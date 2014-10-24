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

#include <assert.h>

#include <vector>

// The global variable inerror is an internal variable of the Singular
// interpreter which is set to 1 if there is a syntax error. We use this
// in SI_EVALUATE and SI_CallProc to reset the interpreter error state.
extern int inerror;

// A GAP string containing the last error printed by a Singular command.
Obj _SI_LastErrorString;

//! This global is used to store the return value of SPrintEnd.
static char *_SI_LastOutputBuf = NULL;


static void ClearLastOutputBuf()
{
    if (_SI_LastOutputBuf) {
        omFree(_SI_LastOutputBuf);
        _SI_LastOutputBuf = NULL;
    }
}

static void StartPrintCapture()
{
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
        UInt len = (UInt)strlen(_SI_LastOutputBuf);
        Obj tmp = NEW_STRING(len);
        SET_LEN_STRING(tmp, len);
        memcpy(CHARS_STRING(tmp), _SI_LastOutputBuf, len + 1);
        ClearLastOutputBuf();
        return tmp;
    }
    return Fail;
}

void _SI_ErrorCallback(const char *st)
{
    UInt len = (UInt)strlen(st);
    if (IS_STRING(_SI_LastErrorString)) {
        UInt oldlen = GET_LEN_STRING(_SI_LastErrorString);
        GROW_STRING(_SI_LastErrorString, oldlen + len + 2);
        char *p = CSTR_STRING(_SI_LastErrorString);
        memcpy(p + oldlen, st, len);
        p[oldlen+len] = '\n';
        p[oldlen+len+1] = 0;
        SET_LEN_STRING(_SI_LastErrorString, oldlen + len + 1);
    }
}

///! Send a string to the Singular interpreter, which is then evaluated.                   
///! We append "return();" to the evaluated string so that control returns
///! to use once the evaluation is complete.
///! 
///! Returns 'true' upon success, and 'false' if an error occurred.
Obj Func_SI_EVALUATE(Obj self, Obj st)
{
    const char return_str[] = "return();";
    UInt len = GET_LEN_STRING(st);
    char *ost = (char *)omalloc(len + sizeof(return_str));
    memcpy(ost, reinterpret_cast<char*>(CHARS_STRING(st)), len);
    memcpy(ost+len, return_str, sizeof(return_str) );

    // Clear the error string
    if (IS_STRING(_SI_LastErrorString)) {
        SET_LEN_STRING(_SI_LastErrorString, 0);
        CSTR_STRING(_SI_LastErrorString)[0] = 0;
        SHRINK_STRING(_SI_LastErrorString);
    }

    StartPrintCapture();
    myynest = 1;
    BOOLEAN err = iiAllStart(NULL, ost, BT_proc, 0);
    inerror = 0;
    EndPrintCapture();

    omFree(ost);

    return err ? False : True;
}

/// Wrap the content of a Singular interpreter object in a GAP object.
static Obj gapwrap(sleftv &obj, ring r)
{
    if (r == 0 && obj.RingDependend()) {
        if (currRing == 0) {
            obj.CleanUp();
            ErrorQuit("Result is ring dependent but can't figure out what the ring should be",0L,0L);
        }
        if (currRing->ext_ref == 0) {
            currRing->ref++;
            if (currRing->qideal)
                NEW_SINGOBJ_ZERO_ONE(SINGTYPE_RING_IMM, currRing, NULL, NULL);
            else
                NEW_SINGOBJ_ZERO_ONE(SINGTYPE_QRING_IMM, currRing, NULL, NULL);
        }
        r = currRing;
    }
    
    if ((obj.Typ() == RING_CMD || obj.Typ() == QRING_CMD) && ((ring)obj.Data())->ext_ref != 0) {
        Obj rr = (Obj)((ring)obj.Data())->ext_ref;
        obj.CleanUp();
        return HIWRAP_SINGOBJ(rr);
    }

    Obj res;
    int gtype = SingtoGAPType[obj.Typ()];
    // Adjust gtype for mutable / immutable: objects which are not copyable
    // are created as immutable, all others as mutable.
    if (obj.Typ() != NONE && !IsCopyableSingularType(gtype|1))
        gtype |= 1;

    switch (obj.Typ()) {
        case NONE:
            obj.CleanUp();
            return True;
        case INT_CMD:
            res = ObjInt_Int((long)obj.Data());
            obj.CleanUp();
            return res;
        case RING_CMD:
        case QRING_CMD:
            res = NEW_SINGOBJ_ZERO_ONE(gtype, (ring)obj.CopyD(), NULL, NULL);
            break;
        default:
            if (HasRingTable[gtype])
                res = NEW_SINGOBJ_RING(gtype, obj.CopyD(), r);
            else
                res = NEW_SINGOBJ(gtype, obj.CopyD());
            break;
    }
        
    if (obj.flag)
        SET_FLAGS_SINGOBJ(res, obj.flag);
    if (obj.attribute != NULL || obj.e != NULL)
        SET_ATTRIB_SINGOBJ(res, (void *)obj.CopyA());
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

    void init(int i, Obj input, ring &extr) {
        assert(h == 0);

        SingObj::init(input, extr);
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

    SingularIdHdlWithWrap(int i, Obj input, ring &extr) {
        init(i, input, extr);

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
    ring r = NULL;

    SingularIdHdlWithWrap sing(0, a, r);
    if (sing.error) { ErrorQuit(sing.error, 0L, 0L); }

    StartPrintCapture();
    sleftv result;
    BOOLEAN ret = iiExprArith1(&result, sing.ptr(), INT_INTOBJ(op));
    EndPrintCapture();
    if (ret) {
        result.CleanUp(r);
        return Fail;
    }

    return gapwrap(result, r);
}

Obj Func_SI_CallFunc2(Obj self, Obj op, Obj a, Obj b)
{
    ring r = NULL;

    SingularIdHdlWithWrap singa(0, a, r);
    if (singa.error) { ErrorQuit(singa.error, 0L, 0L); }
    SingularIdHdlWithWrap singb(1, b, r);
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
    return gapwrap(result, r);
}

Obj Func_SI_CallFunc3(Obj self, Obj op, Obj a, Obj b, Obj c)
{
    ring r = NULL;

    SingularIdHdlWithWrap singa(0, a, r);
    if (singa.error) { ErrorQuit(singa.error, 0L, 0L); }
    SingularIdHdlWithWrap singb(1, b, r);
    if (singb.error) {
        singa.cleanup();
        ErrorQuit(singb.error, 0L, 0L);
    }
    SingularIdHdlWithWrap singc(2, c, r);
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
    return gapwrap(result, r);
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
    
    WrapMultiArgs(Obj arg, ring &r) : sing(0), error(0) {
        int i;
        int nrargs = (int) LEN_PLIST(arg);
        if (nrargs > 0)
            sing = new SingularIdHdl[nrargs];
        for (i = 0; i < nrargs; i++) {
            sing[i].init(i, ELM_PLIST(arg, i + 1), r);
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
    ring r = NULL;

    int nrargs = (int) LEN_PLIST(arg);
    WrapMultiArgs wrap(arg, r);
    if (wrap.error) ErrorQuit(wrap.error, 0L, 0L);

    StartPrintCapture();
    sleftv result;
    BOOLEAN ret = iiExprArithM(&result, nrargs ? &wrap.s_arg : NULL, INT_INTOBJ(op));
    EndPrintCapture();

    if (ret) {
        result.CleanUp(r);
        return Fail;
    }
    return gapwrap(result, r);
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

    ring r = NULL;
    idhdl tmpHdl = 0;

    int nrargs = (int) LEN_PLIST(args);
    WrapMultiArgs wrap(args, r);
    if (wrap.error) ErrorQuit(wrap.error, 0L, 0L);

    assert(currRingHdl == 0);
    if (r)
        rChangeCurrRing(r);

    BOOLEAN bool_ret;
    if (currRing) {
        // FIXME: Perhaps we should be using getSingularIdhdl() here, too?
        tmpHdl = enterid(" libsing fake currRingHdl ", 0, RING_CMD, &IDROOT, FALSE, FALSE);
        assert(tmpHdl);
        IDRING(tmpHdl) = currRing;
        currRing->ref++;

        currRingHdl = tmpHdl;
    }
    iiRETURNEXPR.Init();

    StartPrintCapture();
    bool_ret = iiMake_proc(h, NULL, nrargs ? &wrap.s_arg : NULL);
    EndPrintCapture();

    inerror = 0;    // reset interpreter error flag
    if (tmpHdl) {
        killhdl(tmpHdl, currPack);
    }
    currRingHdl = NULL;
    
    // If the return value is ring dependant, then (according to Hans)
    // the current ring after iiMake_proc must be the same as
    // before iiMake_proc.

    if (bool_ret == TRUE)
        return Fail;
    leftv ret = &iiRETURNEXPR;
    if (ret->next != NULL) {
        Int len = ret->listLength();
        Obj list = NEW_PLIST( T_PLIST, len );
        SET_LEN_PLIST( list, len );
        for (int i = 0; i < len; ++i) {
            leftv next = ret->next;
            ret->next = 0;
            SET_ELM_PLIST(list, i+1, gapwrap(*ret, r));
            if (i > 0) omFreeBin(ret, sleftv_bin);
            ret = next;
        }
        return list;
    }

    return gapwrap(*ret, r);
}
