(ns xiangqi.game
    (:require [xiangqi.info :refer [game-info]]))

(defn get-piece [player row column pieces]
    (let [offset? (= player "red")
          row (if offset? (- 7 row) row)
          column (if offset? (- 7 column) column)]
        (aget pieces (str column "," row))))

(def find-piece (partial get-piece (:player-color @game-info)))

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

(defn game->board [game]
    (vec (for [row (range 8)] 
        (vec (for [column (range 8)
                   piece [(find-piece row column (.-position game))]] 
                    (if (js/Boolean piece) 
                        (piece->clj piece)
                        (square (str column "," row))))))))

(defn piece? [{:keys [color name]}]
    (every? js/Boolean [color name]))

