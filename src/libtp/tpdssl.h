/*
 * tpdssl.h: Define SSL-based discipline for libtp.
 */

#ifndef _SSL_DISC_H_
#define _SSL_DISC_H_

#include "tp.h"

typedef struct _tpssldisc_s Tpssldisc_t;

struct _tpssldisc_s
{
  Tpdisc_t tpdisc;
  BIO *bio;
  SSL_CTX *ctx;
  SSL *ssl;
  int encrypt; /* 1=encrypt, 0=don't encrypt. not used yet, encrypt-only. */
  int verify;  /* 1=enforce certificate, 0=anything goes. not used yet. */
};

void tp_set_verify(Tpdisc_t *disc, int val);

#endif /* !_SSL_DISC_H_ */
