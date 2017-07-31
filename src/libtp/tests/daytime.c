/**********************************************************************\
* daytime.c: Test for libtp daytime method.                            *
* -------------------------------------------------------------------- *
*      (c) Copyright 2000 by Steve Lumos.  All rights reserved.        *
\**********************************************************************/

#ifndef NO_CONFIG_H
#ifndef HAVE_CONFIG_H
#define HAVE_CONFIG_H
#endif
#endif

#ifdef HAVE_CONFIG_H
#include "../../h/config.h"
#endif

#include <stdio.h>
#include <stdlib.h>
#include <tp.h>

int main(int argc, char **argv)
{
  Tp_t* tp;
  URI uri = { 0, "daytime", NULL, NULL, "localhost", 13, 0, NULL };

  char s[1024];

  tp = tp_new(&uri, TpmDaytime, TpdUnix);
  
  if (tp_quickreq(tp, NULL, s, sizeof(s)) < 0) {
    perror("tp_quickreq");
    exit(1);
  }
  puts(s);
  return 0;
}
