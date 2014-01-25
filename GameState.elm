module GameState where
import Model (Color, Red, Black, Position, Piece, allPieces, findPiece, State, Move)
import Moving (makeMove)
import WebSocket (connect)
import Monad (map)
import Http (Success, Waiting, Failure, sendGet)
import JavaScript as J
import Parser
import Input
import Mouse
import String

gameId = lift (String.fromList . tail . String.toList) Input.urlHash

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

playerColor = constant (Just Red) --lift ((map playerADT) . parseResponse) playerRequest

initialState : State
initialState = {turn = Red, pieces = allPieces, selected = Nothing, moved = False}

choosePos : Maybe Color -> Position -> Position -> Position
choosePos player redPos blackPos =
    case player of
        Just Red -> redPos
        Just Black -> blackPos
        Nothing -> ('h', 11)

mousePosition : Signal Position
mousePosition = lift3 choosePos playerColor Input.redBoardPosition Input.blackBoardPosition

clickPosition = sampleOn Mouse.clicks mousePosition

updateMove : Position -> Move -> Move
updateMove position (from, to) = (to, position)
initialMove = (('h',11), ('h',11))

moves = foldp updateMove initialMove clickPosition

messageData gameId player =
    "{\"gameId\":\""++gameId++"\",\"player\":\""++player++"\""

serverMoveMessage gameId player moveData =
    let firstPart = messageData gameId player
    in firstPart ++ ",\"message\":"++moveData++"}"

colorString : Maybe Color -> String
colorString player =
    case player of
        Just Black -> "black"
        Just Red -> "red"
        Nothing -> "none"

playerString = lift colorString playerColor
movesToCheck = lift3 serverMoveMessage gameId playerString <| lift Parser.encodeMove moves
--socketConnection = connect ("ws" ++ server ++ "move") movesToCheck

--makeSocketUrl server id color = "ws" ++ server ++ "move/" ++ id ++ "/" ++ color
--socketUrl = lift3 makeSocketUrl server gameId playerString
--outGoingMessages = lift J.fromString <| lift2 (\url message -> url ++ "|" ++ message) socketUrl movesToCheck

--foreign export jsevent "toWebsocket"
--    outGoingMessages : Signal J.JSString

--socketConnection = Input.incomingMessages

allMoves = lift Parser.decodeMove (constant "")

isLegal : Maybe Piece -> Parser.Metadata -> Bool
isLegal piece {player} =
    case piece of
        Nothing -> False
        (Just (Piece t p color)) -> color == playerADT player

toggleTurn turn = case turn of
    Red -> Black
    Black -> Red

selectPiece : State -> Position -> State
selectPiece state clickPos = { state |
        selected <- if state.moved then Nothing
                    else findPiece state.pieces clickPos
    }

handleLegalMove : State -> (Move, Parser.Metadata) -> State
handleLegalMove state (move, mData) =
  let {turn, pieces} = state
      (from, to) = move
      mightMove = findPiece pieces from
      moved = isLegal mightMove mData
    in if not moved then { state | moved <- False}
        else {turn = toggleTurn turn,
              pieces = makeMove mightMove pieces to,
              selected = Nothing,
              moved = True}

update : Maybe (Move, Parser.Metadata) -> State -> State
update moveOption state =
    case moveOption of
        Nothing -> state
        Just move -> handleLegalMove state move

onlyMoves : Signal State
onlyMoves = foldp update initialState allMoves

gameState : Signal State
gameState = lift2 selectPiece onlyMoves clickPosition
