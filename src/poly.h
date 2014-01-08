#ifndef LIBSING_POLY_H
#define LIBSING_POLY_H

#include "libsing.h"

int ParsePolyList(ring r, const char *&st, int expected, poly *&res);

Obj Func_SI_poly_from_String(Obj self, Obj rr, Obj st);
Obj Func_SI_COPY_POLY(Obj self, Obj po);
Obj Func_SI_MULT_POLY_NUMBER(Obj self, Obj a, Obj b);

#endif
