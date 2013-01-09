#ifndef LIBSING_H
#define LIBSING_H

// Include gmp.h *before* switching to C mode, because GMP detects when compiled from C++
// and then does some things differently, which would cause an error if
// called from within extern "C". But libsing.h (indirectly) includes gmp.h ...
#include <gmp.h>

extern "C" {
  #include <src/compiled.h>
}


#undef PACKAGE
#undef PACKAGE_BUGREPORT
#undef PACKAGE_NAME
#undef PACKAGE_STRING
#undef PACKAGE_TARNAME
#undef PACKAGE_URL
#undef PACKAGE_VERSION

#include "pkgconfig.h"             /* our own configure results */

/* Note that SIZEOF_VOID_P comes from GAP's config.h whereas
 * SIZEOF_VOID_PP comes from pkgconfig.h! */
#if SIZEOF_VOID_PP != SIZEOF_VOID_P
#error GAPs word size is different from ours, 64bit/32bit mismatch
#endif

//////////////////////////////////////////////////////////////////////////////
/**
@file libsing.h
This C header file file contains all of declarations for C++ functions that 
are to be called from C, or vice-versa.
**/
//////////////////////////////////////////////////////////////////////////////

extern Obj _SI_Types;    /* A kernel copy of a plain list of types */
extern Obj SI_Errors;   /* A kernel copy of a string */
extern Obj SingularProxiesType;   /* A kernel copy of the type of proxy els */

//////////////// Layout of the T_SINGULAR objects /////////////////////
// There are 3 possibilites: 
// (1) objects without a ring (2) objects with a ring (3) ring objects.
// Objects in case (1) consists of 2 words: 
// First is the GAP type as a small integer pointing into a plain list
// Second is a pointer to a C++ singular object.
// These are the same for all objects.
// For type (2) there are 4 words, the first 2 are as above:
// Third is a reference to the GAP wrapper object of the corresponding
// ring, this is to keep the ring alive as long as its elements are.
// Fourth is a pointer to the C++ ring object.
// For type (3) there are 4 words, the first 2 are as above:
// Third is a reference to the canonical GAP wrapper of the ring's zero.
// Fourth is a reference to the canonical GAP wrapper of the ring's one.

inline Int TYPE_SINGOBJ( Obj obj ) { return (Int) ADDR_OBJ(obj)[0]; }
inline void SET_TYPE_SINGOBJ( Obj obj, Int val )
{ ADDR_OBJ(obj)[0] = (Obj) val; }

inline void *CXX_SINGOBJ( Obj obj ) { return (void *) ADDR_OBJ(obj)[1]; }
inline void SET_CXX_SINGOBJ( Obj obj, void *val )
{ ADDR_OBJ(obj)[1] = (Obj) val; }

inline Obj RING_SINGOBJ( Obj obj ) { return ADDR_OBJ(obj)[2]; }
inline void SET_RING_SINGOBJ( Obj obj, Obj rr )
{ ADDR_OBJ(obj)[2] = rr; }

inline void *CXXRING_SINGOBJ( Obj obj ) { return (void *) ADDR_OBJ(obj)[3]; }
inline void SET_CXXRING_SINGOBJ( Obj obj, void *r )
{ ADDR_OBJ(obj)[3] = (Obj) r; }

inline Obj ZERO_SINGOBJ( Obj obj ) { return ADDR_OBJ(obj)[2]; }
inline void SET_ZERO_SINGOBJ( Obj obj, Obj zero )
{ ADDR_OBJ(obj)[2] = zero; }

inline Obj ONE_SINGOBJ( Obj obj ) { return ADDR_OBJ(obj)[3]; }
inline void SET_ONE_SINGOBJ( Obj obj, Obj one )
{ ADDR_OBJ(obj)[3] = one; }

Obj NEW_SINGOBJ(UInt type, void *cxx);
Obj NEW_SINGOBJ_RING(UInt type, void *cxx, Obj ring);
Obj NEW_SINGOBJ_RING(UInt type, void *cxx, Obj zero, Obj one);

enum {
    SINGTYPE_VOID          = 1,
    SINGTYPE_BIGINT        = 2,
    SINGTYPE_BIGINT_IMM    = 3,
    SINGTYPE_DEF           = 4,
    SINGTYPE_DEF_IMM       = 5,
    SINGTYPE_IDEAL         = 6,
    SINGTYPE_IDEAL_IMM     = 7,
    SINGTYPE_INT           = 8,
    SINGTYPE_INT_IMM       = 9,
    SINGTYPE_INTMAT        = 10,
    SINGTYPE_INTMAT_IMM    = 11,
    SINGTYPE_INTVEC        = 12,
    SINGTYPE_INTVEC_IMM    = 13,
    SINGTYPE_LINK          = 14,
    SINGTYPE_LINK_IMM      = 15,
    SINGTYPE_LIST          = 16,
    SINGTYPE_LIST_IMM      = 17,
    SINGTYPE_MAP           = 18,
    SINGTYPE_MAP_IMM       = 19,
    SINGTYPE_MATRIX        = 20,
    SINGTYPE_MATRIX_IMM    = 21,
    SINGTYPE_MODULE        = 22,
    SINGTYPE_MODULE_IMM    = 23,
    SINGTYPE_NUMBER        = 24,
    SINGTYPE_NUMBER_IMM    = 25,
    SINGTYPE_PACKAGE       = 26,
    SINGTYPE_PACKAGE_IMM   = 27,
    SINGTYPE_POLY          = 28,
    SINGTYPE_POLY_IMM      = 29,
    SINGTYPE_PROC          = 30,
    SINGTYPE_PROC_IMM      = 31,
    SINGTYPE_QRING         = 32,
    SINGTYPE_QRING_IMM     = 33,
    SINGTYPE_RESOLUTION    = 34,
    SINGTYPE_RESOLUTION_IMM= 35,
    SINGTYPE_RING          = 36,
    SINGTYPE_RING_IMM      = 37,
    SINGTYPE_STRING        = 38,
    SINGTYPE_STRING_IMM    = 39,
    SINGTYPE_VECTOR        = 40,
    SINGTYPE_VECTOR_IMM    = 41,
    SINGTYPE_USERDEF       = 42,
    SINGTYPE_USERDEF_IMM   = 43,
    SINGTYPE_PYOBJECT      = 44,
    SINGTYPE_PYOBJECT_IMM  = 45,

    SINGTYPE_LASTNUMBER    = 45
};

/* If you change these numbers, then also adjust the tables GAPtoSingType
 * and HasRingTable in cxxfuncs.cc! */

#if 0
proxies fuer:
  ideal   ->  poly
  list    ->  ?
  matrix  ->  poly
  module  ->  vector
  qring   ->  ideal
#endif

inline int ISSINGOBJ(int typ, Obj obj)
{
    return TNUM_OBJ(obj) == T_SINGULAR && TYPE_SINGOBJ(obj) == typ;
}

//////////////// C++ functions to be called from C ////////////////////


void _SI_ObjMarkFunc(Bag o);
void _SI_FreeFunc(Obj o);
Obj _SI_TypeObj(Obj o);
Obj Func_SI_ring(Obj self, Obj charact, Obj names, Obj orderings);
Obj FuncSI_ring_of_singobj( Obj self, Obj singobj );
Obj FuncSI_Indeterminates(Obj self, Obj r);
Obj Func_SI_poly_from_String(Obj self, Obj rr, Obj st);
Obj Func_SI_matrix_from_String(Obj self, Obj nrrows, Obj nrcols,Obj rr, Obj st);
Obj Func_SI_MONOMIAL(Obj self, Obj rr, Obj coeff, Obj exps);
Obj Func_SI_COPY_POLY(Obj self, Obj po);
Obj Func_SI_MULT_POLY_NUMBER(Obj self, Obj a, Obj b);
Obj Func_SI_INIT_INTERPRETER(Obj self, Obj path);
Obj Func_SI_EVALUATE(Obj self, Obj st);
Obj FuncSI_ValueOfVar(Obj self, Obj name);
Obj Func_SI_SingularProcs(Obj self);
Obj FuncSI_ToGAP(Obj self, Obj singobj);
Obj FuncSI_LastOutput(Obj self);
Obj Func_SI_bigint(Obj self, Obj nr);
Obj Func_SI_Intbigint(Obj self, Obj b);
Obj Func_SI_number(Obj self, Obj r, Obj nr);
Obj Func_SI_intvec(Obj self, Obj l);
Obj Func_SI_Plistintvec(Obj self, Obj iv);
Obj Func_SI_intmat(Obj self, Obj m);
Obj Func_SI_Matintmat(Obj self, Obj im);
Obj Func_SI_ideal_from_els(Obj self, Obj l);
Obj Func_SI_matrix_from_els(Obj self, Obj nrrows, Obj nrcols, Obj l);

Obj Func_SI_CallFunc1(Obj self, Obj op, Obj input);
Obj Func_SI_CallFunc2(Obj self, Obj op, Obj a, Obj b);
Obj Func_SI_CallFunc3(Obj self, Obj op, Obj a, Obj b, Obj c);
Obj Func_SI_CallFuncM(Obj self, Obj op, Obj arg);

Obj FuncSI_SetCurrRing(Obj self, Obj r);

Obj FuncSI_CallProc(Obj self, Obj name, Obj args);

Obj FuncOmPrintInfo(Obj self);
Obj FuncOmCurrentBytes(Obj self);

#endif //#define LIBSING_H

