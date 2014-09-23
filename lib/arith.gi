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
# Note: we must use a rank higher than 4, as otherwise a generic
# method of the IO package for comparing lists may be triggered
# (which then fails to actually perform the comparison).
InstallOtherMethod(\=, ["IsSingularObj","IsSingularObj"], 10, _SI_Comparer);

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
InstallOtherMethod(\[\], [IsSingularObj, IsInt], function(sobj, i)
    return SI_\[(sobj, i);
end);

#
# Alternative access via the syntax mat[[row,col]]
#
# This is a syntax extension in GAP; most of it is not yet
# in a released GAP version.
#
# Usage example:
#
#
# gap> m:=SI_intmat([[1,2,3],[4,5,6]]);
# <singular intmat:[ [ 1, 2, 3 ], [ 4, 5, 6 ] ]>
# gap> IsBound(m[[1,2]]);
# true
# gap> m[[1,2]];
# 2
# gap> m[[1,2]]:=42;
# 42
# gap> m[[1,2]];
# 42
# gap> m;
# <singular intmat:[ [ 1, 42, 3 ], [ 4, 5, 6 ] ]>
#
_SI_MatElm_with_list := function(mat, l)
    Assert(0, Length(l) = 2 and ForAll(l, IsPosInt));   # TODO: replace by proper error
    return _SI_MatElm(mat, l[1], l[2]);
end;
InstallOtherMethod(\[\], [IsSingularMatrix, IsList], _SI_MatElm_with_list);
InstallOtherMethod(\[\], [IsSingularIntMat, IsList], _SI_MatElm_with_list);
InstallOtherMethod(\[\], [IsSingularBigIntMat, IsList], _SI_MatElm_with_list);

_SI_SetMatElm_with_list := function(mat, l, val)
    Assert(0, Length(l) = 2 and ForAll(l, IsPosInt));
    _SI_SetMatElm(mat, l[1], l[2], val);
end;
InstallOtherMethod(\[\]\:\=, [IsSingularMatrix, IsList, IsObject], _SI_SetMatElm_with_list);
InstallOtherMethod(\[\]\:\=, [IsSingularIntMat, IsList, IsObject], _SI_SetMatElm_with_list);
InstallOtherMethod(\[\]\:\=, [IsSingularBigIntMat, IsList, IsObject], _SI_SetMatElm_with_list);

_SI_MatElmIsBound_with_list := function(mat, l)
    return Length(l) = 2 and l[1] in [1..SI_nrows(mat)] and l[2] in [1..SI_ncols(mat)];
end;
InstallOtherMethod(ISB_LIST, [IsSingularMatrix, IsList], _SI_MatElmIsBound_with_list);
InstallOtherMethod(ISB_LIST, [IsSingularIntMat, IsList], _SI_MatElmIsBound_with_list);
InstallOtherMethod(ISB_LIST, [IsSingularBigIntMat, IsList], _SI_MatElmIsBound_with_list);

_SI_MatElmUnbind_with_list := function(mat, l)
    Error("Cannot unbind entries of singular matrix");
end;
InstallOtherMethod(UNB_LIST, [IsSingularMatrix, IsList], _SI_MatElmUnbind_with_list);
InstallOtherMethod(UNB_LIST, [IsSingularIntMat, IsList], _SI_MatElmUnbind_with_list);
InstallOtherMethod(UNB_LIST, [IsSingularBigIntMat, IsList], _SI_MatElmUnbind_with_list);


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
