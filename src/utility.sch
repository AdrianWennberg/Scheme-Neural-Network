
; Split a list in two after element number N
(define (split N L)
    (cond ((zero? N) (list () L))
          (#t ( (lambda (R) (list (cons (car L) (car R)) (cadr R))) 
                (split (- N 1) (cdr L)) )  )
    )
)

; take the first N elements from L
(define (carN N L)
    (cond   ((zero? N) ())
            (#t (cons (car L) (carN (- N 1) (cdr L))))
    )
)

; remove the first N elements then return L
(define (cdrN N L)
    (cond   ((zero? N) L)
            (#t  (cdrN (- N 1) (cdr L)))
    )
)

; Combines two lists by preforming the operation f on pairwise elements
(define (combine L1 L2 f)
    (if (null? L1) 
        '()
        (cons 
            (f (car L1) (car L2) ) 
            (combine (cdr L1) (cdr L2) f)
        )
    )
)

; random number functions
(define random 
    (let ((a 69069) (c 1) (m (expt 2 32)) (seed 19380110))
        (lambda new-seed
            (if (pair? new-seed)
                (set! seed (car new-seed))
                (set! seed (modulo (+ (* seed a) c) m)))
            (* 1.0 (/ seed m))
        )
    )
)

(define (randmax max)
    (* (random) max)
)

(define (randrange min max)
    (+ min (* (random) (- max min)))
)