;; environment.scm
;;
;; Interface:
;; the-empty-environment
;; (enclosing-environment env)
;; (first-frame env)
;; (frame-variables f) (frame-values f)
;; (define-variable! var val env)
;; (setup-environment)
;;
;; Environment:
;; ((first frame) (frame2) ...)
;;
;; Frame:
;; ((variable1 variable2) (value1 value2))


;; Need primitives in setup-environment.
(load "primitives.scm")


;; Environment basics

(define the-empty-environment '())

(define (first-frame env) (car env))

(define (enclosing-environment env) (cdr env))


;; Frame basics

(define (make-frame vars vals) (cons vars vals))

(define (frame-variables f) (car f))

(define (frame-values f) (cdr f))

(define (add-binding-to-frame! var val f)
  (set-car! f (cons var (car f)))
  (set-cdr! f (cons val (cdr f))))

;; Operations (reqire both env. and frame basics)

(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
      (cons (make-frame vars vals) base-env)
      (if (< (length vars) (length vals))
	  (error "Too many arguments -- extend-environment" vars vals)
	  (error "Too few  arguments -- extent-environment" vals vals))))

(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (define (scan vars vals)
      (cond ((null? vars) (add-binding-to-frame! var val frame))
	    ((eq? (car vars) var)
	     (set-car! vals val))
	    (else
	     (scan (cdr vars) (cdr vals)))))
    (scan (frame-variables frame) (frame-values frame))))

(define (setup-environment)
  (let ((initial-env (extend-environment (primitive-procedure-names)
					 (primitive-procedure-objects)
					 the-empty-environment)))
    (define-variable! 'true #t initial-env)
    (define-variable! 'false #f initial-env)
    initial-env))
