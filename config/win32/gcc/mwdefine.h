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
#define Double
#define ZERODIVIDE
#define QSortFncCast int (*)(const char *,const char *)

/* #define Eve */
#define PosixFns
#define KeyboardFncs
#define ISQL
#define NoCrypt
#define Dbm
#define Messaging
#ifdef Messaging
#define ssize_t signed
#endif					/* Messaging */
#define LoadFunc
#define MSWindows
#define FAttrib 1
#define FieldTableCompression 1
#define EventMon 1
