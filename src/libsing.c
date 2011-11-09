//////////////////////////////////////////////////////////////////////////////
/**
@file libsing.c
This file contains all of the pure C code that deals with GAP.
**/
//////////////////////////////////////////////////////////////////////////////

#include <string.h>
  
#include "libsing.h"


/******************** Helper functions ***************/

/**
Print a GAP error message. 
@param message The message
**/
void PrintGAPError(const char* message)
{
  ErrorMayQuit(message, 0L, 0L);
}

/******************** The interface to GAP ***************/


/**
Details of the functions to make available to GAP. 
This is used in InitKernel() and InitLibrary()
*/
static StructGVarFunc GVarFuncs[] = 
{
  {"SingularRingWithoutOrdering", 2,
   "characteristic, names",
   FuncSingularRingWithoutOrdering,
   "cxx-funcs.cc:FuncSingularRingWithoutOrdering" }, 

  {"IndeterminatesOfSingularRing", 1,
   "ring", FuncIndeterminatesOfSingularRing,
   "cxx-funcs.cc:FuncIndeterminatesOfSingularRing" }, 

  {"SINGULAR_MONOMIAL", 3,
   "ring, coeff, exponents", FuncSINGULAR_MONOMIAL,
   "cxx-funcs.cc:FuncSINGULAR_MONOMIAL" }, 

  {"STRING_POLY", 1,
   "poly", FuncSTRING_POLY,
   "cxx-funcs.cc:FuncSTRING_POLY" }, 

  {"ADD_POLYS", 2,
   "a, b", FuncADD_POLYS,
   "cxx-funcs.cc:FuncADD_POLYS" }, 

  {"NEG_POLY", 1,
   "a", FuncNEG_POLY,
   "cxx-funcs.cc:FuncNEG_POLY" }, 

  {"MULT_POLYS", 2,
   "a, b", FuncMULT_POLYS,
   "cxx-funcs.cc:FuncMULT_POLYS" }, 

  {"MULT_POLY_NUMBER", 2,
   "a, b", FuncMULT_POLY_NUMBER,
   "cxx-funcs.cc:FuncMULT_POLY_NUMBER" }, 

  {"INIT_SINGULAR_INTERPRETER", 1, 
   "path",
   FuncINIT_SINGULAR_INTERPRETER,
   "cxx-funcs.cc:FuncINIT_SINGULAR_INTERPRETER" },

  {"EVALUATE_IN_SINGULAR", 1, 
   "st",
   FuncEVALUATE_IN_SINGULAR,
   "cxx-funcs.cc:FuncEVALUATE_IN_SINGULAR" },

  {"ValueOfSingularVar", 1, 
   "name",
   FuncValueOfSingularVar,
   "cxx-funcs.cc:FuncValueOfSingularVar" },

  {"LastSingularOutput", 0,
   "",
   FuncLastSingularOutput,
   "cxx-funcs.cc:FuncLastSingularOutput" },

  /* The rest will eventually go: */

  {"CXXAddStrings", /* GAP function name */
   2,               /* Number of parameters */
   "a, b",          /* String for GAP to display list of parameter names */
   FuncCONCATENATE, /* C function to call */
   "cxx-funcs.cc:FuncCONCATENATE" /* String to display function location */
  }, 

  {"FuncSingularTest", /* GAP function name */
   0,               /* Number of parameters */
   "",          /* String for GAP to display list of parameter names */
   FuncSingularTest, /* C function to call */
   "cxx-funcs.cc:FuncSingularTest" /* String to display function location */
  },

  { 0 } /* Finish with an empty entry */
};

Obj SingularTypes;    /* A kernel copy of a plain list of types */
Obj SingularRings;    /* A kernel copy of a plain list of rings */
Obj SingularElCounts; /* A kernel copy of a plain list of ref counts */

/**
The first function to be called when the library is loaded by the kernel.
**/
static Int InitKernel(StructInitInfo* module)
{
  Obj tmp;
  Int gvar;

  /* init filters and functions                                          */
  InitHdlrFuncsFromTable( GVarFuncs );
  InitFreeFuncBag(T_SINGULAR,&SingularFreeFunc);
  InitMarkFuncBags(T_SINGULAR,&SingularObjMarkFunc);
  tmp = NEW_PREC(SINGTYPE_LASTNUMBER);
  AssPRec(tmp,RNamName("SINGTYPE_BIGINT"), INTOBJ_INT(SINGTYPE_BIGINT));
  AssPRec(tmp,RNamName("SINGTYPE_RING"), INTOBJ_INT(SINGTYPE_RING));
  AssPRec(tmp,RNamName("SINGTYPE_POLY"), INTOBJ_INT(SINGTYPE_POLY));
  gvar = GVarName("SINGULAR_TYPENRS");
  MakeReadWriteGVar(gvar);
  AssGVar(gvar,tmp);
  MakeReadOnlyGVar(gvar);

  InitCopyGVar("SingularTypes", &SingularTypes);
  InitCopyGVar("SingularRings", &SingularRings);
  InitCopyGVar("SingularElCounts", &SingularElCounts);
  
  TypeObjFuncs[T_SINGULAR] = TypeSingularObj;

  /* return success                                                      */
  return 0;
}


/**
The second function to be called when the library is loaded by the kernel.
**/
static Int InitLibrary(StructInitInfo* module)
{
    /* init filters and functions                                          */
    InitGVarFuncsFromTable( GVarFuncs );

    /* return success                                                      */
    return 0;
}


/**
Information about this library, returned when the library is loaded, 
for example by Init__Dynamic(). This contains details of the library name,
and the further initialisation functions to call.
**/
static StructInitInfo module = {
#ifdef STATICMODULE
 /* type        = */ MODULE_STATIC,
#else
 /* type        = */ MODULE_DYNAMIC,
#endif
 /* name        = */ "libsingular interface",
 /* revision_c  = */ 0,
 /* revision_h  = */ 0,
 /* version     = */ 0,
 /* crc         = */ 0,
 /* initKernel  = */ InitKernel,
 /* initLibrary = */ InitLibrary,
 /* checkInit   = */ 0,
 /* preSave     = */ 0,
 /* postSave    = */ 0,
 /* postRestore = */ 0
};


#ifndef STATICGAP
/** 
Function called by GAP as soon as the library is dynamically loaded. 
This returns the StructInitInfo data for this library
**/
StructInitInfo * Init__Dynamic (void)
{
 return &module;
}
#endif
StructInitInfo * Init__libsing(void)
{
  return &module;
}

