#lang racketscript/base

(require ;htdp/error
         racket/list)

(provide sexp?
         make-package
         package?
         package-world
         package-message)

(define (sexp? x)
  (cond
    [(empty? x) #true]
    [(string? x) #true]
    [(bytes? x) #true]
    [(symbol? x) #true]
    [(number? x) #true]
    [(boolean? x) #true]
    [(char? x) #true]
    [(pair? x) (and (list? x) (andmap sexp? x))]
    ; [(and (struct? x) (prefab-struct-key x)) (for/and ((i (struct->vector x))) (sexp? i))]
    [else #false]))

(define-values (make-package package? package-world package-message)
  (let ()
    (struct package (world message) #:transparent)
    (define (make-package w m)
    ;   (check-arg 'make-package (sexp? m) 'sexp "second" m)
      (package w m))
    (values make-package package? package-world package-message)))
