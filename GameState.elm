module GameState where
import Model (Color, Red, Black, Position, Piece, allPieces, findPiece)
import Input
import Mouse

type State = {turn : Color, selected: Maybe Piece, pieces: [Piece]}
initialState = {turn = Red, selected = Nothing, pieces = allPieces}

type Positions = {red: Position, black: Position}
posRecord red black = {red = red, black = black}
unifiedPosition = lift2 posRecord Input.redBoardPosition Input.blackBoardPosition

currentPos positions turn = case turn of
    Red -> positions.red
    Black -> positions.black

update positions {turn, selected, pieces} =
    let position = currentPos positions turn
        piece = findPiece pieces position
    in {turn = turn, selected = piece, pieces = pieces}

gameState = foldp update initialState (sampleOn Mouse.clicks unifiedPosition)
