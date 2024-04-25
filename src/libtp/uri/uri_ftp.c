/**********************************************************************\
* uri_ftp.c: Parser for ftp URLs.                                      *
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

static const char *URI_DEFAULT_PATH="/";

PURI _ftp_parse(char *uri, PURI puri);

SCHEME scFTP = { "ftp", _ftp_parse, 21 };

/*
 * Expects the scheme part (i.e. "ftp:") to have already been
 * removed, and the scheme and default port to be in the struct.
 *
 * From RFC 1738:
 *   ftpurl         = "ftp://" login [ "/" fpath [ ";type=" ftptype ]]
 *   login          = [ user [ ":" password ] "@" ] hostport
 *   hostport       = host [ ":" port ]
 */
PURI _ftp_parse(char *uri, PURI puri)
{
  char *colon;
  char *slash;
  char *at;

  if (uri[0] == '/' && uri[1] == '/') {
    uri += 2;
  }
  else {
    puri->status = URI_EMALFORMED;
    return puri;
  }

  /* Get username/password */
  at = strchr(uri, '@');
  if (at) {
    colon = strchr(uri, ':');
    if (colon) {
      /* user and pass */
      if ((colon - uri) > 0) {
        puri->user = (char *)malloc(colon - uri + 1);
        if (!puri->user) {
          puri->status = URI_ECHECKERRNO;
          return puri;
        }
        puri->user[0] = '\0';
        strncat(puri->user, uri, colon - uri);

        puri->pass = (char *)malloc(at - colon + 1);
        if (!puri->user) {
          puri->status = URI_ECHECKERRNO;
          return puri;
        }
        puri->pass[0] = '\0';
        strncat(puri->pass, colon + 1, at - colon - 1);
      }
      else {
        /* empty user is illegal */
        puri->status = URI_ENOUSER;
        return puri;
      }
    }
    else {
      /* user only */
      puri->user = (char *)malloc(at - uri + 1);
      puri->user[0] = '\0';
      strncat(puri->user, uri, at - uri);
    }

    /* skip to host */
    uri = at + 1;
  }

  /* Get the host and port */
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
    puri->host = (char *)malloc(slash - uri);
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
    if (puri->host == NULL) {
      puri->status = URI_ECHECKERRNO;
      return puri;
    }
    strcpy(puri->host, uri);
  }

  /* Get the path */
  if (slash) {
    /* Path specified */
    puri->path = (char *)malloc(strlen(slash));
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

