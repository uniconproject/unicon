/* Test for HEAD request of HTTP method for libtp */

/* This program sends an HTTP HEAD request and displays the response
 * from the web server.  It is also an example of the program using
 * its own exception handler. */

#ifndef NO_CONFIG_H
#ifndef HAVE_CONFIG_H
#define HAVE_CONFIG_H
#endif
#endif

#ifdef HAVE_CONFIG_H
#include "../../h/config.h"
#endif

#include "tp.h"

#ifdef STDC_HEADERS
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#endif

#ifdef HAVE_ERRNO_H
#include <errno.h>
#endif

#ifdef HAVE_SYS_ERRNO_H
#include <sys/errno.h>
#endif

Tpexcept_f tpexcept;
char* url;

int exception(int e, void* obj, Tpdisc_t* disc)
{
  int rc = tpexcept(e, obj, disc);
  if (rc == TP_RETURNERROR) {
    if (errno != 0) {
      perror(url);
    }
    else {
      switch (e)
      {
        case TP_EHOST:
          fputs(url, stderr); fputs(": Unknown host\n", stderr);
          break;

        default:
          fputs(url, stderr); fputs(": Error connecting\n", stderr);
      }
    }
    exit(1);
  }
  else {
    return rc;
  }
}

int main(int argc, char **argv)
{
  Tp_t*         tp;
  Tpdisc_t*     disc;
  Tprequest_t   req = { HEAD, "User-Agent: NutScrape CP/M 1.6183\r\n" };
  Tpresponse_t* resp;

  PURI puri;

  if (argc < 2) {
    fprintf(stderr, "usage: %s url\n", argv[0]);
    exit(1);
  }

  url = argv[1];
  puri = uri_parse(url);
  if (puri->status != URI_OK) {
    fprintf(stderr, "%s: %s\n", url, _uri_errlist[puri->status]);
    exit(1);
  }

  if (strcmp(puri->scheme, "http") != 0) {
    fprintf(stderr, "%s: not a http URL\n", url);
    exit(1);
  }

  disc = tp_newdisc(TpdUnix);
  tpexcept = disc->exceptf;
  disc->exceptf = exception;

  tp = tp_new(puri, TpmHTTP, disc);
  resp = tp_sendreq(tp, &req);
  tp_free(tp);

  printf("(%d) [%s]\n<%s>\n", resp->sc, resp->msg, resp->header);
  return 0;
}


