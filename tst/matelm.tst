gap> SI_intmat([[1,2,3],[4,5,6]] * 7^15);
Error, m must contain small integers
gap> 
gap> m1 := SI_intmat([[1,2,3],[4,5,6]]);
<singular intmat (mutable):[ [ 1, 2, 3 ], [ 4, 5, 6 ] ]>
gap> _SI_MatElm(m1, 1, 3);
3
gap> _SI_MatElm(m1, 2, 3);
6
gap> _SI_MatElm(m1, 4, 3);
Error, intmat indices out of range
gap> _SI_SetMatElm(m1, 1, 3, 42);
gap> _SI_MatElm(m1, 1, 3);
42
gap> m1;
<singular intmat (mutable):[ [ 1, 2, 42 ], [ 4, 5, 6 ] ]>
gap> 
gap> 
gap> 
gap> m2 := SI_bigintmat([[1,2,3],[4,5,6]] * 7^15);
<singular intmat:[ [ 4747561509943, 9495123019886, 14242684529829 ], [ 1899024\
6039772, 23737807549715, 28485369059658 ] ]>
gap> _SI_MatElm(m2, 1, 3);
14242684529829
gap> _SI_MatElm(m2, 2, 3);
28485369059658
gap> _SI_MatElm(m2, 4, 3);
Error, bigintmat indices out of range
gap> _SI_SetMatElm(m2, 1, 3, 42^23);
gap> _SI_MatElm(m2, 1, 3);
21613926941579800829422581272845221888
gap> m2;
<singular intmat:[ [ 4747561509943, 9495123019886, 216139269415798008294225812\
72845221888 ], [ 18990246039772, 23737807549715, 28485369059658 ] ]>
gap> _SI_SetMatElm(m2, 1, 1, SI_bigint(5^16));
gap> m2;
<singular intmat:[ [ 152587890625, 9495123019886, 2161392694157980082942258127\
2845221888 ], [ 18990246039772, 23737807549715, 28485369059658 ] ]>
gap> 
gap> 
gap> 
gap> r := SI_ring(0,["x"]);; a := SI_poly(r,"x2");; b := SI_poly(r,"x3");;
gap> m3 := SI_matrix(2,3,[a,b,a+b,a-b,a*b,a-a]);
<singular matrix (mutable):
x^2,     x^3,x^3+x^2,
-x^3+x^2,x^5,0       >
gap> _SI_MatElm(m3, 1, 3);
x^3+x^2
gap> _SI_MatElm(m3, 2, 3);
0
gap> _SI_MatElm(m3, 4, 3);
Error, matrix indices out of range
gap> _SI_SetMatElm(m3, 1, 3, 23*a+42*b);
gap> _SI_MatElm(m3, 1, 3);
42*x^3+23*x^2
gap> m3;
<singular matrix (mutable):
x^2,     x^3,42*x^3+23*x^2,
-x^3+x^2,x^5,0             >
