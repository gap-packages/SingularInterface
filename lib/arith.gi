
# install various arithmetic functions as methods

# Generic \+, faster method for polys
InstallOtherMethod(\+, ["IsSingularObj","IsSingularObj"], SI_\+);
InstallOtherMethod(\+, ["IsInt","IsSingularObj"], SI_\+);
InstallOtherMethod(\+, ["IsSingularObj","IsInt"], SI_\+);

# For small polynomials this variant can be 30%  faster. If SI_\+ were 
# using SI_CallFuncM, it  would be slower again by a similar factor. 
InstallOtherMethod(\+, ["IsSingularPoly","IsSingularPoly"], _SI_p_Add_q);

InstallOtherMethod(\-, ["IsSingularObj","IsSingularObj"], SI_\-);
InstallOtherMethod(\-, ["IsInt","IsSingularObj"], SI_\-);
InstallOtherMethod(\-, ["IsSingularObj","IsInt"], SI_\-);

InstallOtherMethod(AINV, ["IsSingularObj"], SI_\-);
InstallOtherMethod(AINV, ["IsSingularPoly"], _SI_p_Neg);


InstallOtherMethod(\*, ["IsSingularObj","IsSingularObj"], SI_\*);
InstallOtherMethod(\*, ["IsInt","IsSingularObj"], SI_\*);
InstallOtherMethod(\*, ["IsSingularObj","IsInt"], SI_\*);
InstallOtherMethod(\*, ["IsSingularPoly","IsSingularPoly"], _SI_p_Mult_q);

InstallOtherMethod(\^, ["IsSingularObj","IsInt"], SI_\^);

InstallOtherMethod(\=, ["IsSingularObj","IsSingularObj"], 
  function(a,b) return SI_\=\=(a,b) = 1; end);

# for any singular object that carries a ring
InstallOtherMethod(One, ["IsSingularPoly"], function(sobj)
  return SI_poly(SI_ring(sobj), "1");
end);

InstallOtherMethod(One, ["IsSingularBigInt"], function(sobj)
  return SI_bigint(1);
end);
InstallOtherMethod(Zero, ["IsSingularPoly"], function(sobj)
  return SI_poly(SI_ring(sobj), "0");
end);

InstallOtherMethod(Zero, ["IsSingularBigInt"], function(sobj)
  return SI_bigint(0);
end);

# now we can make use of  the following implication
InstallTrueMethod(IsRingElementWithOne, IsSingularPoly);

# list access makes sense for many Singular objects
BindGlobal("SI_Entry", function(sobj, i)
  return _SI_CallFunc2(91, sobj, i); end);
#    this is not used in GAP 4.5.5, kernel complains
InstallOtherMethod(\[\], [IsSingularObj, IsInt], SI_Entry);
