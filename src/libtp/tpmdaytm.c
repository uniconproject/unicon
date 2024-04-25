/*
 * tpmdaytime.c: RFC 876 protocol METHOD for libtp.
 *       Copyright 2000 by Steve Lumos.  All rights reserved.
 */

#include "../h/config.h"
#include "tp.h"
#include "util.h"

#ifdef STDC_HEADERS
#include <stdlib.h>
#endif

/* Connect to daytime server.  req is ignored. */
int daytimebegin(Tp_t* tp, Tprequest_t* req)
{
  Tpdisc_t* disc = tp->disc;

  if (!TPSTATE(tp, CONNECTED)) {
    if (disc->connectf(&tp->uri, disc) < 0) {
      return (-1);
    }
    else {
      TPENTER(tp, CONNECTED);
    }
  }
  return 1;
}

Tpresponse_t* daytimeend(Tp_t* tp)
{
  char buf[1024];
  ssize_t n;
  Tpdisc_t* disc = tp->disc;
  Tpresponse_t* resp;

  resp = (Tpresponse_t*)disc->memf(sizeof(Tpresponse_t), disc);
  n = disc->readf(buf, sizeof(buf)-1, disc);
  if (n < 0) {
    resp->sc = 500;
    resp->msg  = "Read Error";
    resp->header = NULL;
    return resp;
  }

  buf[n+1] = '\0';
  disc->closef(disc);
  TPSET(tp, CLOSED);
  resp->sc = 200;
  resp->msg  = _tpastrcpy(buf, disc);
  resp->header = NULL;
  return resp;
}

int daytimeclose(Tp_t* tp)
{
  Tpdisc_t* disc = tp->disc;

  if (!TPSTATE(tp, CLOSED)) {
    disc->closef(disc);
    TPSET(tp, CLOSED);
  }
  return 1;
}

int daytimefree(Tp_t* tp, Tpresponse_t* resp)
{
  Tpdisc_t* disc = tp->disc;

  if (disc->freef) {
    disc->freef(resp->msg, disc);
    disc->freef(resp, disc);
  }
  return 1;
}

static Tpmethod_t _tpmdaytime = { daytimebegin, daytimeend, daytimeclose,
                                  daytimefree, 0 };
Tpmethod_t* TpmDaytime = &_tpmdaytime;
