module Xiangqi where
import Constants (allLetters, allColumns)
import GameState (makeMoves, makeGame)
import Parser (piece2List, encodeColor)
import Board (makeBoard)
import Sidebar (makeSideBar)
import Window

port color : Signal String
port inMoves : Signal {legal: Bool, move: {from: String, to: String}}
port connected : Signal Bool
port check : Signal {check: Bool, mate: Bool, checker: String}

stateInputs = {
        color = color,
        moves = inMoves,
        checkStatus = check
    }

port outMoves : Signal {from : String, to : String}
port outMoves = makeMoves inputs

gameState = makeGame stateInputs

pieces2List = map piece2List
pieces = lift (pieces2List . .pieces) gameState
turn = lift (encodeColor . .turn) gameState

port state : Signal {pieces : [[String]], turn : String}
port state = lift2 (\p t -> {pieces = p, turn = t}) pieces turn

centeredContainer : (Signal  (Position -> Element -> Element))
centeredContainer = lift2 container Window.width Window.height

rlift : Signal (a -> b) -> a  -> Signal b
rlift functions c = functions ~ (constant c)

uiInputs = {
        gameState = gameState,
        color = color, 
        connected = connected
    }

boardCanvas = makeBoard uiInputs

sidebar = makeSideBar uiInputs

toDisplay = lift2 (\board sidebar -> flow right [board, sidebar]) boardCanvas sidebar

inMiddle : Signal (Element -> Element)
inMiddle = rlift centeredContainer middle

main = inMiddle ~ toDisplay--lift asText <| lift2 (,) outMoves gameState
