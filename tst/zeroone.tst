gap> r := SI_ring(0,["x","y"]);
<singular ring>
gap> a := SI_poly(r,"xy");
<singular poly (mutable):xy>
gap> IsMutable(r);
false
gap> IsMutable(a);
true
gap> ai := SI_poly(r,"xx");
<singular poly (mutable):x2>
gap> MakeImmutable(ai);
<singular poly:x2>
gap> IsMutable(ai);
false
gap> x := OneSM(r);
<singular poly:1>
gap> IsMutable(x);
false
gap> x := OneSM(a);
<singular poly (mutable):1>
gap> IsMutable(x);
true
gap> x := OneSM(ai);
<singular poly:1>
gap> IsMutable(x);
false
gap> x := OneMutable(r);
<singular poly (mutable):1>
gap> IsMutable(x);
true
gap> x := OneMutable(a);
<singular poly (mutable):1>
gap> IsMutable(x);
true
gap> x := OneMutable(ai);
<singular poly (mutable):1>
gap> IsMutable(x);
true
gap> x := OneImmutable(r);
<singular poly:1>
gap> IsMutable(x);
false
gap> x := OneImmutable(a);
<singular poly:1>
gap> IsMutable(x);
false
gap> OneImmutable(ai);
<singular poly:1>
gap> IsMutable(x);
false
gap> x := ZeroSM(r);
<singular poly:0>
gap> IsMutable(x);
false
gap> x := ZeroSM(a);
<singular poly (mutable):0>
gap> IsMutable(x);
true
gap> x := ZeroSM(ai);
<singular poly:0>
gap> IsMutable(x);
false
gap> x := ZeroMutable(r);
<singular poly (mutable):0>
gap> IsMutable(x);
true
gap> x := ZeroMutable(a);
<singular poly (mutable):0>
gap> IsMutable(x);
true
gap> x := ZeroMutable(ai);
<singular poly (mutable):0>
gap> IsMutable(x);
true
gap> x := ZeroImmutable(r);
<singular poly:0>
gap> IsMutable(x);
false
gap> x := ZeroImmutable(a);
<singular poly:0>
gap> IsMutable(x);
false
gap> x := ZeroImmutable(ai);
<singular poly:0>
gap> IsMutable(x);
false
gap> x := ZeroSM(r);
<singular poly:0>
gap> y := ZeroSM(r);
<singular poly:0>
gap> IsIdenticalObj(x,y);
true
gap> x := ZeroMutable(r);
<singular poly (mutable):0>
gap> y := ZeroMutable(r);
<singular poly (mutable):0>
gap> IsIdenticalObj(x,y);
false
