gap> bim := SI_bigintmat([[1,2,3],[4,5,6]]);
<singular bigintmat:[ [ 1, 2, 3 ], [ 4, 5, 6 ] ]>
gap> Length(bim);
3
gap> SI_ToGAP(bim);
[ [ 1, 2, 3 ], [ 4, 5, 6 ] ]
gap> Display(bim);
1,2,3,
4,5,6
gap> a:=[[1,2^20], [3^50, - 5^17]];;
gap> A:=SI_bigintmat(a);
<singular bigintmat:[ [ 1, 1048576 ], [ 717897987691852588770249, -76293945312\
5 ] ]>
gap> b:=[[-37^15, 12^8-17^2], [-100000, 42]];;
gap> B:=SI_bigintmat(b);
<singular bigintmat:[ [ -333446267951815307088493, 429981407 ], [ -100000, 42 \
] ]>
gap> SI_ToGAP(A)=a;
true
gap> SI_ToGAP(B)=b;
true
gap> A + B;
<singular bigintmat:[ [ -333446267951815307088492, 431029983 ], [ 717897987691\
852588670249, -762939453083 ] ]>
gap> A + B = SI_bigintmat(a + b);
true
gap> A - B;
<singular bigintmat:[ [ 333446267951815307088494, -428932831 ], [ 717897987691\
852588870249, -762939453167 ] ]>
gap> A - B = SI_bigintmat(a - b);
true
gap> A * B;
<singular bigintmat:[ [ -333446267951920164688493, 474021599 ], [ -23938040476\
5966485652857489514321121594176144757, 308682786830211458523980607729093 ] ]>
gap> A * B = SI_bigintmat(a * b);
true
gap> 10 * A;
<singular bigintmat:[ [ 10, 10485760 ], [ 7178979876918525887702490, -76293945\
31250 ] ]>
gap> 10 * A = SI_bigintmat(10 * a);
true
gap> A * 10;
<singular bigintmat:[ [ 10, 10485760 ], [ 7178979876918525887702490, -76293945\
31250 ] ]>
gap> A * 10 = SI_bigintmat(a * 10);
true
gap> 32003 * A;
<singular bigintmat:[ [ 32003, 33557577728 ], [ 22974889300102358398414278747,\
 -24416351318359375 ] ]>
gap> 32003 * A = SI_bigintmat(32003 * a);
true
gap> -A;
<singular bigintmat:[ [ -1, -1048576 ], [ -717897987691852588770249, 762939453\
125 ] ]>
gap> -A = SI_bigintmat(-a);
true
gap> A = B;
false
gap> A = A;
true
gap> A - B = A + (-B);
true
gap> -A = (-1) * A;
true
gap> 0 * A;
<singular bigintmat:[ [ 0, 0 ], [ 0, 0 ] ]>
gap> A - A;
<singular bigintmat:[ [ 0, 0 ], [ 0, 0 ] ]>
gap> Zero(A);
<singular bigintmat:[ [ 0, 0 ], [ 0, 0 ] ]>
