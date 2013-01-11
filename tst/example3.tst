gap> if not IsBound(SIL_submat) then SI_LIB("matrix.lib"); fi;
gap> Singular("listvar(proc);");
0
gap> s := SI_ring(0,["a","b"]);
<singular ring>
gap> m := SI_matrix(s,2,2,"a,b,ab,1");
<singular matrix (mutable):
a, b,
ab,1 >
gap> v1 := SI_intvec([1]);
<singular intvec:[ 1 ]>
gap> v2 := SI_intvec([2]);
<singular intvec:[ 2 ]>
gap> x := SI_CallProc("submat",[m,v1,v2]);
<singular matrix (mutable):
b>
gap> y := SIL_submat(m,v1,v2);
<singular matrix (mutable):
b>
gap> x = y;
true
