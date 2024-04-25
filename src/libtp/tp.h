/*
 * tp.h: definitions for libtp transport protocol library
 *      (c) Copyright 2000 by Steve Lumos.  All rights reserved.
 */

#ifndef TP_H
#define TP_H 1

#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif

#include "uri/uri.h"

typedef struct _tp_s        Tp_t;          /* libtp handle */
typedef struct _tpdisc_s    Tpdisc_t;      /* discipline */
typedef struct _tpmethod_s  Tpmethod_t;    /* method */

typedef int       (*Tpconnect_f)(PURI puri,  Tpdisc_t* disc);
typedef int       (*Tpclose_f)(Tpdisc_t* disc);
typedef ssize_t   (*Tpread_f)(void* buf, size_t n, Tpdisc_t* disc);
typedef ssize_t   (*Tpreadln_f)(void* buf, size_t n, Tpdisc_t* disc);
typedef ssize_t   (*Tpwrite_f)(void* buf, size_t n, Tpdisc_t* disc);
typedef void*     (*Tpmem_f)(size_t n, Tpdisc_t* disc);
typedef int       (*Tpfree_f)(void* obj, Tpdisc_t* disc);
typedef int       (*Tpexcept_f)(int type, void* obj, Tpdisc_t* disc);
typedef Tpdisc_t* (*Tpnewdisc_f)(Tpdisc_t* disc);

struct _tpdisc_s
{
  Tpconnect_f connectf;  /* establish a connection */
  Tpclose_f   closef;    /* close the connection */
  Tpread_f    readf;     /* read from the connection */
  Tpreadln_f  readlnf;   /* read a line from the connection */
  Tpwrite_f   writef;    /* write to the connection */
  Tpmem_f     memf;      /* allocate some memory */
  Tpfree_f    freef;     /* free memory */
  Tpexcept_f  exceptf;   /* handle exception */
  Tpnewdisc_f newdiscf;  /* deep copy a discipline */
  int type;              /* TP_FILE, TP_SOCKET */
};

/* Exceptions */
enum _tperr {
  TP_RETURNERROR = -1,
  TP_DEFAULT = 0,
  TP_TRYAGAIN = 1,

  TP_ECONNECT,
  TP_EHOST,
  TP_EINVAL,
  TP_EMEM,
  TP_EOPEN,
  TP_EREAD,
  TP_ESERVER,
  TP_ESOCKET,
  TP_EWRITE,

  TP_STATECLOSED,
  TP_STATENOTREADING,
  TP_STATENOTWRITING,

  TP_ETRUST,
  TP_EVERIFY,

  TPM_UNIMPLEMENTED,
  TPM_UNSUPPORTED,

  TP_ERRCODE = 900    /* Offset for library errors returned in Tpresponse_t */
};

/* Method functions */
typedef struct _tprequest_s  Tprequest_t;
typedef struct _tpresponse_s Tpresponse_t;

typedef int Tpreqtype_t;
enum _tpreqtype_e {
  NOOP=1,
  GET, HEAD, POST, PUT,                 /* HTTP */
  DELE, LIST, QUIT, RETR, STAT,         /* POP3 */
  DATA, HELO, MAIL, RCPT                /* SMTP */
};

struct _tprequest_s
{
  Tpreqtype_t type;    /* kind of request */
  char*       header;  /* ready-to-send header */
  char*       args;    /* request argument string */
};

struct _tpresponse_s
{
  int    sc;       /* error/success code */
  char*  msg;      /* message/string part of response */
  char*  header;   /* header part of response */
};

typedef int           (*Tpmbegin_f)(Tp_t* tp, Tprequest_t* req);
typedef Tpresponse_t* (*Tpmend_f)(Tp_t* tp);
typedef int           (*Tpmclose_f)(Tp_t* tp);
typedef int           (*Tpmfreeresp_f)(Tp_t* tp, Tpresponse_t* resp);

typedef int Tpstate_t;
enum _tpstate_e {
  CLOSED     = 0,
  CONNECTING = 1,
  CONNECTED  = 2,
  WRITING    = 4,
  READING    = 8,
  CATCH      = 16,  /* exceptions are caught with setjmp() */
  BAD        = 32
};

#define TPSTATE(tp, s) (tp->meth->state & s)
#define TPIN(tp, s)    (tp->meth->state & s)
#define TPENTER(tp, s) (tp->meth->state |= s)
#define TPLEAVE(tp, s) (tp->meth->state &= ~s)
#define TPSET(tp, s)   (tp->meth->state = s)

struct _tpmethod_s
{
  Tpmbegin_f    beginf;    /* begin a request */
  Tpmend_f      endf;      /* end a request */
  Tpmclose_f    closef;    /* cleanup and close connection */
  Tpmfreeresp_f freerespf; /* free the response record */
  Tpstate_t     state;
};

/* libtp handle */
struct _tp_s
{
  Tpmethod_t* meth;  /* COPY of the method structure */
  Tpdisc_t*   disc;  /* COPY of the discipline structure */
  URI         uri;   /* Parsed URI */

  /* Buffer for pushback data (required for recognizing
   * HTTP/0.9 vs. post HTTP/1.0 servers) */
  char*       rptr;
  size_t      rlen;
  char        rbuf[6];
};

/* libtp functions */

/* tp_new: Open a connection of type meth using discipline disc. */
Tp_t* tp_new(URI* puri, Tpmethod_t* meth, Tpdisc_t* disc);

/* tp_newdisc: Return a copy of discipline disc. */
Tpdisc_t* tp_newdisc(Tpdisc_t* disc);

/* tp_free: Close connection if necessary and free space. */
void tp_free(Tp_t* tp);

/* tp_freeresp: Free a response structure */
void tp_freeresp(Tp_t* tp, Tpresponse_t* resp);

/* tp_begin: Begin a request. */
int tp_begin(Tp_t* tp, Tprequest_t* req);

/* tp_end: End the request, start reading. */
Tpresponse_t* tp_end(Tp_t* tp);

/* tp_quickreq: For services that have small requests/responses, just
 *  make the request and return the response as a single buffer. */
int tp_quickreq(Tp_t* tp, char* req, char* resp, size_t n);

/* tp_sendreq: For services that have small requests, but potentially
 *  large responses.  Use tp_read/tp_readln to read the response
 *  body. */
Tpresponse_t* tp_sendreq(Tp_t* tp, Tprequest_t* req);

/* tp_read: Read n bytes into buf. */
ssize_t tp_read(Tp_t* tp, void* buf, size_t n);

/* tp_readln: Read until newline encountered and null terminate . */
ssize_t tp_readln(Tp_t* tp, void* buf, size_t n);

/* tp_write: Write n bytes. */
ssize_t tp_write(Tp_t* tp, void* buf, size_t n);

/* tp_headerfield: Return a pointer to the value part of a header field. */
char* tp_headerfield(char* header, char* field);

int tp_fileno(Tp_t* tp);

#ifndef _LIBTP_

/* Methods */
extern Tpmethod_t* TpmDaytime;
extern Tpmethod_t* TpmFinger;
extern Tpmethod_t* TpmHTTP;
extern Tpmethod_t* TpmPOP;
extern Tpmethod_t* TpmSMTP;

/* Disciplines */
extern Tpdisc_t* TpdUnix;
extern Tpdisc_t* TpdSSL;

#endif /* !_LIBTP_ */

#endif /* TP_H */
