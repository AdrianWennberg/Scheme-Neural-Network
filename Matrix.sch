(define (add M1 M2)
    (define (addRows R1 R2) (if (null? R1) '()
        (cons (+ (car R1) (car R2)) (addRows (cdr R1) (cdr R2)))))
    (cond ((null? M1)              '())
          ((not (sameSize? M1 M2)) (addErr))
          (#t                      (cons (addRows (car M1) (car M2)) 
                                         (add (cdr M1) (cdr M2))))))

(define (mult M1 M2)
    (define (multRow R M)
        (if (null? M) '() (cons (dotProduct R (car M)) (multRow R (cdr M)))))
    (define (multTransposed M1 M2) 
        (if (null? M1) '() (cons (multRow (car M1) M2) (multTransposed (cdr M1) M2))))
        
    (if (not (= (columns M1) (rows M2))) (multErr)
        (multTransposed M1 (transpose M2))))
    
(define (hadamard M1 M2)
    (define (multRow R1 R2)
        (if (null? R1) '() (cons (* (car R1) (car R2)) (multRow (cdr R1) (cdr R2)))))
        
    (if (null? M1) '()
        (if (not (sameSize M1 M2)) (hadamardErr)
        (cons (multRow (car M1) (car M2)) (hadamard (cdr M1) (cdr M2))))))
    
    
(define (dotProduct R1 R2)
    (if (null? R1) 0 (+ (* (car R1) (car R2) ) (dotProduct (cdr R1) (cdr R2)))))

(define (mapM M f)
    (define (mapRow R f) (if (null? R) '() 
        (cons (f (car R)) (mapRow (cdr R) f))))
        
    (if (= 0 (rows M)) '()
        (cons (mapRow (car M) f) (mapM (cdr M) f)))) 
        
(define (transpose M)
    (define (attachColumn C M)  
        (cond ((null? M) C)
              (#t       (cons (cons (car (car C)) (car M)) 
                                    (attachColumn (cdr C) (cdr M))))))
                                    
    (if (null? M) '()
        (attachColumn (map list (car M)) (transpose (cdr M)))))
        
    
    
(define (sameSize? M1 M2)
        (equal? (size M1) (size M2)))

(define (size M)
    (list (rows m) (columns M)))
    
(define (rows M)
    (length M))
    
(define (columns M)
    (length (car M)))
    
    
    
(define (randomMatrix R C)
    (define (randomList C) (if (= C 0) '() 
        (cons (/ (round (* 100000.0 (random))) 100000.0) (randomList (- C 1)))))
        
    (if (= R 0) '() (cons (randomList C) (randomMatrix (- R 1) C))))

(define random
  (let ((a 69069) (c 1) (m (expt 2 32)) (seed 19380110))
    (lambda new-seed
      (if (pair? new-seed)
          (set! seed (car new-seed))
          (set! seed (modulo (+ (* seed a) c) m)))
      (/ seed m))))
    
    
    