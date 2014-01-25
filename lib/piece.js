var c = require('./color.js')

function Piece(color) {
  c.assertColor(color);
  this.color = color;
}

module.exports = Piece;
