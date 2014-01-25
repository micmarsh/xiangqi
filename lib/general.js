var Piece = require('./piece.js');

function General(color) {
  var self = new Piece(color);

  self.type = 'General';

  self.getMoves = function(position) {
    var moves = [];
    var palace = position.BOARD.palaces[self.color];
    var directions = ['left', 'right', 'up', 'down'];
    for(var dir_index = 0; dir_index < 4; dir_index += 1) {
      direction = directions[dir_index];
      target_square = self.square[direction];
      if (!target_square || !palace[target_square.coordinates]) {
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

module.exports = General;
