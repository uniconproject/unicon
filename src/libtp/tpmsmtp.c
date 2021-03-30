/*
 * tpmsmtp.c: SMTP (RFC 821) method for libtp.
 *      (c) Copyright 2000 by Steve Lumos.  All rights reserved.
 */

#include "../h/config.h"

#ifdef STDC_HEADERS
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#ifndef HAVE_LIBPNG
#include <setjmp.h>
#endif					/* HAVE_LIBPNG */
#endif

#include "tp.h"
#include "util.h"

int smtpclose(Tp_t* tp);

int smtpbegin(Tp_t* tp, Tprequest_t* req)
{
  Tpdisc_t* disc = tp->disc;
  char buf[4096];
  int rc;

  if (!TPIN(tp, CONNECTED)) {
    disc->connectf(&tp->uri, disc);
    disc->readlnf(buf, sizeof(buf), disc);
    rc = atoi(buf);
    while (buf[3] == '-') {
      disc->readlnf(buf, sizeof(buf), disc);
    }
    if (rc == 421) {
      disc->closef(disc);
      TPSET(tp, BAD);
      disc->exceptf(TP_ECONNECT, tp->uri.host, disc);
      return -1;
    }
    TPSET(tp, CONNECTED);
  }
  
  switch (req->type)
  {
    case DATA:
      _tpsends(disc, "DATA\r\n");

      /* We have to handle the DATA response here.  tp_end() will return
       * the reponse from the end of the DATA transaction. */
      disc->readlnf(buf, sizeof(buf), disc);
      rc = atoi(buf);
      if (rc != 354) {
	 disc->exceptf(TP_ECONNECT, "DATA", disc);
	 return (-1);
	 }
      while(buf[3] == '-') disc->readlnf(buf, sizeof(buf), disc);
      _tpsends(disc, "%s\r\n", req->header);
      TPENTER(tp, WRITING);
      break;

    case HELO:
      _tpsends(disc, "HELO %s\r\n", req->args);
      break;

    case MAIL:
      _tpsends(disc, "MAIL FROM:<%s>\r\n", req->args);
      break;

    case RCPT:
      _tpsends(disc, "RCPT TO:<%s>\r\n", req->args);
      break;
  }
  return 1;
}

Tpresponse_t* smtpend(Tp_t* tp)
{
  Tpdisc_t* disc = tp->disc;
  Tpresponse_t* resp;
  char buf[4096];
  char msg[8192];
  size_t nleft;
  size_t len;

  resp = (Tpresponse_t*)disc->memf(sizeof(Tpresponse_t), disc);
  resp->sc = 0;
  resp->msg = NULL;
  resp->header = NULL;

  if (TPIN(tp, WRITING)) {
     disc->writef("\r\n.\r\n", 5, disc);
     }
#pragma GCC diagnostic push
#if __GNUC__ > 7
#  pragma GCC diagnostic ignored "-Wstringop-overflow"
#endif
  disc->readlnf(buf, sizeof(buf), disc);
  resp->sc = atoi(buf);
  msg[0] = '\0';
  nleft = sizeof(msg);
  len = strlen(buf+4);
  strncat(msg, buf+4, (len < nleft) ? len : nleft);
  nleft -= len;

  while (buf[3] == '-' && nleft > 0) {
    disc->readlnf(buf, sizeof(buf), disc);
    len = strlen(buf+4);
    strncat(msg, buf+4, (len < nleft) ? len : nleft);
    nleft -= len;
  }
#pragma GCC diagnostic pop

  resp->msg = _tpastrcpy(msg, disc);

  return resp;
}

int smtpclose(Tp_t* tp)
{
  Tpdisc_t* disc = tp->disc;

  if (!TPSTATE(tp, CLOSED)) {
    disc->writef("QUIT\r\n", 6, disc);
    disc->closef(disc);
  }

  TPSET(tp, CLOSED);
  return 1;
}

int smtpfree(Tp_t* tp, Tpresponse_t* resp)
{
  Tpdisc_t* disc = tp->disc;

  if (resp->msg) disc->freef(resp->msg, disc);
  if (resp->header) disc->freef(resp->header, disc);

  disc->freef(resp, disc);
  return 1;
}

static Tpmethod_t _tpmsmtp = { smtpbegin, smtpend, smtpclose, smtpfree, 0 };
Tpmethod_t* TpmSMTP = &_tpmsmtp;
