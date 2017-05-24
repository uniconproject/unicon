/**********************************************************************\
* tpdunix.h: Define Unix socket()-based discipline for libtp.          *
* -------------------------------------------------------------------- *
*      (c) Copyright 2000 by Steve Lumos.  All rights reserved.        *
\**********************************************************************/

#ifndef TPDUNIX_H
#define TPDUNIX_H

typedef struct _tpunixdisc_s Tpunixdisc_t;

struct _tpunixdisc_s
{
  Tpdisc_t tpdisc;
  int fd;        /* File descriptor for file or socket */
};

#endif /* !TPDUNIX_H */
