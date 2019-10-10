/**********************************************************************\
* uri_finger.c: Parser for finger URLs.                                *
* -------------------------------------------------------------------- *
*      (c) Copyright 2000 by Steve Lumos.  All rights reserved.        *
\**********************************************************************/

#include <stdlib.h>
#include <string.h>
#include <errno.h>

#include "uri.h"
#include "uri_schm.h"

PURI _finger_parse(char *uri, PURI puri);

SCHEME scFinger = { "finger", _finger_parse, 79 };

/* 
 * Expects the scheme part (i.e. "finger:") to have already been
 * removed, and the scheme and default port to be in the struct.
 *
 * From (expired) draft-ietf-uri-url-finger-03:
 *
 * The "finger" URL has the form:
 *
 *     finger://host[:port][/<request>]
 *
 * The <request> must conform with the RFC 1288 request format.
 */
PURI _finger_parse(char *uri, PURI puri)
{
  char *colon;
  char *slash;

  if (uri[0] == '/' && uri[1] == '/') {
    uri += 2;
  }
  else {
    puri->status = URI_EMALFORMED;
    return puri;
  }

  colon = strchr(uri, ':');
  slash = strchr(uri, '/');
  if (colon) {
    /* With port specified */
    puri->port = atoi(colon+1);
    puri->sport = strdup(colon + 1);
    puri->host = (char *)malloc(colon - uri + 1);
    if (!puri->host) {
      puri->status = URI_ECHECKERRNO;
      return puri;
    }
    puri->host[0] = '\0';
    strncat(puri->host, uri, colon - uri);
  }
  else if (slash) {
    /* No port specified */
    puri->host = (char *)malloc(slash - uri + 1);
    if (!puri->host) {
      puri->status = URI_ECHECKERRNO;
      return puri;
    }
    puri->host[0] = '\0';
    strncat(puri->host, uri, slash - uri);
  }
  else {
    /* No port or path */
    puri->host = (char *)malloc(strlen(uri) + 1);
    if (!puri->host) {
      puri->status = URI_ECHECKERRNO;
      return puri;
    }
    strcpy(puri->host, uri);
  }

  /* Get the path */
  if (slash) {
    puri->path = (char *)malloc(strlen(slash) + 1);
    if (!puri->path) {
      puri->status = URI_ECHECKERRNO;
      return puri;
    }
    strcpy(puri->path, slash+1);
  }

  puri->status = URI_SUCCESS;
  return puri;
}
