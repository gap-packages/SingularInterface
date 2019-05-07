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

InstallGlobalFunction( _SI_BindSingularProcs,
  function( prefix )
    local n,nn,procs,st,s;
    procs := _SI_SingularProcs();
    st := "";
    for n in procs do
        nn := Concatenation(prefix,n);
        if not(IsBoundGlobal(nn)) then
            Append(st,Concatenation("BindGlobal(\"",
                nn,"\", function(arg) return SI_CallProc(\"",
                n,"\",arg); end);\n"));
        fi;
    od;
    s := InputTextString(st);
    Read(s);
  end );

# This is a dirty hack but seems to work:
MakeReadWriteGlobal("SI_LIB");
Unbind(SI_LIB);
BindGlobal("SI_LIB",function(libname)
    local res;
    res := SI_load(libname,"with");
    if res = true then
        _SI_BindSingularProcs("SIL_");
    fi;
    return res;
end);


InstallMethod( Singular, "for a string in stringrep",
  [ IsStringRep ],
  function( st )
    local ret;
    ret := _SI_EVALUATE(st);
    Print(SingularLastError());
    return ret;
  end );

# empty string is not in string rep, handle it separately
InstallMethod( Singular, "for a string in stringrep",
  [ IsString and IsEmpty ],
  function( st )
    return 0;
  end );

InstallMethod( Singular, "without arguments",
  [ ],
  function()
    local i,s;
    i := InputTextUser();
    while true do
        Print("\rS> \c");
        s := ReadLine(i);
        if s = "\n" then break; fi;
        Singular(s);
        Print(SingularLastOutput());
    od;
    CloseStream(i);
  end );

InstallGlobalFunction( SingularLastError,
  function()
    return _SI_LastErrorString;
  end );

InstallGlobalFunction( SingularUnbind, function(x)
   Singular(Concatenation("if(defined(",x,")){kill ",x,";};"));
end);
