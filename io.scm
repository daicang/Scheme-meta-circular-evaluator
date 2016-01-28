;; io.scm
;;
;; Interface:
;; input-prompt
;; output-prompt
;; (prompt-for-input str)
;; (announce-output str)
;; (user-print obj)

(define input-prompt ";; Meta-circular-evaluater input:")
(define output-prompt ";; Result:")

;; Input

(define (prompt-for-input string)
  (newline)
  (display string)
  (newline))

;; Output

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
