/*
 * tpdssl.c: SSL discipline for libtp.
 *
 * Portions adapted from
http://www.chesterproductions.net.nz/blogs/it/c/an-ssl-client-using-openssl/245/
 * which says it is under GPL2; get their version of source from there.
 */

#define _SSLDISC_C_

#include "config.h"

#ifdef HAVE_LIBSSL

#include "tp.h"
#include "util.h"

#ifdef STDC_HEADERS
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#endif

#include <openssl/bio.h>
#include <openssl/ssl.h>
#include <openssl/err.h>

extern int unixexcept(int type, void *obj, Tpdisc_t* tpdisc);

#include "tpdssl.h"

#ifdef HAVE_ERRNO_H
#include <errno.h>
#endif

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#ifdef HAVE_NETDB_H
#include <netdb.h>
#endif

#ifdef HAVE_STRINGS_H
#include <strings.h>    /* For bzero(3) on Solaris */
#endif

#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif

#ifdef HAVE_SYS_SOCKET_H
#include <sys/socket.h>
#endif

#ifdef HAVE_NETINET_IN_H
#include <netinet/in.h>
#endif

#ifdef HAVE_ARPA_INET_H
#include <arpa/inet.h>  /* For inet_pton(3) */
#endif

#define MAX_NAME_LOOKUPS 3
#ifndef MAXADDRS
# define MAXADDRS 35
#endif

static int ssl_is_initialized;


/**
 * Initialise OpenSSL
 */
void init_openssl() {
   /* call the standard SSL init functions */
   SSL_load_error_strings();
   SSL_library_init();
   ERR_load_BIO_strings();
   OpenSSL_add_all_algorithms();

   /*
    * systems without '/dev/random' should seed the random number system
    */
   /* RAND_add(?,?,?); need to work out a cryptographically significant way
      of generating the seed */
}

/**
 * Read from a stream and handle restarts if necessary
 */
ssize_t read_from_stream(BIO* bio, char* buffer, ssize_t length) {
   ssize_t r = -1;

   while (r < 0) {
      r = BIO_read(bio, buffer, length);
      if (r == 0) {
         continue;
         }
      else if (r < 0) {
         if (!BIO_should_retry(bio)) {
            /* add exception: "should retry" test failed. */
            continue;
            }
         /* "should retry" test succeeded. */
         /* check the reason for the retry and handle it appropriately here */
	 /* think about whether to set errno to EINTR or some such */
         }
      }
    return r;
}

/**
 * Write to a stream and handle restarts if nessecary
 */
int write_to_stream(BIO* bio, char* buffer, ssize_t length) {
   ssize_t r = -1;
   while (r < 0) {
      r = BIO_write(bio, buffer, length);
      if (r <= 0) {
         if (!BIO_should_retry(bio)) {
            /* add exception: "should retry" test failed. */
            continue;
            }
         /* "should retry" test succeeded. */
         /* check the reason for the retry and handle it appropriately here */
	 /* think about whether to set errno to EINTR or some such */
         }
      }
   return r;
}

/**
 * Connect to a host using an encrypted stream
 */
BIO* connect_encrypted(char* host_and_port, char* store_path, char store_type,
                       SSL_CTX** ctx, SSL** ssl) {
   BIO* bio = NULL;
   int r = 0;

   /* Set up the SSL pointers */
   *ctx = SSL_CTX_new(SSLv23_client_method());
   *ssl = NULL;

   /* Load the trust store from the pem location in argv[2] */
   if (store_type == 'f')
      r = SSL_CTX_load_verify_locations(*ctx, store_path, NULL);
   else
      r = SSL_CTX_load_verify_locations(*ctx, NULL, store_path);
   if (r == 0) {
      /* add exception: Unable to load the trust store from store_path */
      return NULL;
      }

   /* Setting up the BIO SSL object */
   bio = BIO_new_ssl_connect(*ctx);
   BIO_get_ssl(bio, ssl);
   if (!(*ssl)) {
      /* add exception: Unable to allocate SSL pointer. */
      return NULL;
      }
   SSL_set_mode(*ssl, SSL_MODE_AUTO_RETRY);

   /* Attempt to connect */
   BIO_set_conn_hostname(bio, host_and_port);

   /* Verify the connection opened and perform the handshake */
   if (BIO_do_connect(bio) < 1) {
      /* add exception: Unable to connect BIO. */
      return NULL;
      }

   if (SSL_get_verify_result(*ssl) != X509_V_OK) {
      /* if certificate is required, then */
      /* add exception: Unable to verify connection result. */
      }

   return bio;
}

/* upgrade to use environment variable?  or something in discipline? */
char *get_storepath(Tpdisc_t *tpdisc, char *store_typep)
{
   *store_typep = 'f';
   return "/etc/pki/ca-trust/extracted/pem/objsign-ca-bundle.pem";
}

int sslconnect(char* host, u_short port, Tpdisc_t* tpdisc)
{
   char store_type;
   char *store_path = get_storepath(tpdisc, &store_type);
   char *host_and_port = malloc(strlen(host)+7);
   sprintf(host_and_port, "%s:%d", host, port);

   if (!ssl_is_initialized) {
      init_openssl();
      ssl_is_initialized++;
      }
   ((Tpssldisc_t*)tpdisc)->bio =
      connect_encrypted(host_and_port, store_path, store_type,
			&(((Tpssldisc_t*)tpdisc)->ctx),
			&(((Tpssldisc_t*)tpdisc)->ssl));
   free(host_and_port);
   if (((Tpssldisc_t*)tpdisc)->bio == NULL) return -1;
   return 1;
}

/**
 * Close an unencrypted connection gracefully
 */
int sslclose(Tpdisc_t* tpdisc)
{
   int rv;
   if ((rv = BIO_free(((Tpssldisc_t*)tpdisc)->bio)) == 0) {
      /* Error unable to free BIO */
      (void)tpdisc->exceptf(TP_EMEM, NULL, tpdisc);
      }
   return 1;
}

void *sslmem(size_t n, Tpdisc_t* tpdisc)
{
  void *ret;

  if (n < 1) {
    return NULL;
  }

  ret = malloc(n);
  if (ret == NULL) {
    (void)tpdisc->exceptf(TP_EMEM, NULL, tpdisc);
    return NULL;
  }

  return ret;
}

int sslfree(void *p, Tpdisc_t* tpdisc)
{
  free(p);
  return 1;
}

Tpdisc_t* sslnewdisc(Tpdisc_t* tpdisc)
{
  Tpssldisc_t* newdisc = tpdisc->memf(sizeof(Tpssldisc_t), tpdisc);

  if (newdisc == NULL) {
    return NULL;
  }
  memcpy(newdisc, tpdisc, sizeof(Tpssldisc_t));
  return (Tpdisc_t*)newdisc;
}

/* Similar to readn() from [RS98] */
ssize_t sslread(void* buf, size_t n, Tpdisc_t* tpdisc)
{
  size_t  nleft;
  ssize_t nread;
  char*   ptr = buf;

  nleft = n;
  while (nleft > 0) {
    if ((nread = read_from_stream(((Tpssldisc_t*)tpdisc)->bio, ptr, nleft)) <= 0) {
      int action = tpdisc->exceptf(TP_EREAD, &nread, tpdisc);
      if (action > 0) {
	nread = 0;
	continue;
      }
      else if (action == 0 && nread >= 0) {
	break;
      }
      else {
	return (-1);
      }
    }

    nleft -= nread;
    ptr += nread;
  }
  return (n - nleft);
}

/* Similar to readline() from [RS98] */
ssize_t sslreadln(void* buf, size_t maxlen, Tpdisc_t* tpdisc)
{
  Tpssldisc_t* disc = (Tpssldisc_t*)tpdisc;

  ssize_t n, rc;
  char    c;
  char*   ptr = buf;

  for (n=1; n<maxlen; n++) {
  again:
    if ((rc = read_from_stream(disc->bio, &c, 1)) == 1) {
      *ptr++ = c;
      if (c == '\n') {
	break;
      }
    }
    else {
      int action = tpdisc->exceptf(TP_EREAD, &rc, tpdisc);
      switch (action)
      {
	case TP_TRYAGAIN: goto again;
	case TP_DEFAULT:  return 0;

	case TP_RETURNERROR:
	default:          return -1;
      }
#if 0
      if (action TP_TRYAGAIN) {
	goto again;
      }
      else if (action == 0) {
	if (rc == 0) {  /* No data read */
	  return (0);
	}
	else {         /* Some data read before error */
	  break;
	}
      }
      else {
	return (-1);
      }
#endif
    }
  }

  *ptr = '\0';  /* Null terminate */
  return n;
}

/* Similar to writen() from [RS98] */
ssize_t sslwrite(void* buf, size_t n, Tpdisc_t* tpdisc)
{
  Tpssldisc_t* disc = (Tpssldisc_t*)tpdisc;

  size_t nleft;
  ssize_t nwritten;
  const char* cp = buf;

  nleft = n;
  nwritten = 0;
  while(nleft > 0) {
    nwritten = write_to_stream(disc->bio, cp, nleft);
    if (nwritten <= 0) {
      int action = tpdisc->exceptf(TP_EWRITE, NULL, tpdisc);
      if (action <= 0) {
	return -1;
      }
      else {
	nwritten = 0;
	continue;
      }
    }

    nleft -= nwritten;
    cp += nwritten;
  }

  return nwritten;
}

/* The SSL discipline */
static Tpssldisc_t _tpdssl = 
{ { sslconnect, sslclose, sslread, sslreadln, 
    sslwrite, sslmem, sslfree, unixexcept, sslnewdisc, 0 }, 0 };

Tpdisc_t* TpdSSL = (Tpdisc_t *)&_tpdssl;

#else
static char junk;		/* avoid empty module */
#endif					/* HAVE_LIBSSL */
