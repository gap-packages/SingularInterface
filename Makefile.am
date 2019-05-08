# SingularInterface: A GAP interface to Singular
#
# Copyright of SingularInterface belongs to its developers.
# Please refer to the COPYRIGHT file for details.
#
# SPDX-License-Identifier: GPL-2.0-or-later

ACLOCAL_AMFLAGS = -I m4

BINARCHDIR = bin/$(GAPARCH)
GAPINSTALLLIB = $(BINARCHDIR)/SingularInterface.so
AM_CPPFLAGS= $(LIBSINGULAR_CFLAGS)

lib_LTLIBRARIES = SingularInterface.la
bin_PROGRAMS = gentableforGAP

gentableforGAP_SOURCES = src/gentableforGAP.cc
gentableforGAP_CPPFLAGS = $(AM_CPPFLAGS)

SingularInterface_la_SOURCES = \
    src/calls.cc \
    src/cxxfuncs.cc \
    src/libsing.cc \
    src/libsing.h \
    src/lowlevel_mappings.cc \
    src/lowlevel_mappings.h \
    src/matrix.cc \
    src/matrix.h \
    src/number.cc \
    src/number.h \
    src/singobj.cc \
    src/singobj.h \
    src/singtypes.cc \
    src/singtypes.h
SingularInterface_la_LDFLAGS = -module -avoid-version -R$(LIBSINGULAR_HOME)/lib
SingularInterface_la_LIBADD = $(LIBSINGULAR_LIBS)
SingularInterface_la_CPPFLAGS = $(GAP_CPPFLAGS) $(AM_CPPFLAGS)
SingularInterface_la_CXXFLAGS = -Wall -Wmissing-prototypes


all-local: $(GAPINSTALLLIB) lib/highlevel_mappings.g

clean-local: 
	rm -f $(GAPINSTALLLIB)

$(GAPINSTALLLIB): SingularInterface.la
	$(mkdir_p) $(BINARCHDIR)
	cp .libs/SingularInterface.so $(GAPINSTALLLIB)

# Apply C++ preprocessor to lowlevel_mappings_src.h to strip out
# comments and unwanted macros.
# We cannot use cpp directly, as language selection (via -x) is broken
# there on recent Mac OS X versions :-(/
src/lowlevel_mappings_src.h: src/lowlevel_mappings_src.h.in
	c++ -E -P -DPINLINE0= -DPINLINE2= -Dinline= -x c++ $< > $@

src/lowlevel_mappings.cc src/lowlevel_mappings.h: src/lowlevel_mappings_table.h
src/lowlevel_mappings_table.h: src/gen_lowlevel_mappings.g src/lowlevel_mappings_src.h
	@echo "Generating lowlevel mappings..."
	$(GAPROOT)/bin/gap.sh -A -q -T < $<
	@echo "Done!"

src/highlevel_mappings_table.g:	gentableforGAP
	./gentableforGAP > $@

lib/highlevel_mappings.g: src/highlevel_mappings_table.g src/gen_highlevel_mappings.g
	@echo "Generating highlevel mappings..."
	$(GAPROOT)/bin/gap.sh -A -q --quitonbreak src/gen_highlevel_mappings.g
	@echo "Done!"

BUILT_SOURCES = \
	src/lowlevel_mappings.cc \
	src/lowlevel_mappings.h \
	src/lowlevel_mappings_table.h

CLEANFILES = \
	src/lowlevel_mappings.cc \
	src/lowlevel_mappings.h \
	src/lowlevel_mappings_table.h \
	src/lowlevel_mappings_src.h \
	lib/highlevel_mappings.g \
	src/highlevel_mappings_table.g


indent:
	astyle --options=libsing.astyle src/cxxfuncs.cc src/libsing.cc src/singtypes.cc

.PHONY: doc
