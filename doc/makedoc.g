LoadPackage("AutoDoc");

AutoDoc(
    "libsing" : 
    autodoc := true,
    scaffold := rec(
        includes := [
            "intro.xml",
            ],
        entities := [
            "Singular",
        ],
    )
);

# Create VERSION file for "make towww"
PrintTo( "VERSION", PackageInfo( "libsing" )[1].Version );

QUIT;
