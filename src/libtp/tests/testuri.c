#ifndef NO_CONFIG_H
#ifndef HAVE_CONFIG_H
#define HAVE_CONFIG_H
#endif
#endif

#ifdef HAVE_CONFIG_H
#include "../../h/config.h"
#endif

#ifdef STDC_HEADERS
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#endif

#include <uri.h>

void print_uri(PURI puri);

int main(int argc, char **argv)
{
  PURI puri;

  if (argc != 2) {
    fprintf(stderr, "usage: %s uri | @file\n", argv[0]);
    exit(1);
  }

  if (argv[1][0] != '@') {
    puri = uri_parse(argv[1]);
    if (puri->status != URI_SUCCESS) {
      fprintf(stderr, "testuri: %s `%s' (%s: %d)\n",
              _uri_errlist[puri->status], argv[1],
              __FILE__, __LINE__);
      uri_free(puri);
      exit(1);
    }
    print_uri(puri);
    uri_free(puri);
    exit(0);
  }
  else {
    char uri[1024];
    char *file = argv[1]+1;
    FILE *uris = fopen(file, "r");
    if (uris == NULL) {
      perror(file);
      exit(1);
    }

    while (fgets(uri, 1024, uris)) {
      if (uri[0] == '#') {  /* Allow comments */
        continue;
      }
      uri[strlen(uri)-1] = '\0'; /* Kill the newline */
      printf("\n[%s]\n", uri);
      puri = uri_parse(uri);
      if (puri->status != URI_SUCCESS) {
        fprintf(stderr, "testuri: %s `%s' (%s: %d)",
                _uri_errlist[puri->status], uri, __FILE__, __LINE__);
        uri_free(puri);
        continue;
      }
      print_uri(puri);
      uri_free(puri);
    }
    fclose(uris);
  }

  return 0;
}

void print_uri(PURI puri)
{
  static const char *nullstr = "<NULL>";

  if (puri == NULL) {
    printf("NULL URI!\n");
    return;
  }

  printf("scheme: [%s]\n", (puri->scheme) ? puri->scheme : nullstr);
  printf("user:   [%s]\n", (puri->user) ? puri->user : nullstr);
  printf("pass:   [%s]\n", (puri->pass) ? puri->pass : nullstr);
  printf("host:   [%s]\n", (puri->host) ? puri->host : nullstr);
  printf("port:   [%d]\n", puri->port);
  printf("path:   [%s]\n", (puri->path) ? puri->path : nullstr);
}

