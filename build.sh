#!/bin/sh
elm --make -o Xiangqi.elm
cat coffee/*.coffee > all.coffee
coffee -o javascripts/ -c all.coffee
browserify javascripts/all.js > build/main.js
cp javascripts/lib/peer.min.js build/peer.min.js
cp javascripts/lib/elm-runtime.js build/elm-runtime.js

rm all.coffee javascripts/all.js

# deps: browserify, coffee, chinese_chess if it gets packaged
