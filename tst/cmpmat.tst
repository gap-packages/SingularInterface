gap> r := SI_ring(0,["x"]);
<singular ring>
gap> a := SI_poly(r,"x2");
<singular poly (mutable):x2>
gap> b := SI_poly(r,"x3");
<singular poly (mutable):x3>
gap> m := SI_matrix(2,2,[a,b,a,b]);
<singular matrix (mutable):
x2,x3,
x2,x3 >
gap> n := SI_matrix(2,2,[a,b,a,b]);
<singular matrix (mutable):
x2,x3,
x2,x3 >
gap> m=n;
true
