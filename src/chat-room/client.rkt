#lang racketscript/base

(require "../universe.rkt"
         "util.rkt"
         racketscript/htdp/image)

(provide start-world)

;; Example based on https://course.khoury.northeastern.edu/cs5010sp15/set08.html

;; UserName
;; String of only letters and numbers between 1 and 12 chars long

;; MsgFromServer
;; (list "userlist" ListOf<UserName>) ;; don't include in event-messages
;; (list "join" UserName)
;; (list "leave" UserName)
;; (list "error" Message)
;; (list "private" UserName Message) ;; a private msg from a user
;; (list "broadcast" UserName Message) ;; a public msg from a user

;; WorldState
;; (list client-name<UserName> connected-users<ListOf<UserName>> event-messages<ListOf<MsgFromServer>> curr-input<String>)

(define TEST-WORLD (list "Ayden" 
                         (list "Bob" "Josh" "Ken" "Cindy" "Lucy" "Crystal" "Ayden")
                         (list (list "join" "Ayden")
                               (list "join" "Crystal")
                               (list "broadcast" "Crystal" "Hey guys")
                               (list "private" "Crystal" "Hey dude")
                               (list "error" "Error test")
                               (list "leave" "Crystal")
                               (list "join" "Ayden")
                               (list "join" "Crystal")
                               (list "broadcast" "Crystal" "Hey guys")
                               (list "private" "Crystal" "Hey dude")
                               (list "error" "Error test")
                               (list "leave" "Crystal")
                               (list "join" "Ayden")
                               (list "join" "Crystal")
                               (list "broadcast" "Crystal" "Hey guys")
                               (list "private" "Crystal" "Hey dude")
                               (list "error" "Error test")
                               (list "leave" "Crystal")
                               (list "join" "Ayden")
                               )
                         "Hey what's up!"))

(define FONT-SIZE 12)
(define MARGIN 3)
(define MT (empty-scene 400 400))
(define CHARS-PER-LINE 44) ;; max chars that can fit in the input box
(define MAX-MESSAGES 25)

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

;; 300x380px box displaying log of messages and events
(define (message-log-display event-list username)
  (define background (rectangle 300 380 'outline 'black))
  (define count 0)
  (foldl (lambda (evt res)
           (define evt-type (list-ref evt 0))
           (define (add-text img)
             (define new-res (underlay/xy res MARGIN (+ (* count FONT-SIZE) (* (+ count 1) MARGIN)) img))
             (set! count (+ count 1))
             new-res)
           (define (message-text user msg color)
              (text (format "<~a> ~a" user msg) FONT-SIZE color))
           (case evt-type
                 [("broadcast") (add-text (message-text (list-ref evt 1)
                                                        (list-ref evt 2)
                                                        'black))]
                 [("private")   (add-text (message-text (format "~a->~a" (list-ref evt 1) username)
                                                        (list-ref evt 2)
                                                        'blue))]
                 [("join")      (add-text (text (format "~a joined."        (list-ref evt 1))
                                                FONT-SIZE
                                                'gray))]
                 [("leave")     (add-text (text (format "~a left the chat." (list-ref evt 1))
                                                FONT-SIZE
                                                'gray))]
                 [("error")     (add-text (text (list-ref evt 1) FONT-SIZE 'red))]
                 [else res]))
         background
         (if (> (length event-list) MAX-MESSAGES)
             (slice-list event-list 
                         (- (length event-list) MAX-MESSAGES)
                         (length event-list))
             event-list)))

(define (draw ws)
  (define textbox (message-textbox          (get-curr-input ws)))
  (define users   (participant-names-column (get-connected-users ws)))
  (define log     (message-log-display      (get-event-messages ws) (get-client-name ws)))

  (underlay/xy (underlay/xy (underlay/xy MT 0 0 users)
                            100 380
                            textbox)
               100 0
               log))

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
  (if (key=? k "\r")
      (make-package (list (get-client-name ws)
                          (get-connected-users ws)
                          (get-event-messages ws)
                          "")
                    curr-text)
      (list (get-client-name ws)
            (get-connected-users ws)
            (get-event-messages ws)
            new-text)))

(define (start-world username)
  (big-bang (list username '() '())
    [to-draw draw]))

(big-bang TEST-WORLD
  [to-draw draw]
  [on-key handle-key])