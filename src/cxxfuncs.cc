//////////////////////////////////////////////////////////////////////////////
/**
@file cxxfuncs.cc
This file contains all of the code that deals with C++ libraries.
**/
//////////////////////////////////////////////////////////////////////////////

extern "C" 
{
  #include "libsingular.h"
}

#include <string>
#include <libsingular.h>

/// The C++ Standard Library namespace
using namespace std;


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

extern "C"
Obj FuncSingularRingWithoutOrdering(Obj self, Obj charact, Obj numberinvs,
                                    Obj names)
{
    char **array;
    char *p;
    UInt nrvars = INT_INTOBJ(numberinvs);
    UInt i;
    Obj tmp;
    
    array = (char **) omalloc(sizeof(char *) * nrvars);
    for (i = 0;i < nrvars;i++)
        array[i] = omStrDup(CSTR_STRING(ELM_PLIST(names,i+1)));

    ring r = rDefault(INT_INTOBJ(charact),nrvars,array);
    tmp = NEW_SINGOBJ_TYPE(NULL,SINGTYPE_RING,r);
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
            printf("Freed a ring.\n");
            break;
        case SINGTYPE_POLY:
            poly p = (poly) CXX_SINGOBJ(o);
            p_Delete( &p, (ring) CXX_SINGOBJ(RING_SINGOBJ(o)) );
            SET_CXX_SINGOBJ(o,NULL);
            printf("Freed a polynomial.\n");
            break;

    }
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
    UInt nrvars = rVar(r);
    UInt i;
    Obj tmp;

    if (r != currRing) rChangeCurrRing(r);
        
    res = NEW_PLIST(T_PLIST_DENSE,nrvars);
    for (i = 1;i <= nrvars;i++) {
        poly p = p_ISet(1,r);
        pSetExp(p,i,1);
        pSetm(p);
        tmp = NEW_SINGOBJ_TYPE(rr,SINGTYPE_POLY,p);
        SET_ELM_PLIST(res,i,tmp);
        CHANGED_BAG(res);
    }
    SET_LEN_PLIST(res,nrvars);

    return res;
}


//////////////////////////////////////////////////////////////////////////////

