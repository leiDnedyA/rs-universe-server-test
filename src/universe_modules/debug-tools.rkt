#lang racketscript/base

(provide console-log-rkt-list)

(define (console-log-rkt-list l)
  (if (list? l) (#js*.console.log (foldl (lambda (curr res)
                                    (#js.res.push curr)
                                    res)
                                  ($/array) l))
                (#js*.console.log l)))
