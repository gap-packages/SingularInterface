gap> r := SI_ring(0,["x","y","z"],[["lp",3]]);
<singular ring>
gap> i := SI_ideal([SI_poly(r,"y3+x2"),SI_poly(r,"x2y+x2"),SI_poly(r,"x3-x2"),
> SI_poly(r,"z4-x2-y")]);
<singular ideal (mutable), 4 gens of deg <= 4>
gap> ii := SI_ideal(r,"y3+x2,x2y+x2,x3-x2,z4-x2-y");
<singular ideal (mutable), 4 gens of deg <= 4>
gap> i[1];
<singular poly (mutable):x2+y3>
gap> i[2];
<singular poly (mutable):x2y+x2>
gap> i[3];
<singular poly (mutable):x3-x2>
gap> i[4];
<singular poly (mutable):-x2-y+z4>
gap> ii[1];
<singular poly (mutable):x2+y3>
gap> ii[2];
<singular poly (mutable):x2y+x2>
gap> ii[3];
<singular poly (mutable):x3-x2>
gap> ii[4];
<singular poly (mutable):-x2-y+z4>
gap> i[1]=ii[1] and i[2]=ii[2] and i[3]=ii[3] and i[4]=ii[4];
true
gap> SIL_stdfglm(i);
<singular ideal (mutable), 5 gens of deg <= 12>
gap> j := last;
<singular ideal (mutable), 5 gens of deg <= 12>
gap> Display(j);
z12,
yz4-z8,
y2+y-z8-z4,
xy-xz4-y+z4,
x2+y-z4
