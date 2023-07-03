#lang racketscript/base
(require "rs-universe.rkt")

(define (tick w) 
    (#js*.console.log (js-string (string-append "Hello world" (number->string w))))
    (+ w 1))

(big-bang* 0 #:on-tick tick)