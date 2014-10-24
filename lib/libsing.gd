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

DeclareGlobalFunction( "_SI_Addition" );
DeclareGlobalFunction( "_SI_Addition_fast" );
DeclareGlobalFunction( "_SI_Subtraction" );
DeclareGlobalFunction( "_SI_Negation" );
DeclareGlobalFunction( "_SI_Negation_fast" );

DeclareOperation("SI_bigint",[IsSI_Object]);
DeclareOperation("SI_bigint",[IsInt]);

DeclareOperation("SI_bigintmat",[IsSI_Object]);
#DeclareOperation("SI_bigintmat",[IsSI_Object,IsPosInt,IsPosInt]);
DeclareOperation("SI_bigintmat",[IsList]);

DeclareOperation("SI_number",[IsSI_ring, IsObject]);

DeclareOperation("SI_intvec",[IsSI_Object]);
DeclareOperation("SI_intvec",[IsList]);

DeclareOperation("SI_intmat",[IsSI_Object]);
DeclareOperation("SI_intmat",[IsSI_Object,IsPosInt,IsPosInt]);
DeclareOperation("SI_intmat",[IsList]);

DeclareOperation("SI_poly",[IsSI_ring, IsSI_Object]);
DeclareOperation("SI_poly",[IsSI_ring, IsStringRep]);

DeclareOperation("SI_matrix",[IsSI_Object]);
DeclareOperation("SI_matrix",[IsSI_Object,IsPosInt,IsPosInt]);
DeclareOperation("SI_matrix",[IsSI_ring, IsPosInt, IsPosInt, IsStringRep]);
DeclareOperation("SI_matrix",[IsPosInt, IsPosInt, IsList]);

DeclareOperation("SI_vector",[IsSI_Object]);
DeclareOperation("SI_vector",[IsSI_ring, IsPosInt, IsStringRep]);

DeclareOperation("SI_ZeroMat",[IsSI_ring, IsPosInt, IsPosInt]);
DeclareOperation("SI_IdentityMat",[IsSI_ring, IsPosInt]);

DeclareOperation("SI_ideal",[IsSI_Object]);
DeclareOperation("SI_ideal",[IsSI_ring, IsStringRep]);
DeclareOperation("SI_ideal",[IsList]);

DeclareGlobalFunction( "_SI_Comparer" );
