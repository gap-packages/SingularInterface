# Make some types:

SingularTypes := [];

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

SingularTypes[SINGULAR_TYPENRS.SINGTYPE_BIGINT]
   := NewType(SingularFamily,IsSingularBigInt);
SingularTypes[SINGULAR_TYPENRS.SINGTYPE_IDEAL]
   := NewType(SingularFamily,IsSingularIdeal);
SingularTypes[SINGULAR_TYPENRS.SINGTYPE_INTMAT]
   := NewType(SingularFamily,IsSingularIntMat);
SingularTypes[SINGULAR_TYPENRS.SINGTYPE_INTVEC]
   := NewType(SingularFamily,IsSingularIntVec);
SingularTypes[SINGULAR_TYPENRS.SINGTYPE_LINK]
   := NewType(SingularFamily,IsSingularLink);
SingularTypes[SINGULAR_TYPENRS.SINGTYPE_LIST]
   := NewType(SingularFamily,IsSingularList);
SingularTypes[SINGULAR_TYPENRS.SINGTYPE_MAP]
   := NewType(SingularFamily,IsSingularMap);
SingularTypes[SINGULAR_TYPENRS.SINGTYPE_MATRIX]
   := NewType(SingularFamily,IsSingularMatrix);
SingularTypes[SINGULAR_TYPENRS.SINGTYPE_MODULE]
   := NewType(SingularFamily,IsSingularModule);
SingularTypes[SINGULAR_TYPENRS.SINGTYPE_NUMBER]
   := NewType(SingularFamily,IsSingularNumber);
SingularTypes[SINGULAR_TYPENRS.SINGTYPE_POLY]
   := NewType(SingularFamily,IsSingularPoly);
SingularTypes[SINGULAR_TYPENRS.SINGTYPE_QRING] 
   := NewType(SingularFamily,IsSingularQRing);
SingularTypes[SINGULAR_TYPENRS.SINGTYPE_RESOLUTION] 
   := NewType(SingularFamily,IsSingularResolution);
SingularTypes[SINGULAR_TYPENRS.SINGTYPE_RING] 
   := NewType(SingularFamily,IsSingularRing);
SingularTypes[SINGULAR_TYPENRS.SINGTYPE_STRING] 
   := NewType(SingularFamily,IsSingularString);
SingularTypes[SINGULAR_TYPENRS.SINGTYPE_VECTOR] 
   := NewType(SingularFamily,IsSingularVector);

BindGlobal("SINGULAR_TYPETAB",
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

SingularRings := [];
SingularElCounts := [];
SingularErrors := "";

DeclareGlobalFunction( "CleanupSingularRings" );

DeclareGlobalFunction( "InitSingularInterpreter" );
# This is called automatically from libsing.gi, no need for the user to call it.

DeclareOperation( "Singular", [IsStringRep] );
DeclareOperation( "Singular", [] );

DeclareOperation( "SI_proxy", [IsSingularObj, IsPosInt] );
DeclareOperation( "SI_proxy", [IsSingularObj, IsPosInt, IsPosInt] );

