
(load "src/NN.sch")
(load "src/dataFormatter.sch")

; ------------------ Data definition -----------------
(define xorData 
    (list
        (list (vector 0 0) (vector 0))
        (list (vector 0 1) (vector 1))
        (list (vector 1 0) (vector 1))
        (list (vector 1 1) (vector 0))
    )
)

; Setup activation functions as sigmoid
(define hiddenActivationFunc sig)
(define hiddenActivationFuncDeriv sigD)
(define outputActivationFunc sig)
(define outputActivationFuncDeriv sigD)


(define maxStartWeight 0.5)
(define learningRate 10)
(define hiddenNodes 5)
(define iterations 100)
(define batchSize 4)


; Setup file for logging experiment data
(define formatHolder (getDataFormatter "examples/xor/runs/" "xor" 6))
(define formatter (car formatHolder))
(define infoFormatter (cadr formatHolder))
(define networkWriter (caddr formatHolder))
(define closeFiles (cadddr formatHolder))

; ------------ Creating the Neural Network -----------
(define untrained (newNN maxStartWeight (list 2 hiddenNodes 1)))

; ------------ Training the Neural Network -----------
(define startTime (runtime))
(define trained (trainLoopBatchRecording untrained xorData iterations batchSize learningRate xorData formatter))
(define trainTime (- (runtime) startTime))


(display untrained)
(display trained)

(runNN untrained (vector 0 0))
(runNN untrained (vector 0 1))
(runNN untrained (vector 1 0))
(runNN untrained (vector 1 1))

(runNN trained (vector 0 0))
(runNN trained (vector 0 1))
(runNN trained (vector 1 0))
(runNN trained (vector 1 1))

(avgMSE untrained xorData)
(define finalError (avgMSE trained xorData))

(networkWriter trained)

(infoFormatter 
        maxStartWeight 
        learningRate
        hiddenNodes
        iterations
        batchSize
        trainTime
        finalError
        finalError)

(closeFiles)