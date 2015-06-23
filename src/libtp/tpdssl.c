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
 * Print SSL error details
 */
void print_ssl_error(char* message, FILE* out) {
   fprintf(out, message);
   fprintf(out, "Error: %s\n", ERR_reason_error_string(ERR_get_error()));
   fprintf(out, "%s\n", ERR_error_string(ERR_get_error(), NULL));
   ERR_print_errors_fp(out);
}

/**
 * Print SSL error details with inserted content
 */
void print_ssl_error_2(char* message, char* content, FILE* out) {
   fprintf(out, message, content);
   fprintf(out, "Error: %s\n", ERR_reason_error_string(ERR_get_error()));
   fprintf(out, "%s\n", ERR_error_string(ERR_get_error(), NULL));
   ERR_print_errors_fp(out);
}

/**
 * Initialise OpenSSL
 */
void init_openssl() {
   /* call the standard SSL init functions */
   SSL_load_error_strings();
   SSL_library_init();
   ERR_load_BIO_strings();
   OpenSSL_add_all_algorithms();

    /* seed the random number system - only really nessecary for systems
       without '/dev/random' */
    /* RAND_add(?,?,?); need to work out a cryptographically significant way
       of generating the seed */
}

/**
 * Close an unencrypted connection gracefully
 */
int close_connection(BIO* bio) {
   int r;
   if ((r = BIO_free(bio)) == 0) {
      /* Error unable to free BIO */
      }
   return r;
}


/**
 * Read from a stream and handle restarts if necessary
 */
ssize_t read_from_stream(BIO* bio, char* buffer, ssize_t length) {
   ssize_t r = -1;

   while (r < 0) {
      r = BIO_read(bio, buffer, length);
      if (r == 0) {
         print_ssl_error("Reached the end of the data stream.\n", stdout);
         continue;
         }
      else if (r < 0) {
         if (!BIO_should_retry(bio)) {
            print_ssl_error("BIO_read should retry test failed.\n", stdout);
            continue;
            }
         print_ssl_error("BIO_read should retry test succeeded.\n", stdout);
         /* It would be prudent to check the reason for the retry and handle
          * it appropriately here */
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
            print_ssl_error("BIO_read should retry test failed.\n", stdout);
            continue;
            }
         /* It would be prudent to check the reason for the retry and handle
          * it appropriately here */
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
      print_ssl_error_2("Unable to load the trust store from %s.\n",
                        store_path, stdout);
      return NULL;
      }

   /* Setting up the BIO SSL object */
   bio = BIO_new_ssl_connect(*ctx);
   BIO_get_ssl(bio, ssl);
   if (!(*ssl)) {
      print_ssl_error("Unable to allocate SSL pointer.\n", stdout);
      return NULL;
      }
   SSL_set_mode(*ssl, SSL_MODE_AUTO_RETRY);

   /* Attempt to connect */
   BIO_set_conn_hostname(bio, host_and_port);

   /* Verify the connection opened and perform the handshake */
   if (BIO_do_connect(bio) < 1) {
      print_ssl_error_2("Unable to connect BIO.%s\n", host_and_port, stdout);
      return NULL;
      }

   if (SSL_get_verify_result(*ssl) != X509_V_OK) {
      print_ssl_error("Unable to verify connection result.\n", stdout);
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

int sslclose(Tpdisc_t* tpdisc)
{
   int rv = close_connection(((Tpssldisc_t*)tpdisc)->bio);
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
