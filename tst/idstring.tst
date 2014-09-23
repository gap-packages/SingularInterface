gap> r := SI_ring(0,["x","y"]);
<singular ring, 2 indeterminates>
gap> i := SI_ideal(r,"x2,y2,xy");
<singular ideal, 3 gens>
gap> i[1];
x^2
gap> i[2];
y^2
gap> i[3];
x*y
gap> j := SI_std(i);
<singular ideal, 3 gens>
gap> Display(j);
y^2,
x*y,
x^2
