#lang racketscript/base

(require "../universe.rkt"
         racketscript/htdp/image)

(provide start-world)

(define init-state 0)

(define (draw state)
  (text (format "Score: ~a" (number->string state)) 20 "black"))

(define (handle-key state key)
  (cond
    [(key=? key " ") (make-package state 'click)]
    [else state]))

(define (handle-receive state msg)
  msg)

(define (start-world username)
  (big-bang 0
    [to-draw draw]
    [on-key handle-key]
    [on-receive handle-receive]
    [name username]
    [register "server"]))