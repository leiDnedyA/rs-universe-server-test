#lang racketscript/base

(require racket/list)

(provide insertion-sort)

(define (insertion-sort los sorted-los)
  (cond [(empty? sorted-los) (list los)]
        [(string-ci<=? los (first sorted-los))
         (cons los sorted-los)]
        [else (cons (first sorted-los)
                    (insertion-sort los (rest sorted-los)))]))