gap> SI_test(1);
true
gap> SI_test(-1);
true
gap> SI_test(1,1);
true
gap> SI_test(-1,-1);
true
gap> SI_test(1,1,1);
true
gap> SI_test(-1,-1,-1);
true
gap> SI_test(1,1,1,1);
true
gap> SI_test(-1,-1,-1,-1);
true
gap> SI_test(1,1,1,1,1);
true
gap> SI_test(-1,-1,-1,-1,-1);
true
gap> SI_names();;
gap> s := SI_ring(3,["a","b"],[["dp",2]]);
<singular ring>
gap> SI_names(s);
<singular list (mutable):
empty list>
