AC_DEFUN([CHECK_ZLIB],
#
# Handle user hints
#
[AC_MSG_CHECKING(if zlib is wanted)
AC_ARG_WITH(zlib,
[  --with-zlib=DIR root directory path of zlib installation [defaults to
                    /usr/local or /usr if not found in /usr/local]
  --without-zlib to disable zlib usage completely],
[if test "$withval" != no ; then
  AC_MSG_RESULT(yes)
  ZLIB_HOME="$withval"
else
  AC_MSG_RESULT(no)
fi], [
AC_MSG_RESULT(yes)
ZLIB_HOME=/usr/local
if test ! -f "${ZLIB_HOME}/include/zlib.h"
then
        ZLIB_HOME=/usr
fi
])

#
# Locate zlib, if wanted
#
if test -n "${ZLIB_HOME}"
then
        ZLIB_OLD_LDFLAGS=$LDFLAGS
        ZLIB_OLD_CPPFLAGS=$LDFLAGS
        LDFLAGS="$LDFLAGS -L${ZLIB_HOME}/lib"
        CPPFLAGS="$CPPFLAGS -I${ZLIB_HOME}/include"
        AC_LANG_SAVE
        AC_LANG_C
        AC_CHECK_LIB(z, inflateEnd, [zlib_cv_libz=yes], [zlib_cv_libz=no])
        AC_CHECK_HEADER(zlib.h, [zlib_cv_zlib_h=yes], [zlib_cv_zlib_h=no])
        AC_LANG_RESTORE
        if test "$zlib_cv_libz" = "yes" -a "$zlib_cv_zlib_h" = "yes"
        then
                #
                # If both library and header were found, use them
                #
                AC_CHECK_LIB(z, inflateEnd)
                AC_MSG_CHECKING(zlib in ${ZLIB_HOME})
                AC_MSG_RESULT(ok)
        else
                #
                # If either header or library was not found, revert and bomb
                #
                AC_MSG_CHECKING(zlib in ${ZLIB_HOME})
                LDFLAGS="$ZLIB_OLD_LDFLAGS"
                CPPFLAGS="$ZLIB_OLD_CPPFLAGS"
                AC_MSG_RESULT(failed)
        fi
fi

])

AC_DEFUN([CHECK_XLIB],
#
# Handle user hints
#
[AC_MSG_CHECKING(if xlib is wanted)
AC_ARG_WITH(xlib,
[  --with-xlib=DIR root directory path of xlib installation [defaults to
          /usr/X11 or /usr/X11R6 or /usr/openwin if not found in /usr/X11]
  --without-xlib to disable xlib usage completely],
[if test "$withval" != no ; then
  AC_MSG_RESULT(yes)
  XLIB_HOME="$withval"
else
  AC_MSG_RESULT(no)
fi], [
AC_MSG_RESULT(yes)
XLIB_HOME=/usr/X11
if test ! -f "${XLIB_HOME}/include/X11/Xlib.h"
then
        XLIB_HOME=/usr/X11R6
	if test ! -f "${XLIB_HOME}/include/X11/Xlib.h"
	then
	        XLIB_HOME=/usr/openwin
	fi
fi
])

#
# Locate Xlib, if wanted
#
if test -n "${XLIB_HOME}"
then
        XLIB_OLD_LDFLAGS=$LDFLAGS
        XLIB_OLD_CPPFLAGS=$LDFLAGS
        LDFLAGS="$LDFLAGS -L${XLIB_HOME}/lib"
        CPPFLAGS="$CPPFLAGS -I${XLIB_HOME}/include"
        AC_LANG_SAVE
        AC_LANG_C
        AC_CHECK_LIB(X11, XAllocColorCells, [xlib_cv_libx=yes], [xlib_cv_libx=no])
        AC_CHECK_HEADER(X11/Xlib.h, [xlib_cv_xlib_h=yes], [xlib_cv_xlib_h=no])
        AC_CHECK_HEADER(X11/Xos.h, [xlib_cv_xos_h=yes], [xlib_cv_xos_h=no])
        AC_CHECK_HEADER(X11/Xutil.h, [xlib_cv_xutil_h=yes], [xlib_cv_xutil_h=no])
        AC_CHECK_HEADER(X11/Xatom.h, [xlib_cv_xatom_h=yes], [xlib_cv_xatom_h=no])
        AC_LANG_RESTORE
        if test "$xlib_cv_libx" = "yes" -a "$xlib_cv_xlib_h" = "yes" -a "$xlib_cv_xos_h" = "yes" -a "$xlib_cv_xutil_h" = "yes" -a "$xlib_cv_xatom_h" = "yes"
        then
                #
                # If both library and header were found, use them
                #
                AC_CHECK_LIB(X11, XAllocColorCells)
                AC_MSG_CHECKING(xlib in ${XLIB_HOME})
                AC_MSG_RESULT(ok)
        else
                #
                # If either header or library was not found, revert and bomb
                #
                AC_MSG_CHECKING(xlib in ${XLIB_HOME})
                LDFLAGS="$XLIB_OLD_LDFLAGS"
                CPPFLAGS="$XLIB_OLD_CPPFLAGS"
                AC_MSG_RESULT(failed)
        fi
fi

])


AC_DEFUN([CHECK_JPEG],
#
# Handle user hints
#
[AC_MSG_CHECKING(if jpeg is wanted)
AC_ARG_WITH(jpeg,
[  --with-jpeg=DIR root directory path of jpeg installation [defaults to
                    /usr/local or /usr if not found in /usr/local]
  --without-jpeg to disable jpeg usage completely],
[if test "$withval" != no ; then
  AC_MSG_RESULT(yes)
  JPEG_HOME="$withval"
else
  AC_MSG_RESULT(no)
fi], [
AC_MSG_RESULT(yes)
JPEG_HOME=/usr/local
if test ! -f "${JPEG_HOME}/include/jpeglib.h"
then
        JPEG_HOME=/usr
fi
])

#
# Locate JPEG, if wanted
#
if test -n "${JPEG_HOME}"
then
        JPEG_OLD_LDFLAGS=$LDFLAGS
        JPEG_OLD_CPPFLAGS=$LDFLAGS
        LDFLAGS="$LDFLAGS -L${JPEG_HOME}/lib"
        CPPFLAGS="$CPPFLAGS -I${JPEG_HOME}/include"
        AC_LANG_SAVE
        AC_LANG_C
        AC_CHECK_LIB(jpeg, jpeg_destroy_decompress, [jpeg_cv_libjpeg=yes], [jpeg_cv_libjpeg=no])
        AC_CHECK_HEADER(jpeglib.h, [jpeg_cv_jpeglib_h=yes], [jpeg_cv_jpeglib_h=no])
        AC_CHECK_HEADER(jerror.h, [jpeg_cv_jerror_h=yes], [jpeg_cv_jerror_h=no])
        AC_LANG_RESTORE
        if test "$jpeg_cv_libjpeg" = "yes" -a "$jpeg_cv_jpeglib_h" = "yes" -a "$jpeg_cv_jerror_h" = "yes"
        then
                #
                # If both library and headers were found, use them
                #
                AC_CHECK_LIB(jpeg, jpeg_destroy_decompress)
                AC_MSG_CHECKING(jpeg in ${JPEG_HOME})
                AC_MSG_RESULT(ok)
        else
                #
                # If either header or library was not found, revert and bomb
                #
                AC_MSG_CHECKING(jpeg in ${JPEG_HOME})
                LDFLAGS="$JPEG_OLD_LDFLAGS"
                CPPFLAGS="$JPEG_OLD_CPPFLAGS"
                AC_MSG_RESULT(failed)
        fi
fi

])


AC_DEFUN([CHECK_OPENGL],
#
# Handle user hints
#
[AC_MSG_CHECKING(if opengl is wanted)
AC_ARG_WITH(opengl,
[  --with-opengl=DIR root directory path of opengl installation [defaults to
                    /usr/local or /usr if not found in /usr/local]
  --without-opengl to disable opengl usage completely],
[if test "$withval" != no ; then
  AC_MSG_RESULT(yes)
  OPENGL_HOME="$withval"
else
  AC_MSG_RESULT(no)
fi], [
AC_MSG_RESULT(yes)
OPENGL_HOME=/usr/local
if test ! -f "${OPENGL_HOME}/include/GL/gl.h"
then
        OPENGL_HOME=/usr/X11R6
fi
if test ! -f "${OPENGL_HOME}/include/GL/gl.h"
then
        OPENGL_HOME=/usr
fi
])

#
# Locate OPENGL, if wanted
#
if test -n "${OPENGL_HOME}"
then
        OPENGL_OLD_LDFLAGS=$LDFLAGS
        OPENGL_OLD_CPPFLAGS=$LDFLAGS
        LDFLAGS="$LDFLAGS -lm -L${OPENGL_HOME}/lib"
        CPPFLAGS="$CPPFLAGS -I${OPENGL_HOME}/include"
        AC_LANG_SAVE
        AC_LANG_C
        AC_CHECK_LIB(GL, glAccum, [opengl_cv_libGL=yes], [opengl_cv_libGL=no])
        AC_CHECK_LIB(GLU, gluBeginCurve, [opengl_cv_libGLU=yes], [opengl_cv_libGLU=no], [-lGL])
        AC_CHECK_HEADER(GL/gl.h, [opengl_cv_gl_h=yes], [opengl_cv_gl_h=no])
        AC_CHECK_HEADER(GL/glx.h, [opengl_cv_glx_h=yes], [opengl_cv_glx_h=no])
        AC_CHECK_HEADER(GL/glu.h, [opengl_cv_glu_h=yes], [opengl_cv_glu_h=no])
        AC_LANG_RESTORE
        if test "$opengl_cv_libGL" = "yes" -a "$opengl_cv_libGLU" = "yes" -a "$opengl_cv_gl_h" = "yes" -a "$opengl_cv_glx_h" = "yes" -a "$opengl_cv_glu_h" = "yes"
        then
                #
                # If both library and headers were found, use them
                #
                AC_CHECK_LIB(GL, glAccum)
                AC_CHECK_LIB(GLU, gluBeginCurve)
	        GL_CFLAGS=" -I${OPENGL_HOME}/include"
	        AC_SUBST(GL_CFLAGS)
	        GL_LDFLAGS=" -L${OPENGL_HOME}/lib"
	        AC_SUBST(GL_LDFLAGS)
                AC_MSG_CHECKING(GL in ${OPENGL_HOME})
                AC_MSG_RESULT(ok)
        else
                #
                # If either header or library was not found, revert and bomb
                #
                AC_MSG_CHECKING(GL in ${OPENGL_HOME})
                LDFLAGS="$OPENGL_OLD_LDFLAGS"
                CPPFLAGS="$OPENGL_OLD_CPPFLAGS"
	        GL_CFLAGS=
	        AC_SUBST(GL_CFLAGS)
	        GL_LDFLAGS=
	        AC_SUBST(GL_LDFLAGS)
                AC_MSG_RESULT(failed)
        fi
fi

])




AC_DEFUN([CHECK_ODBC],
#
# Handle user hints
#
[AC_MSG_CHECKING(if odbc is wanted)
AC_ARG_WITH(odbc,
[  --with-odbc=DIR root directory path of odbc installation [defaults to
                    /usr/local or /usr if not found in /usr/local]
  --without-odbc to disable odbc usage completely],
[if test "$withval" != no ; then
  AC_MSG_RESULT(yes)
  ODBC_HOME="$withval"
else
  AC_MSG_RESULT(no)
fi], [
AC_MSG_RESULT(yes)
ODBC_HOME=/usr/local
if test ! -f "${ODBC_HOME}/include/sqlext.h"
then
        ODBC_HOME=/usr
fi
])

#
# Locate ODBC, if wanted
#
if test -n "${ODBC_HOME}"
then
        ODBC_OLD_LDFLAGS=$LDFLAGS
        ODBC_OLD_CPPFLAGS=$LDFLAGS
        LDFLAGS="$LDFLAGS -L${ODBC_HOME}/lib"
        CPPFLAGS="$CPPFLAGS -I${ODBC_HOME}/include"
        AC_LANG_SAVE
        AC_LANG_C
        AC_CHECK_LIB(iodbc, SQLAllocConnect, [odbc_cv_libiodbc=yes], [odbc_cv_libiodbc=no])
        AC_CHECK_LIB(odbc, SQLAllocConnect, [odbc_cv_libodbc=yes], [odbc_cv_libodbc=no])
        AC_CHECK_HEADER(sqlext.h, [odbc_cv_sqlext_h=yes], [odbc_cv_sqlext_h=no])
        AC_LANG_RESTORE
        if test "$odbc_cv_libiodbc" = "yes" -a "$odbc_cv_sqlext_h" = "yes"
        then
                #
                # If both library and headers were found, use them
                #
                AC_CHECK_LIB(iodbc, SQLAllocConnect)
                AC_MSG_CHECKING(odbc in ${ODBC_HOME})
                AC_MSG_RESULT(ok)
        else
        if test "$odbc_cv_libodbc" = "yes" -a "$odbc_cv_sqlext_h" = "yes"
        then
                #
                # If both library and headers were found, use them
                #
                AC_CHECK_LIB(odbc, SQLAllocConnect)
                AC_MSG_CHECKING(odbc in ${ODBC_HOME})
                AC_MSG_RESULT(ok)
        else
                #
                # If either header or library was not found, revert and bomb
                #
                AC_MSG_CHECKING(odbc in ${ODBC_HOME})
                LDFLAGS="$ODBC_OLD_LDFLAGS"
                CPPFLAGS="$ODBC_OLD_CPPFLAGS"
                AC_MSG_RESULT(failed)
        fi
        fi
fi

])

AC_DEFUN([AC_VAR_TIMEZONE_EXTERNALS],
[  AC_REQUIRE([AC_STRUCT_TIMEZONE])dnl
   AC_CACHE_CHECK(for timezone external, mb_cv_var_timezone,
   [  AC_TRY_LINK([#include <time.h>], [return (int)timezone;],
         mb_cv_var_timezone=yes,
         mb_cv_var_timezone=no)
   ])
   AC_CACHE_CHECK(for altzone external, mb_cv_var_altzone,
   [  AC_TRY_LINK([#include <time.h>], [return (int)altzone;],
         mb_cv_var_altzone=yes,
         mb_cv_var_altzone=no)
   ])
   AC_CACHE_CHECK(for daylight external, mb_cv_var_daylight,
   [  AC_TRY_LINK([#include <time.h>], [return (int)daylight;],
         mb_cv_var_daylight=yes,
         mb_cv_var_daylight=no)
   ])
   if test $mb_cv_var_timezone = yes; then
      AC_DEFINE([HAVE_TIMEZONE], 1,
              [Define if you have the external `timezone' variable.])
   fi
   if test $mb_cv_var_altzone = yes; then
      AC_DEFINE([HAVE_ALTZONE], 1,
              [Define if you have the external `altzone' variable.])
   fi
   if test $mb_cv_var_daylight = yes; then
      AC_DEFINE([HAVE_DAYLIGHT], 1,
              [Define if you have the external `daylight' variable.])
   fi
])

AC_DEFUN(AC_CHECK_GLOBAL,
[for ac_global in $1
do
   ac_tr_global=HAVE_`echo $ac_global | tr 'abcdefghijklmnopqrstuvwxyz' 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'`
   AC_MSG_CHECKING([for global variable ${ac_global}])
   AC_CACHE_VAL(ac_cv_global_$ac_global,
   [
    AC_TRY_LINK(dnl
    [/* no includes */],
    [ extern long int $ac_global;  exit((int)$ac_global)],
    eval "ac_cv_global_${ac_global}=yes",
    eval "ac_cv_global_${ac_global}=no"
    )
dnl   ]
   )
  if eval "test \"`echo '$ac_cv_global_'$ac_global`\" = yes"; then
    AC_MSG_RESULT(yes)
    AC_DEFINE_UNQUOTED($ac_tr_global)
  else
    AC_MSG_RESULT(no)
  fi
done
])
