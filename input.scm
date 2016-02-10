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
