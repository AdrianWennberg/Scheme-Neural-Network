(load "src/matrix/vector.sch")

; --------------- Random vector tests ----------------
(randV 0)
(randV 1)
(randV 2)

; ---------------- Dot product tests -----------------
(dotProduct '() '())
(dotProduct '(1) '(2))
(dotProduct '(1 2 4) '(2 2 1))

; -------------- Vector addtiton tests ---------------
(addV '() '())
(addV '(1) '(2))
(addV '(1 2 4) '(2 2 1))

; ------------- Hadamard product tests ---------------
(hadamardV '() '())
(hadamardV '(1) '(2))
(hadamardV '(2 3) '(5 3))

; --------------- Map function tests -----------------
(mapV (lambda (x) (* 2 x)) '(1 2 3))

; --------------- Column vector tests ----------------
(columnV '(1 2 3))