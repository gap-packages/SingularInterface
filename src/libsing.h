//////////////////////////////////////////////////////////////////////////////
/**
@file libsing.h
This C header file file contains all of declarations for C++ functions that
are to be called from C, or vice-versa.
**/
//////////////////////////////////////////////////////////////////////////////

#ifndef LIBSING_H
#define LIBSING_H

// Include gmp.h *before* switching to C mode, because GMP detects when compiled from C++
// and then does some things differently, which would cause an error if
// called from within extern "C". But libsing.h (indirectly) includes gmp.h ...
#include <gmp.h>

extern "C" {
  #include <src/compiled.h>
}

#include "Singular/libsingular.h"
#include "singtypes.h"

#undef PACKAGE
#undef PACKAGE_BUGREPORT
#undef PACKAGE_NAME
#undef PACKAGE_STRING
#undef PACKAGE_TARNAME
#undef PACKAGE_URL
#undef PACKAGE_VERSION
#undef VERSION

#include "pkgconfig.h"             /* our own configure results */

/* Note that SIZEOF_VOID_P comes from GAP's config.h whereas
 * SIZEOF_VOID_PP comes from pkgconfig.h! */
#if SIZEOF_VOID_PP != SIZEOF_VOID_P
#error GAPs word size is different from ours, 64bit/32bit mismatch
#endif

extern Obj SI_Errors;   //!< A kernel copy of a string
extern Obj _SI_ProxiesType;   //!< A kernel copy of the type of proxy elements

void InstallPrePostGCFuncs(void);

//////////////// Layout of the T_SINGULAR objects /////////////////////
// There are 3 possibilites:
// (1) objects without a ring (2) objects with a ring (3) ring objects.
// Objects in case (1) consists of 2 words:
// First is the GAP type as a small integer pointing into a plain list
// together with some bits for the special attributes.
// Second is a pointer to a C++ singular object.
// These are the same for all objects.
// For type (2) there are 4 words, the first 2 are as above:
// Third is a reference to the GAP wrapper object of the corresponding
// ring, this is to keep the ring alive as long as its elements are.
// Fourth is a pointer to the C++ ring object.
// For type (3) there are 4 words, the first 2 are as above:
// Third is a reference to the canonical GAP wrapper of the ring's zero.
// Fourth is a reference to the canonical GAP wrapper of the ring's one.
//
// Additionally, all object wrappers can have an additional word
// for the extended attributes.

#ifdef SYS_IS_64_BIT

struct SingObj_FirstWord {
    unsigned int flags;
    int type;
};

#else

struct SingObj_FirstWord {
    unsigned short int flags;
    short int type;
};

#endif


inline SingType TYPE_SINGOBJ( Obj obj )
{
    SingObj_FirstWord *p = (SingObj_FirstWord *)(ADDR_OBJ(obj));
    return (SingType)(p->type);
}

inline void SET_TYPE_SINGOBJ( Obj obj, Int val )
{
    SingObj_FirstWord *p = (SingObj_FirstWord *)(ADDR_OBJ(obj));
    p->type = val;
}

inline unsigned int FLAGS_SINGOBJ( Obj obj )
{
    SingObj_FirstWord *p = (SingObj_FirstWord *)(ADDR_OBJ(obj));
    return p->flags;
}

inline void SET_FLAGS_SINGOBJ( Obj obj, unsigned int val )
{
    SingObj_FirstWord *p = (SingObj_FirstWord *)(ADDR_OBJ(obj));
    p->flags = val;
}


///! Get pointer to the underlying Singular C data structure
///! of an arbitrary wrapper object.
inline void *CXX_SINGOBJ( Obj obj )
{
    return (void *) ADDR_OBJ(obj)[1];
}

///! Set pointer to the underlying Singular C data structure
///! of an arbitrary wrapper object.
inline void SET_CXX_SINGOBJ( Obj obj, void *val )
{
    ADDR_OBJ(obj)[1] = (Obj) val;
}

//
// The following accessor functions are for wrappers for ring dependant
// objects. These contain a reference to the wrapper object for their
// basering, as well as a direct pointer to the base ring (the latter
// allows us to avoid another level of indirection).
//

inline Obj RING_SINGOBJ( Obj obj )
{
    return ADDR_OBJ(obj)[2];
}

inline void SET_RING_SINGOBJ( Obj obj, Obj rr )
{
    ADDR_OBJ(obj)[2] = rr;
}

inline ring CXXRING_SINGOBJ( Obj obj )
{
    return (ring) ADDR_OBJ(obj)[3];
}

inline void SET_CXXRING_SINGOBJ( Obj obj, ring r )
{
    ADDR_OBJ(obj)[3] = (Obj) r;
}

//
// Ring wrappers also contain references to a zero object, a one object,
// and a high level wrapper object
//

inline Obj ZERO_SINGOBJ( Obj obj )
{
    return ADDR_OBJ(obj)[2];
}

inline void SET_ZERO_SINGOBJ( Obj obj, Obj zero )
{
    ADDR_OBJ(obj)[2] = zero;
}

inline Obj ONE_SINGOBJ( Obj obj )
{
    return ADDR_OBJ(obj)[3];
}

inline void SET_ONE_SINGOBJ( Obj obj, Obj one )
{
    ADDR_OBJ(obj)[3] = one;
}

inline Obj HIWRAP_SINGOBJ( Obj obj )
{
    return ADDR_OBJ(obj)[4];
}

inline void SET_HIWRAP_SINGOBJ( Obj obj, Obj hi )
{
    ADDR_OBJ(obj)[4] = hi;
}


///! Get Singular attributes from a Singular wrapper object, if any.
inline void *ATTRIB_SINGOBJ( Obj obj )
{
    Int t = TYPE_SINGOBJ(obj);
    Int basesize = 2;
    if (t == SINGTYPE_RING_IMM || t == SINGTYPE_QRING_IMM)
        basesize = 5;
    else if (HasRingTable[t])
        basesize = 4;

    if (SIZE_BAG(obj) <= basesize * sizeof(Obj))
        return NULL;
    return (void *)(ADDR_OBJ(obj)[basesize]);
}

///! Store Singular attributes inside a Singular wrapper object.
inline void SET_ATTRIB_SINGOBJ( Obj obj, void *a )
{
    Int t = TYPE_SINGOBJ(obj);
    Int basesize = 2;
    if (t == SINGTYPE_RING_IMM || t == SINGTYPE_QRING_IMM)
        basesize = 5;
    else if (HasRingTable[t])
        basesize = 4;

    if (SIZE_BAG(obj) <= basesize * sizeof(Obj))
        ResizeBag(obj, (basesize + 1) * sizeof(Obj));
    ADDR_OBJ(obj)[basesize] = (Obj)a;
}


Obj NEW_SINGOBJ(UInt type, void *cxx);
Obj NEW_SINGOBJ_RING(UInt type, void *cxx, Obj rr);
Obj NEW_SINGOBJ_ZERO_ONE(UInt type, ring r, Obj zero, Obj one);

Obj gapwrap(sleftv &obj, Obj rr);

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

bool IsCopyableSingularType(Int gtype);

extern UInt _SI_internalRingRNam;

Obj UnwrapHighlevelWrapper(Obj obj);


//////////////// C++ functions to be called from C ////////////////////


void _SI_ObjMarkFunc(Bag o);
void _SI_FreeFunc(Obj o);
Obj _SI_TypeObj(Obj o);
Obj Func_SI_ring(Obj self, Obj charact, Obj names, Obj orderings);
Obj FuncSI_RingOfSingobj( Obj self, Obj singobj );
Obj FuncSI_Indeterminates(Obj self, Obj r);
Obj Func_SI_ideal_from_String(Obj self, Obj rr, Obj st);
Obj Func_SI_MONOMIAL(Obj self, Obj rr, Obj coeff, Obj exps);
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
Obj Func_SI_ideal_from_els(Obj self, Obj l);

Obj Func_SI_CallFunc1(Obj self, Obj op, Obj a);
Obj Func_SI_CallFunc2(Obj self, Obj op, Obj a, Obj b);
Obj Func_SI_CallFunc3(Obj self, Obj op, Obj a, Obj b, Obj c);
Obj Func_SI_CallFuncM(Obj self, Obj op, Obj arg);

Obj FuncSI_SetCurrRing(Obj self, Obj r);

Obj FuncSI_CallProc(Obj self, Obj name, Obj args);

Obj Func_SI_OmPrintInfo(Obj self);
Obj Func_SI_OmCurrentBytes(Obj self);

//////////////// C++ functions for the jump tables ////////////////////

Int IsCopyableObjSingular(Obj s);
Obj ShallowCopyObjSingular(Obj s);
Obj CopyObjSingular(Obj s, Int mut);
void CleanObjConstant(Obj s);

Int IsMutableSingObj(Obj s);
void MakeImmutableSingObj(Obj s);
Obj ZeroSMSingObj(Obj s);
Obj OneSMSingObj(Obj s);


#endif //#define LIBSING_H

