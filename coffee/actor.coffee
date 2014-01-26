
System = do ->
    actors = { }
    create: (name, onReceive) ->
        actors[name] = actor = {
            onReceive,
            send: (message, sender) ->
                onReceive(message, sender, actor)
        }
        return actor
    get: (name) ->
        actor = actors[name]
        unless actor
            throw new Error "#{name} doesn't exist"
        return actor


