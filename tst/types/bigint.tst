gap> #
gap> # Check some small integers
gap> #
gap> SI_bigint(0);
<singular bigint:0>
gap> SI_bigint(1);
<singular bigint:1>
gap> SI_bigint(-1);
<singular bigint:-1>
gap> #
gap> # Check potential 32 bit boundary values
gap> #
gap> SI_bigint(2^28);
<singular bigint:268435456>
gap> SI_bigint(2^28-1);
<singular bigint:268435455>
gap> SI_bigint(2^28+1);
<singular bigint:268435457>
gap> SI_bigint(-2^28);
<singular bigint:-268435456>
gap> SI_bigint(-2^28-1);
<singular bigint:-268435457>
gap> SI_bigint(-2^28+1);
<singular bigint:-268435455>
gap> #
gap> # Check potential 64 bit boundary values
gap> #
gap> SI_bigint(2^60);
<singular bigint:1152921504606846976>
gap> SI_bigint(2^60-1);
<singular bigint:1152921504606846975>
gap> SI_bigint(2^60+1);
<singular bigint:1152921504606846977>
gap> SI_bigint(-2^60);
<singular bigint:-1152921504606846976>
gap> SI_bigint(-2^60-1);
<singular bigint:-1152921504606846977>
gap> SI_bigint(-2^60+1);
<singular bigint:-1152921504606846975>
gap> #
gap> # Verify that SI_bigint is idempotent
gap> #
gap> a := SI_bigint(12);
<singular bigint:12>
gap> b := SI_bigint(a);
<singular bigint:12>
gap> a = b;
true
gap> i:=SI_bigint(42);
<singular bigint:42>
gap> _SI_Intbigint(i) = 42;
true
gap> i:=SI_bigint(42^42);
<singular bigint:1501309375452965723567719721642544578140479705687387772358935\
33016064>
gap> _SI_Intbigint(i) = 42^42;
true
