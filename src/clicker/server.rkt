#lang racketscript/base

(require "../universe.rkt"
         racket/list)

(provide start-universe)

(define clicks 0)

(define (mail-to-all ws content)
  (foldl (lambda (iw result)
           (cond [(number? iw) result]
                 [else (append result (list (make-mail iw content)))]))
         '()
         ws))

(define (handle-new u iw)
  (define u* (append u (list iw)))
  (define mails '())
  (define low-to-remove '())
  (make-bundle u* mails low-to-remove))

(define (handle-msg u iw msg)
  (define u* u)
  ($/:= clicks (add1 clicks))
  (define mails (mail-to-all u* clicks))
  (define low-to-remove '())
  (make-bundle u* mails low-to-remove))

(define (handle-disconnect u iw)
  (make-bundle u '() '()))

(define (start-universe)
  (universe '()
            [on-new        handle-new]
            [on-msg        handle-msg]
            [on-disconnect handle-disconnect]))