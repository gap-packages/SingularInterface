gap> r := SI_ring(0,["x"]);
<singular ring, 1 indeterminate>
gap> a := SI_poly(r,"x2");
x^2
gap> b := SI_poly(r,"x3");
x^3
gap> m := SI_matrix(2,2,[a,b,a,b]);
<singular matrix, 2x2>
gap> n := SI_matrix(2,2,[a,b,a,b]);
<singular matrix, 2x2>
gap> m=n;
true
