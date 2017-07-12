
# arsgs: additionals cflags, ldflags and cppflags.  
AC_DEFUN([save_flags],
[
	TMP_CPPFLAGS=$CPPFLAGS
 	TMP_LDFLAGS=$LDFLAGS
 	TMP_CFLAGS=$CFLAGS
 	TMP_LIBS=$LIBS

	for part in $1
  	do
		FOUND=
		for itm in $CPPFLAGS -a -z $FOUND
    		do
			if test $itm = $part
      			then
				FOUND=1
      			fi
    		done

		if test -z $FOUND ; then
	   	   CPPFLAGS="$CPPFLAGS $part"     
		fi
	done

  	for part in $2
  	do
		FOUND=
		for itm in $LDFLAGS -a -z $FOUND
    		do
			if test $itm = $part
      			then
				FOUND=1
      			fi
    		done

		if test -z $FOUND ; then
	   	   LDFLAGS="$LDFLAGS $part"     
		fi
	done

])

#assuming a call was already made to save the flags
AC_DEFUN([restore_flags],
[
	CFLAGS=$TMP_CFLAGS  
	LDFLAGS=$TMP_LDFLAGS
	CPPFLAGS=$TMP_CPPFLAGS
 	LIBS=$TMP_LIBS
])

AC_DEFUN([fail_and_restore],
[
	restore_flags()
	AC_MSG_CHECKING(checking lib $1)
	AC_MSG_RESULT(failed)
])

# 
# $1 libname
# $2 path to the libraray
# $3 headers to check 
# $4 function to check in the library
# $5 the symobol to define if the function/lib exist
# $6 lang (C or C++)
AC_DEFUN([do_lib_check],
[
if test -n $2
then
	save_flags([-I$2/include], [-L$2/lib], [])
        AC_LANG_PUSH([$6])
	# If we have mulltiple headers, any missing one will set this to no
	cv_libthislib_h=yes
        AC_CHECK_HEADERS([$3], [], [cv_libthislib_h=no], [])
	if test $cv_libthislib_h = yes ;  then
	  AC_SEARCH_LIBS([$4], [$1],
	     [cv_lib$1=yes
	      if test -n $5 ; then
	        AC_DEFINE([$5], [1], [Define to 1 if you lib $1])
	      fi
	     ],
	     [fail_and_restore()])
        else
          fail_and_restore([$1 in $2])
	fi
	AC_LANG_POP([$6])
fi

])

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

do_lib_check([z], [${ZLIB_HOME}], [zlib.h], [inflateEnd], [HAVE_LIBZ], [C])

])

AC_DEFUN([CHECK_FREETYPE],
#
# Handle user hints
#
[AC_MSG_CHECKING(if freetype is wanted)
AC_ARG_WITH(freetype,
[  --with-freetype2=DIR root directory path of freetype installation [defaults to
                    /usr/include or /usr if not found in /usr/lib64]
  --without-freetype to disable freetype usage completely],
[if test "$withval" != no ; then
  AC_MSG_RESULT(yes)
  FREETYPE_HOME="$withval"
else
  AC_MSG_RESULT(no)
fi], [
AC_MSG_RESULT(yes)
FREETYPE_HOME=/usr/X11
if test ! -f "${FREETYPE_HOME}/include/freetype2/freetype/freetype.h"
then
FREETYPE_HOME=/usr/local
if test ! -f "${FREETYPE_HOME}/include/freetype2/freetype/freetype.h"
then
        FREETYPE_HOME=/usr
fi
fi
])

do_lib_check([freetype], [${FREETYPE_HOME}], [freetype2/freetype/freetype.h],
			 [FT_Open_Face], [HAVE_LIBFREETYPE], [C])

])


AC_DEFUN([CHECK_FTGL],
#
# Handle user hints
#
[AC_MSG_CHECKING(if FTGL is wanted)
AC_ARG_WITH(FTGL,
[  --with-FTGL=DIR root directory path of FTGL installation [defaults to /usr/local/ftgl]
  --without-FTGL to disable FTGL usage completely],
[if test "$withval" != no ; then
  AC_MSG_RESULT(yes)
  FTGL_HOME="$withval"
else
  AC_MSG_RESULT(no)
fi], [
AC_MSG_RESULT(yes)
FTGL_HOME=/usr/local
if test ! -f "${FTGL_HOME}/include/FTGL/FTGLExtrdFont.h"
then
        FTGL_HOME=/usr
fi

])

do_lib_check([ftgl], [${FTGL_HOME}], [FTGL/FTGLExtrdFont.h], [_ZN6FTFaceD2Ev], [HAVE_LIBFTGL], [C++])
if test "$cv_libftgl" = "yes" ; then
   LIBS="$LIBS -lstdc++"
fi
])

#---------------------------------------
# Checking for libogg for audio support
#---------------------------------------
AC_DEFUN([CHECK_OGG],
#
# Handle user hints
#
[AC_MSG_CHECKING(if oggvorbis is wanted)
AC_ARG_WITH(ogg,
[  --with-ogg=DIR root directory path of libogg installation [defaults to
                    /usr/local or /usr if not found in /usr/local]
  --without-ogg to disable ogg usage completely],
[if test "$withval" != no ; then
  AC_MSG_RESULT(yes)
  LIBOGG_HOME="$withval"
else
  AC_MSG_RESULT(no)
fi], [
AC_MSG_RESULT(yes)
LIBOGG_HOME=/usr/local
if test ! -f "${LIBOGG_HOME}/include/ogg/ogg.h"
then
	LIBOGG_HOME=/usr
fi
])

do_lib_check([ogg], [${LIBOGG_HOME}], [ogg/ogg.h], [oggpack_write], [HAVE_LIBOGG], [C])
do_lib_check([vorbis], [${LIBOGG_HOME}], [vorbis/codec.h], [vorbis_bitrate_init,], [HAVE_LIBVORBIS], [C])
do_lib_check([vorbisfile], [${LIBOGG_HOME}], [vorbis/vorbisfile.h], [ov_open], [HAVE_LIBVORBISFILE], [C])

])

#------------------------------------------------
# Checking for the SDL library for Audio Support
#------------------------------------------------
AC_DEFUN([CHECK_SDL],
#
# Handle user hints
#
[AC_MSG_CHECKING(if libsdl is wanted)
AC_ARG_WITH(libsdl,
[  --with-libsdl=DIR root directory path of libsdl installation [defaults to
                    /usr/local or /usr if not found in /usr/local]
  --without-libsdl to disable lib usage completely],
[if test "$withval" != no ; then
  AC_MSG_RESULT(yes)
  LIBSDL_HOME="$withval"
else
  AC_MSG_RESULT(no)
fi], [
AC_MSG_RESULT(yes)
LIBSDL_HOME=/usr/local
if test ! -f "${LIBSDL_HOME}/include/SDL/SDL_audio.h"
then
        LIBSDL_HOME=/usr
fi
])

do_lib_check([SDL], [${LIBSDL_HOME}], [SDL/SDL_audio.h], [SDL_AudioInit], [HAVE_LIBSDL], [C])

])

#-----------------------------------------------------------
# Checking for libsmpeg, it supports OpenAL for Playing MP3
#-----------------------------------------------------------
AC_DEFUN([CHECK_SMPEG],
#
# Handle user hints
#
[AC_MSG_CHECKING(if libsmpeg is wanted)
AC_ARG_WITH(libsmpeg,
[  --with-libsmpeg=DIR root directory path of libsmpeg installation [defaults to
                    /usr/local or /usr if not found in /usr/local]
  --without-libsmpeg to disable libsmpeg usage completely],
[if test "$withval" != no ; then
  AC_MSG_RESULT(yes)
  LIBSMPEG_HOME="$withval"
else
  AC_MSG_RESULT(no)
fi], [
AC_MSG_RESULT(yes)
LIBSMPEG_HOME=/usr/local
if test ! -f "${LIBSMPEG_HOME}/include/smpeg/smpeg.h"
then
        LIBSMPEG_HOME=/usr
fi
])

do_lib_check([smpeg], [${LIBSMPEG_HOME}], [smpeg.h], [SMPEG_playAudio], [HAVE_LIBSMPEG], [C])

])

#---------------------------------------
# Checking for OpenAL for audio support
#---------------------------------------
AC_DEFUN([CHECK_OPENAL],
#
# Handle user hints
#
[AC_MSG_CHECKING(if libopenal is wanted)
AC_ARG_WITH(libopenal,
[  --with-libopenal=DIR root directory path of libopenal installation [defaults to
                    /usr/local or /usr if not found in /usr/local]
  --without-libopenal to disable libopenal usage completely],
[if test "$withval" != no ; then
  AC_MSG_RESULT(yes)
  LIBOPENAL_HOME="$withval"
else
  AC_MSG_RESULT(no)
fi], [
AC_MSG_RESULT(yes)
LIBOPENAL_HOME=/usr/local
if test ! -f "${LIBOPENAL_HOME}/include/AL/al.h"
then
        LIBOPENAL_HOME=/usr
fi
])


do_lib_check([openal], [${LIBOPENAL_HOME}], [AL/al.h], [alGetSourceiv], [HAVE_LIBOPENAL], [C])
do_lib_check([alut], [${LIBOPENAL_HOME}], [AL/alut.h], [alutGetMajorVersion], [HAVE_LIBALUT], [C])

])

AC_DEFUN([CHECK_VOICE],
#
# Handle user hints
#
[AC_MSG_CHECKING(if jvoiplib is wanted)
AC_ARG_WITH(jvoiplib,
[  --with-jvoiplib=DIR root directory path of jvoiplib installation [defaults to
                    /usr/local or /usr if not found in /usr/local]
  --without-jvoiplib to disable jvoiplib usage completely],
[if test "$withval" != no ; then
  AC_MSG_RESULT(yes)
  JVOIPLIB_HOME="$withval"
else
  AC_MSG_RESULT(no)
fi], [
AC_MSG_RESULT(yes)
JVOIPLIB_HOME=bin
])

#
# Locate jvoiplib, if wanted
#
if test -n "${JVOIPLIB_HOME}"
then
        save_flags([], [-L${JVOIPLIB_HOME}], [])
	AC_LANG_PUSH([C++])
        #  _ZN7JThread13ThreadStartedEv
        AC_CHECK_LIB(jrtp, _ZN9RTPPacket5ClearEv, [jvlib_cv_libjr=yes], [jvlib_cv_libjr=no])
	AC_CHECK_LIB(jthread, _ZN6JMutex4InitEv, [jvlib_cv_libjt=yes], [jvlib_cv_libjt=no])
	AC_CHECK_LIB(jvoip, _Z19JVOIPGetErrorStringi, [jvlib_cv_libjv=yes], [jvlib_cv_libjv=no])
	AC_CHECK_LIB(voip, _Z11dummy_printc, [jvlib_cv_libv=yes], [jvlib_cv_libv=no])
	AC_MSG_CHECKING(jvoiplib in ${JVOIPLIB_HOME})
	
        if test "$jvlib_cv_libjv" = "yes" -a "$jvlib_cv_libjt" = "yes" -a "$jvlib_cv_libjr" = "yes" -a "$jvlib_cv_libjv" = "yes"
        then
                #
                # If all libraries were found, use them
                #
                AC_MSG_RESULT(ok)
                AC_CHECK_LIB(jrtp, _ZN9RTPPacket5ClearEv)
		AC_CHECK_LIB(jthread, _ZN6JMutex4InitEv)
		AC_CHECK_LIB(jvoip, _Z19JVOIPGetErrorStringi)
		AC_CHECK_LIB(voip, _Z11dummy_printc)
		JV_LDFLAGS=" -L../../bin -lvoip -ljvoip -ljthread -ljrtp -lpthread -lstdc++ "
        else
                #
                # If either header or library was not found, revert and bomb
                #
		JV_LDFLAGS=
		fail_and_restore([voip in $JVOIPLIB_HOME])
        fi

	AC_LANG_POP([C++])
fi

])

AC_DEFUN([CHECK_XLIB],
#
# Handle user hints
#
[AC_MSG_CHECKING(if xlib is wanted)
AC_ARG_WITH(xlib,
[  --with-xlib=DIR root directory path of xlib installation [looks in
          /usr/X11 /usr/X11R6 /usr/openwin /opt/X11 /usr/local]
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
		if test ! -f "${XLIB_HOME}/include/X11/Xlib.h"
		then
		        XLIB_HOME=/opt/X11
			if test ! -f "${XLIB_HOME}/include/X11/Xlib.h"
			then
				XLIB_HOME=/usr/local
			fi
		fi
	fi
fi
])

do_lib_check([X11], [${XLIB_HOME}], [X11/Xlib.h X11/Xos.h X11/Xutil.h X11/Xatom.h],
		    [XAllocColorCells], [HAVE_LIBX11], [C])
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

do_lib_check([jpeg], [${JPEG_HOME}], [jpeglib.h jerror.h], [jpeg_destroy_decompress], [HAVE_LIBJPEG], [C])

])

AC_DEFUN([CHECK_PNG],
#
# Handle user hints
#
[AC_MSG_CHECKING(if png is wanted)
AC_ARG_WITH(png,
[  --with-png=DIR root directory path of png installation [defaults to
                    /usr/local or /usr if not found in /usr/local]
  --without-png to disable png usage completely],
[if test "$withval" != no ; then
  AC_MSG_RESULT(yes)
  PNG_HOME="$withval"
else
  AC_MSG_RESULT(no)
fi], [
AC_MSG_RESULT(yes)
PNG_HOME=/usr/local
if test ! -f "${PNG_HOME}/include/png.h"
then
        PNG_HOME=/usr
fi
])

do_lib_check([png], [${PNG_HOME}], [png.h], [png_read_image], [HAVE_LIBPNG], [C])
])

AC_DEFUN([CHECK_PTHREAD],
#
# Handle user hints
#
[AC_MSG_CHECKING(if POSIX threads are wanted)
AC_ARG_WITH(pthread,
[  --with-pthread=DIR root directory path of pthread installation [defaults to
                    /usr/local or /usr if not found in /usr/local]
  --without-pthread to disable pthread usage completely],
[if test "$withval" != no ; then
  AC_MSG_RESULT(yes)
  PTHREAD_HOME="$withval"
else
  AC_MSG_RESULT(no)
fi], [
AC_MSG_RESULT(yes)
PTHREAD_HOME=/usr/local
if test ! -f "${PTHREAD_HOME}/include/pthread.h"
then
        PTHREAD_HOME=/usr
fi
])

do_lib_check([pthread], [${PTHREAD_HOME}], [pthread.h], [pthread_create], [HAVE_LIBPTHREAD], [C])

])


AC_DEFUN([CHECK_OPENSSL],
#
# Handle user hints
#
[AC_MSG_CHECKING(if ssl is wanted)
AC_ARG_WITH(openssl,
[  --with-openssl=DIR root directory path of openssl installation [defaults to
                    /usr/local or /usr if not found in /usr/local]
  --without-openssl to disable openssl usage completely],
[if test "$withval" != no ; then
  AC_MSG_RESULT(yes)
  OPENSSL_HOME="$withval"
else
  AC_MSG_RESULT(no)
fi], [
AC_MSG_RESULT(yes)
OPENSSL_HOME=/usr/local
if test ! -f "${SSL_HOME}/include/openssl/ssl.h"
then
        OPENSSL_HOME=/usr
fi
])

do_lib_check([ssl], [${OPENSSL_HOME}], [openssl/ssl.h], [SSL_library_init], [HAVE_LIBSSL], [C])
do_lib_check([crypto], [${OPENSSL_HOME}], [openssl/bio.h], [BIO_read], [HAVE_LIBCRYPTO], [C])

#        AC_CHECK_HEADER(openssl/bio.h, [openssl_cv_bio_h=yes], [openssl_cv_bio_h=no])
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
        save_flags([-I${OPENGL_HOME}/include], [-lm -L${OPENGL_HOME}/lib], [])
        AC_LANG_PUSH([C])
        AC_CHECK_LIB(GL, glAccum, [opengl_cv_libGL=yes], [opengl_cv_libGL=no])
        AC_CHECK_LIB(GLU, gluBeginCurve, [opengl_cv_libGLU=yes], [opengl_cv_libGLU=no], [-lGL])
        AC_CHECK_HEADER(GL/gl.h, [opengl_cv_gl_h=yes], [opengl_cv_gl_h=no])
        AC_CHECK_HEADER(GL/glx.h, [opengl_cv_glx_h=yes], [opengl_cv_glx_h=no])
        AC_CHECK_HEADER(GL/glu.h, [opengl_cv_glu_h=yes], [opengl_cv_glu_h=no])
	AC_MSG_CHECKING(GL in ${OPENGL_HOME})
        if test "$opengl_cv_libGL" = "yes" -a "$opengl_cv_libGLU" = "yes" -a "$opengl_cv_gl_h" = "yes" -a "$opengl_cv_glx_h" = "yes" -a "$opengl_cv_glu_h" = "yes"
        then
                #
                # If both library and headers were found, use them
                #
                AC_MSG_RESULT(ok)
                AC_CHECK_LIB(GL, glAccum)
                AC_CHECK_LIB(GLU, gluBeginCurve)
	        GL_CFLAGS=" -I${OPENGL_HOME}/include"
	        GL_LDFLAGS=" -L${OPENGL_HOME}/lib"
        else
                #
                # If either header or library was not found, revert and bomb
                #
	        GL_CFLAGS=
	        GL_LDFLAGS=
		fail_and_restore([opengl in $OPENGL_HOME])
        fi
        AC_LANG_POP([C])
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

do_lib_check([iodbc], [${ODBC_HOME}], [sqlext.h], [SQLAllocConnect], [HAVE_LIBIODBC], [C])

if test "$cv_libiodbc" != "yes" ; then
  do_lib_check([odbc], [${ODBC_HOME}], [sqlext.h], [SQLAllocConnect], [HAVE_LIBODBC], [C])
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

AC_DEFUN([CHECK_XFT],
#
# Handle user hints
#
[AC_MSG_CHECKING(if xft is wanted)
AC_ARG_WITH(xft,
[  --with-xft=DIR root directory path of Xft installation [defaults to /usr/local]
  --without-xft to disable xft usage completely],
[if test "$withval" != no ; then
  AC_MSG_RESULT(yes)
  XFT_HOME="$withval"
else
  AC_MSG_RESULT(no)
fi], [
AC_MSG_RESULT(yes)
XFT_HOME=/usr/X11
if test ! -f "${XFT_HOME}/include/X11/Xft/Xft.h"
then
XFT_HOME=/usr/local
if test ! -f "${XFT_HOME}/include/X11/Xft/Xft.h"
then
        XFT_HOME=/usr
fi
fi
])

do_lib_check([Xft], [${XFT_HOME}], [X11/Xft/Xft.h], [XftFontOpenPattern], [HAVE_LIBXFT], [C])

])

AC_DEFUN([AC_CFLAG], [{
	AC_LANG_PUSH([C])
	ac_c_flag_save="$CFLAGS"
	CFLAGS="$CFLAGS $1"
	AC_MSG_CHECKING([[whether $CC supports $1]])
	AC_COMPILE_IFELSE(
		[AC_LANG_PROGRAM([[]])],
		[
			AC_MSG_RESULT([yes])
			m4_if([$3], [], [],
			[
				CFLAGS="$ac_c_flag_save"
				$3
			])
		],
		[
			CFLAGS="$ac_c_flag_save"
			AC_MSG_RESULT([no])
			$2
		])
	AC_LANG_POP([C])
	}])
