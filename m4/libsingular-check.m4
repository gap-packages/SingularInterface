# Check for libSingular via the libsingular-config tool

dnl LB_CHECK_LIBSINGULAR ([MINIMUM-VERSION [, ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]]])
dnl
dnl Test for the libSingular library and define LIBSINGULAR_CFLAGS and LIBSINGULAR_LIBS

AC_DEFUN([LB_CHECK_LIBSINGULAR],[

AC_ARG_WITH([libSingular],[
    AS_HELP_STRING([--with-libSingular=<path>],[
        Override in which location we check for the libsingular-config tool.
        By default, the current PATH is searched. With this option given, we
        instead search in <path>/bin/libsingular-config.]
    )],
    [LIBSINGULAR_CONFIG="$withval/bin/libsingular-config"],
    [LIBSINGULAR_CONFIG=""])

AC_PATH_PROGS([LIBSINGULAR_CONFIG], [libsingular-config])

dnl Check for existence
AC_MSG_CHECKING([for libSingular])

LIBSINGULAR_CFLAGS=""
LIBSINGULAR_LIBS=""

AS_IF([test -x "$LIBSINGULAR_CONFIG"],[
    LIBSINGULAR_found="yes"
    LIBSINGULAR_CFLAGS="`$LIBSINGULAR_CONFIG --cflags`"
    LIBSINGULAR_LIBS="`$LIBSINGULAR_CONFIG --libs`"
    LIBSINGULAR_HOME="`$LIBSINGULAR_CONFIG --prefix`"
    LIBSINGULAR_VERSION="`$LIBSINGULAR_CONFIG --version`"
    AC_MSG_RESULT([found at $LIBSINGULAR_HOME])

    AS_IF([test x"$1" != x],[
        dnl Check for provided library version
        AC_MSG_CHECKING([for libSingular >= $1])
        AX_COMPARE_VERSION($LIBSINGULAR_VERSION,[ge],[$1],[
            AC_MSG_RESULT([yes, found $LIBSINGULAR_VERSION])
            LIBSINGULAR_found="yes"
        ],[
            AC_MSG_RESULT([no, found $LIBSINGULAR_VERSION])
            LIBSINGULAR_found="no"
        ])
    ],[
    ])
],[
    AC_MSG_RESULT([not found])
    LIBSINGULAR_found="no"
])

AS_IF([test "x$LIBSINGULAR_found" = "xyes"],[
    AC_SUBST(LIBSINGULAR_CFLAGS)
    AC_SUBST(LIBSINGULAR_LIBS)
    AC_SUBST(LIBSINGULAR_HOME)
    AC_DEFINE_UNQUOTED(LIBSINGULAR_HOME,"$LIBSINGULAR_HOME",Prefix for libSingular)
    # execute user provided code, if any:
    :
    $2
],[
    # execute user provided code, if any:
    :
    $3
])


])
