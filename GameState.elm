module GameState where
import Model (Color, Red, Black, Position, Piece,
    allPieces, findPiece, State, Move, playerADT, Check, CheckMate)
import Moving (makeMove)
import Monad (map)
import Http (Success, Waiting, Failure, sendGet)
import JavaScript as J
import Parser (pos2String, decodeMove)
import Input
import Mouse
import String

initialState : State
initialState = {turn = Red, pieces = allPieces, selected = Nothing, moved = False, check = Nothing}

choosePos : Color -> Position -> Position -> Position
choosePos player redPos blackPos =
    case player of
        Red -> redPos
        Black -> blackPos

updateMove : Position -> Move -> Move
updateMove position (from, to) = (to, position)
initialMove = (('h',11), ('h',11))
initialConfirmation = {legal = False, move = encodeMove initialMove}

stail : String -> String
stail = String.fromList . tail . String.toList

encodeMove (from, to) =
    {from = pos2String from, to = pos2String to}

makeClicks color =
    let playerColor = lift playerADT color
        mousePosition = lift3 choosePos playerColor Input.redBoardPosition Input.blackBoardPosition
    in sampleOn Mouse.clicks mousePosition

makeMoves {color} =
    let clickPosition = makeClicks color
        boardMoves = foldp updateMove initialMove clickPosition
    in lift encodeMove boardMoves

selectPiece state clickPos = { state |
    selected <- if state.moved then Nothing
                else findPiece state.pieces clickPos
    }

handleLegalMove  {move, legal} state =
  let {turn, pieces} = state
      (from, to) = move
      mightMove = findPiece pieces from
    in if not legal then { state | moved <- False}
        else {turn = toggleTurn turn,
              pieces = makeMove mightMove pieces to,
              selected = Nothing,
              moved = True}

type ParsedMove = {legal: Bool, move: {from:String, to:String}}
convertMoveRecord : ParsedMove -> {legal:Bool, move: Move}
convertMoveRecord confirm = {confirm |
        move <- decodeMove confirm.move
    }

toggleTurn turn = case turn of
    Red -> Black
    Black -> Red

calculateCheck state {check, mate, inCheck} =
    let color = playerADT inCheck 
    in if mate then Just (CheckMate color)
       else if check then Just (Check color)
       else Nothing 

addCheckToState state check = {state |
        check <- calculateCheck state check
    }

makeGame {color, moves, checkStatus} =
    let boardMoves = lift convertMoveRecord moves
        onlyMoves = foldp handleLegalMove initialState boardMoves
        clickPosition = makeClicks color
        withSelected = lift2 selectPiece onlyMoves clickPosition
    in lift2 addCheckToState withSelected checkStatus

