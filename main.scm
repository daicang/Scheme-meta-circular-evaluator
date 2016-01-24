;; main.scm
;;
;; Meta-circular evaluater: evaluator written by the evaluated language.
;;
;; main.scm:
;; - I/O component
;; - main loop

(load "environment.scm")

;; I/O part

(define input-prompt ";; Meta-circular-evaluater input:")
(define output-prompt ";; Result:")

;; input

(define (prompt-for-input string)
  (newline)
  (display string)
  (newline))

;; output

(define (announce-output string)
  (newline)
  (display string)
  (newline))

(define (user-print obj)
  (if (my-compound-procedure? obj)
      (display (list 'compound-procedure
		     (procedure-parameters obj)
		     (procedure-body obj)))
      (display obj)))



;; main loop

(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output (eval input the-global-environment)))
      (announce-output output-prompt)
      (user-print output)))
  (driver-loop))


