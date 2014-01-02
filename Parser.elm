module Parser where
import Model (Color, Black, Red, Piece, State, Position, Move,
    Soldier, Advisor, Elephant, Horse, Cannon, Chariot, King)
import String (cons, toInt, toList, fromList)
import Json (fromString, toJSObject, JsonValue)
import JavaScript.Experimental (toRecord)
import Monad (map)

encodeMove : Move -> String
encodeMove (from, to) =
    let fromStr = pos2String from
        toStr = pos2String to
    in "{\"type\":\"move\",\"from\":\"" ++ fromStr ++ "\",\"to\":\"" ++ toStr ++ "\"}"

decodeMove : String -> Maybe Move
decodeMove str = map object2Move <| fromString str

object2Move : JsonValue -> Move
object2Move json =
    let  jsObj = toJSObject json
         record = toRecord jsObj
         {from, to} = record
         start = string2Pos from
         end = string2Pos to
     in (start, end)

pos2String : Position -> String
pos2String pair =
    let (col, int) = pair
        row = int2Str int
    in cons col <| cons ',' row

chars2Pos : [Char] -> Position
chars2Pos chars =
    let char = head chars
        numStr = (tail . tail) chars |> fromList
        number = case (toInt numStr) of
                    Nothing -> -1
                    Just num -> num
    in (char, number)

string2Pos : String -> Position
string2Pos = chars2Pos . toList

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
