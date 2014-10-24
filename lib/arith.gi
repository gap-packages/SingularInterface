#
# SingularInterface: A GAP interface to Singular
#
# Copyright (C) 2011-2014  Mohamed Barakat, Max Horn, Frank Lübeck,
#                          Oleksandr Motsak, Max Neunhöffer, Hans Schönemann
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
#


# install various arithmetic functions as methods

# Generic \+, faster method for polys
InstallGlobalFunction( _SI_Addition,
  function(a,b)
    local c;
    c := SI_\+(a,b);
    if IsMutable(a) or IsMutable(b) then return c;
    else return MakeImmutable(c); fi;
  end );
InstallOtherMethod(\+, ["IsSI_Object","IsSI_Object"], _SI_Addition);
InstallOtherMethod(\+, ["IsInt","IsSI_Object"], _SI_Addition);
InstallOtherMethod(\+, ["IsSI_Object","IsInt"], _SI_Addition);

# For small polynomials this variant can be 30%  faster. If SI_\+ were
# using SI_CallFuncM, it  would be slower again by a similar factor.
InstallGlobalFunction( _SI_Addition_fast,
  function(a,b)
    local c;
    c := _SI_p_Add_q(a,b);
    if IsMutable(a) or IsMutable(b) then return c; 
    else return MakeImmutable(c); fi;
  end );
InstallOtherMethod(\+, ["IsSI_poly","IsSI_poly"], _SI_Addition_fast);

InstallGlobalFunction( _SI_Subtraction,
  function(a,b)
    local c;
    c := SI_\-(a,b);
    if IsMutable(a) or IsMutable(b) then return c;
    else return MakeImmutable(c); fi;
  end );
InstallOtherMethod(\-, ["IsSI_Object","IsSI_Object"], _SI_Subtraction);
InstallOtherMethod(\-, ["IsInt","IsSI_Object"], _SI_Subtraction);
InstallOtherMethod(\-, ["IsSI_Object","IsInt"], _SI_Subtraction);

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
InstallOtherMethod(AINV, ["IsSI_Object"], _SI_Negation);
InstallOtherMethod(AINV, ["IsSI_poly"], _SI_Negation_fast);


InstallOtherMethod(\*, ["IsSI_Object","IsSI_Object"], SI_\*);
InstallOtherMethod(\*, ["IsInt","IsSI_Object"], SI_\*);
InstallOtherMethod(\*, ["IsSI_Object","IsInt"], SI_\*);
InstallOtherMethod(\*, ["IsSI_poly","IsSI_poly"], _SI_p_Mult_q);

InstallOtherMethod(\^, ["IsSI_Object","IsInt"], SI_\^);

InstallGlobalFunction( _SI_Comparer,
  function(a,b)
    local r;
    r := SI_\=\=(a,b);
    if r = fail then Error("cannot compare ",a," and ",b); fi;
    return r = 1;
  end);
# Note: we must use a rank higher than 4, as otherwise a generic
# method of the IO package for comparing lists may be triggered
# (which then fails to actually perform the comparison).
InstallOtherMethod(\=, ["IsSI_Object","IsSI_Object"], 10, _SI_Comparer);

# Zero and One for rings and polys:
InstallOtherMethod(ZeroImmutable, ["IsSI_ring"], ZeroSM);
InstallOtherMethod(ZeroImmutable, ["IsSI_poly"], function(sobj)
  return ZeroSM(SI_RingOfSingobj(sobj));
end);
InstallOtherMethod(ZeroMutable, ["IsSI_ring"], function(sobj)
  return SI_poly(sobj, "0");
end);
InstallOtherMethod(ZeroMutable, ["IsSI_poly"], function(sobj)
  return SI_poly(SI_RingOfSingobj(sobj), "0");
end);
# ZeroSM for rings and polys is done in the kernel!
# This is efficient for rings and immutable polys and
# for mutable polys it delegates to ZeroMutable and method selection!

InstallOtherMethod(OneImmutable, ["IsSI_ring"], function(sobj)
  return OneSM(sobj);
end);
InstallOtherMethod(OneImmutable, ["IsSI_poly"], function(sobj)
  return OneSM(SI_RingOfSingobj(sobj));
end);
InstallOtherMethod(OneMutable, ["IsSI_ring"], function(sobj)
  return SI_poly(sobj, "1");
end);
InstallOtherMethod(OneMutable, ["IsSI_poly"], function(sobj)
  return SI_poly(SI_RingOfSingobj(sobj), "1");
end);
# OneSM for rings and polys is done in the kernel!
# This is efficient for rings and immutable polys and
# for mutable polys it delegates to OneMutable and method selection!

InstallOtherMethod(Zero, ["IsSI_bigint"], sobj -> SI_bigint(0));
InstallOtherMethod(ZeroMutable, ["IsSI_bigint"], sobj -> SI_bigint(0));
InstallOtherMethod(One, ["IsSI_bigint"], sobj -> SI_bigint(1));
InstallOtherMethod(OneMutable, ["IsSI_bigint"], sobj -> SI_bigint(1));

# HACK: Fallback (works correctly only for objects that support subtracting
InstallOtherMethod(Zero, ["IsSI_Object"], sobj -> sobj - sobj);
InstallOtherMethod(ZeroMutable, ["IsSI_Object"], sobj -> sobj - sobj);

# now we can make use of  the following implication
InstallTrueMethod(IsRingElementWithOne, IsSI_poly);

# list access makes sense for many Singular objects
InstallOtherMethod(\[\], [IsSI_Object, IsInt], function(sobj, i)
    return SI_\[(sobj, i);
end);



# multiplicative inverses, first the generic delegation to Singular
InstallOtherMethod(InverseSM, ["IsSI_Object"], function(sobj)
  local res;
  res := SI_\/(One(sobj), sobj);
  if not IsMutable(sobj) then
    MakeImmutable(res);
  fi;
  return res;
end);
# above doesn't handle non-constant polynomials correctly:
InstallOtherMethod(InverseSM, ["IsSI_poly"], function(pol)
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
InstallOtherMethod(InverseMutable, ["IsSI_poly"], function(pol)
  if SI_deg(pol) > 0 or IsZero(pol) then
    return fail;
  fi;
  return SI_\/(1, pol);
end);

InstallOtherMethod(QUO, ["IsSI_Object", "IsSI_Object"], function(a, b)
  return SI_\/(a, b);
end);

