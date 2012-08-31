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
