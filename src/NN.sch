(load "src/utility.sch")


; Creates a new neural networks with initial weights being random numbers up to 'lim'
; and the the numbers of input, hidden, and output nodes given by the list 'layers'
; E.G. layers = (4 5 6 2) implies 4 inputs, 2 hidden layers with 5 and 6 weights respectively
; and 2 outputs. Biases are added automatically and need not be considered here.
(define (newNN lim layers)
    (if (or (null? layers) (null? (cdr layers))) 
        () 
        (cons 
            (m:generate (cadr layers) (+ (car layers) 1) (lambda (i j) (randRange (- 1) 1)))
            (newNN lim (cdr layers))
        )
    )
)

; Adds a bias term to a 1xN row matrix
(define (addBias R) 
    (apply vector (cons 1 (vector->list  R)))
)


; Removes a bias terms from a weight matrix
(define (removeBiasWeights W) 
    (m:submatrix W
        0
        (m:num-rows W)
        1
        (m:num-cols W)
    )
)


(define (activate R M)
    (* M (addBias R))
)

; Computes a single layer activations
(define (getOutput func activation ) 
    ((vector:elementwise func) activation)
)

(define (ff func R M ) 
    (getOutput func (activate R M))
)

; Computes the predictions fro the network for the given input
(define (runNN NN in)
    (if (= 1 (length NN))
        (ff outputActivationFunc in (car NN))
        (runNN (cdr NN) (ff hiddenActivationFunc in (car NN)))
    )
)

; Gives all input-activation-output triples foreach layer in a given prediction
(define (layerData in NN) 
    (if (= 1 (length NN))
        ; For Output layer
        ((lambda () 
            (define input (addBias in))
            (define activation (activate in (car NN)))
            (define output (getOutput outputActivationFunc activation))
            (list (list input activation output))
        ))
        ; for Hidden Layers
        ((lambda () 
            (define input (addBias in))
            (define activation (activate in (car NN)))
            (define output (getOutput hiddenActivationFunc activation))
            (cons 
                (list input activation output) 
                (layerData output (cdr NN))
            )
        ))
    )
)

; Calculates the error for an output
(define (MSE expected output)
    (/ 
        (apply + (vector->list ((v:elementwise square) (- expected output))))
        (vector-length expected)
    )
)

; Calculate the total error over a training set
(define (totalMSE NN trainData)
    (if (= (length trainData) 1)
        (MSE (cadar trainData) (runNN NN (caar trainData)))
        (+ 
            (MSE (cadar trainData) (runNN NN (caar trainData)))
            (totalMSE NN (cdr trainData))
        )
    )
)

; Calculate the average Mean Squared Error over a training set
(define (avgMSE NN trainData)
    (/ 
        (totalMSE NN trainData)
        (length trainData)
    )
)


; Computes the vector value for an output vector
(define (deltaOut target output activations) 
    ((v:elementwise *) 
        (- target output)
        ((v:elementwise outputActivationFuncDeriv) activations)
    )
) 

; Computes the vector value for a hidden vector
(define (deltaHidden deltaNext weightsNext activations) 
    ((v:elementwise *)
        (* 
            (m:transpose (removeBiasWeights weightsNext))
            deltaNext
        )
        ((v:elementwise hiddenActivationFuncDeriv) activations)
    ) 
) 

; Uses the delta values to compute the weight change of a weights matrix
(define (weightChange learnRate delta inputs)
    (apply matrix-by-rows 
        (map vector->list (vector->list 
            (* inputs (* learnRate delta) )
        ))
    )
)


(define (addWeights NN1 NN2) 
    (if (null? NN1)
        '()
        (cons 
            (+ (car NN1) (car NN2))
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


(define (trainAllBatches NN trainData batchSize learnRate)
    (define (trainBatches NN batches)
        (if (null? batches) 
            NN
            (trainBatches 
                (addWeights
                    NN
                    (trainAll NN (car batches) learnRate)
                )
                (cdr batches)
            )
        )
    )
    (trainBatches NN (splitEveryN batchSize trainData))
)

    
(define (trainLoop NN trainData i learnRate)
    (if (= i 0) 
        NN 
        (trainLoop 
            (addWeights
                NN
                (trainAll NN trainData learnRate)
            )
            trainData 
            (- i 1)
            learnRate
        )
    )
)

(define (trainLoopBatch NN trainData i batchSize learnRate)
    (if (= i 0) 
        NN 
        (trainLoopBatch 
            (trainAllBatches NN trainData batchSize learnRate)
            trainData 
            (- i 1)
            batchSize
            learnRate
        )    
    )
)
    
(define (trainLoopBatchRecording NN trainData i batchSize learnRate testData dataFormatter)
    (if (= i 0) 
        ((lambda ()
            (dataFormatter 0 (avgMSE NN testData))
            NN 
        ))
        ((lambda () 
            (define prevEpoch (trainLoopBatchRecording 
                NN
                trainData 
                (- i 1)
                batchSize
                learnRate
                testData
                dataFormatter
            ))
            (define result (trainAllBatches prevEpoch trainData batchSize learnRate))
            (dataFormatter i (avgMSE result testData))
            result
        ))    
    )
)
