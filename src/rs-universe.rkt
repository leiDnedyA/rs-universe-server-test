#lang racketscript/base

(provide big-bang*
        ;  big-bang
         )

; (define-syntax (big-bang stx)
;   (syntax-parse stx
;     [(_ (clause val)...)
;      #'(big-bang* (create-clause clause val) ...)
;      ]))

; TODO: figure out how to take clauses instead of keyword args
(define (big-bang* w #:on-tick [on-tick (lambda (_ w) (w))])
    (#js*.setInterval (lambda (_) (set! w (on-tick w))) 1000))