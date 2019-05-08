# SingularInterface: A GAP interface to Singular
#
# Copyright of SingularInterface belongs to its developers.
# Please refer to the COPYRIGHT file for details.
#
# SPDX-License-Identifier: GPL-2.0-or-later

InstallMethod( ViewString, "for a singular poly", [ IsSI_poly ],
function( poly )
    return _SI_p_String(poly);
end );

InstallMethod( ViewString, "for a singular bigint", [ IsSI_bigint ],
function( bigint )
    return STRINGIFY("<singular bigint:",_SI_Intbigint(bigint),">");
end );

InstallMethod( String, "for a singular bigint", [ IsSI_bigint ],
function( bigint )
    return STRINGIFY("SI_bigint(",_SI_Intbigint(bigint),")");
end );

InstallMethod( ViewString, "for a singular bigintmat", [ IsSI_bigintmat ],
function( bigintmat )
    return STRINGIFY("<singular bigintmat:",_SI_Matbigintmat(bigintmat),">");
end );

InstallMethod( String, "for a singular bigintmat", [ IsSI_bigintmat ],
function( bigintmat )
    return STRINGIFY("SI_bigintmat(",_SI_Matbigintmat(bigintmat),")");
end );

InstallMethod( ViewString, "for a singular intvec", [ IsSI_intvec ],
function( intvec )
#    local suffix;
#    if SI_nrows(intvec) = 1 then suffix := "y"; else suffix := "ies"; fi;
#    return STRINGIFY("<singular intvec, ",SI_nrows(intvec)," entr",suffix,">");
    return STRINGIFY("<singular intvec:",_SI_Plistintvec(intvec),">");
end );

InstallMethod( String, "for a singular intvec", [ IsSI_intvec ],
function( intvec )
    return STRINGIFY("SI_intvec(",_SI_Plistintvec(intvec),")");
end );

InstallMethod( ViewString, "for a singular vector", [ IsSI_vector ],
function( vec )
    local suffix;
    if SI_nrows(vec) = 1 then suffix := "y"; else suffix := "ies"; fi;
    return STRINGIFY("<singular vector, ",SI_nrows(vec)," entr",suffix,">");
end );

# InstallMethod( String, "for a singular vector", [ IsSI_vector ],
# function( vec )
#     return STRINGIFY("SI_vector(",TODO(vec),")");
# end );

InstallMethod( ViewString, "for a singular intmat", [ IsSI_intmat ],
function( intmat )
    return STRINGIFY("<singular intmat:",_SI_Matintmat(intmat),">");
end );

InstallMethod( String, "for a singular intmat", [ IsSI_intmat ],
function( intmat )
    return STRINGIFY("SI_intmat(",_SI_Matintmat(intmat),")");
end );

InstallMethod( ViewString, "for a singular matrix", [ IsSI_matrix ],
function( mat )
    return STRINGIFY("<singular matrix, ",SI_nrows(mat),"x",SI_ncols(mat),">");
end );

# InstallMethod( String, "for a singular matrix", [ IsSI_matrix ],
# function( mat )
#     return STRINGIFY("SI_matrix(",TODO(mat),")");
# end );

InstallMethod( ViewString, "for a singular ideal", [ IsSI_ideal ],
function( ideal )
    return STRINGIFY("<singular ideal, ",SI_ncols(ideal)," gens>");
end );

InstallMethod( ViewString, "for a singular module", [ IsSI_module ],
function( module )
    local suffix;
    if SI_ncols(module) = 1 then suffix := ""; else suffix := "s"; fi;
    return STRINGIFY("<singular module, ", SI_ncols(module),
                     " vector",suffix," in free module of rank ",SI_nrows(module),">");
end );

InstallMethod(ViewString, "for a singular number", [ IsSI_number ],
function( sobj )
    return Concatenation("<singular number: ", SI_ToGAP(SI_print(sobj)),">");
end );


# TODO: Quoting the GAP manual:
# "ViewObj should print the object to the standard output in a short and
# concise form, it is used in the main read-eval-print loop to display
# the resulting object of a computation"
InstallMethod(ViewString, "for a generic singular object", [ IsSI_Object ],
function( sobj )
    return Concatenation("<singular ",_SI_TypeName(sobj),":\n",
                         SI_ToGAP(SI_print(sobj)),">");
end );

# TODO: Quoting the GAP manual:
# "Display should print the object to the standard output in a
# human-readable relatively complete and verbose form."
InstallMethod(DisplayString, "for a generic singular object", [ IsSI_Object ],
function( s )
    return Concatenation(SI_ToGAP(SI_print(s)),"\n");
end );

# TODO: Quoting the GAP manual:
# "PrintObj should print the object to the standard output in a complete
# form which is GAP-readable if at all possible, such that reading the
# output into GAP produces an object which is equal to the original one."
InstallMethod(String, "for a generic singular object", [ IsSI_Object ],
function( s )
    return SI_ToGAP(SI_print(s));
end );


# HACK: Since we mark some types (e.g. intvecs) as lists,
# GAP's Display() method for lists gets triggered. In particular,
# the resclasses package has a Display method for IsList which
# uses SUM_FLAGS... baaad. 
InstallMethod(Display, "for a singular object which is a list", [ IsSI_Object and IsList ],
    SUM_FLAGS,
function( obj )
    local st;
    st := DisplayString( obj );
    if IsIdenticalObj( st, DEFAULTDISPLAYSTRING )  then
        Print( obj, "\n" );
    else
        Print( st );
    fi;
end );


# WORKAROUND for a bug in GAP 4.5.5: There is a bad PrintObj
# method for objects which hides the correct one. To workaround
# this, we re-install the correct method with slightly higher rank.
InstallMethod(PrintObj, "default method delegating to PrintString",
  [IsObject], 1, function(o) Print(PrintString(o)); end );
