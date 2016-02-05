;; main.scm
;;
;; Meta-circular evaluater: evaluator written by the evaluated language.
;;
;; main.scm:
;; - eval/apply function
;; - main loop

(load "environment.scm") ;; Include "primitives.scm"
(load "io.scm")
(load "procedure.scm")
(load "utils.scm")


;; Initialize environment

(define the-global-environment (setup-environment))


;; eval helper functions
;; We define 'true?', then use 'if' in underlying Scheme directly.
(define (eval-if exp env)
  (if (true? (eval (if-predicate exp) env))
      (eval (if-consequent exp) env)
      (eval (if-alternative exp) env)))

(define (eval-sequence exps env)
  (cond ((last-exp? exps) (eval (first-exp exps) env))
	(else (eval (first-exp exps) env)
	      (eval-sequence (rest-exps exps) env))))

(define (eval-assignment exp env)
  (set-variable-value! (assignment-variable exp)
		       (eval (assignment-value exp) env)
		       env)
  'ok)

(define (eval-definition exp env)
  (define-variable! (definition-variable exp)
                    (eval (definition-value exp) env)
		    env)
  'ok)


;; eval
(define (eval exp env)
  ;; (newline)
  ;; (display "eval: exp: ")
  ;; (user-print exp)
  ;; (newline)
  ;; (display "env: ")
  ;; (user-print env)
  (cond ((self-evaluating? exp) exp)
	((variable? exp) (lookup-variable-value exp env))
	((quoted? exp) (text-of-quotation exp))
	((assignment? exp) (eval-assignment exp env))
	((definition? exp) (eval-definition exp env))
	((if? exp) (eval-if exp env))
	((cond? exp) (eval (cond->if exp) env))
	((let? exp) (eval (let->combination exp) env))
	((let*? exp) (eval (let*->nested-lets exp) env))
	((letrec? exp) (eval (letrec->let-and-set exp) env))

	;; lambda handler.
	((lambda? exp)
	 (make-procedure (lambda-parameters exp)
			 (lambda-body exp)
			 env))
	((begin? exp)
	 (eval-sequence (begin-actions exp) env))

	;; Must be here. 'application?' (pair?) recognizes any pair.
	((application? exp)
	 (apply (eval (operator exp) env)
		(list-of-values (operands exp) env))) ;; Evaluate arguments.
	(else
	 (error "Unknown expression type -- eval: " exp))))


;; apply helper functions
(define (apply-primitive-procedure proc args)
  ;; (newline)
  ;; (display "apply-primitive-procedure: ")
  ;; (display proc)
  ;; (newline)
  ;; (display args)
  (apply-in-underlying-scheme
   (primitive-implementation proc) args))

(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (cons (eval (first-operand exps) env)
	    (list-of-values (rest-operands exps) env))))

;; apply
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

(driver-loop)
