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

(defn capitalize [[letter & tail]]
    (apply str (.toUpperCase letter) tail))

(defn clj->piece [{:keys [name color position] :as piece}]
    (let [constructor (aget js/window (capitalize name))]
        (new constructor color
            (.split position ","))))

(def ranges {
    "black" (range 8)
    "red" (range 7 -1 -1)
    })

(def player-range (ranges (@game-info :player-color)))

(defn game->clj [game]
    (vec (for [row player-range] 
        (vec (for [column player-range
                   piece [(get-piece row column (.-position game))]] 
                    (if (js/Boolean piece) 
                        (piece->clj piece)
                        (square (str column "," row))))))))

(defn clj->game [board turn]
    (let [game (js/Game.)
          position (js/Position.)]
        (doseq [row board
                square row]
                (when (piece? square)
                    (.place position
                        (clj->piece square))))
        (set! (.-toMove position) turn)
        (.importPosition game position)
        game)) 

(defn piece? [{:keys [color name]}]
    (every? js/Boolean [color name]))
