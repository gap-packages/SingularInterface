gap> r := SI_ring(0,["x","y","z"],[["lp",3]]);
<singular ring>
gap> i := SI_ideal([SI_poly(r,"y3+x2"),SI_poly(r,"x2y+x2"),SI_poly(r,"x3-x2"),
> SI_poly(r,"z4-x2-y")]);
<singular ideal>
gap> i[1];
<singular poly:x2+y3>
gap> i[2];
<singular poly:x2y+x2>
gap> i[3];
<singular poly:x3-x2>
gap> i[4];
<singular poly:-x2-y+z4>
gap> SIL_stdfglm(i);
<singular ideal>
gap> j := last;
<singular ideal>
gap> Display(j);
z12,
yz4-z8,
y2+y-z8-z4,
xy-xz4-y+z4,
x2+y-z4
