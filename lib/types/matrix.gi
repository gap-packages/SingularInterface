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
