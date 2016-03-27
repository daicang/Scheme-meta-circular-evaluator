;; Use '(load "input.scm")' to execute this file.


;; let*
(define (f x)
  (let* ((a x)
	 (b (+ a 2)))
    (+ a b)))

(f 1)

;; letrec
(define (f x)
  (letrec ((even?
	    (lambda (n)
	      (if (= n 0)
		  #t
		  (odd? (- n 1)))))
	   (odd?
	    (lambda (n)
	      (if (= n 0)
		  #f
		  (even? (- n 1))))))
    (even? x)))

;; (display "Test letrec")
;; (f 5)
;; (f 1024)

;; named-let
(define (fib n)
  (let iter ((a 1)
	     (b 0)
	     (count n))
    (if (= count 0)
	b
	(iter (+ a b) a (- count 1)))))

;; 0 1 1 2 3 5 8
(display "Test named-let")
(fib 5)
(fib 6)


;; Recursive function defination
(define (factorial n)
  (if (= n 0)
      1
      (* n (factorial (- n 1)))))

(display "Test recursive function")
(factorial 4)
(factorial 5)

;; Lambda calculus test, will not pass
;; ((lambda (f n)
;;   (if (= n 0)
;;       1
;;       (* n (f f (- n 1)))))
;;  '(lambda (f n)
;;    (if (= n 0)
;;        1
;;        (* n (f f (- n 1)))))
;;  5)
    

;; Omega combinator
;; Loop forever (watch CPU usage!)
;; ((lambda (x) (x x)) (lambda (x) (x x)))
