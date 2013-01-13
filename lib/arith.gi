
# install various arithmetic functions as methods

# Generic \+, faster method for polys
InstallGlobalFunction( _SI_Addition,
  function(a,b)
    local c;
    c := SI_\+(a,b);
    if IsMutable(a) or IsMutable(b) then return c;
    else return MakeImmutable(c); fi;
  end );
InstallOtherMethod(\+, ["IsSingularObj","IsSingularObj"], _SI_Addition);
InstallOtherMethod(\+, ["IsInt","IsSingularObj"], _SI_Addition);
InstallOtherMethod(\+, ["IsSingularObj","IsInt"], _SI_Addition);

# For small polynomials this variant can be 30%  faster. If SI_\+ were
# using SI_CallFuncM, it  would be slower again by a similar factor.
InstallGlobalFunction( _SI_Addition_fast,
  function(a,b)
    local c;
    c := _SI_p_Add_q(a,b);
    if IsMutable(a) or IsMutable(b) then return c; 
    else return MakeImmutable(c); fi;
  end );
InstallOtherMethod(\+, ["IsSingularPoly","IsSingularPoly"], _SI_Addition_fast);

InstallGlobalFunction( _SI_Subtraction,
  function(a,b)
    local c;
    c := SI_\-(a,b);
    if IsMutable(a) or IsMutable(b) then return c;
    else return MakeImmutable(c); fi;
  end );
InstallOtherMethod(\-, ["IsSingularObj","IsSingularObj"], _SI_Subtraction);
InstallOtherMethod(\-, ["IsInt","IsSingularObj"], _SI_Subtraction);
InstallOtherMethod(\-, ["IsSingularObj","IsInt"], _SI_Subtraction);

InstallGlobalFunction( _SI_Negation,
  function(a)
    local c;
    c := SI_\-(a);
    if IsMutable(a) then return c; 
    else return MakeImmutable(c); fi;
  end );
InstallGlobalFunction( _SI_Negation_fast,
  function(a)
    local c;
    c := _SI_p_Neg(a);
    if IsMutable(a) then return c; 
    else return MakeImmutable(c); fi;
  end );
InstallOtherMethod(AINV, ["IsSingularObj"], _SI_Negation);
InstallOtherMethod(AINV, ["IsSingularPoly"], _SI_Negation_fast);


InstallOtherMethod(\*, ["IsSingularObj","IsSingularObj"], SI_\*);
InstallOtherMethod(\*, ["IsInt","IsSingularObj"], SI_\*);
InstallOtherMethod(\*, ["IsSingularObj","IsInt"], SI_\*);
InstallOtherMethod(\*, ["IsSingularPoly","IsSingularPoly"], _SI_p_Mult_q);

InstallOtherMethod(\^, ["IsSingularObj","IsInt"], SI_\^);

InstallGlobalFunction( _SI_Comparer,
  function(a,b)
    local r;
    r := SI_\=\=(a,b);
    if r = fail then Error("cannot compare ",a," and ",b); fi;
    return r = 1;
  end);
InstallOtherMethod(\=, ["IsSingularObj","IsSingularObj"], _SI_Comparer);
InstallOtherMethod(\=, ["IsSingularIntVec", "IsSingularIntVec"], _SI_Comparer);

# Zero and One for rings and polys:
InstallOtherMethod(ZeroImmutable, ["IsSingularRing"], ZeroSM);
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

# multiplicative inverses, first the generic delegation to Singular
InstallOtherMethod(InverseSM, ["IsSingularObj"], function(sobj)
  local res;
  res := SI_\/(One(sobj), sobj);
  if not IsMutable(sobj) then
    MakeImmutable(res);
  fi;
  return res;
end);
# above doesn't handle non-constant polynomials correctly:
InstallOtherMethod(InverseSM, ["IsSingularPoly"], function(pol)
  local res;
  if SI_deg(pol) > 0 or IsZero(pol) then
    return fail;
  fi;
  res := SI_\/(1, pol);
  if not IsMutable(pol) then
    MakeImmutable(res);
  fi;
  return res;
end);
InstallOtherMethod(InverseMutable, ["IsSingularPoly"], function(pol)
  if SI_deg(pol) > 0 or IsZero(pol) then
    return fail;
  fi;
  return SI_\/(1, pol);
end);

InstallOtherMethod(QUO, ["IsSingularObj", "IsSingularObj"], function(a, b)
  return SI_\/(a, b);
end);

# this causes that DefaultRing of a Singular object with ring returns that ring
InstallOtherMethod(DefaultRingByGenerators, fam->
    fam = CollectionsFamily(SingularFamily), ["IsList"], l-> SI_ring(l[1]));
InstallMethod(\in, ["IsSingularPoly", "IsRing"], function(pol, r)
  return SI_ring(pol) = r;
end);
