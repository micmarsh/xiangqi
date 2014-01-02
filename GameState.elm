module GameState where
import Model (Color, Red, Black, Position, Piece, allPieces, findPiece, State, Move)
import Moving (maybeMove)
import WebSocket (connect)
import Monad (map)
import Parser
import Input
import Mouse

initialState : State
initialState = {turn = Red, selected = Nothing, pieces = allPieces}

type Positions = {red: Position, black: Position}
posRecord : Position -> Position -> Positions
posRecord red black = {red = red, black = black}
unifiedPosition : Signal Positions
unifiedPosition = lift2 posRecord Input.redBoardPosition Input.blackBoardPosition

currentPos : Positions -> Color -> Position
currentPos positions turn = case turn of
    Red -> positions.red
    Black -> positions.black

toggleTurn : Color -> Color
toggleTurn turn = case turn of
    Red -> Black
    Black -> Red

update : Positions -> State -> State
update positions {turn, selected, pieces} =
    let position = currentPos positions turn
        option = findPiece pieces position
        (moved, newPieces) = maybeMove selected pieces position
    in {turn = if moved then toggleTurn turn else turn,
        -- shouldn't have anything clicked on for next turn
        selected = if moved then Nothing else option,
        pieces = newPieces}

getMove : Positions -> (Maybe Move, State) -> (Maybe Move, State)
getMove positions (oldMove, gameState) =
    let {selected, turn} = gameState
        position = currentPos positions turn
        newMove = map (\(Piece t fromPos c) -> (fromPos, position)) selected
    in (newMove, gameState)

-- the sample on clicks should merge with sockets, so both can do stuff. Need to mod uni-pos again, then
maybeMoves : Signal (Maybe Move, State)
maybeMoves = foldp getMove (Nothing, initialState) (sampleOn Mouse.clicks unifiedPosition)

encodeMove : Maybe Move -> Maybe String
encodeMove option = map Parser.encodeMove option

gameState : Signal State
gameState = foldp update initialState (sampleOn Mouse.clicks unifiedPosition)
