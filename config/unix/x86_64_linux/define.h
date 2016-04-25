/*  
 * Icon configuration file for Linux v2 on Athlon64
 */

#define UNIX 1
#define LoadFunc
/* no SysOpt: Linux getopt() is POSIX-compatible only if an envmt var is set */

#define CComp "gcc"
#define COpts "-O2 -fomit-frame-pointer"
#define NEED_UTIME

/* CPU architecture */
#define IntBits 32
#define WordBits 64
#define Double
#define StackAlign 16

/* a non-default datatype for SQLBindCol's 6th parameter */
#define SQL_LENORIND SQLLEN
#define HAVE_SYSCONF 1

/*
 * To turn off concurrency
 * #define NoConcurrent
 *
 * On certain older platforms you might need to
 * #define PTHREAD_MUTEX_RECURSIVE PTHREAD_MUTEX_RECURSIVE_NP
 * to build with concurreny enabled
 *
 * If you don't have native coswitch (rswitch.s), you must 
 * #define NoNativeCoswitch
 */

