AC_INIT([Unicon],[12.1],[jeffery@cs.uidaho.edu])
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
AC_INT_16_BITS
AC_LONG_64_BITS
AC_WORDS_BIGENDIAN
AC_C_CONST
AC_TYPE_SIZE_T
AC_FUNC_ALLOCA
AC_TYPE_OFF_T
AC_ST_BLKSIZE
AC_CHECK_TYPE(ssize_t, signed)
AC_CHECK_FUNCS(socket bcopy bzero memcpy memset inet_aton inet_pton \
	       snprintf vsprintf rename ftruncate flock fsync)
AC_REPLACE_FUNCS(getopt)
AC_FUNC_FORK()
AC_CHECK_LIB(dbm,main)
AC_CHECK_LIB(ndbm,main)
AC_SEARCH_LIBS([getaddrinfo],[socket],AC_DEFINE(HAVE_GETADDRINFO))
AC_SEARCH_LIBS([clock_gettime],[rt],AC_DEFINE(HAVE_CLOCK_GETTIME))
AC_SEARCH_LIBS([crypt],[crypt],AC_DEFINE(HAVE_CRYPT))
AC_CHECK_FUNC(getrusage,AC_DEFINE(HAVE_GETRUSAGE))
AC_CHECK_FUNC(sysconf,AC_DEFINE(HAVE_SYSCONF))
CHECK_FREETYPE()
CHECK_FTGL()
CHECK_OGG()
CHECK_SDL()
CHECK_SMPEG()
CHECK_OPENAL()
CHECK_VOICE()
CHECK_ZLIB()
CHECK_XLIB()
CHECK_JPEG()
CHECK_PNG()
CHECK_OPENGL()
CHECK_ODBC()
CHECK_PTHREAD()
CHECK_OPENSSL()
AC_CHECK_FUNCS(getrlimit setrlimit strerror vfork)
AC_CHECK_GLOBAL(sys_nerr)
AC_CHECK_GLOBAL(sys_errlist)
AC_VAR_TIMEZONE_EXTERNALS()
AC_STRUCT_TIMEZONE()
AC_CONFIG_FILES([Makedefs:Makedefs.in],)
AC_CONFIG_HEADERS([src/h/auto.h:src/h/auto.in],)
CHECK_XFT()
AC_OUTPUT
