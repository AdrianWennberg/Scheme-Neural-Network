
(load "src/NN.sch")

; ------------------ Data definition -----------------
(define xorData 
    '(
        (((0) (0)) ((0)))
        (((0) (1)) ((1)))
        (((1) (0)) ((1)))
        (((1) (1)) ((0)))
    )
)

; Setup activation functions as sigmoid
(define hiddenActivationFunc sig)
(define hiddenActivationFuncDeriv sigD)
(define outputActivationFunc sig)
(define outputActivationFuncDeriv sigD)


(define maxStartWeight 1)
(define learningRate 10)
(define hiddenNodes 5)
(define iterations 100)


; ------------ Creating the Neural Network -----------
(define untrained (newNN maxStartWeight (list 2 hiddenNodes 1)))
(define trained (trainLoop untrained xorData iterations learningRate))
(display untrained)
(display trained)

(runNN untrained '((0) (0)))
(runNN untrained '((0) (1)))
(runNN untrained '((1) (0)))
(runNN untrained '((1) (1)))

(runNN trained '((0) (0)))
(runNN trained '((0) (1)))
(runNN trained '((1) (0)))
(runNN trained '((1) (1)))

(MSE untrained xorData)
(MSE trained xorData)