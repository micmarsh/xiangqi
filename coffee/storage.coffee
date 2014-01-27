#again, 4 node tests
localStorage = { }


System.create 'storage', do ->
    ID = null
    PREFIX = 'xiangqi-'
    getInfo =  ->
        localStorage[PREFIX+ID]
    saveInfo = (info) ->
        localStorage[PREFIX+ID] = info
    System.later ->
        System.get('id').send
            type: 'get-id'
        , System.get('storage')
    ({type, data}, sender, self) ->
        switch type
            when 'save-color'
                {color} = data
                info = getInfo()
                if info
                    info.color = color
                else
                    info = {color}
                saveInfo info
                sender.send {type: 'saved'}
            when 'get-color'
                info = getInfo()
                if info and info.color
                    sender.send
                        type: 'color'
                        data: info.color
            when 'push-history'
                info = getInfo()
                if info
                    info.history = [] unless info.history
                    info.history.push data
                    saveInfo info
            when 'get-history'
                info = getInfo()
                if info and info.history
                    sender.send
                        type: 'history'
                        data: info.history
                    , selfg
            when 'id'
                ID = data





