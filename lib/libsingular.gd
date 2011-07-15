# Make some types:

SingularTypes := [];

SingularFamily := NewFamily("SingularFamily");
DeclareCategory( "IsSingularRing", IsObject );
DeclareCategory( "IsSingularPoly", IsObject );

SingularTypes[SINGULAR_TYPENRS.SINGTYPE_RING] 
   := NewType(SingularFamily,IsSingularRing);
SingularTypes[SINGULAR_TYPENRS.SINGTYPE_POLY]
   := NewType(SingularFamily,IsSingularPoly);

SingularRings := [];
SingularElCounts := [];

DeclareGlobalFunction( "CleanupSingularRings" );

DeclareGlobalFunction( "InitSingularInterpreter" );
# This is called automatically from libsingular.gi, no need for the user to call it.

DeclareOperation( "Singular", [IsStringRep] );
DeclareOperation( "Singular", [] );

