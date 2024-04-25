/*
 * tpdssl.c: SSL discipline for libtp.
 *
 * Portions adapted from
http://www.chesterproductions.net.nz/blogs/it/c/an-ssl-client-using-openssl/245/
 * which says it is under GPL2; get their version of source from there.
 */

#define _SSLDISC_C_

#include "../h/config.h"

#ifdef HAVE_LIBSSL

#ifdef STDC_HEADERS
#include <stdio.h>
#include <string.h>
#endif

#include <stdlib.h>
/* stdlib.h should define getenv_r, but it is missing on some systems??!! */
int		getenv_r	(const char *name, char *buf, size_t len);

/* openssl thinks we are a VMS system when VMS=0 , see sys.h*/
#if !VMS
#undef VMS
#endif

#include <openssl/bio.h>
#include <openssl/ssl.h>
#include <openssl/err.h>

#include "tp.h"
#include "util.h"

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

static int ssl_is_initialized;


/**
 * Initialise OpenSSL
 */
void init_openssl() {
   /* call the standard SSL init functions */
#if OPENSSL_VERSION_NUMBER < 0x10100000L
   SSL_library_init();
#else
   OPENSSL_init_ssl(0, NULL);
#endif
   SSL_load_error_strings();
   /*OPENSSL_config(NULL); */
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
BIO* connect_encrypted(char* host, unsigned short port, char* store_path,
		       char store_type, Tpdisc_t* tpdisc){
  
   Tpssldisc_t* ssldisc = (Tpssldisc_t*) tpdisc;
   SSL_CTX* ctx = NULL;
   SSL* ssl = NULL;
   BIO* bio = NULL;
   int r = 0;
   char sport[8];

   /* Set up the SSL pointers */
   //   const SSL_METHOD* method = TLSv1_client_method();
   const SSL_METHOD* method = SSLv23_client_method();
   ctx = ssldisc->ctx = SSL_CTX_new(method);
   const long flags = SSL_OP_ALL | SSL_OP_NO_SSLv2 | SSL_OP_NO_SSLv3;
   SSL_CTX_set_options(ctx, flags);

   /* Load the trust store from the pem location in argv[2] */
   if (store_type == 'f')
      r = SSL_CTX_load_verify_locations(ctx, store_path, NULL);
   else
      r = SSL_CTX_load_verify_locations(ctx, NULL, store_path);
   if (r == 0) {
      /* Exception: Unable to load the trust store from store_path */
      (void)tpdisc->exceptf(TP_ETRUST, NULL, tpdisc);
      return NULL;
      }
   
   /* Setting up the BIO SSL object */
   bio = BIO_new_ssl_connect(ctx);
   if (bio == NULL) {
      /* Exception: Unable to allocate new bio. */
      (void)tpdisc->exceptf(TP_EMEM, NULL, tpdisc);     
      return NULL;
      }
   
   BIO_get_ssl(bio, &ssl);
   if (ssl == NULL) {
      /* Exception: Unable to get SSL pointer. */
      (void)tpdisc->exceptf(TP_EMEM, NULL, tpdisc);     
      return NULL;
      }
   ssldisc->ssl = ssl;
   SSL_set_mode(ssl, SSL_MODE_AUTO_RETRY);

   snprintf(sport, 8, "%d", port);
   sport[7] = 0;

   BIO_set_conn_hostname(bio, host);
   BIO_set_conn_port(bio, sport);

   /*
    * Add an sni field to the request which is required
    * by some https servers
    */
   SSL_set_tlsext_host_name(ssl, host);

   /* Attempt to connect */
   if (BIO_do_connect(bio) <= 0) {
      /* Exception: Unable to connect BIO. */
      (void)tpdisc->exceptf(TP_ECONNECT, NULL, tpdisc);     
      return NULL;
   }

   /* perform the handshake */
   if (BIO_do_handshake(bio) <= 0) {
      /* Exception: Unable to connect BIO. */
      (void)tpdisc->exceptf(TP_ECONNECT, NULL, tpdisc);     
      return NULL;
      }   

   if ((ssldisc->verify != 0) && (SSL_get_verify_result(ssl) != X509_V_OK)) {
       /* valid/verified certificate is required but...*/
       /* Exception: Unable to verify connection result. */
       (void)tpdisc->exceptf(TP_EVERIFY, NULL, tpdisc);
       return NULL;
       }

   return bio;
}

#include <sys/stat.h>
/*
 * Adapted from pathFind. Looks on the real path to find an executable.
 * Simplified and avoids circular library dependency for iconc's sake.
 */
static int sslpathFind(char target[], char buf[], int n)
   {
   char *path;
   register int i;
   int res = 1;
   struct stat sbuf;

   if ((path = getenv("PATH")) == 0)
      path = "";

   while(res && *path) {
#if UNIX
      for (i = 0; *path && *path != ':' && *path != ';' ; ++i)
#else
      for (i = 0; *path && *path != ';' ; ++i)
#endif
         buf[i] = *path++;
      if (*path)			/* skip the ; or : separator */
         ++path;
      if (i == 0)			/* skip empty fragments in PATH */
         continue;
#if UNIX
      if (i > 0 && buf[i-1] != '/' && buf[i-1] != '\\' && buf[i-1] != ':')
            buf[i++] = '/';
#else					/* UNIX */
      if (i > 0 && buf[i-1] != '/' && buf[i-1] != '\\')
            buf[i++] = '\\';
#endif					/* UNIX */
      strcpy(buf + i, target);
      res = stat(buf, &sbuf);
      /* exclude directories (and any other nasties) from selection */
      if (res == 0 && sbuf.st_mode & S_IFDIR)
         res = -1;
      }
   if (res != 0)
      *buf = 0;
   return res == 0;
   }

/*
 * upgrade to use something in discipline?
 * returns 'f' for file, 'd' for directory, or NUL for error.
 */
char get_storepath(Tpdisc_t *tpdisc, char *store_path)
{
   char path_to_ssl[1024];

   /* use SSL_CERT_FILE if available */
   if ((getenv_r("SSL_CERT_FILE", store_path, 1023)) == 0)
      return 'f';

   /* use SSL_CERT_DIR if available */
   if ((getenv_r("SSL_CERT_DIR", store_path, 1023)) == 0)
      return 'd';

   /* if openssl command line client is available, use its output */
   if (sslpathFind("openssl", path_to_ssl, 1024) == 1) {
      FILE *f;
      f = popen("openssl version -a | grep OPENSSLDIR", "r");
      if (fgets(path_to_ssl, 1023, f) == NULL) return '\0';
      pclose(f);
      if (sscanf(path_to_ssl, "OPENSSLDIR: \"%s\"", store_path) == 1) {
	 /* sscanf was OK */
	 return 'd';
	 }
      /* else fall through to return a default string */
      }

   /* if /usr/local/ssl/certs/ is present, use it */
   sprintf(store_path, "/usr/lib/ssl/certs");
   return 'd';
}

int sslconnect(PURI puri, Tpdisc_t* tpdisc)
{
   char store_type;
   char store_path[1024];

   if ((store_type = get_storepath(tpdisc, store_path)) == 0) return -1;

   if (!ssl_is_initialized) {
      init_openssl();
      ssl_is_initialized++;
      }
   ((Tpssldisc_t*)tpdisc)->bio =
      connect_encrypted(puri->host, puri->port, store_path, store_type,
			tpdisc);
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
	case TP_DEFAULT:
	  if (rc == 0 && n > 1 ){
	    *ptr = '\0';
	    return n-1;   /* no \n in this case */
	  }
	  return 0;
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
  char *cp = buf;

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
    sslwrite, sslmem, sslfree, unixexcept, sslnewdisc, 0 },
  NULL, NULL, NULL,
  1, /* encrypt*/
  0 /* don't verify certificates by default*/
};

Tpdisc_t* TpdSSL = (Tpdisc_t *)&_tpdssl;

void _tpssl_setparam(Tpdisc_t *disc, int val){
   ((Tpssldisc_t *)disc)->verify = val;
 }

#else
/* static char junk;		 avoid empty module */
#endif					/* HAVE_LIBSSL */
