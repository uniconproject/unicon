/*
 * Group of include files for translators, etc.
 */

#include "../h/define.h"
#include "../h/config.h"

#if CSET2V2
   #include <io.h>
#endif                                  /* CSet/2 ver 2 */

#if !VMS && !UNIX && !Windows    /* don't need path.h */
   #include "../h/path.h"
#endif                                  /* !VMS && !UNIX */

#include "../h/sys.h"
#include "../h/typedefs.h"
#include "../h/cstructs.h"
#include "../h/proto.h"
#include "../h/cpuconf.h"

#ifdef HAVE_GETADDRINFO
#undef HAVE_GETADDRINFO
#endif

#if NT && defined(ConsoleWindow)
   #include "../h/rmacros.h"
   #include "../h/rstructs.h"
   #include "../h/graphics.h"
   #include "../h/rexterns.h"
   #include "../h/rproto.h"
#endif                                  /* ConsoleWindow */

#ifdef IconcLogAllocations
extern void * _alloc(unsigned int, char *, int);
#define alloc(n) (_alloc((n),__FILE__,__LINE__))
#endif                                  /* IconcLogAllocations */

/* squelch redef of "OF" and "Type" - avoid gcc warning */
#ifdef OF
#undef OF
#endif

#ifdef Type
#undef Type
#endif

