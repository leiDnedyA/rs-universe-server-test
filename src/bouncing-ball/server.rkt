#lang racketscript/base

(require racketscript/htdp/peer-universe
         racketscript/htdp/image
         racket/list)

(provide start-universe)

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
  (define mails (make-curr-mail ws*))
  (define to-remove '())
  (make-bundle ws* mails to-remove))

(define (handle-tick ws)
  (make-bundle ws '() '()))

(define (start-universe root)
  (universe '() #:dom-root root
    [on-new        handle-new]
    [on-msg        handle-msg]
    [on-tick       handle-tick]
    [on-disconnect handle-disconnect]))