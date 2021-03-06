# SingularInterface: A GAP interface to Singular
#
# Copyright of SingularInterface belongs to its developers.
# Please refer to the COPYRIGHT file for details.
#
# SPDX-License-Identifier: GPL-2.0-or-later

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

ReadPackage("SingularInterface", "lib/highlevel_mappings.g");
ReadPackage("SingularInterface", "lib/singtypes.gd");
ReadPackage("SingularInterface", "lib/libsing.gd");

ReadPackage("SingularInterface", "lib/interpreter.gd");
ReadPackage("SingularInterface", "lib/proxy.gd");

ReadPackage("SingularInterface", "lib/types/ring.gd");
