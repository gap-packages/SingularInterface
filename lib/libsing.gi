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
  function(r,rows,cols) return SI_matrix(r,rows,cols," "); end );
InstallMethod(SI_IdentityMat,["IsSingularRing", "IsPosInt"],
  function(r,rows) return SI_matrix(SI_freemodule(r,rows)); end );

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

InstallMethod( ViewString, "for a singular poly",
  [ IsSingularPoly ],
  function( poly )
    local mut;
    if SI_DEBUG_MODE then
        if IsMutable(poly) then mut := " (mutable)"; else mut := ""; fi;
        return STRINGIFY("<singular poly",mut,":",_SI_p_String(poly),">");
    else
        return _SI_p_String(poly);
    fi;
  end );

InstallMethod( ViewString, "for a singular bigint",
  [ IsSingularBigInt ],
  function( bigint )
    return STRINGIFY("<singular bigint:",_SI_Intbigint(bigint),">");
  end );

InstallMethod( ViewString, "for a singular bigintmat",
  [ IsSingularBigIntMat ],
  function( bigintmat )
    return STRINGIFY("<singular intmat:",_SI_Matbigintmat(bigintmat),">");
  end );

InstallMethod( ViewString, "for a singular intvec",
  [ IsSingularIntVec ],
  function( intvec )
    local mut;
    if SI_DEBUG_MODE and IsMutable(intvec) then mut := " (mutable)"; else mut := ""; fi;
    return STRINGIFY("<singular intvec",mut,":",_SI_Plistintvec(intvec),">");
  end );

InstallMethod( ViewString, "for a singular intmat",
  [ IsSingularIntMat ],
  function( intmat )
    local mut;
    if SI_DEBUG_MODE and IsMutable(intmat) then mut := " (mutable)"; else mut := ""; fi;
    return STRINGIFY("<singular intmat",mut,":",_SI_Matintmat(intmat),">");
  end );

InstallMethod( ViewString, "for a singular ideal",
  [ IsSingularIdeal ],
  function( ideal )
    local mut;
    if SI_DEBUG_MODE and IsMutable(ideal) then mut := " (mutable)"; else mut := ""; fi;
    return STRINGIFY("<singular ideal",mut,", ",SI_ncols(ideal)," gens>");
  end );


# TODO: Quoting the GAP manual:
# "ViewObj should print the object to the standard output in a short and
# concise form, it is used in the main read-eval-print loop to display
# the resulting object of a computation"
InstallMethod(ViewString, "for a generic singular object",
  [ IsSingularObj ],
  function( sobj )
    local mut;
    if SI_DEBUG_MODE and IsMutable(sobj) then mut := " (mutable)"; else mut := ""; fi;
    return Concatenation("<singular ",_SI_TypeName(sobj),mut,":\n",
                         SI_ToGAP(SI_print(sobj)),">");
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

