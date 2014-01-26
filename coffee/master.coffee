
System.create 'master', (message) ->
    switch message.type
        when 'get-color'
            System.get('color').send(message)
        when 'color'
            console.log(message)

System.get('master').send
    type: 'get-color'
