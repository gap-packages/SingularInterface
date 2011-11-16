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

  {"SI_MONOMIAL", 3,
   "ring, coeff, exponents", FuncSI_MONOMIAL,
   "cxx-funcs.cc:FuncSI_MONOMIAL" }, 

  {"SI_STRING_POLY", 1,
   "poly", FuncSI_STRING_POLY,
   "cxx-funcs.cc:FuncSI_STRING_POLY" }, 

  {"SI_ADD_POLYS", 2,
   "a, b", FuncSI_ADD_POLYS,
   "cxx-funcs.cc:FuncSI_ADD_POLYS" }, 

  {"SI_NEG_POLY", 1,
   "a", FuncSI_NEG_POLY,
   "cxx-funcs.cc:FuncSI_NEG_POLY" }, 

  {"SI_MULT_POLYS", 2,
   "a, b", FuncSI_MULT_POLYS,
   "cxx-funcs.cc:FuncSI_MULT_POLYS" }, 

  {"SI_MULT_POLY_NUMBER", 2,
   "a, b", FuncSI_MULT_POLY_NUMBER,
   "cxx-funcs.cc:FuncSI_MULT_POLY_NUMBER" }, 

  {"SI_INIT_INTERPRETER", 1, 
   "path",
   FuncSI_INIT_INTERPRETER,
   "cxx-funcs.cc:FuncSI_INIT_INTERPRETER" },

  {"SI_EVALUATE", 1, 
   "st",
   FuncSI_EVALUATE,
   "cxx-funcs.cc:FuncSI_EVALUATE" },

  {"ValueOfSingularVar", 1, 
   "name",
   FuncValueOfSingularVar,
   "cxx-funcs.cc:FuncValueOfSingularVar" },

  {"LastSingularOutput", 0,
   "",
   FuncLastSingularOutput,
   "cxx-funcs.cc:FuncLastSingularOutput" },

  {"SI_bigint", 1,
   "nr",
   FuncSI_bigint,
   "cxx-funcs.cc:FuncSI_bigint" },

  {"SI_Intbigint", 1,
   "nr",
   FuncSI_Intbigint,
   "cxx-funcs.cc:FuncSI_Intbigint" },

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
Obj SingularErrors;   /* A kernel copy of a string */

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
  InitCopyGVar("SingularErrors", &SingularErrors);
  
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

