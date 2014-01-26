module Board where
import Model (King, Chariot, Cannon, Horse, Elephant, Advisor, Soldier,
    Piece, Red, Black, Color, allPieces, playerADT)
import Constants (folder, boardWidth, boardHeight, boardImage, squareSize,
    char2Num, centerWidth, centerHeight, imageName, pieceImage)
import Window
import Mouse
import Input

tmap : (a -> b) -> (a, a) -> (b, b)
tmap fn (one, two) =
    (fn one, fn two)
toFloats = tmap toFloat

translate2Pixels : (Char, Int) -> Color -> (Int, Int)
translate2Pixels (char, row) player =
    let vertIndex = row - 1
        horIndex = char2Num char
        defaultHeight = vertIndex * squareSize
        defaultWidth = horIndex * squareSize
    in case player of
        Red -> (defaultWidth, defaultHeight)
        Black -> (boardWidth - defaultWidth, boardHeight - defaultHeight)

initialMove (row, col) = ( row - centerWidth, col - centerHeight)

pieceName kind = case kind of
    King -> "king"
    Soldier -> "soldier"
    Advisor -> "advisor"
    Elephant -> "elephant"
    Cannon -> "cannon"
    Chariot -> "chariot"
    Horse -> "horse"

pieceImage kind color =
    let cfolder = case color of
            Red -> "/red"
            Black -> "/black"
        fullFolder = folder ++ cfolder
        fullPath = fullFolder ++ "/" ++ (pieceName kind) ++ ".png"
    in
        image squareSize squareSize fullPath

pieceRadius = (((toFloat squareSize) / 2)) - 5

makePiece : Piece -> Color -> Form
makePiece (Piece kind position player) you =
    let
        numPosition = translate2Pixels position you
        moveTo = ( toFloats . initialMove ) numPosition
    in
        pieceImage kind player |> toForm |> move moveTo

rmap : [a -> b] -> a -> [b]
rmap functions c = map (\f -> f c) functions

imageWithPieces : [Piece] -> Color -> [Form]
imageWithPieces pieces turn =
    let pieceFns = (map makePiece pieces)
        finalPieces = (rmap pieceFns turn)
    in (toForm boardImage) :: finalPieces

edgeOffset = 60
collageBounds = collage (boardWidth + edgeOffset) (boardHeight + edgeOffset)

makeBoard gameState color =
    let pieces = lift .pieces gameState
        player = lift playerADT color
        realDisplay = lift2 imageWithPieces pieces <| player
    in lift collageBounds realDisplay
