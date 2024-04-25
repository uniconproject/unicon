#define HostStr "Win32 Intel"
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
#define WINCE 1
#define MSVC 1
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

/*#define ScrollingConsoleWin *//* wince */

/* #define Eve */
#define NoPosixFns /* wince */
#define NoCoExpr   /* wince */
#define KeyboardFncs
/* #define ISQL wince */
#undef ISQL
#define NoCrypt
#define Dbm /*wince*/
/*#undef Dbm
#define NoDbm*/ /* wince */
#undef MultiProgram
#define NoMultiProgram
/* #define Messaging wince */
#undef Messaging     /* wince */
#define NoMessaging  /* wince */
#ifdef Messaging
#define ssize_t signed
#endif					/* Messaging */
#define LoadFunc
