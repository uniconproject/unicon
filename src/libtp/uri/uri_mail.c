/**********************************************************************\
* uri_mailto.c: Parse mailto: URLs.                                    *
* -------------------------------------------------------------------- *
*      Copyright 1999-2000 by Steve Lumos.  All rights reserved.       *
\**********************************************************************/

#include <stdlib.h>
#include <string.h>
#include <errno.h>

#include "uri.h"
#include "uri_schm.h"

PURI _mailto_parse(char *uri, PURI puri);

const SCHEME scMAILTO = { "mailto", _mailto_parse, 25 };

/* 
 * Just copies everything to path.  Parsing RFC 822 addresses is the
 * job of the protocol handler.
 */
PURI _mailto_parse(char *uri, PURI puri)
{
  puri->path = (char *)malloc(strlen(uri)+1);
  if (!puri->path) {
    puri->status = URI_SUCCESS;
    return puri;
  }

  strcpy(puri->path, uri);
  
  puri->status = URI_SUCCESS;
  return puri;
}
