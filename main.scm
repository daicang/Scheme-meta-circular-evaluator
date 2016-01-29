;; main.scm
;;
;; Meta-circular evaluater: evaluator written by the evaluated language.
;;
;; main.scm:
;; - eval/apply function
;; - main loop

(load "environment.scm")
(load "io.scm")
(load "procedure.scm")


;; Initialize environment

(define the-global-environment (setup-environment))


;; eval/apply

(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
	((variable? exp) (lookup-variable-value exp env))
	((quoted? exp) (text-of-quotation exp))
	((assignment? exp) (eval-assignment exp env))
	((definition? exp) (eval-definition exp env))
	((if? exp) (eval-if exp env))
	((cond? exp) (eval (cond->if exp) env))
	((let? exp) (eval (let->combination exp) env))
	((lambda? exp)
	 (make-procedure (lambda-parameters exp)
			 (lambda-body exp)
			 env))
	((begin? exp)
	 (eval-sequence (begin-actions exp) env))
	((application? exp)
	 (apply (eval (operator exp) env)
		(list-of-values (operands exp) env)))
	(else
	 (error "Unknown expression type -- eval: " exp))))

(define (apply procedure arguments)
  (cond ((primitive-procedure? procedure)
	 (apply-primitive-procedure procedure arguments))

	;; Main part
	((compound-procedure? procedure)
	 (eval-sequence
	  (procedure-body procedure)
	  (extend-environment
	   (procedure-parameters procedure) ;; As variable
	   arguments                        ;; As value
	   (procedure-environment procedure))))
	
	(else
	 (display (cadr procedure))
	 (error "Unknown procedure type --apply" procedure))))



;; Main loop

(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output (eval input the-global-environment)))
      (announce-output output-prompt)
      (user-print output)))
  (driver-loop))


