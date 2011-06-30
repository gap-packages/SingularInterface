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

