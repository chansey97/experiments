#lang racket

(require qi)
(require qi/probe)
(require data/collection) ; use multiple params map

(require (for-syntax racket/base syntax/parse))

(define (add s1 s2)
  (map + s1 s2))

(define (add-* s1 s2)
  (map * s1 s2))

(define (mul x)
  (λ (s)
    (map (curry * x) s)))

(define (reg init)
  (λ (s)
    (stream-cons init s)))

(define (fb f)
  (λ ass
    (letrec-values ([(cs bss) (call-with-values
                               (λ () (apply f (cons (stream-lazy cs) ass)))
                               (λ (cs . bss) (values cs bss)))])
      (apply values bss))))

(define-qi-syntax-rule (fbc flo)
  (esc (fb (flow flo))))


;; τ = (1 / 1 - X) σ

(probe (~>> ((stream 1 0 0 0 0 0 0 0 0 0)) ; σ=1
            (fbc (~>> (== (reg 0) _) add (-< _ _)))
            (stream-take _ 7)
            stream->list))
;; '(1 1 1 1 1 1 1)



;;  τ = (1 / 1 - 2X) σ

(probe (~>> ((stream 1 0 0 0 0 0 0 0 0 0)) ; σ=1
            (fbc (~>> (== (reg 0) _) (== (mul 2) _) add (-< _ _)))
            (stream-take _ 7)
            stream->list))
;; '(1 2 4 8 16 32 64)


;; τ = (1 / (1 - X)^2) σ

(probe (~>> ((stream 1 0 0 0 0 0 0 0 0 0))
            (fbc (~>> (== (reg 0) _) add (-< _ _)))
            (fbc (~>> (== (reg 0) _) add (-< _ _)))
            (stream-take _ 7)
            stream->list))
;; '(1 2 3 4 5 6 7)

;; Factorial
;; like (1 2 3 4 5 6 7), but use multiplication

(probe (~>> ((stream 1 0 0 0 0 0 0 0 0 0)) ; σ=1
            (fbc (~>> (== (reg 0) _) add   (-< _ _)))
            (fbc (~>> (== (reg 0) _) add   (-< _ _)))
            (fbc (~>> (== (reg 1) _) add-* (-< _ _)))
            (stream-take _ 7)
            stream->list))
;; '(1 2 6 24 120 720 5040)

;; Fibonacci 
;; τ = (X / (1 - X - X^2)^2) σ

(probe (~>> ((stream 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)) ; σ=1
            (fbc (~>> (== (~> (reg 0) (mul 1)) _) add (fbc (~>> (== (~> (reg 0) (mul 1)) _) add (-< _ _))) (reg 0) (-< _ _)))
            (mul 1)
            (stream-take _ 20)
            stream->list))
'(0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181)

