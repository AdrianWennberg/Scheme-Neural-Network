
(load "src/NN.sch")
(load "examples/sin/createData.sch")
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


; ------------ Creating the Neural Network -----------
(define untrained (newNN maxStartWeight (list 4 hiddenNodes 1)))
(define trained (trainLoopBatch untrained trainData iterations batchSize learningRate))

(avgMSE untrained trainData)
(avgMSE trained trainData)

(avgMSE untrained testData)
(avgMSE trained testData)