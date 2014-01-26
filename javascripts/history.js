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
