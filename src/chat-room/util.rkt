#lang racketscript/base

(require racket/list)

(provide slice-list
         insertion-sort
         text-width)

(define (slice-list l start stop)
  (take (drop l start) (- stop start)))

(define (insertion-sort los sorted-los)
  (cond [(empty? sorted-los) (list los)]
        [(string-ci<=? los (first sorted-los))
         (cons los sorted-los)]
        [else (cons (first sorted-los)
                    (insertion-sort los (rest sorted-los)))]))

(define (text-width str font-size)
  (define char-sizes (hash
                        " " 7 "!" 7 "\"" 9 "#" 16 "$" 14 "%" 21 "&" 15 "'" 4 "(" 8 ")" 8
                        "*" 10 "+" 14 "," 6 "-" 8 "." 6 "/" 9 "0" 14 "1" 14 "2" 14 "3" 14
                        "4" 14 "5" 14 "6" 14 "7" 14 "8" 14 "9" 14 ":" 6 ";" 6 "<" 14 "=" 14
                        ">" 14 "?" 13 "@" 23 "A" 17 "B" 17 "C" 18 "D" 19 "E" 15 "F" 15 "G" 20
                        "H" 20 "I" 8 "J" 14 "K" 18 "L" 15 "M" 23 "N" 20 "O" 20 "P" 17 "Q" 20
                        "R" 18 "S" 14 "T" 17 "U" 19 "V" 17 "W" 25 "X" 17 "Y" 17 "Z" 15 "[" 8
                        "\\" 9 "]" 8 "^" 10 "_" 14 "`" 7 "a" 14 "b" 14 "c" 12 "d" 14 "e" 13
                        "f" 7 "g" 14 "h" 14 "i" 6 "j" 6 "k" 14 "l" 6 "m" 21 "n" 14 "o" 14
                        "p" 14 "q" 14 "r" 8 "s" 12 "t" 7 "u" 14 "v" 14 "w" 20 "x" 14 "y" 14
                        "z" 12 "{" 8 "|" 6 "}" 8 "~" 14))
  (define width (foldl (lambda (c result)
                         (define char-width (hash-ref char-sizes (string c) 0))
                         (#js*.console.log char-width)
                         (+ result char-width))
                       0
                       (string->list str)))
  (* (/ width 1000) font-size))