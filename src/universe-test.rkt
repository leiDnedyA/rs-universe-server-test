#lang racketscript/base

(require "universe-server.rkt"
         racketscript/htdp/image)

(provide start-universe-test)

(define (tick ws)
  (#js*.console.log ws)
  (make-bundle (add1 ws) '() '()))

(define (start-universe-test)
  (universe 0 [u-on-tick tick]))