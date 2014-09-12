SI_Errors := "";

DeclareGlobalFunction( "_SI_BindSingularProcs" );

DeclareGlobalFunction( "_SI_Addition" );
DeclareGlobalFunction( "_SI_Addition_fast" );
DeclareGlobalFunction( "_SI_Subtraction" );
DeclareGlobalFunction( "_SI_Negation" );
DeclareGlobalFunction( "_SI_Negation_fast" );

DeclareOperation( "Singular", [IsStringRep] );
DeclareOperation( "Singular", [IsString and IsEmpty] );
DeclareOperation( "Singular", [] );

DeclareOperation("SI_bigint",[IsSingularObj]);
DeclareOperation("SI_bigint",[IsInt]);

DeclareOperation("SI_bigintmat",[IsSingularObj]);
#DeclareOperation("SI_bigintmat",[IsSingularObj,IsPosInt,IsPosInt]);
DeclareOperation("SI_bigintmat",[IsList]);

DeclareOperation("SI_number",[IsSingularRing, IsObject]);

DeclareOperation("SI_intvec",[IsSingularObj]);
DeclareOperation("SI_intvec",[IsList]);

DeclareOperation("SI_intmat",[IsSingularObj]);
DeclareOperation("SI_intmat",[IsSingularObj,IsPosInt,IsPosInt]);
DeclareOperation("SI_intmat",[IsList]);

DeclareOperation("SI_ring",[IsSingularRing, IsSingularObj]);
DeclareOperation("SI_ring",[IsInt,IsList]);
DeclareOperation("SI_ring",[IsInt,IsList,IsList]);
# to get back associated ring
DeclareOperation("SI_ring",[IsSingularObj]);

DeclareOperation("SI_poly",[IsSingularRing, IsSingularObj]);
DeclareOperation("SI_poly",[IsSingularRing, IsStringRep]);

DeclareOperation("SI_matrix",[IsSingularObj]);
DeclareOperation("SI_matrix",[IsSingularObj,IsPosInt,IsPosInt]);
DeclareOperation("SI_matrix",[IsSingularRing, IsPosInt, IsPosInt, IsStringRep]);
DeclareOperation("SI_matrix",[IsPosInt, IsPosInt, IsList]);

DeclareOperation("SI_vector",[IsSingularObj]);
DeclareOperation("SI_vector",[IsSingularRing, IsPosInt, IsStringRep]);

DeclareOperation("SI_ZeroMat",[IsSingularRing, IsPosInt, IsPosInt]);
DeclareOperation("SI_IdentityMat",[IsSingularRing, IsPosInt]);

DeclareOperation("SI_ideal",[IsSingularObj]);
DeclareOperation("SI_ideal",[IsSingularRing, IsStringRep]);
DeclareOperation("SI_ideal",[IsList]);

DeclareOperation( "SI_Proxy", [IsSingularObj, IsPosInt] );
DeclareOperation( "SI_Proxy", [IsSingularObj, IsPosInt, IsPosInt] );
DeclareOperation( "SI_Proxy", [IsSingularObj, IsStringRep] );

DeclareGlobalFunction( "_SI_Comparer" );


# Useful little helper to undefine a Singular var or proc
BindGlobal( "SI_Undef", function(x)
   Singular(Concatenation("if(defined(",x,")){kill ",x,";};"));
end);

