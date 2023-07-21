#lang racketscript/base

(require "../universe.rkt"
         "util.rkt"
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
;; (list client-name<UserName> connected-users<ListOf<UserName>> event-messages<ListOf<MsgFromServer>> curr-input<String>)

(define TEST-WORLD (list "Ayden" (list "Bob" "Josh" "Ken" "Cindy" "Lucy" "Crystal" "Ayden") '() ""))

(define FONT-SIZE 12)
(define MARGIN 3)
(define MT (empty-scene 400 400))
(define CHARS-PER-LINE 44) ;; max chars that can fit in the input box

(define (get-client-name ws)
  (list-ref ws 0))

(define (get-connected-users ws)
  (list-ref ws 1))

(define (get-event-messages ws)
  (list-ref ws 2))

(define (get-curr-input ws)
  (list-ref ws 3))

;; 100x400px column displaying names sorted alphabetically
(define (participant-names-column names)
  (define container (rectangle 100 400 'outline 'black))
  (define i 0)
  (foldl (lambda (name res)
           (define name-text (text name FONT-SIZE 'black))
           (define col (underlay/xy res 
                                    MARGIN (+ MARGIN (* i 20))
                                    name-text))
           (set! i (+ i 1))
           col)
         container
         names))

;; 300x20px row displaying the current user input
(define (message-textbox curr-text cursor-pos)
  (define container  (rectangle 300 20 'outline 'black))
  (define text-len (string-length curr-text))
  (define input-text (text (if (> text-len CHARS-PER-LINE)
                               (substring curr-text (- text-len CHARS-PER-LINE) text-len)
                               curr-text)
                           FONT-SIZE
                           'black))

  (underlay/xy container MARGIN MARGIN input-text))

(define (message-log-display message-list event-list)
  0) ;; 200x380px box displaying log of messages and events

(define (draw ws)
  (define textbox (message-textbox (get-curr-input ws)))
  (define users   (participant-names-column (get-connected-users ws)))

  (underlay/xy
   (underlay/xy MT 0 0 users)
   100 380
   textbox))

(define (handle-key ws k)
  (define curr-text (get-curr-input ws))
  (define new-text (cond
                    [(> (string-length k) 1) curr-text]
                    [(key=? k "\b") (if (<= (string-length curr-text) 0)
                                          curr-text
                                          (substring curr-text
                                                     0
                                                     (- (string-length curr-text) 1)))]
                    [else (string-append curr-text k)]))
  (#js*.console.log (string-length new-text))
  (list (get-client-name ws)
        (get-connected-users ws)
        (get-event-messages ws)
        new-text))

(define (start-world username)
  (big-bang (list username '() '())
    [to-draw draw]))

; (#js*.console.log (draw TEST-WORLD))

(big-bang TEST-WORLD
  [to-draw draw]
  [on-key handle-key])