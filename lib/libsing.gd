# Make some types:

_SI_Types := [];

SingularFamily := NewFamily("SingularFamily");
DeclareCategory( "IsSingularObj", IsObject );
DeclareCategory( "IsSingularBigInt", IsSingularObj );
DeclareCategory( "IsSingularIdeal", IsSingularObj );
DeclareCategory( "IsSingularIntMat", IsSingularObj );
DeclareCategory( "IsSingularIntVec", IsSingularObj );
DeclareCategory( "IsSingularLink", IsSingularObj );
DeclareCategory( "IsSingularList", IsSingularObj );
DeclareCategory( "IsSingularMap", IsSingularObj );
DeclareCategory( "IsSingularMatrix", IsSingularObj );
DeclareCategory( "IsSingularModule", IsSingularObj );
DeclareCategory( "IsSingularNumber", IsSingularObj );
DeclareCategory( "IsSingularPoly", IsSingularObj );
DeclareCategory( "IsSingularQRing", IsSingularObj );
DeclareCategory( "IsSingularResolution", IsSingularObj );
DeclareCategory( "IsSingularRing", IsSingularObj );
DeclareCategory( "IsSingularString", IsSingularObj );
DeclareCategory( "IsSingularVector", IsSingularObj );
DeclareCategory( "IsSingularProxy", IsPositionalObjectRep and IsSingularObj );

_SI_Types[_SI_TYPENRS.SINGTYPE_BIGINT]
   := NewType(SingularFamily,IsSingularBigInt);
_SI_Types[_SI_TYPENRS.SINGTYPE_IDEAL]
   := NewType(SingularFamily,IsSingularIdeal);
_SI_Types[_SI_TYPENRS.SINGTYPE_INTMAT]
   := NewType(SingularFamily,IsSingularIntMat);
_SI_Types[_SI_TYPENRS.SINGTYPE_INTVEC]
   := NewType(SingularFamily,IsSingularIntVec);
_SI_Types[_SI_TYPENRS.SINGTYPE_LINK]
   := NewType(SingularFamily,IsSingularLink);
_SI_Types[_SI_TYPENRS.SINGTYPE_LIST]
   := NewType(SingularFamily,IsSingularList);
_SI_Types[_SI_TYPENRS.SINGTYPE_MAP]
   := NewType(SingularFamily,IsSingularMap);
_SI_Types[_SI_TYPENRS.SINGTYPE_MATRIX]
   := NewType(SingularFamily,IsSingularMatrix);
_SI_Types[_SI_TYPENRS.SINGTYPE_MODULE]
   := NewType(SingularFamily,IsSingularModule);
_SI_Types[_SI_TYPENRS.SINGTYPE_NUMBER]
   := NewType(SingularFamily,IsSingularNumber);
_SI_Types[_SI_TYPENRS.SINGTYPE_POLY]
   := NewType(SingularFamily,IsSingularPoly);
_SI_Types[_SI_TYPENRS.SINGTYPE_QRING] 
   := NewType(SingularFamily,IsSingularQRing);
_SI_Types[_SI_TYPENRS.SINGTYPE_RESOLUTION] 
   := NewType(SingularFamily,IsSingularResolution);
_SI_Types[_SI_TYPENRS.SINGTYPE_RING] 
   := NewType(SingularFamily,IsSingularRing);
_SI_Types[_SI_TYPENRS.SINGTYPE_STRING] 
   := NewType(SingularFamily,IsSingularString);
_SI_Types[_SI_TYPENRS.SINGTYPE_VECTOR] 
   := NewType(SingularFamily,IsSingularVector);

BindGlobal("_SI_TYPETAB",
    rec( bigint := IsSingularBigInt,
         ideal := IsSingularIdeal,
         intmat := IsSingularIntMat,
         intvec := IsSingularIntVec,
         link := IsSingularLink,
         list := IsSingularList,
         map := IsSingularMap,
         matrix := IsSingularMatrix,
         module := IsSingularModule,
         number := IsSingularNumber,
         poly := IsSingularPoly,
         qring := IsSingularQRing,
         resolution := IsSingularResolution,
         ring := IsSingularRing,
         string := IsSingularString,
         vector := IsSingularVector,
       ));

BindGlobal("SingularProxiesType", NewType( SingularFamily, IsSingularProxy ));

_SI_Rings := [];
_SI_ElCounts := [];
_SI_Errors := "";

DeclareGlobalFunction( "SI_CleanupRings" );

DeclareGlobalFunction( "_SI_InitInterpreter" );
# This is called automatically from libsing.gi, no need for the user to call it.

DeclareOperation( "Singular", [IsStringRep] );
DeclareOperation( "Singular", [] );

DeclareOperation( "SI_Proxy", [IsSingularObj, IsPosInt] );
DeclareOperation( "SI_Proxy", [IsSingularObj, IsPosInt, IsPosInt] );
DeclareOperation( "SI_Proxy", [IsSingularObj, IsStringRep] );


