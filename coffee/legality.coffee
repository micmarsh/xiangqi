System.create 'legality', do ->
    # THE REASON WE NEED BROWSERIFY
    checker = require './lib/xiangcheck'
    # *****************************
    playerColor = null
    System.later ->
        System.get('color').send
            type: 'get-color'
        , System.get('legality')

    ({type, data}, sender) ->
        switch type
            when 'color'
                console.log 'woah got some color'
                playerColor = data
            when 'state'
                {pieces, turn} = data
                checker.setState pieces, turn
            when 'check-move'
                if playerColor
                    legal = checker.isLegal data, playerColor
                    # TODO: FANCY PEERJS STUFF
                    if legal
                        System.get('p2p').send
                            type: 'move'
                            data:
                                color: playerColor
                                move: data
                    else
                        sender.send
                            type: 'move'
                            data: {
                                legal
                                move: data
                            }
            when 'confirmed'
                # Type check: this probably sends
                # {legal:bool, move:...} formatted data
                {move} = data
                System.get('history').send
                    type: 'push'
                    data: move
                System.get('inmoves').send {data, type: 'move'}


