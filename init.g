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
