gap> m := SI_intmat([[1,2,3],[4,5,6]]);
<singular intmat:[ [ 1, 2, 3 ], [ 4, 5, 6 ] ]>
gap> x := SI_Proxy(m,1,2);
<proxy for <singular intmat:[ [ 1, 2, 3 ], [ 4, 5, 6 ] ]>[1,2]>
gap> v := SI_intvec([1,2,3]);
<singular intvec:[ 1, 2, 3 ]>
gap> p := SI_Proxy(v,2);
<proxy for <singular intvec:[ 1, 2, 3 ]>[2]>
gap> b := SI_bigint(p);
<singular bigint:2>
gap> p := SI_Proxy(v,3);
<proxy for <singular intvec:[ 1, 2, 3 ]>[3]>
gap> b := SI_bigint(p);
<singular bigint:3>
