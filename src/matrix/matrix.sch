(load "src/utility.sch")
(load "src/matrix/vector.sch")


; Matrix Operations
; A matrix is a list of rows all of equal length. So '((1 0) (0 1)) is a 2x2 identity matrix

; Create an RxC martix from list L
(define (matrix rows columns L)
    (cond ((zero? rows) '())
          ((zero? (- rows 1)) (list L))
          (#t ( (lambda (spl) (cons (car spl) (matrix (- rows 1) columns (cadr spl))))
                (split columns L))
          )
    )
)

; Create an identity matrix of dimention N
(define (matrixID N)
    (define (IDRow N i)
        (cond 
            ((zero? N) '())
            ((eq? N  i) (cons 1 (IDRow (-1+ N) i)))
            (#t (cons 0 (IDRow (-1+ N) i)))
        )
    )
    (define (create N i)
        (if (zero? i)
            '()
            (cons (IDRow N i) (create N (-1+ i)))
        )
    )

    (create N N)
)

; Creates a random matrix of the given size with entries in the range [0, 1]
(define (randM rows columns)
    (if (= rows 0) 
        '() 
        (cons 
            (randV columns) 
            (randM (- rows 1) columns)
        )
    )
)

; Adds two matrixes elementwise
(define (addM M1 M2)
    (combine M1 M2 addV)
)

; Multiply a matrix by a constant
(define (prodCM C M)
    (mapM (lambda (x) (* C x)) M)
)

; Multiply a matrix by a vector
(define (prodVM V M)
    (if (null? M) 
        '() 
        (cons (dotProduct V (car M)) (prodVM V (cdr M)))
    )
)

; Computes the matrix product of two matrixes M1 and M2 
(define (prodMM M1 M2)
    (define (multTransposed M1 M2) 
        (if (null? M1) 
            '() 
            (cons (prodVM (car M1) M2) (multTransposed (cdr M1) M2))
        )
    )
        
    (multTransposed M1 (transpose M2))
)

; Computes the hadamard product of two matrixes    
(define (hadamardM M1 M2)
    (combine M1 M2 hadamardV)
)


(define (mapM f M)
    (map (lambda (V) (mapV f V)) M)
)
        
(define (transpose M)
    (define (attachColumn C M)  
        (if (null? M) 
            C
            (cons 
                (cons 
                    (caar C)
                    (car M)) 
                (attachColumn (cdr C) (cdr M))
            )
        )
    )
                             
    (if (null? M) 
        '()
        (attachColumn 
            (columnV (car M)) 
            (transpose (cdr M))
        )
    )
)
    
(define (rows M)
    (length M))
    
(define (columns M)
    (if (null? M) 
        0
        (length (car M))
    )
)

    
    
    