module Logic (maybeMove) where
import Model (Piece, Position, findPiece)

type MoveCheck = (Piece, [Piece], Position)
type MoveResult = (Bool, [Piece])
--this is going to have some real logic in it at some point
moveIsLegal : MoveCheck -> Bool
moveIsLegal (piece, pieces, position) = True

remove : [a] -> a -> [a]
remove list element = filter (\e -> not <| e == element) list

-- really need let destructures
move : MoveCheck -> MoveResult
move ((Piece t oldPos c), pieces, position) =
    let removeOld = remove pieces (Piece t oldPos c)
        newPiece = Piece t position c
        option = findPiece removeOld position
        removeCaptured = case option of
            Nothing -> removeOld
            (Just captured) -> remove removeOld captured
    in (True, newPiece :: removeCaptured)


maybeMove : Maybe Piece -> [Piece] -> Position -> MoveResult
maybeMove option pieces position =
    case option of
        Nothing -> (False, pieces)
        (Just piece) ->
            let checker = (piece, pieces, position)
            in if moveIsLegal checker then move checker
                else (False, pieces)
