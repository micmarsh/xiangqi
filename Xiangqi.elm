module Xianqi where

import Display (boardCanvas)
import Window

centeredContainer : (Signal  (Position -> Element -> Element))
centeredContainer = lift2 container Window.width Window.height

apply functions c = functions ~ (constant c)

inMiddle = apply centeredContainer middle
main =  inMiddle ~ boardCanvas
