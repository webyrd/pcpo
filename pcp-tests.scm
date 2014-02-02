(load "pcp.scm")
(load "mk/test-check.scm")


(define zhao-1.1-tiles '(((1 0 0) (1) pair-1)
                         ((0) (1 0 0) pair-2)
                         ((1) (0 0) pair-3)))

(test "PCP 1.1 from Zhao's Master's thesis"
  (run 1 (str name-ls) (pcpo str name-ls zhao-1.1-tiles))
  '(((1 0 0 1 1 0 0 1 0 0 1 0 0)
     (pair-1 pair-3 pair-1 pair-1 pair-3 pair-2 pair-2))))

(test "PCP 1.1 from Zhao's Master's thesis"
  (run 2 (str name-ls) (pcpo str name-ls zhao-1.1-tiles))
  '(((1 0 0 1 1 0 0 1 0 0 1 0 0)
     (pair-1 pair-3 pair-1 pair-1 pair-3 pair-2 pair-2))
    ((1 0 0 1 1 0 0 1 0 0 1 0 0 1 0 0 1 1 0 0 1 0 0 1 0 0)
     (pair-1 pair-3 pair-1 pair-1 pair-3 pair-2 pair-2 pair-1 pair-3 pair-1 pair-1 pair-3 pair-2 pair-2))))



(define penn-tiles '(((a b a b) (a b a b a a a) 1)
                     ((a a a b b b) (b b) 2)
                     ((a a b) (b a a b) 3)
                     ((b a) (b a a) 4)
                     ((a b) (b a) 5)
                     ((a a) (a) 6)))

(test "PCP example from http://www.cis.upenn.edu/~jean/gbooks/PCPh04.pdf"
  (run 1 (str) (pcpo str '(1 2 3 4 5 5 6) penn-tiles))
  '((a b a b a a a b b b a a b b a a b a b a a)))

(test "PCP example from http://www.cis.upenn.edu/~jean/gbooks/PCPh04.pdf"
  (run 10 (str name-ls) (pcpo str name-ls penn-tiles))
  '(((a b a b a a a b b b a a b)
     (1 2 3))
    ((b a a a) (4 6))
    ((b a a b a a) (4 5 6))
    ((a b a b a a a b b b a b a a b) (1 2 5 3))
    ((a b a b a a a a a a) (1 6 6 6))
    ((b a a b a b a a) (4 5 5 6))
    ((a b a b a a a a a b a a)
     (1 6 6 5 6))
    ((a b a b a a a b b b a b a b a a b) (1 2 5 5 3))
    ((b a a a a b a b a a a b b b a a b) (4 6 1 2 3))
    ((a b a b a a a b b b a a b a b a b a a a b b b a a b)
     (1 2 3 1 2 3))))

(test "PCP example from http://www.cis.upenn.edu/~jean/gbooks/PCPh04.pdf"
  (run 1 (str) (pcpo str '(1 2 3 4 5 5 5) penn-tiles))
  '())

(test "a little different-ez"
  (run 1 (tile1 tile2 tile3)
    (fresh (u1 l1
            u2 l2
            u3 l3)
      (== `(,u1 ,l1 pair-1) tile1)
      (== `(,u2 ,l2 pair-2) tile2)
      (== `(,u3 ,l3 pair-3) tile3)

      (== '(1 0 0) u1)
      (== '(1) l1)

      (== '(0) u2)
      (== '(1 0 0) l2)

      (== '(1) u3)
      (== '(0 0) l3)
            
      (pcpo '(1 0 0 1 1 0 0 1 0 0 1 0 0) '(pair-1 pair-3 pair-1 pair-1 pair-3 pair-2 pair-2)
            `(,tile1 ,tile2 ,tile3))))
  `(,zhao-1.1-tiles))

(test "a little different-generate-and-test"
  (run 1 (tile1 tile2 tile3)
    (fresh (u1 l1
            u2 l2
            u3 l3)
      (== `(,u1 ,l1 pair-1) tile1)
      (== `(,u2 ,l2 pair-2) tile2)
      (== `(,u3 ,l3 pair-3) tile3)            
      (pcpo '(1 0 0 1 1 0 0 1 0 0 1 0 0) '(pair-1 pair-3 pair-1 pair-1 pair-3 pair-2 pair-2)
            `(,tile1 ,tile2 ,tile3))
      (== `(,tile1 ,tile2 ,tile3) zhao-1.1-tiles)))
  `(,zhao-1.1-tiles))

(test "a little different-harder"
;; proof that only two possible sets of three tiles satisfy the problem  
  (run* (tile1 tile2 tile3)
    (fresh (u1 l1
            u2 l2
            u3 l3)
      (== `(,u1 ,l1 pair-1) tile1)
      (== `(,u2 ,l2 pair-2) tile2)
      (== `(,u3 ,l3 pair-3) tile3)            
      (pcpo '(1 0 0 1 1 0 0 1 0 0 1 0 0) '(pair-1 pair-3 pair-1 pair-1 pair-3 pair-2 pair-2)
            `(,tile1 ,tile2 ,tile3))))
  '((((1) (1 0 0) pair-1) ((1 0 0) (0) pair-2) ((0 0) (1) pair-3))
    (((1 0 0) (1) pair-1) ((0) (1 0 0) pair-2) ((1) (0 0) pair-3))))

(test "generate tiles and name-ls"
  (run 1 (name-ls tile1 tile2 tile3)
    (fresh (u1 l1
            u2 l2
            u3 l3)
      (== `(,u1 ,l1 pair-1) tile1)
      (== `(,u2 ,l2 pair-2) tile2)
      (== `(,u3 ,l3 pair-3) tile3)            
      (pcpo '(1 0 0 1 1 0 0 1 0 0 1 0 0) name-ls
            `(,tile1 ,tile2 ,tile3))))
  '(((pair-1 pair-2)
     ; tile set
     ((1) (1 0) pair-1)
     ((0 0 1 1 0 0 1 0 0 1 0 0) (0 1 1 0 0 1 0 0 1 0 0) pair-2)
     (_.0 _.1 pair-3))))

(test "generate tiles and name-ls and string"
  (run 1 (str name-ls tile1 tile2 tile3)
    (fresh (u1 l1
            u2 l2
            u3 l3)
      (== `(,u1 ,l1 pair-1) tile1)
      (== `(,u2 ,l2 pair-2) tile2)
      (== `(,u3 ,l3 pair-3) tile3)  
      (pcpo str name-ls `(,tile1 ,tile2 ,tile3))))
  '(((_.0 _.1 _.2 . _.3)
     (pair-1 pair-2)
     ((_.0) (_.0 _.1) pair-1)
     ((_.1 _.2 . _.3) (_.2 . _.3) pair-2)
     (_.4 _.5 pair-3))))

(test "generate tile-ls and name-ls and string"
  (run 1 (str name-ls tile-ls) (pcpo str name-ls tile-ls))
  '((((_.0 _.1 _.2 . _.3)
      (_.4 _.5)
      (((_.0) (_.0 _.1) _.4)
       ((_.1 _.2 . _.3) (_.2 . _.3) _.5)
       .
       _.6))
     (=/= ((_.4 _.5))))))

(test "generate a string and tile set such that a list of three distinct tiles is the solution"
  (run 1 (str name-ls tile-ls)
    (fresh (t1 t2 t3)
      (== `(,t1 ,t2 ,t3) name-ls)
      (=/= t1 t2)
      (=/= t1 t3)
      (=/= t2 t3)
      (pcpo str name-ls tile-ls)))
  '((((_.0 _.1 _.2 _.3 . _.4) ; string
      (_.5 _.6 _.7) ; list of tiles that forms the string
      ; tile set
      ;
      ; Tile name:       _.5       _.6       _.7
      ;
      ; Upper string:    _.0       _.1       _.2 _.3 . _.4
      ;
      ; Lower string:   _.0 _.1    _.2       _.3 . _.4
      (((_.0) (_.0 _.1) _.5)
       ((_.1) (_.2) _.6)
       ((_.2 _.3 . _.4) (_.3 . _.4) _.7)
       .
       _.8))
     (=/= ((_.1 _.2)) ((_.5 _.6)) ((_.5 _.7)) ((_.6 _.7))))))

(test "generate strings and decidable tile sets (with two tiles)"
  (run 1 (str name-ls tile-ls)
    (fresh (t1 t2)
      (== `(,t1 ,t2) tile-ls)
      (=/= t1 t2)
      (pcpo str name-ls tile-ls)))
  '((((_.0 _.1 _.2 . _.3) (_.4 _.5)
      (((_.0) (_.0 _.1) _.4) ((_.1 _.2 . _.3) (_.2 . _.3) _.5)))
     (=/= ((_.4 _.5))))))

(test "decidable-problem 1 (with two tiles in tile set)"
  (let ((tiles '(((1 0 0) (1) pair-1)
                 ((0) (1 0 0) pair-2))))
    (run 1 (name-ls)
      (pcpo '(0 1 1 3 2) name-ls tiles)))
  '())

(test "decidable-problem 2 (with two tiles in tile set)"
  (let ((tiles '(((1 0 0) (1) pair-1)
                 ((0) (1 0 0) pair-2))))
    (run 1 (name-ls)
      (pcpo '(0 1 1 0 1) name-ls tiles)))
  '())

(test "unknown whether 3 tiles is decidable"
  (let ((tiles '(((1 0 0) (1) pair-1)
                 ((0) (1 0 0) pair-2)
                 ((1) (0 0) pair-3))))
    (run 1 (name-ls)
      (pcpo '(0 1 1 0 1) name-ls tiles)))
  '())

#!eof

(test "easiest of the hards"
; solution has length 44
; almost certainly need A* search to have any chance of finding the solution
;  
; third problem from
; http://webdocs.cs.ualberta.ca/~games/PCP/doc/23hard.txt
;
; Instance 3:
; 3 3 44 1
; 101 1   0
; 1   0   10
;  
  (let ((tiles '(((1 0 1) (1) pair-1)
                 ((1) (0) pair-2)
                 ((0) (1 0) pair-3))))
    (run 1 (str name-ls)
      (pcpo str name-ls tiles)))
  '???)
