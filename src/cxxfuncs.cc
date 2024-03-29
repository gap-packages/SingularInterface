// SingularInterface: A GAP interface to Singular
//
// Copyright of SingularInterface belongs to its developers.
// Please refer to the COPYRIGHT file for details.
//
// SPDX-License-Identifier: GPL-2.0-or-later

#include "libsing.h"
#include "lowlevel_mappings.h"
#include "matrix.h"    // for Func_SI_Matintmat / Func_SI_Matbigintmat
#include "number.h"
#include "singobj.h"

#include <cmath>

#include <coeffs/bigintmat.h>
#include <coeffs/longrat.h>
//#include <kernel/syz.h>
#include <Singular/ipid.h>
#include <Singular/lists.h>

// from GAP
extern "C" {
  #include "gasman_intern.h"  // for RegisterAfterCollectFuncBags
}


/* We add hooks to the wrapper functions to call a garbage collection
   by GASMAN if more than a threshold of memory is allocated by omalloc  */
static long gc_omalloc_threshold = 1000000L;
// static long gcfull_omalloc_threshold = 4000000L;

static int GCCOUNT = 0;

static inline void possiblytriggerGC(void)
{
    if ((om_Info.CurrentBytesFromValloc) > gc_omalloc_threshold) {
        if (GCCOUNT == 10) {
            GCCOUNT = 0;
            CollectBags(0, 1);
        }
        else {
            GCCOUNT++;
            CollectBags(0, 0);
        }
        // printf("\nGC: %ld -> ", gc_omalloc_threshold);
        gc_omalloc_threshold = 2 * om_Info.CurrentBytesFromValloc;
        // printf("%ld \n", gc_omalloc_threshold); fflush(stdout);
    }
}

// get omalloc statistics
Obj Func_SI_OmPrintInfo(Obj self)
{
    omPrintInfo(stdout);
    return NULL;
}

Obj Func_SI_OmCurrentBytes(Obj self)
{
    omUpdateInfo();
    return INTOBJ_INT(om_Info.CurrentBytesSystem);
}

//! Wrap a singular object that is not ring dependent inside GAP object.
//!
//! \param[in] type  the type of the singular object
//! \param[in] cxx   pointer to the singular object
//! \return  a GAP object wrapping the singular object
Obj NEW_SINGOBJ(UInt type, void * cxx)
{
    possiblytriggerGC();
    Obj tmp = NewBag(T_SINGULAR, 2 * sizeof(Obj));
    SET_TYPE_SINGOBJ(tmp, type);
    SET_FLAGS_SINGOBJ(tmp, 0u);
    SET_CXX_SINGOBJ(tmp, cxx);
    return tmp;
}

//! Wrap a ring-dependent singular object inside GAP object.
//!
//! \param[in] type  the type of the singular object
//! \param[in] cxx   pointer to the singular object
//! \param[in] r     a singular ring
//! \return  a GAP object wrapping the singular object
Obj NEW_SINGOBJ_RING(UInt type, void * cxx, ring r)
{
    possiblytriggerGC();
    Obj tmp = NewBag(T_SINGULAR, 3 * sizeof(Obj));
    SET_TYPE_SINGOBJ(tmp, type);
    SET_FLAGS_SINGOBJ(tmp, 0u);
    SET_CXX_SINGOBJ(tmp, cxx);
    SET_CXXRING_SINGOBJ(tmp, r);
    return tmp;
}

//! Create a high level wrapper for a (low level) wrapper object
//! for a singular ring.
static Obj makeHighlevelWrapper(Obj rr)
{
    // TODO: Create high level wrapper for ring. For now
    // as a temporary hack, we set the (low level) wrapper
    // itself.
    return rr;
}

Obj UnwrapHighlevelWrapper(Obj obj)
{
    // First we check if this is perhaps a highlevel ring wrapper. We
    // verify that by checking if it has the right member. We could do a
    // more sophisticated check, but for now, this should suffice.
    if (TNUM_OBJ(obj) == T_COMOBJ && IsbPRec(obj, _SI_internalRingRNam)) {
        return ElmPRec(obj, _SI_internalRingRNam);
    }
    return obj;
}

//! Wrap a ring or qring inside GAP object.
//!
//! Optionally allows setting zero and one elements for that ring,
//! which GAP operations like Zero() and One() will return.
//!
//! \param[in] type  the type of the singular object
//! \param[in] r     pointer to the singular ring
//! \param[in] zero  a GAP-wrapped element of the (q)ring, may be NULL
//! \param[in] one   a GAP-wrapped element of the (q)ring, may be NULL
//! \return  a GAP object wrapping the singular (q)ring
Obj NEW_SINGOBJ_ZERO_ONE(UInt type, ring r, Obj zero, Obj one)
{
    // Check if the ring has already been wrapped. In principle, we could
    // then just return ext_ref,
    if (r->ext_ref != 0) {
        ErrorQuit("Oops, Singular ring already wrapped again, please report "
                  "this to SingularInterface team",
                  0L, 0L);
    }
    possiblytriggerGC();
    Obj rr = NewBag(T_SINGULAR, 5 * sizeof(Obj));
    SET_TYPE_SINGOBJ(rr, type);
    SET_FLAGS_SINGOBJ(rr, 0);
    SET_CXX_SINGOBJ(rr, r);
    SET_ZERO_SINGOBJ(rr, zero);
    SET_ONE_SINGOBJ(rr, one);
    Obj high = makeHighlevelWrapper(rr);
    SET_HIWRAP_SINGOBJ(rr, high);

    // store ref to GAP wrapper in Singular ring
    r->ext_ref = rr;
    return high;
}

// The following function is called from the garbage collector, it
// needs to free the underlying singular object. Since objects are
// wrapped only once, this is safe. Note in particular that proxy
// objects do not have TNUM T_SINGULAR and thus are not taking part
// in this freeing scheme. They do not actually hold a direct
// reference to a singular object anyway.

static ring * SingularRingsToCleanup = NULL;
static int    SRTC_nr = 0;
static int    SRTC_capacity = 0;

static void AddSingularRingToCleanup(ring r)
{
    if (SingularRingsToCleanup == NULL) {
        SingularRingsToCleanup = (ring *)malloc(100 * sizeof(ring));
        SRTC_nr = 0;
        SRTC_capacity = 100;
    }
    else if (SRTC_nr == SRTC_capacity) {
        SRTC_capacity *= 2;
        SingularRingsToCleanup = (ring *)realloc(
            SingularRingsToCleanup, SRTC_capacity * sizeof(ring));
    }
    SingularRingsToCleanup[SRTC_nr++] = r;
}

static void SingularRingCleaner(void)
{
    int i;
    for (i = 0; i < SRTC_nr; i++) {
        rKill(SingularRingsToCleanup[i]);
        // Pr("killed a ring\n", 0L, 0L);
    }
    SRTC_nr = 0;
}

void InstallPrePostGCFuncs(void)
{
    RegisterAfterCollectFuncBags(SingularRingCleaner);
}

//! Free a given T_SINGULAR object. It is registered using InitFreeFuncBag
//!  and GASMAN invokes it as needed.
void _SI_FreeFunc(Obj o)
{
    sleftv obj;
    obj.Init();
    int gtype = TYPE_SINGOBJ(o);
    obj.data = CXX_SINGOBJ(o);
    obj.rtyp = GAPtoSingType[gtype];
    obj.flag = FLAGS_SINGOBJ(o);
    obj.attribute = (attr)ATTRIB_SINGOBJ(o);
    ring r = HasRingTable[gtype] ? CXXRING_SINGOBJ(o) : 0;

    switch (gtype) {
    case SINGTYPE_QRING:
    case SINGTYPE_QRING_IMM:
    case SINGTYPE_RING:
    case SINGTYPE_RING_IMM:
        // Pr("scheduled a ring for killing\n", 0L, 0L);
        AddSingularRingToCleanup((ring)obj.data);
        break;
    default:
        obj.CleanUp(r);
    }
}

/// The following function is the marking function for the garbage
/// collector for T_SINGULAR objects.
void _SI_ObjMarkFunc(Bag o)
{
    Int gtype = TYPE_SINGOBJ(o);
    if (HasRingTable[gtype]) {
        ring r = CXXRING_SINGOBJ(o);
        Obj  rr = r ? (Obj)r->ext_ref : 0;
        MarkBag(rr);
    }
    else if (/*  gtype == SINGTYPE_RING ||  */
             gtype == SINGTYPE_RING_IMM ||
             /* gtype == SINGTYPE_QRING ||  */
             gtype == SINGTYPE_QRING_IMM) {
        MarkBag(ZERO_SINGOBJ(o));    // Mark zero
        MarkBag(ONE_SINGOBJ(o));     // Mark one
    }
}


static bool IsIntList(Obj list)
{
    if (!list || !IS_LIST(list))
        return false;

    const int len = LEN_LIST(list);
    for (int j = 1; j <= len; j++) {
        if (!IS_INTOBJ(ELM_LIST(list, j)))
            return false;
    }

    return true;
}

// The following functions are implementations of functions which
// appear on the GAP level. There are a lot of constructors amongst
// them:

/// Installed as SI_ring method
Obj Func_SI_ring(Obj self, Obj charact, Obj names, Obj orderings)
{
    UInt nrvars;
    UInt nrords;
    UInt i;
    Int  j;
    int  covered;
    bool c_ord_is_present = false;

    // Some checks:
    if (!IS_INTOBJ(charact) || !IS_LIST(names) || !IS_LIST(orderings)) {
        ErrorQuit("Need immediate integer and two lists", 0L, 0L);
        return Fail;
    }
    nrvars = LEN_LIST(names);
    if (nrvars == 0) {
        ErrorQuit("Need at least one variable name", 0L, 0L);
        return Fail;
    }
    for (i = 1; i <= nrvars; i++) {
        if (!IS_STRING_REP(ELM_LIST(names, i))) {
            ErrorQuit("Variable names must be strings", 0L, 0L);
            return Fail;
        }
    }

    // First check that the orderings cover exactly all variables:
    covered = 0;
    nrords = LEN_LIST(orderings);
    for (i = 1; i <= nrords; i++) {
        Obj tmp = ELM_LIST(orderings, i);

        if (!IS_LIST(tmp) || (LEN_LIST(tmp) != 1 && LEN_LIST(tmp) != 2)) {
            ErrorQuit("Orderings must be lists of length 1 or 2", 0L, 0L);
            return Fail;
        }

        Obj name = ELM_LIST(tmp, 1);
        Obj spec = (LEN_LIST(tmp) == 2) ? ELM_LIST(tmp, 2) : 0;

        if (!IS_STRING_REP(name)) {
            ErrorQuit("First entry of ordering must be a string", 0L, 0L);
            return Fail;
        }

        Int namelen = GET_LEN_STRING(name);
        if (namelen != 1 && namelen != 2) {
            ErrorQuit(
                "First entry of ordering must be a string of length 1 or 2",
                0L, 0L);
            return Fail;
        }

        const char * nameStr = CSTR_STRING(name);

        if (namelen == 1 && nameStr[0] == 'M') {
            // Matrix orderings: "M" must be followed by an intmat (flattened
            // to an intvec of square length)
            if (!IsIntList(spec)) {
                ErrorQuit("Second entry of ordering of type '%s' must be a "
                          "plain list of integers",
                          (Int)nameStr, 0L);
                return Fail;
            }
            covered += std::sqrt(LEN_LIST(spec));
        }
        else if ((namelen == 1 && nameStr[0] == 'a') ||
                 (namelen == 2 && tolower(nameStr[0]) == 'w')) {
            // wp, Wp, ws, Ws must be followed by an int vector
            // Extra weight vector: "a" followed by intvec, can appear
            // anywhere
            if (!IsIntList(spec)) {
                ErrorQuit("Second entry of ordering of type '%s' must be a "
                          "plain list of integers",
                          (Int)nameStr, 0L);
                return Fail;
            }

            if (0 == strcmp(nameStr, "a")) {
                // Extra weight vector, no extra vars covered
            }
            else {
                covered += LEN_LIST(spec);
            }
        }
        else if (namelen == 1 && tolower(nameStr[0]) == 'c') {
            // Module ordering: at most once a "c" or "C" followed by nothing
            // may appear.
#if 0
            if (spec != 0)  {
                ErrorQuit("Ordering of type '%s' must not be followed by second entry", (Int)nameStr, 0L);
                return Fail;
            }
#endif

            if (c_ord_is_present) {
                ErrorQuit(
                    "At most one ordering of type 'c' or 'C' may be used", 0L,
                    0L);
                return Fail;
            }

            c_ord_is_present = true;
        }
        else {
            // lp, rp, dp, Dp, ls, rs, ds, Ds may be followed by an int
            if (!spec || !IS_INTOBJ(spec)) {
                ErrorQuit("Second entry of ordering of type '%s' must be an "
                          "integer",
                          (Int)nameStr, 0L);
                return Fail;
            }

            covered += INT_INTOBJ(spec);
        }
    }
    if (covered != (int)nrvars) {
        ErrorQuit("Orderings do not cover exactly the variables", 0L, 0L);
        return Fail;
    }

    // Now allocate int lists for the orderings:
    rRingOrder_t * ord = (rRingOrder_t *)omalloc(
        sizeof(rRingOrder_t) * (nrords + 1));    // array of orderings
    ord[nrords] = ringorder_no;
    int * block0 = (int *)omalloc(
        sizeof(int) * (nrords + 1));    // starting position of blocks
    int * block1 = (int *)omalloc(
        sizeof(int) * (nrords + 1));    // ending position of blocks
    int ** wvhdl = (int **)omAlloc0(
        sizeof(int *) * (nrords + 1));    // array of weight vectors
    covered = 0;
    for (i = 0; i < nrords; i++) {
        Obj    tmp = ELM_LIST(orderings, i + 1);
        char * p = omStrDup(CSTR_STRING(ELM_LIST(tmp, 1)));
        ord[i] = rOrderName(p);
        if (ord[i] == ringorder_no) {
            Pr("Warning: Unknown ordering name: %s, assume \"dp\"",
               (Int)(CSTR_STRING(ELM_LIST(tmp, 1))), 0L);
            ord[i] = rOrderName(omStrDup("dp"));
        }
        block0[i] = covered + 1;

        Obj tmp2 = ELM_LIST(tmp, 2);
        if (IS_INTOBJ(tmp2)) {
            block1[i] = covered + INT_INTOBJ(tmp2);
            wvhdl[i] = NULL;
            covered += INT_INTOBJ(tmp2);
        }
        else {    // IS_LIST(tmp2) and consisting of immediate integers
            block1[i] = covered + LEN_LIST(tmp2);
            wvhdl[i] = (int *)omalloc(sizeof(int) * LEN_LIST(tmp2));
            for (j = 0; j < LEN_LIST(tmp2); j++) {
                wvhdl[i][j] = INT_INTOBJ(ELM_LIST(tmp2, j + 1));
            }
        }
    }

    // Now allocate strings for the variable names:
    char ** cnames = (char **)omalloc(sizeof(char *) * nrvars);
    for (i = 0; i < nrvars; i++)
        cnames[i] = CSTR_STRING(ELM_LIST(names, i + 1));

    ring r = rDefault(INT_INTOBJ(charact), nrvars, cnames, nrords, ord,
                      block0, block1, wvhdl);
    r->ref++;

    omFree(cnames);

    r->ShortOut = FALSE;

    return NEW_SINGOBJ_ZERO_ONE(SINGTYPE_RING_IMM, r, NULL, NULL);
}

/// Installed as SI_ring method
Obj FuncSI_RingOfSingobj(Obj self, Obj singobj)
{
    singobj = UnwrapHighlevelWrapper(singobj);
    if (TNUM_OBJ(singobj) != T_SINGULAR)
        ErrorQuit("argument must be singular object.", 0L, 0L);
    Int gtype = TYPE_SINGOBJ(singobj);
    if (HasRingTable[gtype]) {
        ring r = CXXRING_SINGOBJ(singobj);
        if (r == 0 || r->ext_ref == 0)
            ErrorQuit(
                "internal error: bad ring reference in ring dependant object",
                0L, 0L);
        return (Obj)r->ext_ref;
    }
    else if (/* gtype == SINGTYPE_RING || */
             gtype == SINGTYPE_RING_IMM ||
             /* gtype == SINGTYPE_QRING || */
             gtype == SINGTYPE_QRING_IMM) {
        return singobj;
    }
    else {
        ErrorQuit("argument must have associated singular ring.", 0L, 0L);
        return Fail;
    }
}

// TODO: SI_Indeterminates is only used by examples, do we still need it? For
// what?
Obj FuncSI_Indeterminates(Obj self, Obj rr)
{
    Obj res;
    /* check arg */
    rr = UnwrapHighlevelWrapper(rr);
    if (!ISSINGOBJ(SINGTYPE_RING_IMM, rr))
        ErrorQuit("argument must be Singular ring.", 0L, 0L);

    ring r = (ring)CXX_SINGOBJ(rr);
    UInt nrvars = rVar(r);
    UInt i;
    Obj  tmp;

    if (r != currRing)
        rChangeCurrRing(r);

    res = NEW_PLIST(T_PLIST_DENSE, nrvars);
    for (i = 1; i <= nrvars; i++) {
        poly p = p_ISet(1, r);
        pSetExp(p, i, 1);
        pSetm(p);
        tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY, p, r);
        SET_ELM_PLIST(res, i, tmp);
        CHANGED_BAG(res);
    }
    SET_LEN_PLIST(res, nrvars);

    return res;
}


/// Installed as SI_bigint method
Obj Func_SI_bigint(Obj self, Obj nr)
{
    return NEW_SINGOBJ(SINGTYPE_BIGINT_IMM, _SI_BIGINT_FROM_GAP(nr));
}

/// Used for bigint ViewString method.
// TODO: get rid of _SI_Intbigint and use SI_ToGAP instead ?
Obj Func_SI_Intbigint(Obj self, Obj nr)
{
    number n = (number)CXX_SINGOBJ(nr);
    return _SI_BIGINT_OR_INT_TO_GAP(n);
}

/// Installed as SI_number method
Obj Func_SI_number(Obj self, Obj rr, Obj nr)
{
    rr = UnwrapHighlevelWrapper(rr);
    ring   r = (ring)CXX_SINGOBJ(rr);
    number num = _SI_NUMBER_FROM_GAP(r, nr);
    return NEW_SINGOBJ_RING(SINGTYPE_NUMBER_IMM, num, r);
}

/// Installed as SI_intvec method
Obj Func_SI_intvec(Obj self, Obj l)
{
    if (!IS_LIST(l)) {
        ErrorQuit("l must be a list", 0L, 0L);
        return Fail;
    }
    UInt     len = LEN_LIST(l);
    UInt     i;
    intvec * iv = new intvec(len);
    for (i = 1; i <= len; i++) {
        Obj t = ELM_LIST(l, i);
        if (!IS_INTOBJ(t)
#ifdef SYS_IS_64_BIT
            || (INT_INTOBJ(t) < -(1L << 31) || INT_INTOBJ(t) >= (1L << 31))
#endif
        ) {
            delete iv;
            ErrorQuit("l must contain small integers", 0L, 0L);
        }
        (*iv)[i - 1] = (int)(INT_INTOBJ(t));
    }
    return NEW_SINGOBJ(SINGTYPE_INTVEC_IMM, iv);
}

/// Used for intvec ViewString method.
// TODO: get rid of _SI_Plistintvec and use SI_ToGAP instead ?
Obj Func_SI_Plistintvec(Obj self, Obj iv)
{
    if (!(ISSINGOBJ(SINGTYPE_INTVEC, iv) ||
          ISSINGOBJ(SINGTYPE_INTVEC_IMM, iv))) {
        ErrorQuit("iv must be a singular intvec", 0L, 0L);
        return Fail;
    }
    intvec * i = (intvec *)CXX_SINGOBJ(iv);
    UInt     len = i->length();
    Obj      ret = NEW_PLIST(T_PLIST_CYC, len);
    UInt     j;
    for (j = 1; j <= len; j++) {
        SET_ELM_PLIST(ret, j, ObjInt_Int((Int)((*i)[j - 1])));
        CHANGED_BAG(ret);
    }
    SET_LEN_PLIST(ret, len);
    return ret;
}

/// Installed as SI_ideal method
Obj Func_SI_ideal_from_els(Obj self, Obj l)
{
    if (!IS_LIST(l)) {
        ErrorQuit("l must be a list", 0L, 0L);
        return Fail;
    }
    UInt len = LEN_LIST(l);
    if (len == 0) {
        ErrorQuit("l must contain at least one element", 0L, 0L);
        return Fail;
    }
    ideal id;
    UInt  i;
    Obj   t = NULL;
    ring  r = NULL;
    for (i = 1; i <= len; i++) {
        t = ELM_LIST(l, i);
        if (!(ISSINGOBJ(SINGTYPE_POLY, t) ||
              ISSINGOBJ(SINGTYPE_POLY_IMM, t))) {
            if (i > 1)
                id_Delete(&id, r);
            ErrorQuit("l must only contain singular polynomials", 0L, 0L);
            return Fail;
        }
        if (i == 1) {
            r = CXXRING_SINGOBJ(t);
            if (r != currRing)
                rChangeCurrRing(r);
            id = idInit(len, 1);
        }
        else {
            if (r != CXXRING_SINGOBJ(t)) {
                id_Delete(&id, r);
                ErrorQuit("all elements of l must have the same ring", 0L,
                          0L);
                return Fail;
            }
        }
        poly p = p_Copy((poly)CXX_SINGOBJ(t), r);
        id->m[i - 1] = p;
    }
    return NEW_SINGOBJ_RING(SINGTYPE_IDEAL, id, r);
}

/* if needed, handle more cases */
Obj FuncSingularValueOfVar(Obj self, Obj name)
{
    Int      len;
    Obj      tmp, tmp2;
    intvec * v;
    int      i, j, k;
    Int      rows, cols;
    /* number n;   */

    idhdl h = ggetid(reinterpret_cast<char *>(CHARS_STRING(name)));
    if (h == NULL)
        return Fail;
    switch (IDTYP(h)) {
    case INT_CMD:
        return ObjInt_Int((Int)(IDINT(h)));
    case STRING_CMD:
        return MakeString(IDSTRING(h));
    case INTVEC_CMD:
        v = IDINTVEC(h);
        len = (Int)v->length();
        tmp = NEW_PLIST(T_PLIST_CYC, len);
        SET_LEN_PLIST(tmp, len);
        for (i = 0; i < len; i++) {
            SET_ELM_PLIST(tmp, i + 1, ObjInt_Int((Int)((*v)[i])));
            CHANGED_BAG(tmp);    // ObjInt_Int can trigger garbage collections
        }
        return tmp;
    case INTMAT_CMD:
        v = IDINTVEC(h);
        rows = (Int)v->rows();
        cols = (Int)v->cols();
        tmp = NEW_PLIST(T_PLIST_DENSE, rows);
        SET_LEN_PLIST(tmp, rows);
        k = 0;
        for (i = 0; i < rows; i++) {
            tmp2 = NEW_PLIST(T_PLIST_CYC, cols);
            SET_LEN_PLIST(tmp2, cols);
            SET_ELM_PLIST(tmp, i + 1, tmp2);
            CHANGED_BAG(tmp);    // ObjInt_Int can trigger garbage collections
            for (j = 0; j < cols; j++) {
                SET_ELM_PLIST(tmp2, j + 1, ObjInt_Int((Int)((*v)[k++])));
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
    Obj   list;
    int   len = 0;
    idhdl x = IDROOT;
    while (x) {
        if (x->typ == PROC_CMD)
            len++;
        x = x->next;
    }
    list = NEW_PLIST(T_PLIST_DENSE, len);
    x = IDROOT;
    while (x) {
        if (x->typ == PROC_CMD) {
            PushPlist(list, MakeString(x->id));
        }
        x = x->next;
    }
    return list;
}

/**
 * Tries to transform a singular object to a GAP object.
 * Currently does small integers and strings.
 */
Obj FuncSI_ToGAP(Obj self, Obj singobj)
{
    if (TNUM_OBJ(singobj) != T_SINGULAR) {
        ErrorQuit("singobj must be a wrapped Singular object", 0L, 0L);
        return Fail;
    }
    switch (TYPE_SINGOBJ(singobj)) {
    case SINGTYPE_STRING:
    case SINGTYPE_STRING_IMM:
        return MakeString((char *)CXX_SINGOBJ(singobj));
    case SINGTYPE_INT:
    case SINGTYPE_INT_IMM:
        return INTOBJ_INT((Int)CXX_SINGOBJ(singobj));
    case SINGTYPE_INTMAT:
    case SINGTYPE_INTMAT_IMM:
        return Func_SI_Matintmat(self, singobj);
    case SINGTYPE_INTVEC:
    case SINGTYPE_INTVEC_IMM:
        return Func_SI_Plistintvec(self, singobj);
    case SINGTYPE_BIGINT:
    case SINGTYPE_BIGINT_IMM:
        return _SI_BIGINT_OR_INT_TO_GAP((number)CXX_SINGOBJ(singobj));
    case SINGTYPE_BIGINTMAT:
    case SINGTYPE_BIGINTMAT_IMM:
        return Func_SI_Matbigintmat(self, singobj);
    default:
        return Fail;
    }
}


//////////////// C++ functions for the jump tables ////////////////////

///! Create a structure copy of a Singular object.
///! This is used as method for ShallowCopy and StructuralCopy
///! for Singular wrapper objects in GAP.
static Obj CopySingObj(Obj s, bool immutable)
{
    if (TNUM_OBJ(s) != T_SINGULAR) {
        ErrorQuit("argument must be a singular object", 0L, 0L);
        return Fail;
    }

    if (!IsCopyableObjSingular(s))
        return s;

    sleftv obj;
    obj.Init();

    int gtype = TYPE_SINGOBJ(s);
    obj.data = CXX_SINGOBJ(s);
    obj.rtyp = GAPtoSingType[gtype];
    obj.flag = FLAGS_SINGOBJ(s);
    obj.attribute = (attr)ATTRIB_SINGOBJ(s);
    ring r = HasRingTable[gtype] ? CXXRING_SINGOBJ(s) : 0;

    sleftv copy;
    if (r && r != currRing)
        rChangeCurrRing(r);
    copy.Copy(&obj);

    if (immutable)
        gtype = gtype | 1;
    else
        gtype = gtype & ~1;

    // Wrap it again
    Obj res;
    if (r) {
        res = NEW_SINGOBJ_RING(gtype, copy.data, r);
    }
    else {
        res = NEW_SINGOBJ(gtype, copy.data);
    }

    if (copy.flag)
        SET_FLAGS_SINGOBJ(res, copy.flag);
    if (copy.attribute != NULL || copy.e != NULL)
        SET_ATTRIB_SINGOBJ(res, (void *)copy.CopyA());
    return res;
}

///! This function returns 1 if the object <s> is copyable (i.e., can be
///! copied into a mutable object), and 0 otherwise.
Int IsCopyableObjSingular(Obj s)
{
    return IsCopyableSingularType(TYPE_SINGOBJ(s));
}


bool IsCopyableSingularType(Int gtype)
{
    switch (gtype) {
        // Objects of the following types can't be modified on the Singular
        // interpreter level. Thus we should not allow them to be modified
        // either.
    case SINGTYPE_BIGINT_IMM:
    case SINGTYPE_INT_IMM:
    case SINGTYPE_MAP_IMM:
    case SINGTYPE_NUMBER_IMM:
    case SINGTYPE_RESOLUTION_IMM:
    case SINGTYPE_STRING_IMM:
        return 0;

        // The following types represent singletons and as such
        // cannot be copied (they all use ref counters, in fact).
        //
        // TODO/FIXME: Should we insist that they always are marked as
        // immutable? Although note that they infact still can change,
        // e.g. package is in the end a namespace, and new things can be
        // added to it. Similar for rings.
    case SINGTYPE_LINK:
    case SINGTYPE_LINK_IMM:
    case SINGTYPE_PACKAGE:
    case SINGTYPE_PACKAGE_IMM:
    case SINGTYPE_PROC:
    case SINGTYPE_PROC_IMM:
    case SINGTYPE_QRING:
    case SINGTYPE_QRING_IMM:
    case SINGTYPE_RING:
    case SINGTYPE_RING_IMM:
        return 0;

    case SINGTYPE_BIGINTMAT:
    case SINGTYPE_BIGINTMAT_IMM:
    case SINGTYPE_IDEAL:
    case SINGTYPE_IDEAL_IMM:
    case SINGTYPE_INTMAT:
    case SINGTYPE_INTMAT_IMM:
    case SINGTYPE_INTVEC:
    case SINGTYPE_INTVEC_IMM:
    case SINGTYPE_LIST:
    case SINGTYPE_LIST_IMM:
    case SINGTYPE_MATRIX:
    case SINGTYPE_MATRIX_IMM:
    case SINGTYPE_MODULE:
    case SINGTYPE_MODULE_IMM:
    case SINGTYPE_POLY:
    case SINGTYPE_POLY_IMM:
    case SINGTYPE_VECTOR:
    case SINGTYPE_VECTOR_IMM:
        return 1;
    }

    ErrorQuit("IsCopyableObjSingular: unsupported singtype %d", gtype, 0);
    return 0;
}

Obj ShallowCopyObjSingular(Obj s)
{
    return CopySingObj(s, false);
}

Obj CopyObjSingular(Obj s, Int mut)
{
    if (!IS_MUTABLE_OBJ(s))
        return s;
    return CopySingObj(s, !mut);
}

void CleanObjConstant(Obj s)
{
    // we don't mark, so we don't need to clean
}

Int IsMutableSingObj(Obj s)
{
    return ((TYPE_SINGOBJ(s)) & 1) == 0;
}


void MakeImmutableSingObj(Obj s)
{
    SET_TYPE_SINGOBJ(s, TYPE_SINGOBJ(s) | 1);
}


Obj (*OurZeroObject)(Obj s);
Obj (*OurOneObject)(Obj s);
Obj (*OurZeroMutObject)(Obj s);
Obj (*OurOneMutObject)(Obj s);


Obj ZeroSMSingObj(Obj s)
{
    Obj res;
    int gtype = TYPE_SINGOBJ(s);
    // Pr("Zero\n", 0L, 0L);
    if (gtype == SINGTYPE_RING_IMM || gtype == SINGTYPE_QRING_IMM) {
        res = ZERO_SINGOBJ(s);
        if (res != NULL)
            return res;
        res = OurZeroMutObject(s);    // This makes a mutable zero
        MakeImmutable(res);
        SET_ZERO_SINGOBJ(s, res);
        CHANGED_BAG(s);
        return res;
    }
    if (((gtype + 1) & 1) == 1)    // we are mutable
        return OurZeroMutObject(s);
    // Here we are immutable:
    if (HasRingTable[gtype]) {
        // Rings are always immutable!
        ring r = CXXRING_SINGOBJ(s);
        if (r == 0 || r->ext_ref == 0)
            ErrorQuit(
                "internal error: bad ring reference in ring dependant object",
                0L, 0L);
        return ZeroSMSingObj((Obj)r->ext_ref);
    }
    return OurZeroObject(s);
}

Obj OneSMSingObj(Obj s)
{
    Obj res;
    int gtype = TYPE_SINGOBJ(s);
    // Pr("One\n", 0L, 0L);
    if (gtype == SINGTYPE_RING_IMM || gtype == SINGTYPE_QRING_IMM) {
        res = ONE_SINGOBJ(s);
        if (res != NULL)
            return res;
        res = OurOneObject(s);    // This is OneMutable and gives us mutable
        MakeImmutable(res);
        SET_ONE_SINGOBJ(s, res);
        CHANGED_BAG(s);
        return res;
    }
    if (((gtype + 1) & 1) == 1)    // we are mutable!
        return OurOneObject(s);    // This is OneMutable
    // Here we are immutable:
    if (HasRingTable[gtype]) {
        // Rings are always immutable!
        ring r = CXXRING_SINGOBJ(s);
        if (r == 0 || r->ext_ref == 0)
            ErrorQuit(
                "internal error: bad ring reference in ring dependant object",
                0L, 0L);
        return OneSMSingObj((Obj)r->ext_ref);
    }
    return OurOneMutObject(s);
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

Obj Func_SI_attrib(Obj self, Obj singobj)
{
    singobj = UnwrapHighlevelWrapper(singobj);
    if (TNUM_OBJ(singobj) != T_SINGULAR)
        ErrorQuit("argument must be singular object.", 0L, 0L);
    // TODO: for now we just return whether the
    // object has any attributes; but in the future we could
    // return a list with the actual attributes...
    attr a = (attr)ATTRIB_SINGOBJ(singobj);
    if (!a)
        return Fail;
    // HACK
    a->Print();
    return True;
}

Obj Func_SI_flags(Obj self, Obj singobj)
{
    singobj = UnwrapHighlevelWrapper(singobj);
    if (TNUM_OBJ(singobj) != T_SINGULAR)
        ErrorQuit("argument must be singular object.", 0L, 0L);
    unsigned int flags = FLAGS_SINGOBJ(singobj);
    return INTOBJ_INT(flags);
}

Obj Func_SI_type(Obj self, Obj singobj)
{
    singobj = UnwrapHighlevelWrapper(singobj);
    if (TNUM_OBJ(singobj) != T_SINGULAR)
        ErrorQuit("argument must be singular object.", 0L, 0L);
    Int gtype = TYPE_SINGOBJ(singobj);
    return INTOBJ_INT(gtype);
}
