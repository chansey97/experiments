#lang racket

(require qi)
(require qi/probe)
(require "../circuit.rkt")
(require "basic-streams.rkt")

(define fact (~>> (positives)
                  ; The circuit is similar to sf-4.17, but use multiplication
                  (fbc (~>> (== _ (reg 1)) (add *)   (-< _ _)))
                  ))
(probe (~>> (fact) (stream-take _ 10) stream->list))
;; '(1 2 6 24 120 720 5040 40320 362880 3628800)

(define fact0 (~>> (fact) (reg 0)))
(probe (~>> (fact0) (stream-take _ 10) stream->list))
;; '(0 1 2 6 24 120 720 5040 40320 362880)

