/**********************************************************************\
* unixdisc.h: Define Unix socket()-based discipline for libtp.         *
* -------------------------------------------------------------------- *
*      (c) Copyright 2000 by Steve Lumos.  All rights reserved.        *
\**********************************************************************/

#ifndef _UNIX_DISC_H_
#define _UNIX_DISC_H_

#include "tp.h"

typedef struct _tpunixdisc_s Tpunixdisc_t;

struct _tpunixdisc_s
{
  Tpdisc_t tpdisc;
  int fd;        /* File descriptor for file or socket */
};

enum _tperr {
  TP_RETURNERROR = -1,
  TP_DEFAULT = 0,
  TP_TRYAGAIN = 1,
/*******************/
  TP_ECONNECT,
  TP_EHOST,
  TP_EMEM,
  TP_EOPEN,
  TP_EREAD,
  TP_ESOCKET,
  TP_EWRITE
};

#endif /* !_UNIX_DISC_H_ */
