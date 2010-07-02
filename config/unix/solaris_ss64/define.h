/*
 * Icon configuration file for Sun 4 running Solaris 2.x with Sun cc
 */

/* configure for Unix System V release 4 */

#define UNIX 1
#define SUN
#define INTMAIN /* int main() */

#define LoadFunc
#define SysOpt
#define NoRanlib

/* CPU architecture */
#define Double
#define StackAlign 8
#define IntBits 32
#define WordBits 64  /* For a 64-bit build */

#define NEED_UTIME
#define Messaging 1
#define PthreadCoswitch 1 /* posix co-expressions */
