# SingularInterface: A GAP interface to Singular
#
# Copyright of SingularInterface belongs to its developers.
# Please refer to the COPYRIGHT file for details.
#
# SPDX-License-Identifier: GPL-2.0-or-later

ReadPackage("SingularInterface", "lib/singtypes.gi");
ReadPackage("SingularInterface", "lib/libsing.gi");
ReadPackage("SingularInterface", "lib/view.gi");
ReadPackage("SingularInterface", "lib/arith.gi");

ReadPackage("SingularInterface", "lib/interpreter.gi");
ReadPackage("SingularInterface", "lib/proxy.gi");

ReadPackage("SingularInterface", "lib/types/matrix.gi");
ReadPackage("SingularInterface", "lib/types/ring.gi");


_SI_BindSingularProcs("SIL_");
