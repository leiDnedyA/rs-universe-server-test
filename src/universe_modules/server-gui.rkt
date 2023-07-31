#lang racketscript/base

(require (for-syntax racketscript/base
                     syntax/parse)
         "encode-decode.rkt"
         "debug-tools.rkt"
         "universe-primitives.rkt"
         "jscommon.rkt")

(provide server-gui)

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

    (:= #js.this.container  (#js*.document.createElement #js"div"))
    (:= #js.this.textbox    (#js*.document.createElement #js"textarea"))
    
    ;; Add more stuff
    (:= #js.this.textbox.innerHTML #js"test text")
    (#js.this.container.appendChild #js.this.textbox)
    
    (#js.root.appendChild #js.this.container)
    ))

(define (make-gui root)
  (new (ServerLogger root)))

(define (server-gui [root-element #js*.document.body])
  (make-gui root-element))