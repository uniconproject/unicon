/*
 * File: rsys.r
 *  Contents: [flushrec], [getrec], getstrg, host, longread, [putrec], putstr
 */

#ifdef PosixFns
#ifndef SOCKET_ERROR
#define SOCKET_ERROR -1
#endif
/*
 * sock_getstrg - read a line into buf from socket.  At most maxi
 * characters are read.  Returns the length of the line, not counting
 * the newline.  Returns -1 if EOF, and -3 if a socket error occurs.
 */
int sock_getstrg(buf, maxi, file)
register char *buf;
int maxi;
dptr file;
   {
   int r = 0, i=0;
   char *stmp=NULL;

#if HAVE_LIBSSL
   if (BlkD(*file, File)->status & Fs_Encrypt) {
     r = SSL_peek(BlkD(*file, File)->fd.ssl, buf, maxi);
     if (r == 0) {
       if (set_ssl_connection_errortext(BlkD(*file, File)->fd.ssl, r) == SSL_ERROR_ZERO_RETURN)
	 return -1;
       else
	 return -3;
     }
   }
   else
#endif					/* LIBSSL */
   if ((r=recv((SOCKET)BlkD(*file,File)->fd.fd, buf, maxi, MSG_PEEK))==SOCKET_ERROR) {
#if NT
      i = WSAGetLastError();
      if (i == WSAESHUTDOWN)   
	 return -1;
      set_errortext(1040); /* could use i to do better */
#else					/* NT */
      set_syserrortext(errno);
#endif					/* NT */
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

#if HAVE_LIBSSL
   if (BlkD(*file, File)->status & Fs_Encrypt) {
     r = SSL_read(BlkD(*file,File)->fd.ssl, buf, i);
     if (r == 0) {
       if (set_ssl_connection_errortext(BlkD(*file,File)->fd.ssl, r) == SSL_ERROR_ZERO_RETURN)
	 return -1;
       else
	 return -3;
     }
   }
   else
#endif					/* LIBSSL */
   if ((r=recv((SOCKET)BlkD(*file,File)->fd.fd, buf, i, 0)) == SOCKET_ERROR) {
#if NT
     if (WSAGetLastError() == WSAESHUTDOWN)
	 return -1;
#endif					/* NT */
      set_errortext(1040);
      return -3;
      }
   return r;
   }
#endif					/* NT */

#if NT
#if !defined(NTGCC)
#define pclose _pclose
#endif					/* !NTGCC */
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
   register int c, l;
   FILE *fd = fbp->fd.fp;

#if defined(PosixFns) && !defined(Concurrent)
   /*
    * Think about doing a thread-safe implementation,
    * so Concurrent uses this logic.
    */
   static char savedbuf[BUFSIZ];
   static int nsaved = 0;
#endif					/* PosixFns */

#ifdef Messaging
   if (fbp->status & Fs_Messaging) {
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
      else if ((buf[l-1] == '\0') && (l==maxi)) {
	 return -2;
	 }
      if ((!(fbp->status & Fs_Untrans)) && (buf[l-1] == '\r')) {
	 l--;
	 }
      return l;
      }
#endif                                  /* Messaging */

#ifdef XWindows
   wflushall();
#endif					/* XWindows */
#if NT
   if (fbp->status & Fs_Pipe) {
      if (feof(fd) || (fgets(buf, maxi, fd) == NULL)) {
         pclose(fd);
	 fbp->status = Fs_Pipe;
         return -1;
         }
      l = strlen(buf);
      if (l>0 && buf[l-1] == '\n') l--;
      if (l>0 && buf[l-1] == '\r' && (fbp->status & Fs_Untrans) == 0) l--;
      if (feof(fd)) {
         pclose(fd);
	 fbp->status = 0;
         }
      return l;
      }
#endif					/* NT */

   l = 0;

#if defined(PosixFns) && !defined(Concurrent)
   /* If there are saved chars in the static buffer, use those */
   if (nsaved > 0) {
      strncpy(buf, savedbuf, nsaved);
      l = nsaved;
      buf += l;
   }
#endif					/* PosixFns */

   while (1) {

#ifdef Graphics
      /* insert non-blocking read/code to service windows here */
#endif					/* Graphics */

#if NT
      if (fbp->status & Fs_Pipe) {
	 if (feof(fd)) {
	    pclose(fd);
	    fbp->status = 0;
	    if (l>0) return 1;
	    else return -1;
	    }
	 }
#endif					/* NT */
      errno = 0;
      if ((c = fgetc(fd)) == '\n') {	/* \n terminates line */
	 break;
         }

      if (c == '\r' && (fbp->status & Fs_Untrans) == 0) {
	 /* \r terminates line in translated mode */
#if NT
   if (fbp->status & Fs_Pipe) {
      if (feof(fd)) {
         pclose(fd);
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
         pclose(fd);
	 fbp->status = 0;
         if (l>0) return 1;
         else return -1;
         }
      }
#endif					/* NT */
      if (c == EOF) {
#if NT
         if (fbp->status & Fs_Pipe) {
            pclose(fd);
	    fbp->status = 0;
            }
#endif					/* NT */

#ifdef PosixFns
	 /*
	  * If errno is EAGAIN, we will not return any chars just yet.
	  */
	 if (errno == EAGAIN 
#if !NT
	    || errno == EWOULDBLOCK
#endif
	 ) {
	    return -1;
	 }
#endif					/* PosixFns */

	 if (l > 0) {
#if defined(PosixFns) && !defined(Concurrent)
	    /* Clear the saved chars buffer */
	    nsaved = 0;
#endif					/* PosixFns && !Concurrent */
	    return l;
	    } 
	 else {
	    return -1;
	    }
	 }
      if (++l > maxi) {
	 ungetc(c, fd);
#if defined(PosixFns) && !defined(Concurrent)
	 /* Clear the saved chars buffer */
	 nsaved = 0;
#endif					/* PosixFns && !Concurrent */
	 return -2;
	 }
#if defined(PosixFns) && !defined(Concurrent)
      savedbuf[nsaved++] = c;
#endif					/* PosixFns && !Concurrent */
      *buf++ = c;
      }

#if defined(PosixFns) && !defined(Concurrent)
   /* We can clear the saved static buffer */
   nsaved = 0;
#endif					/* PosixFns && !Concurrent */

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
   char *h, hbuf[256];
   if ((getenv_r("ICON_HOST", hbuf, 255)) && (getenv_r("SYS$NODE", hbuf, 255)))
      h = "VAX/VMS";
    else
      h=hbuf;
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
 * Read a long string in shorter parts. (Standard read may not handle
 *  long strings.)
 */
word longread(s,width,len,fd)
FILE *fd;
int width;
char *s;
word len;
{
   tended char *ts = s;
   word tally = 0;
   word n = 0;

#if NT
   /*
    * Under NT, ftell() used in Icon where() returns bad answers
    * after a wlongread().  We work around it here by fseeking after fread.
    */
   word pos = ftell(fd);
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


#if HAVE_LIBZ
/*
 * Read a long string in shorter parts from a compressed file. 
 * (Standard read may not handle long strings.)
 */
word gzlongread(s,width,len,fd)
char *s;
int width;
word len;
FILE *fd;
{
   tended char *ts = s;
   word tally = 0;
   word n = 0;

#ifdef NT_FIXFTELL
   /*
    * Under NT, ftell() used in Icon where() returns bad answers
    * after a wlongread().  We work around it here by fseeking after fread.
    *
    * Update (Feb/2017): This seems to have the opposite effect on newer
    * systems, i.e. it breaks ftell rather than fixing it.
    * We are keeping it under a special symbol and will only
    * be turned on if it is asked for explicitly.
    */
   word pos = ftell(fd);
#endif					/* NT_FIXFTELL */

#if defined(XWindows) && !defined(MacOS)
   if (isatty(fileno(fd))) wflushall();
#endif					/* XWindows && !MacOS */

   while (len > 0) {
      n = gzread(fd,ts, width * ((int)((len < MaxIn) ? len : MaxIn)));
      if (n <= 0) {
#ifdef NT_FIXFTELL
         gzseek(fd, pos + tally, SEEK_SET);
#endif					/* NT_FIXFTELL */
         return tally;
	 }
      tally += n;
      ts += n;
      len -= n;
      }
#ifdef NT_FIXFTELL
   gzseek(fd, pos + tally, SEEK_SET);
#endif					/* NT_FIXFTELL */
   return tally;
   }

#endif					/* HAVE_LIBZ */



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
   l = StrLen(*d);
   if (l == 0)
      return  Succeeded;
   s = StrLoc(*d);

   if (checkOpenConsole(f, s)) return Succeeded;

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
 * Wait for input to become available on fd, with timeout of t ms.
 */
int iselect(int fd, int t)
   {

#ifdef PosixFns
   struct timeval tv;
   fd_set fds;
   tv.tv_sec = t/1000;
   tv.tv_usec = (t % 1000) * 1000;
   FD_ZERO(&fds);
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
   if (n == 0) return Succeeded; /* delay < 0 = no delay */
#ifdef Concurrent
   if (n < 0){  /* delay < 0 = block the current thread */
      CURTSTATE();
      DEC_NARTHREADS;
      sem_wait(curtstate->c->semp);		/* block this thread */
      INC_NARTHREADS_CONTROLLED;
      return Succeeded; 
      }
#endif					/* Concurrent */        

/*
 * The following code is operating-system dependent [@fsys.01].
 */
#if VMS
   delay_vms(n);
   return Succeeded;
#endif					/* VMS */

#if UNIX
   {
   struct timeval t;
#if defined(KbhitPoll) || defined(KbhitIoctl)
   struct pollfd fd_stdin;
   fd_stdin.fd = fileno(stdin);
   fd_stdin.events = POLLIN;
   poll(&fd_stdin, 1, n);
#else					/* KbhitPoll || KbhitIoctl */
   t.tv_sec = n / 1000;
   t.tv_usec = (n % 1000) * 1000;
   DEC_NARTHREADS;
   select(1, NULL, NULL, NULL, &t);
   INC_NARTHREADS_CONTROLLED;
#endif					/* KbhitPoll || KbhitIoctl */
   return Succeeded;
   }
#endif					/* UNIX */

#if MSDOS
#if NT
   DEC_NARTHREADS;
   Sleep(n);
   INC_NARTHREADS_CONTROLLED;
   return Succeeded;
#else					/* NT */
   return Failed;
#endif					/* NT */
#endif					/* MSDOS */

#if MACINTOSH
   void MacDelay(int n);
   DEC_NARTHREADS;
   MacDelay(n);
   INC_NARTHREADS_CONTROLLED;
   return Succeeded;
#endif					/* MACINTOSH */

#if PORT || MVS || VM
   return Failed;
#endif					/* PORT || ... */

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

void parse_url(char *url, char *scheme, char *host, char *port, char *path)
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
	 strcpy(port, "http");
      else {
	 *colon = '\0';
	 if (isdigit(colon[1]))
	   strcpy(port, colon + 1);
	 else {
	    /*
	     * : with no number following (site:/file) denotes the default port
	     */
	    strcpy(scheme, "http");
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
 * sending the http request to the remote http server for retrieving the file
 * at the remote site.
 */
 
int urlopen(char *url, int flag, struct netfd *retval)
{
   char request[MAXPATHLEN + 35];
   char scheme[50], host[MAXPATHLEN], path[MAXPATHLEN];
   char *proxy, proxybuf[256];
   char* port[MAXPATHLEN];
   int s, rv;
   int file_flag = 0;
   struct addrinfo *res0, *res;

   if ( strncasecmp(url, "file:", 5) == 0 )
      file_flag = 1;
   if (getenv_r("http_proxy", proxybuf, 255)==0)
      proxy=proxybuf;
   else
      proxy=NULL;

   if (proxy == NULL || file_flag ) {
      parse_url(url, scheme, host, port, path);

#ifdef DEBUG
      fprintf(stderr, "URL scheme = %s\n", scheme);
      fprintf(stderr, "URL host = %s\n", host); 
      fprintf(stderr, "URL port = %s\n", port);
      fprintf(stderr, "URL path = %s\n", path);
#endif

      if (strcasecmp(scheme, "http") != 0 && strcasecmp(scheme, "file") != 0) {
         fprintf(stderr, "httpget cannot operate on %s URLs without a proxy\n", scheme);
	 return -1; 
      }
   } 
   else {
      parse_url(proxy, scheme, host, port, path);
   }

   if ( strcasecmp(scheme, "file") != 0 ) {
      /* Find out the IP address */
      res0 = uni_getaddrinfo(host, port, SOCK_STREAM, AF_INET);
      if (!res0)
	return NULL;

      s = -1;
      for (res = res0; res; res = res->ai_next) {
	s = socket(res->ai_family, res->ai_socktype,
		   res->ai_protocol);
	if (s >= 0)
	  break;  /* okay we got one */
      }

      if (s < 0) {
	// failed to create a socket to any of the resloved names
	freeaddrinfo(res0);
	set_syserrortext(errno);
	return -3;
      }
  
      signal(SIGALRM, myhandler);
      alarm(5);
      if (connect(s, res->ai_addr, res->ai_addrlen) == -1) {
         alarm(0);
	 if (errno != EINTR) { /* if not just a timeout, print an error */
	    freeaddrinfo(res0);
	    set_syserrortext(errno);
	    //perror("httpget: connect()");
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
   char *host, *colon, *port;
   char turl[MAXPATHLEN];
   int s;
   struct addrinfo *res0, *res;

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
      port = colon + 1;
   }
   else 
      port = "http";

   /* Find out the IP address */
   res0 = uni_getaddrinfo(host, port, SOCK_STREAM, AF_INET);
   if (!res0)
     return NULL;

   s = -1;
   for (res = res0; res; res = res->ai_next) {
     s = socket(res->ai_family, res->ai_socktype,
		res->ai_protocol);
     if (s >= 0)
       break;  /* okay we got one */
   }

   if (s < 0) {
     // failed to create a socket to any of the resloved names
     freeaddrinfo(res0);
     set_syserrortext(errno);
     return NULL;
   }

 
   if (connect(s, res->ai_addr, res->ai_addrlen) == -1) {
      freeaddrinfo(res0);
      set_syserrortext(errno);
      return NULL; 
   }

   freeaddrinfo(res0);
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

#if NT
#ifdef Dbm
/*
 * Win32 does not provide a link() function expected by GDBM.
 * Cross fingers and hope that copy-on-link semantics will work.
 */
int link(char *s1, char *s2)
{
   int c;
   FILE *f1 = fopen(s1,"rb"), *f2;
   if (f1 == NULL) return -1;
   f2 = fopen(s2, "wb");
   if (f2 == NULL) { fclose(f1); return -1; }
   while ((c = fgetc(f1)) != EOF) fputc(c, f2);
   fclose(f1);
   fclose(f2);
   return 0;
}
#endif					/* Dbm */

struct b_cons *LstTmpFiles;
void closetmpfiles()
{
   while (LstTmpFiles) {
      struct b_file *fp = Blk(LstTmpFiles->data,File);
      if (fp->status & (Fs_Read | Fs_Write)) {
	 fclose(fp->fd.fp);
	 fp->status = 0;
	 }
      remove(StrLoc(fp->fname));
      LstTmpFiles = (struct b_cons *)(LstTmpFiles->next);
      }
}

/*
 * tmpfile() from Mingw32 no longer works under Vista.
 */
FILE *mstmpfile()
{
   char *temp;
   FILE *f;

   if ((temp = _tempnam(NULL, "uni")) == NULL)
      return NULL;

   if ((f = fopen(temp, "w+b")) == NULL) {
      free(temp);
      return NULL;
      }
   free(temp);
   return f;
}
#endif					/* NT */

// FIXME: This is no longer needed on Windows with recent APIs 
#ifdef DROPNTGCC
/* libc replacement functions for win32.

Copyright (C) 1992, 93 Free Software Foundation, Inc.

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Library General Public
License as published by the Free Software Foundation; either
version 2 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Library General Public License for more details.

You should have received a copy of the GNU Library General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  */

/*
  This does make sense only under WIN32.
  Functions:
    - popen() rewritten
    - pclose() rewritten
    - stat() wrapper for _stat(), removing trailing slashes
  */

struct _popen_elt {
  FILE *f;                      /* File stream returned */
  HANDLE hp;                    /* Handle of associated process */
  struct _popen_elt *next;      /* Next list element */
};

static struct _popen_elt _z = { NULL, 0, &_z };
static struct _popen_elt *_popen_list = &_z;

FILE *popen (const char* cmd, const char *mode)
{
  STARTUPINFO si;
  PROCESS_INFORMATION pi;
  SECURITY_ATTRIBUTES sa = { sizeof(SECURITY_ATTRIBUTES), NULL, TRUE };
  FILE *f = NULL;
  int fno, i;
  HANDLE child_in, child_out;
  HANDLE father_in, father_out;
  HANDLE father_in_dup, father_out_dup;
  HANDLE current_in, current_out;
  HANDLE current_pid;
  int binary_mode;
  char *new_cmd, *app_name = NULL;
  char *p, *q;
  struct _popen_elt *new_process;
  char pname[PATH_MAX], *fp;
  char *suffixes[] = { ".bat", ".cmd", ".com", ".exe", NULL };
  char **s;
  int go_on;

  /*
   * Look for the application name along the PATH,
   * and decide to prepend "%COMSPEC% /c " or not to the command line.
   * Do nothing for the moment.
   */

  /* Another way to do that would be to try CreateProcess first without
     invoking cmd, and look at the error code. If it fails because of
     command not found, try to prepend "cmd /c" to the cmd line.
     */

  /* Look for the application name */
  for (p = (char *)cmd; *p && isspace(*p); p++);
  if (*p == '"') {
    q = ++p;
    while(*p && *p != '"') p++;
    if (*p == '\0') {
      fprintf(stderr, "popen: malformed command (\" not terminated)\n");
      return NULL;
    }
  }
  else
    for (q = p; *p && !isspace(*p); p++);
  /* q points to the beginning of appname, p to the last + 1 char */
  if ((app_name = malloc(p - q + 1)) == NULL) {
    fprintf(stderr, "xpopen: malloc(app_name) failed.\n");
    return NULL;
  }
  strncpy(app_name, q, p - q );
  app_name[p - q] = '\0';
  pname[0] = '\0';

  /* Looking for appname on the path */
  for (s = suffixes, go_on = 1; go_on; *s++) {
    if (SearchPath(NULL,        /* Address of search path */
                   app_name,    /* Address of filename */
                   *s,          /* Address of extension */
                   PATH_MAX,    /* Size of destination buffer */
                   pname,       /* Address of destination buffer */
                   &fp)         /* File part of app_name */
      != 0) {
      new_cmd = strdup(cmd);
      free(app_name);
      app_name = strdup(pname);
      break;
    }
    go_on = (*s != NULL);
  }
  if (go_on == 0) {
    /* the app_name was not found */
    char tmpbuf[256];
    int tmpsize;
    if (getenv_r("COMSPEC", tmpbuf, 255)==0)
      tmpsize=strlen(tmpbuf);
    else
      tmpsize=0;
       
    new_cmd = malloc(tmpsize+4+strlen(cmd)+1);
    sprintf(new_cmd, "%s /c %s",tmpbuf, cmd);
    free(app_name);
    app_name = NULL;
  }
  else {
  }

  current_in = GetStdHandle(STD_INPUT_HANDLE);
  current_out = GetStdHandle(STD_OUTPUT_HANDLE);
  current_pid = GetCurrentProcess();
  ZeroMemory( &si, sizeof(STARTUPINFO) );
  si.cb = sizeof(STARTUPINFO);
  si.dwFlags = STARTF_USESTDHANDLES | STARTF_USESHOWWINDOW;
  si.wShowWindow = SW_HIDE;

  if (strchr(mode, 'b'))
    binary_mode = _O_BINARY;
  else
    binary_mode = _O_TEXT;

  /* Opening the pipe for writing */
  if (strchr(mode, 'w')) {
    binary_mode |= _O_WRONLY;
    if (CreatePipe(&child_in, &father_out, &sa, 0) == FALSE) {
      return NULL;
    }
    si.hStdInput = child_in;
    si.hStdOutput = GetStdHandle(STD_OUTPUT_HANDLE);
    si.hStdError = GetStdHandle(STD_ERROR_HANDLE);

    if (DuplicateHandle(current_pid, father_out, 
                        current_pid, &father_out_dup, 
                        0, FALSE, DUPLICATE_SAME_ACCESS) == FALSE) {
      return NULL;
    }
    CloseHandle(father_out);
    fno = _open_osfhandle((word)father_out_dup, binary_mode);
    f = _fdopen(fno, mode);
    i = setvbuf( f, NULL, _IONBF, 0 );
  }
  /* Opening the pipe for reading */
  else if (strchr(mode, 'r')) {
    binary_mode |= _O_RDONLY;
    if (CreatePipe(&father_in, &child_out, &sa, 0) == FALSE) {
      return NULL;
    }
    si.hStdInput = GetStdHandle(STD_INPUT_HANDLE);
    si.hStdOutput = child_out;
    si.hStdError = GetStdHandle(STD_ERROR_HANDLE);
    if (DuplicateHandle(current_pid, father_in, 
                        current_pid, &father_in_dup, 
                        0, FALSE, DUPLICATE_SAME_ACCESS) == FALSE) {
      fprintf(stderr, "popen: error DuplicateHandle father_in\n");
      return NULL;
    }
    CloseHandle(father_in);
    fno = _open_osfhandle((word)father_in_dup, binary_mode);
    f = _fdopen(fno, mode);
    i = setvbuf( f, NULL, _IONBF, 0 );
  }
  else {
    return NULL;
  }

  /* creating child process */
  if (CreateProcess(app_name,   /* pointer to name of executable module */
                    new_cmd,    /* pointer to command line string */
                    NULL,       /* pointer to process security attributes */
                    NULL,       /* pointer to thread security attributes */
                    TRUE,       /* handle inheritance flag */
                    CREATE_NEW_CONSOLE,         /* creation flags */
                    NULL,       /* pointer to environment */
                    NULL,       /* pointer to current directory */
                    &si,        /* pointer to STARTUPINFO */
                    &pi         /* pointer to PROCESS_INFORMATION */
                  ) == FALSE) {
    return NULL;
  }
  
   /* Only the process handle is needed */
  if (CloseHandle(pi.hThread) == FALSE) {
    fprintf(stderr, "popen: error closing thread handle\n");
    return NULL;
  }

  if (new_cmd) free(new_cmd);
  if (app_name) free(app_name);

#if 0
  /* This does not seem to make sense for console apps */
  while (1) {
    i = WaitForInputIdle(pi.hProcess, 5); /* Wait 5ms  */
    if (i == 0xFFFFFFFF) {
      fprintf(stderr, "popen: process can't initialize\n");
      return NULL;
    }
    else if (i == WAIT_TIMEOUT)
      fprintf(stderr, "popen: warning, process still not initialized\n");
    else
      break;
  }
#endif

  /* Add the pair (f, pi.hProcess) to the list */
  if ((new_process = malloc(sizeof(struct _popen_elt))) == NULL) {
    fprintf (stderr, "popen: malloc(new_process) error\n");
    return NULL;
  }
  /* Saving the FILE * pointer, access key for retrieving the process
     handle later on */
  new_process->f = f;
  /* Closing the unnecessary part of the pipe */
  if (strchr(mode, 'r')) {
    CloseHandle(child_out);
  }
  else if (strchr(mode, 'w')) {
    CloseHandle(child_in);
  }
  /* Saving the process handle */
  new_process->hp = pi.hProcess;
  /* Linking it to the list of popen() processes */
  new_process->next = _popen_list;
  _popen_list = new_process;

  return f;

}

#if defined(OLD_NTGCC) && (__GNUC__ < 3)
int pclose (FILE * f)
{
  struct _popen_elt *p, *q;
  long exit_code;

  /* Look for f is the access key in the linked list */
  for (q = NULL, p = _popen_list; 
       p != &_z && p->f != f; 
       q = p, p = p->next);

  if (p == &_z) {
    fprintf(stderr, "pclose: error, file not found.");
    return -1;
  }

  /* Closing the FILE pointer */
  fclose(f);

  /* Waiting for the process to terminate */
  if (WaitForSingleObject(p->hp, INFINITE) != WAIT_OBJECT_0) {
    fprintf(stderr, "pclose: error, process still active\n");
    return -1;
  }

  /* retrieving the exit code */
  if (GetExitCodeProcess(p->hp, &exit_code) == 0) {
    fprintf(stderr, "pclose: can't get process exit code\n");
    return -1;
  }

  /* Closing the process handle, this will cause the system to
     remove the process from memory */
  if (CloseHandle(p->hp) == FALSE) {
    fprintf(stderr, "pclose: error closing process handle\n");
    return -1;
  }

  /* remove the elt from the list */
  if (q != NULL)
    q->next = p->next;
  else
    _popen_list = p->next;
  free(p);
    
  return exit_code;
}
#endif					/* defined(OLD_NTGCC) && (__GNUC__ < 3) */
#endif

#ifdef PseudoPty
void ptclose(struct ptstruct *ptStruct)
{
   int status;
   if (ptStruct == NULL)
      return;  /* structure is NULL, nothing to do */

#if NT
   CloseHandle(ptStruct->master_read);
   CloseHandle(ptStruct->master_write);
#else					/* NT */
   /* close the master and slave file descriptors */
   close(ptStruct->master_fd);
   close(ptStruct->slave_fd);
   /* terminate the child process */
   waitpid(ptStruct->slave_pid,&status,WNOHANG);
   kill(ptStruct->slave_pid,SIGKILL);
#endif					/* NT */
   /* free the space allocated for the structure */
   free(ptStruct);
   return;
}

#define EXITERROR(P) { ptclose(P); return NULL; }

struct ptstruct *ptopen(char *command)
{
   char **av;
#if defined(MacOS) || defined(FreeBSD)
   char *tmps;
#endif					/* MacOS || FreeBSD */
#if NT
   HANDLE hOutputReadMaster,hOutputRead,hOutputWrite;
   HANDLE hInputWriteMaster,hInputRead,hInputWrite;
   HANDLE hIOTmp;
   HANDLE hStdIn = NULL;
   SECURITY_ATTRIBUTES sa;
   PROCESS_INFORMATION pi;
   STARTUPINFO si;
#endif					/* NT */

   /* allocating new ptstruct */
   struct ptstruct *newPtStruct =
      (struct ptstruct *)malloc(sizeof(struct ptstruct));
   if (newPtStruct == NULL) {
      EXITERROR(newPtStruct);
      }
   strcpy(newPtStruct->slave_command, command);
  
   CmdParamToArgv(command, &av, 0);
   /*
    * Maybe need to conduct a path search for av[0], augment
    * command string with path if found; fail if not found.
    */

#if NT
   /* Set up the security attributes struct. */
   sa.nLength= sizeof(SECURITY_ATTRIBUTES);
   sa.lpSecurityDescriptor = NULL;
   sa.bInheritHandle = TRUE;

   /* Create the child output pipe */
   if(!CreatePipe(&newPtStruct->master_read,&hOutputWrite,&sa,0)) {
      EXITERROR(newPtStruct);
      }

   if (!CreatePipe(&hInputRead,&newPtStruct->master_write,&sa,0)) {
      EXITERROR(newPtStruct);
      }

   /* Set up the start up info struct. */
   ZeroMemory(&si,sizeof(STARTUPINFO));
   si.cb = sizeof(STARTUPINFO);
   si.dwFlags = STARTF_USESTDHANDLES;
   si.hStdOutput = hOutputWrite;
   si.hStdInput  = hInputRead;
   si.hStdError  = hOutputWrite;

   /* Launch the process that you want to redirect */
   if (!CreateProcess(NULL,newPtStruct->slave_command,NULL,NULL,TRUE,
		      CREATE_NEW_CONSOLE,NULL,NULL,&si,&pi)) {
      EXITERROR(newPtStruct);
      }

   /* Set global child process handle to cause threads to exit. */
   newPtStruct->slave_pid = pi.hProcess;

#else					/* NT */

  /* open master pty file descriptor */
#ifdef SUN
   if((newPtStruct->master_fd=open("/dev/ptmx",O_RDWR|O_NONBLOCK)) == -1) {
      EXITERROR(newPtStruct);
      }
#else					/* SUN */
   if((newPtStruct->master_fd=posix_openpt(O_RDWR|O_NONBLOCK)) == -1) {
      EXITERROR(newPtStruct);
      }
#endif					/* SUN */

   /* change permissions of slave pty to correspond with the master pty */
   if(grantpt(newPtStruct->master_fd) == -1) {
      EXITERROR(newPtStruct);
      }

   /* unlock the slave pty file descriptor before opening it */
   if(unlockpt(newPtStruct->master_fd) == -1) {
      EXITERROR(newPtStruct);
      }

   /*
    * determine the filename of the slave pty associated with
    * the already opened master pty
    */
#ifdef SUN
   if(ttyname_r(newPtStruct->master_fd,newPtStruct->slave_filename,
	              sizeof(newPtStruct->slave_filename)) != 0) {
#else					/* SUN */
#if defined(MacOS) || defined(FreeBSD)
   if (((tmps = ptsname(newPtStruct->master_fd)) == NULL) ||
      (strlen(tmps) > sizeof(newPtStruct->slave_filename)-1) ||
      (!strcpy(newPtStruct->slave_filename, tmps))){
#else					/* MacOS || FreeBSD */
   if(ptsname_r(newPtStruct->master_fd,newPtStruct->slave_filename,
		sizeof(newPtStruct->slave_filename)) != 0) {
#endif					/* MacOS || FreeBSD */
#endif					/* SUN */
      EXITERROR(newPtStruct);
      }

   /* finally open the slave pty file descriptor */
   if((newPtStruct->slave_fd=open(newPtStruct->slave_filename,
				  O_RDWR)) == -1) {
      EXITERROR(newPtStruct);
      }

   /* try forking the slave process ... */
   if ((newPtStruct->slave_pid = fork()) == -1) {
      EXITERROR(newPtStruct);
      }
   else if(newPtStruct->slave_pid == 0) {
      /* create a session id and make this process the process group leader */
      if(setsid() == -1) /* was setpgid */
	 EXITERROR(newPtStruct);
      /*
       * dup standard file descriptors to be associated with pseudo terminal */
      if(dup2(newPtStruct->slave_fd,0) == -1) {
	 EXITERROR(newPtStruct);
	 }
      if(dup2(newPtStruct->slave_fd,1) == -1) {
	 EXITERROR(newPtStruct);
	 }
      if(dup2(newPtStruct->slave_fd,2) == -1) {
	 EXITERROR(newPtStruct);
	 }

      /* attempt to execute the command slave process */
      if(execve(av[0], av, NULL) == -1) {
         EXITERROR(newPtStruct);
         }
      }
#endif					/* NT */

  return newPtStruct;
#undef EXITERROR

}

/*
 * ptgetstrt() - pseudo-pty getstr with timeout.  Actually, read() does not
 * have a timeout, not sure this should either. I guess timeout is optional.
 * Returns -1 for various (unfortunate) errors: bad parameters, bad
 * master file descriptor, no bytes read ...  probably needs finer-grained
 * error reporting.
 */
int ptgetstrt(char *buffer, const int bufsiz, struct ptstruct *ptStruct,
	      unsigned long waittime, int longread)
   {
   int tot_bytes_read=0, wait_fd, i=0, ret=0, premstop=0;
#if NT
   long bytes_read=0;
#else
   int bytes_read=0;
   fd_set rd_set;
   struct timeval timeout, *timeoutp = NULL;
#endif

   if(buffer == NULL || ptStruct == NULL) {
      return -1;
      }

#if !NT
  
   /* clear the buffer */
   memset(buffer, '\0', bufsiz);

   if (!longread) {
      timeout.tv_sec  = waittime / 1000000L;
      timeout.tv_usec = waittime % 1000000L;
      timeoutp = &timeout;
      }

   /* set the wait file descriptor for use with select */
   wait_fd = ptStruct->master_fd+1;
  
   /* set file descriptor sets for reading with select */
   FD_ZERO(&rd_set);
   if (ptStruct->master_fd > -1) {
      FD_SET(ptStruct->master_fd,&rd_set);
      }
   else {
      return -1;
      }

  /*
   * if select returns without any errors and
   * if the characters are available to read from input ...
   */
#endif					/* NT */

#if NT
   /* clear the buffer */
   ZeroMemory(buffer,bufsiz);
   if(WaitForSingleObject(ptStruct->master_read,waittime) != WAIT_FAILED) {
#else					/* NT */

   if((ret=select(wait_fd,&rd_set,NULL,NULL,timeoutp)) > 0
      && FD_ISSET(ptStruct->master_fd,&rd_set) ) {

#endif					/* NT */

      while(!premstop && tot_bytes_read < bufsiz) {

	 /*
	  * Read a byte. See if we have a newline.  Probably needs to
	  * be rewritten to try for multiple bytes.
	  */
#if NT
	 if ((ret=ReadFile(ptStruct->master_read,&buffer[i],1,
			  &bytes_read,NULL)) != 0) {
#else					/* NT */
	 if ((bytes_read=read(ptStruct->master_fd,&buffer[i],1)) > 0) {
#endif					/* NT */

	     if(!longread && buffer[i] == '\n') {
		if (buffer[i-1] == '\r') {
		   tot_bytes_read--;
		   }
		premstop=1;
		}
	     tot_bytes_read += bytes_read;
	     i++;

#if NT
#else					/* NT */
	     FD_ZERO(&rd_set);
	     FD_SET(ptStruct->master_fd,&rd_set);
#endif					/* NT */

	     } /* if bytes read */
	 else {
#if NT
	    /*
	     * Handle ReadFile() != 0 here. Use GetLastError().
	     * Do we ever retry? Is ERROR_IO_PENDING possible?
	     */
	    break;
#else					/* NT */
	    /*
	     * Negative read() is an error; 0 just means wait for more.
	     * But even if negative, we might just need to try again.
	     */
	    if ((bytes_read < 0) && (errno != EAGAIN)) {
	       /* non-continuing error */
	       break;
	       }
	    usleep(5000);
	    continue;
#endif					/* NT */
	    }
	 } /* while */
	 } /* if we had input before timeout */
#if NT
      else ret = -1;
      if (ret == 0)
	 ret = -1;
#else					/* NT */
else {
   }
#endif					/* NT */


   /* if some bytes were read than return the number read */
   if (tot_bytes_read > 0) {
      if(!longread && premstop) tot_bytes_read--;
      return tot_bytes_read;
      }
  /* else if no bytes were read at all than return an error code */
   else if (tot_bytes_read == 0) {
      return -1;
      }
   /* else return the value returned by select */
   return ret;
   }

int ptgetstr(char *buffer, const int bufsiz, struct ptstruct *ptStruct, struct timeval *timeout)
{
   return ptgetstrt(buffer, bufsiz, ptStruct, 10000000, 0);
#if 0
  presumably subsumed above
  fd_set rd_set;
  int bytes_read=0, ret=0, wait_fd, i=0, sel_ret;

  if(buffer == NULL | ptStruct == NULL | timeout == NULL)
    return -1;
  
  /* set the wait file descriptor for use with select */
  wait_fd = ptStruct->master_fd+1;
 
  /* clear the buffer */
  memset(buffer,0,sizeof(buffer));
  
  /* set file descriptor sets for reading with select */
  FD_ZERO(&rd_set);
  if(ptStruct->master_fd > -1)
    FD_SET(ptStruct->master_fd,&rd_set);
  else
    return -1;
  /* if select returns without any errors then ... */
  /* if the characters are availabe to read from input ... */
  while((sel_ret=select(wait_fd,&rd_set,NULL,NULL,timeout)) > 0
	&& FD_ISSET(ptStruct->master_fd,&rd_set)
	&& bytes_read < bufsiz 
	&& (ret=read(ptStruct->master_fd,&buffer[i],1)) > 0) {
	bytes_read += ret;
	i++;
	FD_ZERO(&rd_set);
	FD_SET(ptStruct->master_fd,&rd_set);
  } 
  if(bytes_read > 0) {
    return bytes_read;
  } else if(bytes_read == 0 && !FD_ISSET(ptStruct->master_fd,&rd_set)) {
    return -1;
  }
  return sel_ret;
#endif
}

int ptlongread(char *buffer, const int nelem, struct ptstruct *ptStruct)
{
   return ptgetstrt(buffer, nelem, ptStruct, 0, 1);
#if 0
  fd_set rd_set;
  int bytes_read=0, ret=0, wait_fd, i=0;
  
  /*   size_t max_read_bytes=sizeof(char)*256; */
  /* if ptystruct pointer is NULL than return with error code */
  if(ptStruct == NULL)
    return -1;
  
  /* set the wait file descriptor for use with select */
  wait_fd = ptStruct->master_fd+1;

  /* clear the buffer */
  memset(buffer,0,sizeof(buffer));
  
  /* set file descriptor sets for reading with select */
  FD_ZERO(&rd_set);
  if(ptStruct->master_fd > -1) 
    FD_SET(ptStruct->master_fd,&rd_set);
   
  /* if select returns without any errors then ... */
  if(select(wait_fd,&rd_set,NULL,NULL,NULL) > 0) {
    /* if the characters are availabe to read from input ... */
    if(FD_ISSET(ptStruct->master_fd,&rd_set)) {
      /* read all the characters until  */
      /* 1) none are available */
      /* 2) the maximum buffer size has been reached */
      /* 3) a newline has been read */
      while((ret=read(ptStruct->master_fd,&buffer[i],1)) > 0 
	    && (bytes_read+=ret) < nelem) 
	i++;

      /* if there was an error then return an error code */
      if( ret < 0)
	ret = -1; /* -1 indicates error reading from slave */
      else 
	ret = bytes_read;
    } else {
      /* select timed out */
      ret = -2;
    }
  } else 
    ret = -1; /* error occurred from select */
  return ret;
#endif
}

int ptputstr(struct ptstruct *ptStruct, char *buffer, int bufsize)
{
   long bytes_written;
   int ret=0, sel_ret;

   if (ptStruct == NULL || buffer == NULL || bufsize < 1)
      return -1;

#if NT
   if ( (WaitForSingleObject(ptStruct->master_write,0) == WAIT_FAILED) ||
       (!WriteFile(ptStruct->master_write,buffer,bufsize,&bytes_written,NULL)))
      ret = -1;
   else 
      ret = bytes_written;
#else					/* NT */

   {
   fd_set wd_set;
   struct timeval timeout;

   timeout.tv_sec=0L;
   timeout.tv_usec=0L;
  
   /* set file descriptors for writing with select */
   FD_ZERO(&wd_set);
   if(ptStruct->master_fd > -1) 
      FD_SET(ptStruct->master_fd,&wd_set);
   else
      return -3; /* invalid output file descriptor - return error */

   if ((sel_ret=select(ptStruct->master_fd+1,NULL,&wd_set,NULL,&timeout)) > 0){
      /* if the file descriptor is ready to write to ... */
      if(FD_ISSET(ptStruct->master_fd,&wd_set)) {
	 if((bytes_written=write(ptStruct->master_fd,buffer,bufsize)) < 0) 
	    ret = -1; /* -1 indicates error writing to file descriptor */
	 else 
	    ret=bytes_written;
	 }
      else {
	 /* select timed out */
	 ret = 0; /* was -2 */
	 }
      }
   else {
      ret = sel_ret; /* return value returned by select */
      }
   }

#endif					/* NT */
  return ret;
}

int ptputc(char c, struct ptstruct *ptStruct)
{
   return ptputstr(ptStruct, &c, 1);
}

int ptflush(struct ptstruct *ptStruct)
{
#if 0
   /* not implemented; not sure if this gobbledy gook does anything */
  fd_set rd_set;
  char temp_read;
  int wait_fd = ptStruct->slave_fd+1;
  FD_ZERO(&rd_set);
  FD_SET(ptStruct->slave_fd,&rd_set);
  if(select(wait_fd,&rd_set,NULL,NULL,NULL) > 0) {
    if(FD_ISSET(ptStruct->slave_fd,&rd_set)) {
      while(read(ptStruct->slave_fd,&temp_read,sizeof(temp_read)) > 0);
      return 0;
    } else {
      return -2;
    }
  }
#endif
  return -1;
}

#endif					/* PseudoPty */

FILE *finredir, *fouredir, *ferredir;

#ifdef Graphics
/*
 * Under Graphics builds, primarily wicon[tx], the use of < or > on a
 * command line overrides default behavior of using a console window.
 */
void detectRedirection()
{
#if defined(NTGCC) && (WordBits==32)
#passthru #if (__GNUC__==4) && (__GNUC_MINOR__>7)
#passthru #define stat _stat64i32
#passthru #endif
#endif					/* NTGCC && WordBits==32*/
   struct stat sb;
   /*
    * Look at the standard file handles and attempt to detect
    * redirection.
    */
   if (fstat(fileno(stdin), &sb) == 0) {
      if (sb.st_mode & S_IFCHR) {		/* stdin is a device */
	 }
      if (sb.st_mode & S_IFREG) {		/* stdin is a regular file */
	 }
      /* stdin is of size sb.st_size */
      if (sb.st_size > 0) {
         ConsoleFlags |= StdInRedirect;
	 }
      }
   else {					/* unable to identify stdin */
      }

   if (fstat(fileno(stdout), &sb) == 0) {
      if (sb.st_mode & S_IFCHR) {		/* stdout is a device */
	 }
      if (sb.st_mode & S_IFREG) {		/* stdout is a regular file */
	 }
      /* stdout is of size sb.st_size */
      if (sb.st_size == 0)
         ConsoleFlags |= StdOutRedirect;
      }
   else {					/* unable to identify stdout */
     }
}
#endif					/* Graphics */

/*
 * CmdParamToArgv() - convert a command line to an argv array.  Return argc.
 * Called for both input processing (e.g. in WinMain()) and in output
 * (e.g. in mswinsystem()).  Behavior differs in that output does not
 * remove double quotes from quoted arguments, otherwise receiving process
 * (if a win32 process) would lose quotedness.
 */
int CmdParamToArgv(char *s, char ***avp, int dequote)
{
   char tmp[MaxPath];
   char *t=salloc(s), *t2=t;
   int rv=0;

   *avp = malloc(2 * sizeof(char *));
   (*avp)[rv] = NULL;

#ifdef Graphics
   if (dequote)
      detectRedirection();
#endif					/* Graphics */

   while (*t2) {
      while (*t2 && isspace(*t2)) t2++;
      switch (*t2) {
	 case '\0': break;
#ifdef Graphics
	 /*
	  * perform file redirection; this is for MS Windows
	  * and other situations where Wiconx is launched from
	  * a shell that does not process < and > characters.
	  */
	 case '<': case '>': {
	    FILE *f;
	    char c, buf[128], *t3;
	    if (dequote == 0) goto skipredirect;
	    c = *t2++;
	    while (*t2 && isspace(*t2)) t2++;
	    t3 = buf;
	    while (*t2 && !isspace(*t2)) *t3++ = *t2++;
	    *t3 = '\0';
	    if (c == '<')
	       f = fopen(buf, "r");
	    else
	       f = fopen(buf, "w");
	    if (f == NULL) {
	       fprintf(stderr, "system error: unable to redirect i/o");
	       c_exit(-1);
	       }
	    if (c == '<') {
	       finredir = f;
	       ConsoleFlags |= StdInRedirect;
	       }
	    else {
	       fouredir = f;
	       ConsoleFlags |= StdOutRedirect;
	       }
	    break;
	    }
#endif					/* Graphics */
	 case '"': {
	    char *t3, c = '\0';
	    if (dequote) t3 = ++t2;			/* skip " */
	    else t3 = t2++;

            while (*t2 && (*t2 != '"')) t2++;
	    if (*t2 && !dequote) t2++;
            if ((c = *t2)) {
	       *t2++ = '\0';
	       }
	    *avp = realloc(*avp, (rv + 2) * sizeof (char *));
	    (*avp)[rv++] = salloc(t3);
            (*avp)[rv] = NULL;
	    if(!dequote && c) *--t2 = c;

	    break;
	    }
         default: {
#if NT
            FINDDATA_T fd;
#endif					/* NT */
	    char *t3;
#ifdef Graphics
skipredirect:
#endif					/* Graphics */
	    t3 = t2;
            while (*t2 && !isspace(*t2)) t2++;
	    if (*t2)
	       *t2++ = '\0';
            strcpy(tmp, t3);

#if NT
	    if (!strcmp(tmp, ">") || !FINDFIRST(tmp, &fd)) {
#endif


	       *avp = realloc(*avp, (rv + 2) * sizeof (char *));
	       (*avp)[rv++] = salloc(t3);
               (*avp)[rv] = NULL;
#if NT
               }
	    else {
   	       char dir[MaxPath];
               int end;
               strcpy(dir, t3);
	       do {
	          end = strlen(dir)-1;
	          while (end >= 0 && dir[end] != '\\' && dir[end] != '/' &&
			dir[end] != ':') {
                     dir[end] = '\0';
		     end--;
	             }
		  strcat(dir, FILENAME(&fd));
	          *avp = realloc(*avp, (rv + 2) * sizeof (char *));
	          (*avp)[rv++] = salloc(dir);
                  (*avp)[rv] = NULL;
	          } while (FINDNEXT(&fd));
	       FINDCLOSE(&fd);
	       }
#endif					/* NT */
            break;
	    }
         }
      }
   free(t);
   return rv;
}

#if defined(HAVE_LIBPTHREAD) && (defined(Concurrent) || defined(PthreadCoswitch))

#ifndef SUN
/* from netbsd.org, under the BSD license  */
pthread_rwlock_t __environ_lock;
#endif

extern char **environ;
char *
__findenv(const char *name, int *offset);

int getenv_r(const char *name, char *buf, size_t len)
{
	int offset;
	char *result;
	int rv = -1;

	pthread_rwlock_rdlock(&__environ_lock);
	result = __findenv(name, &offset);
	if (result == NULL) {
		errno = ENOENT;
		goto out;
	}
	if (strlen(result) >= len) {
		errno = ERANGE;
		goto out;
	   }
	strncpy(buf, result, len);
	rv = 0;
out:
	pthread_rwlock_unlock(&__environ_lock);
	return rv;
}

/*
 * __findenv --
 *	Returns pointer to value associated with name, if any, else NULL.
 *	Sets offset to be the offset of the name/value combination in the
 *	environmental array, for use by setenv(3) and unsetenv(3).
 *	Explicitly removes '=' in argument name.
 *
 *	This routine *should* be a static; don't use it.
 */
char *
__findenv(const char *name, int *offset)
{
	size_t len;
	const char *np;
	char **p, *c;

	if (name == NULL || environ == NULL)
		return NULL;
	for (np = name; *np && *np != '='; ++np)
		continue;
	len = np - name;
	for (p = environ; (c = *p) != NULL; ++p)
		if (strncmp(c, name, len) == 0 && c[len] == '=') {
			*offset = p - environ;
			return c + len + 1;
		}
	*offset = p - environ;
	return NULL;
}

#else
int
getenv_r(const char *name, char *buf, size_t len)
{
   char *buf2 = getenv(name);
   if (buf2) {
      if (strlen(buf2) >= len) {
	 errno = ERANGE;
	 return -1;
	 }
      errno = 0;
      strcpy(buf, buf2);
      return 0;
      }
   else {
      errno = ENOENT;
      return -1;
      }
}

#endif					/* HAVE_LIBPTHREAD */
