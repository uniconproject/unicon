/**********************************************************************\
* tpdunix.h: Define Unix socket()-based discipline for libtp.          *
* -------------------------------------------------------------------- *
*      (c) Copyright 2000 by Steve Lumos.  All rights reserved.        *
\**********************************************************************/

#ifndef _UNIX_DISC_H_
#define _UNIX_DISC_H_

typedef struct _tpunixdisc_s Tpunixdisc_t;

struct _tpunixdisc_s
{
  Tpdisc_t tpdisc;
  int fd;        /* File descriptor for file or socket */
};

#endif /* !_UNIX_DISC_H_ */
