#ifndef NO_CONFIG_H
#ifndef HAVE_CONFIG_H
#define HAVE_CONFIG_H
#endif
#endif

#ifdef HAVE_CONFIG_H
#include "../../h/config.h"
#endif

#include "tp.h"

#ifdef STDC_HEADERS
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#endif

#ifdef HAVE_ERRNO_H
#include <errno.h>
#endif

#ifdef HAVE_SYS_ERRNO_H
#include <sys/errno.h>
#endif

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

Tpexcept_f tpexcept;
Tpread_f   tpread;
Tpreadln_f tpreadln;
Tpwrite_f  tpwrite;

char* url;

int exception(int e, void* obj, Tpdisc_t* disc)
{
  int rc = tpexcept(e, obj, disc);
  if (rc == TP_RETURNERROR) {
    if (errno != 0) {
      perror(url);
    }
    else {
      switch (e)
      {
        case TP_EHOST:
          fputs(url, stderr); fputs(": Unknown host\n", stderr);
          break;

        default:
          fputs(url, stderr); fputs(": Error connecting\n", stderr);
          return rc;
      }
    }
    exit(1);
  }
  else {
    return rc;
  }
}

ssize_t readf(void* buf, size_t n, Tpdisc_t* disc)
{
  ssize_t nread;

  if ((nread = tpread(buf, n, disc)) <= 0) {
    return nread;
  }

  if (write(2, "\n<<", 3) < 0) {
    perror("write");
    exit(1);
  }

  if (write(2, buf, nread) < 0) {
    perror("write");
    exit(1);
  }

  if (write(2, ">>\n", 3) < 0) {
    perror("write");
    exit(1);
  }

  return nread;
}

ssize_t readlnf(void* buf, size_t n, Tpdisc_t* disc)
{
  ssize_t nread;

  if ((nread = tpreadln(buf, n, disc)) <= 0) {
    return nread;
  }

  if (write(2, "\n<<", 3) < 0) {
    perror("write");
    exit(1);
  }

  if (write(2, buf, nread) < 0) {
    perror("write");
    exit(1);
  }

  if (write(2, ">>\n", 3) < 0) {
    perror("write");
    exit(1);
  }

  return nread;
}

ssize_t writef(void* buf, size_t n, Tpdisc_t* disc)
{
  ssize_t nwritten;

  if (write(2, "\n[[", 3) < 0) {
    perror("write");
    exit(1);
  }

  if (write(2, buf, n) < 0) {
    perror("write");
    exit(1);
  }

  if (write(2, "]]\n", 3) < 0) {
    perror("write");
    exit(1);
  }

  nwritten = tpwrite(buf, n, disc);
  return nwritten;
}

int main(int argc, char **argv)
{
  Tp_t*         tp;
  Tpdisc_t*     disc;
  Tprequest_t   req = {0};
  Tpresponse_t* resp;

  PURI puri;
  int i;
  char* type = "head";
  char buf[8192];

  if (argc < 2) {
    fprintf(stderr, "usage: %s <POP url>\n", argv[0]);
    exit(1);
  }

  url = argv[1];
  puri = uri_parse(url);
  if (puri->status != URI_OK) {
    fprintf(stderr, "%s: %s\n", url, _uri_errlist[puri->status]);
    exit(1);
  }

  if (strcmp(puri->scheme, "pop") != 0) {
    fprintf(stderr, "%s: not a POP URL\n", url);
    exit(1);
  }

  disc = tp_newdisc(TpdUnix);
  tpexcept = disc->exceptf;
  disc->exceptf = exception;
#if 0
  tpread = disc->readf;
  disc->readf = readf;
  tpreadln = disc->readlnf;
  disc->readlnf = readlnf;
  tpwrite = disc->writef;
  disc->writef = writef;
#endif

  tp = tp_new(puri, TpmPOP, disc);

  req.type = LIST;
  req.args = "";
  resp = tp_sendreq(tp, &req);
  if (resp->sc > 300) {
    fprintf(stderr, "%s\n", resp->msg);
    tp_freeresp(tp, resp);
    tp_free(tp);
    exit(1);
  }
  tp_freeresp(tp, resp);

  printf("Messages:\n");
  while (tp_readln(tp, buf, sizeof(buf)) > 0) {
    if (buf[0] == '.' && buf[1] != '.') {
      break;
    }

    printf("%s", buf);
  }

  tp_free(tp);

  return 0;
}
