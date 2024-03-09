
/*
 * posix.h - includes for posix interface
 */

/*
 * Copyright 1997 Shamim Mohamed.
 *
 * Modification and redistribution is permitted as long as this (and any
 * other) copyright notices are kept intact.
 */

#if UNIX
#include <sys/wait.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <time.h>
#include <dirent.h>
#include <unistd.h>
#include <utime.h>
#include <sys/resource.h>

#include <fcntl.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <pwd.h>
#include <grp.h>
#endif                                  /* UNIX */


#ifdef NT

#include<ws2tcpip.h>

#include <sys/timeb.h>
#include <sys/locking.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/utime.h>
#include <fcntl.h>
#include <io.h>
#include <time.h>
#include <process.h>
#define NAME_MAX FILENAME_MAX
#ifdef PATH_MAX
#undef PATH_MAX
#endif                                          /* PATH_MAX */
#define PATH_MAX FILENAME_MAX
#define MAXHOSTNAMELEN          256
#else                                   /* NT */
#ifndef NAME_MAX
#define NAME_MAX _POSIX_NAME_MAX
#endif                                  /* not defined NAME_MAX */
#define SOCKET int
#endif                                  /* NT */

#if defined(SUN) || defined(HP) || defined(IRIS4D)
#include <sys/file.h>

extern int sys_nerr;
extern char *sys_errlist[];

#ifndef UX10
#ifndef NAME_MAX
#define NAME_MAX 1024
#endif                                  /* NAME_MAX */
#endif


#ifdef SYSV
#define bcopy(a, b, n) memcopy(b, a, n)
#endif
#endif                                  /* SUN || HP */

#ifdef HP
#define FASYNC O_SYNC
#endif

#if defined(BSD) || defined(HP) || defined(BSD_4_4_LITE)
#include <sys/param.h>
#endif

#if (defined(BSD) || defined(BSD_4_4_LITE)) && !defined(MacOS)
#define Setpgrp() setpgrp(0, 0)
#else
#define Setpgrp() setpgrp()
#endif

extern stringint signalnames[];

#ifdef IRIS4D
#include <limits.h>
#include <sys/param.h>
#endif                                  /* IRIS4D */

#ifdef NT
extern WORD wVersionRequested;
extern WSADATA wsaData;
extern int werr;
extern int WINSOCK_INITIAL;
#endif                                  /* NT */
