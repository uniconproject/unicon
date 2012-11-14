/*
 * This used to be an independent autoconf, redundant with Unicon's.
 * Now, we use Unicon's autoconf results, unless Unicon was told not
 * to autoconf.  In that case, try and include the minimum set of
 * includes we need for gdbm.
 */
#include "../h/define.h"

#ifdef NoAuto
#define STDC_HEADERS
#define HAVE_BZERO
#define HAVE_MEMCPY
#define HAVE_SNPRINTF
#define HAVE_ERRNO_H
#define HAVE_NETDB_H
#define HAVE_SYS_TYPES_H
#define HAVE_SYS_SOCKET_H
#define HAVE_ARPA_INET_H
#define HAVE_NETINET_INET_H
#else
#include "../h/auto.h"
#endif
