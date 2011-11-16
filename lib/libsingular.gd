# Make some types:

SingularTypes := [];

SingularFamily := NewFamily("SingularFamily");
DeclareCategory( "IsSingularRing", IsObject );
DeclareCategory( "IsSingularPoly", IsObject );
DeclareCategory( "IsSingularBigInt", IsObject );

SingularTypes[SINGULAR_TYPENRS.SINGTYPE_RING] 
   := NewType(SingularFamily,IsSingularRing);
SingularTypes[SINGULAR_TYPENRS.SINGTYPE_POLY]
   := NewType(SingularFamily,IsSingularPoly);
SingularTypes[SINGULAR_TYPENRS.SINGTYPE_BIGINT]
   := NewType(SingularFamily,IsSingularBigInt);

SingularRings := [];
SingularElCounts := [];
SingularErrors := "";

DeclareGlobalFunction( "CleanupSingularRings" );

DeclareGlobalFunction( "InitSingularInterpreter" );
# This is called automatically from libsingular.gi, no need for the user to call it.

DeclareOperation( "Singular", [IsStringRep] );
DeclareOperation( "Singular", [] );

