/*
 * messaging.h - includes for Internet protocol support
 */

/**********************************************************************\
*       (c) Copyright 2000 by Steve Lumos.  All rights reserved.       *
\**********************************************************************/

#include <tp.h>
#include <setjmp.h>

/* State transition macros */
#define MFIN(mfile, s)    (mfile->state & s)
#define MFSTATE(mfile, s) (mfile->state = s)
#define MFENTER(mfile, s) (mfile->state |= s)
#define MFLEAVE(mfile, s) (mfile->state &= ~(s))

/* Header fields that we know about */
enum {
  H_CONTENT_TYPE = 1,
  H_FROM,
  H_HOST,
  H_LOCATION,
  H_TO,
  H_USER_AGENT
};
#define NUMHEADERS 5

/* Where runerrs for Messaging start */
#define MRUNERRMIN 1200
#define MRUNERRMAX 1250
