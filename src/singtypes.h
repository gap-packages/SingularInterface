#ifndef SINGTYPES_H
#define SINGTYPES_H

extern "C" {
  #include <src/compiled.h>
}

/* If you change these numbers, then also adjust the tables GAPtoSingType
 * and HasRingTable in cxxfuncs.cc! */
enum SingType {
    SINGTYPE_VOID          = 1,
    SINGTYPE_BIGINT        = 2,
    SINGTYPE_BIGINT_IMM    = 3,
    SINGTYPE_DEF           = 4,
    SINGTYPE_DEF_IMM       = 5,
    SINGTYPE_IDEAL         = 6,
    SINGTYPE_IDEAL_IMM     = 7,
    SINGTYPE_INT           = 8,
    SINGTYPE_INT_IMM       = 9,
    SINGTYPE_INTMAT        = 10,
    SINGTYPE_INTMAT_IMM    = 11,
    SINGTYPE_INTVEC        = 12,
    SINGTYPE_INTVEC_IMM    = 13,
    SINGTYPE_LINK          = 14,
    SINGTYPE_LINK_IMM      = 15,
    SINGTYPE_LIST          = 16,
    SINGTYPE_LIST_IMM      = 17,
    SINGTYPE_MAP           = 18,
    SINGTYPE_MAP_IMM       = 19,
    SINGTYPE_MATRIX        = 20,
    SINGTYPE_MATRIX_IMM    = 21,
    SINGTYPE_MODULE        = 22,
    SINGTYPE_MODULE_IMM    = 23,
    SINGTYPE_NUMBER        = 24,
    SINGTYPE_NUMBER_IMM    = 25,
    SINGTYPE_PACKAGE       = 26,
    SINGTYPE_PACKAGE_IMM   = 27,
    SINGTYPE_POLY          = 28,
    SINGTYPE_POLY_IMM      = 29,
    SINGTYPE_PROC          = 30,
    SINGTYPE_PROC_IMM      = 31,
    SINGTYPE_QRING         = 32,
    SINGTYPE_QRING_IMM     = 33,
    SINGTYPE_RESOLUTION    = 34,
    SINGTYPE_RESOLUTION_IMM= 35,
    SINGTYPE_RING          = 36,
    SINGTYPE_RING_IMM      = 37,
    SINGTYPE_STRING        = 38,
    SINGTYPE_STRING_IMM    = 39,
    SINGTYPE_VECTOR        = 40,
    SINGTYPE_VECTOR_IMM    = 41,
    SINGTYPE_USERDEF       = 42,
    SINGTYPE_USERDEF_IMM   = 43,
    SINGTYPE_PYOBJECT      = 44,
    SINGTYPE_PYOBJECT_IMM  = 45,

    SINGTYPE_LASTNUMBER    = 45
};


extern const int GAPtoSingType[];
extern int SingtoGAPType[];
extern const int HasRingTable[];

extern void InitSingTypesFromKernel();

// The following function returns the GAP type of an object with TNUM
// T_SINGULAR. A pointer to it is put into the dispatcher table in the
// GAP kernel.
extern Obj _SI_TypeObj(Obj o);

#endif
