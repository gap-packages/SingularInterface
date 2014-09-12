gap> old_opts := _SI_Plistintvec(SI_option("get"));;
gap> SI_test(34);
true
gap> SI_test(-34);
true
gap> SI_test(34,34);
true
gap> SI_test(-34,-34);
true
gap> SI_test(34,34,34);
true
gap> SI_test(-34,-34,-34);
true
gap> SI_test(34,34,34,34);
true
gap> SI_test(-34,-34,-34,-34);
true
gap> SI_test(34,34,34,34,34);
true
gap> SI_test(-34,-34,-34,-34,-34);
true
gap> SI_option("set", SI_intvec(old_opts));
true
gap> SI_names();;
gap> s := SI_ring(3,["a","b"],[["dp",2]]);
<singular ring>
gap> SI_names(s);
<singular list:
empty list>
