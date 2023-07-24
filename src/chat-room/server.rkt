#lang racketscript/base

(require "../universe.rkt"
         racketscript/htdp/image)

(provide start-universe)

;; Example based on https://course.khoury.northeastern.edu/cs5010sp15/set08.html

;; WorldState:
;; (list ListOf<iWorld> ListOf<EventMessage>)

;; TODO:
;; Create methods to:
;; - generate mails for all clients
;; - add event to the event list

(define (make-client-list ws)
  (format "[~a]" (foldl (lambda (iw result)
                          (#js*.console.log (iworld-name iw))
                          (string-append result (format "~s, " (iworld-name iw))))
                        ""
                        ws)))

(define (handle-new ws iw)
  (define ws* (append ws (list iw)))
  (#js*.console.log (js-string (make-client-list ws*)))
  (define mails '())
  (define to-remove '())
  (make-bundle ws* mails to-remove))

(define (handle-msg ws iw msg)
  (define ws* '())
  (define mails '())
  (define to-remove '())
  (make-bundle ws* mails to-remove))

(define (handle-disconnect ws iw)
  (define ws* '())
  (define mails '())
  (define to-remove '())
  (make-bundle ws* mails to-remove))

(define (start-universe)
  (universe '()
    [u-on-new        handle-new]
    [u-on-msg        handle-msg]
    [u-on-disconnect handle-disconnect]))