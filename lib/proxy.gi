# SingularInterface: A GAP interface to Singular
#
# Copyright of SingularInterface belongs to its developers.
# Please refer to the COPYRIGHT file for details.
#
# SPDX-License-Identifier: GPL-2.0-or-later

InstallMethod(SI_Proxy, "for a singular object and a positive integer",
  [ IsSI_Object, IsPosInt ],
  function( o, i )
    local l;
    l := [o,i];
    Objectify(_SI_ProxiesType, l);
    return l;
  end );

InstallMethod(SI_Proxy, "for a singular object and two positive integers",
  [ IsSI_Object, IsPosInt, IsPosInt ],
  function( o, i, j)
    local l;
    l := [o,i,j];
    Objectify(_SI_ProxiesType, l);
    return l;
  end );

InstallMethod(SI_Proxy, "for a singular object and a string",
  [ IsSI_Object, IsStringRep ],
  function( o, s)
    local l;
    l := [o,s];
    Objectify(_SI_ProxiesType, l);
    return l;
  end );

InstallMethod(ViewString, "for a singular proxy object",
  [ IsSI_proxy ],
  function(p)
    local str;
    str := "<proxy for ";
    Append(str, ViewString(p![1]));
    Append(str, "[");
    Append(str, ViewString(p![2]));
    if IsBound(p![3]) then
        Append(str, ",");
        Append(str, ViewString(p![3]));
    fi;
    Append(str, "]>");
    return str;
  end );

