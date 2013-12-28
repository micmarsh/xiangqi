module Logic (maybeMove) where
import Model (Piece, Position)

type MoveCheck = (Piece, [Piece], Position)
--this is going to have some real logic in it at some point
moveIsLegal : MoveCheck -> Bool
moveIsLegal (piece, pieces, position) = True

-- really need let destructures
move : MoveCheck -> (Bool, [Piece])
move ((Piece t oldPos c), pieces, position) =
    let removeOld = filter (\p -> not <| p == (Piece t oldPos c)) pieces
        newPiece = Piece t position c
    in (True, newPiece :: removeOld)


maybeMove : Maybe Piece -> [Piece] -> Position -> (Bool, [Piece])
maybeMove option pieces position =
    case option of
        Nothing -> (False, pieces)
        (Just piece) ->
            let checker = (piece, pieces, position)
            in if moveIsLegal checker then move checker
                else (False, pieces)
