module GameState where
import Model (Color, Red, Black, Position, Piece, allPieces, findPiece, State, Move)
import Moving (maybeMove)
import Monad (map)
import Input
import Mouse

initialState : State
initialState = {turn = Red, selected = Nothing, pieces = allPieces}

type Positions = {red: Position, black: Position}
posRecord : Position -> Position -> Positions
posRecord red black = {red = red, black = black}
unifiedPosition : Signal Positions
unifiedPosition = lift2 posRecord Input.redBoardPosition Input.blackBoardPosition

currentPos : Positions -> Color -> Position
currentPos positions turn = case turn of
    Red -> positions.red
    Black -> positions.black

toggleTurn : Color -> Color
toggleTurn turn = case turn of
    Red -> Black
    Black -> Red

update : Positions -> State -> State
update positions {turn, selected, pieces} =
    let position = currentPos positions turn
        option = findPiece pieces position
        (moved, newPieces) = maybeMove selected pieces position
    in {turn = if moved then toggleTurn turn else turn,
        -- shouldn't have anything clicked on for next turn
        selected = if moved then Nothing else option,
        pieces = newPieces}

getMove : Positions -> State -> Maybe Move
getMove positions {turn, selected, pieces} =
    let position = currentPos positions turn
    in map (\(Piece t fromPos c) -> (fromPos, position)) selected

maybeMoves : Signal (Maybe Move)
maybeMoves = foldp getMove initialState (sampleOn Mouse.clicks unifiedPosition)

defaultMove = Just (('a',1), ('i',10))
-- warning, only use get when u know fo shizzle that you'll have a value
get : Maybe a -> a
get option = case option of
    Just value -> value
maybe2Bool option = case option of
    Nothing -> False
    Just thing -> True

moves : Signal Move
moves = keepIf maybe2Bool defaultMove maybeMoves |> lift get

gameState : Signal State
gameState = foldp update initialState (sampleOn Mouse.clicks unifiedPosition)
