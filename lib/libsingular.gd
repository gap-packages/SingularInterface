# Make some types:

SingularTypes := [];

SingularFamily := NewFamily("SingularFamily");
DeclareCategory( "IsSingularRing", IsObject );
DeclareCategory( "IsSingularPoly", IsObject );

SingularTypes[SINGULAR_TYPENRS.SINGTYPE_RING] 
   := NewType(SingularFamily,IsSingularRing);
SingularTypes[SINGULAR_TYPENRS.SINGTYPE_POLY]
   := NewType(SingularFamily,IsSingularPoly);


InstallMethod( ViewObj, "for a singular ring",
  [ IsSingularRing ],
  function( r )
    Print("<singular ring>");
  end );

InstallMethod( ViewObj, "for a singular poly",
  [ IsSingularPoly ],
  function( r )
    Print("<singular polynomial>");
  end );
