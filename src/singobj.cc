#include "libsing.h"
#include "singobj.h"

#include <coeffs/longrat.h>
#include <coeffs/bigintmat.h>
#include <kernel/syz.h>
#include <Singular/ipid.h>
#include <Singular/lists.h>


// The following should be in rational.h but isn't (as of GAP 4.7.2):
#ifndef NUM_RAT
#define NUM_RAT(rat)    ADDR_OBJ(rat)[0]
#define DEN_RAT(rat)    ADDR_OBJ(rat)[1]
#endif


//! \defgroup CxxHelper C++ helpers for converting between GAP and Singular
//! The following functions are helpers on the C++ level. They
//! are not exposed to the GAP level. They are mainly used to dig out
//! proper singular elements from their GAP wrappers or from real GAP
//! objects.
//! @{


static void _SI_GMP_FROM_GAP(Obj in, mpz_t out)
{
    UInt size = SIZE_INT(in);
    mpz_init2(out,size*GMP_NUMB_BITS);
    memcpy(out->_mp_d,ADDR_INT(in),sizeof(mp_limb_t)*size);
    out->_mp_size = (TNUM_OBJ(in) == T_INTPOS) ? (Int)size : - (Int)size;
}


/// This internal function converts a GAP number n into a coefficient
/// number for the ring r. n can be an immediate integer, a GMP integer
/// or a rational number. If anything goes wrong, NULL is returned.
number _SI_NUMBER_FROM_GAP(ring r, Obj n)
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
        if (i >= (-1L << 31) && i < (1L << 31))
            return n_Init(i,r);
#else
        return n_Init(i,r);
#endif
    }

    if (rField_is_Zp(r)) {
        if (IS_INTOBJ(n)) {
            return n_Init(INT_INTOBJ(n) % rChar(r), r);
        } else if (IS_FFE(n)) {
            FF ff = FLD_FFE(n);
            if (CHAR_FF(ff) != rChar(r) || DEGR_FF(ff) != 1)
                ErrorQuit("Argument is in wrong field.\n",0L,0L);
            return n_Init(VAL_FFE(n), r);
        } else if (TNUM_OBJ(n) == T_INTPOS || TNUM_OBJ(n) == T_INTNEG || TNUM_OBJ(n) == T_RAT) {
            n = MOD( n, INTOBJ_INT( rChar(r) ) );
            if (n != Fail && IS_INTOBJ(n)) {
                return n_Init(INT_INTOBJ(n) % rChar(r), r);
            }
        }
        ErrorQuit("Argument must be an integer, rational or finite prime field element.\n",0L,0L);
        return NULL;  // never executed
    } else if (!rField_is_Q(r)) {
        // Other fields not yet supported
        ErrorQuit("GAP numbers over this field not yet implemented.\n",0L,0L);
        return NULL;  // never executed
    }
    // Here we know that the rationals are the coefficients:
    if (IS_INTOBJ(n)) {   // a GAP immediate integer
        Int i = INT_INTOBJ(n);
        // Does not fit into a Singular immediate integer, or else it
        // would have already been handled above.
        return nlRInit(i);
    } else if (TNUM_OBJ(n) == T_INTPOS || TNUM_OBJ(n) == T_INTNEG) {
        // n is a long GAP integer. Both GAP and Singular use GMP, but
        // GAP uses the low-level mpn API (where data is stored as an
        // mp_limb_t array), whereas Singular uses the high-level mpz
        // API (using type mpz_t).
        number res = ALLOC_RNUMBER();
        _SI_GMP_FROM_GAP(n, res->z);
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
            _SI_GMP_FROM_GAP(nn, res->z);
        }
        nn = DEN_RAT(n);
        if (IS_INTOBJ(nn)) { // a GAP immediate integer
            Int i = INT_INTOBJ(nn);
            mpz_init_set_si(res->n,i);
        } else {
            _SI_GMP_FROM_GAP(nn, res->n);
        }
        return res;
    } else {
        ErrorQuit("Argument must be an integer or rational.\n",0L,0L);
        return NULL;  // never executed
    }
}

number _SI_BIGINT_FROM_GAP(Obj nr)
{
    number n = NULL;
    if (IS_INTOBJ(nr)) {   // a GAP immediate integer
        Int i = INT_INTOBJ(nr);
        if (i >= (-1L << 28) && i < (1L << 28))
            n = nlInit((int) i,NULL);
        else
            n = nlRInit(i);
    } else if (TNUM_OBJ(nr) == T_INTPOS || TNUM_OBJ(nr) == T_INTNEG) {
        // A long GAP integer
        n = ALLOC_RNUMBER();
        _SI_GMP_FROM_GAP(nr, n->z);
        n->s = 3;  // indicates an integer
    } else {
        ErrorQuit("Argument must be an integer.\n",0L,0L);
    }
    return n;
}


int _SI_BIGINT_OR_INT_FROM_GAP(Obj nr, sleftv &obj)
{
    number n;
    if (IS_INTOBJ(nr)) {    // a GAP immediate integer
        Int i = INT_INTOBJ(nr);
#ifdef SYS_IS_64_BIT
        if (i >= (-1L << 31) && i < (1L << 31)) {
#endif
            obj.data = (void *) i;
            obj.rtyp = INT_CMD;
            return SINGTYPE_INT_IMM;
#ifdef SYS_IS_64_BIT
        } else {
            n = nlRInit(i);
        }
#endif
    } else {   // a long GAP integer
        n = ALLOC_RNUMBER();
        _SI_GMP_FROM_GAP(nr, n->z);
        n->s = 3;  // indicates an integer
    }
    obj.data = n;
    obj.rtyp = BIGINT_CMD;
    return SINGTYPE_BIGINT_IMM;
}

Obj _SI_BIGINT_OR_INT_TO_GAP(number n)
{
    if (SR_HDL(n) & SR_INT) {
        // an immediate integer
        return INTOBJ_INT(SR_TO_INT(n));
    } else {
        Obj res;
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
            return (void *) (long) BIMATELEM(*mat,row,col);
        }
        default:
            error = "Singular object has no subobjects";
            return NULL;
    }
}

void SingObj::init(Obj input, Obj &extrr, ring &extr)
{
    error = NULL;
    r = NULL;
    rr = NULL;
    obj.Init();
    if (IS_INTOBJ(input) ||
        TNUM_OBJ(input) == T_INTPOS || TNUM_OBJ(input) == T_INTNEG) {
        gtype = _SI_BIGINT_OR_INT_FROM_GAP(input,obj);
        if (gtype == SINGTYPE_INT || gtype == SINGTYPE_INT_IMM) {
            needcleanup = false;
        } else {
            needcleanup = true;
        }
    } else if (TNUM_OBJ(input) == T_STRING) {
        UInt len = GET_LEN_STRING(input);
        char *ost = (char *) omalloc((size_t) len + 1);
        memcpy(ost,reinterpret_cast<char*>(CHARS_STRING(input)),len);
        ost[len] = 0;
        obj.data = (void *) ost;
        obj.rtyp = STRING_CMD;
        gtype = SINGTYPE_STRING;
        needcleanup = true;
    } else if (TNUM_OBJ(input) == T_SINGULAR) {
        gtype = TYPE_SINGOBJ(input);
        obj.data = CXX_SINGOBJ(input);
        obj.rtyp = GAPtoSingType[gtype];
        obj.flag = FLAGS_SINGOBJ(input);
        obj.attribute = (attr) ATTRIB_SINGOBJ(input);
        if (HasRingTable[gtype]) {
            rr = RING_SINGOBJ(input);
            r = (ring) CXXRING_SINGOBJ(input);
            extrr = rr;
            extr = r;
            if (r != currRing) rChangeCurrRing(r);
        } else if (/*  gtype == SINGTYPE_RING ||  */
                    gtype == SINGTYPE_RING_IMM ||
                    /* gtype == SINGTYPE_QRING ||  */
                    gtype == SINGTYPE_QRING_IMM) {
            extrr = input;
            extr = (ring) CXX_SINGOBJ(input);
        }
        needcleanup = false;
    } else if (IS_POSOBJ(input) && TYPE_OBJ(input) == _SI_ProxiesType) {
        if (IS_INTOBJ(ELM_PLIST(input,2))) {
            // This is a proxy object for a subobject:
            Obj ob = ELM_PLIST(input,1);
            if (TNUM_OBJ(ob) != T_SINGULAR) {
                obj.Init();
                needcleanup = false;
                gtype = 0;
                error = "proxy object does not refer to Singular object";
                return;
            }
            gtype = TYPE_SINGOBJ(ob);
            if (HasRingTable[gtype] && RING_SINGOBJ(ob) != 0) {
                rr = RING_SINGOBJ(ob);
                r = (ring) CXX_SINGOBJ(rr);
                extrr = rr;
                extr = r;
                if (r != currRing) rChangeCurrRing(r);
            }
            obj.data = FOLLOW_SUBOBJ(input,2,CXX_SINGOBJ(ob),gtype,error);
            obj.rtyp = GAPtoSingType[gtype];
            needcleanup = false;
        } else if (IS_STRING_REP(ELM_PLIST(input,2))) {
            // This is a proxy object for an interpreter variable
            obj.Init();
            error = "proxy objects to Singular interpreter variables are not yet implemented";
            needcleanup = false;
            gtype = 0;
        } else {
            obj.Init();
            error = "unknown Singular proxy object";
            needcleanup = false;
            gtype = 0;
        }
    } else {
        obj.Init();
        needcleanup = false;
        error = "Argument to Singular call is no valid Singular object";
        gtype = 0;
    }
}

/// Copies a singular object using the appropriate function according
/// to its type, unless it is a link, a qring or a ring, or unless it
/// is already a copy.
void SingObj::copy()
{
    ring ri;
    if (obj.attribute) obj.attribute = obj.attribute->Copy();

    switch (gtype) {
        case SINGTYPE_BIGINT:
        case SINGTYPE_BIGINT_IMM:
            obj.data = (void *) nlCopy((number) obj.data, coeffs_BIGINT);
            break;
        case SINGTYPE_BIGINTMAT:
        case SINGTYPE_BIGINTMAT_IMM:
            obj.data = (void *) new bigintmat((bigintmat *) obj.data);
            break;
        case SINGTYPE_IDEAL:
        case SINGTYPE_IDEAL_IMM:
            obj.data = (void *) id_Copy((ideal) obj.data,r);
            break;
        case SINGTYPE_INT:
        case SINGTYPE_INT_IMM:
            // do nothing and return immediately; do not set needcleanup to true
            return;
        case SINGTYPE_INTMAT:
        case SINGTYPE_INTMAT_IMM:
        case SINGTYPE_INTVEC:
        case SINGTYPE_INTVEC_IMM:
            obj.data = (void *) new intvec((intvec *) obj.data);
            break;
        case SINGTYPE_LINK:  // Do not copy here since it does not make sense
        case SINGTYPE_LINK_IMM:
            // do nothing and return immediately; do not set needcleanup to true
            return;
        case SINGTYPE_LIST:
        case SINGTYPE_LIST_IMM:
            obj.data = (void *) lCopy( (lists) obj.data );
            break;
        case SINGTYPE_MAP:
        case SINGTYPE_MAP_IMM:
            obj.data = (void *) maCopy( (map) obj.data,r);
            break;
        case SINGTYPE_MATRIX:
        case SINGTYPE_MATRIX_IMM:
            obj.data = (void *) mp_Copy( (matrix) obj.data, r );
            break;
        case SINGTYPE_MODULE:
        case SINGTYPE_MODULE_IMM:
            obj.data = (void *) id_Copy((ideal) obj.data,r);
            break;
        case SINGTYPE_NUMBER:
        case SINGTYPE_NUMBER_IMM:
            obj.data = (void *) n_Copy((number) obj.data,r);
            break;
        case SINGTYPE_POLY:
        case SINGTYPE_POLY_IMM:
            obj.data = (void *) p_Copy((poly) obj.data,r);
            break;
        case SINGTYPE_QRING:
        case SINGTYPE_QRING_IMM:
            ri = (ring) obj.data;
            ri->ref++;   // We fake a copy since this will be decreased later on
            return;
        case SINGTYPE_RESOLUTION:
        case SINGTYPE_RESOLUTION_IMM:
            obj.data = (void *) syCopy((syStrategy) obj.data);
            break;
        case SINGTYPE_RING:
        case SINGTYPE_RING_IMM:
            ri = (ring) obj.data;
            ri->ref++;   // We fake a copy since this will be decreased later on
            return; // TOOD: We could use rCopy... But maybe we never need / want to copy rings ??
            // indeed, we never want to do this, therefore we increase
            // the reference count
        case SINGTYPE_STRING:
        case SINGTYPE_STRING_IMM:
            obj.data = (void *) omStrDup( (char *) obj.data);
            break;
        case SINGTYPE_VECTOR:
        case SINGTYPE_VECTOR_IMM:
            obj.data = (void *) p_Copy((poly) obj.data,r);
            break;
        default:
            ErrorQuit("SingObj::copy: unsupported gtype",0L,0L);
            break;
    }
    needcleanup = true;
}

void SingObj::cleanup()
{
    if (!needcleanup) return;
    needcleanup = false;

    void *data = obj.data;
    attr a = obj.attribute;

    if (a) {
        a->killAll(r);
    }

    switch (gtype) {
        case SINGTYPE_QRING:
        case SINGTYPE_QRING_IMM:
        case SINGTYPE_RING:
        case SINGTYPE_RING_IMM:
            break;
        case SINGTYPE_BIGINT:
        case SINGTYPE_BIGINT_IMM: {
            number n = (number)data;
            nlDelete(&n,NULL); // FIXME: s_internalDelete uses coeffs_BIGINT instead of NULL
            break;
        }
        case SINGTYPE_BIGINTMAT:
        case SINGTYPE_BIGINTMAT_IMM:
            delete (bigintmat *)data;
            break;
        case SINGTYPE_IDEAL:
        case SINGTYPE_IDEAL_IMM: {
            ideal id = (ideal)data;
            id_Delete(&id, r);
            break;
        }
        case SINGTYPE_INT:
        case SINGTYPE_INT_IMM:
            // do nothing
            break;
        case SINGTYPE_INTMAT:
        case SINGTYPE_INTMAT_IMM:
        case SINGTYPE_INTVEC:
        case SINGTYPE_INTVEC_IMM:
            delete (intvec *)data;
            break;
        case SINGTYPE_LINK:  // Was never copied, so leave untouched
        case SINGTYPE_LINK_IMM:
            return;
        case SINGTYPE_LIST:
        case SINGTYPE_LIST_IMM:
            ((lists)data)->Clean(r);
            break;
        case SINGTYPE_MAP:
        case SINGTYPE_MAP_IMM: {
            map m = (map)data;
            omfree(m->preimage);
            m->preimage = NULL;
            id_Delete((ideal *) &m,r);
            break;
        }
        case SINGTYPE_MATRIX:
        case SINGTYPE_MATRIX_IMM: {
            matrix m = (matrix)data;
            mp_Delete(&m, r);
            break;
        }
        case SINGTYPE_MODULE:
        case SINGTYPE_MODULE_IMM: {
            ideal i = (ideal)data;
            id_Delete(&i, r);
            break;
        }
        case SINGTYPE_NUMBER:
        case SINGTYPE_NUMBER_IMM: {
            number n = (number)data;
            n_Delete(&n, r);
            break;
        }
        case SINGTYPE_POLY:
        case SINGTYPE_POLY_IMM:
        case SINGTYPE_VECTOR:
        case SINGTYPE_VECTOR_IMM: {
            poly p = (poly)data;
            p_Delete( &p, r );
            break;
        }
        case SINGTYPE_RESOLUTION:
        case SINGTYPE_RESOLUTION_IMM:
            syKillComputation((syStrategy)data, r);
            break;
        case SINGTYPE_STRING:
        case SINGTYPE_STRING_IMM:
            omfree( (char *)data );
            break;
        default:
            ErrorQuit("SingObj::cleanup: unsupported gtype",0L,0L);
            break;
    }
}

//! @}  end group CxxHelper

