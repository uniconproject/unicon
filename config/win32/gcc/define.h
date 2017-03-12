
/*
 * 0x501 => WindowsXP or later
 */

#if !defined(WINVER) || (WINVER < 0x0501)
#undef WINVER
#define WINVER 0x0501
#define HAVE_GETADDRINFO
#endif

#define HostStr "Win32 Intel GCC"
#define IconAlloc
#define Precision 16
#define IcodeSuffix ".exe"
#define IcodeASuffix ".EXE"
#define SystemFnc
#define SysTime <sys/time.h>
#define Standard
/*
 * Header is used in winnt.h; careful how we define it here
 */
#define Header header
#define NT 1
#define NTGCC 1
#define CComp "gcc"
#define ShellHeader

#define index strchr
#define rindex strrchr
#define strdup _strdup
#define unlink _unlink

#define MSDOS 1
#define StandardC
#define ZERODIVIDE
#define QSortFncCast int (*)(const void *,const void *)

/* #define Eve */
#define PosixFns
#define KeyboardFncs
#define ISQL
#define NoCrypt
#define Dbm
#define Messaging
#define HAVE_STRERROR

#if defined(Messaging) && defined(OLD_NTGCC)
#define ssize_t signed
#endif					/* Messaging && OLD_NTGCC */

#define LoadFunc
#define FieldTableCompression 1
#define HAVE_LIBGL 1

#ifndef OLD_NTGCC
#define Double
#endif					/* OLD_NTGCC */

#define PatternType 1

/* StackCheck seems to cause a crash when exiting through 
 * pressing the [x] close window button, turn it off for now 
 */
#define NoStackCheck

/*
 * The rule of thumb we aim for is: it includes everything that comes with
 * mingw out of the box. This includes pthreads, apparently, and 2D and 3D
 * (OpenGL) headers, but not png, libz, or jpeg.
 *
 * In order to obtain png, libz, or jpeg libraries and headers for Mingw:
 *
 * ... fill in missing information here ...
 */

/* define for png image support, libz is required by PNG */
#if WANT_PNG
#define HAVE_LIBPNG 1
#define HAVE_LIBZ 1
#endif

/* define for jpeg image support */
#if WANT_JPG
#define HAVE_LIBJPEG 1
#endif

/* define for SSL/HTTPS support */
#if WANT_SSL
#define HAVE_LIBSSL 1
#endif

/* define if you have pthreads and want concurrency*/
#if WANT_THREADS
#define HAVE_LIBPTHREAD 1
#else
#define NoConcurrent
#endif

/*#define HAVE_STRUCT_TIMESPEC 1*/
