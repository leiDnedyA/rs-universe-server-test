#lang racketscript/base

(require "universe.rkt"
         racketscript/htdp/image
         racket/list)

(provide start-universe-test)

(define (make-curr-mail ws)
  (define curr-iw (first ws))
  ; (#js*.console.log ($/str (iworld-name curr-iw)))
  (list (make-mail curr-iw #js"it-is-your-turn")))

(define (handle-new ws iw)
  (define ws* (append ws (list iw)))
  (define mails (make-curr-mail ws*))
  (define to-remove '())
  (make-bundle ws* mails to-remove))

(define (handle-msg ws iw msg)
  (define ws* (append (rest ws) (list (first ws))))
  (define mails (make-curr-mail ws*))
  (define to-remove '())
  (make-bundle ws* mails to-remove))

(define (handle-disconnect ws iw)
  (define ws* (remove iw ws))
  (#js*.console.log (length ws*))
  (define mails (make-curr-mail ws*))
  (define to-remove '())
  (make-bundle ws* mails to-remove))

(define (start-universe-test)
  (universe '()
    [u-on-new        handle-new]
    [u-on-msg        handle-msg]
    [u-on-disconnect handle-disconnect]))