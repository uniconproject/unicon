/*
 * This used to be an independent autoconf, redundant with Unicon's.
 * Now, we use Unicon's autoconf results, unless Unicon was told not
 * to autoconf.  In that case, try and include the minimum set of
 * includes we need for gdbm.
 */
#include "../h/define.h"

#ifdef NoAuto
#include <fcntl.h>
#include <string.h>
#include <stdlib.h>
#define HAVE_RENAME 1
#else
#include "../h/auto.h"
#endif
