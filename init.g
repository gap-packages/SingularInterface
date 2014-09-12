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

SI_DEBUG_MODE := false;

# load kernel functions if possible
# try the static module first
if not IsBound(_SI_SINGULARINTERFACE_LOADED) then
  if "SingularInterface" in SHOW_STAT() then
    LoadStaticModule("SingularInterface");
  fi;
fi;
# now try the dynamic module
if not IsBound(_SI_SINGULARINTERFACE_LOADED) then
  if Filename(DirectoriesPackagePrograms("SingularInterface"), 
              "SingularInterface.so") <> fail then
    LoadDynamicModule(Filename(DirectoriesPackagePrograms("SingularInterface"), 
                               "SingularInterface.so"));
  fi;
fi;

#ReadPackage("SingularInterface", "lib/highlevel_mappings_table.g");
ReadPackage("SingularInterface", "lib/highlevel_mappings.g");
ReadPackage("SingularInterface", "lib/singtypes.gd");
ReadPackage("SingularInterface", "lib/libsing.gd");

ReadPackage("SingularInterface", "lib/interpreter.gd");
ReadPackage("SingularInterface", "lib/proxy.gd");

ReadPackage("SingularInterface", "lib/types/ring.gd");
