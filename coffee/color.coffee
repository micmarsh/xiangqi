
System.create 'color', (m, sender, self) ->
    switch m.type
        when 'get-color'
            self.send
                type: 'color'
                message: 'red'
            , self
        when 'color'
            System.get('master').send(m, self)
