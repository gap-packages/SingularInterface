# load kernel functions if possible
# try the static module first

if not IsBound(LIBSINGULAR) then
  if "libsing" in SHOW_STAT() then
    LoadStaticModule("libsing");
  fi;
fi;
# now try the dynamic module
if not IsBound(LIBSINGULAR) then
  if Filename(DirectoriesPackagePrograms("libsingular"), 
              "libsing.so") <> fail then
    LoadDynamicModule(Filename(DirectoriesPackagePrograms("libsingular"), 
                               "libsing.so"));
  fi;
fi;

ReadPackage( "libsingular", "lib/libsingular.gd" );

