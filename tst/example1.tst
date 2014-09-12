gap> s := SI_ring(3,["a","b"],[["dp",2]]);
<singular ring>
gap> m := SI_matrix(s,2,2,"a,b,ab,2");
<singular matrix (mutable):
a,  b,
a*b,-1>
gap> Display(m);
a,  b,
a*b,-1
gap> x := SI_\[(m,1);
<singular vector (mutable):
[a,a*b]>
