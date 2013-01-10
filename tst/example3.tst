gap> if not IsBound(SIL_submat) then SI_LIB("matrix.lib"); fi;
gap> Singular("listvar(proc);");
0
gap> s := SI_ring(0,["a","b"]);
<singular ring>
gap> m := SI_matrix(2,2,s,"a,b,ab,1");
<singular object:
a, b,
ab,1 >
gap> v1 := SI_intvec([1]);
<singular intvec:[ 1 ]>
gap> v2 := SI_intvec([2]);
<singular intvec:[ 2 ]>
gap> x := SI_CallProc("submat",[m,v1,v2]);
<singular object:
b>
gap> y := SIL_submat(m,v1,v2);
<singular object:
b>
gap> x = y;
true
