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

-- TODO you have two streams one of fns to apply to the other of elements
-- simple enough, but something's off here, so windowCentered is probably going to
-- need to take on a new form. That curry chain is actually kind of confusing, need to figure
-- out a clean way of doing that kind of thing

applyToElt fn elt = fn elt
main = lift2  applyToElt centeredContainer boardCanvas
