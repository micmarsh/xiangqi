module Model where
import Constants (allLetters, soldierLetters)

data Type = Soldier Bool |
            Advisor |
            Elephant |
            Horse |
            Cannon |
            Chariot |
            King

type Position = (Char, Int)
type Move = (Position, Position)
data Color = Red | Black
data Piece = Piece Type Position Color

type State = {turn : Color, pieces : [Piece], selected: Maybe Piece, moved: Bool}

soldier char = Piece (Soldier False) (char, 4) Red
soldiers = map soldier soldierLetters
cannons = map (\c -> Piece Cannon (c, 3) Red) ['b', 'h']

typeOrder = [Chariot, Horse, Elephant, Advisor]
fullTypes =  concat [typeOrder, (King :: (reverse typeOrder))]
typesWithChars = zip fullTypes allLetters
piece (kind, char) = Piece kind (char, 1) Red
rest = map piece typesWithChars

redPieces = concat [soldiers, cannons, rest]

makeBlack (Piece kind (col, row) c) = Piece kind (col, 11 - row) Black
blackPieces = map makeBlack redPieces

allPieces = concat [redPieces, blackPieces]

findPiece : [Piece] -> Position -> Maybe Piece
findPiece pieces position =
    case pieces of
        [] -> Nothing
        (Piece t p c) :: rest ->
            -- destructuring in lets is broken as poop, pull down fix sometime
            if (position == p) then Just (Piece t p c)
            else findPiece rest position

playerADT color =
    case color of
        "red" -> Red
        "black" -> Black
        _ -> Red
