#lang racketscript/base
(require "universe-server.rkt"
         "jscommon.rkt"
         racketscript/htdp/image)

(provide start-universe)

(define peerjs ($/require "peerjs" *))
(define Peer #js.peerjs.Peer)

;; Implementation of bouncing ball example from
;; 2htdp/universe docs
;; ( https://docs.racket-lang.org/teachpack/2htdpuniverse.html )
;; (ctrl + F search for "Designing the Ball World")

(define u-state '())

(define (add-world us iw)
  (append us (list iw)))

(define (universe-test init-state) ;; Test for world client features
  (define peer (new (Peer ($/str "server"))))

  (define (handle-world-connection conn)
    (#js.conn.on #js"open"
      (lambda (_)
        (#js*.console.log #js"user joined!")
        (set! u-state (add-world u-state conn)))))

  (#js.peer.on #js"open" 
    (λ ()
      (#js*.console.log (js-string "universe test started..."))
      (#js.peer.on #js"connection" handle-world-connection))))


(define (start-universe)
  ; (universe 0 [u-on-tick tick])
  (universe-test 0))