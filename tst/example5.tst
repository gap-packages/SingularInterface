gap> LoadPackage("SingularInterface");
true
gap> SingularUnbind("ver");
gap> Singular("int ver=3160;");
true
gap> SingularValueOfVar("ver");
3160
gap> SingularValueOfVar("version");   # gives fail
fail
gap> Singular("print(ver);");
true
gap> SingularLastOutput();   # gives version number as string
"3160\n"
gap> SingularUnbind("a");
gap> Singular("string a=\"Max\";");
true
gap> SingularValueOfVar("a");
"Max"
gap> SingularUnbind("x");
gap> Singular("intvec x=1,1,2,3,5,8,13;");
true
gap> SingularValueOfVar("x");
[ 1, 1, 2, 3, 5, 8, 13 ]
gap> SingularUnbind("y");
gap> Singular("intmat y[3][5]=1,3,5,7,8,9,10,11,12,13;");
true
gap> SingularValueOfVar("y");
[ [ 1, 3, 5, 7, 8 ], [ 9, 10, 11, 12, 13 ], [ 0, 0, 0, 0, 0 ] ]
gap> s := SI_ring(3,["a","b"]);
<singular ring, 2 indeterminates>
gap> i := SI_Indeterminates(s);
[ a, b ]
gap> _SI_p_String(i[1]);
"a"
gap> _SI_p_String(i[2]);
"b"
gap> a := _SI_MONOMIAL(s,2,[2,3]);
-a^2*b^3
gap> aa := _SI_MULT_POLY_NUMBER(a,2);
a^2*b^3
gap> #aa := _SI_pp_Mult_nn(a,2);
gap> b := _SI_MONOMIAL(s,2,[4,5]);
-a^4*b^5
gap> c := _SI_p_Add_q(a,b);
-a^4*b^5-a^2*b^3
gap> d := _SI_pp_Mult_qq(a,b);
a^6*b^8
gap> e := _SI_p_Neg(a);
a^2*b^3
gap> _SI_p_String(a);
"-a^2*b^3"
gap> _SI_p_String(b);
"-a^4*b^5"
gap> _SI_p_String(c);
"-a^4*b^5-a^2*b^3"
gap> _SI_p_String(d);
"a^6*b^8"
gap> _SI_p_String(e);
"a^2*b^3"
gap> Unbind(a);
gap> Unbind(b);
gap> Unbind(c);
gap> Unbind(d);
gap> Unbind(e);
gap> Unbind(i);
gap> Unbind(s);
gap> Unbind(aa);
gap> 1;2;3;
1
2
3
gap> i:=SI_bigint(42);
<singular bigint:42>
gap> _SI_Intbigint(i) = 42;
true
gap> i:=SI_bigint(42^42);
<singular bigint:1501309375452965723567719721642544578140479705687387772358935\
33016064>
gap> _SI_Intbigint(i) = 42^42;
true
gap> iv:=SI_intvec([1..100]);
<singular intvec:[ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, \
18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37\
, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, \
57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76\
, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, \
96, 97, 98, 99, 100 ]>
gap> m:=List([1..10],i->List([1..10],j-> j*i));
[ [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ], [ 2, 4, 6, 8, 10, 12, 14, 16, 18, 20 ], 
  [ 3, 6, 9, 12, 15, 18, 21, 24, 27, 30 ], 
  [ 4, 8, 12, 16, 20, 24, 28, 32, 36, 40 ], 
  [ 5, 10, 15, 20, 25, 30, 35, 40, 45, 50 ], 
  [ 6, 12, 18, 24, 30, 36, 42, 48, 54, 60 ], 
  [ 7, 14, 21, 28, 35, 42, 49, 56, 63, 70 ], 
  [ 8, 16, 24, 32, 40, 48, 56, 64, 72, 80 ], 
  [ 9, 18, 27, 36, 45, 54, 63, 72, 81, 90 ], 
  [ 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 ] ]
gap> im:=SI_intmat(m);
<singular intmat:[ [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ], [ 2, 4, 6, 8, 10, 12, 14\
, 16, 18, 20 ], [ 3, 6, 9, 12, 15, 18, 21, 24, 27, 30 ], [ 4, 8, 12, 16, 20, 2\
4, 28, 32, 36, 40 ], [ 5, 10, 15, 20, 25, 30, 35, 40, 45, 50 ], [ 6, 12, 18, 2\
4, 30, 36, 42, 48, 54, 60 ], [ 7, 14, 21, 28, 35, 42, 49, 56, 63, 70 ], [ 8, 1\
6, 24, 32, 40, 48, 56, 64, 72, 80 ], [ 9, 18, 27, 36, 45, 54, 63, 72, 81, 90 ]\
, [ 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 ] ]>
gap> _SI_Plistintvec(iv) = [1..100];
true
gap> _SI_Matintmat(im) = m;
true
gap> s := SI_ring(17,["a","b"]);
<singular ring, 2 indeterminates>
gap> ind := SI_Indeterminates(s);
[ a, b ]
gap> id := SI_ideal(ind);
<singular ideal, 2 gens>
gap> x := _SI_MONOMIAL(s,12,[2,3]);
-5*a^2*b^3
gap> y := _SI_MONOMIAL(s,2,[4,3]);
2*a^4*b^3
gap> _SI_p_Add_q(x,y);
2*a^4*b^3-5*a^2*b^3
gap> id := SI_ideal([x,y]);
<singular ideal, 2 gens>
gap> p1 := SI_Proxy(id,1);
<proxy for <singular ideal, 2 gens>[1]>
gap> p2 := SI_Proxy(id,2);
<proxy for <singular ideal, 2 gens>[2]>
gap> _SI_COPY_POLY(p1);
-5*a^2*b^3
gap> _SI_COPY_POLY(p2);
2*a^4*b^3
gap> _SI_p_Add_q(x,p2);
2*a^4*b^3-5*a^2*b^3
gap> _SI_p_Add_q(p2,y);
4*a^4*b^3
gap> _SI_p_Add_q(p2,p1);
2*a^4*b^3-5*a^2*b^3
gap> 
gap> 
