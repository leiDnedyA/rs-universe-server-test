#lang racketscript/base

(require (for-syntax racketscript/base
                     syntax/parse)
         "encode-decode.rkt"
         "debug-tools.rkt"
         "universe-primitives.rkt"
         "jscommon.rkt")

(provide server-gui)

(define DEFAULT-DISPLAY-MODE #js"block")
(define WIDTH 500)
(define HEIGHT 300)

(define-proto ServerLogger
  (λ (root)
    #:with-this this

    ; <div id="server-logger-container">
    ;     <textbox>logged text</textbox>
    ;     <div class="button-container">
    ;         <button>stop</button>
    ;         <button>stop and restart</button>
    ;     </div>
    ; </div>
    (:= #js.this.logs  ($/array))

    (:= #js.this.container  (#js*.document.createElement #js"div"))
    (:= #js.this.textbox    (#js*.document.createElement #js"textarea"))

    ;; Add more stuff
    (:= #js.this.container.style.display #js"none")
    (:= #js.this.container.style.width  (js-string (format "~apx" WIDTH)))
    (:= #js.this.container.style.height (js-string (format "~apx" HEIGHT)))
    (:= #js.this.textbox.style.width #js"inherit")
    (:= #js.this.textbox.style.height #js"inherit")

    (#js.this.container.appendChild #js.this.textbox)
    (#js.root.appendChild #js.this.container)
    this)
    [log
     (λ (text) 
       #:with-this this
       (#js.this.logs.push (js-string text))
       (#js.this.render)
       (#js*.console.log (js-string text))
       (void))]
    [show
     (λ ()
       #:with-this this
       (:= #js.this.container.style.display DEFAULT-DISPLAY-MODE)
       (void))]
    [hide
     (λ ()
       #:with-this this
       (:= #js.this.container.style.display #js"none")
       (void))]
    [render
     (λ ()
       #:with-this this
       (define log-string (#js.this.logs.reduce (λ (res curr)
                                                  (if ($/binop === res #js"")
                                                      (js-string curr)
                                                      ($/+ res #js"\n\n" (js-string curr))))
                                                #js""))
       (:= #js.this.textbox.innerHTML log-string)
       (:= #js.this.textbox.scrollTop #js.this.textbox.scrollHeight)
       (void))])

(define (make-gui root)
  (new (ServerLogger root)))

(define (server-gui [root-element #js*.document.body])
  (make-gui root-element))