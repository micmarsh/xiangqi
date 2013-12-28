module Input (redBoardPosition, blackBoardPosition) where
import Constants (boardWidth, boardHeight, squareSize, num2Char)
import BoardState (Black, Red)
import Mouse
import Window

toBoardPixels (x, y) w h = let yToBoard = (h - boardHeight) `div` 2
                               xToBoard = (w - boardWidth) `div` 2
                           in (x - xToBoard, y - yToBoard)
boardPixels = lift3 toBoardPixels Mouse.position Window.width Window.height

heightOffset = 12
widthOffset = 20

toBoardRow player pixels = case player of
                            Red -> let newHeight = boardHeight + heightOffset
                                       converted = newHeight - pixels
                                   in (div converted squareSize) + 1
                            Black -> let blackOffset = heightOffset * 2
                                         newPixels = pixels + blackOffset
                                     in (div newPixels squareSize) + 1
                        -- TODO these both need to be shifted a little bit in their respective directions,
                        -- for more accuracy as to what you're actually pressing
toBoardColumn player pixels = case player of
                            Red -> num2Char <| div (pixels + widthOffset) squareSize
                            Black -> let newWidth = boardWidth + widthOffset
                                         converted = newWidth - pixels
                                     in num2Char <| div converted squareSize

toBoardPosition player (x, y) = (toBoardColumn player x, toBoardRow player y)

redBoardPosition = lift (toBoardPosition Red) boardPixels
blackBoardPosition = lift (toBoardPosition Black) boardPixels
