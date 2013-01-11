gap> r := SI_ring(0,["x","y"]);
<singular ring>
gap> i := SI_ideal(r,"x2,y2,xy");
<singular ideal (mutable), 3gens of deg <= 2>
gap> i[1];
<singular poly (mutable):x2>
gap> i[2];
<singular poly (mutable):y2>
gap> i[3];
<singular poly (mutable):xy>
gap> j := SI_std(i);
<singular ideal (mutable), 3gens of deg <= 2>
gap> Display(j);
y2,
xy,
x2
