
var Position = require('./position.js');

var Position = require('./position');

var Pieces = {};
Pieces.Advisor = require('./advisor');
Pieces.Cannon = require('./cannon');
Pieces.Chariot = require('./chariot');
Pieces.Elephant = require('./elephant');
Pieces.King = require('./general');
Pieces.Horse = require('./horse');
Pieces.Soldier = require('./soldier');

var checker = {};
var position;
var TYPE = 0;
var POSITION = 1;
var COLOR = 2;

checker.setState = function (pieces, turn) {
  var piece;
  var type;
  var pos;
  var color;
  position = new Position();
  for (var i in pieces) {
    piece = pieces[i];
    pos = piece[POSITION];
    type = piece[TYPE];
    color = piece[COLOR];

    //nasty mutability
    piece = new Pieces[type](color);

    position.place(piece, pos);
  }
  position.toMove = turn;
};

function makeMove(piece, from, to) {
    position.remove(from).place(piece, to);
}
checker.isLegal = function (move) {
  if (position) {
    var from = move.from;
    var to = move.to;
    var piece = position[from];
    if (piece) {
      var moveList = piece.getMoves(position);
      if (moveList.indexOf(to) !== -1) {
        makeMove(from, to);
        var result = !position.isCheck;
        makeMove(to, from);
        return result;
      }
    }
  }
  return false;
}

module.exports = checker;
