gap> s := SI_ring(3,["a","b"]);
<singular ring, 2 indeterminates>
gap> i := SI_Indeterminates(s);
[ a, b ]
gap> _SI_p_String(i[1]);
"a"
gap> _SI_p_String(i[2]);
"b"
gap> a := 2 * SI_monomial(s, SI_intvec([2,3]));
-a^2*b^3
gap> b := 2 * SI_monomial(s, SI_intvec([4,5]));
-a^4*b^5
gap> c := _SI_p_Add_q(a,b);
-a^4*b^5-a^2*b^3
gap> d := _SI_pp_Mult_qq(a,b);
a^6*b^8
gap> e := _SI_p_Neg(a);
a^2*b^3
gap> _SI_p_String(a);
"-a^2*b^3"
gap> _SI_p_String(b);
"-a^4*b^5"
gap> _SI_p_String(c);
"-a^4*b^5-a^2*b^3"
gap> _SI_p_String(d);
"a^6*b^8"
gap> _SI_p_String(e);
"a^2*b^3"
gap> Unbind(a);
gap> Unbind(b);
gap> Unbind(c);
gap> Unbind(d);
gap> Unbind(e);
gap> Unbind(i);
gap> Unbind(s);
gap> s := SI_ring(17,["a","b"]);
<singular ring, 2 indeterminates>
gap> ind := SI_Indeterminates(s);
[ a, b ]
gap> id := SI_ideal(ind);
<singular ideal, 2 gens>
gap> x := 12 * SI_monomial(s, SI_intvec([2,3]));
-5*a^2*b^3
gap> y := 2 * SI_monomial(s, SI_intvec([4,3]));
2*a^4*b^3
gap> _SI_p_Add_q(x,y);
2*a^4*b^3-5*a^2*b^3
gap> id := SI_ideal([x,y]);
<singular ideal, 2 gens>
gap> p1 := SI_Proxy(id,1);
<proxy for <singular ideal, 2 gens>[1]>
gap> p2 := SI_Proxy(id,2);
<proxy for <singular ideal, 2 gens>[2]>
gap> _SI_p_Add_q(x,p2);
2*a^4*b^3-5*a^2*b^3
gap> _SI_p_Add_q(p2,y);
4*a^4*b^3
gap> _SI_p_Add_q(p2,p1);
2*a^4*b^3-5*a^2*b^3
gap> 
gap> 
