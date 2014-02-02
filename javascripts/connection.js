function connect (args) {
    var playerColor = args.playerColor;
    var otherPlayer = args.otherPlayer;
    var id = args.id;
    var app = args.app;
    var checker = args.checker;

    var peerId = 'xiangqi-'+playerColor+id;
    var otherId = 'xiangqi-'+otherPlayer+id;
    var peer = new Peer(peerId, {key: '51am0fffupb0ggb9'});

    var connection;
    var cou

    function pushToGame (data, history) {
        delete data.color;
        app.ports.inMoves.send(data);
        if (data.legal) {
            history.push(data.move);
        }
    }

    function receiveData (conn) {
        var history = require('./history');
        return function (data) {
            if(data.color !== playerColor) {
                data.legal = checker.isLegal(data.move, data.color);
                conn.send(data);
                if(data.legal) {
                    checker.setTurn(playerColor);
                }
            }
            pushToGame(data, history);
        }
    }

    var connected;
    function _connect (id) {
        connection = peer.connect(id);
        connection.on('data', receiveData(connection));
        connection.on('open', function(e) {
            connected = true;
        });
        connection.on('close', function(e) {
            connected = false;
            _connect(otherId);
        });
    }

    _connect(otherId);

    setInterval(function(){
        connected = connection.open;
        app.ports.connected.send(connected);
    },1000);

    peer.on('connection', function (conn) {
        connected = true;
        conn.on('data', receiveData(conn));
    });

    return {
        isOpen: function () {
            return connection.open;
        },
        send: function (data) {
            connection.send(data);
        },
        reconnect: function (){
            _connect(otherId);
        }
    };
}

exports.connect = connect;

