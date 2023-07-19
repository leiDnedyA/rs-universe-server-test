#lang racketscript/base

(require "../universe.rkt"
         racketscript/htdp/image)

(provide start-world)

;; Example based on https://course.khoury.northeastern.edu/cs5010sp15/set08.html

;; UserName
;; String of only letters and numbers between 1 and 12 chars long

;; MsgFromServer
;; (list 'userlist ListOf<UserName>) ;; don't include in event-messages
;; (list 'join UserName)
;; (list 'leave UserName)
;; (list 'error Message)
;; (list 'private UserName Message) ;; a private msg from a user
;; (list 'broadcase UserName Message) ;; a public msg from a user

;; WorldState
;; (list client-name<UserName> connected-users<ListOf<UserName>> event-messages<ListOf<MsgFromServer>>)

(define (get-client-name ws)
  (list-ref ws 0))

(define (get-connected-users ws)
  (list-ref ws 1))

(define (get-event-messages ws)
  (list-ref ws 2))

;; 100x400px column displaying names sorted alphabetically
(define (participant-names-column names)
  (rectangle 100 400 'outline 'black))

(define (message-textbox curr-text cursor-pos)
  0) ;; 300x20px row displaying the current user input

(define (message-log-display message-list event-list)
  0) ;; 200x380px box displaying log of messages and events

(define (draw ws)
  (participant-names-column (get-connected-users ws)))

(define (start-world username)
  (big-bang (list username '() '())
    [to-draw draw]))