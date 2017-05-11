/*
 *  tlocal.c -- functions needed for different systems.
 */

#include "../h/gsupport.h"

/*
 * The following code is operating-system dependent [@tlocal.01].
 *  Routines needed by different systems.
 */

#if PORT
/* place to put anything system specific */
Deliberate Syntax Error
#endif					/* PORT */

#if ARM
#include "kernel.h"

/* **** The following line causes a fatal error in some C preprocessors
   **** even if ARM is 0.  Remove the comment characters for ARM.
   ****
*/
/*#define QUOTE " \"\t"*/

int armquote (char *str, char **ret)
{
	char *p;
	static char buf[255];

	if (strpbrk(str,QUOTE) == NULL)
	{
		*ret = str;
		return strlen(str);
	}

	p = buf;

	while (*str && p < &buf[255])
	{
		if (strchr(QUOTE,*str))
		{
			if (p > &buf[252])
				return -1;

			*p++ = '\\';
			*p++ = *str;
		}
		else
			*p++ = *str;

		++str;
	}

	if (p >= &buf[255])
		return -1;

	*p = 0;
	*ret = buf;
	return (p - buf);
}

/* Takes a filename, with a ".u1" suffix, and swaps it, IN PLACE, to
 * conform to Archimedes conventions (u1 as a directory).
 * Note that this is a very simplified version. It relies on the following
 * facts:
 *
 *	1. In the ucode link directives, files ALWAYS end in .u1
 *	2. The input filename is writeable.
 *	3. Files which include directory parts conform to Archimedes
 *	   format (FS:dir.dir.file). Note that Unix formats such as
 *	   "/usr/icon/lib/time" are inherently non-portable, and NOT
 *	   supported.
 *
 * This function is only called from readglob() in C.Lglob.
 */
char *flipname(char *name)
{
	char *p = name + strlen(name) - 1;
	char *q = p - 3;

	/* Copy the leafname to the end */
	while (q >= name && *q != '.' && *q != ':')
		*p-- = *q--;

	/* Insert the "U1." before the leafname */
	*p-- = '.';
	*p-- = '1';
	*p-- = 'U';

	return name;
}
#endif					/* ARM */

#if MSDOS

#if MICROSOFT

pointer xmalloc(n)
   long n;
   {
   return calloc((size_t)n,sizeof(char));
   }
#endif					/* MICROSOFT */

#if MICROSOFT
int _stack = (8 * 1024);
#endif					/* MICROSOFT */

#if TURBO
extern unsigned _stklen = 12 * 1024;
#endif					/* TURBO */

#endif					/* MSDOS */

/*
 * End of operating-system specific code.
 */

/* static char *tjunk; */      		/* avoid empty module */
