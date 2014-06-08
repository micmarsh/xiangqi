(defproject xiangqi "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojurescript "0.0-2069"]
                 [org.clojure/clojure "1.5.1"]
                 [reagent "0.4.2"]]

  :plugins [[lein-cljsbuild "1.0.0"]]

  :cljsbuild
      {:builds [{:source-paths ["src/xiangqi"]
                   :compiler
                     {:preamble ["reagent/react.min.js"]
                      :output-to "resources/main.js"
                      :pretty-print true}}]}))
