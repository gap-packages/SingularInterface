# SingularInterface: A GAP interface to Singular
#
# Copyright of SingularInterface belongs to its developers.
# Please refer to the COPYRIGHT file for details.
#
# SPDX-License-Identifier: GPL-2.0-or-later

if fail = LoadPackage("AutoDoc", ">= 2016.01.21") then
    Error("AutoDoc 2016.01.21 or newer is required");
fi;

AutoDoc( rec(
        scaffold := rec(
            entities := [ "Singular", "Plural", "SCA", "homalg" ],
            appendix := [ "appendix-implementation.xml" ]
            ),
        autodoc :=
        rec(
             files := [
                     "doc/intro.autodoc",
                     "doc/ring.autodoc",
                     "doc/matrix.autodoc",
                     "doc/integer.autodoc",
                     ],
             ),
        
        maketest := rec( folder := ".",
                         commands := [ "LoadPackage( \"SingularInterface\" );" ],
                         )
));

# Create VERSION file for "make towww"
PrintTo( "VERSION", GAPInfo.PackageInfoCurrent.Version );
