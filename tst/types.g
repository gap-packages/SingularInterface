LoadPackage("libsingular");
a := SI_bigint(12);
b := SI_bigint(a);
m := SI_Makeintmat([[1,2,3],[4,5,6]]);
x := SI_proxy(m,1,2);
c := SI_bigint(x);
  --> segfaults
