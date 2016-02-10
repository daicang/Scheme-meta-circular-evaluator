Scheme meta-circular evaluator
===========


About
------

This is a [Scheme](http://www.schemers.org/) [meta-circular evaluator](https://en.wikipedia.org/wiki/Meta-circular_evaluator) from [SICP](https://mitpress.mit.edu/sicp/) chapter 4.


Quickstart
-----

We use [mit-scheme](https://www.gnu.org/software/mit-scheme/) 9.2 on OSX. 

```
$ scheme

1 ]=> (load "main.scm")
(load "main.scm")

;Loading "main.scm"...
;  Loading "environment.scm"...
;    Loading "primitives.scm"... done
;  ... done
;  Loading "io.scm"... done
;  Loading "procedure.scm"... done
;  Loading "utils.scm"... done
;... done
;Value: driver-loop

1 ]=> (driver-loop)
(driver-loop)

;; Meta-circular-evaluater input:

```
Then have fun testing whatever you want. Note that do not load "main.scm" twice, or nested `apply` would cause problems.


TODO
-----

- [x] let*
- [x] letrec
- [ ] Named let
- [x] Input from file


Features
-----

- Support [lexical binding](http://www.gnu.org/software/mit-scheme/documentation/mit-scheme-ref/Lexical-Binding.html).
- Support let*/letrec:
```
(load "main.scm")

;Loading "main.scm"...
;  Loading "environment.scm"...
;    Loading "primitives.scm"... done
;  ... done
;  Loading "io.scm"... done
;  Loading "procedure.scm"... done
;  Loading "utils.scm"... done

;; Meta-circular-evaluater input:
(define (f x) (letrec ((even? (lambda (n) (if (= n 0) #t (odd? (- n 1))))) (odd? (lambda (n) (if (= n 0) #f (even? (- n 1)))))) (even? x)))

;; Result:
ok
;; Meta-circular-evaluater input:
(f 5)

;; Result:
#f
;; Meta-circular-evaluater input:
(f 1022)

;; Result:
#t
```
