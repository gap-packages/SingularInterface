SI_Errors := "";

DeclareGlobalFunction( "_SI_BindSingularProcs" );

DeclareGlobalFunction( "_SI_Addition" );
DeclareGlobalFunction( "_SI_Addition_fast" );
DeclareGlobalFunction( "_SI_Subtraction" );
DeclareGlobalFunction( "_SI_Negation" );
DeclareGlobalFunction( "_SI_Negation_fast" );

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

DeclareGlobalFunction( "_SI_Comparer" );
