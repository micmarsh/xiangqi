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
;  now make an "admin" or "logistics" namespace that sets up the route and gets the right color
;  from localstorage and everything, provides constants for everywhere else to use
;  then actual clicking and move checking, woah


