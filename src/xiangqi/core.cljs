(ns xiangqi.core
    (:require [reagent.core :as r]))

(set! *print-fn* #(.log js/console %))

(def numbers (iterate inc 0))
(defn enumerate [sequence]
    (map (fn [item index] [item index])
        sequence numbers))

(defn main-view [pieces]
    [:table 
        (for [[row index] (enumerate @pieces)]
           ^{:key index} ; later: the actual index, row-col type  
            [:tr
                (for [[square column] (enumerate row)]
                    ^{:key [index column]} ; later: the actual row-col position, that won't ever change
                    [:td [:img {:src "assets/red/cannon.png"}]])])])

(def pieces (r/atom (vec (for [row (range 8)] 
                        (vec (for [column (range 8)] 
                            (str row "," column)))))))

(r/render-component
    [main-view pieces] 
    (.getElementById js/document "main"))

(aset js/window "setText" (fn [row column text]
    (swap! pieces (fn [pieces]
                    (let [row-vec (pieces row)]
                        (assoc pieces row 
                            (assoc row-vec column text)))))))