/*
 * File: rmsg.r
 *  Contents: [csicmp], [Maddtoheader], Mclose, [Mexcept], [Mhttp],
 *  Mopen, [Mpop], Mpop_delete, [Mpop_freelist], [Mpop_newlist],
 *  [Msmtp], [Mstartreading], [Mwashs], [si_cs2i]
 */

/**********************************************************************\
* rmsg.r: Support code for messaging extensions.                       *
* -------------------------------------------------------------------- *
*      (c) Copyright 2000 by Steve Lumos. All rights reserved.         *
\**********************************************************************/
#ifdef Messaging

static Tpexcept_f tpexcept;
jmp_buf Mexceptbuf;
int Mexceptjmp;
int Merror;

/* Size of header array */
#define HDRSIZE 8192

/*
 * Adding a timeout to open() is a practical requirement.
 * Not implemented yet.
 */
int M_open_timeout;

#if NT
extern int StartupWinSocket(void);
#endif                                  /* NT */

const char* DEFAULT_USER_AGENT = "User-Agent: Unicon Messaging/13.0";

char *Maddtoheader(char* header, const char* s, int slen, int* nleft);
void Mhttp(struct MFile* mf, dptr attr, int nattr);
void Mpop(struct MFile* mf, dptr attr, int nattr);
int Mpop_newlist(struct MFile* mf, unsigned n);
void Msmtp(struct MFile* mf, dptr attr, int nattr);
char *Mwashs(char* dest, char* s, size_t n);
int si_cs2i(siptr sip, char* s);
stringint headers[];

extern char *_tpastrcpy(char *s, Tpdisc_t *disc);
extern void _tpssl_setparam(Tpdisc_t *disc, int val);

/* Use the same function for handling real libtp exceptions and also
 * internal exceptions.  In the latter case, disc == NULL. */
int Mexcept(int e, void* obj, Tpdisc_t* disc)
{
   int rc;

#ifdef MDEBUG
   fprintf(stderr, "Mexcept: %d\n", e); fflush(stderr);
#endif


   if (disc == NULL) {
      Merror = e;
      rc = (-1);
      }
   else {
      rc = tpexcept(e, obj, disc);
      }

   if (Mexceptjmp > 0 && (rc == TP_RETURNERROR || disc == NULL)) {
      longjmp(Mexceptbuf, e);
      }
   return rc;
}

struct MFile* Mopen(URI* puri, dptr attr, int nattr, int shortreq,
                    int status)
{
   Tp_t* tp;
   Tpdisc_t* disc;
   Tpmethod_t* meth;
   Tprequest_t req;
   struct MFile* mfile;
   int exception;

#if (UNIX || NT)
#ifdef HAVE_LIBSSL
   if (strcasecmp(puri->scheme, "https") == 0) {
      disc = tp_newdisc(TpdSSL);
      _tpssl_setparam(disc, status & Fs_Verify);
      }
   else
#endif                                  /* HAVE_LIBSSL */
      disc = tp_newdisc(TpdUnix);

#else
#error Systems other than Unix/Windows not supported yet
#endif                                  /* UNIX */

#if NT
   if (!StartupWinSocket()) return NULL;
#endif                                  /*NT*/

   tpexcept = disc->exceptf;
   disc->exceptf = Mexcept;

   Merror = 0;
   Mexceptjmp = 1;
   if ((exception = setjmp(Mexceptbuf)) != 0) {
      Merror = exception;
      Mexceptjmp = 0;
      return NULL;
      }

   if ((strcasecmp(puri->scheme, "http")  == 0) ||
      ( strcasecmp(puri->scheme, "https") == 0)) {
      meth = TpmHTTP;
      }
   else if (strcasecmp(puri->scheme, "finger") == 0) {
      meth = TpmFinger;
      }
   else if (strcasecmp(puri->scheme, "mailto") == 0) {
      meth = TpmSMTP;
      }
   else if (strcasecmp(puri->scheme, "pop") == 0) {
      meth = TpmPOP;
      }
   else {
      Mexceptjmp = 0;
      return NULL;
      }

   tp = tp_new(puri, meth, disc);

   mfile = (struct MFile*)disc->memf(sizeof(struct MFile), disc);
   mfile->flags = shortreq;
   mfile->tp = tp;
   mfile->resp = NULL;
   MFSTATE(mfile, CONNECTING);

   if (meth == TpmHTTP) {
      Mhttp(mfile, attr, nattr);
      }
   else if (meth == TpmPOP) {
      Mpop(mfile, attr, nattr);
      }
   else if (meth == TpmSMTP) {
      Msmtp(mfile, attr, nattr);
      }
   else {
      req.type = GET;
      req.header = NULL;
      mfile->resp = tp_sendreq(tp, &req);
      MFENTER(mfile, READING);
      }

   Mexceptjmp = 0;
   return mfile;
}

void Mhttp(struct MFile* mf, dptr attr, int nattr)
{
   int i, l;
   tended char *s;
   char *end, *colon;
   char buf[4096];
   char header[HDRSIZE];

   int need_user_agent = 1;
   int need_host = 1;
   int hleft = HDRSIZE;

   Tprequest_t req;

   /* Default request method */
   if (mf->flags) {
      req.type = HEAD;
      }
   else {
      req.type = GET;
      }

   /* Parse attributes into the header */
   header[0] = '\0';
   for (i=0; i<nattr; i++) {
      if (!cnv:C_string(attr[i], s)) {
         abort();
         }
      l = strlen(s);
      end = s+l;
      for (colon=s; colon<end; colon++) {
         if (*colon == ':') {
            break;
            }
         }

      if (colon < end) {
         if (hleft <= 0) {
#ifdef MDEBUG
            fprintf(stderr, "Warning: Header truncated at: %s\n", s);
            fflush(stderr);
#endif /* MDEBUG */
            break;
            }
         strncat(header, s, colon - s);
         hleft -= (colon - s);
         switch (si_cs2i(headers, Mwashs(buf, s, colon - s)))
            {
               case -1:
#ifdef MDEBUG
                  fprintf(stderr, "Unknown header, passing through: %s\n", s);
                  fflush(stderr);
#endif /* MDEBUG */
                  break;

               case H_CONTENT_TYPE:
                  if (strstr(colon, "form")) {
                     req.type = POST;
                     }
                  else {
                     req.type = PUT;
                     }
                  break;

               case H_HOST:
                  need_host = 0;
                  break;

               case H_USER_AGENT:
                  need_user_agent = 0;
                  break;
               }
         }
      else {
         Mexcept(1207, NULL, NULL);
         }

      /* Append the colon and space */
      Maddtoheader(header, ": ", 2, &hleft);
      while (strchr(" \t", *++colon) != NULL); /* Skip leading whitespace */
      Maddtoheader(header, colon, s - colon, &hleft);
      Maddtoheader(header, "\r\n", 2, &hleft);
      }

   /* Add standard fields */
   if (need_user_agent) {
      Maddtoheader(header, DEFAULT_USER_AGENT,
                   strlen(DEFAULT_USER_AGENT), &hleft);
      Maddtoheader(header, "\r\n", 2, &hleft);
      }

   if (need_host) {
      Maddtoheader(header, "Host: ", 6, &hleft);
      Maddtoheader(header, mf->tp->uri.host, strlen(mf->tp->uri.host), &hleft);
      /* if the user set the port explicitly then add it to the header */
      if (mf->tp->uri.is_explicit_port != 0 ){
         Maddtoheader(header, ":", 1, &hleft);
         l = sprintf(buf, "%d", mf->tp->uri.port);
         Maddtoheader(header, buf, l, &hleft);
         }
      Maddtoheader(header, "\r\n", 2, &hleft);
      }

   req.header = header;

   tp_begin(mf->tp, &req);

   MFSTATE(mf, CONNECTED | WRITING);
}

void Mpop(struct MFile* mf, dptr attr, int nattr)
{
   Tprequest_t req = {0};
   unsigned int nmsg;

   req.type = STAT;
   mf->resp = tp_sendreq(mf->tp, &req);
   if (mf->resp->sc != 200) {
      Mexcept(1212, NULL, NULL);
      }
   if (sscanf(mf->resp->msg, "%*s %d %*d", &nmsg) < 1) {
      Mexcept(1212, NULL, NULL);
      }
   if (nmsg == 0) {
      return;
      }
   if (Mpop_newlist(mf, nmsg) < 0) {
      Mexcept(1200, NULL, NULL);
      }
   MFSTATE(mf, CONNECTED | READING);
   return;
}

int Mpop_delete(struct MFile* mf, unsigned int msgnum)
{
   struct Mpoplist* mplCurrent;
   unsigned int i, svrnum;
   unsigned char buf[100];
   Tprequest_t req = { DELE, NULL, NULL };
   Tpdisc_t* disc = mf->tp->disc;

   if (mf->data == NULL) {
      return -1;
      }
   if (strcmp(mf->tp->uri.scheme, "pop") != 0) {
      return -1;
      }

   mplCurrent = (struct Mpoplist*)mf->data;
   for (i=0; i<msgnum; i++) {
      mplCurrent = mplCurrent->next;
      if (mplCurrent->msgnum == 0) {
         return -1;
         }
      }
   svrnum = mplCurrent->msgnum;
   req.args = (char *)buf;
   snprintf(req.args, sizeof(buf), "%d", svrnum);
   mf->resp = tp_sendreq(mf->tp, &req);
   if (mf->resp->sc < 300) {
      /* Delete from the list */
      mplCurrent->prev->next = mplCurrent->next;
      mplCurrent->next->prev = mplCurrent->prev;
      disc->freef(mplCurrent, disc);
      return 1;
      }
   else {
      return -1;
      }
}

void Mpop_freelist(struct MFile* mf)
{
   Tpdisc_t* disc = mf->tp->disc;
   struct Mpoplist* mplHead;
   struct Mpoplist* mplCurrent;

   if (mf->data == NULL) {
      return;
      }
   if (strcmp(mf->tp->uri.scheme, "pop") != 0) {
      return;
      }

   mplHead = (struct Mpoplist*)mf->data;
   mplCurrent = mplHead->next;
   while (mplCurrent != mplHead) {
      struct Mpoplist* mplTemp = mplCurrent->next;
      disc->freef(mplCurrent, disc);
      mplCurrent = mplTemp;
      }
   disc->freef(mf->data, disc);
   mf->data = NULL;
}

int Mpop_newlist(struct MFile* mf, unsigned n)
{
   struct Mpoplist* mplCurrent;
   struct Mpoplist* mplHead;
   Tpdisc_t* disc = mf->tp->disc;
   unsigned i;

   if (n <= 0) {
      return -1;
      }

   /* Initialize the list */
   mf->data = (void *)disc->memf(sizeof(struct Mpoplist), disc);
   mplHead = (struct Mpoplist *)(mf->data);
   mplHead->msgnum = 0;
   mplHead->next = mplHead;
   mplHead->prev = mplHead;
   mplCurrent = mplHead;

   for (i=1; i<=n; i++) {
      struct Mpoplist* mplNew;
      mplNew = (struct Mpoplist*)disc->memf(sizeof(struct Mpoplist), disc);
      mplNew->msgnum = i;
      mplNew->next = mplHead;
      mplNew->prev = mplCurrent;
      mplCurrent->next = mplNew;
      mplCurrent = mplNew;
      }
   return n;
}

void Msmtp(struct MFile* mf, dptr attr, int nattr)
{
   tended char *s;
   char smtpserver[1024] = { 0 };
   char useraddr[1024] = { 0 };
   char *at, *colon, *end;
   char buf[4096], tmpbuf[256];
   char header[HDRSIZE];
   int l, hleft;
   int i;
   Tprequest_t req;
   Tpresponse_t* resp;

   int need_from = 1;

   if (getenv_r("UNICON_SMTPSERVER", tmpbuf, 255)==0) {
      strncat(smtpserver, tmpbuf, sizeof(smtpserver)-1);
      smtpserver[sizeof(smtpserver)-1] = '\0';
      }
   else {
#ifdef HAVE_GETHOSTNAME
      if (gethostname(smtpserver, sizeof(smtpserver)) >= 0) {
         if (getdomainname(buf, sizeof(buf)) >= 0) {
            strncat(smtpserver, ".", 1);
            strncat(smtpserver, buf, sizeof(smtpserver)-strlen(smtpserver)-1);
            goto got_smtpserver;
            }
         }
#endif /* HAVE_GETHOSTNAME */
      Mexcept(1209, NULL, NULL);
      return;
      }

#ifdef HAVE_GETHOSTNAME
 got_smtpserver:
 #endif /* HAVE_GETHOSTNAME */

   if(getenv_r("UNICON_USERADDRESS", tmpbuf, 255)==0) {
      tmpbuf[255] = '\0';
      strncat(useraddr, tmpbuf, sizeof(useraddr)-1);
      useraddr[sizeof(useraddr)-1] = '\0';
      }
   else {
#if defined(HAVE_GETUID) && defined(HAVE_GETPWUID)
      struct passwd* pw, pwbuf;
      char buf[1024];
      if(getpwuid_r(getuid(), &pwbuf, buf, 1024, &pw)==0){
         snprintf(useraddr, sizeof(useraddr), "%s@%s",
                  pw->pw_name, smtpserver);
         goto got_useraddr;
         }
#endif
      Mexcept(1210, NULL, NULL);
      return;
      }

#if defined(HAVE_GETUID) && defined(HAVE_GETPWUID)
 got_useraddr:
#endif

   mf->tp->uri.host = _tpastrcpy(smtpserver, mf->tp->disc);
   mf->tp->uri.port = 25;

   at = strchr(useraddr, '@');
   if (!at) {
      Mexcept(1210, NULL, NULL);
      return;
      }

   req.type = HELO;
   req.args = at+1;

   resp = tp_sendreq(mf->tp, &req);
   switch (resp->sc) {
      case 250: /* OK */
         break;

      case 501: /* Argument syntax error */
      case 502: /* Command not implemented */
      case 504: /* Command parameter not implemented */
         Mclose(mf);
         Mexcept(1212, NULL, NULL);
         return;

      case 421: /* Service not available, closing transmission channel */
         Mclose(mf);
         Mexcept(1212, NULL, NULL);
         return;

      default:
         fprintf(stderr, "Msmtp: unrecognized response to HELO: %d\n",
                 resp->sc);
      }

   tp_freeresp(mf->tp, resp);
   req.type = MAIL;
   req.args = useraddr;
   resp = tp_sendreq(mf->tp, &req);
   switch (resp->sc) {
      case 250: /* success */
         break;

      case 451: /* Requested action aborted: local error in processing */
      case 452: /* Requested action not taken: insufficient system storage */
      case 552: /* Requested mail action aborted: exceeded storage allocation */
         Mclose(mf);
         Mexcept(1212, NULL, NULL);
         return;

      case 500: /* Syntax error, command unrecognized */
      case 501: /* Syntax error in parameters or arguments */
         Mclose(mf);
         Mexcept(1212, NULL, NULL);
         return;

      case 421:
         Mclose(mf);
         Mexcept(1212, NULL, NULL);
         return;

      default:
         fprintf(stderr, "Msmtp: unrecognized response to MAIL: %d\n",
                 resp->sc);
      }

   tp_freeresp(mf->tp, resp);
   req.type = RCPT;
   req.args = mf->tp->uri.path;
   resp = tp_sendreq(mf->tp, &req);
   switch (resp->sc) {
      case 250: /* OK */
      case 251: /* User not local; will forward to <forward-path> */
         break;

      case 450: /* Requested mail action not taken: mailbox unavailable */
      case 451: /* Requested action aborted: local error in processing */
      case 452: /* Requested action not taken: insufficient system storage */
      case 550: /* Syntax error, command unrecognized */
      case 551: /* User not local; please try <forward-path> */
      case 552: /* Requested mail action aborted: exceeded storage allocation */
      case 553: /* Requested action not taken: mailbox name not allowed */
         Mclose(mf);
         Mexcept(1212, NULL, NULL);
         return;

      case 500: /* Syntax error, command unrecognized */
      case 501: /* Syntax error in parameters or arguments */
      case 503: /* Bad sequence of commands */
         Mclose(mf);
         Mexcept(1212, NULL, NULL);
         return;

      case 421:
         Mclose(mf);
         Mexcept(1212, NULL, NULL);
         return;

      default:
         fprintf(stderr, "Msmtp: unrecognized response to MAIL: %d\n",
                 resp->sc);
      }

   tp_freeresp(mf->tp, resp);
   req.type = DATA;
   req.args = NULL;

   /* Parse attributes into the header */
   header[0] = '\0';
   hleft = HDRSIZE;
   for (i=0; i<nattr; i++) {
      if (!cnv:C_string(attr[i], s)) {
         abort();
         }
      l = strlen(s);
      end = s+l;
      for (colon=s; colon<end; colon++) {
         if (*colon == ':') {
            break;
            }
         }

      if (colon < end) {
         if (hleft <= 0) {
#ifdef MDEBUG
            fprintf(stderr, "Warning: Header truncated at: %s\n", s);
            fflush(stderr);
#endif /* MDEBUG */
            break;
            }
         strncat(header, s, colon - s);
         hleft -= (colon - s);
         if (si_cs2i(headers, Mwashs(buf, s, colon - s)) == H_FROM) {
            need_from = 0;
            }
         }
      else {
         Mexcept(1207, NULL, NULL);
         }

      /* Append the colon and space */
      Maddtoheader(header, ": ", 2, &hleft);
      while (strchr(" \t", *++colon) != NULL); /* Skip leading whitespace */
      Maddtoheader(header, colon, s - colon, &hleft);
      Maddtoheader(header, "\r\n", 2, &hleft);
      }

   /* Add standard fields */
   if (need_from) {
      Maddtoheader(header, "From: ", 6, &hleft);
      Maddtoheader(header, useraddr, strlen(useraddr), &hleft);
      Maddtoheader(header, "\r\n", 2, &hleft);
      }

   Maddtoheader(header, "\r\n", 2, &hleft);
   req.header = header;
   tp_begin(mf->tp, &req);
   MFSTATE(mf, CONNECTED | WRITING);
}

void Mstartreading(struct MFile* mf)
{
   int exception;

   if (MFIN(mf, READING)) {
      return;
      }

   Merror = 0;
   Mexceptjmp = 1;
   if ((exception = setjmp(Mexceptbuf)) != 0) {
      Merror = exception;
      Mexceptjmp = 0;
      return;
      }

   mf->resp = tp_end(mf->tp);
   MFLEAVE(mf, WRITING);
   MFENTER(mf, READING);
   Mexceptjmp = 0;
   return;
}

int Mclose(struct MFile* mf)
{
  if (mf->state != CLOSED) { /* duh, skip this part if already closed */

    /* Make sure the request is closed */
    if (MFIN(mf, WRITING)) {
      Mstartreading(mf);
      }
    if (strcmp(mf->tp->uri.scheme, "pop") == 0) {
      Mpop_freelist(mf);
      }

    tp_freeresp(mf->tp, mf->resp);
    tp_free(mf->tp);
    }

   free(mf);
   return 1;
}

/* Remove whitespace, null-terminate, and return in dest */
char *Mwashs(char* dest, char* s, size_t n)
{
   static const char *ws = " \t";
   int i;
   char *p = (char *)dest;

   for (i=0; i<n; i++) {
      if (strchr(ws, s[i]) == NULL) {
         *p++ = s[i];
         }
      }
   *p = '\0';

   return dest;
}

char *Maddtoheader(char header[HDRSIZE], const char* s, int slen, int* nleft)
{
   if (slen >= *nleft) if (0 >= (slen = *nleft - 1)) return header;

   memcpy(&header[HDRSIZE - *nleft], s, slen);
   *nleft -= slen;
   header[HDRSIZE - *nleft] = '\0';
   return header;
}

stringint headers[] = {
   { 0,              NUMHEADERS     },
   { "content-type", H_CONTENT_TYPE },
   { "from",         H_FROM         },
   { "host",         H_HOST         },
   { "location",     H_LOCATION     },
   { "to",           H_TO           },
   { "user-agent",   H_USER_AGENT   }
};

/*
 * Like si_s2i but not case-sensitive
 */
static int csicmp(siptr sip1, siptr sip2)
{
   return strcasecmp(sip1->s, sip2->s);
}

int si_cs2i(siptr sip, char *s)
{
   stringint key;
   siptr p;
   key.s = s;

   p = (siptr)qsearch((char *)&key,(char *)(sip+1),sip[0].i,sizeof(key),csicmp);
   if (p) return p->i;
   return -1;
}
#else                                   /* Messaging */
static int nomessaging;         /* avoid empty module */
#endif                                  /* Messaging */
