#lang racketscript/base

(provide encode-data
         decode-data
         
         js-string?)

(define (js-string? s)
  (or ($/typeof s "string") ($/instanceof s #js*.String)))

(define DATA-TYPE-WARNING #js"racketscript/htdp/universe: Unsupported datatype being passed to/from server.")

(define (encode-data data)
  (cond [(list? data) (foldl (lambda (curr result)
                               (#js.result.push (encode-data curr))
                               result)
                      ($/array)
                      data)]
        [(number? data)    ($/obj [type #js"number"]
                                  [val data])]
        [(string? data)    ($/obj [type #js"string"]
                                  [val (js-string data)])]
        [(symbol? data)    ($/obj [type #js"symbol"]
                                  [val (js-string (symbol->string data))])]
        [(boolean? data)   ($/obj [type #js"boolean"]
                                  [val data])]
        ; [(js-string? data) ($/obj [type #js"js-string"]
        ;                           [val data])]
        [else              (begin 
                             (#js*.console.warn ($/array DATA-TYPE-WARNING data))
                             ($/obj [type #js"unknown"]
                                  [val data]))]))


(define (decode-data data)
  (cond [(#js*.Array.isArray data) (#js.data.reduce (lambda (result curr)
                                                      (append result (list (decode-data curr))))
                                                    '())]
        [($/binop == #js.data.type #js"number")    #js.data.val]
        [($/binop == #js.data.type #js"string")    (js-string->string #js.data.val)]
        [($/binop == #js.data.type #js"symbol")    (string->symbol (js-string->string #js.data.val))]
        [($/binop == #js.data.type #js"boolean")   #js.data.val]
        [($/binop == #js.data.type #js"js-string") #js.data.val]
        [($/binop == #js.data.type #js"unknown")   (begin
                                                     (#js*.console.warn DATA-TYPE-WARNING)
                                                     #js.data.val)]))