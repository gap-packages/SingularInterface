//////////////////////////////////////////////////////////////////////////////
/**
@file cxxfuncs.cc
This file contains all of the code that deals with C++ libraries.
**/
//////////////////////////////////////////////////////////////////////////////

// Include gmp.h *before* libsing.h, because it detects when compiled from C++
// and then does some things differently, which would cause an error if
// called from within extern "C". But libsing.h (indirectly) includes gmp.h ...
#include <gmp.h>

extern "C" 
{
  #include "libsing.h"

  // HACK: Workaround #2 for version of GAP before 2011-11-16:
  // export AInvInt to global namespace
  Obj AInvInt ( Obj gmp );
}

// Prevent inline code from using tests which are not in libsingular:
#define NDEBUG 1
#define OM_NDEBUG 1

#include <string>
#include <libsingular.h>
// To be removed later on:  (FIXME)
#include <singular/lists.h>
#include <singular/syz.h>

/// The C++ Standard Library namespace
using namespace std;


// Some convenience for C++:

inline ring SINGRING_SINGOBJ( Obj obj )
{
    return (ring) CXX_SINGOBJ(ELM_PLIST( SingularRings, RING_SINGOBJ(obj)));
}

inline ring GET_SINGRING(UInt rnr)
{
    return (ring) CXX_SINGOBJ(ELM_PLIST( SingularRings, rnr ));
}


// The following should be in rational.h but isn't:
#define NUM_RAT(rat)    ADDR_OBJ(rat)[0]
#define DEN_RAT(rat)    ADDR_OBJ(rat)[1]

number NUMBER_FROM_GAP(Obj self, ring r, Obj n)
// This internal function converts a GAP number n into a coefficient
// number for the ring r. n can be an immediate integer, a GMP integer
// or a rational number. If anything goes wrong, NULL is returned.
{
    if (r != currRing) rChangeCurrRing(r);

    // First check if n is a small integer that fits into a machine word;
    // this is usually cheap to convert.
    // However, GAP uses (32-4)=28 bit integers on 32bit machines, and
    // (64-4)=60 bit integers on 64 bit machine; whereas Singular always
    // uses (32-4)=28 bit integers, even on 64 bit systems. So we have to
    // use different code in each case.
    if (IS_INTOBJ(n)) {
        Int i = INT_INTOBJ(n);
#ifdef SYS_IS_64_BIT
        if (i >= -0x80000000L && i < 0x80000000L)
            return n_Init(i,r);
#else
        return n_Init(i,r);
#endif
    }

    if (rField_is_Zp(r)) {
        // We are in characteristic p, so number is just an integer:
        if (IS_INTOBJ(n)) {
            return n_Init((int) (INT_INTOBJ(n) % rChar(r)),r);
        } 
        // Maybe allow for finite field elements here, but check
        // characteristic!
        ErrorQuit("Argument must be an immediate integer.\n",0L,0L);
        return NULL;  // never executed
    } else if (!rField_is_Q(r)) {
        // Other fields not yet supported
        ErrorQuit("GAP numbers over this field not yet implemented.\n",0L,0L);
        return NULL;  // never executed
    }
    // Here we know that the rationals are the coefficients:
    if (IS_INTOBJ(n)) {   // a GAP immediate integer
        Int i = INT_INTOBJ(n);
        // Does not fit into a Singular immediate integer, or else it would have
        // already been handled above.
        return nlRInit(i);
    } else if (TNUM_OBJ(n) == T_INTPOS || TNUM_OBJ(n) == T_INTNEG) {
        // n is a long GAP integer. Both GAP and Singular use GMP,
        // but GAP uses the low-level mpn API (where data is stored as an mp_limb_t array), whereas
        // Singular uses the high-level mpz API (using type mpz_t).
        number res = ALLOC_RNUMBER();
        UInt size = SIZE_INT(n);
        mpz_init2(res->z,size*GMP_NUMB_BITS);
        memcpy(res->z->_mp_d,ADDR_INT(n),sizeof(mp_limb_t)*size);
        res->z->_mp_size = (TNUM_OBJ(n) == T_INTPOS) ? (Int)size : - (Int)size;
        res->s = 3;  // indicates an integer
        return res;
    } else if (TNUM_OBJ(n) == T_RAT) {
        // n is a long GAP rational:
        number res = ALLOC_RNUMBER();
        res->s = 0;
        Obj nn = NUM_RAT(n);
        if (IS_INTOBJ(nn)) { // a GAP immediate integer
            Int i = INT_INTOBJ(nn);
            mpz_init_set_si(res->z,i);
        } else {
            UInt size = SIZE_INT(nn);
            mpz_init2(res->z,size*GMP_NUMB_BITS);
            memcpy(res->z->_mp_d,ADDR_INT(nn),sizeof(mp_limb_t)*size);
            res->z->_mp_size = (TNUM_OBJ(n) == T_INTPOS) 
                               ? (Int) size : - (Int)size;
        }
        nn = DEN_RAT(n);
        if (IS_INTOBJ(nn)) { // a GAP immediate integer
            Int i = INT_INTOBJ(nn);
            mpz_init_set_si(res->n,i);
        } else {
            UInt size = SIZE_INT(nn);
            mpz_init2(res->n,size*GMP_NUMB_BITS);
            memcpy(res->n->_mp_d,ADDR_INT(nn),sizeof(mp_limb_t)*size);
            res->n->_mp_size = (TNUM_OBJ(n) == T_INTPOS) 
                               ? (Int) size : - (Int)size;
        }
        return res;
    } else {
        ErrorQuit("Argument must be an integer or rational.\n",0L,0L);
        return NULL;  // never executed
    }
}

number BIGINT_FROM_GAP(Obj nr)
{
    number n;
    if (IS_INTOBJ(nr)) {   // a GAP immediate integer
        Int i = INT_INTOBJ(nr);
        if (i >= -268435456L && i < 268435456L)
            n = nlInit((int) i,NULL);
        else
            n = nlRInit(i);
    } else if (TNUM_OBJ(nr) == T_INTPOS || TNUM_OBJ(nr) == T_INTNEG) {
        // A long GAP integer
        n = ALLOC_RNUMBER();
        UInt size = SIZE_INT(nr);
        mpz_init2(n->z,size*GMP_NUMB_BITS);
        memcpy(n->z->_mp_d,ADDR_INT(nr),sizeof(mp_limb_t)*size);
        n->z->_mp_size = (TNUM_OBJ(nr) == T_INTPOS) ? (Int) size : - (Int)size;
        n->s = 3;  // indicates an integer
    } else {
        ErrorQuit("Argument must be an integer.\n",0L,0L);
    }
    return n;
}

int INT_FROM_GAP(Obj nr)
{
    if (IS_INTOBJ(nr)) {    // a GAP immediate integer
        Int i = INT_INTOBJ(nr);
#ifdef SYS_IS_64_BIT
        if (i < -1L << 31 || i >= 1L << 31) {
            ErrorQuit("Argument must be a 32-bit integer",0L,0L);
            return 0;
        }
#endif
        return (int) i;
    } else {   // a long GAP integer
        UInt size = SIZE_INT(nr);
        if (size * sizeof(mp_limb_t) > 4 ||
            (size == 1 && ADDR_INT(nr)[0] > (1L << 31)) ||
            (size == 1 && ADDR_INT(nr)[0] == (1L << 31) && 
             TNUM_OBJ(nr) == T_INTPOS)) {
            ErrorQuit("Argument must be a 32-bit integer",0L,0L);
            return 0;
        }
        return TNUM_OBJ(nr) == T_INTPOS ?
               (int) ADDR_INT(nr)[0] :
               -(int) ADDR_INT(nr)[0];
    }
}

static poly GET_poly(Obj o, UInt &rnr)
{
    if (ISSINGOBJ(SINGTYPE_POLY,o)) {
        rnr = RING_SINGOBJ(o);
        return (poly) CXX_SINGOBJ(o);
    } else if (TYPE_OBJ(o) == SingularProxiesType) {
        Obj ob = ELM_PLIST(o,1);
        if (ISSINGOBJ(SINGTYPE_IDEAL,ob)) {
            rnr = RING_SINGOBJ(ob);
            int index = INT_INTOBJ(ELM_PLIST(o,2));
            ideal id = (ideal) CXX_SINGOBJ(ob);
            if (index <= 0 || index > IDELEMS(id)) {
                ErrorQuit("ideal index out of range",0L,0L);
                return NULL;
            }
            return id->m[index-1];
        } else if (ISSINGOBJ(SINGTYPE_MATRIX,ob)) {
            rnr = RING_SINGOBJ(ob);
            int row = INT_INTOBJ(ELM_PLIST(o,2));
            int col = INT_INTOBJ(ELM_PLIST(o,3));
            matrix mat = (matrix) CXX_SINGOBJ(ob);
            if (row <= 0 || row > mat->nrows ||
                col <= 0 || col > mat->ncols) {
                ErrorQuit("matrix indices out of range",0L,0L);
                return NULL;
            }
            return MATELEM(mat,row,col);
        } else if (ISSINGOBJ(SINGTYPE_LIST,ob)) {
            rnr = RING_SINGOBJ(ob);
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
}

extern "C"
Obj FuncSingularRingWithoutOrdering(Obj self, Obj charact, Obj names)
{
    char **array;
    char *p;
    UInt nrvars = LEN_PLIST(names);
    UInt i;
    Obj tmp;
    
    array = (char **) omalloc(sizeof(char *) * nrvars);
    for (i = 0;i < nrvars;i++)
        array[i] = omStrDup(CSTR_STRING(ELM_PLIST(names,i+1)));

    ring r = rDefault(INT_INTOBJ(charact),nrvars,array);
    i = LEN_LIST(SingularRings)+1;
    tmp = NEW_SINGOBJ_RING(SINGTYPE_RING,r,i);
    ASS_LIST(SingularRings,i,tmp);
    ASS_LIST(SingularElCounts,i,INTOBJ_INT(0));
    return tmp;
}

extern "C" 
void SingularFreeFunc(Obj o)
{
    UInt type = TYPE_SINGOBJ(o);
    poly p;
    number n;
    ideal id;

    switch (type) {
        case SINGTYPE_RING:
            rKill( (ring) CXX_SINGOBJ(o) );
            // Pr("killed a ring\n",0L,0L);
            break;
        case SINGTYPE_POLY:
            p = (poly) CXX_SINGOBJ(o);
            p_Delete( &p, SINGRING_SINGOBJ(o) );
            DEC_REFCOUNT( RING_SINGOBJ(o) );
            // Pr("killed a ring element\n",0L,0L);
            break;
        case SINGTYPE_BIGINT:
            n = (number) CXX_SINGOBJ(o);
            nlDelete(&n,NULL);
            break;
        case SINGTYPE_IDEAL:
            id = (ideal) CXX_SINGOBJ(o);
            id_Delete(&id,SINGRING_SINGOBJ(o));
            DEC_REFCOUNT( RING_SINGOBJ(o) );
            break;
    }
}

extern "C"
void SingularObjMarkFunc(Bag o)
{
#if 0
    // Not necessary, since singular objects do not have GAP subobjects!
    Bag *ptr;
    Bag sub;
    UInt i;
    if (SIZE_BAG(o) > 2*sizeof(Bag)) {
        ptr = PTR_BAG(o);
        for (i = 2;i < SIZE_BAG(o)/sizeof(Bag);i++) {
            sub = ptr[i];
            MARK_BAG( sub );
        }
    }
#endif
}

extern "C"
Obj TypeSingularObj(Obj o)
{
    return ELM_PLIST(SingularTypes,TYPE_SINGOBJ(o));
}

extern "C"
Obj FuncIndeterminatesOfSingularRing(Obj self, Obj rr)
{
    Obj res;
    ring r = (ring) CXX_SINGOBJ(rr);
    UInt rnr = RING_SINGOBJ(rr);
    UInt nrvars = rVar(r);
    UInt i;
    Obj tmp;

    if (r != currRing) rChangeCurrRing(r);
        
    res = NEW_PLIST(T_PLIST_DENSE,nrvars);
    for (i = 1;i <= nrvars;i++) {
        poly p = p_ISet(1,r);
        pSetExp(p,i,1);
        pSetm(p);
        tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY,p,rnr);
        SET_ELM_PLIST(res,i,tmp);
        CHANGED_BAG(res);
    }
    SET_LEN_PLIST(res,nrvars);

    return res;
}

extern "C"
Obj FuncSI_MONOMIAL(Obj self, Obj rr, Obj coeff, Obj exps)
{
    ring r = (ring) CXX_SINGOBJ(rr);
    UInt rnr = RING_SINGOBJ(rr);
    UInt nrvars = rVar(r);
    UInt i;
    UInt len;
    if (r != currRing) rChangeCurrRing(r);
    poly p = p_NSet(NUMBER_FROM_GAP(self, r, coeff),r);
    if (p != NULL) {
        len = LEN_LIST(exps);
        if (len < nrvars) nrvars = len;
        for (i = 1;i <= nrvars;i++)
            pSetExp(p,i,INT_INTOBJ(ELM_LIST(exps,i)));
        pSetm(p);
    }
    Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY,p,rnr);
    return tmp;
}

extern "C"
Obj FuncSI_STRING_POLY(Obj self, Obj po)
{
    UInt rnr;
    poly p = GET_poly(po,rnr);
    ring r = GET_SINGRING(rnr);
    if (r != currRing) rChangeCurrRing(r);
    char *st = p_String(p,r);
    UInt len = (UInt) strlen(st);
    Obj tmp = NEW_STRING(len);
    SET_LEN_STRING(tmp,len);
    strcpy(reinterpret_cast<char*>(CHARS_STRING(tmp)),st);
    return tmp;
}

extern "C"
Obj FuncSI_COPY_POLY(Obj self, Obj po)
{
    UInt rnr;
    poly p = GET_poly(po,rnr);
    ring r = GET_SINGRING(rnr);
    if (r != currRing) rChangeCurrRing(r);  // necessary?
    p = p_Copy(p,r);
    Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY,p,rnr);
    return tmp;
}

extern "C"
Obj FuncSI_ADD_POLYS(Obj self, Obj a, Obj b)
{
    UInt ra,rb;
    poly aa = GET_poly(a,ra);
    poly bb = GET_poly(b,rb);
    if (ra != rb) ErrorQuit("Elements not over the same ring\n",0L,0L);
    ring r = GET_SINGRING(ra);
    if (r != currRing) rChangeCurrRing(r);  // necessary?
    aa = p_Copy(aa,r);
    bb = p_Copy(bb,r);
    aa = p_Add_q(aa,bb,r);
    Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY,aa,ra);
    return tmp;
}

extern "C"
Obj FuncSI_NEG_POLY(Obj self, Obj a)
{
    ring r = SINGRING_SINGOBJ(a);
    if (r != currRing) rChangeCurrRing(r);  // necessary?
    poly aa = p_Copy((poly) CXX_SINGOBJ(a),r);
    aa = p_Neg(aa,r);
    Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY,aa,RING_SINGOBJ(a));
    return tmp;
}

extern "C"
Obj FuncSI_MULT_POLYS(Obj self, Obj a, Obj b)
{
    if (RING_SINGOBJ(a) != RING_SINGOBJ(b))
        ErrorQuit("Elements not over the same ring\n",0L,0L);
    ring r = SINGRING_SINGOBJ(a);
    if (r != currRing) rChangeCurrRing(r);   // necessary?
    poly aa = pp_Mult_qq((poly) CXX_SINGOBJ(a),(poly) CXX_SINGOBJ(b),r);
    Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY,aa,RING_SINGOBJ(a));
    return tmp;
}

extern "C"
Obj FuncSI_MULT_POLY_NUMBER(Obj self, Obj a, Obj b)
{
    ring r = SINGRING_SINGOBJ(a);
    if (r != currRing) rChangeCurrRing(r);   // necessary?
    number bb = NUMBER_FROM_GAP(self,r,b);
    poly aa = pp_Mult_nn((poly) CXX_SINGOBJ(a),bb,r);
    n_Delete(&bb,r);
    Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY,aa,RING_SINGOBJ(a));
    return tmp;
}

extern "C"
Obj FuncSI_INIT_INTERPRETER(Obj self, Obj path)
{
    // init path names etc.
    siInit(reinterpret_cast<char*>(CHARS_STRING(path)));
    currentVoice=feInitStdin(NULL);
}

char *LastSingularOutput = NULL;

extern "C"
Obj FuncLastSingularOutput(Obj self)
{
    if (LastSingularOutput) {
        UInt len = (UInt) strlen(LastSingularOutput);
        Obj tmp = NEW_STRING(len);
        SET_LEN_STRING(tmp,len);
        strcpy(reinterpret_cast<char*>(CHARS_STRING(tmp)),LastSingularOutput);
        omFree(LastSingularOutput);
        LastSingularOutput = NULL;
        return tmp;
    } else return Fail;
}

extern int inerror;

extern "C"
void SingularErrorCallback(const char *st)
{
    UInt len = (UInt) strlen(st);
    if (IS_STRING(SingularErrors)) {
        char *p;
        UInt oldlen = GET_LEN_STRING(SingularErrors);
        GROW_STRING(SingularErrors,oldlen+len+2);
        p = CSTR_STRING(SingularErrors);
        memcpy(p+oldlen,st,len);
        p[oldlen+len] = '\n';
        p[oldlen+len+1] = 0;
        SET_LEN_STRING(SingularErrors,oldlen+len+1);
    }
}

extern "C"
Obj FuncSI_EVALUATE(Obj self, Obj st)
{
    UInt len = GET_LEN_STRING(st);
    char *ost = (char *) omalloc((size_t) len + 10);
    memcpy(ost,reinterpret_cast<char*>(CHARS_STRING(st)),len);
    memcpy(ost+len,"return();",10);
    if (LastSingularOutput) {
        omFree(LastSingularOutput);
        LastSingularOutput = NULL;
    }
    SPrintStart();
    myynest = 1;
    WerrorS_callback = SingularErrorCallback;
    Int err = (Int) iiAllStart(NULL,ost,BT_proc,0);
    inerror = 0;
    errorreported = 0;
    LastSingularOutput = SPrintEnd();
    // Note that iiEStart uses omFree internally to free the string ost
    return ObjInt_Int((Int) err);
}

extern "C"
Obj FuncValueOfSingularVar(Obj self, Obj name)
{
    UInt len;
    Obj tmp,tmp2;
    intvec *v;
    int i,j,k;
    UInt rows, cols;
    number n;

    idhdl h = ggetid(reinterpret_cast<char*>(CHARS_STRING(name)));
    if (h == NULL) return Fail;
    switch (IDTYP(h)) {
        case INT_CMD:
            return ObjInt_Int( (Int) (IDINT(h)) );
        case STRING_CMD:
            len = (UInt) strlen(IDSTRING(h));
            tmp = NEW_STRING(len);
            SET_LEN_STRING(tmp,len);
            strcpy(reinterpret_cast<char*>(CHARS_STRING(tmp)),IDSTRING(h));
            return tmp;
        case INTVEC_CMD:
            v = IDINTVEC(h);
            len = (UInt) v->length();
            tmp = NEW_PLIST(T_PLIST_CYC,len);
            SET_LEN_PLIST(tmp,len);
            for (i = 0; i < len;i++) {
                SET_ELM_PLIST(tmp,i+1,ObjInt_Int( (Int) ((*v)[i]) ));
                CHANGED_BAG(tmp); // ObjInt_Int can trigger garbage collections
            }
            return tmp;
        case INTMAT_CMD:
            v = IDINTVEC(h);
            rows = (UInt) v->rows();
            cols = (UInt) v->cols();
            tmp = NEW_PLIST(T_PLIST_DENSE,rows);
            SET_LEN_PLIST(tmp,rows);
            k = 0;
            for (i = 0; i < rows;i++) {
                tmp2 = NEW_PLIST(T_PLIST_CYC,cols);
                SET_LEN_PLIST(tmp2,cols);
                SET_ELM_PLIST(tmp,i+1,tmp2);
                CHANGED_BAG(tmp); // ObjInt_Int can trigger garbage collections
                for (j = 0; j < cols;j++) {
                    SET_ELM_PLIST(tmp2,j+1,ObjInt_Int( (Int) ((*v)[k++])));
                    CHANGED_BAG(tmp2);
                }
            }
            return tmp;
        case BIGINT_CMD:
            n = IDBIGINT(h);
            return Fail;
        default:
            return Fail;
    }
}

Obj FuncSI_bigint(Obj self, Obj nr)
{
    return NEW_SINGOBJ(SINGTYPE_BIGINT,BIGINT_FROM_GAP(nr));
}

Obj FuncSI_Intbigint(Obj self, Obj nr)
{
    number n = (number) CXX_SINGOBJ(nr);
    Obj res;
    if (SR_HDL(n) & SR_INT) {
        // an immediate integer
        return INTOBJ_INT(SR_TO_INT(n));
    } else {
        Int size = n->z->_mp_size;
        int sign = size > 0 ? 1 : -1;
        size = abs(size);
#ifdef SYS_IS_64_BIT
        if (size == 1) {
            if (sign > 0)
                return ObjInt_UInt(n->z->_mp_d[0]);
            else
                return AInvInt(ObjInt_UInt(n->z->_mp_d[0]));
        }
#endif
        if (sign > 0)
            res = NewBag(T_INTPOS,sizeof(mp_limb_t)*size);
        else
            res = NewBag(T_INTNEG,sizeof(mp_limb_t)*size);
        memcpy(ADDR_INT(res),n->z->_mp_d,sizeof(mp_limb_t)*size);
        return res;
    }             
}

Obj FuncSI_intvec(Obj self, Obj l)
{
    if (!IS_LIST(l)) {
        ErrorQuit("l must be a list",0L,0L);
        return Fail;
    }
    UInt len = LEN_LIST(l);
    UInt i;
    intvec *iv = new intvec(len);
    for (i = 1;i <= len;i++) {
        Obj t = ELM_LIST(l,i);
        if (!IS_INTOBJ(t)
#ifdef SYS_IS_64_BIT
            || (INT_INTOBJ(t) < -(1L << 31) || INT_INTOBJ(t) >= (1L << 31))
#endif
           ) {
            delete iv;
            ErrorQuit("l must contain small integers", 0L, 0L);
        }
        (*iv)[i-1] = (int) (INT_INTOBJ(t));
    }
    return NEW_SINGOBJ(SINGTYPE_INTVEC,iv);
}

Obj FuncSI_Plistintvec(Obj self, Obj iv)
{
    if (! (TNUM_OBJ(iv) == T_SINGULAR && 
           TYPE_SINGOBJ(iv) == SINGTYPE_INTVEC) ) {
        ErrorQuit("iv must be a singular intvec", 0L, 0L);
        return Fail;
    }
    intvec *i = (intvec *) CXX_SINGOBJ(iv);
    UInt len = i->length();
    Obj ret = NEW_PLIST(T_PLIST_CYC,len);
    UInt j;
    for (j = 1;j <= len;j++) {
        SET_ELM_PLIST(ret,j,ObjInt_Int( (Int) ((*i)[j-1])));
        CHANGED_BAG(ret);
    }
    SET_LEN_PLIST(ret,len);
    return ret;
}

Obj FuncSI_intmat(Obj self, Obj m)
{
    if (! (IS_LIST(m) && LEN_LIST(m) > 0 && 
           IS_LIST(ELM_LIST(m,1)) && LEN_LIST(ELM_LIST(m,1)) > 0)) {
        ErrorQuit("m must be a list of lists",0L,0L);
        return Fail;
    }
    UInt rows = LEN_LIST(m);
    UInt cols = LEN_LIST(ELM_LIST(m,1));
    UInt r,c;
    Obj therow;
    intvec *iv = new intvec(rows,cols,0);
    for (r = 1;r <= rows;r++) {
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
    return NEW_SINGOBJ(SINGTYPE_INTMAT,iv);
}

Obj FuncSI_Matintmat(Obj self, Obj im)
{
    if (! (TNUM_OBJ(im) == T_SINGULAR && 
           TYPE_SINGOBJ(im) == SINGTYPE_INTMAT) ) {
        ErrorQuit("im must be a singular intmat", 0L, 0L);
        return Fail;
    }
    intvec *i = (intvec *) CXX_SINGOBJ(im);
    UInt rows = i->rows();
    UInt cols = i->cols();
    Obj ret = NEW_PLIST(T_PLIST_DENSE,rows);
    SET_LEN_PLIST(ret,rows);
    UInt r,c;
    for (r = 1;r <= rows;r++) {
        Obj tmp;
        tmp = NEW_PLIST(T_PLIST_CYC,cols);
        SET_ELM_PLIST(ret,r,tmp);
        CHANGED_BAG(ret);
        for (c = 1;c <= cols;c++) {
            SET_ELM_PLIST(tmp,c,ObjInt_Int(IMATELEM(*i,r,c)));
            CHANGED_BAG(tmp);
        }
        SET_LEN_PLIST(tmp,cols);
    }
    return ret;
}

Obj FuncSI_ideal(Obj self, Obj l)
{
    if (!IS_LIST(l)) {
        ErrorQuit("l must be a list",0L,0L);
        return Fail;
    }
    UInt len = LEN_LIST(l);
    if (len == 0) {
        ErrorQuit("l must contain at least one element",0L,0L);
        return Fail;
    }
    ideal id;
    UInt i;
    Obj t;
    ring r,r2;
    for (i = 1;i <= len;i++) {
        t = ELM_LIST(l,i);
        if (!ISSINGOBJ(SINGTYPE_POLY,t)) {
            if (i > 1) id_Delete(&id,r);
            ErrorQuit("l must only contain singular polynomials",0L,0L);
            return Fail;
        }
        if (i == 1) {
            r = SINGRING_SINGOBJ(t);
            if (r != currRing) rChangeCurrRing(r);
            id = idInit(len,1);
        } else {
            if (r != SINGRING_SINGOBJ(t)) {
                id_Delete(&id,r);
                ErrorQuit("all elements of l must have the same ring",0L,0L);
                return Fail;
            }
        }
        poly p = p_Copy((poly) CXX_SINGOBJ(t),r);
        id->m[i-1] = p;
    }
    return NEW_SINGOBJ_RING(SINGTYPE_IDEAL,id,RING_SINGOBJ(t));
}

static inline poly GET_IDEAL_ELM_PROXY_NC(Obj p)
{
    Obj id = ELM_PLIST(p,1);
    ideal ide = (ideal) CXX_SINGOBJ(id);
    return ide->m[INT_INTOBJ(ELM_PLIST(p,2))-1];
}

static poly GET_IDEAL_ELM_PROXY(Obj p)
{
    if (TYPE_OBJ(p) != SingularProxiesType) {
        ErrorQuit("p must be a singular proxy object",0L,0L);
        return NULL;
    }
    Obj id = ELM_PLIST(p,1);
    /*...*/
    ideal ide = (ideal) CXX_SINGOBJ(id);
    return ide->m[INT_INTOBJ(ELM_PLIST(p,2))-1];
}

void *GET_SINGOBJ(Obj input, int &type, UInt &rnr, ring &r)
{
    rnr = 0;
    if (IS_INTOBJ(input) || 
        TNUM_OBJ(input) == T_INTPOS || TNUM_OBJ(input) == T_INTNEG) {
        type = INT_CMD;
        return (void *) (INT_FROM_GAP(input));
    }
    if (TNUM_OBJ(input) == T_SINGULAR) {
        switch (TYPE_SINGOBJ(input)) {
          case SINGTYPE_BIGINT:
            type = BIGINT_CMD;
            return nlCopy((number) CXX_SINGOBJ(input));
          case SINGTYPE_IDEAL:
            type = IDEAL_CMD;
            rnr = RING_SINGOBJ(input);
            r = GET_SINGRING(rnr);
            if (r != currRing) rChangeCurrRing(r);
            return id_Copy((ideal) CXX_SINGOBJ(input),SINGRING_SINGOBJ(input));
          case SINGTYPE_INTMAT:
            type = INTMAT_CMD;
            return new intvec((intvec *) CXX_SINGOBJ(input));
          case SINGTYPE_INTVEC:
            type = INTVEC_CMD;
            return new intvec((intvec *) CXX_SINGOBJ(input));
          case SINGTYPE_LINK:
            type = LINK_CMD;
            return CXX_SINGOBJ(input);
          case SINGTYPE_LIST:
            type = LIST_CMD;
            rnr = RING_SINGOBJ(input);
            r = GET_SINGRING(rnr);
            if (r != currRing) rChangeCurrRing(r);
            return lCopy( (lists) CXX_SINGOBJ(input) );
          case SINGTYPE_MAP:
            type = MAP_CMD;
            rnr = RING_SINGOBJ(input);
            r = GET_SINGRING(rnr);
            if (r != currRing) rChangeCurrRing(r);
            return maCopy( (map) CXX_SINGOBJ(input) );
          case SINGTYPE_MATRIX:
            type = MATRIX_CMD;
            rnr = RING_SINGOBJ(input);
            r = GET_SINGRING(rnr);
            if (r != currRing) rChangeCurrRing(r);
            return mpCopy( (matrix) CXX_SINGOBJ(input) );
          case SINGTYPE_MODULE:
            type = MODUL_CMD;
            rnr = RING_SINGOBJ(input);
            r = GET_SINGRING(rnr);
            if (r != currRing) rChangeCurrRing(r);
            return id_Copy((ideal) CXX_SINGOBJ(input),SINGRING_SINGOBJ(input));
          case SINGTYPE_NUMBER:
            type = NUMBER_CMD;
            rnr = RING_SINGOBJ(input);
            r = GET_SINGRING(rnr);
            if (r != currRing) rChangeCurrRing(r);
            return n_Copy((number)CXX_SINGOBJ(input),SINGRING_SINGOBJ(input));
          case SINGTYPE_POLY:
            type = POLY_CMD;
            rnr = RING_SINGOBJ(input);
            r = GET_SINGRING(rnr);
            if (r != currRing) rChangeCurrRing(r);
            return p_Copy((poly) CXX_SINGOBJ(input),SINGRING_SINGOBJ(input));
          case SINGTYPE_QRING:
            type = QRING_CMD;
            return CXX_SINGOBJ(input);
          case SINGTYPE_RESOLUTION:
            type = RESOLUTION_CMD;
            rnr = RING_SINGOBJ(input);
            r = GET_SINGRING(rnr);
            if (r != currRing) rChangeCurrRing(r);
            return syCopy((syStrategy) CXX_SINGOBJ(input));
          case SINGTYPE_RING:
            type = RING_CMD;
            return CXX_SINGOBJ(input);
          case SINGTYPE_STRING:
            type = STRING_CMD;
            return omStrDup( (char *) CXX_SINGOBJ(input));
          case SINGTYPE_VECTOR:
            type = VECTOR_CMD;
            rnr = RING_SINGOBJ(input);
            r = GET_SINGRING(rnr);
            if (r != currRing) rChangeCurrRing(r);
            return p_Copy((poly) CXX_SINGOBJ(input),SINGRING_SINGOBJ(input));
        }
    } else if (IS_POSOBJ(input) && TYPE_OBJ(input) == SingularProxiesType) {
        ErrorQuit("Argument to Singular call is no valid singular object",
                  0L,0L);
    } else {
        ErrorQuit("Argument to Singular call is no valid singular object",
                  0L,0L);
    }
}


#if 0
static int TypeTable[] =
  { 0, BIGINT_CMD, 0, IDEAL_CMD, INT_CMD, INTMAT_CMD, INTVEC_CMD, LINK_CMD,
    LIST_CMD, MAP_CMD, MATRIX_CMD, MODUL_CMD, NUMBER_CMD, 0 /* PACKAGE */,
    POLY_CMD, 0 /* PROC */, QRING_CMD, RESOLUTION_CMD, RING_CMD, STRING_CMD,
    VECTOR_CMD, 0 /* USERDEF */, 0 /* PYOBJECT */ };
#endif

leftv WRAP_SINGULAR(void *singobj, int type)
{
    leftv res = (leftv) omAlloc0(sizeof(sleftv));
    res->rtyp = type;
    res->data = singobj;
    return res;
}

Obj UNWRAP_SINGULAR(leftv singres, UInt rnr, ring r)
{
    Obj result;

    switch (singres->Typ()) {
      case NONE:
        return True;
      case INT_CMD:
        return ObjInt_Int((int) (singres->Data()));
      case NUMBER_CMD:
        return NEW_SINGOBJ_RING(SINGTYPE_NUMBER,singres->Data(),rnr);
      case POLY_CMD:
        return NEW_SINGOBJ_RING(SINGTYPE_POLY,singres->Data(),rnr);
      case INTVEC_CMD:
        return NEW_SINGOBJ(SINGTYPE_INTVEC,singres->Data());
      case INTMAT_CMD:
        return NEW_SINGOBJ(SINGTYPE_INTMAT,singres->Data());
      case VECTOR_CMD:
        return NEW_SINGOBJ_RING(SINGTYPE_VECTOR,singres->Data(),rnr);
      case IDEAL_CMD:
        return NEW_SINGOBJ_RING(SINGTYPE_IDEAL,singres->Data(),rnr);
      case BIGINT_CMD:
        return NEW_SINGOBJ(SINGTYPE_BIGINT,singres->Data());
      case MATRIX_CMD:
        return NEW_SINGOBJ_RING(SINGTYPE_MATRIX,singres->Data(),rnr);
      case LIST_CMD:
        return NEW_SINGOBJ_RING(SINGTYPE_LIST,singres->Data(),rnr);
      case LINK_CMD:
        return NEW_SINGOBJ(SINGTYPE_LINK,singres->Data());
      case RING_CMD:
        return NEW_SINGOBJ(SINGTYPE_RING,singres->Data());
      case QRING_CMD:
        return NEW_SINGOBJ(SINGTYPE_QRING,singres->Data());
      case RESOLUTION_CMD:
        return NEW_SINGOBJ_RING(SINGTYPE_RESOLUTION,singres->Data(),rnr);
      case STRING_CMD:
        return NEW_SINGOBJ(SINGTYPE_STRING,singres->Data());
      case MAP_CMD:
        return NEW_SINGOBJ_RING(SINGTYPE_MAP,singres->Data(),rnr);
      case MODUL_CMD:
        return NEW_SINGOBJ_RING(SINGTYPE_MODULE,singres->Data(),rnr);
      default:
        singres->CleanUp(r);
        return False;
    }
}

Obj FuncSI_CallFunc1(Obj self, Obj op, Obj input)
{
    int type;  /* Singular type like INT_CMD */
    UInt rnr;
    ring r;
    void *sing = GET_SINGOBJ(input,type,rnr,r);
    leftv singint = WRAP_SINGULAR(sing,type);
    leftv singres = (leftv) omAlloc0(sizeof(sleftv));
    BOOLEAN ret = iiExprArith1(singres,singint,INT_INTOBJ(op));
    if (type != LINK_CMD && type != RING_CMD && type != QRING_CMD) 
        singint->CleanUp(r);
    omFree(singint);
    if (ret) {
        singres->CleanUp(r);
        omFree(singres);
        return Fail;
    }
    Obj result = UNWRAP_SINGULAR(singres,rnr,r);
    omFree(singres);
    return result;
}

