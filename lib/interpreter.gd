# SingularInterface: A GAP interface to Singular
#
# Copyright of SingularInterface belongs to its developers.
# Please refer to the COPYRIGHT file for details.
#
# SPDX-License-Identifier: GPL-2.0-or-later

DeclareGlobalFunction( "_SI_BindSingularProcs" );

DeclareOperation( "Singular", [IsStringRep] );
DeclareOperation( "Singular", [IsString and IsEmpty] );
DeclareOperation( "Singular", [] );

DeclareGlobalFunction( "SingularLastError" );

# Useful little helper to undefine a Singular var or proc
DeclareGlobalFunction( "SingularUnbind" );
