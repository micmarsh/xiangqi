(ns xiangqi.game)

(defn get-piece [player row column pieces]
    (let [offset? (= player :red)
          row (if offset? (- 7 row) row)
          column (if offset? (- 7 column) column)]
        (aget pieces (str column "," row))))

(defn game->board [game]
    (vec (for [row (range 8)] 
        (vec (for [column (range 8)
                   piece [(get-piece :red row column (.-position game))]] 
                    (if (js/Boolean piece) 
                        (piece->clj piece)
                        (square position)))))))

(defn square [pos]
    {
        :position pos 
        :image nil
    })

(defn piece->clj [piece]
    {
        :name (-> piece .-type .toLowerCase)
        :color (.-color piece)
        :position (-> piece .-square .-coordinates)
    })

(defn piece? [{:keys [color name]}]
    (every? js/Boolean [color name]))

; TODO:
;  get the board in place, should be too hard overall
;  on the way there, you can figure out a good system of mutable->clojure
;  game->board is pretty cool (need which player, though, that should prolly be
;  parialied fn (get-piece player-color row column position) that's globally (partial get-piece player-color)
;  and useful throughout, at least when we need to aget something)
;  back to the topic, "board" should contain immutable clj maps: {:name (lowercase all names should allow image lookup)
;    :color "duh" :position (maybe)}, which should be fine (other stuff like legal moves, can be grabbed with
;  :position -> mutable stuff)
;
;  that's^ a good start


