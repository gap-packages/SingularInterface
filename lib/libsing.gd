# Make some types:

_SI_Types := [];

SingularFamily := NewFamily("SingularFamily");
Setter(ElementsFamily)(SingularFamily, SingularFamily); # Grrrrrrrrr

DeclareCategory( "IsSingularObj", IsObject );
DeclareOperation( "_SI_TypeName", [IsSingularObj] );
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

SI_Errors := "";

DeclareGlobalFunction( "_SI_BindSingularProcs" );

DeclareGlobalFunction( "_SI_Addition" );
DeclareGlobalFunction( "_SI_Addition_fast" );
DeclareGlobalFunction( "_SI_Subtraction" );
DeclareGlobalFunction( "_SI_Negation" );
DeclareGlobalFunction( "_SI_Negation_fast" );

DeclareGlobalFunction( "_SI_InitInterpreter" );
# This is called automatically from libsing.gi, no need for the user to call it.

DeclareOperation( "Singular", [IsStringRep] );
DeclareOperation( "Singular", [IsString and IsEmpty] );
DeclareOperation( "Singular", [] );

BindGlobal("SI_bigint_singular", SI_bigint);
MakeReadWriteGVar("SI_bigint");
Unbind(SI_bigint);
DeclareOperation("SI_bigint",[IsSingularObj]);
DeclareOperation("SI_bigint",[IsInt]);

BindGlobal("SI_bigintmat_singular", SI_bigintmat);
MakeReadWriteGVar("SI_bigintmat");
Unbind(SI_bigintmat);
DeclareOperation("SI_bigintmat",[IsSingularObj]);
#DeclareOperation("SI_bigintmat",[IsSingularObj,IsPosInt,IsPosInt]);
DeclareOperation("SI_bigintmat",[IsList]);

BindGlobal("SI_number_singular", SI_number);
MakeReadWriteGVar("SI_number");
Unbind(SI_number);
DeclareOperation("SI_number",[IsSingularRing, IsSingularObj]);
DeclareOperation("SI_number",[IsSingularRing, IsInt]);

BindGlobal("SI_intvec_singular", SI_intvec);
MakeReadWriteGVar("SI_intvec");
Unbind(SI_intvec);
DeclareOperation("SI_intvec",[IsSingularObj]);
DeclareOperation("SI_intvec",[IsList]);

BindGlobal("SI_intmat_singular", SI_intmat);
MakeReadWriteGVar("SI_intmat");
Unbind(SI_intmat);
DeclareOperation("SI_intmat",[IsSingularObj]);
DeclareOperation("SI_intmat",[IsSingularObj,IsPosInt,IsPosInt]);
DeclareOperation("SI_intmat",[IsList]);

BindGlobal("SI_ring_singular", SI_ring);
MakeReadWriteGVar("SI_ring");
Unbind(SI_ring);
DeclareOperation("SI_ring",[IsSingularRing, IsSingularObj]);
DeclareOperation("SI_ring",[IsInt,IsList]);
DeclareOperation("SI_ring",[IsInt,IsList,IsList]);
# to get back associated ring
DeclareOperation("SI_ring",[IsSingularObj]);

BindGlobal("SI_poly_singular", SI_poly);
MakeReadWriteGVar("SI_poly");
Unbind(SI_poly);
DeclareOperation("SI_poly",[IsSingularRing, IsSingularObj]);
DeclareOperation("SI_poly",[IsSingularRing, IsStringRep]);

BindGlobal("SI_matrix_singular", SI_matrix);
MakeReadWriteGVar("SI_matrix");
Unbind(SI_matrix);
DeclareOperation("SI_matrix",[IsSingularObj]);
DeclareOperation("SI_matrix",[IsSingularObj,IsPosInt,IsPosInt]);
DeclareOperation("SI_matrix",[IsSingularRing, IsPosInt, IsPosInt, IsStringRep]);
DeclareOperation("SI_matrix",[IsPosInt, IsPosInt, IsList]);

BindGlobal("SI_vector_singular", SI_vector);
MakeReadWriteGVar("SI_vector");
Unbind(SI_vector);
DeclareOperation("SI_vector",[IsSingularObj]);
DeclareOperation("SI_vector",[IsSingularRing, IsPosInt, IsStringRep]);
DeclareOperation("SI_ZeroMat",[IsSingularRing, IsPosInt, IsPosInt]);
DeclareOperation("SI_IdentityMat",[IsSingularRing, IsPosInt]);

BindGlobal("SI_ideal_singular", SI_ideal);
MakeReadWriteGVar("SI_ideal");
Unbind(SI_ideal);
DeclareOperation("SI_ideal",[IsSingularObj]);
DeclareOperation("SI_ideal",[IsSingularRing, IsStringRep]);
DeclareOperation("SI_ideal",[IsList]);

DeclareOperation( "SI_Proxy", [IsSingularObj, IsPosInt] );
DeclareOperation( "SI_Proxy", [IsSingularObj, IsPosInt, IsPosInt] );
DeclareOperation( "SI_Proxy", [IsSingularObj, IsStringRep] );

DeclareGlobalFunction( "_SI_Comparer" );

DeclareGlobalFunction( "SI_AddGAPFunctionToSingularInterpreter" );

