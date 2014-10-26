gap> if not IsBound(SIL_submat) then SI_LIB("matrix.lib"); fi;
gap> s := SI_ring(0,["a","b"]);
<singular ring, 2 indeterminates>
gap> m := SI_matrix(s,2,2,"a,b,ab,1");
<singular matrix, 2x2>
gap> v1 := SI_intvec([1]);
<singular intvec:[ 1 ]>
gap> v2 := SI_intvec([2]);
<singular intvec:[ 2 ]>
gap> x := SI_CallProc("submat",[m,v1,v2]);
<singular matrix, 1x1>
gap> y := SIL_submat(m,v1,v2);
<singular matrix, 1x1>
gap> x = y;
true
