module Display where
import Model (King, Chariot, Cannon, Horse, Elephant, Advisor, Soldier,
    Piece, Red, Black, Color, allPieces)
import Constants (folder, boardWidth, boardHeight, boardImage, squareSize,
    char2Num, centerWidth, centerHeight, imageName, pieceImage)
import GameState (gameState, playerColor, socketConnection)
import Window
import Mouse
import Input

tmap : (a -> b) -> (a, a) -> (b, b)
tmap fn (one, two) =
    (fn one, fn two)
toFloats = tmap toFloat

translate2Pixels : (Char, Int) -> Maybe Color -> (Int, Int)
translate2Pixels (char, row) turn =
    let vertIndex = row - 1
        horIndex = char2Num char
        defaultHeight = vertIndex * squareSize
        defaultWidth = horIndex * squareSize
    in case turn of
        Nothing -> (defaultWidth, defaultHeight)
        Just Red -> (defaultWidth, defaultHeight)
        Just Black -> (boardWidth - defaultWidth, boardHeight - defaultHeight)

initialMove (row, col) = ( row - centerWidth, col - centerHeight)

pieceName kind = case kind of
    King -> "king"
    (Soldier b) -> "soldier"
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

makePiece : Piece -> Maybe Color -> Form
makePiece (Piece kind position player) turn =
    let
        numPosition = translate2Pixels position turn
        moveTo = ( toFloats . initialMove ) numPosition
    in
        pieceImage kind player |> toForm |> move moveTo

pieces = lift .pieces gameState

console = lift .selected gameState

rmap : [a -> b] -> a -> [b]
rmap functions c = map (\f -> f c) functions

imageWithPieces : [Piece] -> Maybe Color -> [Form]
imageWithPieces pieces turn =
    let pieceFns = (map makePiece pieces)
        finalPieces = (rmap pieceFns turn)
    in (toForm boardImage) :: finalPieces

realDisplay = lift2 imageWithPieces pieces <| playerColor

displayConsole output display =
            let board = head display
                pieces = tail display
                -- wtf Y NO destructuring?
                form = toForm . asText <| output
            in board :: form :: pieces

forms = lift2 displayConsole console realDisplay

edgeOffset = 60
collageBounds = collage (boardWidth + edgeOffset) (boardHeight + edgeOffset)
boardCanvas = lift collageBounds forms
