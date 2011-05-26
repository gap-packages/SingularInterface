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

  {"SingularRingWithoutOrdering", 3,
   "characteristic, numberinvs, names",
   FuncSingularRingWithoutOrdering,
   "cxx-funcs.cc:FuncSingularRingWithoutOrdering" }, 

  {"IndeterminatesOfSingularRing", 1,
   "ring", FuncIndeterminatesOfSingularRing,
   "cxx-funcs.cc:FuncIndeterminatesOfSingularRing" }, 

  { 0 } /* Finish with an empty entry */
};



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
  tmp = NEW_PREC(SINGTYPE_LASTNUMBER);
  AssPRec(tmp,RNamName("SINGTYPE_BIGINT"), INTOBJ_INT(SINGTYPE_BIGINT));
  AssPRec(tmp,RNamName("SINGTYPE_RING"), INTOBJ_INT(SINGTYPE_RING));
  AssPRec(tmp,RNamName("SINGTYPE_POLY"), INTOBJ_INT(SINGTYPE_POLY));
  gvar = GVarName("SINGULAR_TYPENRS");
  MakeReadWriteGVar(gvar);
  AssGVar(gvar,tmp);
  MakeReadOnlyGVar(gvar);

  InitCopyGVar("SingularTypes", &SingularTypes);
  
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
 /* name        = */ "simple C++ interface",
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
StructInitInfo * Init__linbox(void)
{
  return &module;
}

