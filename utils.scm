;; utils.scm
;; *INCOMPLETE NOW*
;; 
;; Handling assignment, definition, lambda
;; and control structures: if, begin, cond, 


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


;; Assignment
(define (assignment? exp) (tagged-list? exp 'set!))

(define (assignment-variable exp) (cadr exp))

(define (assignment-value exp) (caddr exp))


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
      (caddr exp)  ;; Variable definition.
      (make-lambda ;; Function definition, make it lambda.
       (cdadr exp) ;; <parameters>
       (cddr exp))))


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

(define (expand-clauses exp)
  )


;; begin
(define (begin? exp) (tagged-list? exp 'begin))

(define (begin-actions exp) (cdr exp))

(define (first-exp exp) (car exp))

(define (rest-exp exp) (cdr exp))

(define (last-exp? exp) (null? (cdr exp)))

(define (make-begin exp) (cons 'begin exp))

