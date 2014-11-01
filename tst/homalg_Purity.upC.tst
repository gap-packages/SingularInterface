gap> SI_option("notWarnSB");;
gap> if not IsBound( SIH_ZeroColumns ) then
> DeclareGlobalFunction( "SIH_ZeroColumns" );
> DeclareGlobalFunction( "SIH_ZeroRows" );
> DeclareGlobalFunction( "SIH_BasisOfColumnModule" );
> DeclareGlobalFunction( "SIH_BasisOfRowModule" );
> DeclareGlobalFunction( "SIH_BasisOfColumnsCoeff" );
> DeclareGlobalFunction( "SIH_BasisOfRowsCoeff" );
> DeclareGlobalFunction( "SIH_DecideZeroColumns" );
> DeclareGlobalFunction( "SIH_DecideZeroRows" );
> DeclareGlobalFunction( "SIH_DecideZeroColumnsEffectively" );
> DeclareGlobalFunction( "SIH_DecideZeroRowsEffectively" );
> DeclareGlobalFunction( "SIH_SyzygiesGeneratorsOfColumns" );
> DeclareGlobalFunction( "SIH_SyzygiesGeneratorsOfRows" );
> DeclareGlobalFunction( "SIH_RelativeSyzygiesGeneratorsOfColumns" );
> DeclareGlobalFunction( "SIH_RelativeSyzygiesGeneratorsOfRows" );
> DeclareGlobalFunction( "SIH_ReducedSyzygiesGeneratorsOfColumns" );
> DeclareGlobalFunction( "SIH_ReducedSyzygiesGeneratorsOfRows" );
> DeclareGlobalFunction( "SIH_Submatrix" );
> DeclareGlobalFunction( "SIH_UnionOfRows" );
> DeclareGlobalFunction( "SIH_UnionOfColumns" );
> DeclareGlobalFunction( "SIH_GetColumnIndependentUnitPositions" );
> DeclareGlobalFunction( "SIH_GetRowIndependentUnitPositions" );
> DeclareGlobalFunction( "SIH_GetUnitPosition" );
> InstallGlobalFunction( SIH_BasisOfColumnModule,
>   function( M )
>     
>     return SI_matrix( SI_std( M ) );
>     
> end );
> InstallGlobalFunction( SIH_BasisOfRowModule,
>   function( M )
>     
>     return SI_transpose( SIH_BasisOfColumnModule( SI_transpose( M ) ) );
>     
> end );
> InstallGlobalFunction( SIH_BasisOfColumnsCoeff,
>   function( M )
>     local B;
>     
>     B := SIH_BasisOfColumnModule( M );
>     
>     return [ B, SI_lift( M, B ) ];
>     
> end );
> InstallGlobalFunction( SIH_BasisOfRowsCoeff,
>   function( M )
>     
>     return List( SIH_BasisOfColumnsCoeff( SI_transpose( M ) ), SI_transpose );
>     
> end );
> InstallGlobalFunction( SIH_DecideZeroColumns,
>   function( A, B )
>     
>     return SI_matrix( SI_reduce( A, B ) );
>     
> end );
> InstallGlobalFunction( SIH_DecideZeroRows,
>   function( A, B )
>     
>     return SI_transpose( SIH_DecideZeroColumns( SI_transpose( A ), SI_transpose( B ) ) );
>     
> end );
> InstallGlobalFunction( SIH_DecideZeroColumnsEffectively,
>   function( A, B )
>     local M;
>     
>     M := SIH_DecideZeroColumns( A, B );
>     
>     return [ M, SI_lift( B, M - A ) ];
>     
> end );
> InstallGlobalFunction( SIH_DecideZeroRowsEffectively,
>   function( A, B )
>     
>     return List( SIH_DecideZeroColumnsEffectively( SI_transpose( A ), SI_transpose( B ) ), SI_transpose );
>     
> end );
> InstallGlobalFunction( SIH_SyzygiesGeneratorsOfColumns,
>   function( M )
>     
>     return SI_matrix( SI_syz( M ) );
>     
> end );
> InstallGlobalFunction( SIH_SyzygiesGeneratorsOfRows,
>   function( M )
>     
>     return SI_transpose( SIH_SyzygiesGeneratorsOfColumns( SI_transpose( M ) ) );
>     
> end );
> InstallGlobalFunction( SIH_RelativeSyzygiesGeneratorsOfColumns,
>   function( M, M2 )
>     
>     return SIH_BasisOfColumnModule( SI_modulo( M, M2 ) );
>     
> end );
> InstallGlobalFunction( SIH_RelativeSyzygiesGeneratorsOfRows,
>   function( M, M2 )
>     
>     return SI_transpose( SIH_RelativeSyzygiesGeneratorsOfColumns( SI_transpose( M ), SI_transpose( M2 ) ) );
>     
> end );
> InstallGlobalFunction( SIH_ReducedSyzygiesGeneratorsOfColumns,
>   function( M )
>     
>     return SI_nres( M, 2 )[2];
>     
> end );
> InstallGlobalFunction( SIH_ReducedSyzygiesGeneratorsOfRows,
>   function( M )
>     
>     return SI_transpose( SIH_ReducedSyzygiesGeneratorsOfColumns( SI_transpose( M ) ) );
>     
> end );
> InstallGlobalFunction( SIH_ZeroColumns,
>   function( M )
>     local zero;
>     
>     M := SI_module( M );
>     
>     zero := M[0];
>     
>     ##FIXME: should become: return Filtered( M, IsZero );
>     return Filtered( [ 1 .. SI_ncols( M ) ], i -> SI_\=\=( M[i], zero ) = 1 );
>     
> end );
> InstallGlobalFunction( SIH_ZeroRows,
>   function( M )
>     
>     return SIH_ZeroColumns( SI_transpose( M ) );
>     
> end );
> InstallGlobalFunction( SIH_Submatrix,
>   function( M, row_range, col_range )
>     local N;
>     
>     N := Flat( List( row_range, r -> List( col_range, c -> SI_\[( M, r, c ) ) ) );
>     
>     return SI_matrix( Length( row_range ), Length( col_range ), N );
>     
> end );
> InstallGlobalFunction( SIH_UnionOfRows,
>   function( M, N )
>     local rM, cM, rN;
>     
>     rM := SI_nrows( M );
>     cM := SI_ncols( M );
>     rN := SI_nrows( N );
>     
>     M := List( [ 1 .. rM ], r -> List( [ 1 .. cM ], c -> SI_\[( M, r, c ) ) );
>     N := List( [ 1 .. rN ], r -> List( [ 1 .. cM ], c -> SI_\[( N, r, c ) ) );
>     
>     return SI_matrix( rM + rN, cM, Flat( Concatenation( M, N ) ) );
>     
> end );
> InstallGlobalFunction( SIH_UnionOfColumns,
>   function( M, N )
>     local rM, cM, cN;
>     
>     rM := SI_nrows( M );
>     cM := SI_ncols( M );
>     cN := SI_ncols( N );
>     
>     M := List( [ 1 .. rM ], r -> List( [ 1 .. cM ], c -> SI_\[( M, r, c ) ) );
>     N := List( [ 1 .. rM ], r -> List( [ 1 .. cN ], c -> SI_\[( N, r, c ) ) );
>     
>     return
>       SI_matrix( rM, cM + cN,
>               Flat( ListN( M, N,
>                       function( r1, r2 ) return Flat( Concatenation( r1, r2 ) ); end
>                         ) ) );
>     
> end );
> InstallGlobalFunction( SIH_GetColumnIndependentUnitPositions,
>   function( M, poslist )
>     local R, rest, pos, i, j, k;
>     
>     R := SI_ring( M );
>     
>     rest := [ 1 .. SI_ncols( M ) ];
>     
>     pos := [ ];
>     
>     for i in [ 1 .. SI_nrows( M ) ] do
>         for k in Reversed( rest ) do
>             if not [ i, k ] in poslist and
>                ##FIXME: IsUnit( R, MatElm( M, i, k ) ) then
>                SI_deg( SI_\[( M, i, k ) ) = 0 then
>                 Add( pos, [ i, k ] );
>                 rest := Filtered( rest,
>                                 a -> IsZero( SI_\[( M, i, a ) ) );
>                 break;
>             fi;
>         od;
>     od;
>     
>     ##FIXME:
>     #if pos <> [ ] then
>     #    SetIsZero( M, false );
>     #fi;
>     
>     return pos;
>     
> end );
> InstallGlobalFunction( SIH_GetRowIndependentUnitPositions,
>   function( M, poslist )
>     local R, rest, pos, j, i, k;
>     
>     R := SI_ring( M );
>     
>     rest := [ 1 .. SI_nrows( M ) ];
>     
>     pos := [ ];
>     
>     for j in [ 1 .. SI_ncols( M ) ] do
>         for k in Reversed( rest ) do
>             if not [ j, k ] in poslist and
>                ##FIXME: IsUnit( R, MatElm( M, k, j ) ) then
>                SI_deg( SI_\[( M, k, j ) ) = 0 then
>                 Add( pos, [ j, k ] );
>                 rest := Filtered( rest,
>                                 a -> IsZero( SI_\[( M, a, j ) ) );
>                 break;
>             fi;
>         od;
>     od;
>     
>     ##FIXME:
>     #if pos <> [ ] then
>     #    SetIsZero( M, false );
>     #fi;
>     
>     return pos;
>     
> end );
> InstallGlobalFunction( SIH_GetUnitPosition,
>   function( M, poslist )
>     local R, pos, m, n, i, j;
>     
>     R := SI_ring( M );
>     
>     m := SI_ncols( M );
>     n := SI_nrows( M );
>     
>     for i in [ 1 .. m ] do
>         for j in [ 1 .. n ] do
>             if not [ i, j ] in poslist and not j in poslist and
>                ##FIXME: IsUnit( R, SI_\[( M, j, i ) ) then
>                SI_deg( SI_\[( M, j, i ) ) = 0 then
>                 ##FIXME: SetIsZero( M, false );
>                 return [ i, j ];
>             fi;
>         od;
>     od;
>     
>     return fail;
>     
> end );
> fi;
gap> homalg_variable_1 := SI_ring(0,["dummy_variable"],[["dp",1],["C",0]]);;
gap> homalg_variable_2 := Zero(homalg_variable_1);;
gap> homalg_variable_3 := One(homalg_variable_1);;
gap> homalg_variable_4 := -One(homalg_variable_1);;
gap> homalg_variable_5 := SI_ring(0,[ "x", "y", "z" ],[["dp",3],["C",0]]);;
gap> homalg_variable_6 := Zero(homalg_variable_5);;
gap> homalg_variable_7 := One(homalg_variable_5);;
gap> homalg_variable_8 := -One(homalg_variable_5);;
gap> homalg_variable_9 := SI_transpose(SI_matrix(homalg_variable_5,6,5,"xy,yz,z,0,0,x3z,x2z2,0,xz2,-z2,x4,x3z,0,x2z,-xz,0,0,xy,-y2,x2-1,0,0,x2z,-xyz,yz,0,0,x2y-x2,-xy2+xy,y2-y"));;
gap> homalg_variable_10 := SIH_BasisOfColumnModule(homalg_variable_9);;
gap> SI_ncols(homalg_variable_10);
6
gap> homalg_variable_11 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_10 = homalg_variable_11;
false
gap> homalg_variable_10 = homalg_variable_9;
false
gap> homalg_variable_12 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_10);;
gap> SI_ncols(homalg_variable_12);
4
gap> homalg_variable_13 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_12 = homalg_variable_13;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_12,[ 0 ]);
[  ]
gap> homalg_variable_15 := SI_transpose(homalg_variable_10);;
gap> homalg_variable_14 := SIH_BasisOfRowModule(homalg_variable_15);;
gap> SI_nrows(homalg_variable_14);
6
gap> homalg_variable_16 := SI_matrix(homalg_variable_5,6,5,"0");;
gap> homalg_variable_14 = homalg_variable_16;
false
gap> homalg_variable_14 = homalg_variable_15;
true
gap> homalg_variable_18 := SI_matrix(SI_freemodule(homalg_variable_5,5));;
gap> homalg_variable_17 := SIH_DecideZeroRows(homalg_variable_18,homalg_variable_14);;
gap> homalg_variable_19 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_17 = homalg_variable_19;
false
gap> SIH_ZeroRows(homalg_variable_17);
[  ]
gap> homalg_variable_17 = homalg_variable_18;
true
gap> homalg_variable_20 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_14);;
gap> SI_nrows(homalg_variable_20);
4
gap> homalg_variable_21 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_20 = homalg_variable_21;
false
gap> SIH_GetColumnIndependentUnitPositions(homalg_variable_20,[ 0 ]);
[  ]
gap> homalg_variable_22 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_10);;
gap> SI_nrows(homalg_variable_22);
2
gap> homalg_variable_23 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_22 = homalg_variable_23;
false
gap> homalg_variable_24 := homalg_variable_22 * homalg_variable_10;;
gap> homalg_variable_25 := SI_matrix(homalg_variable_5,2,6,"0");;
gap> homalg_variable_24 = homalg_variable_25;
true
gap> homalg_variable_26 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_22);;
gap> SI_ncols(homalg_variable_26);
4
gap> homalg_variable_27 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_26 = homalg_variable_27;
false
gap> homalg_variable_28 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_26);;
gap> SI_ncols(homalg_variable_28);
1
gap> homalg_variable_29 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_28 = homalg_variable_29;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_28,[ 0 ]);
[  ]
gap> homalg_variable_30 := SIH_BasisOfColumnModule(homalg_variable_26);;
gap> SI_ncols(homalg_variable_30);
4
gap> homalg_variable_31 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_30 = homalg_variable_31;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_26);; homalg_variable_32 := homalg_variable_l[1];; homalg_variable_33 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_32);
4
gap> homalg_variable_34 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_32 = homalg_variable_34;
false
gap> SI_nrows(homalg_variable_33);
4
gap> homalg_variable_35 := homalg_variable_26 * homalg_variable_33;;
gap> homalg_variable_32 = homalg_variable_35;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_30,homalg_variable_32);; homalg_variable_36 := homalg_variable_l[1];; homalg_variable_37 := homalg_variable_l[2];;
gap> homalg_variable_38 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_36 = homalg_variable_38;
true
gap> homalg_variable_39 := homalg_variable_32 * homalg_variable_37;;
gap> homalg_variable_40 := homalg_variable_30 + homalg_variable_39;;
gap> homalg_variable_36 = homalg_variable_40;
true
gap> homalg_variable_41 := SIH_DecideZeroColumns(homalg_variable_30,homalg_variable_32);;
gap> homalg_variable_42 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_41 = homalg_variable_42;
true
gap> homalg_variable_43 := homalg_variable_37 * (homalg_variable_8);;
gap> homalg_variable_44 := homalg_variable_33 * homalg_variable_43;;
gap> homalg_variable_45 := homalg_variable_26 * homalg_variable_44;;
gap> homalg_variable_45 = homalg_variable_30;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_26,homalg_variable_30);; homalg_variable_46 := homalg_variable_l[1];; homalg_variable_47 := homalg_variable_l[2];;
gap> homalg_variable_48 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_46 = homalg_variable_48;
true
gap> homalg_variable_49 := homalg_variable_30 * homalg_variable_47;;
gap> homalg_variable_50 := homalg_variable_26 + homalg_variable_49;;
gap> homalg_variable_46 = homalg_variable_50;
true
gap> homalg_variable_51 := SIH_DecideZeroColumns(homalg_variable_26,homalg_variable_30);;
gap> homalg_variable_52 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_51 = homalg_variable_52;
true
gap> homalg_variable_53 := homalg_variable_47 * (homalg_variable_8);;
gap> homalg_variable_54 := homalg_variable_30 * homalg_variable_53;;
gap> homalg_variable_54 = homalg_variable_26;
true
gap> homalg_variable_55 := SIH_DecideZeroColumns(homalg_variable_26,homalg_variable_10);;
gap> homalg_variable_56 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_55 = homalg_variable_56;
false
gap> SIH_ZeroColumns(homalg_variable_55);
[ 3 ]
gap> homalg_variable_58 := SIH_Submatrix(homalg_variable_55,[1..5],[ 1, 2, 4 ]);;
gap> homalg_variable_57 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_58,homalg_variable_10);;
gap> SI_ncols(homalg_variable_57);
6
gap> homalg_variable_59 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_57 = homalg_variable_59;
false
gap> homalg_variable_61 := homalg_variable_58 * homalg_variable_57;;
gap> homalg_variable_60 := SIH_DecideZeroColumns(homalg_variable_61,homalg_variable_10);;
gap> homalg_variable_62 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_60 = homalg_variable_62;
true
gap> homalg_variable_63 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_58,homalg_variable_10);;
gap> SI_ncols(homalg_variable_63);
6
gap> homalg_variable_64 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_63 = homalg_variable_64;
false
gap> homalg_variable_65 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_63);;
gap> SI_ncols(homalg_variable_65);
4
gap> homalg_variable_66 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_65 = homalg_variable_66;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_65,[ 0 ]);
[  ]
gap> homalg_variable_67 := SIH_BasisOfColumnModule(homalg_variable_63);;
gap> SI_ncols(homalg_variable_67);
6
gap> homalg_variable_68 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_67 = homalg_variable_68;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_63);; homalg_variable_69 := homalg_variable_l[1];; homalg_variable_70 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_69);
6
gap> homalg_variable_71 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_69 = homalg_variable_71;
false
gap> SI_nrows(homalg_variable_70);
6
gap> homalg_variable_72 := homalg_variable_63 * homalg_variable_70;;
gap> homalg_variable_69 = homalg_variable_72;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_67,homalg_variable_69);; homalg_variable_73 := homalg_variable_l[1];; homalg_variable_74 := homalg_variable_l[2];;
gap> homalg_variable_75 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_73 = homalg_variable_75;
true
gap> homalg_variable_76 := homalg_variable_69 * homalg_variable_74;;
gap> homalg_variable_77 := homalg_variable_67 + homalg_variable_76;;
gap> homalg_variable_73 = homalg_variable_77;
true
gap> homalg_variable_78 := SIH_DecideZeroColumns(homalg_variable_67,homalg_variable_69);;
gap> homalg_variable_79 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_78 = homalg_variable_79;
true
gap> homalg_variable_80 := homalg_variable_74 * (homalg_variable_8);;
gap> homalg_variable_81 := homalg_variable_70 * homalg_variable_80;;
gap> homalg_variable_82 := homalg_variable_63 * homalg_variable_81;;
gap> homalg_variable_82 = homalg_variable_67;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_63,homalg_variable_67);; homalg_variable_83 := homalg_variable_l[1];; homalg_variable_84 := homalg_variable_l[2];;
gap> homalg_variable_85 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_83 = homalg_variable_85;
true
gap> homalg_variable_86 := homalg_variable_67 * homalg_variable_84;;
gap> homalg_variable_87 := homalg_variable_63 + homalg_variable_86;;
gap> homalg_variable_83 = homalg_variable_87;
true
gap> homalg_variable_88 := SIH_DecideZeroColumns(homalg_variable_63,homalg_variable_67);;
gap> homalg_variable_89 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_88 = homalg_variable_89;
true
gap> homalg_variable_90 := homalg_variable_84 * (homalg_variable_8);;
gap> homalg_variable_91 := homalg_variable_67 * homalg_variable_90;;
gap> homalg_variable_91 = homalg_variable_63;
true
gap> homalg_variable_92 := SIH_BasisOfColumnModule(homalg_variable_57);;
gap> SI_ncols(homalg_variable_92);
6
gap> homalg_variable_93 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_92 = homalg_variable_93;
false
gap> homalg_variable_92 = homalg_variable_57;
true
gap> homalg_variable_94 := SIH_DecideZeroColumns(homalg_variable_63,homalg_variable_92);;
gap> homalg_variable_95 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_94 = homalg_variable_95;
true
gap> homalg_variable_96 := SI_transpose(SI_matrix(homalg_variable_5,5,5,"x2+y-z,xz-z,0,z,-z,x-1,x+y-1,-y,-1,0,x3+y,x2z+y,x2+y2+y,-xy+xz+y,xy-z,x,x,x,y2+x,1,0,0,-xy,y2,1"));;
gap> homalg_variable_97 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_12);;
gap> SI_ncols(homalg_variable_97);
1
gap> homalg_variable_98 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_97 = homalg_variable_98;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_97,[ 0 ]);
[  ]
gap> homalg_variable_99 := SIH_BasisOfColumnModule(homalg_variable_12);;
gap> SI_ncols(homalg_variable_99);
4
gap> homalg_variable_100 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_99 = homalg_variable_100;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_12);; homalg_variable_101 := homalg_variable_l[1];; homalg_variable_102 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_101);
4
gap> homalg_variable_103 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_101 = homalg_variable_103;
false
gap> SI_nrows(homalg_variable_102);
4
gap> homalg_variable_104 := homalg_variable_12 * homalg_variable_102;;
gap> homalg_variable_101 = homalg_variable_104;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_99,homalg_variable_101);; homalg_variable_105 := homalg_variable_l[1];; homalg_variable_106 := homalg_variable_l[2];;
gap> homalg_variable_107 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_105 = homalg_variable_107;
true
gap> homalg_variable_108 := homalg_variable_101 * homalg_variable_106;;
gap> homalg_variable_109 := homalg_variable_99 + homalg_variable_108;;
gap> homalg_variable_105 = homalg_variable_109;
true
gap> homalg_variable_110 := SIH_DecideZeroColumns(homalg_variable_99,homalg_variable_101);;
gap> homalg_variable_111 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_110 = homalg_variable_111;
true
gap> homalg_variable_112 := homalg_variable_106 * (homalg_variable_8);;
gap> homalg_variable_113 := homalg_variable_102 * homalg_variable_112;;
gap> homalg_variable_114 := homalg_variable_12 * homalg_variable_113;;
gap> homalg_variable_114 = homalg_variable_99;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_12,homalg_variable_99);; homalg_variable_115 := homalg_variable_l[1];; homalg_variable_116 := homalg_variable_l[2];;
gap> homalg_variable_117 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_115 = homalg_variable_117;
true
gap> homalg_variable_118 := homalg_variable_99 * homalg_variable_116;;
gap> homalg_variable_119 := homalg_variable_12 + homalg_variable_118;;
gap> homalg_variable_115 = homalg_variable_119;
true
gap> homalg_variable_120 := SIH_DecideZeroColumns(homalg_variable_12,homalg_variable_99);;
gap> homalg_variable_121 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_120 = homalg_variable_121;
true
gap> homalg_variable_122 := homalg_variable_116 * (homalg_variable_8);;
gap> homalg_variable_123 := homalg_variable_99 * homalg_variable_122;;
gap> homalg_variable_123 = homalg_variable_12;
true
gap> homalg_variable_124 := SIH_BasisOfColumnModule(homalg_variable_97);;
gap> SI_ncols(homalg_variable_124);
1
gap> homalg_variable_125 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_124 = homalg_variable_125;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_97);; homalg_variable_126 := homalg_variable_l[1];; homalg_variable_127 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_126);
1
gap> homalg_variable_128 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_126 = homalg_variable_128;
false
gap> SI_nrows(homalg_variable_127);
1
gap> homalg_variable_129 := homalg_variable_97 * homalg_variable_127;;
gap> homalg_variable_126 = homalg_variable_129;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_124,homalg_variable_126);; homalg_variable_130 := homalg_variable_l[1];; homalg_variable_131 := homalg_variable_l[2];;
gap> homalg_variable_132 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_130 = homalg_variable_132;
true
gap> homalg_variable_133 := homalg_variable_126 * homalg_variable_131;;
gap> homalg_variable_134 := homalg_variable_124 + homalg_variable_133;;
gap> homalg_variable_130 = homalg_variable_134;
true
gap> homalg_variable_135 := SIH_DecideZeroColumns(homalg_variable_124,homalg_variable_126);;
gap> homalg_variable_136 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_135 = homalg_variable_136;
true
gap> homalg_variable_137 := homalg_variable_131 * (homalg_variable_8);;
gap> homalg_variable_138 := homalg_variable_127 * homalg_variable_137;;
gap> homalg_variable_139 := homalg_variable_97 * homalg_variable_138;;
gap> homalg_variable_139 = homalg_variable_124;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_97,homalg_variable_124);; homalg_variable_140 := homalg_variable_l[1];; homalg_variable_141 := homalg_variable_l[2];;
gap> homalg_variable_142 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_140 = homalg_variable_142;
true
gap> homalg_variable_143 := homalg_variable_124 * homalg_variable_141;;
gap> homalg_variable_144 := homalg_variable_97 + homalg_variable_143;;
gap> homalg_variable_140 = homalg_variable_144;
true
gap> homalg_variable_145 := SIH_DecideZeroColumns(homalg_variable_97,homalg_variable_124);;
gap> homalg_variable_146 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_145 = homalg_variable_146;
true
gap> homalg_variable_147 := homalg_variable_141 * (homalg_variable_8);;
gap> homalg_variable_148 := homalg_variable_124 * homalg_variable_147;;
gap> homalg_variable_148 = homalg_variable_97;
true
gap> homalg_variable_149 := homalg_variable_10 * homalg_variable_12;;
gap> homalg_variable_150 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_149 = homalg_variable_150;
true
gap> homalg_variable_151 := homalg_variable_12 * homalg_variable_97;;
gap> homalg_variable_152 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_151 = homalg_variable_152;
true
gap> homalg_variable_99 = homalg_variable_12;
true
gap> homalg_variable_153 := SIH_DecideZeroColumns(homalg_variable_12,homalg_variable_99);;
gap> homalg_variable_154 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_153 = homalg_variable_154;
true
gap> homalg_variable_124 = homalg_variable_97;
true
gap> homalg_variable_155 := SIH_DecideZeroColumns(homalg_variable_97,homalg_variable_124);;
gap> homalg_variable_156 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_155 = homalg_variable_156;
true
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_97);; homalg_variable_157 := homalg_variable_l[1];; homalg_variable_158 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_157);
3
gap> homalg_variable_159 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_157 = homalg_variable_159;
false
gap> SI_ncols(homalg_variable_158);
4
gap> homalg_variable_160 := homalg_variable_158 * homalg_variable_97;;
gap> homalg_variable_157 = homalg_variable_160;
true
gap> homalg_variable_161 := SI_matrix(SI_freemodule(homalg_variable_5,1));;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_161,homalg_variable_157);; homalg_variable_162 := homalg_variable_l[1];; homalg_variable_163 := homalg_variable_l[2];;
gap> homalg_variable_164 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_162 = homalg_variable_164;
false
gap> homalg_variable_165 := homalg_variable_163 * homalg_variable_157;;
gap> homalg_variable_166 := homalg_variable_161 + homalg_variable_165;;
gap> homalg_variable_162 = homalg_variable_166;
true
gap> homalg_variable_167 := SIH_DecideZeroRows(homalg_variable_161,homalg_variable_157);;
gap> homalg_variable_168 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_167 = homalg_variable_168;
false
gap> homalg_variable_162 = homalg_variable_167;
true
gap> homalg_variable_169 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_22);;
gap> SI_nrows(homalg_variable_169);
1
gap> homalg_variable_170 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_169 = homalg_variable_170;
true
gap> homalg_variable_171 := SIH_BasisOfRowModule(homalg_variable_22);;
gap> SI_nrows(homalg_variable_171);
2
gap> homalg_variable_172 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_171 = homalg_variable_172;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_22);; homalg_variable_173 := homalg_variable_l[1];; homalg_variable_174 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_173);
2
gap> homalg_variable_175 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_173 = homalg_variable_175;
false
gap> SI_ncols(homalg_variable_174);
2
gap> homalg_variable_176 := homalg_variable_174 * homalg_variable_22;;
gap> homalg_variable_173 = homalg_variable_176;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_171,homalg_variable_173);; homalg_variable_177 := homalg_variable_l[1];; homalg_variable_178 := homalg_variable_l[2];;
gap> homalg_variable_179 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_177 = homalg_variable_179;
true
gap> homalg_variable_180 := homalg_variable_178 * homalg_variable_173;;
gap> homalg_variable_181 := homalg_variable_171 + homalg_variable_180;;
gap> homalg_variable_177 = homalg_variable_181;
true
gap> homalg_variable_182 := SIH_DecideZeroRows(homalg_variable_171,homalg_variable_173);;
gap> homalg_variable_183 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_182 = homalg_variable_183;
true
gap> homalg_variable_184 := homalg_variable_178 * (homalg_variable_8);;
gap> homalg_variable_185 := homalg_variable_184 * homalg_variable_174;;
gap> homalg_variable_186 := homalg_variable_185 * homalg_variable_22;;
gap> homalg_variable_186 = homalg_variable_171;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_22,homalg_variable_171);; homalg_variable_187 := homalg_variable_l[1];; homalg_variable_188 := homalg_variable_l[2];;
gap> homalg_variable_189 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_187 = homalg_variable_189;
true
gap> homalg_variable_190 := homalg_variable_188 * homalg_variable_171;;
gap> homalg_variable_191 := homalg_variable_22 + homalg_variable_190;;
gap> homalg_variable_187 = homalg_variable_191;
true
gap> homalg_variable_192 := SIH_DecideZeroRows(homalg_variable_22,homalg_variable_171);;
gap> homalg_variable_193 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_192 = homalg_variable_193;
true
gap> homalg_variable_194 := homalg_variable_188 * (homalg_variable_8);;
gap> homalg_variable_195 := homalg_variable_194 * homalg_variable_171;;
gap> homalg_variable_195 = homalg_variable_22;
true
gap> SIH_ZeroRows(homalg_variable_22);
[  ]
gap> homalg_variable_196 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_12);;
gap> SI_nrows(homalg_variable_196);
4
gap> homalg_variable_197 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_196 = homalg_variable_197;
false
gap> homalg_variable_198 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_196);;
gap> SI_nrows(homalg_variable_198);
1
gap> homalg_variable_199 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_198 = homalg_variable_199;
false
gap> SIH_GetColumnIndependentUnitPositions(homalg_variable_198,[ 0 ]);
[  ]
gap> homalg_variable_200 := SIH_BasisOfRowModule(homalg_variable_196);;
gap> SI_nrows(homalg_variable_200);
4
gap> homalg_variable_201 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_200 = homalg_variable_201;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_196);; homalg_variable_202 := homalg_variable_l[1];; homalg_variable_203 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_202);
4
gap> homalg_variable_204 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_202 = homalg_variable_204;
false
gap> SI_ncols(homalg_variable_203);
4
gap> homalg_variable_205 := homalg_variable_203 * homalg_variable_196;;
gap> homalg_variable_202 = homalg_variable_205;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_200,homalg_variable_202);; homalg_variable_206 := homalg_variable_l[1];; homalg_variable_207 := homalg_variable_l[2];;
gap> homalg_variable_208 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_206 = homalg_variable_208;
true
gap> homalg_variable_209 := homalg_variable_207 * homalg_variable_202;;
gap> homalg_variable_210 := homalg_variable_200 + homalg_variable_209;;
gap> homalg_variable_206 = homalg_variable_210;
true
gap> homalg_variable_211 := SIH_DecideZeroRows(homalg_variable_200,homalg_variable_202);;
gap> homalg_variable_212 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_211 = homalg_variable_212;
true
gap> homalg_variable_213 := homalg_variable_207 * (homalg_variable_8);;
gap> homalg_variable_214 := homalg_variable_213 * homalg_variable_203;;
gap> homalg_variable_215 := homalg_variable_214 * homalg_variable_196;;
gap> homalg_variable_215 = homalg_variable_200;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_196,homalg_variable_200);; homalg_variable_216 := homalg_variable_l[1];; homalg_variable_217 := homalg_variable_l[2];;
gap> homalg_variable_218 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_216 = homalg_variable_218;
true
gap> homalg_variable_219 := homalg_variable_217 * homalg_variable_200;;
gap> homalg_variable_220 := homalg_variable_196 + homalg_variable_219;;
gap> homalg_variable_216 = homalg_variable_220;
true
gap> homalg_variable_221 := SIH_DecideZeroRows(homalg_variable_196,homalg_variable_200);;
gap> homalg_variable_222 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_221 = homalg_variable_222;
true
gap> homalg_variable_223 := homalg_variable_217 * (homalg_variable_8);;
gap> homalg_variable_224 := homalg_variable_223 * homalg_variable_200;;
gap> homalg_variable_224 = homalg_variable_196;
true
gap> homalg_variable_225 := SIH_BasisOfRowModule(homalg_variable_10);;
gap> SI_nrows(homalg_variable_225);
5
gap> homalg_variable_226 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_225 = homalg_variable_226;
false
gap> homalg_variable_225 = homalg_variable_10;
false
gap> homalg_variable_227 := SIH_DecideZeroRows(homalg_variable_196,homalg_variable_225);;
gap> homalg_variable_228 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_227 = homalg_variable_228;
false
gap> SIH_ZeroRows(homalg_variable_227);
[  ]
gap> homalg_variable_229 := SIH_RelativeSyzygiesGeneratorsOfRows(homalg_variable_227,homalg_variable_225);;
gap> SI_nrows(homalg_variable_229);
7
gap> homalg_variable_230 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_229 = homalg_variable_230;
false
gap> homalg_variable_232 := homalg_variable_229 * homalg_variable_227;;
gap> homalg_variable_231 := SIH_DecideZeroRows(homalg_variable_232,homalg_variable_225);;
gap> homalg_variable_233 := SI_matrix(homalg_variable_5,7,6,"0");;
gap> homalg_variable_231 = homalg_variable_233;
true
gap> homalg_variable_234 := SIH_RelativeSyzygiesGeneratorsOfRows(homalg_variable_227,homalg_variable_225);;
gap> SI_nrows(homalg_variable_234);
7
gap> homalg_variable_235 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_234 = homalg_variable_235;
false
gap> homalg_variable_236 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_234);;
gap> SI_nrows(homalg_variable_236);
3
gap> homalg_variable_237 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_236 = homalg_variable_237;
false
gap> SIH_GetColumnIndependentUnitPositions(homalg_variable_236,[ 0 ]);
[ [ 2, 7 ], [ 3, 2 ] ]
gap> homalg_variable_239 := SIH_Submatrix(homalg_variable_234,[ 1, 3, 4, 5, 6 ],[1..4]);;
gap> homalg_variable_238 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_239);;
gap> SI_nrows(homalg_variable_238);
1
gap> homalg_variable_240 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_238 = homalg_variable_240;
false
gap> SIH_GetColumnIndependentUnitPositions(homalg_variable_238,[ 0 ]);
[  ]
gap> homalg_variable_241 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_239 = homalg_variable_241;
false
gap> homalg_variable_242 := SIH_BasisOfRowModule(homalg_variable_234);;
gap> SI_nrows(homalg_variable_242);
7
gap> homalg_variable_243 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_242 = homalg_variable_243;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_239);; homalg_variable_244 := homalg_variable_l[1];; homalg_variable_245 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_244);
7
gap> homalg_variable_246 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_244 = homalg_variable_246;
false
gap> SI_ncols(homalg_variable_245);
5
gap> homalg_variable_247 := homalg_variable_245 * homalg_variable_239;;
gap> homalg_variable_244 = homalg_variable_247;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_242,homalg_variable_244);; homalg_variable_248 := homalg_variable_l[1];; homalg_variable_249 := homalg_variable_l[2];;
gap> homalg_variable_250 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_248 = homalg_variable_250;
true
gap> homalg_variable_251 := homalg_variable_249 * homalg_variable_244;;
gap> homalg_variable_252 := homalg_variable_242 + homalg_variable_251;;
gap> homalg_variable_248 = homalg_variable_252;
true
gap> homalg_variable_253 := SIH_DecideZeroRows(homalg_variable_242,homalg_variable_244);;
gap> homalg_variable_254 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_253 = homalg_variable_254;
true
gap> homalg_variable_255 := homalg_variable_249 * (homalg_variable_8);;
gap> homalg_variable_256 := homalg_variable_255 * homalg_variable_245;;
gap> homalg_variable_257 := homalg_variable_256 * homalg_variable_239;;
gap> homalg_variable_257 = homalg_variable_242;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_239,homalg_variable_242);; homalg_variable_258 := homalg_variable_l[1];; homalg_variable_259 := homalg_variable_l[2];;
gap> homalg_variable_260 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_258 = homalg_variable_260;
true
gap> homalg_variable_261 := homalg_variable_259 * homalg_variable_242;;
gap> homalg_variable_262 := homalg_variable_239 + homalg_variable_261;;
gap> homalg_variable_258 = homalg_variable_262;
true
gap> homalg_variable_263 := SIH_DecideZeroRows(homalg_variable_239,homalg_variable_242);;
gap> homalg_variable_264 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_263 = homalg_variable_264;
true
gap> homalg_variable_265 := homalg_variable_259 * (homalg_variable_8);;
gap> homalg_variable_266 := homalg_variable_265 * homalg_variable_242;;
gap> homalg_variable_266 = homalg_variable_239;
true
gap> homalg_variable_267 := SIH_BasisOfRowModule(homalg_variable_229);;
gap> SI_nrows(homalg_variable_267);
7
gap> homalg_variable_268 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_267 = homalg_variable_268;
false
gap> homalg_variable_267 = homalg_variable_229;
true
gap> homalg_variable_269 := SIH_DecideZeroRows(homalg_variable_239,homalg_variable_267);;
gap> homalg_variable_270 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_269 = homalg_variable_270;
true
gap> homalg_variable_271 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_97);;
gap> SI_nrows(homalg_variable_271);
4
gap> homalg_variable_272 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_271 = homalg_variable_272;
false
gap> homalg_variable_273 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_271);;
gap> SI_nrows(homalg_variable_273);
1
gap> homalg_variable_274 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_273 = homalg_variable_274;
false
gap> SIH_GetColumnIndependentUnitPositions(homalg_variable_273,[ 0 ]);
[  ]
gap> homalg_variable_275 := SIH_BasisOfRowModule(homalg_variable_271);;
gap> SI_nrows(homalg_variable_275);
4
gap> homalg_variable_276 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_275 = homalg_variable_276;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_271);; homalg_variable_277 := homalg_variable_l[1];; homalg_variable_278 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_277);
4
gap> homalg_variable_279 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_277 = homalg_variable_279;
false
gap> SI_ncols(homalg_variable_278);
4
gap> homalg_variable_280 := homalg_variable_278 * homalg_variable_271;;
gap> homalg_variable_277 = homalg_variable_280;
true
gap> homalg_variable_281 := SI_matrix(SI_freemodule(homalg_variable_5,4));;
gap> homalg_variable_277 = homalg_variable_281;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_275,homalg_variable_277);; homalg_variable_282 := homalg_variable_l[1];; homalg_variable_283 := homalg_variable_l[2];;
gap> homalg_variable_284 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_282 = homalg_variable_284;
true
gap> homalg_variable_285 := homalg_variable_283 * homalg_variable_277;;
gap> homalg_variable_286 := homalg_variable_275 + homalg_variable_285;;
gap> homalg_variable_282 = homalg_variable_286;
true
gap> homalg_variable_287 := SIH_DecideZeroRows(homalg_variable_275,homalg_variable_277);;
gap> homalg_variable_288 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_287 = homalg_variable_288;
true
gap> homalg_variable_289 := homalg_variable_283 * (homalg_variable_8);;
gap> homalg_variable_290 := homalg_variable_289 * homalg_variable_278;;
gap> homalg_variable_291 := homalg_variable_290 * homalg_variable_271;;
gap> homalg_variable_291 = homalg_variable_275;
true
gap> homalg_variable_275 = homalg_variable_281;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_271,homalg_variable_275);; homalg_variable_292 := homalg_variable_l[1];; homalg_variable_293 := homalg_variable_l[2];;
gap> homalg_variable_294 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_292 = homalg_variable_294;
true
gap> homalg_variable_295 := homalg_variable_293 * homalg_variable_275;;
gap> homalg_variable_296 := homalg_variable_271 + homalg_variable_295;;
gap> homalg_variable_292 = homalg_variable_296;
true
gap> homalg_variable_297 := SIH_DecideZeroRows(homalg_variable_271,homalg_variable_275);;
gap> homalg_variable_298 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_297 = homalg_variable_298;
true
gap> homalg_variable_299 := homalg_variable_293 * (homalg_variable_8);;
gap> homalg_variable_300 := homalg_variable_299 * homalg_variable_275;;
gap> homalg_variable_300 = homalg_variable_271;
true
gap> homalg_variable_301 := SIH_BasisOfRowModule(homalg_variable_12);;
gap> SI_nrows(homalg_variable_301);
6
gap> homalg_variable_302 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_301 = homalg_variable_302;
false
gap> homalg_variable_301 = homalg_variable_12;
false
gap> homalg_variable_303 := SIH_DecideZeroRows(homalg_variable_271,homalg_variable_301);;
gap> homalg_variable_304 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_303 = homalg_variable_304;
false
gap> SIH_ZeroRows(homalg_variable_303);
[ 2, 3 ]
gap> homalg_variable_306 := SIH_Submatrix(homalg_variable_303,[ 1, 4 ],[1..4]);;
gap> homalg_variable_305 := SIH_RelativeSyzygiesGeneratorsOfRows(homalg_variable_306,homalg_variable_301);;
gap> SI_nrows(homalg_variable_305);
5
gap> homalg_variable_307 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_305 = homalg_variable_307;
false
gap> homalg_variable_309 := homalg_variable_305 * homalg_variable_306;;
gap> homalg_variable_308 := SIH_DecideZeroRows(homalg_variable_309,homalg_variable_301);;
gap> homalg_variable_310 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_308 = homalg_variable_310;
true
gap> homalg_variable_311 := SIH_RelativeSyzygiesGeneratorsOfRows(homalg_variable_306,homalg_variable_301);;
gap> SI_nrows(homalg_variable_311);
5
gap> homalg_variable_312 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_311 = homalg_variable_312;
false
gap> homalg_variable_313 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_311);;
gap> SI_nrows(homalg_variable_313);
4
gap> homalg_variable_314 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_313 = homalg_variable_314;
false
gap> SIH_GetColumnIndependentUnitPositions(homalg_variable_313,[ 0 ]);
[ [ 1, 2 ] ]
gap> homalg_variable_316 := SIH_Submatrix(homalg_variable_311,[ 1, 3, 4, 5 ],[1..2]);;
gap> homalg_variable_315 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_316);;
gap> SI_nrows(homalg_variable_315);
3
gap> homalg_variable_317 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_315 = homalg_variable_317;
false
gap> SIH_GetColumnIndependentUnitPositions(homalg_variable_315,[ 0 ]);
[  ]
gap> homalg_variable_318 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_316 = homalg_variable_318;
false
gap> homalg_variable_319 := SIH_BasisOfRowModule(homalg_variable_311);;
gap> SI_nrows(homalg_variable_319);
5
gap> homalg_variable_320 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_319 = homalg_variable_320;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_316);; homalg_variable_321 := homalg_variable_l[1];; homalg_variable_322 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_321);
5
gap> homalg_variable_323 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_321 = homalg_variable_323;
false
gap> SI_ncols(homalg_variable_322);
4
gap> homalg_variable_324 := homalg_variable_322 * homalg_variable_316;;
gap> homalg_variable_321 = homalg_variable_324;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_319,homalg_variable_321);; homalg_variable_325 := homalg_variable_l[1];; homalg_variable_326 := homalg_variable_l[2];;
gap> homalg_variable_327 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_325 = homalg_variable_327;
true
gap> homalg_variable_328 := homalg_variable_326 * homalg_variable_321;;
gap> homalg_variable_329 := homalg_variable_319 + homalg_variable_328;;
gap> homalg_variable_325 = homalg_variable_329;
true
gap> homalg_variable_330 := SIH_DecideZeroRows(homalg_variable_319,homalg_variable_321);;
gap> homalg_variable_331 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_330 = homalg_variable_331;
true
gap> homalg_variable_332 := homalg_variable_326 * (homalg_variable_8);;
gap> homalg_variable_333 := homalg_variable_332 * homalg_variable_322;;
gap> homalg_variable_334 := homalg_variable_333 * homalg_variable_316;;
gap> homalg_variable_334 = homalg_variable_319;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_316,homalg_variable_319);; homalg_variable_335 := homalg_variable_l[1];; homalg_variable_336 := homalg_variable_l[2];;
gap> homalg_variable_337 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_335 = homalg_variable_337;
true
gap> homalg_variable_338 := homalg_variable_336 * homalg_variable_319;;
gap> homalg_variable_339 := homalg_variable_316 + homalg_variable_338;;
gap> homalg_variable_335 = homalg_variable_339;
true
gap> homalg_variable_340 := SIH_DecideZeroRows(homalg_variable_316,homalg_variable_319);;
gap> homalg_variable_341 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_340 = homalg_variable_341;
true
gap> homalg_variable_342 := homalg_variable_336 * (homalg_variable_8);;
gap> homalg_variable_343 := homalg_variable_342 * homalg_variable_319;;
gap> homalg_variable_343 = homalg_variable_316;
true
gap> homalg_variable_344 := SIH_BasisOfRowModule(homalg_variable_305);;
gap> SI_nrows(homalg_variable_344);
5
gap> homalg_variable_345 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_344 = homalg_variable_345;
false
gap> homalg_variable_344 = homalg_variable_305;
true
gap> homalg_variable_346 := SIH_DecideZeroRows(homalg_variable_316,homalg_variable_344);;
gap> homalg_variable_347 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_346 = homalg_variable_347;
true
gap> homalg_variable_348 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_267);;
gap> SI_nrows(homalg_variable_348);
3
gap> homalg_variable_349 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_348 = homalg_variable_349;
false
gap> SIH_GetColumnIndependentUnitPositions(homalg_variable_348,[ 0 ]);
[ [ 2, 7 ], [ 3, 2 ] ]
gap> homalg_variable_351 := SIH_Submatrix(homalg_variable_267,[ 1, 3, 4, 5, 6 ],[1..4]);;
gap> homalg_variable_350 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_351);;
gap> SI_nrows(homalg_variable_350);
1
gap> homalg_variable_352 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_350 = homalg_variable_352;
false
gap> SIH_GetColumnIndependentUnitPositions(homalg_variable_350,[ 0 ]);
[  ]
gap> homalg_variable_353 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_351 = homalg_variable_353;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_351);; homalg_variable_354 := homalg_variable_l[1];; homalg_variable_355 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_354);
7
gap> homalg_variable_356 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_354 = homalg_variable_356;
false
gap> SI_ncols(homalg_variable_355);
5
gap> homalg_variable_357 := homalg_variable_355 * homalg_variable_351;;
gap> homalg_variable_354 = homalg_variable_357;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_267,homalg_variable_354);; homalg_variable_358 := homalg_variable_l[1];; homalg_variable_359 := homalg_variable_l[2];;
gap> homalg_variable_360 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_358 = homalg_variable_360;
true
gap> homalg_variable_361 := homalg_variable_359 * homalg_variable_354;;
gap> homalg_variable_362 := homalg_variable_267 + homalg_variable_361;;
gap> homalg_variable_358 = homalg_variable_362;
true
gap> homalg_variable_363 := SIH_DecideZeroRows(homalg_variable_267,homalg_variable_354);;
gap> homalg_variable_364 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_363 = homalg_variable_364;
true
gap> homalg_variable_365 := homalg_variable_359 * (homalg_variable_8);;
gap> homalg_variable_366 := homalg_variable_365 * homalg_variable_355;;
gap> homalg_variable_367 := homalg_variable_366 * homalg_variable_351;;
gap> homalg_variable_367 = homalg_variable_267;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_351,homalg_variable_267);; homalg_variable_368 := homalg_variable_l[1];; homalg_variable_369 := homalg_variable_l[2];;
gap> homalg_variable_370 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_368 = homalg_variable_370;
true
gap> homalg_variable_371 := homalg_variable_369 * homalg_variable_267;;
gap> homalg_variable_372 := homalg_variable_351 + homalg_variable_371;;
gap> homalg_variable_368 = homalg_variable_372;
true
gap> homalg_variable_373 := SIH_DecideZeroRows(homalg_variable_351,homalg_variable_267);;
gap> homalg_variable_374 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_373 = homalg_variable_374;
true
gap> homalg_variable_375 := homalg_variable_369 * (homalg_variable_8);;
gap> homalg_variable_376 := homalg_variable_375 * homalg_variable_267;;
gap> homalg_variable_376 = homalg_variable_351;
true
gap> homalg_variable_377 := SIH_BasisOfRowModule(homalg_variable_350);;
gap> SI_nrows(homalg_variable_377);
1
gap> homalg_variable_378 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_377 = homalg_variable_378;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_350);; homalg_variable_379 := homalg_variable_l[1];; homalg_variable_380 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_379);
1
gap> homalg_variable_381 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_379 = homalg_variable_381;
false
gap> SI_ncols(homalg_variable_380);
1
gap> homalg_variable_382 := homalg_variable_380 * homalg_variable_350;;
gap> homalg_variable_379 = homalg_variable_382;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_377,homalg_variable_379);; homalg_variable_383 := homalg_variable_l[1];; homalg_variable_384 := homalg_variable_l[2];;
gap> homalg_variable_385 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_383 = homalg_variable_385;
true
gap> homalg_variable_386 := homalg_variable_384 * homalg_variable_379;;
gap> homalg_variable_387 := homalg_variable_377 + homalg_variable_386;;
gap> homalg_variable_383 = homalg_variable_387;
true
gap> homalg_variable_388 := SIH_DecideZeroRows(homalg_variable_377,homalg_variable_379);;
gap> homalg_variable_389 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_388 = homalg_variable_389;
true
gap> homalg_variable_390 := homalg_variable_384 * (homalg_variable_8);;
gap> homalg_variable_391 := homalg_variable_390 * homalg_variable_380;;
gap> homalg_variable_392 := homalg_variable_391 * homalg_variable_350;;
gap> homalg_variable_392 = homalg_variable_377;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_350,homalg_variable_377);; homalg_variable_393 := homalg_variable_l[1];; homalg_variable_394 := homalg_variable_l[2];;
gap> homalg_variable_395 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_393 = homalg_variable_395;
true
gap> homalg_variable_396 := homalg_variable_394 * homalg_variable_377;;
gap> homalg_variable_397 := homalg_variable_350 + homalg_variable_396;;
gap> homalg_variable_393 = homalg_variable_397;
true
gap> homalg_variable_398 := SIH_DecideZeroRows(homalg_variable_350,homalg_variable_377);;
gap> homalg_variable_399 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_398 = homalg_variable_399;
true
gap> homalg_variable_400 := homalg_variable_394 * (homalg_variable_8);;
gap> homalg_variable_401 := homalg_variable_400 * homalg_variable_377;;
gap> homalg_variable_401 = homalg_variable_350;
true
gap> homalg_variable_402 := homalg_variable_350 * homalg_variable_351;;
gap> homalg_variable_403 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_402 = homalg_variable_403;
true
gap> homalg_variable_377 = homalg_variable_350;
true
gap> homalg_variable_404 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_344);;
gap> SI_nrows(homalg_variable_404);
4
gap> homalg_variable_405 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_404 = homalg_variable_405;
false
gap> SIH_GetColumnIndependentUnitPositions(homalg_variable_404,[ 0 ]);
[ [ 1, 2 ] ]
gap> homalg_variable_407 := SIH_Submatrix(homalg_variable_344,[ 1, 3, 4, 5 ],[1..2]);;
gap> homalg_variable_406 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_407);;
gap> SI_nrows(homalg_variable_406);
3
gap> homalg_variable_408 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_406 = homalg_variable_408;
false
gap> SIH_GetColumnIndependentUnitPositions(homalg_variable_406,[ 0 ]);
[  ]
gap> homalg_variable_409 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_407 = homalg_variable_409;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_407);; homalg_variable_410 := homalg_variable_l[1];; homalg_variable_411 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_410);
5
gap> homalg_variable_412 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_410 = homalg_variable_412;
false
gap> SI_ncols(homalg_variable_411);
4
gap> homalg_variable_413 := homalg_variable_411 * homalg_variable_407;;
gap> homalg_variable_410 = homalg_variable_413;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_344,homalg_variable_410);; homalg_variable_414 := homalg_variable_l[1];; homalg_variable_415 := homalg_variable_l[2];;
gap> homalg_variable_416 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_414 = homalg_variable_416;
true
gap> homalg_variable_417 := homalg_variable_415 * homalg_variable_410;;
gap> homalg_variable_418 := homalg_variable_344 + homalg_variable_417;;
gap> homalg_variable_414 = homalg_variable_418;
true
gap> homalg_variable_419 := SIH_DecideZeroRows(homalg_variable_344,homalg_variable_410);;
gap> homalg_variable_420 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_419 = homalg_variable_420;
true
gap> homalg_variable_421 := homalg_variable_415 * (homalg_variable_8);;
gap> homalg_variable_422 := homalg_variable_421 * homalg_variable_411;;
gap> homalg_variable_423 := homalg_variable_422 * homalg_variable_407;;
gap> homalg_variable_423 = homalg_variable_344;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_407,homalg_variable_344);; homalg_variable_424 := homalg_variable_l[1];; homalg_variable_425 := homalg_variable_l[2];;
gap> homalg_variable_426 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_424 = homalg_variable_426;
true
gap> homalg_variable_427 := homalg_variable_425 * homalg_variable_344;;
gap> homalg_variable_428 := homalg_variable_407 + homalg_variable_427;;
gap> homalg_variable_424 = homalg_variable_428;
true
gap> homalg_variable_429 := SIH_DecideZeroRows(homalg_variable_407,homalg_variable_344);;
gap> homalg_variable_430 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_429 = homalg_variable_430;
true
gap> homalg_variable_431 := homalg_variable_425 * (homalg_variable_8);;
gap> homalg_variable_432 := homalg_variable_431 * homalg_variable_344;;
gap> homalg_variable_432 = homalg_variable_407;
true
gap> homalg_variable_433 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_406);;
gap> SI_nrows(homalg_variable_433);
1
gap> homalg_variable_434 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_433 = homalg_variable_434;
false
gap> SIH_GetColumnIndependentUnitPositions(homalg_variable_433,[ 0 ]);
[  ]
gap> homalg_variable_435 := SIH_BasisOfRowModule(homalg_variable_406);;
gap> SI_nrows(homalg_variable_435);
3
gap> homalg_variable_436 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_435 = homalg_variable_436;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_406);; homalg_variable_437 := homalg_variable_l[1];; homalg_variable_438 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_437);
3
gap> homalg_variable_439 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_437 = homalg_variable_439;
false
gap> SI_ncols(homalg_variable_438);
3
gap> homalg_variable_440 := homalg_variable_438 * homalg_variable_406;;
gap> homalg_variable_437 = homalg_variable_440;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_435,homalg_variable_437);; homalg_variable_441 := homalg_variable_l[1];; homalg_variable_442 := homalg_variable_l[2];;
gap> homalg_variable_443 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_441 = homalg_variable_443;
true
gap> homalg_variable_444 := homalg_variable_442 * homalg_variable_437;;
gap> homalg_variable_445 := homalg_variable_435 + homalg_variable_444;;
gap> homalg_variable_441 = homalg_variable_445;
true
gap> homalg_variable_446 := SIH_DecideZeroRows(homalg_variable_435,homalg_variable_437);;
gap> homalg_variable_447 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_446 = homalg_variable_447;
true
gap> homalg_variable_448 := homalg_variable_442 * (homalg_variable_8);;
gap> homalg_variable_449 := homalg_variable_448 * homalg_variable_438;;
gap> homalg_variable_450 := homalg_variable_449 * homalg_variable_406;;
gap> homalg_variable_450 = homalg_variable_435;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_406,homalg_variable_435);; homalg_variable_451 := homalg_variable_l[1];; homalg_variable_452 := homalg_variable_l[2];;
gap> homalg_variable_453 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_451 = homalg_variable_453;
true
gap> homalg_variable_454 := homalg_variable_452 * homalg_variable_435;;
gap> homalg_variable_455 := homalg_variable_406 + homalg_variable_454;;
gap> homalg_variable_451 = homalg_variable_455;
true
gap> homalg_variable_456 := SIH_DecideZeroRows(homalg_variable_406,homalg_variable_435);;
gap> homalg_variable_457 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_456 = homalg_variable_457;
true
gap> homalg_variable_458 := homalg_variable_452 * (homalg_variable_8);;
gap> homalg_variable_459 := homalg_variable_458 * homalg_variable_435;;
gap> homalg_variable_459 = homalg_variable_406;
true
gap> homalg_variable_460 := SIH_BasisOfRowModule(homalg_variable_433);;
gap> SI_nrows(homalg_variable_460);
1
gap> homalg_variable_461 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_460 = homalg_variable_461;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_433);; homalg_variable_462 := homalg_variable_l[1];; homalg_variable_463 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_462);
1
gap> homalg_variable_464 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_462 = homalg_variable_464;
false
gap> SI_ncols(homalg_variable_463);
1
gap> homalg_variable_465 := homalg_variable_463 * homalg_variable_433;;
gap> homalg_variable_462 = homalg_variable_465;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_460,homalg_variable_462);; homalg_variable_466 := homalg_variable_l[1];; homalg_variable_467 := homalg_variable_l[2];;
gap> homalg_variable_468 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_466 = homalg_variable_468;
true
gap> homalg_variable_469 := homalg_variable_467 * homalg_variable_462;;
gap> homalg_variable_470 := homalg_variable_460 + homalg_variable_469;;
gap> homalg_variable_466 = homalg_variable_470;
true
gap> homalg_variable_471 := SIH_DecideZeroRows(homalg_variable_460,homalg_variable_462);;
gap> homalg_variable_472 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_471 = homalg_variable_472;
true
gap> homalg_variable_473 := homalg_variable_467 * (homalg_variable_8);;
gap> homalg_variable_474 := homalg_variable_473 * homalg_variable_463;;
gap> homalg_variable_475 := homalg_variable_474 * homalg_variable_433;;
gap> homalg_variable_475 = homalg_variable_460;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_433,homalg_variable_460);; homalg_variable_476 := homalg_variable_l[1];; homalg_variable_477 := homalg_variable_l[2];;
gap> homalg_variable_478 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_476 = homalg_variable_478;
true
gap> homalg_variable_479 := homalg_variable_477 * homalg_variable_460;;
gap> homalg_variable_480 := homalg_variable_433 + homalg_variable_479;;
gap> homalg_variable_476 = homalg_variable_480;
true
gap> homalg_variable_481 := SIH_DecideZeroRows(homalg_variable_433,homalg_variable_460);;
gap> homalg_variable_482 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_481 = homalg_variable_482;
true
gap> homalg_variable_483 := homalg_variable_477 * (homalg_variable_8);;
gap> homalg_variable_484 := homalg_variable_483 * homalg_variable_460;;
gap> homalg_variable_484 = homalg_variable_433;
true
gap> homalg_variable_485 := homalg_variable_406 * homalg_variable_407;;
gap> homalg_variable_486 := SI_matrix(homalg_variable_5,3,2,"0");;
gap> homalg_variable_485 = homalg_variable_486;
true
gap> homalg_variable_487 := homalg_variable_433 * homalg_variable_406;;
gap> homalg_variable_488 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_487 = homalg_variable_488;
true
gap> homalg_variable_435 = homalg_variable_406;
true
gap> homalg_variable_489 := SIH_DecideZeroRows(homalg_variable_406,homalg_variable_435);;
gap> homalg_variable_490 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_489 = homalg_variable_490;
true
gap> homalg_variable_460 = homalg_variable_433;
true
gap> homalg_variable_491 := SIH_DecideZeroRows(homalg_variable_433,homalg_variable_460);;
gap> homalg_variable_492 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_491 = homalg_variable_492;
true
gap> homalg_variable_493 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_157);;
gap> SI_nrows(homalg_variable_493);
3
gap> homalg_variable_494 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_493 = homalg_variable_494;
false
gap> SIH_GetColumnIndependentUnitPositions(homalg_variable_493,[ 0 ]);
[  ]
gap> homalg_variable_495 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_493);;
gap> SI_nrows(homalg_variable_495);
1
gap> homalg_variable_496 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_495 = homalg_variable_496;
false
gap> SIH_GetColumnIndependentUnitPositions(homalg_variable_495,[ 0 ]);
[  ]
gap> homalg_variable_497 := SIH_BasisOfRowModule(homalg_variable_493);;
gap> SI_nrows(homalg_variable_497);
3
gap> homalg_variable_498 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_497 = homalg_variable_498;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_493);; homalg_variable_499 := homalg_variable_l[1];; homalg_variable_500 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_499);
3
gap> for _del in [ "homalg_variable_11", "homalg_variable_13", "homalg_variable_16", "homalg_variable_19", "homalg_variable_21", "homalg_variable_23", "homalg_variable_27", "homalg_variable_29", "homalg_variable_31", "homalg_variable_34", "homalg_variable_35", "homalg_variable_36", "homalg_variable_37", "homalg_variable_38", "homalg_variable_39", "homalg_variable_40", "homalg_variable_41", "homalg_variable_42", "homalg_variable_43", "homalg_variable_44", "homalg_variable_45", "homalg_variable_46", "homalg_variable_47", "homalg_variable_48", "homalg_variable_49", "homalg_variable_50", "homalg_variable_51", "homalg_variable_52", "homalg_variable_53", "homalg_variable_54", "homalg_variable_56", "homalg_variable_59", "homalg_variable_60", "homalg_variable_61", "homalg_variable_62", "homalg_variable_64", "homalg_variable_66", "homalg_variable_68", "homalg_variable_71", "homalg_variable_72", "homalg_variable_75", "homalg_variable_76", "homalg_variable_77", "homalg_variable_78", "homalg_variable_79", "homalg_variable_83", "homalg_variable_84", "homalg_variable_85", "homalg_variable_86", "homalg_variable_87", "homalg_variable_88", "homalg_variable_89", "homalg_variable_90", "homalg_variable_91", "homalg_variable_93", "homalg_variable_94", "homalg_variable_95", "homalg_variable_98", "homalg_variable_100", "homalg_variable_103", "homalg_variable_104", "homalg_variable_107", "homalg_variable_108", "homalg_variable_109", "homalg_variable_110", "homalg_variable_111", "homalg_variable_114", "homalg_variable_115", "homalg_variable_116", "homalg_variable_117", "homalg_variable_118", "homalg_variable_119", "homalg_variable_120", "homalg_variable_121", "homalg_variable_122", "homalg_variable_123", "homalg_variable_125", "homalg_variable_128", "homalg_variable_129", "homalg_variable_130", "homalg_variable_131", "homalg_variable_132", "homalg_variable_133", "homalg_variable_134", "homalg_variable_135", "homalg_variable_136", "homalg_variable_137", "homalg_variable_138", "homalg_variable_139", "homalg_variable_140", "homalg_variable_141", "homalg_variable_142", "homalg_variable_143", "homalg_variable_144", "homalg_variable_145", "homalg_variable_146", "homalg_variable_147", "homalg_variable_148", "homalg_variable_149", "homalg_variable_150", "homalg_variable_151", "homalg_variable_152", "homalg_variable_153", "homalg_variable_154", "homalg_variable_155", "homalg_variable_156", "homalg_variable_159", "homalg_variable_160", "homalg_variable_161", "homalg_variable_162", "homalg_variable_163", "homalg_variable_164", "homalg_variable_165", "homalg_variable_166", "homalg_variable_167", "homalg_variable_168", "homalg_variable_169", "homalg_variable_170", "homalg_variable_172", "homalg_variable_175", "homalg_variable_176", "homalg_variable_177", "homalg_variable_178", "homalg_variable_179", "homalg_variable_180", "homalg_variable_181", "homalg_variable_182", "homalg_variable_183", "homalg_variable_184", "homalg_variable_185", "homalg_variable_186", "homalg_variable_187", "homalg_variable_188", "homalg_variable_189", "homalg_variable_190", "homalg_variable_191", "homalg_variable_192", "homalg_variable_193", "homalg_variable_194", "homalg_variable_195", "homalg_variable_197", "homalg_variable_199", "homalg_variable_201", "homalg_variable_204", "homalg_variable_205", "homalg_variable_208", "homalg_variable_209", "homalg_variable_210", "homalg_variable_211", "homalg_variable_212", "homalg_variable_216", "homalg_variable_217", "homalg_variable_218", "homalg_variable_219", "homalg_variable_220", "homalg_variable_221", "homalg_variable_222", "homalg_variable_223", "homalg_variable_224", "homalg_variable_226", "homalg_variable_228", "homalg_variable_230", "homalg_variable_231", "homalg_variable_232", "homalg_variable_233", "homalg_variable_235", "homalg_variable_237", "homalg_variable_240", "homalg_variable_241", "homalg_variable_243", "homalg_variable_246", "homalg_variable_247", "homalg_variable_248", "homalg_variable_249", "homalg_variable_250", "homalg_variable_251", "homalg_variable_252", "homalg_variable_253", "homalg_variable_254", "homalg_variable_255", "homalg_variable_256", "homalg_variable_257", "homalg_variable_261", "homalg_variable_262", "homalg_variable_263", "homalg_variable_264", "homalg_variable_266", "homalg_variable_268", "homalg_variable_269", "homalg_variable_270", "homalg_variable_274", "homalg_variable_276", "homalg_variable_279", "homalg_variable_280", "homalg_variable_281", "homalg_variable_282", "homalg_variable_283", "homalg_variable_284", "homalg_variable_285", "homalg_variable_286", "homalg_variable_287", "homalg_variable_288", "homalg_variable_289", "homalg_variable_290", "homalg_variable_291", "homalg_variable_292", "homalg_variable_293", "homalg_variable_294", "homalg_variable_295", "homalg_variable_296", "homalg_variable_297", "homalg_variable_298", "homalg_variable_299", "homalg_variable_300", "homalg_variable_302", "homalg_variable_304", "homalg_variable_307", "homalg_variable_308", "homalg_variable_309", "homalg_variable_310", "homalg_variable_312", "homalg_variable_314", "homalg_variable_317", "homalg_variable_318", "homalg_variable_320", "homalg_variable_323", "homalg_variable_324", "homalg_variable_325", "homalg_variable_326", "homalg_variable_327", "homalg_variable_328", "homalg_variable_329", "homalg_variable_330", "homalg_variable_331", "homalg_variable_332", "homalg_variable_333", "homalg_variable_334", "homalg_variable_335", "homalg_variable_336", "homalg_variable_337", "homalg_variable_338", "homalg_variable_339", "homalg_variable_340", "homalg_variable_341", "homalg_variable_342", "homalg_variable_343", "homalg_variable_345", "homalg_variable_346", "homalg_variable_347", "homalg_variable_349", "homalg_variable_352", "homalg_variable_353", "homalg_variable_356", "homalg_variable_357", "homalg_variable_358", "homalg_variable_359", "homalg_variable_360", "homalg_variable_361", "homalg_variable_362", "homalg_variable_363", "homalg_variable_364", "homalg_variable_365", "homalg_variable_366", "homalg_variable_367", "homalg_variable_370", "homalg_variable_371", "homalg_variable_372", "homalg_variable_373", "homalg_variable_374", "homalg_variable_376", "homalg_variable_378", "homalg_variable_381", "homalg_variable_382", "homalg_variable_383", "homalg_variable_384", "homalg_variable_385", "homalg_variable_386", "homalg_variable_387", "homalg_variable_388", "homalg_variable_389", "homalg_variable_390", "homalg_variable_391", "homalg_variable_392", "homalg_variable_393", "homalg_variable_394", "homalg_variable_395", "homalg_variable_396", "homalg_variable_397", "homalg_variable_398", "homalg_variable_399", "homalg_variable_400", "homalg_variable_401", "homalg_variable_402", "homalg_variable_403", "homalg_variable_405", "homalg_variable_408", "homalg_variable_409", "homalg_variable_412", "homalg_variable_413", "homalg_variable_414", "homalg_variable_415", "homalg_variable_416", "homalg_variable_417", "homalg_variable_418", "homalg_variable_419", "homalg_variable_420", "homalg_variable_421", "homalg_variable_422", "homalg_variable_423", "homalg_variable_426", "homalg_variable_429", "homalg_variable_430", "homalg_variable_432", "homalg_variable_434", "homalg_variable_436", "homalg_variable_439", "homalg_variable_440", "homalg_variable_441", "homalg_variable_442", "homalg_variable_443", "homalg_variable_444", "homalg_variable_445", "homalg_variable_446", "homalg_variable_447", "homalg_variable_448", "homalg_variable_449", "homalg_variable_450", "homalg_variable_451", "homalg_variable_452", "homalg_variable_453", "homalg_variable_454", "homalg_variable_455", "homalg_variable_456", "homalg_variable_457", "homalg_variable_458", "homalg_variable_459", "homalg_variable_461", "homalg_variable_464", "homalg_variable_465", "homalg_variable_468", "homalg_variable_469", "homalg_variable_470", "homalg_variable_472", "homalg_variable_475", "homalg_variable_476", "homalg_variable_477", "homalg_variable_478", "homalg_variable_479", "homalg_variable_480", "homalg_variable_481", "homalg_variable_482", "homalg_variable_483", "homalg_variable_484", "homalg_variable_485", "homalg_variable_486", "homalg_variable_487", "homalg_variable_488", "homalg_variable_489", "homalg_variable_490", "homalg_variable_491", "homalg_variable_492", "homalg_variable_494" ] do UnbindGlobal( _del ); od;;
gap> homalg_variable_501 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_499 = homalg_variable_501;
false
gap> SI_ncols(homalg_variable_500);
3
gap> homalg_variable_502 := homalg_variable_500 * homalg_variable_493;;
gap> homalg_variable_499 = homalg_variable_502;
true
gap> homalg_variable_503 := SI_matrix(SI_freemodule(homalg_variable_5,3));;
gap> homalg_variable_499 = homalg_variable_503;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_497,homalg_variable_499);; homalg_variable_504 := homalg_variable_l[1];; homalg_variable_505 := homalg_variable_l[2];;
gap> homalg_variable_506 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_504 = homalg_variable_506;
true
gap> homalg_variable_507 := homalg_variable_505 * homalg_variable_499;;
gap> homalg_variable_508 := homalg_variable_497 + homalg_variable_507;;
gap> homalg_variable_504 = homalg_variable_508;
true
gap> homalg_variable_509 := SIH_DecideZeroRows(homalg_variable_497,homalg_variable_499);;
gap> homalg_variable_510 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_509 = homalg_variable_510;
true
gap> homalg_variable_511 := homalg_variable_505 * (homalg_variable_8);;
gap> homalg_variable_512 := homalg_variable_511 * homalg_variable_500;;
gap> homalg_variable_513 := homalg_variable_512 * homalg_variable_493;;
gap> homalg_variable_513 = homalg_variable_497;
true
gap> homalg_variable_497 = homalg_variable_503;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_493,homalg_variable_497);; homalg_variable_514 := homalg_variable_l[1];; homalg_variable_515 := homalg_variable_l[2];;
gap> homalg_variable_516 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_514 = homalg_variable_516;
true
gap> homalg_variable_517 := homalg_variable_515 * homalg_variable_497;;
gap> homalg_variable_518 := homalg_variable_493 + homalg_variable_517;;
gap> homalg_variable_514 = homalg_variable_518;
true
gap> homalg_variable_519 := SIH_DecideZeroRows(homalg_variable_493,homalg_variable_497);;
gap> homalg_variable_520 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_519 = homalg_variable_520;
true
gap> homalg_variable_521 := homalg_variable_515 * (homalg_variable_8);;
gap> homalg_variable_522 := homalg_variable_521 * homalg_variable_497;;
gap> homalg_variable_522 = homalg_variable_493;
true
gap> homalg_variable_523 := SIH_BasisOfRowModule(homalg_variable_495);;
gap> SI_nrows(homalg_variable_523);
1
gap> homalg_variable_524 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_523 = homalg_variable_524;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_495);; homalg_variable_525 := homalg_variable_l[1];; homalg_variable_526 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_525);
1
gap> homalg_variable_527 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_525 = homalg_variable_527;
false
gap> SI_ncols(homalg_variable_526);
1
gap> homalg_variable_528 := homalg_variable_526 * homalg_variable_495;;
gap> homalg_variable_525 = homalg_variable_528;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_523,homalg_variable_525);; homalg_variable_529 := homalg_variable_l[1];; homalg_variable_530 := homalg_variable_l[2];;
gap> homalg_variable_531 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_529 = homalg_variable_531;
true
gap> homalg_variable_532 := homalg_variable_530 * homalg_variable_525;;
gap> homalg_variable_533 := homalg_variable_523 + homalg_variable_532;;
gap> homalg_variable_529 = homalg_variable_533;
true
gap> homalg_variable_534 := SIH_DecideZeroRows(homalg_variable_523,homalg_variable_525);;
gap> homalg_variable_535 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_534 = homalg_variable_535;
true
gap> homalg_variable_536 := homalg_variable_530 * (homalg_variable_8);;
gap> homalg_variable_537 := homalg_variable_536 * homalg_variable_526;;
gap> homalg_variable_538 := homalg_variable_537 * homalg_variable_495;;
gap> homalg_variable_538 = homalg_variable_523;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_495,homalg_variable_523);; homalg_variable_539 := homalg_variable_l[1];; homalg_variable_540 := homalg_variable_l[2];;
gap> homalg_variable_541 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_539 = homalg_variable_541;
true
gap> homalg_variable_542 := homalg_variable_540 * homalg_variable_523;;
gap> homalg_variable_543 := homalg_variable_495 + homalg_variable_542;;
gap> homalg_variable_539 = homalg_variable_543;
true
gap> homalg_variable_544 := SIH_DecideZeroRows(homalg_variable_495,homalg_variable_523);;
gap> homalg_variable_545 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_544 = homalg_variable_545;
true
gap> homalg_variable_546 := homalg_variable_540 * (homalg_variable_8);;
gap> homalg_variable_547 := homalg_variable_546 * homalg_variable_523;;
gap> homalg_variable_547 = homalg_variable_495;
true
gap> homalg_variable_548 := homalg_variable_493 * homalg_variable_157;;
gap> homalg_variable_549 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_548 = homalg_variable_549;
true
gap> homalg_variable_550 := homalg_variable_495 * homalg_variable_493;;
gap> homalg_variable_551 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_550 = homalg_variable_551;
true
gap> homalg_variable_497 = homalg_variable_493;
true
gap> homalg_variable_552 := SIH_DecideZeroRows(homalg_variable_493,homalg_variable_497);;
gap> homalg_variable_553 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_552 = homalg_variable_553;
true
gap> homalg_variable_523 = homalg_variable_495;
true
gap> homalg_variable_554 := SIH_DecideZeroRows(homalg_variable_495,homalg_variable_523);;
gap> homalg_variable_555 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_554 = homalg_variable_555;
true
gap> homalg_variable_556 := homalg_variable_350 * homalg_variable_351;;
gap> homalg_variable_557 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_556 = homalg_variable_557;
true
gap> SIH_ZeroRows(homalg_variable_10);
[  ]
gap> homalg_variable_558 := homalg_variable_22 * homalg_variable_10;;
gap> homalg_variable_559 := SI_matrix(homalg_variable_5,2,6,"0");;
gap> homalg_variable_558 = homalg_variable_559;
true
gap> homalg_variable_171 = homalg_variable_22;
true
gap> homalg_variable_560 := SIH_DecideZeroRows(homalg_variable_22,homalg_variable_171);;
gap> homalg_variable_561 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_560 = homalg_variable_561;
true
gap> homalg_variable_563 := SIH_UnionOfRows(homalg_variable_18,homalg_variable_171);;
gap> homalg_variable_562 := SIH_BasisOfRowModule(homalg_variable_563);;
gap> SI_nrows(homalg_variable_562);
5
gap> homalg_variable_564 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_562 = homalg_variable_564;
false
gap> homalg_variable_565 := SIH_DecideZeroRows(homalg_variable_18,homalg_variable_562);;
gap> homalg_variable_566 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_565 = homalg_variable_566;
true
gap> homalg_variable_568 := SIH_UnionOfRows(homalg_variable_22,homalg_variable_18);;
gap> homalg_variable_567 := SIH_BasisOfRowModule(homalg_variable_568);;
gap> SI_nrows(homalg_variable_567);
5
gap> homalg_variable_569 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_567 = homalg_variable_569;
false
gap> homalg_variable_570 := SIH_DecideZeroRows(homalg_variable_18,homalg_variable_567);;
gap> homalg_variable_571 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_570 = homalg_variable_571;
true
gap> homalg_variable_572 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_568);;
gap> SI_nrows(homalg_variable_572);
2
gap> homalg_variable_573 := SI_matrix(homalg_variable_5,2,7,"0");;
gap> homalg_variable_572 = homalg_variable_573;
false
gap> homalg_variable_574 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_572);;
gap> SI_nrows(homalg_variable_574);
1
gap> homalg_variable_575 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_574 = homalg_variable_575;
true
gap> homalg_variable_576 := SIH_BasisOfRowModule(homalg_variable_572);;
gap> SI_nrows(homalg_variable_576);
2
gap> homalg_variable_577 := SI_matrix(homalg_variable_5,2,7,"0");;
gap> homalg_variable_576 = homalg_variable_577;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_572);; homalg_variable_578 := homalg_variable_l[1];; homalg_variable_579 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_578);
2
gap> homalg_variable_580 := SI_matrix(homalg_variable_5,2,7,"0");;
gap> homalg_variable_578 = homalg_variable_580;
false
gap> SI_ncols(homalg_variable_579);
2
gap> homalg_variable_581 := homalg_variable_579 * homalg_variable_572;;
gap> homalg_variable_578 = homalg_variable_581;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_576,homalg_variable_578);; homalg_variable_582 := homalg_variable_l[1];; homalg_variable_583 := homalg_variable_l[2];;
gap> homalg_variable_584 := SI_matrix(homalg_variable_5,2,7,"0");;
gap> homalg_variable_582 = homalg_variable_584;
true
gap> homalg_variable_585 := homalg_variable_583 * homalg_variable_578;;
gap> homalg_variable_586 := homalg_variable_576 + homalg_variable_585;;
gap> homalg_variable_582 = homalg_variable_586;
true
gap> homalg_variable_587 := SIH_DecideZeroRows(homalg_variable_576,homalg_variable_578);;
gap> homalg_variable_588 := SI_matrix(homalg_variable_5,2,7,"0");;
gap> homalg_variable_587 = homalg_variable_588;
true
gap> homalg_variable_589 := homalg_variable_583 * (homalg_variable_8);;
gap> homalg_variable_590 := homalg_variable_589 * homalg_variable_579;;
gap> homalg_variable_591 := homalg_variable_590 * homalg_variable_572;;
gap> homalg_variable_591 = homalg_variable_576;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_572,homalg_variable_576);; homalg_variable_592 := homalg_variable_l[1];; homalg_variable_593 := homalg_variable_l[2];;
gap> homalg_variable_594 := SI_matrix(homalg_variable_5,2,7,"0");;
gap> homalg_variable_592 = homalg_variable_594;
true
gap> homalg_variable_595 := homalg_variable_593 * homalg_variable_576;;
gap> homalg_variable_596 := homalg_variable_572 + homalg_variable_595;;
gap> homalg_variable_592 = homalg_variable_596;
true
gap> homalg_variable_597 := SIH_DecideZeroRows(homalg_variable_572,homalg_variable_576);;
gap> homalg_variable_598 := SI_matrix(homalg_variable_5,2,7,"0");;
gap> homalg_variable_597 = homalg_variable_598;
true
gap> homalg_variable_599 := homalg_variable_593 * (homalg_variable_8);;
gap> homalg_variable_600 := homalg_variable_599 * homalg_variable_576;;
gap> homalg_variable_600 = homalg_variable_572;
true
gap> SIH_ZeroRows(homalg_variable_572);
[  ]
gap> homalg_variable_601 := SIH_Submatrix(homalg_variable_572,[1..2],[ 3, 4, 5, 6, 7 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_601,homalg_variable_171);; homalg_variable_602 := homalg_variable_l[1];; homalg_variable_603 := homalg_variable_l[2];;
gap> homalg_variable_604 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_602 = homalg_variable_604;
true
gap> homalg_variable_605 := homalg_variable_603 * homalg_variable_171;;
gap> homalg_variable_606 := homalg_variable_601 + homalg_variable_605;;
gap> homalg_variable_602 = homalg_variable_606;
true
gap> homalg_variable_607 := SIH_DecideZeroRows(homalg_variable_601,homalg_variable_171);;
gap> homalg_variable_608 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_607 = homalg_variable_608;
true
gap> homalg_variable_609 := homalg_variable_603 * (homalg_variable_8);;
gap> homalg_variable_610 := homalg_variable_609 * homalg_variable_171;;
gap> homalg_variable_611 := homalg_variable_610 - homalg_variable_601;;
gap> homalg_variable_612 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_611 = homalg_variable_612;
true
gap> homalg_variable_613 := SIH_BasisOfRowModule(homalg_variable_609);;
gap> SI_nrows(homalg_variable_613);
2
gap> homalg_variable_614 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_613 = homalg_variable_614;
false
gap> homalg_variable_613 = homalg_variable_609;
true
gap> homalg_variable_616 := SI_matrix(SI_freemodule(homalg_variable_5,2));;
gap> homalg_variable_615 := SIH_DecideZeroRows(homalg_variable_616,homalg_variable_613);;
gap> homalg_variable_617 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_615 = homalg_variable_617;
true
gap> homalg_variable_618 := SI_matrix(SI_freemodule(homalg_variable_5,2));;
gap> homalg_variable_609 = homalg_variable_618;
true
gap> homalg_variable_619 := homalg_variable_609 - homalg_variable_618;;
gap> homalg_variable_620 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_619 = homalg_variable_620;
true
gap> homalg_variable_621 := SIH_Submatrix(homalg_variable_572,[1..2],[ 3, 4, 5, 6, 7 ]);;
gap> homalg_variable_622 := homalg_variable_171 - homalg_variable_621;;
gap> homalg_variable_623 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_622 = homalg_variable_623;
true
gap> SIH_ZeroRows(homalg_variable_196);
[  ]
gap> homalg_variable_624 := homalg_variable_198 * homalg_variable_196;;
gap> homalg_variable_625 := SI_matrix(homalg_variable_5,1,6,"0");;
gap> homalg_variable_624 = homalg_variable_625;
true
gap> homalg_variable_626 := SIH_BasisOfRowModule(homalg_variable_198);;
gap> SI_nrows(homalg_variable_626);
1
gap> homalg_variable_627 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_626 = homalg_variable_627;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_198);; homalg_variable_628 := homalg_variable_l[1];; homalg_variable_629 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_628);
1
gap> homalg_variable_630 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_628 = homalg_variable_630;
false
gap> SI_ncols(homalg_variable_629);
1
gap> homalg_variable_631 := homalg_variable_629 * homalg_variable_198;;
gap> homalg_variable_628 = homalg_variable_631;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_626,homalg_variable_628);; homalg_variable_632 := homalg_variable_l[1];; homalg_variable_633 := homalg_variable_l[2];;
gap> homalg_variable_634 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_632 = homalg_variable_634;
true
gap> homalg_variable_635 := homalg_variable_633 * homalg_variable_628;;
gap> homalg_variable_636 := homalg_variable_626 + homalg_variable_635;;
gap> homalg_variable_632 = homalg_variable_636;
true
gap> homalg_variable_637 := SIH_DecideZeroRows(homalg_variable_626,homalg_variable_628);;
gap> homalg_variable_638 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_637 = homalg_variable_638;
true
gap> homalg_variable_639 := homalg_variable_633 * (homalg_variable_8);;
gap> homalg_variable_640 := homalg_variable_639 * homalg_variable_629;;
gap> homalg_variable_641 := homalg_variable_640 * homalg_variable_198;;
gap> homalg_variable_641 = homalg_variable_626;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_198,homalg_variable_626);; homalg_variable_642 := homalg_variable_l[1];; homalg_variable_643 := homalg_variable_l[2];;
gap> homalg_variable_644 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_642 = homalg_variable_644;
true
gap> homalg_variable_645 := homalg_variable_643 * homalg_variable_626;;
gap> homalg_variable_646 := homalg_variable_198 + homalg_variable_645;;
gap> homalg_variable_642 = homalg_variable_646;
true
gap> homalg_variable_647 := SIH_DecideZeroRows(homalg_variable_198,homalg_variable_626);;
gap> homalg_variable_648 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_647 = homalg_variable_648;
true
gap> homalg_variable_649 := homalg_variable_643 * (homalg_variable_8);;
gap> homalg_variable_650 := homalg_variable_649 * homalg_variable_626;;
gap> homalg_variable_650 = homalg_variable_198;
true
gap> homalg_variable_626 = homalg_variable_198;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_10,homalg_variable_202);; homalg_variable_651 := homalg_variable_l[1];; homalg_variable_652 := homalg_variable_l[2];;
gap> homalg_variable_653 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_651 = homalg_variable_653;
true
gap> homalg_variable_654 := homalg_variable_652 * homalg_variable_202;;
gap> homalg_variable_655 := homalg_variable_10 + homalg_variable_654;;
gap> homalg_variable_651 = homalg_variable_655;
true
gap> homalg_variable_656 := SIH_DecideZeroRows(homalg_variable_10,homalg_variable_202);;
gap> homalg_variable_657 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_656 = homalg_variable_657;
true
gap> SI_ncols(homalg_variable_203);
4
gap> SI_nrows(homalg_variable_203);
4
gap> homalg_variable_658 := homalg_variable_652 * (homalg_variable_8);;
gap> homalg_variable_659 := homalg_variable_658 * homalg_variable_203;;
gap> homalg_variable_660 := homalg_variable_659 * homalg_variable_196;;
gap> homalg_variable_661 := homalg_variable_660 - homalg_variable_10;;
gap> homalg_variable_662 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_661 = homalg_variable_662;
true
gap> homalg_variable_664 := homalg_variable_171 * homalg_variable_659;;
gap> homalg_variable_663 := SIH_DecideZeroRows(homalg_variable_664,homalg_variable_626);;
gap> homalg_variable_665 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_663 = homalg_variable_665;
true
gap> homalg_variable_666 := SIH_UnionOfRows(homalg_variable_227,homalg_variable_225);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_666);; homalg_variable_667 := homalg_variable_l[1];; homalg_variable_668 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_667);
4
gap> homalg_variable_669 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_667 = homalg_variable_669;
false
gap> SI_ncols(homalg_variable_668);
9
gap> homalg_variable_670 := SIH_Submatrix(homalg_variable_668,[1..4],[ 1, 2, 3, 4 ]);;
gap> homalg_variable_671 := homalg_variable_670 * homalg_variable_227;;
gap> homalg_variable_672 := SIH_Submatrix(homalg_variable_668,[1..4],[ 5, 6, 7, 8, 9 ]);;
gap> homalg_variable_673 := homalg_variable_672 * homalg_variable_225;;
gap> homalg_variable_674 := homalg_variable_671 + homalg_variable_673;;
gap> homalg_variable_667 = homalg_variable_674;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_227,homalg_variable_667);; homalg_variable_675 := homalg_variable_l[1];; homalg_variable_676 := homalg_variable_l[2];;
gap> homalg_variable_677 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_675 = homalg_variable_677;
true
gap> homalg_variable_678 := homalg_variable_676 * homalg_variable_667;;
gap> homalg_variable_679 := homalg_variable_227 + homalg_variable_678;;
gap> homalg_variable_675 = homalg_variable_679;
true
gap> homalg_variable_680 := SIH_DecideZeroRows(homalg_variable_227,homalg_variable_667);;
gap> homalg_variable_681 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_680 = homalg_variable_681;
true
gap> homalg_variable_683 := homalg_variable_676 * (homalg_variable_8);;
gap> homalg_variable_684 := SIH_Submatrix(homalg_variable_668,[1..4],[ 1, 2, 3, 4 ]);;
gap> homalg_variable_685 := homalg_variable_683 * homalg_variable_684;;
gap> homalg_variable_686 := homalg_variable_685 * homalg_variable_227;;
gap> homalg_variable_687 := homalg_variable_686 - homalg_variable_196;;
gap> homalg_variable_682 := SIH_DecideZeroRows(homalg_variable_687,homalg_variable_225);;
gap> homalg_variable_688 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_682 = homalg_variable_688;
true
gap> homalg_variable_690 := homalg_variable_626 * homalg_variable_685;;
gap> homalg_variable_689 := SIH_DecideZeroRows(homalg_variable_690,homalg_variable_267);;
gap> homalg_variable_691 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_689 = homalg_variable_691;
true
gap> homalg_variable_692 := SIH_DecideZeroRows(homalg_variable_685,homalg_variable_267);;
gap> homalg_variable_693 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_692 = homalg_variable_693;
false
gap> homalg_variable_694 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_685 = homalg_variable_694;
false
gap> homalg_variable_695 := SIH_UnionOfRows(homalg_variable_692,homalg_variable_267);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_695);; homalg_variable_696 := homalg_variable_l[1];; homalg_variable_697 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_696);
4
gap> homalg_variable_698 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_696 = homalg_variable_698;
false
gap> SI_ncols(homalg_variable_697);
11
gap> homalg_variable_699 := SIH_Submatrix(homalg_variable_697,[1..4],[ 1, 2, 3, 4 ]);;
gap> homalg_variable_700 := homalg_variable_699 * homalg_variable_692;;
gap> homalg_variable_701 := SIH_Submatrix(homalg_variable_697,[1..4],[ 5, 6, 7, 8, 9, 10, 11 ]);;
gap> homalg_variable_702 := homalg_variable_701 * homalg_variable_267;;
gap> homalg_variable_703 := homalg_variable_700 + homalg_variable_702;;
gap> homalg_variable_696 = homalg_variable_703;
true
gap> homalg_variable_705 := SI_matrix(SI_freemodule(homalg_variable_5,4));;
gap> homalg_variable_704 := SIH_DecideZeroRows(homalg_variable_705,homalg_variable_267);;
gap> homalg_variable_706 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_704 = homalg_variable_706;
false
gap> homalg_variable_696 = homalg_variable_705;
true
gap> homalg_variable_708 := SIH_Submatrix(homalg_variable_697,[1..4],[ 1, 2, 3, 4 ]);;
gap> homalg_variable_709 := homalg_variable_704 * homalg_variable_708;;
gap> homalg_variable_710 := homalg_variable_709 * homalg_variable_685;;
gap> homalg_variable_711 := homalg_variable_710 - homalg_variable_705;;
gap> homalg_variable_707 := SIH_DecideZeroRows(homalg_variable_711,homalg_variable_267);;
gap> homalg_variable_712 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_707 = homalg_variable_712;
true
gap> homalg_variable_714 := SIH_UnionOfRows(homalg_variable_659,homalg_variable_709);;
gap> homalg_variable_715 := SIH_UnionOfRows(homalg_variable_714,homalg_variable_626);;
gap> homalg_variable_713 := SIH_BasisOfRowModule(homalg_variable_715);;
gap> SI_nrows(homalg_variable_713);
4
gap> homalg_variable_716 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_713 = homalg_variable_716;
false
gap> homalg_variable_717 := SIH_DecideZeroRows(homalg_variable_705,homalg_variable_713);;
gap> homalg_variable_718 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_717 = homalg_variable_718;
true
gap> homalg_variable_719 := SIH_RelativeSyzygiesGeneratorsOfRows(homalg_variable_714,homalg_variable_626);;
gap> SI_nrows(homalg_variable_719);
9
gap> homalg_variable_720 := SI_matrix(homalg_variable_5,9,9,"0");;
gap> homalg_variable_719 = homalg_variable_720;
false
gap> homalg_variable_721 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_719);;
gap> SI_nrows(homalg_variable_721);
3
gap> homalg_variable_722 := SI_matrix(homalg_variable_5,3,9,"0");;
gap> homalg_variable_721 = homalg_variable_722;
false
gap> SIH_GetColumnIndependentUnitPositions(homalg_variable_721,[ 0 ]);
[ [ 1, 2 ], [ 2, 9 ], [ 3, 4 ] ]
gap> homalg_variable_724 := SIH_Submatrix(homalg_variable_719,[ 1, 3, 5, 6, 7, 8 ],[1..9]);;
gap> homalg_variable_723 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_724);;
gap> SI_nrows(homalg_variable_723);
1
gap> homalg_variable_725 := SI_matrix(homalg_variable_5,1,6,"0");;
gap> homalg_variable_723 = homalg_variable_725;
true
gap> homalg_variable_726 := SIH_BasisOfRowModule(homalg_variable_719);;
gap> SI_nrows(homalg_variable_726);
9
gap> homalg_variable_727 := SI_matrix(homalg_variable_5,9,9,"0");;
gap> homalg_variable_726 = homalg_variable_727;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_724);; homalg_variable_728 := homalg_variable_l[1];; homalg_variable_729 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_728);
9
gap> homalg_variable_730 := SI_matrix(homalg_variable_5,9,9,"0");;
gap> homalg_variable_728 = homalg_variable_730;
false
gap> SI_ncols(homalg_variable_729);
6
gap> homalg_variable_731 := homalg_variable_729 * homalg_variable_724;;
gap> homalg_variable_728 = homalg_variable_731;
true
gap> homalg_variable_732 := SI_matrix(SI_freemodule(homalg_variable_5,9));;
gap> homalg_variable_728 = homalg_variable_732;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_726,homalg_variable_728);; homalg_variable_733 := homalg_variable_l[1];; homalg_variable_734 := homalg_variable_l[2];;
gap> homalg_variable_735 := SI_matrix(homalg_variable_5,9,9,"0");;
gap> homalg_variable_733 = homalg_variable_735;
true
gap> homalg_variable_736 := homalg_variable_734 * homalg_variable_728;;
gap> homalg_variable_737 := homalg_variable_726 + homalg_variable_736;;
gap> homalg_variable_733 = homalg_variable_737;
true
gap> homalg_variable_738 := SIH_DecideZeroRows(homalg_variable_726,homalg_variable_728);;
gap> homalg_variable_739 := SI_matrix(homalg_variable_5,9,9,"0");;
gap> homalg_variable_738 = homalg_variable_739;
true
gap> homalg_variable_740 := homalg_variable_734 * (homalg_variable_8);;
gap> homalg_variable_741 := homalg_variable_740 * homalg_variable_729;;
gap> homalg_variable_742 := homalg_variable_741 * homalg_variable_724;;
gap> homalg_variable_742 = homalg_variable_726;
true
gap> homalg_variable_726 = homalg_variable_732;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_724,homalg_variable_726);; homalg_variable_743 := homalg_variable_l[1];; homalg_variable_744 := homalg_variable_l[2];;
gap> homalg_variable_745 := SI_matrix(homalg_variable_5,6,9,"0");;
gap> homalg_variable_743 = homalg_variable_745;
true
gap> homalg_variable_746 := homalg_variable_744 * homalg_variable_726;;
gap> homalg_variable_747 := homalg_variable_724 + homalg_variable_746;;
gap> homalg_variable_743 = homalg_variable_747;
true
gap> homalg_variable_748 := SIH_DecideZeroRows(homalg_variable_724,homalg_variable_726);;
gap> homalg_variable_749 := SI_matrix(homalg_variable_5,6,9,"0");;
gap> homalg_variable_748 = homalg_variable_749;
true
gap> homalg_variable_750 := homalg_variable_744 * (homalg_variable_8);;
gap> homalg_variable_751 := homalg_variable_750 * homalg_variable_726;;
gap> homalg_variable_751 = homalg_variable_724;
true
gap> SIH_ZeroRows(homalg_variable_724);
[  ]
gap> SIH_ZeroRows(homalg_variable_351);
[  ]
gap> homalg_variable_752 := homalg_variable_350 * homalg_variable_351;;
gap> homalg_variable_753 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_752 = homalg_variable_753;
true
gap> homalg_variable_754 := SIH_DecideZeroRows(homalg_variable_350,homalg_variable_377);;
gap> homalg_variable_755 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_754 = homalg_variable_755;
true
gap> homalg_variable_756 := SIH_Submatrix(homalg_variable_724,[1..6],[ 6, 7, 8, 9 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_756,homalg_variable_354);; homalg_variable_757 := homalg_variable_l[1];; homalg_variable_758 := homalg_variable_l[2];;
gap> homalg_variable_759 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_757 = homalg_variable_759;
true
gap> homalg_variable_760 := homalg_variable_758 * homalg_variable_354;;
gap> homalg_variable_761 := homalg_variable_756 + homalg_variable_760;;
gap> homalg_variable_757 = homalg_variable_761;
true
gap> homalg_variable_762 := SIH_DecideZeroRows(homalg_variable_756,homalg_variable_354);;
gap> homalg_variable_763 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_762 = homalg_variable_763;
true
gap> SI_ncols(homalg_variable_355);
5
gap> SI_nrows(homalg_variable_355);
7
gap> homalg_variable_764 := homalg_variable_758 * (homalg_variable_8);;
gap> homalg_variable_765 := homalg_variable_764 * homalg_variable_355;;
gap> homalg_variable_766 := homalg_variable_765 * homalg_variable_351;;
gap> homalg_variable_767 := homalg_variable_766 - homalg_variable_756;;
gap> homalg_variable_768 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_767 = homalg_variable_768;
true
gap> homalg_variable_769 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_770 := SIH_UnionOfColumns(homalg_variable_171,homalg_variable_769);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_770,homalg_variable_728);; homalg_variable_771 := homalg_variable_l[1];; homalg_variable_772 := homalg_variable_l[2];;
gap> homalg_variable_773 := SI_matrix(homalg_variable_5,2,9,"0");;
gap> homalg_variable_771 = homalg_variable_773;
true
gap> homalg_variable_774 := homalg_variable_772 * homalg_variable_728;;
gap> homalg_variable_775 := homalg_variable_770 + homalg_variable_774;;
gap> homalg_variable_771 = homalg_variable_775;
true
gap> homalg_variable_776 := SIH_DecideZeroRows(homalg_variable_770,homalg_variable_728);;
gap> homalg_variable_777 := SI_matrix(homalg_variable_5,2,9,"0");;
gap> homalg_variable_776 = homalg_variable_777;
true
gap> SI_ncols(homalg_variable_729);
6
gap> SI_nrows(homalg_variable_729);
9
gap> homalg_variable_778 := homalg_variable_772 * (homalg_variable_8);;
gap> homalg_variable_779 := homalg_variable_778 * homalg_variable_729;;
gap> homalg_variable_780 := homalg_variable_779 * homalg_variable_724;;
gap> homalg_variable_781 := homalg_variable_780 - homalg_variable_770;;
gap> homalg_variable_782 := SI_matrix(homalg_variable_5,2,9,"0");;
gap> homalg_variable_781 = homalg_variable_782;
true
gap> homalg_variable_783 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_779);;
gap> SI_nrows(homalg_variable_783);
1
gap> homalg_variable_784 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_783 = homalg_variable_784;
true
gap> homalg_variable_786 := SIH_UnionOfRows(homalg_variable_765,homalg_variable_377);;
gap> homalg_variable_785 := SIH_BasisOfRowModule(homalg_variable_786);;
gap> SI_nrows(homalg_variable_785);
5
gap> homalg_variable_787 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_785 = homalg_variable_787;
false
gap> homalg_variable_788 := SIH_DecideZeroRows(homalg_variable_18,homalg_variable_785);;
gap> homalg_variable_789 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_788 = homalg_variable_789;
true
gap> homalg_variable_791 := SIH_UnionOfRows(homalg_variable_18,homalg_variable_377);;
gap> homalg_variable_790 := SIH_BasisOfRowModule(homalg_variable_791);;
gap> SI_nrows(homalg_variable_790);
5
gap> homalg_variable_792 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_790 = homalg_variable_792;
false
gap> homalg_variable_793 := SIH_DecideZeroRows(homalg_variable_18,homalg_variable_790);;
gap> homalg_variable_794 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_793 = homalg_variable_794;
true
gap> homalg_variable_795 := SIH_DecideZeroRows(homalg_variable_765,homalg_variable_377);;
gap> homalg_variable_796 := SI_matrix(homalg_variable_5,6,5,"0");;
gap> homalg_variable_795 = homalg_variable_796;
false
gap> homalg_variable_797 := SI_matrix(homalg_variable_5,6,5,"0");;
gap> homalg_variable_765 = homalg_variable_797;
false
gap> homalg_variable_798 := SIH_UnionOfRows(homalg_variable_795,homalg_variable_377);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_798);; homalg_variable_799 := homalg_variable_l[1];; homalg_variable_800 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_799);
5
gap> homalg_variable_801 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_799 = homalg_variable_801;
false
gap> SI_ncols(homalg_variable_800);
7
gap> homalg_variable_802 := SIH_Submatrix(homalg_variable_800,[1..5],[ 1, 2, 3, 4, 5, 6 ]);;
gap> homalg_variable_803 := homalg_variable_802 * homalg_variable_795;;
gap> homalg_variable_804 := SIH_Submatrix(homalg_variable_800,[1..5],[ 7 ]);;
gap> homalg_variable_805 := homalg_variable_804 * homalg_variable_377;;
gap> homalg_variable_806 := homalg_variable_803 + homalg_variable_805;;
gap> homalg_variable_799 = homalg_variable_806;
true
gap> homalg_variable_807 := SIH_DecideZeroRows(homalg_variable_18,homalg_variable_377);;
gap> homalg_variable_808 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_807 = homalg_variable_808;
false
gap> homalg_variable_799 = homalg_variable_18;
true
gap> homalg_variable_810 := SIH_Submatrix(homalg_variable_800,[1..5],[ 1, 2, 3, 4, 5, 6 ]);;
gap> homalg_variable_811 := homalg_variable_807 * homalg_variable_810;;
gap> homalg_variable_812 := homalg_variable_811 * homalg_variable_765;;
gap> homalg_variable_813 := homalg_variable_812 - homalg_variable_18;;
gap> homalg_variable_809 := SIH_DecideZeroRows(homalg_variable_813,homalg_variable_377);;
gap> homalg_variable_814 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_809 = homalg_variable_814;
true
gap> homalg_variable_816 := homalg_variable_779 * homalg_variable_724;;
gap> homalg_variable_817 := homalg_variable_811 * homalg_variable_724;;
gap> homalg_variable_818 := SIH_UnionOfRows(homalg_variable_816,homalg_variable_817);;
gap> homalg_variable_815 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_818);;
gap> SI_nrows(homalg_variable_815);
1
gap> homalg_variable_819 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_815 = homalg_variable_819;
false
gap> homalg_variable_820 := SIH_BasisOfRowModule(homalg_variable_815);;
gap> SI_nrows(homalg_variable_820);
1
gap> homalg_variable_821 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_820 = homalg_variable_821;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_815);; homalg_variable_822 := homalg_variable_l[1];; homalg_variable_823 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_822);
1
gap> homalg_variable_824 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_822 = homalg_variable_824;
false
gap> SI_ncols(homalg_variable_823);
1
gap> homalg_variable_825 := homalg_variable_823 * homalg_variable_815;;
gap> homalg_variable_822 = homalg_variable_825;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_820,homalg_variable_822);; homalg_variable_826 := homalg_variable_l[1];; homalg_variable_827 := homalg_variable_l[2];;
gap> homalg_variable_828 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_826 = homalg_variable_828;
true
gap> homalg_variable_829 := homalg_variable_827 * homalg_variable_822;;
gap> homalg_variable_830 := homalg_variable_820 + homalg_variable_829;;
gap> homalg_variable_826 = homalg_variable_830;
true
gap> homalg_variable_831 := SIH_DecideZeroRows(homalg_variable_820,homalg_variable_822);;
gap> homalg_variable_832 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_831 = homalg_variable_832;
true
gap> homalg_variable_833 := homalg_variable_827 * (homalg_variable_8);;
gap> homalg_variable_834 := homalg_variable_833 * homalg_variable_823;;
gap> homalg_variable_835 := homalg_variable_834 * homalg_variable_815;;
gap> homalg_variable_835 = homalg_variable_820;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_815,homalg_variable_820);; homalg_variable_836 := homalg_variable_l[1];; homalg_variable_837 := homalg_variable_l[2];;
gap> homalg_variable_838 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_836 = homalg_variable_838;
true
gap> homalg_variable_839 := homalg_variable_837 * homalg_variable_820;;
gap> homalg_variable_840 := homalg_variable_815 + homalg_variable_839;;
gap> homalg_variable_836 = homalg_variable_840;
true
gap> homalg_variable_841 := SIH_DecideZeroRows(homalg_variable_815,homalg_variable_820);;
gap> homalg_variable_842 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_841 = homalg_variable_842;
true
gap> homalg_variable_843 := homalg_variable_837 * (homalg_variable_8);;
gap> homalg_variable_844 := homalg_variable_843 * homalg_variable_820;;
gap> homalg_variable_844 = homalg_variable_815;
true
gap> homalg_variable_845 := SIH_Submatrix(homalg_variable_815,[1..1],[ 3, 4, 5, 6, 7 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_845,homalg_variable_350);; homalg_variable_846 := homalg_variable_l[1];; homalg_variable_847 := homalg_variable_l[2];;
gap> homalg_variable_848 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_846 = homalg_variable_848;
true
gap> homalg_variable_849 := homalg_variable_847 * homalg_variable_350;;
gap> homalg_variable_850 := homalg_variable_845 + homalg_variable_849;;
gap> homalg_variable_846 = homalg_variable_850;
true
gap> homalg_variable_851 := SIH_DecideZeroRows(homalg_variable_845,homalg_variable_377);;
gap> homalg_variable_852 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_851 = homalg_variable_852;
true
gap> homalg_variable_853 := homalg_variable_847 * (homalg_variable_8);;
gap> homalg_variable_854 := homalg_variable_853 * homalg_variable_350;;
gap> homalg_variable_855 := homalg_variable_854 - homalg_variable_845;;
gap> homalg_variable_856 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_855 = homalg_variable_856;
true
gap> homalg_variable_857 := SIH_BasisOfRowModule(homalg_variable_853);;
gap> SI_nrows(homalg_variable_857);
1
gap> homalg_variable_858 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_857 = homalg_variable_858;
false
gap> homalg_variable_857 = homalg_variable_853;
true
gap> homalg_variable_860 := SI_matrix(SI_freemodule(homalg_variable_5,1));;
gap> homalg_variable_859 := SIH_DecideZeroRows(homalg_variable_860,homalg_variable_857);;
gap> homalg_variable_861 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_859 = homalg_variable_861;
true
gap> homalg_variable_853 = homalg_variable_860;
true
gap> homalg_variable_862 := homalg_variable_853 - homalg_variable_860;;
gap> homalg_variable_863 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_862 = homalg_variable_863;
true
gap> homalg_variable_864 := SIH_Submatrix(homalg_variable_815,[1..1],[ 1, 2 ]);;
gap> homalg_variable_865 := homalg_variable_864 * homalg_variable_816;;
gap> homalg_variable_866 := SIH_Submatrix(homalg_variable_815,[1..1],[ 3, 4, 5, 6, 7 ]);;
gap> homalg_variable_867 := homalg_variable_866 * homalg_variable_817;;
gap> homalg_variable_868 := homalg_variable_865 + homalg_variable_867;;
gap> homalg_variable_869 := SI_matrix(homalg_variable_5,1,9,"0");;
gap> homalg_variable_868 = homalg_variable_869;
true
gap> homalg_variable_870 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_871 := SIH_UnionOfRows(homalg_variable_870,homalg_variable_351);;
gap> homalg_variable_872 := SIH_Submatrix(homalg_variable_816,[1..2],[ 6, 7, 8, 9 ]);;
gap> homalg_variable_873 := SIH_Submatrix(homalg_variable_817,[1..5],[ 6, 7, 8, 9 ]);;
gap> homalg_variable_874 := SIH_UnionOfRows(homalg_variable_872,homalg_variable_873);;
gap> homalg_variable_875 := homalg_variable_871 - homalg_variable_874;;
gap> homalg_variable_876 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_875 = homalg_variable_876;
true
gap> homalg_variable_877 := SIH_Submatrix(homalg_variable_815,[1..1],[ 3, 4, 5, 6, 7 ]);;
gap> homalg_variable_878 := homalg_variable_350 - homalg_variable_877;;
gap> homalg_variable_879 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_878 = homalg_variable_879;
true
gap> homalg_variable_880 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_881 := SIH_UnionOfColumns(homalg_variable_171,homalg_variable_880);;
gap> homalg_variable_882 := homalg_variable_816 - homalg_variable_881;;
gap> homalg_variable_883 := SI_matrix(homalg_variable_5,2,9,"0");;
gap> homalg_variable_882 = homalg_variable_883;
true
gap> SIH_ZeroRows(homalg_variable_12);
[ 2 ]
gap> homalg_variable_885 := SIH_Submatrix(homalg_variable_12,[ 1, 3, 4, 5, 6 ],[1..4]);;
gap> homalg_variable_884 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_885);;
gap> SI_nrows(homalg_variable_884);
3
gap> homalg_variable_886 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_884 = homalg_variable_886;
false
gap> homalg_variable_887 := homalg_variable_884 * homalg_variable_885;;
gap> homalg_variable_888 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_887 = homalg_variable_888;
true
gap> homalg_variable_889 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_884);;
gap> SI_nrows(homalg_variable_889);
1
gap> homalg_variable_890 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_889 = homalg_variable_890;
false
gap> SIH_GetColumnIndependentUnitPositions(homalg_variable_889,[ 0 ]);
[  ]
gap> homalg_variable_891 := SIH_BasisOfRowModule(homalg_variable_884);;
gap> SI_nrows(homalg_variable_891);
3
gap> homalg_variable_892 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_891 = homalg_variable_892;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_884);; homalg_variable_893 := homalg_variable_l[1];; homalg_variable_894 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_893);
3
gap> homalg_variable_895 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_893 = homalg_variable_895;
false
gap> SI_ncols(homalg_variable_894);
3
gap> homalg_variable_896 := homalg_variable_894 * homalg_variable_884;;
gap> homalg_variable_893 = homalg_variable_896;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_891,homalg_variable_893);; homalg_variable_897 := homalg_variable_l[1];; homalg_variable_898 := homalg_variable_l[2];;
gap> homalg_variable_899 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_897 = homalg_variable_899;
true
gap> homalg_variable_900 := homalg_variable_898 * homalg_variable_893;;
gap> homalg_variable_901 := homalg_variable_891 + homalg_variable_900;;
gap> homalg_variable_897 = homalg_variable_901;
true
gap> homalg_variable_902 := SIH_DecideZeroRows(homalg_variable_891,homalg_variable_893);;
gap> homalg_variable_903 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_902 = homalg_variable_903;
true
gap> homalg_variable_904 := homalg_variable_898 * (homalg_variable_8);;
gap> homalg_variable_905 := homalg_variable_904 * homalg_variable_894;;
gap> homalg_variable_906 := homalg_variable_905 * homalg_variable_884;;
gap> homalg_variable_906 = homalg_variable_891;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_884,homalg_variable_891);; homalg_variable_907 := homalg_variable_l[1];; homalg_variable_908 := homalg_variable_l[2];;
gap> homalg_variable_909 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_907 = homalg_variable_909;
true
gap> homalg_variable_910 := homalg_variable_908 * homalg_variable_891;;
gap> homalg_variable_911 := homalg_variable_884 + homalg_variable_910;;
gap> homalg_variable_907 = homalg_variable_911;
true
gap> homalg_variable_912 := SIH_DecideZeroRows(homalg_variable_884,homalg_variable_891);;
gap> homalg_variable_913 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_912 = homalg_variable_913;
true
gap> homalg_variable_914 := homalg_variable_908 * (homalg_variable_8);;
gap> homalg_variable_915 := homalg_variable_914 * homalg_variable_891;;
gap> homalg_variable_915 = homalg_variable_884;
true
gap> homalg_variable_891 = homalg_variable_884;
true
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_885);; homalg_variable_916 := homalg_variable_l[1];; homalg_variable_917 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_916);
6
gap> homalg_variable_918 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_916 = homalg_variable_918;
false
gap> SI_ncols(homalg_variable_917);
5
gap> homalg_variable_919 := homalg_variable_917 * homalg_variable_885;;
gap> homalg_variable_916 = homalg_variable_919;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_12,homalg_variable_916);; homalg_variable_920 := homalg_variable_l[1];; homalg_variable_921 := homalg_variable_l[2];;
gap> homalg_variable_922 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_920 = homalg_variable_922;
true
gap> homalg_variable_923 := homalg_variable_921 * homalg_variable_916;;
gap> homalg_variable_924 := homalg_variable_12 + homalg_variable_923;;
gap> homalg_variable_920 = homalg_variable_924;
true
gap> homalg_variable_925 := SIH_DecideZeroRows(homalg_variable_12,homalg_variable_916);;
gap> homalg_variable_926 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_925 = homalg_variable_926;
true
gap> homalg_variable_927 := homalg_variable_921 * (homalg_variable_8);;
gap> homalg_variable_928 := homalg_variable_927 * homalg_variable_917;;
gap> homalg_variable_929 := homalg_variable_928 * homalg_variable_885;;
gap> homalg_variable_930 := homalg_variable_929 - homalg_variable_12;;
gap> homalg_variable_931 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_930 = homalg_variable_931;
true
gap> homalg_variable_933 := SIH_UnionOfRows(homalg_variable_928,homalg_variable_891);;
gap> homalg_variable_932 := SIH_BasisOfRowModule(homalg_variable_933);;
gap> SI_nrows(homalg_variable_932);
5
gap> homalg_variable_934 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_932 = homalg_variable_934;
false
gap> homalg_variable_935 := SIH_DecideZeroRows(homalg_variable_18,homalg_variable_932);;
gap> homalg_variable_936 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_935 = homalg_variable_936;
true
gap> homalg_variable_937 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_891);;
gap> SI_nrows(homalg_variable_937);
1
gap> homalg_variable_938 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_937 = homalg_variable_938;
false
gap> homalg_variable_939 := SIH_BasisOfRowModule(homalg_variable_937);;
gap> SI_nrows(homalg_variable_939);
1
gap> homalg_variable_940 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_939 = homalg_variable_940;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_937);; homalg_variable_941 := homalg_variable_l[1];; homalg_variable_942 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_941);
1
gap> homalg_variable_943 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_941 = homalg_variable_943;
false
gap> SI_ncols(homalg_variable_942);
1
gap> homalg_variable_944 := homalg_variable_942 * homalg_variable_937;;
gap> homalg_variable_941 = homalg_variable_944;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_939,homalg_variable_941);; homalg_variable_945 := homalg_variable_l[1];; homalg_variable_946 := homalg_variable_l[2];;
gap> homalg_variable_947 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_945 = homalg_variable_947;
true
gap> homalg_variable_948 := homalg_variable_946 * homalg_variable_941;;
gap> homalg_variable_949 := homalg_variable_939 + homalg_variable_948;;
gap> homalg_variable_945 = homalg_variable_949;
true
gap> homalg_variable_950 := SIH_DecideZeroRows(homalg_variable_939,homalg_variable_941);;
gap> homalg_variable_951 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_950 = homalg_variable_951;
true
gap> homalg_variable_952 := homalg_variable_946 * (homalg_variable_8);;
gap> homalg_variable_953 := homalg_variable_952 * homalg_variable_942;;
gap> homalg_variable_954 := homalg_variable_953 * homalg_variable_937;;
gap> homalg_variable_954 = homalg_variable_939;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_937,homalg_variable_939);; homalg_variable_955 := homalg_variable_l[1];; homalg_variable_956 := homalg_variable_l[2];;
gap> homalg_variable_957 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_955 = homalg_variable_957;
true
gap> homalg_variable_958 := homalg_variable_956 * homalg_variable_939;;
gap> homalg_variable_959 := homalg_variable_937 + homalg_variable_958;;
gap> homalg_variable_955 = homalg_variable_959;
true
gap> homalg_variable_960 := SIH_DecideZeroRows(homalg_variable_937,homalg_variable_939);;
gap> homalg_variable_961 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_960 = homalg_variable_961;
true
gap> homalg_variable_962 := homalg_variable_956 * (homalg_variable_8);;
gap> homalg_variable_963 := homalg_variable_962 * homalg_variable_939;;
gap> homalg_variable_963 = homalg_variable_937;
true
gap> homalg_variable_964 := homalg_variable_937 * homalg_variable_891;;
gap> homalg_variable_965 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_964 = homalg_variable_965;
true
gap> homalg_variable_939 = homalg_variable_937;
true
gap> homalg_variable_966 := SIH_DecideZeroRows(homalg_variable_928,homalg_variable_891);;
gap> homalg_variable_967 := SI_matrix(homalg_variable_5,6,5,"0");;
gap> homalg_variable_966 = homalg_variable_967;
false
gap> homalg_variable_968 := SI_matrix(homalg_variable_5,6,5,"0");;
gap> homalg_variable_928 = homalg_variable_968;
false
gap> homalg_variable_969 := SIH_UnionOfRows(homalg_variable_966,homalg_variable_891);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_969);; homalg_variable_970 := homalg_variable_l[1];; homalg_variable_971 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_970);
5
gap> homalg_variable_972 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_970 = homalg_variable_972;
false
gap> SI_ncols(homalg_variable_971);
9
gap> homalg_variable_973 := SIH_Submatrix(homalg_variable_971,[1..5],[ 1, 2, 3, 4, 5, 6 ]);;
gap> homalg_variable_974 := homalg_variable_973 * homalg_variable_966;;
gap> homalg_variable_975 := SIH_Submatrix(homalg_variable_971,[1..5],[ 7, 8, 9 ]);;
gap> homalg_variable_976 := homalg_variable_975 * homalg_variable_891;;
gap> homalg_variable_977 := homalg_variable_974 + homalg_variable_976;;
gap> homalg_variable_970 = homalg_variable_977;
true
gap> homalg_variable_978 := SIH_DecideZeroRows(homalg_variable_18,homalg_variable_891);;
gap> homalg_variable_979 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_978 = homalg_variable_979;
false
gap> homalg_variable_970 = homalg_variable_18;
true
gap> homalg_variable_981 := SIH_Submatrix(homalg_variable_971,[1..5],[ 1, 2, 3, 4, 5, 6 ]);;
gap> homalg_variable_982 := homalg_variable_978 * homalg_variable_981;;
gap> homalg_variable_983 := homalg_variable_982 * homalg_variable_928;;
gap> homalg_variable_984 := homalg_variable_983 - homalg_variable_18;;
gap> homalg_variable_980 := SIH_DecideZeroRows(homalg_variable_984,homalg_variable_891);;
gap> homalg_variable_985 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_980 = homalg_variable_985;
true
gap> homalg_variable_987 := homalg_variable_659 * homalg_variable_196;;
gap> homalg_variable_988 := homalg_variable_709 * homalg_variable_196;;
gap> homalg_variable_989 := SIH_UnionOfRows(homalg_variable_987,homalg_variable_988);;
gap> homalg_variable_990 := SIH_UnionOfRows(homalg_variable_989,homalg_variable_982);;
gap> homalg_variable_986 := SIH_BasisOfRowModule(homalg_variable_990);;
gap> SI_nrows(homalg_variable_986);
6
gap> homalg_variable_991 := SI_matrix(homalg_variable_5,6,6,"0");;
gap> homalg_variable_986 = homalg_variable_991;
false
gap> homalg_variable_993 := SI_matrix(SI_freemodule(homalg_variable_5,6));;
gap> homalg_variable_992 := SIH_DecideZeroRows(homalg_variable_993,homalg_variable_986);;
gap> homalg_variable_994 := SI_matrix(homalg_variable_5,6,6,"0");;
gap> homalg_variable_992 = homalg_variable_994;
true
gap> homalg_variable_995 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_990);;
gap> SI_nrows(homalg_variable_995);
8
gap> homalg_variable_996 := SI_matrix(homalg_variable_5,8,14,"0");;
gap> homalg_variable_995 = homalg_variable_996;
false
gap> homalg_variable_997 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_995);;
gap> SI_nrows(homalg_variable_997);
1
gap> homalg_variable_998 := SI_matrix(homalg_variable_5,1,8,"0");;
gap> homalg_variable_997 = homalg_variable_998;
true
gap> homalg_variable_999 := SIH_BasisOfRowModule(homalg_variable_995);;
gap> SI_nrows(homalg_variable_999);
12
gap> homalg_variable_1000 := SI_matrix(homalg_variable_5,12,14,"0");;
gap> homalg_variable_999 = homalg_variable_1000;
false
gap> for _del in [ "homalg_variable_496", "homalg_variable_498", "homalg_variable_501", "homalg_variable_502", "homalg_variable_503", "homalg_variable_504", "homalg_variable_505", "homalg_variable_506", "homalg_variable_507", "homalg_variable_508", "homalg_variable_509", "homalg_variable_510", "homalg_variable_511", "homalg_variable_512", "homalg_variable_513", "homalg_variable_514", "homalg_variable_515", "homalg_variable_516", "homalg_variable_517", "homalg_variable_518", "homalg_variable_519", "homalg_variable_520", "homalg_variable_521", "homalg_variable_522", "homalg_variable_524", "homalg_variable_527", "homalg_variable_528", "homalg_variable_531", "homalg_variable_532", "homalg_variable_533", "homalg_variable_535", "homalg_variable_538", "homalg_variable_539", "homalg_variable_540", "homalg_variable_541", "homalg_variable_542", "homalg_variable_543", "homalg_variable_544", "homalg_variable_545", "homalg_variable_546", "homalg_variable_547", "homalg_variable_548", "homalg_variable_549", "homalg_variable_550", "homalg_variable_551", "homalg_variable_552", "homalg_variable_553", "homalg_variable_554", "homalg_variable_555", "homalg_variable_556", "homalg_variable_557", "homalg_variable_559", "homalg_variable_560", "homalg_variable_561", "homalg_variable_564", "homalg_variable_569", "homalg_variable_570", "homalg_variable_571", "homalg_variable_573", "homalg_variable_574", "homalg_variable_575", "homalg_variable_577", "homalg_variable_580", "homalg_variable_581", "homalg_variable_584", "homalg_variable_585", "homalg_variable_586", "homalg_variable_591", "homalg_variable_592", "homalg_variable_593", "homalg_variable_594", "homalg_variable_595", "homalg_variable_596", "homalg_variable_597", "homalg_variable_598", "homalg_variable_599", "homalg_variable_600", "homalg_variable_602", "homalg_variable_604", "homalg_variable_605", "homalg_variable_606", "homalg_variable_607", "homalg_variable_608", "homalg_variable_610", "homalg_variable_611", "homalg_variable_612", "homalg_variable_614", "homalg_variable_615", "homalg_variable_616", "homalg_variable_617", "homalg_variable_619", "homalg_variable_620", "homalg_variable_621", "homalg_variable_622", "homalg_variable_623", "homalg_variable_624", "homalg_variable_625", "homalg_variable_627", "homalg_variable_630", "homalg_variable_631", "homalg_variable_632", "homalg_variable_633", "homalg_variable_634", "homalg_variable_635", "homalg_variable_636", "homalg_variable_637", "homalg_variable_638", "homalg_variable_639", "homalg_variable_640", "homalg_variable_641", "homalg_variable_645", "homalg_variable_646", "homalg_variable_647", "homalg_variable_648", "homalg_variable_650", "homalg_variable_651", "homalg_variable_653", "homalg_variable_654", "homalg_variable_655", "homalg_variable_656", "homalg_variable_657", "homalg_variable_660", "homalg_variable_661", "homalg_variable_662", "homalg_variable_663", "homalg_variable_664", "homalg_variable_665", "homalg_variable_669", "homalg_variable_670", "homalg_variable_671", "homalg_variable_672", "homalg_variable_673", "homalg_variable_674", "homalg_variable_677", "homalg_variable_678", "homalg_variable_679", "homalg_variable_680", "homalg_variable_681", "homalg_variable_688", "homalg_variable_689", "homalg_variable_690", "homalg_variable_691", "homalg_variable_692", "homalg_variable_693", "homalg_variable_694", "homalg_variable_695", "homalg_variable_696", "homalg_variable_698", "homalg_variable_699", "homalg_variable_700", "homalg_variable_701", "homalg_variable_702", "homalg_variable_703", "homalg_variable_706", "homalg_variable_707", "homalg_variable_710", "homalg_variable_711", "homalg_variable_712", "homalg_variable_716", "homalg_variable_717", "homalg_variable_718", "homalg_variable_720", "homalg_variable_722", "homalg_variable_723", "homalg_variable_725", "homalg_variable_727", "homalg_variable_730", "homalg_variable_731", "homalg_variable_732", "homalg_variable_733", "homalg_variable_734", "homalg_variable_735", "homalg_variable_736", "homalg_variable_737", "homalg_variable_738", "homalg_variable_739", "homalg_variable_740", "homalg_variable_741", "homalg_variable_742", "homalg_variable_745", "homalg_variable_746", "homalg_variable_747", "homalg_variable_748", "homalg_variable_749", "homalg_variable_752", "homalg_variable_753", "homalg_variable_754", "homalg_variable_755", "homalg_variable_757", "homalg_variable_759", "homalg_variable_760", "homalg_variable_761", "homalg_variable_762", "homalg_variable_763", "homalg_variable_766", "homalg_variable_767", "homalg_variable_768", "homalg_variable_773", "homalg_variable_774", "homalg_variable_775", "homalg_variable_776", "homalg_variable_777", "homalg_variable_780", "homalg_variable_781", "homalg_variable_782", "homalg_variable_783", "homalg_variable_784", "homalg_variable_787", "homalg_variable_788", "homalg_variable_789", "homalg_variable_792", "homalg_variable_793", "homalg_variable_794", "homalg_variable_795", "homalg_variable_796", "homalg_variable_797", "homalg_variable_798", "homalg_variable_799", "homalg_variable_801", "homalg_variable_802", "homalg_variable_803", "homalg_variable_804", "homalg_variable_805", "homalg_variable_806", "homalg_variable_808", "homalg_variable_809", "homalg_variable_812", "homalg_variable_813", "homalg_variable_814", "homalg_variable_819", "homalg_variable_821", "homalg_variable_824", "homalg_variable_825", "homalg_variable_826", "homalg_variable_827", "homalg_variable_828", "homalg_variable_829", "homalg_variable_830", "homalg_variable_831", "homalg_variable_832", "homalg_variable_833", "homalg_variable_834", "homalg_variable_835", "homalg_variable_836", "homalg_variable_837", "homalg_variable_838", "homalg_variable_839", "homalg_variable_840", "homalg_variable_841", "homalg_variable_842", "homalg_variable_843", "homalg_variable_844", "homalg_variable_846", "homalg_variable_848", "homalg_variable_849", "homalg_variable_850", "homalg_variable_851", "homalg_variable_852", "homalg_variable_854", "homalg_variable_855", "homalg_variable_856", "homalg_variable_858", "homalg_variable_859", "homalg_variable_861", "homalg_variable_864", "homalg_variable_865", "homalg_variable_866", "homalg_variable_867", "homalg_variable_868", "homalg_variable_869", "homalg_variable_870", "homalg_variable_871", "homalg_variable_872", "homalg_variable_873", "homalg_variable_874", "homalg_variable_875", "homalg_variable_876", "homalg_variable_877", "homalg_variable_878", "homalg_variable_879", "homalg_variable_880", "homalg_variable_881", "homalg_variable_882", "homalg_variable_883", "homalg_variable_886", "homalg_variable_887", "homalg_variable_888", "homalg_variable_890", "homalg_variable_892", "homalg_variable_895", "homalg_variable_896", "homalg_variable_899", "homalg_variable_902", "homalg_variable_903", "homalg_variable_906", "homalg_variable_907", "homalg_variable_908", "homalg_variable_909", "homalg_variable_910", "homalg_variable_911", "homalg_variable_912", "homalg_variable_913", "homalg_variable_914", "homalg_variable_915", "homalg_variable_918", "homalg_variable_919", "homalg_variable_922", "homalg_variable_923", "homalg_variable_924", "homalg_variable_929", "homalg_variable_930", "homalg_variable_931", "homalg_variable_934", "homalg_variable_935", "homalg_variable_936", "homalg_variable_938", "homalg_variable_940", "homalg_variable_943", "homalg_variable_944", "homalg_variable_947", "homalg_variable_948", "homalg_variable_949", "homalg_variable_954", "homalg_variable_955", "homalg_variable_956", "homalg_variable_957", "homalg_variable_958", "homalg_variable_959", "homalg_variable_960", "homalg_variable_961", "homalg_variable_962", "homalg_variable_963", "homalg_variable_964", "homalg_variable_965", "homalg_variable_966", "homalg_variable_967", "homalg_variable_968", "homalg_variable_969", "homalg_variable_970", "homalg_variable_972", "homalg_variable_973", "homalg_variable_974", "homalg_variable_975", "homalg_variable_976", "homalg_variable_977", "homalg_variable_979", "homalg_variable_980", "homalg_variable_983", "homalg_variable_984", "homalg_variable_985" ] do UnbindGlobal( _del ); od;;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_995);; homalg_variable_1001 := homalg_variable_l[1];; homalg_variable_1002 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1001);
12
gap> homalg_variable_1003 := SI_matrix(homalg_variable_5,12,14,"0");;
gap> homalg_variable_1001 = homalg_variable_1003;
false
gap> SI_ncols(homalg_variable_1002);
8
gap> homalg_variable_1004 := homalg_variable_1002 * homalg_variable_995;;
gap> homalg_variable_1001 = homalg_variable_1004;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_999,homalg_variable_1001);; homalg_variable_1005 := homalg_variable_l[1];; homalg_variable_1006 := homalg_variable_l[2];;
gap> homalg_variable_1007 := SI_matrix(homalg_variable_5,12,14,"0");;
gap> homalg_variable_1005 = homalg_variable_1007;
true
gap> homalg_variable_1008 := homalg_variable_1006 * homalg_variable_1001;;
gap> homalg_variable_1009 := homalg_variable_999 + homalg_variable_1008;;
gap> homalg_variable_1005 = homalg_variable_1009;
true
gap> homalg_variable_1010 := SIH_DecideZeroRows(homalg_variable_999,homalg_variable_1001);;
gap> homalg_variable_1011 := SI_matrix(homalg_variable_5,12,14,"0");;
gap> homalg_variable_1010 = homalg_variable_1011;
true
gap> homalg_variable_1012 := homalg_variable_1006 * (homalg_variable_8);;
gap> homalg_variable_1013 := homalg_variable_1012 * homalg_variable_1002;;
gap> homalg_variable_1014 := homalg_variable_1013 * homalg_variable_995;;
gap> homalg_variable_1014 = homalg_variable_999;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_995,homalg_variable_999);; homalg_variable_1015 := homalg_variable_l[1];; homalg_variable_1016 := homalg_variable_l[2];;
gap> homalg_variable_1017 := SI_matrix(homalg_variable_5,8,14,"0");;
gap> homalg_variable_1015 = homalg_variable_1017;
true
gap> homalg_variable_1018 := homalg_variable_1016 * homalg_variable_999;;
gap> homalg_variable_1019 := homalg_variable_995 + homalg_variable_1018;;
gap> homalg_variable_1015 = homalg_variable_1019;
true
gap> homalg_variable_1020 := SIH_DecideZeroRows(homalg_variable_995,homalg_variable_999);;
gap> homalg_variable_1021 := SI_matrix(homalg_variable_5,8,14,"0");;
gap> homalg_variable_1020 = homalg_variable_1021;
true
gap> homalg_variable_1022 := homalg_variable_1016 * (homalg_variable_8);;
gap> homalg_variable_1023 := homalg_variable_1022 * homalg_variable_999;;
gap> homalg_variable_1023 = homalg_variable_995;
true
gap> SIH_ZeroRows(homalg_variable_995);
[  ]
gap> SIH_ZeroRows(homalg_variable_891);
[  ]
gap> homalg_variable_1024 := homalg_variable_937 * homalg_variable_891;;
gap> homalg_variable_1025 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_1024 = homalg_variable_1025;
true
gap> homalg_variable_1026 := SIH_DecideZeroRows(homalg_variable_937,homalg_variable_939);;
gap> homalg_variable_1027 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1026 = homalg_variable_1027;
true
gap> homalg_variable_1028 := SI_matrix(homalg_variable_5,2,9,"0");;
gap> homalg_variable_816 = homalg_variable_1028;
false
gap> SIH_ZeroRows(homalg_variable_818);
[  ]
gap> homalg_variable_1029 := SIH_Submatrix(homalg_variable_815,[1..1],[ 1, 2 ]);;
gap> homalg_variable_1030 := homalg_variable_1029 * homalg_variable_816;;
gap> homalg_variable_1031 := SIH_Submatrix(homalg_variable_815,[1..1],[ 3, 4, 5, 6, 7 ]);;
gap> homalg_variable_1032 := homalg_variable_1031 * homalg_variable_817;;
gap> homalg_variable_1033 := homalg_variable_1030 + homalg_variable_1032;;
gap> homalg_variable_1034 := SI_matrix(homalg_variable_5,1,9,"0");;
gap> homalg_variable_1033 = homalg_variable_1034;
true
gap> homalg_variable_820 = homalg_variable_815;
true
gap> homalg_variable_1035 := SIH_DecideZeroRows(homalg_variable_815,homalg_variable_820);;
gap> homalg_variable_1036 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1035 = homalg_variable_1036;
true
gap> homalg_variable_1037 := SIH_Submatrix(homalg_variable_995,[1..8],[ 10, 11, 12, 13, 14 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1037,homalg_variable_891);; homalg_variable_1038 := homalg_variable_l[1];; homalg_variable_1039 := homalg_variable_l[2];;
gap> homalg_variable_1040 := SI_matrix(homalg_variable_5,8,5,"0");;
gap> homalg_variable_1038 = homalg_variable_1040;
true
gap> homalg_variable_1041 := homalg_variable_1039 * homalg_variable_891;;
gap> homalg_variable_1042 := homalg_variable_1037 + homalg_variable_1041;;
gap> homalg_variable_1038 = homalg_variable_1042;
true
gap> homalg_variable_1043 := SIH_DecideZeroRows(homalg_variable_1037,homalg_variable_891);;
gap> homalg_variable_1044 := SI_matrix(homalg_variable_5,8,5,"0");;
gap> homalg_variable_1043 = homalg_variable_1044;
true
gap> homalg_variable_1045 := homalg_variable_1039 * (homalg_variable_8);;
gap> homalg_variable_1046 := homalg_variable_1045 * homalg_variable_891;;
gap> homalg_variable_1047 := homalg_variable_1046 - homalg_variable_1037;;
gap> homalg_variable_1048 := SI_matrix(homalg_variable_5,8,5,"0");;
gap> homalg_variable_1047 = homalg_variable_1048;
true
gap> homalg_variable_1049 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_1050 := SIH_UnionOfColumns(homalg_variable_816,homalg_variable_1049);;
gap> homalg_variable_1051 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_1052 := SIH_UnionOfColumns(homalg_variable_817,homalg_variable_1051);;
gap> homalg_variable_1053 := SIH_UnionOfRows(homalg_variable_1050,homalg_variable_1052);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1053,homalg_variable_1001);; homalg_variable_1054 := homalg_variable_l[1];; homalg_variable_1055 := homalg_variable_l[2];;
gap> homalg_variable_1056 := SI_matrix(homalg_variable_5,7,14,"0");;
gap> homalg_variable_1054 = homalg_variable_1056;
true
gap> homalg_variable_1057 := homalg_variable_1055 * homalg_variable_1001;;
gap> homalg_variable_1058 := homalg_variable_1053 + homalg_variable_1057;;
gap> homalg_variable_1054 = homalg_variable_1058;
true
gap> homalg_variable_1059 := SIH_DecideZeroRows(homalg_variable_1053,homalg_variable_1001);;
gap> homalg_variable_1060 := SI_matrix(homalg_variable_5,7,14,"0");;
gap> homalg_variable_1059 = homalg_variable_1060;
true
gap> SI_ncols(homalg_variable_1002);
8
gap> SI_nrows(homalg_variable_1002);
12
gap> homalg_variable_1061 := homalg_variable_1055 * (homalg_variable_8);;
gap> homalg_variable_1062 := homalg_variable_1061 * homalg_variable_1002;;
gap> homalg_variable_1063 := homalg_variable_1062 * homalg_variable_995;;
gap> homalg_variable_1064 := homalg_variable_1063 - homalg_variable_1053;;
gap> homalg_variable_1065 := SI_matrix(homalg_variable_5,7,14,"0");;
gap> homalg_variable_1064 = homalg_variable_1065;
true
gap> homalg_variable_1066 := homalg_variable_820 * homalg_variable_1062;;
gap> homalg_variable_1067 := SI_matrix(homalg_variable_5,1,8,"0");;
gap> homalg_variable_1066 = homalg_variable_1067;
true
gap> homalg_variable_1068 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1062);;
gap> SI_nrows(homalg_variable_1068);
1
gap> homalg_variable_1069 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1068 = homalg_variable_1069;
false
gap> homalg_variable_1070 := SIH_BasisOfRowModule(homalg_variable_1068);;
gap> SI_nrows(homalg_variable_1070);
1
gap> homalg_variable_1071 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1070 = homalg_variable_1071;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1068);; homalg_variable_1072 := homalg_variable_l[1];; homalg_variable_1073 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1072);
1
gap> homalg_variable_1074 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1072 = homalg_variable_1074;
false
gap> SI_ncols(homalg_variable_1073);
1
gap> homalg_variable_1075 := homalg_variable_1073 * homalg_variable_1068;;
gap> homalg_variable_1072 = homalg_variable_1075;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1070,homalg_variable_1072);; homalg_variable_1076 := homalg_variable_l[1];; homalg_variable_1077 := homalg_variable_l[2];;
gap> homalg_variable_1078 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1076 = homalg_variable_1078;
true
gap> homalg_variable_1079 := homalg_variable_1077 * homalg_variable_1072;;
gap> homalg_variable_1080 := homalg_variable_1070 + homalg_variable_1079;;
gap> homalg_variable_1076 = homalg_variable_1080;
true
gap> homalg_variable_1081 := SIH_DecideZeroRows(homalg_variable_1070,homalg_variable_1072);;
gap> homalg_variable_1082 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1081 = homalg_variable_1082;
true
gap> homalg_variable_1083 := homalg_variable_1077 * (homalg_variable_8);;
gap> homalg_variable_1084 := homalg_variable_1083 * homalg_variable_1073;;
gap> homalg_variable_1085 := homalg_variable_1084 * homalg_variable_1068;;
gap> homalg_variable_1085 = homalg_variable_1070;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1068,homalg_variable_1070);; homalg_variable_1086 := homalg_variable_l[1];; homalg_variable_1087 := homalg_variable_l[2];;
gap> homalg_variable_1088 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1086 = homalg_variable_1088;
true
gap> homalg_variable_1089 := homalg_variable_1087 * homalg_variable_1070;;
gap> homalg_variable_1090 := homalg_variable_1068 + homalg_variable_1089;;
gap> homalg_variable_1086 = homalg_variable_1090;
true
gap> homalg_variable_1091 := SIH_DecideZeroRows(homalg_variable_1068,homalg_variable_1070);;
gap> homalg_variable_1092 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1091 = homalg_variable_1092;
true
gap> homalg_variable_1093 := homalg_variable_1087 * (homalg_variable_8);;
gap> homalg_variable_1094 := homalg_variable_1093 * homalg_variable_1070;;
gap> homalg_variable_1094 = homalg_variable_1068;
true
gap> homalg_variable_1095 := SIH_DecideZeroRows(homalg_variable_1068,homalg_variable_820);;
gap> homalg_variable_1096 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1095 = homalg_variable_1096;
true
gap> homalg_variable_1098 := SIH_UnionOfRows(homalg_variable_1045,homalg_variable_939);;
gap> homalg_variable_1097 := SIH_BasisOfRowModule(homalg_variable_1098);;
gap> SI_nrows(homalg_variable_1097);
3
gap> homalg_variable_1099 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1097 = homalg_variable_1099;
false
gap> homalg_variable_1101 := SI_matrix(SI_freemodule(homalg_variable_5,3));;
gap> homalg_variable_1100 := SIH_DecideZeroRows(homalg_variable_1101,homalg_variable_1097);;
gap> homalg_variable_1102 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1100 = homalg_variable_1102;
true
gap> homalg_variable_1104 := SIH_UnionOfRows(homalg_variable_1101,homalg_variable_939);;
gap> homalg_variable_1103 := SIH_BasisOfRowModule(homalg_variable_1104);;
gap> SI_nrows(homalg_variable_1103);
3
gap> homalg_variable_1105 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1103 = homalg_variable_1105;
false
gap> homalg_variable_1106 := SIH_DecideZeroRows(homalg_variable_1101,homalg_variable_1103);;
gap> homalg_variable_1107 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1106 = homalg_variable_1107;
true
gap> homalg_variable_1109 := SI_matrix(SI_freemodule(homalg_variable_5,7));;
gap> homalg_variable_1110 := SIH_UnionOfRows(homalg_variable_1109,homalg_variable_820);;
gap> homalg_variable_1108 := SIH_BasisOfRowModule(homalg_variable_1110);;
gap> SI_nrows(homalg_variable_1108);
7
gap> homalg_variable_1111 := SI_matrix(homalg_variable_5,7,7,"0");;
gap> homalg_variable_1108 = homalg_variable_1111;
false
gap> homalg_variable_1112 := SIH_DecideZeroRows(homalg_variable_1109,homalg_variable_1108);;
gap> homalg_variable_1113 := SI_matrix(homalg_variable_5,7,7,"0");;
gap> homalg_variable_1112 = homalg_variable_1113;
true
gap> homalg_variable_1114 := SIH_DecideZeroRows(homalg_variable_1045,homalg_variable_939);;
gap> homalg_variable_1115 := SI_matrix(homalg_variable_5,8,3,"0");;
gap> homalg_variable_1114 = homalg_variable_1115;
false
gap> homalg_variable_1116 := SI_matrix(homalg_variable_5,8,3,"0");;
gap> homalg_variable_1039 = homalg_variable_1116;
false
gap> homalg_variable_1117 := SIH_UnionOfRows(homalg_variable_1114,homalg_variable_939);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1117);; homalg_variable_1118 := homalg_variable_l[1];; homalg_variable_1119 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1118);
3
gap> homalg_variable_1120 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1118 = homalg_variable_1120;
false
gap> SI_ncols(homalg_variable_1119);
9
gap> homalg_variable_1121 := SIH_Submatrix(homalg_variable_1119,[1..3],[ 1, 2, 3, 4, 5, 6, 7, 8 ]);;
gap> homalg_variable_1122 := homalg_variable_1121 * homalg_variable_1114;;
gap> homalg_variable_1123 := SIH_Submatrix(homalg_variable_1119,[1..3],[ 9 ]);;
gap> homalg_variable_1124 := homalg_variable_1123 * homalg_variable_939;;
gap> homalg_variable_1125 := homalg_variable_1122 + homalg_variable_1124;;
gap> homalg_variable_1118 = homalg_variable_1125;
true
gap> homalg_variable_1126 := SIH_DecideZeroRows(homalg_variable_1101,homalg_variable_939);;
gap> homalg_variable_1127 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1126 = homalg_variable_1127;
false
gap> homalg_variable_1118 = homalg_variable_1101;
true
gap> homalg_variable_1129 := SIH_Submatrix(homalg_variable_1119,[1..3],[ 1, 2, 3, 4, 5, 6, 7, 8 ]);;
gap> homalg_variable_1130 := homalg_variable_1126 * homalg_variable_1129;;
gap> homalg_variable_1131 := homalg_variable_1130 * homalg_variable_1045;;
gap> homalg_variable_1132 := homalg_variable_1131 - homalg_variable_1101;;
gap> homalg_variable_1128 := SIH_DecideZeroRows(homalg_variable_1132,homalg_variable_939);;
gap> homalg_variable_1133 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1128 = homalg_variable_1133;
true
gap> homalg_variable_1135 := homalg_variable_1062 * homalg_variable_995;;
gap> homalg_variable_1136 := homalg_variable_1130 * homalg_variable_995;;
gap> homalg_variable_1137 := SIH_UnionOfRows(homalg_variable_1135,homalg_variable_1136);;
gap> homalg_variable_1134 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1137);;
gap> SI_nrows(homalg_variable_1134);
2
gap> homalg_variable_1138 := SI_matrix(homalg_variable_5,2,10,"0");;
gap> homalg_variable_1134 = homalg_variable_1138;
false
gap> homalg_variable_1139 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1134);;
gap> SI_nrows(homalg_variable_1139);
1
gap> homalg_variable_1140 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_1139 = homalg_variable_1140;
true
gap> homalg_variable_1141 := SIH_BasisOfRowModule(homalg_variable_1134);;
gap> SI_nrows(homalg_variable_1141);
2
gap> homalg_variable_1142 := SI_matrix(homalg_variable_5,2,10,"0");;
gap> homalg_variable_1141 = homalg_variable_1142;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1134);; homalg_variable_1143 := homalg_variable_l[1];; homalg_variable_1144 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1143);
2
gap> homalg_variable_1145 := SI_matrix(homalg_variable_5,2,10,"0");;
gap> homalg_variable_1143 = homalg_variable_1145;
false
gap> SI_ncols(homalg_variable_1144);
2
gap> homalg_variable_1146 := homalg_variable_1144 * homalg_variable_1134;;
gap> homalg_variable_1143 = homalg_variable_1146;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1141,homalg_variable_1143);; homalg_variable_1147 := homalg_variable_l[1];; homalg_variable_1148 := homalg_variable_l[2];;
gap> homalg_variable_1149 := SI_matrix(homalg_variable_5,2,10,"0");;
gap> homalg_variable_1147 = homalg_variable_1149;
true
gap> homalg_variable_1150 := homalg_variable_1148 * homalg_variable_1143;;
gap> homalg_variable_1151 := homalg_variable_1141 + homalg_variable_1150;;
gap> homalg_variable_1147 = homalg_variable_1151;
true
gap> homalg_variable_1152 := SIH_DecideZeroRows(homalg_variable_1141,homalg_variable_1143);;
gap> homalg_variable_1153 := SI_matrix(homalg_variable_5,2,10,"0");;
gap> homalg_variable_1152 = homalg_variable_1153;
true
gap> homalg_variable_1154 := homalg_variable_1148 * (homalg_variable_8);;
gap> homalg_variable_1155 := homalg_variable_1154 * homalg_variable_1144;;
gap> homalg_variable_1156 := homalg_variable_1155 * homalg_variable_1134;;
gap> homalg_variable_1156 = homalg_variable_1141;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1134,homalg_variable_1141);; homalg_variable_1157 := homalg_variable_l[1];; homalg_variable_1158 := homalg_variable_l[2];;
gap> homalg_variable_1159 := SI_matrix(homalg_variable_5,2,10,"0");;
gap> homalg_variable_1157 = homalg_variable_1159;
true
gap> homalg_variable_1160 := homalg_variable_1158 * homalg_variable_1141;;
gap> homalg_variable_1161 := homalg_variable_1134 + homalg_variable_1160;;
gap> homalg_variable_1157 = homalg_variable_1161;
true
gap> homalg_variable_1162 := SIH_DecideZeroRows(homalg_variable_1134,homalg_variable_1141);;
gap> homalg_variable_1163 := SI_matrix(homalg_variable_5,2,10,"0");;
gap> homalg_variable_1162 = homalg_variable_1163;
true
gap> homalg_variable_1164 := homalg_variable_1158 * (homalg_variable_8);;
gap> homalg_variable_1165 := homalg_variable_1164 * homalg_variable_1141;;
gap> homalg_variable_1165 = homalg_variable_1134;
true
gap> SIH_ZeroRows(homalg_variable_1134);
[  ]
gap> homalg_variable_1166 := SIH_Submatrix(homalg_variable_1134,[1..2],[ 8, 9, 10 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1166,homalg_variable_937);; homalg_variable_1167 := homalg_variable_l[1];; homalg_variable_1168 := homalg_variable_l[2];;
gap> homalg_variable_1169 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_1167 = homalg_variable_1169;
true
gap> homalg_variable_1170 := homalg_variable_1168 * homalg_variable_937;;
gap> homalg_variable_1171 := homalg_variable_1166 + homalg_variable_1170;;
gap> homalg_variable_1167 = homalg_variable_1171;
true
gap> homalg_variable_1172 := SIH_DecideZeroRows(homalg_variable_1166,homalg_variable_939);;
gap> homalg_variable_1173 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_1172 = homalg_variable_1173;
true
gap> homalg_variable_1174 := homalg_variable_1168 * (homalg_variable_8);;
gap> homalg_variable_1175 := homalg_variable_1174 * homalg_variable_937;;
gap> homalg_variable_1176 := homalg_variable_1175 - homalg_variable_1166;;
gap> homalg_variable_1177 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_1176 = homalg_variable_1177;
true
gap> homalg_variable_1178 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1179 := SIH_UnionOfColumns(homalg_variable_815,homalg_variable_1178);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1179,homalg_variable_1143);; homalg_variable_1180 := homalg_variable_l[1];; homalg_variable_1181 := homalg_variable_l[2];;
gap> homalg_variable_1182 := SI_matrix(homalg_variable_5,1,10,"0");;
gap> homalg_variable_1180 = homalg_variable_1182;
true
gap> homalg_variable_1183 := homalg_variable_1181 * homalg_variable_1143;;
gap> homalg_variable_1184 := homalg_variable_1179 + homalg_variable_1183;;
gap> homalg_variable_1180 = homalg_variable_1184;
true
gap> homalg_variable_1185 := SIH_DecideZeroRows(homalg_variable_1179,homalg_variable_1143);;
gap> homalg_variable_1186 := SI_matrix(homalg_variable_5,1,10,"0");;
gap> homalg_variable_1185 = homalg_variable_1186;
true
gap> SI_ncols(homalg_variable_1144);
2
gap> SI_nrows(homalg_variable_1144);
2
gap> homalg_variable_1187 := homalg_variable_1181 * (homalg_variable_8);;
gap> homalg_variable_1188 := homalg_variable_1187 * homalg_variable_1144;;
gap> homalg_variable_1189 := homalg_variable_1188 * homalg_variable_1134;;
gap> homalg_variable_1190 := homalg_variable_1189 - homalg_variable_1179;;
gap> homalg_variable_1191 := SI_matrix(homalg_variable_5,1,10,"0");;
gap> homalg_variable_1190 = homalg_variable_1191;
true
gap> homalg_variable_1192 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1188);;
gap> SI_nrows(homalg_variable_1192);
1
gap> homalg_variable_1193 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_1192 = homalg_variable_1193;
true
gap> homalg_variable_1194 := SIH_BasisOfRowModule(homalg_variable_1174);;
gap> SI_nrows(homalg_variable_1194);
1
gap> homalg_variable_1195 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_1194 = homalg_variable_1195;
false
gap> homalg_variable_1196 := SIH_DecideZeroRows(homalg_variable_860,homalg_variable_1194);;
gap> homalg_variable_1197 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_1196 = homalg_variable_1197;
true
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1174);; homalg_variable_1198 := homalg_variable_l[1];; homalg_variable_1199 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1198);
1
gap> homalg_variable_1200 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_1198 = homalg_variable_1200;
false
gap> SI_ncols(homalg_variable_1199);
2
gap> homalg_variable_1201 := homalg_variable_1199 * homalg_variable_1174;;
gap> homalg_variable_1198 = homalg_variable_1201;
true
gap> homalg_variable_1198 = homalg_variable_860;
true
gap> homalg_variable_1202 := homalg_variable_1199 * homalg_variable_1174;;
gap> homalg_variable_1203 := homalg_variable_1202 - homalg_variable_860;;
gap> homalg_variable_1204 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_1203 = homalg_variable_1204;
true
gap> homalg_variable_1206 := homalg_variable_1188 * homalg_variable_1134;;
gap> homalg_variable_1207 := homalg_variable_1199 * homalg_variable_1134;;
gap> homalg_variable_1208 := SIH_UnionOfRows(homalg_variable_1206,homalg_variable_1207);;
gap> homalg_variable_1205 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1208);;
gap> SI_nrows(homalg_variable_1205);
1
gap> homalg_variable_1209 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_1205 = homalg_variable_1209;
true
gap> homalg_variable_1210 := SIH_Submatrix(homalg_variable_1206,[1..1],[ 1, 2, 3, 4, 5, 6, 7 ]);;
gap> homalg_variable_1211 := homalg_variable_1210 * homalg_variable_1135;;
gap> homalg_variable_1212 := SIH_Submatrix(homalg_variable_1207,[1..1],[ 1, 2, 3, 4, 5, 6, 7 ]);;
gap> homalg_variable_1213 := homalg_variable_1212 * homalg_variable_1135;;
gap> homalg_variable_1214 := SIH_UnionOfRows(homalg_variable_1211,homalg_variable_1213);;
gap> homalg_variable_1215 := SIH_Submatrix(homalg_variable_1206,[1..1],[ 8, 9, 10 ]);;
gap> homalg_variable_1216 := homalg_variable_1215 * homalg_variable_1136;;
gap> homalg_variable_1217 := SIH_Submatrix(homalg_variable_1207,[1..1],[ 8, 9, 10 ]);;
gap> homalg_variable_1218 := homalg_variable_1217 * homalg_variable_1136;;
gap> homalg_variable_1219 := SIH_UnionOfRows(homalg_variable_1216,homalg_variable_1218);;
gap> homalg_variable_1220 := homalg_variable_1214 + homalg_variable_1219;;
gap> homalg_variable_1221 := SI_matrix(homalg_variable_5,2,14,"0");;
gap> homalg_variable_1220 = homalg_variable_1221;
true
gap> homalg_variable_1222 := SI_matrix(homalg_variable_5,7,5,"0");;
gap> homalg_variable_1223 := SIH_UnionOfRows(homalg_variable_1222,homalg_variable_891);;
gap> homalg_variable_1224 := SIH_Submatrix(homalg_variable_1135,[1..7],[ 10, 11, 12, 13, 14 ]);;
gap> homalg_variable_1225 := SIH_Submatrix(homalg_variable_1136,[1..3],[ 10, 11, 12, 13, 14 ]);;
gap> homalg_variable_1226 := SIH_UnionOfRows(homalg_variable_1224,homalg_variable_1225);;
gap> homalg_variable_1227 := homalg_variable_1223 - homalg_variable_1226;;
gap> homalg_variable_1228 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_1227 = homalg_variable_1228;
true
gap> homalg_variable_1229 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1230 := SIH_UnionOfRows(homalg_variable_1229,homalg_variable_937);;
gap> homalg_variable_1231 := SIH_Submatrix(homalg_variable_1206,[1..1],[ 8, 9, 10 ]);;
gap> homalg_variable_1232 := SIH_Submatrix(homalg_variable_1207,[1..1],[ 8, 9, 10 ]);;
gap> homalg_variable_1233 := SIH_UnionOfRows(homalg_variable_1231,homalg_variable_1232);;
gap> homalg_variable_1234 := homalg_variable_1230 - homalg_variable_1233;;
gap> homalg_variable_1235 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_1234 = homalg_variable_1235;
true
gap> homalg_variable_1236 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_1237 := SIH_UnionOfColumns(homalg_variable_816,homalg_variable_1236);;
gap> homalg_variable_1238 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_1239 := SIH_UnionOfColumns(homalg_variable_817,homalg_variable_1238);;
gap> homalg_variable_1240 := SIH_UnionOfRows(homalg_variable_1237,homalg_variable_1239);;
gap> homalg_variable_1241 := homalg_variable_1135 - homalg_variable_1240;;
gap> homalg_variable_1242 := SI_matrix(homalg_variable_5,7,14,"0");;
gap> homalg_variable_1241 = homalg_variable_1242;
true
gap> homalg_variable_1243 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1244 := SIH_UnionOfColumns(homalg_variable_815,homalg_variable_1243);;
gap> homalg_variable_1245 := homalg_variable_1206 - homalg_variable_1244;;
gap> homalg_variable_1246 := SI_matrix(homalg_variable_5,1,10,"0");;
gap> homalg_variable_1245 = homalg_variable_1246;
true
gap> SIH_ZeroRows(homalg_variable_271);
[  ]
gap> homalg_variable_271 = homalg_variable_705;
false
gap> homalg_variable_1247 := homalg_variable_273 * homalg_variable_271;;
gap> homalg_variable_1248 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1247 = homalg_variable_1248;
true
gap> homalg_variable_1249 := SIH_BasisOfRowModule(homalg_variable_273);;
gap> SI_nrows(homalg_variable_1249);
1
gap> homalg_variable_1250 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1249 = homalg_variable_1250;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_273);; homalg_variable_1251 := homalg_variable_l[1];; homalg_variable_1252 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1251);
1
gap> homalg_variable_1253 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1251 = homalg_variable_1253;
false
gap> SI_ncols(homalg_variable_1252);
1
gap> homalg_variable_1254 := homalg_variable_1252 * homalg_variable_273;;
gap> homalg_variable_1251 = homalg_variable_1254;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1249,homalg_variable_1251);; homalg_variable_1255 := homalg_variable_l[1];; homalg_variable_1256 := homalg_variable_l[2];;
gap> homalg_variable_1257 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1255 = homalg_variable_1257;
true
gap> homalg_variable_1258 := homalg_variable_1256 * homalg_variable_1251;;
gap> homalg_variable_1259 := homalg_variable_1249 + homalg_variable_1258;;
gap> homalg_variable_1255 = homalg_variable_1259;
true
gap> homalg_variable_1260 := SIH_DecideZeroRows(homalg_variable_1249,homalg_variable_1251);;
gap> homalg_variable_1261 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1260 = homalg_variable_1261;
true
gap> homalg_variable_1262 := homalg_variable_1256 * (homalg_variable_8);;
gap> homalg_variable_1263 := homalg_variable_1262 * homalg_variable_1252;;
gap> homalg_variable_1264 := homalg_variable_1263 * homalg_variable_273;;
gap> homalg_variable_1264 = homalg_variable_1249;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_273,homalg_variable_1249);; homalg_variable_1265 := homalg_variable_l[1];; homalg_variable_1266 := homalg_variable_l[2];;
gap> homalg_variable_1267 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1265 = homalg_variable_1267;
true
gap> homalg_variable_1268 := homalg_variable_1266 * homalg_variable_1249;;
gap> homalg_variable_1269 := homalg_variable_273 + homalg_variable_1268;;
gap> homalg_variable_1265 = homalg_variable_1269;
true
gap> homalg_variable_1270 := SIH_DecideZeroRows(homalg_variable_273,homalg_variable_1249);;
gap> homalg_variable_1271 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1270 = homalg_variable_1271;
true
gap> homalg_variable_1272 := homalg_variable_1266 * (homalg_variable_8);;
gap> homalg_variable_1273 := homalg_variable_1272 * homalg_variable_1249;;
gap> homalg_variable_1273 = homalg_variable_273;
true
gap> homalg_variable_1249 = homalg_variable_273;
true
gap> homalg_variable_1274 := SIH_DecideZeroRows(homalg_variable_273,homalg_variable_1249);;
gap> homalg_variable_1275 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1274 = homalg_variable_1275;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_885,homalg_variable_277);; homalg_variable_1276 := homalg_variable_l[1];; homalg_variable_1277 := homalg_variable_l[2];;
gap> homalg_variable_1278 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_1276 = homalg_variable_1278;
true
gap> homalg_variable_1279 := homalg_variable_1277 * homalg_variable_277;;
gap> homalg_variable_1280 := homalg_variable_885 + homalg_variable_1279;;
gap> homalg_variable_1276 = homalg_variable_1280;
true
gap> homalg_variable_1281 := SIH_DecideZeroRows(homalg_variable_885,homalg_variable_277);;
gap> homalg_variable_1282 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_1281 = homalg_variable_1282;
true
gap> SI_ncols(homalg_variable_278);
4
gap> SI_nrows(homalg_variable_278);
4
gap> homalg_variable_1283 := homalg_variable_1277 * (homalg_variable_8);;
gap> homalg_variable_1284 := homalg_variable_1283 * homalg_variable_278;;
gap> homalg_variable_1285 := homalg_variable_1284 * homalg_variable_271;;
gap> homalg_variable_1286 := homalg_variable_1285 - homalg_variable_885;;
gap> homalg_variable_1287 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_1286 = homalg_variable_1287;
true
gap> homalg_variable_1289 := homalg_variable_891 * homalg_variable_1284;;
gap> homalg_variable_1288 := SIH_DecideZeroRows(homalg_variable_1289,homalg_variable_1249);;
gap> homalg_variable_1290 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_1288 = homalg_variable_1290;
true
gap> homalg_variable_1291 := SIH_DecideZeroRows(homalg_variable_306,homalg_variable_301);;
gap> homalg_variable_1292 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_1291 = homalg_variable_1292;
false
gap> homalg_variable_1293 := SIH_UnionOfRows(homalg_variable_1291,homalg_variable_301);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1293);; homalg_variable_1294 := homalg_variable_l[1];; homalg_variable_1295 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1294);
4
gap> homalg_variable_1296 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1294 = homalg_variable_1296;
false
gap> SI_ncols(homalg_variable_1295);
8
gap> homalg_variable_1297 := SIH_Submatrix(homalg_variable_1295,[1..4],[ 1, 2 ]);;
gap> homalg_variable_1298 := homalg_variable_1297 * homalg_variable_1291;;
gap> homalg_variable_1299 := SIH_Submatrix(homalg_variable_1295,[1..4],[ 3, 4, 5, 6, 7, 8 ]);;
gap> homalg_variable_1300 := homalg_variable_1299 * homalg_variable_301;;
gap> homalg_variable_1301 := homalg_variable_1298 + homalg_variable_1300;;
gap> homalg_variable_1294 = homalg_variable_1301;
true
gap> homalg_variable_1294 = homalg_variable_705;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_303,homalg_variable_1294);; homalg_variable_1302 := homalg_variable_l[1];; homalg_variable_1303 := homalg_variable_l[2];;
gap> homalg_variable_1304 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1302 = homalg_variable_1304;
true
gap> homalg_variable_1305 := homalg_variable_1303 * homalg_variable_1294;;
gap> homalg_variable_1306 := homalg_variable_303 + homalg_variable_1305;;
gap> homalg_variable_1302 = homalg_variable_1306;
true
gap> homalg_variable_1307 := SIH_DecideZeroRows(homalg_variable_303,homalg_variable_1294);;
gap> homalg_variable_1308 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1307 = homalg_variable_1308;
true
gap> homalg_variable_1310 := homalg_variable_1303 * (homalg_variable_8);;
gap> homalg_variable_1311 := SIH_Submatrix(homalg_variable_1295,[1..4],[ 1, 2 ]);;
gap> homalg_variable_1312 := homalg_variable_1310 * homalg_variable_1311;;
gap> homalg_variable_1313 := homalg_variable_1312 * homalg_variable_306;;
gap> homalg_variable_1314 := homalg_variable_1313 - homalg_variable_271;;
gap> homalg_variable_1309 := SIH_DecideZeroRows(homalg_variable_1314,homalg_variable_301);;
gap> homalg_variable_1315 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1309 = homalg_variable_1315;
true
gap> homalg_variable_1317 := homalg_variable_1249 * homalg_variable_1312;;
gap> homalg_variable_1316 := SIH_DecideZeroRows(homalg_variable_1317,homalg_variable_344);;
gap> homalg_variable_1318 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_1316 = homalg_variable_1318;
true
gap> homalg_variable_1319 := SIH_DecideZeroRows(homalg_variable_1312,homalg_variable_344);;
gap> homalg_variable_1320 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_1319 = homalg_variable_1320;
false
gap> homalg_variable_1321 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_1312 = homalg_variable_1321;
false
gap> homalg_variable_1322 := SIH_UnionOfRows(homalg_variable_1319,homalg_variable_344);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1322);; homalg_variable_1323 := homalg_variable_l[1];; homalg_variable_1324 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1323);
2
gap> homalg_variable_1325 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_1323 = homalg_variable_1325;
false
gap> SI_ncols(homalg_variable_1324);
9
gap> homalg_variable_1326 := SIH_Submatrix(homalg_variable_1324,[1..2],[ 1, 2, 3, 4 ]);;
gap> homalg_variable_1327 := homalg_variable_1326 * homalg_variable_1319;;
gap> homalg_variable_1328 := SIH_Submatrix(homalg_variable_1324,[1..2],[ 5, 6, 7, 8, 9 ]);;
gap> homalg_variable_1329 := homalg_variable_1328 * homalg_variable_344;;
gap> homalg_variable_1330 := homalg_variable_1327 + homalg_variable_1329;;
gap> homalg_variable_1323 = homalg_variable_1330;
true
gap> homalg_variable_1331 := SIH_DecideZeroRows(homalg_variable_618,homalg_variable_344);;
gap> homalg_variable_1332 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_1331 = homalg_variable_1332;
false
gap> homalg_variable_1323 = homalg_variable_618;
true
gap> homalg_variable_1334 := SIH_Submatrix(homalg_variable_1324,[1..2],[ 1, 2, 3, 4 ]);;
gap> homalg_variable_1335 := homalg_variable_1331 * homalg_variable_1334;;
gap> homalg_variable_1336 := homalg_variable_1335 * homalg_variable_1312;;
gap> homalg_variable_1337 := homalg_variable_1336 - homalg_variable_618;;
gap> homalg_variable_1333 := SIH_DecideZeroRows(homalg_variable_1337,homalg_variable_344);;
gap> homalg_variable_1338 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_1333 = homalg_variable_1338;
true
gap> homalg_variable_1340 := SIH_UnionOfRows(homalg_variable_1284,homalg_variable_1335);;
gap> homalg_variable_1341 := SIH_UnionOfRows(homalg_variable_1340,homalg_variable_1249);;
gap> homalg_variable_1339 := SIH_BasisOfRowModule(homalg_variable_1341);;
gap> SI_nrows(homalg_variable_1339);
4
gap> homalg_variable_1342 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1339 = homalg_variable_1342;
false
gap> homalg_variable_1343 := SIH_DecideZeroRows(homalg_variable_705,homalg_variable_1339);;
gap> homalg_variable_1344 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1343 = homalg_variable_1344;
true
gap> homalg_variable_1345 := SIH_RelativeSyzygiesGeneratorsOfRows(homalg_variable_1340,homalg_variable_1249);;
gap> SI_nrows(homalg_variable_1345);
5
gap> homalg_variable_1346 := SI_matrix(homalg_variable_5,5,7,"0");;
gap> homalg_variable_1345 = homalg_variable_1346;
false
gap> homalg_variable_1347 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1345);;
gap> SI_nrows(homalg_variable_1347);
1
gap> homalg_variable_1348 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_1347 = homalg_variable_1348;
false
gap> SIH_GetColumnIndependentUnitPositions(homalg_variable_1347,[ 0 ]);
[ [ 1, 2 ] ]
gap> homalg_variable_1350 := SIH_Submatrix(homalg_variable_1345,[ 1, 3, 4, 5 ],[1..7]);;
gap> homalg_variable_1349 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1350);;
gap> SI_nrows(homalg_variable_1349);
1
gap> homalg_variable_1351 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1349 = homalg_variable_1351;
true
gap> homalg_variable_1352 := SIH_BasisOfRowModule(homalg_variable_1345);;
gap> SI_nrows(homalg_variable_1352);
5
gap> homalg_variable_1353 := SI_matrix(homalg_variable_5,5,7,"0");;
gap> homalg_variable_1352 = homalg_variable_1353;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1350);; homalg_variable_1354 := homalg_variable_l[1];; homalg_variable_1355 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1354);
5
gap> homalg_variable_1356 := SI_matrix(homalg_variable_5,5,7,"0");;
gap> homalg_variable_1354 = homalg_variable_1356;
false
gap> SI_ncols(homalg_variable_1355);
4
gap> homalg_variable_1357 := homalg_variable_1355 * homalg_variable_1350;;
gap> homalg_variable_1354 = homalg_variable_1357;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1352,homalg_variable_1354);; homalg_variable_1358 := homalg_variable_l[1];; homalg_variable_1359 := homalg_variable_l[2];;
gap> homalg_variable_1360 := SI_matrix(homalg_variable_5,5,7,"0");;
gap> homalg_variable_1358 = homalg_variable_1360;
true
gap> homalg_variable_1361 := homalg_variable_1359 * homalg_variable_1354;;
gap> homalg_variable_1362 := homalg_variable_1352 + homalg_variable_1361;;
gap> homalg_variable_1358 = homalg_variable_1362;
true
gap> homalg_variable_1363 := SIH_DecideZeroRows(homalg_variable_1352,homalg_variable_1354);;
gap> homalg_variable_1364 := SI_matrix(homalg_variable_5,5,7,"0");;
gap> homalg_variable_1363 = homalg_variable_1364;
true
gap> homalg_variable_1365 := homalg_variable_1359 * (homalg_variable_8);;
gap> homalg_variable_1366 := homalg_variable_1365 * homalg_variable_1355;;
gap> homalg_variable_1367 := homalg_variable_1366 * homalg_variable_1350;;
gap> homalg_variable_1367 = homalg_variable_1352;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1350,homalg_variable_1352);; homalg_variable_1368 := homalg_variable_l[1];; homalg_variable_1369 := homalg_variable_l[2];;
gap> homalg_variable_1370 := SI_matrix(homalg_variable_5,4,7,"0");;
gap> homalg_variable_1368 = homalg_variable_1370;
true
gap> homalg_variable_1371 := homalg_variable_1369 * homalg_variable_1352;;
gap> homalg_variable_1372 := homalg_variable_1350 + homalg_variable_1371;;
gap> homalg_variable_1368 = homalg_variable_1372;
true
gap> homalg_variable_1373 := SIH_DecideZeroRows(homalg_variable_1350,homalg_variable_1352);;
gap> homalg_variable_1374 := SI_matrix(homalg_variable_5,4,7,"0");;
gap> homalg_variable_1373 = homalg_variable_1374;
true
gap> homalg_variable_1375 := homalg_variable_1369 * (homalg_variable_8);;
gap> homalg_variable_1376 := homalg_variable_1375 * homalg_variable_1352;;
gap> homalg_variable_1376 = homalg_variable_1350;
true
gap> SIH_ZeroRows(homalg_variable_1350);
[  ]
gap> SIH_ZeroRows(homalg_variable_407);
[  ]
gap> homalg_variable_1377 := homalg_variable_406 * homalg_variable_407;;
gap> homalg_variable_1378 := SI_matrix(homalg_variable_5,3,2,"0");;
gap> homalg_variable_1377 = homalg_variable_1378;
true
gap> homalg_variable_1379 := SIH_DecideZeroRows(homalg_variable_406,homalg_variable_435);;
gap> homalg_variable_1380 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_1379 = homalg_variable_1380;
true
gap> homalg_variable_1381 := SIH_Submatrix(homalg_variable_1350,[1..4],[ 6, 7 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1381,homalg_variable_410);; homalg_variable_1382 := homalg_variable_l[1];; homalg_variable_1383 := homalg_variable_l[2];;
gap> homalg_variable_1384 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_1382 = homalg_variable_1384;
true
gap> homalg_variable_1385 := homalg_variable_1383 * homalg_variable_410;;
gap> homalg_variable_1386 := homalg_variable_1381 + homalg_variable_1385;;
gap> homalg_variable_1382 = homalg_variable_1386;
true
gap> homalg_variable_1387 := SIH_DecideZeroRows(homalg_variable_1381,homalg_variable_410);;
gap> homalg_variable_1388 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_1387 = homalg_variable_1388;
true
gap> SI_ncols(homalg_variable_411);
4
gap> SI_nrows(homalg_variable_411);
5
gap> homalg_variable_1389 := homalg_variable_1383 * (homalg_variable_8);;
gap> homalg_variable_1390 := homalg_variable_1389 * homalg_variable_411;;
gap> homalg_variable_1391 := homalg_variable_1390 * homalg_variable_407;;
gap> homalg_variable_1392 := homalg_variable_1391 - homalg_variable_1381;;
gap> homalg_variable_1393 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_1392 = homalg_variable_1393;
true
gap> homalg_variable_1394 := SI_matrix(homalg_variable_5,3,2,"0");;
gap> homalg_variable_1395 := SIH_UnionOfColumns(homalg_variable_891,homalg_variable_1394);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1395,homalg_variable_1354);; homalg_variable_1396 := homalg_variable_l[1];; homalg_variable_1397 := homalg_variable_l[2];;
gap> homalg_variable_1398 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_1396 = homalg_variable_1398;
true
gap> homalg_variable_1399 := homalg_variable_1397 * homalg_variable_1354;;
gap> homalg_variable_1400 := homalg_variable_1395 + homalg_variable_1399;;
gap> homalg_variable_1396 = homalg_variable_1400;
true
gap> homalg_variable_1401 := SIH_DecideZeroRows(homalg_variable_1395,homalg_variable_1354);;
gap> homalg_variable_1402 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_1401 = homalg_variable_1402;
true
gap> SI_ncols(homalg_variable_1355);
4
gap> SI_nrows(homalg_variable_1355);
5
gap> homalg_variable_1403 := homalg_variable_1397 * (homalg_variable_8);;
gap> homalg_variable_1404 := homalg_variable_1403 * homalg_variable_1355;;
gap> homalg_variable_1405 := homalg_variable_1404 * homalg_variable_1350;;
gap> homalg_variable_1406 := homalg_variable_1405 - homalg_variable_1395;;
gap> homalg_variable_1407 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_1406 = homalg_variable_1407;
true
gap> homalg_variable_1408 := homalg_variable_939 * homalg_variable_1404;;
gap> homalg_variable_1409 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1408 = homalg_variable_1409;
true
gap> homalg_variable_1410 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1404);;
gap> SI_nrows(homalg_variable_1410);
1
gap> homalg_variable_1411 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1410 = homalg_variable_1411;
false
gap> homalg_variable_1412 := SIH_BasisOfRowModule(homalg_variable_1410);;
gap> SI_nrows(homalg_variable_1412);
1
gap> homalg_variable_1413 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1412 = homalg_variable_1413;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1410);; homalg_variable_1414 := homalg_variable_l[1];; homalg_variable_1415 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1414);
1
gap> homalg_variable_1416 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1414 = homalg_variable_1416;
false
gap> SI_ncols(homalg_variable_1415);
1
gap> homalg_variable_1417 := homalg_variable_1415 * homalg_variable_1410;;
gap> homalg_variable_1414 = homalg_variable_1417;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1412,homalg_variable_1414);; homalg_variable_1418 := homalg_variable_l[1];; homalg_variable_1419 := homalg_variable_l[2];;
gap> homalg_variable_1420 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1418 = homalg_variable_1420;
true
gap> homalg_variable_1421 := homalg_variable_1419 * homalg_variable_1414;;
gap> homalg_variable_1422 := homalg_variable_1412 + homalg_variable_1421;;
gap> homalg_variable_1418 = homalg_variable_1422;
true
gap> homalg_variable_1423 := SIH_DecideZeroRows(homalg_variable_1412,homalg_variable_1414);;
gap> homalg_variable_1424 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1423 = homalg_variable_1424;
true
gap> homalg_variable_1425 := homalg_variable_1419 * (homalg_variable_8);;
gap> homalg_variable_1426 := homalg_variable_1425 * homalg_variable_1415;;
gap> homalg_variable_1427 := homalg_variable_1426 * homalg_variable_1410;;
gap> homalg_variable_1427 = homalg_variable_1412;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1410,homalg_variable_1412);; homalg_variable_1428 := homalg_variable_l[1];; homalg_variable_1429 := homalg_variable_l[2];;
gap> homalg_variable_1430 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1428 = homalg_variable_1430;
true
gap> homalg_variable_1431 := homalg_variable_1429 * homalg_variable_1412;;
gap> homalg_variable_1432 := homalg_variable_1410 + homalg_variable_1431;;
gap> homalg_variable_1428 = homalg_variable_1432;
true
gap> homalg_variable_1433 := SIH_DecideZeroRows(homalg_variable_1410,homalg_variable_1412);;
gap> homalg_variable_1434 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1433 = homalg_variable_1434;
true
gap> homalg_variable_1435 := homalg_variable_1429 * (homalg_variable_8);;
gap> homalg_variable_1436 := homalg_variable_1435 * homalg_variable_1412;;
gap> homalg_variable_1436 = homalg_variable_1410;
true
gap> homalg_variable_1437 := SIH_DecideZeroRows(homalg_variable_1410,homalg_variable_939);;
gap> homalg_variable_1438 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1437 = homalg_variable_1438;
true
gap> homalg_variable_1440 := SIH_UnionOfRows(homalg_variable_1390,homalg_variable_435);;
gap> homalg_variable_1439 := SIH_BasisOfRowModule(homalg_variable_1440);;
gap> SI_nrows(homalg_variable_1439);
4
gap> homalg_variable_1441 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1439 = homalg_variable_1441;
false
gap> homalg_variable_1442 := SIH_DecideZeroRows(homalg_variable_705,homalg_variable_1439);;
gap> homalg_variable_1443 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1442 = homalg_variable_1443;
true
gap> homalg_variable_1445 := SIH_UnionOfRows(homalg_variable_705,homalg_variable_435);;
gap> homalg_variable_1444 := SIH_BasisOfRowModule(homalg_variable_1445);;
gap> SI_nrows(homalg_variable_1444);
4
gap> homalg_variable_1446 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1444 = homalg_variable_1446;
false
gap> homalg_variable_1447 := SIH_DecideZeroRows(homalg_variable_705,homalg_variable_1444);;
gap> homalg_variable_1448 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1447 = homalg_variable_1448;
true
gap> homalg_variable_1449 := SIH_DecideZeroRows(homalg_variable_1390,homalg_variable_435);;
gap> homalg_variable_1450 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1449 = homalg_variable_1450;
false
gap> homalg_variable_1451 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1390 = homalg_variable_1451;
false
gap> homalg_variable_1452 := SIH_UnionOfRows(homalg_variable_1449,homalg_variable_435);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1452);; homalg_variable_1453 := homalg_variable_l[1];; homalg_variable_1454 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1453);
4
gap> homalg_variable_1455 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1453 = homalg_variable_1455;
false
gap> SI_ncols(homalg_variable_1454);
7
gap> homalg_variable_1456 := SIH_Submatrix(homalg_variable_1454,[1..4],[ 1, 2, 3, 4 ]);;
gap> homalg_variable_1457 := homalg_variable_1456 * homalg_variable_1449;;
gap> homalg_variable_1458 := SIH_Submatrix(homalg_variable_1454,[1..4],[ 5, 6, 7 ]);;
gap> homalg_variable_1459 := homalg_variable_1458 * homalg_variable_435;;
gap> homalg_variable_1460 := homalg_variable_1457 + homalg_variable_1459;;
gap> homalg_variable_1453 = homalg_variable_1460;
true
gap> homalg_variable_1461 := SIH_DecideZeroRows(homalg_variable_705,homalg_variable_435);;
gap> homalg_variable_1462 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1461 = homalg_variable_1462;
false
gap> homalg_variable_1453 = homalg_variable_705;
true
gap> homalg_variable_1464 := SIH_Submatrix(homalg_variable_1454,[1..4],[ 1, 2, 3, 4 ]);;
gap> homalg_variable_1465 := homalg_variable_1461 * homalg_variable_1464;;
gap> homalg_variable_1466 := homalg_variable_1465 * homalg_variable_1390;;
gap> homalg_variable_1467 := homalg_variable_1466 - homalg_variable_705;;
gap> homalg_variable_1463 := SIH_DecideZeroRows(homalg_variable_1467,homalg_variable_435);;
gap> homalg_variable_1468 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1463 = homalg_variable_1468;
true
gap> homalg_variable_1470 := homalg_variable_1404 * homalg_variable_1350;;
gap> homalg_variable_1471 := homalg_variable_1465 * homalg_variable_1350;;
gap> homalg_variable_1472 := SIH_UnionOfRows(homalg_variable_1470,homalg_variable_1471);;
gap> homalg_variable_1469 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1472);;
gap> SI_nrows(homalg_variable_1469);
3
gap> homalg_variable_1473 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_1469 = homalg_variable_1473;
false
gap> homalg_variable_1474 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1469);;
gap> SI_nrows(homalg_variable_1474);
1
gap> homalg_variable_1475 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1474 = homalg_variable_1475;
true
gap> homalg_variable_1476 := SIH_BasisOfRowModule(homalg_variable_1469);;
gap> SI_nrows(homalg_variable_1476);
4
gap> homalg_variable_1477 := SI_matrix(homalg_variable_5,4,7,"0");;
gap> homalg_variable_1476 = homalg_variable_1477;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1469);; homalg_variable_1478 := homalg_variable_l[1];; homalg_variable_1479 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1478);
4
gap> homalg_variable_1480 := SI_matrix(homalg_variable_5,4,7,"0");;
gap> homalg_variable_1478 = homalg_variable_1480;
false
gap> SI_ncols(homalg_variable_1479);
3
gap> homalg_variable_1481 := homalg_variable_1479 * homalg_variable_1469;;
gap> homalg_variable_1478 = homalg_variable_1481;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1476,homalg_variable_1478);; homalg_variable_1482 := homalg_variable_l[1];; homalg_variable_1483 := homalg_variable_l[2];;
gap> homalg_variable_1484 := SI_matrix(homalg_variable_5,4,7,"0");;
gap> homalg_variable_1482 = homalg_variable_1484;
true
gap> homalg_variable_1485 := homalg_variable_1483 * homalg_variable_1478;;
gap> homalg_variable_1486 := homalg_variable_1476 + homalg_variable_1485;;
gap> homalg_variable_1482 = homalg_variable_1486;
true
gap> homalg_variable_1487 := SIH_DecideZeroRows(homalg_variable_1476,homalg_variable_1478);;
gap> homalg_variable_1488 := SI_matrix(homalg_variable_5,4,7,"0");;
gap> homalg_variable_1487 = homalg_variable_1488;
true
gap> homalg_variable_1489 := homalg_variable_1483 * (homalg_variable_8);;
gap> homalg_variable_1490 := homalg_variable_1489 * homalg_variable_1479;;
gap> homalg_variable_1491 := homalg_variable_1490 * homalg_variable_1469;;
gap> homalg_variable_1491 = homalg_variable_1476;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1469,homalg_variable_1476);; homalg_variable_1492 := homalg_variable_l[1];; homalg_variable_1493 := homalg_variable_l[2];;
gap> homalg_variable_1494 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_1492 = homalg_variable_1494;
true
gap> homalg_variable_1495 := homalg_variable_1493 * homalg_variable_1476;;
gap> homalg_variable_1496 := homalg_variable_1469 + homalg_variable_1495;;
gap> homalg_variable_1492 = homalg_variable_1496;
true
gap> homalg_variable_1497 := SIH_DecideZeroRows(homalg_variable_1469,homalg_variable_1476);;
gap> homalg_variable_1498 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_1497 = homalg_variable_1498;
true
gap> homalg_variable_1499 := homalg_variable_1493 * (homalg_variable_8);;
gap> homalg_variable_1500 := homalg_variable_1499 * homalg_variable_1476;;
gap> homalg_variable_1500 = homalg_variable_1469;
true
gap> SIH_ZeroRows(homalg_variable_1469);
[  ]
gap> SIH_ZeroRows(homalg_variable_406);
[  ]
gap> for _del in [ "homalg_variable_991", "homalg_variable_992", "homalg_variable_993", "homalg_variable_994", "homalg_variable_996", "homalg_variable_997", "homalg_variable_998", "homalg_variable_1000", "homalg_variable_1003", "homalg_variable_1004", "homalg_variable_1008", "homalg_variable_1009", "homalg_variable_1010", "homalg_variable_1011", "homalg_variable_1014", "homalg_variable_1015", "homalg_variable_1016", "homalg_variable_1017", "homalg_variable_1018", "homalg_variable_1019", "homalg_variable_1020", "homalg_variable_1021", "homalg_variable_1022", "homalg_variable_1023", "homalg_variable_1024", "homalg_variable_1025", "homalg_variable_1026", "homalg_variable_1027", "homalg_variable_1028", "homalg_variable_1029", "homalg_variable_1030", "homalg_variable_1031", "homalg_variable_1032", "homalg_variable_1033", "homalg_variable_1034", "homalg_variable_1036", "homalg_variable_1038", "homalg_variable_1040", "homalg_variable_1041", "homalg_variable_1042", "homalg_variable_1043", "homalg_variable_1044", "homalg_variable_1046", "homalg_variable_1047", "homalg_variable_1048", "homalg_variable_1056", "homalg_variable_1059", "homalg_variable_1060", "homalg_variable_1063", "homalg_variable_1064", "homalg_variable_1065", "homalg_variable_1066", "homalg_variable_1067", "homalg_variable_1069", "homalg_variable_1071", "homalg_variable_1074", "homalg_variable_1075", "homalg_variable_1078", "homalg_variable_1079", "homalg_variable_1080", "homalg_variable_1085", "homalg_variable_1086", "homalg_variable_1087", "homalg_variable_1088", "homalg_variable_1089", "homalg_variable_1090", "homalg_variable_1091", "homalg_variable_1092", "homalg_variable_1093", "homalg_variable_1094", "homalg_variable_1095", "homalg_variable_1096", "homalg_variable_1099", "homalg_variable_1100", "homalg_variable_1102", "homalg_variable_1105", "homalg_variable_1106", "homalg_variable_1107", "homalg_variable_1111", "homalg_variable_1112", "homalg_variable_1113", "homalg_variable_1115", "homalg_variable_1116", "homalg_variable_1120", "homalg_variable_1121", "homalg_variable_1122", "homalg_variable_1123", "homalg_variable_1124", "homalg_variable_1125", "homalg_variable_1127", "homalg_variable_1138", "homalg_variable_1139", "homalg_variable_1140", "homalg_variable_1142", "homalg_variable_1145", "homalg_variable_1146", "homalg_variable_1149", "homalg_variable_1150", "homalg_variable_1151", "homalg_variable_1153", "homalg_variable_1156", "homalg_variable_1157", "homalg_variable_1158", "homalg_variable_1159", "homalg_variable_1160", "homalg_variable_1161", "homalg_variable_1162", "homalg_variable_1163", "homalg_variable_1164", "homalg_variable_1165", "homalg_variable_1167", "homalg_variable_1169", "homalg_variable_1170", "homalg_variable_1171", "homalg_variable_1172", "homalg_variable_1173", "homalg_variable_1175", "homalg_variable_1176", "homalg_variable_1177", "homalg_variable_1182", "homalg_variable_1185", "homalg_variable_1186", "homalg_variable_1189", "homalg_variable_1190", "homalg_variable_1191", "homalg_variable_1192", "homalg_variable_1193", "homalg_variable_1195", "homalg_variable_1196", "homalg_variable_1197", "homalg_variable_1200", "homalg_variable_1201", "homalg_variable_1202", "homalg_variable_1203", "homalg_variable_1204", "homalg_variable_1205", "homalg_variable_1209", "homalg_variable_1221", "homalg_variable_1222", "homalg_variable_1223", "homalg_variable_1224", "homalg_variable_1225", "homalg_variable_1226", "homalg_variable_1227", "homalg_variable_1228", "homalg_variable_1229", "homalg_variable_1230", "homalg_variable_1231", "homalg_variable_1232", "homalg_variable_1233", "homalg_variable_1234", "homalg_variable_1235", "homalg_variable_1236", "homalg_variable_1237", "homalg_variable_1238", "homalg_variable_1239", "homalg_variable_1240", "homalg_variable_1241", "homalg_variable_1242", "homalg_variable_1243", "homalg_variable_1244", "homalg_variable_1245", "homalg_variable_1246", "homalg_variable_1247", "homalg_variable_1248", "homalg_variable_1250", "homalg_variable_1253", "homalg_variable_1254", "homalg_variable_1257", "homalg_variable_1258", "homalg_variable_1259", "homalg_variable_1260", "homalg_variable_1261", "homalg_variable_1264", "homalg_variable_1267", "homalg_variable_1268", "homalg_variable_1269", "homalg_variable_1270", "homalg_variable_1271", "homalg_variable_1274", "homalg_variable_1275", "homalg_variable_1276", "homalg_variable_1278", "homalg_variable_1279", "homalg_variable_1280", "homalg_variable_1281", "homalg_variable_1282", "homalg_variable_1285", "homalg_variable_1286", "homalg_variable_1287", "homalg_variable_1288", "homalg_variable_1289", "homalg_variable_1290", "homalg_variable_1292", "homalg_variable_1296", "homalg_variable_1297", "homalg_variable_1298", "homalg_variable_1299", "homalg_variable_1300", "homalg_variable_1301", "homalg_variable_1304", "homalg_variable_1305", "homalg_variable_1306", "homalg_variable_1307", "homalg_variable_1308", "homalg_variable_1316", "homalg_variable_1317", "homalg_variable_1318", "homalg_variable_1320", "homalg_variable_1321", "homalg_variable_1325", "homalg_variable_1326", "homalg_variable_1327", "homalg_variable_1328", "homalg_variable_1329", "homalg_variable_1330", "homalg_variable_1332", "homalg_variable_1333", "homalg_variable_1336", "homalg_variable_1337", "homalg_variable_1338", "homalg_variable_1342", "homalg_variable_1343", "homalg_variable_1344", "homalg_variable_1346", "homalg_variable_1348", "homalg_variable_1349", "homalg_variable_1351", "homalg_variable_1353", "homalg_variable_1356", "homalg_variable_1357", "homalg_variable_1361", "homalg_variable_1362", "homalg_variable_1363", "homalg_variable_1364", "homalg_variable_1367", "homalg_variable_1370", "homalg_variable_1371", "homalg_variable_1372", "homalg_variable_1373", "homalg_variable_1374", "homalg_variable_1377", "homalg_variable_1378", "homalg_variable_1379", "homalg_variable_1380", "homalg_variable_1384", "homalg_variable_1385", "homalg_variable_1386", "homalg_variable_1387", "homalg_variable_1388", "homalg_variable_1391", "homalg_variable_1392", "homalg_variable_1393", "homalg_variable_1399", "homalg_variable_1400", "homalg_variable_1401", "homalg_variable_1402", "homalg_variable_1405", "homalg_variable_1406", "homalg_variable_1407", "homalg_variable_1408", "homalg_variable_1409", "homalg_variable_1411", "homalg_variable_1413", "homalg_variable_1416", "homalg_variable_1417", "homalg_variable_1420", "homalg_variable_1421", "homalg_variable_1422", "homalg_variable_1423", "homalg_variable_1424", "homalg_variable_1428", "homalg_variable_1429", "homalg_variable_1430", "homalg_variable_1431", "homalg_variable_1432", "homalg_variable_1433", "homalg_variable_1434", "homalg_variable_1435", "homalg_variable_1436", "homalg_variable_1441", "homalg_variable_1442", "homalg_variable_1443", "homalg_variable_1446", "homalg_variable_1448", "homalg_variable_1450", "homalg_variable_1451", "homalg_variable_1455", "homalg_variable_1456", "homalg_variable_1457", "homalg_variable_1458", "homalg_variable_1459", "homalg_variable_1460", "homalg_variable_1462", "homalg_variable_1463", "homalg_variable_1466", "homalg_variable_1467", "homalg_variable_1468", "homalg_variable_1473", "homalg_variable_1475", "homalg_variable_1477", "homalg_variable_1480", "homalg_variable_1481", "homalg_variable_1484", "homalg_variable_1485", "homalg_variable_1486", "homalg_variable_1488", "homalg_variable_1491", "homalg_variable_1494", "homalg_variable_1495", "homalg_variable_1496", "homalg_variable_1497", "homalg_variable_1498" ] do UnbindGlobal( _del ); od;;
gap> homalg_variable_1501 := homalg_variable_433 * homalg_variable_406;;
gap> homalg_variable_1502 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1501 = homalg_variable_1502;
true
gap> homalg_variable_1503 := SIH_DecideZeroRows(homalg_variable_433,homalg_variable_460);;
gap> homalg_variable_1504 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1503 = homalg_variable_1504;
true
gap> homalg_variable_1505 := SIH_Submatrix(homalg_variable_1469,[1..3],[ 4, 5, 6, 7 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1505,homalg_variable_406);; homalg_variable_1506 := homalg_variable_l[1];; homalg_variable_1507 := homalg_variable_l[2];;
gap> homalg_variable_1508 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_1506 = homalg_variable_1508;
true
gap> homalg_variable_1509 := homalg_variable_1507 * homalg_variable_406;;
gap> homalg_variable_1510 := homalg_variable_1505 + homalg_variable_1509;;
gap> homalg_variable_1506 = homalg_variable_1510;
true
gap> homalg_variable_1511 := SIH_DecideZeroRows(homalg_variable_1505,homalg_variable_435);;
gap> homalg_variable_1512 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_1511 = homalg_variable_1512;
true
gap> homalg_variable_1513 := homalg_variable_1507 * (homalg_variable_8);;
gap> homalg_variable_1514 := homalg_variable_1513 * homalg_variable_406;;
gap> homalg_variable_1515 := homalg_variable_1514 - homalg_variable_1505;;
gap> homalg_variable_1516 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_1515 = homalg_variable_1516;
true
gap> homalg_variable_1517 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1518 := SIH_UnionOfColumns(homalg_variable_937,homalg_variable_1517);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1518,homalg_variable_1478);; homalg_variable_1519 := homalg_variable_l[1];; homalg_variable_1520 := homalg_variable_l[2];;
gap> homalg_variable_1521 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1519 = homalg_variable_1521;
true
gap> homalg_variable_1522 := homalg_variable_1520 * homalg_variable_1478;;
gap> homalg_variable_1523 := homalg_variable_1518 + homalg_variable_1522;;
gap> homalg_variable_1519 = homalg_variable_1523;
true
gap> homalg_variable_1524 := SIH_DecideZeroRows(homalg_variable_1518,homalg_variable_1478);;
gap> homalg_variable_1525 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1524 = homalg_variable_1525;
true
gap> SI_ncols(homalg_variable_1479);
3
gap> SI_nrows(homalg_variable_1479);
4
gap> homalg_variable_1526 := homalg_variable_1520 * (homalg_variable_8);;
gap> homalg_variable_1527 := homalg_variable_1526 * homalg_variable_1479;;
gap> homalg_variable_1528 := homalg_variable_1527 * homalg_variable_1469;;
gap> homalg_variable_1529 := homalg_variable_1528 - homalg_variable_1518;;
gap> homalg_variable_1530 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1529 = homalg_variable_1530;
true
gap> homalg_variable_1531 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1527);;
gap> SI_nrows(homalg_variable_1531);
1
gap> homalg_variable_1532 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_1531 = homalg_variable_1532;
true
gap> homalg_variable_1534 := SIH_UnionOfRows(homalg_variable_1513,homalg_variable_460);;
gap> homalg_variable_1533 := SIH_BasisOfRowModule(homalg_variable_1534);;
gap> SI_nrows(homalg_variable_1533);
3
gap> homalg_variable_1535 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1533 = homalg_variable_1535;
false
gap> homalg_variable_1536 := SIH_DecideZeroRows(homalg_variable_1101,homalg_variable_1533);;
gap> homalg_variable_1537 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1536 = homalg_variable_1537;
true
gap> homalg_variable_1539 := SIH_UnionOfRows(homalg_variable_1101,homalg_variable_460);;
gap> homalg_variable_1538 := SIH_BasisOfRowModule(homalg_variable_1539);;
gap> SI_nrows(homalg_variable_1538);
3
gap> homalg_variable_1540 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1538 = homalg_variable_1540;
false
gap> homalg_variable_1541 := SIH_DecideZeroRows(homalg_variable_1101,homalg_variable_1538);;
gap> homalg_variable_1542 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1541 = homalg_variable_1542;
true
gap> homalg_variable_1543 := SIH_DecideZeroRows(homalg_variable_1513,homalg_variable_460);;
gap> homalg_variable_1544 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1543 = homalg_variable_1544;
false
gap> homalg_variable_1545 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1507 = homalg_variable_1545;
false
gap> homalg_variable_1546 := SIH_UnionOfRows(homalg_variable_1543,homalg_variable_460);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1546);; homalg_variable_1547 := homalg_variable_l[1];; homalg_variable_1548 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1547);
3
gap> homalg_variable_1549 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1547 = homalg_variable_1549;
false
gap> SI_ncols(homalg_variable_1548);
4
gap> homalg_variable_1550 := SIH_Submatrix(homalg_variable_1548,[1..3],[ 1, 2, 3 ]);;
gap> homalg_variable_1551 := homalg_variable_1550 * homalg_variable_1543;;
gap> homalg_variable_1552 := SIH_Submatrix(homalg_variable_1548,[1..3],[ 4 ]);;
gap> homalg_variable_1553 := homalg_variable_1552 * homalg_variable_460;;
gap> homalg_variable_1554 := homalg_variable_1551 + homalg_variable_1553;;
gap> homalg_variable_1547 = homalg_variable_1554;
true
gap> homalg_variable_1555 := SIH_DecideZeroRows(homalg_variable_1101,homalg_variable_460);;
gap> homalg_variable_1556 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1555 = homalg_variable_1556;
false
gap> homalg_variable_1547 = homalg_variable_1101;
true
gap> homalg_variable_1558 := SIH_Submatrix(homalg_variable_1548,[1..3],[ 1, 2, 3 ]);;
gap> homalg_variable_1559 := homalg_variable_1555 * homalg_variable_1558;;
gap> homalg_variable_1560 := homalg_variable_1559 * homalg_variable_1513;;
gap> homalg_variable_1561 := homalg_variable_1560 - homalg_variable_1101;;
gap> homalg_variable_1557 := SIH_DecideZeroRows(homalg_variable_1561,homalg_variable_460);;
gap> homalg_variable_1562 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1557 = homalg_variable_1562;
true
gap> homalg_variable_1564 := homalg_variable_1527 * homalg_variable_1469;;
gap> homalg_variable_1565 := homalg_variable_1559 * homalg_variable_1469;;
gap> homalg_variable_1566 := SIH_UnionOfRows(homalg_variable_1564,homalg_variable_1565);;
gap> homalg_variable_1563 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1566);;
gap> SI_nrows(homalg_variable_1563);
1
gap> homalg_variable_1567 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1563 = homalg_variable_1567;
false
gap> homalg_variable_1568 := SIH_BasisOfRowModule(homalg_variable_1563);;
gap> SI_nrows(homalg_variable_1568);
1
gap> homalg_variable_1569 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1568 = homalg_variable_1569;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1563);; homalg_variable_1570 := homalg_variable_l[1];; homalg_variable_1571 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1570);
1
gap> homalg_variable_1572 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1570 = homalg_variable_1572;
false
gap> SI_ncols(homalg_variable_1571);
1
gap> homalg_variable_1573 := homalg_variable_1571 * homalg_variable_1563;;
gap> homalg_variable_1570 = homalg_variable_1573;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1568,homalg_variable_1570);; homalg_variable_1574 := homalg_variable_l[1];; homalg_variable_1575 := homalg_variable_l[2];;
gap> homalg_variable_1576 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1574 = homalg_variable_1576;
true
gap> homalg_variable_1577 := homalg_variable_1575 * homalg_variable_1570;;
gap> homalg_variable_1578 := homalg_variable_1568 + homalg_variable_1577;;
gap> homalg_variable_1574 = homalg_variable_1578;
true
gap> homalg_variable_1579 := SIH_DecideZeroRows(homalg_variable_1568,homalg_variable_1570);;
gap> homalg_variable_1580 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1579 = homalg_variable_1580;
true
gap> homalg_variable_1581 := homalg_variable_1575 * (homalg_variable_8);;
gap> homalg_variable_1582 := homalg_variable_1581 * homalg_variable_1571;;
gap> homalg_variable_1583 := homalg_variable_1582 * homalg_variable_1563;;
gap> homalg_variable_1583 = homalg_variable_1568;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1563,homalg_variable_1568);; homalg_variable_1584 := homalg_variable_l[1];; homalg_variable_1585 := homalg_variable_l[2];;
gap> homalg_variable_1586 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1584 = homalg_variable_1586;
true
gap> homalg_variable_1587 := homalg_variable_1585 * homalg_variable_1568;;
gap> homalg_variable_1588 := homalg_variable_1563 + homalg_variable_1587;;
gap> homalg_variable_1584 = homalg_variable_1588;
true
gap> homalg_variable_1589 := SIH_DecideZeroRows(homalg_variable_1563,homalg_variable_1568);;
gap> homalg_variable_1590 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1589 = homalg_variable_1590;
true
gap> homalg_variable_1591 := homalg_variable_1585 * (homalg_variable_8);;
gap> homalg_variable_1592 := homalg_variable_1591 * homalg_variable_1568;;
gap> homalg_variable_1592 = homalg_variable_1563;
true
gap> homalg_variable_1593 := SIH_Submatrix(homalg_variable_1563,[1..1],[ 2, 3, 4 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1593,homalg_variable_433);; homalg_variable_1594 := homalg_variable_l[1];; homalg_variable_1595 := homalg_variable_l[2];;
gap> homalg_variable_1596 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1594 = homalg_variable_1596;
true
gap> homalg_variable_1597 := homalg_variable_1595 * homalg_variable_433;;
gap> homalg_variable_1598 := homalg_variable_1593 + homalg_variable_1597;;
gap> homalg_variable_1594 = homalg_variable_1598;
true
gap> homalg_variable_1599 := SIH_DecideZeroRows(homalg_variable_1593,homalg_variable_460);;
gap> homalg_variable_1600 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1599 = homalg_variable_1600;
true
gap> homalg_variable_1601 := homalg_variable_1595 * (homalg_variable_8);;
gap> homalg_variable_1602 := homalg_variable_1601 * homalg_variable_433;;
gap> homalg_variable_1603 := homalg_variable_1602 - homalg_variable_1593;;
gap> homalg_variable_1604 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1603 = homalg_variable_1604;
true
gap> homalg_variable_1605 := SIH_BasisOfRowModule(homalg_variable_1601);;
gap> SI_nrows(homalg_variable_1605);
1
gap> homalg_variable_1606 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_1605 = homalg_variable_1606;
false
gap> homalg_variable_1605 = homalg_variable_1601;
true
gap> homalg_variable_1607 := SIH_DecideZeroRows(homalg_variable_860,homalg_variable_1605);;
gap> homalg_variable_1608 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_1607 = homalg_variable_1608;
true
gap> homalg_variable_1601 = homalg_variable_860;
true
gap> homalg_variable_1609 := homalg_variable_1601 - homalg_variable_860;;
gap> homalg_variable_1610 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_1609 = homalg_variable_1610;
true
gap> homalg_variable_1611 := SIH_Submatrix(homalg_variable_1564,[1..1],[ 1, 2, 3 ]);;
gap> homalg_variable_1612 := homalg_variable_1611 * homalg_variable_1470;;
gap> homalg_variable_1613 := SIH_Submatrix(homalg_variable_1565,[1..3],[ 1, 2, 3 ]);;
gap> homalg_variable_1614 := homalg_variable_1613 * homalg_variable_1470;;
gap> homalg_variable_1615 := SIH_UnionOfRows(homalg_variable_1612,homalg_variable_1614);;
gap> homalg_variable_1616 := SIH_Submatrix(homalg_variable_1564,[1..1],[ 4, 5, 6, 7 ]);;
gap> homalg_variable_1617 := homalg_variable_1616 * homalg_variable_1471;;
gap> homalg_variable_1618 := SIH_Submatrix(homalg_variable_1565,[1..3],[ 4, 5, 6, 7 ]);;
gap> homalg_variable_1619 := homalg_variable_1618 * homalg_variable_1471;;
gap> homalg_variable_1620 := SIH_UnionOfRows(homalg_variable_1617,homalg_variable_1619);;
gap> homalg_variable_1621 := homalg_variable_1615 + homalg_variable_1620;;
gap> homalg_variable_1622 := SI_matrix(homalg_variable_5,4,7,"0");;
gap> homalg_variable_1621 = homalg_variable_1622;
true
gap> homalg_variable_1623 := SIH_Submatrix(homalg_variable_1563,[1..1],[ 1 ]);;
gap> homalg_variable_1624 := homalg_variable_1623 * homalg_variable_1564;;
gap> homalg_variable_1625 := SIH_Submatrix(homalg_variable_1563,[1..1],[ 2, 3, 4 ]);;
gap> homalg_variable_1626 := homalg_variable_1625 * homalg_variable_1565;;
gap> homalg_variable_1627 := homalg_variable_1624 + homalg_variable_1626;;
gap> homalg_variable_1628 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1627 = homalg_variable_1628;
true
gap> homalg_variable_1629 := SI_matrix(homalg_variable_5,3,2,"0");;
gap> homalg_variable_1630 := SIH_UnionOfRows(homalg_variable_1629,homalg_variable_407);;
gap> homalg_variable_1631 := SIH_Submatrix(homalg_variable_1470,[1..3],[ 6, 7 ]);;
gap> homalg_variable_1632 := SIH_Submatrix(homalg_variable_1471,[1..4],[ 6, 7 ]);;
gap> homalg_variable_1633 := SIH_UnionOfRows(homalg_variable_1631,homalg_variable_1632);;
gap> homalg_variable_1634 := homalg_variable_1630 - homalg_variable_1633;;
gap> homalg_variable_1635 := SI_matrix(homalg_variable_5,7,2,"0");;
gap> homalg_variable_1634 = homalg_variable_1635;
true
gap> homalg_variable_1636 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1637 := SIH_UnionOfRows(homalg_variable_1636,homalg_variable_406);;
gap> homalg_variable_1638 := SIH_Submatrix(homalg_variable_1564,[1..1],[ 4, 5, 6, 7 ]);;
gap> homalg_variable_1639 := SIH_Submatrix(homalg_variable_1565,[1..3],[ 4, 5, 6, 7 ]);;
gap> homalg_variable_1640 := SIH_UnionOfRows(homalg_variable_1638,homalg_variable_1639);;
gap> homalg_variable_1641 := homalg_variable_1637 - homalg_variable_1640;;
gap> homalg_variable_1642 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1641 = homalg_variable_1642;
true
gap> homalg_variable_1643 := SIH_Submatrix(homalg_variable_1563,[1..1],[ 2, 3, 4 ]);;
gap> homalg_variable_1644 := homalg_variable_433 - homalg_variable_1643;;
gap> homalg_variable_1645 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1644 = homalg_variable_1645;
true
gap> homalg_variable_1646 := SI_matrix(homalg_variable_5,3,2,"0");;
gap> homalg_variable_1647 := SIH_UnionOfColumns(homalg_variable_891,homalg_variable_1646);;
gap> homalg_variable_1648 := homalg_variable_1470 - homalg_variable_1647;;
gap> homalg_variable_1649 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_1648 = homalg_variable_1649;
true
gap> homalg_variable_1650 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1651 := SIH_UnionOfColumns(homalg_variable_937,homalg_variable_1650);;
gap> homalg_variable_1652 := homalg_variable_1564 - homalg_variable_1651;;
gap> homalg_variable_1653 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1652 = homalg_variable_1653;
true
gap> SIH_ZeroRows(homalg_variable_97);
[ 1 ]
gap> homalg_variable_1655 := SIH_Submatrix(homalg_variable_97,[ 2, 3, 4 ],[1..1]);;
gap> homalg_variable_1654 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1655);;
gap> SI_nrows(homalg_variable_1654);
3
gap> homalg_variable_1656 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1654 = homalg_variable_1656;
false
gap> homalg_variable_1657 := homalg_variable_1654 * homalg_variable_1655;;
gap> homalg_variable_1658 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_1657 = homalg_variable_1658;
true
gap> homalg_variable_1659 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1654);;
gap> SI_nrows(homalg_variable_1659);
1
gap> homalg_variable_1660 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1659 = homalg_variable_1660;
false
gap> SIH_GetColumnIndependentUnitPositions(homalg_variable_1659,[ 0 ]);
[  ]
gap> homalg_variable_1661 := SIH_BasisOfRowModule(homalg_variable_1654);;
gap> SI_nrows(homalg_variable_1661);
3
gap> homalg_variable_1662 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1661 = homalg_variable_1662;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1654);; homalg_variable_1663 := homalg_variable_l[1];; homalg_variable_1664 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1663);
3
gap> homalg_variable_1665 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1663 = homalg_variable_1665;
false
gap> SI_ncols(homalg_variable_1664);
3
gap> homalg_variable_1666 := homalg_variable_1664 * homalg_variable_1654;;
gap> homalg_variable_1663 = homalg_variable_1666;
true
gap> homalg_variable_1663 = homalg_variable_1101;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1661,homalg_variable_1663);; homalg_variable_1667 := homalg_variable_l[1];; homalg_variable_1668 := homalg_variable_l[2];;
gap> homalg_variable_1669 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1667 = homalg_variable_1669;
true
gap> homalg_variable_1670 := homalg_variable_1668 * homalg_variable_1663;;
gap> homalg_variable_1671 := homalg_variable_1661 + homalg_variable_1670;;
gap> homalg_variable_1667 = homalg_variable_1671;
true
gap> homalg_variable_1672 := SIH_DecideZeroRows(homalg_variable_1661,homalg_variable_1663);;
gap> homalg_variable_1673 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1672 = homalg_variable_1673;
true
gap> homalg_variable_1674 := homalg_variable_1668 * (homalg_variable_8);;
gap> homalg_variable_1675 := homalg_variable_1674 * homalg_variable_1664;;
gap> homalg_variable_1676 := homalg_variable_1675 * homalg_variable_1654;;
gap> homalg_variable_1676 = homalg_variable_1661;
true
gap> homalg_variable_1661 = homalg_variable_1101;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1654,homalg_variable_1661);; homalg_variable_1677 := homalg_variable_l[1];; homalg_variable_1678 := homalg_variable_l[2];;
gap> homalg_variable_1679 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1677 = homalg_variable_1679;
true
gap> homalg_variable_1680 := homalg_variable_1678 * homalg_variable_1661;;
gap> homalg_variable_1681 := homalg_variable_1654 + homalg_variable_1680;;
gap> homalg_variable_1677 = homalg_variable_1681;
true
gap> homalg_variable_1682 := SIH_DecideZeroRows(homalg_variable_1654,homalg_variable_1661);;
gap> homalg_variable_1683 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1682 = homalg_variable_1683;
true
gap> homalg_variable_1684 := homalg_variable_1678 * (homalg_variable_8);;
gap> homalg_variable_1685 := homalg_variable_1684 * homalg_variable_1661;;
gap> homalg_variable_1685 = homalg_variable_1654;
true
gap> homalg_variable_1661 = homalg_variable_1654;
true
gap> homalg_variable_1686 := SIH_DecideZeroRows(homalg_variable_1654,homalg_variable_1661);;
gap> homalg_variable_1687 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1686 = homalg_variable_1687;
true
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1655);; homalg_variable_1688 := homalg_variable_l[1];; homalg_variable_1689 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1688);
3
gap> homalg_variable_1690 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_1688 = homalg_variable_1690;
false
gap> SI_ncols(homalg_variable_1689);
3
gap> homalg_variable_1691 := homalg_variable_1689 * homalg_variable_1655;;
gap> homalg_variable_1688 = homalg_variable_1691;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_97,homalg_variable_1688);; homalg_variable_1692 := homalg_variable_l[1];; homalg_variable_1693 := homalg_variable_l[2];;
gap> homalg_variable_1694 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_1692 = homalg_variable_1694;
true
gap> homalg_variable_1695 := homalg_variable_1693 * homalg_variable_1688;;
gap> homalg_variable_1696 := homalg_variable_97 + homalg_variable_1695;;
gap> homalg_variable_1692 = homalg_variable_1696;
true
gap> homalg_variable_1697 := SIH_DecideZeroRows(homalg_variable_97,homalg_variable_1688);;
gap> homalg_variable_1698 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_1697 = homalg_variable_1698;
true
gap> homalg_variable_1699 := homalg_variable_1693 * (homalg_variable_8);;
gap> homalg_variable_1700 := homalg_variable_1699 * homalg_variable_1689;;
gap> homalg_variable_1701 := homalg_variable_1700 * homalg_variable_1655;;
gap> homalg_variable_1702 := homalg_variable_1701 - homalg_variable_97;;
gap> homalg_variable_1703 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_1702 = homalg_variable_1703;
true
gap> homalg_variable_1705 := SIH_UnionOfRows(homalg_variable_1700,homalg_variable_1661);;
gap> homalg_variable_1704 := SIH_BasisOfRowModule(homalg_variable_1705);;
gap> SI_nrows(homalg_variable_1704);
3
gap> homalg_variable_1706 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1704 = homalg_variable_1706;
false
gap> homalg_variable_1707 := SIH_DecideZeroRows(homalg_variable_1101,homalg_variable_1704);;
gap> homalg_variable_1708 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1707 = homalg_variable_1708;
true
gap> homalg_variable_1709 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1661);;
gap> SI_nrows(homalg_variable_1709);
1
gap> homalg_variable_1710 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1709 = homalg_variable_1710;
false
gap> homalg_variable_1711 := SIH_BasisOfRowModule(homalg_variable_1709);;
gap> SI_nrows(homalg_variable_1711);
1
gap> homalg_variable_1712 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1711 = homalg_variable_1712;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1709);; homalg_variable_1713 := homalg_variable_l[1];; homalg_variable_1714 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1713);
1
gap> homalg_variable_1715 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1713 = homalg_variable_1715;
false
gap> SI_ncols(homalg_variable_1714);
1
gap> homalg_variable_1716 := homalg_variable_1714 * homalg_variable_1709;;
gap> homalg_variable_1713 = homalg_variable_1716;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1711,homalg_variable_1713);; homalg_variable_1717 := homalg_variable_l[1];; homalg_variable_1718 := homalg_variable_l[2];;
gap> homalg_variable_1719 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1717 = homalg_variable_1719;
true
gap> homalg_variable_1720 := homalg_variable_1718 * homalg_variable_1713;;
gap> homalg_variable_1721 := homalg_variable_1711 + homalg_variable_1720;;
gap> homalg_variable_1717 = homalg_variable_1721;
true
gap> homalg_variable_1722 := SIH_DecideZeroRows(homalg_variable_1711,homalg_variable_1713);;
gap> homalg_variable_1723 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1722 = homalg_variable_1723;
true
gap> homalg_variable_1724 := homalg_variable_1718 * (homalg_variable_8);;
gap> homalg_variable_1725 := homalg_variable_1724 * homalg_variable_1714;;
gap> homalg_variable_1726 := homalg_variable_1725 * homalg_variable_1709;;
gap> homalg_variable_1726 = homalg_variable_1711;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1709,homalg_variable_1711);; homalg_variable_1727 := homalg_variable_l[1];; homalg_variable_1728 := homalg_variable_l[2];;
gap> homalg_variable_1729 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1727 = homalg_variable_1729;
true
gap> homalg_variable_1730 := homalg_variable_1728 * homalg_variable_1711;;
gap> homalg_variable_1731 := homalg_variable_1709 + homalg_variable_1730;;
gap> homalg_variable_1727 = homalg_variable_1731;
true
gap> homalg_variable_1732 := SIH_DecideZeroRows(homalg_variable_1709,homalg_variable_1711);;
gap> homalg_variable_1733 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1732 = homalg_variable_1733;
true
gap> homalg_variable_1734 := homalg_variable_1728 * (homalg_variable_8);;
gap> homalg_variable_1735 := homalg_variable_1734 * homalg_variable_1711;;
gap> homalg_variable_1735 = homalg_variable_1709;
true
gap> homalg_variable_1736 := homalg_variable_1709 * homalg_variable_1661;;
gap> homalg_variable_1737 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1736 = homalg_variable_1737;
true
gap> homalg_variable_1711 = homalg_variable_1709;
true
gap> homalg_variable_1738 := SIH_DecideZeroRows(homalg_variable_1700,homalg_variable_1661);;
gap> homalg_variable_1739 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_1738 = homalg_variable_1739;
false
gap> homalg_variable_1740 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_1700 = homalg_variable_1740;
false
gap> homalg_variable_1741 := SIH_UnionOfRows(homalg_variable_1738,homalg_variable_1661);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1741);; homalg_variable_1742 := homalg_variable_l[1];; homalg_variable_1743 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1742);
3
gap> homalg_variable_1744 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1742 = homalg_variable_1744;
false
gap> SI_ncols(homalg_variable_1743);
7
gap> homalg_variable_1745 := SIH_Submatrix(homalg_variable_1743,[1..3],[ 1, 2, 3, 4 ]);;
gap> homalg_variable_1746 := homalg_variable_1745 * homalg_variable_1738;;
gap> homalg_variable_1747 := SIH_Submatrix(homalg_variable_1743,[1..3],[ 5, 6, 7 ]);;
gap> homalg_variable_1748 := homalg_variable_1747 * homalg_variable_1661;;
gap> homalg_variable_1749 := homalg_variable_1746 + homalg_variable_1748;;
gap> homalg_variable_1742 = homalg_variable_1749;
true
gap> homalg_variable_1750 := SIH_DecideZeroRows(homalg_variable_1101,homalg_variable_1661);;
gap> homalg_variable_1751 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1750 = homalg_variable_1751;
false
gap> homalg_variable_1742 = homalg_variable_1101;
true
gap> homalg_variable_1753 := SIH_Submatrix(homalg_variable_1743,[1..3],[ 1, 2, 3, 4 ]);;
gap> homalg_variable_1754 := homalg_variable_1750 * homalg_variable_1753;;
gap> homalg_variable_1755 := homalg_variable_1754 * homalg_variable_1700;;
gap> homalg_variable_1756 := homalg_variable_1755 - homalg_variable_1101;;
gap> homalg_variable_1752 := SIH_DecideZeroRows(homalg_variable_1756,homalg_variable_1661);;
gap> homalg_variable_1757 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1752 = homalg_variable_1757;
true
gap> homalg_variable_1759 := homalg_variable_1284 * homalg_variable_271;;
gap> homalg_variable_1760 := homalg_variable_1335 * homalg_variable_271;;
gap> homalg_variable_1761 := SIH_UnionOfRows(homalg_variable_1759,homalg_variable_1760);;
gap> homalg_variable_1762 := SIH_UnionOfRows(homalg_variable_1761,homalg_variable_1754);;
gap> homalg_variable_1758 := SIH_BasisOfRowModule(homalg_variable_1762);;
gap> SI_nrows(homalg_variable_1758);
4
gap> homalg_variable_1763 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1758 = homalg_variable_1763;
false
gap> homalg_variable_1764 := SIH_DecideZeroRows(homalg_variable_705,homalg_variable_1758);;
gap> homalg_variable_1765 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1764 = homalg_variable_1765;
true
gap> homalg_variable_1766 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1762);;
gap> SI_nrows(homalg_variable_1766);
6
gap> homalg_variable_1767 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_1766 = homalg_variable_1767;
false
gap> homalg_variable_1768 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1766);;
gap> SI_nrows(homalg_variable_1768);
1
gap> homalg_variable_1769 := SI_matrix(homalg_variable_5,1,6,"0");;
gap> homalg_variable_1768 = homalg_variable_1769;
true
gap> homalg_variable_1770 := SIH_BasisOfRowModule(homalg_variable_1766);;
gap> SI_nrows(homalg_variable_1770);
8
gap> homalg_variable_1771 := SI_matrix(homalg_variable_5,8,10,"0");;
gap> homalg_variable_1770 = homalg_variable_1771;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1766);; homalg_variable_1772 := homalg_variable_l[1];; homalg_variable_1773 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1772);
8
gap> homalg_variable_1774 := SI_matrix(homalg_variable_5,8,10,"0");;
gap> homalg_variable_1772 = homalg_variable_1774;
false
gap> SI_ncols(homalg_variable_1773);
6
gap> homalg_variable_1775 := homalg_variable_1773 * homalg_variable_1766;;
gap> homalg_variable_1772 = homalg_variable_1775;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1770,homalg_variable_1772);; homalg_variable_1776 := homalg_variable_l[1];; homalg_variable_1777 := homalg_variable_l[2];;
gap> homalg_variable_1778 := SI_matrix(homalg_variable_5,8,10,"0");;
gap> homalg_variable_1776 = homalg_variable_1778;
true
gap> homalg_variable_1779 := homalg_variable_1777 * homalg_variable_1772;;
gap> homalg_variable_1780 := homalg_variable_1770 + homalg_variable_1779;;
gap> homalg_variable_1776 = homalg_variable_1780;
true
gap> homalg_variable_1781 := SIH_DecideZeroRows(homalg_variable_1770,homalg_variable_1772);;
gap> homalg_variable_1782 := SI_matrix(homalg_variable_5,8,10,"0");;
gap> homalg_variable_1781 = homalg_variable_1782;
true
gap> homalg_variable_1783 := homalg_variable_1777 * (homalg_variable_8);;
gap> homalg_variable_1784 := homalg_variable_1783 * homalg_variable_1773;;
gap> homalg_variable_1785 := homalg_variable_1784 * homalg_variable_1766;;
gap> homalg_variable_1785 = homalg_variable_1770;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1766,homalg_variable_1770);; homalg_variable_1786 := homalg_variable_l[1];; homalg_variable_1787 := homalg_variable_l[2];;
gap> homalg_variable_1788 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_1786 = homalg_variable_1788;
true
gap> homalg_variable_1789 := homalg_variable_1787 * homalg_variable_1770;;
gap> homalg_variable_1790 := homalg_variable_1766 + homalg_variable_1789;;
gap> homalg_variable_1786 = homalg_variable_1790;
true
gap> homalg_variable_1791 := SIH_DecideZeroRows(homalg_variable_1766,homalg_variable_1770);;
gap> homalg_variable_1792 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_1791 = homalg_variable_1792;
true
gap> homalg_variable_1793 := homalg_variable_1787 * (homalg_variable_8);;
gap> homalg_variable_1794 := homalg_variable_1793 * homalg_variable_1770;;
gap> homalg_variable_1794 = homalg_variable_1766;
true
gap> SIH_ZeroRows(homalg_variable_1766);
[  ]
gap> SIH_ZeroRows(homalg_variable_1661);
[  ]
gap> homalg_variable_1795 := homalg_variable_1709 * homalg_variable_1661;;
gap> homalg_variable_1796 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1795 = homalg_variable_1796;
true
gap> homalg_variable_1797 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_1470 = homalg_variable_1797;
false
gap> SIH_ZeroRows(homalg_variable_1472);
[  ]
gap> homalg_variable_1472 = homalg_variable_1109;
false
gap> homalg_variable_1798 := SIH_Submatrix(homalg_variable_1469,[1..3],[ 1, 2, 3 ]);;
gap> homalg_variable_1799 := homalg_variable_1798 * homalg_variable_1470;;
gap> homalg_variable_1800 := SIH_Submatrix(homalg_variable_1469,[1..3],[ 4, 5, 6, 7 ]);;
gap> homalg_variable_1801 := homalg_variable_1800 * homalg_variable_1471;;
gap> homalg_variable_1802 := homalg_variable_1799 + homalg_variable_1801;;
gap> homalg_variable_1803 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_1802 = homalg_variable_1803;
true
gap> homalg_variable_1804 := SIH_DecideZeroRows(homalg_variable_1469,homalg_variable_1476);;
gap> homalg_variable_1805 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_1804 = homalg_variable_1805;
true
gap> homalg_variable_1806 := SIH_Submatrix(homalg_variable_1766,[1..6],[ 8, 9, 10 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1806,homalg_variable_1661);; homalg_variable_1807 := homalg_variable_l[1];; homalg_variable_1808 := homalg_variable_l[2];;
gap> homalg_variable_1809 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_1807 = homalg_variable_1809;
true
gap> homalg_variable_1810 := homalg_variable_1808 * homalg_variable_1661;;
gap> homalg_variable_1811 := homalg_variable_1806 + homalg_variable_1810;;
gap> homalg_variable_1807 = homalg_variable_1811;
true
gap> homalg_variable_1812 := SIH_DecideZeroRows(homalg_variable_1806,homalg_variable_1661);;
gap> homalg_variable_1813 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_1812 = homalg_variable_1813;
true
gap> homalg_variable_1814 := homalg_variable_1808 * (homalg_variable_8);;
gap> homalg_variable_1815 := homalg_variable_1814 * homalg_variable_1661;;
gap> homalg_variable_1816 := homalg_variable_1815 - homalg_variable_1806;;
gap> homalg_variable_1817 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_1816 = homalg_variable_1817;
true
gap> homalg_variable_1818 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1819 := SIH_UnionOfColumns(homalg_variable_1470,homalg_variable_1818);;
gap> homalg_variable_1820 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_1821 := SIH_UnionOfColumns(homalg_variable_1471,homalg_variable_1820);;
gap> homalg_variable_1822 := SIH_UnionOfRows(homalg_variable_1819,homalg_variable_1821);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1822,homalg_variable_1772);; homalg_variable_1823 := homalg_variable_l[1];; homalg_variable_1824 := homalg_variable_l[2];;
gap> homalg_variable_1825 := SI_matrix(homalg_variable_5,7,10,"0");;
gap> homalg_variable_1823 = homalg_variable_1825;
true
gap> homalg_variable_1826 := homalg_variable_1824 * homalg_variable_1772;;
gap> homalg_variable_1827 := homalg_variable_1822 + homalg_variable_1826;;
gap> homalg_variable_1823 = homalg_variable_1827;
true
gap> homalg_variable_1828 := SIH_DecideZeroRows(homalg_variable_1822,homalg_variable_1772);;
gap> homalg_variable_1829 := SI_matrix(homalg_variable_5,7,10,"0");;
gap> homalg_variable_1828 = homalg_variable_1829;
true
gap> SI_ncols(homalg_variable_1773);
6
gap> SI_nrows(homalg_variable_1773);
8
gap> homalg_variable_1830 := homalg_variable_1824 * (homalg_variable_8);;
gap> homalg_variable_1831 := homalg_variable_1830 * homalg_variable_1773;;
gap> homalg_variable_1832 := homalg_variable_1831 * homalg_variable_1766;;
gap> homalg_variable_1833 := homalg_variable_1832 - homalg_variable_1822;;
gap> homalg_variable_1834 := SI_matrix(homalg_variable_5,7,10,"0");;
gap> homalg_variable_1833 = homalg_variable_1834;
true
gap> homalg_variable_1835 := homalg_variable_1476 * homalg_variable_1831;;
gap> homalg_variable_1836 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_1835 = homalg_variable_1836;
true
gap> homalg_variable_1837 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1831);;
gap> SI_nrows(homalg_variable_1837);
3
gap> homalg_variable_1838 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_1837 = homalg_variable_1838;
false
gap> homalg_variable_1839 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1837);;
gap> SI_nrows(homalg_variable_1839);
1
gap> homalg_variable_1840 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1839 = homalg_variable_1840;
true
gap> homalg_variable_1841 := SIH_BasisOfRowModule(homalg_variable_1837);;
gap> SI_nrows(homalg_variable_1841);
4
gap> homalg_variable_1842 := SI_matrix(homalg_variable_5,4,7,"0");;
gap> homalg_variable_1841 = homalg_variable_1842;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1837);; homalg_variable_1843 := homalg_variable_l[1];; homalg_variable_1844 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1843);
4
gap> homalg_variable_1845 := SI_matrix(homalg_variable_5,4,7,"0");;
gap> homalg_variable_1843 = homalg_variable_1845;
false
gap> SI_ncols(homalg_variable_1844);
3
gap> homalg_variable_1846 := homalg_variable_1844 * homalg_variable_1837;;
gap> homalg_variable_1843 = homalg_variable_1846;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1841,homalg_variable_1843);; homalg_variable_1847 := homalg_variable_l[1];; homalg_variable_1848 := homalg_variable_l[2];;
gap> homalg_variable_1849 := SI_matrix(homalg_variable_5,4,7,"0");;
gap> homalg_variable_1847 = homalg_variable_1849;
true
gap> homalg_variable_1850 := homalg_variable_1848 * homalg_variable_1843;;
gap> homalg_variable_1851 := homalg_variable_1841 + homalg_variable_1850;;
gap> homalg_variable_1847 = homalg_variable_1851;
true
gap> homalg_variable_1852 := SIH_DecideZeroRows(homalg_variable_1841,homalg_variable_1843);;
gap> homalg_variable_1853 := SI_matrix(homalg_variable_5,4,7,"0");;
gap> homalg_variable_1852 = homalg_variable_1853;
true
gap> homalg_variable_1854 := homalg_variable_1848 * (homalg_variable_8);;
gap> homalg_variable_1855 := homalg_variable_1854 * homalg_variable_1844;;
gap> homalg_variable_1856 := homalg_variable_1855 * homalg_variable_1837;;
gap> homalg_variable_1856 = homalg_variable_1841;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1837,homalg_variable_1841);; homalg_variable_1857 := homalg_variable_l[1];; homalg_variable_1858 := homalg_variable_l[2];;
gap> homalg_variable_1859 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_1857 = homalg_variable_1859;
true
gap> homalg_variable_1860 := homalg_variable_1858 * homalg_variable_1841;;
gap> homalg_variable_1861 := homalg_variable_1837 + homalg_variable_1860;;
gap> homalg_variable_1857 = homalg_variable_1861;
true
gap> homalg_variable_1862 := SIH_DecideZeroRows(homalg_variable_1837,homalg_variable_1841);;
gap> homalg_variable_1863 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_1862 = homalg_variable_1863;
true
gap> homalg_variable_1864 := homalg_variable_1858 * (homalg_variable_8);;
gap> homalg_variable_1865 := homalg_variable_1864 * homalg_variable_1841;;
gap> homalg_variable_1865 = homalg_variable_1837;
true
gap> homalg_variable_1866 := SIH_DecideZeroRows(homalg_variable_1837,homalg_variable_1476);;
gap> homalg_variable_1867 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_1866 = homalg_variable_1867;
true
gap> homalg_variable_1869 := SIH_UnionOfRows(homalg_variable_1814,homalg_variable_1711);;
gap> homalg_variable_1868 := SIH_BasisOfRowModule(homalg_variable_1869);;
gap> SI_nrows(homalg_variable_1868);
3
gap> homalg_variable_1870 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1868 = homalg_variable_1870;
false
gap> homalg_variable_1871 := SIH_DecideZeroRows(homalg_variable_1101,homalg_variable_1868);;
gap> homalg_variable_1872 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1871 = homalg_variable_1872;
true
gap> homalg_variable_1874 := SIH_UnionOfRows(homalg_variable_1101,homalg_variable_1711);;
gap> homalg_variable_1873 := SIH_BasisOfRowModule(homalg_variable_1874);;
gap> SI_nrows(homalg_variable_1873);
3
gap> homalg_variable_1875 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1873 = homalg_variable_1875;
false
gap> homalg_variable_1876 := SIH_DecideZeroRows(homalg_variable_1101,homalg_variable_1873);;
gap> homalg_variable_1877 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1876 = homalg_variable_1877;
true
gap> homalg_variable_1879 := SIH_UnionOfRows(homalg_variable_1109,homalg_variable_1476);;
gap> homalg_variable_1878 := SIH_BasisOfRowModule(homalg_variable_1879);;
gap> SI_nrows(homalg_variable_1878);
7
gap> homalg_variable_1880 := SI_matrix(homalg_variable_5,7,7,"0");;
gap> homalg_variable_1878 = homalg_variable_1880;
false
gap> homalg_variable_1881 := SIH_DecideZeroRows(homalg_variable_1109,homalg_variable_1878);;
gap> homalg_variable_1882 := SI_matrix(homalg_variable_5,7,7,"0");;
gap> homalg_variable_1881 = homalg_variable_1882;
true
gap> homalg_variable_1883 := SIH_DecideZeroRows(homalg_variable_1814,homalg_variable_1711);;
gap> homalg_variable_1884 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_1883 = homalg_variable_1884;
false
gap> homalg_variable_1885 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_1808 = homalg_variable_1885;
false
gap> homalg_variable_1886 := SIH_UnionOfRows(homalg_variable_1883,homalg_variable_1711);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1886);; homalg_variable_1887 := homalg_variable_l[1];; homalg_variable_1888 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1887);
3
gap> homalg_variable_1889 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1887 = homalg_variable_1889;
false
gap> SI_ncols(homalg_variable_1888);
7
gap> homalg_variable_1890 := SIH_Submatrix(homalg_variable_1888,[1..3],[ 1, 2, 3, 4, 5, 6 ]);;
gap> homalg_variable_1891 := homalg_variable_1890 * homalg_variable_1883;;
gap> homalg_variable_1892 := SIH_Submatrix(homalg_variable_1888,[1..3],[ 7 ]);;
gap> homalg_variable_1893 := homalg_variable_1892 * homalg_variable_1711;;
gap> homalg_variable_1894 := homalg_variable_1891 + homalg_variable_1893;;
gap> homalg_variable_1887 = homalg_variable_1894;
true
gap> homalg_variable_1895 := SIH_DecideZeroRows(homalg_variable_1101,homalg_variable_1711);;
gap> homalg_variable_1896 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1895 = homalg_variable_1896;
false
gap> homalg_variable_1887 = homalg_variable_1101;
true
gap> homalg_variable_1898 := SIH_Submatrix(homalg_variable_1888,[1..3],[ 1, 2, 3, 4, 5, 6 ]);;
gap> homalg_variable_1899 := homalg_variable_1895 * homalg_variable_1898;;
gap> homalg_variable_1900 := homalg_variable_1899 * homalg_variable_1814;;
gap> homalg_variable_1901 := homalg_variable_1900 - homalg_variable_1101;;
gap> homalg_variable_1897 := SIH_DecideZeroRows(homalg_variable_1901,homalg_variable_1711);;
gap> homalg_variable_1902 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1897 = homalg_variable_1902;
true
gap> homalg_variable_1904 := homalg_variable_1831 * homalg_variable_1766;;
gap> homalg_variable_1905 := homalg_variable_1899 * homalg_variable_1766;;
gap> homalg_variable_1906 := SIH_UnionOfRows(homalg_variable_1904,homalg_variable_1905);;
gap> homalg_variable_1903 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1906);;
gap> SI_nrows(homalg_variable_1903);
4
gap> homalg_variable_1907 := SI_matrix(homalg_variable_5,4,10,"0");;
gap> homalg_variable_1903 = homalg_variable_1907;
false
gap> homalg_variable_1908 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1903);;
gap> SI_nrows(homalg_variable_1908);
1
gap> homalg_variable_1909 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1908 = homalg_variable_1909;
true
gap> homalg_variable_1910 := SIH_BasisOfRowModule(homalg_variable_1903);;
gap> SI_nrows(homalg_variable_1910);
5
gap> homalg_variable_1911 := SI_matrix(homalg_variable_5,5,10,"0");;
gap> homalg_variable_1910 = homalg_variable_1911;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1903);; homalg_variable_1912 := homalg_variable_l[1];; homalg_variable_1913 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1912);
5
gap> homalg_variable_1914 := SI_matrix(homalg_variable_5,5,10,"0");;
gap> homalg_variable_1912 = homalg_variable_1914;
false
gap> SI_ncols(homalg_variable_1913);
4
gap> homalg_variable_1915 := homalg_variable_1913 * homalg_variable_1903;;
gap> homalg_variable_1912 = homalg_variable_1915;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1910,homalg_variable_1912);; homalg_variable_1916 := homalg_variable_l[1];; homalg_variable_1917 := homalg_variable_l[2];;
gap> homalg_variable_1918 := SI_matrix(homalg_variable_5,5,10,"0");;
gap> homalg_variable_1916 = homalg_variable_1918;
true
gap> homalg_variable_1919 := homalg_variable_1917 * homalg_variable_1912;;
gap> homalg_variable_1920 := homalg_variable_1910 + homalg_variable_1919;;
gap> homalg_variable_1916 = homalg_variable_1920;
true
gap> homalg_variable_1921 := SIH_DecideZeroRows(homalg_variable_1910,homalg_variable_1912);;
gap> homalg_variable_1922 := SI_matrix(homalg_variable_5,5,10,"0");;
gap> homalg_variable_1921 = homalg_variable_1922;
true
gap> homalg_variable_1923 := homalg_variable_1917 * (homalg_variable_8);;
gap> homalg_variable_1924 := homalg_variable_1923 * homalg_variable_1913;;
gap> homalg_variable_1925 := homalg_variable_1924 * homalg_variable_1903;;
gap> homalg_variable_1925 = homalg_variable_1910;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1903,homalg_variable_1910);; homalg_variable_1926 := homalg_variable_l[1];; homalg_variable_1927 := homalg_variable_l[2];;
gap> homalg_variable_1928 := SI_matrix(homalg_variable_5,4,10,"0");;
gap> homalg_variable_1926 = homalg_variable_1928;
true
gap> homalg_variable_1929 := homalg_variable_1927 * homalg_variable_1910;;
gap> homalg_variable_1930 := homalg_variable_1903 + homalg_variable_1929;;
gap> homalg_variable_1926 = homalg_variable_1930;
true
gap> homalg_variable_1931 := SIH_DecideZeroRows(homalg_variable_1903,homalg_variable_1910);;
gap> homalg_variable_1932 := SI_matrix(homalg_variable_5,4,10,"0");;
gap> homalg_variable_1931 = homalg_variable_1932;
true
gap> homalg_variable_1933 := homalg_variable_1927 * (homalg_variable_8);;
gap> homalg_variable_1934 := homalg_variable_1933 * homalg_variable_1910;;
gap> homalg_variable_1934 = homalg_variable_1903;
true
gap> SIH_ZeroRows(homalg_variable_1903);
[  ]
gap> homalg_variable_1935 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1564 = homalg_variable_1935;
false
gap> SIH_ZeroRows(homalg_variable_1566);
[  ]
gap> homalg_variable_1936 := SIH_Submatrix(homalg_variable_1563,[1..1],[ 1 ]);;
gap> homalg_variable_1937 := homalg_variable_1936 * homalg_variable_1564;;
gap> homalg_variable_1938 := SIH_Submatrix(homalg_variable_1563,[1..1],[ 2, 3, 4 ]);;
gap> homalg_variable_1939 := homalg_variable_1938 * homalg_variable_1565;;
gap> homalg_variable_1940 := homalg_variable_1937 + homalg_variable_1939;;
gap> homalg_variable_1941 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1940 = homalg_variable_1941;
true
gap> homalg_variable_1568 = homalg_variable_1563;
true
gap> homalg_variable_1942 := SIH_DecideZeroRows(homalg_variable_1563,homalg_variable_1568);;
gap> homalg_variable_1943 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1942 = homalg_variable_1943;
true
gap> homalg_variable_1944 := SIH_Submatrix(homalg_variable_1903,[1..4],[ 8, 9, 10 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1944,homalg_variable_1709);; homalg_variable_1945 := homalg_variable_l[1];; homalg_variable_1946 := homalg_variable_l[2];;
gap> homalg_variable_1947 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_1945 = homalg_variable_1947;
true
gap> homalg_variable_1948 := homalg_variable_1946 * homalg_variable_1709;;
gap> homalg_variable_1949 := homalg_variable_1944 + homalg_variable_1948;;
gap> homalg_variable_1945 = homalg_variable_1949;
true
gap> homalg_variable_1950 := SIH_DecideZeroRows(homalg_variable_1944,homalg_variable_1711);;
gap> homalg_variable_1951 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_1950 = homalg_variable_1951;
true
gap> homalg_variable_1952 := homalg_variable_1946 * (homalg_variable_8);;
gap> homalg_variable_1953 := homalg_variable_1952 * homalg_variable_1709;;
gap> homalg_variable_1954 := homalg_variable_1953 - homalg_variable_1944;;
gap> homalg_variable_1955 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_1954 = homalg_variable_1955;
true
gap> homalg_variable_1956 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1957 := SIH_UnionOfColumns(homalg_variable_1564,homalg_variable_1956);;
gap> homalg_variable_1958 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1959 := SIH_UnionOfColumns(homalg_variable_1565,homalg_variable_1958);;
gap> homalg_variable_1960 := SIH_UnionOfRows(homalg_variable_1957,homalg_variable_1959);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1960,homalg_variable_1912);; homalg_variable_1961 := homalg_variable_l[1];; homalg_variable_1962 := homalg_variable_l[2];;
gap> homalg_variable_1963 := SI_matrix(homalg_variable_5,4,10,"0");;
gap> homalg_variable_1961 = homalg_variable_1963;
true
gap> homalg_variable_1964 := homalg_variable_1962 * homalg_variable_1912;;
gap> homalg_variable_1965 := homalg_variable_1960 + homalg_variable_1964;;
gap> homalg_variable_1961 = homalg_variable_1965;
true
gap> homalg_variable_1966 := SIH_DecideZeroRows(homalg_variable_1960,homalg_variable_1912);;
gap> homalg_variable_1967 := SI_matrix(homalg_variable_5,4,10,"0");;
gap> homalg_variable_1966 = homalg_variable_1967;
true
gap> SI_ncols(homalg_variable_1913);
4
gap> SI_nrows(homalg_variable_1913);
5
gap> homalg_variable_1968 := homalg_variable_1962 * (homalg_variable_8);;
gap> homalg_variable_1969 := homalg_variable_1968 * homalg_variable_1913;;
gap> homalg_variable_1970 := homalg_variable_1969 * homalg_variable_1903;;
gap> homalg_variable_1971 := homalg_variable_1970 - homalg_variable_1960;;
gap> homalg_variable_1972 := SI_matrix(homalg_variable_5,4,10,"0");;
gap> homalg_variable_1971 = homalg_variable_1972;
true
gap> homalg_variable_1973 := homalg_variable_1568 * homalg_variable_1969;;
gap> homalg_variable_1974 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1973 = homalg_variable_1974;
true
gap> homalg_variable_1975 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1969);;
gap> SI_nrows(homalg_variable_1975);
1
gap> homalg_variable_1976 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1975 = homalg_variable_1976;
false
gap> homalg_variable_1977 := SIH_BasisOfRowModule(homalg_variable_1975);;
gap> SI_nrows(homalg_variable_1977);
1
gap> homalg_variable_1978 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1977 = homalg_variable_1978;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1975);; homalg_variable_1979 := homalg_variable_l[1];; homalg_variable_1980 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1979);
1
gap> homalg_variable_1981 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1979 = homalg_variable_1981;
false
gap> SI_ncols(homalg_variable_1980);
1
gap> homalg_variable_1982 := homalg_variable_1980 * homalg_variable_1975;;
gap> homalg_variable_1979 = homalg_variable_1982;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1977,homalg_variable_1979);; homalg_variable_1983 := homalg_variable_l[1];; homalg_variable_1984 := homalg_variable_l[2];;
gap> homalg_variable_1985 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1983 = homalg_variable_1985;
true
gap> homalg_variable_1986 := homalg_variable_1984 * homalg_variable_1979;;
gap> homalg_variable_1987 := homalg_variable_1977 + homalg_variable_1986;;
gap> homalg_variable_1983 = homalg_variable_1987;
true
gap> homalg_variable_1988 := SIH_DecideZeroRows(homalg_variable_1977,homalg_variable_1979);;
gap> homalg_variable_1989 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1988 = homalg_variable_1989;
true
gap> homalg_variable_1990 := homalg_variable_1984 * (homalg_variable_8);;
gap> homalg_variable_1991 := homalg_variable_1990 * homalg_variable_1980;;
gap> homalg_variable_1992 := homalg_variable_1991 * homalg_variable_1975;;
gap> homalg_variable_1992 = homalg_variable_1977;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1975,homalg_variable_1977);; homalg_variable_1993 := homalg_variable_l[1];; homalg_variable_1994 := homalg_variable_l[2];;
gap> homalg_variable_1995 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1993 = homalg_variable_1995;
true
gap> homalg_variable_1996 := homalg_variable_1994 * homalg_variable_1977;;
gap> homalg_variable_1997 := homalg_variable_1975 + homalg_variable_1996;;
gap> homalg_variable_1993 = homalg_variable_1997;
true
gap> homalg_variable_1998 := SIH_DecideZeroRows(homalg_variable_1975,homalg_variable_1977);;
gap> homalg_variable_1999 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1998 = homalg_variable_1999;
true
gap> homalg_variable_2000 := homalg_variable_1994 * (homalg_variable_8);;
gap> for _del in [ "homalg_variable_24", "homalg_variable_25", "homalg_variable_57", "homalg_variable_73", "homalg_variable_74", "homalg_variable_80", "homalg_variable_81", "homalg_variable_82", "homalg_variable_105", "homalg_variable_106", "homalg_variable_112", "homalg_variable_113", "homalg_variable_206", "homalg_variable_207", "homalg_variable_213", "homalg_variable_214", "homalg_variable_215", "homalg_variable_229", "homalg_variable_258", "homalg_variable_259", "homalg_variable_260", "homalg_variable_265", "homalg_variable_272", "homalg_variable_305", "homalg_variable_368", "homalg_variable_369", "homalg_variable_375", "homalg_variable_424", "homalg_variable_425", "homalg_variable_427", "homalg_variable_428", "homalg_variable_431", "homalg_variable_466", "homalg_variable_467", "homalg_variable_471", "homalg_variable_473", "homalg_variable_474", "homalg_variable_529", "homalg_variable_530", "homalg_variable_534", "homalg_variable_536", "homalg_variable_537", "homalg_variable_558", "homalg_variable_565", "homalg_variable_566", "homalg_variable_582", "homalg_variable_583", "homalg_variable_587", "homalg_variable_588", "homalg_variable_589", "homalg_variable_590", "homalg_variable_642", "homalg_variable_643", "homalg_variable_644", "homalg_variable_649", "homalg_variable_666", "homalg_variable_667", "homalg_variable_675", "homalg_variable_682", "homalg_variable_686", "homalg_variable_687", "homalg_variable_743", "homalg_variable_744", "homalg_variable_750", "homalg_variable_751", "homalg_variable_771", "homalg_variable_862", "homalg_variable_863", "homalg_variable_897", "homalg_variable_898", "homalg_variable_900", "homalg_variable_901", "homalg_variable_904", "homalg_variable_905", "homalg_variable_920", "homalg_variable_925", "homalg_variable_926", "homalg_variable_945", "homalg_variable_946", "homalg_variable_950", "homalg_variable_951", "homalg_variable_952", "homalg_variable_953", "homalg_variable_1005", "homalg_variable_1006", "homalg_variable_1007", "homalg_variable_1012", "homalg_variable_1013", "homalg_variable_1035", "homalg_variable_1054", "homalg_variable_1057", "homalg_variable_1058", "homalg_variable_1076", "homalg_variable_1077", "homalg_variable_1081", "homalg_variable_1082", "homalg_variable_1083", "homalg_variable_1084", "homalg_variable_1114", "homalg_variable_1117", "homalg_variable_1118", "homalg_variable_1128", "homalg_variable_1131", "homalg_variable_1132", "homalg_variable_1133", "homalg_variable_1147", "homalg_variable_1148", "homalg_variable_1152", "homalg_variable_1154", "homalg_variable_1155", "homalg_variable_1180", "homalg_variable_1183", "homalg_variable_1184", "homalg_variable_1210", "homalg_variable_1211", "homalg_variable_1212", "homalg_variable_1213", "homalg_variable_1214", "homalg_variable_1215", "homalg_variable_1216", "homalg_variable_1217", "homalg_variable_1218", "homalg_variable_1219", "homalg_variable_1220", "homalg_variable_1255", "homalg_variable_1256", "homalg_variable_1262", "homalg_variable_1263", "homalg_variable_1265", "homalg_variable_1266", "homalg_variable_1272", "homalg_variable_1273", "homalg_variable_1291", "homalg_variable_1293", "homalg_variable_1294", "homalg_variable_1302", "homalg_variable_1309", "homalg_variable_1313", "homalg_variable_1314", "homalg_variable_1315", "homalg_variable_1319", "homalg_variable_1322", "homalg_variable_1323", "homalg_variable_1358", "homalg_variable_1359", "homalg_variable_1360", "homalg_variable_1365", "homalg_variable_1366", "homalg_variable_1368", "homalg_variable_1369", "homalg_variable_1375", "homalg_variable_1376", "homalg_variable_1382", "homalg_variable_1396", "homalg_variable_1398", "homalg_variable_1418", "homalg_variable_1419", "homalg_variable_1425", "homalg_variable_1426", "homalg_variable_1427", "homalg_variable_1437", "homalg_variable_1438", "homalg_variable_1447", "homalg_variable_1449", "homalg_variable_1452", "homalg_variable_1453", "homalg_variable_1474", "homalg_variable_1482", "homalg_variable_1483", "homalg_variable_1487", "homalg_variable_1489", "homalg_variable_1490", "homalg_variable_1492", "homalg_variable_1493", "homalg_variable_1499", "homalg_variable_1500", "homalg_variable_1501", "homalg_variable_1502", "homalg_variable_1503", "homalg_variable_1504", "homalg_variable_1506", "homalg_variable_1508", "homalg_variable_1509", "homalg_variable_1510", "homalg_variable_1511", "homalg_variable_1512", "homalg_variable_1514", "homalg_variable_1515", "homalg_variable_1516", "homalg_variable_1519", "homalg_variable_1521", "homalg_variable_1522", "homalg_variable_1523", "homalg_variable_1524", "homalg_variable_1525", "homalg_variable_1528", "homalg_variable_1529", "homalg_variable_1530", "homalg_variable_1531", "homalg_variable_1532", "homalg_variable_1535", "homalg_variable_1536", "homalg_variable_1537", "homalg_variable_1540", "homalg_variable_1541", "homalg_variable_1542", "homalg_variable_1543", "homalg_variable_1544", "homalg_variable_1545", "homalg_variable_1546", "homalg_variable_1547", "homalg_variable_1549", "homalg_variable_1550", "homalg_variable_1551", "homalg_variable_1552", "homalg_variable_1553", "homalg_variable_1554", "homalg_variable_1556", "homalg_variable_1557", "homalg_variable_1560", "homalg_variable_1561", "homalg_variable_1562", "homalg_variable_1567", "homalg_variable_1569", "homalg_variable_1572", "homalg_variable_1573", "homalg_variable_1574", "homalg_variable_1575", "homalg_variable_1576", "homalg_variable_1577", "homalg_variable_1578", "homalg_variable_1579", "homalg_variable_1580", "homalg_variable_1581", "homalg_variable_1582", "homalg_variable_1583", "homalg_variable_1584", "homalg_variable_1585", "homalg_variable_1586", "homalg_variable_1587", "homalg_variable_1588", "homalg_variable_1589", "homalg_variable_1590", "homalg_variable_1591", "homalg_variable_1592", "homalg_variable_1594", "homalg_variable_1596", "homalg_variable_1597", "homalg_variable_1598", "homalg_variable_1599", "homalg_variable_1600", "homalg_variable_1602", "homalg_variable_1603", "homalg_variable_1604", "homalg_variable_1606", "homalg_variable_1607", "homalg_variable_1608", "homalg_variable_1609", "homalg_variable_1610", "homalg_variable_1611", "homalg_variable_1612", "homalg_variable_1613", "homalg_variable_1614", "homalg_variable_1615", "homalg_variable_1616", "homalg_variable_1617", "homalg_variable_1618", "homalg_variable_1619", "homalg_variable_1620", "homalg_variable_1621", "homalg_variable_1622", "homalg_variable_1623", "homalg_variable_1624", "homalg_variable_1625", "homalg_variable_1626", "homalg_variable_1627", "homalg_variable_1628", "homalg_variable_1629", "homalg_variable_1630", "homalg_variable_1631", "homalg_variable_1632", "homalg_variable_1633", "homalg_variable_1634", "homalg_variable_1635", "homalg_variable_1636", "homalg_variable_1637", "homalg_variable_1638", "homalg_variable_1639", "homalg_variable_1640", "homalg_variable_1641", "homalg_variable_1642", "homalg_variable_1643", "homalg_variable_1644", "homalg_variable_1645", "homalg_variable_1646", "homalg_variable_1647", "homalg_variable_1648", "homalg_variable_1649", "homalg_variable_1650", "homalg_variable_1651", "homalg_variable_1652", "homalg_variable_1653", "homalg_variable_1656", "homalg_variable_1657", "homalg_variable_1658", "homalg_variable_1660", "homalg_variable_1662", "homalg_variable_1665", "homalg_variable_1666", "homalg_variable_1667", "homalg_variable_1668", "homalg_variable_1669", "homalg_variable_1670", "homalg_variable_1671", "homalg_variable_1672", "homalg_variable_1673", "homalg_variable_1674", "homalg_variable_1675", "homalg_variable_1676", "homalg_variable_1677", "homalg_variable_1678", "homalg_variable_1679", "homalg_variable_1680", "homalg_variable_1681", "homalg_variable_1682", "homalg_variable_1683", "homalg_variable_1684", "homalg_variable_1685", "homalg_variable_1686", "homalg_variable_1687", "homalg_variable_1690", "homalg_variable_1691", "homalg_variable_1692", "homalg_variable_1694", "homalg_variable_1695", "homalg_variable_1696", "homalg_variable_1697", "homalg_variable_1698", "homalg_variable_1701", "homalg_variable_1702", "homalg_variable_1703", "homalg_variable_1706", "homalg_variable_1707", "homalg_variable_1708", "homalg_variable_1710", "homalg_variable_1712", "homalg_variable_1715", "homalg_variable_1716", "homalg_variable_1717", "homalg_variable_1718", "homalg_variable_1719", "homalg_variable_1720", "homalg_variable_1721", "homalg_variable_1722", "homalg_variable_1723", "homalg_variable_1724", "homalg_variable_1725", "homalg_variable_1726", "homalg_variable_1727", "homalg_variable_1728", "homalg_variable_1729", "homalg_variable_1730", "homalg_variable_1731", "homalg_variable_1732", "homalg_variable_1733", "homalg_variable_1734", "homalg_variable_1735", "homalg_variable_1736", "homalg_variable_1737", "homalg_variable_1738", "homalg_variable_1739", "homalg_variable_1740", "homalg_variable_1741", "homalg_variable_1742", "homalg_variable_1744", "homalg_variable_1745", "homalg_variable_1746", "homalg_variable_1747", "homalg_variable_1748", "homalg_variable_1749", "homalg_variable_1751", "homalg_variable_1752", "homalg_variable_1755", "homalg_variable_1756", "homalg_variable_1757", "homalg_variable_1763", "homalg_variable_1764", "homalg_variable_1765", "homalg_variable_1767", "homalg_variable_1768", "homalg_variable_1769", "homalg_variable_1771", "homalg_variable_1774", "homalg_variable_1775", "homalg_variable_1776", "homalg_variable_1777", "homalg_variable_1778", "homalg_variable_1779", "homalg_variable_1780", "homalg_variable_1781", "homalg_variable_1782", "homalg_variable_1783", "homalg_variable_1784", "homalg_variable_1785", "homalg_variable_1786", "homalg_variable_1787", "homalg_variable_1788", "homalg_variable_1789", "homalg_variable_1790", "homalg_variable_1791", "homalg_variable_1792", "homalg_variable_1793", "homalg_variable_1794", "homalg_variable_1795", "homalg_variable_1796", "homalg_variable_1797", "homalg_variable_1798", "homalg_variable_1799", "homalg_variable_1800", "homalg_variable_1801", "homalg_variable_1802", "homalg_variable_1803", "homalg_variable_1804", "homalg_variable_1805", "homalg_variable_1807", "homalg_variable_1809", "homalg_variable_1810", "homalg_variable_1811", "homalg_variable_1812", "homalg_variable_1813", "homalg_variable_1815", "homalg_variable_1816", "homalg_variable_1817", "homalg_variable_1823", "homalg_variable_1825", "homalg_variable_1826", "homalg_variable_1827", "homalg_variable_1828", "homalg_variable_1829", "homalg_variable_1832", "homalg_variable_1833", "homalg_variable_1834", "homalg_variable_1835", "homalg_variable_1836", "homalg_variable_1838", "homalg_variable_1839", "homalg_variable_1840", "homalg_variable_1842", "homalg_variable_1845", "homalg_variable_1846", "homalg_variable_1847", "homalg_variable_1848", "homalg_variable_1849", "homalg_variable_1850", "homalg_variable_1851", "homalg_variable_1852", "homalg_variable_1853", "homalg_variable_1854", "homalg_variable_1855", "homalg_variable_1856", "homalg_variable_1857", "homalg_variable_1858", "homalg_variable_1859", "homalg_variable_1860", "homalg_variable_1861", "homalg_variable_1862", "homalg_variable_1863", "homalg_variable_1864", "homalg_variable_1865", "homalg_variable_1870", "homalg_variable_1871", "homalg_variable_1872", "homalg_variable_1875", "homalg_variable_1876", "homalg_variable_1877", "homalg_variable_1880", "homalg_variable_1881", "homalg_variable_1882", "homalg_variable_1883", "homalg_variable_1884", "homalg_variable_1885", "homalg_variable_1886", "homalg_variable_1887", "homalg_variable_1889", "homalg_variable_1890", "homalg_variable_1891", "homalg_variable_1892", "homalg_variable_1893", "homalg_variable_1894", "homalg_variable_1896", "homalg_variable_1897", "homalg_variable_1900", "homalg_variable_1901", "homalg_variable_1902", "homalg_variable_1907", "homalg_variable_1908", "homalg_variable_1909", "homalg_variable_1911", "homalg_variable_1914", "homalg_variable_1915", "homalg_variable_1916", "homalg_variable_1917", "homalg_variable_1918", "homalg_variable_1919", "homalg_variable_1920", "homalg_variable_1921", "homalg_variable_1922", "homalg_variable_1923", "homalg_variable_1924", "homalg_variable_1925", "homalg_variable_1928", "homalg_variable_1929", "homalg_variable_1930", "homalg_variable_1932", "homalg_variable_1934", "homalg_variable_1935", "homalg_variable_1936", "homalg_variable_1937", "homalg_variable_1938", "homalg_variable_1939", "homalg_variable_1940", "homalg_variable_1941", "homalg_variable_1942", "homalg_variable_1943" ] do UnbindGlobal( _del ); od;;
gap> homalg_variable_2001 := homalg_variable_2000 * homalg_variable_1977;;
gap> homalg_variable_2001 = homalg_variable_1975;
true
gap> homalg_variable_2002 := SIH_DecideZeroRows(homalg_variable_1975,homalg_variable_1568);;
gap> homalg_variable_2003 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2002 = homalg_variable_2003;
true
gap> homalg_variable_2004 := SIH_BasisOfRowModule(homalg_variable_1952);;
gap> SI_nrows(homalg_variable_2004);
1
gap> homalg_variable_2005 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2004 = homalg_variable_2005;
false
gap> homalg_variable_2006 := SIH_DecideZeroRows(homalg_variable_860,homalg_variable_2004);;
gap> homalg_variable_2007 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2006 = homalg_variable_2007;
true
gap> homalg_variable_2009 := SIH_UnionOfRows(homalg_variable_705,homalg_variable_1568);;
gap> homalg_variable_2008 := SIH_BasisOfRowModule(homalg_variable_2009);;
gap> SI_nrows(homalg_variable_2008);
4
gap> homalg_variable_2010 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_2008 = homalg_variable_2010;
false
gap> homalg_variable_2011 := SIH_DecideZeroRows(homalg_variable_705,homalg_variable_2008);;
gap> homalg_variable_2012 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_2011 = homalg_variable_2012;
true
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1952);; homalg_variable_2013 := homalg_variable_l[1];; homalg_variable_2014 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_2013);
1
gap> homalg_variable_2015 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2013 = homalg_variable_2015;
false
gap> SI_ncols(homalg_variable_2014);
4
gap> homalg_variable_2016 := homalg_variable_2014 * homalg_variable_1952;;
gap> homalg_variable_2013 = homalg_variable_2016;
true
gap> homalg_variable_2013 = homalg_variable_860;
true
gap> homalg_variable_2017 := homalg_variable_2014 * homalg_variable_1952;;
gap> homalg_variable_2018 := homalg_variable_2017 - homalg_variable_860;;
gap> homalg_variable_2019 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2018 = homalg_variable_2019;
true
gap> homalg_variable_2021 := homalg_variable_1969 * homalg_variable_1903;;
gap> homalg_variable_2022 := homalg_variable_2014 * homalg_variable_1903;;
gap> homalg_variable_2023 := SIH_UnionOfRows(homalg_variable_2021,homalg_variable_2022);;
gap> homalg_variable_2020 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_2023);;
gap> SI_nrows(homalg_variable_2020);
1
gap> homalg_variable_2024 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2020 = homalg_variable_2024;
false
gap> homalg_variable_2025 := SIH_BasisOfRowModule(homalg_variable_2020);;
gap> SI_nrows(homalg_variable_2025);
1
gap> homalg_variable_2026 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2025 = homalg_variable_2026;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_2020);; homalg_variable_2027 := homalg_variable_l[1];; homalg_variable_2028 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_2027);
1
gap> homalg_variable_2029 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2027 = homalg_variable_2029;
false
gap> SI_ncols(homalg_variable_2028);
1
gap> homalg_variable_2030 := homalg_variable_2028 * homalg_variable_2020;;
gap> homalg_variable_2027 = homalg_variable_2030;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2025,homalg_variable_2027);; homalg_variable_2031 := homalg_variable_l[1];; homalg_variable_2032 := homalg_variable_l[2];;
gap> homalg_variable_2033 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2031 = homalg_variable_2033;
true
gap> homalg_variable_2034 := homalg_variable_2032 * homalg_variable_2027;;
gap> homalg_variable_2035 := homalg_variable_2025 + homalg_variable_2034;;
gap> homalg_variable_2031 = homalg_variable_2035;
true
gap> homalg_variable_2036 := SIH_DecideZeroRows(homalg_variable_2025,homalg_variable_2027);;
gap> homalg_variable_2037 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2036 = homalg_variable_2037;
true
gap> homalg_variable_2038 := homalg_variable_2032 * (homalg_variable_8);;
gap> homalg_variable_2039 := homalg_variable_2038 * homalg_variable_2028;;
gap> homalg_variable_2040 := homalg_variable_2039 * homalg_variable_2020;;
gap> homalg_variable_2040 = homalg_variable_2025;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2020,homalg_variable_2025);; homalg_variable_2041 := homalg_variable_l[1];; homalg_variable_2042 := homalg_variable_l[2];;
gap> homalg_variable_2043 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2041 = homalg_variable_2043;
true
gap> homalg_variable_2044 := homalg_variable_2042 * homalg_variable_2025;;
gap> homalg_variable_2045 := homalg_variable_2020 + homalg_variable_2044;;
gap> homalg_variable_2041 = homalg_variable_2045;
true
gap> homalg_variable_2046 := SIH_DecideZeroRows(homalg_variable_2020,homalg_variable_2025);;
gap> homalg_variable_2047 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2046 = homalg_variable_2047;
true
gap> homalg_variable_2048 := homalg_variable_2042 * (homalg_variable_8);;
gap> homalg_variable_2049 := homalg_variable_2048 * homalg_variable_2025;;
gap> homalg_variable_2049 = homalg_variable_2020;
true
gap> homalg_variable_2050 := SIH_Submatrix(homalg_variable_2020,[1..1],[ 5 ]);;
gap> homalg_variable_2051 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2050 = homalg_variable_2051;
true
gap> homalg_variable_2052 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2053 := SIH_UnionOfColumns(homalg_variable_1563,homalg_variable_2052);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2053,homalg_variable_2027);; homalg_variable_2054 := homalg_variable_l[1];; homalg_variable_2055 := homalg_variable_l[2];;
gap> homalg_variable_2056 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2054 = homalg_variable_2056;
true
gap> homalg_variable_2057 := homalg_variable_2055 * homalg_variable_2027;;
gap> homalg_variable_2058 := homalg_variable_2053 + homalg_variable_2057;;
gap> homalg_variable_2054 = homalg_variable_2058;
true
gap> homalg_variable_2059 := SIH_DecideZeroRows(homalg_variable_2053,homalg_variable_2027);;
gap> homalg_variable_2060 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2059 = homalg_variable_2060;
true
gap> SI_ncols(homalg_variable_2028);
1
gap> SI_nrows(homalg_variable_2028);
1
gap> homalg_variable_2061 := homalg_variable_2055 * (homalg_variable_8);;
gap> homalg_variable_2062 := homalg_variable_2061 * homalg_variable_2028;;
gap> homalg_variable_2063 := homalg_variable_2062 * homalg_variable_2020;;
gap> homalg_variable_2064 := homalg_variable_2063 - homalg_variable_2053;;
gap> homalg_variable_2065 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2064 = homalg_variable_2065;
true
gap> homalg_variable_2066 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_2062);;
gap> SI_nrows(homalg_variable_2066);
1
gap> homalg_variable_2067 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2066 = homalg_variable_2067;
true
gap> homalg_variable_2068 := SIH_Submatrix(homalg_variable_2021,[1..4],[ 1, 2, 3, 4, 5, 6, 7 ]);;
gap> homalg_variable_2069 := homalg_variable_2068 * homalg_variable_1904;;
gap> homalg_variable_2070 := SIH_Submatrix(homalg_variable_2022,[1..1],[ 1, 2, 3, 4, 5, 6, 7 ]);;
gap> homalg_variable_2071 := homalg_variable_2070 * homalg_variable_1904;;
gap> homalg_variable_2072 := SIH_UnionOfRows(homalg_variable_2069,homalg_variable_2071);;
gap> homalg_variable_2073 := SIH_Submatrix(homalg_variable_2021,[1..4],[ 8, 9, 10 ]);;
gap> homalg_variable_2074 := homalg_variable_2073 * homalg_variable_1905;;
gap> homalg_variable_2075 := SIH_Submatrix(homalg_variable_2022,[1..1],[ 8, 9, 10 ]);;
gap> homalg_variable_2076 := homalg_variable_2075 * homalg_variable_1905;;
gap> homalg_variable_2077 := SIH_UnionOfRows(homalg_variable_2074,homalg_variable_2076);;
gap> homalg_variable_2078 := homalg_variable_2072 + homalg_variable_2077;;
gap> homalg_variable_2079 := SI_matrix(homalg_variable_5,5,10,"0");;
gap> homalg_variable_2078 = homalg_variable_2079;
true
gap> homalg_variable_2080 := SIH_Submatrix(homalg_variable_2020,[1..1],[ 1, 2, 3, 4 ]);;
gap> homalg_variable_2081 := homalg_variable_2062 * homalg_variable_2080;;
gap> homalg_variable_2082 := homalg_variable_2081 * homalg_variable_2021;;
gap> homalg_variable_2083 := SIH_Submatrix(homalg_variable_2020,[1..1],[ 5 ]);;
gap> homalg_variable_2084 := homalg_variable_2062 * homalg_variable_2083;;
gap> homalg_variable_2085 := homalg_variable_2084 * homalg_variable_2022;;
gap> homalg_variable_2086 := homalg_variable_2082 + homalg_variable_2085;;
gap> homalg_variable_2087 := SI_matrix(homalg_variable_5,1,10,"0");;
gap> homalg_variable_2086 = homalg_variable_2087;
true
gap> homalg_variable_2088 := SI_matrix(homalg_variable_5,7,3,"0");;
gap> homalg_variable_2089 := SIH_UnionOfRows(homalg_variable_2088,homalg_variable_1661);;
gap> homalg_variable_2090 := SIH_Submatrix(homalg_variable_1904,[1..7],[ 8, 9, 10 ]);;
gap> homalg_variable_2091 := SIH_Submatrix(homalg_variable_1905,[1..3],[ 8, 9, 10 ]);;
gap> homalg_variable_2092 := SIH_UnionOfRows(homalg_variable_2090,homalg_variable_2091);;
gap> homalg_variable_2093 := homalg_variable_2089 - homalg_variable_2092;;
gap> homalg_variable_2094 := SI_matrix(homalg_variable_5,10,3,"0");;
gap> homalg_variable_2093 = homalg_variable_2094;
true
gap> homalg_variable_2095 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2096 := SIH_UnionOfRows(homalg_variable_2095,homalg_variable_1709);;
gap> homalg_variable_2097 := SIH_Submatrix(homalg_variable_2021,[1..4],[ 8, 9, 10 ]);;
gap> homalg_variable_2098 := SIH_Submatrix(homalg_variable_2022,[1..1],[ 8, 9, 10 ]);;
gap> homalg_variable_2099 := SIH_UnionOfRows(homalg_variable_2097,homalg_variable_2098);;
gap> homalg_variable_2100 := homalg_variable_2096 - homalg_variable_2099;;
gap> homalg_variable_2101 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_2100 = homalg_variable_2101;
true
gap> homalg_variable_2102 := SIH_Submatrix(homalg_variable_2020,[1..1],[ 5 ]);;
gap> homalg_variable_2103 := homalg_variable_2062 * homalg_variable_2102;;
gap> homalg_variable_2104 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2103 = homalg_variable_2104;
true
gap> homalg_variable_2105 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2106 := SIH_UnionOfColumns(homalg_variable_1470,homalg_variable_2105);;
gap> homalg_variable_2107 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2108 := SIH_UnionOfColumns(homalg_variable_1471,homalg_variable_2107);;
gap> homalg_variable_2109 := SIH_UnionOfRows(homalg_variable_2106,homalg_variable_2108);;
gap> homalg_variable_2110 := homalg_variable_1904 - homalg_variable_2109;;
gap> homalg_variable_2111 := SI_matrix(homalg_variable_5,7,10,"0");;
gap> homalg_variable_2110 = homalg_variable_2111;
true
gap> homalg_variable_2112 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2113 := SIH_UnionOfColumns(homalg_variable_1564,homalg_variable_2112);;
gap> homalg_variable_2114 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2115 := SIH_UnionOfColumns(homalg_variable_1565,homalg_variable_2114);;
gap> homalg_variable_2116 := SIH_UnionOfRows(homalg_variable_2113,homalg_variable_2115);;
gap> homalg_variable_2117 := homalg_variable_2021 - homalg_variable_2116;;
gap> homalg_variable_2118 := SI_matrix(homalg_variable_5,4,10,"0");;
gap> homalg_variable_2117 = homalg_variable_2118;
true
gap> homalg_variable_2119 := homalg_variable_2062 * homalg_variable_2020;;
gap> homalg_variable_2120 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2121 := SIH_UnionOfColumns(homalg_variable_1563,homalg_variable_2120);;
gap> homalg_variable_2122 := homalg_variable_2119 - homalg_variable_2121;;
gap> homalg_variable_2123 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2122 = homalg_variable_2123;
true
gap> homalg_variable_2125 := SIH_UnionOfRows(homalg_variable_1655,homalg_variable_860);;
gap> homalg_variable_2124 := SIH_BasisOfRowModule(homalg_variable_2125);;
gap> SI_nrows(homalg_variable_2124);
1
gap> homalg_variable_2126 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2124 = homalg_variable_2126;
false
gap> homalg_variable_2127 := SIH_DecideZeroRows(homalg_variable_860,homalg_variable_2124);;
gap> homalg_variable_2128 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2127 = homalg_variable_2128;
true
gap> homalg_variable_2129 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_2125);;
gap> SI_nrows(homalg_variable_2129);
3
gap> homalg_variable_2130 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_2129 = homalg_variable_2130;
false
gap> homalg_variable_2131 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_2129);;
gap> SI_nrows(homalg_variable_2131);
1
gap> homalg_variable_2132 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2131 = homalg_variable_2132;
true
gap> homalg_variable_2133 := SIH_BasisOfRowModule(homalg_variable_2129);;
gap> SI_nrows(homalg_variable_2133);
6
gap> homalg_variable_2134 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_2133 = homalg_variable_2134;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_2129);; homalg_variable_2135 := homalg_variable_l[1];; homalg_variable_2136 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_2135);
6
gap> homalg_variable_2137 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_2135 = homalg_variable_2137;
false
gap> SI_ncols(homalg_variable_2136);
3
gap> homalg_variable_2138 := homalg_variable_2136 * homalg_variable_2129;;
gap> homalg_variable_2135 = homalg_variable_2138;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2133,homalg_variable_2135);; homalg_variable_2139 := homalg_variable_l[1];; homalg_variable_2140 := homalg_variable_l[2];;
gap> homalg_variable_2141 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_2139 = homalg_variable_2141;
true
gap> homalg_variable_2142 := homalg_variable_2140 * homalg_variable_2135;;
gap> homalg_variable_2143 := homalg_variable_2133 + homalg_variable_2142;;
gap> homalg_variable_2139 = homalg_variable_2143;
true
gap> homalg_variable_2144 := SIH_DecideZeroRows(homalg_variable_2133,homalg_variable_2135);;
gap> homalg_variable_2145 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_2144 = homalg_variable_2145;
true
gap> homalg_variable_2146 := homalg_variable_2140 * (homalg_variable_8);;
gap> homalg_variable_2147 := homalg_variable_2146 * homalg_variable_2136;;
gap> homalg_variable_2148 := homalg_variable_2147 * homalg_variable_2129;;
gap> homalg_variable_2148 = homalg_variable_2133;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2129,homalg_variable_2133);; homalg_variable_2149 := homalg_variable_l[1];; homalg_variable_2150 := homalg_variable_l[2];;
gap> homalg_variable_2151 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_2149 = homalg_variable_2151;
true
gap> homalg_variable_2152 := homalg_variable_2150 * homalg_variable_2133;;
gap> homalg_variable_2153 := homalg_variable_2129 + homalg_variable_2152;;
gap> homalg_variable_2149 = homalg_variable_2153;
true
gap> homalg_variable_2154 := SIH_DecideZeroRows(homalg_variable_2129,homalg_variable_2133);;
gap> homalg_variable_2155 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_2154 = homalg_variable_2155;
true
gap> homalg_variable_2156 := homalg_variable_2150 * (homalg_variable_8);;
gap> homalg_variable_2157 := homalg_variable_2156 * homalg_variable_2133;;
gap> homalg_variable_2157 = homalg_variable_2129;
true
gap> SIH_ZeroRows(homalg_variable_2129);
[  ]
gap> SIH_ZeroRows(homalg_variable_157);
[  ]
gap> homalg_variable_2158 := homalg_variable_493 * homalg_variable_157;;
gap> homalg_variable_2159 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_2158 = homalg_variable_2159;
true
gap> homalg_variable_2160 := SIH_DecideZeroRows(homalg_variable_493,homalg_variable_497);;
gap> homalg_variable_2161 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2160 = homalg_variable_2161;
true
gap> homalg_variable_2162 := SIH_Submatrix(homalg_variable_2129,[1..3],[ 4 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2162,homalg_variable_157);; homalg_variable_2163 := homalg_variable_l[1];; homalg_variable_2164 := homalg_variable_l[2];;
gap> homalg_variable_2165 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_2163 = homalg_variable_2165;
true
gap> homalg_variable_2166 := homalg_variable_2164 * homalg_variable_157;;
gap> homalg_variable_2167 := homalg_variable_2162 + homalg_variable_2166;;
gap> homalg_variable_2163 = homalg_variable_2167;
true
gap> homalg_variable_2168 := SIH_DecideZeroRows(homalg_variable_2162,homalg_variable_157);;
gap> homalg_variable_2169 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_2168 = homalg_variable_2169;
true
gap> homalg_variable_2170 := homalg_variable_2164 * (homalg_variable_8);;
gap> homalg_variable_2171 := homalg_variable_2170 * homalg_variable_157;;
gap> homalg_variable_2172 := homalg_variable_2171 - homalg_variable_2162;;
gap> homalg_variable_2173 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_2172 = homalg_variable_2173;
true
gap> homalg_variable_2174 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_2175 := SIH_UnionOfColumns(homalg_variable_1661,homalg_variable_2174);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2175,homalg_variable_2135);; homalg_variable_2176 := homalg_variable_l[1];; homalg_variable_2177 := homalg_variable_l[2];;
gap> homalg_variable_2178 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_2176 = homalg_variable_2178;
true
gap> homalg_variable_2179 := homalg_variable_2177 * homalg_variable_2135;;
gap> homalg_variable_2180 := homalg_variable_2175 + homalg_variable_2179;;
gap> homalg_variable_2176 = homalg_variable_2180;
true
gap> homalg_variable_2181 := SIH_DecideZeroRows(homalg_variable_2175,homalg_variable_2135);;
gap> homalg_variable_2182 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_2181 = homalg_variable_2182;
true
gap> SI_ncols(homalg_variable_2136);
3
gap> SI_nrows(homalg_variable_2136);
6
gap> homalg_variable_2183 := homalg_variable_2177 * (homalg_variable_8);;
gap> homalg_variable_2184 := homalg_variable_2183 * homalg_variable_2136;;
gap> homalg_variable_2185 := homalg_variable_2184 * homalg_variable_2129;;
gap> homalg_variable_2186 := homalg_variable_2185 - homalg_variable_2175;;
gap> homalg_variable_2187 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_2186 = homalg_variable_2187;
true
gap> homalg_variable_2188 := homalg_variable_1711 * homalg_variable_2184;;
gap> homalg_variable_2189 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2188 = homalg_variable_2189;
true
gap> homalg_variable_2190 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_2184);;
gap> SI_nrows(homalg_variable_2190);
1
gap> homalg_variable_2191 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2190 = homalg_variable_2191;
false
gap> homalg_variable_2192 := SIH_BasisOfRowModule(homalg_variable_2190);;
gap> SI_nrows(homalg_variable_2192);
1
gap> homalg_variable_2193 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2192 = homalg_variable_2193;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_2190);; homalg_variable_2194 := homalg_variable_l[1];; homalg_variable_2195 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_2194);
1
gap> homalg_variable_2196 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2194 = homalg_variable_2196;
false
gap> SI_ncols(homalg_variable_2195);
1
gap> homalg_variable_2197 := homalg_variable_2195 * homalg_variable_2190;;
gap> homalg_variable_2194 = homalg_variable_2197;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2192,homalg_variable_2194);; homalg_variable_2198 := homalg_variable_l[1];; homalg_variable_2199 := homalg_variable_l[2];;
gap> homalg_variable_2200 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2198 = homalg_variable_2200;
true
gap> homalg_variable_2201 := homalg_variable_2199 * homalg_variable_2194;;
gap> homalg_variable_2202 := homalg_variable_2192 + homalg_variable_2201;;
gap> homalg_variable_2198 = homalg_variable_2202;
true
gap> homalg_variable_2203 := SIH_DecideZeroRows(homalg_variable_2192,homalg_variable_2194);;
gap> homalg_variable_2204 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2203 = homalg_variable_2204;
true
gap> homalg_variable_2205 := homalg_variable_2199 * (homalg_variable_8);;
gap> homalg_variable_2206 := homalg_variable_2205 * homalg_variable_2195;;
gap> homalg_variable_2207 := homalg_variable_2206 * homalg_variable_2190;;
gap> homalg_variable_2207 = homalg_variable_2192;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2190,homalg_variable_2192);; homalg_variable_2208 := homalg_variable_l[1];; homalg_variable_2209 := homalg_variable_l[2];;
gap> homalg_variable_2210 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2208 = homalg_variable_2210;
true
gap> homalg_variable_2211 := homalg_variable_2209 * homalg_variable_2192;;
gap> homalg_variable_2212 := homalg_variable_2190 + homalg_variable_2211;;
gap> homalg_variable_2208 = homalg_variable_2212;
true
gap> homalg_variable_2213 := SIH_DecideZeroRows(homalg_variable_2190,homalg_variable_2192);;
gap> homalg_variable_2214 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2213 = homalg_variable_2214;
true
gap> homalg_variable_2215 := homalg_variable_2209 * (homalg_variable_8);;
gap> homalg_variable_2216 := homalg_variable_2215 * homalg_variable_2192;;
gap> homalg_variable_2216 = homalg_variable_2190;
true
gap> homalg_variable_2217 := SIH_DecideZeroRows(homalg_variable_2190,homalg_variable_1711);;
gap> homalg_variable_2218 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2217 = homalg_variable_2218;
true
gap> homalg_variable_2220 := SIH_UnionOfRows(homalg_variable_2170,homalg_variable_497);;
gap> homalg_variable_2219 := SIH_BasisOfRowModule(homalg_variable_2220);;
gap> SI_nrows(homalg_variable_2219);
3
gap> homalg_variable_2221 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2219 = homalg_variable_2221;
false
gap> homalg_variable_2222 := SIH_DecideZeroRows(homalg_variable_1101,homalg_variable_2219);;
gap> homalg_variable_2223 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2222 = homalg_variable_2223;
true
gap> homalg_variable_2225 := SIH_UnionOfRows(homalg_variable_1101,homalg_variable_497);;
gap> homalg_variable_2224 := SIH_BasisOfRowModule(homalg_variable_2225);;
gap> SI_nrows(homalg_variable_2224);
3
gap> homalg_variable_2226 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2224 = homalg_variable_2226;
false
gap> homalg_variable_2227 := SIH_DecideZeroRows(homalg_variable_1101,homalg_variable_2224);;
gap> homalg_variable_2228 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2227 = homalg_variable_2228;
true
gap> homalg_variable_2229 := SIH_DecideZeroRows(homalg_variable_2170,homalg_variable_497);;
gap> homalg_variable_2230 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2229 = homalg_variable_2230;
false
gap> homalg_variable_2231 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2164 = homalg_variable_2231;
false
gap> homalg_variable_2232 := SIH_UnionOfRows(homalg_variable_2229,homalg_variable_497);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_2232);; homalg_variable_2233 := homalg_variable_l[1];; homalg_variable_2234 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_2233);
3
gap> homalg_variable_2235 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2233 = homalg_variable_2235;
false
gap> SI_ncols(homalg_variable_2234);
6
gap> homalg_variable_2236 := SIH_Submatrix(homalg_variable_2234,[1..3],[ 1, 2, 3 ]);;
gap> homalg_variable_2237 := homalg_variable_2236 * homalg_variable_2229;;
gap> homalg_variable_2238 := SIH_Submatrix(homalg_variable_2234,[1..3],[ 4, 5, 6 ]);;
gap> homalg_variable_2239 := homalg_variable_2238 * homalg_variable_497;;
gap> homalg_variable_2240 := homalg_variable_2237 + homalg_variable_2239;;
gap> homalg_variable_2233 = homalg_variable_2240;
true
gap> homalg_variable_2241 := SIH_DecideZeroRows(homalg_variable_1101,homalg_variable_497);;
gap> homalg_variable_2242 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2241 = homalg_variable_2242;
false
gap> homalg_variable_2233 = homalg_variable_1101;
true
gap> homalg_variable_2244 := SIH_Submatrix(homalg_variable_2234,[1..3],[ 1, 2, 3 ]);;
gap> homalg_variable_2245 := homalg_variable_2241 * homalg_variable_2244;;
gap> homalg_variable_2246 := homalg_variable_2245 * homalg_variable_2170;;
gap> homalg_variable_2247 := homalg_variable_2246 - homalg_variable_1101;;
gap> homalg_variable_2243 := SIH_DecideZeroRows(homalg_variable_2247,homalg_variable_497);;
gap> homalg_variable_2248 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2243 = homalg_variable_2248;
true
gap> homalg_variable_2250 := homalg_variable_2184 * homalg_variable_2129;;
gap> homalg_variable_2251 := homalg_variable_2245 * homalg_variable_2129;;
gap> homalg_variable_2252 := SIH_UnionOfRows(homalg_variable_2250,homalg_variable_2251);;
gap> homalg_variable_2249 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_2252);;
gap> SI_nrows(homalg_variable_2249);
3
gap> homalg_variable_2253 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_2249 = homalg_variable_2253;
false
gap> homalg_variable_2254 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_2249);;
gap> SI_nrows(homalg_variable_2254);
1
gap> homalg_variable_2255 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2254 = homalg_variable_2255;
true
gap> homalg_variable_2256 := SIH_BasisOfRowModule(homalg_variable_2249);;
gap> SI_nrows(homalg_variable_2256);
4
gap> homalg_variable_2257 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_2256 = homalg_variable_2257;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_2249);; homalg_variable_2258 := homalg_variable_l[1];; homalg_variable_2259 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_2258);
4
gap> homalg_variable_2260 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_2258 = homalg_variable_2260;
false
gap> SI_ncols(homalg_variable_2259);
3
gap> homalg_variable_2261 := homalg_variable_2259 * homalg_variable_2249;;
gap> homalg_variable_2258 = homalg_variable_2261;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2256,homalg_variable_2258);; homalg_variable_2262 := homalg_variable_l[1];; homalg_variable_2263 := homalg_variable_l[2];;
gap> homalg_variable_2264 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_2262 = homalg_variable_2264;
true
gap> homalg_variable_2265 := homalg_variable_2263 * homalg_variable_2258;;
gap> homalg_variable_2266 := homalg_variable_2256 + homalg_variable_2265;;
gap> homalg_variable_2262 = homalg_variable_2266;
true
gap> homalg_variable_2267 := SIH_DecideZeroRows(homalg_variable_2256,homalg_variable_2258);;
gap> homalg_variable_2268 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_2267 = homalg_variable_2268;
true
gap> homalg_variable_2269 := homalg_variable_2263 * (homalg_variable_8);;
gap> homalg_variable_2270 := homalg_variable_2269 * homalg_variable_2259;;
gap> homalg_variable_2271 := homalg_variable_2270 * homalg_variable_2249;;
gap> homalg_variable_2271 = homalg_variable_2256;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2249,homalg_variable_2256);; homalg_variable_2272 := homalg_variable_l[1];; homalg_variable_2273 := homalg_variable_l[2];;
gap> homalg_variable_2274 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_2272 = homalg_variable_2274;
true
gap> homalg_variable_2275 := homalg_variable_2273 * homalg_variable_2256;;
gap> homalg_variable_2276 := homalg_variable_2249 + homalg_variable_2275;;
gap> homalg_variable_2272 = homalg_variable_2276;
true
gap> homalg_variable_2277 := SIH_DecideZeroRows(homalg_variable_2249,homalg_variable_2256);;
gap> homalg_variable_2278 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_2277 = homalg_variable_2278;
true
gap> homalg_variable_2279 := homalg_variable_2273 * (homalg_variable_8);;
gap> homalg_variable_2280 := homalg_variable_2279 * homalg_variable_2256;;
gap> homalg_variable_2280 = homalg_variable_2249;
true
gap> SIH_ZeroRows(homalg_variable_2249);
[  ]
gap> SIH_ZeroRows(homalg_variable_493);
[  ]
gap> homalg_variable_2281 := homalg_variable_495 * homalg_variable_493;;
gap> homalg_variable_2282 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2281 = homalg_variable_2282;
true
gap> homalg_variable_2283 := SIH_DecideZeroRows(homalg_variable_495,homalg_variable_523);;
gap> homalg_variable_2284 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2283 = homalg_variable_2284;
true
gap> homalg_variable_2285 := SIH_Submatrix(homalg_variable_2249,[1..3],[ 4, 5, 6 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2285,homalg_variable_493);; homalg_variable_2286 := homalg_variable_l[1];; homalg_variable_2287 := homalg_variable_l[2];;
gap> homalg_variable_2288 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2286 = homalg_variable_2288;
true
gap> homalg_variable_2289 := homalg_variable_2287 * homalg_variable_493;;
gap> homalg_variable_2290 := homalg_variable_2285 + homalg_variable_2289;;
gap> homalg_variable_2286 = homalg_variable_2290;
true
gap> homalg_variable_2291 := SIH_DecideZeroRows(homalg_variable_2285,homalg_variable_497);;
gap> homalg_variable_2292 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2291 = homalg_variable_2292;
true
gap> homalg_variable_2293 := homalg_variable_2287 * (homalg_variable_8);;
gap> homalg_variable_2294 := homalg_variable_2293 * homalg_variable_493;;
gap> homalg_variable_2295 := homalg_variable_2294 - homalg_variable_2285;;
gap> homalg_variable_2296 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2295 = homalg_variable_2296;
true
gap> homalg_variable_2297 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2298 := SIH_UnionOfColumns(homalg_variable_1709,homalg_variable_2297);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2298,homalg_variable_2258);; homalg_variable_2299 := homalg_variable_l[1];; homalg_variable_2300 := homalg_variable_l[2];;
gap> homalg_variable_2301 := SI_matrix(homalg_variable_5,1,6,"0");;
gap> homalg_variable_2299 = homalg_variable_2301;
true
gap> homalg_variable_2302 := homalg_variable_2300 * homalg_variable_2258;;
gap> homalg_variable_2303 := homalg_variable_2298 + homalg_variable_2302;;
gap> homalg_variable_2299 = homalg_variable_2303;
true
gap> homalg_variable_2304 := SIH_DecideZeroRows(homalg_variable_2298,homalg_variable_2258);;
gap> homalg_variable_2305 := SI_matrix(homalg_variable_5,1,6,"0");;
gap> homalg_variable_2304 = homalg_variable_2305;
true
gap> SI_ncols(homalg_variable_2259);
3
gap> SI_nrows(homalg_variable_2259);
4
gap> homalg_variable_2306 := homalg_variable_2300 * (homalg_variable_8);;
gap> homalg_variable_2307 := homalg_variable_2306 * homalg_variable_2259;;
gap> homalg_variable_2308 := homalg_variable_2307 * homalg_variable_2249;;
gap> homalg_variable_2309 := homalg_variable_2308 - homalg_variable_2298;;
gap> homalg_variable_2310 := SI_matrix(homalg_variable_5,1,6,"0");;
gap> homalg_variable_2309 = homalg_variable_2310;
true
gap> homalg_variable_2311 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_2307);;
gap> SI_nrows(homalg_variable_2311);
1
gap> homalg_variable_2312 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2311 = homalg_variable_2312;
true
gap> homalg_variable_2314 := SIH_UnionOfRows(homalg_variable_2293,homalg_variable_523);;
gap> homalg_variable_2313 := SIH_BasisOfRowModule(homalg_variable_2314);;
gap> SI_nrows(homalg_variable_2313);
3
gap> homalg_variable_2315 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2313 = homalg_variable_2315;
false
gap> homalg_variable_2316 := SIH_DecideZeroRows(homalg_variable_1101,homalg_variable_2313);;
gap> homalg_variable_2317 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2316 = homalg_variable_2317;
true
gap> homalg_variable_2319 := SIH_UnionOfRows(homalg_variable_1101,homalg_variable_523);;
gap> homalg_variable_2318 := SIH_BasisOfRowModule(homalg_variable_2319);;
gap> SI_nrows(homalg_variable_2318);
3
gap> homalg_variable_2320 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2318 = homalg_variable_2320;
false
gap> homalg_variable_2321 := SIH_DecideZeroRows(homalg_variable_1101,homalg_variable_2318);;
gap> homalg_variable_2322 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2321 = homalg_variable_2322;
true
gap> homalg_variable_2323 := SIH_DecideZeroRows(homalg_variable_2293,homalg_variable_523);;
gap> homalg_variable_2324 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2323 = homalg_variable_2324;
false
gap> homalg_variable_2325 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2287 = homalg_variable_2325;
false
gap> homalg_variable_2326 := SIH_UnionOfRows(homalg_variable_2323,homalg_variable_523);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_2326);; homalg_variable_2327 := homalg_variable_l[1];; homalg_variable_2328 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_2327);
3
gap> homalg_variable_2329 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2327 = homalg_variable_2329;
false
gap> SI_ncols(homalg_variable_2328);
4
gap> homalg_variable_2330 := SIH_Submatrix(homalg_variable_2328,[1..3],[ 1, 2, 3 ]);;
gap> homalg_variable_2331 := homalg_variable_2330 * homalg_variable_2323;;
gap> homalg_variable_2332 := SIH_Submatrix(homalg_variable_2328,[1..3],[ 4 ]);;
gap> homalg_variable_2333 := homalg_variable_2332 * homalg_variable_523;;
gap> homalg_variable_2334 := homalg_variable_2331 + homalg_variable_2333;;
gap> homalg_variable_2327 = homalg_variable_2334;
true
gap> homalg_variable_2335 := SIH_DecideZeroRows(homalg_variable_1101,homalg_variable_523);;
gap> homalg_variable_2336 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2335 = homalg_variable_2336;
false
gap> homalg_variable_2327 = homalg_variable_1101;
true
gap> homalg_variable_2338 := SIH_Submatrix(homalg_variable_2328,[1..3],[ 1, 2, 3 ]);;
gap> homalg_variable_2339 := homalg_variable_2335 * homalg_variable_2338;;
gap> homalg_variable_2340 := homalg_variable_2339 * homalg_variable_2293;;
gap> homalg_variable_2341 := homalg_variable_2340 - homalg_variable_1101;;
gap> homalg_variable_2337 := SIH_DecideZeroRows(homalg_variable_2341,homalg_variable_523);;
gap> homalg_variable_2342 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2337 = homalg_variable_2342;
true
gap> homalg_variable_2344 := homalg_variable_2307 * homalg_variable_2249;;
gap> homalg_variable_2345 := homalg_variable_2339 * homalg_variable_2249;;
gap> homalg_variable_2346 := SIH_UnionOfRows(homalg_variable_2344,homalg_variable_2345);;
gap> homalg_variable_2343 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_2346);;
gap> SI_nrows(homalg_variable_2343);
1
gap> homalg_variable_2347 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2343 = homalg_variable_2347;
false
gap> homalg_variable_2348 := SIH_BasisOfRowModule(homalg_variable_2343);;
gap> SI_nrows(homalg_variable_2348);
1
gap> homalg_variable_2349 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2348 = homalg_variable_2349;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_2343);; homalg_variable_2350 := homalg_variable_l[1];; homalg_variable_2351 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_2350);
1
gap> homalg_variable_2352 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2350 = homalg_variable_2352;
false
gap> SI_ncols(homalg_variable_2351);
1
gap> homalg_variable_2353 := homalg_variable_2351 * homalg_variable_2343;;
gap> homalg_variable_2350 = homalg_variable_2353;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2348,homalg_variable_2350);; homalg_variable_2354 := homalg_variable_l[1];; homalg_variable_2355 := homalg_variable_l[2];;
gap> homalg_variable_2356 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2354 = homalg_variable_2356;
true
gap> homalg_variable_2357 := homalg_variable_2355 * homalg_variable_2350;;
gap> homalg_variable_2358 := homalg_variable_2348 + homalg_variable_2357;;
gap> homalg_variable_2354 = homalg_variable_2358;
true
gap> homalg_variable_2359 := SIH_DecideZeroRows(homalg_variable_2348,homalg_variable_2350);;
gap> homalg_variable_2360 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2359 = homalg_variable_2360;
true
gap> homalg_variable_2361 := homalg_variable_2355 * (homalg_variable_8);;
gap> homalg_variable_2362 := homalg_variable_2361 * homalg_variable_2351;;
gap> homalg_variable_2363 := homalg_variable_2362 * homalg_variable_2343;;
gap> homalg_variable_2363 = homalg_variable_2348;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2343,homalg_variable_2348);; homalg_variable_2364 := homalg_variable_l[1];; homalg_variable_2365 := homalg_variable_l[2];;
gap> homalg_variable_2366 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2364 = homalg_variable_2366;
true
gap> homalg_variable_2367 := homalg_variable_2365 * homalg_variable_2348;;
gap> homalg_variable_2368 := homalg_variable_2343 + homalg_variable_2367;;
gap> homalg_variable_2364 = homalg_variable_2368;
true
gap> homalg_variable_2369 := SIH_DecideZeroRows(homalg_variable_2343,homalg_variable_2348);;
gap> homalg_variable_2370 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2369 = homalg_variable_2370;
true
gap> homalg_variable_2371 := homalg_variable_2365 * (homalg_variable_8);;
gap> homalg_variable_2372 := homalg_variable_2371 * homalg_variable_2348;;
gap> homalg_variable_2372 = homalg_variable_2343;
true
gap> homalg_variable_2373 := SIH_Submatrix(homalg_variable_2343,[1..1],[ 2, 3, 4 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2373,homalg_variable_495);; homalg_variable_2374 := homalg_variable_l[1];; homalg_variable_2375 := homalg_variable_l[2];;
gap> homalg_variable_2376 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2374 = homalg_variable_2376;
true
gap> homalg_variable_2377 := homalg_variable_2375 * homalg_variable_495;;
gap> homalg_variable_2378 := homalg_variable_2373 + homalg_variable_2377;;
gap> homalg_variable_2374 = homalg_variable_2378;
true
gap> homalg_variable_2379 := SIH_DecideZeroRows(homalg_variable_2373,homalg_variable_523);;
gap> homalg_variable_2380 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2379 = homalg_variable_2380;
true
gap> homalg_variable_2381 := homalg_variable_2375 * (homalg_variable_8);;
gap> homalg_variable_2382 := homalg_variable_2381 * homalg_variable_495;;
gap> homalg_variable_2383 := homalg_variable_2382 - homalg_variable_2373;;
gap> homalg_variable_2384 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2383 = homalg_variable_2384;
true
gap> homalg_variable_2385 := SIH_BasisOfRowModule(homalg_variable_2381);;
gap> SI_nrows(homalg_variable_2385);
1
gap> homalg_variable_2386 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2385 = homalg_variable_2386;
false
gap> homalg_variable_2385 = homalg_variable_2381;
true
gap> homalg_variable_2387 := SIH_DecideZeroRows(homalg_variable_860,homalg_variable_2385);;
gap> homalg_variable_2388 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2387 = homalg_variable_2388;
true
gap> homalg_variable_2381 = homalg_variable_860;
true
gap> homalg_variable_2389 := homalg_variable_2381 - homalg_variable_860;;
gap> homalg_variable_2390 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2389 = homalg_variable_2390;
true
gap> homalg_variable_2391 := SIH_Submatrix(homalg_variable_2344,[1..1],[ 1, 2, 3 ]);;
gap> homalg_variable_2392 := homalg_variable_2391 * homalg_variable_2250;;
gap> homalg_variable_2393 := SIH_Submatrix(homalg_variable_2345,[1..3],[ 1, 2, 3 ]);;
gap> homalg_variable_2394 := homalg_variable_2393 * homalg_variable_2250;;
gap> homalg_variable_2395 := SIH_UnionOfRows(homalg_variable_2392,homalg_variable_2394);;
gap> homalg_variable_2396 := SIH_Submatrix(homalg_variable_2344,[1..1],[ 4, 5, 6 ]);;
gap> homalg_variable_2397 := homalg_variable_2396 * homalg_variable_2251;;
gap> homalg_variable_2398 := SIH_Submatrix(homalg_variable_2345,[1..3],[ 4, 5, 6 ]);;
gap> homalg_variable_2399 := homalg_variable_2398 * homalg_variable_2251;;
gap> homalg_variable_2400 := SIH_UnionOfRows(homalg_variable_2397,homalg_variable_2399);;
gap> homalg_variable_2401 := homalg_variable_2395 + homalg_variable_2400;;
gap> homalg_variable_2402 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_2401 = homalg_variable_2402;
true
gap> homalg_variable_2403 := SIH_Submatrix(homalg_variable_2343,[1..1],[ 1 ]);;
gap> homalg_variable_2404 := homalg_variable_2403 * homalg_variable_2344;;
gap> homalg_variable_2405 := SIH_Submatrix(homalg_variable_2343,[1..1],[ 2, 3, 4 ]);;
gap> homalg_variable_2406 := homalg_variable_2405 * homalg_variable_2345;;
gap> homalg_variable_2407 := homalg_variable_2404 + homalg_variable_2406;;
gap> homalg_variable_2408 := SI_matrix(homalg_variable_5,1,6,"0");;
gap> homalg_variable_2407 = homalg_variable_2408;
true
gap> homalg_variable_2409 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_2410 := SIH_UnionOfRows(homalg_variable_2409,homalg_variable_157);;
gap> homalg_variable_2411 := SIH_Submatrix(homalg_variable_2250,[1..3],[ 4 ]);;
gap> homalg_variable_2412 := SIH_Submatrix(homalg_variable_2251,[1..3],[ 4 ]);;
gap> homalg_variable_2413 := SIH_UnionOfRows(homalg_variable_2411,homalg_variable_2412);;
gap> homalg_variable_2414 := homalg_variable_2410 - homalg_variable_2413;;
gap> homalg_variable_2415 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_2414 = homalg_variable_2415;
true
gap> homalg_variable_2416 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2417 := SIH_UnionOfRows(homalg_variable_2416,homalg_variable_493);;
gap> homalg_variable_2418 := SIH_Submatrix(homalg_variable_2344,[1..1],[ 4, 5, 6 ]);;
gap> homalg_variable_2419 := SIH_Submatrix(homalg_variable_2345,[1..3],[ 4, 5, 6 ]);;
gap> homalg_variable_2420 := SIH_UnionOfRows(homalg_variable_2418,homalg_variable_2419);;
gap> homalg_variable_2421 := homalg_variable_2417 - homalg_variable_2420;;
gap> homalg_variable_2422 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2421 = homalg_variable_2422;
true
gap> homalg_variable_2423 := SIH_Submatrix(homalg_variable_2343,[1..1],[ 2, 3, 4 ]);;
gap> homalg_variable_2424 := homalg_variable_495 - homalg_variable_2423;;
gap> homalg_variable_2425 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2424 = homalg_variable_2425;
true
gap> homalg_variable_2426 := SIH_UnionOfColumns(homalg_variable_1661,homalg_variable_2174);;
gap> homalg_variable_2427 := homalg_variable_2250 - homalg_variable_2426;;
gap> homalg_variable_2428 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_2427 = homalg_variable_2428;
true
gap> homalg_variable_2429 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2430 := SIH_UnionOfColumns(homalg_variable_1709,homalg_variable_2429);;
gap> homalg_variable_2431 := homalg_variable_2344 - homalg_variable_2430;;
gap> homalg_variable_2432 := SI_matrix(homalg_variable_5,1,6,"0");;
gap> homalg_variable_2431 = homalg_variable_2432;
true
gap> homalg_variable_2433 := SIH_DecideZeroColumns(homalg_variable_12,homalg_variable_99);;
gap> homalg_variable_2434 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_2433 = homalg_variable_2434;
true
gap> homalg_variable_2435 := SIH_DecideZeroColumns(homalg_variable_97,homalg_variable_124);;
gap> homalg_variable_2436 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_2435 = homalg_variable_2436;
true
gap> homalg_variable_2437 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_990);;
gap> SI_ncols(homalg_variable_2437);
1
gap> homalg_variable_2438 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_2437 = homalg_variable_2438;
true
gap> homalg_variable_2439 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_1762);;
gap> SI_ncols(homalg_variable_2439);
1
gap> homalg_variable_2440 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_2439 = homalg_variable_2440;
true
gap> homalg_variable_2442 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2443 := SIH_Submatrix(homalg_variable_705,[ 1 ],[1..4]);;
gap> homalg_variable_2444 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2445 := SIH_UnionOfColumns(homalg_variable_2443,homalg_variable_2444);;
gap> homalg_variable_2446 := SIH_UnionOfRows(homalg_variable_2442,homalg_variable_2445);;
gap> homalg_variable_2441 := SIH_BasisOfColumnModule(homalg_variable_2446);;
gap> SI_ncols(homalg_variable_2441);
1
gap> homalg_variable_2447 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_2441 = homalg_variable_2447;
false
gap> homalg_variable_2448 := SIH_DecideZeroColumns(homalg_variable_618,homalg_variable_2441);;
gap> homalg_variable_2449 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_2448 = homalg_variable_2449;
false
gap> SIH_ZeroColumns(homalg_variable_2448);
[ 2 ]
gap> homalg_variable_2451 := SIH_Submatrix(homalg_variable_2448,[1..2],[ 1 ]);;
gap> homalg_variable_2450 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2451,homalg_variable_2441);;
gap> SI_ncols(homalg_variable_2450);
1
gap> homalg_variable_2452 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2450 = homalg_variable_2452;
true
gap> homalg_variable_2453 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2451,homalg_variable_2441);;
gap> SI_ncols(homalg_variable_2453);
1
gap> homalg_variable_2454 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2453 = homalg_variable_2454;
true
gap> homalg_variable_2455 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2446);;
gap> SI_ncols(homalg_variable_2455);
4
gap> homalg_variable_2456 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_2455 = homalg_variable_2456;
false
gap> homalg_variable_2457 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2455);;
gap> SI_ncols(homalg_variable_2457);
1
gap> homalg_variable_2458 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_2457 = homalg_variable_2458;
true
gap> homalg_variable_2459 := SIH_BasisOfColumnModule(homalg_variable_2455);;
gap> SI_ncols(homalg_variable_2459);
4
gap> homalg_variable_2460 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_2459 = homalg_variable_2460;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_2455);; homalg_variable_2461 := homalg_variable_l[1];; homalg_variable_2462 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_2461);
4
gap> homalg_variable_2463 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_2461 = homalg_variable_2463;
false
gap> SI_nrows(homalg_variable_2462);
4
gap> homalg_variable_2464 := homalg_variable_2455 * homalg_variable_2462;;
gap> homalg_variable_2461 = homalg_variable_2464;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2459,homalg_variable_2461);; homalg_variable_2465 := homalg_variable_l[1];; homalg_variable_2466 := homalg_variable_l[2];;
gap> homalg_variable_2467 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_2465 = homalg_variable_2467;
true
gap> homalg_variable_2468 := homalg_variable_2461 * homalg_variable_2466;;
gap> homalg_variable_2469 := homalg_variable_2459 + homalg_variable_2468;;
gap> homalg_variable_2465 = homalg_variable_2469;
true
gap> homalg_variable_2470 := SIH_DecideZeroColumns(homalg_variable_2459,homalg_variable_2461);;
gap> homalg_variable_2471 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_2470 = homalg_variable_2471;
true
gap> homalg_variable_2472 := homalg_variable_2466 * (homalg_variable_8);;
gap> homalg_variable_2473 := homalg_variable_2462 * homalg_variable_2472;;
gap> homalg_variable_2474 := homalg_variable_2455 * homalg_variable_2473;;
gap> homalg_variable_2474 = homalg_variable_2459;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2455,homalg_variable_2459);; homalg_variable_2475 := homalg_variable_l[1];; homalg_variable_2476 := homalg_variable_l[2];;
gap> homalg_variable_2477 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_2475 = homalg_variable_2477;
true
gap> homalg_variable_2478 := homalg_variable_2459 * homalg_variable_2476;;
gap> homalg_variable_2479 := homalg_variable_2455 + homalg_variable_2478;;
gap> homalg_variable_2475 = homalg_variable_2479;
true
gap> homalg_variable_2480 := SIH_DecideZeroColumns(homalg_variable_2455,homalg_variable_2459);;
gap> homalg_variable_2481 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_2480 = homalg_variable_2481;
true
gap> homalg_variable_2482 := homalg_variable_2476 * (homalg_variable_8);;
gap> homalg_variable_2483 := homalg_variable_2459 * homalg_variable_2482;;
gap> homalg_variable_2483 = homalg_variable_2455;
true
gap> homalg_variable_2485 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_2486 := SIH_UnionOfColumns(homalg_variable_860,homalg_variable_2416);;
gap> homalg_variable_2487 := SIH_UnionOfRows(homalg_variable_2485,homalg_variable_2486);;
gap> homalg_variable_2484 := SIH_BasisOfColumnModule(homalg_variable_2487);;
gap> SI_ncols(homalg_variable_2484);
1
gap> homalg_variable_2488 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_2484 = homalg_variable_2488;
false
gap> homalg_variable_2489 := SIH_DecideZeroColumns(homalg_variable_2455,homalg_variable_2484);;
gap> homalg_variable_2490 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_2489 = homalg_variable_2490;
false
gap> SIH_ZeroColumns(homalg_variable_2489);
[ 4 ]
gap> homalg_variable_2492 := SIH_Submatrix(homalg_variable_2489,[1..5],[ 1, 2, 3 ]);;
gap> homalg_variable_2491 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2492,homalg_variable_2484);;
gap> SI_ncols(homalg_variable_2491);
1
gap> homalg_variable_2493 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_2491 = homalg_variable_2493;
true
gap> homalg_variable_2494 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2492,homalg_variable_2484);;
gap> SI_ncols(homalg_variable_2494);
1
gap> homalg_variable_2495 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_2494 = homalg_variable_2495;
true
gap> homalg_variable_2496 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2487);;
gap> SI_ncols(homalg_variable_2496);
3
gap> homalg_variable_2497 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2496 = homalg_variable_2497;
false
gap> homalg_variable_2498 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2496);;
gap> SI_ncols(homalg_variable_2498);
1
gap> homalg_variable_2499 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_2498 = homalg_variable_2499;
true
gap> homalg_variable_2500 := SIH_BasisOfColumnModule(homalg_variable_2496);;
gap> SI_ncols(homalg_variable_2500);
3
gap> for _del in [ "homalg_variable_1945", "homalg_variable_1947", "homalg_variable_1948", "homalg_variable_1949", "homalg_variable_1950", "homalg_variable_1951", "homalg_variable_1953", "homalg_variable_1954", "homalg_variable_1955", "homalg_variable_1961", "homalg_variable_1963", "homalg_variable_1964", "homalg_variable_1965", "homalg_variable_1966", "homalg_variable_1967", "homalg_variable_1970", "homalg_variable_1971", "homalg_variable_1972", "homalg_variable_1973", "homalg_variable_1974", "homalg_variable_1976", "homalg_variable_1978", "homalg_variable_1981", "homalg_variable_1982", "homalg_variable_1983", "homalg_variable_1984", "homalg_variable_1985", "homalg_variable_1986", "homalg_variable_1987", "homalg_variable_1988", "homalg_variable_1989", "homalg_variable_1990", "homalg_variable_1991", "homalg_variable_1992", "homalg_variable_1995", "homalg_variable_1996", "homalg_variable_1997", "homalg_variable_1998", "homalg_variable_1999", "homalg_variable_2002", "homalg_variable_2003", "homalg_variable_2005", "homalg_variable_2006", "homalg_variable_2007", "homalg_variable_2010", "homalg_variable_2011", "homalg_variable_2012", "homalg_variable_2015", "homalg_variable_2016", "homalg_variable_2017", "homalg_variable_2018", "homalg_variable_2019", "homalg_variable_2024", "homalg_variable_2026", "homalg_variable_2029", "homalg_variable_2030", "homalg_variable_2033", "homalg_variable_2036", "homalg_variable_2037", "homalg_variable_2040", "homalg_variable_2041", "homalg_variable_2042", "homalg_variable_2043", "homalg_variable_2044", "homalg_variable_2045", "homalg_variable_2046", "homalg_variable_2047", "homalg_variable_2048", "homalg_variable_2049", "homalg_variable_2051", "homalg_variable_2054", "homalg_variable_2056", "homalg_variable_2057", "homalg_variable_2058", "homalg_variable_2059", "homalg_variable_2060", "homalg_variable_2063", "homalg_variable_2064", "homalg_variable_2065", "homalg_variable_2066", "homalg_variable_2067", "homalg_variable_2080", "homalg_variable_2081", "homalg_variable_2082", "homalg_variable_2083", "homalg_variable_2084", "homalg_variable_2085", "homalg_variable_2086", "homalg_variable_2087", "homalg_variable_2089", "homalg_variable_2090", "homalg_variable_2091", "homalg_variable_2092", "homalg_variable_2093", "homalg_variable_2094", "homalg_variable_2095", "homalg_variable_2096", "homalg_variable_2097", "homalg_variable_2098", "homalg_variable_2099", "homalg_variable_2100", "homalg_variable_2101", "homalg_variable_2102", "homalg_variable_2103", "homalg_variable_2104", "homalg_variable_2105", "homalg_variable_2106", "homalg_variable_2107", "homalg_variable_2108", "homalg_variable_2109", "homalg_variable_2110", "homalg_variable_2111", "homalg_variable_2112", "homalg_variable_2113", "homalg_variable_2114", "homalg_variable_2115", "homalg_variable_2116", "homalg_variable_2117", "homalg_variable_2118", "homalg_variable_2120", "homalg_variable_2121", "homalg_variable_2122", "homalg_variable_2123", "homalg_variable_2126", "homalg_variable_2127", "homalg_variable_2128", "homalg_variable_2130", "homalg_variable_2131", "homalg_variable_2132", "homalg_variable_2134", "homalg_variable_2137", "homalg_variable_2138", "homalg_variable_2141", "homalg_variable_2143", "homalg_variable_2144", "homalg_variable_2145", "homalg_variable_2148", "homalg_variable_2149", "homalg_variable_2150", "homalg_variable_2151", "homalg_variable_2152", "homalg_variable_2153", "homalg_variable_2154", "homalg_variable_2155", "homalg_variable_2156", "homalg_variable_2157", "homalg_variable_2158", "homalg_variable_2159", "homalg_variable_2160", "homalg_variable_2161", "homalg_variable_2163", "homalg_variable_2165", "homalg_variable_2166", "homalg_variable_2167", "homalg_variable_2168", "homalg_variable_2169", "homalg_variable_2171", "homalg_variable_2172", "homalg_variable_2173", "homalg_variable_2176", "homalg_variable_2178", "homalg_variable_2179", "homalg_variable_2180", "homalg_variable_2181", "homalg_variable_2182", "homalg_variable_2185", "homalg_variable_2186", "homalg_variable_2187", "homalg_variable_2188", "homalg_variable_2189", "homalg_variable_2191", "homalg_variable_2193", "homalg_variable_2196", "homalg_variable_2197", "homalg_variable_2198", "homalg_variable_2199", "homalg_variable_2200", "homalg_variable_2201", "homalg_variable_2202", "homalg_variable_2203", "homalg_variable_2204", "homalg_variable_2205", "homalg_variable_2206", "homalg_variable_2207", "homalg_variable_2208", "homalg_variable_2209", "homalg_variable_2210", "homalg_variable_2211", "homalg_variable_2212", "homalg_variable_2213", "homalg_variable_2214", "homalg_variable_2215", "homalg_variable_2216", "homalg_variable_2217", "homalg_variable_2218", "homalg_variable_2221", "homalg_variable_2222", "homalg_variable_2223", "homalg_variable_2226", "homalg_variable_2227", "homalg_variable_2228", "homalg_variable_2229", "homalg_variable_2230", "homalg_variable_2231", "homalg_variable_2232", "homalg_variable_2233", "homalg_variable_2235", "homalg_variable_2236", "homalg_variable_2237", "homalg_variable_2238", "homalg_variable_2239", "homalg_variable_2240", "homalg_variable_2242", "homalg_variable_2243", "homalg_variable_2246", "homalg_variable_2247", "homalg_variable_2248", "homalg_variable_2253", "homalg_variable_2254", "homalg_variable_2255", "homalg_variable_2257", "homalg_variable_2260", "homalg_variable_2261", "homalg_variable_2262", "homalg_variable_2263", "homalg_variable_2264", "homalg_variable_2265", "homalg_variable_2266", "homalg_variable_2267", "homalg_variable_2268", "homalg_variable_2269", "homalg_variable_2270", "homalg_variable_2271", "homalg_variable_2272", "homalg_variable_2273", "homalg_variable_2274", "homalg_variable_2275", "homalg_variable_2276", "homalg_variable_2277", "homalg_variable_2278", "homalg_variable_2279", "homalg_variable_2280", "homalg_variable_2281", "homalg_variable_2282", "homalg_variable_2283", "homalg_variable_2284", "homalg_variable_2286", "homalg_variable_2288", "homalg_variable_2289", "homalg_variable_2290", "homalg_variable_2291", "homalg_variable_2292", "homalg_variable_2294", "homalg_variable_2295", "homalg_variable_2296", "homalg_variable_2301", "homalg_variable_2304", "homalg_variable_2305", "homalg_variable_2308", "homalg_variable_2309", "homalg_variable_2310", "homalg_variable_2311", "homalg_variable_2312", "homalg_variable_2315", "homalg_variable_2316", "homalg_variable_2317", "homalg_variable_2320", "homalg_variable_2321", "homalg_variable_2322", "homalg_variable_2323", "homalg_variable_2324", "homalg_variable_2325", "homalg_variable_2326", "homalg_variable_2327", "homalg_variable_2329", "homalg_variable_2330", "homalg_variable_2331", "homalg_variable_2332", "homalg_variable_2333", "homalg_variable_2334", "homalg_variable_2336", "homalg_variable_2337", "homalg_variable_2340", "homalg_variable_2341", "homalg_variable_2342", "homalg_variable_2347", "homalg_variable_2349", "homalg_variable_2352", "homalg_variable_2353", "homalg_variable_2356", "homalg_variable_2359", "homalg_variable_2360", "homalg_variable_2363", "homalg_variable_2364", "homalg_variable_2365", "homalg_variable_2366", "homalg_variable_2367", "homalg_variable_2368", "homalg_variable_2369", "homalg_variable_2370", "homalg_variable_2371", "homalg_variable_2372", "homalg_variable_2374", "homalg_variable_2376", "homalg_variable_2377", "homalg_variable_2378", "homalg_variable_2379", "homalg_variable_2380", "homalg_variable_2382", "homalg_variable_2383", "homalg_variable_2384", "homalg_variable_2386", "homalg_variable_2387", "homalg_variable_2388", "homalg_variable_2389", "homalg_variable_2390", "homalg_variable_2391", "homalg_variable_2392", "homalg_variable_2393", "homalg_variable_2394", "homalg_variable_2395", "homalg_variable_2396", "homalg_variable_2397", "homalg_variable_2398", "homalg_variable_2399", "homalg_variable_2400", "homalg_variable_2401", "homalg_variable_2402", "homalg_variable_2403", "homalg_variable_2404", "homalg_variable_2405", "homalg_variable_2406", "homalg_variable_2407", "homalg_variable_2408", "homalg_variable_2409", "homalg_variable_2410", "homalg_variable_2411", "homalg_variable_2412", "homalg_variable_2413", "homalg_variable_2414", "homalg_variable_2415", "homalg_variable_2417", "homalg_variable_2418", "homalg_variable_2419", "homalg_variable_2420", "homalg_variable_2421", "homalg_variable_2422", "homalg_variable_2423", "homalg_variable_2424", "homalg_variable_2425", "homalg_variable_2426", "homalg_variable_2427", "homalg_variable_2428", "homalg_variable_2433", "homalg_variable_2434", "homalg_variable_2435", "homalg_variable_2436", "homalg_variable_2437", "homalg_variable_2438", "homalg_variable_2439", "homalg_variable_2440", "homalg_variable_2447", "homalg_variable_2449", "homalg_variable_2450", "homalg_variable_2452", "homalg_variable_2453", "homalg_variable_2454", "homalg_variable_2456", "homalg_variable_2457", "homalg_variable_2458", "homalg_variable_2460", "homalg_variable_2463", "homalg_variable_2464", "homalg_variable_2467", "homalg_variable_2468", "homalg_variable_2469", "homalg_variable_2470", "homalg_variable_2471", "homalg_variable_2474", "homalg_variable_2475", "homalg_variable_2476", "homalg_variable_2477", "homalg_variable_2478", "homalg_variable_2479", "homalg_variable_2480", "homalg_variable_2481", "homalg_variable_2482", "homalg_variable_2483", "homalg_variable_2488", "homalg_variable_2490", "homalg_variable_2491", "homalg_variable_2493", "homalg_variable_2494", "homalg_variable_2495" ] do UnbindGlobal( _del ); od;;
gap> homalg_variable_2501 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2500 = homalg_variable_2501;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_2496);; homalg_variable_2502 := homalg_variable_l[1];; homalg_variable_2503 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_2502);
3
gap> homalg_variable_2504 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2502 = homalg_variable_2504;
false
gap> SI_nrows(homalg_variable_2503);
3
gap> homalg_variable_2505 := homalg_variable_2496 * homalg_variable_2503;;
gap> homalg_variable_2502 = homalg_variable_2505;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2500,homalg_variable_2502);; homalg_variable_2506 := homalg_variable_l[1];; homalg_variable_2507 := homalg_variable_l[2];;
gap> homalg_variable_2508 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2506 = homalg_variable_2508;
true
gap> homalg_variable_2509 := homalg_variable_2502 * homalg_variable_2507;;
gap> homalg_variable_2510 := homalg_variable_2500 + homalg_variable_2509;;
gap> homalg_variable_2506 = homalg_variable_2510;
true
gap> homalg_variable_2511 := SIH_DecideZeroColumns(homalg_variable_2500,homalg_variable_2502);;
gap> homalg_variable_2512 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2511 = homalg_variable_2512;
true
gap> homalg_variable_2513 := homalg_variable_2507 * (homalg_variable_8);;
gap> homalg_variable_2514 := homalg_variable_2503 * homalg_variable_2513;;
gap> homalg_variable_2515 := homalg_variable_2496 * homalg_variable_2514;;
gap> homalg_variable_2515 = homalg_variable_2500;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2496,homalg_variable_2500);; homalg_variable_2516 := homalg_variable_l[1];; homalg_variable_2517 := homalg_variable_l[2];;
gap> homalg_variable_2518 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2516 = homalg_variable_2518;
true
gap> homalg_variable_2519 := homalg_variable_2500 * homalg_variable_2517;;
gap> homalg_variable_2520 := homalg_variable_2496 + homalg_variable_2519;;
gap> homalg_variable_2516 = homalg_variable_2520;
true
gap> homalg_variable_2521 := SIH_DecideZeroColumns(homalg_variable_2496,homalg_variable_2500);;
gap> homalg_variable_2522 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2521 = homalg_variable_2522;
true
gap> homalg_variable_2523 := homalg_variable_2517 * (homalg_variable_8);;
gap> homalg_variable_2524 := homalg_variable_2500 * homalg_variable_2523;;
gap> homalg_variable_2524 = homalg_variable_2496;
true
gap> SIH_ZeroColumns(homalg_variable_2496);
[  ]
gap> homalg_variable_2526 := SIH_Submatrix(homalg_variable_1109,[ 1, 2 ],[1..7]);;
gap> homalg_variable_2527 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_2528 := SIH_UnionOfColumns(homalg_variable_2526,homalg_variable_2527);;
gap> homalg_variable_2525 := SIH_BasisOfColumnModule(homalg_variable_2528);;
gap> SI_ncols(homalg_variable_2525);
2
gap> homalg_variable_2529 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_2525 = homalg_variable_2529;
false
gap> homalg_variable_2530 := SIH_DecideZeroColumns(homalg_variable_618,homalg_variable_2525);;
gap> homalg_variable_2531 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_2530 = homalg_variable_2531;
true
gap> homalg_variable_2532 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2528);;
gap> SI_ncols(homalg_variable_2532);
8
gap> homalg_variable_2533 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_2532 = homalg_variable_2533;
false
gap> homalg_variable_2534 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2532);;
gap> SI_ncols(homalg_variable_2534);
1
gap> homalg_variable_2535 := SI_matrix(homalg_variable_5,8,1,"0");;
gap> homalg_variable_2534 = homalg_variable_2535;
true
gap> homalg_variable_2536 := SIH_BasisOfColumnModule(homalg_variable_2532);;
gap> SI_ncols(homalg_variable_2536);
8
gap> homalg_variable_2537 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_2536 = homalg_variable_2537;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_2532);; homalg_variable_2538 := homalg_variable_l[1];; homalg_variable_2539 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_2538);
8
gap> homalg_variable_2540 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_2538 = homalg_variable_2540;
false
gap> SI_nrows(homalg_variable_2539);
8
gap> homalg_variable_2541 := homalg_variable_2532 * homalg_variable_2539;;
gap> homalg_variable_2538 = homalg_variable_2541;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2536,homalg_variable_2538);; homalg_variable_2542 := homalg_variable_l[1];; homalg_variable_2543 := homalg_variable_l[2];;
gap> homalg_variable_2544 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_2542 = homalg_variable_2544;
true
gap> homalg_variable_2545 := homalg_variable_2538 * homalg_variable_2543;;
gap> homalg_variable_2546 := homalg_variable_2536 + homalg_variable_2545;;
gap> homalg_variable_2542 = homalg_variable_2546;
true
gap> homalg_variable_2547 := SIH_DecideZeroColumns(homalg_variable_2536,homalg_variable_2538);;
gap> homalg_variable_2548 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_2547 = homalg_variable_2548;
true
gap> homalg_variable_2549 := homalg_variable_2543 * (homalg_variable_8);;
gap> homalg_variable_2550 := homalg_variable_2539 * homalg_variable_2549;;
gap> homalg_variable_2551 := homalg_variable_2532 * homalg_variable_2550;;
gap> homalg_variable_2551 = homalg_variable_2536;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2532,homalg_variable_2536);; homalg_variable_2552 := homalg_variable_l[1];; homalg_variable_2553 := homalg_variable_l[2];;
gap> homalg_variable_2554 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_2552 = homalg_variable_2554;
true
gap> homalg_variable_2555 := homalg_variable_2536 * homalg_variable_2553;;
gap> homalg_variable_2556 := homalg_variable_2532 + homalg_variable_2555;;
gap> homalg_variable_2552 = homalg_variable_2556;
true
gap> homalg_variable_2557 := SIH_DecideZeroColumns(homalg_variable_2532,homalg_variable_2536);;
gap> homalg_variable_2558 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_2557 = homalg_variable_2558;
true
gap> homalg_variable_2559 := homalg_variable_2553 * (homalg_variable_8);;
gap> homalg_variable_2560 := homalg_variable_2536 * homalg_variable_2559;;
gap> homalg_variable_2560 = homalg_variable_2532;
true
gap> homalg_variable_2562 := SI_matrix(homalg_variable_5,7,10,"0");;
gap> homalg_variable_2563 := SIH_Submatrix(homalg_variable_1109,[ 1, 2, 3 ],[1..7]);;
gap> homalg_variable_2564 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2565 := SIH_UnionOfColumns(homalg_variable_2563,homalg_variable_2564);;
gap> homalg_variable_2566 := SIH_UnionOfRows(homalg_variable_2562,homalg_variable_2565);;
gap> homalg_variable_2561 := SIH_BasisOfColumnModule(homalg_variable_2566);;
gap> SI_ncols(homalg_variable_2561);
3
gap> homalg_variable_2567 := SI_matrix(homalg_variable_5,10,3,"0");;
gap> homalg_variable_2561 = homalg_variable_2567;
false
gap> homalg_variable_2568 := SIH_DecideZeroColumns(homalg_variable_2532,homalg_variable_2561);;
gap> homalg_variable_2569 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_2568 = homalg_variable_2569;
false
gap> SIH_ZeroColumns(homalg_variable_2568);
[ 6, 7, 8 ]
gap> homalg_variable_2571 := SIH_Submatrix(homalg_variable_2568,[1..10],[ 1, 2, 3, 4, 5 ]);;
gap> homalg_variable_2570 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2571,homalg_variable_2561);;
gap> SI_ncols(homalg_variable_2570);
1
gap> homalg_variable_2572 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_2570 = homalg_variable_2572;
true
gap> homalg_variable_2573 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2571,homalg_variable_2561);;
gap> SI_ncols(homalg_variable_2573);
1
gap> homalg_variable_2574 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_2573 = homalg_variable_2574;
true
gap> homalg_variable_2575 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2566);;
gap> SI_ncols(homalg_variable_2575);
7
gap> homalg_variable_2576 := SI_matrix(homalg_variable_5,10,7,"0");;
gap> homalg_variable_2575 = homalg_variable_2576;
false
gap> homalg_variable_2577 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2575);;
gap> SI_ncols(homalg_variable_2577);
1
gap> homalg_variable_2578 := SI_matrix(homalg_variable_5,7,1,"0");;
gap> homalg_variable_2577 = homalg_variable_2578;
true
gap> homalg_variable_2579 := SIH_BasisOfColumnModule(homalg_variable_2575);;
gap> SI_ncols(homalg_variable_2579);
7
gap> homalg_variable_2580 := SI_matrix(homalg_variable_5,10,7,"0");;
gap> homalg_variable_2579 = homalg_variable_2580;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_2575);; homalg_variable_2581 := homalg_variable_l[1];; homalg_variable_2582 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_2581);
7
gap> homalg_variable_2583 := SI_matrix(homalg_variable_5,10,7,"0");;
gap> homalg_variable_2581 = homalg_variable_2583;
false
gap> SI_nrows(homalg_variable_2582);
7
gap> homalg_variable_2584 := homalg_variable_2575 * homalg_variable_2582;;
gap> homalg_variable_2581 = homalg_variable_2584;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2579,homalg_variable_2581);; homalg_variable_2585 := homalg_variable_l[1];; homalg_variable_2586 := homalg_variable_l[2];;
gap> homalg_variable_2587 := SI_matrix(homalg_variable_5,10,7,"0");;
gap> homalg_variable_2585 = homalg_variable_2587;
true
gap> homalg_variable_2588 := homalg_variable_2581 * homalg_variable_2586;;
gap> homalg_variable_2589 := homalg_variable_2579 + homalg_variable_2588;;
gap> homalg_variable_2585 = homalg_variable_2589;
true
gap> homalg_variable_2590 := SIH_DecideZeroColumns(homalg_variable_2579,homalg_variable_2581);;
gap> homalg_variable_2591 := SI_matrix(homalg_variable_5,10,7,"0");;
gap> homalg_variable_2590 = homalg_variable_2591;
true
gap> homalg_variable_2592 := homalg_variable_2586 * (homalg_variable_8);;
gap> homalg_variable_2593 := homalg_variable_2582 * homalg_variable_2592;;
gap> homalg_variable_2594 := homalg_variable_2575 * homalg_variable_2593;;
gap> homalg_variable_2594 = homalg_variable_2579;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2575,homalg_variable_2579);; homalg_variable_2595 := homalg_variable_l[1];; homalg_variable_2596 := homalg_variable_l[2];;
gap> homalg_variable_2597 := SI_matrix(homalg_variable_5,10,7,"0");;
gap> homalg_variable_2595 = homalg_variable_2597;
true
gap> homalg_variable_2598 := homalg_variable_2579 * homalg_variable_2596;;
gap> homalg_variable_2599 := homalg_variable_2575 + homalg_variable_2598;;
gap> homalg_variable_2595 = homalg_variable_2599;
true
gap> homalg_variable_2600 := SIH_DecideZeroColumns(homalg_variable_2575,homalg_variable_2579);;
gap> homalg_variable_2601 := SI_matrix(homalg_variable_5,10,7,"0");;
gap> homalg_variable_2600 = homalg_variable_2601;
true
gap> homalg_variable_2602 := homalg_variable_2596 * (homalg_variable_8);;
gap> homalg_variable_2603 := homalg_variable_2579 * homalg_variable_2602;;
gap> homalg_variable_2603 = homalg_variable_2575;
true
gap> homalg_variable_2605 := SI_matrix(homalg_variable_5,7,6,"0");;
gap> homalg_variable_2606 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2607 := SIH_UnionOfColumns(homalg_variable_1101,homalg_variable_2606);;
gap> homalg_variable_2608 := SIH_UnionOfRows(homalg_variable_2605,homalg_variable_2607);;
gap> homalg_variable_2604 := SIH_BasisOfColumnModule(homalg_variable_2608);;
gap> SI_ncols(homalg_variable_2604);
3
gap> homalg_variable_2609 := SI_matrix(homalg_variable_5,10,3,"0");;
gap> homalg_variable_2604 = homalg_variable_2609;
false
gap> homalg_variable_2610 := SIH_DecideZeroColumns(homalg_variable_2575,homalg_variable_2604);;
gap> homalg_variable_2611 := SI_matrix(homalg_variable_5,10,7,"0");;
gap> homalg_variable_2610 = homalg_variable_2611;
false
gap> SIH_ZeroColumns(homalg_variable_2610);
[ 5, 6, 7 ]
gap> homalg_variable_2613 := SIH_Submatrix(homalg_variable_2610,[1..10],[ 1, 2, 3, 4 ]);;
gap> homalg_variable_2612 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2613,homalg_variable_2604);;
gap> SI_ncols(homalg_variable_2612);
1
gap> homalg_variable_2614 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_2612 = homalg_variable_2614;
true
gap> homalg_variable_2615 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2613,homalg_variable_2604);;
gap> SI_ncols(homalg_variable_2615);
1
gap> homalg_variable_2616 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_2615 = homalg_variable_2616;
true
gap> homalg_variable_2617 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2608);;
gap> SI_ncols(homalg_variable_2617);
3
gap> homalg_variable_2618 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_2617 = homalg_variable_2618;
false
gap> homalg_variable_2619 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2617);;
gap> SI_ncols(homalg_variable_2619);
1
gap> homalg_variable_2620 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_2619 = homalg_variable_2620;
true
gap> homalg_variable_2621 := SIH_BasisOfColumnModule(homalg_variable_2617);;
gap> SI_ncols(homalg_variable_2621);
3
gap> homalg_variable_2622 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_2621 = homalg_variable_2622;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_2617);; homalg_variable_2623 := homalg_variable_l[1];; homalg_variable_2624 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_2623);
3
gap> homalg_variable_2625 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_2623 = homalg_variable_2625;
false
gap> SI_nrows(homalg_variable_2624);
3
gap> homalg_variable_2626 := homalg_variable_2617 * homalg_variable_2624;;
gap> homalg_variable_2623 = homalg_variable_2626;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2621,homalg_variable_2623);; homalg_variable_2627 := homalg_variable_l[1];; homalg_variable_2628 := homalg_variable_l[2];;
gap> homalg_variable_2629 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_2627 = homalg_variable_2629;
true
gap> homalg_variable_2630 := homalg_variable_2623 * homalg_variable_2628;;
gap> homalg_variable_2631 := homalg_variable_2621 + homalg_variable_2630;;
gap> homalg_variable_2627 = homalg_variable_2631;
true
gap> homalg_variable_2632 := SIH_DecideZeroColumns(homalg_variable_2621,homalg_variable_2623);;
gap> homalg_variable_2633 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_2632 = homalg_variable_2633;
true
gap> homalg_variable_2634 := homalg_variable_2628 * (homalg_variable_8);;
gap> homalg_variable_2635 := homalg_variable_2624 * homalg_variable_2634;;
gap> homalg_variable_2636 := homalg_variable_2617 * homalg_variable_2635;;
gap> homalg_variable_2636 = homalg_variable_2621;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2617,homalg_variable_2621);; homalg_variable_2637 := homalg_variable_l[1];; homalg_variable_2638 := homalg_variable_l[2];;
gap> homalg_variable_2639 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_2637 = homalg_variable_2639;
true
gap> homalg_variable_2640 := homalg_variable_2621 * homalg_variable_2638;;
gap> homalg_variable_2641 := homalg_variable_2617 + homalg_variable_2640;;
gap> homalg_variable_2637 = homalg_variable_2641;
true
gap> homalg_variable_2642 := SIH_DecideZeroColumns(homalg_variable_2617,homalg_variable_2621);;
gap> homalg_variable_2643 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_2642 = homalg_variable_2643;
true
gap> homalg_variable_2644 := homalg_variable_2638 * (homalg_variable_8);;
gap> homalg_variable_2645 := homalg_variable_2621 * homalg_variable_2644;;
gap> homalg_variable_2645 = homalg_variable_2617;
true
gap> SIH_ZeroColumns(homalg_variable_2617);
[  ]
gap> homalg_variable_2647 := SI_matrix(homalg_variable_5,2,14,"0");;
gap> homalg_variable_2648 := SI_matrix(SI_freemodule(homalg_variable_5,9));;
gap> homalg_variable_2649 := SIH_Submatrix(homalg_variable_2648,[ 1, 2, 3, 4, 5 ],[1..9]);;
gap> homalg_variable_2650 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_2651 := SIH_UnionOfColumns(homalg_variable_2649,homalg_variable_2650);;
gap> homalg_variable_2652 := SIH_UnionOfRows(homalg_variable_2647,homalg_variable_2651);;
gap> homalg_variable_2646 := SIH_BasisOfColumnModule(homalg_variable_2652);;
gap> SI_ncols(homalg_variable_2646);
5
gap> homalg_variable_2653 := SI_matrix(homalg_variable_5,7,5,"0");;
gap> homalg_variable_2646 = homalg_variable_2653;
false
gap> homalg_variable_2654 := SIH_DecideZeroColumns(homalg_variable_1109,homalg_variable_2646);;
gap> homalg_variable_2655 := SI_matrix(homalg_variable_5,7,7,"0");;
gap> homalg_variable_2654 = homalg_variable_2655;
false
gap> SIH_ZeroColumns(homalg_variable_2654);
[ 3, 4, 5, 6, 7 ]
gap> homalg_variable_2656 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2652);;
gap> SI_ncols(homalg_variable_2656);
9
gap> homalg_variable_2657 := SI_matrix(homalg_variable_5,14,9,"0");;
gap> homalg_variable_2656 = homalg_variable_2657;
false
gap> homalg_variable_2658 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2656);;
gap> SI_ncols(homalg_variable_2658);
1
gap> homalg_variable_2659 := SI_matrix(homalg_variable_5,9,1,"0");;
gap> homalg_variable_2658 = homalg_variable_2659;
true
gap> homalg_variable_2660 := SIH_BasisOfColumnModule(homalg_variable_2656);;
gap> SI_ncols(homalg_variable_2660);
9
gap> homalg_variable_2661 := SI_matrix(homalg_variable_5,14,9,"0");;
gap> homalg_variable_2660 = homalg_variable_2661;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_2656);; homalg_variable_2662 := homalg_variable_l[1];; homalg_variable_2663 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_2662);
9
gap> homalg_variable_2664 := SI_matrix(homalg_variable_5,14,9,"0");;
gap> homalg_variable_2662 = homalg_variable_2664;
false
gap> SI_nrows(homalg_variable_2663);
9
gap> homalg_variable_2665 := homalg_variable_2656 * homalg_variable_2663;;
gap> homalg_variable_2662 = homalg_variable_2665;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2660,homalg_variable_2662);; homalg_variable_2666 := homalg_variable_l[1];; homalg_variable_2667 := homalg_variable_l[2];;
gap> homalg_variable_2668 := SI_matrix(homalg_variable_5,14,9,"0");;
gap> homalg_variable_2666 = homalg_variable_2668;
true
gap> homalg_variable_2669 := homalg_variable_2662 * homalg_variable_2667;;
gap> homalg_variable_2670 := homalg_variable_2660 + homalg_variable_2669;;
gap> homalg_variable_2666 = homalg_variable_2670;
true
gap> homalg_variable_2671 := SIH_DecideZeroColumns(homalg_variable_2660,homalg_variable_2662);;
gap> homalg_variable_2672 := SI_matrix(homalg_variable_5,14,9,"0");;
gap> homalg_variable_2671 = homalg_variable_2672;
true
gap> homalg_variable_2673 := homalg_variable_2667 * (homalg_variable_8);;
gap> homalg_variable_2674 := homalg_variable_2663 * homalg_variable_2673;;
gap> homalg_variable_2675 := homalg_variable_2656 * homalg_variable_2674;;
gap> homalg_variable_2675 = homalg_variable_2660;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2656,homalg_variable_2660);; homalg_variable_2676 := homalg_variable_l[1];; homalg_variable_2677 := homalg_variable_l[2];;
gap> homalg_variable_2678 := SI_matrix(homalg_variable_5,14,9,"0");;
gap> homalg_variable_2676 = homalg_variable_2678;
true
gap> homalg_variable_2679 := homalg_variable_2660 * homalg_variable_2677;;
gap> homalg_variable_2680 := homalg_variable_2656 + homalg_variable_2679;;
gap> homalg_variable_2676 = homalg_variable_2680;
true
gap> homalg_variable_2681 := SIH_DecideZeroColumns(homalg_variable_2656,homalg_variable_2660);;
gap> homalg_variable_2682 := SI_matrix(homalg_variable_5,14,9,"0");;
gap> homalg_variable_2681 = homalg_variable_2682;
true
gap> homalg_variable_2683 := homalg_variable_2677 * (homalg_variable_8);;
gap> homalg_variable_2684 := homalg_variable_2660 * homalg_variable_2683;;
gap> homalg_variable_2684 = homalg_variable_2656;
true
gap> homalg_variable_2686 := SI_matrix(homalg_variable_5,9,10,"0");;
gap> homalg_variable_2687 := SIH_Submatrix(homalg_variable_1109,[ 1, 2, 3, 4, 5 ],[1..7]);;
gap> homalg_variable_2688 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_2689 := SIH_UnionOfColumns(homalg_variable_2687,homalg_variable_2688);;
gap> homalg_variable_2690 := SIH_UnionOfRows(homalg_variable_2686,homalg_variable_2689);;
gap> homalg_variable_2685 := SIH_BasisOfColumnModule(homalg_variable_2690);;
gap> SI_ncols(homalg_variable_2685);
5
gap> homalg_variable_2691 := SI_matrix(homalg_variable_5,14,5,"0");;
gap> homalg_variable_2685 = homalg_variable_2691;
false
gap> homalg_variable_2692 := SIH_DecideZeroColumns(homalg_variable_2656,homalg_variable_2685);;
gap> homalg_variable_2693 := SI_matrix(homalg_variable_5,14,9,"0");;
gap> homalg_variable_2692 = homalg_variable_2693;
false
gap> SIH_ZeroColumns(homalg_variable_2692);
[ 5, 6, 7, 8, 9 ]
gap> homalg_variable_2695 := SIH_Submatrix(homalg_variable_2692,[1..14],[ 1, 2, 3, 4 ]);;
gap> homalg_variable_2694 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2695,homalg_variable_2685);;
gap> SI_ncols(homalg_variable_2694);
1
gap> homalg_variable_2696 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_2694 = homalg_variable_2696;
true
gap> homalg_variable_2697 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2695,homalg_variable_2685);;
gap> SI_ncols(homalg_variable_2697);
1
gap> homalg_variable_2698 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_2697 = homalg_variable_2698;
true
gap> homalg_variable_2699 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2690);;
gap> SI_ncols(homalg_variable_2699);
5
gap> homalg_variable_2700 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_2699 = homalg_variable_2700;
false
gap> homalg_variable_2701 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2699);;
gap> SI_ncols(homalg_variable_2701);
1
gap> homalg_variable_2702 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_2701 = homalg_variable_2702;
true
gap> homalg_variable_2703 := SIH_BasisOfColumnModule(homalg_variable_2699);;
gap> SI_ncols(homalg_variable_2703);
5
gap> homalg_variable_2704 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_2703 = homalg_variable_2704;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_2699);; homalg_variable_2705 := homalg_variable_l[1];; homalg_variable_2706 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_2705);
5
gap> homalg_variable_2707 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_2705 = homalg_variable_2707;
false
gap> SI_nrows(homalg_variable_2706);
5
gap> homalg_variable_2708 := homalg_variable_2699 * homalg_variable_2706;;
gap> homalg_variable_2705 = homalg_variable_2708;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2703,homalg_variable_2705);; homalg_variable_2709 := homalg_variable_l[1];; homalg_variable_2710 := homalg_variable_l[2];;
gap> homalg_variable_2711 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_2709 = homalg_variable_2711;
true
gap> homalg_variable_2712 := homalg_variable_2705 * homalg_variable_2710;;
gap> homalg_variable_2713 := homalg_variable_2703 + homalg_variable_2712;;
gap> homalg_variable_2709 = homalg_variable_2713;
true
gap> homalg_variable_2714 := SIH_DecideZeroColumns(homalg_variable_2703,homalg_variable_2705);;
gap> homalg_variable_2715 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_2714 = homalg_variable_2715;
true
gap> homalg_variable_2716 := homalg_variable_2710 * (homalg_variable_8);;
gap> homalg_variable_2717 := homalg_variable_2706 * homalg_variable_2716;;
gap> homalg_variable_2718 := homalg_variable_2699 * homalg_variable_2717;;
gap> homalg_variable_2718 = homalg_variable_2703;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2699,homalg_variable_2703);; homalg_variable_2719 := homalg_variable_l[1];; homalg_variable_2720 := homalg_variable_l[2];;
gap> homalg_variable_2721 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_2719 = homalg_variable_2721;
true
gap> homalg_variable_2722 := homalg_variable_2703 * homalg_variable_2720;;
gap> homalg_variable_2723 := homalg_variable_2699 + homalg_variable_2722;;
gap> homalg_variable_2719 = homalg_variable_2723;
true
gap> homalg_variable_2724 := SIH_DecideZeroColumns(homalg_variable_2699,homalg_variable_2703);;
gap> homalg_variable_2725 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_2724 = homalg_variable_2725;
true
gap> homalg_variable_2726 := homalg_variable_2720 * (homalg_variable_8);;
gap> homalg_variable_2727 := homalg_variable_2703 * homalg_variable_2726;;
gap> homalg_variable_2727 = homalg_variable_2699;
true
gap> homalg_variable_2729 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_2730 := SIH_UnionOfColumns(homalg_variable_1101,homalg_variable_2174);;
gap> homalg_variable_2731 := SIH_UnionOfRows(homalg_variable_2729,homalg_variable_2730);;
gap> homalg_variable_2728 := SIH_BasisOfColumnModule(homalg_variable_2731);;
gap> SI_ncols(homalg_variable_2728);
3
gap> homalg_variable_2732 := SI_matrix(homalg_variable_5,10,3,"0");;
gap> homalg_variable_2728 = homalg_variable_2732;
false
gap> homalg_variable_2733 := SIH_DecideZeroColumns(homalg_variable_2699,homalg_variable_2728);;
gap> homalg_variable_2734 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_2733 = homalg_variable_2734;
false
gap> SIH_ZeroColumns(homalg_variable_2733);
[ 3, 4, 5 ]
gap> homalg_variable_2736 := SIH_Submatrix(homalg_variable_2733,[1..10],[ 1, 2 ]);;
gap> homalg_variable_2735 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2736,homalg_variable_2728);;
gap> SI_ncols(homalg_variable_2735);
1
gap> homalg_variable_2737 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_2735 = homalg_variable_2737;
true
gap> homalg_variable_2738 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2736,homalg_variable_2728);;
gap> SI_ncols(homalg_variable_2738);
1
gap> homalg_variable_2739 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_2738 = homalg_variable_2739;
true
gap> homalg_variable_2740 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2731);;
gap> SI_ncols(homalg_variable_2740);
1
gap> homalg_variable_2741 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_2740 = homalg_variable_2741;
false
gap> homalg_variable_2742 := SIH_BasisOfColumnModule(homalg_variable_2740);;
gap> SI_ncols(homalg_variable_2742);
1
gap> homalg_variable_2743 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_2742 = homalg_variable_2743;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_2740);; homalg_variable_2744 := homalg_variable_l[1];; homalg_variable_2745 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_2744);
1
gap> homalg_variable_2746 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_2744 = homalg_variable_2746;
false
gap> SI_nrows(homalg_variable_2745);
1
gap> homalg_variable_2747 := homalg_variable_2740 * homalg_variable_2745;;
gap> homalg_variable_2744 = homalg_variable_2747;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2742,homalg_variable_2744);; homalg_variable_2748 := homalg_variable_l[1];; homalg_variable_2749 := homalg_variable_l[2];;
gap> homalg_variable_2750 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_2748 = homalg_variable_2750;
true
gap> homalg_variable_2751 := homalg_variable_2744 * homalg_variable_2749;;
gap> homalg_variable_2752 := homalg_variable_2742 + homalg_variable_2751;;
gap> homalg_variable_2748 = homalg_variable_2752;
true
gap> homalg_variable_2753 := SIH_DecideZeroColumns(homalg_variable_2742,homalg_variable_2744);;
gap> homalg_variable_2754 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_2753 = homalg_variable_2754;
true
gap> homalg_variable_2755 := homalg_variable_2749 * (homalg_variable_8);;
gap> homalg_variable_2756 := homalg_variable_2745 * homalg_variable_2755;;
gap> homalg_variable_2757 := homalg_variable_2740 * homalg_variable_2756;;
gap> homalg_variable_2757 = homalg_variable_2742;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2740,homalg_variable_2742);; homalg_variable_2758 := homalg_variable_l[1];; homalg_variable_2759 := homalg_variable_l[2];;
gap> homalg_variable_2760 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_2758 = homalg_variable_2760;
true
gap> homalg_variable_2761 := homalg_variable_2742 * homalg_variable_2759;;
gap> homalg_variable_2762 := homalg_variable_2740 + homalg_variable_2761;;
gap> homalg_variable_2758 = homalg_variable_2762;
true
gap> homalg_variable_2763 := SIH_DecideZeroColumns(homalg_variable_2740,homalg_variable_2742);;
gap> homalg_variable_2764 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_2763 = homalg_variable_2764;
true
gap> homalg_variable_2765 := homalg_variable_2759 * (homalg_variable_8);;
gap> homalg_variable_2766 := homalg_variable_2742 * homalg_variable_2765;;
gap> homalg_variable_2766 = homalg_variable_2740;
true
gap> homalg_variable_2767 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2119 = homalg_variable_2767;
false
gap> homalg_variable_2769 := SIH_Submatrix(homalg_variable_2119,[1..1],[ 5 ]);;
gap> homalg_variable_2770 := SIH_UnionOfColumns(homalg_variable_2769,homalg_variable_2416);;
gap> homalg_variable_2771 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2772 := SIH_UnionOfColumns(homalg_variable_2770,homalg_variable_2771);;
gap> homalg_variable_2768 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2772);;
gap> SI_ncols(homalg_variable_2768);
5
gap> homalg_variable_2773 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_2768 = homalg_variable_2773;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_2768,[ 0 ]);
[ [ 1, 1 ], [ 2, 2 ], [ 3, 3 ], [ 4, 4 ], [ 5, 5 ] ]
gap> homalg_variable_2774 := SIH_DecideZeroColumns(homalg_variable_2451,homalg_variable_2441);;
gap> homalg_variable_2775 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_2774 = homalg_variable_2775;
false
gap> homalg_variable_2776 := SIH_UnionOfColumns(homalg_variable_2774,homalg_variable_2441);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_2776);; homalg_variable_2777 := homalg_variable_l[1];; homalg_variable_2778 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_2777);
2
gap> homalg_variable_2779 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_2777 = homalg_variable_2779;
false
gap> SI_nrows(homalg_variable_2778);
2
gap> homalg_variable_2780 := SIH_Submatrix(homalg_variable_2778,[ 1 ],[1..2]);;
gap> homalg_variable_2781 := homalg_variable_2774 * homalg_variable_2780;;
gap> homalg_variable_2782 := SIH_Submatrix(homalg_variable_2778,[ 2 ],[1..2]);;
gap> homalg_variable_2783 := homalg_variable_2441 * homalg_variable_2782;;
gap> homalg_variable_2784 := homalg_variable_2781 + homalg_variable_2783;;
gap> homalg_variable_2777 = homalg_variable_2784;
true
gap> homalg_variable_2786 := homalg_variable_1208 * (homalg_variable_8);;
gap> homalg_variable_2787 := homalg_variable_2786 * homalg_variable_2571;;
gap> homalg_variable_2785 := SIH_DecideZeroColumns(homalg_variable_2787,homalg_variable_2441);;
gap> homalg_variable_2788 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_2785 = homalg_variable_2788;
false
gap> homalg_variable_2789 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_2787 = homalg_variable_2789;
false
gap> homalg_variable_2777 = homalg_variable_618;
true
gap> homalg_variable_2791 := SIH_Submatrix(homalg_variable_2778,[ 1 ],[1..2]);;
gap> homalg_variable_2792 := homalg_variable_2791 * homalg_variable_2785;;
gap> homalg_variable_2793 := homalg_variable_2451 * homalg_variable_2792;;
gap> homalg_variable_2794 := homalg_variable_2793 - homalg_variable_2787;;
gap> homalg_variable_2790 := SIH_DecideZeroColumns(homalg_variable_2794,homalg_variable_2441);;
gap> homalg_variable_2795 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_2790 = homalg_variable_2795;
true
gap> homalg_variable_2797 := SIH_Submatrix(homalg_variable_2786,[1..2],[ 8, 9, 10 ]);;
gap> homalg_variable_2798 := homalg_variable_2797 * homalg_variable_2563;;
gap> homalg_variable_2799 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_2800 := SIH_UnionOfColumns(homalg_variable_2798,homalg_variable_2799);;
gap> homalg_variable_2801 := SIH_UnionOfColumns(homalg_variable_2800,homalg_variable_2446);;
gap> homalg_variable_2796 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2451,homalg_variable_2801);;
gap> SI_ncols(homalg_variable_2796);
1
gap> homalg_variable_2802 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2796 = homalg_variable_2802;
true
gap> homalg_variable_2803 := SI_matrix(homalg_variable_5,4,10,"0");;
gap> homalg_variable_2021 = homalg_variable_2803;
false
gap> homalg_variable_2804 := SIH_DecideZeroColumns(homalg_variable_2492,homalg_variable_2484);;
gap> homalg_variable_2805 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_2804 = homalg_variable_2805;
false
gap> homalg_variable_2806 := SIH_UnionOfColumns(homalg_variable_2804,homalg_variable_2484);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_2806);; homalg_variable_2807 := homalg_variable_l[1];; homalg_variable_2808 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_2807);
4
gap> homalg_variable_2809 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_2807 = homalg_variable_2809;
false
gap> SI_nrows(homalg_variable_2808);
4
gap> homalg_variable_2810 := SIH_Submatrix(homalg_variable_2808,[ 1, 2, 3 ],[1..4]);;
gap> homalg_variable_2811 := homalg_variable_2804 * homalg_variable_2810;;
gap> homalg_variable_2812 := SIH_Submatrix(homalg_variable_2808,[ 4 ],[1..4]);;
gap> homalg_variable_2813 := homalg_variable_2484 * homalg_variable_2812;;
gap> homalg_variable_2814 := homalg_variable_2811 + homalg_variable_2813;;
gap> homalg_variable_2807 = homalg_variable_2814;
true
gap> homalg_variable_2816 := homalg_variable_2021 * homalg_variable_2613;;
gap> homalg_variable_2817 := homalg_variable_2022 * homalg_variable_2613;;
gap> homalg_variable_2818 := SIH_UnionOfRows(homalg_variable_2816,homalg_variable_2817);;
gap> homalg_variable_2815 := SIH_DecideZeroColumns(homalg_variable_2818,homalg_variable_2484);;
gap> homalg_variable_2819 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_2815 = homalg_variable_2819;
false
gap> homalg_variable_2820 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_2816 = homalg_variable_2820;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2815,homalg_variable_2807);; homalg_variable_2821 := homalg_variable_l[1];; homalg_variable_2822 := homalg_variable_l[2];;
gap> homalg_variable_2823 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_2821 = homalg_variable_2823;
true
gap> homalg_variable_2824 := homalg_variable_2807 * homalg_variable_2822;;
gap> homalg_variable_2825 := homalg_variable_2815 + homalg_variable_2824;;
gap> homalg_variable_2821 = homalg_variable_2825;
true
gap> homalg_variable_2826 := SIH_DecideZeroColumns(homalg_variable_2815,homalg_variable_2807);;
gap> homalg_variable_2827 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_2826 = homalg_variable_2827;
true
gap> homalg_variable_2829 := SIH_Submatrix(homalg_variable_2808,[ 1, 2, 3 ],[1..4]);;
gap> homalg_variable_2830 := homalg_variable_2822 * (homalg_variable_8);;
gap> homalg_variable_2831 := homalg_variable_2829 * homalg_variable_2830;;
gap> homalg_variable_2832 := homalg_variable_2492 * homalg_variable_2831;;
gap> homalg_variable_2833 := homalg_variable_2832 - homalg_variable_2818;;
gap> homalg_variable_2828 := SIH_DecideZeroColumns(homalg_variable_2833,homalg_variable_2484);;
gap> homalg_variable_2834 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_2828 = homalg_variable_2834;
true
gap> homalg_variable_2836 := SIH_Submatrix(homalg_variable_2021,[1..4],[ 8, 9, 10 ]);;
gap> homalg_variable_2837 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2838 := SIH_UnionOfColumns(homalg_variable_2836,homalg_variable_2837);;
gap> homalg_variable_2839 := SIH_Submatrix(homalg_variable_2022,[1..1],[ 8, 9, 10 ]);;
gap> homalg_variable_2840 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2841 := SIH_UnionOfColumns(homalg_variable_2839,homalg_variable_2840);;
gap> homalg_variable_2842 := SIH_UnionOfRows(homalg_variable_2838,homalg_variable_2841);;
gap> homalg_variable_2843 := SIH_UnionOfColumns(homalg_variable_2842,homalg_variable_2487);;
gap> homalg_variable_2835 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2492,homalg_variable_2843);;
gap> SI_ncols(homalg_variable_2835);
1
gap> homalg_variable_2844 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_2835 = homalg_variable_2844;
true
gap> homalg_variable_2845 := SI_matrix(homalg_variable_5,1,6,"0");;
gap> homalg_variable_2344 = homalg_variable_2845;
false
gap> homalg_variable_2846 := homalg_variable_2346 * (homalg_variable_8);;
gap> homalg_variable_2847 := homalg_variable_2846 * homalg_variable_2617;;
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2847,homalg_variable_2502);; homalg_variable_2848 := homalg_variable_l[1];; homalg_variable_2849 := homalg_variable_l[2];;
gap> homalg_variable_2850 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2848 = homalg_variable_2850;
true
gap> homalg_variable_2851 := homalg_variable_2502 * homalg_variable_2849;;
gap> homalg_variable_2852 := homalg_variable_2847 + homalg_variable_2851;;
gap> homalg_variable_2848 = homalg_variable_2852;
true
gap> homalg_variable_2853 := SIH_DecideZeroColumns(homalg_variable_2847,homalg_variable_2502);;
gap> homalg_variable_2854 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2853 = homalg_variable_2854;
true
gap> SI_nrows(homalg_variable_2503);
3
gap> SI_ncols(homalg_variable_2503);
3
gap> homalg_variable_2855 := homalg_variable_2849 * (homalg_variable_8);;
gap> homalg_variable_2856 := homalg_variable_2503 * homalg_variable_2855;;
gap> homalg_variable_2857 := homalg_variable_2496 * homalg_variable_2856;;
gap> homalg_variable_2858 := homalg_variable_2857 - homalg_variable_2847;;
gap> homalg_variable_2859 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2858 = homalg_variable_2859;
true
gap> homalg_variable_2860 := SI_matrix(homalg_variable_5,7,14,"0");;
gap> homalg_variable_1135 = homalg_variable_2860;
false
gap> homalg_variable_2861 := SIH_DecideZeroColumns(homalg_variable_2571,homalg_variable_2561);;
gap> homalg_variable_2862 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_2861 = homalg_variable_2862;
false
gap> homalg_variable_2863 := SIH_UnionOfColumns(homalg_variable_2861,homalg_variable_2561);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_2863);; homalg_variable_2864 := homalg_variable_l[1];; homalg_variable_2865 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_2864);
8
gap> homalg_variable_2866 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_2864 = homalg_variable_2866;
false
gap> SI_nrows(homalg_variable_2865);
8
gap> homalg_variable_2867 := SIH_Submatrix(homalg_variable_2865,[ 1, 2, 3, 4, 5 ],[1..8]);;
gap> homalg_variable_2868 := homalg_variable_2861 * homalg_variable_2867;;
gap> homalg_variable_2869 := SIH_Submatrix(homalg_variable_2865,[ 6, 7, 8 ],[1..8]);;
gap> homalg_variable_2870 := homalg_variable_2561 * homalg_variable_2869;;
gap> homalg_variable_2871 := homalg_variable_2868 + homalg_variable_2870;;
gap> homalg_variable_2864 = homalg_variable_2871;
true
gap> homalg_variable_2873 := homalg_variable_1137 * (homalg_variable_8);;
gap> homalg_variable_2874 := homalg_variable_2873 * homalg_variable_2695;;
gap> homalg_variable_2872 := SIH_DecideZeroColumns(homalg_variable_2874,homalg_variable_2561);;
gap> homalg_variable_2875 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_2872 = homalg_variable_2875;
false
gap> homalg_variable_2876 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_2874 = homalg_variable_2876;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2872,homalg_variable_2864);; homalg_variable_2877 := homalg_variable_l[1];; homalg_variable_2878 := homalg_variable_l[2];;
gap> homalg_variable_2879 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_2877 = homalg_variable_2879;
true
gap> homalg_variable_2880 := homalg_variable_2864 * homalg_variable_2878;;
gap> homalg_variable_2881 := homalg_variable_2872 + homalg_variable_2880;;
gap> homalg_variable_2877 = homalg_variable_2881;
true
gap> homalg_variable_2882 := SIH_DecideZeroColumns(homalg_variable_2872,homalg_variable_2864);;
gap> homalg_variable_2883 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_2882 = homalg_variable_2883;
true
gap> homalg_variable_2885 := SIH_Submatrix(homalg_variable_2865,[ 1, 2, 3, 4, 5 ],[1..8]);;
gap> homalg_variable_2886 := homalg_variable_2878 * (homalg_variable_8);;
gap> homalg_variable_2887 := homalg_variable_2885 * homalg_variable_2886;;
gap> homalg_variable_2888 := homalg_variable_2571 * homalg_variable_2887;;
gap> homalg_variable_2889 := homalg_variable_2888 - homalg_variable_2874;;
gap> homalg_variable_2884 := SIH_DecideZeroColumns(homalg_variable_2889,homalg_variable_2561);;
gap> homalg_variable_2890 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_2884 = homalg_variable_2890;
true
gap> homalg_variable_2892 := SIH_Submatrix(homalg_variable_2873,[1..10],[ 10, 11, 12, 13, 14 ]);;
gap> homalg_variable_2893 := homalg_variable_2892 * homalg_variable_2687;;
gap> homalg_variable_2894 := SI_matrix(homalg_variable_5,10,3,"0");;
gap> homalg_variable_2895 := SIH_UnionOfColumns(homalg_variable_2893,homalg_variable_2894);;
gap> homalg_variable_2896 := SIH_UnionOfColumns(homalg_variable_2895,homalg_variable_2566);;
gap> homalg_variable_2891 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2571,homalg_variable_2896);;
gap> SI_ncols(homalg_variable_2891);
1
gap> homalg_variable_2897 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_2891 = homalg_variable_2897;
true
gap> homalg_variable_2898 := SI_matrix(homalg_variable_5,7,10,"0");;
gap> homalg_variable_1904 = homalg_variable_2898;
false
gap> homalg_variable_2899 := SIH_DecideZeroColumns(homalg_variable_2613,homalg_variable_2604);;
gap> homalg_variable_2900 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_2899 = homalg_variable_2900;
false
gap> homalg_variable_2901 := SIH_UnionOfColumns(homalg_variable_2899,homalg_variable_2604);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_2901);; homalg_variable_2902 := homalg_variable_l[1];; homalg_variable_2903 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_2902);
7
gap> homalg_variable_2904 := SI_matrix(homalg_variable_5,10,7,"0");;
gap> homalg_variable_2902 = homalg_variable_2904;
false
gap> SI_nrows(homalg_variable_2903);
7
gap> homalg_variable_2905 := SIH_Submatrix(homalg_variable_2903,[ 1, 2, 3, 4 ],[1..7]);;
gap> homalg_variable_2906 := homalg_variable_2899 * homalg_variable_2905;;
gap> homalg_variable_2907 := SIH_Submatrix(homalg_variable_2903,[ 5, 6, 7 ],[1..7]);;
gap> homalg_variable_2908 := homalg_variable_2604 * homalg_variable_2907;;
gap> homalg_variable_2909 := homalg_variable_2906 + homalg_variable_2908;;
gap> homalg_variable_2902 = homalg_variable_2909;
true
gap> homalg_variable_2911 := homalg_variable_1904 * homalg_variable_2736;;
gap> homalg_variable_2912 := homalg_variable_1905 * homalg_variable_2736;;
gap> homalg_variable_2913 := SIH_UnionOfRows(homalg_variable_2911,homalg_variable_2912);;
gap> homalg_variable_2910 := SIH_DecideZeroColumns(homalg_variable_2913,homalg_variable_2604);;
gap> homalg_variable_2914 := SI_matrix(homalg_variable_5,10,2,"0");;
gap> homalg_variable_2910 = homalg_variable_2914;
false
gap> homalg_variable_2915 := SI_matrix(homalg_variable_5,7,2,"0");;
gap> homalg_variable_2911 = homalg_variable_2915;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2910,homalg_variable_2902);; homalg_variable_2916 := homalg_variable_l[1];; homalg_variable_2917 := homalg_variable_l[2];;
gap> homalg_variable_2918 := SI_matrix(homalg_variable_5,10,2,"0");;
gap> homalg_variable_2916 = homalg_variable_2918;
true
gap> homalg_variable_2919 := homalg_variable_2902 * homalg_variable_2917;;
gap> homalg_variable_2920 := homalg_variable_2910 + homalg_variable_2919;;
gap> homalg_variable_2916 = homalg_variable_2920;
true
gap> homalg_variable_2921 := SIH_DecideZeroColumns(homalg_variable_2910,homalg_variable_2902);;
gap> homalg_variable_2922 := SI_matrix(homalg_variable_5,10,2,"0");;
gap> homalg_variable_2921 = homalg_variable_2922;
true
gap> homalg_variable_2924 := SIH_Submatrix(homalg_variable_2903,[ 1, 2, 3, 4 ],[1..7]);;
gap> homalg_variable_2925 := homalg_variable_2917 * (homalg_variable_8);;
gap> homalg_variable_2926 := homalg_variable_2924 * homalg_variable_2925;;
gap> homalg_variable_2927 := homalg_variable_2613 * homalg_variable_2926;;
gap> homalg_variable_2928 := homalg_variable_2927 - homalg_variable_2913;;
gap> homalg_variable_2923 := SIH_DecideZeroColumns(homalg_variable_2928,homalg_variable_2604);;
gap> homalg_variable_2929 := SI_matrix(homalg_variable_5,10,2,"0");;
gap> homalg_variable_2923 = homalg_variable_2929;
true
gap> homalg_variable_2931 := SIH_Submatrix(homalg_variable_1904,[1..7],[ 8, 9, 10 ]);;
gap> homalg_variable_2932 := SI_matrix(homalg_variable_5,7,1,"0");;
gap> homalg_variable_2933 := SIH_UnionOfColumns(homalg_variable_2931,homalg_variable_2932);;
gap> homalg_variable_2934 := SIH_Submatrix(homalg_variable_1905,[1..3],[ 8, 9, 10 ]);;
gap> homalg_variable_2935 := SIH_UnionOfColumns(homalg_variable_2934,homalg_variable_2174);;
gap> homalg_variable_2936 := SIH_UnionOfRows(homalg_variable_2933,homalg_variable_2935);;
gap> homalg_variable_2937 := SIH_UnionOfColumns(homalg_variable_2936,homalg_variable_2608);;
gap> homalg_variable_2930 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2613,homalg_variable_2937);;
gap> SI_ncols(homalg_variable_2930);
1
gap> homalg_variable_2938 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_2930 = homalg_variable_2938;
true
gap> homalg_variable_2939 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_2250 = homalg_variable_2939;
false
gap> homalg_variable_2940 := homalg_variable_2252 * (homalg_variable_8);;
gap> homalg_variable_2941 := homalg_variable_2940 * homalg_variable_2740;;
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2941,homalg_variable_2623);; homalg_variable_2942 := homalg_variable_l[1];; homalg_variable_2943 := homalg_variable_l[2];;
gap> homalg_variable_2944 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_2942 = homalg_variable_2944;
true
gap> homalg_variable_2945 := homalg_variable_2623 * homalg_variable_2943;;
gap> homalg_variable_2946 := homalg_variable_2941 + homalg_variable_2945;;
gap> homalg_variable_2942 = homalg_variable_2946;
true
gap> homalg_variable_2947 := SIH_DecideZeroColumns(homalg_variable_2941,homalg_variable_2623);;
gap> homalg_variable_2948 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_2947 = homalg_variable_2948;
true
gap> SI_nrows(homalg_variable_2624);
3
gap> SI_ncols(homalg_variable_2624);
3
gap> homalg_variable_2949 := homalg_variable_2943 * (homalg_variable_8);;
gap> homalg_variable_2950 := homalg_variable_2624 * homalg_variable_2949;;
gap> homalg_variable_2951 := homalg_variable_2617 * homalg_variable_2950;;
gap> homalg_variable_2952 := homalg_variable_2951 - homalg_variable_2941;;
gap> homalg_variable_2953 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_2952 = homalg_variable_2953;
true
gap> homalg_variable_2955 := homalg_variable_2119 * homalg_variable_2492;;
gap> homalg_variable_2954 := SIH_BasisOfColumnModule(homalg_variable_2955);;
gap> SI_ncols(homalg_variable_2954);
3
gap> homalg_variable_2956 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2954 = homalg_variable_2956;
false
gap> homalg_variable_2954 = homalg_variable_2955;
false
gap> homalg_variable_2957 := SIH_DecideZeroColumns(homalg_variable_860,homalg_variable_2954);;
gap> homalg_variable_2958 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2957 = homalg_variable_2958;
false
gap> homalg_variable_2960 := homalg_variable_2343 * (homalg_variable_8);;
gap> homalg_variable_2961 := homalg_variable_2960 * homalg_variable_2496;;
gap> homalg_variable_2959 := SIH_BasisOfColumnModule(homalg_variable_2961);;
gap> SI_ncols(homalg_variable_2959);
3
gap> homalg_variable_2962 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2959 = homalg_variable_2962;
false
gap> homalg_variable_2959 = homalg_variable_2961;
false
gap> homalg_variable_2963 := SIH_DecideZeroColumns(homalg_variable_860,homalg_variable_2959);;
gap> homalg_variable_2964 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2963 = homalg_variable_2964;
false
gap> homalg_variable_2965 := SIH_BasisOfColumnModule(homalg_variable_2792);;
gap> SI_ncols(homalg_variable_2965);
2
gap> homalg_variable_2966 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_2965 = homalg_variable_2966;
false
gap> homalg_variable_2967 := SIH_DecideZeroColumns(homalg_variable_860,homalg_variable_2965);;
gap> homalg_variable_2968 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2967 = homalg_variable_2968;
false
gap> homalg_variable_2969 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2955);;
gap> SI_ncols(homalg_variable_2969);
3
gap> homalg_variable_2970 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2969 = homalg_variable_2970;
false
gap> homalg_variable_2971 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2969);;
gap> SI_ncols(homalg_variable_2971);
1
gap> homalg_variable_2972 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_2971 = homalg_variable_2972;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_2971,[ 0 ]);
[  ]
gap> homalg_variable_2973 := SIH_BasisOfColumnModule(homalg_variable_2969);;
gap> SI_ncols(homalg_variable_2973);
3
gap> homalg_variable_2974 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2973 = homalg_variable_2974;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_2969);; homalg_variable_2975 := homalg_variable_l[1];; homalg_variable_2976 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_2975);
3
gap> homalg_variable_2977 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2975 = homalg_variable_2977;
false
gap> SI_nrows(homalg_variable_2976);
3
gap> homalg_variable_2978 := homalg_variable_2969 * homalg_variable_2976;;
gap> homalg_variable_2975 = homalg_variable_2978;
true
gap> homalg_variable_2975 = homalg_variable_1101;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2973,homalg_variable_2975);; homalg_variable_2979 := homalg_variable_l[1];; homalg_variable_2980 := homalg_variable_l[2];;
gap> homalg_variable_2981 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2979 = homalg_variable_2981;
true
gap> homalg_variable_2982 := homalg_variable_2975 * homalg_variable_2980;;
gap> homalg_variable_2983 := homalg_variable_2973 + homalg_variable_2982;;
gap> homalg_variable_2979 = homalg_variable_2983;
true
gap> homalg_variable_2984 := SIH_DecideZeroColumns(homalg_variable_2973,homalg_variable_2975);;
gap> homalg_variable_2985 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2984 = homalg_variable_2985;
true
gap> homalg_variable_2986 := homalg_variable_2980 * (homalg_variable_8);;
gap> homalg_variable_2987 := homalg_variable_2976 * homalg_variable_2986;;
gap> homalg_variable_2988 := homalg_variable_2969 * homalg_variable_2987;;
gap> homalg_variable_2988 = homalg_variable_2973;
true
gap> homalg_variable_2973 = homalg_variable_1101;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2969,homalg_variable_2973);; homalg_variable_2989 := homalg_variable_l[1];; homalg_variable_2990 := homalg_variable_l[2];;
gap> homalg_variable_2991 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2989 = homalg_variable_2991;
true
gap> homalg_variable_2992 := homalg_variable_2973 * homalg_variable_2990;;
gap> homalg_variable_2993 := homalg_variable_2969 + homalg_variable_2992;;
gap> homalg_variable_2989 = homalg_variable_2993;
true
gap> homalg_variable_2994 := SIH_DecideZeroColumns(homalg_variable_2969,homalg_variable_2973);;
gap> homalg_variable_2995 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2994 = homalg_variable_2995;
true
gap> homalg_variable_2996 := homalg_variable_2990 * (homalg_variable_8);;
gap> homalg_variable_2997 := homalg_variable_2973 * homalg_variable_2996;;
gap> homalg_variable_2997 = homalg_variable_2969;
true
gap> homalg_variable_2998 := SIH_BasisOfColumnModule(homalg_variable_2831);;
gap> SI_ncols(homalg_variable_2998);
4
gap> homalg_variable_2999 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_2998 = homalg_variable_2999;
false
gap> homalg_variable_2998 = homalg_variable_2831;
false
gap> homalg_variable_3000 := SIH_DecideZeroColumns(homalg_variable_2969,homalg_variable_2998);;
gap> for _del in [ "homalg_variable_2497", "homalg_variable_2498", "homalg_variable_2499", "homalg_variable_2501", "homalg_variable_2504", "homalg_variable_2505", "homalg_variable_2506", "homalg_variable_2507", "homalg_variable_2508", "homalg_variable_2509", "homalg_variable_2510", "homalg_variable_2511", "homalg_variable_2512", "homalg_variable_2513", "homalg_variable_2514", "homalg_variable_2515", "homalg_variable_2516", "homalg_variable_2517", "homalg_variable_2518", "homalg_variable_2519", "homalg_variable_2520", "homalg_variable_2521", "homalg_variable_2522", "homalg_variable_2523", "homalg_variable_2524", "homalg_variable_2529", "homalg_variable_2530", "homalg_variable_2531", "homalg_variable_2533", "homalg_variable_2534", "homalg_variable_2535", "homalg_variable_2537", "homalg_variable_2540", "homalg_variable_2541", "homalg_variable_2542", "homalg_variable_2543", "homalg_variable_2544", "homalg_variable_2545", "homalg_variable_2546", "homalg_variable_2547", "homalg_variable_2548", "homalg_variable_2549", "homalg_variable_2550", "homalg_variable_2551", "homalg_variable_2552", "homalg_variable_2553", "homalg_variable_2554", "homalg_variable_2555", "homalg_variable_2556", "homalg_variable_2557", "homalg_variable_2558", "homalg_variable_2559", "homalg_variable_2560", "homalg_variable_2567", "homalg_variable_2569", "homalg_variable_2570", "homalg_variable_2572", "homalg_variable_2573", "homalg_variable_2574", "homalg_variable_2576", "homalg_variable_2577", "homalg_variable_2578", "homalg_variable_2580", "homalg_variable_2583", "homalg_variable_2584", "homalg_variable_2587", "homalg_variable_2588", "homalg_variable_2589", "homalg_variable_2590", "homalg_variable_2591", "homalg_variable_2594", "homalg_variable_2595", "homalg_variable_2596", "homalg_variable_2597", "homalg_variable_2598", "homalg_variable_2599", "homalg_variable_2600", "homalg_variable_2601", "homalg_variable_2602", "homalg_variable_2603", "homalg_variable_2609", "homalg_variable_2611", "homalg_variable_2612", "homalg_variable_2614", "homalg_variable_2615", "homalg_variable_2616", "homalg_variable_2618", "homalg_variable_2619", "homalg_variable_2620", "homalg_variable_2622", "homalg_variable_2625", "homalg_variable_2626", "homalg_variable_2627", "homalg_variable_2628", "homalg_variable_2629", "homalg_variable_2630", "homalg_variable_2631", "homalg_variable_2632", "homalg_variable_2633", "homalg_variable_2634", "homalg_variable_2635", "homalg_variable_2636", "homalg_variable_2637", "homalg_variable_2638", "homalg_variable_2639", "homalg_variable_2640", "homalg_variable_2641", "homalg_variable_2642", "homalg_variable_2643", "homalg_variable_2644", "homalg_variable_2645", "homalg_variable_2653", "homalg_variable_2654", "homalg_variable_2655", "homalg_variable_2657", "homalg_variable_2658", "homalg_variable_2659", "homalg_variable_2661", "homalg_variable_2664", "homalg_variable_2665", "homalg_variable_2666", "homalg_variable_2667", "homalg_variable_2668", "homalg_variable_2669", "homalg_variable_2670", "homalg_variable_2671", "homalg_variable_2672", "homalg_variable_2673", "homalg_variable_2674", "homalg_variable_2675", "homalg_variable_2678", "homalg_variable_2679", "homalg_variable_2680", "homalg_variable_2681", "homalg_variable_2682", "homalg_variable_2691", "homalg_variable_2693", "homalg_variable_2694", "homalg_variable_2696", "homalg_variable_2697", "homalg_variable_2698", "homalg_variable_2700", "homalg_variable_2701", "homalg_variable_2702", "homalg_variable_2707", "homalg_variable_2708", "homalg_variable_2709", "homalg_variable_2710", "homalg_variable_2711", "homalg_variable_2712", "homalg_variable_2713", "homalg_variable_2714", "homalg_variable_2715", "homalg_variable_2716", "homalg_variable_2717", "homalg_variable_2718", "homalg_variable_2719", "homalg_variable_2720", "homalg_variable_2721", "homalg_variable_2722", "homalg_variable_2723", "homalg_variable_2724", "homalg_variable_2725", "homalg_variable_2726", "homalg_variable_2727", "homalg_variable_2732", "homalg_variable_2734", "homalg_variable_2735", "homalg_variable_2737", "homalg_variable_2738", "homalg_variable_2739", "homalg_variable_2741", "homalg_variable_2743", "homalg_variable_2746", "homalg_variable_2747", "homalg_variable_2748", "homalg_variable_2749", "homalg_variable_2750", "homalg_variable_2751", "homalg_variable_2752", "homalg_variable_2753", "homalg_variable_2754", "homalg_variable_2755", "homalg_variable_2756", "homalg_variable_2757", "homalg_variable_2758", "homalg_variable_2759", "homalg_variable_2760", "homalg_variable_2761", "homalg_variable_2762", "homalg_variable_2763", "homalg_variable_2764", "homalg_variable_2765", "homalg_variable_2766", "homalg_variable_2767", "homalg_variable_2773", "homalg_variable_2775", "homalg_variable_2779", "homalg_variable_2780", "homalg_variable_2781", "homalg_variable_2782", "homalg_variable_2783", "homalg_variable_2784", "homalg_variable_2788", "homalg_variable_2789", "homalg_variable_2790", "homalg_variable_2793", "homalg_variable_2794", "homalg_variable_2795", "homalg_variable_2796", "homalg_variable_2802", "homalg_variable_2803", "homalg_variable_2804", "homalg_variable_2805", "homalg_variable_2806", "homalg_variable_2807", "homalg_variable_2809", "homalg_variable_2810", "homalg_variable_2811", "homalg_variable_2812", "homalg_variable_2813", "homalg_variable_2814", "homalg_variable_2815", "homalg_variable_2816", "homalg_variable_2817", "homalg_variable_2818", "homalg_variable_2819", "homalg_variable_2820", "homalg_variable_2821", "homalg_variable_2824", "homalg_variable_2825", "homalg_variable_2826", "homalg_variable_2827", "homalg_variable_2828", "homalg_variable_2832", "homalg_variable_2833", "homalg_variable_2834", "homalg_variable_2835", "homalg_variable_2844", "homalg_variable_2845", "homalg_variable_2848", "homalg_variable_2850", "homalg_variable_2851", "homalg_variable_2852", "homalg_variable_2853", "homalg_variable_2854", "homalg_variable_2857", "homalg_variable_2858", "homalg_variable_2859", "homalg_variable_2860", "homalg_variable_2861", "homalg_variable_2862", "homalg_variable_2863", "homalg_variable_2864", "homalg_variable_2866", "homalg_variable_2867", "homalg_variable_2868", "homalg_variable_2869", "homalg_variable_2870", "homalg_variable_2871", "homalg_variable_2872", "homalg_variable_2874", "homalg_variable_2875", "homalg_variable_2876", "homalg_variable_2877", "homalg_variable_2879", "homalg_variable_2880", "homalg_variable_2881", "homalg_variable_2882", "homalg_variable_2883", "homalg_variable_2884", "homalg_variable_2888", "homalg_variable_2889", "homalg_variable_2890", "homalg_variable_2891", "homalg_variable_2897", "homalg_variable_2898", "homalg_variable_2899", "homalg_variable_2900", "homalg_variable_2901", "homalg_variable_2902", "homalg_variable_2904", "homalg_variable_2905", "homalg_variable_2906", "homalg_variable_2907", "homalg_variable_2908", "homalg_variable_2909", "homalg_variable_2910", "homalg_variable_2914", "homalg_variable_2915", "homalg_variable_2916", "homalg_variable_2918", "homalg_variable_2919", "homalg_variable_2920", "homalg_variable_2921", "homalg_variable_2922", "homalg_variable_2923", "homalg_variable_2927", "homalg_variable_2928", "homalg_variable_2929", "homalg_variable_2930", "homalg_variable_2938", "homalg_variable_2939", "homalg_variable_2942", "homalg_variable_2944", "homalg_variable_2945", "homalg_variable_2946", "homalg_variable_2947", "homalg_variable_2948", "homalg_variable_2951", "homalg_variable_2952", "homalg_variable_2953", "homalg_variable_2957", "homalg_variable_2958", "homalg_variable_2962", "homalg_variable_2963", "homalg_variable_2964", "homalg_variable_2966", "homalg_variable_2967", "homalg_variable_2968", "homalg_variable_2970", "homalg_variable_2972", "homalg_variable_2974", "homalg_variable_2977", "homalg_variable_2978", "homalg_variable_2979", "homalg_variable_2980", "homalg_variable_2981", "homalg_variable_2982", "homalg_variable_2983", "homalg_variable_2984", "homalg_variable_2985", "homalg_variable_2986", "homalg_variable_2987", "homalg_variable_2988", "homalg_variable_2989", "homalg_variable_2990", "homalg_variable_2991", "homalg_variable_2992", "homalg_variable_2993", "homalg_variable_2994", "homalg_variable_2995", "homalg_variable_2996", "homalg_variable_2997" ] do UnbindGlobal( _del ); od;;
gap> homalg_variable_3001 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3000 = homalg_variable_3001;
false
gap> SIH_ZeroColumns(homalg_variable_3000);
[ 1, 2 ]
gap> homalg_variable_3003 := SIH_Submatrix(homalg_variable_3000,[1..3],[ 3 ]);;
gap> homalg_variable_3002 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3003,homalg_variable_2998);;
gap> SI_ncols(homalg_variable_3002);
2
gap> homalg_variable_3004 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_3002 = homalg_variable_3004;
false
gap> homalg_variable_3006 := homalg_variable_3003 * homalg_variable_3002;;
gap> homalg_variable_3005 := SIH_DecideZeroColumns(homalg_variable_3006,homalg_variable_2998);;
gap> homalg_variable_3007 := SI_matrix(homalg_variable_5,3,2,"0");;
gap> homalg_variable_3005 = homalg_variable_3007;
true
gap> homalg_variable_3008 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3003,homalg_variable_2998);;
gap> SI_ncols(homalg_variable_3008);
2
gap> homalg_variable_3009 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_3008 = homalg_variable_3009;
false
gap> homalg_variable_3010 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3008);;
gap> SI_ncols(homalg_variable_3010);
1
gap> homalg_variable_3011 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_3010 = homalg_variable_3011;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_3010,[ 0 ]);
[  ]
gap> homalg_variable_3012 := SIH_BasisOfColumnModule(homalg_variable_3008);;
gap> SI_ncols(homalg_variable_3012);
2
gap> homalg_variable_3013 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_3012 = homalg_variable_3013;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3008);; homalg_variable_3014 := homalg_variable_l[1];; homalg_variable_3015 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3014);
2
gap> homalg_variable_3016 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_3014 = homalg_variable_3016;
false
gap> SI_nrows(homalg_variable_3015);
2
gap> homalg_variable_3017 := homalg_variable_3008 * homalg_variable_3015;;
gap> homalg_variable_3014 = homalg_variable_3017;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3012,homalg_variable_3014);; homalg_variable_3018 := homalg_variable_l[1];; homalg_variable_3019 := homalg_variable_l[2];;
gap> homalg_variable_3020 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_3018 = homalg_variable_3020;
true
gap> homalg_variable_3021 := homalg_variable_3014 * homalg_variable_3019;;
gap> homalg_variable_3022 := homalg_variable_3012 + homalg_variable_3021;;
gap> homalg_variable_3018 = homalg_variable_3022;
true
gap> homalg_variable_3023 := SIH_DecideZeroColumns(homalg_variable_3012,homalg_variable_3014);;
gap> homalg_variable_3024 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_3023 = homalg_variable_3024;
true
gap> homalg_variable_3025 := homalg_variable_3019 * (homalg_variable_8);;
gap> homalg_variable_3026 := homalg_variable_3015 * homalg_variable_3025;;
gap> homalg_variable_3027 := homalg_variable_3008 * homalg_variable_3026;;
gap> homalg_variable_3027 = homalg_variable_3012;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3008,homalg_variable_3012);; homalg_variable_3028 := homalg_variable_l[1];; homalg_variable_3029 := homalg_variable_l[2];;
gap> homalg_variable_3030 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_3028 = homalg_variable_3030;
true
gap> homalg_variable_3031 := homalg_variable_3012 * homalg_variable_3029;;
gap> homalg_variable_3032 := homalg_variable_3008 + homalg_variable_3031;;
gap> homalg_variable_3028 = homalg_variable_3032;
true
gap> homalg_variable_3033 := SIH_DecideZeroColumns(homalg_variable_3008,homalg_variable_3012);;
gap> homalg_variable_3034 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_3033 = homalg_variable_3034;
true
gap> homalg_variable_3035 := homalg_variable_3029 * (homalg_variable_8);;
gap> homalg_variable_3036 := homalg_variable_3012 * homalg_variable_3035;;
gap> homalg_variable_3036 = homalg_variable_3008;
true
gap> homalg_variable_3037 := SIH_BasisOfColumnModule(homalg_variable_3002);;
gap> SI_ncols(homalg_variable_3037);
2
gap> homalg_variable_3038 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_3037 = homalg_variable_3038;
false
gap> homalg_variable_3037 = homalg_variable_3002;
true
gap> homalg_variable_3039 := SIH_DecideZeroColumns(homalg_variable_3008,homalg_variable_3037);;
gap> homalg_variable_3040 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_3039 = homalg_variable_3040;
true
gap> homalg_variable_3041 := SIH_DecideZeroColumns(homalg_variable_860,homalg_variable_3037);;
gap> homalg_variable_3042 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3041 = homalg_variable_3042;
false
gap> homalg_variable_3043 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2961);;
gap> SI_ncols(homalg_variable_3043);
3
gap> homalg_variable_3044 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3043 = homalg_variable_3044;
false
gap> homalg_variable_3045 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3043);;
gap> SI_ncols(homalg_variable_3045);
1
gap> homalg_variable_3046 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3045 = homalg_variable_3046;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_3045,[ 0 ]);
[  ]
gap> homalg_variable_3047 := SIH_BasisOfColumnModule(homalg_variable_3043);;
gap> SI_ncols(homalg_variable_3047);
3
gap> homalg_variable_3048 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3047 = homalg_variable_3048;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3043);; homalg_variable_3049 := homalg_variable_l[1];; homalg_variable_3050 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3049);
3
gap> homalg_variable_3051 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3049 = homalg_variable_3051;
false
gap> SI_nrows(homalg_variable_3050);
3
gap> homalg_variable_3052 := homalg_variable_3043 * homalg_variable_3050;;
gap> homalg_variable_3049 = homalg_variable_3052;
true
gap> homalg_variable_3049 = homalg_variable_1101;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3047,homalg_variable_3049);; homalg_variable_3053 := homalg_variable_l[1];; homalg_variable_3054 := homalg_variable_l[2];;
gap> homalg_variable_3055 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3053 = homalg_variable_3055;
true
gap> homalg_variable_3056 := homalg_variable_3049 * homalg_variable_3054;;
gap> homalg_variable_3057 := homalg_variable_3047 + homalg_variable_3056;;
gap> homalg_variable_3053 = homalg_variable_3057;
true
gap> homalg_variable_3058 := SIH_DecideZeroColumns(homalg_variable_3047,homalg_variable_3049);;
gap> homalg_variable_3059 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3058 = homalg_variable_3059;
true
gap> homalg_variable_3060 := homalg_variable_3054 * (homalg_variable_8);;
gap> homalg_variable_3061 := homalg_variable_3050 * homalg_variable_3060;;
gap> homalg_variable_3062 := homalg_variable_3043 * homalg_variable_3061;;
gap> homalg_variable_3062 = homalg_variable_3047;
true
gap> homalg_variable_3047 = homalg_variable_1101;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3043,homalg_variable_3047);; homalg_variable_3063 := homalg_variable_l[1];; homalg_variable_3064 := homalg_variable_l[2];;
gap> homalg_variable_3065 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3063 = homalg_variable_3065;
true
gap> homalg_variable_3066 := homalg_variable_3047 * homalg_variable_3064;;
gap> homalg_variable_3067 := homalg_variable_3043 + homalg_variable_3066;;
gap> homalg_variable_3063 = homalg_variable_3067;
true
gap> homalg_variable_3068 := SIH_DecideZeroColumns(homalg_variable_3043,homalg_variable_3047);;
gap> homalg_variable_3069 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3068 = homalg_variable_3069;
true
gap> homalg_variable_3070 := homalg_variable_3064 * (homalg_variable_8);;
gap> homalg_variable_3071 := homalg_variable_3047 * homalg_variable_3070;;
gap> homalg_variable_3071 = homalg_variable_3043;
true
gap> homalg_variable_3072 := SIH_BasisOfColumnModule(homalg_variable_2856);;
gap> SI_ncols(homalg_variable_3072);
3
gap> homalg_variable_3073 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3072 = homalg_variable_3073;
false
gap> homalg_variable_3072 = homalg_variable_2856;
false
gap> homalg_variable_3074 := SIH_DecideZeroColumns(homalg_variable_3043,homalg_variable_3072);;
gap> homalg_variable_3075 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3074 = homalg_variable_3075;
true
gap> homalg_variable_3076 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2792);;
gap> SI_ncols(homalg_variable_3076);
4
gap> homalg_variable_3077 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3076 = homalg_variable_3077;
false
gap> homalg_variable_3078 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3076);;
gap> SI_ncols(homalg_variable_3078);
1
gap> homalg_variable_3079 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3078 = homalg_variable_3079;
true
gap> homalg_variable_3080 := SIH_BasisOfColumnModule(homalg_variable_3076);;
gap> SI_ncols(homalg_variable_3080);
4
gap> homalg_variable_3081 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3080 = homalg_variable_3081;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3076);; homalg_variable_3082 := homalg_variable_l[1];; homalg_variable_3083 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3082);
4
gap> homalg_variable_3084 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3082 = homalg_variable_3084;
false
gap> SI_nrows(homalg_variable_3083);
4
gap> homalg_variable_3085 := homalg_variable_3076 * homalg_variable_3083;;
gap> homalg_variable_3082 = homalg_variable_3085;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3080,homalg_variable_3082);; homalg_variable_3086 := homalg_variable_l[1];; homalg_variable_3087 := homalg_variable_l[2];;
gap> homalg_variable_3088 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3086 = homalg_variable_3088;
true
gap> homalg_variable_3089 := homalg_variable_3082 * homalg_variable_3087;;
gap> homalg_variable_3090 := homalg_variable_3080 + homalg_variable_3089;;
gap> homalg_variable_3086 = homalg_variable_3090;
true
gap> homalg_variable_3091 := SIH_DecideZeroColumns(homalg_variable_3080,homalg_variable_3082);;
gap> homalg_variable_3092 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3091 = homalg_variable_3092;
true
gap> homalg_variable_3093 := homalg_variable_3087 * (homalg_variable_8);;
gap> homalg_variable_3094 := homalg_variable_3083 * homalg_variable_3093;;
gap> homalg_variable_3095 := homalg_variable_3076 * homalg_variable_3094;;
gap> homalg_variable_3095 = homalg_variable_3080;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3076,homalg_variable_3080);; homalg_variable_3096 := homalg_variable_l[1];; homalg_variable_3097 := homalg_variable_l[2];;
gap> homalg_variable_3098 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3096 = homalg_variable_3098;
true
gap> homalg_variable_3099 := homalg_variable_3080 * homalg_variable_3097;;
gap> homalg_variable_3100 := homalg_variable_3076 + homalg_variable_3099;;
gap> homalg_variable_3096 = homalg_variable_3100;
true
gap> homalg_variable_3101 := SIH_DecideZeroColumns(homalg_variable_3076,homalg_variable_3080);;
gap> homalg_variable_3102 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3101 = homalg_variable_3102;
true
gap> homalg_variable_3103 := homalg_variable_3097 * (homalg_variable_8);;
gap> homalg_variable_3104 := homalg_variable_3080 * homalg_variable_3103;;
gap> homalg_variable_3104 = homalg_variable_3076;
true
gap> homalg_variable_3105 := SIH_BasisOfColumnModule(homalg_variable_2887);;
gap> SI_ncols(homalg_variable_3105);
4
gap> homalg_variable_3106 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3105 = homalg_variable_3106;
false
gap> homalg_variable_3105 = homalg_variable_2887;
false
gap> homalg_variable_3107 := SIH_DecideZeroColumns(homalg_variable_3076,homalg_variable_3105);;
gap> homalg_variable_3108 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3107 = homalg_variable_3108;
false
gap> SIH_ZeroColumns(homalg_variable_3107);
[ 2, 4 ]
gap> homalg_variable_3110 := SIH_Submatrix(homalg_variable_3107,[1..5],[ 1, 3 ]);;
gap> homalg_variable_3109 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3110,homalg_variable_3105);;
gap> SI_ncols(homalg_variable_3109);
2
gap> homalg_variable_3111 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3109 = homalg_variable_3111;
false
gap> homalg_variable_3113 := homalg_variable_3110 * homalg_variable_3109;;
gap> homalg_variable_3112 := SIH_DecideZeroColumns(homalg_variable_3113,homalg_variable_3105);;
gap> homalg_variable_3114 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_3112 = homalg_variable_3114;
true
gap> homalg_variable_3115 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3110,homalg_variable_3105);;
gap> SI_ncols(homalg_variable_3115);
2
gap> homalg_variable_3116 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3115 = homalg_variable_3116;
false
gap> homalg_variable_3117 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3115);;
gap> SI_ncols(homalg_variable_3117);
1
gap> homalg_variable_3118 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_3117 = homalg_variable_3118;
true
gap> homalg_variable_3119 := SIH_BasisOfColumnModule(homalg_variable_3115);;
gap> SI_ncols(homalg_variable_3119);
2
gap> homalg_variable_3120 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3119 = homalg_variable_3120;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3115);; homalg_variable_3121 := homalg_variable_l[1];; homalg_variable_3122 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3121);
2
gap> homalg_variable_3123 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3121 = homalg_variable_3123;
false
gap> SI_nrows(homalg_variable_3122);
2
gap> homalg_variable_3124 := homalg_variable_3115 * homalg_variable_3122;;
gap> homalg_variable_3121 = homalg_variable_3124;
true
gap> homalg_variable_3121 = homalg_variable_618;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3119,homalg_variable_3121);; homalg_variable_3125 := homalg_variable_l[1];; homalg_variable_3126 := homalg_variable_l[2];;
gap> homalg_variable_3127 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3125 = homalg_variable_3127;
true
gap> homalg_variable_3128 := homalg_variable_3121 * homalg_variable_3126;;
gap> homalg_variable_3129 := homalg_variable_3119 + homalg_variable_3128;;
gap> homalg_variable_3125 = homalg_variable_3129;
true
gap> homalg_variable_3130 := SIH_DecideZeroColumns(homalg_variable_3119,homalg_variable_3121);;
gap> homalg_variable_3131 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3130 = homalg_variable_3131;
true
gap> homalg_variable_3132 := homalg_variable_3126 * (homalg_variable_8);;
gap> homalg_variable_3133 := homalg_variable_3122 * homalg_variable_3132;;
gap> homalg_variable_3134 := homalg_variable_3115 * homalg_variable_3133;;
gap> homalg_variable_3134 = homalg_variable_3119;
true
gap> homalg_variable_3119 = homalg_variable_618;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3115,homalg_variable_3119);; homalg_variable_3135 := homalg_variable_l[1];; homalg_variable_3136 := homalg_variable_l[2];;
gap> homalg_variable_3137 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3135 = homalg_variable_3137;
true
gap> homalg_variable_3138 := homalg_variable_3119 * homalg_variable_3136;;
gap> homalg_variable_3139 := homalg_variable_3115 + homalg_variable_3138;;
gap> homalg_variable_3135 = homalg_variable_3139;
true
gap> homalg_variable_3140 := SIH_DecideZeroColumns(homalg_variable_3115,homalg_variable_3119);;
gap> homalg_variable_3141 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3140 = homalg_variable_3141;
true
gap> homalg_variable_3142 := homalg_variable_3136 * (homalg_variable_8);;
gap> homalg_variable_3143 := homalg_variable_3119 * homalg_variable_3142;;
gap> homalg_variable_3143 = homalg_variable_3115;
true
gap> homalg_variable_3144 := SIH_BasisOfColumnModule(homalg_variable_3109);;
gap> SI_ncols(homalg_variable_3144);
2
gap> homalg_variable_3145 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3144 = homalg_variable_3145;
false
gap> homalg_variable_3144 = homalg_variable_3109;
true
gap> homalg_variable_3146 := SIH_DecideZeroColumns(homalg_variable_3115,homalg_variable_3144);;
gap> homalg_variable_3147 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3146 = homalg_variable_3147;
true
gap> homalg_variable_3148 := SIH_DecideZeroColumns(homalg_variable_618,homalg_variable_3144);;
gap> homalg_variable_3149 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3148 = homalg_variable_3149;
false
gap> SIH_ZeroColumns(homalg_variable_3148);
[  ]
gap> homalg_variable_3150 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2831);;
gap> SI_ncols(homalg_variable_3150);
2
gap> homalg_variable_3151 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_3150 = homalg_variable_3151;
false
gap> homalg_variable_3152 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3150);;
gap> SI_ncols(homalg_variable_3152);
1
gap> homalg_variable_3153 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_3152 = homalg_variable_3153;
true
gap> homalg_variable_3154 := SIH_BasisOfColumnModule(homalg_variable_3150);;
gap> SI_ncols(homalg_variable_3154);
2
gap> homalg_variable_3155 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_3154 = homalg_variable_3155;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3150);; homalg_variable_3156 := homalg_variable_l[1];; homalg_variable_3157 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3156);
2
gap> homalg_variable_3158 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_3156 = homalg_variable_3158;
false
gap> SI_nrows(homalg_variable_3157);
2
gap> homalg_variable_3159 := homalg_variable_3150 * homalg_variable_3157;;
gap> homalg_variable_3156 = homalg_variable_3159;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3154,homalg_variable_3156);; homalg_variable_3160 := homalg_variable_l[1];; homalg_variable_3161 := homalg_variable_l[2];;
gap> homalg_variable_3162 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_3160 = homalg_variable_3162;
true
gap> homalg_variable_3163 := homalg_variable_3156 * homalg_variable_3161;;
gap> homalg_variable_3164 := homalg_variable_3154 + homalg_variable_3163;;
gap> homalg_variable_3160 = homalg_variable_3164;
true
gap> homalg_variable_3165 := SIH_DecideZeroColumns(homalg_variable_3154,homalg_variable_3156);;
gap> homalg_variable_3166 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_3165 = homalg_variable_3166;
true
gap> homalg_variable_3167 := homalg_variable_3161 * (homalg_variable_8);;
gap> homalg_variable_3168 := homalg_variable_3157 * homalg_variable_3167;;
gap> homalg_variable_3169 := homalg_variable_3150 * homalg_variable_3168;;
gap> homalg_variable_3169 = homalg_variable_3154;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3150,homalg_variable_3154);; homalg_variable_3170 := homalg_variable_l[1];; homalg_variable_3171 := homalg_variable_l[2];;
gap> homalg_variable_3172 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_3170 = homalg_variable_3172;
true
gap> homalg_variable_3173 := homalg_variable_3154 * homalg_variable_3171;;
gap> homalg_variable_3174 := homalg_variable_3150 + homalg_variable_3173;;
gap> homalg_variable_3170 = homalg_variable_3174;
true
gap> homalg_variable_3175 := SIH_DecideZeroColumns(homalg_variable_3150,homalg_variable_3154);;
gap> homalg_variable_3176 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_3175 = homalg_variable_3176;
true
gap> homalg_variable_3177 := homalg_variable_3171 * (homalg_variable_8);;
gap> homalg_variable_3178 := homalg_variable_3154 * homalg_variable_3177;;
gap> homalg_variable_3178 = homalg_variable_3150;
true
gap> homalg_variable_3179 := SIH_BasisOfColumnModule(homalg_variable_2926);;
gap> SI_ncols(homalg_variable_3179);
2
gap> homalg_variable_3180 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_3179 = homalg_variable_3180;
false
gap> homalg_variable_3179 = homalg_variable_2926;
true
gap> homalg_variable_3181 := SIH_DecideZeroColumns(homalg_variable_3150,homalg_variable_3179);;
gap> homalg_variable_3182 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_3181 = homalg_variable_3182;
true
gap> homalg_variable_3183 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2856);;
gap> SI_ncols(homalg_variable_3183);
1
gap> homalg_variable_3184 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3183 = homalg_variable_3184;
false
gap> homalg_variable_3185 := SIH_BasisOfColumnModule(homalg_variable_3183);;
gap> SI_ncols(homalg_variable_3185);
1
gap> homalg_variable_3186 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3185 = homalg_variable_3186;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3183);; homalg_variable_3187 := homalg_variable_l[1];; homalg_variable_3188 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3187);
1
gap> homalg_variable_3189 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3187 = homalg_variable_3189;
false
gap> SI_nrows(homalg_variable_3188);
1
gap> homalg_variable_3190 := homalg_variable_3183 * homalg_variable_3188;;
gap> homalg_variable_3187 = homalg_variable_3190;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3185,homalg_variable_3187);; homalg_variable_3191 := homalg_variable_l[1];; homalg_variable_3192 := homalg_variable_l[2];;
gap> homalg_variable_3193 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3191 = homalg_variable_3193;
true
gap> homalg_variable_3194 := homalg_variable_3187 * homalg_variable_3192;;
gap> homalg_variable_3195 := homalg_variable_3185 + homalg_variable_3194;;
gap> homalg_variable_3191 = homalg_variable_3195;
true
gap> homalg_variable_3196 := SIH_DecideZeroColumns(homalg_variable_3185,homalg_variable_3187);;
gap> homalg_variable_3197 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3196 = homalg_variable_3197;
true
gap> homalg_variable_3198 := homalg_variable_3192 * (homalg_variable_8);;
gap> homalg_variable_3199 := homalg_variable_3188 * homalg_variable_3198;;
gap> homalg_variable_3200 := homalg_variable_3183 * homalg_variable_3199;;
gap> homalg_variable_3200 = homalg_variable_3185;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3183,homalg_variable_3185);; homalg_variable_3201 := homalg_variable_l[1];; homalg_variable_3202 := homalg_variable_l[2];;
gap> homalg_variable_3203 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3201 = homalg_variable_3203;
true
gap> homalg_variable_3204 := homalg_variable_3185 * homalg_variable_3202;;
gap> homalg_variable_3205 := homalg_variable_3183 + homalg_variable_3204;;
gap> homalg_variable_3201 = homalg_variable_3205;
true
gap> homalg_variable_3206 := SIH_DecideZeroColumns(homalg_variable_3183,homalg_variable_3185);;
gap> homalg_variable_3207 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3206 = homalg_variable_3207;
true
gap> homalg_variable_3208 := homalg_variable_3202 * (homalg_variable_8);;
gap> homalg_variable_3209 := homalg_variable_3185 * homalg_variable_3208;;
gap> homalg_variable_3209 = homalg_variable_3183;
true
gap> homalg_variable_3210 := SIH_BasisOfColumnModule(homalg_variable_2950);;
gap> SI_ncols(homalg_variable_3210);
1
gap> homalg_variable_3211 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3210 = homalg_variable_3211;
false
gap> homalg_variable_3210 = homalg_variable_2950;
false
gap> homalg_variable_3212 := SIH_DecideZeroColumns(homalg_variable_3183,homalg_variable_3210);;
gap> homalg_variable_3213 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3212 = homalg_variable_3213;
true
gap> homalg_variable_3214 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2887);;
gap> SI_ncols(homalg_variable_3214);
1
gap> homalg_variable_3215 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3214 = homalg_variable_3215;
true
gap> homalg_variable_3216 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2926);;
gap> SI_ncols(homalg_variable_3216);
1
gap> homalg_variable_3217 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_3216 = homalg_variable_3217;
true
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_2446);; homalg_variable_3218 := homalg_variable_l[1];; homalg_variable_3219 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3218);
1
gap> homalg_variable_3220 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_3218 = homalg_variable_3220;
false
gap> SI_nrows(homalg_variable_3219);
5
gap> homalg_variable_3221 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3222 := SIH_Submatrix(homalg_variable_3219,[ 1 ],[1..1]);;
gap> homalg_variable_3223 := SIH_UnionOfRows(homalg_variable_3221,homalg_variable_3222);;
gap> homalg_variable_3218 = homalg_variable_3223;
true
gap> homalg_variable_3224 := homalg_variable_2571 * homalg_variable_3110;;
gap> homalg_variable_3225 := homalg_variable_2786 * homalg_variable_3224;;
gap> homalg_variable_3226 := homalg_variable_3225 * (homalg_variable_8);;
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3226,homalg_variable_3218);; homalg_variable_3227 := homalg_variable_l[1];; homalg_variable_3228 := homalg_variable_l[2];;
gap> homalg_variable_3229 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3227 = homalg_variable_3229;
true
gap> homalg_variable_3230 := homalg_variable_3218 * homalg_variable_3228;;
gap> homalg_variable_3231 := homalg_variable_3230 - homalg_variable_3225;;
gap> homalg_variable_3227 = homalg_variable_3231;
true
gap> homalg_variable_3232 := SIH_DecideZeroColumns(homalg_variable_3226,homalg_variable_3218);;
gap> homalg_variable_3233 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3232 = homalg_variable_3233;
true
gap> homalg_variable_3234 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_3235 := SIH_Submatrix(homalg_variable_3219,[ 1 ],[1..1]);;
gap> homalg_variable_3236 := homalg_variable_3228 * (homalg_variable_8);;
gap> homalg_variable_3237 := homalg_variable_3235 * homalg_variable_3236;;
gap> homalg_variable_3238 := SIH_UnionOfRows(homalg_variable_3234,homalg_variable_3237);;
gap> homalg_variable_3239 := homalg_variable_3238 - homalg_variable_3226;;
gap> homalg_variable_3240 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3239 = homalg_variable_3240;
true
gap> homalg_variable_3242 := homalg_variable_3219 * homalg_variable_3236;;
gap> homalg_variable_3243 := homalg_variable_2119 * homalg_variable_3242;;
gap> homalg_variable_3244 := homalg_variable_3243 * homalg_variable_3144;;
gap> homalg_variable_3241 := SIH_DecideZeroColumns(homalg_variable_3244,homalg_variable_2954);;
gap> homalg_variable_3245 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_3241 = homalg_variable_3245;
true
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_2528);; homalg_variable_3246 := homalg_variable_l[1];; homalg_variable_3247 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3246);
2
gap> homalg_variable_3248 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3246 = homalg_variable_3248;
false
gap> SI_nrows(homalg_variable_3247);
10
gap> homalg_variable_3249 := SIH_Submatrix(homalg_variable_3247,[ 1, 2 ],[1..2]);;
gap> homalg_variable_3246 = homalg_variable_3249;
true
gap> homalg_variable_3246 = homalg_variable_618;
true
gap> homalg_variable_3250 := SIH_Submatrix(homalg_variable_3247,[ 1, 2 ],[1..2]);;
gap> homalg_variable_3251 := SIH_Submatrix(homalg_variable_572,[1..2],[ 1, 2 ]);;
gap> homalg_variable_3252 := homalg_variable_3251 * (homalg_variable_8);;
gap> homalg_variable_3253 := homalg_variable_3250 * homalg_variable_3252;;
gap> homalg_variable_3254 := homalg_variable_3251 * (homalg_variable_8);;
gap> homalg_variable_3255 := homalg_variable_3253 - homalg_variable_3254;;
gap> homalg_variable_3256 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3255 = homalg_variable_3256;
true
gap> homalg_variable_3258 := homalg_variable_2451 * homalg_variable_2792;;
gap> homalg_variable_3259 := SIH_UnionOfColumns(homalg_variable_2446,homalg_variable_3258);;
gap> homalg_variable_3257 := SIH_BasisOfColumnModule(homalg_variable_3259);;
gap> SI_ncols(homalg_variable_3257);
3
gap> homalg_variable_3260 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_3257 = homalg_variable_3260;
false
gap> homalg_variable_3261 := SIH_DecideZeroColumns(homalg_variable_2451,homalg_variable_3257);;
gap> homalg_variable_3262 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_3261 = homalg_variable_3262;
false
gap> homalg_variable_3263 := SIH_UnionOfColumns(homalg_variable_3261,homalg_variable_3257);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3263);; homalg_variable_3264 := homalg_variable_l[1];; homalg_variable_3265 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3264);
2
gap> homalg_variable_3266 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3264 = homalg_variable_3266;
false
gap> SI_nrows(homalg_variable_3265);
4
gap> homalg_variable_3267 := SIH_Submatrix(homalg_variable_3265,[ 1 ],[1..2]);;
gap> homalg_variable_3268 := homalg_variable_3261 * homalg_variable_3267;;
gap> homalg_variable_3269 := SIH_Submatrix(homalg_variable_3265,[ 2, 3, 4 ],[1..2]);;
gap> homalg_variable_3270 := homalg_variable_3257 * homalg_variable_3269;;
gap> homalg_variable_3271 := homalg_variable_3268 + homalg_variable_3270;;
gap> homalg_variable_3264 = homalg_variable_3271;
true
gap> homalg_variable_3273 := homalg_variable_3247 * homalg_variable_3252;;
gap> homalg_variable_3274 := homalg_variable_2786 * homalg_variable_3273;;
gap> homalg_variable_3272 := SIH_DecideZeroColumns(homalg_variable_3274,homalg_variable_3257);;
gap> homalg_variable_3275 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3272 = homalg_variable_3275;
false
gap> homalg_variable_3276 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3274 = homalg_variable_3276;
false
gap> homalg_variable_3264 = homalg_variable_618;
true
gap> homalg_variable_3278 := SIH_Submatrix(homalg_variable_3265,[ 1 ],[1..2]);;
gap> homalg_variable_3279 := homalg_variable_3278 * homalg_variable_3272;;
gap> homalg_variable_3280 := homalg_variable_2451 * homalg_variable_3279;;
gap> homalg_variable_3281 := homalg_variable_3280 - homalg_variable_3274;;
gap> homalg_variable_3277 := SIH_DecideZeroColumns(homalg_variable_3281,homalg_variable_3257);;
gap> homalg_variable_3282 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3277 = homalg_variable_3282;
true
gap> homalg_variable_3284 := SIH_UnionOfColumns(homalg_variable_3243,homalg_variable_2955);;
gap> homalg_variable_3283 := SIH_BasisOfColumnModule(homalg_variable_3284);;
gap> SI_ncols(homalg_variable_3283);
3
gap> homalg_variable_3285 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_3283 = homalg_variable_3285;
false
gap> homalg_variable_3286 := SIH_DecideZeroColumns(homalg_variable_860,homalg_variable_3283);;
gap> homalg_variable_3287 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3286 = homalg_variable_3287;
false
gap> homalg_variable_3289 := SIH_UnionOfColumns(homalg_variable_3279,homalg_variable_2792);;
gap> homalg_variable_3288 := SIH_BasisOfColumnModule(homalg_variable_3289);;
gap> SI_ncols(homalg_variable_3288);
1
gap> homalg_variable_3290 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3288 = homalg_variable_3290;
false
gap> homalg_variable_3291 := SIH_DecideZeroColumns(homalg_variable_860,homalg_variable_3288);;
gap> homalg_variable_3292 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3291 = homalg_variable_3292;
true
gap> homalg_variable_3293 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3243,homalg_variable_2955);;
gap> SI_ncols(homalg_variable_3293);
4
gap> homalg_variable_3294 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_3293 = homalg_variable_3294;
false
gap> homalg_variable_3295 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3293);;
gap> SI_ncols(homalg_variable_3295);
3
gap> homalg_variable_3296 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_3295 = homalg_variable_3296;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_3295,[ 0 ]);
[  ]
gap> homalg_variable_3297 := SIH_BasisOfColumnModule(homalg_variable_3293);;
gap> SI_ncols(homalg_variable_3297);
4
gap> homalg_variable_3298 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_3297 = homalg_variable_3298;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3293);; homalg_variable_3299 := homalg_variable_l[1];; homalg_variable_3300 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3299);
4
gap> homalg_variable_3301 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_3299 = homalg_variable_3301;
false
gap> SI_nrows(homalg_variable_3300);
4
gap> homalg_variable_3302 := homalg_variable_3293 * homalg_variable_3300;;
gap> homalg_variable_3299 = homalg_variable_3302;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3297,homalg_variable_3299);; homalg_variable_3303 := homalg_variable_l[1];; homalg_variable_3304 := homalg_variable_l[2];;
gap> homalg_variable_3305 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_3303 = homalg_variable_3305;
true
gap> homalg_variable_3306 := homalg_variable_3299 * homalg_variable_3304;;
gap> homalg_variable_3307 := homalg_variable_3297 + homalg_variable_3306;;
gap> homalg_variable_3303 = homalg_variable_3307;
true
gap> homalg_variable_3308 := SIH_DecideZeroColumns(homalg_variable_3297,homalg_variable_3299);;
gap> homalg_variable_3309 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_3308 = homalg_variable_3309;
true
gap> homalg_variable_3310 := homalg_variable_3304 * (homalg_variable_8);;
gap> homalg_variable_3311 := homalg_variable_3300 * homalg_variable_3310;;
gap> homalg_variable_3312 := homalg_variable_3293 * homalg_variable_3311;;
gap> homalg_variable_3312 = homalg_variable_3297;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3293,homalg_variable_3297);; homalg_variable_3313 := homalg_variable_l[1];; homalg_variable_3314 := homalg_variable_l[2];;
gap> homalg_variable_3315 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_3313 = homalg_variable_3315;
true
gap> homalg_variable_3316 := homalg_variable_3297 * homalg_variable_3314;;
gap> homalg_variable_3317 := homalg_variable_3293 + homalg_variable_3316;;
gap> homalg_variable_3313 = homalg_variable_3317;
true
gap> homalg_variable_3318 := SIH_DecideZeroColumns(homalg_variable_3293,homalg_variable_3297);;
gap> homalg_variable_3319 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_3318 = homalg_variable_3319;
true
gap> homalg_variable_3320 := homalg_variable_3314 * (homalg_variable_8);;
gap> homalg_variable_3321 := homalg_variable_3297 * homalg_variable_3320;;
gap> homalg_variable_3321 = homalg_variable_3293;
true
gap> homalg_variable_3322 := SIH_DecideZeroColumns(homalg_variable_3293,homalg_variable_3144);;
gap> homalg_variable_3323 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_3322 = homalg_variable_3323;
false
gap> SIH_ZeroColumns(homalg_variable_3322);
[  ]
gap> homalg_variable_3324 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3322,homalg_variable_3144);;
gap> SI_ncols(homalg_variable_3324);
5
gap> homalg_variable_3325 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_3324 = homalg_variable_3325;
false
gap> homalg_variable_3327 := homalg_variable_3322 * homalg_variable_3324;;
gap> homalg_variable_3326 := SIH_DecideZeroColumns(homalg_variable_3327,homalg_variable_3144);;
gap> homalg_variable_3328 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_3326 = homalg_variable_3328;
true
gap> homalg_variable_3329 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3322,homalg_variable_3144);;
gap> SI_ncols(homalg_variable_3329);
5
gap> homalg_variable_3330 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_3329 = homalg_variable_3330;
false
gap> homalg_variable_3331 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3329);;
gap> SI_ncols(homalg_variable_3331);
1
gap> homalg_variable_3332 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_3331 = homalg_variable_3332;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_3331,[ 0 ]);
[  ]
gap> homalg_variable_3333 := SIH_BasisOfColumnModule(homalg_variable_3329);;
gap> SI_ncols(homalg_variable_3333);
5
gap> homalg_variable_3334 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_3333 = homalg_variable_3334;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3329);; homalg_variable_3335 := homalg_variable_l[1];; homalg_variable_3336 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3335);
5
gap> homalg_variable_3337 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_3335 = homalg_variable_3337;
false
gap> SI_nrows(homalg_variable_3336);
5
gap> homalg_variable_3338 := homalg_variable_3329 * homalg_variable_3336;;
gap> homalg_variable_3335 = homalg_variable_3338;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3333,homalg_variable_3335);; homalg_variable_3339 := homalg_variable_l[1];; homalg_variable_3340 := homalg_variable_l[2];;
gap> homalg_variable_3341 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_3339 = homalg_variable_3341;
true
gap> homalg_variable_3342 := homalg_variable_3335 * homalg_variable_3340;;
gap> homalg_variable_3343 := homalg_variable_3333 + homalg_variable_3342;;
gap> homalg_variable_3339 = homalg_variable_3343;
true
gap> homalg_variable_3344 := SIH_DecideZeroColumns(homalg_variable_3333,homalg_variable_3335);;
gap> homalg_variable_3345 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_3344 = homalg_variable_3345;
true
gap> homalg_variable_3346 := homalg_variable_3340 * (homalg_variable_8);;
gap> homalg_variable_3347 := homalg_variable_3336 * homalg_variable_3346;;
gap> homalg_variable_3348 := homalg_variable_3329 * homalg_variable_3347;;
gap> homalg_variable_3348 = homalg_variable_3333;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3329,homalg_variable_3333);; homalg_variable_3349 := homalg_variable_l[1];; homalg_variable_3350 := homalg_variable_l[2];;
gap> homalg_variable_3351 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_3349 = homalg_variable_3351;
true
gap> homalg_variable_3352 := homalg_variable_3333 * homalg_variable_3350;;
gap> homalg_variable_3353 := homalg_variable_3329 + homalg_variable_3352;;
gap> homalg_variable_3349 = homalg_variable_3353;
true
gap> homalg_variable_3354 := SIH_DecideZeroColumns(homalg_variable_3329,homalg_variable_3333);;
gap> homalg_variable_3355 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_3354 = homalg_variable_3355;
true
gap> homalg_variable_3356 := homalg_variable_3350 * (homalg_variable_8);;
gap> homalg_variable_3357 := homalg_variable_3333 * homalg_variable_3356;;
gap> homalg_variable_3357 = homalg_variable_3329;
true
gap> homalg_variable_3358 := SIH_BasisOfColumnModule(homalg_variable_3324);;
gap> SI_ncols(homalg_variable_3358);
5
gap> homalg_variable_3359 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_3358 = homalg_variable_3359;
false
gap> homalg_variable_3358 = homalg_variable_3324;
true
gap> homalg_variable_3360 := SIH_DecideZeroColumns(homalg_variable_3329,homalg_variable_3358);;
gap> homalg_variable_3361 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_3360 = homalg_variable_3361;
true
gap> homalg_variable_3362 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3279,homalg_variable_2792);;
gap> SI_ncols(homalg_variable_3362);
3
gap> homalg_variable_3363 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_3362 = homalg_variable_3363;
false
gap> homalg_variable_3364 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3362);;
gap> SI_ncols(homalg_variable_3364);
1
gap> homalg_variable_3365 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3364 = homalg_variable_3365;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_3364,[ 0 ]);
[  ]
gap> homalg_variable_3366 := SIH_BasisOfColumnModule(homalg_variable_3362);;
gap> SI_ncols(homalg_variable_3366);
3
gap> homalg_variable_3367 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_3366 = homalg_variable_3367;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3362);; homalg_variable_3368 := homalg_variable_l[1];; homalg_variable_3369 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3368);
3
gap> homalg_variable_3370 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_3368 = homalg_variable_3370;
false
gap> SI_nrows(homalg_variable_3369);
3
gap> homalg_variable_3371 := homalg_variable_3362 * homalg_variable_3369;;
gap> homalg_variable_3368 = homalg_variable_3371;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3366,homalg_variable_3368);; homalg_variable_3372 := homalg_variable_l[1];; homalg_variable_3373 := homalg_variable_l[2];;
gap> homalg_variable_3374 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_3372 = homalg_variable_3374;
true
gap> homalg_variable_3375 := homalg_variable_3368 * homalg_variable_3373;;
gap> homalg_variable_3376 := homalg_variable_3366 + homalg_variable_3375;;
gap> homalg_variable_3372 = homalg_variable_3376;
true
gap> homalg_variable_3377 := SIH_DecideZeroColumns(homalg_variable_3366,homalg_variable_3368);;
gap> homalg_variable_3378 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_3377 = homalg_variable_3378;
true
gap> homalg_variable_3379 := homalg_variable_3373 * (homalg_variable_8);;
gap> homalg_variable_3380 := homalg_variable_3369 * homalg_variable_3379;;
gap> homalg_variable_3381 := homalg_variable_3362 * homalg_variable_3380;;
gap> homalg_variable_3381 = homalg_variable_3366;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3362,homalg_variable_3366);; homalg_variable_3382 := homalg_variable_l[1];; homalg_variable_3383 := homalg_variable_l[2];;
gap> homalg_variable_3384 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_3382 = homalg_variable_3384;
true
gap> homalg_variable_3385 := homalg_variable_3366 * homalg_variable_3383;;
gap> homalg_variable_3386 := homalg_variable_3362 + homalg_variable_3385;;
gap> homalg_variable_3382 = homalg_variable_3386;
true
gap> homalg_variable_3387 := SIH_DecideZeroColumns(homalg_variable_3362,homalg_variable_3366);;
gap> homalg_variable_3388 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_3387 = homalg_variable_3388;
true
gap> homalg_variable_3389 := homalg_variable_3383 * (homalg_variable_8);;
gap> homalg_variable_3390 := homalg_variable_3366 * homalg_variable_3389;;
gap> homalg_variable_3390 = homalg_variable_3362;
true
gap> SIH_ZeroColumns(homalg_variable_3362);
[  ]
gap> homalg_variable_3391 := homalg_variable_3362 * homalg_variable_3364;;
gap> homalg_variable_3392 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_3391 = homalg_variable_3392;
true
gap> homalg_variable_3393 := SIH_BasisOfColumnModule(homalg_variable_3364);;
gap> SI_ncols(homalg_variable_3393);
1
gap> homalg_variable_3394 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3393 = homalg_variable_3394;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3364);; homalg_variable_3395 := homalg_variable_l[1];; homalg_variable_3396 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3395);
1
gap> homalg_variable_3397 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3395 = homalg_variable_3397;
false
gap> SI_nrows(homalg_variable_3396);
1
gap> homalg_variable_3398 := homalg_variable_3364 * homalg_variable_3396;;
gap> homalg_variable_3395 = homalg_variable_3398;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3393,homalg_variable_3395);; homalg_variable_3399 := homalg_variable_l[1];; homalg_variable_3400 := homalg_variable_l[2];;
gap> homalg_variable_3401 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3399 = homalg_variable_3401;
true
gap> homalg_variable_3402 := homalg_variable_3395 * homalg_variable_3400;;
gap> homalg_variable_3403 := homalg_variable_3393 + homalg_variable_3402;;
gap> homalg_variable_3399 = homalg_variable_3403;
true
gap> homalg_variable_3404 := SIH_DecideZeroColumns(homalg_variable_3393,homalg_variable_3395);;
gap> homalg_variable_3405 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3404 = homalg_variable_3405;
true
gap> homalg_variable_3406 := homalg_variable_3400 * (homalg_variable_8);;
gap> homalg_variable_3407 := homalg_variable_3396 * homalg_variable_3406;;
gap> homalg_variable_3408 := homalg_variable_3364 * homalg_variable_3407;;
gap> homalg_variable_3408 = homalg_variable_3393;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3364,homalg_variable_3393);; homalg_variable_3409 := homalg_variable_l[1];; homalg_variable_3410 := homalg_variable_l[2];;
gap> homalg_variable_3411 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3409 = homalg_variable_3411;
true
gap> homalg_variable_3412 := homalg_variable_3393 * homalg_variable_3410;;
gap> homalg_variable_3413 := homalg_variable_3364 + homalg_variable_3412;;
gap> homalg_variable_3409 = homalg_variable_3413;
true
gap> homalg_variable_3414 := SIH_DecideZeroColumns(homalg_variable_3364,homalg_variable_3393);;
gap> homalg_variable_3415 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3414 = homalg_variable_3415;
true
gap> homalg_variable_3416 := homalg_variable_3410 * (homalg_variable_8);;
gap> homalg_variable_3417 := homalg_variable_3393 * homalg_variable_3416;;
gap> homalg_variable_3417 = homalg_variable_3364;
true
gap> homalg_variable_3393 = homalg_variable_3364;
true
gap> homalg_variable_3419 := SIH_UnionOfRows(homalg_variable_2528,homalg_variable_2786);;
gap> homalg_variable_3418 := SIH_BasisOfColumnModule(homalg_variable_3419);;
gap> SI_ncols(homalg_variable_3418);
7
gap> homalg_variable_3420 := SI_matrix(homalg_variable_5,4,7,"0");;
gap> homalg_variable_3418 = homalg_variable_3420;
false
gap> homalg_variable_3422 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_3423 := SIH_UnionOfRows(homalg_variable_3422,homalg_variable_2446);;
gap> homalg_variable_3421 := SIH_DecideZeroColumns(homalg_variable_3423,homalg_variable_3418);;
gap> homalg_variable_3424 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_3421 = homalg_variable_3424;
false
gap> homalg_variable_3425 := SIH_UnionOfColumns(homalg_variable_3421,homalg_variable_3418);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3425);; homalg_variable_3426 := homalg_variable_l[1];; homalg_variable_3427 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3426);
5
gap> homalg_variable_3428 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_3426 = homalg_variable_3428;
false
gap> SI_nrows(homalg_variable_3427);
12
gap> homalg_variable_3429 := SIH_Submatrix(homalg_variable_3427,[ 1, 2, 3, 4, 5 ],[1..5]);;
gap> homalg_variable_3430 := homalg_variable_3421 * homalg_variable_3429;;
gap> homalg_variable_3431 := SIH_Submatrix(homalg_variable_3427,[ 6, 7, 8, 9, 10, 11, 12 ],[1..5]);;
gap> homalg_variable_3432 := homalg_variable_3418 * homalg_variable_3431;;
gap> homalg_variable_3433 := homalg_variable_3430 + homalg_variable_3432;;
gap> homalg_variable_3426 = homalg_variable_3433;
true
gap> homalg_variable_3435 := SIH_Submatrix(homalg_variable_1109,[1..7],[ 1, 2 ]);;
gap> homalg_variable_3436 := homalg_variable_3435 * homalg_variable_3362;;
gap> homalg_variable_3437 := homalg_variable_572 * homalg_variable_3436;;
gap> homalg_variable_3438 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_3439 := SIH_UnionOfRows(homalg_variable_3437,homalg_variable_3438);;
gap> homalg_variable_3440 := homalg_variable_3439 * (homalg_variable_8);;
gap> homalg_variable_3434 := SIH_DecideZeroColumns(homalg_variable_3440,homalg_variable_3418);;
gap> homalg_variable_3441 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_3434 = homalg_variable_3441;
false
gap> homalg_variable_3442 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_3437 = homalg_variable_3442;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3434,homalg_variable_3426);; homalg_variable_3443 := homalg_variable_l[1];; homalg_variable_3444 := homalg_variable_l[2];;
gap> homalg_variable_3445 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_3443 = homalg_variable_3445;
true
gap> homalg_variable_3446 := homalg_variable_3426 * homalg_variable_3444;;
gap> homalg_variable_3447 := homalg_variable_3434 + homalg_variable_3446;;
gap> homalg_variable_3443 = homalg_variable_3447;
true
gap> homalg_variable_3448 := SIH_DecideZeroColumns(homalg_variable_3434,homalg_variable_3426);;
gap> homalg_variable_3449 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_3448 = homalg_variable_3449;
true
gap> homalg_variable_3451 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_3452 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_3453 := SIH_Submatrix(homalg_variable_3427,[ 1 ],[1..5]);;
gap> homalg_variable_3454 := homalg_variable_3444 * (homalg_variable_8);;
gap> homalg_variable_3455 := homalg_variable_3453 * homalg_variable_3454;;
gap> homalg_variable_3456 := SIH_UnionOfRows(homalg_variable_3452,homalg_variable_3455);;
gap> homalg_variable_3457 := SIH_UnionOfRows(homalg_variable_3451,homalg_variable_3456);;
gap> homalg_variable_3458 := homalg_variable_3457 - homalg_variable_3440;;
gap> homalg_variable_3450 := SIH_DecideZeroColumns(homalg_variable_3458,homalg_variable_3418);;
gap> homalg_variable_3459 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_3450 = homalg_variable_3459;
true
gap> homalg_variable_3461 := SIH_Submatrix(homalg_variable_3427,[ 1, 2, 3, 4, 5 ],[1..5]);;
gap> homalg_variable_3462 := homalg_variable_3461 * homalg_variable_3454;;
gap> homalg_variable_3463 := homalg_variable_2119 * homalg_variable_3462;;
gap> homalg_variable_3464 := homalg_variable_3463 * homalg_variable_3393;;
gap> homalg_variable_3460 := SIH_DecideZeroColumns(homalg_variable_3464,homalg_variable_3283);;
gap> homalg_variable_3465 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3460 = homalg_variable_3465;
true
gap> homalg_variable_3467 := SIH_UnionOfColumns(homalg_variable_3463,homalg_variable_3284);;
gap> homalg_variable_3466 := SIH_BasisOfColumnModule(homalg_variable_3467);;
gap> SI_ncols(homalg_variable_3466);
1
gap> homalg_variable_3468 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3466 = homalg_variable_3468;
false
gap> homalg_variable_3469 := SIH_DecideZeroColumns(homalg_variable_860,homalg_variable_3466);;
gap> homalg_variable_3470 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3469 = homalg_variable_3470;
true
gap> homalg_variable_3471 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3463,homalg_variable_3284);;
gap> SI_ncols(homalg_variable_3471);
5
gap> homalg_variable_3472 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_3471 = homalg_variable_3472;
false
gap> homalg_variable_3473 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3471);;
gap> SI_ncols(homalg_variable_3473);
3
gap> homalg_variable_3474 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_3473 = homalg_variable_3474;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_3473,[ 0 ]);
[  ]
gap> homalg_variable_3475 := SIH_BasisOfColumnModule(homalg_variable_3471);;
gap> SI_ncols(homalg_variable_3475);
5
gap> homalg_variable_3476 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_3475 = homalg_variable_3476;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3471);; homalg_variable_3477 := homalg_variable_l[1];; homalg_variable_3478 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3477);
5
gap> homalg_variable_3479 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_3477 = homalg_variable_3479;
false
gap> SI_nrows(homalg_variable_3478);
5
gap> homalg_variable_3480 := homalg_variable_3471 * homalg_variable_3478;;
gap> homalg_variable_3477 = homalg_variable_3480;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3475,homalg_variable_3477);; homalg_variable_3481 := homalg_variable_l[1];; homalg_variable_3482 := homalg_variable_l[2];;
gap> homalg_variable_3483 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_3481 = homalg_variable_3483;
true
gap> homalg_variable_3484 := homalg_variable_3477 * homalg_variable_3482;;
gap> homalg_variable_3485 := homalg_variable_3475 + homalg_variable_3484;;
gap> homalg_variable_3481 = homalg_variable_3485;
true
gap> homalg_variable_3486 := SIH_DecideZeroColumns(homalg_variable_3475,homalg_variable_3477);;
gap> homalg_variable_3487 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_3486 = homalg_variable_3487;
true
gap> homalg_variable_3488 := homalg_variable_3482 * (homalg_variable_8);;
gap> homalg_variable_3489 := homalg_variable_3478 * homalg_variable_3488;;
gap> homalg_variable_3490 := homalg_variable_3471 * homalg_variable_3489;;
gap> homalg_variable_3490 = homalg_variable_3475;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3471,homalg_variable_3475);; homalg_variable_3491 := homalg_variable_l[1];; homalg_variable_3492 := homalg_variable_l[2];;
gap> homalg_variable_3493 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_3491 = homalg_variable_3493;
true
gap> homalg_variable_3494 := homalg_variable_3475 * homalg_variable_3492;;
gap> homalg_variable_3495 := homalg_variable_3471 + homalg_variable_3494;;
gap> homalg_variable_3491 = homalg_variable_3495;
true
gap> homalg_variable_3496 := SIH_DecideZeroColumns(homalg_variable_3471,homalg_variable_3475);;
gap> homalg_variable_3497 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_3496 = homalg_variable_3497;
true
gap> homalg_variable_3498 := homalg_variable_3492 * (homalg_variable_8);;
gap> homalg_variable_3499 := homalg_variable_3475 * homalg_variable_3498;;
gap> homalg_variable_3499 = homalg_variable_3471;
true
gap> homalg_variable_3500 := SIH_DecideZeroColumns(homalg_variable_3471,homalg_variable_3393);;
gap> for _del in [ "homalg_variable_3001", "homalg_variable_3002", "homalg_variable_3004", "homalg_variable_3005", "homalg_variable_3006", "homalg_variable_3007", "homalg_variable_3009", "homalg_variable_3011", "homalg_variable_3013", "homalg_variable_3016", "homalg_variable_3017", "homalg_variable_3018", "homalg_variable_3019", "homalg_variable_3020", "homalg_variable_3021", "homalg_variable_3022", "homalg_variable_3023", "homalg_variable_3024", "homalg_variable_3025", "homalg_variable_3026", "homalg_variable_3027", "homalg_variable_3028", "homalg_variable_3029", "homalg_variable_3030", "homalg_variable_3031", "homalg_variable_3032", "homalg_variable_3033", "homalg_variable_3034", "homalg_variable_3035", "homalg_variable_3036", "homalg_variable_3038", "homalg_variable_3041", "homalg_variable_3042", "homalg_variable_3044", "homalg_variable_3046", "homalg_variable_3048", "homalg_variable_3051", "homalg_variable_3052", "homalg_variable_3055", "homalg_variable_3056", "homalg_variable_3057", "homalg_variable_3062", "homalg_variable_3063", "homalg_variable_3064", "homalg_variable_3065", "homalg_variable_3066", "homalg_variable_3067", "homalg_variable_3068", "homalg_variable_3069", "homalg_variable_3070", "homalg_variable_3071", "homalg_variable_3073", "homalg_variable_3074", "homalg_variable_3075", "homalg_variable_3077", "homalg_variable_3078", "homalg_variable_3079", "homalg_variable_3081", "homalg_variable_3084", "homalg_variable_3085", "homalg_variable_3089", "homalg_variable_3090", "homalg_variable_3091", "homalg_variable_3092", "homalg_variable_3095", "homalg_variable_3096", "homalg_variable_3097", "homalg_variable_3098", "homalg_variable_3099", "homalg_variable_3100", "homalg_variable_3101", "homalg_variable_3102", "homalg_variable_3103", "homalg_variable_3104", "homalg_variable_3106", "homalg_variable_3108", "homalg_variable_3111", "homalg_variable_3112", "homalg_variable_3113", "homalg_variable_3114", "homalg_variable_3116", "homalg_variable_3117", "homalg_variable_3118", "homalg_variable_3120", "homalg_variable_3123", "homalg_variable_3124", "homalg_variable_3127", "homalg_variable_3128", "homalg_variable_3129", "homalg_variable_3134", "homalg_variable_3135", "homalg_variable_3136", "homalg_variable_3137", "homalg_variable_3138", "homalg_variable_3139", "homalg_variable_3140", "homalg_variable_3141", "homalg_variable_3142", "homalg_variable_3143", "homalg_variable_3145", "homalg_variable_3146", "homalg_variable_3147", "homalg_variable_3148", "homalg_variable_3149", "homalg_variable_3151", "homalg_variable_3152", "homalg_variable_3153", "homalg_variable_3155", "homalg_variable_3158", "homalg_variable_3159", "homalg_variable_3160", "homalg_variable_3161", "homalg_variable_3162", "homalg_variable_3163", "homalg_variable_3164", "homalg_variable_3165", "homalg_variable_3166", "homalg_variable_3167", "homalg_variable_3168", "homalg_variable_3169", "homalg_variable_3170", "homalg_variable_3171", "homalg_variable_3172", "homalg_variable_3173", "homalg_variable_3174", "homalg_variable_3175", "homalg_variable_3176", "homalg_variable_3177", "homalg_variable_3178", "homalg_variable_3180", "homalg_variable_3181", "homalg_variable_3182", "homalg_variable_3184", "homalg_variable_3186", "homalg_variable_3189", "homalg_variable_3190", "homalg_variable_3191", "homalg_variable_3192", "homalg_variable_3193", "homalg_variable_3194", "homalg_variable_3195", "homalg_variable_3196", "homalg_variable_3197", "homalg_variable_3198", "homalg_variable_3199", "homalg_variable_3200", "homalg_variable_3201", "homalg_variable_3202", "homalg_variable_3203", "homalg_variable_3204", "homalg_variable_3205", "homalg_variable_3206", "homalg_variable_3207", "homalg_variable_3208", "homalg_variable_3209", "homalg_variable_3211", "homalg_variable_3212", "homalg_variable_3213", "homalg_variable_3214", "homalg_variable_3215", "homalg_variable_3216", "homalg_variable_3217", "homalg_variable_3220", "homalg_variable_3221", "homalg_variable_3222", "homalg_variable_3223", "homalg_variable_3227", "homalg_variable_3229", "homalg_variable_3230", "homalg_variable_3231", "homalg_variable_3232", "homalg_variable_3233", "homalg_variable_3234", "homalg_variable_3235", "homalg_variable_3237", "homalg_variable_3238", "homalg_variable_3239", "homalg_variable_3240", "homalg_variable_3241", "homalg_variable_3245", "homalg_variable_3248", "homalg_variable_3249", "homalg_variable_3250", "homalg_variable_3253", "homalg_variable_3255", "homalg_variable_3256", "homalg_variable_3260", "homalg_variable_3261", "homalg_variable_3262", "homalg_variable_3263", "homalg_variable_3264", "homalg_variable_3266", "homalg_variable_3267", "homalg_variable_3268", "homalg_variable_3269", "homalg_variable_3270", "homalg_variable_3271", "homalg_variable_3275", "homalg_variable_3276", "homalg_variable_3277", "homalg_variable_3280", "homalg_variable_3281", "homalg_variable_3282", "homalg_variable_3285", "homalg_variable_3286", "homalg_variable_3287", "homalg_variable_3290", "homalg_variable_3294", "homalg_variable_3296", "homalg_variable_3298", "homalg_variable_3301", "homalg_variable_3302", "homalg_variable_3303", "homalg_variable_3304", "homalg_variable_3305", "homalg_variable_3306", "homalg_variable_3307", "homalg_variable_3308", "homalg_variable_3309", "homalg_variable_3310", "homalg_variable_3311", "homalg_variable_3312", "homalg_variable_3313", "homalg_variable_3314", "homalg_variable_3315", "homalg_variable_3316", "homalg_variable_3317", "homalg_variable_3318", "homalg_variable_3319", "homalg_variable_3320", "homalg_variable_3321", "homalg_variable_3323", "homalg_variable_3325", "homalg_variable_3326", "homalg_variable_3327", "homalg_variable_3328", "homalg_variable_3330", "homalg_variable_3332", "homalg_variable_3334", "homalg_variable_3337", "homalg_variable_3338", "homalg_variable_3339", "homalg_variable_3340", "homalg_variable_3341", "homalg_variable_3342", "homalg_variable_3343", "homalg_variable_3344", "homalg_variable_3345", "homalg_variable_3346", "homalg_variable_3347", "homalg_variable_3348", "homalg_variable_3349", "homalg_variable_3350", "homalg_variable_3351", "homalg_variable_3352", "homalg_variable_3353", "homalg_variable_3354", "homalg_variable_3355", "homalg_variable_3356", "homalg_variable_3357", "homalg_variable_3359", "homalg_variable_3360", "homalg_variable_3361", "homalg_variable_3363", "homalg_variable_3365", "homalg_variable_3367", "homalg_variable_3370", "homalg_variable_3371", "homalg_variable_3372", "homalg_variable_3373", "homalg_variable_3374", "homalg_variable_3375", "homalg_variable_3376", "homalg_variable_3377", "homalg_variable_3378", "homalg_variable_3379", "homalg_variable_3380", "homalg_variable_3381", "homalg_variable_3382", "homalg_variable_3383", "homalg_variable_3384", "homalg_variable_3385", "homalg_variable_3386", "homalg_variable_3387", "homalg_variable_3388", "homalg_variable_3389", "homalg_variable_3390", "homalg_variable_3391", "homalg_variable_3392", "homalg_variable_3394", "homalg_variable_3397", "homalg_variable_3398", "homalg_variable_3399", "homalg_variable_3400", "homalg_variable_3401", "homalg_variable_3402", "homalg_variable_3403", "homalg_variable_3404", "homalg_variable_3405", "homalg_variable_3406", "homalg_variable_3407", "homalg_variable_3408", "homalg_variable_3409", "homalg_variable_3410", "homalg_variable_3411", "homalg_variable_3412", "homalg_variable_3413", "homalg_variable_3414", "homalg_variable_3415", "homalg_variable_3416", "homalg_variable_3417", "homalg_variable_3421", "homalg_variable_3424", "homalg_variable_3425", "homalg_variable_3426", "homalg_variable_3428", "homalg_variable_3429", "homalg_variable_3430", "homalg_variable_3431", "homalg_variable_3432", "homalg_variable_3433", "homalg_variable_3434", "homalg_variable_3441", "homalg_variable_3442", "homalg_variable_3443", "homalg_variable_3445", "homalg_variable_3446", "homalg_variable_3447", "homalg_variable_3448", "homalg_variable_3449", "homalg_variable_3450", "homalg_variable_3451", "homalg_variable_3452", "homalg_variable_3453", "homalg_variable_3455", "homalg_variable_3456", "homalg_variable_3457", "homalg_variable_3458", "homalg_variable_3459", "homalg_variable_3460", "homalg_variable_3464", "homalg_variable_3465", "homalg_variable_3468", "homalg_variable_3469", "homalg_variable_3470", "homalg_variable_3472" ] do UnbindGlobal( _del ); od;;
gap> homalg_variable_3501 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_3500 = homalg_variable_3501;
false
gap> SIH_ZeroColumns(homalg_variable_3500);
[  ]
gap> homalg_variable_3502 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3500,homalg_variable_3393);;
gap> SI_ncols(homalg_variable_3502);
4
gap> homalg_variable_3503 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3502 = homalg_variable_3503;
false
gap> homalg_variable_3505 := homalg_variable_3500 * homalg_variable_3502;;
gap> homalg_variable_3504 := SIH_DecideZeroColumns(homalg_variable_3505,homalg_variable_3393);;
gap> homalg_variable_3506 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_3504 = homalg_variable_3506;
true
gap> homalg_variable_3507 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3500,homalg_variable_3393);;
gap> SI_ncols(homalg_variable_3507);
4
gap> homalg_variable_3508 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3507 = homalg_variable_3508;
false
gap> homalg_variable_3509 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3507);;
gap> SI_ncols(homalg_variable_3509);
1
gap> homalg_variable_3510 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3509 = homalg_variable_3510;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_3509,[ 0 ]);
[  ]
gap> homalg_variable_3511 := SIH_BasisOfColumnModule(homalg_variable_3507);;
gap> SI_ncols(homalg_variable_3511);
4
gap> homalg_variable_3512 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3511 = homalg_variable_3512;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3507);; homalg_variable_3513 := homalg_variable_l[1];; homalg_variable_3514 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3513);
4
gap> homalg_variable_3515 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3513 = homalg_variable_3515;
false
gap> SI_nrows(homalg_variable_3514);
4
gap> homalg_variable_3516 := homalg_variable_3507 * homalg_variable_3514;;
gap> homalg_variable_3513 = homalg_variable_3516;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3511,homalg_variable_3513);; homalg_variable_3517 := homalg_variable_l[1];; homalg_variable_3518 := homalg_variable_l[2];;
gap> homalg_variable_3519 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3517 = homalg_variable_3519;
true
gap> homalg_variable_3520 := homalg_variable_3513 * homalg_variable_3518;;
gap> homalg_variable_3521 := homalg_variable_3511 + homalg_variable_3520;;
gap> homalg_variable_3517 = homalg_variable_3521;
true
gap> homalg_variable_3522 := SIH_DecideZeroColumns(homalg_variable_3511,homalg_variable_3513);;
gap> homalg_variable_3523 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3522 = homalg_variable_3523;
true
gap> homalg_variable_3524 := homalg_variable_3518 * (homalg_variable_8);;
gap> homalg_variable_3525 := homalg_variable_3514 * homalg_variable_3524;;
gap> homalg_variable_3526 := homalg_variable_3507 * homalg_variable_3525;;
gap> homalg_variable_3526 = homalg_variable_3511;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3507,homalg_variable_3511);; homalg_variable_3527 := homalg_variable_l[1];; homalg_variable_3528 := homalg_variable_l[2];;
gap> homalg_variable_3529 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3527 = homalg_variable_3529;
true
gap> homalg_variable_3530 := homalg_variable_3511 * homalg_variable_3528;;
gap> homalg_variable_3531 := homalg_variable_3507 + homalg_variable_3530;;
gap> homalg_variable_3527 = homalg_variable_3531;
true
gap> homalg_variable_3532 := SIH_DecideZeroColumns(homalg_variable_3507,homalg_variable_3511);;
gap> homalg_variable_3533 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3532 = homalg_variable_3533;
true
gap> homalg_variable_3534 := homalg_variable_3528 * (homalg_variable_8);;
gap> homalg_variable_3535 := homalg_variable_3511 * homalg_variable_3534;;
gap> homalg_variable_3535 = homalg_variable_3507;
true
gap> homalg_variable_3536 := SIH_BasisOfColumnModule(homalg_variable_3502);;
gap> SI_ncols(homalg_variable_3536);
4
gap> homalg_variable_3537 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3536 = homalg_variable_3537;
false
gap> homalg_variable_3536 = homalg_variable_3502;
true
gap> homalg_variable_3538 := SIH_DecideZeroColumns(homalg_variable_3507,homalg_variable_3536);;
gap> homalg_variable_3539 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3538 = homalg_variable_3539;
true
gap> homalg_variable_3540 := SIH_BasisOfColumnModule(homalg_variable_572);;
gap> SI_ncols(homalg_variable_3540);
2
gap> homalg_variable_3541 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3540 = homalg_variable_3541;
false
gap> homalg_variable_3542 := SIH_DecideZeroColumns(homalg_variable_618,homalg_variable_3540);;
gap> homalg_variable_3543 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3542 = homalg_variable_3543;
true
gap> homalg_variable_3544 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_572);;
gap> SI_ncols(homalg_variable_3544);
5
gap> homalg_variable_3545 := SI_matrix(homalg_variable_5,7,5,"0");;
gap> homalg_variable_3544 = homalg_variable_3545;
false
gap> homalg_variable_3546 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3544);;
gap> SI_ncols(homalg_variable_3546);
1
gap> homalg_variable_3547 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_3546 = homalg_variable_3547;
true
gap> homalg_variable_3548 := SIH_BasisOfColumnModule(homalg_variable_3544);;
gap> SI_ncols(homalg_variable_3548);
7
gap> homalg_variable_3549 := SI_matrix(homalg_variable_5,7,7,"0");;
gap> homalg_variable_3548 = homalg_variable_3549;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3544);; homalg_variable_3550 := homalg_variable_l[1];; homalg_variable_3551 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3550);
7
gap> homalg_variable_3552 := SI_matrix(homalg_variable_5,7,7,"0");;
gap> homalg_variable_3550 = homalg_variable_3552;
false
gap> SI_nrows(homalg_variable_3551);
5
gap> homalg_variable_3553 := homalg_variable_3544 * homalg_variable_3551;;
gap> homalg_variable_3550 = homalg_variable_3553;
true
gap> homalg_variable_3550 = homalg_variable_1109;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3548,homalg_variable_3550);; homalg_variable_3554 := homalg_variable_l[1];; homalg_variable_3555 := homalg_variable_l[2];;
gap> homalg_variable_3556 := SI_matrix(homalg_variable_5,7,7,"0");;
gap> homalg_variable_3554 = homalg_variable_3556;
true
gap> homalg_variable_3557 := homalg_variable_3550 * homalg_variable_3555;;
gap> homalg_variable_3558 := homalg_variable_3548 + homalg_variable_3557;;
gap> homalg_variable_3554 = homalg_variable_3558;
true
gap> homalg_variable_3559 := SIH_DecideZeroColumns(homalg_variable_3548,homalg_variable_3550);;
gap> homalg_variable_3560 := SI_matrix(homalg_variable_5,7,7,"0");;
gap> homalg_variable_3559 = homalg_variable_3560;
true
gap> homalg_variable_3561 := homalg_variable_3555 * (homalg_variable_8);;
gap> homalg_variable_3562 := homalg_variable_3551 * homalg_variable_3561;;
gap> homalg_variable_3563 := homalg_variable_3544 * homalg_variable_3562;;
gap> homalg_variable_3563 = homalg_variable_3548;
true
gap> homalg_variable_3548 = homalg_variable_1109;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3544,homalg_variable_3548);; homalg_variable_3564 := homalg_variable_l[1];; homalg_variable_3565 := homalg_variable_l[2];;
gap> homalg_variable_3566 := SI_matrix(homalg_variable_5,7,5,"0");;
gap> homalg_variable_3564 = homalg_variable_3566;
true
gap> homalg_variable_3567 := homalg_variable_3548 * homalg_variable_3565;;
gap> homalg_variable_3568 := homalg_variable_3544 + homalg_variable_3567;;
gap> homalg_variable_3564 = homalg_variable_3568;
true
gap> homalg_variable_3569 := SIH_DecideZeroColumns(homalg_variable_3544,homalg_variable_3548);;
gap> homalg_variable_3570 := SI_matrix(homalg_variable_5,7,5,"0");;
gap> homalg_variable_3569 = homalg_variable_3570;
true
gap> homalg_variable_3571 := homalg_variable_3565 * (homalg_variable_8);;
gap> homalg_variable_3572 := homalg_variable_3548 * homalg_variable_3571;;
gap> homalg_variable_3572 = homalg_variable_3544;
true
gap> SIH_ZeroColumns(homalg_variable_3544);
[  ]
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_568,homalg_variable_3550);; homalg_variable_3573 := homalg_variable_l[1];; homalg_variable_3574 := homalg_variable_l[2];;
gap> homalg_variable_3575 := SI_matrix(homalg_variable_5,7,5,"0");;
gap> homalg_variable_3573 = homalg_variable_3575;
true
gap> homalg_variable_3576 := homalg_variable_3550 * homalg_variable_3574;;
gap> homalg_variable_3577 := homalg_variable_568 + homalg_variable_3576;;
gap> homalg_variable_3573 = homalg_variable_3577;
true
gap> homalg_variable_3578 := SIH_DecideZeroColumns(homalg_variable_568,homalg_variable_3550);;
gap> homalg_variable_3579 := SI_matrix(homalg_variable_5,7,5,"0");;
gap> homalg_variable_3578 = homalg_variable_3579;
true
gap> SI_nrows(homalg_variable_3551);
5
gap> SI_ncols(homalg_variable_3551);
7
gap> homalg_variable_3580 := homalg_variable_3574 * (homalg_variable_8);;
gap> homalg_variable_3581 := homalg_variable_3551 * homalg_variable_3580;;
gap> homalg_variable_3582 := homalg_variable_3544 * homalg_variable_3581;;
gap> homalg_variable_3583 := homalg_variable_3582 - homalg_variable_568;;
gap> homalg_variable_3584 := SI_matrix(homalg_variable_5,7,5,"0");;
gap> homalg_variable_3583 = homalg_variable_3584;
true
gap> homalg_variable_3585 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3581);;
gap> SI_ncols(homalg_variable_3585);
1
gap> homalg_variable_3586 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_3585 = homalg_variable_3586;
true
gap> homalg_variable_3587 := SIH_BasisOfColumnModule(homalg_variable_2786);;
gap> SI_ncols(homalg_variable_3587);
2
gap> homalg_variable_3588 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3587 = homalg_variable_3588;
false
gap> homalg_variable_3589 := SIH_DecideZeroColumns(homalg_variable_618,homalg_variable_3587);;
gap> homalg_variable_3590 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3589 = homalg_variable_3590;
true
gap> homalg_variable_3591 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2786);;
gap> SI_ncols(homalg_variable_3591);
8
gap> homalg_variable_3592 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_3591 = homalg_variable_3592;
false
gap> homalg_variable_3593 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3591);;
gap> SI_ncols(homalg_variable_3593);
1
gap> homalg_variable_3594 := SI_matrix(homalg_variable_5,8,1,"0");;
gap> homalg_variable_3593 = homalg_variable_3594;
true
gap> homalg_variable_3595 := SIH_BasisOfColumnModule(homalg_variable_3591);;
gap> SI_ncols(homalg_variable_3595);
12
gap> homalg_variable_3596 := SI_matrix(homalg_variable_5,10,12,"0");;
gap> homalg_variable_3595 = homalg_variable_3596;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3591);; homalg_variable_3597 := homalg_variable_l[1];; homalg_variable_3598 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3597);
12
gap> homalg_variable_3599 := SI_matrix(homalg_variable_5,10,12,"0");;
gap> homalg_variable_3597 = homalg_variable_3599;
false
gap> SI_nrows(homalg_variable_3598);
8
gap> homalg_variable_3600 := homalg_variable_3591 * homalg_variable_3598;;
gap> homalg_variable_3597 = homalg_variable_3600;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3595,homalg_variable_3597);; homalg_variable_3601 := homalg_variable_l[1];; homalg_variable_3602 := homalg_variable_l[2];;
gap> homalg_variable_3603 := SI_matrix(homalg_variable_5,10,12,"0");;
gap> homalg_variable_3601 = homalg_variable_3603;
true
gap> homalg_variable_3604 := homalg_variable_3597 * homalg_variable_3602;;
gap> homalg_variable_3605 := homalg_variable_3595 + homalg_variable_3604;;
gap> homalg_variable_3601 = homalg_variable_3605;
true
gap> homalg_variable_3606 := SIH_DecideZeroColumns(homalg_variable_3595,homalg_variable_3597);;
gap> homalg_variable_3607 := SI_matrix(homalg_variable_5,10,12,"0");;
gap> homalg_variable_3606 = homalg_variable_3607;
true
gap> homalg_variable_3608 := homalg_variable_3602 * (homalg_variable_8);;
gap> homalg_variable_3609 := homalg_variable_3598 * homalg_variable_3608;;
gap> homalg_variable_3610 := homalg_variable_3591 * homalg_variable_3609;;
gap> homalg_variable_3610 = homalg_variable_3595;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3591,homalg_variable_3595);; homalg_variable_3611 := homalg_variable_l[1];; homalg_variable_3612 := homalg_variable_l[2];;
gap> homalg_variable_3613 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_3611 = homalg_variable_3613;
true
gap> homalg_variable_3614 := homalg_variable_3595 * homalg_variable_3612;;
gap> homalg_variable_3615 := homalg_variable_3591 + homalg_variable_3614;;
gap> homalg_variable_3611 = homalg_variable_3615;
true
gap> homalg_variable_3616 := SIH_DecideZeroColumns(homalg_variable_3591,homalg_variable_3595);;
gap> homalg_variable_3617 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_3616 = homalg_variable_3617;
true
gap> homalg_variable_3618 := homalg_variable_3612 * (homalg_variable_8);;
gap> homalg_variable_3619 := homalg_variable_3595 * homalg_variable_3618;;
gap> homalg_variable_3619 = homalg_variable_3591;
true
gap> homalg_variable_3620 := SIH_BasisOfColumnModule(homalg_variable_2873);;
gap> SI_ncols(homalg_variable_3620);
12
gap> homalg_variable_3621 := SI_matrix(homalg_variable_5,10,12,"0");;
gap> homalg_variable_3620 = homalg_variable_3621;
false
gap> homalg_variable_3622 := SIH_DecideZeroColumns(homalg_variable_3591,homalg_variable_3620);;
gap> homalg_variable_3623 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_3622 = homalg_variable_3623;
true
gap> homalg_variable_3624 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2873);;
gap> SI_ncols(homalg_variable_3624);
6
gap> homalg_variable_3625 := SI_matrix(homalg_variable_5,14,6,"0");;
gap> homalg_variable_3624 = homalg_variable_3625;
false
gap> homalg_variable_3626 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3624);;
gap> SI_ncols(homalg_variable_3626);
1
gap> homalg_variable_3627 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_3626 = homalg_variable_3627;
true
gap> homalg_variable_3628 := SIH_BasisOfColumnModule(homalg_variable_3624);;
gap> SI_ncols(homalg_variable_3628);
10
gap> homalg_variable_3629 := SI_matrix(homalg_variable_5,14,10,"0");;
gap> homalg_variable_3628 = homalg_variable_3629;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3624);; homalg_variable_3630 := homalg_variable_l[1];; homalg_variable_3631 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3630);
10
gap> homalg_variable_3632 := SI_matrix(homalg_variable_5,14,10,"0");;
gap> homalg_variable_3630 = homalg_variable_3632;
false
gap> SI_nrows(homalg_variable_3631);
6
gap> homalg_variable_3633 := homalg_variable_3624 * homalg_variable_3631;;
gap> homalg_variable_3630 = homalg_variable_3633;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3628,homalg_variable_3630);; homalg_variable_3634 := homalg_variable_l[1];; homalg_variable_3635 := homalg_variable_l[2];;
gap> homalg_variable_3636 := SI_matrix(homalg_variable_5,14,10,"0");;
gap> homalg_variable_3634 = homalg_variable_3636;
true
gap> homalg_variable_3637 := homalg_variable_3630 * homalg_variable_3635;;
gap> homalg_variable_3638 := homalg_variable_3628 + homalg_variable_3637;;
gap> homalg_variable_3634 = homalg_variable_3638;
true
gap> homalg_variable_3639 := SIH_DecideZeroColumns(homalg_variable_3628,homalg_variable_3630);;
gap> homalg_variable_3640 := SI_matrix(homalg_variable_5,14,10,"0");;
gap> homalg_variable_3639 = homalg_variable_3640;
true
gap> homalg_variable_3641 := homalg_variable_3635 * (homalg_variable_8);;
gap> homalg_variable_3642 := homalg_variable_3631 * homalg_variable_3641;;
gap> homalg_variable_3643 := homalg_variable_3624 * homalg_variable_3642;;
gap> homalg_variable_3643 = homalg_variable_3628;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3624,homalg_variable_3628);; homalg_variable_3644 := homalg_variable_l[1];; homalg_variable_3645 := homalg_variable_l[2];;
gap> homalg_variable_3646 := SI_matrix(homalg_variable_5,14,6,"0");;
gap> homalg_variable_3644 = homalg_variable_3646;
true
gap> homalg_variable_3647 := homalg_variable_3628 * homalg_variable_3645;;
gap> homalg_variable_3648 := homalg_variable_3624 + homalg_variable_3647;;
gap> homalg_variable_3644 = homalg_variable_3648;
true
gap> homalg_variable_3649 := SIH_DecideZeroColumns(homalg_variable_3624,homalg_variable_3628);;
gap> homalg_variable_3650 := SI_matrix(homalg_variable_5,14,6,"0");;
gap> homalg_variable_3649 = homalg_variable_3650;
true
gap> homalg_variable_3651 := homalg_variable_3645 * (homalg_variable_8);;
gap> homalg_variable_3652 := homalg_variable_3628 * homalg_variable_3651;;
gap> homalg_variable_3652 = homalg_variable_3624;
true
gap> SIH_ZeroColumns(homalg_variable_3624);
[  ]
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_990,homalg_variable_3630);; homalg_variable_3653 := homalg_variable_l[1];; homalg_variable_3654 := homalg_variable_l[2];;
gap> homalg_variable_3655 := SI_matrix(homalg_variable_5,14,6,"0");;
gap> homalg_variable_3653 = homalg_variable_3655;
true
gap> homalg_variable_3656 := homalg_variable_3630 * homalg_variable_3654;;
gap> homalg_variable_3657 := homalg_variable_990 + homalg_variable_3656;;
gap> homalg_variable_3653 = homalg_variable_3657;
true
gap> homalg_variable_3658 := SIH_DecideZeroColumns(homalg_variable_990,homalg_variable_3630);;
gap> homalg_variable_3659 := SI_matrix(homalg_variable_5,14,6,"0");;
gap> homalg_variable_3658 = homalg_variable_3659;
true
gap> SI_nrows(homalg_variable_3631);
6
gap> SI_ncols(homalg_variable_3631);
10
gap> homalg_variable_3660 := homalg_variable_3654 * (homalg_variable_8);;
gap> homalg_variable_3661 := homalg_variable_3631 * homalg_variable_3660;;
gap> homalg_variable_3662 := homalg_variable_3624 * homalg_variable_3661;;
gap> homalg_variable_3663 := homalg_variable_3662 - homalg_variable_990;;
gap> homalg_variable_3664 := SI_matrix(homalg_variable_5,14,6,"0");;
gap> homalg_variable_3663 = homalg_variable_3664;
true
gap> homalg_variable_3665 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3661);;
gap> SI_ncols(homalg_variable_3665);
1
gap> homalg_variable_3666 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_3665 = homalg_variable_3666;
true
gap> homalg_variable_3667 := SIH_BasisOfColumnModule(homalg_variable_2119);;
gap> SI_ncols(homalg_variable_3667);
1
gap> homalg_variable_3668 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3667 = homalg_variable_3668;
false
gap> homalg_variable_3669 := SIH_DecideZeroColumns(homalg_variable_860,homalg_variable_3667);;
gap> homalg_variable_3670 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3669 = homalg_variable_3670;
true
gap> homalg_variable_3671 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2119);;
gap> SI_ncols(homalg_variable_3671);
4
gap> homalg_variable_3672 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3671 = homalg_variable_3672;
false
gap> homalg_variable_3673 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3671);;
gap> SI_ncols(homalg_variable_3673);
1
gap> homalg_variable_3674 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3673 = homalg_variable_3674;
true
gap> homalg_variable_3675 := SIH_BasisOfColumnModule(homalg_variable_3671);;
gap> SI_ncols(homalg_variable_3675);
7
gap> homalg_variable_3676 := SI_matrix(homalg_variable_5,5,7,"0");;
gap> homalg_variable_3675 = homalg_variable_3676;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3671);; homalg_variable_3677 := homalg_variable_l[1];; homalg_variable_3678 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3677);
7
gap> homalg_variable_3679 := SI_matrix(homalg_variable_5,5,7,"0");;
gap> homalg_variable_3677 = homalg_variable_3679;
false
gap> SI_nrows(homalg_variable_3678);
4
gap> homalg_variable_3680 := homalg_variable_3671 * homalg_variable_3678;;
gap> homalg_variable_3677 = homalg_variable_3680;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3675,homalg_variable_3677);; homalg_variable_3681 := homalg_variable_l[1];; homalg_variable_3682 := homalg_variable_l[2];;
gap> homalg_variable_3683 := SI_matrix(homalg_variable_5,5,7,"0");;
gap> homalg_variable_3681 = homalg_variable_3683;
true
gap> homalg_variable_3684 := homalg_variable_3677 * homalg_variable_3682;;
gap> homalg_variable_3685 := homalg_variable_3675 + homalg_variable_3684;;
gap> homalg_variable_3681 = homalg_variable_3685;
true
gap> homalg_variable_3686 := SIH_DecideZeroColumns(homalg_variable_3675,homalg_variable_3677);;
gap> homalg_variable_3687 := SI_matrix(homalg_variable_5,5,7,"0");;
gap> homalg_variable_3686 = homalg_variable_3687;
true
gap> homalg_variable_3688 := homalg_variable_3682 * (homalg_variable_8);;
gap> homalg_variable_3689 := homalg_variable_3678 * homalg_variable_3688;;
gap> homalg_variable_3690 := homalg_variable_3671 * homalg_variable_3689;;
gap> homalg_variable_3690 = homalg_variable_3675;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3671,homalg_variable_3675);; homalg_variable_3691 := homalg_variable_l[1];; homalg_variable_3692 := homalg_variable_l[2];;
gap> homalg_variable_3693 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3691 = homalg_variable_3693;
true
gap> homalg_variable_3694 := homalg_variable_3675 * homalg_variable_3692;;
gap> homalg_variable_3695 := homalg_variable_3671 + homalg_variable_3694;;
gap> homalg_variable_3691 = homalg_variable_3695;
true
gap> homalg_variable_3696 := SIH_DecideZeroColumns(homalg_variable_3671,homalg_variable_3675);;
gap> homalg_variable_3697 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3696 = homalg_variable_3697;
true
gap> homalg_variable_3698 := homalg_variable_3692 * (homalg_variable_8);;
gap> homalg_variable_3699 := homalg_variable_3675 * homalg_variable_3698;;
gap> homalg_variable_3699 = homalg_variable_3671;
true
gap> homalg_variable_3700 := SIH_BasisOfColumnModule(homalg_variable_2023);;
gap> SI_ncols(homalg_variable_3700);
7
gap> homalg_variable_3701 := SI_matrix(homalg_variable_5,5,7,"0");;
gap> homalg_variable_3700 = homalg_variable_3701;
false
gap> homalg_variable_3702 := SIH_DecideZeroColumns(homalg_variable_3671,homalg_variable_3700);;
gap> homalg_variable_3703 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3702 = homalg_variable_3703;
true
gap> homalg_variable_3704 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2023);;
gap> SI_ncols(homalg_variable_3704);
9
gap> homalg_variable_3705 := SI_matrix(homalg_variable_5,10,9,"0");;
gap> homalg_variable_3704 = homalg_variable_3705;
false
gap> homalg_variable_3706 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3704);;
gap> SI_ncols(homalg_variable_3706);
4
gap> homalg_variable_3707 := SI_matrix(homalg_variable_5,9,4,"0");;
gap> homalg_variable_3706 = homalg_variable_3707;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_3706,[ 0 ]);
[ [ 2, 3 ], [ 3, 2 ], [ 4, 4 ] ]
gap> homalg_variable_3709 := SIH_Submatrix(homalg_variable_3704,[1..10],[ 1, 5, 6, 7, 8, 9 ]);;
gap> homalg_variable_3708 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3709);;
gap> SI_ncols(homalg_variable_3708);
1
gap> homalg_variable_3710 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_3708 = homalg_variable_3710;
true
gap> homalg_variable_3711 := SIH_BasisOfColumnModule(homalg_variable_3704);;
gap> SI_ncols(homalg_variable_3711);
10
gap> homalg_variable_3712 := SI_matrix(homalg_variable_5,10,10,"0");;
gap> homalg_variable_3711 = homalg_variable_3712;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3709);; homalg_variable_3713 := homalg_variable_l[1];; homalg_variable_3714 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3713);
10
gap> homalg_variable_3715 := SI_matrix(homalg_variable_5,10,10,"0");;
gap> homalg_variable_3713 = homalg_variable_3715;
false
gap> SI_nrows(homalg_variable_3714);
6
gap> homalg_variable_3716 := homalg_variable_3709 * homalg_variable_3714;;
gap> homalg_variable_3713 = homalg_variable_3716;
true
gap> homalg_variable_3717 := SI_matrix(SI_freemodule(homalg_variable_5,10));;
gap> homalg_variable_3713 = homalg_variable_3717;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3711,homalg_variable_3713);; homalg_variable_3718 := homalg_variable_l[1];; homalg_variable_3719 := homalg_variable_l[2];;
gap> homalg_variable_3720 := SI_matrix(homalg_variable_5,10,10,"0");;
gap> homalg_variable_3718 = homalg_variable_3720;
true
gap> homalg_variable_3721 := homalg_variable_3713 * homalg_variable_3719;;
gap> homalg_variable_3722 := homalg_variable_3711 + homalg_variable_3721;;
gap> homalg_variable_3718 = homalg_variable_3722;
true
gap> homalg_variable_3723 := SIH_DecideZeroColumns(homalg_variable_3711,homalg_variable_3713);;
gap> homalg_variable_3724 := SI_matrix(homalg_variable_5,10,10,"0");;
gap> homalg_variable_3723 = homalg_variable_3724;
true
gap> homalg_variable_3725 := homalg_variable_3719 * (homalg_variable_8);;
gap> homalg_variable_3726 := homalg_variable_3714 * homalg_variable_3725;;
gap> homalg_variable_3727 := homalg_variable_3709 * homalg_variable_3726;;
gap> homalg_variable_3727 = homalg_variable_3711;
true
gap> homalg_variable_3728 := SI_matrix(SI_freemodule(homalg_variable_5,10));;
gap> homalg_variable_3711 = homalg_variable_3728;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3709,homalg_variable_3711);; homalg_variable_3729 := homalg_variable_l[1];; homalg_variable_3730 := homalg_variable_l[2];;
gap> homalg_variable_3731 := SI_matrix(homalg_variable_5,10,6,"0");;
gap> homalg_variable_3729 = homalg_variable_3731;
true
gap> homalg_variable_3732 := homalg_variable_3711 * homalg_variable_3730;;
gap> homalg_variable_3733 := homalg_variable_3709 + homalg_variable_3732;;
gap> homalg_variable_3729 = homalg_variable_3733;
true
gap> homalg_variable_3734 := SIH_DecideZeroColumns(homalg_variable_3709,homalg_variable_3711);;
gap> homalg_variable_3735 := SI_matrix(homalg_variable_5,10,6,"0");;
gap> homalg_variable_3734 = homalg_variable_3735;
true
gap> homalg_variable_3736 := homalg_variable_3730 * (homalg_variable_8);;
gap> homalg_variable_3737 := homalg_variable_3711 * homalg_variable_3736;;
gap> homalg_variable_3737 = homalg_variable_3709;
true
gap> homalg_variable_3738 := SIH_BasisOfColumnModule(homalg_variable_1906);;
gap> SI_ncols(homalg_variable_3738);
10
gap> homalg_variable_3739 := SI_matrix(homalg_variable_5,10,10,"0");;
gap> homalg_variable_3738 = homalg_variable_3739;
false
gap> homalg_variable_3738 = homalg_variable_1906;
false
gap> homalg_variable_3740 := SIH_DecideZeroColumns(homalg_variable_3709,homalg_variable_3738);;
gap> homalg_variable_3741 := SI_matrix(homalg_variable_5,10,6,"0");;
gap> homalg_variable_3740 = homalg_variable_3741;
true
gap> homalg_variable_3742 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_1906);;
gap> SI_ncols(homalg_variable_3742);
5
gap> homalg_variable_3743 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_3742 = homalg_variable_3743;
false
gap> homalg_variable_3744 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3742);;
gap> SI_ncols(homalg_variable_3744);
1
gap> homalg_variable_3745 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_3744 = homalg_variable_3745;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_3744,[ 0 ]);
[ [ 1, 3 ] ]
gap> homalg_variable_3747 := SIH_Submatrix(homalg_variable_3742,[1..10],[ 1, 2, 4, 5 ]);;
gap> homalg_variable_3746 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3747);;
gap> SI_ncols(homalg_variable_3746);
1
gap> homalg_variable_3748 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3746 = homalg_variable_3748;
true
gap> homalg_variable_3749 := SIH_BasisOfColumnModule(homalg_variable_3742);;
gap> SI_ncols(homalg_variable_3749);
5
gap> homalg_variable_3750 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_3749 = homalg_variable_3750;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3747);; homalg_variable_3751 := homalg_variable_l[1];; homalg_variable_3752 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3751);
5
gap> homalg_variable_3753 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_3751 = homalg_variable_3753;
false
gap> SI_nrows(homalg_variable_3752);
4
gap> homalg_variable_3754 := homalg_variable_3747 * homalg_variable_3752;;
gap> homalg_variable_3751 = homalg_variable_3754;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3749,homalg_variable_3751);; homalg_variable_3755 := homalg_variable_l[1];; homalg_variable_3756 := homalg_variable_l[2];;
gap> homalg_variable_3757 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_3755 = homalg_variable_3757;
true
gap> homalg_variable_3758 := homalg_variable_3751 * homalg_variable_3756;;
gap> homalg_variable_3759 := homalg_variable_3749 + homalg_variable_3758;;
gap> homalg_variable_3755 = homalg_variable_3759;
true
gap> homalg_variable_3760 := SIH_DecideZeroColumns(homalg_variable_3749,homalg_variable_3751);;
gap> homalg_variable_3761 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_3760 = homalg_variable_3761;
true
gap> homalg_variable_3762 := homalg_variable_3756 * (homalg_variable_8);;
gap> homalg_variable_3763 := homalg_variable_3752 * homalg_variable_3762;;
gap> homalg_variable_3764 := homalg_variable_3747 * homalg_variable_3763;;
gap> homalg_variable_3764 = homalg_variable_3749;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3747,homalg_variable_3749);; homalg_variable_3765 := homalg_variable_l[1];; homalg_variable_3766 := homalg_variable_l[2];;
gap> homalg_variable_3767 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_3765 = homalg_variable_3767;
true
gap> homalg_variable_3768 := homalg_variable_3749 * homalg_variable_3766;;
gap> homalg_variable_3769 := homalg_variable_3747 + homalg_variable_3768;;
gap> homalg_variable_3765 = homalg_variable_3769;
true
gap> homalg_variable_3770 := SIH_DecideZeroColumns(homalg_variable_3747,homalg_variable_3749);;
gap> homalg_variable_3771 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_3770 = homalg_variable_3771;
true
gap> homalg_variable_3772 := homalg_variable_3766 * (homalg_variable_8);;
gap> homalg_variable_3773 := homalg_variable_3749 * homalg_variable_3772;;
gap> homalg_variable_3773 = homalg_variable_3747;
true
gap> SIH_ZeroColumns(homalg_variable_3747);
[  ]
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_1762,homalg_variable_3751);; homalg_variable_3774 := homalg_variable_l[1];; homalg_variable_3775 := homalg_variable_l[2];;
gap> homalg_variable_3776 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_3774 = homalg_variable_3776;
true
gap> homalg_variable_3777 := homalg_variable_3751 * homalg_variable_3775;;
gap> homalg_variable_3778 := homalg_variable_1762 + homalg_variable_3777;;
gap> homalg_variable_3774 = homalg_variable_3778;
true
gap> homalg_variable_3779 := SIH_DecideZeroColumns(homalg_variable_1762,homalg_variable_3751);;
gap> homalg_variable_3780 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_3779 = homalg_variable_3780;
true
gap> SI_nrows(homalg_variable_3752);
4
gap> SI_ncols(homalg_variable_3752);
5
gap> homalg_variable_3781 := homalg_variable_3775 * (homalg_variable_8);;
gap> homalg_variable_3782 := homalg_variable_3752 * homalg_variable_3781;;
gap> homalg_variable_3783 := homalg_variable_3747 * homalg_variable_3782;;
gap> homalg_variable_3784 := homalg_variable_3783 - homalg_variable_1762;;
gap> homalg_variable_3785 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_3784 = homalg_variable_3785;
true
gap> homalg_variable_3786 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3782);;
gap> SI_ncols(homalg_variable_3786);
1
gap> homalg_variable_3787 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3786 = homalg_variable_3787;
true
gap> homalg_variable_3788 := SIH_BasisOfColumnModule(homalg_variable_2960);;
gap> SI_ncols(homalg_variable_3788);
1
gap> homalg_variable_3789 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3788 = homalg_variable_3789;
false
gap> homalg_variable_3790 := SIH_DecideZeroColumns(homalg_variable_860,homalg_variable_3788);;
gap> homalg_variable_3791 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3790 = homalg_variable_3791;
true
gap> homalg_variable_3792 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2960);;
gap> SI_ncols(homalg_variable_3792);
3
gap> homalg_variable_3793 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_3792 = homalg_variable_3793;
false
gap> homalg_variable_3794 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3792);;
gap> SI_ncols(homalg_variable_3794);
1
gap> homalg_variable_3795 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3794 = homalg_variable_3795;
true
gap> homalg_variable_3796 := SIH_BasisOfColumnModule(homalg_variable_3792);;
gap> SI_ncols(homalg_variable_3796);
6
gap> homalg_variable_3797 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_3796 = homalg_variable_3797;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3792);; homalg_variable_3798 := homalg_variable_l[1];; homalg_variable_3799 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3798);
6
gap> homalg_variable_3800 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_3798 = homalg_variable_3800;
false
gap> SI_nrows(homalg_variable_3799);
3
gap> homalg_variable_3801 := homalg_variable_3792 * homalg_variable_3799;;
gap> homalg_variable_3798 = homalg_variable_3801;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3796,homalg_variable_3798);; homalg_variable_3802 := homalg_variable_l[1];; homalg_variable_3803 := homalg_variable_l[2];;
gap> homalg_variable_3804 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_3802 = homalg_variable_3804;
true
gap> homalg_variable_3805 := homalg_variable_3798 * homalg_variable_3803;;
gap> homalg_variable_3806 := homalg_variable_3796 + homalg_variable_3805;;
gap> homalg_variable_3802 = homalg_variable_3806;
true
gap> homalg_variable_3807 := SIH_DecideZeroColumns(homalg_variable_3796,homalg_variable_3798);;
gap> homalg_variable_3808 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_3807 = homalg_variable_3808;
true
gap> homalg_variable_3809 := homalg_variable_3803 * (homalg_variable_8);;
gap> homalg_variable_3810 := homalg_variable_3799 * homalg_variable_3809;;
gap> homalg_variable_3811 := homalg_variable_3792 * homalg_variable_3810;;
gap> homalg_variable_3811 = homalg_variable_3796;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3792,homalg_variable_3796);; homalg_variable_3812 := homalg_variable_l[1];; homalg_variable_3813 := homalg_variable_l[2];;
gap> homalg_variable_3814 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_3812 = homalg_variable_3814;
true
gap> homalg_variable_3815 := homalg_variable_3796 * homalg_variable_3813;;
gap> homalg_variable_3816 := homalg_variable_3792 + homalg_variable_3815;;
gap> homalg_variable_3812 = homalg_variable_3816;
true
gap> homalg_variable_3817 := SIH_DecideZeroColumns(homalg_variable_3792,homalg_variable_3796);;
gap> homalg_variable_3818 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_3817 = homalg_variable_3818;
true
gap> homalg_variable_3819 := homalg_variable_3813 * (homalg_variable_8);;
gap> homalg_variable_3820 := homalg_variable_3796 * homalg_variable_3819;;
gap> homalg_variable_3820 = homalg_variable_3792;
true
gap> homalg_variable_3821 := SIH_BasisOfColumnModule(homalg_variable_2846);;
gap> SI_ncols(homalg_variable_3821);
6
gap> homalg_variable_3822 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_3821 = homalg_variable_3822;
false
gap> homalg_variable_3821 = homalg_variable_2846;
false
gap> homalg_variable_3823 := SIH_DecideZeroColumns(homalg_variable_3792,homalg_variable_3821);;
gap> homalg_variable_3824 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_3823 = homalg_variable_3824;
true
gap> homalg_variable_3825 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2846);;
gap> SI_ncols(homalg_variable_3825);
3
gap> homalg_variable_3826 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_3825 = homalg_variable_3826;
false
gap> homalg_variable_3827 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3825);;
gap> SI_ncols(homalg_variable_3827);
1
gap> homalg_variable_3828 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3827 = homalg_variable_3828;
true
gap> homalg_variable_3829 := SIH_BasisOfColumnModule(homalg_variable_3825);;
gap> SI_ncols(homalg_variable_3829);
4
gap> homalg_variable_3830 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_3829 = homalg_variable_3830;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3825);; homalg_variable_3831 := homalg_variable_l[1];; homalg_variable_3832 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3831);
4
gap> homalg_variable_3833 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_3831 = homalg_variable_3833;
false
gap> SI_nrows(homalg_variable_3832);
3
gap> homalg_variable_3834 := homalg_variable_3825 * homalg_variable_3832;;
gap> homalg_variable_3831 = homalg_variable_3834;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3829,homalg_variable_3831);; homalg_variable_3835 := homalg_variable_l[1];; homalg_variable_3836 := homalg_variable_l[2];;
gap> homalg_variable_3837 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_3835 = homalg_variable_3837;
true
gap> homalg_variable_3838 := homalg_variable_3831 * homalg_variable_3836;;
gap> homalg_variable_3839 := homalg_variable_3829 + homalg_variable_3838;;
gap> homalg_variable_3835 = homalg_variable_3839;
true
gap> homalg_variable_3840 := SIH_DecideZeroColumns(homalg_variable_3829,homalg_variable_3831);;
gap> homalg_variable_3841 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_3840 = homalg_variable_3841;
true
gap> homalg_variable_3842 := homalg_variable_3836 * (homalg_variable_8);;
gap> homalg_variable_3843 := homalg_variable_3832 * homalg_variable_3842;;
gap> homalg_variable_3844 := homalg_variable_3825 * homalg_variable_3843;;
gap> homalg_variable_3844 = homalg_variable_3829;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3825,homalg_variable_3829);; homalg_variable_3845 := homalg_variable_l[1];; homalg_variable_3846 := homalg_variable_l[2];;
gap> homalg_variable_3847 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_3845 = homalg_variable_3847;
true
gap> homalg_variable_3848 := homalg_variable_3829 * homalg_variable_3846;;
gap> homalg_variable_3849 := homalg_variable_3825 + homalg_variable_3848;;
gap> homalg_variable_3845 = homalg_variable_3849;
true
gap> homalg_variable_3850 := SIH_DecideZeroColumns(homalg_variable_3825,homalg_variable_3829);;
gap> homalg_variable_3851 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_3850 = homalg_variable_3851;
true
gap> homalg_variable_3852 := homalg_variable_3846 * (homalg_variable_8);;
gap> homalg_variable_3853 := homalg_variable_3829 * homalg_variable_3852;;
gap> homalg_variable_3853 = homalg_variable_3825;
true
gap> homalg_variable_3854 := SIH_BasisOfColumnModule(homalg_variable_2940);;
gap> SI_ncols(homalg_variable_3854);
4
gap> homalg_variable_3855 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_3854 = homalg_variable_3855;
false
gap> homalg_variable_3854 = homalg_variable_2940;
false
gap> homalg_variable_3856 := SIH_DecideZeroColumns(homalg_variable_3825,homalg_variable_3854);;
gap> homalg_variable_3857 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_3856 = homalg_variable_3857;
true
gap> homalg_variable_3858 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2940);;
gap> SI_ncols(homalg_variable_3858);
1
gap> homalg_variable_3859 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3858 = homalg_variable_3859;
false
gap> homalg_variable_3860 := SIH_BasisOfColumnModule(homalg_variable_3858);;
gap> SI_ncols(homalg_variable_3860);
1
gap> homalg_variable_3861 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3860 = homalg_variable_3861;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3858);; homalg_variable_3862 := homalg_variable_l[1];; homalg_variable_3863 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3862);
1
gap> homalg_variable_3864 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3862 = homalg_variable_3864;
false
gap> SI_nrows(homalg_variable_3863);
1
gap> homalg_variable_3865 := homalg_variable_3858 * homalg_variable_3863;;
gap> homalg_variable_3862 = homalg_variable_3865;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3860,homalg_variable_3862);; homalg_variable_3866 := homalg_variable_l[1];; homalg_variable_3867 := homalg_variable_l[2];;
gap> homalg_variable_3868 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3866 = homalg_variable_3868;
true
gap> homalg_variable_3869 := homalg_variable_3862 * homalg_variable_3867;;
gap> homalg_variable_3870 := homalg_variable_3860 + homalg_variable_3869;;
gap> homalg_variable_3866 = homalg_variable_3870;
true
gap> homalg_variable_3871 := SIH_DecideZeroColumns(homalg_variable_3860,homalg_variable_3862);;
gap> homalg_variable_3872 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3871 = homalg_variable_3872;
true
gap> homalg_variable_3873 := homalg_variable_3867 * (homalg_variable_8);;
gap> homalg_variable_3874 := homalg_variable_3863 * homalg_variable_3873;;
gap> homalg_variable_3875 := homalg_variable_3858 * homalg_variable_3874;;
gap> homalg_variable_3875 = homalg_variable_3860;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3858,homalg_variable_3860);; homalg_variable_3876 := homalg_variable_l[1];; homalg_variable_3877 := homalg_variable_l[2];;
gap> homalg_variable_3878 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3876 = homalg_variable_3878;
true
gap> homalg_variable_3879 := homalg_variable_3860 * homalg_variable_3877;;
gap> homalg_variable_3880 := homalg_variable_3858 + homalg_variable_3879;;
gap> homalg_variable_3876 = homalg_variable_3880;
true
gap> homalg_variable_3881 := SIH_DecideZeroColumns(homalg_variable_3858,homalg_variable_3860);;
gap> homalg_variable_3882 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3881 = homalg_variable_3882;
true
gap> homalg_variable_3883 := homalg_variable_3877 * (homalg_variable_8);;
gap> homalg_variable_3884 := homalg_variable_3860 * homalg_variable_3883;;
gap> homalg_variable_3884 = homalg_variable_3858;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2125,homalg_variable_3862);; homalg_variable_3885 := homalg_variable_l[1];; homalg_variable_3886 := homalg_variable_l[2];;
gap> homalg_variable_3887 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3885 = homalg_variable_3887;
true
gap> homalg_variable_3888 := homalg_variable_3862 * homalg_variable_3886;;
gap> homalg_variable_3889 := homalg_variable_2125 + homalg_variable_3888;;
gap> homalg_variable_3885 = homalg_variable_3889;
true
gap> homalg_variable_3890 := SIH_DecideZeroColumns(homalg_variable_2125,homalg_variable_3862);;
gap> homalg_variable_3891 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3890 = homalg_variable_3891;
true
gap> SI_nrows(homalg_variable_3863);
1
gap> SI_ncols(homalg_variable_3863);
1
gap> homalg_variable_3892 := homalg_variable_3886 * (homalg_variable_8);;
gap> homalg_variable_3893 := homalg_variable_3863 * homalg_variable_3892;;
gap> homalg_variable_3894 := homalg_variable_3858 * homalg_variable_3893;;
gap> homalg_variable_3895 := homalg_variable_3894 - homalg_variable_2125;;
gap> homalg_variable_3896 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3895 = homalg_variable_3896;
true
gap> homalg_variable_3897 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3893);;
gap> SI_ncols(homalg_variable_3897);
1
gap> homalg_variable_3898 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3897 = homalg_variable_3898;
true
gap> homalg_variable_3899 := SI_matrix(homalg_variable_5,2,6,"0");;
gap> homalg_variable_3900 := SIH_Submatrix(homalg_variable_3624,[ 1, 2, 3, 4, 5 ],[1..6]);;
gap> homalg_variable_3901 := SIH_UnionOfRows(homalg_variable_3899,homalg_variable_3900);;
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3901,homalg_variable_3550);; homalg_variable_3902 := homalg_variable_l[1];; homalg_variable_3903 := homalg_variable_l[2];;
gap> homalg_variable_3904 := SI_matrix(homalg_variable_5,7,6,"0");;
gap> homalg_variable_3902 = homalg_variable_3904;
true
gap> homalg_variable_3905 := homalg_variable_3550 * homalg_variable_3903;;
gap> homalg_variable_3906 := homalg_variable_3901 + homalg_variable_3905;;
gap> homalg_variable_3902 = homalg_variable_3906;
true
gap> homalg_variable_3907 := SIH_DecideZeroColumns(homalg_variable_3901,homalg_variable_3550);;
gap> homalg_variable_3908 := SI_matrix(homalg_variable_5,7,6,"0");;
gap> homalg_variable_3907 = homalg_variable_3908;
true
gap> SI_nrows(homalg_variable_3551);
5
gap> SI_ncols(homalg_variable_3551);
7
gap> homalg_variable_3909 := homalg_variable_3903 * (homalg_variable_8);;
gap> homalg_variable_3910 := homalg_variable_3551 * homalg_variable_3909;;
gap> homalg_variable_3911 := homalg_variable_3544 * homalg_variable_3910;;
gap> homalg_variable_3912 := homalg_variable_3911 - homalg_variable_3901;;
gap> homalg_variable_3913 := SI_matrix(homalg_variable_5,7,6,"0");;
gap> homalg_variable_3912 = homalg_variable_3913;
true
gap> homalg_variable_3914 := SI_matrix(homalg_variable_5,9,4,"0");;
gap> homalg_variable_3915 := SIH_Submatrix(homalg_variable_3747,[ 1, 2, 3, 4, 5 ],[1..4]);;
gap> homalg_variable_3916 := SIH_UnionOfRows(homalg_variable_3914,homalg_variable_3915);;
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3916,homalg_variable_3630);; homalg_variable_3917 := homalg_variable_l[1];; homalg_variable_3918 := homalg_variable_l[2];;
gap> homalg_variable_3919 := SI_matrix(homalg_variable_5,14,4,"0");;
gap> homalg_variable_3917 = homalg_variable_3919;
true
gap> homalg_variable_3920 := homalg_variable_3630 * homalg_variable_3918;;
gap> homalg_variable_3921 := homalg_variable_3916 + homalg_variable_3920;;
gap> homalg_variable_3917 = homalg_variable_3921;
true
gap> homalg_variable_3922 := SIH_DecideZeroColumns(homalg_variable_3916,homalg_variable_3630);;
gap> homalg_variable_3923 := SI_matrix(homalg_variable_5,14,4,"0");;
gap> homalg_variable_3922 = homalg_variable_3923;
true
gap> SI_nrows(homalg_variable_3631);
6
gap> SI_ncols(homalg_variable_3631);
10
gap> homalg_variable_3924 := homalg_variable_3918 * (homalg_variable_8);;
gap> homalg_variable_3925 := homalg_variable_3631 * homalg_variable_3924;;
gap> homalg_variable_3926 := homalg_variable_3624 * homalg_variable_3925;;
gap> homalg_variable_3927 := homalg_variable_3926 - homalg_variable_3916;;
gap> homalg_variable_3928 := SI_matrix(homalg_variable_5,14,4,"0");;
gap> homalg_variable_3927 = homalg_variable_3928;
true
gap> homalg_variable_3929 := SI_matrix(homalg_variable_5,7,1,"0");;
gap> homalg_variable_3930 := SIH_Submatrix(homalg_variable_3858,[ 1, 2, 3 ],[1..1]);;
gap> homalg_variable_3931 := SIH_UnionOfRows(homalg_variable_3929,homalg_variable_3930);;
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3931,homalg_variable_3751);; homalg_variable_3932 := homalg_variable_l[1];; homalg_variable_3933 := homalg_variable_l[2];;
gap> homalg_variable_3934 := SI_matrix(homalg_variable_5,10,1,"0");;
gap> homalg_variable_3932 = homalg_variable_3934;
true
gap> homalg_variable_3935 := homalg_variable_3751 * homalg_variable_3933;;
gap> homalg_variable_3936 := homalg_variable_3931 + homalg_variable_3935;;
gap> homalg_variable_3932 = homalg_variable_3936;
true
gap> homalg_variable_3937 := SIH_DecideZeroColumns(homalg_variable_3931,homalg_variable_3751);;
gap> homalg_variable_3938 := SI_matrix(homalg_variable_5,10,1,"0");;
gap> homalg_variable_3937 = homalg_variable_3938;
true
gap> SI_nrows(homalg_variable_3752);
4
gap> SI_ncols(homalg_variable_3752);
5
gap> homalg_variable_3939 := homalg_variable_3933 * (homalg_variable_8);;
gap> homalg_variable_3940 := homalg_variable_3752 * homalg_variable_3939;;
gap> homalg_variable_3941 := homalg_variable_3747 * homalg_variable_3940;;
gap> homalg_variable_3942 := homalg_variable_3941 - homalg_variable_3931;;
gap> homalg_variable_3943 := SI_matrix(homalg_variable_5,10,1,"0");;
gap> homalg_variable_3942 = homalg_variable_3943;
true
gap> homalg_variable_3944 := SIH_BasisOfColumnModule(homalg_variable_3910);;
gap> SI_ncols(homalg_variable_3944);
6
gap> homalg_variable_3945 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_3944 = homalg_variable_3945;
false
gap> homalg_variable_3944 = homalg_variable_3910;
false
gap> homalg_variable_3946 := SIH_DecideZeroColumns(homalg_variable_18,homalg_variable_3944);;
gap> homalg_variable_3947 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_3946 = homalg_variable_3947;
false
gap> SIH_ZeroColumns(homalg_variable_3946);
[  ]
gap> homalg_variable_3948 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3910);;
gap> SI_ncols(homalg_variable_3948);
4
gap> homalg_variable_3949 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_3948 = homalg_variable_3949;
false
gap> homalg_variable_3950 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3948);;
gap> SI_ncols(homalg_variable_3950);
1
gap> homalg_variable_3951 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3950 = homalg_variable_3951;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_3950,[ 0 ]);
[  ]
gap> homalg_variable_3952 := SIH_BasisOfColumnModule(homalg_variable_3948);;
gap> SI_ncols(homalg_variable_3952);
4
gap> homalg_variable_3953 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_3952 = homalg_variable_3953;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3948);; homalg_variable_3954 := homalg_variable_l[1];; homalg_variable_3955 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3954);
4
gap> homalg_variable_3956 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_3954 = homalg_variable_3956;
false
gap> SI_nrows(homalg_variable_3955);
4
gap> homalg_variable_3957 := homalg_variable_3948 * homalg_variable_3955;;
gap> homalg_variable_3954 = homalg_variable_3957;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3952,homalg_variable_3954);; homalg_variable_3958 := homalg_variable_l[1];; homalg_variable_3959 := homalg_variable_l[2];;
gap> homalg_variable_3960 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_3958 = homalg_variable_3960;
true
gap> homalg_variable_3961 := homalg_variable_3954 * homalg_variable_3959;;
gap> homalg_variable_3962 := homalg_variable_3952 + homalg_variable_3961;;
gap> homalg_variable_3958 = homalg_variable_3962;
true
gap> homalg_variable_3963 := SIH_DecideZeroColumns(homalg_variable_3952,homalg_variable_3954);;
gap> homalg_variable_3964 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_3963 = homalg_variable_3964;
true
gap> homalg_variable_3965 := homalg_variable_3959 * (homalg_variable_8);;
gap> homalg_variable_3966 := homalg_variable_3955 * homalg_variable_3965;;
gap> homalg_variable_3967 := homalg_variable_3948 * homalg_variable_3966;;
gap> homalg_variable_3967 = homalg_variable_3952;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3948,homalg_variable_3952);; homalg_variable_3968 := homalg_variable_l[1];; homalg_variable_3969 := homalg_variable_l[2];;
gap> homalg_variable_3970 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_3968 = homalg_variable_3970;
true
gap> homalg_variable_3971 := homalg_variable_3952 * homalg_variable_3969;;
gap> homalg_variable_3972 := homalg_variable_3948 + homalg_variable_3971;;
gap> homalg_variable_3968 = homalg_variable_3972;
true
gap> homalg_variable_3973 := SIH_DecideZeroColumns(homalg_variable_3948,homalg_variable_3952);;
gap> homalg_variable_3974 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_3973 = homalg_variable_3974;
true
gap> homalg_variable_3975 := homalg_variable_3969 * (homalg_variable_8);;
gap> homalg_variable_3976 := homalg_variable_3952 * homalg_variable_3975;;
gap> homalg_variable_3976 = homalg_variable_3948;
true
gap> homalg_variable_3977 := SIH_BasisOfColumnModule(homalg_variable_3925);;
gap> SI_ncols(homalg_variable_3977);
4
gap> homalg_variable_3978 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_3977 = homalg_variable_3978;
false
gap> homalg_variable_3977 = homalg_variable_3925;
true
gap> homalg_variable_3979 := SIH_DecideZeroColumns(homalg_variable_3948,homalg_variable_3977);;
gap> homalg_variable_3980 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_3979 = homalg_variable_3980;
true
gap> homalg_variable_3981 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3925);;
gap> SI_ncols(homalg_variable_3981);
1
gap> homalg_variable_3982 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3981 = homalg_variable_3982;
false
gap> homalg_variable_3983 := SIH_BasisOfColumnModule(homalg_variable_3981);;
gap> SI_ncols(homalg_variable_3983);
1
gap> homalg_variable_3984 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3983 = homalg_variable_3984;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3981);; homalg_variable_3985 := homalg_variable_l[1];; homalg_variable_3986 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3985);
1
gap> homalg_variable_3987 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3985 = homalg_variable_3987;
false
gap> SI_nrows(homalg_variable_3986);
1
gap> homalg_variable_3988 := homalg_variable_3981 * homalg_variable_3986;;
gap> homalg_variable_3985 = homalg_variable_3988;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3983,homalg_variable_3985);; homalg_variable_3989 := homalg_variable_l[1];; homalg_variable_3990 := homalg_variable_l[2];;
gap> homalg_variable_3991 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3989 = homalg_variable_3991;
true
gap> homalg_variable_3992 := homalg_variable_3985 * homalg_variable_3990;;
gap> homalg_variable_3993 := homalg_variable_3983 + homalg_variable_3992;;
gap> homalg_variable_3989 = homalg_variable_3993;
true
gap> homalg_variable_3994 := SIH_DecideZeroColumns(homalg_variable_3983,homalg_variable_3985);;
gap> homalg_variable_3995 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3994 = homalg_variable_3995;
true
gap> homalg_variable_3996 := homalg_variable_3990 * (homalg_variable_8);;
gap> homalg_variable_3997 := homalg_variable_3986 * homalg_variable_3996;;
gap> homalg_variable_3998 := homalg_variable_3981 * homalg_variable_3997;;
gap> homalg_variable_3998 = homalg_variable_3983;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3981,homalg_variable_3983);; homalg_variable_3999 := homalg_variable_l[1];; homalg_variable_4000 := homalg_variable_l[2];;
gap> for _del in [ "homalg_variable_3474", "homalg_variable_3476", "homalg_variable_3479", "homalg_variable_3480", "homalg_variable_3481", "homalg_variable_3482", "homalg_variable_3483", "homalg_variable_3484", "homalg_variable_3485", "homalg_variable_3486", "homalg_variable_3487", "homalg_variable_3488", "homalg_variable_3489", "homalg_variable_3490", "homalg_variable_3491", "homalg_variable_3492", "homalg_variable_3493", "homalg_variable_3494", "homalg_variable_3495", "homalg_variable_3496", "homalg_variable_3497", "homalg_variable_3498", "homalg_variable_3499", "homalg_variable_3501", "homalg_variable_3503", "homalg_variable_3504", "homalg_variable_3505", "homalg_variable_3506", "homalg_variable_3510", "homalg_variable_3512", "homalg_variable_3515", "homalg_variable_3516", "homalg_variable_3517", "homalg_variable_3518", "homalg_variable_3519", "homalg_variable_3520", "homalg_variable_3521", "homalg_variable_3522", "homalg_variable_3523", "homalg_variable_3524", "homalg_variable_3525", "homalg_variable_3526", "homalg_variable_3527", "homalg_variable_3528", "homalg_variable_3529", "homalg_variable_3530", "homalg_variable_3531", "homalg_variable_3532", "homalg_variable_3533", "homalg_variable_3534", "homalg_variable_3535", "homalg_variable_3537", "homalg_variable_3538", "homalg_variable_3539", "homalg_variable_3541", "homalg_variable_3542", "homalg_variable_3543", "homalg_variable_3545", "homalg_variable_3546", "homalg_variable_3547", "homalg_variable_3549", "homalg_variable_3552", "homalg_variable_3553", "homalg_variable_3554", "homalg_variable_3555", "homalg_variable_3556", "homalg_variable_3557", "homalg_variable_3558", "homalg_variable_3559", "homalg_variable_3560", "homalg_variable_3561", "homalg_variable_3562", "homalg_variable_3563", "homalg_variable_3566", "homalg_variable_3569", "homalg_variable_3570", "homalg_variable_3572", "homalg_variable_3575", "homalg_variable_3576", "homalg_variable_3577", "homalg_variable_3579", "homalg_variable_3582", "homalg_variable_3583", "homalg_variable_3584", "homalg_variable_3585", "homalg_variable_3586", "homalg_variable_3588", "homalg_variable_3589", "homalg_variable_3590", "homalg_variable_3592", "homalg_variable_3593", "homalg_variable_3594", "homalg_variable_3596", "homalg_variable_3599", "homalg_variable_3600", "homalg_variable_3601", "homalg_variable_3602", "homalg_variable_3603", "homalg_variable_3604", "homalg_variable_3605", "homalg_variable_3606", "homalg_variable_3607", "homalg_variable_3608", "homalg_variable_3609", "homalg_variable_3610", "homalg_variable_3611", "homalg_variable_3612", "homalg_variable_3613", "homalg_variable_3614", "homalg_variable_3615", "homalg_variable_3616", "homalg_variable_3617", "homalg_variable_3618", "homalg_variable_3619", "homalg_variable_3621", "homalg_variable_3622", "homalg_variable_3623", "homalg_variable_3625", "homalg_variable_3626", "homalg_variable_3627", "homalg_variable_3629", "homalg_variable_3632", "homalg_variable_3633", "homalg_variable_3636", "homalg_variable_3637", "homalg_variable_3638", "homalg_variable_3643", "homalg_variable_3644", "homalg_variable_3645", "homalg_variable_3646", "homalg_variable_3647", "homalg_variable_3648", "homalg_variable_3649", "homalg_variable_3650", "homalg_variable_3651", "homalg_variable_3652", "homalg_variable_3653", "homalg_variable_3655", "homalg_variable_3656", "homalg_variable_3657", "homalg_variable_3658", "homalg_variable_3659", "homalg_variable_3662", "homalg_variable_3663", "homalg_variable_3664", "homalg_variable_3665", "homalg_variable_3666", "homalg_variable_3668", "homalg_variable_3670", "homalg_variable_3672", "homalg_variable_3673", "homalg_variable_3674", "homalg_variable_3676", "homalg_variable_3679", "homalg_variable_3680", "homalg_variable_3681", "homalg_variable_3682", "homalg_variable_3683", "homalg_variable_3684", "homalg_variable_3685", "homalg_variable_3686", "homalg_variable_3687", "homalg_variable_3688", "homalg_variable_3689", "homalg_variable_3690", "homalg_variable_3691", "homalg_variable_3692", "homalg_variable_3693", "homalg_variable_3694", "homalg_variable_3695", "homalg_variable_3696", "homalg_variable_3697", "homalg_variable_3698", "homalg_variable_3699", "homalg_variable_3701", "homalg_variable_3705", "homalg_variable_3707", "homalg_variable_3708", "homalg_variable_3710", "homalg_variable_3712", "homalg_variable_3715", "homalg_variable_3716", "homalg_variable_3717", "homalg_variable_3720", "homalg_variable_3721", "homalg_variable_3722", "homalg_variable_3727", "homalg_variable_3728", "homalg_variable_3729", "homalg_variable_3730", "homalg_variable_3731", "homalg_variable_3732", "homalg_variable_3733", "homalg_variable_3734", "homalg_variable_3735", "homalg_variable_3736", "homalg_variable_3737", "homalg_variable_3739", "homalg_variable_3740", "homalg_variable_3741", "homalg_variable_3743", "homalg_variable_3745", "homalg_variable_3746", "homalg_variable_3748", "homalg_variable_3750", "homalg_variable_3753", "homalg_variable_3754", "homalg_variable_3755", "homalg_variable_3756", "homalg_variable_3757", "homalg_variable_3758", "homalg_variable_3759", "homalg_variable_3760", "homalg_variable_3761", "homalg_variable_3762", "homalg_variable_3763", "homalg_variable_3764", "homalg_variable_3765", "homalg_variable_3766", "homalg_variable_3767", "homalg_variable_3768", "homalg_variable_3769", "homalg_variable_3770", "homalg_variable_3771", "homalg_variable_3772", "homalg_variable_3773", "homalg_variable_3774", "homalg_variable_3776", "homalg_variable_3777", "homalg_variable_3778", "homalg_variable_3779", "homalg_variable_3780", "homalg_variable_3783", "homalg_variable_3784", "homalg_variable_3785", "homalg_variable_3786", "homalg_variable_3787", "homalg_variable_3789", "homalg_variable_3790", "homalg_variable_3791", "homalg_variable_3793", "homalg_variable_3794", "homalg_variable_3795", "homalg_variable_3797", "homalg_variable_3800", "homalg_variable_3801", "homalg_variable_3805", "homalg_variable_3806", "homalg_variable_3807", "homalg_variable_3808", "homalg_variable_3811", "homalg_variable_3812", "homalg_variable_3813", "homalg_variable_3814", "homalg_variable_3815", "homalg_variable_3816", "homalg_variable_3817", "homalg_variable_3818", "homalg_variable_3819", "homalg_variable_3820", "homalg_variable_3822", "homalg_variable_3823", "homalg_variable_3824", "homalg_variable_3826", "homalg_variable_3827", "homalg_variable_3828", "homalg_variable_3830", "homalg_variable_3833", "homalg_variable_3834", "homalg_variable_3835", "homalg_variable_3836", "homalg_variable_3837", "homalg_variable_3838", "homalg_variable_3839", "homalg_variable_3840", "homalg_variable_3841", "homalg_variable_3842", "homalg_variable_3843", "homalg_variable_3844", "homalg_variable_3845", "homalg_variable_3846", "homalg_variable_3847", "homalg_variable_3848", "homalg_variable_3849", "homalg_variable_3850", "homalg_variable_3851", "homalg_variable_3852", "homalg_variable_3853", "homalg_variable_3855", "homalg_variable_3856", "homalg_variable_3857", "homalg_variable_3859", "homalg_variable_3861", "homalg_variable_3864", "homalg_variable_3865", "homalg_variable_3868", "homalg_variable_3871", "homalg_variable_3872", "homalg_variable_3875", "homalg_variable_3876", "homalg_variable_3877", "homalg_variable_3878", "homalg_variable_3879", "homalg_variable_3880", "homalg_variable_3881", "homalg_variable_3882", "homalg_variable_3883", "homalg_variable_3884", "homalg_variable_3885", "homalg_variable_3887", "homalg_variable_3888", "homalg_variable_3889", "homalg_variable_3890", "homalg_variable_3891", "homalg_variable_3894", "homalg_variable_3895", "homalg_variable_3896", "homalg_variable_3897", "homalg_variable_3898", "homalg_variable_3902", "homalg_variable_3904", "homalg_variable_3905", "homalg_variable_3906", "homalg_variable_3907", "homalg_variable_3908", "homalg_variable_3911", "homalg_variable_3912", "homalg_variable_3913", "homalg_variable_3917", "homalg_variable_3919", "homalg_variable_3920", "homalg_variable_3921", "homalg_variable_3922", "homalg_variable_3923", "homalg_variable_3926", "homalg_variable_3927", "homalg_variable_3928", "homalg_variable_3934", "homalg_variable_3937", "homalg_variable_3938", "homalg_variable_3941", "homalg_variable_3942", "homalg_variable_3943", "homalg_variable_3945", "homalg_variable_3946", "homalg_variable_3947", "homalg_variable_3949", "homalg_variable_3951", "homalg_variable_3953", "homalg_variable_3956", "homalg_variable_3957", "homalg_variable_3960", "homalg_variable_3961", "homalg_variable_3962", "homalg_variable_3963", "homalg_variable_3964", "homalg_variable_3968", "homalg_variable_3969", "homalg_variable_3970", "homalg_variable_3971", "homalg_variable_3972", "homalg_variable_3973", "homalg_variable_3974", "homalg_variable_3975", "homalg_variable_3976", "homalg_variable_3978", "homalg_variable_3979", "homalg_variable_3980" ] do UnbindGlobal( _del ); od;;
gap> homalg_variable_4001 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3999 = homalg_variable_4001;
true
gap> homalg_variable_4002 := homalg_variable_3983 * homalg_variable_4000;;
gap> homalg_variable_4003 := homalg_variable_3981 + homalg_variable_4002;;
gap> homalg_variable_3999 = homalg_variable_4003;
true
gap> homalg_variable_4004 := SIH_DecideZeroColumns(homalg_variable_3981,homalg_variable_3983);;
gap> homalg_variable_4005 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4004 = homalg_variable_4005;
true
gap> homalg_variable_4006 := homalg_variable_4000 * (homalg_variable_8);;
gap> homalg_variable_4007 := homalg_variable_3983 * homalg_variable_4006;;
gap> homalg_variable_4007 = homalg_variable_3981;
true
gap> homalg_variable_4008 := SIH_BasisOfColumnModule(homalg_variable_3940);;
gap> SI_ncols(homalg_variable_4008);
1
gap> homalg_variable_4009 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4008 = homalg_variable_4009;
false
gap> homalg_variable_4008 = homalg_variable_3940;
true
gap> homalg_variable_4010 := SIH_DecideZeroColumns(homalg_variable_3981,homalg_variable_4008);;
gap> homalg_variable_4011 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4010 = homalg_variable_4011;
true
gap> homalg_variable_4013 := homalg_variable_3581 * homalg_variable_10;;
gap> homalg_variable_4012 := SIH_BasisOfColumnModule(homalg_variable_4013);;
gap> SI_ncols(homalg_variable_4012);
6
gap> homalg_variable_4014 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4012 = homalg_variable_4014;
false
gap> homalg_variable_4012 = homalg_variable_4013;
false
gap> homalg_variable_4015 := SIH_DecideZeroColumns(homalg_variable_3581,homalg_variable_4012);;
gap> homalg_variable_4016 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_4015 = homalg_variable_4016;
false
gap> homalg_variable_4017 := SIH_UnionOfColumns(homalg_variable_4015,homalg_variable_4012);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4017);; homalg_variable_4018 := homalg_variable_l[1];; homalg_variable_4019 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4018);
5
gap> homalg_variable_4020 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_4018 = homalg_variable_4020;
false
gap> SI_nrows(homalg_variable_4019);
11
gap> homalg_variable_4021 := SIH_Submatrix(homalg_variable_4019,[ 1, 2, 3, 4, 5 ],[1..5]);;
gap> homalg_variable_4022 := homalg_variable_4015 * homalg_variable_4021;;
gap> homalg_variable_4023 := SIH_Submatrix(homalg_variable_4019,[ 6, 7, 8, 9, 10, 11 ],[1..5]);;
gap> homalg_variable_4024 := homalg_variable_4012 * homalg_variable_4023;;
gap> homalg_variable_4025 := homalg_variable_4022 + homalg_variable_4024;;
gap> homalg_variable_4018 = homalg_variable_4025;
true
gap> homalg_variable_4026 := SIH_DecideZeroColumns(homalg_variable_18,homalg_variable_4012);;
gap> homalg_variable_4027 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_4026 = homalg_variable_4027;
false
gap> homalg_variable_4018 = homalg_variable_18;
true
gap> homalg_variable_4029 := SIH_Submatrix(homalg_variable_4019,[ 1, 2, 3, 4, 5 ],[1..5]);;
gap> homalg_variable_4030 := homalg_variable_4029 * homalg_variable_4026;;
gap> homalg_variable_4031 := homalg_variable_3581 * homalg_variable_4030;;
gap> homalg_variable_4032 := homalg_variable_4031 - homalg_variable_18;;
gap> homalg_variable_4028 := SIH_DecideZeroColumns(homalg_variable_4032,homalg_variable_4012);;
gap> homalg_variable_4033 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_4028 = homalg_variable_4033;
true
gap> homalg_variable_4035 := SIH_UnionOfColumns(homalg_variable_3910,homalg_variable_4013);;
gap> homalg_variable_4034 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3581,homalg_variable_4035);;
gap> SI_ncols(homalg_variable_4034);
6
gap> homalg_variable_4036 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4034 = homalg_variable_4036;
false
gap> homalg_variable_4037 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4034);;
gap> SI_ncols(homalg_variable_4037);
4
gap> homalg_variable_4038 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_4037 = homalg_variable_4038;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_4037,[ 0 ]);
[  ]
gap> homalg_variable_4039 := SIH_BasisOfColumnModule(homalg_variable_4034);;
gap> SI_ncols(homalg_variable_4039);
6
gap> homalg_variable_4040 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4039 = homalg_variable_4040;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4034);; homalg_variable_4041 := homalg_variable_l[1];; homalg_variable_4042 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4041);
6
gap> homalg_variable_4043 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4041 = homalg_variable_4043;
false
gap> SI_nrows(homalg_variable_4042);
6
gap> homalg_variable_4044 := homalg_variable_4034 * homalg_variable_4042;;
gap> homalg_variable_4041 = homalg_variable_4044;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4039,homalg_variable_4041);; homalg_variable_4045 := homalg_variable_l[1];; homalg_variable_4046 := homalg_variable_l[2];;
gap> homalg_variable_4047 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4045 = homalg_variable_4047;
true
gap> homalg_variable_4048 := homalg_variable_4041 * homalg_variable_4046;;
gap> homalg_variable_4049 := homalg_variable_4039 + homalg_variable_4048;;
gap> homalg_variable_4045 = homalg_variable_4049;
true
gap> homalg_variable_4050 := SIH_DecideZeroColumns(homalg_variable_4039,homalg_variable_4041);;
gap> homalg_variable_4051 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4050 = homalg_variable_4051;
true
gap> homalg_variable_4052 := homalg_variable_4046 * (homalg_variable_8);;
gap> homalg_variable_4053 := homalg_variable_4042 * homalg_variable_4052;;
gap> homalg_variable_4054 := homalg_variable_4034 * homalg_variable_4053;;
gap> homalg_variable_4054 = homalg_variable_4039;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4034,homalg_variable_4039);; homalg_variable_4055 := homalg_variable_l[1];; homalg_variable_4056 := homalg_variable_l[2];;
gap> homalg_variable_4057 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4055 = homalg_variable_4057;
true
gap> homalg_variable_4058 := homalg_variable_4039 * homalg_variable_4056;;
gap> homalg_variable_4059 := homalg_variable_4034 + homalg_variable_4058;;
gap> homalg_variable_4055 = homalg_variable_4059;
true
gap> homalg_variable_4060 := SIH_DecideZeroColumns(homalg_variable_4034,homalg_variable_4039);;
gap> homalg_variable_4061 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4060 = homalg_variable_4061;
true
gap> homalg_variable_4062 := homalg_variable_4056 * (homalg_variable_8);;
gap> homalg_variable_4063 := homalg_variable_4039 * homalg_variable_4062;;
gap> homalg_variable_4063 = homalg_variable_4034;
true
gap> homalg_variable_4064 := SIH_DecideZeroColumns(homalg_variable_4034,homalg_variable_10);;
gap> homalg_variable_4065 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4064 = homalg_variable_4065;
true
gap> homalg_variable_4067 := homalg_variable_4030 * homalg_variable_3910;;
gap> homalg_variable_4066 := SIH_DecideZeroColumns(homalg_variable_4067,homalg_variable_10);;
gap> homalg_variable_4068 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4066 = homalg_variable_4068;
true
gap> homalg_variable_4069 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4030,homalg_variable_10);;
gap> SI_ncols(homalg_variable_4069);
6
gap> homalg_variable_4070 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4069 = homalg_variable_4070;
false
gap> homalg_variable_4071 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4069);;
gap> SI_ncols(homalg_variable_4071);
4
gap> homalg_variable_4072 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_4071 = homalg_variable_4072;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_4071,[ 0 ]);
[  ]
gap> homalg_variable_4073 := SIH_BasisOfColumnModule(homalg_variable_4069);;
gap> SI_ncols(homalg_variable_4073);
6
gap> homalg_variable_4074 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4073 = homalg_variable_4074;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4069);; homalg_variable_4075 := homalg_variable_l[1];; homalg_variable_4076 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4075);
6
gap> homalg_variable_4077 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4075 = homalg_variable_4077;
false
gap> SI_nrows(homalg_variable_4076);
6
gap> homalg_variable_4078 := homalg_variable_4069 * homalg_variable_4076;;
gap> homalg_variable_4075 = homalg_variable_4078;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4073,homalg_variable_4075);; homalg_variable_4079 := homalg_variable_l[1];; homalg_variable_4080 := homalg_variable_l[2];;
gap> homalg_variable_4081 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4079 = homalg_variable_4081;
true
gap> homalg_variable_4082 := homalg_variable_4075 * homalg_variable_4080;;
gap> homalg_variable_4083 := homalg_variable_4073 + homalg_variable_4082;;
gap> homalg_variable_4079 = homalg_variable_4083;
true
gap> homalg_variable_4084 := SIH_DecideZeroColumns(homalg_variable_4073,homalg_variable_4075);;
gap> homalg_variable_4085 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4084 = homalg_variable_4085;
true
gap> homalg_variable_4086 := homalg_variable_4080 * (homalg_variable_8);;
gap> homalg_variable_4087 := homalg_variable_4076 * homalg_variable_4086;;
gap> homalg_variable_4088 := homalg_variable_4069 * homalg_variable_4087;;
gap> homalg_variable_4088 = homalg_variable_4073;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4069,homalg_variable_4073);; homalg_variable_4089 := homalg_variable_l[1];; homalg_variable_4090 := homalg_variable_l[2];;
gap> homalg_variable_4091 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4089 = homalg_variable_4091;
true
gap> homalg_variable_4092 := homalg_variable_4073 * homalg_variable_4090;;
gap> homalg_variable_4093 := homalg_variable_4069 + homalg_variable_4092;;
gap> homalg_variable_4089 = homalg_variable_4093;
true
gap> homalg_variable_4094 := SIH_DecideZeroColumns(homalg_variable_4069,homalg_variable_4073);;
gap> homalg_variable_4095 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4094 = homalg_variable_4095;
true
gap> homalg_variable_4096 := homalg_variable_4090 * (homalg_variable_8);;
gap> homalg_variable_4097 := homalg_variable_4073 * homalg_variable_4096;;
gap> homalg_variable_4097 = homalg_variable_4069;
true
gap> homalg_variable_4098 := SIH_DecideZeroColumns(homalg_variable_4069,homalg_variable_3944);;
gap> homalg_variable_4099 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4098 = homalg_variable_4099;
true
gap> homalg_variable_4101 := SIH_UnionOfRows(homalg_variable_2960,homalg_variable_2487);;
gap> homalg_variable_4102 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_4103 := SIH_UnionOfRows(homalg_variable_4101,homalg_variable_4102);;
gap> homalg_variable_4104 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_4105 := SIH_UnionOfRows(homalg_variable_4103,homalg_variable_4104);;
gap> homalg_variable_4106 := SI_matrix(homalg_variable_5,1,10,"0");;
gap> homalg_variable_4107 := SIH_UnionOfRows(homalg_variable_4106,homalg_variable_2023);;
gap> homalg_variable_4108 := SIH_UnionOfRows(homalg_variable_4107,homalg_variable_2566);;
gap> homalg_variable_4109 := SI_matrix(homalg_variable_5,7,10,"0");;
gap> homalg_variable_4110 := SIH_UnionOfRows(homalg_variable_4108,homalg_variable_4109);;
gap> homalg_variable_4111 := SIH_UnionOfColumns(homalg_variable_4105,homalg_variable_4110);;
gap> homalg_variable_4112 := SI_matrix(homalg_variable_5,6,14,"0");;
gap> homalg_variable_4113 := SIH_UnionOfRows(homalg_variable_4112,homalg_variable_2873);;
gap> homalg_variable_4114 := SIH_UnionOfRows(homalg_variable_4113,homalg_variable_2652);;
gap> homalg_variable_4115 := SIH_UnionOfColumns(homalg_variable_4111,homalg_variable_4114);;
gap> homalg_variable_4100 := SIH_BasisOfColumnModule(homalg_variable_4115);;
gap> SI_ncols(homalg_variable_4100);
25
gap> homalg_variable_4116 := SI_matrix(homalg_variable_5,23,25,"0");;
gap> homalg_variable_4100 = homalg_variable_4116;
false
gap> homalg_variable_4117 := SIH_DecideZeroColumns(homalg_variable_4115,homalg_variable_4100);;
gap> homalg_variable_4118 := SI_matrix(homalg_variable_5,23,28,"0");;
gap> homalg_variable_4117 = homalg_variable_4118;
true
gap> homalg_variable_4120 := SI_matrix(homalg_variable_5,16,6,"0");;
gap> homalg_variable_4121 := homalg_variable_3544 * homalg_variable_3944;;
gap> homalg_variable_4122 := SIH_UnionOfRows(homalg_variable_4120,homalg_variable_4121);;
gap> homalg_variable_4119 := SIH_DecideZeroColumns(homalg_variable_4122,homalg_variable_4100);;
gap> homalg_variable_4123 := SI_matrix(homalg_variable_5,23,6,"0");;
gap> homalg_variable_4119 = homalg_variable_4123;
true
gap> homalg_variable_4125 := SI_matrix(homalg_variable_5,16,5,"0");;
gap> homalg_variable_4126 := SIH_UnionOfRows(homalg_variable_4125,homalg_variable_3544);;
gap> homalg_variable_4124 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4126,homalg_variable_4115);;
gap> SI_ncols(homalg_variable_4124);
6
gap> homalg_variable_4127 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4124 = homalg_variable_4127;
false
gap> homalg_variable_4128 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4124);;
gap> SI_ncols(homalg_variable_4128);
4
gap> homalg_variable_4129 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_4128 = homalg_variable_4129;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_4128,[ 0 ]);
[  ]
gap> homalg_variable_4130 := SIH_BasisOfColumnModule(homalg_variable_4124);;
gap> SI_ncols(homalg_variable_4130);
6
gap> homalg_variable_4131 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4130 = homalg_variable_4131;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4124);; homalg_variable_4132 := homalg_variable_l[1];; homalg_variable_4133 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4132);
6
gap> homalg_variable_4134 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4132 = homalg_variable_4134;
false
gap> SI_nrows(homalg_variable_4133);
6
gap> homalg_variable_4135 := homalg_variable_4124 * homalg_variable_4133;;
gap> homalg_variable_4132 = homalg_variable_4135;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4130,homalg_variable_4132);; homalg_variable_4136 := homalg_variable_l[1];; homalg_variable_4137 := homalg_variable_l[2];;
gap> homalg_variable_4138 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4136 = homalg_variable_4138;
true
gap> homalg_variable_4139 := homalg_variable_4132 * homalg_variable_4137;;
gap> homalg_variable_4140 := homalg_variable_4130 + homalg_variable_4139;;
gap> homalg_variable_4136 = homalg_variable_4140;
true
gap> homalg_variable_4141 := SIH_DecideZeroColumns(homalg_variable_4130,homalg_variable_4132);;
gap> homalg_variable_4142 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4141 = homalg_variable_4142;
true
gap> homalg_variable_4143 := homalg_variable_4137 * (homalg_variable_8);;
gap> homalg_variable_4144 := homalg_variable_4133 * homalg_variable_4143;;
gap> homalg_variable_4145 := homalg_variable_4124 * homalg_variable_4144;;
gap> homalg_variable_4145 = homalg_variable_4130;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4124,homalg_variable_4130);; homalg_variable_4146 := homalg_variable_l[1];; homalg_variable_4147 := homalg_variable_l[2];;
gap> homalg_variable_4148 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4146 = homalg_variable_4148;
true
gap> homalg_variable_4149 := homalg_variable_4130 * homalg_variable_4147;;
gap> homalg_variable_4150 := homalg_variable_4124 + homalg_variable_4149;;
gap> homalg_variable_4146 = homalg_variable_4150;
true
gap> homalg_variable_4151 := SIH_DecideZeroColumns(homalg_variable_4124,homalg_variable_4130);;
gap> homalg_variable_4152 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4151 = homalg_variable_4152;
true
gap> homalg_variable_4153 := homalg_variable_4147 * (homalg_variable_8);;
gap> homalg_variable_4154 := homalg_variable_4130 * homalg_variable_4153;;
gap> homalg_variable_4154 = homalg_variable_4124;
true
gap> homalg_variable_4155 := SIH_DecideZeroColumns(homalg_variable_4124,homalg_variable_3944);;
gap> homalg_variable_4156 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4155 = homalg_variable_4156;
true
gap> homalg_variable_4158 := SI_matrix(SI_freemodule(homalg_variable_5,16));;
gap> homalg_variable_4159 := SIH_Submatrix(homalg_variable_4158,[1..16],[ 6 ]);;
gap> homalg_variable_4160 := SI_matrix(homalg_variable_5,16,3,"0");;
gap> homalg_variable_4161 := SIH_UnionOfColumns(homalg_variable_4159,homalg_variable_4160);;
gap> homalg_variable_4162 := SIH_Submatrix(homalg_variable_4158,[1..16],[ 2, 3, 4, 5, 6 ]);;
gap> homalg_variable_4163 := homalg_variable_2492 * homalg_variable_2831;;
gap> homalg_variable_4164 := homalg_variable_4162 * homalg_variable_4163;;
gap> homalg_variable_4165 := SIH_UnionOfColumns(homalg_variable_4161,homalg_variable_4164);;
gap> homalg_variable_4166 := SI_matrix(homalg_variable_5,7,8,"0");;
gap> homalg_variable_4167 := SIH_UnionOfRows(homalg_variable_4165,homalg_variable_4166);;
gap> homalg_variable_4168 := SIH_Submatrix(homalg_variable_4158,[1..16],[ 1 ]);;
gap> homalg_variable_4169 := SI_matrix(homalg_variable_5,7,1,"0");;
gap> homalg_variable_4170 := SIH_UnionOfRows(homalg_variable_4168,homalg_variable_4169);;
gap> homalg_variable_4171 := SIH_UnionOfColumns(homalg_variable_4167,homalg_variable_4170);;
gap> homalg_variable_4157 := SIH_BasisOfColumnModule(homalg_variable_4171);;
gap> SI_ncols(homalg_variable_4157);
6
gap> homalg_variable_4172 := SI_matrix(homalg_variable_5,23,6,"0");;
gap> homalg_variable_4157 = homalg_variable_4172;
false
gap> homalg_variable_4173 := SIH_DecideZeroColumns(homalg_variable_4171,homalg_variable_4157);;
gap> homalg_variable_4174 := SI_matrix(homalg_variable_5,23,9,"0");;
gap> homalg_variable_4173 = homalg_variable_4174;
true
gap> homalg_variable_4176 := homalg_variable_2492 * homalg_variable_3003;;
gap> homalg_variable_4177 := homalg_variable_4162 * homalg_variable_4176;;
gap> homalg_variable_4178 := homalg_variable_4177 * homalg_variable_3037;;
gap> homalg_variable_4179 := SI_matrix(homalg_variable_5,7,2,"0");;
gap> homalg_variable_4180 := SIH_UnionOfRows(homalg_variable_4178,homalg_variable_4179);;
gap> homalg_variable_4175 := SIH_DecideZeroColumns(homalg_variable_4180,homalg_variable_4157);;
gap> homalg_variable_4181 := SI_matrix(homalg_variable_5,23,2,"0");;
gap> homalg_variable_4175 = homalg_variable_4181;
true
gap> homalg_variable_4183 := SI_matrix(homalg_variable_5,7,1,"0");;
gap> homalg_variable_4184 := SIH_UnionOfRows(homalg_variable_4177,homalg_variable_4183);;
gap> homalg_variable_4182 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4184,homalg_variable_4171);;
gap> SI_ncols(homalg_variable_4182);
2
gap> homalg_variable_4185 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4182 = homalg_variable_4185;
false
gap> homalg_variable_4186 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4182);;
gap> SI_ncols(homalg_variable_4186);
1
gap> homalg_variable_4187 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_4186 = homalg_variable_4187;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_4186,[ 0 ]);
[  ]
gap> homalg_variable_4188 := SIH_BasisOfColumnModule(homalg_variable_4182);;
gap> SI_ncols(homalg_variable_4188);
2
gap> homalg_variable_4189 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4188 = homalg_variable_4189;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4182);; homalg_variable_4190 := homalg_variable_l[1];; homalg_variable_4191 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4190);
2
gap> homalg_variable_4192 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4190 = homalg_variable_4192;
false
gap> SI_nrows(homalg_variable_4191);
2
gap> homalg_variable_4193 := homalg_variable_4182 * homalg_variable_4191;;
gap> homalg_variable_4190 = homalg_variable_4193;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4188,homalg_variable_4190);; homalg_variable_4194 := homalg_variable_l[1];; homalg_variable_4195 := homalg_variable_l[2];;
gap> homalg_variable_4196 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4194 = homalg_variable_4196;
true
gap> homalg_variable_4197 := homalg_variable_4190 * homalg_variable_4195;;
gap> homalg_variable_4198 := homalg_variable_4188 + homalg_variable_4197;;
gap> homalg_variable_4194 = homalg_variable_4198;
true
gap> homalg_variable_4199 := SIH_DecideZeroColumns(homalg_variable_4188,homalg_variable_4190);;
gap> homalg_variable_4200 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4199 = homalg_variable_4200;
true
gap> homalg_variable_4201 := homalg_variable_4195 * (homalg_variable_8);;
gap> homalg_variable_4202 := homalg_variable_4191 * homalg_variable_4201;;
gap> homalg_variable_4203 := homalg_variable_4182 * homalg_variable_4202;;
gap> homalg_variable_4203 = homalg_variable_4188;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4182,homalg_variable_4188);; homalg_variable_4204 := homalg_variable_l[1];; homalg_variable_4205 := homalg_variable_l[2];;
gap> homalg_variable_4206 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4204 = homalg_variable_4206;
true
gap> homalg_variable_4207 := homalg_variable_4188 * homalg_variable_4205;;
gap> homalg_variable_4208 := homalg_variable_4182 + homalg_variable_4207;;
gap> homalg_variable_4204 = homalg_variable_4208;
true
gap> homalg_variable_4209 := SIH_DecideZeroColumns(homalg_variable_4182,homalg_variable_4188);;
gap> homalg_variable_4210 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4209 = homalg_variable_4210;
true
gap> homalg_variable_4211 := homalg_variable_4205 * (homalg_variable_8);;
gap> homalg_variable_4212 := homalg_variable_4188 * homalg_variable_4211;;
gap> homalg_variable_4212 = homalg_variable_4182;
true
gap> homalg_variable_4213 := SIH_DecideZeroColumns(homalg_variable_4182,homalg_variable_3037);;
gap> homalg_variable_4214 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4213 = homalg_variable_4214;
true
gap> homalg_variable_4216 := SIH_Submatrix(homalg_variable_4158,[1..16],[ 14, 15, 16 ]);;
gap> homalg_variable_4217 := homalg_variable_4216 * homalg_variable_2563;;
gap> homalg_variable_4218 := SI_matrix(homalg_variable_5,16,3,"0");;
gap> homalg_variable_4219 := SIH_UnionOfColumns(homalg_variable_4217,homalg_variable_4218);;
gap> homalg_variable_4220 := SIH_Submatrix(homalg_variable_4158,[1..16],[ 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 ]);;
gap> homalg_variable_4221 := homalg_variable_2571 * homalg_variable_2887;;
gap> homalg_variable_4222 := homalg_variable_4220 * homalg_variable_4221;;
gap> homalg_variable_4223 := SIH_UnionOfColumns(homalg_variable_4219,homalg_variable_4222);;
gap> homalg_variable_4224 := SI_matrix(homalg_variable_5,7,14,"0");;
gap> homalg_variable_4225 := SIH_UnionOfRows(homalg_variable_4223,homalg_variable_4224);;
gap> homalg_variable_4226 := SI_matrix(homalg_variable_5,7,5,"0");;
gap> homalg_variable_4227 := SIH_UnionOfRows(homalg_variable_4162,homalg_variable_4226);;
gap> homalg_variable_4228 := SIH_UnionOfColumns(homalg_variable_4227,homalg_variable_4170);;
gap> homalg_variable_4229 := SIH_UnionOfColumns(homalg_variable_4225,homalg_variable_4228);;
gap> homalg_variable_4215 := SIH_BasisOfColumnModule(homalg_variable_4229);;
gap> SI_ncols(homalg_variable_4215);
13
gap> homalg_variable_4230 := SI_matrix(homalg_variable_5,23,13,"0");;
gap> homalg_variable_4215 = homalg_variable_4230;
false
gap> homalg_variable_4231 := SIH_DecideZeroColumns(homalg_variable_4229,homalg_variable_4215);;
gap> homalg_variable_4232 := SI_matrix(homalg_variable_5,23,20,"0");;
gap> homalg_variable_4231 = homalg_variable_4232;
true
gap> homalg_variable_4234 := homalg_variable_3224 * homalg_variable_3322;;
gap> homalg_variable_4235 := homalg_variable_4220 * homalg_variable_4234;;
gap> homalg_variable_4236 := homalg_variable_4235 * homalg_variable_3358;;
gap> homalg_variable_4237 := SI_matrix(homalg_variable_5,7,5,"0");;
gap> homalg_variable_4238 := SIH_UnionOfRows(homalg_variable_4236,homalg_variable_4237);;
gap> homalg_variable_4233 := SIH_DecideZeroColumns(homalg_variable_4238,homalg_variable_4215);;
gap> homalg_variable_4239 := SI_matrix(homalg_variable_5,23,5,"0");;
gap> homalg_variable_4233 = homalg_variable_4239;
true
gap> homalg_variable_4241 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_4242 := SIH_UnionOfRows(homalg_variable_4235,homalg_variable_4241);;
gap> homalg_variable_4240 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4242,homalg_variable_4229);;
gap> SI_ncols(homalg_variable_4240);
5
gap> homalg_variable_4243 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4240 = homalg_variable_4243;
false
gap> homalg_variable_4244 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4240);;
gap> SI_ncols(homalg_variable_4244);
1
gap> homalg_variable_4245 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_4244 = homalg_variable_4245;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_4244,[ 0 ]);
[  ]
gap> homalg_variable_4246 := SIH_BasisOfColumnModule(homalg_variable_4240);;
gap> SI_ncols(homalg_variable_4246);
5
gap> homalg_variable_4247 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4246 = homalg_variable_4247;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4240);; homalg_variable_4248 := homalg_variable_l[1];; homalg_variable_4249 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4248);
5
gap> homalg_variable_4250 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4248 = homalg_variable_4250;
false
gap> SI_nrows(homalg_variable_4249);
5
gap> homalg_variable_4251 := homalg_variable_4240 * homalg_variable_4249;;
gap> homalg_variable_4248 = homalg_variable_4251;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4246,homalg_variable_4248);; homalg_variable_4252 := homalg_variable_l[1];; homalg_variable_4253 := homalg_variable_l[2];;
gap> homalg_variable_4254 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4252 = homalg_variable_4254;
true
gap> homalg_variable_4255 := homalg_variable_4248 * homalg_variable_4253;;
gap> homalg_variable_4256 := homalg_variable_4246 + homalg_variable_4255;;
gap> homalg_variable_4252 = homalg_variable_4256;
true
gap> homalg_variable_4257 := SIH_DecideZeroColumns(homalg_variable_4246,homalg_variable_4248);;
gap> homalg_variable_4258 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4257 = homalg_variable_4258;
true
gap> homalg_variable_4259 := homalg_variable_4253 * (homalg_variable_8);;
gap> homalg_variable_4260 := homalg_variable_4249 * homalg_variable_4259;;
gap> homalg_variable_4261 := homalg_variable_4240 * homalg_variable_4260;;
gap> homalg_variable_4261 = homalg_variable_4246;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4240,homalg_variable_4246);; homalg_variable_4262 := homalg_variable_l[1];; homalg_variable_4263 := homalg_variable_l[2];;
gap> homalg_variable_4264 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4262 = homalg_variable_4264;
true
gap> homalg_variable_4265 := homalg_variable_4246 * homalg_variable_4263;;
gap> homalg_variable_4266 := homalg_variable_4240 + homalg_variable_4265;;
gap> homalg_variable_4262 = homalg_variable_4266;
true
gap> homalg_variable_4267 := SIH_DecideZeroColumns(homalg_variable_4240,homalg_variable_4246);;
gap> homalg_variable_4268 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4267 = homalg_variable_4268;
true
gap> homalg_variable_4269 := homalg_variable_4263 * (homalg_variable_8);;
gap> homalg_variable_4270 := homalg_variable_4246 * homalg_variable_4269;;
gap> homalg_variable_4270 = homalg_variable_4240;
true
gap> homalg_variable_4271 := SIH_DecideZeroColumns(homalg_variable_4240,homalg_variable_3358);;
gap> homalg_variable_4272 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4271 = homalg_variable_4272;
true
gap> homalg_variable_4274 := SI_matrix(homalg_variable_5,16,14,"0");;
gap> homalg_variable_4275 := SIH_Submatrix(homalg_variable_1109,[1..7],[ 3, 4, 5, 6, 7 ]);;
gap> homalg_variable_4276 := homalg_variable_4275 * homalg_variable_2649;;
gap> homalg_variable_4277 := SI_matrix(homalg_variable_5,7,5,"0");;
gap> homalg_variable_4278 := SIH_UnionOfColumns(homalg_variable_4276,homalg_variable_4277);;
gap> homalg_variable_4279 := SIH_UnionOfRows(homalg_variable_4274,homalg_variable_4278);;
gap> homalg_variable_4280 := SI_matrix(homalg_variable_5,7,10,"0");;
gap> homalg_variable_4281 := SIH_UnionOfRows(homalg_variable_4220,homalg_variable_4280);;
gap> homalg_variable_4282 := SIH_UnionOfColumns(homalg_variable_4281,homalg_variable_4228);;
gap> homalg_variable_4283 := SIH_UnionOfColumns(homalg_variable_4279,homalg_variable_4282);;
gap> homalg_variable_4273 := SIH_BasisOfColumnModule(homalg_variable_4283);;
gap> SI_ncols(homalg_variable_4273);
21
gap> homalg_variable_4284 := SI_matrix(homalg_variable_5,23,21,"0");;
gap> homalg_variable_4273 = homalg_variable_4284;
false
gap> homalg_variable_4285 := SIH_DecideZeroColumns(homalg_variable_4283,homalg_variable_4273);;
gap> homalg_variable_4286 := SI_matrix(homalg_variable_5,23,30,"0");;
gap> homalg_variable_4285 = homalg_variable_4286;
true
gap> homalg_variable_4288 := SI_matrix(homalg_variable_5,16,4,"0");;
gap> homalg_variable_4289 := homalg_variable_3436 * homalg_variable_3500;;
gap> homalg_variable_4290 := homalg_variable_4289 * homalg_variable_3536;;
gap> homalg_variable_4291 := SIH_UnionOfRows(homalg_variable_4288,homalg_variable_4290);;
gap> homalg_variable_4287 := SIH_DecideZeroColumns(homalg_variable_4291,homalg_variable_4273);;
gap> homalg_variable_4292 := SI_matrix(homalg_variable_5,23,4,"0");;
gap> homalg_variable_4287 = homalg_variable_4292;
true
gap> homalg_variable_4294 := SI_matrix(homalg_variable_5,16,5,"0");;
gap> homalg_variable_4295 := SIH_UnionOfRows(homalg_variable_4294,homalg_variable_4289);;
gap> homalg_variable_4293 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4295,homalg_variable_4283);;
gap> SI_ncols(homalg_variable_4293);
4
gap> homalg_variable_4296 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4293 = homalg_variable_4296;
false
gap> homalg_variable_4297 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4293);;
gap> SI_ncols(homalg_variable_4297);
1
gap> homalg_variable_4298 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4297 = homalg_variable_4298;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_4297,[ 0 ]);
[  ]
gap> homalg_variable_4299 := SIH_BasisOfColumnModule(homalg_variable_4293);;
gap> SI_ncols(homalg_variable_4299);
4
gap> homalg_variable_4300 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4299 = homalg_variable_4300;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4293);; homalg_variable_4301 := homalg_variable_l[1];; homalg_variable_4302 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4301);
4
gap> homalg_variable_4303 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4301 = homalg_variable_4303;
false
gap> SI_nrows(homalg_variable_4302);
4
gap> homalg_variable_4304 := homalg_variable_4293 * homalg_variable_4302;;
gap> homalg_variable_4301 = homalg_variable_4304;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4299,homalg_variable_4301);; homalg_variable_4305 := homalg_variable_l[1];; homalg_variable_4306 := homalg_variable_l[2];;
gap> homalg_variable_4307 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4305 = homalg_variable_4307;
true
gap> homalg_variable_4308 := homalg_variable_4301 * homalg_variable_4306;;
gap> homalg_variable_4309 := homalg_variable_4299 + homalg_variable_4308;;
gap> homalg_variable_4305 = homalg_variable_4309;
true
gap> homalg_variable_4310 := SIH_DecideZeroColumns(homalg_variable_4299,homalg_variable_4301);;
gap> homalg_variable_4311 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4310 = homalg_variable_4311;
true
gap> homalg_variable_4312 := homalg_variable_4306 * (homalg_variable_8);;
gap> homalg_variable_4313 := homalg_variable_4302 * homalg_variable_4312;;
gap> homalg_variable_4314 := homalg_variable_4293 * homalg_variable_4313;;
gap> homalg_variable_4314 = homalg_variable_4299;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4293,homalg_variable_4299);; homalg_variable_4315 := homalg_variable_l[1];; homalg_variable_4316 := homalg_variable_l[2];;
gap> homalg_variable_4317 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4315 = homalg_variable_4317;
true
gap> homalg_variable_4318 := homalg_variable_4299 * homalg_variable_4316;;
gap> homalg_variable_4319 := homalg_variable_4293 + homalg_variable_4318;;
gap> homalg_variable_4315 = homalg_variable_4319;
true
gap> homalg_variable_4320 := SIH_DecideZeroColumns(homalg_variable_4293,homalg_variable_4299);;
gap> homalg_variable_4321 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4320 = homalg_variable_4321;
true
gap> homalg_variable_4322 := homalg_variable_4316 * (homalg_variable_8);;
gap> homalg_variable_4323 := homalg_variable_4299 * homalg_variable_4322;;
gap> homalg_variable_4323 = homalg_variable_4293;
true
gap> homalg_variable_4324 := SIH_DecideZeroColumns(homalg_variable_4293,homalg_variable_3536);;
gap> homalg_variable_4325 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4324 = homalg_variable_4325;
true
gap> homalg_variable_4326 := SIH_DecideZeroColumns(homalg_variable_4126,homalg_variable_4100);;
gap> homalg_variable_4327 := SI_matrix(homalg_variable_5,23,5,"0");;
gap> homalg_variable_4326 = homalg_variable_4327;
false
gap> homalg_variable_4328 := SIH_UnionOfColumns(homalg_variable_4326,homalg_variable_4100);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4328);; homalg_variable_4329 := homalg_variable_l[1];; homalg_variable_4330 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4329);
27
gap> homalg_variable_4331 := SI_matrix(homalg_variable_5,23,27,"0");;
gap> homalg_variable_4329 = homalg_variable_4331;
false
gap> SI_nrows(homalg_variable_4330);
30
gap> homalg_variable_4332 := SIH_Submatrix(homalg_variable_4330,[ 1, 2, 3, 4, 5 ],[1..27]);;
gap> homalg_variable_4333 := homalg_variable_4326 * homalg_variable_4332;;
gap> homalg_variable_4334 := SIH_Submatrix(homalg_variable_4330,[ 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 ],[1..27]);;
gap> homalg_variable_4335 := homalg_variable_4100 * homalg_variable_4334;;
gap> homalg_variable_4336 := homalg_variable_4333 + homalg_variable_4335;;
gap> homalg_variable_4329 = homalg_variable_4336;
true
gap> homalg_variable_4337 := SIH_DecideZeroColumns(homalg_variable_4295,homalg_variable_4100);;
gap> homalg_variable_4338 := SI_matrix(homalg_variable_5,23,5,"0");;
gap> homalg_variable_4337 = homalg_variable_4338;
false
gap> homalg_variable_4339 := SI_matrix(homalg_variable_5,7,5,"0");;
gap> homalg_variable_4289 = homalg_variable_4339;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4337,homalg_variable_4329);; homalg_variable_4340 := homalg_variable_l[1];; homalg_variable_4341 := homalg_variable_l[2];;
gap> homalg_variable_4342 := SI_matrix(homalg_variable_5,23,5,"0");;
gap> homalg_variable_4340 = homalg_variable_4342;
false
gap> homalg_variable_4343 := homalg_variable_4329 * homalg_variable_4341;;
gap> homalg_variable_4344 := homalg_variable_4337 + homalg_variable_4343;;
gap> homalg_variable_4340 = homalg_variable_4344;
true
gap> homalg_variable_4345 := SIH_DecideZeroColumns(homalg_variable_4337,homalg_variable_4329);;
gap> homalg_variable_4346 := SI_matrix(homalg_variable_5,23,5,"0");;
gap> homalg_variable_4345 = homalg_variable_4346;
false
gap> homalg_variable_4340 = homalg_variable_4345;
true
gap> homalg_variable_4348 := SIH_UnionOfColumns(homalg_variable_4283,homalg_variable_4115);;
gap> homalg_variable_4347 := SIH_BasisOfColumnModule(homalg_variable_4348);;
gap> SI_ncols(homalg_variable_4347);
21
gap> homalg_variable_4349 := SI_matrix(homalg_variable_5,23,21,"0");;
gap> homalg_variable_4347 = homalg_variable_4349;
false
gap> homalg_variable_4350 := SIH_DecideZeroColumns(homalg_variable_4126,homalg_variable_4347);;
gap> homalg_variable_4351 := SI_matrix(homalg_variable_5,23,5,"0");;
gap> homalg_variable_4350 = homalg_variable_4351;
false
gap> homalg_variable_4352 := SIH_UnionOfColumns(homalg_variable_4350,homalg_variable_4347);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4352);; homalg_variable_4353 := homalg_variable_l[1];; homalg_variable_4354 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4353);
26
gap> homalg_variable_4355 := SI_matrix(homalg_variable_5,23,26,"0");;
gap> homalg_variable_4353 = homalg_variable_4355;
false
gap> SI_nrows(homalg_variable_4354);
26
gap> homalg_variable_4356 := SIH_Submatrix(homalg_variable_4354,[ 1, 2, 3, 4, 5 ],[1..26]);;
gap> homalg_variable_4357 := homalg_variable_4350 * homalg_variable_4356;;
gap> homalg_variable_4358 := SIH_Submatrix(homalg_variable_4354,[ 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 ],[1..26]);;
gap> homalg_variable_4359 := homalg_variable_4347 * homalg_variable_4358;;
gap> homalg_variable_4360 := homalg_variable_4357 + homalg_variable_4359;;
gap> homalg_variable_4353 = homalg_variable_4360;
true
gap> homalg_variable_4361 := SIH_DecideZeroColumns(homalg_variable_4295,homalg_variable_4347);;
gap> homalg_variable_4362 := SI_matrix(homalg_variable_5,23,5,"0");;
gap> homalg_variable_4361 = homalg_variable_4362;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4361,homalg_variable_4353);; homalg_variable_4363 := homalg_variable_l[1];; homalg_variable_4364 := homalg_variable_l[2];;
gap> homalg_variable_4365 := SI_matrix(homalg_variable_5,23,5,"0");;
gap> homalg_variable_4363 = homalg_variable_4365;
true
gap> homalg_variable_4366 := homalg_variable_4353 * homalg_variable_4364;;
gap> homalg_variable_4367 := homalg_variable_4361 + homalg_variable_4366;;
gap> homalg_variable_4363 = homalg_variable_4367;
true
gap> homalg_variable_4368 := SIH_DecideZeroColumns(homalg_variable_4361,homalg_variable_4353);;
gap> homalg_variable_4369 := SI_matrix(homalg_variable_5,23,5,"0");;
gap> homalg_variable_4368 = homalg_variable_4369;
true
gap> homalg_variable_4371 := SIH_Submatrix(homalg_variable_4354,[ 1, 2, 3, 4, 5 ],[1..26]);;
gap> homalg_variable_4372 := homalg_variable_4364 * (homalg_variable_8);;
gap> homalg_variable_4373 := homalg_variable_4371 * homalg_variable_4372;;
gap> homalg_variable_4374 := homalg_variable_3544 * homalg_variable_4373;;
gap> homalg_variable_4375 := SIH_UnionOfRows(homalg_variable_4125,homalg_variable_4374);;
gap> homalg_variable_4376 := homalg_variable_4375 - homalg_variable_4295;;
gap> homalg_variable_4370 := SIH_DecideZeroColumns(homalg_variable_4376,homalg_variable_4347);;
gap> homalg_variable_4377 := SI_matrix(homalg_variable_5,23,5,"0");;
gap> homalg_variable_4370 = homalg_variable_4377;
true
gap> homalg_variable_4378 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4126,homalg_variable_4348);;
gap> SI_ncols(homalg_variable_4378);
4
gap> homalg_variable_4379 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4378 = homalg_variable_4379;
false
gap> homalg_variable_4380 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4378);;
gap> SI_ncols(homalg_variable_4380);
1
gap> homalg_variable_4381 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4380 = homalg_variable_4381;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_4380,[ 0 ]);
[  ]
gap> homalg_variable_4382 := SIH_BasisOfColumnModule(homalg_variable_4378);;
gap> SI_ncols(homalg_variable_4382);
4
gap> homalg_variable_4383 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4382 = homalg_variable_4383;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4378);; homalg_variable_4384 := homalg_variable_l[1];; homalg_variable_4385 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4384);
4
gap> homalg_variable_4386 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4384 = homalg_variable_4386;
false
gap> SI_nrows(homalg_variable_4385);
4
gap> homalg_variable_4387 := homalg_variable_4378 * homalg_variable_4385;;
gap> homalg_variable_4384 = homalg_variable_4387;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4382,homalg_variable_4384);; homalg_variable_4388 := homalg_variable_l[1];; homalg_variable_4389 := homalg_variable_l[2];;
gap> homalg_variable_4390 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4388 = homalg_variable_4390;
true
gap> homalg_variable_4391 := homalg_variable_4384 * homalg_variable_4389;;
gap> homalg_variable_4392 := homalg_variable_4382 + homalg_variable_4391;;
gap> homalg_variable_4388 = homalg_variable_4392;
true
gap> homalg_variable_4393 := SIH_DecideZeroColumns(homalg_variable_4382,homalg_variable_4384);;
gap> homalg_variable_4394 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4393 = homalg_variable_4394;
true
gap> homalg_variable_4395 := homalg_variable_4389 * (homalg_variable_8);;
gap> homalg_variable_4396 := homalg_variable_4385 * homalg_variable_4395;;
gap> homalg_variable_4397 := homalg_variable_4378 * homalg_variable_4396;;
gap> homalg_variable_4397 = homalg_variable_4382;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4378,homalg_variable_4382);; homalg_variable_4398 := homalg_variable_l[1];; homalg_variable_4399 := homalg_variable_l[2];;
gap> homalg_variable_4400 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4398 = homalg_variable_4400;
true
gap> homalg_variable_4401 := homalg_variable_4382 * homalg_variable_4399;;
gap> homalg_variable_4402 := homalg_variable_4378 + homalg_variable_4401;;
gap> homalg_variable_4398 = homalg_variable_4402;
true
gap> homalg_variable_4403 := SIH_DecideZeroColumns(homalg_variable_4378,homalg_variable_4382);;
gap> homalg_variable_4404 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4403 = homalg_variable_4404;
true
gap> homalg_variable_4405 := homalg_variable_4399 * (homalg_variable_8);;
gap> homalg_variable_4406 := homalg_variable_4382 * homalg_variable_4405;;
gap> homalg_variable_4406 = homalg_variable_4378;
true
gap> homalg_variable_4408 := SIH_UnionOfColumns(homalg_variable_4378,homalg_variable_3944);;
gap> homalg_variable_4407 := SIH_BasisOfColumnModule(homalg_variable_4408);;
gap> SI_ncols(homalg_variable_4407);
4
gap> homalg_variable_4409 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4407 = homalg_variable_4409;
false
gap> homalg_variable_4410 := SIH_DecideZeroColumns(homalg_variable_4378,homalg_variable_4407);;
gap> homalg_variable_4411 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4410 = homalg_variable_4411;
true
gap> homalg_variable_4413 := homalg_variable_4373 * homalg_variable_3536;;
gap> homalg_variable_4412 := SIH_DecideZeroColumns(homalg_variable_4413,homalg_variable_4407);;
gap> homalg_variable_4414 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4412 = homalg_variable_4414;
true
gap> homalg_variable_4415 := SIH_UnionOfColumns(homalg_variable_4326,homalg_variable_4100);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4415);; homalg_variable_4416 := homalg_variable_l[1];; homalg_variable_4417 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4416);
27
gap> homalg_variable_4418 := SI_matrix(homalg_variable_5,23,27,"0");;
gap> homalg_variable_4416 = homalg_variable_4418;
false
gap> SI_nrows(homalg_variable_4417);
30
gap> homalg_variable_4419 := SIH_Submatrix(homalg_variable_4417,[ 1, 2, 3, 4, 5 ],[1..27]);;
gap> homalg_variable_4420 := homalg_variable_4326 * homalg_variable_4419;;
gap> homalg_variable_4421 := SIH_Submatrix(homalg_variable_4417,[ 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 ],[1..27]);;
gap> homalg_variable_4422 := homalg_variable_4100 * homalg_variable_4421;;
gap> homalg_variable_4423 := homalg_variable_4420 + homalg_variable_4422;;
gap> homalg_variable_4416 = homalg_variable_4423;
true
gap> homalg_variable_4424 := SIH_DecideZeroColumns(homalg_variable_4242,homalg_variable_4100);;
gap> homalg_variable_4425 := SI_matrix(homalg_variable_5,23,4,"0");;
gap> homalg_variable_4424 = homalg_variable_4425;
false
gap> homalg_variable_4426 := SI_matrix(homalg_variable_5,16,4,"0");;
gap> homalg_variable_4235 = homalg_variable_4426;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4424,homalg_variable_4416);; homalg_variable_4427 := homalg_variable_l[1];; homalg_variable_4428 := homalg_variable_l[2];;
gap> homalg_variable_4429 := SI_matrix(homalg_variable_5,23,4,"0");;
gap> homalg_variable_4427 = homalg_variable_4429;
false
gap> homalg_variable_4430 := homalg_variable_4416 * homalg_variable_4428;;
gap> homalg_variable_4431 := homalg_variable_4424 + homalg_variable_4430;;
gap> homalg_variable_4427 = homalg_variable_4431;
true
gap> homalg_variable_4432 := SIH_DecideZeroColumns(homalg_variable_4424,homalg_variable_4416);;
gap> homalg_variable_4433 := SI_matrix(homalg_variable_5,23,4,"0");;
gap> homalg_variable_4432 = homalg_variable_4433;
false
gap> homalg_variable_4427 = homalg_variable_4432;
true
gap> homalg_variable_4435 := SIH_UnionOfColumns(homalg_variable_4229,homalg_variable_4115);;
gap> homalg_variable_4434 := SIH_BasisOfColumnModule(homalg_variable_4435);;
gap> SI_ncols(homalg_variable_4434);
20
gap> homalg_variable_4436 := SI_matrix(homalg_variable_5,23,20,"0");;
gap> homalg_variable_4434 = homalg_variable_4436;
false
gap> homalg_variable_4437 := SIH_DecideZeroColumns(homalg_variable_4126,homalg_variable_4434);;
gap> homalg_variable_4438 := SI_matrix(homalg_variable_5,23,5,"0");;
gap> homalg_variable_4437 = homalg_variable_4438;
false
gap> homalg_variable_4439 := SIH_UnionOfColumns(homalg_variable_4437,homalg_variable_4434);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4439);; homalg_variable_4440 := homalg_variable_l[1];; homalg_variable_4441 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4440);
27
gap> homalg_variable_4442 := SI_matrix(homalg_variable_5,23,27,"0");;
gap> homalg_variable_4440 = homalg_variable_4442;
false
gap> SI_nrows(homalg_variable_4441);
25
gap> homalg_variable_4443 := SIH_Submatrix(homalg_variable_4441,[ 1, 2, 3, 4, 5 ],[1..27]);;
gap> homalg_variable_4444 := homalg_variable_4437 * homalg_variable_4443;;
gap> homalg_variable_4445 := SIH_Submatrix(homalg_variable_4441,[ 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 ],[1..27]);;
gap> homalg_variable_4446 := homalg_variable_4434 * homalg_variable_4445;;
gap> homalg_variable_4447 := homalg_variable_4444 + homalg_variable_4446;;
gap> homalg_variable_4440 = homalg_variable_4447;
true
gap> homalg_variable_4448 := SIH_DecideZeroColumns(homalg_variable_4242,homalg_variable_4434);;
gap> homalg_variable_4449 := SI_matrix(homalg_variable_5,23,4,"0");;
gap> homalg_variable_4448 = homalg_variable_4449;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4448,homalg_variable_4440);; homalg_variable_4450 := homalg_variable_l[1];; homalg_variable_4451 := homalg_variable_l[2];;
gap> homalg_variable_4452 := SI_matrix(homalg_variable_5,23,4,"0");;
gap> homalg_variable_4450 = homalg_variable_4452;
true
gap> homalg_variable_4453 := homalg_variable_4440 * homalg_variable_4451;;
gap> homalg_variable_4454 := homalg_variable_4448 + homalg_variable_4453;;
gap> homalg_variable_4450 = homalg_variable_4454;
true
gap> homalg_variable_4455 := SIH_DecideZeroColumns(homalg_variable_4448,homalg_variable_4440);;
gap> homalg_variable_4456 := SI_matrix(homalg_variable_5,23,4,"0");;
gap> homalg_variable_4455 = homalg_variable_4456;
true
gap> homalg_variable_4458 := SI_matrix(homalg_variable_5,16,4,"0");;
gap> homalg_variable_4459 := SIH_Submatrix(homalg_variable_4441,[ 1, 2, 3, 4, 5 ],[1..27]);;
gap> homalg_variable_4460 := homalg_variable_4451 * (homalg_variable_8);;
gap> homalg_variable_4461 := homalg_variable_4459 * homalg_variable_4460;;
gap> homalg_variable_4462 := homalg_variable_3544 * homalg_variable_4461;;
gap> homalg_variable_4463 := SIH_UnionOfRows(homalg_variable_4458,homalg_variable_4462);;
gap> homalg_variable_4464 := homalg_variable_4463 - homalg_variable_4242;;
gap> homalg_variable_4457 := SIH_DecideZeroColumns(homalg_variable_4464,homalg_variable_4434);;
gap> homalg_variable_4465 := SI_matrix(homalg_variable_5,23,4,"0");;
gap> homalg_variable_4457 = homalg_variable_4465;
true
gap> homalg_variable_4466 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4126,homalg_variable_4435);;
gap> SI_ncols(homalg_variable_4466);
4
gap> homalg_variable_4467 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4466 = homalg_variable_4467;
false
gap> homalg_variable_4468 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4466);;
gap> SI_ncols(homalg_variable_4468);
1
gap> homalg_variable_4469 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4468 = homalg_variable_4469;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_4468,[ 0 ]);
[  ]
gap> homalg_variable_4470 := SIH_BasisOfColumnModule(homalg_variable_4466);;
gap> SI_ncols(homalg_variable_4470);
4
gap> homalg_variable_4471 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4470 = homalg_variable_4471;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4466);; homalg_variable_4472 := homalg_variable_l[1];; homalg_variable_4473 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4472);
4
gap> homalg_variable_4474 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4472 = homalg_variable_4474;
false
gap> SI_nrows(homalg_variable_4473);
4
gap> homalg_variable_4475 := homalg_variable_4466 * homalg_variable_4473;;
gap> homalg_variable_4472 = homalg_variable_4475;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4470,homalg_variable_4472);; homalg_variable_4476 := homalg_variable_l[1];; homalg_variable_4477 := homalg_variable_l[2];;
gap> homalg_variable_4478 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4476 = homalg_variable_4478;
true
gap> homalg_variable_4479 := homalg_variable_4472 * homalg_variable_4477;;
gap> homalg_variable_4480 := homalg_variable_4470 + homalg_variable_4479;;
gap> homalg_variable_4476 = homalg_variable_4480;
true
gap> homalg_variable_4481 := SIH_DecideZeroColumns(homalg_variable_4470,homalg_variable_4472);;
gap> homalg_variable_4482 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4481 = homalg_variable_4482;
true
gap> homalg_variable_4483 := homalg_variable_4477 * (homalg_variable_8);;
gap> homalg_variable_4484 := homalg_variable_4473 * homalg_variable_4483;;
gap> homalg_variable_4485 := homalg_variable_4466 * homalg_variable_4484;;
gap> homalg_variable_4485 = homalg_variable_4470;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4466,homalg_variable_4470);; homalg_variable_4486 := homalg_variable_l[1];; homalg_variable_4487 := homalg_variable_l[2];;
gap> homalg_variable_4488 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4486 = homalg_variable_4488;
true
gap> homalg_variable_4489 := homalg_variable_4470 * homalg_variable_4487;;
gap> homalg_variable_4490 := homalg_variable_4466 + homalg_variable_4489;;
gap> homalg_variable_4486 = homalg_variable_4490;
true
gap> homalg_variable_4491 := SIH_DecideZeroColumns(homalg_variable_4466,homalg_variable_4470);;
gap> homalg_variable_4492 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4491 = homalg_variable_4492;
true
gap> homalg_variable_4493 := homalg_variable_4487 * (homalg_variable_8);;
gap> homalg_variable_4494 := homalg_variable_4470 * homalg_variable_4493;;
gap> homalg_variable_4494 = homalg_variable_4466;
true
gap> homalg_variable_4496 := SIH_UnionOfColumns(homalg_variable_4466,homalg_variable_3944);;
gap> homalg_variable_4495 := SIH_BasisOfColumnModule(homalg_variable_4496);;
gap> SI_ncols(homalg_variable_4495);
4
gap> homalg_variable_4497 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4495 = homalg_variable_4497;
false
gap> homalg_variable_4498 := SIH_DecideZeroColumns(homalg_variable_4466,homalg_variable_4495);;
gap> homalg_variable_4499 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4498 = homalg_variable_4499;
true
gap> for _del in [ "homalg_variable_3982", "homalg_variable_3984", "homalg_variable_3987", "homalg_variable_3988", "homalg_variable_3989", "homalg_variable_3990", "homalg_variable_3991", "homalg_variable_3992", "homalg_variable_3993", "homalg_variable_3994", "homalg_variable_3995", "homalg_variable_3996", "homalg_variable_3997", "homalg_variable_3998", "homalg_variable_3999", "homalg_variable_4000", "homalg_variable_4001", "homalg_variable_4002", "homalg_variable_4003", "homalg_variable_4004", "homalg_variable_4005", "homalg_variable_4006", "homalg_variable_4007", "homalg_variable_4009", "homalg_variable_4010", "homalg_variable_4011", "homalg_variable_4014", "homalg_variable_4015", "homalg_variable_4016", "homalg_variable_4017", "homalg_variable_4018", "homalg_variable_4020", "homalg_variable_4021", "homalg_variable_4022", "homalg_variable_4023", "homalg_variable_4024", "homalg_variable_4025", "homalg_variable_4027", "homalg_variable_4028", "homalg_variable_4031", "homalg_variable_4032", "homalg_variable_4033", "homalg_variable_4038", "homalg_variable_4040", "homalg_variable_4043", "homalg_variable_4044", "homalg_variable_4045", "homalg_variable_4046", "homalg_variable_4047", "homalg_variable_4048", "homalg_variable_4049", "homalg_variable_4050", "homalg_variable_4051", "homalg_variable_4052", "homalg_variable_4053", "homalg_variable_4054", "homalg_variable_4055", "homalg_variable_4056", "homalg_variable_4057", "homalg_variable_4058", "homalg_variable_4059", "homalg_variable_4060", "homalg_variable_4061", "homalg_variable_4062", "homalg_variable_4063", "homalg_variable_4065", "homalg_variable_4070", "homalg_variable_4072", "homalg_variable_4074", "homalg_variable_4077", "homalg_variable_4078", "homalg_variable_4079", "homalg_variable_4080", "homalg_variable_4081", "homalg_variable_4082", "homalg_variable_4083", "homalg_variable_4084", "homalg_variable_4085", "homalg_variable_4086", "homalg_variable_4087", "homalg_variable_4088", "homalg_variable_4089", "homalg_variable_4090", "homalg_variable_4091", "homalg_variable_4092", "homalg_variable_4093", "homalg_variable_4094", "homalg_variable_4095", "homalg_variable_4096", "homalg_variable_4097", "homalg_variable_4116", "homalg_variable_4117", "homalg_variable_4118", "homalg_variable_4127", "homalg_variable_4129", "homalg_variable_4131", "homalg_variable_4134", "homalg_variable_4135", "homalg_variable_4136", "homalg_variable_4137", "homalg_variable_4138", "homalg_variable_4139", "homalg_variable_4140", "homalg_variable_4141", "homalg_variable_4142", "homalg_variable_4143", "homalg_variable_4144", "homalg_variable_4145", "homalg_variable_4148", "homalg_variable_4149", "homalg_variable_4150", "homalg_variable_4151", "homalg_variable_4152", "homalg_variable_4154", "homalg_variable_4155", "homalg_variable_4156", "homalg_variable_4172", "homalg_variable_4173", "homalg_variable_4174", "homalg_variable_4175", "homalg_variable_4178", "homalg_variable_4179", "homalg_variable_4180", "homalg_variable_4181", "homalg_variable_4185", "homalg_variable_4187", "homalg_variable_4189", "homalg_variable_4193", "homalg_variable_4196", "homalg_variable_4197", "homalg_variable_4198", "homalg_variable_4199", "homalg_variable_4200", "homalg_variable_4203", "homalg_variable_4204", "homalg_variable_4205", "homalg_variable_4206", "homalg_variable_4207", "homalg_variable_4208", "homalg_variable_4209", "homalg_variable_4210", "homalg_variable_4211", "homalg_variable_4212", "homalg_variable_4213", "homalg_variable_4214", "homalg_variable_4230", "homalg_variable_4233", "homalg_variable_4236", "homalg_variable_4237", "homalg_variable_4238", "homalg_variable_4239", "homalg_variable_4243", "homalg_variable_4245", "homalg_variable_4247", "homalg_variable_4250", "homalg_variable_4251", "homalg_variable_4252", "homalg_variable_4253", "homalg_variable_4254", "homalg_variable_4255", "homalg_variable_4256", "homalg_variable_4257", "homalg_variable_4258", "homalg_variable_4259", "homalg_variable_4260", "homalg_variable_4261", "homalg_variable_4265", "homalg_variable_4266", "homalg_variable_4267", "homalg_variable_4268", "homalg_variable_4270", "homalg_variable_4271", "homalg_variable_4272", "homalg_variable_4284", "homalg_variable_4285", "homalg_variable_4286", "homalg_variable_4287", "homalg_variable_4288", "homalg_variable_4290", "homalg_variable_4291", "homalg_variable_4292", "homalg_variable_4296", "homalg_variable_4298", "homalg_variable_4303", "homalg_variable_4304", "homalg_variable_4305", "homalg_variable_4306", "homalg_variable_4307", "homalg_variable_4308", "homalg_variable_4309", "homalg_variable_4310", "homalg_variable_4311", "homalg_variable_4312", "homalg_variable_4313", "homalg_variable_4314", "homalg_variable_4315", "homalg_variable_4316", "homalg_variable_4317", "homalg_variable_4318", "homalg_variable_4319", "homalg_variable_4320", "homalg_variable_4321", "homalg_variable_4322", "homalg_variable_4323", "homalg_variable_4324", "homalg_variable_4325", "homalg_variable_4327", "homalg_variable_4331", "homalg_variable_4332", "homalg_variable_4333", "homalg_variable_4334", "homalg_variable_4335", "homalg_variable_4336", "homalg_variable_4338", "homalg_variable_4342", "homalg_variable_4343", "homalg_variable_4344", "homalg_variable_4345", "homalg_variable_4346", "homalg_variable_4349", "homalg_variable_4351", "homalg_variable_4355", "homalg_variable_4356", "homalg_variable_4357", "homalg_variable_4358", "homalg_variable_4359", "homalg_variable_4360", "homalg_variable_4362", "homalg_variable_4365", "homalg_variable_4366", "homalg_variable_4367", "homalg_variable_4370", "homalg_variable_4374", "homalg_variable_4375", "homalg_variable_4376", "homalg_variable_4377", "homalg_variable_4379", "homalg_variable_4381", "homalg_variable_4383", "homalg_variable_4386", "homalg_variable_4387", "homalg_variable_4388", "homalg_variable_4389", "homalg_variable_4390", "homalg_variable_4391", "homalg_variable_4392", "homalg_variable_4393", "homalg_variable_4394", "homalg_variable_4395", "homalg_variable_4396", "homalg_variable_4397", "homalg_variable_4400", "homalg_variable_4401", "homalg_variable_4402", "homalg_variable_4403", "homalg_variable_4404", "homalg_variable_4406", "homalg_variable_4409", "homalg_variable_4410", "homalg_variable_4411", "homalg_variable_4412", "homalg_variable_4413", "homalg_variable_4414", "homalg_variable_4418", "homalg_variable_4419", "homalg_variable_4420", "homalg_variable_4421", "homalg_variable_4422", "homalg_variable_4423", "homalg_variable_4425", "homalg_variable_4426", "homalg_variable_4429", "homalg_variable_4430", "homalg_variable_4431", "homalg_variable_4432", "homalg_variable_4433", "homalg_variable_4436", "homalg_variable_4438", "homalg_variable_4442", "homalg_variable_4443", "homalg_variable_4444", "homalg_variable_4445", "homalg_variable_4446", "homalg_variable_4447", "homalg_variable_4449", "homalg_variable_4452", "homalg_variable_4455", "homalg_variable_4456", "homalg_variable_4457", "homalg_variable_4458", "homalg_variable_4462", "homalg_variable_4463", "homalg_variable_4464", "homalg_variable_4465", "homalg_variable_4467", "homalg_variable_4469", "homalg_variable_4471", "homalg_variable_4474", "homalg_variable_4475", "homalg_variable_4478", "homalg_variable_4479", "homalg_variable_4480" ] do UnbindGlobal( _del ); od;;
gap> homalg_variable_4501 := homalg_variable_4461 * homalg_variable_3358;;
gap> homalg_variable_4500 := SIH_DecideZeroColumns(homalg_variable_4501,homalg_variable_4495);;
gap> homalg_variable_4502 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_4500 = homalg_variable_4502;
true
gap> homalg_variable_4503 := SIH_UnionOfColumns(homalg_variable_4326,homalg_variable_4100);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4503);; homalg_variable_4504 := homalg_variable_l[1];; homalg_variable_4505 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4504);
27
gap> homalg_variable_4506 := SI_matrix(homalg_variable_5,23,27,"0");;
gap> homalg_variable_4504 = homalg_variable_4506;
false
gap> SI_nrows(homalg_variable_4505);
30
gap> homalg_variable_4507 := SIH_Submatrix(homalg_variable_4505,[ 1, 2, 3, 4, 5 ],[1..27]);;
gap> homalg_variable_4508 := homalg_variable_4326 * homalg_variable_4507;;
gap> homalg_variable_4509 := SIH_Submatrix(homalg_variable_4505,[ 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 ],[1..27]);;
gap> homalg_variable_4510 := homalg_variable_4100 * homalg_variable_4509;;
gap> homalg_variable_4511 := homalg_variable_4508 + homalg_variable_4510;;
gap> homalg_variable_4504 = homalg_variable_4511;
true
gap> homalg_variable_4512 := SIH_DecideZeroColumns(homalg_variable_4184,homalg_variable_4100);;
gap> homalg_variable_4513 := SI_matrix(homalg_variable_5,23,1,"0");;
gap> homalg_variable_4512 = homalg_variable_4513;
false
gap> homalg_variable_4514 := SI_matrix(homalg_variable_5,16,1,"0");;
gap> homalg_variable_4177 = homalg_variable_4514;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4512,homalg_variable_4504);; homalg_variable_4515 := homalg_variable_l[1];; homalg_variable_4516 := homalg_variable_l[2];;
gap> homalg_variable_4517 := SI_matrix(homalg_variable_5,23,1,"0");;
gap> homalg_variable_4515 = homalg_variable_4517;
true
gap> homalg_variable_4518 := homalg_variable_4504 * homalg_variable_4516;;
gap> homalg_variable_4519 := homalg_variable_4512 + homalg_variable_4518;;
gap> homalg_variable_4515 = homalg_variable_4519;
true
gap> homalg_variable_4520 := SIH_DecideZeroColumns(homalg_variable_4512,homalg_variable_4504);;
gap> homalg_variable_4521 := SI_matrix(homalg_variable_5,23,1,"0");;
gap> homalg_variable_4520 = homalg_variable_4521;
true
gap> homalg_variable_4523 := SI_matrix(homalg_variable_5,16,1,"0");;
gap> homalg_variable_4524 := SIH_Submatrix(homalg_variable_4505,[ 1, 2, 3, 4, 5 ],[1..27]);;
gap> homalg_variable_4525 := homalg_variable_4516 * (homalg_variable_8);;
gap> homalg_variable_4526 := homalg_variable_4524 * homalg_variable_4525;;
gap> homalg_variable_4527 := homalg_variable_3544 * homalg_variable_4526;;
gap> homalg_variable_4528 := SIH_UnionOfRows(homalg_variable_4523,homalg_variable_4527);;
gap> homalg_variable_4529 := homalg_variable_4528 - homalg_variable_4184;;
gap> homalg_variable_4522 := SIH_DecideZeroColumns(homalg_variable_4529,homalg_variable_4100);;
gap> homalg_variable_4530 := SI_matrix(homalg_variable_5,23,1,"0");;
gap> homalg_variable_4522 = homalg_variable_4530;
true
gap> homalg_variable_4531 := SIH_UnionOfColumns(homalg_variable_4326,homalg_variable_4100);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4531);; homalg_variable_4532 := homalg_variable_l[1];; homalg_variable_4533 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4532);
27
gap> homalg_variable_4534 := SI_matrix(homalg_variable_5,23,27,"0");;
gap> homalg_variable_4532 = homalg_variable_4534;
false
gap> SI_nrows(homalg_variable_4533);
30
gap> homalg_variable_4535 := SIH_Submatrix(homalg_variable_4533,[ 1, 2, 3, 4, 5 ],[1..27]);;
gap> homalg_variable_4536 := homalg_variable_4326 * homalg_variable_4535;;
gap> homalg_variable_4537 := SIH_Submatrix(homalg_variable_4533,[ 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 ],[1..27]);;
gap> homalg_variable_4538 := homalg_variable_4100 * homalg_variable_4537;;
gap> homalg_variable_4539 := homalg_variable_4536 + homalg_variable_4538;;
gap> homalg_variable_4532 = homalg_variable_4539;
true
gap> homalg_variable_4540 := SIH_DecideZeroColumns(homalg_variable_4170,homalg_variable_4100);;
gap> homalg_variable_4541 := SI_matrix(homalg_variable_5,23,1,"0");;
gap> homalg_variable_4540 = homalg_variable_4541;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4540,homalg_variable_4532);; homalg_variable_4542 := homalg_variable_l[1];; homalg_variable_4543 := homalg_variable_l[2];;
gap> homalg_variable_4544 := SI_matrix(homalg_variable_5,23,1,"0");;
gap> homalg_variable_4542 = homalg_variable_4544;
true
gap> homalg_variable_4545 := homalg_variable_4532 * homalg_variable_4543;;
gap> homalg_variable_4546 := homalg_variable_4540 + homalg_variable_4545;;
gap> homalg_variable_4542 = homalg_variable_4546;
true
gap> homalg_variable_4547 := SIH_DecideZeroColumns(homalg_variable_4540,homalg_variable_4532);;
gap> homalg_variable_4548 := SI_matrix(homalg_variable_5,23,1,"0");;
gap> homalg_variable_4547 = homalg_variable_4548;
true
gap> homalg_variable_4550 := SI_matrix(homalg_variable_5,16,1,"0");;
gap> homalg_variable_4551 := SIH_Submatrix(homalg_variable_4533,[ 1, 2, 3, 4, 5 ],[1..27]);;
gap> homalg_variable_4552 := homalg_variable_4543 * (homalg_variable_8);;
gap> homalg_variable_4553 := homalg_variable_4551 * homalg_variable_4552;;
gap> homalg_variable_4554 := homalg_variable_3544 * homalg_variable_4553;;
gap> homalg_variable_4555 := SIH_UnionOfRows(homalg_variable_4550,homalg_variable_4554);;
gap> homalg_variable_4556 := homalg_variable_4555 - homalg_variable_4170;;
gap> homalg_variable_4549 := SIH_DecideZeroColumns(homalg_variable_4556,homalg_variable_4100);;
gap> homalg_variable_4557 := SI_matrix(homalg_variable_5,23,1,"0");;
gap> homalg_variable_4549 = homalg_variable_4557;
true
gap> homalg_variable_4559 := homalg_variable_4168 * homalg_variable_2961;;
gap> homalg_variable_4560 := SI_matrix(homalg_variable_5,7,3,"0");;
gap> homalg_variable_4561 := SIH_UnionOfRows(homalg_variable_4559,homalg_variable_4560);;
gap> homalg_variable_4562 := SIH_UnionOfColumns(homalg_variable_4561,homalg_variable_4115);;
gap> homalg_variable_4558 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4126,homalg_variable_4562);;
gap> SI_ncols(homalg_variable_4558);
6
gap> homalg_variable_4563 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4558 = homalg_variable_4563;
false
gap> homalg_variable_4564 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4558);;
gap> SI_ncols(homalg_variable_4564);
4
gap> homalg_variable_4565 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_4564 = homalg_variable_4565;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_4564,[ 0 ]);
[  ]
gap> homalg_variable_4566 := SIH_BasisOfColumnModule(homalg_variable_4558);;
gap> SI_ncols(homalg_variable_4566);
6
gap> homalg_variable_4567 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4566 = homalg_variable_4567;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4558);; homalg_variable_4568 := homalg_variable_l[1];; homalg_variable_4569 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4568);
6
gap> homalg_variable_4570 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4568 = homalg_variable_4570;
false
gap> SI_nrows(homalg_variable_4569);
6
gap> homalg_variable_4571 := homalg_variable_4558 * homalg_variable_4569;;
gap> homalg_variable_4568 = homalg_variable_4571;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4566,homalg_variable_4568);; homalg_variable_4572 := homalg_variable_l[1];; homalg_variable_4573 := homalg_variable_l[2];;
gap> homalg_variable_4574 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4572 = homalg_variable_4574;
true
gap> homalg_variable_4575 := homalg_variable_4568 * homalg_variable_4573;;
gap> homalg_variable_4576 := homalg_variable_4566 + homalg_variable_4575;;
gap> homalg_variable_4572 = homalg_variable_4576;
true
gap> homalg_variable_4577 := SIH_DecideZeroColumns(homalg_variable_4566,homalg_variable_4568);;
gap> homalg_variable_4578 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4577 = homalg_variable_4578;
true
gap> homalg_variable_4579 := homalg_variable_4573 * (homalg_variable_8);;
gap> homalg_variable_4580 := homalg_variable_4569 * homalg_variable_4579;;
gap> homalg_variable_4581 := homalg_variable_4558 * homalg_variable_4580;;
gap> homalg_variable_4581 = homalg_variable_4566;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4558,homalg_variable_4566);; homalg_variable_4582 := homalg_variable_l[1];; homalg_variable_4583 := homalg_variable_l[2];;
gap> homalg_variable_4584 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4582 = homalg_variable_4584;
true
gap> homalg_variable_4585 := homalg_variable_4566 * homalg_variable_4583;;
gap> homalg_variable_4586 := homalg_variable_4558 + homalg_variable_4585;;
gap> homalg_variable_4582 = homalg_variable_4586;
true
gap> homalg_variable_4587 := SIH_DecideZeroColumns(homalg_variable_4558,homalg_variable_4566);;
gap> homalg_variable_4588 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4587 = homalg_variable_4588;
true
gap> homalg_variable_4589 := homalg_variable_4583 * (homalg_variable_8);;
gap> homalg_variable_4590 := homalg_variable_4566 * homalg_variable_4589;;
gap> homalg_variable_4590 = homalg_variable_4558;
true
gap> homalg_variable_4591 := SIH_DecideZeroColumns(homalg_variable_4558,homalg_variable_3944);;
gap> homalg_variable_4592 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4591 = homalg_variable_4592;
true
gap> homalg_variable_4594 := homalg_variable_4553 * homalg_variable_2961;;
gap> homalg_variable_4593 := SIH_DecideZeroColumns(homalg_variable_4594,homalg_variable_3944);;
gap> homalg_variable_4595 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_4593 = homalg_variable_4595;
true
gap> homalg_variable_4596 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4553,homalg_variable_3944);;
gap> SI_ncols(homalg_variable_4596);
3
gap> homalg_variable_4597 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_4596 = homalg_variable_4597;
false
gap> homalg_variable_4598 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4596);;
gap> SI_ncols(homalg_variable_4598);
3
gap> homalg_variable_4599 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_4598 = homalg_variable_4599;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_4598,[ 0 ]);
[  ]
gap> homalg_variable_4600 := SIH_BasisOfColumnModule(homalg_variable_4596);;
gap> SI_ncols(homalg_variable_4600);
3
gap> homalg_variable_4601 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_4600 = homalg_variable_4601;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4596);; homalg_variable_4602 := homalg_variable_l[1];; homalg_variable_4603 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4602);
3
gap> homalg_variable_4604 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_4602 = homalg_variable_4604;
false
gap> SI_nrows(homalg_variable_4603);
3
gap> homalg_variable_4605 := homalg_variable_4596 * homalg_variable_4603;;
gap> homalg_variable_4602 = homalg_variable_4605;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4600,homalg_variable_4602);; homalg_variable_4606 := homalg_variable_l[1];; homalg_variable_4607 := homalg_variable_l[2];;
gap> homalg_variable_4608 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_4606 = homalg_variable_4608;
true
gap> homalg_variable_4609 := homalg_variable_4602 * homalg_variable_4607;;
gap> homalg_variable_4610 := homalg_variable_4600 + homalg_variable_4609;;
gap> homalg_variable_4606 = homalg_variable_4610;
true
gap> homalg_variable_4611 := SIH_DecideZeroColumns(homalg_variable_4600,homalg_variable_4602);;
gap> homalg_variable_4612 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_4611 = homalg_variable_4612;
true
gap> homalg_variable_4613 := homalg_variable_4607 * (homalg_variable_8);;
gap> homalg_variable_4614 := homalg_variable_4603 * homalg_variable_4613;;
gap> homalg_variable_4615 := homalg_variable_4596 * homalg_variable_4614;;
gap> homalg_variable_4615 = homalg_variable_4600;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4596,homalg_variable_4600);; homalg_variable_4616 := homalg_variable_l[1];; homalg_variable_4617 := homalg_variable_l[2];;
gap> homalg_variable_4618 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_4616 = homalg_variable_4618;
true
gap> homalg_variable_4619 := homalg_variable_4600 * homalg_variable_4617;;
gap> homalg_variable_4620 := homalg_variable_4596 + homalg_variable_4619;;
gap> homalg_variable_4616 = homalg_variable_4620;
true
gap> homalg_variable_4621 := SIH_DecideZeroColumns(homalg_variable_4596,homalg_variable_4600);;
gap> homalg_variable_4622 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_4621 = homalg_variable_4622;
true
gap> homalg_variable_4623 := homalg_variable_4617 * (homalg_variable_8);;
gap> homalg_variable_4624 := homalg_variable_4600 * homalg_variable_4623;;
gap> homalg_variable_4624 = homalg_variable_4596;
true
gap> homalg_variable_4625 := SIH_DecideZeroColumns(homalg_variable_4596,homalg_variable_2959);;
gap> homalg_variable_4626 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_4625 = homalg_variable_4626;
true
gap> homalg_variable_4628 := SIH_UnionOfColumns(homalg_variable_4553,homalg_variable_3944);;
gap> homalg_variable_4627 := SIH_BasisOfColumnModule(homalg_variable_4628);;
gap> SI_ncols(homalg_variable_4627);
5
gap> homalg_variable_4629 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_4627 = homalg_variable_4629;
false
gap> homalg_variable_4630 := SIH_DecideZeroColumns(homalg_variable_4553,homalg_variable_4627);;
gap> homalg_variable_4631 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_4630 = homalg_variable_4631;
true
gap> homalg_variable_4633 := homalg_variable_4526 * homalg_variable_3037;;
gap> homalg_variable_4632 := SIH_DecideZeroColumns(homalg_variable_4633,homalg_variable_4627);;
gap> homalg_variable_4634 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_4632 = homalg_variable_4634;
true
gap> homalg_variable_4635 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4526,homalg_variable_4628);;
gap> SI_ncols(homalg_variable_4635);
2
gap> homalg_variable_4636 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4635 = homalg_variable_4636;
false
gap> homalg_variable_4637 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4635);;
gap> SI_ncols(homalg_variable_4637);
1
gap> homalg_variable_4638 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_4637 = homalg_variable_4638;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_4637,[ 0 ]);
[  ]
gap> homalg_variable_4639 := SIH_BasisOfColumnModule(homalg_variable_4635);;
gap> SI_ncols(homalg_variable_4639);
2
gap> homalg_variable_4640 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4639 = homalg_variable_4640;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4635);; homalg_variable_4641 := homalg_variable_l[1];; homalg_variable_4642 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4641);
2
gap> homalg_variable_4643 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4641 = homalg_variable_4643;
false
gap> SI_nrows(homalg_variable_4642);
2
gap> homalg_variable_4644 := homalg_variable_4635 * homalg_variable_4642;;
gap> homalg_variable_4641 = homalg_variable_4644;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4639,homalg_variable_4641);; homalg_variable_4645 := homalg_variable_l[1];; homalg_variable_4646 := homalg_variable_l[2];;
gap> homalg_variable_4647 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4645 = homalg_variable_4647;
true
gap> homalg_variable_4648 := homalg_variable_4641 * homalg_variable_4646;;
gap> homalg_variable_4649 := homalg_variable_4639 + homalg_variable_4648;;
gap> homalg_variable_4645 = homalg_variable_4649;
true
gap> homalg_variable_4650 := SIH_DecideZeroColumns(homalg_variable_4639,homalg_variable_4641);;
gap> homalg_variable_4651 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4650 = homalg_variable_4651;
true
gap> homalg_variable_4652 := homalg_variable_4646 * (homalg_variable_8);;
gap> homalg_variable_4653 := homalg_variable_4642 * homalg_variable_4652;;
gap> homalg_variable_4654 := homalg_variable_4635 * homalg_variable_4653;;
gap> homalg_variable_4654 = homalg_variable_4639;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4635,homalg_variable_4639);; homalg_variable_4655 := homalg_variable_l[1];; homalg_variable_4656 := homalg_variable_l[2];;
gap> homalg_variable_4657 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4655 = homalg_variable_4657;
true
gap> homalg_variable_4658 := homalg_variable_4639 * homalg_variable_4656;;
gap> homalg_variable_4659 := homalg_variable_4635 + homalg_variable_4658;;
gap> homalg_variable_4655 = homalg_variable_4659;
true
gap> homalg_variable_4660 := SIH_DecideZeroColumns(homalg_variable_4635,homalg_variable_4639);;
gap> homalg_variable_4661 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4660 = homalg_variable_4661;
true
gap> homalg_variable_4662 := homalg_variable_4656 * (homalg_variable_8);;
gap> homalg_variable_4663 := homalg_variable_4639 * homalg_variable_4662;;
gap> homalg_variable_4663 = homalg_variable_4635;
true
gap> homalg_variable_4664 := SIH_DecideZeroColumns(homalg_variable_4635,homalg_variable_3037);;
gap> homalg_variable_4665 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4664 = homalg_variable_4665;
true
gap> homalg_variable_4667 := SIH_UnionOfColumns(homalg_variable_4171,homalg_variable_4115);;
gap> homalg_variable_4666 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4126,homalg_variable_4667);;
gap> SI_ncols(homalg_variable_4666);
5
gap> homalg_variable_4668 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_4666 = homalg_variable_4668;
false
gap> homalg_variable_4669 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4666);;
gap> SI_ncols(homalg_variable_4669);
2
gap> homalg_variable_4670 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_4669 = homalg_variable_4670;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_4669,[ 0 ]);
[ [ 2, 3 ] ]
gap> homalg_variable_4672 := SIH_Submatrix(homalg_variable_4666,[1..5],[ 1, 2, 4, 5 ]);;
gap> homalg_variable_4671 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4672);;
gap> SI_ncols(homalg_variable_4671);
1
gap> homalg_variable_4673 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4671 = homalg_variable_4673;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_4671,[ 0 ]);
[  ]
gap> homalg_variable_4674 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4672 = homalg_variable_4674;
false
gap> homalg_variable_4675 := SIH_BasisOfColumnModule(homalg_variable_4666);;
gap> SI_ncols(homalg_variable_4675);
5
gap> homalg_variable_4676 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_4675 = homalg_variable_4676;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4672);; homalg_variable_4677 := homalg_variable_l[1];; homalg_variable_4678 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4677);
5
gap> homalg_variable_4679 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_4677 = homalg_variable_4679;
false
gap> SI_nrows(homalg_variable_4678);
4
gap> homalg_variable_4680 := homalg_variable_4672 * homalg_variable_4678;;
gap> homalg_variable_4677 = homalg_variable_4680;
true
gap> homalg_variable_4677 = homalg_variable_18;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4675,homalg_variable_4677);; homalg_variable_4681 := homalg_variable_l[1];; homalg_variable_4682 := homalg_variable_l[2];;
gap> homalg_variable_4683 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_4681 = homalg_variable_4683;
true
gap> homalg_variable_4684 := homalg_variable_4677 * homalg_variable_4682;;
gap> homalg_variable_4685 := homalg_variable_4675 + homalg_variable_4684;;
gap> homalg_variable_4681 = homalg_variable_4685;
true
gap> homalg_variable_4686 := SIH_DecideZeroColumns(homalg_variable_4675,homalg_variable_4677);;
gap> homalg_variable_4687 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_4686 = homalg_variable_4687;
true
gap> homalg_variable_4688 := homalg_variable_4682 * (homalg_variable_8);;
gap> homalg_variable_4689 := homalg_variable_4678 * homalg_variable_4688;;
gap> homalg_variable_4690 := homalg_variable_4672 * homalg_variable_4689;;
gap> homalg_variable_4690 = homalg_variable_4675;
true
gap> homalg_variable_4675 = homalg_variable_18;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4672,homalg_variable_4675);; homalg_variable_4691 := homalg_variable_l[1];; homalg_variable_4692 := homalg_variable_l[2];;
gap> homalg_variable_4693 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4691 = homalg_variable_4693;
true
gap> homalg_variable_4694 := homalg_variable_4675 * homalg_variable_4692;;
gap> homalg_variable_4695 := homalg_variable_4672 + homalg_variable_4694;;
gap> homalg_variable_4691 = homalg_variable_4695;
true
gap> homalg_variable_4696 := SIH_DecideZeroColumns(homalg_variable_4672,homalg_variable_4675);;
gap> homalg_variable_4697 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4696 = homalg_variable_4697;
true
gap> homalg_variable_4698 := homalg_variable_4692 * (homalg_variable_8);;
gap> homalg_variable_4699 := homalg_variable_4675 * homalg_variable_4698;;
gap> homalg_variable_4699 = homalg_variable_4672;
true
gap> homalg_variable_4701 := SIH_UnionOfColumns(homalg_variable_4553,homalg_variable_4526);;
gap> homalg_variable_4702 := SIH_UnionOfColumns(homalg_variable_4701,homalg_variable_3944);;
gap> homalg_variable_4700 := SIH_BasisOfColumnModule(homalg_variable_4702);;
gap> SI_ncols(homalg_variable_4700);
4
gap> homalg_variable_4703 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4700 = homalg_variable_4703;
false
gap> homalg_variable_4704 := SIH_DecideZeroColumns(homalg_variable_4701,homalg_variable_4700);;
gap> homalg_variable_4705 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_4704 = homalg_variable_4705;
true
gap> homalg_variable_4707 := homalg_variable_4461 * homalg_variable_3358;;
gap> homalg_variable_4706 := SIH_DecideZeroColumns(homalg_variable_4707,homalg_variable_4700);;
gap> homalg_variable_4708 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_4706 = homalg_variable_4708;
true
gap> homalg_variable_4709 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4461,homalg_variable_4702);;
gap> SI_ncols(homalg_variable_4709);
5
gap> homalg_variable_4710 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4709 = homalg_variable_4710;
false
gap> homalg_variable_4711 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4709);;
gap> SI_ncols(homalg_variable_4711);
1
gap> homalg_variable_4712 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_4711 = homalg_variable_4712;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_4711,[ 0 ]);
[  ]
gap> homalg_variable_4713 := SIH_BasisOfColumnModule(homalg_variable_4709);;
gap> SI_ncols(homalg_variable_4713);
5
gap> homalg_variable_4714 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4713 = homalg_variable_4714;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4709);; homalg_variable_4715 := homalg_variable_l[1];; homalg_variable_4716 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4715);
5
gap> homalg_variable_4717 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4715 = homalg_variable_4717;
false
gap> SI_nrows(homalg_variable_4716);
5
gap> homalg_variable_4718 := homalg_variable_4709 * homalg_variable_4716;;
gap> homalg_variable_4715 = homalg_variable_4718;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4713,homalg_variable_4715);; homalg_variable_4719 := homalg_variable_l[1];; homalg_variable_4720 := homalg_variable_l[2];;
gap> homalg_variable_4721 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4719 = homalg_variable_4721;
true
gap> homalg_variable_4722 := homalg_variable_4715 * homalg_variable_4720;;
gap> homalg_variable_4723 := homalg_variable_4713 + homalg_variable_4722;;
gap> homalg_variable_4719 = homalg_variable_4723;
true
gap> homalg_variable_4724 := SIH_DecideZeroColumns(homalg_variable_4713,homalg_variable_4715);;
gap> homalg_variable_4725 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4724 = homalg_variable_4725;
true
gap> homalg_variable_4726 := homalg_variable_4720 * (homalg_variable_8);;
gap> homalg_variable_4727 := homalg_variable_4716 * homalg_variable_4726;;
gap> homalg_variable_4728 := homalg_variable_4709 * homalg_variable_4727;;
gap> homalg_variable_4728 = homalg_variable_4713;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4709,homalg_variable_4713);; homalg_variable_4729 := homalg_variable_l[1];; homalg_variable_4730 := homalg_variable_l[2];;
gap> homalg_variable_4731 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4729 = homalg_variable_4731;
true
gap> homalg_variable_4732 := homalg_variable_4713 * homalg_variable_4730;;
gap> homalg_variable_4733 := homalg_variable_4709 + homalg_variable_4732;;
gap> homalg_variable_4729 = homalg_variable_4733;
true
gap> homalg_variable_4734 := SIH_DecideZeroColumns(homalg_variable_4709,homalg_variable_4713);;
gap> homalg_variable_4735 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4734 = homalg_variable_4735;
true
gap> homalg_variable_4736 := homalg_variable_4730 * (homalg_variable_8);;
gap> homalg_variable_4737 := homalg_variable_4713 * homalg_variable_4736;;
gap> homalg_variable_4737 = homalg_variable_4709;
true
gap> homalg_variable_4738 := SIH_DecideZeroColumns(homalg_variable_4709,homalg_variable_3358);;
gap> homalg_variable_4739 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4738 = homalg_variable_4739;
true
gap> homalg_variable_4741 := SIH_UnionOfColumns(homalg_variable_4701,homalg_variable_4461);;
gap> homalg_variable_4742 := SIH_UnionOfColumns(homalg_variable_4741,homalg_variable_3944);;
gap> homalg_variable_4740 := SIH_BasisOfColumnModule(homalg_variable_4742);;
gap> SI_ncols(homalg_variable_4740);
4
gap> homalg_variable_4743 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4740 = homalg_variable_4743;
false
gap> homalg_variable_4744 := SIH_DecideZeroColumns(homalg_variable_4741,homalg_variable_4740);;
gap> homalg_variable_4745 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4744 = homalg_variable_4745;
true
gap> homalg_variable_4747 := homalg_variable_4373 * homalg_variable_3536;;
gap> homalg_variable_4746 := SIH_DecideZeroColumns(homalg_variable_4747,homalg_variable_4740);;
gap> homalg_variable_4748 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4746 = homalg_variable_4748;
true
gap> homalg_variable_4749 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4373,homalg_variable_4742);;
gap> SI_ncols(homalg_variable_4749);
4
gap> homalg_variable_4750 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4749 = homalg_variable_4750;
false
gap> homalg_variable_4751 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4749);;
gap> SI_ncols(homalg_variable_4751);
1
gap> homalg_variable_4752 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4751 = homalg_variable_4752;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_4751,[ 0 ]);
[  ]
gap> homalg_variable_4753 := SIH_BasisOfColumnModule(homalg_variable_4749);;
gap> SI_ncols(homalg_variable_4753);
4
gap> homalg_variable_4754 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4753 = homalg_variable_4754;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4749);; homalg_variable_4755 := homalg_variable_l[1];; homalg_variable_4756 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4755);
4
gap> homalg_variable_4757 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4755 = homalg_variable_4757;
false
gap> SI_nrows(homalg_variable_4756);
4
gap> homalg_variable_4758 := homalg_variable_4749 * homalg_variable_4756;;
gap> homalg_variable_4755 = homalg_variable_4758;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4753,homalg_variable_4755);; homalg_variable_4759 := homalg_variable_l[1];; homalg_variable_4760 := homalg_variable_l[2];;
gap> homalg_variable_4761 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4759 = homalg_variable_4761;
true
gap> homalg_variable_4762 := homalg_variable_4755 * homalg_variable_4760;;
gap> homalg_variable_4763 := homalg_variable_4753 + homalg_variable_4762;;
gap> homalg_variable_4759 = homalg_variable_4763;
true
gap> homalg_variable_4764 := SIH_DecideZeroColumns(homalg_variable_4753,homalg_variable_4755);;
gap> homalg_variable_4765 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4764 = homalg_variable_4765;
true
gap> homalg_variable_4766 := homalg_variable_4760 * (homalg_variable_8);;
gap> homalg_variable_4767 := homalg_variable_4756 * homalg_variable_4766;;
gap> homalg_variable_4768 := homalg_variable_4749 * homalg_variable_4767;;
gap> homalg_variable_4768 = homalg_variable_4753;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4749,homalg_variable_4753);; homalg_variable_4769 := homalg_variable_l[1];; homalg_variable_4770 := homalg_variable_l[2];;
gap> homalg_variable_4771 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4769 = homalg_variable_4771;
true
gap> homalg_variable_4772 := homalg_variable_4753 * homalg_variable_4770;;
gap> homalg_variable_4773 := homalg_variable_4749 + homalg_variable_4772;;
gap> homalg_variable_4769 = homalg_variable_4773;
true
gap> homalg_variable_4774 := SIH_DecideZeroColumns(homalg_variable_4749,homalg_variable_4753);;
gap> homalg_variable_4775 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4774 = homalg_variable_4775;
true
gap> homalg_variable_4776 := homalg_variable_4770 * (homalg_variable_8);;
gap> homalg_variable_4777 := homalg_variable_4753 * homalg_variable_4776;;
gap> homalg_variable_4777 = homalg_variable_4749;
true
gap> homalg_variable_4778 := SIH_DecideZeroColumns(homalg_variable_4749,homalg_variable_3536);;
gap> homalg_variable_4779 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4778 = homalg_variable_4779;
true
gap> homalg_variable_4781 := SIH_UnionOfColumns(homalg_variable_4373,homalg_variable_4742);;
gap> homalg_variable_4780 := SIH_BasisOfColumnModule(homalg_variable_4781);;
gap> SI_ncols(homalg_variable_4780);
5
gap> homalg_variable_4782 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_4780 = homalg_variable_4782;
false
gap> homalg_variable_4783 := SIH_DecideZeroColumns(homalg_variable_18,homalg_variable_4780);;
gap> homalg_variable_4784 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_4783 = homalg_variable_4784;
true
gap> homalg_variable_4786 := SIH_UnionOfColumns(homalg_variable_10,homalg_variable_4064);;
gap> homalg_variable_4785 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4786);;
gap> SI_ncols(homalg_variable_4785);
10
gap> homalg_variable_4787 := SI_matrix(homalg_variable_5,12,10,"0");;
gap> homalg_variable_4785 = homalg_variable_4787;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_4785,[ 0 ]);
[ [ 1, 7 ], [ 2, 8 ], [ 3, 9 ], [ 4, 10 ], [ 5, 11 ], [ 6, 12 ] ]
gap> homalg_variable_4788 := SIH_BasisOfColumnModule(homalg_variable_4786);;
gap> SI_ncols(homalg_variable_4788);
6
gap> homalg_variable_4789 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4788 = homalg_variable_4789;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4788,homalg_variable_10);; homalg_variable_4790 := homalg_variable_l[1];; homalg_variable_4791 := homalg_variable_l[2];;
gap> homalg_variable_4792 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4790 = homalg_variable_4792;
true
gap> homalg_variable_4793 := homalg_variable_10 * homalg_variable_4791;;
gap> homalg_variable_4794 := homalg_variable_4788 + homalg_variable_4793;;
gap> homalg_variable_4790 = homalg_variable_4794;
true
gap> homalg_variable_4795 := SIH_DecideZeroColumns(homalg_variable_4788,homalg_variable_10);;
gap> homalg_variable_4796 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4795 = homalg_variable_4796;
true
gap> homalg_variable_4797 := homalg_variable_4791 * (homalg_variable_8);;
gap> homalg_variable_4798 := homalg_variable_10 * homalg_variable_4797;;
gap> homalg_variable_4798 = homalg_variable_4788;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_10,homalg_variable_4788);; homalg_variable_4799 := homalg_variable_l[1];; homalg_variable_4800 := homalg_variable_l[2];;
gap> homalg_variable_4801 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4799 = homalg_variable_4801;
true
gap> homalg_variable_4802 := homalg_variable_4788 * homalg_variable_4800;;
gap> homalg_variable_4803 := homalg_variable_10 + homalg_variable_4802;;
gap> homalg_variable_4799 = homalg_variable_4803;
true
gap> homalg_variable_4804 := SIH_DecideZeroColumns(homalg_variable_10,homalg_variable_4788);;
gap> homalg_variable_4805 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4804 = homalg_variable_4805;
true
gap> homalg_variable_4806 := homalg_variable_4800 * (homalg_variable_8);;
gap> homalg_variable_4807 := homalg_variable_4788 * homalg_variable_4806;;
gap> homalg_variable_4807 = homalg_variable_10;
true
gap> homalg_variable_4809 := homalg_variable_4030 * homalg_variable_3944;;
gap> homalg_variable_4808 := SIH_DecideZeroColumns(homalg_variable_4809,homalg_variable_10);;
gap> homalg_variable_4810 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4808 = homalg_variable_4810;
true
gap> homalg_variable_4812 := SIH_UnionOfColumns(homalg_variable_4030,homalg_variable_10);;
gap> homalg_variable_4811 := SIH_BasisOfColumnModule(homalg_variable_4812);;
gap> SI_ncols(homalg_variable_4811);
5
gap> homalg_variable_4813 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_4811 = homalg_variable_4813;
false
gap> homalg_variable_4814 := SIH_DecideZeroColumns(homalg_variable_18,homalg_variable_4811);;
gap> homalg_variable_4815 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_4814 = homalg_variable_4815;
true
gap> homalg_variable_4816 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4030,homalg_variable_10);;
gap> SI_ncols(homalg_variable_4816);
6
gap> homalg_variable_4817 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4816 = homalg_variable_4817;
false
gap> homalg_variable_4818 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4816);;
gap> SI_ncols(homalg_variable_4818);
4
gap> homalg_variable_4819 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_4818 = homalg_variable_4819;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_4818,[ 0 ]);
[  ]
gap> homalg_variable_4820 := SIH_BasisOfColumnModule(homalg_variable_4816);;
gap> SI_ncols(homalg_variable_4820);
6
gap> homalg_variable_4821 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4820 = homalg_variable_4821;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4816);; homalg_variable_4822 := homalg_variable_l[1];; homalg_variable_4823 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4822);
6
gap> homalg_variable_4824 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4822 = homalg_variable_4824;
false
gap> SI_nrows(homalg_variable_4823);
6
gap> homalg_variable_4825 := homalg_variable_4816 * homalg_variable_4823;;
gap> homalg_variable_4822 = homalg_variable_4825;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4820,homalg_variable_4822);; homalg_variable_4826 := homalg_variable_l[1];; homalg_variable_4827 := homalg_variable_l[2];;
gap> homalg_variable_4828 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4826 = homalg_variable_4828;
true
gap> homalg_variable_4829 := homalg_variable_4822 * homalg_variable_4827;;
gap> homalg_variable_4830 := homalg_variable_4820 + homalg_variable_4829;;
gap> homalg_variable_4826 = homalg_variable_4830;
true
gap> homalg_variable_4831 := SIH_DecideZeroColumns(homalg_variable_4820,homalg_variable_4822);;
gap> homalg_variable_4832 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4831 = homalg_variable_4832;
true
gap> homalg_variable_4833 := homalg_variable_4827 * (homalg_variable_8);;
gap> homalg_variable_4834 := homalg_variable_4823 * homalg_variable_4833;;
gap> homalg_variable_4835 := homalg_variable_4816 * homalg_variable_4834;;
gap> homalg_variable_4835 = homalg_variable_4820;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4816,homalg_variable_4820);; homalg_variable_4836 := homalg_variable_l[1];; homalg_variable_4837 := homalg_variable_l[2];;
gap> homalg_variable_4838 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4836 = homalg_variable_4838;
true
gap> homalg_variable_4839 := homalg_variable_4820 * homalg_variable_4837;;
gap> homalg_variable_4840 := homalg_variable_4816 + homalg_variable_4839;;
gap> homalg_variable_4836 = homalg_variable_4840;
true
gap> homalg_variable_4841 := SIH_DecideZeroColumns(homalg_variable_4816,homalg_variable_4820);;
gap> homalg_variable_4842 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4841 = homalg_variable_4842;
true
gap> homalg_variable_4843 := homalg_variable_4837 * (homalg_variable_8);;
gap> homalg_variable_4844 := homalg_variable_4820 * homalg_variable_4843;;
gap> homalg_variable_4844 = homalg_variable_4816;
true
gap> homalg_variable_4845 := SIH_DecideZeroColumns(homalg_variable_4816,homalg_variable_3944);;
gap> homalg_variable_4846 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4845 = homalg_variable_4846;
true
gap> homalg_variable_4848 := homalg_variable_4030 * homalg_variable_4553;;
gap> homalg_variable_4849 := SIH_UnionOfColumns(homalg_variable_4848,homalg_variable_10);;
gap> homalg_variable_4847 := SIH_BasisOfColumnModule(homalg_variable_4849);;
gap> SI_ncols(homalg_variable_4847);
5
gap> homalg_variable_4850 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_4847 = homalg_variable_4850;
false
gap> homalg_variable_4851 := SIH_DecideZeroColumns(homalg_variable_4848,homalg_variable_4847);;
gap> homalg_variable_4852 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_4851 = homalg_variable_4852;
true
gap> homalg_variable_4854 := homalg_variable_4030 * homalg_variable_4526;;
gap> homalg_variable_4855 := homalg_variable_4854 * homalg_variable_3037;;
gap> homalg_variable_4853 := SIH_DecideZeroColumns(homalg_variable_4855,homalg_variable_4847);;
gap> homalg_variable_4856 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_4853 = homalg_variable_4856;
true
gap> homalg_variable_4857 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4854,homalg_variable_4849);;
gap> SI_ncols(homalg_variable_4857);
2
gap> homalg_variable_4858 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4857 = homalg_variable_4858;
false
gap> homalg_variable_4859 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4857);;
gap> SI_ncols(homalg_variable_4859);
1
gap> homalg_variable_4860 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_4859 = homalg_variable_4860;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_4859,[ 0 ]);
[  ]
gap> homalg_variable_4861 := SIH_BasisOfColumnModule(homalg_variable_4857);;
gap> SI_ncols(homalg_variable_4861);
2
gap> homalg_variable_4862 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4861 = homalg_variable_4862;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4857);; homalg_variable_4863 := homalg_variable_l[1];; homalg_variable_4864 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4863);
2
gap> homalg_variable_4865 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4863 = homalg_variable_4865;
false
gap> SI_nrows(homalg_variable_4864);
2
gap> homalg_variable_4866 := homalg_variable_4857 * homalg_variable_4864;;
gap> homalg_variable_4863 = homalg_variable_4866;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4861,homalg_variable_4863);; homalg_variable_4867 := homalg_variable_l[1];; homalg_variable_4868 := homalg_variable_l[2];;
gap> homalg_variable_4869 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4867 = homalg_variable_4869;
true
gap> homalg_variable_4870 := homalg_variable_4863 * homalg_variable_4868;;
gap> homalg_variable_4871 := homalg_variable_4861 + homalg_variable_4870;;
gap> homalg_variable_4867 = homalg_variable_4871;
true
gap> homalg_variable_4872 := SIH_DecideZeroColumns(homalg_variable_4861,homalg_variable_4863);;
gap> homalg_variable_4873 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4872 = homalg_variable_4873;
true
gap> homalg_variable_4874 := homalg_variable_4868 * (homalg_variable_8);;
gap> homalg_variable_4875 := homalg_variable_4864 * homalg_variable_4874;;
gap> homalg_variable_4876 := homalg_variable_4857 * homalg_variable_4875;;
gap> homalg_variable_4876 = homalg_variable_4861;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4857,homalg_variable_4861);; homalg_variable_4877 := homalg_variable_l[1];; homalg_variable_4878 := homalg_variable_l[2];;
gap> homalg_variable_4879 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4877 = homalg_variable_4879;
true
gap> homalg_variable_4880 := homalg_variable_4861 * homalg_variable_4878;;
gap> homalg_variable_4881 := homalg_variable_4857 + homalg_variable_4880;;
gap> homalg_variable_4877 = homalg_variable_4881;
true
gap> homalg_variable_4882 := SIH_DecideZeroColumns(homalg_variable_4857,homalg_variable_4861);;
gap> homalg_variable_4883 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4882 = homalg_variable_4883;
true
gap> homalg_variable_4884 := homalg_variable_4878 * (homalg_variable_8);;
gap> homalg_variable_4885 := homalg_variable_4861 * homalg_variable_4884;;
gap> homalg_variable_4885 = homalg_variable_4857;
true
gap> homalg_variable_4886 := SIH_DecideZeroColumns(homalg_variable_4857,homalg_variable_3037);;
gap> homalg_variable_4887 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4886 = homalg_variable_4887;
true
gap> homalg_variable_4889 := SIH_UnionOfColumns(homalg_variable_4848,homalg_variable_4854);;
gap> homalg_variable_4890 := SIH_UnionOfColumns(homalg_variable_4889,homalg_variable_10);;
gap> homalg_variable_4888 := SIH_BasisOfColumnModule(homalg_variable_4890);;
gap> SI_ncols(homalg_variable_4888);
4
gap> homalg_variable_4891 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4888 = homalg_variable_4891;
false
gap> homalg_variable_4892 := SIH_DecideZeroColumns(homalg_variable_4889,homalg_variable_4888);;
gap> homalg_variable_4893 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_4892 = homalg_variable_4893;
true
gap> homalg_variable_4895 := homalg_variable_4030 * homalg_variable_4461;;
gap> homalg_variable_4896 := homalg_variable_4895 * homalg_variable_3358;;
gap> homalg_variable_4894 := SIH_DecideZeroColumns(homalg_variable_4896,homalg_variable_4888);;
gap> homalg_variable_4897 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_4894 = homalg_variable_4897;
true
gap> homalg_variable_4898 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4895,homalg_variable_4890);;
gap> SI_ncols(homalg_variable_4898);
5
gap> homalg_variable_4899 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4898 = homalg_variable_4899;
false
gap> homalg_variable_4900 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4898);;
gap> SI_ncols(homalg_variable_4900);
1
gap> homalg_variable_4901 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_4900 = homalg_variable_4901;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_4900,[ 0 ]);
[  ]
gap> homalg_variable_4902 := SIH_BasisOfColumnModule(homalg_variable_4898);;
gap> SI_ncols(homalg_variable_4902);
5
gap> homalg_variable_4903 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4902 = homalg_variable_4903;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4898);; homalg_variable_4904 := homalg_variable_l[1];; homalg_variable_4905 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4904);
5
gap> homalg_variable_4906 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4904 = homalg_variable_4906;
false
gap> SI_nrows(homalg_variable_4905);
5
gap> homalg_variable_4907 := homalg_variable_4898 * homalg_variable_4905;;
gap> homalg_variable_4904 = homalg_variable_4907;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4902,homalg_variable_4904);; homalg_variable_4908 := homalg_variable_l[1];; homalg_variable_4909 := homalg_variable_l[2];;
gap> homalg_variable_4910 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4908 = homalg_variable_4910;
true
gap> homalg_variable_4911 := homalg_variable_4904 * homalg_variable_4909;;
gap> homalg_variable_4912 := homalg_variable_4902 + homalg_variable_4911;;
gap> homalg_variable_4908 = homalg_variable_4912;
true
gap> homalg_variable_4913 := SIH_DecideZeroColumns(homalg_variable_4902,homalg_variable_4904);;
gap> homalg_variable_4914 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4913 = homalg_variable_4914;
true
gap> homalg_variable_4915 := homalg_variable_4909 * (homalg_variable_8);;
gap> homalg_variable_4916 := homalg_variable_4905 * homalg_variable_4915;;
gap> homalg_variable_4917 := homalg_variable_4898 * homalg_variable_4916;;
gap> homalg_variable_4917 = homalg_variable_4902;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4898,homalg_variable_4902);; homalg_variable_4918 := homalg_variable_l[1];; homalg_variable_4919 := homalg_variable_l[2];;
gap> homalg_variable_4920 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4918 = homalg_variable_4920;
true
gap> homalg_variable_4921 := homalg_variable_4902 * homalg_variable_4919;;
gap> homalg_variable_4922 := homalg_variable_4898 + homalg_variable_4921;;
gap> homalg_variable_4918 = homalg_variable_4922;
true
gap> homalg_variable_4923 := SIH_DecideZeroColumns(homalg_variable_4898,homalg_variable_4902);;
gap> homalg_variable_4924 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4923 = homalg_variable_4924;
true
gap> homalg_variable_4925 := homalg_variable_4919 * (homalg_variable_8);;
gap> homalg_variable_4926 := homalg_variable_4902 * homalg_variable_4925;;
gap> homalg_variable_4926 = homalg_variable_4898;
true
gap> homalg_variable_4927 := SIH_DecideZeroColumns(homalg_variable_4898,homalg_variable_3358);;
gap> homalg_variable_4928 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4927 = homalg_variable_4928;
true
gap> homalg_variable_4930 := SIH_UnionOfColumns(homalg_variable_4889,homalg_variable_4895);;
gap> homalg_variable_4931 := SIH_UnionOfColumns(homalg_variable_4930,homalg_variable_10);;
gap> homalg_variable_4929 := SIH_BasisOfColumnModule(homalg_variable_4931);;
gap> SI_ncols(homalg_variable_4929);
4
gap> homalg_variable_4932 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4929 = homalg_variable_4932;
false
gap> homalg_variable_4933 := SIH_DecideZeroColumns(homalg_variable_4930,homalg_variable_4929);;
gap> homalg_variable_4934 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4933 = homalg_variable_4934;
true
gap> homalg_variable_4936 := homalg_variable_4030 * homalg_variable_4373;;
gap> homalg_variable_4937 := homalg_variable_4936 * homalg_variable_3536;;
gap> homalg_variable_4935 := SIH_DecideZeroColumns(homalg_variable_4937,homalg_variable_4929);;
gap> homalg_variable_4938 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4935 = homalg_variable_4938;
true
gap> homalg_variable_4939 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4936,homalg_variable_4931);;
gap> SI_ncols(homalg_variable_4939);
4
gap> homalg_variable_4940 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4939 = homalg_variable_4940;
false
gap> homalg_variable_4941 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4939);;
gap> SI_ncols(homalg_variable_4941);
1
gap> homalg_variable_4942 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4941 = homalg_variable_4942;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_4941,[ 0 ]);
[  ]
gap> homalg_variable_4943 := SIH_BasisOfColumnModule(homalg_variable_4939);;
gap> SI_ncols(homalg_variable_4943);
4
gap> homalg_variable_4944 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4943 = homalg_variable_4944;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4939);; homalg_variable_4945 := homalg_variable_l[1];; homalg_variable_4946 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4945);
4
gap> homalg_variable_4947 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4945 = homalg_variable_4947;
false
gap> SI_nrows(homalg_variable_4946);
4
gap> homalg_variable_4948 := homalg_variable_4939 * homalg_variable_4946;;
gap> homalg_variable_4945 = homalg_variable_4948;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4943,homalg_variable_4945);; homalg_variable_4949 := homalg_variable_l[1];; homalg_variable_4950 := homalg_variable_l[2];;
gap> homalg_variable_4951 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4949 = homalg_variable_4951;
true
gap> homalg_variable_4952 := homalg_variable_4945 * homalg_variable_4950;;
gap> homalg_variable_4953 := homalg_variable_4943 + homalg_variable_4952;;
gap> homalg_variable_4949 = homalg_variable_4953;
true
gap> homalg_variable_4954 := SIH_DecideZeroColumns(homalg_variable_4943,homalg_variable_4945);;
gap> homalg_variable_4955 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4954 = homalg_variable_4955;
true
gap> homalg_variable_4956 := homalg_variable_4950 * (homalg_variable_8);;
gap> homalg_variable_4957 := homalg_variable_4946 * homalg_variable_4956;;
gap> homalg_variable_4958 := homalg_variable_4939 * homalg_variable_4957;;
gap> homalg_variable_4958 = homalg_variable_4943;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4939,homalg_variable_4943);; homalg_variable_4959 := homalg_variable_l[1];; homalg_variable_4960 := homalg_variable_l[2];;
gap> homalg_variable_4961 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4959 = homalg_variable_4961;
true
gap> homalg_variable_4962 := homalg_variable_4943 * homalg_variable_4960;;
gap> homalg_variable_4963 := homalg_variable_4939 + homalg_variable_4962;;
gap> homalg_variable_4959 = homalg_variable_4963;
true
gap> homalg_variable_4964 := SIH_DecideZeroColumns(homalg_variable_4939,homalg_variable_4943);;
gap> homalg_variable_4965 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4964 = homalg_variable_4965;
true
gap> homalg_variable_4966 := homalg_variable_4960 * (homalg_variable_8);;
gap> homalg_variable_4967 := homalg_variable_4943 * homalg_variable_4966;;
gap> homalg_variable_4967 = homalg_variable_4939;
true
gap> homalg_variable_4968 := SIH_DecideZeroColumns(homalg_variable_4939,homalg_variable_3536);;
gap> homalg_variable_4969 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4968 = homalg_variable_4969;
true
gap> homalg_variable_4971 := SIH_UnionOfColumns(homalg_variable_4936,homalg_variable_4931);;
gap> homalg_variable_4970 := SIH_BasisOfColumnModule(homalg_variable_4971);;
gap> SI_ncols(homalg_variable_4970);
5
gap> homalg_variable_4972 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_4970 = homalg_variable_4972;
false
gap> homalg_variable_4973 := SIH_DecideZeroColumns(homalg_variable_18,homalg_variable_4970);;
gap> homalg_variable_4974 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_4973 = homalg_variable_4974;
true
gap> SIH_GetUnitPosition(homalg_variable_2959,[ 0 ]);
fail
gap> homalg_variable_4975 := SIH_BasisOfRowModule(homalg_variable_2959);;
gap> SI_nrows(homalg_variable_4975);
1
gap> homalg_variable_4976 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_4975 = homalg_variable_4976;
false
gap> homalg_variable_4977 := SIH_DecideZeroRows(homalg_variable_2959,homalg_variable_4975);;
gap> homalg_variable_4978 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_4977 = homalg_variable_4978;
true
gap> homalg_variable_4979 := SIH_DecideZeroColumns(homalg_variable_860,homalg_variable_2959);;
gap> homalg_variable_4980 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_4979 = homalg_variable_4980;
false
gap> homalg_variable_4981 := SIH_DecideZeroColumns(homalg_variable_860,homalg_variable_2959);;
gap> homalg_variable_4982 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_4981 = homalg_variable_4982;
false
gap> homalg_variable_4981 = homalg_variable_860;
true
gap> SIH_GetUnitPosition(homalg_variable_3037,[ 0 ]);
fail
gap> homalg_variable_4983 := SIH_BasisOfRowModule(homalg_variable_3037);;
gap> SI_nrows(homalg_variable_4983);
1
gap> homalg_variable_4984 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4983 = homalg_variable_4984;
false
gap> homalg_variable_4985 := SIH_DecideZeroRows(homalg_variable_3037,homalg_variable_4983);;
gap> homalg_variable_4986 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4985 = homalg_variable_4986;
true
gap> homalg_variable_4988 := homalg_variable_2492 * homalg_variable_2831;;
gap> homalg_variable_4989 := SIH_UnionOfColumns(homalg_variable_2487,homalg_variable_4988);;
gap> homalg_variable_4987 := SIH_BasisOfColumnModule(homalg_variable_4989);;
gap> SI_ncols(homalg_variable_4987);
5
gap> homalg_variable_4990 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_4987 = homalg_variable_4990;
false
gap> homalg_variable_4992 := homalg_variable_2492 * homalg_variable_3003;;
gap> homalg_variable_4991 := SIH_DecideZeroColumns(homalg_variable_4992,homalg_variable_4987);;
gap> homalg_variable_4993 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_4991 = homalg_variable_4993;
false
gap> homalg_variable_4994 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_4992 = homalg_variable_4994;
false
gap> homalg_variable_4991 = homalg_variable_4992;
true
gap> SIH_GetUnitPosition(homalg_variable_3358,[ 0 ]);
[ 1, 1 ]
gap> homalg_variable_4995 := SI_\[(homalg_variable_3358,1,1);;
gap> SI_deg(homalg_variable_4995);
0
gap> IsZero(homalg_variable_4995);
false
gap> IsOne(homalg_variable_4995);
true
gap> homalg_variable_4996 := SIH_Submatrix(homalg_variable_3358,[ 2, 3, 4 ],[1..5]);;
gap> homalg_variable_4997 := SIH_Submatrix(homalg_variable_4996,[1..3],[ 2, 3, 4, 5 ]);;
gap> homalg_variable_4998 := SIH_Submatrix(homalg_variable_3358,[1..4],[ 1 ]);;
gap> homalg_variable_4999 := SIH_Submatrix(homalg_variable_4998,[ 2, 3, 4 ],[1..1]);;
gap> homalg_variable_5000 := SIH_Submatrix(homalg_variable_3358,[ 1 ],[1..5]);;
gap> for _del in [ "homalg_variable_4485", "homalg_variable_4486", "homalg_variable_4487", "homalg_variable_4488", "homalg_variable_4489", "homalg_variable_4490", "homalg_variable_4491", "homalg_variable_4492", "homalg_variable_4493", "homalg_variable_4494", "homalg_variable_4497", "homalg_variable_4498", "homalg_variable_4499", "homalg_variable_4503", "homalg_variable_4504", "homalg_variable_4506", "homalg_variable_4507", "homalg_variable_4508", "homalg_variable_4509", "homalg_variable_4510", "homalg_variable_4511", "homalg_variable_4512", "homalg_variable_4513", "homalg_variable_4514", "homalg_variable_4515", "homalg_variable_4517", "homalg_variable_4518", "homalg_variable_4519", "homalg_variable_4520", "homalg_variable_4521", "homalg_variable_4522", "homalg_variable_4523", "homalg_variable_4528", "homalg_variable_4529", "homalg_variable_4531", "homalg_variable_4532", "homalg_variable_4534", "homalg_variable_4535", "homalg_variable_4536", "homalg_variable_4537", "homalg_variable_4538", "homalg_variable_4539", "homalg_variable_4540", "homalg_variable_4541", "homalg_variable_4542", "homalg_variable_4544", "homalg_variable_4545", "homalg_variable_4546", "homalg_variable_4547", "homalg_variable_4548", "homalg_variable_4549", "homalg_variable_4550", "homalg_variable_4554", "homalg_variable_4555", "homalg_variable_4556", "homalg_variable_4557", "homalg_variable_4563", "homalg_variable_4567", "homalg_variable_4570", "homalg_variable_4571", "homalg_variable_4572", "homalg_variable_4573", "homalg_variable_4574", "homalg_variable_4575", "homalg_variable_4576", "homalg_variable_4577", "homalg_variable_4578", "homalg_variable_4579", "homalg_variable_4580", "homalg_variable_4581", "homalg_variable_4584", "homalg_variable_4585", "homalg_variable_4586", "homalg_variable_4587", "homalg_variable_4588", "homalg_variable_4590", "homalg_variable_4592", "homalg_variable_4593", "homalg_variable_4594", "homalg_variable_4595", "homalg_variable_4597", "homalg_variable_4599", "homalg_variable_4601", "homalg_variable_4604", "homalg_variable_4605", "homalg_variable_4608", "homalg_variable_4609", "homalg_variable_4610", "homalg_variable_4615", "homalg_variable_4616", "homalg_variable_4617", "homalg_variable_4618", "homalg_variable_4619", "homalg_variable_4620", "homalg_variable_4621", "homalg_variable_4622", "homalg_variable_4623", "homalg_variable_4624", "homalg_variable_4625", "homalg_variable_4626", "homalg_variable_4629", "homalg_variable_4630", "homalg_variable_4631", "homalg_variable_4632", "homalg_variable_4633", "homalg_variable_4634", "homalg_variable_4636", "homalg_variable_4638", "homalg_variable_4640", "homalg_variable_4644", "homalg_variable_4647", "homalg_variable_4648", "homalg_variable_4649", "homalg_variable_4650", "homalg_variable_4651", "homalg_variable_4654", "homalg_variable_4655", "homalg_variable_4656", "homalg_variable_4657", "homalg_variable_4658", "homalg_variable_4659", "homalg_variable_4660", "homalg_variable_4661", "homalg_variable_4662", "homalg_variable_4663", "homalg_variable_4668", "homalg_variable_4670", "homalg_variable_4673", "homalg_variable_4674", "homalg_variable_4676", "homalg_variable_4679", "homalg_variable_4680", "homalg_variable_4681", "homalg_variable_4682", "homalg_variable_4683", "homalg_variable_4684", "homalg_variable_4685", "homalg_variable_4686", "homalg_variable_4687", "homalg_variable_4688", "homalg_variable_4689", "homalg_variable_4690", "homalg_variable_4693", "homalg_variable_4694", "homalg_variable_4695", "homalg_variable_4699", "homalg_variable_4703", "homalg_variable_4704", "homalg_variable_4705", "homalg_variable_4706", "homalg_variable_4707", "homalg_variable_4708", "homalg_variable_4710", "homalg_variable_4712", "homalg_variable_4714", "homalg_variable_4717", "homalg_variable_4718", "homalg_variable_4719", "homalg_variable_4720", "homalg_variable_4721", "homalg_variable_4722", "homalg_variable_4723", "homalg_variable_4724", "homalg_variable_4725", "homalg_variable_4726", "homalg_variable_4727", "homalg_variable_4728", "homalg_variable_4731", "homalg_variable_4732", "homalg_variable_4733", "homalg_variable_4737", "homalg_variable_4738", "homalg_variable_4739", "homalg_variable_4743", "homalg_variable_4747", "homalg_variable_4748", "homalg_variable_4750", "homalg_variable_4752", "homalg_variable_4757", "homalg_variable_4758", "homalg_variable_4761", "homalg_variable_4762", "homalg_variable_4763", "homalg_variable_4764", "homalg_variable_4765", "homalg_variable_4768", "homalg_variable_4769", "homalg_variable_4770", "homalg_variable_4771", "homalg_variable_4772", "homalg_variable_4773", "homalg_variable_4774", "homalg_variable_4775", "homalg_variable_4776", "homalg_variable_4777", "homalg_variable_4778", "homalg_variable_4779", "homalg_variable_4782", "homalg_variable_4783", "homalg_variable_4784", "homalg_variable_4787", "homalg_variable_4789", "homalg_variable_4790", "homalg_variable_4791", "homalg_variable_4792", "homalg_variable_4793", "homalg_variable_4794", "homalg_variable_4795", "homalg_variable_4796", "homalg_variable_4797", "homalg_variable_4798", "homalg_variable_4801", "homalg_variable_4802", "homalg_variable_4803", "homalg_variable_4807", "homalg_variable_4808", "homalg_variable_4809", "homalg_variable_4810", "homalg_variable_4813", "homalg_variable_4814", "homalg_variable_4815", "homalg_variable_4817", "homalg_variable_4819", "homalg_variable_4824", "homalg_variable_4825", "homalg_variable_4826", "homalg_variable_4827", "homalg_variable_4828", "homalg_variable_4829", "homalg_variable_4830", "homalg_variable_4831", "homalg_variable_4832", "homalg_variable_4833", "homalg_variable_4834", "homalg_variable_4835", "homalg_variable_4838", "homalg_variable_4839", "homalg_variable_4840", "homalg_variable_4841", "homalg_variable_4842", "homalg_variable_4845", "homalg_variable_4846", "homalg_variable_4852", "homalg_variable_4853", "homalg_variable_4855", "homalg_variable_4856", "homalg_variable_4858", "homalg_variable_4860", "homalg_variable_4862", "homalg_variable_4865", "homalg_variable_4866", "homalg_variable_4870", "homalg_variable_4871", "homalg_variable_4872", "homalg_variable_4873", "homalg_variable_4876", "homalg_variable_4877", "homalg_variable_4878", "homalg_variable_4879", "homalg_variable_4880", "homalg_variable_4881", "homalg_variable_4882", "homalg_variable_4883", "homalg_variable_4884", "homalg_variable_4885", "homalg_variable_4887", "homalg_variable_4891", "homalg_variable_4893", "homalg_variable_4894", "homalg_variable_4896", "homalg_variable_4897", "homalg_variable_4899", "homalg_variable_4901", "homalg_variable_4903", "homalg_variable_4906", "homalg_variable_4907", "homalg_variable_4911", "homalg_variable_4912", "homalg_variable_4913", "homalg_variable_4914", "homalg_variable_4917", "homalg_variable_4918", "homalg_variable_4919", "homalg_variable_4920", "homalg_variable_4921", "homalg_variable_4922", "homalg_variable_4923", "homalg_variable_4924", "homalg_variable_4925", "homalg_variable_4926", "homalg_variable_4932", "homalg_variable_4933", "homalg_variable_4934", "homalg_variable_4935", "homalg_variable_4937", "homalg_variable_4938", "homalg_variable_4940", "homalg_variable_4942", "homalg_variable_4944", "homalg_variable_4948", "homalg_variable_4951", "homalg_variable_4952", "homalg_variable_4953", "homalg_variable_4954", "homalg_variable_4955", "homalg_variable_4958", "homalg_variable_4961", "homalg_variable_4962", "homalg_variable_4963", "homalg_variable_4964", "homalg_variable_4965", "homalg_variable_4967", "homalg_variable_4968", "homalg_variable_4969", "homalg_variable_4973", "homalg_variable_4974", "homalg_variable_4976", "homalg_variable_4977", "homalg_variable_4978", "homalg_variable_4979", "homalg_variable_4980", "homalg_variable_4981", "homalg_variable_4982", "homalg_variable_4984", "homalg_variable_4985", "homalg_variable_4986", "homalg_variable_4990", "homalg_variable_4991", "homalg_variable_4993", "homalg_variable_4994", "homalg_variable_4995" ] do UnbindGlobal( _del ); od;;
gap> homalg_variable_5001 := SIH_Submatrix(homalg_variable_5000,[1..1],[ 2, 3, 4, 5 ]);;
gap> homalg_variable_5002 := homalg_variable_4999 * homalg_variable_5001;;
gap> homalg_variable_5003 := homalg_variable_4997 - homalg_variable_5002;;
gap> SIH_GetUnitPosition(homalg_variable_5003,[ 0 ]);
fail
gap> homalg_variable_5004 := SIH_Submatrix(homalg_variable_3358,[1..4],[ 1 ]);;
gap> homalg_variable_5005 := homalg_variable_5001 * (homalg_variable_8);;
gap> homalg_variable_5006 := homalg_variable_5004 * homalg_variable_5005;;
gap> homalg_variable_5007 := SIH_Submatrix(homalg_variable_3358,[1..4],[ 2, 3, 4, 5 ]);;
gap> homalg_variable_5008 := homalg_variable_5006 + homalg_variable_5007;;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_5008);; homalg_variable_5009 := homalg_variable_l[1];; homalg_variable_5010 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_5009);
3
gap> homalg_variable_5011 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5009 = homalg_variable_5011;
false
gap> SI_ncols(homalg_variable_5010);
4
gap> homalg_variable_5012 := homalg_variable_5010 * homalg_variable_5008;;
gap> homalg_variable_5009 = homalg_variable_5012;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_5003,homalg_variable_5009);; homalg_variable_5013 := homalg_variable_l[1];; homalg_variable_5014 := homalg_variable_l[2];;
gap> homalg_variable_5015 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5013 = homalg_variable_5015;
true
gap> homalg_variable_5016 := homalg_variable_5014 * homalg_variable_5009;;
gap> homalg_variable_5017 := homalg_variable_5003 + homalg_variable_5016;;
gap> homalg_variable_5013 = homalg_variable_5017;
true
gap> homalg_variable_5018 := SIH_DecideZeroRows(homalg_variable_5003,homalg_variable_5009);;
gap> homalg_variable_5019 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5018 = homalg_variable_5019;
true
gap> homalg_variable_5020 := homalg_variable_5014 * (homalg_variable_8);;
gap> homalg_variable_5021 := homalg_variable_5020 * homalg_variable_5010;;
gap> homalg_variable_5022 := homalg_variable_5021 * homalg_variable_5008;;
gap> homalg_variable_5022 = homalg_variable_5003;
true
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_5003);; homalg_variable_5023 := homalg_variable_l[1];; homalg_variable_5024 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_5023);
3
gap> homalg_variable_5025 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5023 = homalg_variable_5025;
false
gap> SI_ncols(homalg_variable_5024);
3
gap> homalg_variable_5026 := homalg_variable_5024 * homalg_variable_5003;;
gap> homalg_variable_5023 = homalg_variable_5026;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_5008,homalg_variable_5023);; homalg_variable_5027 := homalg_variable_l[1];; homalg_variable_5028 := homalg_variable_l[2];;
gap> homalg_variable_5029 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_5027 = homalg_variable_5029;
true
gap> homalg_variable_5030 := homalg_variable_5028 * homalg_variable_5023;;
gap> homalg_variable_5031 := homalg_variable_5008 + homalg_variable_5030;;
gap> homalg_variable_5027 = homalg_variable_5031;
true
gap> homalg_variable_5032 := SIH_DecideZeroRows(homalg_variable_5008,homalg_variable_5023);;
gap> homalg_variable_5033 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_5032 = homalg_variable_5033;
true
gap> homalg_variable_5034 := homalg_variable_5028 * (homalg_variable_8);;
gap> homalg_variable_5035 := homalg_variable_5034 * homalg_variable_5024;;
gap> homalg_variable_5036 := homalg_variable_5035 * homalg_variable_5003;;
gap> homalg_variable_5036 = homalg_variable_5008;
true
gap> homalg_variable_5037 := homalg_variable_4999 * (homalg_variable_8);;
gap> homalg_variable_5038 := SIH_Submatrix(homalg_variable_3358,[ 1 ],[1..5]);;
gap> homalg_variable_5039 := homalg_variable_5037 * homalg_variable_5038;;
gap> homalg_variable_5040 := SIH_Submatrix(homalg_variable_3358,[ 2, 3, 4 ],[1..5]);;
gap> homalg_variable_5041 := homalg_variable_5039 + homalg_variable_5040;;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5041);; homalg_variable_5042 := homalg_variable_l[1];; homalg_variable_5043 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5042);
4
gap> homalg_variable_5044 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5042 = homalg_variable_5044;
false
gap> SI_nrows(homalg_variable_5043);
5
gap> homalg_variable_5045 := homalg_variable_5041 * homalg_variable_5043;;
gap> homalg_variable_5042 = homalg_variable_5045;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5003,homalg_variable_5042);; homalg_variable_5046 := homalg_variable_l[1];; homalg_variable_5047 := homalg_variable_l[2];;
gap> homalg_variable_5048 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5046 = homalg_variable_5048;
true
gap> homalg_variable_5049 := homalg_variable_5042 * homalg_variable_5047;;
gap> homalg_variable_5050 := homalg_variable_5003 + homalg_variable_5049;;
gap> homalg_variable_5046 = homalg_variable_5050;
true
gap> homalg_variable_5051 := SIH_DecideZeroColumns(homalg_variable_5003,homalg_variable_5042);;
gap> homalg_variable_5052 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5051 = homalg_variable_5052;
true
gap> homalg_variable_5053 := homalg_variable_5047 * (homalg_variable_8);;
gap> homalg_variable_5054 := homalg_variable_5043 * homalg_variable_5053;;
gap> homalg_variable_5055 := homalg_variable_5041 * homalg_variable_5054;;
gap> homalg_variable_5055 = homalg_variable_5003;
true
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5003);; homalg_variable_5056 := homalg_variable_l[1];; homalg_variable_5057 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5056);
4
gap> homalg_variable_5058 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5056 = homalg_variable_5058;
false
gap> SI_nrows(homalg_variable_5057);
4
gap> homalg_variable_5059 := homalg_variable_5003 * homalg_variable_5057;;
gap> homalg_variable_5056 = homalg_variable_5059;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5041,homalg_variable_5056);; homalg_variable_5060 := homalg_variable_l[1];; homalg_variable_5061 := homalg_variable_l[2];;
gap> homalg_variable_5062 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_5060 = homalg_variable_5062;
true
gap> homalg_variable_5063 := homalg_variable_5056 * homalg_variable_5061;;
gap> homalg_variable_5064 := homalg_variable_5041 + homalg_variable_5063;;
gap> homalg_variable_5060 = homalg_variable_5064;
true
gap> homalg_variable_5065 := SIH_DecideZeroColumns(homalg_variable_5041,homalg_variable_5056);;
gap> homalg_variable_5066 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_5065 = homalg_variable_5066;
true
gap> homalg_variable_5067 := homalg_variable_5061 * (homalg_variable_8);;
gap> homalg_variable_5068 := homalg_variable_5057 * homalg_variable_5067;;
gap> homalg_variable_5069 := homalg_variable_5003 * homalg_variable_5068;;
gap> homalg_variable_5069 = homalg_variable_5041;
true
gap> homalg_variable_5070 := SIH_BasisOfRowModule(homalg_variable_3358);;
gap> SI_nrows(homalg_variable_5070);
4
gap> homalg_variable_5071 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_5070 = homalg_variable_5071;
false
gap> homalg_variable_5073 := SIH_Submatrix(homalg_variable_18,[ 2, 3, 4, 5 ],[1..5]);;
gap> homalg_variable_5074 := homalg_variable_5003 * homalg_variable_5073;;
gap> homalg_variable_5072 := SIH_DecideZeroRows(homalg_variable_5074,homalg_variable_5070);;
gap> homalg_variable_5075 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_5072 = homalg_variable_5075;
true
gap> homalg_variable_5077 := SIH_Submatrix(homalg_variable_705,[1..4],[ 2, 3, 4 ]);;
gap> homalg_variable_5078 := homalg_variable_5077 * homalg_variable_5003;;
gap> homalg_variable_5076 := SIH_DecideZeroColumns(homalg_variable_5078,homalg_variable_3358);;
gap> homalg_variable_5079 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_5076 = homalg_variable_5079;
true
gap> homalg_variable_5056 = homalg_variable_5003;
false
gap> homalg_variable_5080 := SIH_DecideZeroColumns(homalg_variable_1101,homalg_variable_5056);;
gap> homalg_variable_5081 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_5080 = homalg_variable_5081;
false
gap> SIH_ZeroColumns(homalg_variable_5080);
[  ]
gap> homalg_variable_5082 := SIH_DecideZeroRows(homalg_variable_5003,homalg_variable_5023);;
gap> homalg_variable_5083 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5082 = homalg_variable_5083;
true
gap> homalg_variable_5084 := SIH_DecideZeroColumns(homalg_variable_5003,homalg_variable_5056);;
gap> homalg_variable_5085 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5084 = homalg_variable_5085;
true
gap> homalg_variable_5086 := SIH_DecideZeroColumns(homalg_variable_1101,homalg_variable_5056);;
gap> homalg_variable_5087 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_5086 = homalg_variable_5087;
false
gap> SIH_ZeroColumns(homalg_variable_5086);
[  ]
gap> SIH_GetUnitPosition(homalg_variable_5056,[ 0 ]);
fail
gap> homalg_variable_5088 := SIH_BasisOfRowModule(homalg_variable_5056);;
gap> SI_nrows(homalg_variable_5088);
3
gap> homalg_variable_5089 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5088 = homalg_variable_5089;
false
gap> homalg_variable_5090 := SIH_DecideZeroRows(homalg_variable_5056,homalg_variable_5088);;
gap> homalg_variable_5091 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5090 = homalg_variable_5091;
true
gap> homalg_variable_5092 := SIH_DecideZeroColumns(homalg_variable_1101,homalg_variable_5056);;
gap> homalg_variable_5093 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_5092 = homalg_variable_5093;
false
gap> SIH_ZeroColumns(homalg_variable_5092);
[  ]
gap> homalg_variable_5095 := homalg_variable_2571 * homalg_variable_2887;;
gap> homalg_variable_5096 := SIH_UnionOfColumns(homalg_variable_2566,homalg_variable_5095);;
gap> homalg_variable_5094 := SIH_BasisOfColumnModule(homalg_variable_5096);;
gap> SI_ncols(homalg_variable_5094);
7
gap> homalg_variable_5097 := SI_matrix(homalg_variable_5,10,7,"0");;
gap> homalg_variable_5094 = homalg_variable_5097;
false
gap> homalg_variable_5099 := homalg_variable_2571 * homalg_variable_3110;;
gap> homalg_variable_5100 := SIH_Submatrix(homalg_variable_3322,[1..2],[ 2, 3, 4 ]);;
gap> homalg_variable_5101 := homalg_variable_5099 * homalg_variable_5100;;
gap> homalg_variable_5098 := SIH_DecideZeroColumns(homalg_variable_5101,homalg_variable_5094);;
gap> homalg_variable_5102 := SI_matrix(homalg_variable_5,10,3,"0");;
gap> homalg_variable_5098 = homalg_variable_5102;
false
gap> homalg_variable_5103 := SI_matrix(homalg_variable_5,10,3,"0");;
gap> homalg_variable_5101 = homalg_variable_5103;
false
gap> homalg_variable_5098 = homalg_variable_5101;
true
gap> SIH_GetUnitPosition(homalg_variable_3536,[ 0 ]);
[ 2, 3 ]
gap> homalg_variable_5104 := SI_\[(homalg_variable_3536,3,2);;
gap> SI_deg(homalg_variable_5104);
0
gap> IsZero(homalg_variable_5104);
false
gap> IsOne(homalg_variable_5104);
false
gap> String( homalg_variable_7 );
"1"
gap> homalg_variable_5105 := SI_transpose(SI_matrix(homalg_variable_5,1,1,"1"));;
gap> String( homalg_variable_5104 );
"-1"
gap> homalg_variable_5106 := SI_transpose(SI_matrix(homalg_variable_5,1,1,"-1"));;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5106);; homalg_variable_5107 := homalg_variable_l[1];; homalg_variable_5108 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5107);
1
gap> homalg_variable_5109 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_5107 = homalg_variable_5109;
false
gap> SI_nrows(homalg_variable_5108);
1
gap> homalg_variable_5110 := homalg_variable_5106 * homalg_variable_5108;;
gap> homalg_variable_5107 = homalg_variable_5110;
true
gap> homalg_variable_5107 = homalg_variable_860;
true
gap> homalg_variable_5111 := homalg_variable_5108 * homalg_variable_5105;;
gap> homalg_variable_5112 := homalg_variable_5106 * homalg_variable_5111;;
gap> homalg_variable_5112 = homalg_variable_5105;
true
gap> homalg_variable_5113 := SI_\[(homalg_variable_5111,1,1);;
gap> String( homalg_variable_5113 );
"-1"
gap> homalg_variable_5114 := SI_transpose(SI_matrix(homalg_variable_5,1,1,"-1"));;
gap> homalg_variable_5115 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_5114 = homalg_variable_5115;
false
gap> homalg_variable_5116 := SIH_Submatrix(homalg_variable_3536,[1..5],[ 1, 3, 4 ]);;
gap> homalg_variable_5117 := SIH_Submatrix(homalg_variable_5116,[ 1, 2, 4, 5 ],[1..3]);;
gap> homalg_variable_5118 := SIH_Submatrix(homalg_variable_3536,[1..5],[ 2 ]);;
gap> homalg_variable_5119 := SIH_Submatrix(homalg_variable_5118,[ 1, 2, 4, 5 ],[1..1]);;
gap> homalg_variable_5120 := homalg_variable_5119 * homalg_variable_5114;;
gap> homalg_variable_5121 := SIH_Submatrix(homalg_variable_3536,[ 3 ],[1..4]);;
gap> homalg_variable_5122 := SIH_Submatrix(homalg_variable_5121,[1..1],[ 1, 3, 4 ]);;
gap> homalg_variable_5123 := homalg_variable_5120 * homalg_variable_5122;;
gap> homalg_variable_5124 := homalg_variable_5117 - homalg_variable_5123;;
gap> SIH_GetUnitPosition(homalg_variable_5124,[ 0 ]);
fail
gap> homalg_variable_5125 := SIH_Submatrix(homalg_variable_3536,[1..5],[ 1 ]);;
gap> homalg_variable_5126 := SIH_Submatrix(homalg_variable_1101,[ 1 ],[1..3]);;
gap> homalg_variable_5127 := homalg_variable_5125 * homalg_variable_5126;;
gap> homalg_variable_5128 := SIH_Submatrix(homalg_variable_3536,[1..5],[ 2 ]);;
gap> homalg_variable_5129 := homalg_variable_5114 * homalg_variable_5122;;
gap> homalg_variable_5130 := homalg_variable_5129 * (homalg_variable_8);;
gap> homalg_variable_5131 := homalg_variable_5128 * homalg_variable_5130;;
gap> homalg_variable_5132 := homalg_variable_5127 + homalg_variable_5131;;
gap> homalg_variable_5133 := SIH_Submatrix(homalg_variable_3536,[1..5],[ 3, 4 ]);;
gap> homalg_variable_5134 := SIH_Submatrix(homalg_variable_1101,[ 2, 3 ],[1..3]);;
gap> homalg_variable_5135 := homalg_variable_5133 * homalg_variable_5134;;
gap> homalg_variable_5136 := homalg_variable_5132 + homalg_variable_5135;;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_5136);; homalg_variable_5137 := homalg_variable_l[1];; homalg_variable_5138 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_5137);
4
gap> homalg_variable_5139 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_5137 = homalg_variable_5139;
false
gap> SI_ncols(homalg_variable_5138);
5
gap> homalg_variable_5140 := homalg_variable_5138 * homalg_variable_5136;;
gap> homalg_variable_5137 = homalg_variable_5140;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_5124,homalg_variable_5137);; homalg_variable_5141 := homalg_variable_l[1];; homalg_variable_5142 := homalg_variable_l[2];;
gap> homalg_variable_5143 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_5141 = homalg_variable_5143;
true
gap> homalg_variable_5144 := homalg_variable_5142 * homalg_variable_5137;;
gap> homalg_variable_5145 := homalg_variable_5124 + homalg_variable_5144;;
gap> homalg_variable_5141 = homalg_variable_5145;
true
gap> homalg_variable_5146 := SIH_DecideZeroRows(homalg_variable_5124,homalg_variable_5137);;
gap> homalg_variable_5147 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_5146 = homalg_variable_5147;
true
gap> homalg_variable_5148 := homalg_variable_5142 * (homalg_variable_8);;
gap> homalg_variable_5149 := homalg_variable_5148 * homalg_variable_5138;;
gap> homalg_variable_5150 := homalg_variable_5149 * homalg_variable_5136;;
gap> homalg_variable_5150 = homalg_variable_5124;
true
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_5124);; homalg_variable_5151 := homalg_variable_l[1];; homalg_variable_5152 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_5151);
4
gap> homalg_variable_5153 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_5151 = homalg_variable_5153;
false
gap> SI_ncols(homalg_variable_5152);
4
gap> homalg_variable_5154 := homalg_variable_5152 * homalg_variable_5124;;
gap> homalg_variable_5151 = homalg_variable_5154;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_5136,homalg_variable_5151);; homalg_variable_5155 := homalg_variable_l[1];; homalg_variable_5156 := homalg_variable_l[2];;
gap> homalg_variable_5157 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_5155 = homalg_variable_5157;
true
gap> homalg_variable_5158 := homalg_variable_5156 * homalg_variable_5151;;
gap> homalg_variable_5159 := homalg_variable_5136 + homalg_variable_5158;;
gap> homalg_variable_5155 = homalg_variable_5159;
true
gap> homalg_variable_5160 := SIH_DecideZeroRows(homalg_variable_5136,homalg_variable_5151);;
gap> homalg_variable_5161 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_5160 = homalg_variable_5161;
true
gap> homalg_variable_5162 := homalg_variable_5156 * (homalg_variable_8);;
gap> homalg_variable_5163 := homalg_variable_5162 * homalg_variable_5152;;
gap> homalg_variable_5164 := homalg_variable_5163 * homalg_variable_5124;;
gap> homalg_variable_5164 = homalg_variable_5136;
true
gap> homalg_variable_5165 := SIH_Submatrix(homalg_variable_705,[1..4],[ 1, 2 ]);;
gap> homalg_variable_5166 := SIH_Submatrix(homalg_variable_3536,[ 1, 2 ],[1..4]);;
gap> homalg_variable_5167 := homalg_variable_5165 * homalg_variable_5166;;
gap> homalg_variable_5168 := homalg_variable_5120 * (homalg_variable_8);;
gap> homalg_variable_5169 := SIH_Submatrix(homalg_variable_3536,[ 3 ],[1..4]);;
gap> homalg_variable_5170 := homalg_variable_5168 * homalg_variable_5169;;
gap> homalg_variable_5171 := homalg_variable_5167 + homalg_variable_5170;;
gap> homalg_variable_5172 := SIH_Submatrix(homalg_variable_705,[1..4],[ 3, 4 ]);;
gap> homalg_variable_5173 := SIH_Submatrix(homalg_variable_3536,[ 4, 5 ],[1..4]);;
gap> homalg_variable_5174 := homalg_variable_5172 * homalg_variable_5173;;
gap> homalg_variable_5175 := homalg_variable_5171 + homalg_variable_5174;;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5175);; homalg_variable_5176 := homalg_variable_l[1];; homalg_variable_5177 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5176);
3
gap> homalg_variable_5178 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_5176 = homalg_variable_5178;
false
gap> SI_nrows(homalg_variable_5177);
4
gap> homalg_variable_5179 := homalg_variable_5175 * homalg_variable_5177;;
gap> homalg_variable_5176 = homalg_variable_5179;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5124,homalg_variable_5176);; homalg_variable_5180 := homalg_variable_l[1];; homalg_variable_5181 := homalg_variable_l[2];;
gap> homalg_variable_5182 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_5180 = homalg_variable_5182;
true
gap> homalg_variable_5183 := homalg_variable_5176 * homalg_variable_5181;;
gap> homalg_variable_5184 := homalg_variable_5124 + homalg_variable_5183;;
gap> homalg_variable_5180 = homalg_variable_5184;
true
gap> homalg_variable_5185 := SIH_DecideZeroColumns(homalg_variable_5124,homalg_variable_5176);;
gap> homalg_variable_5186 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_5185 = homalg_variable_5186;
true
gap> homalg_variable_5187 := homalg_variable_5181 * (homalg_variable_8);;
gap> homalg_variable_5188 := homalg_variable_5177 * homalg_variable_5187;;
gap> homalg_variable_5189 := homalg_variable_5175 * homalg_variable_5188;;
gap> homalg_variable_5189 = homalg_variable_5124;
true
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5124);; homalg_variable_5190 := homalg_variable_l[1];; homalg_variable_5191 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5190);
3
gap> homalg_variable_5192 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_5190 = homalg_variable_5192;
false
gap> SI_nrows(homalg_variable_5191);
3
gap> homalg_variable_5193 := homalg_variable_5124 * homalg_variable_5191;;
gap> homalg_variable_5190 = homalg_variable_5193;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5175,homalg_variable_5190);; homalg_variable_5194 := homalg_variable_l[1];; homalg_variable_5195 := homalg_variable_l[2];;
gap> homalg_variable_5196 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_5194 = homalg_variable_5196;
true
gap> homalg_variable_5197 := homalg_variable_5190 * homalg_variable_5195;;
gap> homalg_variable_5198 := homalg_variable_5175 + homalg_variable_5197;;
gap> homalg_variable_5194 = homalg_variable_5198;
true
gap> homalg_variable_5199 := SIH_DecideZeroColumns(homalg_variable_5175,homalg_variable_5190);;
gap> homalg_variable_5200 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_5199 = homalg_variable_5200;
true
gap> homalg_variable_5201 := homalg_variable_5195 * (homalg_variable_8);;
gap> homalg_variable_5202 := homalg_variable_5191 * homalg_variable_5201;;
gap> homalg_variable_5203 := homalg_variable_5124 * homalg_variable_5202;;
gap> homalg_variable_5203 = homalg_variable_5175;
true
gap> homalg_variable_5204 := SIH_BasisOfRowModule(homalg_variable_3536);;
gap> SI_nrows(homalg_variable_5204);
5
gap> homalg_variable_5205 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5204 = homalg_variable_5205;
false
gap> homalg_variable_5207 := SIH_Submatrix(homalg_variable_705,[ 1, 3, 4 ],[1..4]);;
gap> homalg_variable_5208 := homalg_variable_5124 * homalg_variable_5207;;
gap> homalg_variable_5206 := SIH_DecideZeroRows(homalg_variable_5208,homalg_variable_5204);;
gap> homalg_variable_5209 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_5206 = homalg_variable_5209;
true
gap> homalg_variable_5211 := SIH_Submatrix(homalg_variable_18,[1..5],[ 1, 2, 4, 5 ]);;
gap> homalg_variable_5212 := homalg_variable_5211 * homalg_variable_5124;;
gap> homalg_variable_5210 := SIH_DecideZeroColumns(homalg_variable_5212,homalg_variable_3536);;
gap> homalg_variable_5213 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_5210 = homalg_variable_5213;
true
gap> homalg_variable_5190 = homalg_variable_5124;
false
gap> homalg_variable_5214 := SIH_DecideZeroColumns(homalg_variable_705,homalg_variable_5190);;
gap> homalg_variable_5215 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_5214 = homalg_variable_5215;
false
gap> SIH_ZeroColumns(homalg_variable_5214);
[  ]
gap> homalg_variable_5216 := SIH_DecideZeroRows(homalg_variable_5124,homalg_variable_5151);;
gap> homalg_variable_5217 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_5216 = homalg_variable_5217;
true
gap> homalg_variable_5218 := SIH_DecideZeroColumns(homalg_variable_5124,homalg_variable_5190);;
gap> homalg_variable_5219 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_5218 = homalg_variable_5219;
true
gap> homalg_variable_5220 := SIH_DecideZeroColumns(homalg_variable_705,homalg_variable_5190);;
gap> homalg_variable_5221 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_5220 = homalg_variable_5221;
false
gap> SIH_ZeroColumns(homalg_variable_5220);
[  ]
gap> SIH_GetUnitPosition(homalg_variable_5190,[ 0 ]);
fail
gap> homalg_variable_5222 := SIH_BasisOfRowModule(homalg_variable_5190);;
gap> SI_nrows(homalg_variable_5222);
4
gap> homalg_variable_5223 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_5222 = homalg_variable_5223;
false
gap> homalg_variable_5224 := SIH_DecideZeroRows(homalg_variable_5190,homalg_variable_5222);;
gap> homalg_variable_5225 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_5224 = homalg_variable_5225;
true
gap> homalg_variable_5226 := SIH_DecideZeroColumns(homalg_variable_705,homalg_variable_5190);;
gap> homalg_variable_5227 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_5226 = homalg_variable_5227;
false
gap> SIH_ZeroColumns(homalg_variable_5226);
[  ]
gap> homalg_variable_5229 := homalg_variable_3435 * homalg_variable_3362;;
gap> homalg_variable_5230 := SIH_Submatrix(homalg_variable_3500,[1..3],[ 1, 2, 4, 5 ]);;
gap> homalg_variable_5231 := homalg_variable_5229 * homalg_variable_5230;;
gap> homalg_variable_5228 := SIH_DecideZeroColumns(homalg_variable_5231,homalg_variable_2646);;
gap> homalg_variable_5232 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_5228 = homalg_variable_5232;
false
gap> homalg_variable_5233 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_5231 = homalg_variable_5233;
false
gap> homalg_variable_5228 = homalg_variable_5231;
true
gap> SIH_GetUnitPosition(homalg_variable_10,[ 0 ]);
fail
gap> homalg_variable_5234 := SIH_DecideZeroRows(homalg_variable_10,homalg_variable_225);;
gap> homalg_variable_5235 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5234 = homalg_variable_5235;
true
gap> homalg_variable_5236 := SIH_DecideZeroColumns(homalg_variable_18,homalg_variable_10);;
gap> homalg_variable_5237 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5236 = homalg_variable_5237;
false
gap> SIH_ZeroColumns(homalg_variable_5236);
[  ]
gap> homalg_variable_5238 := SIH_DecideZeroColumns(homalg_variable_18,homalg_variable_10);;
gap> homalg_variable_5239 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5238 = homalg_variable_5239;
false
gap> homalg_variable_5238 = homalg_variable_18;
true
gap> homalg_variable_5240 := SIH_DecideZeroColumns(homalg_variable_4848,homalg_variable_10);;
gap> homalg_variable_5241 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_5240 = homalg_variable_5241;
false
gap> homalg_variable_5242 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_4848 = homalg_variable_5242;
false
gap> homalg_variable_5243 := SIH_DecideZeroColumns(homalg_variable_4854,homalg_variable_10);;
gap> homalg_variable_5244 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_5243 = homalg_variable_5244;
false
gap> homalg_variable_5245 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_4854 = homalg_variable_5245;
false
gap> homalg_variable_5247 := SIH_Submatrix(homalg_variable_4895,[1..5],[ 2, 3, 4 ]);;
gap> homalg_variable_5246 := SIH_DecideZeroColumns(homalg_variable_5247,homalg_variable_10);;
gap> homalg_variable_5248 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_5246 = homalg_variable_5248;
false
gap> homalg_variable_5249 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_5247 = homalg_variable_5249;
false
gap> homalg_variable_5251 := SIH_Submatrix(homalg_variable_4936,[1..5],[ 1, 2, 4, 5 ]);;
gap> homalg_variable_5250 := SIH_DecideZeroColumns(homalg_variable_5251,homalg_variable_10);;
gap> homalg_variable_5252 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5250 = homalg_variable_5252;
false
gap> homalg_variable_5253 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5251 = homalg_variable_5253;
false
gap> homalg_variable_3366 = homalg_variable_3362;
true
gap> homalg_variable_5254 := SIH_DecideZeroColumns(homalg_variable_618,homalg_variable_3366);;
gap> homalg_variable_5255 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_5254 = homalg_variable_5255;
false
gap> SIH_ZeroColumns(homalg_variable_5254);
[ 2 ]
gap> homalg_variable_5256 := SIH_Submatrix(homalg_variable_3366,[ 1 ],[1..3]);;
gap> SIH_ZeroColumns(homalg_variable_5256);
[ 1 ]
gap> homalg_variable_5258 := SIH_Submatrix(homalg_variable_3500,[1..3],[ 1, 2, 4, 5 ]);;
gap> homalg_variable_5259 := SIH_UnionOfColumns(homalg_variable_5258,homalg_variable_3393);;
gap> homalg_variable_5257 := SIH_BasisOfColumnModule(homalg_variable_5259);;
gap> SI_ncols(homalg_variable_5257);
5
gap> homalg_variable_5260 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_5257 = homalg_variable_5260;
false
gap> homalg_variable_5257 = homalg_variable_5259;
false
gap> homalg_variable_5261 := SIH_DecideZeroColumns(homalg_variable_1101,homalg_variable_5257);;
gap> homalg_variable_5262 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_5261 = homalg_variable_5262;
false
gap> SIH_ZeroColumns(homalg_variable_5261);
[ 2 ]
gap> homalg_variable_5263 := SIH_Submatrix(homalg_variable_5258,[ 1, 3 ],[1..4]);;
gap> homalg_variable_5264 := SIH_Submatrix(homalg_variable_3393,[ 1, 3 ],[1..1]);;
gap> homalg_variable_5265 := SIH_UnionOfColumns(homalg_variable_5263,homalg_variable_5264);;
gap> SIH_ZeroColumns(homalg_variable_5265);
[ 1 ]
gap> homalg_variable_5266 := SIH_DecideZeroColumns(homalg_variable_5250,homalg_variable_4929);;
gap> homalg_variable_5267 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5266 = homalg_variable_5267;
false
gap> homalg_variable_5268 := SIH_UnionOfColumns(homalg_variable_5266,homalg_variable_4929);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5268);; homalg_variable_5269 := homalg_variable_l[1];; homalg_variable_5270 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5269);
5
gap> homalg_variable_5271 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5269 = homalg_variable_5271;
false
gap> SI_nrows(homalg_variable_5270);
8
gap> homalg_variable_5272 := SIH_Submatrix(homalg_variable_5270,[ 1, 2, 3, 4 ],[1..5]);;
gap> homalg_variable_5273 := homalg_variable_5266 * homalg_variable_5272;;
gap> homalg_variable_5274 := SIH_Submatrix(homalg_variable_5270,[ 5, 6, 7, 8 ],[1..5]);;
gap> homalg_variable_5275 := homalg_variable_4929 * homalg_variable_5274;;
gap> homalg_variable_5276 := homalg_variable_5273 + homalg_variable_5275;;
gap> homalg_variable_5269 = homalg_variable_5276;
true
gap> homalg_variable_5277 := SIH_DecideZeroColumns(homalg_variable_18,homalg_variable_4929);;
gap> homalg_variable_5278 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5277 = homalg_variable_5278;
false
gap> homalg_variable_5269 = homalg_variable_18;
true
gap> homalg_variable_5280 := SIH_Submatrix(homalg_variable_5270,[ 1, 2, 3, 4 ],[1..5]);;
gap> homalg_variable_5281 := homalg_variable_5280 * homalg_variable_5277;;
gap> homalg_variable_5282 := homalg_variable_5250 * homalg_variable_5281;;
gap> homalg_variable_5283 := homalg_variable_5282 - homalg_variable_18;;
gap> homalg_variable_5279 := SIH_DecideZeroColumns(homalg_variable_5283,homalg_variable_4929);;
gap> homalg_variable_5284 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5279 = homalg_variable_5284;
true
gap> homalg_variable_5286 := homalg_variable_5281 * homalg_variable_10;;
gap> homalg_variable_5285 := SIH_DecideZeroColumns(homalg_variable_5286,homalg_variable_5190);;
gap> homalg_variable_5287 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_5285 = homalg_variable_5287;
true
gap> homalg_variable_5288 := SIH_DecideZeroColumns(homalg_variable_4930,homalg_variable_10);;
gap> homalg_variable_5289 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5288 = homalg_variable_5289;
false
gap> SIH_ZeroColumns(homalg_variable_5288);
[  ]
gap> homalg_variable_5290 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_5288,homalg_variable_10);;
gap> SI_ncols(homalg_variable_5290);
10
gap> homalg_variable_5291 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_5290 = homalg_variable_5291;
false
gap> homalg_variable_5293 := homalg_variable_5288 * homalg_variable_5290;;
gap> homalg_variable_5292 := SIH_DecideZeroColumns(homalg_variable_5293,homalg_variable_10);;
gap> homalg_variable_5294 := SI_matrix(homalg_variable_5,5,10,"0");;
gap> homalg_variable_5292 = homalg_variable_5294;
true
gap> homalg_variable_5295 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_5288,homalg_variable_10);;
gap> SI_ncols(homalg_variable_5295);
10
gap> homalg_variable_5296 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_5295 = homalg_variable_5296;
false
gap> homalg_variable_5297 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5295);;
gap> SI_ncols(homalg_variable_5297);
5
gap> homalg_variable_5298 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_5297 = homalg_variable_5298;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_5297,[ 0 ]);
[ [ 5, 4 ] ]
gap> homalg_variable_5300 := SIH_Submatrix(homalg_variable_5295,[1..6],[ 1, 2, 3, 5, 6, 7, 8, 9, 10 ]);;
gap> homalg_variable_5299 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5300);;
gap> SI_ncols(homalg_variable_5299);
4
gap> homalg_variable_5301 := SI_matrix(homalg_variable_5,9,4,"0");;
gap> homalg_variable_5299 = homalg_variable_5301;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_5299,[ 0 ]);
[  ]
gap> homalg_variable_5302 := SI_matrix(homalg_variable_5,6,9,"0");;
gap> homalg_variable_5300 = homalg_variable_5302;
false
gap> homalg_variable_5303 := SIH_BasisOfColumnModule(homalg_variable_5295);;
gap> SI_ncols(homalg_variable_5303);
10
gap> homalg_variable_5304 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_5303 = homalg_variable_5304;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5300);; homalg_variable_5305 := homalg_variable_l[1];; homalg_variable_5306 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5305);
10
gap> homalg_variable_5307 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_5305 = homalg_variable_5307;
false
gap> SI_nrows(homalg_variable_5306);
9
gap> homalg_variable_5308 := homalg_variable_5300 * homalg_variable_5306;;
gap> homalg_variable_5305 = homalg_variable_5308;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5303,homalg_variable_5305);; homalg_variable_5309 := homalg_variable_l[1];; homalg_variable_5310 := homalg_variable_l[2];;
gap> homalg_variable_5311 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_5309 = homalg_variable_5311;
true
gap> homalg_variable_5312 := homalg_variable_5305 * homalg_variable_5310;;
gap> homalg_variable_5313 := homalg_variable_5303 + homalg_variable_5312;;
gap> homalg_variable_5309 = homalg_variable_5313;
true
gap> homalg_variable_5314 := SIH_DecideZeroColumns(homalg_variable_5303,homalg_variable_5305);;
gap> homalg_variable_5315 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_5314 = homalg_variable_5315;
true
gap> homalg_variable_5316 := homalg_variable_5310 * (homalg_variable_8);;
gap> homalg_variable_5317 := homalg_variable_5306 * homalg_variable_5316;;
gap> homalg_variable_5318 := homalg_variable_5300 * homalg_variable_5317;;
gap> homalg_variable_5318 = homalg_variable_5303;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5300,homalg_variable_5303);; homalg_variable_5319 := homalg_variable_l[1];; homalg_variable_5320 := homalg_variable_l[2];;
gap> homalg_variable_5321 := SI_matrix(homalg_variable_5,6,9,"0");;
gap> homalg_variable_5319 = homalg_variable_5321;
true
gap> homalg_variable_5322 := homalg_variable_5303 * homalg_variable_5320;;
gap> homalg_variable_5323 := homalg_variable_5300 + homalg_variable_5322;;
gap> homalg_variable_5319 = homalg_variable_5323;
true
gap> homalg_variable_5324 := SIH_DecideZeroColumns(homalg_variable_5300,homalg_variable_5303);;
gap> homalg_variable_5325 := SI_matrix(homalg_variable_5,6,9,"0");;
gap> homalg_variable_5324 = homalg_variable_5325;
true
gap> homalg_variable_5326 := homalg_variable_5320 * (homalg_variable_8);;
gap> homalg_variable_5327 := homalg_variable_5303 * homalg_variable_5326;;
gap> homalg_variable_5327 = homalg_variable_5300;
true
gap> homalg_variable_5328 := SIH_BasisOfColumnModule(homalg_variable_5290);;
gap> SI_ncols(homalg_variable_5328);
10
gap> homalg_variable_5329 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_5328 = homalg_variable_5329;
false
gap> homalg_variable_5328 = homalg_variable_5290;
true
gap> homalg_variable_5330 := SIH_DecideZeroColumns(homalg_variable_5300,homalg_variable_5328);;
gap> homalg_variable_5331 := SI_matrix(homalg_variable_5,6,9,"0");;
gap> homalg_variable_5330 = homalg_variable_5331;
true
gap> homalg_variable_5332 := SIH_UnionOfColumns(homalg_variable_5288,homalg_variable_10);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5332);; homalg_variable_5333 := homalg_variable_l[1];; homalg_variable_5334 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5333);
4
gap> homalg_variable_5335 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5333 = homalg_variable_5335;
false
gap> SI_nrows(homalg_variable_5334);
12
gap> homalg_variable_5336 := SIH_Submatrix(homalg_variable_5334,[ 1, 2, 3, 4, 5, 6 ],[1..4]);;
gap> homalg_variable_5337 := homalg_variable_5288 * homalg_variable_5336;;
gap> homalg_variable_5338 := SIH_Submatrix(homalg_variable_5334,[ 7, 8, 9, 10, 11, 12 ],[1..4]);;
gap> homalg_variable_5339 := homalg_variable_10 * homalg_variable_5338;;
gap> homalg_variable_5340 := homalg_variable_5337 + homalg_variable_5339;;
gap> homalg_variable_5333 = homalg_variable_5340;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5240,homalg_variable_5333);; homalg_variable_5341 := homalg_variable_l[1];; homalg_variable_5342 := homalg_variable_l[2];;
gap> homalg_variable_5343 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_5341 = homalg_variable_5343;
true
gap> homalg_variable_5344 := homalg_variable_5333 * homalg_variable_5342;;
gap> homalg_variable_5345 := homalg_variable_5240 + homalg_variable_5344;;
gap> homalg_variable_5341 = homalg_variable_5345;
true
gap> homalg_variable_5346 := SIH_DecideZeroColumns(homalg_variable_5240,homalg_variable_5333);;
gap> homalg_variable_5347 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_5346 = homalg_variable_5347;
true
gap> homalg_variable_5349 := SIH_Submatrix(homalg_variable_5334,[ 1, 2, 3, 4, 5, 6 ],[1..4]);;
gap> homalg_variable_5350 := homalg_variable_5342 * (homalg_variable_8);;
gap> homalg_variable_5351 := homalg_variable_5349 * homalg_variable_5350;;
gap> homalg_variable_5352 := homalg_variable_5288 * homalg_variable_5351;;
gap> homalg_variable_5353 := homalg_variable_5352 - homalg_variable_5240;;
gap> homalg_variable_5348 := SIH_DecideZeroColumns(homalg_variable_5353,homalg_variable_10);;
gap> homalg_variable_5354 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_5348 = homalg_variable_5354;
true
gap> homalg_variable_5355 := SIH_UnionOfColumns(homalg_variable_5288,homalg_variable_10);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5355);; homalg_variable_5356 := homalg_variable_l[1];; homalg_variable_5357 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5356);
4
gap> homalg_variable_5358 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5356 = homalg_variable_5358;
false
gap> SI_nrows(homalg_variable_5357);
12
gap> homalg_variable_5359 := SIH_Submatrix(homalg_variable_5357,[ 1, 2, 3, 4, 5, 6 ],[1..4]);;
gap> homalg_variable_5360 := homalg_variable_5288 * homalg_variable_5359;;
gap> homalg_variable_5361 := SIH_Submatrix(homalg_variable_5357,[ 7, 8, 9, 10, 11, 12 ],[1..4]);;
gap> homalg_variable_5362 := homalg_variable_10 * homalg_variable_5361;;
gap> homalg_variable_5363 := homalg_variable_5360 + homalg_variable_5362;;
gap> homalg_variable_5356 = homalg_variable_5363;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5243,homalg_variable_5356);; homalg_variable_5364 := homalg_variable_l[1];; homalg_variable_5365 := homalg_variable_l[2];;
gap> homalg_variable_5366 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_5364 = homalg_variable_5366;
true
gap> homalg_variable_5367 := homalg_variable_5356 * homalg_variable_5365;;
gap> homalg_variable_5368 := homalg_variable_5243 + homalg_variable_5367;;
gap> homalg_variable_5364 = homalg_variable_5368;
true
gap> homalg_variable_5369 := SIH_DecideZeroColumns(homalg_variable_5243,homalg_variable_5356);;
gap> homalg_variable_5370 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_5369 = homalg_variable_5370;
true
gap> homalg_variable_5372 := SIH_Submatrix(homalg_variable_5357,[ 1, 2, 3, 4, 5, 6 ],[1..4]);;
gap> homalg_variable_5373 := homalg_variable_5365 * (homalg_variable_8);;
gap> homalg_variable_5374 := homalg_variable_5372 * homalg_variable_5373;;
gap> homalg_variable_5375 := homalg_variable_5288 * homalg_variable_5374;;
gap> homalg_variable_5376 := homalg_variable_5375 - homalg_variable_5243;;
gap> homalg_variable_5371 := SIH_DecideZeroColumns(homalg_variable_5376,homalg_variable_10);;
gap> homalg_variable_5377 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_5371 = homalg_variable_5377;
true
gap> homalg_variable_5378 := SIH_UnionOfColumns(homalg_variable_5288,homalg_variable_10);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5378);; homalg_variable_5379 := homalg_variable_l[1];; homalg_variable_5380 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5379);
4
gap> homalg_variable_5381 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5379 = homalg_variable_5381;
false
gap> SI_nrows(homalg_variable_5380);
12
gap> homalg_variable_5382 := SIH_Submatrix(homalg_variable_5380,[ 1, 2, 3, 4, 5, 6 ],[1..4]);;
gap> homalg_variable_5383 := homalg_variable_5288 * homalg_variable_5382;;
gap> homalg_variable_5384 := SIH_Submatrix(homalg_variable_5380,[ 7, 8, 9, 10, 11, 12 ],[1..4]);;
gap> homalg_variable_5385 := homalg_variable_10 * homalg_variable_5384;;
gap> homalg_variable_5386 := homalg_variable_5383 + homalg_variable_5385;;
gap> homalg_variable_5379 = homalg_variable_5386;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5246,homalg_variable_5379);; homalg_variable_5387 := homalg_variable_l[1];; homalg_variable_5388 := homalg_variable_l[2];;
gap> homalg_variable_5389 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_5387 = homalg_variable_5389;
true
gap> homalg_variable_5390 := homalg_variable_5379 * homalg_variable_5388;;
gap> homalg_variable_5391 := homalg_variable_5246 + homalg_variable_5390;;
gap> homalg_variable_5387 = homalg_variable_5391;
true
gap> homalg_variable_5392 := SIH_DecideZeroColumns(homalg_variable_5246,homalg_variable_5379);;
gap> homalg_variable_5393 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_5392 = homalg_variable_5393;
true
gap> homalg_variable_5395 := SIH_Submatrix(homalg_variable_5380,[ 1, 2, 3, 4, 5, 6 ],[1..4]);;
gap> homalg_variable_5396 := homalg_variable_5388 * (homalg_variable_8);;
gap> homalg_variable_5397 := homalg_variable_5395 * homalg_variable_5396;;
gap> homalg_variable_5398 := homalg_variable_5288 * homalg_variable_5397;;
gap> homalg_variable_5399 := homalg_variable_5398 - homalg_variable_5246;;
gap> homalg_variable_5394 := SIH_DecideZeroColumns(homalg_variable_5399,homalg_variable_10);;
gap> homalg_variable_5400 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_5394 = homalg_variable_5400;
true
gap> homalg_variable_5402 := SI_matrix(homalg_variable_5,5,12,"0");;
gap> homalg_variable_5403 := SIH_UnionOfColumns(homalg_variable_5402,homalg_variable_10);;
gap> homalg_variable_5401 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_5288,homalg_variable_5403);;
gap> SI_ncols(homalg_variable_5401);
10
gap> homalg_variable_5404 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_5401 = homalg_variable_5404;
false
gap> homalg_variable_5405 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5401);;
gap> SI_ncols(homalg_variable_5405);
5
gap> homalg_variable_5406 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_5405 = homalg_variable_5406;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_5405,[ 0 ]);
[ [ 5, 4 ] ]
gap> homalg_variable_5408 := SIH_Submatrix(homalg_variable_5401,[1..6],[ 1, 2, 3, 5, 6, 7, 8, 9, 10 ]);;
gap> homalg_variable_5407 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5408);;
gap> SI_ncols(homalg_variable_5407);
4
gap> homalg_variable_5409 := SI_matrix(homalg_variable_5,9,4,"0");;
gap> homalg_variable_5407 = homalg_variable_5409;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_5407,[ 0 ]);
[  ]
gap> homalg_variable_5410 := SI_matrix(homalg_variable_5,6,9,"0");;
gap> homalg_variable_5408 = homalg_variable_5410;
false
gap> homalg_variable_5411 := SIH_BasisOfColumnModule(homalg_variable_5401);;
gap> SI_ncols(homalg_variable_5411);
10
gap> homalg_variable_5412 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_5411 = homalg_variable_5412;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5408);; homalg_variable_5413 := homalg_variable_l[1];; homalg_variable_5414 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5413);
10
gap> homalg_variable_5415 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_5413 = homalg_variable_5415;
false
gap> SI_nrows(homalg_variable_5414);
9
gap> homalg_variable_5416 := homalg_variable_5408 * homalg_variable_5414;;
gap> homalg_variable_5413 = homalg_variable_5416;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5411,homalg_variable_5413);; homalg_variable_5417 := homalg_variable_l[1];; homalg_variable_5418 := homalg_variable_l[2];;
gap> homalg_variable_5419 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_5417 = homalg_variable_5419;
true
gap> homalg_variable_5420 := homalg_variable_5413 * homalg_variable_5418;;
gap> homalg_variable_5421 := homalg_variable_5411 + homalg_variable_5420;;
gap> homalg_variable_5417 = homalg_variable_5421;
true
gap> homalg_variable_5422 := SIH_DecideZeroColumns(homalg_variable_5411,homalg_variable_5413);;
gap> homalg_variable_5423 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_5422 = homalg_variable_5423;
true
gap> homalg_variable_5424 := homalg_variable_5418 * (homalg_variable_8);;
gap> homalg_variable_5425 := homalg_variable_5414 * homalg_variable_5424;;
gap> homalg_variable_5426 := homalg_variable_5408 * homalg_variable_5425;;
gap> homalg_variable_5426 = homalg_variable_5411;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5408,homalg_variable_5411);; homalg_variable_5427 := homalg_variable_l[1];; homalg_variable_5428 := homalg_variable_l[2];;
gap> homalg_variable_5429 := SI_matrix(homalg_variable_5,6,9,"0");;
gap> homalg_variable_5427 = homalg_variable_5429;
true
gap> homalg_variable_5430 := homalg_variable_5411 * homalg_variable_5428;;
gap> homalg_variable_5431 := homalg_variable_5408 + homalg_variable_5430;;
gap> homalg_variable_5427 = homalg_variable_5431;
true
gap> homalg_variable_5432 := SIH_DecideZeroColumns(homalg_variable_5408,homalg_variable_5411);;
gap> homalg_variable_5433 := SI_matrix(homalg_variable_5,6,9,"0");;
gap> homalg_variable_5432 = homalg_variable_5433;
true
gap> homalg_variable_5434 := homalg_variable_5428 * (homalg_variable_8);;
gap> homalg_variable_5435 := homalg_variable_5411 * homalg_variable_5434;;
gap> homalg_variable_5435 = homalg_variable_5408;
true
gap> homalg_variable_5436 := SIH_DecideZeroColumns(homalg_variable_5408,homalg_variable_5328);;
gap> homalg_variable_5437 := SI_matrix(homalg_variable_5,6,9,"0");;
gap> homalg_variable_5436 = homalg_variable_5437;
true
gap> homalg_variable_5439 := homalg_variable_5351 * homalg_variable_2959;;
gap> homalg_variable_5438 := SIH_DecideZeroColumns(homalg_variable_5439,homalg_variable_5328);;
gap> homalg_variable_5440 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_5438 = homalg_variable_5440;
true
gap> homalg_variable_5441 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_5351,homalg_variable_5328);;
gap> SI_ncols(homalg_variable_5441);
3
gap> homalg_variable_5442 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5441 = homalg_variable_5442;
false
gap> homalg_variable_5443 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5441);;
gap> SI_ncols(homalg_variable_5443);
3
gap> homalg_variable_5444 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_5443 = homalg_variable_5444;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_5443,[ 0 ]);
[  ]
gap> homalg_variable_5445 := SIH_BasisOfColumnModule(homalg_variable_5441);;
gap> SI_ncols(homalg_variable_5445);
3
gap> homalg_variable_5446 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5445 = homalg_variable_5446;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5441);; homalg_variable_5447 := homalg_variable_l[1];; homalg_variable_5448 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5447);
3
gap> homalg_variable_5449 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5447 = homalg_variable_5449;
false
gap> SI_nrows(homalg_variable_5448);
3
gap> homalg_variable_5450 := homalg_variable_5441 * homalg_variable_5448;;
gap> homalg_variable_5447 = homalg_variable_5450;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5445,homalg_variable_5447);; homalg_variable_5451 := homalg_variable_l[1];; homalg_variable_5452 := homalg_variable_l[2];;
gap> homalg_variable_5453 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5451 = homalg_variable_5453;
true
gap> homalg_variable_5454 := homalg_variable_5447 * homalg_variable_5452;;
gap> homalg_variable_5455 := homalg_variable_5445 + homalg_variable_5454;;
gap> homalg_variable_5451 = homalg_variable_5455;
true
gap> homalg_variable_5456 := SIH_DecideZeroColumns(homalg_variable_5445,homalg_variable_5447);;
gap> homalg_variable_5457 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5456 = homalg_variable_5457;
true
gap> homalg_variable_5458 := homalg_variable_5452 * (homalg_variable_8);;
gap> homalg_variable_5459 := homalg_variable_5448 * homalg_variable_5458;;
gap> homalg_variable_5460 := homalg_variable_5441 * homalg_variable_5459;;
gap> homalg_variable_5460 = homalg_variable_5445;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5441,homalg_variable_5445);; homalg_variable_5461 := homalg_variable_l[1];; homalg_variable_5462 := homalg_variable_l[2];;
gap> homalg_variable_5463 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5461 = homalg_variable_5463;
true
gap> homalg_variable_5464 := homalg_variable_5445 * homalg_variable_5462;;
gap> homalg_variable_5465 := homalg_variable_5441 + homalg_variable_5464;;
gap> homalg_variable_5461 = homalg_variable_5465;
true
gap> homalg_variable_5466 := SIH_DecideZeroColumns(homalg_variable_5441,homalg_variable_5445);;
gap> homalg_variable_5467 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5466 = homalg_variable_5467;
true
gap> homalg_variable_5468 := homalg_variable_5462 * (homalg_variable_8);;
gap> homalg_variable_5469 := homalg_variable_5445 * homalg_variable_5468;;
gap> homalg_variable_5469 = homalg_variable_5441;
true
gap> homalg_variable_5470 := SIH_DecideZeroColumns(homalg_variable_5441,homalg_variable_2959);;
gap> homalg_variable_5471 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5470 = homalg_variable_5471;
true
gap> homalg_variable_5473 := SIH_UnionOfColumns(homalg_variable_5351,homalg_variable_5328);;
gap> homalg_variable_5472 := SIH_BasisOfColumnModule(homalg_variable_5473);;
gap> SI_ncols(homalg_variable_5472);
8
gap> homalg_variable_5474 := SI_matrix(homalg_variable_5,6,8,"0");;
gap> homalg_variable_5472 = homalg_variable_5474;
false
gap> homalg_variable_5475 := SIH_DecideZeroColumns(homalg_variable_5351,homalg_variable_5472);;
gap> homalg_variable_5476 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_5475 = homalg_variable_5476;
true
gap> homalg_variable_5478 := homalg_variable_5374 * homalg_variable_3037;;
gap> homalg_variable_5477 := SIH_DecideZeroColumns(homalg_variable_5478,homalg_variable_5472);;
gap> homalg_variable_5479 := SI_matrix(homalg_variable_5,6,2,"0");;
gap> homalg_variable_5477 = homalg_variable_5479;
true
gap> homalg_variable_5480 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_5374,homalg_variable_5473);;
gap> SI_ncols(homalg_variable_5480);
2
gap> homalg_variable_5481 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5480 = homalg_variable_5481;
false
gap> homalg_variable_5482 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5480);;
gap> SI_ncols(homalg_variable_5482);
1
gap> homalg_variable_5483 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_5482 = homalg_variable_5483;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_5482,[ 0 ]);
[  ]
gap> homalg_variable_5484 := SIH_BasisOfColumnModule(homalg_variable_5480);;
gap> SI_ncols(homalg_variable_5484);
2
gap> homalg_variable_5485 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5484 = homalg_variable_5485;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5480);; homalg_variable_5486 := homalg_variable_l[1];; homalg_variable_5487 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5486);
2
gap> homalg_variable_5488 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5486 = homalg_variable_5488;
false
gap> SI_nrows(homalg_variable_5487);
2
gap> homalg_variable_5489 := homalg_variable_5480 * homalg_variable_5487;;
gap> homalg_variable_5486 = homalg_variable_5489;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5484,homalg_variable_5486);; homalg_variable_5490 := homalg_variable_l[1];; homalg_variable_5491 := homalg_variable_l[2];;
gap> homalg_variable_5492 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5490 = homalg_variable_5492;
true
gap> homalg_variable_5493 := homalg_variable_5486 * homalg_variable_5491;;
gap> homalg_variable_5494 := homalg_variable_5484 + homalg_variable_5493;;
gap> homalg_variable_5490 = homalg_variable_5494;
true
gap> homalg_variable_5495 := SIH_DecideZeroColumns(homalg_variable_5484,homalg_variable_5486);;
gap> homalg_variable_5496 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5495 = homalg_variable_5496;
true
gap> homalg_variable_5497 := homalg_variable_5491 * (homalg_variable_8);;
gap> homalg_variable_5498 := homalg_variable_5487 * homalg_variable_5497;;
gap> homalg_variable_5499 := homalg_variable_5480 * homalg_variable_5498;;
gap> homalg_variable_5499 = homalg_variable_5484;
true
gap> for _del in [ "homalg_variable_5011", "homalg_variable_5012", "homalg_variable_5015", "homalg_variable_5016", "homalg_variable_5017", "homalg_variable_5022", "homalg_variable_5025", "homalg_variable_5026", "homalg_variable_5027", "homalg_variable_5028", "homalg_variable_5029", "homalg_variable_5030", "homalg_variable_5031", "homalg_variable_5032", "homalg_variable_5033", "homalg_variable_5034", "homalg_variable_5035", "homalg_variable_5036", "homalg_variable_5045", "homalg_variable_5048", "homalg_variable_5049", "homalg_variable_5050", "homalg_variable_5051", "homalg_variable_5052", "homalg_variable_5055", "homalg_variable_5058", "homalg_variable_5059", "homalg_variable_5062", "homalg_variable_5065", "homalg_variable_5066", "homalg_variable_5069", "homalg_variable_5071", "homalg_variable_5072", "homalg_variable_5074", "homalg_variable_5075", "homalg_variable_5076", "homalg_variable_5078", "homalg_variable_5079", "homalg_variable_5082", "homalg_variable_5083", "homalg_variable_5084", "homalg_variable_5085", "homalg_variable_5086", "homalg_variable_5087", "homalg_variable_5089", "homalg_variable_5090", "homalg_variable_5091", "homalg_variable_5092", "homalg_variable_5093", "homalg_variable_5097", "homalg_variable_5098", "homalg_variable_5102", "homalg_variable_5103", "homalg_variable_5109", "homalg_variable_5112", "homalg_variable_5115", "homalg_variable_5139", "homalg_variable_5140", "homalg_variable_5144", "homalg_variable_5145", "homalg_variable_5146", "homalg_variable_5147", "homalg_variable_5150", "homalg_variable_5153", "homalg_variable_5154", "homalg_variable_5157", "homalg_variable_5158", "homalg_variable_5159", "homalg_variable_5164", "homalg_variable_5178", "homalg_variable_5179", "homalg_variable_5182", "homalg_variable_5183", "homalg_variable_5184", "homalg_variable_5185", "homalg_variable_5186", "homalg_variable_5192", "homalg_variable_5193", "homalg_variable_5194", "homalg_variable_5195", "homalg_variable_5196", "homalg_variable_5197", "homalg_variable_5198", "homalg_variable_5199", "homalg_variable_5200", "homalg_variable_5201", "homalg_variable_5202", "homalg_variable_5203", "homalg_variable_5205", "homalg_variable_5209", "homalg_variable_5210", "homalg_variable_5212", "homalg_variable_5213", "homalg_variable_5214", "homalg_variable_5215", "homalg_variable_5216", "homalg_variable_5217", "homalg_variable_5218", "homalg_variable_5219", "homalg_variable_5220", "homalg_variable_5221", "homalg_variable_5223", "homalg_variable_5224", "homalg_variable_5225", "homalg_variable_5226", "homalg_variable_5227", "homalg_variable_5232", "homalg_variable_5234", "homalg_variable_5235", "homalg_variable_5236", "homalg_variable_5237", "homalg_variable_5238", "homalg_variable_5239", "homalg_variable_5241", "homalg_variable_5242", "homalg_variable_5245", "homalg_variable_5247", "homalg_variable_5248", "homalg_variable_5249", "homalg_variable_5251", "homalg_variable_5252", "homalg_variable_5253", "homalg_variable_5255", "homalg_variable_5260", "homalg_variable_5261", "homalg_variable_5262", "homalg_variable_5265", "homalg_variable_5267", "homalg_variable_5272", "homalg_variable_5273", "homalg_variable_5274", "homalg_variable_5275", "homalg_variable_5276", "homalg_variable_5278", "homalg_variable_5279", "homalg_variable_5282", "homalg_variable_5283", "homalg_variable_5284", "homalg_variable_5285", "homalg_variable_5286", "homalg_variable_5287", "homalg_variable_5289", "homalg_variable_5291", "homalg_variable_5292", "homalg_variable_5293", "homalg_variable_5294", "homalg_variable_5296", "homalg_variable_5298", "homalg_variable_5301", "homalg_variable_5302", "homalg_variable_5304", "homalg_variable_5307", "homalg_variable_5308", "homalg_variable_5309", "homalg_variable_5310", "homalg_variable_5311", "homalg_variable_5312", "homalg_variable_5313", "homalg_variable_5314", "homalg_variable_5315", "homalg_variable_5316", "homalg_variable_5317", "homalg_variable_5318", "homalg_variable_5321", "homalg_variable_5322", "homalg_variable_5323", "homalg_variable_5324", "homalg_variable_5325", "homalg_variable_5327", "homalg_variable_5329", "homalg_variable_5335", "homalg_variable_5343", "homalg_variable_5344", "homalg_variable_5345", "homalg_variable_5346", "homalg_variable_5347", "homalg_variable_5348", "homalg_variable_5352", "homalg_variable_5353", "homalg_variable_5354", "homalg_variable_5358", "homalg_variable_5359", "homalg_variable_5360", "homalg_variable_5361", "homalg_variable_5362", "homalg_variable_5363", "homalg_variable_5366", "homalg_variable_5367", "homalg_variable_5368", "homalg_variable_5369", "homalg_variable_5370", "homalg_variable_5381", "homalg_variable_5382", "homalg_variable_5383", "homalg_variable_5384", "homalg_variable_5385", "homalg_variable_5386", "homalg_variable_5389", "homalg_variable_5390", "homalg_variable_5391", "homalg_variable_5394", "homalg_variable_5398", "homalg_variable_5399", "homalg_variable_5400", "homalg_variable_5404", "homalg_variable_5406", "homalg_variable_5409", "homalg_variable_5410", "homalg_variable_5412", "homalg_variable_5415", "homalg_variable_5416", "homalg_variable_5419", "homalg_variable_5420", "homalg_variable_5421", "homalg_variable_5426", "homalg_variable_5429", "homalg_variable_5430", "homalg_variable_5431", "homalg_variable_5432", "homalg_variable_5433", "homalg_variable_5437", "homalg_variable_5438", "homalg_variable_5439", "homalg_variable_5440", "homalg_variable_5442", "homalg_variable_5444", "homalg_variable_5449", "homalg_variable_5450", "homalg_variable_5453", "homalg_variable_5454", "homalg_variable_5455", "homalg_variable_5457", "homalg_variable_5460", "homalg_variable_5463", "homalg_variable_5464", "homalg_variable_5465", "homalg_variable_5466", "homalg_variable_5467", "homalg_variable_5470", "homalg_variable_5471", "homalg_variable_5474", "homalg_variable_5475", "homalg_variable_5476", "homalg_variable_5479", "homalg_variable_5481", "homalg_variable_5483", "homalg_variable_5485", "homalg_variable_5489", "homalg_variable_5492", "homalg_variable_5493", "homalg_variable_5494", "homalg_variable_5495", "homalg_variable_5496", "homalg_variable_5499" ] do UnbindGlobal( _del ); od;;
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5480,homalg_variable_5484);; homalg_variable_5500 := homalg_variable_l[1];; homalg_variable_5501 := homalg_variable_l[2];;
gap> homalg_variable_5502 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5500 = homalg_variable_5502;
true
gap> homalg_variable_5503 := homalg_variable_5484 * homalg_variable_5501;;
gap> homalg_variable_5504 := homalg_variable_5480 + homalg_variable_5503;;
gap> homalg_variable_5500 = homalg_variable_5504;
true
gap> homalg_variable_5505 := SIH_DecideZeroColumns(homalg_variable_5480,homalg_variable_5484);;
gap> homalg_variable_5506 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5505 = homalg_variable_5506;
true
gap> homalg_variable_5507 := homalg_variable_5501 * (homalg_variable_8);;
gap> homalg_variable_5508 := homalg_variable_5484 * homalg_variable_5507;;
gap> homalg_variable_5508 = homalg_variable_5480;
true
gap> homalg_variable_5509 := SIH_DecideZeroColumns(homalg_variable_5480,homalg_variable_3037);;
gap> homalg_variable_5510 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5509 = homalg_variable_5510;
true
gap> homalg_variable_5511 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_5288,homalg_variable_4849);;
gap> SI_ncols(homalg_variable_5511);
8
gap> homalg_variable_5512 := SI_matrix(homalg_variable_5,6,8,"0");;
gap> homalg_variable_5511 = homalg_variable_5512;
false
gap> homalg_variable_5513 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5511);;
gap> SI_ncols(homalg_variable_5513);
2
gap> homalg_variable_5514 := SI_matrix(homalg_variable_5,8,2,"0");;
gap> homalg_variable_5513 = homalg_variable_5514;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_5513,[ 0 ]);
[ [ 2, 3 ] ]
gap> homalg_variable_5516 := SIH_Submatrix(homalg_variable_5511,[1..6],[ 1, 2, 4, 5, 6, 7, 8 ]);;
gap> homalg_variable_5515 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5516);;
gap> SI_ncols(homalg_variable_5515);
1
gap> homalg_variable_5517 := SI_matrix(homalg_variable_5,7,1,"0");;
gap> homalg_variable_5515 = homalg_variable_5517;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_5515,[ 0 ]);
[  ]
gap> homalg_variable_5518 := SI_matrix(homalg_variable_5,6,7,"0");;
gap> homalg_variable_5516 = homalg_variable_5518;
false
gap> homalg_variable_5519 := SIH_BasisOfColumnModule(homalg_variable_5511);;
gap> SI_ncols(homalg_variable_5519);
8
gap> homalg_variable_5520 := SI_matrix(homalg_variable_5,6,8,"0");;
gap> homalg_variable_5519 = homalg_variable_5520;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5516);; homalg_variable_5521 := homalg_variable_l[1];; homalg_variable_5522 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5521);
8
gap> homalg_variable_5523 := SI_matrix(homalg_variable_5,6,8,"0");;
gap> homalg_variable_5521 = homalg_variable_5523;
false
gap> SI_nrows(homalg_variable_5522);
7
gap> homalg_variable_5524 := homalg_variable_5516 * homalg_variable_5522;;
gap> homalg_variable_5521 = homalg_variable_5524;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5519,homalg_variable_5521);; homalg_variable_5525 := homalg_variable_l[1];; homalg_variable_5526 := homalg_variable_l[2];;
gap> homalg_variable_5527 := SI_matrix(homalg_variable_5,6,8,"0");;
gap> homalg_variable_5525 = homalg_variable_5527;
true
gap> homalg_variable_5528 := homalg_variable_5521 * homalg_variable_5526;;
gap> homalg_variable_5529 := homalg_variable_5519 + homalg_variable_5528;;
gap> homalg_variable_5525 = homalg_variable_5529;
true
gap> homalg_variable_5530 := SIH_DecideZeroColumns(homalg_variable_5519,homalg_variable_5521);;
gap> homalg_variable_5531 := SI_matrix(homalg_variable_5,6,8,"0");;
gap> homalg_variable_5530 = homalg_variable_5531;
true
gap> homalg_variable_5532 := homalg_variable_5526 * (homalg_variable_8);;
gap> homalg_variable_5533 := homalg_variable_5522 * homalg_variable_5532;;
gap> homalg_variable_5534 := homalg_variable_5516 * homalg_variable_5533;;
gap> homalg_variable_5534 = homalg_variable_5519;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5516,homalg_variable_5519);; homalg_variable_5535 := homalg_variable_l[1];; homalg_variable_5536 := homalg_variable_l[2];;
gap> homalg_variable_5537 := SI_matrix(homalg_variable_5,6,7,"0");;
gap> homalg_variable_5535 = homalg_variable_5537;
true
gap> homalg_variable_5538 := homalg_variable_5519 * homalg_variable_5536;;
gap> homalg_variable_5539 := homalg_variable_5516 + homalg_variable_5538;;
gap> homalg_variable_5535 = homalg_variable_5539;
true
gap> homalg_variable_5540 := SIH_DecideZeroColumns(homalg_variable_5516,homalg_variable_5519);;
gap> homalg_variable_5541 := SI_matrix(homalg_variable_5,6,7,"0");;
gap> homalg_variable_5540 = homalg_variable_5541;
true
gap> homalg_variable_5542 := homalg_variable_5536 * (homalg_variable_8);;
gap> homalg_variable_5543 := homalg_variable_5519 * homalg_variable_5542;;
gap> homalg_variable_5543 = homalg_variable_5516;
true
gap> homalg_variable_5545 := SIH_UnionOfColumns(homalg_variable_5351,homalg_variable_5374);;
gap> homalg_variable_5546 := SIH_UnionOfColumns(homalg_variable_5545,homalg_variable_5328);;
gap> homalg_variable_5544 := SIH_BasisOfColumnModule(homalg_variable_5546);;
gap> SI_ncols(homalg_variable_5544);
7
gap> homalg_variable_5547 := SI_matrix(homalg_variable_5,6,7,"0");;
gap> homalg_variable_5544 = homalg_variable_5547;
false
gap> homalg_variable_5548 := SIH_DecideZeroColumns(homalg_variable_5545,homalg_variable_5544);;
gap> homalg_variable_5549 := SI_matrix(homalg_variable_5,6,2,"0");;
gap> homalg_variable_5548 = homalg_variable_5549;
true
gap> homalg_variable_5551 := homalg_variable_5397 * homalg_variable_5056;;
gap> homalg_variable_5550 := SIH_DecideZeroColumns(homalg_variable_5551,homalg_variable_5544);;
gap> homalg_variable_5552 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_5550 = homalg_variable_5552;
true
gap> homalg_variable_5553 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_5397,homalg_variable_5546);;
gap> SI_ncols(homalg_variable_5553);
4
gap> homalg_variable_5554 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5553 = homalg_variable_5554;
false
gap> homalg_variable_5555 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5553);;
gap> SI_ncols(homalg_variable_5555);
1
gap> homalg_variable_5556 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_5555 = homalg_variable_5556;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_5555,[ 0 ]);
[  ]
gap> homalg_variable_5557 := SIH_BasisOfColumnModule(homalg_variable_5553);;
gap> SI_ncols(homalg_variable_5557);
4
gap> homalg_variable_5558 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5557 = homalg_variable_5558;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5553);; homalg_variable_5559 := homalg_variable_l[1];; homalg_variable_5560 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5559);
4
gap> homalg_variable_5561 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5559 = homalg_variable_5561;
false
gap> SI_nrows(homalg_variable_5560);
4
gap> homalg_variable_5562 := homalg_variable_5553 * homalg_variable_5560;;
gap> homalg_variable_5559 = homalg_variable_5562;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5557,homalg_variable_5559);; homalg_variable_5563 := homalg_variable_l[1];; homalg_variable_5564 := homalg_variable_l[2];;
gap> homalg_variable_5565 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5563 = homalg_variable_5565;
true
gap> homalg_variable_5566 := homalg_variable_5559 * homalg_variable_5564;;
gap> homalg_variable_5567 := homalg_variable_5557 + homalg_variable_5566;;
gap> homalg_variable_5563 = homalg_variable_5567;
true
gap> homalg_variable_5568 := SIH_DecideZeroColumns(homalg_variable_5557,homalg_variable_5559);;
gap> homalg_variable_5569 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5568 = homalg_variable_5569;
true
gap> homalg_variable_5570 := homalg_variable_5564 * (homalg_variable_8);;
gap> homalg_variable_5571 := homalg_variable_5560 * homalg_variable_5570;;
gap> homalg_variable_5572 := homalg_variable_5553 * homalg_variable_5571;;
gap> homalg_variable_5572 = homalg_variable_5557;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5553,homalg_variable_5557);; homalg_variable_5573 := homalg_variable_l[1];; homalg_variable_5574 := homalg_variable_l[2];;
gap> homalg_variable_5575 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5573 = homalg_variable_5575;
true
gap> homalg_variable_5576 := homalg_variable_5557 * homalg_variable_5574;;
gap> homalg_variable_5577 := homalg_variable_5553 + homalg_variable_5576;;
gap> homalg_variable_5573 = homalg_variable_5577;
true
gap> homalg_variable_5578 := SIH_DecideZeroColumns(homalg_variable_5553,homalg_variable_5557);;
gap> homalg_variable_5579 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5578 = homalg_variable_5579;
true
gap> homalg_variable_5580 := homalg_variable_5574 * (homalg_variable_8);;
gap> homalg_variable_5581 := homalg_variable_5557 * homalg_variable_5580;;
gap> homalg_variable_5581 = homalg_variable_5553;
true
gap> homalg_variable_5582 := SIH_DecideZeroColumns(homalg_variable_5553,homalg_variable_5056);;
gap> homalg_variable_5583 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5582 = homalg_variable_5583;
true
gap> homalg_variable_5585 := SIH_UnionOfColumns(homalg_variable_5397,homalg_variable_5546);;
gap> homalg_variable_5584 := SIH_BasisOfColumnModule(homalg_variable_5585);;
gap> SI_ncols(homalg_variable_5584);
6
gap> homalg_variable_5586 := SI_matrix(homalg_variable_5,6,6,"0");;
gap> homalg_variable_5584 = homalg_variable_5586;
false
gap> homalg_variable_5588 := SI_matrix(SI_freemodule(homalg_variable_5,6));;
gap> homalg_variable_5587 := SIH_DecideZeroColumns(homalg_variable_5588,homalg_variable_5584);;
gap> homalg_variable_5589 := SI_matrix(homalg_variable_5,6,6,"0");;
gap> homalg_variable_5587 = homalg_variable_5589;
true
gap> homalg_variable_5590 := SIH_DecideZeroColumns(homalg_variable_5397,homalg_variable_5544);;
gap> homalg_variable_5591 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_5590 = homalg_variable_5591;
false
gap> homalg_variable_5592 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_5397 = homalg_variable_5592;
false
gap> homalg_variable_5593 := SIH_UnionOfColumns(homalg_variable_5590,homalg_variable_5544);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5593);; homalg_variable_5594 := homalg_variable_l[1];; homalg_variable_5595 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5594);
6
gap> homalg_variable_5596 := SI_matrix(homalg_variable_5,6,6,"0");;
gap> homalg_variable_5594 = homalg_variable_5596;
false
gap> SI_nrows(homalg_variable_5595);
10
gap> homalg_variable_5597 := SIH_Submatrix(homalg_variable_5595,[ 1, 2, 3 ],[1..6]);;
gap> homalg_variable_5598 := homalg_variable_5590 * homalg_variable_5597;;
gap> homalg_variable_5599 := SIH_Submatrix(homalg_variable_5595,[ 4, 5, 6, 7, 8, 9, 10 ],[1..6]);;
gap> homalg_variable_5600 := homalg_variable_5544 * homalg_variable_5599;;
gap> homalg_variable_5601 := homalg_variable_5598 + homalg_variable_5600;;
gap> homalg_variable_5594 = homalg_variable_5601;
true
gap> homalg_variable_5603 := SI_matrix(SI_freemodule(homalg_variable_5,6));;
gap> homalg_variable_5602 := SIH_DecideZeroColumns(homalg_variable_5603,homalg_variable_5544);;
gap> homalg_variable_5604 := SI_matrix(homalg_variable_5,6,6,"0");;
gap> homalg_variable_5602 = homalg_variable_5604;
false
gap> homalg_variable_5594 = homalg_variable_5603;
true
gap> homalg_variable_5606 := SIH_Submatrix(homalg_variable_5595,[ 1, 2, 3 ],[1..6]);;
gap> homalg_variable_5607 := homalg_variable_5606 * homalg_variable_5602;;
gap> homalg_variable_5608 := homalg_variable_5397 * homalg_variable_5607;;
gap> homalg_variable_5609 := homalg_variable_5608 - homalg_variable_5603;;
gap> homalg_variable_5605 := SIH_DecideZeroColumns(homalg_variable_5609,homalg_variable_5544);;
gap> homalg_variable_5610 := SI_matrix(homalg_variable_5,6,6,"0");;
gap> homalg_variable_5605 = homalg_variable_5610;
true
gap> homalg_variable_5612 := homalg_variable_5607 * homalg_variable_5328;;
gap> homalg_variable_5611 := SIH_DecideZeroColumns(homalg_variable_5612,homalg_variable_5056);;
gap> homalg_variable_5613 := SI_matrix(homalg_variable_5,3,10,"0");;
gap> homalg_variable_5611 = homalg_variable_5613;
true
gap> homalg_variable_5614 := SIH_DecideZeroColumns(homalg_variable_5545,homalg_variable_5328);;
gap> homalg_variable_5615 := SI_matrix(homalg_variable_5,6,2,"0");;
gap> homalg_variable_5614 = homalg_variable_5615;
false
gap> homalg_variable_5616 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_5351 = homalg_variable_5616;
false
gap> SIH_ZeroColumns(homalg_variable_5614);
[  ]
gap> homalg_variable_5617 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_5614,homalg_variable_5328);;
gap> SI_ncols(homalg_variable_5617);
5
gap> homalg_variable_5618 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_5617 = homalg_variable_5618;
false
gap> homalg_variable_5620 := homalg_variable_5614 * homalg_variable_5617;;
gap> homalg_variable_5619 := SIH_DecideZeroColumns(homalg_variable_5620,homalg_variable_5328);;
gap> homalg_variable_5621 := SI_matrix(homalg_variable_5,6,5,"0");;
gap> homalg_variable_5619 = homalg_variable_5621;
true
gap> homalg_variable_5622 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_5614,homalg_variable_5328);;
gap> SI_ncols(homalg_variable_5622);
5
gap> homalg_variable_5623 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_5622 = homalg_variable_5623;
false
gap> homalg_variable_5624 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5622);;
gap> SI_ncols(homalg_variable_5624);
4
gap> homalg_variable_5625 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5624 = homalg_variable_5625;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_5624,[ 0 ]);
[  ]
gap> homalg_variable_5626 := SIH_BasisOfColumnModule(homalg_variable_5622);;
gap> SI_ncols(homalg_variable_5626);
5
gap> homalg_variable_5627 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_5626 = homalg_variable_5627;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5622);; homalg_variable_5628 := homalg_variable_l[1];; homalg_variable_5629 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5628);
5
gap> homalg_variable_5630 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_5628 = homalg_variable_5630;
false
gap> SI_nrows(homalg_variable_5629);
5
gap> homalg_variable_5631 := homalg_variable_5622 * homalg_variable_5629;;
gap> homalg_variable_5628 = homalg_variable_5631;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5626,homalg_variable_5628);; homalg_variable_5632 := homalg_variable_l[1];; homalg_variable_5633 := homalg_variable_l[2];;
gap> homalg_variable_5634 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_5632 = homalg_variable_5634;
true
gap> homalg_variable_5635 := homalg_variable_5628 * homalg_variable_5633;;
gap> homalg_variable_5636 := homalg_variable_5626 + homalg_variable_5635;;
gap> homalg_variable_5632 = homalg_variable_5636;
true
gap> homalg_variable_5637 := SIH_DecideZeroColumns(homalg_variable_5626,homalg_variable_5628);;
gap> homalg_variable_5638 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_5637 = homalg_variable_5638;
true
gap> homalg_variable_5639 := homalg_variable_5633 * (homalg_variable_8);;
gap> homalg_variable_5640 := homalg_variable_5629 * homalg_variable_5639;;
gap> homalg_variable_5641 := homalg_variable_5622 * homalg_variable_5640;;
gap> homalg_variable_5641 = homalg_variable_5626;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5622,homalg_variable_5626);; homalg_variable_5642 := homalg_variable_l[1];; homalg_variable_5643 := homalg_variable_l[2];;
gap> homalg_variable_5644 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_5642 = homalg_variable_5644;
true
gap> homalg_variable_5645 := homalg_variable_5626 * homalg_variable_5643;;
gap> homalg_variable_5646 := homalg_variable_5622 + homalg_variable_5645;;
gap> homalg_variable_5642 = homalg_variable_5646;
true
gap> homalg_variable_5647 := SIH_DecideZeroColumns(homalg_variable_5622,homalg_variable_5626);;
gap> homalg_variable_5648 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_5647 = homalg_variable_5648;
true
gap> homalg_variable_5649 := homalg_variable_5643 * (homalg_variable_8);;
gap> homalg_variable_5650 := homalg_variable_5626 * homalg_variable_5649;;
gap> homalg_variable_5650 = homalg_variable_5622;
true
gap> homalg_variable_5651 := SIH_BasisOfColumnModule(homalg_variable_5617);;
gap> SI_ncols(homalg_variable_5651);
5
gap> homalg_variable_5652 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_5651 = homalg_variable_5652;
false
gap> homalg_variable_5651 = homalg_variable_5617;
true
gap> homalg_variable_5653 := SIH_DecideZeroColumns(homalg_variable_5622,homalg_variable_5651);;
gap> homalg_variable_5654 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_5653 = homalg_variable_5654;
true
gap> homalg_variable_5655 := SIH_UnionOfColumns(homalg_variable_5614,homalg_variable_5328);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5655);; homalg_variable_5656 := homalg_variable_l[1];; homalg_variable_5657 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5656);
7
gap> homalg_variable_5658 := SI_matrix(homalg_variable_5,6,7,"0");;
gap> homalg_variable_5656 = homalg_variable_5658;
false
gap> SI_nrows(homalg_variable_5657);
12
gap> homalg_variable_5659 := SIH_Submatrix(homalg_variable_5657,[ 1, 2 ],[1..7]);;
gap> homalg_variable_5660 := homalg_variable_5614 * homalg_variable_5659;;
gap> homalg_variable_5661 := SIH_Submatrix(homalg_variable_5657,[ 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ],[1..7]);;
gap> homalg_variable_5662 := homalg_variable_5328 * homalg_variable_5661;;
gap> homalg_variable_5663 := homalg_variable_5660 + homalg_variable_5662;;
gap> homalg_variable_5656 = homalg_variable_5663;
true
gap> homalg_variable_5664 := SIH_DecideZeroColumns(homalg_variable_5351,homalg_variable_5328);;
gap> homalg_variable_5665 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_5664 = homalg_variable_5665;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5664,homalg_variable_5656);; homalg_variable_5666 := homalg_variable_l[1];; homalg_variable_5667 := homalg_variable_l[2];;
gap> homalg_variable_5668 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_5666 = homalg_variable_5668;
true
gap> homalg_variable_5669 := homalg_variable_5656 * homalg_variable_5667;;
gap> homalg_variable_5670 := homalg_variable_5664 + homalg_variable_5669;;
gap> homalg_variable_5666 = homalg_variable_5670;
true
gap> homalg_variable_5671 := SIH_DecideZeroColumns(homalg_variable_5664,homalg_variable_5656);;
gap> homalg_variable_5672 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_5671 = homalg_variable_5672;
true
gap> homalg_variable_5674 := SIH_Submatrix(homalg_variable_5657,[ 1, 2 ],[1..7]);;
gap> homalg_variable_5675 := homalg_variable_5667 * (homalg_variable_8);;
gap> homalg_variable_5676 := homalg_variable_5674 * homalg_variable_5675;;
gap> homalg_variable_5677 := homalg_variable_5614 * homalg_variable_5676;;
gap> homalg_variable_5678 := homalg_variable_5677 - homalg_variable_5351;;
gap> homalg_variable_5673 := SIH_DecideZeroColumns(homalg_variable_5678,homalg_variable_5328);;
gap> homalg_variable_5679 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_5673 = homalg_variable_5679;
true
gap> homalg_variable_5680 := SIH_UnionOfColumns(homalg_variable_5614,homalg_variable_5328);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5680);; homalg_variable_5681 := homalg_variable_l[1];; homalg_variable_5682 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5681);
7
gap> homalg_variable_5683 := SI_matrix(homalg_variable_5,6,7,"0");;
gap> homalg_variable_5681 = homalg_variable_5683;
false
gap> SI_nrows(homalg_variable_5682);
12
gap> homalg_variable_5684 := SIH_Submatrix(homalg_variable_5682,[ 1, 2 ],[1..7]);;
gap> homalg_variable_5685 := homalg_variable_5614 * homalg_variable_5684;;
gap> homalg_variable_5686 := SIH_Submatrix(homalg_variable_5682,[ 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ],[1..7]);;
gap> homalg_variable_5687 := homalg_variable_5328 * homalg_variable_5686;;
gap> homalg_variable_5688 := homalg_variable_5685 + homalg_variable_5687;;
gap> homalg_variable_5681 = homalg_variable_5688;
true
gap> homalg_variable_5689 := SIH_DecideZeroColumns(homalg_variable_5374,homalg_variable_5328);;
gap> homalg_variable_5690 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_5689 = homalg_variable_5690;
false
gap> homalg_variable_5691 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_5374 = homalg_variable_5691;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5689,homalg_variable_5681);; homalg_variable_5692 := homalg_variable_l[1];; homalg_variable_5693 := homalg_variable_l[2];;
gap> homalg_variable_5694 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_5692 = homalg_variable_5694;
true
gap> homalg_variable_5695 := homalg_variable_5681 * homalg_variable_5693;;
gap> homalg_variable_5696 := homalg_variable_5689 + homalg_variable_5695;;
gap> homalg_variable_5692 = homalg_variable_5696;
true
gap> homalg_variable_5697 := SIH_DecideZeroColumns(homalg_variable_5689,homalg_variable_5681);;
gap> homalg_variable_5698 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_5697 = homalg_variable_5698;
true
gap> homalg_variable_5700 := SIH_Submatrix(homalg_variable_5682,[ 1, 2 ],[1..7]);;
gap> homalg_variable_5701 := homalg_variable_5693 * (homalg_variable_8);;
gap> homalg_variable_5702 := homalg_variable_5700 * homalg_variable_5701;;
gap> homalg_variable_5703 := homalg_variable_5614 * homalg_variable_5702;;
gap> homalg_variable_5704 := homalg_variable_5703 - homalg_variable_5374;;
gap> homalg_variable_5699 := SIH_DecideZeroColumns(homalg_variable_5704,homalg_variable_5328);;
gap> homalg_variable_5705 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_5699 = homalg_variable_5705;
true
gap> homalg_variable_5707 := SIH_UnionOfColumns(homalg_variable_5436,homalg_variable_5328);;
gap> homalg_variable_5706 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_5614,homalg_variable_5707);;
gap> SI_ncols(homalg_variable_5706);
5
gap> homalg_variable_5708 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_5706 = homalg_variable_5708;
false
gap> homalg_variable_5709 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5706);;
gap> SI_ncols(homalg_variable_5709);
4
gap> homalg_variable_5710 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5709 = homalg_variable_5710;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_5709,[ 0 ]);
[  ]
gap> homalg_variable_5711 := SIH_BasisOfColumnModule(homalg_variable_5706);;
gap> SI_ncols(homalg_variable_5711);
5
gap> homalg_variable_5712 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_5711 = homalg_variable_5712;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5706);; homalg_variable_5713 := homalg_variable_l[1];; homalg_variable_5714 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5713);
5
gap> homalg_variable_5715 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_5713 = homalg_variable_5715;
false
gap> SI_nrows(homalg_variable_5714);
5
gap> homalg_variable_5716 := homalg_variable_5706 * homalg_variable_5714;;
gap> homalg_variable_5713 = homalg_variable_5716;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5711,homalg_variable_5713);; homalg_variable_5717 := homalg_variable_l[1];; homalg_variable_5718 := homalg_variable_l[2];;
gap> homalg_variable_5719 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_5717 = homalg_variable_5719;
true
gap> homalg_variable_5720 := homalg_variable_5713 * homalg_variable_5718;;
gap> homalg_variable_5721 := homalg_variable_5711 + homalg_variable_5720;;
gap> homalg_variable_5717 = homalg_variable_5721;
true
gap> homalg_variable_5722 := SIH_DecideZeroColumns(homalg_variable_5711,homalg_variable_5713);;
gap> homalg_variable_5723 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_5722 = homalg_variable_5723;
true
gap> homalg_variable_5724 := homalg_variable_5718 * (homalg_variable_8);;
gap> homalg_variable_5725 := homalg_variable_5714 * homalg_variable_5724;;
gap> homalg_variable_5726 := homalg_variable_5706 * homalg_variable_5725;;
gap> homalg_variable_5726 = homalg_variable_5711;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5706,homalg_variable_5711);; homalg_variable_5727 := homalg_variable_l[1];; homalg_variable_5728 := homalg_variable_l[2];;
gap> homalg_variable_5729 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_5727 = homalg_variable_5729;
true
gap> homalg_variable_5730 := homalg_variable_5711 * homalg_variable_5728;;
gap> homalg_variable_5731 := homalg_variable_5706 + homalg_variable_5730;;
gap> homalg_variable_5727 = homalg_variable_5731;
true
gap> homalg_variable_5732 := SIH_DecideZeroColumns(homalg_variable_5706,homalg_variable_5711);;
gap> homalg_variable_5733 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_5732 = homalg_variable_5733;
true
gap> homalg_variable_5734 := homalg_variable_5728 * (homalg_variable_8);;
gap> homalg_variable_5735 := homalg_variable_5711 * homalg_variable_5734;;
gap> homalg_variable_5735 = homalg_variable_5706;
true
gap> homalg_variable_5736 := SIH_DecideZeroColumns(homalg_variable_5706,homalg_variable_5651);;
gap> homalg_variable_5737 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_5736 = homalg_variable_5737;
true
gap> homalg_variable_5739 := homalg_variable_5676 * homalg_variable_2959;;
gap> homalg_variable_5738 := SIH_DecideZeroColumns(homalg_variable_5739,homalg_variable_5651);;
gap> homalg_variable_5740 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_5738 = homalg_variable_5740;
true
gap> homalg_variable_5741 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_5676,homalg_variable_5651);;
gap> SI_ncols(homalg_variable_5741);
3
gap> homalg_variable_5742 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5741 = homalg_variable_5742;
false
gap> homalg_variable_5743 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5741);;
gap> SI_ncols(homalg_variable_5743);
3
gap> homalg_variable_5744 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_5743 = homalg_variable_5744;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_5743,[ 0 ]);
[  ]
gap> homalg_variable_5745 := SIH_BasisOfColumnModule(homalg_variable_5741);;
gap> SI_ncols(homalg_variable_5745);
3
gap> homalg_variable_5746 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5745 = homalg_variable_5746;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5741);; homalg_variable_5747 := homalg_variable_l[1];; homalg_variable_5748 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5747);
3
gap> homalg_variable_5749 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5747 = homalg_variable_5749;
false
gap> SI_nrows(homalg_variable_5748);
3
gap> homalg_variable_5750 := homalg_variable_5741 * homalg_variable_5748;;
gap> homalg_variable_5747 = homalg_variable_5750;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5745,homalg_variable_5747);; homalg_variable_5751 := homalg_variable_l[1];; homalg_variable_5752 := homalg_variable_l[2];;
gap> homalg_variable_5753 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5751 = homalg_variable_5753;
true
gap> homalg_variable_5754 := homalg_variable_5747 * homalg_variable_5752;;
gap> homalg_variable_5755 := homalg_variable_5745 + homalg_variable_5754;;
gap> homalg_variable_5751 = homalg_variable_5755;
true
gap> homalg_variable_5756 := SIH_DecideZeroColumns(homalg_variable_5745,homalg_variable_5747);;
gap> homalg_variable_5757 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5756 = homalg_variable_5757;
true
gap> homalg_variable_5758 := homalg_variable_5752 * (homalg_variable_8);;
gap> homalg_variable_5759 := homalg_variable_5748 * homalg_variable_5758;;
gap> homalg_variable_5760 := homalg_variable_5741 * homalg_variable_5759;;
gap> homalg_variable_5760 = homalg_variable_5745;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5741,homalg_variable_5745);; homalg_variable_5761 := homalg_variable_l[1];; homalg_variable_5762 := homalg_variable_l[2];;
gap> homalg_variable_5763 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5761 = homalg_variable_5763;
true
gap> homalg_variable_5764 := homalg_variable_5745 * homalg_variable_5762;;
gap> homalg_variable_5765 := homalg_variable_5741 + homalg_variable_5764;;
gap> homalg_variable_5761 = homalg_variable_5765;
true
gap> homalg_variable_5766 := SIH_DecideZeroColumns(homalg_variable_5741,homalg_variable_5745);;
gap> homalg_variable_5767 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5766 = homalg_variable_5767;
true
gap> homalg_variable_5768 := homalg_variable_5762 * (homalg_variable_8);;
gap> homalg_variable_5769 := homalg_variable_5745 * homalg_variable_5768;;
gap> homalg_variable_5769 = homalg_variable_5741;
true
gap> homalg_variable_5770 := SIH_DecideZeroColumns(homalg_variable_5741,homalg_variable_2959);;
gap> homalg_variable_5771 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5770 = homalg_variable_5771;
true
gap> homalg_variable_5773 := SIH_UnionOfColumns(homalg_variable_5676,homalg_variable_5651);;
gap> homalg_variable_5772 := SIH_BasisOfColumnModule(homalg_variable_5773);;
gap> SI_ncols(homalg_variable_5772);
3
gap> homalg_variable_5774 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_5772 = homalg_variable_5774;
false
gap> homalg_variable_5775 := SIH_DecideZeroColumns(homalg_variable_5676,homalg_variable_5772);;
gap> homalg_variable_5776 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_5775 = homalg_variable_5776;
true
gap> homalg_variable_5778 := homalg_variable_5702 * homalg_variable_3037;;
gap> homalg_variable_5777 := SIH_DecideZeroColumns(homalg_variable_5778,homalg_variable_5772);;
gap> homalg_variable_5779 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_5777 = homalg_variable_5779;
true
gap> homalg_variable_5780 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_5702,homalg_variable_5773);;
gap> SI_ncols(homalg_variable_5780);
2
gap> homalg_variable_5781 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5780 = homalg_variable_5781;
false
gap> homalg_variable_5782 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5780);;
gap> SI_ncols(homalg_variable_5782);
1
gap> homalg_variable_5783 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_5782 = homalg_variable_5783;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_5782,[ 0 ]);
[  ]
gap> homalg_variable_5784 := SIH_BasisOfColumnModule(homalg_variable_5780);;
gap> SI_ncols(homalg_variable_5784);
2
gap> homalg_variable_5785 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5784 = homalg_variable_5785;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5780);; homalg_variable_5786 := homalg_variable_l[1];; homalg_variable_5787 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5786);
2
gap> homalg_variable_5788 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5786 = homalg_variable_5788;
false
gap> SI_nrows(homalg_variable_5787);
2
gap> homalg_variable_5789 := homalg_variable_5780 * homalg_variable_5787;;
gap> homalg_variable_5786 = homalg_variable_5789;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5784,homalg_variable_5786);; homalg_variable_5790 := homalg_variable_l[1];; homalg_variable_5791 := homalg_variable_l[2];;
gap> homalg_variable_5792 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5790 = homalg_variable_5792;
true
gap> homalg_variable_5793 := homalg_variable_5786 * homalg_variable_5791;;
gap> homalg_variable_5794 := homalg_variable_5784 + homalg_variable_5793;;
gap> homalg_variable_5790 = homalg_variable_5794;
true
gap> homalg_variable_5795 := SIH_DecideZeroColumns(homalg_variable_5784,homalg_variable_5786);;
gap> homalg_variable_5796 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5795 = homalg_variable_5796;
true
gap> homalg_variable_5797 := homalg_variable_5791 * (homalg_variable_8);;
gap> homalg_variable_5798 := homalg_variable_5787 * homalg_variable_5797;;
gap> homalg_variable_5799 := homalg_variable_5780 * homalg_variable_5798;;
gap> homalg_variable_5799 = homalg_variable_5784;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5780,homalg_variable_5784);; homalg_variable_5800 := homalg_variable_l[1];; homalg_variable_5801 := homalg_variable_l[2];;
gap> homalg_variable_5802 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5800 = homalg_variable_5802;
true
gap> homalg_variable_5803 := homalg_variable_5784 * homalg_variable_5801;;
gap> homalg_variable_5804 := homalg_variable_5780 + homalg_variable_5803;;
gap> homalg_variable_5800 = homalg_variable_5804;
true
gap> homalg_variable_5805 := SIH_DecideZeroColumns(homalg_variable_5780,homalg_variable_5784);;
gap> homalg_variable_5806 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5805 = homalg_variable_5806;
true
gap> homalg_variable_5807 := homalg_variable_5801 * (homalg_variable_8);;
gap> homalg_variable_5808 := homalg_variable_5784 * homalg_variable_5807;;
gap> homalg_variable_5808 = homalg_variable_5780;
true
gap> homalg_variable_5809 := SIH_DecideZeroColumns(homalg_variable_5780,homalg_variable_3037);;
gap> homalg_variable_5810 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5809 = homalg_variable_5810;
true
gap> homalg_variable_5812 := SIH_UnionOfColumns(homalg_variable_5702,homalg_variable_5773);;
gap> homalg_variable_5811 := SIH_BasisOfColumnModule(homalg_variable_5812);;
gap> SI_ncols(homalg_variable_5811);
2
gap> homalg_variable_5813 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_5811 = homalg_variable_5813;
false
gap> homalg_variable_5814 := SIH_DecideZeroColumns(homalg_variable_618,homalg_variable_5811);;
gap> homalg_variable_5815 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_5814 = homalg_variable_5815;
true
gap> homalg_variable_5816 := SIH_DecideZeroColumns(homalg_variable_5702,homalg_variable_5772);;
gap> homalg_variable_5817 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_5816 = homalg_variable_5817;
false
gap> homalg_variable_5818 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_5702 = homalg_variable_5818;
false
gap> homalg_variable_5819 := SIH_UnionOfColumns(homalg_variable_5816,homalg_variable_5772);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5819);; homalg_variable_5820 := homalg_variable_l[1];; homalg_variable_5821 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5820);
2
gap> homalg_variable_5822 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_5820 = homalg_variable_5822;
false
gap> SI_nrows(homalg_variable_5821);
4
gap> homalg_variable_5823 := SIH_Submatrix(homalg_variable_5821,[ 1 ],[1..2]);;
gap> homalg_variable_5824 := homalg_variable_5816 * homalg_variable_5823;;
gap> homalg_variable_5825 := SIH_Submatrix(homalg_variable_5821,[ 2, 3, 4 ],[1..2]);;
gap> homalg_variable_5826 := homalg_variable_5772 * homalg_variable_5825;;
gap> homalg_variable_5827 := homalg_variable_5824 + homalg_variable_5826;;
gap> homalg_variable_5820 = homalg_variable_5827;
true
gap> homalg_variable_5828 := SIH_DecideZeroColumns(homalg_variable_618,homalg_variable_5772);;
gap> homalg_variable_5829 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_5828 = homalg_variable_5829;
false
gap> homalg_variable_5820 = homalg_variable_618;
true
gap> homalg_variable_5831 := SIH_Submatrix(homalg_variable_5821,[ 1 ],[1..2]);;
gap> homalg_variable_5832 := homalg_variable_5831 * homalg_variable_5828;;
gap> homalg_variable_5833 := homalg_variable_5702 * homalg_variable_5832;;
gap> homalg_variable_5834 := homalg_variable_5833 - homalg_variable_618;;
gap> homalg_variable_5830 := SIH_DecideZeroColumns(homalg_variable_5834,homalg_variable_5772);;
gap> homalg_variable_5835 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_5830 = homalg_variable_5835;
true
gap> homalg_variable_5837 := homalg_variable_5832 * homalg_variable_5651;;
gap> homalg_variable_5836 := SIH_DecideZeroColumns(homalg_variable_5837,homalg_variable_3037);;
gap> homalg_variable_5838 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_5836 = homalg_variable_5838;
true
gap> homalg_variable_5839 := SIH_DecideZeroColumns(homalg_variable_5676,homalg_variable_5651);;
gap> homalg_variable_5840 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_5839 = homalg_variable_5840;
false
gap> homalg_variable_5841 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_5676 = homalg_variable_5841;
false
gap> homalg_variable_5842 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_5839,homalg_variable_5651);;
gap> SI_ncols(homalg_variable_5842);
3
gap> homalg_variable_5843 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5842 = homalg_variable_5843;
false
gap> homalg_variable_5845 := homalg_variable_5839 * homalg_variable_5842;;
gap> homalg_variable_5844 := SIH_DecideZeroColumns(homalg_variable_5845,homalg_variable_5651);;
gap> homalg_variable_5846 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_5844 = homalg_variable_5846;
true
gap> homalg_variable_5847 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_5839,homalg_variable_5651);;
gap> SI_ncols(homalg_variable_5847);
3
gap> homalg_variable_5848 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5847 = homalg_variable_5848;
false
gap> homalg_variable_5849 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5847);;
gap> SI_ncols(homalg_variable_5849);
3
gap> homalg_variable_5850 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_5849 = homalg_variable_5850;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_5849,[ 0 ]);
[  ]
gap> homalg_variable_5851 := SIH_BasisOfColumnModule(homalg_variable_5847);;
gap> SI_ncols(homalg_variable_5851);
3
gap> homalg_variable_5852 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5851 = homalg_variable_5852;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5847);; homalg_variable_5853 := homalg_variable_l[1];; homalg_variable_5854 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5853);
3
gap> homalg_variable_5855 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5853 = homalg_variable_5855;
false
gap> SI_nrows(homalg_variable_5854);
3
gap> homalg_variable_5856 := homalg_variable_5847 * homalg_variable_5854;;
gap> homalg_variable_5853 = homalg_variable_5856;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5851,homalg_variable_5853);; homalg_variable_5857 := homalg_variable_l[1];; homalg_variable_5858 := homalg_variable_l[2];;
gap> homalg_variable_5859 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5857 = homalg_variable_5859;
true
gap> homalg_variable_5860 := homalg_variable_5853 * homalg_variable_5858;;
gap> homalg_variable_5861 := homalg_variable_5851 + homalg_variable_5860;;
gap> homalg_variable_5857 = homalg_variable_5861;
true
gap> homalg_variable_5862 := SIH_DecideZeroColumns(homalg_variable_5851,homalg_variable_5853);;
gap> homalg_variable_5863 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5862 = homalg_variable_5863;
true
gap> homalg_variable_5864 := homalg_variable_5858 * (homalg_variable_8);;
gap> homalg_variable_5865 := homalg_variable_5854 * homalg_variable_5864;;
gap> homalg_variable_5866 := homalg_variable_5847 * homalg_variable_5865;;
gap> homalg_variable_5866 = homalg_variable_5851;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5847,homalg_variable_5851);; homalg_variable_5867 := homalg_variable_l[1];; homalg_variable_5868 := homalg_variable_l[2];;
gap> homalg_variable_5869 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5867 = homalg_variable_5869;
true
gap> homalg_variable_5870 := homalg_variable_5851 * homalg_variable_5868;;
gap> homalg_variable_5871 := homalg_variable_5847 + homalg_variable_5870;;
gap> homalg_variable_5867 = homalg_variable_5871;
true
gap> homalg_variable_5872 := SIH_DecideZeroColumns(homalg_variable_5847,homalg_variable_5851);;
gap> homalg_variable_5873 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5872 = homalg_variable_5873;
true
gap> homalg_variable_5874 := homalg_variable_5868 * (homalg_variable_8);;
gap> homalg_variable_5875 := homalg_variable_5851 * homalg_variable_5874;;
gap> homalg_variable_5875 = homalg_variable_5847;
true
gap> homalg_variable_5876 := SIH_BasisOfColumnModule(homalg_variable_5842);;
gap> SI_ncols(homalg_variable_5876);
3
gap> homalg_variable_5877 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5876 = homalg_variable_5877;
false
gap> homalg_variable_5876 = homalg_variable_5842;
true
gap> homalg_variable_5878 := SIH_DecideZeroColumns(homalg_variable_5847,homalg_variable_5876);;
gap> homalg_variable_5879 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5878 = homalg_variable_5879;
true
gap> homalg_variable_5880 := SIH_UnionOfColumns(homalg_variable_5839,homalg_variable_5651);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5880);; homalg_variable_5881 := homalg_variable_l[1];; homalg_variable_5882 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5881);
3
gap> homalg_variable_5883 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_5881 = homalg_variable_5883;
false
gap> SI_nrows(homalg_variable_5882);
6
gap> homalg_variable_5884 := SIH_Submatrix(homalg_variable_5882,[ 1 ],[1..3]);;
gap> homalg_variable_5885 := homalg_variable_5839 * homalg_variable_5884;;
gap> homalg_variable_5886 := SIH_Submatrix(homalg_variable_5882,[ 2, 3, 4, 5, 6 ],[1..3]);;
gap> homalg_variable_5887 := homalg_variable_5651 * homalg_variable_5886;;
gap> homalg_variable_5888 := homalg_variable_5885 + homalg_variable_5887;;
gap> homalg_variable_5881 = homalg_variable_5888;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5839,homalg_variable_5881);; homalg_variable_5889 := homalg_variable_l[1];; homalg_variable_5890 := homalg_variable_l[2];;
gap> homalg_variable_5891 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_5889 = homalg_variable_5891;
true
gap> homalg_variable_5892 := homalg_variable_5881 * homalg_variable_5890;;
gap> homalg_variable_5893 := homalg_variable_5839 + homalg_variable_5892;;
gap> homalg_variable_5889 = homalg_variable_5893;
true
gap> homalg_variable_5894 := SIH_DecideZeroColumns(homalg_variable_5839,homalg_variable_5881);;
gap> homalg_variable_5895 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_5894 = homalg_variable_5895;
true
gap> homalg_variable_5897 := SIH_Submatrix(homalg_variable_5882,[ 1 ],[1..3]);;
gap> homalg_variable_5898 := homalg_variable_5890 * (homalg_variable_8);;
gap> homalg_variable_5899 := homalg_variable_5897 * homalg_variable_5898;;
gap> homalg_variable_5900 := homalg_variable_5839 * homalg_variable_5899;;
gap> homalg_variable_5901 := homalg_variable_5900 - homalg_variable_5676;;
gap> homalg_variable_5896 := SIH_DecideZeroColumns(homalg_variable_5901,homalg_variable_5651);;
gap> homalg_variable_5902 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_5896 = homalg_variable_5902;
true
gap> homalg_variable_5904 := SIH_UnionOfColumns(homalg_variable_5736,homalg_variable_5651);;
gap> homalg_variable_5903 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_5839,homalg_variable_5904);;
gap> SI_ncols(homalg_variable_5903);
3
gap> homalg_variable_5905 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5903 = homalg_variable_5905;
false
gap> homalg_variable_5906 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5903);;
gap> SI_ncols(homalg_variable_5906);
3
gap> homalg_variable_5907 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_5906 = homalg_variable_5907;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_5906,[ 0 ]);
[  ]
gap> homalg_variable_5908 := SIH_BasisOfColumnModule(homalg_variable_5903);;
gap> SI_ncols(homalg_variable_5908);
3
gap> homalg_variable_5909 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5908 = homalg_variable_5909;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5903);; homalg_variable_5910 := homalg_variable_l[1];; homalg_variable_5911 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5910);
3
gap> homalg_variable_5912 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5910 = homalg_variable_5912;
false
gap> SI_nrows(homalg_variable_5911);
3
gap> homalg_variable_5913 := homalg_variable_5903 * homalg_variable_5911;;
gap> homalg_variable_5910 = homalg_variable_5913;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5908,homalg_variable_5910);; homalg_variable_5914 := homalg_variable_l[1];; homalg_variable_5915 := homalg_variable_l[2];;
gap> homalg_variable_5916 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5914 = homalg_variable_5916;
true
gap> homalg_variable_5917 := homalg_variable_5910 * homalg_variable_5915;;
gap> homalg_variable_5918 := homalg_variable_5908 + homalg_variable_5917;;
gap> homalg_variable_5914 = homalg_variable_5918;
true
gap> homalg_variable_5919 := SIH_DecideZeroColumns(homalg_variable_5908,homalg_variable_5910);;
gap> homalg_variable_5920 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5919 = homalg_variable_5920;
true
gap> homalg_variable_5921 := homalg_variable_5915 * (homalg_variable_8);;
gap> homalg_variable_5922 := homalg_variable_5911 * homalg_variable_5921;;
gap> homalg_variable_5923 := homalg_variable_5903 * homalg_variable_5922;;
gap> homalg_variable_5923 = homalg_variable_5908;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5903,homalg_variable_5908);; homalg_variable_5924 := homalg_variable_l[1];; homalg_variable_5925 := homalg_variable_l[2];;
gap> homalg_variable_5926 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5924 = homalg_variable_5926;
true
gap> homalg_variable_5927 := homalg_variable_5908 * homalg_variable_5925;;
gap> homalg_variable_5928 := homalg_variable_5903 + homalg_variable_5927;;
gap> homalg_variable_5924 = homalg_variable_5928;
true
gap> homalg_variable_5929 := SIH_DecideZeroColumns(homalg_variable_5903,homalg_variable_5908);;
gap> homalg_variable_5930 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5929 = homalg_variable_5930;
true
gap> homalg_variable_5931 := homalg_variable_5925 * (homalg_variable_8);;
gap> homalg_variable_5932 := homalg_variable_5908 * homalg_variable_5931;;
gap> homalg_variable_5932 = homalg_variable_5903;
true
gap> homalg_variable_5933 := SIH_DecideZeroColumns(homalg_variable_5903,homalg_variable_5876);;
gap> homalg_variable_5934 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5933 = homalg_variable_5934;
true
gap> homalg_variable_5936 := homalg_variable_5899 * homalg_variable_2959;;
gap> homalg_variable_5935 := SIH_DecideZeroColumns(homalg_variable_5936,homalg_variable_5876);;
gap> homalg_variable_5937 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5935 = homalg_variable_5937;
true
gap> homalg_variable_5939 := SIH_UnionOfColumns(homalg_variable_5899,homalg_variable_5876);;
gap> homalg_variable_5938 := SIH_BasisOfColumnModule(homalg_variable_5939);;
gap> SI_ncols(homalg_variable_5938);
1
gap> homalg_variable_5940 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_5938 = homalg_variable_5940;
false
gap> homalg_variable_5941 := SIH_DecideZeroColumns(homalg_variable_860,homalg_variable_5938);;
gap> homalg_variable_5942 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_5941 = homalg_variable_5942;
true
gap> homalg_variable_5943 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_5899,homalg_variable_5876);;
gap> SI_ncols(homalg_variable_5943);
3
gap> homalg_variable_5944 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5943 = homalg_variable_5944;
false
gap> homalg_variable_5945 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5943);;
gap> SI_ncols(homalg_variable_5945);
3
gap> homalg_variable_5946 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_5945 = homalg_variable_5946;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_5945,[ 0 ]);
[  ]
gap> homalg_variable_5947 := SIH_BasisOfColumnModule(homalg_variable_5943);;
gap> SI_ncols(homalg_variable_5947);
3
gap> homalg_variable_5948 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5947 = homalg_variable_5948;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5943);; homalg_variable_5949 := homalg_variable_l[1];; homalg_variable_5950 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5949);
3
gap> homalg_variable_5951 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5949 = homalg_variable_5951;
false
gap> SI_nrows(homalg_variable_5950);
3
gap> homalg_variable_5952 := homalg_variable_5943 * homalg_variable_5950;;
gap> homalg_variable_5949 = homalg_variable_5952;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5947,homalg_variable_5949);; homalg_variable_5953 := homalg_variable_l[1];; homalg_variable_5954 := homalg_variable_l[2];;
gap> homalg_variable_5955 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5953 = homalg_variable_5955;
true
gap> homalg_variable_5956 := homalg_variable_5949 * homalg_variable_5954;;
gap> homalg_variable_5957 := homalg_variable_5947 + homalg_variable_5956;;
gap> homalg_variable_5953 = homalg_variable_5957;
true
gap> homalg_variable_5958 := SIH_DecideZeroColumns(homalg_variable_5947,homalg_variable_5949);;
gap> homalg_variable_5959 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5958 = homalg_variable_5959;
true
gap> homalg_variable_5960 := homalg_variable_5954 * (homalg_variable_8);;
gap> homalg_variable_5961 := homalg_variable_5950 * homalg_variable_5960;;
gap> homalg_variable_5962 := homalg_variable_5943 * homalg_variable_5961;;
gap> homalg_variable_5962 = homalg_variable_5947;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5943,homalg_variable_5947);; homalg_variable_5963 := homalg_variable_l[1];; homalg_variable_5964 := homalg_variable_l[2];;
gap> homalg_variable_5965 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5963 = homalg_variable_5965;
true
gap> homalg_variable_5966 := homalg_variable_5947 * homalg_variable_5964;;
gap> homalg_variable_5967 := homalg_variable_5943 + homalg_variable_5966;;
gap> homalg_variable_5963 = homalg_variable_5967;
true
gap> homalg_variable_5968 := SIH_DecideZeroColumns(homalg_variable_5943,homalg_variable_5947);;
gap> homalg_variable_5969 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5968 = homalg_variable_5969;
true
gap> homalg_variable_5970 := homalg_variable_5964 * (homalg_variable_8);;
gap> homalg_variable_5971 := homalg_variable_5947 * homalg_variable_5970;;
gap> homalg_variable_5971 = homalg_variable_5943;
true
gap> homalg_variable_5972 := SIH_DecideZeroColumns(homalg_variable_5943,homalg_variable_2959);;
gap> homalg_variable_5973 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5972 = homalg_variable_5973;
true
gap> homalg_variable_5974 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3037);;
gap> SI_ncols(homalg_variable_5974);
1
gap> homalg_variable_5975 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_5974 = homalg_variable_5975;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_5974,[ 0 ]);
[  ]
gap> SIH_ZeroColumns(homalg_variable_3037);
[  ]
gap> homalg_variable_5976 := homalg_variable_3037 * homalg_variable_5974;;
gap> homalg_variable_5977 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_5976 = homalg_variable_5977;
true
gap> homalg_variable_5978 := SIH_BasisOfColumnModule(homalg_variable_5974);;
gap> SI_ncols(homalg_variable_5978);
1
gap> homalg_variable_5979 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_5978 = homalg_variable_5979;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5974);; homalg_variable_5980 := homalg_variable_l[1];; homalg_variable_5981 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5980);
1
gap> homalg_variable_5982 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_5980 = homalg_variable_5982;
false
gap> SI_nrows(homalg_variable_5981);
1
gap> homalg_variable_5983 := homalg_variable_5974 * homalg_variable_5981;;
gap> homalg_variable_5980 = homalg_variable_5983;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5978,homalg_variable_5980);; homalg_variable_5984 := homalg_variable_l[1];; homalg_variable_5985 := homalg_variable_l[2];;
gap> homalg_variable_5986 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_5984 = homalg_variable_5986;
true
gap> homalg_variable_5987 := homalg_variable_5980 * homalg_variable_5985;;
gap> homalg_variable_5988 := homalg_variable_5978 + homalg_variable_5987;;
gap> homalg_variable_5984 = homalg_variable_5988;
true
gap> homalg_variable_5989 := SIH_DecideZeroColumns(homalg_variable_5978,homalg_variable_5980);;
gap> homalg_variable_5990 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_5989 = homalg_variable_5990;
true
gap> homalg_variable_5991 := homalg_variable_5985 * (homalg_variable_8);;
gap> homalg_variable_5992 := homalg_variable_5981 * homalg_variable_5991;;
gap> homalg_variable_5993 := homalg_variable_5974 * homalg_variable_5992;;
gap> homalg_variable_5993 = homalg_variable_5978;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5974,homalg_variable_5978);; homalg_variable_5994 := homalg_variable_l[1];; homalg_variable_5995 := homalg_variable_l[2];;
gap> homalg_variable_5996 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_5994 = homalg_variable_5996;
true
gap> homalg_variable_5997 := homalg_variable_5978 * homalg_variable_5995;;
gap> homalg_variable_5998 := homalg_variable_5974 + homalg_variable_5997;;
gap> homalg_variable_5994 = homalg_variable_5998;
true
gap> homalg_variable_5999 := SIH_DecideZeroColumns(homalg_variable_5974,homalg_variable_5978);;
gap> homalg_variable_6000 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_5999 = homalg_variable_6000;
true
gap> for _del in [ "homalg_variable_1866", "homalg_variable_1867", "homalg_variable_1926", "homalg_variable_1927", "homalg_variable_1931", "homalg_variable_1933", "homalg_variable_1993", "homalg_variable_1994", "homalg_variable_2000", "homalg_variable_2001", "homalg_variable_2031", "homalg_variable_2032", "homalg_variable_2034", "homalg_variable_2035", "homalg_variable_2038", "homalg_variable_2039", "homalg_variable_2068", "homalg_variable_2069", "homalg_variable_2070", "homalg_variable_2071", "homalg_variable_2072", "homalg_variable_2073", "homalg_variable_2074", "homalg_variable_2075", "homalg_variable_2076", "homalg_variable_2077", "homalg_variable_2078", "homalg_variable_2079", "homalg_variable_2139", "homalg_variable_2140", "homalg_variable_2142", "homalg_variable_2146", "homalg_variable_2147", "homalg_variable_2299", "homalg_variable_2302", "homalg_variable_2303", "homalg_variable_2354", "homalg_variable_2355", "homalg_variable_2357", "homalg_variable_2358", "homalg_variable_2361", "homalg_variable_2362", "homalg_variable_2429", "homalg_variable_2430", "homalg_variable_2431", "homalg_variable_2432", "homalg_variable_2465", "homalg_variable_2466", "homalg_variable_2472", "homalg_variable_2473", "homalg_variable_2585", "homalg_variable_2586", "homalg_variable_2592", "homalg_variable_2593", "homalg_variable_2676", "homalg_variable_2677", "homalg_variable_2683", "homalg_variable_2684", "homalg_variable_2704", "homalg_variable_2774", "homalg_variable_2776", "homalg_variable_2777", "homalg_variable_2787", "homalg_variable_2823", "homalg_variable_2911", "homalg_variable_2912", "homalg_variable_2913", "homalg_variable_2956", "homalg_variable_2999", "homalg_variable_3039", "homalg_variable_3040", "homalg_variable_3053", "homalg_variable_3054", "homalg_variable_3058", "homalg_variable_3059", "homalg_variable_3060", "homalg_variable_3061", "homalg_variable_3086", "homalg_variable_3087", "homalg_variable_3088", "homalg_variable_3093", "homalg_variable_3094", "homalg_variable_3109", "homalg_variable_3125", "homalg_variable_3126", "homalg_variable_3130", "homalg_variable_3131", "homalg_variable_3132", "homalg_variable_3133", "homalg_variable_3244", "homalg_variable_3291", "homalg_variable_3292", "homalg_variable_3324", "homalg_variable_3420", "homalg_variable_3502", "homalg_variable_3508", "homalg_variable_3564", "homalg_variable_3565", "homalg_variable_3567", "homalg_variable_3568", "homalg_variable_3571", "homalg_variable_3573", "homalg_variable_3578", "homalg_variable_3634", "homalg_variable_3635", "homalg_variable_3639", "homalg_variable_3640", "homalg_variable_3641", "homalg_variable_3642", "homalg_variable_3669", "homalg_variable_3702", "homalg_variable_3703", "homalg_variable_3718", "homalg_variable_3719", "homalg_variable_3723", "homalg_variable_3724", "homalg_variable_3725", "homalg_variable_3726", "homalg_variable_3802", "homalg_variable_3803", "homalg_variable_3804", "homalg_variable_3809", "homalg_variable_3810", "homalg_variable_3866", "homalg_variable_3867", "homalg_variable_3869", "homalg_variable_3870", "homalg_variable_3873", "homalg_variable_3874", "homalg_variable_3932", "homalg_variable_3935", "homalg_variable_3936", "homalg_variable_3958", "homalg_variable_3959", "homalg_variable_3965", "homalg_variable_3966", "homalg_variable_3967", "homalg_variable_4034", "homalg_variable_4036", "homalg_variable_4037", "homalg_variable_4039", "homalg_variable_4041", "homalg_variable_4042", "homalg_variable_4066", "homalg_variable_4067", "homalg_variable_4068", "homalg_variable_4098", "homalg_variable_4099", "homalg_variable_4119", "homalg_variable_4120", "homalg_variable_4121", "homalg_variable_4122", "homalg_variable_4123", "homalg_variable_4124", "homalg_variable_4128", "homalg_variable_4130", "homalg_variable_4132", "homalg_variable_4133", "homalg_variable_4146", "homalg_variable_4147", "homalg_variable_4153", "homalg_variable_4182", "homalg_variable_4186", "homalg_variable_4188", "homalg_variable_4190", "homalg_variable_4191", "homalg_variable_4192", "homalg_variable_4194", "homalg_variable_4195", "homalg_variable_4201", "homalg_variable_4202", "homalg_variable_4231", "homalg_variable_4232", "homalg_variable_4240", "homalg_variable_4244", "homalg_variable_4246", "homalg_variable_4248", "homalg_variable_4249", "homalg_variable_4262", "homalg_variable_4263", "homalg_variable_4264", "homalg_variable_4269", "homalg_variable_4293", "homalg_variable_4297", "homalg_variable_4299", "homalg_variable_4300", "homalg_variable_4301", "homalg_variable_4302", "homalg_variable_4326", "homalg_variable_4328", "homalg_variable_4329", "homalg_variable_4330", "homalg_variable_4337", "homalg_variable_4339", "homalg_variable_4340", "homalg_variable_4341", "homalg_variable_4350", "homalg_variable_4352", "homalg_variable_4353", "homalg_variable_4361", "homalg_variable_4363", "homalg_variable_4368", "homalg_variable_4369", "homalg_variable_4398", "homalg_variable_4399", "homalg_variable_4405", "homalg_variable_4415", "homalg_variable_4416", "homalg_variable_4417", "homalg_variable_4424", "homalg_variable_4427", "homalg_variable_4428", "homalg_variable_4437", "homalg_variable_4439", "homalg_variable_4440", "homalg_variable_4448", "homalg_variable_4450", "homalg_variable_4453", "homalg_variable_4454", "homalg_variable_4476", "homalg_variable_4477", "homalg_variable_4481", "homalg_variable_4482", "homalg_variable_4483", "homalg_variable_4484", "homalg_variable_4500", "homalg_variable_4501", "homalg_variable_4502", "homalg_variable_4527", "homalg_variable_4530", "homalg_variable_4558", "homalg_variable_4564", "homalg_variable_4565", "homalg_variable_4566", "homalg_variable_4568", "homalg_variable_4569", "homalg_variable_4582", "homalg_variable_4583", "homalg_variable_4589", "homalg_variable_4606", "homalg_variable_4607", "homalg_variable_4611", "homalg_variable_4612", "homalg_variable_4613", "homalg_variable_4614", "homalg_variable_4627", "homalg_variable_4628", "homalg_variable_4635", "homalg_variable_4637", "homalg_variable_4639", "homalg_variable_4641", "homalg_variable_4642", "homalg_variable_4643", "homalg_variable_4645", "homalg_variable_4646", "homalg_variable_4652", "homalg_variable_4653", "homalg_variable_4664", "homalg_variable_4665", "homalg_variable_4691", "homalg_variable_4692", "homalg_variable_4696", "homalg_variable_4697", "homalg_variable_4698", "homalg_variable_4700", "homalg_variable_4701", "homalg_variable_4702", "homalg_variable_4709", "homalg_variable_4711", "homalg_variable_4713", "homalg_variable_4715", "homalg_variable_4716", "homalg_variable_4729", "homalg_variable_4730", "homalg_variable_4734", "homalg_variable_4735", "homalg_variable_4736", "homalg_variable_4740", "homalg_variable_4741", "homalg_variable_4742", "homalg_variable_4744", "homalg_variable_4745", "homalg_variable_4746", "homalg_variable_4749", "homalg_variable_4751", "homalg_variable_4753", "homalg_variable_4754", "homalg_variable_4755", "homalg_variable_4756", "homalg_variable_4759", "homalg_variable_4760", "homalg_variable_4766", "homalg_variable_4767", "homalg_variable_4780", "homalg_variable_4781", "homalg_variable_4799", "homalg_variable_4800", "homalg_variable_4804", "homalg_variable_4805", "homalg_variable_4806", "homalg_variable_4821", "homalg_variable_4836", "homalg_variable_4837", "homalg_variable_4843", "homalg_variable_4844", "homalg_variable_4850", "homalg_variable_4851", "homalg_variable_4857", "homalg_variable_4859", "homalg_variable_4861", "homalg_variable_4863", "homalg_variable_4864", "homalg_variable_4867", "homalg_variable_4868", "homalg_variable_4869", "homalg_variable_4874", "homalg_variable_4875", "homalg_variable_4886", "homalg_variable_4892", "homalg_variable_4898", "homalg_variable_4900", "homalg_variable_4902", "homalg_variable_4904", "homalg_variable_4905", "homalg_variable_4908", "homalg_variable_4909", "homalg_variable_4910", "homalg_variable_4915", "homalg_variable_4916", "homalg_variable_4927", "homalg_variable_4928", "homalg_variable_4939", "homalg_variable_4941", "homalg_variable_4943", "homalg_variable_4945", "homalg_variable_4946", "homalg_variable_4947", "homalg_variable_4949", "homalg_variable_4950", "homalg_variable_4956", "homalg_variable_4957", "homalg_variable_4959", "homalg_variable_4960", "homalg_variable_4966", "homalg_variable_4970", "homalg_variable_4971", "homalg_variable_4972", "homalg_variable_5004", "homalg_variable_5006", "homalg_variable_5007", "homalg_variable_5008", "homalg_variable_5009", "homalg_variable_5010", "homalg_variable_5013", "homalg_variable_5014", "homalg_variable_5018", "homalg_variable_5019", "homalg_variable_5020", "homalg_variable_5021", "homalg_variable_5038", "homalg_variable_5039", "homalg_variable_5040", "homalg_variable_5041", "homalg_variable_5042", "homalg_variable_5043", "homalg_variable_5044", "homalg_variable_5046", "homalg_variable_5047", "homalg_variable_5053", "homalg_variable_5054", "homalg_variable_5060", "homalg_variable_5061", "homalg_variable_5063", "homalg_variable_5064", "homalg_variable_5067", "homalg_variable_5068", "homalg_variable_5080", "homalg_variable_5081", "homalg_variable_5104", "homalg_variable_5105", "homalg_variable_5106", "homalg_variable_5107", "homalg_variable_5108", "homalg_variable_5110", "homalg_variable_5111", "homalg_variable_5113", "homalg_variable_5125", "homalg_variable_5127", "homalg_variable_5128", "homalg_variable_5131", "homalg_variable_5132", "homalg_variable_5133", "homalg_variable_5135", "homalg_variable_5136", "homalg_variable_5137", "homalg_variable_5138", "homalg_variable_5141", "homalg_variable_5142", "homalg_variable_5143", "homalg_variable_5148", "homalg_variable_5149", "homalg_variable_5155", "homalg_variable_5156", "homalg_variable_5160", "homalg_variable_5161", "homalg_variable_5162", "homalg_variable_5163", "homalg_variable_5166", "homalg_variable_5167", "homalg_variable_5169", "homalg_variable_5170", "homalg_variable_5171", "homalg_variable_5173", "homalg_variable_5174", "homalg_variable_5175", "homalg_variable_5176", "homalg_variable_5177", "homalg_variable_5180", "homalg_variable_5181", "homalg_variable_5187", "homalg_variable_5188", "homalg_variable_5189", "homalg_variable_5206", "homalg_variable_5208", "homalg_variable_5228", "homalg_variable_5233", "homalg_variable_5244", "homalg_variable_5254", "homalg_variable_5266", "homalg_variable_5268", "homalg_variable_5269", "homalg_variable_5271", "homalg_variable_5290", "homalg_variable_5319", "homalg_variable_5320", "homalg_variable_5326", "homalg_variable_5330", "homalg_variable_5331", "homalg_variable_5332", "homalg_variable_5333", "homalg_variable_5336", "homalg_variable_5337", "homalg_variable_5338", "homalg_variable_5339", "homalg_variable_5340", "homalg_variable_5341", "homalg_variable_5355", "homalg_variable_5356", "homalg_variable_5364", "homalg_variable_5371", "homalg_variable_5375", "homalg_variable_5376", "homalg_variable_5377", "homalg_variable_5378", "homalg_variable_5379", "homalg_variable_5387", "homalg_variable_5392", "homalg_variable_5393", "homalg_variable_5401", "homalg_variable_5405", "homalg_variable_5407", "homalg_variable_5408", "homalg_variable_5411", "homalg_variable_5413", "homalg_variable_5414", "homalg_variable_5417", "homalg_variable_5418", "homalg_variable_5422", "homalg_variable_5423", "homalg_variable_5424", "homalg_variable_5425", "homalg_variable_5427", "homalg_variable_5428", "homalg_variable_5434", "homalg_variable_5435", "homalg_variable_5446", "homalg_variable_5451", "homalg_variable_5452", "homalg_variable_5456", "homalg_variable_5458", "homalg_variable_5459", "homalg_variable_5461", "homalg_variable_5462", "homalg_variable_5468", "homalg_variable_5469", "homalg_variable_5477", "homalg_variable_5478", "homalg_variable_5480", "homalg_variable_5482", "homalg_variable_5484", "homalg_variable_5486", "homalg_variable_5487", "homalg_variable_5488", "homalg_variable_5490", "homalg_variable_5491", "homalg_variable_5497", "homalg_variable_5498", "homalg_variable_5500", "homalg_variable_5501", "homalg_variable_5502", "homalg_variable_5503", "homalg_variable_5504", "homalg_variable_5505", "homalg_variable_5506", "homalg_variable_5507", "homalg_variable_5508", "homalg_variable_5509", "homalg_variable_5510", "homalg_variable_5511", "homalg_variable_5512", "homalg_variable_5513", "homalg_variable_5514", "homalg_variable_5515", "homalg_variable_5516", "homalg_variable_5517", "homalg_variable_5518", "homalg_variable_5519", "homalg_variable_5520", "homalg_variable_5521", "homalg_variable_5522", "homalg_variable_5523", "homalg_variable_5524", "homalg_variable_5525", "homalg_variable_5526", "homalg_variable_5527", "homalg_variable_5528", "homalg_variable_5529", "homalg_variable_5530", "homalg_variable_5531", "homalg_variable_5532", "homalg_variable_5533", "homalg_variable_5534", "homalg_variable_5535", "homalg_variable_5536", "homalg_variable_5537", "homalg_variable_5538", "homalg_variable_5539", "homalg_variable_5540", "homalg_variable_5541", "homalg_variable_5542", "homalg_variable_5543", "homalg_variable_5547", "homalg_variable_5548", "homalg_variable_5549", "homalg_variable_5550", "homalg_variable_5551", "homalg_variable_5552", "homalg_variable_5553", "homalg_variable_5554", "homalg_variable_5555", "homalg_variable_5556", "homalg_variable_5557", "homalg_variable_5558", "homalg_variable_5559", "homalg_variable_5560", "homalg_variable_5561", "homalg_variable_5562", "homalg_variable_5563", "homalg_variable_5564", "homalg_variable_5565", "homalg_variable_5566", "homalg_variable_5567", "homalg_variable_5568", "homalg_variable_5569", "homalg_variable_5570", "homalg_variable_5571", "homalg_variable_5572", "homalg_variable_5573", "homalg_variable_5574", "homalg_variable_5575", "homalg_variable_5576", "homalg_variable_5577", "homalg_variable_5578", "homalg_variable_5579", "homalg_variable_5580", "homalg_variable_5581", "homalg_variable_5582", "homalg_variable_5583", "homalg_variable_5584", "homalg_variable_5585", "homalg_variable_5586", "homalg_variable_5587", "homalg_variable_5588", "homalg_variable_5589", "homalg_variable_5590", "homalg_variable_5591", "homalg_variable_5592", "homalg_variable_5593", "homalg_variable_5594", "homalg_variable_5596", "homalg_variable_5597", "homalg_variable_5598", "homalg_variable_5599", "homalg_variable_5600", "homalg_variable_5601", "homalg_variable_5604", "homalg_variable_5605", "homalg_variable_5608", "homalg_variable_5609", "homalg_variable_5610", "homalg_variable_5611", "homalg_variable_5612", "homalg_variable_5613", "homalg_variable_5615", "homalg_variable_5616", "homalg_variable_5617", "homalg_variable_5618", "homalg_variable_5619", "homalg_variable_5620", "homalg_variable_5621", "homalg_variable_5623", "homalg_variable_5625", "homalg_variable_5627", "homalg_variable_5630", "homalg_variable_5631", "homalg_variable_5632", "homalg_variable_5633", "homalg_variable_5634", "homalg_variable_5635", "homalg_variable_5636", "homalg_variable_5637", "homalg_variable_5638", "homalg_variable_5639", "homalg_variable_5640", "homalg_variable_5641", "homalg_variable_5642", "homalg_variable_5643", "homalg_variable_5644", "homalg_variable_5645", "homalg_variable_5646", "homalg_variable_5647", "homalg_variable_5648", "homalg_variable_5649", "homalg_variable_5650", "homalg_variable_5652", "homalg_variable_5653", "homalg_variable_5654", "homalg_variable_5655", "homalg_variable_5656", "homalg_variable_5658", "homalg_variable_5659", "homalg_variable_5660", "homalg_variable_5661", "homalg_variable_5662", "homalg_variable_5663", "homalg_variable_5664", "homalg_variable_5665", "homalg_variable_5666", "homalg_variable_5668", "homalg_variable_5669", "homalg_variable_5670", "homalg_variable_5671", "homalg_variable_5672", "homalg_variable_5673", "homalg_variable_5677", "homalg_variable_5678", "homalg_variable_5679", "homalg_variable_5680", "homalg_variable_5681", "homalg_variable_5683", "homalg_variable_5684", "homalg_variable_5685", "homalg_variable_5686", "homalg_variable_5687", "homalg_variable_5688", "homalg_variable_5689", "homalg_variable_5690", "homalg_variable_5691", "homalg_variable_5692", "homalg_variable_5694", "homalg_variable_5695", "homalg_variable_5696", "homalg_variable_5697", "homalg_variable_5698", "homalg_variable_5699", "homalg_variable_5703", "homalg_variable_5704", "homalg_variable_5705", "homalg_variable_5706", "homalg_variable_5708", "homalg_variable_5709", "homalg_variable_5710", "homalg_variable_5711", "homalg_variable_5712", "homalg_variable_5713", "homalg_variable_5714", "homalg_variable_5715", "homalg_variable_5716", "homalg_variable_5717", "homalg_variable_5718", "homalg_variable_5719", "homalg_variable_5720", "homalg_variable_5721", "homalg_variable_5722", "homalg_variable_5723", "homalg_variable_5724", "homalg_variable_5725", "homalg_variable_5726", "homalg_variable_5727", "homalg_variable_5728", "homalg_variable_5729", "homalg_variable_5730", "homalg_variable_5731", "homalg_variable_5732", "homalg_variable_5733", "homalg_variable_5734", "homalg_variable_5735", "homalg_variable_5737", "homalg_variable_5738", "homalg_variable_5739", "homalg_variable_5740", "homalg_variable_5742", "homalg_variable_5744", "homalg_variable_5746", "homalg_variable_5749", "homalg_variable_5750", "homalg_variable_5751", "homalg_variable_5752", "homalg_variable_5753", "homalg_variable_5754", "homalg_variable_5755", "homalg_variable_5756", "homalg_variable_5757", "homalg_variable_5758", "homalg_variable_5759", "homalg_variable_5760", "homalg_variable_5761", "homalg_variable_5762", "homalg_variable_5763", "homalg_variable_5764", "homalg_variable_5765", "homalg_variable_5766", "homalg_variable_5767", "homalg_variable_5768", "homalg_variable_5769", "homalg_variable_5770", "homalg_variable_5771", "homalg_variable_5774", "homalg_variable_5775", "homalg_variable_5776", "homalg_variable_5777", "homalg_variable_5778", "homalg_variable_5779", "homalg_variable_5780", "homalg_variable_5781", "homalg_variable_5782", "homalg_variable_5783", "homalg_variable_5784", "homalg_variable_5785", "homalg_variable_5786", "homalg_variable_5787", "homalg_variable_5788", "homalg_variable_5789", "homalg_variable_5790", "homalg_variable_5791", "homalg_variable_5792", "homalg_variable_5793", "homalg_variable_5794", "homalg_variable_5795", "homalg_variable_5796", "homalg_variable_5797", "homalg_variable_5798", "homalg_variable_5799", "homalg_variable_5800", "homalg_variable_5801", "homalg_variable_5802", "homalg_variable_5803", "homalg_variable_5804", "homalg_variable_5805", "homalg_variable_5806", "homalg_variable_5807", "homalg_variable_5808", "homalg_variable_5809", "homalg_variable_5810", "homalg_variable_5811", "homalg_variable_5812", "homalg_variable_5813", "homalg_variable_5814", "homalg_variable_5815", "homalg_variable_5816", "homalg_variable_5817", "homalg_variable_5818", "homalg_variable_5819", "homalg_variable_5820", "homalg_variable_5822", "homalg_variable_5823", "homalg_variable_5824", "homalg_variable_5825", "homalg_variable_5826", "homalg_variable_5827", "homalg_variable_5829", "homalg_variable_5830", "homalg_variable_5833", "homalg_variable_5834", "homalg_variable_5835", "homalg_variable_5836", "homalg_variable_5837", "homalg_variable_5838", "homalg_variable_5841", "homalg_variable_5842", "homalg_variable_5843", "homalg_variable_5844", "homalg_variable_5845", "homalg_variable_5846", "homalg_variable_5848", "homalg_variable_5850", "homalg_variable_5852", "homalg_variable_5855", "homalg_variable_5856", "homalg_variable_5857", "homalg_variable_5858", "homalg_variable_5859", "homalg_variable_5860", "homalg_variable_5861", "homalg_variable_5862", "homalg_variable_5863", "homalg_variable_5864", "homalg_variable_5865", "homalg_variable_5866", "homalg_variable_5867", "homalg_variable_5868", "homalg_variable_5869", "homalg_variable_5870", "homalg_variable_5871", "homalg_variable_5872", "homalg_variable_5873", "homalg_variable_5874", "homalg_variable_5875", "homalg_variable_5877", "homalg_variable_5878", "homalg_variable_5879", "homalg_variable_5880", "homalg_variable_5881", "homalg_variable_5883", "homalg_variable_5884", "homalg_variable_5885", "homalg_variable_5886", "homalg_variable_5887", "homalg_variable_5888", "homalg_variable_5889", "homalg_variable_5891", "homalg_variable_5892", "homalg_variable_5893", "homalg_variable_5894", "homalg_variable_5895", "homalg_variable_5896", "homalg_variable_5900", "homalg_variable_5901", "homalg_variable_5902", "homalg_variable_5903", "homalg_variable_5905", "homalg_variable_5906", "homalg_variable_5907", "homalg_variable_5908", "homalg_variable_5909", "homalg_variable_5910", "homalg_variable_5911", "homalg_variable_5912", "homalg_variable_5913", "homalg_variable_5914", "homalg_variable_5915", "homalg_variable_5916", "homalg_variable_5917", "homalg_variable_5918", "homalg_variable_5919", "homalg_variable_5920", "homalg_variable_5921", "homalg_variable_5922", "homalg_variable_5923", "homalg_variable_5924", "homalg_variable_5925", "homalg_variable_5926", "homalg_variable_5927", "homalg_variable_5928", "homalg_variable_5929", "homalg_variable_5930", "homalg_variable_5931", "homalg_variable_5932", "homalg_variable_5934", "homalg_variable_5935", "homalg_variable_5936", "homalg_variable_5937", "homalg_variable_5941", "homalg_variable_5942", "homalg_variable_5944", "homalg_variable_5946", "homalg_variable_5948", "homalg_variable_5951", "homalg_variable_5952", "homalg_variable_5953", "homalg_variable_5954", "homalg_variable_5955", "homalg_variable_5956", "homalg_variable_5957", "homalg_variable_5958", "homalg_variable_5959", "homalg_variable_5960", "homalg_variable_5961", "homalg_variable_5962", "homalg_variable_5963", "homalg_variable_5964", "homalg_variable_5965", "homalg_variable_5966", "homalg_variable_5967", "homalg_variable_5968", "homalg_variable_5969", "homalg_variable_5970", "homalg_variable_5971", "homalg_variable_5972", "homalg_variable_5973", "homalg_variable_5975" ] do UnbindGlobal( _del ); od;;
gap> homalg_variable_6001 := homalg_variable_5995 * (homalg_variable_8);;
gap> homalg_variable_6002 := homalg_variable_5978 * homalg_variable_6001;;
gap> homalg_variable_6002 = homalg_variable_5974;
true
gap> homalg_variable_5978 = homalg_variable_5974;
true
gap> homalg_variable_6003 := SIH_DecideZeroColumns(homalg_variable_5702,homalg_variable_5651);;
gap> homalg_variable_6004 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_6003 = homalg_variable_6004;
false
gap> homalg_variable_6006 := homalg_variable_5839 * homalg_variable_5899;;
gap> homalg_variable_6005 := SIH_DecideZeroColumns(homalg_variable_6006,homalg_variable_5651);;
gap> homalg_variable_6007 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_6005 = homalg_variable_6007;
false
gap> homalg_variable_6008 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_6006 = homalg_variable_6008;
false
gap> homalg_variable_6009 := SIH_UnionOfColumns(homalg_variable_6005,homalg_variable_5651);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6009);; homalg_variable_6010 := homalg_variable_l[1];; homalg_variable_6011 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6010);
3
gap> homalg_variable_6012 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_6010 = homalg_variable_6012;
false
gap> SI_nrows(homalg_variable_6011);
6
gap> homalg_variable_6013 := SIH_Submatrix(homalg_variable_6011,[ 1 ],[1..3]);;
gap> homalg_variable_6014 := homalg_variable_6005 * homalg_variable_6013;;
gap> homalg_variable_6015 := SIH_Submatrix(homalg_variable_6011,[ 2, 3, 4, 5, 6 ],[1..3]);;
gap> homalg_variable_6016 := homalg_variable_5651 * homalg_variable_6015;;
gap> homalg_variable_6017 := homalg_variable_6014 + homalg_variable_6016;;
gap> homalg_variable_6010 = homalg_variable_6017;
true
gap> homalg_variable_6019 := homalg_variable_6003 * homalg_variable_3037;;
gap> homalg_variable_6018 := SIH_DecideZeroColumns(homalg_variable_6019,homalg_variable_5651);;
gap> homalg_variable_6020 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_6018 = homalg_variable_6020;
true
gap> homalg_variable_6022 := homalg_variable_6019 * (homalg_variable_8);;
gap> homalg_variable_6021 := SIH_DecideZeroColumns(homalg_variable_6022,homalg_variable_5651);;
gap> homalg_variable_6023 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_6021 = homalg_variable_6023;
true
gap> homalg_variable_6025 := homalg_variable_6003 * (homalg_variable_8);;
gap> homalg_variable_6026 := homalg_variable_6025 * homalg_variable_3037;;
gap> homalg_variable_6024 := SIH_DecideZeroColumns(homalg_variable_6026,homalg_variable_5651);;
gap> homalg_variable_6027 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_6024 = homalg_variable_6027;
true
gap> homalg_variable_6029 := homalg_variable_6025 * homalg_variable_3037;;
gap> homalg_variable_6030 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_6031 := SIH_UnionOfColumns(homalg_variable_6029,homalg_variable_6030);;
gap> homalg_variable_6032 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_6033 := homalg_variable_6006 * homalg_variable_2959;;
gap> homalg_variable_6034 := SIH_UnionOfColumns(homalg_variable_6032,homalg_variable_6033);;
gap> homalg_variable_6035 := homalg_variable_6031 + homalg_variable_6034;;
gap> homalg_variable_6028 := SIH_DecideZeroColumns(homalg_variable_6035,homalg_variable_5651);;
gap> homalg_variable_6036 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6028 = homalg_variable_6036;
true
gap> homalg_variable_6038 := SIH_UnionOfColumns(homalg_variable_6025,homalg_variable_6006);;
gap> homalg_variable_6039 := SIH_UnionOfColumns(homalg_variable_6038,homalg_variable_5651);;
gap> homalg_variable_6037 := SIH_BasisOfColumnModule(homalg_variable_6039);;
gap> SI_ncols(homalg_variable_6037);
2
gap> homalg_variable_6040 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_6037 = homalg_variable_6040;
false
gap> homalg_variable_6041 := SIH_DecideZeroColumns(homalg_variable_618,homalg_variable_6037);;
gap> homalg_variable_6042 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_6041 = homalg_variable_6042;
true
gap> homalg_variable_6043 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_6038,homalg_variable_5651);;
gap> SI_ncols(homalg_variable_6043);
5
gap> homalg_variable_6044 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6043 = homalg_variable_6044;
false
gap> homalg_variable_6045 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_6043);;
gap> SI_ncols(homalg_variable_6045);
4
gap> homalg_variable_6046 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_6045 = homalg_variable_6046;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_6045,[ 0 ]);
[  ]
gap> homalg_variable_6047 := SIH_BasisOfColumnModule(homalg_variable_6043);;
gap> SI_ncols(homalg_variable_6047);
5
gap> homalg_variable_6048 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6047 = homalg_variable_6048;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6043);; homalg_variable_6049 := homalg_variable_l[1];; homalg_variable_6050 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6049);
5
gap> homalg_variable_6051 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6049 = homalg_variable_6051;
false
gap> SI_nrows(homalg_variable_6050);
5
gap> homalg_variable_6052 := homalg_variable_6043 * homalg_variable_6050;;
gap> homalg_variable_6049 = homalg_variable_6052;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6047,homalg_variable_6049);; homalg_variable_6053 := homalg_variable_l[1];; homalg_variable_6054 := homalg_variable_l[2];;
gap> homalg_variable_6055 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6053 = homalg_variable_6055;
true
gap> homalg_variable_6056 := homalg_variable_6049 * homalg_variable_6054;;
gap> homalg_variable_6057 := homalg_variable_6047 + homalg_variable_6056;;
gap> homalg_variable_6053 = homalg_variable_6057;
true
gap> homalg_variable_6058 := SIH_DecideZeroColumns(homalg_variable_6047,homalg_variable_6049);;
gap> homalg_variable_6059 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6058 = homalg_variable_6059;
true
gap> homalg_variable_6060 := homalg_variable_6054 * (homalg_variable_8);;
gap> homalg_variable_6061 := homalg_variable_6050 * homalg_variable_6060;;
gap> homalg_variable_6062 := homalg_variable_6043 * homalg_variable_6061;;
gap> homalg_variable_6062 = homalg_variable_6047;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6043,homalg_variable_6047);; homalg_variable_6063 := homalg_variable_l[1];; homalg_variable_6064 := homalg_variable_l[2];;
gap> homalg_variable_6065 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6063 = homalg_variable_6065;
true
gap> homalg_variable_6066 := homalg_variable_6047 * homalg_variable_6064;;
gap> homalg_variable_6067 := homalg_variable_6043 + homalg_variable_6066;;
gap> homalg_variable_6063 = homalg_variable_6067;
true
gap> homalg_variable_6068 := SIH_DecideZeroColumns(homalg_variable_6043,homalg_variable_6047);;
gap> homalg_variable_6069 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6068 = homalg_variable_6069;
true
gap> homalg_variable_6070 := homalg_variable_6064 * (homalg_variable_8);;
gap> homalg_variable_6071 := homalg_variable_6047 * homalg_variable_6070;;
gap> homalg_variable_6071 = homalg_variable_6043;
true
gap> homalg_variable_6073 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_6074 := SIH_UnionOfRows(homalg_variable_3037,homalg_variable_6073);;
gap> homalg_variable_6075 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_6076 := SIH_UnionOfRows(homalg_variable_6075,homalg_variable_2959);;
gap> homalg_variable_6077 := SIH_UnionOfColumns(homalg_variable_6074,homalg_variable_6076);;
gap> homalg_variable_6072 := SIH_BasisOfColumnModule(homalg_variable_6077);;
gap> SI_ncols(homalg_variable_6072);
5
gap> homalg_variable_6078 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6072 = homalg_variable_6078;
false
gap> homalg_variable_6072 = homalg_variable_6077;
false
gap> homalg_variable_6079 := SIH_DecideZeroColumns(homalg_variable_6043,homalg_variable_6072);;
gap> homalg_variable_6080 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6079 = homalg_variable_6080;
true
gap> homalg_variable_6081 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5056);;
gap> SI_ncols(homalg_variable_6081);
1
gap> homalg_variable_6082 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_6081 = homalg_variable_6082;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_6081,[ 0 ]);
[  ]
gap> SIH_ZeroColumns(homalg_variable_5056);
[  ]
gap> homalg_variable_6083 := homalg_variable_5056 * homalg_variable_6081;;
gap> homalg_variable_6084 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_6083 = homalg_variable_6084;
true
gap> homalg_variable_6085 := SIH_BasisOfColumnModule(homalg_variable_6081);;
gap> SI_ncols(homalg_variable_6085);
1
gap> homalg_variable_6086 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_6085 = homalg_variable_6086;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6081);; homalg_variable_6087 := homalg_variable_l[1];; homalg_variable_6088 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6087);
1
gap> homalg_variable_6089 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_6087 = homalg_variable_6089;
false
gap> SI_nrows(homalg_variable_6088);
1
gap> homalg_variable_6090 := homalg_variable_6081 * homalg_variable_6088;;
gap> homalg_variable_6087 = homalg_variable_6090;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6085,homalg_variable_6087);; homalg_variable_6091 := homalg_variable_l[1];; homalg_variable_6092 := homalg_variable_l[2];;
gap> homalg_variable_6093 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_6091 = homalg_variable_6093;
true
gap> homalg_variable_6094 := homalg_variable_6087 * homalg_variable_6092;;
gap> homalg_variable_6095 := homalg_variable_6085 + homalg_variable_6094;;
gap> homalg_variable_6091 = homalg_variable_6095;
true
gap> homalg_variable_6096 := SIH_DecideZeroColumns(homalg_variable_6085,homalg_variable_6087);;
gap> homalg_variable_6097 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_6096 = homalg_variable_6097;
true
gap> homalg_variable_6098 := homalg_variable_6092 * (homalg_variable_8);;
gap> homalg_variable_6099 := homalg_variable_6088 * homalg_variable_6098;;
gap> homalg_variable_6100 := homalg_variable_6081 * homalg_variable_6099;;
gap> homalg_variable_6100 = homalg_variable_6085;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6081,homalg_variable_6085);; homalg_variable_6101 := homalg_variable_l[1];; homalg_variable_6102 := homalg_variable_l[2];;
gap> homalg_variable_6103 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_6101 = homalg_variable_6103;
true
gap> homalg_variable_6104 := homalg_variable_6085 * homalg_variable_6102;;
gap> homalg_variable_6105 := homalg_variable_6081 + homalg_variable_6104;;
gap> homalg_variable_6101 = homalg_variable_6105;
true
gap> homalg_variable_6106 := SIH_DecideZeroColumns(homalg_variable_6081,homalg_variable_6085);;
gap> homalg_variable_6107 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_6106 = homalg_variable_6107;
true
gap> homalg_variable_6108 := homalg_variable_6102 * (homalg_variable_8);;
gap> homalg_variable_6109 := homalg_variable_6085 * homalg_variable_6108;;
gap> homalg_variable_6109 = homalg_variable_6081;
true
gap> homalg_variable_6085 = homalg_variable_6081;
true
gap> homalg_variable_6110 := SIH_DecideZeroColumns(homalg_variable_5397,homalg_variable_5328);;
gap> homalg_variable_6111 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_6110 = homalg_variable_6111;
false
gap> homalg_variable_6113 := homalg_variable_5614 * homalg_variable_6025;;
gap> homalg_variable_6114 := homalg_variable_5614 * homalg_variable_6006;;
gap> homalg_variable_6115 := SIH_UnionOfColumns(homalg_variable_6113,homalg_variable_6114);;
gap> homalg_variable_6112 := SIH_DecideZeroColumns(homalg_variable_6115,homalg_variable_5328);;
gap> homalg_variable_6116 := SI_matrix(homalg_variable_5,6,2,"0");;
gap> homalg_variable_6112 = homalg_variable_6116;
false
gap> homalg_variable_6117 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_6113 = homalg_variable_6117;
false
gap> homalg_variable_6118 := SIH_UnionOfColumns(homalg_variable_6112,homalg_variable_5328);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6118);; homalg_variable_6119 := homalg_variable_l[1];; homalg_variable_6120 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6119);
7
gap> homalg_variable_6121 := SI_matrix(homalg_variable_5,6,7,"0");;
gap> homalg_variable_6119 = homalg_variable_6121;
false
gap> SI_nrows(homalg_variable_6120);
12
gap> homalg_variable_6122 := SIH_Submatrix(homalg_variable_6120,[ 1, 2 ],[1..7]);;
gap> homalg_variable_6123 := homalg_variable_6112 * homalg_variable_6122;;
gap> homalg_variable_6124 := SIH_Submatrix(homalg_variable_6120,[ 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ],[1..7]);;
gap> homalg_variable_6125 := homalg_variable_5328 * homalg_variable_6124;;
gap> homalg_variable_6126 := homalg_variable_6123 + homalg_variable_6125;;
gap> homalg_variable_6119 = homalg_variable_6126;
true
gap> homalg_variable_6128 := homalg_variable_6110 * homalg_variable_5056;;
gap> homalg_variable_6127 := SIH_DecideZeroColumns(homalg_variable_6128,homalg_variable_5328);;
gap> homalg_variable_6129 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_6127 = homalg_variable_6129;
false
gap> homalg_variable_6130 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_6128 = homalg_variable_6130;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6127,homalg_variable_6119);; homalg_variable_6131 := homalg_variable_l[1];; homalg_variable_6132 := homalg_variable_l[2];;
gap> homalg_variable_6133 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_6131 = homalg_variable_6133;
true
gap> homalg_variable_6134 := homalg_variable_6119 * homalg_variable_6132;;
gap> homalg_variable_6135 := homalg_variable_6127 + homalg_variable_6134;;
gap> homalg_variable_6131 = homalg_variable_6135;
true
gap> homalg_variable_6136 := SIH_DecideZeroColumns(homalg_variable_6127,homalg_variable_6119);;
gap> homalg_variable_6137 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_6136 = homalg_variable_6137;
true
gap> homalg_variable_6139 := SIH_Submatrix(homalg_variable_6120,[ 1 ],[1..7]);;
gap> homalg_variable_6140 := homalg_variable_6132 * (homalg_variable_8);;
gap> homalg_variable_6141 := homalg_variable_6139 * homalg_variable_6140;;
gap> homalg_variable_6142 := homalg_variable_6113 * homalg_variable_6141;;
gap> homalg_variable_6143 := SIH_Submatrix(homalg_variable_6120,[ 2 ],[1..7]);;
gap> homalg_variable_6144 := homalg_variable_6143 * homalg_variable_6140;;
gap> homalg_variable_6145 := homalg_variable_6114 * homalg_variable_6144;;
gap> homalg_variable_6146 := homalg_variable_6142 + homalg_variable_6145;;
gap> homalg_variable_6147 := homalg_variable_6146 - homalg_variable_6128;;
gap> homalg_variable_6138 := SIH_DecideZeroColumns(homalg_variable_6147,homalg_variable_5328);;
gap> homalg_variable_6148 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_6138 = homalg_variable_6148;
true
gap> homalg_variable_6150 := SIH_Submatrix(homalg_variable_6120,[ 1, 2 ],[1..7]);;
gap> homalg_variable_6151 := homalg_variable_6150 * homalg_variable_6140;;
gap> homalg_variable_6152 := homalg_variable_6151 * homalg_variable_6085;;
gap> homalg_variable_6149 := SIH_DecideZeroColumns(homalg_variable_6152,homalg_variable_6072);;
gap> homalg_variable_6153 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_6149 = homalg_variable_6153;
true
gap> homalg_variable_6154 := SIH_DecideZeroColumns(homalg_variable_6151,homalg_variable_6072);;
gap> homalg_variable_6155 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_6154 = homalg_variable_6155;
false
gap> homalg_variable_6156 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_6151 = homalg_variable_6156;
false
gap> homalg_variable_6158 := homalg_variable_6110 * (homalg_variable_8);;
gap> homalg_variable_6159 := homalg_variable_6158 * homalg_variable_5056;;
gap> homalg_variable_6160 := SIH_Submatrix(homalg_variable_6154,[ 1 ],[1..4]);;
gap> homalg_variable_6161 := homalg_variable_6113 * homalg_variable_6160;;
gap> homalg_variable_6162 := SIH_Submatrix(homalg_variable_6154,[ 2 ],[1..4]);;
gap> homalg_variable_6163 := homalg_variable_6114 * homalg_variable_6162;;
gap> homalg_variable_6164 := homalg_variable_6161 + homalg_variable_6163;;
gap> homalg_variable_6165 := homalg_variable_6159 + homalg_variable_6164;;
gap> homalg_variable_6157 := SIH_DecideZeroColumns(homalg_variable_6165,homalg_variable_5328);;
gap> homalg_variable_6166 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_6157 = homalg_variable_6166;
true
gap> homalg_variable_6168 := homalg_variable_6158 * homalg_variable_5056;;
gap> homalg_variable_6169 := SI_matrix(homalg_variable_5,6,5,"0");;
gap> homalg_variable_6170 := SIH_UnionOfColumns(homalg_variable_6168,homalg_variable_6169);;
gap> homalg_variable_6171 := SIH_Submatrix(homalg_variable_6154,[ 1 ],[1..4]);;
gap> homalg_variable_6172 := homalg_variable_6113 * homalg_variable_6171;;
gap> homalg_variable_6173 := homalg_variable_6113 * homalg_variable_3037;;
gap> homalg_variable_6174 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_6175 := SIH_UnionOfColumns(homalg_variable_6173,homalg_variable_6174);;
gap> homalg_variable_6176 := SIH_UnionOfColumns(homalg_variable_6172,homalg_variable_6175);;
gap> homalg_variable_6177 := SIH_Submatrix(homalg_variable_6154,[ 2 ],[1..4]);;
gap> homalg_variable_6178 := homalg_variable_6114 * homalg_variable_6177;;
gap> homalg_variable_6179 := SI_matrix(homalg_variable_5,6,2,"0");;
gap> homalg_variable_6180 := homalg_variable_6114 * homalg_variable_2959;;
gap> homalg_variable_6181 := SIH_UnionOfColumns(homalg_variable_6179,homalg_variable_6180);;
gap> homalg_variable_6182 := SIH_UnionOfColumns(homalg_variable_6178,homalg_variable_6181);;
gap> homalg_variable_6183 := homalg_variable_6176 + homalg_variable_6182;;
gap> homalg_variable_6184 := homalg_variable_6170 + homalg_variable_6183;;
gap> homalg_variable_6167 := SIH_DecideZeroColumns(homalg_variable_6184,homalg_variable_5328);;
gap> homalg_variable_6185 := SI_matrix(homalg_variable_5,6,9,"0");;
gap> homalg_variable_6167 = homalg_variable_6185;
true
gap> homalg_variable_6187 := SIH_UnionOfColumns(homalg_variable_6158,homalg_variable_6115);;
gap> homalg_variable_6188 := SIH_UnionOfColumns(homalg_variable_6187,homalg_variable_5328);;
gap> homalg_variable_6186 := SIH_BasisOfColumnModule(homalg_variable_6188);;
gap> SI_ncols(homalg_variable_6186);
6
gap> homalg_variable_6189 := SI_matrix(homalg_variable_5,6,6,"0");;
gap> homalg_variable_6186 = homalg_variable_6189;
false
gap> homalg_variable_6190 := SIH_DecideZeroColumns(homalg_variable_5603,homalg_variable_6186);;
gap> homalg_variable_6191 := SI_matrix(homalg_variable_5,6,6,"0");;
gap> homalg_variable_6190 = homalg_variable_6191;
true
gap> homalg_variable_6192 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_6187,homalg_variable_5328);;
gap> SI_ncols(homalg_variable_6192);
9
gap> homalg_variable_6193 := SI_matrix(homalg_variable_5,5,9,"0");;
gap> homalg_variable_6192 = homalg_variable_6193;
false
gap> homalg_variable_6194 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_6192);;
gap> SI_ncols(homalg_variable_6194);
5
gap> homalg_variable_6195 := SI_matrix(homalg_variable_5,9,5,"0");;
gap> homalg_variable_6194 = homalg_variable_6195;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_6194,[ 0 ]);
[ [ 4, 5 ] ]
gap> homalg_variable_6197 := SIH_Submatrix(homalg_variable_6192,[1..5],[ 1, 2, 3, 4, 6, 7, 8, 9 ]);;
gap> homalg_variable_6196 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_6197);;
gap> SI_ncols(homalg_variable_6196);
4
gap> homalg_variable_6198 := SI_matrix(homalg_variable_5,8,4,"0");;
gap> homalg_variable_6196 = homalg_variable_6198;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_6196,[ 0 ]);
[  ]
gap> homalg_variable_6199 := SI_matrix(homalg_variable_5,5,8,"0");;
gap> homalg_variable_6197 = homalg_variable_6199;
false
gap> homalg_variable_6200 := SIH_BasisOfColumnModule(homalg_variable_6192);;
gap> SI_ncols(homalg_variable_6200);
9
gap> homalg_variable_6201 := SI_matrix(homalg_variable_5,5,9,"0");;
gap> homalg_variable_6200 = homalg_variable_6201;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6197);; homalg_variable_6202 := homalg_variable_l[1];; homalg_variable_6203 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6202);
9
gap> homalg_variable_6204 := SI_matrix(homalg_variable_5,5,9,"0");;
gap> homalg_variable_6202 = homalg_variable_6204;
false
gap> SI_nrows(homalg_variable_6203);
8
gap> homalg_variable_6205 := homalg_variable_6197 * homalg_variable_6203;;
gap> homalg_variable_6202 = homalg_variable_6205;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6200,homalg_variable_6202);; homalg_variable_6206 := homalg_variable_l[1];; homalg_variable_6207 := homalg_variable_l[2];;
gap> homalg_variable_6208 := SI_matrix(homalg_variable_5,5,9,"0");;
gap> homalg_variable_6206 = homalg_variable_6208;
true
gap> homalg_variable_6209 := homalg_variable_6202 * homalg_variable_6207;;
gap> homalg_variable_6210 := homalg_variable_6200 + homalg_variable_6209;;
gap> homalg_variable_6206 = homalg_variable_6210;
true
gap> homalg_variable_6211 := SIH_DecideZeroColumns(homalg_variable_6200,homalg_variable_6202);;
gap> homalg_variable_6212 := SI_matrix(homalg_variable_5,5,9,"0");;
gap> homalg_variable_6211 = homalg_variable_6212;
true
gap> homalg_variable_6213 := homalg_variable_6207 * (homalg_variable_8);;
gap> homalg_variable_6214 := homalg_variable_6203 * homalg_variable_6213;;
gap> homalg_variable_6215 := homalg_variable_6197 * homalg_variable_6214;;
gap> homalg_variable_6215 = homalg_variable_6200;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6197,homalg_variable_6200);; homalg_variable_6216 := homalg_variable_l[1];; homalg_variable_6217 := homalg_variable_l[2];;
gap> homalg_variable_6218 := SI_matrix(homalg_variable_5,5,8,"0");;
gap> homalg_variable_6216 = homalg_variable_6218;
true
gap> homalg_variable_6219 := homalg_variable_6200 * homalg_variable_6217;;
gap> homalg_variable_6220 := homalg_variable_6197 + homalg_variable_6219;;
gap> homalg_variable_6216 = homalg_variable_6220;
true
gap> homalg_variable_6221 := SIH_DecideZeroColumns(homalg_variable_6197,homalg_variable_6200);;
gap> homalg_variable_6222 := SI_matrix(homalg_variable_5,5,8,"0");;
gap> homalg_variable_6221 = homalg_variable_6222;
true
gap> homalg_variable_6223 := homalg_variable_6217 * (homalg_variable_8);;
gap> homalg_variable_6224 := homalg_variable_6200 * homalg_variable_6223;;
gap> homalg_variable_6224 = homalg_variable_6197;
true
gap> homalg_variable_6226 := SIH_UnionOfRows(homalg_variable_5056,homalg_variable_6154);;
gap> homalg_variable_6227 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_6228 := SIH_UnionOfRows(homalg_variable_6227,homalg_variable_6077);;
gap> homalg_variable_6229 := SIH_UnionOfColumns(homalg_variable_6226,homalg_variable_6228);;
gap> homalg_variable_6225 := SIH_BasisOfColumnModule(homalg_variable_6229);;
gap> SI_ncols(homalg_variable_6225);
9
gap> homalg_variable_6230 := SI_matrix(homalg_variable_5,5,9,"0");;
gap> homalg_variable_6225 = homalg_variable_6230;
false
gap> homalg_variable_6225 = homalg_variable_6229;
false
gap> homalg_variable_6231 := SIH_DecideZeroColumns(homalg_variable_6197,homalg_variable_6225);;
gap> homalg_variable_6232 := SI_matrix(homalg_variable_5,5,8,"0");;
gap> homalg_variable_6231 = homalg_variable_6232;
true
gap> homalg_variable_6233 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5190);;
gap> SI_ncols(homalg_variable_6233);
1
gap> homalg_variable_6234 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_6233 = homalg_variable_6234;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_6233,[ 0 ]);
[  ]
gap> SIH_ZeroColumns(homalg_variable_5190);
[  ]
gap> homalg_variable_6235 := homalg_variable_5190 * homalg_variable_6233;;
gap> homalg_variable_6236 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_6235 = homalg_variable_6236;
true
gap> homalg_variable_6237 := SIH_BasisOfColumnModule(homalg_variable_6233);;
gap> SI_ncols(homalg_variable_6237);
1
gap> homalg_variable_6238 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_6237 = homalg_variable_6238;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6233);; homalg_variable_6239 := homalg_variable_l[1];; homalg_variable_6240 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6239);
1
gap> homalg_variable_6241 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_6239 = homalg_variable_6241;
false
gap> SI_nrows(homalg_variable_6240);
1
gap> homalg_variable_6242 := homalg_variable_6233 * homalg_variable_6240;;
gap> homalg_variable_6239 = homalg_variable_6242;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6237,homalg_variable_6239);; homalg_variable_6243 := homalg_variable_l[1];; homalg_variable_6244 := homalg_variable_l[2];;
gap> homalg_variable_6245 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_6243 = homalg_variable_6245;
true
gap> homalg_variable_6246 := homalg_variable_6239 * homalg_variable_6244;;
gap> homalg_variable_6247 := homalg_variable_6237 + homalg_variable_6246;;
gap> homalg_variable_6243 = homalg_variable_6247;
true
gap> homalg_variable_6248 := SIH_DecideZeroColumns(homalg_variable_6237,homalg_variable_6239);;
gap> homalg_variable_6249 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_6248 = homalg_variable_6249;
true
gap> homalg_variable_6250 := homalg_variable_6244 * (homalg_variable_8);;
gap> homalg_variable_6251 := homalg_variable_6240 * homalg_variable_6250;;
gap> homalg_variable_6252 := homalg_variable_6233 * homalg_variable_6251;;
gap> homalg_variable_6252 = homalg_variable_6237;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6233,homalg_variable_6237);; homalg_variable_6253 := homalg_variable_l[1];; homalg_variable_6254 := homalg_variable_l[2];;
gap> homalg_variable_6255 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_6253 = homalg_variable_6255;
true
gap> homalg_variable_6256 := homalg_variable_6237 * homalg_variable_6254;;
gap> homalg_variable_6257 := homalg_variable_6233 + homalg_variable_6256;;
gap> homalg_variable_6253 = homalg_variable_6257;
true
gap> homalg_variable_6258 := SIH_DecideZeroColumns(homalg_variable_6233,homalg_variable_6237);;
gap> homalg_variable_6259 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_6258 = homalg_variable_6259;
true
gap> homalg_variable_6260 := homalg_variable_6254 * (homalg_variable_8);;
gap> homalg_variable_6261 := homalg_variable_6237 * homalg_variable_6260;;
gap> homalg_variable_6261 = homalg_variable_6233;
true
gap> homalg_variable_6237 = homalg_variable_6233;
true
gap> homalg_variable_6263 := homalg_variable_5288 * homalg_variable_6158;;
gap> homalg_variable_6264 := homalg_variable_5288 * homalg_variable_6113;;
gap> homalg_variable_6265 := homalg_variable_5288 * homalg_variable_6114;;
gap> homalg_variable_6266 := SIH_UnionOfColumns(homalg_variable_6264,homalg_variable_6265);;
gap> homalg_variable_6267 := SIH_UnionOfColumns(homalg_variable_6263,homalg_variable_6266);;
gap> homalg_variable_6262 := SIH_DecideZeroColumns(homalg_variable_6267,homalg_variable_10);;
gap> homalg_variable_6268 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_6262 = homalg_variable_6268;
false
gap> homalg_variable_6269 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_6263 = homalg_variable_6269;
false
gap> homalg_variable_6270 := SIH_UnionOfColumns(homalg_variable_6262,homalg_variable_10);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6270);; homalg_variable_6271 := homalg_variable_l[1];; homalg_variable_6272 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6271);
4
gap> homalg_variable_6273 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_6271 = homalg_variable_6273;
false
gap> SI_nrows(homalg_variable_6272);
11
gap> homalg_variable_6274 := SIH_Submatrix(homalg_variable_6272,[ 1, 2, 3, 4, 5 ],[1..4]);;
gap> homalg_variable_6275 := homalg_variable_6262 * homalg_variable_6274;;
gap> homalg_variable_6276 := SIH_Submatrix(homalg_variable_6272,[ 6, 7, 8, 9, 10, 11 ],[1..4]);;
gap> homalg_variable_6277 := homalg_variable_10 * homalg_variable_6276;;
gap> homalg_variable_6278 := homalg_variable_6275 + homalg_variable_6277;;
gap> homalg_variable_6271 = homalg_variable_6278;
true
gap> homalg_variable_6280 := homalg_variable_5250 * homalg_variable_5190;;
gap> homalg_variable_6279 := SIH_DecideZeroColumns(homalg_variable_6280,homalg_variable_10);;
gap> homalg_variable_6281 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_6279 = homalg_variable_6281;
false
gap> homalg_variable_6282 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_6280 = homalg_variable_6282;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6279,homalg_variable_6271);; homalg_variable_6283 := homalg_variable_l[1];; homalg_variable_6284 := homalg_variable_l[2];;
gap> homalg_variable_6285 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_6283 = homalg_variable_6285;
true
gap> homalg_variable_6286 := homalg_variable_6271 * homalg_variable_6284;;
gap> homalg_variable_6287 := homalg_variable_6279 + homalg_variable_6286;;
gap> homalg_variable_6283 = homalg_variable_6287;
true
gap> homalg_variable_6288 := SIH_DecideZeroColumns(homalg_variable_6279,homalg_variable_6271);;
gap> homalg_variable_6289 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_6288 = homalg_variable_6289;
true
gap> homalg_variable_6291 := SIH_Submatrix(homalg_variable_6272,[ 1, 2, 3 ],[1..4]);;
gap> homalg_variable_6292 := homalg_variable_6284 * (homalg_variable_8);;
gap> homalg_variable_6293 := homalg_variable_6291 * homalg_variable_6292;;
gap> homalg_variable_6294 := homalg_variable_6263 * homalg_variable_6293;;
gap> homalg_variable_6295 := SIH_Submatrix(homalg_variable_6272,[ 4 ],[1..4]);;
gap> homalg_variable_6296 := homalg_variable_6295 * homalg_variable_6292;;
gap> homalg_variable_6297 := homalg_variable_6264 * homalg_variable_6296;;
gap> homalg_variable_6298 := SIH_Submatrix(homalg_variable_6272,[ 5 ],[1..4]);;
gap> homalg_variable_6299 := homalg_variable_6298 * homalg_variable_6292;;
gap> homalg_variable_6300 := homalg_variable_6265 * homalg_variable_6299;;
gap> homalg_variable_6301 := homalg_variable_6297 + homalg_variable_6300;;
gap> homalg_variable_6302 := homalg_variable_6294 + homalg_variable_6301;;
gap> homalg_variable_6303 := homalg_variable_6302 - homalg_variable_6280;;
gap> homalg_variable_6290 := SIH_DecideZeroColumns(homalg_variable_6303,homalg_variable_10);;
gap> homalg_variable_6304 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_6290 = homalg_variable_6304;
true
gap> homalg_variable_6306 := SIH_Submatrix(homalg_variable_6272,[ 1, 2, 3, 4, 5 ],[1..4]);;
gap> homalg_variable_6307 := homalg_variable_6306 * homalg_variable_6292;;
gap> homalg_variable_6308 := homalg_variable_6307 * homalg_variable_6237;;
gap> homalg_variable_6305 := SIH_DecideZeroColumns(homalg_variable_6308,homalg_variable_6225);;
gap> homalg_variable_6309 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_6305 = homalg_variable_6309;
true
gap> homalg_variable_6310 := SIH_DecideZeroColumns(homalg_variable_6307,homalg_variable_6225);;
gap> homalg_variable_6311 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_6310 = homalg_variable_6311;
false
gap> homalg_variable_6312 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_6307 = homalg_variable_6312;
false
gap> homalg_variable_6314 := homalg_variable_5250 * (homalg_variable_8);;
gap> homalg_variable_6315 := homalg_variable_6314 * homalg_variable_5190;;
gap> homalg_variable_6316 := SIH_Submatrix(homalg_variable_6310,[ 1, 2, 3 ],[1..3]);;
gap> homalg_variable_6317 := homalg_variable_6263 * homalg_variable_6316;;
gap> homalg_variable_6318 := SIH_Submatrix(homalg_variable_6310,[ 4 ],[1..3]);;
gap> homalg_variable_6319 := homalg_variable_6264 * homalg_variable_6318;;
gap> homalg_variable_6320 := SIH_Submatrix(homalg_variable_6310,[ 5 ],[1..3]);;
gap> homalg_variable_6321 := homalg_variable_6265 * homalg_variable_6320;;
gap> homalg_variable_6322 := homalg_variable_6319 + homalg_variable_6321;;
gap> homalg_variable_6323 := homalg_variable_6317 + homalg_variable_6322;;
gap> homalg_variable_6324 := homalg_variable_6315 + homalg_variable_6323;;
gap> homalg_variable_6313 := SIH_DecideZeroColumns(homalg_variable_6324,homalg_variable_10);;
gap> homalg_variable_6325 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_6313 = homalg_variable_6325;
true
gap> homalg_variable_6327 := homalg_variable_6314 * homalg_variable_5190;;
gap> homalg_variable_6328 := SI_matrix(homalg_variable_5,5,9,"0");;
gap> homalg_variable_6329 := SIH_UnionOfColumns(homalg_variable_6327,homalg_variable_6328);;
gap> homalg_variable_6330 := SIH_Submatrix(homalg_variable_6310,[ 1, 2, 3 ],[1..3]);;
gap> homalg_variable_6331 := homalg_variable_6263 * homalg_variable_6330;;
gap> homalg_variable_6332 := homalg_variable_6263 * homalg_variable_5056;;
gap> homalg_variable_6333 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_6334 := SIH_UnionOfColumns(homalg_variable_6332,homalg_variable_6333);;
gap> homalg_variable_6335 := SIH_UnionOfColumns(homalg_variable_6331,homalg_variable_6334);;
gap> homalg_variable_6336 := SIH_Submatrix(homalg_variable_6310,[ 4 ],[1..3]);;
gap> homalg_variable_6337 := homalg_variable_6264 * homalg_variable_6336;;
gap> homalg_variable_6338 := SIH_Submatrix(homalg_variable_6154,[ 1 ],[1..4]);;
gap> homalg_variable_6339 := homalg_variable_6264 * homalg_variable_6338;;
gap> homalg_variable_6340 := homalg_variable_6264 * homalg_variable_3037;;
gap> homalg_variable_6341 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_6342 := SIH_UnionOfColumns(homalg_variable_6340,homalg_variable_6341);;
gap> homalg_variable_6343 := SIH_UnionOfColumns(homalg_variable_6339,homalg_variable_6342);;
gap> homalg_variable_6344 := SIH_UnionOfColumns(homalg_variable_6337,homalg_variable_6343);;
gap> homalg_variable_6345 := SIH_Submatrix(homalg_variable_6310,[ 5 ],[1..3]);;
gap> homalg_variable_6346 := homalg_variable_6265 * homalg_variable_6345;;
gap> homalg_variable_6347 := SIH_Submatrix(homalg_variable_6154,[ 2 ],[1..4]);;
gap> homalg_variable_6348 := homalg_variable_6265 * homalg_variable_6347;;
gap> homalg_variable_6349 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_6350 := homalg_variable_6265 * homalg_variable_2959;;
gap> homalg_variable_6351 := SIH_UnionOfColumns(homalg_variable_6349,homalg_variable_6350);;
gap> homalg_variable_6352 := SIH_UnionOfColumns(homalg_variable_6348,homalg_variable_6351);;
gap> homalg_variable_6353 := SIH_UnionOfColumns(homalg_variable_6346,homalg_variable_6352);;
gap> homalg_variable_6354 := homalg_variable_6344 + homalg_variable_6353;;
gap> homalg_variable_6355 := homalg_variable_6335 + homalg_variable_6354;;
gap> homalg_variable_6356 := homalg_variable_6329 + homalg_variable_6355;;
gap> homalg_variable_6326 := SIH_DecideZeroColumns(homalg_variable_6356,homalg_variable_10);;
gap> homalg_variable_6357 := SI_matrix(homalg_variable_5,5,12,"0");;
gap> homalg_variable_6326 = homalg_variable_6357;
true
gap> homalg_variable_6359 := SIH_UnionOfColumns(homalg_variable_6314,homalg_variable_6267);;
gap> homalg_variable_6360 := SIH_UnionOfColumns(homalg_variable_6359,homalg_variable_10);;
gap> homalg_variable_6358 := SIH_BasisOfColumnModule(homalg_variable_6360);;
gap> SI_ncols(homalg_variable_6358);
5
gap> homalg_variable_6361 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_6358 = homalg_variable_6361;
false
gap> homalg_variable_6362 := SIH_DecideZeroColumns(homalg_variable_18,homalg_variable_6358);;
gap> homalg_variable_6363 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_6362 = homalg_variable_6363;
true
gap> homalg_variable_6364 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_6359,homalg_variable_10);;
gap> SI_ncols(homalg_variable_6364);
12
gap> homalg_variable_6365 := SI_matrix(homalg_variable_5,9,12,"0");;
gap> homalg_variable_6364 = homalg_variable_6365;
false
gap> homalg_variable_6366 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_6364);;
gap> SI_ncols(homalg_variable_6366);
6
gap> homalg_variable_6367 := SI_matrix(homalg_variable_5,12,6,"0");;
gap> homalg_variable_6366 = homalg_variable_6367;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_6366,[ 0 ]);
[ [ 4, 5 ] ]
gap> homalg_variable_6369 := SIH_Submatrix(homalg_variable_6364,[1..9],[ 1, 2, 3, 4, 6, 7, 8, 9, 10, 11, 12 ]);;
gap> homalg_variable_6368 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_6369);;
gap> SI_ncols(homalg_variable_6368);
5
gap> homalg_variable_6370 := SI_matrix(homalg_variable_5,11,5,"0");;
gap> homalg_variable_6368 = homalg_variable_6370;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_6368,[ 0 ]);
[ [ 3, 3 ] ]
gap> homalg_variable_6372 := SIH_Submatrix(homalg_variable_6369,[1..9],[ 1, 2, 4, 5, 6, 7, 8, 9, 10, 11 ]);;
gap> homalg_variable_6371 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_6372);;
gap> SI_ncols(homalg_variable_6371);
4
gap> homalg_variable_6373 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_6371 = homalg_variable_6373;
false
gap> SIH_GetRowIndependentUnitPositions(homalg_variable_6371,[ 0 ]);
[  ]
gap> homalg_variable_6374 := SI_matrix(homalg_variable_5,9,10,"0");;
gap> homalg_variable_6372 = homalg_variable_6374;
false
gap> homalg_variable_6375 := SIH_BasisOfColumnModule(homalg_variable_6364);;
gap> SI_ncols(homalg_variable_6375);
12
gap> homalg_variable_6376 := SI_matrix(homalg_variable_5,9,12,"0");;
gap> homalg_variable_6375 = homalg_variable_6376;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6372);; homalg_variable_6377 := homalg_variable_l[1];; homalg_variable_6378 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6377);
12
gap> homalg_variable_6379 := SI_matrix(homalg_variable_5,9,12,"0");;
gap> homalg_variable_6377 = homalg_variable_6379;
false
gap> SI_nrows(homalg_variable_6378);
10
gap> homalg_variable_6380 := homalg_variable_6372 * homalg_variable_6378;;
gap> homalg_variable_6377 = homalg_variable_6380;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6375,homalg_variable_6377);; homalg_variable_6381 := homalg_variable_l[1];; homalg_variable_6382 := homalg_variable_l[2];;
gap> homalg_variable_6383 := SI_matrix(homalg_variable_5,9,12,"0");;
gap> homalg_variable_6381 = homalg_variable_6383;
true
gap> homalg_variable_6384 := homalg_variable_6377 * homalg_variable_6382;;
gap> homalg_variable_6385 := homalg_variable_6375 + homalg_variable_6384;;
gap> homalg_variable_6381 = homalg_variable_6385;
true
gap> homalg_variable_6386 := SIH_DecideZeroColumns(homalg_variable_6375,homalg_variable_6377);;
gap> homalg_variable_6387 := SI_matrix(homalg_variable_5,9,12,"0");;
gap> homalg_variable_6386 = homalg_variable_6387;
true
gap> homalg_variable_6388 := homalg_variable_6382 * (homalg_variable_8);;
gap> homalg_variable_6389 := homalg_variable_6378 * homalg_variable_6388;;
gap> homalg_variable_6390 := homalg_variable_6372 * homalg_variable_6389;;
gap> homalg_variable_6390 = homalg_variable_6375;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6372,homalg_variable_6375);; homalg_variable_6391 := homalg_variable_l[1];; homalg_variable_6392 := homalg_variable_l[2];;
gap> homalg_variable_6393 := SI_matrix(homalg_variable_5,9,10,"0");;
gap> homalg_variable_6391 = homalg_variable_6393;
true
gap> homalg_variable_6394 := homalg_variable_6375 * homalg_variable_6392;;
gap> homalg_variable_6395 := homalg_variable_6372 + homalg_variable_6394;;
gap> homalg_variable_6391 = homalg_variable_6395;
true
gap> homalg_variable_6396 := SIH_DecideZeroColumns(homalg_variable_6372,homalg_variable_6375);;
gap> homalg_variable_6397 := SI_matrix(homalg_variable_5,9,10,"0");;
gap> homalg_variable_6396 = homalg_variable_6397;
true
gap> homalg_variable_6398 := homalg_variable_6392 * (homalg_variable_8);;
gap> homalg_variable_6399 := homalg_variable_6375 * homalg_variable_6398;;
gap> homalg_variable_6399 = homalg_variable_6372;
true
gap> homalg_variable_6401 := SIH_UnionOfRows(homalg_variable_5190,homalg_variable_6310);;
gap> homalg_variable_6402 := SI_matrix(homalg_variable_5,4,9,"0");;
gap> homalg_variable_6403 := SIH_UnionOfRows(homalg_variable_6402,homalg_variable_6229);;
gap> homalg_variable_6404 := SIH_UnionOfColumns(homalg_variable_6401,homalg_variable_6403);;
gap> homalg_variable_6400 := SIH_BasisOfColumnModule(homalg_variable_6404);;
gap> SI_ncols(homalg_variable_6400);
12
gap> homalg_variable_6405 := SI_matrix(homalg_variable_5,9,12,"0");;
gap> homalg_variable_6400 = homalg_variable_6405;
false
gap> homalg_variable_6400 = homalg_variable_6404;
false
gap> homalg_variable_6406 := SIH_DecideZeroColumns(homalg_variable_6372,homalg_variable_6400);;
gap> homalg_variable_6407 := SI_matrix(homalg_variable_5,9,10,"0");;
gap> homalg_variable_6406 = homalg_variable_6407;
true
