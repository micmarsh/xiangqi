System.create 'inmoves', ({data, type}, sender, self) ->
    #explicit parent
    master = System.get('master')

    switch type
        when "history"
            for move in data
                master.send
                    type: 'move'
                    data: {
                        legal: true
                        move
                    }
                , self
        when 'move'
            master.send {data, type}, sender
