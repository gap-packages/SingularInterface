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

