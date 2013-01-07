Read("highlevel_mappings_table.g");;
IsRingDep := 
Set(["ideal","map","matrix","module","number","poly","qring","ring","vector"]);;
IsRingDepVariant := function(tabrow)
  return ForAll(tabrow[2],x->not(x in IsRingDep)) and
         tabrow[3] in IsRingDep;
end;;

doit := function()
  local needring,s,ops,ops2,op,poss,name,nr,i;
s := OutputTextFile("highlevel_mappings.g",false);
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
    name := Concatenation("SI_",op);
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
    else
        # generic Case:
        if needring then
            PrintTo(s,"BindGlobal(\"",name,"\",\n  function(arg)\n",
                    "    SI_SetCurrRing(arg[1]);\n",
                    "    return _SI_CallFuncM(",nr,",arg{[2..Length(arg)]});\n",
                    "  end );\n\n");
        else
            PrintTo(s,"BindGlobal(\"",name,"\",\n  function(arg)\n",
                      "    return _SI_CallFuncM(",nr,",arg);\n",
                      "  end );\n\n");
        fi;
    fi;
  fi;
od;

CloseStream(s);
end;;
doit();;
