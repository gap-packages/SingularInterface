gap> r := SI_ring(0,["x"]);
<singular ring>
gap> a := SI_poly(r,"x2");
x^2
gap> b := SI_poly(r,"x3");
x^3
gap> m := SI_matrix(2,2,[a,b,a,b]);
<singular matrix:
x^2,x^3,
x^2,x^3 >
gap> n := SI_matrix(2,2,[a,b,a,b]);
<singular matrix:
x^2,x^3,
x^2,x^3 >
gap> m=n;
true
