/*
 * tpmpop.c: Post Office Protocol (RFC 1939) support for libtp.
 *      (c) Copyright 2000 by Steve Lumos.  All rights reserved.
 */

#include "../h/config.h"

#ifdef STDC_HEADERS
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#endif

#include "tp.h"
#include "util.h"

int popclose(Tp_t* tp);

int popbegin(Tp_t* tp, Tprequest_t* req)
{
  Tpdisc_t* disc = tp->disc;
  char* user = "";
  char* pass = NULL;
  char* auth = NULL;
  char* semi = NULL;
  char buf[4096];

  if ((semi = strchr(tp->uri.user, ';'))) {
    user = (char*)disc->memf(semi - tp->uri.user + 1, disc);
    strncat(user, tp->uri.user, semi - tp->uri.user);
    auth = semi + 1;
  }
  else {
    user = tp->uri.user;
  }

  pass = tp->uri.pass;

  if ((auth != NULL) && (strcmp(auth, "USER") != 0)) {
    disc->exceptf(TPM_UNIMPLEMENTED, auth, disc);
    return -1;
  }

  if (!TPIN(tp, CONNECTED)) {
    disc->connectf(&tp->uri, disc);
    disc->readlnf(buf, sizeof(buf), disc);
    if (strncasecmp(buf, "+OK", 3) != 0) {
      popclose(tp);
      disc->exceptf(TP_ESERVER, buf, disc);
      return -1;
    }
    TPSET(tp, CONNECTED);

    _tpsends(disc, "USER %s\r\n", user);
    disc->readlnf(buf, sizeof(buf), disc);
    if (strncasecmp(buf, "+OK", 3) != 0) {
      popclose(tp);
      disc->exceptf(TP_ESERVER, buf, disc);
      return -1;
    }

    _tpsends(disc, "PASS %s\r\n", pass);
    disc->readlnf(buf, sizeof(buf), disc);
    if (strncasecmp(buf, "+OK", 3) != 0) {
      popclose(tp);
      disc->exceptf(TP_ESERVER, buf, disc);
      return -1;
    }
  }

  switch (req->type)
  {
    case DELE:
      if (req->args == NULL) {
        disc->exceptf(TP_EINVAL, NULL, disc);
        return -1;
      }
      _tpsends(disc, "DELE %s\r\n", req->args);
      TPSET(tp, CONNECTED);
      break;

    case LIST:
      if (req->args != NULL) {
        _tpsends(disc, "LIST %s\r\n", req->args);
      }
      else {
        disc->writef("LIST\r\n", 6, disc);
      }
      TPENTER(tp, READING);
      break;

    case QUIT:
      return popclose(tp);

    case RETR:
      if (req->args == NULL) {
        disc->exceptf(TP_EINVAL, NULL, disc);
        return -1;
      }
      _tpsends(disc, "RETR %s\r\n", req->args);
      TPENTER(tp, READING);
      break;

    case STAT:
      disc->writef("STAT\r\n", 6, disc);
      break;

    default:
      disc->exceptf(TPM_UNSUPPORTED, req, disc);
      return -1;
  }

  return 1;
}

Tpresponse_t* popend(Tp_t* tp)
{
  Tpdisc_t* disc = tp->disc;
  Tpresponse_t* resp;
  char buf[4096];

  disc->readlnf(buf, sizeof(buf), disc);
  resp = (Tpresponse_t*)disc->memf(sizeof(Tpresponse_t), disc);
  bzero(resp, sizeof(Tpresponse_t));
  if (strncasecmp(buf, "+OK", 3) != 0) {
    resp->sc = 500;
    if (TPIN(tp, READING)) {
      TPSET(tp, CONNECTED);
    }
  }
  else {
    resp->sc = 200;
  }

  resp->msg = _tpastrcpy(buf, disc);

  return resp;
}

int popclose(Tp_t* tp)
{
  Tpdisc_t* disc = tp->disc;
  char buf[4096];

  disc->writef("QUIT\r\n", 6, disc);
  disc->readlnf(buf, sizeof(buf), disc);
  disc->closef(disc);
  return 1;
}

int popfree(Tp_t* tp, Tpresponse_t* resp)
{
  Tpdisc_t* disc = tp->disc;

  if (resp->msg) disc->freef(resp->msg, disc);
  if (resp->header) disc->freef(resp->header, disc);

  disc->freef(resp, disc);
  return 1;
}

static Tpmethod_t _tpmpop = { popbegin, popend, popclose, popfree, 0 };
Tpmethod_t* TpmPOP = &_tpmpop;
