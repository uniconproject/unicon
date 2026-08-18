/*
 * ssl_dtls.c - DTLS handshake helpers for encrypted UDP (nue/naue).
 */

#include "../h/gsupport.h"

#if HAVE_LIBSSL
#if UNIX
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#endif                                  /* UNIX */
#ifdef NT
#include <winsock2.h>
#include <ws2tcpip.h>
#endif                                  /* NT */
#endif                                  /* HAVE_LIBSSL */

#if HAVE_LIBSSL

#ifndef OPENSSL_NO_DTLS

#define DTLS_COOKIE_SECRET_LEN 16

static unsigned char dtls_cookie_secret[DTLS_COOKIE_SECRET_LEN];
static int dtls_cookie_ready = 0;

extern int sock_udp_connect_saved(int fd);

static int dtls_generate_cookie(SSL *ssl, unsigned char *cookie,
                                unsigned int *cookie_len)
{
   (void)ssl;
   if (!dtls_cookie_ready) {
      if (RAND_bytes(dtls_cookie_secret, DTLS_COOKIE_SECRET_LEN) != 1)
         return 0;
      dtls_cookie_ready = 1;
      }
   memcpy(cookie, dtls_cookie_secret, DTLS_COOKIE_SECRET_LEN);
   *cookie_len = DTLS_COOKIE_SECRET_LEN;
   return 1;
}

static int dtls_verify_cookie(SSL *ssl, const unsigned char *cookie,
                              unsigned int cookie_len)
{
   (void)ssl;
   if (!dtls_cookie_ready || cookie_len != DTLS_COOKIE_SECRET_LEN)
      return 0;
   return CRYPTO_memcmp(cookie, dtls_cookie_secret, DTLS_COOKIE_SECRET_LEN) == 0;
}

static int dtls_want_retry(SSL *ssl, int rv)
{
   int err = SSL_get_error(ssl, rv);
   return err == SSL_ERROR_WANT_READ || err == SSL_ERROR_WANT_WRITE;
}

static int dtls_connect_peer(int fd, BIO_ADDR *peer, void *sa_out)
{
   int family = BIO_ADDR_family(peer);
   unsigned short port = BIO_ADDR_rawport(peer);
   size_t alen;

   if (family == AF_INET) {
      struct sockaddr_in *sin = (struct sockaddr_in *)sa_out;
      memset(sin, 0, sizeof(*sin));
      sin->sin_family = AF_INET;
      sin->sin_port = port;
      alen = sizeof(sin->sin_addr);
      if (!BIO_ADDR_rawaddress(peer, &sin->sin_addr, &alen))
         return -1;
      return connect(fd, (struct sockaddr *)sin, sizeof(*sin));
      }
#ifdef AF_INET6
   if (family == AF_INET6) {
      struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)sa_out;
      memset(sin6, 0, sizeof(*sin6));
      sin6->sin6_family = AF_INET6;
      sin6->sin6_port = port;
      alen = sizeof(sin6->sin6_addr);
      if (!BIO_ADDR_rawaddress(peer, &sin6->sin6_addr, &alen))
         return -1;
      return connect(fd, (struct sockaddr *)sin6, sizeof(*sin6));
      }
#endif
   return -1;
}

int ssl_dtls_accept(SSL *ssl, int fd)
{
   BIO *bio;
   BIO_ADDR *client;
   SSL_CTX *ctx;
   struct timeval tv;
   struct sockaddr_storage peer_sa;
   int rv, tries;

   bio = BIO_new_dgram(fd, BIO_NOCLOSE);
   if (bio == NULL)
      return 0;
   /* Short recv timeout so we can re-enter DTLSv1_listen while the client starts. */
   tv.tv_sec = 1;
   tv.tv_usec = 0;
   BIO_ctrl(bio, BIO_CTRL_DGRAM_SET_RECV_TIMEOUT, 0, &tv);
   BIO_ctrl(bio, BIO_CTRL_DGRAM_SET_SEND_TIMEOUT, 0, &tv);
   SSL_set_bio(ssl, bio, bio);

   ctx = SSL_get_SSL_CTX(ssl);
   SSL_CTX_set_cookie_generate_cb(ctx, dtls_generate_cookie);
   SSL_CTX_set_cookie_verify_cb(ctx, dtls_verify_cookie);
   SSL_set_options(ssl, SSL_OP_COOKIE_EXCHANGE);

   client = BIO_ADDR_new();
   if (client == NULL)
      return 0;
   rv = 0;
   for (tries = 0; tries < 20; tries++) {
      rv = DTLSv1_listen(ssl, client);
      if (rv > 0)
         break;
      if (rv < 0 && !dtls_want_retry(ssl, rv)) {
         BIO_ADDR_free(client);
         return 0;
         }
      }
   if (rv <= 0) {
      BIO_ADDR_free(client);
      return 0;
      }
   if (dtls_connect_peer(fd, client, &peer_sa) < 0) {
      BIO_ADDR_free(client);
      return 0;
      }
   BIO_ADDR_free(client);
   BIO_ctrl(bio, BIO_CTRL_DGRAM_SET_CONNECTED, 0, &peer_sa);
   rv = SSL_accept(ssl);
   while (rv <= 0 && dtls_want_retry(ssl, rv))
      rv = SSL_accept(ssl);
   return rv == 1;
}

int ssl_dtls_connect(SSL *ssl, int fd)
{
   BIO *bio;
   struct sockaddr_storage peer;
   socklen_t peerlen = sizeof(peer);
   struct timeval tv;
   int rv;

   /* Unicon UDP sockets are unconnected; connect to open()'s peer. */
   if (sock_udp_connect_saved(fd) < 0)
      return 0;
   if (getpeername(fd, (struct sockaddr *)&peer, &peerlen) < 0)
      return 0;
   bio = BIO_new_dgram(fd, BIO_NOCLOSE);
   if (bio == NULL)
      return 0;
   tv.tv_sec = 5;
   tv.tv_usec = 0;
   BIO_ctrl(bio, BIO_CTRL_DGRAM_SET_RECV_TIMEOUT, 0, &tv);
   BIO_ctrl(bio, BIO_CTRL_DGRAM_SET_SEND_TIMEOUT, 0, &tv);
   BIO_ctrl(bio, BIO_CTRL_DGRAM_SET_CONNECTED, 0, &peer);
   SSL_set_bio(ssl, bio, bio);
   rv = SSL_connect(ssl);
   while (rv <= 0 && dtls_want_retry(ssl, rv))
      rv = SSL_connect(ssl);
   return rv == 1;
}

#else /* OPENSSL_NO_DTLS */

int ssl_dtls_accept(SSL *ssl, int fd)
{
   (void)ssl;
   (void)fd;
   return 0;
}

int ssl_dtls_connect(SSL *ssl, int fd)
{
   (void)ssl;
   (void)fd;
   return 0;
}

#endif /* OPENSSL_NO_DTLS */

#endif /* HAVE_LIBSSL */
