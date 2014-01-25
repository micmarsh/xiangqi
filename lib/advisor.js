var Piece = require('./piece.js');

function Advisor(color) {
  var self = new Piece(color);

  self.type = "Advisor";

  self.getMoves = function(position) {
    var moves = [];
    var palace = position.BOARD.palaces[self.color];
    var directions = [
      ['left', 'up'],
      ['up', 'right'],
      ['right', 'down'],
      ['down', 'left']
    ];
    for (var dir_index = 0; dir_index < 4; dir_index += 1) {
      var direction = directions[dir_index];
      if (!self.square[direction[0]] || !self.square[direction[1]]) {
        continue;
      }
      var target_square = self.square[direction[0]][direction[1]];
      if (!palace[target_square.coordinates]) {
        continue;
      }
      if (!position[target_square.coordinates] ||
        position[target_square.coordinates].color !== self.color) {
        moves.push(target_square.coordinates);
      }
    }
    return moves;
  };

  return self;
}

module.exports = Advisor;
