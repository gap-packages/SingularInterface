# Check for libpolys
# Modified by Oleksandr and Brad

dnl LB_CHECK_LIBPOLYS ([MINIMUM-VERSION [, ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]]])
dnl
dnl Test for the libpolys library and define LIBPOLYS_CFLAGS and LIBPOLYS_LIBS

AC_DEFUN([LB_CHECK_LIBPOLYS],
[
DEFAULT_CHECKING_PATH="/usr /usr/local /sw /opt/local"

AC_ARG_WITH(libpolys,
[  --with-libpolys= <path>|yes Use libpolys library. This library is mandatory for Singular
	                 compilation. If argument is yes or <empty> that means 
   	       		 the library is reachable with the standard search path
			 "/usr" or "/usr/local" (set as default). Otherwise you
			 give the <path> to the directory which contain the 
			 library.
],
		[if test "$withval" = yes ; then
			LIBPOLYS_HOME_PATH="${DEFAULT_CHECKING_PATH}"
	         elif test "$withval" != no ; then
			LIBPOLYS_HOME_PATH="$withval ${DEFAULT_CHECKING_PATH}"
	        fi],
		[LIBPOLYS_HOME_PATH="${DEFAULT_CHECKING_PATH}"])

dnl Check for existence
AC_MSG_CHECKING(for libpolys)

LIBPOLYS_CFLAGS=""
LIBPOLYS_LIBS=""

# TODO: Add the version check...!

for LIBPOLYS_HOME in ${LIBPOLYS_HOME_PATH} 
  do
	SCRIPT_NAME="$LIBPOLYS_HOME/bin/libpolys-config"
	if test -x "$SCRIPT_NAME" ; then
		LIBPOLYS_found="yes"
		LIBPOLYS_CFLAGS="`$SCRIPT_NAME --cflags`"
		LIBPOLYS_LIBS="`$SCRIPT_NAME --libs`"
		AC_MSG_RESULT([found at $LIBPOLYS_HOME])
		break
	else
		LIBPOLYS_found="no"	
	fi
done

if test "x$LIBPOLYS_found" = "xyes"; then
	AC_DEFINE(HAVE_LIBPOLYS,1,[Enable libpolys])
	AC_DEFINE_UNQUOTED(LIBPOLYS_HOME,"$LIBPOLYS_HOME",Prefix for libpolys)
  AC_SUBST(LIBPOLYS_HOME)
else
	AC_MSG_RESULT(not found)
fi

AC_SUBST(LIBPOLYS_CFLAGS)
AC_SUBST(LIBPOLYS_LIBS)

])
