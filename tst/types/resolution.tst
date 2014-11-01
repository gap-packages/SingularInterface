gap> r := SI_ring(0,["x","y","z"]);
<singular ring, 3 indeterminates>
gap> m := SI_matrix(r,1,3,"x,y,z");
<singular matrix, 1x3>
gap> res := SIL_res(m,1);
<singular resolution:
[1]:
   _[1]=z*gen(1)
   _[2]=y*gen(1)
   _[3]=x*gen(1)
[2]:
   _[1]=-y*gen(1)+z*gen(2)
   _[2]=-x*gen(1)+z*gen(3)
   _[3]=-x*gen(2)+y*gen(3)>
gap> SI_size(res);
2
gap> res[1];
<singular module, 3 vectors in free module of rank 1>
gap> res[2];
<singular module, 3 vectors in free module of rank 3>
