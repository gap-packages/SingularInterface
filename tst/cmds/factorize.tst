gap> r:=SI_ring();
<singular ring, 3 indeterminates>
gap> p:=SI_poly(r,"9*(x-1)^2*(y+z)");
9*x^2*y+9*x^2*z-18*x*y-18*x*z+9*y+9*z
gap> fac:=SI_factorize(p);
<singular list:
[1]:
   _[1]=9
   _[2]=y+z
   _[3]=x-1
[2]:
   1,1,2>
gap> fac0:=SI_factorize(p,0);
<singular list:
[1]:
   _[1]=9
   _[2]=y+z
   _[3]=x-1
[2]:
   1,1,2>
gap> fac1:=SI_factorize(p,1);
<singular ideal, 2 gens>
gap> fac2:=SI_factorize(p,2);
<singular list:
[1]:
   _[1]=y+z
   _[2]=x-1
[2]:
   1,2>
gap> rQ:=SI_ring(0,"x");
<singular ring, 1 indeterminate>
gap> f:=SI_poly(rQ,"x2+1");
x^2+1
gap> SI_factorize(f);
<singular list:
[1]:
   _[1]=1
   _[2]=x^2+1
[2]:
   1,1>
