# SingularInterface: A GAP interface to Singular
#
# Copyright of SingularInterface belongs to its developers.
# Please refer to the COPYRIGHT file for details.
#
# SPDX-License-Identifier: GPL-2.0-or-later

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
