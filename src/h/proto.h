/*
 * proto.h -- prototypes for library functions.
 */

/*
 * The following code is operating-system dependent. [@proto.01].
 *  Prototypes for library functions.
 */

#if PORT
   Deliberate Syntax Error
#endif                                  /* PORT */

#if MSDOS
   #if MICROSOFT || TURBO || NT
      #include <dos.h>
   #endif                               /* MICROSOFT || TURBO ... */
#endif                                  /* MSDOS */

/*
 * End of operating-system specific code.
 */

#include "../h/mproto.h"

/*
 * These must be after prototypes to avoid clash with system
 * prototypes.
 */

#if IntBits == 16
   #define sbrk lsbrk
   #define strlen lstrlen
   #define qsort lqsort
#endif                                  /* IntBits == 16 */
