module Xianqi where

import Display (boardCanvas)
import Window
import Constants (allLetters, allColumns)
--allLetters is probably better dealt with somewhere where u can reverse their direction

centeredContainer : (Signal  (Position -> Element -> Element))
centeredContainer = lift2 container Window.width Window.height

apply functions c = functions ~ (constant c)

columnForms = flow right <| map asText allColumns
boardWithColumns = lift (\c -> flow down [c, columnForms]) boardCanvas

inMiddle = apply centeredContainer middle
main =  inMiddle ~ boardWithColumns
