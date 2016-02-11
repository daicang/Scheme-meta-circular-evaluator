;; Use '(load "input.scm")' to execute this file.


;; Test letrec
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

(f 5)
(f 1024)


;; Test named-let
(define (fib n)
  (let iter ((a 1)
	     (b 0)
	     (count n))
    (if (= count 0)
	b
	(iter (+ a b) a (- count 1)))))

;; 0 1 1 2 3 5 8
(fib 5)
(fib 6)
