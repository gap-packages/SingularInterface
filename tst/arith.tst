gap> ############################################
gap> # Test arithmetic functionality
gap> #
gap> #  The following tests are performed for additive domains:
gap> #
gap> #    a + b;
gap> #    a - b;
gap> #    a * 10;
gap> #    10 * a;
gap> #    a * 32003;
gap> #    32003 * a;
gap> #    -a;
gap> #    a = b;
gap> #    a = a;
gap> #    a - b = a + (-b);
gap> #    -a = (-1) * b;
gap> #    0 * a;
gap> #    a - a;
gap> #    Zero(a);
gap> #
gap> #  The following tests are performed for multiplicative domains:
gap> #
gap> #    a * b;
gap> #    a * b = b * a;
gap> #    a * a = a^2;
gap> #    One(a);
gap> #    a^0;
gap> #    a^1;
gap> #    a^2;
gap> #
gap> ############################################
gap> # Polynomials over a finite field
gap> #
gap> s := SI_ring(32003,["x","y","z"]);
<singular ring, 3 indeterminates>
gap> a := SI_poly(s,"x2y+151xyz10+169y21");
169*y^21+151*x*y*z^10+x^2*y
gap> b := SI_poly(s,"xz14+6x2y4+z24");
z^24+x*z^14+6*x^2*y^4
gap> x := SI_poly(s,"x");;
gap> y := SI_poly(s,"y");;
gap> z := SI_poly(s,"z");;
gap> 
gap> a = x^2*y+151*x*y*z^10+169*y^21;
true
gap> b = x*z^14+6*x^2*y^4+z^24;
true
gap> 
gap> a + b;
z^24+169*y^21+x*z^14+151*x*y*z^10+6*x^2*y^4+x^2*y
gap> a - b;
-z^24+169*y^21-x*z^14+151*x*y*z^10-6*x^2*y^4+x^2*y
gap> a * 10;
1690*y^21+1510*x*y*z^10+10*x^2*y
gap> 10 * a;
1690*y^21+1510*x*y*z^10+10*x^2*y
gap> a * 32003;
0
gap> 32003 * a;
0
gap> -a;
-169*y^21-151*x*y*z^10-x^2*y
gap> a = b;
false
gap> a = a;
true
gap> a - b = a + (-b);
true
gap> -a = (-1) * b;
false
gap> 0 * a;
0
gap> a - a;
0
gap> 
gap> 
gap> a * b;
169*y^21*z^24+169*x*y^21*z^14+151*x*y*z^34+1014*x^2*y^25+152*x^2*y*z^24+906*x^\
3*y^5*z^10+x^3*y*z^14+6*x^4*y^5
gap> a * b = b * a;
true
gap> a * a = a^2;
true
gap> One(a);
1
gap> a^0;
1
gap> a^1;
169*y^21+151*x*y*z^10+x^2*y
gap> a^2;
-3442*y^42-12968*x*y^22*z^10+338*x^2*y^22-9202*x^2*y^2*z^20+302*x^3*y^2*z^10+x\
^4*y^2
gap> 
gap> ############################################
gap> # Polynomials in characteristic 0
gap> #
gap> s := SI_ring(0,["x","y","z"]);
<singular ring, 3 indeterminates>
gap> a := SI_poly(s,"x2y+151xyz10+169y21");
169*y^21+151*x*y*z^10+x^2*y
gap> b := SI_poly(s,"xz14+6x2y4+z24");
z^24+x*z^14+6*x^2*y^4
gap> x := SI_poly(s,"x");;
gap> y := SI_poly(s,"y");;
gap> z := SI_poly(s,"z");;
gap> 
gap> a + b;
z^24+169*y^21+x*z^14+151*x*y*z^10+6*x^2*y^4+x^2*y
gap> a - b;
-z^24+169*y^21-x*z^14+151*x*y*z^10-6*x^2*y^4+x^2*y
gap> a * 10;
1690*y^21+1510*x*y*z^10+10*x^2*y
gap> 10 * a;
1690*y^21+1510*x*y*z^10+10*x^2*y
gap> a * 32003;
5408507*y^21+4832453*x*y*z^10+32003*x^2*y
gap> 32003 * a;
5408507*y^21+4832453*x*y*z^10+32003*x^2*y
gap> -a;
-169*y^21-151*x*y*z^10-x^2*y
gap> a = b;
false
gap> a = a;
true
gap> a - b = a + (-b);
true
gap> -a = (-1) * b;
false
gap> 0 * a;
0
gap> a - a;
0
gap> Zero(a);
0
gap> 
gap> a * b;
169*y^21*z^24+169*x*y^21*z^14+151*x*y*z^34+1014*x^2*y^25+152*x^2*y*z^24+906*x^\
3*y^5*z^10+x^3*y*z^14+6*x^4*y^5
gap> a * b = b * a;
true
gap> a * a = a^2;
true
gap> One(a);
1
gap> a^0;
1
gap> a^1;
169*y^21+151*x*y*z^10+x^2*y
gap> a^2;
28561*y^42+51038*x*y^22*z^10+338*x^2*y^22+22801*x^2*y^2*z^20+302*x^3*y^2*z^10+\
x^4*y^2
gap> 
gap> ############################################
gap> # int
gap> #
gap> 
gap> a := SI_bigint(2^28-1);
<singular bigint:268435455>
gap> b := SI_bigint(2);
<singular bigint:2>
gap> 
gap> 
gap> a + b;
<singular bigint:268435457>
gap> a - b;
<singular bigint:268435453>
gap> a * 10;
<singular bigint:2684354550>
gap> 10 * a;
<singular bigint:2684354550>
gap> a * 32003;
<singular bigint:8590739866365>
gap> 32003 * a;
<singular bigint:8590739866365>
gap> -a;
<singular bigint:-268435455>
gap> a = b;
false
gap> a = a;
true
gap> a - b = a + (-b);
true
gap> -a = (-1) * b;
false
gap> 0 * a;
<singular bigint:0>
gap> a - a;
<singular bigint:0>
gap> Zero(a);
<singular bigint:0>
gap> 
gap> a * b;
<singular bigint:536870910>
gap> a * b = b * a;
true
gap> a * a = a^2;
true
gap> One(a);
<singular bigint:1>
gap> a^0;
<singular bigint:1>
gap> a^1;
<singular bigint:268435455>
gap> a^2;
<singular bigint:72057593501057025>
gap> 
gap> ############################################
gap> # matrix
gap> #
gap> 
gap> ############################################
gap> # intvec
gap> #
gap> a := SI_intvec([1,2,3]);
<singular intvec:[ 1, 2, 3 ]>
gap> b := SI_intvec([-4,-2,4]);
<singular intvec:[ -4, -2, 4 ]>
gap> 
gap> a + b;
<singular intvec:[ -3, 0, 7 ]>
gap> a - b;
<singular intvec:[ 5, 4, -1 ]>
gap> a * 10;
<singular intvec:[ 10, 20, 30 ]>
gap> 10 * a;
<singular intvec:[ 10, 20, 30 ]>
gap> a * 32003;
<singular intvec:[ 32003, 64006, 96009 ]>
gap> 32003 * a;
<singular intvec:[ 32003, 64006, 96009 ]>
gap> -a;
<singular intvec:[ -1, -2, -3 ]>
gap> a = b;
false
gap> a = a;
true
gap> a - b = a + (-b);
true
gap> -a = (-1) * b;
false
gap> 0 * a;
<singular intvec:[ 0, 0, 0 ]>
gap> a - a;
<singular intvec:[ 0, 0, 0 ]>
gap> Zero(a);
<singular intvec:[ 0, 0, 0 ]>
