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
	AC_DEFINE([SOLARIS], [1], [Solaris OS])
	AC_DEFINE([SUN], [1], [Sun platform])
        ;;
     *aix*)
        unicon_os="aix"
	AC_DEFINE([UNIX], [1], [Unix platform])
        ;;
     *bsd*)
       # freebsd for now
        unicon_os="freebsd"
	AC_DEFINE([UNIX], [1], [Unix platform])
	AC_DEFINE([FreeBSD], [1], [FreeBSD OS])
        ;;
     *darwin*)
        unicon_os="macos"
	AC_DEFINE([UNIX], [1], [Unix platform])
	AC_DEFINE([MacOS], [1], [Mac OS])
        ;;
     *cygwin*)
        unicon_os="windows"
        ;;
     *mingw*)
        unicon_os="windows"
        ;;
esac

unicon_host="$unicon_cpu"_"$unicon_os"

echo "##########################################"
echo "Configuring Unicon Host: $unicon_host"
echo "##########################################"

AC_ARG_ENABLE([graphics],
	[AS_HELP_STRING([--disable-graphics], [No graphics subsystem])],
			[graphics=no], [graphics=yes])
AC_ARG_ENABLE([graphics3d],
	[AS_HELP_STRING([--disable-graphics3d], [No 3D graphics support])],
		        [graphics3d=no], [graphics3d=yes])
AC_ARG_ENABLE([concurrency],
	[AS_HELP_STRING([--disable-concurrency], [No concurrent thread support])],
			[concurrency=no], [concurrency=yes])
AC_ARG_ENABLE([pattern],
	[AS_HELP_STRING([--disable-pattern], [No pattern type support])],
			[pattern=no], [pattern=yes])
AC_ARG_ENABLE([database],
	[AS_HELP_STRING([--disable-database], [No database support])],
			[database=no], [database=yes])
AC_ARG_ENABLE([ssl],
	[AS_HELP_STRING([--disable-ssl], [No SSL support])],
			[ssl=no], [ssl=yes])
AC_ARG_ENABLE([audio],
	[AS_HELP_STRING([--disable-audio], [No audio support])],
			[audio=no], [audio=yes])
AC_ARG_ENABLE([voip],
	[AS_HELP_STRING([--disable-voip], [No VOIP support])],
			[voip=no], [voip=yes])
AC_ARG_ENABLE([plugins],
	[AS_HELP_STRING([--disable-plugins], [No loadfunc or plugins support])],
			[plugins=no], [plugins=yes])

AC_ARG_ENABLE([ovld],
	[AS_HELP_STRING([--enable-ovld], [enable operator overloading])],
			[ovld=yes], [ovld=no])

AC_ARG_ENABLE([iconc],
	[AS_HELP_STRING([--enable-iconc], [Build Unicon Compiler (Iconc/Uniconc)])],
			[iconc=yes], [iconc=no])
			
AC_ARG_ENABLE([verbosebuild],
	[AS_HELP_STRING([--enable-verbosebuild], [Show full CC build lines with all compiler arguments])],
			[verbosebuild=yes], [verbosebuild=no])

AC_ARG_ENABLE([thin],
	[AS_HELP_STRING([--enable-thin], [Do a minimalist build disabling non critical features])],
			[thin=yes], [thin=no])
AC_ARG_ENABLE([debug],
	[AS_HELP_STRING([--enable-debug], [Add debugging symbols])],
			[debug=yes], [debug=no])
AC_ARG_ENABLE([devmode],
	[AS_HELP_STRING([--enable-devmode], [Developper mode: turn on warnings and debugging options])],
			[devmode=yes], [devmode=no])
			
# Save flags 
CFLAGS="${CFLAGS:-}"
orig_cflags="$CFLAGS"
AC_LANG([C])
AC_USE_SYSTEM_EXTENSIONS
# Try CC 99, or better
ac_cc="$CC"
CC="${CC% -std=c99}"

AC_CFLAG([-std=gnu11], [CC="$ac_cc"], [CC="$CC -std=gnu11"])

if test x"$verbosebuild" = x"yes" ; then
  CMNT="#"
  SLNT=
  DASHS=
else
  CMNT=
  SLNT="@"
  DASHS="-s"
fi

if test x"$devmode" = x"yes" ; then
  debug=yes
fi

# honor custom flags
if test "z$orig_cflags" = "z"; then
  if test x"$debug" = x"yes" ; then
     AC_CFLAG([-g])
     AC_CFLAG([-O0])
  else
    AC_CFLAG([-O2], [
    AC_CFLAG([-Os])
    ])
  fi
fi

# We always want these CFLAGS
AC_CFLAG([-fno-omit-frame-pointer])
AC_CFLAG([-fno-strict-aliasing])

if test x"$devmode" = x"yes" ; then
  AC_CFLAG([-Wall])
#  AC_CFLAG([-Wmissing-prototypes])
#  AC_CFLAG([-Wmissing-declarations])
fi

if test x"${enable_werror}" = x"yes" ; then
  WERROR="-Werror"
fi

# OS specific flags go here
case $unicon_host in
     *linux*)
      AC_CFLAG([-fno-unit-at-a-time])
      LDFLAGS="$LDFLAGS -rdynamic "
      RLINK="-rdynamic -Wl,-E "
      RLIBS="-lnsl -lcrypt "
      CFDYN="-fPIC -shared "
        ;;
     *solaris*)
	;;
     *aix*)
        ;;
     *bsd*)
        ;;
     *macos*)
       AC_CFLAG([-Wno-parentheses-equality])
       CFDYN="-Xlinker -dylib -Xlinker -undefined -Xlinker dynamic_lookup -fpic"
	;;
     *windows*)
       EXE=".exe"
        ;;
esac

AC_SUBST(EXE)
AC_SUBST(unicon_os)
AC_SUBST(WERROR)
AC_SUBST(CC)
AC_SUBST(RLINK)
AC_SUBST(RLIBS)
AC_SUBST(CFDYN)

# Do we have rdynamic?
#AC_LANG_PUSH(C)
#ac_ld_flag_save="$LDFLAGS"
#LDFLAGS="$LDFLAGS -rdynamic"
#AC_MSG_CHECKING([[whether linker supports -rdynamic]])
#AC_LINK_IFELSE(
#	[AC_LANG_PROGRAM([[]])],
#	[AC_MSG_RESULT([yes])],
#	[
#		LDFLAGS="$ac_ld_flag_save"
#		AC_MSG_RESULT([no])
#	])
#AC_LANG_POP(C)


if test "x$thin" = "xyes"; then
graphics=no
graphics3d=no
concurrency=no
pattern=no
audio=no
database=no
voip=no
plugins=no
database=no
ssl=no

  AC_DEFINE([NoMultiThread], [1], [No MultiThread])
  # what else we need to disable?
fi

if test "x$concurrent" = "xno"; then
  AC_DEFINE([NoConcurrent], [1], [No Concurrency])
fi

if test "x$pattern" = "xno"; then
  AC_DEFINE([NoPattern], [1], [No PatternType])
fi

if test "x$ovld" = "xyes"; then
  AC_DEFINE([OVLD], [1], [Enable Operator Overloading])
fi
#AM_CONDITIONAL([GRAPHICS], [test x$graphics = xyes])

if test "x$graphics" = "xyes"; then

  CHECK_XLIB()
  if test "x$xlib_cv_libx" = xyes ; then

    CHECK_FREETYPE()
    CHECK_XFT()
    CHECK_JPEG()
    CHECK_PNG()

    if test "x$graphics3d" = "xyes"; then
       CHECK_OPENGL()
       # A C++ compiler must be present and usable
       if test "$CXX" = "g++" -a "$GXX" = "yes"; then
         CHECK_FTGL()
       else
         echo "FTGL: missing or untrusted C++; CXX is $CXX and GXX is $GXX"
       fi
    else
      AC_DEFINE([NoGraphics3D], [1], [No Graphics3D])   
    fi    

    echo "Building with graphics..."
    GRAPHICS=graphics
    XL="-L../../bin -lXpm \$(XLIBS)"
    XPM=xpm
    DRAWSTRING=drawstring3d.o
    COMMONDRAWSTRING=../common/drawstring3d.o

#    Any system specific graphics related config can go here
    case $unicon_host in
     *linux*)
        ;;
     *solaris*)
        XLIBS = -L/usr/X11R6/lib/64 -R/usr/X11R6/lib/64 -lXpm -lX11       ;;
     *aix*)
        ;;
     *bsd*)
        ;;
     *macos*)
        XLIBS="-L/opt/X11/lib -L/usr/X11R6/lib -L/usr/local/lib -lXpm -lX11"
	;;
     *windows*)
        ;;
    esac
    
  else
    echo "Graphics library missing: building without graphics..."
  fi
  
else
  echo "Building without graphics..."
  AC_DEFINE([NoGraphics], [1], [No Graphics])
  AC_DEFINE([NoGraphics3D], [1], [No Graphics3D])   
fi

  AC_SUBST(XLIBS)
  AC_SUBST(GRAPHICS)
  AC_SUBST(XL)
  AC_SUBST(XPM)
  AC_SUBST(DRAWSTRING)
  AC_SUBST(COMMONDRAWSTRING)
  AC_SUBST(CMNT)
  AC_SUBST(SLNT)
  AC_SUBST(DASHS)

if test -f src/asm/$unicon_host-rswitch.s; then
    echo "Native coswitch detected"
    cp src/asm/$unicon_host-rswitch.s src/common/rswitch.s
else
   if test -f src/asm/$unicon_host-rswitch.c; then
      echo "Native coswitch detected"
      cp src/asm/$unicon_host-rswitch.c src/common/rswitch.c
   else
      echo "No native coswitch for $unicon_host , switching to pthreadcoswitch..."
      AC_DEFINE([NoNativeCoswitch], [1], [No Native coswitch])
      cp src/common/pthreadcoswitch.c src/common/rswitch.c
   fi
fi

#AC_GNU_SOURCE

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

if test "x$plugins" = "xyes"; then
  AC_CHECK_LIB(dl, dlopen)
else
  AC_DEFINE([NoLoadFunc], [1], [No LoadFunc])
fi
#AC_CHECK_FUNC(dlopen,
#	[AC_DEFINE([HAVE_DLOPEN], [1], [dlopen for shared object via c functions])])

if test "x$audio" = "xyes"; then
   CHECK_OGG()
   CHECK_SDL()
   CHECK_SMPEG()
   CHECK_OPENAL()
else
  AC_DEFINE([NoAudio], [1], [No Audio])
fi

if test "x$voip" = "xyes"; then
    # A C++ compiler must be present and usable
    if test "$CXX" = "g++" -a "$GXX" = "yes"; then
      CHECK_VOICE()
    else
         echo "VOIP: missing or untrusted C++; CXX is $CXX and GXX is $GXX"
    fi
else
  AC_DEFINE([NoVoip], [1], [No VOIP])
fi

CHECK_ZLIB()

if test "x$database" = "xyes"; then
   CHECK_ODBC()
else
  AC_DEFINE([NoDatabase], [1], [No Database])
fi

CHECK_PTHREAD()
CHECK_OPENSSL()


AC_SUBST(JV_LDFLAGS)
AC_SUBST(GL_CFLAGS)
AC_SUBST(GL_LDFLAGS)


AC_CHECK_GLOBAL(sys_nerr)
AC_CHECK_GLOBAL(sys_errlist)
AC_VAR_TIMEZONE_EXTERNALS()
AC_STRUCT_TIMEZONE()
AC_CONFIG_FILES([Makedefs:Makedefs.in],)
AC_CONFIG_FILES([Makedefs.uni:Makedefs.uni.in],)
AC_CONFIG_HEADERS([src/h/auto.h:src/h/auto.in],)
AC_OUTPUT



if test "$zlib_cv_libz"   = yes ; then
   ctmp=" + Compression        : +ZLIB"
else
   ctmp=" - Compression        : -ZLIB"
fi

# want graphics
if test "$graphics" = yes ; then
  gtmp="Graphics           :"
  if test "$xlib_cv_libx"    = yes ; then
    gtmp=" + $gtmp +XLIB "
  else
    gtmp=" - $gtmp -XLIB "
  fi

  if test "$jpeg_cv_libjpeg" = yes ; then gtmp="$gtmp +JPG " ; else gtmp="$gtmp -JPG " ; fi

  if test "$png_cv_libpng"   = yes ; then gtmp="$gtmp +PNG " ; else gtmp="$gtmp -PNG " ; fi

  if test "$xft_cv_libxft"   = yes ; then gtmp="$gtmp +XFT " ; else gtmp="$gtmp -XFT " ; fi
  if test "$freetype_cv_libfreetype"   = yes ; then
    gtmp="$gtmp+Freetype " ; else gtmp="$gtmp-FreeType " ; fi
else
#disbaled graphics
  gtmp=" ! Graphics"
fi

# want graphics3d
if test "$graphics3d" = yes ; then

  if test "$opengl_cv_libGL"   = yes ; then
    gdtmp="$gdtmp+OpenGL "
    ong3d=1
  else
    gdtmp="$gdtmp-OpenGL "
  fi

  if test "$opengl_cv_libGLU"  = yes ; then
    gdtmp="$gdtmp +GLU "
    if test $ong3d = 1 ; then ong3d=2 ; fi
  else
    gdtmp="$gdtmp -GLU "
  fi

  if test "$FTGL_cv_libFTGL"   = yes ; then gdtmp="$gdtmp +FTGL "   ; else gdtmp="$gdtmp -FTGL " ; fi

  if test "$opengl_cv_libGL" = yes && test "$opengl_cv_libGLU"  = yes ; then
    gdtmp=" + Graphics3D         : $gdtmp"
  else
    gdtmp=" - Graphics3D         : $gdtmp"
  fi
else
#disbaled graphics3D
  gdtmp=" ! Graphics3D"
fi

# want concurrency
if test "$concurrency" = yes ; then
  if test "$pthread_cv_libpthread"  = yes ; then
    contmp=" + Concurrency        : +pthread"
  else
    contmp=" - Concurrency        : -pthread"
  fi 
else
#disbaled Concurrency
  contmp=" ! Concurrency"
fi

# want audio
if test "$audio" = yes ; then
  atmp="Audio              :"
  onAudio=0
  if test "$libopenal_cv_libopenal" = yes ; then
    atmp="$atmp +OpenAL "
    onAudio="1"
  else
    atmp="$atmp -OpenAL "
  fi

  if test "$libalut_cv_libalut"     = yes ; then
    atmp="$atmp +alut "
    if test "$onAudio" = 1 ; then onAudio=2 ; fi
  else
    atmp="$atmp -alut "
  fi


  atmp="$atmp("
  if test "$ogglib_cv_libogg"       = yes ; then
    atmp="$atmp +ogg "
    if test "$onAudio" = 2 ; then onAudio=3 ; fi
  else
    atmp="$atmp -ogg "
  fi
  
  if test "$ogglib_cv_libvorbis"    = yes ; then
    atmp="$atmp +vorbis "
    if test "$onAudio" = 3 ; then onAudio=4 ; fi
  else
    atmp="$atmp -vorbis "
  fi

  # if ogg was present but vorbis was missing, reset
  if test "$onAudio" = 3 ; then onAudio=2 ; fi

  atmp="$atmp) | ("
  if test "$libsmpeg_cv_libsmpeg"   = yes ; then
    atmp="$atmp +SDL +SMPEG "
    if test "$onAudio" = 2 ; then onAudio=4 ; fi
  else
    atmp="$atmp -SDL -SMPEG "
  fi

  atmp="$atmp)"

  if test "$onAudio" = 4 ; then
    atmp=" + $atmp"
  else
    atmp=" - $atmp"
  fi

else
#disbaled Audio
  atmp=" ! Audio"
fi

# want voip
if test "$voip" = yes ; then
  if test "$jvlib_cv_libjv"         = yes ; then
    vtmp=" + VOIP               : +jvoip"
  else
    vtmp=" - VOIP               : -jvoip"
  fi
else
#disbaled Voip
  vtmp=" ! VOIP"
fi

# want database
if test "$database" = yes ; then
  if test "$odbc_cv_libodbc"        = yes ; then
    dtmp=" + Database           : +odbc"
  else
    dtmp=" - Database           : -odbc"
  fi
else
#disbaled databse
  dtmp=" ! Databse"
fi

# want ssl
if test "$ssl" = yes ; then
  if test "$openssl_cv_libssl"      = yes ; then
    stmp=" + SSL                : +ssl"
  else
    stmp=" - SSL                : -ssl"
  fi
else
#disbaled ssl
  stmp=" ! SSL"
fi

echo "" 
echo "--------------------------------------------------" 
echo "           Configuration Summary"
echo "--------------------------------------------------" 
echo "*** Build Environment"
echo "Host     :  $host_os  ($unicon_host)"
echo "CC       :  $CC"
echo "CFLAGS   :$CFLAGS"
echo "CPPFLAGS :$CPPFLAGS"
echo "LDFLAGS  :$LDFLAGS"
echo "LIBS     : $LIBS"
echo "CXX      :  $CXX  (Required only with FTGL and VOIP)" 
echo "Verbose  :  $verbosebuild"
echo "Debug    :  $debug"
echo "Devmode  :  $devmode"
echo ""
echo "*** Features (+Available   -Missing   !Disabled)"
echo "$ctmp"
echo "$gtmp"
echo "$gdtmp"
echo "$contmp"
echo "$atmp"
echo "$vtmp"
echo "$dtmp"
echo "$stmp"

if test "$plugins"      = yes ; then
echo " + plugins"
else
echo " ! plugins"
fi

if test "$iconc"      = yes ; then
echo " + Compiler "
else
echo " ! Compiler"
fi

if test "$pattern"      = yes ; then
echo " + Patterns"
else
echo " ! Patterns"
fi

if test "$ovld"      = yes ; then
echo " + Overlodading"
else
echo " ! Overloading"
fi

echo "" 
echo "Remember to add unicon/bin to your path"
