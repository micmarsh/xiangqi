module Sidebar where

import GameState (gameState, playerColor)
import Model (Red, Black, Piece, Color)
import Constants (sideBarWidth, squareSize)
import Board (pieceImage)

whoseTurn : Maybe Color -> Color -> String
whoseTurn option player =
    case option of
        Just color ->
            (if color == player then "Your"
            else case player of
                Red -> "Red's"
                Black -> "Black's") ++ " Turn"
        Nothing -> ""

turnMessage = lift2 whoseTurn playerColor (lift .turn gameState)
turnViews = lift asText turnMessage

selectedPiece = lift .selected gameState

makePieceView : Maybe Piece -> Element
makePieceView option =
    case option of
        Nothing -> spacer sideBarWidth sideBarWidth
        Just (Piece kind position color) ->
            let textWidth = sideBarWidth - squareSize
                textWrapper = container textWidth squareSize midLeft
            in flow right [
                textWrapper (asText "Selected: "),
                pieceImage kind color
            ]
            -- TODO groovy lulu image in some hot and composable way. renaming will probs be involved

pieceViews : Signal Element
pieceViews = lift makePieceView selectedPiece

unsizedSidebar = lift2 (\m ps -> flow down [m, ps]) turnViews pieceViews
sidebar = lift (width sideBarWidth) unsizedSidebar
