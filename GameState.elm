module GameState where
import Model (Color, Red, Black, Position, Piece, allPieces, findPiece, State, Move)
import Moving (makeMove)
import WebSocket (connect)
import Monad (map)
import Parser
import Input
import Mouse

-- wooooo! this signal will either be somehting "unsafe" OR
-- just a straight signal to a "/register", get a color assignment
-- and Id, homie
playerInfo = constant (Red, "yoyoyoId")

playerColor = lift fst playerInfo
gameId = lift snd playerInfo

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

serverMoveMessage gameId moveData =
    "{\"gameId\":\""++gameId++"\",\"message\":\""++moveData++"\"}"

movesToCheck = lift2 serverMoveMessage gameId <| lift Parser.encodeMove moves

serverLocation = "ws://localhost:8000/move"

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
