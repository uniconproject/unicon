/*
 * Group of include files for translators, etc. 
 */

#include "../h/define.h"

#if CSET2V2
   #include <io.h>
#endif					/* CSet/2 ver 2 */

#if !VMS && !UNIX	 /* don't need path.h */
   #include "../h/path.h"
#endif					/* !VMS && !UNIX */

#include "../h/config.h"
#include "../h/sys.h"
#include "../h/typedefs.h"
#include "../h/cstructs.h"
#include "../h/proto.h"
#include "../h/cpuconf.h"

#ifdef HAVE_GETADDRINFO
#undef HAVE_GETADDRINFO
#endif 

#ifdef ConsoleWindow
   #include "../h/rmacros.h"
   #include "../h/rstructs.h"
   #include "../h/graphics.h"
   #include "../h/rexterns.h"
   #include "../h/rproto.h"
#endif					/* ConsoleWindow */

#ifdef mdw_Instrument_Allocations
extern void * _alloc(unsigned int, char *, int);
#define alloc(n) (_alloc((n),__FILE__,__LINE__))
#endif /* mdw_Instrument_Allocations */

/* mdw: squelch redef of "OF" as gcc warning */
#ifdef OF
#undef OF
#endif

/* mdw: squelch redef of "Type" as gcc warning */
#ifdef Type
#undef Type
#endif

