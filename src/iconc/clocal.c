/*
 *  clocal.c -- compiler functions needed for different systems.
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
extern unsigned _stklen = 8192;
#endif					/* TURBO */

#endif					/* MSDOS */

#if MVS || VM
#endif					/* MVS || VM */

#if OS2
#endif					/* OS2 */

#if UNIX
#endif					/* UNIX */

#if VMS
#endif					/* VMS */

/*
 * End of operating-system specific code.
 */

char *tjunk;			/* avoid empty module */
