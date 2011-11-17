# Make some types:

SingularTypes := [];

SingularFamily := NewFamily("SingularFamily");
DeclareCategory( "IsSingularObj", IsObject );
DeclareCategory( "IsSingularRing", IsSingularObj );
DeclareCategory( "IsSingularPoly", IsSingularObj );
DeclareCategory( "IsSingularBigInt", IsSingularObj );
DeclareCategory( "IsSingularIntVec", IsSingularObj );
DeclareCategory( "IsSingularIntMat", IsSingularObj );
DeclareCategory( "IsSingularIdeal", IsSingularObj );
DeclareCategory( "IsSingularProxy", IsPositionalObjectRep and IsSingularObj );

SingularTypes[SINGULAR_TYPENRS.SINGTYPE_RING] 
   := NewType(SingularFamily,IsSingularRing);
SingularTypes[SINGULAR_TYPENRS.SINGTYPE_POLY]
   := NewType(SingularFamily,IsSingularPoly);
SingularTypes[SINGULAR_TYPENRS.SINGTYPE_BIGINT]
   := NewType(SingularFamily,IsSingularBigInt);
SingularTypes[SINGULAR_TYPENRS.SINGTYPE_INTVEC]
   := NewType(SingularFamily,IsSingularIntVec);
SingularTypes[SINGULAR_TYPENRS.SINGTYPE_INTMAT]
   := NewType(SingularFamily,IsSingularIntMat);
SingularTypes[SINGULAR_TYPENRS.SINGTYPE_IDEAL]
   := NewType(SingularFamily,IsSingularIdeal);

BindGlobal("SingularProxiesType", NewType( SingularFamily, IsSingularProxy ));

SingularRings := [];
SingularElCounts := [];
SingularErrors := "";

DeclareGlobalFunction( "CleanupSingularRings" );

DeclareGlobalFunction( "InitSingularInterpreter" );
# This is called automatically from libsingular.gi, no need for the user to call it.

DeclareOperation( "Singular", [IsStringRep] );
DeclareOperation( "Singular", [] );

DeclareOperation( "SI_proxy", [IsSingularObj, IsPosInt] );
DeclareOperation( "SI_proxy", [IsSingularObj, IsPosInt, IsPosInt] );
