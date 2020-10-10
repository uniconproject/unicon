/**********************************************************************\
* uri_file.c: Parse file URLs.                                         *
* -------------------------------------------------------------------- *
*      Copyright 1999-2000 by Steve Lumos.  All rights reserved.       *
\**********************************************************************/

/*
 * From RFC 1738:
 *    fileurl = "file://" [ host | "localhost" ] "/" fpath
 *
 * The interpretation of fpath is completely system-dependant.  I
 * would like this function to be smart, so that what is returned in
 * puri->path will be in whatever format the host system requires.
 * For example (also from RFC 1738): 
 *    <URL:file://vms.host.edu/disk$user/my/notes/note12345.txt>
 * on a VMS system should be converted to:
 *    DISK$USER:[MY.NOTES]NOTE123456.TXT
 *
 * OK, ick.  Of course this is impossible to do in general, and for
 * any host other than localhost, but it is probably reasonable to
 * let
 *    <URL:file:///C|/WINDOWS/BLAH.TXT>  (wierd Netscape-ism)
 * or
 *    <URL:file:///C/WINDOWS/BLAH.TXT>
 * become:
 *    "C:\\WINDOWS\\BLAH.TXT"
 * on a DOS/Windows system.
 * 
 * I don't support the form fileurl = "file:" fpath, since as you can
 * see from above, this is illegal.  
 */

#include <stdlib.h>
#include <string.h>
#include <errno.h>

#include "uri.h"
#include "uri_schm.h"


PURI _file_parse(char *uri, PURI puri);

SCHEME scFILE = { "file", _file_parse, 0 };

PURI _file_parse(char *uri, PURI puri)
{
  char *slash;

  if (uri[0] == '/' && uri[1] == '/') {
    uri += 2;
  }
  else {
    puri->status = URI_EMALFORMED;
    return puri;
  }
  
  slash = strchr(uri, '/');
  if (slash > uri) {
    /* hostname specified */
    puri->host = (char *)malloc(slash - uri + 1);
    if (!puri->host) {
      puri->status = URI_ECHECKERRNO;
      return puri;
    }
    puri->host[0] = '\0';
    strncat(puri->host, uri, slash - uri);
    uri = slash;
  }

  /* everything else is the path */
  puri->path = (char *)malloc(strlen(uri) + 1);
  if (!puri->path) {
    puri->status = URI_ECHECKERRNO;
    return puri;
  }
  strcpy(puri->path, uri);

  puri->status = URI_SUCCESS;
  return puri;
}
