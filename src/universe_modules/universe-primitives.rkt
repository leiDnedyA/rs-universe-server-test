#lang racketscript/base

(require ;htdp/error
         racket/list)

(provide sexp?
         
         make-package
         package?
         package-world
         package-message
         
         (struct-out u-bundle)
         make-bundle
         bundle?

         (struct-out u-mail)
         make-mail
         mail?)

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

(struct u-bundle (state mails low-to-remove))
(define (make-bundle state mails low-to-remove)
  (u-bundle state mails low-to-remove))
(define (bundle? bundle)
  (u-bundle? bundle))

(struct u-mail (to content))
(define (make-mail to content)
  (u-mail to content))
(define (mail? mail)
  (u-mail? mail))
