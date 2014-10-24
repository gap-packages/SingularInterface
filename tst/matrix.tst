gap> r := SI_ring(0,["x","y","z"]);
<singular ring, 3 indeterminates>
gap> x := SI_poly(r,"x");; y := SI_poly(r,"y");; z := SI_poly(r,"z");;
gap> m := SI_matrix(2,2,[1,x,y,z] * x^0);
<singular matrix, 2x2>
gap> Display(m);
1,x,
y,z 
gap> SI_ncols(m);
2
gap> SI_nrows(m);
2
gap> n := SI_matrix(2,3,[1,2,3,x^2,y^3,z^4] * x^0);
<singular matrix, 2x3>
gap> Display(n);
1,  2,  3, 
x^2,y^3,z^4
gap> SI_ncols(n);
3
gap> SI_nrows(n);
2
gap> Display(m*n);
x^3+1,  x*y^3+2,  x*z^4+3,
x^2*z+y,y^3*z+2*y,z^5+3*y 
gap> n*m;
fail
gap> Length(m);
2
gap> Length(n);
3
gap> Display(m[1]);
[1,y]
gap> Display(n[1]);
[1,x^2]
