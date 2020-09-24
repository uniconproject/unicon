AC_INIT([Unicon],[13.1],[jeffery@cs.uidaho.edu], [unicon], [http://www.unicon.org])

AC_CANONICAL_HOST


# not needed yet
#AC_CANONICAL_BUILD
#AC_CANONICAL_TARGET

case $host_cpu in
     *armv7* | *armv6* | *aarch32*)
        unicon_cpu="arm_32"
	ARCHBITS="32"
	AC_DEFINE([ARM], [1], [ARM platform])
        ;;
     *armv8* | *aarch64*)
        unicon_cpu="arm_64"
	ARCHBITS="64"
	AC_DEFINE([ARM], [1], [ARM platform])
        ;;
     *i386* | *i686*)
        unicon_cpu="x86_32"
	ARCHBITS="32"
	AC_DEFINE([X86], [1], [X86 platform])
	;;
     *)
        unicon_cpu="$host_cpu"
	ARCHBITS="64"
        ;;
esac

unicon_osdist=$OSDIST
unicon_osrel=$OSREL

case $host_os in
     *linux*)
        unicon_os="linux"

	# if dist/version are not set, try to guess them
	if test x$unicon_osdist = x ; then
	   if test -f /etc/os-release ; then
	      . /etc/os-release
	      unicon_osdist=$NAME
	      unicon_osrel=$VERSION_ID
	   elif type lsb_release >/dev/null 2>&1; then
	      unicon_osdist=$(lsb_release -si)
	      unicon_osrel=$(lsb_release -sr)
	   elif test -f /etc/lsb-release ; then
	      . /etc/lsb-release
	      unicon_osdist=$DISTRIB_ID
	      unicon_osrel=$DISTRIB_RELEASE
	   elif test -f /etc/debian_version ; then
	      unicon_osdist=Debian
	      unicon_osrel=$(cat /etc/debian_version)
	   fi
	fi

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
     *cygwin* | *mingw* | *msys*)
        unicon_os="windows"
	AC_DEFINE([Windows], [1], [Windows platform])
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

AC_ARG_ENABLE([iconc],
	[AS_HELP_STRING([--disable-iconc], [Build Unicon Compiler (Iconc/Uniconc)])],
			[iconc=no], [iconc=yes])
AC_ARG_ENABLE([iconcurrency],
	[AS_HELP_STRING([--enable-iconcurrency], [enable thread support in Unicon Compiler])],
			[coniconc=yes], [coniconc=no])
AC_ARG_ENABLE([ovld],
	[AS_HELP_STRING([--enable-ovld], [enable operator overloading])],
			[ovld=yes], [ovld=no])

AC_ARG_ENABLE([udbtools],
	[AS_HELP_STRING([--enable-udbtools], [enable Unicon debugger tools])],
			[udbtools=yes], [udbtools=no])

AC_ARG_ENABLE([progs],
	[AS_HELP_STRING([--enable-progs], [enable Unicon programs])],
			[progs=yes], [progs=no])

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
orig_cflags="${CFLAGS:-}"
CFLAGS=""
AC_LANG([C])
AC_USE_SYSTEM_EXTENSIONS
# Try CC 99, or better
ac_cc="$CC"
CC="${CC% -std=c99}"

AC_CFLAG([-std=gnu11], [CC="$ac_cc"], [CC="$CC -std=gnu11"])

# try to add -m32 or -m64
ARCHFLAG="-m$ARCHBITS"
AC_CFLAG([$ARCHFLAG],[], [
			 CPPFLAGS="$CPPFLAGS $ARCHFLAG"
			 LDFLAGS="$LDFLAGS $ARCHFLAG"
			 ASFLAGS="$ASFLAGS $ARCHFLAG"
			 ] )

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
  AC_DEFINE([DEVMODE], [1], [Developer Mode])
fi

if test x"$udbtools" = x"yes" ; then
  UDBTOOLS=udbtools
fi

if test x"$progs" = x"yes" ; then
  UNIPROGS=progs
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

# We always want these CFLAGS if available, the second one is neseccary for a stable runtime
AC_CFLAG([-fno-omit-frame-pointer])

AC_CFLAG([-fno-strict-aliasing])

if test x"$devmode" = x"yes" ; then
  AC_CFLAG([-Wall])
  AC_CFLAG([-Wno-missing-braces])
#  AC_CFLAG([-Wmissing-prototypes])
#  AC_CFLAG([-Wmissing-declarations])
fi

if test x"${enable_werror}" = x"yes" ; then
  WERROR="-Werror"
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
AC_CHECK_SIZEOF(long int)
AC_CHECK_SIZEOF(long long int)
AC_CHECK_SIZEOF(int *)

AC_WORDS_BIGENDIAN
AC_C_CONST
AC_TYPE_SIZE_T
AC_FUNC_ALLOCA
AC_TYPE_OFF_T
AC_ST_BLKSIZE
AC_CHECK_TYPE(ssize_t, signed)

case $ac_cv_sizeof_int_p in
     *1)
     BITS=8
     ;;
     *2)
     BITS=16
     ;;
     *4)
     BITS=32
     # RCFLAGS used on Windows only at the moment
     RCFLAGS="--target=pe-i386"
     ;;
     *8)
     BITS=64
     # RCFLAGS used on Windows only at the moment
     RCFLAGS="--target=pe-x86-64"
     ;;
esac

OBJ=o
CFUNCTARGET="cfun"
CFDYN="-fPIC -shared -O2 $OMIT"
SO=so
# OS specific flags go here
case $unicon_host in
     *linux*)
      LDFLAGS="$LDFLAGS -rdynamic "
      RLINK="-rdynamic -Wl,-E "
      RLIBS="-ldl -lcrypt "
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
       DASHX=-x
       RLIBS="-ldl "
	;;
     *windows*)
       EXE=".exe"
       NT="NT"
       DNT="-DNT"
       SO=dll
       DASHG="-G"
       LDFLAGS="$LDFLAGS --static -mnop-fun-dllimport -mwin32 -DPTW32_STATIC_LIB "
       CPPFLAGS="$CPPFLAGS --static -mnop-fun-dllimport -mwin32 -DPTW32_STATIC_LIB "
       LIBS="$LIBS -lgdi32 -lws2_32"

       WSTKLDFLAG="-Xlinker --stack -Xlinker 8192000"
       WGLIBS="-lopengl32 -lglu32 -lkernel32 -luser32 -lgdi32 -lcomdlg32 -lwinmm"
       WSUBSYS="-Wl,--subsystem,console"
       NTCONDEP="NTCON"
       LIBWUCONSOLE="libwuconsole.a"
       WICONXTARGET="wiconx"
       WICONTTARGET="wicont"
       WUNICONTARGET="wunicon"
       CFUNCTARGET="windows"
       EXEICONTARGET=icon.$OBJ

       ICONXEXE=iconx.exe
       WICONXEXE=wiconx.exe
       ICONTEXE=icont.exe
       WICONTEXE=wicont.exe
       UNICONEXE=unicon.exe
       WUNICONEXE=wunicon.exe
       ICONCEXE=iconc.exe
        ;;
esac

if test "x$iconc"      = "xyes" ; then
       ICONCTARGET=Iconc
fi


if test "x$orig_cflags" != "x" ; then
  CFLAGS="$CFLAGS $orig_cflags"
fi

AC_SUBST(EXE)
AC_SUBST(WSTKLDFLAG)
AC_SUBST(WGLIBS)
AC_SUBST(WSUBSYS)
AC_SUBST(NT)
AC_SUBST(DNT)
AC_SUBST(NTCONDEP)
AC_SUBST(LIBWUCONSOLE)
AC_SUBST(WICONXTARGET)
AC_SUBST(WICONTTARGET)
AC_SUBST(WUNICONTARGET)
AC_SUBST(CFUNCTARGET)
AC_SUBST(EXEICONTARGET)
AC_SUBST(RCFLAGS)
AC_SUBST(ICONXEXE)
AC_SUBST(WICONXEXE)
AC_SUBST(ICONTEXE)
AC_SUBST(WICONTEXE)
AC_SUBST(UNICONEXE)
AC_SUBST(WUNICONEXE)
AC_SUBST(ICONCEXE)

AC_SUBST(OBJ)
AC_SUBST(BITS)
AC_SUBST(unicon_os)
AC_SUBST(unicon_osdist)
AC_SUBST(unicon_osrel)

AC_SUBST(CC)
AC_SUBST(RLINK)
AC_SUBST(RLIBS)
AC_SUBST(CFDYN)
AC_SUBST(SO)
AC_SUBST(ICONCTARGET)

AC_SUBST(UDBTOOLS)
AC_SUBST(UNIPROGS)


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

  AC_DEFINE([NoMultiProgram], [1], [No MultiProgram])
  # what else we need to disable?
fi


AC_CHECK_FUNCS([socket bcopy bzero memcpy memset inet_aton inet_pton \
	       snprintf vsprintf rename ftruncate flock fsync \
	       getrlimit setrlimit strerror vfork \
	       getrusage sysconf profil getenv_r])

AC_FUNC_STRERROR_R()

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

if test "x$concurrency" = "xno"; then
  AC_DEFINE([NoConcurrent], [1], [No Concurrency])
fi

if test "x$coniconc" != "xyes"; then
  AC_DEFINE([NoConcurrentCOMPILER], [1], [No ConcurrentCOMPILER])
fi

if test "x$pattern" = "xno"; then
  AC_DEFINE([NoPattern], [1], [No PatternType])
fi

if test "x$ovld" = "xyes"; then
  AC_DEFINE([OVLD], [1], [Enable Operator Overloading])
fi
#AM_CONDITIONAL([GRAPHICS], [test x$graphics = xyes])

CHECK_ZLIB()

if test "x$graphics" = "xyes"; then

  CHECK_XLIB()
  # if we have X11 or if we are running on MS Windows check for graphics libs
  if test "x$cv_libX11" = xyes -o "ms$unicon_os" = "mswindows" ; then

    CHECK_FREETYPE()
    CHECK_XFT()
    CHECK_JPEG()
    CHECK_PNG()

    if test "x$graphics3d" = "xyes"; then
       # assume we have opengl on windows
       if test "ms$unicon_os" = "mswindows" ; then
          cv_libGL=yes
	  cv_libGLU=yes
	  cv_opengl=yes
	  AC_DEFINE([HAVE_LIBGL], [1])
	  AC_DEFINE([HAVE_LIBGLU], [1])
       else
          CHECK_OPENGL()
       fi
       # A C++ compiler must be present and usable
       if test "x$CXX" = "xg++" -a "x$GXX" = "xyes"; then
         CHECK_FTGL()
       else
         echo "FTGL: missing or untrusted C++; CXX is $CXX and GXX is $GXX"
       fi
    else
      AC_DEFINE([NoGraphics3D], [1], [No Graphics3D])
    fi

    echo "Building with graphics..."
    GRAPHICS=graphics

    if test "ms$unicon_os" != "mswindows" ; then
       XL="-L../../bin -lXpm \$(XLIBS)"
       XPM=xpm
    fi

    if test "$cv_libftgl" = "yes"; then
        DRAWSTRING=drawstring3d.o
    	COMMONDRAWSTRING=../common/drawstring3d.o
   fi

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
  graphics3d=no
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
  AC_SUBST(DASHX)
  AC_SUBST(DASHG)

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

if test "x$plugins" = "xyes"; then
  AC_SEARCH_LIBS([dlopen], [dl dld],
        [AC_DEFINE([HAVE_LIBDL], [1], [define to 1 if you have dlopen])],
	[])

  if test "x$ac_cv_search_dlopen" != "xno" ; then
    PLUGINS=upexample
    AC_CHECK_LIB(lxc,lxc_get_version,[PLUGINS="$PLUGINS lxcunicon"])
    AC_SUBST(PLUGINS)
  fi
else
  AC_DEFINE([NoLoadFunc], [1], [No LoadFunc])
  CFUNCTARGET="disabled"
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

if test "x$database" = "xyes"; then
   if test "ms$unicon_os" = "mswindows" ; then
     CHECK_ODBC32()
   else
     CHECK_ODBC()
   fi
else
  AC_DEFINE([NoDatabase], [1], [No Database])
fi

CHECK_PTHREAD()
CHECK_OPENSSL()

# autoconf does this too late, so just do it now...
test "x$prefix" = xNONE && prefix=$ac_default_prefix
test "x$exec_prefix" = xNONE && exec_prefix='${prefix}'

AC_SUBST(JV_LDFLAGS)
AC_SUBST(GL_CFLAGS)
AC_SUBST(GL_LDFLAGS)


AC_SUBST(prefix)
AC_SUBST(exec_prefix)
AC_SUBST(bindir)
AC_SUBST(libdir)
AC_SUBST(docdir)
AC_SUBST(mandir)

    cprefix="$prefix"
    cexec_prefix="$exec_prefix"
    cbindir="$bindir"
    clibdir="$libdir"
    cdocdir="$docdir"
    cmandir="$mandir"

for I in 1 2 3 4 5 6 7 8 9 10; do
    eval cprefix="\"$cprefix\""
    eval cexec_prefix="\"$cexec_prefix\""
    eval cbindir="\"$cbindir\""
    eval clibdir="\"$clibdir\""
    eval cdocdir="\"$cdocdir\""
    eval cmandir="\"$cmandir\""

done


AC_DEFINE_UNQUOTED([config_prefix],      ["${cprefix}"], [prefix])
AC_DEFINE_UNQUOTED([config_exec_prefix], ["${cexec_prefix}"], [exec_prefix])
AC_DEFINE_UNQUOTED([config_bindir],      ["${cbindir}"], [bindir])
AC_DEFINE_UNQUOTED([config_libdir],      ["${clibdir}"], [libdir])
AC_DEFINE_UNQUOTED([config_docdir],      ["${cdocdir}"], [docdir])
AC_DEFINE_UNQUOTED([config_man],         ["${cmandir}"], [mandir])

AC_CHECK_GLOBAL(sys_nerr)
AC_CHECK_GLOBAL(sys_errlist)
AC_VAR_TIMEZONE_EXTERNALS()
AC_STRUCT_TIMEZONE()
AC_CONFIG_FILES([Makefile:Makefile.in],)
AC_CONFIG_FILES([Makedefs:Makedefs.in],)
AC_CONFIG_FILES([Makedefs.uni:Makedefs.uni.in],)
AC_CONFIG_HEADERS([src/h/auto.h:src/h/auto.in],)


AC_OUTPUT



if test "x$cv_libz"   = "xyes" ; then
   ctmp=" + Compression        : +ZLIB"
else
   ctmp=" - Compression        : -ZLIB"
fi

# want graphics
if test "x$graphics" = "xyes" ; then
  gtmp="Graphics           :"
  if test "x$cv_libX11"    = "xyes" ; then
    gtmp=" + $gtmp +X11 "
  else
    gtmp=" - $gtmp -X11 "
  fi

  if test "x$cv_libjpeg" = "xyes" ; then gtmp="$gtmp +JPG " ; else gtmp="$gtmp -JPG " ; fi


  if test "x$cv_libpng"  = "xyes" ; then gtmp="$gtmp +PNG " ; else gtmp="$gtmp -PNG " ; fi

  if test "x$cv_libXft"   = "xyes" ; then gtmp="$gtmp +XFT " ; else gtmp="$gtmp -XFT " ; fi
  if test "x$cv_libfreetype"   = "xyes" ; then
    gtmp="$gtmp+Freetype " ; else gtmp="$gtmp-FreeType " ; fi
else
#disbaled graphics
  gtmp=" ! Graphics"
fi

# want graphics3d
if test "x$graphics3d" = "xyes" ; then

  if test "x$cv_libGL"   = "xyes" ; then
    gdtmp="$gdtmp+OpenGL "
    ong3d=1
  else
    gdtmp="$gdtmp-OpenGL "
  fi

  if test "x$cv_libGLU"  = "xyes" ; then
    gdtmp="$gdtmp +GLU "
    if test $ong3d = 1 ; then ong3d=2 ; fi
  else
    gdtmp="$gdtmp -GLU "
  fi

  if test "x$cv_libftgl"   = "xyes" ; then gdtmp="$gdtmp +FTGL "   ; else gdtmp="$gdtmp -FTGL " ; fi

  if test "x$cv_opengl" = "xyes" ; then
    gdtmp=" + Graphics3D         : $gdtmp"
  else
    gdtmp=" - Graphics3D         : $gdtmp"
  fi
else
#disbaled graphics3D
  gdtmp=" ! Graphics3D"
fi

# want concurrency
if test "x$concurrency" = "xyes" ; then
  if test "x$cv_libpthread"  = "xyes" ; then
    contmp=" + Concurrency        : +pthread"
  else
    contmp=" - Concurrency        : -pthread"
  fi
else
#disbaled Concurrency
  contmp=" ! Concurrency"
fi

# want audio
if test "x$audio" = "xyes" ; then
  atmp="Audio              :"
  onAudio=0
  if test "x$cv_libopenal" = "xyes" ; then
    atmp="$atmp +OpenAL "
    onAudio="1"
  else
    atmp="$atmp -OpenAL "
  fi

  if test "x$cv_libalut"     = "xyes" ; then
    atmp="$atmp +alut "
    if test "$onAudio" = 1 ; then onAudio=2 ; fi
  else
    atmp="$atmp -alut "
  fi


  atmp="$atmp("
  if test "x$cv_libogg"       = "xyes" ; then
    atmp="$atmp +ogg "
    if test "$onAudio" = 2 ; then onAudio=3 ; fi
  else
    atmp="$atmp -ogg "
  fi

  if test "x$cv_libvorbis"    = "xyes" ; then
    atmp="$atmp +vorbis "
    if test "$onAudio" = 3 ; then onAudio=4 ; fi
  else
    atmp="$atmp -vorbis "
  fi

  # if ogg was present but vorbis was missing, reset
  if test "$onAudio" = 3 ; then onAudio=2 ; fi

  atmp="$atmp) | ("
  if test "x$cv_libsmpeg"   = "xyes" ; then
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
if test "x$voip" = "xyes" ; then
  if test "x$cv_libvoip"         = "xyes" ; then
    vtmp=" + VOIP               : +voip"
  else
    vtmp=" - VOIP               : -voip"
  fi

  if test "x$cv_libjvoip"         = "xyes" ; then
    vtmp="$vtmp +jvoip"
  else
    vtmp="$vtmp -jvoip"
  fi

  if test "x$cv_libjthread"         = "xyes" ; then
    vtmp="$vtmp +jthread"
  else
    vtmp="$vtmp -jthread"
  fi

  if test "x$cv_libjrtp"         = "xyes" ; then
    vtmp="$vtmp +jrtp"
  else
    vtmp="$vtmp -jrtp"
  fi

else
#disbaled Voip
  vtmp=" ! VOIP"
fi

# want database
if test "x$database" = "xyes" ; then
  if test "$cv_libodbc"        = yes ; then
    dtmp=" + Database           : +odbc"
  else
  if test "x$cv_libiodbc"       = "xyes" ; then
    dtmp=" + Database           : +iodbc"
  else
    dtmp=" - Database           : -odbc | -iodbc"
  fi
  fi
else
#disbaled databse
  dtmp=" ! Databse"
fi

# want ssl
if test "x$ssl" = "xyes" ; then
  if test "x$cv_libssl"      = "xyes" ; then
    stmp=" + SSL                : +ssl"
  else
    stmp=" - SSL                : -ssl"
  fi
else
#disbaled ssl
  stmp=" ! SSL"
fi

AC_MSG_RESULT([

--------------------------------------------------
           Configuration Summary
--------------------------------------------------
*** Build Environment
Host     :  $host_os  ($unicon_host) $unicon_osdist $unicon_osrel
CC       :  $CC
CFLAGS   :$CFLAGS
CPPFLAGS :$CPPFLAGS
LDFLAGS  :$LDFLAGS
LIBS     : $LIBS
CXX      :  $CXX  (Required only with FTGL and VOIP)
CXXFLAGS : $CXXFLAGS
prefix	 : $prefix
Verbose  :  $verbosebuild
Debug    :  $debug
Devmode  :  $devmode

*** Features (+Available   -Missing   !Disabled)
$ctmp
$gtmp
$gdtmp
$contmp
$atmp
$vtmp
$dtmp
$stmp
])

if test "x$plugins"      = "xyes" ; then
  if test "x$ac_cv_search_dlopen" = "xno" ; then
    echo " - Plugins"
  else
    echo " + Plugins"
  fi
else
  echo " ! Plugins"
fi

if test "x$iconc"      = "xyes" ; then
  if test "x$coniconc"      = "xyes" ; then
     echo " + Compiler: with concurrency"
  else
     echo " + Compiler: no concurrency"
  fi
else
  echo " ! Compiler"
fi

if test "x$pattern"      = "xyes" ; then
  echo " + Patterns"
else
  echo " ! Patterns"
fi

if test "x$ovld"      = "xyes" ; then
  echo " + Overloading"
else
  echo " ! Overloading"
fi

echo ""
echo "do make to continue the build"
echo "or make -j8 for parallel and faster build"
