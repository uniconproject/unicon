/*
 * sys.h -- system include files.
 */

#ifdef ConsoleWindow
#undef putc
#undef printf
#undef fprintf
#undef fflush
#endif					/* ConsoleWindow */

/*
 * Universal (Standard ANSI C) includes.
 */
#include <ctype.h>
#include <errno.h>
#include <math.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

   /* not sure whether this one should always be in effect. Maybe it should.
    * moved from config.h so that it does not knock out exit's prototype.
    */
   #ifdef ConsoleWindow
      #undef exit
      #define exit c_exit
   #endif				/* Console Window */

/*
 * Operating-system-dependent includes.
 */
#if PORT
   Deliberate Syntax Error
#endif					/* PORT */

#if MACINTOSH
   #ifdef MacGraph
      #include <console.h>
      #include <AppleEvents.h>
      #include <GestaltEqu.h>
      #include <fp.h>
      #include <QDOffscreen.h>
      #include <Palettes.h>
      #include <Quickdraw.h>
   #endif				/* MacGraph */
#endif					/* MACINTOSH */

#ifdef ISQL
  #undef Type
  #undef Precision
#endif					/* ISQL */

#if MSDOS
   #undef Type
   #include <sys/types.h>
   #include <sys/stat.h>
   #include <fcntl.h>
#ifdef NTGCC
   #include <sys/time.h>
   /* Mingw GCC 4.8.1 idiotically #define's stat. We need that name intact. */
#ifdef stat
   #undef stat
#endif					/* stat */
   #include <dirent.h>
   #ifndef OLD_NTGCC
   /* The new GCC needs locking.h but the old one doesn't*/
   #include <sys/locking.h>
   #endif				/* OLD_NTGCC */
#endif					/* NTGCC */
#ifdef MSVC
   #include <direct.h>
#endif					/* MSVC */
   #ifdef MSWindows
      #define int_PASCAL int PASCAL
      #define LRESULT_CALLBACK LRESULT CALLBACK
      #define BOOL_CALLBACK BOOL CALLBACK
      #ifdef PosixFns

      /* 
       * Avoid a conflict between rpcndr.h and jmorecfg.h (jpeg) about "boolean"
       * uncomment the "boolean" lines below if you have this issue. 
       */
      /* #define boolean bolean */
      #include <winsock2.h>
      /* #undef boolean */
      #include<ws2tcpip.h>
      #else					/* PosixFns */
      #include <windows.h>
      #endif					/* PosixFns */
      #include <mmsystem.h>
      #include <process.h>
   #else					/* MSWindows */
      #if NT
      #ifndef PATH_MAX
      #define PATH_MAX 512
      #endif					/* PATH_MAX */
      #ifdef PosixFns
      /* 
       * Avoid a conflict between rpcndr.h and jmorecfg.h (jpeg) about "boolean"
       * uncomment the "boolean" lines below if you have this issue. 
       */
      /* #define boolean bolean */
      #include <winsock2.h>
      /* #undef boolean */
      #include<ws2tcpip.h>
      #else
         #if defined(ISQL) || defined(Audio)
           #include <windows.h>
           #include <mmsystem.h>
         #endif					/* ISQL */
      #endif					/* PosixFns */
      #endif					/* NT */
   #endif				/* MSWindows */
   #include <setjmp.h>
   #define Type(d) (int)((d).dword & TypeMask)
   #undef lst1
   #undef lst2

   /*MinGW32 needs these defined*/
   #ifndef EWOULDBLOCK
      
      #define EWOULDBLOCK             WSAEWOULDBLOCK
      #define EINPROGRESS             WSAEINPROGRESS
      #define EALREADY                WSAEALREADY
      #define ENOTSOCK                WSAENOTSOCK
      #define EDESTADDRREQ            WSAEDESTADDRREQ
      #define EMSGSIZE                WSAEMSGSIZE
      #define EPROTOTYPE              WSAEPROTOTYPE
      #define ENOPROTOOPT             WSAENOPROTOOPT
      #define EPROTONOSUPPORT         WSAEPROTONOSUPPORT
      #define ESOCKTNOSUPPORT         WSAESOCKTNOSUPPORT
      #define EOPNOTSUPP              WSAEOPNOTSUPP
      #define EPFNOSUPPORT            WSAEPFNOSUPPORT
      #define EAFNOSUPPORT            WSAEAFNOSUPPORT
      #define EADDRINUSE              WSAEADDRINUSE
      #define EADDRNOTAVAIL           WSAEADDRNOTAVAIL
      #define ENETDOWN                WSAENETDOWN
      #define ENETUNREACH             WSAENETUNREACH
      #define ENETRESET               WSAENETRESET
      #define ECONNABORTED            WSAECONNABORTED
      #define ECONNRESET              WSAECONNRESET
      #define ENOBUFS                 WSAENOBUFS
      #define EISCONN                 WSAEISCONN
      #define ENOTCONN                WSAENOTCONN
      #define ESHUTDOWN               WSAESHUTDOWN
      #define ETOOMANYREFS            WSAETOOMANYREFS
      #define ETIMEDOUT               WSAETIMEDOUT
      #define ECONNREFUSED            WSAECONNREFUSED
      #define ELOOP                   WSAELOOP
      #define EHOSTDOWN               WSAEHOSTDOWN
      #define EHOSTUNREACH            WSAEHOSTUNREACH
      #define EPROCLIM                WSAEPROCLIM
      #define EUSERS                  WSAEUSERS
      #define EDQUOT                  WSAEDQUOT
      #define ESTALE                  WSAESTALE
      #define EREMOTE                 WSAEREMOTE
#endif						/* EWOULDBLOCK */
   
#endif					/* MSDOS */

#if UNIX
   #include <dirent.h>
   #include <limits.h>
   #include <unistd.h>
   #include <sys/stat.h>
   #include <sys/time.h>
   #include <sys/times.h>
   #include <sys/types.h>
#ifdef MacOS
   #include <sys/sysctl.h>
#endif
#ifdef HAVE_SYS_RESOURCE_H
   #include <sys/resource.h>
#endif					/* HAVE_SYS_RESOURCE_H */
#ifdef HAVE_SYS_FILE_H
   #include <sys/file.h>
#endif					/* HAVE_FILE_H */
   #include <termios.h>
   #include <poll.h>
   #ifdef SysSelectH
      #include <sys/select.h>
   #endif
#if defined(PseudoPty) || defined(Audio)
   #include <fcntl.h>
#endif					/* PseudoPty || Audio */
#ifdef Audio
   #include <sys/ioctl.h>
   #include <linux/soundcard.h>
   #include <pthread.h>
#endif					/* Audio */
#endif					/* UNIX */

#ifdef HAVE_LIBPTHREAD
#if !UNIX || !defined(Audio)
#include <pthread.h>
#endif					/* PthreadCoswitch & ! Audio */
#include <semaphore.h>
#endif					/* HAVE_LIBPTHREAD */

#if VMS
   #include <types.h>
   #include <dvidef>
   #include <iodef>
   #include <stsdef.h>
#endif					/* VMS */

#include <stdarg.h>
/*
 * Window-system-dependent includes.
 */
#ifdef ConsoleWindow
   #undef printf
   #undef fprintf
   #undef fflush
   #define printf Consoleprintf
   #define fprintf Consolefprintf
   #define fflush Consolefflush
#endif					/* ConsoleWindow */

#ifdef XWindows
   /*
    * Undef VMS under UNIX, and UNIX under VMS,
    * to avoid confusing the tests within the X header files.
    */
   #if VMS
      #undef UNIX
      #include "decw$include:Xlib.h"
      #include "decw$include:Xutil.h"
      #include "decw$include:Xos.h"
      #include "decw$include:Xatom.h"

      #ifdef HAVE_LIBXPM
         #include "../xpm/xpm.h"
      #endif				/* HAVE_LIBXPM */

      #undef UNIX
      #define UNIX 0
   #else				/* VMS */
      #undef VMS

#ifdef Redhat71
/* due to a header bug, we must commit a preemptive first strike of Xosdefs */
#include <X11/Xosdefs.h>

#ifdef X_WCHAR
#undef X_WCHAR
#endif
#ifdef X_NOT_STDC_ENV
#undef X_NOT_STDC_ENV
#endif
#endif					/* Redhat71 */

      #ifdef HAVE_LIBXPM
         #include "../xpm/xpm.h"
      #else				/* HAVE_LIBXPM */
         #include <X11/Xlib.h>
      #endif				/* HAVE_LIBXPM */

      #include <X11/Xutil.h>
      #include <X11/Xos.h>
      #include <X11/Xatom.h>

      #undef VMS
      #define VMS 0
   #endif				/* VMS */

#endif					/* XWindows */

/*
 * Include this after Xlib stuff, jmorecfg.h expects this.
 */
#if HAVE_LIBJPEG && defined(Graphics)

#if defined(XWindows)
/* Some AMD64 Gentoo systems seem to have a buggy macros in
   jmorecfg.h, but if we include Xmd.h beforehand then we get better
   definitions of the macros. */
#include <X11/Xmd.h>
#endif

#ifdef NTGCC
/* avoid INT32 compile error in jmorecfg.h by pretending we used Xmd.h! */
#define XMD_H

/* avoid warnings over duplicate definition of HAVE_STDLIB_H in jpeglib.h */
#undef HAVE_STDLIB_H
#endif					/* NTGCC */

#include "jpeglib.h"
#include "jerror.h"
#ifndef HAVE_LIBPNG
#include <setjmp.h>
#endif					/* HAVE_LIBPNG */
/* we do not use their definitions of GLOBAL, LOCAL, or OF; we use our own */
#ifdef NTGCC
#undef boolean
#endif					/* NTGCC */
#undef GLOBAL
#undef LOCAL
#undef OF
#endif					/* HAVE_LIBJPEG */

#define VanquishReturn(s) return s;

/*
 * Feature-dependent includes.
 */
#ifndef HostStr
   #if !VMS && !Windows
      #include <sys/utsname.h>
   #endif				/* !VMS && !Windows*/
#endif					/* HostStr */

#ifdef LoadFunc
#if NT
   void *dlopen(char *, int); /* LoadLibrary */
   void *dlsym(void *, char *sym); /* GetProcAddress */
   int dlclose(void *); /* FreeLibrary */
#else					/* NT */
   #include <dlfcn.h>
#endif					/* NT */
#endif					/* LoadFunc */

#include "../h/filepat.h"

#ifdef Dbm
#include <ndbm.h>
#endif					/* Dbm */

#ifdef ISQL
#ifndef BOOL
  /* to prevent double-typedef of BOOL on some platforms */
#ifdef MacOS
//#define BOOL rumplemacskin
#else
  #define BOOL int
#endif
#endif
  #include <sqlext.h>
#undef BOOL

#ifdef DebugHeap
#define Type(d)		(int)((((d).dword & F_Typecode) ? ((int)((d).dword & TypeMask)) : (heaperr("descriptor type error",BlkLoc(d),(d).dword), -1)))
#else
#define Type(d) (int)((d).dword & TypeMask)
#endif
  #define Precision 16

#endif					/* ISQL */

#ifdef Messaging
# include <tp.h>
#endif                                  /* Messaging */

#ifdef ConsoleWindow
#undef putc
#define putc Consoleputc
#endif					/* ConsoleWindow */

#if HAVE_LIBGL
#include <GL/gl.h>
#ifdef XWindows
#include <GL/glx.h>
#endif					/* XWindows */
#include <GL/glu.h>
#if HAVE_LIBFREETYPE
   #include <ft2build.h>
   #include FT_FREETYPE_H
   #define PNG_SKIP_SETJMP_CHECK	/* 
					 * Fixes compile error for Ubuntu 16.04:
					 * 'expected [...] before __pngconf.h in
					 * libpng already includes setjmp.h'
					 */
#endif					/* HAVE_LIBFREETYPE */
#endif					/* HAVE_LIBGL */

#if HAVE_LIBZ
#  ifdef STDC
#    define OF(args)  args
#  else
#    define OF(args)  ()
#  endif

#if !VMS
#undef VMS
#endif

/*
 * On many platforms png.h includes zlib.h and including it again is an error
 * for a redefined type.  On many other platforms png.h does not include zlib.h
 * and this code needs to.  Apparently, this not including of zlib.h in png.h
 * occurs for libpng 1.5 and higher.
 */
#if HAVE_LIBPNG && defined(Graphics)
#include <png.h>
#if defined(NTGCC) || (defined(PNG_LIBPNG_VER) && (PNG_LIBPNG_VER >= 10500))
#include <zlib.h>
#endif

#else					/* HAVE_LIBPNG */

#include <zlib.h>
#endif					/* HAVE_LIBPNG */

#ifndef VMS
#define VMS 0
#endif

#else					/* HAVE_LIBZ */

/* If you claim to have libpng, but you don't have libz, that's no good */
#if HAVE_LIBPNG
/*#include <png.h>*/
#endif					/* HAVE_LIBPNG */
#endif					/* HAVE_LIBZ */

#ifdef HAVE_VOICE
#include "../lib/voice/jvoip.h"
#endif					/* HAVE_VOICE */

#ifdef HAVE_LIBOPENAL
#if HAVE_ALTYPES
	#include <AL/altypes.h>
	#include <AL/alexttypes.h>
#endif					/* HAVE_ALTYPES */
	#include <AL/al.h>
	#include <AL/alc.h>
	#include <AL/alext.h>
/*
 * 10/2008: alut.h is a legacy header. Putting this in to see what breaks.
 */
#if HAVE_ALUT
	#include <AL/alut.h>
#endif
#endif					/* HAVE_LIBOPENAL */

/* Ogg Vorbis */
#ifdef HAVE_LIBOGG
	#include <vorbis/codec.h>
	#include <vorbis/vorbisfile.h>
#endif					/* HAVE_LIBOGG */

/* OpenCL */
#ifdef HAVE_LIBCL
	#include <CL/cl.h>
#endif					/* HAVE_LIBCL */

#ifdef HAVE_LIBSSL
/* openssl thinks we are a VMS system when VMS=0 */
#if !VMS
#undef VMS
#endif

#include <openssl/bio.h>
#include <openssl/ssl.h>
#include <openssl/err.h>
#include <openssl/opensslv.h>

#ifndef VMS
#define VMS 0
#endif

#endif					/* HAVE_LIBSSL */
