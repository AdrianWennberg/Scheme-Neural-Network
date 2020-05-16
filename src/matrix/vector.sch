(load "src/utility.sch")

; Vector (list) operations

; Creates a random vector
(define (randV L) 
    (if (= L 0) 
        '() 
        (cons
            (random) 
            (randV (- L 1))
        )
    )
)

(define (dotProduct V1 V2)
    (if (null? V1) 
        0 
        (+ 
            (* (car V1) (car V2) ) 
            (dotProduct (cdr V1) (cdr V2))
        )
    )
)

(define (addV V1 V2)
    (combine V1 V2 +)
)

; Hadamard (elementwise) product of two vectors
(define (hadamardV V1 V2)
    (combine V1 V2 *)
)

; Map function for vectors is equivalent to map function for lists
(define mapV map)

(define (columnV V)
    (mapV list V)
)


