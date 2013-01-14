//////////////////////////////////////////////////////////////////////////////
/**
@file libsing.cc
This file contains all of the pure C code that deals with GAP.
**/
//////////////////////////////////////////////////////////////////////////////

#include "libsing.h"
#include "lowlevel_mappings.h"
#include "singtypes.h"

/******************** The interface to GAP ***************/

static Obj Func_SI_debug(Obj self, Obj obj);

static Obj Func_SI_debug(Obj self, Obj obj)
{
    return NULL;
}

typedef Obj (* GVarFunc)(/*arguments*/);

#define GVAR_FUNC_TABLE_ENTRY(srcfile, name, nparam, params) \
  {#name, nparam, \
   params, \
   (GVarFunc)Func##name, \
   srcfile ":Func" #name }

/**
Details of the functions to make available to GAP.
This is used in InitKernel() and InitLibrary()
*/
static StructGVarFunc GVarFuncs[] = {
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_debug, 1, "obj"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_ring, 3, "characteristic, names, orderings"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", SI_Indeterminates, 1, "ring"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_poly_from_String, 2, "rr, st"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_matrix_from_String, 4, "rr, nrrows, nrcols, st"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_ideal_from_String, 2, "rr, st"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_MONOMIAL, 3, "ring, coeff, exponents"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_COPY_POLY, 1, "poly"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_MULT_POLY_NUMBER, 2, "a, b"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_INIT_INTERPRETER, 1, "path"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_EVALUATE, 1, "st"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", SI_ValueOfVar, 1, "name"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_SingularProcs, 0, ""),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", SI_ToGAP, 1, "singobj"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", SI_LastOutput, 0, ""),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_bigint, 1, "nr"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_Intbigint, 1, "nr"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_bigintmat, 1, "m"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_Matbigintmat, 1, "im"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_number, 2, "ring, nr"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_intvec, 1, "l"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_Plistintvec, 1, "iv"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_intmat, 1, "m"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_Matintmat, 1, "im"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_ideal_from_els, 1, "l"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_matrix_from_els, 3, "nrrows, nrcols, l"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_CallFunc1, 2, "op, input"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_CallFunc2, 3, "op, a, b"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_CallFunc3, 4, "op, a, b, c"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_CallFuncM, 2, "op, arg"),
    GVAR_FUNC_TABLE_ENTRY("cxx-funcs.cc", SI_SetCurrRing, 1, "r"),
    GVAR_FUNC_TABLE_ENTRY("cxx-funcs.cc", SI_ring_of_singobj, 1, "singobj"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", SI_CallProc, 2, "name, args"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_OmPrintInfo, 0, ""),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_OmCurrentBytes, 0, ""),

#include "lowlevel_mappings_table.h"

    { 0 } /* Finish with an empty entry */
};

Obj SI_Errors;
Obj _SI_ProxiesType;

// This is defined in arith.c but not exported in arith.h:
extern "C" Int EqObject(Obj opL, Obj opR);
extern "C" Int InObject(Obj opL, Obj opR);

// The following are not exported in lists.h:
extern "C" Int IsListObject(Obj obj);
extern "C" Int IsSmallListObject(Obj obj);
extern "C" Int LenListObject(Obj obj);
extern "C" Obj LengthObject(Obj obj);
extern "C" Int IsbListObject(Obj obj, Int pos);
extern "C" Int IsbbListObject(Obj obj, Obj pos);
extern "C" Obj Elm0ListObject(Obj obj, Int pos);
extern "C" Obj ElmListObject(Obj obj, Int pos);
extern "C" Obj ElmsListObject(Obj ob, Obj possj);
extern "C" void UnbListObject(Obj obj, Int pos);
extern "C" void UnbbListObject(Obj ob, Obj poss);
extern "C" void AssListObject(Obj list, Int pos, Obj obj);
extern "C" void AssbListObject(Obj list, Obj pos, Obj obj);
extern "C" void AsssListObject(Obj list, Obj poss, Obj obj);
extern "C" Int IsDenseListObject(Obj obj);
extern "C" Int IsHomogListObject(Obj obj);
extern "C" Int IsTableListObject(Obj obj);
extern "C" Int IsSSortListObject(Obj obj);
extern "C" Int IsPossListObject(Obj obj);
extern "C" Obj PosListObject(Obj list, Obj obj, Obj start);

/**
The first function to be called when the library is loaded by the kernel.
**/
static Int InitKernel(StructInitInfo* module)
{
    /* init filters and functions                                          */
    InitHdlrFuncsFromTable( GVarFuncs );
    InitFreeFuncBag(T_SINGULAR, &_SI_FreeFunc);
    InitMarkFuncBags(T_SINGULAR, &_SI_ObjMarkFunc);

    InitSingTypesFromKernel();

    InitCopyGVar("SI_Errors", &SI_Errors);
    InitCopyGVar("_SI_ProxiesType", &_SI_ProxiesType);

    TypeObjFuncs[T_SINGULAR] = _SI_TypeObj;
    InfoBags[T_SINGULAR].name = "singular wrapper object";

    /* TODO:
     * IsCopyableObjFuncs fuer T_SINGULAR
     * ShallowCopyObjFuncs fuer T_SINGULAR
     * CopyObjFuncs fuer T_SINGULAR
     * CleanObjFuncs fuer T_SINGULAR
     * PrintObjFuncs fuer T_SINGULAR ist PrintObjObject, OK?
     * PrintPathFuncs fuer T_SINGULAR
     * AInvFuncs fuer T_SINGULAR ist AInvObject, OK?
     * AInvMutFuncs fuer T_SINGULAR ist AInvMutObject, OK?
     * InvFuncs fuer T_SINGULAR ist InvObject, OK?
     * InvMutFuncs fuer T_SINGULAR ist InvMutObject, OK?
     * EqFuncs fuer T_SINGULAR/T_SINGULAR
     * LtFuncs fuer T_SINGULAR/T_SINGULAR ist LtObject, OK?
     // InFuncs fuer T_SINGULAR/T_SINGULAR
     * SumFuncs fuer T_SINGULAR/T_SINGULAR ist SumObject, OK?
     // SumFuncs[T_SINGULAR][T_SINGULAR] = SumSingObjs;
     * DiffFuncs fuer T_SINGULAR/T_SINGULAR ist DiffObject, OK?
     * ProdFuncs fuer T_SINGULAR/T_SINGULAR ist ProdObject, OK?
     * QuoFuncs fuer T_SINGULAR/T_SINGULAR ist QuoObject, OK?
     * LQuoFuncs fuer T_SINGULAR/T_SINGULAR ist LQuoObject, OK?
     * PowFuncs fuer T_SINGULAR/T_INT... ist PowObject, OK?
     * CommFuncs fuer T_SINGULAR/T_SINGULAR ist CommDefault, OK?
     * ModFuncs fuer T_SINGULAR/T_SINGULAR ist ModObject, OK?
     * IsListFuncs fuer T_SINGULAR ist
     * IsSmallListFuncs fuer T_SINGULAR ist */
    IsMutableObjFuncs[T_SINGULAR] = IsMutableSingObj;
    MakeImmutableObjFuncs[T_SINGULAR] = MakeImmutableSingObj;
    // The following are OK, see dev/ZEROONECHAOS for details!
    InFuncs[T_SINGULAR][T_SINGULAR] = InObject;
    ZeroFuncs[T_SINGULAR] = ZeroSMSingObj;
    OneMutFuncs[T_SINGULAR] = OneSMSingObj;
    EqFuncs[T_SINGULAR][T_SINGULAR] = EqObject;
    IsListFuncs[ T_SINGULAR ] = IsListObject;
    IsSmallListFuncs[ T_SINGULAR ] = IsSmallListObject;
    LenListFuncs[ T_SINGULAR ] = LenListObject;
    LengthFuncs[ T_SINGULAR ] = LengthObject;
    IsbListFuncs[ T_SINGULAR ] = IsbListObject;
    IsbvListFuncs[ T_SINGULAR ] = IsbListObject;
    IsbbListFuncs[ T_SINGULAR ] = IsbbListObject;
    Elm0ListFuncs[ T_SINGULAR ] = Elm0ListObject;
    Elm0vListFuncs[ T_SINGULAR ] = Elm0ListObject;
    ElmListFuncs[  T_SINGULAR ] = ElmListObject;
    ElmvListFuncs[ T_SINGULAR ] = ElmListObject;
    ElmwListFuncs[ T_SINGULAR ] = ElmListObject;
    ElmsListFuncs[ T_SINGULAR ] = ElmsListObject;
    UnbListFuncs[ T_SINGULAR ] = UnbListObject;
    UnbbListFuncs[ T_SINGULAR ] = UnbbListObject;
    AssListFuncs[ T_SINGULAR ] = AssListObject;
    AssbListFuncs[ T_SINGULAR ] = AssbListObject;
    AsssListFuncs[ T_SINGULAR ] = AsssListObject;
    IsDenseListFuncs[ T_SINGULAR ] = IsDenseListObject;
    IsHomogListFuncs[ T_SINGULAR ] = IsHomogListObject;
    IsTableListFuncs[ T_SINGULAR ] = IsTableListObject;
    IsSSortListFuncs[ T_SINGULAR ] = IsSSortListObject;
    IsPossListFuncs[ T_SINGULAR ] = IsPossListObject;
    PosListFuncs[ T_SINGULAR ] = PosListObject;

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

