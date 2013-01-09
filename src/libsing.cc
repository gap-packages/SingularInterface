//////////////////////////////////////////////////////////////////////////////
/**
@file libsing.c
This file contains all of the pure C code that deals with GAP.
**/
//////////////////////////////////////////////////////////////////////////////

#include "libsing.h"
#include "lowlevel_mappings.h"

/******************** The interface to GAP ***************/

Obj Func_SI_debug(Obj self, Obj obj)
{
    return NULL;
}

typedef Obj (* GVarFunc)(/*arguments*/);

/**
Details of the functions to make available to GAP.
This is used in InitKernel() and InitLibrary()
*/
static StructGVarFunc GVarFuncs[] =
{

  {"_SI_debug", 1,
   "obj",
   (GVarFunc)Func_SI_debug,
   "cxxfuncs.cc:Func_SI_debug" },

  {"_SI_ring", 3,
   "characteristic, names, orderings",
   (GVarFunc)Func_SI_ring,
   "cxxfuncs.cc:Func_SI_ring" },

  {"SI_Indeterminates", 1,
   "ring",
   (GVarFunc)FuncSI_Indeterminates,
   "cxxfuncs.cc:FuncSI_Indeterminates" },

  {"_SI_poly_from_String", 2,
   "rr, st",
   (GVarFunc)Func_SI_poly_from_String,
   "cxxfuncs.cc:Func_SI_poly_from_String" },

  {"_SI_matrix_from_String", 4,
   "nrrows, nrcols, rr, st",
   (GVarFunc)Func_SI_matrix_from_String,
   "cxxfuncs.cc:Func_SI_matrix_from_String" },

  {"_SI_MONOMIAL", 3,
   "ring, coeff, exponents",
   (GVarFunc)Func_SI_MONOMIAL,
   "cxxfuncs.cc:Func_SI_MONOMIAL" },

  {"_SI_COPY_POLY", 1,
   "poly",
   (GVarFunc)Func_SI_COPY_POLY,
   "cxxfuncs.cc:Func_SI_COPY_POLY" },

  {"_SI_MULT_POLY_NUMBER", 2,
   "a, b",
   (GVarFunc)Func_SI_MULT_POLY_NUMBER,
   "cxxfuncs.cc:Func_SI_MULT_POLY_NUMBER" },

  {"_SI_INIT_INTERPRETER", 1,
   "path",
   (GVarFunc)Func_SI_INIT_INTERPRETER,
   "cxxfuncs.cc:Func_SI_INIT_INTERPRETER" },

  {"_SI_EVALUATE", 1,
   "st",
   (GVarFunc)Func_SI_EVALUATE,
   "cxxfuncs.cc:Func_SI_EVALUATE" },

  {"SI_ValueOfVar", 1,
   "name",
   (GVarFunc)FuncSI_ValueOfVar,
   "cxxfuncs.cc:FuncSI_ValueOfVar" },

  {"_SI_SingularProcs", 0,
   "",
   (GVarFunc)Func_SI_SingularProcs,
   "cxxfuncs.cc:Func_SI_SingularProcs" },

  {"SI_ToGAP", 1,
   "singobj",
   (GVarFunc)FuncSI_ToGAP,
   "cxxfuncs.cc:FuncSI_ToGAP" },

  {"SI_LastOutput", 0,
   "",
   (GVarFunc)FuncSI_LastOutput,
   "cxxfuncs.cc:FuncSI_LastOutput" },

  {"_SI_bigint", 1,
   "nr",
   (GVarFunc)Func_SI_bigint,
   "cxxfuncs.cc:Func_SI_bigint" },

  {"_SI_Intbigint", 1,
   "nr",
   (GVarFunc)Func_SI_Intbigint,
   "cxxfuncs.cc:Func_SI_Intbigint" },

  {"_SI_number", 2,
   "ring, nr",
   (GVarFunc)Func_SI_number,
   "cxxfuncs.cc:Func_SI_number" },

  {"_SI_intvec", 1,
   "l",
   (GVarFunc)Func_SI_intvec,
   "cxxfuncs.cc:Func_SI_intvec" },

  {"_SI_Plistintvec", 1,
   "iv",
   (GVarFunc)Func_SI_Plistintvec,
   "cxxfuncs.cc:Func_SI_Plistintvec" },

  {"_SI_intmat", 1,
   "m",
   (GVarFunc)Func_SI_intmat,
   "cxxfuncs.cc:Func_SI_intmat" },

  {"_SI_Matintmat", 1,
   "im",
   (GVarFunc)Func_SI_Matintmat,
   "cxxfuncs.cc:Func_SI_Matintmat" },

  {"_SI_ideal_from_els", 1,
   "l",
   (GVarFunc)Func_SI_ideal_from_els,
   "cxxfuncs.cc:Func_SI_ideal_from_els" },

  {"_SI_matrix_from_els", 3,
   "nrrows, nrcols, l",
   (GVarFunc)Func_SI_matrix_from_els,
   "cxxfuncs.cc:Func_SI_matrix_from_els" },

  {"_SI_CallFunc1", 2,
   "op, input",
   (GVarFunc)Func_SI_CallFunc1,
   "cxxfuncs.cc:Func_SI_CallFunc1" },

  {"_SI_CallFunc2", 3,
   "op, a, b",
   (GVarFunc)Func_SI_CallFunc2,
   "cxxfuncs.cc:Func_SI_CallFunc2" },

  {"_SI_CallFunc3", 4,
   "op, a, b, c",
   (GVarFunc)Func_SI_CallFunc3,
   "cxxfuncs.cc:Func_SI_CallFunc3" },

  {"_SI_CallFuncM", 2,
   "op, arg",
   (GVarFunc)Func_SI_CallFuncM,
   "cxxfuncs.cc:Func_SI_CallFuncM" },

  {"SI_SetCurrRing", 1,
   "r",
   (GVarFunc)FuncSI_SetCurrRing,
   "cxx-funcs.cc:FuncSI_SetCurrRing" },

  {"SI_ring_of_singobj", 1,
   "singobj",
   (GVarFunc)FuncSI_ring_of_singobj,
   "cxx-funcs.cc:FuncSI_ring_of_singobj" },

  {"SI_CallProc", 2,
   "name, args",
   (GVarFunc)FuncSI_CallProc,
   "cxxfuncs.cc:FuncSI_CallProc" },

  {"_SI_OmPrintInfo", 0,
   "",
   (GVarFunc)FuncOmPrintInfo,
   "cxxfuncs.cc:FuncOmPrintInfo" },

  {"_SI_OmCurrentBytes", 0,
   "",
   (GVarFunc)FuncOmCurrentBytes,
   "cxxfuncs.cc:FuncOmCurrentBytes" },

#include "lowlevel_mappings_table.h"

  { 0 } /* Finish with an empty entry */
};

Obj _SI_Types;    /* A kernel copy of a plain list of types */
Obj SI_Errors;   /* A kernel copy of a string */
Obj SingularProxiesType;  /* A kernel copy of the type of proxies */
Obj SI_CurrentRingObj;   /* The GAP wrapper for the current Singular ring */

extern "C" Int EqObject(Obj opL, Obj opR);
// This is defined in arith.c but not exported in arith.h 


/**
The first function to be called when the library is loaded by the kernel.
**/
static Int InitKernel(StructInitInfo* module)
{
  Obj tmp;
  Int gvar;

  /* init filters and functions                                          */
  InitHdlrFuncsFromTable( GVarFuncs );
  InitFreeFuncBag(T_SINGULAR,&_SI_FreeFunc);
  InitMarkFuncBags(T_SINGULAR,&_SI_ObjMarkFunc);
  tmp = NEW_PREC(SINGTYPE_LASTNUMBER);
  AssPRec(tmp,RNamName("SINGTYPE_VOID"), INTOBJ_INT(SINGTYPE_VOID));
  AssPRec(tmp,RNamName("SINGTYPE_BIGINT"), INTOBJ_INT(SINGTYPE_BIGINT));
  AssPRec(tmp,RNamName("SINGTYPE_BIGINT_IMM"), INTOBJ_INT(SINGTYPE_BIGINT_IMM));
  AssPRec(tmp,RNamName("SINGTYPE_DEF"), INTOBJ_INT(SINGTYPE_DEF));
  AssPRec(tmp,RNamName("SINGTYPE_DEF_IMM"), INTOBJ_INT(SINGTYPE_DEF_IMM));
  AssPRec(tmp,RNamName("SINGTYPE_IDEAL"), INTOBJ_INT(SINGTYPE_IDEAL));
  AssPRec(tmp,RNamName("SINGTYPE_IDEAL_IMM"), INTOBJ_INT(SINGTYPE_IDEAL_IMM));
  AssPRec(tmp,RNamName("SINGTYPE_INT"), INTOBJ_INT(SINGTYPE_INT));
  AssPRec(tmp,RNamName("SINGTYPE_INT_IMM"), INTOBJ_INT(SINGTYPE_INT_IMM));
  AssPRec(tmp,RNamName("SINGTYPE_INTMAT"), INTOBJ_INT(SINGTYPE_INTMAT));
  AssPRec(tmp,RNamName("SINGTYPE_INTMAT_IMM"), INTOBJ_INT(SINGTYPE_INTMAT_IMM));
  AssPRec(tmp,RNamName("SINGTYPE_INTVEC"), INTOBJ_INT(SINGTYPE_INTVEC));
  AssPRec(tmp,RNamName("SINGTYPE_INTVEC_IMM"), INTOBJ_INT(SINGTYPE_INTVEC_IMM));
  AssPRec(tmp,RNamName("SINGTYPE_LINK"), INTOBJ_INT(SINGTYPE_LINK));
  AssPRec(tmp,RNamName("SINGTYPE_LINK_IMM"), INTOBJ_INT(SINGTYPE_LINK_IMM));
  AssPRec(tmp,RNamName("SINGTYPE_LIST"), INTOBJ_INT(SINGTYPE_LIST));
  AssPRec(tmp,RNamName("SINGTYPE_LIST_IMM"), INTOBJ_INT(SINGTYPE_LIST_IMM));
  AssPRec(tmp,RNamName("SINGTYPE_MAP"), INTOBJ_INT(SINGTYPE_MAP));
  AssPRec(tmp,RNamName("SINGTYPE_MAP_IMM"), INTOBJ_INT(SINGTYPE_MAP_IMM));
  AssPRec(tmp,RNamName("SINGTYPE_MATRIX"), INTOBJ_INT(SINGTYPE_MATRIX));
  AssPRec(tmp,RNamName("SINGTYPE_MATRIX_IMM"), INTOBJ_INT(SINGTYPE_MATRIX_IMM));
  AssPRec(tmp,RNamName("SINGTYPE_MODULE"), INTOBJ_INT(SINGTYPE_MODULE));
  AssPRec(tmp,RNamName("SINGTYPE_MODULE_IMM"), INTOBJ_INT(SINGTYPE_MODULE_IMM));
  AssPRec(tmp,RNamName("SINGTYPE_NUMBER"), INTOBJ_INT(SINGTYPE_NUMBER));
  AssPRec(tmp,RNamName("SINGTYPE_NUMBER_IMM"), INTOBJ_INT(SINGTYPE_NUMBER_IMM));
  AssPRec(tmp,RNamName("SINGTYPE_PACKAGE"), INTOBJ_INT(SINGTYPE_PACKAGE));
  AssPRec(tmp,RNamName("SINGTYPE_PACKAGE_IMM"), INTOBJ_INT(SINGTYPE_PACKAGE_IMM));
  AssPRec(tmp,RNamName("SINGTYPE_POLY"), INTOBJ_INT(SINGTYPE_POLY));
  AssPRec(tmp,RNamName("SINGTYPE_POLY_IMM"), INTOBJ_INT(SINGTYPE_POLY_IMM));
  AssPRec(tmp,RNamName("SINGTYPE_PROC"), INTOBJ_INT(SINGTYPE_PROC));
  AssPRec(tmp,RNamName("SINGTYPE_PROC_IMM"), INTOBJ_INT(SINGTYPE_PROC_IMM));
  AssPRec(tmp,RNamName("SINGTYPE_QRING"), INTOBJ_INT(SINGTYPE_QRING));
  AssPRec(tmp,RNamName("SINGTYPE_QRING_IMM"), INTOBJ_INT(SINGTYPE_QRING_IMM));
  AssPRec(tmp,RNamName("SINGTYPE_RESOLUTION"), INTOBJ_INT(SINGTYPE_RESOLUTION));
  AssPRec(tmp,RNamName("SINGTYPE_RESOLUTION_IMM"), INTOBJ_INT(SINGTYPE_RESOLUTION_IMM));
  AssPRec(tmp,RNamName("SINGTYPE_RING"), INTOBJ_INT(SINGTYPE_RING));
  AssPRec(tmp,RNamName("SINGTYPE_RING_IMM"), INTOBJ_INT(SINGTYPE_RING_IMM));
  AssPRec(tmp,RNamName("SINGTYPE_STRING"), INTOBJ_INT(SINGTYPE_STRING));
  AssPRec(tmp,RNamName("SINGTYPE_STRING_IMM"), INTOBJ_INT(SINGTYPE_STRING_IMM));
  AssPRec(tmp,RNamName("SINGTYPE_VECTOR"), INTOBJ_INT(SINGTYPE_VECTOR));
  AssPRec(tmp,RNamName("SINGTYPE_VECTOR_IMM"), INTOBJ_INT(SINGTYPE_VECTOR_IMM));
  AssPRec(tmp,RNamName("SINGTYPE_USERDEF"), INTOBJ_INT(SINGTYPE_USERDEF));
  AssPRec(tmp,RNamName("SINGTYPE_USERDEF_IMM"), INTOBJ_INT(SINGTYPE_USERDEF_IMM));
  AssPRec(tmp,RNamName("SINGTYPE_PYOBJECT"), INTOBJ_INT(SINGTYPE_PYOBJECT));
  AssPRec(tmp,RNamName("SINGTYPE_PYOBJECT_IMM"), INTOBJ_INT(SINGTYPE_PYOBJECT_IMM));
  gvar = GVarName("_SI_TYPENRS");
  MakeReadWriteGVar(gvar);
  AssGVar(gvar,tmp);
  MakeReadOnlyGVar(gvar);

  InitCopyGVar("_SI_Types", &_SI_Types);
  InitCopyGVar("SI_Errors", &SI_Errors);
  InitCopyGVar("SingularProxiesType", &SingularProxiesType);
  InitCopyGVar("SI_CurrentRingObj", &SI_CurrentRingObj); // FIXME: Can we do this w/o exposing the var on the interpreter level?

  TypeObjFuncs[T_SINGULAR] = _SI_TypeObj;
  InfoBags[T_SINGULAR].name = "singular wrapper object";

  /* TODO:
   * IsCopyableObjFuncs fuer T_SINGULAR
   * ShallowCopyObjFuncs fuer T_SINGULAR
   * CopyObjFuncs fuer T_SINGULAR
   * CleanObjFuncs fuer T_SINGULAR
   * PrintObjFuncs fuer T_SINGULAR ist PrintObjObject, OK?
   * PrintPathFuncs fuer T_SINGULAR
   * IsMutableObjFunc fuer T_SINGULAR
   * ZeroFuncs fuer T_SINGULAR ist ZeroObject, OK?
   * ZeroMutFuncs fuer T_SINGULAR ist ZeroMutObject, OK?
   * AInvFuncs fuer T_SINGULAR ist AInvObject, OK?
   * AInvMutFuncs fuer T_SINGULAR ist AInvMutObject, OK?
   * OneFuncs fuer T_SINGULAR ist OneObject, OK?
   * OneMutFuncs fuer T_SINGULAR ist OneMutObject, OK?
   * InvFuncs fuer T_SINGULAR ist InvObject, OK?
   * InvMutFuncs fuer T_SINGULAR ist InvMutObject, OK?
   * EqFuncs fuer T_SINGULAR/T_SINGULAR
   * LtFuncs fuer T_SINGULAR/T_SINGULAR ist LtObject, OK?
   * InFuncs fuer T_SINGULAR/T_SINGULAR
   * SumFuncs fuer T_SINGULAR/T_SINGULAR ist SumObject, OK?
   * DiffFuncs fuer T_SINGULAR/T_SINGULAR ist DiffObject, OK?
   * ProdFuncs fuer T_SINGULAR/T_SINGULAR ist ProdObject, OK?
   * QuoFuncs fuer T_SINGULAR/T_SINGULAR ist QuoObject, OK?
   * LQuoFuncs fuer T_SINGULAR/T_SINGULAR ist LQuoObject, OK?
   * PowFuncs fuer T_SINGULAR/T_INT... ist PowObject, OK?
   * CommFuncs fuer T_SINGULAR/T_SINGULAR ist CommDefault, OK?
   * ModFuncs fuer T_SINGULAR/T_SINGULAR ist ModObject, OK? */
  IsMutableObjFuncs[T_SINGULAR] = IsMutableSingObj;
  MakeImmutableObjFuncs[T_SINGULAR] = MakeImmutableSingObj;
  ZeroFuncs[T_SINGULAR] = ZeroSingObj;
  OneFuncs[T_SINGULAR] = OneSingObj;
  EqFuncs[T_SINGULAR][T_SINGULAR] = EqObject;

  InstallPrePostGCFuncs();

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
extern "C"
StructInitInfo * Init__Dynamic (void)
{
 return &module;
}
#endif
extern "C"
StructInitInfo * Init__libsing(void)
{
  return &module;
}

