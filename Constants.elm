module Constants where

imageFileSize = [669, 749]
imageName = "/board.jpg"


twoThirds : (Int -> Int)
twoThirds x = x - (div x 3)
half x = div x 2

boardSize = map twoThirds imageFileSize

[boardWidth, boardHeight] = boardSize
boardImage = image boardWidth boardHeight imageName
[centerWidth, centerHeight] = map half boardSize

squareSize = div boardWidth 8

char2Num char = case char of
    'a' -> 0
    'b' -> 1
    'c' -> 2
    'd' -> 3
    'e' -> 4
    'f' -> 5
    'g' -> 6
    'h' -> 7
    'i' -> 8

num2Char num = case num of
    0 -> 'a'
    1 -> 'b'
    2 -> 'c'
    3 -> 'd'
    4 -> 'e'
    5 -> 'f'
    6 -> 'g'
    7 -> 'h'
    8 -> 'i'

allRows = range 1 10

range min max = if min < max then min :: range (min + 1) max
                else []

allColumns = allLetters

allLetters = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i']
soldierLetters = ['a', 'c', 'e', 'g', 'i']
