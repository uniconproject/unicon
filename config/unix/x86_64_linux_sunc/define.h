/*
 * Icon configuration file for Linux v2 on Athlon64, Solaris Studio compilers
 */

#define UNIX 1
#define LoadFunc
/* no SysOpt: Linux getopt() is POSIX-compatible only if an envmt var is set */

/* CPU architecture */
#define IntBits 32
#define WordBits 64
#define Double
#define StackAlign 16
#define NEED_UTIME
/* a non-default datatype for SQLBindCol's 6th parameter */
#define SQL_LENORIND SQLLEN

#define NoVFork 1

/*
 * This turns out to be a sore spot: needed on some, an error on others.
 * Want this to be a simple #ifdef, but the use of enums instead of #define's
 * means we can't tell which ones are defined.  Boo!
 */
#if 0
#define PTHREAD_MUTEX_RECURSIVE PTHREAD_MUTEX_RECURSIVE_NP
#endif
