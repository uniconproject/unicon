#include "../h/gsupport.h"

/*
 * redirerr - redirect error output to the named file. '-' indicates that
 *  it should be redirected to standard out.
 */
int redirerr(p)
char *p;
   {
   if ( *p == '-' ) { /* let - be stdout */

/*
 * The following code is operating-system dependent [@redirerr.01].  Redirect
 *  stderr to stdout.
 */

#if PORT
   /* may not be possible */
   Deliberate Syntax Error
#endif                                  /* PORT */

#if MVS || VM
   /* cannot do this */
#endif                                  /* MVS || VM */

#if MSDOS || VMS
   #ifdef _UCRT
     if (_dup2(fileno(stdout), fileno(stderr))) return 0;
   #elif NT
      /*
       * Don't like doing this, but it seems to work.
       */
      setbuf(stdout,NULL);
      setbuf(stderr,NULL);
      stderr->_file = stdout->_file;
   #else                                /* NT */
      if (dup2(fileno(stdout),fileno(stderr)))
        return 0;
   #endif                               /* NT */
#endif                                  /* MSDOS || ... */


#if UNIX
      /*
       * This relies on the way UNIX assigns file numbers.
       */
      close(fileno(stderr));
      if (dup(fileno(stdout) == -1))
          return 0;
#endif                                  /* UNIX */

/*
 * End of operating-system specific code.
 */

       }
    else    /* redirecting to named file */
       if (freopen(p, "w", stderr) == NULL)
          return 0;
   return 1;
   }
