module GameState where
import Model (Color, Red, Black, Position, Piece, allPieces, findPiece, State, Move)
import Moving (makeMove)
import WebSocket (connect)
import Monad (map)
import Http (Success, Waiting, Failure, sendGet)
import JavaScript as J
import Parser (pos2String)
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

stail : String -> String
stail = String.fromList . tail . String.toList

encodeMove (from, to) =
    {from = pos2String from, to = pos2String to}

makeMoves {color} =
    let playerColor = lift playerADT color
        mousePosition = lift3 choosePos playerColor Input.redBoardPosition Input.blackBoardPosition
        clickPosition = sampleOn Mouse.clicks mousePosition
        boardMoves = foldp updateMove initialMove clickPosition
    in lift encodeMove boardMoves

colorString : Maybe Color -> String
colorString player =
    case player of
        Just Black -> "black"
        Just Red -> "red"
        Nothing -> "none"

--playerString = lift colorString playerColor
--movesToCheck = lift3 serverMoveMessage gameId playerString <| lift Parser.encodeMove moves

--allMoves = lift Parser.decodeMove (constant "")

--isLegal : Maybe Piece -> Parser.Metadata -> Bool
--isLegal piece {player} =
--    case piece of
--        Nothing -> False
--        (Just (Piece t p color)) -> color == playerADT player

--toggleTurn turn = case turn of
--    Red -> Black
--    Black -> Red

--selectPiece : State -> Position -> State
--selectPiece state clickPos = { state |
--        selected <- if state.moved then Nothing
--                    else findPiece state.pieces clickPos
--    }

--handleLegalMove : State -> (Move, Parser.Metadata) -> State
--handleLegalMove state (move, mData) =
--  let {turn, pieces} = state
--      (from, to) = move
--      mightMove = findPiece pieces from
--      moved = isLegal mightMove mData
--    in if not moved then { state | moved <- False}
--        else {turn = toggleTurn turn,
--              pieces = makeMove mightMove pieces to,
--              selected = Nothing,
--              moved = True}

--update : Maybe (Move, Parser.Metadata) -> State -> State
--update moveOption state =
--    case moveOption of
--        Nothing -> state
--        Just move -> handleLegalMove state move

--onlyMoves : Signal State
--onlyMoves = foldp update initialState allMoves

gameState : Signal State
gameState = (constant initialState)--lift2 selectPiece onlyMoves clickPosition
