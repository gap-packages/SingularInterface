SI_LIB("matrix.lib");
Singular("listvar(proc);");
Print(SI_LastOutput());
s := SI_ring(0,["a","b"]);
m := SI_matrix(2,2,s,"a,b,ab,1");
v1 := SI_intvec([1]);
v2 := SI_intvec([2]);
a := SI_CallProc("submat",[m,v1,v2]);
