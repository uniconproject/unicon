/**********************************************************************\
* uri_pop.c: Functions for parsing POP URLs                            *
* -------------------------------------------------------------------- *
*      Copyright 1999-2000 by Steve Lumos.  All rights reserved.       *
\**********************************************************************/

/*
 * These functions are NOT designed to be called by client code.  You
 * should use uri_parse instead.
 */

#include <stdlib.h>
#include <string.h>
#include <errno.h>

#include "uri.h"
#include "uri_schm.h"


PURI _pop_parse(char *uri, PURI puri);

const SCHEME scPOP  = { "pop", _pop_parse, 110 };

/* 
 * Expects the scheme part (i.e. "http:") to have already been
 * removed, and the scheme and default port to be set in the
 * structure.
 *
 * From RFC2384: pop://<user>;auth=<auth>@<host>:<port>
 *
 * Since RFC2384 does not allow specification of a password, we
 * have to break it and accept pop://<user>:<pass>@<host>:<port>
 */
PURI _pop_parse(char *uri, PURI puri)
{
  char *colon;
  char *at;
  
  if (uri[0] == '/' && uri[1] == '/') {
    uri += 2;
  }
  else {
    puri->status = URI_EMALFORMED;
    return puri;
  }

  /* User is required */
  at = strchr(uri, '@');
  if (!at) {
    puri->status = URI_ENOUSER;
    return puri;
  }

  /* Path is prohibited */
  if (strchr(at, '/')) {
    puri->status = URI_EMALFORMED;
    return puri;
  }

  colon = strchr(uri, ':');
  if (colon && colon < at) {
    /* user and password */
    puri->user = (char *)malloc(colon - uri + 1);
    if (!puri->user) {
      puri->status = URI_ECHECKERRNO;
      return puri;
    }
    puri->user[0] = '\0';
    strncat(puri->user, uri, colon - uri);
    
    puri->pass = (char *)malloc(at - colon + 1);
    if (!puri->pass) {
      puri->status = URI_ECHECKERRNO;
      return puri;
    }
    puri->pass[0] = '\0';
    strncat(puri->pass, colon + 1, at - colon - 1);
    colon = strchr(at, ':');
  }
  else {
    /* user but no password */
    puri->user = (char *)malloc(at - uri + 1);
    if (!puri->user) {
      puri->status = URI_ECHECKERRNO;
      return puri;
    }
    puri->user[0] = '\0';
    strncat(puri->user, uri, at - uri);
  }

  if (colon) {
    /* host and port */
    puri->host = (char *)malloc(colon - at + 1);
    if (!puri->host) {
      puri->status = URI_ECHECKERRNO;
      return puri;
    }
    puri->host[0] = '\0';
    strncat(puri->host, at + 1, colon - at - 1);
    puri->port = atoi(colon+1);
    puri->sport = strdup(colon + 1);
  }
  else {
    /* only host */
    puri->host = (char *)malloc(strlen(at) + 1);
    if (!puri->host) {
      puri->status = URI_ECHECKERRNO;
      return puri;
    }
    strcpy(puri->host, at + 1);
  }

  puri->status = URI_SUCCESS;
  return puri;
}
