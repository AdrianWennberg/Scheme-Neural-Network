(load "src/utility.sch")

(define (getDataFormatter directory experimentName precision)
    (define timeString (getCurrentTimeString))
    (define errorFileName (string-append directory experimentName timeString "errors.data"))
    (define errorFile (open-output-file errorFileName))
    (define power (expt 10 precision))

    (display "Epoch,Error" errorFile)
    (newline errorFile)
    (define (formatEntry epoch error)
        (display epoch errorFile)
        (display ",0" errorFile)
        (display (floorN error power) errorFile)
        (newline errorFile)
    )

    (define infoFileName (string-append directory experimentName timeString "info.data"))
    (define infoFile (open-output-file infoFileName))

    (define (writeInfo 
        maxStartWeight 
        learningRate
        hiddenNodes
        iterations
        batchSize
        timeTaken
        trainError
        testError
        )
        (display (string-append experimentName timeString) infoFile)
        (newline infoFile) (display "Settings:" infoFile)
        (newline infoFile) (display (string-append "  Starting weight range: " (number->string (- maxStartWeight)) "," (number->string maxStartWeight)) infoFile)
        (newline infoFile) (display (string-append "  Learning Rate: " (number->string learningRate)) infoFile)
        (newline infoFile) (display (string-append "  Number of hidden nodes: " (number->string hiddenNodes)) infoFile)
        (newline infoFile) (display (string-append "  Total number of epochs: " (number->string iterations)) infoFile)
        (newline infoFile) (display (string-append "  Batch size: " (number->string batchSize)) infoFile)
        (newline infoFile)
        (newline infoFile) (display "Results:" infoFile)
        (newline infoFile) (display (string-append "  Total time taken(seconds): " (number->string timeTaken)) infoFile)
        (newline infoFile) (display (string-append "  Final mean squared error(train): " (number->string (floorN trainError power))) infoFile)
        (newline infoFile) (display (string-append "  Final mean squared error(test): " (number->string (floorN testError power))) infoFile)
    )

    (define networkFileName (string-append directory experimentName timeString "network.data"))
    (define networkFile (open-output-file networkFileName))

    (display "(list " networkFile)
    (define (writeNetwork network)
        (define (writeVector vector)
                (newline networkFile)
                (display "(list " networkFile)
                ((v:elementwise (lambda (x) (display x networkFile) (display " " networkFile))) vector) 
                (display ")" networkFile)
        )

        (define (writeMatrix matrix row)
            (if (= row (m:num-rows matrix))
                '()
                ((lambda ()
                    (writeVector (m:nth-row matrix row))
                    (writeMatrix matrix (+ row 1))
                ))
            )
        )

        (if (null? network)
            ((lambda ()
                (newline networkFile) 
                (display ")" networkFile)
            ))
            ((lambda ()
                (newline networkFile)
                (display "(matrix-by-rows " networkFile)
                (writeMatrix (car network) 0)
                (newline networkFile)
                (display ")" networkFile)
                (writeNetwork (cdr network))
            ))
        )
    )


    (define (closeFormatter)
        (close-output-port errorFile)
        (close-output-port infoFile)
        (close-output-port networkFile)
    )
    (list formatEntry writeInfo writeNetwork closeFormatter networkFileName)
)
