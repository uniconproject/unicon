/*  
 * Icon configuration file for ARM devices such as the Raspberry Pi
 */

#define UNIX 1
#define LoadFunc
/*#define NoCoexpr*/
/* no SysOpt: Linux getopt() is POSIX-compatible only if an envmt var is set */

#define CComp "gcc"
#define COpts "-Os"
#define NEED_UTIME
#define Double

/*
 * #define Concurrent 1
 * here to enable threads. If you do on certain older platforms,
 * you might need to
 * #define PTHREAD_MUTEX_RECURSIVE PTHREAD_MUTEX_RECURSIVE_NP
 * as well.
 */

#define Concurrent 1
