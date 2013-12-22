module Display where
import BoardState (Piece, Red, Black, initialPieces)
import Window
import Mouse

imageFileSize = [669, 749]
imageName = "/board.jpg"


twoThirds : (Int -> Int)
twoThirds x = x - (div x 3)
half x = div x 2

boardSize = map twoThirds imageFileSize

[boardWidth, boardHeight] = boardSize
boardImage = image boardWidth boardHeight imageName

[centerWidth, centerHeight] = map half boardSize

char2Num char = case char of
    'a' -> 0
    'b' -> 1
    'c' -> 2
    'd' -> 3
    'e' -> 4
    'f' -> 5
    'g' -> 6
    'h' -> 7
    'i' -> 8

num2Char num = case num of
    0 -> 'a'
    1 -> 'b'
    2 -> 'c'
    3 -> 'd'
    4 -> 'e'
    5 -> 'f'
    6 -> 'g'
    7 -> 'h'
    8 -> 'i'

squareSize = div boardWidth 8
translate2Pixels : ((Int, Char) -> (Int, Int))
translate2Pixels (row, char) =  let vertIndex = row - 1
                                    horIndex = char2Num char
                                in
                                    (horIndex * squareSize, vertIndex * squareSize)

initialMove (row, col) = ( row - centerWidth, col - centerHeight)
toFloats (row, col) = (toFloat row, toFloat  col)

pieceRadius = ((toFloat boardWidth) / 16) - 5
getColor color = case color of
    Black -> black
    Red -> red
-- TODO: this is going to eventually look up the appropriate image and return
-- a form of said image, like an abstracted baws
renderImage kind player = filled (getColor player) (circle pieceRadius)

makePiece (Piece kind position player) =
    let
        numPosition = translate2Pixels position
        moveTo = ( toFloats . initialMove ) numPosition
    in
        move moveTo <| renderImage kind player

boardPixels (x, y) w h = (x - (w - boardWidth) `div` 2, y - (h - boardHeight) `div` 2)
console = lift3 boardPixels Mouse.position Window.width Window.height

pieces = map makePiece initialPieces

forms = lift (\c -> (toForm boardImage) :: (toForm . asText <| c) :: pieces) console

edgeOffset = 60
collageBounds = collage (boardWidth + edgeOffset) (boardHeight + edgeOffset)
boardCanvas = lift collageBounds forms
