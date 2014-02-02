System.create 'history', do ->
    pushing = false

    System.later ->
        System.get('history').send
            type: 'get-history'
        , System.get 'inmoves'

    (message, sender, self) ->
        storage = System.get('storage')
        switch message.type
            when 'get-history'
                console.log 'getting history'
                storage.send
                    type: 'safe-get'
                    data:
                        key: 'history'
                        backup: [ ]
                , self
            when 'history'
                {data} = message
                if pushing
                    console.log 'pushing'
                    data.push pushing
                    storage.send
                        type: 'set'
                        data:
                            key: 'history'
                            value: data
                    , self
                    pushing = false
                else
                    #explicit parent
                    System.get('inmoves').send
                        type: 'history'
                        data: data or []
                    , self
            when 'push'
                console.log 'pushing data'
                pushing = message.data
                self.send {type: 'get-history'}
