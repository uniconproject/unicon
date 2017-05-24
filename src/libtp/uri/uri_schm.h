/**********************************************************************\
* uri-schm.h: Definitions for the various URI schemes that the         *
*                library knows about.                                  *
* -------------------------------------------------------------------- *
*    (c) Copyright 1999-2000 by Steve Lumos.  All rights reserved.     *
\**********************************************************************/

#ifndef URI_SCHM_H
#define URI_SCHM_H

#include "uri.h"

/* How to parse for different schemes */
typedef struct _scheme {
  char *name; /* E.g. "ftp", "http" */
  PURI (*parse)(char *uri, PURI puri);
  unsigned short port;     /* Default port */
  char  is_explicit_port;  /* Whether an explicit port was set */  
  
} SCHEME;

extern SCHEME *schemes[];

#endif /*! URI_SCHM_H */
