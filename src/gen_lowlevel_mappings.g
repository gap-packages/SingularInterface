#
# This file generates low-level wrapper GAP C kernel wrappers for
# Singular C++ kernel functions.
#
# TODO:
# * Instead of adding new mappings in SINGULAR_funcs, allow specifying
#   them in a separate file in pseudo-C syntax: Essentially, each line
#   of this file would contain a C++ function prototype, but with some
#   additional annotation to mark arguments that need to be copied.
# * Add mappings for more data types to SINGULAR_types.
#

# indention level
indent := 0;

# send all input into a GAP string
output_str := "";
stream := OutputTextString(output_str, false);
#stream := OutputTextFile("lowlevel_mappings.cc", false);

# helper function printing lines
PrintCXXLine := function(arg)
	local i;
	for i in [1..indent] do PrintTo(stream, "    "); od;
	i := Concatenation([stream], arg);
	CallFuncList(PrintTo,i);
	PrintTo(stream, "\n");
end;

# Generate code for returning a string (where "name" is the name of a
# C++ variable of type char*).
SINGULAR_string_return := function (type, name)
	PrintCXXLine("{");
	indent := indent + 1;
		PrintCXXLine("UInt len = (UInt) strlen(", name, ");");
		PrintCXXLine("Obj tmp = NEW_STRING(len);");
		PrintCXXLine("SET_LEN_STRING(tmp,len);");
		PrintCXXLine("strcpy(reinterpret_cast<char*>(CHARS_STRING(tmp)),", name, ");");
		PrintCXXLine("return tmp;");
	indent := indent - 1;
	PrintCXXLine("}");
end;

# Generate code for returning a ring-dependent Singular object
SINGULAR_default_ringdep_return := function (type, name)
	PrintCXXLine("{");
	indent := indent + 1;
		PrintCXXLine("Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_",type ,",", name, ",rnr);");
		PrintCXXLine("return tmp;");
	indent := indent - 1;
	PrintCXXLine("}");
end;

# Generate code for returning a Singular object that does not depend on a ring
SINGULAR_default_return := function (type, name)
	PrintCXXLine("{");
	indent := indent + 1;
		PrintCXXLine("Obj tmp = NEW_SINGOBJ(SINGTYPE_",type ,",", name, ");");
		PrintCXXLine("return tmp;");
	indent := indent - 1;
	PrintCXXLine("}");
end;


# A record containing information about the various Singular types.
# The name of each entry is carefully chosen to match the types defined
# in libsing.h; e.g. STRING maps to SINGTYPE_STRING.
# For each type, there is a record with the following entries:
# * ring: boolean indicating whether the type implicitly depends on the active ring
# * cxxtype: corresponding C++ type
# * copy: a GAP function that takes a C variable name of this type and
#         returns a string with C++ code creating a copy of the variable.
#         If the type is ring dependant, then this may implicitly assume that "r" is
#         the name of a C++ variable containing the active ring.
#
# * retconv: (optional) a GAP function that generates code to return a value of this type
# * ...
SINGULAR_types := rec(
	STRING := rec( ring := false, cxxtype := "char *", retconv:=SINGULAR_string_return ),
	INTVEC := rec( ring := false, cxxtype := "intvec *", copy := var -> Concatenation("ivCopy(", var, ")" ) ),
	RING   := rec( ring := false, cxxtype := "ring",     copy := var -> Concatenation("rCopy(", var, ")" )),

	NUMBER := rec( ring := true,  cxxtype := "number",   copy := var -> Concatenation("n_Copy(", var, ", r)" ) ),
	POLY   := rec( ring := true,  cxxtype := "poly",     copy := var -> Concatenation("p_Copy(", var, ", r)" ) ),
	IDEAL  := rec( ring := true,  cxxtype := "ideal",    copy := var -> Concatenation("id_Copy(", var, ", r)" ) ),

	# TODO: There seems to be no mp_Copy which takes a ring, so for now use the old mpCopy
	MATRIX := rec( ring := true,  cxxtype := "matrix",   copy := var -> Concatenation("mpCopy(", var, ")" ) ),
);

# Array containing records describing various Singular kernel functions.
# From this, we generate GAP C kernel functions that call the Singular
# kernel, after suitably processing the input argument and the Singular
# return value. The records contains this data:
# * name: the C++ name of the Singular kernel function
# * params: list describing the input, in the form of pairs: the first
#           entry of each pair is the name of a Singular type (this is
#           used to lookup the type in SINGULAR_types). The second entry
#           is a boolean which indicates whether the parameter needs to
#           be copied (because some Singular kernel functions destroy
#           their inputs).
#           To simplify things, instead of a pair a simple string can
#           be specified; in that case the input value is *not* copied.
# * result: string indicating the return type (this is again used to
#           lookup the type in SINGULAR_types).
SINGULAR_funcs := [
	rec( name := "p_String", params := [ "POLY" ], result := "STRING" ),
	rec( name := "p_Add_q", params := [ ["POLY",true], ["POLY",true] ], result := "POLY" ),
	rec( name := "p_Neg", params := [ ["POLY",true] ], result := "POLY" ),
	rec( name := "pp_Mult_qq", params := [ "POLY", "POLY" ], result := "POLY" ),
	rec( name := "pp_Mult_nn", params := [ "POLY", "NUMBER" ], result := "POLY" ),
];

GenerateSingularWrapper := function (desc)
	local
		ring_users,		# indices of params depending on a ring
		result_type,
		type,
		cxxparams,
		CXXArgName,		# helper function printing name of the i-th param
		CXXVarName,		# helper function printing name of the i-th param after conversion
		GetParamTypeName,
		var_formatter,
		retconv,
		i, j;

	GetParamTypeName := function (i)
		local tmp; tmp := desc.params[i];
		if not IsString(tmp) then tmp := tmp[1]; fi;
		return tmp;
	end;
	CXXArgName := i -> String(Concatenation("arg", String(i)));
	CXXVarName := i -> String(Concatenation("var", String(i)));

	# Generate the function name
	PrintTo(stream, "extern \"C\"\n");  # TODO: Instead use a big global  extern "C" { ... } around things?
	PrintTo(stream, "Obj FuncSI_", desc.name, "(Obj self");
	for i in [1 .. Length(desc.params) ] do
		PrintTo(stream, ", Obj ", CXXArgName(i));
	od;
	PrintTo(stream, ") {\n");

	#############################################
	# begin function body
	#############################################

	indent := 1;

	# Ddetermine all params that depend on the current ring.
	ring_users := Filtered( [1 .. Length(desc.params) ],
		i -> SINGULAR_types.(GetParamTypeName(i)).ring );

	# Ensure right ring is set, and that all ring-depend params use the same ring.
	if Length(ring_users) > 0 then
		PrintCXXLine("// Setup current ring");
		PrintCXXLine("UInt rnr = RING_SINGOBJ(", CXXArgName(ring_users[1]), ");");
		for j in ring_users{[2..Length(ring_users)]} do
			PrintCXXLine("if (rnr != RING_SINGOBJ(", CXXArgName(j), "))");
			PrintCXXLine("    ErrorQuit(\"Elements not over the same ring\\n\",0L,0L);");
		od;
		PrintCXXLine("ring r = (ring)CXX_SINGOBJ(ELM_PLIST(SingularRings,rnr));");
		PrintCXXLine("if (r != currRing) rChangeCurrRing(r);");
		PrintCXXLine("");
	fi;

	# Extract the underlying data for the parameters
	PrintCXXLine("// Prepare input data");
	for i in [1 .. Length(desc.params) ] do
		type := SINGULAR_types.(GetParamTypeName(i));
		# Determine whether we need to copy the parameter or not
		if not IsString(desc.params[i]) and desc.params[i][2] then
			var_formatter := type.copy;
		else
			var_formatter := IdFunc;
		fi;
		PrintCXXLine(type.cxxtype, " ", CXXVarName(i), " = ",
						var_formatter( Concatenation(
							"(", type.cxxtype, ")", # cast
							"CXX_SINGOBJ(", CXXArgName(i), ")"
						) ),
					";");
	od;
	PrintCXXLine("");


	# Determine the result type
	result_type := SINGULAR_types.(desc.result);
	# TODO: Are there any functions we want to wrap the do not return anything?
	#       If so, we need to add code for that.

	# TODO: We currently assume that a ring-dependent function always
	#       receives the parameter as last value. To be safe, we check for this.
	Assert(0, not result_type.ring or Length(ring_users) > 0 );

	# Generate code to call the Singular C++ function.
	PrintCXXLine("// Call into Singular kernel");
	cxxparams := List( [1 .. Length(desc.params) ], CXXVarName );
	if Length(ring_users) > 0 then
		Add(cxxparams, "r");
	fi;

	PrintCXXLine(result_type.cxxtype, " res = ",
			desc.name, "(",
			JoinStringsWithSeparator(cxxparams),
			");");
	PrintCXXLine("");


	# Wrap the return value for GAP and return it.
	# How this is done is type dependent, and we delegate this
	# to a type dependent function.
	PrintCXXLine("// Convert result for GAP and return it");
	if IsBound(result_type.retconv) then
		retconv := result_type.retconv;
	elif result_type.ring then
		retconv := SINGULAR_default_ringdep_return;
	else
		retconv := SINGULAR_default_return;
	fi;
	retconv(desc.result, "res");

	#############################################
	# end function body
	#############################################
	PrintTo(stream, "}\n\n");
end;

# Convert one or all entries of
#GenerateSingularWrapper(SINGULAR_funcs[1]);
Perform(SINGULAR_funcs, GenerateSingularWrapper);


Print(output_str);
PrintTo("lowlevel_mappings.cc", output_str);
