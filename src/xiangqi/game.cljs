(ns xiangqi.game
    (:require [xiangqi.info :refer [game-info]]))

(defn get-piece [row column pieces]
    (aget pieces (str column "," row))) 

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

(def ranges {
    "black" (range 8)
    "red" (range 7 -1 -1)
    })

(def player-range (ranges (@game-info :player-color)))

(defn game->board [game]
    (vec (for [row player-range] 
        (vec (for [column player-range
                   piece [(get-piece row column (.-position game))]] 
                    (if (js/Boolean piece) 
                        (piece->clj piece)
                        (square (str column "," row))))))))

(defn piece? [{:keys [color name]}]
    (every? js/Boolean [color name]))

