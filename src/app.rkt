#lang racketscript/base
(require racketscript/htdp/peer-universe
        ;  "chat-room/client.rkt"
        ;  "chat-room/server.rkt"
        ;  "clicker/client.rkt"
        ;  "clicker/server.rkt"
        "bouncing-ball/client.rkt"
        "bouncing-ball/server.rkt"
         racketscript/htdp/image)

; TODO:

; - Try and reproduce bug with bouncing ball example
; - document any deviations from the htdp/universe API (e.g register to peer id instead of ip)
; - consider reworking implementation of package datatype
;   to be like the bundle and mail implementations (w/ aliases)
; - Investigate bug: requestanimationframe not working when window is hidden?
; - Figure out a way to configure Peer server to not allow custom IDs in client code

(define root (#js*.document.querySelector #js"#root"))

(create-login-form start-world start-universe root)