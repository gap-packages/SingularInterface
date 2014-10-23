gap> r := SI_ring(37, ["x","y"]);
<singular ring, 2 indeterminates>
gap> SI_number(r, 1);
<singular number: 1>
gap> SI_number(r, 37);
<singular number: 0>
gap> SI_number(r, 37^100+2);
<singular number: 2>
gap> SI_number(r, 5*Z(37)^0);
<singular number: 5>
gap> SI_number(r, Z(47));
Error, Argument is in wrong field.

gap> SI_number(r, 37^100+2);
<singular number: 2>
