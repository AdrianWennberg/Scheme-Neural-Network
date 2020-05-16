(load "src/utility.sch")

; Tests of utility functions
(carN 0 '(1 2 3))
(cdrN 0 '(1 2 3))
(carN 1 '(1 2 3))
(cdrN 1 '(1 2 3))
(carN 5 '(1 2 3 4 5 6 7 8 9 10))
(cdrN 5 '(1 2 3 4 5 6 7 8 9 10))

(split 3 '(1 2 3 4 5 6))