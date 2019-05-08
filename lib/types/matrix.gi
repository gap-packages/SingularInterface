# SingularInterface: A GAP interface to Singular
#
# Copyright of SingularInterface belongs to its developers.
# Please refer to the COPYRIGHT file for details.
#
# SPDX-License-Identifier: GPL-2.0-or-later


#
# Make some Singular interpreter functions for matrices available as methods
# for the corresponding GAP operations
#
InstallMethod(TraceMat, [IsSI_Object and IsMatrixObj], SI_trace);
InstallMethod(TransposedMat, [IsSI_Object and IsMatrixObj], SI_transpose);
InstallMethod(Determinant, [IsSI_Object and IsMatrixObj], SI_det);
InstallOtherMethod(DeterminantMat, [IsSI_Object and IsMatrixObj], SI_det);

#
# Access via legacy MatrixObj API
#
InstallMethod(MatElm, [IsSI_Object and IsMatrixObj, IsPosInt, IsPosInt], _SI_MatElm);
InstallMethod(SetMatElm, [IsSI_Object and IsMatrixObj, IsPosInt, IsPosInt, IsObject], _SI_SetMatElm);

InstallMethod(Length, [IsSI_Object and IsMatrixObj], SI_ncols);


#
# Access via modern MatrixObj API
#
InstallMethod(\[\], [IsSI_Object and IsMatrixObj, IsPosInt, IsPosInt], _SI_MatElm);
InstallMethod(\[\]\:\=, [IsSI_Object and IsMatrixObj, IsPosInt, IsPosInt, IsObject], _SI_SetMatElm);

InstallMethod(NrCols, [IsSI_Object and IsMatrixObj], SI_ncols);
InstallMethod(NrRows, [IsSI_Object and IsMatrixObj], SI_nrows);

# TODO: install IsBound method to support  IsBound(mat[i,j]) ???
