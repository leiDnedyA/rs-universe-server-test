#lang racketscript/base

(require "universe-server.rkt"
         racketscript/htdp/image)

(provide start-universe-test)

(define (handle-new ws iw)
  (#js*.console.log iw)
  (make-bundle ws '() '()))

(define (start-universe-test)
  (universe 0 [u-on-new handle-new]))