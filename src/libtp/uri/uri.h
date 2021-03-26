/**********************************************************************\
* uri.h: Parse a URL.                                                  *
* -------------------------------------------------------------------- *
*   (c) Copyright 1999-2000 by Steve Lumos.  All rights reserved.      *
\**********************************************************************/

#ifndef URI_H
#define URI_H

enum URIERR {
  URI_SUCCESS = 0,     /* URI was parsed correctly */
  URI_OK = 0,          /* Alias for URI_SUCCESS */
  URI_EMALFORMED,      /* Malformed URI */
  URI_ENOUSER,         /* Username required but not present */
  URI_EUNKNOWNSCHEME,  /* Don't have a parser for this scheme */
  URI_ECHECKERRNO      /* Look at errno for error code */
};

extern const char* const _uri_errlist[];

#ifndef strdup
char *strdup(const char* s);
#endif

/* A parsed URI */
typedef struct _uri {
  int   status;   /* Success or error code */
  char  *scheme;  /* Access scheme (http, mailto, etc) */
  char  *user;    /* Username for authentication */
  char  *pass;    /* Password for authentication */
  char  *host;    /* Server hostname */
  char  *sport;   /* Service port string */
  int   af_family;         /* AF_UNSPEC, AF_INET6 or AF_INET */
  unsigned short port;     /* Service port number */
  char  is_explicit_port;  /* Whether an explicit port was set */
  char  *path;    /* Pathname (file, email address, etc) */
} URI, *PURI;

PURI uri_parse(char *uri, int af_fam);
PURI uri_new(void);
void uri_free(PURI puri);

#endif /* defined URI_H */
