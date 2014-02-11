module Sidebar where

--import GameState (gameState, playerColor)
import Model (Red, Black, Piece, Color, playerADT, Check)
import Constants (sideBarWidth, squareSize)
import Board (pieceImage)
import Monad as M
color = Text.color
darkGrey = rgb 55 55 55

spacerw = spacer sideBarWidth

squareSpacer = spacerw sideBarWidth
rectSpacer = spacerw squareSize
shortSpacer = spacerw  <| squareSize `div` 3

whoseTurn : Color -> Color -> String
whoseTurn player turn =
    if turn == player then "Your"
    else case turn of
        Red -> "Red's"
        Black -> "Black's"

applyColor : String -> Text
applyColor string =
    let text = toText string
    in case string of
        "Red's" -> color red text
        "Black's" -> color black text
        _ -> color darkGrey text

turnMessage : Text -> Element
turnMessage name =
    let ending = color darkGrey <| toText " Turn"
        phrase = [name, ending]
        asElts = map text phrase
    in
        flow right asElts

makePieceView : Maybe Piece -> Element
makePieceView option =
    case option of
        Nothing -> squareSpacer
        Just (Piece kind position color) ->
            let image = pieceImage kind color
                sideLength = (sideBarWidth `div` 3) * 2
                biggerImage = size sideLength sideLength image
            in flow down [
                rectSpacer,
                biggerImage
            ]

putTogether turn piece check =
    flow down [
        rectSpacer,
        turn,
        check,
        piece
    ]

makeTurnView gameState color  =
    let playerColor = lift playerADT color
        turnText =  lift applyColor <| lift2 whoseTurn playerColor (lift .turn gameState)
    in lift turnMessage turnText

waiting = (text . applyColor) "Waiting for other player..."
disconnected = (text . (color red) . toText) "Disconnected"

data Status = Waiting |
              Connected |
              Disconnected

makeTitle : Element -> Status -> Element
makeTitle turnView connected =
    case connected of
        Waiting -> waiting
        Connected -> turnView
        Disconnected -> disconnected

updateStatus : Bool -> Status -> Status
updateStatus new prev =
    if new then Connected
    else if prev == Waiting then Waiting
    else if prev == Connected then Disconnected
    else Disconnected

checkText : Color -> Maybe Check -> Element
checkText player check =
    let makeText = (text . applyColor)
    in case check of
        Just (Check color) ->
            if (not (color == player)) then makeText "You're in check!"
            else shortSpacer
        _ -> shortSpacer

makeSideBar {gameState, color, connected} =
    let turnViews = makeTurnView gameState color
        connStatus = foldp updateStatus Waiting connected
        titleViews = lift2 makeTitle turnViews connStatus
        selectedPiece = lift .selected gameState
        pieceViews = lift makePieceView selectedPiece
        checkMessage = lift2 checkText (lift playerADT color) (lift .check gameState)
        unsizedSidebar = lift3 putTogether titleViews pieceViews checkMessage
    in lift (width sideBarWidth) unsizedSidebar
