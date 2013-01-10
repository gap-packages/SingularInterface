gap> r := SI_ring(0,["x","y"]);
<ring-with-one>
gap> i := SI_ideal(r,"x2,y2,xy");
<singular ideal>
gap> i[1];
<singular poly:x2>
gap> i[2];
<singular poly:y2>
gap> i[3];
<singular poly:xy>
gap> j := SI_std(i);
<singular ideal>
gap> Display(j);
y2,
xy,
x2
