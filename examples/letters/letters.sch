(load "examples/letters/createData.sch")
(load "src/NN.sch")

(define trainProportion 0.8)

(define fullData (splitTrainTest (readDataFile "examples/letters/letter-recognition.data") trainProportion))

(define trainData (car fullData))
(define testData (cadr fullData))
(display (length trainData))
(display (length testData))


(display (car testData))


; Setup activation functions as sigmoid
(define hiddenActivationFunc sig)
(define hiddenActivationFuncDeriv sigD)
(define outputActivationFunc sig)
(define outputActivationFuncDeriv sigD)


(define maxStartWeight 0.1)
(define learningRate 1)
(define hiddenNodes 5)
(define iterations 1)
(define batchSize 10)


; ------------ Creating the Neural Network -----------
(define untrained (newNN maxStartWeight (list 16 hiddenNodes 26)))


(runtime)
(define trained (trainLoopBatch untrained trainData iterations batchSize learningRate))

(runtime)


(caar testData)
(cadar testData)
(runNN trained (caar testData))


(caar trainData)
(cadar trainData)
(runNN trained (caar trainData))


(define trainError (MSE trained trainData))
(define testError (MSE trained testData))
(display trainError)
(display testError)
(/ (reduce-left + 0 (car (transpose trainError))) 26)
(/ (reduce-left + 0 (car (transpose testError))) 26)

(runtime)