/**********************************************************************\
* uri_http.c: Functions for parsing HTTP URLs                          *
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
#include <ctype.h>

#include "uri.h"
#include "uri_schm.h"

static const char *URI_DEFAULT_PATH="/";

PURI _http_parse(char *uri, PURI puri);

const SCHEME scHTTP  = { "http", _http_parse, 80 };
const SCHEME scHTTPS = { "https", _http_parse, 443 };

/* 
 * Expects the scheme part (i.e. "http:") to have already been
 * removed, and the scheme and default port to be set in the
 * structure.
 *
 * From RFCs 1945, 2068: "http:" "//" host [ ":" port ] [ abs_path ] 
 */
PURI _http_parse(char *uri, PURI puri)
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

  /* Get the host and port */

  /* First, look for legal hostname chars per RFC 952. */
  colon = uri;
  while (isalnum((int)*colon) || (*colon == '-') || (*colon == '.')) {
     colon++;
     }
  if (*colon != ':') colon = NULL;

  slash = strchr(uri, '/');
  if (colon) {
    /* With port specified */
    /*FIXME: what if there is nothing after the colon  */
    puri->port = atoi(colon+1);
    puri->sport = strdup(colon + 1);

    puri->host = (char *)malloc(colon - uri + 1);
    if (!puri->host) {
      puri->status = URI_ECHECKERRNO;
      return puri;
    }
    puri->host[0] = '\0';
    strncat(puri->host, uri, colon - uri);
    puri->is_explicit_port = 1;
  }
  else if (slash) {
    /* No port specified */
    puri->host = (char *)malloc(slash - uri + 1);
    if (puri->host == NULL) {
      puri->status = URI_ECHECKERRNO;
      return puri;
    }
    puri->host[0] = '\0';
    strncat(puri->host, uri, slash - uri);
  }
  else {
    /* No port, no path */
    puri->host = (char *)malloc(strlen(uri) + 1);
    strcpy(puri->host, uri);
  }

  /* Get the path */
  if (slash) {
    /* Path specified */
    puri->path = (char *)malloc(strlen(slash) + 1);
    if (puri->path == NULL) {
      puri->status = URI_ECHECKERRNO;
      return puri;
    }
    strcpy(puri->path, slash);
  }
  else {
    /* No path */
    puri->path = (char *)malloc(strlen(URI_DEFAULT_PATH)+1);
    if (!puri->path) {
      puri->status = URI_ECHECKERRNO;
      return puri;
    }
    strcpy(puri->path, URI_DEFAULT_PATH);
  }

  /* Sanity check */
  if (!puri->host || !puri->port || !puri->path) {
    puri->status = URI_EMALFORMED;
    return puri;
  }

  puri->status = URI_SUCCESS;
  return puri;
}
  
