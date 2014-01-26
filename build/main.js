;(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var info = require('./initialize');

function push (move) {
    var key = 'xiangqi-'+info.id;
    var saved = JSON.parse(localStorage.getItem(key) || '{}');
    if (saved && saved.history) {
        saved.history.push(move);
        localStorage.setItem(key, JSON.stringify(saved));
    }
}

exports.push = push;

},{"./initialize":2}],2:[function(require,module,exports){

function isGame(id) {
    return typeof id === 'string' && id.length === 5;
}
function newId() {
    return Math.random().toString(36).substring(3,8);
}
var currentId = location.hash.slice(1); //to get rid of the "#"
var playerColor = "black";
var history = []
if (!isGame(currentId)) {
    location.hash = '#' + (currentId = newId());
    playerColor = "red";
}
var STORAGE_KEY = 'xiangqi-' + currentId
var saved = JSON.parse(localStorage.getItem(STORAGE_KEY) || "{}");

if (saved) {
    if (saved.color) {
        playerColor = saved.color;
    }
    if (saved.history) {
        history = saved.history;
    }
}

saved = {
    color: playerColor,
    history: history,
}

localStorage.setItem(STORAGE_KEY, JSON.stringify(saved));

saved.id = currentId;
module.exports = saved;

},{}],3:[function(require,module,exports){
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

},{"./piece.js":11}],4:[function(require,module,exports){
var Square = require('./square.js');

function Board() {

  var continents = { red: {}, black: {} };
  var palaces = { red: {}, black: {} };

  for (var x = 0; x < 9; x += 1) {
    for (var y = 0; y < 10; y += 1) {
       var coordinates = x + ',' + y;
      var square = new Square(x, y);
      this[coordinates] = square;
      var leftSquare = this[(x - 1) + ',' + y];
      var downSquare = this[x + ',' + (y - 1)];
      if (leftSquare) { square.left = leftSquare; leftSquare.right = square; }
      if (downSquare) { square.down = downSquare; downSquare.up = square }
      if (y < 5) {
        continents.red[coordinates] = square;
      } else {
        continents.black[coordinates] = square;
      }
      if (y < 3 && x < 6 && x > 2) {
        palaces.red[coordinates] = square;
      } else if (y > 6 && x < 6 && x > 2) {
        palaces.black[coordinates] = square;
      }
    }
  }

  Object.defineProperties(this, {
    continents: { value: continents, enumerable: false },
    palaces: { value: palaces, enumerable: false }
  });
}

module.exports = Board;

},{"./square.js":14}],5:[function(require,module,exports){
var Piece = require('./piece.js');

function Cannon(color) {
  var self = new Piece(color);

  self.type = 'Cannon';

  self.getMoves = function(position) {
    var current_square;
    var moves = [];
    var directions = ['left', 'right', 'up', 'down'];
    for (var dir_index = 0; dir_index < directions.length; dir_index += 1) {
      var direction = directions[dir_index];
      var next_square = self.square[direction];
      while (next_square) {
        current_square = next_square;
        if (position[current_square.coordinates]) {
          next_square = current_square[direction];
          while (next_square) {
            current_square = next_square;
            if (position[current_square.coordinates]) {
              if (position[current_square.coordinates].color !== self.color) {
                moves.push(current_square.coordinates);
              }
              break;
            }
            next_square = current_square[direction];
          }
          break;
        }
        moves.push(current_square.coordinates);
        next_square = current_square[direction];
      }
    }
    return moves;
  };

  return self;
}

module.exports = Cannon;

},{"./piece.js":11}],6:[function(require,module,exports){
var Piece = require('./piece.js');

function Chariot(color) {
  var self = new Piece(color);

  self.type = 'Chariot';

  self.getMoves = function(position) {
    var current_square;
    var moves = [];
    var directions = ['left', 'right', 'up', 'down'];
    for (var dir_index = 0; dir_index < directions.length; dir_index += 1) {
      var direction = directions[dir_index];
      var next_square = self.square[direction];
      while (next_square) {
        current_square = next_square;
        if (position[current_square.coordinates]) {
          if (position[current_square.coordinates].color !== self.color) {
            moves.push(current_square.coordinates);
          }
          break;
        }
        moves.push(current_square.coordinates);
        next_square = current_square[direction];
      }
    }
    return(moves);
  };

  return self;
}

Chariot.prototype.constructor = Chariot;

module.exports = Chariot;

},{"./piece.js":11}],7:[function(require,module,exports){

function assertColor(color) {
  if (color !== 'red' && color !== 'black')
    throw Error(color + ' is not a valid color');
}

exports.assertColor = assertColor

},{}],8:[function(require,module,exports){
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

},{"./piece.js":11}],9:[function(require,module,exports){
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

},{"./piece.js":11}],10:[function(require,module,exports){
var Piece = require('./piece.js');

function Horse(color) {
  var self = new Piece(color);

  self.type = 'Horse'

  self.getMoves = function(position) {
    var moves = [];
    var directions = {
      left: ['down', 'up'],
      right: ['down', 'up'],
      up: ['left', 'right'],
      down: ['left', 'right']
    };
    for (var pri_dir_index = 0; pri_dir_index < 4; pri_dir_index += 1) {
      var primary_direction = Object.keys(directions)[pri_dir_index];
      var blocking_square = self.square[primary_direction];
      if (!blocking_square || position[blocking_square.coordinates]) {
        continue;
      }
      var pivot_square = blocking_square[primary_direction];
      if (!pivot_square) {
        continue;
      }
      for (var sec_dir_index = 0; sec_dir_index < 2; sec_dir_index += 1) {
        var secondary_direction = directions[primary_direction][sec_dir_index];
        var target_square = pivot_square[secondary_direction];
        if (target_square && (!position[target_square.coordinates] ||
          position[target_square.coordinates].color !== self.color)) {
          moves.push(target_square.coordinates);
        }
      }
    }
    return moves;
  };

  return self;
}

module.exports = Horse;

},{"./piece.js":11}],11:[function(require,module,exports){
var c = require('./color.js')

function Piece(color) {
  c.assertColor(color);
  this.color = color;
}

module.exports = Piece;

},{"./color.js":7}],12:[function(require,module,exports){
var Board = require('./board.js');
var c = require('./color.js')

function Position() {
  var self = this;
  var toMove;

  function place(piece, coordinates) {
    self[coordinates] = piece;
    piece.square = self.BOARD[coordinates];
    return self;
  }

  function remove(coordinates) {
    delete self[coordinates];
    return self;
  }

  function _import(position) {
    var turn = position.toMove;
    for (var key in position) {
      self.place(position[key], key)
    }
    if (turn === 'red' || turn === 'black') {
      self.toMove = position.toMove;
    }
    return this;
  }

  function findGeneral() {
    for (var coordinates in self) {
      var piece = self[coordinates];
      if (piece.color === toMove && piece.type === 'General') {
        return coordinates;
      }
    }
  }

  function isCheck() {
    var piece;
    var general_location = findGeneral();
    for (var coordinates in self) {
      if (coordinates === 'undefined') { continue; }

      piece = self[coordinates];
      if (piece.color === toMove) {
        continue;
      }

      if (piece.getMoves(self).indexOf(general_location) !== -1) {
        return true;
      }
    }
    var forward = toMove === 'red' ? 'up' : 'down';
    var next_square = self.BOARD[general_location][forward];
    while (next_square) {
      current_square = next_square;
      if (self[current_square.coordinates]) {
        if (self[current_square.coordinates].type === 'General') {
          return true;
        }
        break;
      }
      next_square = current_square[forward];
    }
    return false;
  }

  Object.defineProperties(this, {
    toMove: {
      get: function() { return toMove; },
      set: function(color) {
        c.assertColor(color);
        toMove = color;
      },
      enumerable: false
    },
    remove: {value: remove, enumerable: false},
    place: { value: place, enumerable: false },
    'import': { value: _import, enumerable: false },
    isCheck: {
      get: function() { return isCheck(); },
      enumerable: false
    }
  });
}

Object.defineProperties(Position.prototype, {
  BOARD: { value: new Board(), enumerable: false }
});

module.exports = Position;

},{"./board.js":4,"./color.js":7}],13:[function(require,module,exports){
var Piece = require('./piece.js');

function Soldier(color) {
  var self = new Piece(color);

  self.type = 'Soldier';

  self.getMoves = function(position) {
    var moves = [];
    var forward = self.color === 'red' ? 'up' : 'down';
    var continent = position.BOARD.continents[self.color];
    if (continent[self.square.coordinates]) {
      var directions = [forward];
    } else {
      var directions = ['left', forward, 'right'];
    }
    for (var dir_index = 0; dir_index < directions.length; dir_index += 1) {
      var direction = directions[dir_index];
      var target_square = self.square[direction];
      if (!target_square) {
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

module.exports = Soldier;

},{"./piece.js":11}],14:[function(require,module,exports){
function Square(x, y) {
  var left;
  var right;
  var up;
  var down;

  this.x = x;
  this.y = y;
  this.coordinates = x + ',' + y;

  Object.defineProperties(this, {
    left: {
      get: function() { return left; },
      set: function(square) { left = square; }
    },
    right: {
      get: function() { return right; },
      set: function(square) { right = square; }
    },
    up: {
      get: function() { return up; },
      set: function(square) { up = square; }
    },
    down: {
      get: function() { return down; },
      set: function(square) { down = square; }
    }
  });
}

module.exports = Square;

},{}],15:[function(require,module,exports){
var Position = require('./position.js');
var Chariot = require('./chariot.js');
var Horse = require('./horse.js');
var Elephant = require('./elephant.js');
var Advisor = require('./advisor.js');
var General = require('./general.js');
var Cannon = require('./cannon.js');
var Soldier = require('./soldier.js');

function StartingPosition() {
  var self = new Position();
  var BOARD = self.BOARD;

  self.place(new Chariot('red'), [0, 0])
    .place(new Horse('red'), [1, 0])
    .place(new Elephant('red'), [2, 0])
    .place(new Advisor('red'), [3, 0])
    .place(new General('red'), [4, 0])
    .place(new Advisor('red'), [5, 0])
    .place(new Elephant('red'), [6, 0])
    .place(new Horse('red'), [7, 0])
    .place(new Chariot('red'), [8, 0])
    .place(new Cannon('red'), [1, 2])
    .place(new Cannon('red'), [7, 2])
    .place(new Soldier('red'), [0, 3])
    .place(new Soldier('red'), [2, 3])
    .place(new Soldier('red'), [4, 3])
    .place(new Soldier('red'), [6, 3])
    .place(new Soldier('red'), [8, 3])
    .place(new Chariot('black'), [0, 9])
    .place(new Horse('black'), [1, 9])
    .place(new Elephant('black'), [2, 9])
    .place(new Advisor('black'), [3, 9])
    .place(new General('black'), [4, 9])
    .place(new Advisor('black'), [5, 9])
    .place(new Elephant('black'), [6, 9])
    .place(new Horse('black'), [7, 9])
    .place(new Chariot('black'), [8, 9])
    .place(new Cannon('black'), [1, 7])
    .place(new Cannon('black'), [7, 7])
    .place(new Soldier('black'), [0, 6])
    .place(new Soldier('black'), [2, 6])
    .place(new Soldier('black'), [4, 6])
    .place(new Soldier('black'), [6, 6])
    .place(new Soldier('black'), [8, 6]);
  self.toMove = 'red';

  return self;
}

module.exports = StartingPosition;

},{"./advisor.js":3,"./cannon.js":5,"./chariot.js":6,"./elephant.js":8,"./general.js":9,"./horse.js":10,"./position.js":12,"./soldier.js":13}],16:[function(require,module,exports){

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

function makeMove(piece, from, to) {
    position.remove(from).place(piece, to);
}

checker.isLegal = function (move, makingMove) {
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

module.exports = checker;

},{"./advisor":3,"./cannon":5,"./chariot":6,"./elephant":8,"./general":9,"./horse":10,"./position":12,"./soldier":13,"./starting_position":15}],17:[function(require,module,exports){

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
    }
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

var peerId = 'xiangqi-'+playerColor+id;
var otherId = 'xiangqi-'+otherPlayer+id;
var peer = new Peer(peerId, {key: '51am0fffupb0ggb9'});

var connection;

app.ports.outMoves.subscribe(function (move) {
    var legal = checker.isLegal(move, playerColor);
    if(!connection.open){
        console.log('wtf y u no open');
        connect(otherId);
    };
    if (legal && connection.open) {
        connection.send({
            move: move,
            color: playerColor
        });
    } else {
        app.ports.inMoves.send({legal: false, move: move});
    }
});

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
            console.log("checking someone else's move");
            data.legal = checker.isLegal(data.move, data.color);
            conn.send(data);
            if(data.legal) {
                checker.setTurn(playerColor);
            }
        } else { console.log("got ur move back"); }
        pushToGame(data, history);
    }
}

function connect (id) {
    connection = peer.connect(id);
    connection.on('data', receiveData(connection));
    connection.on('open', function(e) {
        console.log('woooooo u opened');
        console.log(e);
    });
    connection.on('close', function(e) {
        console.log('u closed');
        connect(otherId);
    });
}

connect(otherId);

peer.on('connection', function (conn) {
    console.log('received other dude\'s connection');
    conn.on('data', receiveData(conn));
})


},{"./history":1,"./initialize.js":2,"./lib/xiangcheck.js":16}]},{},[17])
;