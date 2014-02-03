
var Position = require('./position');

var Pieces = {};
Pieces.Advisor = require('./advisor');
Pieces.Cannon = require('./cannon');
Pieces.Chariot = require('./chariot');
Pieces.Elephant = require('./elephant');
Pieces.King = require('./general');
Pieces.Horse = require('./horse');
Pieces.Soldier = require('./soldier');

var Start = require('./starting_position');
var checker = {};
var position = new Start();
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
checker.setTurn = function (turn) {
  if(position){
    position.toMove = turn;
  }
}

checker.getTurn = function () {
  return position.toMove;
}

function makeMove(piece, from, to) {
    position.remove(from).place(piece, to);
}

var isLegal;
checker.isLegal = isLegal = function (move, makingMove) {
  function legalPiece (piece) {
    return piece &&
    piece.color === makingMove &&
    piece.color === position.toMove;
  }

  if (position) {
    var from = move.from;
    var to = move.to;
    var piece = position[from];
    if (legalPiece(piece)) {
      var moveList = piece.getMoves(position);
      if (moveList.indexOf(to) !== -1) {
        makeMove(piece, from, to);
        var result = !position.isCheck;
        makeMove(piece, to, from);
        return result;
      }
    }
  }
  return false;
}

checker.isCheck = function () {
  return position.isCheck;
}

checker.isCheckmate = function () {
  var pos,
      move,
      piece,
      moves,
      result = true;
  for (pos in position) {
    piece = position[pos];
    if (piece.color === position.toMove) {
      moves = piece.getMoves(position);
      moves = moves.map(function (move) {
        return {from: pos, to: move};
      }).filter(function (move) {
        return isLegal(move, position.toMove);
      });
      result = moves.length === 0;
    }
  }
  return result
}

window.butt = checker.isCheckmate

module.exports = checker;
