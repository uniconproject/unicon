/* Define to `signed' if not defined in <sys/types.h> */
#undef ssize_t

/* Define if running on Solaris 2.4+ which requires defining
 * __EXTENSIONS__ to get prototypes for snprintf() and strncasecmp() */
#ifndef __EXTENSIONS__
#undef __EXTENSIONS__
#endif

/* Define if running on Linux or other GNU Libc system which requires
 * defining _BSD_SOURCE to get prototypes for... */
#ifndef _BSD_SOURCE
#undef _BSD_SOURCE
#endif

/* Define if running on IRIX where /usr/include/sgidefs.h breaks when
 * _LONGLONG is not defined.  Note that libtp does not use long long
 * on any platform. */
#ifndef _LONGLONG
#undef _LONGLONG
#endif
