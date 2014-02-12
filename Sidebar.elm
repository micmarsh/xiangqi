module Sidebar where

--import GameState (gameState, playerColor)
import Model (Red, Black, Piece, Color, playerADT, Check, CheckMate)
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

putTogether message piece  =
    flow down [
        rectSpacer,
        message,
        piece
    ]

makeTurnView gameState color  =
    let playerColor = lift playerADT color
        turnText =  lift applyColor <| lift2 whoseTurn playerColor (lift .turn gameState)
    in lift turnMessage turnText

colorText c = text . (color c) . toText
redText = colorText red
blackText = colorText black
greyText = colorText darkGrey

waiting = (text . applyColor) "Waiting for other player..."
disconnected =  redText "Disconnected"

data Status = Waiting |
              Connected |
              Disconnected

makeTitle turnView connected =
    case connected of
        Waiting -> waiting
        Connected -> turnView
        Disconnected -> disconnected

updateStatus new prev =
    if new then Connected
    else if prev == Waiting then Waiting
    else if prev == Connected then Disconnected
    else Disconnected

checkText player check =
    let makeText = (text . applyColor)
    in case check of
        Just (Check color) ->
            if (color == player) then makeText "You're in check!"
            else shortSpacer
        _ -> shortSpacer

isCheckMate check = 
    case check of
        Just (CheckMate color) -> True
        _ -> False

renderCheckMateFor check =
    case check of
        Just (CheckMate color) ->
            flow down [ 
                (text . applyColor) "Checkmate!",
                flow right [(if color == Red then redText "Red"
                else blackText "Black"), greyText " wins!"]
            ]
        _ -> rectSpacer -- this will never happen

decideMessage turnStatus check = 
    if isCheckMate check then renderCheckMateFor check
    else turnStatus

makeSideBar {gameState, color, connected} =
    let turnViews = makeTurnView gameState color
        connStatus = foldp updateStatus Waiting connected
        titleViews = lift2 makeTitle turnViews connStatus
        selectedPiece = lift .selected gameState
        pieceViews = lift makePieceView selectedPiece
        checkStatus = lift .check gameState
        checkMessage = lift2 checkText (lift playerADT color) checkStatus
        turnStatus = lift (flow down) <| lift2 (\u l -> [u, l]) titleViews checkMessage
        displayMessage = lift2 decideMessage turnStatus checkStatus
        unsizedSidebar = lift2 putTogether displayMessage pieceViews
    in lift (width sideBarWidth) unsizedSidebar
