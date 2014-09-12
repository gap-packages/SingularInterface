gap> r := SI_ring(0,["x","y","z"],[["lp",3]]);
<singular ring>
gap> i := SI_ideal([SI_poly(r,"y3+x2"),SI_poly(r,"x2y+x2"),SI_poly(r,"x3-x2"),
> SI_poly(r,"z4-x2-y")]);
<singular ideal (mutable), 4 gens>
gap> ii := SI_ideal(r,"y3+x2,x2y+x2,x3-x2,z4-x2-y");
<singular ideal (mutable), 4 gens>
gap> i[1];
x^2+y^3
gap> i[2];
x^2*y+x^2
gap> i[3];
x^3-x^2
gap> i[4];
-x^2-y+z^4
gap> ii[1];
x^2+y^3
gap> ii[2];
x^2*y+x^2
gap> ii[3];
x^3-x^2
gap> ii[4];
-x^2-y+z^4
gap> i[1]=ii[1] and i[2]=ii[2] and i[3]=ii[3] and i[4]=ii[4];
true
gap> SIL_stdfglm(i);
<singular ideal (mutable), 5 gens>
gap> j := last;
<singular ideal (mutable), 5 gens>
gap> Display(j);
z^12,
y*z^4-z^8,
y^2+y-z^8-z^4,
x*y-x*z^4-y+z^4,
x^2+y-z^4
