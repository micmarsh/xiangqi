module Display where
import Model (Piece, Red, Black, allPieces, findPiece)
import Constants (boardWidth, boardHeight, boardImage, squareSize, char2Num, centerWidth, centerHeight, imageName)
import GameState (gameState)
import Window
import Mouse
import Input

translate2Pixels : ((Char, Int) -> (Int, Int))
translate2Pixels (char, row) =  let vertIndex = row - 1
                                    horIndex = char2Num char
                                in
                                    (horIndex * squareSize, vertIndex * squareSize)

initialMove (row, col) = ( row - centerWidth, col - centerHeight)
toFloats (fst, snd) = (toFloat fst, toFloat  snd)

-- TODO: this is going to eventually look up the appropriate image and return
-- a form of said image, like an abstracted baws
pieceRadius = (((toFloat squareSize) / 2)) - 5
getColor color = case color of
    Black -> black
    Red -> red
renderImage kind player = filled (getColor player) (circle pieceRadius)

makePiece (Piece kind position player) =
    let
        numPosition = translate2Pixels position
        moveTo = ( toFloats . initialMove ) numPosition
    in
        move moveTo <| renderImage kind player

pieces = map makePiece allPieces

console = gameState

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
