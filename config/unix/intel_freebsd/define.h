/*
 * Icon configuration file for freeBSD
 */

#define UNIX 1
#define GenericBSD
#define BSD_4_4_LITE    1	/* This is new, for 4.4Lite specific stuff */

#define FreeBSD 1
#define NEED_UTIME
#define Messaging 1
#define LoadFunc
#define SysOpt
#define ExecImages

#define MaxStatSize 20480

#define CComp "gcc"
#define COpts "-O2"
#define LinkLibs " -lm"

#define HAVE_GETHOSTNAME 1
#define HAVE_GETPWUID 1
#define HAVE_GETUID 1
