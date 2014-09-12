#
# SingularInterface: A GAP interface to Singular
#
# Copyright (C) 2011-2014  Mohamed Barakat, Max Horn, Frank Lübeck,
#                          Oleksandr Motsak, Max Neunhöffer, Hans Schönemann
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
#

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
