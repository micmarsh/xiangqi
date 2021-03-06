System.create 'master',
    do ->
        app = Elm.fullscreen Elm.Xiangqi,
            color: 'red'
            inMoves:
                legal: false,
                move: {from: '0,0', to: '0,0'}
            connected: false
            check: {check: false, mate: false, inCheck: 'red'}

        System.later ->
            legality = System.get 'legality'
            master = System.get 'master'
            app.ports.outMoves.subscribe (move) ->
                move.send = true
                legality.send
                    type: 'check-move'
                    data: move
                , master
            app.ports.state.subscribe (state) ->
                console.log 'yo state updated'
                legality.send
                    type: 'state'
                    data: state
                , master

        for event in ['online', 'offline']
            do (event) ->
                window["on#{event}"] = ->
                    online = event is 'online'
                    app.ports.connected.send online

        (message, s, self) ->
            {type, data} = message
            switch type
                when 'check'
                    app.ports.check.send data
                when 'move'
                    app.ports.inMoves.send data
                when 'color'
                    app.ports.color.send data
                when 'connected'
                    app.ports.connected.send data
                else
                    console.log "master recieved unknown message"
                    console.log message
                    console.log 'sent by'
                    console.log s



