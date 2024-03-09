/*
 * util.c: Replacements for standard functions that don't yet exist on
 *         everything.
 *      (c) Copyright 2000 by Steve Lumos.  All rights reserved.
 */

#include "../h/config.h"
#include "util.h"
#include "tp.h"

#ifdef STDC_HEADERS
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#endif

#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif

#ifdef HAVE_SYS_SOCKET_H
#include <sys/socket.h>
#endif

#ifdef HAVE_NETINET_IN_H
#include <netinet/in.h>
#endif

#ifdef HAVE_ARPA_INET_H
#include <arpa/inet.h>
#endif

#ifdef HAVE_ERRNO_H
# include <errno.h>
#else
# ifdef HAVE_SYS_ERRNO_H
#  include <sys/errno.h>
# else
#  ifdef HAVE_NET_ERRNO_H
#   include <net/errno.h>
#  endif
# endif
#endif

#ifdef HAVE_STRINGS_H
#include <strings.h>  /* For strncasecmp() on Solaris */
#endif

/* Replacements for system library functions: */

#ifndef HAVE_INET_ATON
int inet_aton(const char *cp, struct in_addr *pin);
#endif /* !HAVE_INET_ATON */

#ifndef HAVE_INET_PTON
/* From [RS98] */
int inet_pton(int family, const char* s, void* addr)
{
  if (family == AF_INET) {
    struct in_addr in_val;

    if (inet_aton(s, &in_val)) {
      memcpy(addr, &in_val, sizeof(struct in_addr));
      return 1;
    }

    return 0;
  }

  errno = EAFNOSUPPORT;
  return -1;
}
#endif /* !HAVE_INET_PTON */

#ifndef HAVE_SNPRINTF
#ifdef HAVE_VSPRINTF
int snprintf(char *str, size_t size, const char *fmt,...)
{
  int ret;
  va_list ap;
  va_start(ap, fmt);
  ret = vsprintf(str, fmt, ap);
  va_end(ap);
  return ret;
}
#else /* !HAVE_VSPRINTF */
#error snprintf(3) or vsprintf(3) required
#endif /* HAVE_VSPRINTF */
#endif /* !HAVE_SNPRINTF */

/* Other Functions: */

/* Formated network send */
ssize_t _tpsends(Tpdisc_t* disc, char* fmt, ...)
{
  char* s; /* string */
  char  c; /* character */
  long  l; /* integer */
  char  buf[4096];
  size_t nbuf;
  ssize_t nsent;

  va_list ap;

  nsent = 0;

  va_start(ap, fmt);
  while (*fmt != '\0') {
    nbuf = 0;
    while (*fmt != '%' && *fmt != '\0') {
      buf[nbuf++] = *fmt++;
      if (nbuf >= sizeof(buf)) {
        nbuf = sizeof(buf) - 1; /* paranoia */
        break; /* flush the buffer */
      }
    }

    if (nbuf > 0) {
      nsent += disc->writef(buf, nbuf, disc);
    }

    if (*fmt == '\0') break;
    if (*fmt == '%')  fmt++;
    switch (*fmt)
    {
      case 'c':
        c = va_arg(ap, int);
        nsent += disc->writef(&c, 1, disc);
        break;

      case 'd':
        l = va_arg(ap, long);
        nbuf = snprintf(buf, sizeof(buf), "%ld", l);
        nsent += disc->writef(buf, nbuf, disc);
        break;

      case 's':
        s = va_arg(ap, char*);
        nsent += disc->writef(s, strlen(s), disc);
        break;

      case '%':
        nsent += disc->writef("%", 1, disc);
        break;

      case '\0':
        return nsent;

      default:
        buf[0] = '%';
        buf[1] = *fmt;
        nsent += disc->writef(buf, 2, disc);
    }
    fmt++;
  }
  return nsent;
}

/* Make a copy of s and return a pointer to it. */
char* _tpastrcpy(const char* s, Tpdisc_t* disc)
{
  char *ret;

  if (s == NULL) {
    return NULL;
  }

  if ((ret = disc->memf(strlen(s)+1, disc)) == NULL) {
    return NULL;
  }

  strcpy(ret, s);
  return ret;
}

/* Trim \r and \n from the end of a string. */
char* _tptrimnewline(char* s)
{
  size_t len = strlen(s);

  if (s[len-2] == '\r') {
    s[len-2] = '\0';
  }
  else if (s[len-1] == '\n') {
    s[len-1] = '\0';
  }
  return s;
}

/* Copyrighted functions taken from other sources: */

#ifndef HAVE_INET_ATON
/*
 * ++Copyright++ 1983, 1990, 1993
 * -
 * Copyright (c) 1983, 1990, 1993
 *    The Regents of the University of California.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *      This product includes software developed by the University of
 *      California, Berkeley and its contributors.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * -
 * Portions Copyright (c) 1993 by Digital Equipment Corporation.
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies, and that
 * the name of Digital Equipment Corporation not be used in advertising or
 * publicity pertaining to distribution of the document or software without
 * specific, written prior permission.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND DIGITAL EQUIPMENT CORP. DISCLAIMS ALL
 * WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS.   IN NO EVENT SHALL DIGITAL EQUIPMENT
 * CORPORATION BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
 * DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR
 * PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS
 * ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
 * SOFTWARE.
 * -
 * --Copyright--
 */


/*
 * Check whether "cp" is a valid ascii representation
 * of an Internet address and convert to a binary address.
 * Returns 1 if the address is valid, 0 if not.
 * This replaces inet_addr, the return value from which
 * cannot distinguish between failure and a local broadcast address.
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
        register u_long val;
        register int base, n;
        register int c;
        u_int parts[4];
        register u_int *pp = parts;

        c = *cp;
        for (;;) {
                /*
                 * Collect number up to ``.''.
                 * Values are specified as for C:
                 * 0x=hex, 0=octal, isdigit=decimal.
                 */
                if (!isdigit(c))
                        return (0);
                val = 0; base = 10;
                if (c == '0') {
                        c = *++cp;
                        if (c == 'x' || c == 'X')
                                base = 16, c = *++cp;
                        else
                                base = 8;
                }
                for (;;) {
                        if (isascii(c) && isdigit(c)) {
                                val = (val * base) + (c - '0');
                                c = *++cp;
                        } else if (base == 16 && isascii(c) && isxdigit(c)) {
                                val = (val << 4) |
                                        (c + 10 - (islower(c) ? 'a' : 'A'));
                                c = *++cp;
                        } else
                                break;
                }
                if (c == '.') {
                        /*
                         * Internet format:
                         *      a.b.c.d
                         *      a.b.c   (with c treated as 16 bits)
                         *      a.b     (with b treated as 24 bits)
                         */
                        if (pp >= parts + 3)
                                return (0);
                        *pp++ = val;
                        c = *++cp;
                } else
                        break;
        }
        /*
         * Check for trailing characters.
         */
        if (c != '\0' && (!isascii(c) || !isspace(c)))
                return (0);
        /*
         * Concoct the address according to
         * the number of parts specified.
         */
        n = pp - parts + 1;
        switch (n) {

        case 0:
                return (0);             /* initial nondigit */

        case 1:                         /* a -- 32 bits */
                break;

        case 2:                         /* a.b -- 8.24 bits */
                if (val > 0xffffff)
                        return (0);
                val |= parts[0] << 24;
                break;

        case 3:                         /* a.b.c -- 8.8.16 bits */
                if (val > 0xffff)
                        return (0);
                val |= (parts[0] << 24) | (parts[1] << 16);
                break;

        case 4:                         /* a.b.c.d -- 8.8.8.8 bits */
                if (val > 0xff)
                        return (0);
                val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
                break;
        }
        if (addr)
                addr->s_addr = htonl(val);
        return (1);
}
#endif /* !HAVE_INET_ATON */

/* _tpstrcasestr: like strstr but case insensitive */
char *_tpstrcasestr(char *s, char *find)
{
   register char c, sc;
   register size_t len;

   if ((c = *find++) != 0) {
      len = strlen(find);
      do {
         do {
            if ((sc = *s++) == 0)
               return (NULL);
            } while (tolower(sc) != tolower(c));
         } while (strncasecmp(s, find, len) != 0);
      s--;
      }
   return ((char *)s);
}
