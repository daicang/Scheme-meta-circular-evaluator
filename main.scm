;; main.scm
;;
;; Meta-circular evaluater: evaluator written by the evaluated language.
;;
;; main.scm:
;; Main loop

(load "environment.scm")
(load "io.scm")
(load "procedure.scm")


;; Initialize environment

(define the-global-environment (setup-environment))


;; Main loop

(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output (eval input the-global-environment)))
      (announce-output output-prompt)
      (user-print output)))
  (driver-loop))


