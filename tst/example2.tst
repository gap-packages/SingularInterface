gap> s := SI_ring(3,["a","b"],[["dp",2]]);
<singular ring>
gap> p := SI_matrix(s,1,1,"a+b+ab");
<singular object:
ab+a+b>
gap> SI_\[(p,1);
<singular object:
[ab+a+b]>
gap> SI_\[(p,2);
<singular object:
[0]>
gap> SI_\[(p,3);
<singular object:
[0]>
gap> SI_\[(p,4);
<singular object:
[0]>
gap> m := SI_matrix(s,2,2,"a,b,ab,2");
<singular object:
a, b,
ab,-1>
gap> SI_\[(m,1,1);
<singular poly:a>
gap> SI_\[(m,2,1);
<singular poly:ab>
gap> SI_\[(m,2,2);
<singular poly:-1>
gap> SI_\*(m,2);
<singular object:
-a, -b,
-ab,1  >
gap> SI_\*(m,0);
<singular object:
0,0,
0,0 >
gap> a := SI_poly(s,"a");
<singular poly:a>
gap> SI_\*(m,a);
<singular object:
a2, ab,
a2b,-a >
gap> Display(m);
a, b,
ab,-1
gap> SI_\-(m,m);
<singular object:
0,0,
0,0 >
gap> SI_\-(m);
<singular object:
-a, -b,
-ab,1  >
