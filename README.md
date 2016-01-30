Scheme meta-circular evaluator
===========


About
------

This is a [Scheme](http://www.schemers.org/) [meta-circular evaluator](https://en.wikipedia.org/wiki/Meta-circular_evaluator) from [SICP](https://mitpress.mit.edu/sicp/) chapter 4, currently under developing.


Features
-----

- Support [lexical binding](http://www.gnu.org/software/mit-scheme/documentation/mit-scheme-ref/Lexical-Binding.html).


TODO
-----

- [ ] let*
- [ ] letrec



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
