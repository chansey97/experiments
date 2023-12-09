#lang racket

(require qi)
(require qi/probe)
(require data/collection) ; use multiple params map

(require (for-syntax racket/base syntax/parse))

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
  (λ ass
    (letrec-values ([(cs bss) (call-with-values
                               (λ () (apply f (cons (stream-lazy cs) ass)))
                               (λ (cs . bss) (values cs bss)))])
      (apply values bss))))

(define-qi-syntax-rule (fbc flo)
  (esc (fb (flow flo))))


(define zero (stream-cons 0 zero))
(~>> (zero) (stream-take _ 10) stream->list)
;; '(0 0 0 0 0 0 0 0 0 0)

(define one (~>> (zero) (reg 1)))
(~>> (one) (stream-take _ 10) stream->list)
;; '(1 0 0 0 0 0 0 0 0 0)



;; τ = (1 / 1 - X) σ
(define-flow ones
  (~>> (fbc (~>> (== (reg 0) _) (add +) (-< _ _)))))

(probe (~>> (one) ; σ=1
            ones
            (stream-take _ 10)
            stream->list))
;; '(1 1 1 1 1 1 1)



;;  τ = (1 / 1 - 2X) σ
(define-flow sf-power2
  (~>> (fbc (~>> (== (reg 0) _) (== (mul 2) _) (add +) (-< _ _)))))

(probe (~>> (one) ; σ=1
            sf-power2
            (stream-take _ 10)
            stream->list))
;; '(1 2 4 8 16 32 64 128 256 512)


;; τ = (1 / (1 - X)^2) σ
(define-flow sf-nats
  (~>> (fbc (~>> (== (reg 0) _) (add +) (-< _ _)))
       (fbc (~>> (== (reg 0) _) (add +) (-< _ _)))))

(define nats ((☯ sf-nats) one))

(probe (~>> (nats) ; σ=1
            (stream-take _ 10)
            stream->list))
;; '(1 2 3 4 5 6 7 8 9 10)


;; Factorial
;; like '(1 2 3 4 5 6 7 8 9 10), but use multiplication

(define-flow sf-fact
  (~>> (fbc (~>> (== (reg 0) _) (add +)   (-< _ _)))
       (fbc (~>> (== (reg 0) _) (add +)   (-< _ _)))
       (fbc (~>> (== (reg 1) _) (add *)   (-< _ _)))))

(probe (~>> (one) ; σ=1
            sf-fact
            (stream-take _ 10)
            stream->list))
;; '(1 2 6 24 120 720 5040 40320 362880 3628800)


;; Fibonacci 
;; τ = (X / (1 - X - X^2)^2) σ

(define-flow sf-fib
  (~>> (fbc (~>> (== (~> (reg 0) (mul 1)) _)
                      (add +)
                      (fbc (~>> (== (~> (reg 0) (mul 1)) _) (add +) (-< _ _)))
                      (reg 0)
                      (-< _ _)))
       (mul 1)))

(probe (~>> (one) ; σ=1
            sf-fib
            (stream-take _ 20)
            stream->list))
;; '(0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181)


;; Integral

(define (integrator init dt)
  (☯ (~>> (mul 1)  (fbc (~>> (== (reg 0) _) (add +) (-< _ _))) (reg 0))))

(probe (~>> (nats) ; σ=1
            (integrator 0 1)
            (stream-take _ 10)
            stream->list))
;; '(0 1 3 6 10 15 21 28 36 45)

