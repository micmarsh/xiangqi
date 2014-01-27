System.create 'inmoves', ({data, type}, sender, self) ->
    switch type
        when "history"
            master = System.get('master')
            for move in data
                master.send
                    type: 'move'
                    data: {
                        legal: true
                        move
                    }
                , self
