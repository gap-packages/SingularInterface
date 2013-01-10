#include "libsing.h"
#include "singobj.h"


#ifdef WANT_SW
#include <coeffs/longrat.h>
#include <kernel/syz.h>
#include <Singular/ipid.h>
#include <Singular/libsingular.h>
#include <Singular/lists.h>
#else
// To be removed later on:  (FIXME)
#include <singular/lists.h>
#include <singular/syz.h>
#endif



Obj _SI_Types;    /* A kernel copy of a plain list of types */


// The following table maps GAP type numbers for singular objects to
// Singular type numbers for Singular objects:

const int GAPtoSingType[] =
  { 0, /* NOTUSED */
    0, /* VOID */
    BIGINT_CMD,
    BIGINT_CMD,
    DEF_CMD ,
    DEF_CMD ,
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
/* Also adjust Func_SI_INIT_INTERPRETER where this is initialised,
   when the set of types changes. */

const int HasRingTable[] =
  { 0, // NOTUSED
    0, // SINGTYPE_VOID          = 1
    0, // SINGTYPE_BIGINT        = 2,
    0, // SINGTYPE_BIGINT_IMM    = 3,
    0, // SINGTYPE_DEF           = 4,
    0, // SINGTYPE_DEF_IMM       = 5,
    1, // SINGTYPE_IDEAL         = 6,
    1, // SINGTYPE_IDEAL_IMM     = 7,
    0, // SINGTYPE_INT           = 8,
    0, // SINGTYPE_INT_IMM       = 9,
    0, // SINGTYPE_INTMAT        = 10,
    0, // SINGTYPE_INTMAT_IMM    = 11,
    0, // SINGTYPE_INTVEC        = 12,
    0, // SINGTYPE_INTVEC_IMM    = 13,
    0, // SINGTYPE_LINK          = 14,
    0, // SINGTYPE_LINK_IMM      = 15,
    1, // SINGTYPE_LIST          = 16,
    1, // SINGTYPE_LIST_IMM      = 17,
    1, // SINGTYPE_MAP           = 18,
    1, // SINGTYPE_MAP_IMM       = 19,
    1, // SINGTYPE_MATRIX        = 20,
    1, // SINGTYPE_MATRIX_IMM    = 21,
    1, // SINGTYPE_MODULE        = 22,
    1, // SINGTYPE_MODULE_IMM    = 23,
    1, // SINGTYPE_NUMBER        = 24,
    1, // SINGTYPE_NUMBER_IMM    = 25,
    0, // SINGTYPE_PACKAGE       = 26,
    0, // SINGTYPE_PACKAGE_IMM   = 27,
    1, // SINGTYPE_POLY          = 28,
    1, // SINGTYPE_POLY_IMM      = 29,
    0, // SINGTYPE_PROC          = 30,
    0, // SINGTYPE_PROC_IMM      = 31,
    0, // SINGTYPE_QRING         = 32,
    0, // SINGTYPE_QRING_IMM     = 33,
    1, // SINGTYPE_RESOLUTION    = 34,
    1, // SINGTYPE_RESOLUTION_IMM= 35,
    0, // SINGTYPE_RING          = 36,
    0, // SINGTYPE_RING_IMM      = 37,
    0, // SINGTYPE_STRING        = 38,
    0, // SINGTYPE_STRING_IMM    = 39,
    1, // SINGTYPE_VECTOR        = 40,
    1, // SINGTYPE_VECTOR_IMM    = 41,
    0, // SINGTYPE_USERDEF       = 42,
    0, // SINGTYPE_USERDEF_IMM   = 43,
    0, // SINGTYPE_PYOBJECT      = 44,
    0  // SINGTYPE_PYOBJECT_IMM  = 45,
  };


void InitSingTypesFromKernel()
{
  Obj tmp;
  Int gvar;

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
}


// The following function returns the GAP type of an object with TNUM
// T_SINGULAR. A pointer to it is put into the dispatcher table in the
// GAP kernel.
Obj _SI_TypeObj(Obj o)
{
    return ELM_PLIST(_SI_Types,TYPE_SINGOBJ(o));
}
