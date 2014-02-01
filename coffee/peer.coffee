
System.create 'p2p', do ->
    id = null
    color = null
    other = null
    prefix = 'xiangqi-'

    registerConn = (conn, peer) ->
        ->
            conn.on 'data', (data) ->
            # conn.on 'close', ->

    wait = (fn) ->
        if id and color and other
            fn()
        else
            setTimeout ->
                wait fn
            ,1

    wait ->
        peer = new Peer prefix+color+id,
            key: '51am0fffupb0ggb9'

        peer.on 'connection', (conn) ->
            do registerConn conn, peer

        conn = peer.connect prefix+other+id
        conn.on 'open', registerConn conn, peer


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
            when 'move'
                # TODO need to figure out a good mapping between this send/receive
                # and the peer's connection's send/receive. Take a break 4 now
                # Some thoughts: this part should send something to the peer connection,
                # but getting things sent back remotely is muy dificil. May have to mess with some
                # state to get things to happen in the proper order. Maybe worth starting over entirely
                # with this actor
                console.log "received move in p2p #{JSON.stringify data}"

