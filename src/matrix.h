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
