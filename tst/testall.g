LoadPackage("SingularInterface");
dirs:=DirectoriesPackageLibrary("SingularInterface", "tst");
TestDirectory(dirs, rec(exitGAP := true));
FORCE_QUIT_GAP(1);
