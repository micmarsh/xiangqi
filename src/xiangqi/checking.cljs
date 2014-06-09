(ns xiangqi.checking
    (:require [cljs.core.async :refer (chan put! <!)]
              [xiangqi.game :refer (piece?)]
              [reagent.core :as r])
    (:use-macros [cljs.core.async.macros :only (go go-loop)]))

(set! *print-fn* #(.log js/console %))

(def game (js/Game.))
(def current-piece (r/atom nil))
(def square-clicks (chan))
(def legal-moves (chan))

(defn get-move [square]
    (map :position [@current-piece square]))

(defn js-any? [pred array]
    (> (.-length (.filter array pred)) 0))

(defn legal? [game from to]
    (let [legal-moves (.-legalMoves game)
          moves-to (aget legal-moves from)]
        (and (js/Boolean moves-to)
             (js-any? #(= % to) moves-to))))

(defn check-move [square]
    (let [[from to] (get-move square)
          return (chan)]
        (put! return (legal? game from to))
        return))

(go-loop [ ]
    (let [square (<! square-clicks)]
        (println square)
        (cond 
            (piece? square)
                (reset! current-piece square)
            @current-piece
                (do 
                    (when (<! (check-move square))
                        (put! legal-moves (get-move square)))
                    (reset! current-piece nil)))
        (recur)))

(go-loop [ ]
    (println (<! legal-moves))
    (recur))
