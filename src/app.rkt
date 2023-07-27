#lang racketscript/base
(require "universe.rkt"
         "chat-room/client.rkt"
         "chat-room/server.rkt"
        ; "bouncing-ball/client.rkt"
        ; "bouncing-ball/server.rkt"
        "universe_modules/encode-decode.rkt"
         "universe_modules/debug-tools.rkt"
         racketscript/htdp/image)

; TODO:

; - Look into design patterns for handling user disconnections (e.g user timeout)
;     - look into universe implementation
;     - figure out standard accepted way for distributed programs to handle the problem
; - Encoding/decoding: Add more error messages if the user tries to encode an unsupported type
;     - Support encoding and decoding racket primitives within js objects. e.g {"name": 'Darius}
;     - Add better type safety / check if data is plain obj or is instance of class
; - Universe UI interface
; - Work on implementing missing API features (consider doing chat-room example as test)
; - write macros to convert handler names passed to universe function 
;   to universe-specific ones
;   e.g (universe (on-tick tick)) -> (universe* (u-on-tick tick))
; - document any deviations from the htdp/universe API (e.g register to peer id instead of ip)
; - consider reworking implementation of package datatype
;   to be like the bundle and mail implementations (w/ aliases)
; - Investigate bug: requestanimationframe not working when window is hidden?
; - Figure out a way to configure Peer server to not allow custom IDs in client code

(define world-form (#js*.document.querySelector #js"#world-form"))
(define username-input (#js*.document.querySelector #js"#username-input"))
(define universe-button (#js*.document.querySelector #js"#universe-button"))

(define (remove-setup)
  (define setup-div (#js*.document.querySelector #js"#setup-div"))
  (#js.setup-div.remove))

(define (set-title str)
  (define page-title (#js*.document.querySelector #js"title"))
  ($/:= #js.page-title.innerHTML (js-string str)))

($/:= #js*.window.startClient
  (lambda ()
    (remove-setup)
    (start-world ($/str "test"))))

(#js.world-form.addEventListener #js"submit"
  (lambda (e)
    (define name #js.username-input.value)
    (start-world name)
    (remove-setup)
    (set-title ($/str name))))

(#js.universe-button.addEventListener #js"click"
  (lambda ()
    (start-universe)
    (remove-setup)
    (set-title "Server")))

(test-encoding "test")
(test-encoding 'Test)
(test-encoding ($/obj [val "Hello world"]))
(test-encoding ($/null))
(test-encoding ($/undefined))