module Parser where
import Model (Color, Black, Red, Piece, State, Position, Move,
    Soldier, Advisor, Elephant, Horse, Cannon, Chariot, King)
import String (cons, toInt, toList, fromList)
import Json (fromString, toJSObject, JsonValue)
import JavaScript.Experimental (toRecord)
import Constants (char2Num, num2Char)
import Monad (map)

type Metadata = {gameId : String, player: String}

decodeMove message =
    let  {from, to} = message
         start = string2Pos from
         end = string2Pos to
     in (start, end)

pos2String : Position -> String
pos2String pair =
    let (col, int) = pair
        row = int2Str (int - 1)
        intCol = (int2Str . char2Num) col
    in (++) intCol <| cons ',' row

unpack option =
    case option of
        Nothing -> -1
        Just num -> num

chars2Pos : [Char] -> Position
chars2Pos chars =
    let colStr = take 1 chars |> fromList
        col = unpack <| toInt colStr
        char = num2Char col
        numStr = drop 2 chars |> fromList
        number = unpack <| toInt numStr
    in (char, number + 1)

string2Pos : String -> Position
string2Pos = chars2Pos . toList

int2Str : Int -> String
int2Str int =
    case int of
        0 -> "0"
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
        _ -> "11"

piece2List : Piece -> [String]
piece2List (Piece kind position player) =
    let strType = type2String kind
        strPos = pos2String position
        strColor = encodeColor player
    in [strType, strPos, strColor]

type2String adt =
    case adt of
        Soldier -> "Soldier"
        Advisor -> "Advisor"
        Elephant -> "Elephant"
        Horse -> "Horse"
        Cannon -> "Cannon"
        Chariot -> "Chariot"
        King -> "King"

encodeColor color =
    case color of
        Black -> "black"
        Red -> "red"
