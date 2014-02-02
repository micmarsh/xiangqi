# How this should work:
# do the hash generation stuff, is RED
# if need to make a hash, is BLACK if not
#
# if the color is RED, u can just send it to sender (color)
# when get-color comes around, else forward get-color to storage
# and receive a 'color' to forward back to 'color'
#
# either way, send color and "new" to local storage
# if it's actually new it'll save, if it already exists it'll
# just ignore
#

System.create 'id', do ->
    #for node testing
    if System.test
        global.location = {}
        global.location.hash = '#15o6'
    isGame = (id) ->
        typeof id is "string" and id.length is 5
    newId = ->
        Math.random().toString(36).substring 3, 8
    currentId = location.hash.slice(1) #to get rid of the "#"

    playerColor = "black"
    unless isGame currentId
        location.hash = "#" + (currentId = newId())
        playerColor = "red"

    needToConfirm = playerColor is 'black'

    System.later ->
        color = System.get 'color'
        color.send
            type: 'set-color'
            data: playerColor
        , System.get 'master'

    (m, sender, self) ->
        switch m.type
            when 'get-id'
                sender.send
                    type: 'id'
                    data: currentId
                , self
