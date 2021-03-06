# SingularInterface: A GAP interface to Singular
#
# Copyright of SingularInterface belongs to its developers.
# Please refer to the COPYRIGHT file for details.
#
# SPDX-License-Identifier: GPL-2.0-or-later

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

InstallMethod(SI_poly, [IsSI_ring, IsSI_Object], _SI_poly_singular);
InstallMethod(SI_poly, [IsSI_ring, IsStringRep],
function(ring, desc)
    local str;
    SI_SetCurrRing(ring);
    SingularUnbind("SI_poly_maker");
    str := Concatenation("proc SI_poly_maker(){poly p = ", desc, "; return(p);}");
    Singular(str);
    return SI_CallProc("SI_poly_maker", []);
end);

InstallMethod(SI_matrix, ["IsSI_Object"], _SI_matrix_singular);
InstallMethod(SI_matrix, ["IsSI_Object", "IsPosInt", "IsPosInt"],
  _SI_matrix_singular);
InstallMethod(SI_matrix, ["IsSI_ring", "IsPosInt", "IsPosInt", "IsStringRep"],
function(ring, rows, cols, desc)
    local str;
    SI_SetCurrRing(ring);
    SingularUnbind("SI_matrix_maker");
    str := Concatenation("proc SI_matrix_maker(){matrix m[",
                String(rows), "][", String(cols), "] = ", desc, "; return(m);}");
    Singular(str);
    return SI_CallProc("SI_matrix_maker", []);
end);
InstallMethod(SI_matrix, ["IsPosInt", "IsPosInt", "IsList"],
              _SI_matrix_from_els);

InstallMethod(SIC_ZeroMat,["IsSI_ring", "IsPosInt", "IsPosInt"],
function(r, rows, cols)
    return SI_matrix(r, rows, cols," ");
end );

InstallMethod(SIC_IdentityMat,["IsSI_ring", "IsPosInt"],
function(r, rows)
    return SI_matrix(SI_freemodule(r, rows));
end );

# A singular vector is a "polynomial" in which each monomial also carries
# its position
InstallMethod(SI_vector, [IsSI_Object], _SI_vector_singular);
InstallMethod(SI_vector, [IsSI_ring, IsStringRep],
function(ring, desc)
    local str;
    SI_SetCurrRing(ring);
    SingularUnbind("SI_vector_maker");
    str := Concatenation("proc SI_vector_maker(){vector v = [", desc, "]; return(v);}");
    Singular(str);
    return SI_CallProc("SI_vector_maker", []);
end);

InstallMethod(SI_ideal, [IsSI_Object], _SI_ideal_singular);
InstallMethod(SI_ideal, [IsSI_ring, IsStringRep],
function(ring, desc)
    local str;
    SI_SetCurrRing(ring);
    SingularUnbind("SI_ideal_maker");
    str := Concatenation("proc SI_ideal_maker(){ideal i = ", desc, "; return(i);}");
    Singular(str);
    return SI_CallProc("SI_ideal_maker", []);
end);
InstallMethod(SI_ideal,[IsList], _SI_ideal_from_els);



InstallMethod(Length, [IsSI_intvec], SI_nrows);
InstallMethod(Length, [IsSI_vector], SI_nrows);

InstallMethod(Length, [IsSI_string], SI_size);
