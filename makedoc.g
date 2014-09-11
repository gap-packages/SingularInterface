LoadPackage("AutoDoc");

AutoDoc( "SingularInterface" :
        
        scaffold :=
        rec(
            entities := [
                    "Singular",
                    ]
            ),
         
         autodoc :=
         rec(
             files := [
                     "doc/intro.autodoc",
                     ]
             )
         );

# Create VERSION file for "make towww"
PrintTo( "VERSION", PackageInfo( "SingularInterface" )[1].Version );

QUIT;
