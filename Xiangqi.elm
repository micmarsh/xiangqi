module Xiangqi where
import Constants (allLetters, allColumns)
import Board (boardCanvas)
import Sidebar (sidebar)
import Window


centeredContainer : (Signal  (Position -> Element -> Element))
centeredContainer = lift2 container Window.width Window.height

rlift : Signal (a -> b) -> a  -> Signal b
rlift functions c = functions ~ (constant c)

toDisplay = lift2 (\board sidebar -> flow right [board, sidebar]) boardCanvas sidebar

inMiddle = rlift centeredContainer middle
main =  inMiddle ~ toDisplay
