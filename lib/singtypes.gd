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

# Make some types:

SingularFamily := NewFamily("SingularFamily");
Setter(ElementsFamily)(SingularFamily, SingularFamily); # HACK: Grrrrrrrrr

DeclareCategory( "IsSI_Object", IsObject );

DeclareCategory( "IsSI_bigint", IsSI_Object and IsRingElementWithOne );
DeclareCategory( "IsSI_bigintmat", IsSI_Object and IsList );
DeclareCategory( "IsSI_ideal", IsSI_Object );
DeclareCategory( "IsSI_intmat", IsSI_Object and IsList );
DeclareCategory( "IsSI_intvec", IsSI_Object and IsList );
DeclareCategory( "IsSI_link", IsSI_Object );
DeclareCategory( "IsSI_list", IsSI_Object and IsList);
DeclareCategory( "IsSI_map", IsSI_Object );
DeclareCategory( "IsSI_matrix", IsSI_Object );
DeclareCategory( "IsSI_module", IsSI_Object );
DeclareCategory( "IsSI_number", IsSI_Object and IsRingElementWithOne );
DeclareCategory( "IsSI_poly", IsSI_Object and IsRingElementWithOne );
DeclareCategory( "IsSI_qring", IsSI_Object and IsAdditiveMagmaWithZero
                  and IsRingWithOne );
DeclareCategory( "IsSI_resolution", IsSI_Object );
DeclareCategory( "IsSI_ring", IsSI_Object and IsAdditiveMagmaWithZero
                  and IsRingWithOne );
DeclareCategory( "IsSI_string", IsSI_Object and IsList );
DeclareCategory( "IsSI_vector", IsSI_Object and IsList );
DeclareCategory( "IsSI_proxy", IsPositionalObjectRep and IsSI_Object );

_SI_Types := [];

_SI_Types[_SI_TYPENRS.SINGTYPE_BIGINT]
   := NewType(SingularFamily,IsSI_bigint and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_BIGINT_IMM]
   := NewType(SingularFamily,IsSI_bigint);
_SI_Types[_SI_TYPENRS.SINGTYPE_BIGINTMAT]
   := NewType(SingularFamily,IsSI_bigintmat and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_BIGINTMAT_IMM]
   := NewType(SingularFamily,IsSI_bigintmat);
_SI_Types[_SI_TYPENRS.SINGTYPE_IDEAL]
   := NewType(SingularFamily,IsSI_ideal and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_IDEAL_IMM]
   := NewType(SingularFamily,IsSI_ideal);
_SI_Types[_SI_TYPENRS.SINGTYPE_INTMAT]
   := NewType(SingularFamily,IsSI_intmat and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_INTMAT_IMM]
   := NewType(SingularFamily,IsSI_intmat);
_SI_Types[_SI_TYPENRS.SINGTYPE_INTVEC]
   := NewType(SingularFamily,IsSI_intvec and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_INTVEC_IMM]
   := NewType(SingularFamily,IsSI_intvec);
_SI_Types[_SI_TYPENRS.SINGTYPE_LINK]
   := NewType(SingularFamily,IsSI_link and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_LINK_IMM]
   := NewType(SingularFamily,IsSI_link);
_SI_Types[_SI_TYPENRS.SINGTYPE_LIST]
   := NewType(SingularFamily,IsSI_list and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_LIST_IMM]
   := NewType(SingularFamily,IsSI_list);
_SI_Types[_SI_TYPENRS.SINGTYPE_MAP]
   := NewType(SingularFamily,IsSI_map and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_MAP_IMM]
   := NewType(SingularFamily,IsSI_map);
_SI_Types[_SI_TYPENRS.SINGTYPE_MATRIX]
   := NewType(SingularFamily,IsSI_matrix and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_MATRIX_IMM]
   := NewType(SingularFamily,IsSI_matrix);
_SI_Types[_SI_TYPENRS.SINGTYPE_MODULE]
   := NewType(SingularFamily,IsSI_module and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_MODULE_IMM]
   := NewType(SingularFamily,IsSI_module);
_SI_Types[_SI_TYPENRS.SINGTYPE_NUMBER]
   := NewType(SingularFamily,IsSI_number and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_NUMBER_IMM]
   := NewType(SingularFamily,IsSI_number);
_SI_Types[_SI_TYPENRS.SINGTYPE_POLY]
   := NewType(SingularFamily,IsSI_poly and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_POLY_IMM]
   := NewType(SingularFamily,IsSI_poly);
_SI_Types[_SI_TYPENRS.SINGTYPE_QRING]
   := NewType(SingularFamily,IsSI_qring and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_QRING_IMM]
   := NewType(SingularFamily,IsSI_qring);
_SI_Types[_SI_TYPENRS.SINGTYPE_RESOLUTION]
   := NewType(SingularFamily,IsSI_resolution and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_RESOLUTION_IMM]
   := NewType(SingularFamily,IsSI_resolution);
_SI_Types[_SI_TYPENRS.SINGTYPE_RING]
   := NewType(SingularFamily,IsSI_ring and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_RING_IMM]
   := NewType(SingularFamily,IsSI_ring);
_SI_Types[_SI_TYPENRS.SINGTYPE_STRING]
   := NewType(SingularFamily,IsSI_string and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_STRING_IMM]
   := NewType(SingularFamily,IsSI_string);
_SI_Types[_SI_TYPENRS.SINGTYPE_VECTOR]
   := NewType(SingularFamily,IsSI_vector and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_VECTOR_IMM]
   := NewType(SingularFamily,IsSI_vector);

BindGlobal("_SI_ProxiesType",
  NewType( SingularFamily, IsSI_proxy and IsMutable));

DeclareOperation( "_SI_TypeName", [IsSI_Object] );
