#!/bin/sh
elm --make -o Xiangqi.elm
cat coffee/*.coffee > all.coffee
coffee -o javascripts/ -c all.coffee
# mv javascripts/all.js javascripts/main.js
rm all.coffee
browserify javascripts/main.js > build/main.js
cp javascripts/lib/peer.min.js build/peer.min.js
cp javascripts/lib/elm-runtime.js build/elm-runtime.js
