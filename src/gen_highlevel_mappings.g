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

Read("src/highlevel_mappings_table.g");;

IsRingDep := Set([
    "ideal",
    "map",
    "matrix",
    "module",
    "number",
    "poly",
    "qring",
    "ring",
    "vector",
]);;
IsRingDepVariant := function(tabrow)
    return ForAll(tabrow[2], x->not (x in IsRingDep)) and
           tabrow[3] in IsRingDep;
end;;

#
# The following constructors get installed under a different
# name ("_SI_op_singular" instead of "SI_op") as we want to
# provide operations with the same name.
singularConstructors := Set([
    "bigint",
    "bigintmat",
    "ideal",
    "intmat",
    "intvec",
    "matrix",
    "number",
    "poly",
    "ring",
    "vector",
]);;



doit := function()
  local needring,s,ops,ops2,op,poss,name,nr,i;
s := OutputTextFile("lib/highlevel_mappings.g",false);
PrintTo(s,"# DO NOT EDIT, this file is generated automatically.\n");

ops := Set(Concatenation(List(SI_OPERATIONS,x->List(x,y->y[1]))));
ops2 := rec();
for i in [1,3..Length(SI_TOKENLIST)-1] do
    ops2.(SI_TOKENLIST[i+1]) := SI_TOKENLIST[i];
od;
for op in ops do
  if IsBound(ops2.(op)) then
    nr := ops2.(op);
    poss := List(SI_OPERATIONS,l->Filtered([1..Length(l)],i->l[i][1] = op));
    needring := false;
    for i in [1..3] do
        if ForAny(SI_OPERATIONS[i]{poss[i]},IsRingDepVariant) then
            needring := true;
        fi;
    od;
    if op in singularConstructors then
        name := Concatenation("_SI_", op, "_singular");
    else
        name := Concatenation("SI_", op);
    fi;
    if poss{[2..4]} = [[],[],[]] then
        # occurs only with one argument
        if needring then
            PrintTo(s,"BindGlobal(\"",name,"\",\n  function(r,a)\n",
                      "    SI_SetCurrRing(r);\n",
                      "    return _SI_CallFunc1(",nr,",a);\n",
                      "  end );\n\n");
        else
            PrintTo(s,"BindGlobal(\"",name,"\",\n  function(a)\n",
                      "    return _SI_CallFunc1(",nr,",a);\n",
                      "  end );\n\n");
        fi;
    elif poss{[1,3,4]} = [[],[],[]] then
        # occurs only with two arguments
        if needring then
            PrintTo(s,"BindGlobal(\"",name,"\",\n  function(r,a,b)\n",
                      "    SI_SetCurrRing(r);\n",
                      "    return _SI_CallFunc2(",nr,",a,b);\n",
                      "  end );\n\n");
        else
            PrintTo(s,"BindGlobal(\"",name,"\",\n  function(a,b)\n",
                      "    return _SI_CallFunc2(",nr,",a,b);\n",
                      "  end );\n\n");
        fi;
    elif poss{[1,2,4]} = [[],[],[]] then
        # occurs only with three arguments
        if needring then
            PrintTo(s,"BindGlobal(\"",name,"\",\n  function(r,a,b,c)\n",
                      "    SI_SetCurrRing(r);\n",
                      "    return _SI_CallFunc3(",nr,",a,b,c);\n",
                      "  end );\n\n");
        else
            PrintTo(s,"BindGlobal(\"",name,"\",\n  function(a,b,c)\n",
                      "    return _SI_CallFunc3(",nr,",a,b,c);\n",
                      "  end );\n\n");
        fi;
    elif poss[4] <> [] then
        # variable argument count: we only use _SI_CallFuncM, and relay
        # on the Singular interpreter (resp. on jjCALL1ARG etc. entries
        # in table dArithM) to dispatch to the 1/2/3 arg variants as needed.
        
        # For now we just assume these that the parameter lists always
        # specify a ring for these commands.
        if needring then
            Error("vararg op ", op, " needs ring\n");
        fi;
        
        poss := Set(SI_OPERATIONS[4]{poss[4]}, x -> x[2]);
        
        PrintTo(s,    "BindGlobal(\"",name,"\",\n  function(arg)\n");
        if -1 in poss or (-2 in poss and 0 in poss) then
            # takes arbitrary number of arguments
        elif -2 in poss then
            PrintTo(s,"    if Length(arg) = 0 then\n",
                      "      Error(\"incorrect number of arguments\");\n",
                      "    fi;\n");
        else
            PrintTo(s,"    if not Length(arg) in ", poss, " then\n",
                      "      Error(\"incorrect number of arguments\");\n",
                      "    fi;\n");
        fi;
        PrintTo(s,    "    return _SI_CallFuncM(",nr,",arg);\n",
                      "  end );\n\n");
    else
        # op occurs with at least two different fixed argument counts
        poss := Filtered([1..3], i -> [] <> poss[i]);
        
        PrintTo(s,    "BindGlobal(\"",name,"\",\n  function(arg)\n");
        if 1 in poss then
            PrintTo(s,"    if Length(arg) = 1 then\n",
                      "      return _SI_CallFunc1(",nr,",arg[1]);\n",
                      "    fi;\n");
        fi;
        if 2 in poss then
            PrintTo(s,"    if Length(arg) = 2 then\n",
                      "      return _SI_CallFunc2(",nr,",arg[1],arg[2]);\n",
                      "    fi;\n");
        fi;
        if 3 in poss then
            PrintTo(s,"    if Length(arg) = 3 then\n",
                      "      return _SI_CallFunc3(",nr,",arg[1],arg[2],arg[3]);\n",
                      "    fi;\n");
        fi;
        PrintTo(s,    "    Error(\"incorrect number of arguments\");\n",
                      "  end );\n\n");
    fi;
  fi;
od;

CloseStream(s);
end;;
doit();;
