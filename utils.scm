;; utils.scm
;; 
;; Handling assignment, definition, lambda and control paths.
;;
;; Require:
;; environment.scm


;; Tagged-list/quote/self-evaluating/variable
(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      #f))

(define (quoted? exp)
  (tagged-list? exp 'quote))

(define (text-of-quotation exp) (cadr exp))

(define (self-evaluating? exp)
  (cond ((number? exp) #t)
	((string? exp) #t)
	(else #f)))

(define (variable? exp) (symbol? exp))


;; Ture/false
(define (true? x) (not (eq? x #f)))

(define (false? x) (eq? x #f))


;; Sequence
;; ((exp1) (exp2) ..)
(define (sequence->exp seq)
  (cond ((null? seq) seq)
	((last-exp? seq) (first-exp seq))
	(else (make-begin seq))))


;; Assignment
;; ('set! a b)
(define (assignment? exp) (tagged-list? exp 'set!))

(define (assignment-variable exp) (cadr exp))

(define (assignment-value exp) (caddr exp))

;; called by eval-assignment
(define (set-variable-value! var val env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
	     (env-loop (enclosing-environment env)))
	    ((eq? (car vars) var)
	     (set-car! vals val))
	    (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
	(error "Unbound variable -- set-variable-value!" var)
	(let ((f (first-frame env)))
	  (scan (frame-variables frame) (frame-values frame)))))
  (env-loop env))


;; Definition
(define (definition? exp) (tagged-list? exp 'define))

;; ('define <variable> <body>)
;; or ('define (<variable> <parameters>) <body>)
(define (definition-variable exp)
  (if (symbol? (cadr exp))
      (cadr exp)
      (caadr exp)))

(define (definition-value exp)
  (if (symbol? (cadr exp))
      (caddr exp)    ;; Variable definition.
      (make-lambda   ;; Function definition, make it lambda.
       (cdadr exp)   ;; <parameters>
       (cddr exp)))) ;; <body>


;; Lambda expression
;; ('lambda (<parameters>) <body>)
(define (lambda? exp) (tagged-list? exp 'lambda))

(define (lambda-parameters exp) (cadr exp))

(define (lambda-body exp) (cddr exp))

(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))


;; Control structures

;; if
;; (if <predicate> <consequent> <alternative>)
;; Note <alternative> is optional.
(define (if? exp) (tagged-list? exp 'if))

(define (if-predicate exp) (cadr exp))

(define (if-consequent exp) (caddr exp))

(define (if-alternative exp)
  (if (null? (cdddr exp))
      'false
      (cadddr exp)))

(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))

;; cond
;; (cond ((<predicate1>) <action1>)
;;       ((<predicate2>) <action2>)
;;       ('else <action-else>))
(define (cond? exp) (tagged-list? exp 'cond))

(define (cond-clauses exp) (cdr exp))

(define (cond-predicate clause) (car clause))

(define (cond-actions clause) (cdr clause))

(define (cond-else-clause? clause) (eq? (cond-predicate clause) 'else))

(define (cond->if exp)
  (expand-clauses (cond-clauses exp)))

(define (expand-clauses clauses)
  (if (null? clauses)
      'false
      (let ((first (car clauses))
	    (rest (cdr clauses)))
	(if (cond-else-clause? first)
	    (if (null? rest)
		(sequence->exp (cond-actions first))
		(error "else clause isn't last -- cond->if" clause))
	    (make-if (cond-predicate first)
		     (sequence->exp (cond-actions first))
		     (expand-clauses rest))))))


;; begin
(define (begin? exp) (tagged-list? exp 'begin))

(define (begin-actions exp) (cdr exp))

(define (first-exp exp) (car exp))

(define (rest-exp exp) (cdr exp))

(define (last-exp? exp) (null? (cdr exp)))

(define (make-begin exp) (cons 'begin exp))


;; let
;; ('let ((<variable1> <value1>) (<variable2> <value2>)) <body>)
(define (let? exp) (tagged-list? exp 'let))

(define (let-clauses exp) (cadr exp))

(define (let-body exp) (caddr exp))

(define (let-variables clauses)
  (if (null? clauses)
      '()
      (cons (caar clauses)
	    (let-variables (cdr clauses)))))

(define (let-exps clauses)
  (if (null? clauses)
      '()
      (cons (cadar clauses)
	    (let-exps (cdr clauses)))))

;; let handler
;; Make let a lambda application.
;; (('lambda <varibales> <body>) <values>)
(define (let->combination exp)
  (append (list (list 'lambda (let-variables (let-clauses exp)) (let-body exp)))
	  (let-exps (let-clauses exp))))

;; let*
;; Transform 'let*' to nested 'let'.
;; ('let* <clauses> <actions>)
(define (let*? exp) (tagged-list? exp 'let*))

(define (let*-clauses exp) (cadr exp))

(define (let*-actions exp) (caddr exp))

(define (first-clause clauses) (car clauses))

(define (rest-clauses clauses) (cdr clauses))

(define (let*->nested-lets exp)
  (define (loop clauses actions)
    (if (null? clauses)
	actions
	(list 'let
	      (list (first-clause clauses))
	      (loop (rest-clauses clauses) actions))))
  (loop (let*-clauses exp) (let*-actions exp)))

;; letrec
;; 
;; ('letrec <clauses> <action>)
;; ((<variable1> <value1>) (<variable2> <value2>) ...)
;; 
;; Transform into:
;;
;; ('let ((<varibale1> '*unassigned*) (<variable2> '*unassigned*) ...)
;;   ('set! <variable1> <value1>)
;;   ('set! <variable2> <value2>)
;;   ...
;;   <action>)
(define (letrec? exp) (tagged-list? exp 'letrec))

(define (letrec-clauses exp) (cadr exp))

(define (letrec-actions exp) (caddr exp))

(define (letrec->let-and-set exp)
  (def))


;; Application
;; All pairs (none-empty list) are recognized as application.
(define (application? exp) (pair? exp))

(define (operator exp) (car exp))

(define (operands exp) (cdr exp))

(define (no-operands? exp) (null? exp))

(define (first-operand exp) (car exp))

(define (rest-operands exp) (cdr exp))


