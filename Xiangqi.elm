module Xianqi where
import Constants (allLetters, allColumns)
import Display (boardCanvas)
import Window
--allLetters is probably better dealt with somewhere where u can reverse their direction

centeredContainer : (Signal  (Position -> Element -> Element))
centeredContainer = lift2 container Window.width Window.height

rlift : Signal (a -> b) -> a  -> Signal b
rlift functions c = functions ~ (constant c)


inMiddle = rlift centeredContainer middle
main =  inMiddle ~ boardCanvas
