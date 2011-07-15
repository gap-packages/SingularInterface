InstallGlobalFunction( CleanupSingularRings,
  function()
    local i;
    for i in [1..Length(SingularRings)] do
        if IsBound(SingularRings[i]) and SingularElCounts[i] = 0 then
            Unbind(SingularRings[i]);
            Unbind(SingularElCounts[i]);
        fi;
    od;
  end );
  
InstallGlobalFunction( InitSingularInterpreter,
  function( )
    local path;
    path := Filename(DirectoriesPackageLibrary("libsingular","")[1],
                     "Singular-3-1-3/Singular/libsingular.so");
    INIT_SINGULAR_INTERPRETER(path);
  end );
InitSingularInterpreter();

InstallMethod( Singular, "for a string in stringrep",
  [ IsStringRep ], EVALUATE_IN_SINGULAR );

InstallMethod( Singular, "without arguments",
  [ ],
  function()
    local i,s;
    i := InputTextUser();
    while true do
        Print("\rS>\c");
        s := ReadLine(i);
        if s = "\n" then break; fi;
        Singular(s);
    od;
    CloseStream(i);
  end );

