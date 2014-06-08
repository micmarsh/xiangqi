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
(defn register-hash! [window]
    (->> js/window
        get-hash 
        (slice-from 1) 
        (swap! game-info assoc :id)))

(if (has-hash? js/window)
    (register-hash! js/window)
    (do 
        (set-hash! js/window (new-id))
        (register-hash! js/window)))