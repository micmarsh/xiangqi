module Display where
import BoardState (Piece, Red, Black, initialPieces)
import String (indices)

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

squareSize = div boardWidth 8
translate : ((Int, Char) -> (Int, Int))
translate (row, char) = let vertIndex = row - 1
                            horIndex = char2Num char
                        in
                            (horIndex * squareSize, vertIndex * squareSize)

initialMove (row, col) = ( row - centerWidth, col - centerHeight)
toFloats (row, col) = (toFloat row, toFloat  col)

pieceRadius = ((toFloat boardWidth) / 16) - 5
getColor color = case color of
    Black -> black
    Red -> red
renderImage kind player = filled (getColor player) (circle pieceRadius)

makePiece (Piece kind position player) =
    let
        numPosition = translate position
        moveTo = toFloats <| initialMove numPosition
    in
        move moveTo <| renderImage kind player
        -- Damn it, move is also wrong wrong wrong. Another PR?

console = move (1,0) <| toForm <| asText <| length initialPieces

pieces = map makePiece initialPieces
forms =  (toForm boardImage) :: console :: pieces

edgeOffset = 500
boardCanvas = collage (boardWidth + edgeOffset) (boardHeight + edgeOffset) forms
