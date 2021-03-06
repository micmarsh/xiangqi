module Moving where
import Model (Piece, Position, findPiece)

type MoveCheck = (Piece, [Piece], Position)
type MoveResult = [Piece]

remove : [a] -> a -> [a]
remove list element = filter (\e -> not <| e == element) list

-- really need let destructures
move : MoveCheck -> MoveResult
move ((Piece t oldPos c), pieces, position) =
    let removedOld = remove pieces (Piece t oldPos c)
        newPiece = Piece t position c
        option = findPiece removedOld position
        removeCaptured = case option of
            Nothing -> removedOld
            (Just captured) -> remove removedOld captured
    in newPiece :: removeCaptured


makeMove : Maybe Piece -> [Piece] -> Position -> MoveResult
makeMove option pieces position =
    case option of
        Nothing -> pieces
        (Just piece) ->
            move (piece, pieces, position)
