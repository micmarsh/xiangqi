(ns xiangqi.macros)

(defmacro get-hash [window]
    `(-> ~window
        .-location
        .-hash))
