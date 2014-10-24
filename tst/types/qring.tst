# HACK: Until we have a "native" way to create a qring,
# ask the Singular interpreter
gap> SI_Undef("p0");Singular("proc p0(){ring r=0,(x,y,z),dp;ideal i=xy;qring q=std(i);return(q);}");
true
gap> q := SI_CallProc("p0", []);
<ring-with-one>
gap> IsSI_qring(q);
true
