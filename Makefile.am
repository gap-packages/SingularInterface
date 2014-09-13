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

ACLOCAL_AMFLAGS = -I m4

BINARCHDIR = bin/$(GAPARCH)
GAPINSTALLLIB = $(abs_top_srcdir)/$(BINARCHDIR)/SingularInterface.so
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
    src/poly.cc \
    src/poly.h \
    src/singobj.cc \
    src/singobj.h \
    src/singtypes.cc \
    src/singtypes.h
SingularInterface_la_LDFLAGS = -module -avoid-version
# -R$(LIBSINGULAR_HOME)/lib -R$(LIBSINGULAR_HOME)/lib/singular
SingularInterface_la_LIBADD = $(LIBSINGULAR_LIBS)
SingularInterface_la_CPPFLAGS = $(GAP_CPPFLAGS) $(AM_CPPFLAGS)
SingularInterface_la_CXXFLAGS = -Wall -Wmissing-prototypes


all-local: $(GAPINSTALLLIB) lib/highlevel_mappings.g
	@echo "***********************************************************************"
	@echo ""
	@echo "  SUCCESS!"
	@echo ""
	@echo "***********************************************************************"

clean-local: 
	rm -f $(GAPINSTALLLIB)

$(GAPINSTALLLIB): SingularInterface.la
	$(mkdir_p) $(top_srcdir)/$(BINARCHDIR)
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
	$(GAPROOT)/bin/gap.sh -A -q -T < src/gen_highlevel_mappings.g
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


AM_COLOR_TESTS = always
TESTS_ENVIRONMENT = GAP_EXECUTABLE='$(GAPROOT)/bin/gap.sh'
TESTS = test.sh
