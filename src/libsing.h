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

//////////////// Layout of the T_SINGULAR objects /////////////////////
// 3 words: 
// First is the GAP type
// Second is a pointer to a C++ singular object
// Third is a pointer to a GAP object representing the ring (only if needed)

#define RING_SINGOBJ( obj ) ADDR_OBJ(obj)[0]
#define SET_RING_SINGOBJ( obj,val ) (ADDR_OBJ(obj)[0] = (val))
#define TYPE_SINGOBJ( obj ) ((UInt) ADDR_OBJ(obj)[1])
#define SET_TYPE_SINGOBJ( obj,val ) (ADDR_OBJ(obj)[1] = ((Bag) val))
#define CXX_SINGOBJ( obj ) ((void *) ADDR_OBJ(obj)[2])
#define SET_CXX_SINGOBJ( obj,val ) (ADDR_OBJ(obj)[2] = ((Obj) val))

static inline Obj NEW_SINGOBJ(void *cxx)
{
    Obj tmp = NewBag(T_SINGULAR, 3*sizeof(Obj));
    SET_CXX_SINGOBJ(tmp,cxx);
    return tmp;
}

static inline Obj NEW_SINGOBJ_TYPE(Obj ring, UInt type, void *cxx)
{
    Obj tmp = NewBag(T_SINGULAR, 3*sizeof(Obj));
    SET_RING_SINGOBJ(tmp,ring);
    SET_TYPE_SINGOBJ(tmp,type);
    SET_CXX_SINGOBJ(tmp,cxx);
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

Obj SingularTypes;   /* A kernel copy of a plain list of types */

//////////////// C++ functions to be called from C ////////////////////


Obj FuncCONCATENATE(Obj self, Obj a, Obj b);
Obj FuncSingularTest(Obj self);
void SingularFreeFunc(Obj o);
Obj TypeSingularObj(Obj o);
Obj FuncSingularRingWithoutOrdering(Obj self, Obj charact, Obj numberinvs,
                                    Obj names);
Obj FuncIndeterminatesOfSingularRing(Obj self, Obj r);
Obj FuncINIT_SINGULAR_INTERPRETER(Obj self, Obj path);
Obj FuncEVALUATE_IN_SINGULAR(Obj self, Obj st);
Obj FuncValueOfSingularVar(Obj self, Obj name);

//////////////// C functions to be called from C++ ////////////////////

void PrintGAPError(const char* message);


#endif //#define LIBSING_H
