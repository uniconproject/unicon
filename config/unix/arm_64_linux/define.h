/*  
 * Icon configuration file for ARM64 (aarch64) devices such as Raspberry Pi 3
 */

#define UNIX 1
#define LoadFunc
/*#define NoCoexpr*/
/* no SysOpt: Linux getopt() is POSIX-compatible only if an envmt var is set */

#define CComp "gcc"
#define COpts "-Os"
#define NEED_UTIME

/* CPU architecture */
#define IntBits 32
#define WordBits 64
#define Double
#define StackAlign 16

/*
 * you might need to
 * #define PTHREAD_MUTEX_RECURSIVE PTHREAD_MUTEX_RECURSIVE_NP
 */
