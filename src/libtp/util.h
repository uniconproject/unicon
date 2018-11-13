/**********************************************************************\
* util.h: Definitions for functions that don't exist on all systems.   *
* -------------------------------------------------------------------- *
*      (c) Copyright 2000 by Steve Lumos.  All rights reserved.        *
\**********************************************************************/

#ifndef _UTIL_H_
#define _UTIL_H_ 1
#include "../h/sys.h"

#ifndef HAVE_BZERO
# ifdef HAVE_MEMSET
#  define bzero(b, len) memset((b), 0, (len))
# else /* !HAVE_MEMSET */
#  error need bzero(3) or memset(3)
# endif /* HAVE_MEMSET */
#endif /* !HAVE_BZERO */

#ifndef HAVE_MEMCPY
# ifdef HAVE_BCOPY
#  define memcpy(dst, src, len) bcopy((src), (dst), (len))
# else /* !HAVE_BCOPY */
#  error need memcpy(3) or bcopy(3)
# endif /* HAVE_BCOPY */
#endif /* !HAVE_MEMCPY */

#ifndef HAVE_INET_PTON
int inet_pton(int family, const char* s, void* addr);
#endif

#ifndef HAVE_SNPRINTF
int snprintf(char *str, size_t size, const char *fmt,...);
#endif

char* _tpastrcpy(const char* s, Tpdisc_t* disc);
ssize_t _tpsends(Tpdisc_t* disc, char* fmt, ...);
char *_tpstrcasestr(char *s, char *find);
char* _tptrimnewline(char* s);

#endif /* UTIL_H */
