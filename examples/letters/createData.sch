(load "src/matrix/matrix.sch")
(load "src/utility.sch")

; We are using an MIT letter recognition dataset. More info here:
; http://archive.ics.uci.edu/ml/datasets/Letter+Recognition

; Turns a capital letter to an integer with A->0, B->1, ...
(define (charToInt c)
    (- (char->integer c) 65)
)

; Turns a integer character to an integer with 0->0, 1->1, ...
(define (numToInt c)
    (- (char->integer c) 48)
)

; Checks if a character is an integer
(define (isInt? c)
    ((lambda (i) (and (< -1 i) (> 10 i))) (numToInt c))
)

; Creates an output vector of length L with L - 1 0s and a 1 at the Nth position (starting at 0)
(define (createOutputVector N L)
    (cond 
        ((zero? L) '())
        ((zero? N) (cons 
            '(1) 
            (createOutputVector (- N 1) (- L 1))
        ))
        (#t (cons 
            '(0) 
            (createOutputVector (- N 1) (- L 1))
        ))
    )
)

; Reads a number from an input port.
; Consumes one character after the number.
(define (readNumber inputPort)
    (define (readDigits)
        (define character (read-char inputPort))
        (cond 
            ((eof-object? character) '())
            ((isInt? character) (cons character (readDigits)))
            (#t '())
        )
    )
    (string->number (list->string (readDigits)))
)


; Creates an input vector of length L from the given input port. 
; Assumes one line of L comma separated values and consumes the newline character at the end.
(define (readInputData inputPort L)
    (if (zero? L)
        '()
        (cons 
            (readNumber inputPort)
            (readInputData inputPort (- L 1))
        )
    )
)

(define (readLine inputPort)
    (define outputIndex (charToInt (read-char inputPort)))
    (read-char inputPort)
    (list 
        (transpose (list (reverse (readInputData inputPort 16)))) 
        (createOutputVector outputIndex 26)
    )
)


(define (readDataFile fileName)
    (define (readDataLines input)
        (if (eof-object? (peek-char input))
            '()
            ((lambda (fileLine) (cons fileLine (readDataLines input)))
                (readLine input)
            )
        )
    )
    (readDataLines (open-input-file fileName))
)


(define (splitTrainTest data proportion)
    (split 
        (floor (* (length data) proportion)) 
        data
    )
)

(define file (open-input-file "examples/letters/data-sample.data"))

(define outputLetter (read-char file))

(display outputLetter)
(charToInt outputLetter)

(read-char file)
(numToInt (read-char file))


(read-char file)
(numToInt (read-char file))

(isInt? #\T)
(isInt? #\0)
(isInt? #\9)

(list->string (list #\0 #\9 #\1) )

(readNumber (open-input-string "ABC"))
(readNumber (open-input-string "21C"))
(readNumber (open-input-string "123"))

(define input (open-input-string "2,8,3,5,1,8,13,0,6,6,10,8,0,8,0,8"))

(readNumber input)
(readNumber input)
(readNumber input)

(define input (open-input-string "2,8,3,5,1,8,13,0,6,6,10,8,0,8,0,8"))

(readInputData input 16)


(define input (open-input-file "examples/letters/data-sample.data"))

(readLine input)
(readLine input)


