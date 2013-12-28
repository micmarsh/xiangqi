module BoardState where
import Constants (allLetters, soldierLetters)

data Type = Soldier Bool |
            Advisor |
            Elephant |
            Horse |
            Cannon |
            Chariot |
            King

type Position = (Char, Int)
data Color = Red | Black
data Piece = Piece Type Position Color

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

initialPieces = concat [redPieces, blackPieces]
