Scheme meta-circular evaluator
===========


About
------

This is a [Scheme](http://www.schemers.org/) [meta-circular evaluator](https://en.wikipedia.org/wiki/Meta-circular_evaluator) from [SICP](https://mitpress.mit.edu/sicp/) chapter 4.


Quickstart
-----

### Environment
I use [MIT/GNU-Scheme](https://www.gnu.org/software/mit-scheme/) 9.2 on OS X 10.11.

### Interactive mode
The default interface is an interactive loop, try this:
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

;; Meta-circular-evaluater input:

```
Then have fun testing whatever you want. Note that do not load "main.scm" twice, or nested `apply` would cause problems.

### Input from file
Load "main.scm" in scheme shell, then load file like this:
```
;; Meta-circular-evaluater input:
(load "input.scm")
```


Features
-----

- Support [lexical binding](http://www.gnu.org/software/mit-scheme/documentation/mit-scheme-ref/Lexical-Binding.html).
- Support let*/letrec/named-let

```
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


TODO
-----

- [x] let*
- [x] letrec
- [x] Named let
- [x] Input from file
- [ ] Separate syntatic anslysis from execution (SICP 4.1.7)
- [ ] Lazy evatuating (SICP 4.2)
