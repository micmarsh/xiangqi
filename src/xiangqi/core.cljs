(ns xiangqi.core
    (:require [reagent.core :as r]))

(set! *print-fn* #(.log js/console %))

(defn main-view [pieces]
    [:table 
        (for [row @pieces]
           ^{:key row} ; later: the actual index, row-col type  
            [:tr
                (for [square row]
                    ^{:key square} ; later: the actual row-col position, that won't ever change
                    [:td (or square "yo")])
            ]
            )])

(def pieces (r/atom (vec (for [row (range 8)] 
                        (vec (for [ column (range 8)] 
                            (str row "," column)))))))

(r/render-component
    [main-view pieces] 
    (.getElementById js/document "main"))

(aset js/window "setText" (fn [row column text]
    (swap! pieces (fn [pieces]
                    (let [row-vec (pieces row)]
                        (println row-vec row column)
                        (assoc pieces row (assoc row-vec column text)))))))