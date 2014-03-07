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

#if defined(Messaging) && defined(OLD_NTGCC)
#define ssize_t signed
#endif					/* Messaging && OLD_NTGCC */

#define LoadFunc
#define FieldTableCompression 1
#define HAVE_LIBGL 1

#ifndef OLD_NTGCC
#define Double
#endif					/* OLD_NTGCC */
