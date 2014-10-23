#! @System Rundbrief_Example

LoadPackage( "SingularInterface" );

#!  Here is a short example in &Singular; 4.0.1 demonstrating some
#!  basic procedures. &Singular; uses <C>=</C> for assignments and
#!  suppresses any output while &GAP; uses <C>:=</C> for assignments
#!  and triggers the so-called <C>View</C>-method, which gives a very brief
#!  description of the object (unless suppressed by a trailing <C>;;</C>).
#!  Basically, &Singular;'s print procedure is mapped to the so-called
#!  <C>Display</C>-method in &GAP;. <P/>
#!  
#!  Start by loading &SingularInterface; in &GAP;.
#! @Example
LoadPackage( "SingularInterface" );
#! true
#! @EndExample
#!  Define the ring $R := \mathbb{Q}[x_0, x_1, x_2, x_3]$ (with the monomial ordering
#!  <C>degrevlex</C>):
#! @Example
R := SI_ring( 0, "x0..3", [["dp",4]] );
#! <singular ring, 4 indeterminates>
## short=0 is the default, disable by: Singular( "short=1" );
SI_option( "redTail" );
#! true
#! @EndExample
#!  Define the polynomial $(x_1+x_3)^2$:
#! @Example
AssignGeneratorVariables( R );
#! #I Assigned the global variables [x0,x1,x2,x3]
p := (x1+x3)^2;
#! x1^2+2*x1*x3+x3^2
IsSI_poly( p );
#! true
#! @EndExample
#!  Define the ideal $I := \langle x_0^2-x_1 x_3,x_0 x_1-x_2 x_3 \rangle \lhd R$:
#! @Example
I := SI_ideal([x0^2-x1*x3, x0*x1-x2*x3]);
#! <singular ideal, 2 gens>
Display( I );
#! x0^2-x1*x3,
#! x0*x1-x2*x3
#! @EndExample
#!  The corresponding matrix $i$:
#! @Example
i := SI_matrix( I );
#! <singular matrix, 1x2>
Display( i );
#! x0^2-x1*x3,x0*x1-x2*x3
#! @EndExample
#!  The sum $I+I$ means the sum of ideals:
#! @Example
J:=I+I;
#! <singular ideal, 2 gens>
Display( J );
#! x0^2-x1*x3,
#! x0*x1-x2*x3
#! @EndExample
#!  Whereas $i+i$ means the sum of matrices:
#! @Example
Display( i + i );
#! 2*x0^2-2*x1*x3,2*x0*x1-2*x2*x3
#! @EndExample
#!  The squared ideal $I^2 \lhd R$:
#! @Example
I2 := I^2;
#! <singular ideal, 3 gens>
Display( I2 );
#! x0^4-2*x0^2*x1*x3+x1^2*x3^2,
#! x0^3*x1-x0*x1^2*x3-x0^2*x2*x3+x1*x2*x3^2,
#! x0^2*x1^2-2*x0*x1*x2*x3+x2^2*x3^2
#! @EndExample
#!  The Gröbner basis of the ideal $I$ is returned as a new different
#!  (but mathematically equal) ideal $G$:
#! @Example
G := SI_std( I );
#! <singular ideal, 3 gens>
Display( G );
#! x0*x1-x2*x3,
#! x0^2-x1*x3,
#! x1^2*x3-x0*x2*x3
#! @EndExample
#! The syzygies of the generators of $G$ are the columns of the &Singular;
#! datatype <C>module</C>:
#! @Example
S := SI_syz( G );
#! <singular module, 2 vectors in free module of rank 3>
Display( S );
#! x0, x1*x3,
#! -x1,-x2*x3,
#! -1, -x0
#! @EndExample
#!  To access the second column of <C>S</C> use:
#! @Example
S[2];
#! <singular vector, 3 entries>
Display( S[2] );
#! [x1*x3,-x2*x3,-x0]
#! @EndExample
#!  To access the first entry of the second column of <C>S</C> use:
#! @Example
S[2][1];
#! x1*x3
p - S[2][1];
#! x1^2+x1*x3+x3^2
#! @EndExample
#!  To create a matrix use:
#! @Example
m := SI_matrix( R, 3, 2, "x0,x3,x1,x2,x3,x0" );
#! <singular matrix, 3x2>
Display( m );
#! x0,x3,
#! x1,x2,
#! x3,x0
#! @EndExample
#!  To extract the (2,1)-entry from the matrix use:
#! @Example
m[[2,1]];
#! x1
#! @EndExample
#!  The sum of the <C>module</C> <C>S</C> and the <C>matrix</C>
#!  <C>m</C> is their augmentation:
#! @Example
S + m;
#! <singular module, 4 vectors in free module of rank 3>
Display( S + m );
#! x0, x1*x3, x0,x3,
#! -x1,-x2*x3,x1,x2,
#! -1, -x0, x3,x0
#! @EndExample
