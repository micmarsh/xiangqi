System.create 'history', (message, sender) ->
    storage = System.get('storage')
    switch message.type
        when 'push-history', 'get-history'
            storage.send message, sender
