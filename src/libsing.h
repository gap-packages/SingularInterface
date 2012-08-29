#ifndef LIBSING_H
#define LIBSING_H

#if 1
// HACK: Workaround #1 for version of GAP before 2011-11-16:
// ensure USE_GMP is defined
#define USE_GMP 1
#endif

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

extern Obj SingularTypes;    /* A kernel copy of a plain list of types */
extern Obj SingularRings;    /* A kernel copy of a plain list of rings */
extern Obj SingularElCounts; /* A kernel copy of a plain list of ref counts */
extern Obj SingularErrors;   /* A kernel copy of a string */
extern Obj SingularProxiesType;   /* A kernel copy of the type of proxy els */

//////////////// Layout of the T_SINGULAR objects /////////////////////
// 3 words: 
// First is the GAP type as a small integer pointing into a plain list
// Second is a pointer to a C++ singular object
// The third is an index into the list of all singular rings and the
// corresponding reference counting list.

inline UInt TYPE_SINGOBJ( Obj obj ) { return (UInt) ADDR_OBJ(obj)[0]; }
inline void SET_TYPE_SINGOBJ( Obj obj, UInt val )
{ ADDR_OBJ(obj)[0] = (Obj) val; }
inline void *CXX_SINGOBJ( Obj obj ) { return (void *) ADDR_OBJ(obj)[1]; }
inline void SET_CXX_SINGOBJ( Obj obj, void *val )
{ ADDR_OBJ(obj)[1] = (Obj) val; }
inline UInt RING_SINGOBJ( Obj obj ) { return (UInt) ADDR_OBJ(obj)[2]; }
inline void SET_RING_SINGOBJ( Obj obj, UInt val )
{ ADDR_OBJ(obj)[2] = (Obj) val; }

inline void INC_REFCOUNT( UInt ring )
{
    Int count = INT_INTOBJ(ELM_PLIST(SingularElCounts,ring));
    count++;
    SET_ELM_PLIST(SingularElCounts,ring,INTOBJ_INT(count));
}

inline void DEC_REFCOUNT( UInt ring )
{
    Int count = INT_INTOBJ(ELM_PLIST(SingularElCounts,ring));
    count--;
    SET_ELM_PLIST(SingularElCounts,ring,INTOBJ_INT(count));
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
    SINGTYPE_BIGINT        =  1,
    SINGTYPE_DEF           =  2,
    SINGTYPE_IDEAL         =  3,
    SINGTYPE_INT           =  4,
    SINGTYPE_INTMAT        =  5,
    SINGTYPE_INTVEC        =  6,
    SINGTYPE_LINK          =  7,
    SINGTYPE_LIST          =  8,
    SINGTYPE_MAP           =  9,
    SINGTYPE_MATRIX        = 10,
    SINGTYPE_MODULE        = 11,
    SINGTYPE_NUMBER        = 12,
    SINGTYPE_PACKAGE       = 13,
    SINGTYPE_POLY          = 14,
    SINGTYPE_PROC          = 15,
    SINGTYPE_QRING         = 16,
    SINGTYPE_RESOLUTION    = 17,
    SINGTYPE_RING          = 18,
    SINGTYPE_STRING        = 19,
    SINGTYPE_VECTOR        = 20,
    SINGTYPE_USERDEF       = 21,
    SINGTYPE_PYOBJECT      = 22,

    SINGTYPE_LASTNUMBER    = 22
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


void SingularObjMarkFunc(Bag o);
void SingularFreeFunc(Obj o);
Obj TypeSingularObj(Obj o);
Obj FuncSingularRingWithoutOrdering(Obj self, Obj charact, Obj names);
Obj FuncSingularRing(Obj self, Obj charact, Obj names, Obj orderings);
Obj FuncIndeterminatesOfSingularRing(Obj self, Obj r);
Obj FuncSI_Makepoly_from_String(Obj self, Obj rr, Obj st);
Obj FuncSI_Makematrix_from_String(Obj self, Obj nrrows, Obj nrcols, 
                                  Obj rr, Obj st);
Obj FuncSI_MONOMIAL(Obj self, Obj rr, Obj coeff, Obj exps);
Obj FuncSI_STRING_POLY(Obj self, Obj po);
Obj FuncSI_COPY_POLY(Obj self, Obj po);
Obj FuncSI_ADD_POLYS(Obj self, Obj a, Obj b);
Obj FuncSI_NEG_POLY(Obj self, Obj a);
Obj FuncSI_MULT_POLYS(Obj self, Obj a, Obj b);
Obj FuncSI_MULT_POLY_NUMBER(Obj self, Obj a, Obj b);
Obj FuncSI_INIT_INTERPRETER(Obj self, Obj path);
Obj FuncSI_EVALUATE(Obj self, Obj st);
Obj FuncValueOfSingularVar(Obj self, Obj name);
Obj FuncGAPSingular(Obj self, Obj singobj);
Obj FuncLastSingularOutput(Obj self);
Obj FuncSI_Makebigint(Obj self, Obj nr);
Obj FuncSI_Intbigint(Obj self, Obj b);
Obj FuncSI_Makeintvec(Obj self, Obj l);
Obj FuncSI_Plistintvec(Obj self, Obj iv);
Obj FuncSI_Makeintmat(Obj self, Obj m);
Obj FuncSI_Matintmat(Obj self, Obj im);
Obj FuncSI_Makeideal(Obj self, Obj l);
Obj FuncSI_Makematrix(Obj self, Obj nrrows, Obj nrcols, Obj l);

Obj FuncSI_CallFunc1(Obj self, Obj op, Obj input);
Obj FuncSI_CallFunc2(Obj self, Obj op, Obj a, Obj b);
Obj FuncSI_CallFunc3(Obj self, Obj op, Obj a, Obj b, Obj c);
Obj FuncSI_CallFuncM(Obj self, Obj op, Obj arg);

Obj FuncSI_SetCurrRing(Obj self, Obj r);

//////////////// C functions to be called from C++ ////////////////////

void PrintGAPError(const char* message);

#endif //#define LIBSING_H

