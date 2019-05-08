# SingularInterface: A GAP interface to Singular
#
# Copyright of SingularInterface belongs to its developers.
# Please refer to the COPYRIGHT file for details.
#
# SPDX-License-Identifier: GPL-2.0-or-later

DeclareGlobalFunction( "_SI_Addition" );
DeclareGlobalFunction( "_SI_Addition_fast" );
DeclareGlobalFunction( "_SI_Subtraction" );
DeclareGlobalFunction( "_SI_Negation" );
DeclareGlobalFunction( "_SI_Negation_fast" );

DeclareOperation("SI_bigint",[IsSI_Object]);
DeclareOperation("SI_bigint",[IsInt]);

DeclareOperation("SI_bigintmat",[IsSI_Object]);
#DeclareOperation("SI_bigintmat",[IsSI_Object, IsPosInt, IsPosInt]);
DeclareOperation("SI_bigintmat",[IsList]);

DeclareOperation("SI_number",[IsSI_ring, IsObject]);

DeclareOperation("SI_intvec",[IsSI_Object]);
DeclareOperation("SI_intvec",[IsList]);

DeclareOperation("SI_intmat",[IsSI_Object]);
DeclareOperation("SI_intmat",[IsSI_Object, IsPosInt, IsPosInt]);
DeclareOperation("SI_intmat",[IsList]);

DeclareOperation("SI_poly",[IsSI_ring, IsSI_Object]);
DeclareOperation("SI_poly",[IsSI_ring, IsStringRep]);

DeclareOperation("SI_matrix",[IsSI_Object]);
DeclareOperation("SI_matrix",[IsSI_Object, IsPosInt, IsPosInt]);
DeclareOperation("SI_matrix",[IsSI_ring, IsPosInt, IsPosInt, IsStringRep]);
DeclareOperation("SI_matrix",[IsPosInt, IsPosInt, IsList]);

DeclareOperation("SI_vector",[IsSI_Object]);
DeclareOperation("SI_vector",[IsSI_ring, IsStringRep]);

DeclareOperation("SIC_ZeroMat",[IsSI_ring, IsPosInt, IsPosInt]);
DeclareOperation("SIC_IdentityMat",[IsSI_ring, IsPosInt]);

DeclareOperation("SI_ideal",[IsSI_Object]);
DeclareOperation("SI_ideal",[IsSI_ring, IsStringRep]);
DeclareOperation("SI_ideal",[IsList]);

DeclareGlobalFunction( "_SI_Comparer" );
