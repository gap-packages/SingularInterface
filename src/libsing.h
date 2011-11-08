#ifndef LIBSING_H
#define LIBSING_H

#include <src/compiled.h>

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

#define SINGTYPE_BIGINT         1
#define SINGTYPE_DEF            2 
#define SINGTYPE_IDEAL          3 
#define SINGTYPE_INT            4 
#define SINGTYPE_INTMAT         5 
#define SINGTYPE_INTVEC         6 
#define SINGTYPE_LINK           7 
#define SINGTYPE_LIST           8 
#define SINGTYPE_MAP            9 
#define SINGTYPE_MATRIX        10 
#define SINGTYPE_MODULE        11 
#define SINGTYPE_NUMBER        12 
#define SINGTYPE_PACKAGE       13 
#define SINGTYPE_POLY          14 
#define SINGTYPE_PROC          15 
#define SINGTYPE_QRING         16 
#define SINGTYPE_RESOLUTION    17 
#define SINGTYPE_RING          18 
#define SINGTYPE_STRING        19 
#define SINGTYPE_VECTOR        20 
#define SINGTYPE_USERDEF       21 
#define SINGTYPE_PYOBJECT      22 
#define SINGTYPE_LASTNUMBER    22

//////////////// C++ functions to be called from C ////////////////////


void SingularObjMarkFunc(Bag o);
void SingularFreeFunc(Obj o);
Obj TypeSingularObj(Obj o);
Obj FuncSingularRingWithoutOrdering(Obj self, Obj charact, Obj names);
Obj FuncIndeterminatesOfSingularRing(Obj self, Obj r);
Obj FuncSINGULAR_MONOMIAL(Obj self, Obj rr, Obj coeff, Obj exps);
Obj FuncSTRING_POLY(Obj self, Obj po);
Obj FuncADD_POLYS(Obj self, Obj a, Obj b);
Obj FuncINIT_SINGULAR_INTERPRETER(Obj self, Obj path);
Obj FuncEVALUATE_IN_SINGULAR(Obj self, Obj st);
Obj FuncValueOfSingularVar(Obj self, Obj name);
Obj FuncLastSingularOutput(Obj self);


//////////////// C functions to be called from C++ ////////////////////

void PrintGAPError(const char* message);


//////////////// old stuff which will eventually go ///////////////////

Obj FuncCONCATENATE(Obj self, Obj a, Obj b);
Obj FuncSingularTest(Obj self);

#endif //#define LIBSING_H

