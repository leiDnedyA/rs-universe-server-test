#lang racketscript/base

(require (for-syntax racketscript/base
                     syntax/parse)
         "universe-primitives.rkt"
         "jscommon.rkt")

; TODO:
; REFACTOR IMPLEMENTATION TO USE iWORLD DATATYPE
; implement the following handlers
; - on-new
; - on-msg
; - on-disconnect
; - state
; - to-string
; - port
; - check-with

(provide universe

         u-on-tick
         u-on-new
         
         bundle?
         make-bundle

         mail?
         make-mail)

(define peerjs ($/require "peerjs" *))
(define Peer #js.peerjs.Peer)

(define DEFAULT-UNIVERSE-ID "server") ;; Change this

(define *default-frames-per-second* 70)

;; Universe server
(define (make-universe init-state handlers)
  (new (Universe init-state handlers)))

(define (universe init-state . handlers)
  ($> (make-universe init-state handlers)
      (setup)
      (start)))

(define-proto Universe
  (λ (init-state handlers)
    #:with-this this
    (:= #js.this.state      init-state)
    (:= #js.this.interval   (/ 1000 *default-frames-per-second*))
    (:= #js.this.handlers   handlers)

    (:= #js.this.-active-handlers         ($/obj))
    (:= #js.this.-state-change-listeners  ($/array))
    (:= #js.this.-package-listeners       ($/array))

    (:= #js.this.-peer            $/undefined)
    (:= #js.this.-peer-init-tasks ($/array))

    (:= #js.this.-idle       #t)
    (:= #js.this.-stopped    #t)
    (:= #js.this.-events     ($/array)))
  [setup
   (λ ()
     #:with-this this
     (#js.this.register-handlers)
     this)]
  [register-handlers
   (λ ()
     #:with-this this
     (define active-handlers #js.this.-active-handlers)
     (let loop ([handlers #js.this.handlers])
       (when (pair? handlers)
         (define h ((car handlers) this))
         (#js.h.register)
         (:= ($ active-handlers #js.h.name) h)
         (loop (cdr handlers)))))]
  [deregister-handlers
   (λ ()
     #:with-this this
     (define active-handlers #js.this.-active-handlers)
     ($> (#js*.Object.keys active-handlers)
         (forEach
          (λ (key)
            (define h ($ active-handlers key))
            (#js.h.deregister)
            (:= ($ #js.active-handlers #js.h.name) *undefined*)))))]
  [start
   (λ ()
     #:with-this this
     (#js.this.init-peer-connection)
     0)]
  [stop
   (λ () 0)]
  [clear-event-queue
   (λ ()
     #:with-this this
     (#js.this.-events.splice 0 #js.this.-events.length))]
  [add-state-change-listener
   (λ () 0)]
  [remove-state-change-listener
   (λ () 0)]
  [queue-event
   (λ (e)
     #:with-this this
     (#js.this.-events.push e)
     (when #js.this.-idle
       (schedule-animation-frame #js.this 'process_events)))]
  [process-events
   (λ ()
      #:with-this this
      (define events #js.this.-events)
 
      (:= #js.this.-idle #f)
 
      (let loop ([state-changed? #f])
        (cond
          [(> #js.events.length 0)
           (define evt         (#js.events.shift))
           (define handler     ($ #js.this.-active-handlers #js.evt.type))
           (define changed?
             (cond
               ; raw evt must be checked 1st; bc handler will be undefined
               [(equal? #js.evt.type #js"raw")
                (#js.evt.invoke #js.this.state evt)]
               [(not ($/typeof handler "undefined"))
                (#js.handler.invoke #js.this.state evt)]
               [else
                (#js.console.warn "ignoring unknown/unregistered event type: " evt)]))
           (loop (or state-changed? changed?))]))
 
      (:= #js.this.-idle #t))]
    [change-state
     (λ (handler-result)
       #:with-this this
       
       ;; TODO - implement Bundle datatype and expect that to be
       ;; passed instead of new-state
       
       (define new-state (bundle-state handler-result))

       (define listeners #js.this.-state-change-listeners)
       (let loop ([i 0])
         (when (< i #js.listeners.length)
           (define listener ($ #js.listeners i))
           (listener new-state)
           (loop (add1 i))))
       (:= #js.this.state new-state))]
    [init-peer-connection
     (λ (id)
       #:with-this this
       (define peer (new (Peer DEFAULT-UNIVERSE-ID)))
       (:= #js.this.-peer peer)
       (#js.peer.on #js"open"
         (λ ()
           (define init-tasks #js.this.-peer-init-tasks)
           (let loop ([i 0])
            (when (< i #js.init-tasks.length)
             (define task ($ #js.init-tasks i))
             (task peer)
             (loop (add1 i)))))))]
    [add-peer-init-task
     (λ (cb) ;; cb = (peer: Peer) => void
       #:with-this this
       ;; If peer already exists, execute callback
       ;; else, append callback to this.-peer-init-tasks[]
       (define peer #js.this.-peer)
       (define peer-started? (not ($/typeof peer "undefined")))
       
       (if peer-started?
           (cb peer)
           (#js.this.-peer-init-tasks.push cb)))])

(define (u-id id-expr) ;; Allow users to specify the Peer ID of the universe
  0)

(define (u-on-tick cb rate)
  (λ (u)
    (define on-tick-evt ($/obj [type #js"on-tick"]))
    ($/obj
     [name         #js"on-tick"]
     [register     (λ ()
                     #:with-this this
                     (#js.u.queue-event on-tick-evt)
                     (if rate
                         (set! rate (* 1000 rate))
                         (set! rate #js.u.interval)))]
     [deregister   (λ ()
                     #:with-this this
                     (define last-cb #js.this.last-cb)
                     (when last-cb
                       ;; TODO: This sometimes doesn't work,
                       ;; particularly with high fps, so we need to do
                       ;; something at event loop itself.
                       (#js*.window.clearTimeout last-cb)))]
     [invoke       (λ (state _)
                     #:with-this this
                     (#js.u.change-state (cb state))
                     (:= #js.this.last-cb (#js*.setTimeout
                                            (λ ()
                                              (#js.u.queue-event on-tick-evt))
                                            rate))
                     #t)])))

(define (u-on-new cb)
  (λ (u)
    (define on-new-evt ($/obj [type #js"on-new"]))
    ($/obj
     [name         #js"on-new"]
     [register     (λ ()
                     #:with-this this
                     (:= #js.this.-active-conns ($/array))
                     (define (init-task peer)
                       (define (handle-connection conn)
                         ;; TODO: Add disconnect listener to conn
                         (#js.this.-active-conns.push conn)
                         (#js.u.queue-event ($/obj [type #js"on-new"]
                                                   [iWorld conn])))
                       (#js.peer.on #js"connection" handle-connection))
                     
                     (#js.u.add-peer-init-task init-task)
                     
                     (void))]
     [deregister   (λ () ;; TODO: implement this
                     #:with-this this
                     (void))]
     [invoke       (λ (state evt)
                     #:with-this this
                     (#js.u.change-state 
                      (cb state #js.evt.iWorld))
                     #t)])))