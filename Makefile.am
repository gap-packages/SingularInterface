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
AM_LIBTOOLFLAGS=--silent

SUBDIRS = src

EXTRA_DIST = \
	PackageInfo.g \
	init.g \
	read.g 

dist-hook:
	@echo "---------------------------------------------------------------"
	@echo ""
	@echo " Did you call dist2, not dist? If not, why not?"	
	@echo ""
	@echo "---------------------------------------------------------------"

# My own dist which sets the directory permissions to 755, not 777
dist2: distdir
	-find $(distdir) -type d -perm -777 -exec chmod 755 {} \;
	tardir=$(distdir) && $(am__tar) | GZIP=$(GZIP_ENV) gzip -c >$(distdir).tar.gz
	$(am__remove_distdir)
	
indent:
	astyle --options=libsing.astyle src/cxxfuncs.cc src/libsing.cc src/singtypes.cc



AM_COLOR_TESTS = always
TESTS_ENVIRONMENT = GAP_EXECUTABLE='$(GAPROOT)/bin/gap.sh'
TESTS = test.sh
EXTRA_DIST += $(TESTS) tst/check.g
