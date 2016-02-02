;; primitives.scm
;;
;; ('primitive <primitive-proc> <args>)


(define (primitive-procedure? proc)
  (tagged-list? proc 'primitive))

(define (primitive-implementation proc) (cadr proc))

(define primitive-procedures
  (list (list 'car car)
	(list 'cdr cdr)
	(list 'cons cons)
	(list 'null? null?)
	(list '+ +)
	(list '- -)
	(list '* *)
	(list '/ /)))

(define (primitive-procedure-names)
  (map car primitive-procedures))

(define (primitive-procedure-objects)
  (map (lambda (proc)
	 (list 'primitive (cadr proc)))
       primitive-procedures))
