
var checker = require('./lib/xiangcheck.js');
var info = require('./initialize.js');

var playerColor = info.color;
var id = info.id;
var history = info.history;
var otherPlayer = playerColor === "red" ? "black" : "red"

var sampleShit = {from: '0,0', to: '2,3'};
var app = Elm.fullscreen(Elm.Xiangqi, {
    color: playerColor,
    inMoves: {legal: false, move: sampleShit}
});

for (var i in history) {
    var move = history[i];
    app.ports.inMoves.send({legal:true, move: move});
}

app.ports.state.subscribe(function (state) {
    var pieces = state.pieces;
    var turn = state.turn;
    console.log(turn);
    checker.setState(pieces, turn);
});

var peerId = 'xiangqi-'+playerColor+id;
var otherId = 'xiangqi-'+otherPlayer+id;
var peer = new Peer(peerId, {key: '51am0fffupb0ggb9'});

var connection = peer.connect(otherId);

app.ports.outMoves.subscribe(function (move) {
    var legal = checker.isLegal(move, playerColor);
    if (legal && connection.open) {
        connection.send({
            move: move,
            color: playerColor
        });
    } else {
        app.ports.inMoves.send({legal: false, move: move});
    }
});

connection.on('data', receiveData);

peer.on('connection', function (conn) {
    console.log('received other dude\'s connection');
    conn.on('data', receiveData);
})

function pushToGame (data) {
    delete data.color;
    app.ports.inMoves.send(data);
}
function receiveData (data) {
    var move = data.move;
    var color = data.color;
    var legal = data.legal || false;
    if(color !== playerColor) {
        console.log("checking someone else's move");
        legal = checker.isLegal(move, color);
        conn.send({
            move: move,
            color: color,
            legal: legal
        });
        if(legal) {
            checker.setTurn(playerColor);
        }
    } else { console.log("got ur move back"); }
    pushToGame(data);
}


