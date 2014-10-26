gap> r1 := SI_ring(32003, ["x","y","z"], [["dp", 3]]);
<singular ring, 3 indeterminates>
gap> i := SI_ideal(r1, "x,y,z");
<singular ideal, 3 gens>
gap> r2 := SI_ring(32003, ["a","b"], [["dp", 2]]);
<singular ring, 2 indeterminates>

# HACK: Until SI_map is implemented (see issue #44),
# create a map by invoking the Singular interpreter.
# TODO
gap> MySingularValueOfVar := function(name)
>     SingularUnbind("HACK");
>     Singular(Concatenation("proc HACK(){return(",name,");}"));
>     return SI_CallProc("HACK", []);
> end;;
gap> SingularUnbind("a");
gap> Singular("ring r1=32003,(x,y,z),dp;");
true
gap> Singular("ring r2=32003,(a,b),dp;");
true
gap> Singular("map f=r1,a,b,a+b;");
true
gap> Singular("export f;");
true
gap> f:=MySingularValueOfVar("f");
<singular map:
_[1]=a
_[2]=b
_[3]=a+b>
