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

InstallMethod( _SI_TypeName, ["IsSI_void"], x->"void" );
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
