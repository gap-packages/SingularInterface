gap> Singular("1+1;");
true
gap> SingularLastOutput();
"2\n"
gap> SingularUnbind("ver");
gap> Singular("int ver=3160;");
true
gap> SingularValueOfVar("ver");
3160
gap> SingularValueOfVar("version");   # gives fail
fail
gap> Singular("print(ver);");
true
gap> SingularLastOutput();   # gives version number as string
"3160\n"
gap> SingularUnbind("someVar");
gap> Singular("string someVar=\"someValue\";");
true
gap> SingularValueOfVar("someVar");
"someValue"
gap> SingularUnbind("iv");
gap> Singular("intvec iv=1,1,2,3,5,8,13;");
true
gap> SingularValueOfVar("iv");
[ 1, 1, 2, 3, 5, 8, 13 ]
gap> SingularUnbind("im");
gap> Singular("intmat im[3][5]=1,3,5,7,8,9,10,11,12,13;");
true
gap> SingularValueOfVar("im");
[ [ 1, 3, 5, 7, 8 ], [ 9, 10, 11, 12, 13 ], [ 0, 0, 0, 0, 0 ] ]

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
