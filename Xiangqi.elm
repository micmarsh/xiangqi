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

-- TODO you've got lift which is basically 'map' for signals, but need a reversed lift that will let
-- you make a stream out of a stream of functions and a constant
-- pretty lift (~) looks like what u need call it apply:
apply functions c = (~) functions (constant c)

withMiddle = apply centeredContainer middle
main = (~)  withMiddle boardCanvas
