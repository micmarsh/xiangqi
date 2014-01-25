module Xiangqi where
import Constants (allLetters, allColumns)
--import Board (boardCanvas)
--import Sidebar (sidebar)
import GameState (makeMoves, makeGame)
import Window

port hash : Signal String
port color : Signal String
port history : Signal {from : String, to : String}
port confirmations : Signal {legal : Bool, move : {from : String, to : String}}

inputs = {
        hash = hash,
        color = color,
        history = history,
        confirmations = confirmations
    }

port moves : Signal {from : String, to : String}
port moves = makeMoves inputs

--gameState = makeGame {inputs | moves = moves}


--centeredContainer : (Signal  (Position -> Element -> Element))
--centeredContainer = lift2 container Window.width Window.height

--rlift : Signal (a -> b) -> a  -> Signal b
--rlift functions c = functions ~ (constant c)

--toDisplay = lift2 (\board sidebar -> flow right [board, sidebar]) boardCanvas sidebar

--inMiddle = rlift centeredContainer middle
main = lift asText moves--inMiddle ~ toDisplay
