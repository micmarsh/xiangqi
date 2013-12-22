module BoardState where
import Constants (allLetters, soldierLetters)

data Type = Soldier Bool |
            Advisor |
            Elephant |
            Horse |
            Cannon |
            Chariot |
            King

type Position = (Int, Char) -- TODO: this should be board-based
data Color = Red | Black
data Piece = Piece Type Position Color

soldier char = Piece (Soldier False) (4, char) Red
soldiers = map soldier soldierLetters
cannons = map (\c -> Piece Cannon (3, c) Red) ['b', 'h']

typeOrder = [Chariot, Horse, Elephant, Advisor]
fullTypes =  concat [typeOrder, (King :: (reverse typeOrder))]
typesWithChars = zip fullTypes allLetters
piece (kind, char) = Piece kind (1, char) Red
rest = map piece typesWithChars

redPieces = concat [soldiers, cannons, rest]

makeBlack (Piece kind (row, col) c) = Piece kind (11 - row, col) Black
blackPieces = map makeBlack redPieces

initialPieces = concat [redPieces, blackPieces]
