module GameState where
import Model (Color, Red, Black, Position, Piece, allPieces, findPiece, State, Move)
import Moving (makeMove)
import WebSocket (connect)
import Monad (map)
import Http (Success, Waiting, Failure, sendGet)
import Parser
import Input
import Mouse
import String


-- wooooo! this ID should eventually come from
-- a magical custom from-the-dom signal that
-- pulls from the current route
gameId = lift (String.fromList . tail . String.toList) Input.urlHash

playerADT color =
    case color of
        "red" -> Red
        "black" -> Black
        _ -> Red

-- TODO this shit can totally be part of a more general "url" signal that
-- you prtovide, that we can derive ID from as well, once u get a sflatten type thing
heroku = False
serverName = if heroku then "glacial-island-4986.herokuapp.com" else "localhost:8008"
server = "://"++serverName++"/"
http = "http" ++ if heroku then "s" else ""

playerRequest = sendGet (lift (\id -> http ++ server ++ id) gameId)

parseResponse response =
    case response of
        Success color -> Just color
        Waiting -> Nothing
        Failure code message -> Nothing

playerColor = lift ((map playerADT) . parseResponse) playerRequest

initialState : State
initialState = {turn = Red, pieces = allPieces, selected = Nothing}

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

colorString player =
    case player of
        Just Black -> "black"
        Just Red -> "red"
        Nothing -> "none"

movesToCheck = lift3 serverMoveMessage gameId (lift colorString playerColor) <| lift Parser.encodeMove moves

allMoves = lift Parser.decodeMove <| connect ("ws" ++ server ++ "move") movesToCheck

isLegal : Maybe Piece -> Parser.Metadata -> Bool
isLegal piece {player} =
    case piece of
        Nothing -> False
        (Just (Piece t p color)) -> color == playerADT player

toggleTurn turn = case turn of
    Red -> Black
    Black -> Red

selectPiece : State -> Position -> State
selectPiece state clickPos =
    let {pieces} = state
    in {state |
        selected = findPiece pieces clickPos
    }

handleLegalMove : State -> (Move, Parser.Metadata) -> State
handleLegalMove state (move, mData) =
  let {turn, pieces} = state
      (from, to) = move
      mightMove = findPiece pieces from
      moved = isLegal mightMove mData
    in if not moved then state
        else {turn = toggleTurn turn,
              pieces = makeMove mightMove pieces to,
              selected = Nothing}

update : (Maybe (Move, Parser.Metadata), Position) -> State -> State
update (moveOption, clickPos) state =
    case moveOption of
        Nothing -> selectPiece state clickPos
        Just move -> handleLegalMove state move

gameState : Signal State
gameState = foldp update initialState <| lift2 (,) allMoves clickPosition
