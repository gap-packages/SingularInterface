#
# This file generates low-level wrapper GAP C kernel wrappers for
# Singular C++ kernel functions.
#
# Here is an overview on which file is generated from which by whom:
#
#  lowlevel_mappings_src.h.in  (contains excerpts of Singular header files)
#   |
#   v  processed by C++ preprocessor
#  lowlevel_mappings_src.h
#   |
#   v  processed by gen_lowlevel_mappings.g
#  lowlevel_mappings.[ch], lowlevel_mappings_table.h
#
# TODO:
# * Add mappings for more data types to SINGULAR_types.
#

#
# open output streams
#
basename := "lowlevel_mappings";;
# - for the source file containing the wrapper functions
stream_cc := OutputTextFile(Concatenation(basename, ".cc"), false);;
# - for the header file containing declarations for the wrappers
stream_h := OutputTextFile(Concatenation(basename, ".h"), false);;
# - for the header file containing entries for the GVarFuncs table
stream_table_h := OutputTextFile(Concatenation(basename, "_table.h"), false);;

# indention level
indent := 0;;

# Helper function for printing lines into the source file.
# Taking indention level into account.
PrintCXXLine := function(arg)
	local i;
	for i in [1..indent] do PrintTo(stream_cc, "    "); od;
	i := Concatenation([stream_cc], arg);
	CallFuncList(PrintTo,i);
	PrintTo(stream_cc, "\n");
end;;

# Helper function for printing lines into the header file.
# Ignores indention level.
PrintHeaderLine := function(arg)
	local i;
	i := Concatenation([stream_h], arg);
	CallFuncList(PrintTo,i);
	PrintTo(stream_h, "\n");
end;;


# Generate code for returning a string (where "name" is the name of a
# C++ variable of type char*).
SINGULAR_string_return := function (type, name)
	PrintCXXLine("{");
	indent := indent + 1;
		PrintCXXLine("UInt len = (UInt) strlen(", name, ");");
		PrintCXXLine("Obj tmp = NEW_STRING(len);");
		PrintCXXLine("SET_LEN_STRING(tmp,len);");
		PrintCXXLine("memcpy(CHARS_STRING(tmp),", name, ", len+1);");
		PrintCXXLine("return tmp;");
	indent := indent - 1;
	PrintCXXLine("}");
end;;

SINGULAR_int_return := function (type, name)
	PrintCXXLine("{");
	indent := indent + 1;
		# TODO: Should perform bounds checking
		PrintCXXLine("return INTOBJ_INT(", name,");");
	indent := indent - 1;
	PrintCXXLine("}");
end;;

# Generate code for returning a ring-dependent Singular object
SINGULAR_default_ringdep_return := function (type, name)
	PrintCXXLine("{");
	indent := indent + 1;
		PrintCXXLine("Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_",type ,",", name, ",rr);");
		PrintCXXLine("return tmp;");
	indent := indent - 1;
	PrintCXXLine("}");
end;;

# Generate code for returning a Singular object that does not depend on a ring
SINGULAR_default_return := function (type, name)
	PrintCXXLine("{");
	indent := indent + 1;
		PrintCXXLine("Obj tmp = NEW_SINGOBJ(SINGTYPE_",type ,",", name, ");");
		PrintCXXLine("return tmp;");
	indent := indent - 1;
	PrintCXXLine("}");
end;;

# A record containing information about the various Singular types.
# The name of each entry is carefully chosen to match the types defined
# in libsing.h; e.g. STRING maps to SINGTYPE_STRING.
# For each type, there is a record with the following entries:
# * ring: boolean indicating whether the type implicitly depends on the active ring
# * cxxtype: corresponding C++ type
# * ...
SINGULAR_types := rec(
	#BIGINT  := rec( ring := false,  ... ),
	IDEAL  := rec( ring := true,  cxxtype := "ideal" ),
	INT := rec( ring := false, cxxtype := "int" ),
	#INTMAT  := rec( ring := false,  ... ),
	INTVEC := rec( ring := false, cxxtype := "intvec *" ),
	#LINK  := rec( ... ),
	#LIST  := rec( ... ),
	#MAP  := rec( ... ),

	MATRIX := rec( ring := true,  cxxtype := "matrix" ),

	#MODULE  := rec( ... ),
	NUMBER := rec( ring := true,  cxxtype := "number" ),
	#PACKAGE  := rec( ... ),
	POLY   := rec( ring := true,  cxxtype := "poly" ),
	#QRING  := rec( ... ),
	#RESOLUTION  := rec( ... ),
	RING   := rec( ring := false, cxxtype := "ring" ),
	STRING := rec( ring := false, cxxtype := "char *" ),
	#VECTOR  := rec( ... ),
);;

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

CToSingularType := function(type)
	# TODO: Handle intvec* etc.
	if type = "char*" then
		return "STRING";
	fi;
	return UppercaseString(type);
end;;

Generate_SINGULAR_funcs := function()
	local SINGULAR_funcs, input, proto, line, toks, tmp, func_name, ret_type, i, j, arg_name, arg_destroyed, arg_type;

	SINGULAR_funcs := [];

	input := InputTextFile("lowlevel_mappings_src.h");

	while not IsEndOfStream(input) do
		# Read lines until we encounter a semicolon
		proto := "";
		repeat
			line := ReadLine(input);
			if line = fail then break; fi;
			Append( proto, line );
		until ';' in line;
		if line = fail then break; fi;
		NormalizeWhitespace(proto);

		# Skip any prototypes using pass-by-reference parameters.
		# We can't currently handle those (and most are overloaded
		# with variants that don't need by-ref params anyway).
		if '&' in proto then continue; fi;


		# At this point we have a string like
		# "poly pp_Mult_nn(poly p, number n, const ring r);"
		# Split it into a list like this one:
		# [ "poly pp_Mult_nn", "poly p", " number n", " const ring r" ]
		RemoveCharacters(proto,";");
		toks := SplitString(proto, "(,)");

		# Extract the return type and function name
		tmp := SplitString(toks[1], " ");
		ret_type := CToSingularType(tmp[1]);
		func_name := tmp[2];

		# TODO: Add support for void functions
		if ret_type = "VOID" then
			continue;
		fi;

		proto := rec( name := func_name, result := ret_type, params := [] );

		# Iterate over the arguments
		for i in [2..Length(toks)] do
			NormalizeWhitespace(toks[i]);
			tmp := SplitString(toks[i], " ");
			# Name of the argument comes last
			# TODO: Deal with 'BOOLEAN revert = FALSE'
			# TODO: Deal with 'int &length'
			arg_name := Remove(tmp);
			tmp := Set(tmp);

			# Destroy argument?
			j := Position(tmp, "DESTROYS");
			arg_destroyed := (j <> fail);
			if j <> fail then
				Remove(tmp, j);
			fi;

			tmp := Filtered(tmp, x -> x <> "const");

			Assert(0, Length(tmp) = 1);
			# TODO: Handle pointers formatted like "char * s" (instead of "char *s")
			arg_type := CToSingularType(tmp[1]);

			if arg_destroyed then
				Add( proto.params, [ arg_type, true ] );
			else
				Add( proto.params, arg_type );
			fi;
		od;

		# TODO: Suppress outputting "ring r" parameter if it is implicit.
		# This could be done either by adding an IMPLICIT marker;
		# or we could attempt to guess this by looking at the input elements,
		# and checking whether any of them carries a ring implicitly; in
		# that case, drop "ring r" (if it is the last param, at least ?!)
		# This would require the SINGULAR_types table.

		Add( SINGULAR_funcs, proto );
	od;

	CloseStream(input);

	return SINGULAR_funcs;
end;;

SINGULAR_funcs := Generate_SINGULAR_funcs();;


GenerateSingularWrapper := function (desc)
	local
		ring_users,		# indices of params depending on a ring
		result_type,
		type,
		cxxparams,
		CXXArgName,		# helper function printing name of the i-th param
		CXXVarName,		# helper function printing name of the i-th param after conversion
		CXXObjName,     # helper function printing name of the i-th param conversion obj
		GetParamTypeName,
		retconv,
		func_head,
		implicit_ring,
		i, j;

	GetParamTypeName := function (i)
		local tmp; tmp := desc.params[i];
		if not IsString(tmp) then tmp := tmp[1]; fi;
		return tmp;
	end;
	CXXArgName := i -> String(Concatenation("arg", String(i)));
	CXXVarName := i -> String(Concatenation("var", String(i)));
	CXXObjName := i -> String(Concatenation("obj", String(i)));

	# Determine all params that depend on the current ring.
	ring_users := Filtered( [1 .. Length(desc.params) ],
		i -> SINGULAR_types.(GetParamTypeName(i)).ring );

	if Length(ring_users) > 0 and GetParamTypeName(Length(desc.params)) = "RING" then
		implicit_ring := true;
		Remove(desc.params);
	else
		implicit_ring := false;
	fi;


	#############################################
	# Generate the function head
	#############################################
	func_head := Concatenation("Obj Func_SI_", desc.name, "(Obj self");
	for i in [1 .. Length(desc.params) ] do
		Append(func_head, ", Obj ");
		Append(func_head, CXXArgName(i));
	od;
	Append(func_head, ")");

	# add function head to source file
	PrintTo(stream_cc, func_head, " {\n");

	# add function declaration to header file
	PrintTo(stream_h, func_head, ";\n");

	# add function entry in table header file
	# the result looks like this:
	#   {"_SI_p_Add_q", 2,
	#    "a, b", Func_SI_p_Add_q,
	#    "cxx-funcs.cc:Func_SI_p_Add_q" },

	PrintTo(stream_table_h, "  {\"_SI_", desc.name, "\", ", Length(desc.params), ",\n" );
	PrintTo(stream_table_h, "  \"" );
	for i in [1 .. Length(desc.params) ] do
		if i>1 then
			PrintTo(stream_table_h, ", " );
		fi;
		PrintTo(stream_table_h, CXXArgName(i) );
	od;
	PrintTo(stream_table_h, "\", (GVarFunc)Func_SI_", desc.name, ",\n" );
	PrintTo(stream_table_h, "  \"", basename, ".cc:Func_SI_", desc.name, "\" },\n" );
	PrintTo(stream_table_h, "\n" );


	#############################################
	# begin function body
	#############################################

	indent := 1;

	# Declare some variables used throughout the wrapper function body.
	PrintCXXLine("Obj rr;");
	PrintCXXLine("ring r = currRing;");
	PrintCXXLine("");


	# TODO: When this code was converted to use GET_SINGOBJ, the code that verifies
	# that all ring-dependent inputs are defined over the same ring was disabled.
	# We need to decide whether to rewrite this, or whether to go on without such
	# a check.

#	# Ensure right ring is set, and that all ring-depend params use the same ring.
# 	if Length(ring_users) > 0 then
# 		PrintCXXLine("// Setup current ring");
# 		PrintCXXLine("rr = RING_SINGOBJ(", CXXArgName(ring_users[1]), ");");
# 		for j in ring_users{[2..Length(ring_users)]} do
# 			PrintCXXLine("if (rr != RING_SINGOBJ(", CXXArgName(j), "))");
# 			PrintCXXLine("    ErrorQuit(\"Elements not over the same ring\\n\",0L,0L);");
# 		od;
# 		PrintCXXLine("r = CXX_SINGOBJ(rr);");
# 		PrintCXXLine("if (r != currRing) rChangeCurrRing(r);");
# 		PrintCXXLine("");
# 	fi;

	# Extract the underlying data for the parameters
	PrintCXXLine("// Prepare input data");
	for i in [1 .. Length(desc.params) ] do
		type := SINGULAR_types.(GetParamTypeName(i));
		# Extract the underlying Singular data from the GAP input object
		PrintCXXLine("SingObj ",CXXObjName(i),"(",CXXArgName(i),", rnr, r);");
		PrintCXXLine("if (",CXXObjName(i),".error) {");
		indent := indent + 1;
		    for j in [1..i] do
				PrintCXXLine(CXXObjName(j),".cleanup();");
			od;
			PrintCXXLine("ErrorQuit(",CXXObjName(i),".error,0L,0L);");
			PrintCXXLine("return Fail;");
		indent := indent - 1;
		PrintCXXLine("} else if (",CXXObjName(i),".obj.rtyp != ",GetParamTypeName(i),"_CMD) {");
		indent := indent + 1;
		    for j in [1..i] do
				PrintCXXLine(CXXObjName(j),".cleanup();");
			od;
			PrintCXXLine("ErrorQuit(\"argument ",i," must be of type ",GetParamTypeName(i),"\", 0L, 0L);");
			PrintCXXLine("return Fail;");
		indent := indent - 1;
		PrintCXXLine("}");
		# Is this destructive use?
		if not IsString(desc.params[i]) and desc.params[i][2] then
			PrintCXXLine(type.cxxtype, " ", CXXVarName(i), " = ",
								"(", type.cxxtype, ") ", # cast
								CXXObjName(i),".destructiveuse()->data;");
		else
			PrintCXXLine(type.cxxtype, " ", CXXVarName(i), " = ",
								"(", type.cxxtype, ") ", # cast
								CXXObjName(i),".nondestructiveuse()->data;");
		fi;
		#PrintCXXLine(type.cxxtype, " ", CXXVarName(i), " = ",
		#					"(", type.cxxtype, ")", # cast
		#					"GET_SINGOBJ(", CXXArgName(i), ", gtype, stype, rnr, r, ", GetParamTypeName(i), "_CMD)",
		#					";");

		# Copy the parameter if necessary
		#if not IsString(desc.params[i]) and desc.params[i][2] then
		#	PrintCXXLine(CXXVarName(i), " = ",
		#					"(", type.cxxtype, ")", # cast
		#					"COPY_SINGOBJ(", CXXVarName(i), ", SINGTYPE_", GetParamTypeName(i), ", r)",
		#					";");
		#fi;
	od;
	PrintCXXLine("");

    # The SingObj class sets the ring for us, we use the ring of the last
	# argument that had one. --> Maybe do better checking here???
	# Ensure right ring is set
	#if Length(ring_users) > 0 then
	#	PrintCXXLine("// Setup current ring");
	#	PrintCXXLine("if (r != currRing) rChangeCurrRing(r);");
	#	PrintCXXLine("");
	#fi;


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
	if implicit_ring then
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
	if desc.result = "STRING" then
		retconv := SINGULAR_string_return;
	elif desc.result = "INT" then
		retconv := SINGULAR_int_return;
	elif result_type.ring then
		retconv := SINGULAR_default_ringdep_return;
	else
		retconv := SINGULAR_default_return;
	fi;
	retconv(desc.result, "res");

	#############################################
	# end function body
	#############################################
	PrintTo(stream_cc, "}\n\n");
end;;

#
# Insert headers into the generated files
#
do_not_edit_warning := "// DO NOT EDIT THIS FILE BY HAND IT IS MACHINE GENERATED\n";;

PrintTo(stream_table_h, do_not_edit_warning);

PrintTo(stream_h, Concatenation(
	do_not_edit_warning,
	"#ifndef ", UppercaseString(basename), "_H\n",
	"#define ", UppercaseString(basename), "_H\n",
	"\n",
	"#include \"libsing.h\"\n",
	"\n"
));

PrintTo(stream_cc, do_not_edit_warning);
PrintCXXLine("#include \"lowlevel_mappings.h\"");
PrintCXXLine("#include \"singobj.h\"");
PrintCXXLine("");

#
# Generate the wrappers
#
Perform(SINGULAR_funcs, GenerateSingularWrapper);

#
# Insert footers into the generated files
#
PrintTo(stream_h, Concatenation(
	"\n",
	"#endif\n"
));

#
# Close everything
#
CloseStream(stream_cc);
CloseStream(stream_h);
CloseStream(stream_table_h);
