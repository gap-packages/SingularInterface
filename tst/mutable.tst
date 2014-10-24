gap> r := SI_ring(0,["x","y","z"]);
<singular ring, 3 indeterminates>
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
gap> a := SIC_IdentityMat(r,3);
<singular matrix, 3x3>
gap> IsMutable(a);
true
gap> ai := MakeImmutable(SIC_IdentityMat(r,3));
<singular matrix, 3x3>
gap> IsMutable(ai);
false
gap> b := SIC_IdentityMat(r,3);
<singular matrix, 3x3>
gap> bi := MakeImmutable(SIC_IdentityMat(r,3));
<singular matrix, 3x3>
gap> a+b;
<singular matrix, 3x3>
gap> a+bi;
<singular matrix, 3x3>
gap> ai+b;
<singular matrix, 3x3>
gap> ai+bi;
<singular matrix, 3x3>
gap> a-b;
<singular matrix, 3x3>
gap> a-bi;
<singular matrix, 3x3>
gap> ai-b;
<singular matrix, 3x3>
gap> ai-bi;
<singular matrix, 3x3>
