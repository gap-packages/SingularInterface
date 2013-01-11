gap> r := SI_ring(0,["x","y"]);
<singular ring>
gap> a := SI_poly(r,"xy");
<singular poly (mutable):xy>
gap> ai := MakeImmutable(SI_poly(r,"xy"));
<singular poly:xy>
gap> b := SI_poly(r,"xz");
<singular poly (mutable):0>
gap> bi := MakeImmutable(SI_poly(r,"xz"));
<singular poly:0>
gap> a+b;
<singular poly (mutable):xy>
gap> a+bi;
<singular poly (mutable):xy>
gap> ai+b;
<singular poly (mutable):xy>
gap> ai+bi;
<singular poly:xy>
gap> a := SI_IdentityMat(r,3);
<singular matrix (mutable):
1,0,0,
0,1,0,
0,0,1 >
gap> ai := MakeImmutable(SI_IdentityMat(r,3));
<singular matrix:
1,0,0,
0,1,0,
0,0,1 >
gap> b := SI_IdentityMat(r,3);
<singular matrix (mutable):
1,0,0,
0,1,0,
0,0,1 >
gap> bi := MakeImmutable(SI_IdentityMat(r,3));
<singular matrix:
1,0,0,
0,1,0,
0,0,1 >
gap> a+b;
<singular matrix (mutable):
1,0,0,
0,1,0,
0,0,1 >
gap> a+bi;
<singular matrix (mutable):
1,0,0,
0,1,0,
0,0,1 >
gap> ai+b;
<singular matrix (mutable):
1,0,0,
0,1,0,
0,0,1 >
gap> ai+bi;
<singular matrix:
1,0,0,
0,1,0,
0,0,1 >
