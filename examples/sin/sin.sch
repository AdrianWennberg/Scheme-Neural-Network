
(load "src/NN.sch")
(load "examples/sin/createData.sch")
(load "src/dataFormatter.sch")

; ------------------ Data definition -----------------
(define testData 
     (sinData 50)
)

(define trainData 
     (sinData 150)
)

; Setup activation functions. Sigmoid for hidden and linear for output
(define hiddenActivationFunc sig)
(define hiddenActivationFuncDeriv sigD)
(define outputActivationFunc linear)
(define outputActivationFuncDeriv linearD)


(define maxStartWeight 0.01)
(define learningRate 0.01)
(define hiddenNodes 7)
(define iterations 1000)
(define batchSize 10)


; Setup file for logging experiment data
(define formatHolder (getDataFormatter "examples/sin/runs/" "sin" 6))
(define formatter (car formatHolder))
(define infoFormatter (cadr formatHolder))
(define networkWriter (caddr formatHolder))
(define closeFiles (cadddr formatHolder))


; ------------ Creating the Neural Network -----------
(define untrained (newNN maxStartWeight (list 4 hiddenNodes 1)))

; ------------ Training the Neural Network -----------
(define startTime (runtime))
(define trained (trainLoopBatchRecording untrained trainData iterations batchSize learningRate testData formatter))
(define trainTime (- (runtime) startTime))

(avgMSE untrained trainData)
(avgMSE trained trainData)

(avgMSE untrained testData)
(avgMSE trained testData)

(define trainError (avgMSE trained trainData))
(define testError (avgMSE trained testData))

(runNN trained (caar testData))
(cadar testData)

(runtime)

(networkWriter trained)

(infoFormatter 
        maxStartWeight 
        learningRate
        hiddenNodes
        iterations
        batchSize
        trainTime
        trainError
        testError)

(closeFiles)