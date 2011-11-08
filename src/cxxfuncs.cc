//////////////////////////////////////////////////////////////////////////////
/**
@file cxxfuncs.cc
This file contains all of the code that deals with C++ libraries.
**/
//////////////////////////////////////////////////////////////////////////////

extern "C" 
{
  #include "libsing.h"
}

// Prevent inline code from using tests which are not in libsingular:
#define NDEBUG 1
#define OM_NDEBUG 1

#include <string>
#include <libsingular.h>

/// The C++ Standard Library namespace
using namespace std;


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

    switch (type) {
        case SINGTYPE_RING:
            rKill( (ring) CXX_SINGOBJ(o) );
            SET_CXX_SINGOBJ(o,NULL);
            SET_RING_SINGOBJ(o,0);
            // Pr("killed a ring\n",0L,0L);
            break;
        case SINGTYPE_POLY:
            poly p = (poly) CXX_SINGOBJ(o);
            UInt rnr = RING_SINGOBJ(o);
            p_Delete( &p, (ring) CXX_SINGOBJ(ELM_PLIST(SingularRings,rnr)) );
            SET_CXX_SINGOBJ(o,NULL);
            SET_RING_SINGOBJ(o,0);
            DEC_REFCOUNT( rnr );
            // Pr("killed a ring element\n",0L,0L);
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
Obj FuncSINGULAR_MONOMIAL(Obj self, Obj rr, Obj coeff, Obj exps)
{
    ring r = (ring) CXX_SINGOBJ(rr);
    UInt rnr = RING_SINGOBJ(rr);
    UInt nrvars = rVar(r);
    UInt i;
    UInt len;
    if (r != currRing) rChangeCurrRing(r);
    poly p = p_ISet(INT_INTOBJ(coeff),r);
    len = LEN_LIST(exps);
    if (len < nrvars) nrvars = len;
    for (i = 1;i <= nrvars;i++)
        pSetExp(p,i,INT_INTOBJ(ELM_LIST(exps,i)));
    pSetm(p);
    Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY,p,rnr);
    return tmp;
}

extern "C"
Obj FuncSTRING_POLY(Obj self, Obj po)
{
    UInt rnr = RING_SINGOBJ(po);
    ring r = (ring) CXX_SINGOBJ(ELM_PLIST(SingularRings,rnr));
    if (r != currRing) rChangeCurrRing(r);
    poly p = (poly) CXX_SINGOBJ(po);
    char *st = p_String(p,r);
    UInt len = (UInt) strlen(st);
    Obj tmp = NEW_STRING(len);
    SET_LEN_STRING(tmp,len);
    strcpy(reinterpret_cast<char*>(CHARS_STRING(tmp)),st);
    return tmp;
}

extern "C"
Obj FuncADD_POLYS(Obj self, Obj a, Obj b)
{
    UInt rnr = RING_SINGOBJ(a);
    if (rnr != RING_SINGOBJ(b))
        ErrorQuit("Elements not over the same ring\n",0L,0L);
    ring r = (ring) CXX_SINGOBJ(ELM_PLIST(SingularRings,rnr));
    if (r != currRing) rChangeCurrRing(r);  // necessary?
    poly aa = p_Copy((poly) CXX_SINGOBJ(a),r);
    poly bb = p_Copy((poly) CXX_SINGOBJ(b),r);
    aa = p_Add_q(aa,bb,r);
    Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY,aa,rnr);
    return tmp;
}

extern "C"
Obj FuncNEG_POLY(Obj self, Obj a)
{
    UInt rnr = RING_SINGOBJ(a);
    ring r = (ring) CXX_SINGOBJ(ELM_PLIST(SingularRings,rnr));
    if (r != currRing) rChangeCurrRing(r);  // necessary?
    poly aa = p_Copy((poly) CXX_SINGOBJ(a),r);
    aa = p_Neg(aa,r);
    Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY,aa,rnr);
    return tmp;
}

extern "C"
Obj FuncMULT_POLYS(Obj self, Obj a, Obj b)
{
    UInt rnr = RING_SINGOBJ(a);
    if (rnr != RING_SINGOBJ(b))
        ErrorQuit("Elements not over the same ring\n",0L,0L);
    ring r = (ring) CXX_SINGOBJ(ELM_PLIST(SingularRings,rnr));
    if (r != currRing) rChangeCurrRing(r);   // necessary?
    poly aa = pp_Mult_qq((poly) CXX_SINGOBJ(a),(poly) CXX_SINGOBJ(b),r);
    Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY,aa,rnr);
    return tmp;
}

number NUMBER_FROM_GAP(Obj self, ring r, Obj n)
// This internal function converts a GAP number n into a coefficient
// number for the ring r. n can be an immediate integer, a GMP integer
// or a rational number. If anything goes wrong, NULL is returned.
{
    if (r != currRing) rChangeCurrRing(r);
    number res;
    return res;
}

extern "C"
Obj FuncINIT_SINGULAR_INTERPRETER(Obj self, Obj path)
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

extern "C"
Obj FuncEVALUATE_IN_SINGULAR(Obj self, Obj st)
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
    // Int err = (Int) iiEStart(ost,NULL);
    Int err = (Int) iiAllStart(NULL,ost,BT_proc,0);
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


//////////////////////////////////////////////////////////////////////////////

// The rest will eventually go:

/// GAP kernel C handler to concatenate two strings
/// @param self The usual GAP first parameter
/// @param a The first string
/// @param b The second string
/// @return The rank of the matrix
extern "C"
Obj FuncCONCATENATE(Obj self, Obj a, Obj b)
{
  if(!IS_STRING(a))
    PrintGAPError("The first argument must be a string");

  if(!IS_STRING(b))
    PrintGAPError("The second argument must be a string");
    
  string str_a = reinterpret_cast<char*>(CHARS_STRING(a));
  string str_b = reinterpret_cast<char*>(CHARS_STRING(b));
  string str = str_a + "-" + str_b;

  unsigned int len = str.length();
  Obj GAPstring = NEW_STRING(len);
  memcpy( CHARS_STRING(GAPstring), str.c_str(), len );
  return GAPstring;
}

extern "C"
Obj FuncSingularTest(Obj self)
{
  // init path names etc.
  siInit((char
*)"/scratch/neunhoef/4.0/pkg/libsingular/Singular-3-1-3/Singular/libsingular.so");

  // construct the ring Z/32003[x,y,z]
  // the variable names
  char **n=(char**)omalloc(3*sizeof(char*));
  n[0]=omStrDup("x");
  n[1]=omStrDup("y");
  n[2]=omStrDup("z2");

  ring R=rDefault(32003,3,n);
  // make R the default ring:
  rChangeCurrRing(R);

  // create the polynomial 1
  poly p1=p_ISet(1,R);

  // create tthe polynomial 2*x^3*z^2
  poly p2=p_ISet(2,R);
  pSetExp(p2,1,3);
  pSetExp(p2,3,2);
  pSetm(p2);

  // print p1 + p2
  pWrite(p1); printf(" + \n"); pWrite(p2); printf("\n");

  // compute p1+p2
  p1=p_Add_q(p1,p2,R); p2=NULL;
  pWrite(p1); 

  // cleanup:
  pDelete(&p1);
  rKill(R);

  currentVoice=feInitStdin(NULL);
  int err=iiEStart(omStrDup("int ver=system(\"version\");export ver;return();\n"),NULL);
  // if (err) errorreported = inerror = cmdtok = 0; // reset error handling
  printf("interpreter returns %d\n",err);
  idhdl h=ggetid("ver");
  if (h!=NULL)
    printf("singular variable ver contains %d\n",IDINT(h));
  else
    printf("variable ver does not exist\n");
  return 0;

}

