InstallMethod(SI_bigint,[IsSingularObj],SI_bigint_singular);
InstallMethod(SI_bigint,[IsInt],_SI_bigint);

InstallMethod(SI_bigintmat,[IsSingularObj],SI_bigintmat_singular);
#InstallMethod(SI_bigintmat,[IsSingularObj,IsPosInt,IsPosInt],SI_bigintmat_singular);
InstallMethod(SI_bigintmat,[IsList],_SI_bigintmat);

InstallMethod(SI_number,[IsSingularRing, IsSingularObj],SI_number_singular);
InstallMethod(SI_number,[IsSingularRing, IsInt],_SI_number);
InstallMethod(SI_number,[IsSingularRing, IsFFE],_SI_number);
InstallMethod(SI_number,[IsSingularRing, IsRat],_SI_number);

InstallMethod(SI_intvec,[IsSingularObj],SI_intvec_singular);
InstallMethod(SI_intvec,[IsList],_SI_intvec);

InstallMethod(SI_intmat,[IsSingularObj],SI_intmat_singular);
InstallMethod(SI_intmat,[IsSingularObj,IsPosInt,IsPosInt],SI_intmat_singular);
InstallMethod(SI_intmat,[IsList],_SI_intmat);


# TODO: document the format accepted by _ParseIndeterminatesDescription
# TODO: add support for Singular format  "x(2..4)" ->  x(2), x(3), x(4)
BindGlobal("_ParseIndeterminatesDescription", function(str)
    local parts, result, p, v, n, i, name, tmp, range, open, close, pos, ranges;
    if IsEmpty(str) then
        # Must have at least one variable
        return [ "dummy_variable" ];
    fi;
    if not IsString(str) then
        Error("Argument must be a string");
    fi;

    # Remove all spaces ...
    str := Filtered(str, x -> x <> ' ');

    # ... and split comma separated values
    parts := SplitString(str, ",");

    result := [];
    for p in parts do
        if p[Length(p)] = '.' then
            Error("Invalid input '",p," ends with with '.'");
        elif p[1] = '(' then
            Error("Invalid input '",p," starts with with '('");
        elif '(' in p then
            # Singular style!
            #  x(2..4) ->  x(2), x(3), x(4)
            #  x(4..2) ->  x(4), x(3), x(2)
            #  x(1) -> x(1)
            #  x(1..0)(-1..0)  -> x(1)(-1) x(1)(0) x(0)(-1) x(0)(0)
            open := Positions(p,'(');
            close := Positions(p,')');
            if Length(open) <> Length(close) then
                Error("Invalid format in '",p,"'");
            fi;

            n := Length(open);
            if close[n] <> Length(p) or open{[2..n]} <> close{[1..n-1]} + 1 then
                Error("Invalid format in '",p,"'");
            fi;
            name := p{[1..open[1]-1]};
            if not IsValidIdentifier(name) then
                Error("'", name, "' is not a valid identifier in '",p,"'");
            fi;
            
            ranges := [];
            for i in [1..n] do
                tmp := p{[open[i]+1..close[i]-1]};
                pos := PositionSublist(tmp, "..");
                if pos <> fail then
                    tmp := [ tmp{[1..pos-1]}, tmp{[pos+2..Length(tmp)]} ];
                    if "" in tmp then
                        Error("Invalid format in '",p,"'");
                    fi;
                    tmp := [ Int(tmp[1]), Int(tmp[2]) ];
                    if fail in tmp then
                        Error("Invalid format in '",p,"'");
                    fi;
                    if tmp[1] <= tmp[2] then
                        ranges[i] := [tmp[1]..tmp[2]];
                    else
                        ranges[i] := [tmp[1],tmp[1]-1..tmp[2]];
                    fi;
                else
                    if tmp = "" or Int(tmp) = fail then
                        Error("Invalid format in '",p,"'");
                    fi;
                    ranges[i] := [Int(tmp)];
                fi;
            od;
            for tmp in Cartesian(ranges) do
                tmp := List(tmp, i -> Concatenation("(",String(i),")"));
                tmp := Concatenation(tmp);
                Add(result, Concatenation(name, tmp));
            od;
            
        elif PositionSublist( p, ".." ) <> fail then
            v := SplitString(p, ".");
            if Length(v) <> 3 then
                Error("Too many '.' in '",p,"'");
            fi;
            if ForAll(v[1], IsDigitChar) then
                Error("Text left of '..' must contain at least one non-digit (in '",p,"')");
            fi;
            if not ForAll(v[3], IsDigitChar) then
                Error("Text right of '..' must not contain any non-digits (in '",p,"')");
            fi;

            # Find longest suffix of v[1] consisting of only digits
            n := Length(v[1]);
            if not IsDigitChar(v[1][n]) then
                Error("Text left of '..' must end with at least one digit (in '",p,"')");
            fi;
            while IsDigitChar(v[1][n]) do
                n := n - 1;
            od;

            # Split into "name" part and "range" part
            name := v[1]{[1..n]};
            if not IsValidIdentifier(name) then
                Error("'", name, "' is not a valid identifier in '",p,"'");
            fi;

            # Extract the numerical range
            tmp := v[1]{[n+1..Length(v[1])]};
            range := [ Int(tmp) .. Int(v[3]) ];
            if IsEmpty(range) then
                Error("Invalid range in '",p,"'");
            fi;

            # Generate the variable names
            for i in range do
                Add(result,  Concatenation(name, String(i)));
            od;
        elif not IsValidIdentifier(p) then
            Error("'", p, "' is not a valid identifier");
        else
            Add(result, p);
        fi;
    od;

    return result;
end );

InstallMethod(SI_ring,[IsSingularRing, IsSingularObj],SI_ring_singular);
InstallMethod(SI_ring,[IsInt,IsList,IsList],
  function( charact, names, orderings )
    local bad;
    if IsString(names) then
        names := _ParseIndeterminatesDescription(names);
    fi;
    bad := First(names, x -> not IsValidIdentifier(x));
    if bad <> fail then
        # TODO: Use Info() instead?
        Print("# WARNING: '",bad,"' is not a valid GAP identifier.\n",
              "# You will not be able to use AssignGeneratorVariables on this ring.\n");
    fi;
    
    if not IsDuplicateFreeList(names) then
        Error("At least one variable name occurs multiple times!\n");
    fi;

    if ForAll(orderings, x->x[1] <> "c" and x[1] <> "C") then
        # FIXME: Why do we do this?
        # It seems "c" stands for module orderings...
        orderings := ShallowCopy(orderings);
        Add(orderings, ["c",0]);
    fi;
    return _SI_ring(charact, names, orderings);
  end);

InstallMethod(SI_ring,[IsInt,IsList],
  function( charact, names )
    if IsString(names) then
        names := _ParseIndeterminatesDescription(names);
    fi;
    return SI_ring(charact, names, [["dp",Length(names)]]);
  end);

InstallMethod(SI_ring,["IsSingularObj"], SI_RingOfSingobj);

InstallMethod(SI_poly,[IsSingularRing, IsSingularObj],SI_poly_singular);
InstallMethod(SI_poly,[IsSingularRing, IsStringRep],_SI_poly_from_String);

InstallMethod(SI_matrix,["IsSingularObj"],SI_matrix_singular);
InstallMethod(SI_matrix,["IsSingularObj","IsPosInt","IsPosInt"],
  SI_matrix_singular);
InstallMethod(SI_matrix,["IsSingularRing","IsPosInt","IsPosInt","IsStringRep"],
              _SI_matrix_from_String);
InstallMethod(SI_matrix,["IsPosInt", "IsPosInt", "IsList"], 
              _SI_matrix_from_els);

InstallMethod(SI_ZeroMat,["IsSingularRing", "IsPosInt", "IsPosInt"],
  function(r,rows,cols) return SI_matrix(r,rows,cols," "); end );
InstallMethod(SI_IdentityMat,["IsSingularRing", "IsPosInt"],
  function(r,rows) return SI_matrix(SI_freemodule(r,rows)); end );

# a Singular vector is a "polynomial" in which each monomial also carries
# its position
InstallMethod(SI_vector,[IsSingularRing, IsPosInt, IsStringRep], 
function(r, len, str)
  local mat;
  mat := SI_matrix(r, len, 1, str);
  # this returns the first column(!) of mat as vector
  return SI_\[(mat,1);
end);
InstallMethod(SI_vector,["IsSingularObj"],SI_vector_singular);

InstallMethod(SI_ideal,[IsSingularObj],SI_ideal_singular);
InstallMethod(SI_ideal,[IsSingularRing, IsStringRep], _SI_ideal_from_String);
InstallMethod(SI_ideal,[IsList], _SI_ideal_from_els);

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
MakeReadWriteGVar("SI_LIB");
Unbind(SI_LIB);
BindGlobal("SI_LIB",function(libname)
  SI_load(libname,"with");
  _SI_BindSingularProcs("SIL_");
end);

InstallMethod( ViewString, "for a singular ring",
  [ IsSingularRing ],
  function( ring )
    return "<singular ring>";
  end );
# As long as the library has a ViewObj for ring-with-one method, we need:
InstallMethod( ViewObj, "for a singular ring",
  [ IsSingularRing ],
  function( ring )
    Print("<singular ring>");
  end );

InstallMethod( ViewString, "for a singular poly",
  [ IsSingularPoly ],
  function( poly )
    local mut;
    if SI_DEBUG_MODE then
        if IsMutable(poly) then mut := " (mutable)"; else mut := ""; fi;
        return STRINGIFY("<singular poly",mut,":",_SI_p_String(poly),">");
    else
        return _SI_p_String(poly);
    fi;
  end );

InstallMethod( ViewString, "for a singular bigint",
  [ IsSingularBigInt ],
  function( bigint )
    return STRINGIFY("<singular bigint:",_SI_Intbigint(bigint),">");
  end );

InstallMethod( ViewString, "for a singular bigintmat",
  [ IsSingularBigIntMat ],
  function( bigintmat )
    return STRINGIFY("<singular intmat:",_SI_Matbigintmat(bigintmat),">");
  end );

InstallMethod( ViewString, "for a singular intvec",
  [ IsSingularIntVec ],
  function( intvec )
    local mut;
    if SI_DEBUG_MODE and IsMutable(intvec) then mut := " (mutable)"; else mut := ""; fi;
    return STRINGIFY("<singular intvec",mut,":",_SI_Plistintvec(intvec),">");
  end );

InstallMethod( ViewString, "for a singular intmat",
  [ IsSingularIntMat ],
  function( intmat )
    local mut;
    if SI_DEBUG_MODE and IsMutable(intmat) then mut := " (mutable)"; else mut := ""; fi;
    return STRINGIFY("<singular intmat",mut,":",_SI_Matintmat(intmat),">");
  end );

InstallMethod( ViewString, "for a singular ideal",
  [ IsSingularIdeal ],
  function( ideal )
    local mut;
    if SI_DEBUG_MODE and IsMutable(ideal) then mut := " (mutable)"; else mut := ""; fi;
    return STRINGIFY("<singular ideal",mut,", ",SI_ncols(ideal)," gens>");
  end );


InstallMethod( Singular, "for a string in stringrep",
  [ IsStringRep ],
  function( st )
    local ret;
    SI_Errors := "";
    ret := _SI_EVALUATE(st);
    if Length(SI_Errors) > 0 then
        Print(SI_Errors);
    fi;
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
        Print(SI_LastOutput());
    od;
    CloseStream(i);
  end );

InstallMethod(SI_Proxy, "for a singular object and a positive integer",
  [ IsSingularObj, IsPosInt ],
  function( o, i )
    local l;
    l := [o,i];
    Objectify(_SI_ProxiesType, l);
    return l;
  end );

InstallMethod(SI_Proxy, "for a singular object and two positive integers",
  [ IsSingularObj, IsPosInt, IsPosInt ],
  function( o, i, j)
    local l;
    l := [o,i,j];
    Objectify(_SI_ProxiesType, l);
    return l;
  end );

InstallMethod(SI_Proxy, "for a singular object and a string",
  [ IsSingularObj, IsStringRep ],
  function( o, s)
    local l;
    l := [o,s];
    Objectify(_SI_ProxiesType, l);
    return l;
  end );

InstallMethod(ViewString, "for a singular proxy object",
  [ IsSingularProxy ],
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

# TODO: Quoting the GAP manual:
# "ViewObj should print the object to the standard output in a short and
# concise form, it is used in the main read-eval-print loop to display
# the resulting object of a computation"
InstallMethod(ViewString, "for a generic singular object",
  [ IsSingularObj ],
  function( sobj )
    local mut;
    if SI_DEBUG_MODE and IsMutable(sobj) then mut := " (mutable)"; else mut := ""; fi;
    return Concatenation("<singular ",_SI_TypeName(sobj),mut,":\n",
                         SI_ToGAP(SI_print(sobj)),">");
  end );


# TODO: Quoting the GAP manual:
# "Display should print the object to the standard output in a
# human-readable relatively complete and verbose form."
InstallMethod(DisplayString, "for a generic singular object",
  [ IsSingularObj ],
  function( s )
    return Concatenation(SI_ToGAP(SI_print(s)),"\n");
  end );

# TODO: Quoting the GAP manual:
# "PrintObj should print the object to the standard output in a complete
# form which is GAP-readable if at all possible, such that reading the
# output into GAP produces an object which is equal to the original one."
InstallMethod(String, "for a generic singular object",
  [ IsSingularObj ],
  function( s )
    return SI_ToGAP(SI_print(s));
  end );

# WORKAROUND for a bug in GAP 4.5.5: There is a bad PrintObj
# method for objects which hides the correct one. To workaround
# this, we re-install the correct method with slightly higher rank.
InstallMethod(PrintObj, "default method delegating to PrintString",
  [IsObject], 1, function(o) Print(PrintString(o)); end );


InstallOtherMethod(TransposedMat, [IsSingularIntMat], SI_transpose);
InstallOtherMethod(TransposedMat, [IsSingularBigIntMat], SI_transpose);
InstallOtherMethod(TransposedMat, [IsSingularMatrix], SI_transpose);
InstallOtherMethod(TransposedMat, [IsSingularModule], SI_transpose);

InstallOtherMethod(Determinant, [IsSingularIntMat], SI_det);
InstallOtherMethod(Determinant, [IsSingularBigIntMat], SI_det);
InstallOtherMethod(Determinant, [IsSingularMatrix], SI_det);

InstallOtherMethod(DeterminantMat, [IsSingularIntMat], SI_det);
InstallOtherMethod(DeterminantMat, [IsSingularBigIntMat], SI_det);
InstallOtherMethod(DeterminantMat, [IsSingularMatrix], SI_det);

