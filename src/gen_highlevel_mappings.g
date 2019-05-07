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

if not IsBound(SI_OPERATIONS) then
    Read("src/highlevel_mappings_table.g");
fi;

# The following information from grammer.y is one of the things that helped to
# create the record 'IsRingDep' below.
#
# TODO: Note that the data in the section titled "ring dependent cmd" is not
# yet used; and while it is close to what we auto-deduced, there are subtle
# differences...

#
# /* types, part 1 (ring indep.)*/
# %token <i> GRING_CMD
# %token <i> BIGINTMAT_CMD
# %token <i> INTMAT_CMD
# %token <i> PROC_CMD
# %token <i> RING_CMD
#
# /* valid when ring defined ! */
# %token <i> BEGIN_RING
# /* types, part 2 */
# %token <i> BUCKET_CMD
# %token <i> IDEAL_CMD
# %token <i> MAP_CMD
# %token <i> MATRIX_CMD
# %token <i> MODUL_CMD
# %token <i> NUMBER_CMD
# %token <i> POLY_CMD
# %token <i> RESOLUTION_CMD
# %token <i> SMATRIX_CMD
# %token <i> VECTOR_CMD
# /* end types */
#
# /* ring dependent cmd, with argumnts indep. of a ring*/
# %token <i> BETTI_CMD
# %token <i> E_CMD
# %token <i> FETCH_CMD
# %token <i> FREEMODULE_CMD
# %token <i> KEEPRING_CMD
# %token <i> IMAP_CMD
# %token <i> KOSZUL_CMD
# %token <i> MAXID_CMD
# %token <i> MONOM_CMD
# %token <i> PAR_CMD
# %token <i> PREIMAGE_CMD
# %token <i> VAR_CMD
#
# /*system variables in ring block*/
# %token <i> VALTVARS
# %token <i> VMAXDEG
# %token <i> VMAXMULT
# %token <i> VNOETHER
# %token <i> VMINPOLY
#
# %token <i> END_RING
# /* end of ring definitions */


# the following record maps singular argument "types" (using their names in
# the Singular interpreter) to a boolean: true if that type implicitly
# references a ring, and false otherwise
IsRingDep := rec(
    # ring dependant
    ideal := true,
    map := true,
    matrix := true,
    module := true,
    number := true,
    poly := true,
    polyBucket := true,
    qring := true,
    resolution := true,
    ring := true,       # HACK
    smatrix := true,
    vector := true,

    cring := true, # ??? CRING_CMD

    # the following are new in Singular 4.2
    Matrix := true,  # ??? CMATRIX_CMD
    Number := true,  # ??? CNUMBER_CMD
    Poly := true,    # ??? CPOLY_CMD

    # not ring dependant
    bigint := false,
    bigintmat := false,
    int := false,
    intmat := false,
    intvec := false,
    LIB := false,
    link := false,
    nothing := false,
    package := false,
    proc := false,
    string := false,

    any_type := false,  # can be anything, so we must assume it is something w/o ring
    def := false,  # ???
    identifier := false,  # ??? IDHDL  -> interpreter handle
    list := false,  # ???
);


# a variant of a Singular interpreter op is "ring dependent" if none of its
# arguments contains a ring reference, but its output does. For these, we need
# to provide the ring as an explicit argument
IsRingDepVariant := function(tabrow)
    return ForAll(tabrow[2], x -> not IsRingDep.(x)) and
           IsRingDep.(tabrow[3]);
end;

# The following constructors get installed under different names than
# everything else ("_SI_op_singular" instead of "SI_op"), since we need to
# provide operations with the same names.
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
]);

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
        if ForAny(SI_OPERATIONS[i]{poss[i]}, IsRingDepVariant) then
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
                      "    return _SI_CallFunc1(r,",nr,",a);\n",
                      "  end );\n\n");
        else
            PrintTo(s,"BindGlobal(\"",name,"\",\n  function(a)\n",
                      "    return _SI_CallFunc1(0,",nr,",a);\n",
                      "  end );\n\n");
        fi;
    elif poss{[1,3,4]} = [[],[],[]] then
        # occurs only with two arguments
        if needring then
            PrintTo(s,"BindGlobal(\"",name,"\",\n  function(r,a,b)\n",
                      "    return _SI_CallFunc2(r,",nr,",a,b);\n",
                      "  end );\n\n");
        else
            PrintTo(s,"BindGlobal(\"",name,"\",\n  function(a,b)\n",
                      "    return _SI_CallFunc2(0,",nr,",a,b);\n",
                      "  end );\n\n");
        fi;
    elif poss{[1,2,4]} = [[],[],[]] then
        # occurs only with three arguments
        if needring then
            PrintTo(s,"BindGlobal(\"",name,"\",\n  function(r,a,b,c)\n",
                      "    return _SI_CallFunc3(r,",nr,",a,b,c);\n",
                      "  end );\n\n");
        else
            PrintTo(s,"BindGlobal(\"",name,"\",\n  function(a,b,c)\n",
                      "    return _SI_CallFunc3(0,",nr,",a,b,c);\n",
                      "  end );\n\n");
        fi; 
    else
        
        # For now we just assume that the parameter lists always specify
        # a ring for these commands.
        if needring then
            Print("WARNING: vararg op '", op, "' needs ring\n");

            Print("  the following methods are NOT ring dependant:\n");
            for i in [1..4] do
                for meth in SI_OPERATIONS[i]{poss[i]} do
                    if not IsRingDepVariant(meth) then
                        Print("    ", meth, "\n");
                    fi;
                od;
            od;

            Print("  the following methods are ring dependant:\n");
            for i in [1..4] do
                for meth in SI_OPERATIONS[i]{poss[i]} do
                    if IsRingDepVariant(meth) then
                        Print("    ", meth, "\n");
                    fi;
                od;
            od;

            #Error("vararg op ", op, " needs ring\n");
            #continue;
        fi;

        PrintTo(s,    "BindGlobal(\"",name,"\",\n  function(arg)\n");
        if Length(poss[1]) > 0 then
            PrintTo(s,"    if Length(arg) = 1 then\n",
                      "      return _SI_CallFunc1(0,",nr,",arg[1]);\n",
                      "    fi;\n");
        fi;
        if Length(poss[2]) > 0 then
            PrintTo(s,"    if Length(arg) = 2 then\n",
                      "      return _SI_CallFunc2(0,",nr,",arg[1],arg[2]);\n",
                      "    fi;\n");
        fi;
        if Length(poss[3]) > 0 then
            PrintTo(s,"    if Length(arg) = 3 then\n",
                      "      return _SI_CallFunc3(0,",nr,",arg[1],arg[2],arg[3]);\n",
                      "    fi;\n");
        fi;

        if Length(poss[4]) > 0 then
            poss := Set(SI_OPERATIONS[4]{poss[4]}, x -> x[2]);
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
            PrintTo(s,    "    return _SI_CallFuncM(0,",nr,",arg);\n");
        else
            PrintTo(s,    "    Error(\"incorrect number of arguments\");\n");
        fi;

        PrintTo(s,    "  end );\n\n");
    fi;
  fi;
od;

CloseStream(s);

QUIT;
