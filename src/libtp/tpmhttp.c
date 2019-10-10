/*
 * tpmhttp.c: HTTP (RFC 1945) Method for libtp
 *      (c) Copyright 2000 by Steve Lumos.  All rights reserved.
 */

/* TODO:
 *
 * - Do HTTP authentication if necessary. An Authorization header line
 *   can already be appended easily.
 */

#include "../h/config.h"

#ifdef STDC_HEADERS
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#endif

#ifdef HAVE_STRINGS_H
#include <strings.h> /* For bzero() on Solaris */
#endif

#include "tp.h"
#include "util.h"

const char* HTTP_VERSION = "1.0";

int httpbegin(Tp_t* tp, Tprequest_t* req)
{
  Tpdisc_t* disc;
  char buf[4096];

  disc = tp->disc;

  switch (req->type)
  {
    /* Why I think GET and HEAD can use the same code:
     *   1) Both want to go into the READING state to prevent
     *      writes from happening, and
     *   2) If they try to read after making a HEAD request,
     *      we'll get EOF, which is fine. */
    case GET: case HEAD:
      if (!TPSTATE(tp, CONNECTED)) {
        disc->connectf(&tp->uri, disc);
      }
      snprintf(buf, sizeof(buf), "%s %s HTTP/%s\r\n", 
               (req->type == GET) ? "GET" : "HEAD",
               tp->uri.path, HTTP_VERSION);
      disc->writef(buf, strlen(buf), disc);
      if (req->header) {
        disc->writef(req->header, strlen(req->header), disc);
      }
      disc->writef("\r\n", 2, disc);  /* End of header marker */
      TPENTER(tp, READING);
      break;

    case POST:
      if (!TPSTATE(tp, CONNECTED)) {
        disc->connectf(&tp->uri, disc);
      }
      snprintf(buf, sizeof(buf), "POST %s HTTP/%s\r\n", tp->uri.path, 
               HTTP_VERSION);
      disc->writef(buf, strlen(buf), disc);
      if (req->header) {
        disc->writef(req->header, strlen(req->header), disc);
      }
      disc->writef("\r\n", 2, disc); /* End of header marker */
      TPENTER(tp, WRITING);
      break;

    case PUT:
      if (!TPSTATE(tp, CONNECTED)) {
        disc->connectf(&tp->uri, disc);
      }
      snprintf(buf, sizeof(buf), "PUT %s HTTP/%s\r\n", tp->uri.path,
               HTTP_VERSION);
      disc->writef(buf, strlen(buf), disc);
      if (req->header) {
        disc->writef(req->header, strlen(req->header), disc);
      }
      disc->writef("\r\n", 2, disc);
      TPENTER(tp, WRITING);
      break;

    default:
      disc->exceptf(TPM_UNSUPPORTED, req, disc);
      return (-1);
  }

  return 1;
}

Tpresponse_t* httpend(Tp_t* tp)
{
  Tpdisc_t* disc = tp->disc;
  Tpresponse_t* resp;
  char buf[4096];
  char header[8192];
  size_t nread;
  size_t nleft;
  int i;

  TPLEAVE(tp, WRITING);

  resp = (Tpresponse_t*)disc->memf(sizeof(Tpresponse_t), disc);
  bzero(resp, sizeof(Tpresponse_t));
  resp->sc = TP_ERRCODE + TP_EREAD;

  if (disc->readf(buf, 5, disc) < 0) {
    return resp;
  }

  if (memcmp("HTTP/", buf, 5) != 0) {
    /* We're talking to HTTP/0.9, so pushback the bytes we read */
    memcpy(tp->rbuf, buf, 5);
    TPENTER(tp, READING);
    resp->sc = 200;
    resp->msg = _tpastrcpy("OK (HTTP/0.9)", disc);
    return resp;
  }

  disc->readlnf(buf, sizeof(buf), disc);
  /*
   * Manpage for sscanf says %n fills in an int, not a size_t.
   */
  sscanf(buf, "%*[0-9].%*[0-9] %d %n", &(resp->sc), &i);
  nread = i;

  resp->msg = _tptrimnewline(_tpastrcpy(buf+nread, disc));

  header[0] = '\0';
  nleft = sizeof(header) - 1;
  for(;;) {
    ssize_t len = disc->readlnf(buf, sizeof(buf), disc);
    if (len < 0) {
      TPSET(tp, BAD);
      return resp;
    }

    if (len == 0) {
      break;
    }

    if (strcmp(buf, "\r\n") == 0) {
      break;
    }

    if (strcmp(buf, "\n") == 0) {
      break;
    }

    strncat(header, buf, nleft);
    if (len < nleft) {
      nleft -= len;
    }
    else {
      header[sizeof(header) - 1] = '\0';
      break;
    }
  }

  resp->header = _tptrimnewline(_tpastrcpy(header, disc));
  TPENTER(tp, READING);
  return resp;
}

int httpclose(Tp_t* tp)
{
  Tpdisc_t* disc = tp->disc;

  if (!TPSTATE(tp, CLOSED)) {
    disc->closef(disc);
  }

  TPSET(tp, CLOSED);
  return 1;
}

int httpfree(Tp_t* tp, Tpresponse_t* resp)
{
  Tpdisc_t* disc = tp->disc;

  if (resp->msg) disc->freef(resp->msg, disc);
  if (resp->header) disc->freef(resp->header, disc);

  disc->freef(resp, disc);
  return 1;
}

static Tpmethod_t _tpmhttp = { httpbegin, httpend, httpclose, httpfree, 0 };
Tpmethod_t* TpmHTTP = &_tpmhttp;
