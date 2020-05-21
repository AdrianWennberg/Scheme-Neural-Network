(load "src/utility.sch")
(load "src/matrix/matrix.sch")


; Creates a new neural networks with initial weights being random numbers up to 'lim'
; and the the numbers of input, hidden, and output nodes given by the list 'layers'
; E.G. layers = (4 5 6 2) implies 4 inputs, 2 hidden layers with 5 and 6 weights respectively
; and 2 outputs. Biases are added automatically and need not be considered here.
(define (newNN lim layers)
    (if (or (null? layers) (null? (cdr layers))) 
        () 
        (cons 
            (mapM (lambda (i) (* (- (* i lim) (/ lim 2.0)) 2.0)) (randM (cadr layers) (+ (car layers) 1))) 
            (newNN lim (cdr layers))
        )
    )
)

; Adds a bias term to a 1xN row matrix
(define (addBias R) 
    (cons '(1) R)
)


; Removes a bias terms from a weight matrix
(define (removeBiasWeights W) 
    (if (null? W)
        '()
        (cons 
            (cdr (car W)) 
            (removeBiasWeights (cdr W))
        )
    )
)


(define (activate R M)
    (prodMM M (addBias R))
)

; Computes a single layer activations
(define (getOutput func activation ) 
    (mapM func activation)
)

(define (ff R M ) 
    (getOutput activationFunc (activate R M))
)

; Computes the predictions fro the network for the given input
(define (runNN nn in)
    (if (null? nn) 
        in 
        (runNN (cdr nn) (ff in (car nn)))
    )
)

; Gives all input-activation-output triples foreach layer in a given prediction
(define (layerData in nn) 
    (if (null? nn) 
        '()
        ((lambda () 
            (define input (addBias in))
            (define activation (activate in (car nn)))
            (define output (getOutput activationFunc activation))
            (cons 
                (list input activation output) 
                (layerData output (cdr nn))
            )
        ))
    )
)

; Calculates the error for an output
(define (error expected output)
    (prodCM 0.5 
        ((lambda (x) (hadamardM x x)) 
            (addM expected (mapM - output))
        )
    )
)

; Calculate the total error over a training set
(define (totalError NN trainData)
    (if (= (length trainData) 1)
        (error (cadar trainData) (runNN NN (caar trainData)))
        (addM 
            (error (cadar trainData) (runNN NN (caar trainData)))
            (totalError NN (cdr trainData))
        )
    )
)


; Computes the vector value for an output vector
(define (deltaOut target output activations) 
    (hadamardM 
        (addM target (mapM - output)) 
        (mapM activationFuncDeriv activations)
    )
) 

; Computes the vector value for a hidden vector
(define (deltaHidden deltaNext weightsNext activations) 
    (hadamardM
        (prodMM 
            (transpose (removeBiasWeights weightsNext))
            deltaNext
        )
        (mapM activationFuncDeriv activations)
    ) 
) 

; Uses the delata values to compute the weight change of a weights matrix
(define (weightChange learnRate delta inputs)
    (prodMM  (prodCM learnRate delta) (transpose inputs))
)


(define (addWeights NN1 NN2) 
    (if (null? NN1)
        '()
        (cons 
            (addM (car NN1) (car NN2))
            (addWeights (cdr NN1) (cdr NN2))
        )
    )
)

(define (train NN trainData learnRate)
    ; Returns so far computed weight changes along with delta of next layer (delta-next (weight-changes))
    (define (backpropagate NN data)
        (if (= (length NN) 1) 
            ((lambda (deltaOut)
                (list deltaOut 
                    (weightChange 
                        learnRate 
                        deltaOut 
                        (caar data) 
                    )
                )
            ) (deltaOut 
                (cadr trainData)
                (caddar data)
                (cadar data)
            ))
            ((lambda (x)
                (list 
                    (deltaHidden (car x) (cadr NN) (cadar data))
                    (cons 
                        (weightChange learnRate (deltaHidden (car x) (cadr NN) (cadar data)) (caar data))
                        (cdr x)
                    )
                )  
            ) (backpropagate (cdr NN) (cdr data))
            )
        )
    )
    (cadr (backpropagate NN (layerData (car trainData) NN)))
)

(define (trainAll NN trainData learnRate)
    (if (= (length trainData) 1)
        (train NN (car trainData) learnRate) 
        (addWeights 
            (train NN (car trainData) learnRate) 
            (trainAll NN (cdr trainData) learnRate)
        )
    )
)

    
(define (trainLoop nn trainData i learnRate)
    (if (= i 0) 
        nn 
        (trainLoop 
            (addWeights
                nn
                (trainAll nn trainData learnRate)
            )
            trainData 
            (- i 1)
            learnRate
        )
    )
)
    

