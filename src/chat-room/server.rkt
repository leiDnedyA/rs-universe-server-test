#lang racketscript/base

(require "../universe.rkt"
         "util.rkt"
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
  (define count 0)
  (format "[~a]" (foldl (lambda (iw result)
                          (set! count (+ 1 count))
                          (if (equal? count (length ws))
                              (string-append result (format "~s" (iworld-name iw)))
                              (string-append result (format "~s, " (iworld-name iw)))))
                        ""
                        ws)))

(define (make-broadcast sender msg)
  (format "[]"))

(define (mail-to-all ws content)
  (foldl (lambda (iw result)
           (append result (list (make-mail iw content))))
         '()
         ws))

(define (client-list-mails ws)
  (define client-list (make-client-list ws))
  (mail-to-all ws (msg-from-server "userlist" client-list)))

;; type: string, content: any(if string, wrap in quotes), sender: string
(define (msg-from-server type content [sender ""])
  ; (js-string (format "{ \"type\": ~s, \"content\": ~a, \"sender\": ~s}" type content sender))
  (encode-data (list type content sender)))

(define (handle-new ws iw)
  (define ws* (append ws (list iw)))
  (define mails (client-list-mails ws*))
  (define to-remove '())
  (make-bundle ws* mails to-remove))

(define (handle-msg ws iw msg)
  (define msg-mail (msg-from-server "broadcast" (format "\"~a\"" msg) (iworld-name iw)))
  (define ws* ws)
  (define mails (mail-to-all ws* msg-mail))
  (define to-remove '())
  (make-bundle ws* mails to-remove))

(define (handle-disconnect ws iw)
  (define ws* (remove iw ws))
  (define mails (client-list-mails ws*))
  (define to-remove '())
  (make-bundle ws* mails to-remove))

(define (start-universe)
  (universe '()
    [u-on-new        handle-new]
    [u-on-msg        handle-msg]
    [u-on-disconnect handle-disconnect]))