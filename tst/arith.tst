gap> ############################################
gap> # Test arithmetic functionality
gap> #
gap> #  The following tests are perform for additive domains:
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
gap> #  The following tests are perform for multiplicative domains:
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
<singular ring>
gap> a := SI_poly(s,"x2y+151xyz10+169y21");
<singular poly (mutable):169y21+151xyz10+x2y>
gap> b := SI_poly(s,"xz14+6x2y4+z24");
<singular poly (mutable):z24+xz14+6x2y4>
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
<singular poly (mutable):z24+169y21+xz14+151xyz10+6x2y4+x2y>
gap> a - b;
<singular poly (mutable):-z24+169y21-xz14+151xyz10-6x2y4+x2y>
gap> a * 10;
<singular poly (mutable):1690y21+1510xyz10+10x2y>
gap> 10 * a;
<singular poly (mutable):1690y21+1510xyz10+10x2y>
gap> a * 32003;
<singular poly (mutable):0>
gap> 32003 * a;
<singular poly (mutable):0>
gap> -a;
<singular poly (mutable):-169y21-151xyz10-x2y>
gap> a = b;
false
gap> a = a;
true
gap> a - b = a + (-b);
true
gap> -a = (-1) * b;
false
gap> 0 * a;
<singular poly (mutable):0>
gap> a - a;
<singular poly (mutable):0>
gap> 
gap> 
gap> a * b;
<singular poly (mutable):169y21z24+169xy21z14+151xyz34+1014x2y25+152x2yz24+906\
x3y5z10+x3yz14+6x4y5>
gap> a * b = b * a;
true
gap> a * a = a^2;
true
gap> One(a);
<singular poly:1>
gap> a^0;
<singular poly (mutable):1>
gap> a^1;
<singular poly (mutable):169y21+151xyz10+x2y>
gap> a^2;
<singular poly (mutable):-3442y42-12968xy22z10+338x2y22-9202x2y2z20+302x3y2z10\
+x4y2>
gap> 
gap> ############################################
gap> # Polynomials in characteristic 0
gap> #
gap> s := SI_ring(0,["x","y","z"]);
<singular ring>
gap> a := SI_poly(s,"x2y+151xyz10+169y21");
<singular poly (mutable):169y21+151xyz10+x2y>
gap> b := SI_poly(s,"xz14+6x2y4+z24");
<singular poly (mutable):z24+xz14+6x2y4>
gap> x := SI_poly(s,"x");;
gap> y := SI_poly(s,"y");;
gap> z := SI_poly(s,"z");;
gap> 
gap> a + b;
<singular poly (mutable):z24+169y21+xz14+151xyz10+6x2y4+x2y>
gap> a - b;
<singular poly (mutable):-z24+169y21-xz14+151xyz10-6x2y4+x2y>
gap> a * 10;
<singular poly (mutable):1690y21+1510xyz10+10x2y>
gap> 10 * a;
<singular poly (mutable):1690y21+1510xyz10+10x2y>
gap> a * 32003;
<singular poly (mutable):5408507y21+4832453xyz10+32003x2y>
gap> 32003 * a;
<singular poly (mutable):5408507y21+4832453xyz10+32003x2y>
gap> -a;
<singular poly (mutable):-169y21-151xyz10-x2y>
gap> a = b;
false
gap> a = a;
true
gap> a - b = a + (-b);
true
gap> -a = (-1) * b;
false
gap> 0 * a;
<singular poly (mutable):0>
gap> a - a;
<singular poly (mutable):0>
gap> Zero(a);
<singular poly:0>
gap> 
gap> a * b;
<singular poly (mutable):169y21z24+169xy21z14+151xyz34+1014x2y25+152x2yz24+906\
x3y5z10+x3yz14+6x4y5>
gap> a * b = b * a;
true
gap> a * a = a^2;
true
gap> One(a);
<singular poly:1>
gap> a^0;
<singular poly (mutable):1>
gap> a^1;
<singular poly (mutable):169y21+151xyz10+x2y>
gap> a^2;
<singular poly (mutable):28561y42+51038xy22z10+338x2y22+22801x2y2z20+302x3y2z1\
0+x4y2>
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
<singular intvec (mutable):[ -3, 0, 7 ]>
gap> a - b;
<singular intvec (mutable):[ 5, 4, -1 ]>
gap> a * 10;
<singular intvec (mutable):[ 10, 20, 30 ]>
gap> 10 * a;
<singular intvec (mutable):[ 10, 20, 30 ]>
gap> a * 32003;
<singular intvec (mutable):[ 32003, 64006, 96009 ]>
gap> 32003 * a;
<singular intvec (mutable):[ 32003, 64006, 96009 ]>
gap> -a;
<singular intvec (mutable):[ -1, -2, -3 ]>
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
<singular intvec (mutable):[ 0, 0, 0 ]>
gap> Zero(a);
<singular intvec (mutable):[ 0, 0, 0 ]>
