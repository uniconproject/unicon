/*
 * sys.h -- system include files.
 */

#ifdef ConsoleWindow
#undef putc
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


/*
 * Operating-system-dependent includes.
 */
#if PORT
   Deliberate Syntax Error
#endif					/* PORT */

#if AMIGA
   #include <fcntl.h>
   #include <ios1.h>
   #include <libraries/dosextens.h>
   #include <libraries/dos.h>
   #include <workbench/startup.h>
   #if __SASC
      #include <proto/dos.h>
      #include <proto/icon.h>
      #include <proto/wb.h>
      #undef GLOBAL
      #undef STATIC			/* defined in <exec/types.h> */
   #endif				/* __SASC */
#endif					/* AMIGA */

#if ATARI_ST
   #include <fcntl.h>
   #include <osbind.h>
#endif					/* ATARI_ST */

#if MACINTOSH
   #if LSC
      #include <unix.h>
   #endif				/* LSC */
   #if MPW
      #define create xx_create	/* prevent duplicate definition of create() */
      #include <Types.h>
      #include <Events.h>
      #include <Files.h>
      #include <FCntl.h>
      #include <Files.h>
      #include <IOCtl.h>
      #include <fp.h>
      #include <OSUtils.h>
      #include <Memory.h>
      #include <Errors.h>
      #include "time.h"
      #include <Quickdraw.h>
      #include <ToolUtils.h>
      #include <CursorCtl.h>
   #endif				/* MPW */
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
#if UNIX
#undef OS2
#endif					/* OS2 */
  #undef Type
  #undef Precision
#endif					/* ISQL */

#if MSDOS
   #undef Type
   #include <sys/types.h>
   #include <sys/stat.h>
   #include <fcntl.h>
#ifdef NTGCC
   #include <dirent.h>
#endif					/* NTGCC */

   #ifdef MSWindows
      #define int_PASCAL int PASCAL
      #define LRESULT_CALLBACK LRESULT CALLBACK
      #define BOOL_CALLBACK BOOL CALLBACK
      #ifdef PosixFns
      #include <winsock2.h>
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
      #include <winsock2.h>
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
#endif					/* MSDOS */


#if MVS || VM
   #ifdef RecordIO
      #if SASC
         #include <lcio.h>
      #endif				/* SASC */
   #endif				/* RecordIO */
   #if SASC
      #include <lcsignal.h>
   #endif				/* SASC */
#endif					/* MVS || VM */

#if OS2
   #define INCL_DOS
   #define INCL_ERRORS
   #define INCL_RESOURCES
   #define INCL_DOSMODULEMGR

   #ifdef PresentationManager
      #define INCL_PM
   #endif				/* PresentationManager */

   #include <os2.h>
   /* Pipe support for OS/2 */
   #include <stddef.h>
   #include <process.h>
   #include <fcntl.h>

   #if CSET2V2
      #include <io.h>
      #include <direct.h>
      #define IN_SYS_H
      #include "../h/local.h"		/* Include #pragmas */
      #undef IN_SYS_H
   #endif				/* CSet/2 version 2 */

#endif					/* OS2 */

#if UNIX
   #include <dirent.h>
   #include <limits.h>
   #include <unistd.h>
   #include <sys/stat.h>
   #include <sys/time.h>
   #include <sys/times.h>
   #include <sys/types.h>
   #include <termios.h>
   #ifdef SysSelectH
      #include <sys/select.h>
   #endif
#ifdef Audio
   #include <sys/ioctl.h>
   #include <fcntl.h>
   #include <linux/soundcard.h>
   #include <pthread.h>
#endif
#endif					/* UNIX */

#if VMS
   #include <types.h>
   #include <dvidef>
   #include <iodef>
   #include <stsdef.h>
#endif					/* VMS */

/*
 * Window-system-dependent includes.
 */
#ifdef ConsoleWindow
   #include <stdarg.h>
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
#if !AMIGA
#define AMIGA_ZERO
#undef AMIGA
#endif					/* !AMIGA */
         #include "../xpm/xpm.h"
#ifdef AMIGA_ZERO
#define AMIGA 0
#endif					/* !AMIGA */
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
#if HAVE_LIBJPEG

#if defined(__x86_64__) && defined(XWindows)
/* Some AMD64 Gentoo systems seem to have a buggy macros in
   jmorecfg.h, but if we include Xmd.h beforehand then we get better
   definitions of the macros. */
#include <X11/Xmd.h>
#endif

#ifdef NTGCC
/* avoid INT32 compile error in jmorecfg.h by pretending we used Xmd.h! */
#define XMD_H
#endif

#include "jpeglib.h"
#include "jerror.h"
#include <setjmp.h>
/* we do not use their definitions of GLOBAL, LOCAL, or OF; we use our own */
#undef GLOBAL
#undef LOCAL
#undef OF
#endif					/* HAVE_LIBJPEG */

#ifdef Graphics
   #define VanquishReturn(s) return s;
#endif					/* Graphics */

/*
 * Feature-dependent includes.
 */
#ifndef HostStr
   #if !VMS
      #include <sys/utsname.h>
   #endif				/* !VMS */
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

#if WildCards
   #include "../h/filepat.h"
#endif					/* WildCards */

#ifdef Dbm
#include <ndbm.h>
#endif					/* Dbm */

#ifdef ISQL
  /* to prevent double-typedef of BOOL on some platforms */
  #define BOOL int
  #include <sqlext.h>

  #define Type(d) (int)((d).dword & TypeMask)
  #define Precision 16

#if UNIX
#define OS2 0
#endif					/* UNIX */
#endif					/* ISQL */

#ifdef Messaging
# include <tp.h>
#endif                                  /* Messaging */

#ifdef ConsoleWindow
#undef putc
#define putc Consoleputc
#endif					/* ConsoleWindow */

#ifdef Graphics3D
#include <GL/gl.h>
#ifdef XWindows
#include <GL/glx.h>
#endif					/* XWindows */
#include <GL/glu.h>
#endif					/* Graphics3D */

#if HAVE_LIBZ
			
#  ifdef STDC
#    define OF(args)  args
#  else
#    define OF(args)  ()
#  endif

#if !VMS
#undef VMS
#endif
#include <zlib.h>
#ifndef VMS
#define VMS 0
#endif

#endif					/* HAVE_LIBZ */

#ifdef HAVE_VOICE
#include "../lib/voice/jvoip.h"
#endif					/* HAVE_VOICE */

#ifdef HAVE_LIBOPENAL
	#include <AL/al.h>
	#include <AL/alc.h>
	#include <AL/alext.h>
	#include <AL/alut.h>
#endif					/* HAVE_LIBOPENAL */

/* Ogg Vorbis */
#ifdef HAVE_LIBOGG
	#include <vorbis/codec.h>
	#include <vorbis/vorbisfile.h>
#endif					/* HAVE_LIBOGG */
