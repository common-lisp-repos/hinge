(defpackage hinge-system
  (:use :asdf))
(in-package :hinge-system)

(defsystem :hinge
  :description "A synonym for node. Something like an evented framework in and for CL."
  :version "0.0.1"
  :depends-on (:ev
               :zmq
               :closer-mop
               :bordeaux-threads
               :arnesi
               :log5
               :alexandria
               :iolib
               :uuid)

  :components ((:module "src" :components
                        ((:module "patches" :components
                                  ((:file "zmq")))

                         (:file "package" :depends-on ("patches"))
                         (:file "helpers" :depends-on ("package"))

                         ;; Basic reactor
                         (:file "hinge" :depends-on ("package" "helpers"))
                         (:file "generics" :depends-on ("package"))
                         (:file "methods" :depends-on ("generics" "hinge" "pool"))

                         ;; Async job pool
                         (:file "pool" :depends-on ("emitter"))

                         ;; Event emitter
                         (:file "emitter" :depends-on ("hinge" "generics"))

                         ;; Network
                         (:file "socket" :depends-on ("pool" "emitter"))
                         (:file "zmq-socket" :depends-on ("socket"))
                         (:file "server" :depends-on ("emitter" "helpers" "socket"))

                         (:module "http" :depends-on ("package" "server" "socket") :components
                                  ((:file "package")
                                   (:file "fsm" :depends-on ("package"))
                                   (:file "parser" :depends-on ("fsm"))
                                   (:file "request" :depends-on ("package"))
                                   (:file "http-server" :depends-on ("parser" "request"))))))))
