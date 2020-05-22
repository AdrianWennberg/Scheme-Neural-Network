(load "src/matrix/matrix.sch")

; creates a vector [x1 x2 x3 x4]
(define (inputPoint)
    (mapM (lambda (x) (* 2 (- 0.5 x))) (randM 4 1))
)

; computes the output sin(x1-x2+x3-x4)
(define (computeOutput input)
    (mapM sin (prodMM '((1 -1 1 -1)) input))
)

(define (dataPoint input)
    (list 
        input
        (computeOutput input)
    )
)

(define (sinData N) 
    (if (zero? N)
        '()
        (cons (dataPoint (inputPoint)) (sinData (- N 1)))
    )
)

