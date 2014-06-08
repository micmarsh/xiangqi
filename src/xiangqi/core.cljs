(ns xiangqi.core
    (:require [reagent.core :as r]
              [xiangqi.game :refer [game->board piece?]]))

(def game (js/Game.))

(set! *print-fn* #(.log js/console %))

(def numbers (iterate inc 0))
(defn enumerate [sequence]
    (map (fn [item index] [item index])
        sequence numbers))

(defn main-view [pieces]
    [:table 
        (for [[row index] (enumerate @pieces)]
           ^{:key index}
            [:tr
                (for [[square column] (enumerate row)]
                    ^{:key [index column]} 
                    ; TODO "square" means piece right now should be another kind
                    ; of squaure object that could possibly go here
                    [:td 
                    (when (piece? square)
                        [:img
                            {:src (str "assets/" (:color square) "/" 
                                    (:name square) ".png")}])])])])

(def pieces (-> game game->board atom))

(r/render-component
    [main-view pieces] 
    (.getElementById js/document "main"))

(aset js/window "setText" 
    (fn [row column text]
        (swap! pieces 
            (fn [pieces]
                (let [row-vec (pieces row)]
                    (assoc pieces row 
                        (assoc row-vec column text)))))))