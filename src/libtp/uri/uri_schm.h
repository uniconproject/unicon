/**********************************************************************\
* uri-schm.h: Definitions for the various URI schemes that the         *
*                library knows about.                                  *
* -------------------------------------------------------------------- *
*    (c) Copyright 1999-2000 by Steve Lumos.  All rights reserved.     *
\**********************************************************************/

#ifndef __URI_SCHEMES_H__
#define __URI_SCHEMES_H__

#include "uri.h"

/* How to parse for different schemes */
typedef struct _scheme {
  char *name; /* E.g. "ftp", "http" */
  PURI (*parse)(char *uri, PURI puri);
  int port;   /* Default port */
} SCHEME;

extern SCHEME *schemes[];

#endif /* defined __URI_SCHEMES_H__ */
