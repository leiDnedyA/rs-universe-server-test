#lang racketscript/base
(require "universe.rkt"
         "client.rkt"
         "server.rkt"
         "universe-test.rkt" ;; Remove when done testing universe implementation
         racketscript/htdp/image)

; TODO:

; - features to handle client disconnections
; - implement world names
; - Universe UI interface
; - consider reworking implementation of package datatype
;   to be like the bundle and mail implementations (w/ aliases)
; - Work on implementing missing API features (consider doing chat-room example as test)
; - document any deviations from the htdp/universe API (e.g register to peer id instead of ip)
; - write macros to convert handler names passed to universe function 
;   to universe-specific ones
;   e.g (universe (on-tick tick)) -> (universe* (u-on-tick tick))
;   do some bug testing
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

(#js.world-form.addEventListener #js"submit"
  (lambda (e)
    (define name #js.username-input.value)
    (start-world ($/str "test"))
    (remove-setup)
    (set-title ($/str name))))

(#js.universe-button.addEventListener #js"click"
  (lambda ()
    (start-universe-test)
    ; (start-universe)
    (remove-setup)
    (set-title "Server")))