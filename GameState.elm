module GameState where
import Model (Color, Red, Black)
import Input
import Mouse

type State = {turn : Color}
initialState = {turn = Red}

whoseTurn state redPos blackPos =  case state.turn of
    Red -> redPos
    Black -> blackPos

unifiedPosition = lift3 whoseTurn gameState Input.redBoardPosition Input.blackBoardPosition

update position state = case state.turn of
    Red -> {turn = Black}
    Black -> {turn = Red}

gameState = foldp update initialState (sampleOn Mouse.clicks unifiedPosition)
