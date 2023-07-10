#lang racketscript/base
(require "universe-server.rkt"
         "client.rkt"
         "server.rkt"
         racketscript/htdp/image)

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
  (lambda (_)
    (define name #js.username-input.value)
    (start-world ($/str "test"))
    (remove-setup)
    (set-title ($/str name))))

(#js.universe-button.addEventListener #js"click"
  (lambda (_)
    (start-universe)
    (remove-setup)
    (set-title "Server")))