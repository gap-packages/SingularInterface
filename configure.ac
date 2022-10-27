# SingularInterface: A GAP interface to Singular
#
# Copyright of SingularInterface belongs to its developers.
# Please refer to the COPYRIGHT file for details.
#
# SPDX-License-Identifier: GPL-2.0-or-later

dnl ##
dnl ## Setup autoconf
dnl ##
AC_PREREQ([2.68])
AC_INIT([SingularInterface], m4_esyscmd([tr -d '\n' < VERSION]), [gapsing@mathematik.uni-kl.de])
AC_CONFIG_SRCDIR([src/libsing.h])
AC_CONFIG_HEADERS([src/pkgconfig.h:cnf/pkgconfig.h.in])
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_AUX_DIR([cnf])

dnl ##
dnl ## Get canonical host info
dnl ##
AC_CANONICAL_HOST

dnl ##
dnl ## Setup automake
dnl ##
AM_INIT_AUTOMAKE([-Wall foreign subdir-objects])
AM_SILENT_RULES([yes])
AM_PROG_AR

#AC_PREFIX_DEFAULT([${PWD}/src])

dnl ##
dnl ## Check for the compiler
dnl ##
AC_PROG_CXX

dnl ##
dnl ## Setup libtool (for building the GAP kernel extension)
dnl ##
LT_PREREQ([2.4.2])
LT_INIT([disable-static dlopen win32-dll])

dnl ##
dnl ## Locate the GAP root dir
dnl ##
AC_FIND_GAP

dnl ##
dnl ## Check for Singular >= 4.0.1
dnl ##
LB_CHECK_LIBSINGULAR([4.0.1],
 [],
 [AC_MSG_ERROR([required library libSingular not found])])

dnl ##
dnl ## Detect pointer size to distinguish 32 and 64 bit builds
dnl ##
AC_CHECK_SIZEOF([void **])

dnl ##
dnl ## Output everything
dnl ##
AC_CONFIG_FILES([Makefile])
AC_OUTPUT
