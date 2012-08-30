InstallMethod(SI_bigint,[IsSingularObj],SI_bigint_singular);
InstallMethod(SI_bigint,[IsInt],_SI_bigint);

InstallMethod(SI_intvec,[IsSingularObj],SI_intvec_singular);
InstallMethod(SI_intvec,[IsList],_SI_intvec);

InstallMethod(SI_intmat,[IsSingularObj],SI_intmat_singular);
InstallMethod(SI_intmat,[IsSingularObj,IsPosInt,IsPosInt],SI_intmat_singular);
InstallMethod(SI_intmat,[IsList],_SI_intmat);

InstallMethod(SI_ring,[IsSingularRing, IsSingularObj],SI_ring_singular);
InstallMethod(SI_ring,[IsInt,IsList,IsList],_SI_ring);
InstallMethod(SI_ring,[IsInt,IsList],
  function( p, l )
    return SI_ring(p,l,[["dp",Length(l)]]);
  end);

InstallMethod(SI_poly,[IsSingularRing, IsSingularObj],SI_poly_singular);
InstallMethod(SI_poly,[IsSingularRing, IsStringRep],_SI_poly_from_String);

InstallMethod(SI_matrix,[IsSingularObj],SI_matrix_singular);
InstallMethod(SI_matrix,[IsSingularObj,IsPosInt,IsPosInt],SI_matrix_singular);
InstallMethod(SI_matrix,[IsPosInt, IsPosInt, IsSingularRing, IsStringRep],
              _SI_matrix_from_String);
InstallMethod(SI_matrix,[IsPosInt, IsPosInt, IsList], _SI_matrix_from_els);

InstallMethod(SI_ideal,[IsSingularObj],SI_ideal_singular);
#InstallMethod(SI_ideal,[IsPosInt, IsPosInt, IsSingularRing, IsStringRep],
#              _SI_ideal_from_String);
InstallMethod(SI_ideal,[IsList], _SI_ideal_from_els);

InstallGlobalFunction( SI_CleanupRings,
  function()
    local i;
    for i in [1..Length(_SI_Rings)] do
        if IsBound(_SI_Rings[i]) and _SI_ElCounts[i] = 0 then
            Unbind(_SI_Rings[i]);
            Unbind(_SI_ElCounts[i]);
        fi;
    od;
  end );
  
InstallMethod( ViewString, "for a singular ring",
  [ IsSingularRing ],
  function( r )
    return "<singular ring>";
  end );

InstallMethod( ViewString, "for a singular poly",
  [ IsSingularPoly ],
  function( r )
    return STRINGIFY("<singular poly:",_SI_STRING_POLY(r),">");
  end );

InstallMethod( ViewString, "for a singular bigint",
  [ IsSingularBigInt ],
  function( r )
    return STRINGIFY("<singular bigint:",_SI_Intbigint(r),">");
  end );

InstallMethod( ViewString, "for a singular intvec",
  [ IsSingularIntVec ],
  function( i )
    return STRINGIFY("<singular intvec:",_SI_Plistintvec(i),">");
  end );

InstallMethod( ViewString, "for a singular intmat",
  [ IsSingularIntMat ],
  function( i )
    return STRINGIFY("<singular intmat:",_SI_Matintmat(i),">");
  end );

InstallMethod( ViewString, "for a singular ideal",
  [ IsSingularIdeal ],
  function( i )
    return "<singular ideal>";
  end );

InstallGlobalFunction( _SI_InitInterpreter,
  function( )
    local path;
    path := ShallowCopy(
            Filename(DirectoriesPackageLibrary("libsing","")[1],
                     "Singular-3-1-5/Singular/libsingular."));
    if ARCH_IS_MAC_OS_X() then
        Append(path,"dylib");
    else
        Append(path,"so");
    fi;
    _SI_INIT_INTERPRETER(path);
  end );
_SI_InitInterpreter();

InstallMethod( Singular, "for a string in stringrep",
  [ IsStringRep ], 
  function( st )
    local ret;
    SI_Errors := "";
    ret := _SI_EVALUATE(st);
    if Length(SI_Errors) > 0 then
        Print(SI_Errors);
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
        Print(SI_LastOutput());
    od;
    CloseStream(i);
  end );

InstallMethod(SI_Proxy, "for a singular object and a positive integer",
  [ IsSingularObj, IsPosInt ],
  function( o, i )
    local l;
    l := [o,i];
    Objectify(SingularProxiesType, l);
    return l;
  end );

InstallMethod(SI_Proxy, "for a singular object and two positive integers",
  [ IsSingularObj, IsPosInt, IsPosInt ],
  function( o, i, j)
    local l;
    l := [o,i,j];
    Objectify(SingularProxiesType, l);
    return l;
  end );

InstallMethod(SI_Proxy, "for a singular object and a string",
  [ IsSingularObj, IsStringRep ],
  function( o, s)
    local l;
    l := [o,s];
    Objectify(SingularProxiesType, l);
    return l;
  end );

InstallMethod(ViewString, "for a singular proxy object",
  [ IsSingularProxy ],
  function(p)
    local str;
    str := "<proxy for ";
    Append(str, ViewString(p![1]));
    Print("[",p![2]);
    Append(str, "[");
    Append(str, ViewString(p![2]));
    if IsBound(p![3]) then
        Append(str, ",");
        Append(str, ViewString(p![3]));
    fi;
    Append(str, "]>");
    return str;
  end );

# TODO: Quoting the GAP manual:
# "ViewObj should print the object to the standard output in a short and
# concise form, it is used in the main read-eval-print loop to display
# the resulting object of a computation"
InstallMethod(ViewString, "for a generic singular object",
  [ IsSingularObj ],
  function( s )
    return Concatenation("<singular object:\n",SI_ToGAP(SI_print(s)),">");
  end );


# TODO: Quoting the GAP manual:
# "Display should print the object to the standard output in a
# human-readable relatively complete and verbose form."
InstallMethod(DisplayString, "for a generic singular object",
  [ IsSingularObj ],
  function( s )
    return Concatenation(SI_ToGAP(SI_print(s)),"\n");
  end );

# TODO: Quoting the GAP manual:
# "PrintObj should print the object to the standard output in a complete
# form which is GAP-readable if at all possible, such that reading the
# output into GAP produces an object which is equal to the original one."
InstallMethod(String, "for a generic singular object",
  [ IsSingularObj ],
  function( s )
    return SI_ToGAP(SI_print(s));
  end );

# WORKAROUND for a bug in GAP 4.5.5: There is a bad PrintObj
# method for objects which hides the correct one. To workaround
# this, we re-install the correct method with slightly higher rank.
InstallMethod(PrintObj, "default method delegating to PrintString",
  [IsObject], 1, function(o) Print(PrintString(o)); end );

