;; procedure.scm
;;
;; Interface:
;; (lookup-variable-value var env)


;; Procedure structure:
;; ('procedure paras body env)

;; Requires "environment.scm", and we load it in main.scm.

(define (make-procedure parameters body env)
  (list 'procedure parameters body env))

;; 'compound-procedure?' is already used in Scheme.
(define (compound-procedure? p) (tagged-list? p 'procedure))

(define (procedure-parameters p) (cadr p))

(define (procedure-body p) (caddr p))

(define (procedure-environment p) (cadddr p))

(define apply-in-underlying-scheme apply)

;; lookup-variable-value
;; Searches given variable start from first frame.
(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
	     (env-loop (enclosing-environment env)))
	    ((eq? (car vars) var)
	     (if (eq? (car vals) '*unassigned*)
		 (error "Variable unassigned --lookup-variable-value")
		 (car vals)))
	    (else
	     (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
	(error "Unbound variable -- lookup-variable-value: " var)
	(let ((frame (first-frame env)))
	  (scan (frame-variables frame) (frame-values frame)))))
  ;; (newline)
  ;; (display "lookup-variable-value: ")
  ;; (user-print var)
  (env-loop env))
