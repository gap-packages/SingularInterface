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
#include "singobj.h"


#include <coeffs/longrat.h>
//#include <kernel/syz.h>
#include <Singular/ipid.h>
#include <Singular/libsingular.h>
#include <Singular/lists.h>



static Obj _SI_Types;    /* A kernel copy of a plain list of types */


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
    0, /* PYOBJECT */
    0 /* PYOBJECT */
};

int SingtoGAPType[MAX_TOK];

const int HasRingTable[] = {
    0, // NOTUSED
    0, // NOTUSED
    0, // SINGTYPE_BIGINT        = 2,
    0, // SINGTYPE_BIGINT_IMM    = 3,
    0, // SINGTYPE_BIGINTMAT     = 4,
    0, // SINGTYPE_BIGINTMAT_IMM = 5,
    0, // SINGTYPE_DEF           = 6,
    0, // SINGTYPE_DEF_IMM       = 7,
    1, // SINGTYPE_IDEAL         = 8,
    1, // SINGTYPE_IDEAL_IMM     = 9,
    0, // SINGTYPE_INT           = 10,
    0, // SINGTYPE_INT_IMM       = 11,
    0, // SINGTYPE_INTMAT        = 12,
    0, // SINGTYPE_INTMAT_IMM    = 13,
    0, // SINGTYPE_INTVEC        = 14,
    0, // SINGTYPE_INTVEC_IMM    = 15,
    0, // SINGTYPE_LINK          = 16,
    0, // SINGTYPE_LINK_IMM      = 17,
    1, // SINGTYPE_LIST          = 18,
    1, // SINGTYPE_LIST_IMM      = 19,
    1, // SINGTYPE_MAP           = 20,
    1, // SINGTYPE_MAP_IMM       = 21,
    1, // SINGTYPE_MATRIX        = 22,
    1, // SINGTYPE_MATRIX_IMM    = 23,
    1, // SINGTYPE_MODULE        = 24,
    1, // SINGTYPE_MODULE_IMM    = 25,
    1, // SINGTYPE_NUMBER        = 26,
    1, // SINGTYPE_NUMBER_IMM    = 27,
    0, // SINGTYPE_PACKAGE       = 28,
    0, // SINGTYPE_PACKAGE_IMM   = 29,
    1, // SINGTYPE_POLY          = 30,
    1, // SINGTYPE_POLY_IMM      = 31,
    0, // SINGTYPE_PROC          = 32,
    0, // SINGTYPE_PROC_IMM      = 33,
    0, // SINGTYPE_QRING         = 34,
    0, // SINGTYPE_QRING_IMM     = 35,
    1, // SINGTYPE_RESOLUTION    = 36,
    1, // SINGTYPE_RESOLUTION_IMM= 37,
    0, // SINGTYPE_RING          = 38,
    0, // SINGTYPE_RING_IMM      = 39,
    0, // SINGTYPE_STRING        = 40,
    0, // SINGTYPE_STRING_IMM    = 41,
    1, // SINGTYPE_VECTOR        = 42,
    1, // SINGTYPE_VECTOR_IMM    = 43,
    0, // SINGTYPE_USERDEF       = 44,
    0, // SINGTYPE_USERDEF_IMM   = 45,
    // TODO (?): cone
    // TODO (?): fan
    // TODO (?): polytope
    0, // SINGTYPE_PYOBJECT      = 46,
    0  // SINGTYPE_PYOBJECT_IMM  = 47,
    // TODO (?): reference
    // TODO (?): shared
};


void InitSingTypesFromKernel()
{
    Obj tmp;
    Int gvar;
    int i;
    for (i = SINGTYPE_BIGINT; i <= SINGTYPE_VECTOR; i += 2) {
        if (GAPtoSingType[i] >= MAX_TOK) {
            Pr("Singular types have changed unforeseen",0L,0L);
            exit(1);
        }
        SingtoGAPType[GAPtoSingType[i]] = i;
    }

    tmp = NEW_PREC(SINGTYPE_LASTNUMBER);
    AssPRec(tmp,RNamName("SINGTYPE_BIGINT"), INTOBJ_INT(SINGTYPE_BIGINT));
    AssPRec(tmp,RNamName("SINGTYPE_BIGINT_IMM"), INTOBJ_INT(SINGTYPE_BIGINT_IMM));
    AssPRec(tmp,RNamName("SINGTYPE_BIGINTMAT"), INTOBJ_INT(SINGTYPE_BIGINTMAT));
    AssPRec(tmp,RNamName("SINGTYPE_BIGINTMAT_IMM"), INTOBJ_INT(SINGTYPE_BIGINTMAT_IMM));
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
    // TODO (?): cone
    // TODO (?): fan
    // TODO (?): polytope
    AssPRec(tmp,RNamName("SINGTYPE_PYOBJECT"), INTOBJ_INT(SINGTYPE_PYOBJECT));
    AssPRec(tmp,RNamName("SINGTYPE_PYOBJECT_IMM"), INTOBJ_INT(SINGTYPE_PYOBJECT_IMM));
    // TODO (?): reference
    // TODO (?): shared
    gvar = GVarName("_SI_TYPENRS");
    MakeReadWriteGVar(gvar);
    AssGVar(gvar,tmp);
    MakeReadOnlyGVar(gvar);

    InitCopyGVar("_SI_Types", &_SI_Types);
}


// The following function returns the GAP type of an object with TNUM
// T_SINGULAR. A pointer to it is put into the dispatcher table in the
// GAP kernel.
Obj _SI_TypeObj(Obj o)
{
    return ELM_PLIST(_SI_Types,TYPE_SINGOBJ(o));
}
