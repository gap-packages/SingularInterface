// SingularInterface: A GAP interface to Singular
//
// Copyright of SingularInterface belongs to its developers.
// Please refer to the COPYRIGHT file for details.
//
// SPDX-License-Identifier: GPL-2.0-or-later

#ifndef LIBSING_NUMBER_H
#define LIBSING_NUMBER_H

#include "libsing.h"

number _SI_NUMBER_FROM_GAP(ring r, Obj n);
number _SI_BIGINT_FROM_GAP(Obj nr);
int _SI_BIGINT_OR_INT_FROM_GAP(Obj nr, sleftv &obj);
Obj _SI_BIGINT_OR_INT_TO_GAP(number n);

#endif
