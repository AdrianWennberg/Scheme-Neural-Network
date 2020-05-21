(load "src/NN.sch")
; testing is done for now using the XOR toy example of a training problem
(define activationFunc sig)
(define activationFuncDeriv sigD)

; ------------------ Data definition -----------------
(define xorData 
    '(
        (((0) (0)) ((0)))
        (((0) (1)) ((1)))
        (((1) (0)) ((1)))
        (((1) (1)) ((0)))
    )
)

; ----------- Creating a new Neural Network ----------
(define NN (newNN 0.01 '(2 3 1)))
(display NN)

(define testIn '((0) (0)))
(define testOut '((1)))


; --------------- Adding bias to a row ---------------
(addBias '((1) (2) (3)))


; ------- Remove bias weights from a matrix ----------
(removeBiasWeights '((1 2 3) (2 4 5) (3 5 6)))


; ------------- Computing activations  ---------------
(define a1 (activate testIn (car NN)))
(display a1)

; ------------ Computing results directly ------------
(getOutput sig (activate testIn (car NN)))
(getOutput sig (activate (getOutput sig (activate testIn (car NN))) (cadr NN)))


; --------- Running the NN to get prediction ---------
(define out (runNN NN testIn ))
(display out)

; ----- Computing all activations layer by layer -----
(define data (layerData testIn NN))
(display data)

; ----------- Compute true error of output -----------
(error out testOut)

; ---- Errors and weight changes for output layer ----
(define outData (car (cdr data)))
(define outInputs (car outData))
(define outActivations (car (cdr outData)))
(display outInputs)
(display outActivations)
(define outDelta (deltaOut testOut out outActivations))
(display outDelta)

(define outChange (weightChange 0.01 outDelta outInputs))
(display outChange)


; ---- Errors and weight changes for hidden layer ----
(define hiddenData (car data))
(define hiddenInputs (car hiddenData))
(define hiddenActivations (car (cdr hiddenData)))
(display hiddenInputs)
(display hiddenActivations)
(display (removeBiasWeights (cadr NN)))
(define hiddenDelta (deltaHidden outDelta (cadr NN) hiddenActivations))
(display hiddenDelta)

(define hiddenChange (weightChange 0.01 hiddenDelta hiddenInputs))
(display hiddenChange)
(display NN)
(display (list hiddenChange outChange))

(addWeights NN (list hiddenChange outChange))



; ----------- Single itteration of training ----------

(train NN '(((1) (0)) ((1))) 0.01)
(trainAll NN xorData 0.01)


; ------------ Ten itterations of training -----------

(trainLoop NN xorData 10 0.01)