(ns xiangqi.core
    (:require [reagent.core :as r]
              [xiangqi.game :refer [game->board piece?]]
              [xiangqi.checking :refer [game square-clicks]]
              [cljs.core.async :refer [put!]]))

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
                    [:td {:on-click #(put! square-clicks square)}
                    (when (piece? square)
                        [:img
                            {:src (str "assets/" 
                                    (:color square) "/" 
                                    (:name square) ".png")}])])])])

(def pieces (-> game game->board atom))

(r/render-component
    [main-view pieces] 
    (.getElementById js/document "main"))

(aset js/window "setText" 
    (fn [row column text]
        (swap! pieces 
            (fn [pieces]
                (assoc-in pieces [row column] text)))))