#lang racketscript/base

(require "universe.rkt"
         racketscript/htdp/image)

(provide start-universe-test)

(define (handle-new ws iw)
  (define m (make-mail iw #js"test"))
  (make-bundle ws (list m) '()))

(define (start-universe-test)
  (universe 0
    [u-on-new handle-new]))