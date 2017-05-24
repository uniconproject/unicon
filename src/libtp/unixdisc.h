/**********************************************************************\
* unixdisc.h: Define Unix socket()-based discipline for libtp.         *
* -------------------------------------------------------------------- *
*      (c) Copyright 2000 by Steve Lumos.  All rights reserved.        *
\**********************************************************************/

#ifndef UNIX_DISC_H
#define UNIX_DISC_H

#include "tp.h"

#include "tpdunix.h"

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

#endif /* !UNIX_DISC_H */
