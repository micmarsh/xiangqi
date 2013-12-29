module GameState where
import Model (Color, Red, Black, Position, Piece, allPieces, findPiece, State)
import Logic (maybeMove)
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

gameState : Signal State
gameState = foldp update initialState (sampleOn Mouse.clicks unifiedPosition)
