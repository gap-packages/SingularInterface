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

InstallMethod( ViewObj, "for a singular ideal",
  [ IsSingularIdeal ],
  function( i )
    Print("<singular ideal>");
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

InstallMethod(SI_proxy, "for a singular object and a positive integer",
  [ IsSingularObj, IsPosInt ],
  function( o, i )
    local l;
    l := [o,i];
    Objectify(SingularProxiesType, l);
    return l;
  end );

InstallMethod(SI_proxy, "for a singular object and two positive integers",
  [ IsSingularObj, IsPosInt, IsPosInt ],
  function( o, i, j)
    local l;
    l := [o,i,j];
    Objectify(SingularProxiesType, l);
    return l;
  end );

InstallMethod(ViewObj, "for a singular proxy object",
  [ IsSingularProxy ],
  function(p)
    Print("<proxy for ");
    ViewObj(p![1]);
    Print("[",p![2]);
    if IsBound(p![3]) then
        Print(",",p![3]);
    fi;
    Print("]>");
  end );

