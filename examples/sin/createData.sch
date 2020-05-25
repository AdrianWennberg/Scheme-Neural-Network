(load "src/utility.sch")

; creates a vector [x1 x2 x3 x4]
(define (inputPoint)
    (v:generate 4 (lambda (x) (randRange -1 1)))
)

; computes the output sin(x1-x2+x3-x4)
(define (computeOutput input)
    (vector (sin (dot-product (vector 1 -1 1 -1) input)))
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

