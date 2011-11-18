#include "lowlevel_mappings.h"

#ifdef __cplusplus
extern "C"
{
#endif /* ifdef __cplusplus */

Obj FuncSI_p_String(Obj self, Obj arg1) {
    // Setup current ring
    UInt rnr = RING_SINGOBJ(arg1);
    ring r = (ring)CXX_SINGOBJ(ELM_PLIST(SingularRings,rnr));
    if (r != currRing) rChangeCurrRing(r);
    
    // Prepare input data
    poly var1 = (poly)CXX_SINGOBJ(arg1);
    
    // Call into Singular kernel
    char * res = p_String(var1,r);
    
    // Convert result for GAP and return it
    {
        UInt len = (UInt) strlen(res);
        Obj tmp = NEW_STRING(len);
        SET_LEN_STRING(tmp,len);
        strcpy(reinterpret_cast<char*>(CHARS_STRING(tmp)),res);
        return tmp;
    }
}

Obj FuncSI_p_Add_q(Obj self, Obj arg1, Obj arg2) {
    // Setup current ring
    UInt rnr = RING_SINGOBJ(arg1);
    if (rnr != RING_SINGOBJ(arg2))
        ErrorQuit("Elements not over the same ring\n",0L,0L);
    ring r = (ring)CXX_SINGOBJ(ELM_PLIST(SingularRings,rnr));
    if (r != currRing) rChangeCurrRing(r);
    
    // Prepare input data
    poly var1 = p_Copy((poly)CXX_SINGOBJ(arg1), r);
    poly var2 = p_Copy((poly)CXX_SINGOBJ(arg2), r);
    
    // Call into Singular kernel
    poly res = p_Add_q(var1,var2,r);
    
    // Convert result for GAP and return it
    {
        Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY,res,rnr);
        return tmp;
    }
}

Obj FuncSI_p_Neg(Obj self, Obj arg1) {
    // Setup current ring
    UInt rnr = RING_SINGOBJ(arg1);
    ring r = (ring)CXX_SINGOBJ(ELM_PLIST(SingularRings,rnr));
    if (r != currRing) rChangeCurrRing(r);
    
    // Prepare input data
    poly var1 = p_Copy((poly)CXX_SINGOBJ(arg1), r);
    
    // Call into Singular kernel
    poly res = p_Neg(var1,r);
    
    // Convert result for GAP and return it
    {
        Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY,res,rnr);
        return tmp;
    }
}

Obj FuncSI_pp_Mult_qq(Obj self, Obj arg1, Obj arg2) {
    // Setup current ring
    UInt rnr = RING_SINGOBJ(arg1);
    if (rnr != RING_SINGOBJ(arg2))
        ErrorQuit("Elements not over the same ring\n",0L,0L);
    ring r = (ring)CXX_SINGOBJ(ELM_PLIST(SingularRings,rnr));
    if (r != currRing) rChangeCurrRing(r);
    
    // Prepare input data
    poly var1 = (poly)CXX_SINGOBJ(arg1);
    poly var2 = (poly)CXX_SINGOBJ(arg2);
    
    // Call into Singular kernel
    poly res = pp_Mult_qq(var1,var2,r);
    
    // Convert result for GAP and return it
    {
        Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY,res,rnr);
        return tmp;
    }
}

Obj FuncSI_pp_Mult_nn(Obj self, Obj arg1, Obj arg2) {
    // Setup current ring
    UInt rnr = RING_SINGOBJ(arg1);
    if (rnr != RING_SINGOBJ(arg2))
        ErrorQuit("Elements not over the same ring\n",0L,0L);
    ring r = (ring)CXX_SINGOBJ(ELM_PLIST(SingularRings,rnr));
    if (r != currRing) rChangeCurrRing(r);
    
    // Prepare input data
    poly var1 = (poly)CXX_SINGOBJ(arg1);
    number var2 = (number)CXX_SINGOBJ(arg2);
    
    // Call into Singular kernel
    poly res = pp_Mult_nn(var1,var2,r);
    
    // Convert result for GAP and return it
    {
        Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_POLY,res,rnr);
        return tmp;
    }
}


#ifdef __cplusplus
}
#endif /* ifdef __cplusplus */
