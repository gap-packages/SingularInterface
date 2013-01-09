# Check for libSingular
# by Oleksandr

dnl LB_CHECK_LIBSINGULAR ([MINIMUM-VERSION [, ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]]])
dnl
dnl Test for the libSingular library and define LIBSINGULAR_CFLAGS and LIBSINGULAR_LIBS

AC_DEFUN([LB_CHECK_LIBSINGULAR],
[
DEFAULT_CHECKING_PATH="/usr /usr/local /sw /opt/local"

AC_ARG_WITH(libSingular,
[  --with-libSingular= <path>|yes Use libSingular library. If argument is yes or <empty> that means 
   	       		 the library is reachable with the standard search path
			 "/usr" or "/usr/local" (set as default). Otherwise you
			 give the <path> to the directory which contain the 
			 library.
],
		[if test "$withval" = yes ; then
			LIBSINGULAR_HOME_PATH="${DEFAULT_CHECKING_PATH}"
	         elif test "$withval" != no ; then
			LIBSINGULAR_HOME_PATH="$withval ${DEFAULT_CHECKING_PATH}"
	        fi],
		[LIBSINGULAR_HOME_PATH="${DEFAULT_CHECKING_PATH}"])

dnl Check for existence
AC_MSG_CHECKING(for libSingular)

LIBSINGULAR_CFLAGS=""
LIBSINGULAR_LIBS=""

# TODO: Add the version check...!

for LIBSINGULAR_HOME in ${LIBSINGULAR_HOME_PATH} 
  do
	SCRIPT_NAME="$LIBSINGULAR_HOME/bin/libsingular-config"
	if test -x "$SCRIPT_NAME" ; then
		LIBSINGULAR_found="yes"
		LIBSINGULAR_CFLAGS="`$SCRIPT_NAME --cflags`"
		LIBSINGULAR_LIBS="`$SCRIPT_NAME --libs`"
		AC_MSG_RESULT([found at $LIBSINGULAR_HOME])
		break
	else
		LIBSINGULAR_found="no"	
	fi
done

if test "x$LIBSINGULAR_found" = "xyes"; then
	AC_DEFINE(HAVE_LIBSINGULAR,1,[Enable libSingular])
	AC_DEFINE_UNQUOTED(LIBSINGULAR_HOME,"$LIBSINGULAR_HOME",Prefix for libSingular)
        AC_SUBST(LIBSINGULAR_HOME)
else
	AC_MSG_RESULT(not found)
fi

AC_SUBST(LIBSINGULAR_CFLAGS)
AC_SUBST(LIBSINGULAR_LIBS)

])
