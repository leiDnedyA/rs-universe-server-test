#lang racketscript/base
(require "universe-server.rkt"
         racketscript/htdp/image)

(provide start-universe)

;; Implementation of bouncing ball example from
;; 2htdp/universe docs
;; ( https://docs.racket-lang.org/teachpack/2htdpuniverse.html )
;; (ctrl + F search for "Designing the Ball World")

(define (start-universe)
  ; (universe 0 [u-on-tick tick])
  (universe-test 0))