// SingularInterface: A GAP interface to Singular
//
// Copyright of SingularInterface belongs to its developers.
// Please refer to the COPYRIGHT file for details.
//
// SPDX-License-Identifier: GPL-2.0-or-later

#ifndef SINGTYPES_H
#define SINGTYPES_H

extern "C" {
#include <src/compiled.h>
}

/* If you change these numbers, then also adjust the tables GAPtoSingType
 * and HasRingTable in cxxfuncs.cc! */
enum SingType {
    SINGTYPE_BIGINT = 2,
    SINGTYPE_BIGINT_IMM = 3,
    SINGTYPE_BIGINTMAT = 4,
    SINGTYPE_BIGINTMAT_IMM = 5,
    SINGTYPE_DEF = 6,
    SINGTYPE_DEF_IMM = 7,
    SINGTYPE_IDEAL = 8,
    SINGTYPE_IDEAL_IMM = 9,
    SINGTYPE_INT = 10,
    SINGTYPE_INT_IMM = 11,
    SINGTYPE_INTMAT = 12,
    SINGTYPE_INTMAT_IMM = 13,
    SINGTYPE_INTVEC = 14,
    SINGTYPE_INTVEC_IMM = 15,
    SINGTYPE_LINK = 16,
    SINGTYPE_LINK_IMM = 17,
    SINGTYPE_LIST = 18,
    SINGTYPE_LIST_IMM = 19,
    SINGTYPE_MAP = 20,
    SINGTYPE_MAP_IMM = 21,
    SINGTYPE_MATRIX = 22,
    SINGTYPE_MATRIX_IMM = 23,
    SINGTYPE_MODULE = 24,
    SINGTYPE_MODULE_IMM = 25,
    SINGTYPE_NUMBER = 26,
    SINGTYPE_NUMBER_IMM = 27,
    SINGTYPE_PACKAGE = 28,
    SINGTYPE_PACKAGE_IMM = 29,
    SINGTYPE_POLY = 30,
    SINGTYPE_POLY_IMM = 31,
    SINGTYPE_PROC = 32,
    SINGTYPE_PROC_IMM = 33,
    SINGTYPE_QRING = 34,
    SINGTYPE_QRING_IMM = 35,
    SINGTYPE_RESOLUTION = 36,
    SINGTYPE_RESOLUTION_IMM = 37,
    SINGTYPE_RING = 38,
    SINGTYPE_RING_IMM = 39,
    SINGTYPE_STRING = 40,
    SINGTYPE_STRING_IMM = 41,
    SINGTYPE_VECTOR = 42,
    SINGTYPE_VECTOR_IMM = 43,
    SINGTYPE_USERDEF = 44,
    SINGTYPE_USERDEF_IMM = 45,
    // TODO (?): reference
    // TODO (?): shared

    SINGTYPE_LASTNUMBER = 47
};


extern const int GAPtoSingType[];
extern int       SingtoGAPType[];
extern const int HasRingTable[];

extern void InitSingTypesFromKernel();

// The following function returns the GAP type of an object with TNUM
// T_SINGULAR. A pointer to it is put into the dispatcher table in the
// GAP kernel.
extern Obj _SI_TypeObj(Obj o);

#endif
