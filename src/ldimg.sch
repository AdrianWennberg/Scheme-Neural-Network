(define offset 16)

(define readBytes (lambda (n F) (if (= n 0) '() (cons (read-byte f) (readBytes (- n 1) F )))))

(define loadImages (lambda (n) 
    (define readPixels (lambda (n F) (if (= n 0) '() (cons (/ (read-byte f) 255) (readPixels (- n 1) F )))))
    (define readImages (lambda (n F) (if (= n 0) '() (cons (list (readPixels 784 F)) (readImages (- n 1) F) ))))
    (define image-file (open-binary-input-file "train-images.idx3-ubyte"))
    
    (readBytes offset image-file)
    (readImages n image-file)))
