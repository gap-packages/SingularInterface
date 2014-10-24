gap> r := SI_ring(0,["x","y","z"]);
<singular ring, 3 indeterminates>
gap> m := SI_matrix(r,2,3,"1,0,0,x2,0,z4");
<singular matrix, 2x3>
gap> M := SI_module(m);
<singular module, 3 vectors in free module of rank 2>
gap> SI_ncols(M);
3
gap> SI_nrows(M);
2
gap> Display(M);
1,  0,0, 
x^2,0,z^4
gap> Length(M);
3
