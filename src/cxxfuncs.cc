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

// The following functions are helpers on the C++ level. They
// are not exposed to the GAP level. They are mainly used to dig out
// proper singular elements from their GAP wrappers or from real GAP
// objects.

number NUMBER_FROM_GAP(ring r, Obj n)
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
        if (i >= (-1L << 28) && i < (1L << 28))
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

void BIGINT_OR_INT_FROM_GAP(Obj nr, int &gtype, int ii, number n)
{
    if (IS_INTOBJ(nr)) {    // a GAP immediate integer
        Int i = INT_INTOBJ(nr);
#ifdef SYS_IS_64_BIT
        if (i >= (-1L << 31) && i < (1L << 31)) {
#endif
            gtype = SINGTYPE_INT;
            ii = (int) i;
#ifdef SYS_IS_64_BIT
        } else {
            gtype = SINGTYPE_BIGINT;
            n = nlRInit(i);
        }
#endif
    } else {   // a long GAP integer
        n = ALLOC_RNUMBER();
        UInt size = SIZE_INT(nr);
        mpz_init2(n->z,size*GMP_NUMB_BITS);
        memcpy(n->z->_mp_d,ADDR_INT(nr),sizeof(mp_limb_t)*size);
        n->z->_mp_size = (TNUM_OBJ(nr) == T_INTPOS) ? (Int) size : - (Int)size;
        n->s = 3;  // indicates an integer
        gtype = SINGTYPE_BIGINT;
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

// The following table maps GAP type numbers for singular objects to
// Singular type numbers for Singular objects:

static const int GAPtoSingType[] =
  { 0 /* NOTUSED */,
    BIGINT_CMD,
    DEF_CMD ,
    IDEAL_CMD,
    INT_CMD,
    INTMAT_CMD,
    INTVEC_CMD,
    LINK_CMD,
    LIST_CMD,
    MAP_CMD,
    MATRIX_CMD,
    MODUL_CMD,
    NUMBER_CMD,
    PACKAGE_CMD,
    POLY_CMD,
    PROC_CMD,
    QRING_CMD,
    RESOLUTION_CMD,
    RING_CMD,
    STRING_CMD,
    VECTOR_CMD,
    0 /* USERDEF */,
    0 /* PYOBJECT */
  };

static int SingtoGAPType[MAX_TOK];
/* Also adjust FuncSI_INIT_INTERPRETER where this is initialised,
   when the set of types changes. */

static const int HasRingTable[] =
  { 0, // NOTUSED
    0, // SINGTYPE_BIGINT        =  1
    0, // SINGTYPE_DEF           =  2
    1, // SINGTYPE_IDEAL         =  3
    0, // SINGTYPE_INT           =  4
    0, // SINGTYPE_INTMAT        =  5
    0, // SINGTYPE_INTVEC        =  6
    0, // SINGTYPE_LINK          =  7
    1, // SINGTYPE_LIST          =  8
    1, // SINGTYPE_MAP           =  9
    1, // SINGTYPE_MATRIX        = 10
    1, // SINGTYPE_MODULE        = 11
    1, // SINGTYPE_NUMBER        = 12
    0, // SINGTYPE_PACKAGE       = 13
    1, // SINGTYPE_POLY          = 14
    0, // SINGTYPE_PROC          = 15
    0, // SINGTYPE_QRING         = 16
    1, // SINGTYPE_RESOLUTION    = 17
    0, // SINGTYPE_RING          = 18
    0, // SINGTYPE_STRING        = 19
    1, // SINGTYPE_VECTOR        = 20
    0, // SINGTYPE_USERDEF       = 21
    0  // SINGTYPE_PYOBJECT      = 22
  };

void *FOLLOW_SUBOBJ(Obj proxy, int pos, void *current, int &currgtype)
// proxy is a GAP proxy object, pos is a position in it, the first
// being 2, current is a pointer to a Singular object of type
// currgtype (as a GAP type number). This function returns the
// Singular object referenced by the proxy object. This function
// implements the recursion needed for deeply nested Singular objects.
{
    // To end the recursion:
    if (pos >= SIZE_OBJ(proxy)/sizeof(UInt)) return current;
    if (!IS_INTOBJ(ELM_PLIST(proxy,pos))) {
        ErrorQuit("proxy index must be an immediate integer",0L,0L);
        return NULL;
    }

    if (currgtype == SINGTYPE_IDEAL) {
        Int index = INT_INTOBJ(ELM_PLIST(proxy,pos));
        ideal id = (ideal) current;
        if (index <= 0 || index > IDELEMS(id)) {
            ErrorQuit("ideal index out of range",0L,0L);
            return NULL;
        }
        currgtype = SINGTYPE_POLY;
        return id->m[index-1];
    } else if (currgtype == SINGTYPE_MATRIX) {
        if (pos+1 >= SIZE_OBJ(proxy)/sizeof(UInt) ||
            !IS_INTOBJ(ELM_PLIST(proxy,pos)) ||
            !IS_INTOBJ(ELM_PLIST(proxy,pos+1))) {
          ErrorQuit("need two integer indices for matrix proxy element",0L,0L);
          return NULL;
        }
        Int row = INT_INTOBJ(ELM_PLIST(proxy,pos));
        Int col = INT_INTOBJ(ELM_PLIST(proxy,pos+1));
        matrix mat = (matrix) current;
        if (row <= 0 || row > mat->nrows ||
            col <= 0 || col > mat->ncols) {
            ErrorQuit("matrix indices out of range",0L,0L);
            return NULL;
        }
        return MATELEM(mat,row,col);
    } else if (currgtype == SINGTYPE_LIST) {
        lists l = (lists) current;
        Int index = INT_INTOBJ(ELM_PLIST(proxy,pos));
        if (index <= 0 || index > l->nr+1 ) {
            ErrorQuit("list index out of range",0L,0L);
            return NULL;
        }
        currgtype = SingtoGAPType[l->m[index-1].Typ()];
        current = l->m[index-1].Data();
        return FOLLOW_SUBOBJ(proxy,pos+1,current,currgtype);
    } else {
        ErrorQuit("Singular object has no subobjects",0L,0L);
        return NULL;
    }
}

class SingObj {
    // This class digs out the underlying singular object of a GAP
    // object together with its type and ring. gtype is set to the GAP
    // number for of the type and stype to the Singular number of the
    // type. rnr and r are set if the object has an associated ring,
    // otherwise they are not touched.
    // The GAP object input can be GAP integers (which produce
    // machine integers if possible), GAP strings, GAP wrappers for
    // Singular objects, which produce the corresponding Singular
    // object, GAP proxy objects for subobjects of other Singular
    // objects, or GAP proxy objects for values in Singular interpreter
    // variables. Note that the resulting Singular object is *not*
    // copied. Use .copy afterwards if you want to hand the
    // result to something destructive.
    // This class remembers, whether or not the object has been made
    // on the fly (for integers and strings) or whether it is only
    // borrowed. The destructor takes care of freeing automatically.
  public:
    void *obj;
    int gtype;
    int stype;
    bool iscopy;
    const char *error;
    ring ri;

    SingObj(Obj input, UInt &rnr, ring &r);
    ~SingObj(void);       // Calls cleanup
    void copy(void);      // Makes a copy if it is not already one
    void cleanup(void);   // Frees object if it was a copy
};

SingObj::~SingObj(void)
{
    if (iscopy) cleanup();
}

SingObj::SingObj(Obj input, UInt &rnr, ring &r)
{
    int i;
    number n;
    error = NULL;
    ri = NULL;
    if (IS_INTOBJ(input) || 
        TNUM_OBJ(input) == T_INTPOS || TNUM_OBJ(input) == T_INTNEG) {
        BIGINT_OR_INT_FROM_GAP(input,gtype,i,n);
        if (gtype == SINGTYPE_INT) {
            obj = (void *) i;
            iscopy = false;
        } else {
            obj = (void *) n;
            iscopy = true;
        }
    } else if (TNUM_OBJ(input) == T_STRING) {
        UInt len = GET_LEN_STRING(input);
        char *ost = (char *) omalloc((size_t) len + 1);
        memcpy(ost,reinterpret_cast<char*>(CHARS_STRING(input)),len);
        obj = (void *) ost;
        gtype = SINGTYPE_STRING;
        iscopy = true;
    } else if (TNUM_OBJ(input) == T_SINGULAR) {
        gtype = TYPE_SINGOBJ(input);
        obj = CXX_SINGOBJ(input);
        if (HasRingTable[gtype]) {
            rnr = RING_SINGOBJ(input);
            r = GET_SINGRING(rnr);
            ri = r;
        }
        iscopy = false;
    } else if (IS_POSOBJ(input) && TYPE_OBJ(input) == SingularProxiesType) {
        if (IS_INTOBJ(ELM_PLIST(input,2))) {
            // This is a proxy object for a subobject:
            Obj ob = ELM_PLIST(input,1);
            if (TNUM_OBJ(ob) != T_SINGULAR) {
                obj = NULL;
                iscopy = false;
                gtype = 0;
                stype = 0;
                error = "proxy object does not refer to Singular object";
                return;
            }
            gtype = TYPE_SINGOBJ(ob);
            if (HasRingTable[gtype] && RING_SINGOBJ(ob) != 0) {
                rnr = RING_SINGOBJ(ob);
                r = GET_SINGRING(rnr);
                ri = r;
            }
            obj = FOLLOW_SUBOBJ(input,2,CXX_SINGOBJ(ob),gtype);
            iscopy = false;
        } else if (IS_STRING_REP(ELM_PLIST(input,2))) {
            // This is a proxy object for an interpreter variable
            obj = NULL;
            error = "proxy objects to Singular interpreter variables are not yet implemented";
            iscopy = false;
            gtype = 0;
            stype = 0;
            return;
        } else {
            obj = NULL;
            error = "unknown Singular proxy object";
            iscopy = false;
            gtype = 0;
            stype = 0;
            return;
        }
    } else {
        obj = NULL;
        iscopy = false;
        error = "Argument to Singular call is no valid Singular object";
        gtype = 0;
        stype = 0;
        return;
    }
    stype = GAPtoSingType[gtype];
}

void SingObj::copy()
// Copies a singular object using the appropriate function according
// to its type, unless it is a link, a qring or a ring, or unless it
// is already a copy.
{
    if (ri && ri != currRing) rChangeCurrRing(ri);
    switch (gtype) {
      case SINGTYPE_BIGINT:
        obj = (void *) nlCopy((number) obj);
        break;
      case SINGTYPE_IDEAL:
        obj = (void *) id_Copy((ideal) obj,ri);
        break;
      case SINGTYPE_INTMAT:
      case SINGTYPE_INTVEC:
        obj = (void *) new intvec((intvec *) obj);
        break;
      case SINGTYPE_LINK:  // Do not copy here since it does not make sense
        return;
      case SINGTYPE_LIST:
        obj = (void *) lCopy( (lists) obj );
        break;
      case SINGTYPE_MAP:
        obj = (void *) maCopy( (map) obj );
        break;
      case SINGTYPE_MATRIX:
        obj = (void *) mpCopy( (matrix) obj );
        break;
      case SINGTYPE_MODULE:
        obj = (void *) id_Copy((ideal) obj,ri);
        break;
      case SINGTYPE_NUMBER:
        obj = (void *) n_Copy((number) obj,ri);
        break;
      case SINGTYPE_POLY:
        obj = (void *) p_Copy((poly) obj,ri);
        break;
      case SINGTYPE_QRING:
        return;
      case SINGTYPE_RESOLUTION:
        obj = (void *) syCopy((syStrategy) obj);
        break;
      case SINGTYPE_RING:
        return; // TOOD: We could use rCopy... But maybe we never need / want to copy rings ??
      case SINGTYPE_STRING:
        obj = (void *) omStrDup( (char *) obj);
        break;
      case SINGTYPE_VECTOR:
        obj = (void *) p_Copy((poly) obj,ri);
        break;
      case SINGTYPE_INT:
        return;
      default:
        return;
    }
    iscopy = true;
}

void SingObj::cleanup(void)
{
    if (!iscopy) return;
    iscopy = false;
    switch (gtype) {
      case SINGTYPE_BIGINT:
        nlDelete((number *)(&obj), NULL);
        break;
      case SINGTYPE_IDEAL:
        id_Delete((ideal *)(&obj), ri);
        break;
      case SINGTYPE_INTMAT:
      case SINGTYPE_INTVEC:
        delete (intvec *) obj;
        break;
      case SINGTYPE_LINK:  // Was never copied, so leave untouched
        return;
      case SINGTYPE_LIST:
        ((lists) obj)->Clean(ri);
        break;
      case SINGTYPE_MAP:
        // FIXME
        break;
      case SINGTYPE_MATRIX:
        mpDelete((matrix *)(&obj), ri);
        break;
      case SINGTYPE_MODULE:
        id_Delete((ideal *)(&obj), ri);
        break;
      case SINGTYPE_NUMBER:
        n_Delete((number *)(&obj), ri);
        break;
      case SINGTYPE_POLY:
        p_Delete((poly *)(&obj), ri);
        break;
      case SINGTYPE_QRING:
        return;
      case SINGTYPE_RESOLUTION:
        return;
      case SINGTYPE_RING:
        return;
      case SINGTYPE_STRING:
        omfree( (char *) obj );
        break;
      case SINGTYPE_VECTOR:
        p_Delete((poly*)(&obj), ri);
        break;
      case SINGTYPE_INT:
        return;
    }
}

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
        return ObjInt_Int((long) (singres->Data()));
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

// The following function is called from the garbage collector, it
// needs to free the underlying singular object. Since objects are
// wrapped only once, this is safe. Note in particular that proxy
// objects do not have TNUM T_SINGULAR and thus are not taking part
// in this freeing scheme. They do not actually hold a direct
// reference to a singular object anyway.

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

// The following function is the marking function for the garbage
// collector for T_SINGULAR objects. In the current implementation
// This function is not actually needed.

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

// The following function returns the GAP type of an object with TNUM
// T_SINGULAR. A pointer to it is put into the dispatcher table in the
// GAP kernel.

extern "C"
Obj TypeSingularObj(Obj o)
{
    return ELM_PLIST(SingularTypes,TYPE_SINGOBJ(o));
}

// The following functions are implementations of functions which
// appear on the GAP level. There are a lot of constructors amongst
// them:

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
    poly p = p_NSet(NUMBER_FROM_GAP(r, coeff),r);
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

Obj FuncSI_Makebigint(Obj self, Obj nr)
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

Obj FuncSI_Makeintvec(Obj self, Obj l)
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

Obj FuncSI_Makeintmat(Obj self, Obj m)
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

Obj FuncSI_Makeideal(Obj self, Obj l)
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
    number bb = NUMBER_FROM_GAP(r,b);
    poly aa = pp_Mult_nn((poly) CXX_SINGOBJ(a),bb,r);
    n_Delete(&bb,r);
    Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY,aa,RING_SINGOBJ(a));
    return tmp;
}

#include "lowlevel_mappings.cc"

// The following functions allow access to the singular interpreter.
// They are exported to the GAP level.

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
Obj FuncSI_INIT_INTERPRETER(Obj self, Obj path)
{
    int i;
    // init path names etc.
    siInit(reinterpret_cast<char*>(CHARS_STRING(path)));
    currentVoice=feInitStdin(NULL);
    WerrorS_callback = SingularErrorCallback;
    for (i = SINGTYPE_BIGINT; i <= SINGTYPE_VECTOR; i++) {
        if (GAPtoSingType[i] >= MAX_TOK) {
            Pr("Singular types have changed unforeseen",0L,0L);
            exit(1);
        }
        SingtoGAPType[GAPtoSingType[i]] = i;
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

// The following functions allow access to all functions of the
// Singular C++ library that the Singular interpreter can call.
// They do not provide a fast path into the library, because they
// use some Singular interpreter infrastructure, in particular, all
// function arguments are wrapped by some Singular interpreter data
// structure.

Obj FuncSI_CallFunc1(Obj self, Obj op, Obj input)
{
    int gtype;
    int stype;  /* Singular type like INT_CMD */
    UInt rnr = 0;
    ring r = NULL;

    SingObj sing(input,rnr,r);
    if (r && r != currRing) rChangeCurrRing(r);
    if (sing.error) {
        sing.cleanup();
        ErrorQuit(sing.error,0L,0L);
    }
    sing.copy();   // this has copied the object if at all possible
                   // (not for link, qring and ring)
    leftv singint = WRAP_SINGULAR(sing.obj,sing.stype);

    leftv singres = (leftv) omAlloc0(sizeof(sleftv));
    if (LastSingularOutput) {
        omFree(LastSingularOutput);
        LastSingularOutput = NULL;
    }
    SPrintStart();
    errorreported = 0;
    BOOLEAN ret = iiExprArith1(singres,singint,INT_INTOBJ(op));
    LastSingularOutput = SPrintEnd();

    // if (stype != LINK_CMD && stype != RING_CMD && stype != QRING_CMD) 
    //    singint->CleanUp(r);
    sing.cleanup();
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

Obj FuncSI_CallFunc2(Obj self, Obj op, Obj a, Obj b)
{
    UInt rnr = 0;
    ring r = NULL;

    SingObj singa(a,rnr,r);
    if (r && r != currRing) rChangeCurrRing(r);
    if (singa.error) {
        singa.cleanup();
        ErrorQuit(singa.error,0L,0L);
    }
    singa.copy();  // this has copied the object if at all possible
                   // (not for link, qring and ring)
    leftv singaint = WRAP_SINGULAR(singa.obj,singa.stype);

    SingObj singb(b,rnr,r);
    if (r && r != currRing) rChangeCurrRing(r);
    if (singb.error) {
        singa.cleanup();
        singb.cleanup();
        ErrorQuit(singb.error,0L,0L);
    }
    singb.copy();  // this has copied the object if at all possible
                   // (not for link, qring and ring)
    leftv singbint = WRAP_SINGULAR(singb.obj,singb.stype);

    leftv singres = (leftv) omAlloc0(sizeof(sleftv));
    if (LastSingularOutput) {
        omFree(LastSingularOutput);
        LastSingularOutput = NULL;
    }
    SPrintStart();
    errorreported = 0;
    BOOLEAN ret = iiExprArith2(singres,singaint,INT_INTOBJ(op),singbint);
    LastSingularOutput = SPrintEnd();

    singa.cleanup();
    omFree(singaint);

    singb.cleanup();
    omFree(singbint);

    if (ret) {
        singres->CleanUp(r);
        omFree(singres);
        return Fail;
    }
    Obj result = UNWRAP_SINGULAR(singres,rnr,r);
    omFree(singres);
    return result;
}

Obj FuncSI_CallFunc3(Obj self, Obj op, Obj a, Obj b, Obj c)
{
    UInt rnr = 0;
    ring r = NULL;

    SingObj singa(a,rnr,r);
    if (r && r != currRing) rChangeCurrRing(r);
    if (singa.error) {
        singa.cleanup();
        ErrorQuit(singa.error,0L,0L);
    }
    singa.copy();  // this has copied the object if at all possible
                   // (not for link, qring and ring)
    leftv singaint = WRAP_SINGULAR(singa.obj,singa.stype);

    SingObj singb(b,rnr,r);
    if (r && r != currRing) rChangeCurrRing(r);
    if (singb.error) {
        singa.cleanup();
        singb.cleanup();
        ErrorQuit(singb.error,0L,0L);
    }
    singb.copy();  // this has copied the object if at all possible
                   // (not for link, qring and ring)
    leftv singbint = WRAP_SINGULAR(singb.obj,singb.stype);

    SingObj singc(c,rnr,r);
    if (r && r != currRing) rChangeCurrRing(r);
    if (singc.error) {
        singa.cleanup();
        singb.cleanup();
        singc.cleanup();
        ErrorQuit(singc.error,0L,0L);
    }
    singc.copy();  // this has copied the object if at all possible
                   // (not for link, qring and ring)
    leftv singcint = WRAP_SINGULAR(singc.obj,singc.stype);

    leftv singres = (leftv) omAlloc0(sizeof(sleftv));
    if (LastSingularOutput) {
        omFree(LastSingularOutput);
        LastSingularOutput = NULL;
    }
    SPrintStart();
    errorreported = 0;
    BOOLEAN ret = iiExprArith3(singres,INT_INTOBJ(op),
                               singaint,singbint,singcint);
    LastSingularOutput = SPrintEnd();

    singa.cleanup();
    omFree(singaint);

    singb.cleanup();
    omFree(singbint);

    singc.cleanup();
    omFree(singcint);

    if (ret) {
        singres->CleanUp(r);
        omFree(singres);
        return Fail;
    }
    Obj result = UNWRAP_SINGULAR(singres,rnr,r);
    omFree(singres);
    return result;
}

#define SINGULAR_MAX_NR_ARGS 8

Obj FuncSI_CallFuncM(Obj self, Obj op, Obj arg)
{
    int gtype;
    int stype[SINGULAR_MAX_NR_ARGS];  /* Singular type like INT_CMD */
    UInt rnr = 0;
    ring r = NULL;
    void *sing[SINGULAR_MAX_NR_ARGS];
    leftv singint[SINGULAR_MAX_NR_ARGS];
    int nrargs = (int) LEN_PLIST(arg);
    int i;
    if (nrargs > SINGULAR_MAX_NR_ARGS) {
        ErrorQuit("Too many arguments to Singular call",0L,0L);
        return NULL;
    }
    for (i = 0;i < nrargs;i++) {
        sing[i] = GET_SINGOBJ(ELM_PLIST(arg,i+1),gtype,stype[i],rnr,r,0);
        if (r && r != currRing) rChangeCurrRing(r);
        sing[i] = COPY_SINGOBJ(sing[i],gtype,r);
                     // this has copied the object if at all possible
                     // (not for link, qring and ring)
        singint[i] = WRAP_SINGULAR(sing[i],stype[i]);
        if (i > 0) singint[i-1]->next = singint[i];
    }
    leftv singres = (leftv) omAlloc0(sizeof(sleftv));
    if (LastSingularOutput) {
        omFree(LastSingularOutput);
        LastSingularOutput = NULL;
    }
    SPrintStart();
    errorreported = 0;
    BOOLEAN ret;
    switch (nrargs) {
        case 1:
            ret = iiExprArith1(singres,singint[0],INT_INTOBJ(op));
            break;
        case 2:
            ret = iiExprArith2(singres,singint[0],INT_INTOBJ(op),singint[1]);
            break;
        case 3:
            ret = iiExprArith3(singres,INT_INTOBJ(op),
                               singint[0],singint[1],singint[2]);
            break;
        default:
            ret = iiExprArithM(singres,singint[0],INT_INTOBJ(op));
            break;
    }
    LastSingularOutput = SPrintEnd();
    for (i = 0;i < nrargs;i++) {
        if (stype[i] != LINK_CMD && stype[i] != RING_CMD && 
            stype[i] != QRING_CMD) 
            singint[i]->CleanUp(r);
        omFree(singint[i]);
    }
    if (ret) {
        singres->CleanUp(r);
        omFree(singres);
        return Fail;
    }
    Obj result = UNWRAP_SINGULAR(singres,rnr,r);
    omFree(singres);
    return result;
}

