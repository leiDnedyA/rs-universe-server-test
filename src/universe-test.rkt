#lang racketscript/base

(require "universe.rkt"
         racketscript/htdp/image
         racket/list)

(provide start-universe-test)

(define (tick ws)
  (make-bundle ws '() '()))

(define (handle-new ws iw)
  (define m (make-mail iw #js"test"))
  (define ws* (append ws (list iw)))
  (define ws-len (length ws*))
  (define to-remove '())
  (if (> ws-len 3)
      (begin
        (set! to-remove (list (first ws*)))
        (set! ws* (rest ws*)))
      (void))
  (make-bundle ws* (list m) to-remove))

(define (start-universe-test)
  (universe '()
    [u-on-new handle-new]
    [u-on-tick tick]))