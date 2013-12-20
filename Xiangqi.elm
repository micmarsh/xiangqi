module Xianqi where

import Display (boardCanvas)
import Window

centeredContainer : (Signal  (Position -> Element -> Element))
centeredContainer = lift2 container Window.width Window.height

applyTwoArgs : (a -> b -> (a -> b -> c) -> c)
applyTwoArgs arg1 arg2 function = function arg1 arg2
applyArg : (a -> (a -> b) -> b)
applyArg arg function = function arg

applyToMiddle = applyTwoArgs middle

windowCentered element = lift (applyToMiddle element) centeredContainer

main = windowCentered boardCanvas
