# Me and Functional Programming.



Some of you may know that I'm pretty interested in Functional Programming with some of the code that I write day to day having a somewhat functional style (while hopefully not being completely alien to our imperative friends). I have spent quite a bit of time trying to learn Haskell but recently things have changed a bit...

I started a new job two weeks ago and the company works in both JavaScript and Clojure. They hired me based primarily on my JavaScript skills but are very open to people moving between teams so I am going to be studying over the next few months with the hope of spending at least some of my time there writing Clojure. Exciting times!

Generally we learn by doing and I have a side project that I want to try and finish. It is primarily a front end project with some of the major components already wrote in JavaScript/Browserify but I will be trying to build at least some of it in Clojure. I acknowledge this may not be entirely sensible from a project stand point but I only have so much time.

I have spent a bit of time figuring out how to build node modules from Clojure code and I wanted to make some notes on how to do it.

The code itself (if you can call it that) is currently stored in `src-cljs/fireplace/core.js`. The magic bit is the `^:export` which tells the ClojureScript compiler that this is one of the functions which should be added to the `module.exports` of the compiled Node module:

```
(ns fireplace.core)

(defn ^:export times2 [x]
  (* 2 x)
  )

(defn -main [&args]
  (apply str (map [\ "world" "hello"] [2 0 1])))

(set! *main-cli-fn* -main)
```

Of course you have to tell [Leiningen](http://leiningen.org), which is the main Clojure build system, that you actually want to build ClojureScript (as opposed to Clojure) and the options to use. These are in the `cljsbuild` section of the `project.clj` file shown below:

```
(defproject fireplace "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "MIT" :url "http://opensource.org/licenses/MIT"}
  :dependencies [
                 [org.clojure/clojure "1.6.0"]
                 [org.clojure/clojurescript "0.0-2356"]
                 ]
  :plugins [ [lein-cljsbuild "1.0.3"] [lein-npm "0.4.0"] ]
  :cljsbuild {
              :builds [{
                        :source-paths ["src-cljs"]
                        :compiler {
                                   :output-to "war/javascripts/main.js"
                                   :optimizations :simple
                                   :target :nodejs
                                   :pretty-print true
                                   }
                        }
                       ]
              }
  :main ^:skip-aot fireplace.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}})
```

