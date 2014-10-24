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


#
# Make some Singular interpreter functions for matrices available as methods
# for the corresponding GAP operations

InstallOtherMethod(TraceMat, [IsSI_Object and IsMatrixObj], SI_trace);

InstallOtherMethod(TransposedMat, [IsSI_Object and IsMatrixObj], SI_transpose);

InstallOtherMethod(Determinant, [IsSI_intmat], SI_det);
InstallOtherMethod(Determinant, [IsSI_bigintmat], SI_det);
InstallOtherMethod(Determinant, [IsSI_matrix], SI_det);

InstallOtherMethod(DeterminantMat, [IsSI_intmat], SI_det);
InstallOtherMethod(DeterminantMat, [IsSI_bigintmat], SI_det);
InstallOtherMethod(DeterminantMat, [IsSI_matrix], SI_det);

#DeclareAttribute( "TransposedMatImmutable", IsMatrixObj );
#DeclareOperation( "TransposedMatMutable", [IsMatrixObj] );

InstallMethod(MatElm, [IsSI_Object and IsMatrixObj, IsPosInt, IsPosInt], _SI_MatElm);
InstallMethod(SetMatElm, [IsSI_Object and IsMatrixObj, IsPosInt, IsPosInt, IsObject], _SI_SetMatElm);

InstallMethod(Length, [IsSI_Object and IsMatrixObj], SI_ncols);



#
# Alternative access via the syntax mat[[row,col]]
#
# This is a syntax extension in GAP; most of it is not yet
# in a released GAP version.
#
# Usage example:
#
#
# gap> m:=SI_intmat([[1,2,3],[4,5,6]]);
# <singular intmat:[ [ 1, 2, 3 ], [ 4, 5, 6 ] ]>
# gap> IsBound(m[[1,2]]);
# true
# gap> m[[1,2]];
# 2
# gap> m[[1,2]]:=42;
# 42
# gap> m[[1,2]];
# 42
# gap> m;
# <singular intmat:[ [ 1, 42, 3 ], [ 4, 5, 6 ] ]>
#
_SI_MatElm_with_list := function(mat, l)
    Assert(0, Length(l) = 2 and ForAll(l, IsPosInt));   # TODO: replace by proper error
    return _SI_MatElm(mat, l[1], l[2]);
end;
InstallOtherMethod(\[\], [IsSI_matrix, IsList], _SI_MatElm_with_list);
InstallOtherMethod(\[\], [IsSI_intmat, IsList], _SI_MatElm_with_list);
InstallOtherMethod(\[\], [IsSI_bigintmat, IsList], _SI_MatElm_with_list);

_SI_SetMatElm_with_list := function(mat, l, val)
    Assert(0, Length(l) = 2 and ForAll(l, IsPosInt));
    _SI_SetMatElm(mat, l[1], l[2], val);
end;
InstallOtherMethod(\[\]\:\=, [IsSI_matrix, IsList, IsObject], _SI_SetMatElm_with_list);
InstallOtherMethod(\[\]\:\=, [IsSI_intmat, IsList, IsObject], _SI_SetMatElm_with_list);
InstallOtherMethod(\[\]\:\=, [IsSI_bigintmat, IsList, IsObject], _SI_SetMatElm_with_list);

_SI_MatElmIsBound_with_list := function(mat, l)
    return Length(l) = 2 and l[1] in [1..SI_nrows(mat)] and l[2] in [1..SI_ncols(mat)];
end;
InstallOtherMethod(ISB_LIST, [IsSI_matrix, IsList], _SI_MatElmIsBound_with_list);
InstallOtherMethod(ISB_LIST, [IsSI_intmat, IsList], _SI_MatElmIsBound_with_list);
InstallOtherMethod(ISB_LIST, [IsSI_bigintmat, IsList], _SI_MatElmIsBound_with_list);

_SI_MatElmUnbind_with_list := function(mat, l)
    Error("Cannot unbind entries of singular matrix");
end;
InstallOtherMethod(UNB_LIST, [IsSI_matrix, IsList], _SI_MatElmUnbind_with_list);
InstallOtherMethod(UNB_LIST, [IsSI_intmat, IsList], _SI_MatElmUnbind_with_list);
InstallOtherMethod(UNB_LIST, [IsSI_bigintmat, IsList], _SI_MatElmUnbind_with_list);
