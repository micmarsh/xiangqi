module GameState where
import Model (Color, Red, Black, Position, Piece, allPieces, findPiece, State, Move)
import Moving (makeMove)
import WebSocket (connect)
import Monad (map)
import Parser
import Input
import Mouse

-- wooooo! this ID should eventually come from
-- a magical custom from-the-dom signal that
-- pulls from the current route
gameId = constant "yoyoyoId"

playerADT color =
    case color of
        "red" -> Red
        "black" -> Black
        _ -> Red

messageData gameId player =
    "{\"gameId\":\""++gameId++"\",\"player\":\""++player++"\""
idWithData = lift2 (\g p -> (messageData g p) ++ "}") gameId (constant "red")

playerColor = lift playerADT <| connect "ws://localhost:8008/register" idWithData

initialState : State
initialState = {turn = Red, pieces = allPieces}

choosePos : Color -> Position -> Position -> Position
choosePos player redPos blackPos =
    case player of
        Red -> redPos
        Black -> blackPos

mousePosition : Signal Position
mousePosition = lift3 choosePos playerColor Input.redBoardPosition Input.blackBoardPosition

clickPosition = sampleOn Mouse.clicks mousePosition

updateMove : Position -> Move -> Move
updateMove position (from, to) = (to, position)
initialMove = (('h',11), ('h',11))

moves = foldp updateMove initialMove clickPosition

serverMoveMessage gameId player moveData =
    let firstPart = messageData gameId player
    in firstPart ++ ",\"message\":"++moveData++"}"

colorString player =
    case player of
        Black -> "black"
        Red -> "red"

movesToCheck = lift3 serverMoveMessage gameId (lift colorString playerColor) <| lift Parser.encodeMove moves

serverLocation = "ws://localhost:8008/move"

legalMoves = lift Parser.decodeMove <| connect serverLocation movesToCheck

toggleTurn : Color -> Color
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
