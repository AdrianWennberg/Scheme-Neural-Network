
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

; Setup activation function as sigmoid
(define activationFunc sig)
(define activationFuncDeriv sigD)

(define maxStartWeight 1)
(define learningRate 10)
(define hiddenNodes 5)
(define iterations 10000)


; ------------ Creating the Neural Network -----------
(define NN (newNN maxStartWeight (list 2 hiddenNodes 1)))
(display NN)

(runNN NN '((0) (0)))
(runNN NN '((0) (1)))
(runNN NN '((1) (0)))
(runNN NN '((1) (1)))

(define trained (trainLoop NN xorData iterations learningRate))
(display trained)

(runNN trained '((0) (0)))
(runNN trained '((0) (1)))
(runNN trained '((1) (0)))
(runNN trained '((1) (1)))

(totalError NN xorData)
(totalError trained xorData)