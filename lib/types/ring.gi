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

InstallMethod(SI_ring,[IsSingularRing, IsSingularObj],_SI_ring_singular);
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


BindGlobal("_SI_ViewString_ring", function( ring )
    local suffix;
    if SI_nvars(ring) = 1 then suffix := ""; else suffix := "s"; fi;
    return Concatenation("<singular ring, ", String(SI_nvars(ring)),
                         " indeterminate", suffix, ">");
end );

InstallMethod( ViewString, "for a singular ring",
  [ IsSingularRing ],
  _SI_ViewString_ring );

# As long as the library has a ViewObj for ring-with-one method, we need:
InstallMethod( ViewObj, "for a singular ring",
  [ IsSingularRing ],
  function( ring )
    Print(_SI_ViewString_ring(ring));
  end );


# this causes that DefaultRing of a Singular object with ring returns that ring
InstallOtherMethod(DefaultRingByGenerators, fam->
    fam = CollectionsFamily(SingularFamily), ["IsList"], l-> SI_ring(l[1]));
InstallMethod(\in, ["IsSingularPoly", "IsRing"], function(pol, r)
  return SI_ring(pol) = r;
end);

# HACK for demo in Konstanz
InstallMethod(AssignGeneratorVariables, ["IsSingularRing"], function(r)
  local gens;
  gens := SI_Indeterminates(r);
  DoAssignGenVars(gens);
end);
