module GameState where
import Model (Color, Red, Black, Position, Piece, allPieces, findPiece, State, Move)
import Moving (makeMove)
import WebSocket (connect)
import Monad (map)
import Http (Success, Waiting, Failure, sendGet)
import Parser
import Input
import Mouse

-- wooooo! this ID should eventually come from
-- a magical custom from-the-dom signal that
-- pulls from the current route
gameId = constant "id123"

playerADT color =
    case color of
        "red" -> Red
        "black" -> Black

playerRequest = sendGet (lift (\id -> "http://localhost:8008/" ++ id) gameId)

parseResponse response =
    case response of
        Success color -> Just color
        Waiting -> Nothing
        Failure code message -> Nothing

playerColor = lift ((map playerADT) . parseResponse) playerRequest

initialState : State
initialState = {turn = Red, pieces = allPieces}

choosePos : Maybe Color -> Position -> Position -> Position
choosePos player redPos blackPos =
    case player of
        Just Red -> redPos
        Just Black -> blackPos
        Nothing -> ('h', 11)

mousePosition : Signal Position
mousePosition = lift3 choosePos playerColor Input.redBoardPosition Input.blackBoardPosition

clickPosition = sampleOn Mouse.clicks mousePosition

updateMove : Position -> Move -> Move
updateMove position (from, to) = (to, position)
initialMove = (('h',11), ('h',11))

moves = foldp updateMove initialMove clickPosition

messageData gameId player =
    "{\"gameId\":\""++gameId++"\",\"player\":\""++player++"\""

serverMoveMessage gameId player moveData =
    let firstPart = messageData gameId player
    in firstPart ++ ",\"message\":"++moveData++"}"

colorString player =
    case player of
        Just Black -> "black"
        Just Red -> "red"
        Nothing -> "none"

movesToCheck = lift3 serverMoveMessage gameId (lift colorString playerColor) <| lift Parser.encodeMove moves

legalMoves = lift Parser.decodeMove <| connect "ws://localhost:8008/move" movesToCheck

toggleTurn turn = case turn of
    Red -> Black
    Black -> Red

update : Maybe Move -> State -> State
update moveOption state =
    case moveOption of
        Nothing -> state
        Just move ->
            let {turn, pieces} = state
                (from, to) = move
                pieceOption = findPiece pieces from
                (moved, newPieces) = makeMove pieceOption pieces to
            in {turn = if moved then toggleTurn turn else turn,
                pieces = newPieces}

gameState : Signal State
gameState = foldp update initialState legalMoves
