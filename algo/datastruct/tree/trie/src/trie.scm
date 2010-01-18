;; Alphabetic Trie

(load "trieutil.scm")

;; Definition

(define (make-trie v lop) ;; v: value, lop: children, list of char-trie pairs
  (cons v lop))

(define (empty-trie)
  (make-trie '() '()))

(define (value t)
  (if (null? t) '() (car t)))

(define (children t)
  (if (null? t) '() (cdr t)))

(define (make-child k t)
  (cons k t))

(define (key child)
  (if (null? child) '() (car child)))

(define (tree child)
  (if (null? child) '() (cdr child)))

(define (string-car s)
  (string-head s 1))

(define (string-cdr s)
  (string-tail s 1))

;; Insertion
(define (insert t k x)
  (define (ins lst k ks x) ;; return list of child
    (if (null? lst)
	(list (make-child k (insert '() ks x)))
	(if (string=? (key (car lst)) k)
	    (cons (make-child k (insert (tree (car lst)) ks x)) (cdr lst))
	    (cons (car lst) (ins (cdr lst) k ks x)))))
  (if (string-null? k) 
      (make-trie x (children t))
      (make-trie (value t) 
		 (ins (children t) (string-car k) (string-cdr k) x))))

;; Test helpers

;; sort children base on keys
(define (sort-children lst)
  (if (null? lst) '()
      (let ((xs (filter (lambda (c) (string<=? (key c) (key (car lst)))) 
			(cdr lst)))
	    (ys (filter (lambda (c) (string>?  (key c) (key (car lst)))) 
			(cdr lst))))
	(append (sort-children xs) 
		(list (car lst))
		(sort-children ys)))))

(define (trie->string t)
  (define (value->string x)
    (cond ((null? x) ".")
	  ((number? x) (number->string x))
	  ((string? x) x)
	  (else "unknon value")))
  (define (trie->str t prefix)
    (define (child->str c)
      (string-append ", " (trie->str (tree c) (string-append prefix (key c)))))
    (let ((lst (map child->str (sort-children (children t)))))
      (string-append "(" prefix (value->string (value t))
		     (fold-left string-append "" lst) ")")))
  (trie->str t ""))

(define (test-trie)
  (define t (list->trie (list '("a" 1) '("an" 2) '("another" 7) '("boy" 3) '("bool" 4) '("zoo" 3))))
  (display (trie->string t)) (newline))
