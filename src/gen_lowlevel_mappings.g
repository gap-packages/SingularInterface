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
		PrintCXXLine("strcpy(reinterpret_cast<char*>(CHARS_STRING(tmp)),", name, ");");
		PrintCXXLine("return tmp;");
	indent := indent - 1;
	PrintCXXLine("}");
end;;

# Generate code for returning a ring-dependent Singular object
SINGULAR_default_ringdep_return := function (type, name)
	PrintCXXLine("{");
	indent := indent + 1;
		PrintCXXLine("Obj tmp = NEW_SINGOBJ_RING(SINGTYPE_",type ,",", name, ",rnr);");
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
# * retconv: (optional) a GAP function that generates code to return a value of this type
# * ...
SINGULAR_types := rec(
	#BIGINT  := rec( ring := false,  ... ),
	IDEAL  := rec( ring := true,  cxxtype := "ideal" ),
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
	STRING := rec( ring := false, cxxtype := "char *", retconv:=SINGULAR_string_return ),
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
SINGULAR_funcs := [
	# PINLINE2 char*     p_String(poly p, ring p_ring);
	rec( name := "p_String", params := [ "POLY" ], result := "STRING" ),

	#PINLINE2 poly p_Neg(DESTROYS poly p, const ring r);
	rec( name := "p_Neg", params := [ ["POLY",true] ], result := "POLY" ),

	# PINLINE2 poly pp_Mult_qq(poly p, poly q, const ring r);
	rec( name := "pp_Mult_qq", params := [ "POLY", "POLY" ], result := "POLY" ),

	# PINLINE2 poly pp_Mult_nn(poly p, number n, const ring r);
	rec( name := "pp_Mult_nn", params := [ "POLY", "NUMBER" ], result := "POLY" ),

	# PINLINE2 poly p_Add_q(DESTROYS poly p, DESTROYS poly q, const ring r);
	rec( name := "p_Add_q", params := [ ["POLY",true], ["POLY",true] ], result := "POLY" ),

	# PINLINE2 poly p_Minus_mm_Mult_qq(DESTROYS poly p, poly m, poly q, const ring r);
	rec( name := "p_Minus_mm_Mult_qq", params := [ ["POLY",true], "POLY", "POLY" ], result := "POLY" ),

	# PINLINE2 poly p_Plus_mm_Mult_qq(DESTROYS poly p, poly m, poly q, const ring r);
	rec( name := "p_Plus_mm_Mult_qq", params := [ ["POLY",true], "POLY", "POLY" ], result := "POLY" ),


];;

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
		i, j;

	GetParamTypeName := function (i)
		local tmp; tmp := desc.params[i];
		if not IsString(tmp) then tmp := tmp[1]; fi;
		return tmp;
	end;
	CXXArgName := i -> String(Concatenation("arg", String(i)));
	CXXVarName := i -> String(Concatenation("var", String(i)));
	CXXObjName := i -> String(Concatenation("obj", String(i)));

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
	#   {"_SI_ADD_POLYS", 2,
	#    "a, b", Func_SI_ADD_POLYS,
	#    "cxx-funcs.cc:Func_SI_ADD_POLYS" },

	PrintTo(stream_table_h, "  {\"_SI_", desc.name, "\", ", Length(desc.params), ",\n" );
	PrintTo(stream_table_h, "  \"" );
	for i in [1 .. Length(desc.params) ] do
		if i>1 then
			PrintTo(stream_table_h, ", " );
		fi;
		PrintTo(stream_table_h, CXXArgName(i) );
	od;
	PrintTo(stream_table_h, "\", Func_SI_", desc.name, ",\n" );
	PrintTo(stream_table_h, "  \"", basename, ".cc:Func_SI_", desc.name, "\" },\n" );
	PrintTo(stream_table_h, "\n" );


	#############################################
	# begin function body
	#############################################

	indent := 1;

	# Declare some variables used throughout the wrapper function body.
	PrintCXXLine("UInt rnr;");
	PrintCXXLine("ring r = currRing;");
	PrintCXXLine("");

	# Ddetermine all params that depend on the current ring.
	ring_users := Filtered( [1 .. Length(desc.params) ],
		i -> SINGULAR_types.(GetParamTypeName(i)).ring );

	# TODO: When this code was converted to use GET_SINGOBJ, the code that verifies
	# that all ring-dependent inputs are defined over the same ring was disabled.
	# We need to decide whether to rewrite this, or whether to go on without such
	# a check.

#	# Ensure right ring is set, and that all ring-depend params use the same ring.
# 	if Length(ring_users) > 0 then
# 		PrintCXXLine("// Setup current ring");
# 		PrintCXXLine("rnr = RING_SINGOBJ(", CXXArgName(ring_users[1]), ");");
# 		for j in ring_users{[2..Length(ring_users)]} do
# 			PrintCXXLine("if (rnr != RING_SINGOBJ(", CXXArgName(j), "))");
# 			PrintCXXLine("    ErrorQuit(\"Elements not over the same ring\\n\",0L,0L);");
# 		od;
# 		PrintCXXLine("r = GET_SINGRING(rnr);");
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
	PrintTo(stream_cc, "}\n\n");
end;;

#
# Insert headers into the generated files
#
do_not_edit_warning := "// DO NOT EDIT THIS FILE BY HAND IT IS MACHINE GENERATED\n";;

PrintTo(stream_cc, do_not_edit_warning);
PrintTo(stream_h, do_not_edit_warning);
PrintTo(stream_table_h, do_not_edit_warning);

PrintCXXLine("#include \"lowlevel_mappings.h\"");
PrintCXXLine("");

extern_c_start := Concatenation(
	"#ifdef __cplusplus\n",
	"extern \"C\" {\n",
	"#endif /* ifdef __cplusplus */\n",
	"\n"
);;

extern_c_end := Concatenation(
	"\n",
	"#ifdef __cplusplus\n",
	"}\n",
	"#endif /* ifdef __cplusplus */\n"
);;

PrintTo(stream_cc, extern_c_start);
PrintTo(stream_h, extern_c_start);

#
# Generate the wrappers
#
Perform(SINGULAR_funcs, GenerateSingularWrapper);

#
# Insert footers into the generated files
#
PrintTo(stream_cc, extern_c_end);
PrintTo(stream_h, extern_c_end);

#
# Close everything
#
CloseStream(stream_cc);
CloseStream(stream_h);
CloseStream(stream_table_h);
