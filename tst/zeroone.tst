gap> r := SI_ring(0,["x","y"]);
<singular ring, 2 indeterminates>
gap> a := SI_poly(r,"xy");
x*y
gap> IsMutable(r);
false
gap> IsMutable(a);
true
gap> ai := SI_poly(r,"xx");
x^2
gap> MakeImmutable(ai);
x^2
gap> IsMutable(ai);
false
gap> x := OneSM(r);
1
gap> IsMutable(x);
false
gap> x := OneSM(a);
1
gap> IsMutable(x);
true
gap> x := OneSM(ai);
1
gap> IsMutable(x);
false
gap> x := OneMutable(r);
1
gap> IsMutable(x);
true
gap> x := OneMutable(a);
1
gap> IsMutable(x);
true
gap> x := OneMutable(ai);
1
gap> IsMutable(x);
true
gap> x := OneImmutable(r);
1
gap> IsMutable(x);
false
gap> x := OneImmutable(a);
1
gap> IsMutable(x);
false
gap> OneImmutable(ai);
1
gap> IsMutable(x);
false
gap> x := ZeroSM(r);
0
gap> IsMutable(x);
false
gap> x := ZeroSM(a);
0
gap> IsMutable(x);
true
gap> x := ZeroSM(ai);
0
gap> IsMutable(x);
false
gap> x := ZeroMutable(r);
0
gap> IsMutable(x);
true
gap> x := ZeroMutable(a);
0
gap> IsMutable(x);
true
gap> x := ZeroMutable(ai);
0
gap> IsMutable(x);
true
gap> x := ZeroImmutable(r);
0
gap> IsMutable(x);
false
gap> x := ZeroImmutable(a);
0
gap> IsMutable(x);
false
gap> x := ZeroImmutable(ai);
0
gap> IsMutable(x);
false
gap> x := ZeroSM(r);
0
gap> y := ZeroSM(r);
0
gap> IsIdenticalObj(x,y);
true
gap> x := ZeroMutable(r);
0
gap> y := ZeroMutable(r);
0
gap> IsIdenticalObj(x,y);
false
