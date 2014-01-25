var Position = require('./position.js');

function MovablePosition(parent) {
    self = parent || new Position();

    function toggleTurn () {
        self.toMove = self.toMove === 'red'? 'black' : 'red';
    }

    function canMove(from, to) {
        var piece = self[from];
        if (Boolean(piece) && piece.color === self.toMove) {
            var moveList = piece.getMoves(self);
            if (moveList.indexOf(to) !== -1) {
                makeMove(from, to, true);
                var result = !self.isCheck;
                makeMove(to, from, true);
                return result;
            };
        };
        return false;
    }

    function makeMove(from, to, internal) {
        var piece = self[from];
        self.remove(from).place(piece, to);
        if(!internal)
            toggleTurn();
    }

    Object.defineProperties(self, {
        canMove: {value: canMove, enumerable: false},
        makeMove: {value: function (from, to) {
            makeMove(from, to, false);
        }, enumerable: false },
    });

    return self;
}

module.exports = MovablePosition
