// SingularInterface: A GAP interface to Singular
//
// Copyright of SingularInterface belongs to its developers.
// Please refer to the COPYRIGHT file for details.
//
// SPDX-License-Identifier: GPL-2.0-or-later

#include "number.h"


//! \defgroup CxxHelper C++ helpers for converting between GAP and Singular
//! The following functions are helpers on the C++ level. They
//! are not exposed to the GAP level. They are mainly used to dig out
//! proper singular elements from their GAP wrappers or from real GAP
//! objects.
//! @{


static void _SI_GMP_FROM_GAP(Obj in, mpz_t out)
{
    UInt size = SIZE_INT(in);
    mpz_init2(out, size * GMP_NUMB_BITS);
    memcpy(out->_mp_d, ADDR_INT(in), sizeof(mp_limb_t) * size);
    out->_mp_size = (TNUM_OBJ(in) == T_INTPOS) ? (Int)size : -(Int)size;
}


/// Convert a GAP finite field element object to a GAP integer object. This
/// simply calls the GAP function IntFFE().
static Obj IntFFE(Obj o)
{
    return CALL_1ARGS(SI_IntFFE, o);
}


/// This internal function converts a GAP number n into a coefficient
/// number for the ring r. n can be an immediate integer, a GMP integer
/// or a rational number. If anything goes wrong, NULL is returned.
number _SI_NUMBER_FROM_GAP(ring r, Obj n)
{
    if (r != currRing)
        rChangeCurrRing(r);

    // First check if n is a small integer that fits into a machine word;
    // this is usually cheap to convert.
    // However, GAP uses (32-4)=28 bit integers on 32bit machines, and
    // (64-4)=60 bit integers on 64 bit machine; whereas Singular always
    // uses (32-4)=28 bit integers, even on 64 bit systems. So we have to
    // use different code in each case.
    if (IS_INTOBJ(n)) {
        Int i = INT_INTOBJ(n);
#ifdef SYS_IS_64_BIT
        if (i >= -(1L << 31) && i < (1L << 31))
            return n_Init(i, r);
#else
        return n_Init(i, r);
#endif
    }

    if (rField_is_Zp(r)) {
        if (IS_INTOBJ(n)) {
            return n_Init(INT_INTOBJ(n) % rChar(r), r);
        }
        else if (IS_FFE(n)) {
            FF ff = FLD_FFE(n);
            if (CHAR_FF(ff) != rChar(r) || DEGR_FF(ff) != 1)
                ErrorQuit("Argument is in wrong field.\n", 0L, 0L);
            Obj v = IntFFE(n);
            return n_Init(INT_INTOBJ(v), r);
        }
        else if (TNUM_OBJ(n) == T_INTPOS || TNUM_OBJ(n) == T_INTNEG ||
                 TNUM_OBJ(n) == T_RAT) {
            n = MOD(n, INTOBJ_INT(rChar(r)));
            if (n != Fail && IS_INTOBJ(n)) {
                return n_Init(INT_INTOBJ(n) % rChar(r), r);
            }
        }
        ErrorQuit("Argument must be an integer, rational or finite prime "
                  "field element.\n",
                  0L, 0L);
        return NULL;    // never executed
    }
    else if (!rField_is_Q(r)) {
        // Other fields not yet supported
        ErrorQuit("GAP numbers over this field not yet implemented.\n", 0L,
                  0L);
        return NULL;    // never executed
    }
    // Here we know that the rationals are the coefficients:
    if (IS_INTOBJ(n)) {    // a GAP immediate integer
        Int i = INT_INTOBJ(n);
        // Does not fit into a Singular immediate integer, or else it
        // would have already been handled above.
        return n_Init(i, coeffs_BIGINT);
    }
    else if (TNUM_OBJ(n) == T_INTPOS || TNUM_OBJ(n) == T_INTNEG) {
        // n is a long GAP integer. Both GAP and Singular use GMP, but
        // GAP uses the low-level mpn API (where data is stored as an
        // mp_limb_t array), whereas Singular uses the high-level mpz
        // API (using type mpz_t).
        number res = ALLOC_RNUMBER();
        _SI_GMP_FROM_GAP(n, res->z);
#if defined(LDEBUG)
        res->debug = 123456;
#endif
        res->s = 3;    // indicates an integer
        return res;
    }
    else if (TNUM_OBJ(n) == T_RAT) {
        // n is a long GAP rational:
        number res = ALLOC_RNUMBER();
#if defined(LDEBUG)
        res->debug = 123456;
#endif
        res->s = 0;
        Obj nn = NUM_RAT(n);
        if (IS_INTOBJ(nn)) {    // a GAP immediate integer
            Int i = INT_INTOBJ(nn);
            mpz_init_set_si(res->z, i);
        }
        else {
            _SI_GMP_FROM_GAP(nn, res->z);
        }
        nn = DEN_RAT(n);
        if (IS_INTOBJ(nn)) {    // a GAP immediate integer
            Int i = INT_INTOBJ(nn);
            mpz_init_set_si(res->n, i);
        }
        else {
            _SI_GMP_FROM_GAP(nn, res->n);
        }
        return res;
    }
    else {
        ErrorQuit("Argument must be an integer or rational.\n", 0L, 0L);
        return NULL;    // never executed
    }
}

number _SI_BIGINT_FROM_GAP(Obj nr)
{
    number n = NULL;
    if (IS_INTOBJ(nr)) {    // a GAP immediate integer
        Int i = INT_INTOBJ(nr);
        if (i >= -(1L << 28) && i < (1L << 28))
            n = n_Init((int)i, coeffs_BIGINT);
        else
            n = n_Init(i, coeffs_BIGINT);
    }
    else if (TNUM_OBJ(nr) == T_INTPOS || TNUM_OBJ(nr) == T_INTNEG) {
        // A long GAP integer
        n = ALLOC_RNUMBER();
        _SI_GMP_FROM_GAP(nr, n->z);
#if defined(LDEBUG)
        n->debug = 123456;
#endif
        n->s = 3;    // indicates an integer
    }
    else {
        ErrorQuit("Argument must be an integer.\n", 0L, 0L);
    }
    return n;
}


int _SI_BIGINT_OR_INT_FROM_GAP(Obj nr, sleftv & obj)
{
    number n;
    if (IS_INTOBJ(nr)) {    // a GAP immediate integer
        Int i = INT_INTOBJ(nr);
#ifdef SYS_IS_64_BIT
        if (i >= -(1L << 31) && i < (1L << 31)) {
#endif
            obj.data = (void *)i;
            obj.rtyp = INT_CMD;
            return SINGTYPE_INT_IMM;
#ifdef SYS_IS_64_BIT
        }
        else {
            n = n_Init(i, coeffs_BIGINT);
        }
#endif
    }
    else {    // a long GAP integer
        n = ALLOC_RNUMBER();
        _SI_GMP_FROM_GAP(nr, n->z);
#if defined(LDEBUG)
        n->debug = 123456;
#endif
        n->s = 3;    // indicates an integer
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
    }
    else {
        return MakeObjInt((const UInt *)n->z->_mp_d, n->z->_mp_size);
    }
}
