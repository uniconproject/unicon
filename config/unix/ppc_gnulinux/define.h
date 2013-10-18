/*  
 * Icon configuration file for GNU/Linux on PPC
 */

#define UNIX 1
#define LoadFunc
/* no SysOpt: GNU/Linux getopt() is POSIX-compatible only if an envmt var is set */

#define CComp "gcc"
#define COpts "-O2 -fomit-frame-pointer"
#define NEED_UTIME

#define Messaging
