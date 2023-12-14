#lang racket

(require qi)
(require qi/probe)
(require data/collection) ; use multiple params map
;; (require (for-syntax racket/base syntax/parse))

(provide add mul convo reg (for-space qi fbc))

(define (add op)
  (λ (s1 s2)
    (map op s1 s2)))

(define (mul x)
  (λ (s)
    (map (curry * x) s)))

(define (convo s1 s2)
  (match/values (values s1 s2)
    [((sequence f fs ...) (sequence g gs ...))
     (stream-cons (* f g) ((add +) ((mul f) gs) (convo fs (stream-cons g gs))))]))

(define (reg init)
  (λ (s)
    (stream-cons init s)))

(define (fb f)
  (λ (as)
    (letrec-values ([(bs cs) (f as (stream-lazy cs))])
      bs)))

(define-qi-syntax-rule (fbc flo)
  (esc (fb (flow flo))))
