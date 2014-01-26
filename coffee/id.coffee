
System.create 'id', do ->
    #for node testing
    location = {}
    location.hash = '#1456'

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
                sender.send
                    type: 'color'
                    data: playerColor
                ,self


