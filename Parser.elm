module Parser where
import Model (Black, Red, Piece, State)

gameState2Json : State -> {turn : String, selected: [String], pieces: [[String]]}
gameState2Json {turn, selected, pieces} =
    let strTurn = case turn of
            Black -> "Black"
            Red -> "Red"
        strSelect = option2Json selected
    in {turn = strTurn, selected = strSelect, pieces = [["pieces"]]}

option2Json : Maybe Piece -> [String]
option2Json option = case option of
    Nothing -> []
    Just piece -> piece2Json piece

piece2Json : Piece -> [String]
piece2Json piece = ["piece"]

