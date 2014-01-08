#include "poly.h"
#include "singobj.h"

static poly _SI_GET_poly(Obj o, Obj &rr)
{
    if (ISSINGOBJ(SINGTYPE_POLY,o) || ISSINGOBJ(SINGTYPE_POLY_IMM,o)) {
        rr = RING_SINGOBJ(o);
        return (poly) CXX_SINGOBJ(o);
    } else if (TYPE_OBJ(o) == _SI_ProxiesType) {
        Obj ob = ELM_PLIST(o,1);
        if (ISSINGOBJ(SINGTYPE_IDEAL,ob) || ISSINGOBJ(SINGTYPE_IDEAL_IMM,ob)) {
            rr = RING_SINGOBJ(ob);
            int index = INT_INTOBJ(ELM_PLIST(o,2));
            ideal id = (ideal) CXX_SINGOBJ(ob);
            if (index <= 0 || index > IDELEMS(id)) {
                ErrorQuit("ideal index out of range",0L,0L);
                return NULL;
            }
            return id->m[index-1];
        } else if (ISSINGOBJ(SINGTYPE_MATRIX,ob) ||
                   ISSINGOBJ(SINGTYPE_MATRIX_IMM,ob)) {
            rr = RING_SINGOBJ(ob);
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
            rr = RING_SINGOBJ(ob);
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

// Our constructors for polynomials:

static poly ParsePoly(ring r, const char *&st)
{
    poly p,q;
    const char *s;
    char *buf;
    p = NULL;
    bool neg;
    if (r != currRing) rChangeCurrRing(r);
    while (true) {
        while (*st == ' ') st++;
        if (*st == '-') {
            neg = true;
            st++;
            while (*st == ' ') st++;
        } else neg = false;
        s = st;
        while ((*s >= '0' && *s <= '9') ||
               (*s >= 'a' && *s <= 'z') ||
               (*s >= 'A' && *s <= 'Z')) s++;
        buf = (char *) omalloc( (s - st)+1 );
        strncpy(buf,st,s-st);
        buf[s-st] = 0;
        s = p_Read(buf,q,r);
        s = st + (s - buf);
        omFree(buf);
        if (s == st) return p;
        if (neg) q = p_Neg(q,r);
        p = p_Add_q(p,q,r);
        st = s;
        while (*st == ' ') st++;
        if (*st == '+') {
            st++;
            while (*st == ' ') st++;
        }
        if (*st == ',' || *st == 0) return p;
    }
}

/// Installed as SI_poly method
Obj Func_SI_poly_from_String(Obj self, Obj rr, Obj st)
// st a string or a list of lists or so...
{
    if (!ISSINGOBJ(SINGTYPE_RING_IMM,rr)) {
        ErrorQuit("Argument rr must be a singular ring",0L,0L);
        return Fail;
    }
    if (!IS_STRING_REP(st)) {
        ErrorQuit("Argument st must be a string",0L,0L);
        return Fail;
    }
    ring r = (ring) CXX_SINGOBJ(rr);
    const char *p = CSTR_STRING(st);
    poly q = ParsePoly(r,p);
    Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY,q,rr);
    return tmp;
}

int ParsePolyList(ring r, const char *&st, int expected, poly *&res)
{
    int alloc = expected;
    int len = 0;
    res = (poly *) omalloc(sizeof(poly) * alloc);
    poly *newres;
    poly newpoly;

    while (true) {
        newpoly = ParsePoly(r,st);
        if (len >= alloc) {
            alloc *= 2;
            newres = (poly *) omalloc(sizeof(poly) * alloc);
            memcpy(newres,res,sizeof(poly)*len);
            omFree(res);
            res = newres;
        }
        res[len++] = newpoly;
        if (*st != ',') return len;
        st++;
        while (*st == ' ') st++;
    }
}

// TODO: _SI_MONOMIAL is only used by examples, do we still need it? For what?
Obj Func_SI_MONOMIAL(Obj self, Obj rr, Obj coeff, Obj exps)
{
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
    Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY,p,rr);
    return tmp;
}

// TODO: _SI_COPY_POLY is only used by examples, do we still need it? For what?
Obj Func_SI_COPY_POLY(Obj self, Obj po)
{
    Obj rr = 0;
    poly p = _SI_GET_poly(po,rr);
    ring r = (ring) CXX_SINGOBJ(rr);
    if (r != currRing) rChangeCurrRing(r);  // necessary?
    p = p_Copy(p,r);
    Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY,p,rr);
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
    ring r = CXXRING_SINGOBJ(a);
    if (r != currRing) rChangeCurrRing(r);   // necessary?
    number bb = _SI_NUMBER_FROM_GAP(r,b);
    poly aa = pp_Mult_nn((poly) CXX_SINGOBJ(a),bb,r);
    n_Delete(&bb,r);
    Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY,aa,RING_SINGOBJ(a));
    return tmp;
}

