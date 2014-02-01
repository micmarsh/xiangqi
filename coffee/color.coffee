System.create 'color', do ->

    System.later ->
        master = System.get 'master'
        System.get('color').send
            type: 'get-color'
        , master

    (m, sender, self) ->
        switch m.type
            when 'get-color'
                System.get('storage').send
                    type: 'get'
                    data: 'color'
                , sender
