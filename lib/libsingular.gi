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
  
InstallMethod( ViewObj, "for a singular ring",
  [ IsSingularRing ],
  function( r )
    Print("<singular ring>");
  end );

InstallMethod( ViewObj, "for a singular poly",
  [ IsSingularPoly ],
  function( r )
    Print("<singular poly:",SI_STRING_POLY(r),">");
  end );

InstallMethod( ViewObj, "for a singular bigint",
  [ IsSingularBigInt ],
  function( r )
    Print("<singular bigint:",SI_Intbigint(r),">");
  end );

InstallMethod( ViewObj, "for a singular intvec",
  [ IsSingularIntVec ],
  function( i )
    Print("<singular intvec:",SI_Plistintvec(i),">");
  end );

InstallMethod( ViewObj, "for a singular intmat",
  [ IsSingularIntMat ],
  function( i )
    Print("<singular intmat:",SI_Matintmat(i),">");
  end );

InstallGlobalFunction( InitSingularInterpreter,
  function( )
    local path;
    path := ShallowCopy(
            Filename(DirectoriesPackageLibrary("libsingular","")[1],
                     "Singular-3-1-3/Singular/libsingular."));
    if ARCH_IS_MAC_OS_X() then
        Append(path,"dylib");
    else
        Append(path,"so");
    fi;
    SI_INIT_INTERPRETER(path);
  end );
InitSingularInterpreter();

InstallMethod( Singular, "for a string in stringrep",
  [ IsStringRep ], 
  function( st )
    local ret;
    SingularErrors := "";
    ret := SI_EVALUATE(st);
    if Length(SingularErrors) > 0 then
        Print(SingularErrors);
    fi;
    return ret;
  end );

InstallMethod( Singular, "without arguments",
  [ ],
  function()
    local i,s;
    i := InputTextUser();
    while true do
        Print("\rS> \c");
        s := ReadLine(i);
        if s = "\n" then break; fi;
        Singular(s);
        Print(LastSingularOutput());
    od;
    CloseStream(i);
  end );

