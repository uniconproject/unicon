/**********************************************************************\
* uri.c: Parse URLs.                                                   *
* -------------------------------------------------------------------- *
*    (c) Copyright 1999-2000 by Steve Lumos.  All rights reserved.     *
\**********************************************************************/

/* See RFC 1738 <URL:http://www.ietf.org/rfc/rfc1738.txt>
 *     RFC 2396 <URL:http://www.ietf.org/rfc/rfc2396.txt> */

/* TODO:
 *
 *  - Handle PROXY if applicable */

#include <stdlib.h>
#include <string.h>
#include <errno.h>

#include "uri.h"
#include "uri_schm.h"

const char* const _uri_errlist[] = {
  "Success - No error",       /* 0 - URI_SUCCESS */
  "Malformed URI",            /* 1 - URI_EMALFORMED */
  "Missing username",         /* 2 - URI_NOUSER */
  "Unknown scheme",           /* 3 - URI_EUNKNOWNSCHEME */
  "System error (see errno)"  /* 4 - URI_ECHECKERRNO */
};

PURI uri_parse(char *uri, int af_fam)
{
  char *colon;
  PURI puri;

  puri = uri_new();
  if (puri == NULL) {
    return puri;
  }

  puri->af_family = af_fam;

  /* Get the scheme */
  colon = strchr(uri, ':');
  if (!colon) {
    puri->status = URI_EMALFORMED;
    return puri;
  }

  puri->scheme = (char *)malloc(colon - uri + 1);
  if (puri->scheme == NULL) {
    puri->status = URI_ECHECKERRNO;
    return puri;
  }
  puri->scheme[0] = '\0';
  strncat(puri->scheme, uri, colon - uri);

  /* Check for optional "URL:" */
  if (strcmp(puri->scheme, "URL") == 0) {
    uri_free(puri);
    return uri_parse(colon+1, af_fam);
  }
  else {
    /* Call the parse function for this scheme */
    int i = 0;
    while (schemes[i] != 0) {
      if (!strcmp(schemes[i]->name, puri->scheme)) {
        /* Load default port here since different schemes
         * might use the same parser */
        puri->port = schemes[i]->port;
        puri->is_explicit_port = schemes[i]->is_explicit_port;
        return schemes[i]->parse(colon+1, puri);
      }
      i++;
    }
  }
  /* We don't have a parse function */
  puri->status = URI_EUNKNOWNSCHEME;
  return puri;
}

PURI uri_new(void)
{
  PURI puri = (PURI)malloc(sizeof(URI));

  if (puri == NULL) {
    return NULL;
  }

  puri->scheme = NULL;
  puri->user = NULL;
  puri->pass = NULL;
  puri->host = NULL;
  puri->sport = NULL;
  puri->port = 0;
  puri->is_explicit_port = 0;
  puri->path = NULL;

  return puri;
}

void uri_free(PURI puri)
{
  if (puri->scheme != NULL) {
    free(puri->scheme);
  }

  if (puri->user != NULL) {
    free(puri->user);
  }

  if (puri->pass != NULL) {
    free(puri->pass);
  }

  if (puri->host != NULL) {
    free(puri->host);
  }

  if (puri->sport != NULL) {
    free(puri->sport);
  }
  /* (port is not a pointer) */

  if (puri->path != NULL) {
    free(puri->path);
  }
}
