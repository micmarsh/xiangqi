var Piece = require('./piece.js');

function Elephant(color) {
  var self = new Piece(color);

  self.type = 'Elephant';

  self.getMoves = function(position) {
    var moves = [];
    var continent = position.BOARD.continents[self.color];
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
      var blocking_square = self.square[direction[0]][direction[1]];
      if (position[blocking_square.coordinates]) {
        continue;
      }
      if (!blocking_square[direction[0]] || !blocking_square[direction[1]]) {
        continue;
      }
      var target_square = blocking_square[direction[0]][direction[1]];
      if (!continent[target_square.coordinates]) {
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

module.exports = Elephant;
