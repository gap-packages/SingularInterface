// SingularInterface: A GAP interface to Singular
//
// Copyright of SingularInterface belongs to its developers.
// Please refer to the COPYRIGHT file for details.
//
// SPDX-License-Identifier: GPL-2.0-or-later

#include "libsing.h"
#include "singobj.h"


#include <coeffs/longrat.h>
//#include <kernel/syz.h>
#include <Singular/ipid.h>
#include <Singular/libsingular.h>
#include <Singular/lists.h>


static Obj _SI_Types; /* A kernel copy of a plain list of types */


// The following table maps GAP type numbers for singular objects to
// Singular type numbers for Singular objects:

const int GAPtoSingType[] = {
    0, /* NOTUSED */
    0, /* NOTUSED */
    BIGINT_CMD,
    BIGINT_CMD,
    BIGINTMAT_CMD,
    BIGINTMAT_CMD,
    DEF_CMD,
    DEF_CMD,
    IDEAL_CMD,
    IDEAL_CMD,
    INT_CMD,
    INT_CMD,
    INTMAT_CMD,
    INTMAT_CMD,
    INTVEC_CMD,
    INTVEC_CMD,
    LINK_CMD,
    LINK_CMD,
    LIST_CMD,
    LIST_CMD,
    MAP_CMD,
    MAP_CMD,
    MATRIX_CMD,
    MATRIX_CMD,
    MODUL_CMD,
    MODUL_CMD,
    NUMBER_CMD,
    NUMBER_CMD,
    PACKAGE_CMD,
    PACKAGE_CMD,
    POLY_CMD,
    POLY_CMD,
    PROC_CMD,
    PROC_CMD,
    QRING_CMD,
    QRING_CMD,
    RESOLUTION_CMD,
    RESOLUTION_CMD,
    RING_CMD,
    RING_CMD,
    STRING_CMD,
    STRING_CMD,
    VECTOR_CMD,
    VECTOR_CMD,
    0, /* USERDEF */
    0, /* USERDEF */
};

int SingtoGAPType[MAX_TOK];

const int HasRingTable[] = {
    0,    // NOTUSED
    0,    // NOTUSED
    0,    // SINGTYPE_BIGINT        = 2,
    0,    // SINGTYPE_BIGINT_IMM    = 3,
    0,    // SINGTYPE_BIGINTMAT     = 4,
    0,    // SINGTYPE_BIGINTMAT_IMM = 5,
    0,    // SINGTYPE_DEF           = 6,
    0,    // SINGTYPE_DEF_IMM       = 7,
    1,    // SINGTYPE_IDEAL         = 8,
    1,    // SINGTYPE_IDEAL_IMM     = 9,
    0,    // SINGTYPE_INT           = 10,
    0,    // SINGTYPE_INT_IMM       = 11,
    0,    // SINGTYPE_INTMAT        = 12,
    0,    // SINGTYPE_INTMAT_IMM    = 13,
    0,    // SINGTYPE_INTVEC        = 14,
    0,    // SINGTYPE_INTVEC_IMM    = 15,
    0,    // SINGTYPE_LINK          = 16,
    0,    // SINGTYPE_LINK_IMM      = 17,
    1,    // SINGTYPE_LIST          = 18,
    1,    // SINGTYPE_LIST_IMM      = 19,
    1,    // SINGTYPE_MAP           = 20,
    1,    // SINGTYPE_MAP_IMM       = 21,
    1,    // SINGTYPE_MATRIX        = 22,
    1,    // SINGTYPE_MATRIX_IMM    = 23,
    1,    // SINGTYPE_MODULE        = 24,
    1,    // SINGTYPE_MODULE_IMM    = 25,
    1,    // SINGTYPE_NUMBER        = 26,
    1,    // SINGTYPE_NUMBER_IMM    = 27,
    0,    // SINGTYPE_PACKAGE       = 28,
    0,    // SINGTYPE_PACKAGE_IMM   = 29,
    1,    // SINGTYPE_POLY          = 30,
    1,    // SINGTYPE_POLY_IMM      = 31,
    0,    // SINGTYPE_PROC          = 32,
    0,    // SINGTYPE_PROC_IMM      = 33,
    0,    // SINGTYPE_QRING         = 34,
    0,    // SINGTYPE_QRING_IMM     = 35,
    1,    // SINGTYPE_RESOLUTION    = 36,
    1,    // SINGTYPE_RESOLUTION_IMM= 37,
    0,    // SINGTYPE_RING          = 38,
    0,    // SINGTYPE_RING_IMM      = 39,
    0,    // SINGTYPE_STRING        = 40,
    0,    // SINGTYPE_STRING_IMM    = 41,
    1,    // SINGTYPE_VECTOR        = 42,
    1,    // SINGTYPE_VECTOR_IMM    = 43,
    0,    // SINGTYPE_USERDEF       = 44,
    0,    // SINGTYPE_USERDEF_IMM   = 45,
    // TODO (?): reference
    // TODO (?): shared
};


void InitSingTypesFromKernel()
{
    Obj tmp;
    Int gvar;
    int i;
    memset(SingtoGAPType, 0, sizeof(SingtoGAPType));
    for (i = SINGTYPE_BIGINT; i <= SINGTYPE_VECTOR; i += 2) {
        if (GAPtoSingType[i] >= MAX_TOK) {
            Pr("Singular types have changed unforeseen", 0L, 0L);
            exit(1);
        }
        SingtoGAPType[GAPtoSingType[i]] = i;
    }

    tmp = NEW_PREC(SINGTYPE_LASTNUMBER);

#define ExportAsRecEntry(symbol)                                             \
    AssPRec(tmp, RNamName(#symbol), INTOBJ_INT(symbol));                     \
    AssPRec(tmp, RNamName(#symbol "_IMM"), INTOBJ_INT(symbol##_IMM))

    ExportAsRecEntry(SINGTYPE_BIGINT);
    ExportAsRecEntry(SINGTYPE_BIGINTMAT);
    ExportAsRecEntry(SINGTYPE_DEF);
    ExportAsRecEntry(SINGTYPE_IDEAL);
    ExportAsRecEntry(SINGTYPE_INT);
    ExportAsRecEntry(SINGTYPE_INTMAT);
    ExportAsRecEntry(SINGTYPE_INTVEC);
    ExportAsRecEntry(SINGTYPE_LINK);
    ExportAsRecEntry(SINGTYPE_LIST);
    ExportAsRecEntry(SINGTYPE_MAP);
    ExportAsRecEntry(SINGTYPE_MATRIX);
    ExportAsRecEntry(SINGTYPE_MODULE);
    ExportAsRecEntry(SINGTYPE_NUMBER);
    ExportAsRecEntry(SINGTYPE_PACKAGE);
    ExportAsRecEntry(SINGTYPE_POLY);
    ExportAsRecEntry(SINGTYPE_PROC);
    ExportAsRecEntry(SINGTYPE_QRING);
    ExportAsRecEntry(SINGTYPE_RESOLUTION);
    ExportAsRecEntry(SINGTYPE_RING);
    ExportAsRecEntry(SINGTYPE_STRING);
    ExportAsRecEntry(SINGTYPE_VECTOR);
    ExportAsRecEntry(SINGTYPE_USERDEF);
    // TODO (?): reference
    // TODO (?): shared
    gvar = GVarName("_SI_TYPENRS");
    MakeReadWriteGVar(gvar);
    AssGVar(gvar, tmp);
    MakeReadOnlyGVar(gvar);

    InitCopyGVar("_SI_Types", &_SI_Types);
}


// The following function returns the GAP type of an object with TNUM
// T_SINGULAR. A pointer to it is put into the dispatcher table in the
// GAP kernel.
Obj _SI_TypeObj(Obj o)
{
    return ELM_PLIST(_SI_Types, TYPE_SINGOBJ(o));
}
