module GameState where
import Model (Color, Red, Black, Position, Piece, allPieces, findPiece, State, Move)
import Moving (makeMove)
import Monad (map)
import Http (Success, Waiting, Failure, sendGet)
import JavaScript as J
import Parser (pos2String, decodeMove)
import Input
import Mouse
import String


playerADT color =
    case color of
        "red" -> Red
        "black" -> Black
        _ -> Red

--playerRequest = sendGet (lift3 (\http server id -> http ++ server ++ id) http server gameId)

--parseResponse response =
--    case response of
--        Success color -> Just color
--        Waiting -> Nothing
--        Failure code message -> Nothing


initialState : State
initialState = {turn = Red, pieces = allPieces, selected = Nothing, moved = False}

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

convertMoveRecord confirm = {confirm |
        move <- decodeMove confirm.move
    }

toggleTurn turn = case turn of
    Red -> Black
    Black -> Red

makeGame {color, confirmations} =
    let moves = lift convertMoveRecord confirmations
        onlyMoves = foldp handleLegalMove initialState moves
        clickPosition = makeClicks color
    in lift2 selectPiece onlyMoves clickPosition

