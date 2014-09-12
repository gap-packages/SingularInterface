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
#include "number.h"

#include <coeffs/longrat.h>
#include <coeffs/bigintmat.h>
//#include <kernel/syz.h>
#include <Singular/ipid.h>
#include <Singular/lists.h>


/// This function returns the Singular object referenced by the proxy
/// object. This function implements the recursion needed for deeply
/// nested Singular objects. If anything goes wrong, error is set to a
/// message and NULL is returned.
/// \param[in] proxy is a GAP proxy object
/// \param[in] pos is a position in proxy, the first being 2
/// \param[in] current is a pointer to a Singular object
/// \param[in] currgtype is the GAP type of the Singular object current
void *FOLLOW_SUBOBJ(Obj proxy, int pos, void *current, int &currgtype,
                           const char *(&error))
{
    // To end the recursion:
    if ((UInt) pos >= SIZE_OBJ(proxy)/sizeof(UInt))
        return current;
    if (!IS_INTOBJ(ELM_PLIST(proxy,pos))) {
        error = "proxy index must be an immediate integer";
        return NULL;
    }

    switch (currgtype) {
        case SINGTYPE_IDEAL:
        case SINGTYPE_IDEAL_IMM: {
            Int index = INT_INTOBJ(ELM_PLIST(proxy,pos));
            ideal id = (ideal) current;
            if (index <= 0 || index > IDELEMS(id)) {
                error = "ideal index out of range";
                return NULL;
            }
            currgtype = SINGTYPE_POLY;
            return id->m[index-1];
        }
        case SINGTYPE_MATRIX:
        case SINGTYPE_MATRIX_IMM: {
            if ((UInt)pos+1 >= SIZE_OBJ(proxy)/sizeof(UInt) ||
                !IS_INTOBJ(ELM_PLIST(proxy,pos)) ||
                !IS_INTOBJ(ELM_PLIST(proxy,pos+1))) {
                error = "need two integer indices for matrix proxy element";
                return NULL;
            }
            Int row = INT_INTOBJ(ELM_PLIST(proxy,pos));
            Int col = INT_INTOBJ(ELM_PLIST(proxy,pos+1));
            matrix mat = (matrix) current;
            if (row <= 0 || row > mat->nrows ||
                col <= 0 || col > mat->ncols) {
                error = "matrix indices out of range";
                return NULL;
            }
            return MATELEM(mat,row,col);
        }
        case SINGTYPE_LIST:
        case SINGTYPE_LIST_IMM: {
            lists l = (lists) current;
            Int index = INT_INTOBJ(ELM_PLIST(proxy,pos));
            if (index <= 0 || index > l->nr+1 ) {
                error = "list index out of range";
                return NULL;
            }
            currgtype = SingtoGAPType[l->m[index-1].Typ()];
            current = l->m[index-1].Data();
            return FOLLOW_SUBOBJ(proxy,pos+1,current,currgtype,error);
        }
        case SINGTYPE_INTMAT:
        case SINGTYPE_INTMAT_IMM: {
            if ((UInt)pos+1 >= SIZE_OBJ(proxy)/sizeof(UInt) ||
                !IS_INTOBJ(ELM_PLIST(proxy,pos)) ||
                !IS_INTOBJ(ELM_PLIST(proxy,pos+1))) {
                error = "need two integer indices for intmat proxy element";
                return NULL;
            }
            Int row = INT_INTOBJ(ELM_PLIST(proxy,pos));
            Int col = INT_INTOBJ(ELM_PLIST(proxy,pos+1));
            intvec *mat = (intvec *) current;
            if (row <= 0 || row > mat->rows() ||
                col <= 0 || col > mat->cols()) {
                error = "intmat indices out of range";
                return NULL;
            }
            currgtype = SINGTYPE_INT_IMM;
            return (void *) (long) IMATELEM(*mat,row,col);
        }
        case SINGTYPE_INTVEC:
        case SINGTYPE_INTVEC_IMM: {
            if ((UInt)pos >= SIZE_OBJ(proxy)/sizeof(UInt) ||
                !IS_INTOBJ(ELM_PLIST(proxy,pos))) {
                error = "need an integer index for intvec proxy element";
                return NULL;
            }
            Int n = INT_INTOBJ(ELM_PLIST(proxy,pos));
            intvec *v = (intvec *) current;
            if (n <= 0 || n > v->length()) {
                error = "vector index out of range";
                return NULL;
            }
            currgtype = SINGTYPE_INT_IMM;
            return (void *) (long) (*v)[n-1];
        }
        case SINGTYPE_BIGINTMAT:
        case SINGTYPE_BIGINTMAT_IMM: {
            if ((UInt)pos+1 >= SIZE_OBJ(proxy)/sizeof(UInt) ||
                !IS_INTOBJ(ELM_PLIST(proxy,pos)) ||
                !IS_INTOBJ(ELM_PLIST(proxy,pos+1))) {
                error = "need two integer indices for bigintmat proxy element";
                return NULL;
            }
            Int row = INT_INTOBJ(ELM_PLIST(proxy,pos));
            Int col = INT_INTOBJ(ELM_PLIST(proxy,pos+1));
            bigintmat *mat = (bigintmat *) current;
            if (row <= 0 || row > mat->rows() ||
                col <= 0 || col > mat->cols()) {
                error = "bigintmat indices out of range";
                return NULL;
            }
            currgtype = SINGTYPE_BIGINT_IMM;
            return (void *) BIMATELEM(*mat,row,col);
        }
        default:
            error = "Singular object has no subobjects";
            return NULL;
    }
}

void SingObj::init(Obj input, ring &r)
{
    error = NULL;
    needcleanup = false;
    obj.Init();

    input = UnwrapHighlevelWrapper(input);

    if (IS_INTOBJ(input) ||
        TNUM_OBJ(input) == T_INTPOS || TNUM_OBJ(input) == T_INTNEG) {
        int gtype = _SI_BIGINT_OR_INT_FROM_GAP(input,obj);
        if (gtype != SINGTYPE_INT && gtype != SINGTYPE_INT_IMM) {
            needcleanup = true;
        }
    } else if (TNUM_OBJ(input) == T_STRING) {
        UInt len = GET_LEN_STRING(input);
        char *ost = (char *) omalloc((size_t) len + 1);
        memcpy(ost,reinterpret_cast<char*>(CHARS_STRING(input)),len);
        ost[len] = 0;
        obj.data = (void *) ost;
        obj.rtyp = STRING_CMD;
        needcleanup = true;
    } else if (TNUM_OBJ(input) == T_SINGULAR) {
        int gtype = TYPE_SINGOBJ(input);
        obj.data = CXX_SINGOBJ(input);
        obj.rtyp = GAPtoSingType[gtype];
        obj.flag = FLAGS_SINGOBJ(input);
        obj.attribute = (attr) ATTRIB_SINGOBJ(input);
        if (HasRingTable[gtype]) {
            r = (ring) CXXRING_SINGOBJ(input);
            if (r != currRing) rChangeCurrRing(r);
        } else if (/*  gtype == SINGTYPE_RING ||  */
                    gtype == SINGTYPE_RING_IMM ||
                    /* gtype == SINGTYPE_QRING ||  */
                    gtype == SINGTYPE_QRING_IMM) {
            r = (ring) CXX_SINGOBJ(input);
        }
    } else if (IS_POSOBJ(input) && TYPE_OBJ(input) == _SI_ProxiesType) {
        if (IS_INTOBJ(ELM_PLIST(input,2))) {
            // This is a proxy object for a subobject:
            Obj ob = ELM_PLIST(input,1);
            if (TNUM_OBJ(ob) != T_SINGULAR) {
                obj.Init();
                error = "proxy object does not refer to Singular object";
                return;
            }
            int gtype = TYPE_SINGOBJ(ob);
            if (HasRingTable[gtype] && CXXRING_SINGOBJ(ob) != 0) {
                r = (ring) CXXRING_SINGOBJ(ob);
                if (r != currRing) rChangeCurrRing(r);
            }
            obj.data = FOLLOW_SUBOBJ(input,2,CXX_SINGOBJ(ob),gtype,error);
            obj.rtyp = GAPtoSingType[gtype];
        } else if (IS_STRING_REP(ELM_PLIST(input,2))) {
            // This is a proxy object for an interpreter variable
            obj.Init();
            error = "proxy objects to Singular interpreter variables are not yet implemented";
        } else {
            obj.Init();
            error = "unknown Singular proxy object";
        }
    } else {
        obj.Init();
        error = "Argument to Singular call is no valid Singular object";
    }
}

leftv SingObj::destructiveuse(ring r)
{
    if (needcleanup) {
        // already was a copy, do nothing except making sure cleanup()
        // won't free it later on.
        needcleanup = false;
        return &obj;
    }
    needcleanup = false;

    sleftv tmp = obj;
    if (r != currRing) rChangeCurrRing(r);
    obj.Copy(&tmp);
    return &obj;
}

void SingObj::cleanup()
{
    if (!needcleanup)
        return;
    needcleanup = false;

    // No need to worry about e.g. rings here; in fact, due to the way
    // init() works, at this point obj should be of type INT_CMD,
    // BIGINT_CMD or STRING_CMD.
    obj.CleanUp();
}

//! @}  end group CxxHelper

