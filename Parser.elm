module Parser where
import Model (Color, Black, Red, Piece, State, Position,
    Soldier, Advisor, Elephant, Horse, Cannon, Chariot, King)
import String (cons)
import Json (toString, fromJSObject)
import JavaScript.Experimental (fromRecord)

-- encodeGameState : State -> String
encodeGameState = (toString " ") . fromJSObject . fromRecord . gameState2Record

gameState2Record : State -> {turn : String, selected: [String], pieces: [[String]]}
gameState2Record {turn, selected, pieces} =
    let strTurn = encodeColor turn
        strSelect = option2Record selected
        strPieces = map piece2Record pieces
    in {turn = strTurn, selected = strSelect, pieces = strPieces}

encodeColor color =
    case color of
        Black -> "Black"
        Red -> "Red"

option2Record : Maybe Piece -> [String]
option2Record option = case option of
    Nothing -> []
    Just piece -> piece2Record piece

piece2Record : Piece -> [String]
piece2Record (Piece kind position player) =
    let strType = type2String kind
        strPos = pos2String position
        strColor = encodeColor player
    in [strType, strPos, strColor]

pos2String : Position -> String
pos2String pair =
    let (col, int) = pair
        row = int2Str int
    in (cons col (cons ','  row))

int2Str : Int -> String
int2Str int =
    case int of
        1 -> "1"
        2 -> "2"
        3 -> "3"
        4 -> "4"
        5 -> "5"
        6 -> "6"
        7 -> "7"
        8 -> "8"
        9 -> "9"
        10 -> "10"

type2String adt =
    case adt of
        (Soldier bool) -> "Soldier|" ++ if bool then "True" else "False"
        Advisor -> "Advisor"
        Elephant -> "Elephant"
        Horse -> "Horse"
        Cannon -> "Cannon"
        Chariot -> "Chariot"
        King -> "King"
