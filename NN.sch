(load "matrix.sch")
(define trainData '((((1 0)) ((1)) )(((0 1)) ((1)) )(((0 0)) ((0)) )(((1 1)) ((0)) )))


(define newNN (lambda x
    (if (or (null? x) (null? (cdr x))) () (cons (randomMatrix (+ (car x) 1) (cadr x)) (apply newNN (cdr x)))))) 


(define (runNN nn in)
    (define (addBias R) (list (cons 1 (car R))))
    (define (ff R M) (map (mult (addBias R) M) sig))
    (if (null? nn) in (runNN (cdr nn) (ff in (car nn)))))

(define (train nn trainData )
    (define (get N L) (if (= N 0) (car L) (get (- N 1) (cdr L))))
    
    (define (data) 
        (get (floor (* (random) (length trainData))) trainData))
    
    (define (addBias R) (list (cons 1 (car R))))
    (define (ff R M) (map (mult (addBias R) M) sig))
    (define (results in nn) (if (null? nn) '()
        ((lambda (in out) (cons (list in out) (results out (cdr nn)))) (addBias in) (ff in (car nn)))))
    
    (define (gradients res err) (map (hadamard (map res sig') err) (lambda (x) (* x 100 )))) 
    (define (deltas in gradients) (mult (transpose in) gradients))
    (define (newWeights err in res weights) (add weights (deltas in (gradients res err))) )
    
    (define (oNewWeihgts in exOut res weights) 
        (define err (add exOut (map  res -)))
        (list err (newWeights err in res weights)))
        
    (define (hNewWeights in res nextErr nn) 
        (define err (list (cdr (car (mult nextErr (transpose (cadr nn)))))))
        (list err (newWeights err in res (car nn))))
        
    (define (backpropagate nn results data)
        (if (= (length nn) 1) 
            (oNewWeihgts (car (car results)) (cadr data) (cadr (car results)) (car nn))
            ((lambda (x) (append  (hNewWeights (car (car results)) (cadr (car results)) (car x) nn) (cdr x)))
                (backpropagate (cdr nn) (cdr results) data))))
           
    (cdr ((lambda (x) (backpropagate      nn       (results (car x) nn)  x)  ) (data))))
    
(define (trainLoop nn trainData i)
    (if (= i 0) nn (trainLoop (train nn trainData)  trainData (- i 1))))
    
    
(define (sig x) (/ 1 (+ 1 (exp (- x)))))
(define (sig' x) (* x (- 1 x)))

