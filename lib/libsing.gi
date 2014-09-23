#
# SingularInterface: A GAP interface to Singular
#
# Copyright (C) 2011-2014  Mohamed Barakat, Max Horn, Frank Lübeck,
#                          Oleksandr Motsak, Max Neunhöffer, Hans Schönemann
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
#

InstallMethod(SI_bigint,[IsSingularObj],_SI_bigint_singular);
InstallMethod(SI_bigint,[IsInt],_SI_bigint);

InstallMethod(SI_bigintmat,[IsSingularObj],_SI_bigintmat_singular);
#InstallMethod(SI_bigintmat,[IsSingularObj,IsPosInt,IsPosInt],_SI_bigintmat_singular);
InstallMethod(SI_bigintmat,[IsList],_SI_bigintmat);

InstallMethod(SI_number,[IsSingularRing, IsSingularObj],_SI_number_singular);
InstallMethod(SI_number,[IsSingularRing, IsInt],_SI_number);
InstallMethod(SI_number,[IsSingularRing, IsFFE],_SI_number);
InstallMethod(SI_number,[IsSingularRing, IsRat],_SI_number);

InstallMethod(SI_intvec,[IsSingularObj],_SI_intvec_singular);
InstallMethod(SI_intvec,[IsList],_SI_intvec);

InstallMethod(SI_intmat,[IsSingularObj],_SI_intmat_singular);
InstallMethod(SI_intmat,[IsSingularObj,IsPosInt,IsPosInt],_SI_intmat_singular);
InstallMethod(SI_intmat,[IsList],_SI_intmat);

InstallMethod(SI_poly,[IsSingularRing, IsSingularObj],_SI_poly_singular);
InstallMethod(SI_poly,[IsSingularRing, IsStringRep],_SI_poly_from_String);

InstallMethod(SI_matrix,["IsSingularObj"],_SI_matrix_singular);
InstallMethod(SI_matrix,["IsSingularObj","IsPosInt","IsPosInt"],
  _SI_matrix_singular);
InstallMethod(SI_matrix,["IsSingularRing","IsPosInt","IsPosInt","IsStringRep"],
              _SI_matrix_from_String);
InstallMethod(SI_matrix,["IsPosInt", "IsPosInt", "IsList"], 
              _SI_matrix_from_els);

InstallMethod(SI_ZeroMat,["IsSingularRing", "IsPosInt", "IsPosInt"],
function(r, rows, cols)
    return SI_matrix(r, rows, cols," ");
end );

InstallMethod(SI_IdentityMat,["IsSingularRing", "IsPosInt"],
function(r, rows)
    return SI_matrix(SI_freemodule(r, rows));
end );

# a Singular vector is a "polynomial" in which each monomial also carries
# its position
InstallMethod(SI_vector,[IsSingularRing, IsPosInt, IsStringRep], 
function(r, len, str)
    local mat;
    mat := SI_matrix(r, len, 1, str);
    # this returns the first column(!) of mat as vector
    return SI_\[(mat,1);
end);
InstallMethod(SI_vector,["IsSingularObj"],_SI_vector_singular);

InstallMethod(SI_ideal,[IsSingularObj],_SI_ideal_singular);
InstallMethod(SI_ideal,[IsSingularRing, IsStringRep], _SI_ideal_from_String);
InstallMethod(SI_ideal,[IsList], _SI_ideal_from_els);

InstallMethod( ViewString, "for a singular poly", [ IsSingularPoly ],
function( poly )
    if SI_DEBUG_MODE then
        return STRINGIFY("<singular poly:",_SI_p_String(poly),">");
    else
        return _SI_p_String(poly);
    fi;
end );

InstallMethod( ViewString, "for a singular bigint", [ IsSingularBigInt ],
function( bigint )
    return STRINGIFY("<singular bigint:",_SI_Intbigint(bigint),">");
end );

InstallMethod( String, "for a singular bigint", [ IsSingularBigInt ],
function( bigint )
    return STRINGIFY("SI_bigint(",_SI_Intbigint(bigint),")");
end );

InstallMethod( ViewString, "for a singular bigintmat", [ IsSingularBigIntMat ],
function( bigintmat )
    return STRINGIFY("<singular bigintmat:",_SI_Matbigintmat(bigintmat),">");
end );

InstallMethod( String, "for a singular bigintmat", [ IsSingularBigIntMat ],
function( bigintmat )
    return STRINGIFY("SI_bigintmat(",_SI_Matbigintmat(bigintmat),")");
end );

InstallMethod( ViewString, "for a singular intvec", [ IsSingularIntVec ],
function( intvec )
#    local suffix;
#    if SI_nrows(intvec) = 1 then suffix := "y"; else suffix := "ies"; fi;
#    return STRINGIFY("<singular intvec, ",SI_nrows(intvec)," entr",suffix,">");
    return STRINGIFY("<singular intvec:",_SI_Plistintvec(intvec),">");
end );

InstallMethod( String, "for a singular intvec", [ IsSingularIntVec ],
function( intvec )
    return STRINGIFY("SI_intvec(",_SI_Plistintvec(intvec),")");
end );

InstallMethod( ViewString, "for a singular vector", [ IsSingularVector ],
function( vec )
    local suffix;
    if SI_nrows(vec) = 1 then suffix := "y"; else suffix := "ies"; fi;
    return STRINGIFY("<singular vector, ",SI_nrows(vec)," entr",suffix,">");
end );

# InstallMethod( String, "for a singular vector", [ IsSingularVector ],
# function( vec )
#     return STRINGIFY("SI_vector(",TODO(vec),")");
# end );

InstallMethod( ViewString, "for a singular intmat", [ IsSingularIntMat ],
function( intmat )
    return STRINGIFY("<singular intmat:",_SI_Matintmat(intmat),">");
end );

InstallMethod( String, "for a singular intmat", [ IsSingularIntMat ],
function( intmat )
    return STRINGIFY("SI_intmat(",_SI_Matintmat(intmat),")");
end );

InstallMethod( ViewString, "for a singular matrix", [ IsSingularMatrix ],
function( mat )
    return STRINGIFY("<singular matrix, ",SI_nrows(mat),"x",SI_ncols(mat),">");
end );

# InstallMethod( String, "for a singular matrix", [ IsSingularMatrix ],
# function( mat )
#     return STRINGIFY("SI_matrix(",TODO(mat),")");
# end );

InstallMethod( ViewString, "for a singular ideal", [ IsSingularIdeal ],
function( ideal )
    return STRINGIFY("<singular ideal, ",SI_ncols(ideal)," gens>");
end );

InstallMethod( ViewString, "for a singular module", [ IsSingularModule ],
function( module )
    local suffix;
    if SI_ncols(module) = 1 then suffix := ""; else suffix := "s"; fi;
    return STRINGIFY("<singular module, ", SI_ncols(module),
                     " vector",suffix," in free module of rank ",SI_nrows(module),">");
end );





# TODO: Quoting the GAP manual:
# "ViewObj should print the object to the standard output in a short and
# concise form, it is used in the main read-eval-print loop to display
# the resulting object of a computation"
InstallMethod(ViewString, "for a generic singular object", [ IsSingularObj ],
function( sobj )
    return Concatenation("<singular ",_SI_TypeName(sobj),":\n",
                         SI_ToGAP(SI_print(sobj)),">");
end );

# TODO: Quoting the GAP manual:
# "Display should print the object to the standard output in a
# human-readable relatively complete and verbose form."
InstallMethod(DisplayString, "for a generic singular object", [ IsSingularObj ],
function( s )
    return Concatenation(SI_ToGAP(SI_print(s)),"\n");
end );

# TODO: Quoting the GAP manual:
# "PrintObj should print the object to the standard output in a complete
# form which is GAP-readable if at all possible, such that reading the
# output into GAP produces an object which is equal to the original one."
InstallMethod(String, "for a generic singular object", [ IsSingularObj ],
function( s )
    return SI_ToGAP(SI_print(s));
end );


# HACK: Since we mark some types (e.g. intvecs) as lists,
# GAP's Display() method for lists gets triggered.
InstallMethod(Display, "for a generic singular object", [ IsSingularObj and IsList ],
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


InstallOtherMethod(TransposedMat, [IsSingularIntMat], SI_transpose);
InstallOtherMethod(TransposedMat, [IsSingularBigIntMat], SI_transpose);
InstallOtherMethod(TransposedMat, [IsSingularMatrix], SI_transpose);
InstallOtherMethod(TransposedMat, [IsSingularModule], SI_transpose);

InstallOtherMethod(Determinant, [IsSingularIntMat], SI_det);
InstallOtherMethod(Determinant, [IsSingularBigIntMat], SI_det);
InstallOtherMethod(Determinant, [IsSingularMatrix], SI_det);

InstallOtherMethod(DeterminantMat, [IsSingularIntMat], SI_det);
InstallOtherMethod(DeterminantMat, [IsSingularBigIntMat], SI_det);
InstallOtherMethod(DeterminantMat, [IsSingularMatrix], SI_det);

