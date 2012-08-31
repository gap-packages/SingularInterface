# Generate lowlevel_mappings_src.g by parsing the pseudo C prototypes
# in lowlevel_mappings_src.h.

Read("gen_lowlevel_common.g");

input := InputTextFile("lowlevel_mappings_src.h");

Print("SINGULAR_funcs := [\n");


CToSingularType := function(type)
	# TODO: Handle intvec* etc.
	if type = "char*" then
		return "STRING";
	fi;
	return UppercaseString(type);
end;


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


# SINGULAR_funcs := [
# 	# PINLINE2 char*     p_String(poly p, ring p_ring);
# 	rec( name := "p_String", params := [ "POLY" ], result := "STRING" ),
#	rec( name := "p_Add_q", params := [ ["POLY",true], ["POLY",true] ], result := "POLY" ),

	# Extract the return type and function name
	tmp := SplitString(toks[1], " ");
	ret_type := CToSingularType(tmp[1]);
	func_name := tmp[2];

	# TODO: Add support for void functions
	if ret_type = "VOID" then
		continue;
	fi;


	Print("	rec( name := \"", func_name, "\", result := \"", ret_type, "\", params := [ ");

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
			Print("[\"", arg_type, "\",true], ");
		else
			Print("\"", arg_type, "\", ");
		fi;
	od;

	# TODO: Suppress outputting "ring r" parameter if it is implicit.
	# This could be done either by adding an IMPLICIT marker;
	# or we could attempt to guess this by looking at the input elements,
	# and checking whether any of them carries a ring implicitly; in
	# that case, drop "ring r" (if it is the last param, at least ?!)
	# This would require the SINGULAR_types table.

	Print("] ),\n");
od;

Print("];;\n");

CloseStream(input);
