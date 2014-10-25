gap> Display(SI_ring());
polynomial ring, over a field, global ordering
//   characteristic : 32003
//   number of vars : 3
//        block   1 : ordering dp
//                  : names    x y z
//        block   2 : ordering c
gap> Display(SI_ring(0,"x1..3,y4..6"));
polynomial ring, over a field, global ordering
//   characteristic : 0
//   number of vars : 6
//        block   1 : ordering dp
//                  : names    x1 x2 x3 y4 y5 y6
//        block   2 : ordering c
gap> Display(SI_ring(0,"x(1..3)"));
# WARNING: 'x(1)' is not a valid GAP identifier.
# You will not be able to use AssignGeneratorVariables on this ring.
polynomial ring, over a field, global ordering
//   characteristic : 0
//   number of vars : 3
//        block   1 : ordering dp
//                  : names    x(1) x(2) x(3)
//        block   2 : ordering c
gap> Display(SI_ring(0,["x","y","z"]));
polynomial ring, over a field, global ordering
//   characteristic : 0
//   number of vars : 3
//        block   1 : ordering dp
//                  : names    x y z
//        block   2 : ordering c
gap> Display(SI_ring(0,["x","y","z"],[["lp",2]]));
Error, Orderings do not cover exactly the variables
gap> Display(SI_ring(0,["x","y","z"],[["lp",3]]));
polynomial ring, over a field, global ordering
//   characteristic : 0
//   number of vars : 3
//        block   1 : ordering lp
//                  : names    x y z
//        block   2 : ordering c
gap> Display(SI_ring(0,["x","y","z"],[["lp",4]]));
Error, Orderings do not cover exactly the variables
gap> Display(SI_ring(0,"x1..5",[["lp",3],["dp",2]]));
polynomial ring, over a field, global ordering
//   characteristic : 0
//   number of vars : 5
//        block   1 : ordering lp
//                  : names    x1 x2 x3
//        block   2 : ordering dp
//                  : names    x4 x5
//        block   3 : ordering c
gap> Display(SI_ring(0,"x1..5",[["lp",3],["dp",3]]));
Error, Orderings do not cover exactly the variables
gap> Display(SI_ring(0,["x","y","z"],[["wp",[1,2,3]]]));
polynomial ring, over a field, global ordering
//   characteristic : 0
//   number of vars : 3
//        block   1 : ordering wp
//                  : names    x y z
//                  : weights  1 2 3
//        block   2 : ordering c
gap> Display(SI_ring(0,"x1..3",[["dp",1],["dp",1],["dp",1]]));
polynomial ring, over a field, global ordering
//   characteristic : 0
//   number of vars : 3
//        block   1 : ordering dp
//                  : names    x1
//        block   2 : ordering dp
//                  : names    x2
//        block   3 : ordering dp
//                  : names    x3
//        block   4 : ordering c
gap> Display(SI_ring(0,"x1..3",[["a",[1]],["dp",2],["dp",1]]));
polynomial ring, over a field, global ordering
//   characteristic : 0
//   number of vars : 3
//        block   1 : ordering a
//                  : names    x1
//                  : weights   1
//        block   2 : ordering dp
//                  : names    x1 x2
//        block   3 : ordering dp
//                  : names    x3
//        block   4 : ordering c
gap> Display(SI_ring(0,"x1..3",[["C",0],["dp",1],["dp",1],["dp",1]]));
polynomial ring, over a field, global ordering
//   characteristic : 0
//   number of vars : 3
//        block   1 : ordering C
//        block   2 : ordering dp
//                  : names    x1
//        block   3 : ordering dp
//                  : names    x2
//        block   4 : ordering dp
//                  : names    x3
gap> Display(SI_ring(0,"x1..3",[["dp",1],["C",0],["dp",1],["dp",1]]));
polynomial ring, over a field, global ordering
//   characteristic : 0
//   number of vars : 3
//        block   1 : ordering dp
//                  : names    x1
//        block   2 : ordering C
//        block   3 : ordering dp
//                  : names    x2
//        block   4 : ordering dp
//                  : names    x3
gap> Display(SI_ring(0,"x1..3",[["dp",1],["C",0],["dp",1],["dp",1],["c",0]]));
Error, At most one ordering of type 'c' or 'C' may be used
gap> # The following used to crash, see issue #11.
gap> Display(SI_ring(0,["x","y","z"],[["wp",3]]));
Error, Second entry of ordering of type 'wp' must be a plain list of integers
