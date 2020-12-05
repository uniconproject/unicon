

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
if test  x$2 != "x"
then
	save_flags([-I$2/include -I$2], [-L$2/lib], [])
else
	save_flags([], [], [])
fi
        AC_LANG_PUSH([$6])
	# If we have mulltiple headers, any missing one will set this to no
	cv_libthislib_h=yes
        AC_CHECK_HEADERS([$3], [], [cv_libthislib_h=no], [])
	if test x$cv_libthislib_h != xno ;  then
	  AC_SEARCH_LIBS([$4], [$1],
	     [cv_lib$1=yes
	      if test -n $5 ; then
	        AC_DEFINE([$5], [1], [Define to 1 if you lib $1])
	      fi
	     ],
	     [cv_lib$1=no
	      fail_and_restore([$1 in ($2)])], [$7])
        else
          fail_and_restore([$1 in ($2)])
	fi
	AC_LANG_POP([$6])
])

AC_DEFUN([do_arg_with],
[
  AC_MSG_CHECKING(if $1 is wanted)
  AC_ARG_WITH([$1],
   [AS_HELP_STRING([--with-$1[[=DIR]]], [Use $1 package (DIR: custom library path)])],
   [if test x$withval != xno ; then
      AC_MSG_RESULT(yes)
      if test x$withval != xyes ; then
         $1_HOME="$withval"
      fi
    else
      AC_MSG_RESULT(no)
    fi],
   [ AC_MSG_RESULT(yes)])

])

AC_DEFUN([CHECK_ZLIB],
[
  do_arg_with([zlib])
  if test "x$with_zlib" != "xno"; then
     do_lib_check([z], [${zlib_HOME}], [zlib.h], [inflateEnd], [HAVE_LIBZ], [C])
  fi
])

AC_DEFUN([CHECK_FREETYPE],
[
do_arg_with([freetype])


if test "x$freetype_HOME" = "x" ; then
   FREETYPE_HOME=/usr/X11
   if test ! -f "${FREETYPE_HOME}/include/freetype2/freetype/freetype.h" ; then
      FREETYPE_HOME=/usr/local
      if test ! -f "${FREETYPE_HOME}/include/freetype2/freetype/freetype.h" ; then
        FREETYPE_HOME=/usr
      fi
   fi
#   AC_PATH_PROG(FREETYPE_CONFIG,freetype-config)   
else
   FREETYPE_HOME=$freetype_HOME
#   AC_PATH_PROG(FREETYPE_CONFIG,freetype-config,,[$freetype_HOME/bin:$PATH])
fi

if test "x$with_freetype" != "xno"; then
  ftsave_CPPFLAGS=$CPPFLAGS
#  if test -n "$FREETYPE_CONFIG"; then
#     FREETYPE_CFLAGS=`$FREETYPE_CONFIG --cflags`
#     FREETYPE_LIBS=`$FREETYPE_CONFIG --libs`
#     echo $FREETYPE_CONFIG reports cflags=$FREETYPE_CFLAGS  libs=$FREETYPE_LIBS
#  else
     FREETYPE_CFLAGS="-I$FREETYPE_HOME/include/freetype2"
#  fi

  CPPFLAGS="$CPPFLAGS $FREETYPE_CFLAGS "

  do_lib_check([freetype], [${freetype_HOME}], [freetype/fttypes.h],
			 [FT_Open_Face], [HAVE_LIBFREETYPE], [C])
   if test "x$cv_freetype" = "xno" ; then
      CPPFLAGS=$ftsave_CPPFLAGS
   fi
fi
])


AC_DEFUN([CHECK_FTGL],
[
do_arg_with([ftgl])
if test "x$with_ftgl" != "xno"; then
   do_lib_check([ftgl], [${ftgl_HOME}], [FTGL/FTGLExtrdFont.h], [_ZN6FTFaceD2Ev], [HAVE_LIBFTGL], [C++])
   if test "x$cv_libftgl" = "xyes" ; then
      LIBS="$LIBS -lstdc++"
   fi
fi
])

#---------------------------------------
# Checking for libogg for audio support
#---------------------------------------
AC_DEFUN([CHECK_OGG],
[
do_arg_with([ogg])
if test "x$with_ogg" != "xno"; then
   do_lib_check([ogg], [${ogg_HOME}], [ogg/ogg.h], [oggpack_write], [HAVE_LIBOGG], [C])
   do_lib_check([vorbis], [${ogg_HOME}], [vorbis/codec.h], [vorbis_info_init], [HAVE_LIBVORBIS], [C])
   do_lib_check([vorbisfile], [${ogg_HOME}], [vorbis/vorbisfile.h], [ov_open], [HAVE_LIBVORBISFILE], [C])
fi
])

#------------------------------------------------
# Checking for the SDL library for Audio Support
#------------------------------------------------
AC_DEFUN([CHECK_SDL],
[
do_arg_with([SDL])
if test "x$with_SDL" != "xno"; then
   do_lib_check([SDL], [${SDL_HOME}], [SDL/SDL_audio.h], [SDL_AudioInit], [HAVE_LIBSDL], [C])
fi
])

#-----------------------------------------------------------
# Checking for libsmpeg, it supports OpenAL for Playing MP3
#-----------------------------------------------------------
AC_DEFUN([CHECK_SMPEG],
[
do_arg_with([smpeg])
if test "x$with_smpeg" != "xno"; then
   do_lib_check([smpeg], [${smpeg_HOME}], [smpeg.h], [SMPEG_playAudio], [HAVE_LIBSMPEG], [C])
fi
])

#---------------------------------------
# Checking for OpenAL for audio support
#---------------------------------------
AC_DEFUN([CHECK_OPENAL],
[
do_arg_with([openal])
if test "x$with_openal" != "xno"; then
  do_lib_check([openal], [${openal_HOME}], [AL/al.h], [alGetSourceiv], [HAVE_LIBOPENAL], [C])
  do_lib_check([alut],   [${openal_HOME}], [AL/alut.h], [alutGetMajorVersion], [HAVE_LIBALUT], [C])
fi
])

AC_DEFUN([CHECK_VOICE],
[
do_arg_with([jvoip])
#JVOIPLIB_HOME=bin
save_flags([], [-L${JVOIPLIB_HOME}], [])
AC_LANG_PUSH([C++])
#  _ZN7JThread13ThreadStartedEv
AC_CHECK_LIB(jrtp, _ZN9RTPPacket5ClearEv, [cv_libjrtp=yes], [cv_libjrtp=no])
AC_CHECK_LIB(jthread, _ZN6JMutex4InitEv, [cv_libjthread=yes], [cv_libjthread=no])
AC_CHECK_LIB(jvoip, _Z19JVOIPGetErrorStringi, [cv_libjvoip=yes], [cv_libjvoip=no])
AC_CHECK_LIB(voip, _Z11dummy_printc, [cv_libvoip=yes], [cv_libvoip=no])
#AC_MSG_CHECKING(jvoiplib in ${JVOIPLIB_HOME})

if test "x$cv_libjvoip" = "xyes" -a "x$cv_libjthread" = "xyes" -a "x$cv_libjrtp" = "xyes" -a "x$cv_libjvoip" = "xyes"
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

])


AC_DEFUN([CHECK_XLIB],
[
do_arg_with([xlib])

if test "x$with_xlib" != "xno"; then
  if test "x$xlib_HOME" = "x" ; then
    XLIB_HOME=/usr/X11
    if test ! -f "${XLIB_HOME}/include/X11/Xlib.h" ; then
       XLIB_HOME=/usr/X11R6
       if test ! -f "${XLIB_HOME}/include/X11/Xlib.h" ; then
          XLIB_HOME=/usr/openwin
	  if test ! -f "${XLIB_HOME}/include/X11/Xlib.h" ; then
	     XLIB_HOME=/opt/X11
	     if test ! -f "${XLIB_HOME}/include/X11/Xlib.h" ; then
	        XLIB_HOME=/usr/local
             fi
	  fi
       fi
    fi
  else
    XLIB_HOME=$xlib_HOME
  fi

  do_lib_check([X11], [${XLIB_HOME}], [X11/Xlib.h X11/Xos.h X11/Xutil.h X11/Xatom.h],
		    [XAllocColorCells], [HAVE_LIBX11], [C])
fi
])


AC_DEFUN([CHECK_JPEG],
[
do_arg_with([jpeg])
if test "x$with_jpeg" != "xno"; then
  do_lib_check([jpeg], [${jpeg_HOME}], [jpeglib.h jerror.h], [jpeg_destroy_decompress], [HAVE_LIBJPEG], [C])
fi
])

AC_DEFUN([CHECK_PNG],
[
do_arg_with([png])
if test "x$with_png" != "xno"; then
   do_lib_check([png], [${png_HOME}], [png.h], [png_read_image], [HAVE_LIBPNG], [C])
fi
])

AC_DEFUN([CHECK_PTHREAD],
[
  do_arg_with([pthread])
  if test "x$with_pthread" != "xno"; then
    do_lib_check([pthread], [${pthread_HOME}], [pthread.h], [pthread_create], [HAVE_LIBPTHREAD], [C])
  fi
])


AC_DEFUN([CHECK_OPENSSL],
[
do_arg_with([ssl])
if test "x$with_ssl" != "xno"; then
  do_lib_check([crypto], [${ssl_HOME}], [openssl/bio.h], [BIO_read], [HAVE_LIBCRYPTO], [C])
  do_lib_check([ssl], [${ssl_HOME}], [openssl/ssl.h], [SSL_library_init], [HAVE_LIBSSL], [C])
  if test "x$cv_libssl" != "xyes" ; then
    do_lib_check([ssl], [${ssl_HOME}], [openssl/ssl.h], [OPENSSL_init_ssl], [HAVE_LIBSSL], [C])
  fi
fi
#        AC_CHECK_HEADER(openssl/bio.h, [openssl_cv_bio_h=yes], [openssl_cv_bio_h=no])
])


AC_DEFUN([CHECK_OPENGL],
[

do_arg_with([opengl])

if test "x$with_opengl" != "xno"; then

  if test  "x$opengl_HOME" != "x" ; then
    save_flags([-I${opengl_HOME}], [-L${opengl_HOME}/lib], [])
  else
    save_flags([], [], [])
  fi
  
  AC_LANG_PUSH([C])

  AC_CHECK_HEADERS([GL/gl.h GL/glu.h], [], [cv_opengl_h=no])
  AC_CHECK_LIB(GL, glAccum, [cv_libGL=yes], [cv_libGL=no])
  AC_CHECK_LIB(GLU, gluBeginCurve, [cv_libGLU=yes], [cv_libGLU=no], [-lGL])

  if test "x$cv_libX11" = "xyes" ; then
     AC_CHECK_HEADER(GL/glx.h, [cv_glx_h=yes], [cv_glx_h=no])
  else
    cv_glx_h="yes"
  fi

  if test "x$cv_libGL" = "xyes" -a "x$cv_libGLU" = "xyes" -a "x$cv_opengl_h" != "xno" -a "x$cv_glx_h" = "xyes" ; then

       if test  "x$opengl_HOME" != "x" ; then
	        GL_CFLAGS=" -I${opengl_HOME}/include"
	        GL_LDFLAGS=" -L${opengl_HOME}/lib"
       else
	        GL_CFLAGS=
	        GL_LDFLAGS=
       fi
  		AC_CHECK_LIB(m, cos)
  		AC_CHECK_LIB(GL, glAccum)
  		AC_CHECK_LIB(GLU, gluBeginCurve)
		cv_opengl=yes
  else
	        GL_CFLAGS=
	        GL_LDFLAGS=
		cv_opengl=no
		fail_and_restore([OpenGL])
  fi
  AC_LANG_POP([C])
fi
])

AC_DEFUN([CHECK_ODBC],
[
do_arg_with([odbc])
if test "x$with_odbc" != "xno"; then
  do_lib_check([iodbc], [${odbc_HOME}], [sqlext.h], [SQLAllocConnect], [HAVE_LIBIODBC], [C])

  if test "x$cv_libiodbc" != "xyes" ; then
    do_lib_check([odbc], [${odbc_HOME}], [sqlext.h], [SQLConnect], [HAVE_LIBODBC], [C])
  fi
fi
])

AC_DEFUN([CHECK_ODBC32],
[
do_arg_with([odbc])
if test "x$with_odbc" != "xno"; then

if test  x${odbc_HOME} != "x"
then
	save_flags([-I${odbc_HOME}/include -I${odbc_HOME}], [-L${odbc_HOME}/lib], [])
else
	save_flags([], [], [])
fi
        AC_LANG_PUSH([C])
	# If we have mulltiple headers, any missing one will set this to no
	cv_libodbc32_h=yes
	AC_CHECK_HEADERS([sqlext.h], [], [cv_libodbc32_h=no],
        [[
          #include <windows.h>
    	  #include <sqlext.h>
        ]])

	if test x$cv_libodbc32_h != xno ;  then
	  AC_SEARCH_LIBS([SQLConnect], [odbc32],
	     [cv_libodbc=yes
	      AC_DEFINE([HAVE_LIBODBC], [1], [Define to 1 if you lib odbc])
	     ],
	     [cv_libodbc=no
	       fail_and_restore([odbc32 in (${odbc_HOME})])
	     ],
	     [])
        else
          fail_and_restore([odbc32 in (${odbc_HOME})])
        fi
	AC_LANG_POP([C])
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
[
do_arg_with([Xft])
if test "x$with_Xft" != "xno"; then
  do_lib_check([Xft], [${Xft_HOME}], [X11/Xft/Xft.h], [XftFontOpenPattern], [HAVE_LIBXFT], [C])
fi
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
