(ns xiangqi.info
    (:use-macros [xiangqi.macros :only [get-hash]]))

(set! *print-fn* #(.log js/console %))

(defn new-id []
    (-> (.random js/Math)
        .toString
        (.slice 2 10)))

(defn has-hash? [window]
    (-> window get-hash (not= "")))

(defn set-hash! [window id]
    (-> window get-hash (set! id)))

(def game-info (atom { }))

(def slice-from #(.slice %2 %1))
(defn register-hash! [window game-info]
    (->> js/window
        get-hash 
        (slice-from 1) 
        (swap! game-info assoc :game-id)))

(defn color-key [id]
    (str game-id "-player-color"))

(defn get-color [window game-id] 
    (-> window 
        .-localStorage 
        (aget (color-key game-id))))

(def get-id #(.slice (get-hash %) 1))

(defn has-color? [window]
    (let [game-id (get-id window)]
        (-> window 
            (get-color window game-id) 
            js/Boolean)))

(defn set-color! [window player-color]
    (let [id (get-id window)]
        (aset (.-localStorage window)
            (color-key id)
            player-color)))

(defn register-color! [window game-info]
    (let [game-id (get-id window)
          color (get-color window game-id)]
        (swap! game-info assoc :player-color color)))

(defn color-checking! [window default]
    (println (get-id window))
    (if (has-color? window)
        (register-color! window game-info)
        (do
            (set-color! window default)
            (register-color! window game-info))))

(let [window js/window]
    (if (has-hash? window)
        (do 
            (register-hash! window game-info)
            (color-checking! window "black"))
        (do 
            (set-hash! js/window (new-id))
            (color-checking! window "red")
            (register-hash! window game-info))))
