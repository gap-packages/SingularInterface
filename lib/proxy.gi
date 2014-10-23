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

