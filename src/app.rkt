#lang racketscript/base
(require "universe-server.rkt"
         racketscript/htdp/image)

(define (tick w) 
    ; (#js*.console.log w)
    (+ w 1))

; (define (draw w)
;     (rectangle 200 200 'solid 'blue))

; (big-bang 0 [on-tick tick] [to-draw draw])

(universe 0 [u-on-tick tick])