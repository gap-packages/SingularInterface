# load kernel functions if possible
# try the static module first

if not IsBound(LIBSINGULAR) then
  if "libsing" in SHOW_STAT() then
    LoadStaticModule("libsing");
  fi;
fi;
# now try the dynamic module
if not IsBound(LIBSINGULAR) then
  if Filename(DirectoriesPackagePrograms("libsing"), 
              "libsing.so") <> fail then
    LoadDynamicModule(Filename(DirectoriesPackagePrograms("libsing"), 
                               "libsing.so"));
  fi;
fi;

#ReadPackage( "libsing", "lib/highlevel_mappings_table.g" );
ReadPackage( "libsing", "lib/highlevel_mappings.g" );
ReadPackage( "libsing", "lib/libsing.gd" );
