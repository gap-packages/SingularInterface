# SingularInterface: A GAP interface to Singular
#
# Copyright of SingularInterface belongs to its developers.
# Please refer to the COPYRIGHT file for details.
#
# SPDX-License-Identifier: GPL-2.0-or-later

InstallMethod( _SI_TypeName, ["IsSI_bigint"], x->"bigint" );
InstallMethod( _SI_TypeName, ["IsSI_bigintmat"], x->"bigintmat" );
InstallMethod( _SI_TypeName, ["IsSI_ideal"], x->"ideal" );
InstallMethod( _SI_TypeName, ["IsSI_intmat"], x->"intmat" );
InstallMethod( _SI_TypeName, ["IsSI_intvec"], x->"intvec" );
InstallMethod( _SI_TypeName, ["IsSI_link"], x->"link" );
InstallMethod( _SI_TypeName, ["IsSI_list"], x->"list" );
InstallMethod( _SI_TypeName, ["IsSI_map"], x->"map" );
InstallMethod( _SI_TypeName, ["IsSI_matrix"], x->"matrix" );
InstallMethod( _SI_TypeName, ["IsSI_module"], x->"module" );
InstallMethod( _SI_TypeName, ["IsSI_number"], x->"number" );
InstallMethod( _SI_TypeName, ["IsSI_poly"], x->"poly" );
InstallMethod( _SI_TypeName, ["IsSI_qring"], x->"qring" );
InstallMethod( _SI_TypeName, ["IsSI_resolution"], x->"resolution" );
InstallMethod( _SI_TypeName, ["IsSI_ring"], x->"ring" );
InstallMethod( _SI_TypeName, ["IsSI_string"], x->"string" );
InstallMethod( _SI_TypeName, ["IsSI_vector"], x->"vector" );
