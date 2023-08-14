#lang racketscript/base
(require racketscript-universe
         "chat-room/client.rkt"
         "chat-room/server.rkt"
        ;  "clicker/client.rkt"
        ;  "clicker/server.rkt"
        ; "bouncing-ball/client.rkt"
        ; "bouncing-ball/server.rkt"
         racketscript/htdp/image)

; TODO:

; - Try and reproduce bug with bouncing ball example
; - document any deviations from the htdp/universe API (e.g register to peer id instead of ip)
; - consider reworking implementation of package datatype
;   to be like the bundle and mail implementations (w/ aliases)
; - Investigate bug: requestanimationframe not working when window is hidden?
; - Figure out a way to configure Peer server to not allow custom IDs in client code

(define world-form (#js*.document.querySelector #js"#world-form"))
(define username-input (#js*.document.querySelector #js"#username-input"))
(define universe-button (#js*.document.querySelector #js"#universe-button"))

(define root (#js*.document.querySelector #js"#root"))

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
    (start-world name root)
    (remove-setup)
    (set-title ($/str name))))

($/:= #js*.window.startWorld start-world)

(#js.universe-button.addEventListener #js"click"
  (lambda ()
    (start-universe root)
    (remove-setup)
    (set-title "Server")))