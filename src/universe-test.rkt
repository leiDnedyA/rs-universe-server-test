#lang racketscript/base

(require "universe-server.rkt"
         racketscript/htdp/image)

(provide start-universe-test)

(define (tick ws)
  (#js*.console.log ws)
  (add1 ws))

(define (start-universe-test)
  (universe '() [u-on-tick tick]))