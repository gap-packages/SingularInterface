gap> s := SI_ring(3,["a","b"],[["dp",2]]);
<singular ring>
gap> m := SI_matrix(2,2,s,"a,b,ab,2");
<singular object:
a, b,
ab,-1>
gap> Display(m);
a, b,
ab,-1
gap> x := SI_\[(m,1);
<singular object:
[a,ab]>
