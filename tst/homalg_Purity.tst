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
> InstallGlobalFunction( SIH_BasisOfColumnModule,
>  function( M )
>    
>    return SI_matrix( SI_std( M ) );
>    
> end );
> InstallGlobalFunction( SIH_BasisOfRowModule,
>  function( M )
>    
>    return SI_transpose( SIH_BasisOfColumnModule( SI_transpose( M ) ) );
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
>     N := Flat( List( row_range, r -> List( col_range, c -> SI_\[( M , r, c ) ) ) );
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
> fi;
gap> homalg_variable_1 := SI_ring( 0, [ "dummy_variable" ] );;
gap> homalg_variable_2 := Zero( homalg_variable_1 );;
gap> homalg_variable_3 := One( homalg_variable_1 );;
gap> homalg_variable_4 := -One( homalg_variable_1 );;
gap> homalg_variable_5 := SI_ring(0,[ "x", "y", "z" ]);;
gap> homalg_variable_6 := Zero( homalg_variable_5 );;
gap> homalg_variable_7 := One( homalg_variable_5 );;
gap> homalg_variable_8 := -One( homalg_variable_5 );;
gap> homalg_variable_9 := SI_transpose( SI_matrix(homalg_variable_5,6,5,"xy,yz,z,0,0,x3z,x2z2,0,xz2,-z2,x4,x3z,0,x2z,-xz,0,0,xy,-y2,x2-1,0,0,x2z,-xyz,yz,0,0,x2y-x2,-xy2+xy,y2-y") );;
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
gap> homalg_variable_14 := SI_\[(homalg_variable_12,6,1);;
gap> SI_deg( homalg_variable_14 );
-1
gap> homalg_variable_15 := SI_\[(homalg_variable_12,5,1);;
gap> SI_deg( homalg_variable_15 );
-1
gap> homalg_variable_16 := SI_\[(homalg_variable_12,4,1);;
gap> SI_deg( homalg_variable_16 );
1
gap> homalg_variable_17 := SI_\[(homalg_variable_12,3,1);;
gap> SI_deg( homalg_variable_17 );
1
gap> homalg_variable_18 := SI_\[(homalg_variable_12,2,1);;
gap> SI_deg( homalg_variable_18 );
-1
gap> homalg_variable_19 := SI_\[(homalg_variable_12,1,1);;
gap> SI_deg( homalg_variable_19 );
-1
gap> homalg_variable_20 := SI_\[(homalg_variable_12,6,2);;
gap> SI_deg( homalg_variable_20 );
1
gap> homalg_variable_21 := SI_\[(homalg_variable_12,5,2);;
gap> SI_deg( homalg_variable_21 );
1
gap> homalg_variable_22 := SI_\[(homalg_variable_12,4,2);;
gap> SI_deg( homalg_variable_22 );
-1
gap> homalg_variable_23 := SI_\[(homalg_variable_12,3,2);;
gap> SI_deg( homalg_variable_23 );
-1
gap> homalg_variable_24 := SI_\[(homalg_variable_12,2,2);;
gap> SI_deg( homalg_variable_24 );
-1
gap> homalg_variable_25 := SI_\[(homalg_variable_12,1,2);;
gap> SI_deg( homalg_variable_25 );
-1
gap> homalg_variable_26 := SI_\[(homalg_variable_12,6,3);;
gap> SI_deg( homalg_variable_26 );
-1
gap> homalg_variable_27 := SI_\[(homalg_variable_12,5,3);;
gap> SI_deg( homalg_variable_27 );
1
gap> homalg_variable_28 := SI_\[(homalg_variable_12,4,3);;
gap> SI_deg( homalg_variable_28 );
-1
gap> homalg_variable_29 := SI_\[(homalg_variable_12,3,3);;
gap> SI_deg( homalg_variable_29 );
1
gap> homalg_variable_30 := SI_\[(homalg_variable_12,2,3);;
gap> SI_deg( homalg_variable_30 );
-1
gap> homalg_variable_31 := SI_\[(homalg_variable_12,1,3);;
gap> SI_deg( homalg_variable_31 );
3
gap> homalg_variable_32 := SI_\[(homalg_variable_12,6,4);;
gap> SI_deg( homalg_variable_32 );
1
gap> homalg_variable_33 := SI_\[(homalg_variable_12,5,4);;
gap> SI_deg( homalg_variable_33 );
-1
gap> homalg_variable_34 := SI_\[(homalg_variable_12,4,4);;
gap> SI_deg( homalg_variable_34 );
-1
gap> homalg_variable_35 := SI_\[(homalg_variable_12,3,4);;
gap> SI_deg( homalg_variable_35 );
1
gap> homalg_variable_36 := SI_\[(homalg_variable_12,2,4);;
gap> SI_deg( homalg_variable_36 );
-1
gap> homalg_variable_37 := SI_\[(homalg_variable_12,1,4);;
gap> SI_deg( homalg_variable_37 );
3
gap> homalg_variable_39 := SI_transpose(homalg_variable_10);;
gap> homalg_variable_38 := SIH_BasisOfRowModule(homalg_variable_39);;
gap> SI_nrows(homalg_variable_38);
6
gap> homalg_variable_40 := SI_matrix(homalg_variable_5,6,5,"0");;
gap> homalg_variable_38 = homalg_variable_40;
false
gap> homalg_variable_38 = homalg_variable_39;
true
gap> homalg_variable_42 := SI_matrix( SI_freemodule( homalg_variable_5,5 ) );;
gap> homalg_variable_41 := SIH_DecideZeroRows(homalg_variable_42,homalg_variable_38);;
gap> homalg_variable_43 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_41 = homalg_variable_43;
false
gap> SIH_ZeroRows(homalg_variable_41);
[  ]
gap> homalg_variable_41 = homalg_variable_42;
true
gap> homalg_variable_44 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_38);;
gap> SI_nrows(homalg_variable_44);
4
gap> homalg_variable_45 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_44 = homalg_variable_45;
false
gap> homalg_variable_46 := SI_\[(homalg_variable_44,1,6);;
gap> SI_deg( homalg_variable_46 );
-1
gap> homalg_variable_47 := SI_\[(homalg_variable_44,1,5);;
gap> SI_deg( homalg_variable_47 );
-1
gap> homalg_variable_48 := SI_\[(homalg_variable_44,1,4);;
gap> SI_deg( homalg_variable_48 );
1
gap> homalg_variable_49 := SI_\[(homalg_variable_44,1,3);;
gap> SI_deg( homalg_variable_49 );
1
gap> homalg_variable_50 := SI_\[(homalg_variable_44,1,2);;
gap> SI_deg( homalg_variable_50 );
-1
gap> homalg_variable_51 := SI_\[(homalg_variable_44,1,1);;
gap> SI_deg( homalg_variable_51 );
-1
gap> homalg_variable_52 := SI_\[(homalg_variable_44,2,6);;
gap> SI_deg( homalg_variable_52 );
1
gap> homalg_variable_53 := SI_\[(homalg_variable_44,2,5);;
gap> SI_deg( homalg_variable_53 );
1
gap> homalg_variable_54 := SI_\[(homalg_variable_44,2,4);;
gap> SI_deg( homalg_variable_54 );
-1
gap> homalg_variable_55 := SI_\[(homalg_variable_44,2,3);;
gap> SI_deg( homalg_variable_55 );
-1
gap> homalg_variable_56 := SI_\[(homalg_variable_44,2,2);;
gap> SI_deg( homalg_variable_56 );
-1
gap> homalg_variable_57 := SI_\[(homalg_variable_44,2,1);;
gap> SI_deg( homalg_variable_57 );
-1
gap> homalg_variable_58 := SI_\[(homalg_variable_44,3,6);;
gap> SI_deg( homalg_variable_58 );
-1
gap> homalg_variable_59 := SI_\[(homalg_variable_44,3,5);;
gap> SI_deg( homalg_variable_59 );
1
gap> homalg_variable_60 := SI_\[(homalg_variable_44,3,4);;
gap> SI_deg( homalg_variable_60 );
-1
gap> homalg_variable_61 := SI_\[(homalg_variable_44,3,3);;
gap> SI_deg( homalg_variable_61 );
1
gap> homalg_variable_62 := SI_\[(homalg_variable_44,3,2);;
gap> SI_deg( homalg_variable_62 );
-1
gap> homalg_variable_63 := SI_\[(homalg_variable_44,3,1);;
gap> SI_deg( homalg_variable_63 );
3
gap> homalg_variable_64 := SI_\[(homalg_variable_44,4,6);;
gap> SI_deg( homalg_variable_64 );
1
gap> homalg_variable_65 := SI_\[(homalg_variable_44,4,5);;
gap> SI_deg( homalg_variable_65 );
-1
gap> homalg_variable_66 := SI_\[(homalg_variable_44,4,4);;
gap> SI_deg( homalg_variable_66 );
-1
gap> homalg_variable_67 := SI_\[(homalg_variable_44,4,3);;
gap> SI_deg( homalg_variable_67 );
1
gap> homalg_variable_68 := SI_\[(homalg_variable_44,4,2);;
gap> SI_deg( homalg_variable_68 );
-1
gap> homalg_variable_69 := SI_\[(homalg_variable_44,4,1);;
gap> SI_deg( homalg_variable_69 );
3
gap> homalg_variable_70 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_10);;
gap> SI_nrows(homalg_variable_70);
2
gap> homalg_variable_71 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_70 = homalg_variable_71;
false
gap> homalg_variable_72 := homalg_variable_70 * homalg_variable_10;;
gap> homalg_variable_73 := SI_matrix(homalg_variable_5,2,6,"0");;
gap> homalg_variable_72 = homalg_variable_73;
true
gap> homalg_variable_74 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_70);;
gap> SI_ncols(homalg_variable_74);
4
gap> homalg_variable_75 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_74 = homalg_variable_75;
false
gap> homalg_variable_76 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_74);;
gap> SI_ncols(homalg_variable_76);
1
gap> homalg_variable_77 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_76 = homalg_variable_77;
false
gap> homalg_variable_78 := SI_\[(homalg_variable_76,4,1);;
gap> SI_deg( homalg_variable_78 );
1
gap> homalg_variable_79 := SI_\[(homalg_variable_76,3,1);;
gap> SI_deg( homalg_variable_79 );
1
gap> homalg_variable_80 := SI_\[(homalg_variable_76,2,1);;
gap> SI_deg( homalg_variable_80 );
1
gap> homalg_variable_81 := SI_\[(homalg_variable_76,1,1);;
gap> SI_deg( homalg_variable_81 );
-1
gap> homalg_variable_82 := SIH_BasisOfColumnModule(homalg_variable_74);;
gap> SI_ncols(homalg_variable_82);
4
gap> homalg_variable_83 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_82 = homalg_variable_83;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_74);; homalg_variable_84 := homalg_variable_l[1];; homalg_variable_85 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_84);
4
gap> homalg_variable_86 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_84 = homalg_variable_86;
false
gap> SI_nrows(homalg_variable_85);
4
gap> homalg_variable_87 := homalg_variable_74 * homalg_variable_85;;
gap> homalg_variable_84 = homalg_variable_87;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_82,homalg_variable_84);; homalg_variable_88 := homalg_variable_l[1];; homalg_variable_89 := homalg_variable_l[2];;
gap> homalg_variable_90 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_88 = homalg_variable_90;
true
gap> homalg_variable_91 := homalg_variable_84 * homalg_variable_89;;
gap> homalg_variable_92 := homalg_variable_82 + homalg_variable_91;;
gap> homalg_variable_88 = homalg_variable_92;
true
gap> homalg_variable_93 := SIH_DecideZeroColumns(homalg_variable_82,homalg_variable_84);;
gap> homalg_variable_94 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_93 = homalg_variable_94;
true
gap> homalg_variable_95 := homalg_variable_89 * (homalg_variable_8);;
gap> homalg_variable_96 := homalg_variable_85 * homalg_variable_95;;
gap> homalg_variable_97 := homalg_variable_74 * homalg_variable_96;;
gap> homalg_variable_97 = homalg_variable_82;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_74,homalg_variable_82);; homalg_variable_98 := homalg_variable_l[1];; homalg_variable_99 := homalg_variable_l[2];;
gap> homalg_variable_100 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_98 = homalg_variable_100;
true
gap> homalg_variable_101 := homalg_variable_82 * homalg_variable_99;;
gap> homalg_variable_102 := homalg_variable_74 + homalg_variable_101;;
gap> homalg_variable_98 = homalg_variable_102;
true
gap> homalg_variable_103 := SIH_DecideZeroColumns(homalg_variable_74,homalg_variable_82);;
gap> homalg_variable_104 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_103 = homalg_variable_104;
true
gap> homalg_variable_105 := homalg_variable_99 * (homalg_variable_8);;
gap> homalg_variable_106 := homalg_variable_82 * homalg_variable_105;;
gap> homalg_variable_106 = homalg_variable_74;
true
gap> homalg_variable_107 := SIH_DecideZeroColumns(homalg_variable_74,homalg_variable_10);;
gap> homalg_variable_108 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_107 = homalg_variable_108;
false
gap> SIH_ZeroColumns(homalg_variable_107);
[ 3 ]
gap> homalg_variable_110 := SIH_Submatrix(homalg_variable_107,[1..5],[ 1, 2, 4 ]);;
gap> homalg_variable_109 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_110,homalg_variable_10);;
gap> SI_ncols(homalg_variable_109);
6
gap> homalg_variable_111 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_109 = homalg_variable_111;
false
gap> homalg_variable_113 := homalg_variable_110 * homalg_variable_109;;
gap> homalg_variable_112 := SIH_DecideZeroColumns(homalg_variable_113,homalg_variable_10);;
gap> homalg_variable_114 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_112 = homalg_variable_114;
true
gap> homalg_variable_115 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_110,homalg_variable_10);;
gap> SI_ncols(homalg_variable_115);
6
gap> homalg_variable_116 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_115 = homalg_variable_116;
false
gap> homalg_variable_117 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_115);;
gap> SI_ncols(homalg_variable_117);
4
gap> homalg_variable_118 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_117 = homalg_variable_118;
false
gap> homalg_variable_119 := SI_\[(homalg_variable_117,6,1);;
gap> SI_deg( homalg_variable_119 );
-1
gap> homalg_variable_120 := SI_\[(homalg_variable_117,5,1);;
gap> SI_deg( homalg_variable_120 );
-1
gap> homalg_variable_121 := SI_\[(homalg_variable_117,4,1);;
gap> SI_deg( homalg_variable_121 );
1
gap> homalg_variable_122 := SI_\[(homalg_variable_117,3,1);;
gap> SI_deg( homalg_variable_122 );
1
gap> homalg_variable_123 := SI_\[(homalg_variable_117,2,1);;
gap> SI_deg( homalg_variable_123 );
-1
gap> homalg_variable_124 := SI_\[(homalg_variable_117,1,1);;
gap> SI_deg( homalg_variable_124 );
-1
gap> homalg_variable_125 := SI_\[(homalg_variable_117,6,2);;
gap> SI_deg( homalg_variable_125 );
-1
gap> homalg_variable_126 := SI_\[(homalg_variable_117,5,2);;
gap> SI_deg( homalg_variable_126 );
1
gap> homalg_variable_127 := SI_\[(homalg_variable_117,4,2);;
gap> SI_deg( homalg_variable_127 );
-1
gap> homalg_variable_128 := SI_\[(homalg_variable_117,3,2);;
gap> SI_deg( homalg_variable_128 );
-1
gap> homalg_variable_129 := SI_\[(homalg_variable_117,2,2);;
gap> SI_deg( homalg_variable_129 );
1
gap> homalg_variable_130 := SI_\[(homalg_variable_117,1,2);;
gap> SI_deg( homalg_variable_130 );
-1
gap> homalg_variable_131 := SI_\[(homalg_variable_117,6,3);;
gap> SI_deg( homalg_variable_131 );
-1
gap> homalg_variable_132 := SI_\[(homalg_variable_117,5,3);;
gap> SI_deg( homalg_variable_132 );
-1
gap> homalg_variable_133 := SI_\[(homalg_variable_117,4,3);;
gap> SI_deg( homalg_variable_133 );
-1
gap> homalg_variable_134 := SI_\[(homalg_variable_117,3,3);;
gap> SI_deg( homalg_variable_134 );
1
gap> homalg_variable_135 := SI_\[(homalg_variable_117,2,3);;
gap> SI_deg( homalg_variable_135 );
1
gap> homalg_variable_136 := SI_\[(homalg_variable_117,1,3);;
gap> SI_deg( homalg_variable_136 );
2
gap> homalg_variable_137 := SI_\[(homalg_variable_117,6,4);;
gap> SI_deg( homalg_variable_137 );
-1
gap> homalg_variable_138 := SI_\[(homalg_variable_117,5,4);;
gap> SI_deg( homalg_variable_138 );
1
gap> homalg_variable_139 := SI_\[(homalg_variable_117,4,4);;
gap> SI_deg( homalg_variable_139 );
-1
gap> homalg_variable_140 := SI_\[(homalg_variable_117,3,4);;
gap> SI_deg( homalg_variable_140 );
1
gap> homalg_variable_141 := SI_\[(homalg_variable_117,2,4);;
gap> SI_deg( homalg_variable_141 );
-1
gap> homalg_variable_142 := SI_\[(homalg_variable_117,1,4);;
gap> SI_deg( homalg_variable_142 );
2
gap> homalg_variable_143 := SIH_BasisOfColumnModule(homalg_variable_115);;
gap> SI_ncols(homalg_variable_143);
6
gap> homalg_variable_144 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_143 = homalg_variable_144;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_115);; homalg_variable_145 := homalg_variable_l[1];; homalg_variable_146 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_145);
6
gap> homalg_variable_147 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_145 = homalg_variable_147;
false
gap> SI_nrows(homalg_variable_146);
6
gap> homalg_variable_148 := homalg_variable_115 * homalg_variable_146;;
gap> homalg_variable_145 = homalg_variable_148;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_143,homalg_variable_145);; homalg_variable_149 := homalg_variable_l[1];; homalg_variable_150 := homalg_variable_l[2];;
gap> homalg_variable_151 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_149 = homalg_variable_151;
true
gap> homalg_variable_152 := homalg_variable_145 * homalg_variable_150;;
gap> homalg_variable_153 := homalg_variable_143 + homalg_variable_152;;
gap> homalg_variable_149 = homalg_variable_153;
true
gap> homalg_variable_154 := SIH_DecideZeroColumns(homalg_variable_143,homalg_variable_145);;
gap> homalg_variable_155 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_154 = homalg_variable_155;
true
gap> homalg_variable_156 := homalg_variable_150 * (homalg_variable_8);;
gap> homalg_variable_157 := homalg_variable_146 * homalg_variable_156;;
gap> homalg_variable_158 := homalg_variable_115 * homalg_variable_157;;
gap> homalg_variable_158 = homalg_variable_143;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_115,homalg_variable_143);; homalg_variable_159 := homalg_variable_l[1];; homalg_variable_160 := homalg_variable_l[2];;
gap> homalg_variable_161 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_159 = homalg_variable_161;
true
gap> homalg_variable_162 := homalg_variable_143 * homalg_variable_160;;
gap> homalg_variable_163 := homalg_variable_115 + homalg_variable_162;;
gap> homalg_variable_159 = homalg_variable_163;
true
gap> homalg_variable_164 := SIH_DecideZeroColumns(homalg_variable_115,homalg_variable_143);;
gap> homalg_variable_165 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_164 = homalg_variable_165;
true
gap> homalg_variable_166 := homalg_variable_160 * (homalg_variable_8);;
gap> homalg_variable_167 := homalg_variable_143 * homalg_variable_166;;
gap> homalg_variable_167 = homalg_variable_115;
true
gap> homalg_variable_168 := SIH_BasisOfColumnModule(homalg_variable_109);;
gap> SI_ncols(homalg_variable_168);
6
gap> homalg_variable_169 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_168 = homalg_variable_169;
false
gap> homalg_variable_168 = homalg_variable_109;
true
gap> homalg_variable_170 := SIH_DecideZeroColumns(homalg_variable_115,homalg_variable_168);;
gap> homalg_variable_171 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_170 = homalg_variable_171;
true
gap> homalg_variable_172 := SI_transpose( SI_matrix(homalg_variable_5,5,5,"x2+y-z,xz-z,0,z,-z,x-1,x+y-1,-y,-1,0,x3+y,x2z+y,x2+y2+y,-xy+xz+y,xy-z,x,x,x,y2+x,1,0,0,-xy,y2,1") );;
gap> homalg_variable_173 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_12);;
gap> SI_ncols(homalg_variable_173);
1
gap> homalg_variable_174 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_173 = homalg_variable_174;
false
gap> homalg_variable_175 := SI_\[(homalg_variable_173,4,1);;
gap> SI_deg( homalg_variable_175 );
1
gap> homalg_variable_176 := SI_\[(homalg_variable_173,3,1);;
gap> SI_deg( homalg_variable_176 );
1
gap> homalg_variable_177 := SI_\[(homalg_variable_173,2,1);;
gap> SI_deg( homalg_variable_177 );
1
gap> homalg_variable_178 := SI_\[(homalg_variable_173,1,1);;
gap> SI_deg( homalg_variable_178 );
-1
gap> homalg_variable_179 := SIH_BasisOfColumnModule(homalg_variable_12);;
gap> SI_ncols(homalg_variable_179);
4
gap> homalg_variable_180 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_179 = homalg_variable_180;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_12);; homalg_variable_181 := homalg_variable_l[1];; homalg_variable_182 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_181);
4
gap> homalg_variable_183 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_181 = homalg_variable_183;
false
gap> SI_nrows(homalg_variable_182);
4
gap> homalg_variable_184 := homalg_variable_12 * homalg_variable_182;;
gap> homalg_variable_181 = homalg_variable_184;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_179,homalg_variable_181);; homalg_variable_185 := homalg_variable_l[1];; homalg_variable_186 := homalg_variable_l[2];;
gap> homalg_variable_187 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_185 = homalg_variable_187;
true
gap> homalg_variable_188 := homalg_variable_181 * homalg_variable_186;;
gap> homalg_variable_189 := homalg_variable_179 + homalg_variable_188;;
gap> homalg_variable_185 = homalg_variable_189;
true
gap> homalg_variable_190 := SIH_DecideZeroColumns(homalg_variable_179,homalg_variable_181);;
gap> homalg_variable_191 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_190 = homalg_variable_191;
true
gap> homalg_variable_192 := homalg_variable_186 * (homalg_variable_8);;
gap> homalg_variable_193 := homalg_variable_182 * homalg_variable_192;;
gap> homalg_variable_194 := homalg_variable_12 * homalg_variable_193;;
gap> homalg_variable_194 = homalg_variable_179;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_12,homalg_variable_179);; homalg_variable_195 := homalg_variable_l[1];; homalg_variable_196 := homalg_variable_l[2];;
gap> homalg_variable_197 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_195 = homalg_variable_197;
true
gap> homalg_variable_198 := homalg_variable_179 * homalg_variable_196;;
gap> homalg_variable_199 := homalg_variable_12 + homalg_variable_198;;
gap> homalg_variable_195 = homalg_variable_199;
true
gap> homalg_variable_200 := SIH_DecideZeroColumns(homalg_variable_12,homalg_variable_179);;
gap> homalg_variable_201 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_200 = homalg_variable_201;
true
gap> homalg_variable_202 := homalg_variable_196 * (homalg_variable_8);;
gap> homalg_variable_203 := homalg_variable_179 * homalg_variable_202;;
gap> homalg_variable_203 = homalg_variable_12;
true
gap> homalg_variable_204 := SIH_BasisOfColumnModule(homalg_variable_173);;
gap> SI_ncols(homalg_variable_204);
1
gap> homalg_variable_205 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_204 = homalg_variable_205;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_173);; homalg_variable_206 := homalg_variable_l[1];; homalg_variable_207 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_206);
1
gap> homalg_variable_208 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_206 = homalg_variable_208;
false
gap> SI_nrows(homalg_variable_207);
1
gap> homalg_variable_209 := homalg_variable_173 * homalg_variable_207;;
gap> homalg_variable_206 = homalg_variable_209;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_204,homalg_variable_206);; homalg_variable_210 := homalg_variable_l[1];; homalg_variable_211 := homalg_variable_l[2];;
gap> homalg_variable_212 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_210 = homalg_variable_212;
true
gap> homalg_variable_213 := homalg_variable_206 * homalg_variable_211;;
gap> homalg_variable_214 := homalg_variable_204 + homalg_variable_213;;
gap> homalg_variable_210 = homalg_variable_214;
true
gap> homalg_variable_215 := SIH_DecideZeroColumns(homalg_variable_204,homalg_variable_206);;
gap> homalg_variable_216 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_215 = homalg_variable_216;
true
gap> homalg_variable_217 := homalg_variable_211 * (homalg_variable_8);;
gap> homalg_variable_218 := homalg_variable_207 * homalg_variable_217;;
gap> homalg_variable_219 := homalg_variable_173 * homalg_variable_218;;
gap> homalg_variable_219 = homalg_variable_204;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_173,homalg_variable_204);; homalg_variable_220 := homalg_variable_l[1];; homalg_variable_221 := homalg_variable_l[2];;
gap> homalg_variable_222 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_220 = homalg_variable_222;
true
gap> homalg_variable_223 := homalg_variable_204 * homalg_variable_221;;
gap> homalg_variable_224 := homalg_variable_173 + homalg_variable_223;;
gap> homalg_variable_220 = homalg_variable_224;
true
gap> homalg_variable_225 := SIH_DecideZeroColumns(homalg_variable_173,homalg_variable_204);;
gap> homalg_variable_226 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_225 = homalg_variable_226;
true
gap> homalg_variable_227 := homalg_variable_221 * (homalg_variable_8);;
gap> homalg_variable_228 := homalg_variable_204 * homalg_variable_227;;
gap> homalg_variable_228 = homalg_variable_173;
true
gap> homalg_variable_229 := homalg_variable_10 * homalg_variable_12;;
gap> homalg_variable_230 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_229 = homalg_variable_230;
true
gap> homalg_variable_231 := homalg_variable_12 * homalg_variable_173;;
gap> homalg_variable_232 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_231 = homalg_variable_232;
true
gap> homalg_variable_179 = homalg_variable_12;
true
gap> homalg_variable_204 = homalg_variable_173;
true
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_173);; homalg_variable_233 := homalg_variable_l[1];; homalg_variable_234 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_233);
3
gap> homalg_variable_235 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_233 = homalg_variable_235;
false
gap> SI_ncols(homalg_variable_234);
4
gap> homalg_variable_236 := homalg_variable_234 * homalg_variable_173;;
gap> homalg_variable_233 = homalg_variable_236;
true
gap> homalg_variable_237 := SI_matrix( SI_freemodule( homalg_variable_5,1 ) );;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_237,homalg_variable_233);; homalg_variable_238 := homalg_variable_l[1];; homalg_variable_239 := homalg_variable_l[2];;
gap> homalg_variable_240 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_238 = homalg_variable_240;
false
gap> homalg_variable_241 := homalg_variable_239 * homalg_variable_233;;
gap> homalg_variable_242 := homalg_variable_237 + homalg_variable_241;;
gap> homalg_variable_238 = homalg_variable_242;
true
gap> homalg_variable_243 := SIH_DecideZeroRows(homalg_variable_237,homalg_variable_233);;
gap> homalg_variable_244 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_243 = homalg_variable_244;
false
gap> homalg_variable_238 = homalg_variable_243;
true
gap> homalg_variable_245 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_70);;
gap> SI_nrows(homalg_variable_245);
1
gap> homalg_variable_246 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_245 = homalg_variable_246;
true
gap> homalg_variable_247 := SIH_BasisOfRowModule(homalg_variable_70);;
gap> SI_nrows(homalg_variable_247);
2
gap> homalg_variable_248 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_247 = homalg_variable_248;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_70);; homalg_variable_249 := homalg_variable_l[1];; homalg_variable_250 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_249);
2
gap> homalg_variable_251 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_249 = homalg_variable_251;
false
gap> SI_ncols(homalg_variable_250);
2
gap> homalg_variable_252 := homalg_variable_250 * homalg_variable_70;;
gap> homalg_variable_249 = homalg_variable_252;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_247,homalg_variable_249);; homalg_variable_253 := homalg_variable_l[1];; homalg_variable_254 := homalg_variable_l[2];;
gap> homalg_variable_255 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_253 = homalg_variable_255;
true
gap> homalg_variable_256 := homalg_variable_254 * homalg_variable_249;;
gap> homalg_variable_257 := homalg_variable_247 + homalg_variable_256;;
gap> homalg_variable_253 = homalg_variable_257;
true
gap> homalg_variable_258 := SIH_DecideZeroRows(homalg_variable_247,homalg_variable_249);;
gap> homalg_variable_259 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_258 = homalg_variable_259;
true
gap> homalg_variable_260 := homalg_variable_254 * (homalg_variable_8);;
gap> homalg_variable_261 := homalg_variable_260 * homalg_variable_250;;
gap> homalg_variable_262 := homalg_variable_261 * homalg_variable_70;;
gap> homalg_variable_262 = homalg_variable_247;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_70,homalg_variable_247);; homalg_variable_263 := homalg_variable_l[1];; homalg_variable_264 := homalg_variable_l[2];;
gap> homalg_variable_265 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_263 = homalg_variable_265;
true
gap> homalg_variable_266 := homalg_variable_264 * homalg_variable_247;;
gap> homalg_variable_267 := homalg_variable_70 + homalg_variable_266;;
gap> homalg_variable_263 = homalg_variable_267;
true
gap> homalg_variable_268 := SIH_DecideZeroRows(homalg_variable_70,homalg_variable_247);;
gap> homalg_variable_269 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_268 = homalg_variable_269;
true
gap> homalg_variable_270 := homalg_variable_264 * (homalg_variable_8);;
gap> homalg_variable_271 := homalg_variable_270 * homalg_variable_247;;
gap> homalg_variable_271 = homalg_variable_70;
true
gap> SIH_ZeroRows(homalg_variable_70);
[  ]
gap> homalg_variable_272 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_12);;
gap> SI_nrows(homalg_variable_272);
4
gap> homalg_variable_273 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_272 = homalg_variable_273;
false
gap> homalg_variable_274 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_272);;
gap> SI_nrows(homalg_variable_274);
1
gap> homalg_variable_275 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_274 = homalg_variable_275;
false
gap> homalg_variable_276 := SI_\[(homalg_variable_274,1,4);;
gap> SI_deg( homalg_variable_276 );
1
gap> homalg_variable_277 := SI_\[(homalg_variable_274,1,3);;
gap> SI_deg( homalg_variable_277 );
1
gap> homalg_variable_278 := SI_\[(homalg_variable_274,1,2);;
gap> SI_deg( homalg_variable_278 );
2
gap> homalg_variable_279 := SI_\[(homalg_variable_274,1,1);;
gap> SI_deg( homalg_variable_279 );
-1
gap> homalg_variable_280 := SIH_BasisOfRowModule(homalg_variable_272);;
gap> SI_nrows(homalg_variable_280);
4
gap> homalg_variable_281 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_280 = homalg_variable_281;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_272);; homalg_variable_282 := homalg_variable_l[1];; homalg_variable_283 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_282);
4
gap> homalg_variable_284 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_282 = homalg_variable_284;
false
gap> SI_ncols(homalg_variable_283);
4
gap> homalg_variable_285 := homalg_variable_283 * homalg_variable_272;;
gap> homalg_variable_282 = homalg_variable_285;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_280,homalg_variable_282);; homalg_variable_286 := homalg_variable_l[1];; homalg_variable_287 := homalg_variable_l[2];;
gap> homalg_variable_288 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_286 = homalg_variable_288;
true
gap> homalg_variable_289 := homalg_variable_287 * homalg_variable_282;;
gap> homalg_variable_290 := homalg_variable_280 + homalg_variable_289;;
gap> homalg_variable_286 = homalg_variable_290;
true
gap> homalg_variable_291 := SIH_DecideZeroRows(homalg_variable_280,homalg_variable_282);;
gap> homalg_variable_292 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_291 = homalg_variable_292;
true
gap> homalg_variable_293 := homalg_variable_287 * (homalg_variable_8);;
gap> homalg_variable_294 := homalg_variable_293 * homalg_variable_283;;
gap> homalg_variable_295 := homalg_variable_294 * homalg_variable_272;;
gap> homalg_variable_295 = homalg_variable_280;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_272,homalg_variable_280);; homalg_variable_296 := homalg_variable_l[1];; homalg_variable_297 := homalg_variable_l[2];;
gap> homalg_variable_298 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_296 = homalg_variable_298;
true
gap> homalg_variable_299 := homalg_variable_297 * homalg_variable_280;;
gap> homalg_variable_300 := homalg_variable_272 + homalg_variable_299;;
gap> homalg_variable_296 = homalg_variable_300;
true
gap> homalg_variable_301 := SIH_DecideZeroRows(homalg_variable_272,homalg_variable_280);;
gap> homalg_variable_302 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_301 = homalg_variable_302;
true
gap> homalg_variable_303 := homalg_variable_297 * (homalg_variable_8);;
gap> homalg_variable_304 := homalg_variable_303 * homalg_variable_280;;
gap> homalg_variable_304 = homalg_variable_272;
true
gap> homalg_variable_305 := SIH_BasisOfRowModule(homalg_variable_10);;
gap> SI_nrows(homalg_variable_305);
5
gap> homalg_variable_306 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_305 = homalg_variable_306;
false
gap> homalg_variable_305 = homalg_variable_10;
false
gap> homalg_variable_307 := SIH_DecideZeroRows(homalg_variable_272,homalg_variable_305);;
gap> homalg_variable_308 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_307 = homalg_variable_308;
false
gap> SIH_ZeroRows(homalg_variable_307);
[  ]
gap> homalg_variable_309 := SIH_RelativeSyzygiesGeneratorsOfRows(homalg_variable_307,homalg_variable_305);;
gap> SI_nrows(homalg_variable_309);
7
gap> homalg_variable_310 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_309 = homalg_variable_310;
false
gap> homalg_variable_312 := homalg_variable_309 * homalg_variable_307;;
gap> homalg_variable_311 := SIH_DecideZeroRows(homalg_variable_312,homalg_variable_305);;
gap> homalg_variable_313 := SI_matrix(homalg_variable_5,7,6,"0");;
gap> homalg_variable_311 = homalg_variable_313;
true
gap> homalg_variable_314 := SIH_RelativeSyzygiesGeneratorsOfRows(homalg_variable_307,homalg_variable_305);;
gap> SI_nrows(homalg_variable_314);
7
gap> homalg_variable_315 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_314 = homalg_variable_315;
false
gap> homalg_variable_316 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_314);;
gap> SI_nrows(homalg_variable_316);
3
gap> homalg_variable_317 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_316 = homalg_variable_317;
false
gap> homalg_variable_318 := SI_\[(homalg_variable_316,1,7);;
gap> SI_deg( homalg_variable_318 );
1
gap> homalg_variable_319 := SI_\[(homalg_variable_316,1,6);;
gap> SI_deg( homalg_variable_319 );
-1
gap> homalg_variable_320 := SI_\[(homalg_variable_316,1,5);;
gap> SI_deg( homalg_variable_320 );
1
gap> homalg_variable_321 := SI_\[(homalg_variable_316,1,4);;
gap> SI_deg( homalg_variable_321 );
-1
gap> homalg_variable_322 := SI_\[(homalg_variable_316,1,3);;
gap> SI_deg( homalg_variable_322 );
0
gap> homalg_variable_323 := SI_\[(homalg_variable_316,1,1);;
gap> IsZero(homalg_variable_323);
true
gap> homalg_variable_324 := SI_\[(homalg_variable_316,1,2);;
gap> IsZero(homalg_variable_324);
true
gap> homalg_variable_325 := SI_\[(homalg_variable_316,1,3);;
gap> IsZero(homalg_variable_325);
false
gap> homalg_variable_326 := SI_\[(homalg_variable_316,1,4);;
gap> IsZero(homalg_variable_326);
true
gap> homalg_variable_327 := SI_\[(homalg_variable_316,1,5);;
gap> IsZero(homalg_variable_327);
false
gap> homalg_variable_328 := SI_\[(homalg_variable_316,1,6);;
gap> IsZero(homalg_variable_328);
true
gap> homalg_variable_329 := SI_\[(homalg_variable_316,1,7);;
gap> IsZero(homalg_variable_329);
false
gap> homalg_variable_330 := SI_\[(homalg_variable_316,2,6);;
gap> SI_deg( homalg_variable_330 );
0
gap> homalg_variable_331 := SI_\[(homalg_variable_316,2,1);;
gap> IsZero(homalg_variable_331);
true
gap> homalg_variable_332 := SI_\[(homalg_variable_316,2,2);;
gap> IsZero(homalg_variable_332);
true
gap> homalg_variable_333 := SI_\[(homalg_variable_316,2,4);;
gap> IsZero(homalg_variable_333);
false
gap> homalg_variable_334 := SI_\[(homalg_variable_316,2,6);;
gap> IsZero(homalg_variable_334);
false
gap> homalg_variable_335 := SI_\[(homalg_variable_316,3,2);;
gap> SI_deg( homalg_variable_335 );
1
gap> homalg_variable_336 := SI_\[(homalg_variable_316,3,1);;
gap> SI_deg( homalg_variable_336 );
1
gap> homalg_variable_338 := SIH_Submatrix(homalg_variable_314,[ 1, 2, 4, 5, 7 ],[1..4]);;
gap> homalg_variable_337 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_338);;
gap> SI_nrows(homalg_variable_337);
1
gap> homalg_variable_339 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_337 = homalg_variable_339;
false
gap> homalg_variable_340 := SI_\[(homalg_variable_337,1,5);;
gap> SI_deg( homalg_variable_340 );
-1
gap> homalg_variable_341 := SI_\[(homalg_variable_337,1,4);;
gap> SI_deg( homalg_variable_341 );
-1
gap> homalg_variable_342 := SI_\[(homalg_variable_337,1,3);;
gap> SI_deg( homalg_variable_342 );
-1
gap> homalg_variable_343 := SI_\[(homalg_variable_337,1,2);;
gap> SI_deg( homalg_variable_343 );
1
gap> homalg_variable_344 := SI_\[(homalg_variable_337,1,1);;
gap> SI_deg( homalg_variable_344 );
1
gap> homalg_variable_345 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_338 = homalg_variable_345;
false
gap> homalg_variable_346 := SIH_BasisOfRowModule(homalg_variable_314);;
gap> SI_nrows(homalg_variable_346);
7
gap> homalg_variable_347 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_346 = homalg_variable_347;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_338);; homalg_variable_348 := homalg_variable_l[1];; homalg_variable_349 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_348);
7
gap> homalg_variable_350 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_348 = homalg_variable_350;
false
gap> SI_ncols(homalg_variable_349);
5
gap> homalg_variable_351 := homalg_variable_349 * homalg_variable_338;;
gap> homalg_variable_348 = homalg_variable_351;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_346,homalg_variable_348);; homalg_variable_352 := homalg_variable_l[1];; homalg_variable_353 := homalg_variable_l[2];;
gap> homalg_variable_354 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_352 = homalg_variable_354;
true
gap> homalg_variable_355 := homalg_variable_353 * homalg_variable_348;;
gap> homalg_variable_356 := homalg_variable_346 + homalg_variable_355;;
gap> homalg_variable_352 = homalg_variable_356;
true
gap> homalg_variable_357 := SIH_DecideZeroRows(homalg_variable_346,homalg_variable_348);;
gap> homalg_variable_358 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_357 = homalg_variable_358;
true
gap> homalg_variable_359 := homalg_variable_353 * (homalg_variable_8);;
gap> homalg_variable_360 := homalg_variable_359 * homalg_variable_349;;
gap> homalg_variable_361 := homalg_variable_360 * homalg_variable_338;;
gap> homalg_variable_361 = homalg_variable_346;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_338,homalg_variable_346);; homalg_variable_362 := homalg_variable_l[1];; homalg_variable_363 := homalg_variable_l[2];;
gap> homalg_variable_364 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_362 = homalg_variable_364;
true
gap> homalg_variable_365 := homalg_variable_363 * homalg_variable_346;;
gap> homalg_variable_366 := homalg_variable_338 + homalg_variable_365;;
gap> homalg_variable_362 = homalg_variable_366;
true
gap> homalg_variable_367 := SIH_DecideZeroRows(homalg_variable_338,homalg_variable_346);;
gap> homalg_variable_368 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_367 = homalg_variable_368;
true
gap> homalg_variable_369 := homalg_variable_363 * (homalg_variable_8);;
gap> homalg_variable_370 := homalg_variable_369 * homalg_variable_346;;
gap> homalg_variable_370 = homalg_variable_338;
true
gap> homalg_variable_371 := SIH_BasisOfRowModule(homalg_variable_309);;
gap> SI_nrows(homalg_variable_371);
7
gap> homalg_variable_372 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_371 = homalg_variable_372;
false
gap> homalg_variable_371 = homalg_variable_309;
true
gap> homalg_variable_373 := SIH_DecideZeroRows(homalg_variable_338,homalg_variable_371);;
gap> homalg_variable_374 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_373 = homalg_variable_374;
true
gap> homalg_variable_375 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_173);;
gap> SI_nrows(homalg_variable_375);
4
gap> homalg_variable_376 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_375 = homalg_variable_376;
false
gap> homalg_variable_377 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_375);;
gap> SI_nrows(homalg_variable_377);
1
gap> homalg_variable_378 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_377 = homalg_variable_378;
false
gap> homalg_variable_379 := SI_\[(homalg_variable_377,1,4);;
gap> SI_deg( homalg_variable_379 );
1
gap> homalg_variable_380 := SI_\[(homalg_variable_377,1,3);;
gap> SI_deg( homalg_variable_380 );
1
gap> homalg_variable_381 := SI_\[(homalg_variable_377,1,2);;
gap> SI_deg( homalg_variable_381 );
1
gap> homalg_variable_382 := SI_\[(homalg_variable_377,1,1);;
gap> SI_deg( homalg_variable_382 );
-1
gap> homalg_variable_383 := SIH_BasisOfRowModule(homalg_variable_375);;
gap> SI_nrows(homalg_variable_383);
4
gap> homalg_variable_384 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_383 = homalg_variable_384;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_375);; homalg_variable_385 := homalg_variable_l[1];; homalg_variable_386 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_385);
4
gap> homalg_variable_387 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_385 = homalg_variable_387;
false
gap> SI_ncols(homalg_variable_386);
4
gap> homalg_variable_388 := homalg_variable_386 * homalg_variable_375;;
gap> homalg_variable_385 = homalg_variable_388;
true
gap> homalg_variable_389 := SI_matrix( SI_freemodule( homalg_variable_5,4 ) );;
gap> homalg_variable_385 = homalg_variable_389;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_383,homalg_variable_385);; homalg_variable_390 := homalg_variable_l[1];; homalg_variable_391 := homalg_variable_l[2];;
gap> homalg_variable_392 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_390 = homalg_variable_392;
true
gap> homalg_variable_393 := homalg_variable_391 * homalg_variable_385;;
gap> homalg_variable_394 := homalg_variable_383 + homalg_variable_393;;
gap> homalg_variable_390 = homalg_variable_394;
true
gap> homalg_variable_395 := SIH_DecideZeroRows(homalg_variable_383,homalg_variable_385);;
gap> homalg_variable_396 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_395 = homalg_variable_396;
true
gap> homalg_variable_397 := homalg_variable_391 * (homalg_variable_8);;
gap> homalg_variable_398 := homalg_variable_397 * homalg_variable_386;;
gap> homalg_variable_399 := homalg_variable_398 * homalg_variable_375;;
gap> homalg_variable_399 = homalg_variable_383;
true
gap> homalg_variable_383 = homalg_variable_389;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_375,homalg_variable_383);; homalg_variable_400 := homalg_variable_l[1];; homalg_variable_401 := homalg_variable_l[2];;
gap> homalg_variable_402 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_400 = homalg_variable_402;
true
gap> homalg_variable_403 := homalg_variable_401 * homalg_variable_383;;
gap> homalg_variable_404 := homalg_variable_375 + homalg_variable_403;;
gap> homalg_variable_400 = homalg_variable_404;
true
gap> homalg_variable_405 := SIH_DecideZeroRows(homalg_variable_375,homalg_variable_383);;
gap> homalg_variable_406 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_405 = homalg_variable_406;
true
gap> homalg_variable_407 := homalg_variable_401 * (homalg_variable_8);;
gap> homalg_variable_408 := homalg_variable_407 * homalg_variable_383;;
gap> homalg_variable_408 = homalg_variable_375;
true
gap> homalg_variable_409 := SIH_BasisOfRowModule(homalg_variable_12);;
gap> SI_nrows(homalg_variable_409);
6
gap> homalg_variable_410 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_409 = homalg_variable_410;
false
gap> homalg_variable_409 = homalg_variable_12;
false
gap> homalg_variable_411 := SIH_DecideZeroRows(homalg_variable_375,homalg_variable_409);;
gap> homalg_variable_412 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_411 = homalg_variable_412;
false
gap> SIH_ZeroRows(homalg_variable_411);
[ 2, 4 ]
gap> homalg_variable_414 := SIH_Submatrix(homalg_variable_411,[ 1, 3 ],[1..4]);;
gap> homalg_variable_413 := SIH_RelativeSyzygiesGeneratorsOfRows(homalg_variable_414,homalg_variable_409);;
gap> SI_nrows(homalg_variable_413);
5
gap> homalg_variable_415 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_413 = homalg_variable_415;
false
gap> homalg_variable_417 := homalg_variable_413 * homalg_variable_414;;
gap> homalg_variable_416 := SIH_DecideZeroRows(homalg_variable_417,homalg_variable_409);;
gap> homalg_variable_418 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_416 = homalg_variable_418;
true
gap> homalg_variable_419 := SIH_RelativeSyzygiesGeneratorsOfRows(homalg_variable_414,homalg_variable_409);;
gap> SI_nrows(homalg_variable_419);
5
gap> homalg_variable_420 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_419 = homalg_variable_420;
false
gap> homalg_variable_421 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_419);;
gap> SI_nrows(homalg_variable_421);
4
gap> homalg_variable_422 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_421 = homalg_variable_422;
false
gap> homalg_variable_423 := SI_\[(homalg_variable_421,1,5);;
gap> SI_deg( homalg_variable_423 );
-1
gap> homalg_variable_424 := SI_\[(homalg_variable_421,1,4);;
gap> SI_deg( homalg_variable_424 );
1
gap> homalg_variable_425 := SI_\[(homalg_variable_421,1,3);;
gap> SI_deg( homalg_variable_425 );
-1
gap> homalg_variable_426 := SI_\[(homalg_variable_421,1,2);;
gap> SI_deg( homalg_variable_426 );
1
gap> homalg_variable_427 := SI_\[(homalg_variable_421,1,1);;
gap> SI_deg( homalg_variable_427 );
0
gap> homalg_variable_428 := SI_\[(homalg_variable_421,1,1);;
gap> IsZero(homalg_variable_428);
false
gap> homalg_variable_429 := SI_\[(homalg_variable_421,1,2);;
gap> IsZero(homalg_variable_429);
false
gap> homalg_variable_430 := SI_\[(homalg_variable_421,1,3);;
gap> IsZero(homalg_variable_430);
true
gap> homalg_variable_431 := SI_\[(homalg_variable_421,1,4);;
gap> IsZero(homalg_variable_431);
false
gap> homalg_variable_432 := SI_\[(homalg_variable_421,1,5);;
gap> IsZero(homalg_variable_432);
true
gap> homalg_variable_433 := SI_\[(homalg_variable_421,2,5);;
gap> SI_deg( homalg_variable_433 );
-1
gap> homalg_variable_434 := SI_\[(homalg_variable_421,2,3);;
gap> SI_deg( homalg_variable_434 );
1
gap> homalg_variable_435 := SI_\[(homalg_variable_421,3,5);;
gap> SI_deg( homalg_variable_435 );
1
gap> homalg_variable_436 := SI_\[(homalg_variable_421,3,3);;
gap> SI_deg( homalg_variable_436 );
2
gap> homalg_variable_437 := SI_\[(homalg_variable_421,4,5);;
gap> SI_deg( homalg_variable_437 );
1
gap> homalg_variable_438 := SI_\[(homalg_variable_421,4,3);;
gap> SI_deg( homalg_variable_438 );
-1
gap> homalg_variable_440 := SIH_Submatrix(homalg_variable_419,[ 2, 3, 4, 5 ],[1..2]);;
gap> homalg_variable_439 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_440);;
gap> SI_nrows(homalg_variable_439);
3
gap> homalg_variable_441 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_439 = homalg_variable_441;
false
gap> homalg_variable_442 := SI_\[(homalg_variable_439,1,4);;
gap> SI_deg( homalg_variable_442 );
-1
gap> homalg_variable_443 := SI_\[(homalg_variable_439,1,3);;
gap> SI_deg( homalg_variable_443 );
2
gap> homalg_variable_444 := SI_\[(homalg_variable_439,1,2);;
gap> SI_deg( homalg_variable_444 );
1
gap> homalg_variable_445 := SI_\[(homalg_variable_439,1,1);;
gap> SI_deg( homalg_variable_445 );
2
gap> homalg_variable_446 := SI_\[(homalg_variable_439,2,4);;
gap> SI_deg( homalg_variable_446 );
1
gap> homalg_variable_447 := SI_\[(homalg_variable_439,2,3);;
gap> SI_deg( homalg_variable_447 );
-1
gap> homalg_variable_448 := SI_\[(homalg_variable_439,2,2);;
gap> SI_deg( homalg_variable_448 );
2
gap> homalg_variable_449 := SI_\[(homalg_variable_439,2,1);;
gap> SI_deg( homalg_variable_449 );
-1
gap> homalg_variable_450 := SI_\[(homalg_variable_439,3,4);;
gap> SI_deg( homalg_variable_450 );
1
gap> homalg_variable_451 := SI_\[(homalg_variable_439,3,3);;
gap> SI_deg( homalg_variable_451 );
3
gap> homalg_variable_452 := SI_\[(homalg_variable_439,3,2);;
gap> SI_deg( homalg_variable_452 );
-1
gap> homalg_variable_453 := SI_\[(homalg_variable_439,3,1);;
gap> SI_deg( homalg_variable_453 );
3
gap> homalg_variable_454 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_440 = homalg_variable_454;
false
gap> homalg_variable_455 := SIH_BasisOfRowModule(homalg_variable_419);;
gap> SI_nrows(homalg_variable_455);
5
gap> homalg_variable_456 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_455 = homalg_variable_456;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_440);; homalg_variable_457 := homalg_variable_l[1];; homalg_variable_458 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_457);
5
gap> homalg_variable_459 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_457 = homalg_variable_459;
false
gap> SI_ncols(homalg_variable_458);
4
gap> homalg_variable_460 := homalg_variable_458 * homalg_variable_440;;
gap> homalg_variable_457 = homalg_variable_460;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_455,homalg_variable_457);; homalg_variable_461 := homalg_variable_l[1];; homalg_variable_462 := homalg_variable_l[2];;
gap> homalg_variable_463 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_461 = homalg_variable_463;
true
gap> homalg_variable_464 := homalg_variable_462 * homalg_variable_457;;
gap> homalg_variable_465 := homalg_variable_455 + homalg_variable_464;;
gap> homalg_variable_461 = homalg_variable_465;
true
gap> homalg_variable_466 := SIH_DecideZeroRows(homalg_variable_455,homalg_variable_457);;
gap> homalg_variable_467 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_466 = homalg_variable_467;
true
gap> homalg_variable_468 := homalg_variable_462 * (homalg_variable_8);;
gap> homalg_variable_469 := homalg_variable_468 * homalg_variable_458;;
gap> homalg_variable_470 := homalg_variable_469 * homalg_variable_440;;
gap> homalg_variable_470 = homalg_variable_455;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_440,homalg_variable_455);; homalg_variable_471 := homalg_variable_l[1];; homalg_variable_472 := homalg_variable_l[2];;
gap> homalg_variable_473 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_471 = homalg_variable_473;
true
gap> homalg_variable_474 := homalg_variable_472 * homalg_variable_455;;
gap> homalg_variable_475 := homalg_variable_440 + homalg_variable_474;;
gap> homalg_variable_471 = homalg_variable_475;
true
gap> homalg_variable_476 := SIH_DecideZeroRows(homalg_variable_440,homalg_variable_455);;
gap> homalg_variable_477 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_476 = homalg_variable_477;
true
gap> homalg_variable_478 := homalg_variable_472 * (homalg_variable_8);;
gap> homalg_variable_479 := homalg_variable_478 * homalg_variable_455;;
gap> homalg_variable_479 = homalg_variable_440;
true
gap> homalg_variable_480 := SIH_BasisOfRowModule(homalg_variable_413);;
gap> SI_nrows(homalg_variable_480);
5
gap> homalg_variable_481 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_480 = homalg_variable_481;
false
gap> homalg_variable_480 = homalg_variable_413;
true
gap> homalg_variable_482 := SIH_DecideZeroRows(homalg_variable_440,homalg_variable_480);;
gap> homalg_variable_483 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_482 = homalg_variable_483;
true
gap> homalg_variable_484 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_371);;
gap> SI_nrows(homalg_variable_484);
3
gap> homalg_variable_485 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_484 = homalg_variable_485;
false
gap> homalg_variable_486 := SI_\[(homalg_variable_484,1,7);;
gap> SI_deg( homalg_variable_486 );
1
gap> homalg_variable_487 := SI_\[(homalg_variable_484,1,6);;
gap> SI_deg( homalg_variable_487 );
-1
gap> homalg_variable_488 := SI_\[(homalg_variable_484,1,5);;
gap> SI_deg( homalg_variable_488 );
1
gap> homalg_variable_489 := SI_\[(homalg_variable_484,1,4);;
gap> SI_deg( homalg_variable_489 );
-1
gap> homalg_variable_490 := SI_\[(homalg_variable_484,1,3);;
gap> SI_deg( homalg_variable_490 );
0
gap> homalg_variable_491 := SI_\[(homalg_variable_484,1,1);;
gap> IsZero(homalg_variable_491);
true
gap> homalg_variable_492 := SI_\[(homalg_variable_484,1,2);;
gap> IsZero(homalg_variable_492);
true
gap> homalg_variable_493 := SI_\[(homalg_variable_484,1,3);;
gap> IsZero(homalg_variable_493);
false
gap> homalg_variable_494 := SI_\[(homalg_variable_484,1,4);;
gap> IsZero(homalg_variable_494);
true
gap> homalg_variable_495 := SI_\[(homalg_variable_484,1,5);;
gap> IsZero(homalg_variable_495);
false
gap> homalg_variable_496 := SI_\[(homalg_variable_484,1,6);;
gap> IsZero(homalg_variable_496);
true
gap> homalg_variable_497 := SI_\[(homalg_variable_484,1,7);;
gap> IsZero(homalg_variable_497);
false
gap> homalg_variable_498 := SI_\[(homalg_variable_484,2,6);;
gap> SI_deg( homalg_variable_498 );
0
gap> homalg_variable_499 := SI_\[(homalg_variable_484,2,1);;
gap> IsZero(homalg_variable_499);
true
gap> homalg_variable_500 := SI_\[(homalg_variable_484,2,2);;
gap> IsZero(homalg_variable_500);
true
gap> for _del in [ "homalg_variable_11", "homalg_variable_13", "homalg_variable_14", "homalg_variable_15", "homalg_variable_16", "homalg_variable_17", "homalg_variable_18", "homalg_variable_19", "homalg_variable_20", "homalg_variable_21", "homalg_variable_22", "homalg_variable_23", "homalg_variable_24", "homalg_variable_25", "homalg_variable_26", "homalg_variable_27", "homalg_variable_28", "homalg_variable_29", "homalg_variable_30", "homalg_variable_31", "homalg_variable_32", "homalg_variable_33", "homalg_variable_34", "homalg_variable_35", "homalg_variable_36", "homalg_variable_37", "homalg_variable_40", "homalg_variable_43", "homalg_variable_45", "homalg_variable_46", "homalg_variable_47", "homalg_variable_48", "homalg_variable_49", "homalg_variable_50", "homalg_variable_51", "homalg_variable_52", "homalg_variable_53", "homalg_variable_54", "homalg_variable_55", "homalg_variable_56", "homalg_variable_57", "homalg_variable_58", "homalg_variable_59", "homalg_variable_60", "homalg_variable_61", "homalg_variable_62", "homalg_variable_63", "homalg_variable_64", "homalg_variable_65", "homalg_variable_66", "homalg_variable_67", "homalg_variable_68", "homalg_variable_69", "homalg_variable_71", "homalg_variable_72", "homalg_variable_73", "homalg_variable_75", "homalg_variable_77", "homalg_variable_78", "homalg_variable_79", "homalg_variable_80", "homalg_variable_81", "homalg_variable_83", "homalg_variable_86", "homalg_variable_87", "homalg_variable_90", "homalg_variable_91", "homalg_variable_92", "homalg_variable_93", "homalg_variable_94", "homalg_variable_98", "homalg_variable_99", "homalg_variable_100", "homalg_variable_101", "homalg_variable_102", "homalg_variable_103", "homalg_variable_104", "homalg_variable_105", "homalg_variable_106", "homalg_variable_108", "homalg_variable_109", "homalg_variable_111", "homalg_variable_112", "homalg_variable_113", "homalg_variable_114", "homalg_variable_116", "homalg_variable_118", "homalg_variable_119", "homalg_variable_120", "homalg_variable_121", "homalg_variable_122", "homalg_variable_123", "homalg_variable_124", "homalg_variable_125", "homalg_variable_126", "homalg_variable_127", "homalg_variable_128", "homalg_variable_129", "homalg_variable_130", "homalg_variable_131", "homalg_variable_132", "homalg_variable_133", "homalg_variable_134", "homalg_variable_135", "homalg_variable_136", "homalg_variable_137", "homalg_variable_138", "homalg_variable_139", "homalg_variable_140", "homalg_variable_141", "homalg_variable_142", "homalg_variable_144", "homalg_variable_147", "homalg_variable_148", "homalg_variable_149", "homalg_variable_150", "homalg_variable_151", "homalg_variable_152", "homalg_variable_153", "homalg_variable_154", "homalg_variable_155", "homalg_variable_156", "homalg_variable_157", "homalg_variable_158", "homalg_variable_159", "homalg_variable_160", "homalg_variable_161", "homalg_variable_162", "homalg_variable_163", "homalg_variable_164", "homalg_variable_165", "homalg_variable_166", "homalg_variable_167", "homalg_variable_169", "homalg_variable_170", "homalg_variable_171", "homalg_variable_174", "homalg_variable_175", "homalg_variable_176", "homalg_variable_177", "homalg_variable_178", "homalg_variable_180", "homalg_variable_183", "homalg_variable_184", "homalg_variable_185", "homalg_variable_186", "homalg_variable_187", "homalg_variable_188", "homalg_variable_189", "homalg_variable_190", "homalg_variable_191", "homalg_variable_192", "homalg_variable_193", "homalg_variable_194", "homalg_variable_195", "homalg_variable_196", "homalg_variable_197", "homalg_variable_198", "homalg_variable_199", "homalg_variable_200", "homalg_variable_201", "homalg_variable_202", "homalg_variable_203", "homalg_variable_205", "homalg_variable_208", "homalg_variable_209", "homalg_variable_210", "homalg_variable_211", "homalg_variable_212", "homalg_variable_213", "homalg_variable_214", "homalg_variable_215", "homalg_variable_216", "homalg_variable_217", "homalg_variable_218", "homalg_variable_219", "homalg_variable_220", "homalg_variable_221", "homalg_variable_222", "homalg_variable_223", "homalg_variable_224", "homalg_variable_225", "homalg_variable_226", "homalg_variable_227", "homalg_variable_228", "homalg_variable_229", "homalg_variable_230", "homalg_variable_231", "homalg_variable_232", "homalg_variable_235", "homalg_variable_236", "homalg_variable_240", "homalg_variable_241", "homalg_variable_242", "homalg_variable_245", "homalg_variable_246", "homalg_variable_248", "homalg_variable_251", "homalg_variable_252", "homalg_variable_253", "homalg_variable_254", "homalg_variable_255", "homalg_variable_256", "homalg_variable_257", "homalg_variable_258", "homalg_variable_259", "homalg_variable_260", "homalg_variable_261", "homalg_variable_262", "homalg_variable_263", "homalg_variable_264", "homalg_variable_265", "homalg_variable_266", "homalg_variable_267", "homalg_variable_268", "homalg_variable_269", "homalg_variable_270", "homalg_variable_271", "homalg_variable_273", "homalg_variable_275", "homalg_variable_276", "homalg_variable_277", "homalg_variable_278", "homalg_variable_279", "homalg_variable_281", "homalg_variable_284", "homalg_variable_285", "homalg_variable_286", "homalg_variable_287", "homalg_variable_288", "homalg_variable_289", "homalg_variable_290", "homalg_variable_291", "homalg_variable_292", "homalg_variable_293", "homalg_variable_294", "homalg_variable_295", "homalg_variable_296", "homalg_variable_297", "homalg_variable_298", "homalg_variable_299", "homalg_variable_300", "homalg_variable_301", "homalg_variable_302", "homalg_variable_303", "homalg_variable_304", "homalg_variable_306", "homalg_variable_308", "homalg_variable_310", "homalg_variable_311", "homalg_variable_312", "homalg_variable_313", "homalg_variable_315", "homalg_variable_317", "homalg_variable_318", "homalg_variable_319", "homalg_variable_320", "homalg_variable_321", "homalg_variable_322", "homalg_variable_323", "homalg_variable_324", "homalg_variable_325", "homalg_variable_326", "homalg_variable_327", "homalg_variable_328", "homalg_variable_329", "homalg_variable_330", "homalg_variable_331", "homalg_variable_332", "homalg_variable_333", "homalg_variable_334", "homalg_variable_335", "homalg_variable_336", "homalg_variable_339", "homalg_variable_340", "homalg_variable_341", "homalg_variable_342", "homalg_variable_343", "homalg_variable_344", "homalg_variable_345", "homalg_variable_347", "homalg_variable_350", "homalg_variable_351", "homalg_variable_352", "homalg_variable_353", "homalg_variable_354", "homalg_variable_355", "homalg_variable_356", "homalg_variable_357", "homalg_variable_358", "homalg_variable_359", "homalg_variable_360", "homalg_variable_361", "homalg_variable_364", "homalg_variable_367", "homalg_variable_368", "homalg_variable_370", "homalg_variable_372", "homalg_variable_373", "homalg_variable_374", "homalg_variable_376", "homalg_variable_378", "homalg_variable_379", "homalg_variable_380", "homalg_variable_381", "homalg_variable_382", "homalg_variable_384", "homalg_variable_387", "homalg_variable_388", "homalg_variable_389", "homalg_variable_390", "homalg_variable_391", "homalg_variable_392", "homalg_variable_393", "homalg_variable_394", "homalg_variable_395", "homalg_variable_396", "homalg_variable_397", "homalg_variable_398", "homalg_variable_399", "homalg_variable_400", "homalg_variable_401", "homalg_variable_402", "homalg_variable_403", "homalg_variable_404", "homalg_variable_405", "homalg_variable_406", "homalg_variable_407", "homalg_variable_408", "homalg_variable_410", "homalg_variable_412", "homalg_variable_415", "homalg_variable_416", "homalg_variable_417", "homalg_variable_418", "homalg_variable_420", "homalg_variable_422", "homalg_variable_423", "homalg_variable_424", "homalg_variable_425", "homalg_variable_426", "homalg_variable_427", "homalg_variable_428", "homalg_variable_429", "homalg_variable_430", "homalg_variable_431", "homalg_variable_432", "homalg_variable_433", "homalg_variable_434", "homalg_variable_435", "homalg_variable_436", "homalg_variable_437", "homalg_variable_438", "homalg_variable_441", "homalg_variable_442", "homalg_variable_443", "homalg_variable_444", "homalg_variable_445", "homalg_variable_446", "homalg_variable_447", "homalg_variable_448", "homalg_variable_449" ] do UnbindGlobal( _del );; od;;
gap> homalg_variable_501 := SI_\[(homalg_variable_484,2,4);;
gap> IsZero(homalg_variable_501);
false
gap> homalg_variable_502 := SI_\[(homalg_variable_484,2,6);;
gap> IsZero(homalg_variable_502);
false
gap> homalg_variable_503 := SI_\[(homalg_variable_484,3,2);;
gap> SI_deg( homalg_variable_503 );
1
gap> homalg_variable_504 := SI_\[(homalg_variable_484,3,1);;
gap> SI_deg( homalg_variable_504 );
1
gap> homalg_variable_506 := SIH_Submatrix(homalg_variable_371,[ 1, 2, 4, 5, 7 ],[1..4]);;
gap> homalg_variable_505 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_506);;
gap> SI_nrows(homalg_variable_505);
1
gap> homalg_variable_507 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_505 = homalg_variable_507;
false
gap> homalg_variable_508 := SI_\[(homalg_variable_505,1,5);;
gap> SI_deg( homalg_variable_508 );
-1
gap> homalg_variable_509 := SI_\[(homalg_variable_505,1,4);;
gap> SI_deg( homalg_variable_509 );
-1
gap> homalg_variable_510 := SI_\[(homalg_variable_505,1,3);;
gap> SI_deg( homalg_variable_510 );
-1
gap> homalg_variable_511 := SI_\[(homalg_variable_505,1,2);;
gap> SI_deg( homalg_variable_511 );
1
gap> homalg_variable_512 := SI_\[(homalg_variable_505,1,1);;
gap> SI_deg( homalg_variable_512 );
1
gap> homalg_variable_513 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_506 = homalg_variable_513;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_506);; homalg_variable_514 := homalg_variable_l[1];; homalg_variable_515 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_514);
7
gap> homalg_variable_516 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_514 = homalg_variable_516;
false
gap> SI_ncols(homalg_variable_515);
5
gap> homalg_variable_517 := homalg_variable_515 * homalg_variable_506;;
gap> homalg_variable_514 = homalg_variable_517;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_371,homalg_variable_514);; homalg_variable_518 := homalg_variable_l[1];; homalg_variable_519 := homalg_variable_l[2];;
gap> homalg_variable_520 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_518 = homalg_variable_520;
true
gap> homalg_variable_521 := homalg_variable_519 * homalg_variable_514;;
gap> homalg_variable_522 := homalg_variable_371 + homalg_variable_521;;
gap> homalg_variable_518 = homalg_variable_522;
true
gap> homalg_variable_523 := SIH_DecideZeroRows(homalg_variable_371,homalg_variable_514);;
gap> homalg_variable_524 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_523 = homalg_variable_524;
true
gap> homalg_variable_525 := homalg_variable_519 * (homalg_variable_8);;
gap> homalg_variable_526 := homalg_variable_525 * homalg_variable_515;;
gap> homalg_variable_527 := homalg_variable_526 * homalg_variable_506;;
gap> homalg_variable_527 = homalg_variable_371;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_506,homalg_variable_371);; homalg_variable_528 := homalg_variable_l[1];; homalg_variable_529 := homalg_variable_l[2];;
gap> homalg_variable_530 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_528 = homalg_variable_530;
true
gap> homalg_variable_531 := homalg_variable_529 * homalg_variable_371;;
gap> homalg_variable_532 := homalg_variable_506 + homalg_variable_531;;
gap> homalg_variable_528 = homalg_variable_532;
true
gap> homalg_variable_533 := SIH_DecideZeroRows(homalg_variable_506,homalg_variable_371);;
gap> homalg_variable_534 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_533 = homalg_variable_534;
true
gap> homalg_variable_535 := homalg_variable_529 * (homalg_variable_8);;
gap> homalg_variable_536 := homalg_variable_535 * homalg_variable_371;;
gap> homalg_variable_536 = homalg_variable_506;
true
gap> homalg_variable_537 := SIH_BasisOfRowModule(homalg_variable_505);;
gap> SI_nrows(homalg_variable_537);
1
gap> homalg_variable_538 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_537 = homalg_variable_538;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_505);; homalg_variable_539 := homalg_variable_l[1];; homalg_variable_540 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_539);
1
gap> homalg_variable_541 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_539 = homalg_variable_541;
false
gap> SI_ncols(homalg_variable_540);
1
gap> homalg_variable_542 := homalg_variable_540 * homalg_variable_505;;
gap> homalg_variable_539 = homalg_variable_542;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_537,homalg_variable_539);; homalg_variable_543 := homalg_variable_l[1];; homalg_variable_544 := homalg_variable_l[2];;
gap> homalg_variable_545 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_543 = homalg_variable_545;
true
gap> homalg_variable_546 := homalg_variable_544 * homalg_variable_539;;
gap> homalg_variable_547 := homalg_variable_537 + homalg_variable_546;;
gap> homalg_variable_543 = homalg_variable_547;
true
gap> homalg_variable_548 := SIH_DecideZeroRows(homalg_variable_537,homalg_variable_539);;
gap> homalg_variable_549 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_548 = homalg_variable_549;
true
gap> homalg_variable_550 := homalg_variable_544 * (homalg_variable_8);;
gap> homalg_variable_551 := homalg_variable_550 * homalg_variable_540;;
gap> homalg_variable_552 := homalg_variable_551 * homalg_variable_505;;
gap> homalg_variable_552 = homalg_variable_537;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_505,homalg_variable_537);; homalg_variable_553 := homalg_variable_l[1];; homalg_variable_554 := homalg_variable_l[2];;
gap> homalg_variable_555 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_553 = homalg_variable_555;
true
gap> homalg_variable_556 := homalg_variable_554 * homalg_variable_537;;
gap> homalg_variable_557 := homalg_variable_505 + homalg_variable_556;;
gap> homalg_variable_553 = homalg_variable_557;
true
gap> homalg_variable_558 := SIH_DecideZeroRows(homalg_variable_505,homalg_variable_537);;
gap> homalg_variable_559 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_558 = homalg_variable_559;
true
gap> homalg_variable_560 := homalg_variable_554 * (homalg_variable_8);;
gap> homalg_variable_561 := homalg_variable_560 * homalg_variable_537;;
gap> homalg_variable_561 = homalg_variable_505;
true
gap> homalg_variable_562 := homalg_variable_505 * homalg_variable_506;;
gap> homalg_variable_563 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_562 = homalg_variable_563;
true
gap> homalg_variable_537 = homalg_variable_505;
true
gap> homalg_variable_564 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_480);;
gap> SI_nrows(homalg_variable_564);
4
gap> homalg_variable_565 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_564 = homalg_variable_565;
false
gap> homalg_variable_566 := SI_\[(homalg_variable_564,1,5);;
gap> SI_deg( homalg_variable_566 );
-1
gap> homalg_variable_567 := SI_\[(homalg_variable_564,1,4);;
gap> SI_deg( homalg_variable_567 );
1
gap> homalg_variable_568 := SI_\[(homalg_variable_564,1,3);;
gap> SI_deg( homalg_variable_568 );
-1
gap> homalg_variable_569 := SI_\[(homalg_variable_564,1,2);;
gap> SI_deg( homalg_variable_569 );
1
gap> homalg_variable_570 := SI_\[(homalg_variable_564,1,1);;
gap> SI_deg( homalg_variable_570 );
0
gap> homalg_variable_571 := SI_\[(homalg_variable_564,1,1);;
gap> IsZero(homalg_variable_571);
false
gap> homalg_variable_572 := SI_\[(homalg_variable_564,1,2);;
gap> IsZero(homalg_variable_572);
false
gap> homalg_variable_573 := SI_\[(homalg_variable_564,1,3);;
gap> IsZero(homalg_variable_573);
true
gap> homalg_variable_574 := SI_\[(homalg_variable_564,1,4);;
gap> IsZero(homalg_variable_574);
false
gap> homalg_variable_575 := SI_\[(homalg_variable_564,1,5);;
gap> IsZero(homalg_variable_575);
true
gap> homalg_variable_576 := SI_\[(homalg_variable_564,2,5);;
gap> SI_deg( homalg_variable_576 );
-1
gap> homalg_variable_577 := SI_\[(homalg_variable_564,2,3);;
gap> SI_deg( homalg_variable_577 );
1
gap> homalg_variable_578 := SI_\[(homalg_variable_564,3,5);;
gap> SI_deg( homalg_variable_578 );
1
gap> homalg_variable_579 := SI_\[(homalg_variable_564,3,3);;
gap> SI_deg( homalg_variable_579 );
2
gap> homalg_variable_580 := SI_\[(homalg_variable_564,4,5);;
gap> SI_deg( homalg_variable_580 );
1
gap> homalg_variable_581 := SI_\[(homalg_variable_564,4,3);;
gap> SI_deg( homalg_variable_581 );
-1
gap> homalg_variable_583 := SIH_Submatrix(homalg_variable_480,[ 2, 3, 4, 5 ],[1..2]);;
gap> homalg_variable_582 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_583);;
gap> SI_nrows(homalg_variable_582);
3
gap> homalg_variable_584 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_582 = homalg_variable_584;
false
gap> homalg_variable_585 := SI_\[(homalg_variable_582,1,4);;
gap> SI_deg( homalg_variable_585 );
-1
gap> homalg_variable_586 := SI_\[(homalg_variable_582,1,3);;
gap> SI_deg( homalg_variable_586 );
2
gap> homalg_variable_587 := SI_\[(homalg_variable_582,1,2);;
gap> SI_deg( homalg_variable_587 );
1
gap> homalg_variable_588 := SI_\[(homalg_variable_582,1,1);;
gap> SI_deg( homalg_variable_588 );
2
gap> homalg_variable_589 := SI_\[(homalg_variable_582,2,4);;
gap> SI_deg( homalg_variable_589 );
1
gap> homalg_variable_590 := SI_\[(homalg_variable_582,2,3);;
gap> SI_deg( homalg_variable_590 );
-1
gap> homalg_variable_591 := SI_\[(homalg_variable_582,2,2);;
gap> SI_deg( homalg_variable_591 );
2
gap> homalg_variable_592 := SI_\[(homalg_variable_582,2,1);;
gap> SI_deg( homalg_variable_592 );
-1
gap> homalg_variable_593 := SI_\[(homalg_variable_582,3,4);;
gap> SI_deg( homalg_variable_593 );
1
gap> homalg_variable_594 := SI_\[(homalg_variable_582,3,3);;
gap> SI_deg( homalg_variable_594 );
3
gap> homalg_variable_595 := SI_\[(homalg_variable_582,3,2);;
gap> SI_deg( homalg_variable_595 );
-1
gap> homalg_variable_596 := SI_\[(homalg_variable_582,3,1);;
gap> SI_deg( homalg_variable_596 );
3
gap> homalg_variable_597 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_583 = homalg_variable_597;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_583);; homalg_variable_598 := homalg_variable_l[1];; homalg_variable_599 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_598);
5
gap> homalg_variable_600 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_598 = homalg_variable_600;
false
gap> SI_ncols(homalg_variable_599);
4
gap> homalg_variable_601 := homalg_variable_599 * homalg_variable_583;;
gap> homalg_variable_598 = homalg_variable_601;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_480,homalg_variable_598);; homalg_variable_602 := homalg_variable_l[1];; homalg_variable_603 := homalg_variable_l[2];;
gap> homalg_variable_604 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_602 = homalg_variable_604;
true
gap> homalg_variable_605 := homalg_variable_603 * homalg_variable_598;;
gap> homalg_variable_606 := homalg_variable_480 + homalg_variable_605;;
gap> homalg_variable_602 = homalg_variable_606;
true
gap> homalg_variable_607 := SIH_DecideZeroRows(homalg_variable_480,homalg_variable_598);;
gap> homalg_variable_608 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_607 = homalg_variable_608;
true
gap> homalg_variable_609 := homalg_variable_603 * (homalg_variable_8);;
gap> homalg_variable_610 := homalg_variable_609 * homalg_variable_599;;
gap> homalg_variable_611 := homalg_variable_610 * homalg_variable_583;;
gap> homalg_variable_611 = homalg_variable_480;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_583,homalg_variable_480);; homalg_variable_612 := homalg_variable_l[1];; homalg_variable_613 := homalg_variable_l[2];;
gap> homalg_variable_614 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_612 = homalg_variable_614;
true
gap> homalg_variable_615 := homalg_variable_613 * homalg_variable_480;;
gap> homalg_variable_616 := homalg_variable_583 + homalg_variable_615;;
gap> homalg_variable_612 = homalg_variable_616;
true
gap> homalg_variable_617 := SIH_DecideZeroRows(homalg_variable_583,homalg_variable_480);;
gap> homalg_variable_618 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_617 = homalg_variable_618;
true
gap> homalg_variable_619 := homalg_variable_613 * (homalg_variable_8);;
gap> homalg_variable_620 := homalg_variable_619 * homalg_variable_480;;
gap> homalg_variable_620 = homalg_variable_583;
true
gap> homalg_variable_621 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_582);;
gap> SI_nrows(homalg_variable_621);
1
gap> homalg_variable_622 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_621 = homalg_variable_622;
false
gap> homalg_variable_623 := SI_\[(homalg_variable_621,1,3);;
gap> SI_deg( homalg_variable_623 );
1
gap> homalg_variable_624 := SI_\[(homalg_variable_621,1,2);;
gap> SI_deg( homalg_variable_624 );
1
gap> homalg_variable_625 := SI_\[(homalg_variable_621,1,1);;
gap> SI_deg( homalg_variable_625 );
2
gap> homalg_variable_626 := SIH_BasisOfRowModule(homalg_variable_582);;
gap> SI_nrows(homalg_variable_626);
3
gap> homalg_variable_627 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_626 = homalg_variable_627;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_582);; homalg_variable_628 := homalg_variable_l[1];; homalg_variable_629 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_628);
3
gap> homalg_variable_630 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_628 = homalg_variable_630;
false
gap> SI_ncols(homalg_variable_629);
3
gap> homalg_variable_631 := homalg_variable_629 * homalg_variable_582;;
gap> homalg_variable_628 = homalg_variable_631;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_626,homalg_variable_628);; homalg_variable_632 := homalg_variable_l[1];; homalg_variable_633 := homalg_variable_l[2];;
gap> homalg_variable_634 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_632 = homalg_variable_634;
true
gap> homalg_variable_635 := homalg_variable_633 * homalg_variable_628;;
gap> homalg_variable_636 := homalg_variable_626 + homalg_variable_635;;
gap> homalg_variable_632 = homalg_variable_636;
true
gap> homalg_variable_637 := SIH_DecideZeroRows(homalg_variable_626,homalg_variable_628);;
gap> homalg_variable_638 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_637 = homalg_variable_638;
true
gap> homalg_variable_639 := homalg_variable_633 * (homalg_variable_8);;
gap> homalg_variable_640 := homalg_variable_639 * homalg_variable_629;;
gap> homalg_variable_641 := homalg_variable_640 * homalg_variable_582;;
gap> homalg_variable_641 = homalg_variable_626;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_582,homalg_variable_626);; homalg_variable_642 := homalg_variable_l[1];; homalg_variable_643 := homalg_variable_l[2];;
gap> homalg_variable_644 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_642 = homalg_variable_644;
true
gap> homalg_variable_645 := homalg_variable_643 * homalg_variable_626;;
gap> homalg_variable_646 := homalg_variable_582 + homalg_variable_645;;
gap> homalg_variable_642 = homalg_variable_646;
true
gap> homalg_variable_647 := SIH_DecideZeroRows(homalg_variable_582,homalg_variable_626);;
gap> homalg_variable_648 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_647 = homalg_variable_648;
true
gap> homalg_variable_649 := homalg_variable_643 * (homalg_variable_8);;
gap> homalg_variable_650 := homalg_variable_649 * homalg_variable_626;;
gap> homalg_variable_650 = homalg_variable_582;
true
gap> homalg_variable_651 := SIH_BasisOfRowModule(homalg_variable_621);;
gap> SI_nrows(homalg_variable_651);
1
gap> homalg_variable_652 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_651 = homalg_variable_652;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_621);; homalg_variable_653 := homalg_variable_l[1];; homalg_variable_654 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_653);
1
gap> homalg_variable_655 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_653 = homalg_variable_655;
false
gap> SI_ncols(homalg_variable_654);
1
gap> homalg_variable_656 := homalg_variable_654 * homalg_variable_621;;
gap> homalg_variable_653 = homalg_variable_656;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_651,homalg_variable_653);; homalg_variable_657 := homalg_variable_l[1];; homalg_variable_658 := homalg_variable_l[2];;
gap> homalg_variable_659 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_657 = homalg_variable_659;
true
gap> homalg_variable_660 := homalg_variable_658 * homalg_variable_653;;
gap> homalg_variable_661 := homalg_variable_651 + homalg_variable_660;;
gap> homalg_variable_657 = homalg_variable_661;
true
gap> homalg_variable_662 := SIH_DecideZeroRows(homalg_variable_651,homalg_variable_653);;
gap> homalg_variable_663 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_662 = homalg_variable_663;
true
gap> homalg_variable_664 := homalg_variable_658 * (homalg_variable_8);;
gap> homalg_variable_665 := homalg_variable_664 * homalg_variable_654;;
gap> homalg_variable_666 := homalg_variable_665 * homalg_variable_621;;
gap> homalg_variable_666 = homalg_variable_651;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_621,homalg_variable_651);; homalg_variable_667 := homalg_variable_l[1];; homalg_variable_668 := homalg_variable_l[2];;
gap> homalg_variable_669 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_667 = homalg_variable_669;
true
gap> homalg_variable_670 := homalg_variable_668 * homalg_variable_651;;
gap> homalg_variable_671 := homalg_variable_621 + homalg_variable_670;;
gap> homalg_variable_667 = homalg_variable_671;
true
gap> homalg_variable_672 := SIH_DecideZeroRows(homalg_variable_621,homalg_variable_651);;
gap> homalg_variable_673 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_672 = homalg_variable_673;
true
gap> homalg_variable_674 := homalg_variable_668 * (homalg_variable_8);;
gap> homalg_variable_675 := homalg_variable_674 * homalg_variable_651;;
gap> homalg_variable_675 = homalg_variable_621;
true
gap> homalg_variable_676 := homalg_variable_582 * homalg_variable_583;;
gap> homalg_variable_677 := SI_matrix(homalg_variable_5,3,2,"0");;
gap> homalg_variable_676 = homalg_variable_677;
true
gap> homalg_variable_678 := homalg_variable_621 * homalg_variable_582;;
gap> homalg_variable_679 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_678 = homalg_variable_679;
true
gap> homalg_variable_626 = homalg_variable_582;
true
gap> homalg_variable_651 = homalg_variable_621;
true
gap> homalg_variable_680 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_233);;
gap> SI_nrows(homalg_variable_680);
3
gap> homalg_variable_681 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_680 = homalg_variable_681;
false
gap> homalg_variable_682 := SI_\[(homalg_variable_680,1,3);;
gap> SI_deg( homalg_variable_682 );
-1
gap> homalg_variable_683 := SI_\[(homalg_variable_680,1,2);;
gap> SI_deg( homalg_variable_683 );
1
gap> homalg_variable_684 := SI_\[(homalg_variable_680,1,1);;
gap> SI_deg( homalg_variable_684 );
1
gap> homalg_variable_685 := SI_\[(homalg_variable_680,2,3);;
gap> SI_deg( homalg_variable_685 );
1
gap> homalg_variable_686 := SI_\[(homalg_variable_680,2,2);;
gap> SI_deg( homalg_variable_686 );
1
gap> homalg_variable_687 := SI_\[(homalg_variable_680,2,1);;
gap> SI_deg( homalg_variable_687 );
-1
gap> homalg_variable_688 := SI_\[(homalg_variable_680,3,3);;
gap> SI_deg( homalg_variable_688 );
1
gap> homalg_variable_689 := SI_\[(homalg_variable_680,3,2);;
gap> SI_deg( homalg_variable_689 );
-1
gap> homalg_variable_690 := SI_\[(homalg_variable_680,3,1);;
gap> SI_deg( homalg_variable_690 );
1
gap> homalg_variable_691 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_680);;
gap> SI_nrows(homalg_variable_691);
1
gap> homalg_variable_692 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_691 = homalg_variable_692;
false
gap> homalg_variable_693 := SI_\[(homalg_variable_691,1,3);;
gap> SI_deg( homalg_variable_693 );
1
gap> homalg_variable_694 := SI_\[(homalg_variable_691,1,2);;
gap> SI_deg( homalg_variable_694 );
1
gap> homalg_variable_695 := SI_\[(homalg_variable_691,1,1);;
gap> SI_deg( homalg_variable_695 );
1
gap> homalg_variable_696 := SIH_BasisOfRowModule(homalg_variable_680);;
gap> SI_nrows(homalg_variable_696);
3
gap> homalg_variable_697 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_696 = homalg_variable_697;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_680);; homalg_variable_698 := homalg_variable_l[1];; homalg_variable_699 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_698);
3
gap> homalg_variable_700 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_698 = homalg_variable_700;
false
gap> SI_ncols(homalg_variable_699);
3
gap> homalg_variable_701 := homalg_variable_699 * homalg_variable_680;;
gap> homalg_variable_698 = homalg_variable_701;
true
gap> homalg_variable_702 := SI_matrix( SI_freemodule( homalg_variable_5,3 ) );;
gap> homalg_variable_698 = homalg_variable_702;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_696,homalg_variable_698);; homalg_variable_703 := homalg_variable_l[1];; homalg_variable_704 := homalg_variable_l[2];;
gap> homalg_variable_705 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_703 = homalg_variable_705;
true
gap> homalg_variable_706 := homalg_variable_704 * homalg_variable_698;;
gap> homalg_variable_707 := homalg_variable_696 + homalg_variable_706;;
gap> homalg_variable_703 = homalg_variable_707;
true
gap> homalg_variable_708 := SIH_DecideZeroRows(homalg_variable_696,homalg_variable_698);;
gap> homalg_variable_709 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_708 = homalg_variable_709;
true
gap> homalg_variable_710 := homalg_variable_704 * (homalg_variable_8);;
gap> homalg_variable_711 := homalg_variable_710 * homalg_variable_699;;
gap> homalg_variable_712 := homalg_variable_711 * homalg_variable_680;;
gap> homalg_variable_712 = homalg_variable_696;
true
gap> homalg_variable_696 = homalg_variable_702;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_680,homalg_variable_696);; homalg_variable_713 := homalg_variable_l[1];; homalg_variable_714 := homalg_variable_l[2];;
gap> homalg_variable_715 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_713 = homalg_variable_715;
true
gap> homalg_variable_716 := homalg_variable_714 * homalg_variable_696;;
gap> homalg_variable_717 := homalg_variable_680 + homalg_variable_716;;
gap> homalg_variable_713 = homalg_variable_717;
true
gap> homalg_variable_718 := SIH_DecideZeroRows(homalg_variable_680,homalg_variable_696);;
gap> homalg_variable_719 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_718 = homalg_variable_719;
true
gap> homalg_variable_720 := homalg_variable_714 * (homalg_variable_8);;
gap> homalg_variable_721 := homalg_variable_720 * homalg_variable_696;;
gap> homalg_variable_721 = homalg_variable_680;
true
gap> homalg_variable_722 := SIH_BasisOfRowModule(homalg_variable_691);;
gap> SI_nrows(homalg_variable_722);
1
gap> homalg_variable_723 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_722 = homalg_variable_723;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_691);; homalg_variable_724 := homalg_variable_l[1];; homalg_variable_725 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_724);
1
gap> homalg_variable_726 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_724 = homalg_variable_726;
false
gap> SI_ncols(homalg_variable_725);
1
gap> homalg_variable_727 := homalg_variable_725 * homalg_variable_691;;
gap> homalg_variable_724 = homalg_variable_727;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_722,homalg_variable_724);; homalg_variable_728 := homalg_variable_l[1];; homalg_variable_729 := homalg_variable_l[2];;
gap> homalg_variable_730 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_728 = homalg_variable_730;
true
gap> homalg_variable_731 := homalg_variable_729 * homalg_variable_724;;
gap> homalg_variable_732 := homalg_variable_722 + homalg_variable_731;;
gap> homalg_variable_728 = homalg_variable_732;
true
gap> homalg_variable_733 := SIH_DecideZeroRows(homalg_variable_722,homalg_variable_724);;
gap> homalg_variable_734 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_733 = homalg_variable_734;
true
gap> homalg_variable_735 := homalg_variable_729 * (homalg_variable_8);;
gap> homalg_variable_736 := homalg_variable_735 * homalg_variable_725;;
gap> homalg_variable_737 := homalg_variable_736 * homalg_variable_691;;
gap> homalg_variable_737 = homalg_variable_722;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_691,homalg_variable_722);; homalg_variable_738 := homalg_variable_l[1];; homalg_variable_739 := homalg_variable_l[2];;
gap> homalg_variable_740 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_738 = homalg_variable_740;
true
gap> homalg_variable_741 := homalg_variable_739 * homalg_variable_722;;
gap> homalg_variable_742 := homalg_variable_691 + homalg_variable_741;;
gap> homalg_variable_738 = homalg_variable_742;
true
gap> homalg_variable_743 := SIH_DecideZeroRows(homalg_variable_691,homalg_variable_722);;
gap> homalg_variable_744 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_743 = homalg_variable_744;
true
gap> homalg_variable_745 := homalg_variable_739 * (homalg_variable_8);;
gap> homalg_variable_746 := homalg_variable_745 * homalg_variable_722;;
gap> homalg_variable_746 = homalg_variable_691;
true
gap> homalg_variable_747 := homalg_variable_680 * homalg_variable_233;;
gap> homalg_variable_748 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_747 = homalg_variable_748;
true
gap> homalg_variable_749 := homalg_variable_691 * homalg_variable_680;;
gap> homalg_variable_750 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_749 = homalg_variable_750;
true
gap> homalg_variable_696 = homalg_variable_680;
true
gap> homalg_variable_722 = homalg_variable_691;
true
gap> homalg_variable_751 := homalg_variable_505 * homalg_variable_506;;
gap> homalg_variable_752 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_751 = homalg_variable_752;
true
gap> homalg_variable_753 := SIH_DecideZeroRows(homalg_variable_505,homalg_variable_537);;
gap> homalg_variable_754 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_753 = homalg_variable_754;
true
gap> SIH_ZeroRows(homalg_variable_10);
[  ]
gap> homalg_variable_755 := homalg_variable_70 * homalg_variable_10;;
gap> homalg_variable_756 := SI_matrix(homalg_variable_5,2,6,"0");;
gap> homalg_variable_755 = homalg_variable_756;
true
gap> homalg_variable_247 = homalg_variable_70;
true
gap> homalg_variable_757 := SIH_DecideZeroRows(homalg_variable_70,homalg_variable_247);;
gap> homalg_variable_758 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_757 = homalg_variable_758;
true
gap> homalg_variable_760 := SIH_UnionOfRows(homalg_variable_42,homalg_variable_247);;
gap> homalg_variable_759 := SIH_BasisOfRowModule(homalg_variable_760);;
gap> SI_nrows(homalg_variable_759);
5
gap> homalg_variable_761 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_759 = homalg_variable_761;
false
gap> homalg_variable_762 := SIH_DecideZeroRows(homalg_variable_42,homalg_variable_759);;
gap> homalg_variable_763 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_762 = homalg_variable_763;
true
gap> homalg_variable_765 := SIH_UnionOfRows(homalg_variable_70,homalg_variable_42);;
gap> homalg_variable_764 := SIH_BasisOfRowModule(homalg_variable_765);;
gap> SI_nrows(homalg_variable_764);
5
gap> homalg_variable_766 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_764 = homalg_variable_766;
false
gap> homalg_variable_767 := SIH_DecideZeroRows(homalg_variable_42,homalg_variable_764);;
gap> homalg_variable_768 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_767 = homalg_variable_768;
true
gap> homalg_variable_769 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_765);;
gap> SI_nrows(homalg_variable_769);
2
gap> homalg_variable_770 := SI_matrix(homalg_variable_5,2,7,"0");;
gap> homalg_variable_769 = homalg_variable_770;
false
gap> homalg_variable_771 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_769);;
gap> SI_nrows(homalg_variable_771);
1
gap> homalg_variable_772 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_771 = homalg_variable_772;
true
gap> homalg_variable_773 := SIH_BasisOfRowModule(homalg_variable_769);;
gap> SI_nrows(homalg_variable_773);
2
gap> homalg_variable_774 := SI_matrix(homalg_variable_5,2,7,"0");;
gap> homalg_variable_773 = homalg_variable_774;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_769);; homalg_variable_775 := homalg_variable_l[1];; homalg_variable_776 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_775);
2
gap> homalg_variable_777 := SI_matrix(homalg_variable_5,2,7,"0");;
gap> homalg_variable_775 = homalg_variable_777;
false
gap> SI_ncols(homalg_variable_776);
2
gap> homalg_variable_778 := homalg_variable_776 * homalg_variable_769;;
gap> homalg_variable_775 = homalg_variable_778;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_773,homalg_variable_775);; homalg_variable_779 := homalg_variable_l[1];; homalg_variable_780 := homalg_variable_l[2];;
gap> homalg_variable_781 := SI_matrix(homalg_variable_5,2,7,"0");;
gap> homalg_variable_779 = homalg_variable_781;
true
gap> homalg_variable_782 := homalg_variable_780 * homalg_variable_775;;
gap> homalg_variable_783 := homalg_variable_773 + homalg_variable_782;;
gap> homalg_variable_779 = homalg_variable_783;
true
gap> homalg_variable_784 := SIH_DecideZeroRows(homalg_variable_773,homalg_variable_775);;
gap> homalg_variable_785 := SI_matrix(homalg_variable_5,2,7,"0");;
gap> homalg_variable_784 = homalg_variable_785;
true
gap> homalg_variable_786 := homalg_variable_780 * (homalg_variable_8);;
gap> homalg_variable_787 := homalg_variable_786 * homalg_variable_776;;
gap> homalg_variable_788 := homalg_variable_787 * homalg_variable_769;;
gap> homalg_variable_788 = homalg_variable_773;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_769,homalg_variable_773);; homalg_variable_789 := homalg_variable_l[1];; homalg_variable_790 := homalg_variable_l[2];;
gap> homalg_variable_791 := SI_matrix(homalg_variable_5,2,7,"0");;
gap> homalg_variable_789 = homalg_variable_791;
true
gap> homalg_variable_792 := homalg_variable_790 * homalg_variable_773;;
gap> homalg_variable_793 := homalg_variable_769 + homalg_variable_792;;
gap> homalg_variable_789 = homalg_variable_793;
true
gap> homalg_variable_794 := SIH_DecideZeroRows(homalg_variable_769,homalg_variable_773);;
gap> homalg_variable_795 := SI_matrix(homalg_variable_5,2,7,"0");;
gap> homalg_variable_794 = homalg_variable_795;
true
gap> homalg_variable_796 := homalg_variable_790 * (homalg_variable_8);;
gap> homalg_variable_797 := homalg_variable_796 * homalg_variable_773;;
gap> homalg_variable_797 = homalg_variable_769;
true
gap> SIH_ZeroRows(homalg_variable_769);
[  ]
gap> homalg_variable_798 := SIH_Submatrix(homalg_variable_769,[1..2],[ 3, 4, 5, 6, 7 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_798,homalg_variable_247);; homalg_variable_799 := homalg_variable_l[1];; homalg_variable_800 := homalg_variable_l[2];;
gap> homalg_variable_801 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_799 = homalg_variable_801;
true
gap> homalg_variable_802 := homalg_variable_800 * homalg_variable_247;;
gap> homalg_variable_803 := homalg_variable_798 + homalg_variable_802;;
gap> homalg_variable_799 = homalg_variable_803;
true
gap> homalg_variable_804 := SIH_DecideZeroRows(homalg_variable_798,homalg_variable_247);;
gap> homalg_variable_805 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_804 = homalg_variable_805;
true
gap> homalg_variable_806 := homalg_variable_800 * (homalg_variable_8);;
gap> homalg_variable_807 := homalg_variable_806 * homalg_variable_247;;
gap> homalg_variable_808 := homalg_variable_807 - homalg_variable_798;;
gap> homalg_variable_809 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_808 = homalg_variable_809;
true
gap> homalg_variable_810 := SIH_BasisOfRowModule(homalg_variable_806);;
gap> SI_nrows(homalg_variable_810);
2
gap> homalg_variable_811 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_810 = homalg_variable_811;
false
gap> homalg_variable_810 = homalg_variable_806;
false
gap> homalg_variable_813 := SI_matrix( SI_freemodule( homalg_variable_5,2 ) );;
gap> homalg_variable_812 := SIH_DecideZeroRows(homalg_variable_813,homalg_variable_810);;
gap> homalg_variable_814 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_812 = homalg_variable_814;
true
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_806);; homalg_variable_815 := homalg_variable_l[1];; homalg_variable_816 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_815);
2
gap> homalg_variable_817 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_815 = homalg_variable_817;
false
gap> SI_ncols(homalg_variable_816);
2
gap> homalg_variable_818 := homalg_variable_816 * homalg_variable_806;;
gap> homalg_variable_815 = homalg_variable_818;
true
gap> homalg_variable_815 = homalg_variable_813;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_813,homalg_variable_815);; homalg_variable_819 := homalg_variable_l[1];; homalg_variable_820 := homalg_variable_l[2];;
gap> homalg_variable_821 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_819 = homalg_variable_821;
true
gap> homalg_variable_822 := homalg_variable_820 * homalg_variable_815;;
gap> homalg_variable_823 := homalg_variable_813 + homalg_variable_822;;
gap> homalg_variable_819 = homalg_variable_823;
true
gap> homalg_variable_824 := SIH_DecideZeroRows(homalg_variable_813,homalg_variable_815);;
gap> homalg_variable_825 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_824 = homalg_variable_825;
true
gap> homalg_variable_826 := homalg_variable_820 * (homalg_variable_8);;
gap> homalg_variable_827 := homalg_variable_826 * homalg_variable_816;;
gap> homalg_variable_828 := homalg_variable_827 * homalg_variable_806;;
gap> homalg_variable_829 := homalg_variable_828 - homalg_variable_813;;
gap> homalg_variable_830 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_829 = homalg_variable_830;
true
gap> homalg_variable_832 := homalg_variable_827 * homalg_variable_769;;
gap> homalg_variable_831 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_832);;
gap> SI_nrows(homalg_variable_831);
1
gap> homalg_variable_833 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_831 = homalg_variable_833;
true
gap> homalg_variable_834 := SIH_Submatrix(homalg_variable_832,[1..2],[ 3, 4, 5, 6, 7 ]);;
gap> homalg_variable_835 := homalg_variable_247 - homalg_variable_834;;
gap> homalg_variable_836 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_835 = homalg_variable_836;
true
gap> SIH_ZeroRows(homalg_variable_272);
[  ]
gap> homalg_variable_837 := homalg_variable_274 * homalg_variable_272;;
gap> homalg_variable_838 := SI_matrix(homalg_variable_5,1,6,"0");;
gap> homalg_variable_837 = homalg_variable_838;
true
gap> homalg_variable_839 := SIH_BasisOfRowModule(homalg_variable_274);;
gap> SI_nrows(homalg_variable_839);
1
gap> homalg_variable_840 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_839 = homalg_variable_840;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_274);; homalg_variable_841 := homalg_variable_l[1];; homalg_variable_842 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_841);
1
gap> homalg_variable_843 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_841 = homalg_variable_843;
false
gap> SI_ncols(homalg_variable_842);
1
gap> homalg_variable_844 := homalg_variable_842 * homalg_variable_274;;
gap> homalg_variable_841 = homalg_variable_844;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_839,homalg_variable_841);; homalg_variable_845 := homalg_variable_l[1];; homalg_variable_846 := homalg_variable_l[2];;
gap> homalg_variable_847 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_845 = homalg_variable_847;
true
gap> homalg_variable_848 := homalg_variable_846 * homalg_variable_841;;
gap> homalg_variable_849 := homalg_variable_839 + homalg_variable_848;;
gap> homalg_variable_845 = homalg_variable_849;
true
gap> homalg_variable_850 := SIH_DecideZeroRows(homalg_variable_839,homalg_variable_841);;
gap> homalg_variable_851 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_850 = homalg_variable_851;
true
gap> homalg_variable_852 := homalg_variable_846 * (homalg_variable_8);;
gap> homalg_variable_853 := homalg_variable_852 * homalg_variable_842;;
gap> homalg_variable_854 := homalg_variable_853 * homalg_variable_274;;
gap> homalg_variable_854 = homalg_variable_839;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_274,homalg_variable_839);; homalg_variable_855 := homalg_variable_l[1];; homalg_variable_856 := homalg_variable_l[2];;
gap> homalg_variable_857 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_855 = homalg_variable_857;
true
gap> homalg_variable_858 := homalg_variable_856 * homalg_variable_839;;
gap> homalg_variable_859 := homalg_variable_274 + homalg_variable_858;;
gap> homalg_variable_855 = homalg_variable_859;
true
gap> homalg_variable_860 := SIH_DecideZeroRows(homalg_variable_274,homalg_variable_839);;
gap> homalg_variable_861 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_860 = homalg_variable_861;
true
gap> homalg_variable_862 := homalg_variable_856 * (homalg_variable_8);;
gap> homalg_variable_863 := homalg_variable_862 * homalg_variable_839;;
gap> homalg_variable_863 = homalg_variable_274;
true
gap> homalg_variable_839 = homalg_variable_274;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_10,homalg_variable_282);; homalg_variable_864 := homalg_variable_l[1];; homalg_variable_865 := homalg_variable_l[2];;
gap> homalg_variable_866 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_864 = homalg_variable_866;
true
gap> homalg_variable_867 := homalg_variable_865 * homalg_variable_282;;
gap> homalg_variable_868 := homalg_variable_10 + homalg_variable_867;;
gap> homalg_variable_864 = homalg_variable_868;
true
gap> homalg_variable_869 := SIH_DecideZeroRows(homalg_variable_10,homalg_variable_282);;
gap> homalg_variable_870 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_869 = homalg_variable_870;
true
gap> SI_ncols(homalg_variable_283);
4
gap> SI_nrows(homalg_variable_283);
4
gap> homalg_variable_871 := homalg_variable_865 * (homalg_variable_8);;
gap> homalg_variable_872 := homalg_variable_871 * homalg_variable_283;;
gap> homalg_variable_873 := homalg_variable_872 * homalg_variable_272;;
gap> homalg_variable_874 := homalg_variable_873 - homalg_variable_10;;
gap> homalg_variable_875 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_874 = homalg_variable_875;
true
gap> homalg_variable_877 := homalg_variable_247 * homalg_variable_872;;
gap> homalg_variable_876 := SIH_DecideZeroRows(homalg_variable_877,homalg_variable_839);;
gap> homalg_variable_878 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_876 = homalg_variable_878;
true
gap> homalg_variable_879 := SIH_UnionOfRows(homalg_variable_307,homalg_variable_305);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_879);; homalg_variable_880 := homalg_variable_l[1];; homalg_variable_881 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_880);
4
gap> homalg_variable_882 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_880 = homalg_variable_882;
false
gap> SI_ncols(homalg_variable_881);
9
gap> homalg_variable_883 := SIH_Submatrix(homalg_variable_881,[1..4],[ 1, 2, 3, 4 ]);;
gap> homalg_variable_884 := homalg_variable_883 * homalg_variable_307;;
gap> homalg_variable_885 := SIH_Submatrix(homalg_variable_881,[1..4],[ 5, 6, 7, 8, 9 ]);;
gap> homalg_variable_886 := homalg_variable_885 * homalg_variable_305;;
gap> homalg_variable_887 := homalg_variable_884 + homalg_variable_886;;
gap> homalg_variable_880 = homalg_variable_887;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_307,homalg_variable_880);; homalg_variable_888 := homalg_variable_l[1];; homalg_variable_889 := homalg_variable_l[2];;
gap> homalg_variable_890 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_888 = homalg_variable_890;
true
gap> homalg_variable_891 := homalg_variable_889 * homalg_variable_880;;
gap> homalg_variable_892 := homalg_variable_307 + homalg_variable_891;;
gap> homalg_variable_888 = homalg_variable_892;
true
gap> homalg_variable_893 := SIH_DecideZeroRows(homalg_variable_307,homalg_variable_880);;
gap> homalg_variable_894 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_893 = homalg_variable_894;
true
gap> homalg_variable_896 := homalg_variable_889 * (homalg_variable_8);;
gap> homalg_variable_897 := SIH_Submatrix(homalg_variable_881,[1..4],[ 1, 2, 3, 4 ]);;
gap> homalg_variable_898 := homalg_variable_896 * homalg_variable_897;;
gap> homalg_variable_899 := homalg_variable_898 * homalg_variable_307;;
gap> homalg_variable_900 := homalg_variable_899 - homalg_variable_272;;
gap> homalg_variable_895 := SIH_DecideZeroRows(homalg_variable_900,homalg_variable_305);;
gap> homalg_variable_901 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_895 = homalg_variable_901;
true
gap> homalg_variable_903 := homalg_variable_839 * homalg_variable_898;;
gap> homalg_variable_902 := SIH_DecideZeroRows(homalg_variable_903,homalg_variable_371);;
gap> homalg_variable_904 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_902 = homalg_variable_904;
true
gap> homalg_variable_905 := SIH_DecideZeroRows(homalg_variable_898,homalg_variable_371);;
gap> homalg_variable_906 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_905 = homalg_variable_906;
false
gap> homalg_variable_907 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_898 = homalg_variable_907;
false
gap> homalg_variable_908 := SIH_UnionOfRows(homalg_variable_905,homalg_variable_371);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_908);; homalg_variable_909 := homalg_variable_l[1];; homalg_variable_910 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_909);
4
gap> homalg_variable_911 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_909 = homalg_variable_911;
false
gap> SI_ncols(homalg_variable_910);
11
gap> homalg_variable_912 := SIH_Submatrix(homalg_variable_910,[1..4],[ 1, 2, 3, 4 ]);;
gap> homalg_variable_913 := homalg_variable_912 * homalg_variable_905;;
gap> homalg_variable_914 := SIH_Submatrix(homalg_variable_910,[1..4],[ 5, 6, 7, 8, 9, 10, 11 ]);;
gap> homalg_variable_915 := homalg_variable_914 * homalg_variable_371;;
gap> homalg_variable_916 := homalg_variable_913 + homalg_variable_915;;
gap> homalg_variable_909 = homalg_variable_916;
true
gap> homalg_variable_918 := SI_matrix( SI_freemodule( homalg_variable_5,4 ) );;
gap> homalg_variable_917 := SIH_DecideZeroRows(homalg_variable_918,homalg_variable_371);;
gap> homalg_variable_919 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_917 = homalg_variable_919;
false
gap> homalg_variable_909 = homalg_variable_918;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_917,homalg_variable_909);; homalg_variable_920 := homalg_variable_l[1];; homalg_variable_921 := homalg_variable_l[2];;
gap> homalg_variable_922 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_920 = homalg_variable_922;
true
gap> homalg_variable_923 := homalg_variable_921 * homalg_variable_909;;
gap> homalg_variable_924 := homalg_variable_917 + homalg_variable_923;;
gap> homalg_variable_920 = homalg_variable_924;
true
gap> homalg_variable_925 := SIH_DecideZeroRows(homalg_variable_917,homalg_variable_909);;
gap> homalg_variable_926 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_925 = homalg_variable_926;
true
gap> homalg_variable_928 := homalg_variable_921 * (homalg_variable_8);;
gap> homalg_variable_929 := SIH_Submatrix(homalg_variable_910,[1..4],[ 1, 2, 3, 4 ]);;
gap> homalg_variable_930 := homalg_variable_928 * homalg_variable_929;;
gap> homalg_variable_931 := homalg_variable_930 * homalg_variable_898;;
gap> homalg_variable_932 := homalg_variable_931 - homalg_variable_918;;
gap> homalg_variable_927 := SIH_DecideZeroRows(homalg_variable_932,homalg_variable_371);;
gap> homalg_variable_933 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_927 = homalg_variable_933;
true
gap> homalg_variable_935 := SIH_UnionOfRows(homalg_variable_872,homalg_variable_930);;
gap> homalg_variable_936 := SIH_UnionOfRows(homalg_variable_935,homalg_variable_839);;
gap> homalg_variable_934 := SIH_BasisOfRowModule(homalg_variable_936);;
gap> SI_nrows(homalg_variable_934);
4
gap> homalg_variable_937 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_934 = homalg_variable_937;
false
gap> homalg_variable_938 := SIH_DecideZeroRows(homalg_variable_918,homalg_variable_934);;
gap> homalg_variable_939 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_938 = homalg_variable_939;
true
gap> homalg_variable_940 := SIH_RelativeSyzygiesGeneratorsOfRows(homalg_variable_935,homalg_variable_839);;
gap> SI_nrows(homalg_variable_940);
9
gap> homalg_variable_941 := SI_matrix(homalg_variable_5,9,9,"0");;
gap> homalg_variable_940 = homalg_variable_941;
false
gap> homalg_variable_942 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_940);;
gap> SI_nrows(homalg_variable_942);
3
gap> homalg_variable_943 := SI_matrix(homalg_variable_5,3,9,"0");;
gap> homalg_variable_942 = homalg_variable_943;
false
gap> homalg_variable_944 := SI_\[(homalg_variable_942,1,9);;
gap> SI_deg( homalg_variable_944 );
1
gap> homalg_variable_945 := SI_\[(homalg_variable_942,1,8);;
gap> SI_deg( homalg_variable_945 );
-1
gap> homalg_variable_946 := SI_\[(homalg_variable_942,1,7);;
gap> SI_deg( homalg_variable_946 );
1
gap> homalg_variable_947 := SI_\[(homalg_variable_942,1,6);;
gap> SI_deg( homalg_variable_947 );
-1
gap> homalg_variable_948 := SI_\[(homalg_variable_942,1,5);;
gap> SI_deg( homalg_variable_948 );
-1
gap> homalg_variable_949 := SI_\[(homalg_variable_942,1,4);;
gap> SI_deg( homalg_variable_949 );
0
gap> homalg_variable_950 := SI_\[(homalg_variable_942,1,1);;
gap> IsZero(homalg_variable_950);
true
gap> homalg_variable_951 := SI_\[(homalg_variable_942,1,2);;
gap> IsZero(homalg_variable_951);
true
gap> homalg_variable_952 := SI_\[(homalg_variable_942,1,3);;
gap> IsZero(homalg_variable_952);
true
gap> homalg_variable_953 := SI_\[(homalg_variable_942,1,4);;
gap> IsZero(homalg_variable_953);
false
gap> homalg_variable_954 := SI_\[(homalg_variable_942,1,5);;
gap> IsZero(homalg_variable_954);
true
gap> homalg_variable_955 := SI_\[(homalg_variable_942,1,6);;
gap> IsZero(homalg_variable_955);
true
gap> homalg_variable_956 := SI_\[(homalg_variable_942,1,7);;
gap> IsZero(homalg_variable_956);
false
gap> homalg_variable_957 := SI_\[(homalg_variable_942,1,8);;
gap> IsZero(homalg_variable_957);
true
gap> homalg_variable_958 := SI_\[(homalg_variable_942,1,9);;
gap> IsZero(homalg_variable_958);
false
gap> homalg_variable_959 := SI_\[(homalg_variable_942,2,8);;
gap> SI_deg( homalg_variable_959 );
0
gap> homalg_variable_960 := SI_\[(homalg_variable_942,2,1);;
gap> IsZero(homalg_variable_960);
true
gap> homalg_variable_961 := SI_\[(homalg_variable_942,2,2);;
gap> IsZero(homalg_variable_961);
true
gap> homalg_variable_962 := SI_\[(homalg_variable_942,2,3);;
gap> IsZero(homalg_variable_962);
false
gap> homalg_variable_963 := SI_\[(homalg_variable_942,2,5);;
gap> IsZero(homalg_variable_963);
true
gap> homalg_variable_964 := SI_\[(homalg_variable_942,2,6);;
gap> IsZero(homalg_variable_964);
false
gap> homalg_variable_965 := SI_\[(homalg_variable_942,2,8);;
gap> IsZero(homalg_variable_965);
false
gap> homalg_variable_966 := SI_\[(homalg_variable_942,3,5);;
gap> SI_deg( homalg_variable_966 );
0
gap> homalg_variable_967 := SI_\[(homalg_variable_942,3,1);;
gap> IsZero(homalg_variable_967);
false
gap> homalg_variable_968 := SI_\[(homalg_variable_942,3,2);;
gap> IsZero(homalg_variable_968);
false
gap> homalg_variable_969 := SI_\[(homalg_variable_942,3,5);;
gap> IsZero(homalg_variable_969);
false
gap> homalg_variable_971 := SIH_Submatrix(homalg_variable_940,[ 1, 2, 3, 6, 7, 9 ],[1..9]);;
gap> homalg_variable_970 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_971);;
gap> SI_nrows(homalg_variable_970);
1
gap> homalg_variable_972 := SI_matrix(homalg_variable_5,1,6,"0");;
gap> homalg_variable_970 = homalg_variable_972;
true
gap> homalg_variable_973 := SIH_BasisOfRowModule(homalg_variable_940);;
gap> SI_nrows(homalg_variable_973);
9
gap> homalg_variable_974 := SI_matrix(homalg_variable_5,9,9,"0");;
gap> homalg_variable_973 = homalg_variable_974;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_971);; homalg_variable_975 := homalg_variable_l[1];; homalg_variable_976 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_975);
9
gap> homalg_variable_977 := SI_matrix(homalg_variable_5,9,9,"0");;
gap> homalg_variable_975 = homalg_variable_977;
false
gap> SI_ncols(homalg_variable_976);
6
gap> homalg_variable_978 := homalg_variable_976 * homalg_variable_971;;
gap> homalg_variable_975 = homalg_variable_978;
true
gap> homalg_variable_979 := SI_matrix( SI_freemodule( homalg_variable_5,9 ) );;
gap> homalg_variable_975 = homalg_variable_979;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_973,homalg_variable_975);; homalg_variable_980 := homalg_variable_l[1];; homalg_variable_981 := homalg_variable_l[2];;
gap> homalg_variable_982 := SI_matrix(homalg_variable_5,9,9,"0");;
gap> homalg_variable_980 = homalg_variable_982;
true
gap> homalg_variable_983 := homalg_variable_981 * homalg_variable_975;;
gap> homalg_variable_984 := homalg_variable_973 + homalg_variable_983;;
gap> homalg_variable_980 = homalg_variable_984;
true
gap> homalg_variable_985 := SIH_DecideZeroRows(homalg_variable_973,homalg_variable_975);;
gap> homalg_variable_986 := SI_matrix(homalg_variable_5,9,9,"0");;
gap> homalg_variable_985 = homalg_variable_986;
true
gap> homalg_variable_987 := homalg_variable_981 * (homalg_variable_8);;
gap> homalg_variable_988 := homalg_variable_987 * homalg_variable_976;;
gap> homalg_variable_989 := homalg_variable_988 * homalg_variable_971;;
gap> homalg_variable_989 = homalg_variable_973;
true
gap> homalg_variable_990 := SI_matrix( SI_freemodule( homalg_variable_5,9 ) );;
gap> homalg_variable_973 = homalg_variable_990;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_971,homalg_variable_973);; homalg_variable_991 := homalg_variable_l[1];; homalg_variable_992 := homalg_variable_l[2];;
gap> homalg_variable_993 := SI_matrix(homalg_variable_5,6,9,"0");;
gap> homalg_variable_991 = homalg_variable_993;
true
gap> homalg_variable_994 := homalg_variable_992 * homalg_variable_973;;
gap> homalg_variable_995 := homalg_variable_971 + homalg_variable_994;;
gap> homalg_variable_991 = homalg_variable_995;
true
gap> homalg_variable_996 := SIH_DecideZeroRows(homalg_variable_971,homalg_variable_973);;
gap> homalg_variable_997 := SI_matrix(homalg_variable_5,6,9,"0");;
gap> homalg_variable_996 = homalg_variable_997;
true
gap> homalg_variable_998 := homalg_variable_992 * (homalg_variable_8);;
gap> homalg_variable_999 := homalg_variable_998 * homalg_variable_973;;
gap> homalg_variable_999 = homalg_variable_971;
true
gap> SIH_ZeroRows(homalg_variable_971);
[  ]
gap> SIH_ZeroRows(homalg_variable_506);
[  ]
gap> homalg_variable_1000 := homalg_variable_505 * homalg_variable_506;;
gap> for _del in [ "homalg_variable_452", "homalg_variable_453", "homalg_variable_454", "homalg_variable_456", "homalg_variable_459", "homalg_variable_460", "homalg_variable_461", "homalg_variable_462", "homalg_variable_463", "homalg_variable_464", "homalg_variable_465", "homalg_variable_466", "homalg_variable_467", "homalg_variable_468", "homalg_variable_469", "homalg_variable_470", "homalg_variable_471", "homalg_variable_472", "homalg_variable_473", "homalg_variable_474", "homalg_variable_475", "homalg_variable_476", "homalg_variable_477", "homalg_variable_478", "homalg_variable_479", "homalg_variable_481", "homalg_variable_482", "homalg_variable_483", "homalg_variable_485", "homalg_variable_486", "homalg_variable_487", "homalg_variable_488", "homalg_variable_489", "homalg_variable_490", "homalg_variable_491", "homalg_variable_492", "homalg_variable_493", "homalg_variable_494", "homalg_variable_495", "homalg_variable_496", "homalg_variable_497", "homalg_variable_498", "homalg_variable_499", "homalg_variable_500", "homalg_variable_501", "homalg_variable_502", "homalg_variable_503", "homalg_variable_504", "homalg_variable_507", "homalg_variable_508", "homalg_variable_509", "homalg_variable_510", "homalg_variable_511", "homalg_variable_512", "homalg_variable_513", "homalg_variable_516", "homalg_variable_517", "homalg_variable_518", "homalg_variable_519", "homalg_variable_520", "homalg_variable_521", "homalg_variable_522", "homalg_variable_523", "homalg_variable_524", "homalg_variable_525", "homalg_variable_526", "homalg_variable_527", "homalg_variable_530", "homalg_variable_531", "homalg_variable_532", "homalg_variable_533", "homalg_variable_534", "homalg_variable_538", "homalg_variable_541", "homalg_variable_542", "homalg_variable_543", "homalg_variable_544", "homalg_variable_545", "homalg_variable_546", "homalg_variable_547", "homalg_variable_548", "homalg_variable_549", "homalg_variable_550", "homalg_variable_551", "homalg_variable_552", "homalg_variable_553", "homalg_variable_554", "homalg_variable_555", "homalg_variable_556", "homalg_variable_557", "homalg_variable_558", "homalg_variable_559", "homalg_variable_560", "homalg_variable_561", "homalg_variable_562", "homalg_variable_563", "homalg_variable_565", "homalg_variable_566", "homalg_variable_567", "homalg_variable_568", "homalg_variable_569", "homalg_variable_570", "homalg_variable_571", "homalg_variable_572", "homalg_variable_573", "homalg_variable_574", "homalg_variable_575", "homalg_variable_576", "homalg_variable_577", "homalg_variable_578", "homalg_variable_579", "homalg_variable_580", "homalg_variable_581", "homalg_variable_584", "homalg_variable_585", "homalg_variable_586", "homalg_variable_587", "homalg_variable_588", "homalg_variable_589", "homalg_variable_590", "homalg_variable_591", "homalg_variable_592", "homalg_variable_593", "homalg_variable_594", "homalg_variable_595", "homalg_variable_596", "homalg_variable_597", "homalg_variable_600", "homalg_variable_601", "homalg_variable_602", "homalg_variable_603", "homalg_variable_604", "homalg_variable_605", "homalg_variable_606", "homalg_variable_607", "homalg_variable_608", "homalg_variable_609", "homalg_variable_610", "homalg_variable_611", "homalg_variable_614", "homalg_variable_615", "homalg_variable_616", "homalg_variable_620", "homalg_variable_622", "homalg_variable_623", "homalg_variable_624", "homalg_variable_625", "homalg_variable_627", "homalg_variable_630", "homalg_variable_631", "homalg_variable_632", "homalg_variable_633", "homalg_variable_634", "homalg_variable_635", "homalg_variable_636", "homalg_variable_637", "homalg_variable_638", "homalg_variable_639", "homalg_variable_640", "homalg_variable_641", "homalg_variable_642", "homalg_variable_643", "homalg_variable_644", "homalg_variable_645", "homalg_variable_646", "homalg_variable_647", "homalg_variable_648", "homalg_variable_649", "homalg_variable_650", "homalg_variable_652", "homalg_variable_655", "homalg_variable_656", "homalg_variable_657", "homalg_variable_658", "homalg_variable_659", "homalg_variable_660", "homalg_variable_661", "homalg_variable_662", "homalg_variable_663", "homalg_variable_664", "homalg_variable_665", "homalg_variable_666", "homalg_variable_667", "homalg_variable_668", "homalg_variable_669", "homalg_variable_670", "homalg_variable_671", "homalg_variable_672", "homalg_variable_673", "homalg_variable_674", "homalg_variable_675", "homalg_variable_676", "homalg_variable_677", "homalg_variable_678", "homalg_variable_679", "homalg_variable_681", "homalg_variable_682", "homalg_variable_683", "homalg_variable_684", "homalg_variable_685", "homalg_variable_686", "homalg_variable_687", "homalg_variable_688", "homalg_variable_689", "homalg_variable_690", "homalg_variable_692", "homalg_variable_693", "homalg_variable_694", "homalg_variable_695", "homalg_variable_697", "homalg_variable_700", "homalg_variable_701", "homalg_variable_702", "homalg_variable_703", "homalg_variable_704", "homalg_variable_705", "homalg_variable_706", "homalg_variable_707", "homalg_variable_708", "homalg_variable_709", "homalg_variable_710", "homalg_variable_711", "homalg_variable_712", "homalg_variable_713", "homalg_variable_714", "homalg_variable_715", "homalg_variable_716", "homalg_variable_717", "homalg_variable_718", "homalg_variable_719", "homalg_variable_720", "homalg_variable_721", "homalg_variable_723", "homalg_variable_726", "homalg_variable_727", "homalg_variable_728", "homalg_variable_729", "homalg_variable_730", "homalg_variable_731", "homalg_variable_732", "homalg_variable_733", "homalg_variable_734", "homalg_variable_735", "homalg_variable_736", "homalg_variable_737", "homalg_variable_738", "homalg_variable_739", "homalg_variable_740", "homalg_variable_741", "homalg_variable_742", "homalg_variable_743", "homalg_variable_744", "homalg_variable_745", "homalg_variable_746", "homalg_variable_747", "homalg_variable_748", "homalg_variable_749", "homalg_variable_750", "homalg_variable_751", "homalg_variable_752", "homalg_variable_753", "homalg_variable_754", "homalg_variable_755", "homalg_variable_756", "homalg_variable_757", "homalg_variable_758", "homalg_variable_761", "homalg_variable_762", "homalg_variable_763", "homalg_variable_766", "homalg_variable_767", "homalg_variable_768", "homalg_variable_770", "homalg_variable_771", "homalg_variable_772", "homalg_variable_774", "homalg_variable_777", "homalg_variable_778", "homalg_variable_779", "homalg_variable_780", "homalg_variable_781", "homalg_variable_782", "homalg_variable_783", "homalg_variable_784", "homalg_variable_785", "homalg_variable_786", "homalg_variable_787", "homalg_variable_788", "homalg_variable_789", "homalg_variable_790", "homalg_variable_791", "homalg_variable_792", "homalg_variable_793", "homalg_variable_794", "homalg_variable_795", "homalg_variable_796", "homalg_variable_797", "homalg_variable_801", "homalg_variable_802", "homalg_variable_803", "homalg_variable_805", "homalg_variable_807", "homalg_variable_808", "homalg_variable_809", "homalg_variable_811", "homalg_variable_812", "homalg_variable_814", "homalg_variable_817", "homalg_variable_818", "homalg_variable_819", "homalg_variable_821", "homalg_variable_822", "homalg_variable_823", "homalg_variable_824", "homalg_variable_825", "homalg_variable_828", "homalg_variable_829", "homalg_variable_830", "homalg_variable_831", "homalg_variable_833", "homalg_variable_834", "homalg_variable_835", "homalg_variable_836", "homalg_variable_837", "homalg_variable_838", "homalg_variable_840", "homalg_variable_843", "homalg_variable_844", "homalg_variable_845", "homalg_variable_846", "homalg_variable_847", "homalg_variable_848", "homalg_variable_849", "homalg_variable_850", "homalg_variable_851", "homalg_variable_852", "homalg_variable_853", "homalg_variable_854", "homalg_variable_855", "homalg_variable_856", "homalg_variable_857", "homalg_variable_858", "homalg_variable_859", "homalg_variable_860", "homalg_variable_861", "homalg_variable_862", "homalg_variable_863", "homalg_variable_864", "homalg_variable_866", "homalg_variable_867", "homalg_variable_868", "homalg_variable_869", "homalg_variable_870", "homalg_variable_873", "homalg_variable_874", "homalg_variable_875", "homalg_variable_876", "homalg_variable_877", "homalg_variable_878", "homalg_variable_882", "homalg_variable_883", "homalg_variable_884", "homalg_variable_885", "homalg_variable_886", "homalg_variable_887", "homalg_variable_890", "homalg_variable_891", "homalg_variable_892", "homalg_variable_893", "homalg_variable_894", "homalg_variable_901", "homalg_variable_902", "homalg_variable_903", "homalg_variable_904", "homalg_variable_905", "homalg_variable_906", "homalg_variable_907", "homalg_variable_908", "homalg_variable_909", "homalg_variable_911", "homalg_variable_912", "homalg_variable_913", "homalg_variable_914", "homalg_variable_915", "homalg_variable_916", "homalg_variable_917", "homalg_variable_919", "homalg_variable_920", "homalg_variable_922", "homalg_variable_923", "homalg_variable_924", "homalg_variable_925", "homalg_variable_926", "homalg_variable_927", "homalg_variable_931", "homalg_variable_932", "homalg_variable_933", "homalg_variable_937", "homalg_variable_938", "homalg_variable_939", "homalg_variable_941", "homalg_variable_943", "homalg_variable_944", "homalg_variable_945", "homalg_variable_946", "homalg_variable_947", "homalg_variable_948", "homalg_variable_949", "homalg_variable_950", "homalg_variable_951", "homalg_variable_952", "homalg_variable_953", "homalg_variable_954", "homalg_variable_955", "homalg_variable_956", "homalg_variable_957", "homalg_variable_958", "homalg_variable_959", "homalg_variable_960", "homalg_variable_961", "homalg_variable_962", "homalg_variable_963", "homalg_variable_964", "homalg_variable_965", "homalg_variable_966", "homalg_variable_967", "homalg_variable_968", "homalg_variable_969", "homalg_variable_970", "homalg_variable_972", "homalg_variable_974", "homalg_variable_977", "homalg_variable_978", "homalg_variable_979", "homalg_variable_980", "homalg_variable_981", "homalg_variable_982", "homalg_variable_983", "homalg_variable_984", "homalg_variable_985", "homalg_variable_986", "homalg_variable_987", "homalg_variable_988", "homalg_variable_989" ] do UnbindGlobal( _del );; od;;
gap> homalg_variable_1001 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1000 = homalg_variable_1001;
true
gap> homalg_variable_1002 := SIH_DecideZeroRows(homalg_variable_505,homalg_variable_537);;
gap> homalg_variable_1003 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_1002 = homalg_variable_1003;
true
gap> homalg_variable_1004 := SIH_Submatrix(homalg_variable_971,[1..6],[ 6, 7, 8, 9 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1004,homalg_variable_514);; homalg_variable_1005 := homalg_variable_l[1];; homalg_variable_1006 := homalg_variable_l[2];;
gap> homalg_variable_1007 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_1005 = homalg_variable_1007;
true
gap> homalg_variable_1008 := homalg_variable_1006 * homalg_variable_514;;
gap> homalg_variable_1009 := homalg_variable_1004 + homalg_variable_1008;;
gap> homalg_variable_1005 = homalg_variable_1009;
true
gap> homalg_variable_1010 := SIH_DecideZeroRows(homalg_variable_1004,homalg_variable_514);;
gap> homalg_variable_1011 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_1010 = homalg_variable_1011;
true
gap> SI_ncols(homalg_variable_515);
5
gap> SI_nrows(homalg_variable_515);
7
gap> homalg_variable_1012 := homalg_variable_1006 * (homalg_variable_8);;
gap> homalg_variable_1013 := homalg_variable_1012 * homalg_variable_515;;
gap> homalg_variable_1014 := homalg_variable_1013 * homalg_variable_506;;
gap> homalg_variable_1015 := homalg_variable_1014 - homalg_variable_1004;;
gap> homalg_variable_1016 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_1015 = homalg_variable_1016;
true
gap> homalg_variable_1017 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_1018 := SIH_UnionOfColumns(homalg_variable_247,homalg_variable_1017);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1018,homalg_variable_975);; homalg_variable_1019 := homalg_variable_l[1];; homalg_variable_1020 := homalg_variable_l[2];;
gap> homalg_variable_1021 := SI_matrix(homalg_variable_5,2,9,"0");;
gap> homalg_variable_1019 = homalg_variable_1021;
true
gap> homalg_variable_1022 := homalg_variable_1020 * homalg_variable_975;;
gap> homalg_variable_1023 := homalg_variable_1018 + homalg_variable_1022;;
gap> homalg_variable_1019 = homalg_variable_1023;
true
gap> homalg_variable_1024 := SIH_DecideZeroRows(homalg_variable_1018,homalg_variable_975);;
gap> homalg_variable_1025 := SI_matrix(homalg_variable_5,2,9,"0");;
gap> homalg_variable_1024 = homalg_variable_1025;
true
gap> SI_ncols(homalg_variable_976);
6
gap> SI_nrows(homalg_variable_976);
9
gap> homalg_variable_1026 := homalg_variable_1020 * (homalg_variable_8);;
gap> homalg_variable_1027 := homalg_variable_1026 * homalg_variable_976;;
gap> homalg_variable_1028 := homalg_variable_1027 * homalg_variable_971;;
gap> homalg_variable_1029 := homalg_variable_1028 - homalg_variable_1018;;
gap> homalg_variable_1030 := SI_matrix(homalg_variable_5,2,9,"0");;
gap> homalg_variable_1029 = homalg_variable_1030;
true
gap> homalg_variable_1031 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1027);;
gap> SI_nrows(homalg_variable_1031);
1
gap> homalg_variable_1032 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_1031 = homalg_variable_1032;
true
gap> homalg_variable_1034 := SIH_UnionOfRows(homalg_variable_1013,homalg_variable_537);;
gap> homalg_variable_1033 := SIH_BasisOfRowModule(homalg_variable_1034);;
gap> SI_nrows(homalg_variable_1033);
5
gap> homalg_variable_1035 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_1033 = homalg_variable_1035;
false
gap> homalg_variable_1036 := SIH_DecideZeroRows(homalg_variable_42,homalg_variable_1033);;
gap> homalg_variable_1037 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_1036 = homalg_variable_1037;
true
gap> homalg_variable_1039 := SIH_UnionOfRows(homalg_variable_42,homalg_variable_537);;
gap> homalg_variable_1038 := SIH_BasisOfRowModule(homalg_variable_1039);;
gap> SI_nrows(homalg_variable_1038);
5
gap> homalg_variable_1040 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_1038 = homalg_variable_1040;
false
gap> homalg_variable_1041 := SIH_DecideZeroRows(homalg_variable_42,homalg_variable_1038);;
gap> homalg_variable_1042 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_1041 = homalg_variable_1042;
true
gap> homalg_variable_1043 := SIH_DecideZeroRows(homalg_variable_1013,homalg_variable_537);;
gap> homalg_variable_1044 := SI_matrix(homalg_variable_5,6,5,"0");;
gap> homalg_variable_1043 = homalg_variable_1044;
false
gap> homalg_variable_1045 := SI_matrix(homalg_variable_5,6,5,"0");;
gap> homalg_variable_1013 = homalg_variable_1045;
false
gap> homalg_variable_1046 := SIH_UnionOfRows(homalg_variable_1043,homalg_variable_537);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1046);; homalg_variable_1047 := homalg_variable_l[1];; homalg_variable_1048 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1047);
5
gap> homalg_variable_1049 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_1047 = homalg_variable_1049;
false
gap> SI_ncols(homalg_variable_1048);
7
gap> homalg_variable_1050 := SIH_Submatrix(homalg_variable_1048,[1..5],[ 1, 2, 3, 4, 5, 6 ]);;
gap> homalg_variable_1051 := homalg_variable_1050 * homalg_variable_1043;;
gap> homalg_variable_1052 := SIH_Submatrix(homalg_variable_1048,[1..5],[ 7 ]);;
gap> homalg_variable_1053 := homalg_variable_1052 * homalg_variable_537;;
gap> homalg_variable_1054 := homalg_variable_1051 + homalg_variable_1053;;
gap> homalg_variable_1047 = homalg_variable_1054;
true
gap> homalg_variable_1055 := SIH_DecideZeroRows(homalg_variable_42,homalg_variable_537);;
gap> homalg_variable_1056 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_1055 = homalg_variable_1056;
false
gap> homalg_variable_1047 = homalg_variable_42;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1055,homalg_variable_1047);; homalg_variable_1057 := homalg_variable_l[1];; homalg_variable_1058 := homalg_variable_l[2];;
gap> homalg_variable_1059 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_1057 = homalg_variable_1059;
true
gap> homalg_variable_1060 := homalg_variable_1058 * homalg_variable_1047;;
gap> homalg_variable_1061 := homalg_variable_1055 + homalg_variable_1060;;
gap> homalg_variable_1057 = homalg_variable_1061;
true
gap> homalg_variable_1062 := SIH_DecideZeroRows(homalg_variable_1055,homalg_variable_1047);;
gap> homalg_variable_1063 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_1062 = homalg_variable_1063;
true
gap> homalg_variable_1065 := homalg_variable_1058 * (homalg_variable_8);;
gap> homalg_variable_1066 := SIH_Submatrix(homalg_variable_1048,[1..5],[ 1, 2, 3, 4, 5, 6 ]);;
gap> homalg_variable_1067 := homalg_variable_1065 * homalg_variable_1066;;
gap> homalg_variable_1068 := homalg_variable_1067 * homalg_variable_1013;;
gap> homalg_variable_1069 := homalg_variable_1068 - homalg_variable_42;;
gap> homalg_variable_1064 := SIH_DecideZeroRows(homalg_variable_1069,homalg_variable_537);;
gap> homalg_variable_1070 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_1064 = homalg_variable_1070;
true
gap> homalg_variable_1072 := homalg_variable_1027 * homalg_variable_971;;
gap> homalg_variable_1073 := homalg_variable_1067 * homalg_variable_971;;
gap> homalg_variable_1074 := SIH_UnionOfRows(homalg_variable_1072,homalg_variable_1073);;
gap> homalg_variable_1071 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1074);;
gap> SI_nrows(homalg_variable_1071);
1
gap> homalg_variable_1075 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1071 = homalg_variable_1075;
false
gap> homalg_variable_1076 := SIH_BasisOfRowModule(homalg_variable_1071);;
gap> SI_nrows(homalg_variable_1076);
1
gap> homalg_variable_1077 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1076 = homalg_variable_1077;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1071);; homalg_variable_1078 := homalg_variable_l[1];; homalg_variable_1079 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1078);
1
gap> homalg_variable_1080 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1078 = homalg_variable_1080;
false
gap> SI_ncols(homalg_variable_1079);
1
gap> homalg_variable_1081 := homalg_variable_1079 * homalg_variable_1071;;
gap> homalg_variable_1078 = homalg_variable_1081;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1076,homalg_variable_1078);; homalg_variable_1082 := homalg_variable_l[1];; homalg_variable_1083 := homalg_variable_l[2];;
gap> homalg_variable_1084 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1082 = homalg_variable_1084;
true
gap> homalg_variable_1085 := homalg_variable_1083 * homalg_variable_1078;;
gap> homalg_variable_1086 := homalg_variable_1076 + homalg_variable_1085;;
gap> homalg_variable_1082 = homalg_variable_1086;
true
gap> homalg_variable_1087 := SIH_DecideZeroRows(homalg_variable_1076,homalg_variable_1078);;
gap> homalg_variable_1088 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1087 = homalg_variable_1088;
true
gap> homalg_variable_1089 := homalg_variable_1083 * (homalg_variable_8);;
gap> homalg_variable_1090 := homalg_variable_1089 * homalg_variable_1079;;
gap> homalg_variable_1091 := homalg_variable_1090 * homalg_variable_1071;;
gap> homalg_variable_1091 = homalg_variable_1076;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1071,homalg_variable_1076);; homalg_variable_1092 := homalg_variable_l[1];; homalg_variable_1093 := homalg_variable_l[2];;
gap> homalg_variable_1094 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1092 = homalg_variable_1094;
true
gap> homalg_variable_1095 := homalg_variable_1093 * homalg_variable_1076;;
gap> homalg_variable_1096 := homalg_variable_1071 + homalg_variable_1095;;
gap> homalg_variable_1092 = homalg_variable_1096;
true
gap> homalg_variable_1097 := SIH_DecideZeroRows(homalg_variable_1071,homalg_variable_1076);;
gap> homalg_variable_1098 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1097 = homalg_variable_1098;
true
gap> homalg_variable_1099 := homalg_variable_1093 * (homalg_variable_8);;
gap> homalg_variable_1100 := homalg_variable_1099 * homalg_variable_1076;;
gap> homalg_variable_1100 = homalg_variable_1071;
true
gap> homalg_variable_1101 := SIH_Submatrix(homalg_variable_1071,[1..1],[ 3, 4, 5, 6, 7 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1101,homalg_variable_505);; homalg_variable_1102 := homalg_variable_l[1];; homalg_variable_1103 := homalg_variable_l[2];;
gap> homalg_variable_1104 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_1102 = homalg_variable_1104;
true
gap> homalg_variable_1105 := homalg_variable_1103 * homalg_variable_505;;
gap> homalg_variable_1106 := homalg_variable_1101 + homalg_variable_1105;;
gap> homalg_variable_1102 = homalg_variable_1106;
true
gap> homalg_variable_1107 := SIH_DecideZeroRows(homalg_variable_1101,homalg_variable_505);;
gap> homalg_variable_1108 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_1107 = homalg_variable_1108;
true
gap> homalg_variable_1109 := homalg_variable_1103 * (homalg_variable_8);;
gap> homalg_variable_1110 := homalg_variable_1109 * homalg_variable_505;;
gap> homalg_variable_1111 := homalg_variable_1110 - homalg_variable_1101;;
gap> homalg_variable_1112 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_1111 = homalg_variable_1112;
true
gap> homalg_variable_1113 := SIH_BasisOfRowModule(homalg_variable_1109);;
gap> SI_nrows(homalg_variable_1113);
1
gap> homalg_variable_1114 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_1113 = homalg_variable_1114;
false
gap> homalg_variable_1113 = homalg_variable_1109;
true
gap> homalg_variable_1115 := SIH_DecideZeroRows(homalg_variable_237,homalg_variable_1113);;
gap> homalg_variable_1116 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_1115 = homalg_variable_1116;
true
gap> homalg_variable_1109 = homalg_variable_237;
true
gap> homalg_variable_1117 := homalg_variable_1109 - homalg_variable_237;;
gap> homalg_variable_1118 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_1117 = homalg_variable_1118;
true
gap> homalg_variable_1119 := SIH_Submatrix(homalg_variable_1071,[1..1],[ 1, 2 ]);;
gap> homalg_variable_1120 := homalg_variable_1119 * homalg_variable_1072;;
gap> homalg_variable_1121 := SIH_Submatrix(homalg_variable_1071,[1..1],[ 3, 4, 5, 6, 7 ]);;
gap> homalg_variable_1122 := homalg_variable_1121 * homalg_variable_1073;;
gap> homalg_variable_1123 := homalg_variable_1120 + homalg_variable_1122;;
gap> homalg_variable_1124 := SI_matrix(homalg_variable_5,1,9,"0");;
gap> homalg_variable_1123 = homalg_variable_1124;
true
gap> homalg_variable_1125 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_1126 := SIH_UnionOfRows(homalg_variable_1125,homalg_variable_506);;
gap> homalg_variable_1127 := SIH_Submatrix(homalg_variable_1072,[1..2],[ 6, 7, 8, 9 ]);;
gap> homalg_variable_1128 := SIH_Submatrix(homalg_variable_1073,[1..5],[ 6, 7, 8, 9 ]);;
gap> homalg_variable_1129 := SIH_UnionOfRows(homalg_variable_1127,homalg_variable_1128);;
gap> homalg_variable_1130 := homalg_variable_1126 - homalg_variable_1129;;
gap> homalg_variable_1131 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_1130 = homalg_variable_1131;
true
gap> homalg_variable_1132 := SIH_Submatrix(homalg_variable_1071,[1..1],[ 3, 4, 5, 6, 7 ]);;
gap> homalg_variable_1133 := homalg_variable_505 - homalg_variable_1132;;
gap> homalg_variable_1134 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_1133 = homalg_variable_1134;
true
gap> homalg_variable_1135 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_1136 := SIH_UnionOfColumns(homalg_variable_247,homalg_variable_1135);;
gap> homalg_variable_1137 := homalg_variable_1072 - homalg_variable_1136;;
gap> homalg_variable_1138 := SI_matrix(homalg_variable_5,2,9,"0");;
gap> homalg_variable_1137 = homalg_variable_1138;
true
gap> SIH_ZeroRows(homalg_variable_12);
[ 2 ]
gap> homalg_variable_1140 := SIH_Submatrix(homalg_variable_12,[ 1, 3, 4, 5, 6 ],[1..4]);;
gap> homalg_variable_1139 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1140);;
gap> SI_nrows(homalg_variable_1139);
3
gap> homalg_variable_1141 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_1139 = homalg_variable_1141;
false
gap> homalg_variable_1142 := homalg_variable_1139 * homalg_variable_1140;;
gap> homalg_variable_1143 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_1142 = homalg_variable_1143;
true
gap> homalg_variable_1144 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1139);;
gap> SI_nrows(homalg_variable_1144);
1
gap> homalg_variable_1145 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1144 = homalg_variable_1145;
false
gap> homalg_variable_1146 := SI_\[(homalg_variable_1144,1,3);;
gap> SI_deg( homalg_variable_1146 );
1
gap> homalg_variable_1147 := SI_\[(homalg_variable_1144,1,2);;
gap> SI_deg( homalg_variable_1147 );
1
gap> homalg_variable_1148 := SI_\[(homalg_variable_1144,1,1);;
gap> SI_deg( homalg_variable_1148 );
2
gap> homalg_variable_1149 := SIH_BasisOfRowModule(homalg_variable_1139);;
gap> SI_nrows(homalg_variable_1149);
3
gap> homalg_variable_1150 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_1149 = homalg_variable_1150;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1139);; homalg_variable_1151 := homalg_variable_l[1];; homalg_variable_1152 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1151);
3
gap> homalg_variable_1153 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_1151 = homalg_variable_1153;
false
gap> SI_ncols(homalg_variable_1152);
3
gap> homalg_variable_1154 := homalg_variable_1152 * homalg_variable_1139;;
gap> homalg_variable_1151 = homalg_variable_1154;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1149,homalg_variable_1151);; homalg_variable_1155 := homalg_variable_l[1];; homalg_variable_1156 := homalg_variable_l[2];;
gap> homalg_variable_1157 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_1155 = homalg_variable_1157;
true
gap> homalg_variable_1158 := homalg_variable_1156 * homalg_variable_1151;;
gap> homalg_variable_1159 := homalg_variable_1149 + homalg_variable_1158;;
gap> homalg_variable_1155 = homalg_variable_1159;
true
gap> homalg_variable_1160 := SIH_DecideZeroRows(homalg_variable_1149,homalg_variable_1151);;
gap> homalg_variable_1161 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_1160 = homalg_variable_1161;
true
gap> homalg_variable_1162 := homalg_variable_1156 * (homalg_variable_8);;
gap> homalg_variable_1163 := homalg_variable_1162 * homalg_variable_1152;;
gap> homalg_variable_1164 := homalg_variable_1163 * homalg_variable_1139;;
gap> homalg_variable_1164 = homalg_variable_1149;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1139,homalg_variable_1149);; homalg_variable_1165 := homalg_variable_l[1];; homalg_variable_1166 := homalg_variable_l[2];;
gap> homalg_variable_1167 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_1165 = homalg_variable_1167;
true
gap> homalg_variable_1168 := homalg_variable_1166 * homalg_variable_1149;;
gap> homalg_variable_1169 := homalg_variable_1139 + homalg_variable_1168;;
gap> homalg_variable_1165 = homalg_variable_1169;
true
gap> homalg_variable_1170 := SIH_DecideZeroRows(homalg_variable_1139,homalg_variable_1149);;
gap> homalg_variable_1171 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_1170 = homalg_variable_1171;
true
gap> homalg_variable_1172 := homalg_variable_1166 * (homalg_variable_8);;
gap> homalg_variable_1173 := homalg_variable_1172 * homalg_variable_1149;;
gap> homalg_variable_1173 = homalg_variable_1139;
true
gap> homalg_variable_1149 = homalg_variable_1139;
true
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1140);; homalg_variable_1174 := homalg_variable_l[1];; homalg_variable_1175 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1174);
6
gap> homalg_variable_1176 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_1174 = homalg_variable_1176;
false
gap> SI_ncols(homalg_variable_1175);
5
gap> homalg_variable_1177 := homalg_variable_1175 * homalg_variable_1140;;
gap> homalg_variable_1174 = homalg_variable_1177;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_12,homalg_variable_1174);; homalg_variable_1178 := homalg_variable_l[1];; homalg_variable_1179 := homalg_variable_l[2];;
gap> homalg_variable_1180 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_1178 = homalg_variable_1180;
true
gap> homalg_variable_1181 := homalg_variable_1179 * homalg_variable_1174;;
gap> homalg_variable_1182 := homalg_variable_12 + homalg_variable_1181;;
gap> homalg_variable_1178 = homalg_variable_1182;
true
gap> homalg_variable_1183 := SIH_DecideZeroRows(homalg_variable_12,homalg_variable_1174);;
gap> homalg_variable_1184 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_1183 = homalg_variable_1184;
true
gap> homalg_variable_1185 := homalg_variable_1179 * (homalg_variable_8);;
gap> homalg_variable_1186 := homalg_variable_1185 * homalg_variable_1175;;
gap> homalg_variable_1187 := homalg_variable_1186 * homalg_variable_1140;;
gap> homalg_variable_1188 := homalg_variable_1187 - homalg_variable_12;;
gap> homalg_variable_1189 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_1188 = homalg_variable_1189;
true
gap> homalg_variable_1191 := SIH_UnionOfRows(homalg_variable_1186,homalg_variable_1149);;
gap> homalg_variable_1190 := SIH_BasisOfRowModule(homalg_variable_1191);;
gap> SI_nrows(homalg_variable_1190);
5
gap> homalg_variable_1192 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_1190 = homalg_variable_1192;
false
gap> homalg_variable_1193 := SIH_DecideZeroRows(homalg_variable_42,homalg_variable_1190);;
gap> homalg_variable_1194 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_1193 = homalg_variable_1194;
true
gap> homalg_variable_1195 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1149);;
gap> SI_nrows(homalg_variable_1195);
1
gap> homalg_variable_1196 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1195 = homalg_variable_1196;
false
gap> homalg_variable_1197 := SIH_BasisOfRowModule(homalg_variable_1195);;
gap> SI_nrows(homalg_variable_1197);
1
gap> homalg_variable_1198 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1197 = homalg_variable_1198;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1195);; homalg_variable_1199 := homalg_variable_l[1];; homalg_variable_1200 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1199);
1
gap> homalg_variable_1201 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1199 = homalg_variable_1201;
false
gap> SI_ncols(homalg_variable_1200);
1
gap> homalg_variable_1202 := homalg_variable_1200 * homalg_variable_1195;;
gap> homalg_variable_1199 = homalg_variable_1202;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1197,homalg_variable_1199);; homalg_variable_1203 := homalg_variable_l[1];; homalg_variable_1204 := homalg_variable_l[2];;
gap> homalg_variable_1205 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1203 = homalg_variable_1205;
true
gap> homalg_variable_1206 := homalg_variable_1204 * homalg_variable_1199;;
gap> homalg_variable_1207 := homalg_variable_1197 + homalg_variable_1206;;
gap> homalg_variable_1203 = homalg_variable_1207;
true
gap> homalg_variable_1208 := SIH_DecideZeroRows(homalg_variable_1197,homalg_variable_1199);;
gap> homalg_variable_1209 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1208 = homalg_variable_1209;
true
gap> homalg_variable_1210 := homalg_variable_1204 * (homalg_variable_8);;
gap> homalg_variable_1211 := homalg_variable_1210 * homalg_variable_1200;;
gap> homalg_variable_1212 := homalg_variable_1211 * homalg_variable_1195;;
gap> homalg_variable_1212 = homalg_variable_1197;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1195,homalg_variable_1197);; homalg_variable_1213 := homalg_variable_l[1];; homalg_variable_1214 := homalg_variable_l[2];;
gap> homalg_variable_1215 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1213 = homalg_variable_1215;
true
gap> homalg_variable_1216 := homalg_variable_1214 * homalg_variable_1197;;
gap> homalg_variable_1217 := homalg_variable_1195 + homalg_variable_1216;;
gap> homalg_variable_1213 = homalg_variable_1217;
true
gap> homalg_variable_1218 := SIH_DecideZeroRows(homalg_variable_1195,homalg_variable_1197);;
gap> homalg_variable_1219 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1218 = homalg_variable_1219;
true
gap> homalg_variable_1220 := homalg_variable_1214 * (homalg_variable_8);;
gap> homalg_variable_1221 := homalg_variable_1220 * homalg_variable_1197;;
gap> homalg_variable_1221 = homalg_variable_1195;
true
gap> homalg_variable_1222 := homalg_variable_1195 * homalg_variable_1149;;
gap> homalg_variable_1223 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_1222 = homalg_variable_1223;
true
gap> homalg_variable_1197 = homalg_variable_1195;
true
gap> homalg_variable_1224 := SIH_DecideZeroRows(homalg_variable_1186,homalg_variable_1149);;
gap> homalg_variable_1225 := SI_matrix(homalg_variable_5,6,5,"0");;
gap> homalg_variable_1224 = homalg_variable_1225;
false
gap> homalg_variable_1226 := SI_matrix(homalg_variable_5,6,5,"0");;
gap> homalg_variable_1186 = homalg_variable_1226;
false
gap> homalg_variable_1227 := SIH_UnionOfRows(homalg_variable_1224,homalg_variable_1149);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1227);; homalg_variable_1228 := homalg_variable_l[1];; homalg_variable_1229 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1228);
5
gap> homalg_variable_1230 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_1228 = homalg_variable_1230;
false
gap> SI_ncols(homalg_variable_1229);
9
gap> homalg_variable_1231 := SIH_Submatrix(homalg_variable_1229,[1..5],[ 1, 2, 3, 4, 5, 6 ]);;
gap> homalg_variable_1232 := homalg_variable_1231 * homalg_variable_1224;;
gap> homalg_variable_1233 := SIH_Submatrix(homalg_variable_1229,[1..5],[ 7, 8, 9 ]);;
gap> homalg_variable_1234 := homalg_variable_1233 * homalg_variable_1149;;
gap> homalg_variable_1235 := homalg_variable_1232 + homalg_variable_1234;;
gap> homalg_variable_1228 = homalg_variable_1235;
true
gap> homalg_variable_1236 := SIH_DecideZeroRows(homalg_variable_42,homalg_variable_1149);;
gap> homalg_variable_1237 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_1236 = homalg_variable_1237;
false
gap> homalg_variable_1228 = homalg_variable_42;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1236,homalg_variable_1228);; homalg_variable_1238 := homalg_variable_l[1];; homalg_variable_1239 := homalg_variable_l[2];;
gap> homalg_variable_1240 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_1238 = homalg_variable_1240;
true
gap> homalg_variable_1241 := homalg_variable_1239 * homalg_variable_1228;;
gap> homalg_variable_1242 := homalg_variable_1236 + homalg_variable_1241;;
gap> homalg_variable_1238 = homalg_variable_1242;
true
gap> homalg_variable_1243 := SIH_DecideZeroRows(homalg_variable_1236,homalg_variable_1228);;
gap> homalg_variable_1244 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_1243 = homalg_variable_1244;
true
gap> homalg_variable_1246 := homalg_variable_1239 * (homalg_variable_8);;
gap> homalg_variable_1247 := SIH_Submatrix(homalg_variable_1229,[1..5],[ 1, 2, 3, 4, 5, 6 ]);;
gap> homalg_variable_1248 := homalg_variable_1246 * homalg_variable_1247;;
gap> homalg_variable_1249 := homalg_variable_1248 * homalg_variable_1186;;
gap> homalg_variable_1250 := homalg_variable_1249 - homalg_variable_42;;
gap> homalg_variable_1245 := SIH_DecideZeroRows(homalg_variable_1250,homalg_variable_1149);;
gap> homalg_variable_1251 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_1245 = homalg_variable_1251;
true
gap> homalg_variable_1253 := homalg_variable_872 * homalg_variable_272;;
gap> homalg_variable_1254 := homalg_variable_930 * homalg_variable_272;;
gap> homalg_variable_1255 := SIH_UnionOfRows(homalg_variable_1253,homalg_variable_1254);;
gap> homalg_variable_1256 := SIH_UnionOfRows(homalg_variable_1255,homalg_variable_1248);;
gap> homalg_variable_1252 := SIH_BasisOfRowModule(homalg_variable_1256);;
gap> SI_nrows(homalg_variable_1252);
6
gap> homalg_variable_1257 := SI_matrix(homalg_variable_5,6,6,"0");;
gap> homalg_variable_1252 = homalg_variable_1257;
false
gap> homalg_variable_1259 := SI_matrix( SI_freemodule( homalg_variable_5,6 ) );;
gap> homalg_variable_1258 := SIH_DecideZeroRows(homalg_variable_1259,homalg_variable_1252);;
gap> homalg_variable_1260 := SI_matrix(homalg_variable_5,6,6,"0");;
gap> homalg_variable_1258 = homalg_variable_1260;
true
gap> homalg_variable_1261 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1256);;
gap> SI_nrows(homalg_variable_1261);
8
gap> homalg_variable_1262 := SI_matrix(homalg_variable_5,8,14,"0");;
gap> homalg_variable_1261 = homalg_variable_1262;
false
gap> homalg_variable_1263 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1261);;
gap> SI_nrows(homalg_variable_1263);
1
gap> homalg_variable_1264 := SI_matrix(homalg_variable_5,1,8,"0");;
gap> homalg_variable_1263 = homalg_variable_1264;
true
gap> homalg_variable_1265 := SIH_BasisOfRowModule(homalg_variable_1261);;
gap> SI_nrows(homalg_variable_1265);
12
gap> homalg_variable_1266 := SI_matrix(homalg_variable_5,12,14,"0");;
gap> homalg_variable_1265 = homalg_variable_1266;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1261);; homalg_variable_1267 := homalg_variable_l[1];; homalg_variable_1268 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1267);
12
gap> homalg_variable_1269 := SI_matrix(homalg_variable_5,12,14,"0");;
gap> homalg_variable_1267 = homalg_variable_1269;
false
gap> SI_ncols(homalg_variable_1268);
8
gap> homalg_variable_1270 := homalg_variable_1268 * homalg_variable_1261;;
gap> homalg_variable_1267 = homalg_variable_1270;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1265,homalg_variable_1267);; homalg_variable_1271 := homalg_variable_l[1];; homalg_variable_1272 := homalg_variable_l[2];;
gap> homalg_variable_1273 := SI_matrix(homalg_variable_5,12,14,"0");;
gap> homalg_variable_1271 = homalg_variable_1273;
true
gap> homalg_variable_1274 := homalg_variable_1272 * homalg_variable_1267;;
gap> homalg_variable_1275 := homalg_variable_1265 + homalg_variable_1274;;
gap> homalg_variable_1271 = homalg_variable_1275;
true
gap> homalg_variable_1276 := SIH_DecideZeroRows(homalg_variable_1265,homalg_variable_1267);;
gap> homalg_variable_1277 := SI_matrix(homalg_variable_5,12,14,"0");;
gap> homalg_variable_1276 = homalg_variable_1277;
true
gap> homalg_variable_1278 := homalg_variable_1272 * (homalg_variable_8);;
gap> homalg_variable_1279 := homalg_variable_1278 * homalg_variable_1268;;
gap> homalg_variable_1280 := homalg_variable_1279 * homalg_variable_1261;;
gap> homalg_variable_1280 = homalg_variable_1265;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1261,homalg_variable_1265);; homalg_variable_1281 := homalg_variable_l[1];; homalg_variable_1282 := homalg_variable_l[2];;
gap> homalg_variable_1283 := SI_matrix(homalg_variable_5,8,14,"0");;
gap> homalg_variable_1281 = homalg_variable_1283;
true
gap> homalg_variable_1284 := homalg_variable_1282 * homalg_variable_1265;;
gap> homalg_variable_1285 := homalg_variable_1261 + homalg_variable_1284;;
gap> homalg_variable_1281 = homalg_variable_1285;
true
gap> homalg_variable_1286 := SIH_DecideZeroRows(homalg_variable_1261,homalg_variable_1265);;
gap> homalg_variable_1287 := SI_matrix(homalg_variable_5,8,14,"0");;
gap> homalg_variable_1286 = homalg_variable_1287;
true
gap> homalg_variable_1288 := homalg_variable_1282 * (homalg_variable_8);;
gap> homalg_variable_1289 := homalg_variable_1288 * homalg_variable_1265;;
gap> homalg_variable_1289 = homalg_variable_1261;
true
gap> SIH_ZeroRows(homalg_variable_1261);
[  ]
gap> SIH_ZeroRows(homalg_variable_1149);
[  ]
gap> homalg_variable_1290 := homalg_variable_1195 * homalg_variable_1149;;
gap> homalg_variable_1291 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_1290 = homalg_variable_1291;
true
gap> homalg_variable_1292 := SIH_DecideZeroRows(homalg_variable_1195,homalg_variable_1197);;
gap> homalg_variable_1293 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1292 = homalg_variable_1293;
true
gap> homalg_variable_1294 := SI_matrix(homalg_variable_5,2,9,"0");;
gap> homalg_variable_1072 = homalg_variable_1294;
false
gap> SIH_ZeroRows(homalg_variable_1074);
[  ]
gap> homalg_variable_1295 := SIH_Submatrix(homalg_variable_1071,[1..1],[ 1, 2 ]);;
gap> homalg_variable_1296 := homalg_variable_1295 * homalg_variable_1072;;
gap> homalg_variable_1297 := SIH_Submatrix(homalg_variable_1071,[1..1],[ 3, 4, 5, 6, 7 ]);;
gap> homalg_variable_1298 := homalg_variable_1297 * homalg_variable_1073;;
gap> homalg_variable_1299 := homalg_variable_1296 + homalg_variable_1298;;
gap> homalg_variable_1300 := SI_matrix(homalg_variable_5,1,9,"0");;
gap> homalg_variable_1299 = homalg_variable_1300;
true
gap> homalg_variable_1076 = homalg_variable_1071;
true
gap> homalg_variable_1301 := SIH_DecideZeroRows(homalg_variable_1071,homalg_variable_1076);;
gap> homalg_variable_1302 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1301 = homalg_variable_1302;
true
gap> homalg_variable_1303 := SIH_Submatrix(homalg_variable_1261,[1..8],[ 10, 11, 12, 13, 14 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1303,homalg_variable_1149);; homalg_variable_1304 := homalg_variable_l[1];; homalg_variable_1305 := homalg_variable_l[2];;
gap> homalg_variable_1306 := SI_matrix(homalg_variable_5,8,5,"0");;
gap> homalg_variable_1304 = homalg_variable_1306;
true
gap> homalg_variable_1307 := homalg_variable_1305 * homalg_variable_1149;;
gap> homalg_variable_1308 := homalg_variable_1303 + homalg_variable_1307;;
gap> homalg_variable_1304 = homalg_variable_1308;
true
gap> homalg_variable_1309 := SIH_DecideZeroRows(homalg_variable_1303,homalg_variable_1149);;
gap> homalg_variable_1310 := SI_matrix(homalg_variable_5,8,5,"0");;
gap> homalg_variable_1309 = homalg_variable_1310;
true
gap> homalg_variable_1311 := homalg_variable_1305 * (homalg_variable_8);;
gap> homalg_variable_1312 := homalg_variable_1311 * homalg_variable_1149;;
gap> homalg_variable_1313 := homalg_variable_1312 - homalg_variable_1303;;
gap> homalg_variable_1314 := SI_matrix(homalg_variable_5,8,5,"0");;
gap> homalg_variable_1313 = homalg_variable_1314;
true
gap> homalg_variable_1315 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_1316 := SIH_UnionOfColumns(homalg_variable_1072,homalg_variable_1315);;
gap> homalg_variable_1317 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_1318 := SIH_UnionOfColumns(homalg_variable_1073,homalg_variable_1317);;
gap> homalg_variable_1319 := SIH_UnionOfRows(homalg_variable_1316,homalg_variable_1318);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1319,homalg_variable_1267);; homalg_variable_1320 := homalg_variable_l[1];; homalg_variable_1321 := homalg_variable_l[2];;
gap> homalg_variable_1322 := SI_matrix(homalg_variable_5,7,14,"0");;
gap> homalg_variable_1320 = homalg_variable_1322;
true
gap> homalg_variable_1323 := homalg_variable_1321 * homalg_variable_1267;;
gap> homalg_variable_1324 := homalg_variable_1319 + homalg_variable_1323;;
gap> homalg_variable_1320 = homalg_variable_1324;
true
gap> homalg_variable_1325 := SIH_DecideZeroRows(homalg_variable_1319,homalg_variable_1267);;
gap> homalg_variable_1326 := SI_matrix(homalg_variable_5,7,14,"0");;
gap> homalg_variable_1325 = homalg_variable_1326;
true
gap> SI_ncols(homalg_variable_1268);
8
gap> SI_nrows(homalg_variable_1268);
12
gap> homalg_variable_1327 := homalg_variable_1321 * (homalg_variable_8);;
gap> homalg_variable_1328 := homalg_variable_1327 * homalg_variable_1268;;
gap> homalg_variable_1329 := homalg_variable_1328 * homalg_variable_1261;;
gap> homalg_variable_1330 := homalg_variable_1329 - homalg_variable_1319;;
gap> homalg_variable_1331 := SI_matrix(homalg_variable_5,7,14,"0");;
gap> homalg_variable_1330 = homalg_variable_1331;
true
gap> homalg_variable_1332 := homalg_variable_1076 * homalg_variable_1328;;
gap> homalg_variable_1333 := SI_matrix(homalg_variable_5,1,8,"0");;
gap> homalg_variable_1332 = homalg_variable_1333;
true
gap> homalg_variable_1334 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1328);;
gap> SI_nrows(homalg_variable_1334);
1
gap> homalg_variable_1335 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1334 = homalg_variable_1335;
false
gap> homalg_variable_1336 := SIH_BasisOfRowModule(homalg_variable_1334);;
gap> SI_nrows(homalg_variable_1336);
1
gap> homalg_variable_1337 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1336 = homalg_variable_1337;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1334);; homalg_variable_1338 := homalg_variable_l[1];; homalg_variable_1339 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1338);
1
gap> homalg_variable_1340 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1338 = homalg_variable_1340;
false
gap> SI_ncols(homalg_variable_1339);
1
gap> homalg_variable_1341 := homalg_variable_1339 * homalg_variable_1334;;
gap> homalg_variable_1338 = homalg_variable_1341;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1336,homalg_variable_1338);; homalg_variable_1342 := homalg_variable_l[1];; homalg_variable_1343 := homalg_variable_l[2];;
gap> homalg_variable_1344 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1342 = homalg_variable_1344;
true
gap> homalg_variable_1345 := homalg_variable_1343 * homalg_variable_1338;;
gap> homalg_variable_1346 := homalg_variable_1336 + homalg_variable_1345;;
gap> homalg_variable_1342 = homalg_variable_1346;
true
gap> homalg_variable_1347 := SIH_DecideZeroRows(homalg_variable_1336,homalg_variable_1338);;
gap> homalg_variable_1348 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1347 = homalg_variable_1348;
true
gap> homalg_variable_1349 := homalg_variable_1343 * (homalg_variable_8);;
gap> homalg_variable_1350 := homalg_variable_1349 * homalg_variable_1339;;
gap> homalg_variable_1351 := homalg_variable_1350 * homalg_variable_1334;;
gap> homalg_variable_1351 = homalg_variable_1336;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1334,homalg_variable_1336);; homalg_variable_1352 := homalg_variable_l[1];; homalg_variable_1353 := homalg_variable_l[2];;
gap> homalg_variable_1354 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1352 = homalg_variable_1354;
true
gap> homalg_variable_1355 := homalg_variable_1353 * homalg_variable_1336;;
gap> homalg_variable_1356 := homalg_variable_1334 + homalg_variable_1355;;
gap> homalg_variable_1352 = homalg_variable_1356;
true
gap> homalg_variable_1357 := SIH_DecideZeroRows(homalg_variable_1334,homalg_variable_1336);;
gap> homalg_variable_1358 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1357 = homalg_variable_1358;
true
gap> homalg_variable_1359 := homalg_variable_1353 * (homalg_variable_8);;
gap> homalg_variable_1360 := homalg_variable_1359 * homalg_variable_1336;;
gap> homalg_variable_1360 = homalg_variable_1334;
true
gap> homalg_variable_1361 := SIH_DecideZeroRows(homalg_variable_1334,homalg_variable_1076);;
gap> homalg_variable_1362 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1361 = homalg_variable_1362;
true
gap> homalg_variable_1364 := SIH_UnionOfRows(homalg_variable_1311,homalg_variable_1197);;
gap> homalg_variable_1363 := SIH_BasisOfRowModule(homalg_variable_1364);;
gap> SI_nrows(homalg_variable_1363);
3
gap> homalg_variable_1365 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1363 = homalg_variable_1365;
false
gap> homalg_variable_1367 := SI_matrix( SI_freemodule( homalg_variable_5,3 ) );;
gap> homalg_variable_1366 := SIH_DecideZeroRows(homalg_variable_1367,homalg_variable_1363);;
gap> homalg_variable_1368 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1366 = homalg_variable_1368;
true
gap> homalg_variable_1370 := SIH_UnionOfRows(homalg_variable_1367,homalg_variable_1197);;
gap> homalg_variable_1369 := SIH_BasisOfRowModule(homalg_variable_1370);;
gap> SI_nrows(homalg_variable_1369);
3
gap> homalg_variable_1371 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1369 = homalg_variable_1371;
false
gap> homalg_variable_1372 := SIH_DecideZeroRows(homalg_variable_1367,homalg_variable_1369);;
gap> homalg_variable_1373 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1372 = homalg_variable_1373;
true
gap> homalg_variable_1375 := SI_matrix( SI_freemodule( homalg_variable_5,7 ) );;
gap> homalg_variable_1376 := SIH_UnionOfRows(homalg_variable_1375,homalg_variable_1076);;
gap> homalg_variable_1374 := SIH_BasisOfRowModule(homalg_variable_1376);;
gap> SI_nrows(homalg_variable_1374);
7
gap> homalg_variable_1377 := SI_matrix(homalg_variable_5,7,7,"0");;
gap> homalg_variable_1374 = homalg_variable_1377;
false
gap> homalg_variable_1378 := SIH_DecideZeroRows(homalg_variable_1375,homalg_variable_1374);;
gap> homalg_variable_1379 := SI_matrix(homalg_variable_5,7,7,"0");;
gap> homalg_variable_1378 = homalg_variable_1379;
true
gap> homalg_variable_1380 := SIH_DecideZeroRows(homalg_variable_1311,homalg_variable_1197);;
gap> homalg_variable_1381 := SI_matrix(homalg_variable_5,8,3,"0");;
gap> homalg_variable_1380 = homalg_variable_1381;
false
gap> homalg_variable_1382 := SI_matrix(homalg_variable_5,8,3,"0");;
gap> homalg_variable_1305 = homalg_variable_1382;
false
gap> homalg_variable_1383 := SIH_UnionOfRows(homalg_variable_1380,homalg_variable_1197);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1383);; homalg_variable_1384 := homalg_variable_l[1];; homalg_variable_1385 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1384);
3
gap> homalg_variable_1386 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1384 = homalg_variable_1386;
false
gap> SI_ncols(homalg_variable_1385);
9
gap> homalg_variable_1387 := SIH_Submatrix(homalg_variable_1385,[1..3],[ 1, 2, 3, 4, 5, 6, 7, 8 ]);;
gap> homalg_variable_1388 := homalg_variable_1387 * homalg_variable_1380;;
gap> homalg_variable_1389 := SIH_Submatrix(homalg_variable_1385,[1..3],[ 9 ]);;
gap> homalg_variable_1390 := homalg_variable_1389 * homalg_variable_1197;;
gap> homalg_variable_1391 := homalg_variable_1388 + homalg_variable_1390;;
gap> homalg_variable_1384 = homalg_variable_1391;
true
gap> homalg_variable_1392 := SIH_DecideZeroRows(homalg_variable_1367,homalg_variable_1197);;
gap> homalg_variable_1393 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1392 = homalg_variable_1393;
false
gap> homalg_variable_1384 = homalg_variable_1367;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1392,homalg_variable_1384);; homalg_variable_1394 := homalg_variable_l[1];; homalg_variable_1395 := homalg_variable_l[2];;
gap> homalg_variable_1396 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1394 = homalg_variable_1396;
true
gap> homalg_variable_1397 := homalg_variable_1395 * homalg_variable_1384;;
gap> homalg_variable_1398 := homalg_variable_1392 + homalg_variable_1397;;
gap> homalg_variable_1394 = homalg_variable_1398;
true
gap> homalg_variable_1399 := SIH_DecideZeroRows(homalg_variable_1392,homalg_variable_1384);;
gap> homalg_variable_1400 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1399 = homalg_variable_1400;
true
gap> homalg_variable_1402 := homalg_variable_1395 * (homalg_variable_8);;
gap> homalg_variable_1403 := SIH_Submatrix(homalg_variable_1385,[1..3],[ 1, 2, 3, 4, 5, 6, 7, 8 ]);;
gap> homalg_variable_1404 := homalg_variable_1402 * homalg_variable_1403;;
gap> homalg_variable_1405 := homalg_variable_1404 * homalg_variable_1311;;
gap> homalg_variable_1406 := homalg_variable_1405 - homalg_variable_1367;;
gap> homalg_variable_1401 := SIH_DecideZeroRows(homalg_variable_1406,homalg_variable_1197);;
gap> homalg_variable_1407 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1401 = homalg_variable_1407;
true
gap> homalg_variable_1409 := homalg_variable_1328 * homalg_variable_1261;;
gap> homalg_variable_1410 := homalg_variable_1404 * homalg_variable_1261;;
gap> homalg_variable_1411 := SIH_UnionOfRows(homalg_variable_1409,homalg_variable_1410);;
gap> homalg_variable_1408 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1411);;
gap> SI_nrows(homalg_variable_1408);
2
gap> homalg_variable_1412 := SI_matrix(homalg_variable_5,2,10,"0");;
gap> homalg_variable_1408 = homalg_variable_1412;
false
gap> homalg_variable_1413 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1408);;
gap> SI_nrows(homalg_variable_1413);
1
gap> homalg_variable_1414 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_1413 = homalg_variable_1414;
true
gap> homalg_variable_1415 := SIH_BasisOfRowModule(homalg_variable_1408);;
gap> SI_nrows(homalg_variable_1415);
2
gap> homalg_variable_1416 := SI_matrix(homalg_variable_5,2,10,"0");;
gap> homalg_variable_1415 = homalg_variable_1416;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1408);; homalg_variable_1417 := homalg_variable_l[1];; homalg_variable_1418 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1417);
2
gap> homalg_variable_1419 := SI_matrix(homalg_variable_5,2,10,"0");;
gap> homalg_variable_1417 = homalg_variable_1419;
false
gap> SI_ncols(homalg_variable_1418);
2
gap> homalg_variable_1420 := homalg_variable_1418 * homalg_variable_1408;;
gap> homalg_variable_1417 = homalg_variable_1420;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1415,homalg_variable_1417);; homalg_variable_1421 := homalg_variable_l[1];; homalg_variable_1422 := homalg_variable_l[2];;
gap> homalg_variable_1423 := SI_matrix(homalg_variable_5,2,10,"0");;
gap> homalg_variable_1421 = homalg_variable_1423;
true
gap> homalg_variable_1424 := homalg_variable_1422 * homalg_variable_1417;;
gap> homalg_variable_1425 := homalg_variable_1415 + homalg_variable_1424;;
gap> homalg_variable_1421 = homalg_variable_1425;
true
gap> homalg_variable_1426 := SIH_DecideZeroRows(homalg_variable_1415,homalg_variable_1417);;
gap> homalg_variable_1427 := SI_matrix(homalg_variable_5,2,10,"0");;
gap> homalg_variable_1426 = homalg_variable_1427;
true
gap> homalg_variable_1428 := homalg_variable_1422 * (homalg_variable_8);;
gap> homalg_variable_1429 := homalg_variable_1428 * homalg_variable_1418;;
gap> homalg_variable_1430 := homalg_variable_1429 * homalg_variable_1408;;
gap> homalg_variable_1430 = homalg_variable_1415;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1408,homalg_variable_1415);; homalg_variable_1431 := homalg_variable_l[1];; homalg_variable_1432 := homalg_variable_l[2];;
gap> homalg_variable_1433 := SI_matrix(homalg_variable_5,2,10,"0");;
gap> homalg_variable_1431 = homalg_variable_1433;
true
gap> homalg_variable_1434 := homalg_variable_1432 * homalg_variable_1415;;
gap> homalg_variable_1435 := homalg_variable_1408 + homalg_variable_1434;;
gap> homalg_variable_1431 = homalg_variable_1435;
true
gap> homalg_variable_1436 := SIH_DecideZeroRows(homalg_variable_1408,homalg_variable_1415);;
gap> homalg_variable_1437 := SI_matrix(homalg_variable_5,2,10,"0");;
gap> homalg_variable_1436 = homalg_variable_1437;
true
gap> homalg_variable_1438 := homalg_variable_1432 * (homalg_variable_8);;
gap> homalg_variable_1439 := homalg_variable_1438 * homalg_variable_1415;;
gap> homalg_variable_1439 = homalg_variable_1408;
true
gap> SIH_ZeroRows(homalg_variable_1408);
[  ]
gap> homalg_variable_1440 := SIH_Submatrix(homalg_variable_1408,[1..2],[ 8, 9, 10 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1440,homalg_variable_1195);; homalg_variable_1441 := homalg_variable_l[1];; homalg_variable_1442 := homalg_variable_l[2];;
gap> homalg_variable_1443 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_1441 = homalg_variable_1443;
true
gap> homalg_variable_1444 := homalg_variable_1442 * homalg_variable_1195;;
gap> homalg_variable_1445 := homalg_variable_1440 + homalg_variable_1444;;
gap> homalg_variable_1441 = homalg_variable_1445;
true
gap> homalg_variable_1446 := SIH_DecideZeroRows(homalg_variable_1440,homalg_variable_1195);;
gap> homalg_variable_1447 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_1446 = homalg_variable_1447;
true
gap> homalg_variable_1448 := homalg_variable_1442 * (homalg_variable_8);;
gap> homalg_variable_1449 := homalg_variable_1448 * homalg_variable_1195;;
gap> homalg_variable_1450 := homalg_variable_1449 - homalg_variable_1440;;
gap> homalg_variable_1451 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_1450 = homalg_variable_1451;
true
gap> homalg_variable_1452 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1453 := SIH_UnionOfColumns(homalg_variable_1071,homalg_variable_1452);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1453,homalg_variable_1417);; homalg_variable_1454 := homalg_variable_l[1];; homalg_variable_1455 := homalg_variable_l[2];;
gap> homalg_variable_1456 := SI_matrix(homalg_variable_5,1,10,"0");;
gap> homalg_variable_1454 = homalg_variable_1456;
true
gap> homalg_variable_1457 := homalg_variable_1455 * homalg_variable_1417;;
gap> homalg_variable_1458 := homalg_variable_1453 + homalg_variable_1457;;
gap> homalg_variable_1454 = homalg_variable_1458;
true
gap> homalg_variable_1459 := SIH_DecideZeroRows(homalg_variable_1453,homalg_variable_1417);;
gap> homalg_variable_1460 := SI_matrix(homalg_variable_5,1,10,"0");;
gap> homalg_variable_1459 = homalg_variable_1460;
true
gap> SI_ncols(homalg_variable_1418);
2
gap> SI_nrows(homalg_variable_1418);
2
gap> homalg_variable_1461 := homalg_variable_1455 * (homalg_variable_8);;
gap> homalg_variable_1462 := homalg_variable_1461 * homalg_variable_1418;;
gap> homalg_variable_1463 := homalg_variable_1462 * homalg_variable_1408;;
gap> homalg_variable_1464 := homalg_variable_1463 - homalg_variable_1453;;
gap> homalg_variable_1465 := SI_matrix(homalg_variable_5,1,10,"0");;
gap> homalg_variable_1464 = homalg_variable_1465;
true
gap> homalg_variable_1466 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1462);;
gap> SI_nrows(homalg_variable_1466);
1
gap> homalg_variable_1467 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_1466 = homalg_variable_1467;
true
gap> homalg_variable_1468 := SIH_BasisOfRowModule(homalg_variable_1448);;
gap> SI_nrows(homalg_variable_1468);
1
gap> homalg_variable_1469 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_1468 = homalg_variable_1469;
false
gap> homalg_variable_1470 := SIH_DecideZeroRows(homalg_variable_237,homalg_variable_1468);;
gap> homalg_variable_1471 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_1470 = homalg_variable_1471;
true
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1448);; homalg_variable_1472 := homalg_variable_l[1];; homalg_variable_1473 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1472);
1
gap> homalg_variable_1474 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_1472 = homalg_variable_1474;
false
gap> SI_ncols(homalg_variable_1473);
2
gap> homalg_variable_1475 := homalg_variable_1473 * homalg_variable_1448;;
gap> homalg_variable_1472 = homalg_variable_1475;
true
gap> homalg_variable_1472 = homalg_variable_237;
true
gap> homalg_variable_1476 := homalg_variable_1473 * homalg_variable_1448;;
gap> homalg_variable_1477 := homalg_variable_1476 - homalg_variable_237;;
gap> homalg_variable_1478 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_1477 = homalg_variable_1478;
true
gap> homalg_variable_1480 := homalg_variable_1462 * homalg_variable_1408;;
gap> homalg_variable_1481 := homalg_variable_1473 * homalg_variable_1408;;
gap> homalg_variable_1482 := SIH_UnionOfRows(homalg_variable_1480,homalg_variable_1481);;
gap> homalg_variable_1479 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1482);;
gap> SI_nrows(homalg_variable_1479);
1
gap> homalg_variable_1483 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_1479 = homalg_variable_1483;
true
gap> homalg_variable_1484 := SIH_Submatrix(homalg_variable_1480,[1..1],[ 1, 2, 3, 4, 5, 6, 7 ]);;
gap> homalg_variable_1485 := homalg_variable_1484 * homalg_variable_1409;;
gap> homalg_variable_1486 := SIH_Submatrix(homalg_variable_1481,[1..1],[ 1, 2, 3, 4, 5, 6, 7 ]);;
gap> homalg_variable_1487 := homalg_variable_1486 * homalg_variable_1409;;
gap> homalg_variable_1488 := SIH_UnionOfRows(homalg_variable_1485,homalg_variable_1487);;
gap> homalg_variable_1489 := SIH_Submatrix(homalg_variable_1480,[1..1],[ 8, 9, 10 ]);;
gap> homalg_variable_1490 := homalg_variable_1489 * homalg_variable_1410;;
gap> homalg_variable_1491 := SIH_Submatrix(homalg_variable_1481,[1..1],[ 8, 9, 10 ]);;
gap> homalg_variable_1492 := homalg_variable_1491 * homalg_variable_1410;;
gap> homalg_variable_1493 := SIH_UnionOfRows(homalg_variable_1490,homalg_variable_1492);;
gap> homalg_variable_1494 := homalg_variable_1488 + homalg_variable_1493;;
gap> homalg_variable_1495 := SI_matrix(homalg_variable_5,2,14,"0");;
gap> homalg_variable_1494 = homalg_variable_1495;
true
gap> homalg_variable_1496 := SI_matrix(homalg_variable_5,7,5,"0");;
gap> homalg_variable_1497 := SIH_UnionOfRows(homalg_variable_1496,homalg_variable_1149);;
gap> homalg_variable_1498 := SIH_Submatrix(homalg_variable_1409,[1..7],[ 10, 11, 12, 13, 14 ]);;
gap> homalg_variable_1499 := SIH_Submatrix(homalg_variable_1410,[1..3],[ 10, 11, 12, 13, 14 ]);;
gap> homalg_variable_1500 := SIH_UnionOfRows(homalg_variable_1498,homalg_variable_1499);;
gap> for _del in [ "homalg_variable_990", "homalg_variable_993", "homalg_variable_994", "homalg_variable_995", "homalg_variable_996", "homalg_variable_997", "homalg_variable_999", "homalg_variable_1000", "homalg_variable_1001", "homalg_variable_1002", "homalg_variable_1003", "homalg_variable_1005", "homalg_variable_1007", "homalg_variable_1008", "homalg_variable_1009", "homalg_variable_1010", "homalg_variable_1011", "homalg_variable_1014", "homalg_variable_1015", "homalg_variable_1016", "homalg_variable_1019", "homalg_variable_1021", "homalg_variable_1022", "homalg_variable_1023", "homalg_variable_1024", "homalg_variable_1025", "homalg_variable_1028", "homalg_variable_1029", "homalg_variable_1030", "homalg_variable_1031", "homalg_variable_1032", "homalg_variable_1035", "homalg_variable_1036", "homalg_variable_1037", "homalg_variable_1040", "homalg_variable_1041", "homalg_variable_1042", "homalg_variable_1043", "homalg_variable_1044", "homalg_variable_1045", "homalg_variable_1046", "homalg_variable_1047", "homalg_variable_1049", "homalg_variable_1050", "homalg_variable_1051", "homalg_variable_1052", "homalg_variable_1053", "homalg_variable_1054", "homalg_variable_1055", "homalg_variable_1056", "homalg_variable_1057", "homalg_variable_1059", "homalg_variable_1060", "homalg_variable_1061", "homalg_variable_1062", "homalg_variable_1063", "homalg_variable_1064", "homalg_variable_1068", "homalg_variable_1069", "homalg_variable_1070", "homalg_variable_1075", "homalg_variable_1077", "homalg_variable_1080", "homalg_variable_1081", "homalg_variable_1082", "homalg_variable_1083", "homalg_variable_1084", "homalg_variable_1085", "homalg_variable_1086", "homalg_variable_1087", "homalg_variable_1088", "homalg_variable_1089", "homalg_variable_1090", "homalg_variable_1091", "homalg_variable_1092", "homalg_variable_1093", "homalg_variable_1094", "homalg_variable_1095", "homalg_variable_1096", "homalg_variable_1097", "homalg_variable_1098", "homalg_variable_1099", "homalg_variable_1100", "homalg_variable_1102", "homalg_variable_1104", "homalg_variable_1105", "homalg_variable_1106", "homalg_variable_1107", "homalg_variable_1108", "homalg_variable_1110", "homalg_variable_1111", "homalg_variable_1112", "homalg_variable_1114", "homalg_variable_1115", "homalg_variable_1116", "homalg_variable_1117", "homalg_variable_1118", "homalg_variable_1119", "homalg_variable_1120", "homalg_variable_1121", "homalg_variable_1122", "homalg_variable_1123", "homalg_variable_1124", "homalg_variable_1125", "homalg_variable_1126", "homalg_variable_1127", "homalg_variable_1128", "homalg_variable_1129", "homalg_variable_1130", "homalg_variable_1131", "homalg_variable_1132", "homalg_variable_1133", "homalg_variable_1134", "homalg_variable_1135", "homalg_variable_1136", "homalg_variable_1137", "homalg_variable_1138", "homalg_variable_1143", "homalg_variable_1145", "homalg_variable_1146", "homalg_variable_1147", "homalg_variable_1148", "homalg_variable_1150", "homalg_variable_1153", "homalg_variable_1154", "homalg_variable_1155", "homalg_variable_1156", "homalg_variable_1157", "homalg_variable_1158", "homalg_variable_1159", "homalg_variable_1160", "homalg_variable_1161", "homalg_variable_1162", "homalg_variable_1163", "homalg_variable_1164", "homalg_variable_1165", "homalg_variable_1166", "homalg_variable_1167", "homalg_variable_1168", "homalg_variable_1169", "homalg_variable_1170", "homalg_variable_1171", "homalg_variable_1172", "homalg_variable_1173", "homalg_variable_1176", "homalg_variable_1177", "homalg_variable_1178", "homalg_variable_1180", "homalg_variable_1181", "homalg_variable_1182", "homalg_variable_1183", "homalg_variable_1184", "homalg_variable_1187", "homalg_variable_1188", "homalg_variable_1189", "homalg_variable_1192", "homalg_variable_1193", "homalg_variable_1194", "homalg_variable_1196", "homalg_variable_1198", "homalg_variable_1201", "homalg_variable_1202", "homalg_variable_1205", "homalg_variable_1206", "homalg_variable_1207", "homalg_variable_1208", "homalg_variable_1209", "homalg_variable_1213", "homalg_variable_1214", "homalg_variable_1215", "homalg_variable_1216", "homalg_variable_1217", "homalg_variable_1218", "homalg_variable_1219", "homalg_variable_1220", "homalg_variable_1221", "homalg_variable_1222", "homalg_variable_1223", "homalg_variable_1224", "homalg_variable_1225", "homalg_variable_1226", "homalg_variable_1227", "homalg_variable_1228", "homalg_variable_1230", "homalg_variable_1231", "homalg_variable_1232", "homalg_variable_1233", "homalg_variable_1234", "homalg_variable_1235", "homalg_variable_1236", "homalg_variable_1237", "homalg_variable_1238", "homalg_variable_1240", "homalg_variable_1241", "homalg_variable_1242", "homalg_variable_1243", "homalg_variable_1244", "homalg_variable_1245", "homalg_variable_1249", "homalg_variable_1250", "homalg_variable_1251", "homalg_variable_1257", "homalg_variable_1258", "homalg_variable_1259", "homalg_variable_1260", "homalg_variable_1262", "homalg_variable_1263", "homalg_variable_1264", "homalg_variable_1266", "homalg_variable_1270", "homalg_variable_1273", "homalg_variable_1274", "homalg_variable_1275", "homalg_variable_1276", "homalg_variable_1277", "homalg_variable_1280", "homalg_variable_1281", "homalg_variable_1282", "homalg_variable_1283", "homalg_variable_1284", "homalg_variable_1285", "homalg_variable_1286", "homalg_variable_1287", "homalg_variable_1288", "homalg_variable_1289", "homalg_variable_1290", "homalg_variable_1291", "homalg_variable_1292", "homalg_variable_1293", "homalg_variable_1294", "homalg_variable_1295", "homalg_variable_1296", "homalg_variable_1297", "homalg_variable_1298", "homalg_variable_1299", "homalg_variable_1300", "homalg_variable_1301", "homalg_variable_1302", "homalg_variable_1304", "homalg_variable_1306", "homalg_variable_1307", "homalg_variable_1308", "homalg_variable_1309", "homalg_variable_1310", "homalg_variable_1312", "homalg_variable_1313", "homalg_variable_1314", "homalg_variable_1323", "homalg_variable_1324", "homalg_variable_1325", "homalg_variable_1326", "homalg_variable_1329", "homalg_variable_1330", "homalg_variable_1331", "homalg_variable_1332", "homalg_variable_1333", "homalg_variable_1335", "homalg_variable_1337", "homalg_variable_1340", "homalg_variable_1341", "homalg_variable_1342", "homalg_variable_1343", "homalg_variable_1344", "homalg_variable_1345", "homalg_variable_1346", "homalg_variable_1347", "homalg_variable_1348", "homalg_variable_1349", "homalg_variable_1350", "homalg_variable_1351", "homalg_variable_1352", "homalg_variable_1353", "homalg_variable_1354", "homalg_variable_1355", "homalg_variable_1356", "homalg_variable_1357", "homalg_variable_1358", "homalg_variable_1359", "homalg_variable_1360", "homalg_variable_1361", "homalg_variable_1362", "homalg_variable_1365", "homalg_variable_1366", "homalg_variable_1368", "homalg_variable_1371", "homalg_variable_1372", "homalg_variable_1373", "homalg_variable_1377", "homalg_variable_1378", "homalg_variable_1379", "homalg_variable_1381", "homalg_variable_1382", "homalg_variable_1387", "homalg_variable_1388", "homalg_variable_1389", "homalg_variable_1390", "homalg_variable_1391", "homalg_variable_1393", "homalg_variable_1396", "homalg_variable_1397", "homalg_variable_1398", "homalg_variable_1399", "homalg_variable_1400", "homalg_variable_1401", "homalg_variable_1405", "homalg_variable_1406", "homalg_variable_1407", "homalg_variable_1412", "homalg_variable_1413", "homalg_variable_1414", "homalg_variable_1416", "homalg_variable_1419", "homalg_variable_1420", "homalg_variable_1421", "homalg_variable_1422", "homalg_variable_1423", "homalg_variable_1424", "homalg_variable_1425", "homalg_variable_1426", "homalg_variable_1427", "homalg_variable_1428", "homalg_variable_1429", "homalg_variable_1430", "homalg_variable_1431", "homalg_variable_1432", "homalg_variable_1433", "homalg_variable_1434", "homalg_variable_1435", "homalg_variable_1436", "homalg_variable_1437", "homalg_variable_1438", "homalg_variable_1439", "homalg_variable_1441", "homalg_variable_1443", "homalg_variable_1444", "homalg_variable_1445", "homalg_variable_1446", "homalg_variable_1447", "homalg_variable_1449", "homalg_variable_1450", "homalg_variable_1451", "homalg_variable_1454", "homalg_variable_1456", "homalg_variable_1457", "homalg_variable_1458", "homalg_variable_1459", "homalg_variable_1460", "homalg_variable_1463", "homalg_variable_1464", "homalg_variable_1465", "homalg_variable_1466", "homalg_variable_1467", "homalg_variable_1469", "homalg_variable_1470", "homalg_variable_1471", "homalg_variable_1474", "homalg_variable_1475", "homalg_variable_1476", "homalg_variable_1477", "homalg_variable_1478", "homalg_variable_1483" ] do UnbindGlobal( _del );; od;;
gap> homalg_variable_1501 := homalg_variable_1497 - homalg_variable_1500;;
gap> homalg_variable_1502 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_1501 = homalg_variable_1502;
true
gap> homalg_variable_1503 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1504 := SIH_UnionOfRows(homalg_variable_1503,homalg_variable_1195);;
gap> homalg_variable_1505 := SIH_Submatrix(homalg_variable_1480,[1..1],[ 8, 9, 10 ]);;
gap> homalg_variable_1506 := SIH_Submatrix(homalg_variable_1481,[1..1],[ 8, 9, 10 ]);;
gap> homalg_variable_1507 := SIH_UnionOfRows(homalg_variable_1505,homalg_variable_1506);;
gap> homalg_variable_1508 := homalg_variable_1504 - homalg_variable_1507;;
gap> homalg_variable_1509 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_1508 = homalg_variable_1509;
true
gap> homalg_variable_1510 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_1511 := SIH_UnionOfColumns(homalg_variable_1072,homalg_variable_1510);;
gap> homalg_variable_1512 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_1513 := SIH_UnionOfColumns(homalg_variable_1073,homalg_variable_1512);;
gap> homalg_variable_1514 := SIH_UnionOfRows(homalg_variable_1511,homalg_variable_1513);;
gap> homalg_variable_1515 := homalg_variable_1409 - homalg_variable_1514;;
gap> homalg_variable_1516 := SI_matrix(homalg_variable_5,7,14,"0");;
gap> homalg_variable_1515 = homalg_variable_1516;
true
gap> homalg_variable_1517 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1518 := SIH_UnionOfColumns(homalg_variable_1071,homalg_variable_1517);;
gap> homalg_variable_1519 := homalg_variable_1480 - homalg_variable_1518;;
gap> homalg_variable_1520 := SI_matrix(homalg_variable_5,1,10,"0");;
gap> homalg_variable_1519 = homalg_variable_1520;
true
gap> SIH_ZeroRows(homalg_variable_375);
[  ]
gap> homalg_variable_375 = homalg_variable_918;
false
gap> homalg_variable_1521 := homalg_variable_377 * homalg_variable_375;;
gap> homalg_variable_1522 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1521 = homalg_variable_1522;
true
gap> homalg_variable_1523 := SIH_BasisOfRowModule(homalg_variable_377);;
gap> SI_nrows(homalg_variable_1523);
1
gap> homalg_variable_1524 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1523 = homalg_variable_1524;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_377);; homalg_variable_1525 := homalg_variable_l[1];; homalg_variable_1526 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1525);
1
gap> homalg_variable_1527 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1525 = homalg_variable_1527;
false
gap> SI_ncols(homalg_variable_1526);
1
gap> homalg_variable_1528 := homalg_variable_1526 * homalg_variable_377;;
gap> homalg_variable_1525 = homalg_variable_1528;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1523,homalg_variable_1525);; homalg_variable_1529 := homalg_variable_l[1];; homalg_variable_1530 := homalg_variable_l[2];;
gap> homalg_variable_1531 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1529 = homalg_variable_1531;
true
gap> homalg_variable_1532 := homalg_variable_1530 * homalg_variable_1525;;
gap> homalg_variable_1533 := homalg_variable_1523 + homalg_variable_1532;;
gap> homalg_variable_1529 = homalg_variable_1533;
true
gap> homalg_variable_1534 := SIH_DecideZeroRows(homalg_variable_1523,homalg_variable_1525);;
gap> homalg_variable_1535 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1534 = homalg_variable_1535;
true
gap> homalg_variable_1536 := homalg_variable_1530 * (homalg_variable_8);;
gap> homalg_variable_1537 := homalg_variable_1536 * homalg_variable_1526;;
gap> homalg_variable_1538 := homalg_variable_1537 * homalg_variable_377;;
gap> homalg_variable_1538 = homalg_variable_1523;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_377,homalg_variable_1523);; homalg_variable_1539 := homalg_variable_l[1];; homalg_variable_1540 := homalg_variable_l[2];;
gap> homalg_variable_1541 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1539 = homalg_variable_1541;
true
gap> homalg_variable_1542 := homalg_variable_1540 * homalg_variable_1523;;
gap> homalg_variable_1543 := homalg_variable_377 + homalg_variable_1542;;
gap> homalg_variable_1539 = homalg_variable_1543;
true
gap> homalg_variable_1544 := SIH_DecideZeroRows(homalg_variable_377,homalg_variable_1523);;
gap> homalg_variable_1545 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1544 = homalg_variable_1545;
true
gap> homalg_variable_1546 := homalg_variable_1540 * (homalg_variable_8);;
gap> homalg_variable_1547 := homalg_variable_1546 * homalg_variable_1523;;
gap> homalg_variable_1547 = homalg_variable_377;
true
gap> homalg_variable_1523 = homalg_variable_377;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1140,homalg_variable_385);; homalg_variable_1548 := homalg_variable_l[1];; homalg_variable_1549 := homalg_variable_l[2];;
gap> homalg_variable_1550 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_1548 = homalg_variable_1550;
true
gap> homalg_variable_1551 := homalg_variable_1549 * homalg_variable_385;;
gap> homalg_variable_1552 := homalg_variable_1140 + homalg_variable_1551;;
gap> homalg_variable_1548 = homalg_variable_1552;
true
gap> homalg_variable_1553 := SIH_DecideZeroRows(homalg_variable_1140,homalg_variable_385);;
gap> homalg_variable_1554 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_1553 = homalg_variable_1554;
true
gap> SI_ncols(homalg_variable_386);
4
gap> SI_nrows(homalg_variable_386);
4
gap> homalg_variable_1555 := homalg_variable_1549 * (homalg_variable_8);;
gap> homalg_variable_1556 := homalg_variable_1555 * homalg_variable_386;;
gap> homalg_variable_1557 := homalg_variable_1556 * homalg_variable_375;;
gap> homalg_variable_1558 := homalg_variable_1557 - homalg_variable_1140;;
gap> homalg_variable_1559 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_1558 = homalg_variable_1559;
true
gap> homalg_variable_1561 := homalg_variable_1149 * homalg_variable_1556;;
gap> homalg_variable_1560 := SIH_DecideZeroRows(homalg_variable_1561,homalg_variable_1523);;
gap> homalg_variable_1562 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_1560 = homalg_variable_1562;
true
gap> homalg_variable_1563 := SIH_DecideZeroRows(homalg_variable_414,homalg_variable_409);;
gap> homalg_variable_1564 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_1563 = homalg_variable_1564;
false
gap> homalg_variable_1565 := SIH_UnionOfRows(homalg_variable_1563,homalg_variable_409);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1565);; homalg_variable_1566 := homalg_variable_l[1];; homalg_variable_1567 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1566);
4
gap> homalg_variable_1568 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1566 = homalg_variable_1568;
false
gap> SI_ncols(homalg_variable_1567);
8
gap> homalg_variable_1569 := SIH_Submatrix(homalg_variable_1567,[1..4],[ 1, 2 ]);;
gap> homalg_variable_1570 := homalg_variable_1569 * homalg_variable_1563;;
gap> homalg_variable_1571 := SIH_Submatrix(homalg_variable_1567,[1..4],[ 3, 4, 5, 6, 7, 8 ]);;
gap> homalg_variable_1572 := homalg_variable_1571 * homalg_variable_409;;
gap> homalg_variable_1573 := homalg_variable_1570 + homalg_variable_1572;;
gap> homalg_variable_1566 = homalg_variable_1573;
true
gap> homalg_variable_1566 = homalg_variable_918;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_411,homalg_variable_1566);; homalg_variable_1574 := homalg_variable_l[1];; homalg_variable_1575 := homalg_variable_l[2];;
gap> homalg_variable_1576 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1574 = homalg_variable_1576;
true
gap> homalg_variable_1577 := homalg_variable_1575 * homalg_variable_1566;;
gap> homalg_variable_1578 := homalg_variable_411 + homalg_variable_1577;;
gap> homalg_variable_1574 = homalg_variable_1578;
true
gap> homalg_variable_1579 := SIH_DecideZeroRows(homalg_variable_411,homalg_variable_1566);;
gap> homalg_variable_1580 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1579 = homalg_variable_1580;
true
gap> homalg_variable_1582 := homalg_variable_1575 * (homalg_variable_8);;
gap> homalg_variable_1583 := SIH_Submatrix(homalg_variable_1567,[1..4],[ 1, 2 ]);;
gap> homalg_variable_1584 := homalg_variable_1582 * homalg_variable_1583;;
gap> homalg_variable_1585 := homalg_variable_1584 * homalg_variable_414;;
gap> homalg_variable_1586 := homalg_variable_1585 - homalg_variable_375;;
gap> homalg_variable_1581 := SIH_DecideZeroRows(homalg_variable_1586,homalg_variable_409);;
gap> homalg_variable_1587 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1581 = homalg_variable_1587;
true
gap> homalg_variable_1589 := homalg_variable_1523 * homalg_variable_1584;;
gap> homalg_variable_1588 := SIH_DecideZeroRows(homalg_variable_1589,homalg_variable_480);;
gap> homalg_variable_1590 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_1588 = homalg_variable_1590;
true
gap> homalg_variable_1591 := SIH_DecideZeroRows(homalg_variable_1584,homalg_variable_480);;
gap> homalg_variable_1592 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_1591 = homalg_variable_1592;
false
gap> homalg_variable_1593 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_1584 = homalg_variable_1593;
false
gap> homalg_variable_1594 := SIH_UnionOfRows(homalg_variable_1591,homalg_variable_480);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1594);; homalg_variable_1595 := homalg_variable_l[1];; homalg_variable_1596 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1595);
2
gap> homalg_variable_1597 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_1595 = homalg_variable_1597;
false
gap> SI_ncols(homalg_variable_1596);
9
gap> homalg_variable_1598 := SIH_Submatrix(homalg_variable_1596,[1..2],[ 1, 2, 3, 4 ]);;
gap> homalg_variable_1599 := homalg_variable_1598 * homalg_variable_1591;;
gap> homalg_variable_1600 := SIH_Submatrix(homalg_variable_1596,[1..2],[ 5, 6, 7, 8, 9 ]);;
gap> homalg_variable_1601 := homalg_variable_1600 * homalg_variable_480;;
gap> homalg_variable_1602 := homalg_variable_1599 + homalg_variable_1601;;
gap> homalg_variable_1595 = homalg_variable_1602;
true
gap> homalg_variable_1603 := SIH_DecideZeroRows(homalg_variable_813,homalg_variable_480);;
gap> homalg_variable_1604 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_1603 = homalg_variable_1604;
false
gap> homalg_variable_1595 = homalg_variable_813;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1603,homalg_variable_1595);; homalg_variable_1605 := homalg_variable_l[1];; homalg_variable_1606 := homalg_variable_l[2];;
gap> homalg_variable_1607 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_1605 = homalg_variable_1607;
true
gap> homalg_variable_1608 := homalg_variable_1606 * homalg_variable_1595;;
gap> homalg_variable_1609 := homalg_variable_1603 + homalg_variable_1608;;
gap> homalg_variable_1605 = homalg_variable_1609;
true
gap> homalg_variable_1610 := SIH_DecideZeroRows(homalg_variable_1603,homalg_variable_1595);;
gap> homalg_variable_1611 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_1610 = homalg_variable_1611;
true
gap> homalg_variable_1613 := homalg_variable_1606 * (homalg_variable_8);;
gap> homalg_variable_1614 := SIH_Submatrix(homalg_variable_1596,[1..2],[ 1, 2, 3, 4 ]);;
gap> homalg_variable_1615 := homalg_variable_1613 * homalg_variable_1614;;
gap> homalg_variable_1616 := homalg_variable_1615 * homalg_variable_1584;;
gap> homalg_variable_1617 := homalg_variable_1616 - homalg_variable_813;;
gap> homalg_variable_1612 := SIH_DecideZeroRows(homalg_variable_1617,homalg_variable_480);;
gap> homalg_variable_1618 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_1612 = homalg_variable_1618;
true
gap> homalg_variable_1620 := SIH_UnionOfRows(homalg_variable_1556,homalg_variable_1615);;
gap> homalg_variable_1621 := SIH_UnionOfRows(homalg_variable_1620,homalg_variable_1523);;
gap> homalg_variable_1619 := SIH_BasisOfRowModule(homalg_variable_1621);;
gap> SI_nrows(homalg_variable_1619);
4
gap> homalg_variable_1622 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1619 = homalg_variable_1622;
false
gap> homalg_variable_1623 := SIH_DecideZeroRows(homalg_variable_918,homalg_variable_1619);;
gap> homalg_variable_1624 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1623 = homalg_variable_1624;
true
gap> homalg_variable_1625 := SIH_RelativeSyzygiesGeneratorsOfRows(homalg_variable_1620,homalg_variable_1523);;
gap> SI_nrows(homalg_variable_1625);
5
gap> homalg_variable_1626 := SI_matrix(homalg_variable_5,5,7,"0");;
gap> homalg_variable_1625 = homalg_variable_1626;
false
gap> homalg_variable_1627 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1625);;
gap> SI_nrows(homalg_variable_1627);
1
gap> homalg_variable_1628 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_1627 = homalg_variable_1628;
false
gap> homalg_variable_1629 := SI_\[(homalg_variable_1627,1,5);;
gap> SI_deg( homalg_variable_1629 );
-1
gap> homalg_variable_1630 := SI_\[(homalg_variable_1627,1,4);;
gap> SI_deg( homalg_variable_1630 );
-1
gap> homalg_variable_1631 := SI_\[(homalg_variable_1627,1,3);;
gap> SI_deg( homalg_variable_1631 );
0
gap> homalg_variable_1632 := SI_\[(homalg_variable_1627,1,1);;
gap> IsZero(homalg_variable_1632);
false
gap> homalg_variable_1633 := SI_\[(homalg_variable_1627,1,2);;
gap> IsZero(homalg_variable_1633);
false
gap> homalg_variable_1634 := SI_\[(homalg_variable_1627,1,3);;
gap> IsZero(homalg_variable_1634);
false
gap> homalg_variable_1635 := SI_\[(homalg_variable_1627,1,4);;
gap> IsZero(homalg_variable_1635);
true
gap> homalg_variable_1636 := SI_\[(homalg_variable_1627,1,5);;
gap> IsZero(homalg_variable_1636);
true
gap> homalg_variable_1638 := SIH_Submatrix(homalg_variable_1625,[ 1, 2, 4, 5 ],[1..7]);;
gap> homalg_variable_1637 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1638);;
gap> SI_nrows(homalg_variable_1637);
1
gap> homalg_variable_1639 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1637 = homalg_variable_1639;
true
gap> homalg_variable_1640 := SIH_BasisOfRowModule(homalg_variable_1625);;
gap> SI_nrows(homalg_variable_1640);
5
gap> homalg_variable_1641 := SI_matrix(homalg_variable_5,5,7,"0");;
gap> homalg_variable_1640 = homalg_variable_1641;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1638);; homalg_variable_1642 := homalg_variable_l[1];; homalg_variable_1643 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1642);
5
gap> homalg_variable_1644 := SI_matrix(homalg_variable_5,5,7,"0");;
gap> homalg_variable_1642 = homalg_variable_1644;
false
gap> SI_ncols(homalg_variable_1643);
4
gap> homalg_variable_1645 := homalg_variable_1643 * homalg_variable_1638;;
gap> homalg_variable_1642 = homalg_variable_1645;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1640,homalg_variable_1642);; homalg_variable_1646 := homalg_variable_l[1];; homalg_variable_1647 := homalg_variable_l[2];;
gap> homalg_variable_1648 := SI_matrix(homalg_variable_5,5,7,"0");;
gap> homalg_variable_1646 = homalg_variable_1648;
true
gap> homalg_variable_1649 := homalg_variable_1647 * homalg_variable_1642;;
gap> homalg_variable_1650 := homalg_variable_1640 + homalg_variable_1649;;
gap> homalg_variable_1646 = homalg_variable_1650;
true
gap> homalg_variable_1651 := SIH_DecideZeroRows(homalg_variable_1640,homalg_variable_1642);;
gap> homalg_variable_1652 := SI_matrix(homalg_variable_5,5,7,"0");;
gap> homalg_variable_1651 = homalg_variable_1652;
true
gap> homalg_variable_1653 := homalg_variable_1647 * (homalg_variable_8);;
gap> homalg_variable_1654 := homalg_variable_1653 * homalg_variable_1643;;
gap> homalg_variable_1655 := homalg_variable_1654 * homalg_variable_1638;;
gap> homalg_variable_1655 = homalg_variable_1640;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1638,homalg_variable_1640);; homalg_variable_1656 := homalg_variable_l[1];; homalg_variable_1657 := homalg_variable_l[2];;
gap> homalg_variable_1658 := SI_matrix(homalg_variable_5,4,7,"0");;
gap> homalg_variable_1656 = homalg_variable_1658;
true
gap> homalg_variable_1659 := homalg_variable_1657 * homalg_variable_1640;;
gap> homalg_variable_1660 := homalg_variable_1638 + homalg_variable_1659;;
gap> homalg_variable_1656 = homalg_variable_1660;
true
gap> homalg_variable_1661 := SIH_DecideZeroRows(homalg_variable_1638,homalg_variable_1640);;
gap> homalg_variable_1662 := SI_matrix(homalg_variable_5,4,7,"0");;
gap> homalg_variable_1661 = homalg_variable_1662;
true
gap> homalg_variable_1663 := homalg_variable_1657 * (homalg_variable_8);;
gap> homalg_variable_1664 := homalg_variable_1663 * homalg_variable_1640;;
gap> homalg_variable_1664 = homalg_variable_1638;
true
gap> SIH_ZeroRows(homalg_variable_1638);
[  ]
gap> SIH_ZeroRows(homalg_variable_583);
[  ]
gap> homalg_variable_1665 := homalg_variable_582 * homalg_variable_583;;
gap> homalg_variable_1666 := SI_matrix(homalg_variable_5,3,2,"0");;
gap> homalg_variable_1665 = homalg_variable_1666;
true
gap> homalg_variable_1667 := SIH_DecideZeroRows(homalg_variable_582,homalg_variable_626);;
gap> homalg_variable_1668 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_1667 = homalg_variable_1668;
true
gap> homalg_variable_1669 := SIH_Submatrix(homalg_variable_1638,[1..4],[ 6, 7 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1669,homalg_variable_598);; homalg_variable_1670 := homalg_variable_l[1];; homalg_variable_1671 := homalg_variable_l[2];;
gap> homalg_variable_1672 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_1670 = homalg_variable_1672;
true
gap> homalg_variable_1673 := homalg_variable_1671 * homalg_variable_598;;
gap> homalg_variable_1674 := homalg_variable_1669 + homalg_variable_1673;;
gap> homalg_variable_1670 = homalg_variable_1674;
true
gap> homalg_variable_1675 := SIH_DecideZeroRows(homalg_variable_1669,homalg_variable_598);;
gap> homalg_variable_1676 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_1675 = homalg_variable_1676;
true
gap> SI_ncols(homalg_variable_599);
4
gap> SI_nrows(homalg_variable_599);
5
gap> homalg_variable_1677 := homalg_variable_1671 * (homalg_variable_8);;
gap> homalg_variable_1678 := homalg_variable_1677 * homalg_variable_599;;
gap> homalg_variable_1679 := homalg_variable_1678 * homalg_variable_583;;
gap> homalg_variable_1680 := homalg_variable_1679 - homalg_variable_1669;;
gap> homalg_variable_1681 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_1680 = homalg_variable_1681;
true
gap> homalg_variable_1682 := SI_matrix(homalg_variable_5,3,2,"0");;
gap> homalg_variable_1683 := SIH_UnionOfColumns(homalg_variable_1149,homalg_variable_1682);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1683,homalg_variable_1642);; homalg_variable_1684 := homalg_variable_l[1];; homalg_variable_1685 := homalg_variable_l[2];;
gap> homalg_variable_1686 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_1684 = homalg_variable_1686;
true
gap> homalg_variable_1687 := homalg_variable_1685 * homalg_variable_1642;;
gap> homalg_variable_1688 := homalg_variable_1683 + homalg_variable_1687;;
gap> homalg_variable_1684 = homalg_variable_1688;
true
gap> homalg_variable_1689 := SIH_DecideZeroRows(homalg_variable_1683,homalg_variable_1642);;
gap> homalg_variable_1690 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_1689 = homalg_variable_1690;
true
gap> SI_ncols(homalg_variable_1643);
4
gap> SI_nrows(homalg_variable_1643);
5
gap> homalg_variable_1691 := homalg_variable_1685 * (homalg_variable_8);;
gap> homalg_variable_1692 := homalg_variable_1691 * homalg_variable_1643;;
gap> homalg_variable_1693 := homalg_variable_1692 * homalg_variable_1638;;
gap> homalg_variable_1694 := homalg_variable_1693 - homalg_variable_1683;;
gap> homalg_variable_1695 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_1694 = homalg_variable_1695;
true
gap> homalg_variable_1696 := homalg_variable_1197 * homalg_variable_1692;;
gap> homalg_variable_1697 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1696 = homalg_variable_1697;
true
gap> homalg_variable_1698 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1692);;
gap> SI_nrows(homalg_variable_1698);
1
gap> homalg_variable_1699 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1698 = homalg_variable_1699;
false
gap> homalg_variable_1700 := SIH_BasisOfRowModule(homalg_variable_1698);;
gap> SI_nrows(homalg_variable_1700);
1
gap> homalg_variable_1701 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1700 = homalg_variable_1701;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1698);; homalg_variable_1702 := homalg_variable_l[1];; homalg_variable_1703 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1702);
1
gap> homalg_variable_1704 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1702 = homalg_variable_1704;
false
gap> SI_ncols(homalg_variable_1703);
1
gap> homalg_variable_1705 := homalg_variable_1703 * homalg_variable_1698;;
gap> homalg_variable_1702 = homalg_variable_1705;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1700,homalg_variable_1702);; homalg_variable_1706 := homalg_variable_l[1];; homalg_variable_1707 := homalg_variable_l[2];;
gap> homalg_variable_1708 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1706 = homalg_variable_1708;
true
gap> homalg_variable_1709 := homalg_variable_1707 * homalg_variable_1702;;
gap> homalg_variable_1710 := homalg_variable_1700 + homalg_variable_1709;;
gap> homalg_variable_1706 = homalg_variable_1710;
true
gap> homalg_variable_1711 := SIH_DecideZeroRows(homalg_variable_1700,homalg_variable_1702);;
gap> homalg_variable_1712 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1711 = homalg_variable_1712;
true
gap> homalg_variable_1713 := homalg_variable_1707 * (homalg_variable_8);;
gap> homalg_variable_1714 := homalg_variable_1713 * homalg_variable_1703;;
gap> homalg_variable_1715 := homalg_variable_1714 * homalg_variable_1698;;
gap> homalg_variable_1715 = homalg_variable_1700;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1698,homalg_variable_1700);; homalg_variable_1716 := homalg_variable_l[1];; homalg_variable_1717 := homalg_variable_l[2];;
gap> homalg_variable_1718 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1716 = homalg_variable_1718;
true
gap> homalg_variable_1719 := homalg_variable_1717 * homalg_variable_1700;;
gap> homalg_variable_1720 := homalg_variable_1698 + homalg_variable_1719;;
gap> homalg_variable_1716 = homalg_variable_1720;
true
gap> homalg_variable_1721 := SIH_DecideZeroRows(homalg_variable_1698,homalg_variable_1700);;
gap> homalg_variable_1722 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1721 = homalg_variable_1722;
true
gap> homalg_variable_1723 := homalg_variable_1717 * (homalg_variable_8);;
gap> homalg_variable_1724 := homalg_variable_1723 * homalg_variable_1700;;
gap> homalg_variable_1724 = homalg_variable_1698;
true
gap> homalg_variable_1725 := SIH_DecideZeroRows(homalg_variable_1698,homalg_variable_1197);;
gap> homalg_variable_1726 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1725 = homalg_variable_1726;
true
gap> homalg_variable_1728 := SIH_UnionOfRows(homalg_variable_1678,homalg_variable_626);;
gap> homalg_variable_1727 := SIH_BasisOfRowModule(homalg_variable_1728);;
gap> SI_nrows(homalg_variable_1727);
4
gap> homalg_variable_1729 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1727 = homalg_variable_1729;
false
gap> homalg_variable_1730 := SIH_DecideZeroRows(homalg_variable_918,homalg_variable_1727);;
gap> homalg_variable_1731 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1730 = homalg_variable_1731;
true
gap> homalg_variable_1733 := SIH_UnionOfRows(homalg_variable_918,homalg_variable_626);;
gap> homalg_variable_1732 := SIH_BasisOfRowModule(homalg_variable_1733);;
gap> SI_nrows(homalg_variable_1732);
4
gap> homalg_variable_1734 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1732 = homalg_variable_1734;
false
gap> homalg_variable_1735 := SIH_DecideZeroRows(homalg_variable_918,homalg_variable_1732);;
gap> homalg_variable_1736 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1735 = homalg_variable_1736;
true
gap> homalg_variable_1737 := SIH_DecideZeroRows(homalg_variable_1678,homalg_variable_626);;
gap> homalg_variable_1738 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1737 = homalg_variable_1738;
false
gap> homalg_variable_1739 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1678 = homalg_variable_1739;
false
gap> homalg_variable_1740 := SIH_UnionOfRows(homalg_variable_1737,homalg_variable_626);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1740);; homalg_variable_1741 := homalg_variable_l[1];; homalg_variable_1742 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1741);
4
gap> homalg_variable_1743 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1741 = homalg_variable_1743;
false
gap> SI_ncols(homalg_variable_1742);
7
gap> homalg_variable_1744 := SIH_Submatrix(homalg_variable_1742,[1..4],[ 1, 2, 3, 4 ]);;
gap> homalg_variable_1745 := homalg_variable_1744 * homalg_variable_1737;;
gap> homalg_variable_1746 := SIH_Submatrix(homalg_variable_1742,[1..4],[ 5, 6, 7 ]);;
gap> homalg_variable_1747 := homalg_variable_1746 * homalg_variable_626;;
gap> homalg_variable_1748 := homalg_variable_1745 + homalg_variable_1747;;
gap> homalg_variable_1741 = homalg_variable_1748;
true
gap> homalg_variable_1749 := SIH_DecideZeroRows(homalg_variable_918,homalg_variable_626);;
gap> homalg_variable_1750 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1749 = homalg_variable_1750;
false
gap> homalg_variable_1741 = homalg_variable_918;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1749,homalg_variable_1741);; homalg_variable_1751 := homalg_variable_l[1];; homalg_variable_1752 := homalg_variable_l[2];;
gap> homalg_variable_1753 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1751 = homalg_variable_1753;
true
gap> homalg_variable_1754 := homalg_variable_1752 * homalg_variable_1741;;
gap> homalg_variable_1755 := homalg_variable_1749 + homalg_variable_1754;;
gap> homalg_variable_1751 = homalg_variable_1755;
true
gap> homalg_variable_1756 := SIH_DecideZeroRows(homalg_variable_1749,homalg_variable_1741);;
gap> homalg_variable_1757 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1756 = homalg_variable_1757;
true
gap> homalg_variable_1759 := homalg_variable_1752 * (homalg_variable_8);;
gap> homalg_variable_1760 := SIH_Submatrix(homalg_variable_1742,[1..4],[ 1, 2, 3, 4 ]);;
gap> homalg_variable_1761 := homalg_variable_1759 * homalg_variable_1760;;
gap> homalg_variable_1762 := homalg_variable_1761 * homalg_variable_1678;;
gap> homalg_variable_1763 := homalg_variable_1762 - homalg_variable_918;;
gap> homalg_variable_1758 := SIH_DecideZeroRows(homalg_variable_1763,homalg_variable_626);;
gap> homalg_variable_1764 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1758 = homalg_variable_1764;
true
gap> homalg_variable_1766 := homalg_variable_1692 * homalg_variable_1638;;
gap> homalg_variable_1767 := homalg_variable_1761 * homalg_variable_1638;;
gap> homalg_variable_1768 := SIH_UnionOfRows(homalg_variable_1766,homalg_variable_1767);;
gap> homalg_variable_1765 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1768);;
gap> SI_nrows(homalg_variable_1765);
3
gap> homalg_variable_1769 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_1765 = homalg_variable_1769;
false
gap> homalg_variable_1770 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1765);;
gap> SI_nrows(homalg_variable_1770);
1
gap> homalg_variable_1771 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1770 = homalg_variable_1771;
true
gap> homalg_variable_1772 := SIH_BasisOfRowModule(homalg_variable_1765);;
gap> SI_nrows(homalg_variable_1772);
4
gap> homalg_variable_1773 := SI_matrix(homalg_variable_5,4,7,"0");;
gap> homalg_variable_1772 = homalg_variable_1773;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1765);; homalg_variable_1774 := homalg_variable_l[1];; homalg_variable_1775 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1774);
4
gap> homalg_variable_1776 := SI_matrix(homalg_variable_5,4,7,"0");;
gap> homalg_variable_1774 = homalg_variable_1776;
false
gap> SI_ncols(homalg_variable_1775);
3
gap> homalg_variable_1777 := homalg_variable_1775 * homalg_variable_1765;;
gap> homalg_variable_1774 = homalg_variable_1777;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1772,homalg_variable_1774);; homalg_variable_1778 := homalg_variable_l[1];; homalg_variable_1779 := homalg_variable_l[2];;
gap> homalg_variable_1780 := SI_matrix(homalg_variable_5,4,7,"0");;
gap> homalg_variable_1778 = homalg_variable_1780;
true
gap> homalg_variable_1781 := homalg_variable_1779 * homalg_variable_1774;;
gap> homalg_variable_1782 := homalg_variable_1772 + homalg_variable_1781;;
gap> homalg_variable_1778 = homalg_variable_1782;
true
gap> homalg_variable_1783 := SIH_DecideZeroRows(homalg_variable_1772,homalg_variable_1774);;
gap> homalg_variable_1784 := SI_matrix(homalg_variable_5,4,7,"0");;
gap> homalg_variable_1783 = homalg_variable_1784;
true
gap> homalg_variable_1785 := homalg_variable_1779 * (homalg_variable_8);;
gap> homalg_variable_1786 := homalg_variable_1785 * homalg_variable_1775;;
gap> homalg_variable_1787 := homalg_variable_1786 * homalg_variable_1765;;
gap> homalg_variable_1787 = homalg_variable_1772;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1765,homalg_variable_1772);; homalg_variable_1788 := homalg_variable_l[1];; homalg_variable_1789 := homalg_variable_l[2];;
gap> homalg_variable_1790 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_1788 = homalg_variable_1790;
true
gap> homalg_variable_1791 := homalg_variable_1789 * homalg_variable_1772;;
gap> homalg_variable_1792 := homalg_variable_1765 + homalg_variable_1791;;
gap> homalg_variable_1788 = homalg_variable_1792;
true
gap> homalg_variable_1793 := SIH_DecideZeroRows(homalg_variable_1765,homalg_variable_1772);;
gap> homalg_variable_1794 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_1793 = homalg_variable_1794;
true
gap> homalg_variable_1795 := homalg_variable_1789 * (homalg_variable_8);;
gap> homalg_variable_1796 := homalg_variable_1795 * homalg_variable_1772;;
gap> homalg_variable_1796 = homalg_variable_1765;
true
gap> SIH_ZeroRows(homalg_variable_1765);
[  ]
gap> SIH_ZeroRows(homalg_variable_582);
[  ]
gap> homalg_variable_1797 := homalg_variable_621 * homalg_variable_582;;
gap> homalg_variable_1798 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1797 = homalg_variable_1798;
true
gap> homalg_variable_1799 := SIH_DecideZeroRows(homalg_variable_621,homalg_variable_651);;
gap> homalg_variable_1800 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1799 = homalg_variable_1800;
true
gap> homalg_variable_1801 := SIH_Submatrix(homalg_variable_1765,[1..3],[ 4, 5, 6, 7 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1801,homalg_variable_582);; homalg_variable_1802 := homalg_variable_l[1];; homalg_variable_1803 := homalg_variable_l[2];;
gap> homalg_variable_1804 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_1802 = homalg_variable_1804;
true
gap> homalg_variable_1805 := homalg_variable_1803 * homalg_variable_582;;
gap> homalg_variable_1806 := homalg_variable_1801 + homalg_variable_1805;;
gap> homalg_variable_1802 = homalg_variable_1806;
true
gap> homalg_variable_1807 := SIH_DecideZeroRows(homalg_variable_1801,homalg_variable_582);;
gap> homalg_variable_1808 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_1807 = homalg_variable_1808;
true
gap> homalg_variable_1809 := homalg_variable_1803 * (homalg_variable_8);;
gap> homalg_variable_1810 := homalg_variable_1809 * homalg_variable_582;;
gap> homalg_variable_1811 := homalg_variable_1810 - homalg_variable_1801;;
gap> homalg_variable_1812 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_1811 = homalg_variable_1812;
true
gap> homalg_variable_1813 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1814 := SIH_UnionOfColumns(homalg_variable_1195,homalg_variable_1813);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1814,homalg_variable_1774);; homalg_variable_1815 := homalg_variable_l[1];; homalg_variable_1816 := homalg_variable_l[2];;
gap> homalg_variable_1817 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1815 = homalg_variable_1817;
true
gap> homalg_variable_1818 := homalg_variable_1816 * homalg_variable_1774;;
gap> homalg_variable_1819 := homalg_variable_1814 + homalg_variable_1818;;
gap> homalg_variable_1815 = homalg_variable_1819;
true
gap> homalg_variable_1820 := SIH_DecideZeroRows(homalg_variable_1814,homalg_variable_1774);;
gap> homalg_variable_1821 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1820 = homalg_variable_1821;
true
gap> SI_ncols(homalg_variable_1775);
3
gap> SI_nrows(homalg_variable_1775);
4
gap> homalg_variable_1822 := homalg_variable_1816 * (homalg_variable_8);;
gap> homalg_variable_1823 := homalg_variable_1822 * homalg_variable_1775;;
gap> homalg_variable_1824 := homalg_variable_1823 * homalg_variable_1765;;
gap> homalg_variable_1825 := homalg_variable_1824 - homalg_variable_1814;;
gap> homalg_variable_1826 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1825 = homalg_variable_1826;
true
gap> homalg_variable_1827 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1823);;
gap> SI_nrows(homalg_variable_1827);
1
gap> homalg_variable_1828 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_1827 = homalg_variable_1828;
true
gap> homalg_variable_1830 := SIH_UnionOfRows(homalg_variable_1809,homalg_variable_651);;
gap> homalg_variable_1829 := SIH_BasisOfRowModule(homalg_variable_1830);;
gap> SI_nrows(homalg_variable_1829);
3
gap> homalg_variable_1831 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1829 = homalg_variable_1831;
false
gap> homalg_variable_1832 := SIH_DecideZeroRows(homalg_variable_1367,homalg_variable_1829);;
gap> homalg_variable_1833 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1832 = homalg_variable_1833;
true
gap> homalg_variable_1835 := SIH_UnionOfRows(homalg_variable_1367,homalg_variable_651);;
gap> homalg_variable_1834 := SIH_BasisOfRowModule(homalg_variable_1835);;
gap> SI_nrows(homalg_variable_1834);
3
gap> homalg_variable_1836 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1834 = homalg_variable_1836;
false
gap> homalg_variable_1837 := SIH_DecideZeroRows(homalg_variable_1367,homalg_variable_1834);;
gap> homalg_variable_1838 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1837 = homalg_variable_1838;
true
gap> homalg_variable_1839 := SIH_DecideZeroRows(homalg_variable_1809,homalg_variable_651);;
gap> homalg_variable_1840 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1839 = homalg_variable_1840;
false
gap> homalg_variable_1841 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1803 = homalg_variable_1841;
false
gap> homalg_variable_1842 := SIH_UnionOfRows(homalg_variable_1839,homalg_variable_651);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1842);; homalg_variable_1843 := homalg_variable_l[1];; homalg_variable_1844 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1843);
3
gap> homalg_variable_1845 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1843 = homalg_variable_1845;
false
gap> SI_ncols(homalg_variable_1844);
4
gap> homalg_variable_1846 := SIH_Submatrix(homalg_variable_1844,[1..3],[ 1, 2, 3 ]);;
gap> homalg_variable_1847 := homalg_variable_1846 * homalg_variable_1839;;
gap> homalg_variable_1848 := SIH_Submatrix(homalg_variable_1844,[1..3],[ 4 ]);;
gap> homalg_variable_1849 := homalg_variable_1848 * homalg_variable_651;;
gap> homalg_variable_1850 := homalg_variable_1847 + homalg_variable_1849;;
gap> homalg_variable_1843 = homalg_variable_1850;
true
gap> homalg_variable_1851 := SIH_DecideZeroRows(homalg_variable_1367,homalg_variable_651);;
gap> homalg_variable_1852 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1851 = homalg_variable_1852;
false
gap> homalg_variable_1843 = homalg_variable_1367;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1851,homalg_variable_1843);; homalg_variable_1853 := homalg_variable_l[1];; homalg_variable_1854 := homalg_variable_l[2];;
gap> homalg_variable_1855 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1853 = homalg_variable_1855;
true
gap> homalg_variable_1856 := homalg_variable_1854 * homalg_variable_1843;;
gap> homalg_variable_1857 := homalg_variable_1851 + homalg_variable_1856;;
gap> homalg_variable_1853 = homalg_variable_1857;
true
gap> homalg_variable_1858 := SIH_DecideZeroRows(homalg_variable_1851,homalg_variable_1843);;
gap> homalg_variable_1859 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1858 = homalg_variable_1859;
true
gap> homalg_variable_1861 := homalg_variable_1854 * (homalg_variable_8);;
gap> homalg_variable_1862 := SIH_Submatrix(homalg_variable_1844,[1..3],[ 1, 2, 3 ]);;
gap> homalg_variable_1863 := homalg_variable_1861 * homalg_variable_1862;;
gap> homalg_variable_1864 := homalg_variable_1863 * homalg_variable_1809;;
gap> homalg_variable_1865 := homalg_variable_1864 - homalg_variable_1367;;
gap> homalg_variable_1860 := SIH_DecideZeroRows(homalg_variable_1865,homalg_variable_651);;
gap> homalg_variable_1866 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1860 = homalg_variable_1866;
true
gap> homalg_variable_1868 := homalg_variable_1823 * homalg_variable_1765;;
gap> homalg_variable_1869 := homalg_variable_1863 * homalg_variable_1765;;
gap> homalg_variable_1870 := SIH_UnionOfRows(homalg_variable_1868,homalg_variable_1869);;
gap> homalg_variable_1867 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1870);;
gap> SI_nrows(homalg_variable_1867);
1
gap> homalg_variable_1871 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1867 = homalg_variable_1871;
false
gap> homalg_variable_1872 := SIH_BasisOfRowModule(homalg_variable_1867);;
gap> SI_nrows(homalg_variable_1872);
1
gap> homalg_variable_1873 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1872 = homalg_variable_1873;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1867);; homalg_variable_1874 := homalg_variable_l[1];; homalg_variable_1875 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1874);
1
gap> homalg_variable_1876 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1874 = homalg_variable_1876;
false
gap> SI_ncols(homalg_variable_1875);
1
gap> homalg_variable_1877 := homalg_variable_1875 * homalg_variable_1867;;
gap> homalg_variable_1874 = homalg_variable_1877;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1872,homalg_variable_1874);; homalg_variable_1878 := homalg_variable_l[1];; homalg_variable_1879 := homalg_variable_l[2];;
gap> homalg_variable_1880 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1878 = homalg_variable_1880;
true
gap> homalg_variable_1881 := homalg_variable_1879 * homalg_variable_1874;;
gap> homalg_variable_1882 := homalg_variable_1872 + homalg_variable_1881;;
gap> homalg_variable_1878 = homalg_variable_1882;
true
gap> homalg_variable_1883 := SIH_DecideZeroRows(homalg_variable_1872,homalg_variable_1874);;
gap> homalg_variable_1884 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1883 = homalg_variable_1884;
true
gap> homalg_variable_1885 := homalg_variable_1879 * (homalg_variable_8);;
gap> homalg_variable_1886 := homalg_variable_1885 * homalg_variable_1875;;
gap> homalg_variable_1887 := homalg_variable_1886 * homalg_variable_1867;;
gap> homalg_variable_1887 = homalg_variable_1872;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1867,homalg_variable_1872);; homalg_variable_1888 := homalg_variable_l[1];; homalg_variable_1889 := homalg_variable_l[2];;
gap> homalg_variable_1890 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1888 = homalg_variable_1890;
true
gap> homalg_variable_1891 := homalg_variable_1889 * homalg_variable_1872;;
gap> homalg_variable_1892 := homalg_variable_1867 + homalg_variable_1891;;
gap> homalg_variable_1888 = homalg_variable_1892;
true
gap> homalg_variable_1893 := SIH_DecideZeroRows(homalg_variable_1867,homalg_variable_1872);;
gap> homalg_variable_1894 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1893 = homalg_variable_1894;
true
gap> homalg_variable_1895 := homalg_variable_1889 * (homalg_variable_8);;
gap> homalg_variable_1896 := homalg_variable_1895 * homalg_variable_1872;;
gap> homalg_variable_1896 = homalg_variable_1867;
true
gap> homalg_variable_1897 := SIH_Submatrix(homalg_variable_1867,[1..1],[ 2, 3, 4 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1897,homalg_variable_621);; homalg_variable_1898 := homalg_variable_l[1];; homalg_variable_1899 := homalg_variable_l[2];;
gap> homalg_variable_1900 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1898 = homalg_variable_1900;
true
gap> homalg_variable_1901 := homalg_variable_1899 * homalg_variable_621;;
gap> homalg_variable_1902 := homalg_variable_1897 + homalg_variable_1901;;
gap> homalg_variable_1898 = homalg_variable_1902;
true
gap> homalg_variable_1903 := SIH_DecideZeroRows(homalg_variable_1897,homalg_variable_621);;
gap> homalg_variable_1904 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1903 = homalg_variable_1904;
true
gap> homalg_variable_1905 := homalg_variable_1899 * (homalg_variable_8);;
gap> homalg_variable_1906 := homalg_variable_1905 * homalg_variable_621;;
gap> homalg_variable_1907 := homalg_variable_1906 - homalg_variable_1897;;
gap> homalg_variable_1908 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1907 = homalg_variable_1908;
true
gap> homalg_variable_1909 := SIH_BasisOfRowModule(homalg_variable_1905);;
gap> SI_nrows(homalg_variable_1909);
1
gap> homalg_variable_1910 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_1909 = homalg_variable_1910;
false
gap> homalg_variable_1909 = homalg_variable_1905;
true
gap> homalg_variable_1911 := SIH_DecideZeroRows(homalg_variable_237,homalg_variable_1909);;
gap> homalg_variable_1912 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_1911 = homalg_variable_1912;
true
gap> homalg_variable_1905 = homalg_variable_237;
true
gap> homalg_variable_1913 := homalg_variable_1905 - homalg_variable_237;;
gap> homalg_variable_1914 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_1913 = homalg_variable_1914;
true
gap> homalg_variable_1915 := SIH_Submatrix(homalg_variable_1868,[1..1],[ 1, 2, 3 ]);;
gap> homalg_variable_1916 := homalg_variable_1915 * homalg_variable_1766;;
gap> homalg_variable_1917 := SIH_Submatrix(homalg_variable_1869,[1..3],[ 1, 2, 3 ]);;
gap> homalg_variable_1918 := homalg_variable_1917 * homalg_variable_1766;;
gap> homalg_variable_1919 := SIH_UnionOfRows(homalg_variable_1916,homalg_variable_1918);;
gap> homalg_variable_1920 := SIH_Submatrix(homalg_variable_1868,[1..1],[ 4, 5, 6, 7 ]);;
gap> homalg_variable_1921 := homalg_variable_1920 * homalg_variable_1767;;
gap> homalg_variable_1922 := SIH_Submatrix(homalg_variable_1869,[1..3],[ 4, 5, 6, 7 ]);;
gap> homalg_variable_1923 := homalg_variable_1922 * homalg_variable_1767;;
gap> homalg_variable_1924 := SIH_UnionOfRows(homalg_variable_1921,homalg_variable_1923);;
gap> homalg_variable_1925 := homalg_variable_1919 + homalg_variable_1924;;
gap> homalg_variable_1926 := SI_matrix(homalg_variable_5,4,7,"0");;
gap> homalg_variable_1925 = homalg_variable_1926;
true
gap> homalg_variable_1927 := SIH_Submatrix(homalg_variable_1867,[1..1],[ 1 ]);;
gap> homalg_variable_1928 := homalg_variable_1927 * homalg_variable_1868;;
gap> homalg_variable_1929 := SIH_Submatrix(homalg_variable_1867,[1..1],[ 2, 3, 4 ]);;
gap> homalg_variable_1930 := homalg_variable_1929 * homalg_variable_1869;;
gap> homalg_variable_1931 := homalg_variable_1928 + homalg_variable_1930;;
gap> homalg_variable_1932 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1931 = homalg_variable_1932;
true
gap> homalg_variable_1933 := SI_matrix(homalg_variable_5,3,2,"0");;
gap> homalg_variable_1934 := SIH_UnionOfRows(homalg_variable_1933,homalg_variable_583);;
gap> homalg_variable_1935 := SIH_Submatrix(homalg_variable_1766,[1..3],[ 6, 7 ]);;
gap> homalg_variable_1936 := SIH_Submatrix(homalg_variable_1767,[1..4],[ 6, 7 ]);;
gap> homalg_variable_1937 := SIH_UnionOfRows(homalg_variable_1935,homalg_variable_1936);;
gap> homalg_variable_1938 := homalg_variable_1934 - homalg_variable_1937;;
gap> homalg_variable_1939 := SI_matrix(homalg_variable_5,7,2,"0");;
gap> homalg_variable_1938 = homalg_variable_1939;
true
gap> homalg_variable_1940 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1941 := SIH_UnionOfRows(homalg_variable_1940,homalg_variable_582);;
gap> homalg_variable_1942 := SIH_Submatrix(homalg_variable_1868,[1..1],[ 4, 5, 6, 7 ]);;
gap> homalg_variable_1943 := SIH_Submatrix(homalg_variable_1869,[1..3],[ 4, 5, 6, 7 ]);;
gap> homalg_variable_1944 := SIH_UnionOfRows(homalg_variable_1942,homalg_variable_1943);;
gap> homalg_variable_1945 := homalg_variable_1941 - homalg_variable_1944;;
gap> homalg_variable_1946 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_1945 = homalg_variable_1946;
true
gap> homalg_variable_1947 := SIH_Submatrix(homalg_variable_1867,[1..1],[ 2, 3, 4 ]);;
gap> homalg_variable_1948 := homalg_variable_621 - homalg_variable_1947;;
gap> homalg_variable_1949 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1948 = homalg_variable_1949;
true
gap> homalg_variable_1950 := SI_matrix(homalg_variable_5,3,2,"0");;
gap> homalg_variable_1951 := SIH_UnionOfColumns(homalg_variable_1149,homalg_variable_1950);;
gap> homalg_variable_1952 := homalg_variable_1766 - homalg_variable_1951;;
gap> homalg_variable_1953 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_1952 = homalg_variable_1953;
true
gap> homalg_variable_1954 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_1955 := SIH_UnionOfColumns(homalg_variable_1195,homalg_variable_1954);;
gap> homalg_variable_1956 := homalg_variable_1868 - homalg_variable_1955;;
gap> homalg_variable_1957 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1956 = homalg_variable_1957;
true
gap> SIH_ZeroRows(homalg_variable_173);
[ 1 ]
gap> homalg_variable_1959 := SIH_Submatrix(homalg_variable_173,[ 2, 3, 4 ],[1..1]);;
gap> homalg_variable_1958 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1959);;
gap> SI_nrows(homalg_variable_1958);
3
gap> homalg_variable_1960 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1958 = homalg_variable_1960;
false
gap> homalg_variable_1961 := homalg_variable_1958 * homalg_variable_1959;;
gap> homalg_variable_1962 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_1961 = homalg_variable_1962;
true
gap> homalg_variable_1963 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1958);;
gap> SI_nrows(homalg_variable_1963);
1
gap> homalg_variable_1964 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_1963 = homalg_variable_1964;
false
gap> homalg_variable_1965 := SI_\[(homalg_variable_1963,1,3);;
gap> SI_deg( homalg_variable_1965 );
1
gap> homalg_variable_1966 := SI_\[(homalg_variable_1963,1,2);;
gap> SI_deg( homalg_variable_1966 );
1
gap> homalg_variable_1967 := SI_\[(homalg_variable_1963,1,1);;
gap> SI_deg( homalg_variable_1967 );
1
gap> homalg_variable_1968 := SIH_BasisOfRowModule(homalg_variable_1958);;
gap> SI_nrows(homalg_variable_1968);
3
gap> homalg_variable_1969 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1968 = homalg_variable_1969;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1958);; homalg_variable_1970 := homalg_variable_l[1];; homalg_variable_1971 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1970);
3
gap> homalg_variable_1972 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1970 = homalg_variable_1972;
false
gap> SI_ncols(homalg_variable_1971);
3
gap> homalg_variable_1973 := homalg_variable_1971 * homalg_variable_1958;;
gap> homalg_variable_1970 = homalg_variable_1973;
true
gap> homalg_variable_1970 = homalg_variable_1367;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1968,homalg_variable_1970);; homalg_variable_1974 := homalg_variable_l[1];; homalg_variable_1975 := homalg_variable_l[2];;
gap> homalg_variable_1976 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1974 = homalg_variable_1976;
true
gap> homalg_variable_1977 := homalg_variable_1975 * homalg_variable_1970;;
gap> homalg_variable_1978 := homalg_variable_1968 + homalg_variable_1977;;
gap> homalg_variable_1974 = homalg_variable_1978;
true
gap> homalg_variable_1979 := SIH_DecideZeroRows(homalg_variable_1968,homalg_variable_1970);;
gap> homalg_variable_1980 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1979 = homalg_variable_1980;
true
gap> homalg_variable_1981 := homalg_variable_1975 * (homalg_variable_8);;
gap> homalg_variable_1982 := homalg_variable_1981 * homalg_variable_1971;;
gap> homalg_variable_1983 := homalg_variable_1982 * homalg_variable_1958;;
gap> homalg_variable_1983 = homalg_variable_1968;
true
gap> homalg_variable_1968 = homalg_variable_1367;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_1958,homalg_variable_1968);; homalg_variable_1984 := homalg_variable_l[1];; homalg_variable_1985 := homalg_variable_l[2];;
gap> homalg_variable_1986 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1984 = homalg_variable_1986;
true
gap> homalg_variable_1987 := homalg_variable_1985 * homalg_variable_1968;;
gap> homalg_variable_1988 := homalg_variable_1958 + homalg_variable_1987;;
gap> homalg_variable_1984 = homalg_variable_1988;
true
gap> homalg_variable_1989 := SIH_DecideZeroRows(homalg_variable_1958,homalg_variable_1968);;
gap> homalg_variable_1990 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_1989 = homalg_variable_1990;
true
gap> homalg_variable_1991 := homalg_variable_1985 * (homalg_variable_8);;
gap> homalg_variable_1992 := homalg_variable_1991 * homalg_variable_1968;;
gap> homalg_variable_1992 = homalg_variable_1958;
true
gap> homalg_variable_1968 = homalg_variable_1958;
true
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_1959);; homalg_variable_1993 := homalg_variable_l[1];; homalg_variable_1994 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_1993);
3
gap> homalg_variable_1995 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_1993 = homalg_variable_1995;
false
gap> SI_ncols(homalg_variable_1994);
3
gap> homalg_variable_1996 := homalg_variable_1994 * homalg_variable_1959;;
gap> homalg_variable_1993 = homalg_variable_1996;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_173,homalg_variable_1993);; homalg_variable_1997 := homalg_variable_l[1];; homalg_variable_1998 := homalg_variable_l[2];;
gap> homalg_variable_1999 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_1997 = homalg_variable_1999;
true
gap> homalg_variable_2000 := homalg_variable_1998 * homalg_variable_1993;;
gap> for _del in [ "homalg_variable_1484", "homalg_variable_1485", "homalg_variable_1486", "homalg_variable_1487", "homalg_variable_1488", "homalg_variable_1489", "homalg_variable_1490", "homalg_variable_1491", "homalg_variable_1492", "homalg_variable_1493", "homalg_variable_1494", "homalg_variable_1495", "homalg_variable_1496", "homalg_variable_1497", "homalg_variable_1498", "homalg_variable_1499", "homalg_variable_1500", "homalg_variable_1501", "homalg_variable_1502", "homalg_variable_1503", "homalg_variable_1504", "homalg_variable_1505", "homalg_variable_1506", "homalg_variable_1507", "homalg_variable_1508", "homalg_variable_1509", "homalg_variable_1510", "homalg_variable_1511", "homalg_variable_1512", "homalg_variable_1513", "homalg_variable_1514", "homalg_variable_1515", "homalg_variable_1516", "homalg_variable_1517", "homalg_variable_1518", "homalg_variable_1519", "homalg_variable_1520", "homalg_variable_1521", "homalg_variable_1522", "homalg_variable_1524", "homalg_variable_1527", "homalg_variable_1528", "homalg_variable_1529", "homalg_variable_1530", "homalg_variable_1531", "homalg_variable_1532", "homalg_variable_1533", "homalg_variable_1534", "homalg_variable_1535", "homalg_variable_1536", "homalg_variable_1537", "homalg_variable_1538", "homalg_variable_1539", "homalg_variable_1540", "homalg_variable_1541", "homalg_variable_1542", "homalg_variable_1543", "homalg_variable_1544", "homalg_variable_1545", "homalg_variable_1546", "homalg_variable_1547", "homalg_variable_1548", "homalg_variable_1550", "homalg_variable_1551", "homalg_variable_1552", "homalg_variable_1553", "homalg_variable_1554", "homalg_variable_1557", "homalg_variable_1558", "homalg_variable_1559", "homalg_variable_1560", "homalg_variable_1561", "homalg_variable_1562", "homalg_variable_1563", "homalg_variable_1564", "homalg_variable_1565", "homalg_variable_1566", "homalg_variable_1568", "homalg_variable_1569", "homalg_variable_1570", "homalg_variable_1571", "homalg_variable_1572", "homalg_variable_1573", "homalg_variable_1574", "homalg_variable_1576", "homalg_variable_1577", "homalg_variable_1578", "homalg_variable_1579", "homalg_variable_1580", "homalg_variable_1581", "homalg_variable_1585", "homalg_variable_1586", "homalg_variable_1587", "homalg_variable_1588", "homalg_variable_1589", "homalg_variable_1590", "homalg_variable_1592", "homalg_variable_1593", "homalg_variable_1597", "homalg_variable_1598", "homalg_variable_1599", "homalg_variable_1600", "homalg_variable_1601", "homalg_variable_1602", "homalg_variable_1604", "homalg_variable_1607", "homalg_variable_1608", "homalg_variable_1609", "homalg_variable_1610", "homalg_variable_1611", "homalg_variable_1612", "homalg_variable_1616", "homalg_variable_1617", "homalg_variable_1618", "homalg_variable_1622", "homalg_variable_1623", "homalg_variable_1624", "homalg_variable_1626", "homalg_variable_1628", "homalg_variable_1629", "homalg_variable_1630", "homalg_variable_1631", "homalg_variable_1632", "homalg_variable_1633", "homalg_variable_1634", "homalg_variable_1635", "homalg_variable_1636", "homalg_variable_1637", "homalg_variable_1639", "homalg_variable_1641", "homalg_variable_1644", "homalg_variable_1645", "homalg_variable_1646", "homalg_variable_1647", "homalg_variable_1648", "homalg_variable_1649", "homalg_variable_1650", "homalg_variable_1651", "homalg_variable_1652", "homalg_variable_1653", "homalg_variable_1654", "homalg_variable_1655", "homalg_variable_1656", "homalg_variable_1657", "homalg_variable_1658", "homalg_variable_1659", "homalg_variable_1660", "homalg_variable_1661", "homalg_variable_1662", "homalg_variable_1663", "homalg_variable_1664", "homalg_variable_1665", "homalg_variable_1666", "homalg_variable_1667", "homalg_variable_1668", "homalg_variable_1670", "homalg_variable_1672", "homalg_variable_1673", "homalg_variable_1674", "homalg_variable_1675", "homalg_variable_1676", "homalg_variable_1679", "homalg_variable_1680", "homalg_variable_1681", "homalg_variable_1684", "homalg_variable_1686", "homalg_variable_1687", "homalg_variable_1688", "homalg_variable_1689", "homalg_variable_1690", "homalg_variable_1693", "homalg_variable_1694", "homalg_variable_1695", "homalg_variable_1696", "homalg_variable_1697", "homalg_variable_1699", "homalg_variable_1701", "homalg_variable_1704", "homalg_variable_1705", "homalg_variable_1706", "homalg_variable_1707", "homalg_variable_1708", "homalg_variable_1709", "homalg_variable_1710", "homalg_variable_1711", "homalg_variable_1712", "homalg_variable_1713", "homalg_variable_1714", "homalg_variable_1715", "homalg_variable_1718", "homalg_variable_1721", "homalg_variable_1722", "homalg_variable_1724", "homalg_variable_1725", "homalg_variable_1726", "homalg_variable_1729", "homalg_variable_1730", "homalg_variable_1731", "homalg_variable_1734", "homalg_variable_1735", "homalg_variable_1736", "homalg_variable_1737", "homalg_variable_1738", "homalg_variable_1739", "homalg_variable_1740", "homalg_variable_1741", "homalg_variable_1743", "homalg_variable_1744", "homalg_variable_1745", "homalg_variable_1746", "homalg_variable_1747", "homalg_variable_1748", "homalg_variable_1749", "homalg_variable_1750", "homalg_variable_1751", "homalg_variable_1753", "homalg_variable_1754", "homalg_variable_1755", "homalg_variable_1756", "homalg_variable_1757", "homalg_variable_1758", "homalg_variable_1762", "homalg_variable_1763", "homalg_variable_1764", "homalg_variable_1769", "homalg_variable_1770", "homalg_variable_1771", "homalg_variable_1773", "homalg_variable_1776", "homalg_variable_1777", "homalg_variable_1780", "homalg_variable_1781", "homalg_variable_1782", "homalg_variable_1784", "homalg_variable_1787", "homalg_variable_1788", "homalg_variable_1789", "homalg_variable_1790", "homalg_variable_1791", "homalg_variable_1792", "homalg_variable_1793", "homalg_variable_1794", "homalg_variable_1795", "homalg_variable_1796", "homalg_variable_1797", "homalg_variable_1798", "homalg_variable_1799", "homalg_variable_1800", "homalg_variable_1802", "homalg_variable_1804", "homalg_variable_1805", "homalg_variable_1806", "homalg_variable_1807", "homalg_variable_1808", "homalg_variable_1810", "homalg_variable_1811", "homalg_variable_1812", "homalg_variable_1815", "homalg_variable_1817", "homalg_variable_1818", "homalg_variable_1819", "homalg_variable_1820", "homalg_variable_1821", "homalg_variable_1824", "homalg_variable_1825", "homalg_variable_1826", "homalg_variable_1827", "homalg_variable_1828", "homalg_variable_1831", "homalg_variable_1832", "homalg_variable_1833", "homalg_variable_1836", "homalg_variable_1837", "homalg_variable_1838", "homalg_variable_1839", "homalg_variable_1840", "homalg_variable_1841", "homalg_variable_1842", "homalg_variable_1843", "homalg_variable_1845", "homalg_variable_1846", "homalg_variable_1847", "homalg_variable_1848", "homalg_variable_1849", "homalg_variable_1850", "homalg_variable_1851", "homalg_variable_1852", "homalg_variable_1853", "homalg_variable_1855", "homalg_variable_1856", "homalg_variable_1857", "homalg_variable_1858", "homalg_variable_1859", "homalg_variable_1860", "homalg_variable_1864", "homalg_variable_1865", "homalg_variable_1866", "homalg_variable_1871", "homalg_variable_1873", "homalg_variable_1876", "homalg_variable_1877", "homalg_variable_1878", "homalg_variable_1879", "homalg_variable_1880", "homalg_variable_1881", "homalg_variable_1882", "homalg_variable_1883", "homalg_variable_1884", "homalg_variable_1885", "homalg_variable_1886", "homalg_variable_1887", "homalg_variable_1888", "homalg_variable_1889", "homalg_variable_1890", "homalg_variable_1891", "homalg_variable_1892", "homalg_variable_1893", "homalg_variable_1894", "homalg_variable_1895", "homalg_variable_1896", "homalg_variable_1898", "homalg_variable_1900", "homalg_variable_1901", "homalg_variable_1902", "homalg_variable_1903", "homalg_variable_1904", "homalg_variable_1906", "homalg_variable_1907", "homalg_variable_1908", "homalg_variable_1910", "homalg_variable_1911", "homalg_variable_1912", "homalg_variable_1913", "homalg_variable_1914", "homalg_variable_1915", "homalg_variable_1916", "homalg_variable_1917", "homalg_variable_1918", "homalg_variable_1919", "homalg_variable_1920", "homalg_variable_1921", "homalg_variable_1922", "homalg_variable_1923", "homalg_variable_1924", "homalg_variable_1925", "homalg_variable_1926", "homalg_variable_1927", "homalg_variable_1928", "homalg_variable_1929", "homalg_variable_1930", "homalg_variable_1931", "homalg_variable_1932", "homalg_variable_1940", "homalg_variable_1941", "homalg_variable_1942", "homalg_variable_1943", "homalg_variable_1944", "homalg_variable_1945", "homalg_variable_1946", "homalg_variable_1947", "homalg_variable_1948", "homalg_variable_1949", "homalg_variable_1950", "homalg_variable_1951", "homalg_variable_1952", "homalg_variable_1953", "homalg_variable_1954", "homalg_variable_1955", "homalg_variable_1956", "homalg_variable_1957", "homalg_variable_1960", "homalg_variable_1961", "homalg_variable_1962", "homalg_variable_1964", "homalg_variable_1965", "homalg_variable_1966", "homalg_variable_1967", "homalg_variable_1969", "homalg_variable_1972", "homalg_variable_1973", "homalg_variable_1974", "homalg_variable_1975", "homalg_variable_1976", "homalg_variable_1977", "homalg_variable_1978", "homalg_variable_1979", "homalg_variable_1980", "homalg_variable_1981", "homalg_variable_1982", "homalg_variable_1983", "homalg_variable_1984", "homalg_variable_1985", "homalg_variable_1986", "homalg_variable_1987", "homalg_variable_1988", "homalg_variable_1989", "homalg_variable_1990", "homalg_variable_1991", "homalg_variable_1992", "homalg_variable_1995" ] do UnbindGlobal( _del );; od;;
gap> homalg_variable_2001 := homalg_variable_173 + homalg_variable_2000;;
gap> homalg_variable_1997 = homalg_variable_2001;
true
gap> homalg_variable_2002 := SIH_DecideZeroRows(homalg_variable_173,homalg_variable_1993);;
gap> homalg_variable_2003 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_2002 = homalg_variable_2003;
true
gap> homalg_variable_2004 := homalg_variable_1998 * (homalg_variable_8);;
gap> homalg_variable_2005 := homalg_variable_2004 * homalg_variable_1994;;
gap> homalg_variable_2006 := homalg_variable_2005 * homalg_variable_1959;;
gap> homalg_variable_2007 := homalg_variable_2006 - homalg_variable_173;;
gap> homalg_variable_2008 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_2007 = homalg_variable_2008;
true
gap> homalg_variable_2010 := SIH_UnionOfRows(homalg_variable_2005,homalg_variable_1968);;
gap> homalg_variable_2009 := SIH_BasisOfRowModule(homalg_variable_2010);;
gap> SI_nrows(homalg_variable_2009);
3
gap> homalg_variable_2011 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2009 = homalg_variable_2011;
false
gap> homalg_variable_2012 := SIH_DecideZeroRows(homalg_variable_1367,homalg_variable_2009);;
gap> homalg_variable_2013 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2012 = homalg_variable_2013;
true
gap> homalg_variable_2014 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_1968);;
gap> SI_nrows(homalg_variable_2014);
1
gap> homalg_variable_2015 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2014 = homalg_variable_2015;
false
gap> homalg_variable_2016 := SIH_BasisOfRowModule(homalg_variable_2014);;
gap> SI_nrows(homalg_variable_2016);
1
gap> homalg_variable_2017 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2016 = homalg_variable_2017;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_2014);; homalg_variable_2018 := homalg_variable_l[1];; homalg_variable_2019 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_2018);
1
gap> homalg_variable_2020 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2018 = homalg_variable_2020;
false
gap> SI_ncols(homalg_variable_2019);
1
gap> homalg_variable_2021 := homalg_variable_2019 * homalg_variable_2014;;
gap> homalg_variable_2018 = homalg_variable_2021;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2016,homalg_variable_2018);; homalg_variable_2022 := homalg_variable_l[1];; homalg_variable_2023 := homalg_variable_l[2];;
gap> homalg_variable_2024 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2022 = homalg_variable_2024;
true
gap> homalg_variable_2025 := homalg_variable_2023 * homalg_variable_2018;;
gap> homalg_variable_2026 := homalg_variable_2016 + homalg_variable_2025;;
gap> homalg_variable_2022 = homalg_variable_2026;
true
gap> homalg_variable_2027 := SIH_DecideZeroRows(homalg_variable_2016,homalg_variable_2018);;
gap> homalg_variable_2028 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2027 = homalg_variable_2028;
true
gap> homalg_variable_2029 := homalg_variable_2023 * (homalg_variable_8);;
gap> homalg_variable_2030 := homalg_variable_2029 * homalg_variable_2019;;
gap> homalg_variable_2031 := homalg_variable_2030 * homalg_variable_2014;;
gap> homalg_variable_2031 = homalg_variable_2016;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2014,homalg_variable_2016);; homalg_variable_2032 := homalg_variable_l[1];; homalg_variable_2033 := homalg_variable_l[2];;
gap> homalg_variable_2034 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2032 = homalg_variable_2034;
true
gap> homalg_variable_2035 := homalg_variable_2033 * homalg_variable_2016;;
gap> homalg_variable_2036 := homalg_variable_2014 + homalg_variable_2035;;
gap> homalg_variable_2032 = homalg_variable_2036;
true
gap> homalg_variable_2037 := SIH_DecideZeroRows(homalg_variable_2014,homalg_variable_2016);;
gap> homalg_variable_2038 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2037 = homalg_variable_2038;
true
gap> homalg_variable_2039 := homalg_variable_2033 * (homalg_variable_8);;
gap> homalg_variable_2040 := homalg_variable_2039 * homalg_variable_2016;;
gap> homalg_variable_2040 = homalg_variable_2014;
true
gap> homalg_variable_2041 := homalg_variable_2014 * homalg_variable_1968;;
gap> homalg_variable_2042 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2041 = homalg_variable_2042;
true
gap> homalg_variable_2016 = homalg_variable_2014;
true
gap> homalg_variable_2043 := SIH_DecideZeroRows(homalg_variable_2005,homalg_variable_1968);;
gap> homalg_variable_2044 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2043 = homalg_variable_2044;
false
gap> homalg_variable_2045 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2005 = homalg_variable_2045;
false
gap> homalg_variable_2046 := SIH_UnionOfRows(homalg_variable_2043,homalg_variable_1968);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_2046);; homalg_variable_2047 := homalg_variable_l[1];; homalg_variable_2048 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_2047);
3
gap> homalg_variable_2049 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2047 = homalg_variable_2049;
false
gap> SI_ncols(homalg_variable_2048);
7
gap> homalg_variable_2050 := SIH_Submatrix(homalg_variable_2048,[1..3],[ 1, 2, 3, 4 ]);;
gap> homalg_variable_2051 := homalg_variable_2050 * homalg_variable_2043;;
gap> homalg_variable_2052 := SIH_Submatrix(homalg_variable_2048,[1..3],[ 5, 6, 7 ]);;
gap> homalg_variable_2053 := homalg_variable_2052 * homalg_variable_1968;;
gap> homalg_variable_2054 := homalg_variable_2051 + homalg_variable_2053;;
gap> homalg_variable_2047 = homalg_variable_2054;
true
gap> homalg_variable_2055 := SIH_DecideZeroRows(homalg_variable_1367,homalg_variable_1968);;
gap> homalg_variable_2056 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2055 = homalg_variable_2056;
false
gap> homalg_variable_2047 = homalg_variable_1367;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2055,homalg_variable_2047);; homalg_variable_2057 := homalg_variable_l[1];; homalg_variable_2058 := homalg_variable_l[2];;
gap> homalg_variable_2059 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2057 = homalg_variable_2059;
true
gap> homalg_variable_2060 := homalg_variable_2058 * homalg_variable_2047;;
gap> homalg_variable_2061 := homalg_variable_2055 + homalg_variable_2060;;
gap> homalg_variable_2057 = homalg_variable_2061;
true
gap> homalg_variable_2062 := SIH_DecideZeroRows(homalg_variable_2055,homalg_variable_2047);;
gap> homalg_variable_2063 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2062 = homalg_variable_2063;
true
gap> homalg_variable_2065 := homalg_variable_2058 * (homalg_variable_8);;
gap> homalg_variable_2066 := SIH_Submatrix(homalg_variable_2048,[1..3],[ 1, 2, 3, 4 ]);;
gap> homalg_variable_2067 := homalg_variable_2065 * homalg_variable_2066;;
gap> homalg_variable_2068 := homalg_variable_2067 * homalg_variable_2005;;
gap> homalg_variable_2069 := homalg_variable_2068 - homalg_variable_1367;;
gap> homalg_variable_2064 := SIH_DecideZeroRows(homalg_variable_2069,homalg_variable_1968);;
gap> homalg_variable_2070 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2064 = homalg_variable_2070;
true
gap> homalg_variable_2072 := homalg_variable_1556 * homalg_variable_375;;
gap> homalg_variable_2073 := homalg_variable_1615 * homalg_variable_375;;
gap> homalg_variable_2074 := SIH_UnionOfRows(homalg_variable_2072,homalg_variable_2073);;
gap> homalg_variable_2075 := SIH_UnionOfRows(homalg_variable_2074,homalg_variable_2067);;
gap> homalg_variable_2071 := SIH_BasisOfRowModule(homalg_variable_2075);;
gap> SI_nrows(homalg_variable_2071);
4
gap> homalg_variable_2076 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_2071 = homalg_variable_2076;
false
gap> homalg_variable_2077 := SIH_DecideZeroRows(homalg_variable_918,homalg_variable_2071);;
gap> homalg_variable_2078 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_2077 = homalg_variable_2078;
true
gap> homalg_variable_2079 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_2075);;
gap> SI_nrows(homalg_variable_2079);
6
gap> homalg_variable_2080 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_2079 = homalg_variable_2080;
false
gap> homalg_variable_2081 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_2079);;
gap> SI_nrows(homalg_variable_2081);
1
gap> homalg_variable_2082 := SI_matrix(homalg_variable_5,1,6,"0");;
gap> homalg_variable_2081 = homalg_variable_2082;
true
gap> homalg_variable_2083 := SIH_BasisOfRowModule(homalg_variable_2079);;
gap> SI_nrows(homalg_variable_2083);
8
gap> homalg_variable_2084 := SI_matrix(homalg_variable_5,8,10,"0");;
gap> homalg_variable_2083 = homalg_variable_2084;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_2079);; homalg_variable_2085 := homalg_variable_l[1];; homalg_variable_2086 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_2085);
8
gap> homalg_variable_2087 := SI_matrix(homalg_variable_5,8,10,"0");;
gap> homalg_variable_2085 = homalg_variable_2087;
false
gap> SI_ncols(homalg_variable_2086);
6
gap> homalg_variable_2088 := homalg_variable_2086 * homalg_variable_2079;;
gap> homalg_variable_2085 = homalg_variable_2088;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2083,homalg_variable_2085);; homalg_variable_2089 := homalg_variable_l[1];; homalg_variable_2090 := homalg_variable_l[2];;
gap> homalg_variable_2091 := SI_matrix(homalg_variable_5,8,10,"0");;
gap> homalg_variable_2089 = homalg_variable_2091;
true
gap> homalg_variable_2092 := homalg_variable_2090 * homalg_variable_2085;;
gap> homalg_variable_2093 := homalg_variable_2083 + homalg_variable_2092;;
gap> homalg_variable_2089 = homalg_variable_2093;
true
gap> homalg_variable_2094 := SIH_DecideZeroRows(homalg_variable_2083,homalg_variable_2085);;
gap> homalg_variable_2095 := SI_matrix(homalg_variable_5,8,10,"0");;
gap> homalg_variable_2094 = homalg_variable_2095;
true
gap> homalg_variable_2096 := homalg_variable_2090 * (homalg_variable_8);;
gap> homalg_variable_2097 := homalg_variable_2096 * homalg_variable_2086;;
gap> homalg_variable_2098 := homalg_variable_2097 * homalg_variable_2079;;
gap> homalg_variable_2098 = homalg_variable_2083;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2079,homalg_variable_2083);; homalg_variable_2099 := homalg_variable_l[1];; homalg_variable_2100 := homalg_variable_l[2];;
gap> homalg_variable_2101 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_2099 = homalg_variable_2101;
true
gap> homalg_variable_2102 := homalg_variable_2100 * homalg_variable_2083;;
gap> homalg_variable_2103 := homalg_variable_2079 + homalg_variable_2102;;
gap> homalg_variable_2099 = homalg_variable_2103;
true
gap> homalg_variable_2104 := SIH_DecideZeroRows(homalg_variable_2079,homalg_variable_2083);;
gap> homalg_variable_2105 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_2104 = homalg_variable_2105;
true
gap> homalg_variable_2106 := homalg_variable_2100 * (homalg_variable_8);;
gap> homalg_variable_2107 := homalg_variable_2106 * homalg_variable_2083;;
gap> homalg_variable_2107 = homalg_variable_2079;
true
gap> SIH_ZeroRows(homalg_variable_2079);
[  ]
gap> SIH_ZeroRows(homalg_variable_1968);
[  ]
gap> homalg_variable_2108 := homalg_variable_2014 * homalg_variable_1968;;
gap> homalg_variable_2109 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2108 = homalg_variable_2109;
true
gap> homalg_variable_2110 := SIH_DecideZeroRows(homalg_variable_2014,homalg_variable_2016);;
gap> homalg_variable_2111 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2110 = homalg_variable_2111;
true
gap> homalg_variable_2112 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_1766 = homalg_variable_2112;
false
gap> SIH_ZeroRows(homalg_variable_1768);
[  ]
gap> homalg_variable_1768 = homalg_variable_1375;
false
gap> homalg_variable_2113 := SIH_Submatrix(homalg_variable_1765,[1..3],[ 1, 2, 3 ]);;
gap> homalg_variable_2114 := homalg_variable_2113 * homalg_variable_1766;;
gap> homalg_variable_2115 := SIH_Submatrix(homalg_variable_1765,[1..3],[ 4, 5, 6, 7 ]);;
gap> homalg_variable_2116 := homalg_variable_2115 * homalg_variable_1767;;
gap> homalg_variable_2117 := homalg_variable_2114 + homalg_variable_2116;;
gap> homalg_variable_2118 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_2117 = homalg_variable_2118;
true
gap> homalg_variable_2119 := SIH_DecideZeroRows(homalg_variable_1765,homalg_variable_1772);;
gap> homalg_variable_2120 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_2119 = homalg_variable_2120;
true
gap> homalg_variable_2121 := SIH_Submatrix(homalg_variable_2079,[1..6],[ 8, 9, 10 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2121,homalg_variable_1968);; homalg_variable_2122 := homalg_variable_l[1];; homalg_variable_2123 := homalg_variable_l[2];;
gap> homalg_variable_2124 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_2122 = homalg_variable_2124;
true
gap> homalg_variable_2125 := homalg_variable_2123 * homalg_variable_1968;;
gap> homalg_variable_2126 := homalg_variable_2121 + homalg_variable_2125;;
gap> homalg_variable_2122 = homalg_variable_2126;
true
gap> homalg_variable_2127 := SIH_DecideZeroRows(homalg_variable_2121,homalg_variable_1968);;
gap> homalg_variable_2128 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_2127 = homalg_variable_2128;
true
gap> homalg_variable_2129 := homalg_variable_2123 * (homalg_variable_8);;
gap> homalg_variable_2130 := homalg_variable_2129 * homalg_variable_1968;;
gap> homalg_variable_2131 := homalg_variable_2130 - homalg_variable_2121;;
gap> homalg_variable_2132 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_2131 = homalg_variable_2132;
true
gap> homalg_variable_2133 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2134 := SIH_UnionOfColumns(homalg_variable_1766,homalg_variable_2133);;
gap> homalg_variable_2135 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2136 := SIH_UnionOfColumns(homalg_variable_1767,homalg_variable_2135);;
gap> homalg_variable_2137 := SIH_UnionOfRows(homalg_variable_2134,homalg_variable_2136);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2137,homalg_variable_2085);; homalg_variable_2138 := homalg_variable_l[1];; homalg_variable_2139 := homalg_variable_l[2];;
gap> homalg_variable_2140 := SI_matrix(homalg_variable_5,7,10,"0");;
gap> homalg_variable_2138 = homalg_variable_2140;
true
gap> homalg_variable_2141 := homalg_variable_2139 * homalg_variable_2085;;
gap> homalg_variable_2142 := homalg_variable_2137 + homalg_variable_2141;;
gap> homalg_variable_2138 = homalg_variable_2142;
true
gap> homalg_variable_2143 := SIH_DecideZeroRows(homalg_variable_2137,homalg_variable_2085);;
gap> homalg_variable_2144 := SI_matrix(homalg_variable_5,7,10,"0");;
gap> homalg_variable_2143 = homalg_variable_2144;
true
gap> SI_ncols(homalg_variable_2086);
6
gap> SI_nrows(homalg_variable_2086);
8
gap> homalg_variable_2145 := homalg_variable_2139 * (homalg_variable_8);;
gap> homalg_variable_2146 := homalg_variable_2145 * homalg_variable_2086;;
gap> homalg_variable_2147 := homalg_variable_2146 * homalg_variable_2079;;
gap> homalg_variable_2148 := homalg_variable_2147 - homalg_variable_2137;;
gap> homalg_variable_2149 := SI_matrix(homalg_variable_5,7,10,"0");;
gap> homalg_variable_2148 = homalg_variable_2149;
true
gap> homalg_variable_2150 := homalg_variable_1772 * homalg_variable_2146;;
gap> homalg_variable_2151 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_2150 = homalg_variable_2151;
true
gap> homalg_variable_2152 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_2146);;
gap> SI_nrows(homalg_variable_2152);
3
gap> homalg_variable_2153 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_2152 = homalg_variable_2153;
false
gap> homalg_variable_2154 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_2152);;
gap> SI_nrows(homalg_variable_2154);
1
gap> homalg_variable_2155 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2154 = homalg_variable_2155;
true
gap> homalg_variable_2156 := SIH_BasisOfRowModule(homalg_variable_2152);;
gap> SI_nrows(homalg_variable_2156);
4
gap> homalg_variable_2157 := SI_matrix(homalg_variable_5,4,7,"0");;
gap> homalg_variable_2156 = homalg_variable_2157;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_2152);; homalg_variable_2158 := homalg_variable_l[1];; homalg_variable_2159 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_2158);
4
gap> homalg_variable_2160 := SI_matrix(homalg_variable_5,4,7,"0");;
gap> homalg_variable_2158 = homalg_variable_2160;
false
gap> SI_ncols(homalg_variable_2159);
3
gap> homalg_variable_2161 := homalg_variable_2159 * homalg_variable_2152;;
gap> homalg_variable_2158 = homalg_variable_2161;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2156,homalg_variable_2158);; homalg_variable_2162 := homalg_variable_l[1];; homalg_variable_2163 := homalg_variable_l[2];;
gap> homalg_variable_2164 := SI_matrix(homalg_variable_5,4,7,"0");;
gap> homalg_variable_2162 = homalg_variable_2164;
true
gap> homalg_variable_2165 := homalg_variable_2163 * homalg_variable_2158;;
gap> homalg_variable_2166 := homalg_variable_2156 + homalg_variable_2165;;
gap> homalg_variable_2162 = homalg_variable_2166;
true
gap> homalg_variable_2167 := SIH_DecideZeroRows(homalg_variable_2156,homalg_variable_2158);;
gap> homalg_variable_2168 := SI_matrix(homalg_variable_5,4,7,"0");;
gap> homalg_variable_2167 = homalg_variable_2168;
true
gap> homalg_variable_2169 := homalg_variable_2163 * (homalg_variable_8);;
gap> homalg_variable_2170 := homalg_variable_2169 * homalg_variable_2159;;
gap> homalg_variable_2171 := homalg_variable_2170 * homalg_variable_2152;;
gap> homalg_variable_2171 = homalg_variable_2156;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2152,homalg_variable_2156);; homalg_variable_2172 := homalg_variable_l[1];; homalg_variable_2173 := homalg_variable_l[2];;
gap> homalg_variable_2174 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_2172 = homalg_variable_2174;
true
gap> homalg_variable_2175 := homalg_variable_2173 * homalg_variable_2156;;
gap> homalg_variable_2176 := homalg_variable_2152 + homalg_variable_2175;;
gap> homalg_variable_2172 = homalg_variable_2176;
true
gap> homalg_variable_2177 := SIH_DecideZeroRows(homalg_variable_2152,homalg_variable_2156);;
gap> homalg_variable_2178 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_2177 = homalg_variable_2178;
true
gap> homalg_variable_2179 := homalg_variable_2173 * (homalg_variable_8);;
gap> homalg_variable_2180 := homalg_variable_2179 * homalg_variable_2156;;
gap> homalg_variable_2180 = homalg_variable_2152;
true
gap> homalg_variable_2181 := SIH_DecideZeroRows(homalg_variable_2152,homalg_variable_1772);;
gap> homalg_variable_2182 := SI_matrix(homalg_variable_5,3,7,"0");;
gap> homalg_variable_2181 = homalg_variable_2182;
true
gap> homalg_variable_2184 := SIH_UnionOfRows(homalg_variable_2129,homalg_variable_2016);;
gap> homalg_variable_2183 := SIH_BasisOfRowModule(homalg_variable_2184);;
gap> SI_nrows(homalg_variable_2183);
3
gap> homalg_variable_2185 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2183 = homalg_variable_2185;
false
gap> homalg_variable_2186 := SIH_DecideZeroRows(homalg_variable_1367,homalg_variable_2183);;
gap> homalg_variable_2187 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2186 = homalg_variable_2187;
true
gap> homalg_variable_2189 := SIH_UnionOfRows(homalg_variable_1367,homalg_variable_2016);;
gap> homalg_variable_2188 := SIH_BasisOfRowModule(homalg_variable_2189);;
gap> SI_nrows(homalg_variable_2188);
3
gap> homalg_variable_2190 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2188 = homalg_variable_2190;
false
gap> homalg_variable_2191 := SIH_DecideZeroRows(homalg_variable_1367,homalg_variable_2188);;
gap> homalg_variable_2192 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2191 = homalg_variable_2192;
true
gap> homalg_variable_2194 := SIH_UnionOfRows(homalg_variable_1375,homalg_variable_1772);;
gap> homalg_variable_2193 := SIH_BasisOfRowModule(homalg_variable_2194);;
gap> SI_nrows(homalg_variable_2193);
7
gap> homalg_variable_2195 := SI_matrix(homalg_variable_5,7,7,"0");;
gap> homalg_variable_2193 = homalg_variable_2195;
false
gap> homalg_variable_2196 := SIH_DecideZeroRows(homalg_variable_1375,homalg_variable_2193);;
gap> homalg_variable_2197 := SI_matrix(homalg_variable_5,7,7,"0");;
gap> homalg_variable_2196 = homalg_variable_2197;
true
gap> homalg_variable_2198 := SIH_DecideZeroRows(homalg_variable_2129,homalg_variable_2016);;
gap> homalg_variable_2199 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_2198 = homalg_variable_2199;
false
gap> homalg_variable_2200 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_2123 = homalg_variable_2200;
false
gap> homalg_variable_2201 := SIH_UnionOfRows(homalg_variable_2198,homalg_variable_2016);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_2201);; homalg_variable_2202 := homalg_variable_l[1];; homalg_variable_2203 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_2202);
3
gap> homalg_variable_2204 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2202 = homalg_variable_2204;
false
gap> SI_ncols(homalg_variable_2203);
7
gap> homalg_variable_2205 := SIH_Submatrix(homalg_variable_2203,[1..3],[ 1, 2, 3, 4, 5, 6 ]);;
gap> homalg_variable_2206 := homalg_variable_2205 * homalg_variable_2198;;
gap> homalg_variable_2207 := SIH_Submatrix(homalg_variable_2203,[1..3],[ 7 ]);;
gap> homalg_variable_2208 := homalg_variable_2207 * homalg_variable_2016;;
gap> homalg_variable_2209 := homalg_variable_2206 + homalg_variable_2208;;
gap> homalg_variable_2202 = homalg_variable_2209;
true
gap> homalg_variable_2210 := SIH_DecideZeroRows(homalg_variable_1367,homalg_variable_2016);;
gap> homalg_variable_2211 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2210 = homalg_variable_2211;
false
gap> homalg_variable_2202 = homalg_variable_1367;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2210,homalg_variable_2202);; homalg_variable_2212 := homalg_variable_l[1];; homalg_variable_2213 := homalg_variable_l[2];;
gap> homalg_variable_2214 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2212 = homalg_variable_2214;
true
gap> homalg_variable_2215 := homalg_variable_2213 * homalg_variable_2202;;
gap> homalg_variable_2216 := homalg_variable_2210 + homalg_variable_2215;;
gap> homalg_variable_2212 = homalg_variable_2216;
true
gap> homalg_variable_2217 := SIH_DecideZeroRows(homalg_variable_2210,homalg_variable_2202);;
gap> homalg_variable_2218 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2217 = homalg_variable_2218;
true
gap> homalg_variable_2220 := homalg_variable_2213 * (homalg_variable_8);;
gap> homalg_variable_2221 := SIH_Submatrix(homalg_variable_2203,[1..3],[ 1, 2, 3, 4, 5, 6 ]);;
gap> homalg_variable_2222 := homalg_variable_2220 * homalg_variable_2221;;
gap> homalg_variable_2223 := homalg_variable_2222 * homalg_variable_2129;;
gap> homalg_variable_2224 := homalg_variable_2223 - homalg_variable_1367;;
gap> homalg_variable_2219 := SIH_DecideZeroRows(homalg_variable_2224,homalg_variable_2016);;
gap> homalg_variable_2225 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2219 = homalg_variable_2225;
true
gap> homalg_variable_2227 := homalg_variable_2146 * homalg_variable_2079;;
gap> homalg_variable_2228 := homalg_variable_2222 * homalg_variable_2079;;
gap> homalg_variable_2229 := SIH_UnionOfRows(homalg_variable_2227,homalg_variable_2228);;
gap> homalg_variable_2226 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_2229);;
gap> SI_nrows(homalg_variable_2226);
4
gap> homalg_variable_2230 := SI_matrix(homalg_variable_5,4,10,"0");;
gap> homalg_variable_2226 = homalg_variable_2230;
false
gap> homalg_variable_2231 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_2226);;
gap> SI_nrows(homalg_variable_2231);
1
gap> homalg_variable_2232 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2231 = homalg_variable_2232;
true
gap> homalg_variable_2233 := SIH_BasisOfRowModule(homalg_variable_2226);;
gap> SI_nrows(homalg_variable_2233);
5
gap> homalg_variable_2234 := SI_matrix(homalg_variable_5,5,10,"0");;
gap> homalg_variable_2233 = homalg_variable_2234;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_2226);; homalg_variable_2235 := homalg_variable_l[1];; homalg_variable_2236 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_2235);
5
gap> homalg_variable_2237 := SI_matrix(homalg_variable_5,5,10,"0");;
gap> homalg_variable_2235 = homalg_variable_2237;
false
gap> SI_ncols(homalg_variable_2236);
4
gap> homalg_variable_2238 := homalg_variable_2236 * homalg_variable_2226;;
gap> homalg_variable_2235 = homalg_variable_2238;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2233,homalg_variable_2235);; homalg_variable_2239 := homalg_variable_l[1];; homalg_variable_2240 := homalg_variable_l[2];;
gap> homalg_variable_2241 := SI_matrix(homalg_variable_5,5,10,"0");;
gap> homalg_variable_2239 = homalg_variable_2241;
true
gap> homalg_variable_2242 := homalg_variable_2240 * homalg_variable_2235;;
gap> homalg_variable_2243 := homalg_variable_2233 + homalg_variable_2242;;
gap> homalg_variable_2239 = homalg_variable_2243;
true
gap> homalg_variable_2244 := SIH_DecideZeroRows(homalg_variable_2233,homalg_variable_2235);;
gap> homalg_variable_2245 := SI_matrix(homalg_variable_5,5,10,"0");;
gap> homalg_variable_2244 = homalg_variable_2245;
true
gap> homalg_variable_2246 := homalg_variable_2240 * (homalg_variable_8);;
gap> homalg_variable_2247 := homalg_variable_2246 * homalg_variable_2236;;
gap> homalg_variable_2248 := homalg_variable_2247 * homalg_variable_2226;;
gap> homalg_variable_2248 = homalg_variable_2233;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2226,homalg_variable_2233);; homalg_variable_2249 := homalg_variable_l[1];; homalg_variable_2250 := homalg_variable_l[2];;
gap> homalg_variable_2251 := SI_matrix(homalg_variable_5,4,10,"0");;
gap> homalg_variable_2249 = homalg_variable_2251;
true
gap> homalg_variable_2252 := homalg_variable_2250 * homalg_variable_2233;;
gap> homalg_variable_2253 := homalg_variable_2226 + homalg_variable_2252;;
gap> homalg_variable_2249 = homalg_variable_2253;
true
gap> homalg_variable_2254 := SIH_DecideZeroRows(homalg_variable_2226,homalg_variable_2233);;
gap> homalg_variable_2255 := SI_matrix(homalg_variable_5,4,10,"0");;
gap> homalg_variable_2254 = homalg_variable_2255;
true
gap> homalg_variable_2256 := homalg_variable_2250 * (homalg_variable_8);;
gap> homalg_variable_2257 := homalg_variable_2256 * homalg_variable_2233;;
gap> homalg_variable_2257 = homalg_variable_2226;
true
gap> SIH_ZeroRows(homalg_variable_2226);
[  ]
gap> homalg_variable_2258 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_1868 = homalg_variable_2258;
false
gap> SIH_ZeroRows(homalg_variable_1870);
[  ]
gap> homalg_variable_2259 := SIH_Submatrix(homalg_variable_1867,[1..1],[ 1 ]);;
gap> homalg_variable_2260 := homalg_variable_2259 * homalg_variable_1868;;
gap> homalg_variable_2261 := SIH_Submatrix(homalg_variable_1867,[1..1],[ 2, 3, 4 ]);;
gap> homalg_variable_2262 := homalg_variable_2261 * homalg_variable_1869;;
gap> homalg_variable_2263 := homalg_variable_2260 + homalg_variable_2262;;
gap> homalg_variable_2264 := SI_matrix(homalg_variable_5,1,7,"0");;
gap> homalg_variable_2263 = homalg_variable_2264;
true
gap> homalg_variable_1872 = homalg_variable_1867;
true
gap> homalg_variable_2265 := SIH_DecideZeroRows(homalg_variable_1867,homalg_variable_1872);;
gap> homalg_variable_2266 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2265 = homalg_variable_2266;
true
gap> homalg_variable_2267 := SIH_Submatrix(homalg_variable_2226,[1..4],[ 8, 9, 10 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2267,homalg_variable_2014);; homalg_variable_2268 := homalg_variable_l[1];; homalg_variable_2269 := homalg_variable_l[2];;
gap> homalg_variable_2270 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2268 = homalg_variable_2270;
true
gap> homalg_variable_2271 := homalg_variable_2269 * homalg_variable_2014;;
gap> homalg_variable_2272 := homalg_variable_2267 + homalg_variable_2271;;
gap> homalg_variable_2268 = homalg_variable_2272;
true
gap> homalg_variable_2273 := SIH_DecideZeroRows(homalg_variable_2267,homalg_variable_2014);;
gap> homalg_variable_2274 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2273 = homalg_variable_2274;
true
gap> homalg_variable_2275 := homalg_variable_2269 * (homalg_variable_8);;
gap> homalg_variable_2276 := homalg_variable_2275 * homalg_variable_2014;;
gap> homalg_variable_2277 := homalg_variable_2276 - homalg_variable_2267;;
gap> homalg_variable_2278 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2277 = homalg_variable_2278;
true
gap> homalg_variable_2279 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2280 := SIH_UnionOfColumns(homalg_variable_1868,homalg_variable_2279);;
gap> homalg_variable_2281 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2282 := SIH_UnionOfColumns(homalg_variable_1869,homalg_variable_2281);;
gap> homalg_variable_2283 := SIH_UnionOfRows(homalg_variable_2280,homalg_variable_2282);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2283,homalg_variable_2235);; homalg_variable_2284 := homalg_variable_l[1];; homalg_variable_2285 := homalg_variable_l[2];;
gap> homalg_variable_2286 := SI_matrix(homalg_variable_5,4,10,"0");;
gap> homalg_variable_2284 = homalg_variable_2286;
true
gap> homalg_variable_2287 := homalg_variable_2285 * homalg_variable_2235;;
gap> homalg_variable_2288 := homalg_variable_2283 + homalg_variable_2287;;
gap> homalg_variable_2284 = homalg_variable_2288;
true
gap> homalg_variable_2289 := SIH_DecideZeroRows(homalg_variable_2283,homalg_variable_2235);;
gap> homalg_variable_2290 := SI_matrix(homalg_variable_5,4,10,"0");;
gap> homalg_variable_2289 = homalg_variable_2290;
true
gap> SI_ncols(homalg_variable_2236);
4
gap> SI_nrows(homalg_variable_2236);
5
gap> homalg_variable_2291 := homalg_variable_2285 * (homalg_variable_8);;
gap> homalg_variable_2292 := homalg_variable_2291 * homalg_variable_2236;;
gap> homalg_variable_2293 := homalg_variable_2292 * homalg_variable_2226;;
gap> homalg_variable_2294 := homalg_variable_2293 - homalg_variable_2283;;
gap> homalg_variable_2295 := SI_matrix(homalg_variable_5,4,10,"0");;
gap> homalg_variable_2294 = homalg_variable_2295;
true
gap> homalg_variable_2296 := homalg_variable_1872 * homalg_variable_2292;;
gap> homalg_variable_2297 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2296 = homalg_variable_2297;
true
gap> homalg_variable_2298 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_2292);;
gap> SI_nrows(homalg_variable_2298);
1
gap> homalg_variable_2299 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2298 = homalg_variable_2299;
false
gap> homalg_variable_2300 := SIH_BasisOfRowModule(homalg_variable_2298);;
gap> SI_nrows(homalg_variable_2300);
1
gap> homalg_variable_2301 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2300 = homalg_variable_2301;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_2298);; homalg_variable_2302 := homalg_variable_l[1];; homalg_variable_2303 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_2302);
1
gap> homalg_variable_2304 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2302 = homalg_variable_2304;
false
gap> SI_ncols(homalg_variable_2303);
1
gap> homalg_variable_2305 := homalg_variable_2303 * homalg_variable_2298;;
gap> homalg_variable_2302 = homalg_variable_2305;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2300,homalg_variable_2302);; homalg_variable_2306 := homalg_variable_l[1];; homalg_variable_2307 := homalg_variable_l[2];;
gap> homalg_variable_2308 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2306 = homalg_variable_2308;
true
gap> homalg_variable_2309 := homalg_variable_2307 * homalg_variable_2302;;
gap> homalg_variable_2310 := homalg_variable_2300 + homalg_variable_2309;;
gap> homalg_variable_2306 = homalg_variable_2310;
true
gap> homalg_variable_2311 := SIH_DecideZeroRows(homalg_variable_2300,homalg_variable_2302);;
gap> homalg_variable_2312 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2311 = homalg_variable_2312;
true
gap> homalg_variable_2313 := homalg_variable_2307 * (homalg_variable_8);;
gap> homalg_variable_2314 := homalg_variable_2313 * homalg_variable_2303;;
gap> homalg_variable_2315 := homalg_variable_2314 * homalg_variable_2298;;
gap> homalg_variable_2315 = homalg_variable_2300;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2298,homalg_variable_2300);; homalg_variable_2316 := homalg_variable_l[1];; homalg_variable_2317 := homalg_variable_l[2];;
gap> homalg_variable_2318 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2316 = homalg_variable_2318;
true
gap> homalg_variable_2319 := homalg_variable_2317 * homalg_variable_2300;;
gap> homalg_variable_2320 := homalg_variable_2298 + homalg_variable_2319;;
gap> homalg_variable_2316 = homalg_variable_2320;
true
gap> homalg_variable_2321 := SIH_DecideZeroRows(homalg_variable_2298,homalg_variable_2300);;
gap> homalg_variable_2322 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2321 = homalg_variable_2322;
true
gap> homalg_variable_2323 := homalg_variable_2317 * (homalg_variable_8);;
gap> homalg_variable_2324 := homalg_variable_2323 * homalg_variable_2300;;
gap> homalg_variable_2324 = homalg_variable_2298;
true
gap> homalg_variable_2325 := SIH_DecideZeroRows(homalg_variable_2298,homalg_variable_1872);;
gap> homalg_variable_2326 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2325 = homalg_variable_2326;
true
gap> homalg_variable_2327 := SIH_BasisOfRowModule(homalg_variable_2275);;
gap> SI_nrows(homalg_variable_2327);
1
gap> homalg_variable_2328 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2327 = homalg_variable_2328;
false
gap> homalg_variable_2329 := SIH_DecideZeroRows(homalg_variable_237,homalg_variable_2327);;
gap> homalg_variable_2330 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2329 = homalg_variable_2330;
true
gap> homalg_variable_2332 := SIH_UnionOfRows(homalg_variable_918,homalg_variable_1872);;
gap> homalg_variable_2331 := SIH_BasisOfRowModule(homalg_variable_2332);;
gap> SI_nrows(homalg_variable_2331);
4
gap> homalg_variable_2333 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_2331 = homalg_variable_2333;
false
gap> homalg_variable_2334 := SIH_DecideZeroRows(homalg_variable_918,homalg_variable_2331);;
gap> homalg_variable_2335 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_2334 = homalg_variable_2335;
true
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_2275);; homalg_variable_2336 := homalg_variable_l[1];; homalg_variable_2337 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_2336);
1
gap> homalg_variable_2338 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2336 = homalg_variable_2338;
false
gap> SI_ncols(homalg_variable_2337);
4
gap> homalg_variable_2339 := homalg_variable_2337 * homalg_variable_2275;;
gap> homalg_variable_2336 = homalg_variable_2339;
true
gap> homalg_variable_2336 = homalg_variable_237;
true
gap> homalg_variable_2340 := homalg_variable_2337 * homalg_variable_2275;;
gap> homalg_variable_2341 := homalg_variable_2340 - homalg_variable_237;;
gap> homalg_variable_2342 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2341 = homalg_variable_2342;
true
gap> homalg_variable_2344 := homalg_variable_2292 * homalg_variable_2226;;
gap> homalg_variable_2345 := homalg_variable_2337 * homalg_variable_2226;;
gap> homalg_variable_2346 := SIH_UnionOfRows(homalg_variable_2344,homalg_variable_2345);;
gap> homalg_variable_2343 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_2346);;
gap> SI_nrows(homalg_variable_2343);
1
gap> homalg_variable_2347 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2343 = homalg_variable_2347;
false
gap> homalg_variable_2348 := SIH_BasisOfRowModule(homalg_variable_2343);;
gap> SI_nrows(homalg_variable_2348);
1
gap> homalg_variable_2349 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2348 = homalg_variable_2349;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_2343);; homalg_variable_2350 := homalg_variable_l[1];; homalg_variable_2351 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_2350);
1
gap> homalg_variable_2352 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2350 = homalg_variable_2352;
false
gap> SI_ncols(homalg_variable_2351);
1
gap> homalg_variable_2353 := homalg_variable_2351 * homalg_variable_2343;;
gap> homalg_variable_2350 = homalg_variable_2353;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2348,homalg_variable_2350);; homalg_variable_2354 := homalg_variable_l[1];; homalg_variable_2355 := homalg_variable_l[2];;
gap> homalg_variable_2356 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2354 = homalg_variable_2356;
true
gap> homalg_variable_2357 := homalg_variable_2355 * homalg_variable_2350;;
gap> homalg_variable_2358 := homalg_variable_2348 + homalg_variable_2357;;
gap> homalg_variable_2354 = homalg_variable_2358;
true
gap> homalg_variable_2359 := SIH_DecideZeroRows(homalg_variable_2348,homalg_variable_2350);;
gap> homalg_variable_2360 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2359 = homalg_variable_2360;
true
gap> homalg_variable_2361 := homalg_variable_2355 * (homalg_variable_8);;
gap> homalg_variable_2362 := homalg_variable_2361 * homalg_variable_2351;;
gap> homalg_variable_2363 := homalg_variable_2362 * homalg_variable_2343;;
gap> homalg_variable_2363 = homalg_variable_2348;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2343,homalg_variable_2348);; homalg_variable_2364 := homalg_variable_l[1];; homalg_variable_2365 := homalg_variable_l[2];;
gap> homalg_variable_2366 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2364 = homalg_variable_2366;
true
gap> homalg_variable_2367 := homalg_variable_2365 * homalg_variable_2348;;
gap> homalg_variable_2368 := homalg_variable_2343 + homalg_variable_2367;;
gap> homalg_variable_2364 = homalg_variable_2368;
true
gap> homalg_variable_2369 := SIH_DecideZeroRows(homalg_variable_2343,homalg_variable_2348);;
gap> homalg_variable_2370 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2369 = homalg_variable_2370;
true
gap> homalg_variable_2371 := homalg_variable_2365 * (homalg_variable_8);;
gap> homalg_variable_2372 := homalg_variable_2371 * homalg_variable_2348;;
gap> homalg_variable_2372 = homalg_variable_2343;
true
gap> homalg_variable_2373 := SIH_Submatrix(homalg_variable_2343,[1..1],[ 5 ]);;
gap> homalg_variable_2374 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2373 = homalg_variable_2374;
true
gap> homalg_variable_2375 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2376 := SIH_UnionOfColumns(homalg_variable_1867,homalg_variable_2375);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2376,homalg_variable_2350);; homalg_variable_2377 := homalg_variable_l[1];; homalg_variable_2378 := homalg_variable_l[2];;
gap> homalg_variable_2379 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2377 = homalg_variable_2379;
true
gap> homalg_variable_2380 := homalg_variable_2378 * homalg_variable_2350;;
gap> homalg_variable_2381 := homalg_variable_2376 + homalg_variable_2380;;
gap> homalg_variable_2377 = homalg_variable_2381;
true
gap> homalg_variable_2382 := SIH_DecideZeroRows(homalg_variable_2376,homalg_variable_2350);;
gap> homalg_variable_2383 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2382 = homalg_variable_2383;
true
gap> SI_ncols(homalg_variable_2351);
1
gap> SI_nrows(homalg_variable_2351);
1
gap> homalg_variable_2384 := homalg_variable_2378 * (homalg_variable_8);;
gap> homalg_variable_2385 := homalg_variable_2384 * homalg_variable_2351;;
gap> homalg_variable_2386 := homalg_variable_2385 * homalg_variable_2343;;
gap> homalg_variable_2387 := homalg_variable_2386 - homalg_variable_2376;;
gap> homalg_variable_2388 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2387 = homalg_variable_2388;
true
gap> homalg_variable_2389 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_2385);;
gap> SI_nrows(homalg_variable_2389);
1
gap> homalg_variable_2390 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2389 = homalg_variable_2390;
true
gap> homalg_variable_2391 := SIH_Submatrix(homalg_variable_2344,[1..4],[ 1, 2, 3, 4, 5, 6, 7 ]);;
gap> homalg_variable_2392 := homalg_variable_2391 * homalg_variable_2227;;
gap> homalg_variable_2393 := SIH_Submatrix(homalg_variable_2345,[1..1],[ 1, 2, 3, 4, 5, 6, 7 ]);;
gap> homalg_variable_2394 := homalg_variable_2393 * homalg_variable_2227;;
gap> homalg_variable_2395 := SIH_UnionOfRows(homalg_variable_2392,homalg_variable_2394);;
gap> homalg_variable_2396 := SIH_Submatrix(homalg_variable_2344,[1..4],[ 8, 9, 10 ]);;
gap> homalg_variable_2397 := homalg_variable_2396 * homalg_variable_2228;;
gap> homalg_variable_2398 := SIH_Submatrix(homalg_variable_2345,[1..1],[ 8, 9, 10 ]);;
gap> homalg_variable_2399 := homalg_variable_2398 * homalg_variable_2228;;
gap> homalg_variable_2400 := SIH_UnionOfRows(homalg_variable_2397,homalg_variable_2399);;
gap> homalg_variable_2401 := homalg_variable_2395 + homalg_variable_2400;;
gap> homalg_variable_2402 := SI_matrix(homalg_variable_5,5,10,"0");;
gap> homalg_variable_2401 = homalg_variable_2402;
true
gap> homalg_variable_2403 := SIH_Submatrix(homalg_variable_2343,[1..1],[ 1, 2, 3, 4 ]);;
gap> homalg_variable_2404 := homalg_variable_2385 * homalg_variable_2403;;
gap> homalg_variable_2405 := homalg_variable_2404 * homalg_variable_2344;;
gap> homalg_variable_2406 := SIH_Submatrix(homalg_variable_2343,[1..1],[ 5 ]);;
gap> homalg_variable_2407 := homalg_variable_2385 * homalg_variable_2406;;
gap> homalg_variable_2408 := homalg_variable_2407 * homalg_variable_2345;;
gap> homalg_variable_2409 := homalg_variable_2405 + homalg_variable_2408;;
gap> homalg_variable_2410 := SI_matrix(homalg_variable_5,1,10,"0");;
gap> homalg_variable_2409 = homalg_variable_2410;
true
gap> homalg_variable_2411 := SI_matrix(homalg_variable_5,7,3,"0");;
gap> homalg_variable_2412 := SIH_UnionOfRows(homalg_variable_2411,homalg_variable_1968);;
gap> homalg_variable_2413 := SIH_Submatrix(homalg_variable_2227,[1..7],[ 8, 9, 10 ]);;
gap> homalg_variable_2414 := SIH_Submatrix(homalg_variable_2228,[1..3],[ 8, 9, 10 ]);;
gap> homalg_variable_2415 := SIH_UnionOfRows(homalg_variable_2413,homalg_variable_2414);;
gap> homalg_variable_2416 := homalg_variable_2412 - homalg_variable_2415;;
gap> homalg_variable_2417 := SI_matrix(homalg_variable_5,10,3,"0");;
gap> homalg_variable_2416 = homalg_variable_2417;
true
gap> homalg_variable_2418 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2419 := SIH_UnionOfRows(homalg_variable_2418,homalg_variable_2014);;
gap> homalg_variable_2420 := SIH_Submatrix(homalg_variable_2344,[1..4],[ 8, 9, 10 ]);;
gap> homalg_variable_2421 := SIH_Submatrix(homalg_variable_2345,[1..1],[ 8, 9, 10 ]);;
gap> homalg_variable_2422 := SIH_UnionOfRows(homalg_variable_2420,homalg_variable_2421);;
gap> homalg_variable_2423 := homalg_variable_2419 - homalg_variable_2422;;
gap> homalg_variable_2424 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_2423 = homalg_variable_2424;
true
gap> homalg_variable_2425 := SIH_Submatrix(homalg_variable_2343,[1..1],[ 5 ]);;
gap> homalg_variable_2426 := homalg_variable_2385 * homalg_variable_2425;;
gap> homalg_variable_2427 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2426 = homalg_variable_2427;
true
gap> homalg_variable_2428 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2429 := SIH_UnionOfColumns(homalg_variable_1766,homalg_variable_2428);;
gap> homalg_variable_2430 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2431 := SIH_UnionOfColumns(homalg_variable_1767,homalg_variable_2430);;
gap> homalg_variable_2432 := SIH_UnionOfRows(homalg_variable_2429,homalg_variable_2431);;
gap> homalg_variable_2433 := homalg_variable_2227 - homalg_variable_2432;;
gap> homalg_variable_2434 := SI_matrix(homalg_variable_5,7,10,"0");;
gap> homalg_variable_2433 = homalg_variable_2434;
true
gap> homalg_variable_2435 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2436 := SIH_UnionOfColumns(homalg_variable_1868,homalg_variable_2435);;
gap> homalg_variable_2437 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2438 := SIH_UnionOfColumns(homalg_variable_1869,homalg_variable_2437);;
gap> homalg_variable_2439 := SIH_UnionOfRows(homalg_variable_2436,homalg_variable_2438);;
gap> homalg_variable_2440 := homalg_variable_2344 - homalg_variable_2439;;
gap> homalg_variable_2441 := SI_matrix(homalg_variable_5,4,10,"0");;
gap> homalg_variable_2440 = homalg_variable_2441;
true
gap> homalg_variable_2442 := homalg_variable_2385 * homalg_variable_2343;;
gap> homalg_variable_2443 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2444 := SIH_UnionOfColumns(homalg_variable_1867,homalg_variable_2443);;
gap> homalg_variable_2445 := homalg_variable_2442 - homalg_variable_2444;;
gap> homalg_variable_2446 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2445 = homalg_variable_2446;
true
gap> homalg_variable_2448 := SIH_UnionOfRows(homalg_variable_1959,homalg_variable_237);;
gap> homalg_variable_2447 := SIH_BasisOfRowModule(homalg_variable_2448);;
gap> SI_nrows(homalg_variable_2447);
1
gap> homalg_variable_2449 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2447 = homalg_variable_2449;
false
gap> homalg_variable_2450 := SIH_DecideZeroRows(homalg_variable_237,homalg_variable_2447);;
gap> homalg_variable_2451 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2450 = homalg_variable_2451;
true
gap> homalg_variable_2452 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_2448);;
gap> SI_nrows(homalg_variable_2452);
3
gap> homalg_variable_2453 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_2452 = homalg_variable_2453;
false
gap> homalg_variable_2454 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_2452);;
gap> SI_nrows(homalg_variable_2454);
1
gap> homalg_variable_2455 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2454 = homalg_variable_2455;
true
gap> homalg_variable_2456 := SIH_BasisOfRowModule(homalg_variable_2452);;
gap> SI_nrows(homalg_variable_2456);
6
gap> homalg_variable_2457 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_2456 = homalg_variable_2457;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_2452);; homalg_variable_2458 := homalg_variable_l[1];; homalg_variable_2459 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_2458);
6
gap> homalg_variable_2460 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_2458 = homalg_variable_2460;
false
gap> SI_ncols(homalg_variable_2459);
3
gap> homalg_variable_2461 := homalg_variable_2459 * homalg_variable_2452;;
gap> homalg_variable_2458 = homalg_variable_2461;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2456,homalg_variable_2458);; homalg_variable_2462 := homalg_variable_l[1];; homalg_variable_2463 := homalg_variable_l[2];;
gap> homalg_variable_2464 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_2462 = homalg_variable_2464;
true
gap> homalg_variable_2465 := homalg_variable_2463 * homalg_variable_2458;;
gap> homalg_variable_2466 := homalg_variable_2456 + homalg_variable_2465;;
gap> homalg_variable_2462 = homalg_variable_2466;
true
gap> homalg_variable_2467 := SIH_DecideZeroRows(homalg_variable_2456,homalg_variable_2458);;
gap> homalg_variable_2468 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_2467 = homalg_variable_2468;
true
gap> homalg_variable_2469 := homalg_variable_2463 * (homalg_variable_8);;
gap> homalg_variable_2470 := homalg_variable_2469 * homalg_variable_2459;;
gap> homalg_variable_2471 := homalg_variable_2470 * homalg_variable_2452;;
gap> homalg_variable_2471 = homalg_variable_2456;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2452,homalg_variable_2456);; homalg_variable_2472 := homalg_variable_l[1];; homalg_variable_2473 := homalg_variable_l[2];;
gap> homalg_variable_2474 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_2472 = homalg_variable_2474;
true
gap> homalg_variable_2475 := homalg_variable_2473 * homalg_variable_2456;;
gap> homalg_variable_2476 := homalg_variable_2452 + homalg_variable_2475;;
gap> homalg_variable_2472 = homalg_variable_2476;
true
gap> homalg_variable_2477 := SIH_DecideZeroRows(homalg_variable_2452,homalg_variable_2456);;
gap> homalg_variable_2478 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_2477 = homalg_variable_2478;
true
gap> homalg_variable_2479 := homalg_variable_2473 * (homalg_variable_8);;
gap> homalg_variable_2480 := homalg_variable_2479 * homalg_variable_2456;;
gap> homalg_variable_2480 = homalg_variable_2452;
true
gap> SIH_ZeroRows(homalg_variable_2452);
[  ]
gap> SIH_ZeroRows(homalg_variable_233);
[  ]
gap> homalg_variable_2481 := homalg_variable_680 * homalg_variable_233;;
gap> homalg_variable_2482 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_2481 = homalg_variable_2482;
true
gap> homalg_variable_2483 := SIH_DecideZeroRows(homalg_variable_680,homalg_variable_696);;
gap> homalg_variable_2484 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2483 = homalg_variable_2484;
true
gap> homalg_variable_2485 := SIH_Submatrix(homalg_variable_2452,[1..3],[ 4 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2485,homalg_variable_233);; homalg_variable_2486 := homalg_variable_l[1];; homalg_variable_2487 := homalg_variable_l[2];;
gap> homalg_variable_2488 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_2486 = homalg_variable_2488;
true
gap> homalg_variable_2489 := homalg_variable_2487 * homalg_variable_233;;
gap> homalg_variable_2490 := homalg_variable_2485 + homalg_variable_2489;;
gap> homalg_variable_2486 = homalg_variable_2490;
true
gap> homalg_variable_2491 := SIH_DecideZeroRows(homalg_variable_2485,homalg_variable_233);;
gap> homalg_variable_2492 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_2491 = homalg_variable_2492;
true
gap> homalg_variable_2493 := homalg_variable_2487 * (homalg_variable_8);;
gap> homalg_variable_2494 := homalg_variable_2493 * homalg_variable_233;;
gap> homalg_variable_2495 := homalg_variable_2494 - homalg_variable_2485;;
gap> homalg_variable_2496 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_2495 = homalg_variable_2496;
true
gap> homalg_variable_2497 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_2498 := SIH_UnionOfColumns(homalg_variable_1968,homalg_variable_2497);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2498,homalg_variable_2458);; homalg_variable_2499 := homalg_variable_l[1];; homalg_variable_2500 := homalg_variable_l[2];;
gap> for _del in [ "homalg_variable_1996", "homalg_variable_1999", "homalg_variable_2000", "homalg_variable_2001", "homalg_variable_2002", "homalg_variable_2003", "homalg_variable_2006", "homalg_variable_2007", "homalg_variable_2008", "homalg_variable_2011", "homalg_variable_2012", "homalg_variable_2013", "homalg_variable_2015", "homalg_variable_2017", "homalg_variable_2020", "homalg_variable_2021", "homalg_variable_2022", "homalg_variable_2023", "homalg_variable_2024", "homalg_variable_2025", "homalg_variable_2026", "homalg_variable_2027", "homalg_variable_2028", "homalg_variable_2029", "homalg_variable_2030", "homalg_variable_2031", "homalg_variable_2032", "homalg_variable_2033", "homalg_variable_2034", "homalg_variable_2035", "homalg_variable_2036", "homalg_variable_2037", "homalg_variable_2038", "homalg_variable_2039", "homalg_variable_2040", "homalg_variable_2041", "homalg_variable_2042", "homalg_variable_2043", "homalg_variable_2044", "homalg_variable_2045", "homalg_variable_2046", "homalg_variable_2047", "homalg_variable_2049", "homalg_variable_2050", "homalg_variable_2051", "homalg_variable_2052", "homalg_variable_2053", "homalg_variable_2054", "homalg_variable_2055", "homalg_variable_2056", "homalg_variable_2057", "homalg_variable_2059", "homalg_variable_2060", "homalg_variable_2061", "homalg_variable_2062", "homalg_variable_2063", "homalg_variable_2064", "homalg_variable_2068", "homalg_variable_2069", "homalg_variable_2070", "homalg_variable_2076", "homalg_variable_2077", "homalg_variable_2078", "homalg_variable_2080", "homalg_variable_2081", "homalg_variable_2082", "homalg_variable_2084", "homalg_variable_2087", "homalg_variable_2088", "homalg_variable_2089", "homalg_variable_2090", "homalg_variable_2091", "homalg_variable_2092", "homalg_variable_2093", "homalg_variable_2094", "homalg_variable_2095", "homalg_variable_2096", "homalg_variable_2097", "homalg_variable_2098", "homalg_variable_2101", "homalg_variable_2104", "homalg_variable_2105", "homalg_variable_2107", "homalg_variable_2108", "homalg_variable_2109", "homalg_variable_2110", "homalg_variable_2111", "homalg_variable_2112", "homalg_variable_2113", "homalg_variable_2114", "homalg_variable_2115", "homalg_variable_2116", "homalg_variable_2117", "homalg_variable_2118", "homalg_variable_2119", "homalg_variable_2120", "homalg_variable_2122", "homalg_variable_2124", "homalg_variable_2125", "homalg_variable_2126", "homalg_variable_2127", "homalg_variable_2128", "homalg_variable_2130", "homalg_variable_2131", "homalg_variable_2132", "homalg_variable_2140", "homalg_variable_2141", "homalg_variable_2142", "homalg_variable_2143", "homalg_variable_2144", "homalg_variable_2150", "homalg_variable_2151", "homalg_variable_2153", "homalg_variable_2154", "homalg_variable_2155", "homalg_variable_2157", "homalg_variable_2160", "homalg_variable_2161", "homalg_variable_2162", "homalg_variable_2163", "homalg_variable_2164", "homalg_variable_2165", "homalg_variable_2166", "homalg_variable_2167", "homalg_variable_2168", "homalg_variable_2169", "homalg_variable_2170", "homalg_variable_2171", "homalg_variable_2172", "homalg_variable_2173", "homalg_variable_2174", "homalg_variable_2175", "homalg_variable_2176", "homalg_variable_2177", "homalg_variable_2178", "homalg_variable_2179", "homalg_variable_2180", "homalg_variable_2181", "homalg_variable_2182", "homalg_variable_2185", "homalg_variable_2186", "homalg_variable_2187", "homalg_variable_2190", "homalg_variable_2191", "homalg_variable_2192", "homalg_variable_2195", "homalg_variable_2196", "homalg_variable_2197", "homalg_variable_2200", "homalg_variable_2204", "homalg_variable_2205", "homalg_variable_2206", "homalg_variable_2207", "homalg_variable_2208", "homalg_variable_2209", "homalg_variable_2211", "homalg_variable_2214", "homalg_variable_2215", "homalg_variable_2216", "homalg_variable_2217", "homalg_variable_2218", "homalg_variable_2219", "homalg_variable_2223", "homalg_variable_2224", "homalg_variable_2225", "homalg_variable_2230", "homalg_variable_2231", "homalg_variable_2232", "homalg_variable_2234", "homalg_variable_2237", "homalg_variable_2238", "homalg_variable_2239", "homalg_variable_2240", "homalg_variable_2241", "homalg_variable_2242", "homalg_variable_2243", "homalg_variable_2244", "homalg_variable_2245", "homalg_variable_2246", "homalg_variable_2247", "homalg_variable_2248", "homalg_variable_2249", "homalg_variable_2250", "homalg_variable_2251", "homalg_variable_2252", "homalg_variable_2253", "homalg_variable_2254", "homalg_variable_2255", "homalg_variable_2256", "homalg_variable_2257", "homalg_variable_2258", "homalg_variable_2259", "homalg_variable_2260", "homalg_variable_2261", "homalg_variable_2262", "homalg_variable_2263", "homalg_variable_2264", "homalg_variable_2265", "homalg_variable_2266", "homalg_variable_2268", "homalg_variable_2270", "homalg_variable_2271", "homalg_variable_2272", "homalg_variable_2273", "homalg_variable_2274", "homalg_variable_2276", "homalg_variable_2277", "homalg_variable_2278", "homalg_variable_2284", "homalg_variable_2286", "homalg_variable_2287", "homalg_variable_2288", "homalg_variable_2289", "homalg_variable_2290", "homalg_variable_2293", "homalg_variable_2294", "homalg_variable_2295", "homalg_variable_2296", "homalg_variable_2297", "homalg_variable_2299", "homalg_variable_2301", "homalg_variable_2304", "homalg_variable_2305", "homalg_variable_2308", "homalg_variable_2311", "homalg_variable_2312", "homalg_variable_2315", "homalg_variable_2316", "homalg_variable_2317", "homalg_variable_2318", "homalg_variable_2319", "homalg_variable_2320", "homalg_variable_2321", "homalg_variable_2322", "homalg_variable_2323", "homalg_variable_2324", "homalg_variable_2325", "homalg_variable_2326", "homalg_variable_2328", "homalg_variable_2329", "homalg_variable_2330", "homalg_variable_2333", "homalg_variable_2334", "homalg_variable_2335", "homalg_variable_2338", "homalg_variable_2339", "homalg_variable_2340", "homalg_variable_2341", "homalg_variable_2342", "homalg_variable_2347", "homalg_variable_2349", "homalg_variable_2352", "homalg_variable_2353", "homalg_variable_2354", "homalg_variable_2355", "homalg_variable_2356", "homalg_variable_2357", "homalg_variable_2358", "homalg_variable_2359", "homalg_variable_2360", "homalg_variable_2361", "homalg_variable_2362", "homalg_variable_2363", "homalg_variable_2364", "homalg_variable_2365", "homalg_variable_2366", "homalg_variable_2367", "homalg_variable_2368", "homalg_variable_2369", "homalg_variable_2370", "homalg_variable_2371", "homalg_variable_2372", "homalg_variable_2374", "homalg_variable_2377", "homalg_variable_2379", "homalg_variable_2380", "homalg_variable_2381", "homalg_variable_2382", "homalg_variable_2383", "homalg_variable_2386", "homalg_variable_2387", "homalg_variable_2388", "homalg_variable_2390", "homalg_variable_2391", "homalg_variable_2392", "homalg_variable_2393", "homalg_variable_2394", "homalg_variable_2395", "homalg_variable_2396", "homalg_variable_2397", "homalg_variable_2398", "homalg_variable_2399", "homalg_variable_2400", "homalg_variable_2401", "homalg_variable_2402", "homalg_variable_2403", "homalg_variable_2404", "homalg_variable_2405", "homalg_variable_2406", "homalg_variable_2407", "homalg_variable_2408", "homalg_variable_2409", "homalg_variable_2410", "homalg_variable_2412", "homalg_variable_2413", "homalg_variable_2414", "homalg_variable_2415", "homalg_variable_2416", "homalg_variable_2417", "homalg_variable_2418", "homalg_variable_2419", "homalg_variable_2420", "homalg_variable_2421", "homalg_variable_2422", "homalg_variable_2423", "homalg_variable_2424", "homalg_variable_2425", "homalg_variable_2426", "homalg_variable_2427", "homalg_variable_2428", "homalg_variable_2429", "homalg_variable_2430", "homalg_variable_2431", "homalg_variable_2432", "homalg_variable_2433", "homalg_variable_2434", "homalg_variable_2443", "homalg_variable_2444", "homalg_variable_2445", "homalg_variable_2446", "homalg_variable_2449", "homalg_variable_2450", "homalg_variable_2451", "homalg_variable_2453", "homalg_variable_2454", "homalg_variable_2455", "homalg_variable_2457", "homalg_variable_2460", "homalg_variable_2461", "homalg_variable_2462", "homalg_variable_2463", "homalg_variable_2464", "homalg_variable_2465", "homalg_variable_2466", "homalg_variable_2467", "homalg_variable_2468", "homalg_variable_2469", "homalg_variable_2470", "homalg_variable_2471", "homalg_variable_2472", "homalg_variable_2473", "homalg_variable_2474", "homalg_variable_2475", "homalg_variable_2476", "homalg_variable_2477", "homalg_variable_2478", "homalg_variable_2479", "homalg_variable_2480" ] do UnbindGlobal( _del );; od;;
gap> homalg_variable_2501 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_2499 = homalg_variable_2501;
true
gap> homalg_variable_2502 := homalg_variable_2500 * homalg_variable_2458;;
gap> homalg_variable_2503 := homalg_variable_2498 + homalg_variable_2502;;
gap> homalg_variable_2499 = homalg_variable_2503;
true
gap> homalg_variable_2504 := SIH_DecideZeroRows(homalg_variable_2498,homalg_variable_2458);;
gap> homalg_variable_2505 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_2504 = homalg_variable_2505;
true
gap> SI_ncols(homalg_variable_2459);
3
gap> SI_nrows(homalg_variable_2459);
6
gap> homalg_variable_2506 := homalg_variable_2500 * (homalg_variable_8);;
gap> homalg_variable_2507 := homalg_variable_2506 * homalg_variable_2459;;
gap> homalg_variable_2508 := homalg_variable_2507 * homalg_variable_2452;;
gap> homalg_variable_2509 := homalg_variable_2508 - homalg_variable_2498;;
gap> homalg_variable_2510 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_2509 = homalg_variable_2510;
true
gap> homalg_variable_2511 := homalg_variable_2016 * homalg_variable_2507;;
gap> homalg_variable_2512 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2511 = homalg_variable_2512;
true
gap> homalg_variable_2513 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_2507);;
gap> SI_nrows(homalg_variable_2513);
1
gap> homalg_variable_2514 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2513 = homalg_variable_2514;
false
gap> homalg_variable_2515 := SIH_BasisOfRowModule(homalg_variable_2513);;
gap> SI_nrows(homalg_variable_2515);
1
gap> homalg_variable_2516 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2515 = homalg_variable_2516;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_2513);; homalg_variable_2517 := homalg_variable_l[1];; homalg_variable_2518 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_2517);
1
gap> homalg_variable_2519 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2517 = homalg_variable_2519;
false
gap> SI_ncols(homalg_variable_2518);
1
gap> homalg_variable_2520 := homalg_variable_2518 * homalg_variable_2513;;
gap> homalg_variable_2517 = homalg_variable_2520;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2515,homalg_variable_2517);; homalg_variable_2521 := homalg_variable_l[1];; homalg_variable_2522 := homalg_variable_l[2];;
gap> homalg_variable_2523 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2521 = homalg_variable_2523;
true
gap> homalg_variable_2524 := homalg_variable_2522 * homalg_variable_2517;;
gap> homalg_variable_2525 := homalg_variable_2515 + homalg_variable_2524;;
gap> homalg_variable_2521 = homalg_variable_2525;
true
gap> homalg_variable_2526 := SIH_DecideZeroRows(homalg_variable_2515,homalg_variable_2517);;
gap> homalg_variable_2527 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2526 = homalg_variable_2527;
true
gap> homalg_variable_2528 := homalg_variable_2522 * (homalg_variable_8);;
gap> homalg_variable_2529 := homalg_variable_2528 * homalg_variable_2518;;
gap> homalg_variable_2530 := homalg_variable_2529 * homalg_variable_2513;;
gap> homalg_variable_2530 = homalg_variable_2515;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2513,homalg_variable_2515);; homalg_variable_2531 := homalg_variable_l[1];; homalg_variable_2532 := homalg_variable_l[2];;
gap> homalg_variable_2533 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2531 = homalg_variable_2533;
true
gap> homalg_variable_2534 := homalg_variable_2532 * homalg_variable_2515;;
gap> homalg_variable_2535 := homalg_variable_2513 + homalg_variable_2534;;
gap> homalg_variable_2531 = homalg_variable_2535;
true
gap> homalg_variable_2536 := SIH_DecideZeroRows(homalg_variable_2513,homalg_variable_2515);;
gap> homalg_variable_2537 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2536 = homalg_variable_2537;
true
gap> homalg_variable_2538 := homalg_variable_2532 * (homalg_variable_8);;
gap> homalg_variable_2539 := homalg_variable_2538 * homalg_variable_2515;;
gap> homalg_variable_2539 = homalg_variable_2513;
true
gap> homalg_variable_2540 := SIH_DecideZeroRows(homalg_variable_2513,homalg_variable_2016);;
gap> homalg_variable_2541 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2540 = homalg_variable_2541;
true
gap> homalg_variable_2543 := SIH_UnionOfRows(homalg_variable_2493,homalg_variable_696);;
gap> homalg_variable_2542 := SIH_BasisOfRowModule(homalg_variable_2543);;
gap> SI_nrows(homalg_variable_2542);
3
gap> homalg_variable_2544 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2542 = homalg_variable_2544;
false
gap> homalg_variable_2545 := SIH_DecideZeroRows(homalg_variable_1367,homalg_variable_2542);;
gap> homalg_variable_2546 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2545 = homalg_variable_2546;
true
gap> homalg_variable_2548 := SIH_UnionOfRows(homalg_variable_1367,homalg_variable_696);;
gap> homalg_variable_2547 := SIH_BasisOfRowModule(homalg_variable_2548);;
gap> SI_nrows(homalg_variable_2547);
3
gap> homalg_variable_2549 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2547 = homalg_variable_2549;
false
gap> homalg_variable_2550 := SIH_DecideZeroRows(homalg_variable_1367,homalg_variable_2547);;
gap> homalg_variable_2551 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2550 = homalg_variable_2551;
true
gap> homalg_variable_2552 := SIH_DecideZeroRows(homalg_variable_2493,homalg_variable_696);;
gap> homalg_variable_2553 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2552 = homalg_variable_2553;
false
gap> homalg_variable_2554 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2487 = homalg_variable_2554;
false
gap> homalg_variable_2555 := SIH_UnionOfRows(homalg_variable_2552,homalg_variable_696);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_2555);; homalg_variable_2556 := homalg_variable_l[1];; homalg_variable_2557 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_2556);
3
gap> homalg_variable_2558 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2556 = homalg_variable_2558;
false
gap> SI_ncols(homalg_variable_2557);
6
gap> homalg_variable_2559 := SIH_Submatrix(homalg_variable_2557,[1..3],[ 1, 2, 3 ]);;
gap> homalg_variable_2560 := homalg_variable_2559 * homalg_variable_2552;;
gap> homalg_variable_2561 := SIH_Submatrix(homalg_variable_2557,[1..3],[ 4, 5, 6 ]);;
gap> homalg_variable_2562 := homalg_variable_2561 * homalg_variable_696;;
gap> homalg_variable_2563 := homalg_variable_2560 + homalg_variable_2562;;
gap> homalg_variable_2556 = homalg_variable_2563;
true
gap> homalg_variable_2564 := SIH_DecideZeroRows(homalg_variable_1367,homalg_variable_696);;
gap> homalg_variable_2565 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2564 = homalg_variable_2565;
false
gap> homalg_variable_2556 = homalg_variable_1367;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2564,homalg_variable_2556);; homalg_variable_2566 := homalg_variable_l[1];; homalg_variable_2567 := homalg_variable_l[2];;
gap> homalg_variable_2568 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2566 = homalg_variable_2568;
true
gap> homalg_variable_2569 := homalg_variable_2567 * homalg_variable_2556;;
gap> homalg_variable_2570 := homalg_variable_2564 + homalg_variable_2569;;
gap> homalg_variable_2566 = homalg_variable_2570;
true
gap> homalg_variable_2571 := SIH_DecideZeroRows(homalg_variable_2564,homalg_variable_2556);;
gap> homalg_variable_2572 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2571 = homalg_variable_2572;
true
gap> homalg_variable_2574 := homalg_variable_2567 * (homalg_variable_8);;
gap> homalg_variable_2575 := SIH_Submatrix(homalg_variable_2557,[1..3],[ 1, 2, 3 ]);;
gap> homalg_variable_2576 := homalg_variable_2574 * homalg_variable_2575;;
gap> homalg_variable_2577 := homalg_variable_2576 * homalg_variable_2493;;
gap> homalg_variable_2578 := homalg_variable_2577 - homalg_variable_1367;;
gap> homalg_variable_2573 := SIH_DecideZeroRows(homalg_variable_2578,homalg_variable_696);;
gap> homalg_variable_2579 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2573 = homalg_variable_2579;
true
gap> homalg_variable_2581 := homalg_variable_2507 * homalg_variable_2452;;
gap> homalg_variable_2582 := homalg_variable_2576 * homalg_variable_2452;;
gap> homalg_variable_2583 := SIH_UnionOfRows(homalg_variable_2581,homalg_variable_2582);;
gap> homalg_variable_2580 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_2583);;
gap> SI_nrows(homalg_variable_2580);
3
gap> homalg_variable_2584 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_2580 = homalg_variable_2584;
false
gap> homalg_variable_2585 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_2580);;
gap> SI_nrows(homalg_variable_2585);
1
gap> homalg_variable_2586 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2585 = homalg_variable_2586;
true
gap> homalg_variable_2587 := SIH_BasisOfRowModule(homalg_variable_2580);;
gap> SI_nrows(homalg_variable_2587);
4
gap> homalg_variable_2588 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_2587 = homalg_variable_2588;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_2580);; homalg_variable_2589 := homalg_variable_l[1];; homalg_variable_2590 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_2589);
4
gap> homalg_variable_2591 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_2589 = homalg_variable_2591;
false
gap> SI_ncols(homalg_variable_2590);
3
gap> homalg_variable_2592 := homalg_variable_2590 * homalg_variable_2580;;
gap> homalg_variable_2589 = homalg_variable_2592;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2587,homalg_variable_2589);; homalg_variable_2593 := homalg_variable_l[1];; homalg_variable_2594 := homalg_variable_l[2];;
gap> homalg_variable_2595 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_2593 = homalg_variable_2595;
true
gap> homalg_variable_2596 := homalg_variable_2594 * homalg_variable_2589;;
gap> homalg_variable_2597 := homalg_variable_2587 + homalg_variable_2596;;
gap> homalg_variable_2593 = homalg_variable_2597;
true
gap> homalg_variable_2598 := SIH_DecideZeroRows(homalg_variable_2587,homalg_variable_2589);;
gap> homalg_variable_2599 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_2598 = homalg_variable_2599;
true
gap> homalg_variable_2600 := homalg_variable_2594 * (homalg_variable_8);;
gap> homalg_variable_2601 := homalg_variable_2600 * homalg_variable_2590;;
gap> homalg_variable_2602 := homalg_variable_2601 * homalg_variable_2580;;
gap> homalg_variable_2602 = homalg_variable_2587;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2580,homalg_variable_2587);; homalg_variable_2603 := homalg_variable_l[1];; homalg_variable_2604 := homalg_variable_l[2];;
gap> homalg_variable_2605 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_2603 = homalg_variable_2605;
true
gap> homalg_variable_2606 := homalg_variable_2604 * homalg_variable_2587;;
gap> homalg_variable_2607 := homalg_variable_2580 + homalg_variable_2606;;
gap> homalg_variable_2603 = homalg_variable_2607;
true
gap> homalg_variable_2608 := SIH_DecideZeroRows(homalg_variable_2580,homalg_variable_2587);;
gap> homalg_variable_2609 := SI_matrix(homalg_variable_5,3,6,"0");;
gap> homalg_variable_2608 = homalg_variable_2609;
true
gap> homalg_variable_2610 := homalg_variable_2604 * (homalg_variable_8);;
gap> homalg_variable_2611 := homalg_variable_2610 * homalg_variable_2587;;
gap> homalg_variable_2611 = homalg_variable_2580;
true
gap> SIH_ZeroRows(homalg_variable_2580);
[  ]
gap> SIH_ZeroRows(homalg_variable_680);
[  ]
gap> homalg_variable_2612 := homalg_variable_691 * homalg_variable_680;;
gap> homalg_variable_2613 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2612 = homalg_variable_2613;
true
gap> homalg_variable_2614 := SIH_DecideZeroRows(homalg_variable_691,homalg_variable_722);;
gap> homalg_variable_2615 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2614 = homalg_variable_2615;
true
gap> homalg_variable_2616 := SIH_Submatrix(homalg_variable_2580,[1..3],[ 4, 5, 6 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2616,homalg_variable_680);; homalg_variable_2617 := homalg_variable_l[1];; homalg_variable_2618 := homalg_variable_l[2];;
gap> homalg_variable_2619 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2617 = homalg_variable_2619;
true
gap> homalg_variable_2620 := homalg_variable_2618 * homalg_variable_680;;
gap> homalg_variable_2621 := homalg_variable_2616 + homalg_variable_2620;;
gap> homalg_variable_2617 = homalg_variable_2621;
true
gap> homalg_variable_2622 := SIH_DecideZeroRows(homalg_variable_2616,homalg_variable_680);;
gap> homalg_variable_2623 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2622 = homalg_variable_2623;
true
gap> homalg_variable_2624 := homalg_variable_2618 * (homalg_variable_8);;
gap> homalg_variable_2625 := homalg_variable_2624 * homalg_variable_680;;
gap> homalg_variable_2626 := homalg_variable_2625 - homalg_variable_2616;;
gap> homalg_variable_2627 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2626 = homalg_variable_2627;
true
gap> homalg_variable_2628 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2629 := SIH_UnionOfColumns(homalg_variable_2014,homalg_variable_2628);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2629,homalg_variable_2589);; homalg_variable_2630 := homalg_variable_l[1];; homalg_variable_2631 := homalg_variable_l[2];;
gap> homalg_variable_2632 := SI_matrix(homalg_variable_5,1,6,"0");;
gap> homalg_variable_2630 = homalg_variable_2632;
true
gap> homalg_variable_2633 := homalg_variable_2631 * homalg_variable_2589;;
gap> homalg_variable_2634 := homalg_variable_2629 + homalg_variable_2633;;
gap> homalg_variable_2630 = homalg_variable_2634;
true
gap> homalg_variable_2635 := SIH_DecideZeroRows(homalg_variable_2629,homalg_variable_2589);;
gap> homalg_variable_2636 := SI_matrix(homalg_variable_5,1,6,"0");;
gap> homalg_variable_2635 = homalg_variable_2636;
true
gap> SI_ncols(homalg_variable_2590);
3
gap> SI_nrows(homalg_variable_2590);
4
gap> homalg_variable_2637 := homalg_variable_2631 * (homalg_variable_8);;
gap> homalg_variable_2638 := homalg_variable_2637 * homalg_variable_2590;;
gap> homalg_variable_2639 := homalg_variable_2638 * homalg_variable_2580;;
gap> homalg_variable_2640 := homalg_variable_2639 - homalg_variable_2629;;
gap> homalg_variable_2641 := SI_matrix(homalg_variable_5,1,6,"0");;
gap> homalg_variable_2640 = homalg_variable_2641;
true
gap> homalg_variable_2642 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_2638);;
gap> SI_nrows(homalg_variable_2642);
1
gap> homalg_variable_2643 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2642 = homalg_variable_2643;
true
gap> homalg_variable_2645 := SIH_UnionOfRows(homalg_variable_2624,homalg_variable_722);;
gap> homalg_variable_2644 := SIH_BasisOfRowModule(homalg_variable_2645);;
gap> SI_nrows(homalg_variable_2644);
3
gap> homalg_variable_2646 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2644 = homalg_variable_2646;
false
gap> homalg_variable_2647 := SIH_DecideZeroRows(homalg_variable_1367,homalg_variable_2644);;
gap> homalg_variable_2648 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2647 = homalg_variable_2648;
true
gap> homalg_variable_2650 := SIH_UnionOfRows(homalg_variable_1367,homalg_variable_722);;
gap> homalg_variable_2649 := SIH_BasisOfRowModule(homalg_variable_2650);;
gap> SI_nrows(homalg_variable_2649);
3
gap> homalg_variable_2651 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2649 = homalg_variable_2651;
false
gap> homalg_variable_2652 := SIH_DecideZeroRows(homalg_variable_1367,homalg_variable_2649);;
gap> homalg_variable_2653 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2652 = homalg_variable_2653;
true
gap> homalg_variable_2654 := SIH_DecideZeroRows(homalg_variable_2624,homalg_variable_722);;
gap> homalg_variable_2655 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2654 = homalg_variable_2655;
false
gap> homalg_variable_2656 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2618 = homalg_variable_2656;
false
gap> homalg_variable_2657 := SIH_UnionOfRows(homalg_variable_2654,homalg_variable_722);;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_2657);; homalg_variable_2658 := homalg_variable_l[1];; homalg_variable_2659 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_2658);
3
gap> homalg_variable_2660 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2658 = homalg_variable_2660;
false
gap> SI_ncols(homalg_variable_2659);
4
gap> homalg_variable_2661 := SIH_Submatrix(homalg_variable_2659,[1..3],[ 1, 2, 3 ]);;
gap> homalg_variable_2662 := homalg_variable_2661 * homalg_variable_2654;;
gap> homalg_variable_2663 := SIH_Submatrix(homalg_variable_2659,[1..3],[ 4 ]);;
gap> homalg_variable_2664 := homalg_variable_2663 * homalg_variable_722;;
gap> homalg_variable_2665 := homalg_variable_2662 + homalg_variable_2664;;
gap> homalg_variable_2658 = homalg_variable_2665;
true
gap> homalg_variable_2666 := SIH_DecideZeroRows(homalg_variable_1367,homalg_variable_722);;
gap> homalg_variable_2667 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2666 = homalg_variable_2667;
false
gap> homalg_variable_2658 = homalg_variable_1367;
false
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2666,homalg_variable_2658);; homalg_variable_2668 := homalg_variable_l[1];; homalg_variable_2669 := homalg_variable_l[2];;
gap> homalg_variable_2670 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2668 = homalg_variable_2670;
true
gap> homalg_variable_2671 := homalg_variable_2669 * homalg_variable_2658;;
gap> homalg_variable_2672 := homalg_variable_2666 + homalg_variable_2671;;
gap> homalg_variable_2668 = homalg_variable_2672;
true
gap> homalg_variable_2673 := SIH_DecideZeroRows(homalg_variable_2666,homalg_variable_2658);;
gap> homalg_variable_2674 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2673 = homalg_variable_2674;
true
gap> homalg_variable_2676 := homalg_variable_2669 * (homalg_variable_8);;
gap> homalg_variable_2677 := SIH_Submatrix(homalg_variable_2659,[1..3],[ 1, 2, 3 ]);;
gap> homalg_variable_2678 := homalg_variable_2676 * homalg_variable_2677;;
gap> homalg_variable_2679 := homalg_variable_2678 * homalg_variable_2624;;
gap> homalg_variable_2680 := homalg_variable_2679 - homalg_variable_1367;;
gap> homalg_variable_2675 := SIH_DecideZeroRows(homalg_variable_2680,homalg_variable_722);;
gap> homalg_variable_2681 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2675 = homalg_variable_2681;
true
gap> homalg_variable_2683 := homalg_variable_2638 * homalg_variable_2580;;
gap> homalg_variable_2684 := homalg_variable_2678 * homalg_variable_2580;;
gap> homalg_variable_2685 := SIH_UnionOfRows(homalg_variable_2683,homalg_variable_2684);;
gap> homalg_variable_2682 := SIH_SyzygiesGeneratorsOfRows(homalg_variable_2685);;
gap> SI_nrows(homalg_variable_2682);
1
gap> homalg_variable_2686 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2682 = homalg_variable_2686;
false
gap> homalg_variable_2687 := SIH_BasisOfRowModule(homalg_variable_2682);;
gap> SI_nrows(homalg_variable_2687);
1
gap> homalg_variable_2688 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2687 = homalg_variable_2688;
false
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_2682);; homalg_variable_2689 := homalg_variable_l[1];; homalg_variable_2690 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_2689);
1
gap> homalg_variable_2691 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2689 = homalg_variable_2691;
false
gap> SI_ncols(homalg_variable_2690);
1
gap> homalg_variable_2692 := homalg_variable_2690 * homalg_variable_2682;;
gap> homalg_variable_2689 = homalg_variable_2692;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2687,homalg_variable_2689);; homalg_variable_2693 := homalg_variable_l[1];; homalg_variable_2694 := homalg_variable_l[2];;
gap> homalg_variable_2695 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2693 = homalg_variable_2695;
true
gap> homalg_variable_2696 := homalg_variable_2694 * homalg_variable_2689;;
gap> homalg_variable_2697 := homalg_variable_2687 + homalg_variable_2696;;
gap> homalg_variable_2693 = homalg_variable_2697;
true
gap> homalg_variable_2698 := SIH_DecideZeroRows(homalg_variable_2687,homalg_variable_2689);;
gap> homalg_variable_2699 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2698 = homalg_variable_2699;
true
gap> homalg_variable_2700 := homalg_variable_2694 * (homalg_variable_8);;
gap> homalg_variable_2701 := homalg_variable_2700 * homalg_variable_2690;;
gap> homalg_variable_2702 := homalg_variable_2701 * homalg_variable_2682;;
gap> homalg_variable_2702 = homalg_variable_2687;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2682,homalg_variable_2687);; homalg_variable_2703 := homalg_variable_l[1];; homalg_variable_2704 := homalg_variable_l[2];;
gap> homalg_variable_2705 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2703 = homalg_variable_2705;
true
gap> homalg_variable_2706 := homalg_variable_2704 * homalg_variable_2687;;
gap> homalg_variable_2707 := homalg_variable_2682 + homalg_variable_2706;;
gap> homalg_variable_2703 = homalg_variable_2707;
true
gap> homalg_variable_2708 := SIH_DecideZeroRows(homalg_variable_2682,homalg_variable_2687);;
gap> homalg_variable_2709 := SI_matrix(homalg_variable_5,1,4,"0");;
gap> homalg_variable_2708 = homalg_variable_2709;
true
gap> homalg_variable_2710 := homalg_variable_2704 * (homalg_variable_8);;
gap> homalg_variable_2711 := homalg_variable_2710 * homalg_variable_2687;;
gap> homalg_variable_2711 = homalg_variable_2682;
true
gap> homalg_variable_2712 := SIH_Submatrix(homalg_variable_2682,[1..1],[ 2, 3, 4 ]);;
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_2712,homalg_variable_691);; homalg_variable_2713 := homalg_variable_l[1];; homalg_variable_2714 := homalg_variable_l[2];;
gap> homalg_variable_2715 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2713 = homalg_variable_2715;
true
gap> homalg_variable_2716 := homalg_variable_2714 * homalg_variable_691;;
gap> homalg_variable_2717 := homalg_variable_2712 + homalg_variable_2716;;
gap> homalg_variable_2713 = homalg_variable_2717;
true
gap> homalg_variable_2718 := SIH_DecideZeroRows(homalg_variable_2712,homalg_variable_691);;
gap> homalg_variable_2719 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2718 = homalg_variable_2719;
true
gap> homalg_variable_2720 := homalg_variable_2714 * (homalg_variable_8);;
gap> homalg_variable_2721 := homalg_variable_2720 * homalg_variable_691;;
gap> homalg_variable_2722 := homalg_variable_2721 - homalg_variable_2712;;
gap> homalg_variable_2723 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2722 = homalg_variable_2723;
true
gap> homalg_variable_2724 := SIH_BasisOfRowModule(homalg_variable_2720);;
gap> SI_nrows(homalg_variable_2724);
1
gap> homalg_variable_2725 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2724 = homalg_variable_2725;
false
gap> homalg_variable_2724 = homalg_variable_2720;
true
gap> homalg_variable_2726 := SIH_DecideZeroRows(homalg_variable_237,homalg_variable_2724);;
gap> homalg_variable_2727 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2726 = homalg_variable_2727;
true
gap> homalg_variable_2720 = homalg_variable_237;
true
gap> homalg_variable_2728 := homalg_variable_2720 - homalg_variable_237;;
gap> homalg_variable_2729 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2728 = homalg_variable_2729;
true
gap> homalg_variable_2730 := SIH_Submatrix(homalg_variable_2683,[1..1],[ 1, 2, 3 ]);;
gap> homalg_variable_2731 := homalg_variable_2730 * homalg_variable_2581;;
gap> homalg_variable_2732 := SIH_Submatrix(homalg_variable_2684,[1..3],[ 1, 2, 3 ]);;
gap> homalg_variable_2733 := homalg_variable_2732 * homalg_variable_2581;;
gap> homalg_variable_2734 := SIH_UnionOfRows(homalg_variable_2731,homalg_variable_2733);;
gap> homalg_variable_2735 := SIH_Submatrix(homalg_variable_2683,[1..1],[ 4, 5, 6 ]);;
gap> homalg_variable_2736 := homalg_variable_2735 * homalg_variable_2582;;
gap> homalg_variable_2737 := SIH_Submatrix(homalg_variable_2684,[1..3],[ 4, 5, 6 ]);;
gap> homalg_variable_2738 := homalg_variable_2737 * homalg_variable_2582;;
gap> homalg_variable_2739 := SIH_UnionOfRows(homalg_variable_2736,homalg_variable_2738);;
gap> homalg_variable_2740 := homalg_variable_2734 + homalg_variable_2739;;
gap> homalg_variable_2741 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_2740 = homalg_variable_2741;
true
gap> homalg_variable_2742 := SIH_Submatrix(homalg_variable_2682,[1..1],[ 1 ]);;
gap> homalg_variable_2743 := homalg_variable_2742 * homalg_variable_2683;;
gap> homalg_variable_2744 := SIH_Submatrix(homalg_variable_2682,[1..1],[ 2, 3, 4 ]);;
gap> homalg_variable_2745 := homalg_variable_2744 * homalg_variable_2684;;
gap> homalg_variable_2746 := homalg_variable_2743 + homalg_variable_2745;;
gap> homalg_variable_2747 := SI_matrix(homalg_variable_5,1,6,"0");;
gap> homalg_variable_2746 = homalg_variable_2747;
true
gap> homalg_variable_2748 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_2749 := SIH_UnionOfRows(homalg_variable_2748,homalg_variable_233);;
gap> homalg_variable_2750 := SIH_Submatrix(homalg_variable_2581,[1..3],[ 4 ]);;
gap> homalg_variable_2751 := SIH_Submatrix(homalg_variable_2582,[1..3],[ 4 ]);;
gap> homalg_variable_2752 := SIH_UnionOfRows(homalg_variable_2750,homalg_variable_2751);;
gap> homalg_variable_2753 := homalg_variable_2749 - homalg_variable_2752;;
gap> homalg_variable_2754 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_2753 = homalg_variable_2754;
true
gap> homalg_variable_2755 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2756 := SIH_UnionOfRows(homalg_variable_2755,homalg_variable_680);;
gap> homalg_variable_2757 := SIH_Submatrix(homalg_variable_2683,[1..1],[ 4, 5, 6 ]);;
gap> homalg_variable_2758 := SIH_Submatrix(homalg_variable_2684,[1..3],[ 4, 5, 6 ]);;
gap> homalg_variable_2759 := SIH_UnionOfRows(homalg_variable_2757,homalg_variable_2758);;
gap> homalg_variable_2760 := homalg_variable_2756 - homalg_variable_2759;;
gap> homalg_variable_2761 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2760 = homalg_variable_2761;
true
gap> homalg_variable_2762 := SIH_Submatrix(homalg_variable_2682,[1..1],[ 2, 3, 4 ]);;
gap> homalg_variable_2763 := homalg_variable_691 - homalg_variable_2762;;
gap> homalg_variable_2764 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2763 = homalg_variable_2764;
true
gap> homalg_variable_2765 := SIH_UnionOfColumns(homalg_variable_1968,homalg_variable_2497);;
gap> homalg_variable_2766 := homalg_variable_2581 - homalg_variable_2765;;
gap> homalg_variable_2767 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_2766 = homalg_variable_2767;
true
gap> homalg_variable_2768 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_2769 := SIH_UnionOfColumns(homalg_variable_2014,homalg_variable_2768);;
gap> homalg_variable_2770 := homalg_variable_2683 - homalg_variable_2769;;
gap> homalg_variable_2771 := SI_matrix(homalg_variable_5,1,6,"0");;
gap> homalg_variable_2770 = homalg_variable_2771;
true
gap> homalg_variable_2772 := SIH_DecideZeroColumns(homalg_variable_12,homalg_variable_179);;
gap> homalg_variable_2773 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_2772 = homalg_variable_2773;
true
gap> homalg_variable_2774 := SIH_DecideZeroColumns(homalg_variable_173,homalg_variable_204);;
gap> homalg_variable_2775 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_2774 = homalg_variable_2775;
true
gap> homalg_variable_2776 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_1256);;
gap> SI_ncols(homalg_variable_2776);
1
gap> homalg_variable_2777 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_2776 = homalg_variable_2777;
true
gap> homalg_variable_2778 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2075);;
gap> SI_ncols(homalg_variable_2778);
1
gap> homalg_variable_2779 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_2778 = homalg_variable_2779;
true
gap> homalg_variable_2781 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2782 := SIH_Submatrix(homalg_variable_918,[ 1 ],[1..4]);;
gap> homalg_variable_2783 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2784 := SIH_UnionOfColumns(homalg_variable_2782,homalg_variable_2783);;
gap> homalg_variable_2785 := SIH_UnionOfRows(homalg_variable_2781,homalg_variable_2784);;
gap> homalg_variable_2780 := SIH_BasisOfColumnModule(homalg_variable_2785);;
gap> SI_ncols(homalg_variable_2780);
1
gap> homalg_variable_2786 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_2780 = homalg_variable_2786;
false
gap> homalg_variable_2787 := SIH_DecideZeroColumns(homalg_variable_813,homalg_variable_2780);;
gap> homalg_variable_2788 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_2787 = homalg_variable_2788;
false
gap> SIH_ZeroColumns(homalg_variable_2787);
[ 2 ]
gap> homalg_variable_2790 := SIH_Submatrix(homalg_variable_2787,[1..2],[ 1 ]);;
gap> homalg_variable_2789 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2790,homalg_variable_2780);;
gap> SI_ncols(homalg_variable_2789);
1
gap> homalg_variable_2791 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2789 = homalg_variable_2791;
true
gap> homalg_variable_2792 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2790,homalg_variable_2780);;
gap> SI_ncols(homalg_variable_2792);
1
gap> homalg_variable_2793 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_2792 = homalg_variable_2793;
true
gap> homalg_variable_2794 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2785);;
gap> SI_ncols(homalg_variable_2794);
4
gap> homalg_variable_2795 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_2794 = homalg_variable_2795;
false
gap> homalg_variable_2796 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2794);;
gap> SI_ncols(homalg_variable_2796);
1
gap> homalg_variable_2797 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_2796 = homalg_variable_2797;
true
gap> homalg_variable_2798 := SIH_BasisOfColumnModule(homalg_variable_2794);;
gap> SI_ncols(homalg_variable_2798);
4
gap> homalg_variable_2799 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_2798 = homalg_variable_2799;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_2794);; homalg_variable_2800 := homalg_variable_l[1];; homalg_variable_2801 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_2800);
4
gap> homalg_variable_2802 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_2800 = homalg_variable_2802;
false
gap> SI_nrows(homalg_variable_2801);
4
gap> homalg_variable_2803 := homalg_variable_2794 * homalg_variable_2801;;
gap> homalg_variable_2800 = homalg_variable_2803;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2798,homalg_variable_2800);; homalg_variable_2804 := homalg_variable_l[1];; homalg_variable_2805 := homalg_variable_l[2];;
gap> homalg_variable_2806 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_2804 = homalg_variable_2806;
true
gap> homalg_variable_2807 := homalg_variable_2800 * homalg_variable_2805;;
gap> homalg_variable_2808 := homalg_variable_2798 + homalg_variable_2807;;
gap> homalg_variable_2804 = homalg_variable_2808;
true
gap> homalg_variable_2809 := SIH_DecideZeroColumns(homalg_variable_2798,homalg_variable_2800);;
gap> homalg_variable_2810 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_2809 = homalg_variable_2810;
true
gap> homalg_variable_2811 := homalg_variable_2805 * (homalg_variable_8);;
gap> homalg_variable_2812 := homalg_variable_2801 * homalg_variable_2811;;
gap> homalg_variable_2813 := homalg_variable_2794 * homalg_variable_2812;;
gap> homalg_variable_2813 = homalg_variable_2798;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2794,homalg_variable_2798);; homalg_variable_2814 := homalg_variable_l[1];; homalg_variable_2815 := homalg_variable_l[2];;
gap> homalg_variable_2816 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_2814 = homalg_variable_2816;
true
gap> homalg_variable_2817 := homalg_variable_2798 * homalg_variable_2815;;
gap> homalg_variable_2818 := homalg_variable_2794 + homalg_variable_2817;;
gap> homalg_variable_2814 = homalg_variable_2818;
true
gap> homalg_variable_2819 := SIH_DecideZeroColumns(homalg_variable_2794,homalg_variable_2798);;
gap> homalg_variable_2820 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_2819 = homalg_variable_2820;
true
gap> homalg_variable_2821 := homalg_variable_2815 * (homalg_variable_8);;
gap> homalg_variable_2822 := homalg_variable_2798 * homalg_variable_2821;;
gap> homalg_variable_2822 = homalg_variable_2794;
true
gap> homalg_variable_2824 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_2825 := SIH_UnionOfColumns(homalg_variable_237,homalg_variable_2755);;
gap> homalg_variable_2826 := SIH_UnionOfRows(homalg_variable_2824,homalg_variable_2825);;
gap> homalg_variable_2823 := SIH_BasisOfColumnModule(homalg_variable_2826);;
gap> SI_ncols(homalg_variable_2823);
1
gap> homalg_variable_2827 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_2823 = homalg_variable_2827;
false
gap> homalg_variable_2828 := SIH_DecideZeroColumns(homalg_variable_2794,homalg_variable_2823);;
gap> homalg_variable_2829 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_2828 = homalg_variable_2829;
false
gap> SIH_ZeroColumns(homalg_variable_2828);
[ 1 ]
gap> homalg_variable_2831 := SIH_Submatrix(homalg_variable_2828,[1..5],[ 2, 3, 4 ]);;
gap> homalg_variable_2830 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2831,homalg_variable_2823);;
gap> SI_ncols(homalg_variable_2830);
1
gap> homalg_variable_2832 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_2830 = homalg_variable_2832;
true
gap> homalg_variable_2833 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2831,homalg_variable_2823);;
gap> SI_ncols(homalg_variable_2833);
1
gap> homalg_variable_2834 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_2833 = homalg_variable_2834;
true
gap> homalg_variable_2835 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2826);;
gap> SI_ncols(homalg_variable_2835);
3
gap> homalg_variable_2836 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2835 = homalg_variable_2836;
false
gap> homalg_variable_2837 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2835);;
gap> SI_ncols(homalg_variable_2837);
1
gap> homalg_variable_2838 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_2837 = homalg_variable_2838;
true
gap> homalg_variable_2839 := SIH_BasisOfColumnModule(homalg_variable_2835);;
gap> SI_ncols(homalg_variable_2839);
3
gap> homalg_variable_2840 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2839 = homalg_variable_2840;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_2835);; homalg_variable_2841 := homalg_variable_l[1];; homalg_variable_2842 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_2841);
3
gap> homalg_variable_2843 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2841 = homalg_variable_2843;
false
gap> SI_nrows(homalg_variable_2842);
3
gap> homalg_variable_2844 := homalg_variable_2835 * homalg_variable_2842;;
gap> homalg_variable_2841 = homalg_variable_2844;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2839,homalg_variable_2841);; homalg_variable_2845 := homalg_variable_l[1];; homalg_variable_2846 := homalg_variable_l[2];;
gap> homalg_variable_2847 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2845 = homalg_variable_2847;
true
gap> homalg_variable_2848 := homalg_variable_2841 * homalg_variable_2846;;
gap> homalg_variable_2849 := homalg_variable_2839 + homalg_variable_2848;;
gap> homalg_variable_2845 = homalg_variable_2849;
true
gap> homalg_variable_2850 := SIH_DecideZeroColumns(homalg_variable_2839,homalg_variable_2841);;
gap> homalg_variable_2851 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2850 = homalg_variable_2851;
true
gap> homalg_variable_2852 := homalg_variable_2846 * (homalg_variable_8);;
gap> homalg_variable_2853 := homalg_variable_2842 * homalg_variable_2852;;
gap> homalg_variable_2854 := homalg_variable_2835 * homalg_variable_2853;;
gap> homalg_variable_2854 = homalg_variable_2839;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2835,homalg_variable_2839);; homalg_variable_2855 := homalg_variable_l[1];; homalg_variable_2856 := homalg_variable_l[2];;
gap> homalg_variable_2857 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2855 = homalg_variable_2857;
true
gap> homalg_variable_2858 := homalg_variable_2839 * homalg_variable_2856;;
gap> homalg_variable_2859 := homalg_variable_2835 + homalg_variable_2858;;
gap> homalg_variable_2855 = homalg_variable_2859;
true
gap> homalg_variable_2860 := SIH_DecideZeroColumns(homalg_variable_2835,homalg_variable_2839);;
gap> homalg_variable_2861 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_2860 = homalg_variable_2861;
true
gap> homalg_variable_2862 := homalg_variable_2856 * (homalg_variable_8);;
gap> homalg_variable_2863 := homalg_variable_2839 * homalg_variable_2862;;
gap> homalg_variable_2863 = homalg_variable_2835;
true
gap> SIH_ZeroColumns(homalg_variable_2835);
[  ]
gap> homalg_variable_2865 := SIH_Submatrix(homalg_variable_1375,[ 1, 2 ],[1..7]);;
gap> homalg_variable_2866 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_2867 := SIH_UnionOfColumns(homalg_variable_2865,homalg_variable_2866);;
gap> homalg_variable_2864 := SIH_BasisOfColumnModule(homalg_variable_2867);;
gap> SI_ncols(homalg_variable_2864);
2
gap> homalg_variable_2868 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_2864 = homalg_variable_2868;
false
gap> homalg_variable_2869 := SIH_DecideZeroColumns(homalg_variable_813,homalg_variable_2864);;
gap> homalg_variable_2870 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_2869 = homalg_variable_2870;
true
gap> homalg_variable_2871 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2867);;
gap> SI_ncols(homalg_variable_2871);
8
gap> homalg_variable_2872 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_2871 = homalg_variable_2872;
false
gap> homalg_variable_2873 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2871);;
gap> SI_ncols(homalg_variable_2873);
1
gap> homalg_variable_2874 := SI_matrix(homalg_variable_5,8,1,"0");;
gap> homalg_variable_2873 = homalg_variable_2874;
true
gap> homalg_variable_2875 := SIH_BasisOfColumnModule(homalg_variable_2871);;
gap> SI_ncols(homalg_variable_2875);
8
gap> homalg_variable_2876 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_2875 = homalg_variable_2876;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_2871);; homalg_variable_2877 := homalg_variable_l[1];; homalg_variable_2878 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_2877);
8
gap> homalg_variable_2879 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_2877 = homalg_variable_2879;
false
gap> SI_nrows(homalg_variable_2878);
8
gap> homalg_variable_2880 := homalg_variable_2871 * homalg_variable_2878;;
gap> homalg_variable_2877 = homalg_variable_2880;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2875,homalg_variable_2877);; homalg_variable_2881 := homalg_variable_l[1];; homalg_variable_2882 := homalg_variable_l[2];;
gap> homalg_variable_2883 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_2881 = homalg_variable_2883;
true
gap> homalg_variable_2884 := homalg_variable_2877 * homalg_variable_2882;;
gap> homalg_variable_2885 := homalg_variable_2875 + homalg_variable_2884;;
gap> homalg_variable_2881 = homalg_variable_2885;
true
gap> homalg_variable_2886 := SIH_DecideZeroColumns(homalg_variable_2875,homalg_variable_2877);;
gap> homalg_variable_2887 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_2886 = homalg_variable_2887;
true
gap> homalg_variable_2888 := homalg_variable_2882 * (homalg_variable_8);;
gap> homalg_variable_2889 := homalg_variable_2878 * homalg_variable_2888;;
gap> homalg_variable_2890 := homalg_variable_2871 * homalg_variable_2889;;
gap> homalg_variable_2890 = homalg_variable_2875;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2871,homalg_variable_2875);; homalg_variable_2891 := homalg_variable_l[1];; homalg_variable_2892 := homalg_variable_l[2];;
gap> homalg_variable_2893 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_2891 = homalg_variable_2893;
true
gap> homalg_variable_2894 := homalg_variable_2875 * homalg_variable_2892;;
gap> homalg_variable_2895 := homalg_variable_2871 + homalg_variable_2894;;
gap> homalg_variable_2891 = homalg_variable_2895;
true
gap> homalg_variable_2896 := SIH_DecideZeroColumns(homalg_variable_2871,homalg_variable_2875);;
gap> homalg_variable_2897 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_2896 = homalg_variable_2897;
true
gap> homalg_variable_2898 := homalg_variable_2892 * (homalg_variable_8);;
gap> homalg_variable_2899 := homalg_variable_2875 * homalg_variable_2898;;
gap> homalg_variable_2899 = homalg_variable_2871;
true
gap> homalg_variable_2901 := SI_matrix(homalg_variable_5,7,10,"0");;
gap> homalg_variable_2902 := SIH_Submatrix(homalg_variable_1375,[ 1, 2, 3 ],[1..7]);;
gap> homalg_variable_2903 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2904 := SIH_UnionOfColumns(homalg_variable_2902,homalg_variable_2903);;
gap> homalg_variable_2905 := SIH_UnionOfRows(homalg_variable_2901,homalg_variable_2904);;
gap> homalg_variable_2900 := SIH_BasisOfColumnModule(homalg_variable_2905);;
gap> SI_ncols(homalg_variable_2900);
3
gap> homalg_variable_2906 := SI_matrix(homalg_variable_5,10,3,"0");;
gap> homalg_variable_2900 = homalg_variable_2906;
false
gap> homalg_variable_2907 := SIH_DecideZeroColumns(homalg_variable_2871,homalg_variable_2900);;
gap> homalg_variable_2908 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_2907 = homalg_variable_2908;
false
gap> SIH_ZeroColumns(homalg_variable_2907);
[ 1, 2, 3 ]
gap> homalg_variable_2910 := SIH_Submatrix(homalg_variable_2907,[1..10],[ 4, 5, 6, 7, 8 ]);;
gap> homalg_variable_2909 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2910,homalg_variable_2900);;
gap> SI_ncols(homalg_variable_2909);
1
gap> homalg_variable_2911 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_2909 = homalg_variable_2911;
true
gap> homalg_variable_2912 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2910,homalg_variable_2900);;
gap> SI_ncols(homalg_variable_2912);
1
gap> homalg_variable_2913 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_2912 = homalg_variable_2913;
true
gap> homalg_variable_2914 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2905);;
gap> SI_ncols(homalg_variable_2914);
7
gap> homalg_variable_2915 := SI_matrix(homalg_variable_5,10,7,"0");;
gap> homalg_variable_2914 = homalg_variable_2915;
false
gap> homalg_variable_2916 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2914);;
gap> SI_ncols(homalg_variable_2916);
1
gap> homalg_variable_2917 := SI_matrix(homalg_variable_5,7,1,"0");;
gap> homalg_variable_2916 = homalg_variable_2917;
true
gap> homalg_variable_2918 := SIH_BasisOfColumnModule(homalg_variable_2914);;
gap> SI_ncols(homalg_variable_2918);
7
gap> homalg_variable_2919 := SI_matrix(homalg_variable_5,10,7,"0");;
gap> homalg_variable_2918 = homalg_variable_2919;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_2914);; homalg_variable_2920 := homalg_variable_l[1];; homalg_variable_2921 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_2920);
7
gap> homalg_variable_2922 := SI_matrix(homalg_variable_5,10,7,"0");;
gap> homalg_variable_2920 = homalg_variable_2922;
false
gap> SI_nrows(homalg_variable_2921);
7
gap> homalg_variable_2923 := homalg_variable_2914 * homalg_variable_2921;;
gap> homalg_variable_2920 = homalg_variable_2923;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2918,homalg_variable_2920);; homalg_variable_2924 := homalg_variable_l[1];; homalg_variable_2925 := homalg_variable_l[2];;
gap> homalg_variable_2926 := SI_matrix(homalg_variable_5,10,7,"0");;
gap> homalg_variable_2924 = homalg_variable_2926;
true
gap> homalg_variable_2927 := homalg_variable_2920 * homalg_variable_2925;;
gap> homalg_variable_2928 := homalg_variable_2918 + homalg_variable_2927;;
gap> homalg_variable_2924 = homalg_variable_2928;
true
gap> homalg_variable_2929 := SIH_DecideZeroColumns(homalg_variable_2918,homalg_variable_2920);;
gap> homalg_variable_2930 := SI_matrix(homalg_variable_5,10,7,"0");;
gap> homalg_variable_2929 = homalg_variable_2930;
true
gap> homalg_variable_2931 := homalg_variable_2925 * (homalg_variable_8);;
gap> homalg_variable_2932 := homalg_variable_2921 * homalg_variable_2931;;
gap> homalg_variable_2933 := homalg_variable_2914 * homalg_variable_2932;;
gap> homalg_variable_2933 = homalg_variable_2918;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2914,homalg_variable_2918);; homalg_variable_2934 := homalg_variable_l[1];; homalg_variable_2935 := homalg_variable_l[2];;
gap> homalg_variable_2936 := SI_matrix(homalg_variable_5,10,7,"0");;
gap> homalg_variable_2934 = homalg_variable_2936;
true
gap> homalg_variable_2937 := homalg_variable_2918 * homalg_variable_2935;;
gap> homalg_variable_2938 := homalg_variable_2914 + homalg_variable_2937;;
gap> homalg_variable_2934 = homalg_variable_2938;
true
gap> homalg_variable_2939 := SIH_DecideZeroColumns(homalg_variable_2914,homalg_variable_2918);;
gap> homalg_variable_2940 := SI_matrix(homalg_variable_5,10,7,"0");;
gap> homalg_variable_2939 = homalg_variable_2940;
true
gap> homalg_variable_2941 := homalg_variable_2935 * (homalg_variable_8);;
gap> homalg_variable_2942 := homalg_variable_2918 * homalg_variable_2941;;
gap> homalg_variable_2942 = homalg_variable_2914;
true
gap> homalg_variable_2944 := SI_matrix(homalg_variable_5,7,6,"0");;
gap> homalg_variable_2945 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_2946 := SIH_UnionOfColumns(homalg_variable_1367,homalg_variable_2945);;
gap> homalg_variable_2947 := SIH_UnionOfRows(homalg_variable_2944,homalg_variable_2946);;
gap> homalg_variable_2943 := SIH_BasisOfColumnModule(homalg_variable_2947);;
gap> SI_ncols(homalg_variable_2943);
3
gap> homalg_variable_2948 := SI_matrix(homalg_variable_5,10,3,"0");;
gap> homalg_variable_2943 = homalg_variable_2948;
false
gap> homalg_variable_2949 := SIH_DecideZeroColumns(homalg_variable_2914,homalg_variable_2943);;
gap> homalg_variable_2950 := SI_matrix(homalg_variable_5,10,7,"0");;
gap> homalg_variable_2949 = homalg_variable_2950;
false
gap> SIH_ZeroColumns(homalg_variable_2949);
[ 1, 2, 3 ]
gap> homalg_variable_2952 := SIH_Submatrix(homalg_variable_2949,[1..10],[ 4, 5, 6, 7 ]);;
gap> homalg_variable_2951 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2952,homalg_variable_2943);;
gap> SI_ncols(homalg_variable_2951);
1
gap> homalg_variable_2953 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_2951 = homalg_variable_2953;
true
gap> homalg_variable_2954 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2952,homalg_variable_2943);;
gap> SI_ncols(homalg_variable_2954);
1
gap> homalg_variable_2955 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_2954 = homalg_variable_2955;
true
gap> homalg_variable_2956 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2947);;
gap> SI_ncols(homalg_variable_2956);
3
gap> homalg_variable_2957 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_2956 = homalg_variable_2957;
false
gap> homalg_variable_2958 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2956);;
gap> SI_ncols(homalg_variable_2958);
1
gap> homalg_variable_2959 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_2958 = homalg_variable_2959;
true
gap> homalg_variable_2960 := SIH_BasisOfColumnModule(homalg_variable_2956);;
gap> SI_ncols(homalg_variable_2960);
3
gap> homalg_variable_2961 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_2960 = homalg_variable_2961;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_2956);; homalg_variable_2962 := homalg_variable_l[1];; homalg_variable_2963 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_2962);
3
gap> homalg_variable_2964 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_2962 = homalg_variable_2964;
false
gap> SI_nrows(homalg_variable_2963);
3
gap> homalg_variable_2965 := homalg_variable_2956 * homalg_variable_2963;;
gap> homalg_variable_2962 = homalg_variable_2965;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2960,homalg_variable_2962);; homalg_variable_2966 := homalg_variable_l[1];; homalg_variable_2967 := homalg_variable_l[2];;
gap> homalg_variable_2968 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_2966 = homalg_variable_2968;
true
gap> homalg_variable_2969 := homalg_variable_2962 * homalg_variable_2967;;
gap> homalg_variable_2970 := homalg_variable_2960 + homalg_variable_2969;;
gap> homalg_variable_2966 = homalg_variable_2970;
true
gap> homalg_variable_2971 := SIH_DecideZeroColumns(homalg_variable_2960,homalg_variable_2962);;
gap> homalg_variable_2972 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_2971 = homalg_variable_2972;
true
gap> homalg_variable_2973 := homalg_variable_2967 * (homalg_variable_8);;
gap> homalg_variable_2974 := homalg_variable_2963 * homalg_variable_2973;;
gap> homalg_variable_2975 := homalg_variable_2956 * homalg_variable_2974;;
gap> homalg_variable_2975 = homalg_variable_2960;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2956,homalg_variable_2960);; homalg_variable_2976 := homalg_variable_l[1];; homalg_variable_2977 := homalg_variable_l[2];;
gap> homalg_variable_2978 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_2976 = homalg_variable_2978;
true
gap> homalg_variable_2979 := homalg_variable_2960 * homalg_variable_2977;;
gap> homalg_variable_2980 := homalg_variable_2956 + homalg_variable_2979;;
gap> homalg_variable_2976 = homalg_variable_2980;
true
gap> homalg_variable_2981 := SIH_DecideZeroColumns(homalg_variable_2956,homalg_variable_2960);;
gap> homalg_variable_2982 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_2981 = homalg_variable_2982;
true
gap> homalg_variable_2983 := homalg_variable_2977 * (homalg_variable_8);;
gap> homalg_variable_2984 := homalg_variable_2960 * homalg_variable_2983;;
gap> homalg_variable_2984 = homalg_variable_2956;
true
gap> SIH_ZeroColumns(homalg_variable_2956);
[  ]
gap> homalg_variable_2986 := SI_matrix(homalg_variable_5,2,14,"0");;
gap> homalg_variable_2987 := SI_matrix( SI_freemodule( homalg_variable_5,9 ) );;
gap> homalg_variable_2988 := SIH_Submatrix(homalg_variable_2987,[ 1, 2, 3, 4, 5 ],[1..9]);;
gap> homalg_variable_2989 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_2990 := SIH_UnionOfColumns(homalg_variable_2988,homalg_variable_2989);;
gap> homalg_variable_2991 := SIH_UnionOfRows(homalg_variable_2986,homalg_variable_2990);;
gap> homalg_variable_2985 := SIH_BasisOfColumnModule(homalg_variable_2991);;
gap> SI_ncols(homalg_variable_2985);
5
gap> homalg_variable_2992 := SI_matrix(homalg_variable_5,7,5,"0");;
gap> homalg_variable_2985 = homalg_variable_2992;
false
gap> homalg_variable_2993 := SIH_DecideZeroColumns(homalg_variable_1375,homalg_variable_2985);;
gap> homalg_variable_2994 := SI_matrix(homalg_variable_5,7,7,"0");;
gap> homalg_variable_2993 = homalg_variable_2994;
false
gap> SIH_ZeroColumns(homalg_variable_2993);
[ 3, 4, 5, 6, 7 ]
gap> homalg_variable_2995 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2991);;
gap> SI_ncols(homalg_variable_2995);
9
gap> homalg_variable_2996 := SI_matrix(homalg_variable_5,14,9,"0");;
gap> homalg_variable_2995 = homalg_variable_2996;
false
gap> homalg_variable_2997 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2995);;
gap> SI_ncols(homalg_variable_2997);
1
gap> homalg_variable_2998 := SI_matrix(homalg_variable_5,9,1,"0");;
gap> homalg_variable_2997 = homalg_variable_2998;
true
gap> homalg_variable_2999 := SIH_BasisOfColumnModule(homalg_variable_2995);;
gap> SI_ncols(homalg_variable_2999);
9
gap> homalg_variable_3000 := SI_matrix(homalg_variable_5,14,9,"0");;
gap> homalg_variable_2999 = homalg_variable_3000;
false
gap> for _del in [ "homalg_variable_2481", "homalg_variable_2482", "homalg_variable_2483", "homalg_variable_2484", "homalg_variable_2486", "homalg_variable_2488", "homalg_variable_2489", "homalg_variable_2490", "homalg_variable_2491", "homalg_variable_2492", "homalg_variable_2494", "homalg_variable_2495", "homalg_variable_2496", "homalg_variable_2499", "homalg_variable_2501", "homalg_variable_2502", "homalg_variable_2503", "homalg_variable_2504", "homalg_variable_2505", "homalg_variable_2508", "homalg_variable_2509", "homalg_variable_2510", "homalg_variable_2511", "homalg_variable_2512", "homalg_variable_2514", "homalg_variable_2516", "homalg_variable_2519", "homalg_variable_2520", "homalg_variable_2523", "homalg_variable_2526", "homalg_variable_2527", "homalg_variable_2530", "homalg_variable_2531", "homalg_variable_2532", "homalg_variable_2533", "homalg_variable_2534", "homalg_variable_2535", "homalg_variable_2536", "homalg_variable_2537", "homalg_variable_2538", "homalg_variable_2539", "homalg_variable_2540", "homalg_variable_2541", "homalg_variable_2544", "homalg_variable_2545", "homalg_variable_2546", "homalg_variable_2549", "homalg_variable_2550", "homalg_variable_2551", "homalg_variable_2552", "homalg_variable_2553", "homalg_variable_2554", "homalg_variable_2555", "homalg_variable_2556", "homalg_variable_2558", "homalg_variable_2559", "homalg_variable_2560", "homalg_variable_2561", "homalg_variable_2562", "homalg_variable_2563", "homalg_variable_2564", "homalg_variable_2565", "homalg_variable_2566", "homalg_variable_2568", "homalg_variable_2569", "homalg_variable_2570", "homalg_variable_2571", "homalg_variable_2572", "homalg_variable_2573", "homalg_variable_2577", "homalg_variable_2578", "homalg_variable_2579", "homalg_variable_2584", "homalg_variable_2585", "homalg_variable_2586", "homalg_variable_2588", "homalg_variable_2591", "homalg_variable_2592", "homalg_variable_2593", "homalg_variable_2594", "homalg_variable_2595", "homalg_variable_2596", "homalg_variable_2597", "homalg_variable_2598", "homalg_variable_2599", "homalg_variable_2600", "homalg_variable_2601", "homalg_variable_2602", "homalg_variable_2603", "homalg_variable_2604", "homalg_variable_2605", "homalg_variable_2606", "homalg_variable_2607", "homalg_variable_2608", "homalg_variable_2609", "homalg_variable_2610", "homalg_variable_2611", "homalg_variable_2612", "homalg_variable_2613", "homalg_variable_2614", "homalg_variable_2615", "homalg_variable_2619", "homalg_variable_2622", "homalg_variable_2623", "homalg_variable_2625", "homalg_variable_2626", "homalg_variable_2627", "homalg_variable_2630", "homalg_variable_2632", "homalg_variable_2633", "homalg_variable_2634", "homalg_variable_2635", "homalg_variable_2636", "homalg_variable_2639", "homalg_variable_2640", "homalg_variable_2641", "homalg_variable_2642", "homalg_variable_2643", "homalg_variable_2646", "homalg_variable_2647", "homalg_variable_2648", "homalg_variable_2651", "homalg_variable_2652", "homalg_variable_2653", "homalg_variable_2655", "homalg_variable_2656", "homalg_variable_2660", "homalg_variable_2661", "homalg_variable_2662", "homalg_variable_2663", "homalg_variable_2664", "homalg_variable_2665", "homalg_variable_2667", "homalg_variable_2670", "homalg_variable_2671", "homalg_variable_2672", "homalg_variable_2673", "homalg_variable_2674", "homalg_variable_2681", "homalg_variable_2686", "homalg_variable_2688", "homalg_variable_2691", "homalg_variable_2692", "homalg_variable_2693", "homalg_variable_2694", "homalg_variable_2695", "homalg_variable_2696", "homalg_variable_2697", "homalg_variable_2698", "homalg_variable_2699", "homalg_variable_2700", "homalg_variable_2701", "homalg_variable_2702", "homalg_variable_2703", "homalg_variable_2704", "homalg_variable_2705", "homalg_variable_2706", "homalg_variable_2707", "homalg_variable_2708", "homalg_variable_2709", "homalg_variable_2710", "homalg_variable_2711", "homalg_variable_2715", "homalg_variable_2716", "homalg_variable_2717", "homalg_variable_2719", "homalg_variable_2721", "homalg_variable_2722", "homalg_variable_2723", "homalg_variable_2725", "homalg_variable_2726", "homalg_variable_2727", "homalg_variable_2728", "homalg_variable_2729", "homalg_variable_2730", "homalg_variable_2731", "homalg_variable_2732", "homalg_variable_2733", "homalg_variable_2734", "homalg_variable_2735", "homalg_variable_2736", "homalg_variable_2737", "homalg_variable_2738", "homalg_variable_2739", "homalg_variable_2740", "homalg_variable_2741", "homalg_variable_2742", "homalg_variable_2743", "homalg_variable_2744", "homalg_variable_2745", "homalg_variable_2746", "homalg_variable_2747", "homalg_variable_2748", "homalg_variable_2749", "homalg_variable_2750", "homalg_variable_2751", "homalg_variable_2752", "homalg_variable_2753", "homalg_variable_2754", "homalg_variable_2756", "homalg_variable_2757", "homalg_variable_2758", "homalg_variable_2759", "homalg_variable_2760", "homalg_variable_2761", "homalg_variable_2762", "homalg_variable_2763", "homalg_variable_2764", "homalg_variable_2768", "homalg_variable_2769", "homalg_variable_2770", "homalg_variable_2771", "homalg_variable_2772", "homalg_variable_2773", "homalg_variable_2774", "homalg_variable_2775", "homalg_variable_2778", "homalg_variable_2779", "homalg_variable_2786", "homalg_variable_2788", "homalg_variable_2789", "homalg_variable_2791", "homalg_variable_2792", "homalg_variable_2793", "homalg_variable_2795", "homalg_variable_2796", "homalg_variable_2797", "homalg_variable_2799", "homalg_variable_2802", "homalg_variable_2803", "homalg_variable_2804", "homalg_variable_2805", "homalg_variable_2806", "homalg_variable_2807", "homalg_variable_2808", "homalg_variable_2809", "homalg_variable_2810", "homalg_variable_2811", "homalg_variable_2812", "homalg_variable_2813", "homalg_variable_2814", "homalg_variable_2815", "homalg_variable_2816", "homalg_variable_2817", "homalg_variable_2818", "homalg_variable_2819", "homalg_variable_2820", "homalg_variable_2821", "homalg_variable_2822", "homalg_variable_2827", "homalg_variable_2829", "homalg_variable_2830", "homalg_variable_2832", "homalg_variable_2833", "homalg_variable_2834", "homalg_variable_2836", "homalg_variable_2837", "homalg_variable_2838", "homalg_variable_2840", "homalg_variable_2843", "homalg_variable_2844", "homalg_variable_2845", "homalg_variable_2846", "homalg_variable_2847", "homalg_variable_2848", "homalg_variable_2849", "homalg_variable_2850", "homalg_variable_2851", "homalg_variable_2852", "homalg_variable_2853", "homalg_variable_2854", "homalg_variable_2855", "homalg_variable_2856", "homalg_variable_2857", "homalg_variable_2858", "homalg_variable_2859", "homalg_variable_2860", "homalg_variable_2861", "homalg_variable_2862", "homalg_variable_2863", "homalg_variable_2868", "homalg_variable_2869", "homalg_variable_2870", "homalg_variable_2872", "homalg_variable_2873", "homalg_variable_2874", "homalg_variable_2876", "homalg_variable_2879", "homalg_variable_2880", "homalg_variable_2881", "homalg_variable_2882", "homalg_variable_2883", "homalg_variable_2884", "homalg_variable_2885", "homalg_variable_2886", "homalg_variable_2887", "homalg_variable_2888", "homalg_variable_2889", "homalg_variable_2890", "homalg_variable_2891", "homalg_variable_2892", "homalg_variable_2893", "homalg_variable_2894", "homalg_variable_2895", "homalg_variable_2896", "homalg_variable_2897", "homalg_variable_2898", "homalg_variable_2899", "homalg_variable_2906", "homalg_variable_2908", "homalg_variable_2909", "homalg_variable_2911", "homalg_variable_2912", "homalg_variable_2913", "homalg_variable_2915", "homalg_variable_2916", "homalg_variable_2917", "homalg_variable_2919", "homalg_variable_2922", "homalg_variable_2923", "homalg_variable_2924", "homalg_variable_2925", "homalg_variable_2926", "homalg_variable_2927", "homalg_variable_2928", "homalg_variable_2929", "homalg_variable_2930", "homalg_variable_2931", "homalg_variable_2932", "homalg_variable_2933", "homalg_variable_2934", "homalg_variable_2935", "homalg_variable_2936", "homalg_variable_2937", "homalg_variable_2938", "homalg_variable_2939", "homalg_variable_2940", "homalg_variable_2941", "homalg_variable_2942", "homalg_variable_2948", "homalg_variable_2950", "homalg_variable_2951", "homalg_variable_2953", "homalg_variable_2954", "homalg_variable_2955", "homalg_variable_2957", "homalg_variable_2958", "homalg_variable_2959", "homalg_variable_2961", "homalg_variable_2964", "homalg_variable_2965", "homalg_variable_2966", "homalg_variable_2967", "homalg_variable_2968", "homalg_variable_2969", "homalg_variable_2970", "homalg_variable_2971", "homalg_variable_2972", "homalg_variable_2973", "homalg_variable_2974", "homalg_variable_2975", "homalg_variable_2976", "homalg_variable_2977", "homalg_variable_2978", "homalg_variable_2979", "homalg_variable_2980", "homalg_variable_2981", "homalg_variable_2982", "homalg_variable_2983", "homalg_variable_2984" ] do UnbindGlobal( _del );; od;;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_2995);; homalg_variable_3001 := homalg_variable_l[1];; homalg_variable_3002 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3001);
9
gap> homalg_variable_3003 := SI_matrix(homalg_variable_5,14,9,"0");;
gap> homalg_variable_3001 = homalg_variable_3003;
false
gap> SI_nrows(homalg_variable_3002);
9
gap> homalg_variable_3004 := homalg_variable_2995 * homalg_variable_3002;;
gap> homalg_variable_3001 = homalg_variable_3004;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2999,homalg_variable_3001);; homalg_variable_3005 := homalg_variable_l[1];; homalg_variable_3006 := homalg_variable_l[2];;
gap> homalg_variable_3007 := SI_matrix(homalg_variable_5,14,9,"0");;
gap> homalg_variable_3005 = homalg_variable_3007;
true
gap> homalg_variable_3008 := homalg_variable_3001 * homalg_variable_3006;;
gap> homalg_variable_3009 := homalg_variable_2999 + homalg_variable_3008;;
gap> homalg_variable_3005 = homalg_variable_3009;
true
gap> homalg_variable_3010 := SIH_DecideZeroColumns(homalg_variable_2999,homalg_variable_3001);;
gap> homalg_variable_3011 := SI_matrix(homalg_variable_5,14,9,"0");;
gap> homalg_variable_3010 = homalg_variable_3011;
true
gap> homalg_variable_3012 := homalg_variable_3006 * (homalg_variable_8);;
gap> homalg_variable_3013 := homalg_variable_3002 * homalg_variable_3012;;
gap> homalg_variable_3014 := homalg_variable_2995 * homalg_variable_3013;;
gap> homalg_variable_3014 = homalg_variable_2999;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2995,homalg_variable_2999);; homalg_variable_3015 := homalg_variable_l[1];; homalg_variable_3016 := homalg_variable_l[2];;
gap> homalg_variable_3017 := SI_matrix(homalg_variable_5,14,9,"0");;
gap> homalg_variable_3015 = homalg_variable_3017;
true
gap> homalg_variable_3018 := homalg_variable_2999 * homalg_variable_3016;;
gap> homalg_variable_3019 := homalg_variable_2995 + homalg_variable_3018;;
gap> homalg_variable_3015 = homalg_variable_3019;
true
gap> homalg_variable_3020 := SIH_DecideZeroColumns(homalg_variable_2995,homalg_variable_2999);;
gap> homalg_variable_3021 := SI_matrix(homalg_variable_5,14,9,"0");;
gap> homalg_variable_3020 = homalg_variable_3021;
true
gap> homalg_variable_3022 := homalg_variable_3016 * (homalg_variable_8);;
gap> homalg_variable_3023 := homalg_variable_2999 * homalg_variable_3022;;
gap> homalg_variable_3023 = homalg_variable_2995;
true
gap> homalg_variable_3025 := SI_matrix(homalg_variable_5,9,10,"0");;
gap> homalg_variable_3026 := SIH_Submatrix(homalg_variable_1375,[ 1, 2, 3, 4, 5 ],[1..7]);;
gap> homalg_variable_3027 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_3028 := SIH_UnionOfColumns(homalg_variable_3026,homalg_variable_3027);;
gap> homalg_variable_3029 := SIH_UnionOfRows(homalg_variable_3025,homalg_variable_3028);;
gap> homalg_variable_3024 := SIH_BasisOfColumnModule(homalg_variable_3029);;
gap> SI_ncols(homalg_variable_3024);
5
gap> homalg_variable_3030 := SI_matrix(homalg_variable_5,14,5,"0");;
gap> homalg_variable_3024 = homalg_variable_3030;
false
gap> homalg_variable_3031 := SIH_DecideZeroColumns(homalg_variable_2995,homalg_variable_3024);;
gap> homalg_variable_3032 := SI_matrix(homalg_variable_5,14,9,"0");;
gap> homalg_variable_3031 = homalg_variable_3032;
false
gap> SIH_ZeroColumns(homalg_variable_3031);
[ 1, 2, 3, 4, 5 ]
gap> homalg_variable_3034 := SIH_Submatrix(homalg_variable_3031,[1..14],[ 6, 7, 8, 9 ]);;
gap> homalg_variable_3033 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3034,homalg_variable_3024);;
gap> SI_ncols(homalg_variable_3033);
1
gap> homalg_variable_3035 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3033 = homalg_variable_3035;
true
gap> homalg_variable_3036 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3034,homalg_variable_3024);;
gap> SI_ncols(homalg_variable_3036);
1
gap> homalg_variable_3037 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3036 = homalg_variable_3037;
true
gap> homalg_variable_3038 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3029);;
gap> SI_ncols(homalg_variable_3038);
5
gap> homalg_variable_3039 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_3038 = homalg_variable_3039;
false
gap> homalg_variable_3040 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3038);;
gap> SI_ncols(homalg_variable_3040);
1
gap> homalg_variable_3041 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_3040 = homalg_variable_3041;
true
gap> homalg_variable_3042 := SIH_BasisOfColumnModule(homalg_variable_3038);;
gap> SI_ncols(homalg_variable_3042);
5
gap> homalg_variable_3043 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_3042 = homalg_variable_3043;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3038);; homalg_variable_3044 := homalg_variable_l[1];; homalg_variable_3045 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3044);
5
gap> homalg_variable_3046 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_3044 = homalg_variable_3046;
false
gap> SI_nrows(homalg_variable_3045);
5
gap> homalg_variable_3047 := homalg_variable_3038 * homalg_variable_3045;;
gap> homalg_variable_3044 = homalg_variable_3047;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3042,homalg_variable_3044);; homalg_variable_3048 := homalg_variable_l[1];; homalg_variable_3049 := homalg_variable_l[2];;
gap> homalg_variable_3050 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_3048 = homalg_variable_3050;
true
gap> homalg_variable_3051 := homalg_variable_3044 * homalg_variable_3049;;
gap> homalg_variable_3052 := homalg_variable_3042 + homalg_variable_3051;;
gap> homalg_variable_3048 = homalg_variable_3052;
true
gap> homalg_variable_3053 := SIH_DecideZeroColumns(homalg_variable_3042,homalg_variable_3044);;
gap> homalg_variable_3054 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_3053 = homalg_variable_3054;
true
gap> homalg_variable_3055 := homalg_variable_3049 * (homalg_variable_8);;
gap> homalg_variable_3056 := homalg_variable_3045 * homalg_variable_3055;;
gap> homalg_variable_3057 := homalg_variable_3038 * homalg_variable_3056;;
gap> homalg_variable_3057 = homalg_variable_3042;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3038,homalg_variable_3042);; homalg_variable_3058 := homalg_variable_l[1];; homalg_variable_3059 := homalg_variable_l[2];;
gap> homalg_variable_3060 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_3058 = homalg_variable_3060;
true
gap> homalg_variable_3061 := homalg_variable_3042 * homalg_variable_3059;;
gap> homalg_variable_3062 := homalg_variable_3038 + homalg_variable_3061;;
gap> homalg_variable_3058 = homalg_variable_3062;
true
gap> homalg_variable_3063 := SIH_DecideZeroColumns(homalg_variable_3038,homalg_variable_3042);;
gap> homalg_variable_3064 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_3063 = homalg_variable_3064;
true
gap> homalg_variable_3065 := homalg_variable_3059 * (homalg_variable_8);;
gap> homalg_variable_3066 := homalg_variable_3042 * homalg_variable_3065;;
gap> homalg_variable_3066 = homalg_variable_3038;
true
gap> homalg_variable_3068 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_3069 := SIH_UnionOfColumns(homalg_variable_1367,homalg_variable_2497);;
gap> homalg_variable_3070 := SIH_UnionOfRows(homalg_variable_3068,homalg_variable_3069);;
gap> homalg_variable_3067 := SIH_BasisOfColumnModule(homalg_variable_3070);;
gap> SI_ncols(homalg_variable_3067);
3
gap> homalg_variable_3071 := SI_matrix(homalg_variable_5,10,3,"0");;
gap> homalg_variable_3067 = homalg_variable_3071;
false
gap> homalg_variable_3072 := SIH_DecideZeroColumns(homalg_variable_3038,homalg_variable_3067);;
gap> homalg_variable_3073 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_3072 = homalg_variable_3073;
false
gap> SIH_ZeroColumns(homalg_variable_3072);
[ 1, 2, 3 ]
gap> homalg_variable_3075 := SIH_Submatrix(homalg_variable_3072,[1..10],[ 4, 5 ]);;
gap> homalg_variable_3074 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3075,homalg_variable_3067);;
gap> SI_ncols(homalg_variable_3074);
1
gap> homalg_variable_3076 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_3074 = homalg_variable_3076;
true
gap> homalg_variable_3077 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3075,homalg_variable_3067);;
gap> SI_ncols(homalg_variable_3077);
1
gap> homalg_variable_3078 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_3077 = homalg_variable_3078;
true
gap> homalg_variable_3079 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3070);;
gap> SI_ncols(homalg_variable_3079);
1
gap> homalg_variable_3080 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3079 = homalg_variable_3080;
false
gap> homalg_variable_3081 := SIH_BasisOfColumnModule(homalg_variable_3079);;
gap> SI_ncols(homalg_variable_3081);
1
gap> homalg_variable_3082 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3081 = homalg_variable_3082;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3079);; homalg_variable_3083 := homalg_variable_l[1];; homalg_variable_3084 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3083);
1
gap> homalg_variable_3085 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3083 = homalg_variable_3085;
false
gap> SI_nrows(homalg_variable_3084);
1
gap> homalg_variable_3086 := homalg_variable_3079 * homalg_variable_3084;;
gap> homalg_variable_3083 = homalg_variable_3086;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3081,homalg_variable_3083);; homalg_variable_3087 := homalg_variable_l[1];; homalg_variable_3088 := homalg_variable_l[2];;
gap> homalg_variable_3089 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3087 = homalg_variable_3089;
true
gap> homalg_variable_3090 := homalg_variable_3083 * homalg_variable_3088;;
gap> homalg_variable_3091 := homalg_variable_3081 + homalg_variable_3090;;
gap> homalg_variable_3087 = homalg_variable_3091;
true
gap> homalg_variable_3092 := SIH_DecideZeroColumns(homalg_variable_3081,homalg_variable_3083);;
gap> homalg_variable_3093 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3092 = homalg_variable_3093;
true
gap> homalg_variable_3094 := homalg_variable_3088 * (homalg_variable_8);;
gap> homalg_variable_3095 := homalg_variable_3084 * homalg_variable_3094;;
gap> homalg_variable_3096 := homalg_variable_3079 * homalg_variable_3095;;
gap> homalg_variable_3096 = homalg_variable_3081;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3079,homalg_variable_3081);; homalg_variable_3097 := homalg_variable_l[1];; homalg_variable_3098 := homalg_variable_l[2];;
gap> homalg_variable_3099 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3097 = homalg_variable_3099;
true
gap> homalg_variable_3100 := homalg_variable_3081 * homalg_variable_3098;;
gap> homalg_variable_3101 := homalg_variable_3079 + homalg_variable_3100;;
gap> homalg_variable_3097 = homalg_variable_3101;
true
gap> homalg_variable_3102 := SIH_DecideZeroColumns(homalg_variable_3079,homalg_variable_3081);;
gap> homalg_variable_3103 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3102 = homalg_variable_3103;
true
gap> homalg_variable_3104 := homalg_variable_3098 * (homalg_variable_8);;
gap> homalg_variable_3105 := homalg_variable_3081 * homalg_variable_3104;;
gap> homalg_variable_3105 = homalg_variable_3079;
true
gap> homalg_variable_3106 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_2442 = homalg_variable_3106;
false
gap> homalg_variable_3108 := SIH_Submatrix(homalg_variable_2442,[1..1],[ 5 ]);;
gap> homalg_variable_3109 := SIH_UnionOfColumns(homalg_variable_3108,homalg_variable_2755);;
gap> homalg_variable_3110 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3111 := SIH_UnionOfColumns(homalg_variable_3109,homalg_variable_3110);;
gap> homalg_variable_3107 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3111);;
gap> SI_ncols(homalg_variable_3107);
5
gap> homalg_variable_3112 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_3107 = homalg_variable_3112;
false
gap> homalg_variable_3113 := SI_\[(homalg_variable_3107,5,1);;
gap> SI_deg( homalg_variable_3113 );
-1
gap> homalg_variable_3114 := SI_\[(homalg_variable_3107,4,1);;
gap> SI_deg( homalg_variable_3114 );
-1
gap> homalg_variable_3115 := SI_\[(homalg_variable_3107,3,1);;
gap> SI_deg( homalg_variable_3115 );
-1
gap> homalg_variable_3116 := SI_\[(homalg_variable_3107,2,1);;
gap> SI_deg( homalg_variable_3116 );
-1
gap> homalg_variable_3117 := SI_\[(homalg_variable_3107,1,1);;
gap> SI_deg( homalg_variable_3117 );
0
gap> homalg_variable_3118 := SI_\[(homalg_variable_3107,1,1);;
gap> IsZero(homalg_variable_3118);
false
gap> homalg_variable_3119 := SI_\[(homalg_variable_3107,2,1);;
gap> IsZero(homalg_variable_3119);
true
gap> homalg_variable_3120 := SI_\[(homalg_variable_3107,3,1);;
gap> IsZero(homalg_variable_3120);
true
gap> homalg_variable_3121 := SI_\[(homalg_variable_3107,4,1);;
gap> IsZero(homalg_variable_3121);
true
gap> homalg_variable_3122 := SI_\[(homalg_variable_3107,5,1);;
gap> IsZero(homalg_variable_3122);
true
gap> homalg_variable_3123 := SI_\[(homalg_variable_3107,5,2);;
gap> SI_deg( homalg_variable_3123 );
-1
gap> homalg_variable_3124 := SI_\[(homalg_variable_3107,4,2);;
gap> SI_deg( homalg_variable_3124 );
-1
gap> homalg_variable_3125 := SI_\[(homalg_variable_3107,3,2);;
gap> SI_deg( homalg_variable_3125 );
-1
gap> homalg_variable_3126 := SI_\[(homalg_variable_3107,2,2);;
gap> SI_deg( homalg_variable_3126 );
0
gap> homalg_variable_3127 := SI_\[(homalg_variable_3107,2,2);;
gap> IsZero(homalg_variable_3127);
false
gap> homalg_variable_3128 := SI_\[(homalg_variable_3107,3,2);;
gap> IsZero(homalg_variable_3128);
true
gap> homalg_variable_3129 := SI_\[(homalg_variable_3107,4,2);;
gap> IsZero(homalg_variable_3129);
true
gap> homalg_variable_3130 := SI_\[(homalg_variable_3107,5,2);;
gap> IsZero(homalg_variable_3130);
true
gap> homalg_variable_3131 := SI_\[(homalg_variable_3107,5,3);;
gap> SI_deg( homalg_variable_3131 );
-1
gap> homalg_variable_3132 := SI_\[(homalg_variable_3107,4,3);;
gap> SI_deg( homalg_variable_3132 );
-1
gap> homalg_variable_3133 := SI_\[(homalg_variable_3107,3,3);;
gap> SI_deg( homalg_variable_3133 );
0
gap> homalg_variable_3134 := SI_\[(homalg_variable_3107,3,3);;
gap> IsZero(homalg_variable_3134);
false
gap> homalg_variable_3135 := SI_\[(homalg_variable_3107,4,3);;
gap> IsZero(homalg_variable_3135);
true
gap> homalg_variable_3136 := SI_\[(homalg_variable_3107,5,3);;
gap> IsZero(homalg_variable_3136);
true
gap> homalg_variable_3137 := SI_\[(homalg_variable_3107,5,4);;
gap> SI_deg( homalg_variable_3137 );
-1
gap> homalg_variable_3138 := SI_\[(homalg_variable_3107,4,4);;
gap> SI_deg( homalg_variable_3138 );
0
gap> homalg_variable_3139 := SI_\[(homalg_variable_3107,4,4);;
gap> IsZero(homalg_variable_3139);
false
gap> homalg_variable_3140 := SI_\[(homalg_variable_3107,5,4);;
gap> IsZero(homalg_variable_3140);
true
gap> homalg_variable_3141 := SI_\[(homalg_variable_3107,5,5);;
gap> SI_deg( homalg_variable_3141 );
0
gap> homalg_variable_3142 := SI_\[(homalg_variable_3107,5,5);;
gap> IsZero(homalg_variable_3142);
false
gap> homalg_variable_3143 := SIH_DecideZeroColumns(homalg_variable_2790,homalg_variable_2780);;
gap> homalg_variable_3144 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_3143 = homalg_variable_3144;
false
gap> homalg_variable_3145 := SIH_UnionOfColumns(homalg_variable_3143,homalg_variable_2780);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3145);; homalg_variable_3146 := homalg_variable_l[1];; homalg_variable_3147 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3146);
2
gap> homalg_variable_3148 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3146 = homalg_variable_3148;
false
gap> SI_nrows(homalg_variable_3147);
2
gap> homalg_variable_3149 := SIH_Submatrix(homalg_variable_3147,[ 1 ],[1..2]);;
gap> homalg_variable_3150 := homalg_variable_3143 * homalg_variable_3149;;
gap> homalg_variable_3151 := SIH_Submatrix(homalg_variable_3147,[ 2 ],[1..2]);;
gap> homalg_variable_3152 := homalg_variable_2780 * homalg_variable_3151;;
gap> homalg_variable_3153 := homalg_variable_3150 + homalg_variable_3152;;
gap> homalg_variable_3146 = homalg_variable_3153;
true
gap> homalg_variable_3155 := homalg_variable_1482 * (homalg_variable_8);;
gap> homalg_variable_3156 := homalg_variable_3155 * homalg_variable_2910;;
gap> homalg_variable_3154 := SIH_DecideZeroColumns(homalg_variable_3156,homalg_variable_2780);;
gap> homalg_variable_3157 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_3154 = homalg_variable_3157;
false
gap> homalg_variable_3158 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_3156 = homalg_variable_3158;
false
gap> homalg_variable_3146 = homalg_variable_813;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3154,homalg_variable_3146);; homalg_variable_3159 := homalg_variable_l[1];; homalg_variable_3160 := homalg_variable_l[2];;
gap> homalg_variable_3161 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_3159 = homalg_variable_3161;
true
gap> homalg_variable_3162 := homalg_variable_3146 * homalg_variable_3160;;
gap> homalg_variable_3163 := homalg_variable_3154 + homalg_variable_3162;;
gap> homalg_variable_3159 = homalg_variable_3163;
true
gap> homalg_variable_3164 := SIH_DecideZeroColumns(homalg_variable_3154,homalg_variable_3146);;
gap> homalg_variable_3165 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_3164 = homalg_variable_3165;
true
gap> homalg_variable_3167 := SIH_Submatrix(homalg_variable_3147,[ 1 ],[1..2]);;
gap> homalg_variable_3168 := homalg_variable_3160 * (homalg_variable_8);;
gap> homalg_variable_3169 := homalg_variable_3167 * homalg_variable_3168;;
gap> homalg_variable_3170 := homalg_variable_2790 * homalg_variable_3169;;
gap> homalg_variable_3171 := homalg_variable_3170 - homalg_variable_3156;;
gap> homalg_variable_3166 := SIH_DecideZeroColumns(homalg_variable_3171,homalg_variable_2780);;
gap> homalg_variable_3172 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_3166 = homalg_variable_3172;
true
gap> homalg_variable_3174 := SIH_Submatrix(homalg_variable_3155,[1..2],[ 8, 9, 10 ]);;
gap> homalg_variable_3175 := homalg_variable_3174 * homalg_variable_2902;;
gap> homalg_variable_3176 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_3177 := SIH_UnionOfColumns(homalg_variable_3175,homalg_variable_3176);;
gap> homalg_variable_3178 := SIH_UnionOfColumns(homalg_variable_3177,homalg_variable_2785);;
gap> homalg_variable_3173 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2790,homalg_variable_3178);;
gap> SI_ncols(homalg_variable_3173);
1
gap> homalg_variable_3179 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3173 = homalg_variable_3179;
true
gap> homalg_variable_3180 := SI_matrix(homalg_variable_5,4,10,"0");;
gap> homalg_variable_2344 = homalg_variable_3180;
false
gap> homalg_variable_3181 := SIH_DecideZeroColumns(homalg_variable_2831,homalg_variable_2823);;
gap> homalg_variable_3182 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_3181 = homalg_variable_3182;
false
gap> homalg_variable_3183 := SIH_UnionOfColumns(homalg_variable_3181,homalg_variable_2823);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3183);; homalg_variable_3184 := homalg_variable_l[1];; homalg_variable_3185 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3184);
4
gap> homalg_variable_3186 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3184 = homalg_variable_3186;
false
gap> SI_nrows(homalg_variable_3185);
4
gap> homalg_variable_3187 := SIH_Submatrix(homalg_variable_3185,[ 1, 2, 3 ],[1..4]);;
gap> homalg_variable_3188 := homalg_variable_3181 * homalg_variable_3187;;
gap> homalg_variable_3189 := SIH_Submatrix(homalg_variable_3185,[ 4 ],[1..4]);;
gap> homalg_variable_3190 := homalg_variable_2823 * homalg_variable_3189;;
gap> homalg_variable_3191 := homalg_variable_3188 + homalg_variable_3190;;
gap> homalg_variable_3184 = homalg_variable_3191;
true
gap> homalg_variable_3193 := homalg_variable_2344 * homalg_variable_2952;;
gap> homalg_variable_3194 := homalg_variable_2345 * homalg_variable_2952;;
gap> homalg_variable_3195 := SIH_UnionOfRows(homalg_variable_3193,homalg_variable_3194);;
gap> homalg_variable_3192 := SIH_DecideZeroColumns(homalg_variable_3195,homalg_variable_2823);;
gap> homalg_variable_3196 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3192 = homalg_variable_3196;
false
gap> homalg_variable_3197 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_3193 = homalg_variable_3197;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3192,homalg_variable_3184);; homalg_variable_3198 := homalg_variable_l[1];; homalg_variable_3199 := homalg_variable_l[2];;
gap> homalg_variable_3200 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3198 = homalg_variable_3200;
true
gap> homalg_variable_3201 := homalg_variable_3184 * homalg_variable_3199;;
gap> homalg_variable_3202 := homalg_variable_3192 + homalg_variable_3201;;
gap> homalg_variable_3198 = homalg_variable_3202;
true
gap> homalg_variable_3203 := SIH_DecideZeroColumns(homalg_variable_3192,homalg_variable_3184);;
gap> homalg_variable_3204 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3203 = homalg_variable_3204;
true
gap> homalg_variable_3206 := SIH_Submatrix(homalg_variable_3185,[ 1, 2, 3 ],[1..4]);;
gap> homalg_variable_3207 := homalg_variable_3199 * (homalg_variable_8);;
gap> homalg_variable_3208 := homalg_variable_3206 * homalg_variable_3207;;
gap> homalg_variable_3209 := homalg_variable_2831 * homalg_variable_3208;;
gap> homalg_variable_3210 := homalg_variable_3209 - homalg_variable_3195;;
gap> homalg_variable_3205 := SIH_DecideZeroColumns(homalg_variable_3210,homalg_variable_2823);;
gap> homalg_variable_3211 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3205 = homalg_variable_3211;
true
gap> homalg_variable_3213 := SIH_Submatrix(homalg_variable_2344,[1..4],[ 8, 9, 10 ]);;
gap> homalg_variable_3214 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_3215 := SIH_UnionOfColumns(homalg_variable_3213,homalg_variable_3214);;
gap> homalg_variable_3216 := SIH_Submatrix(homalg_variable_2345,[1..1],[ 8, 9, 10 ]);;
gap> homalg_variable_3217 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_3218 := SIH_UnionOfColumns(homalg_variable_3216,homalg_variable_3217);;
gap> homalg_variable_3219 := SIH_UnionOfRows(homalg_variable_3215,homalg_variable_3218);;
gap> homalg_variable_3220 := SIH_UnionOfColumns(homalg_variable_3219,homalg_variable_2826);;
gap> homalg_variable_3212 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2831,homalg_variable_3220);;
gap> SI_ncols(homalg_variable_3212);
1
gap> homalg_variable_3221 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3212 = homalg_variable_3221;
true
gap> homalg_variable_3222 := SI_matrix(homalg_variable_5,1,6,"0");;
gap> homalg_variable_2683 = homalg_variable_3222;
false
gap> homalg_variable_3223 := homalg_variable_2685 * (homalg_variable_8);;
gap> homalg_variable_3224 := homalg_variable_3223 * homalg_variable_2956;;
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3224,homalg_variable_2841);; homalg_variable_3225 := homalg_variable_l[1];; homalg_variable_3226 := homalg_variable_l[2];;
gap> homalg_variable_3227 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_3225 = homalg_variable_3227;
true
gap> homalg_variable_3228 := homalg_variable_2841 * homalg_variable_3226;;
gap> homalg_variable_3229 := homalg_variable_3224 + homalg_variable_3228;;
gap> homalg_variable_3225 = homalg_variable_3229;
true
gap> homalg_variable_3230 := SIH_DecideZeroColumns(homalg_variable_3224,homalg_variable_2841);;
gap> homalg_variable_3231 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_3230 = homalg_variable_3231;
true
gap> SI_nrows(homalg_variable_2842);
3
gap> SI_ncols(homalg_variable_2842);
3
gap> homalg_variable_3232 := homalg_variable_3226 * (homalg_variable_8);;
gap> homalg_variable_3233 := homalg_variable_2842 * homalg_variable_3232;;
gap> homalg_variable_3234 := homalg_variable_2835 * homalg_variable_3233;;
gap> homalg_variable_3235 := homalg_variable_3234 - homalg_variable_3224;;
gap> homalg_variable_3236 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_3235 = homalg_variable_3236;
true
gap> homalg_variable_3237 := SI_matrix(homalg_variable_5,7,14,"0");;
gap> homalg_variable_1409 = homalg_variable_3237;
false
gap> homalg_variable_3238 := SIH_DecideZeroColumns(homalg_variable_2910,homalg_variable_2900);;
gap> homalg_variable_3239 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_3238 = homalg_variable_3239;
false
gap> homalg_variable_3240 := SIH_UnionOfColumns(homalg_variable_3238,homalg_variable_2900);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3240);; homalg_variable_3241 := homalg_variable_l[1];; homalg_variable_3242 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3241);
8
gap> homalg_variable_3243 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_3241 = homalg_variable_3243;
false
gap> SI_nrows(homalg_variable_3242);
8
gap> homalg_variable_3244 := SIH_Submatrix(homalg_variable_3242,[ 1, 2, 3, 4, 5 ],[1..8]);;
gap> homalg_variable_3245 := homalg_variable_3238 * homalg_variable_3244;;
gap> homalg_variable_3246 := SIH_Submatrix(homalg_variable_3242,[ 6, 7, 8 ],[1..8]);;
gap> homalg_variable_3247 := homalg_variable_2900 * homalg_variable_3246;;
gap> homalg_variable_3248 := homalg_variable_3245 + homalg_variable_3247;;
gap> homalg_variable_3241 = homalg_variable_3248;
true
gap> homalg_variable_3250 := homalg_variable_1411 * (homalg_variable_8);;
gap> homalg_variable_3251 := homalg_variable_3250 * homalg_variable_3034;;
gap> homalg_variable_3249 := SIH_DecideZeroColumns(homalg_variable_3251,homalg_variable_2900);;
gap> homalg_variable_3252 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_3249 = homalg_variable_3252;
false
gap> homalg_variable_3253 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_3251 = homalg_variable_3253;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3249,homalg_variable_3241);; homalg_variable_3254 := homalg_variable_l[1];; homalg_variable_3255 := homalg_variable_l[2];;
gap> homalg_variable_3256 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_3254 = homalg_variable_3256;
true
gap> homalg_variable_3257 := homalg_variable_3241 * homalg_variable_3255;;
gap> homalg_variable_3258 := homalg_variable_3249 + homalg_variable_3257;;
gap> homalg_variable_3254 = homalg_variable_3258;
true
gap> homalg_variable_3259 := SIH_DecideZeroColumns(homalg_variable_3249,homalg_variable_3241);;
gap> homalg_variable_3260 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_3259 = homalg_variable_3260;
true
gap> homalg_variable_3262 := SIH_Submatrix(homalg_variable_3242,[ 1, 2, 3, 4, 5 ],[1..8]);;
gap> homalg_variable_3263 := homalg_variable_3255 * (homalg_variable_8);;
gap> homalg_variable_3264 := homalg_variable_3262 * homalg_variable_3263;;
gap> homalg_variable_3265 := homalg_variable_2910 * homalg_variable_3264;;
gap> homalg_variable_3266 := homalg_variable_3265 - homalg_variable_3251;;
gap> homalg_variable_3261 := SIH_DecideZeroColumns(homalg_variable_3266,homalg_variable_2900);;
gap> homalg_variable_3267 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_3261 = homalg_variable_3267;
true
gap> homalg_variable_3269 := SIH_Submatrix(homalg_variable_3250,[1..10],[ 10, 11, 12, 13, 14 ]);;
gap> homalg_variable_3270 := homalg_variable_3269 * homalg_variable_3026;;
gap> homalg_variable_3271 := SI_matrix(homalg_variable_5,10,3,"0");;
gap> homalg_variable_3272 := SIH_UnionOfColumns(homalg_variable_3270,homalg_variable_3271);;
gap> homalg_variable_3273 := SIH_UnionOfColumns(homalg_variable_3272,homalg_variable_2905);;
gap> homalg_variable_3268 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2910,homalg_variable_3273);;
gap> SI_ncols(homalg_variable_3268);
1
gap> homalg_variable_3274 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_3268 = homalg_variable_3274;
true
gap> homalg_variable_3275 := SI_matrix(homalg_variable_5,7,10,"0");;
gap> homalg_variable_2227 = homalg_variable_3275;
false
gap> homalg_variable_3276 := SIH_DecideZeroColumns(homalg_variable_2952,homalg_variable_2943);;
gap> homalg_variable_3277 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_3276 = homalg_variable_3277;
false
gap> homalg_variable_3278 := SIH_UnionOfColumns(homalg_variable_3276,homalg_variable_2943);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3278);; homalg_variable_3279 := homalg_variable_l[1];; homalg_variable_3280 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3279);
7
gap> homalg_variable_3281 := SI_matrix(homalg_variable_5,10,7,"0");;
gap> homalg_variable_3279 = homalg_variable_3281;
false
gap> SI_nrows(homalg_variable_3280);
7
gap> homalg_variable_3282 := SIH_Submatrix(homalg_variable_3280,[ 1, 2, 3, 4 ],[1..7]);;
gap> homalg_variable_3283 := homalg_variable_3276 * homalg_variable_3282;;
gap> homalg_variable_3284 := SIH_Submatrix(homalg_variable_3280,[ 5, 6, 7 ],[1..7]);;
gap> homalg_variable_3285 := homalg_variable_2943 * homalg_variable_3284;;
gap> homalg_variable_3286 := homalg_variable_3283 + homalg_variable_3285;;
gap> homalg_variable_3279 = homalg_variable_3286;
true
gap> homalg_variable_3288 := homalg_variable_2227 * homalg_variable_3075;;
gap> homalg_variable_3289 := homalg_variable_2228 * homalg_variable_3075;;
gap> homalg_variable_3290 := SIH_UnionOfRows(homalg_variable_3288,homalg_variable_3289);;
gap> homalg_variable_3287 := SIH_DecideZeroColumns(homalg_variable_3290,homalg_variable_2943);;
gap> homalg_variable_3291 := SI_matrix(homalg_variable_5,10,2,"0");;
gap> homalg_variable_3287 = homalg_variable_3291;
false
gap> homalg_variable_3292 := SI_matrix(homalg_variable_5,7,2,"0");;
gap> homalg_variable_3288 = homalg_variable_3292;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3287,homalg_variable_3279);; homalg_variable_3293 := homalg_variable_l[1];; homalg_variable_3294 := homalg_variable_l[2];;
gap> homalg_variable_3295 := SI_matrix(homalg_variable_5,10,2,"0");;
gap> homalg_variable_3293 = homalg_variable_3295;
true
gap> homalg_variable_3296 := homalg_variable_3279 * homalg_variable_3294;;
gap> homalg_variable_3297 := homalg_variable_3287 + homalg_variable_3296;;
gap> homalg_variable_3293 = homalg_variable_3297;
true
gap> homalg_variable_3298 := SIH_DecideZeroColumns(homalg_variable_3287,homalg_variable_3279);;
gap> homalg_variable_3299 := SI_matrix(homalg_variable_5,10,2,"0");;
gap> homalg_variable_3298 = homalg_variable_3299;
true
gap> homalg_variable_3301 := SIH_Submatrix(homalg_variable_3280,[ 1, 2, 3, 4 ],[1..7]);;
gap> homalg_variable_3302 := homalg_variable_3294 * (homalg_variable_8);;
gap> homalg_variable_3303 := homalg_variable_3301 * homalg_variable_3302;;
gap> homalg_variable_3304 := homalg_variable_2952 * homalg_variable_3303;;
gap> homalg_variable_3305 := homalg_variable_3304 - homalg_variable_3290;;
gap> homalg_variable_3300 := SIH_DecideZeroColumns(homalg_variable_3305,homalg_variable_2943);;
gap> homalg_variable_3306 := SI_matrix(homalg_variable_5,10,2,"0");;
gap> homalg_variable_3300 = homalg_variable_3306;
true
gap> homalg_variable_3308 := SIH_Submatrix(homalg_variable_2227,[1..7],[ 8, 9, 10 ]);;
gap> homalg_variable_3309 := SI_matrix(homalg_variable_5,7,1,"0");;
gap> homalg_variable_3310 := SIH_UnionOfColumns(homalg_variable_3308,homalg_variable_3309);;
gap> homalg_variable_3311 := SIH_Submatrix(homalg_variable_2228,[1..3],[ 8, 9, 10 ]);;
gap> homalg_variable_3312 := SIH_UnionOfColumns(homalg_variable_3311,homalg_variable_2497);;
gap> homalg_variable_3313 := SIH_UnionOfRows(homalg_variable_3310,homalg_variable_3312);;
gap> homalg_variable_3314 := SIH_UnionOfColumns(homalg_variable_3313,homalg_variable_2947);;
gap> homalg_variable_3307 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_2952,homalg_variable_3314);;
gap> SI_ncols(homalg_variable_3307);
1
gap> homalg_variable_3315 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3307 = homalg_variable_3315;
true
gap> homalg_variable_3316 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_2581 = homalg_variable_3316;
false
gap> homalg_variable_3317 := homalg_variable_2583 * (homalg_variable_8);;
gap> homalg_variable_3318 := homalg_variable_3317 * homalg_variable_3079;;
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3318,homalg_variable_2962);; homalg_variable_3319 := homalg_variable_l[1];; homalg_variable_3320 := homalg_variable_l[2];;
gap> homalg_variable_3321 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_3319 = homalg_variable_3321;
true
gap> homalg_variable_3322 := homalg_variable_2962 * homalg_variable_3320;;
gap> homalg_variable_3323 := homalg_variable_3318 + homalg_variable_3322;;
gap> homalg_variable_3319 = homalg_variable_3323;
true
gap> homalg_variable_3324 := SIH_DecideZeroColumns(homalg_variable_3318,homalg_variable_2962);;
gap> homalg_variable_3325 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_3324 = homalg_variable_3325;
true
gap> SI_nrows(homalg_variable_2963);
3
gap> SI_ncols(homalg_variable_2963);
3
gap> homalg_variable_3326 := homalg_variable_3320 * (homalg_variable_8);;
gap> homalg_variable_3327 := homalg_variable_2963 * homalg_variable_3326;;
gap> homalg_variable_3328 := homalg_variable_2956 * homalg_variable_3327;;
gap> homalg_variable_3329 := homalg_variable_3328 - homalg_variable_3318;;
gap> homalg_variable_3330 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_3329 = homalg_variable_3330;
true
gap> homalg_variable_3332 := homalg_variable_2442 * homalg_variable_2831;;
gap> homalg_variable_3331 := SIH_BasisOfColumnModule(homalg_variable_3332);;
gap> SI_ncols(homalg_variable_3331);
3
gap> homalg_variable_3333 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_3331 = homalg_variable_3333;
false
gap> homalg_variable_3331 = homalg_variable_3332;
false
gap> homalg_variable_3334 := SIH_DecideZeroColumns(homalg_variable_237,homalg_variable_3331);;
gap> homalg_variable_3335 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3334 = homalg_variable_3335;
false
gap> homalg_variable_3337 := homalg_variable_2682 * (homalg_variable_8);;
gap> homalg_variable_3338 := homalg_variable_3337 * homalg_variable_2835;;
gap> homalg_variable_3336 := SIH_BasisOfColumnModule(homalg_variable_3338);;
gap> SI_ncols(homalg_variable_3336);
3
gap> homalg_variable_3339 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_3336 = homalg_variable_3339;
false
gap> homalg_variable_3336 = homalg_variable_3338;
false
gap> homalg_variable_3340 := SIH_DecideZeroColumns(homalg_variable_237,homalg_variable_3336);;
gap> homalg_variable_3341 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3340 = homalg_variable_3341;
false
gap> homalg_variable_3342 := SIH_BasisOfColumnModule(homalg_variable_3169);;
gap> SI_ncols(homalg_variable_3342);
2
gap> homalg_variable_3343 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_3342 = homalg_variable_3343;
false
gap> homalg_variable_3344 := SIH_DecideZeroColumns(homalg_variable_237,homalg_variable_3342);;
gap> homalg_variable_3345 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3344 = homalg_variable_3345;
false
gap> homalg_variable_3346 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3332);;
gap> SI_ncols(homalg_variable_3346);
3
gap> homalg_variable_3347 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3346 = homalg_variable_3347;
false
gap> homalg_variable_3348 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3346);;
gap> SI_ncols(homalg_variable_3348);
1
gap> homalg_variable_3349 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3348 = homalg_variable_3349;
false
gap> homalg_variable_3350 := SI_\[(homalg_variable_3348,3,1);;
gap> SI_deg( homalg_variable_3350 );
1
gap> homalg_variable_3351 := SI_\[(homalg_variable_3348,2,1);;
gap> SI_deg( homalg_variable_3351 );
1
gap> homalg_variable_3352 := SI_\[(homalg_variable_3348,1,1);;
gap> SI_deg( homalg_variable_3352 );
2
gap> homalg_variable_3353 := SIH_BasisOfColumnModule(homalg_variable_3346);;
gap> SI_ncols(homalg_variable_3353);
3
gap> homalg_variable_3354 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3353 = homalg_variable_3354;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3346);; homalg_variable_3355 := homalg_variable_l[1];; homalg_variable_3356 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3355);
3
gap> homalg_variable_3357 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3355 = homalg_variable_3357;
false
gap> SI_nrows(homalg_variable_3356);
3
gap> homalg_variable_3358 := homalg_variable_3346 * homalg_variable_3356;;
gap> homalg_variable_3355 = homalg_variable_3358;
true
gap> homalg_variable_3355 = homalg_variable_1367;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3353,homalg_variable_3355);; homalg_variable_3359 := homalg_variable_l[1];; homalg_variable_3360 := homalg_variable_l[2];;
gap> homalg_variable_3361 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3359 = homalg_variable_3361;
true
gap> homalg_variable_3362 := homalg_variable_3355 * homalg_variable_3360;;
gap> homalg_variable_3363 := homalg_variable_3353 + homalg_variable_3362;;
gap> homalg_variable_3359 = homalg_variable_3363;
true
gap> homalg_variable_3364 := SIH_DecideZeroColumns(homalg_variable_3353,homalg_variable_3355);;
gap> homalg_variable_3365 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3364 = homalg_variable_3365;
true
gap> homalg_variable_3366 := homalg_variable_3360 * (homalg_variable_8);;
gap> homalg_variable_3367 := homalg_variable_3356 * homalg_variable_3366;;
gap> homalg_variable_3368 := homalg_variable_3346 * homalg_variable_3367;;
gap> homalg_variable_3368 = homalg_variable_3353;
true
gap> homalg_variable_3353 = homalg_variable_1367;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3346,homalg_variable_3353);; homalg_variable_3369 := homalg_variable_l[1];; homalg_variable_3370 := homalg_variable_l[2];;
gap> homalg_variable_3371 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3369 = homalg_variable_3371;
true
gap> homalg_variable_3372 := homalg_variable_3353 * homalg_variable_3370;;
gap> homalg_variable_3373 := homalg_variable_3346 + homalg_variable_3372;;
gap> homalg_variable_3369 = homalg_variable_3373;
true
gap> homalg_variable_3374 := SIH_DecideZeroColumns(homalg_variable_3346,homalg_variable_3353);;
gap> homalg_variable_3375 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3374 = homalg_variable_3375;
true
gap> homalg_variable_3376 := homalg_variable_3370 * (homalg_variable_8);;
gap> homalg_variable_3377 := homalg_variable_3353 * homalg_variable_3376;;
gap> homalg_variable_3377 = homalg_variable_3346;
true
gap> homalg_variable_3378 := SIH_BasisOfColumnModule(homalg_variable_3208);;
gap> SI_ncols(homalg_variable_3378);
4
gap> homalg_variable_3379 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_3378 = homalg_variable_3379;
false
gap> homalg_variable_3378 = homalg_variable_3208;
false
gap> homalg_variable_3380 := SIH_DecideZeroColumns(homalg_variable_3346,homalg_variable_3378);;
gap> homalg_variable_3381 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3380 = homalg_variable_3381;
false
gap> SIH_ZeroColumns(homalg_variable_3380);
[ 1, 2 ]
gap> homalg_variable_3383 := SIH_Submatrix(homalg_variable_3380,[1..3],[ 3 ]);;
gap> homalg_variable_3382 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3383,homalg_variable_3378);;
gap> SI_ncols(homalg_variable_3382);
2
gap> homalg_variable_3384 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_3382 = homalg_variable_3384;
false
gap> homalg_variable_3386 := homalg_variable_3383 * homalg_variable_3382;;
gap> homalg_variable_3385 := SIH_DecideZeroColumns(homalg_variable_3386,homalg_variable_3378);;
gap> homalg_variable_3387 := SI_matrix(homalg_variable_5,3,2,"0");;
gap> homalg_variable_3385 = homalg_variable_3387;
true
gap> homalg_variable_3388 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3383,homalg_variable_3378);;
gap> SI_ncols(homalg_variable_3388);
2
gap> homalg_variable_3389 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_3388 = homalg_variable_3389;
false
gap> homalg_variable_3390 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3388);;
gap> SI_ncols(homalg_variable_3390);
1
gap> homalg_variable_3391 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_3390 = homalg_variable_3391;
false
gap> homalg_variable_3392 := SI_\[(homalg_variable_3390,2,1);;
gap> SI_deg( homalg_variable_3392 );
1
gap> homalg_variable_3393 := SI_\[(homalg_variable_3390,1,1);;
gap> SI_deg( homalg_variable_3393 );
1
gap> homalg_variable_3394 := SIH_BasisOfColumnModule(homalg_variable_3388);;
gap> SI_ncols(homalg_variable_3394);
2
gap> homalg_variable_3395 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_3394 = homalg_variable_3395;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3388);; homalg_variable_3396 := homalg_variable_l[1];; homalg_variable_3397 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3396);
2
gap> homalg_variable_3398 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_3396 = homalg_variable_3398;
false
gap> SI_nrows(homalg_variable_3397);
2
gap> homalg_variable_3399 := homalg_variable_3388 * homalg_variable_3397;;
gap> homalg_variable_3396 = homalg_variable_3399;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3394,homalg_variable_3396);; homalg_variable_3400 := homalg_variable_l[1];; homalg_variable_3401 := homalg_variable_l[2];;
gap> homalg_variable_3402 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_3400 = homalg_variable_3402;
true
gap> homalg_variable_3403 := homalg_variable_3396 * homalg_variable_3401;;
gap> homalg_variable_3404 := homalg_variable_3394 + homalg_variable_3403;;
gap> homalg_variable_3400 = homalg_variable_3404;
true
gap> homalg_variable_3405 := SIH_DecideZeroColumns(homalg_variable_3394,homalg_variable_3396);;
gap> homalg_variable_3406 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_3405 = homalg_variable_3406;
true
gap> homalg_variable_3407 := homalg_variable_3401 * (homalg_variable_8);;
gap> homalg_variable_3408 := homalg_variable_3397 * homalg_variable_3407;;
gap> homalg_variable_3409 := homalg_variable_3388 * homalg_variable_3408;;
gap> homalg_variable_3409 = homalg_variable_3394;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3388,homalg_variable_3394);; homalg_variable_3410 := homalg_variable_l[1];; homalg_variable_3411 := homalg_variable_l[2];;
gap> homalg_variable_3412 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_3410 = homalg_variable_3412;
true
gap> homalg_variable_3413 := homalg_variable_3394 * homalg_variable_3411;;
gap> homalg_variable_3414 := homalg_variable_3388 + homalg_variable_3413;;
gap> homalg_variable_3410 = homalg_variable_3414;
true
gap> homalg_variable_3415 := SIH_DecideZeroColumns(homalg_variable_3388,homalg_variable_3394);;
gap> homalg_variable_3416 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_3415 = homalg_variable_3416;
true
gap> homalg_variable_3417 := homalg_variable_3411 * (homalg_variable_8);;
gap> homalg_variable_3418 := homalg_variable_3394 * homalg_variable_3417;;
gap> homalg_variable_3418 = homalg_variable_3388;
true
gap> homalg_variable_3419 := SIH_BasisOfColumnModule(homalg_variable_3382);;
gap> SI_ncols(homalg_variable_3419);
2
gap> homalg_variable_3420 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_3419 = homalg_variable_3420;
false
gap> homalg_variable_3419 = homalg_variable_3382;
true
gap> homalg_variable_3421 := SIH_DecideZeroColumns(homalg_variable_3388,homalg_variable_3419);;
gap> homalg_variable_3422 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_3421 = homalg_variable_3422;
true
gap> homalg_variable_3423 := SIH_DecideZeroColumns(homalg_variable_237,homalg_variable_3419);;
gap> homalg_variable_3424 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3423 = homalg_variable_3424;
false
gap> homalg_variable_3425 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3338);;
gap> SI_ncols(homalg_variable_3425);
3
gap> homalg_variable_3426 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3425 = homalg_variable_3426;
false
gap> homalg_variable_3427 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3425);;
gap> SI_ncols(homalg_variable_3427);
1
gap> homalg_variable_3428 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3427 = homalg_variable_3428;
false
gap> homalg_variable_3429 := SI_\[(homalg_variable_3427,3,1);;
gap> SI_deg( homalg_variable_3429 );
1
gap> homalg_variable_3430 := SI_\[(homalg_variable_3427,2,1);;
gap> SI_deg( homalg_variable_3430 );
1
gap> homalg_variable_3431 := SI_\[(homalg_variable_3427,1,1);;
gap> SI_deg( homalg_variable_3431 );
1
gap> homalg_variable_3432 := SIH_BasisOfColumnModule(homalg_variable_3425);;
gap> SI_ncols(homalg_variable_3432);
3
gap> homalg_variable_3433 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3432 = homalg_variable_3433;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3425);; homalg_variable_3434 := homalg_variable_l[1];; homalg_variable_3435 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3434);
3
gap> homalg_variable_3436 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3434 = homalg_variable_3436;
false
gap> SI_nrows(homalg_variable_3435);
3
gap> homalg_variable_3437 := homalg_variable_3425 * homalg_variable_3435;;
gap> homalg_variable_3434 = homalg_variable_3437;
true
gap> homalg_variable_3434 = homalg_variable_1367;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3432,homalg_variable_3434);; homalg_variable_3438 := homalg_variable_l[1];; homalg_variable_3439 := homalg_variable_l[2];;
gap> homalg_variable_3440 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3438 = homalg_variable_3440;
true
gap> homalg_variable_3441 := homalg_variable_3434 * homalg_variable_3439;;
gap> homalg_variable_3442 := homalg_variable_3432 + homalg_variable_3441;;
gap> homalg_variable_3438 = homalg_variable_3442;
true
gap> homalg_variable_3443 := SIH_DecideZeroColumns(homalg_variable_3432,homalg_variable_3434);;
gap> homalg_variable_3444 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3443 = homalg_variable_3444;
true
gap> homalg_variable_3445 := homalg_variable_3439 * (homalg_variable_8);;
gap> homalg_variable_3446 := homalg_variable_3435 * homalg_variable_3445;;
gap> homalg_variable_3447 := homalg_variable_3425 * homalg_variable_3446;;
gap> homalg_variable_3447 = homalg_variable_3432;
true
gap> homalg_variable_3432 = homalg_variable_1367;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3425,homalg_variable_3432);; homalg_variable_3448 := homalg_variable_l[1];; homalg_variable_3449 := homalg_variable_l[2];;
gap> homalg_variable_3450 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3448 = homalg_variable_3450;
true
gap> homalg_variable_3451 := homalg_variable_3432 * homalg_variable_3449;;
gap> homalg_variable_3452 := homalg_variable_3425 + homalg_variable_3451;;
gap> homalg_variable_3448 = homalg_variable_3452;
true
gap> homalg_variable_3453 := SIH_DecideZeroColumns(homalg_variable_3425,homalg_variable_3432);;
gap> homalg_variable_3454 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3453 = homalg_variable_3454;
true
gap> homalg_variable_3455 := homalg_variable_3449 * (homalg_variable_8);;
gap> homalg_variable_3456 := homalg_variable_3432 * homalg_variable_3455;;
gap> homalg_variable_3456 = homalg_variable_3425;
true
gap> homalg_variable_3457 := SIH_BasisOfColumnModule(homalg_variable_3233);;
gap> SI_ncols(homalg_variable_3457);
3
gap> homalg_variable_3458 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3457 = homalg_variable_3458;
false
gap> homalg_variable_3457 = homalg_variable_3233;
false
gap> homalg_variable_3459 := SIH_DecideZeroColumns(homalg_variable_3425,homalg_variable_3457);;
gap> homalg_variable_3460 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_3459 = homalg_variable_3460;
true
gap> homalg_variable_3461 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3169);;
gap> SI_ncols(homalg_variable_3461);
4
gap> homalg_variable_3462 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3461 = homalg_variable_3462;
false
gap> homalg_variable_3463 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3461);;
gap> SI_ncols(homalg_variable_3463);
1
gap> homalg_variable_3464 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3463 = homalg_variable_3464;
true
gap> homalg_variable_3465 := SIH_BasisOfColumnModule(homalg_variable_3461);;
gap> SI_ncols(homalg_variable_3465);
4
gap> homalg_variable_3466 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3465 = homalg_variable_3466;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3461);; homalg_variable_3467 := homalg_variable_l[1];; homalg_variable_3468 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3467);
4
gap> homalg_variable_3469 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3467 = homalg_variable_3469;
false
gap> SI_nrows(homalg_variable_3468);
4
gap> homalg_variable_3470 := homalg_variable_3461 * homalg_variable_3468;;
gap> homalg_variable_3467 = homalg_variable_3470;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3465,homalg_variable_3467);; homalg_variable_3471 := homalg_variable_l[1];; homalg_variable_3472 := homalg_variable_l[2];;
gap> homalg_variable_3473 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3471 = homalg_variable_3473;
true
gap> homalg_variable_3474 := homalg_variable_3467 * homalg_variable_3472;;
gap> homalg_variable_3475 := homalg_variable_3465 + homalg_variable_3474;;
gap> homalg_variable_3471 = homalg_variable_3475;
true
gap> homalg_variable_3476 := SIH_DecideZeroColumns(homalg_variable_3465,homalg_variable_3467);;
gap> homalg_variable_3477 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3476 = homalg_variable_3477;
true
gap> homalg_variable_3478 := homalg_variable_3472 * (homalg_variable_8);;
gap> homalg_variable_3479 := homalg_variable_3468 * homalg_variable_3478;;
gap> homalg_variable_3480 := homalg_variable_3461 * homalg_variable_3479;;
gap> homalg_variable_3480 = homalg_variable_3465;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3461,homalg_variable_3465);; homalg_variable_3481 := homalg_variable_l[1];; homalg_variable_3482 := homalg_variable_l[2];;
gap> homalg_variable_3483 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3481 = homalg_variable_3483;
true
gap> homalg_variable_3484 := homalg_variable_3465 * homalg_variable_3482;;
gap> homalg_variable_3485 := homalg_variable_3461 + homalg_variable_3484;;
gap> homalg_variable_3481 = homalg_variable_3485;
true
gap> homalg_variable_3486 := SIH_DecideZeroColumns(homalg_variable_3461,homalg_variable_3465);;
gap> homalg_variable_3487 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3486 = homalg_variable_3487;
true
gap> homalg_variable_3488 := homalg_variable_3482 * (homalg_variable_8);;
gap> homalg_variable_3489 := homalg_variable_3465 * homalg_variable_3488;;
gap> homalg_variable_3489 = homalg_variable_3461;
true
gap> homalg_variable_3490 := SIH_BasisOfColumnModule(homalg_variable_3264);;
gap> SI_ncols(homalg_variable_3490);
4
gap> homalg_variable_3491 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3490 = homalg_variable_3491;
false
gap> homalg_variable_3490 = homalg_variable_3264;
false
gap> homalg_variable_3492 := SIH_DecideZeroColumns(homalg_variable_3461,homalg_variable_3490);;
gap> homalg_variable_3493 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3492 = homalg_variable_3493;
false
gap> SIH_ZeroColumns(homalg_variable_3492);
[ 2, 4 ]
gap> homalg_variable_3495 := SIH_Submatrix(homalg_variable_3492,[1..5],[ 1, 3 ]);;
gap> homalg_variable_3494 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3495,homalg_variable_3490);;
gap> SI_ncols(homalg_variable_3494);
2
gap> homalg_variable_3496 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3494 = homalg_variable_3496;
false
gap> homalg_variable_3498 := homalg_variable_3495 * homalg_variable_3494;;
gap> homalg_variable_3497 := SIH_DecideZeroColumns(homalg_variable_3498,homalg_variable_3490);;
gap> homalg_variable_3499 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_3497 = homalg_variable_3499;
true
gap> homalg_variable_3500 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3495,homalg_variable_3490);;
gap> SI_ncols(homalg_variable_3500);
2
gap> for _del in [ "homalg_variable_2992", "homalg_variable_2993", "homalg_variable_2994", "homalg_variable_2996", "homalg_variable_2997", "homalg_variable_2998", "homalg_variable_3000", "homalg_variable_3003", "homalg_variable_3004", "homalg_variable_3005", "homalg_variable_3006", "homalg_variable_3007", "homalg_variable_3008", "homalg_variable_3009", "homalg_variable_3010", "homalg_variable_3011", "homalg_variable_3012", "homalg_variable_3013", "homalg_variable_3014", "homalg_variable_3017", "homalg_variable_3018", "homalg_variable_3019", "homalg_variable_3021", "homalg_variable_3023", "homalg_variable_3030", "homalg_variable_3032", "homalg_variable_3033", "homalg_variable_3035", "homalg_variable_3036", "homalg_variable_3037", "homalg_variable_3039", "homalg_variable_3040", "homalg_variable_3041", "homalg_variable_3043", "homalg_variable_3046", "homalg_variable_3047", "homalg_variable_3048", "homalg_variable_3049", "homalg_variable_3050", "homalg_variable_3051", "homalg_variable_3052", "homalg_variable_3053", "homalg_variable_3054", "homalg_variable_3055", "homalg_variable_3056", "homalg_variable_3057", "homalg_variable_3061", "homalg_variable_3062", "homalg_variable_3063", "homalg_variable_3064", "homalg_variable_3066", "homalg_variable_3071", "homalg_variable_3073", "homalg_variable_3077", "homalg_variable_3078", "homalg_variable_3080", "homalg_variable_3082", "homalg_variable_3085", "homalg_variable_3086", "homalg_variable_3089", "homalg_variable_3091", "homalg_variable_3096", "homalg_variable_3097", "homalg_variable_3098", "homalg_variable_3099", "homalg_variable_3100", "homalg_variable_3101", "homalg_variable_3102", "homalg_variable_3103", "homalg_variable_3104", "homalg_variable_3105", "homalg_variable_3106", "homalg_variable_3112", "homalg_variable_3113", "homalg_variable_3114", "homalg_variable_3115", "homalg_variable_3116", "homalg_variable_3117", "homalg_variable_3118", "homalg_variable_3119", "homalg_variable_3120", "homalg_variable_3121", "homalg_variable_3122", "homalg_variable_3123", "homalg_variable_3124", "homalg_variable_3125", "homalg_variable_3126", "homalg_variable_3127", "homalg_variable_3128", "homalg_variable_3129", "homalg_variable_3130", "homalg_variable_3131", "homalg_variable_3132", "homalg_variable_3133", "homalg_variable_3134", "homalg_variable_3135", "homalg_variable_3136", "homalg_variable_3137", "homalg_variable_3139", "homalg_variable_3140", "homalg_variable_3141", "homalg_variable_3142", "homalg_variable_3143", "homalg_variable_3144", "homalg_variable_3145", "homalg_variable_3146", "homalg_variable_3148", "homalg_variable_3149", "homalg_variable_3150", "homalg_variable_3151", "homalg_variable_3152", "homalg_variable_3153", "homalg_variable_3154", "homalg_variable_3156", "homalg_variable_3157", "homalg_variable_3158", "homalg_variable_3159", "homalg_variable_3161", "homalg_variable_3162", "homalg_variable_3163", "homalg_variable_3164", "homalg_variable_3165", "homalg_variable_3166", "homalg_variable_3170", "homalg_variable_3171", "homalg_variable_3172", "homalg_variable_3173", "homalg_variable_3179", "homalg_variable_3180", "homalg_variable_3181", "homalg_variable_3182", "homalg_variable_3183", "homalg_variable_3184", "homalg_variable_3186", "homalg_variable_3187", "homalg_variable_3188", "homalg_variable_3189", "homalg_variable_3190", "homalg_variable_3191", "homalg_variable_3192", "homalg_variable_3196", "homalg_variable_3197", "homalg_variable_3198", "homalg_variable_3200", "homalg_variable_3201", "homalg_variable_3202", "homalg_variable_3203", "homalg_variable_3204", "homalg_variable_3205", "homalg_variable_3209", "homalg_variable_3210", "homalg_variable_3211", "homalg_variable_3212", "homalg_variable_3221", "homalg_variable_3222", "homalg_variable_3225", "homalg_variable_3227", "homalg_variable_3228", "homalg_variable_3229", "homalg_variable_3230", "homalg_variable_3231", "homalg_variable_3234", "homalg_variable_3235", "homalg_variable_3236", "homalg_variable_3237", "homalg_variable_3238", "homalg_variable_3239", "homalg_variable_3240", "homalg_variable_3241", "homalg_variable_3243", "homalg_variable_3244", "homalg_variable_3245", "homalg_variable_3246", "homalg_variable_3247", "homalg_variable_3248", "homalg_variable_3249", "homalg_variable_3252", "homalg_variable_3253", "homalg_variable_3254", "homalg_variable_3256", "homalg_variable_3257", "homalg_variable_3258", "homalg_variable_3259", "homalg_variable_3260", "homalg_variable_3261", "homalg_variable_3265", "homalg_variable_3266", "homalg_variable_3267", "homalg_variable_3268", "homalg_variable_3274", "homalg_variable_3275", "homalg_variable_3277", "homalg_variable_3282", "homalg_variable_3283", "homalg_variable_3284", "homalg_variable_3285", "homalg_variable_3286", "homalg_variable_3291", "homalg_variable_3292", "homalg_variable_3295", "homalg_variable_3296", "homalg_variable_3297", "homalg_variable_3298", "homalg_variable_3299", "homalg_variable_3300", "homalg_variable_3304", "homalg_variable_3305", "homalg_variable_3306", "homalg_variable_3307", "homalg_variable_3315", "homalg_variable_3316", "homalg_variable_3319", "homalg_variable_3321", "homalg_variable_3322", "homalg_variable_3323", "homalg_variable_3324", "homalg_variable_3325", "homalg_variable_3328", "homalg_variable_3329", "homalg_variable_3330", "homalg_variable_3333", "homalg_variable_3334", "homalg_variable_3335", "homalg_variable_3339", "homalg_variable_3340", "homalg_variable_3341", "homalg_variable_3343", "homalg_variable_3344", "homalg_variable_3345", "homalg_variable_3347", "homalg_variable_3349", "homalg_variable_3350", "homalg_variable_3351", "homalg_variable_3352", "homalg_variable_3354", "homalg_variable_3357", "homalg_variable_3358", "homalg_variable_3359", "homalg_variable_3360", "homalg_variable_3361", "homalg_variable_3362", "homalg_variable_3363", "homalg_variable_3364", "homalg_variable_3365", "homalg_variable_3366", "homalg_variable_3367", "homalg_variable_3368", "homalg_variable_3369", "homalg_variable_3370", "homalg_variable_3371", "homalg_variable_3372", "homalg_variable_3373", "homalg_variable_3374", "homalg_variable_3375", "homalg_variable_3376", "homalg_variable_3377", "homalg_variable_3379", "homalg_variable_3381", "homalg_variable_3382", "homalg_variable_3384", "homalg_variable_3385", "homalg_variable_3386", "homalg_variable_3387", "homalg_variable_3389", "homalg_variable_3391", "homalg_variable_3392", "homalg_variable_3393", "homalg_variable_3395", "homalg_variable_3398", "homalg_variable_3399", "homalg_variable_3400", "homalg_variable_3401", "homalg_variable_3402", "homalg_variable_3403", "homalg_variable_3404", "homalg_variable_3405", "homalg_variable_3406", "homalg_variable_3407", "homalg_variable_3408", "homalg_variable_3409", "homalg_variable_3410", "homalg_variable_3411", "homalg_variable_3412", "homalg_variable_3413", "homalg_variable_3414", "homalg_variable_3415", "homalg_variable_3416", "homalg_variable_3417", "homalg_variable_3418", "homalg_variable_3420", "homalg_variable_3423", "homalg_variable_3424", "homalg_variable_3426", "homalg_variable_3428", "homalg_variable_3429", "homalg_variable_3430", "homalg_variable_3431", "homalg_variable_3433", "homalg_variable_3436", "homalg_variable_3437", "homalg_variable_3438", "homalg_variable_3439", "homalg_variable_3440", "homalg_variable_3441", "homalg_variable_3442", "homalg_variable_3443", "homalg_variable_3444", "homalg_variable_3445", "homalg_variable_3446", "homalg_variable_3447", "homalg_variable_3448", "homalg_variable_3449", "homalg_variable_3450", "homalg_variable_3451", "homalg_variable_3452", "homalg_variable_3453", "homalg_variable_3454", "homalg_variable_3455", "homalg_variable_3456", "homalg_variable_3459", "homalg_variable_3460", "homalg_variable_3462", "homalg_variable_3463", "homalg_variable_3464", "homalg_variable_3466", "homalg_variable_3469", "homalg_variable_3470", "homalg_variable_3471", "homalg_variable_3472", "homalg_variable_3473", "homalg_variable_3474", "homalg_variable_3475", "homalg_variable_3476", "homalg_variable_3477", "homalg_variable_3478", "homalg_variable_3479", "homalg_variable_3480", "homalg_variable_3481", "homalg_variable_3482", "homalg_variable_3483", "homalg_variable_3484", "homalg_variable_3485", "homalg_variable_3486", "homalg_variable_3487", "homalg_variable_3488", "homalg_variable_3489", "homalg_variable_3491" ] do UnbindGlobal( _del );; od;;
gap> homalg_variable_3501 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3500 = homalg_variable_3501;
false
gap> homalg_variable_3502 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3500);;
gap> SI_ncols(homalg_variable_3502);
1
gap> homalg_variable_3503 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_3502 = homalg_variable_3503;
true
gap> homalg_variable_3504 := SIH_BasisOfColumnModule(homalg_variable_3500);;
gap> SI_ncols(homalg_variable_3504);
2
gap> homalg_variable_3505 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3504 = homalg_variable_3505;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3500);; homalg_variable_3506 := homalg_variable_l[1];; homalg_variable_3507 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3506);
2
gap> homalg_variable_3508 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3506 = homalg_variable_3508;
false
gap> SI_nrows(homalg_variable_3507);
2
gap> homalg_variable_3509 := homalg_variable_3500 * homalg_variable_3507;;
gap> homalg_variable_3506 = homalg_variable_3509;
true
gap> homalg_variable_3506 = homalg_variable_813;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3504,homalg_variable_3506);; homalg_variable_3510 := homalg_variable_l[1];; homalg_variable_3511 := homalg_variable_l[2];;
gap> homalg_variable_3512 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3510 = homalg_variable_3512;
true
gap> homalg_variable_3513 := homalg_variable_3506 * homalg_variable_3511;;
gap> homalg_variable_3514 := homalg_variable_3504 + homalg_variable_3513;;
gap> homalg_variable_3510 = homalg_variable_3514;
true
gap> homalg_variable_3515 := SIH_DecideZeroColumns(homalg_variable_3504,homalg_variable_3506);;
gap> homalg_variable_3516 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3515 = homalg_variable_3516;
true
gap> homalg_variable_3517 := homalg_variable_3511 * (homalg_variable_8);;
gap> homalg_variable_3518 := homalg_variable_3507 * homalg_variable_3517;;
gap> homalg_variable_3519 := homalg_variable_3500 * homalg_variable_3518;;
gap> homalg_variable_3519 = homalg_variable_3504;
true
gap> homalg_variable_3504 = homalg_variable_813;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3500,homalg_variable_3504);; homalg_variable_3520 := homalg_variable_l[1];; homalg_variable_3521 := homalg_variable_l[2];;
gap> homalg_variable_3522 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3520 = homalg_variable_3522;
true
gap> homalg_variable_3523 := homalg_variable_3504 * homalg_variable_3521;;
gap> homalg_variable_3524 := homalg_variable_3500 + homalg_variable_3523;;
gap> homalg_variable_3520 = homalg_variable_3524;
true
gap> homalg_variable_3525 := SIH_DecideZeroColumns(homalg_variable_3500,homalg_variable_3504);;
gap> homalg_variable_3526 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3525 = homalg_variable_3526;
true
gap> homalg_variable_3527 := homalg_variable_3521 * (homalg_variable_8);;
gap> homalg_variable_3528 := homalg_variable_3504 * homalg_variable_3527;;
gap> homalg_variable_3528 = homalg_variable_3500;
true
gap> homalg_variable_3529 := SIH_BasisOfColumnModule(homalg_variable_3494);;
gap> SI_ncols(homalg_variable_3529);
2
gap> homalg_variable_3530 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3529 = homalg_variable_3530;
false
gap> homalg_variable_3529 = homalg_variable_3494;
true
gap> homalg_variable_3531 := SIH_DecideZeroColumns(homalg_variable_3500,homalg_variable_3529);;
gap> homalg_variable_3532 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3531 = homalg_variable_3532;
true
gap> homalg_variable_3533 := SIH_DecideZeroColumns(homalg_variable_813,homalg_variable_3529);;
gap> homalg_variable_3534 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3533 = homalg_variable_3534;
false
gap> SIH_ZeroColumns(homalg_variable_3533);
[  ]
gap> homalg_variable_3535 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3208);;
gap> SI_ncols(homalg_variable_3535);
2
gap> homalg_variable_3536 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_3535 = homalg_variable_3536;
false
gap> homalg_variable_3537 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3535);;
gap> SI_ncols(homalg_variable_3537);
1
gap> homalg_variable_3538 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_3537 = homalg_variable_3538;
true
gap> homalg_variable_3539 := SIH_BasisOfColumnModule(homalg_variable_3535);;
gap> SI_ncols(homalg_variable_3539);
2
gap> homalg_variable_3540 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_3539 = homalg_variable_3540;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3535);; homalg_variable_3541 := homalg_variable_l[1];; homalg_variable_3542 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3541);
2
gap> homalg_variable_3543 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_3541 = homalg_variable_3543;
false
gap> SI_nrows(homalg_variable_3542);
2
gap> homalg_variable_3544 := homalg_variable_3535 * homalg_variable_3542;;
gap> homalg_variable_3541 = homalg_variable_3544;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3539,homalg_variable_3541);; homalg_variable_3545 := homalg_variable_l[1];; homalg_variable_3546 := homalg_variable_l[2];;
gap> homalg_variable_3547 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_3545 = homalg_variable_3547;
true
gap> homalg_variable_3548 := homalg_variable_3541 * homalg_variable_3546;;
gap> homalg_variable_3549 := homalg_variable_3539 + homalg_variable_3548;;
gap> homalg_variable_3545 = homalg_variable_3549;
true
gap> homalg_variable_3550 := SIH_DecideZeroColumns(homalg_variable_3539,homalg_variable_3541);;
gap> homalg_variable_3551 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_3550 = homalg_variable_3551;
true
gap> homalg_variable_3552 := homalg_variable_3546 * (homalg_variable_8);;
gap> homalg_variable_3553 := homalg_variable_3542 * homalg_variable_3552;;
gap> homalg_variable_3554 := homalg_variable_3535 * homalg_variable_3553;;
gap> homalg_variable_3554 = homalg_variable_3539;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3535,homalg_variable_3539);; homalg_variable_3555 := homalg_variable_l[1];; homalg_variable_3556 := homalg_variable_l[2];;
gap> homalg_variable_3557 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_3555 = homalg_variable_3557;
true
gap> homalg_variable_3558 := homalg_variable_3539 * homalg_variable_3556;;
gap> homalg_variable_3559 := homalg_variable_3535 + homalg_variable_3558;;
gap> homalg_variable_3555 = homalg_variable_3559;
true
gap> homalg_variable_3560 := SIH_DecideZeroColumns(homalg_variable_3535,homalg_variable_3539);;
gap> homalg_variable_3561 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_3560 = homalg_variable_3561;
true
gap> homalg_variable_3562 := homalg_variable_3556 * (homalg_variable_8);;
gap> homalg_variable_3563 := homalg_variable_3539 * homalg_variable_3562;;
gap> homalg_variable_3563 = homalg_variable_3535;
true
gap> homalg_variable_3564 := SIH_BasisOfColumnModule(homalg_variable_3303);;
gap> SI_ncols(homalg_variable_3564);
2
gap> homalg_variable_3565 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_3564 = homalg_variable_3565;
false
gap> homalg_variable_3564 = homalg_variable_3303;
false
gap> homalg_variable_3566 := SIH_DecideZeroColumns(homalg_variable_3535,homalg_variable_3564);;
gap> homalg_variable_3567 := SI_matrix(homalg_variable_5,4,2,"0");;
gap> homalg_variable_3566 = homalg_variable_3567;
true
gap> homalg_variable_3568 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3233);;
gap> SI_ncols(homalg_variable_3568);
1
gap> homalg_variable_3569 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3568 = homalg_variable_3569;
false
gap> homalg_variable_3570 := SIH_BasisOfColumnModule(homalg_variable_3568);;
gap> SI_ncols(homalg_variable_3570);
1
gap> homalg_variable_3571 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3570 = homalg_variable_3571;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3568);; homalg_variable_3572 := homalg_variable_l[1];; homalg_variable_3573 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3572);
1
gap> homalg_variable_3574 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3572 = homalg_variable_3574;
false
gap> SI_nrows(homalg_variable_3573);
1
gap> homalg_variable_3575 := homalg_variable_3568 * homalg_variable_3573;;
gap> homalg_variable_3572 = homalg_variable_3575;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3570,homalg_variable_3572);; homalg_variable_3576 := homalg_variable_l[1];; homalg_variable_3577 := homalg_variable_l[2];;
gap> homalg_variable_3578 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3576 = homalg_variable_3578;
true
gap> homalg_variable_3579 := homalg_variable_3572 * homalg_variable_3577;;
gap> homalg_variable_3580 := homalg_variable_3570 + homalg_variable_3579;;
gap> homalg_variable_3576 = homalg_variable_3580;
true
gap> homalg_variable_3581 := SIH_DecideZeroColumns(homalg_variable_3570,homalg_variable_3572);;
gap> homalg_variable_3582 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3581 = homalg_variable_3582;
true
gap> homalg_variable_3583 := homalg_variable_3577 * (homalg_variable_8);;
gap> homalg_variable_3584 := homalg_variable_3573 * homalg_variable_3583;;
gap> homalg_variable_3585 := homalg_variable_3568 * homalg_variable_3584;;
gap> homalg_variable_3585 = homalg_variable_3570;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3568,homalg_variable_3570);; homalg_variable_3586 := homalg_variable_l[1];; homalg_variable_3587 := homalg_variable_l[2];;
gap> homalg_variable_3588 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3586 = homalg_variable_3588;
true
gap> homalg_variable_3589 := homalg_variable_3570 * homalg_variable_3587;;
gap> homalg_variable_3590 := homalg_variable_3568 + homalg_variable_3589;;
gap> homalg_variable_3586 = homalg_variable_3590;
true
gap> homalg_variable_3591 := SIH_DecideZeroColumns(homalg_variable_3568,homalg_variable_3570);;
gap> homalg_variable_3592 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3591 = homalg_variable_3592;
true
gap> homalg_variable_3593 := homalg_variable_3587 * (homalg_variable_8);;
gap> homalg_variable_3594 := homalg_variable_3570 * homalg_variable_3593;;
gap> homalg_variable_3594 = homalg_variable_3568;
true
gap> homalg_variable_3595 := SIH_BasisOfColumnModule(homalg_variable_3327);;
gap> SI_ncols(homalg_variable_3595);
1
gap> homalg_variable_3596 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3595 = homalg_variable_3596;
false
gap> homalg_variable_3595 = homalg_variable_3327;
false
gap> homalg_variable_3597 := SIH_DecideZeroColumns(homalg_variable_3568,homalg_variable_3595);;
gap> homalg_variable_3598 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3597 = homalg_variable_3598;
true
gap> homalg_variable_3599 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3264);;
gap> SI_ncols(homalg_variable_3599);
1
gap> homalg_variable_3600 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3599 = homalg_variable_3600;
true
gap> homalg_variable_3601 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3303);;
gap> SI_ncols(homalg_variable_3601);
1
gap> homalg_variable_3602 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_3601 = homalg_variable_3602;
true
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_2785);; homalg_variable_3603 := homalg_variable_l[1];; homalg_variable_3604 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3603);
1
gap> homalg_variable_3605 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_3603 = homalg_variable_3605;
false
gap> SI_nrows(homalg_variable_3604);
5
gap> homalg_variable_3606 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3607 := SIH_Submatrix(homalg_variable_3604,[ 1 ],[1..1]);;
gap> homalg_variable_3608 := SIH_UnionOfRows(homalg_variable_3606,homalg_variable_3607);;
gap> homalg_variable_3603 = homalg_variable_3608;
true
gap> homalg_variable_3609 := homalg_variable_2910 * homalg_variable_3495;;
gap> homalg_variable_3610 := homalg_variable_3155 * homalg_variable_3609;;
gap> homalg_variable_3611 := homalg_variable_3610 * (homalg_variable_8);;
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3611,homalg_variable_3603);; homalg_variable_3612 := homalg_variable_l[1];; homalg_variable_3613 := homalg_variable_l[2];;
gap> homalg_variable_3614 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3612 = homalg_variable_3614;
true
gap> homalg_variable_3615 := homalg_variable_3603 * homalg_variable_3613;;
gap> homalg_variable_3616 := homalg_variable_3615 - homalg_variable_3610;;
gap> homalg_variable_3612 = homalg_variable_3616;
true
gap> homalg_variable_3617 := SIH_DecideZeroColumns(homalg_variable_3611,homalg_variable_3603);;
gap> homalg_variable_3618 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3617 = homalg_variable_3618;
true
gap> homalg_variable_3619 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_3620 := SIH_Submatrix(homalg_variable_3604,[ 1 ],[1..1]);;
gap> homalg_variable_3621 := homalg_variable_3613 * (homalg_variable_8);;
gap> homalg_variable_3622 := homalg_variable_3620 * homalg_variable_3621;;
gap> homalg_variable_3623 := SIH_UnionOfRows(homalg_variable_3619,homalg_variable_3622);;
gap> homalg_variable_3624 := homalg_variable_3623 - homalg_variable_3611;;
gap> homalg_variable_3625 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3624 = homalg_variable_3625;
true
gap> homalg_variable_3627 := homalg_variable_3604 * homalg_variable_3621;;
gap> homalg_variable_3628 := homalg_variable_2442 * homalg_variable_3627;;
gap> homalg_variable_3629 := homalg_variable_3628 * homalg_variable_3529;;
gap> homalg_variable_3626 := SIH_DecideZeroColumns(homalg_variable_3629,homalg_variable_3331);;
gap> homalg_variable_3630 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_3626 = homalg_variable_3630;
true
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_2867);; homalg_variable_3631 := homalg_variable_l[1];; homalg_variable_3632 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3631);
2
gap> homalg_variable_3633 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3631 = homalg_variable_3633;
false
gap> SI_nrows(homalg_variable_3632);
10
gap> homalg_variable_3634 := SIH_Submatrix(homalg_variable_3632,[ 1, 2 ],[1..2]);;
gap> homalg_variable_3631 = homalg_variable_3634;
true
gap> homalg_variable_3631 = homalg_variable_813;
false
gap> homalg_variable_3635 := SIH_Submatrix(homalg_variable_832,[1..2],[ 1, 2 ]);;
gap> homalg_variable_3636 := homalg_variable_3635 * (homalg_variable_8);;
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3636,homalg_variable_3631);; homalg_variable_3637 := homalg_variable_l[1];; homalg_variable_3638 := homalg_variable_l[2];;
gap> homalg_variable_3639 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3637 = homalg_variable_3639;
true
gap> homalg_variable_3640 := homalg_variable_3631 * homalg_variable_3638;;
gap> homalg_variable_3641 := homalg_variable_3640 - homalg_variable_3635;;
gap> homalg_variable_3637 = homalg_variable_3641;
true
gap> homalg_variable_3642 := SIH_DecideZeroColumns(homalg_variable_3636,homalg_variable_3631);;
gap> homalg_variable_3643 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3642 = homalg_variable_3643;
true
gap> homalg_variable_3644 := SIH_Submatrix(homalg_variable_3632,[ 1, 2 ],[1..2]);;
gap> homalg_variable_3645 := homalg_variable_3638 * (homalg_variable_8);;
gap> homalg_variable_3646 := homalg_variable_3644 * homalg_variable_3645;;
gap> homalg_variable_3647 := homalg_variable_3646 - homalg_variable_3636;;
gap> homalg_variable_3648 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3647 = homalg_variable_3648;
true
gap> homalg_variable_3650 := homalg_variable_2790 * homalg_variable_3169;;
gap> homalg_variable_3651 := SIH_UnionOfColumns(homalg_variable_2785,homalg_variable_3650);;
gap> homalg_variable_3649 := SIH_BasisOfColumnModule(homalg_variable_3651);;
gap> SI_ncols(homalg_variable_3649);
3
gap> homalg_variable_3652 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_3649 = homalg_variable_3652;
false
gap> homalg_variable_3653 := SIH_DecideZeroColumns(homalg_variable_2790,homalg_variable_3649);;
gap> homalg_variable_3654 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_3653 = homalg_variable_3654;
false
gap> homalg_variable_3655 := SIH_UnionOfColumns(homalg_variable_3653,homalg_variable_3649);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3655);; homalg_variable_3656 := homalg_variable_l[1];; homalg_variable_3657 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3656);
2
gap> homalg_variable_3658 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3656 = homalg_variable_3658;
false
gap> SI_nrows(homalg_variable_3657);
4
gap> homalg_variable_3659 := SIH_Submatrix(homalg_variable_3657,[ 1 ],[1..2]);;
gap> homalg_variable_3660 := homalg_variable_3653 * homalg_variable_3659;;
gap> homalg_variable_3661 := SIH_Submatrix(homalg_variable_3657,[ 2, 3, 4 ],[1..2]);;
gap> homalg_variable_3662 := homalg_variable_3649 * homalg_variable_3661;;
gap> homalg_variable_3663 := homalg_variable_3660 + homalg_variable_3662;;
gap> homalg_variable_3656 = homalg_variable_3663;
true
gap> homalg_variable_3665 := homalg_variable_3632 * homalg_variable_3645;;
gap> homalg_variable_3666 := homalg_variable_3155 * homalg_variable_3665;;
gap> homalg_variable_3664 := SIH_DecideZeroColumns(homalg_variable_3666,homalg_variable_3649);;
gap> homalg_variable_3667 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3664 = homalg_variable_3667;
false
gap> homalg_variable_3668 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3666 = homalg_variable_3668;
false
gap> homalg_variable_3656 = homalg_variable_813;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3664,homalg_variable_3656);; homalg_variable_3669 := homalg_variable_l[1];; homalg_variable_3670 := homalg_variable_l[2];;
gap> homalg_variable_3671 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3669 = homalg_variable_3671;
true
gap> homalg_variable_3672 := homalg_variable_3656 * homalg_variable_3670;;
gap> homalg_variable_3673 := homalg_variable_3664 + homalg_variable_3672;;
gap> homalg_variable_3669 = homalg_variable_3673;
true
gap> homalg_variable_3674 := SIH_DecideZeroColumns(homalg_variable_3664,homalg_variable_3656);;
gap> homalg_variable_3675 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3674 = homalg_variable_3675;
true
gap> homalg_variable_3677 := SIH_Submatrix(homalg_variable_3657,[ 1 ],[1..2]);;
gap> homalg_variable_3678 := homalg_variable_3670 * (homalg_variable_8);;
gap> homalg_variable_3679 := homalg_variable_3677 * homalg_variable_3678;;
gap> homalg_variable_3680 := homalg_variable_2790 * homalg_variable_3679;;
gap> homalg_variable_3681 := homalg_variable_3680 - homalg_variable_3666;;
gap> homalg_variable_3676 := SIH_DecideZeroColumns(homalg_variable_3681,homalg_variable_3649);;
gap> homalg_variable_3682 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3676 = homalg_variable_3682;
true
gap> homalg_variable_3684 := SIH_UnionOfColumns(homalg_variable_3628,homalg_variable_3332);;
gap> homalg_variable_3683 := SIH_BasisOfColumnModule(homalg_variable_3684);;
gap> SI_ncols(homalg_variable_3683);
3
gap> homalg_variable_3685 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_3683 = homalg_variable_3685;
false
gap> homalg_variable_3686 := SIH_DecideZeroColumns(homalg_variable_237,homalg_variable_3683);;
gap> homalg_variable_3687 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3686 = homalg_variable_3687;
false
gap> homalg_variable_3689 := SIH_UnionOfColumns(homalg_variable_3679,homalg_variable_3169);;
gap> homalg_variable_3688 := SIH_BasisOfColumnModule(homalg_variable_3689);;
gap> SI_ncols(homalg_variable_3688);
1
gap> homalg_variable_3690 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3688 = homalg_variable_3690;
false
gap> homalg_variable_3691 := SIH_DecideZeroColumns(homalg_variable_237,homalg_variable_3688);;
gap> homalg_variable_3692 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3691 = homalg_variable_3692;
true
gap> homalg_variable_3693 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3628,homalg_variable_3332);;
gap> SI_ncols(homalg_variable_3693);
4
gap> homalg_variable_3694 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_3693 = homalg_variable_3694;
false
gap> homalg_variable_3695 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3693);;
gap> SI_ncols(homalg_variable_3695);
3
gap> homalg_variable_3696 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_3695 = homalg_variable_3696;
false
gap> homalg_variable_3697 := SI_\[(homalg_variable_3695,4,1);;
gap> SI_deg( homalg_variable_3697 );
-1
gap> homalg_variable_3698 := SI_\[(homalg_variable_3695,3,1);;
gap> SI_deg( homalg_variable_3698 );
1
gap> homalg_variable_3699 := SI_\[(homalg_variable_3695,2,1);;
gap> SI_deg( homalg_variable_3699 );
1
gap> homalg_variable_3700 := SI_\[(homalg_variable_3695,1,1);;
gap> SI_deg( homalg_variable_3700 );
-1
gap> homalg_variable_3701 := SI_\[(homalg_variable_3695,4,2);;
gap> SI_deg( homalg_variable_3701 );
1
gap> homalg_variable_3702 := SI_\[(homalg_variable_3695,3,2);;
gap> SI_deg( homalg_variable_3702 );
1
gap> homalg_variable_3703 := SI_\[(homalg_variable_3695,2,2);;
gap> SI_deg( homalg_variable_3703 );
-1
gap> homalg_variable_3704 := SI_\[(homalg_variable_3695,1,2);;
gap> SI_deg( homalg_variable_3704 );
-1
gap> homalg_variable_3705 := SI_\[(homalg_variable_3695,4,3);;
gap> SI_deg( homalg_variable_3705 );
1
gap> homalg_variable_3706 := SI_\[(homalg_variable_3695,3,3);;
gap> SI_deg( homalg_variable_3706 );
-1
gap> homalg_variable_3707 := SI_\[(homalg_variable_3695,2,3);;
gap> SI_deg( homalg_variable_3707 );
1
gap> homalg_variable_3708 := SI_\[(homalg_variable_3695,1,3);;
gap> SI_deg( homalg_variable_3708 );
-1
gap> homalg_variable_3709 := SIH_BasisOfColumnModule(homalg_variable_3693);;
gap> SI_ncols(homalg_variable_3709);
4
gap> homalg_variable_3710 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_3709 = homalg_variable_3710;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3693);; homalg_variable_3711 := homalg_variable_l[1];; homalg_variable_3712 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3711);
4
gap> homalg_variable_3713 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_3711 = homalg_variable_3713;
false
gap> SI_nrows(homalg_variable_3712);
4
gap> homalg_variable_3714 := homalg_variable_3693 * homalg_variable_3712;;
gap> homalg_variable_3711 = homalg_variable_3714;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3709,homalg_variable_3711);; homalg_variable_3715 := homalg_variable_l[1];; homalg_variable_3716 := homalg_variable_l[2];;
gap> homalg_variable_3717 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_3715 = homalg_variable_3717;
true
gap> homalg_variable_3718 := homalg_variable_3711 * homalg_variable_3716;;
gap> homalg_variable_3719 := homalg_variable_3709 + homalg_variable_3718;;
gap> homalg_variable_3715 = homalg_variable_3719;
true
gap> homalg_variable_3720 := SIH_DecideZeroColumns(homalg_variable_3709,homalg_variable_3711);;
gap> homalg_variable_3721 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_3720 = homalg_variable_3721;
true
gap> homalg_variable_3722 := homalg_variable_3716 * (homalg_variable_8);;
gap> homalg_variable_3723 := homalg_variable_3712 * homalg_variable_3722;;
gap> homalg_variable_3724 := homalg_variable_3693 * homalg_variable_3723;;
gap> homalg_variable_3724 = homalg_variable_3709;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3693,homalg_variable_3709);; homalg_variable_3725 := homalg_variable_l[1];; homalg_variable_3726 := homalg_variable_l[2];;
gap> homalg_variable_3727 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_3725 = homalg_variable_3727;
true
gap> homalg_variable_3728 := homalg_variable_3709 * homalg_variable_3726;;
gap> homalg_variable_3729 := homalg_variable_3693 + homalg_variable_3728;;
gap> homalg_variable_3725 = homalg_variable_3729;
true
gap> homalg_variable_3730 := SIH_DecideZeroColumns(homalg_variable_3693,homalg_variable_3709);;
gap> homalg_variable_3731 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_3730 = homalg_variable_3731;
true
gap> homalg_variable_3732 := homalg_variable_3726 * (homalg_variable_8);;
gap> homalg_variable_3733 := homalg_variable_3709 * homalg_variable_3732;;
gap> homalg_variable_3733 = homalg_variable_3693;
true
gap> homalg_variable_3734 := SIH_DecideZeroColumns(homalg_variable_3693,homalg_variable_3529);;
gap> homalg_variable_3735 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_3734 = homalg_variable_3735;
false
gap> SIH_ZeroColumns(homalg_variable_3734);
[  ]
gap> homalg_variable_3736 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3734,homalg_variable_3529);;
gap> SI_ncols(homalg_variable_3736);
5
gap> homalg_variable_3737 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_3736 = homalg_variable_3737;
false
gap> homalg_variable_3739 := homalg_variable_3734 * homalg_variable_3736;;
gap> homalg_variable_3738 := SIH_DecideZeroColumns(homalg_variable_3739,homalg_variable_3529);;
gap> homalg_variable_3740 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_3738 = homalg_variable_3740;
true
gap> homalg_variable_3741 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3734,homalg_variable_3529);;
gap> SI_ncols(homalg_variable_3741);
5
gap> homalg_variable_3742 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_3741 = homalg_variable_3742;
false
gap> homalg_variable_3743 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3741);;
gap> SI_ncols(homalg_variable_3743);
1
gap> homalg_variable_3744 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_3743 = homalg_variable_3744;
false
gap> homalg_variable_3745 := SI_\[(homalg_variable_3743,5,1);;
gap> SI_deg( homalg_variable_3745 );
-1
gap> homalg_variable_3746 := SI_\[(homalg_variable_3743,4,1);;
gap> SI_deg( homalg_variable_3746 );
1
gap> homalg_variable_3747 := SI_\[(homalg_variable_3743,3,1);;
gap> SI_deg( homalg_variable_3747 );
1
gap> homalg_variable_3748 := SI_\[(homalg_variable_3743,2,1);;
gap> SI_deg( homalg_variable_3748 );
1
gap> homalg_variable_3749 := SI_\[(homalg_variable_3743,1,1);;
gap> SI_deg( homalg_variable_3749 );
-1
gap> homalg_variable_3750 := SIH_BasisOfColumnModule(homalg_variable_3741);;
gap> SI_ncols(homalg_variable_3750);
5
gap> homalg_variable_3751 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_3750 = homalg_variable_3751;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3741);; homalg_variable_3752 := homalg_variable_l[1];; homalg_variable_3753 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3752);
5
gap> homalg_variable_3754 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_3752 = homalg_variable_3754;
false
gap> SI_nrows(homalg_variable_3753);
5
gap> homalg_variable_3755 := homalg_variable_3741 * homalg_variable_3753;;
gap> homalg_variable_3752 = homalg_variable_3755;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3750,homalg_variable_3752);; homalg_variable_3756 := homalg_variable_l[1];; homalg_variable_3757 := homalg_variable_l[2];;
gap> homalg_variable_3758 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_3756 = homalg_variable_3758;
true
gap> homalg_variable_3759 := homalg_variable_3752 * homalg_variable_3757;;
gap> homalg_variable_3760 := homalg_variable_3750 + homalg_variable_3759;;
gap> homalg_variable_3756 = homalg_variable_3760;
true
gap> homalg_variable_3761 := SIH_DecideZeroColumns(homalg_variable_3750,homalg_variable_3752);;
gap> homalg_variable_3762 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_3761 = homalg_variable_3762;
true
gap> homalg_variable_3763 := homalg_variable_3757 * (homalg_variable_8);;
gap> homalg_variable_3764 := homalg_variable_3753 * homalg_variable_3763;;
gap> homalg_variable_3765 := homalg_variable_3741 * homalg_variable_3764;;
gap> homalg_variable_3765 = homalg_variable_3750;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3741,homalg_variable_3750);; homalg_variable_3766 := homalg_variable_l[1];; homalg_variable_3767 := homalg_variable_l[2];;
gap> homalg_variable_3768 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_3766 = homalg_variable_3768;
true
gap> homalg_variable_3769 := homalg_variable_3750 * homalg_variable_3767;;
gap> homalg_variable_3770 := homalg_variable_3741 + homalg_variable_3769;;
gap> homalg_variable_3766 = homalg_variable_3770;
true
gap> homalg_variable_3771 := SIH_DecideZeroColumns(homalg_variable_3741,homalg_variable_3750);;
gap> homalg_variable_3772 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_3771 = homalg_variable_3772;
true
gap> homalg_variable_3773 := homalg_variable_3767 * (homalg_variable_8);;
gap> homalg_variable_3774 := homalg_variable_3750 * homalg_variable_3773;;
gap> homalg_variable_3774 = homalg_variable_3741;
true
gap> homalg_variable_3775 := SIH_BasisOfColumnModule(homalg_variable_3736);;
gap> SI_ncols(homalg_variable_3775);
5
gap> homalg_variable_3776 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_3775 = homalg_variable_3776;
false
gap> homalg_variable_3775 = homalg_variable_3736;
true
gap> homalg_variable_3777 := SIH_DecideZeroColumns(homalg_variable_3741,homalg_variable_3775);;
gap> homalg_variable_3778 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_3777 = homalg_variable_3778;
true
gap> homalg_variable_3779 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3679,homalg_variable_3169);;
gap> SI_ncols(homalg_variable_3779);
3
gap> homalg_variable_3780 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_3779 = homalg_variable_3780;
false
gap> homalg_variable_3781 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3779);;
gap> SI_ncols(homalg_variable_3781);
1
gap> homalg_variable_3782 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3781 = homalg_variable_3782;
false
gap> homalg_variable_3783 := SI_\[(homalg_variable_3781,3,1);;
gap> SI_deg( homalg_variable_3783 );
1
gap> homalg_variable_3784 := SI_\[(homalg_variable_3781,2,1);;
gap> SI_deg( homalg_variable_3784 );
1
gap> homalg_variable_3785 := SI_\[(homalg_variable_3781,1,1);;
gap> SI_deg( homalg_variable_3785 );
-1
gap> homalg_variable_3786 := SIH_BasisOfColumnModule(homalg_variable_3779);;
gap> SI_ncols(homalg_variable_3786);
3
gap> homalg_variable_3787 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_3786 = homalg_variable_3787;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3779);; homalg_variable_3788 := homalg_variable_l[1];; homalg_variable_3789 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3788);
3
gap> homalg_variable_3790 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_3788 = homalg_variable_3790;
false
gap> SI_nrows(homalg_variable_3789);
3
gap> homalg_variable_3791 := homalg_variable_3779 * homalg_variable_3789;;
gap> homalg_variable_3788 = homalg_variable_3791;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3786,homalg_variable_3788);; homalg_variable_3792 := homalg_variable_l[1];; homalg_variable_3793 := homalg_variable_l[2];;
gap> homalg_variable_3794 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_3792 = homalg_variable_3794;
true
gap> homalg_variable_3795 := homalg_variable_3788 * homalg_variable_3793;;
gap> homalg_variable_3796 := homalg_variable_3786 + homalg_variable_3795;;
gap> homalg_variable_3792 = homalg_variable_3796;
true
gap> homalg_variable_3797 := SIH_DecideZeroColumns(homalg_variable_3786,homalg_variable_3788);;
gap> homalg_variable_3798 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_3797 = homalg_variable_3798;
true
gap> homalg_variable_3799 := homalg_variable_3793 * (homalg_variable_8);;
gap> homalg_variable_3800 := homalg_variable_3789 * homalg_variable_3799;;
gap> homalg_variable_3801 := homalg_variable_3779 * homalg_variable_3800;;
gap> homalg_variable_3801 = homalg_variable_3786;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3779,homalg_variable_3786);; homalg_variable_3802 := homalg_variable_l[1];; homalg_variable_3803 := homalg_variable_l[2];;
gap> homalg_variable_3804 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_3802 = homalg_variable_3804;
true
gap> homalg_variable_3805 := homalg_variable_3786 * homalg_variable_3803;;
gap> homalg_variable_3806 := homalg_variable_3779 + homalg_variable_3805;;
gap> homalg_variable_3802 = homalg_variable_3806;
true
gap> homalg_variable_3807 := SIH_DecideZeroColumns(homalg_variable_3779,homalg_variable_3786);;
gap> homalg_variable_3808 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_3807 = homalg_variable_3808;
true
gap> homalg_variable_3809 := homalg_variable_3803 * (homalg_variable_8);;
gap> homalg_variable_3810 := homalg_variable_3786 * homalg_variable_3809;;
gap> homalg_variable_3810 = homalg_variable_3779;
true
gap> SIH_ZeroColumns(homalg_variable_3779);
[  ]
gap> homalg_variable_3811 := homalg_variable_3779 * homalg_variable_3781;;
gap> homalg_variable_3812 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_3811 = homalg_variable_3812;
true
gap> homalg_variable_3813 := SIH_BasisOfColumnModule(homalg_variable_3781);;
gap> SI_ncols(homalg_variable_3813);
1
gap> homalg_variable_3814 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3813 = homalg_variable_3814;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3781);; homalg_variable_3815 := homalg_variable_l[1];; homalg_variable_3816 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3815);
1
gap> homalg_variable_3817 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3815 = homalg_variable_3817;
false
gap> SI_nrows(homalg_variable_3816);
1
gap> homalg_variable_3818 := homalg_variable_3781 * homalg_variable_3816;;
gap> homalg_variable_3815 = homalg_variable_3818;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3813,homalg_variable_3815);; homalg_variable_3819 := homalg_variable_l[1];; homalg_variable_3820 := homalg_variable_l[2];;
gap> homalg_variable_3821 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3819 = homalg_variable_3821;
true
gap> homalg_variable_3822 := homalg_variable_3815 * homalg_variable_3820;;
gap> homalg_variable_3823 := homalg_variable_3813 + homalg_variable_3822;;
gap> homalg_variable_3819 = homalg_variable_3823;
true
gap> homalg_variable_3824 := SIH_DecideZeroColumns(homalg_variable_3813,homalg_variable_3815);;
gap> homalg_variable_3825 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3824 = homalg_variable_3825;
true
gap> homalg_variable_3826 := homalg_variable_3820 * (homalg_variable_8);;
gap> homalg_variable_3827 := homalg_variable_3816 * homalg_variable_3826;;
gap> homalg_variable_3828 := homalg_variable_3781 * homalg_variable_3827;;
gap> homalg_variable_3828 = homalg_variable_3813;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3781,homalg_variable_3813);; homalg_variable_3829 := homalg_variable_l[1];; homalg_variable_3830 := homalg_variable_l[2];;
gap> homalg_variable_3831 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3829 = homalg_variable_3831;
true
gap> homalg_variable_3832 := homalg_variable_3813 * homalg_variable_3830;;
gap> homalg_variable_3833 := homalg_variable_3781 + homalg_variable_3832;;
gap> homalg_variable_3829 = homalg_variable_3833;
true
gap> homalg_variable_3834 := SIH_DecideZeroColumns(homalg_variable_3781,homalg_variable_3813);;
gap> homalg_variable_3835 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_3834 = homalg_variable_3835;
true
gap> homalg_variable_3836 := homalg_variable_3830 * (homalg_variable_8);;
gap> homalg_variable_3837 := homalg_variable_3813 * homalg_variable_3836;;
gap> homalg_variable_3837 = homalg_variable_3781;
true
gap> homalg_variable_3813 = homalg_variable_3781;
true
gap> homalg_variable_3839 := SIH_UnionOfRows(homalg_variable_2867,homalg_variable_3155);;
gap> homalg_variable_3838 := SIH_BasisOfColumnModule(homalg_variable_3839);;
gap> SI_ncols(homalg_variable_3838);
7
gap> homalg_variable_3840 := SI_matrix(homalg_variable_5,4,7,"0");;
gap> homalg_variable_3838 = homalg_variable_3840;
false
gap> homalg_variable_3842 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_3843 := SIH_UnionOfRows(homalg_variable_3842,homalg_variable_2785);;
gap> homalg_variable_3841 := SIH_DecideZeroColumns(homalg_variable_3843,homalg_variable_3838);;
gap> homalg_variable_3844 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_3841 = homalg_variable_3844;
false
gap> homalg_variable_3845 := SIH_UnionOfColumns(homalg_variable_3841,homalg_variable_3838);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3845);; homalg_variable_3846 := homalg_variable_l[1];; homalg_variable_3847 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3846);
5
gap> homalg_variable_3848 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_3846 = homalg_variable_3848;
false
gap> SI_nrows(homalg_variable_3847);
12
gap> homalg_variable_3849 := SIH_Submatrix(homalg_variable_3847,[ 1, 2, 3, 4, 5 ],[1..5]);;
gap> homalg_variable_3850 := homalg_variable_3841 * homalg_variable_3849;;
gap> homalg_variable_3851 := SIH_Submatrix(homalg_variable_3847,[ 6, 7, 8, 9, 10, 11, 12 ],[1..5]);;
gap> homalg_variable_3852 := homalg_variable_3838 * homalg_variable_3851;;
gap> homalg_variable_3853 := homalg_variable_3850 + homalg_variable_3852;;
gap> homalg_variable_3846 = homalg_variable_3853;
true
gap> homalg_variable_3855 := SIH_Submatrix(homalg_variable_1375,[1..7],[ 1, 2 ]);;
gap> homalg_variable_3856 := homalg_variable_3855 * homalg_variable_3779;;
gap> homalg_variable_3857 := homalg_variable_832 * homalg_variable_3856;;
gap> homalg_variable_3858 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_3859 := SIH_UnionOfRows(homalg_variable_3857,homalg_variable_3858);;
gap> homalg_variable_3860 := homalg_variable_3859 * (homalg_variable_8);;
gap> homalg_variable_3854 := SIH_DecideZeroColumns(homalg_variable_3860,homalg_variable_3838);;
gap> homalg_variable_3861 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_3854 = homalg_variable_3861;
false
gap> homalg_variable_3862 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_3857 = homalg_variable_3862;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3854,homalg_variable_3846);; homalg_variable_3863 := homalg_variable_l[1];; homalg_variable_3864 := homalg_variable_l[2];;
gap> homalg_variable_3865 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_3863 = homalg_variable_3865;
true
gap> homalg_variable_3866 := homalg_variable_3846 * homalg_variable_3864;;
gap> homalg_variable_3867 := homalg_variable_3854 + homalg_variable_3866;;
gap> homalg_variable_3863 = homalg_variable_3867;
true
gap> homalg_variable_3868 := SIH_DecideZeroColumns(homalg_variable_3854,homalg_variable_3846);;
gap> homalg_variable_3869 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_3868 = homalg_variable_3869;
true
gap> homalg_variable_3871 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_3872 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_3873 := SIH_Submatrix(homalg_variable_3847,[ 1 ],[1..5]);;
gap> homalg_variable_3874 := homalg_variable_3864 * (homalg_variable_8);;
gap> homalg_variable_3875 := homalg_variable_3873 * homalg_variable_3874;;
gap> homalg_variable_3876 := SIH_UnionOfRows(homalg_variable_3872,homalg_variable_3875);;
gap> homalg_variable_3877 := SIH_UnionOfRows(homalg_variable_3871,homalg_variable_3876);;
gap> homalg_variable_3878 := homalg_variable_3877 - homalg_variable_3860;;
gap> homalg_variable_3870 := SIH_DecideZeroColumns(homalg_variable_3878,homalg_variable_3838);;
gap> homalg_variable_3879 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_3870 = homalg_variable_3879;
true
gap> homalg_variable_3881 := SIH_Submatrix(homalg_variable_3847,[ 1, 2, 3, 4, 5 ],[1..5]);;
gap> homalg_variable_3882 := homalg_variable_3881 * homalg_variable_3874;;
gap> homalg_variable_3883 := homalg_variable_2442 * homalg_variable_3882;;
gap> homalg_variable_3884 := homalg_variable_3883 * homalg_variable_3813;;
gap> homalg_variable_3880 := SIH_DecideZeroColumns(homalg_variable_3884,homalg_variable_3683);;
gap> homalg_variable_3885 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3880 = homalg_variable_3885;
true
gap> homalg_variable_3887 := SIH_UnionOfColumns(homalg_variable_3883,homalg_variable_3684);;
gap> homalg_variable_3886 := SIH_BasisOfColumnModule(homalg_variable_3887);;
gap> SI_ncols(homalg_variable_3886);
1
gap> homalg_variable_3888 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3886 = homalg_variable_3888;
false
gap> homalg_variable_3889 := SIH_DecideZeroColumns(homalg_variable_237,homalg_variable_3886);;
gap> homalg_variable_3890 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_3889 = homalg_variable_3890;
true
gap> homalg_variable_3891 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3883,homalg_variable_3684);;
gap> SI_ncols(homalg_variable_3891);
5
gap> homalg_variable_3892 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_3891 = homalg_variable_3892;
false
gap> homalg_variable_3893 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3891);;
gap> SI_ncols(homalg_variable_3893);
3
gap> homalg_variable_3894 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_3893 = homalg_variable_3894;
false
gap> homalg_variable_3895 := SI_\[(homalg_variable_3893,5,1);;
gap> SI_deg( homalg_variable_3895 );
-1
gap> homalg_variable_3896 := SI_\[(homalg_variable_3893,4,1);;
gap> SI_deg( homalg_variable_3896 );
1
gap> homalg_variable_3897 := SI_\[(homalg_variable_3893,3,1);;
gap> SI_deg( homalg_variable_3897 );
1
gap> homalg_variable_3898 := SI_\[(homalg_variable_3893,2,1);;
gap> SI_deg( homalg_variable_3898 );
-1
gap> homalg_variable_3899 := SI_\[(homalg_variable_3893,1,1);;
gap> SI_deg( homalg_variable_3899 );
-1
gap> homalg_variable_3900 := SI_\[(homalg_variable_3893,5,2);;
gap> SI_deg( homalg_variable_3900 );
1
gap> homalg_variable_3901 := SI_\[(homalg_variable_3893,4,2);;
gap> SI_deg( homalg_variable_3901 );
1
gap> homalg_variable_3902 := SI_\[(homalg_variable_3893,3,2);;
gap> SI_deg( homalg_variable_3902 );
-1
gap> homalg_variable_3903 := SI_\[(homalg_variable_3893,2,2);;
gap> SI_deg( homalg_variable_3903 );
-1
gap> homalg_variable_3904 := SI_\[(homalg_variable_3893,1,2);;
gap> SI_deg( homalg_variable_3904 );
-1
gap> homalg_variable_3905 := SI_\[(homalg_variable_3893,5,3);;
gap> SI_deg( homalg_variable_3905 );
1
gap> homalg_variable_3906 := SI_\[(homalg_variable_3893,4,3);;
gap> SI_deg( homalg_variable_3906 );
-1
gap> homalg_variable_3907 := SI_\[(homalg_variable_3893,3,3);;
gap> SI_deg( homalg_variable_3907 );
1
gap> homalg_variable_3908 := SI_\[(homalg_variable_3893,2,3);;
gap> SI_deg( homalg_variable_3908 );
-1
gap> homalg_variable_3909 := SI_\[(homalg_variable_3893,1,3);;
gap> SI_deg( homalg_variable_3909 );
-1
gap> homalg_variable_3910 := SIH_BasisOfColumnModule(homalg_variable_3891);;
gap> SI_ncols(homalg_variable_3910);
5
gap> homalg_variable_3911 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_3910 = homalg_variable_3911;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3891);; homalg_variable_3912 := homalg_variable_l[1];; homalg_variable_3913 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3912);
5
gap> homalg_variable_3914 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_3912 = homalg_variable_3914;
false
gap> SI_nrows(homalg_variable_3913);
5
gap> homalg_variable_3915 := homalg_variable_3891 * homalg_variable_3913;;
gap> homalg_variable_3912 = homalg_variable_3915;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3910,homalg_variable_3912);; homalg_variable_3916 := homalg_variable_l[1];; homalg_variable_3917 := homalg_variable_l[2];;
gap> homalg_variable_3918 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_3916 = homalg_variable_3918;
true
gap> homalg_variable_3919 := homalg_variable_3912 * homalg_variable_3917;;
gap> homalg_variable_3920 := homalg_variable_3910 + homalg_variable_3919;;
gap> homalg_variable_3916 = homalg_variable_3920;
true
gap> homalg_variable_3921 := SIH_DecideZeroColumns(homalg_variable_3910,homalg_variable_3912);;
gap> homalg_variable_3922 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_3921 = homalg_variable_3922;
true
gap> homalg_variable_3923 := homalg_variable_3917 * (homalg_variable_8);;
gap> homalg_variable_3924 := homalg_variable_3913 * homalg_variable_3923;;
gap> homalg_variable_3925 := homalg_variable_3891 * homalg_variable_3924;;
gap> homalg_variable_3925 = homalg_variable_3910;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3891,homalg_variable_3910);; homalg_variable_3926 := homalg_variable_l[1];; homalg_variable_3927 := homalg_variable_l[2];;
gap> homalg_variable_3928 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_3926 = homalg_variable_3928;
true
gap> homalg_variable_3929 := homalg_variable_3910 * homalg_variable_3927;;
gap> homalg_variable_3930 := homalg_variable_3891 + homalg_variable_3929;;
gap> homalg_variable_3926 = homalg_variable_3930;
true
gap> homalg_variable_3931 := SIH_DecideZeroColumns(homalg_variable_3891,homalg_variable_3910);;
gap> homalg_variable_3932 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_3931 = homalg_variable_3932;
true
gap> homalg_variable_3933 := homalg_variable_3927 * (homalg_variable_8);;
gap> homalg_variable_3934 := homalg_variable_3910 * homalg_variable_3933;;
gap> homalg_variable_3934 = homalg_variable_3891;
true
gap> homalg_variable_3935 := SIH_DecideZeroColumns(homalg_variable_3891,homalg_variable_3813);;
gap> homalg_variable_3936 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_3935 = homalg_variable_3936;
false
gap> SIH_ZeroColumns(homalg_variable_3935);
[  ]
gap> homalg_variable_3937 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3935,homalg_variable_3813);;
gap> SI_ncols(homalg_variable_3937);
4
gap> homalg_variable_3938 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3937 = homalg_variable_3938;
false
gap> homalg_variable_3940 := homalg_variable_3935 * homalg_variable_3937;;
gap> homalg_variable_3939 := SIH_DecideZeroColumns(homalg_variable_3940,homalg_variable_3813);;
gap> homalg_variable_3941 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_3939 = homalg_variable_3941;
true
gap> homalg_variable_3942 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_3935,homalg_variable_3813);;
gap> SI_ncols(homalg_variable_3942);
4
gap> homalg_variable_3943 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3942 = homalg_variable_3943;
false
gap> homalg_variable_3944 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3942);;
gap> SI_ncols(homalg_variable_3944);
1
gap> homalg_variable_3945 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_3944 = homalg_variable_3945;
false
gap> homalg_variable_3946 := SI_\[(homalg_variable_3944,4,1);;
gap> SI_deg( homalg_variable_3946 );
-1
gap> homalg_variable_3947 := SI_\[(homalg_variable_3944,3,1);;
gap> SI_deg( homalg_variable_3947 );
1
gap> homalg_variable_3948 := SI_\[(homalg_variable_3944,2,1);;
gap> SI_deg( homalg_variable_3948 );
1
gap> homalg_variable_3949 := SI_\[(homalg_variable_3944,1,1);;
gap> SI_deg( homalg_variable_3949 );
1
gap> homalg_variable_3950 := SIH_BasisOfColumnModule(homalg_variable_3942);;
gap> SI_ncols(homalg_variable_3950);
4
gap> homalg_variable_3951 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3950 = homalg_variable_3951;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3942);; homalg_variable_3952 := homalg_variable_l[1];; homalg_variable_3953 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3952);
4
gap> homalg_variable_3954 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3952 = homalg_variable_3954;
false
gap> SI_nrows(homalg_variable_3953);
4
gap> homalg_variable_3955 := homalg_variable_3942 * homalg_variable_3953;;
gap> homalg_variable_3952 = homalg_variable_3955;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3950,homalg_variable_3952);; homalg_variable_3956 := homalg_variable_l[1];; homalg_variable_3957 := homalg_variable_l[2];;
gap> homalg_variable_3958 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3956 = homalg_variable_3958;
true
gap> homalg_variable_3959 := homalg_variable_3952 * homalg_variable_3957;;
gap> homalg_variable_3960 := homalg_variable_3950 + homalg_variable_3959;;
gap> homalg_variable_3956 = homalg_variable_3960;
true
gap> homalg_variable_3961 := SIH_DecideZeroColumns(homalg_variable_3950,homalg_variable_3952);;
gap> homalg_variable_3962 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3961 = homalg_variable_3962;
true
gap> homalg_variable_3963 := homalg_variable_3957 * (homalg_variable_8);;
gap> homalg_variable_3964 := homalg_variable_3953 * homalg_variable_3963;;
gap> homalg_variable_3965 := homalg_variable_3942 * homalg_variable_3964;;
gap> homalg_variable_3965 = homalg_variable_3950;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3942,homalg_variable_3950);; homalg_variable_3966 := homalg_variable_l[1];; homalg_variable_3967 := homalg_variable_l[2];;
gap> homalg_variable_3968 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3966 = homalg_variable_3968;
true
gap> homalg_variable_3969 := homalg_variable_3950 * homalg_variable_3967;;
gap> homalg_variable_3970 := homalg_variable_3942 + homalg_variable_3969;;
gap> homalg_variable_3966 = homalg_variable_3970;
true
gap> homalg_variable_3971 := SIH_DecideZeroColumns(homalg_variable_3942,homalg_variable_3950);;
gap> homalg_variable_3972 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3971 = homalg_variable_3972;
true
gap> homalg_variable_3973 := homalg_variable_3967 * (homalg_variable_8);;
gap> homalg_variable_3974 := homalg_variable_3950 * homalg_variable_3973;;
gap> homalg_variable_3974 = homalg_variable_3942;
true
gap> homalg_variable_3975 := SIH_BasisOfColumnModule(homalg_variable_3937);;
gap> SI_ncols(homalg_variable_3975);
4
gap> homalg_variable_3976 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3975 = homalg_variable_3976;
false
gap> homalg_variable_3975 = homalg_variable_3937;
true
gap> homalg_variable_3977 := SIH_DecideZeroColumns(homalg_variable_3942,homalg_variable_3975);;
gap> homalg_variable_3978 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_3977 = homalg_variable_3978;
true
gap> homalg_variable_3979 := SIH_BasisOfColumnModule(homalg_variable_832);;
gap> SI_ncols(homalg_variable_3979);
2
gap> homalg_variable_3980 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3979 = homalg_variable_3980;
false
gap> homalg_variable_3981 := SIH_DecideZeroColumns(homalg_variable_813,homalg_variable_3979);;
gap> homalg_variable_3982 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_3981 = homalg_variable_3982;
true
gap> homalg_variable_3983 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_832);;
gap> SI_ncols(homalg_variable_3983);
5
gap> homalg_variable_3984 := SI_matrix(homalg_variable_5,7,5,"0");;
gap> homalg_variable_3983 = homalg_variable_3984;
false
gap> homalg_variable_3985 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3983);;
gap> SI_ncols(homalg_variable_3985);
1
gap> homalg_variable_3986 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_3985 = homalg_variable_3986;
true
gap> homalg_variable_3987 := SIH_BasisOfColumnModule(homalg_variable_3983);;
gap> SI_ncols(homalg_variable_3987);
7
gap> homalg_variable_3988 := SI_matrix(homalg_variable_5,7,7,"0");;
gap> homalg_variable_3987 = homalg_variable_3988;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_3983);; homalg_variable_3989 := homalg_variable_l[1];; homalg_variable_3990 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_3989);
7
gap> homalg_variable_3991 := SI_matrix(homalg_variable_5,7,7,"0");;
gap> homalg_variable_3989 = homalg_variable_3991;
false
gap> SI_nrows(homalg_variable_3990);
5
gap> homalg_variable_3992 := homalg_variable_3983 * homalg_variable_3990;;
gap> homalg_variable_3989 = homalg_variable_3992;
true
gap> homalg_variable_3989 = homalg_variable_1375;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3987,homalg_variable_3989);; homalg_variable_3993 := homalg_variable_l[1];; homalg_variable_3994 := homalg_variable_l[2];;
gap> homalg_variable_3995 := SI_matrix(homalg_variable_5,7,7,"0");;
gap> homalg_variable_3993 = homalg_variable_3995;
true
gap> homalg_variable_3996 := homalg_variable_3989 * homalg_variable_3994;;
gap> homalg_variable_3997 := homalg_variable_3987 + homalg_variable_3996;;
gap> homalg_variable_3993 = homalg_variable_3997;
true
gap> homalg_variable_3998 := SIH_DecideZeroColumns(homalg_variable_3987,homalg_variable_3989);;
gap> homalg_variable_3999 := SI_matrix(homalg_variable_5,7,7,"0");;
gap> homalg_variable_3998 = homalg_variable_3999;
true
gap> homalg_variable_4000 := homalg_variable_3994 * (homalg_variable_8);;
gap> for _del in [ "homalg_variable_3493", "homalg_variable_3496", "homalg_variable_3497", "homalg_variable_3498", "homalg_variable_3499", "homalg_variable_3501", "homalg_variable_3502", "homalg_variable_3503", "homalg_variable_3505", "homalg_variable_3508", "homalg_variable_3509", "homalg_variable_3510", "homalg_variable_3511", "homalg_variable_3512", "homalg_variable_3513", "homalg_variable_3514", "homalg_variable_3515", "homalg_variable_3516", "homalg_variable_3517", "homalg_variable_3518", "homalg_variable_3519", "homalg_variable_3520", "homalg_variable_3521", "homalg_variable_3522", "homalg_variable_3523", "homalg_variable_3524", "homalg_variable_3525", "homalg_variable_3526", "homalg_variable_3527", "homalg_variable_3528", "homalg_variable_3530", "homalg_variable_3531", "homalg_variable_3532", "homalg_variable_3533", "homalg_variable_3534", "homalg_variable_3536", "homalg_variable_3537", "homalg_variable_3538", "homalg_variable_3540", "homalg_variable_3543", "homalg_variable_3544", "homalg_variable_3545", "homalg_variable_3546", "homalg_variable_3547", "homalg_variable_3548", "homalg_variable_3549", "homalg_variable_3550", "homalg_variable_3551", "homalg_variable_3552", "homalg_variable_3553", "homalg_variable_3554", "homalg_variable_3555", "homalg_variable_3556", "homalg_variable_3557", "homalg_variable_3558", "homalg_variable_3559", "homalg_variable_3560", "homalg_variable_3561", "homalg_variable_3562", "homalg_variable_3563", "homalg_variable_3565", "homalg_variable_3566", "homalg_variable_3567", "homalg_variable_3569", "homalg_variable_3571", "homalg_variable_3574", "homalg_variable_3575", "homalg_variable_3576", "homalg_variable_3577", "homalg_variable_3578", "homalg_variable_3579", "homalg_variable_3580", "homalg_variable_3581", "homalg_variable_3582", "homalg_variable_3583", "homalg_variable_3584", "homalg_variable_3585", "homalg_variable_3586", "homalg_variable_3587", "homalg_variable_3588", "homalg_variable_3589", "homalg_variable_3590", "homalg_variable_3591", "homalg_variable_3592", "homalg_variable_3593", "homalg_variable_3594", "homalg_variable_3596", "homalg_variable_3597", "homalg_variable_3598", "homalg_variable_3599", "homalg_variable_3600", "homalg_variable_3601", "homalg_variable_3602", "homalg_variable_3605", "homalg_variable_3606", "homalg_variable_3607", "homalg_variable_3608", "homalg_variable_3614", "homalg_variable_3617", "homalg_variable_3618", "homalg_variable_3619", "homalg_variable_3620", "homalg_variable_3622", "homalg_variable_3623", "homalg_variable_3624", "homalg_variable_3625", "homalg_variable_3626", "homalg_variable_3629", "homalg_variable_3630", "homalg_variable_3633", "homalg_variable_3634", "homalg_variable_3637", "homalg_variable_3639", "homalg_variable_3640", "homalg_variable_3641", "homalg_variable_3642", "homalg_variable_3643", "homalg_variable_3644", "homalg_variable_3646", "homalg_variable_3647", "homalg_variable_3648", "homalg_variable_3652", "homalg_variable_3658", "homalg_variable_3659", "homalg_variable_3660", "homalg_variable_3661", "homalg_variable_3662", "homalg_variable_3663", "homalg_variable_3667", "homalg_variable_3668", "homalg_variable_3671", "homalg_variable_3672", "homalg_variable_3673", "homalg_variable_3674", "homalg_variable_3675", "homalg_variable_3676", "homalg_variable_3680", "homalg_variable_3681", "homalg_variable_3682", "homalg_variable_3685", "homalg_variable_3686", "homalg_variable_3687", "homalg_variable_3690", "homalg_variable_3691", "homalg_variable_3692", "homalg_variable_3694", "homalg_variable_3696", "homalg_variable_3697", "homalg_variable_3698", "homalg_variable_3699", "homalg_variable_3700", "homalg_variable_3702", "homalg_variable_3703", "homalg_variable_3704", "homalg_variable_3705", "homalg_variable_3706", "homalg_variable_3707", "homalg_variable_3708", "homalg_variable_3710", "homalg_variable_3713", "homalg_variable_3714", "homalg_variable_3715", "homalg_variable_3716", "homalg_variable_3717", "homalg_variable_3718", "homalg_variable_3719", "homalg_variable_3720", "homalg_variable_3721", "homalg_variable_3722", "homalg_variable_3723", "homalg_variable_3724", "homalg_variable_3725", "homalg_variable_3726", "homalg_variable_3727", "homalg_variable_3728", "homalg_variable_3729", "homalg_variable_3730", "homalg_variable_3731", "homalg_variable_3732", "homalg_variable_3733", "homalg_variable_3735", "homalg_variable_3737", "homalg_variable_3738", "homalg_variable_3739", "homalg_variable_3740", "homalg_variable_3742", "homalg_variable_3744", "homalg_variable_3745", "homalg_variable_3746", "homalg_variable_3747", "homalg_variable_3748", "homalg_variable_3749", "homalg_variable_3751", "homalg_variable_3754", "homalg_variable_3755", "homalg_variable_3756", "homalg_variable_3757", "homalg_variable_3758", "homalg_variable_3759", "homalg_variable_3760", "homalg_variable_3761", "homalg_variable_3762", "homalg_variable_3763", "homalg_variable_3764", "homalg_variable_3765", "homalg_variable_3766", "homalg_variable_3767", "homalg_variable_3768", "homalg_variable_3769", "homalg_variable_3770", "homalg_variable_3771", "homalg_variable_3772", "homalg_variable_3773", "homalg_variable_3774", "homalg_variable_3776", "homalg_variable_3777", "homalg_variable_3778", "homalg_variable_3780", "homalg_variable_3782", "homalg_variable_3783", "homalg_variable_3784", "homalg_variable_3785", "homalg_variable_3787", "homalg_variable_3790", "homalg_variable_3791", "homalg_variable_3792", "homalg_variable_3793", "homalg_variable_3794", "homalg_variable_3795", "homalg_variable_3796", "homalg_variable_3797", "homalg_variable_3798", "homalg_variable_3799", "homalg_variable_3800", "homalg_variable_3801", "homalg_variable_3802", "homalg_variable_3803", "homalg_variable_3804", "homalg_variable_3805", "homalg_variable_3806", "homalg_variable_3807", "homalg_variable_3808", "homalg_variable_3809", "homalg_variable_3810", "homalg_variable_3811", "homalg_variable_3812", "homalg_variable_3814", "homalg_variable_3817", "homalg_variable_3821", "homalg_variable_3822", "homalg_variable_3823", "homalg_variable_3824", "homalg_variable_3825", "homalg_variable_3828", "homalg_variable_3829", "homalg_variable_3830", "homalg_variable_3831", "homalg_variable_3832", "homalg_variable_3833", "homalg_variable_3834", "homalg_variable_3835", "homalg_variable_3836", "homalg_variable_3837", "homalg_variable_3840", "homalg_variable_3841", "homalg_variable_3844", "homalg_variable_3845", "homalg_variable_3846", "homalg_variable_3848", "homalg_variable_3849", "homalg_variable_3850", "homalg_variable_3851", "homalg_variable_3852", "homalg_variable_3853", "homalg_variable_3854", "homalg_variable_3861", "homalg_variable_3862", "homalg_variable_3863", "homalg_variable_3865", "homalg_variable_3866", "homalg_variable_3867", "homalg_variable_3868", "homalg_variable_3869", "homalg_variable_3870", "homalg_variable_3871", "homalg_variable_3872", "homalg_variable_3873", "homalg_variable_3875", "homalg_variable_3876", "homalg_variable_3877", "homalg_variable_3878", "homalg_variable_3879", "homalg_variable_3885", "homalg_variable_3888", "homalg_variable_3889", "homalg_variable_3890", "homalg_variable_3892", "homalg_variable_3894", "homalg_variable_3895", "homalg_variable_3896", "homalg_variable_3897", "homalg_variable_3898", "homalg_variable_3899", "homalg_variable_3900", "homalg_variable_3901", "homalg_variable_3902", "homalg_variable_3903", "homalg_variable_3904", "homalg_variable_3905", "homalg_variable_3906", "homalg_variable_3907", "homalg_variable_3908", "homalg_variable_3909", "homalg_variable_3911", "homalg_variable_3914", "homalg_variable_3915", "homalg_variable_3916", "homalg_variable_3917", "homalg_variable_3918", "homalg_variable_3919", "homalg_variable_3920", "homalg_variable_3921", "homalg_variable_3922", "homalg_variable_3923", "homalg_variable_3924", "homalg_variable_3925", "homalg_variable_3928", "homalg_variable_3929", "homalg_variable_3930", "homalg_variable_3931", "homalg_variable_3932", "homalg_variable_3934", "homalg_variable_3936", "homalg_variable_3938", "homalg_variable_3939", "homalg_variable_3940", "homalg_variable_3941", "homalg_variable_3943", "homalg_variable_3945", "homalg_variable_3946", "homalg_variable_3947", "homalg_variable_3948", "homalg_variable_3949", "homalg_variable_3951", "homalg_variable_3954", "homalg_variable_3955", "homalg_variable_3958", "homalg_variable_3959", "homalg_variable_3960", "homalg_variable_3961", "homalg_variable_3962", "homalg_variable_3966", "homalg_variable_3967", "homalg_variable_3968", "homalg_variable_3969", "homalg_variable_3970", "homalg_variable_3971", "homalg_variable_3972", "homalg_variable_3973", "homalg_variable_3974", "homalg_variable_3976", "homalg_variable_3977", "homalg_variable_3978", "homalg_variable_3980" ] do UnbindGlobal( _del );; od;;
gap> homalg_variable_4001 := homalg_variable_3990 * homalg_variable_4000;;
gap> homalg_variable_4002 := homalg_variable_3983 * homalg_variable_4001;;
gap> homalg_variable_4002 = homalg_variable_3987;
true
gap> homalg_variable_3987 = homalg_variable_1375;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_3983,homalg_variable_3987);; homalg_variable_4003 := homalg_variable_l[1];; homalg_variable_4004 := homalg_variable_l[2];;
gap> homalg_variable_4005 := SI_matrix(homalg_variable_5,7,5,"0");;
gap> homalg_variable_4003 = homalg_variable_4005;
true
gap> homalg_variable_4006 := homalg_variable_3987 * homalg_variable_4004;;
gap> homalg_variable_4007 := homalg_variable_3983 + homalg_variable_4006;;
gap> homalg_variable_4003 = homalg_variable_4007;
true
gap> homalg_variable_4008 := SIH_DecideZeroColumns(homalg_variable_3983,homalg_variable_3987);;
gap> homalg_variable_4009 := SI_matrix(homalg_variable_5,7,5,"0");;
gap> homalg_variable_4008 = homalg_variable_4009;
true
gap> homalg_variable_4010 := homalg_variable_4004 * (homalg_variable_8);;
gap> homalg_variable_4011 := homalg_variable_3987 * homalg_variable_4010;;
gap> homalg_variable_4011 = homalg_variable_3983;
true
gap> SIH_ZeroColumns(homalg_variable_3983);
[  ]
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_765,homalg_variable_3989);; homalg_variable_4012 := homalg_variable_l[1];; homalg_variable_4013 := homalg_variable_l[2];;
gap> homalg_variable_4014 := SI_matrix(homalg_variable_5,7,5,"0");;
gap> homalg_variable_4012 = homalg_variable_4014;
true
gap> homalg_variable_4015 := homalg_variable_3989 * homalg_variable_4013;;
gap> homalg_variable_4016 := homalg_variable_765 + homalg_variable_4015;;
gap> homalg_variable_4012 = homalg_variable_4016;
true
gap> homalg_variable_4017 := SIH_DecideZeroColumns(homalg_variable_765,homalg_variable_3989);;
gap> homalg_variable_4018 := SI_matrix(homalg_variable_5,7,5,"0");;
gap> homalg_variable_4017 = homalg_variable_4018;
true
gap> SI_nrows(homalg_variable_3990);
5
gap> SI_ncols(homalg_variable_3990);
7
gap> homalg_variable_4019 := homalg_variable_4013 * (homalg_variable_8);;
gap> homalg_variable_4020 := homalg_variable_3990 * homalg_variable_4019;;
gap> homalg_variable_4021 := homalg_variable_3983 * homalg_variable_4020;;
gap> homalg_variable_4022 := homalg_variable_4021 - homalg_variable_765;;
gap> homalg_variable_4023 := SI_matrix(homalg_variable_5,7,5,"0");;
gap> homalg_variable_4022 = homalg_variable_4023;
true
gap> homalg_variable_4024 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4020);;
gap> SI_ncols(homalg_variable_4024);
1
gap> homalg_variable_4025 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_4024 = homalg_variable_4025;
true
gap> homalg_variable_4026 := SIH_BasisOfColumnModule(homalg_variable_3155);;
gap> SI_ncols(homalg_variable_4026);
2
gap> homalg_variable_4027 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_4026 = homalg_variable_4027;
false
gap> homalg_variable_4028 := SIH_DecideZeroColumns(homalg_variable_813,homalg_variable_4026);;
gap> homalg_variable_4029 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_4028 = homalg_variable_4029;
true
gap> homalg_variable_4030 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3155);;
gap> SI_ncols(homalg_variable_4030);
8
gap> homalg_variable_4031 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_4030 = homalg_variable_4031;
false
gap> homalg_variable_4032 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4030);;
gap> SI_ncols(homalg_variable_4032);
1
gap> homalg_variable_4033 := SI_matrix(homalg_variable_5,8,1,"0");;
gap> homalg_variable_4032 = homalg_variable_4033;
true
gap> homalg_variable_4034 := SIH_BasisOfColumnModule(homalg_variable_4030);;
gap> SI_ncols(homalg_variable_4034);
12
gap> homalg_variable_4035 := SI_matrix(homalg_variable_5,10,12,"0");;
gap> homalg_variable_4034 = homalg_variable_4035;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4030);; homalg_variable_4036 := homalg_variable_l[1];; homalg_variable_4037 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4036);
12
gap> homalg_variable_4038 := SI_matrix(homalg_variable_5,10,12,"0");;
gap> homalg_variable_4036 = homalg_variable_4038;
false
gap> SI_nrows(homalg_variable_4037);
8
gap> homalg_variable_4039 := homalg_variable_4030 * homalg_variable_4037;;
gap> homalg_variable_4036 = homalg_variable_4039;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4034,homalg_variable_4036);; homalg_variable_4040 := homalg_variable_l[1];; homalg_variable_4041 := homalg_variable_l[2];;
gap> homalg_variable_4042 := SI_matrix(homalg_variable_5,10,12,"0");;
gap> homalg_variable_4040 = homalg_variable_4042;
true
gap> homalg_variable_4043 := homalg_variable_4036 * homalg_variable_4041;;
gap> homalg_variable_4044 := homalg_variable_4034 + homalg_variable_4043;;
gap> homalg_variable_4040 = homalg_variable_4044;
true
gap> homalg_variable_4045 := SIH_DecideZeroColumns(homalg_variable_4034,homalg_variable_4036);;
gap> homalg_variable_4046 := SI_matrix(homalg_variable_5,10,12,"0");;
gap> homalg_variable_4045 = homalg_variable_4046;
true
gap> homalg_variable_4047 := homalg_variable_4041 * (homalg_variable_8);;
gap> homalg_variable_4048 := homalg_variable_4037 * homalg_variable_4047;;
gap> homalg_variable_4049 := homalg_variable_4030 * homalg_variable_4048;;
gap> homalg_variable_4049 = homalg_variable_4034;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4030,homalg_variable_4034);; homalg_variable_4050 := homalg_variable_l[1];; homalg_variable_4051 := homalg_variable_l[2];;
gap> homalg_variable_4052 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_4050 = homalg_variable_4052;
true
gap> homalg_variable_4053 := homalg_variable_4034 * homalg_variable_4051;;
gap> homalg_variable_4054 := homalg_variable_4030 + homalg_variable_4053;;
gap> homalg_variable_4050 = homalg_variable_4054;
true
gap> homalg_variable_4055 := SIH_DecideZeroColumns(homalg_variable_4030,homalg_variable_4034);;
gap> homalg_variable_4056 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_4055 = homalg_variable_4056;
true
gap> homalg_variable_4057 := homalg_variable_4051 * (homalg_variable_8);;
gap> homalg_variable_4058 := homalg_variable_4034 * homalg_variable_4057;;
gap> homalg_variable_4058 = homalg_variable_4030;
true
gap> homalg_variable_4059 := SIH_BasisOfColumnModule(homalg_variable_3250);;
gap> SI_ncols(homalg_variable_4059);
12
gap> homalg_variable_4060 := SI_matrix(homalg_variable_5,10,12,"0");;
gap> homalg_variable_4059 = homalg_variable_4060;
false
gap> homalg_variable_4061 := SIH_DecideZeroColumns(homalg_variable_4030,homalg_variable_4059);;
gap> homalg_variable_4062 := SI_matrix(homalg_variable_5,10,8,"0");;
gap> homalg_variable_4061 = homalg_variable_4062;
true
gap> homalg_variable_4063 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3250);;
gap> SI_ncols(homalg_variable_4063);
6
gap> homalg_variable_4064 := SI_matrix(homalg_variable_5,14,6,"0");;
gap> homalg_variable_4063 = homalg_variable_4064;
false
gap> homalg_variable_4065 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4063);;
gap> SI_ncols(homalg_variable_4065);
1
gap> homalg_variable_4066 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_4065 = homalg_variable_4066;
true
gap> homalg_variable_4067 := SIH_BasisOfColumnModule(homalg_variable_4063);;
gap> SI_ncols(homalg_variable_4067);
10
gap> homalg_variable_4068 := SI_matrix(homalg_variable_5,14,10,"0");;
gap> homalg_variable_4067 = homalg_variable_4068;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4063);; homalg_variable_4069 := homalg_variable_l[1];; homalg_variable_4070 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4069);
10
gap> homalg_variable_4071 := SI_matrix(homalg_variable_5,14,10,"0");;
gap> homalg_variable_4069 = homalg_variable_4071;
false
gap> SI_nrows(homalg_variable_4070);
6
gap> homalg_variable_4072 := homalg_variable_4063 * homalg_variable_4070;;
gap> homalg_variable_4069 = homalg_variable_4072;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4067,homalg_variable_4069);; homalg_variable_4073 := homalg_variable_l[1];; homalg_variable_4074 := homalg_variable_l[2];;
gap> homalg_variable_4075 := SI_matrix(homalg_variable_5,14,10,"0");;
gap> homalg_variable_4073 = homalg_variable_4075;
true
gap> homalg_variable_4076 := homalg_variable_4069 * homalg_variable_4074;;
gap> homalg_variable_4077 := homalg_variable_4067 + homalg_variable_4076;;
gap> homalg_variable_4073 = homalg_variable_4077;
true
gap> homalg_variable_4078 := SIH_DecideZeroColumns(homalg_variable_4067,homalg_variable_4069);;
gap> homalg_variable_4079 := SI_matrix(homalg_variable_5,14,10,"0");;
gap> homalg_variable_4078 = homalg_variable_4079;
true
gap> homalg_variable_4080 := homalg_variable_4074 * (homalg_variable_8);;
gap> homalg_variable_4081 := homalg_variable_4070 * homalg_variable_4080;;
gap> homalg_variable_4082 := homalg_variable_4063 * homalg_variable_4081;;
gap> homalg_variable_4082 = homalg_variable_4067;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4063,homalg_variable_4067);; homalg_variable_4083 := homalg_variable_l[1];; homalg_variable_4084 := homalg_variable_l[2];;
gap> homalg_variable_4085 := SI_matrix(homalg_variable_5,14,6,"0");;
gap> homalg_variable_4083 = homalg_variable_4085;
true
gap> homalg_variable_4086 := homalg_variable_4067 * homalg_variable_4084;;
gap> homalg_variable_4087 := homalg_variable_4063 + homalg_variable_4086;;
gap> homalg_variable_4083 = homalg_variable_4087;
true
gap> homalg_variable_4088 := SIH_DecideZeroColumns(homalg_variable_4063,homalg_variable_4067);;
gap> homalg_variable_4089 := SI_matrix(homalg_variable_5,14,6,"0");;
gap> homalg_variable_4088 = homalg_variable_4089;
true
gap> homalg_variable_4090 := homalg_variable_4084 * (homalg_variable_8);;
gap> homalg_variable_4091 := homalg_variable_4067 * homalg_variable_4090;;
gap> homalg_variable_4091 = homalg_variable_4063;
true
gap> SIH_ZeroColumns(homalg_variable_4063);
[  ]
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_1256,homalg_variable_4069);; homalg_variable_4092 := homalg_variable_l[1];; homalg_variable_4093 := homalg_variable_l[2];;
gap> homalg_variable_4094 := SI_matrix(homalg_variable_5,14,6,"0");;
gap> homalg_variable_4092 = homalg_variable_4094;
true
gap> homalg_variable_4095 := homalg_variable_4069 * homalg_variable_4093;;
gap> homalg_variable_4096 := homalg_variable_1256 + homalg_variable_4095;;
gap> homalg_variable_4092 = homalg_variable_4096;
true
gap> homalg_variable_4097 := SIH_DecideZeroColumns(homalg_variable_1256,homalg_variable_4069);;
gap> homalg_variable_4098 := SI_matrix(homalg_variable_5,14,6,"0");;
gap> homalg_variable_4097 = homalg_variable_4098;
true
gap> SI_nrows(homalg_variable_4070);
6
gap> SI_ncols(homalg_variable_4070);
10
gap> homalg_variable_4099 := homalg_variable_4093 * (homalg_variable_8);;
gap> homalg_variable_4100 := homalg_variable_4070 * homalg_variable_4099;;
gap> homalg_variable_4101 := homalg_variable_4063 * homalg_variable_4100;;
gap> homalg_variable_4102 := homalg_variable_4101 - homalg_variable_1256;;
gap> homalg_variable_4103 := SI_matrix(homalg_variable_5,14,6,"0");;
gap> homalg_variable_4102 = homalg_variable_4103;
true
gap> homalg_variable_4104 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4100);;
gap> SI_ncols(homalg_variable_4104);
1
gap> homalg_variable_4105 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_4104 = homalg_variable_4105;
true
gap> homalg_variable_4106 := SIH_BasisOfColumnModule(homalg_variable_2442);;
gap> SI_ncols(homalg_variable_4106);
1
gap> homalg_variable_4107 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_4106 = homalg_variable_4107;
false
gap> homalg_variable_4108 := SIH_DecideZeroColumns(homalg_variable_237,homalg_variable_4106);;
gap> homalg_variable_4109 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_4108 = homalg_variable_4109;
true
gap> homalg_variable_4110 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2442);;
gap> SI_ncols(homalg_variable_4110);
4
gap> homalg_variable_4111 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4110 = homalg_variable_4111;
false
gap> homalg_variable_4112 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4110);;
gap> SI_ncols(homalg_variable_4112);
1
gap> homalg_variable_4113 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4112 = homalg_variable_4113;
true
gap> homalg_variable_4114 := SIH_BasisOfColumnModule(homalg_variable_4110);;
gap> SI_ncols(homalg_variable_4114);
7
gap> homalg_variable_4115 := SI_matrix(homalg_variable_5,5,7,"0");;
gap> homalg_variable_4114 = homalg_variable_4115;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4110);; homalg_variable_4116 := homalg_variable_l[1];; homalg_variable_4117 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4116);
7
gap> homalg_variable_4118 := SI_matrix(homalg_variable_5,5,7,"0");;
gap> homalg_variable_4116 = homalg_variable_4118;
false
gap> SI_nrows(homalg_variable_4117);
4
gap> homalg_variable_4119 := homalg_variable_4110 * homalg_variable_4117;;
gap> homalg_variable_4116 = homalg_variable_4119;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4114,homalg_variable_4116);; homalg_variable_4120 := homalg_variable_l[1];; homalg_variable_4121 := homalg_variable_l[2];;
gap> homalg_variable_4122 := SI_matrix(homalg_variable_5,5,7,"0");;
gap> homalg_variable_4120 = homalg_variable_4122;
true
gap> homalg_variable_4123 := homalg_variable_4116 * homalg_variable_4121;;
gap> homalg_variable_4124 := homalg_variable_4114 + homalg_variable_4123;;
gap> homalg_variable_4120 = homalg_variable_4124;
true
gap> homalg_variable_4125 := SIH_DecideZeroColumns(homalg_variable_4114,homalg_variable_4116);;
gap> homalg_variable_4126 := SI_matrix(homalg_variable_5,5,7,"0");;
gap> homalg_variable_4125 = homalg_variable_4126;
true
gap> homalg_variable_4127 := homalg_variable_4121 * (homalg_variable_8);;
gap> homalg_variable_4128 := homalg_variable_4117 * homalg_variable_4127;;
gap> homalg_variable_4129 := homalg_variable_4110 * homalg_variable_4128;;
gap> homalg_variable_4129 = homalg_variable_4114;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4110,homalg_variable_4114);; homalg_variable_4130 := homalg_variable_l[1];; homalg_variable_4131 := homalg_variable_l[2];;
gap> homalg_variable_4132 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4130 = homalg_variable_4132;
true
gap> homalg_variable_4133 := homalg_variable_4114 * homalg_variable_4131;;
gap> homalg_variable_4134 := homalg_variable_4110 + homalg_variable_4133;;
gap> homalg_variable_4130 = homalg_variable_4134;
true
gap> homalg_variable_4135 := SIH_DecideZeroColumns(homalg_variable_4110,homalg_variable_4114);;
gap> homalg_variable_4136 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4135 = homalg_variable_4136;
true
gap> homalg_variable_4137 := homalg_variable_4131 * (homalg_variable_8);;
gap> homalg_variable_4138 := homalg_variable_4114 * homalg_variable_4137;;
gap> homalg_variable_4138 = homalg_variable_4110;
true
gap> homalg_variable_4139 := SIH_BasisOfColumnModule(homalg_variable_2346);;
gap> SI_ncols(homalg_variable_4139);
7
gap> homalg_variable_4140 := SI_matrix(homalg_variable_5,5,7,"0");;
gap> homalg_variable_4139 = homalg_variable_4140;
false
gap> homalg_variable_4141 := SIH_DecideZeroColumns(homalg_variable_4110,homalg_variable_4139);;
gap> homalg_variable_4142 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4141 = homalg_variable_4142;
true
gap> homalg_variable_4143 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2346);;
gap> SI_ncols(homalg_variable_4143);
9
gap> homalg_variable_4144 := SI_matrix(homalg_variable_5,10,9,"0");;
gap> homalg_variable_4143 = homalg_variable_4144;
false
gap> homalg_variable_4145 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4143);;
gap> SI_ncols(homalg_variable_4145);
4
gap> homalg_variable_4146 := SI_matrix(homalg_variable_5,9,4,"0");;
gap> homalg_variable_4145 = homalg_variable_4146;
false
gap> homalg_variable_4147 := SI_\[(homalg_variable_4145,9,1);;
gap> SI_deg( homalg_variable_4147 );
1
gap> homalg_variable_4148 := SI_\[(homalg_variable_4145,8,1);;
gap> SI_deg( homalg_variable_4148 );
-1
gap> homalg_variable_4149 := SI_\[(homalg_variable_4145,7,1);;
gap> SI_deg( homalg_variable_4149 );
-1
gap> homalg_variable_4150 := SI_\[(homalg_variable_4145,6,1);;
gap> SI_deg( homalg_variable_4150 );
1
gap> homalg_variable_4151 := SI_\[(homalg_variable_4145,5,1);;
gap> SI_deg( homalg_variable_4151 );
-1
gap> homalg_variable_4152 := SI_\[(homalg_variable_4145,4,1);;
gap> SI_deg( homalg_variable_4152 );
-1
gap> homalg_variable_4153 := SI_\[(homalg_variable_4145,3,1);;
gap> SI_deg( homalg_variable_4153 );
0
gap> homalg_variable_4154 := SI_\[(homalg_variable_4145,1,1);;
gap> IsZero(homalg_variable_4154);
true
gap> homalg_variable_4155 := SI_\[(homalg_variable_4145,2,1);;
gap> IsZero(homalg_variable_4155);
true
gap> homalg_variable_4156 := SI_\[(homalg_variable_4145,3,1);;
gap> IsZero(homalg_variable_4156);
false
gap> homalg_variable_4157 := SI_\[(homalg_variable_4145,4,1);;
gap> IsZero(homalg_variable_4157);
true
gap> homalg_variable_4158 := SI_\[(homalg_variable_4145,5,1);;
gap> IsZero(homalg_variable_4158);
true
gap> homalg_variable_4159 := SI_\[(homalg_variable_4145,6,1);;
gap> IsZero(homalg_variable_4159);
false
gap> homalg_variable_4160 := SI_\[(homalg_variable_4145,7,1);;
gap> IsZero(homalg_variable_4160);
true
gap> homalg_variable_4161 := SI_\[(homalg_variable_4145,8,1);;
gap> IsZero(homalg_variable_4161);
true
gap> homalg_variable_4162 := SI_\[(homalg_variable_4145,9,1);;
gap> IsZero(homalg_variable_4162);
false
gap> homalg_variable_4163 := SI_\[(homalg_variable_4145,8,2);;
gap> SI_deg( homalg_variable_4163 );
-1
gap> homalg_variable_4164 := SI_\[(homalg_variable_4145,7,2);;
gap> SI_deg( homalg_variable_4164 );
-1
gap> homalg_variable_4165 := SI_\[(homalg_variable_4145,5,2);;
gap> SI_deg( homalg_variable_4165 );
-1
gap> homalg_variable_4166 := SI_\[(homalg_variable_4145,4,2);;
gap> SI_deg( homalg_variable_4166 );
1
gap> homalg_variable_4167 := SI_\[(homalg_variable_4145,2,2);;
gap> SI_deg( homalg_variable_4167 );
-1
gap> homalg_variable_4168 := SI_\[(homalg_variable_4145,1,2);;
gap> SI_deg( homalg_variable_4168 );
1
gap> homalg_variable_4169 := SI_\[(homalg_variable_4145,8,3);;
gap> SI_deg( homalg_variable_4169 );
-1
gap> homalg_variable_4170 := SI_\[(homalg_variable_4145,7,3);;
gap> SI_deg( homalg_variable_4170 );
1
gap> homalg_variable_4171 := SI_\[(homalg_variable_4145,5,3);;
gap> SI_deg( homalg_variable_4171 );
-1
gap> homalg_variable_4172 := SI_\[(homalg_variable_4145,4,3);;
gap> SI_deg( homalg_variable_4172 );
-1
gap> homalg_variable_4173 := SI_\[(homalg_variable_4145,2,3);;
gap> SI_deg( homalg_variable_4173 );
3
gap> homalg_variable_4174 := SI_\[(homalg_variable_4145,1,3);;
gap> SI_deg( homalg_variable_4174 );
0
gap> homalg_variable_4175 := SI_\[(homalg_variable_4145,1,3);;
gap> IsZero(homalg_variable_4175);
false
gap> homalg_variable_4176 := SI_\[(homalg_variable_4145,2,3);;
gap> IsZero(homalg_variable_4176);
false
gap> homalg_variable_4177 := SI_\[(homalg_variable_4145,4,3);;
gap> IsZero(homalg_variable_4177);
true
gap> homalg_variable_4178 := SI_\[(homalg_variable_4145,5,3);;
gap> IsZero(homalg_variable_4178);
true
gap> homalg_variable_4179 := SI_\[(homalg_variable_4145,7,3);;
gap> IsZero(homalg_variable_4179);
false
gap> homalg_variable_4180 := SI_\[(homalg_variable_4145,8,3);;
gap> IsZero(homalg_variable_4180);
true
gap> homalg_variable_4181 := SI_\[(homalg_variable_4145,8,4);;
gap> SI_deg( homalg_variable_4181 );
-1
gap> homalg_variable_4182 := SI_\[(homalg_variable_4145,5,4);;
gap> SI_deg( homalg_variable_4182 );
-1
gap> homalg_variable_4183 := SI_\[(homalg_variable_4145,4,4);;
gap> SI_deg( homalg_variable_4183 );
0
gap> homalg_variable_4184 := SI_\[(homalg_variable_4145,4,4);;
gap> IsZero(homalg_variable_4184);
false
gap> homalg_variable_4185 := SI_\[(homalg_variable_4145,5,4);;
gap> IsZero(homalg_variable_4185);
true
gap> homalg_variable_4186 := SI_\[(homalg_variable_4145,8,4);;
gap> IsZero(homalg_variable_4186);
true
gap> homalg_variable_4188 := SIH_Submatrix(homalg_variable_4143,[1..10],[ 2, 5, 6, 7, 8, 9 ]);;
gap> homalg_variable_4187 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4188);;
gap> SI_ncols(homalg_variable_4187);
1
gap> homalg_variable_4189 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_4187 = homalg_variable_4189;
true
gap> homalg_variable_4190 := SIH_BasisOfColumnModule(homalg_variable_4143);;
gap> SI_ncols(homalg_variable_4190);
10
gap> homalg_variable_4191 := SI_matrix(homalg_variable_5,10,10,"0");;
gap> homalg_variable_4190 = homalg_variable_4191;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4188);; homalg_variable_4192 := homalg_variable_l[1];; homalg_variable_4193 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4192);
10
gap> homalg_variable_4194 := SI_matrix(homalg_variable_5,10,10,"0");;
gap> homalg_variable_4192 = homalg_variable_4194;
false
gap> SI_nrows(homalg_variable_4193);
6
gap> homalg_variable_4195 := homalg_variable_4188 * homalg_variable_4193;;
gap> homalg_variable_4192 = homalg_variable_4195;
true
gap> homalg_variable_4196 := SI_matrix( SI_freemodule( homalg_variable_5,10 ) );;
gap> homalg_variable_4192 = homalg_variable_4196;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4190,homalg_variable_4192);; homalg_variable_4197 := homalg_variable_l[1];; homalg_variable_4198 := homalg_variable_l[2];;
gap> homalg_variable_4199 := SI_matrix(homalg_variable_5,10,10,"0");;
gap> homalg_variable_4197 = homalg_variable_4199;
true
gap> homalg_variable_4200 := homalg_variable_4192 * homalg_variable_4198;;
gap> homalg_variable_4201 := homalg_variable_4190 + homalg_variable_4200;;
gap> homalg_variable_4197 = homalg_variable_4201;
true
gap> homalg_variable_4202 := SIH_DecideZeroColumns(homalg_variable_4190,homalg_variable_4192);;
gap> homalg_variable_4203 := SI_matrix(homalg_variable_5,10,10,"0");;
gap> homalg_variable_4202 = homalg_variable_4203;
true
gap> homalg_variable_4204 := homalg_variable_4198 * (homalg_variable_8);;
gap> homalg_variable_4205 := homalg_variable_4193 * homalg_variable_4204;;
gap> homalg_variable_4206 := homalg_variable_4188 * homalg_variable_4205;;
gap> homalg_variable_4206 = homalg_variable_4190;
true
gap> homalg_variable_4190 = homalg_variable_4196;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4188,homalg_variable_4190);; homalg_variable_4207 := homalg_variable_l[1];; homalg_variable_4208 := homalg_variable_l[2];;
gap> homalg_variable_4209 := SI_matrix(homalg_variable_5,10,6,"0");;
gap> homalg_variable_4207 = homalg_variable_4209;
true
gap> homalg_variable_4210 := homalg_variable_4190 * homalg_variable_4208;;
gap> homalg_variable_4211 := homalg_variable_4188 + homalg_variable_4210;;
gap> homalg_variable_4207 = homalg_variable_4211;
true
gap> homalg_variable_4212 := SIH_DecideZeroColumns(homalg_variable_4188,homalg_variable_4190);;
gap> homalg_variable_4213 := SI_matrix(homalg_variable_5,10,6,"0");;
gap> homalg_variable_4212 = homalg_variable_4213;
true
gap> homalg_variable_4214 := homalg_variable_4208 * (homalg_variable_8);;
gap> homalg_variable_4215 := homalg_variable_4190 * homalg_variable_4214;;
gap> homalg_variable_4215 = homalg_variable_4188;
true
gap> homalg_variable_4216 := SIH_BasisOfColumnModule(homalg_variable_2229);;
gap> SI_ncols(homalg_variable_4216);
10
gap> homalg_variable_4217 := SI_matrix(homalg_variable_5,10,10,"0");;
gap> homalg_variable_4216 = homalg_variable_4217;
false
gap> homalg_variable_4216 = homalg_variable_2229;
false
gap> homalg_variable_4218 := SIH_DecideZeroColumns(homalg_variable_4188,homalg_variable_4216);;
gap> homalg_variable_4219 := SI_matrix(homalg_variable_5,10,6,"0");;
gap> homalg_variable_4218 = homalg_variable_4219;
true
gap> homalg_variable_4220 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_2229);;
gap> SI_ncols(homalg_variable_4220);
5
gap> homalg_variable_4221 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_4220 = homalg_variable_4221;
false
gap> homalg_variable_4222 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4220);;
gap> SI_ncols(homalg_variable_4222);
1
gap> homalg_variable_4223 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_4222 = homalg_variable_4223;
false
gap> homalg_variable_4224 := SI_\[(homalg_variable_4222,5,1);;
gap> SI_deg( homalg_variable_4224 );
1
gap> homalg_variable_4225 := SI_\[(homalg_variable_4222,4,1);;
gap> SI_deg( homalg_variable_4225 );
1
gap> homalg_variable_4226 := SI_\[(homalg_variable_4222,3,1);;
gap> SI_deg( homalg_variable_4226 );
1
gap> homalg_variable_4227 := SI_\[(homalg_variable_4222,2,1);;
gap> SI_deg( homalg_variable_4227 );
0
gap> homalg_variable_4228 := SI_\[(homalg_variable_4222,1,1);;
gap> IsZero(homalg_variable_4228);
true
gap> homalg_variable_4229 := SI_\[(homalg_variable_4222,2,1);;
gap> IsZero(homalg_variable_4229);
false
gap> homalg_variable_4230 := SI_\[(homalg_variable_4222,3,1);;
gap> IsZero(homalg_variable_4230);
false
gap> homalg_variable_4231 := SI_\[(homalg_variable_4222,4,1);;
gap> IsZero(homalg_variable_4231);
false
gap> homalg_variable_4232 := SI_\[(homalg_variable_4222,5,1);;
gap> IsZero(homalg_variable_4232);
false
gap> homalg_variable_4234 := SIH_Submatrix(homalg_variable_4220,[1..10],[ 1, 3, 4, 5 ]);;
gap> homalg_variable_4233 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4234);;
gap> SI_ncols(homalg_variable_4233);
1
gap> homalg_variable_4235 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4233 = homalg_variable_4235;
true
gap> homalg_variable_4236 := SIH_BasisOfColumnModule(homalg_variable_4220);;
gap> SI_ncols(homalg_variable_4236);
5
gap> homalg_variable_4237 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_4236 = homalg_variable_4237;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4234);; homalg_variable_4238 := homalg_variable_l[1];; homalg_variable_4239 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4238);
5
gap> homalg_variable_4240 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_4238 = homalg_variable_4240;
false
gap> SI_nrows(homalg_variable_4239);
4
gap> homalg_variable_4241 := homalg_variable_4234 * homalg_variable_4239;;
gap> homalg_variable_4238 = homalg_variable_4241;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4236,homalg_variable_4238);; homalg_variable_4242 := homalg_variable_l[1];; homalg_variable_4243 := homalg_variable_l[2];;
gap> homalg_variable_4244 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_4242 = homalg_variable_4244;
true
gap> homalg_variable_4245 := homalg_variable_4238 * homalg_variable_4243;;
gap> homalg_variable_4246 := homalg_variable_4236 + homalg_variable_4245;;
gap> homalg_variable_4242 = homalg_variable_4246;
true
gap> homalg_variable_4247 := SIH_DecideZeroColumns(homalg_variable_4236,homalg_variable_4238);;
gap> homalg_variable_4248 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_4247 = homalg_variable_4248;
true
gap> homalg_variable_4249 := homalg_variable_4243 * (homalg_variable_8);;
gap> homalg_variable_4250 := homalg_variable_4239 * homalg_variable_4249;;
gap> homalg_variable_4251 := homalg_variable_4234 * homalg_variable_4250;;
gap> homalg_variable_4251 = homalg_variable_4236;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4234,homalg_variable_4236);; homalg_variable_4252 := homalg_variable_l[1];; homalg_variable_4253 := homalg_variable_l[2];;
gap> homalg_variable_4254 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_4252 = homalg_variable_4254;
true
gap> homalg_variable_4255 := homalg_variable_4236 * homalg_variable_4253;;
gap> homalg_variable_4256 := homalg_variable_4234 + homalg_variable_4255;;
gap> homalg_variable_4252 = homalg_variable_4256;
true
gap> homalg_variable_4257 := SIH_DecideZeroColumns(homalg_variable_4234,homalg_variable_4236);;
gap> homalg_variable_4258 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_4257 = homalg_variable_4258;
true
gap> homalg_variable_4259 := homalg_variable_4253 * (homalg_variable_8);;
gap> homalg_variable_4260 := homalg_variable_4236 * homalg_variable_4259;;
gap> homalg_variable_4260 = homalg_variable_4234;
true
gap> SIH_ZeroColumns(homalg_variable_4234);
[  ]
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2075,homalg_variable_4238);; homalg_variable_4261 := homalg_variable_l[1];; homalg_variable_4262 := homalg_variable_l[2];;
gap> homalg_variable_4263 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_4261 = homalg_variable_4263;
true
gap> homalg_variable_4264 := homalg_variable_4238 * homalg_variable_4262;;
gap> homalg_variable_4265 := homalg_variable_2075 + homalg_variable_4264;;
gap> homalg_variable_4261 = homalg_variable_4265;
true
gap> homalg_variable_4266 := SIH_DecideZeroColumns(homalg_variable_2075,homalg_variable_4238);;
gap> homalg_variable_4267 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_4266 = homalg_variable_4267;
true
gap> SI_nrows(homalg_variable_4239);
4
gap> SI_ncols(homalg_variable_4239);
5
gap> homalg_variable_4268 := homalg_variable_4262 * (homalg_variable_8);;
gap> homalg_variable_4269 := homalg_variable_4239 * homalg_variable_4268;;
gap> homalg_variable_4270 := homalg_variable_4234 * homalg_variable_4269;;
gap> homalg_variable_4271 := homalg_variable_4270 - homalg_variable_2075;;
gap> homalg_variable_4272 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_4271 = homalg_variable_4272;
true
gap> homalg_variable_4273 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4269);;
gap> SI_ncols(homalg_variable_4273);
1
gap> homalg_variable_4274 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4273 = homalg_variable_4274;
true
gap> homalg_variable_4275 := SIH_BasisOfColumnModule(homalg_variable_3337);;
gap> SI_ncols(homalg_variable_4275);
1
gap> homalg_variable_4276 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_4275 = homalg_variable_4276;
false
gap> homalg_variable_4277 := SIH_DecideZeroColumns(homalg_variable_237,homalg_variable_4275);;
gap> homalg_variable_4278 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_4277 = homalg_variable_4278;
true
gap> homalg_variable_4279 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3337);;
gap> SI_ncols(homalg_variable_4279);
3
gap> homalg_variable_4280 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_4279 = homalg_variable_4280;
false
gap> homalg_variable_4281 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4279);;
gap> SI_ncols(homalg_variable_4281);
1
gap> homalg_variable_4282 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_4281 = homalg_variable_4282;
true
gap> homalg_variable_4283 := SIH_BasisOfColumnModule(homalg_variable_4279);;
gap> SI_ncols(homalg_variable_4283);
6
gap> homalg_variable_4284 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_4283 = homalg_variable_4284;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4279);; homalg_variable_4285 := homalg_variable_l[1];; homalg_variable_4286 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4285);
6
gap> homalg_variable_4287 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_4285 = homalg_variable_4287;
false
gap> SI_nrows(homalg_variable_4286);
3
gap> homalg_variable_4288 := homalg_variable_4279 * homalg_variable_4286;;
gap> homalg_variable_4285 = homalg_variable_4288;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4283,homalg_variable_4285);; homalg_variable_4289 := homalg_variable_l[1];; homalg_variable_4290 := homalg_variable_l[2];;
gap> homalg_variable_4291 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_4289 = homalg_variable_4291;
true
gap> homalg_variable_4292 := homalg_variable_4285 * homalg_variable_4290;;
gap> homalg_variable_4293 := homalg_variable_4283 + homalg_variable_4292;;
gap> homalg_variable_4289 = homalg_variable_4293;
true
gap> homalg_variable_4294 := SIH_DecideZeroColumns(homalg_variable_4283,homalg_variable_4285);;
gap> homalg_variable_4295 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_4294 = homalg_variable_4295;
true
gap> homalg_variable_4296 := homalg_variable_4290 * (homalg_variable_8);;
gap> homalg_variable_4297 := homalg_variable_4286 * homalg_variable_4296;;
gap> homalg_variable_4298 := homalg_variable_4279 * homalg_variable_4297;;
gap> homalg_variable_4298 = homalg_variable_4283;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4279,homalg_variable_4283);; homalg_variable_4299 := homalg_variable_l[1];; homalg_variable_4300 := homalg_variable_l[2];;
gap> homalg_variable_4301 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_4299 = homalg_variable_4301;
true
gap> homalg_variable_4302 := homalg_variable_4283 * homalg_variable_4300;;
gap> homalg_variable_4303 := homalg_variable_4279 + homalg_variable_4302;;
gap> homalg_variable_4299 = homalg_variable_4303;
true
gap> homalg_variable_4304 := SIH_DecideZeroColumns(homalg_variable_4279,homalg_variable_4283);;
gap> homalg_variable_4305 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_4304 = homalg_variable_4305;
true
gap> homalg_variable_4306 := homalg_variable_4300 * (homalg_variable_8);;
gap> homalg_variable_4307 := homalg_variable_4283 * homalg_variable_4306;;
gap> homalg_variable_4307 = homalg_variable_4279;
true
gap> homalg_variable_4308 := SIH_BasisOfColumnModule(homalg_variable_3223);;
gap> SI_ncols(homalg_variable_4308);
6
gap> homalg_variable_4309 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_4308 = homalg_variable_4309;
false
gap> homalg_variable_4308 = homalg_variable_3223;
false
gap> homalg_variable_4310 := SIH_DecideZeroColumns(homalg_variable_4279,homalg_variable_4308);;
gap> homalg_variable_4311 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_4310 = homalg_variable_4311;
true
gap> homalg_variable_4312 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3223);;
gap> SI_ncols(homalg_variable_4312);
3
gap> homalg_variable_4313 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_4312 = homalg_variable_4313;
false
gap> homalg_variable_4314 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4312);;
gap> SI_ncols(homalg_variable_4314);
1
gap> homalg_variable_4315 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_4314 = homalg_variable_4315;
true
gap> homalg_variable_4316 := SIH_BasisOfColumnModule(homalg_variable_4312);;
gap> SI_ncols(homalg_variable_4316);
4
gap> homalg_variable_4317 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_4316 = homalg_variable_4317;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4312);; homalg_variable_4318 := homalg_variable_l[1];; homalg_variable_4319 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4318);
4
gap> homalg_variable_4320 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_4318 = homalg_variable_4320;
false
gap> SI_nrows(homalg_variable_4319);
3
gap> homalg_variable_4321 := homalg_variable_4312 * homalg_variable_4319;;
gap> homalg_variable_4318 = homalg_variable_4321;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4316,homalg_variable_4318);; homalg_variable_4322 := homalg_variable_l[1];; homalg_variable_4323 := homalg_variable_l[2];;
gap> homalg_variable_4324 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_4322 = homalg_variable_4324;
true
gap> homalg_variable_4325 := homalg_variable_4318 * homalg_variable_4323;;
gap> homalg_variable_4326 := homalg_variable_4316 + homalg_variable_4325;;
gap> homalg_variable_4322 = homalg_variable_4326;
true
gap> homalg_variable_4327 := SIH_DecideZeroColumns(homalg_variable_4316,homalg_variable_4318);;
gap> homalg_variable_4328 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_4327 = homalg_variable_4328;
true
gap> homalg_variable_4329 := homalg_variable_4323 * (homalg_variable_8);;
gap> homalg_variable_4330 := homalg_variable_4319 * homalg_variable_4329;;
gap> homalg_variable_4331 := homalg_variable_4312 * homalg_variable_4330;;
gap> homalg_variable_4331 = homalg_variable_4316;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4312,homalg_variable_4316);; homalg_variable_4332 := homalg_variable_l[1];; homalg_variable_4333 := homalg_variable_l[2];;
gap> homalg_variable_4334 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_4332 = homalg_variable_4334;
true
gap> homalg_variable_4335 := homalg_variable_4316 * homalg_variable_4333;;
gap> homalg_variable_4336 := homalg_variable_4312 + homalg_variable_4335;;
gap> homalg_variable_4332 = homalg_variable_4336;
true
gap> homalg_variable_4337 := SIH_DecideZeroColumns(homalg_variable_4312,homalg_variable_4316);;
gap> homalg_variable_4338 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_4337 = homalg_variable_4338;
true
gap> homalg_variable_4339 := homalg_variable_4333 * (homalg_variable_8);;
gap> homalg_variable_4340 := homalg_variable_4316 * homalg_variable_4339;;
gap> homalg_variable_4340 = homalg_variable_4312;
true
gap> homalg_variable_4341 := SIH_BasisOfColumnModule(homalg_variable_3317);;
gap> SI_ncols(homalg_variable_4341);
4
gap> homalg_variable_4342 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_4341 = homalg_variable_4342;
false
gap> homalg_variable_4341 = homalg_variable_3317;
false
gap> homalg_variable_4343 := SIH_DecideZeroColumns(homalg_variable_4312,homalg_variable_4341);;
gap> homalg_variable_4344 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_4343 = homalg_variable_4344;
true
gap> homalg_variable_4345 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3317);;
gap> SI_ncols(homalg_variable_4345);
1
gap> homalg_variable_4346 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4345 = homalg_variable_4346;
false
gap> homalg_variable_4347 := SIH_BasisOfColumnModule(homalg_variable_4345);;
gap> SI_ncols(homalg_variable_4347);
1
gap> homalg_variable_4348 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4347 = homalg_variable_4348;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4345);; homalg_variable_4349 := homalg_variable_l[1];; homalg_variable_4350 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4349);
1
gap> homalg_variable_4351 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4349 = homalg_variable_4351;
false
gap> SI_nrows(homalg_variable_4350);
1
gap> homalg_variable_4352 := homalg_variable_4345 * homalg_variable_4350;;
gap> homalg_variable_4349 = homalg_variable_4352;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4347,homalg_variable_4349);; homalg_variable_4353 := homalg_variable_l[1];; homalg_variable_4354 := homalg_variable_l[2];;
gap> homalg_variable_4355 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4353 = homalg_variable_4355;
true
gap> homalg_variable_4356 := homalg_variable_4349 * homalg_variable_4354;;
gap> homalg_variable_4357 := homalg_variable_4347 + homalg_variable_4356;;
gap> homalg_variable_4353 = homalg_variable_4357;
true
gap> homalg_variable_4358 := SIH_DecideZeroColumns(homalg_variable_4347,homalg_variable_4349);;
gap> homalg_variable_4359 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4358 = homalg_variable_4359;
true
gap> homalg_variable_4360 := homalg_variable_4354 * (homalg_variable_8);;
gap> homalg_variable_4361 := homalg_variable_4350 * homalg_variable_4360;;
gap> homalg_variable_4362 := homalg_variable_4345 * homalg_variable_4361;;
gap> homalg_variable_4362 = homalg_variable_4347;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4345,homalg_variable_4347);; homalg_variable_4363 := homalg_variable_l[1];; homalg_variable_4364 := homalg_variable_l[2];;
gap> homalg_variable_4365 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4363 = homalg_variable_4365;
true
gap> homalg_variable_4366 := homalg_variable_4347 * homalg_variable_4364;;
gap> homalg_variable_4367 := homalg_variable_4345 + homalg_variable_4366;;
gap> homalg_variable_4363 = homalg_variable_4367;
true
gap> homalg_variable_4368 := SIH_DecideZeroColumns(homalg_variable_4345,homalg_variable_4347);;
gap> homalg_variable_4369 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4368 = homalg_variable_4369;
true
gap> homalg_variable_4370 := homalg_variable_4364 * (homalg_variable_8);;
gap> homalg_variable_4371 := homalg_variable_4347 * homalg_variable_4370;;
gap> homalg_variable_4371 = homalg_variable_4345;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_2448,homalg_variable_4349);; homalg_variable_4372 := homalg_variable_l[1];; homalg_variable_4373 := homalg_variable_l[2];;
gap> homalg_variable_4374 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4372 = homalg_variable_4374;
true
gap> homalg_variable_4375 := homalg_variable_4349 * homalg_variable_4373;;
gap> homalg_variable_4376 := homalg_variable_2448 + homalg_variable_4375;;
gap> homalg_variable_4372 = homalg_variable_4376;
true
gap> homalg_variable_4377 := SIH_DecideZeroColumns(homalg_variable_2448,homalg_variable_4349);;
gap> homalg_variable_4378 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4377 = homalg_variable_4378;
true
gap> SI_nrows(homalg_variable_4350);
1
gap> SI_ncols(homalg_variable_4350);
1
gap> homalg_variable_4379 := homalg_variable_4373 * (homalg_variable_8);;
gap> homalg_variable_4380 := homalg_variable_4350 * homalg_variable_4379;;
gap> homalg_variable_4381 := homalg_variable_4345 * homalg_variable_4380;;
gap> homalg_variable_4382 := homalg_variable_4381 - homalg_variable_2448;;
gap> homalg_variable_4383 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4382 = homalg_variable_4383;
true
gap> homalg_variable_4384 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4380);;
gap> SI_ncols(homalg_variable_4384);
1
gap> homalg_variable_4385 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_4384 = homalg_variable_4385;
true
gap> homalg_variable_4386 := SI_matrix(homalg_variable_5,2,6,"0");;
gap> homalg_variable_4387 := SIH_Submatrix(homalg_variable_4063,[ 1, 2, 3, 4, 5 ],[1..6]);;
gap> homalg_variable_4388 := SIH_UnionOfRows(homalg_variable_4386,homalg_variable_4387);;
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4388,homalg_variable_3989);; homalg_variable_4389 := homalg_variable_l[1];; homalg_variable_4390 := homalg_variable_l[2];;
gap> homalg_variable_4391 := SI_matrix(homalg_variable_5,7,6,"0");;
gap> homalg_variable_4389 = homalg_variable_4391;
true
gap> homalg_variable_4392 := homalg_variable_3989 * homalg_variable_4390;;
gap> homalg_variable_4393 := homalg_variable_4388 + homalg_variable_4392;;
gap> homalg_variable_4389 = homalg_variable_4393;
true
gap> homalg_variable_4394 := SIH_DecideZeroColumns(homalg_variable_4388,homalg_variable_3989);;
gap> homalg_variable_4395 := SI_matrix(homalg_variable_5,7,6,"0");;
gap> homalg_variable_4394 = homalg_variable_4395;
true
gap> SI_nrows(homalg_variable_3990);
5
gap> SI_ncols(homalg_variable_3990);
7
gap> homalg_variable_4396 := homalg_variable_4390 * (homalg_variable_8);;
gap> homalg_variable_4397 := homalg_variable_3990 * homalg_variable_4396;;
gap> homalg_variable_4398 := homalg_variable_3983 * homalg_variable_4397;;
gap> homalg_variable_4399 := homalg_variable_4398 - homalg_variable_4388;;
gap> homalg_variable_4400 := SI_matrix(homalg_variable_5,7,6,"0");;
gap> homalg_variable_4399 = homalg_variable_4400;
true
gap> homalg_variable_4401 := SI_matrix(homalg_variable_5,9,4,"0");;
gap> homalg_variable_4402 := SIH_Submatrix(homalg_variable_4234,[ 1, 2, 3, 4, 5 ],[1..4]);;
gap> homalg_variable_4403 := SIH_UnionOfRows(homalg_variable_4401,homalg_variable_4402);;
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4403,homalg_variable_4069);; homalg_variable_4404 := homalg_variable_l[1];; homalg_variable_4405 := homalg_variable_l[2];;
gap> homalg_variable_4406 := SI_matrix(homalg_variable_5,14,4,"0");;
gap> homalg_variable_4404 = homalg_variable_4406;
true
gap> homalg_variable_4407 := homalg_variable_4069 * homalg_variable_4405;;
gap> homalg_variable_4408 := homalg_variable_4403 + homalg_variable_4407;;
gap> homalg_variable_4404 = homalg_variable_4408;
true
gap> homalg_variable_4409 := SIH_DecideZeroColumns(homalg_variable_4403,homalg_variable_4069);;
gap> homalg_variable_4410 := SI_matrix(homalg_variable_5,14,4,"0");;
gap> homalg_variable_4409 = homalg_variable_4410;
true
gap> SI_nrows(homalg_variable_4070);
6
gap> SI_ncols(homalg_variable_4070);
10
gap> homalg_variable_4411 := homalg_variable_4405 * (homalg_variable_8);;
gap> homalg_variable_4412 := homalg_variable_4070 * homalg_variable_4411;;
gap> homalg_variable_4413 := homalg_variable_4063 * homalg_variable_4412;;
gap> homalg_variable_4414 := homalg_variable_4413 - homalg_variable_4403;;
gap> homalg_variable_4415 := SI_matrix(homalg_variable_5,14,4,"0");;
gap> homalg_variable_4414 = homalg_variable_4415;
true
gap> homalg_variable_4416 := SI_matrix(homalg_variable_5,7,1,"0");;
gap> homalg_variable_4417 := SIH_Submatrix(homalg_variable_4345,[ 1, 2, 3 ],[1..1]);;
gap> homalg_variable_4418 := SIH_UnionOfRows(homalg_variable_4416,homalg_variable_4417);;
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4418,homalg_variable_4238);; homalg_variable_4419 := homalg_variable_l[1];; homalg_variable_4420 := homalg_variable_l[2];;
gap> homalg_variable_4421 := SI_matrix(homalg_variable_5,10,1,"0");;
gap> homalg_variable_4419 = homalg_variable_4421;
true
gap> homalg_variable_4422 := homalg_variable_4238 * homalg_variable_4420;;
gap> homalg_variable_4423 := homalg_variable_4418 + homalg_variable_4422;;
gap> homalg_variable_4419 = homalg_variable_4423;
true
gap> homalg_variable_4424 := SIH_DecideZeroColumns(homalg_variable_4418,homalg_variable_4238);;
gap> homalg_variable_4425 := SI_matrix(homalg_variable_5,10,1,"0");;
gap> homalg_variable_4424 = homalg_variable_4425;
true
gap> SI_nrows(homalg_variable_4239);
4
gap> SI_ncols(homalg_variable_4239);
5
gap> homalg_variable_4426 := homalg_variable_4420 * (homalg_variable_8);;
gap> homalg_variable_4427 := homalg_variable_4239 * homalg_variable_4426;;
gap> homalg_variable_4428 := homalg_variable_4234 * homalg_variable_4427;;
gap> homalg_variable_4429 := homalg_variable_4428 - homalg_variable_4418;;
gap> homalg_variable_4430 := SI_matrix(homalg_variable_5,10,1,"0");;
gap> homalg_variable_4429 = homalg_variable_4430;
true
gap> homalg_variable_4431 := SIH_BasisOfColumnModule(homalg_variable_4397);;
gap> SI_ncols(homalg_variable_4431);
6
gap> homalg_variable_4432 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4431 = homalg_variable_4432;
false
gap> homalg_variable_4431 = homalg_variable_4397;
false
gap> homalg_variable_4433 := SIH_DecideZeroColumns(homalg_variable_42,homalg_variable_4431);;
gap> homalg_variable_4434 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_4433 = homalg_variable_4434;
false
gap> SIH_ZeroColumns(homalg_variable_4433);
[  ]
gap> homalg_variable_4435 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4397);;
gap> SI_ncols(homalg_variable_4435);
4
gap> homalg_variable_4436 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_4435 = homalg_variable_4436;
false
gap> homalg_variable_4437 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4435);;
gap> SI_ncols(homalg_variable_4437);
1
gap> homalg_variable_4438 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4437 = homalg_variable_4438;
false
gap> homalg_variable_4439 := SI_\[(homalg_variable_4437,4,1);;
gap> SI_deg( homalg_variable_4439 );
1
gap> homalg_variable_4440 := SI_\[(homalg_variable_4437,3,1);;
gap> SI_deg( homalg_variable_4440 );
1
gap> homalg_variable_4441 := SI_\[(homalg_variable_4437,2,1);;
gap> SI_deg( homalg_variable_4441 );
1
gap> homalg_variable_4442 := SI_\[(homalg_variable_4437,1,1);;
gap> SI_deg( homalg_variable_4442 );
-1
gap> homalg_variable_4443 := SIH_BasisOfColumnModule(homalg_variable_4435);;
gap> SI_ncols(homalg_variable_4443);
4
gap> homalg_variable_4444 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_4443 = homalg_variable_4444;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4435);; homalg_variable_4445 := homalg_variable_l[1];; homalg_variable_4446 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4445);
4
gap> homalg_variable_4447 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_4445 = homalg_variable_4447;
false
gap> SI_nrows(homalg_variable_4446);
4
gap> homalg_variable_4448 := homalg_variable_4435 * homalg_variable_4446;;
gap> homalg_variable_4445 = homalg_variable_4448;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4443,homalg_variable_4445);; homalg_variable_4449 := homalg_variable_l[1];; homalg_variable_4450 := homalg_variable_l[2];;
gap> homalg_variable_4451 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_4449 = homalg_variable_4451;
true
gap> homalg_variable_4452 := homalg_variable_4445 * homalg_variable_4450;;
gap> homalg_variable_4453 := homalg_variable_4443 + homalg_variable_4452;;
gap> homalg_variable_4449 = homalg_variable_4453;
true
gap> homalg_variable_4454 := SIH_DecideZeroColumns(homalg_variable_4443,homalg_variable_4445);;
gap> homalg_variable_4455 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_4454 = homalg_variable_4455;
true
gap> homalg_variable_4456 := homalg_variable_4450 * (homalg_variable_8);;
gap> homalg_variable_4457 := homalg_variable_4446 * homalg_variable_4456;;
gap> homalg_variable_4458 := homalg_variable_4435 * homalg_variable_4457;;
gap> homalg_variable_4458 = homalg_variable_4443;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4435,homalg_variable_4443);; homalg_variable_4459 := homalg_variable_l[1];; homalg_variable_4460 := homalg_variable_l[2];;
gap> homalg_variable_4461 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_4459 = homalg_variable_4461;
true
gap> homalg_variable_4462 := homalg_variable_4443 * homalg_variable_4460;;
gap> homalg_variable_4463 := homalg_variable_4435 + homalg_variable_4462;;
gap> homalg_variable_4459 = homalg_variable_4463;
true
gap> homalg_variable_4464 := SIH_DecideZeroColumns(homalg_variable_4435,homalg_variable_4443);;
gap> homalg_variable_4465 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_4464 = homalg_variable_4465;
true
gap> homalg_variable_4466 := homalg_variable_4460 * (homalg_variable_8);;
gap> homalg_variable_4467 := homalg_variable_4443 * homalg_variable_4466;;
gap> homalg_variable_4467 = homalg_variable_4435;
true
gap> homalg_variable_4468 := SIH_BasisOfColumnModule(homalg_variable_4412);;
gap> SI_ncols(homalg_variable_4468);
4
gap> homalg_variable_4469 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_4468 = homalg_variable_4469;
false
gap> homalg_variable_4468 = homalg_variable_4412;
true
gap> homalg_variable_4470 := SIH_DecideZeroColumns(homalg_variable_4435,homalg_variable_4468);;
gap> homalg_variable_4471 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_4470 = homalg_variable_4471;
true
gap> homalg_variable_4472 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4412);;
gap> SI_ncols(homalg_variable_4472);
1
gap> homalg_variable_4473 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4472 = homalg_variable_4473;
false
gap> homalg_variable_4474 := SIH_BasisOfColumnModule(homalg_variable_4472);;
gap> SI_ncols(homalg_variable_4474);
1
gap> homalg_variable_4475 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4474 = homalg_variable_4475;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4472);; homalg_variable_4476 := homalg_variable_l[1];; homalg_variable_4477 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4476);
1
gap> homalg_variable_4478 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4476 = homalg_variable_4478;
false
gap> SI_nrows(homalg_variable_4477);
1
gap> homalg_variable_4479 := homalg_variable_4472 * homalg_variable_4477;;
gap> homalg_variable_4476 = homalg_variable_4479;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4474,homalg_variable_4476);; homalg_variable_4480 := homalg_variable_l[1];; homalg_variable_4481 := homalg_variable_l[2];;
gap> homalg_variable_4482 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4480 = homalg_variable_4482;
true
gap> homalg_variable_4483 := homalg_variable_4476 * homalg_variable_4481;;
gap> homalg_variable_4484 := homalg_variable_4474 + homalg_variable_4483;;
gap> homalg_variable_4480 = homalg_variable_4484;
true
gap> homalg_variable_4485 := SIH_DecideZeroColumns(homalg_variable_4474,homalg_variable_4476);;
gap> homalg_variable_4486 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4485 = homalg_variable_4486;
true
gap> homalg_variable_4487 := homalg_variable_4481 * (homalg_variable_8);;
gap> homalg_variable_4488 := homalg_variable_4477 * homalg_variable_4487;;
gap> homalg_variable_4489 := homalg_variable_4472 * homalg_variable_4488;;
gap> homalg_variable_4489 = homalg_variable_4474;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4472,homalg_variable_4474);; homalg_variable_4490 := homalg_variable_l[1];; homalg_variable_4491 := homalg_variable_l[2];;
gap> homalg_variable_4492 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4490 = homalg_variable_4492;
true
gap> homalg_variable_4493 := homalg_variable_4474 * homalg_variable_4491;;
gap> homalg_variable_4494 := homalg_variable_4472 + homalg_variable_4493;;
gap> homalg_variable_4490 = homalg_variable_4494;
true
gap> homalg_variable_4495 := SIH_DecideZeroColumns(homalg_variable_4472,homalg_variable_4474);;
gap> homalg_variable_4496 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4495 = homalg_variable_4496;
true
gap> homalg_variable_4497 := homalg_variable_4491 * (homalg_variable_8);;
gap> homalg_variable_4498 := homalg_variable_4474 * homalg_variable_4497;;
gap> homalg_variable_4498 = homalg_variable_4472;
true
gap> homalg_variable_4499 := SIH_BasisOfColumnModule(homalg_variable_4427);;
gap> SI_ncols(homalg_variable_4499);
1
gap> homalg_variable_4500 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4499 = homalg_variable_4500;
false
gap> homalg_variable_4499 = homalg_variable_4427;
true
gap> for _del in [ "homalg_variable_3984", "homalg_variable_3985", "homalg_variable_3986", "homalg_variable_3988", "homalg_variable_3991", "homalg_variable_3992", "homalg_variable_3993", "homalg_variable_3994", "homalg_variable_3995", "homalg_variable_3996", "homalg_variable_3997", "homalg_variable_3998", "homalg_variable_3999", "homalg_variable_4000", "homalg_variable_4001", "homalg_variable_4002", "homalg_variable_4005", "homalg_variable_4006", "homalg_variable_4007", "homalg_variable_4011", "homalg_variable_4012", "homalg_variable_4014", "homalg_variable_4015", "homalg_variable_4016", "homalg_variable_4017", "homalg_variable_4018", "homalg_variable_4021", "homalg_variable_4022", "homalg_variable_4023", "homalg_variable_4024", "homalg_variable_4025", "homalg_variable_4027", "homalg_variable_4028", "homalg_variable_4029", "homalg_variable_4031", "homalg_variable_4032", "homalg_variable_4033", "homalg_variable_4035", "homalg_variable_4038", "homalg_variable_4039", "homalg_variable_4040", "homalg_variable_4041", "homalg_variable_4042", "homalg_variable_4043", "homalg_variable_4044", "homalg_variable_4045", "homalg_variable_4046", "homalg_variable_4047", "homalg_variable_4048", "homalg_variable_4049", "homalg_variable_4050", "homalg_variable_4051", "homalg_variable_4052", "homalg_variable_4053", "homalg_variable_4054", "homalg_variable_4055", "homalg_variable_4056", "homalg_variable_4057", "homalg_variable_4058", "homalg_variable_4061", "homalg_variable_4062", "homalg_variable_4064", "homalg_variable_4065", "homalg_variable_4066", "homalg_variable_4068", "homalg_variable_4071", "homalg_variable_4072", "homalg_variable_4073", "homalg_variable_4074", "homalg_variable_4075", "homalg_variable_4076", "homalg_variable_4077", "homalg_variable_4078", "homalg_variable_4079", "homalg_variable_4080", "homalg_variable_4081", "homalg_variable_4082", "homalg_variable_4085", "homalg_variable_4086", "homalg_variable_4087", "homalg_variable_4091", "homalg_variable_4092", "homalg_variable_4094", "homalg_variable_4095", "homalg_variable_4096", "homalg_variable_4097", "homalg_variable_4098", "homalg_variable_4101", "homalg_variable_4102", "homalg_variable_4103", "homalg_variable_4104", "homalg_variable_4105", "homalg_variable_4107", "homalg_variable_4108", "homalg_variable_4109", "homalg_variable_4112", "homalg_variable_4113", "homalg_variable_4115", "homalg_variable_4118", "homalg_variable_4119", "homalg_variable_4120", "homalg_variable_4121", "homalg_variable_4122", "homalg_variable_4123", "homalg_variable_4124", "homalg_variable_4125", "homalg_variable_4126", "homalg_variable_4127", "homalg_variable_4128", "homalg_variable_4129", "homalg_variable_4130", "homalg_variable_4131", "homalg_variable_4132", "homalg_variable_4133", "homalg_variable_4134", "homalg_variable_4135", "homalg_variable_4136", "homalg_variable_4137", "homalg_variable_4138", "homalg_variable_4140", "homalg_variable_4141", "homalg_variable_4142", "homalg_variable_4144", "homalg_variable_4146", "homalg_variable_4147", "homalg_variable_4148", "homalg_variable_4149", "homalg_variable_4150", "homalg_variable_4151", "homalg_variable_4152", "homalg_variable_4153", "homalg_variable_4154", "homalg_variable_4155", "homalg_variable_4156", "homalg_variable_4157", "homalg_variable_4158", "homalg_variable_4159", "homalg_variable_4160", "homalg_variable_4161", "homalg_variable_4162", "homalg_variable_4163", "homalg_variable_4164", "homalg_variable_4165", "homalg_variable_4166", "homalg_variable_4167", "homalg_variable_4168", "homalg_variable_4169", "homalg_variable_4170", "homalg_variable_4171", "homalg_variable_4172", "homalg_variable_4173", "homalg_variable_4174", "homalg_variable_4175", "homalg_variable_4176", "homalg_variable_4177", "homalg_variable_4178", "homalg_variable_4179", "homalg_variable_4180", "homalg_variable_4181", "homalg_variable_4182", "homalg_variable_4183", "homalg_variable_4184", "homalg_variable_4185", "homalg_variable_4186", "homalg_variable_4187", "homalg_variable_4189", "homalg_variable_4194", "homalg_variable_4195", "homalg_variable_4196", "homalg_variable_4197", "homalg_variable_4198", "homalg_variable_4199", "homalg_variable_4200", "homalg_variable_4201", "homalg_variable_4202", "homalg_variable_4203", "homalg_variable_4204", "homalg_variable_4205", "homalg_variable_4206", "homalg_variable_4207", "homalg_variable_4208", "homalg_variable_4209", "homalg_variable_4210", "homalg_variable_4211", "homalg_variable_4212", "homalg_variable_4213", "homalg_variable_4214", "homalg_variable_4215", "homalg_variable_4217", "homalg_variable_4218", "homalg_variable_4219", "homalg_variable_4221", "homalg_variable_4223", "homalg_variable_4224", "homalg_variable_4225", "homalg_variable_4226", "homalg_variable_4227", "homalg_variable_4228", "homalg_variable_4229", "homalg_variable_4230", "homalg_variable_4231", "homalg_variable_4232", "homalg_variable_4233", "homalg_variable_4235", "homalg_variable_4237", "homalg_variable_4240", "homalg_variable_4241", "homalg_variable_4242", "homalg_variable_4243", "homalg_variable_4244", "homalg_variable_4245", "homalg_variable_4246", "homalg_variable_4247", "homalg_variable_4248", "homalg_variable_4249", "homalg_variable_4250", "homalg_variable_4251", "homalg_variable_4254", "homalg_variable_4255", "homalg_variable_4256", "homalg_variable_4257", "homalg_variable_4258", "homalg_variable_4260", "homalg_variable_4261", "homalg_variable_4263", "homalg_variable_4264", "homalg_variable_4265", "homalg_variable_4266", "homalg_variable_4267", "homalg_variable_4270", "homalg_variable_4271", "homalg_variable_4272", "homalg_variable_4273", "homalg_variable_4274", "homalg_variable_4276", "homalg_variable_4277", "homalg_variable_4278", "homalg_variable_4281", "homalg_variable_4282", "homalg_variable_4284", "homalg_variable_4287", "homalg_variable_4288", "homalg_variable_4289", "homalg_variable_4290", "homalg_variable_4291", "homalg_variable_4292", "homalg_variable_4293", "homalg_variable_4294", "homalg_variable_4295", "homalg_variable_4296", "homalg_variable_4297", "homalg_variable_4298", "homalg_variable_4299", "homalg_variable_4300", "homalg_variable_4301", "homalg_variable_4302", "homalg_variable_4303", "homalg_variable_4304", "homalg_variable_4305", "homalg_variable_4306", "homalg_variable_4307", "homalg_variable_4309", "homalg_variable_4313", "homalg_variable_4314", "homalg_variable_4315", "homalg_variable_4317", "homalg_variable_4320", "homalg_variable_4321", "homalg_variable_4322", "homalg_variable_4323", "homalg_variable_4324", "homalg_variable_4325", "homalg_variable_4326", "homalg_variable_4327", "homalg_variable_4328", "homalg_variable_4329", "homalg_variable_4330", "homalg_variable_4331", "homalg_variable_4334", "homalg_variable_4335", "homalg_variable_4336", "homalg_variable_4337", "homalg_variable_4338", "homalg_variable_4342", "homalg_variable_4343", "homalg_variable_4344", "homalg_variable_4346", "homalg_variable_4348", "homalg_variable_4351", "homalg_variable_4352", "homalg_variable_4353", "homalg_variable_4354", "homalg_variable_4355", "homalg_variable_4356", "homalg_variable_4357", "homalg_variable_4358", "homalg_variable_4359", "homalg_variable_4360", "homalg_variable_4361", "homalg_variable_4362", "homalg_variable_4366", "homalg_variable_4367", "homalg_variable_4368", "homalg_variable_4369", "homalg_variable_4371", "homalg_variable_4372", "homalg_variable_4374", "homalg_variable_4375", "homalg_variable_4376", "homalg_variable_4377", "homalg_variable_4378", "homalg_variable_4381", "homalg_variable_4382", "homalg_variable_4383", "homalg_variable_4384", "homalg_variable_4385", "homalg_variable_4391", "homalg_variable_4392", "homalg_variable_4393", "homalg_variable_4394", "homalg_variable_4395", "homalg_variable_4398", "homalg_variable_4399", "homalg_variable_4400", "homalg_variable_4404", "homalg_variable_4406", "homalg_variable_4407", "homalg_variable_4408", "homalg_variable_4409", "homalg_variable_4410", "homalg_variable_4413", "homalg_variable_4414", "homalg_variable_4415", "homalg_variable_4421", "homalg_variable_4422", "homalg_variable_4423", "homalg_variable_4424", "homalg_variable_4425", "homalg_variable_4432", "homalg_variable_4433", "homalg_variable_4434", "homalg_variable_4436", "homalg_variable_4438", "homalg_variable_4439", "homalg_variable_4440", "homalg_variable_4441", "homalg_variable_4442", "homalg_variable_4444", "homalg_variable_4447", "homalg_variable_4448", "homalg_variable_4449", "homalg_variable_4450", "homalg_variable_4451", "homalg_variable_4452", "homalg_variable_4453", "homalg_variable_4454", "homalg_variable_4455", "homalg_variable_4456", "homalg_variable_4457", "homalg_variable_4458", "homalg_variable_4461", "homalg_variable_4462", "homalg_variable_4463", "homalg_variable_4465", "homalg_variable_4467", "homalg_variable_4469", "homalg_variable_4470", "homalg_variable_4471", "homalg_variable_4473", "homalg_variable_4475", "homalg_variable_4478", "homalg_variable_4479", "homalg_variable_4482", "homalg_variable_4483", "homalg_variable_4484" ] do UnbindGlobal( _del );; od;;
gap> homalg_variable_4501 := SIH_DecideZeroColumns(homalg_variable_4472,homalg_variable_4499);;
gap> homalg_variable_4502 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4501 = homalg_variable_4502;
true
gap> homalg_variable_4504 := SIH_UnionOfRows(homalg_variable_3337,homalg_variable_2826);;
gap> homalg_variable_4505 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_4506 := SIH_UnionOfRows(homalg_variable_4504,homalg_variable_4505);;
gap> homalg_variable_4507 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_4508 := SIH_UnionOfRows(homalg_variable_4506,homalg_variable_4507);;
gap> homalg_variable_4509 := SI_matrix(homalg_variable_5,1,10,"0");;
gap> homalg_variable_4510 := SIH_UnionOfRows(homalg_variable_4509,homalg_variable_2346);;
gap> homalg_variable_4511 := SIH_UnionOfRows(homalg_variable_4510,homalg_variable_2905);;
gap> homalg_variable_4512 := SI_matrix(homalg_variable_5,7,10,"0");;
gap> homalg_variable_4513 := SIH_UnionOfRows(homalg_variable_4511,homalg_variable_4512);;
gap> homalg_variable_4514 := SIH_UnionOfColumns(homalg_variable_4508,homalg_variable_4513);;
gap> homalg_variable_4515 := SI_matrix(homalg_variable_5,6,14,"0");;
gap> homalg_variable_4516 := SIH_UnionOfRows(homalg_variable_4515,homalg_variable_3250);;
gap> homalg_variable_4517 := SIH_UnionOfRows(homalg_variable_4516,homalg_variable_2991);;
gap> homalg_variable_4518 := SIH_UnionOfColumns(homalg_variable_4514,homalg_variable_4517);;
gap> homalg_variable_4503 := SIH_BasisOfColumnModule(homalg_variable_4518);;
gap> SI_ncols(homalg_variable_4503);
25
gap> homalg_variable_4519 := SI_matrix(homalg_variable_5,23,25,"0");;
gap> homalg_variable_4503 = homalg_variable_4519;
false
gap> homalg_variable_4520 := SIH_DecideZeroColumns(homalg_variable_4518,homalg_variable_4503);;
gap> homalg_variable_4521 := SI_matrix(homalg_variable_5,23,28,"0");;
gap> homalg_variable_4520 = homalg_variable_4521;
true
gap> homalg_variable_4523 := SI_matrix(homalg_variable_5,16,6,"0");;
gap> homalg_variable_4524 := homalg_variable_3983 * homalg_variable_4397;;
gap> homalg_variable_4525 := SIH_UnionOfRows(homalg_variable_4523,homalg_variable_4524);;
gap> homalg_variable_4522 := SIH_DecideZeroColumns(homalg_variable_4525,homalg_variable_4503);;
gap> homalg_variable_4526 := SI_matrix(homalg_variable_5,23,6,"0");;
gap> homalg_variable_4522 = homalg_variable_4526;
true
gap> homalg_variable_4528 := SI_matrix(homalg_variable_5,16,5,"0");;
gap> homalg_variable_4529 := SIH_UnionOfRows(homalg_variable_4528,homalg_variable_3983);;
gap> homalg_variable_4527 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4529,homalg_variable_4518);;
gap> SI_ncols(homalg_variable_4527);
6
gap> homalg_variable_4530 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4527 = homalg_variable_4530;
false
gap> homalg_variable_4531 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4527);;
gap> SI_ncols(homalg_variable_4531);
4
gap> homalg_variable_4532 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_4531 = homalg_variable_4532;
false
gap> homalg_variable_4533 := SI_\[(homalg_variable_4531,6,1);;
gap> SI_deg( homalg_variable_4533 );
-1
gap> homalg_variable_4534 := SI_\[(homalg_variable_4531,5,1);;
gap> SI_deg( homalg_variable_4534 );
-1
gap> homalg_variable_4535 := SI_\[(homalg_variable_4531,4,1);;
gap> SI_deg( homalg_variable_4535 );
1
gap> homalg_variable_4536 := SI_\[(homalg_variable_4531,3,1);;
gap> SI_deg( homalg_variable_4536 );
1
gap> homalg_variable_4537 := SI_\[(homalg_variable_4531,2,1);;
gap> SI_deg( homalg_variable_4537 );
-1
gap> homalg_variable_4538 := SI_\[(homalg_variable_4531,1,1);;
gap> SI_deg( homalg_variable_4538 );
-1
gap> homalg_variable_4539 := SI_\[(homalg_variable_4531,6,2);;
gap> SI_deg( homalg_variable_4539 );
1
gap> homalg_variable_4540 := SI_\[(homalg_variable_4531,5,2);;
gap> SI_deg( homalg_variable_4540 );
1
gap> homalg_variable_4541 := SI_\[(homalg_variable_4531,4,2);;
gap> SI_deg( homalg_variable_4541 );
-1
gap> homalg_variable_4542 := SI_\[(homalg_variable_4531,3,2);;
gap> SI_deg( homalg_variable_4542 );
-1
gap> homalg_variable_4543 := SI_\[(homalg_variable_4531,2,2);;
gap> SI_deg( homalg_variable_4543 );
-1
gap> homalg_variable_4544 := SI_\[(homalg_variable_4531,1,2);;
gap> SI_deg( homalg_variable_4544 );
-1
gap> homalg_variable_4545 := SI_\[(homalg_variable_4531,6,3);;
gap> SI_deg( homalg_variable_4545 );
-1
gap> homalg_variable_4546 := SI_\[(homalg_variable_4531,5,3);;
gap> SI_deg( homalg_variable_4546 );
1
gap> homalg_variable_4547 := SI_\[(homalg_variable_4531,4,3);;
gap> SI_deg( homalg_variable_4547 );
-1
gap> homalg_variable_4548 := SI_\[(homalg_variable_4531,3,3);;
gap> SI_deg( homalg_variable_4548 );
1
gap> homalg_variable_4549 := SI_\[(homalg_variable_4531,2,3);;
gap> SI_deg( homalg_variable_4549 );
-1
gap> homalg_variable_4550 := SI_\[(homalg_variable_4531,1,3);;
gap> SI_deg( homalg_variable_4550 );
3
gap> homalg_variable_4551 := SI_\[(homalg_variable_4531,6,4);;
gap> SI_deg( homalg_variable_4551 );
1
gap> homalg_variable_4552 := SI_\[(homalg_variable_4531,5,4);;
gap> SI_deg( homalg_variable_4552 );
-1
gap> homalg_variable_4553 := SI_\[(homalg_variable_4531,4,4);;
gap> SI_deg( homalg_variable_4553 );
-1
gap> homalg_variable_4554 := SI_\[(homalg_variable_4531,3,4);;
gap> SI_deg( homalg_variable_4554 );
1
gap> homalg_variable_4555 := SI_\[(homalg_variable_4531,2,4);;
gap> SI_deg( homalg_variable_4555 );
-1
gap> homalg_variable_4556 := SI_\[(homalg_variable_4531,1,4);;
gap> SI_deg( homalg_variable_4556 );
3
gap> homalg_variable_4557 := SIH_BasisOfColumnModule(homalg_variable_4527);;
gap> SI_ncols(homalg_variable_4557);
6
gap> homalg_variable_4558 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4557 = homalg_variable_4558;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4527);; homalg_variable_4559 := homalg_variable_l[1];; homalg_variable_4560 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4559);
6
gap> homalg_variable_4561 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4559 = homalg_variable_4561;
false
gap> SI_nrows(homalg_variable_4560);
6
gap> homalg_variable_4562 := homalg_variable_4527 * homalg_variable_4560;;
gap> homalg_variable_4559 = homalg_variable_4562;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4557,homalg_variable_4559);; homalg_variable_4563 := homalg_variable_l[1];; homalg_variable_4564 := homalg_variable_l[2];;
gap> homalg_variable_4565 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4563 = homalg_variable_4565;
true
gap> homalg_variable_4566 := homalg_variable_4559 * homalg_variable_4564;;
gap> homalg_variable_4567 := homalg_variable_4557 + homalg_variable_4566;;
gap> homalg_variable_4563 = homalg_variable_4567;
true
gap> homalg_variable_4568 := SIH_DecideZeroColumns(homalg_variable_4557,homalg_variable_4559);;
gap> homalg_variable_4569 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4568 = homalg_variable_4569;
true
gap> homalg_variable_4570 := homalg_variable_4564 * (homalg_variable_8);;
gap> homalg_variable_4571 := homalg_variable_4560 * homalg_variable_4570;;
gap> homalg_variable_4572 := homalg_variable_4527 * homalg_variable_4571;;
gap> homalg_variable_4572 = homalg_variable_4557;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4527,homalg_variable_4557);; homalg_variable_4573 := homalg_variable_l[1];; homalg_variable_4574 := homalg_variable_l[2];;
gap> homalg_variable_4575 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4573 = homalg_variable_4575;
true
gap> homalg_variable_4576 := homalg_variable_4557 * homalg_variable_4574;;
gap> homalg_variable_4577 := homalg_variable_4527 + homalg_variable_4576;;
gap> homalg_variable_4573 = homalg_variable_4577;
true
gap> homalg_variable_4578 := SIH_DecideZeroColumns(homalg_variable_4527,homalg_variable_4557);;
gap> homalg_variable_4579 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4578 = homalg_variable_4579;
true
gap> homalg_variable_4580 := homalg_variable_4574 * (homalg_variable_8);;
gap> homalg_variable_4581 := homalg_variable_4557 * homalg_variable_4580;;
gap> homalg_variable_4581 = homalg_variable_4527;
true
gap> homalg_variable_4582 := SIH_DecideZeroColumns(homalg_variable_4527,homalg_variable_4431);;
gap> homalg_variable_4583 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_4582 = homalg_variable_4583;
true
gap> homalg_variable_4585 := SI_matrix( SI_freemodule( homalg_variable_5,16 ) );;
gap> homalg_variable_4586 := SIH_Submatrix(homalg_variable_4585,[1..16],[ 6 ]);;
gap> homalg_variable_4587 := SI_matrix(homalg_variable_5,16,3,"0");;
gap> homalg_variable_4588 := SIH_UnionOfColumns(homalg_variable_4586,homalg_variable_4587);;
gap> homalg_variable_4589 := SIH_Submatrix(homalg_variable_4585,[1..16],[ 2, 3, 4, 5, 6 ]);;
gap> homalg_variable_4590 := homalg_variable_2831 * homalg_variable_3208;;
gap> homalg_variable_4591 := homalg_variable_4589 * homalg_variable_4590;;
gap> homalg_variable_4592 := SIH_UnionOfColumns(homalg_variable_4588,homalg_variable_4591);;
gap> homalg_variable_4593 := SI_matrix(homalg_variable_5,7,8,"0");;
gap> homalg_variable_4594 := SIH_UnionOfRows(homalg_variable_4592,homalg_variable_4593);;
gap> homalg_variable_4595 := SIH_Submatrix(homalg_variable_4585,[1..16],[ 1 ]);;
gap> homalg_variable_4596 := SI_matrix(homalg_variable_5,7,1,"0");;
gap> homalg_variable_4597 := SIH_UnionOfRows(homalg_variable_4595,homalg_variable_4596);;
gap> homalg_variable_4598 := SIH_UnionOfColumns(homalg_variable_4594,homalg_variable_4597);;
gap> homalg_variable_4584 := SIH_BasisOfColumnModule(homalg_variable_4598);;
gap> SI_ncols(homalg_variable_4584);
6
gap> homalg_variable_4599 := SI_matrix(homalg_variable_5,23,6,"0");;
gap> homalg_variable_4584 = homalg_variable_4599;
false
gap> homalg_variable_4600 := SIH_DecideZeroColumns(homalg_variable_4598,homalg_variable_4584);;
gap> homalg_variable_4601 := SI_matrix(homalg_variable_5,23,9,"0");;
gap> homalg_variable_4600 = homalg_variable_4601;
true
gap> homalg_variable_4603 := homalg_variable_2831 * homalg_variable_3383;;
gap> homalg_variable_4604 := homalg_variable_4589 * homalg_variable_4603;;
gap> homalg_variable_4605 := homalg_variable_4604 * homalg_variable_3419;;
gap> homalg_variable_4606 := SI_matrix(homalg_variable_5,7,2,"0");;
gap> homalg_variable_4607 := SIH_UnionOfRows(homalg_variable_4605,homalg_variable_4606);;
gap> homalg_variable_4602 := SIH_DecideZeroColumns(homalg_variable_4607,homalg_variable_4584);;
gap> homalg_variable_4608 := SI_matrix(homalg_variable_5,23,2,"0");;
gap> homalg_variable_4602 = homalg_variable_4608;
true
gap> homalg_variable_4610 := SI_matrix(homalg_variable_5,7,1,"0");;
gap> homalg_variable_4611 := SIH_UnionOfRows(homalg_variable_4604,homalg_variable_4610);;
gap> homalg_variable_4609 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4611,homalg_variable_4598);;
gap> SI_ncols(homalg_variable_4609);
2
gap> homalg_variable_4612 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4609 = homalg_variable_4612;
false
gap> homalg_variable_4613 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4609);;
gap> SI_ncols(homalg_variable_4613);
1
gap> homalg_variable_4614 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_4613 = homalg_variable_4614;
false
gap> homalg_variable_4615 := SI_\[(homalg_variable_4613,2,1);;
gap> SI_deg( homalg_variable_4615 );
1
gap> homalg_variable_4616 := SI_\[(homalg_variable_4613,1,1);;
gap> SI_deg( homalg_variable_4616 );
1
gap> homalg_variable_4617 := SIH_BasisOfColumnModule(homalg_variable_4609);;
gap> SI_ncols(homalg_variable_4617);
2
gap> homalg_variable_4618 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4617 = homalg_variable_4618;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4609);; homalg_variable_4619 := homalg_variable_l[1];; homalg_variable_4620 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4619);
2
gap> homalg_variable_4621 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4619 = homalg_variable_4621;
false
gap> SI_nrows(homalg_variable_4620);
2
gap> homalg_variable_4622 := homalg_variable_4609 * homalg_variable_4620;;
gap> homalg_variable_4619 = homalg_variable_4622;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4617,homalg_variable_4619);; homalg_variable_4623 := homalg_variable_l[1];; homalg_variable_4624 := homalg_variable_l[2];;
gap> homalg_variable_4625 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4623 = homalg_variable_4625;
true
gap> homalg_variable_4626 := homalg_variable_4619 * homalg_variable_4624;;
gap> homalg_variable_4627 := homalg_variable_4617 + homalg_variable_4626;;
gap> homalg_variable_4623 = homalg_variable_4627;
true
gap> homalg_variable_4628 := SIH_DecideZeroColumns(homalg_variable_4617,homalg_variable_4619);;
gap> homalg_variable_4629 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4628 = homalg_variable_4629;
true
gap> homalg_variable_4630 := homalg_variable_4624 * (homalg_variable_8);;
gap> homalg_variable_4631 := homalg_variable_4620 * homalg_variable_4630;;
gap> homalg_variable_4632 := homalg_variable_4609 * homalg_variable_4631;;
gap> homalg_variable_4632 = homalg_variable_4617;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4609,homalg_variable_4617);; homalg_variable_4633 := homalg_variable_l[1];; homalg_variable_4634 := homalg_variable_l[2];;
gap> homalg_variable_4635 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4633 = homalg_variable_4635;
true
gap> homalg_variable_4636 := homalg_variable_4617 * homalg_variable_4634;;
gap> homalg_variable_4637 := homalg_variable_4609 + homalg_variable_4636;;
gap> homalg_variable_4633 = homalg_variable_4637;
true
gap> homalg_variable_4638 := SIH_DecideZeroColumns(homalg_variable_4609,homalg_variable_4617);;
gap> homalg_variable_4639 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4638 = homalg_variable_4639;
true
gap> homalg_variable_4640 := homalg_variable_4634 * (homalg_variable_8);;
gap> homalg_variable_4641 := homalg_variable_4617 * homalg_variable_4640;;
gap> homalg_variable_4641 = homalg_variable_4609;
true
gap> homalg_variable_4642 := SIH_DecideZeroColumns(homalg_variable_4609,homalg_variable_3419);;
gap> homalg_variable_4643 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_4642 = homalg_variable_4643;
true
gap> homalg_variable_4645 := SIH_Submatrix(homalg_variable_4585,[1..16],[ 14, 15, 16 ]);;
gap> homalg_variable_4646 := homalg_variable_4645 * homalg_variable_2902;;
gap> homalg_variable_4647 := SI_matrix(homalg_variable_5,16,3,"0");;
gap> homalg_variable_4648 := SIH_UnionOfColumns(homalg_variable_4646,homalg_variable_4647);;
gap> homalg_variable_4649 := SIH_Submatrix(homalg_variable_4585,[1..16],[ 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 ]);;
gap> homalg_variable_4650 := homalg_variable_2910 * homalg_variable_3264;;
gap> homalg_variable_4651 := homalg_variable_4649 * homalg_variable_4650;;
gap> homalg_variable_4652 := SIH_UnionOfColumns(homalg_variable_4648,homalg_variable_4651);;
gap> homalg_variable_4653 := SI_matrix(homalg_variable_5,7,14,"0");;
gap> homalg_variable_4654 := SIH_UnionOfRows(homalg_variable_4652,homalg_variable_4653);;
gap> homalg_variable_4655 := SI_matrix(homalg_variable_5,7,5,"0");;
gap> homalg_variable_4656 := SIH_UnionOfRows(homalg_variable_4589,homalg_variable_4655);;
gap> homalg_variable_4657 := SIH_UnionOfColumns(homalg_variable_4656,homalg_variable_4597);;
gap> homalg_variable_4658 := SIH_UnionOfColumns(homalg_variable_4654,homalg_variable_4657);;
gap> homalg_variable_4644 := SIH_BasisOfColumnModule(homalg_variable_4658);;
gap> SI_ncols(homalg_variable_4644);
13
gap> homalg_variable_4659 := SI_matrix(homalg_variable_5,23,13,"0");;
gap> homalg_variable_4644 = homalg_variable_4659;
false
gap> homalg_variable_4660 := SIH_DecideZeroColumns(homalg_variable_4658,homalg_variable_4644);;
gap> homalg_variable_4661 := SI_matrix(homalg_variable_5,23,20,"0");;
gap> homalg_variable_4660 = homalg_variable_4661;
true
gap> homalg_variable_4663 := homalg_variable_3609 * homalg_variable_3734;;
gap> homalg_variable_4664 := homalg_variable_4649 * homalg_variable_4663;;
gap> homalg_variable_4665 := homalg_variable_4664 * homalg_variable_3775;;
gap> homalg_variable_4666 := SI_matrix(homalg_variable_5,7,5,"0");;
gap> homalg_variable_4667 := SIH_UnionOfRows(homalg_variable_4665,homalg_variable_4666);;
gap> homalg_variable_4662 := SIH_DecideZeroColumns(homalg_variable_4667,homalg_variable_4644);;
gap> homalg_variable_4668 := SI_matrix(homalg_variable_5,23,5,"0");;
gap> homalg_variable_4662 = homalg_variable_4668;
true
gap> homalg_variable_4670 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_4671 := SIH_UnionOfRows(homalg_variable_4664,homalg_variable_4670);;
gap> homalg_variable_4669 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4671,homalg_variable_4658);;
gap> SI_ncols(homalg_variable_4669);
5
gap> homalg_variable_4672 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4669 = homalg_variable_4672;
false
gap> homalg_variable_4673 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4669);;
gap> SI_ncols(homalg_variable_4673);
1
gap> homalg_variable_4674 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_4673 = homalg_variable_4674;
false
gap> homalg_variable_4675 := SI_\[(homalg_variable_4673,5,1);;
gap> SI_deg( homalg_variable_4675 );
-1
gap> homalg_variable_4676 := SI_\[(homalg_variable_4673,4,1);;
gap> SI_deg( homalg_variable_4676 );
1
gap> homalg_variable_4677 := SI_\[(homalg_variable_4673,3,1);;
gap> SI_deg( homalg_variable_4677 );
1
gap> homalg_variable_4678 := SI_\[(homalg_variable_4673,2,1);;
gap> SI_deg( homalg_variable_4678 );
1
gap> homalg_variable_4679 := SI_\[(homalg_variable_4673,1,1);;
gap> SI_deg( homalg_variable_4679 );
-1
gap> homalg_variable_4680 := SIH_BasisOfColumnModule(homalg_variable_4669);;
gap> SI_ncols(homalg_variable_4680);
5
gap> homalg_variable_4681 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4680 = homalg_variable_4681;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4669);; homalg_variable_4682 := homalg_variable_l[1];; homalg_variable_4683 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4682);
5
gap> homalg_variable_4684 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4682 = homalg_variable_4684;
false
gap> SI_nrows(homalg_variable_4683);
5
gap> homalg_variable_4685 := homalg_variable_4669 * homalg_variable_4683;;
gap> homalg_variable_4682 = homalg_variable_4685;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4680,homalg_variable_4682);; homalg_variable_4686 := homalg_variable_l[1];; homalg_variable_4687 := homalg_variable_l[2];;
gap> homalg_variable_4688 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4686 = homalg_variable_4688;
true
gap> homalg_variable_4689 := homalg_variable_4682 * homalg_variable_4687;;
gap> homalg_variable_4690 := homalg_variable_4680 + homalg_variable_4689;;
gap> homalg_variable_4686 = homalg_variable_4690;
true
gap> homalg_variable_4691 := SIH_DecideZeroColumns(homalg_variable_4680,homalg_variable_4682);;
gap> homalg_variable_4692 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4691 = homalg_variable_4692;
true
gap> homalg_variable_4693 := homalg_variable_4687 * (homalg_variable_8);;
gap> homalg_variable_4694 := homalg_variable_4683 * homalg_variable_4693;;
gap> homalg_variable_4695 := homalg_variable_4669 * homalg_variable_4694;;
gap> homalg_variable_4695 = homalg_variable_4680;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4669,homalg_variable_4680);; homalg_variable_4696 := homalg_variable_l[1];; homalg_variable_4697 := homalg_variable_l[2];;
gap> homalg_variable_4698 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4696 = homalg_variable_4698;
true
gap> homalg_variable_4699 := homalg_variable_4680 * homalg_variable_4697;;
gap> homalg_variable_4700 := homalg_variable_4669 + homalg_variable_4699;;
gap> homalg_variable_4696 = homalg_variable_4700;
true
gap> homalg_variable_4701 := SIH_DecideZeroColumns(homalg_variable_4669,homalg_variable_4680);;
gap> homalg_variable_4702 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4701 = homalg_variable_4702;
true
gap> homalg_variable_4703 := homalg_variable_4697 * (homalg_variable_8);;
gap> homalg_variable_4704 := homalg_variable_4680 * homalg_variable_4703;;
gap> homalg_variable_4704 = homalg_variable_4669;
true
gap> homalg_variable_4705 := SIH_DecideZeroColumns(homalg_variable_4669,homalg_variable_3775);;
gap> homalg_variable_4706 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_4705 = homalg_variable_4706;
true
gap> homalg_variable_4708 := SI_matrix(homalg_variable_5,16,14,"0");;
gap> homalg_variable_4709 := SIH_Submatrix(homalg_variable_1375,[1..7],[ 3, 4, 5, 6, 7 ]);;
gap> homalg_variable_4710 := homalg_variable_4709 * homalg_variable_2988;;
gap> homalg_variable_4711 := SI_matrix(homalg_variable_5,7,5,"0");;
gap> homalg_variable_4712 := SIH_UnionOfColumns(homalg_variable_4710,homalg_variable_4711);;
gap> homalg_variable_4713 := SIH_UnionOfRows(homalg_variable_4708,homalg_variable_4712);;
gap> homalg_variable_4714 := SI_matrix(homalg_variable_5,7,10,"0");;
gap> homalg_variable_4715 := SIH_UnionOfRows(homalg_variable_4649,homalg_variable_4714);;
gap> homalg_variable_4716 := SIH_UnionOfColumns(homalg_variable_4715,homalg_variable_4657);;
gap> homalg_variable_4717 := SIH_UnionOfColumns(homalg_variable_4713,homalg_variable_4716);;
gap> homalg_variable_4707 := SIH_BasisOfColumnModule(homalg_variable_4717);;
gap> SI_ncols(homalg_variable_4707);
21
gap> homalg_variable_4718 := SI_matrix(homalg_variable_5,23,21,"0");;
gap> homalg_variable_4707 = homalg_variable_4718;
false
gap> homalg_variable_4719 := SIH_DecideZeroColumns(homalg_variable_4717,homalg_variable_4707);;
gap> homalg_variable_4720 := SI_matrix(homalg_variable_5,23,30,"0");;
gap> homalg_variable_4719 = homalg_variable_4720;
true
gap> homalg_variable_4722 := SI_matrix(homalg_variable_5,16,4,"0");;
gap> homalg_variable_4723 := homalg_variable_3856 * homalg_variable_3935;;
gap> homalg_variable_4724 := homalg_variable_4723 * homalg_variable_3975;;
gap> homalg_variable_4725 := SIH_UnionOfRows(homalg_variable_4722,homalg_variable_4724);;
gap> homalg_variable_4721 := SIH_DecideZeroColumns(homalg_variable_4725,homalg_variable_4707);;
gap> homalg_variable_4726 := SI_matrix(homalg_variable_5,23,4,"0");;
gap> homalg_variable_4721 = homalg_variable_4726;
true
gap> homalg_variable_4728 := SI_matrix(homalg_variable_5,16,5,"0");;
gap> homalg_variable_4729 := SIH_UnionOfRows(homalg_variable_4728,homalg_variable_4723);;
gap> homalg_variable_4727 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4729,homalg_variable_4717);;
gap> SI_ncols(homalg_variable_4727);
4
gap> homalg_variable_4730 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4727 = homalg_variable_4730;
false
gap> homalg_variable_4731 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4727);;
gap> SI_ncols(homalg_variable_4731);
1
gap> homalg_variable_4732 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4731 = homalg_variable_4732;
false
gap> homalg_variable_4733 := SI_\[(homalg_variable_4731,4,1);;
gap> SI_deg( homalg_variable_4733 );
-1
gap> homalg_variable_4734 := SI_\[(homalg_variable_4731,3,1);;
gap> SI_deg( homalg_variable_4734 );
1
gap> homalg_variable_4735 := SI_\[(homalg_variable_4731,2,1);;
gap> SI_deg( homalg_variable_4735 );
1
gap> homalg_variable_4736 := SI_\[(homalg_variable_4731,1,1);;
gap> SI_deg( homalg_variable_4736 );
1
gap> homalg_variable_4737 := SIH_BasisOfColumnModule(homalg_variable_4727);;
gap> SI_ncols(homalg_variable_4737);
4
gap> homalg_variable_4738 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4737 = homalg_variable_4738;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4727);; homalg_variable_4739 := homalg_variable_l[1];; homalg_variable_4740 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4739);
4
gap> homalg_variable_4741 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4739 = homalg_variable_4741;
false
gap> SI_nrows(homalg_variable_4740);
4
gap> homalg_variable_4742 := homalg_variable_4727 * homalg_variable_4740;;
gap> homalg_variable_4739 = homalg_variable_4742;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4737,homalg_variable_4739);; homalg_variable_4743 := homalg_variable_l[1];; homalg_variable_4744 := homalg_variable_l[2];;
gap> homalg_variable_4745 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4743 = homalg_variable_4745;
true
gap> homalg_variable_4746 := homalg_variable_4739 * homalg_variable_4744;;
gap> homalg_variable_4747 := homalg_variable_4737 + homalg_variable_4746;;
gap> homalg_variable_4743 = homalg_variable_4747;
true
gap> homalg_variable_4748 := SIH_DecideZeroColumns(homalg_variable_4737,homalg_variable_4739);;
gap> homalg_variable_4749 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4748 = homalg_variable_4749;
true
gap> homalg_variable_4750 := homalg_variable_4744 * (homalg_variable_8);;
gap> homalg_variable_4751 := homalg_variable_4740 * homalg_variable_4750;;
gap> homalg_variable_4752 := homalg_variable_4727 * homalg_variable_4751;;
gap> homalg_variable_4752 = homalg_variable_4737;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4727,homalg_variable_4737);; homalg_variable_4753 := homalg_variable_l[1];; homalg_variable_4754 := homalg_variable_l[2];;
gap> homalg_variable_4755 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4753 = homalg_variable_4755;
true
gap> homalg_variable_4756 := homalg_variable_4737 * homalg_variable_4754;;
gap> homalg_variable_4757 := homalg_variable_4727 + homalg_variable_4756;;
gap> homalg_variable_4753 = homalg_variable_4757;
true
gap> homalg_variable_4758 := SIH_DecideZeroColumns(homalg_variable_4727,homalg_variable_4737);;
gap> homalg_variable_4759 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4758 = homalg_variable_4759;
true
gap> homalg_variable_4760 := homalg_variable_4754 * (homalg_variable_8);;
gap> homalg_variable_4761 := homalg_variable_4737 * homalg_variable_4760;;
gap> homalg_variable_4761 = homalg_variable_4727;
true
gap> homalg_variable_4762 := SIH_DecideZeroColumns(homalg_variable_4727,homalg_variable_3975);;
gap> homalg_variable_4763 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4762 = homalg_variable_4763;
true
gap> homalg_variable_4764 := SIH_DecideZeroColumns(homalg_variable_4529,homalg_variable_4503);;
gap> homalg_variable_4765 := SI_matrix(homalg_variable_5,23,5,"0");;
gap> homalg_variable_4764 = homalg_variable_4765;
false
gap> homalg_variable_4766 := SIH_UnionOfColumns(homalg_variable_4764,homalg_variable_4503);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4766);; homalg_variable_4767 := homalg_variable_l[1];; homalg_variable_4768 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4767);
27
gap> homalg_variable_4769 := SI_matrix(homalg_variable_5,23,27,"0");;
gap> homalg_variable_4767 = homalg_variable_4769;
false
gap> SI_nrows(homalg_variable_4768);
30
gap> homalg_variable_4770 := SIH_Submatrix(homalg_variable_4768,[ 1, 2, 3, 4, 5 ],[1..27]);;
gap> homalg_variable_4771 := homalg_variable_4764 * homalg_variable_4770;;
gap> homalg_variable_4772 := SIH_Submatrix(homalg_variable_4768,[ 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 ],[1..27]);;
gap> homalg_variable_4773 := homalg_variable_4503 * homalg_variable_4772;;
gap> homalg_variable_4774 := homalg_variable_4771 + homalg_variable_4773;;
gap> homalg_variable_4767 = homalg_variable_4774;
true
gap> homalg_variable_4775 := SIH_DecideZeroColumns(homalg_variable_4729,homalg_variable_4503);;
gap> homalg_variable_4776 := SI_matrix(homalg_variable_5,23,5,"0");;
gap> homalg_variable_4775 = homalg_variable_4776;
false
gap> homalg_variable_4777 := SI_matrix(homalg_variable_5,7,5,"0");;
gap> homalg_variable_4723 = homalg_variable_4777;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4775,homalg_variable_4767);; homalg_variable_4778 := homalg_variable_l[1];; homalg_variable_4779 := homalg_variable_l[2];;
gap> homalg_variable_4780 := SI_matrix(homalg_variable_5,23,5,"0");;
gap> homalg_variable_4778 = homalg_variable_4780;
false
gap> homalg_variable_4781 := homalg_variable_4767 * homalg_variable_4779;;
gap> homalg_variable_4782 := homalg_variable_4775 + homalg_variable_4781;;
gap> homalg_variable_4778 = homalg_variable_4782;
true
gap> homalg_variable_4783 := SIH_DecideZeroColumns(homalg_variable_4775,homalg_variable_4767);;
gap> homalg_variable_4784 := SI_matrix(homalg_variable_5,23,5,"0");;
gap> homalg_variable_4783 = homalg_variable_4784;
false
gap> homalg_variable_4778 = homalg_variable_4783;
true
gap> homalg_variable_4786 := SIH_UnionOfColumns(homalg_variable_4717,homalg_variable_4518);;
gap> homalg_variable_4785 := SIH_BasisOfColumnModule(homalg_variable_4786);;
gap> SI_ncols(homalg_variable_4785);
21
gap> homalg_variable_4787 := SI_matrix(homalg_variable_5,23,21,"0");;
gap> homalg_variable_4785 = homalg_variable_4787;
false
gap> homalg_variable_4788 := SIH_DecideZeroColumns(homalg_variable_4529,homalg_variable_4785);;
gap> homalg_variable_4789 := SI_matrix(homalg_variable_5,23,5,"0");;
gap> homalg_variable_4788 = homalg_variable_4789;
false
gap> homalg_variable_4790 := SIH_UnionOfColumns(homalg_variable_4788,homalg_variable_4785);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4790);; homalg_variable_4791 := homalg_variable_l[1];; homalg_variable_4792 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4791);
26
gap> homalg_variable_4793 := SI_matrix(homalg_variable_5,23,26,"0");;
gap> homalg_variable_4791 = homalg_variable_4793;
false
gap> SI_nrows(homalg_variable_4792);
26
gap> homalg_variable_4794 := SIH_Submatrix(homalg_variable_4792,[ 1, 2, 3, 4, 5 ],[1..26]);;
gap> homalg_variable_4795 := homalg_variable_4788 * homalg_variable_4794;;
gap> homalg_variable_4796 := SIH_Submatrix(homalg_variable_4792,[ 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 ],[1..26]);;
gap> homalg_variable_4797 := homalg_variable_4785 * homalg_variable_4796;;
gap> homalg_variable_4798 := homalg_variable_4795 + homalg_variable_4797;;
gap> homalg_variable_4791 = homalg_variable_4798;
true
gap> homalg_variable_4799 := SIH_DecideZeroColumns(homalg_variable_4729,homalg_variable_4785);;
gap> homalg_variable_4800 := SI_matrix(homalg_variable_5,23,5,"0");;
gap> homalg_variable_4799 = homalg_variable_4800;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4799,homalg_variable_4791);; homalg_variable_4801 := homalg_variable_l[1];; homalg_variable_4802 := homalg_variable_l[2];;
gap> homalg_variable_4803 := SI_matrix(homalg_variable_5,23,5,"0");;
gap> homalg_variable_4801 = homalg_variable_4803;
true
gap> homalg_variable_4804 := homalg_variable_4791 * homalg_variable_4802;;
gap> homalg_variable_4805 := homalg_variable_4799 + homalg_variable_4804;;
gap> homalg_variable_4801 = homalg_variable_4805;
true
gap> homalg_variable_4806 := SIH_DecideZeroColumns(homalg_variable_4799,homalg_variable_4791);;
gap> homalg_variable_4807 := SI_matrix(homalg_variable_5,23,5,"0");;
gap> homalg_variable_4806 = homalg_variable_4807;
true
gap> homalg_variable_4809 := SIH_Submatrix(homalg_variable_4792,[ 1, 2, 3, 4, 5 ],[1..26]);;
gap> homalg_variable_4810 := homalg_variable_4802 * (homalg_variable_8);;
gap> homalg_variable_4811 := homalg_variable_4809 * homalg_variable_4810;;
gap> homalg_variable_4812 := homalg_variable_3983 * homalg_variable_4811;;
gap> homalg_variable_4813 := SIH_UnionOfRows(homalg_variable_4528,homalg_variable_4812);;
gap> homalg_variable_4814 := homalg_variable_4813 - homalg_variable_4729;;
gap> homalg_variable_4808 := SIH_DecideZeroColumns(homalg_variable_4814,homalg_variable_4785);;
gap> homalg_variable_4815 := SI_matrix(homalg_variable_5,23,5,"0");;
gap> homalg_variable_4808 = homalg_variable_4815;
true
gap> homalg_variable_4816 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4529,homalg_variable_4786);;
gap> SI_ncols(homalg_variable_4816);
4
gap> homalg_variable_4817 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4816 = homalg_variable_4817;
false
gap> homalg_variable_4818 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4816);;
gap> SI_ncols(homalg_variable_4818);
1
gap> homalg_variable_4819 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4818 = homalg_variable_4819;
false
gap> homalg_variable_4820 := SI_\[(homalg_variable_4818,4,1);;
gap> SI_deg( homalg_variable_4820 );
1
gap> homalg_variable_4821 := SI_\[(homalg_variable_4818,3,1);;
gap> SI_deg( homalg_variable_4821 );
1
gap> homalg_variable_4822 := SI_\[(homalg_variable_4818,2,1);;
gap> SI_deg( homalg_variable_4822 );
1
gap> homalg_variable_4823 := SI_\[(homalg_variable_4818,1,1);;
gap> SI_deg( homalg_variable_4823 );
-1
gap> homalg_variable_4824 := SIH_BasisOfColumnModule(homalg_variable_4816);;
gap> SI_ncols(homalg_variable_4824);
4
gap> homalg_variable_4825 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4824 = homalg_variable_4825;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4816);; homalg_variable_4826 := homalg_variable_l[1];; homalg_variable_4827 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4826);
4
gap> homalg_variable_4828 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4826 = homalg_variable_4828;
false
gap> SI_nrows(homalg_variable_4827);
4
gap> homalg_variable_4829 := homalg_variable_4816 * homalg_variable_4827;;
gap> homalg_variable_4826 = homalg_variable_4829;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4824,homalg_variable_4826);; homalg_variable_4830 := homalg_variable_l[1];; homalg_variable_4831 := homalg_variable_l[2];;
gap> homalg_variable_4832 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4830 = homalg_variable_4832;
true
gap> homalg_variable_4833 := homalg_variable_4826 * homalg_variable_4831;;
gap> homalg_variable_4834 := homalg_variable_4824 + homalg_variable_4833;;
gap> homalg_variable_4830 = homalg_variable_4834;
true
gap> homalg_variable_4835 := SIH_DecideZeroColumns(homalg_variable_4824,homalg_variable_4826);;
gap> homalg_variable_4836 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4835 = homalg_variable_4836;
true
gap> homalg_variable_4837 := homalg_variable_4831 * (homalg_variable_8);;
gap> homalg_variable_4838 := homalg_variable_4827 * homalg_variable_4837;;
gap> homalg_variable_4839 := homalg_variable_4816 * homalg_variable_4838;;
gap> homalg_variable_4839 = homalg_variable_4824;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4816,homalg_variable_4824);; homalg_variable_4840 := homalg_variable_l[1];; homalg_variable_4841 := homalg_variable_l[2];;
gap> homalg_variable_4842 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4840 = homalg_variable_4842;
true
gap> homalg_variable_4843 := homalg_variable_4824 * homalg_variable_4841;;
gap> homalg_variable_4844 := homalg_variable_4816 + homalg_variable_4843;;
gap> homalg_variable_4840 = homalg_variable_4844;
true
gap> homalg_variable_4845 := SIH_DecideZeroColumns(homalg_variable_4816,homalg_variable_4824);;
gap> homalg_variable_4846 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4845 = homalg_variable_4846;
true
gap> homalg_variable_4847 := homalg_variable_4841 * (homalg_variable_8);;
gap> homalg_variable_4848 := homalg_variable_4824 * homalg_variable_4847;;
gap> homalg_variable_4848 = homalg_variable_4816;
true
gap> homalg_variable_4850 := SIH_UnionOfColumns(homalg_variable_4816,homalg_variable_4431);;
gap> homalg_variable_4849 := SIH_BasisOfColumnModule(homalg_variable_4850);;
gap> SI_ncols(homalg_variable_4849);
4
gap> homalg_variable_4851 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4849 = homalg_variable_4851;
false
gap> homalg_variable_4852 := SIH_DecideZeroColumns(homalg_variable_4816,homalg_variable_4849);;
gap> homalg_variable_4853 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4852 = homalg_variable_4853;
true
gap> homalg_variable_4855 := homalg_variable_4811 * homalg_variable_3975;;
gap> homalg_variable_4854 := SIH_DecideZeroColumns(homalg_variable_4855,homalg_variable_4849);;
gap> homalg_variable_4856 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4854 = homalg_variable_4856;
true
gap> homalg_variable_4857 := SIH_DecideZeroColumns(homalg_variable_4529,homalg_variable_4503);;
gap> homalg_variable_4858 := SI_matrix(homalg_variable_5,23,5,"0");;
gap> homalg_variable_4857 = homalg_variable_4858;
false
gap> homalg_variable_4859 := SIH_UnionOfColumns(homalg_variable_4857,homalg_variable_4503);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4859);; homalg_variable_4860 := homalg_variable_l[1];; homalg_variable_4861 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4860);
27
gap> homalg_variable_4862 := SI_matrix(homalg_variable_5,23,27,"0");;
gap> homalg_variable_4860 = homalg_variable_4862;
false
gap> SI_nrows(homalg_variable_4861);
30
gap> homalg_variable_4863 := SIH_Submatrix(homalg_variable_4861,[ 1, 2, 3, 4, 5 ],[1..27]);;
gap> homalg_variable_4864 := homalg_variable_4857 * homalg_variable_4863;;
gap> homalg_variable_4865 := SIH_Submatrix(homalg_variable_4861,[ 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 ],[1..27]);;
gap> homalg_variable_4866 := homalg_variable_4503 * homalg_variable_4865;;
gap> homalg_variable_4867 := homalg_variable_4864 + homalg_variable_4866;;
gap> homalg_variable_4860 = homalg_variable_4867;
true
gap> homalg_variable_4868 := SIH_DecideZeroColumns(homalg_variable_4671,homalg_variable_4503);;
gap> homalg_variable_4869 := SI_matrix(homalg_variable_5,23,4,"0");;
gap> homalg_variable_4868 = homalg_variable_4869;
false
gap> homalg_variable_4870 := SI_matrix(homalg_variable_5,16,4,"0");;
gap> homalg_variable_4664 = homalg_variable_4870;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4868,homalg_variable_4860);; homalg_variable_4871 := homalg_variable_l[1];; homalg_variable_4872 := homalg_variable_l[2];;
gap> homalg_variable_4873 := SI_matrix(homalg_variable_5,23,4,"0");;
gap> homalg_variable_4871 = homalg_variable_4873;
false
gap> homalg_variable_4874 := homalg_variable_4860 * homalg_variable_4872;;
gap> homalg_variable_4875 := homalg_variable_4868 + homalg_variable_4874;;
gap> homalg_variable_4871 = homalg_variable_4875;
true
gap> homalg_variable_4876 := SIH_DecideZeroColumns(homalg_variable_4868,homalg_variable_4860);;
gap> homalg_variable_4877 := SI_matrix(homalg_variable_5,23,4,"0");;
gap> homalg_variable_4876 = homalg_variable_4877;
false
gap> homalg_variable_4871 = homalg_variable_4876;
true
gap> homalg_variable_4879 := SIH_UnionOfColumns(homalg_variable_4658,homalg_variable_4518);;
gap> homalg_variable_4878 := SIH_BasisOfColumnModule(homalg_variable_4879);;
gap> SI_ncols(homalg_variable_4878);
20
gap> homalg_variable_4880 := SI_matrix(homalg_variable_5,23,20,"0");;
gap> homalg_variable_4878 = homalg_variable_4880;
false
gap> homalg_variable_4881 := SIH_DecideZeroColumns(homalg_variable_4529,homalg_variable_4878);;
gap> homalg_variable_4882 := SI_matrix(homalg_variable_5,23,5,"0");;
gap> homalg_variable_4881 = homalg_variable_4882;
false
gap> homalg_variable_4883 := SIH_UnionOfColumns(homalg_variable_4881,homalg_variable_4878);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4883);; homalg_variable_4884 := homalg_variable_l[1];; homalg_variable_4885 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4884);
27
gap> homalg_variable_4886 := SI_matrix(homalg_variable_5,23,27,"0");;
gap> homalg_variable_4884 = homalg_variable_4886;
false
gap> SI_nrows(homalg_variable_4885);
25
gap> homalg_variable_4887 := SIH_Submatrix(homalg_variable_4885,[ 1, 2, 3, 4, 5 ],[1..27]);;
gap> homalg_variable_4888 := homalg_variable_4881 * homalg_variable_4887;;
gap> homalg_variable_4889 := SIH_Submatrix(homalg_variable_4885,[ 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 ],[1..27]);;
gap> homalg_variable_4890 := homalg_variable_4878 * homalg_variable_4889;;
gap> homalg_variable_4891 := homalg_variable_4888 + homalg_variable_4890;;
gap> homalg_variable_4884 = homalg_variable_4891;
true
gap> homalg_variable_4892 := SIH_DecideZeroColumns(homalg_variable_4671,homalg_variable_4878);;
gap> homalg_variable_4893 := SI_matrix(homalg_variable_5,23,4,"0");;
gap> homalg_variable_4892 = homalg_variable_4893;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4892,homalg_variable_4884);; homalg_variable_4894 := homalg_variable_l[1];; homalg_variable_4895 := homalg_variable_l[2];;
gap> homalg_variable_4896 := SI_matrix(homalg_variable_5,23,4,"0");;
gap> homalg_variable_4894 = homalg_variable_4896;
true
gap> homalg_variable_4897 := homalg_variable_4884 * homalg_variable_4895;;
gap> homalg_variable_4898 := homalg_variable_4892 + homalg_variable_4897;;
gap> homalg_variable_4894 = homalg_variable_4898;
true
gap> homalg_variable_4899 := SIH_DecideZeroColumns(homalg_variable_4892,homalg_variable_4884);;
gap> homalg_variable_4900 := SI_matrix(homalg_variable_5,23,4,"0");;
gap> homalg_variable_4899 = homalg_variable_4900;
true
gap> homalg_variable_4902 := SI_matrix(homalg_variable_5,16,4,"0");;
gap> homalg_variable_4903 := SIH_Submatrix(homalg_variable_4885,[ 1, 2, 3, 4, 5 ],[1..27]);;
gap> homalg_variable_4904 := homalg_variable_4895 * (homalg_variable_8);;
gap> homalg_variable_4905 := homalg_variable_4903 * homalg_variable_4904;;
gap> homalg_variable_4906 := homalg_variable_3983 * homalg_variable_4905;;
gap> homalg_variable_4907 := SIH_UnionOfRows(homalg_variable_4902,homalg_variable_4906);;
gap> homalg_variable_4908 := homalg_variable_4907 - homalg_variable_4671;;
gap> homalg_variable_4901 := SIH_DecideZeroColumns(homalg_variable_4908,homalg_variable_4878);;
gap> homalg_variable_4909 := SI_matrix(homalg_variable_5,23,4,"0");;
gap> homalg_variable_4901 = homalg_variable_4909;
true
gap> homalg_variable_4910 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4529,homalg_variable_4879);;
gap> SI_ncols(homalg_variable_4910);
4
gap> homalg_variable_4911 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4910 = homalg_variable_4911;
false
gap> homalg_variable_4912 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_4910);;
gap> SI_ncols(homalg_variable_4912);
1
gap> homalg_variable_4913 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_4912 = homalg_variable_4913;
false
gap> homalg_variable_4914 := SI_\[(homalg_variable_4912,4,1);;
gap> SI_deg( homalg_variable_4914 );
1
gap> homalg_variable_4915 := SI_\[(homalg_variable_4912,3,1);;
gap> SI_deg( homalg_variable_4915 );
-1
gap> homalg_variable_4916 := SI_\[(homalg_variable_4912,2,1);;
gap> SI_deg( homalg_variable_4916 );
1
gap> homalg_variable_4917 := SI_\[(homalg_variable_4912,1,1);;
gap> SI_deg( homalg_variable_4917 );
2
gap> homalg_variable_4918 := SIH_BasisOfColumnModule(homalg_variable_4910);;
gap> SI_ncols(homalg_variable_4918);
4
gap> homalg_variable_4919 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4918 = homalg_variable_4919;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4910);; homalg_variable_4920 := homalg_variable_l[1];; homalg_variable_4921 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4920);
4
gap> homalg_variable_4922 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4920 = homalg_variable_4922;
false
gap> SI_nrows(homalg_variable_4921);
4
gap> homalg_variable_4923 := homalg_variable_4910 * homalg_variable_4921;;
gap> homalg_variable_4920 = homalg_variable_4923;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4918,homalg_variable_4920);; homalg_variable_4924 := homalg_variable_l[1];; homalg_variable_4925 := homalg_variable_l[2];;
gap> homalg_variable_4926 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4924 = homalg_variable_4926;
true
gap> homalg_variable_4927 := homalg_variable_4920 * homalg_variable_4925;;
gap> homalg_variable_4928 := homalg_variable_4918 + homalg_variable_4927;;
gap> homalg_variable_4924 = homalg_variable_4928;
true
gap> homalg_variable_4929 := SIH_DecideZeroColumns(homalg_variable_4918,homalg_variable_4920);;
gap> homalg_variable_4930 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4929 = homalg_variable_4930;
true
gap> homalg_variable_4931 := homalg_variable_4925 * (homalg_variable_8);;
gap> homalg_variable_4932 := homalg_variable_4921 * homalg_variable_4931;;
gap> homalg_variable_4933 := homalg_variable_4910 * homalg_variable_4932;;
gap> homalg_variable_4933 = homalg_variable_4918;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4910,homalg_variable_4918);; homalg_variable_4934 := homalg_variable_l[1];; homalg_variable_4935 := homalg_variable_l[2];;
gap> homalg_variable_4936 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4934 = homalg_variable_4936;
true
gap> homalg_variable_4937 := homalg_variable_4918 * homalg_variable_4935;;
gap> homalg_variable_4938 := homalg_variable_4910 + homalg_variable_4937;;
gap> homalg_variable_4934 = homalg_variable_4938;
true
gap> homalg_variable_4939 := SIH_DecideZeroColumns(homalg_variable_4910,homalg_variable_4918);;
gap> homalg_variable_4940 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4939 = homalg_variable_4940;
true
gap> homalg_variable_4941 := homalg_variable_4935 * (homalg_variable_8);;
gap> homalg_variable_4942 := homalg_variable_4918 * homalg_variable_4941;;
gap> homalg_variable_4942 = homalg_variable_4910;
true
gap> homalg_variable_4944 := SIH_UnionOfColumns(homalg_variable_4910,homalg_variable_4431);;
gap> homalg_variable_4943 := SIH_BasisOfColumnModule(homalg_variable_4944);;
gap> SI_ncols(homalg_variable_4943);
4
gap> homalg_variable_4945 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4943 = homalg_variable_4945;
false
gap> homalg_variable_4946 := SIH_DecideZeroColumns(homalg_variable_4910,homalg_variable_4943);;
gap> homalg_variable_4947 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_4946 = homalg_variable_4947;
true
gap> homalg_variable_4949 := homalg_variable_4905 * homalg_variable_3775;;
gap> homalg_variable_4948 := SIH_DecideZeroColumns(homalg_variable_4949,homalg_variable_4943);;
gap> homalg_variable_4950 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_4948 = homalg_variable_4950;
true
gap> homalg_variable_4951 := SIH_DecideZeroColumns(homalg_variable_4529,homalg_variable_4503);;
gap> homalg_variable_4952 := SI_matrix(homalg_variable_5,23,5,"0");;
gap> homalg_variable_4951 = homalg_variable_4952;
false
gap> homalg_variable_4953 := SIH_UnionOfColumns(homalg_variable_4951,homalg_variable_4503);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4953);; homalg_variable_4954 := homalg_variable_l[1];; homalg_variable_4955 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4954);
27
gap> homalg_variable_4956 := SI_matrix(homalg_variable_5,23,27,"0");;
gap> homalg_variable_4954 = homalg_variable_4956;
false
gap> SI_nrows(homalg_variable_4955);
30
gap> homalg_variable_4957 := SIH_Submatrix(homalg_variable_4955,[ 1, 2, 3, 4, 5 ],[1..27]);;
gap> homalg_variable_4958 := homalg_variable_4951 * homalg_variable_4957;;
gap> homalg_variable_4959 := SIH_Submatrix(homalg_variable_4955,[ 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 ],[1..27]);;
gap> homalg_variable_4960 := homalg_variable_4503 * homalg_variable_4959;;
gap> homalg_variable_4961 := homalg_variable_4958 + homalg_variable_4960;;
gap> homalg_variable_4954 = homalg_variable_4961;
true
gap> homalg_variable_4962 := SIH_DecideZeroColumns(homalg_variable_4611,homalg_variable_4503);;
gap> homalg_variable_4963 := SI_matrix(homalg_variable_5,23,1,"0");;
gap> homalg_variable_4962 = homalg_variable_4963;
false
gap> homalg_variable_4964 := SI_matrix(homalg_variable_5,16,1,"0");;
gap> homalg_variable_4604 = homalg_variable_4964;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4962,homalg_variable_4954);; homalg_variable_4965 := homalg_variable_l[1];; homalg_variable_4966 := homalg_variable_l[2];;
gap> homalg_variable_4967 := SI_matrix(homalg_variable_5,23,1,"0");;
gap> homalg_variable_4965 = homalg_variable_4967;
true
gap> homalg_variable_4968 := homalg_variable_4954 * homalg_variable_4966;;
gap> homalg_variable_4969 := homalg_variable_4962 + homalg_variable_4968;;
gap> homalg_variable_4965 = homalg_variable_4969;
true
gap> homalg_variable_4970 := SIH_DecideZeroColumns(homalg_variable_4962,homalg_variable_4954);;
gap> homalg_variable_4971 := SI_matrix(homalg_variable_5,23,1,"0");;
gap> homalg_variable_4970 = homalg_variable_4971;
true
gap> homalg_variable_4973 := SI_matrix(homalg_variable_5,16,1,"0");;
gap> homalg_variable_4974 := SIH_Submatrix(homalg_variable_4955,[ 1, 2, 3, 4, 5 ],[1..27]);;
gap> homalg_variable_4975 := homalg_variable_4966 * (homalg_variable_8);;
gap> homalg_variable_4976 := homalg_variable_4974 * homalg_variable_4975;;
gap> homalg_variable_4977 := homalg_variable_3983 * homalg_variable_4976;;
gap> homalg_variable_4978 := SIH_UnionOfRows(homalg_variable_4973,homalg_variable_4977);;
gap> homalg_variable_4979 := homalg_variable_4978 - homalg_variable_4611;;
gap> homalg_variable_4972 := SIH_DecideZeroColumns(homalg_variable_4979,homalg_variable_4503);;
gap> homalg_variable_4980 := SI_matrix(homalg_variable_5,23,1,"0");;
gap> homalg_variable_4972 = homalg_variable_4980;
true
gap> homalg_variable_4981 := SIH_DecideZeroColumns(homalg_variable_4529,homalg_variable_4503);;
gap> homalg_variable_4982 := SI_matrix(homalg_variable_5,23,5,"0");;
gap> homalg_variable_4981 = homalg_variable_4982;
false
gap> homalg_variable_4983 := SIH_UnionOfColumns(homalg_variable_4981,homalg_variable_4503);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_4983);; homalg_variable_4984 := homalg_variable_l[1];; homalg_variable_4985 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_4984);
27
gap> homalg_variable_4986 := SI_matrix(homalg_variable_5,23,27,"0");;
gap> homalg_variable_4984 = homalg_variable_4986;
false
gap> SI_nrows(homalg_variable_4985);
30
gap> homalg_variable_4987 := SIH_Submatrix(homalg_variable_4985,[ 1, 2, 3, 4, 5 ],[1..27]);;
gap> homalg_variable_4988 := homalg_variable_4981 * homalg_variable_4987;;
gap> homalg_variable_4989 := SIH_Submatrix(homalg_variable_4985,[ 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 ],[1..27]);;
gap> homalg_variable_4990 := homalg_variable_4503 * homalg_variable_4989;;
gap> homalg_variable_4991 := homalg_variable_4988 + homalg_variable_4990;;
gap> homalg_variable_4984 = homalg_variable_4991;
true
gap> homalg_variable_4992 := SIH_DecideZeroColumns(homalg_variable_4597,homalg_variable_4503);;
gap> homalg_variable_4993 := SI_matrix(homalg_variable_5,23,1,"0");;
gap> homalg_variable_4992 = homalg_variable_4993;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_4992,homalg_variable_4984);; homalg_variable_4994 := homalg_variable_l[1];; homalg_variable_4995 := homalg_variable_l[2];;
gap> homalg_variable_4996 := SI_matrix(homalg_variable_5,23,1,"0");;
gap> homalg_variable_4994 = homalg_variable_4996;
true
gap> homalg_variable_4997 := homalg_variable_4984 * homalg_variable_4995;;
gap> homalg_variable_4998 := homalg_variable_4992 + homalg_variable_4997;;
gap> homalg_variable_4994 = homalg_variable_4998;
true
gap> homalg_variable_4999 := SIH_DecideZeroColumns(homalg_variable_4992,homalg_variable_4984);;
gap> homalg_variable_5000 := SI_matrix(homalg_variable_5,23,1,"0");;
gap> homalg_variable_4999 = homalg_variable_5000;
true
gap> for _del in [ "homalg_variable_4489", "homalg_variable_4490", "homalg_variable_4491", "homalg_variable_4492", "homalg_variable_4493", "homalg_variable_4494", "homalg_variable_4495", "homalg_variable_4496", "homalg_variable_4497", "homalg_variable_4498", "homalg_variable_4500", "homalg_variable_4501", "homalg_variable_4502", "homalg_variable_4519", "homalg_variable_4521", "homalg_variable_4522", "homalg_variable_4523", "homalg_variable_4524", "homalg_variable_4525", "homalg_variable_4526", "homalg_variable_4530", "homalg_variable_4532", "homalg_variable_4533", "homalg_variable_4534", "homalg_variable_4535", "homalg_variable_4536", "homalg_variable_4537", "homalg_variable_4538", "homalg_variable_4539", "homalg_variable_4540", "homalg_variable_4541", "homalg_variable_4542", "homalg_variable_4543", "homalg_variable_4544", "homalg_variable_4545", "homalg_variable_4546", "homalg_variable_4547", "homalg_variable_4548", "homalg_variable_4549", "homalg_variable_4550", "homalg_variable_4551", "homalg_variable_4552", "homalg_variable_4553", "homalg_variable_4554", "homalg_variable_4555", "homalg_variable_4556", "homalg_variable_4558", "homalg_variable_4561", "homalg_variable_4562", "homalg_variable_4566", "homalg_variable_4567", "homalg_variable_4568", "homalg_variable_4569", "homalg_variable_4572", "homalg_variable_4573", "homalg_variable_4574", "homalg_variable_4575", "homalg_variable_4576", "homalg_variable_4577", "homalg_variable_4578", "homalg_variable_4579", "homalg_variable_4580", "homalg_variable_4581", "homalg_variable_4582", "homalg_variable_4583", "homalg_variable_4599", "homalg_variable_4600", "homalg_variable_4601", "homalg_variable_4602", "homalg_variable_4605", "homalg_variable_4606", "homalg_variable_4607", "homalg_variable_4608", "homalg_variable_4612", "homalg_variable_4614", "homalg_variable_4615", "homalg_variable_4616", "homalg_variable_4618", "homalg_variable_4621", "homalg_variable_4622", "homalg_variable_4625", "homalg_variable_4626", "homalg_variable_4627", "homalg_variable_4628", "homalg_variable_4629", "homalg_variable_4632", "homalg_variable_4633", "homalg_variable_4634", "homalg_variable_4635", "homalg_variable_4636", "homalg_variable_4637", "homalg_variable_4638", "homalg_variable_4639", "homalg_variable_4640", "homalg_variable_4641", "homalg_variable_4642", "homalg_variable_4643", "homalg_variable_4659", "homalg_variable_4660", "homalg_variable_4661", "homalg_variable_4662", "homalg_variable_4665", "homalg_variable_4666", "homalg_variable_4667", "homalg_variable_4668", "homalg_variable_4672", "homalg_variable_4674", "homalg_variable_4675", "homalg_variable_4676", "homalg_variable_4677", "homalg_variable_4678", "homalg_variable_4679", "homalg_variable_4681", "homalg_variable_4684", "homalg_variable_4685", "homalg_variable_4686", "homalg_variable_4687", "homalg_variable_4688", "homalg_variable_4689", "homalg_variable_4690", "homalg_variable_4691", "homalg_variable_4692", "homalg_variable_4693", "homalg_variable_4694", "homalg_variable_4695", "homalg_variable_4696", "homalg_variable_4697", "homalg_variable_4698", "homalg_variable_4699", "homalg_variable_4700", "homalg_variable_4701", "homalg_variable_4702", "homalg_variable_4703", "homalg_variable_4704", "homalg_variable_4705", "homalg_variable_4706", "homalg_variable_4718", "homalg_variable_4719", "homalg_variable_4720", "homalg_variable_4721", "homalg_variable_4722", "homalg_variable_4724", "homalg_variable_4725", "homalg_variable_4726", "homalg_variable_4730", "homalg_variable_4732", "homalg_variable_4733", "homalg_variable_4734", "homalg_variable_4735", "homalg_variable_4736", "homalg_variable_4738", "homalg_variable_4741", "homalg_variable_4742", "homalg_variable_4743", "homalg_variable_4744", "homalg_variable_4745", "homalg_variable_4746", "homalg_variable_4747", "homalg_variable_4748", "homalg_variable_4749", "homalg_variable_4750", "homalg_variable_4751", "homalg_variable_4752", "homalg_variable_4753", "homalg_variable_4754", "homalg_variable_4755", "homalg_variable_4756", "homalg_variable_4757", "homalg_variable_4758", "homalg_variable_4759", "homalg_variable_4760", "homalg_variable_4761", "homalg_variable_4763", "homalg_variable_4764", "homalg_variable_4765", "homalg_variable_4766", "homalg_variable_4767", "homalg_variable_4768", "homalg_variable_4769", "homalg_variable_4770", "homalg_variable_4771", "homalg_variable_4772", "homalg_variable_4773", "homalg_variable_4774", "homalg_variable_4775", "homalg_variable_4776", "homalg_variable_4777", "homalg_variable_4778", "homalg_variable_4779", "homalg_variable_4780", "homalg_variable_4781", "homalg_variable_4782", "homalg_variable_4783", "homalg_variable_4784", "homalg_variable_4787", "homalg_variable_4789", "homalg_variable_4793", "homalg_variable_4794", "homalg_variable_4795", "homalg_variable_4796", "homalg_variable_4797", "homalg_variable_4798", "homalg_variable_4800", "homalg_variable_4803", "homalg_variable_4804", "homalg_variable_4805", "homalg_variable_4806", "homalg_variable_4807", "homalg_variable_4808", "homalg_variable_4812", "homalg_variable_4813", "homalg_variable_4814", "homalg_variable_4815", "homalg_variable_4817", "homalg_variable_4819", "homalg_variable_4820", "homalg_variable_4821", "homalg_variable_4822", "homalg_variable_4823", "homalg_variable_4825", "homalg_variable_4828", "homalg_variable_4829", "homalg_variable_4832", "homalg_variable_4833", "homalg_variable_4834", "homalg_variable_4835", "homalg_variable_4836", "homalg_variable_4839", "homalg_variable_4840", "homalg_variable_4841", "homalg_variable_4842", "homalg_variable_4843", "homalg_variable_4844", "homalg_variable_4845", "homalg_variable_4846", "homalg_variable_4847", "homalg_variable_4848", "homalg_variable_4851", "homalg_variable_4854", "homalg_variable_4855", "homalg_variable_4856", "homalg_variable_4857", "homalg_variable_4858", "homalg_variable_4859", "homalg_variable_4860", "homalg_variable_4861", "homalg_variable_4862", "homalg_variable_4863", "homalg_variable_4864", "homalg_variable_4865", "homalg_variable_4866", "homalg_variable_4867", "homalg_variable_4868", "homalg_variable_4869", "homalg_variable_4870", "homalg_variable_4871", "homalg_variable_4872", "homalg_variable_4873", "homalg_variable_4874", "homalg_variable_4875", "homalg_variable_4876", "homalg_variable_4877", "homalg_variable_4880", "homalg_variable_4882", "homalg_variable_4886", "homalg_variable_4887", "homalg_variable_4888", "homalg_variable_4889", "homalg_variable_4890", "homalg_variable_4891", "homalg_variable_4893", "homalg_variable_4896", "homalg_variable_4897", "homalg_variable_4898", "homalg_variable_4899", "homalg_variable_4900", "homalg_variable_4901", "homalg_variable_4902", "homalg_variable_4906", "homalg_variable_4907", "homalg_variable_4908", "homalg_variable_4909", "homalg_variable_4911", "homalg_variable_4913", "homalg_variable_4914", "homalg_variable_4915", "homalg_variable_4916", "homalg_variable_4917", "homalg_variable_4919", "homalg_variable_4923", "homalg_variable_4926", "homalg_variable_4927", "homalg_variable_4928", "homalg_variable_4929", "homalg_variable_4930", "homalg_variable_4933", "homalg_variable_4934", "homalg_variable_4935", "homalg_variable_4936", "homalg_variable_4937", "homalg_variable_4938", "homalg_variable_4939", "homalg_variable_4940", "homalg_variable_4941", "homalg_variable_4942", "homalg_variable_4945", "homalg_variable_4948", "homalg_variable_4949", "homalg_variable_4950", "homalg_variable_4951", "homalg_variable_4952", "homalg_variable_4953", "homalg_variable_4954", "homalg_variable_4956", "homalg_variable_4957", "homalg_variable_4958", "homalg_variable_4959", "homalg_variable_4960", "homalg_variable_4961", "homalg_variable_4962", "homalg_variable_4963", "homalg_variable_4964", "homalg_variable_4965", "homalg_variable_4967", "homalg_variable_4968", "homalg_variable_4969", "homalg_variable_4970", "homalg_variable_4971", "homalg_variable_4972", "homalg_variable_4973", "homalg_variable_4977", "homalg_variable_4978", "homalg_variable_4979", "homalg_variable_4980" ] do UnbindGlobal( _del );; od;;
gap> homalg_variable_5002 := SI_matrix(homalg_variable_5,16,1,"0");;
gap> homalg_variable_5003 := SIH_Submatrix(homalg_variable_4985,[ 1, 2, 3, 4, 5 ],[1..27]);;
gap> homalg_variable_5004 := homalg_variable_4995 * (homalg_variable_8);;
gap> homalg_variable_5005 := homalg_variable_5003 * homalg_variable_5004;;
gap> homalg_variable_5006 := homalg_variable_3983 * homalg_variable_5005;;
gap> homalg_variable_5007 := SIH_UnionOfRows(homalg_variable_5002,homalg_variable_5006);;
gap> homalg_variable_5008 := homalg_variable_5007 - homalg_variable_4597;;
gap> homalg_variable_5001 := SIH_DecideZeroColumns(homalg_variable_5008,homalg_variable_4503);;
gap> homalg_variable_5009 := SI_matrix(homalg_variable_5,23,1,"0");;
gap> homalg_variable_5001 = homalg_variable_5009;
true
gap> homalg_variable_5011 := homalg_variable_4020 * homalg_variable_10;;
gap> homalg_variable_5010 := SIH_BasisOfColumnModule(homalg_variable_5011);;
gap> SI_ncols(homalg_variable_5010);
6
gap> homalg_variable_5012 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5010 = homalg_variable_5012;
false
gap> homalg_variable_5010 = homalg_variable_5011;
false
gap> homalg_variable_5013 := SIH_DecideZeroColumns(homalg_variable_4020,homalg_variable_5010);;
gap> homalg_variable_5014 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5013 = homalg_variable_5014;
false
gap> homalg_variable_5015 := SIH_UnionOfColumns(homalg_variable_5013,homalg_variable_5010);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5015);; homalg_variable_5016 := homalg_variable_l[1];; homalg_variable_5017 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5016);
5
gap> homalg_variable_5018 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5016 = homalg_variable_5018;
false
gap> SI_nrows(homalg_variable_5017);
11
gap> homalg_variable_5019 := SIH_Submatrix(homalg_variable_5017,[ 1, 2, 3, 4, 5 ],[1..5]);;
gap> homalg_variable_5020 := homalg_variable_5013 * homalg_variable_5019;;
gap> homalg_variable_5021 := SIH_Submatrix(homalg_variable_5017,[ 6, 7, 8, 9, 10, 11 ],[1..5]);;
gap> homalg_variable_5022 := homalg_variable_5010 * homalg_variable_5021;;
gap> homalg_variable_5023 := homalg_variable_5020 + homalg_variable_5022;;
gap> homalg_variable_5016 = homalg_variable_5023;
true
gap> homalg_variable_5024 := SIH_DecideZeroColumns(homalg_variable_42,homalg_variable_5010);;
gap> homalg_variable_5025 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5024 = homalg_variable_5025;
false
gap> homalg_variable_5016 = homalg_variable_42;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5024,homalg_variable_5016);; homalg_variable_5026 := homalg_variable_l[1];; homalg_variable_5027 := homalg_variable_l[2];;
gap> homalg_variable_5028 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5026 = homalg_variable_5028;
true
gap> homalg_variable_5029 := homalg_variable_5016 * homalg_variable_5027;;
gap> homalg_variable_5030 := homalg_variable_5024 + homalg_variable_5029;;
gap> homalg_variable_5026 = homalg_variable_5030;
true
gap> homalg_variable_5031 := SIH_DecideZeroColumns(homalg_variable_5024,homalg_variable_5016);;
gap> homalg_variable_5032 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5031 = homalg_variable_5032;
true
gap> homalg_variable_5034 := SIH_Submatrix(homalg_variable_5017,[ 1, 2, 3, 4, 5 ],[1..5]);;
gap> homalg_variable_5035 := homalg_variable_5027 * (homalg_variable_8);;
gap> homalg_variable_5036 := homalg_variable_5034 * homalg_variable_5035;;
gap> homalg_variable_5037 := homalg_variable_4020 * homalg_variable_5036;;
gap> homalg_variable_5038 := homalg_variable_5037 - homalg_variable_42;;
gap> homalg_variable_5033 := SIH_DecideZeroColumns(homalg_variable_5038,homalg_variable_5010);;
gap> homalg_variable_5039 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5033 = homalg_variable_5039;
true
gap> homalg_variable_5041 := SIH_UnionOfColumns(homalg_variable_4397,homalg_variable_5011);;
gap> homalg_variable_5040 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4020,homalg_variable_5041);;
gap> SI_ncols(homalg_variable_5040);
6
gap> homalg_variable_5042 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5040 = homalg_variable_5042;
false
gap> homalg_variable_5043 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5040);;
gap> SI_ncols(homalg_variable_5043);
4
gap> homalg_variable_5044 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_5043 = homalg_variable_5044;
false
gap> homalg_variable_5045 := SI_\[(homalg_variable_5043,6,1);;
gap> SI_deg( homalg_variable_5045 );
-1
gap> homalg_variable_5046 := SI_\[(homalg_variable_5043,5,1);;
gap> SI_deg( homalg_variable_5046 );
-1
gap> homalg_variable_5047 := SI_\[(homalg_variable_5043,4,1);;
gap> SI_deg( homalg_variable_5047 );
1
gap> homalg_variable_5048 := SI_\[(homalg_variable_5043,3,1);;
gap> SI_deg( homalg_variable_5048 );
1
gap> homalg_variable_5049 := SI_\[(homalg_variable_5043,2,1);;
gap> SI_deg( homalg_variable_5049 );
-1
gap> homalg_variable_5050 := SI_\[(homalg_variable_5043,1,1);;
gap> SI_deg( homalg_variable_5050 );
-1
gap> homalg_variable_5051 := SI_\[(homalg_variable_5043,6,2);;
gap> SI_deg( homalg_variable_5051 );
1
gap> homalg_variable_5052 := SI_\[(homalg_variable_5043,5,2);;
gap> SI_deg( homalg_variable_5052 );
1
gap> homalg_variable_5053 := SI_\[(homalg_variable_5043,4,2);;
gap> SI_deg( homalg_variable_5053 );
-1
gap> homalg_variable_5054 := SI_\[(homalg_variable_5043,3,2);;
gap> SI_deg( homalg_variable_5054 );
-1
gap> homalg_variable_5055 := SI_\[(homalg_variable_5043,2,2);;
gap> SI_deg( homalg_variable_5055 );
-1
gap> homalg_variable_5056 := SI_\[(homalg_variable_5043,1,2);;
gap> SI_deg( homalg_variable_5056 );
-1
gap> homalg_variable_5057 := SI_\[(homalg_variable_5043,6,3);;
gap> SI_deg( homalg_variable_5057 );
-1
gap> homalg_variable_5058 := SI_\[(homalg_variable_5043,5,3);;
gap> SI_deg( homalg_variable_5058 );
1
gap> homalg_variable_5059 := SI_\[(homalg_variable_5043,4,3);;
gap> SI_deg( homalg_variable_5059 );
-1
gap> homalg_variable_5060 := SI_\[(homalg_variable_5043,3,3);;
gap> SI_deg( homalg_variable_5060 );
1
gap> homalg_variable_5061 := SI_\[(homalg_variable_5043,2,3);;
gap> SI_deg( homalg_variable_5061 );
-1
gap> homalg_variable_5062 := SI_\[(homalg_variable_5043,1,3);;
gap> SI_deg( homalg_variable_5062 );
3
gap> homalg_variable_5063 := SI_\[(homalg_variable_5043,6,4);;
gap> SI_deg( homalg_variable_5063 );
1
gap> homalg_variable_5064 := SI_\[(homalg_variable_5043,5,4);;
gap> SI_deg( homalg_variable_5064 );
-1
gap> homalg_variable_5065 := SI_\[(homalg_variable_5043,4,4);;
gap> SI_deg( homalg_variable_5065 );
-1
gap> homalg_variable_5066 := SI_\[(homalg_variable_5043,3,4);;
gap> SI_deg( homalg_variable_5066 );
1
gap> homalg_variable_5067 := SI_\[(homalg_variable_5043,2,4);;
gap> SI_deg( homalg_variable_5067 );
-1
gap> homalg_variable_5068 := SI_\[(homalg_variable_5043,1,4);;
gap> SI_deg( homalg_variable_5068 );
3
gap> homalg_variable_5069 := SIH_BasisOfColumnModule(homalg_variable_5040);;
gap> SI_ncols(homalg_variable_5069);
6
gap> homalg_variable_5070 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5069 = homalg_variable_5070;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5040);; homalg_variable_5071 := homalg_variable_l[1];; homalg_variable_5072 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5071);
6
gap> homalg_variable_5073 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5071 = homalg_variable_5073;
false
gap> SI_nrows(homalg_variable_5072);
6
gap> homalg_variable_5074 := homalg_variable_5040 * homalg_variable_5072;;
gap> homalg_variable_5071 = homalg_variable_5074;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5069,homalg_variable_5071);; homalg_variable_5075 := homalg_variable_l[1];; homalg_variable_5076 := homalg_variable_l[2];;
gap> homalg_variable_5077 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5075 = homalg_variable_5077;
true
gap> homalg_variable_5078 := homalg_variable_5071 * homalg_variable_5076;;
gap> homalg_variable_5079 := homalg_variable_5069 + homalg_variable_5078;;
gap> homalg_variable_5075 = homalg_variable_5079;
true
gap> homalg_variable_5080 := SIH_DecideZeroColumns(homalg_variable_5069,homalg_variable_5071);;
gap> homalg_variable_5081 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5080 = homalg_variable_5081;
true
gap> homalg_variable_5082 := homalg_variable_5076 * (homalg_variable_8);;
gap> homalg_variable_5083 := homalg_variable_5072 * homalg_variable_5082;;
gap> homalg_variable_5084 := homalg_variable_5040 * homalg_variable_5083;;
gap> homalg_variable_5084 = homalg_variable_5069;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5040,homalg_variable_5069);; homalg_variable_5085 := homalg_variable_l[1];; homalg_variable_5086 := homalg_variable_l[2];;
gap> homalg_variable_5087 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5085 = homalg_variable_5087;
true
gap> homalg_variable_5088 := homalg_variable_5069 * homalg_variable_5086;;
gap> homalg_variable_5089 := homalg_variable_5040 + homalg_variable_5088;;
gap> homalg_variable_5085 = homalg_variable_5089;
true
gap> homalg_variable_5090 := SIH_DecideZeroColumns(homalg_variable_5040,homalg_variable_5069);;
gap> homalg_variable_5091 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5090 = homalg_variable_5091;
true
gap> homalg_variable_5092 := homalg_variable_5086 * (homalg_variable_8);;
gap> homalg_variable_5093 := homalg_variable_5069 * homalg_variable_5092;;
gap> homalg_variable_5093 = homalg_variable_5040;
true
gap> homalg_variable_5094 := SIH_DecideZeroColumns(homalg_variable_5040,homalg_variable_10);;
gap> homalg_variable_5095 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5094 = homalg_variable_5095;
true
gap> homalg_variable_5097 := homalg_variable_5036 * homalg_variable_4431;;
gap> homalg_variable_5096 := SIH_DecideZeroColumns(homalg_variable_5097,homalg_variable_10);;
gap> homalg_variable_5098 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5096 = homalg_variable_5098;
true
gap> homalg_variable_5099 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_5036,homalg_variable_10);;
gap> SI_ncols(homalg_variable_5099);
6
gap> homalg_variable_5100 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5099 = homalg_variable_5100;
false
gap> homalg_variable_5101 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5099);;
gap> SI_ncols(homalg_variable_5101);
4
gap> homalg_variable_5102 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_5101 = homalg_variable_5102;
false
gap> homalg_variable_5103 := SI_\[(homalg_variable_5101,6,1);;
gap> SI_deg( homalg_variable_5103 );
-1
gap> homalg_variable_5104 := SI_\[(homalg_variable_5101,5,1);;
gap> SI_deg( homalg_variable_5104 );
-1
gap> homalg_variable_5105 := SI_\[(homalg_variable_5101,4,1);;
gap> SI_deg( homalg_variable_5105 );
1
gap> homalg_variable_5106 := SI_\[(homalg_variable_5101,3,1);;
gap> SI_deg( homalg_variable_5106 );
1
gap> homalg_variable_5107 := SI_\[(homalg_variable_5101,2,1);;
gap> SI_deg( homalg_variable_5107 );
-1
gap> homalg_variable_5108 := SI_\[(homalg_variable_5101,1,1);;
gap> SI_deg( homalg_variable_5108 );
-1
gap> homalg_variable_5109 := SI_\[(homalg_variable_5101,6,2);;
gap> SI_deg( homalg_variable_5109 );
1
gap> homalg_variable_5110 := SI_\[(homalg_variable_5101,5,2);;
gap> SI_deg( homalg_variable_5110 );
1
gap> homalg_variable_5111 := SI_\[(homalg_variable_5101,4,2);;
gap> SI_deg( homalg_variable_5111 );
-1
gap> homalg_variable_5112 := SI_\[(homalg_variable_5101,3,2);;
gap> SI_deg( homalg_variable_5112 );
-1
gap> homalg_variable_5113 := SI_\[(homalg_variable_5101,2,2);;
gap> SI_deg( homalg_variable_5113 );
-1
gap> homalg_variable_5114 := SI_\[(homalg_variable_5101,1,2);;
gap> SI_deg( homalg_variable_5114 );
-1
gap> homalg_variable_5115 := SI_\[(homalg_variable_5101,6,3);;
gap> SI_deg( homalg_variable_5115 );
-1
gap> homalg_variable_5116 := SI_\[(homalg_variable_5101,5,3);;
gap> SI_deg( homalg_variable_5116 );
1
gap> homalg_variable_5117 := SI_\[(homalg_variable_5101,4,3);;
gap> SI_deg( homalg_variable_5117 );
-1
gap> homalg_variable_5118 := SI_\[(homalg_variable_5101,3,3);;
gap> SI_deg( homalg_variable_5118 );
1
gap> homalg_variable_5119 := SI_\[(homalg_variable_5101,2,3);;
gap> SI_deg( homalg_variable_5119 );
-1
gap> homalg_variable_5120 := SI_\[(homalg_variable_5101,1,3);;
gap> SI_deg( homalg_variable_5120 );
3
gap> homalg_variable_5121 := SI_\[(homalg_variable_5101,6,4);;
gap> SI_deg( homalg_variable_5121 );
1
gap> homalg_variable_5122 := SI_\[(homalg_variable_5101,5,4);;
gap> SI_deg( homalg_variable_5122 );
-1
gap> homalg_variable_5123 := SI_\[(homalg_variable_5101,4,4);;
gap> SI_deg( homalg_variable_5123 );
-1
gap> homalg_variable_5124 := SI_\[(homalg_variable_5101,3,4);;
gap> SI_deg( homalg_variable_5124 );
1
gap> homalg_variable_5125 := SI_\[(homalg_variable_5101,2,4);;
gap> SI_deg( homalg_variable_5125 );
-1
gap> homalg_variable_5126 := SI_\[(homalg_variable_5101,1,4);;
gap> SI_deg( homalg_variable_5126 );
3
gap> homalg_variable_5127 := SIH_BasisOfColumnModule(homalg_variable_5099);;
gap> SI_ncols(homalg_variable_5127);
6
gap> homalg_variable_5128 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5127 = homalg_variable_5128;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5099);; homalg_variable_5129 := homalg_variable_l[1];; homalg_variable_5130 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5129);
6
gap> homalg_variable_5131 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5129 = homalg_variable_5131;
false
gap> SI_nrows(homalg_variable_5130);
6
gap> homalg_variable_5132 := homalg_variable_5099 * homalg_variable_5130;;
gap> homalg_variable_5129 = homalg_variable_5132;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5127,homalg_variable_5129);; homalg_variable_5133 := homalg_variable_l[1];; homalg_variable_5134 := homalg_variable_l[2];;
gap> homalg_variable_5135 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5133 = homalg_variable_5135;
true
gap> homalg_variable_5136 := homalg_variable_5129 * homalg_variable_5134;;
gap> homalg_variable_5137 := homalg_variable_5127 + homalg_variable_5136;;
gap> homalg_variable_5133 = homalg_variable_5137;
true
gap> homalg_variable_5138 := SIH_DecideZeroColumns(homalg_variable_5127,homalg_variable_5129);;
gap> homalg_variable_5139 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5138 = homalg_variable_5139;
true
gap> homalg_variable_5140 := homalg_variable_5134 * (homalg_variable_8);;
gap> homalg_variable_5141 := homalg_variable_5130 * homalg_variable_5140;;
gap> homalg_variable_5142 := homalg_variable_5099 * homalg_variable_5141;;
gap> homalg_variable_5142 = homalg_variable_5127;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5099,homalg_variable_5127);; homalg_variable_5143 := homalg_variable_l[1];; homalg_variable_5144 := homalg_variable_l[2];;
gap> homalg_variable_5145 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5143 = homalg_variable_5145;
true
gap> homalg_variable_5146 := homalg_variable_5127 * homalg_variable_5144;;
gap> homalg_variable_5147 := homalg_variable_5099 + homalg_variable_5146;;
gap> homalg_variable_5143 = homalg_variable_5147;
true
gap> homalg_variable_5148 := SIH_DecideZeroColumns(homalg_variable_5099,homalg_variable_5127);;
gap> homalg_variable_5149 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5148 = homalg_variable_5149;
true
gap> homalg_variable_5150 := homalg_variable_5144 * (homalg_variable_8);;
gap> homalg_variable_5151 := homalg_variable_5127 * homalg_variable_5150;;
gap> homalg_variable_5151 = homalg_variable_5099;
true
gap> homalg_variable_5152 := SIH_DecideZeroColumns(homalg_variable_5099,homalg_variable_4431);;
gap> homalg_variable_5153 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5152 = homalg_variable_5153;
true
gap> homalg_variable_5155 := homalg_variable_4595 * homalg_variable_3338;;
gap> homalg_variable_5156 := SI_matrix(homalg_variable_5,7,3,"0");;
gap> homalg_variable_5157 := SIH_UnionOfRows(homalg_variable_5155,homalg_variable_5156);;
gap> homalg_variable_5158 := SIH_UnionOfColumns(homalg_variable_5157,homalg_variable_4518);;
gap> homalg_variable_5154 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4529,homalg_variable_5158);;
gap> SI_ncols(homalg_variable_5154);
6
gap> homalg_variable_5159 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5154 = homalg_variable_5159;
false
gap> homalg_variable_5160 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5154);;
gap> SI_ncols(homalg_variable_5160);
4
gap> homalg_variable_5161 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_5160 = homalg_variable_5161;
false
gap> homalg_variable_5162 := SI_\[(homalg_variable_5160,6,1);;
gap> SI_deg( homalg_variable_5162 );
-1
gap> homalg_variable_5163 := SI_\[(homalg_variable_5160,5,1);;
gap> SI_deg( homalg_variable_5163 );
-1
gap> homalg_variable_5164 := SI_\[(homalg_variable_5160,4,1);;
gap> SI_deg( homalg_variable_5164 );
1
gap> homalg_variable_5165 := SI_\[(homalg_variable_5160,3,1);;
gap> SI_deg( homalg_variable_5165 );
1
gap> homalg_variable_5166 := SI_\[(homalg_variable_5160,2,1);;
gap> SI_deg( homalg_variable_5166 );
-1
gap> homalg_variable_5167 := SI_\[(homalg_variable_5160,1,1);;
gap> SI_deg( homalg_variable_5167 );
-1
gap> homalg_variable_5168 := SI_\[(homalg_variable_5160,6,2);;
gap> SI_deg( homalg_variable_5168 );
1
gap> homalg_variable_5169 := SI_\[(homalg_variable_5160,5,2);;
gap> SI_deg( homalg_variable_5169 );
1
gap> homalg_variable_5170 := SI_\[(homalg_variable_5160,4,2);;
gap> SI_deg( homalg_variable_5170 );
-1
gap> homalg_variable_5171 := SI_\[(homalg_variable_5160,3,2);;
gap> SI_deg( homalg_variable_5171 );
-1
gap> homalg_variable_5172 := SI_\[(homalg_variable_5160,2,2);;
gap> SI_deg( homalg_variable_5172 );
-1
gap> homalg_variable_5173 := SI_\[(homalg_variable_5160,1,2);;
gap> SI_deg( homalg_variable_5173 );
-1
gap> homalg_variable_5174 := SI_\[(homalg_variable_5160,6,3);;
gap> SI_deg( homalg_variable_5174 );
-1
gap> homalg_variable_5175 := SI_\[(homalg_variable_5160,5,3);;
gap> SI_deg( homalg_variable_5175 );
1
gap> homalg_variable_5176 := SI_\[(homalg_variable_5160,4,3);;
gap> SI_deg( homalg_variable_5176 );
-1
gap> homalg_variable_5177 := SI_\[(homalg_variable_5160,3,3);;
gap> SI_deg( homalg_variable_5177 );
1
gap> homalg_variable_5178 := SI_\[(homalg_variable_5160,2,3);;
gap> SI_deg( homalg_variable_5178 );
-1
gap> homalg_variable_5179 := SI_\[(homalg_variable_5160,1,3);;
gap> SI_deg( homalg_variable_5179 );
3
gap> homalg_variable_5180 := SI_\[(homalg_variable_5160,6,4);;
gap> SI_deg( homalg_variable_5180 );
1
gap> homalg_variable_5181 := SI_\[(homalg_variable_5160,5,4);;
gap> SI_deg( homalg_variable_5181 );
-1
gap> homalg_variable_5182 := SI_\[(homalg_variable_5160,4,4);;
gap> SI_deg( homalg_variable_5182 );
-1
gap> homalg_variable_5183 := SI_\[(homalg_variable_5160,3,4);;
gap> SI_deg( homalg_variable_5183 );
1
gap> homalg_variable_5184 := SI_\[(homalg_variable_5160,2,4);;
gap> SI_deg( homalg_variable_5184 );
-1
gap> homalg_variable_5185 := SI_\[(homalg_variable_5160,1,4);;
gap> SI_deg( homalg_variable_5185 );
3
gap> homalg_variable_5186 := SIH_BasisOfColumnModule(homalg_variable_5154);;
gap> SI_ncols(homalg_variable_5186);
6
gap> homalg_variable_5187 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5186 = homalg_variable_5187;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5154);; homalg_variable_5188 := homalg_variable_l[1];; homalg_variable_5189 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5188);
6
gap> homalg_variable_5190 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5188 = homalg_variable_5190;
false
gap> SI_nrows(homalg_variable_5189);
6
gap> homalg_variable_5191 := homalg_variable_5154 * homalg_variable_5189;;
gap> homalg_variable_5188 = homalg_variable_5191;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5186,homalg_variable_5188);; homalg_variable_5192 := homalg_variable_l[1];; homalg_variable_5193 := homalg_variable_l[2];;
gap> homalg_variable_5194 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5192 = homalg_variable_5194;
true
gap> homalg_variable_5195 := homalg_variable_5188 * homalg_variable_5193;;
gap> homalg_variable_5196 := homalg_variable_5186 + homalg_variable_5195;;
gap> homalg_variable_5192 = homalg_variable_5196;
true
gap> homalg_variable_5197 := SIH_DecideZeroColumns(homalg_variable_5186,homalg_variable_5188);;
gap> homalg_variable_5198 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5197 = homalg_variable_5198;
true
gap> homalg_variable_5199 := homalg_variable_5193 * (homalg_variable_8);;
gap> homalg_variable_5200 := homalg_variable_5189 * homalg_variable_5199;;
gap> homalg_variable_5201 := homalg_variable_5154 * homalg_variable_5200;;
gap> homalg_variable_5201 = homalg_variable_5186;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5154,homalg_variable_5186);; homalg_variable_5202 := homalg_variable_l[1];; homalg_variable_5203 := homalg_variable_l[2];;
gap> homalg_variable_5204 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5202 = homalg_variable_5204;
true
gap> homalg_variable_5205 := homalg_variable_5186 * homalg_variable_5203;;
gap> homalg_variable_5206 := homalg_variable_5154 + homalg_variable_5205;;
gap> homalg_variable_5202 = homalg_variable_5206;
true
gap> homalg_variable_5207 := SIH_DecideZeroColumns(homalg_variable_5154,homalg_variable_5186);;
gap> homalg_variable_5208 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5207 = homalg_variable_5208;
true
gap> homalg_variable_5209 := homalg_variable_5203 * (homalg_variable_8);;
gap> homalg_variable_5210 := homalg_variable_5186 * homalg_variable_5209;;
gap> homalg_variable_5210 = homalg_variable_5154;
true
gap> homalg_variable_5211 := SIH_DecideZeroColumns(homalg_variable_5154,homalg_variable_4431);;
gap> homalg_variable_5212 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5211 = homalg_variable_5212;
true
gap> homalg_variable_5214 := homalg_variable_5005 * homalg_variable_3338;;
gap> homalg_variable_5213 := SIH_DecideZeroColumns(homalg_variable_5214,homalg_variable_4431);;
gap> homalg_variable_5215 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_5213 = homalg_variable_5215;
true
gap> homalg_variable_5216 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_5005,homalg_variable_4431);;
gap> SI_ncols(homalg_variable_5216);
3
gap> homalg_variable_5217 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5216 = homalg_variable_5217;
false
gap> homalg_variable_5218 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5216);;
gap> SI_ncols(homalg_variable_5218);
3
gap> homalg_variable_5219 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_5218 = homalg_variable_5219;
false
gap> homalg_variable_5220 := SI_\[(homalg_variable_5218,3,1);;
gap> SI_deg( homalg_variable_5220 );
-1
gap> homalg_variable_5221 := SI_\[(homalg_variable_5218,2,1);;
gap> SI_deg( homalg_variable_5221 );
1
gap> homalg_variable_5222 := SI_\[(homalg_variable_5218,1,1);;
gap> SI_deg( homalg_variable_5222 );
1
gap> homalg_variable_5223 := SI_\[(homalg_variable_5218,3,2);;
gap> SI_deg( homalg_variable_5223 );
1
gap> homalg_variable_5224 := SI_\[(homalg_variable_5218,2,2);;
gap> SI_deg( homalg_variable_5224 );
1
gap> homalg_variable_5225 := SI_\[(homalg_variable_5218,1,2);;
gap> SI_deg( homalg_variable_5225 );
-1
gap> homalg_variable_5226 := SI_\[(homalg_variable_5218,3,3);;
gap> SI_deg( homalg_variable_5226 );
1
gap> homalg_variable_5227 := SI_\[(homalg_variable_5218,2,3);;
gap> SI_deg( homalg_variable_5227 );
-1
gap> homalg_variable_5228 := SI_\[(homalg_variable_5218,1,3);;
gap> SI_deg( homalg_variable_5228 );
1
gap> homalg_variable_5229 := SIH_BasisOfColumnModule(homalg_variable_5216);;
gap> SI_ncols(homalg_variable_5229);
3
gap> homalg_variable_5230 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5229 = homalg_variable_5230;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5216);; homalg_variable_5231 := homalg_variable_l[1];; homalg_variable_5232 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5231);
3
gap> homalg_variable_5233 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5231 = homalg_variable_5233;
false
gap> SI_nrows(homalg_variable_5232);
3
gap> homalg_variable_5234 := homalg_variable_5216 * homalg_variable_5232;;
gap> homalg_variable_5231 = homalg_variable_5234;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5229,homalg_variable_5231);; homalg_variable_5235 := homalg_variable_l[1];; homalg_variable_5236 := homalg_variable_l[2];;
gap> homalg_variable_5237 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5235 = homalg_variable_5237;
true
gap> homalg_variable_5238 := homalg_variable_5231 * homalg_variable_5236;;
gap> homalg_variable_5239 := homalg_variable_5229 + homalg_variable_5238;;
gap> homalg_variable_5235 = homalg_variable_5239;
true
gap> homalg_variable_5240 := SIH_DecideZeroColumns(homalg_variable_5229,homalg_variable_5231);;
gap> homalg_variable_5241 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5240 = homalg_variable_5241;
true
gap> homalg_variable_5242 := homalg_variable_5236 * (homalg_variable_8);;
gap> homalg_variable_5243 := homalg_variable_5232 * homalg_variable_5242;;
gap> homalg_variable_5244 := homalg_variable_5216 * homalg_variable_5243;;
gap> homalg_variable_5244 = homalg_variable_5229;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5216,homalg_variable_5229);; homalg_variable_5245 := homalg_variable_l[1];; homalg_variable_5246 := homalg_variable_l[2];;
gap> homalg_variable_5247 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5245 = homalg_variable_5247;
true
gap> homalg_variable_5248 := homalg_variable_5229 * homalg_variable_5246;;
gap> homalg_variable_5249 := homalg_variable_5216 + homalg_variable_5248;;
gap> homalg_variable_5245 = homalg_variable_5249;
true
gap> homalg_variable_5250 := SIH_DecideZeroColumns(homalg_variable_5216,homalg_variable_5229);;
gap> homalg_variable_5251 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5250 = homalg_variable_5251;
true
gap> homalg_variable_5252 := homalg_variable_5246 * (homalg_variable_8);;
gap> homalg_variable_5253 := homalg_variable_5229 * homalg_variable_5252;;
gap> homalg_variable_5253 = homalg_variable_5216;
true
gap> homalg_variable_5254 := SIH_DecideZeroColumns(homalg_variable_5216,homalg_variable_3336);;
gap> homalg_variable_5255 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5254 = homalg_variable_5255;
true
gap> homalg_variable_5257 := SIH_UnionOfColumns(homalg_variable_5005,homalg_variable_4431);;
gap> homalg_variable_5256 := SIH_BasisOfColumnModule(homalg_variable_5257);;
gap> SI_ncols(homalg_variable_5256);
5
gap> homalg_variable_5258 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5256 = homalg_variable_5258;
false
gap> homalg_variable_5259 := SIH_DecideZeroColumns(homalg_variable_5005,homalg_variable_5256);;
gap> homalg_variable_5260 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_5259 = homalg_variable_5260;
true
gap> homalg_variable_5262 := homalg_variable_4976 * homalg_variable_3419;;
gap> homalg_variable_5261 := SIH_DecideZeroColumns(homalg_variable_5262,homalg_variable_5256);;
gap> homalg_variable_5263 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_5261 = homalg_variable_5263;
true
gap> homalg_variable_5264 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4976,homalg_variable_5257);;
gap> SI_ncols(homalg_variable_5264);
2
gap> homalg_variable_5265 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5264 = homalg_variable_5265;
false
gap> homalg_variable_5266 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5264);;
gap> SI_ncols(homalg_variable_5266);
1
gap> homalg_variable_5267 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_5266 = homalg_variable_5267;
false
gap> homalg_variable_5268 := SI_\[(homalg_variable_5266,2,1);;
gap> SI_deg( homalg_variable_5268 );
1
gap> homalg_variable_5269 := SI_\[(homalg_variable_5266,1,1);;
gap> SI_deg( homalg_variable_5269 );
1
gap> homalg_variable_5270 := SIH_BasisOfColumnModule(homalg_variable_5264);;
gap> SI_ncols(homalg_variable_5270);
2
gap> homalg_variable_5271 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5270 = homalg_variable_5271;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5264);; homalg_variable_5272 := homalg_variable_l[1];; homalg_variable_5273 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5272);
2
gap> homalg_variable_5274 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5272 = homalg_variable_5274;
false
gap> SI_nrows(homalg_variable_5273);
2
gap> homalg_variable_5275 := homalg_variable_5264 * homalg_variable_5273;;
gap> homalg_variable_5272 = homalg_variable_5275;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5270,homalg_variable_5272);; homalg_variable_5276 := homalg_variable_l[1];; homalg_variable_5277 := homalg_variable_l[2];;
gap> homalg_variable_5278 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5276 = homalg_variable_5278;
true
gap> homalg_variable_5279 := homalg_variable_5272 * homalg_variable_5277;;
gap> homalg_variable_5280 := homalg_variable_5270 + homalg_variable_5279;;
gap> homalg_variable_5276 = homalg_variable_5280;
true
gap> homalg_variable_5281 := SIH_DecideZeroColumns(homalg_variable_5270,homalg_variable_5272);;
gap> homalg_variable_5282 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5281 = homalg_variable_5282;
true
gap> homalg_variable_5283 := homalg_variable_5277 * (homalg_variable_8);;
gap> homalg_variable_5284 := homalg_variable_5273 * homalg_variable_5283;;
gap> homalg_variable_5285 := homalg_variable_5264 * homalg_variable_5284;;
gap> homalg_variable_5285 = homalg_variable_5270;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5264,homalg_variable_5270);; homalg_variable_5286 := homalg_variable_l[1];; homalg_variable_5287 := homalg_variable_l[2];;
gap> homalg_variable_5288 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5286 = homalg_variable_5288;
true
gap> homalg_variable_5289 := homalg_variable_5270 * homalg_variable_5287;;
gap> homalg_variable_5290 := homalg_variable_5264 + homalg_variable_5289;;
gap> homalg_variable_5286 = homalg_variable_5290;
true
gap> homalg_variable_5291 := SIH_DecideZeroColumns(homalg_variable_5264,homalg_variable_5270);;
gap> homalg_variable_5292 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5291 = homalg_variable_5292;
true
gap> homalg_variable_5293 := homalg_variable_5287 * (homalg_variable_8);;
gap> homalg_variable_5294 := homalg_variable_5270 * homalg_variable_5293;;
gap> homalg_variable_5294 = homalg_variable_5264;
true
gap> homalg_variable_5295 := SIH_DecideZeroColumns(homalg_variable_5264,homalg_variable_3419);;
gap> homalg_variable_5296 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5295 = homalg_variable_5296;
true
gap> homalg_variable_5298 := SIH_UnionOfColumns(homalg_variable_4598,homalg_variable_4518);;
gap> homalg_variable_5297 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4529,homalg_variable_5298);;
gap> SI_ncols(homalg_variable_5297);
5
gap> homalg_variable_5299 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5297 = homalg_variable_5299;
false
gap> homalg_variable_5300 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5297);;
gap> SI_ncols(homalg_variable_5300);
2
gap> homalg_variable_5301 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_5300 = homalg_variable_5301;
false
gap> homalg_variable_5302 := SI_\[(homalg_variable_5300,5,1);;
gap> SI_deg( homalg_variable_5302 );
-1
gap> homalg_variable_5303 := SI_\[(homalg_variable_5300,4,1);;
gap> SI_deg( homalg_variable_5303 );
1
gap> homalg_variable_5304 := SI_\[(homalg_variable_5300,3,1);;
gap> SI_deg( homalg_variable_5304 );
1
gap> homalg_variable_5305 := SI_\[(homalg_variable_5300,2,1);;
gap> SI_deg( homalg_variable_5305 );
-1
gap> homalg_variable_5306 := SI_\[(homalg_variable_5300,1,1);;
gap> SI_deg( homalg_variable_5306 );
-1
gap> homalg_variable_5307 := SI_\[(homalg_variable_5300,5,2);;
gap> SI_deg( homalg_variable_5307 );
1
gap> homalg_variable_5308 := SI_\[(homalg_variable_5300,4,2);;
gap> SI_deg( homalg_variable_5308 );
-1
gap> homalg_variable_5309 := SI_\[(homalg_variable_5300,3,2);;
gap> SI_deg( homalg_variable_5309 );
0
gap> homalg_variable_5310 := SI_\[(homalg_variable_5300,1,2);;
gap> IsZero(homalg_variable_5310);
false
gap> homalg_variable_5311 := SI_\[(homalg_variable_5300,2,2);;
gap> IsZero(homalg_variable_5311);
true
gap> homalg_variable_5312 := SI_\[(homalg_variable_5300,3,2);;
gap> IsZero(homalg_variable_5312);
false
gap> homalg_variable_5313 := SI_\[(homalg_variable_5300,4,2);;
gap> IsZero(homalg_variable_5313);
true
gap> homalg_variable_5314 := SI_\[(homalg_variable_5300,5,2);;
gap> IsZero(homalg_variable_5314);
false
gap> homalg_variable_5316 := SIH_Submatrix(homalg_variable_5297,[1..5],[ 1, 2, 4, 5 ]);;
gap> homalg_variable_5315 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5316);;
gap> SI_ncols(homalg_variable_5315);
1
gap> homalg_variable_5317 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_5315 = homalg_variable_5317;
false
gap> homalg_variable_5318 := SI_\[(homalg_variable_5315,4,1);;
gap> SI_deg( homalg_variable_5318 );
2
gap> homalg_variable_5319 := SI_\[(homalg_variable_5315,3,1);;
gap> SI_deg( homalg_variable_5319 );
1
gap> homalg_variable_5320 := SI_\[(homalg_variable_5315,2,1);;
gap> SI_deg( homalg_variable_5320 );
-1
gap> homalg_variable_5321 := SI_\[(homalg_variable_5315,1,1);;
gap> SI_deg( homalg_variable_5321 );
3
gap> homalg_variable_5322 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5316 = homalg_variable_5322;
false
gap> homalg_variable_5323 := SIH_BasisOfColumnModule(homalg_variable_5297);;
gap> SI_ncols(homalg_variable_5323);
5
gap> homalg_variable_5324 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5323 = homalg_variable_5324;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5316);; homalg_variable_5325 := homalg_variable_l[1];; homalg_variable_5326 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5325);
5
gap> homalg_variable_5327 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5325 = homalg_variable_5327;
false
gap> SI_nrows(homalg_variable_5326);
4
gap> homalg_variable_5328 := homalg_variable_5316 * homalg_variable_5326;;
gap> homalg_variable_5325 = homalg_variable_5328;
true
gap> homalg_variable_5325 = homalg_variable_42;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5323,homalg_variable_5325);; homalg_variable_5329 := homalg_variable_l[1];; homalg_variable_5330 := homalg_variable_l[2];;
gap> homalg_variable_5331 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5329 = homalg_variable_5331;
true
gap> homalg_variable_5332 := homalg_variable_5325 * homalg_variable_5330;;
gap> homalg_variable_5333 := homalg_variable_5323 + homalg_variable_5332;;
gap> homalg_variable_5329 = homalg_variable_5333;
true
gap> homalg_variable_5334 := SIH_DecideZeroColumns(homalg_variable_5323,homalg_variable_5325);;
gap> homalg_variable_5335 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5334 = homalg_variable_5335;
true
gap> homalg_variable_5336 := homalg_variable_5330 * (homalg_variable_8);;
gap> homalg_variable_5337 := homalg_variable_5326 * homalg_variable_5336;;
gap> homalg_variable_5338 := homalg_variable_5316 * homalg_variable_5337;;
gap> homalg_variable_5338 = homalg_variable_5323;
true
gap> homalg_variable_5323 = homalg_variable_42;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5316,homalg_variable_5323);; homalg_variable_5339 := homalg_variable_l[1];; homalg_variable_5340 := homalg_variable_l[2];;
gap> homalg_variable_5341 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5339 = homalg_variable_5341;
true
gap> homalg_variable_5342 := homalg_variable_5323 * homalg_variable_5340;;
gap> homalg_variable_5343 := homalg_variable_5316 + homalg_variable_5342;;
gap> homalg_variable_5339 = homalg_variable_5343;
true
gap> homalg_variable_5344 := SIH_DecideZeroColumns(homalg_variable_5316,homalg_variable_5323);;
gap> homalg_variable_5345 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5344 = homalg_variable_5345;
true
gap> homalg_variable_5346 := homalg_variable_5340 * (homalg_variable_8);;
gap> homalg_variable_5347 := homalg_variable_5323 * homalg_variable_5346;;
gap> homalg_variable_5347 = homalg_variable_5316;
true
gap> homalg_variable_5349 := SIH_UnionOfColumns(homalg_variable_5005,homalg_variable_4976);;
gap> homalg_variable_5350 := SIH_UnionOfColumns(homalg_variable_5349,homalg_variable_4431);;
gap> homalg_variable_5348 := SIH_BasisOfColumnModule(homalg_variable_5350);;
gap> SI_ncols(homalg_variable_5348);
4
gap> homalg_variable_5351 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5348 = homalg_variable_5351;
false
gap> homalg_variable_5352 := SIH_DecideZeroColumns(homalg_variable_5349,homalg_variable_5348);;
gap> homalg_variable_5353 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_5352 = homalg_variable_5353;
true
gap> homalg_variable_5355 := homalg_variable_4905 * homalg_variable_3775;;
gap> homalg_variable_5354 := SIH_DecideZeroColumns(homalg_variable_5355,homalg_variable_5348);;
gap> homalg_variable_5356 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5354 = homalg_variable_5356;
true
gap> homalg_variable_5357 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4905,homalg_variable_5350);;
gap> SI_ncols(homalg_variable_5357);
5
gap> homalg_variable_5358 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_5357 = homalg_variable_5358;
false
gap> homalg_variable_5359 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5357);;
gap> SI_ncols(homalg_variable_5359);
1
gap> homalg_variable_5360 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_5359 = homalg_variable_5360;
false
gap> homalg_variable_5361 := SI_\[(homalg_variable_5359,5,1);;
gap> SI_deg( homalg_variable_5361 );
-1
gap> homalg_variable_5362 := SI_\[(homalg_variable_5359,4,1);;
gap> SI_deg( homalg_variable_5362 );
1
gap> homalg_variable_5363 := SI_\[(homalg_variable_5359,3,1);;
gap> SI_deg( homalg_variable_5363 );
1
gap> homalg_variable_5364 := SI_\[(homalg_variable_5359,2,1);;
gap> SI_deg( homalg_variable_5364 );
1
gap> homalg_variable_5365 := SI_\[(homalg_variable_5359,1,1);;
gap> SI_deg( homalg_variable_5365 );
-1
gap> homalg_variable_5366 := SIH_BasisOfColumnModule(homalg_variable_5357);;
gap> SI_ncols(homalg_variable_5366);
5
gap> homalg_variable_5367 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_5366 = homalg_variable_5367;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5357);; homalg_variable_5368 := homalg_variable_l[1];; homalg_variable_5369 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5368);
5
gap> homalg_variable_5370 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_5368 = homalg_variable_5370;
false
gap> SI_nrows(homalg_variable_5369);
5
gap> homalg_variable_5371 := homalg_variable_5357 * homalg_variable_5369;;
gap> homalg_variable_5368 = homalg_variable_5371;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5366,homalg_variable_5368);; homalg_variable_5372 := homalg_variable_l[1];; homalg_variable_5373 := homalg_variable_l[2];;
gap> homalg_variable_5374 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_5372 = homalg_variable_5374;
true
gap> homalg_variable_5375 := homalg_variable_5368 * homalg_variable_5373;;
gap> homalg_variable_5376 := homalg_variable_5366 + homalg_variable_5375;;
gap> homalg_variable_5372 = homalg_variable_5376;
true
gap> homalg_variable_5377 := SIH_DecideZeroColumns(homalg_variable_5366,homalg_variable_5368);;
gap> homalg_variable_5378 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_5377 = homalg_variable_5378;
true
gap> homalg_variable_5379 := homalg_variable_5373 * (homalg_variable_8);;
gap> homalg_variable_5380 := homalg_variable_5369 * homalg_variable_5379;;
gap> homalg_variable_5381 := homalg_variable_5357 * homalg_variable_5380;;
gap> homalg_variable_5381 = homalg_variable_5366;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5357,homalg_variable_5366);; homalg_variable_5382 := homalg_variable_l[1];; homalg_variable_5383 := homalg_variable_l[2];;
gap> homalg_variable_5384 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_5382 = homalg_variable_5384;
true
gap> homalg_variable_5385 := homalg_variable_5366 * homalg_variable_5383;;
gap> homalg_variable_5386 := homalg_variable_5357 + homalg_variable_5385;;
gap> homalg_variable_5382 = homalg_variable_5386;
true
gap> homalg_variable_5387 := SIH_DecideZeroColumns(homalg_variable_5357,homalg_variable_5366);;
gap> homalg_variable_5388 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_5387 = homalg_variable_5388;
true
gap> homalg_variable_5389 := homalg_variable_5383 * (homalg_variable_8);;
gap> homalg_variable_5390 := homalg_variable_5366 * homalg_variable_5389;;
gap> homalg_variable_5390 = homalg_variable_5357;
true
gap> homalg_variable_5391 := SIH_DecideZeroColumns(homalg_variable_5357,homalg_variable_3775);;
gap> homalg_variable_5392 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_5391 = homalg_variable_5392;
true
gap> homalg_variable_5394 := SIH_UnionOfColumns(homalg_variable_5349,homalg_variable_4905);;
gap> homalg_variable_5395 := SIH_UnionOfColumns(homalg_variable_5394,homalg_variable_4431);;
gap> homalg_variable_5393 := SIH_BasisOfColumnModule(homalg_variable_5395);;
gap> SI_ncols(homalg_variable_5393);
4
gap> homalg_variable_5396 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5393 = homalg_variable_5396;
false
gap> homalg_variable_5397 := SIH_DecideZeroColumns(homalg_variable_5394,homalg_variable_5393);;
gap> homalg_variable_5398 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5397 = homalg_variable_5398;
true
gap> homalg_variable_5400 := homalg_variable_4811 * homalg_variable_3975;;
gap> homalg_variable_5399 := SIH_DecideZeroColumns(homalg_variable_5400,homalg_variable_5393);;
gap> homalg_variable_5401 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5399 = homalg_variable_5401;
true
gap> homalg_variable_5402 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_4811,homalg_variable_5395);;
gap> SI_ncols(homalg_variable_5402);
4
gap> homalg_variable_5403 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5402 = homalg_variable_5403;
false
gap> homalg_variable_5404 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5402);;
gap> SI_ncols(homalg_variable_5404);
1
gap> homalg_variable_5405 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_5404 = homalg_variable_5405;
false
gap> homalg_variable_5406 := SI_\[(homalg_variable_5404,4,1);;
gap> SI_deg( homalg_variable_5406 );
-1
gap> homalg_variable_5407 := SI_\[(homalg_variable_5404,3,1);;
gap> SI_deg( homalg_variable_5407 );
1
gap> homalg_variable_5408 := SI_\[(homalg_variable_5404,2,1);;
gap> SI_deg( homalg_variable_5408 );
1
gap> homalg_variable_5409 := SI_\[(homalg_variable_5404,1,1);;
gap> SI_deg( homalg_variable_5409 );
1
gap> homalg_variable_5410 := SIH_BasisOfColumnModule(homalg_variable_5402);;
gap> SI_ncols(homalg_variable_5410);
4
gap> homalg_variable_5411 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5410 = homalg_variable_5411;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5402);; homalg_variable_5412 := homalg_variable_l[1];; homalg_variable_5413 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5412);
4
gap> homalg_variable_5414 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5412 = homalg_variable_5414;
false
gap> SI_nrows(homalg_variable_5413);
4
gap> homalg_variable_5415 := homalg_variable_5402 * homalg_variable_5413;;
gap> homalg_variable_5412 = homalg_variable_5415;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5410,homalg_variable_5412);; homalg_variable_5416 := homalg_variable_l[1];; homalg_variable_5417 := homalg_variable_l[2];;
gap> homalg_variable_5418 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5416 = homalg_variable_5418;
true
gap> homalg_variable_5419 := homalg_variable_5412 * homalg_variable_5417;;
gap> homalg_variable_5420 := homalg_variable_5410 + homalg_variable_5419;;
gap> homalg_variable_5416 = homalg_variable_5420;
true
gap> homalg_variable_5421 := SIH_DecideZeroColumns(homalg_variable_5410,homalg_variable_5412);;
gap> homalg_variable_5422 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5421 = homalg_variable_5422;
true
gap> homalg_variable_5423 := homalg_variable_5417 * (homalg_variable_8);;
gap> homalg_variable_5424 := homalg_variable_5413 * homalg_variable_5423;;
gap> homalg_variable_5425 := homalg_variable_5402 * homalg_variable_5424;;
gap> homalg_variable_5425 = homalg_variable_5410;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5402,homalg_variable_5410);; homalg_variable_5426 := homalg_variable_l[1];; homalg_variable_5427 := homalg_variable_l[2];;
gap> homalg_variable_5428 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5426 = homalg_variable_5428;
true
gap> homalg_variable_5429 := homalg_variable_5410 * homalg_variable_5427;;
gap> homalg_variable_5430 := homalg_variable_5402 + homalg_variable_5429;;
gap> homalg_variable_5426 = homalg_variable_5430;
true
gap> homalg_variable_5431 := SIH_DecideZeroColumns(homalg_variable_5402,homalg_variable_5410);;
gap> homalg_variable_5432 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5431 = homalg_variable_5432;
true
gap> homalg_variable_5433 := homalg_variable_5427 * (homalg_variable_8);;
gap> homalg_variable_5434 := homalg_variable_5410 * homalg_variable_5433;;
gap> homalg_variable_5434 = homalg_variable_5402;
true
gap> homalg_variable_5435 := SIH_DecideZeroColumns(homalg_variable_5402,homalg_variable_3975);;
gap> homalg_variable_5436 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5435 = homalg_variable_5436;
true
gap> homalg_variable_5438 := SIH_UnionOfColumns(homalg_variable_4811,homalg_variable_5395);;
gap> homalg_variable_5437 := SIH_BasisOfColumnModule(homalg_variable_5438);;
gap> SI_ncols(homalg_variable_5437);
5
gap> homalg_variable_5439 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5437 = homalg_variable_5439;
false
gap> homalg_variable_5440 := SIH_DecideZeroColumns(homalg_variable_42,homalg_variable_5437);;
gap> homalg_variable_5441 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5440 = homalg_variable_5441;
true
gap> homalg_variable_5443 := SIH_UnionOfColumns(homalg_variable_10,homalg_variable_5094);;
gap> homalg_variable_5442 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5443);;
gap> SI_ncols(homalg_variable_5442);
10
gap> homalg_variable_5444 := SI_matrix(homalg_variable_5,12,10,"0");;
gap> homalg_variable_5442 = homalg_variable_5444;
false
gap> homalg_variable_5445 := SI_\[(homalg_variable_5442,12,1);;
gap> SI_deg( homalg_variable_5445 );
0
gap> homalg_variable_5446 := SI_\[(homalg_variable_5442,1,1);;
gap> IsZero(homalg_variable_5446);
true
gap> homalg_variable_5447 := SI_\[(homalg_variable_5442,2,1);;
gap> IsZero(homalg_variable_5447);
true
gap> homalg_variable_5448 := SI_\[(homalg_variable_5442,3,1);;
gap> IsZero(homalg_variable_5448);
true
gap> homalg_variable_5449 := SI_\[(homalg_variable_5442,4,1);;
gap> IsZero(homalg_variable_5449);
true
gap> homalg_variable_5450 := SI_\[(homalg_variable_5442,5,1);;
gap> IsZero(homalg_variable_5450);
true
gap> homalg_variable_5451 := SI_\[(homalg_variable_5442,6,1);;
gap> IsZero(homalg_variable_5451);
true
gap> homalg_variable_5452 := SI_\[(homalg_variable_5442,7,1);;
gap> IsZero(homalg_variable_5452);
true
gap> homalg_variable_5453 := SI_\[(homalg_variable_5442,8,1);;
gap> IsZero(homalg_variable_5453);
true
gap> homalg_variable_5454 := SI_\[(homalg_variable_5442,9,1);;
gap> IsZero(homalg_variable_5454);
true
gap> homalg_variable_5455 := SI_\[(homalg_variable_5442,10,1);;
gap> IsZero(homalg_variable_5455);
true
gap> homalg_variable_5456 := SI_\[(homalg_variable_5442,11,1);;
gap> IsZero(homalg_variable_5456);
true
gap> homalg_variable_5457 := SI_\[(homalg_variable_5442,12,1);;
gap> IsZero(homalg_variable_5457);
false
gap> homalg_variable_5458 := SI_\[(homalg_variable_5442,11,2);;
gap> SI_deg( homalg_variable_5458 );
0
gap> homalg_variable_5459 := SI_\[(homalg_variable_5442,1,2);;
gap> IsZero(homalg_variable_5459);
true
gap> homalg_variable_5460 := SI_\[(homalg_variable_5442,2,2);;
gap> IsZero(homalg_variable_5460);
true
gap> homalg_variable_5461 := SI_\[(homalg_variable_5442,3,2);;
gap> IsZero(homalg_variable_5461);
true
gap> homalg_variable_5462 := SI_\[(homalg_variable_5442,4,2);;
gap> IsZero(homalg_variable_5462);
true
gap> homalg_variable_5463 := SI_\[(homalg_variable_5442,5,2);;
gap> IsZero(homalg_variable_5463);
true
gap> homalg_variable_5464 := SI_\[(homalg_variable_5442,6,2);;
gap> IsZero(homalg_variable_5464);
true
gap> homalg_variable_5465 := SI_\[(homalg_variable_5442,7,2);;
gap> IsZero(homalg_variable_5465);
true
gap> homalg_variable_5466 := SI_\[(homalg_variable_5442,8,2);;
gap> IsZero(homalg_variable_5466);
true
gap> homalg_variable_5467 := SI_\[(homalg_variable_5442,9,2);;
gap> IsZero(homalg_variable_5467);
true
gap> homalg_variable_5468 := SI_\[(homalg_variable_5442,10,2);;
gap> IsZero(homalg_variable_5468);
true
gap> homalg_variable_5469 := SI_\[(homalg_variable_5442,11,2);;
gap> IsZero(homalg_variable_5469);
false
gap> homalg_variable_5470 := SI_\[(homalg_variable_5442,10,3);;
gap> SI_deg( homalg_variable_5470 );
0
gap> homalg_variable_5471 := SI_\[(homalg_variable_5442,1,3);;
gap> IsZero(homalg_variable_5471);
true
gap> homalg_variable_5472 := SI_\[(homalg_variable_5442,2,3);;
gap> IsZero(homalg_variable_5472);
true
gap> homalg_variable_5473 := SI_\[(homalg_variable_5442,3,3);;
gap> IsZero(homalg_variable_5473);
true
gap> homalg_variable_5474 := SI_\[(homalg_variable_5442,4,3);;
gap> IsZero(homalg_variable_5474);
true
gap> homalg_variable_5475 := SI_\[(homalg_variable_5442,5,3);;
gap> IsZero(homalg_variable_5475);
true
gap> homalg_variable_5476 := SI_\[(homalg_variable_5442,6,3);;
gap> IsZero(homalg_variable_5476);
true
gap> homalg_variable_5477 := SI_\[(homalg_variable_5442,7,3);;
gap> IsZero(homalg_variable_5477);
true
gap> homalg_variable_5478 := SI_\[(homalg_variable_5442,8,3);;
gap> IsZero(homalg_variable_5478);
true
gap> homalg_variable_5479 := SI_\[(homalg_variable_5442,9,3);;
gap> IsZero(homalg_variable_5479);
true
gap> homalg_variable_5480 := SI_\[(homalg_variable_5442,10,3);;
gap> IsZero(homalg_variable_5480);
false
gap> homalg_variable_5481 := SI_\[(homalg_variable_5442,9,4);;
gap> SI_deg( homalg_variable_5481 );
0
gap> homalg_variable_5482 := SI_\[(homalg_variable_5442,1,4);;
gap> IsZero(homalg_variable_5482);
true
gap> homalg_variable_5483 := SI_\[(homalg_variable_5442,2,4);;
gap> IsZero(homalg_variable_5483);
true
gap> homalg_variable_5484 := SI_\[(homalg_variable_5442,3,4);;
gap> IsZero(homalg_variable_5484);
true
gap> homalg_variable_5485 := SI_\[(homalg_variable_5442,4,4);;
gap> IsZero(homalg_variable_5485);
true
gap> homalg_variable_5486 := SI_\[(homalg_variable_5442,5,4);;
gap> IsZero(homalg_variable_5486);
true
gap> homalg_variable_5487 := SI_\[(homalg_variable_5442,6,4);;
gap> IsZero(homalg_variable_5487);
true
gap> homalg_variable_5488 := SI_\[(homalg_variable_5442,7,4);;
gap> IsZero(homalg_variable_5488);
true
gap> homalg_variable_5489 := SI_\[(homalg_variable_5442,8,4);;
gap> IsZero(homalg_variable_5489);
true
gap> homalg_variable_5490 := SI_\[(homalg_variable_5442,9,4);;
gap> IsZero(homalg_variable_5490);
false
gap> homalg_variable_5491 := SI_\[(homalg_variable_5442,8,5);;
gap> SI_deg( homalg_variable_5491 );
0
gap> homalg_variable_5492 := SI_\[(homalg_variable_5442,1,5);;
gap> IsZero(homalg_variable_5492);
true
gap> homalg_variable_5493 := SI_\[(homalg_variable_5442,2,5);;
gap> IsZero(homalg_variable_5493);
true
gap> homalg_variable_5494 := SI_\[(homalg_variable_5442,3,5);;
gap> IsZero(homalg_variable_5494);
true
gap> homalg_variable_5495 := SI_\[(homalg_variable_5442,4,5);;
gap> IsZero(homalg_variable_5495);
true
gap> homalg_variable_5496 := SI_\[(homalg_variable_5442,5,5);;
gap> IsZero(homalg_variable_5496);
true
gap> homalg_variable_5497 := SI_\[(homalg_variable_5442,6,5);;
gap> IsZero(homalg_variable_5497);
true
gap> homalg_variable_5498 := SI_\[(homalg_variable_5442,7,5);;
gap> IsZero(homalg_variable_5498);
true
gap> homalg_variable_5499 := SI_\[(homalg_variable_5442,8,5);;
gap> IsZero(homalg_variable_5499);
false
gap> homalg_variable_5500 := SI_\[(homalg_variable_5442,7,6);;
gap> SI_deg( homalg_variable_5500 );
0
gap> for _del in [ "homalg_variable_4981", "homalg_variable_4982", "homalg_variable_4983", "homalg_variable_4984", "homalg_variable_4986", "homalg_variable_4987", "homalg_variable_4988", "homalg_variable_4989", "homalg_variable_4990", "homalg_variable_4991", "homalg_variable_4992", "homalg_variable_4993", "homalg_variable_4994", "homalg_variable_4996", "homalg_variable_4997", "homalg_variable_4998", "homalg_variable_4999", "homalg_variable_5000", "homalg_variable_5001", "homalg_variable_5002", "homalg_variable_5006", "homalg_variable_5007", "homalg_variable_5008", "homalg_variable_5009", "homalg_variable_5012", "homalg_variable_5013", "homalg_variable_5014", "homalg_variable_5015", "homalg_variable_5016", "homalg_variable_5018", "homalg_variable_5019", "homalg_variable_5020", "homalg_variable_5021", "homalg_variable_5022", "homalg_variable_5023", "homalg_variable_5024", "homalg_variable_5025", "homalg_variable_5026", "homalg_variable_5028", "homalg_variable_5029", "homalg_variable_5030", "homalg_variable_5031", "homalg_variable_5032", "homalg_variable_5033", "homalg_variable_5037", "homalg_variable_5038", "homalg_variable_5039", "homalg_variable_5042", "homalg_variable_5044", "homalg_variable_5045", "homalg_variable_5046", "homalg_variable_5047", "homalg_variable_5048", "homalg_variable_5049", "homalg_variable_5050", "homalg_variable_5051", "homalg_variable_5052", "homalg_variable_5053", "homalg_variable_5054", "homalg_variable_5055", "homalg_variable_5056", "homalg_variable_5057", "homalg_variable_5058", "homalg_variable_5059", "homalg_variable_5060", "homalg_variable_5061", "homalg_variable_5062", "homalg_variable_5063", "homalg_variable_5064", "homalg_variable_5065", "homalg_variable_5066", "homalg_variable_5067", "homalg_variable_5068", "homalg_variable_5070", "homalg_variable_5073", "homalg_variable_5074", "homalg_variable_5077", "homalg_variable_5078", "homalg_variable_5079", "homalg_variable_5081", "homalg_variable_5084", "homalg_variable_5085", "homalg_variable_5086", "homalg_variable_5087", "homalg_variable_5088", "homalg_variable_5089", "homalg_variable_5090", "homalg_variable_5091", "homalg_variable_5092", "homalg_variable_5093", "homalg_variable_5095", "homalg_variable_5096", "homalg_variable_5097", "homalg_variable_5098", "homalg_variable_5100", "homalg_variable_5102", "homalg_variable_5103", "homalg_variable_5104", "homalg_variable_5105", "homalg_variable_5106", "homalg_variable_5107", "homalg_variable_5109", "homalg_variable_5110", "homalg_variable_5111", "homalg_variable_5112", "homalg_variable_5113", "homalg_variable_5114", "homalg_variable_5115", "homalg_variable_5116", "homalg_variable_5117", "homalg_variable_5118", "homalg_variable_5119", "homalg_variable_5120", "homalg_variable_5121", "homalg_variable_5122", "homalg_variable_5123", "homalg_variable_5124", "homalg_variable_5125", "homalg_variable_5126", "homalg_variable_5128", "homalg_variable_5131", "homalg_variable_5132", "homalg_variable_5133", "homalg_variable_5134", "homalg_variable_5135", "homalg_variable_5136", "homalg_variable_5137", "homalg_variable_5138", "homalg_variable_5139", "homalg_variable_5140", "homalg_variable_5141", "homalg_variable_5142", "homalg_variable_5146", "homalg_variable_5147", "homalg_variable_5148", "homalg_variable_5149", "homalg_variable_5151", "homalg_variable_5152", "homalg_variable_5153", "homalg_variable_5159", "homalg_variable_5161", "homalg_variable_5162", "homalg_variable_5163", "homalg_variable_5164", "homalg_variable_5165", "homalg_variable_5166", "homalg_variable_5167", "homalg_variable_5168", "homalg_variable_5169", "homalg_variable_5170", "homalg_variable_5171", "homalg_variable_5172", "homalg_variable_5173", "homalg_variable_5174", "homalg_variable_5175", "homalg_variable_5176", "homalg_variable_5177", "homalg_variable_5178", "homalg_variable_5179", "homalg_variable_5180", "homalg_variable_5181", "homalg_variable_5182", "homalg_variable_5183", "homalg_variable_5184", "homalg_variable_5185", "homalg_variable_5187", "homalg_variable_5190", "homalg_variable_5194", "homalg_variable_5195", "homalg_variable_5196", "homalg_variable_5197", "homalg_variable_5198", "homalg_variable_5201", "homalg_variable_5202", "homalg_variable_5203", "homalg_variable_5204", "homalg_variable_5205", "homalg_variable_5206", "homalg_variable_5207", "homalg_variable_5208", "homalg_variable_5209", "homalg_variable_5210", "homalg_variable_5212", "homalg_variable_5213", "homalg_variable_5214", "homalg_variable_5215", "homalg_variable_5219", "homalg_variable_5220", "homalg_variable_5221", "homalg_variable_5222", "homalg_variable_5223", "homalg_variable_5224", "homalg_variable_5225", "homalg_variable_5226", "homalg_variable_5227", "homalg_variable_5228", "homalg_variable_5230", "homalg_variable_5233", "homalg_variable_5234", "homalg_variable_5235", "homalg_variable_5236", "homalg_variable_5237", "homalg_variable_5238", "homalg_variable_5239", "homalg_variable_5240", "homalg_variable_5241", "homalg_variable_5242", "homalg_variable_5243", "homalg_variable_5244", "homalg_variable_5248", "homalg_variable_5249", "homalg_variable_5250", "homalg_variable_5251", "homalg_variable_5253", "homalg_variable_5254", "homalg_variable_5255", "homalg_variable_5258", "homalg_variable_5259", "homalg_variable_5260", "homalg_variable_5261", "homalg_variable_5262", "homalg_variable_5263", "homalg_variable_5265", "homalg_variable_5267", "homalg_variable_5268", "homalg_variable_5269", "homalg_variable_5271", "homalg_variable_5274", "homalg_variable_5275", "homalg_variable_5276", "homalg_variable_5277", "homalg_variable_5278", "homalg_variable_5279", "homalg_variable_5280", "homalg_variable_5281", "homalg_variable_5282", "homalg_variable_5283", "homalg_variable_5284", "homalg_variable_5285", "homalg_variable_5288", "homalg_variable_5289", "homalg_variable_5290", "homalg_variable_5294", "homalg_variable_5295", "homalg_variable_5296", "homalg_variable_5299", "homalg_variable_5301", "homalg_variable_5302", "homalg_variable_5303", "homalg_variable_5304", "homalg_variable_5305", "homalg_variable_5306", "homalg_variable_5307", "homalg_variable_5308", "homalg_variable_5309", "homalg_variable_5310", "homalg_variable_5311", "homalg_variable_5312", "homalg_variable_5313", "homalg_variable_5314", "homalg_variable_5317", "homalg_variable_5318", "homalg_variable_5320", "homalg_variable_5321", "homalg_variable_5322", "homalg_variable_5324", "homalg_variable_5327", "homalg_variable_5328", "homalg_variable_5329", "homalg_variable_5330", "homalg_variable_5331", "homalg_variable_5332", "homalg_variable_5333", "homalg_variable_5334", "homalg_variable_5335", "homalg_variable_5336", "homalg_variable_5337", "homalg_variable_5338", "homalg_variable_5341", "homalg_variable_5342", "homalg_variable_5343", "homalg_variable_5347", "homalg_variable_5351", "homalg_variable_5352", "homalg_variable_5353", "homalg_variable_5354", "homalg_variable_5355", "homalg_variable_5356", "homalg_variable_5358", "homalg_variable_5360", "homalg_variable_5361", "homalg_variable_5362", "homalg_variable_5363", "homalg_variable_5364", "homalg_variable_5367", "homalg_variable_5370", "homalg_variable_5371", "homalg_variable_5372", "homalg_variable_5373", "homalg_variable_5374", "homalg_variable_5375", "homalg_variable_5376", "homalg_variable_5377", "homalg_variable_5378", "homalg_variable_5379", "homalg_variable_5380", "homalg_variable_5381", "homalg_variable_5382", "homalg_variable_5383", "homalg_variable_5384", "homalg_variable_5385", "homalg_variable_5386", "homalg_variable_5387", "homalg_variable_5388", "homalg_variable_5389", "homalg_variable_5390", "homalg_variable_5391", "homalg_variable_5392", "homalg_variable_5396", "homalg_variable_5397", "homalg_variable_5398", "homalg_variable_5399", "homalg_variable_5400", "homalg_variable_5401", "homalg_variable_5405", "homalg_variable_5406", "homalg_variable_5407", "homalg_variable_5408", "homalg_variable_5409", "homalg_variable_5411", "homalg_variable_5414", "homalg_variable_5415", "homalg_variable_5416", "homalg_variable_5417", "homalg_variable_5418", "homalg_variable_5419", "homalg_variable_5420", "homalg_variable_5421", "homalg_variable_5422", "homalg_variable_5423", "homalg_variable_5424", "homalg_variable_5425", "homalg_variable_5428", "homalg_variable_5429", "homalg_variable_5430", "homalg_variable_5432", "homalg_variable_5434", "homalg_variable_5435", "homalg_variable_5436", "homalg_variable_5439", "homalg_variable_5440", "homalg_variable_5441", "homalg_variable_5444", "homalg_variable_5445", "homalg_variable_5446", "homalg_variable_5447", "homalg_variable_5448", "homalg_variable_5449", "homalg_variable_5450", "homalg_variable_5451", "homalg_variable_5452", "homalg_variable_5453", "homalg_variable_5454", "homalg_variable_5455", "homalg_variable_5456", "homalg_variable_5457", "homalg_variable_5458", "homalg_variable_5459", "homalg_variable_5460", "homalg_variable_5461", "homalg_variable_5462", "homalg_variable_5463", "homalg_variable_5464", "homalg_variable_5465", "homalg_variable_5466", "homalg_variable_5467", "homalg_variable_5468", "homalg_variable_5469", "homalg_variable_5470", "homalg_variable_5471", "homalg_variable_5472", "homalg_variable_5473", "homalg_variable_5474", "homalg_variable_5475", "homalg_variable_5476" ] do UnbindGlobal( _del );; od;;
gap> homalg_variable_5501 := SI_\[(homalg_variable_5442,1,6);;
gap> IsZero(homalg_variable_5501);
true
gap> homalg_variable_5502 := SI_\[(homalg_variable_5442,2,6);;
gap> IsZero(homalg_variable_5502);
true
gap> homalg_variable_5503 := SI_\[(homalg_variable_5442,3,6);;
gap> IsZero(homalg_variable_5503);
true
gap> homalg_variable_5504 := SI_\[(homalg_variable_5442,4,6);;
gap> IsZero(homalg_variable_5504);
true
gap> homalg_variable_5505 := SI_\[(homalg_variable_5442,5,6);;
gap> IsZero(homalg_variable_5505);
true
gap> homalg_variable_5506 := SI_\[(homalg_variable_5442,6,6);;
gap> IsZero(homalg_variable_5506);
true
gap> homalg_variable_5507 := SI_\[(homalg_variable_5442,7,6);;
gap> IsZero(homalg_variable_5507);
false
gap> homalg_variable_5508 := SI_\[(homalg_variable_5442,6,7);;
gap> SI_deg( homalg_variable_5508 );
-1
gap> homalg_variable_5509 := SI_\[(homalg_variable_5442,5,7);;
gap> SI_deg( homalg_variable_5509 );
-1
gap> homalg_variable_5510 := SI_\[(homalg_variable_5442,4,7);;
gap> SI_deg( homalg_variable_5510 );
1
gap> homalg_variable_5511 := SI_\[(homalg_variable_5442,3,7);;
gap> SI_deg( homalg_variable_5511 );
1
gap> homalg_variable_5512 := SI_\[(homalg_variable_5442,2,7);;
gap> SI_deg( homalg_variable_5512 );
-1
gap> homalg_variable_5513 := SI_\[(homalg_variable_5442,1,7);;
gap> SI_deg( homalg_variable_5513 );
-1
gap> homalg_variable_5514 := SI_\[(homalg_variable_5442,6,8);;
gap> SI_deg( homalg_variable_5514 );
1
gap> homalg_variable_5515 := SI_\[(homalg_variable_5442,5,8);;
gap> SI_deg( homalg_variable_5515 );
1
gap> homalg_variable_5516 := SI_\[(homalg_variable_5442,4,8);;
gap> SI_deg( homalg_variable_5516 );
-1
gap> homalg_variable_5517 := SI_\[(homalg_variable_5442,3,8);;
gap> SI_deg( homalg_variable_5517 );
-1
gap> homalg_variable_5518 := SI_\[(homalg_variable_5442,2,8);;
gap> SI_deg( homalg_variable_5518 );
-1
gap> homalg_variable_5519 := SI_\[(homalg_variable_5442,1,8);;
gap> SI_deg( homalg_variable_5519 );
-1
gap> homalg_variable_5520 := SI_\[(homalg_variable_5442,6,9);;
gap> SI_deg( homalg_variable_5520 );
-1
gap> homalg_variable_5521 := SI_\[(homalg_variable_5442,5,9);;
gap> SI_deg( homalg_variable_5521 );
1
gap> homalg_variable_5522 := SI_\[(homalg_variable_5442,4,9);;
gap> SI_deg( homalg_variable_5522 );
-1
gap> homalg_variable_5523 := SI_\[(homalg_variable_5442,3,9);;
gap> SI_deg( homalg_variable_5523 );
1
gap> homalg_variable_5524 := SI_\[(homalg_variable_5442,2,9);;
gap> SI_deg( homalg_variable_5524 );
-1
gap> homalg_variable_5525 := SI_\[(homalg_variable_5442,1,9);;
gap> SI_deg( homalg_variable_5525 );
3
gap> homalg_variable_5526 := SI_\[(homalg_variable_5442,6,10);;
gap> SI_deg( homalg_variable_5526 );
1
gap> homalg_variable_5527 := SI_\[(homalg_variable_5442,5,10);;
gap> SI_deg( homalg_variable_5527 );
-1
gap> homalg_variable_5528 := SI_\[(homalg_variable_5442,4,10);;
gap> SI_deg( homalg_variable_5528 );
-1
gap> homalg_variable_5529 := SI_\[(homalg_variable_5442,3,10);;
gap> SI_deg( homalg_variable_5529 );
1
gap> homalg_variable_5530 := SI_\[(homalg_variable_5442,2,10);;
gap> SI_deg( homalg_variable_5530 );
-1
gap> homalg_variable_5531 := SI_\[(homalg_variable_5442,1,10);;
gap> SI_deg( homalg_variable_5531 );
3
gap> homalg_variable_5532 := SI_\[(homalg_variable_12,6,1);;
gap> SI_deg( homalg_variable_5532 );
-1
gap> homalg_variable_5533 := SI_\[(homalg_variable_12,5,1);;
gap> SI_deg( homalg_variable_5533 );
-1
gap> homalg_variable_5534 := SI_\[(homalg_variable_12,4,1);;
gap> SI_deg( homalg_variable_5534 );
1
gap> homalg_variable_5535 := SI_\[(homalg_variable_12,3,1);;
gap> SI_deg( homalg_variable_5535 );
1
gap> homalg_variable_5536 := SI_\[(homalg_variable_12,2,1);;
gap> SI_deg( homalg_variable_5536 );
-1
gap> homalg_variable_5537 := SI_\[(homalg_variable_12,1,1);;
gap> SI_deg( homalg_variable_5537 );
-1
gap> homalg_variable_5538 := SI_\[(homalg_variable_12,6,2);;
gap> SI_deg( homalg_variable_5538 );
1
gap> homalg_variable_5539 := SI_\[(homalg_variable_12,5,2);;
gap> SI_deg( homalg_variable_5539 );
1
gap> homalg_variable_5540 := SI_\[(homalg_variable_12,4,2);;
gap> SI_deg( homalg_variable_5540 );
-1
gap> homalg_variable_5541 := SI_\[(homalg_variable_12,3,2);;
gap> SI_deg( homalg_variable_5541 );
-1
gap> homalg_variable_5542 := SI_\[(homalg_variable_12,2,2);;
gap> SI_deg( homalg_variable_5542 );
-1
gap> homalg_variable_5543 := SI_\[(homalg_variable_12,1,2);;
gap> SI_deg( homalg_variable_5543 );
-1
gap> homalg_variable_5544 := SI_\[(homalg_variable_12,6,3);;
gap> SI_deg( homalg_variable_5544 );
-1
gap> homalg_variable_5545 := SI_\[(homalg_variable_12,5,3);;
gap> SI_deg( homalg_variable_5545 );
1
gap> homalg_variable_5546 := SI_\[(homalg_variable_12,4,3);;
gap> SI_deg( homalg_variable_5546 );
-1
gap> homalg_variable_5547 := SI_\[(homalg_variable_12,3,3);;
gap> SI_deg( homalg_variable_5547 );
1
gap> homalg_variable_5548 := SI_\[(homalg_variable_12,2,3);;
gap> SI_deg( homalg_variable_5548 );
-1
gap> homalg_variable_5549 := SI_\[(homalg_variable_12,1,3);;
gap> SI_deg( homalg_variable_5549 );
3
gap> homalg_variable_5550 := SI_\[(homalg_variable_12,6,4);;
gap> SI_deg( homalg_variable_5550 );
1
gap> homalg_variable_5551 := SI_\[(homalg_variable_12,5,4);;
gap> SI_deg( homalg_variable_5551 );
-1
gap> homalg_variable_5552 := SI_\[(homalg_variable_12,4,4);;
gap> SI_deg( homalg_variable_5552 );
-1
gap> homalg_variable_5553 := SI_\[(homalg_variable_12,3,4);;
gap> SI_deg( homalg_variable_5553 );
1
gap> homalg_variable_5554 := SI_\[(homalg_variable_12,2,4);;
gap> SI_deg( homalg_variable_5554 );
-1
gap> homalg_variable_5555 := SI_\[(homalg_variable_12,1,4);;
gap> SI_deg( homalg_variable_5555 );
3
gap> homalg_variable_5556 := SIH_BasisOfColumnModule(homalg_variable_5443);;
gap> SI_ncols(homalg_variable_5556);
6
gap> homalg_variable_5557 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5556 = homalg_variable_5557;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5556,homalg_variable_10);; homalg_variable_5558 := homalg_variable_l[1];; homalg_variable_5559 := homalg_variable_l[2];;
gap> homalg_variable_5560 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5558 = homalg_variable_5560;
true
gap> homalg_variable_5561 := homalg_variable_10 * homalg_variable_5559;;
gap> homalg_variable_5562 := homalg_variable_5556 + homalg_variable_5561;;
gap> homalg_variable_5558 = homalg_variable_5562;
true
gap> homalg_variable_5563 := SIH_DecideZeroColumns(homalg_variable_5556,homalg_variable_10);;
gap> homalg_variable_5564 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5563 = homalg_variable_5564;
true
gap> homalg_variable_5565 := homalg_variable_5559 * (homalg_variable_8);;
gap> homalg_variable_5566 := homalg_variable_10 * homalg_variable_5565;;
gap> homalg_variable_5566 = homalg_variable_5556;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_10,homalg_variable_5556);; homalg_variable_5567 := homalg_variable_l[1];; homalg_variable_5568 := homalg_variable_l[2];;
gap> homalg_variable_5569 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5567 = homalg_variable_5569;
true
gap> homalg_variable_5570 := homalg_variable_5556 * homalg_variable_5568;;
gap> homalg_variable_5571 := homalg_variable_10 + homalg_variable_5570;;
gap> homalg_variable_5567 = homalg_variable_5571;
true
gap> homalg_variable_5572 := SIH_DecideZeroColumns(homalg_variable_10,homalg_variable_5556);;
gap> homalg_variable_5573 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5572 = homalg_variable_5573;
true
gap> homalg_variable_5574 := homalg_variable_5568 * (homalg_variable_8);;
gap> homalg_variable_5575 := homalg_variable_5556 * homalg_variable_5574;;
gap> homalg_variable_5575 = homalg_variable_10;
true
gap> homalg_variable_5577 := homalg_variable_5036 * homalg_variable_4431;;
gap> homalg_variable_5576 := SIH_DecideZeroColumns(homalg_variable_5577,homalg_variable_10);;
gap> homalg_variable_5578 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5576 = homalg_variable_5578;
true
gap> homalg_variable_5580 := SIH_UnionOfColumns(homalg_variable_5036,homalg_variable_10);;
gap> homalg_variable_5579 := SIH_BasisOfColumnModule(homalg_variable_5580);;
gap> SI_ncols(homalg_variable_5579);
5
gap> homalg_variable_5581 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5579 = homalg_variable_5581;
false
gap> homalg_variable_5582 := SIH_DecideZeroColumns(homalg_variable_42,homalg_variable_5579);;
gap> homalg_variable_5583 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5582 = homalg_variable_5583;
true
gap> homalg_variable_5584 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_5036,homalg_variable_10);;
gap> SI_ncols(homalg_variable_5584);
6
gap> homalg_variable_5585 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5584 = homalg_variable_5585;
false
gap> homalg_variable_5586 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5584);;
gap> SI_ncols(homalg_variable_5586);
4
gap> homalg_variable_5587 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_5586 = homalg_variable_5587;
false
gap> homalg_variable_5588 := SI_\[(homalg_variable_5586,6,1);;
gap> SI_deg( homalg_variable_5588 );
-1
gap> homalg_variable_5589 := SI_\[(homalg_variable_5586,5,1);;
gap> SI_deg( homalg_variable_5589 );
-1
gap> homalg_variable_5590 := SI_\[(homalg_variable_5586,4,1);;
gap> SI_deg( homalg_variable_5590 );
1
gap> homalg_variable_5591 := SI_\[(homalg_variable_5586,3,1);;
gap> SI_deg( homalg_variable_5591 );
1
gap> homalg_variable_5592 := SI_\[(homalg_variable_5586,2,1);;
gap> SI_deg( homalg_variable_5592 );
-1
gap> homalg_variable_5593 := SI_\[(homalg_variable_5586,1,1);;
gap> SI_deg( homalg_variable_5593 );
-1
gap> homalg_variable_5594 := SI_\[(homalg_variable_5586,6,2);;
gap> SI_deg( homalg_variable_5594 );
1
gap> homalg_variable_5595 := SI_\[(homalg_variable_5586,5,2);;
gap> SI_deg( homalg_variable_5595 );
1
gap> homalg_variable_5596 := SI_\[(homalg_variable_5586,4,2);;
gap> SI_deg( homalg_variable_5596 );
-1
gap> homalg_variable_5597 := SI_\[(homalg_variable_5586,3,2);;
gap> SI_deg( homalg_variable_5597 );
-1
gap> homalg_variable_5598 := SI_\[(homalg_variable_5586,2,2);;
gap> SI_deg( homalg_variable_5598 );
-1
gap> homalg_variable_5599 := SI_\[(homalg_variable_5586,1,2);;
gap> SI_deg( homalg_variable_5599 );
-1
gap> homalg_variable_5600 := SI_\[(homalg_variable_5586,6,3);;
gap> SI_deg( homalg_variable_5600 );
-1
gap> homalg_variable_5601 := SI_\[(homalg_variable_5586,5,3);;
gap> SI_deg( homalg_variable_5601 );
1
gap> homalg_variable_5602 := SI_\[(homalg_variable_5586,4,3);;
gap> SI_deg( homalg_variable_5602 );
-1
gap> homalg_variable_5603 := SI_\[(homalg_variable_5586,3,3);;
gap> SI_deg( homalg_variable_5603 );
1
gap> homalg_variable_5604 := SI_\[(homalg_variable_5586,2,3);;
gap> SI_deg( homalg_variable_5604 );
-1
gap> homalg_variable_5605 := SI_\[(homalg_variable_5586,1,3);;
gap> SI_deg( homalg_variable_5605 );
3
gap> homalg_variable_5606 := SI_\[(homalg_variable_5586,6,4);;
gap> SI_deg( homalg_variable_5606 );
1
gap> homalg_variable_5607 := SI_\[(homalg_variable_5586,5,4);;
gap> SI_deg( homalg_variable_5607 );
-1
gap> homalg_variable_5608 := SI_\[(homalg_variable_5586,4,4);;
gap> SI_deg( homalg_variable_5608 );
-1
gap> homalg_variable_5609 := SI_\[(homalg_variable_5586,3,4);;
gap> SI_deg( homalg_variable_5609 );
1
gap> homalg_variable_5610 := SI_\[(homalg_variable_5586,2,4);;
gap> SI_deg( homalg_variable_5610 );
-1
gap> homalg_variable_5611 := SI_\[(homalg_variable_5586,1,4);;
gap> SI_deg( homalg_variable_5611 );
3
gap> homalg_variable_5612 := SIH_BasisOfColumnModule(homalg_variable_5584);;
gap> SI_ncols(homalg_variable_5612);
6
gap> homalg_variable_5613 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5612 = homalg_variable_5613;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5584);; homalg_variable_5614 := homalg_variable_l[1];; homalg_variable_5615 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5614);
6
gap> homalg_variable_5616 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5614 = homalg_variable_5616;
false
gap> SI_nrows(homalg_variable_5615);
6
gap> homalg_variable_5617 := homalg_variable_5584 * homalg_variable_5615;;
gap> homalg_variable_5614 = homalg_variable_5617;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5612,homalg_variable_5614);; homalg_variable_5618 := homalg_variable_l[1];; homalg_variable_5619 := homalg_variable_l[2];;
gap> homalg_variable_5620 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5618 = homalg_variable_5620;
true
gap> homalg_variable_5621 := homalg_variable_5614 * homalg_variable_5619;;
gap> homalg_variable_5622 := homalg_variable_5612 + homalg_variable_5621;;
gap> homalg_variable_5618 = homalg_variable_5622;
true
gap> homalg_variable_5623 := SIH_DecideZeroColumns(homalg_variable_5612,homalg_variable_5614);;
gap> homalg_variable_5624 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5623 = homalg_variable_5624;
true
gap> homalg_variable_5625 := homalg_variable_5619 * (homalg_variable_8);;
gap> homalg_variable_5626 := homalg_variable_5615 * homalg_variable_5625;;
gap> homalg_variable_5627 := homalg_variable_5584 * homalg_variable_5626;;
gap> homalg_variable_5627 = homalg_variable_5612;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5584,homalg_variable_5612);; homalg_variable_5628 := homalg_variable_l[1];; homalg_variable_5629 := homalg_variable_l[2];;
gap> homalg_variable_5630 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5628 = homalg_variable_5630;
true
gap> homalg_variable_5631 := homalg_variable_5612 * homalg_variable_5629;;
gap> homalg_variable_5632 := homalg_variable_5584 + homalg_variable_5631;;
gap> homalg_variable_5628 = homalg_variable_5632;
true
gap> homalg_variable_5633 := SIH_DecideZeroColumns(homalg_variable_5584,homalg_variable_5612);;
gap> homalg_variable_5634 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5633 = homalg_variable_5634;
true
gap> homalg_variable_5635 := homalg_variable_5629 * (homalg_variable_8);;
gap> homalg_variable_5636 := homalg_variable_5612 * homalg_variable_5635;;
gap> homalg_variable_5636 = homalg_variable_5584;
true
gap> homalg_variable_5637 := SIH_DecideZeroColumns(homalg_variable_5584,homalg_variable_4431);;
gap> homalg_variable_5638 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5637 = homalg_variable_5638;
true
gap> homalg_variable_5640 := homalg_variable_5036 * homalg_variable_5005;;
gap> homalg_variable_5641 := SIH_UnionOfColumns(homalg_variable_5640,homalg_variable_10);;
gap> homalg_variable_5639 := SIH_BasisOfColumnModule(homalg_variable_5641);;
gap> SI_ncols(homalg_variable_5639);
5
gap> homalg_variable_5642 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5639 = homalg_variable_5642;
false
gap> homalg_variable_5643 := SIH_DecideZeroColumns(homalg_variable_5640,homalg_variable_5639);;
gap> homalg_variable_5644 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_5643 = homalg_variable_5644;
true
gap> homalg_variable_5646 := homalg_variable_5036 * homalg_variable_4976;;
gap> homalg_variable_5647 := homalg_variable_5646 * homalg_variable_3419;;
gap> homalg_variable_5645 := SIH_DecideZeroColumns(homalg_variable_5647,homalg_variable_5639);;
gap> homalg_variable_5648 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_5645 = homalg_variable_5648;
true
gap> homalg_variable_5649 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_5646,homalg_variable_5641);;
gap> SI_ncols(homalg_variable_5649);
2
gap> homalg_variable_5650 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5649 = homalg_variable_5650;
false
gap> homalg_variable_5651 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5649);;
gap> SI_ncols(homalg_variable_5651);
1
gap> homalg_variable_5652 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_5651 = homalg_variable_5652;
false
gap> homalg_variable_5653 := SI_\[(homalg_variable_5651,2,1);;
gap> SI_deg( homalg_variable_5653 );
1
gap> homalg_variable_5654 := SI_\[(homalg_variable_5651,1,1);;
gap> SI_deg( homalg_variable_5654 );
1
gap> homalg_variable_5655 := SIH_BasisOfColumnModule(homalg_variable_5649);;
gap> SI_ncols(homalg_variable_5655);
2
gap> homalg_variable_5656 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5655 = homalg_variable_5656;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5649);; homalg_variable_5657 := homalg_variable_l[1];; homalg_variable_5658 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5657);
2
gap> homalg_variable_5659 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5657 = homalg_variable_5659;
false
gap> SI_nrows(homalg_variable_5658);
2
gap> homalg_variable_5660 := homalg_variable_5649 * homalg_variable_5658;;
gap> homalg_variable_5657 = homalg_variable_5660;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5655,homalg_variable_5657);; homalg_variable_5661 := homalg_variable_l[1];; homalg_variable_5662 := homalg_variable_l[2];;
gap> homalg_variable_5663 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5661 = homalg_variable_5663;
true
gap> homalg_variable_5664 := homalg_variable_5657 * homalg_variable_5662;;
gap> homalg_variable_5665 := homalg_variable_5655 + homalg_variable_5664;;
gap> homalg_variable_5661 = homalg_variable_5665;
true
gap> homalg_variable_5666 := SIH_DecideZeroColumns(homalg_variable_5655,homalg_variable_5657);;
gap> homalg_variable_5667 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5666 = homalg_variable_5667;
true
gap> homalg_variable_5668 := homalg_variable_5662 * (homalg_variable_8);;
gap> homalg_variable_5669 := homalg_variable_5658 * homalg_variable_5668;;
gap> homalg_variable_5670 := homalg_variable_5649 * homalg_variable_5669;;
gap> homalg_variable_5670 = homalg_variable_5655;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5649,homalg_variable_5655);; homalg_variable_5671 := homalg_variable_l[1];; homalg_variable_5672 := homalg_variable_l[2];;
gap> homalg_variable_5673 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5671 = homalg_variable_5673;
true
gap> homalg_variable_5674 := homalg_variable_5655 * homalg_variable_5672;;
gap> homalg_variable_5675 := homalg_variable_5649 + homalg_variable_5674;;
gap> homalg_variable_5671 = homalg_variable_5675;
true
gap> homalg_variable_5676 := SIH_DecideZeroColumns(homalg_variable_5649,homalg_variable_5655);;
gap> homalg_variable_5677 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5676 = homalg_variable_5677;
true
gap> homalg_variable_5678 := homalg_variable_5672 * (homalg_variable_8);;
gap> homalg_variable_5679 := homalg_variable_5655 * homalg_variable_5678;;
gap> homalg_variable_5679 = homalg_variable_5649;
true
gap> homalg_variable_5680 := SIH_DecideZeroColumns(homalg_variable_5649,homalg_variable_3419);;
gap> homalg_variable_5681 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5680 = homalg_variable_5681;
true
gap> homalg_variable_5683 := SIH_UnionOfColumns(homalg_variable_5640,homalg_variable_5646);;
gap> homalg_variable_5684 := SIH_UnionOfColumns(homalg_variable_5683,homalg_variable_10);;
gap> homalg_variable_5682 := SIH_BasisOfColumnModule(homalg_variable_5684);;
gap> SI_ncols(homalg_variable_5682);
4
gap> homalg_variable_5685 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5682 = homalg_variable_5685;
false
gap> homalg_variable_5686 := SIH_DecideZeroColumns(homalg_variable_5683,homalg_variable_5682);;
gap> homalg_variable_5687 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_5686 = homalg_variable_5687;
true
gap> homalg_variable_5689 := homalg_variable_5036 * homalg_variable_4905;;
gap> homalg_variable_5690 := homalg_variable_5689 * homalg_variable_3775;;
gap> homalg_variable_5688 := SIH_DecideZeroColumns(homalg_variable_5690,homalg_variable_5682);;
gap> homalg_variable_5691 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5688 = homalg_variable_5691;
true
gap> homalg_variable_5692 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_5689,homalg_variable_5684);;
gap> SI_ncols(homalg_variable_5692);
5
gap> homalg_variable_5693 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_5692 = homalg_variable_5693;
false
gap> homalg_variable_5694 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5692);;
gap> SI_ncols(homalg_variable_5694);
1
gap> homalg_variable_5695 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_5694 = homalg_variable_5695;
false
gap> homalg_variable_5696 := SI_\[(homalg_variable_5694,5,1);;
gap> SI_deg( homalg_variable_5696 );
-1
gap> homalg_variable_5697 := SI_\[(homalg_variable_5694,4,1);;
gap> SI_deg( homalg_variable_5697 );
1
gap> homalg_variable_5698 := SI_\[(homalg_variable_5694,3,1);;
gap> SI_deg( homalg_variable_5698 );
1
gap> homalg_variable_5699 := SI_\[(homalg_variable_5694,2,1);;
gap> SI_deg( homalg_variable_5699 );
1
gap> homalg_variable_5700 := SI_\[(homalg_variable_5694,1,1);;
gap> SI_deg( homalg_variable_5700 );
-1
gap> homalg_variable_5701 := SIH_BasisOfColumnModule(homalg_variable_5692);;
gap> SI_ncols(homalg_variable_5701);
5
gap> homalg_variable_5702 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_5701 = homalg_variable_5702;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5692);; homalg_variable_5703 := homalg_variable_l[1];; homalg_variable_5704 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5703);
5
gap> homalg_variable_5705 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_5703 = homalg_variable_5705;
false
gap> SI_nrows(homalg_variable_5704);
5
gap> homalg_variable_5706 := homalg_variable_5692 * homalg_variable_5704;;
gap> homalg_variable_5703 = homalg_variable_5706;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5701,homalg_variable_5703);; homalg_variable_5707 := homalg_variable_l[1];; homalg_variable_5708 := homalg_variable_l[2];;
gap> homalg_variable_5709 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_5707 = homalg_variable_5709;
true
gap> homalg_variable_5710 := homalg_variable_5703 * homalg_variable_5708;;
gap> homalg_variable_5711 := homalg_variable_5701 + homalg_variable_5710;;
gap> homalg_variable_5707 = homalg_variable_5711;
true
gap> homalg_variable_5712 := SIH_DecideZeroColumns(homalg_variable_5701,homalg_variable_5703);;
gap> homalg_variable_5713 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_5712 = homalg_variable_5713;
true
gap> homalg_variable_5714 := homalg_variable_5708 * (homalg_variable_8);;
gap> homalg_variable_5715 := homalg_variable_5704 * homalg_variable_5714;;
gap> homalg_variable_5716 := homalg_variable_5692 * homalg_variable_5715;;
gap> homalg_variable_5716 = homalg_variable_5701;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5692,homalg_variable_5701);; homalg_variable_5717 := homalg_variable_l[1];; homalg_variable_5718 := homalg_variable_l[2];;
gap> homalg_variable_5719 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_5717 = homalg_variable_5719;
true
gap> homalg_variable_5720 := homalg_variable_5701 * homalg_variable_5718;;
gap> homalg_variable_5721 := homalg_variable_5692 + homalg_variable_5720;;
gap> homalg_variable_5717 = homalg_variable_5721;
true
gap> homalg_variable_5722 := SIH_DecideZeroColumns(homalg_variable_5692,homalg_variable_5701);;
gap> homalg_variable_5723 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_5722 = homalg_variable_5723;
true
gap> homalg_variable_5724 := homalg_variable_5718 * (homalg_variable_8);;
gap> homalg_variable_5725 := homalg_variable_5701 * homalg_variable_5724;;
gap> homalg_variable_5725 = homalg_variable_5692;
true
gap> homalg_variable_5726 := SIH_DecideZeroColumns(homalg_variable_5692,homalg_variable_3775);;
gap> homalg_variable_5727 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_5726 = homalg_variable_5727;
true
gap> homalg_variable_5729 := SIH_UnionOfColumns(homalg_variable_5683,homalg_variable_5689);;
gap> homalg_variable_5730 := SIH_UnionOfColumns(homalg_variable_5729,homalg_variable_10);;
gap> homalg_variable_5728 := SIH_BasisOfColumnModule(homalg_variable_5730);;
gap> SI_ncols(homalg_variable_5728);
4
gap> homalg_variable_5731 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5728 = homalg_variable_5731;
false
gap> homalg_variable_5732 := SIH_DecideZeroColumns(homalg_variable_5729,homalg_variable_5728);;
gap> homalg_variable_5733 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_5732 = homalg_variable_5733;
true
gap> homalg_variable_5735 := homalg_variable_5036 * homalg_variable_4811;;
gap> homalg_variable_5736 := homalg_variable_5735 * homalg_variable_3975;;
gap> homalg_variable_5734 := SIH_DecideZeroColumns(homalg_variable_5736,homalg_variable_5728);;
gap> homalg_variable_5737 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5734 = homalg_variable_5737;
true
gap> homalg_variable_5738 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_5735,homalg_variable_5730);;
gap> SI_ncols(homalg_variable_5738);
4
gap> homalg_variable_5739 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5738 = homalg_variable_5739;
false
gap> homalg_variable_5740 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5738);;
gap> SI_ncols(homalg_variable_5740);
1
gap> homalg_variable_5741 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_5740 = homalg_variable_5741;
false
gap> homalg_variable_5742 := SI_\[(homalg_variable_5740,4,1);;
gap> SI_deg( homalg_variable_5742 );
-1
gap> homalg_variable_5743 := SI_\[(homalg_variable_5740,3,1);;
gap> SI_deg( homalg_variable_5743 );
1
gap> homalg_variable_5744 := SI_\[(homalg_variable_5740,2,1);;
gap> SI_deg( homalg_variable_5744 );
1
gap> homalg_variable_5745 := SI_\[(homalg_variable_5740,1,1);;
gap> SI_deg( homalg_variable_5745 );
1
gap> homalg_variable_5746 := SIH_BasisOfColumnModule(homalg_variable_5738);;
gap> SI_ncols(homalg_variable_5746);
4
gap> homalg_variable_5747 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5746 = homalg_variable_5747;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5738);; homalg_variable_5748 := homalg_variable_l[1];; homalg_variable_5749 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5748);
4
gap> homalg_variable_5750 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5748 = homalg_variable_5750;
false
gap> SI_nrows(homalg_variable_5749);
4
gap> homalg_variable_5751 := homalg_variable_5738 * homalg_variable_5749;;
gap> homalg_variable_5748 = homalg_variable_5751;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5746,homalg_variable_5748);; homalg_variable_5752 := homalg_variable_l[1];; homalg_variable_5753 := homalg_variable_l[2];;
gap> homalg_variable_5754 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5752 = homalg_variable_5754;
true
gap> homalg_variable_5755 := homalg_variable_5748 * homalg_variable_5753;;
gap> homalg_variable_5756 := homalg_variable_5746 + homalg_variable_5755;;
gap> homalg_variable_5752 = homalg_variable_5756;
true
gap> homalg_variable_5757 := SIH_DecideZeroColumns(homalg_variable_5746,homalg_variable_5748);;
gap> homalg_variable_5758 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5757 = homalg_variable_5758;
true
gap> homalg_variable_5759 := homalg_variable_5753 * (homalg_variable_8);;
gap> homalg_variable_5760 := homalg_variable_5749 * homalg_variable_5759;;
gap> homalg_variable_5761 := homalg_variable_5738 * homalg_variable_5760;;
gap> homalg_variable_5761 = homalg_variable_5746;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5738,homalg_variable_5746);; homalg_variable_5762 := homalg_variable_l[1];; homalg_variable_5763 := homalg_variable_l[2];;
gap> homalg_variable_5764 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5762 = homalg_variable_5764;
true
gap> homalg_variable_5765 := homalg_variable_5746 * homalg_variable_5763;;
gap> homalg_variable_5766 := homalg_variable_5738 + homalg_variable_5765;;
gap> homalg_variable_5762 = homalg_variable_5766;
true
gap> homalg_variable_5767 := SIH_DecideZeroColumns(homalg_variable_5738,homalg_variable_5746);;
gap> homalg_variable_5768 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5767 = homalg_variable_5768;
true
gap> homalg_variable_5769 := homalg_variable_5763 * (homalg_variable_8);;
gap> homalg_variable_5770 := homalg_variable_5746 * homalg_variable_5769;;
gap> homalg_variable_5770 = homalg_variable_5738;
true
gap> homalg_variable_5771 := SIH_DecideZeroColumns(homalg_variable_5738,homalg_variable_3975);;
gap> homalg_variable_5772 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_5771 = homalg_variable_5772;
true
gap> homalg_variable_5774 := SIH_UnionOfColumns(homalg_variable_5735,homalg_variable_5730);;
gap> homalg_variable_5773 := SIH_BasisOfColumnModule(homalg_variable_5774);;
gap> SI_ncols(homalg_variable_5773);
5
gap> homalg_variable_5775 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5773 = homalg_variable_5775;
false
gap> homalg_variable_5776 := SIH_DecideZeroColumns(homalg_variable_42,homalg_variable_5773);;
gap> homalg_variable_5777 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5776 = homalg_variable_5777;
true
gap> homalg_variable_5778 := SI_\[(homalg_variable_3336,1,1);;
gap> SI_deg( homalg_variable_5778 );
1
gap> homalg_variable_5779 := SI_\[(homalg_variable_3336,1,2);;
gap> SI_deg( homalg_variable_5779 );
1
gap> homalg_variable_5780 := SI_\[(homalg_variable_3336,1,3);;
gap> SI_deg( homalg_variable_5780 );
1
gap> homalg_variable_5781 := SIH_BasisOfRowModule(homalg_variable_3336);;
gap> SI_nrows(homalg_variable_5781);
1
gap> homalg_variable_5782 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5781 = homalg_variable_5782;
false
gap> homalg_variable_5783 := SIH_DecideZeroRows(homalg_variable_3336,homalg_variable_5781);;
gap> homalg_variable_5784 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_5783 = homalg_variable_5784;
true
gap> homalg_variable_5785 := SIH_DecideZeroColumns(homalg_variable_237,homalg_variable_3336);;
gap> homalg_variable_5786 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_5785 = homalg_variable_5786;
false
gap> homalg_variable_5787 := SIH_DecideZeroColumns(homalg_variable_237,homalg_variable_3336);;
gap> homalg_variable_5788 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_5787 = homalg_variable_5788;
false
gap> homalg_variable_5787 = homalg_variable_237;
true
gap> homalg_variable_5789 := SI_\[(homalg_variable_3419,1,1);;
gap> SI_deg( homalg_variable_5789 );
1
gap> homalg_variable_5790 := SI_\[(homalg_variable_3419,1,2);;
gap> SI_deg( homalg_variable_5790 );
1
gap> homalg_variable_5791 := SIH_BasisOfRowModule(homalg_variable_3419);;
gap> SI_nrows(homalg_variable_5791);
1
gap> homalg_variable_5792 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5791 = homalg_variable_5792;
false
gap> homalg_variable_5793 := SIH_DecideZeroRows(homalg_variable_3419,homalg_variable_5791);;
gap> homalg_variable_5794 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_5793 = homalg_variable_5794;
true
gap> homalg_variable_5796 := homalg_variable_2831 * homalg_variable_3208;;
gap> homalg_variable_5797 := SIH_UnionOfColumns(homalg_variable_2826,homalg_variable_5796);;
gap> homalg_variable_5795 := SIH_BasisOfColumnModule(homalg_variable_5797);;
gap> SI_ncols(homalg_variable_5795);
5
gap> homalg_variable_5798 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_5795 = homalg_variable_5798;
false
gap> homalg_variable_5800 := homalg_variable_2831 * homalg_variable_3383;;
gap> homalg_variable_5799 := SIH_DecideZeroColumns(homalg_variable_5800,homalg_variable_5795);;
gap> homalg_variable_5801 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_5799 = homalg_variable_5801;
false
gap> homalg_variable_5802 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_5800 = homalg_variable_5802;
false
gap> homalg_variable_5799 = homalg_variable_5800;
true
gap> homalg_variable_5803 := SI_\[(homalg_variable_3775,1,1);;
gap> SI_deg( homalg_variable_5803 );
0
gap> homalg_variable_5804 := SI_\[(homalg_variable_3775,1,1);;
gap> SI_deg( homalg_variable_5804 );
0
gap> IsZero(homalg_variable_5804);
false
gap> IsOne(homalg_variable_5804);
true
gap> homalg_variable_5805 := SIH_Submatrix(homalg_variable_3775,[ 2, 3, 4 ],[1..5]);;
gap> homalg_variable_5806 := SIH_Submatrix(homalg_variable_5805,[1..3],[ 2, 3, 4, 5 ]);;
gap> homalg_variable_5807 := SIH_Submatrix(homalg_variable_3775,[1..4],[ 1 ]);;
gap> homalg_variable_5808 := SIH_Submatrix(homalg_variable_5807,[ 2, 3, 4 ],[1..1]);;
gap> homalg_variable_5809 := SIH_Submatrix(homalg_variable_3775,[ 1 ],[1..5]);;
gap> homalg_variable_5810 := SIH_Submatrix(homalg_variable_5809,[1..1],[ 2, 3, 4, 5 ]);;
gap> homalg_variable_5811 := homalg_variable_5808 * homalg_variable_5810;;
gap> homalg_variable_5812 := homalg_variable_5806 - homalg_variable_5811;;
gap> homalg_variable_5813 := SI_\[(homalg_variable_5812,1,1);;
gap> SI_deg( homalg_variable_5813 );
1
gap> homalg_variable_5814 := SI_\[(homalg_variable_5812,2,1);;
gap> SI_deg( homalg_variable_5814 );
1
gap> homalg_variable_5815 := SI_\[(homalg_variable_5812,3,1);;
gap> SI_deg( homalg_variable_5815 );
-1
gap> homalg_variable_5816 := SI_\[(homalg_variable_5812,1,2);;
gap> SI_deg( homalg_variable_5816 );
-1
gap> homalg_variable_5817 := SI_\[(homalg_variable_5812,2,2);;
gap> SI_deg( homalg_variable_5817 );
1
gap> homalg_variable_5818 := SI_\[(homalg_variable_5812,3,2);;
gap> SI_deg( homalg_variable_5818 );
1
gap> homalg_variable_5819 := SI_\[(homalg_variable_5812,1,3);;
gap> SI_deg( homalg_variable_5819 );
1
gap> homalg_variable_5820 := SI_\[(homalg_variable_5812,2,3);;
gap> SI_deg( homalg_variable_5820 );
-1
gap> homalg_variable_5821 := SI_\[(homalg_variable_5812,3,3);;
gap> SI_deg( homalg_variable_5821 );
1
gap> homalg_variable_5822 := SI_\[(homalg_variable_5812,1,4);;
gap> SI_deg( homalg_variable_5822 );
-1
gap> homalg_variable_5823 := SI_\[(homalg_variable_5812,2,4);;
gap> SI_deg( homalg_variable_5823 );
1
gap> homalg_variable_5824 := SI_\[(homalg_variable_5812,3,4);;
gap> SI_deg( homalg_variable_5824 );
2
gap> homalg_variable_5825 := SIH_Submatrix(homalg_variable_3775,[1..4],[ 1 ]);;
gap> homalg_variable_5826 := homalg_variable_5810 * (homalg_variable_8);;
gap> homalg_variable_5827 := homalg_variable_5825 * homalg_variable_5826;;
gap> homalg_variable_5828 := SIH_Submatrix(homalg_variable_3775,[1..4],[ 2, 3, 4, 5 ]);;
gap> homalg_variable_5829 := homalg_variable_5827 + homalg_variable_5828;;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_5829);; homalg_variable_5830 := homalg_variable_l[1];; homalg_variable_5831 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_5830);
3
gap> homalg_variable_5832 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5830 = homalg_variable_5832;
false
gap> SI_ncols(homalg_variable_5831);
4
gap> homalg_variable_5833 := homalg_variable_5831 * homalg_variable_5829;;
gap> homalg_variable_5830 = homalg_variable_5833;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_5812,homalg_variable_5830);; homalg_variable_5834 := homalg_variable_l[1];; homalg_variable_5835 := homalg_variable_l[2];;
gap> homalg_variable_5836 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5834 = homalg_variable_5836;
true
gap> homalg_variable_5837 := homalg_variable_5835 * homalg_variable_5830;;
gap> homalg_variable_5838 := homalg_variable_5812 + homalg_variable_5837;;
gap> homalg_variable_5834 = homalg_variable_5838;
true
gap> homalg_variable_5839 := SIH_DecideZeroRows(homalg_variable_5812,homalg_variable_5830);;
gap> homalg_variable_5840 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5839 = homalg_variable_5840;
true
gap> homalg_variable_5841 := homalg_variable_5835 * (homalg_variable_8);;
gap> homalg_variable_5842 := homalg_variable_5841 * homalg_variable_5831;;
gap> homalg_variable_5843 := homalg_variable_5842 * homalg_variable_5829;;
gap> homalg_variable_5843 = homalg_variable_5812;
true
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_5812);; homalg_variable_5844 := homalg_variable_l[1];; homalg_variable_5845 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_5844);
3
gap> homalg_variable_5846 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5844 = homalg_variable_5846;
false
gap> SI_ncols(homalg_variable_5845);
3
gap> homalg_variable_5847 := homalg_variable_5845 * homalg_variable_5812;;
gap> homalg_variable_5844 = homalg_variable_5847;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_5829,homalg_variable_5844);; homalg_variable_5848 := homalg_variable_l[1];; homalg_variable_5849 := homalg_variable_l[2];;
gap> homalg_variable_5850 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_5848 = homalg_variable_5850;
true
gap> homalg_variable_5851 := homalg_variable_5849 * homalg_variable_5844;;
gap> homalg_variable_5852 := homalg_variable_5829 + homalg_variable_5851;;
gap> homalg_variable_5848 = homalg_variable_5852;
true
gap> homalg_variable_5853 := SIH_DecideZeroRows(homalg_variable_5829,homalg_variable_5844);;
gap> homalg_variable_5854 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_5853 = homalg_variable_5854;
true
gap> homalg_variable_5855 := homalg_variable_5849 * (homalg_variable_8);;
gap> homalg_variable_5856 := homalg_variable_5855 * homalg_variable_5845;;
gap> homalg_variable_5857 := homalg_variable_5856 * homalg_variable_5812;;
gap> homalg_variable_5857 = homalg_variable_5829;
true
gap> homalg_variable_5858 := homalg_variable_5808 * (homalg_variable_8);;
gap> homalg_variable_5859 := SIH_Submatrix(homalg_variable_3775,[ 1 ],[1..5]);;
gap> homalg_variable_5860 := homalg_variable_5858 * homalg_variable_5859;;
gap> homalg_variable_5861 := SIH_Submatrix(homalg_variable_3775,[ 2, 3, 4 ],[1..5]);;
gap> homalg_variable_5862 := homalg_variable_5860 + homalg_variable_5861;;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5862);; homalg_variable_5863 := homalg_variable_l[1];; homalg_variable_5864 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5863);
4
gap> homalg_variable_5865 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5863 = homalg_variable_5865;
false
gap> SI_nrows(homalg_variable_5864);
5
gap> homalg_variable_5866 := homalg_variable_5862 * homalg_variable_5864;;
gap> homalg_variable_5863 = homalg_variable_5866;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5812,homalg_variable_5863);; homalg_variable_5867 := homalg_variable_l[1];; homalg_variable_5868 := homalg_variable_l[2];;
gap> homalg_variable_5869 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5867 = homalg_variable_5869;
true
gap> homalg_variable_5870 := homalg_variable_5863 * homalg_variable_5868;;
gap> homalg_variable_5871 := homalg_variable_5812 + homalg_variable_5870;;
gap> homalg_variable_5867 = homalg_variable_5871;
true
gap> homalg_variable_5872 := SIH_DecideZeroColumns(homalg_variable_5812,homalg_variable_5863);;
gap> homalg_variable_5873 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5872 = homalg_variable_5873;
true
gap> homalg_variable_5874 := homalg_variable_5868 * (homalg_variable_8);;
gap> homalg_variable_5875 := homalg_variable_5864 * homalg_variable_5874;;
gap> homalg_variable_5876 := homalg_variable_5862 * homalg_variable_5875;;
gap> homalg_variable_5876 = homalg_variable_5812;
true
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5812);; homalg_variable_5877 := homalg_variable_l[1];; homalg_variable_5878 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5877);
4
gap> homalg_variable_5879 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5877 = homalg_variable_5879;
false
gap> SI_nrows(homalg_variable_5878);
4
gap> homalg_variable_5880 := homalg_variable_5812 * homalg_variable_5878;;
gap> homalg_variable_5877 = homalg_variable_5880;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5862,homalg_variable_5877);; homalg_variable_5881 := homalg_variable_l[1];; homalg_variable_5882 := homalg_variable_l[2];;
gap> homalg_variable_5883 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_5881 = homalg_variable_5883;
true
gap> homalg_variable_5884 := homalg_variable_5877 * homalg_variable_5882;;
gap> homalg_variable_5885 := homalg_variable_5862 + homalg_variable_5884;;
gap> homalg_variable_5881 = homalg_variable_5885;
true
gap> homalg_variable_5886 := SIH_DecideZeroColumns(homalg_variable_5862,homalg_variable_5877);;
gap> homalg_variable_5887 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_5886 = homalg_variable_5887;
true
gap> homalg_variable_5888 := homalg_variable_5882 * (homalg_variable_8);;
gap> homalg_variable_5889 := homalg_variable_5878 * homalg_variable_5888;;
gap> homalg_variable_5890 := homalg_variable_5812 * homalg_variable_5889;;
gap> homalg_variable_5890 = homalg_variable_5862;
true
gap> homalg_variable_5891 := SIH_BasisOfRowModule(homalg_variable_3775);;
gap> SI_nrows(homalg_variable_5891);
4
gap> homalg_variable_5892 := SI_matrix(homalg_variable_5,4,5,"0");;
gap> homalg_variable_5891 = homalg_variable_5892;
false
gap> homalg_variable_5894 := SIH_Submatrix(homalg_variable_42,[ 2, 3, 4, 5 ],[1..5]);;
gap> homalg_variable_5895 := homalg_variable_5812 * homalg_variable_5894;;
gap> homalg_variable_5893 := SIH_DecideZeroRows(homalg_variable_5895,homalg_variable_5891);;
gap> homalg_variable_5896 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_5893 = homalg_variable_5896;
true
gap> homalg_variable_5898 := SIH_Submatrix(homalg_variable_918,[1..4],[ 2, 3, 4 ]);;
gap> homalg_variable_5899 := homalg_variable_5898 * homalg_variable_5812;;
gap> homalg_variable_5897 := SIH_DecideZeroColumns(homalg_variable_5899,homalg_variable_3775);;
gap> homalg_variable_5900 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_5897 = homalg_variable_5900;
true
gap> homalg_variable_5877 = homalg_variable_5812;
true
gap> homalg_variable_5901 := SIH_DecideZeroColumns(homalg_variable_1367,homalg_variable_5877);;
gap> homalg_variable_5902 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_5901 = homalg_variable_5902;
false
gap> SIH_ZeroColumns(homalg_variable_5901);
[  ]
gap> homalg_variable_5903 := SIH_BasisOfRowModule(homalg_variable_5877);;
gap> SI_nrows(homalg_variable_5903);
3
gap> homalg_variable_5904 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5903 = homalg_variable_5904;
false
gap> homalg_variable_5905 := SIH_DecideZeroRows(homalg_variable_5877,homalg_variable_5903);;
gap> homalg_variable_5906 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_5905 = homalg_variable_5906;
true
gap> homalg_variable_5908 := homalg_variable_2910 * homalg_variable_3264;;
gap> homalg_variable_5909 := SIH_UnionOfColumns(homalg_variable_2905,homalg_variable_5908);;
gap> homalg_variable_5907 := SIH_BasisOfColumnModule(homalg_variable_5909);;
gap> SI_ncols(homalg_variable_5907);
7
gap> homalg_variable_5910 := SI_matrix(homalg_variable_5,10,7,"0");;
gap> homalg_variable_5907 = homalg_variable_5910;
false
gap> homalg_variable_5912 := homalg_variable_2910 * homalg_variable_3495;;
gap> homalg_variable_5913 := SIH_Submatrix(homalg_variable_3734,[1..2],[ 2, 3, 4 ]);;
gap> homalg_variable_5914 := homalg_variable_5912 * homalg_variable_5913;;
gap> homalg_variable_5911 := SIH_DecideZeroColumns(homalg_variable_5914,homalg_variable_5907);;
gap> homalg_variable_5915 := SI_matrix(homalg_variable_5,10,3,"0");;
gap> homalg_variable_5911 = homalg_variable_5915;
false
gap> homalg_variable_5916 := SI_matrix(homalg_variable_5,10,3,"0");;
gap> homalg_variable_5914 = homalg_variable_5916;
false
gap> homalg_variable_5911 = homalg_variable_5914;
true
gap> homalg_variable_5917 := SI_\[(homalg_variable_3975,1,1);;
gap> SI_deg( homalg_variable_5917 );
-1
gap> homalg_variable_5918 := SI_\[(homalg_variable_3975,2,1);;
gap> SI_deg( homalg_variable_5918 );
-1
gap> homalg_variable_5919 := SI_\[(homalg_variable_3975,3,1);;
gap> SI_deg( homalg_variable_5919 );
1
gap> homalg_variable_5920 := SI_\[(homalg_variable_3975,4,1);;
gap> SI_deg( homalg_variable_5920 );
1
gap> homalg_variable_5921 := SI_\[(homalg_variable_3975,5,1);;
gap> SI_deg( homalg_variable_5921 );
-1
gap> homalg_variable_5922 := SI_\[(homalg_variable_3975,1,2);;
gap> SI_deg( homalg_variable_5922 );
-1
gap> homalg_variable_5923 := SI_\[(homalg_variable_3975,2,2);;
gap> SI_deg( homalg_variable_5923 );
-1
gap> homalg_variable_5924 := SI_\[(homalg_variable_3975,3,2);;
gap> SI_deg( homalg_variable_5924 );
-1
gap> homalg_variable_5925 := SI_\[(homalg_variable_3975,4,2);;
gap> SI_deg( homalg_variable_5925 );
1
gap> homalg_variable_5926 := SI_\[(homalg_variable_3975,5,2);;
gap> SI_deg( homalg_variable_5926 );
1
gap> homalg_variable_5927 := SI_\[(homalg_variable_3975,1,3);;
gap> SI_deg( homalg_variable_5927 );
-1
gap> homalg_variable_5928 := SI_\[(homalg_variable_3975,2,3);;
gap> SI_deg( homalg_variable_5928 );
-1
gap> homalg_variable_5929 := SI_\[(homalg_variable_3975,3,3);;
gap> SI_deg( homalg_variable_5929 );
1
gap> homalg_variable_5930 := SI_\[(homalg_variable_3975,4,3);;
gap> SI_deg( homalg_variable_5930 );
-1
gap> homalg_variable_5931 := SI_\[(homalg_variable_3975,5,3);;
gap> SI_deg( homalg_variable_5931 );
1
gap> homalg_variable_5932 := SI_\[(homalg_variable_3975,1,4);;
gap> SI_deg( homalg_variable_5932 );
1
gap> homalg_variable_5933 := SI_\[(homalg_variable_3975,2,4);;
gap> SI_deg( homalg_variable_5933 );
-1
gap> homalg_variable_5934 := SI_\[(homalg_variable_3975,3,4);;
gap> SI_deg( homalg_variable_5934 );
0
gap> homalg_variable_5935 := SI_\[(homalg_variable_3975,3,4);;
gap> SI_deg( homalg_variable_5935 );
0
gap> IsZero(homalg_variable_5935);
false
gap> IsOne(homalg_variable_5935);
false
gap> String( homalg_variable_7 );
"1"
gap> homalg_variable_5936 := SI_transpose( SI_matrix(homalg_variable_5,1,1,"1") );;
gap> String( homalg_variable_5935 );
"-1"
gap> homalg_variable_5937 := SI_transpose( SI_matrix(homalg_variable_5,1,1,"-1") );;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5937);; homalg_variable_5938 := homalg_variable_l[1];; homalg_variable_5939 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_5938);
1
gap> homalg_variable_5940 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_5938 = homalg_variable_5940;
false
gap> SI_nrows(homalg_variable_5939);
1
gap> homalg_variable_5941 := homalg_variable_5937 * homalg_variable_5939;;
gap> homalg_variable_5938 = homalg_variable_5941;
true
gap> homalg_variable_5938 = homalg_variable_237;
true
gap> homalg_variable_5942 := homalg_variable_5939 * homalg_variable_5936;;
gap> homalg_variable_5943 := homalg_variable_5937 * homalg_variable_5942;;
gap> homalg_variable_5943 = homalg_variable_5936;
true
gap> homalg_variable_5944 := SI_\[(homalg_variable_5942,1,1);;
gap> String( homalg_variable_5944 );
"-1"
gap> homalg_variable_5945 := SI_transpose( SI_matrix(homalg_variable_5,1,1,"-1") );;
gap> homalg_variable_5946 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_5945 = homalg_variable_5946;
false
gap> homalg_variable_5947 := SIH_Submatrix(homalg_variable_3975,[1..5],[ 1, 2, 3 ]);;
gap> homalg_variable_5948 := SIH_Submatrix(homalg_variable_5947,[ 1, 2, 4, 5 ],[1..3]);;
gap> homalg_variable_5949 := SIH_Submatrix(homalg_variable_3975,[1..5],[ 4 ]);;
gap> homalg_variable_5950 := SIH_Submatrix(homalg_variable_5949,[ 1, 2, 4, 5 ],[1..1]);;
gap> homalg_variable_5951 := homalg_variable_5950 * homalg_variable_5945;;
gap> homalg_variable_5952 := SIH_Submatrix(homalg_variable_3975,[ 3 ],[1..4]);;
gap> homalg_variable_5953 := SIH_Submatrix(homalg_variable_5952,[1..1],[ 1, 2, 3 ]);;
gap> homalg_variable_5954 := homalg_variable_5951 * homalg_variable_5953;;
gap> homalg_variable_5955 := homalg_variable_5948 - homalg_variable_5954;;
gap> homalg_variable_5956 := SI_\[(homalg_variable_5955,1,1);;
gap> SI_deg( homalg_variable_5956 );
2
gap> homalg_variable_5957 := SI_\[(homalg_variable_5955,2,1);;
gap> SI_deg( homalg_variable_5957 );
-1
gap> homalg_variable_5958 := SI_\[(homalg_variable_5955,3,1);;
gap> SI_deg( homalg_variable_5958 );
1
gap> homalg_variable_5959 := SI_\[(homalg_variable_5955,4,1);;
gap> SI_deg( homalg_variable_5959 );
-1
gap> homalg_variable_5960 := SI_\[(homalg_variable_5955,1,2);;
gap> SI_deg( homalg_variable_5960 );
-1
gap> homalg_variable_5961 := SI_\[(homalg_variable_5955,2,2);;
gap> SI_deg( homalg_variable_5961 );
-1
gap> homalg_variable_5962 := SI_\[(homalg_variable_5955,3,2);;
gap> SI_deg( homalg_variable_5962 );
1
gap> homalg_variable_5963 := SI_\[(homalg_variable_5955,4,2);;
gap> SI_deg( homalg_variable_5963 );
1
gap> homalg_variable_5964 := SI_\[(homalg_variable_5955,1,3);;
gap> SI_deg( homalg_variable_5964 );
2
gap> homalg_variable_5965 := SI_\[(homalg_variable_5955,2,3);;
gap> SI_deg( homalg_variable_5965 );
-1
gap> homalg_variable_5966 := SI_\[(homalg_variable_5955,3,3);;
gap> SI_deg( homalg_variable_5966 );
-1
gap> homalg_variable_5967 := SI_\[(homalg_variable_5955,4,3);;
gap> SI_deg( homalg_variable_5967 );
1
gap> homalg_variable_5968 := SIH_Submatrix(homalg_variable_3975,[1..5],[ 1, 2, 3 ]);;
gap> homalg_variable_5969 := SIH_Submatrix(homalg_variable_3975,[1..5],[ 4 ]);;
gap> homalg_variable_5970 := homalg_variable_5945 * homalg_variable_5953;;
gap> homalg_variable_5971 := homalg_variable_5970 * (homalg_variable_8);;
gap> homalg_variable_5972 := homalg_variable_5969 * homalg_variable_5971;;
gap> homalg_variable_5973 := homalg_variable_5968 + homalg_variable_5972;;
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_5973);; homalg_variable_5974 := homalg_variable_l[1];; homalg_variable_5975 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_5974);
4
gap> homalg_variable_5976 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_5974 = homalg_variable_5976;
false
gap> SI_ncols(homalg_variable_5975);
5
gap> homalg_variable_5977 := homalg_variable_5975 * homalg_variable_5973;;
gap> homalg_variable_5974 = homalg_variable_5977;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_5955,homalg_variable_5974);; homalg_variable_5978 := homalg_variable_l[1];; homalg_variable_5979 := homalg_variable_l[2];;
gap> homalg_variable_5980 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_5978 = homalg_variable_5980;
true
gap> homalg_variable_5981 := homalg_variable_5979 * homalg_variable_5974;;
gap> homalg_variable_5982 := homalg_variable_5955 + homalg_variable_5981;;
gap> homalg_variable_5978 = homalg_variable_5982;
true
gap> homalg_variable_5983 := SIH_DecideZeroRows(homalg_variable_5955,homalg_variable_5974);;
gap> homalg_variable_5984 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_5983 = homalg_variable_5984;
true
gap> homalg_variable_5985 := homalg_variable_5979 * (homalg_variable_8);;
gap> homalg_variable_5986 := homalg_variable_5985 * homalg_variable_5975;;
gap> homalg_variable_5987 := homalg_variable_5986 * homalg_variable_5973;;
gap> homalg_variable_5987 = homalg_variable_5955;
true
gap> homalg_variable_l := SIH_BasisOfRowsCoeff(homalg_variable_5955);; homalg_variable_5988 := homalg_variable_l[1];; homalg_variable_5989 := homalg_variable_l[2];;
gap> SI_nrows(homalg_variable_5988);
4
gap> homalg_variable_5990 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_5988 = homalg_variable_5990;
false
gap> SI_ncols(homalg_variable_5989);
4
gap> homalg_variable_5991 := homalg_variable_5989 * homalg_variable_5955;;
gap> homalg_variable_5988 = homalg_variable_5991;
true
gap> homalg_variable_l := SIH_DecideZeroRowsEffectively(homalg_variable_5973,homalg_variable_5988);; homalg_variable_5992 := homalg_variable_l[1];; homalg_variable_5993 := homalg_variable_l[2];;
gap> homalg_variable_5994 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_5992 = homalg_variable_5994;
true
gap> homalg_variable_5995 := homalg_variable_5993 * homalg_variable_5988;;
gap> homalg_variable_5996 := homalg_variable_5973 + homalg_variable_5995;;
gap> homalg_variable_5992 = homalg_variable_5996;
true
gap> homalg_variable_5997 := SIH_DecideZeroRows(homalg_variable_5973,homalg_variable_5988);;
gap> homalg_variable_5998 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_5997 = homalg_variable_5998;
true
gap> homalg_variable_5999 := homalg_variable_5993 * (homalg_variable_8);;
gap> homalg_variable_6000 := homalg_variable_5999 * homalg_variable_5989;;
gap> for _del in [ "homalg_variable_5478", "homalg_variable_5479", "homalg_variable_5480", "homalg_variable_5481", "homalg_variable_5482", "homalg_variable_5483", "homalg_variable_5484", "homalg_variable_5485", "homalg_variable_5486", "homalg_variable_5487", "homalg_variable_5488", "homalg_variable_5489", "homalg_variable_5490", "homalg_variable_5491", "homalg_variable_5492", "homalg_variable_5493", "homalg_variable_5494", "homalg_variable_5495", "homalg_variable_5496", "homalg_variable_5497", "homalg_variable_5498", "homalg_variable_5499", "homalg_variable_5500", "homalg_variable_5501", "homalg_variable_5502", "homalg_variable_5503", "homalg_variable_5504", "homalg_variable_5505", "homalg_variable_5506", "homalg_variable_5507", "homalg_variable_5508", "homalg_variable_5509", "homalg_variable_5510", "homalg_variable_5511", "homalg_variable_5512", "homalg_variable_5513", "homalg_variable_5516", "homalg_variable_5517", "homalg_variable_5518", "homalg_variable_5519", "homalg_variable_5520", "homalg_variable_5521", "homalg_variable_5522", "homalg_variable_5523", "homalg_variable_5524", "homalg_variable_5525", "homalg_variable_5526", "homalg_variable_5527", "homalg_variable_5528", "homalg_variable_5529", "homalg_variable_5530", "homalg_variable_5531", "homalg_variable_5532", "homalg_variable_5533", "homalg_variable_5534", "homalg_variable_5535", "homalg_variable_5536", "homalg_variable_5537", "homalg_variable_5538", "homalg_variable_5539", "homalg_variable_5540", "homalg_variable_5541", "homalg_variable_5542", "homalg_variable_5543", "homalg_variable_5544", "homalg_variable_5545", "homalg_variable_5546", "homalg_variable_5547", "homalg_variable_5548", "homalg_variable_5549", "homalg_variable_5550", "homalg_variable_5551", "homalg_variable_5552", "homalg_variable_5553", "homalg_variable_5554", "homalg_variable_5555", "homalg_variable_5557", "homalg_variable_5560", "homalg_variable_5561", "homalg_variable_5562", "homalg_variable_5563", "homalg_variable_5564", "homalg_variable_5566", "homalg_variable_5567", "homalg_variable_5568", "homalg_variable_5569", "homalg_variable_5570", "homalg_variable_5571", "homalg_variable_5572", "homalg_variable_5573", "homalg_variable_5574", "homalg_variable_5575", "homalg_variable_5576", "homalg_variable_5577", "homalg_variable_5578", "homalg_variable_5581", "homalg_variable_5582", "homalg_variable_5583", "homalg_variable_5585", "homalg_variable_5587", "homalg_variable_5588", "homalg_variable_5589", "homalg_variable_5590", "homalg_variable_5591", "homalg_variable_5592", "homalg_variable_5593", "homalg_variable_5594", "homalg_variable_5595", "homalg_variable_5596", "homalg_variable_5597", "homalg_variable_5598", "homalg_variable_5599", "homalg_variable_5600", "homalg_variable_5601", "homalg_variable_5602", "homalg_variable_5603", "homalg_variable_5604", "homalg_variable_5605", "homalg_variable_5606", "homalg_variable_5607", "homalg_variable_5608", "homalg_variable_5609", "homalg_variable_5610", "homalg_variable_5611", "homalg_variable_5613", "homalg_variable_5616", "homalg_variable_5617", "homalg_variable_5618", "homalg_variable_5619", "homalg_variable_5620", "homalg_variable_5621", "homalg_variable_5622", "homalg_variable_5623", "homalg_variable_5624", "homalg_variable_5625", "homalg_variable_5626", "homalg_variable_5627", "homalg_variable_5630", "homalg_variable_5631", "homalg_variable_5632", "homalg_variable_5633", "homalg_variable_5634", "homalg_variable_5637", "homalg_variable_5638", "homalg_variable_5642", "homalg_variable_5643", "homalg_variable_5644", "homalg_variable_5645", "homalg_variable_5647", "homalg_variable_5648", "homalg_variable_5650", "homalg_variable_5652", "homalg_variable_5653", "homalg_variable_5654", "homalg_variable_5656", "homalg_variable_5660", "homalg_variable_5663", "homalg_variable_5664", "homalg_variable_5665", "homalg_variable_5666", "homalg_variable_5667", "homalg_variable_5670", "homalg_variable_5671", "homalg_variable_5672", "homalg_variable_5673", "homalg_variable_5674", "homalg_variable_5675", "homalg_variable_5676", "homalg_variable_5677", "homalg_variable_5678", "homalg_variable_5679", "homalg_variable_5685", "homalg_variable_5686", "homalg_variable_5687", "homalg_variable_5688", "homalg_variable_5690", "homalg_variable_5691", "homalg_variable_5693", "homalg_variable_5695", "homalg_variable_5696", "homalg_variable_5697", "homalg_variable_5698", "homalg_variable_5699", "homalg_variable_5700", "homalg_variable_5702", "homalg_variable_5705", "homalg_variable_5706", "homalg_variable_5707", "homalg_variable_5708", "homalg_variable_5709", "homalg_variable_5710", "homalg_variable_5711", "homalg_variable_5712", "homalg_variable_5713", "homalg_variable_5714", "homalg_variable_5715", "homalg_variable_5716", "homalg_variable_5720", "homalg_variable_5721", "homalg_variable_5722", "homalg_variable_5723", "homalg_variable_5725", "homalg_variable_5726", "homalg_variable_5727", "homalg_variable_5731", "homalg_variable_5733", "homalg_variable_5734", "homalg_variable_5736", "homalg_variable_5737", "homalg_variable_5739", "homalg_variable_5741", "homalg_variable_5742", "homalg_variable_5743", "homalg_variable_5744", "homalg_variable_5745", "homalg_variable_5747", "homalg_variable_5750", "homalg_variable_5751", "homalg_variable_5754", "homalg_variable_5757", "homalg_variable_5758", "homalg_variable_5761", "homalg_variable_5762", "homalg_variable_5763", "homalg_variable_5764", "homalg_variable_5765", "homalg_variable_5766", "homalg_variable_5767", "homalg_variable_5768", "homalg_variable_5769", "homalg_variable_5770", "homalg_variable_5771", "homalg_variable_5772", "homalg_variable_5775", "homalg_variable_5776", "homalg_variable_5777", "homalg_variable_5778", "homalg_variable_5779", "homalg_variable_5780", "homalg_variable_5782", "homalg_variable_5783", "homalg_variable_5784", "homalg_variable_5785", "homalg_variable_5786", "homalg_variable_5787", "homalg_variable_5788", "homalg_variable_5789", "homalg_variable_5792", "homalg_variable_5793", "homalg_variable_5794", "homalg_variable_5798", "homalg_variable_5799", "homalg_variable_5801", "homalg_variable_5802", "homalg_variable_5803", "homalg_variable_5804", "homalg_variable_5813", "homalg_variable_5814", "homalg_variable_5815", "homalg_variable_5816", "homalg_variable_5818", "homalg_variable_5819", "homalg_variable_5820", "homalg_variable_5821", "homalg_variable_5822", "homalg_variable_5823", "homalg_variable_5824", "homalg_variable_5832", "homalg_variable_5833", "homalg_variable_5834", "homalg_variable_5835", "homalg_variable_5836", "homalg_variable_5837", "homalg_variable_5838", "homalg_variable_5839", "homalg_variable_5840", "homalg_variable_5841", "homalg_variable_5842", "homalg_variable_5843", "homalg_variable_5846", "homalg_variable_5847", "homalg_variable_5850", "homalg_variable_5851", "homalg_variable_5852", "homalg_variable_5853", "homalg_variable_5854", "homalg_variable_5857", "homalg_variable_5865", "homalg_variable_5866", "homalg_variable_5869", "homalg_variable_5870", "homalg_variable_5871", "homalg_variable_5876", "homalg_variable_5879", "homalg_variable_5880", "homalg_variable_5881", "homalg_variable_5882", "homalg_variable_5883", "homalg_variable_5884", "homalg_variable_5885", "homalg_variable_5886", "homalg_variable_5887", "homalg_variable_5888", "homalg_variable_5889", "homalg_variable_5890", "homalg_variable_5892", "homalg_variable_5897", "homalg_variable_5899", "homalg_variable_5900", "homalg_variable_5901", "homalg_variable_5902", "homalg_variable_5904", "homalg_variable_5905", "homalg_variable_5906", "homalg_variable_5910", "homalg_variable_5915", "homalg_variable_5916", "homalg_variable_5917", "homalg_variable_5918", "homalg_variable_5919", "homalg_variable_5920", "homalg_variable_5921", "homalg_variable_5922", "homalg_variable_5923", "homalg_variable_5924", "homalg_variable_5925", "homalg_variable_5926", "homalg_variable_5927", "homalg_variable_5928", "homalg_variable_5929", "homalg_variable_5930", "homalg_variable_5931", "homalg_variable_5932", "homalg_variable_5933", "homalg_variable_5934", "homalg_variable_5940", "homalg_variable_5941", "homalg_variable_5943", "homalg_variable_5946", "homalg_variable_5956", "homalg_variable_5957", "homalg_variable_5958", "homalg_variable_5959", "homalg_variable_5960", "homalg_variable_5961", "homalg_variable_5962", "homalg_variable_5963", "homalg_variable_5964", "homalg_variable_5965", "homalg_variable_5966", "homalg_variable_5967", "homalg_variable_5976", "homalg_variable_5977", "homalg_variable_5980", "homalg_variable_5981", "homalg_variable_5982", "homalg_variable_5983", "homalg_variable_5984", "homalg_variable_5987", "homalg_variable_5990", "homalg_variable_5991", "homalg_variable_5994", "homalg_variable_5995", "homalg_variable_5996", "homalg_variable_5998" ] do UnbindGlobal( _del );; od;;
gap> homalg_variable_6001 := homalg_variable_6000 * homalg_variable_5955;;
gap> homalg_variable_6001 = homalg_variable_5973;
true
gap> homalg_variable_6002 := SIH_Submatrix(homalg_variable_918,[1..4],[ 1, 2 ]);;
gap> homalg_variable_6003 := SIH_Submatrix(homalg_variable_3975,[ 1, 2 ],[1..4]);;
gap> homalg_variable_6004 := homalg_variable_6002 * homalg_variable_6003;;
gap> homalg_variable_6005 := homalg_variable_5951 * (homalg_variable_8);;
gap> homalg_variable_6006 := SIH_Submatrix(homalg_variable_3975,[ 3 ],[1..4]);;
gap> homalg_variable_6007 := homalg_variable_6005 * homalg_variable_6006;;
gap> homalg_variable_6008 := homalg_variable_6004 + homalg_variable_6007;;
gap> homalg_variable_6009 := SIH_Submatrix(homalg_variable_918,[1..4],[ 3, 4 ]);;
gap> homalg_variable_6010 := SIH_Submatrix(homalg_variable_3975,[ 4, 5 ],[1..4]);;
gap> homalg_variable_6011 := homalg_variable_6009 * homalg_variable_6010;;
gap> homalg_variable_6012 := homalg_variable_6008 + homalg_variable_6011;;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6012);; homalg_variable_6013 := homalg_variable_l[1];; homalg_variable_6014 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6013);
3
gap> homalg_variable_6015 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_6013 = homalg_variable_6015;
false
gap> SI_nrows(homalg_variable_6014);
4
gap> homalg_variable_6016 := homalg_variable_6012 * homalg_variable_6014;;
gap> homalg_variable_6013 = homalg_variable_6016;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_5955,homalg_variable_6013);; homalg_variable_6017 := homalg_variable_l[1];; homalg_variable_6018 := homalg_variable_l[2];;
gap> homalg_variable_6019 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_6017 = homalg_variable_6019;
true
gap> homalg_variable_6020 := homalg_variable_6013 * homalg_variable_6018;;
gap> homalg_variable_6021 := homalg_variable_5955 + homalg_variable_6020;;
gap> homalg_variable_6017 = homalg_variable_6021;
true
gap> homalg_variable_6022 := SIH_DecideZeroColumns(homalg_variable_5955,homalg_variable_6013);;
gap> homalg_variable_6023 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_6022 = homalg_variable_6023;
true
gap> homalg_variable_6024 := homalg_variable_6018 * (homalg_variable_8);;
gap> homalg_variable_6025 := homalg_variable_6014 * homalg_variable_6024;;
gap> homalg_variable_6026 := homalg_variable_6012 * homalg_variable_6025;;
gap> homalg_variable_6026 = homalg_variable_5955;
true
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_5955);; homalg_variable_6027 := homalg_variable_l[1];; homalg_variable_6028 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6027);
3
gap> homalg_variable_6029 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_6027 = homalg_variable_6029;
false
gap> SI_nrows(homalg_variable_6028);
3
gap> homalg_variable_6030 := homalg_variable_5955 * homalg_variable_6028;;
gap> homalg_variable_6027 = homalg_variable_6030;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6012,homalg_variable_6027);; homalg_variable_6031 := homalg_variable_l[1];; homalg_variable_6032 := homalg_variable_l[2];;
gap> homalg_variable_6033 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_6031 = homalg_variable_6033;
true
gap> homalg_variable_6034 := homalg_variable_6027 * homalg_variable_6032;;
gap> homalg_variable_6035 := homalg_variable_6012 + homalg_variable_6034;;
gap> homalg_variable_6031 = homalg_variable_6035;
true
gap> homalg_variable_6036 := SIH_DecideZeroColumns(homalg_variable_6012,homalg_variable_6027);;
gap> homalg_variable_6037 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_6036 = homalg_variable_6037;
true
gap> homalg_variable_6038 := homalg_variable_6032 * (homalg_variable_8);;
gap> homalg_variable_6039 := homalg_variable_6028 * homalg_variable_6038;;
gap> homalg_variable_6040 := homalg_variable_5955 * homalg_variable_6039;;
gap> homalg_variable_6040 = homalg_variable_6012;
true
gap> homalg_variable_6041 := SIH_BasisOfRowModule(homalg_variable_3975);;
gap> SI_nrows(homalg_variable_6041);
5
gap> homalg_variable_6042 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_6041 = homalg_variable_6042;
false
gap> homalg_variable_6044 := SIH_Submatrix(homalg_variable_918,[ 1, 2, 3 ],[1..4]);;
gap> homalg_variable_6045 := homalg_variable_5955 * homalg_variable_6044;;
gap> homalg_variable_6043 := SIH_DecideZeroRows(homalg_variable_6045,homalg_variable_6041);;
gap> homalg_variable_6046 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_6043 = homalg_variable_6046;
true
gap> homalg_variable_6048 := SIH_Submatrix(homalg_variable_42,[1..5],[ 1, 2, 4, 5 ]);;
gap> homalg_variable_6049 := homalg_variable_6048 * homalg_variable_5955;;
gap> homalg_variable_6047 := SIH_DecideZeroColumns(homalg_variable_6049,homalg_variable_3975);;
gap> homalg_variable_6050 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_6047 = homalg_variable_6050;
true
gap> homalg_variable_6027 = homalg_variable_5955;
false
gap> homalg_variable_6051 := SIH_DecideZeroColumns(homalg_variable_918,homalg_variable_6027);;
gap> homalg_variable_6052 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_6051 = homalg_variable_6052;
false
gap> SIH_ZeroColumns(homalg_variable_6051);
[  ]
gap> homalg_variable_6053 := SIH_DecideZeroRows(homalg_variable_5955,homalg_variable_5988);;
gap> homalg_variable_6054 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_6053 = homalg_variable_6054;
true
gap> homalg_variable_6055 := SIH_DecideZeroColumns(homalg_variable_5955,homalg_variable_6027);;
gap> homalg_variable_6056 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_6055 = homalg_variable_6056;
true
gap> homalg_variable_6057 := SIH_DecideZeroColumns(homalg_variable_918,homalg_variable_6027);;
gap> homalg_variable_6058 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_6057 = homalg_variable_6058;
false
gap> SIH_ZeroColumns(homalg_variable_6057);
[  ]
gap> homalg_variable_6059 := SI_\[(homalg_variable_6027,1,1);;
gap> SI_deg( homalg_variable_6059 );
-1
gap> homalg_variable_6060 := SI_\[(homalg_variable_6027,2,1);;
gap> SI_deg( homalg_variable_6060 );
-1
gap> homalg_variable_6061 := SI_\[(homalg_variable_6027,3,1);;
gap> SI_deg( homalg_variable_6061 );
1
gap> homalg_variable_6062 := SI_\[(homalg_variable_6027,4,1);;
gap> SI_deg( homalg_variable_6062 );
1
gap> homalg_variable_6063 := SI_\[(homalg_variable_6027,1,2);;
gap> SI_deg( homalg_variable_6063 );
2
gap> homalg_variable_6064 := SI_\[(homalg_variable_6027,2,2);;
gap> SI_deg( homalg_variable_6064 );
-1
gap> homalg_variable_6065 := SI_\[(homalg_variable_6027,3,2);;
gap> SI_deg( homalg_variable_6065 );
1
gap> homalg_variable_6066 := SI_\[(homalg_variable_6027,4,2);;
gap> SI_deg( homalg_variable_6066 );
-1
gap> homalg_variable_6067 := SI_\[(homalg_variable_6027,1,3);;
gap> SI_deg( homalg_variable_6067 );
2
gap> homalg_variable_6068 := SI_\[(homalg_variable_6027,2,3);;
gap> SI_deg( homalg_variable_6068 );
-1
gap> homalg_variable_6069 := SI_\[(homalg_variable_6027,3,3);;
gap> SI_deg( homalg_variable_6069 );
-1
gap> homalg_variable_6070 := SI_\[(homalg_variable_6027,4,3);;
gap> SI_deg( homalg_variable_6070 );
1
gap> homalg_variable_6071 := SIH_BasisOfRowModule(homalg_variable_6027);;
gap> SI_nrows(homalg_variable_6071);
4
gap> homalg_variable_6072 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_6071 = homalg_variable_6072;
false
gap> homalg_variable_6073 := SIH_DecideZeroRows(homalg_variable_6027,homalg_variable_6071);;
gap> homalg_variable_6074 := SI_matrix(homalg_variable_5,4,3,"0");;
gap> homalg_variable_6073 = homalg_variable_6074;
true
gap> homalg_variable_6075 := SIH_DecideZeroColumns(homalg_variable_918,homalg_variable_6027);;
gap> homalg_variable_6076 := SI_matrix(homalg_variable_5,4,4,"0");;
gap> homalg_variable_6075 = homalg_variable_6076;
false
gap> SIH_ZeroColumns(homalg_variable_6075);
[  ]
gap> homalg_variable_6078 := homalg_variable_3855 * homalg_variable_3779;;
gap> homalg_variable_6079 := SIH_Submatrix(homalg_variable_3935,[1..3],[ 1, 2, 4, 5 ]);;
gap> homalg_variable_6080 := homalg_variable_6078 * homalg_variable_6079;;
gap> homalg_variable_6077 := SIH_DecideZeroColumns(homalg_variable_6080,homalg_variable_2985);;
gap> homalg_variable_6081 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_6077 = homalg_variable_6081;
false
gap> homalg_variable_6082 := SI_matrix(homalg_variable_5,7,4,"0");;
gap> homalg_variable_6080 = homalg_variable_6082;
false
gap> homalg_variable_6077 = homalg_variable_6080;
true
gap> homalg_variable_6083 := SI_\[(homalg_variable_10,1,1);;
gap> SI_deg( homalg_variable_6083 );
2
gap> homalg_variable_6084 := SI_\[(homalg_variable_10,2,1);;
gap> SI_deg( homalg_variable_6084 );
2
gap> homalg_variable_6085 := SI_\[(homalg_variable_10,3,1);;
gap> SI_deg( homalg_variable_6085 );
1
gap> homalg_variable_6086 := SI_\[(homalg_variable_10,4,1);;
gap> SI_deg( homalg_variable_6086 );
-1
gap> homalg_variable_6087 := SI_\[(homalg_variable_10,5,1);;
gap> SI_deg( homalg_variable_6087 );
-1
gap> homalg_variable_6088 := SI_\[(homalg_variable_10,1,2);;
gap> SI_deg( homalg_variable_6088 );
-1
gap> homalg_variable_6089 := SI_\[(homalg_variable_10,2,2);;
gap> SI_deg( homalg_variable_6089 );
-1
gap> homalg_variable_6090 := SI_\[(homalg_variable_10,3,2);;
gap> SI_deg( homalg_variable_6090 );
2
gap> homalg_variable_6091 := SI_\[(homalg_variable_10,4,2);;
gap> SI_deg( homalg_variable_6091 );
2
gap> homalg_variable_6092 := SI_\[(homalg_variable_10,5,2);;
gap> SI_deg( homalg_variable_6092 );
2
gap> homalg_variable_6093 := SI_\[(homalg_variable_10,1,3);;
gap> SI_deg( homalg_variable_6093 );
-1
gap> homalg_variable_6094 := SI_\[(homalg_variable_10,2,3);;
gap> SI_deg( homalg_variable_6094 );
-1
gap> homalg_variable_6095 := SI_\[(homalg_variable_10,3,3);;
gap> SI_deg( homalg_variable_6095 );
3
gap> homalg_variable_6096 := SI_\[(homalg_variable_10,4,3);;
gap> SI_deg( homalg_variable_6096 );
3
gap> homalg_variable_6097 := SI_\[(homalg_variable_10,5,3);;
gap> SI_deg( homalg_variable_6097 );
2
gap> homalg_variable_6098 := SI_\[(homalg_variable_10,1,4);;
gap> SI_deg( homalg_variable_6098 );
-1
gap> homalg_variable_6099 := SI_\[(homalg_variable_10,2,4);;
gap> SI_deg( homalg_variable_6099 );
-1
gap> homalg_variable_6100 := SI_\[(homalg_variable_10,3,4);;
gap> SI_deg( homalg_variable_6100 );
3
gap> homalg_variable_6101 := SI_\[(homalg_variable_10,4,4);;
gap> SI_deg( homalg_variable_6101 );
3
gap> homalg_variable_6102 := SI_\[(homalg_variable_10,5,4);;
gap> SI_deg( homalg_variable_6102 );
2
gap> homalg_variable_6103 := SI_\[(homalg_variable_10,1,5);;
gap> SI_deg( homalg_variable_6103 );
4
gap> homalg_variable_6104 := SI_\[(homalg_variable_10,2,5);;
gap> SI_deg( homalg_variable_6104 );
4
gap> homalg_variable_6105 := SI_\[(homalg_variable_10,3,5);;
gap> SI_deg( homalg_variable_6105 );
-1
gap> homalg_variable_6106 := SI_\[(homalg_variable_10,4,5);;
gap> SI_deg( homalg_variable_6106 );
3
gap> homalg_variable_6107 := SI_\[(homalg_variable_10,5,5);;
gap> SI_deg( homalg_variable_6107 );
2
gap> homalg_variable_6108 := SI_\[(homalg_variable_10,1,6);;
gap> SI_deg( homalg_variable_6108 );
4
gap> homalg_variable_6109 := SI_\[(homalg_variable_10,2,6);;
gap> SI_deg( homalg_variable_6109 );
4
gap> homalg_variable_6110 := SI_\[(homalg_variable_10,3,6);;
gap> SI_deg( homalg_variable_6110 );
-1
gap> homalg_variable_6111 := SI_\[(homalg_variable_10,4,6);;
gap> SI_deg( homalg_variable_6111 );
3
gap> homalg_variable_6112 := SI_\[(homalg_variable_10,5,6);;
gap> SI_deg( homalg_variable_6112 );
2
gap> homalg_variable_6113 := SIH_DecideZeroRows(homalg_variable_10,homalg_variable_305);;
gap> homalg_variable_6114 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_6113 = homalg_variable_6114;
true
gap> homalg_variable_6115 := SIH_DecideZeroColumns(homalg_variable_42,homalg_variable_10);;
gap> homalg_variable_6116 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_6115 = homalg_variable_6116;
false
gap> SIH_ZeroColumns(homalg_variable_6115);
[  ]
gap> homalg_variable_6117 := SIH_DecideZeroColumns(homalg_variable_42,homalg_variable_10);;
gap> homalg_variable_6118 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_6117 = homalg_variable_6118;
false
gap> homalg_variable_6117 = homalg_variable_42;
true
gap> homalg_variable_6119 := SIH_DecideZeroColumns(homalg_variable_5640,homalg_variable_10);;
gap> homalg_variable_6120 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_6119 = homalg_variable_6120;
false
gap> homalg_variable_6121 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_5640 = homalg_variable_6121;
false
gap> homalg_variable_6122 := SIH_DecideZeroColumns(homalg_variable_5646,homalg_variable_10);;
gap> homalg_variable_6123 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_6122 = homalg_variable_6123;
false
gap> homalg_variable_6124 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_5646 = homalg_variable_6124;
false
gap> homalg_variable_6126 := SIH_Submatrix(homalg_variable_5689,[1..5],[ 2, 3, 4 ]);;
gap> homalg_variable_6125 := SIH_DecideZeroColumns(homalg_variable_6126,homalg_variable_10);;
gap> homalg_variable_6127 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_6125 = homalg_variable_6127;
false
gap> homalg_variable_6128 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_6126 = homalg_variable_6128;
false
gap> homalg_variable_6130 := SIH_Submatrix(homalg_variable_5735,[1..5],[ 1, 2, 4, 5 ]);;
gap> homalg_variable_6129 := SIH_DecideZeroColumns(homalg_variable_6130,homalg_variable_10);;
gap> homalg_variable_6131 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_6129 = homalg_variable_6131;
false
gap> homalg_variable_6132 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_6130 = homalg_variable_6132;
false
gap> homalg_variable_3786 = homalg_variable_3779;
true
gap> homalg_variable_6133 := SIH_DecideZeroColumns(homalg_variable_813,homalg_variable_3786);;
gap> homalg_variable_6134 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_6133 = homalg_variable_6134;
false
gap> SIH_ZeroColumns(homalg_variable_6133);
[ 1 ]
gap> homalg_variable_6135 := SIH_Submatrix(homalg_variable_3786,[ 2 ],[1..3]);;
gap> SIH_ZeroColumns(homalg_variable_6135);
[ 1 ]
gap> homalg_variable_6137 := SIH_Submatrix(homalg_variable_3935,[1..3],[ 1, 2, 4, 5 ]);;
gap> homalg_variable_6138 := SIH_UnionOfColumns(homalg_variable_6137,homalg_variable_3813);;
gap> homalg_variable_6136 := SIH_BasisOfColumnModule(homalg_variable_6138);;
gap> SI_ncols(homalg_variable_6136);
5
gap> homalg_variable_6139 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_6136 = homalg_variable_6139;
false
gap> homalg_variable_6136 = homalg_variable_6138;
false
gap> homalg_variable_6140 := SIH_DecideZeroColumns(homalg_variable_1367,homalg_variable_6136);;
gap> homalg_variable_6141 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_6140 = homalg_variable_6141;
false
gap> SIH_ZeroColumns(homalg_variable_6140);
[ 2 ]
gap> homalg_variable_6142 := SIH_Submatrix(homalg_variable_6137,[ 1, 3 ],[1..4]);;
gap> homalg_variable_6143 := SIH_Submatrix(homalg_variable_3813,[ 1, 3 ],[1..1]);;
gap> homalg_variable_6144 := SIH_UnionOfColumns(homalg_variable_6142,homalg_variable_6143);;
gap> SIH_ZeroColumns(homalg_variable_6144);
[ 1 ]
gap> homalg_variable_6145 := SIH_DecideZeroColumns(homalg_variable_6129,homalg_variable_5728);;
gap> homalg_variable_6146 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_6145 = homalg_variable_6146;
false
gap> homalg_variable_6147 := SIH_UnionOfColumns(homalg_variable_6145,homalg_variable_5728);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6147);; homalg_variable_6148 := homalg_variable_l[1];; homalg_variable_6149 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6148);
5
gap> homalg_variable_6150 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_6148 = homalg_variable_6150;
false
gap> SI_nrows(homalg_variable_6149);
8
gap> homalg_variable_6151 := SIH_Submatrix(homalg_variable_6149,[ 1, 2, 3, 4 ],[1..5]);;
gap> homalg_variable_6152 := homalg_variable_6145 * homalg_variable_6151;;
gap> homalg_variable_6153 := SIH_Submatrix(homalg_variable_6149,[ 5, 6, 7, 8 ],[1..5]);;
gap> homalg_variable_6154 := homalg_variable_5728 * homalg_variable_6153;;
gap> homalg_variable_6155 := homalg_variable_6152 + homalg_variable_6154;;
gap> homalg_variable_6148 = homalg_variable_6155;
true
gap> homalg_variable_6156 := SIH_DecideZeroColumns(homalg_variable_42,homalg_variable_5728);;
gap> homalg_variable_6157 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_6156 = homalg_variable_6157;
false
gap> homalg_variable_6148 = homalg_variable_42;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6156,homalg_variable_6148);; homalg_variable_6158 := homalg_variable_l[1];; homalg_variable_6159 := homalg_variable_l[2];;
gap> homalg_variable_6160 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_6158 = homalg_variable_6160;
true
gap> homalg_variable_6161 := homalg_variable_6148 * homalg_variable_6159;;
gap> homalg_variable_6162 := homalg_variable_6156 + homalg_variable_6161;;
gap> homalg_variable_6158 = homalg_variable_6162;
true
gap> homalg_variable_6163 := SIH_DecideZeroColumns(homalg_variable_6156,homalg_variable_6148);;
gap> homalg_variable_6164 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_6163 = homalg_variable_6164;
true
gap> homalg_variable_6166 := SIH_Submatrix(homalg_variable_6149,[ 1, 2, 3, 4 ],[1..5]);;
gap> homalg_variable_6167 := homalg_variable_6159 * (homalg_variable_8);;
gap> homalg_variable_6168 := homalg_variable_6166 * homalg_variable_6167;;
gap> homalg_variable_6169 := homalg_variable_6129 * homalg_variable_6168;;
gap> homalg_variable_6170 := homalg_variable_6169 - homalg_variable_42;;
gap> homalg_variable_6165 := SIH_DecideZeroColumns(homalg_variable_6170,homalg_variable_5728);;
gap> homalg_variable_6171 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_6165 = homalg_variable_6171;
true
gap> homalg_variable_6173 := homalg_variable_6168 * homalg_variable_10;;
gap> homalg_variable_6172 := SIH_DecideZeroColumns(homalg_variable_6173,homalg_variable_6027);;
gap> homalg_variable_6174 := SI_matrix(homalg_variable_5,4,6,"0");;
gap> homalg_variable_6172 = homalg_variable_6174;
true
gap> homalg_variable_6175 := SIH_DecideZeroColumns(homalg_variable_5729,homalg_variable_10);;
gap> homalg_variable_6176 := SI_matrix(homalg_variable_5,5,6,"0");;
gap> homalg_variable_6175 = homalg_variable_6176;
false
gap> SIH_ZeroColumns(homalg_variable_6175);
[  ]
gap> homalg_variable_6177 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_6175,homalg_variable_10);;
gap> SI_ncols(homalg_variable_6177);
10
gap> homalg_variable_6178 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_6177 = homalg_variable_6178;
false
gap> homalg_variable_6180 := homalg_variable_6175 * homalg_variable_6177;;
gap> homalg_variable_6179 := SIH_DecideZeroColumns(homalg_variable_6180,homalg_variable_10);;
gap> homalg_variable_6181 := SI_matrix(homalg_variable_5,5,10,"0");;
gap> homalg_variable_6179 = homalg_variable_6181;
true
gap> homalg_variable_6182 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_6175,homalg_variable_10);;
gap> SI_ncols(homalg_variable_6182);
10
gap> homalg_variable_6183 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_6182 = homalg_variable_6183;
false
gap> homalg_variable_6184 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_6182);;
gap> SI_ncols(homalg_variable_6184);
5
gap> homalg_variable_6185 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_6184 = homalg_variable_6185;
false
gap> homalg_variable_6186 := SI_\[(homalg_variable_6184,10,1);;
gap> SI_deg( homalg_variable_6186 );
-1
gap> homalg_variable_6187 := SI_\[(homalg_variable_6184,9,1);;
gap> SI_deg( homalg_variable_6187 );
-1
gap> homalg_variable_6188 := SI_\[(homalg_variable_6184,8,1);;
gap> SI_deg( homalg_variable_6188 );
-1
gap> homalg_variable_6189 := SI_\[(homalg_variable_6184,7,1);;
gap> SI_deg( homalg_variable_6189 );
-1
gap> homalg_variable_6190 := SI_\[(homalg_variable_6184,6,1);;
gap> SI_deg( homalg_variable_6190 );
1
gap> homalg_variable_6191 := SI_\[(homalg_variable_6184,5,1);;
gap> SI_deg( homalg_variable_6191 );
-1
gap> homalg_variable_6192 := SI_\[(homalg_variable_6184,4,1);;
gap> SI_deg( homalg_variable_6192 );
-1
gap> homalg_variable_6193 := SI_\[(homalg_variable_6184,3,1);;
gap> SI_deg( homalg_variable_6193 );
1
gap> homalg_variable_6194 := SI_\[(homalg_variable_6184,2,1);;
gap> SI_deg( homalg_variable_6194 );
-1
gap> homalg_variable_6195 := SI_\[(homalg_variable_6184,1,1);;
gap> SI_deg( homalg_variable_6195 );
-1
gap> homalg_variable_6196 := SI_\[(homalg_variable_6184,10,2);;
gap> SI_deg( homalg_variable_6196 );
-1
gap> homalg_variable_6197 := SI_\[(homalg_variable_6184,9,2);;
gap> SI_deg( homalg_variable_6197 );
-1
gap> homalg_variable_6198 := SI_\[(homalg_variable_6184,8,2);;
gap> SI_deg( homalg_variable_6198 );
-1
gap> homalg_variable_6199 := SI_\[(homalg_variable_6184,7,2);;
gap> SI_deg( homalg_variable_6199 );
-1
gap> homalg_variable_6200 := SI_\[(homalg_variable_6184,6,2);;
gap> SI_deg( homalg_variable_6200 );
-1
gap> homalg_variable_6201 := SI_\[(homalg_variable_6184,5,2);;
gap> SI_deg( homalg_variable_6201 );
1
gap> homalg_variable_6202 := SI_\[(homalg_variable_6184,4,2);;
gap> SI_deg( homalg_variable_6202 );
-1
gap> homalg_variable_6203 := SI_\[(homalg_variable_6184,3,2);;
gap> SI_deg( homalg_variable_6203 );
-1
gap> homalg_variable_6204 := SI_\[(homalg_variable_6184,2,2);;
gap> SI_deg( homalg_variable_6204 );
1
gap> homalg_variable_6205 := SI_\[(homalg_variable_6184,1,2);;
gap> SI_deg( homalg_variable_6205 );
-1
gap> homalg_variable_6206 := SI_\[(homalg_variable_6184,10,3);;
gap> SI_deg( homalg_variable_6206 );
-1
gap> homalg_variable_6207 := SI_\[(homalg_variable_6184,9,3);;
gap> SI_deg( homalg_variable_6207 );
1
gap> homalg_variable_6208 := SI_\[(homalg_variable_6184,8,3);;
gap> SI_deg( homalg_variable_6208 );
-1
gap> homalg_variable_6209 := SI_\[(homalg_variable_6184,7,3);;
gap> SI_deg( homalg_variable_6209 );
-1
gap> homalg_variable_6210 := SI_\[(homalg_variable_6184,6,3);;
gap> SI_deg( homalg_variable_6210 );
1
gap> homalg_variable_6211 := SI_\[(homalg_variable_6184,5,3);;
gap> SI_deg( homalg_variable_6211 );
-1
gap> homalg_variable_6212 := SI_\[(homalg_variable_6184,4,3);;
gap> SI_deg( homalg_variable_6212 );
-1
gap> homalg_variable_6213 := SI_\[(homalg_variable_6184,3,3);;
gap> SI_deg( homalg_variable_6213 );
-1
gap> homalg_variable_6214 := SI_\[(homalg_variable_6184,2,3);;
gap> SI_deg( homalg_variable_6214 );
-1
gap> homalg_variable_6215 := SI_\[(homalg_variable_6184,1,3);;
gap> SI_deg( homalg_variable_6215 );
-1
gap> homalg_variable_6216 := SI_\[(homalg_variable_6184,10,4);;
gap> SI_deg( homalg_variable_6216 );
-1
gap> homalg_variable_6217 := SI_\[(homalg_variable_6184,9,4);;
gap> SI_deg( homalg_variable_6217 );
-1
gap> homalg_variable_6218 := SI_\[(homalg_variable_6184,8,4);;
gap> SI_deg( homalg_variable_6218 );
1
gap> homalg_variable_6219 := SI_\[(homalg_variable_6184,7,4);;
gap> SI_deg( homalg_variable_6219 );
1
gap> homalg_variable_6220 := SI_\[(homalg_variable_6184,6,4);;
gap> SI_deg( homalg_variable_6220 );
0
gap> homalg_variable_6221 := SI_\[(homalg_variable_6184,1,4);;
gap> IsZero(homalg_variable_6221);
true
gap> homalg_variable_6222 := SI_\[(homalg_variable_6184,2,4);;
gap> IsZero(homalg_variable_6222);
false
gap> homalg_variable_6223 := SI_\[(homalg_variable_6184,3,4);;
gap> IsZero(homalg_variable_6223);
true
gap> homalg_variable_6224 := SI_\[(homalg_variable_6184,4,4);;
gap> IsZero(homalg_variable_6224);
false
gap> homalg_variable_6225 := SI_\[(homalg_variable_6184,5,4);;
gap> IsZero(homalg_variable_6225);
true
gap> homalg_variable_6226 := SI_\[(homalg_variable_6184,6,4);;
gap> IsZero(homalg_variable_6226);
false
gap> homalg_variable_6227 := SI_\[(homalg_variable_6184,7,4);;
gap> IsZero(homalg_variable_6227);
false
gap> homalg_variable_6228 := SI_\[(homalg_variable_6184,8,4);;
gap> IsZero(homalg_variable_6228);
false
gap> homalg_variable_6229 := SI_\[(homalg_variable_6184,9,4);;
gap> IsZero(homalg_variable_6229);
true
gap> homalg_variable_6230 := SI_\[(homalg_variable_6184,10,4);;
gap> IsZero(homalg_variable_6230);
true
gap> homalg_variable_6231 := SI_\[(homalg_variable_6184,10,5);;
gap> SI_deg( homalg_variable_6231 );
-1
gap> homalg_variable_6232 := SI_\[(homalg_variable_6184,9,5);;
gap> SI_deg( homalg_variable_6232 );
1
gap> homalg_variable_6233 := SI_\[(homalg_variable_6184,5,5);;
gap> SI_deg( homalg_variable_6233 );
-1
gap> homalg_variable_6234 := SI_\[(homalg_variable_6184,3,5);;
gap> SI_deg( homalg_variable_6234 );
1
gap> homalg_variable_6235 := SI_\[(homalg_variable_6184,1,5);;
gap> SI_deg( homalg_variable_6235 );
-1
gap> homalg_variable_6237 := SIH_Submatrix(homalg_variable_6182,[1..6],[ 1, 2, 3, 4, 5, 7, 8, 9, 10 ]);;
gap> homalg_variable_6236 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_6237);;
gap> SI_ncols(homalg_variable_6236);
4
gap> homalg_variable_6238 := SI_matrix(homalg_variable_5,9,4,"0");;
gap> homalg_variable_6236 = homalg_variable_6238;
false
gap> homalg_variable_6239 := SI_\[(homalg_variable_6236,9,1);;
gap> SI_deg( homalg_variable_6239 );
-1
gap> homalg_variable_6240 := SI_\[(homalg_variable_6236,8,1);;
gap> SI_deg( homalg_variable_6240 );
-1
gap> homalg_variable_6241 := SI_\[(homalg_variable_6236,7,1);;
gap> SI_deg( homalg_variable_6241 );
-1
gap> homalg_variable_6242 := SI_\[(homalg_variable_6236,6,1);;
gap> SI_deg( homalg_variable_6242 );
-1
gap> homalg_variable_6243 := SI_\[(homalg_variable_6236,5,1);;
gap> SI_deg( homalg_variable_6243 );
1
gap> homalg_variable_6244 := SI_\[(homalg_variable_6236,4,1);;
gap> SI_deg( homalg_variable_6244 );
-1
gap> homalg_variable_6245 := SI_\[(homalg_variable_6236,3,1);;
gap> SI_deg( homalg_variable_6245 );
-1
gap> homalg_variable_6246 := SI_\[(homalg_variable_6236,2,1);;
gap> SI_deg( homalg_variable_6246 );
1
gap> homalg_variable_6247 := SI_\[(homalg_variable_6236,1,1);;
gap> SI_deg( homalg_variable_6247 );
-1
gap> homalg_variable_6248 := SI_\[(homalg_variable_6236,9,2);;
gap> SI_deg( homalg_variable_6248 );
-1
gap> homalg_variable_6249 := SI_\[(homalg_variable_6236,8,2);;
gap> SI_deg( homalg_variable_6249 );
1
gap> homalg_variable_6250 := SI_\[(homalg_variable_6236,7,2);;
gap> SI_deg( homalg_variable_6250 );
-1
gap> homalg_variable_6251 := SI_\[(homalg_variable_6236,6,2);;
gap> SI_deg( homalg_variable_6251 );
-1
gap> homalg_variable_6252 := SI_\[(homalg_variable_6236,5,2);;
gap> SI_deg( homalg_variable_6252 );
-1
gap> homalg_variable_6253 := SI_\[(homalg_variable_6236,4,2);;
gap> SI_deg( homalg_variable_6253 );
-1
gap> homalg_variable_6254 := SI_\[(homalg_variable_6236,3,2);;
gap> SI_deg( homalg_variable_6254 );
1
gap> homalg_variable_6255 := SI_\[(homalg_variable_6236,2,2);;
gap> SI_deg( homalg_variable_6255 );
-1
gap> homalg_variable_6256 := SI_\[(homalg_variable_6236,1,2);;
gap> SI_deg( homalg_variable_6256 );
-1
gap> homalg_variable_6257 := SI_\[(homalg_variable_6236,9,3);;
gap> SI_deg( homalg_variable_6257 );
-1
gap> homalg_variable_6258 := SI_\[(homalg_variable_6236,8,3);;
gap> SI_deg( homalg_variable_6258 );
-1
gap> homalg_variable_6259 := SI_\[(homalg_variable_6236,7,3);;
gap> SI_deg( homalg_variable_6259 );
2
gap> homalg_variable_6260 := SI_\[(homalg_variable_6236,6,3);;
gap> SI_deg( homalg_variable_6260 );
2
gap> homalg_variable_6261 := SI_\[(homalg_variable_6236,5,3);;
gap> SI_deg( homalg_variable_6261 );
-1
gap> homalg_variable_6262 := SI_\[(homalg_variable_6236,4,3);;
gap> SI_deg( homalg_variable_6262 );
2
gap> homalg_variable_6263 := SI_\[(homalg_variable_6236,3,3);;
gap> SI_deg( homalg_variable_6263 );
1
gap> homalg_variable_6264 := SI_\[(homalg_variable_6236,2,3);;
gap> SI_deg( homalg_variable_6264 );
1
gap> homalg_variable_6265 := SI_\[(homalg_variable_6236,1,3);;
gap> SI_deg( homalg_variable_6265 );
-1
gap> homalg_variable_6266 := SI_\[(homalg_variable_6236,9,4);;
gap> SI_deg( homalg_variable_6266 );
-1
gap> homalg_variable_6267 := SI_\[(homalg_variable_6236,8,4);;
gap> SI_deg( homalg_variable_6267 );
1
gap> homalg_variable_6268 := SI_\[(homalg_variable_6236,7,4);;
gap> SI_deg( homalg_variable_6268 );
2
gap> homalg_variable_6269 := SI_\[(homalg_variable_6236,6,4);;
gap> SI_deg( homalg_variable_6269 );
2
gap> homalg_variable_6270 := SI_\[(homalg_variable_6236,5,4);;
gap> SI_deg( homalg_variable_6270 );
-1
gap> homalg_variable_6271 := SI_\[(homalg_variable_6236,4,4);;
gap> SI_deg( homalg_variable_6271 );
2
gap> homalg_variable_6272 := SI_\[(homalg_variable_6236,3,4);;
gap> SI_deg( homalg_variable_6272 );
-1
gap> homalg_variable_6273 := SI_\[(homalg_variable_6236,2,4);;
gap> SI_deg( homalg_variable_6273 );
1
gap> homalg_variable_6274 := SI_\[(homalg_variable_6236,1,4);;
gap> SI_deg( homalg_variable_6274 );
-1
gap> homalg_variable_6275 := SI_matrix(homalg_variable_5,6,9,"0");;
gap> homalg_variable_6237 = homalg_variable_6275;
false
gap> homalg_variable_6276 := SIH_BasisOfColumnModule(homalg_variable_6182);;
gap> SI_ncols(homalg_variable_6276);
10
gap> homalg_variable_6277 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_6276 = homalg_variable_6277;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6237);; homalg_variable_6278 := homalg_variable_l[1];; homalg_variable_6279 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6278);
10
gap> homalg_variable_6280 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_6278 = homalg_variable_6280;
false
gap> SI_nrows(homalg_variable_6279);
9
gap> homalg_variable_6281 := homalg_variable_6237 * homalg_variable_6279;;
gap> homalg_variable_6278 = homalg_variable_6281;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6276,homalg_variable_6278);; homalg_variable_6282 := homalg_variable_l[1];; homalg_variable_6283 := homalg_variable_l[2];;
gap> homalg_variable_6284 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_6282 = homalg_variable_6284;
true
gap> homalg_variable_6285 := homalg_variable_6278 * homalg_variable_6283;;
gap> homalg_variable_6286 := homalg_variable_6276 + homalg_variable_6285;;
gap> homalg_variable_6282 = homalg_variable_6286;
true
gap> homalg_variable_6287 := SIH_DecideZeroColumns(homalg_variable_6276,homalg_variable_6278);;
gap> homalg_variable_6288 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_6287 = homalg_variable_6288;
true
gap> homalg_variable_6289 := homalg_variable_6283 * (homalg_variable_8);;
gap> homalg_variable_6290 := homalg_variable_6279 * homalg_variable_6289;;
gap> homalg_variable_6291 := homalg_variable_6237 * homalg_variable_6290;;
gap> homalg_variable_6291 = homalg_variable_6276;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6237,homalg_variable_6276);; homalg_variable_6292 := homalg_variable_l[1];; homalg_variable_6293 := homalg_variable_l[2];;
gap> homalg_variable_6294 := SI_matrix(homalg_variable_5,6,9,"0");;
gap> homalg_variable_6292 = homalg_variable_6294;
true
gap> homalg_variable_6295 := homalg_variable_6276 * homalg_variable_6293;;
gap> homalg_variable_6296 := homalg_variable_6237 + homalg_variable_6295;;
gap> homalg_variable_6292 = homalg_variable_6296;
true
gap> homalg_variable_6297 := SIH_DecideZeroColumns(homalg_variable_6237,homalg_variable_6276);;
gap> homalg_variable_6298 := SI_matrix(homalg_variable_5,6,9,"0");;
gap> homalg_variable_6297 = homalg_variable_6298;
true
gap> homalg_variable_6299 := homalg_variable_6293 * (homalg_variable_8);;
gap> homalg_variable_6300 := homalg_variable_6276 * homalg_variable_6299;;
gap> homalg_variable_6300 = homalg_variable_6237;
true
gap> homalg_variable_6301 := SIH_BasisOfColumnModule(homalg_variable_6177);;
gap> SI_ncols(homalg_variable_6301);
10
gap> homalg_variable_6302 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_6301 = homalg_variable_6302;
false
gap> homalg_variable_6301 = homalg_variable_6177;
true
gap> homalg_variable_6303 := SIH_DecideZeroColumns(homalg_variable_6237,homalg_variable_6301);;
gap> homalg_variable_6304 := SI_matrix(homalg_variable_5,6,9,"0");;
gap> homalg_variable_6303 = homalg_variable_6304;
true
gap> homalg_variable_6305 := SIH_UnionOfColumns(homalg_variable_6175,homalg_variable_10);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6305);; homalg_variable_6306 := homalg_variable_l[1];; homalg_variable_6307 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6306);
4
gap> homalg_variable_6308 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_6306 = homalg_variable_6308;
false
gap> SI_nrows(homalg_variable_6307);
12
gap> homalg_variable_6309 := SIH_Submatrix(homalg_variable_6307,[ 1, 2, 3, 4, 5, 6 ],[1..4]);;
gap> homalg_variable_6310 := homalg_variable_6175 * homalg_variable_6309;;
gap> homalg_variable_6311 := SIH_Submatrix(homalg_variable_6307,[ 7, 8, 9, 10, 11, 12 ],[1..4]);;
gap> homalg_variable_6312 := homalg_variable_10 * homalg_variable_6311;;
gap> homalg_variable_6313 := homalg_variable_6310 + homalg_variable_6312;;
gap> homalg_variable_6306 = homalg_variable_6313;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6119,homalg_variable_6306);; homalg_variable_6314 := homalg_variable_l[1];; homalg_variable_6315 := homalg_variable_l[2];;
gap> homalg_variable_6316 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_6314 = homalg_variable_6316;
true
gap> homalg_variable_6317 := homalg_variable_6306 * homalg_variable_6315;;
gap> homalg_variable_6318 := homalg_variable_6119 + homalg_variable_6317;;
gap> homalg_variable_6314 = homalg_variable_6318;
true
gap> homalg_variable_6319 := SIH_DecideZeroColumns(homalg_variable_6119,homalg_variable_6306);;
gap> homalg_variable_6320 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_6319 = homalg_variable_6320;
true
gap> homalg_variable_6322 := SIH_Submatrix(homalg_variable_6307,[ 1, 2, 3, 4, 5, 6 ],[1..4]);;
gap> homalg_variable_6323 := homalg_variable_6315 * (homalg_variable_8);;
gap> homalg_variable_6324 := homalg_variable_6322 * homalg_variable_6323;;
gap> homalg_variable_6325 := homalg_variable_6175 * homalg_variable_6324;;
gap> homalg_variable_6326 := homalg_variable_6325 - homalg_variable_6119;;
gap> homalg_variable_6321 := SIH_DecideZeroColumns(homalg_variable_6326,homalg_variable_10);;
gap> homalg_variable_6327 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_6321 = homalg_variable_6327;
true
gap> homalg_variable_6328 := SIH_UnionOfColumns(homalg_variable_6175,homalg_variable_10);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6328);; homalg_variable_6329 := homalg_variable_l[1];; homalg_variable_6330 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6329);
4
gap> homalg_variable_6331 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_6329 = homalg_variable_6331;
false
gap> SI_nrows(homalg_variable_6330);
12
gap> homalg_variable_6332 := SIH_Submatrix(homalg_variable_6330,[ 1, 2, 3, 4, 5, 6 ],[1..4]);;
gap> homalg_variable_6333 := homalg_variable_6175 * homalg_variable_6332;;
gap> homalg_variable_6334 := SIH_Submatrix(homalg_variable_6330,[ 7, 8, 9, 10, 11, 12 ],[1..4]);;
gap> homalg_variable_6335 := homalg_variable_10 * homalg_variable_6334;;
gap> homalg_variable_6336 := homalg_variable_6333 + homalg_variable_6335;;
gap> homalg_variable_6329 = homalg_variable_6336;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6122,homalg_variable_6329);; homalg_variable_6337 := homalg_variable_l[1];; homalg_variable_6338 := homalg_variable_l[2];;
gap> homalg_variable_6339 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_6337 = homalg_variable_6339;
true
gap> homalg_variable_6340 := homalg_variable_6329 * homalg_variable_6338;;
gap> homalg_variable_6341 := homalg_variable_6122 + homalg_variable_6340;;
gap> homalg_variable_6337 = homalg_variable_6341;
true
gap> homalg_variable_6342 := SIH_DecideZeroColumns(homalg_variable_6122,homalg_variable_6329);;
gap> homalg_variable_6343 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_6342 = homalg_variable_6343;
true
gap> homalg_variable_6345 := SIH_Submatrix(homalg_variable_6330,[ 1, 2, 3, 4, 5, 6 ],[1..4]);;
gap> homalg_variable_6346 := homalg_variable_6338 * (homalg_variable_8);;
gap> homalg_variable_6347 := homalg_variable_6345 * homalg_variable_6346;;
gap> homalg_variable_6348 := homalg_variable_6175 * homalg_variable_6347;;
gap> homalg_variable_6349 := homalg_variable_6348 - homalg_variable_6122;;
gap> homalg_variable_6344 := SIH_DecideZeroColumns(homalg_variable_6349,homalg_variable_10);;
gap> homalg_variable_6350 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_6344 = homalg_variable_6350;
true
gap> homalg_variable_6351 := SIH_UnionOfColumns(homalg_variable_6175,homalg_variable_10);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6351);; homalg_variable_6352 := homalg_variable_l[1];; homalg_variable_6353 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6352);
4
gap> homalg_variable_6354 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_6352 = homalg_variable_6354;
false
gap> SI_nrows(homalg_variable_6353);
12
gap> homalg_variable_6355 := SIH_Submatrix(homalg_variable_6353,[ 1, 2, 3, 4, 5, 6 ],[1..4]);;
gap> homalg_variable_6356 := homalg_variable_6175 * homalg_variable_6355;;
gap> homalg_variable_6357 := SIH_Submatrix(homalg_variable_6353,[ 7, 8, 9, 10, 11, 12 ],[1..4]);;
gap> homalg_variable_6358 := homalg_variable_10 * homalg_variable_6357;;
gap> homalg_variable_6359 := homalg_variable_6356 + homalg_variable_6358;;
gap> homalg_variable_6352 = homalg_variable_6359;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6125,homalg_variable_6352);; homalg_variable_6360 := homalg_variable_l[1];; homalg_variable_6361 := homalg_variable_l[2];;
gap> homalg_variable_6362 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_6360 = homalg_variable_6362;
true
gap> homalg_variable_6363 := homalg_variable_6352 * homalg_variable_6361;;
gap> homalg_variable_6364 := homalg_variable_6125 + homalg_variable_6363;;
gap> homalg_variable_6360 = homalg_variable_6364;
true
gap> homalg_variable_6365 := SIH_DecideZeroColumns(homalg_variable_6125,homalg_variable_6352);;
gap> homalg_variable_6366 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_6365 = homalg_variable_6366;
true
gap> homalg_variable_6368 := SIH_Submatrix(homalg_variable_6353,[ 1, 2, 3, 4, 5, 6 ],[1..4]);;
gap> homalg_variable_6369 := homalg_variable_6361 * (homalg_variable_8);;
gap> homalg_variable_6370 := homalg_variable_6368 * homalg_variable_6369;;
gap> homalg_variable_6371 := homalg_variable_6175 * homalg_variable_6370;;
gap> homalg_variable_6372 := homalg_variable_6371 - homalg_variable_6125;;
gap> homalg_variable_6367 := SIH_DecideZeroColumns(homalg_variable_6372,homalg_variable_10);;
gap> homalg_variable_6373 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_6367 = homalg_variable_6373;
true
gap> homalg_variable_6375 := SI_matrix(homalg_variable_5,5,12,"0");;
gap> homalg_variable_6376 := SIH_UnionOfColumns(homalg_variable_6375,homalg_variable_10);;
gap> homalg_variable_6374 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_6175,homalg_variable_6376);;
gap> SI_ncols(homalg_variable_6374);
10
gap> homalg_variable_6377 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_6374 = homalg_variable_6377;
false
gap> homalg_variable_6378 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_6374);;
gap> SI_ncols(homalg_variable_6378);
5
gap> homalg_variable_6379 := SI_matrix(homalg_variable_5,10,5,"0");;
gap> homalg_variable_6378 = homalg_variable_6379;
false
gap> homalg_variable_6380 := SI_\[(homalg_variable_6378,10,1);;
gap> SI_deg( homalg_variable_6380 );
-1
gap> homalg_variable_6381 := SI_\[(homalg_variable_6378,9,1);;
gap> SI_deg( homalg_variable_6381 );
-1
gap> homalg_variable_6382 := SI_\[(homalg_variable_6378,8,1);;
gap> SI_deg( homalg_variable_6382 );
-1
gap> homalg_variable_6383 := SI_\[(homalg_variable_6378,7,1);;
gap> SI_deg( homalg_variable_6383 );
-1
gap> homalg_variable_6384 := SI_\[(homalg_variable_6378,6,1);;
gap> SI_deg( homalg_variable_6384 );
1
gap> homalg_variable_6385 := SI_\[(homalg_variable_6378,5,1);;
gap> SI_deg( homalg_variable_6385 );
-1
gap> homalg_variable_6386 := SI_\[(homalg_variable_6378,4,1);;
gap> SI_deg( homalg_variable_6386 );
-1
gap> homalg_variable_6387 := SI_\[(homalg_variable_6378,3,1);;
gap> SI_deg( homalg_variable_6387 );
1
gap> homalg_variable_6388 := SI_\[(homalg_variable_6378,2,1);;
gap> SI_deg( homalg_variable_6388 );
-1
gap> homalg_variable_6389 := SI_\[(homalg_variable_6378,1,1);;
gap> SI_deg( homalg_variable_6389 );
-1
gap> homalg_variable_6390 := SI_\[(homalg_variable_6378,10,2);;
gap> SI_deg( homalg_variable_6390 );
-1
gap> homalg_variable_6391 := SI_\[(homalg_variable_6378,9,2);;
gap> SI_deg( homalg_variable_6391 );
-1
gap> homalg_variable_6392 := SI_\[(homalg_variable_6378,8,2);;
gap> SI_deg( homalg_variable_6392 );
-1
gap> homalg_variable_6393 := SI_\[(homalg_variable_6378,7,2);;
gap> SI_deg( homalg_variable_6393 );
-1
gap> homalg_variable_6394 := SI_\[(homalg_variable_6378,6,2);;
gap> SI_deg( homalg_variable_6394 );
-1
gap> homalg_variable_6395 := SI_\[(homalg_variable_6378,5,2);;
gap> SI_deg( homalg_variable_6395 );
1
gap> homalg_variable_6396 := SI_\[(homalg_variable_6378,4,2);;
gap> SI_deg( homalg_variable_6396 );
-1
gap> homalg_variable_6397 := SI_\[(homalg_variable_6378,3,2);;
gap> SI_deg( homalg_variable_6397 );
-1
gap> homalg_variable_6398 := SI_\[(homalg_variable_6378,2,2);;
gap> SI_deg( homalg_variable_6398 );
1
gap> homalg_variable_6399 := SI_\[(homalg_variable_6378,1,2);;
gap> SI_deg( homalg_variable_6399 );
-1
gap> homalg_variable_6400 := SI_\[(homalg_variable_6378,10,3);;
gap> SI_deg( homalg_variable_6400 );
-1
gap> homalg_variable_6401 := SI_\[(homalg_variable_6378,9,3);;
gap> SI_deg( homalg_variable_6401 );
1
gap> homalg_variable_6402 := SI_\[(homalg_variable_6378,8,3);;
gap> SI_deg( homalg_variable_6402 );
-1
gap> homalg_variable_6403 := SI_\[(homalg_variable_6378,7,3);;
gap> SI_deg( homalg_variable_6403 );
-1
gap> homalg_variable_6404 := SI_\[(homalg_variable_6378,6,3);;
gap> SI_deg( homalg_variable_6404 );
1
gap> homalg_variable_6405 := SI_\[(homalg_variable_6378,5,3);;
gap> SI_deg( homalg_variable_6405 );
-1
gap> homalg_variable_6406 := SI_\[(homalg_variable_6378,4,3);;
gap> SI_deg( homalg_variable_6406 );
-1
gap> homalg_variable_6407 := SI_\[(homalg_variable_6378,3,3);;
gap> SI_deg( homalg_variable_6407 );
-1
gap> homalg_variable_6408 := SI_\[(homalg_variable_6378,2,3);;
gap> SI_deg( homalg_variable_6408 );
-1
gap> homalg_variable_6409 := SI_\[(homalg_variable_6378,1,3);;
gap> SI_deg( homalg_variable_6409 );
-1
gap> homalg_variable_6410 := SI_\[(homalg_variable_6378,10,4);;
gap> SI_deg( homalg_variable_6410 );
-1
gap> homalg_variable_6411 := SI_\[(homalg_variable_6378,9,4);;
gap> SI_deg( homalg_variable_6411 );
-1
gap> homalg_variable_6412 := SI_\[(homalg_variable_6378,8,4);;
gap> SI_deg( homalg_variable_6412 );
1
gap> homalg_variable_6413 := SI_\[(homalg_variable_6378,7,4);;
gap> SI_deg( homalg_variable_6413 );
1
gap> homalg_variable_6414 := SI_\[(homalg_variable_6378,6,4);;
gap> SI_deg( homalg_variable_6414 );
0
gap> homalg_variable_6415 := SI_\[(homalg_variable_6378,1,4);;
gap> IsZero(homalg_variable_6415);
true
gap> homalg_variable_6416 := SI_\[(homalg_variable_6378,2,4);;
gap> IsZero(homalg_variable_6416);
false
gap> homalg_variable_6417 := SI_\[(homalg_variable_6378,3,4);;
gap> IsZero(homalg_variable_6417);
true
gap> homalg_variable_6418 := SI_\[(homalg_variable_6378,4,4);;
gap> IsZero(homalg_variable_6418);
false
gap> homalg_variable_6419 := SI_\[(homalg_variable_6378,5,4);;
gap> IsZero(homalg_variable_6419);
true
gap> homalg_variable_6420 := SI_\[(homalg_variable_6378,6,4);;
gap> IsZero(homalg_variable_6420);
false
gap> homalg_variable_6421 := SI_\[(homalg_variable_6378,7,4);;
gap> IsZero(homalg_variable_6421);
false
gap> homalg_variable_6422 := SI_\[(homalg_variable_6378,8,4);;
gap> IsZero(homalg_variable_6422);
false
gap> homalg_variable_6423 := SI_\[(homalg_variable_6378,9,4);;
gap> IsZero(homalg_variable_6423);
true
gap> homalg_variable_6424 := SI_\[(homalg_variable_6378,10,4);;
gap> IsZero(homalg_variable_6424);
true
gap> homalg_variable_6425 := SI_\[(homalg_variable_6378,10,5);;
gap> SI_deg( homalg_variable_6425 );
-1
gap> homalg_variable_6426 := SI_\[(homalg_variable_6378,9,5);;
gap> SI_deg( homalg_variable_6426 );
1
gap> homalg_variable_6427 := SI_\[(homalg_variable_6378,5,5);;
gap> SI_deg( homalg_variable_6427 );
-1
gap> homalg_variable_6428 := SI_\[(homalg_variable_6378,3,5);;
gap> SI_deg( homalg_variable_6428 );
1
gap> homalg_variable_6429 := SI_\[(homalg_variable_6378,1,5);;
gap> SI_deg( homalg_variable_6429 );
-1
gap> homalg_variable_6431 := SIH_Submatrix(homalg_variable_6374,[1..6],[ 1, 2, 3, 4, 5, 7, 8, 9, 10 ]);;
gap> homalg_variable_6430 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_6431);;
gap> SI_ncols(homalg_variable_6430);
4
gap> homalg_variable_6432 := SI_matrix(homalg_variable_5,9,4,"0");;
gap> homalg_variable_6430 = homalg_variable_6432;
false
gap> homalg_variable_6433 := SI_\[(homalg_variable_6430,9,1);;
gap> SI_deg( homalg_variable_6433 );
-1
gap> homalg_variable_6434 := SI_\[(homalg_variable_6430,8,1);;
gap> SI_deg( homalg_variable_6434 );
-1
gap> homalg_variable_6435 := SI_\[(homalg_variable_6430,7,1);;
gap> SI_deg( homalg_variable_6435 );
-1
gap> homalg_variable_6436 := SI_\[(homalg_variable_6430,6,1);;
gap> SI_deg( homalg_variable_6436 );
-1
gap> homalg_variable_6437 := SI_\[(homalg_variable_6430,5,1);;
gap> SI_deg( homalg_variable_6437 );
1
gap> homalg_variable_6438 := SI_\[(homalg_variable_6430,4,1);;
gap> SI_deg( homalg_variable_6438 );
-1
gap> homalg_variable_6439 := SI_\[(homalg_variable_6430,3,1);;
gap> SI_deg( homalg_variable_6439 );
-1
gap> homalg_variable_6440 := SI_\[(homalg_variable_6430,2,1);;
gap> SI_deg( homalg_variable_6440 );
1
gap> homalg_variable_6441 := SI_\[(homalg_variable_6430,1,1);;
gap> SI_deg( homalg_variable_6441 );
-1
gap> homalg_variable_6442 := SI_\[(homalg_variable_6430,9,2);;
gap> SI_deg( homalg_variable_6442 );
-1
gap> homalg_variable_6443 := SI_\[(homalg_variable_6430,8,2);;
gap> SI_deg( homalg_variable_6443 );
1
gap> homalg_variable_6444 := SI_\[(homalg_variable_6430,7,2);;
gap> SI_deg( homalg_variable_6444 );
-1
gap> homalg_variable_6445 := SI_\[(homalg_variable_6430,6,2);;
gap> SI_deg( homalg_variable_6445 );
-1
gap> homalg_variable_6446 := SI_\[(homalg_variable_6430,5,2);;
gap> SI_deg( homalg_variable_6446 );
-1
gap> homalg_variable_6447 := SI_\[(homalg_variable_6430,4,2);;
gap> SI_deg( homalg_variable_6447 );
-1
gap> homalg_variable_6448 := SI_\[(homalg_variable_6430,3,2);;
gap> SI_deg( homalg_variable_6448 );
1
gap> homalg_variable_6449 := SI_\[(homalg_variable_6430,2,2);;
gap> SI_deg( homalg_variable_6449 );
-1
gap> homalg_variable_6450 := SI_\[(homalg_variable_6430,1,2);;
gap> SI_deg( homalg_variable_6450 );
-1
gap> homalg_variable_6451 := SI_\[(homalg_variable_6430,9,3);;
gap> SI_deg( homalg_variable_6451 );
-1
gap> homalg_variable_6452 := SI_\[(homalg_variable_6430,8,3);;
gap> SI_deg( homalg_variable_6452 );
-1
gap> homalg_variable_6453 := SI_\[(homalg_variable_6430,7,3);;
gap> SI_deg( homalg_variable_6453 );
2
gap> homalg_variable_6454 := SI_\[(homalg_variable_6430,6,3);;
gap> SI_deg( homalg_variable_6454 );
2
gap> homalg_variable_6455 := SI_\[(homalg_variable_6430,5,3);;
gap> SI_deg( homalg_variable_6455 );
-1
gap> homalg_variable_6456 := SI_\[(homalg_variable_6430,4,3);;
gap> SI_deg( homalg_variable_6456 );
2
gap> homalg_variable_6457 := SI_\[(homalg_variable_6430,3,3);;
gap> SI_deg( homalg_variable_6457 );
1
gap> homalg_variable_6458 := SI_\[(homalg_variable_6430,2,3);;
gap> SI_deg( homalg_variable_6458 );
1
gap> homalg_variable_6459 := SI_\[(homalg_variable_6430,1,3);;
gap> SI_deg( homalg_variable_6459 );
-1
gap> homalg_variable_6460 := SI_\[(homalg_variable_6430,9,4);;
gap> SI_deg( homalg_variable_6460 );
-1
gap> homalg_variable_6461 := SI_\[(homalg_variable_6430,8,4);;
gap> SI_deg( homalg_variable_6461 );
1
gap> homalg_variable_6462 := SI_\[(homalg_variable_6430,7,4);;
gap> SI_deg( homalg_variable_6462 );
2
gap> homalg_variable_6463 := SI_\[(homalg_variable_6430,6,4);;
gap> SI_deg( homalg_variable_6463 );
2
gap> homalg_variable_6464 := SI_\[(homalg_variable_6430,5,4);;
gap> SI_deg( homalg_variable_6464 );
-1
gap> homalg_variable_6465 := SI_\[(homalg_variable_6430,4,4);;
gap> SI_deg( homalg_variable_6465 );
2
gap> homalg_variable_6466 := SI_\[(homalg_variable_6430,3,4);;
gap> SI_deg( homalg_variable_6466 );
-1
gap> homalg_variable_6467 := SI_\[(homalg_variable_6430,2,4);;
gap> SI_deg( homalg_variable_6467 );
1
gap> homalg_variable_6468 := SI_\[(homalg_variable_6430,1,4);;
gap> SI_deg( homalg_variable_6468 );
-1
gap> homalg_variable_6469 := SI_matrix(homalg_variable_5,6,9,"0");;
gap> homalg_variable_6431 = homalg_variable_6469;
false
gap> homalg_variable_6470 := SIH_BasisOfColumnModule(homalg_variable_6374);;
gap> SI_ncols(homalg_variable_6470);
10
gap> homalg_variable_6471 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_6470 = homalg_variable_6471;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6431);; homalg_variable_6472 := homalg_variable_l[1];; homalg_variable_6473 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6472);
10
gap> homalg_variable_6474 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_6472 = homalg_variable_6474;
false
gap> SI_nrows(homalg_variable_6473);
9
gap> homalg_variable_6475 := homalg_variable_6431 * homalg_variable_6473;;
gap> homalg_variable_6472 = homalg_variable_6475;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6470,homalg_variable_6472);; homalg_variable_6476 := homalg_variable_l[1];; homalg_variable_6477 := homalg_variable_l[2];;
gap> homalg_variable_6478 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_6476 = homalg_variable_6478;
true
gap> homalg_variable_6479 := homalg_variable_6472 * homalg_variable_6477;;
gap> homalg_variable_6480 := homalg_variable_6470 + homalg_variable_6479;;
gap> homalg_variable_6476 = homalg_variable_6480;
true
gap> homalg_variable_6481 := SIH_DecideZeroColumns(homalg_variable_6470,homalg_variable_6472);;
gap> homalg_variable_6482 := SI_matrix(homalg_variable_5,6,10,"0");;
gap> homalg_variable_6481 = homalg_variable_6482;
true
gap> homalg_variable_6483 := homalg_variable_6477 * (homalg_variable_8);;
gap> homalg_variable_6484 := homalg_variable_6473 * homalg_variable_6483;;
gap> homalg_variable_6485 := homalg_variable_6431 * homalg_variable_6484;;
gap> homalg_variable_6485 = homalg_variable_6470;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6431,homalg_variable_6470);; homalg_variable_6486 := homalg_variable_l[1];; homalg_variable_6487 := homalg_variable_l[2];;
gap> homalg_variable_6488 := SI_matrix(homalg_variable_5,6,9,"0");;
gap> homalg_variable_6486 = homalg_variable_6488;
true
gap> homalg_variable_6489 := homalg_variable_6470 * homalg_variable_6487;;
gap> homalg_variable_6490 := homalg_variable_6431 + homalg_variable_6489;;
gap> homalg_variable_6486 = homalg_variable_6490;
true
gap> homalg_variable_6491 := SIH_DecideZeroColumns(homalg_variable_6431,homalg_variable_6470);;
gap> homalg_variable_6492 := SI_matrix(homalg_variable_5,6,9,"0");;
gap> homalg_variable_6491 = homalg_variable_6492;
true
gap> homalg_variable_6493 := homalg_variable_6487 * (homalg_variable_8);;
gap> homalg_variable_6494 := homalg_variable_6470 * homalg_variable_6493;;
gap> homalg_variable_6494 = homalg_variable_6431;
true
gap> homalg_variable_6495 := SIH_DecideZeroColumns(homalg_variable_6431,homalg_variable_6301);;
gap> homalg_variable_6496 := SI_matrix(homalg_variable_5,6,9,"0");;
gap> homalg_variable_6495 = homalg_variable_6496;
true
gap> homalg_variable_6498 := homalg_variable_6324 * homalg_variable_3336;;
gap> homalg_variable_6497 := SIH_DecideZeroColumns(homalg_variable_6498,homalg_variable_6301);;
gap> homalg_variable_6499 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_6497 = homalg_variable_6499;
true
gap> homalg_variable_6500 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_6324,homalg_variable_6301);;
gap> SI_ncols(homalg_variable_6500);
3
gap> for _del in [ "homalg_variable_6001", "homalg_variable_6015", "homalg_variable_6016", "homalg_variable_6019", "homalg_variable_6020", "homalg_variable_6021", "homalg_variable_6022", "homalg_variable_6023", "homalg_variable_6029", "homalg_variable_6030", "homalg_variable_6031", "homalg_variable_6032", "homalg_variable_6033", "homalg_variable_6034", "homalg_variable_6035", "homalg_variable_6036", "homalg_variable_6037", "homalg_variable_6038", "homalg_variable_6039", "homalg_variable_6040", "homalg_variable_6042", "homalg_variable_6047", "homalg_variable_6049", "homalg_variable_6050", "homalg_variable_6051", "homalg_variable_6052", "homalg_variable_6053", "homalg_variable_6054", "homalg_variable_6055", "homalg_variable_6056", "homalg_variable_6057", "homalg_variable_6058", "homalg_variable_6059", "homalg_variable_6060", "homalg_variable_6062", "homalg_variable_6063", "homalg_variable_6064", "homalg_variable_6065", "homalg_variable_6066", "homalg_variable_6067", "homalg_variable_6068", "homalg_variable_6069", "homalg_variable_6070", "homalg_variable_6072", "homalg_variable_6073", "homalg_variable_6074", "homalg_variable_6075", "homalg_variable_6076", "homalg_variable_6081", "homalg_variable_6083", "homalg_variable_6084", "homalg_variable_6085", "homalg_variable_6086", "homalg_variable_6087", "homalg_variable_6088", "homalg_variable_6089", "homalg_variable_6090", "homalg_variable_6091", "homalg_variable_6092", "homalg_variable_6093", "homalg_variable_6094", "homalg_variable_6095", "homalg_variable_6096", "homalg_variable_6097", "homalg_variable_6098", "homalg_variable_6099", "homalg_variable_6100", "homalg_variable_6101", "homalg_variable_6102", "homalg_variable_6103", "homalg_variable_6104", "homalg_variable_6105", "homalg_variable_6106", "homalg_variable_6107", "homalg_variable_6108", "homalg_variable_6109", "homalg_variable_6110", "homalg_variable_6111", "homalg_variable_6112", "homalg_variable_6115", "homalg_variable_6116", "homalg_variable_6117", "homalg_variable_6118", "homalg_variable_6120", "homalg_variable_6121", "homalg_variable_6123", "homalg_variable_6124", "homalg_variable_6127", "homalg_variable_6130", "homalg_variable_6131", "homalg_variable_6132", "homalg_variable_6133", "homalg_variable_6134", "homalg_variable_6139", "homalg_variable_6140", "homalg_variable_6141", "homalg_variable_6146", "homalg_variable_6150", "homalg_variable_6151", "homalg_variable_6152", "homalg_variable_6153", "homalg_variable_6154", "homalg_variable_6155", "homalg_variable_6157", "homalg_variable_6160", "homalg_variable_6161", "homalg_variable_6162", "homalg_variable_6165", "homalg_variable_6169", "homalg_variable_6170", "homalg_variable_6171", "homalg_variable_6172", "homalg_variable_6173", "homalg_variable_6174", "homalg_variable_6176", "homalg_variable_6178", "homalg_variable_6179", "homalg_variable_6180", "homalg_variable_6181", "homalg_variable_6183", "homalg_variable_6185", "homalg_variable_6186", "homalg_variable_6187", "homalg_variable_6188", "homalg_variable_6189", "homalg_variable_6190", "homalg_variable_6191", "homalg_variable_6192", "homalg_variable_6193", "homalg_variable_6194", "homalg_variable_6195", "homalg_variable_6196", "homalg_variable_6197", "homalg_variable_6198", "homalg_variable_6199", "homalg_variable_6200", "homalg_variable_6201", "homalg_variable_6202", "homalg_variable_6203", "homalg_variable_6204", "homalg_variable_6205", "homalg_variable_6206", "homalg_variable_6207", "homalg_variable_6208", "homalg_variable_6209", "homalg_variable_6210", "homalg_variable_6213", "homalg_variable_6214", "homalg_variable_6215", "homalg_variable_6216", "homalg_variable_6217", "homalg_variable_6218", "homalg_variable_6219", "homalg_variable_6220", "homalg_variable_6221", "homalg_variable_6222", "homalg_variable_6223", "homalg_variable_6224", "homalg_variable_6225", "homalg_variable_6226", "homalg_variable_6227", "homalg_variable_6228", "homalg_variable_6229", "homalg_variable_6230", "homalg_variable_6231", "homalg_variable_6232", "homalg_variable_6233", "homalg_variable_6234", "homalg_variable_6235", "homalg_variable_6238", "homalg_variable_6239", "homalg_variable_6240", "homalg_variable_6241", "homalg_variable_6242", "homalg_variable_6244", "homalg_variable_6245", "homalg_variable_6246", "homalg_variable_6247", "homalg_variable_6248", "homalg_variable_6249", "homalg_variable_6250", "homalg_variable_6251", "homalg_variable_6252", "homalg_variable_6253", "homalg_variable_6254", "homalg_variable_6255", "homalg_variable_6256", "homalg_variable_6257", "homalg_variable_6258", "homalg_variable_6259", "homalg_variable_6260", "homalg_variable_6261", "homalg_variable_6262", "homalg_variable_6263", "homalg_variable_6264", "homalg_variable_6265", "homalg_variable_6266", "homalg_variable_6267", "homalg_variable_6268", "homalg_variable_6269", "homalg_variable_6270", "homalg_variable_6271", "homalg_variable_6272", "homalg_variable_6273", "homalg_variable_6274", "homalg_variable_6277", "homalg_variable_6280", "homalg_variable_6281", "homalg_variable_6282", "homalg_variable_6283", "homalg_variable_6284", "homalg_variable_6285", "homalg_variable_6286", "homalg_variable_6287", "homalg_variable_6288", "homalg_variable_6289", "homalg_variable_6290", "homalg_variable_6291", "homalg_variable_6294", "homalg_variable_6295", "homalg_variable_6296", "homalg_variable_6297", "homalg_variable_6298", "homalg_variable_6300", "homalg_variable_6302", "homalg_variable_6303", "homalg_variable_6304", "homalg_variable_6308", "homalg_variable_6309", "homalg_variable_6310", "homalg_variable_6311", "homalg_variable_6312", "homalg_variable_6313", "homalg_variable_6316", "homalg_variable_6317", "homalg_variable_6318", "homalg_variable_6319", "homalg_variable_6320", "homalg_variable_6331", "homalg_variable_6332", "homalg_variable_6333", "homalg_variable_6334", "homalg_variable_6335", "homalg_variable_6336", "homalg_variable_6339", "homalg_variable_6340", "homalg_variable_6341", "homalg_variable_6342", "homalg_variable_6343", "homalg_variable_6350", "homalg_variable_6354", "homalg_variable_6355", "homalg_variable_6356", "homalg_variable_6357", "homalg_variable_6358", "homalg_variable_6359", "homalg_variable_6362", "homalg_variable_6363", "homalg_variable_6364", "homalg_variable_6365", "homalg_variable_6366", "homalg_variable_6373", "homalg_variable_6377", "homalg_variable_6379", "homalg_variable_6380", "homalg_variable_6381", "homalg_variable_6382", "homalg_variable_6383", "homalg_variable_6384", "homalg_variable_6385", "homalg_variable_6386", "homalg_variable_6387", "homalg_variable_6388", "homalg_variable_6389", "homalg_variable_6390", "homalg_variable_6391", "homalg_variable_6392", "homalg_variable_6393", "homalg_variable_6396", "homalg_variable_6397", "homalg_variable_6398", "homalg_variable_6399", "homalg_variable_6400", "homalg_variable_6401", "homalg_variable_6402", "homalg_variable_6403", "homalg_variable_6404", "homalg_variable_6405", "homalg_variable_6406", "homalg_variable_6407", "homalg_variable_6408", "homalg_variable_6409", "homalg_variable_6410", "homalg_variable_6411", "homalg_variable_6412", "homalg_variable_6413", "homalg_variable_6414", "homalg_variable_6415", "homalg_variable_6416", "homalg_variable_6417", "homalg_variable_6418", "homalg_variable_6419", "homalg_variable_6420", "homalg_variable_6421", "homalg_variable_6422", "homalg_variable_6423", "homalg_variable_6424", "homalg_variable_6427", "homalg_variable_6428", "homalg_variable_6429", "homalg_variable_6432", "homalg_variable_6433", "homalg_variable_6434", "homalg_variable_6435", "homalg_variable_6436", "homalg_variable_6437", "homalg_variable_6438", "homalg_variable_6439", "homalg_variable_6440", "homalg_variable_6441", "homalg_variable_6442", "homalg_variable_6443", "homalg_variable_6444", "homalg_variable_6445", "homalg_variable_6446", "homalg_variable_6447", "homalg_variable_6448", "homalg_variable_6449", "homalg_variable_6450", "homalg_variable_6451", "homalg_variable_6452", "homalg_variable_6453", "homalg_variable_6454", "homalg_variable_6456", "homalg_variable_6457", "homalg_variable_6458", "homalg_variable_6459", "homalg_variable_6460", "homalg_variable_6461", "homalg_variable_6462", "homalg_variable_6463", "homalg_variable_6464", "homalg_variable_6465", "homalg_variable_6466", "homalg_variable_6467", "homalg_variable_6468", "homalg_variable_6469", "homalg_variable_6471", "homalg_variable_6474", "homalg_variable_6475", "homalg_variable_6479", "homalg_variable_6480", "homalg_variable_6481", "homalg_variable_6482", "homalg_variable_6485", "homalg_variable_6488", "homalg_variable_6489", "homalg_variable_6490" ] do UnbindGlobal( _del );; od;;
gap> homalg_variable_6501 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_6500 = homalg_variable_6501;
false
gap> homalg_variable_6502 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_6500);;
gap> SI_ncols(homalg_variable_6502);
3
gap> homalg_variable_6503 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_6502 = homalg_variable_6503;
false
gap> homalg_variable_6504 := SI_\[(homalg_variable_6502,3,1);;
gap> SI_deg( homalg_variable_6504 );
-1
gap> homalg_variable_6505 := SI_\[(homalg_variable_6502,2,1);;
gap> SI_deg( homalg_variable_6505 );
1
gap> homalg_variable_6506 := SI_\[(homalg_variable_6502,1,1);;
gap> SI_deg( homalg_variable_6506 );
1
gap> homalg_variable_6507 := SI_\[(homalg_variable_6502,3,2);;
gap> SI_deg( homalg_variable_6507 );
1
gap> homalg_variable_6508 := SI_\[(homalg_variable_6502,2,2);;
gap> SI_deg( homalg_variable_6508 );
1
gap> homalg_variable_6509 := SI_\[(homalg_variable_6502,1,2);;
gap> SI_deg( homalg_variable_6509 );
-1
gap> homalg_variable_6510 := SI_\[(homalg_variable_6502,3,3);;
gap> SI_deg( homalg_variable_6510 );
1
gap> homalg_variable_6511 := SI_\[(homalg_variable_6502,2,3);;
gap> SI_deg( homalg_variable_6511 );
-1
gap> homalg_variable_6512 := SI_\[(homalg_variable_6502,1,3);;
gap> SI_deg( homalg_variable_6512 );
1
gap> homalg_variable_6513 := SIH_BasisOfColumnModule(homalg_variable_6500);;
gap> SI_ncols(homalg_variable_6513);
3
gap> homalg_variable_6514 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_6513 = homalg_variable_6514;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6500);; homalg_variable_6515 := homalg_variable_l[1];; homalg_variable_6516 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6515);
3
gap> homalg_variable_6517 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_6515 = homalg_variable_6517;
false
gap> SI_nrows(homalg_variable_6516);
3
gap> homalg_variable_6518 := homalg_variable_6500 * homalg_variable_6516;;
gap> homalg_variable_6515 = homalg_variable_6518;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6513,homalg_variable_6515);; homalg_variable_6519 := homalg_variable_l[1];; homalg_variable_6520 := homalg_variable_l[2];;
gap> homalg_variable_6521 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_6519 = homalg_variable_6521;
true
gap> homalg_variable_6522 := homalg_variable_6515 * homalg_variable_6520;;
gap> homalg_variable_6523 := homalg_variable_6513 + homalg_variable_6522;;
gap> homalg_variable_6519 = homalg_variable_6523;
true
gap> homalg_variable_6524 := SIH_DecideZeroColumns(homalg_variable_6513,homalg_variable_6515);;
gap> homalg_variable_6525 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_6524 = homalg_variable_6525;
true
gap> homalg_variable_6526 := homalg_variable_6520 * (homalg_variable_8);;
gap> homalg_variable_6527 := homalg_variable_6516 * homalg_variable_6526;;
gap> homalg_variable_6528 := homalg_variable_6500 * homalg_variable_6527;;
gap> homalg_variable_6528 = homalg_variable_6513;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6500,homalg_variable_6513);; homalg_variable_6529 := homalg_variable_l[1];; homalg_variable_6530 := homalg_variable_l[2];;
gap> homalg_variable_6531 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_6529 = homalg_variable_6531;
true
gap> homalg_variable_6532 := homalg_variable_6513 * homalg_variable_6530;;
gap> homalg_variable_6533 := homalg_variable_6500 + homalg_variable_6532;;
gap> homalg_variable_6529 = homalg_variable_6533;
true
gap> homalg_variable_6534 := SIH_DecideZeroColumns(homalg_variable_6500,homalg_variable_6513);;
gap> homalg_variable_6535 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_6534 = homalg_variable_6535;
true
gap> homalg_variable_6536 := homalg_variable_6530 * (homalg_variable_8);;
gap> homalg_variable_6537 := homalg_variable_6513 * homalg_variable_6536;;
gap> homalg_variable_6537 = homalg_variable_6500;
true
gap> homalg_variable_6538 := SIH_DecideZeroColumns(homalg_variable_6500,homalg_variable_3336);;
gap> homalg_variable_6539 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_6538 = homalg_variable_6539;
true
gap> homalg_variable_6541 := SIH_UnionOfColumns(homalg_variable_6324,homalg_variable_6301);;
gap> homalg_variable_6540 := SIH_BasisOfColumnModule(homalg_variable_6541);;
gap> SI_ncols(homalg_variable_6540);
8
gap> homalg_variable_6542 := SI_matrix(homalg_variable_5,6,8,"0");;
gap> homalg_variable_6540 = homalg_variable_6542;
false
gap> homalg_variable_6543 := SIH_DecideZeroColumns(homalg_variable_6324,homalg_variable_6540);;
gap> homalg_variable_6544 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_6543 = homalg_variable_6544;
true
gap> homalg_variable_6546 := homalg_variable_6347 * homalg_variable_3419;;
gap> homalg_variable_6545 := SIH_DecideZeroColumns(homalg_variable_6546,homalg_variable_6540);;
gap> homalg_variable_6547 := SI_matrix(homalg_variable_5,6,2,"0");;
gap> homalg_variable_6545 = homalg_variable_6547;
true
gap> homalg_variable_6548 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_6347,homalg_variable_6541);;
gap> SI_ncols(homalg_variable_6548);
2
gap> homalg_variable_6549 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_6548 = homalg_variable_6549;
false
gap> homalg_variable_6550 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_6548);;
gap> SI_ncols(homalg_variable_6550);
1
gap> homalg_variable_6551 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_6550 = homalg_variable_6551;
false
gap> homalg_variable_6552 := SI_\[(homalg_variable_6550,2,1);;
gap> SI_deg( homalg_variable_6552 );
1
gap> homalg_variable_6553 := SI_\[(homalg_variable_6550,1,1);;
gap> SI_deg( homalg_variable_6553 );
1
gap> homalg_variable_6554 := SIH_BasisOfColumnModule(homalg_variable_6548);;
gap> SI_ncols(homalg_variable_6554);
2
gap> homalg_variable_6555 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_6554 = homalg_variable_6555;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6548);; homalg_variable_6556 := homalg_variable_l[1];; homalg_variable_6557 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6556);
2
gap> homalg_variable_6558 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_6556 = homalg_variable_6558;
false
gap> SI_nrows(homalg_variable_6557);
2
gap> homalg_variable_6559 := homalg_variable_6548 * homalg_variable_6557;;
gap> homalg_variable_6556 = homalg_variable_6559;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6554,homalg_variable_6556);; homalg_variable_6560 := homalg_variable_l[1];; homalg_variable_6561 := homalg_variable_l[2];;
gap> homalg_variable_6562 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_6560 = homalg_variable_6562;
true
gap> homalg_variable_6563 := homalg_variable_6556 * homalg_variable_6561;;
gap> homalg_variable_6564 := homalg_variable_6554 + homalg_variable_6563;;
gap> homalg_variable_6560 = homalg_variable_6564;
true
gap> homalg_variable_6565 := SIH_DecideZeroColumns(homalg_variable_6554,homalg_variable_6556);;
gap> homalg_variable_6566 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_6565 = homalg_variable_6566;
true
gap> homalg_variable_6567 := homalg_variable_6561 * (homalg_variable_8);;
gap> homalg_variable_6568 := homalg_variable_6557 * homalg_variable_6567;;
gap> homalg_variable_6569 := homalg_variable_6548 * homalg_variable_6568;;
gap> homalg_variable_6569 = homalg_variable_6554;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6548,homalg_variable_6554);; homalg_variable_6570 := homalg_variable_l[1];; homalg_variable_6571 := homalg_variable_l[2];;
gap> homalg_variable_6572 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_6570 = homalg_variable_6572;
true
gap> homalg_variable_6573 := homalg_variable_6554 * homalg_variable_6571;;
gap> homalg_variable_6574 := homalg_variable_6548 + homalg_variable_6573;;
gap> homalg_variable_6570 = homalg_variable_6574;
true
gap> homalg_variable_6575 := SIH_DecideZeroColumns(homalg_variable_6548,homalg_variable_6554);;
gap> homalg_variable_6576 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_6575 = homalg_variable_6576;
true
gap> homalg_variable_6577 := homalg_variable_6571 * (homalg_variable_8);;
gap> homalg_variable_6578 := homalg_variable_6554 * homalg_variable_6577;;
gap> homalg_variable_6578 = homalg_variable_6548;
true
gap> homalg_variable_6579 := SIH_DecideZeroColumns(homalg_variable_6548,homalg_variable_3419);;
gap> homalg_variable_6580 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_6579 = homalg_variable_6580;
true
gap> homalg_variable_6581 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_6175,homalg_variable_5641);;
gap> SI_ncols(homalg_variable_6581);
8
gap> homalg_variable_6582 := SI_matrix(homalg_variable_5,6,8,"0");;
gap> homalg_variable_6581 = homalg_variable_6582;
false
gap> homalg_variable_6583 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_6581);;
gap> SI_ncols(homalg_variable_6583);
2
gap> homalg_variable_6584 := SI_matrix(homalg_variable_5,8,2,"0");;
gap> homalg_variable_6583 = homalg_variable_6584;
false
gap> homalg_variable_6585 := SI_\[(homalg_variable_6583,8,1);;
gap> SI_deg( homalg_variable_6585 );
-1
gap> homalg_variable_6586 := SI_\[(homalg_variable_6583,7,1);;
gap> SI_deg( homalg_variable_6586 );
-1
gap> homalg_variable_6587 := SI_\[(homalg_variable_6583,6,1);;
gap> SI_deg( homalg_variable_6587 );
-1
gap> homalg_variable_6588 := SI_\[(homalg_variable_6583,5,1);;
gap> SI_deg( homalg_variable_6588 );
1
gap> homalg_variable_6589 := SI_\[(homalg_variable_6583,4,1);;
gap> SI_deg( homalg_variable_6589 );
-1
gap> homalg_variable_6590 := SI_\[(homalg_variable_6583,3,1);;
gap> SI_deg( homalg_variable_6590 );
1
gap> homalg_variable_6591 := SI_\[(homalg_variable_6583,2,1);;
gap> SI_deg( homalg_variable_6591 );
-1
gap> homalg_variable_6592 := SI_\[(homalg_variable_6583,1,1);;
gap> SI_deg( homalg_variable_6592 );
-1
gap> homalg_variable_6593 := SI_\[(homalg_variable_6583,8,2);;
gap> SI_deg( homalg_variable_6593 );
-1
gap> homalg_variable_6594 := SI_\[(homalg_variable_6583,7,2);;
gap> SI_deg( homalg_variable_6594 );
1
gap> homalg_variable_6595 := SI_\[(homalg_variable_6583,6,2);;
gap> SI_deg( homalg_variable_6595 );
1
gap> homalg_variable_6596 := SI_\[(homalg_variable_6583,5,2);;
gap> SI_deg( homalg_variable_6596 );
-1
gap> homalg_variable_6597 := SI_\[(homalg_variable_6583,4,2);;
gap> SI_deg( homalg_variable_6597 );
1
gap> homalg_variable_6598 := SI_\[(homalg_variable_6583,3,2);;
gap> SI_deg( homalg_variable_6598 );
0
gap> homalg_variable_6599 := SI_\[(homalg_variable_6583,1,2);;
gap> IsZero(homalg_variable_6599);
true
gap> homalg_variable_6600 := SI_\[(homalg_variable_6583,2,2);;
gap> IsZero(homalg_variable_6600);
true
gap> homalg_variable_6601 := SI_\[(homalg_variable_6583,3,2);;
gap> IsZero(homalg_variable_6601);
false
gap> homalg_variable_6602 := SI_\[(homalg_variable_6583,4,2);;
gap> IsZero(homalg_variable_6602);
false
gap> homalg_variable_6603 := SI_\[(homalg_variable_6583,5,2);;
gap> IsZero(homalg_variable_6603);
true
gap> homalg_variable_6604 := SI_\[(homalg_variable_6583,6,2);;
gap> IsZero(homalg_variable_6604);
false
gap> homalg_variable_6605 := SI_\[(homalg_variable_6583,7,2);;
gap> IsZero(homalg_variable_6605);
false
gap> homalg_variable_6606 := SI_\[(homalg_variable_6583,8,2);;
gap> IsZero(homalg_variable_6606);
true
gap> homalg_variable_6608 := SIH_Submatrix(homalg_variable_6581,[1..6],[ 1, 2, 4, 5, 6, 7, 8 ]);;
gap> homalg_variable_6607 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_6608);;
gap> SI_ncols(homalg_variable_6607);
1
gap> homalg_variable_6609 := SI_matrix(homalg_variable_5,7,1,"0");;
gap> homalg_variable_6607 = homalg_variable_6609;
false
gap> homalg_variable_6610 := SI_\[(homalg_variable_6607,7,1);;
gap> SI_deg( homalg_variable_6610 );
-1
gap> homalg_variable_6611 := SI_\[(homalg_variable_6607,6,1);;
gap> SI_deg( homalg_variable_6611 );
2
gap> homalg_variable_6612 := SI_\[(homalg_variable_6607,5,1);;
gap> SI_deg( homalg_variable_6612 );
2
gap> homalg_variable_6613 := SI_\[(homalg_variable_6607,4,1);;
gap> SI_deg( homalg_variable_6613 );
1
gap> homalg_variable_6614 := SI_\[(homalg_variable_6607,3,1);;
gap> SI_deg( homalg_variable_6614 );
2
gap> homalg_variable_6615 := SI_\[(homalg_variable_6607,2,1);;
gap> SI_deg( homalg_variable_6615 );
-1
gap> homalg_variable_6616 := SI_\[(homalg_variable_6607,1,1);;
gap> SI_deg( homalg_variable_6616 );
-1
gap> homalg_variable_6617 := SI_matrix(homalg_variable_5,6,7,"0");;
gap> homalg_variable_6608 = homalg_variable_6617;
false
gap> homalg_variable_6618 := SIH_BasisOfColumnModule(homalg_variable_6581);;
gap> SI_ncols(homalg_variable_6618);
8
gap> homalg_variable_6619 := SI_matrix(homalg_variable_5,6,8,"0");;
gap> homalg_variable_6618 = homalg_variable_6619;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6608);; homalg_variable_6620 := homalg_variable_l[1];; homalg_variable_6621 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6620);
8
gap> homalg_variable_6622 := SI_matrix(homalg_variable_5,6,8,"0");;
gap> homalg_variable_6620 = homalg_variable_6622;
false
gap> SI_nrows(homalg_variable_6621);
7
gap> homalg_variable_6623 := homalg_variable_6608 * homalg_variable_6621;;
gap> homalg_variable_6620 = homalg_variable_6623;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6618,homalg_variable_6620);; homalg_variable_6624 := homalg_variable_l[1];; homalg_variable_6625 := homalg_variable_l[2];;
gap> homalg_variable_6626 := SI_matrix(homalg_variable_5,6,8,"0");;
gap> homalg_variable_6624 = homalg_variable_6626;
true
gap> homalg_variable_6627 := homalg_variable_6620 * homalg_variable_6625;;
gap> homalg_variable_6628 := homalg_variable_6618 + homalg_variable_6627;;
gap> homalg_variable_6624 = homalg_variable_6628;
true
gap> homalg_variable_6629 := SIH_DecideZeroColumns(homalg_variable_6618,homalg_variable_6620);;
gap> homalg_variable_6630 := SI_matrix(homalg_variable_5,6,8,"0");;
gap> homalg_variable_6629 = homalg_variable_6630;
true
gap> homalg_variable_6631 := homalg_variable_6625 * (homalg_variable_8);;
gap> homalg_variable_6632 := homalg_variable_6621 * homalg_variable_6631;;
gap> homalg_variable_6633 := homalg_variable_6608 * homalg_variable_6632;;
gap> homalg_variable_6633 = homalg_variable_6618;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6608,homalg_variable_6618);; homalg_variable_6634 := homalg_variable_l[1];; homalg_variable_6635 := homalg_variable_l[2];;
gap> homalg_variable_6636 := SI_matrix(homalg_variable_5,6,7,"0");;
gap> homalg_variable_6634 = homalg_variable_6636;
true
gap> homalg_variable_6637 := homalg_variable_6618 * homalg_variable_6635;;
gap> homalg_variable_6638 := homalg_variable_6608 + homalg_variable_6637;;
gap> homalg_variable_6634 = homalg_variable_6638;
true
gap> homalg_variable_6639 := SIH_DecideZeroColumns(homalg_variable_6608,homalg_variable_6618);;
gap> homalg_variable_6640 := SI_matrix(homalg_variable_5,6,7,"0");;
gap> homalg_variable_6639 = homalg_variable_6640;
true
gap> homalg_variable_6641 := homalg_variable_6635 * (homalg_variable_8);;
gap> homalg_variable_6642 := homalg_variable_6618 * homalg_variable_6641;;
gap> homalg_variable_6642 = homalg_variable_6608;
true
gap> homalg_variable_6644 := SIH_UnionOfColumns(homalg_variable_6324,homalg_variable_6347);;
gap> homalg_variable_6645 := SIH_UnionOfColumns(homalg_variable_6644,homalg_variable_6301);;
gap> homalg_variable_6643 := SIH_BasisOfColumnModule(homalg_variable_6645);;
gap> SI_ncols(homalg_variable_6643);
7
gap> homalg_variable_6646 := SI_matrix(homalg_variable_5,6,7,"0");;
gap> homalg_variable_6643 = homalg_variable_6646;
false
gap> homalg_variable_6647 := SIH_DecideZeroColumns(homalg_variable_6644,homalg_variable_6643);;
gap> homalg_variable_6648 := SI_matrix(homalg_variable_5,6,2,"0");;
gap> homalg_variable_6647 = homalg_variable_6648;
true
gap> homalg_variable_6650 := homalg_variable_6370 * homalg_variable_5877;;
gap> homalg_variable_6649 := SIH_DecideZeroColumns(homalg_variable_6650,homalg_variable_6643);;
gap> homalg_variable_6651 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_6649 = homalg_variable_6651;
true
gap> homalg_variable_6652 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_6370,homalg_variable_6645);;
gap> SI_ncols(homalg_variable_6652);
4
gap> homalg_variable_6653 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_6652 = homalg_variable_6653;
false
gap> homalg_variable_6654 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_6652);;
gap> SI_ncols(homalg_variable_6654);
1
gap> homalg_variable_6655 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_6654 = homalg_variable_6655;
false
gap> homalg_variable_6656 := SI_\[(homalg_variable_6654,4,1);;
gap> SI_deg( homalg_variable_6656 );
-1
gap> homalg_variable_6657 := SI_\[(homalg_variable_6654,3,1);;
gap> SI_deg( homalg_variable_6657 );
1
gap> homalg_variable_6658 := SI_\[(homalg_variable_6654,2,1);;
gap> SI_deg( homalg_variable_6658 );
1
gap> homalg_variable_6659 := SI_\[(homalg_variable_6654,1,1);;
gap> SI_deg( homalg_variable_6659 );
1
gap> homalg_variable_6660 := SIH_BasisOfColumnModule(homalg_variable_6652);;
gap> SI_ncols(homalg_variable_6660);
4
gap> homalg_variable_6661 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_6660 = homalg_variable_6661;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6652);; homalg_variable_6662 := homalg_variable_l[1];; homalg_variable_6663 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6662);
4
gap> homalg_variable_6664 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_6662 = homalg_variable_6664;
false
gap> SI_nrows(homalg_variable_6663);
4
gap> homalg_variable_6665 := homalg_variable_6652 * homalg_variable_6663;;
gap> homalg_variable_6662 = homalg_variable_6665;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6660,homalg_variable_6662);; homalg_variable_6666 := homalg_variable_l[1];; homalg_variable_6667 := homalg_variable_l[2];;
gap> homalg_variable_6668 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_6666 = homalg_variable_6668;
true
gap> homalg_variable_6669 := homalg_variable_6662 * homalg_variable_6667;;
gap> homalg_variable_6670 := homalg_variable_6660 + homalg_variable_6669;;
gap> homalg_variable_6666 = homalg_variable_6670;
true
gap> homalg_variable_6671 := SIH_DecideZeroColumns(homalg_variable_6660,homalg_variable_6662);;
gap> homalg_variable_6672 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_6671 = homalg_variable_6672;
true
gap> homalg_variable_6673 := homalg_variable_6667 * (homalg_variable_8);;
gap> homalg_variable_6674 := homalg_variable_6663 * homalg_variable_6673;;
gap> homalg_variable_6675 := homalg_variable_6652 * homalg_variable_6674;;
gap> homalg_variable_6675 = homalg_variable_6660;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6652,homalg_variable_6660);; homalg_variable_6676 := homalg_variable_l[1];; homalg_variable_6677 := homalg_variable_l[2];;
gap> homalg_variable_6678 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_6676 = homalg_variable_6678;
true
gap> homalg_variable_6679 := homalg_variable_6660 * homalg_variable_6677;;
gap> homalg_variable_6680 := homalg_variable_6652 + homalg_variable_6679;;
gap> homalg_variable_6676 = homalg_variable_6680;
true
gap> homalg_variable_6681 := SIH_DecideZeroColumns(homalg_variable_6652,homalg_variable_6660);;
gap> homalg_variable_6682 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_6681 = homalg_variable_6682;
true
gap> homalg_variable_6683 := homalg_variable_6677 * (homalg_variable_8);;
gap> homalg_variable_6684 := homalg_variable_6660 * homalg_variable_6683;;
gap> homalg_variable_6684 = homalg_variable_6652;
true
gap> homalg_variable_6685 := SIH_DecideZeroColumns(homalg_variable_6652,homalg_variable_5877);;
gap> homalg_variable_6686 := SI_matrix(homalg_variable_5,3,4,"0");;
gap> homalg_variable_6685 = homalg_variable_6686;
true
gap> homalg_variable_6688 := SIH_UnionOfColumns(homalg_variable_6370,homalg_variable_6645);;
gap> homalg_variable_6687 := SIH_BasisOfColumnModule(homalg_variable_6688);;
gap> SI_ncols(homalg_variable_6687);
6
gap> homalg_variable_6689 := SI_matrix(homalg_variable_5,6,6,"0");;
gap> homalg_variable_6687 = homalg_variable_6689;
false
gap> homalg_variable_6691 := SI_matrix( SI_freemodule( homalg_variable_5,6 ) );;
gap> homalg_variable_6690 := SIH_DecideZeroColumns(homalg_variable_6691,homalg_variable_6687);;
gap> homalg_variable_6692 := SI_matrix(homalg_variable_5,6,6,"0");;
gap> homalg_variable_6690 = homalg_variable_6692;
true
gap> homalg_variable_6693 := SIH_DecideZeroColumns(homalg_variable_6370,homalg_variable_6643);;
gap> homalg_variable_6694 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_6693 = homalg_variable_6694;
false
gap> homalg_variable_6695 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_6370 = homalg_variable_6695;
false
gap> homalg_variable_6696 := SIH_UnionOfColumns(homalg_variable_6693,homalg_variable_6643);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6696);; homalg_variable_6697 := homalg_variable_l[1];; homalg_variable_6698 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6697);
6
gap> homalg_variable_6699 := SI_matrix(homalg_variable_5,6,6,"0");;
gap> homalg_variable_6697 = homalg_variable_6699;
false
gap> SI_nrows(homalg_variable_6698);
10
gap> homalg_variable_6700 := SIH_Submatrix(homalg_variable_6698,[ 1, 2, 3 ],[1..6]);;
gap> homalg_variable_6701 := homalg_variable_6693 * homalg_variable_6700;;
gap> homalg_variable_6702 := SIH_Submatrix(homalg_variable_6698,[ 4, 5, 6, 7, 8, 9, 10 ],[1..6]);;
gap> homalg_variable_6703 := homalg_variable_6643 * homalg_variable_6702;;
gap> homalg_variable_6704 := homalg_variable_6701 + homalg_variable_6703;;
gap> homalg_variable_6697 = homalg_variable_6704;
true
gap> homalg_variable_6705 := SIH_DecideZeroColumns(homalg_variable_6691,homalg_variable_6643);;
gap> homalg_variable_6706 := SI_matrix(homalg_variable_5,6,6,"0");;
gap> homalg_variable_6705 = homalg_variable_6706;
false
gap> homalg_variable_6697 = homalg_variable_6691;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6705,homalg_variable_6697);; homalg_variable_6707 := homalg_variable_l[1];; homalg_variable_6708 := homalg_variable_l[2];;
gap> homalg_variable_6709 := SI_matrix(homalg_variable_5,6,6,"0");;
gap> homalg_variable_6707 = homalg_variable_6709;
true
gap> homalg_variable_6710 := homalg_variable_6697 * homalg_variable_6708;;
gap> homalg_variable_6711 := homalg_variable_6705 + homalg_variable_6710;;
gap> homalg_variable_6707 = homalg_variable_6711;
true
gap> homalg_variable_6712 := SIH_DecideZeroColumns(homalg_variable_6705,homalg_variable_6697);;
gap> homalg_variable_6713 := SI_matrix(homalg_variable_5,6,6,"0");;
gap> homalg_variable_6712 = homalg_variable_6713;
true
gap> homalg_variable_6715 := SIH_Submatrix(homalg_variable_6698,[ 1, 2, 3 ],[1..6]);;
gap> homalg_variable_6716 := homalg_variable_6708 * (homalg_variable_8);;
gap> homalg_variable_6717 := homalg_variable_6715 * homalg_variable_6716;;
gap> homalg_variable_6718 := homalg_variable_6370 * homalg_variable_6717;;
gap> homalg_variable_6719 := homalg_variable_6718 - homalg_variable_6691;;
gap> homalg_variable_6714 := SIH_DecideZeroColumns(homalg_variable_6719,homalg_variable_6643);;
gap> homalg_variable_6720 := SI_matrix(homalg_variable_5,6,6,"0");;
gap> homalg_variable_6714 = homalg_variable_6720;
true
gap> homalg_variable_6722 := homalg_variable_6717 * homalg_variable_6301;;
gap> homalg_variable_6721 := SIH_DecideZeroColumns(homalg_variable_6722,homalg_variable_5877);;
gap> homalg_variable_6723 := SI_matrix(homalg_variable_5,3,10,"0");;
gap> homalg_variable_6721 = homalg_variable_6723;
true
gap> homalg_variable_6724 := SIH_DecideZeroColumns(homalg_variable_6644,homalg_variable_6301);;
gap> homalg_variable_6725 := SI_matrix(homalg_variable_5,6,2,"0");;
gap> homalg_variable_6724 = homalg_variable_6725;
false
gap> homalg_variable_6726 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_6324 = homalg_variable_6726;
false
gap> SIH_ZeroColumns(homalg_variable_6724);
[  ]
gap> homalg_variable_6727 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_6724,homalg_variable_6301);;
gap> SI_ncols(homalg_variable_6727);
5
gap> homalg_variable_6728 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6727 = homalg_variable_6728;
false
gap> homalg_variable_6730 := homalg_variable_6724 * homalg_variable_6727;;
gap> homalg_variable_6729 := SIH_DecideZeroColumns(homalg_variable_6730,homalg_variable_6301);;
gap> homalg_variable_6731 := SI_matrix(homalg_variable_5,6,5,"0");;
gap> homalg_variable_6729 = homalg_variable_6731;
true
gap> homalg_variable_6732 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_6724,homalg_variable_6301);;
gap> SI_ncols(homalg_variable_6732);
5
gap> homalg_variable_6733 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6732 = homalg_variable_6733;
false
gap> homalg_variable_6734 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_6732);;
gap> SI_ncols(homalg_variable_6734);
4
gap> homalg_variable_6735 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_6734 = homalg_variable_6735;
false
gap> homalg_variable_6736 := SI_\[(homalg_variable_6734,5,1);;
gap> SI_deg( homalg_variable_6736 );
-1
gap> homalg_variable_6737 := SI_\[(homalg_variable_6734,4,1);;
gap> SI_deg( homalg_variable_6737 );
1
gap> homalg_variable_6738 := SI_\[(homalg_variable_6734,3,1);;
gap> SI_deg( homalg_variable_6738 );
-1
gap> homalg_variable_6739 := SI_\[(homalg_variable_6734,2,1);;
gap> SI_deg( homalg_variable_6739 );
1
gap> homalg_variable_6740 := SI_\[(homalg_variable_6734,1,1);;
gap> SI_deg( homalg_variable_6740 );
-1
gap> homalg_variable_6741 := SI_\[(homalg_variable_6734,5,2);;
gap> SI_deg( homalg_variable_6741 );
-1
gap> homalg_variable_6742 := SI_\[(homalg_variable_6734,4,2);;
gap> SI_deg( homalg_variable_6742 );
-1
gap> homalg_variable_6743 := SI_\[(homalg_variable_6734,3,2);;
gap> SI_deg( homalg_variable_6743 );
1
gap> homalg_variable_6744 := SI_\[(homalg_variable_6734,2,2);;
gap> SI_deg( homalg_variable_6744 );
-1
gap> homalg_variable_6745 := SI_\[(homalg_variable_6734,1,2);;
gap> SI_deg( homalg_variable_6745 );
1
gap> homalg_variable_6746 := SI_\[(homalg_variable_6734,5,3);;
gap> SI_deg( homalg_variable_6746 );
1
gap> homalg_variable_6747 := SI_\[(homalg_variable_6734,4,3);;
gap> SI_deg( homalg_variable_6747 );
1
gap> homalg_variable_6748 := SI_\[(homalg_variable_6734,3,3);;
gap> SI_deg( homalg_variable_6748 );
-1
gap> homalg_variable_6749 := SI_\[(homalg_variable_6734,2,3);;
gap> SI_deg( homalg_variable_6749 );
-1
gap> homalg_variable_6750 := SI_\[(homalg_variable_6734,1,3);;
gap> SI_deg( homalg_variable_6750 );
-1
gap> homalg_variable_6751 := SI_\[(homalg_variable_6734,5,4);;
gap> SI_deg( homalg_variable_6751 );
1
gap> homalg_variable_6752 := SI_\[(homalg_variable_6734,4,4);;
gap> SI_deg( homalg_variable_6752 );
-1
gap> homalg_variable_6753 := SI_\[(homalg_variable_6734,3,4);;
gap> SI_deg( homalg_variable_6753 );
-1
gap> homalg_variable_6754 := SI_\[(homalg_variable_6734,2,4);;
gap> SI_deg( homalg_variable_6754 );
1
gap> homalg_variable_6755 := SI_\[(homalg_variable_6734,1,4);;
gap> SI_deg( homalg_variable_6755 );
-1
gap> homalg_variable_6756 := SIH_BasisOfColumnModule(homalg_variable_6732);;
gap> SI_ncols(homalg_variable_6756);
5
gap> homalg_variable_6757 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6756 = homalg_variable_6757;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6732);; homalg_variable_6758 := homalg_variable_l[1];; homalg_variable_6759 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6758);
5
gap> homalg_variable_6760 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6758 = homalg_variable_6760;
false
gap> SI_nrows(homalg_variable_6759);
5
gap> homalg_variable_6761 := homalg_variable_6732 * homalg_variable_6759;;
gap> homalg_variable_6758 = homalg_variable_6761;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6756,homalg_variable_6758);; homalg_variable_6762 := homalg_variable_l[1];; homalg_variable_6763 := homalg_variable_l[2];;
gap> homalg_variable_6764 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6762 = homalg_variable_6764;
true
gap> homalg_variable_6765 := homalg_variable_6758 * homalg_variable_6763;;
gap> homalg_variable_6766 := homalg_variable_6756 + homalg_variable_6765;;
gap> homalg_variable_6762 = homalg_variable_6766;
true
gap> homalg_variable_6767 := SIH_DecideZeroColumns(homalg_variable_6756,homalg_variable_6758);;
gap> homalg_variable_6768 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6767 = homalg_variable_6768;
true
gap> homalg_variable_6769 := homalg_variable_6763 * (homalg_variable_8);;
gap> homalg_variable_6770 := homalg_variable_6759 * homalg_variable_6769;;
gap> homalg_variable_6771 := homalg_variable_6732 * homalg_variable_6770;;
gap> homalg_variable_6771 = homalg_variable_6756;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6732,homalg_variable_6756);; homalg_variable_6772 := homalg_variable_l[1];; homalg_variable_6773 := homalg_variable_l[2];;
gap> homalg_variable_6774 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6772 = homalg_variable_6774;
true
gap> homalg_variable_6775 := homalg_variable_6756 * homalg_variable_6773;;
gap> homalg_variable_6776 := homalg_variable_6732 + homalg_variable_6775;;
gap> homalg_variable_6772 = homalg_variable_6776;
true
gap> homalg_variable_6777 := SIH_DecideZeroColumns(homalg_variable_6732,homalg_variable_6756);;
gap> homalg_variable_6778 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6777 = homalg_variable_6778;
true
gap> homalg_variable_6779 := homalg_variable_6773 * (homalg_variable_8);;
gap> homalg_variable_6780 := homalg_variable_6756 * homalg_variable_6779;;
gap> homalg_variable_6780 = homalg_variable_6732;
true
gap> homalg_variable_6781 := SIH_BasisOfColumnModule(homalg_variable_6727);;
gap> SI_ncols(homalg_variable_6781);
5
gap> homalg_variable_6782 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6781 = homalg_variable_6782;
false
gap> homalg_variable_6781 = homalg_variable_6727;
true
gap> homalg_variable_6783 := SIH_DecideZeroColumns(homalg_variable_6732,homalg_variable_6781);;
gap> homalg_variable_6784 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6783 = homalg_variable_6784;
true
gap> homalg_variable_6785 := SIH_UnionOfColumns(homalg_variable_6724,homalg_variable_6301);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6785);; homalg_variable_6786 := homalg_variable_l[1];; homalg_variable_6787 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6786);
7
gap> homalg_variable_6788 := SI_matrix(homalg_variable_5,6,7,"0");;
gap> homalg_variable_6786 = homalg_variable_6788;
false
gap> SI_nrows(homalg_variable_6787);
12
gap> homalg_variable_6789 := SIH_Submatrix(homalg_variable_6787,[ 1, 2 ],[1..7]);;
gap> homalg_variable_6790 := homalg_variable_6724 * homalg_variable_6789;;
gap> homalg_variable_6791 := SIH_Submatrix(homalg_variable_6787,[ 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ],[1..7]);;
gap> homalg_variable_6792 := homalg_variable_6301 * homalg_variable_6791;;
gap> homalg_variable_6793 := homalg_variable_6790 + homalg_variable_6792;;
gap> homalg_variable_6786 = homalg_variable_6793;
true
gap> homalg_variable_6794 := SIH_DecideZeroColumns(homalg_variable_6324,homalg_variable_6301);;
gap> homalg_variable_6795 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_6794 = homalg_variable_6795;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6794,homalg_variable_6786);; homalg_variable_6796 := homalg_variable_l[1];; homalg_variable_6797 := homalg_variable_l[2];;
gap> homalg_variable_6798 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_6796 = homalg_variable_6798;
true
gap> homalg_variable_6799 := homalg_variable_6786 * homalg_variable_6797;;
gap> homalg_variable_6800 := homalg_variable_6794 + homalg_variable_6799;;
gap> homalg_variable_6796 = homalg_variable_6800;
true
gap> homalg_variable_6801 := SIH_DecideZeroColumns(homalg_variable_6794,homalg_variable_6786);;
gap> homalg_variable_6802 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_6801 = homalg_variable_6802;
true
gap> homalg_variable_6804 := SIH_Submatrix(homalg_variable_6787,[ 1, 2 ],[1..7]);;
gap> homalg_variable_6805 := homalg_variable_6797 * (homalg_variable_8);;
gap> homalg_variable_6806 := homalg_variable_6804 * homalg_variable_6805;;
gap> homalg_variable_6807 := homalg_variable_6724 * homalg_variable_6806;;
gap> homalg_variable_6808 := homalg_variable_6807 - homalg_variable_6324;;
gap> homalg_variable_6803 := SIH_DecideZeroColumns(homalg_variable_6808,homalg_variable_6301);;
gap> homalg_variable_6809 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_6803 = homalg_variable_6809;
true
gap> homalg_variable_6810 := SIH_UnionOfColumns(homalg_variable_6724,homalg_variable_6301);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6810);; homalg_variable_6811 := homalg_variable_l[1];; homalg_variable_6812 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6811);
7
gap> homalg_variable_6813 := SI_matrix(homalg_variable_5,6,7,"0");;
gap> homalg_variable_6811 = homalg_variable_6813;
false
gap> SI_nrows(homalg_variable_6812);
12
gap> homalg_variable_6814 := SIH_Submatrix(homalg_variable_6812,[ 1, 2 ],[1..7]);;
gap> homalg_variable_6815 := homalg_variable_6724 * homalg_variable_6814;;
gap> homalg_variable_6816 := SIH_Submatrix(homalg_variable_6812,[ 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ],[1..7]);;
gap> homalg_variable_6817 := homalg_variable_6301 * homalg_variable_6816;;
gap> homalg_variable_6818 := homalg_variable_6815 + homalg_variable_6817;;
gap> homalg_variable_6811 = homalg_variable_6818;
true
gap> homalg_variable_6819 := SIH_DecideZeroColumns(homalg_variable_6347,homalg_variable_6301);;
gap> homalg_variable_6820 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_6819 = homalg_variable_6820;
false
gap> homalg_variable_6821 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_6347 = homalg_variable_6821;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6819,homalg_variable_6811);; homalg_variable_6822 := homalg_variable_l[1];; homalg_variable_6823 := homalg_variable_l[2];;
gap> homalg_variable_6824 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_6822 = homalg_variable_6824;
true
gap> homalg_variable_6825 := homalg_variable_6811 * homalg_variable_6823;;
gap> homalg_variable_6826 := homalg_variable_6819 + homalg_variable_6825;;
gap> homalg_variable_6822 = homalg_variable_6826;
true
gap> homalg_variable_6827 := SIH_DecideZeroColumns(homalg_variable_6819,homalg_variable_6811);;
gap> homalg_variable_6828 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_6827 = homalg_variable_6828;
true
gap> homalg_variable_6830 := SIH_Submatrix(homalg_variable_6812,[ 1, 2 ],[1..7]);;
gap> homalg_variable_6831 := homalg_variable_6823 * (homalg_variable_8);;
gap> homalg_variable_6832 := homalg_variable_6830 * homalg_variable_6831;;
gap> homalg_variable_6833 := homalg_variable_6724 * homalg_variable_6832;;
gap> homalg_variable_6834 := homalg_variable_6833 - homalg_variable_6347;;
gap> homalg_variable_6829 := SIH_DecideZeroColumns(homalg_variable_6834,homalg_variable_6301);;
gap> homalg_variable_6835 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_6829 = homalg_variable_6835;
true
gap> homalg_variable_6837 := SIH_UnionOfColumns(homalg_variable_6495,homalg_variable_6301);;
gap> homalg_variable_6836 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_6724,homalg_variable_6837);;
gap> SI_ncols(homalg_variable_6836);
5
gap> homalg_variable_6838 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6836 = homalg_variable_6838;
false
gap> homalg_variable_6839 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_6836);;
gap> SI_ncols(homalg_variable_6839);
4
gap> homalg_variable_6840 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_6839 = homalg_variable_6840;
false
gap> homalg_variable_6841 := SI_\[(homalg_variable_6839,5,1);;
gap> SI_deg( homalg_variable_6841 );
-1
gap> homalg_variable_6842 := SI_\[(homalg_variable_6839,4,1);;
gap> SI_deg( homalg_variable_6842 );
1
gap> homalg_variable_6843 := SI_\[(homalg_variable_6839,3,1);;
gap> SI_deg( homalg_variable_6843 );
-1
gap> homalg_variable_6844 := SI_\[(homalg_variable_6839,2,1);;
gap> SI_deg( homalg_variable_6844 );
1
gap> homalg_variable_6845 := SI_\[(homalg_variable_6839,1,1);;
gap> SI_deg( homalg_variable_6845 );
-1
gap> homalg_variable_6846 := SI_\[(homalg_variable_6839,5,2);;
gap> SI_deg( homalg_variable_6846 );
-1
gap> homalg_variable_6847 := SI_\[(homalg_variable_6839,4,2);;
gap> SI_deg( homalg_variable_6847 );
-1
gap> homalg_variable_6848 := SI_\[(homalg_variable_6839,3,2);;
gap> SI_deg( homalg_variable_6848 );
1
gap> homalg_variable_6849 := SI_\[(homalg_variable_6839,2,2);;
gap> SI_deg( homalg_variable_6849 );
-1
gap> homalg_variable_6850 := SI_\[(homalg_variable_6839,1,2);;
gap> SI_deg( homalg_variable_6850 );
1
gap> homalg_variable_6851 := SI_\[(homalg_variable_6839,5,3);;
gap> SI_deg( homalg_variable_6851 );
1
gap> homalg_variable_6852 := SI_\[(homalg_variable_6839,4,3);;
gap> SI_deg( homalg_variable_6852 );
1
gap> homalg_variable_6853 := SI_\[(homalg_variable_6839,3,3);;
gap> SI_deg( homalg_variable_6853 );
-1
gap> homalg_variable_6854 := SI_\[(homalg_variable_6839,2,3);;
gap> SI_deg( homalg_variable_6854 );
-1
gap> homalg_variable_6855 := SI_\[(homalg_variable_6839,1,3);;
gap> SI_deg( homalg_variable_6855 );
-1
gap> homalg_variable_6856 := SI_\[(homalg_variable_6839,5,4);;
gap> SI_deg( homalg_variable_6856 );
1
gap> homalg_variable_6857 := SI_\[(homalg_variable_6839,4,4);;
gap> SI_deg( homalg_variable_6857 );
-1
gap> homalg_variable_6858 := SI_\[(homalg_variable_6839,3,4);;
gap> SI_deg( homalg_variable_6858 );
-1
gap> homalg_variable_6859 := SI_\[(homalg_variable_6839,2,4);;
gap> SI_deg( homalg_variable_6859 );
1
gap> homalg_variable_6860 := SI_\[(homalg_variable_6839,1,4);;
gap> SI_deg( homalg_variable_6860 );
-1
gap> homalg_variable_6861 := SIH_BasisOfColumnModule(homalg_variable_6836);;
gap> SI_ncols(homalg_variable_6861);
5
gap> homalg_variable_6862 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6861 = homalg_variable_6862;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6836);; homalg_variable_6863 := homalg_variable_l[1];; homalg_variable_6864 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6863);
5
gap> homalg_variable_6865 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6863 = homalg_variable_6865;
false
gap> SI_nrows(homalg_variable_6864);
5
gap> homalg_variable_6866 := homalg_variable_6836 * homalg_variable_6864;;
gap> homalg_variable_6863 = homalg_variable_6866;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6861,homalg_variable_6863);; homalg_variable_6867 := homalg_variable_l[1];; homalg_variable_6868 := homalg_variable_l[2];;
gap> homalg_variable_6869 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6867 = homalg_variable_6869;
true
gap> homalg_variable_6870 := homalg_variable_6863 * homalg_variable_6868;;
gap> homalg_variable_6871 := homalg_variable_6861 + homalg_variable_6870;;
gap> homalg_variable_6867 = homalg_variable_6871;
true
gap> homalg_variable_6872 := SIH_DecideZeroColumns(homalg_variable_6861,homalg_variable_6863);;
gap> homalg_variable_6873 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6872 = homalg_variable_6873;
true
gap> homalg_variable_6874 := homalg_variable_6868 * (homalg_variable_8);;
gap> homalg_variable_6875 := homalg_variable_6864 * homalg_variable_6874;;
gap> homalg_variable_6876 := homalg_variable_6836 * homalg_variable_6875;;
gap> homalg_variable_6876 = homalg_variable_6861;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6836,homalg_variable_6861);; homalg_variable_6877 := homalg_variable_l[1];; homalg_variable_6878 := homalg_variable_l[2];;
gap> homalg_variable_6879 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6877 = homalg_variable_6879;
true
gap> homalg_variable_6880 := homalg_variable_6861 * homalg_variable_6878;;
gap> homalg_variable_6881 := homalg_variable_6836 + homalg_variable_6880;;
gap> homalg_variable_6877 = homalg_variable_6881;
true
gap> homalg_variable_6882 := SIH_DecideZeroColumns(homalg_variable_6836,homalg_variable_6861);;
gap> homalg_variable_6883 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6882 = homalg_variable_6883;
true
gap> homalg_variable_6884 := homalg_variable_6878 * (homalg_variable_8);;
gap> homalg_variable_6885 := homalg_variable_6861 * homalg_variable_6884;;
gap> homalg_variable_6885 = homalg_variable_6836;
true
gap> homalg_variable_6886 := SIH_DecideZeroColumns(homalg_variable_6836,homalg_variable_6781);;
gap> homalg_variable_6887 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_6886 = homalg_variable_6887;
true
gap> homalg_variable_6889 := homalg_variable_6806 * homalg_variable_3336;;
gap> homalg_variable_6888 := SIH_DecideZeroColumns(homalg_variable_6889,homalg_variable_6781);;
gap> homalg_variable_6890 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_6888 = homalg_variable_6890;
true
gap> homalg_variable_6891 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_6806,homalg_variable_6781);;
gap> SI_ncols(homalg_variable_6891);
3
gap> homalg_variable_6892 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_6891 = homalg_variable_6892;
false
gap> homalg_variable_6893 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_6891);;
gap> SI_ncols(homalg_variable_6893);
3
gap> homalg_variable_6894 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_6893 = homalg_variable_6894;
false
gap> homalg_variable_6895 := SI_\[(homalg_variable_6893,3,1);;
gap> SI_deg( homalg_variable_6895 );
-1
gap> homalg_variable_6896 := SI_\[(homalg_variable_6893,2,1);;
gap> SI_deg( homalg_variable_6896 );
1
gap> homalg_variable_6897 := SI_\[(homalg_variable_6893,1,1);;
gap> SI_deg( homalg_variable_6897 );
1
gap> homalg_variable_6898 := SI_\[(homalg_variable_6893,3,2);;
gap> SI_deg( homalg_variable_6898 );
1
gap> homalg_variable_6899 := SI_\[(homalg_variable_6893,2,2);;
gap> SI_deg( homalg_variable_6899 );
1
gap> homalg_variable_6900 := SI_\[(homalg_variable_6893,1,2);;
gap> SI_deg( homalg_variable_6900 );
-1
gap> homalg_variable_6901 := SI_\[(homalg_variable_6893,3,3);;
gap> SI_deg( homalg_variable_6901 );
1
gap> homalg_variable_6902 := SI_\[(homalg_variable_6893,2,3);;
gap> SI_deg( homalg_variable_6902 );
-1
gap> homalg_variable_6903 := SI_\[(homalg_variable_6893,1,3);;
gap> SI_deg( homalg_variable_6903 );
1
gap> homalg_variable_6904 := SIH_BasisOfColumnModule(homalg_variable_6891);;
gap> SI_ncols(homalg_variable_6904);
3
gap> homalg_variable_6905 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_6904 = homalg_variable_6905;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6891);; homalg_variable_6906 := homalg_variable_l[1];; homalg_variable_6907 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6906);
3
gap> homalg_variable_6908 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_6906 = homalg_variable_6908;
false
gap> SI_nrows(homalg_variable_6907);
3
gap> homalg_variable_6909 := homalg_variable_6891 * homalg_variable_6907;;
gap> homalg_variable_6906 = homalg_variable_6909;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6904,homalg_variable_6906);; homalg_variable_6910 := homalg_variable_l[1];; homalg_variable_6911 := homalg_variable_l[2];;
gap> homalg_variable_6912 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_6910 = homalg_variable_6912;
true
gap> homalg_variable_6913 := homalg_variable_6906 * homalg_variable_6911;;
gap> homalg_variable_6914 := homalg_variable_6904 + homalg_variable_6913;;
gap> homalg_variable_6910 = homalg_variable_6914;
true
gap> homalg_variable_6915 := SIH_DecideZeroColumns(homalg_variable_6904,homalg_variable_6906);;
gap> homalg_variable_6916 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_6915 = homalg_variable_6916;
true
gap> homalg_variable_6917 := homalg_variable_6911 * (homalg_variable_8);;
gap> homalg_variable_6918 := homalg_variable_6907 * homalg_variable_6917;;
gap> homalg_variable_6919 := homalg_variable_6891 * homalg_variable_6918;;
gap> homalg_variable_6919 = homalg_variable_6904;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6891,homalg_variable_6904);; homalg_variable_6920 := homalg_variable_l[1];; homalg_variable_6921 := homalg_variable_l[2];;
gap> homalg_variable_6922 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_6920 = homalg_variable_6922;
true
gap> homalg_variable_6923 := homalg_variable_6904 * homalg_variable_6921;;
gap> homalg_variable_6924 := homalg_variable_6891 + homalg_variable_6923;;
gap> homalg_variable_6920 = homalg_variable_6924;
true
gap> homalg_variable_6925 := SIH_DecideZeroColumns(homalg_variable_6891,homalg_variable_6904);;
gap> homalg_variable_6926 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_6925 = homalg_variable_6926;
true
gap> homalg_variable_6927 := homalg_variable_6921 * (homalg_variable_8);;
gap> homalg_variable_6928 := homalg_variable_6904 * homalg_variable_6927;;
gap> homalg_variable_6928 = homalg_variable_6891;
true
gap> homalg_variable_6929 := SIH_DecideZeroColumns(homalg_variable_6891,homalg_variable_3336);;
gap> homalg_variable_6930 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_6929 = homalg_variable_6930;
true
gap> homalg_variable_6932 := SIH_UnionOfColumns(homalg_variable_6806,homalg_variable_6781);;
gap> homalg_variable_6931 := SIH_BasisOfColumnModule(homalg_variable_6932);;
gap> SI_ncols(homalg_variable_6931);
3
gap> homalg_variable_6933 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_6931 = homalg_variable_6933;
false
gap> homalg_variable_6934 := SIH_DecideZeroColumns(homalg_variable_6806,homalg_variable_6931);;
gap> homalg_variable_6935 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_6934 = homalg_variable_6935;
true
gap> homalg_variable_6937 := homalg_variable_6832 * homalg_variable_3419;;
gap> homalg_variable_6936 := SIH_DecideZeroColumns(homalg_variable_6937,homalg_variable_6931);;
gap> homalg_variable_6938 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_6936 = homalg_variable_6938;
true
gap> homalg_variable_6939 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_6832,homalg_variable_6932);;
gap> SI_ncols(homalg_variable_6939);
2
gap> homalg_variable_6940 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_6939 = homalg_variable_6940;
false
gap> homalg_variable_6941 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_6939);;
gap> SI_ncols(homalg_variable_6941);
1
gap> homalg_variable_6942 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_6941 = homalg_variable_6942;
false
gap> homalg_variable_6943 := SI_\[(homalg_variable_6941,2,1);;
gap> SI_deg( homalg_variable_6943 );
1
gap> homalg_variable_6944 := SI_\[(homalg_variable_6941,1,1);;
gap> SI_deg( homalg_variable_6944 );
1
gap> homalg_variable_6945 := SIH_BasisOfColumnModule(homalg_variable_6939);;
gap> SI_ncols(homalg_variable_6945);
2
gap> homalg_variable_6946 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_6945 = homalg_variable_6946;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6939);; homalg_variable_6947 := homalg_variable_l[1];; homalg_variable_6948 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6947);
2
gap> homalg_variable_6949 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_6947 = homalg_variable_6949;
false
gap> SI_nrows(homalg_variable_6948);
2
gap> homalg_variable_6950 := homalg_variable_6939 * homalg_variable_6948;;
gap> homalg_variable_6947 = homalg_variable_6950;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6945,homalg_variable_6947);; homalg_variable_6951 := homalg_variable_l[1];; homalg_variable_6952 := homalg_variable_l[2];;
gap> homalg_variable_6953 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_6951 = homalg_variable_6953;
true
gap> homalg_variable_6954 := homalg_variable_6947 * homalg_variable_6952;;
gap> homalg_variable_6955 := homalg_variable_6945 + homalg_variable_6954;;
gap> homalg_variable_6951 = homalg_variable_6955;
true
gap> homalg_variable_6956 := SIH_DecideZeroColumns(homalg_variable_6945,homalg_variable_6947);;
gap> homalg_variable_6957 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_6956 = homalg_variable_6957;
true
gap> homalg_variable_6958 := homalg_variable_6952 * (homalg_variable_8);;
gap> homalg_variable_6959 := homalg_variable_6948 * homalg_variable_6958;;
gap> homalg_variable_6960 := homalg_variable_6939 * homalg_variable_6959;;
gap> homalg_variable_6960 = homalg_variable_6945;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6939,homalg_variable_6945);; homalg_variable_6961 := homalg_variable_l[1];; homalg_variable_6962 := homalg_variable_l[2];;
gap> homalg_variable_6963 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_6961 = homalg_variable_6963;
true
gap> homalg_variable_6964 := homalg_variable_6945 * homalg_variable_6962;;
gap> homalg_variable_6965 := homalg_variable_6939 + homalg_variable_6964;;
gap> homalg_variable_6961 = homalg_variable_6965;
true
gap> homalg_variable_6966 := SIH_DecideZeroColumns(homalg_variable_6939,homalg_variable_6945);;
gap> homalg_variable_6967 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_6966 = homalg_variable_6967;
true
gap> homalg_variable_6968 := homalg_variable_6962 * (homalg_variable_8);;
gap> homalg_variable_6969 := homalg_variable_6945 * homalg_variable_6968;;
gap> homalg_variable_6969 = homalg_variable_6939;
true
gap> homalg_variable_6970 := SIH_DecideZeroColumns(homalg_variable_6939,homalg_variable_3419);;
gap> homalg_variable_6971 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_6970 = homalg_variable_6971;
true
gap> homalg_variable_6973 := SIH_UnionOfColumns(homalg_variable_6832,homalg_variable_6932);;
gap> homalg_variable_6972 := SIH_BasisOfColumnModule(homalg_variable_6973);;
gap> SI_ncols(homalg_variable_6972);
2
gap> homalg_variable_6974 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_6972 = homalg_variable_6974;
false
gap> homalg_variable_6975 := SIH_DecideZeroColumns(homalg_variable_813,homalg_variable_6972);;
gap> homalg_variable_6976 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_6975 = homalg_variable_6976;
true
gap> homalg_variable_6977 := SIH_DecideZeroColumns(homalg_variable_6832,homalg_variable_6931);;
gap> homalg_variable_6978 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_6977 = homalg_variable_6978;
false
gap> homalg_variable_6979 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_6832 = homalg_variable_6979;
false
gap> homalg_variable_6980 := SIH_UnionOfColumns(homalg_variable_6977,homalg_variable_6931);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_6980);; homalg_variable_6981 := homalg_variable_l[1];; homalg_variable_6982 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_6981);
2
gap> homalg_variable_6983 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_6981 = homalg_variable_6983;
false
gap> SI_nrows(homalg_variable_6982);
4
gap> homalg_variable_6984 := SIH_Submatrix(homalg_variable_6982,[ 1 ],[1..2]);;
gap> homalg_variable_6985 := homalg_variable_6977 * homalg_variable_6984;;
gap> homalg_variable_6986 := SIH_Submatrix(homalg_variable_6982,[ 2, 3, 4 ],[1..2]);;
gap> homalg_variable_6987 := homalg_variable_6931 * homalg_variable_6986;;
gap> homalg_variable_6988 := homalg_variable_6985 + homalg_variable_6987;;
gap> homalg_variable_6981 = homalg_variable_6988;
true
gap> homalg_variable_6989 := SIH_DecideZeroColumns(homalg_variable_813,homalg_variable_6931);;
gap> homalg_variable_6990 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_6989 = homalg_variable_6990;
false
gap> homalg_variable_6981 = homalg_variable_813;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_6989,homalg_variable_6981);; homalg_variable_6991 := homalg_variable_l[1];; homalg_variable_6992 := homalg_variable_l[2];;
gap> homalg_variable_6993 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_6991 = homalg_variable_6993;
true
gap> homalg_variable_6994 := homalg_variable_6981 * homalg_variable_6992;;
gap> homalg_variable_6995 := homalg_variable_6989 + homalg_variable_6994;;
gap> homalg_variable_6991 = homalg_variable_6995;
true
gap> homalg_variable_6996 := SIH_DecideZeroColumns(homalg_variable_6989,homalg_variable_6981);;
gap> homalg_variable_6997 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_6996 = homalg_variable_6997;
true
gap> homalg_variable_6999 := SIH_Submatrix(homalg_variable_6982,[ 1 ],[1..2]);;
gap> homalg_variable_7000 := homalg_variable_6992 * (homalg_variable_8);;
gap> for _del in [ "homalg_variable_6494", "homalg_variable_6496", "homalg_variable_6497", "homalg_variable_6498", "homalg_variable_6499", "homalg_variable_6501", "homalg_variable_6503", "homalg_variable_6504", "homalg_variable_6505", "homalg_variable_6506", "homalg_variable_6507", "homalg_variable_6508", "homalg_variable_6509", "homalg_variable_6510", "homalg_variable_6511", "homalg_variable_6512", "homalg_variable_6514", "homalg_variable_6517", "homalg_variable_6518", "homalg_variable_6522", "homalg_variable_6523", "homalg_variable_6524", "homalg_variable_6525", "homalg_variable_6528", "homalg_variable_6531", "homalg_variable_6532", "homalg_variable_6533", "homalg_variable_6537", "homalg_variable_6538", "homalg_variable_6539", "homalg_variable_6542", "homalg_variable_6545", "homalg_variable_6546", "homalg_variable_6547", "homalg_variable_6549", "homalg_variable_6551", "homalg_variable_6552", "homalg_variable_6553", "homalg_variable_6555", "homalg_variable_6559", "homalg_variable_6562", "homalg_variable_6563", "homalg_variable_6564", "homalg_variable_6565", "homalg_variable_6566", "homalg_variable_6569", "homalg_variable_6573", "homalg_variable_6574", "homalg_variable_6575", "homalg_variable_6576", "homalg_variable_6578", "homalg_variable_6579", "homalg_variable_6580", "homalg_variable_6584", "homalg_variable_6585", "homalg_variable_6586", "homalg_variable_6587", "homalg_variable_6588", "homalg_variable_6589", "homalg_variable_6590", "homalg_variable_6591", "homalg_variable_6592", "homalg_variable_6593", "homalg_variable_6594", "homalg_variable_6595", "homalg_variable_6596", "homalg_variable_6597", "homalg_variable_6598", "homalg_variable_6599", "homalg_variable_6600", "homalg_variable_6601", "homalg_variable_6602", "homalg_variable_6603", "homalg_variable_6604", "homalg_variable_6606", "homalg_variable_6609", "homalg_variable_6610", "homalg_variable_6611", "homalg_variable_6612", "homalg_variable_6613", "homalg_variable_6614", "homalg_variable_6615", "homalg_variable_6616", "homalg_variable_6617", "homalg_variable_6619", "homalg_variable_6622", "homalg_variable_6623", "homalg_variable_6626", "homalg_variable_6627", "homalg_variable_6628", "homalg_variable_6629", "homalg_variable_6630", "homalg_variable_6633", "homalg_variable_6636", "homalg_variable_6639", "homalg_variable_6640", "homalg_variable_6642", "homalg_variable_6646", "homalg_variable_6648", "homalg_variable_6649", "homalg_variable_6650", "homalg_variable_6651", "homalg_variable_6653", "homalg_variable_6655", "homalg_variable_6656", "homalg_variable_6657", "homalg_variable_6658", "homalg_variable_6659", "homalg_variable_6661", "homalg_variable_6664", "homalg_variable_6665", "homalg_variable_6668", "homalg_variable_6669", "homalg_variable_6670", "homalg_variable_6672", "homalg_variable_6675", "homalg_variable_6678", "homalg_variable_6679", "homalg_variable_6680", "homalg_variable_6681", "homalg_variable_6682", "homalg_variable_6685", "homalg_variable_6686", "homalg_variable_6689", "homalg_variable_6694", "homalg_variable_6695", "homalg_variable_6699", "homalg_variable_6700", "homalg_variable_6701", "homalg_variable_6702", "homalg_variable_6703", "homalg_variable_6704", "homalg_variable_6706", "homalg_variable_6709", "homalg_variable_6710", "homalg_variable_6711", "homalg_variable_6712", "homalg_variable_6713", "homalg_variable_6714", "homalg_variable_6718", "homalg_variable_6719", "homalg_variable_6720", "homalg_variable_6723", "homalg_variable_6725", "homalg_variable_6726", "homalg_variable_6728", "homalg_variable_6733", "homalg_variable_6735", "homalg_variable_6736", "homalg_variable_6737", "homalg_variable_6738", "homalg_variable_6739", "homalg_variable_6740", "homalg_variable_6741", "homalg_variable_6742", "homalg_variable_6743", "homalg_variable_6744", "homalg_variable_6745", "homalg_variable_6746", "homalg_variable_6747", "homalg_variable_6748", "homalg_variable_6751", "homalg_variable_6752", "homalg_variable_6753", "homalg_variable_6754", "homalg_variable_6755", "homalg_variable_6757", "homalg_variable_6760", "homalg_variable_6761", "homalg_variable_6764", "homalg_variable_6767", "homalg_variable_6768", "homalg_variable_6771", "homalg_variable_6774", "homalg_variable_6775", "homalg_variable_6776", "homalg_variable_6778", "homalg_variable_6780", "homalg_variable_6782", "homalg_variable_6784", "homalg_variable_6788", "homalg_variable_6789", "homalg_variable_6790", "homalg_variable_6791", "homalg_variable_6792", "homalg_variable_6793", "homalg_variable_6795", "homalg_variable_6799", "homalg_variable_6800", "homalg_variable_6801", "homalg_variable_6802", "homalg_variable_6803", "homalg_variable_6807", "homalg_variable_6808", "homalg_variable_6809", "homalg_variable_6814", "homalg_variable_6815", "homalg_variable_6816", "homalg_variable_6817", "homalg_variable_6818", "homalg_variable_6820", "homalg_variable_6821", "homalg_variable_6824", "homalg_variable_6827", "homalg_variable_6828", "homalg_variable_6829", "homalg_variable_6833", "homalg_variable_6834", "homalg_variable_6835", "homalg_variable_6838", "homalg_variable_6841", "homalg_variable_6842", "homalg_variable_6843", "homalg_variable_6844", "homalg_variable_6845", "homalg_variable_6846", "homalg_variable_6847", "homalg_variable_6848", "homalg_variable_6849", "homalg_variable_6850", "homalg_variable_6851", "homalg_variable_6852", "homalg_variable_6853", "homalg_variable_6854", "homalg_variable_6855", "homalg_variable_6856", "homalg_variable_6857", "homalg_variable_6858", "homalg_variable_6862", "homalg_variable_6865", "homalg_variable_6866", "homalg_variable_6869", "homalg_variable_6870", "homalg_variable_6871", "homalg_variable_6873", "homalg_variable_6876", "homalg_variable_6879", "homalg_variable_6880", "homalg_variable_6881", "homalg_variable_6883", "homalg_variable_6885", "homalg_variable_6887", "homalg_variable_6888", "homalg_variable_6889", "homalg_variable_6890", "homalg_variable_6892", "homalg_variable_6894", "homalg_variable_6895", "homalg_variable_6896", "homalg_variable_6897", "homalg_variable_6898", "homalg_variable_6899", "homalg_variable_6900", "homalg_variable_6901", "homalg_variable_6902", "homalg_variable_6903", "homalg_variable_6908", "homalg_variable_6909", "homalg_variable_6912", "homalg_variable_6913", "homalg_variable_6914", "homalg_variable_6919", "homalg_variable_6922", "homalg_variable_6923", "homalg_variable_6924", "homalg_variable_6928", "homalg_variable_6929", "homalg_variable_6930", "homalg_variable_6933", "homalg_variable_6934", "homalg_variable_6935", "homalg_variable_6940", "homalg_variable_6942", "homalg_variable_6943", "homalg_variable_6944", "homalg_variable_6946", "homalg_variable_6949", "homalg_variable_6950", "homalg_variable_6953", "homalg_variable_6954", "homalg_variable_6955", "homalg_variable_6960", "homalg_variable_6963", "homalg_variable_6964", "homalg_variable_6965", "homalg_variable_6967", "homalg_variable_6969", "homalg_variable_6970", "homalg_variable_6971", "homalg_variable_6974", "homalg_variable_6975", "homalg_variable_6976", "homalg_variable_6978", "homalg_variable_6979", "homalg_variable_6983", "homalg_variable_6984", "homalg_variable_6985", "homalg_variable_6986", "homalg_variable_6987", "homalg_variable_6988", "homalg_variable_6993", "homalg_variable_6994", "homalg_variable_6995" ] do UnbindGlobal( _del );; od;;
gap> homalg_variable_7001 := homalg_variable_6999 * homalg_variable_7000;;
gap> homalg_variable_7002 := homalg_variable_6832 * homalg_variable_7001;;
gap> homalg_variable_7003 := homalg_variable_7002 - homalg_variable_813;;
gap> homalg_variable_6998 := SIH_DecideZeroColumns(homalg_variable_7003,homalg_variable_6931);;
gap> homalg_variable_7004 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_6998 = homalg_variable_7004;
true
gap> homalg_variable_7006 := homalg_variable_7001 * homalg_variable_6781;;
gap> homalg_variable_7005 := SIH_DecideZeroColumns(homalg_variable_7006,homalg_variable_3419);;
gap> homalg_variable_7007 := SI_matrix(homalg_variable_5,1,5,"0");;
gap> homalg_variable_7005 = homalg_variable_7007;
true
gap> homalg_variable_7008 := SIH_DecideZeroColumns(homalg_variable_6806,homalg_variable_6781);;
gap> homalg_variable_7009 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_7008 = homalg_variable_7009;
false
gap> homalg_variable_7010 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_6806 = homalg_variable_7010;
false
gap> homalg_variable_7011 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_7008,homalg_variable_6781);;
gap> SI_ncols(homalg_variable_7011);
3
gap> homalg_variable_7012 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7011 = homalg_variable_7012;
false
gap> homalg_variable_7014 := homalg_variable_7008 * homalg_variable_7011;;
gap> homalg_variable_7013 := SIH_DecideZeroColumns(homalg_variable_7014,homalg_variable_6781);;
gap> homalg_variable_7015 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_7013 = homalg_variable_7015;
true
gap> homalg_variable_7016 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_7008,homalg_variable_6781);;
gap> SI_ncols(homalg_variable_7016);
3
gap> homalg_variable_7017 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7016 = homalg_variable_7017;
false
gap> homalg_variable_7018 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_7016);;
gap> SI_ncols(homalg_variable_7018);
3
gap> homalg_variable_7019 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_7018 = homalg_variable_7019;
false
gap> homalg_variable_7020 := SI_\[(homalg_variable_7018,3,1);;
gap> SI_deg( homalg_variable_7020 );
-1
gap> homalg_variable_7021 := SI_\[(homalg_variable_7018,2,1);;
gap> SI_deg( homalg_variable_7021 );
1
gap> homalg_variable_7022 := SI_\[(homalg_variable_7018,1,1);;
gap> SI_deg( homalg_variable_7022 );
1
gap> homalg_variable_7023 := SI_\[(homalg_variable_7018,3,2);;
gap> SI_deg( homalg_variable_7023 );
1
gap> homalg_variable_7024 := SI_\[(homalg_variable_7018,2,2);;
gap> SI_deg( homalg_variable_7024 );
1
gap> homalg_variable_7025 := SI_\[(homalg_variable_7018,1,2);;
gap> SI_deg( homalg_variable_7025 );
-1
gap> homalg_variable_7026 := SI_\[(homalg_variable_7018,3,3);;
gap> SI_deg( homalg_variable_7026 );
1
gap> homalg_variable_7027 := SI_\[(homalg_variable_7018,2,3);;
gap> SI_deg( homalg_variable_7027 );
-1
gap> homalg_variable_7028 := SI_\[(homalg_variable_7018,1,3);;
gap> SI_deg( homalg_variable_7028 );
1
gap> homalg_variable_7029 := SIH_BasisOfColumnModule(homalg_variable_7016);;
gap> SI_ncols(homalg_variable_7029);
3
gap> homalg_variable_7030 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7029 = homalg_variable_7030;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_7016);; homalg_variable_7031 := homalg_variable_l[1];; homalg_variable_7032 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_7031);
3
gap> homalg_variable_7033 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7031 = homalg_variable_7033;
false
gap> SI_nrows(homalg_variable_7032);
3
gap> homalg_variable_7034 := homalg_variable_7016 * homalg_variable_7032;;
gap> homalg_variable_7031 = homalg_variable_7034;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_7029,homalg_variable_7031);; homalg_variable_7035 := homalg_variable_l[1];; homalg_variable_7036 := homalg_variable_l[2];;
gap> homalg_variable_7037 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7035 = homalg_variable_7037;
true
gap> homalg_variable_7038 := homalg_variable_7031 * homalg_variable_7036;;
gap> homalg_variable_7039 := homalg_variable_7029 + homalg_variable_7038;;
gap> homalg_variable_7035 = homalg_variable_7039;
true
gap> homalg_variable_7040 := SIH_DecideZeroColumns(homalg_variable_7029,homalg_variable_7031);;
gap> homalg_variable_7041 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7040 = homalg_variable_7041;
true
gap> homalg_variable_7042 := homalg_variable_7036 * (homalg_variable_8);;
gap> homalg_variable_7043 := homalg_variable_7032 * homalg_variable_7042;;
gap> homalg_variable_7044 := homalg_variable_7016 * homalg_variable_7043;;
gap> homalg_variable_7044 = homalg_variable_7029;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_7016,homalg_variable_7029);; homalg_variable_7045 := homalg_variable_l[1];; homalg_variable_7046 := homalg_variable_l[2];;
gap> homalg_variable_7047 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7045 = homalg_variable_7047;
true
gap> homalg_variable_7048 := homalg_variable_7029 * homalg_variable_7046;;
gap> homalg_variable_7049 := homalg_variable_7016 + homalg_variable_7048;;
gap> homalg_variable_7045 = homalg_variable_7049;
true
gap> homalg_variable_7050 := SIH_DecideZeroColumns(homalg_variable_7016,homalg_variable_7029);;
gap> homalg_variable_7051 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7050 = homalg_variable_7051;
true
gap> homalg_variable_7052 := homalg_variable_7046 * (homalg_variable_8);;
gap> homalg_variable_7053 := homalg_variable_7029 * homalg_variable_7052;;
gap> homalg_variable_7053 = homalg_variable_7016;
true
gap> homalg_variable_7054 := SIH_BasisOfColumnModule(homalg_variable_7011);;
gap> SI_ncols(homalg_variable_7054);
3
gap> homalg_variable_7055 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7054 = homalg_variable_7055;
false
gap> homalg_variable_7054 = homalg_variable_7011;
true
gap> homalg_variable_7056 := SIH_DecideZeroColumns(homalg_variable_7016,homalg_variable_7054);;
gap> homalg_variable_7057 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7056 = homalg_variable_7057;
true
gap> homalg_variable_7058 := SIH_UnionOfColumns(homalg_variable_7008,homalg_variable_6781);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_7058);; homalg_variable_7059 := homalg_variable_l[1];; homalg_variable_7060 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_7059);
3
gap> homalg_variable_7061 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_7059 = homalg_variable_7061;
false
gap> SI_nrows(homalg_variable_7060);
6
gap> homalg_variable_7062 := SIH_Submatrix(homalg_variable_7060,[ 1 ],[1..3]);;
gap> homalg_variable_7063 := homalg_variable_7008 * homalg_variable_7062;;
gap> homalg_variable_7064 := SIH_Submatrix(homalg_variable_7060,[ 2, 3, 4, 5, 6 ],[1..3]);;
gap> homalg_variable_7065 := homalg_variable_6781 * homalg_variable_7064;;
gap> homalg_variable_7066 := homalg_variable_7063 + homalg_variable_7065;;
gap> homalg_variable_7059 = homalg_variable_7066;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_7008,homalg_variable_7059);; homalg_variable_7067 := homalg_variable_l[1];; homalg_variable_7068 := homalg_variable_l[2];;
gap> homalg_variable_7069 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_7067 = homalg_variable_7069;
true
gap> homalg_variable_7070 := homalg_variable_7059 * homalg_variable_7068;;
gap> homalg_variable_7071 := homalg_variable_7008 + homalg_variable_7070;;
gap> homalg_variable_7067 = homalg_variable_7071;
true
gap> homalg_variable_7072 := SIH_DecideZeroColumns(homalg_variable_7008,homalg_variable_7059);;
gap> homalg_variable_7073 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_7072 = homalg_variable_7073;
true
gap> homalg_variable_7075 := SIH_Submatrix(homalg_variable_7060,[ 1 ],[1..3]);;
gap> homalg_variable_7076 := homalg_variable_7068 * (homalg_variable_8);;
gap> homalg_variable_7077 := homalg_variable_7075 * homalg_variable_7076;;
gap> homalg_variable_7078 := homalg_variable_7008 * homalg_variable_7077;;
gap> homalg_variable_7079 := homalg_variable_7078 - homalg_variable_6806;;
gap> homalg_variable_7074 := SIH_DecideZeroColumns(homalg_variable_7079,homalg_variable_6781);;
gap> homalg_variable_7080 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_7074 = homalg_variable_7080;
true
gap> homalg_variable_7082 := SIH_UnionOfColumns(homalg_variable_6886,homalg_variable_6781);;
gap> homalg_variable_7081 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_7008,homalg_variable_7082);;
gap> SI_ncols(homalg_variable_7081);
3
gap> homalg_variable_7083 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7081 = homalg_variable_7083;
false
gap> homalg_variable_7084 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_7081);;
gap> SI_ncols(homalg_variable_7084);
3
gap> homalg_variable_7085 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_7084 = homalg_variable_7085;
false
gap> homalg_variable_7086 := SI_\[(homalg_variable_7084,3,1);;
gap> SI_deg( homalg_variable_7086 );
-1
gap> homalg_variable_7087 := SI_\[(homalg_variable_7084,2,1);;
gap> SI_deg( homalg_variable_7087 );
1
gap> homalg_variable_7088 := SI_\[(homalg_variable_7084,1,1);;
gap> SI_deg( homalg_variable_7088 );
1
gap> homalg_variable_7089 := SI_\[(homalg_variable_7084,3,2);;
gap> SI_deg( homalg_variable_7089 );
1
gap> homalg_variable_7090 := SI_\[(homalg_variable_7084,2,2);;
gap> SI_deg( homalg_variable_7090 );
1
gap> homalg_variable_7091 := SI_\[(homalg_variable_7084,1,2);;
gap> SI_deg( homalg_variable_7091 );
-1
gap> homalg_variable_7092 := SI_\[(homalg_variable_7084,3,3);;
gap> SI_deg( homalg_variable_7092 );
1
gap> homalg_variable_7093 := SI_\[(homalg_variable_7084,2,3);;
gap> SI_deg( homalg_variable_7093 );
-1
gap> homalg_variable_7094 := SI_\[(homalg_variable_7084,1,3);;
gap> SI_deg( homalg_variable_7094 );
1
gap> homalg_variable_7095 := SIH_BasisOfColumnModule(homalg_variable_7081);;
gap> SI_ncols(homalg_variable_7095);
3
gap> homalg_variable_7096 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7095 = homalg_variable_7096;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_7081);; homalg_variable_7097 := homalg_variable_l[1];; homalg_variable_7098 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_7097);
3
gap> homalg_variable_7099 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7097 = homalg_variable_7099;
false
gap> SI_nrows(homalg_variable_7098);
3
gap> homalg_variable_7100 := homalg_variable_7081 * homalg_variable_7098;;
gap> homalg_variable_7097 = homalg_variable_7100;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_7095,homalg_variable_7097);; homalg_variable_7101 := homalg_variable_l[1];; homalg_variable_7102 := homalg_variable_l[2];;
gap> homalg_variable_7103 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7101 = homalg_variable_7103;
true
gap> homalg_variable_7104 := homalg_variable_7097 * homalg_variable_7102;;
gap> homalg_variable_7105 := homalg_variable_7095 + homalg_variable_7104;;
gap> homalg_variable_7101 = homalg_variable_7105;
true
gap> homalg_variable_7106 := SIH_DecideZeroColumns(homalg_variable_7095,homalg_variable_7097);;
gap> homalg_variable_7107 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7106 = homalg_variable_7107;
true
gap> homalg_variable_7108 := homalg_variable_7102 * (homalg_variable_8);;
gap> homalg_variable_7109 := homalg_variable_7098 * homalg_variable_7108;;
gap> homalg_variable_7110 := homalg_variable_7081 * homalg_variable_7109;;
gap> homalg_variable_7110 = homalg_variable_7095;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_7081,homalg_variable_7095);; homalg_variable_7111 := homalg_variable_l[1];; homalg_variable_7112 := homalg_variable_l[2];;
gap> homalg_variable_7113 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7111 = homalg_variable_7113;
true
gap> homalg_variable_7114 := homalg_variable_7095 * homalg_variable_7112;;
gap> homalg_variable_7115 := homalg_variable_7081 + homalg_variable_7114;;
gap> homalg_variable_7111 = homalg_variable_7115;
true
gap> homalg_variable_7116 := SIH_DecideZeroColumns(homalg_variable_7081,homalg_variable_7095);;
gap> homalg_variable_7117 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7116 = homalg_variable_7117;
true
gap> homalg_variable_7118 := homalg_variable_7112 * (homalg_variable_8);;
gap> homalg_variable_7119 := homalg_variable_7095 * homalg_variable_7118;;
gap> homalg_variable_7119 = homalg_variable_7081;
true
gap> homalg_variable_7120 := SIH_DecideZeroColumns(homalg_variable_7081,homalg_variable_7054);;
gap> homalg_variable_7121 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7120 = homalg_variable_7121;
true
gap> homalg_variable_7123 := homalg_variable_7077 * homalg_variable_3336;;
gap> homalg_variable_7122 := SIH_DecideZeroColumns(homalg_variable_7123,homalg_variable_7054);;
gap> homalg_variable_7124 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7122 = homalg_variable_7124;
true
gap> homalg_variable_7126 := SIH_UnionOfColumns(homalg_variable_7077,homalg_variable_7054);;
gap> homalg_variable_7125 := SIH_BasisOfColumnModule(homalg_variable_7126);;
gap> SI_ncols(homalg_variable_7125);
1
gap> homalg_variable_7127 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_7125 = homalg_variable_7127;
false
gap> homalg_variable_7128 := SIH_DecideZeroColumns(homalg_variable_237,homalg_variable_7125);;
gap> homalg_variable_7129 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_7128 = homalg_variable_7129;
true
gap> homalg_variable_7130 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_7077,homalg_variable_7054);;
gap> SI_ncols(homalg_variable_7130);
3
gap> homalg_variable_7131 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7130 = homalg_variable_7131;
false
gap> homalg_variable_7132 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_7130);;
gap> SI_ncols(homalg_variable_7132);
3
gap> homalg_variable_7133 := SI_matrix(homalg_variable_5,3,3,"0");;
gap> homalg_variable_7132 = homalg_variable_7133;
false
gap> homalg_variable_7134 := SI_\[(homalg_variable_7132,3,1);;
gap> SI_deg( homalg_variable_7134 );
-1
gap> homalg_variable_7135 := SI_\[(homalg_variable_7132,2,1);;
gap> SI_deg( homalg_variable_7135 );
1
gap> homalg_variable_7136 := SI_\[(homalg_variable_7132,1,1);;
gap> SI_deg( homalg_variable_7136 );
1
gap> homalg_variable_7137 := SI_\[(homalg_variable_7132,3,2);;
gap> SI_deg( homalg_variable_7137 );
1
gap> homalg_variable_7138 := SI_\[(homalg_variable_7132,2,2);;
gap> SI_deg( homalg_variable_7138 );
1
gap> homalg_variable_7139 := SI_\[(homalg_variable_7132,1,2);;
gap> SI_deg( homalg_variable_7139 );
-1
gap> homalg_variable_7140 := SI_\[(homalg_variable_7132,3,3);;
gap> SI_deg( homalg_variable_7140 );
1
gap> homalg_variable_7141 := SI_\[(homalg_variable_7132,2,3);;
gap> SI_deg( homalg_variable_7141 );
-1
gap> homalg_variable_7142 := SI_\[(homalg_variable_7132,1,3);;
gap> SI_deg( homalg_variable_7142 );
1
gap> homalg_variable_7143 := SIH_BasisOfColumnModule(homalg_variable_7130);;
gap> SI_ncols(homalg_variable_7143);
3
gap> homalg_variable_7144 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7143 = homalg_variable_7144;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_7130);; homalg_variable_7145 := homalg_variable_l[1];; homalg_variable_7146 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_7145);
3
gap> homalg_variable_7147 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7145 = homalg_variable_7147;
false
gap> SI_nrows(homalg_variable_7146);
3
gap> homalg_variable_7148 := homalg_variable_7130 * homalg_variable_7146;;
gap> homalg_variable_7145 = homalg_variable_7148;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_7143,homalg_variable_7145);; homalg_variable_7149 := homalg_variable_l[1];; homalg_variable_7150 := homalg_variable_l[2];;
gap> homalg_variable_7151 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7149 = homalg_variable_7151;
true
gap> homalg_variable_7152 := homalg_variable_7145 * homalg_variable_7150;;
gap> homalg_variable_7153 := homalg_variable_7143 + homalg_variable_7152;;
gap> homalg_variable_7149 = homalg_variable_7153;
true
gap> homalg_variable_7154 := SIH_DecideZeroColumns(homalg_variable_7143,homalg_variable_7145);;
gap> homalg_variable_7155 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7154 = homalg_variable_7155;
true
gap> homalg_variable_7156 := homalg_variable_7150 * (homalg_variable_8);;
gap> homalg_variable_7157 := homalg_variable_7146 * homalg_variable_7156;;
gap> homalg_variable_7158 := homalg_variable_7130 * homalg_variable_7157;;
gap> homalg_variable_7158 = homalg_variable_7143;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_7130,homalg_variable_7143);; homalg_variable_7159 := homalg_variable_l[1];; homalg_variable_7160 := homalg_variable_l[2];;
gap> homalg_variable_7161 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7159 = homalg_variable_7161;
true
gap> homalg_variable_7162 := homalg_variable_7143 * homalg_variable_7160;;
gap> homalg_variable_7163 := homalg_variable_7130 + homalg_variable_7162;;
gap> homalg_variable_7159 = homalg_variable_7163;
true
gap> homalg_variable_7164 := SIH_DecideZeroColumns(homalg_variable_7130,homalg_variable_7143);;
gap> homalg_variable_7165 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7164 = homalg_variable_7165;
true
gap> homalg_variable_7166 := homalg_variable_7160 * (homalg_variable_8);;
gap> homalg_variable_7167 := homalg_variable_7143 * homalg_variable_7166;;
gap> homalg_variable_7167 = homalg_variable_7130;
true
gap> homalg_variable_7168 := SIH_DecideZeroColumns(homalg_variable_7130,homalg_variable_3336);;
gap> homalg_variable_7169 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7168 = homalg_variable_7169;
true
gap> homalg_variable_7170 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_3419);;
gap> SI_ncols(homalg_variable_7170);
1
gap> homalg_variable_7171 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_7170 = homalg_variable_7171;
false
gap> homalg_variable_7172 := SI_\[(homalg_variable_7170,2,1);;
gap> SI_deg( homalg_variable_7172 );
1
gap> homalg_variable_7173 := SI_\[(homalg_variable_7170,1,1);;
gap> SI_deg( homalg_variable_7173 );
1
gap> SIH_ZeroColumns(homalg_variable_3419);
[  ]
gap> homalg_variable_7174 := homalg_variable_3419 * homalg_variable_7170;;
gap> homalg_variable_7175 := SI_matrix(homalg_variable_5,1,1,"0");;
gap> homalg_variable_7174 = homalg_variable_7175;
true
gap> homalg_variable_7176 := SIH_BasisOfColumnModule(homalg_variable_7170);;
gap> SI_ncols(homalg_variable_7176);
1
gap> homalg_variable_7177 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_7176 = homalg_variable_7177;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_7170);; homalg_variable_7178 := homalg_variable_l[1];; homalg_variable_7179 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_7178);
1
gap> homalg_variable_7180 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_7178 = homalg_variable_7180;
false
gap> SI_nrows(homalg_variable_7179);
1
gap> homalg_variable_7181 := homalg_variable_7170 * homalg_variable_7179;;
gap> homalg_variable_7178 = homalg_variable_7181;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_7176,homalg_variable_7178);; homalg_variable_7182 := homalg_variable_l[1];; homalg_variable_7183 := homalg_variable_l[2];;
gap> homalg_variable_7184 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_7182 = homalg_variable_7184;
true
gap> homalg_variable_7185 := homalg_variable_7178 * homalg_variable_7183;;
gap> homalg_variable_7186 := homalg_variable_7176 + homalg_variable_7185;;
gap> homalg_variable_7182 = homalg_variable_7186;
true
gap> homalg_variable_7187 := SIH_DecideZeroColumns(homalg_variable_7176,homalg_variable_7178);;
gap> homalg_variable_7188 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_7187 = homalg_variable_7188;
true
gap> homalg_variable_7189 := homalg_variable_7183 * (homalg_variable_8);;
gap> homalg_variable_7190 := homalg_variable_7179 * homalg_variable_7189;;
gap> homalg_variable_7191 := homalg_variable_7170 * homalg_variable_7190;;
gap> homalg_variable_7191 = homalg_variable_7176;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_7170,homalg_variable_7176);; homalg_variable_7192 := homalg_variable_l[1];; homalg_variable_7193 := homalg_variable_l[2];;
gap> homalg_variable_7194 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_7192 = homalg_variable_7194;
true
gap> homalg_variable_7195 := homalg_variable_7176 * homalg_variable_7193;;
gap> homalg_variable_7196 := homalg_variable_7170 + homalg_variable_7195;;
gap> homalg_variable_7192 = homalg_variable_7196;
true
gap> homalg_variable_7197 := SIH_DecideZeroColumns(homalg_variable_7170,homalg_variable_7176);;
gap> homalg_variable_7198 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_7197 = homalg_variable_7198;
true
gap> homalg_variable_7199 := homalg_variable_7193 * (homalg_variable_8);;
gap> homalg_variable_7200 := homalg_variable_7176 * homalg_variable_7199;;
gap> homalg_variable_7200 = homalg_variable_7170;
true
gap> homalg_variable_7176 = homalg_variable_7170;
true
gap> homalg_variable_7201 := SIH_DecideZeroColumns(homalg_variable_6832,homalg_variable_6781);;
gap> homalg_variable_7202 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_7201 = homalg_variable_7202;
false
gap> homalg_variable_7204 := homalg_variable_7008 * homalg_variable_7077;;
gap> homalg_variable_7203 := SIH_DecideZeroColumns(homalg_variable_7204,homalg_variable_6781);;
gap> homalg_variable_7205 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_7203 = homalg_variable_7205;
false
gap> homalg_variable_7206 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_7204 = homalg_variable_7206;
false
gap> homalg_variable_7207 := SIH_UnionOfColumns(homalg_variable_7203,homalg_variable_6781);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_7207);; homalg_variable_7208 := homalg_variable_l[1];; homalg_variable_7209 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_7208);
3
gap> homalg_variable_7210 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_7208 = homalg_variable_7210;
false
gap> SI_nrows(homalg_variable_7209);
6
gap> homalg_variable_7211 := SIH_Submatrix(homalg_variable_7209,[ 1 ],[1..3]);;
gap> homalg_variable_7212 := homalg_variable_7203 * homalg_variable_7211;;
gap> homalg_variable_7213 := SIH_Submatrix(homalg_variable_7209,[ 2, 3, 4, 5, 6 ],[1..3]);;
gap> homalg_variable_7214 := homalg_variable_6781 * homalg_variable_7213;;
gap> homalg_variable_7215 := homalg_variable_7212 + homalg_variable_7214;;
gap> homalg_variable_7208 = homalg_variable_7215;
true
gap> homalg_variable_7217 := homalg_variable_7201 * homalg_variable_3419;;
gap> homalg_variable_7216 := SIH_DecideZeroColumns(homalg_variable_7217,homalg_variable_6781);;
gap> homalg_variable_7218 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_7216 = homalg_variable_7218;
true
gap> homalg_variable_7220 := homalg_variable_7217 * (homalg_variable_8);;
gap> homalg_variable_7219 := SIH_DecideZeroColumns(homalg_variable_7220,homalg_variable_6781);;
gap> homalg_variable_7221 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_7219 = homalg_variable_7221;
true
gap> homalg_variable_7223 := homalg_variable_7201 * (homalg_variable_8);;
gap> homalg_variable_7224 := homalg_variable_7223 * homalg_variable_3419;;
gap> homalg_variable_7222 := SIH_DecideZeroColumns(homalg_variable_7224,homalg_variable_6781);;
gap> homalg_variable_7225 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_7222 = homalg_variable_7225;
true
gap> homalg_variable_7227 := homalg_variable_7223 * homalg_variable_3419;;
gap> homalg_variable_7228 := SI_matrix(homalg_variable_5,2,3,"0");;
gap> homalg_variable_7229 := SIH_UnionOfColumns(homalg_variable_7227,homalg_variable_7228);;
gap> homalg_variable_7230 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_7231 := homalg_variable_7204 * homalg_variable_3336;;
gap> homalg_variable_7232 := SIH_UnionOfColumns(homalg_variable_7230,homalg_variable_7231);;
gap> homalg_variable_7233 := homalg_variable_7229 + homalg_variable_7232;;
gap> homalg_variable_7226 := SIH_DecideZeroColumns(homalg_variable_7233,homalg_variable_6781);;
gap> homalg_variable_7234 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_7226 = homalg_variable_7234;
true
gap> homalg_variable_7236 := SIH_UnionOfColumns(homalg_variable_7223,homalg_variable_7204);;
gap> homalg_variable_7237 := SIH_UnionOfColumns(homalg_variable_7236,homalg_variable_6781);;
gap> homalg_variable_7235 := SIH_BasisOfColumnModule(homalg_variable_7237);;
gap> SI_ncols(homalg_variable_7235);
2
gap> homalg_variable_7238 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_7235 = homalg_variable_7238;
false
gap> homalg_variable_7239 := SIH_DecideZeroColumns(homalg_variable_813,homalg_variable_7235);;
gap> homalg_variable_7240 := SI_matrix(homalg_variable_5,2,2,"0");;
gap> homalg_variable_7239 = homalg_variable_7240;
true
gap> homalg_variable_7241 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_7236,homalg_variable_6781);;
gap> SI_ncols(homalg_variable_7241);
5
gap> homalg_variable_7242 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_7241 = homalg_variable_7242;
false
gap> homalg_variable_7243 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_7241);;
gap> SI_ncols(homalg_variable_7243);
4
gap> homalg_variable_7244 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_7243 = homalg_variable_7244;
false
gap> homalg_variable_7245 := SI_\[(homalg_variable_7243,5,1);;
gap> SI_deg( homalg_variable_7245 );
-1
gap> homalg_variable_7246 := SI_\[(homalg_variable_7243,4,1);;
gap> SI_deg( homalg_variable_7246 );
1
gap> homalg_variable_7247 := SI_\[(homalg_variable_7243,3,1);;
gap> SI_deg( homalg_variable_7247 );
-1
gap> homalg_variable_7248 := SI_\[(homalg_variable_7243,2,1);;
gap> SI_deg( homalg_variable_7248 );
1
gap> homalg_variable_7249 := SI_\[(homalg_variable_7243,1,1);;
gap> SI_deg( homalg_variable_7249 );
-1
gap> homalg_variable_7250 := SI_\[(homalg_variable_7243,5,2);;
gap> SI_deg( homalg_variable_7250 );
-1
gap> homalg_variable_7251 := SI_\[(homalg_variable_7243,4,2);;
gap> SI_deg( homalg_variable_7251 );
-1
gap> homalg_variable_7252 := SI_\[(homalg_variable_7243,3,2);;
gap> SI_deg( homalg_variable_7252 );
1
gap> homalg_variable_7253 := SI_\[(homalg_variable_7243,2,2);;
gap> SI_deg( homalg_variable_7253 );
-1
gap> homalg_variable_7254 := SI_\[(homalg_variable_7243,1,2);;
gap> SI_deg( homalg_variable_7254 );
1
gap> homalg_variable_7255 := SI_\[(homalg_variable_7243,5,3);;
gap> SI_deg( homalg_variable_7255 );
1
gap> homalg_variable_7256 := SI_\[(homalg_variable_7243,4,3);;
gap> SI_deg( homalg_variable_7256 );
-1
gap> homalg_variable_7257 := SI_\[(homalg_variable_7243,3,3);;
gap> SI_deg( homalg_variable_7257 );
1
gap> homalg_variable_7258 := SI_\[(homalg_variable_7243,2,3);;
gap> SI_deg( homalg_variable_7258 );
-1
gap> homalg_variable_7259 := SI_\[(homalg_variable_7243,1,3);;
gap> SI_deg( homalg_variable_7259 );
-1
gap> homalg_variable_7260 := SI_\[(homalg_variable_7243,5,4);;
gap> SI_deg( homalg_variable_7260 );
1
gap> homalg_variable_7261 := SI_\[(homalg_variable_7243,4,4);;
gap> SI_deg( homalg_variable_7261 );
-1
gap> homalg_variable_7262 := SI_\[(homalg_variable_7243,3,4);;
gap> SI_deg( homalg_variable_7262 );
-1
gap> homalg_variable_7263 := SI_\[(homalg_variable_7243,2,4);;
gap> SI_deg( homalg_variable_7263 );
-1
gap> homalg_variable_7264 := SI_\[(homalg_variable_7243,1,4);;
gap> SI_deg( homalg_variable_7264 );
1
gap> homalg_variable_7265 := SIH_BasisOfColumnModule(homalg_variable_7241);;
gap> SI_ncols(homalg_variable_7265);
5
gap> homalg_variable_7266 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_7265 = homalg_variable_7266;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_7241);; homalg_variable_7267 := homalg_variable_l[1];; homalg_variable_7268 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_7267);
5
gap> homalg_variable_7269 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_7267 = homalg_variable_7269;
false
gap> SI_nrows(homalg_variable_7268);
5
gap> homalg_variable_7270 := homalg_variable_7241 * homalg_variable_7268;;
gap> homalg_variable_7267 = homalg_variable_7270;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_7265,homalg_variable_7267);; homalg_variable_7271 := homalg_variable_l[1];; homalg_variable_7272 := homalg_variable_l[2];;
gap> homalg_variable_7273 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_7271 = homalg_variable_7273;
true
gap> homalg_variable_7274 := homalg_variable_7267 * homalg_variable_7272;;
gap> homalg_variable_7275 := homalg_variable_7265 + homalg_variable_7274;;
gap> homalg_variable_7271 = homalg_variable_7275;
true
gap> homalg_variable_7276 := SIH_DecideZeroColumns(homalg_variable_7265,homalg_variable_7267);;
gap> homalg_variable_7277 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_7276 = homalg_variable_7277;
true
gap> homalg_variable_7278 := homalg_variable_7272 * (homalg_variable_8);;
gap> homalg_variable_7279 := homalg_variable_7268 * homalg_variable_7278;;
gap> homalg_variable_7280 := homalg_variable_7241 * homalg_variable_7279;;
gap> homalg_variable_7280 = homalg_variable_7265;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_7241,homalg_variable_7265);; homalg_variable_7281 := homalg_variable_l[1];; homalg_variable_7282 := homalg_variable_l[2];;
gap> homalg_variable_7283 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_7281 = homalg_variable_7283;
true
gap> homalg_variable_7284 := homalg_variable_7265 * homalg_variable_7282;;
gap> homalg_variable_7285 := homalg_variable_7241 + homalg_variable_7284;;
gap> homalg_variable_7281 = homalg_variable_7285;
true
gap> homalg_variable_7286 := SIH_DecideZeroColumns(homalg_variable_7241,homalg_variable_7265);;
gap> homalg_variable_7287 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_7286 = homalg_variable_7287;
true
gap> homalg_variable_7288 := homalg_variable_7282 * (homalg_variable_8);;
gap> homalg_variable_7289 := homalg_variable_7265 * homalg_variable_7288;;
gap> homalg_variable_7289 = homalg_variable_7241;
true
gap> homalg_variable_7291 := SI_matrix(homalg_variable_5,1,2,"0");;
gap> homalg_variable_7292 := SIH_UnionOfRows(homalg_variable_3419,homalg_variable_7291);;
gap> homalg_variable_7293 := SI_matrix(homalg_variable_5,1,3,"0");;
gap> homalg_variable_7294 := SIH_UnionOfRows(homalg_variable_7293,homalg_variable_3336);;
gap> homalg_variable_7295 := SIH_UnionOfColumns(homalg_variable_7292,homalg_variable_7294);;
gap> homalg_variable_7290 := SIH_BasisOfColumnModule(homalg_variable_7295);;
gap> SI_ncols(homalg_variable_7290);
5
gap> homalg_variable_7296 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_7290 = homalg_variable_7296;
false
gap> homalg_variable_7290 = homalg_variable_7295;
false
gap> homalg_variable_7297 := SIH_DecideZeroColumns(homalg_variable_7241,homalg_variable_7290);;
gap> homalg_variable_7298 := SI_matrix(homalg_variable_5,2,5,"0");;
gap> homalg_variable_7297 = homalg_variable_7298;
true
gap> homalg_variable_7299 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_5877);;
gap> SI_ncols(homalg_variable_7299);
1
gap> homalg_variable_7300 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_7299 = homalg_variable_7300;
false
gap> homalg_variable_7301 := SI_\[(homalg_variable_7299,4,1);;
gap> SI_deg( homalg_variable_7301 );
-1
gap> homalg_variable_7302 := SI_\[(homalg_variable_7299,3,1);;
gap> SI_deg( homalg_variable_7302 );
1
gap> homalg_variable_7303 := SI_\[(homalg_variable_7299,2,1);;
gap> SI_deg( homalg_variable_7303 );
1
gap> homalg_variable_7304 := SI_\[(homalg_variable_7299,1,1);;
gap> SI_deg( homalg_variable_7304 );
1
gap> SIH_ZeroColumns(homalg_variable_5877);
[  ]
gap> homalg_variable_7305 := homalg_variable_5877 * homalg_variable_7299;;
gap> homalg_variable_7306 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_7305 = homalg_variable_7306;
true
gap> homalg_variable_7307 := SIH_BasisOfColumnModule(homalg_variable_7299);;
gap> SI_ncols(homalg_variable_7307);
1
gap> homalg_variable_7308 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_7307 = homalg_variable_7308;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_7299);; homalg_variable_7309 := homalg_variable_l[1];; homalg_variable_7310 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_7309);
1
gap> homalg_variable_7311 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_7309 = homalg_variable_7311;
false
gap> SI_nrows(homalg_variable_7310);
1
gap> homalg_variable_7312 := homalg_variable_7299 * homalg_variable_7310;;
gap> homalg_variable_7309 = homalg_variable_7312;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_7307,homalg_variable_7309);; homalg_variable_7313 := homalg_variable_l[1];; homalg_variable_7314 := homalg_variable_l[2];;
gap> homalg_variable_7315 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_7313 = homalg_variable_7315;
true
gap> homalg_variable_7316 := homalg_variable_7309 * homalg_variable_7314;;
gap> homalg_variable_7317 := homalg_variable_7307 + homalg_variable_7316;;
gap> homalg_variable_7313 = homalg_variable_7317;
true
gap> homalg_variable_7318 := SIH_DecideZeroColumns(homalg_variable_7307,homalg_variable_7309);;
gap> homalg_variable_7319 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_7318 = homalg_variable_7319;
true
gap> homalg_variable_7320 := homalg_variable_7314 * (homalg_variable_8);;
gap> homalg_variable_7321 := homalg_variable_7310 * homalg_variable_7320;;
gap> homalg_variable_7322 := homalg_variable_7299 * homalg_variable_7321;;
gap> homalg_variable_7322 = homalg_variable_7307;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_7299,homalg_variable_7307);; homalg_variable_7323 := homalg_variable_l[1];; homalg_variable_7324 := homalg_variable_l[2];;
gap> homalg_variable_7325 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_7323 = homalg_variable_7325;
true
gap> homalg_variable_7326 := homalg_variable_7307 * homalg_variable_7324;;
gap> homalg_variable_7327 := homalg_variable_7299 + homalg_variable_7326;;
gap> homalg_variable_7323 = homalg_variable_7327;
true
gap> homalg_variable_7328 := SIH_DecideZeroColumns(homalg_variable_7299,homalg_variable_7307);;
gap> homalg_variable_7329 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_7328 = homalg_variable_7329;
true
gap> homalg_variable_7330 := homalg_variable_7324 * (homalg_variable_8);;
gap> homalg_variable_7331 := homalg_variable_7307 * homalg_variable_7330;;
gap> homalg_variable_7331 = homalg_variable_7299;
true
gap> homalg_variable_7307 = homalg_variable_7299;
true
gap> homalg_variable_7332 := SIH_DecideZeroColumns(homalg_variable_6370,homalg_variable_6301);;
gap> homalg_variable_7333 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_7332 = homalg_variable_7333;
false
gap> homalg_variable_7335 := homalg_variable_6724 * homalg_variable_7223;;
gap> homalg_variable_7336 := homalg_variable_6724 * homalg_variable_7204;;
gap> homalg_variable_7337 := SIH_UnionOfColumns(homalg_variable_7335,homalg_variable_7336);;
gap> homalg_variable_7334 := SIH_DecideZeroColumns(homalg_variable_7337,homalg_variable_6301);;
gap> homalg_variable_7338 := SI_matrix(homalg_variable_5,6,2,"0");;
gap> homalg_variable_7334 = homalg_variable_7338;
false
gap> homalg_variable_7339 := SI_matrix(homalg_variable_5,6,1,"0");;
gap> homalg_variable_7335 = homalg_variable_7339;
false
gap> homalg_variable_7340 := SIH_UnionOfColumns(homalg_variable_7334,homalg_variable_6301);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_7340);; homalg_variable_7341 := homalg_variable_l[1];; homalg_variable_7342 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_7341);
7
gap> homalg_variable_7343 := SI_matrix(homalg_variable_5,6,7,"0");;
gap> homalg_variable_7341 = homalg_variable_7343;
false
gap> SI_nrows(homalg_variable_7342);
12
gap> homalg_variable_7344 := SIH_Submatrix(homalg_variable_7342,[ 1, 2 ],[1..7]);;
gap> homalg_variable_7345 := homalg_variable_7334 * homalg_variable_7344;;
gap> homalg_variable_7346 := SIH_Submatrix(homalg_variable_7342,[ 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ],[1..7]);;
gap> homalg_variable_7347 := homalg_variable_6301 * homalg_variable_7346;;
gap> homalg_variable_7348 := homalg_variable_7345 + homalg_variable_7347;;
gap> homalg_variable_7341 = homalg_variable_7348;
true
gap> homalg_variable_7350 := homalg_variable_7332 * homalg_variable_5877;;
gap> homalg_variable_7349 := SIH_DecideZeroColumns(homalg_variable_7350,homalg_variable_6301);;
gap> homalg_variable_7351 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_7349 = homalg_variable_7351;
false
gap> homalg_variable_7352 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_7350 = homalg_variable_7352;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_7349,homalg_variable_7341);; homalg_variable_7353 := homalg_variable_l[1];; homalg_variable_7354 := homalg_variable_l[2];;
gap> homalg_variable_7355 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_7353 = homalg_variable_7355;
true
gap> homalg_variable_7356 := homalg_variable_7341 * homalg_variable_7354;;
gap> homalg_variable_7357 := homalg_variable_7349 + homalg_variable_7356;;
gap> homalg_variable_7353 = homalg_variable_7357;
true
gap> homalg_variable_7358 := SIH_DecideZeroColumns(homalg_variable_7349,homalg_variable_7341);;
gap> homalg_variable_7359 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_7358 = homalg_variable_7359;
true
gap> homalg_variable_7361 := SIH_Submatrix(homalg_variable_7342,[ 1 ],[1..7]);;
gap> homalg_variable_7362 := homalg_variable_7354 * (homalg_variable_8);;
gap> homalg_variable_7363 := homalg_variable_7361 * homalg_variable_7362;;
gap> homalg_variable_7364 := homalg_variable_7335 * homalg_variable_7363;;
gap> homalg_variable_7365 := SIH_Submatrix(homalg_variable_7342,[ 2 ],[1..7]);;
gap> homalg_variable_7366 := homalg_variable_7365 * homalg_variable_7362;;
gap> homalg_variable_7367 := homalg_variable_7336 * homalg_variable_7366;;
gap> homalg_variable_7368 := homalg_variable_7364 + homalg_variable_7367;;
gap> homalg_variable_7369 := homalg_variable_7368 - homalg_variable_7350;;
gap> homalg_variable_7360 := SIH_DecideZeroColumns(homalg_variable_7369,homalg_variable_6301);;
gap> homalg_variable_7370 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_7360 = homalg_variable_7370;
true
gap> homalg_variable_7372 := SIH_Submatrix(homalg_variable_7342,[ 1, 2 ],[1..7]);;
gap> homalg_variable_7373 := homalg_variable_7372 * homalg_variable_7362;;
gap> homalg_variable_7374 := homalg_variable_7373 * homalg_variable_7307;;
gap> homalg_variable_7371 := SIH_DecideZeroColumns(homalg_variable_7374,homalg_variable_7290);;
gap> homalg_variable_7375 := SI_matrix(homalg_variable_5,2,1,"0");;
gap> homalg_variable_7371 = homalg_variable_7375;
true
gap> homalg_variable_7376 := SIH_DecideZeroColumns(homalg_variable_7373,homalg_variable_7290);;
gap> homalg_variable_7377 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_7376 = homalg_variable_7377;
false
gap> homalg_variable_7378 := SI_matrix(homalg_variable_5,2,4,"0");;
gap> homalg_variable_7373 = homalg_variable_7378;
false
gap> homalg_variable_7380 := homalg_variable_7332 * (homalg_variable_8);;
gap> homalg_variable_7381 := homalg_variable_7380 * homalg_variable_5877;;
gap> homalg_variable_7382 := SIH_Submatrix(homalg_variable_7376,[ 1 ],[1..4]);;
gap> homalg_variable_7383 := homalg_variable_7335 * homalg_variable_7382;;
gap> homalg_variable_7384 := SIH_Submatrix(homalg_variable_7376,[ 2 ],[1..4]);;
gap> homalg_variable_7385 := homalg_variable_7336 * homalg_variable_7384;;
gap> homalg_variable_7386 := homalg_variable_7383 + homalg_variable_7385;;
gap> homalg_variable_7387 := homalg_variable_7381 + homalg_variable_7386;;
gap> homalg_variable_7379 := SIH_DecideZeroColumns(homalg_variable_7387,homalg_variable_6301);;
gap> homalg_variable_7388 := SI_matrix(homalg_variable_5,6,4,"0");;
gap> homalg_variable_7379 = homalg_variable_7388;
true
gap> homalg_variable_7390 := homalg_variable_7380 * homalg_variable_5877;;
gap> homalg_variable_7391 := SI_matrix(homalg_variable_5,6,5,"0");;
gap> homalg_variable_7392 := SIH_UnionOfColumns(homalg_variable_7390,homalg_variable_7391);;
gap> homalg_variable_7393 := SIH_Submatrix(homalg_variable_7376,[ 1 ],[1..4]);;
gap> homalg_variable_7394 := homalg_variable_7335 * homalg_variable_7393;;
gap> homalg_variable_7395 := homalg_variable_7335 * homalg_variable_3419;;
gap> homalg_variable_7396 := SI_matrix(homalg_variable_5,6,3,"0");;
gap> homalg_variable_7397 := SIH_UnionOfColumns(homalg_variable_7395,homalg_variable_7396);;
gap> homalg_variable_7398 := SIH_UnionOfColumns(homalg_variable_7394,homalg_variable_7397);;
gap> homalg_variable_7399 := SIH_Submatrix(homalg_variable_7376,[ 2 ],[1..4]);;
gap> homalg_variable_7400 := homalg_variable_7336 * homalg_variable_7399;;
gap> homalg_variable_7401 := SI_matrix(homalg_variable_5,6,2,"0");;
gap> homalg_variable_7402 := homalg_variable_7336 * homalg_variable_3336;;
gap> homalg_variable_7403 := SIH_UnionOfColumns(homalg_variable_7401,homalg_variable_7402);;
gap> homalg_variable_7404 := SIH_UnionOfColumns(homalg_variable_7400,homalg_variable_7403);;
gap> homalg_variable_7405 := homalg_variable_7398 + homalg_variable_7404;;
gap> homalg_variable_7406 := homalg_variable_7392 + homalg_variable_7405;;
gap> homalg_variable_7389 := SIH_DecideZeroColumns(homalg_variable_7406,homalg_variable_6301);;
gap> homalg_variable_7407 := SI_matrix(homalg_variable_5,6,9,"0");;
gap> homalg_variable_7389 = homalg_variable_7407;
true
gap> homalg_variable_7409 := SIH_UnionOfColumns(homalg_variable_7380,homalg_variable_7337);;
gap> homalg_variable_7410 := SIH_UnionOfColumns(homalg_variable_7409,homalg_variable_6301);;
gap> homalg_variable_7408 := SIH_BasisOfColumnModule(homalg_variable_7410);;
gap> SI_ncols(homalg_variable_7408);
6
gap> homalg_variable_7411 := SI_matrix(homalg_variable_5,6,6,"0");;
gap> homalg_variable_7408 = homalg_variable_7411;
false
gap> homalg_variable_7412 := SIH_DecideZeroColumns(homalg_variable_6691,homalg_variable_7408);;
gap> homalg_variable_7413 := SI_matrix(homalg_variable_5,6,6,"0");;
gap> homalg_variable_7412 = homalg_variable_7413;
true
gap> homalg_variable_7414 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_7409,homalg_variable_6301);;
gap> SI_ncols(homalg_variable_7414);
9
gap> homalg_variable_7415 := SI_matrix(homalg_variable_5,5,9,"0");;
gap> homalg_variable_7414 = homalg_variable_7415;
false
gap> homalg_variable_7416 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_7414);;
gap> SI_ncols(homalg_variable_7416);
5
gap> homalg_variable_7417 := SI_matrix(homalg_variable_5,9,5,"0");;
gap> homalg_variable_7416 = homalg_variable_7417;
false
gap> homalg_variable_7418 := SI_\[(homalg_variable_7416,9,1);;
gap> SI_deg( homalg_variable_7418 );
-1
gap> homalg_variable_7419 := SI_\[(homalg_variable_7416,8,1);;
gap> SI_deg( homalg_variable_7419 );
-1
gap> homalg_variable_7420 := SI_\[(homalg_variable_7416,7,1);;
gap> SI_deg( homalg_variable_7420 );
-1
gap> homalg_variable_7421 := SI_\[(homalg_variable_7416,6,1);;
gap> SI_deg( homalg_variable_7421 );
-1
gap> homalg_variable_7422 := SI_\[(homalg_variable_7416,5,1);;
gap> SI_deg( homalg_variable_7422 );
-1
gap> homalg_variable_7423 := SI_\[(homalg_variable_7416,4,1);;
gap> SI_deg( homalg_variable_7423 );
1
gap> homalg_variable_7424 := SI_\[(homalg_variable_7416,3,1);;
gap> SI_deg( homalg_variable_7424 );
-1
gap> homalg_variable_7425 := SI_\[(homalg_variable_7416,2,1);;
gap> SI_deg( homalg_variable_7425 );
1
gap> homalg_variable_7426 := SI_\[(homalg_variable_7416,1,1);;
gap> SI_deg( homalg_variable_7426 );
-1
gap> homalg_variable_7427 := SI_\[(homalg_variable_7416,9,2);;
gap> SI_deg( homalg_variable_7427 );
-1
gap> homalg_variable_7428 := SI_\[(homalg_variable_7416,8,2);;
gap> SI_deg( homalg_variable_7428 );
-1
gap> homalg_variable_7429 := SI_\[(homalg_variable_7416,7,2);;
gap> SI_deg( homalg_variable_7429 );
-1
gap> homalg_variable_7430 := SI_\[(homalg_variable_7416,6,2);;
gap> SI_deg( homalg_variable_7430 );
-1
gap> homalg_variable_7431 := SI_\[(homalg_variable_7416,5,2);;
gap> SI_deg( homalg_variable_7431 );
-1
gap> homalg_variable_7432 := SI_\[(homalg_variable_7416,4,2);;
gap> SI_deg( homalg_variable_7432 );
-1
gap> homalg_variable_7433 := SI_\[(homalg_variable_7416,3,2);;
gap> SI_deg( homalg_variable_7433 );
1
gap> homalg_variable_7434 := SI_\[(homalg_variable_7416,2,2);;
gap> SI_deg( homalg_variable_7434 );
-1
gap> homalg_variable_7435 := SI_\[(homalg_variable_7416,1,2);;
gap> SI_deg( homalg_variable_7435 );
1
gap> homalg_variable_7436 := SI_\[(homalg_variable_7416,9,3);;
gap> SI_deg( homalg_variable_7436 );
-1
gap> homalg_variable_7437 := SI_\[(homalg_variable_7416,8,3);;
gap> SI_deg( homalg_variable_7437 );
1
gap> homalg_variable_7438 := SI_\[(homalg_variable_7416,7,3);;
gap> SI_deg( homalg_variable_7438 );
1
gap> homalg_variable_7439 := SI_\[(homalg_variable_7416,6,3);;
gap> SI_deg( homalg_variable_7439 );
-1
gap> homalg_variable_7440 := SI_\[(homalg_variable_7416,5,3);;
gap> SI_deg( homalg_variable_7440 );
1
gap> homalg_variable_7441 := SI_\[(homalg_variable_7416,4,3);;
gap> SI_deg( homalg_variable_7441 );
-1
gap> homalg_variable_7442 := SI_\[(homalg_variable_7416,3,3);;
gap> SI_deg( homalg_variable_7442 );
0
gap> homalg_variable_7443 := SI_\[(homalg_variable_7416,1,3);;
gap> IsZero(homalg_variable_7443);
true
gap> homalg_variable_7444 := SI_\[(homalg_variable_7416,2,3);;
gap> IsZero(homalg_variable_7444);
false
gap> homalg_variable_7445 := SI_\[(homalg_variable_7416,3,3);;
gap> IsZero(homalg_variable_7445);
false
gap> homalg_variable_7446 := SI_\[(homalg_variable_7416,4,3);;
gap> IsZero(homalg_variable_7446);
true
gap> homalg_variable_7447 := SI_\[(homalg_variable_7416,5,3);;
gap> IsZero(homalg_variable_7447);
false
gap> homalg_variable_7448 := SI_\[(homalg_variable_7416,6,3);;
gap> IsZero(homalg_variable_7448);
true
gap> homalg_variable_7449 := SI_\[(homalg_variable_7416,7,3);;
gap> IsZero(homalg_variable_7449);
false
gap> homalg_variable_7450 := SI_\[(homalg_variable_7416,8,3);;
gap> IsZero(homalg_variable_7450);
false
gap> homalg_variable_7451 := SI_\[(homalg_variable_7416,9,3);;
gap> IsZero(homalg_variable_7451);
true
gap> homalg_variable_7452 := SI_\[(homalg_variable_7416,9,4);;
gap> SI_deg( homalg_variable_7452 );
-1
gap> homalg_variable_7453 := SI_\[(homalg_variable_7416,6,4);;
gap> SI_deg( homalg_variable_7453 );
1
gap> homalg_variable_7454 := SI_\[(homalg_variable_7416,4,4);;
gap> SI_deg( homalg_variable_7454 );
-1
gap> homalg_variable_7455 := SI_\[(homalg_variable_7416,1,4);;
gap> SI_deg( homalg_variable_7455 );
-1
gap> homalg_variable_7456 := SI_\[(homalg_variable_7416,9,5);;
gap> SI_deg( homalg_variable_7456 );
-1
gap> homalg_variable_7457 := SI_\[(homalg_variable_7416,6,5);;
gap> SI_deg( homalg_variable_7457 );
1
gap> homalg_variable_7458 := SI_\[(homalg_variable_7416,4,5);;
gap> SI_deg( homalg_variable_7458 );
-1
gap> homalg_variable_7459 := SI_\[(homalg_variable_7416,1,5);;
gap> SI_deg( homalg_variable_7459 );
1
gap> homalg_variable_7461 := SIH_Submatrix(homalg_variable_7414,[1..5],[ 1, 2, 4, 5, 6, 7, 8, 9 ]);;
gap> homalg_variable_7460 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_7461);;
gap> SI_ncols(homalg_variable_7460);
4
gap> homalg_variable_7462 := SI_matrix(homalg_variable_5,8,4,"0");;
gap> homalg_variable_7460 = homalg_variable_7462;
false
gap> homalg_variable_7463 := SI_\[(homalg_variable_7460,8,1);;
gap> SI_deg( homalg_variable_7463 );
-1
gap> homalg_variable_7464 := SI_\[(homalg_variable_7460,7,1);;
gap> SI_deg( homalg_variable_7464 );
-1
gap> homalg_variable_7465 := SI_\[(homalg_variable_7460,6,1);;
gap> SI_deg( homalg_variable_7465 );
-1
gap> homalg_variable_7466 := SI_\[(homalg_variable_7460,5,1);;
gap> SI_deg( homalg_variable_7466 );
-1
gap> homalg_variable_7467 := SI_\[(homalg_variable_7460,4,1);;
gap> SI_deg( homalg_variable_7467 );
-1
gap> homalg_variable_7468 := SI_\[(homalg_variable_7460,3,1);;
gap> SI_deg( homalg_variable_7468 );
1
gap> homalg_variable_7469 := SI_\[(homalg_variable_7460,2,1);;
gap> SI_deg( homalg_variable_7469 );
1
gap> homalg_variable_7470 := SI_\[(homalg_variable_7460,1,1);;
gap> SI_deg( homalg_variable_7470 );
-1
gap> homalg_variable_7471 := SI_\[(homalg_variable_7460,8,2);;
gap> SI_deg( homalg_variable_7471 );
-1
gap> homalg_variable_7472 := SI_\[(homalg_variable_7460,7,2);;
gap> SI_deg( homalg_variable_7472 );
-1
gap> homalg_variable_7473 := SI_\[(homalg_variable_7460,6,2);;
gap> SI_deg( homalg_variable_7473 );
-1
gap> homalg_variable_7474 := SI_\[(homalg_variable_7460,5,2);;
gap> SI_deg( homalg_variable_7474 );
1
gap> homalg_variable_7475 := SI_\[(homalg_variable_7460,4,2);;
gap> SI_deg( homalg_variable_7475 );
-1
gap> homalg_variable_7476 := SI_\[(homalg_variable_7460,3,2);;
gap> SI_deg( homalg_variable_7476 );
-1
gap> homalg_variable_7477 := SI_\[(homalg_variable_7460,2,2);;
gap> SI_deg( homalg_variable_7477 );
-1
gap> homalg_variable_7478 := SI_\[(homalg_variable_7460,1,2);;
gap> SI_deg( homalg_variable_7478 );
1
gap> homalg_variable_7479 := SI_\[(homalg_variable_7460,8,3);;
gap> SI_deg( homalg_variable_7479 );
-1
gap> homalg_variable_7480 := SI_\[(homalg_variable_7460,7,3);;
gap> SI_deg( homalg_variable_7480 );
2
gap> homalg_variable_7481 := SI_\[(homalg_variable_7460,6,3);;
gap> SI_deg( homalg_variable_7481 );
2
gap> homalg_variable_7482 := SI_\[(homalg_variable_7460,5,3);;
gap> SI_deg( homalg_variable_7482 );
-1
gap> homalg_variable_7483 := SI_\[(homalg_variable_7460,4,3);;
gap> SI_deg( homalg_variable_7483 );
2
gap> homalg_variable_7484 := SI_\[(homalg_variable_7460,3,3);;
gap> SI_deg( homalg_variable_7484 );
-1
gap> homalg_variable_7485 := SI_\[(homalg_variable_7460,2,3);;
gap> SI_deg( homalg_variable_7485 );
1
gap> homalg_variable_7486 := SI_\[(homalg_variable_7460,1,3);;
gap> SI_deg( homalg_variable_7486 );
1
gap> homalg_variable_7487 := SI_\[(homalg_variable_7460,8,4);;
gap> SI_deg( homalg_variable_7487 );
-1
gap> homalg_variable_7488 := SI_\[(homalg_variable_7460,7,4);;
gap> SI_deg( homalg_variable_7488 );
2
gap> homalg_variable_7489 := SI_\[(homalg_variable_7460,6,4);;
gap> SI_deg( homalg_variable_7489 );
2
gap> homalg_variable_7490 := SI_\[(homalg_variable_7460,5,4);;
gap> SI_deg( homalg_variable_7490 );
1
gap> homalg_variable_7491 := SI_\[(homalg_variable_7460,4,4);;
gap> SI_deg( homalg_variable_7491 );
2
gap> homalg_variable_7492 := SI_\[(homalg_variable_7460,3,4);;
gap> SI_deg( homalg_variable_7492 );
-1
gap> homalg_variable_7493 := SI_\[(homalg_variable_7460,2,4);;
gap> SI_deg( homalg_variable_7493 );
1
gap> homalg_variable_7494 := SI_\[(homalg_variable_7460,1,4);;
gap> SI_deg( homalg_variable_7494 );
-1
gap> homalg_variable_7495 := SI_matrix(homalg_variable_5,5,8,"0");;
gap> homalg_variable_7461 = homalg_variable_7495;
false
gap> homalg_variable_7496 := SIH_BasisOfColumnModule(homalg_variable_7414);;
gap> SI_ncols(homalg_variable_7496);
9
gap> homalg_variable_7497 := SI_matrix(homalg_variable_5,5,9,"0");;
gap> homalg_variable_7496 = homalg_variable_7497;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_7461);; homalg_variable_7498 := homalg_variable_l[1];; homalg_variable_7499 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_7498);
9
gap> homalg_variable_7500 := SI_matrix(homalg_variable_5,5,9,"0");;
gap> homalg_variable_7498 = homalg_variable_7500;
false
gap> SI_nrows(homalg_variable_7499);
8
gap> for _del in [ "homalg_variable_88", "homalg_variable_89", "homalg_variable_95", "homalg_variable_96", "homalg_variable_97", "homalg_variable_238", "homalg_variable_239", "homalg_variable_243", "homalg_variable_244", "homalg_variable_309", "homalg_variable_362", "homalg_variable_363", "homalg_variable_365", "homalg_variable_366", "homalg_variable_369", "homalg_variable_413", "homalg_variable_450", "homalg_variable_451", "homalg_variable_528", "homalg_variable_529", "homalg_variable_535", "homalg_variable_536", "homalg_variable_612", "homalg_variable_613", "homalg_variable_617", "homalg_variable_618", "homalg_variable_619", "homalg_variable_799", "homalg_variable_804", "homalg_variable_879", "homalg_variable_880", "homalg_variable_888", "homalg_variable_895", "homalg_variable_899", "homalg_variable_900", "homalg_variable_991", "homalg_variable_992", "homalg_variable_998", "homalg_variable_1141", "homalg_variable_1142", "homalg_variable_1203", "homalg_variable_1204", "homalg_variable_1210", "homalg_variable_1211", "homalg_variable_1212", "homalg_variable_1269", "homalg_variable_1271", "homalg_variable_1272", "homalg_variable_1278", "homalg_variable_1279", "homalg_variable_1320", "homalg_variable_1322", "homalg_variable_1380", "homalg_variable_1383", "homalg_variable_1384", "homalg_variable_1386", "homalg_variable_1392", "homalg_variable_1394", "homalg_variable_1479", "homalg_variable_1591", "homalg_variable_1594", "homalg_variable_1595", "homalg_variable_1603", "homalg_variable_1605", "homalg_variable_1716", "homalg_variable_1717", "homalg_variable_1719", "homalg_variable_1720", "homalg_variable_1723", "homalg_variable_1778", "homalg_variable_1779", "homalg_variable_1783", "homalg_variable_1785", "homalg_variable_1786", "homalg_variable_1933", "homalg_variable_1934", "homalg_variable_1935", "homalg_variable_1936", "homalg_variable_1937", "homalg_variable_1938", "homalg_variable_1939", "homalg_variable_1997", "homalg_variable_2099", "homalg_variable_2100", "homalg_variable_2102", "homalg_variable_2103", "homalg_variable_2106", "homalg_variable_2138", "homalg_variable_2147", "homalg_variable_2148", "homalg_variable_2149", "homalg_variable_2198", "homalg_variable_2199", "homalg_variable_2201", "homalg_variable_2202", "homalg_variable_2210", "homalg_variable_2212", "homalg_variable_2306", "homalg_variable_2307", "homalg_variable_2309", "homalg_variable_2310", "homalg_variable_2313", "homalg_variable_2314", "homalg_variable_2389", "homalg_variable_2435", "homalg_variable_2436", "homalg_variable_2437", "homalg_variable_2438", "homalg_variable_2439", "homalg_variable_2440", "homalg_variable_2441", "homalg_variable_2521", "homalg_variable_2522", "homalg_variable_2524", "homalg_variable_2525", "homalg_variable_2528", "homalg_variable_2529", "homalg_variable_2617", "homalg_variable_2620", "homalg_variable_2621", "homalg_variable_2654", "homalg_variable_2657", "homalg_variable_2658", "homalg_variable_2666", "homalg_variable_2668", "homalg_variable_2675", "homalg_variable_2679", "homalg_variable_2680", "homalg_variable_2713", "homalg_variable_2718", "homalg_variable_2765", "homalg_variable_2766", "homalg_variable_2767", "homalg_variable_2776", "homalg_variable_2777", "homalg_variable_3015", "homalg_variable_3016", "homalg_variable_3020", "homalg_variable_3022", "homalg_variable_3058", "homalg_variable_3059", "homalg_variable_3060", "homalg_variable_3065", "homalg_variable_3074", "homalg_variable_3076", "homalg_variable_3087", "homalg_variable_3088", "homalg_variable_3090", "homalg_variable_3092", "homalg_variable_3093", "homalg_variable_3094", "homalg_variable_3095", "homalg_variable_3138", "homalg_variable_3193", "homalg_variable_3194", "homalg_variable_3195", "homalg_variable_3251", "homalg_variable_3276", "homalg_variable_3278", "homalg_variable_3279", "homalg_variable_3281", "homalg_variable_3287", "homalg_variable_3288", "homalg_variable_3289", "homalg_variable_3290", "homalg_variable_3293", "homalg_variable_3421", "homalg_variable_3422", "homalg_variable_3458", "homalg_variable_3494", "homalg_variable_3612", "homalg_variable_3615", "homalg_variable_3616", "homalg_variable_3653", "homalg_variable_3654", "homalg_variable_3655", "homalg_variable_3656", "homalg_variable_3664", "homalg_variable_3669", "homalg_variable_3701", "homalg_variable_3736", "homalg_variable_3818", "homalg_variable_3819", "homalg_variable_3820", "homalg_variable_3826", "homalg_variable_3827", "homalg_variable_3880", "homalg_variable_3884", "homalg_variable_3926", "homalg_variable_3927", "homalg_variable_3933", "homalg_variable_3937", "homalg_variable_3956", "homalg_variable_3957", "homalg_variable_3963", "homalg_variable_3964", "homalg_variable_3965", "homalg_variable_3981", "homalg_variable_3982", "homalg_variable_4003", "homalg_variable_4004", "homalg_variable_4008", "homalg_variable_4009", "homalg_variable_4010", "homalg_variable_4060", "homalg_variable_4083", "homalg_variable_4084", "homalg_variable_4088", "homalg_variable_4089", "homalg_variable_4090", "homalg_variable_4111", "homalg_variable_4191", "homalg_variable_4252", "homalg_variable_4253", "homalg_variable_4259", "homalg_variable_4280", "homalg_variable_4310", "homalg_variable_4311", "homalg_variable_4332", "homalg_variable_4333", "homalg_variable_4339", "homalg_variable_4340", "homalg_variable_4363", "homalg_variable_4364", "homalg_variable_4365", "homalg_variable_4370", "homalg_variable_4389", "homalg_variable_4419", "homalg_variable_4428", "homalg_variable_4429", "homalg_variable_4430", "homalg_variable_4459", "homalg_variable_4460", "homalg_variable_4464", "homalg_variable_4466", "homalg_variable_4480", "homalg_variable_4481", "homalg_variable_4485", "homalg_variable_4486", "homalg_variable_4487", "homalg_variable_4488", "homalg_variable_4520", "homalg_variable_4527", "homalg_variable_4531", "homalg_variable_4557", "homalg_variable_4559", "homalg_variable_4560", "homalg_variable_4563", "homalg_variable_4564", "homalg_variable_4565", "homalg_variable_4570", "homalg_variable_4571", "homalg_variable_4609", "homalg_variable_4613", "homalg_variable_4617", "homalg_variable_4619", "homalg_variable_4620", "homalg_variable_4623", "homalg_variable_4624", "homalg_variable_4630", "homalg_variable_4631", "homalg_variable_4669", "homalg_variable_4673", "homalg_variable_4680", "homalg_variable_4682", "homalg_variable_4683", "homalg_variable_4727", "homalg_variable_4731", "homalg_variable_4737", "homalg_variable_4739", "homalg_variable_4740", "homalg_variable_4762", "homalg_variable_4788", "homalg_variable_4790", "homalg_variable_4791", "homalg_variable_4799", "homalg_variable_4801", "homalg_variable_4830", "homalg_variable_4831", "homalg_variable_4837", "homalg_variable_4838", "homalg_variable_4852", "homalg_variable_4853", "homalg_variable_4881", "homalg_variable_4883", "homalg_variable_4884", "homalg_variable_4892", "homalg_variable_4894", "homalg_variable_4922", "homalg_variable_4924", "homalg_variable_4925", "homalg_variable_4931", "homalg_variable_4932", "homalg_variable_4946", "homalg_variable_4947", "homalg_variable_5040", "homalg_variable_5043", "homalg_variable_5069", "homalg_variable_5071", "homalg_variable_5072", "homalg_variable_5075", "homalg_variable_5076", "homalg_variable_5080", "homalg_variable_5082", "homalg_variable_5083", "homalg_variable_5108", "homalg_variable_5143", "homalg_variable_5144", "homalg_variable_5145", "homalg_variable_5150", "homalg_variable_5154", "homalg_variable_5160", "homalg_variable_5186", "homalg_variable_5188", "homalg_variable_5189", "homalg_variable_5191", "homalg_variable_5192", "homalg_variable_5193", "homalg_variable_5199", "homalg_variable_5200", "homalg_variable_5217", "homalg_variable_5245", "homalg_variable_5246", "homalg_variable_5247", "homalg_variable_5252", "homalg_variable_5256", "homalg_variable_5257", "homalg_variable_5264", "homalg_variable_5266", "homalg_variable_5270", "homalg_variable_5272", "homalg_variable_5273", "homalg_variable_5286", "homalg_variable_5287", "homalg_variable_5291", "homalg_variable_5292", "homalg_variable_5293", "homalg_variable_5319", "homalg_variable_5339", "homalg_variable_5340", "homalg_variable_5344", "homalg_variable_5345", "homalg_variable_5346", "homalg_variable_5348", "homalg_variable_5349", "homalg_variable_5350", "homalg_variable_5357", "homalg_variable_5359", "homalg_variable_5365", "homalg_variable_5366", "homalg_variable_5368", "homalg_variable_5369", "homalg_variable_5393", "homalg_variable_5394", "homalg_variable_5395", "homalg_variable_5402", "homalg_variable_5403", "homalg_variable_5404", "homalg_variable_5410", "homalg_variable_5412", "homalg_variable_5413", "homalg_variable_5426", "homalg_variable_5427", "homalg_variable_5431", "homalg_variable_5433", "homalg_variable_5437", "homalg_variable_5438", "homalg_variable_5477", "homalg_variable_5514", "homalg_variable_5515", "homalg_variable_5558", "homalg_variable_5559", "homalg_variable_5565", "homalg_variable_5628", "homalg_variable_5629", "homalg_variable_5635", "homalg_variable_5636", "homalg_variable_5649", "homalg_variable_5651", "homalg_variable_5655", "homalg_variable_5657", "homalg_variable_5658", "homalg_variable_5659", "homalg_variable_5661", "homalg_variable_5662", "homalg_variable_5668", "homalg_variable_5669", "homalg_variable_5680", "homalg_variable_5681", "homalg_variable_5692", "homalg_variable_5694", "homalg_variable_5701", "homalg_variable_5703", "homalg_variable_5704", "homalg_variable_5717", "homalg_variable_5718", "homalg_variable_5719", "homalg_variable_5724", "homalg_variable_5732", "homalg_variable_5738", "homalg_variable_5740", "homalg_variable_5746", "homalg_variable_5748", "homalg_variable_5749", "homalg_variable_5752", "homalg_variable_5753", "homalg_variable_5755", "homalg_variable_5756", "homalg_variable_5759", "homalg_variable_5760", "homalg_variable_5773", "homalg_variable_5774", "homalg_variable_5790", "homalg_variable_5817", "homalg_variable_5825", "homalg_variable_5827", "homalg_variable_5828", "homalg_variable_5829", "homalg_variable_5830", "homalg_variable_5831", "homalg_variable_5848", "homalg_variable_5849", "homalg_variable_5855", "homalg_variable_5856", "homalg_variable_5859", "homalg_variable_5860", "homalg_variable_5861", "homalg_variable_5862", "homalg_variable_5863", "homalg_variable_5864", "homalg_variable_5867", "homalg_variable_5868", "homalg_variable_5872", "homalg_variable_5873", "homalg_variable_5874", "homalg_variable_5875", "homalg_variable_5893", "homalg_variable_5895", "homalg_variable_5896", "homalg_variable_5911", "homalg_variable_5935", "homalg_variable_5936", "homalg_variable_5937", "homalg_variable_5938", "homalg_variable_5939", "homalg_variable_5942", "homalg_variable_5944", "homalg_variable_5968", "homalg_variable_5969", "homalg_variable_5972", "homalg_variable_5973", "homalg_variable_5974", "homalg_variable_5975", "homalg_variable_5978", "homalg_variable_5979", "homalg_variable_5985", "homalg_variable_5986", "homalg_variable_5992", "homalg_variable_5993", "homalg_variable_5997", "homalg_variable_5999", "homalg_variable_6000", "homalg_variable_6003", "homalg_variable_6004", "homalg_variable_6006", "homalg_variable_6007", "homalg_variable_6008", "homalg_variable_6010", "homalg_variable_6011", "homalg_variable_6012", "homalg_variable_6013", "homalg_variable_6014", "homalg_variable_6017", "homalg_variable_6018", "homalg_variable_6024", "homalg_variable_6025", "homalg_variable_6026", "homalg_variable_6043", "homalg_variable_6045", "homalg_variable_6046", "homalg_variable_6061", "homalg_variable_6077", "homalg_variable_6082", "homalg_variable_6113", "homalg_variable_6114", "homalg_variable_6126", "homalg_variable_6128", "homalg_variable_6144", "homalg_variable_6145", "homalg_variable_6147", "homalg_variable_6148", "homalg_variable_6156", "homalg_variable_6158", "homalg_variable_6163", "homalg_variable_6164", "homalg_variable_6177", "homalg_variable_6211", "homalg_variable_6212", "homalg_variable_6243", "homalg_variable_6275", "homalg_variable_6292", "homalg_variable_6293", "homalg_variable_6299", "homalg_variable_6305", "homalg_variable_6306", "homalg_variable_6314", "homalg_variable_6321", "homalg_variable_6325", "homalg_variable_6326", "homalg_variable_6327", "homalg_variable_6328", "homalg_variable_6329", "homalg_variable_6337", "homalg_variable_6344", "homalg_variable_6348", "homalg_variable_6349", "homalg_variable_6351", "homalg_variable_6352", "homalg_variable_6360", "homalg_variable_6367", "homalg_variable_6371", "homalg_variable_6372", "homalg_variable_6374", "homalg_variable_6378", "homalg_variable_6394", "homalg_variable_6395", "homalg_variable_6425", "homalg_variable_6426", "homalg_variable_6430", "homalg_variable_6431", "homalg_variable_6455", "homalg_variable_6470", "homalg_variable_6472", "homalg_variable_6473", "homalg_variable_6476", "homalg_variable_6477", "homalg_variable_6478", "homalg_variable_6483", "homalg_variable_6484", "homalg_variable_6486", "homalg_variable_6487", "homalg_variable_6491", "homalg_variable_6492", "homalg_variable_6493", "homalg_variable_6519", "homalg_variable_6520", "homalg_variable_6521", "homalg_variable_6526", "homalg_variable_6527", "homalg_variable_6529", "homalg_variable_6530", "homalg_variable_6534", "homalg_variable_6535", "homalg_variable_6536", "homalg_variable_6543", "homalg_variable_6544", "homalg_variable_6548", "homalg_variable_6550", "homalg_variable_6554", "homalg_variable_6556", "homalg_variable_6557", "homalg_variable_6558", "homalg_variable_6560", "homalg_variable_6561", "homalg_variable_6567", "homalg_variable_6568", "homalg_variable_6570", "homalg_variable_6571", "homalg_variable_6572", "homalg_variable_6577", "homalg_variable_6581", "homalg_variable_6582", "homalg_variable_6583", "homalg_variable_6605", "homalg_variable_6607", "homalg_variable_6608", "homalg_variable_6618", "homalg_variable_6620", "homalg_variable_6621", "homalg_variable_6624", "homalg_variable_6625", "homalg_variable_6631", "homalg_variable_6632", "homalg_variable_6634", "homalg_variable_6635", "homalg_variable_6637", "homalg_variable_6638", "homalg_variable_6641", "homalg_variable_6647", "homalg_variable_6652", "homalg_variable_6654", "homalg_variable_6660", "homalg_variable_6662", "homalg_variable_6663", "homalg_variable_6666", "homalg_variable_6667", "homalg_variable_6671", "homalg_variable_6673", "homalg_variable_6674", "homalg_variable_6676", "homalg_variable_6677", "homalg_variable_6683", "homalg_variable_6684", "homalg_variable_6687", "homalg_variable_6688", "homalg_variable_6690", "homalg_variable_6692", "homalg_variable_6693", "homalg_variable_6696", "homalg_variable_6697", "homalg_variable_6705", "homalg_variable_6707", "homalg_variable_6721", "homalg_variable_6722", "homalg_variable_6727", "homalg_variable_6729", "homalg_variable_6730", "homalg_variable_6731", "homalg_variable_6749", "homalg_variable_6750", "homalg_variable_6762", "homalg_variable_6763", "homalg_variable_6765", "homalg_variable_6766", "homalg_variable_6769", "homalg_variable_6770", "homalg_variable_6772", "homalg_variable_6773", "homalg_variable_6777", "homalg_variable_6779", "homalg_variable_6783", "homalg_variable_6785", "homalg_variable_6786", "homalg_variable_6794", "homalg_variable_6796", "homalg_variable_6798", "homalg_variable_6810", "homalg_variable_6811", "homalg_variable_6813", "homalg_variable_6819", "homalg_variable_6822", "homalg_variable_6825", "homalg_variable_6826", "homalg_variable_6836", "homalg_variable_6839", "homalg_variable_6840", "homalg_variable_6859", "homalg_variable_6860", "homalg_variable_6861", "homalg_variable_6863", "homalg_variable_6864", "homalg_variable_6867", "homalg_variable_6868", "homalg_variable_6872", "homalg_variable_6874", "homalg_variable_6875", "homalg_variable_6877", "homalg_variable_6878", "homalg_variable_6882", "homalg_variable_6884", "homalg_variable_6905", "homalg_variable_6910", "homalg_variable_6911", "homalg_variable_6915", "homalg_variable_6916", "homalg_variable_6917", "homalg_variable_6918", "homalg_variable_6920", "homalg_variable_6921", "homalg_variable_6925", "homalg_variable_6926", "homalg_variable_6927", "homalg_variable_6936", "homalg_variable_6937", "homalg_variable_6938", "homalg_variable_6939", "homalg_variable_6941", "homalg_variable_6945", "homalg_variable_6947", "homalg_variable_6948", "homalg_variable_6951", "homalg_variable_6952", "homalg_variable_6956", "homalg_variable_6957", "homalg_variable_6958", "homalg_variable_6959", "homalg_variable_6961", "homalg_variable_6962", "homalg_variable_6966", "homalg_variable_6968", "homalg_variable_6972", "homalg_variable_6973", "homalg_variable_6977", "homalg_variable_6980", "homalg_variable_6981", "homalg_variable_6989", "homalg_variable_6990", "homalg_variable_6991", "homalg_variable_6996", "homalg_variable_6997", "homalg_variable_6998", "homalg_variable_7002", "homalg_variable_7003", "homalg_variable_7004", "homalg_variable_7005", "homalg_variable_7006", "homalg_variable_7007", "homalg_variable_7009", "homalg_variable_7010", "homalg_variable_7011", "homalg_variable_7012", "homalg_variable_7013", "homalg_variable_7014", "homalg_variable_7015", "homalg_variable_7017", "homalg_variable_7019", "homalg_variable_7020", "homalg_variable_7021", "homalg_variable_7022", "homalg_variable_7023", "homalg_variable_7024", "homalg_variable_7025", "homalg_variable_7026", "homalg_variable_7027", "homalg_variable_7028", "homalg_variable_7030", "homalg_variable_7033", "homalg_variable_7034", "homalg_variable_7035", "homalg_variable_7036", "homalg_variable_7037", "homalg_variable_7038", "homalg_variable_7039", "homalg_variable_7040", "homalg_variable_7041", "homalg_variable_7042", "homalg_variable_7043", "homalg_variable_7044", "homalg_variable_7045", "homalg_variable_7046", "homalg_variable_7047", "homalg_variable_7048", "homalg_variable_7049", "homalg_variable_7050", "homalg_variable_7051", "homalg_variable_7052", "homalg_variable_7053", "homalg_variable_7055", "homalg_variable_7056", "homalg_variable_7057", "homalg_variable_7058", "homalg_variable_7059", "homalg_variable_7061", "homalg_variable_7062", "homalg_variable_7063", "homalg_variable_7064", "homalg_variable_7065", "homalg_variable_7066", "homalg_variable_7067", "homalg_variable_7069", "homalg_variable_7070", "homalg_variable_7071", "homalg_variable_7072", "homalg_variable_7073", "homalg_variable_7074", "homalg_variable_7078", "homalg_variable_7079", "homalg_variable_7080", "homalg_variable_7081", "homalg_variable_7083", "homalg_variable_7084", "homalg_variable_7085", "homalg_variable_7086", "homalg_variable_7087", "homalg_variable_7088", "homalg_variable_7089", "homalg_variable_7090", "homalg_variable_7091", "homalg_variable_7092", "homalg_variable_7093", "homalg_variable_7094", "homalg_variable_7095", "homalg_variable_7096", "homalg_variable_7097", "homalg_variable_7098", "homalg_variable_7099", "homalg_variable_7100", "homalg_variable_7101", "homalg_variable_7102", "homalg_variable_7103", "homalg_variable_7104", "homalg_variable_7105", "homalg_variable_7106", "homalg_variable_7107", "homalg_variable_7108", "homalg_variable_7109", "homalg_variable_7110", "homalg_variable_7111", "homalg_variable_7112", "homalg_variable_7113", "homalg_variable_7114", "homalg_variable_7115", "homalg_variable_7116", "homalg_variable_7117", "homalg_variable_7118", "homalg_variable_7119", "homalg_variable_7121", "homalg_variable_7122", "homalg_variable_7123", "homalg_variable_7124", "homalg_variable_7127", "homalg_variable_7128", "homalg_variable_7129", "homalg_variable_7131", "homalg_variable_7133", "homalg_variable_7134", "homalg_variable_7135", "homalg_variable_7136", "homalg_variable_7137", "homalg_variable_7138", "homalg_variable_7139", "homalg_variable_7140", "homalg_variable_7141", "homalg_variable_7142", "homalg_variable_7144", "homalg_variable_7147", "homalg_variable_7148", "homalg_variable_7149", "homalg_variable_7150", "homalg_variable_7151", "homalg_variable_7152", "homalg_variable_7153", "homalg_variable_7154", "homalg_variable_7155", "homalg_variable_7156", "homalg_variable_7157", "homalg_variable_7158", "homalg_variable_7159", "homalg_variable_7160", "homalg_variable_7161", "homalg_variable_7162", "homalg_variable_7163", "homalg_variable_7164", "homalg_variable_7165", "homalg_variable_7166", "homalg_variable_7167", "homalg_variable_7168", "homalg_variable_7169", "homalg_variable_7171", "homalg_variable_7172", "homalg_variable_7173", "homalg_variable_7174", "homalg_variable_7175", "homalg_variable_7177", "homalg_variable_7180", "homalg_variable_7181", "homalg_variable_7182", "homalg_variable_7183", "homalg_variable_7184", "homalg_variable_7185", "homalg_variable_7186", "homalg_variable_7187", "homalg_variable_7188", "homalg_variable_7189", "homalg_variable_7190", "homalg_variable_7191", "homalg_variable_7192", "homalg_variable_7193", "homalg_variable_7194", "homalg_variable_7195", "homalg_variable_7196", "homalg_variable_7197", "homalg_variable_7198", "homalg_variable_7199", "homalg_variable_7200", "homalg_variable_7202", "homalg_variable_7203", "homalg_variable_7205", "homalg_variable_7206", "homalg_variable_7207", "homalg_variable_7208", "homalg_variable_7209", "homalg_variable_7210", "homalg_variable_7211", "homalg_variable_7212", "homalg_variable_7213", "homalg_variable_7214", "homalg_variable_7215", "homalg_variable_7216", "homalg_variable_7218", "homalg_variable_7219", "homalg_variable_7221", "homalg_variable_7222", "homalg_variable_7224", "homalg_variable_7225", "homalg_variable_7226", "homalg_variable_7227", "homalg_variable_7228", "homalg_variable_7229", "homalg_variable_7230", "homalg_variable_7231", "homalg_variable_7232", "homalg_variable_7233", "homalg_variable_7234", "homalg_variable_7238", "homalg_variable_7239", "homalg_variable_7240", "homalg_variable_7242", "homalg_variable_7244", "homalg_variable_7245", "homalg_variable_7246", "homalg_variable_7247", "homalg_variable_7248", "homalg_variable_7249", "homalg_variable_7250", "homalg_variable_7251", "homalg_variable_7252", "homalg_variable_7253", "homalg_variable_7254", "homalg_variable_7255", "homalg_variable_7256", "homalg_variable_7257", "homalg_variable_7258", "homalg_variable_7259", "homalg_variable_7260", "homalg_variable_7261", "homalg_variable_7262", "homalg_variable_7263", "homalg_variable_7264", "homalg_variable_7266", "homalg_variable_7269", "homalg_variable_7270", "homalg_variable_7273", "homalg_variable_7274", "homalg_variable_7275", "homalg_variable_7280", "homalg_variable_7281", "homalg_variable_7282", "homalg_variable_7283", "homalg_variable_7284", "homalg_variable_7285", "homalg_variable_7286", "homalg_variable_7287", "homalg_variable_7288", "homalg_variable_7289", "homalg_variable_7296", "homalg_variable_7297", "homalg_variable_7298", "homalg_variable_7300", "homalg_variable_7301", "homalg_variable_7302", "homalg_variable_7303", "homalg_variable_7304", "homalg_variable_7305", "homalg_variable_7306", "homalg_variable_7308", "homalg_variable_7311", "homalg_variable_7312", "homalg_variable_7313", "homalg_variable_7314", "homalg_variable_7315", "homalg_variable_7316", "homalg_variable_7317", "homalg_variable_7318", "homalg_variable_7319", "homalg_variable_7320", "homalg_variable_7321", "homalg_variable_7322", "homalg_variable_7323", "homalg_variable_7324", "homalg_variable_7325", "homalg_variable_7326", "homalg_variable_7327", "homalg_variable_7328", "homalg_variable_7329", "homalg_variable_7330", "homalg_variable_7331", "homalg_variable_7333", "homalg_variable_7338", "homalg_variable_7339", "homalg_variable_7343", "homalg_variable_7344", "homalg_variable_7345", "homalg_variable_7346", "homalg_variable_7347", "homalg_variable_7348", "homalg_variable_7351", "homalg_variable_7352", "homalg_variable_7355", "homalg_variable_7356", "homalg_variable_7357", "homalg_variable_7358", "homalg_variable_7359", "homalg_variable_7360", "homalg_variable_7361", "homalg_variable_7363", "homalg_variable_7364", "homalg_variable_7365", "homalg_variable_7366", "homalg_variable_7367", "homalg_variable_7368", "homalg_variable_7369", "homalg_variable_7370", "homalg_variable_7371", "homalg_variable_7374", "homalg_variable_7375", "homalg_variable_7377", "homalg_variable_7378", "homalg_variable_7379", "homalg_variable_7381", "homalg_variable_7382", "homalg_variable_7383", "homalg_variable_7384", "homalg_variable_7385", "homalg_variable_7386", "homalg_variable_7387", "homalg_variable_7388", "homalg_variable_7389", "homalg_variable_7390", "homalg_variable_7391", "homalg_variable_7392", "homalg_variable_7393", "homalg_variable_7394", "homalg_variable_7395", "homalg_variable_7396", "homalg_variable_7397", "homalg_variable_7398", "homalg_variable_7399", "homalg_variable_7400", "homalg_variable_7401", "homalg_variable_7402", "homalg_variable_7403", "homalg_variable_7404", "homalg_variable_7405", "homalg_variable_7406", "homalg_variable_7407", "homalg_variable_7411", "homalg_variable_7412", "homalg_variable_7413", "homalg_variable_7415", "homalg_variable_7417", "homalg_variable_7418", "homalg_variable_7419", "homalg_variable_7420", "homalg_variable_7421", "homalg_variable_7422", "homalg_variable_7423", "homalg_variable_7424", "homalg_variable_7425", "homalg_variable_7426", "homalg_variable_7427", "homalg_variable_7428", "homalg_variable_7429", "homalg_variable_7430", "homalg_variable_7431", "homalg_variable_7432", "homalg_variable_7433", "homalg_variable_7434", "homalg_variable_7435", "homalg_variable_7436", "homalg_variable_7437", "homalg_variable_7438", "homalg_variable_7439", "homalg_variable_7440", "homalg_variable_7441", "homalg_variable_7442", "homalg_variable_7443", "homalg_variable_7444", "homalg_variable_7445", "homalg_variable_7446", "homalg_variable_7447", "homalg_variable_7448", "homalg_variable_7449", "homalg_variable_7450", "homalg_variable_7451", "homalg_variable_7452", "homalg_variable_7453", "homalg_variable_7454", "homalg_variable_7455", "homalg_variable_7456", "homalg_variable_7457", "homalg_variable_7458", "homalg_variable_7459" ] do UnbindGlobal( _del );; od;;
gap> homalg_variable_7501 := homalg_variable_7461 * homalg_variable_7499;;
gap> homalg_variable_7498 = homalg_variable_7501;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_7496,homalg_variable_7498);; homalg_variable_7502 := homalg_variable_l[1];; homalg_variable_7503 := homalg_variable_l[2];;
gap> homalg_variable_7504 := SI_matrix(homalg_variable_5,5,9,"0");;
gap> homalg_variable_7502 = homalg_variable_7504;
true
gap> homalg_variable_7505 := homalg_variable_7498 * homalg_variable_7503;;
gap> homalg_variable_7506 := homalg_variable_7496 + homalg_variable_7505;;
gap> homalg_variable_7502 = homalg_variable_7506;
true
gap> homalg_variable_7507 := SIH_DecideZeroColumns(homalg_variable_7496,homalg_variable_7498);;
gap> homalg_variable_7508 := SI_matrix(homalg_variable_5,5,9,"0");;
gap> homalg_variable_7507 = homalg_variable_7508;
true
gap> homalg_variable_7509 := homalg_variable_7503 * (homalg_variable_8);;
gap> homalg_variable_7510 := homalg_variable_7499 * homalg_variable_7509;;
gap> homalg_variable_7511 := homalg_variable_7461 * homalg_variable_7510;;
gap> homalg_variable_7511 = homalg_variable_7496;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_7461,homalg_variable_7496);; homalg_variable_7512 := homalg_variable_l[1];; homalg_variable_7513 := homalg_variable_l[2];;
gap> homalg_variable_7514 := SI_matrix(homalg_variable_5,5,8,"0");;
gap> homalg_variable_7512 = homalg_variable_7514;
true
gap> homalg_variable_7515 := homalg_variable_7496 * homalg_variable_7513;;
gap> homalg_variable_7516 := homalg_variable_7461 + homalg_variable_7515;;
gap> homalg_variable_7512 = homalg_variable_7516;
true
gap> homalg_variable_7517 := SIH_DecideZeroColumns(homalg_variable_7461,homalg_variable_7496);;
gap> homalg_variable_7518 := SI_matrix(homalg_variable_5,5,8,"0");;
gap> homalg_variable_7517 = homalg_variable_7518;
true
gap> homalg_variable_7519 := homalg_variable_7513 * (homalg_variable_8);;
gap> homalg_variable_7520 := homalg_variable_7496 * homalg_variable_7519;;
gap> homalg_variable_7520 = homalg_variable_7461;
true
gap> homalg_variable_7522 := SIH_UnionOfRows(homalg_variable_5877,homalg_variable_7376);;
gap> homalg_variable_7523 := SI_matrix(homalg_variable_5,3,5,"0");;
gap> homalg_variable_7524 := SIH_UnionOfRows(homalg_variable_7523,homalg_variable_7295);;
gap> homalg_variable_7525 := SIH_UnionOfColumns(homalg_variable_7522,homalg_variable_7524);;
gap> homalg_variable_7521 := SIH_BasisOfColumnModule(homalg_variable_7525);;
gap> SI_ncols(homalg_variable_7521);
9
gap> homalg_variable_7526 := SI_matrix(homalg_variable_5,5,9,"0");;
gap> homalg_variable_7521 = homalg_variable_7526;
false
gap> homalg_variable_7521 = homalg_variable_7525;
false
gap> homalg_variable_7527 := SIH_DecideZeroColumns(homalg_variable_7461,homalg_variable_7521);;
gap> homalg_variable_7528 := SI_matrix(homalg_variable_5,5,8,"0");;
gap> homalg_variable_7527 = homalg_variable_7528;
true
gap> homalg_variable_7529 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_6027);;
gap> SI_ncols(homalg_variable_7529);
1
gap> homalg_variable_7530 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_7529 = homalg_variable_7530;
false
gap> homalg_variable_7531 := SI_\[(homalg_variable_7529,3,1);;
gap> SI_deg( homalg_variable_7531 );
1
gap> homalg_variable_7532 := SI_\[(homalg_variable_7529,2,1);;
gap> SI_deg( homalg_variable_7532 );
1
gap> homalg_variable_7533 := SI_\[(homalg_variable_7529,1,1);;
gap> SI_deg( homalg_variable_7533 );
1
gap> SIH_ZeroColumns(homalg_variable_6027);
[  ]
gap> homalg_variable_7534 := homalg_variable_6027 * homalg_variable_7529;;
gap> homalg_variable_7535 := SI_matrix(homalg_variable_5,4,1,"0");;
gap> homalg_variable_7534 = homalg_variable_7535;
true
gap> homalg_variable_7536 := SIH_BasisOfColumnModule(homalg_variable_7529);;
gap> SI_ncols(homalg_variable_7536);
1
gap> homalg_variable_7537 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_7536 = homalg_variable_7537;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_7529);; homalg_variable_7538 := homalg_variable_l[1];; homalg_variable_7539 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_7538);
1
gap> homalg_variable_7540 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_7538 = homalg_variable_7540;
false
gap> SI_nrows(homalg_variable_7539);
1
gap> homalg_variable_7541 := homalg_variable_7529 * homalg_variable_7539;;
gap> homalg_variable_7538 = homalg_variable_7541;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_7536,homalg_variable_7538);; homalg_variable_7542 := homalg_variable_l[1];; homalg_variable_7543 := homalg_variable_l[2];;
gap> homalg_variable_7544 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_7542 = homalg_variable_7544;
true
gap> homalg_variable_7545 := homalg_variable_7538 * homalg_variable_7543;;
gap> homalg_variable_7546 := homalg_variable_7536 + homalg_variable_7545;;
gap> homalg_variable_7542 = homalg_variable_7546;
true
gap> homalg_variable_7547 := SIH_DecideZeroColumns(homalg_variable_7536,homalg_variable_7538);;
gap> homalg_variable_7548 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_7547 = homalg_variable_7548;
true
gap> homalg_variable_7549 := homalg_variable_7543 * (homalg_variable_8);;
gap> homalg_variable_7550 := homalg_variable_7539 * homalg_variable_7549;;
gap> homalg_variable_7551 := homalg_variable_7529 * homalg_variable_7550;;
gap> homalg_variable_7551 = homalg_variable_7536;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_7529,homalg_variable_7536);; homalg_variable_7552 := homalg_variable_l[1];; homalg_variable_7553 := homalg_variable_l[2];;
gap> homalg_variable_7554 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_7552 = homalg_variable_7554;
true
gap> homalg_variable_7555 := homalg_variable_7536 * homalg_variable_7553;;
gap> homalg_variable_7556 := homalg_variable_7529 + homalg_variable_7555;;
gap> homalg_variable_7552 = homalg_variable_7556;
true
gap> homalg_variable_7557 := SIH_DecideZeroColumns(homalg_variable_7529,homalg_variable_7536);;
gap> homalg_variable_7558 := SI_matrix(homalg_variable_5,3,1,"0");;
gap> homalg_variable_7557 = homalg_variable_7558;
true
gap> homalg_variable_7559 := homalg_variable_7553 * (homalg_variable_8);;
gap> homalg_variable_7560 := homalg_variable_7536 * homalg_variable_7559;;
gap> homalg_variable_7560 = homalg_variable_7529;
true
gap> homalg_variable_7536 = homalg_variable_7529;
true
gap> homalg_variable_7562 := homalg_variable_6175 * homalg_variable_7380;;
gap> homalg_variable_7563 := homalg_variable_6175 * homalg_variable_7335;;
gap> homalg_variable_7564 := homalg_variable_6175 * homalg_variable_7336;;
gap> homalg_variable_7565 := SIH_UnionOfColumns(homalg_variable_7563,homalg_variable_7564);;
gap> homalg_variable_7566 := SIH_UnionOfColumns(homalg_variable_7562,homalg_variable_7565);;
gap> homalg_variable_7561 := SIH_DecideZeroColumns(homalg_variable_7566,homalg_variable_10);;
gap> homalg_variable_7567 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_7561 = homalg_variable_7567;
false
gap> homalg_variable_7568 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_7562 = homalg_variable_7568;
false
gap> homalg_variable_7569 := SIH_UnionOfColumns(homalg_variable_7561,homalg_variable_10);;
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_7569);; homalg_variable_7570 := homalg_variable_l[1];; homalg_variable_7571 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_7570);
4
gap> homalg_variable_7572 := SI_matrix(homalg_variable_5,5,4,"0");;
gap> homalg_variable_7570 = homalg_variable_7572;
false
gap> SI_nrows(homalg_variable_7571);
11
gap> homalg_variable_7573 := SIH_Submatrix(homalg_variable_7571,[ 1, 2, 3, 4, 5 ],[1..4]);;
gap> homalg_variable_7574 := homalg_variable_7561 * homalg_variable_7573;;
gap> homalg_variable_7575 := SIH_Submatrix(homalg_variable_7571,[ 6, 7, 8, 9, 10, 11 ],[1..4]);;
gap> homalg_variable_7576 := homalg_variable_10 * homalg_variable_7575;;
gap> homalg_variable_7577 := homalg_variable_7574 + homalg_variable_7576;;
gap> homalg_variable_7570 = homalg_variable_7577;
true
gap> homalg_variable_7579 := homalg_variable_6129 * homalg_variable_6027;;
gap> homalg_variable_7578 := SIH_DecideZeroColumns(homalg_variable_7579,homalg_variable_10);;
gap> homalg_variable_7580 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_7578 = homalg_variable_7580;
false
gap> homalg_variable_7581 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_7579 = homalg_variable_7581;
false
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_7578,homalg_variable_7570);; homalg_variable_7582 := homalg_variable_l[1];; homalg_variable_7583 := homalg_variable_l[2];;
gap> homalg_variable_7584 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_7582 = homalg_variable_7584;
true
gap> homalg_variable_7585 := homalg_variable_7570 * homalg_variable_7583;;
gap> homalg_variable_7586 := homalg_variable_7578 + homalg_variable_7585;;
gap> homalg_variable_7582 = homalg_variable_7586;
true
gap> homalg_variable_7587 := SIH_DecideZeroColumns(homalg_variable_7578,homalg_variable_7570);;
gap> homalg_variable_7588 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_7587 = homalg_variable_7588;
true
gap> homalg_variable_7590 := SIH_Submatrix(homalg_variable_7571,[ 1, 2, 3 ],[1..4]);;
gap> homalg_variable_7591 := homalg_variable_7583 * (homalg_variable_8);;
gap> homalg_variable_7592 := homalg_variable_7590 * homalg_variable_7591;;
gap> homalg_variable_7593 := homalg_variable_7562 * homalg_variable_7592;;
gap> homalg_variable_7594 := SIH_Submatrix(homalg_variable_7571,[ 4 ],[1..4]);;
gap> homalg_variable_7595 := homalg_variable_7594 * homalg_variable_7591;;
gap> homalg_variable_7596 := homalg_variable_7563 * homalg_variable_7595;;
gap> homalg_variable_7597 := SIH_Submatrix(homalg_variable_7571,[ 5 ],[1..4]);;
gap> homalg_variable_7598 := homalg_variable_7597 * homalg_variable_7591;;
gap> homalg_variable_7599 := homalg_variable_7564 * homalg_variable_7598;;
gap> homalg_variable_7600 := homalg_variable_7596 + homalg_variable_7599;;
gap> homalg_variable_7601 := homalg_variable_7593 + homalg_variable_7600;;
gap> homalg_variable_7602 := homalg_variable_7601 - homalg_variable_7579;;
gap> homalg_variable_7589 := SIH_DecideZeroColumns(homalg_variable_7602,homalg_variable_10);;
gap> homalg_variable_7603 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_7589 = homalg_variable_7603;
true
gap> homalg_variable_7605 := SIH_Submatrix(homalg_variable_7571,[ 1, 2, 3, 4, 5 ],[1..4]);;
gap> homalg_variable_7606 := homalg_variable_7605 * homalg_variable_7591;;
gap> homalg_variable_7607 := homalg_variable_7606 * homalg_variable_7536;;
gap> homalg_variable_7604 := SIH_DecideZeroColumns(homalg_variable_7607,homalg_variable_7521);;
gap> homalg_variable_7608 := SI_matrix(homalg_variable_5,5,1,"0");;
gap> homalg_variable_7604 = homalg_variable_7608;
true
gap> homalg_variable_7609 := SIH_DecideZeroColumns(homalg_variable_7606,homalg_variable_7521);;
gap> homalg_variable_7610 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_7609 = homalg_variable_7610;
false
gap> homalg_variable_7611 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_7606 = homalg_variable_7611;
false
gap> homalg_variable_7613 := homalg_variable_6129 * (homalg_variable_8);;
gap> homalg_variable_7614 := homalg_variable_7613 * homalg_variable_6027;;
gap> homalg_variable_7615 := SIH_Submatrix(homalg_variable_7609,[ 1, 2, 3 ],[1..3]);;
gap> homalg_variable_7616 := homalg_variable_7562 * homalg_variable_7615;;
gap> homalg_variable_7617 := SIH_Submatrix(homalg_variable_7609,[ 4 ],[1..3]);;
gap> homalg_variable_7618 := homalg_variable_7563 * homalg_variable_7617;;
gap> homalg_variable_7619 := SIH_Submatrix(homalg_variable_7609,[ 5 ],[1..3]);;
gap> homalg_variable_7620 := homalg_variable_7564 * homalg_variable_7619;;
gap> homalg_variable_7621 := homalg_variable_7618 + homalg_variable_7620;;
gap> homalg_variable_7622 := homalg_variable_7616 + homalg_variable_7621;;
gap> homalg_variable_7623 := homalg_variable_7614 + homalg_variable_7622;;
gap> homalg_variable_7612 := SIH_DecideZeroColumns(homalg_variable_7623,homalg_variable_10);;
gap> homalg_variable_7624 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_7612 = homalg_variable_7624;
true
gap> homalg_variable_7626 := homalg_variable_7613 * homalg_variable_6027;;
gap> homalg_variable_7627 := SI_matrix(homalg_variable_5,5,9,"0");;
gap> homalg_variable_7628 := SIH_UnionOfColumns(homalg_variable_7626,homalg_variable_7627);;
gap> homalg_variable_7629 := SIH_Submatrix(homalg_variable_7609,[ 1, 2, 3 ],[1..3]);;
gap> homalg_variable_7630 := homalg_variable_7562 * homalg_variable_7629;;
gap> homalg_variable_7631 := homalg_variable_7562 * homalg_variable_5877;;
gap> homalg_variable_7632 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_7633 := SIH_UnionOfColumns(homalg_variable_7631,homalg_variable_7632);;
gap> homalg_variable_7634 := SIH_UnionOfColumns(homalg_variable_7630,homalg_variable_7633);;
gap> homalg_variable_7635 := SIH_Submatrix(homalg_variable_7609,[ 4 ],[1..3]);;
gap> homalg_variable_7636 := homalg_variable_7563 * homalg_variable_7635;;
gap> homalg_variable_7637 := SIH_Submatrix(homalg_variable_7376,[ 1 ],[1..4]);;
gap> homalg_variable_7638 := homalg_variable_7563 * homalg_variable_7637;;
gap> homalg_variable_7639 := homalg_variable_7563 * homalg_variable_3419;;
gap> homalg_variable_7640 := SI_matrix(homalg_variable_5,5,3,"0");;
gap> homalg_variable_7641 := SIH_UnionOfColumns(homalg_variable_7639,homalg_variable_7640);;
gap> homalg_variable_7642 := SIH_UnionOfColumns(homalg_variable_7638,homalg_variable_7641);;
gap> homalg_variable_7643 := SIH_UnionOfColumns(homalg_variable_7636,homalg_variable_7642);;
gap> homalg_variable_7644 := SIH_Submatrix(homalg_variable_7609,[ 5 ],[1..3]);;
gap> homalg_variable_7645 := homalg_variable_7564 * homalg_variable_7644;;
gap> homalg_variable_7646 := SIH_Submatrix(homalg_variable_7376,[ 2 ],[1..4]);;
gap> homalg_variable_7647 := homalg_variable_7564 * homalg_variable_7646;;
gap> homalg_variable_7648 := SI_matrix(homalg_variable_5,5,2,"0");;
gap> homalg_variable_7649 := homalg_variable_7564 * homalg_variable_3336;;
gap> homalg_variable_7650 := SIH_UnionOfColumns(homalg_variable_7648,homalg_variable_7649);;
gap> homalg_variable_7651 := SIH_UnionOfColumns(homalg_variable_7647,homalg_variable_7650);;
gap> homalg_variable_7652 := SIH_UnionOfColumns(homalg_variable_7645,homalg_variable_7651);;
gap> homalg_variable_7653 := homalg_variable_7643 + homalg_variable_7652;;
gap> homalg_variable_7654 := homalg_variable_7634 + homalg_variable_7653;;
gap> homalg_variable_7655 := homalg_variable_7628 + homalg_variable_7654;;
gap> homalg_variable_7625 := SIH_DecideZeroColumns(homalg_variable_7655,homalg_variable_10);;
gap> homalg_variable_7656 := SI_matrix(homalg_variable_5,5,12,"0");;
gap> homalg_variable_7625 = homalg_variable_7656;
true
gap> homalg_variable_7658 := SIH_UnionOfColumns(homalg_variable_7613,homalg_variable_7566);;
gap> homalg_variable_7659 := SIH_UnionOfColumns(homalg_variable_7658,homalg_variable_10);;
gap> homalg_variable_7657 := SIH_BasisOfColumnModule(homalg_variable_7659);;
gap> SI_ncols(homalg_variable_7657);
5
gap> homalg_variable_7660 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_7657 = homalg_variable_7660;
false
gap> homalg_variable_7661 := SIH_DecideZeroColumns(homalg_variable_42,homalg_variable_7657);;
gap> homalg_variable_7662 := SI_matrix(homalg_variable_5,5,5,"0");;
gap> homalg_variable_7661 = homalg_variable_7662;
true
gap> homalg_variable_7663 := SIH_RelativeSyzygiesGeneratorsOfColumns(homalg_variable_7658,homalg_variable_10);;
gap> SI_ncols(homalg_variable_7663);
12
gap> homalg_variable_7664 := SI_matrix(homalg_variable_5,9,12,"0");;
gap> homalg_variable_7663 = homalg_variable_7664;
false
gap> homalg_variable_7665 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_7663);;
gap> SI_ncols(homalg_variable_7665);
6
gap> homalg_variable_7666 := SI_matrix(homalg_variable_5,12,6,"0");;
gap> homalg_variable_7665 = homalg_variable_7666;
false
gap> homalg_variable_7667 := SI_\[(homalg_variable_7665,12,1);;
gap> SI_deg( homalg_variable_7667 );
-1
gap> homalg_variable_7668 := SI_\[(homalg_variable_7665,11,1);;
gap> SI_deg( homalg_variable_7668 );
-1
gap> homalg_variable_7669 := SI_\[(homalg_variable_7665,10,1);;
gap> SI_deg( homalg_variable_7669 );
-1
gap> homalg_variable_7670 := SI_\[(homalg_variable_7665,9,1);;
gap> SI_deg( homalg_variable_7670 );
-1
gap> homalg_variable_7671 := SI_\[(homalg_variable_7665,8,1);;
gap> SI_deg( homalg_variable_7671 );
-1
gap> homalg_variable_7672 := SI_\[(homalg_variable_7665,7,1);;
gap> SI_deg( homalg_variable_7672 );
-1
gap> homalg_variable_7673 := SI_\[(homalg_variable_7665,6,1);;
gap> SI_deg( homalg_variable_7673 );
-1
gap> homalg_variable_7674 := SI_\[(homalg_variable_7665,5,1);;
gap> SI_deg( homalg_variable_7674 );
-1
gap> homalg_variable_7675 := SI_\[(homalg_variable_7665,4,1);;
gap> SI_deg( homalg_variable_7675 );
1
gap> homalg_variable_7676 := SI_\[(homalg_variable_7665,3,1);;
gap> SI_deg( homalg_variable_7676 );
-1
gap> homalg_variable_7677 := SI_\[(homalg_variable_7665,2,1);;
gap> SI_deg( homalg_variable_7677 );
1
gap> homalg_variable_7678 := SI_\[(homalg_variable_7665,1,1);;
gap> SI_deg( homalg_variable_7678 );
-1
gap> homalg_variable_7679 := SI_\[(homalg_variable_7665,12,2);;
gap> SI_deg( homalg_variable_7679 );
-1
gap> homalg_variable_7680 := SI_\[(homalg_variable_7665,11,2);;
gap> SI_deg( homalg_variable_7680 );
-1
gap> homalg_variable_7681 := SI_\[(homalg_variable_7665,10,2);;
gap> SI_deg( homalg_variable_7681 );
-1
gap> homalg_variable_7682 := SI_\[(homalg_variable_7665,9,2);;
gap> SI_deg( homalg_variable_7682 );
-1
gap> homalg_variable_7683 := SI_\[(homalg_variable_7665,8,2);;
gap> SI_deg( homalg_variable_7683 );
-1
gap> homalg_variable_7684 := SI_\[(homalg_variable_7665,7,2);;
gap> SI_deg( homalg_variable_7684 );
-1
gap> homalg_variable_7685 := SI_\[(homalg_variable_7665,6,2);;
gap> SI_deg( homalg_variable_7685 );
-1
gap> homalg_variable_7686 := SI_\[(homalg_variable_7665,5,2);;
gap> SI_deg( homalg_variable_7686 );
-1
gap> homalg_variable_7687 := SI_\[(homalg_variable_7665,4,2);;
gap> SI_deg( homalg_variable_7687 );
-1
gap> homalg_variable_7688 := SI_\[(homalg_variable_7665,3,2);;
gap> SI_deg( homalg_variable_7688 );
1
gap> homalg_variable_7689 := SI_\[(homalg_variable_7665,2,2);;
gap> SI_deg( homalg_variable_7689 );
-1
gap> homalg_variable_7690 := SI_\[(homalg_variable_7665,1,2);;
gap> SI_deg( homalg_variable_7690 );
1
gap> homalg_variable_7691 := SI_\[(homalg_variable_7665,12,3);;
gap> SI_deg( homalg_variable_7691 );
1
gap> homalg_variable_7692 := SI_\[(homalg_variable_7665,11,3);;
gap> SI_deg( homalg_variable_7692 );
-1
gap> homalg_variable_7693 := SI_\[(homalg_variable_7665,10,3);;
gap> SI_deg( homalg_variable_7693 );
1
gap> homalg_variable_7694 := SI_\[(homalg_variable_7665,9,3);;
gap> SI_deg( homalg_variable_7694 );
1
gap> homalg_variable_7695 := SI_\[(homalg_variable_7665,8,3);;
gap> SI_deg( homalg_variable_7695 );
-1
gap> homalg_variable_7696 := SI_\[(homalg_variable_7665,7,3);;
gap> SI_deg( homalg_variable_7696 );
-1
gap> homalg_variable_7697 := SI_\[(homalg_variable_7665,6,3);;
gap> SI_deg( homalg_variable_7697 );
-1
gap> homalg_variable_7698 := SI_\[(homalg_variable_7665,5,3);;
gap> SI_deg( homalg_variable_7698 );
0
gap> homalg_variable_7699 := SI_\[(homalg_variable_7665,1,3);;
gap> IsZero(homalg_variable_7699);
true
gap> homalg_variable_7700 := SI_\[(homalg_variable_7665,2,3);;
gap> IsZero(homalg_variable_7700);
true
gap> homalg_variable_7701 := SI_\[(homalg_variable_7665,3,3);;
gap> IsZero(homalg_variable_7701);
true
gap> homalg_variable_7702 := SI_\[(homalg_variable_7665,4,3);;
gap> IsZero(homalg_variable_7702);
true
gap> homalg_variable_7703 := SI_\[(homalg_variable_7665,5,3);;
gap> IsZero(homalg_variable_7703);
false
gap> homalg_variable_7704 := SI_\[(homalg_variable_7665,6,3);;
gap> IsZero(homalg_variable_7704);
true
gap> homalg_variable_7705 := SI_\[(homalg_variable_7665,7,3);;
gap> IsZero(homalg_variable_7705);
true
gap> homalg_variable_7706 := SI_\[(homalg_variable_7665,8,3);;
gap> IsZero(homalg_variable_7706);
true
gap> homalg_variable_7707 := SI_\[(homalg_variable_7665,9,3);;
gap> IsZero(homalg_variable_7707);
false
gap> homalg_variable_7708 := SI_\[(homalg_variable_7665,10,3);;
gap> IsZero(homalg_variable_7708);
false
gap> homalg_variable_7709 := SI_\[(homalg_variable_7665,11,3);;
gap> IsZero(homalg_variable_7709);
true
gap> homalg_variable_7710 := SI_\[(homalg_variable_7665,12,3);;
gap> IsZero(homalg_variable_7710);
false
gap> homalg_variable_7711 := SI_\[(homalg_variable_7665,11,4);;
gap> SI_deg( homalg_variable_7711 );
-1
gap> homalg_variable_7712 := SI_\[(homalg_variable_7665,8,4);;
gap> SI_deg( homalg_variable_7712 );
1
gap> homalg_variable_7713 := SI_\[(homalg_variable_7665,7,4);;
gap> SI_deg( homalg_variable_7713 );
1
gap> homalg_variable_7714 := SI_\[(homalg_variable_7665,6,4);;
gap> SI_deg( homalg_variable_7714 );
-1
gap> homalg_variable_7715 := SI_\[(homalg_variable_7665,4,4);;
gap> SI_deg( homalg_variable_7715 );
-1
gap> homalg_variable_7716 := SI_\[(homalg_variable_7665,3,4);;
gap> SI_deg( homalg_variable_7716 );
0
gap> homalg_variable_7717 := SI_\[(homalg_variable_7665,1,4);;
gap> IsZero(homalg_variable_7717);
true
gap> homalg_variable_7718 := SI_\[(homalg_variable_7665,2,4);;
gap> IsZero(homalg_variable_7718);
false
gap> homalg_variable_7719 := SI_\[(homalg_variable_7665,3,4);;
gap> IsZero(homalg_variable_7719);
false
gap> homalg_variable_7720 := SI_\[(homalg_variable_7665,4,4);;
gap> IsZero(homalg_variable_7720);
true
gap> homalg_variable_7721 := SI_\[(homalg_variable_7665,6,4);;
gap> IsZero(homalg_variable_7721);
true
gap> homalg_variable_7722 := SI_\[(homalg_variable_7665,7,4);;
gap> IsZero(homalg_variable_7722);
false
gap> homalg_variable_7723 := SI_\[(homalg_variable_7665,8,4);;
gap> IsZero(homalg_variable_7723);
false
gap> homalg_variable_7724 := SI_\[(homalg_variable_7665,11,4);;
gap> IsZero(homalg_variable_7724);
true
gap> homalg_variable_7725 := SI_\[(homalg_variable_7665,11,5);;
gap> SI_deg( homalg_variable_7725 );
-1
gap> homalg_variable_7726 := SI_\[(homalg_variable_7665,6,5);;
gap> SI_deg( homalg_variable_7726 );
1
gap> homalg_variable_7727 := SI_\[(homalg_variable_7665,4,5);;
gap> SI_deg( homalg_variable_7727 );
-1
gap> homalg_variable_7728 := SI_\[(homalg_variable_7665,1,5);;
gap> SI_deg( homalg_variable_7728 );
-1
gap> homalg_variable_7729 := SI_\[(homalg_variable_7665,11,6);;
gap> SI_deg( homalg_variable_7729 );
-1
gap> homalg_variable_7730 := SI_\[(homalg_variable_7665,6,6);;
gap> SI_deg( homalg_variable_7730 );
1
gap> homalg_variable_7731 := SI_\[(homalg_variable_7665,4,6);;
gap> SI_deg( homalg_variable_7731 );
-1
gap> homalg_variable_7732 := SI_\[(homalg_variable_7665,1,6);;
gap> SI_deg( homalg_variable_7732 );
1
gap> homalg_variable_7734 := SIH_Submatrix(homalg_variable_7663,[1..9],[ 1, 2, 4, 6, 7, 8, 9, 10, 11, 12 ]);;
gap> homalg_variable_7733 := SIH_SyzygiesGeneratorsOfColumns(homalg_variable_7734);;
gap> SI_ncols(homalg_variable_7733);
4
gap> homalg_variable_7735 := SI_matrix(homalg_variable_5,10,4,"0");;
gap> homalg_variable_7733 = homalg_variable_7735;
false
gap> homalg_variable_7736 := SI_\[(homalg_variable_7733,10,1);;
gap> SI_deg( homalg_variable_7736 );
-1
gap> homalg_variable_7737 := SI_\[(homalg_variable_7733,9,1);;
gap> SI_deg( homalg_variable_7737 );
-1
gap> homalg_variable_7738 := SI_\[(homalg_variable_7733,8,1);;
gap> SI_deg( homalg_variable_7738 );
-1
gap> homalg_variable_7739 := SI_\[(homalg_variable_7733,7,1);;
gap> SI_deg( homalg_variable_7739 );
-1
gap> homalg_variable_7740 := SI_\[(homalg_variable_7733,6,1);;
gap> SI_deg( homalg_variable_7740 );
-1
gap> homalg_variable_7741 := SI_\[(homalg_variable_7733,5,1);;
gap> SI_deg( homalg_variable_7741 );
-1
gap> homalg_variable_7742 := SI_\[(homalg_variable_7733,4,1);;
gap> SI_deg( homalg_variable_7742 );
-1
gap> homalg_variable_7743 := SI_\[(homalg_variable_7733,3,1);;
gap> SI_deg( homalg_variable_7743 );
1
gap> homalg_variable_7744 := SI_\[(homalg_variable_7733,2,1);;
gap> SI_deg( homalg_variable_7744 );
1
gap> homalg_variable_7745 := SI_\[(homalg_variable_7733,1,1);;
gap> SI_deg( homalg_variable_7745 );
-1
gap> homalg_variable_7746 := SI_\[(homalg_variable_7733,10,2);;
gap> SI_deg( homalg_variable_7746 );
-1
gap> homalg_variable_7747 := SI_\[(homalg_variable_7733,9,2);;
gap> SI_deg( homalg_variable_7747 );
-1
gap> homalg_variable_7748 := SI_\[(homalg_variable_7733,8,2);;
gap> SI_deg( homalg_variable_7748 );
-1
gap> homalg_variable_7749 := SI_\[(homalg_variable_7733,7,2);;
gap> SI_deg( homalg_variable_7749 );
-1
gap> homalg_variable_7750 := SI_\[(homalg_variable_7733,6,2);;
gap> SI_deg( homalg_variable_7750 );
-1
gap> homalg_variable_7751 := SI_\[(homalg_variable_7733,5,2);;
gap> SI_deg( homalg_variable_7751 );
-1
gap> homalg_variable_7752 := SI_\[(homalg_variable_7733,4,2);;
gap> SI_deg( homalg_variable_7752 );
1
gap> homalg_variable_7753 := SI_\[(homalg_variable_7733,3,2);;
gap> SI_deg( homalg_variable_7753 );
-1
gap> homalg_variable_7754 := SI_\[(homalg_variable_7733,2,2);;
gap> SI_deg( homalg_variable_7754 );
-1
gap> homalg_variable_7755 := SI_\[(homalg_variable_7733,1,2);;
gap> SI_deg( homalg_variable_7755 );
1
gap> homalg_variable_7756 := SI_\[(homalg_variable_7733,10,3);;
gap> SI_deg( homalg_variable_7756 );
3
gap> homalg_variable_7757 := SI_\[(homalg_variable_7733,9,3);;
gap> SI_deg( homalg_variable_7757 );
-1
gap> homalg_variable_7758 := SI_\[(homalg_variable_7733,8,3);;
gap> SI_deg( homalg_variable_7758 );
3
gap> homalg_variable_7759 := SI_\[(homalg_variable_7733,7,3);;
gap> SI_deg( homalg_variable_7759 );
3
gap> homalg_variable_7760 := SI_\[(homalg_variable_7733,6,3);;
gap> SI_deg( homalg_variable_7760 );
2
gap> homalg_variable_7761 := SI_\[(homalg_variable_7733,5,3);;
gap> SI_deg( homalg_variable_7761 );
2
gap> homalg_variable_7762 := SI_\[(homalg_variable_7733,4,3);;
gap> SI_deg( homalg_variable_7762 );
-1
gap> homalg_variable_7763 := SI_\[(homalg_variable_7733,3,3);;
gap> SI_deg( homalg_variable_7763 );
-1
gap> homalg_variable_7764 := SI_\[(homalg_variable_7733,2,3);;
gap> SI_deg( homalg_variable_7764 );
1
gap> homalg_variable_7765 := SI_\[(homalg_variable_7733,1,3);;
gap> SI_deg( homalg_variable_7765 );
1
gap> homalg_variable_7766 := SI_\[(homalg_variable_7733,10,4);;
gap> SI_deg( homalg_variable_7766 );
3
gap> homalg_variable_7767 := SI_\[(homalg_variable_7733,9,4);;
gap> SI_deg( homalg_variable_7767 );
-1
gap> homalg_variable_7768 := SI_\[(homalg_variable_7733,8,4);;
gap> SI_deg( homalg_variable_7768 );
3
gap> homalg_variable_7769 := SI_\[(homalg_variable_7733,7,4);;
gap> SI_deg( homalg_variable_7769 );
3
gap> homalg_variable_7770 := SI_\[(homalg_variable_7733,6,4);;
gap> SI_deg( homalg_variable_7770 );
2
gap> homalg_variable_7771 := SI_\[(homalg_variable_7733,5,4);;
gap> SI_deg( homalg_variable_7771 );
2
gap> homalg_variable_7772 := SI_\[(homalg_variable_7733,4,4);;
gap> SI_deg( homalg_variable_7772 );
1
gap> homalg_variable_7773 := SI_\[(homalg_variable_7733,3,4);;
gap> SI_deg( homalg_variable_7773 );
-1
gap> homalg_variable_7774 := SI_\[(homalg_variable_7733,2,4);;
gap> SI_deg( homalg_variable_7774 );
1
gap> homalg_variable_7775 := SI_\[(homalg_variable_7733,1,4);;
gap> SI_deg( homalg_variable_7775 );
-1
gap> homalg_variable_7776 := SI_matrix(homalg_variable_5,9,10,"0");;
gap> homalg_variable_7734 = homalg_variable_7776;
false
gap> homalg_variable_7777 := SIH_BasisOfColumnModule(homalg_variable_7663);;
gap> SI_ncols(homalg_variable_7777);
12
gap> homalg_variable_7778 := SI_matrix(homalg_variable_5,9,12,"0");;
gap> homalg_variable_7777 = homalg_variable_7778;
false
gap> homalg_variable_l := SIH_BasisOfColumnsCoeff(homalg_variable_7734);; homalg_variable_7779 := homalg_variable_l[1];; homalg_variable_7780 := homalg_variable_l[2];;
gap> SI_ncols(homalg_variable_7779);
12
gap> homalg_variable_7781 := SI_matrix(homalg_variable_5,9,12,"0");;
gap> homalg_variable_7779 = homalg_variable_7781;
false
gap> SI_nrows(homalg_variable_7780);
10
gap> homalg_variable_7782 := homalg_variable_7734 * homalg_variable_7780;;
gap> homalg_variable_7779 = homalg_variable_7782;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_7777,homalg_variable_7779);; homalg_variable_7783 := homalg_variable_l[1];; homalg_variable_7784 := homalg_variable_l[2];;
gap> homalg_variable_7785 := SI_matrix(homalg_variable_5,9,12,"0");;
gap> homalg_variable_7783 = homalg_variable_7785;
true
gap> homalg_variable_7786 := homalg_variable_7779 * homalg_variable_7784;;
gap> homalg_variable_7787 := homalg_variable_7777 + homalg_variable_7786;;
gap> homalg_variable_7783 = homalg_variable_7787;
true
gap> homalg_variable_7788 := SIH_DecideZeroColumns(homalg_variable_7777,homalg_variable_7779);;
gap> homalg_variable_7789 := SI_matrix(homalg_variable_5,9,12,"0");;
gap> homalg_variable_7788 = homalg_variable_7789;
true
gap> homalg_variable_7790 := homalg_variable_7784 * (homalg_variable_8);;
gap> homalg_variable_7791 := homalg_variable_7780 * homalg_variable_7790;;
gap> homalg_variable_7792 := homalg_variable_7734 * homalg_variable_7791;;
gap> homalg_variable_7792 = homalg_variable_7777;
true
gap> homalg_variable_l := SIH_DecideZeroColumnsEffectively(homalg_variable_7734,homalg_variable_7777);; homalg_variable_7793 := homalg_variable_l[1];; homalg_variable_7794 := homalg_variable_l[2];;
gap> homalg_variable_7795 := SI_matrix(homalg_variable_5,9,10,"0");;
gap> homalg_variable_7793 = homalg_variable_7795;
true
gap> homalg_variable_7796 := homalg_variable_7777 * homalg_variable_7794;;
gap> homalg_variable_7797 := homalg_variable_7734 + homalg_variable_7796;;
gap> homalg_variable_7793 = homalg_variable_7797;
true
gap> homalg_variable_7798 := SIH_DecideZeroColumns(homalg_variable_7734,homalg_variable_7777);;
gap> homalg_variable_7799 := SI_matrix(homalg_variable_5,9,10,"0");;
gap> homalg_variable_7798 = homalg_variable_7799;
true
gap> homalg_variable_7800 := homalg_variable_7794 * (homalg_variable_8);;
gap> homalg_variable_7801 := homalg_variable_7777 * homalg_variable_7800;;
gap> homalg_variable_7801 = homalg_variable_7734;
true
gap> homalg_variable_7803 := SIH_UnionOfRows(homalg_variable_6027,homalg_variable_7609);;
gap> homalg_variable_7804 := SI_matrix(homalg_variable_5,4,9,"0");;
gap> homalg_variable_7805 := SIH_UnionOfRows(homalg_variable_7804,homalg_variable_7525);;
gap> homalg_variable_7806 := SIH_UnionOfColumns(homalg_variable_7803,homalg_variable_7805);;
gap> homalg_variable_7802 := SIH_BasisOfColumnModule(homalg_variable_7806);;
gap> SI_ncols(homalg_variable_7802);
12
gap> homalg_variable_7807 := SI_matrix(homalg_variable_5,9,12,"0");;
gap> homalg_variable_7802 = homalg_variable_7807;
false
gap> homalg_variable_7802 = homalg_variable_7806;
false
gap> homalg_variable_7808 := SIH_DecideZeroColumns(homalg_variable_7734,homalg_variable_7802);;
gap> homalg_variable_7809 := SI_matrix(homalg_variable_5,9,10,"0");;
gap> homalg_variable_7808 = homalg_variable_7809;
true
gap> Display( SI_transpose( homalg_variable_7806 ) );
0,  0,x, -y,0,1, 0,    0,  0, 
x*y,0,-z,0, 0,0, 0,    0,  0, 
x^2,0,0, -z,1,0, 0,    0,  0, 
0,  0,0, 0, y,-z,0,    0,  0, 
0,  0,0, 0, 0,x, -y,   -1, 0, 
0,  0,0, 0, x,0, -z,   0,  -1,
0,  0,0, 0, 0,-y,x^2-1,0,  0, 
0,  0,0, 0, 0,0, 0,    z,  0, 
0,  0,0, 0, 0,0, 0,    y-1,0, 
0,  0,0, 0, 0,0, 0,    0,  z, 
0,  0,0, 0, 0,0, 0,    0,  y, 
0,  0,0, 0, 0,0, 0,    0,  x  
