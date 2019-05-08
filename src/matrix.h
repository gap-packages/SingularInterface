// SingularInterface: A GAP interface to Singular
//
// Copyright of SingularInterface belongs to its developers.
// Please refer to the COPYRIGHT file for details.
//
// SPDX-License-Identifier: GPL-2.0-or-later

#ifndef LIBSING_MATRIX_H
#define LIBSING_MATRIX_H

#include "libsing.h"

Obj Func_SI_bigintmat(Obj self, Obj m);
Obj Func_SI_Matbigintmat(Obj self, Obj im);
Obj Func_SI_intmat(Obj self, Obj m);
Obj Func_SI_Matintmat(Obj self, Obj im);
Obj Func_SI_matrix_from_els(Obj self, Obj nrrows, Obj nrcols, Obj l);
Obj Func_SI_MatElm(Obj self, Obj obj, Obj r, Obj c);
Obj Func_SI_SetMatElm(Obj self, Obj obj, Obj r, Obj c, Obj val);

#endif
