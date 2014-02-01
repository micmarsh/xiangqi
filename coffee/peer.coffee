
System.create 'p2p', do ->
    id = null
    color = null
    other = null

    checking = null
    connection = null

    connect = (which) ->
        console.log 'woooooo connected '+which
        # if outgoing and incoming
        System.get('master').send
            type: 'connected'
            data: true

    prefix = 'xiangqi-'

    registerConn = (conn, peer, self) ->
        ->
            conn.on 'data', (data) ->
                console.log 'yo got some data from over there'
                switch data.type
                    when 'check-move'
                        System.get('legality').send data, self
                    when 'move'
                        checking.send data, self
                        checking = null
            conn.on 'close', ->
                alert 'u closed'

    wait = (fn) ->
        if id and color and other
            fn()
        else
            setTimeout ->
                wait fn
            ,1

    wait ->
        self = System.get 'p2p'
        peer = new Peer prefix+color+id,
            key: '51am0fffupb0ggb9'

        peer.on 'connection', (conn) ->
            connect 'incoming'
            connection = conn
            do registerConn conn, peer, self

        connection = peer.connect prefix+other+id
        connection.on 'open', ->
            connect 'outgoing'
            registerConn connection, peer, self


    System.later ->
        self = System.get 'p2p'
        System.get('id').send
            type: 'get-id'
        , self
        System.get('color').send
            type: 'get-color'
        , self

    ({type, data}, sender) ->
        switch type
            when 'id'
                id = data
            when 'color'
                color = data
                other = if color is 'red' then 'black' else 'red'
            when 'check-move', 'move'
                if type is 'check-move'
                    console.log 'yo checking yo move'
                else
                    console.log 'about to send back to OG'
                checking = sender if type is 'check-move'
                connection.send {type, data}
