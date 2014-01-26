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
# also, add a get-id receive, which returns what U want to sender

System.create 'id', do ->
    #for node testing
    location = {}
    location.hash = '#145o6'

    isGame = (id) ->
        typeof id is "string" and id.length is 5
    newId = ->
        Math.random().toString(36).substring 3, 8
    currentId = location.hash.slice(1) #to get rid of the "#"
    playerColor = "black"

    unless isGame currentId
        location.hash = "#" + (currentId = newId())
        playerColor = "red"

    (m, sender, self) ->
        switch m.type
            when 'get-color'
                #TODO a message to localstorage if game is not new
                # a message to save color given appropriate conditions
                # localstorage can for sure check if new
                sender.send
                    type: 'color'
                    data: playerColor
                ,self
            when 'get-id'
                sender.send
                    type: 'id'
                    data: currentId
                ,self


