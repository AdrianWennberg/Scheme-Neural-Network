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


(splitEveryN 2 '(1 2 3 4 5 6))
(splitEveryN 3 '(1 2 3 4 5 6 7 8))
(splitEveryN 10 '(1 2 3 4 5 6 7 8))


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

(randMax 5)
(randMax 5)
(randMax 5)

(randRange 5 10)
(randRange 5 10)
(randRange 5 10)
(randRange 5 10)


; -------------- Activation functions ----------------

(sig 0)
(sig 1)
(sig -1)


(sigD 0)
(sigD 1)
(sigD -1)


(padZeros 5 "1")
(padZeros 3 "123")
(padZeros 0 "1234")

(decoded-time/file-name-time (local-decoded-time))
(decoded-time/file-name-time (global-decoded-time))
(decoded-time/file-name-time (make-decoded-time 0 0 0 1 1 1900))

(getCurrentTimeString)