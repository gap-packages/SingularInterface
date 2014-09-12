gap> r := SI_ring(0,["x","y","z"]);
<singular ring>
gap> a := SI_poly(r,"xy");
x*y
gap> ai := MakeImmutable(SI_poly(r,"xy"));
x*y
gap> b := SI_poly(r,"xz");
x*z
gap> bi := MakeImmutable(SI_poly(r,"xz"));
x*z
gap> a+b;
x*y+x*z
gap> a+bi;
x*y+x*z
gap> ai+b;
x*y+x*z
gap> ai+bi;
x*y+x*z
gap> a-b;
x*y-x*z
gap> a-bi;
x*y-x*z
gap> ai-b;
x*y-x*z
gap> ai-bi;
x*y-x*z
gap> a := SI_IdentityMat(r,3);
<singular matrix:
1,0,0,
0,1,0,
0,0,1 >
gap> ai := MakeImmutable(SI_IdentityMat(r,3));
<singular matrix:
1,0,0,
0,1,0,
0,0,1 >
gap> b := SI_IdentityMat(r,3);
<singular matrix:
1,0,0,
0,1,0,
0,0,1 >
gap> bi := MakeImmutable(SI_IdentityMat(r,3));
<singular matrix:
1,0,0,
0,1,0,
0,0,1 >
gap> a+b;
<singular matrix:
2,0,0,
0,2,0,
0,0,2 >
gap> a+bi;
<singular matrix:
2,0,0,
0,2,0,
0,0,2 >
gap> ai+b;
<singular matrix:
2,0,0,
0,2,0,
0,0,2 >
gap> ai+bi;
<singular matrix:
2,0,0,
0,2,0,
0,0,2 >
gap> a-b;
<singular matrix:
0,0,0,
0,0,0,
0,0,0 >
gap> a-bi;
<singular matrix:
0,0,0,
0,0,0,
0,0,0 >
gap> ai-b;
<singular matrix:
0,0,0,
0,0,0,
0,0,0 >
gap> ai-bi;
<singular matrix:
0,0,0,
0,0,0,
0,0,0 >
