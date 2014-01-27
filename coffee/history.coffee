System.create 'history', (message, sender) ->
    storage = System.get('storage')
    switch m.type
        when 'push-history', 'get-history'
            storage.send message, sender
