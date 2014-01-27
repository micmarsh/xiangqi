System.create 'history', do ->
    pushing = false
    (message, sender, self) ->
        storage = System.get('storage')
        switch message.type
            when 'get-history'
                storage.send
                    type: 'get'
                    data: 'history'
                , self
            when 'history'
                if pushing
                    history = (data or []).push pushing
                    storage.send
                        type: 'set'
                        data:
                            key: 'history'
                            value: history
                    , self
                    pushing = false
                else
                    #explicit parent
                    System.get('inmoves').send
                        type: history
                        data: data or []
                    , self
            when 'push'
                pushing = data
                self.send {type: 'get-history'}
