
var checker = require('./lib/xiangcheck.js');

function isGame(id) {
    return typeof id === 'string' && id.length === 5;
}
function newId() {
    return Math.random().toString(36).substring(3,8);
}

var currentId = location.hash.slice(1); //to get rid of the "#"
var playerColor = "black";

if (!isGame(currentId)) {
    location.hash = currentId = '#' + newId();
    playerColor = "red";
}

var sampleShit = {from: '0,0', to: '2,3'};
var app = Elm.fullscreen(Elm.Xiangqi, {
    color: playerColor,
    inMoves: {legal: false, move: sampleShit}
});

app.ports.state.subscribe(function (state) {
    var pieces = state.pieces;
    var turn = state.turn;
    checker.setState(pieces, turn);
});
app.ports.outMoves.subscribe(function (move) {
    var legal = checker.isLegal(move);
    app.ports.inMoves.send({legal: legal, move: move});
});
