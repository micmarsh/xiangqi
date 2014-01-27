
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
        System.get('id').send
            type: 'get-id'
        , System.get('storage')

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
            when 'id'
                ID = data
