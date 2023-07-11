#lang racketscript/base
(require "universe-server.rkt"
         racketscript/htdp/image)

(provide start-world)

;; Implementation of bouncing ball example from
;; 2htdp/universe docs
;; ( https://docs.racket-lang.org/teachpack/2htdpuniverse.html )
;; (ctrl + F search for "Designing the Ball World")

(define SPEED 5)
(define RADIUS 10)
(define WORLD0 'RESTING)

(define WIDTH 600)
(define HEIGHT 400)
(define MT (empty-scene WIDTH HEIGHT))
(define BALL (circle RADIUS 'solid 'blue))

(define (move ws)
  (define is-active (number? ws))
  (if is-active
    (if (<= ws 0)
        (make-package 'RESTING #js"done")
        (- ws SPEED))
    ws))

(define (draw ws)
  (cond
    [(number? ws) (underlay/xy MT 50 ws BALL)]
    [else (underlay/xy MT 50 50 (text "Resting" 24 'blue))]))

;; The only message that the server send is the your-turn one,
;; so this will always return HEIGHT as the next world state
(define (receive ws msg)
  (if ($/typeof msg "string")
      HEIGHT
      ws))

(define (start-world name)
    (big-bang WORLD0 [on-tick move] [to-draw draw] [on-receive receive]))