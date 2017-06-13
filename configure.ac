AC_INIT([Unicon],[13.0],[jeffery@cs.uidaho.edu], [Unicon], [http://www.unicon.org])

AC_CANONICAL_HOST

# not needed yet
#AC_CANONICAL_BUILD	
#AC_CANONICAL_TARGET

case $host_cpu in
     *armv7*)
        unicon_cpu="arm_32"
        ;;	
     *armv6*)
        unicon_cpu="arm_32"
        ;;
     *armv8*)
        unicon_cpu="arm_64"
        ;;	
     *i386*)
        unicon_cpu="x86_32"
        ;;	
     *i686*)
        unicon_cpu="x86_32"
        ;;	
     *)
        unicon_cpu="$host_cpu"
        ;;
esac

case $host_os in
     *linux*)
        unicon_os="linux"
	AC_DEFINE([UNIX], [1], [Unix platform])
        ;;
     *solaris*)
        unicon_os="solaris"
	AC_DEFINE([UNIX], [1], [Unix platform])
        ;;
     *aix*)
        unicon_os="aix"
	AC_DEFINE([UNIX], [1], [Unix platform])
        ;;
     *bsd*)
       # freebsd for now
        unicon_os="freebsd"
	AC_DEFINE([UNIX], [1], [Unix platform])
        ;;
     *darwin*)
        unicon_os="macos"
	AC_DEFINE([UNIX], [1], [Unix platform])
        ;;
     *cygwin*)
        unicon_os="windows"
        ;;
esac

unicon_host="$unicon_cpu"_"$unicon_os"

echo "##########################################"
echo "Configuring Unicon Host: $unicon_host"
echo "##########################################"

AC_ARG_ENABLE([graphics],
	[AS_HELP_STRING([--disable-graphics], [Build the graphics subsystem])],
			[graphics=no], [graphics=yes])
AC_ARG_ENABLE([graphics3d],
	[AS_HELP_STRING([--disable-graphics3d], [Add 3D graphics support])],
		        [graphics3d=no], [graphics3d=yes])
AC_ARG_ENABLE([concurrency],
	[AS_HELP_STRING([--disable-concurrency], [Build with concurrent thread support])],
			[concurrency=no], [concurrency=yes])
AC_ARG_ENABLE([pattern],
	[AS_HELP_STRING([--disable-pattern], [Build with pattern type support])],
			[pattern=no], [pattern=yes])
AC_ARG_ENABLE([thin],
	[AS_HELP_STRING([--enable-thin], [Do a minimalist build (thin build)])],
			[thin=yes], [thin=no])

#AM_CONDITIONAL([GRAPHICS], [test x$graphics = xyes])

if test "x$graphics" = "xyes"; then
  echo "Building with graphics..."
  make -C config/unix Setup-Graphics name=$unicon_host
else
  echo "Building without graphics..."
  make -C config/unix Setup-NoGraphics name=$unicon_host
fi

AC_GNU_SOURCE

AC_CONFIG_SRCDIR([src/runtime/imain.r])
AC_PROG_CC
AC_PROG_CXX
AC_PROG_CPP
AC_PROG_RANLIB
AC_CHECK_LIB(socket, socket)
AC_CHECK_LIB(nsl, gethostbyname)
AC_HEADER_STDC
AC_CHECK_HEADERS(errno.h netdb.h unistd.h strings.h arpa/inet.h net/errno.h \
		 stdlib.h string.h fcntl.h memory.h sys/file.h sys/resource.h \
                 netinet/in.h sys/errno.h sys/socket.h sys/types.h)

AC_CHECK_SIZEOF(int)
AC_CHECK_SIZEOF(long)
AC_CHECK_SIZEOF(long int)
AC_CHECK_SIZEOF(int *)

AC_WORDS_BIGENDIAN
AC_C_CONST
AC_TYPE_SIZE_T
AC_FUNC_ALLOCA
AC_TYPE_OFF_T
AC_ST_BLKSIZE
AC_CHECK_TYPE(ssize_t, signed)

AC_CHECK_FUNCS(socket bcopy bzero memcpy memset inet_aton inet_pton \
	       snprintf vsprintf rename ftruncate flock fsync \
	       getrlimit setrlimit strerror strerror_r vfork)

AC_REPLACE_FUNCS(getopt)
AC_FUNC_FORK()
AC_CHECK_LIB(dbm,main)
AC_CHECK_LIB(ndbm,main)

AC_SEARCH_LIBS([getaddrinfo],[socket],
	[AC_DEFINE([HAVE_GETADDRINFO], [1], [getaddinfo])])
AC_SEARCH_LIBS([clock_gettime],[rt],
	[AC_DEFINE([HAVE_CLOCK_GETTIME], [1], [gettime])])
AC_SEARCH_LIBS([crypt],[crypt],
	[AC_DEFINE([HAVE_CRYPT], [1], [crypt])])

AC_CHECK_FUNC(getrusage,
	[AC_DEFINE([HAVE_GETRUSAGE], [1], [getrusage])])
AC_CHECK_FUNC(sysconf,
	[AC_DEFINE([HAVE_SYSCONF], [1], [sysconf])])
AC_CHECK_FUNC(profil,
	[AC_DEFINE([HAVE_PROFIL], [1], [profil for profiling loaded programs])])

AC_CHECK_LIB(dl, dlopen)
#AC_CHECK_FUNC(dlopen,
#	[AC_DEFINE([HAVE_DLOPEN], [1], [dlopen for shared object via c functions])])
	
CHECK_FREETYPE()
CHECK_OGG()
CHECK_SDL()
CHECK_SMPEG()
CHECK_OPENAL()
CHECK_VOICE()

CHECK_ZLIB()

if test "$graphics" = yes; then
  CHECK_XLIB()
  CHECK_XFT()
  CHECK_JPEG()
  CHECK_PNG()
  CHECK_OPENGL()
  CHECK_FTGL()
fi

CHECK_ODBC()
CHECK_PTHREAD()
CHECK_OPENSSL()

AC_CHECK_GLOBAL(sys_nerr)
AC_CHECK_GLOBAL(sys_errlist)
AC_VAR_TIMEZONE_EXTERNALS()
AC_STRUCT_TIMEZONE()
AC_CONFIG_FILES([Makedefs:Makedefs.in],)
AC_CONFIG_HEADERS([src/h/auto.h:src/h/auto.in],)
AC_OUTPUT

echo "" 
echo "--------------------------------------------------" 
echo "           Configuration Summary"
echo "--------------------------------------------------" 
echo ""
echo    "* Features"
echo    "|___.* Compression"
/bin/echo -n "|   |--> ZLIB      : "
if test "$zlib_cv_libz"   = yes ; then echo "yes"; else echo "no"; fi
echo    "|"

echo    "|___.* Graphics"
/bin/echo -n "|   |--> XLIB      : "
if test "$xlib_cv_libx" = yes ; then echo "yes"; else echo "no"; fi
/bin/echo -n "|   |--> JPEG      : "
if test "$jpeg_cv_libjpeg" = yes ; then echo "yes"; else echo "no"; fi
/bin/echo -n "|   |--> PNG       : "
if test "$png_cv_libpng"   = yes ; then echo "yes"; else echo "no"; fi
/bin/echo -n "|   |--> XFT       : "
if test "$xft_cv_libxft"   = yes ; then echo "yes"; else echo "no"; fi
/bin/echo -n "|   |--> Freetype  : "
if test "$freetype_cv_libfreetype"   = yes ; then echo "yes"; else echo "no"; fi
echo    "|"

echo    "|___.* 3D Graphics"
/bin/echo -n "|   |--> OpenGL    : "
if test "$opengl_cv_libGL"   = yes ; then echo "yes"; else echo "no"; fi
/bin/echo -n "|   |--> GLU       : "
if test "$opengl_cv_libGLU"  = yes ; then echo "yes"; else echo "no"; fi
/bin/echo -n "|   |--> FTG       : "
if test "$FTGL_cv_libFTGL"   = yes ; then echo "yes"; else echo "no"; fi
echo "|"

echo    "|___.* Concurrency"
/bin/echo -n "|   |--> Threads   : "
if test "$pthread_cv_libpthread"  = yes ; then echo "yes"; else echo "no"; fi 
echo    "|"

echo    "|___. * Audio"
/bin/echo -n "|   |--> OpenAL    : "
if test "$libopenal_cv_libopenal" = yes ; then echo "yes"; else echo "no"; fi
/bin/echo -n "|   |--> alut      : "
if test "$libalut_cv_libalut"     = yes ; then echo "yes"; else echo "no"; fi
echo    "|   |__One group of:"
/bin/echo -n "|   | |> Ogg,vorbis: "
if test "$ogglib_cv_libogg"       = yes; then /bin/echo -n "yes,"; else /bin/echo -n "no,"; fi
if test "$ogglib_cv_libvorbis"    = yes; then echo "yes"; else echo "no"; fi
/bin/echo -n "|   | |> SDL,smpeg : "
if test "$libsdl_cv_libsdl"       = yes; then /bin/echo -n "yes,"; else /bin/echo -n "no,"; fi
if test "$libsmpeg_cv_libsmpeg"   = yes ; then echo "yes"; else echo "no"; fi
echo    "|"

echo    "|___.* VOIP"
/bin/echo -n "|   |--> jvoip     : "
if test "$jvlib_cv_libjv"         = yes ; then echo "yes"; else echo "no"; fi
echo    "|"

echo    "|___.* Database"
/bin/echo -n "|   |--> ODBC      : "
if test "$odbc_cv_libodbc"        = yes ; then echo "yes"; else echo "no"; fi 
echo    "|"

echo    "|___.* Misc"
/bin/echo -n "    |--> SSL       : "
if test "$openssl_cv_libssl"      = yes ; then echo "yes"; else echo "no"; fi 
echo ""

if test "$xlib_cv_libx" = yes ; then
  echo "Think we found X11, you are good to go."
else
  if test "$graphics" = yes; then
     echo "X11 libraries or headers missing; graphics"
     echo "not enabled. "
  fi
fi

echo Remember to add unicon/bin to your path
