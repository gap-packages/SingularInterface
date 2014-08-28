gap> m := SI_intmat([[1,2,3],[4,5,6]]);
<singular intmat (mutable):[ [ 1, 2, 3 ], [ 4, 5, 6 ] ]>
gap> x := SI_Proxy(m,1,2);
<proxy for <singular intmat (mutable):[ [ 1, 2, 3 ], [ 4, 5, 6 ] ]>[1,2]>
gap> c := SI_bigint(x);
<singular bigint:2>
