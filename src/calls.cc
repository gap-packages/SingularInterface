#include "libsing.h"
#include "singobj.h"

#include <assert.h>

#include <vector>

// HACK: inerror is set by the Singular interpreter if there is
// a syntax error. We use this in SI_EVALUATE and SI_CallProc
// to reset the interpreter error state.
extern int inerror;

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

Obj Func_SI_EVALUATE(Obj self, Obj st)
{
    UInt len = GET_LEN_STRING(st);
    char *ost = (char *) omalloc((size_t) len + 10);
    memcpy(ost,reinterpret_cast<char*>(CHARS_STRING(st)),len);
    memcpy(ost+len,"return();",9);
    ost[len+9] = 0;
    StartPrintCapture();
    myynest = 1;
    Int err = (Int) iiAllStart(NULL,ost,BT_proc,0);
    inerror = 0;
    EndPrintCapture();
    // Note that iiEStart uses omFree internally to free the string ost
    return ObjInt_Int((Int) err);
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
class SingularIdHdl : public SingObj {
public:
    idhdl h;

public:
    SingularIdHdl() : h(0) {
    }

    void init(int i, Obj input, Obj &extrr, ring &extr) {
        assert(h == 0);

        SingObj::init(input, extrr, extr);
        if (error)
            return;
        
        h = getSingularIdhdl(i);
        IDTYP(h) = obj.Typ();
        IDDATA(h) = (char *)obj.Data();
        // We don't need to worry about incrementing reference counters
        // (for rings, proc, link, packages) here.
    }

    ~SingularIdHdl() {
        cleanup();
    }

    void cleanup() {
        SingObj::cleanup();
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
        init(i, input, extrr, extr);

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
    if (sing.error) { ErrorQuit(sing.error, 0L, 0L); }

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
    if (singa.error) { ErrorQuit(singa.error, 0L, 0L); }
    SingularIdHdlWithWrap singb(1, b, rr, r);
    if (singb.error) {
        singa.cleanup();
        ErrorQuit(singb.error, 0L, 0L);
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
    if (singa.error) { ErrorQuit(singa.error, 0L, 0L); }
    SingularIdHdlWithWrap singb(1, b, rr, r);
    if (singb.error) {
        singa.cleanup();
        ErrorQuit(singb.error, 0L, 0L);
    }
    SingularIdHdlWithWrap singc(2, c, rr, r);
    if (singc.error) {
        singa.cleanup();
        singb.cleanup();
        ErrorQuit(singc.error, 0L, 0L);
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
        if (nrargs > 0)
            sing = new SingularIdHdl[nrargs];
        for (i = 0; i < nrargs; i++) {
            sing[i].init(i, ELM_PLIST(arg, i + 1), rr, r);
            if (sing[i].error) {
                error = sing[i].error;
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

    int nrargs = (int) LEN_PLIST(args);
    WrapMultiArgs wrap(args, rr, r);
    if (wrap.error) ErrorQuit(wrap.error, 0L, 0L);

    BOOLEAN bool_ret;
    if (r) {
        // FIXME: Perhaps we should be using getSingularIdhdl() here, too?
        currRingHdl = enterid("Blabla", 0, RING_CMD, &IDROOT, FALSE, FALSE);
        assert(currRingHdl);
        IDRING(currRingHdl) = r;
        r->ref++;
    } else {
        currRingHdl = NULL;
        currRing = NULL;
    }
    iiRETURNEXPR.Init();

    StartPrintCapture();
    bool_ret = iiMake_proc(h, NULL, nrargs ? &wrap.s_arg : NULL);
    EndPrintCapture();

    inerror = 0;    // reset interpreter error flag
    if (r) killhdl(currRingHdl, currPack);

    if (bool_ret == TRUE) return Fail;
    leftv ret = &iiRETURNEXPR;
    if (ret->next != NULL) {
        ret->CleanUp(r);
        ErrorQuit("Multiple return values not yet implemented.",0L,0L);
        return Fail;
    }

    return gapwrap(*ret, rr);
}
