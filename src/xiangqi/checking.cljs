(ns xiangqi.checking
    (:require [cljs.core.async :refer (chan put! <!)])
    (:use-macros [cljs.core.async.macros :only (go go-loop)]))

(set! *print-fn* #(.log js/console %))

(def square-clicks (chan))

(go-loop [ ]
    (let [square (<! square-clicks)]
        (println square)
        (recur)))

