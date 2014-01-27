System.create 'color', (m, sender, self) ->
    switch m.type
        when 'get-color'
            System.get('storage').send
                type: 'get'
                data: 'color'
            , sender
            # System.get('master').send m, self
