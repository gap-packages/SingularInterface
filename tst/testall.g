LoadPackage("SingularInterface");
d1 := DirectoriesPackageLibrary("SingularInterface", "tst");
d2 := DirectoriesPackageLibrary("SingularInterface", "tst/cmds");
d3 := DirectoriesPackageLibrary("SingularInterface", "tst/types");

HasSuffix := function(list, suffix)
    local len;
    len := Length(list);
    if Length(list) < Length(suffix) then return false; fi;
    return list{[len-Length(suffix)+1..len]} = suffix;
end;

for d in [d1, d2, d3] do
    # Load all tests in that directory
    tests := DirectoryContents(d[1]);
    tests := Filtered(tests, name -> HasSuffix(name, ".tst"));
    Sort(tests);

    # Convert tests to filenames
    tests := List(tests, test -> Filename(d,test));

    # Run the tests
    for test in tests do
        Print("Running test '",test,"'\n");
        Test(test);
        #Test(test, rec(rewriteToFile:=test));
    od;
od;
