#ifndef LIBSING_H
#define LIBSING_H

#include <src/compiled.h>

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
extern Obj _SI_Rings;    /* A kernel copy of a plain list of rings */
extern Obj _SI_ElCounts; /* A kernel copy of a plain list of ref counts */
extern Obj SI_Errors;   /* A kernel copy of a string */
extern Obj SingularProxiesType;   /* A kernel copy of the type of proxy els */

//////////////// Layout of the T_SINGULAR objects /////////////////////
// 3 words: 
// First is the GAP type as a small integer pointing into a plain list
// Second is a pointer to a C++ singular object
// The third is an index into the list of all singular rings and the
// corresponding reference counting list.

inline Int TYPE_SINGOBJ( Obj obj ) { return (Int) ADDR_OBJ(obj)[0]; }
inline void SET_TYPE_SINGOBJ( Obj obj, Int val )
{ ADDR_OBJ(obj)[0] = (Obj) val; }
inline void *CXX_SINGOBJ( Obj obj ) { return (void *) ADDR_OBJ(obj)[1]; }
inline void SET_CXX_SINGOBJ( Obj obj, void *val )
{ ADDR_OBJ(obj)[1] = (Obj) val; }
inline UInt RING_SINGOBJ( Obj obj ) { return (UInt) ADDR_OBJ(obj)[2]; }
inline void SET_RING_SINGOBJ( Obj obj, UInt val )
{ ADDR_OBJ(obj)[2] = (Obj) val; }

inline void INC_REFCOUNT( UInt ring )
{
    Int count = INT_INTOBJ(ELM_PLIST(_SI_ElCounts,ring));
    count++;
    SET_ELM_PLIST(_SI_ElCounts,ring,INTOBJ_INT(count));
}

inline void DEC_REFCOUNT( UInt ring )
{
    Int count = INT_INTOBJ(ELM_PLIST(_SI_ElCounts,ring));
    count--;
    SET_ELM_PLIST(_SI_ElCounts,ring,INTOBJ_INT(count));
}

static inline Obj NEW_SINGOBJ(UInt type, void *cxx)
{
    Obj tmp = NewBag(T_SINGULAR, 2*sizeof(Obj));
    SET_TYPE_SINGOBJ(tmp,type);
    SET_CXX_SINGOBJ(tmp,cxx);
    return tmp;
}

static inline Obj NEW_SINGOBJ_RING(UInt type, void *cxx, UInt ring)
{
    Obj tmp = NewBag(T_SINGULAR, 3*sizeof(Obj));
    SET_TYPE_SINGOBJ(tmp,type);
    SET_CXX_SINGOBJ(tmp,cxx);
    SET_RING_SINGOBJ(tmp,ring);
    INC_REFCOUNT(ring);
    return tmp;
}

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
Obj FuncSI_Indeterminates(Obj self, Obj r);
Obj Func_SI_poly_from_String(Obj self, Obj rr, Obj st);
Obj Func_SI_matrix_from_String(Obj self, Obj nrrows, Obj nrcols,Obj rr, Obj st);
Obj Func_SI_MONOMIAL(Obj self, Obj rr, Obj coeff, Obj exps);
Obj Func_SI_COPY_POLY(Obj self, Obj po);
Obj Func_SI_MULT_POLY_NUMBER(Obj self, Obj a, Obj b);
Obj Func_SI_INIT_INTERPRETER(Obj self, Obj path);
Obj Func_SI_EVALUATE(Obj self, Obj st);
Obj FuncSI_ValueOfVar(Obj self, Obj name);
Obj FuncSI_ToGAP(Obj self, Obj singobj);
Obj FuncSI_LastOutput(Obj self);
Obj Func_SI_bigint(Obj self, Obj nr);
Obj Func_SI_Intbigint(Obj self, Obj b);
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

//////////////// C functions to be called from C++ ////////////////////

void _SI_PrintGAPError(const char* message);

#endif //#define LIBSING_H

