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

SI_Errors := "";

DeclareGlobalFunction( "_SI_BindSingularProcs" );

DeclareGlobalFunction( "_SI_Addition" );
DeclareGlobalFunction( "_SI_Addition_fast" );
DeclareGlobalFunction( "_SI_Subtraction" );
DeclareGlobalFunction( "_SI_Negation" );
DeclareGlobalFunction( "_SI_Negation_fast" );

DeclareOperation("SI_bigint",[IsSingularObj]);
DeclareOperation("SI_bigint",[IsInt]);

DeclareOperation("SI_bigintmat",[IsSingularObj]);
#DeclareOperation("SI_bigintmat",[IsSingularObj,IsPosInt,IsPosInt]);
DeclareOperation("SI_bigintmat",[IsList]);

DeclareOperation("SI_number",[IsSingularRing, IsObject]);

DeclareOperation("SI_intvec",[IsSingularObj]);
DeclareOperation("SI_intvec",[IsList]);

DeclareOperation("SI_intmat",[IsSingularObj]);
DeclareOperation("SI_intmat",[IsSingularObj,IsPosInt,IsPosInt]);
DeclareOperation("SI_intmat",[IsList]);

DeclareOperation("SI_poly",[IsSingularRing, IsSingularObj]);
DeclareOperation("SI_poly",[IsSingularRing, IsStringRep]);

DeclareOperation("SI_matrix",[IsSingularObj]);
DeclareOperation("SI_matrix",[IsSingularObj,IsPosInt,IsPosInt]);
DeclareOperation("SI_matrix",[IsSingularRing, IsPosInt, IsPosInt, IsStringRep]);
DeclareOperation("SI_matrix",[IsPosInt, IsPosInt, IsList]);

DeclareOperation("SI_vector",[IsSingularObj]);
DeclareOperation("SI_vector",[IsSingularRing, IsPosInt, IsStringRep]);

DeclareOperation("SI_ZeroMat",[IsSingularRing, IsPosInt, IsPosInt]);
DeclareOperation("SI_IdentityMat",[IsSingularRing, IsPosInt]);

DeclareOperation("SI_ideal",[IsSingularObj]);
DeclareOperation("SI_ideal",[IsSingularRing, IsStringRep]);
DeclareOperation("SI_ideal",[IsList]);

DeclareGlobalFunction( "_SI_Comparer" );
