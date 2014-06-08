(ns xiangqi.info
    (:use-macros [xiangqi.macros :only [get-hash]]))

(defn new-id []
    (-> (.random js/Math)
        .toString
        (.slice 2 10)))

(defn has-hash? [window]
    (-> window get-hash (not= "")))

(defn set-hash! [window id]
    (set! (get-hash window) id))

(def game-info (atom { }))

(def slice-from #(.slice %2 %1))
(defn register-hash! [window game-info]
    (->> js/window
        get-hash 
        (slice-from 1) 
        (swap! game-info assoc :game-id)))

(defn color-key [id]
    (str game-id "-player-color"))

(defn get-color [window]
    (-> window 
        .-localStorage 
        (aget (color-key game-id))))

(defn has-color? [window game-id]
    (-> window get-color js/Boolean)

(defn set-color! [window id player-color]
    (aset (.-localStorage window)
        (color-key id)
        player-color))

(defn register-color! [window]
    (let [color (get-color window)]
        (swap! game-info assoc :player-color color)))

(if (has-hash? js/window)
    (register-hash! js/window game-info)
    (do 
        (set-hash! js/window (new-id))
        (register-hash! js/window) game-info))