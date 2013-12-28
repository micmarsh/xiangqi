module Display where
import Model (Piece, Red, Black, Color, allPieces)
import Constants (boardWidth, boardHeight, boardImage, squareSize, char2Num, centerWidth, centerHeight, imageName)
import GameState (gameState)
import Window
import Mouse
import Input

tmap : (a -> b) -> (a, a) -> (b, b)
tmap fn (one, two) =
    (fn one, fn two)
toFloats = tmap toFloat

translate2Pixels : (Char, Int) -> Color -> (Int, Int)
translate2Pixels (char, row) turn =
    let vertIndex = row - 1
        horIndex = char2Num char
        defaultHeight = vertIndex * squareSize
        defaultWidth = horIndex * squareSize
    in case turn of
        Red -> (defaultWidth, defaultHeight)
        Black -> (boardWidth - defaultWidth, boardHeight - defaultHeight)

initialMove (row, col) = ( row - centerWidth, col - centerHeight)

-- TODO: this is going to eventually look up the appropriate image and return
-- a form of said image, like an abstracted baws
pieceRadius = (((toFloat squareSize) / 2)) - 5
getColor color = case color of
    Black -> black
    Red -> red
renderImage kind player = filled (getColor player) (circle pieceRadius)

makePiece : Piece -> Color -> Form
makePiece (Piece kind position player) turn =
    let
        numPosition = translate2Pixels position turn
        moveTo = ( toFloats . initialMove ) numPosition
    in
        move moveTo <| renderImage kind player

pieces = lift .pieces gameState

console = lift .selected gameState

rmap : [a -> b] -> a -> [b]
rmap functions c =
    map (\f -> f c) functions

imageWithPieces pieces turn =
    let pieceFns = (map makePiece pieces)
        finalPieces = (rmap pieceFns turn)
    in (toForm boardImage) :: finalPieces

realDisplay = lift2 imageWithPieces pieces <| .turn <~ gameState

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
