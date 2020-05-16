(load "src/matrix/matrix.sch")

; -------------- matrix creation tests ---------------
(matrix 0 0 '())
(matrix 1 1 '(1))
(matrix 1 2 '(1 2))
(matrix 2 1'(1 2))

(define M1 (matrix 3 2 '(1 2 3 4 5 6)))
(define M2 (matrix 3 2 '(5 6 7 8 9 0)))
(define M3 (matrix 2 4 '(1 5 6 7 8 9 1 3)))
(define M4 (matrix 3 3 '(1 5 6 7 8 9 1 3 9)))


(randM 3 2)

; ---------------- ID matrix creation ----------------
(matrixID 0)
(matrixID 1)
(matrixID 2)
(define ID3 (matrixID 3))


; -------------------- addM tests --------------------
(addM '() '())
(addM '((1)) '((2)))

(addM M1 M2)

; ------------------- prodVM tests -------------------
(prodVM '(2 3 4) ID3)
(prodVM '(2 3 4) M4)
(prodVM '(2 3) M2)
(prodVM '(2 3 5 6) M3)

; ------------------- prodMM tests -------------------

(prodMM ID3 ID3)
(prodMM ID3 M2)
(prodMM M4 M2)


; ----------------- hadamardM tests ------------------

(hadamardM ID3 ID3)
(hadamardM ID3 M4)
(hadamardM M4 M4)

; ---------------- map function tests ----------------

(mapM (lambda (x) (* 2 x)) ID3)


; -------------- Transpose Matrix tests --------------

(transpose M1)
(transpose M4)

; -------------- Rows and columns tests ---------------


(rows '())
(columns '())

(rows ID3)
(columns ID3)


(rows M3)
(columns M3)