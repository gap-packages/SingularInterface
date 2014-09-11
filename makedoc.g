if fail = LoadPackage("AutoDoc", ">= 2014.03.27") then
    Error("AutoDoc version 2014.03.27 is required.");
fi;

AutoDoc( "SingularInterface" :
        
        scaffold :=
        rec(
            entities := [
                    "Singular",
                    ],
            appendix := [
                     "appendix-implementation.xml",
                     ]
            ),
         
         autodoc :=
         rec(
             files := [
                     "doc/intro.autodoc",
                     ],
             )
         );

# Create VERSION file for "make towww"
PrintTo( "VERSION", PackageInfo( "SingularInterface" )[1].Version );

QUIT;
