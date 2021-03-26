/*
 * tp.c: User functions for libtp.
 *	 Copyright 2000 by Steve Lumos.  All rights reserved.
 */
#include <stdio.h>

#include "../h/config.h"
#include "tp.h"
#include "util.h"

void tp_free(Tp_t* tp)
{
  Tpdisc_t* disc = tp->disc;

  if (tp == NULL) {
    return;
  }

  if (!TPSTATE(tp, CLOSED)) {
    tp->meth->closef(tp);
  }

  if (tp->uri.scheme) disc->freef(tp->uri.scheme, disc);
  if (tp->uri.user)   disc->freef(tp->uri.user, disc);
  if (tp->uri.pass)   disc->freef(tp->uri.pass, disc);
  if (tp->uri.host)   disc->freef(tp->uri.host, disc);
  if (tp->uri.sport)  disc->freef(tp->uri.sport, disc);
  if (tp->uri.path)   disc->freef(tp->uri.path, disc);

  disc->freef(tp, disc);
}

void tp_freeresp(Tp_t* tp, Tpresponse_t* resp)
{
  if (resp != NULL) {
    tp->meth->freerespf(tp, resp);
  }
}

Tp_t* tp_new(URI* puri, Tpmethod_t* meth, Tpdisc_t* disc)
{
  Tp_t* tp;

  tp = (Tp_t*)disc->memf(sizeof(Tp_t), disc);
  if (!tp) {
    return NULL;
  }

  memset(tp, 0, sizeof(Tp_t));

  /* Deep copy the URI */
  tp->uri.status = puri->status;
  tp->uri.scheme = _tpastrcpy(puri->scheme, disc);
  tp->uri.user   = _tpastrcpy(puri->user, disc);
  tp->uri.pass   = _tpastrcpy(puri->pass, disc);
  tp->uri.host   = _tpastrcpy(puri->host, disc);
  tp->uri.sport  = _tpastrcpy(puri->sport, disc);
  tp->uri.af_family   = puri->af_family;
  tp->uri.port   = puri->port;
  tp->uri.is_explicit_port = puri->is_explicit_port;
  tp->uri.path   = _tpastrcpy(puri->path, disc);

  tp->meth = meth;

  /* Deep copy discipline because it might contain system specific,
     connection unique data (e.g. file descriptor on Unix). */
  tp->disc = disc->newdiscf(disc);

  return tp;
}

Tpdisc_t* tp_newdisc(Tpdisc_t* disc)
{
  return (disc->newdiscf(disc));
}

int tp_begin(Tp_t* tp, Tprequest_t* req)
{
  return tp->meth->beginf(tp, req);
}

Tpresponse_t* tp_end(Tp_t* tp)
{
  return tp->meth->endf(tp);
}

Tpresponse_t* tp_sendreq(Tp_t* tp, Tprequest_t* req)
{
  tp->meth->beginf(tp, req);
  return tp->meth->endf(tp);
}

int tp_quickreq(Tp_t* tp, char* req, char* resp, size_t n)
{
  Tprequest_t tpreq;
  Tpresponse_t* tpresp = NULL;

  tpreq.type = GET;
  tpreq.header = req;
  tpresp = tp_sendreq(tp, &tpreq);
  if (tpresp->msg) {
    strncpy(resp, tpresp->msg, n);
  }
  tp->meth->freerespf(tp, tpresp);
  return 1;
}

ssize_t tp_read(Tp_t* tp, void* buf, size_t n)
{
  Tpdisc_t* disc = tp->disc;
  size_t nleft = n;
  char* p = buf;

  if (!TPSTATE(tp, READING)) {
    int rc = disc->exceptf(TP_STATENOTREADING, tp, disc);
    if (!(rc == TP_TRYAGAIN && TPSTATE(tp, READING))) {
      return (-1);
    }
  }

  if (tp->rptr) {
    while (nleft-- > 0 && tp->rlen-- > 0) {
      *(p++) = *(tp->rptr++);
    }
  }

  if (tp->rlen <= 0) {
    tp->rptr = NULL;
    tp->rlen = 0;
  }

  return ((n - nleft) + disc->readf(p, nleft, disc));
}

ssize_t tp_readln(Tp_t* tp, void* buf, size_t n)
{
  Tpdisc_t* disc = tp->disc;
  char* p = buf;
  size_t nleft = n;
  
  if (!TPSTATE(tp, READING)) {
    int rc = disc->exceptf(TP_STATENOTREADING, tp, disc);
    if (!(rc == TP_TRYAGAIN && TPSTATE(tp, READING))) {
      return (-1);
    }
  }

  if (tp->rptr) {
    while (nleft-- > 0 && tp->rlen-- > 0) {
      int c = *(tp->rptr++);
      if (c == '\n') {
	*(p++) = '\0';
	return (n - nleft);
      }
      *(p++) = *(tp->rptr++);
    }
  }

  if (tp->rlen <= 0) {
    tp->rptr = NULL;
    tp->rlen = 0;
  }

  return ((n - nleft) + disc->readlnf(buf, n, disc));
}

ssize_t tp_write(Tp_t* tp, void* buf, size_t n)
{
  Tpdisc_t* disc = tp->disc;
  
  if (!TPSTATE(tp, WRITING)) {
    int rc = disc->exceptf(TP_STATENOTWRITING, tp, disc);
    if (!(rc == TP_TRYAGAIN && TPSTATE(tp, WRITING))) {
      return (-1);
    }
  }
  return (disc->writef(buf, n, disc));
}

char* tp_headerfield(char *header, char *field)
{
  char *val;

  if (header == NULL || field == NULL) {
    return NULL;
  }

  /* Find the field */
  val = _tpstrcasestr(header, field);
  
  if (val != NULL) {
    /* Skip the field name */
    val = strchr(val, ':');

    /* Skip whitespace and ':' */
    while (strchr(": \t", *val)) {
      val++;
    }
  }
  return val;
}
  
