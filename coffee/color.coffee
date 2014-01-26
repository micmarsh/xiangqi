System.create 'color', (m, sender, self) ->
    switch m.type
        when 'get-color'
            System.get('id').send m, self
        when 'color'
            System.get('master').send(m, self)
