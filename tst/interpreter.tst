gap> Singular("1+1;");
true
gap> SingularLastOutput();
"2\n"

# Some nonsense input
gap> Singular("foo");
`fooreturn` is not defined
error occurred in or before STDIN line 1: `fooreturn();`
leaving STDIN
false

#
# Test issue #48
#
gap> SingularUnbind("foo");
gap> SingularUnbind("HACK");
gap> Singular("int foo=42;export foo;proc HACK(){return(foo);};HACK();");
true
gap> Print(SingularLastOutput());
42
gap> SingularUnbind("foo");
gap> SingularUnbind("HACK");
gap> Singular("int foo=42;");
true
gap> Singular("export foo;");
true
gap> SingularValueOfVar("foo");
42
gap> Singular("proc HACK(){return(foo);}");
true
gap> SI_CallProc("HACK", []);
42
