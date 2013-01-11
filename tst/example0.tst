gap> s := SI_ring(32003,["x","y","z"]);
<singular ring>
gap> s1 := SI_poly(s,"x2y+151xyz10+169y21");
<singular poly (mutable):169y21+151xyz10+x2y>
gap> s2 := SI_poly(s,"xz14+6x2y4+z24");
<singular poly (mutable):z24+xz14+6x2y4>
gap> s3 := SI_poly(s,"5xy10z10+2y20z10+y10z20+11x3");
<singular poly (mutable):2y20z10+y10z20+5xy10z10+11x3>
gap> i := SI_ideal([s1,s2,s3]);
<singular ideal (mutable), 3gens of deg <= 30>
gap> n := SI_poly(s,"0");
<singular poly (mutable):0>
gap> j := SI_std(i);
<singular ideal (mutable), 41gens of deg <= 31>
gap> ps := List([1..40],k->_SI_p_Add_q(n,SI_Proxy(j,k)));
[ <singular poly (mutable):x7>, <singular poly (mutable):x6y2+7578x6z2>, 
  <singular poly (mutable):x6yz2>, <singular poly (mutable):x6z4>, 
  <singular poly (mutable):x5y7+4490x5y5z2-9765x5y3z4-7107x5yz6>, 
  <singular poly (mutable):x5y6z2-10470x5y4z4+14386x5y2z6-7505x5z8>, 
  <singular poly (mutable):x5y5z4+4955x5y3z6+11753x5yz8>, 
  <singular poly (mutable):x5y2z8+8475x5z10-2011x6>, 
  <singular poly (mutable):x5y4z6-8017x5y2z8+13310x5z10>, 
  <singular poly (mutable):x5yz10+46x6y>, 
  <singular poly (mutable):x4y10z2+5763x4y8z4+9051x4y6z6-14328x4y4z8-9796x4y2z\
10-6358x4z12+11095x5y2-6037x5z2>, 
  <singular poly (mutable):x4y12+11999x4y10z2-10714x4y8z4-8418x4y6z6-1230x4y4z\
8-3198x4y2z10+5056x4z12-8884x5y2+3030x5z2>, 
  <singular poly (mutable):x5z12-14323x6y2-6280x6z2>, 
  <singular poly (mutable):x4y7z6+13666x4y5z8-8520x4y3z10+14633x4yz12+8023x5y3\
-9904x5yz2>, 
  <singular poly (mutable):x4y9z4-3222x4y7z6-13591x4y5z8+8555x4y3z10+12401x4yz\
12+8315x5y3+12733x5yz2>, 
  <singular poly (mutable):x4y4z10-6451x4y2z12+10771x4z14-8850x5y4+9916x5y2z2-\
13939x5z4>, 
  <singular poly (mutable):x4y6z8-2152x4y4z10-13484x4y2z12+6649x4z14-12278x5y4\
-3654x5y2z2+8070x5z4>, 
  <singular poly (mutable):x3y15+2024x3y11z4-12648x3y5z10-8346x3yz14-8682x4y5-\
9041x4yz4>, 
  <singular poly (mutable):x4y3z12-2170x4yz14-13489x5y5-12718x5y3z2-11720x5yz4\
>, <singular poly (mutable):x4z16-15002x5y6-9595x5y4z2-7143x5y2z4-10329x5z6>, 
  <singular poly (mutable):x4y2z14-10573x4z16+2860x5y6+4163x5y4z2+11769x5y2z4+\
9116x5z6>, 
  <singular poly (mutable):x3y13z4-15453x3y11z6+10547x3y7z10+14424x3y3z14+8522\
x3yz16-2784x4y7+8431x4y3z4-9057x4yz6>, 
  <singular poly (mutable):x3y12z6-610x3y8z10+4243x3y4z14+9526x3y2z16+12033x3z\
18-4951x4y8+4996x4y4z4+7481x4y2z6+12033x4z8>, 
  <singular poly (mutable):y21+6250xyz10-5681x2y>, 
  <singular poly (mutable):x3y9z10+9464x3y7z12-6788x3y5z14+4832x3y3z16-11634x3\
yz18+6860x4y9-13449x4y7z2+7734x4y5z4+12659x4y3z6-340x4yz8>, 
  <singular poly (mutable):x3y11z8+9920x3y9z10+486x3y7z12-3421x3y5z14-15307x3y\
3z16+8483x3yz18+2868x4y9-4877x4y7z2-6223x4y5z4-290x4y3z6+6438x4yz8>, 
  <singular poly (mutable):x3y4z16+8928x3y2z18-14124x3z20+2007x4y10-13349x4y8z\
2+4093x4y6z4+13572x4y4z6-6556x4y2z8-15715x4z10-1669x5>, 
  <singular poly (mutable):x3y6z14+10343x3y4z16+9382x3y2z18-1786x3z20-8957x4y1\
0-11046x4y8z2+3478x4y6z4-10723x4y4z6+1134x4y2z8-15530x4z10-4714x5>, 
  <singular poly (mutable):x3y8z12+5679x3y6z14+12687x3y4z16+7137x3y2z18-1810x3\
z20+14588x4y10+6970x4y8z2-15749x4y6z4-6798x4y4z6+2136x4y2z8-1810x4z10>, 
  <singular poly (mutable):x2y11z10+15047x2yz20+3036x3y11+13031x3y5z6-7508x3yz\
10-5558x4y>, 
  <singular poly (mutable):x2y15z6-5446x2y11z10+15260x2yz20+1375x3y11+2562x3y5\
z6+5332x3yz10+12564x4y>, <singular poly (mutable):z24+xz14+6x2y4>, 
  <singular poly (mutable):x3yz20-7799x4y11-7973x4y9z2-12545x4y7z4-11887x4y5z6\
+5201x4y3z8-3593x4yz10-9635x5y>, 
  <singular poly (mutable):x3y3z18+8399x3yz20+446x4y11+12886x4y9z2+1065x4y7z4+\
6600x4y5z6-2673x4y3z8+3686x4yz10-9988x5y>, 
  <singular poly (mutable):x3z22+9612x4y12+2181x4y10z2+4473x4y8z4-12155x4y6z6+\
2387x4y4z8-1763x4y2z10-12409x4z12+828x5y2+519x5z2>, 
  <singular poly (mutable):x2y4z20+4607x3y14-13928x3y8z6-2084x3y4z10+11355x3z1\
4+7679x4y4+11355x4z4>, 
  <singular poly (mutable):xy11z14+16000x2y15-10036x2yz14-13253x3y5-7998x3yz4>
    , 
  <singular poly (mutable):x2y10z14+6187x2y4z20+149x3y14-13600x3y10z4+11543x3y\
8z6+15121x3y4z10+6800x3z14-11014x4y4+1997x4z4>, 
  <singular poly (mutable):y20z10-16001y10z20-15999xy10z10-15996x3>, 
  <singular poly (mutable):y11z20+5xy11z10-12500xyz20+11362x2yz10+11x3y> ]
gap> pss := List(ps,_SI_p_String);
[ "x7", "x6y2+7578x6z2", "x6yz2", "x6z4", 
  "x5y7+4490x5y5z2-9765x5y3z4-7107x5yz6", 
  "x5y6z2-10470x5y4z4+14386x5y2z6-7505x5z8", "x5y5z4+4955x5y3z6+11753x5yz8", 
  "x5y2z8+8475x5z10-2011x6", "x5y4z6-8017x5y2z8+13310x5z10", "x5yz10+46x6y", 
  "x4y10z2+5763x4y8z4+9051x4y6z6-14328x4y4z8-9796x4y2z10-6358x4z12+11095x5y2-6\
037x5z2", 
  "x4y12+11999x4y10z2-10714x4y8z4-8418x4y6z6-1230x4y4z8-3198x4y2z10+5056x4z12-\
8884x5y2+3030x5z2", "x5z12-14323x6y2-6280x6z2", 
  "x4y7z6+13666x4y5z8-8520x4y3z10+14633x4yz12+8023x5y3-9904x5yz2", 
  "x4y9z4-3222x4y7z6-13591x4y5z8+8555x4y3z10+12401x4yz12+8315x5y3+12733x5yz2",
  "x4y4z10-6451x4y2z12+10771x4z14-8850x5y4+9916x5y2z2-13939x5z4", 
  "x4y6z8-2152x4y4z10-13484x4y2z12+6649x4z14-12278x5y4-3654x5y2z2+8070x5z4", 
  "x3y15+2024x3y11z4-12648x3y5z10-8346x3yz14-8682x4y5-9041x4yz4", 
  "x4y3z12-2170x4yz14-13489x5y5-12718x5y3z2-11720x5yz4", 
  "x4z16-15002x5y6-9595x5y4z2-7143x5y2z4-10329x5z6", 
  "x4y2z14-10573x4z16+2860x5y6+4163x5y4z2+11769x5y2z4+9116x5z6", 
  "x3y13z4-15453x3y11z6+10547x3y7z10+14424x3y3z14+8522x3yz16-2784x4y7+8431x4y3\
z4-9057x4yz6", 
  "x3y12z6-610x3y8z10+4243x3y4z14+9526x3y2z16+12033x3z18-4951x4y8+4996x4y4z4+7\
481x4y2z6+12033x4z8", "y21+6250xyz10-5681x2y", 
  "x3y9z10+9464x3y7z12-6788x3y5z14+4832x3y3z16-11634x3yz18+6860x4y9-13449x4y7z\
2+7734x4y5z4+12659x4y3z6-340x4yz8", 
  "x3y11z8+9920x3y9z10+486x3y7z12-3421x3y5z14-15307x3y3z16+8483x3yz18+2868x4y9\
-4877x4y7z2-6223x4y5z4-290x4y3z6+6438x4yz8", 
  "x3y4z16+8928x3y2z18-14124x3z20+2007x4y10-13349x4y8z2+4093x4y6z4+13572x4y4z6\
-6556x4y2z8-15715x4z10-1669x5", 
  "x3y6z14+10343x3y4z16+9382x3y2z18-1786x3z20-8957x4y10-11046x4y8z2+3478x4y6z4\
-10723x4y4z6+1134x4y2z8-15530x4z10-4714x5", 
  "x3y8z12+5679x3y6z14+12687x3y4z16+7137x3y2z18-1810x3z20+14588x4y10+6970x4y8z\
2-15749x4y6z4-6798x4y4z6+2136x4y2z8-1810x4z10", 
  "x2y11z10+15047x2yz20+3036x3y11+13031x3y5z6-7508x3yz10-5558x4y", 
  "x2y15z6-5446x2y11z10+15260x2yz20+1375x3y11+2562x3y5z6+5332x3yz10+12564x4y",
  "z24+xz14+6x2y4", 
  "x3yz20-7799x4y11-7973x4y9z2-12545x4y7z4-11887x4y5z6+5201x4y3z8-3593x4yz10-9\
635x5y", 
  "x3y3z18+8399x3yz20+446x4y11+12886x4y9z2+1065x4y7z4+6600x4y5z6-2673x4y3z8+36\
86x4yz10-9988x5y", 
  "x3z22+9612x4y12+2181x4y10z2+4473x4y8z4-12155x4y6z6+2387x4y4z8-1763x4y2z10-1\
2409x4z12+828x5y2+519x5z2", 
  "x2y4z20+4607x3y14-13928x3y8z6-2084x3y4z10+11355x3z14+7679x4y4+11355x4z4", 
  "xy11z14+16000x2y15-10036x2yz14-13253x3y5-7998x3yz4", 
  "x2y10z14+6187x2y4z20+149x3y14-13600x3y10z4+11543x3y8z6+15121x3y4z10+6800x3z\
14-11014x4y4+1997x4z4", "y20z10-16001y10z20-15999xy10z10-15996x3", 
  "y11z20+5xy11z10-12500xyz20+11362x2yz10+11x3y" ]
gap> ps2 := List([1..40],k->SI_Proxy(j,k));
[ <proxy for <singular ideal (mutable), 41gens of deg <= 31>[1]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[2]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[3]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[4]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[5]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[6]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[7]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[8]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[9]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[10]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[11]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[12]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[13]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[14]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[15]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[16]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[17]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[18]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[19]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[20]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[21]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[22]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[23]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[24]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[25]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[26]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[27]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[28]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[29]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[30]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[31]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[32]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[33]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[34]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[35]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[36]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[37]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[38]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[39]>, 
  <proxy for <singular ideal (mutable), 41gens of deg <= 31>[40]> ]
gap> pss2 := List(ps2,_SI_p_String);
[ "x7", "x6y2+7578x6z2", "x6yz2", "x6z4", 
  "x5y7+4490x5y5z2-9765x5y3z4-7107x5yz6", 
  "x5y6z2-10470x5y4z4+14386x5y2z6-7505x5z8", "x5y5z4+4955x5y3z6+11753x5yz8", 
  "x5y2z8+8475x5z10-2011x6", "x5y4z6-8017x5y2z8+13310x5z10", "x5yz10+46x6y", 
  "x4y10z2+5763x4y8z4+9051x4y6z6-14328x4y4z8-9796x4y2z10-6358x4z12+11095x5y2-6\
037x5z2", 
  "x4y12+11999x4y10z2-10714x4y8z4-8418x4y6z6-1230x4y4z8-3198x4y2z10+5056x4z12-\
8884x5y2+3030x5z2", "x5z12-14323x6y2-6280x6z2", 
  "x4y7z6+13666x4y5z8-8520x4y3z10+14633x4yz12+8023x5y3-9904x5yz2", 
  "x4y9z4-3222x4y7z6-13591x4y5z8+8555x4y3z10+12401x4yz12+8315x5y3+12733x5yz2",
  "x4y4z10-6451x4y2z12+10771x4z14-8850x5y4+9916x5y2z2-13939x5z4", 
  "x4y6z8-2152x4y4z10-13484x4y2z12+6649x4z14-12278x5y4-3654x5y2z2+8070x5z4", 
  "x3y15+2024x3y11z4-12648x3y5z10-8346x3yz14-8682x4y5-9041x4yz4", 
  "x4y3z12-2170x4yz14-13489x5y5-12718x5y3z2-11720x5yz4", 
  "x4z16-15002x5y6-9595x5y4z2-7143x5y2z4-10329x5z6", 
  "x4y2z14-10573x4z16+2860x5y6+4163x5y4z2+11769x5y2z4+9116x5z6", 
  "x3y13z4-15453x3y11z6+10547x3y7z10+14424x3y3z14+8522x3yz16-2784x4y7+8431x4y3\
z4-9057x4yz6", 
  "x3y12z6-610x3y8z10+4243x3y4z14+9526x3y2z16+12033x3z18-4951x4y8+4996x4y4z4+7\
481x4y2z6+12033x4z8", "y21+6250xyz10-5681x2y", 
  "x3y9z10+9464x3y7z12-6788x3y5z14+4832x3y3z16-11634x3yz18+6860x4y9-13449x4y7z\
2+7734x4y5z4+12659x4y3z6-340x4yz8", 
  "x3y11z8+9920x3y9z10+486x3y7z12-3421x3y5z14-15307x3y3z16+8483x3yz18+2868x4y9\
-4877x4y7z2-6223x4y5z4-290x4y3z6+6438x4yz8", 
  "x3y4z16+8928x3y2z18-14124x3z20+2007x4y10-13349x4y8z2+4093x4y6z4+13572x4y4z6\
-6556x4y2z8-15715x4z10-1669x5", 
  "x3y6z14+10343x3y4z16+9382x3y2z18-1786x3z20-8957x4y10-11046x4y8z2+3478x4y6z4\
-10723x4y4z6+1134x4y2z8-15530x4z10-4714x5", 
  "x3y8z12+5679x3y6z14+12687x3y4z16+7137x3y2z18-1810x3z20+14588x4y10+6970x4y8z\
2-15749x4y6z4-6798x4y4z6+2136x4y2z8-1810x4z10", 
  "x2y11z10+15047x2yz20+3036x3y11+13031x3y5z6-7508x3yz10-5558x4y", 
  "x2y15z6-5446x2y11z10+15260x2yz20+1375x3y11+2562x3y5z6+5332x3yz10+12564x4y",
  "z24+xz14+6x2y4", 
  "x3yz20-7799x4y11-7973x4y9z2-12545x4y7z4-11887x4y5z6+5201x4y3z8-3593x4yz10-9\
635x5y", 
  "x3y3z18+8399x3yz20+446x4y11+12886x4y9z2+1065x4y7z4+6600x4y5z6-2673x4y3z8+36\
86x4yz10-9988x5y", 
  "x3z22+9612x4y12+2181x4y10z2+4473x4y8z4-12155x4y6z6+2387x4y4z8-1763x4y2z10-1\
2409x4z12+828x5y2+519x5z2", 
  "x2y4z20+4607x3y14-13928x3y8z6-2084x3y4z10+11355x3z14+7679x4y4+11355x4z4", 
  "xy11z14+16000x2y15-10036x2yz14-13253x3y5-7998x3yz4", 
  "x2y10z14+6187x2y4z20+149x3y14-13600x3y10z4+11543x3y8z6+15121x3y4z10+6800x3z\
14-11014x4y4+1997x4z4", "y20z10-16001y10z20-15999xy10z10-15996x3", 
  "y11z20+5xy11z10-12500xyz20+11362x2yz10+11x3y" ]
gap> pss=pss2;
true
