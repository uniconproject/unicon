/**********************************************************************\
* uri-schemes.c: Definitions for the various URI schemes that the      *
*                library knows about.                                  *
* -------------------------------------------------------------------- *
*    (c) Copyright 1999-2000 by Steve Lumos.  All rights reserved.     *
\**********************************************************************/

#include "uri_schm.h"

extern SCHEME scFinger;
extern SCHEME scFTP;
extern SCHEME scHTTP;
extern SCHEME scHTTPS;
extern SCHEME scPOP;
extern SCHEME scMAILTO;

SCHEME *schemes[] = { &scFinger, &scFTP, &scHTTP, &scHTTPS,
                      &scPOP, &scMAILTO, 0 };
