# Make some types:

SingularFamily := NewFamily("SingularFamily");
Setter(ElementsFamily)(SingularFamily, SingularFamily); # HACK: Grrrrrrrrr

_SI_Types := [];

DeclareCategory( "IsSingularObj", IsObject );
DeclareCategory( "IsSingularVoid", IsSingularObj );
DeclareCategory( "IsSingularBigInt", IsSingularObj and IsRingElementWithOne );
DeclareCategory( "IsSingularBigIntMat", IsSingularObj and IsList );
DeclareCategory( "IsSingularIdeal", IsSingularObj );
DeclareCategory( "IsSingularIntMat", IsSingularObj and IsList );
DeclareCategory( "IsSingularIntVec", IsSingularObj and IsList );
DeclareCategory( "IsSingularLink", IsSingularObj );
DeclareCategory( "IsSingularList", IsSingularObj and IsList);
DeclareCategory( "IsSingularMap", IsSingularObj );
DeclareCategory( "IsSingularMatrix", IsSingularObj );
DeclareCategory( "IsSingularModule", IsSingularObj );
DeclareCategory( "IsSingularNumber", IsSingularObj and IsRingElementWithOne );
DeclareCategory( "IsSingularPoly", IsSingularObj and IsRingElementWithOne );
DeclareCategory( "IsSingularQRing", IsSingularObj and IsAdditiveMagmaWithZero
                  and IsRingWithOne );
DeclareCategory( "IsSingularResolution", IsSingularObj );
DeclareCategory( "IsSingularRing", IsSingularObj and IsAdditiveMagmaWithZero
                  and IsRingWithOne );
DeclareCategory( "IsSingularString", IsSingularObj and IsList );
DeclareCategory( "IsSingularVector", IsSingularObj and IsList );
DeclareCategory( "IsSingularProxy", IsPositionalObjectRep and IsSingularObj );

_SI_Types[_SI_TYPENRS.SINGTYPE_VOID]
   := NewType(SingularFamily,IsSingularVoid);
_SI_Types[_SI_TYPENRS.SINGTYPE_BIGINT]
   := NewType(SingularFamily,IsSingularBigInt and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_BIGINT_IMM]
   := NewType(SingularFamily,IsSingularBigInt);
_SI_Types[_SI_TYPENRS.SINGTYPE_BIGINTMAT]
   := NewType(SingularFamily,IsSingularBigIntMat and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_BIGINTMAT_IMM]
   := NewType(SingularFamily,IsSingularBigIntMat);
_SI_Types[_SI_TYPENRS.SINGTYPE_IDEAL]
   := NewType(SingularFamily,IsSingularIdeal and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_IDEAL_IMM]
   := NewType(SingularFamily,IsSingularIdeal);
_SI_Types[_SI_TYPENRS.SINGTYPE_INTMAT]
   := NewType(SingularFamily,IsSingularIntMat and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_INTMAT_IMM]
   := NewType(SingularFamily,IsSingularIntMat);
_SI_Types[_SI_TYPENRS.SINGTYPE_INTVEC]
   := NewType(SingularFamily,IsSingularIntVec and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_INTVEC_IMM]
   := NewType(SingularFamily,IsSingularIntVec);
_SI_Types[_SI_TYPENRS.SINGTYPE_LINK]
   := NewType(SingularFamily,IsSingularLink and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_LINK_IMM]
   := NewType(SingularFamily,IsSingularLink);
_SI_Types[_SI_TYPENRS.SINGTYPE_LIST]
   := NewType(SingularFamily,IsSingularList and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_LIST_IMM]
   := NewType(SingularFamily,IsSingularList);
_SI_Types[_SI_TYPENRS.SINGTYPE_MAP]
   := NewType(SingularFamily,IsSingularMap and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_MAP_IMM]
   := NewType(SingularFamily,IsSingularMap);
_SI_Types[_SI_TYPENRS.SINGTYPE_MATRIX]
   := NewType(SingularFamily,IsSingularMatrix and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_MATRIX_IMM]
   := NewType(SingularFamily,IsSingularMatrix);
_SI_Types[_SI_TYPENRS.SINGTYPE_MODULE]
   := NewType(SingularFamily,IsSingularModule and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_MODULE_IMM]
   := NewType(SingularFamily,IsSingularModule);
_SI_Types[_SI_TYPENRS.SINGTYPE_NUMBER]
   := NewType(SingularFamily,IsSingularNumber and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_NUMBER_IMM]
   := NewType(SingularFamily,IsSingularNumber);
_SI_Types[_SI_TYPENRS.SINGTYPE_POLY]
   := NewType(SingularFamily,IsSingularPoly and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_POLY_IMM]
   := NewType(SingularFamily,IsSingularPoly);
_SI_Types[_SI_TYPENRS.SINGTYPE_QRING]
   := NewType(SingularFamily,IsSingularQRing and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_QRING_IMM]
   := NewType(SingularFamily,IsSingularQRing);
_SI_Types[_SI_TYPENRS.SINGTYPE_RESOLUTION]
   := NewType(SingularFamily,IsSingularResolution and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_RESOLUTION_IMM]
   := NewType(SingularFamily,IsSingularResolution);
_SI_Types[_SI_TYPENRS.SINGTYPE_RING]
   := NewType(SingularFamily,IsSingularRing and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_RING_IMM]
   := NewType(SingularFamily,IsSingularRing);
_SI_Types[_SI_TYPENRS.SINGTYPE_STRING]
   := NewType(SingularFamily,IsSingularString and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_STRING_IMM]
   := NewType(SingularFamily,IsSingularString);
_SI_Types[_SI_TYPENRS.SINGTYPE_VECTOR]
   := NewType(SingularFamily,IsSingularVector and IsMutable);
_SI_Types[_SI_TYPENRS.SINGTYPE_VECTOR_IMM]
   := NewType(SingularFamily,IsSingularVector);

BindGlobal("_SI_ProxiesType",
  NewType( SingularFamily, IsSingularProxy and IsMutable));

DeclareOperation( "_SI_TypeName", [IsSingularObj] );
