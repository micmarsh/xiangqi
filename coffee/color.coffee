System.create 'color', (m, sender, self) ->
    switch m.type
        when 'get-color'
            System.get('id').send m, sender
        when 'color'
            console.log "this shouldn't really ever happen"
            # System.get('master').send m, self
