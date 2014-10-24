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

#include "number.h"
#include "poly.h"

static poly _SI_GET_poly(Obj o, ring &r)
{
    if (ISSINGOBJ(SINGTYPE_POLY,o) || ISSINGOBJ(SINGTYPE_POLY_IMM,o)) {
        r = CXXRING_SINGOBJ(o);
        return (poly) CXX_SINGOBJ(o);
    } else if (TYPE_OBJ(o) == _SI_ProxiesType) {
        Obj ob = ELM_PLIST(o,1);
        if (ISSINGOBJ(SINGTYPE_IDEAL,ob) || ISSINGOBJ(SINGTYPE_IDEAL_IMM,ob)) {
            r = CXXRING_SINGOBJ(ob);
            int index = INT_INTOBJ(ELM_PLIST(o,2));
            ideal id = (ideal) CXX_SINGOBJ(ob);
            if (index <= 0 || index > IDELEMS(id)) {
                ErrorQuit("ideal index out of range",0L,0L);
                return NULL;
            }
            return id->m[index-1];
        } else if (ISSINGOBJ(SINGTYPE_MATRIX,ob) ||
                   ISSINGOBJ(SINGTYPE_MATRIX_IMM,ob)) {
            r = CXXRING_SINGOBJ(ob);
            int row = INT_INTOBJ(ELM_PLIST(o,2));
            int col = INT_INTOBJ(ELM_PLIST(o,3));
            matrix mat = (matrix) CXX_SINGOBJ(ob);
            if (row <= 0 || row > mat->nrows ||
                col <= 0 || col > mat->ncols) {
                ErrorQuit("matrix indices out of range",0L,0L);
                return NULL;
            }
            return MATELEM(mat,row,col);
        } else if (ISSINGOBJ(SINGTYPE_LIST,ob) ||
                   ISSINGOBJ(SINGTYPE_LIST_IMM,ob)) {
            r = CXXRING_SINGOBJ(ob);
            int index = INT_INTOBJ(ELM_PLIST(o,2));
            lists l = (lists) CXX_SINGOBJ(ob);
            if (index <= 0 || index > l->nr+1 ) {
                ErrorQuit("list index out of range",0L,0L);
                return NULL;
            }
            if (l->m[index-1].Typ() != POLY_CMD) {
                ErrorQuit("list entry is not a polynomial",0L,0L);
                return NULL;
            }
            return (poly) (l->m[index-1].Data());
        }
    } else {
        ErrorQuit("argument must be a singular polynomial (or proxy)",0L,0L);
        return NULL;
    }
    return NULL;   // To please the compiler
}

// TODO: _SI_MONOMIAL is only used by examples, do we still need it? For what?
Obj Func_SI_MONOMIAL(Obj self, Obj rr, Obj coeff, Obj exps)
{
    rr = UnwrapHighlevelWrapper(rr);
    if (!ISSINGOBJ(SINGTYPE_RING_IMM, rr)) {
        ErrorQuit("Argument rr must be a singular ring",0L,0L);
        return Fail;
    }

    ring r = (ring) CXX_SINGOBJ(rr);
    UInt nrvars = rVar(r);
    UInt i;
    UInt len;
    if (r != currRing) rChangeCurrRing(r);
    poly p = p_NSet(_SI_NUMBER_FROM_GAP(r, coeff),r);
    if (p != NULL) {
        len = LEN_LIST(exps);
        if (len < nrvars) nrvars = len;
        for (i = 1; i <= nrvars; i++)
            pSetExp(p,i,INT_INTOBJ(ELM_LIST(exps,i)));
        pSetm(p);
    }
    Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY, p, r);
    return tmp;
}

// TODO: _SI_COPY_POLY is only used by examples, do we still need it? For what?
Obj Func_SI_COPY_POLY(Obj self, Obj po)
{
    ring r = 0;
    poly p = _SI_GET_poly(po, r);
    if (r != currRing) rChangeCurrRing(r);  // necessary?
    p = p_Copy(p,r);
    Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY, p, r);
    return tmp;
}

// TODO: Remove this function, use _SI_pp_Mult_nn instead
// CAVEAT: One issue remains: _SI_MULT_POLY_NUMBER can take
// a GAP integer as second argument.
// But _SI_pp_Mult_nn currently cannot do that: It uses SingObj, which
// converts the GAP (GMP) int into a Singular 'bigint'.
// But pp_Mult_nn needs a Singular 'number'...
Obj Func_SI_MULT_POLY_NUMBER(Obj self, Obj a, Obj b)
{
    ring r = 0;
    poly p = _SI_GET_poly(a, r);
    if (r != currRing) rChangeCurrRing(r);   // necessary?
    number bb = _SI_NUMBER_FROM_GAP(r, b);
    poly aa = pp_Mult_nn(p, bb, r);
    n_Delete(&bb, r);
    Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY, aa, r);
    return tmp;
}

