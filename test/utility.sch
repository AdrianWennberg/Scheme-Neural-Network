(load "src/utility.sch")

; Tests of utility functions
; --------------- Operating on lists -----------------
(carN 0 '(1 2 3))
(cdrN 0 '(1 2 3))
(carN 1 '(1 2 3))
(cdrN 1 '(1 2 3))
(carN 5 '(1 2 3 4 5 6 7 8 9 10))
(cdrN 5 '(1 2 3 4 5 6 7 8 9 10))

(split 3 '(1 2 3 4 5 6))


(getN 0 '(1 2 3 4 5 6 7 8 9 10))
(getN 2 '(1 2 3 4 5 6 7 8 9 10))
(getN 5 '(1 2 3 4 5 6 7 8 9 10))
(getN 9 '(1 2 3 4 5 6 7 8 9 10))


(getRand '(1 2 3 4))
(getRand '(1 2 3 4))
(getRand '(1 2 3 4))
(getRand '(1 2 3 4))
(getRand '(1 2 3 4))
(getRand '(1 2 3 4))
(getRand '(1 2 3 4))
(getRand '(1 2 3 4))

; ---------- Combining lists by a function -----------
(combine '(1 2 3) '(4 5 6) (lambda (x y) (* y x)) )



; ------------ Generating random numbers -------------
(random)
(random)
(random)

(randmax 5)
(randmax 5)
(randmax 5)

(randrange 5 10)
(randrange 5 10)
(randrange 5 10)
(randrange 5 10)


; -------------- Activation functions ----------------

(sig 0)
(sig 1)
(sig -1)


(sigd 0)
(sigd 1)
(sigd -1)


(siginv (sig 0))
(siginv (sig 1))
(siginv (sig -1))