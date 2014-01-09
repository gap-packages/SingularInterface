LoadPackage("AutoDoc");

AutoDoc( "libsing" :
        
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
PrintTo( "VERSION", PackageInfo( "libsing" )[1].Version );

QUIT;
