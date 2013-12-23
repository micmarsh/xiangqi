module Display where
import BoardState (Piece, Red, Black, initialPieces)
import Constants (boardWidth, boardHeight, boardImage, squareSize, char2Num, centerWidth, centerHeight, imageName)
import Window
import Mouse
import Input

translate2Pixels : ((Int, Char) -> (Int, Int))
translate2Pixels (row, char) =  let vertIndex = row - 1
                                    horIndex = char2Num char
                                in
                                    (horIndex * squareSize, vertIndex * squareSize)

initialMove (row, col) = ( row - centerWidth, col - centerHeight)
toFloats (row, col) = (toFloat row, toFloat  col)

pieceRadius = (((toFloat squareSize) / 2)) - 5
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

pieces = map makePiece initialPieces

console = Input.boardPixels

realDisplay = (toForm boardImage) :: pieces

displayConsole output = let board = head realDisplay
                            pieces = tail realDisplay
                            -- wtf Y NO destructuring?
                            form = toForm . asText <| output
                        in board :: form :: pieces

forms = lift displayConsole console

edgeOffset = 60
collageBounds = collage (boardWidth + edgeOffset) (boardHeight + edgeOffset)
boardCanvas = lift collageBounds forms
