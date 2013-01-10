
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
InstallOtherMethod(\=, ["IsSingularIntVec", "IsSingularIntVec"],
  function(a,b) return SI_\=\=(a,b) = 1; end);

# Zero and One for rings and polys:
InstallOtherMethod(ZeroImmutable, ["IsSingularRing"], function(sobj)
  return ZeroSM(sobj);
end);
InstallOtherMethod(ZeroImmutable, ["IsSingularPoly"], function(sobj)
  return ZeroSM(SI_ring(sobj));
end);
InstallOtherMethod(ZeroMutable, ["IsSingularRing"], function(sobj)
  return SI_poly(sobj, "0");
end);
InstallOtherMethod(ZeroMutable, ["IsSingularPoly"], function(sobj)
  return SI_poly(SI_ring(sobj), "0");
end);
# ZeroSM for rings and polys is done in the kernel!
# This is efficient for rings and immutable polys and
# for mutable polys it delegates to ZeroMutable and method selection!

InstallOtherMethod(OneImmutable, ["IsSingularRing"], function(sobj)
  return OneSM(sobj);
end);
InstallOtherMethod(OneImmutable, ["IsSingularPoly"], function(sobj)
  return OneSM(SI_ring(sobj));
end);
InstallOtherMethod(OneMutable, ["IsSingularRing"], function(sobj)
  return SI_poly(sobj, "1");
end);
InstallOtherMethod(OneMutable, ["IsSingularPoly"], function(sobj)
  return SI_poly(SI_ring(sobj), "1");
end);
# OneSM for rings and polys is done in the kernel!
# This is efficient for rings and immutable polys and
# for mutable polys it delegates to OneMutable and method selection!

InstallOtherMethod(Zero, ["IsSingularBigInt"], sobj -> SI_bigint(0));
InstallOtherMethod(ZeroMutable, ["IsSingularBigInt"], sobj -> SI_bigint(0));
InstallOtherMethod(One, ["IsSingularBigInt"], sobj -> SI_bigint(1));
InstallOtherMethod(OneMutable, ["IsSingularBigInt"], sobj -> SI_bigint(1));

# HACK: Fallback (works correctly only for objects that support subtracting
InstallOtherMethod(Zero, ["IsSingularObj"], sobj -> sobj - sobj);
InstallOtherMethod(ZeroMutable, ["IsSingularObj"], sobj -> sobj - sobj);

# now we can make use of  the following implication
InstallTrueMethod(IsRingElementWithOne, IsSingularPoly);

# list access makes sense for many Singular objects
BindGlobal("SI_Entry", function(sobj, i)
  return _SI_CallFunc2(91, sobj, i); end);
#    this is not used in GAP 4.5.5, kernel complains
InstallOtherMethod(\[\], [IsSingularObj, IsInt], SI_Entry);
