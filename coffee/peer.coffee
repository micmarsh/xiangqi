
System.create 'p2p', do ->
    id = null
    color = null
    other = null

    checking = null
    connection = null

    connected = ->
        System.get('master').send
            type: 'connected'
            data: true

    prefix = 'xiangqi-'

    confirm = (actor, data) ->
        delete data.move.color
        actor.send {
            data: data
            type: 'confirmed'
        }

    registerConn = (conn, peer, self) ->
        conn.on 'data', (data) ->
            switch data.type
                when 'check-move'
                    System.get('legality').send data, self
                when 'move'
                    confirm checking, data.data
                    checking = null
        conn.on 'close', ->
            alert 'u closed'
            connect peer, self

    wait = (fn) ->
        if id and color and other
            fn()
        else
            setTimeout ->
                wait fn
            ,1

    connect = (peer, self) ->
        connection = peer.connect prefix+other+id
        connection.on 'open', ->
            connected()
            registerConn connection, peer, self

    wait ->
        self = System.get 'p2p'
        peer = new Peer prefix+color+id,
            key: '51am0fffupb0ggb9'

        peer.on 'connection', (conn) ->
            connected()
            connection = conn
            registerConn conn, peer, self

        connect peer, self


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
                    checking = sender
                else
                    confirm System.get('legality'), data
                connection.send {type, data}
