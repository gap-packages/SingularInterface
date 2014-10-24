gap> im := SI_intmat([[1,2,3],[4,5,6]]);
<singular intmat:[ [ 1, 2, 3 ], [ 4, 5, 6 ] ]>
gap> Length(im);
3
gap> SI_ToGAP(im);
[ [ 1, 2, 3 ], [ 4, 5, 6 ] ]
gap> Display(im);
     1     2     3
     4     5     6
