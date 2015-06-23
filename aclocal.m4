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
        ZLIB_OLD_CPPFLAGS=$CPPFLAGS
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
#
# Locate freetype, if wanted
#
if test -n "${FREETYPE_HOME}"
then
	FREETYPE_OLD_LDFLAGS=$LDFLAGS
	FREETYPE_OLD_CPPFLAGS=$CPPFLAGS
	LDFLAGS="$LDFLAGS -L${FREETYPE_HOME}/lib64 -L${FREETYPE_HOME}/lib"
        CPPFLAGS="$CPPFLAGS -I${FREETYPE_HOME}/include -I${FREETYPE_HOME}/include/freetype2/freetype -I${FREETYPE_HOME}/include/freetype2"
	echo "$CPPFLAGS"
        AC_LANG_SAVE
        AC_LANG_C
        AC_CHECK_LIB(freetype, FT_Open_Face, [freetype_cv_libfreetype=yes], [freetype_cv_libfreetype=no])
        AC_CHECK_HEADER(ft2build.h, [freetype_cv_ft2build_h=yes], [freetype_cv_ft2build_h=no])
        AC_LANG_RESTORE
        if test "$freetype_cv_libfreetype" = "yes" -a "$freetype_cv_ft2build_h" = "yes"
        then
                #
                # If both library and header were found, use them
                #
                AC_CHECK_LIB(freetype, FT_Open_Face)
                AC_MSG_CHECKING(freetype in ${FREETYPE_HOME})
                AC_MSG_RESULT(ok)
        else
                #
                # If either header or library was not found, revert and bomb
                #
                AC_MSG_CHECKING(freetype in ${FREETYPE_HOME})
		LDFLAGS="$FREETYPE_OLD_LDFLAGS"
		CPPFLAGS="$FREETYPE_OLD_CPPFLAGS"
                AC_MSG_RESULT(failed)
        fi
fi

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

#
# Locate FTGL, if wanted
#
if test -n "${FTGL_HOME}"
then
    FTGL_OLD_LDFLAGS=$LDFLAGS
    FTGL_OLD_CPPFLAGS=$CPPFLAGS
    LDFLAGS="$LDFLAGS -L${FTGL_HOME}/lib64 -L${FTGL_HOME}/lib"
    CPPFLAGS="$CPPFLAGS -I${FTGL_HOME}/include/FTGL"
    AC_PROG_CXX
    #
    # Test whether we found a C++ compiler; for now, only a true g++.  We used
    # to use AC_LANG_CPLUSPLUS, but it dies with a FATAL error if no C++ found
    #
    if test "$CXX" = "g++" -a "$GXX" = "yes"
    then
	AC_CHECK_LIB(ftgl, _ZN6FTFaceD2Ev, [FTGL_cv_libFTGL=yes], [FTGL_cv_libFTGL=no])
	AC_CHECK_HEADER(FTGLExtrdFont.h, [FTGL_cv_FTGL_h=yes], [FTGL_cv_FTGL_h=no])
        if test "$FTGL_cv_libFTGL" = "yes" -a "$FTGL_cv_FTGL_h" = "yes"
        then
                #
                # If both library and header were found, use them.
		# At the moment, this looks deplorably Linux-specific.
		# sort|tail ensures that /usr/lib64 is preferred to /usr/lib
                #
                AC_CHECK_LIB(ftgl, _ZN6FTFaceD2Ev)
                AC_MSG_CHECKING(FTGL in ${FTGL_HOME})
		LIBS="$LIBS -lstdc++"
                AC_MSG_RESULT(ok)
        else
                #
                # If either header or library was not found, revert and bomb
                #
                AC_MSG_CHECKING(FTGL in ${FTGL_HOME})
		LDFLAGS="$FTGL_OLD_LDFLAGS"
		CPPFLAGS="$FTGL_OLD_CPPFLAGS"
                AC_MSG_RESULT(failed)
        fi
    else
	echo "missing or untrusted C++; CXX is $CXX and GXX is $GXX"
    fi
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

#
# Locate libogg, if wanted
#
if test -n "${LIBOGG_HOME}"
then
        LIBOGG_OLD_LDFLAGS=$LDFLAGS
        LIBOGG_OLD_CPPFLAGS=$LDFLAGS
        LDFLAGS="$LDFLAGS -L${LIBOGG_HOME}/lib"
        CPPFLAGS="$CPPFLAGS -I${LIBOGG_HOME}/include/ogg -I${LIBOGG_HOME}/include/vorbis"
        AC_LANG_SAVE
        AC_LANG_C
        AC_CHECK_LIB(ogg, oggpack_write, [ogglib_cv_libogg=yes], [ogglib_cv_libogg=no])
        AC_CHECK_LIB(vorbis, vorbis_bitrate_init, [ogglib_cv_libvorbis=yes], [ogglib_cv_libvorbis=no])
        AC_CHECK_LIB(vorbisfile, ov_open, [libvorbisfile_cv_libvorbisfile=yes], [libvorbisfile_cv_libvorbisfile=no])
        AC_CHECK_HEADER(ogg.h, [ogglib_cv_ogglib_h=yes], [ogglib_cv_ogglib_h=no])
        AC_CHECK_HEADER(vorbisfile.h, [libvorbis_cv_libvorbis_h=yes], [libvorbis_cv_libvorbis_h=no])
        AC_CHECK_HEADER(codec.h, [libvorbis_cv_codec_h=yes], [libvorbis_cv_codec_h=no])
        AC_LANG_RESTORE
        if test "$ogglib_cv_libogg" = "yes" -a "$ogglib_cv_libvorbis" = "yes" -a "$libvorbisfile_cv_libvorbisfile" = "yes" -a "$ogglib_cv_ogglib_h" = "yes" -a "$libvorbis_cv_libvorbis_h" = "yes" -a "$libvorbis_cv_codec_h" = "yes"
        then
                #
                # If all libraries were found, use them
                #
                AC_CHECK_LIB(ogg, oggpack_write)
                AC_CHECK_LIB(vorbis, vorbis_bitrate_init)
                AC_CHECK_LIB(vorbisfile, ov_open)
                AC_MSG_CHECKING(oggvorbis in ${LIBOGG_HOME})
                AC_MSG_RESULT(ok)
        else
                #
                # If either header or library was not found, revert and bomb
                #
                AC_MSG_CHECKING(oggvorbis in ${LIBOGG_HOME})
                AC_MSG_RESULT(failed)
        fi
fi

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

#
# Locate libSDL, if wanted
#
if test -n "${LIBSDL_HOME}"
then
        LIBSDL_OLD_LDFLAGS=$LDFLAGS
        LIBSDL_OLD_CPPFLAGS=$LDFLAGS
        LDFLAGS="$LDFLAGS -L${LIBSDL_HOME}/lib"
        CPPFLAGS="$CPPFLAGS -I${LIBSDL_HOME}/include/SDL"
        AC_LANG_SAVE
        AC_LANG_C
        AC_CHECK_LIB(SDL, SDL_AudioInit, [libsdl_cv_libsdl=yes], [libsdl_cv_libsdl=no])
        AC_CHECK_HEADER(SDL_audio.h, [libsdl_cv_libsdl_h=yes], [libsdl_cv_libsdl_h=no])
        AC_LANG_RESTORE
        if test "$libsdl_cv_libsdl" = "yes" -a "$libsdl_cv_libsdl_h" = "yes"
        then
                #
                # If both library and header were found, use them
                #
                AC_CHECK_LIB(SDL, SDL_AudioInit)
                AC_MSG_CHECKING(libsdl in ${LIBSDL_HOME})
                AC_MSG_RESULT(ok)
        else
                #
                # If either header or library was not found, revert and bomb
                #
                AC_MSG_CHECKING(libsdl in ${LIBSDL_HOME})
                LDFLAGS="$LIBSDL_OLD_LDFLAGS"
                CPPFLAGS="$LIBSDL_OLD_CPPFLAGS"
                AC_MSG_RESULT(failed)
        fi
fi
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

#
# Locate libsmpeg, if wanted
#
if test -n "${LIBSMPEG_HOME}"
then
        LIBSMPEG_OLD_LDFLAGS=$LDFLAGS
        LIBSMPEG_OLD_CPPFLAGS=$LDFLAGS
        LDFLAGS="$LDFLAGS -L${LIBSMPEG_HOME}/lib"
        CPPFLAGS="$CPPFLAGS -I${LIBSMPEG_HOME}/include/smpeg"
        AC_LANG_SAVE
        AC_LANG_C
        AC_CHECK_LIB(smpeg, SMPEG_playAudio, [libsmpeg_cv_libsmpeg=yes], [libsmpeg_cv_libsmpeg=no])
        AC_CHECK_HEADER(smpeg.h, [libsmpeg_cv_libsmpeg_h=yes], [libsmpeg_cv_libsmpeg_h=no])
        AC_LANG_RESTORE
        if test "$libsmpeg_cv_libsmpeg" = "yes" -a "$libsmpeg_cv_libsmpeg_h" = "yes"
        then
                #
                # If both library and header were found, use them
                #
                AC_CHECK_LIB(smpeg, SMPEG_playAudio)
                AC_MSG_CHECKING(libsmpeg in ${LIBSMPEG_HOME})
                AC_MSG_RESULT(ok)
        else
                #
                # If either header or library was not found, revert and bomb
                #
                AC_MSG_CHECKING(libsmpeg in ${LIBSMPEG_HOME})
                LDFLAGS="$LIBSMPEG_OLD_LDFLAGS"
                CPPFLAGS="$LIBSMPEG_OLD_CPPFLAGS"
                AC_MSG_RESULT(failed)
        fi
fi
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

#
# Locate libopenal, if wanted
#
if test -n "${LIBOPENAL_HOME}"
then
        LIBOPENAL_OLD_LDFLAGS=$LDFLAGS
        LIBOPENAL_OLD_CPPFLAGS=$LDFLAGS
        LDFLAGS="$LDFLAGS -L${LIBOPENAL_HOME}/lib"
        CPPFLAGS="$CPPFLAGS -I${LIBOPENAL_HOME}/include/AL"
        AC_LANG_SAVE
        AC_LANG_C
        AC_CHECK_LIB(openal, alGetSourceiv, [libopenal_cv_libopenal=yes], [libopenal_cv_libopenal=no])
        AC_CHECK_HEADER(al.h, [libopenal_cv_libopenal_h=yes], [libopenal_cv_libopenal_h=no])
        AC_CHECK_LIB(alut, alutGetMajorVersion, [libalut_cv_libalut=yes], [libalut_cv_libalut=no], [-lopenal])
        AC_CHECK_HEADER(alut.h, [libalut_cv_libalut_h=yes], [libalut_cv_libalut_h=no])
        AC_LANG_RESTORE
        if test "$libopenal_cv_libopenal" = "yes" -a "$libopenal_cv_libopenal_h" = "yes" -a "$libalut_cv_libalut" = "yes" -a "$libalut_cv_libalut_h" = "yes"
        then
                #
                # If both library and header were found, use them
                #
                AC_CHECK_LIB(openal, alGetSourceiv)
                AC_CHECK_LIB(alut, alutGetMajorVersion)
                AC_MSG_CHECKING(libopenal in ${LIBOPENAL_HOME})
                AC_MSG_RESULT(ok)
        else
                #
                # If either header or library was not found, revert and bomb
                #
                AC_MSG_CHECKING(libopenal in ${LIBOPENAL_HOME})
                LDFLAGS="$LIBOPENAL_OLD_LDFLAGS"
                CPPFLAGS="$LIBOPENAL_OLD_CPPFLAGS"
                AC_MSG_RESULT(failed)
        fi
fi
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
        JVOIPLIB_OLD_LDFLAGS=$LDFLAGS
        JVOIPLIB_OLD_CPPFLAGS=$LDFLAGS
        LDFLAGS="$LDFLAGS -L${JVOIPLIB_HOME}"
	AC_PROG_CXX
    if test "$CXX" = "g++" -a "$GXX" = "yes"
    then
        AC_LANG_SAVE
        AC_LANG_CPLUSPLUS
        #  _ZN7JThread13ThreadStartedEv
        AC_CHECK_LIB(jrtp, _ZN9RTPPacket5ClearEv, [jvlib_cv_libjr=yes], [jvlib_cv_libjr=no])
	AC_CHECK_LIB(jthread, _ZN6JMutex4InitEv, [jvlib_cv_libjt=yes], [jvlib_cv_libjt=no])
	AC_CHECK_LIB(jvoip, _Z19JVOIPGetErrorStringi, [jvlib_cv_libjv=yes], [jvlib_cv_libjv=no])
	AC_CHECK_LIB(voip, _Z11dummy_printc, [jvlib_cv_libv=yes], [jvlib_cv_libv=no])

        AC_LANG_RESTORE
        if test "$jvlib_cv_libjv" = "yes" -a "$jvlib_cv_libjt" = "yes" -a "$jvlib_cv_libjr" = "yes" -a "$jvlib_cv_libjv" = "yes"
        then
                #
                # If all libraries were found, use them
                #
	        AC_LANG_SAVE
	        AC_LANG_CPLUSPLUS
                AC_CHECK_LIB(jrtp, _ZN9RTPPacket5ClearEv)
		AC_CHECK_LIB(jthread, _ZN6JMutex4InitEv)
		AC_CHECK_LIB(jvoip, _Z19JVOIPGetErrorStringi)
		AC_CHECK_LIB(voip, _Z11dummy_printc)
	        AC_LANG_RESTORE
                AC_MSG_CHECKING(jvoiplib in ${JVOIPLIB_HOME})
		JV_LDFLAGS=" -L../../bin -lvoip -ljvoip -ljthread -ljrtp -lpthread -lstdc++ "
		AC_SUBST(JV_LDFLAGS)
                AC_MSG_RESULT(ok)
        else
                #
                # If either header or library was not found, revert and bomb
                #
                AC_MSG_CHECKING(jvoiplib in ${JVOIPLIB_HOME})
		JV_LDFLAGS=
		AC_SUBST(JV_LDFLAGS)
                AC_MSG_RESULT(failed)
        fi
    fi
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
        AC_CHECK_HEADERS(X11/Xlib.h, [xlib_cv_xlib_h=yes], [xlib_cv_xlib_h=no])
        AC_CHECK_HEADER(X11/Xos.h, [xlib_cv_xos_h=yes], [xlib_cv_xos_h=no])
        AC_CHECK_HEADER(X11/Xutil.h, [xlib_cv_xutil_h=yes], [xlib_cv_xutil_h=no],[#ifdef HAVE_X11_XLIB_H
#include <X11/Xlib.h>
#endif])
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

#
# Locate PNG, if wanted
#
if test -n "${PNG_HOME}"
then
        PNG_OLD_LDFLAGS=$LDFLAGS
        PNG_OLD_CPPFLAGS=$LDFLAGS
        LDFLAGS="$LDFLAGS -L${PNG_HOME}/lib"
        CPPFLAGS="$CPPFLAGS -I${PNG_HOME}/include"
        AC_LANG_SAVE
        AC_LANG_C
	AC_CHECK_LIB(png, png_read_image, [png_cv_libpng=yes], [png_cv_libpng=no])
        AC_CHECK_HEADER(png.h, [png_cv_png_h=yes], [png_cv_png_h=no])
#	AC_CHECK_HEADER(pngconf.h, [png_cv_pngconf_h=yes], [png_cv_pngconf_h=no])
#	AC_CHECK_HEADER(zlib.h, [png_cv_zlib_h=yes], [png_cv_zlib_h=no])
#	AC_CHECK_HEADER(zconf.h, [png_cv_zconf_h=yes], [png_cv_zconf_h=no])
        AC_LANG_RESTORE
	if test "$png_cv_libpng" = "yes" -a "$png_cv_png_h" = "yes" 
	   # -a "$png_cv_pngconf_h" = "yes" -a "$png_cv_zlib_h" = "yes" -a "$png_cv_zconf_h" = "yes"
        then
                #
                # If both library and headers were found, use them
                #
		AC_CHECK_LIB(png, png_read_image)
                AC_MSG_CHECKING(png in ${PNG_HOME})
                AC_MSG_RESULT(ok)
        else
                #
                # If either header or library was not found, revert and bomb
                #
                AC_MSG_CHECKING(png in ${PNG_HOME})
                LDFLAGS="$PNG_OLD_LDFLAGS"
                CPPFLAGS="$PNG_OLD_CPPFLAGS"
                AC_MSG_RESULT(failed)
        fi
fi
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

#
# Locate pthread, if wanted
#
if test -n "${PTHREAD_HOME}"
then
        PTHREAD_OLD_LDFLAGS=$LDFLAGS
        PTHREAD_OLD_CPPFLAGS=$LDFLAGS
        LDFLAGS="$LDFLAGS -L${PTHREAD_HOME}/lib"
        CPPFLAGS="$CPPFLAGS -I${PTHREAD_HOME}/include"
        AC_LANG_SAVE
        AC_LANG_C
	AC_CHECK_LIB(pthread, pthread_create, [pthread_cv_libpthread=yes], [pthread_cv_libpthread=no])
        AC_CHECK_HEADER(pthread.h, [pthread_cv_pthread_h=yes], [pthread_cv_pthread_h=no])
        AC_LANG_RESTORE
	if test "$pthread_cv_libpthread" = "yes" -a "$pthread_cv_pthread_h" = "yes"
        then
                #
                # If both library and headers were found, use them
                #
		AC_CHECK_LIB(pthread, pthread_create)
                AC_MSG_CHECKING(pthread in ${PTHREAD_HOME})
                AC_MSG_RESULT(ok)
        else
                #
                # If either header or library was not found, revert and bomb
                #
                AC_MSG_CHECKING(pthread in ${PTHREAD_HOME})
                LDFLAGS="$PTHREAD_OLD_LDFLAGS"
                CPPFLAGS="$PTHREAD_OLD_CPPFLAGS"
                AC_MSG_RESULT(failed)
        fi
fi
])


AC_DEFUN([CHECK_OPENSSL],
#
# Handle user hints
#
[AC_MSG_CHECKING(if OPENSSL is wanted)
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
if test ! -f "${SSL_HOME}/include/openssl/bio.h"
then
        OPENSSL_HOME=/usr
fi
])

#
# Locate openssl, if wanted
#
if test -n "${OPENSSL_HOME}"
then
        OPENSSL_OLD_LDFLAGS=$LDFLAGS
        OPENSSL_OLD_CPPFLAGS=$LDFLAGS
        LDFLAGS="$LDFLAGS -L${OPENSSL_HOME}/lib"
        CPPFLAGS="$CPPFLAGS -I${OPENSSL_HOME}/include"
        AC_LANG_SAVE
        AC_LANG_C
	AC_CHECK_LIB(ssl, SSL_library_init, [openssl_cv_libssl=yes], [openssl_cv_libssl=no])
	AC_CHECK_LIB(crypto, BIO_read, [openssl_cv_libcrypto=yes], [openssl_cv_libcrypto=no])
        AC_CHECK_HEADER(openssl/bio.h, [openssl_cv_bio_h=yes], [openssl_cv_bio_h=no])
        AC_LANG_RESTORE
	if test "$openssl_cv_libssl" = "yes" -a "$openssl_cv_bio_h" = "yes" -a "$openssl_cv_libcrypto" = "yes"
        then
                #
                # If libraries and headers were found, use them
                #
		AC_CHECK_LIB(ssl, SSL_library_init)
		AC_CHECK_LIB(crypto, BIO_read)
                AC_MSG_CHECKING(ssl in ${OPENSSL_HOME})
                AC_MSG_RESULT(ok)
        else
                #
                # If either header or library was not found, revert and bomb
                #
                AC_MSG_CHECKING(ssl in ${OPENSSL_HOME})
                LDFLAGS="$OPENSSL_OLD_LDFLAGS"
                CPPFLAGS="$OPENSSL_OLD_CPPFLAGS"
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
        LDFLAGS="$LDFLAGS -L${ODBC_HOME}/lib -L${ODBC_HOME}/lib64"
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
#
# Locate XFT, if wanted
#
if test -n "${XFT_HOME}"
then
	XFT_OLD_LDFLAGS=$LDFLAGS
	XFT_OLD_CPPFLAGS=$CPPFLAGS
	LDFLAGS="$LDFLAGS -L${XFT_HOME}/lib64 -L${XFT_HOME}/lib"
	CPPFLAGS="$CPPFLAGS -I${XFT_HOME}/include/X11/Xft -I${XFT_HOME}/include/freetype2"
        AC_LANG_SAVE
        AC_LANG_C
        AC_CHECK_LIB(Xft, XftFontOpenPattern, [xft_cv_libxft=yes], [xft_cv_libxft=no])
        AC_CHECK_HEADER(Xft.h, [xft_cv_xft_h=yes], [xft_cv_xft_h=no])
        AC_LANG_RESTORE
        if test "$xft_cv_libxft" = "yes" -a "$xft_cv_xft_h" = "yes"
        then
                #
                # If both library and header were found, use them
                #
                AC_CHECK_LIB(Xft, main)
                AC_MSG_CHECKING(XFT in ${XFT_HOME})
                AC_MSG_RESULT(ok)
        else
                #
                # If either header or library was not found, revert and bomb
                #
                AC_MSG_CHECKING(XFT in ${XFT_HOME})
		LDFLAGS="$XFT_OLD_LDFLAGS"
		CPPFLAGS="$XFT_OLD_CPPFLAGS"
                AC_MSG_RESULT(failed)
        fi
fi

])

AC_DEFUN([AC_FAKESTUFF],
if test -f "thin"
then
	echo "doing FAKESTUFF"
	JV_LDFLAGS=
	AC_SUBST(JV_LDFLAGS)
	GL_LDFLAGS=
	AC_SUBST(GL_LDFLAGS)
	GL_CFLAGS=
	AC_SUBST(GL_CFLAGS)
fi
)
