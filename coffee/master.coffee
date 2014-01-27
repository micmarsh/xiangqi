master = System.create 'master',
    do ->
        app = Elm.fullscreen Elm.Xiangqi,
            color: 'red'
            inMoves:
                legal: false,
                move: {from: '0,0', to: '0,0'}
            connected: false

        System.later ->
            legality = System.get 'legality'
            app.ports.outMoves.subscribe (move) ->
                legality.send
                    type: 'move'
                    data: move
                , master
            app.ports.state.subscribe (state) ->
                console.log state
                legality.send
                    type: 'state'
                    data: state
                , master

        (message, s, self) ->
            {type, data} = message
            switch type
                when 'get-color'
                    System.get('color').send message, self
                when 'move'
                    app.ports.inMoves.send data
                when 'color'
                    app.ports.color.send data
                else
                    console.log(message)


System.later ->

    # trigger a read of 'history', which
    # will get forwarded to 'inmoves'
    System.get('history').send
        type: 'get-history'
    , System.get 'inmoves'

    # master should get color so it can
    # send it into the color port
    master.send
        type: 'get-color'

