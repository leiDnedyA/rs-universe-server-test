#lang racketscript/base
(require "universe-server.rkt"
         "client.rkt"
         "server.rkt"
         racketscript/htdp/image)

; TODO:

; - Figure out a way to configure Peer server to not allow custom IDs
; - write a test for on-receive deregister
; - implement features to handle client disconnections
; - implement universe/server
; - write macros to convert handler names passed to universe function 
;   to universe-specific ones
;   e.g (universe (on-tick tick)) -> (universe* (u-on-tick tick))
;   do some bug testing

(define world-form (#js*.document.querySelector #js"#world-form"))
(define username-input (#js*.document.querySelector #js"#username-input"))
(define universe-button (#js*.document.querySelector #js"#universe-button"))

(define (remove-setup)
  (define setup-div (#js*.document.querySelector #js"#setup-div"))
  (#js.setup-div.remove))

(define (set-title str)
  (define page-title (#js*.document.querySelector #js"title"))
  ($/:= #js.page-title.innerHTML (js-string str)))

(#js.world-form.addEventListener #js"submit"
  (lambda (e)
    (define name #js.username-input.value)
    (start-world ($/str "test"))
    (remove-setup)
    (set-title ($/str name))))

(#js.universe-button.addEventListener #js"click"
  (lambda ()
    (start-universe)
    (remove-setup)
    (set-title "Server")))

; (start-world #js"test")