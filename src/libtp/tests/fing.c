/**********************************************************************\
* fing.c: Test for libtp finger method.                                *
* -------------------------------------------------------------------- *
*      (c) Copyright 2000 by Steve Lumos.  All rights reserved.        *
\**********************************************************************/

/* Run this program with a finger URL.  Since there is no standard for
 * finger URLs, I used (expired) draft-ietf-uri-url-finger-03.
 * Essentially it looks like:
 *
 *     finger://<host>/[/w ]<username>
 *
 * and either "/w username" or just "username" is sent to the server. 
 */

#ifndef NO_CONFIG_H
#ifndef HAVE_CONFIG_H
#define HAVE_CONFIG_H
#endif
#endif

#ifdef HAVE_CONFIG_H
#include "../../h/config.h"
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <tp.h>

Tpexcept_f tpexcept;
char *url;

int except(int type, void* obj, Tpdisc_t* disc)
{
  int code;

  code = tpexcept(type, obj, disc);
  if (code == -1) {
    perror(url);
    exit(1);
  }
  return code;
}  

int main(int argc, char **argv)
{
  Tp_t* tp;
  Tpdisc_t* disc;
  Tprequest_t   req = { GET, NULL };
  Tpresponse_t* resp;

  char buf[4096];
  PURI  uri;

  if (argc < 2) {
    fprintf(stderr, "usage: %s <finger url>\n", argv[0]);
    exit(1);
  }

  url = argv[1];
  uri = uri_parse(url);
  if (uri->status != URI_OK) {
    fprintf(stderr, "%s: %s\n", url, _uri_errlist[uri->status]);
    exit(1);
  }

  if (strcmp(uri->scheme, "finger") != 0) {
    fprintf(stderr, "%s: not a finger URL\n", url);
    exit(1);
  }

  disc = TpdUnix->newdiscf(TpdUnix);
  tpexcept = disc->exceptf;
  disc->exceptf = except;
  tp = tp_new(uri, TpmFinger, TpdUnix);
  resp = tp_sendreq(tp, &req);
  if (resp->sc < 300) {
    while (tp_readln(tp, buf, sizeof(buf)) > 0) {
      fputs(buf, stdout);
    }
  }
  else {
    fprintf(stderr, "%d %s\n", resp->sc, resp->msg);
    exit(1);
  }
  return 0;
}
