/*
 * tpmfinge.c: Method for finger protocol (RFC1288).
 *       Copyright 2000 by Steve Lumos.  All rights reserved.
 */

#include "../h/config.h"

#ifdef STDC_HEADERS
#include <stdlib.h>
#endif
#ifdef HAVE_STRINGS_H
#include <strings.h>
#endif
#include <string.h>

#include "tp.h"

int fingerbegin(Tp_t* tp, Tprequest_t* req)
{
  Tpdisc_t* disc = tp->disc;

  if (!TPSTATE(tp, CONNECTED)) {
    disc->connectf(&tp->uri, disc);
    TPSET(tp, CONNECTED);
  }

  if (tp->uri.path) {
    disc->writef(tp->uri.path, strlen(tp->uri.path), disc);
  }
  disc->writef("\n", 1, disc);
  return 1;
}

Tpresponse_t* fingerend(Tp_t* tp)
{
  static Tpresponse_t fingerresp = { 200, "OK", NULL };
  TPENTER(tp, READING);
  return &fingerresp;
}

int fingerclose(Tp_t* tp)
{
  Tpdisc_t* disc = tp->disc;
  if (!TPSTATE(tp, CLOSED)) {
    disc->closef(disc);
  }
  TPSET(tp, CLOSED);
  return 1;
}

int fingerfree(Tp_t* tp, Tpresponse_t* resp)
{
  return 1;
}

static Tpmethod_t _tpmfinger = { fingerbegin, fingerend, fingerclose,
                                 fingerfree, 0 };
Tpmethod_t* TpmFinger = &_tpmfinger;
