elm --make -o Xiangqi.elm
browserify javascripts/main.js > build/main.js
cp javascripts/lib/peer.min.js build/peer.min.js
cp javascripts/lib/elm-runtime.js build/elm-runtime.js
