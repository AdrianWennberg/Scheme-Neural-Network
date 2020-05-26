(load "examples/letters/createData.sch")
(load "src/NN.sch")
(load "src/dataFormatter.sch")

(define digits 4)
(define power (expt 10 digits))

(define (showData NN N data)
    (if (zero? N)
        ((lambda () 
            (newline)
            (display (predicted (cadar data))) 
            (display (cadar data))
            (newline)
            (display (predicted (runNN NN (caar data))))
            (display ((v:elementwise (lambda (x) (/ (round (* x power)) power))) (runNN NN (caar data))))
        ))
        (showData NN (- N 1) (cdr data))
    )
)

(define (showNData NN N data offset)
    (cond 
        ((zero? N) '())
        ((zero? offset) 
            (showData 0 data)
            (newline)
            (showNData NN (- N 1) (cdr data) offset)
        )
        (#t (showNData NN N (cdr data) (- offset 1)))
    )
)

(define (getData NN data)
    (list 
        (predicted (cadar data))
        (predicted (runNN NN (caar data)))
        (cadar data)
        ((v:elementwise (lambda (x) (/ (round (* x power)) power))) (runNN NN (caar data)))
    )
)


(define (getNData NN N data offset)
    (cond 
        ((zero? N) '())
        ((zero? offset) 
            (cons 
                (getData NN data)
                (getNData NN (- N 1) (cdr data) offset)
            )
        )
        (#t (getNData NN N (cdr data) (- offset 1)))
    )
)

(define (countCorrect NN data)
    (cond 
        ((null? data) 0)
        ((eq? (predicted (cadar data)) (predicted (runNN NN (caar data)))) 
            (+ 1 (countCorrect NN (cdr data)))
        )
        (#t (countCorrect NN (cdr data)))
    )
)

; ------------------ Data definition -----------------
(define trainProportion 0.80)
(define fullData (splitTrainTest (readDataFile "examples/letters/letter-recognition.data") trainProportion))

(define trainData (car fullData))
(define testData (cadr fullData))

; ------- Setup activation functions as sigmoid ------
(define hiddenActivationFunc sig)
(define hiddenActivationFuncDeriv sigD)
(define outputActivationFunc sig)
(define outputActivationFuncDeriv sigD)

; -------------------- Load Network ------------------
(define trained (load "examples/letters/runs/letters20200524154537network.data"))

(countCorrect trained trainData)
(length trainData)
(countCorrect trained testData)
(length testData)
