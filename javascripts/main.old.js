
var checker = require('./lib/xiangcheck.js');
var info = require('./initialize.js');

var playerColor = info.color;
var id = info.id;
var history = info.history;
var otherPlayer = playerColor === "red" ? "black" : "red"

var app = Elm.fullscreen(Elm.Xiangqi, {
    color: playerColor,
    inMoves: {
        legal: false,
        move: {from: '0,0', to: '0,0'}
    },
    connected: false
});

for (var i in history) {
    var move = history[i];
    app.ports.inMoves.send({legal:true, move: move});
}

app.ports.state.subscribe(function (state) {
    var pieces = state.pieces;
    var turn = state.turn;
    checker.setState(pieces, turn);
});

var connection = require('./connection').connect({
    playerColor: playerColor,
    otherPlayer: otherPlayer,
    id: id,
    app: app,
    checker: checker
})

app.ports.outMoves.subscribe(function (move) {
    var legal = checker.isLegal(move, playerColor);
    if(!connection.isOpen()){
        connection.reconnect();
    };
    if (legal && connection.isOpen()) {
        connection.send({
            move: move,
            color: playerColor
        });
    } else {
        app.ports.inMoves.send({legal: false, move: move});
    }
});


