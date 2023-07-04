#lang racketscript/base
(require "universe-server.rkt")

(define (tick w) 
    w)

(big-bang 0 [on-tick tick])