(load "examples/letters/createData.sch")
(load "src/NN.sch")
(load "src/dataFormatter.sch")


; ------------------ Data definition -----------------
(define trainProportion 0.80)
(define fullData (splitTrainTest (readDataFile "examples/letters/letter-recognition.data") trainProportion))

(define trainData (car fullData))
(define testData (cadr fullData))


; Setup activation functions as sigmoid
(define hiddenActivationFunc sig)
(define hiddenActivationFuncDeriv sigD)
(define outputActivationFunc sig)
(define outputActivationFuncDeriv sigD)


(define maxStartWeight 0.01)
(define learningRate 0.002)
(define hiddenNodes 12)
(define iterations 1000)
(define batchSize 100)

; Setup file for logging experiment data
(define formatHolder (getDataFormatter "examples/letters/runs/" "letters" 8))
(define formatter (car formatHolder))
(define infoFormatter (cadr formatHolder))
(define networkWriter (caddr formatHolder))
(define closeFiles (cadddr formatHolder))

; ------------ Creating the Neural Network -----------
(define untrained (newNN maxStartWeight (list 16 hiddenNodes 26)))


; ------------ Training the Neural Network -----------
(define startTime (runtime))
(define trained (trainLoopBatchRecording untrained trainData iterations batchSize learningRate testData formatter))
(define trainTime (- (runtime) startTime))



(define trainError (avgMSE trained trainData))
(define testError (avgMSE trained testData))

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

(runtime)