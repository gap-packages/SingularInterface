Read("highlevel_mappings_table.g");;
doit := function()
  local s,ops,ops2,op,poss,name,nr,i;
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
    poss := List(SI_OPERATIONS,l->First([1..Length(l)],i->l[i][1] = op));
    name := Concatenation("SI_",op);
    if poss{[2..4]} = [fail,fail,fail] then
        # occurs only with one argument
        PrintTo(s,"BindGlobal(\"",name,"\",\n  function(a)\n",
                  "    return SI_CallFunc1(",nr,",a);\n",
                  "  end );\n\n");
    elif poss{[1,3,4]} = [fail,fail,fail] then
        # occurs only with two arguments
        PrintTo(s,"BindGlobal(\"",name,"\",\n  function(a,b)\n",
                  "    return SI_CallFunc2(",nr,",a,b);\n",
                  "  end );\n\n");
    elif poss{[1,2,4]} = [fail,fail,fail] then
        # occurs only with three arguments
        PrintTo(s,"BindGlobal(\"",name,"\",\n  function(a,b,c)\n",
                  "    return SI_CallFunc3(",nr,",a,b,c);\n",
                  "  end );\n\n");
    else
        # generic case:
        PrintTo(s,"BindGlobal(\"",name,"\",\n  function(arg)\n",
                  "    return SI_CallFuncM(",nr,",arg);\n",
                  "  end );\n\n");
    fi;
  fi;
od;

CloseStream(s);
end;;
doit();;
