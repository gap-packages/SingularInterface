/* SingularInterface: A GAP interface to Singular
 *
 * Copyright (C) 2011-2014  Mohamed Barakat, Max Horn, Frank Lübeck,
 *                          Oleksandr Motsak, Max Neunhöffer, Hans Schönemann
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 */

#include "libsing.h"
#include "lowlevel_mappings.h"
#include "singtypes.h"
#include "matrix.h"

/******************** The interface to GAP ***************/

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
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_EVALUATE, 1, "st"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", SingularValueOfVar, 1, "name"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_SingularProcs, 0, ""),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", SI_ToGAP, 1, "singobj"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", SingularLastOutput, 0, ""),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_bigint, 1, "nr"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_Intbigint, 1, "nr"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_number, 2, "ring, nr"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_intvec, 1, "l"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_Plistintvec, 1, "iv"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_ideal_from_els, 1, "l"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", SI_RingOfSingobj, 1, "singobj"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_OmPrintInfo, 0, ""),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_OmCurrentBytes, 0, ""),

    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_attrib, 1, "singobj"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_flags, 1, "singobj"),
    GVAR_FUNC_TABLE_ENTRY("cxxfuncs.cc", _SI_type, 1, "singobj"),

    GVAR_FUNC_TABLE_ENTRY("calls.cc", _SI_CallFunc1, 3, "r, op, input"),
    GVAR_FUNC_TABLE_ENTRY("calls.cc", _SI_CallFunc2, 4, "r, op, a, b"),
    GVAR_FUNC_TABLE_ENTRY("calls.cc", _SI_CallFunc3, 5, "r, op, a, b, c"),
    GVAR_FUNC_TABLE_ENTRY("calls.cc", _SI_CallFuncM, 3, "r, op, arg"),
    GVAR_FUNC_TABLE_ENTRY("calls.cc",  SI_SetCurrRing, 1, "r"),
    GVAR_FUNC_TABLE_ENTRY("calls.cc",  SI_CallProc, 2, "name, args"),

    GVAR_FUNC_TABLE_ENTRY("matrix.cc", _SI_bigintmat, 1, "m"),
    GVAR_FUNC_TABLE_ENTRY("matrix.cc", _SI_Matbigintmat, 1, "im"),
    GVAR_FUNC_TABLE_ENTRY("matrix.cc", _SI_intmat, 1, "m"),
    GVAR_FUNC_TABLE_ENTRY("matrix.cc", _SI_Matintmat, 1, "im"),
    GVAR_FUNC_TABLE_ENTRY("matrix.cc", _SI_matrix_from_els, 3, "nrrows, nrcols, l"),
    GVAR_FUNC_TABLE_ENTRY("matrix.cc", _SI_MatElm, 3, "mat, row, col"),
    GVAR_FUNC_TABLE_ENTRY("matrix.cc", _SI_SetMatElm, 4, "mat, row, col, val"),

#include "lowlevel_mappings_table.h"

    { 0 } /* Finish with an empty entry */
};

Obj _SI_ProxiesType;
UInt _SI_internalRingRNam;

UInt T_SINGULAR = 0;

/** 
Stores the GAP object that is the function IntFFE() so that we can
call it to convert finite field elements to integers.
*/
Obj SI_IntFFE;


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
    Int tnum = RegisterPackageTNUM("singular wrapper object", _SI_TypeObj);
    if (tnum < 0)
        return -1; // failure
    T_SINGULAR = (UInt)tnum;

    InitHdlrFuncsFromTable( GVarFuncs );
    InitFreeFuncBag(T_SINGULAR, &_SI_FreeFunc);
    InitMarkFuncBags(T_SINGULAR, &_SI_ObjMarkFunc);

    InitSingTypesFromKernel();

    InitCopyGVar("_SI_ProxiesType", &_SI_ProxiesType);
    InitFopyGVar( "IntFFE", &SI_IntFFE );

    /* TODO:
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
     */

    // The following are OK, see dev/ZEROONECHAOS for details!
    ZeroFuncs[T_SINGULAR] = ZeroSMSingObj;
    OneMutFuncs[T_SINGULAR] = OneSMSingObj;
    EqFuncs[T_SINGULAR][T_SINGULAR] = EqObject;

    IsCopyableObjFuncs[T_SINGULAR] = IsCopyableObjSingular;
    ShallowCopyObjFuncs[T_SINGULAR] = ShallowCopyObjSingular;
    CopyObjFuncs[T_SINGULAR] = CopyObjSingular;
    CleanObjFuncs[T_SINGULAR] = CleanObjConstant;
    IsMutableObjFuncs[T_SINGULAR] = IsMutableSingObj;
    MakeImmutableObjFuncs[T_SINGULAR] = MakeImmutableSingObj;

    InstallPrePostGCFuncs();

    /* return success                                                      */
    return 0;
}


// Called after workspace is restored (and also when GAP starts).
static Int PostRestore(StructInitInfo* module)
{
    _SI_LastErrorStringGVar = GVarName("_SI_LastErrorString");
    AssGVar(_SI_LastErrorStringGVar, NEW_STRING(0));
    MakeReadOnlyGVar(_SI_LastErrorStringGVar);

    _SI_LastOutputStringGVar = GVarName("_SI_LastOutputString");
    AssGVar(_SI_LastOutputStringGVar, NEW_STRING(0));
    MakeReadOnlyGVar(_SI_LastOutputStringGVar);

    /* Set '_SI_LIBSING_LOADED' as a canary variable, so we can detect (and prevent)
      attempts to load the C code more than once. */
    UInt gvar = GVarName("_SI_LIBSING_LOADED");
    AssGVar(gvar, NEW_PREC(0));
    MakeReadOnlyGVar(gvar);

    _SI_internalRingRNam = RNamName("internalRing");

    // Init Singular. Note that siInit() expects the path to
    // "the" Singular binary.
    char path[] = LIBSINGULAR_HOME "/bin/Singular";
    siInit(path);
    currentVoice = feInitStdin(NULL);
    WerrorS_callback = _SI_ErrorCallback;

    /* return success                                                      */
    return 0;
}


/**
The second function to be called when the library is loaded by the kernel.
**/
static Int InitLibrary(StructInitInfo* module)
{
    /* init filters and functions                                          */
    InitGVarFuncsFromTable(GVarFuncs);

    /* return success                                                      */
    return PostRestore(module);
}


/**
Information about this library, returned when the library is loaded,
for example by Init__Dynamic(). This contains details of the library name,
and the further initialisation functions to call.
**/
static StructInitInfo module = {
#ifdef STATICMODULE
    .type = MODULE_STATIC,
#else
    .type = MODULE_DYNAMIC,
#endif
    .name = "SingularInterface",
    .initKernel = InitKernel,
    .initLibrary = InitLibrary,
    .postRestore = PostRestore
};


#ifndef STATICGAP
/**
Function called by GAP as soon as the library is dynamically loaded.
This returns the StructInitInfo data for this library
**/
extern "C" StructInitInfo * Init__Dynamic(void);
extern "C" StructInitInfo * Init__Dynamic(void)
{
    return &module;
}
#endif
extern "C" StructInitInfo * Init__libsing(void);
extern "C" StructInitInfo * Init__libsing(void)
{
    return &module;
}

