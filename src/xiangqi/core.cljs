(ns xiangqi.core
    (:require [reagent.core :as r]))

(defn main-view [pieces])

(r/render-component
    [main-view (r/atom { })] 
    (.getElementById js/document "main"))