/*
 * File: rsys.r
 *  Contents: [flushrec], [getrec], getstrg, host, longread, [putrec], putstr
 */

#ifdef RecordIO
/*
 * flushrec - force buffered output to be written with a record break.
 *  Applies only to files with mode "s".
 */

void flushrec(fd)
FILE *fd;
{
#if SASC
   afwrite("", 1, 0, fd);
#endif					/* SASC */
}

/*
 * getrec - read a record into buf from file fd. At most maxi characters
 *  are read.  getrec returns the length of the record.
 *  Returns -1 if EOF and -2 if length was limited by
 *  maxi. [[ Needs ferror() check. ]]
 *  This function is meaningful only for files opened with mode "s".
 */

int getrec(buf, maxi, fd)
register char *buf;
int maxi;
FILE *fd;
   {
#ifdef SASC
   register int l;

   l = afreadh(buf, 1, maxi+1, fd);     /* read record or maxi+1 chars */
   if (l == 0) return -1;
   if (l <= maxi) return l;
   ungetc(buf[maxi], fd);               /* if record not used up, push
                                           back last char read */
   return -2;
#endif					/* SASC */
   }
#endif					/* RecordIO */

#ifdef PosixFns /* NT */
#ifndef SOCKET_ERROR
#define SOCKET_ERROR -1
#endif
/*
 * sock_getstrg - read a line into buf from socket.  
 *  At most maxi characters are read.  sock_getstrg returns the 
 *  length of the line, not counting the newline.  Returns -1 
 *  if EOF and -3 if a socket error occur.
 */
int sock_getstrg(buf, maxi, fd)
register char *buf;
int maxi;
SOCKET fd;
   {
   int r = 0, i=0;
   char *stmp=NULL;
  
   if ((r=recv(fd, buf, maxi, MSG_PEEK))==SOCKET_ERROR) {
#if NT
      if(WSAGetLastError() == WSAESHUTDOWN)   
	 return -1;
#endif					/* NT */
      k_errornumber = 1040;
      return -3;
      }
   if (r == 0) return -1;
   
   stmp = buf;
   while (stmp - buf < r) {
      if (*stmp == '\n') break;
      stmp++;
      }

   if (stmp - buf < r) {
      if(stmp == buf)
	 i = stmp - buf + 1;
      else
	 i = stmp - buf;
      }
   else  
      i = r;
   if ((r=recv(fd, buf, i, 0)) == SOCKET_ERROR) {
#if NT
      if (WSAGetLastError() == WSAESHUTDOWN)
	 return -1;
#endif					/* NT */
      k_errornumber = 1040;
      return -3;
      }
   return r;
   }
#endif					/* NT */

/*
 * getstrg - read a line into buf from file fbp.  At most maxi characters
 *  are read.  getstrg returns the length of the line, not counting the
 *  newline.  Returns -1 if EOF and -2 if length was limited by maxi.
 *  Discards \r before \n in translated mode.  [[ Needs ferror() check. ]]
 */
int getstrg(buf, maxi, fbp)
register char *buf;
int maxi;
struct b_file *fbp;
   {
   int c, l;
   FILE *fd = fbp->fd;

#ifdef PosixFns
   static char savedbuf[BUFSIZ];
   static int nsaved = 0;
#endif					/* PosixFns */

#if AMIGA
#if LATTICE
   /* This code is special for Lattice 4.0.  It was different for
    *  Lattice 3.10 and probably won't work for other C compilers.
    */
   extern struct UFB _ufbs[];

   if (IsInteractive(_ufbs[fileno(fd)].ufbfh))
      return read(fileno(fd),buf,maxi);
#endif					/* LATTICE */
#endif					/* AMIGA */

#ifdef Messaging
   if (fbp->status & Fs_Messaging) {
      extern int Merror;
      struct MFile* mf = (struct MFile *)fd;

      if (strcmp(mf->tp->uri.scheme, "pop") == 0) {
	 return -1;
	 }

      if (MFIN(mf, WRITING)) {
	 Mstartreading(mf);
	 }
      if (!MFIN(mf, READING)) {
	 return -1;
	 }
      l = tp_readln(mf->tp, buf, maxi);
      if (l <= 0) {
	 tp_free(mf->tp);
	 MFSTATE(mf, CLOSED);
	 return -1;
	 }
      if (buf[l-1] == '\n') {
	 l--;
	 }
      if (fbp->status & Fs_Untrans && buf[l-1] == '\r') {
	 l--;
	 }
      return l;
      }
#endif                                  /* Messaging */

#ifdef XWindows
   if (isatty(fileno(fd))) wflushall();
#endif					/* XWindows */
#if NT
   if (fbp->status & Fs_Pipe) {
      if (feof(fd)) {
         _pclose(fd);
	 fbp->status = 0;
         return -1;
         }
      if (fgets(buf, maxi, fd) == NULL) {
         _pclose(fd);
	 fbp->status = 0;
         return -1;
         }
      l = strlen(buf);
      if (l>0 && buf[l-1] == '\n') l--;
      if (l>0 && buf[l-1] == '\r' && (fbp->status & Fs_Untrans) == 0) l--;
      if (feof(fd)) {
         _pclose(fd);
	 fbp->status = 0;
         }
      return l;
      }
#endif					/* NT */

   l = 0;

#ifdef PosixFns
   /* If there are saved chars in the static buffer, use those */
   if (nsaved > 0) {
      strncpy(buf, savedbuf, nsaved);
      l = nsaved;
      buf += l;
   }
#endif

   while (1) {

#ifdef Graphics
      /* insert non-blocking read/code to service windows here */
#endif					/* Graphics */

#if NT
   if (fbp->status & Fs_Pipe) {
      if (feof(fd)) {
         _pclose(fd);
	 fbp->status = 0;
         if (l>0) return 1;
         else return -1;
         }
      }
#endif					/* NT */
      if ((c = fgetc(fd)) == '\n') {	/* \n terminates line */
	 break;
         }

      if (c == '\r' && (fbp->status & Fs_Untrans) == 0) {
	 /* \r terminates line in translated mode */
#if NT
   if (fbp->status & Fs_Pipe) {
      if (feof(fd)) {
         _pclose(fd);
	 fbp->status = 0;
         if (l>0) return 1;
         else return -1;
         }
      }
#endif					/* NT */
	 if ((c = fgetc(fd)) != '\n')	/* consume following \n */
	     ungetc(c, fd);		/* (put back if not \n) */
	 break;
	 }
#if NT
   if (fbp->status & Fs_Pipe) {
      if (feof(fd)) {
         _pclose(fd);
	 fbp->status = 0;
         if (l>0) return 1;
         else return -1;
         }
      }
#endif					/* NT */
      if (c == EOF) {
#if NT
         if (fbp->status & Fs_Pipe) {
            _pclose(fd);
	    fbp->status = 0;
            }
#endif					/* NT */

#ifdef PosixFns
	 /* If errno is EAGAIN, we will not return any chars just yet */
	 if (errno == EAGAIN 
#if !NT
	    || errno == EWOULDBLOCK
#endif
	 ) {
	    return -1;
	 }
#endif					/* PosixFns */

	 if (l > 0) {
#ifdef PosixFns
	    /* Clear the saved chars buffer */
	    nsaved = 0;
#endif					/* PosixFns */
	    return l;
	    } 
	 else return -1;
	 }
      if (++l > maxi) {
	 ungetc(c, fd);
#ifdef PosixFns
	 /* Clear the saved chars buffer */
	 nsaved = 0;
#endif					/* PosixFns */
	 return -2;
	 }
#ifdef PosixFns
      savedbuf[nsaved++] = c;
#endif					/* PosixFns */
      *buf++ = c;
      }

#ifdef PosixFns
   /* We can clear the saved static buffer */
   nsaved = 0;
#endif					/* PosixFns */

   return l;
   }

/*
 * iconhost - return some sort of host name into the buffer pointed at
 *  by hostname.  This code accommodates several different host name
 *  fetching schemes.
 */
void iconhost(hostname)
char *hostname;
   {

#ifdef HostStr
   /*
    * The string constant HostStr contains the host name.
    */
   strcpy(hostname,HostStr);
#elif VMS				/* HostStr */
   /*
    * VMS has its own special logic.
    */
   char *h;
   if (!(h = getenv("ICON_HOST")) && !(h = getenv("SYS$NODE")))
      h = "VAX/VMS";
   strcpy(hostname,h);
#else					/* HostStr */
   {
   /*
    * Use the uname system call.  (POSIX)
    */
   struct utsname utsn;
   uname(&utsn);
   strcpy(hostname,utsn.nodename);
   }
#endif					/* HostStr */

   }

/*
 * Read a long string in shorter parts. (Standard read may not handle long
 *  strings.)
 */
word longread(s,width,len,fd)
FILE *fd;
int width;
char *s;
long len;
{
   tended char *ts = s;
   long tally = 0;
   long n = 0;

#if NT
   /*
    * Under NT/MSVC++, ftell() used in Icon where() returns bad answers
    * after a wlongread().  We work around it here by fseeking after fread.
    */
   long pos = ftell(fd);
#endif					/* NT */

#ifdef XWindows
   if (isatty(fileno(fd))) wflushall();
#endif					/* XWindows */

   while (len > 0) {
      n = fread(ts, width, (int)((len < MaxIn) ? len : MaxIn), fd);
      if (n <= 0) {
#if NT
         fseek(fd, pos + tally, SEEK_SET);
#endif					/* NT */
         return tally;
	 }
      tally += n;
      ts += n;
      len -= n;
      }
#if NT
   fseek(fd, pos + tally, SEEK_SET);
#endif					/* NT */
   return tally;
   }

#ifdef RecordIO
/*
 * Write string referenced by descriptor d, avoiding a record break.
 *  Applies only to files openend with mode "s".
 */

int putrec(f, d)
register FILE *f;
dptr d;
   {
#if SASC
   register char *s;
   register word l;

   l = StrLen(*d);
   if (l == 0)
      return Succeeded;
   s = StrLoc(*d);

   if (afwriteh(s,1,l,f) < l)
      return Failed;
   else
      return Succeeded;
   /*
    * Note:  Because RecordIO depends on SASC, and because SASC
    *  uses its own malloc rather than the Icon malloc, file usage
    *  cannot cause a garbage collection.  This may require
    *  reevaluation if RecordIO is supported for any other compiler.
    */
#endif					/* SASC */
   }
#endif					/* RecordIO */

/*
 * Print string referenced by descriptor d. Note, d must not move during
 *   a garbage collection.
 */

int putstr(f, d)
register FILE *f;
dptr d;
   {
   register char *s;
   register word l;
   register int  i;

   l = StrLen(*d);
   if (l == 0)
      return  Succeeded;
   s = StrLoc(*d);

#ifdef MSWindows
#ifdef ConsoleWindow
   if ((f == stdout && !(ConsoleFlags & StdOutRedirect)) ||
	(f == stderr && !(ConsoleFlags & StdErrRedirect))) {
      if (ConsoleBinding == NULL)
         ConsoleBinding = OpenConsole();
      { int i; for(i=0;i<l;i++) Consoleputc(s[i], f); }
      return Succeeded;
      }
#endif					/* ConsoleWindow */
#endif					/* MSWindows */
#ifdef PresentationManager
   if (ConsoleFlags & OutputToBuf) {
      /* check for overflow */
      if (MaxReadStr * 4 - ((int)ConsoleStringBufPtr - (int)ConsoleStringBuf) < l + 1)
	 return Failed;
      /* big enough */
      memcpy(ConsoleStringBufPtr, s, l);
      ConsoleStringBufPtr += l;
      *ConsoleStringBufPtr = '\0';
      } /* End of if - push to buffer */
   else if ((f == stdout && !(ConsoleFlags & StdOutRedirect)) ||
	    (f == stderr && !(ConsoleFlags & StdErrRedirect)))
      wputstr((wbinding *)PMOpenConsole(), s, l);
   return Succeeded;
#endif					/* PresentationManager */
#if VMS
   /*
    * This is to get around a bug in VMS C's fwrite routine.
    */
   {
      int i;
      for (i = 0; i < l; i++)
         if (putc(s[i], f) == EOF)
            break;
      if (i == l)
         return Succeeded;
      else
         return Failed;
   }
#else					/* VMS */
   if (longwrite(s,l,f) < 0)
      return Failed;
   else
      return Succeeded;
#endif					/* VMS */
   }

/*
 * Wait for input to become available on fd, with timeout of t ms
 */
iselect(fd, t)
int fd, t;
   {

#ifdef PosixFns
   struct timeval tv;
   fd_set fds;
   tv.tv_sec = t/1000;
   tv.tv_usec = (t % 1000) * 1000;
#if !NT
   FD_ZERO(&fds);
#endif					/* NT */
   FD_SET(fd, &fds);
   return select(fd+1, &fds, NULL, NULL, &tv);
#else					/* PosixFns */
   return -1;
#endif					/* PosixFns */

   }

/*
 * idelay(n) - delay for n milliseconds
 */
int idelay(n)
int n;
   {

/*
 * The following code is operating-system dependent [@fsys.01].
 */
#if OS2
#if OS2_32
   DosSleep(n);
   return Succeeded;
#else					/* OS2_32 */
   return Failed;
#endif					/* OS2_32 */
#endif					/* OS2 */

#if VMS
   delay_vms(n);
   return Succeeded;
#endif					/* VMS */

#if SASC
   sleepd(0.001*n);
   return Succeeded;
#endif                                   /* SASC */

#if UNIX
   struct timeval t;
   t.tv_sec = n / 1000;
   t.tv_usec = (n % 1000) * 1000;
   select(1, NULL, NULL, NULL, &t);
   return Succeeded;
#endif					/* UNIX */

#if MSDOS
#if SCCX_MX
   msleep(n);
   return Succeeded;
#else					/* SCCX_MX */
#if NT
#ifdef MSWindows
   Sleep(n);
#else					/* MSWindows */
   /*
    * In the old DOS documentation, sleep(n) took a # of seconds to sleep,
    * but VC++ 2.0's _sleep() seems to be taking milliseconds.
    */
   _sleep(n);

#endif					/* MSWindows */
   return Succeeded;
#else					/* NT */
   return Failed;
#endif					/* NT */
#endif					/* SCCX_MX */
#endif					/* MSDOS */

#if MACINTOSH
   void MacDelay(int n);
   MacDelay(n);
   return Succeeded;
#endif					/* MACINTOSH */


#if AMIGA
#if __SASC
   Delay(n/20);
   return Succeeded;
#else					/* __SASC */
   return Failed
#endif                                  /* __SASC */
#endif					/* AMIGA */

#if PORT || ARM || ATARI_ST || MVS || VM
   return Failed;
#endif					/* PORT || ARM || ATARI_ST ... */

   /*
    * End of operating-system dependent code.
    */
   }

#ifdef Network

/* 
 * parsing the url, separate scheme, host, port, path parts 
 * the function calling it allocate space for variables scheme,
 * host, port, and path.
*/

void parse_url(char *url, char *scheme, char *host, int *port, char *path)
{
   char *slash, *colon;
   char *delim;
   char turl[MAXPATHLEN]; /* MAXPATHLEN = 1024 in sys/param.h */
   char *t;
   int NOHOST = 0;

   /* All operations on turl so as not to mess contents of url */
  
   strcpy(turl, url);

   delim = "://";

   if ((colon = strstr(turl, delim)) == NULL) {
      if ( *turl == '/' ) {
         strcpy(scheme, "file");
	 NOHOST = 1;
	 t = turl + 1;
      }
      else {
	 strcpy(scheme, "http");
	 t = turl;
      }
   } 
   else {
      *colon = '\0';
      strcpy(scheme, turl);
      if ( strcasecmp(scheme, "file") == 0 )
	 NOHOST = 1;
      t = colon + strlen(delim);
   }

   /* Now t points to the beginning of host name */

   if ((slash = strchr(t, '/')) == NULL) {
      /* If there isn't even one slash, the path must be empty */
      if ( NOHOST == 0 ) {
         strcpy(host, t);
	 strcpy(path, "/");
      }
      else {
	 host = NULL; 
	 strcpy(path, "/");
	 strcat(path, t);
      }
   } 
   else {
      if ( NOHOST == 0 ) {		
         strcpy(path, slash);
	 *slash = '\0';	/* Terminate host name */
	 strcpy(host, t);
      }
      else {
	 strcpy(path, "/");
	 strcat(path, t);
	 host = NULL;
      }
   }

   /* Check if the hostname includes ":portnumber" at the end */

   if ( NOHOST == 0 ) {
      if ((colon = strchr(host, ':')) == NULL) 
	 *port = 80;	/* HTTP standard */
      else {
	 *colon = '\0';
	 if (isdigit(colon[1])) *port = atoi(colon + 1);
	 else {
	    /*
	     * : with no number following (site:/file) denotes the default port
	     */
	    *port = 80;
	    }
      }
   }
}

void myhandler(int i)
{
fprintf(stderr, "I am handling things by not handling them\n");
}

/* 
 * urlopen opens a local file or a remote file depending on the url input.
 * It checks the http_proxy environment variable. If it is set, then sending
 * the request to the proxy server for the remote file, otherwise, only support
 * sending the http request to the remote http server for retrieving the file at
 * the remote site.
*/
 
int urlopen(char *url, int flag, struct netfd *retval)
{
   char request[MAXPATHLEN + 35];
   char scheme[50], host[MAXPATHLEN], path[MAXPATHLEN];
   char *proxy;
   int port;
   struct hostent *nameinfo;
   int s, rv;
   struct sockaddr_in addr;
   int file_flag = 0;

   if ( strncasecmp(url, "file:", 5) == 0 )
      file_flag = 1;
 
   if ((proxy = getenv("http_proxy")) == NULL || file_flag ) {
      parse_url(url, scheme, host, &port, path);

#ifdef DEBUG
      fprintf(stderr, "URL scheme = %s\n", scheme);
      fprintf(stderr, "URL host = %s\n", host); 
      fprintf(stderr, "URL port = %d\n", port);
      fprintf(stderr, "URL path = %s\n", path);
#endif

      if (strcasecmp(scheme, "http") != 0 && strcasecmp(scheme, "file") != 0) {
         fprintf(stderr, "httpget cannot operate on %s URLs without a proxy\n", scheme);
	 return -1; 
      }
   } 
   else {
      parse_url(proxy, scheme, host, &port, path);
   }

   if ( strcasecmp(scheme, "file") != 0 ) {
      /* Find out the IP address */

      if ((nameinfo = gethostbyname(host)) == NULL) {
         addr.sin_addr.s_addr = inet_addr(host);
	 if ((int)addr.sin_addr.s_addr == -1) {
            fprintf(stderr, "Unknown host %s\n", host);
	    return -2;
	 }
      } 
      else 
         memcpy((char *)&addr.sin_addr.s_addr, nameinfo->h_addr, nameinfo->h_length);

      /* Create socket and connect */
  
      if ((s = socket(PF_INET, SOCK_STREAM, 0)) == -1) {
	 perror("httpget: socket()");
	 return -3; 
      }
      addr.sin_family = AF_INET;
      addr.sin_port = htons(port);
  
      signal(SIGALRM, myhandler);
      alarm(5);
      if (connect(s, (struct sockaddr *)&addr, sizeof(addr)) == -1) {
	 if (errno == EINTR) { /* timed out */
	    alarm(0);
	    }
	 else {
	    alarm(0);
	    perror("httpget: connect()");
	    }
	 close(s);
	 s = -1;
	 return -4;
      }
      alarm(0);

      if (proxy) {
	 if ( flag == BODY_ONLY ) sprintf(request, "GET %s\r\n", url);
	 else if ( flag == HEADER_ONLY )
            sprintf(request, "HEAD %s HTTP/1.0\r\n", url);
      } 
      else {
	 if ( flag == BODY_ONLY ) sprintf(request, "GET %s\r\n", path);
	 else if ( flag == HEADER_ONLY )
	    sprintf(request, "HEAD %s HTTP/1.0\r\n", path);
      }

      strcat(request, "Accept: */*\r\n\r\n");
  
      write(s, request, strlen(request));

      retval->flag = HTTP_FLAG;
   }
   else {
      if ( (s = open(path, O_RDONLY)) == -1 ) {
         fprintf(stderr, "file open error: %s\n", strerror(errno));	
         return -5;
      }
      retval->flag = FILE_FLAG;	
   }

   retval->s = s; 

   return 0; /* success */
}


/*
 * netopen calls urlopen and change the file descriptor or socket ID into
 * the FILE *.
*/

FILE * netopen(char *url, char *type)
{
   struct netfd temp;
   FILE *fp;
   int retval;

   if ( (retval = urlopen(url, BODY_ONLY, &temp)) < 0 ) {
      fprintf(stderr, "netopen: urlopen(%s) failed with error code: %d\n", url,
		  retval);
      return NULL;
   }

   fp = fdopen(temp.s, type);
   return (fp);
}

/*
 * Open the socket for the host specified in the url using the port specified
 * or using 80 as default. Return FILE * associated with the opened socket ID.
*/

FILE *socketopen(char *url, char *type)
{
   FILE *fp;
   char *host, *colon;
   int port;
   char turl[MAXPATHLEN];
   struct hostent *nameinfo;
   int s;
   struct sockaddr_in addr;
 
   strcpy(turl, url);
 
/* parsing the url to get host name and port number */
 
   if ( (colon = strchr(turl, ':')) != NULL ) {
      *colon = '\0';
      host = colon + 1;
   }
   else {
      fprintf(stderr, "no host name specified\n");
      return NULL;
   }

   if ( (colon = strchr(host, ':')) != NULL ) {
      *colon = '\0';
      port = atoi(colon + 1);
   }
   else 
      port = 80;

/* Find out the IP address */

   if ((nameinfo = gethostbyname(host)) == NULL) {
      addr.sin_addr.s_addr = inet_addr(host);
      if ((int)addr.sin_addr.s_addr == -1) {
         fprintf(stderr, "Unknown host %s\n", host);
         return NULL; 
      }
   }
   else 
      memcpy((char *)&addr.sin_addr.s_addr, nameinfo->h_addr, nameinfo->h_length);
 
 
/* Create socket and connect */
 
   if ((s = socket(PF_INET, SOCK_STREAM, 0)) == -1) {
      perror("httpget: socket()");
      return NULL; 
   }
   addr.sin_family = AF_INET;
   addr.sin_port = htons(port);
 
   if (connect(s, (struct sockaddr *)&addr, sizeof(addr)) == -1) {
      perror("socketopen: connect()");
      return NULL; 
   }
 
   fp = fdopen(s, "r+");
        
   return (fp);
}        


/*
 *  parse the http header information 
*/

void parse_token (char *s, struct http_stat *buf)
{
   char *tmp;

   tmp = strchr(s, ':');

   if (tmp == NULL) {
      return;
      }
   *tmp++ = '\0'; /* past : */
   if (isspace(*tmp)) tmp++; /* past space past : */
   if (tmp[strlen(tmp)-1] == '\015') /* truncate trailing carriage return */
      tmp[strlen(tmp)-1] = '\0';
	
   if ( strcasecmp (s, "server") == 0 ) {
      buf->server = strdup(tmp);
      }
   else if ( strcasecmp(s, "location") == 0 )
      buf->location = strdup(tmp);
   else if ( strcasecmp(s, "content-type") == 0 )
      buf->type = strdup(tmp);
   else if ( strcasecmp(s, "date") == 0 )
      buf->date = strdup(tmp);
   else if ( strcasecmp(s, "last-modified") == 0 )
      buf->last_mod = strdup(tmp);
   else if ( strcasecmp(s, "expires") == 0 )
      buf->exp_date = strdup(tmp);
   else if ( strcasecmp(s, "content-length") == 0 )
      buf->length = atoi(tmp);
   else 
      {};
/*  fprintf(stderr, "This info is not collected: %s\n", s);	*/
}

/* 
 * parsing the status line of the http return header.
*/

void parse_statline ( char *s, struct http_stat *buf)
{
   char *tmp;
   int scode;
	
   tmp = strchr (s, ' ');
   tmp ++;
   scode = atoi (tmp);

   switch ( scode ) {
      case 200:
         buf->scode = OK;
	 break;
      case 201:
	buf->scode = CREATED;   
	break;
      case 202:
         buf->scode = ACCEPTED;
         break;
      case 204:
         buf->scode = NOCONTENT;
         break;
      case 301: 
         buf->scode = MV_PERM;
         break;
      case 302:
         buf->scode = MV_TEMP;
         break;
      case 304:
         buf->scode = NOT_MOD;
         break;
      case 400:
         buf->scode = BAD;
         break;
      case 401:
         buf->scode = UNAUTH;
         break;
      case 403: 
         buf->scode = FORB;
         break;
      case 404:
         buf->scode = NOTFOUND;
         break;
      case 500:
         buf->scode = SERERROR;
         break;
      case 501:
         buf->scode = NOT_IMPL;
         break;
      case 502:
         buf->scode = BADGATE;
         break;
      case 503:	
         buf->scode = UNAVAIL;
         break;
      default:
         printf("Not valid code\n");
         break;
   }
}

/*	
     Upon successful completion a value of 0 is returned.  Other-
     wise, a negative value is returned and errno is set to indicate
     the error. 
*/

int hstat (int sd, struct http_stat *buf )
{
   char temp[BUFLEN+1];
   int  bytes;
   char *str = NULL;
   char *ptr;

   /* initialize buf structure */

   buf->location = NULL;
   buf->server = NULL;
   buf->type = NULL;
   buf->date = NULL;
   buf->last_mod = NULL;
   buf->exp_date = NULL;
   buf->length = 0;

/* read in whole header and store it in a buffer pointed by str. */

   while ((bytes = read(sd, temp, BUFLEN)) != 0) {
      temp[bytes] = '\0';
      if ( str == NULL ) {
         if ( (str = malloc(bytes) ) == NULL ) {
            fprintf(stderr, "malloc fail: %s \n", strerror(errno));
            return -1;
	 }
         strcat (str, temp);
      }
      else {
         if ( (str = realloc (str, strlen(str)+bytes+1) ) == NULL ) {
            fprintf(stderr, "realloc fail: %s \n", strerror(errno));
	    return -2;
	 }
	 strcat (str, temp);
      }
   }

/* parse the buffer pointed by str, line by line using the delimiter '\n' */

   if ( (ptr = strtok (str, "\n") )== NULL ) {
      /* fprintf(stderr, "empty header, %d bytes\n", bytes); */
      return  -3;
   }
   else 
      parse_statline (ptr, buf);

   while ( (ptr = strtok (NULL, "\n")) != NULL )
      parse_token (ptr, buf); 

   free(str);
   return 0;
}

/* 
     Upon successful completion a value of 0 is returned.  Other-
     wise, a value of -1 is returned and errno is set to indicate
     the error. The file status information is saved in the structure
     buf.
*/
 
int netstatus (char *url, struct netstat *buf)
{
   struct netfd temp;
   int retval;
   int rel;

   if ( (rel = urlopen(url, HEADER_ONLY, &temp)) < 0 ) {
      fprintf(stderr, "netstatus: urlopen(%s) failed with return value: %d\n",
		url, rel) ; 
      return -1;
   }

   switch (temp.flag) {
      case FILE_FLAG: 
         buf->flag = FILE_FLAG;
	 retval = fstat (temp.s, &(buf->u.fbuf) );
	 break;	

      case HTTP_FLAG:
         buf->flag = HTTP_FLAG;
	 retval = hstat (temp.s, &(buf->u.hbuf) );
	 break;			
   }

   close (temp.s);
   return retval;
}
#endif					/* Network */

#ifdef FAttrib
/*
 * make_mode takes mode_t type (an integer) input and returns the file permission
 * in the format of a string.
*/
#if UNIX
char *make_mode (mode_t st_mode)
#endif					/* UNIX */
#if MSDOS
char *make_mode (unsigned short st_mode)
#endif					/* MSDOS */
{
   char *buf;

   if ( (buf = (char *) malloc(sizeof(char)*11)) == NULL ) {
      fprintf(stderr,"fatal malloc error\n");
      return NULL;
   }

#if UNIX
   if ( st_mode & S_IFIFO )      buf[0] = 'f';
   else if ( st_mode & S_IFCHR ) buf[0] = 'c';
   else if ( st_mode & S_IFDIR ) buf[0] = 'd';
   else if ( st_mode & S_IFBLK ) buf[0] = 'b';
   else if ( st_mode & S_IFREG ) buf[0] = '-';
   else			         buf[0] = '\?';

   if (st_mode & S_IRUSR) buf[1] = 'r';
   else    buf[1] = '-';
   if (st_mode & S_IWUSR) buf[2] = 'w';
   else    buf[2] = '-';
   if (st_mode & S_IXUSR) buf[3] = 'x';
   else    buf[3] = '-';
   if (st_mode & S_IRGRP) buf[4] = 'r';
   else    buf[4] = '-';
   if (st_mode & S_IWGRP) buf[5] = 'w';
   else    buf[5] = '-';
   if (st_mode & S_IXGRP) buf[6] = 'x';
   else    buf[6] = '-';
   if (st_mode & S_IROTH) buf[7] = 'r';
   else    buf[7] = '-';
   if (st_mode & S_IWOTH) buf[8] = 'w';
   else    buf[8] = '-';
   if (st_mode & S_IXOTH) buf[9] = 'x';
   else    buf[9] = '-';
#endif					/* UNIX */
#if MSDOS
   if ( st_mode & _S_IFIFO )      buf[0] = 'f';
   else if ( st_mode & _S_IFCHR ) buf[0] = 'c';
   else if ( st_mode & _S_IFDIR ) buf[0] = 'd';
   else if ( st_mode & _S_IFREG ) buf[0] = '-';
   else			         buf[0] = '\?';

   if (st_mode & S_IREAD) buf[1] = 'r';
   else    buf[1] = '-';
   if (st_mode & S_IWRITE) buf[2] = 'w';
   else    buf[2] = '-';
   if (st_mode & S_IEXEC) buf[3] = 'x';
   else    buf[3] = '-';
   if (st_mode & S_IREAD) buf[4] = 'r';
   else    buf[4] = '-';
   if (st_mode & S_IWRITE) buf[5] = 'w';
   else    buf[5] = '-';
   if (st_mode & S_IEXEC) buf[6] = 'x';
   else    buf[6] = '-';
   if (st_mode & S_IREAD) buf[7] = 'r';
   else    buf[7] = '-';
   if (st_mode & S_IWRITE) buf[8] = 'w';
   else    buf[8] = '-';
   if (st_mode & S_IEXEC) buf[9] = 'x';
   else    buf[9] = '-';
#endif					/* MSDOS */
 
   buf[10] = '\0';

   return buf;     
}

#endif					/* FAttrib */

#if NT
#ifdef Dbm
/*
 * Win32 does not provide a link() function expected by GDBM.
 * Cross fingers and hope that copy-on-link semantics will work.
 */
int link(char *s1, char *s2)
{
   int c;
   FILE *f1 = fopen(s1,"r"), *f2;
   if (f1 == NULL) return -1;
   f2 = fopen(s2, "w");
   if (f2 == NULL) { fclose(f1); return -1; }
   while ((c = fgetc(f1)) != EOF) fputc(c, f2);
   fclose(f1);
   fclose(f2);
   return 0;
}
#endif					/* Dbm */
#endif					/* NT */
