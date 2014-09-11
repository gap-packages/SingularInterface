ReadPackage("SingularInterface", "lib/singtypes.gi");
ReadPackage("SingularInterface", "lib/libsing.gi");
ReadPackage("SingularInterface", "lib/arith.gi");

_SI_BindSingularProcs("SIL_");
# Also bind the standard.lib under SI_:
_SI_BindSingularProcs("SI_");
