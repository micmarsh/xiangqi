
System.create 'storage', do ->
    if System.test
        global.localStorage = { }
    ID = null
    PREFIX = 'xiangqi-'
    getInfo =  ->
        JSON.parse(localStorage[PREFIX+ID] or "{ }")

    saveInfo = (info) ->
        localStorage[PREFIX+ID] = JSON.stringify info

    System.later ->
        self = System.get 'storage'
        System.get('id').send
            type: 'get-id'
        , self

    waitForID = (fn) ->
        if ID
            fn()
        else
            setTimeout ->
                waitForID fn
            , 1

    ({type, data}, sender, self) ->
        switch type
            when 'set-if-new'
                waitForID ->
                    {key, value} = data
                    info = getInfo()
                    unless info[key]?
                        info[key] = value
                        saveInfo info
                if sender
                    sender.send {
                        data
                        type: 'confirm-set'
                    }, self
            when 'set'
                waitForID ->
                    info = getInfo()
                    {key, value} = data
                    info[key] = value
                    saveInfo info
            when 'get'
                waitForID ->
                    info = getInfo()
                    if info[data]
                        sender.send
                            type: data
                            data: info[data]
                        , self
            when 'safe-get'
                waitForID ->
                    info = getInfo()
                    {key, backup} = data
                    sender.send
                        type: key
                        data: info[key] or backup
                    , self
            when 'id'
                ID = data
