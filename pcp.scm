(load "mk/mk.scm")
(load "mk/matche.scm")

(define pairo (lambda (p) (fresh (a d) (== (cons a d) p))))

(defmatche (appendo l s ls)
  [(() ,s ,s)]
  [((,a . ,d) ,s (,a . ,res)) (appendo d s res)])

(define (lookupo upper lower name tile-ls)
  (fresh ()
    (=/= upper lower)
    (matche tile-ls
      [((,u ,l ,n) . ,rest)
       (pairo u)
       (pairo l)
       (conde
         [(== n name) (== u upper) (== l lower)]
         [(=/= n name) (lookupo upper lower name rest)])])))

(define pcpo
  (lambda (str name-ls tile-ls)
    (pcp-auxo str str name-ls tile-ls)))

(defmatche (pcp-auxo upper-ls lower-ls name-ls tile-ls)
  [(,upper-ls ,lower-ls (,name) ,tile-ls)
   (lookupo upper-ls lower-ls name tile-ls)]
  [(,upper-ls ,lower-ls (,name . ,name-rest) ,tile-ls)
; This pattern overlaps with the singleton name list case
; Can explicitly check for a list of at length at least two,
; in order to fail faster
   (fresh (upper lower upper-rest lower-rest)
     (lookupo upper lower name tile-ls)
     (appendo upper upper-rest upper-ls)
     (appendo lower lower-rest lower-ls)
     (pcp-auxo upper-rest lower-rest name-rest tile-ls))])
