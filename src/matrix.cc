#include "matrix.h"
#include "singobj.h"

#include <coeffs/bigintmat.h>


/// Installed as SI_matrix method
Obj Func_SI_matrix_from_String(Obj self, Obj rr, Obj nrrows, Obj nrcols,
                               Obj st)
{
    if (!(IS_INTOBJ(nrrows) && IS_INTOBJ(nrcols) &&
          INT_INTOBJ(nrrows) > 0 && INT_INTOBJ(nrcols) > 0)) {
        ErrorQuit("nrrows and nrcols must be positive integers",0L,0L);
        return Fail;
    }
    Int c_nrrows = INT_INTOBJ(nrrows);
    Int c_nrcols = INT_INTOBJ(nrcols);
    if (!ISSINGOBJ(SINGTYPE_RING_IMM,rr)) {
        ErrorQuit("Argument rr must be a singular ring",0L,0L);
        return Fail;
    }
    if (!IS_STRING_REP(st)) {
        ErrorQuit("Argument st must be a string",0L,0L);
        return Fail;
    }
    ring r = (ring) CXX_SINGOBJ(rr);
    if (r != currRing) rChangeCurrRing(r);
    const char *p = CSTR_STRING(st);
    poly *polylist;
    Int len = ParsePolyList(r, p, (int) (c_nrrows * c_nrrows), polylist);
    matrix mat = mpNew(c_nrrows,c_nrcols);
    Int i;
    Int row = 1;
    Int col = 1;
    for (i = 0; i < len && row <= c_nrrows; i++) {
        MATELEM(mat,row,col) = polylist[i];
        col++;
        if (col > c_nrcols) {
            col = 1;
            row++;
        }
    }
    omFree(polylist);
    return NEW_SINGOBJ_RING(SINGTYPE_MATRIX,mat,rr);
}

/// Installed as SI_bigintmat method
Obj Func_SI_bigintmat(Obj self, Obj m)
{
    // TODO: This function is untested! add test cases!!!
    if (! (IS_LIST(m) && LEN_LIST(m) > 0 &&
           IS_LIST(ELM_LIST(m,1)) && LEN_LIST(ELM_LIST(m,1)) > 0)) {
        ErrorQuit("m must be a list of lists",0L,0L);
        return Fail;
    }
    Int rows = LEN_LIST(m);
    Int cols = LEN_LIST(ELM_LIST(m,1));
    Int r,c;
    Obj therow;
    bigintmat *bim = new bigintmat(rows,cols,coeffs_BIGINT);
    for (r = 1; r <= rows; r++) {
        therow = ELM_LIST(m,r);
        if (! (IS_LIST(therow) && LEN_LIST(therow) == cols)) {
            delete bim;
            ErrorQuit("m must be a matrix",0L,0L);
            return Fail;
        }
        for (c = 1; c <= cols; c++) {
            Obj t = ELM_LIST(therow,c);
            if (! (IS_INTOBJ(t) || TNUM_OBJ(t) == T_INTPOS || TNUM_OBJ(t) == T_INTNEG)) {
                delete bim;
                ErrorQuit("m must contain integers", 0L, 0L);
            }
            BIMATELEM(*bim,r,c) = _SI_BIGINT_FROM_GAP(t);
        }
    }
    return NEW_SINGOBJ(SINGTYPE_BIGINTMAT_IMM,bim);
}

/// Used for bigintmat ViewString method.
// TODO: get rid of _SI_Matbigintmat and use SI_ToGAP instead ?
Obj Func_SI_Matbigintmat(Obj self, Obj im)
{
    // TODO: This function is untested! add test cases!!!
    if (!ISSINGOBJ(SINGTYPE_BIGINTMAT_IMM,im)) {
        ErrorQuit("im must be a singular bigintmat", 0L, 0L);
        return Fail;
    }
    bigintmat *bim = (bigintmat *) CXX_SINGOBJ(im);
    UInt rows = bim->rows();
    UInt cols = bim->cols();
    Obj ret = NEW_PLIST(T_PLIST_DENSE,rows);
    SET_LEN_PLIST(ret,rows);
    UInt r,c;
    for (r = 1; r <= rows; r++) {
        Obj tmp;
        tmp = NEW_PLIST(T_PLIST_CYC,cols);
        SET_ELM_PLIST(ret,r,tmp);
        CHANGED_BAG(ret);
        for (c = 1; c <= cols; c++) {
            number n = BIMATELEM(*bim,r,c);
            SET_ELM_PLIST(tmp,c,_SI_BIGINT_OR_INT_TO_GAP(n));
            CHANGED_BAG(tmp);
        }
        SET_LEN_PLIST(tmp,cols);
    }
    return ret;
}


/// Installed as SI_matrix method
Obj Func_SI_intmat(Obj self, Obj m)
{
    if (! (IS_LIST(m) && LEN_LIST(m) > 0 &&
           IS_LIST(ELM_LIST(m,1)) && LEN_LIST(ELM_LIST(m,1)) > 0)) {
        ErrorQuit("m must be a list of lists",0L,0L);
        return Fail;
    }
    Int rows = LEN_LIST(m);
    Int cols = LEN_LIST(ELM_LIST(m,1));
    Int r,c;
    Obj therow;
    intvec *iv = new intvec(rows,cols,0);
    for (r = 1; r <= rows; r++) {
        therow = ELM_LIST(m,r);
        if (! (IS_LIST(therow) && LEN_LIST(therow) == cols)) {
            delete iv;
            ErrorQuit("m must be a matrix",0L,0L);
            return Fail;
        }
        for (c = 1; c <= cols; c++) {
            Obj t = ELM_LIST(therow,c);
            if (!IS_INTOBJ(t)
#ifdef SYS_IS_64_BIT
                || (INT_INTOBJ(t) < -(1L << 31) || INT_INTOBJ(t) >= (1L << 31))
#endif
               ) {
                delete iv;
                ErrorQuit("m must contain small integers", 0L, 0L);
            }
            IMATELEM(*iv,r,c) = (int) (INT_INTOBJ(t));
        }
    }
    return NEW_SINGOBJ(SINGTYPE_INTMAT_IMM,iv);
}

/// Used for intmat ViewString method.
// TODO: get rid of _SI_Matintmat and use SI_ToGAP instead ?
Obj Func_SI_Matintmat(Obj self, Obj im)
{
    if (!(ISSINGOBJ(SINGTYPE_INTMAT_IMM,im) ||
          ISSINGOBJ(SINGTYPE_INTMAT,im))) {
        ErrorQuit("im must be a singular intmat", 0L, 0L);
        return Fail;
    }
    intvec *i = (intvec *) CXX_SINGOBJ(im);
    UInt rows = i->rows();
    UInt cols = i->cols();
    Obj ret = NEW_PLIST(T_PLIST_DENSE,rows);
    SET_LEN_PLIST(ret,rows);
    UInt r,c;
    for (r = 1; r <= rows; r++) {
        Obj tmp;
        tmp = NEW_PLIST(T_PLIST_CYC,cols);
        SET_ELM_PLIST(ret,r,tmp);
        CHANGED_BAG(ret);
        for (c = 1; c <= cols; c++) {
            SET_ELM_PLIST(tmp,c,ObjInt_Int(IMATELEM(*i,r,c)));
            CHANGED_BAG(tmp);
        }
        SET_LEN_PLIST(tmp,cols);
    }
    return ret;
}

/// Installed as SI_matrix method
Obj Func_SI_matrix_from_els(Obj self, Obj nrrows, Obj nrcols, Obj l)
{
    if (!(IS_INTOBJ(nrrows) && IS_INTOBJ(nrcols) &&
          INT_INTOBJ(nrrows) > 0 && INT_INTOBJ(nrcols) > 0)) {
        ErrorQuit("nrrows and nrcols must be positive integers",0L,0L);
        return Fail;
    }
    Int c_nrrows = INT_INTOBJ(nrrows);
    Int c_nrcols = INT_INTOBJ(nrcols);
    if (!IS_LIST(l)) {
        ErrorQuit("l must be a list",0L,0L);
        return Fail;
    }
    Int len = LEN_LIST(l);
    if (len == 0) {
        ErrorQuit("l must contain at least one element",0L,0L);
        return Fail;
    }
    matrix mat;
    Int i;
    Obj t = NULL;
    ring r = NULL;
    Int row = 1;
    Int col = 1;
    for (i = 1; i <= len && row <= c_nrrows; i++) {
        t = ELM_LIST(l,i);
        if (!(ISSINGOBJ(SINGTYPE_POLY,t) || ISSINGOBJ(SINGTYPE_POLY_IMM,t))) {
            if (i > 1) id_Delete((ideal *) &mat,r);
            ErrorQuit("l must only contain singular polynomials",0L,0L);
            return Fail;
        }
        if (i == 1) {
            r = CXXRING_SINGOBJ(t);
            if (r != currRing) rChangeCurrRing(r);
            mat = mpNew(c_nrrows,c_nrcols);
        } else {
            if (r != CXXRING_SINGOBJ(t)) {
                id_Delete((ideal *) &mat,r);
                ErrorQuit("all elements of l must have the same ring",0L,0L);
                return Fail;
            }
        }
        poly p = p_Copy((poly) CXX_SINGOBJ(t),r);
        MATELEM(mat,row,col) = p;
        col++;
        if (col > c_nrcols) {
            col = 1;
            row++;
        }
    }
    return NEW_SINGOBJ_RING(SINGTYPE_MATRIX,mat,RING_SINGOBJ(t));
}
