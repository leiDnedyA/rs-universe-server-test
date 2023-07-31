#lang racketscript/base

(require (for-syntax racketscript/base
                     syntax/parse))

(provide format-js-str)

(define-syntax-rule (format-js-str fmt-str args ...)
  (js-string (format fmt-str args ...)))