/*
 * tpdssl.h: Define SSL-based discipline for libtp.
 */

#ifndef _SSL_DISC_H_
#define _SSL_DISC_H_

typedef struct _tpssldisc_s Tpssldisc_t;

struct _tpssldisc_s
{
  Tpdisc_t tpdisc;
  BIO *bio;
  SSL_CTX *ctx;
  SSL *ssl;
};

#endif /* !_SSL_DISC_H_ */
