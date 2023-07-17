#lang racketscript/base

(require "universe.rkt"
         racketscript/htdp/image)

(provide start-universe-test)

(define (handle-new ws iw)
  (#js*.console.log (iworld-name iw))
  (make-bundle ws '() '()))

(define (start-universe-test)
  (universe 0
    [u-on-new handle-new]))