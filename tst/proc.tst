gap> SI_Undef:=function(x)
>   Singular(Concatenation("if(defined(",x,")){kill ",x,";};"));
> end;;

# Define a simple Singular interpreter proc and call it
gap> SI_Undef("p0");Singular("proc p0(){return(42);}");
0
gap> SI_CallProc("p0", []);
42

gap> SI_Undef("p1");Singular("proc p1(){return(1,2);}");
0
gap> SI_CallProc("p1", []);
[ 1, 2 ]
gap> SI_Undef("p2");Singular("proc p2(a,b){return(a,b);}");
0
gap> SI_CallProc("p2", [1,2]);
[ 1, 2 ]
gap> SI_CallProc("p2", [-11,"abc"]);
[ -11, <singular string (mutable):
    abc> ]
gap> r := SI_ring(0,[ "x" ]);
<singular ring>
gap> SI_Undef("p3");Singular("proc p3(a){return(a);}");
0
gap> SI_CallProc("p3", [23]);
23
gap> r2 := SI_CallProc("p3", [r]);
<singular ring>
gap> r = r2;
true


gap> s := SI_ring(37,[ "y" ]);
<singular ring>
gap> SI_CallProc("p2", [r,s]) = [r,s];
true


gap> Singular("if(defined(myRingMaker)){kill myRingMaker;};proc myRingMaker(){ring r=0,a,dp;return(r);}");
0
gap> t := SI_CallProc("myRingMaker", []);
<singular ring>
