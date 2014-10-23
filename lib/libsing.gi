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

InstallMethod(SI_bigint,[IsSI_Object],_SI_bigint_singular);
InstallMethod(SI_bigint,[IsInt],_SI_bigint);

InstallMethod(SI_bigintmat,[IsSI_Object],_SI_bigintmat_singular);
#InstallMethod(SI_bigintmat,[IsSI_Object,IsPosInt,IsPosInt],_SI_bigintmat_singular);
InstallMethod(SI_bigintmat,[IsList],_SI_bigintmat);

InstallMethod(SI_number,[IsSI_ring, IsSI_Object],_SI_number_singular);
InstallMethod(SI_number,[IsSI_ring, IsInt],_SI_number);
InstallMethod(SI_number,[IsSI_ring, IsFFE],_SI_number);
InstallMethod(SI_number,[IsSI_ring, IsRat],_SI_number);

InstallMethod(SI_intvec,[IsSI_Object],_SI_intvec_singular);
InstallMethod(SI_intvec,[IsList],_SI_intvec);

InstallMethod(SI_intmat,[IsSI_Object],_SI_intmat_singular);
InstallMethod(SI_intmat,[IsSI_Object,IsPosInt,IsPosInt],_SI_intmat_singular);
InstallMethod(SI_intmat,[IsList],_SI_intmat);

InstallMethod(SI_poly,[IsSI_ring, IsSI_Object],_SI_poly_singular);
InstallMethod(SI_poly,[IsSI_ring, IsStringRep],_SI_poly_from_String);

InstallMethod(SI_matrix,["IsSI_Object"],_SI_matrix_singular);
InstallMethod(SI_matrix,["IsSI_Object","IsPosInt","IsPosInt"],
  _SI_matrix_singular);
InstallMethod(SI_matrix,["IsSI_ring","IsPosInt","IsPosInt","IsStringRep"],
              _SI_matrix_from_String);
InstallMethod(SI_matrix,["IsPosInt", "IsPosInt", "IsList"], 
              _SI_matrix_from_els);

InstallMethod(SI_ZeroMat,["IsSI_ring", "IsPosInt", "IsPosInt"],
function(r, rows, cols)
    return SI_matrix(r, rows, cols," ");
end );

InstallMethod(SI_IdentityMat,["IsSI_ring", "IsPosInt"],
function(r, rows)
    return SI_matrix(SI_freemodule(r, rows));
end );

# a Singular vector is a "polynomial" in which each monomial also carries
# its position
InstallMethod(SI_vector,[IsSI_ring, IsPosInt, IsStringRep], 
function(r, len, str)
    local mat;
    mat := SI_matrix(r, len, 1, str);
    # this returns the first column(!) of mat as vector
    return SI_\[(mat,1);
end);
InstallMethod(SI_vector,["IsSI_Object"],_SI_vector_singular);

InstallMethod(SI_ideal,[IsSI_Object],_SI_ideal_singular);
InstallMethod(SI_ideal,[IsSI_ring, IsStringRep], _SI_ideal_from_String);
InstallMethod(SI_ideal,[IsList], _SI_ideal_from_els);

InstallMethod( ViewString, "for a singular poly", [ IsSI_poly ],
function( poly )
    if SI_DEBUG_MODE then
        return STRINGIFY("<singular poly:",_SI_p_String(poly),">");
    else
        return _SI_p_String(poly);
    fi;
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


InstallOtherMethod(TransposedMat, [IsSI_intmat], SI_transpose);
InstallOtherMethod(TransposedMat, [IsSI_bigintmat], SI_transpose);
InstallOtherMethod(TransposedMat, [IsSI_matrix], SI_transpose);
InstallOtherMethod(TransposedMat, [IsSI_module], SI_transpose);

InstallOtherMethod(Determinant, [IsSI_intmat], SI_det);
InstallOtherMethod(Determinant, [IsSI_bigintmat], SI_det);
InstallOtherMethod(Determinant, [IsSI_matrix], SI_det);

InstallOtherMethod(DeterminantMat, [IsSI_intmat], SI_det);
InstallOtherMethod(DeterminantMat, [IsSI_bigintmat], SI_det);
InstallOtherMethod(DeterminantMat, [IsSI_matrix], SI_det);

