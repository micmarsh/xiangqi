System = do ->
    actors = { }
    create: (name, onReceive) ->
        if actors[name]
            throw new Error "Actor \"#{name}\" already exists"
        actors[name] = actor =
            send: (message, sender) ->
                onReceive(message, sender, actor)
        return actor
    get: (name) ->
        actor = actors[name]
        unless actor
            throw new Error "Actor \"#{name}\" doesn't exist"
        return actor
    blank: send: ->
    later: (fn) -> setTimeout fn, 0
    test: true

