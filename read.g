ReadPackage("libsing", "lib/singtypes.gi");
ReadPackage("libsing", "lib/libsing.gi");
ReadPackage("libsing", "lib/arith.gi");

_SI_BindSingularProcs("SIL_");
# Also bind the standard.lib under SI_:
_SI_BindSingularProcs("SI_");
