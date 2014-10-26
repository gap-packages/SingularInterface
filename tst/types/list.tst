gap> r:=SI_ring();
<singular ring, 3 indeterminates>
gap> p:=SI_poly(r,"9*(x-1)^2*(y+z)");
9*x^2*y+9*x^2*z-18*x*y-18*x*z+9*y+9*z
gap> list:=SI_factorize(p);
<singular list:
[1]:
   _[1]=9
   _[2]=y+z
   _[3]=x-1
[2]:
   1,1,2>
