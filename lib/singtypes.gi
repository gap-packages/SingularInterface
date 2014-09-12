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

InstallMethod( _SI_TypeName, ["IsSingularVoid"], x->"void" );
InstallMethod( _SI_TypeName, ["IsSingularBigInt"], x->"bigint" );
InstallMethod( _SI_TypeName, ["IsSingularBigIntMat"], x->"bigintmat" );
InstallMethod( _SI_TypeName, ["IsSingularIdeal"], x->"ideal" );
InstallMethod( _SI_TypeName, ["IsSingularIntMat"], x->"intmat" );
InstallMethod( _SI_TypeName, ["IsSingularIntVec"], x->"intvec" );
InstallMethod( _SI_TypeName, ["IsSingularLink"], x->"link" );
InstallMethod( _SI_TypeName, ["IsSingularList"], x->"list" );
InstallMethod( _SI_TypeName, ["IsSingularMap"], x->"map" );
InstallMethod( _SI_TypeName, ["IsSingularMatrix"], x->"matrix" );
InstallMethod( _SI_TypeName, ["IsSingularModule"], x->"module" );
InstallMethod( _SI_TypeName, ["IsSingularNumber"], x->"number" );
InstallMethod( _SI_TypeName, ["IsSingularPoly"], x->"poly" );
InstallMethod( _SI_TypeName, ["IsSingularQRing"], x->"qring" );
InstallMethod( _SI_TypeName, ["IsSingularResolution"], x->"resolution" );
InstallMethod( _SI_TypeName, ["IsSingularRing"], x->"ring" );
InstallMethod( _SI_TypeName, ["IsSingularString"], x->"string" );
InstallMethod( _SI_TypeName, ["IsSingularVector"], x->"vector" );
