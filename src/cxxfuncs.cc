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
            (size == 1UL && ADDR_INT(nr)[0] > (1UL << 31)) ||
            (size == 1UL && ADDR_INT(nr)[0] == (1UL << 31) && 
             TNUM_OBJ(nr) == T_INTPOS)) {
            ErrorQuit("Argument must be a 32-bit integer",0L,0L);
            return 0;
        }
        return TNUM_OBJ(nr) == T_INTPOS ?
               (int) ADDR_INT(nr)[0] :
               -(int) ADDR_INT(nr)[0];
    }
}

void BIGINT_OR_INT_FROM_GAP(Obj nr, int &gtype, int &ii, number &n)
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

void *FOLLOW_SUBOBJ(Obj proxy, int pos, void *current, int &currgtype,
                    const char *(&error))
// proxy is a GAP proxy object, pos is a position in it, the first
// being 2, current is a pointer to a Singular object of type
// currgtype (as a GAP type number). This function returns the
// Singular object referenced by the proxy object. This function
// implements the recursion needed for deeply nested Singular objects.
// If anything goes wrong, error is set to a message and NULL is
// returned.
{
    // To end the recursion:
    if ((UInt) pos >= SIZE_OBJ(proxy)/sizeof(UInt)) return current;
    if (!IS_INTOBJ(ELM_PLIST(proxy,pos))) {
        error = "proxy index must be an immediate integer";
        return NULL;
    }

    if (currgtype == SINGTYPE_IDEAL) {
        Int index = INT_INTOBJ(ELM_PLIST(proxy,pos));
        ideal id = (ideal) current;
        if (index <= 0 || index > IDELEMS(id)) {
            error = "ideal index out of range";
            return NULL;
        }
        currgtype = SINGTYPE_POLY;
        return id->m[index-1];
    } else if (currgtype == SINGTYPE_MATRIX) {
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
    } else if (currgtype == SINGTYPE_LIST) {
        lists l = (lists) current;
        Int index = INT_INTOBJ(ELM_PLIST(proxy,pos));
        if (index <= 0 || index > l->nr+1 ) {
            error = "list index out of range";
            return NULL;
        }
        currgtype = SingtoGAPType[l->m[index-1].Typ()];
        current = l->m[index-1].Data();
        return FOLLOW_SUBOBJ(proxy,pos+1,current,currgtype,error);
    } else {
        error = "Singular object has no subobjects";
        return NULL;
    }
}

class SingObj {
    // This class is a wrapper around a Singular object of any type.
    // It keeps track whether or not it is its responsibility to free
    // the Singular object in the end or whether it has just borrowed
    // the object reference temporarily.
    // It can dig out the underlying singular object of a GAP
    // object together with its type and ring, this also works for
    // proxy objects. The Singular object is also automatically
    // wrapped for the Singular interpreter in an sleftv structure.
    // The object also keeps track of the GAP type number, the underlying
    // ring with its GAP number and a possible error that might have occurred.
    //
    // For the usual constructor taking a GAP object:
    // The GAP object input can be GAP integers (which produce
    // machine integers if possible and otherwise bigints), 
    // GAP strings, GAP wrappers for Singular objects, which produce the
    // corresponding Singular object, GAP proxy objects for subobjects
    // of other Singular objects, or GAP proxy objects for values in
    // Singular interpreter variables. Note that the resulting Singular
    // object is *not* copied. Use .copy afterwards if you want to hand
    // the result to something destructive.
    //
    // Note that if an error occurs, GAP will do a longjmp, so we cannot
    // rely on automatic destruction any more, we have to call cleanup
    // ourselves! This is why the error cannot be handled directly
    // in the methods of this object. It is possible that other objects
    // of the same type need to be told about the error.
  public:
    sleftv obj;
    int gtype;
    bool needcleanup;  // if this is true we have to destruct the Singular
                        // object when this object dies.
    const char *error;  // If non-NULL, an error has happened.
    UInt rnr;     // GAP number of the underlying Singular ring
    ring r;       // Underlying Singular ring.

    SingObj(Obj input, UInt &extrnr, ring &extr)
      { init(input,extrnr,extr); }
    SingObj(void)     // Default constructor for empty object
      : gtype(0), needcleanup(false), error(NULL), rnr(0), r(NULL)
      { obj.Init(); }
    void init(Obj input, UInt &extrnr, ring &extr);
      // This does the actual work
    ~SingObj(void) { cleanup(); }   // a mere convenience
    leftv destructiveuse(void)
      // Call this to get a pointer to the internal obj structure of type
      // sleftv if you intend to use the Singular object destructively.
      // If necessary, copy() is called automatically and any scheduled
      // cleanup on our side is prevented.
    {
        if (!needcleanup) copy();
        needcleanup = false;
        return &obj;
    }
    leftv nondestructiveuse(void)
      // Call this to get a pointer to the internal obj structure of type
      // sleftv if you intend to use the singular object non-destructively.
      // No automatic copy() is performed, if cleanup was scheduled it
      // will be done as scheduled later on.
    {
        return &obj;
    }
    void copy(void);      // Makes a copy if it is not already one
    void cleanup(void);   // Frees object if it was a copy
    Obj gapwrap(void);    // GAP-wraps the object
};

void SingObj::init(Obj input, UInt &extrnr, ring &extr)
{
    int i;
    number n;
    error = NULL;
    r = NULL;
    rnr = 0;
    obj.Init();
    if (IS_INTOBJ(input) || 
        TNUM_OBJ(input) == T_INTPOS || TNUM_OBJ(input) == T_INTNEG) {
        BIGINT_OR_INT_FROM_GAP(input,gtype,i,n);
        if (gtype == SINGTYPE_INT) {
            obj.data = (void *) i;
            obj.rtyp = INT_CMD;
            needcleanup = false;
        } else {
            obj.data = (void *) n;
            obj.rtyp = BIGINT_CMD;
            needcleanup = true;
        }
    } else if (TNUM_OBJ(input) == T_STRING) {
        UInt len = GET_LEN_STRING(input);
        char *ost = (char *) omalloc((size_t) len + 1);
        memcpy(ost,reinterpret_cast<char*>(CHARS_STRING(input)),len);
        obj.data = (void *) ost;
        obj.rtyp = STRING_CMD;
        gtype = SINGTYPE_STRING;
        needcleanup = true;
    } else if (TNUM_OBJ(input) == T_SINGULAR) {
        gtype = TYPE_SINGOBJ(input);
        obj.data = CXX_SINGOBJ(input);
        obj.rtyp = GAPtoSingType[gtype];
        if (HasRingTable[gtype]) {
            rnr = RING_SINGOBJ(input);
            r = GET_SINGRING(rnr);
            extrnr = rnr;
            extr = r;
            if (r != currRing) rChangeCurrRing(r);
        }
        needcleanup = false;
    } else if (IS_POSOBJ(input) && TYPE_OBJ(input) == SingularProxiesType) {
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
                rnr = RING_SINGOBJ(ob);
                r = GET_SINGRING(rnr);
                extrnr = rnr;
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

void SingObj::copy()
// Copies a singular object using the appropriate function according
// to its type, unless it is a link, a qring or a ring, or unless it
// is already a copy.
{
    switch (gtype) {
      case SINGTYPE_BIGINT:
        obj.data = (void *) nlCopy((number) obj.data);
        break;
      case SINGTYPE_IDEAL:
        obj.data = (void *) id_Copy((ideal) obj.data,r);
        break;
      case SINGTYPE_INTMAT:
      case SINGTYPE_INTVEC:
        obj.data = (void *) new intvec((intvec *) obj.data);
        break;
      case SINGTYPE_LINK:  // Do not copy here since it does not make sense
        return;
      case SINGTYPE_LIST:
        obj.data = (void *) lCopy( (lists) obj.data );
        break;
      case SINGTYPE_MAP:
        obj.data = (void *) maCopy( (map) obj.data );
        break;
      case SINGTYPE_MATRIX:
        obj.data = (void *) mpCopy( (matrix) obj.data );
        break;
      case SINGTYPE_MODULE:
        obj.data = (void *) id_Copy((ideal) obj.data,r);
        break;
      case SINGTYPE_NUMBER:
        obj.data = (void *) n_Copy((number) obj.data,r);
        break;
      case SINGTYPE_POLY:
        obj.data = (void *) p_Copy((poly) obj.data,r);
        break;
      case SINGTYPE_QRING:
        return;
      case SINGTYPE_RESOLUTION:
        obj.data = (void *) syCopy((syStrategy) obj.data);
        break;
      case SINGTYPE_RING:
        return; // TOOD: We could use rCopy... But maybe we never need / want to copy rings ??
      case SINGTYPE_STRING:
        obj.data = (void *) omStrDup( (char *) obj.data);
        break;
      case SINGTYPE_VECTOR:
        obj.data = (void *) p_Copy((poly) obj.data,r);
        break;
      case SINGTYPE_INT:
        return;
      default:
        return;
    }
    needcleanup = true;
}

void SingObj::cleanup(void)
{
    if (!needcleanup) return;
    needcleanup = false;
    switch (gtype) {
      case SINGTYPE_BIGINT:
        nlDelete((number *)(obj.data), NULL);
        break;
      case SINGTYPE_IDEAL:
        id_Delete((ideal *)(obj.data), r);
        break;
      case SINGTYPE_INTMAT:
      case SINGTYPE_INTVEC:
        delete (intvec *) (obj.data);
        break;
      case SINGTYPE_LINK:  // Was never copied, so leave untouched
        return;
      case SINGTYPE_LIST:
        ((lists) (obj.data))->Clean(r);
        break;
      case SINGTYPE_MAP:
        // FIXME
        break;
      case SINGTYPE_MATRIX:
        mpDelete((matrix *)(obj.data), r);
        break;
      case SINGTYPE_MODULE:
        id_Delete((ideal *)(obj.data), r);
        break;
      case SINGTYPE_NUMBER:
        n_Delete((number *)(obj.data), r);
        break;
      case SINGTYPE_POLY:
        p_Delete((poly *)(obj.data), r);
        break;
      case SINGTYPE_QRING:
        return;
      case SINGTYPE_RESOLUTION:
        return;
      case SINGTYPE_RING:
        return;
      case SINGTYPE_STRING:
        omfree( (char *) (obj.data) );
        break;
      case SINGTYPE_VECTOR:
        p_Delete((poly*)(obj.data), r);
        break;
      case SINGTYPE_INT:
        return;
    }
}

// This should no long be necessary:
//leftv WRAP_SINGULAR(void *singobj, int type)
//{
//    leftv res = (leftv) omAlloc0(sizeof(sleftv));
//    res->rtyp = type;
//    res->data = singobj;
//    return res;
//}

Obj SingObj::gapwrap(void)
{
    if (!needcleanup) {
        Pr("#W try to GAP-wrap a borrowed Singular object",0L,0L);
    }
    needcleanup = false;
    switch (obj.Typ()) {
      case NONE:
        return True;
      case INT_CMD:
        return ObjInt_Int((long) (obj.Data()));
      case NUMBER_CMD:
        return NEW_SINGOBJ_RING(SINGTYPE_NUMBER,obj.Data(),rnr);
      case POLY_CMD:
        return NEW_SINGOBJ_RING(SINGTYPE_POLY,obj.Data(),rnr);
      case INTVEC_CMD:
        return NEW_SINGOBJ(SINGTYPE_INTVEC,obj.Data());
      case INTMAT_CMD:
        return NEW_SINGOBJ(SINGTYPE_INTMAT,obj.Data());
      case VECTOR_CMD:
        return NEW_SINGOBJ_RING(SINGTYPE_VECTOR,obj.Data(),rnr);
      case IDEAL_CMD:
        return NEW_SINGOBJ_RING(SINGTYPE_IDEAL,obj.Data(),rnr);
      case BIGINT_CMD:
        return NEW_SINGOBJ(SINGTYPE_BIGINT,obj.Data());
      case MATRIX_CMD:
        return NEW_SINGOBJ_RING(SINGTYPE_MATRIX,obj.Data(),rnr);
      case LIST_CMD:
        return NEW_SINGOBJ_RING(SINGTYPE_LIST,obj.Data(),rnr);
      case LINK_CMD:
        return NEW_SINGOBJ(SINGTYPE_LINK,obj.Data());
      case RING_CMD:
        return NEW_SINGOBJ(SINGTYPE_RING,obj.Data());
      case QRING_CMD:
        return NEW_SINGOBJ(SINGTYPE_QRING,obj.Data());
      case RESOLUTION_CMD:
        return NEW_SINGOBJ_RING(SINGTYPE_RESOLUTION,obj.Data(),rnr);
      case STRING_CMD:
        return NEW_SINGOBJ(SINGTYPE_STRING,obj.Data());
      case MAP_CMD:
        return NEW_SINGOBJ_RING(SINGTYPE_MAP,obj.Data(),rnr);
      case MODUL_CMD:
        return NEW_SINGOBJ_RING(SINGTYPE_MODULE,obj.Data(),rnr);
      default:
        obj.CleanUp(r);
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
    UInt nrvars = LEN_PLIST(names);
    UInt i;
    Obj tmp;
    
    array = (char **) omalloc(sizeof(char *) * nrvars);
    for (i = 0;i < nrvars;i++)
        array[i] = omStrDup(CSTR_STRING(ELM_PLIST(names,i+1)));

    ring r = rDefault(INT_INTOBJ(charact),nrvars,array);
    r->ref++;
    i = LEN_LIST(SingularRings)+1;
    tmp = NEW_SINGOBJ_RING(SINGTYPE_RING,r,i);
    ASS_LIST(SingularRings,i,tmp);
    ASS_LIST(SingularElCounts,i,INTOBJ_INT(0));
    return tmp;
}

extern "C"
Obj FuncSingularRing(Obj self, Obj charact, Obj names, Obj orderings)
{
    char **array;
    char *p;
    UInt nrvars;
    UInt nrords;
    int *ord;
    int *block0;
    int *block1;
    int **wvhdl;
    UInt i;
    Int j;
    int covered;
    Obj tmp,tmp2;
    
    // Some checks:
    if (!IS_INTOBJ(charact) || !IS_LIST(names) || !IS_LIST(orderings)) {
        ErrorQuit("Need immediate integer and two lists",0L,0L);
        return Fail;
    }
    nrvars = LEN_LIST(names);
    for (i = 1;i <= nrvars;i++) {
        if (!IS_STRING_REP(ELM_LIST(names,i))) {
            ErrorQuit("Variable names must be strings",0L,0L);
            return Fail;
        }
    }

    // First check that the orderings cover exactly all variables:
    covered = 0;
    nrords = LEN_LIST(orderings);
    for (i = 1;i <= nrords;i++) {
        tmp = ELM_LIST(orderings,i);
        if (!IS_LIST(tmp) || LEN_LIST(tmp) != 2) {
            ErrorQuit("Orderings must be lists of length 2",0L,0L);
            return Fail;
        }
        if (!IS_STRING_REP(ELM_LIST(tmp,1))) {
            ErrorQuit("First entry of ordering must be a string",0L,0L);
            return Fail;
        }
        tmp2 = ELM_LIST(tmp,2);
        if (IS_INTOBJ(tmp2)) covered += (int) INT_INTOBJ(tmp2);
        else if (IS_LIST(tmp2)) {
            covered += (int) LEN_LIST(tmp2);
            for (j = 1;j <= LEN_LIST(tmp2);j++) {
                if (!IS_INTOBJ(ELM_LIST(tmp2,j))) {
                    ErrorQuit("Weights must be immediate integers",0L,0L);
                    return Fail;
                }
            }
        } else {
            ErrorQuit("Second entry of ordering must be an integer or a "
                      "plain list",0L,0L);
            return Fail;
        }
    }
    if (covered != (int) nrvars) {
        ErrorQuit("Orderings do not cover exactly the variables",0L,0L);
        return Fail;
    }
            
    // Now allocate strings for the variable names:
    array = (char **) omalloc(sizeof(char *) * nrvars);
    for (i = 0;i < nrvars;i++)
        array[i] = omStrDup(CSTR_STRING(ELM_LIST(names,i+1)));

    // Now allocate int lists for the orderings:
    ord = (int *) omalloc(sizeof(int) * nrords+1);
    ord[nrords] = 0;
    block0 = (int *) omalloc(sizeof(int) * nrords);
    block1 = (int *) omalloc(sizeof(int) * nrords);
    wvhdl = (int **) omalloc(sizeof(int *) * nrords);
    covered = 0;
    for (i = 0;i < nrords;i++) {
        tmp = ELM_LIST(orderings,i+1);
        p = omStrDup(CSTR_STRING(ELM_LIST(tmp,1)));
        ord[i] = rOrderName(p);
        if (ord[i] == 0) {
            Pr("Warning: Unknown ordering name: %s, assume \"dp\"",
               (Int) (CSTR_STRING(ELM_LIST(tmp,1))),0L);
            ord[i] = rOrderName(omStrDup("dp"));
        }
        block0[i] = covered+1;
        tmp2 = ELM_LIST(tmp,2);
        if (IS_INTOBJ(tmp2)) {
            block1[i] = covered+ (int) (INT_INTOBJ(tmp2));
            wvhdl[i] = NULL;
            covered += (int) (INT_INTOBJ(tmp2));
        } else {   // IS_LIST(tmp2) and consisting of immediate integers
            block1[i] = covered+(int) (LEN_LIST(tmp2));
            wvhdl[i] = (int *) omalloc(sizeof(int) * LEN_LIST(tmp2));
            for (j = 0;j < LEN_LIST(tmp2);j++) {
                wvhdl[i][j] = (int) (INT_INTOBJ(ELM_LIST(tmp2,j+1)));
            }
        }
    }

    ring r = rDefault(INT_INTOBJ(charact),nrvars,array,
                      nrords,ord,block0,block1,wvhdl);
    r->ref++;

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

// Our constructors for polynomials:

poly ParsePoly(ring r, const char *&st)
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

extern "C"
Obj FuncSI_Makepoly_from_String(Obj self, Obj rr, Obj st)
// st a string or a list of lists or so...
{
    if (TNUM_OBJ(rr) != T_SINGULAR ||
        TYPE_SINGOBJ(rr) != SINGTYPE_RING) {
        ErrorQuit("Argument rr must be a singular ring",0L,0L);
        return Fail;
    }
    if (!IS_STRING_REP(st)) {
        ErrorQuit("Argument st must be a string",0L,0L);
        return Fail;
    }
    ring r = (ring) CXX_SINGOBJ(rr);
    UInt rnr = RING_SINGOBJ(rr);
    const char *p = CSTR_STRING(st);
    poly q = ParsePoly(r,p);
    Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY,q,rnr);
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

extern "C"
Obj FuncSI_Makematrix_from_String(Obj self, Obj nrrows, Obj nrcols, 
                                  Obj rr, Obj st)
{
    if (!(IS_INTOBJ(nrrows) && IS_INTOBJ(nrcols) &&
          INT_INTOBJ(nrrows) > 0 && INT_INTOBJ(nrcols) > 0)) {
        ErrorQuit("nrrows and nrcols must be positive integers",0L,0L);
        return Fail;
    }
    Int c_nrrows = INT_INTOBJ(nrrows);
    Int c_nrcols = INT_INTOBJ(nrcols);
    if (TNUM_OBJ(rr) != T_SINGULAR ||
        TYPE_SINGOBJ(rr) != SINGTYPE_RING) {
        ErrorQuit("Argument rr must be a singular ring",0L,0L);
        return Fail;
    }
    if (!IS_STRING_REP(st)) {
        ErrorQuit("Argument st must be a string",0L,0L);
        return Fail;
    }
    ring r = (ring) CXX_SINGOBJ(rr);
    UInt rnr = RING_SINGOBJ(rr);
    if (r != currRing) rChangeCurrRing(r);
    const char *p = CSTR_STRING(st);
    poly *polylist;
    Int len = ParsePolyList(r, p, (int) (c_nrrows * c_nrrows), polylist);
    matrix mat = mpNew(c_nrrows,c_nrcols);
    Int i;
    Int row = 1;
    Int col = 1;
    for (i = 0;i < len && row <= c_nrrows;i++) {
        MATELEM(mat,row,col) = polylist[i];
        col++;
        if (col > c_nrcols) {
            col = 1;
            row++;
        }
    }
    omFree(polylist);
    return NEW_SINGOBJ_RING(SINGTYPE_MATRIX,mat,rnr);
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

extern "C"
Obj FuncSI_Makebigint(Obj self, Obj nr)
{
    return NEW_SINGOBJ(SINGTYPE_BIGINT,BIGINT_FROM_GAP(nr));
}

extern "C"
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

extern "C"
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

extern "C"
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

extern "C"
Obj FuncSI_Makeintmat(Obj self, Obj m)
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

extern "C"
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

extern "C"
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
    ring r;
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
Obj FuncSI_Makematrix(Obj self, Obj nrrows, Obj nrcols, Obj l)
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
    Obj t;
    ring r,r2;
    Int row = 1;
    Int col = 1;
    for (i = 1;i <= len && row <= c_nrrows;i++) {
        t = ELM_LIST(l,i);
        if (!ISSINGOBJ(SINGTYPE_POLY,t)) {
            if (i > 1) id_Delete((ideal *) &mat,r);
            ErrorQuit("l must only contain singular polynomials",0L,0L);
            return Fail;
        }
        if (i == 1) {
            r = SINGRING_SINGOBJ(t);
            if (r != currRing) rChangeCurrRing(r);
            mat = mpNew(c_nrrows,c_nrcols);
        } else {
            if (r != SINGRING_SINGOBJ(t)) {
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

extern "C"
Obj FuncGAPSingular(Obj self, Obj singobj)
// Tries to transform a singular object to a GAP object.
// Currently does small integers and strings
{
    char *st;
    UInt len;
    Obj tmp;
    Int i;

    if (TNUM_OBJ(singobj) != T_SINGULAR) {
        ErrorQuit("singobj must be a wrapped Singular object",0L,0L);
        return Fail;
    }
    switch (TYPE_SINGOBJ(singobj)) {
      case SINGTYPE_STRING:
        st = (char *) CXX_SINGOBJ(singobj);
        len = (UInt) strlen(st);
        tmp = NEW_STRING(len);
        SET_LEN_STRING(tmp,len);
        strcpy(reinterpret_cast<char*>(CHARS_STRING(tmp)),st);
        return tmp;
      case SINGTYPE_INT:
        i = (Int) CXX_SINGOBJ(singobj);
        return INTOBJ_INT(i);
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

extern "C"
Obj FuncSI_CallFunc1(Obj self, Obj op, Obj input)
{
    UInt rnr = 0;
    ring r = NULL;

    SingObj sing(input,rnr,r);
    if (sing.error) { ErrorQuit(sing.error,0L,0L); }
    SingObj singres;
    if (LastSingularOutput) {
        omFree(LastSingularOutput);
        LastSingularOutput = NULL;
    }
    SPrintStart();
    errorreported = 0;
    BOOLEAN ret = iiExprArith1(&(singres.obj),sing.destructiveuse(),
                               INT_INTOBJ(op));
    LastSingularOutput = SPrintEnd();
    if (ret) {
        singres.obj.CleanUp();  // 
        return Fail;
    }
    singres.rnr = rnr;   // Set the ring number according to the arguments
    singres.needcleanup = true;
    return singres.gapwrap();
}

extern "C"
Obj FuncSI_CallFunc2(Obj self, Obj op, Obj a, Obj b)
{
    UInt rnr = 0;
    ring r = NULL;

    SingObj singa(a,rnr,r);
    if (singa.error) { ErrorQuit(singa.error,0L,0L); }
    SingObj singb(b,rnr,r);
    if (singb.error) {
        singa.cleanup();
        ErrorQuit(singb.error,0L,0L);
    }
    SingObj singres;
    if (LastSingularOutput) {
        omFree(LastSingularOutput);
        LastSingularOutput = NULL;
    }
    SPrintStart();
    errorreported = 0;
    BOOLEAN ret = iiExprArith2(&(singres.obj),singa.destructiveuse(),
                    INT_INTOBJ(op),singb.destructiveuse());
    LastSingularOutput = SPrintEnd();
    if (ret) {
        singres.obj.CleanUp(r);
        return Fail;
    }
    singres.rnr = rnr;
    singres.needcleanup = true;
    return singres.gapwrap();
}

extern "C"
Obj FuncSI_CallFunc3(Obj self, Obj op, Obj a, Obj b, Obj c)
{
    UInt rnr = 0;
    ring r = NULL;

    SingObj singa(a,rnr,r);
    if (singa.error) { ErrorQuit(singa.error,0L,0L); }
    SingObj singb(b,rnr,r);
    if (singb.error) {
        singa.cleanup();
        ErrorQuit(singb.error,0L,0L);
    }
    SingObj singc(c,rnr,r);
    if (singc.error) {
        singa.cleanup();
        singb.cleanup();
        ErrorQuit(singc.error,0L,0L);
    }
    SingObj singres;
    if (LastSingularOutput) {
        omFree(LastSingularOutput);
        LastSingularOutput = NULL;
    }
    SPrintStart();
    errorreported = 0;
    BOOLEAN ret = iiExprArith3(&(singres.obj),INT_INTOBJ(op),
                               singa.destructiveuse(),
                               singb.destructiveuse(),
                               singc.destructiveuse());
    LastSingularOutput = SPrintEnd();
    if (ret) {
        singres.obj.CleanUp(r);
        return Fail;
    }
    singres.rnr = rnr;
    singres.needcleanup = true;
    return singres.gapwrap();
}

extern "C"
Obj FuncSI_CallFuncM(Obj self, Obj op, Obj arg)
{
    UInt rnr = 0;
    ring r = NULL;
    int i,j;
    SingObj *sing;
    const char *error;

    int nrargs = (int) LEN_PLIST(arg);
    sing = new SingObj[nrargs];
    for (i = 0;i < nrargs;i++) {
        sing[i].init(ELM_PLIST(arg,i+1),rnr,r);
        if (sing[i].error) {
            for (j = 0;j < i;j++) {
                sing[j].cleanup();
            }
            error = sing[i].error;
            delete [] sing;
            ErrorQuit(error,0L,0L);
        }
        if (i > 0) sing[i-1].obj.next = &(sing[i].obj);
    }
    SingObj singres;
    if (LastSingularOutput) {
        omFree(LastSingularOutput);
        LastSingularOutput = NULL;
    }
    SPrintStart();
    errorreported = 0;
    BOOLEAN ret;
    switch (nrargs) {
        case 1:
            ret = iiExprArith1(&(singres.obj),sing[0].destructiveuse(),
                               INT_INTOBJ(op));
            break;
        case 2:
            sing[0].obj.next = NULL;
            ret = iiExprArith2(&(singres.obj),sing[0].destructiveuse(),
                               INT_INTOBJ(op),
                               sing[1].destructiveuse());
            break;
        case 3:
            sing[0].obj.next = NULL;
            sing[1].obj.next = NULL;
            ret = iiExprArith3(&(singres.obj),INT_INTOBJ(op),
                               sing[0].destructiveuse(),
                               sing[1].destructiveuse(),
                               sing[2].destructiveuse());
            break;
        default:
            for (j = 1;j < nrargs;j++) {
                sing[j].needcleanup = false;
                // The linked list takes care of all cleanup automatically
            }
            ret = iiExprArithM(&(singres.obj),sing[0].destructiveuse(),
                               INT_INTOBJ(op));
            break;
    }
    LastSingularOutput = SPrintEnd();
    if (ret) {
        singres.obj.CleanUp(r);
        return Fail;
    }
    singres.rnr = rnr;
    singres.needcleanup = true;
    return singres.gapwrap();
}

