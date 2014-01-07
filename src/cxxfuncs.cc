//////////////////////////////////////////////////////////////////////////////
/**
@file cxxfuncs.cc
This file contains all of the code that deals with C++ libraries.
**/
//////////////////////////////////////////////////////////////////////////////

#include "libsing.h"
#include "singobj.h"
#include "lowlevel_mappings.h"

#include <coeffs/longrat.h>
#include <coeffs/bigintmat.h>
#include <kernel/syz.h>
#include <Singular/ipid.h>
#include <Singular/lists.h>

#include <assert.h>

#include <vector>

#ifdef HAVE_FACTORY
int mmInit(void) {return 1; } // ? due to SINGULAR!!!...???
#endif


// The following should be in rational.h but isn't (as of GAP 4.7.2):
#ifndef NUM_RAT
#define NUM_RAT(rat)    ADDR_OBJ(rat)[0]
#define DEN_RAT(rat)    ADDR_OBJ(rat)[1]
#endif



extern int inerror; // from Singular/grammar.cc

static void _SI_ErrorCallback(const char *st);
static Obj NEW_SINGOBJ_ZERO_ONE(UInt type, ring cxx, Obj zero, Obj one);
static Obj gapwrap(sleftv &obj, Obj rr);


/* We add hooks to the wrapper functions to call a garbage collection
   by GASMAN if more than a threshold of memory is allocated by omalloc  */
static long gc_omalloc_threshold = 1000000L;
//static long gcfull_omalloc_threshold = 4000000L;

static int GCCOUNT = 0;

static inline void possiblytriggerGC(void)
{
    if ((om_Info.CurrentBytesFromValloc) > gc_omalloc_threshold) {
        if (GCCOUNT == 10) {
            GCCOUNT = 0;
            CollectBags(0,1);
        } else {
            GCCOUNT++;
            CollectBags(0,0);
        }
        //printf("\nGC: %ld -> ",gc_omalloc_threshold);
        gc_omalloc_threshold = 2 * om_Info.CurrentBytesFromValloc;
        //printf("%ld \n",gc_omalloc_threshold); fflush(stdout);
    }
}

// get omalloc statistics
Obj Func_SI_OmPrintInfo( Obj self )
{
    omPrintInfo(stdout);
    return NULL;
}

Obj Func_SI_OmCurrentBytes( Obj self )
{
    omUpdateInfo();
    return INTOBJ_INT(om_Info.CurrentBytesSystem);
}

//! Wrap a singular object that is not ring dependent inside GAP object.
//!
//! \param[in] type  the type of the singular object
//! \param[in] cxx   point to the singular object
//! \return  a GAP object wrapping the singular object
Obj NEW_SINGOBJ(UInt type, void *cxx)
{
    possiblytriggerGC();
    Obj tmp = NewBag(T_SINGULAR, 2*sizeof(Obj));
    SET_TYPE_SINGOBJ(tmp,type);
    SET_FLAGS_SINGOBJ(tmp,0u);
    SET_CXX_SINGOBJ(tmp,cxx);
    return tmp;
}

//! Wrap a ring-dependent singular object inside GAP object.
//!
//! \param[in] type  the type of the singular object
//! \param[in] cxx   point to the singular object
//! \param[in] ring  a GAP-wrapped singular ring
//! \return  a GAP object wrapping the singular object
Obj NEW_SINGOBJ_RING(UInt type, void *cxx, Obj ring)
{
    possiblytriggerGC();
    Obj tmp = NewBag(T_SINGULAR, 4*sizeof(Obj));
    SET_TYPE_SINGOBJ(tmp,type);
    SET_FLAGS_SINGOBJ(tmp,0u);
    SET_CXX_SINGOBJ(tmp,cxx);
    SET_RING_SINGOBJ(tmp,ring);
    if (ring)
        SET_CXXRING_SINGOBJ(tmp,(void *) CXX_SINGOBJ(ring));
    return tmp;
}

//! Wrap a ring or qring inside GAP object.
//!
//! Optionally allows setting zero and one elements for that ring,
//! which GAP operations like Zero() and One() will return.
//!
//! \param[in] type  the type of the singular object
//! \param[in] cxx   point to the singular object
//! \param[in] zero  a GAP-wrapped element of the (q)ring, may be NULL
//! \param[in] one   a GAP-wrapped element of the (q)ring, may be NULL
//! \return  a GAP object wrapping the singular (q)ring
Obj NEW_SINGOBJ_ZERO_ONE(UInt type, ring r, Obj zero, Obj one)
{
    // Check if the ring has already been wrapped.
    if (r->ext_ref != 0) {
        // TODO: In the future, if we detect a wrapper, simply return that:
        //   return (Obj)r->ext_ref;
        // But right now, this should never happen, so instead use this for
        // another paranoid check:
        ErrorQuit("NEW_SINGOBJ_ZERO_ONE: Singular ring already has a GAP wrapper",0L,0L);
    }
    possiblytriggerGC();
    Obj tmp = NewBag(T_SINGULAR, 4*sizeof(Obj));
    SET_TYPE_SINGOBJ(tmp,type);
    SET_FLAGS_SINGOBJ(tmp,0u);
    SET_CXX_SINGOBJ(tmp,r);
    SET_ZERO_SINGOBJ(tmp,zero);
    SET_ONE_SINGOBJ(tmp,one);
    // store ref to GAP wrapper in Singular ring
    r->ext_ref = tmp;
    return tmp;
}

//! Convenience method for accessing the singular ring of a
//! a GAP-wrapped ring-dependent singular object.
inline ring SINGRING_SINGOBJ( Obj obj )
{
    return (ring) CXXRING_SINGOBJ( obj );
}


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

/// Wrap the content of a Singular interpreter object in a GAP object.
static Obj gapwrap(sleftv &obj, Obj rr)
{
    if (rr == 0 && obj.RingDependend()) {
        if (currRing == 0)
            ErrorQuit("Result is ring dependent but can't figure out what the ring should be",0L,0L);
        if (currRing->ext_ref == 0)
            NEW_SINGOBJ_ZERO_ONE(SINGTYPE_RING_IMM,currRing,NULL,NULL);
        rr = (Obj)currRing->ext_ref;
        if (currRing != (ring) CXX_SINGOBJ(rr))
            ErrorQuit("Singular ring with invalid GAP wrapper pointer encountered",0L,0L);
    }

// HACK to work around problems with IDHDL pointing to an entry of a matrix
// TODO: do we need to worry about attributes in this case??!
#define OBJ_COPY_OR_REF(obj) \
    (obj.rtyp != IDHDL ? obj.Data() : obj.CopyD())

    Obj res;
    switch (obj.Typ()) {
        case NONE:
            return True;
        case INT_CMD:
            return ObjInt_Int((long) (obj.Data()));
        case NUMBER_CMD:
            res = NEW_SINGOBJ_RING(SINGTYPE_NUMBER_IMM,OBJ_COPY_OR_REF(obj),rr);
            break;
        case POLY_CMD:
            res = NEW_SINGOBJ_RING(SINGTYPE_POLY,OBJ_COPY_OR_REF(obj),rr);
            break;
        case INTVEC_CMD:
            res = NEW_SINGOBJ(SINGTYPE_INTVEC,OBJ_COPY_OR_REF(obj));
            break;
        case INTMAT_CMD:
            res = NEW_SINGOBJ(SINGTYPE_INTMAT,OBJ_COPY_OR_REF(obj));
            break;
        case VECTOR_CMD:
            res = NEW_SINGOBJ_RING(SINGTYPE_VECTOR,OBJ_COPY_OR_REF(obj),rr);
            break;
        case IDEAL_CMD:
            res = NEW_SINGOBJ_RING(SINGTYPE_IDEAL,OBJ_COPY_OR_REF(obj),rr);
            break;
        case BIGINT_CMD:
            res = NEW_SINGOBJ(SINGTYPE_BIGINT_IMM,OBJ_COPY_OR_REF(obj));
            break;
        case BIGINTMAT_CMD:
            res = NEW_SINGOBJ(SINGTYPE_BIGINTMAT,OBJ_COPY_OR_REF(obj));
            break;
        case MATRIX_CMD:
            res = NEW_SINGOBJ_RING(SINGTYPE_MATRIX,OBJ_COPY_OR_REF(obj),rr);
            break;
        case LIST_CMD:
            res = NEW_SINGOBJ_RING(SINGTYPE_LIST,OBJ_COPY_OR_REF(obj),rr);
            break;
        case LINK_CMD:
            res = NEW_SINGOBJ(SINGTYPE_LINK_IMM,OBJ_COPY_OR_REF(obj));
            break;
        case RING_CMD:
            res = NEW_SINGOBJ_ZERO_ONE(SINGTYPE_RING_IMM,(ring)OBJ_COPY_OR_REF(obj),NULL,NULL);
            break;
        case QRING_CMD:
            res = NEW_SINGOBJ_ZERO_ONE(SINGTYPE_QRING_IMM,(ring)OBJ_COPY_OR_REF(obj),NULL,NULL);
            break;
        case RESOLUTION_CMD:
            res = NEW_SINGOBJ_RING(SINGTYPE_RESOLUTION_IMM,OBJ_COPY_OR_REF(obj),rr);
            break;
        case STRING_CMD:
            res = NEW_SINGOBJ(SINGTYPE_STRING,OBJ_COPY_OR_REF(obj));
            break;
        case MAP_CMD:
            res = NEW_SINGOBJ_RING(SINGTYPE_MAP_IMM,OBJ_COPY_OR_REF(obj),rr);
            break;
        case MODUL_CMD:
            res = NEW_SINGOBJ_RING(SINGTYPE_MODULE,OBJ_COPY_OR_REF(obj),rr);
            break;
        default:
            obj.CleanUp(rr ? (ring)CXX_SINGOBJ(rr) : 0);
            return False;
    }
    if (obj.flag)
        SET_FLAGS_SINGOBJ(res,obj.flag);
    if (obj.attribute) {
        SET_ATTRIB_SINGOBJ(res,(void *) obj.attribute);
        obj.attribute = NULL;
    }
    obj.data = NULL;
    return res;
}


// The following function is called from the garbage collector, it
// needs to free the underlying singular object. Since objects are
// wrapped only once, this is safe. Note in particular that proxy
// objects do not have TNUM T_SINGULAR and thus are not taking part
// in this freeing scheme. They do not actually hold a direct
// reference to a singular object anyway.

static ring *SingularRingsToCleanup = NULL;
static int SRTC_nr = 0;
static int SRTC_capacity = 0;

static void AddSingularRingToCleanup(ring r)
{
    if (SingularRingsToCleanup == NULL) {
        SingularRingsToCleanup = (ring *) malloc(100*sizeof(ring));
        SRTC_nr = 0;
        SRTC_capacity = 100;
    } else if (SRTC_nr == SRTC_capacity) {
        SRTC_capacity *= 2;
        SingularRingsToCleanup = (ring *) realloc(SingularRingsToCleanup,
                                 SRTC_capacity*sizeof(ring));
    }
    SingularRingsToCleanup[SRTC_nr++] = r;
}

static TNumCollectFuncBags oldpostGCfunc = NULL;
// From the GAP kernel, not exported there:
extern TNumCollectFuncBags BeforeCollectFuncBags;
extern TNumCollectFuncBags AfterCollectFuncBags;

static void SingularRingCleaner(void)
{
    int i;
    for (i = 0; i < SRTC_nr; i++) {
        rKill( SingularRingsToCleanup[i] );
        // Pr("killed a ring\n",0L,0L);
    }
    SRTC_nr = 0;
    oldpostGCfunc();
}

void InstallPrePostGCFuncs(void)
{
    TNumCollectFuncBags oldpreGCfunc = BeforeCollectFuncBags;
    oldpostGCfunc = AfterCollectFuncBags;

    InitCollectFuncBags(oldpreGCfunc, SingularRingCleaner);
}

//! Free a given T_SINGULAR object. It is registered using InitFreeFuncBag
//!  and GASMAN invokes it as needed.
void _SI_FreeFunc(Obj o)
{
    UInt gtype = TYPE_SINGOBJ(o);
    void *data = CXX_SINGOBJ(o);
    attr a = (attr)ATTRIB_SINGOBJ(o);
    ring r = HasRingTable[gtype] ? SINGRING_SINGOBJ(o) : 0;

    if (a) {
        a->killAll(r);
    }

    switch (gtype) {
        case SINGTYPE_QRING:
        case SINGTYPE_QRING_IMM:
        case SINGTYPE_RING:
        case SINGTYPE_RING_IMM:
            // Pr("scheduled a ring for killing\n",0L,0L);
            AddSingularRingToCleanup((ring) data);
            break;
        case SINGTYPE_BIGINT:
        case SINGTYPE_BIGINT_IMM: {
            number n = (number)data;
            nlDelete(&n,NULL);
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
        case SINGTYPE_LINK:
        case SINGTYPE_LINK_IMM:
            // FIXME: later: slKill( (si_link)data);
            break;
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
            ErrorQuit("_SI_FreeFunc: unsupported gtype",0L,0L);
            break;
    }
}

/// The following function is the marking function for the garbage
/// collector for T_SINGULAR objects. In the current implementation
/// this function is not actually needed.
void _SI_ObjMarkFunc(Bag o)
{
    Bag *ptr;
    Int gtype = TYPE_SINGOBJ((Obj) o);
    if (HasRingTable[gtype]) {
        ptr = PTR_BAG(o);
        MARK_BAG(ptr[2]);
    } else if (/*  gtype == SINGTYPE_RING ||  */
        gtype == SINGTYPE_RING_IMM ||
        /* gtype == SINGTYPE_QRING ||  */
        gtype == SINGTYPE_QRING_IMM) {
        ptr = PTR_BAG(o);
        MARK_BAG(ptr[2]);   // Mark zero
        MARK_BAG(ptr[3]);   // Mark one
    }
#if 0
    // this is now old and outdated.
    // Not necessary, since singular objects do not have GAP subobjects!
    Bag *ptr;
    Bag sub;
    UInt i;
    if (SIZE_BAG(o) > 2*sizeof(Bag)) {
        ptr = PTR_BAG(o);
        for (i = 2; i < SIZE_BAG(o)/sizeof(Bag); i++) {
            sub = ptr[i];
            MARK_BAG( sub );
        }
    }
#endif
}

// The following functions are implementations of functions which
// appear on the GAP level. There are a lot of constructors amongst
// them:

/// Installed as SI_ring method
Obj Func_SI_ring(Obj self, Obj charact, Obj names, Obj orderings)
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
    for (i = 1; i <= nrvars; i++) {
        if (!IS_STRING_REP(ELM_LIST(names,i))) {
            ErrorQuit("Variable names must be strings",0L,0L);
            return Fail;
        }
    }

    // First check that the orderings cover exactly all variables:
    covered = 0;
    nrords = LEN_LIST(orderings);
    for (i = 1; i <= nrords; i++) {
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
            for (j = 1; j <= LEN_LIST(tmp2); j++) {
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
    for (i = 0; i < nrvars; i++)
        array[i] = omStrDup(CSTR_STRING(ELM_LIST(names,i+1)));

    // Now allocate int lists for the orderings:
    ord = (int *) omalloc(sizeof(int) * (nrords+1));
    ord[nrords] = 0;
    block0 = (int *) omalloc(sizeof(int) * (nrords+1));
    block1 = (int *) omalloc(sizeof(int) * (nrords+1));
    wvhdl = (int **) omAlloc0(sizeof(int *) * (nrords+1));
    covered = 0;
    for (i = 0; i < nrords; i++) {
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
            for (j = 0; j < LEN_LIST(tmp2); j++) {
                wvhdl[i][j] = (int) (INT_INTOBJ(ELM_LIST(tmp2,j+1)));
            }
        }
    }

    ring r = rDefault(INT_INTOBJ(charact),nrvars,array,
                      nrords,ord,block0,block1,wvhdl);
    r->ref++;

    tmp = NEW_SINGOBJ_ZERO_ONE(SINGTYPE_RING_IMM,r,NULL,NULL);
    return tmp;
}

/// Installed as SI_ring method
Obj FuncSI_ring_of_singobj( Obj self, Obj singobj )
{
    if (TNUM_OBJ(singobj) != T_SINGULAR)
        ErrorQuit("argument must be singular object.",0L,0L);
    Int gtype = TYPE_SINGOBJ(singobj);
    if (HasRingTable[gtype]) {
        return RING_SINGOBJ(singobj);
    } else if (/* gtype == SINGTYPE_RING || */
        gtype == SINGTYPE_RING_IMM ||
        /* gtype == SINGTYPE_QRING || */
        gtype == SINGTYPE_QRING_IMM) {
        return singobj;
    } else {
        ErrorQuit("argument must have associated singular ring.",0L,0L);
        return Fail;
    }
}

// TODO: SI_Indeterminates is only used by examples, do we still need it? For what?
Obj FuncSI_Indeterminates(Obj self, Obj rr)
{
    Obj res;
    /* check arg */
    if (! ISSINGOBJ(SINGTYPE_RING_IMM, rr))
        ErrorQuit("argument must be Singular ring.",0L,0L);

    ring r = (ring) CXX_SINGOBJ(rr);
    UInt nrvars = rVar(r);
    UInt i;
    Obj tmp;

    if (r != currRing) rChangeCurrRing(r);

    res = NEW_PLIST(T_PLIST_DENSE,nrvars);
    for (i = 1; i <= nrvars; i++) {
        poly p = p_ISet(1,r);
        pSetExp(p,i,1);
        pSetm(p);
        tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY,p,rr);
        SET_ELM_PLIST(res,i,tmp);
        CHANGED_BAG(res);
    }
    SET_LEN_PLIST(res,nrvars);

    return res;
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

static int ParsePolyList(ring r, const char *&st, int expected, poly *&res)
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

/// Installed as SI_ideal method
Obj Func_SI_ideal_from_String(Obj self, Obj rr, Obj st)
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
    if (r != currRing) rChangeCurrRing(r);
    const char *p = CSTR_STRING(st);
    poly *polylist;
    Int len = ParsePolyList(r, p, 100, polylist);
    ideal id = idInit(len,1);
    Int i;
    for (i = 0; i < len; i++) id->m[i] = polylist[i];
    omFree(polylist);
    return NEW_SINGOBJ_RING(SINGTYPE_IDEAL,id,rr);
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

/// Installed as SI_bigint method
Obj Func_SI_bigint(Obj self, Obj nr)
{
    return NEW_SINGOBJ(SINGTYPE_BIGINT_IMM,_SI_BIGINT_FROM_GAP(nr));
}

/// Used for bigint ViewString method.
// TODO: get rid of _SI_Intbigint and use SI_ToGAP instead ?
Obj Func_SI_Intbigint(Obj self, Obj nr)
{
    number n = (number) CXX_SINGOBJ(nr);
    return _SI_BIGINT_OR_INT_TO_GAP(n);
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


/// Installed as SI_number method
Obj Func_SI_number(Obj self, Obj rr, Obj nr)
{
    return NEW_SINGOBJ_RING(SINGTYPE_NUMBER_IMM,
                            _SI_NUMBER_FROM_GAP((ring) CXX_SINGOBJ(rr), nr),rr);
}

/// Installed as SI_intvec method
Obj Func_SI_intvec(Obj self, Obj l)
{
    if (!IS_LIST(l)) {
        ErrorQuit("l must be a list",0L,0L);
        return Fail;
    }
    UInt len = LEN_LIST(l);
    UInt i;
    intvec *iv = new intvec(len);
    for (i = 1; i <= len; i++) {
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
    return NEW_SINGOBJ(SINGTYPE_INTVEC_IMM,iv);
}

/// Used for intvec ViewString method.
// TODO: get rid of _SI_Plistintvec and use SI_ToGAP instead ?
Obj Func_SI_Plistintvec(Obj self, Obj iv)
{
    if (!(ISSINGOBJ(SINGTYPE_INTVEC,iv) || ISSINGOBJ(SINGTYPE_INTVEC_IMM,iv))) {
        ErrorQuit("iv must be a singular intvec", 0L, 0L);
        return Fail;
    }
    intvec *i = (intvec *) CXX_SINGOBJ(iv);
    UInt len = i->length();
    Obj ret = NEW_PLIST(T_PLIST_CYC,len);
    UInt j;
    for (j = 1; j <= len; j++) {
        SET_ELM_PLIST(ret,j,ObjInt_Int( (Int) ((*i)[j-1])));
        CHANGED_BAG(ret);
    }
    SET_LEN_PLIST(ret,len);
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

/// Installed as SI_ideal method
Obj Func_SI_ideal_from_els(Obj self, Obj l)
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
    Obj t = NULL;
    ring r = NULL;
    for (i = 1; i <= len; i++) {
        t = ELM_LIST(l,i);
        if (!(ISSINGOBJ(SINGTYPE_POLY,t) || ISSINGOBJ(SINGTYPE_POLY_IMM,t))) {
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
    ring r = SINGRING_SINGOBJ(a);
    if (r != currRing) rChangeCurrRing(r);   // necessary?
    number bb = _SI_NUMBER_FROM_GAP(r,b);
    poly aa = pp_Mult_nn((poly) CXX_SINGOBJ(a),bb,r);
    n_Delete(&bb,r);
    Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY,aa,RING_SINGOBJ(a));
    return tmp;
}

// The following functions allow access to the singular interpreter.
// They are exported to the GAP level.

//! This global is used to store the return value of SPrintEnd
static char *_SI_LastOutputBuf = NULL;

static void ClearLastOutputBuf() {
    if (_SI_LastOutputBuf) {
        omFree(_SI_LastOutputBuf);
        _SI_LastOutputBuf = NULL;
    }
}

static void StartPrintCapture() {
    ClearLastOutputBuf();
    SPrintStart();
    errorreported = 0;
}

static void EndPrintCapture() {
    _SI_LastOutputBuf = SPrintEnd();
}

Obj FuncSI_LastOutput(Obj self)
{
    if (_SI_LastOutputBuf) {
        UInt len = (UInt) strlen(_SI_LastOutputBuf);
        Obj tmp = NEW_STRING(len);
        SET_LEN_STRING(tmp,len);
        memcpy(CHARS_STRING(tmp),_SI_LastOutputBuf,len+1);
        ClearLastOutputBuf();
        return tmp;
    } else return Fail;
}

void _SI_ErrorCallback(const char *st)
{
    UInt len = (UInt) strlen(st);
    if (IS_STRING(SI_Errors)) {
        char *p;
        UInt oldlen = GET_LEN_STRING(SI_Errors);
        GROW_STRING(SI_Errors,oldlen+len+2);
        p = CSTR_STRING(SI_Errors);
        memcpy(p+oldlen,st,len);
        p[oldlen+len] = '\n';
        p[oldlen+len+1] = 0;
        SET_LEN_STRING(SI_Errors,oldlen+len+1);
    }
}

Obj Func_SI_INIT_INTERPRETER(Obj self, Obj path)
{
    // init path names etc.
    siInit(reinterpret_cast<char*>(CHARS_STRING(path)));
    currentVoice=feInitStdin(NULL);
    WerrorS_callback = _SI_ErrorCallback;
    return NULL;
}

Obj Func_SI_EVALUATE(Obj self, Obj st)
{
    UInt len = GET_LEN_STRING(st);
    char *ost = (char *) omalloc((size_t) len + 10);
    memcpy(ost,reinterpret_cast<char*>(CHARS_STRING(st)),len);
    memcpy(ost+len,"return();",9);
    ost[len+9] = 0;
    ClearLastOutputBuf();
    SPrintStart();
    myynest = 1;
    Int err = (Int) iiAllStart(NULL,ost,BT_proc,0);
    inerror = 0;
    errorreported = 0;
    EndPrintCapture();
    // Note that iiEStart uses omFree internally to free the string ost
    return ObjInt_Int((Int) err);
}

/* if needed, handle more cases */
Obj FuncSI_ValueOfVar(Obj self, Obj name)
{
    Int len;
    Obj tmp,tmp2;
    intvec *v;
    int i,j,k;
    Int rows, cols;
    /* number n;   */

    idhdl h = ggetid(reinterpret_cast<char*>(CHARS_STRING(name)));
    if (h == NULL) return Fail;
    switch (IDTYP(h)) {
        case INT_CMD:
            return ObjInt_Int( (Int) (IDINT(h)) );
        case STRING_CMD:
            len = (Int) strlen(IDSTRING(h));
            tmp = NEW_STRING(len);
            SET_LEN_STRING(tmp,len);
            memcpy(CHARS_STRING(tmp),IDSTRING(h),len+1);
            return tmp;
        case INTVEC_CMD:
            v = IDINTVEC(h);
            len = (Int) v->length();
            tmp = NEW_PLIST(T_PLIST_CYC,len);
            SET_LEN_PLIST(tmp,len);
            for (i = 0; i < len; i++) {
                SET_ELM_PLIST(tmp,i+1,ObjInt_Int( (Int) ((*v)[i]) ));
                CHANGED_BAG(tmp); // ObjInt_Int can trigger garbage collections
            }
            return tmp;
        case INTMAT_CMD:
            v = IDINTVEC(h);
            rows = (Int) v->rows();
            cols = (Int) v->cols();
            tmp = NEW_PLIST(T_PLIST_DENSE,rows);
            SET_LEN_PLIST(tmp,rows);
            k = 0;
            for (i = 0; i < rows; i++) {
                tmp2 = NEW_PLIST(T_PLIST_CYC,cols);
                SET_LEN_PLIST(tmp2,cols);
                SET_ELM_PLIST(tmp,i+1,tmp2);
                CHANGED_BAG(tmp); // ObjInt_Int can trigger garbage collections
                for (j = 0; j < cols; j++) {
                    SET_ELM_PLIST(tmp2,j+1,ObjInt_Int( (Int) ((*v)[k++])));
                    CHANGED_BAG(tmp2);
                }
            }
            return tmp;
        case BIGINT_CMD:
            /* n = IDBIGINT(h); */
            return Fail;
        default:
            return Fail;
    }
}

Obj Func_SI_SingularProcs(Obj self)
{
    Obj l;
    Obj n;
    int len = 0;
    UInt slen;
    Int i;
    idhdl x = IDROOT;
    while (x) {
        if (x->typ == PROC_CMD) len++;
        x = x->next;
    }
    l = NEW_PLIST(T_PLIST_DENSE,len);
    SET_LEN_PLIST(l,0);
    x = IDROOT;
    i = 1;
    while (x) {
        if (x->typ == PROC_CMD) {
            slen = (UInt) strlen(x->id);
            n = NEW_STRING(slen);
            SET_LEN_STRING(n,slen);
            memcpy(CHARS_STRING(n),x->id,slen+1);
            SET_ELM_PLIST(l,i,n);
            SET_LEN_PLIST(l,i);
            CHANGED_BAG(l);
            i++;
        }
        x = x->next;
    }
    return l;
}

/**
 * Tries to transform a singular object to a GAP object.
 * Currently does small integers and strings.
 */
Obj FuncSI_ToGAP(Obj self, Obj singobj)
{
    if (TNUM_OBJ(singobj) != T_SINGULAR) {
        ErrorQuit("singobj must be a wrapped Singular object",0L,0L);
        return Fail;
    }
    switch (TYPE_SINGOBJ(singobj)) {
        case SINGTYPE_STRING:
        case SINGTYPE_STRING_IMM: {
            char *st = (char *) CXX_SINGOBJ(singobj);
            UInt len = (UInt) strlen(st);
            Obj tmp = NEW_STRING(len);
            SET_LEN_STRING(tmp,len);
            memcpy(CHARS_STRING(tmp),st,len+1);
            return tmp;
        }
        case SINGTYPE_INT:
        case SINGTYPE_INT_IMM: {
            Int i = (Int) CXX_SINGOBJ(singobj);
            return INTOBJ_INT(i);
        }
        case SINGTYPE_BIGINT:
        case SINGTYPE_BIGINT_IMM: {
            // TODO
            number n = (number) CXX_SINGOBJ(singobj);
            return _SI_BIGINT_OR_INT_TO_GAP(n);
        }
        default:
            return Fail;
    }
}


static std::vector<idhdl> *param_idhdls = 0;

static idhdl getSingularIdhdl(int i) {
    assert(i >= 0 && i < 256);
    
    if (param_idhdls == 0) {
        param_idhdls = new std::vector<idhdl>(10, (idhdl)0);
    }

    if (i >= param_idhdls->size())
        param_idhdls->resize(i+1);
    if ((*param_idhdls)[i] == 0) {
        char buf[20];
        // use spaces in variable name to make sure the variable is
        // never generated on the interpreter level
        sprintf(buf, " libsing param %d ", (i+1));
        idhdl h = enterid(omStrDup(buf), 0, INT_CMD, &IDROOT, FALSE, FALSE);
        IDDATA(h) = 0;
        (*param_idhdls)[i] = h;
    }
    
    return (*param_idhdls)[i];
}

//! Auxiliary class for creating temporary Singular interpreter
//! handles ("idhdl"), referencing Singular objects that are to
//! be passed to Singular interpreter or library functions.
class SingularIdHdl {
public:
    idhdl h;
    SingObj obj;

public:
    SingularIdHdl() : h(0) {
    }

    void set(int i, Obj input, Obj &extrr, ring &extr) {
        assert(h == 0);

        obj.init(input, extrr, extr);
        if (obj.error)
            return;
        
        h = getSingularIdhdl(i);
        IDTYP(h) = obj.obj.Typ();
        IDDATA(h) = (char *)obj.obj.Data();
        // We don't need to worry about incrementing reference counters
        // (for rings, proc, link, packages) here.
    }

    ~SingularIdHdl() {
        cleanup();
    }

    void cleanup() {
        obj.cleanup();
        if (h != 0) {
            // Hack to avoid data loss if the idhdl ever gets freed
            IDTYP(h) = INT_CMD;
            IDDATA(h) = 0;
        }
    }
    
};

class SingularIdHdlWithWrap : public SingularIdHdl {
public:
    sleftv wrap;

    SingularIdHdlWithWrap(int i, Obj input, Obj &extrr, ring &extr) {
        set(i, input, extrr, extr);

        wrap.Init();
        wrap.rtyp = IDHDL;
        wrap.data = h;
    }
    
    leftv ptr() {
        return &wrap;
    }
};


// The following functions allow access to all functions of the
// Singular C++ library that the Singular interpreter can call.
// They do not provide a fast path into the library, because they
// use some Singular interpreter infrastructure, in particular, all
// function arguments are wrapped by some Singular interpreter data
// structure.

Obj Func_SI_CallFunc1(Obj self, Obj op, Obj a)
{
    Obj rr = NULL;
    ring r = NULL;

    SingularIdHdlWithWrap sing(0, a, rr, r);
    if (sing.obj.error) { ErrorQuit(sing.obj.error, 0L, 0L); }

    StartPrintCapture();
    sleftv result;
    BOOLEAN ret = iiExprArith1(&result, sing.ptr(), INT_INTOBJ(op));
    EndPrintCapture();
    if (ret) {
        result.CleanUp(r);
        return Fail;
    }

    return gapwrap(result, rr);
}

Obj Func_SI_CallFunc2(Obj self, Obj op, Obj a, Obj b)
{
    Obj rr = NULL;
    ring r = NULL;

    SingularIdHdlWithWrap singa(0, a, rr, r);
    if (singa.obj.error) { ErrorQuit(singa.obj.error, 0L, 0L); }
    SingularIdHdlWithWrap singb(1, b, rr, r);
    if (singb.obj.error) {
        singa.cleanup();
        ErrorQuit(singb.obj.error, 0L, 0L);
    }

    StartPrintCapture();
    sleftv result;
    BOOLEAN ret = iiExprArith2(&result, singa.ptr(), INT_INTOBJ(op), singb.ptr());
    EndPrintCapture();
    if (ret) {
        result.CleanUp(r);
        return Fail;
    }
    return gapwrap(result, rr);
}

Obj Func_SI_CallFunc3(Obj self, Obj op, Obj a, Obj b, Obj c)
{
    Obj rr = NULL;
    ring r = NULL;

    SingularIdHdlWithWrap singa(0, a, rr, r);
    if (singa.obj.error) { ErrorQuit(singa.obj.error, 0L, 0L); }
    SingularIdHdlWithWrap singb(1, b, rr, r);
    if (singb.obj.error) {
        singa.cleanup();
        ErrorQuit(singb.obj.error, 0L, 0L);
    }
    SingularIdHdlWithWrap singc(2, c, rr, r);
    if (singc.obj.error) {
        singa.cleanup();
        singb.cleanup();
        ErrorQuit(singc.obj.error, 0L, 0L);
    }

    StartPrintCapture();
    sleftv result;
    BOOLEAN ret = iiExprArith3(&result,INT_INTOBJ(op),
                               singa.ptr(),
                               singb.ptr(),
                               singc.ptr());
    EndPrintCapture();
    if (ret) {
        result.CleanUp(r);
        return Fail;
    }
    return gapwrap(result, rr);
}

// This class take a GAP list of objects, put each entry into an idhdl,
// and then creates a linked list of sleftv referencing those idhdl.
// Putting this into a simple class simplifies correct memory
// managment a bit (and avoids issues with idhdl being reset before
// gapwrap() had a chance to reference them.
// It also makes it easy to reuse this code.
class WrapMultiArgs {
public:
    SingularIdHdl *sing;
    sleftv s_arg;
    const char *error;
    
    WrapMultiArgs(Obj arg, Obj &rr, ring &r) : sing(0), error(0) {
        int i;
        int nrargs = (int) LEN_PLIST(arg);
        SingularIdHdl *sing = new SingularIdHdl[nrargs];
        for (i = 0; i < nrargs; i++) {
            sing[i].set(i, ELM_PLIST(arg, i + 1), rr, r);
            if (sing[i].obj.error) {
                error = sing[i].obj.error;
                delete [] sing;
                sing = 0;
                return;
            }
        }

        // Build a linked list of pointers to the idhdl objects.
        // It will be freed by iiExprArithM
        leftv cur = &s_arg;
        s_arg.Init();
        for (i = 0; i < nrargs; i++) {
            cur->rtyp = IDHDL;
            cur->data = sing[i].h;
            if (i < nrargs - 1)
                cur->next = (leftv)omAlloc0Bin(sleftv_bin);
            cur = cur->next;
        }
    }
    
    ~WrapMultiArgs() {
        delete [] sing;
    }
};

Obj Func_SI_CallFuncM(Obj self, Obj op, Obj arg)
{
    Obj rr = NULL;
    ring r = NULL;

    WrapMultiArgs wrap(arg, rr, r);
    if (wrap.error) ErrorQuit(wrap.error, 0L, 0L);

    StartPrintCapture();
    sleftv result;
    BOOLEAN ret = iiExprArithM(&result, &wrap.s_arg, INT_INTOBJ(op));
    EndPrintCapture();

    if (ret) {
        result.CleanUp(r);
        return Fail;
    }
    return gapwrap(result, rr);
}

Obj FuncSI_SetCurrRing(Obj self, Obj rr)
{
    if (TNUM_OBJ(rr) != T_SINGULAR ||
        (TYPE_SINGOBJ(rr) != SINGTYPE_RING_IMM &&
         TYPE_SINGOBJ(rr) != SINGTYPE_QRING_IMM)) {
        ErrorQuit("argument r must be a singular ring",0L,0L);
        return Fail;
    }
    ring r = (ring) CXX_SINGOBJ(rr);
    if (r != currRing) rChangeCurrRing(r);
    return NULL;
}

Obj FuncSI_CallProc(Obj self, Obj name, Obj args)
{
    if (!IsStringConv(name)) {
        ErrorQuit("First argument must be a string.",0L,0L);
        return Fail;
    }
    if (!IS_LIST(args)) {
        ErrorQuit("Second argument must be a list.",0L,0L);
        return Fail;
    }

    idhdl h = ggetid(reinterpret_cast<char*>(CHARS_STRING(name)));
    if (h == NULL) {
        ErrorQuit("Proc %s not found in Singular interpreter.",
                  (Int) CHARS_STRING(name),0L);
        return Fail;
    }

    Obj rr = NULL;
    ring r = NULL;
    int i;
    const char *error;

    int nrargs = (int) LEN_LIST(args);
    SingObj sing1;
    SingObj sing2;
    leftv cur,neu;
// TODO: use SingularIdHdl here, too?!
    if (nrargs > 0) {
        sing1.init(ELM_LIST(args,1),rr,r);
        if (sing1.error) {
            error = sing1.error;
            sing1.cleanup();
            ErrorQuit(error,0L,0L);
            return Fail;
        }
        cur = &(sing1.obj);
        for (i = 2; i <= nrargs; i++) {
            sing2.init(ELM_LIST(args,i),rr,r);
            if (sing2.error) {
                neu = sing1.obj.next;
                sing1.obj.next = NULL;
                sing1.cleanup();
                neu->CleanUp(r);
                error = sing2.error;
                sing2.cleanup();
                ErrorQuit(error,0L,0L);
            }
            neu = (leftv) omalloc( sizeof(sleftv) );
            neu->Init();
            sing2.destructiveuse();
            neu->data = sing2.obj.data;
            neu->rtyp = sing2.obj.rtyp;
            cur->next = neu;
            cur = neu;
        }
        sing1.destructiveuse();
    }
    StartPrintCapture();
    BOOLEAN bool_ret;
    if (r) {
        currRingHdl = enterid("Blabla",0,RING_CMD,&IDROOT,FALSE,FALSE);
        assert(currRingHdl);
        IDRING(currRingHdl) = r;
        r->ref++;
    } else {
        currRingHdl = NULL;
        currRing = NULL;
    }
    iiRETURNEXPR.Init();
    if (nrargs == 0)
        bool_ret = iiMake_proc(h,NULL,NULL);
    else
        bool_ret = iiMake_proc(h,NULL,&(sing1.obj));
    if (r) killhdl(currRingHdl,currPack);
    EndPrintCapture();

    if (bool_ret == TRUE) return Fail;
    leftv ret = &iiRETURNEXPR;
    if (ret->next != NULL) {
        ret->CleanUp(r);
        ErrorQuit("Multiple return values not yet implemented.",0L,0L);
        return Fail;
    }

    return gapwrap(*ret, rr);
}

//////////////// C++ functions for the jump tables ////////////////////

extern "C" Obj ZeroObject(Obj s);
extern "C" Obj OneObject(Obj s);
extern "C" Obj ZeroMutObject(Obj s);
extern "C" Obj OneMutObject(Obj s);

Int IsMutableSingObj(Obj s)
{
    return ((TYPE_SINGOBJ(s)+1) & 1) == 1;
}


void MakeImmutableSingObj(Obj s)
{
    SET_TYPE_SINGOBJ(s,TYPE_SINGOBJ(s) | 1);
}

Obj ZeroSMSingObj(Obj s)
{
    Obj res;
    int gtype = TYPE_SINGOBJ(s);
    //Pr("Zero\n",0L,0L);
    if (gtype == SINGTYPE_RING_IMM || gtype == SINGTYPE_QRING_IMM) {
        res = ZERO_SINGOBJ(s);
        if (res != NULL) return res;
        res = ZeroMutObject(s);  // This makes a mutable zero
        MakeImmutable(res);
        SET_ZERO_SINGOBJ(s,res);
        CHANGED_BAG(s);
        return res;
    }
    if (((gtype + 1) & 1) == 1)    // we are mutable
        return ZeroMutObject(s);
    // Here we are immutable:
    if (HasRingTable[gtype])
        // Rings are always immutable!
        return ZeroSMSingObj(RING_SINGOBJ(s));
    return ZeroObject(s);
}

Obj OneSMSingObj(Obj s)
{
    Obj res;
    int gtype = TYPE_SINGOBJ(s);
    //Pr("One\n",0L,0L);
    if (gtype == SINGTYPE_RING_IMM || gtype == SINGTYPE_QRING_IMM) {
        res = ONE_SINGOBJ(s);
        if (res != NULL) return res;
        res = OneObject(s);   // This is OneMutable and gives us mutable
        MakeImmutable(res);
        SET_ONE_SINGOBJ(s,res);
        CHANGED_BAG(s);
        return res;
    }
    if (((gtype + 1) & 1) == 1)   // we are mutable!
        return OneObject(s);  // This is OneMutable
    // Here we are immutable:
    if (HasRingTable[gtype])
        // Rings are always immutable!
        return OneSMSingObj(RING_SINGOBJ(s));
    return OneMutObject(s);
}

/* this is to test the performance gain, when we avoid the method selection
for \+ of Singular polynomials by a SumFuncs function.
The gain seem pretty small - this was tested with zero polyomials.
So: for the moment we just leave the generic functions in the kernel
tables.   */
/* from GAP kernel */
/*
Obj SumObject(Obj l, Obj r);

Obj SumSingObjs(Obj a, Obj b)
{
    int atype, btype;
    atype = TYPE_SINGOBJ(a);
    btype = TYPE_SINGOBJ(b);
    if ((atype == SINGTYPE_POLY || atype == SINGTYPE_POLY_IMM) &&
        (btype == SINGTYPE_POLY || btype == SINGTYPE_POLY_IMM))    {
       return Func_SI_p_Add_q(NULL, a, b);
    } else {
      return SumObject(a, b);
    }
}
*/
