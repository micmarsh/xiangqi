System.create 'legality', do ->
    # THE REASON WE NEED BROWSERIFY
    checker = require './lib/xiangcheck'
    # *****************************

    playerColor = null
    System.later ->
        System.get('color').send
            type: 'get-color'
        , System.get('legality')

    ({type, data}, sender, self) ->
        switch type
            when 'color'
                playerColor = data
            when 'state'
                {pieces, turn} = data
                checker.setState pieces, turn
            when 'check-move'
                if playerColor
                    legal = checker.isLegal data, (data.color or playerColor)
                    if legal and data.send
                        delete data.send
                        data.color = playerColor
                        System.get('p2p').send {
                            data
                            type: 'check-move'
                        }, self
                    else
                        sender.send
                            type: 'move'
                            data: {
                                legal
                                move: data
                            }
                        , self
            when 'confirmed'
                # Type check: this probably sends
                # {legal:bool, move:...} formatted data
                {move} = data
                console.log "yo the data in confirmed #{JSON.stringify data}"
                System.get('history').send
                    type: 'push'
                    data: move
                System.get('inmoves').send {data, type: 'move'}


