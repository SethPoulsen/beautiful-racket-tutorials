#lang br/quicklang

(define (read-syntax path port)
  (define src-lines (port->lines port))
  (define src-datums (format-datums '~a src-lines))
  (define module-datum `(module funstacker-mod "funstacker.rkt"
                          (handle-args ,@src-datums)))
  (datum->syntax #f module-datum))

(provide read-syntax)

(define-macro (stacker-module-begin HANDLE-EXPR ...)
  #'(#%module-begin
     (display (first HANDLE-EXPR ...))
     ))

(provide (rename-out [stacker-module-begin #%module-begin]))

(define (handle [arg #f] [stack empty])
  (cond
    [(void? arg) stack]
    [(number? arg) (cons arg stack)]
    [(or (equal? + arg) (equal? * arg))
     (define op-result (arg (first stack) (first (rest stack))))
     (cons op-result (rest (rest stack)))]))

(define (handle-args . args)
  (foldl handle empty args))

(provide + *)
(provide handle-args)
