# Define a simple Singular interpreter proc and call it
gap> SingularUnbind("p0");Singular("proc p0(){return(42);}");
true
gap> SI_CallProc("p0", []);
42
gap> SingularUnbind("p1");Singular("proc p1(){return(1,2);}");
true
gap> SI_CallProc("p1", []);
[ 1, 2 ]
gap> SingularUnbind("p2");Singular("proc p2(a,b){return(a,b);}");
true
gap> SI_CallProc("p2", [1,2]);
[ 1, 2 ]
gap> SI_CallProc("p2", [-11,"abc"]);
[ -11, <singular string:
    abc> ]
gap> r := SI_ring(0,[ "x" ]);
<singular ring, 1 indeterminate>
gap> SingularUnbind("p3");Singular("proc p3(a){return(a);}");
true
gap> SI_CallProc("p3", [23]);
23
gap> r2 := SI_CallProc("p3", [r]);
<singular ring, 1 indeterminate>
gap> r = r2;
true
gap> s := SI_ring(37,[ "y" ]);
<singular ring, 1 indeterminate>
gap> SI_CallProc("p2", [r,s]) = [r,s];
true
gap> SI_SetCurrRing(r);
gap> SingularUnbind("p4");Singular("proc p4(){return(var(1));}");
true
gap> SI_CallProc("p4", []);
x
gap> SI_SetCurrRing(r);
gap> SingularUnbind("p5");Singular("proc p5(){return(x);}");
true
gap> SI_CallProc("p5", []);
x
gap> SingularUnbind("p6");Singular("proc p6(){ring r_p6=0,(x,y,z),dp; export r_p6;  return(1);}");
true
gap> SI_CallProc("p6", []);
1
gap> SingularUnbind("p7");Singular("proc p7(){ring r_p7=0,(x,y,z),dp; export r_p7;  return(x);}");
true
gap> SI_CallProc("p7", []);
fail

# proc p1(){ring r=0,(x,y,z),dp; export r;  return(1);}
gap> Singular("if(defined(myRingMaker)){kill myRingMaker;};proc myRingMaker(){ring r=0,a,dp;return(r);}");
true
gap> t := SI_CallProc("myRingMaker", []);
<singular ring, 1 indeterminate>
