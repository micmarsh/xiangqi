
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
var saved = JSON.parse(localStorage[STORAGE_KEY] || "{}");

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

localStorage[STORAGE_KEY] = JSON.stringify(saved);

module.exports = saved;
exports.id = currentId;
