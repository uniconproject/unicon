/*
 * File: fsys.r
 *  Contents: close, chdir, exit, getenv, open, read, reads, remove, rename,
 *  [save], seek, stop, system, where, write, writes, [getch, getche, kbhit]
 */

#if MICROSOFT || SCO_XENIX
#define BadCode
#endif					/* MICROSOFT || SCO_XENIX */

#ifdef XENIX_386
#define register
#endif					/* XENIX_386 */
/*
 * The following code is operating-system dependent [@fsys.01]. Include
 *  system-dependent files and declarations.
 */

#if PORT
   /* nothing to do */
Deliberate Syntax Error
#endif					/* PORT */

#if AMIGA
#if __SASC
   /* Undefine macros from fcntl.h and stdlib.h that collide with
      function names in this module. */
#passthru #undef close
#passthru #undef open
#passthru #undef read
#passthru #undef write
#passthru #undef getenv
#endif __SASC                           /* SASC  */
extern FILE *popen(const char *, const char *);
extern int pclose(FILE *);
#endif AMIGA                            /* AMIGA */

#if ATARI_ST || MSDOS || MVS || OS2 || UNIX || VM || VMS
   /* nothing to do */
#endif					/* ATARI_ST || MSDOS ... */

#if MACINTOSH && MPW
extern int MPWFlush(FILE *f);
#define fflush(f) MPWFlush(f)
#endif					/* MACINTOSH && MPW*/

#ifdef PosixFns
extern int errno;
#endif					/* PosixFns */
/*
 * End of operating-system specific code.
 */


/* (should) change the mixed case of string s1 to the lower case string s2 */

void UtoL (char *s1, char *s2)
{
   int i, l = strlen(s2);

   for (i = 0; i < l; i++)
      *(s1+i) = *(s2+i);
}

/*
 * is_url() takes a string s as its parameter. If s starts with a URL scheme, 
 * is_url() returns 1. If s starts with "net:", it returns 2. Otherwise, 
 * for normal files, is_url() returns 0.
*/

int is_url(char *s)
{
   char *tmp = s;

   while ( *tmp == ' ' || *tmp == '\t' || *tmp == '\n' )
      tmp++; 

   if (!strncasecmp (tmp, "http:", 5) ){
      UtoL(tmp, "http");
      return 1;
      }
   if (!strncasecmp (tmp, "file:", 5) ) {
      UtoL(tmp, "file");
      return 1;
      }
   if (!strncasecmp (tmp, "ftp:", 4) ) {
      UtoL(tmp, "ftp"); 
      return 1;
      }
   if (!strncasecmp (tmp, "gopher:", 7) ) {
      UtoL(tmp, "gopher");
      return 1;
      } 
   if (!strncasecmp (tmp, "telnet:", 7) )  {
      UtoL(tmp, "telnet");
      return 1;
      }
   if ( !strncasecmp(tmp, "net:", 4) )
      return 2;
   return 0; 
}

#ifdef FAttrib

"fattrib(str, att) - get the attribute of a file "

function{*} fattrib (fname, att[argc])
 
   if !cnv:C_string(fname) then
        runerr(103, fname)

   abstract {
      return string ++ integer
      }  

   body {
      tended char *s;
      struct stat fs;
#if UNIX
      struct passwd *pwnam;
      struct group  *grnam;
#endif					/* UNIX */
#if NT
      HFILE hf;
      OFSTRUCT of;
      FILETIME ft1,ft2,ft3;
      SYSTEMTIME st;
#endif					/* NT */
      int fd, i;
      char *retval;
      char *temp;
      long l;
   
#ifdef Network
      struct netstat info;

      if ( is_url(fname) == 1 ) {		/* remote files */
         if ( netstatus(fname, &info) < 0 ) fail;
         switch ( info.flag ) {
         case FILE_FLAG:               /* URL scheme is "file:" */
         for(i=0; i<argc; i++) {
            if (!cnv:C_string(att[i], s)) {
               runerr(103, att[i]);
               }
            if ( !strcasecmp("size", s) )
               suspend C_integer(info.u.fbuf.st_size);
            else if ( !strcasecmp("status", s) ) {
               temp = make_mode (info.u.fbuf.st_mode);
	       l = strlen(temp);
               Protect(retval = alcstr(temp,l), runerr(0));
               free(temp);
               suspend string(l,retval);
               }
#if UNIX
            else if ( !strcasecmp("owner", s) ) {
               pwnam = getpwuid (info.u.fbuf.st_uid);
	       temp = pwnam->pw_name;
	       l = strlen(temp);
	       if (temp[l-1] == '\n') l--;
	       Protect(retval = alcstr(temp, l), runerr(0));
               suspend string (l, retval);
               }
            else if ( !strcasecmp("group", s) ) {
               grnam = getgrgid (info.u.fbuf.st_gid);
	       temp = grnam->gr_name;
	       l = strlen(temp);
	       if (temp[l-1] == '\n') l--;
	       Protect(retval = alcstr(temp, l), runerr(0));
               suspend string (l, retval);
               }
#endif					/* UNIX */
            else if ( !strcasecmp("m_time", s) ) {
	       temp = ctime(&(info.u.fbuf.st_mtime));
	       l = strlen(temp);
	       if (temp[l-1] == '\n') l--;
	       Protect(retval = alcstr(temp, l), runerr(0));
               suspend string (l, retval);
	       }
            else if ( !strcasecmp("a_time", s) ) {
	       temp = ctime(&(info.u.fbuf.st_atime));
	       l = strlen(temp);
	       if (temp[l-1] == '\n') l--;
	       Protect(retval = alcstr(temp, l), runerr(0));
               suspend string (l, retval);
	       }
            else if ( !strcasecmp("c_time", s) ) {
	       temp = ctime(&(info.u.fbuf.st_ctime));
	       l = strlen(temp);
	       if (temp[l-1] == '\n') l--;
	       Protect(retval = alcstr(temp, l), runerr(0));
               suspend string (l, retval);
	       }
            else {
               runerr(161);
               }
      }
fail;

            case HTTP_FLAG:       /* URL scheme is "http", "ftp", "gopher", etc */

for(i=0; i<argc; i++) {
      if (!cnv:C_string(att[i], s)) {
        runerr(103, att[i]);
	}

            if ( !strcasecmp("size", s) )
               suspend C_integer(info.u.hbuf.length);
            else if ( !strcasecmp("status", s) )
               switch (info.u.hbuf.scode){
               case 200:
               case 201:
               case 202:
               case 204:
               case 304:
                  suspend C_string ("nr");
		  break;
               case 301:
               case 302:
                  if ( (temp=info.u.hbuf.location) == NULL ) fail;
		  l = strlen(temp);
                  Protect(retval = alcstr(temp,l), runerr(0));
                  free(temp);
                  suspend string(l, retval); 
		  break;
               default:
                  fail;
                  }
            else if ( !strcasecmp("m_time", s) ) {
               if ( (temp=info.u.hbuf.last_mod) == NULL ) fail;
               l = strlen(temp);
               Protect(retval = alcstr(temp,l), runerr(0));
               free(temp);
               suspend string(l,retval); 
               }
            else if (!strcasecmp("content_type", s)) {
	       l = strlen(info.u.hbuf.type);
	       Protect (retval = alcstr(info.u.hbuf.type, l), runerr(0));
	       suspend string(l, retval);
	       }
            else {
               runerr(161);
               }
	    }
	    fail;
            }
         }
      else if ( is_url(fname) == 0 ) {                     /* local files */
#endif					/* Network */
         if ( stat(fname, &fs) == -1 )
            fail;
	 for(i=0; i<argc; i++) {
	    if (!cnv:C_string(att[i], s)) {
	       runerr(103, att[i]);
	       }
	    if ( !strcasecmp("size", s) ) {
	       suspend C_integer(fs.st_size);
	       }
	    else if ( !strcasecmp("status", s) ) {
	       temp = make_mode (fs.st_mode);
	       l = strlen(temp);
	       Protect(retval = alcstr(temp,l), runerr(0));
	       free(temp);
	       suspend string(l, retval); 
	       }
#if UNIX
         else if ( !strcasecmp("owner", s) ) {
            pwnam = getpwuid (fs.st_uid);
	    temp = pwnam->pw_name;
	    l = strlen(temp);
	    Protect(temp = alcstr(temp, l), runerr(0));
            suspend string (l, temp);
            }
         else if ( !strcasecmp("group", s) ) {
            grnam = getgrgid (fs.st_gid);
	    temp = grnam->gr_name;
	    l = strlen(temp);
	    Protect(temp = alcstr(temp, l), runerr(0));
            suspend string (l, temp);
            }
#endif					/* UNIX */
         else if ( !strcasecmp("m_time", s) ) {
	    temp = ctime(&(fs.st_mtime));
	    l = strlen(temp);
  	    if (temp[l-1] == '\n') l--;
	    Protect(temp = alcstr(temp, l), runerr(0));
            suspend string(l, temp);
            }
         else if ( !strcasecmp("a_time", s) ) {
	    temp = ctime(&(fs.st_atime));
	    l = strlen(temp);
  	    if (temp[l-1] == '\n') l--;
	    Protect(temp = alcstr(temp, l), runerr(0));
            suspend string(l, temp);
            }
         else if ( !strcasecmp("c_time", s) ) {
	    temp = ctime(&(fs.st_ctime));
	    l = strlen(temp);
  	    if (temp[l-1] == '\n') l--;
	    Protect(temp = alcstr(temp, l), runerr(0));
            suspend string(l, temp);
            }
         else {
            runerr(161);
            }
      }
#ifdef Network
      }
#endif					/* Network */
      fail;
   }
end
#endif					/* FAttrib */

"close(f) - close file f."

function{1} close(f)

   if !is:file(f) then
      runerr(105, f)

   abstract {
      return file ++ integer
      }

   body {
      FILE *fp;

      fp = BlkLoc(f)->file.fd;
      if (BlkLoc(f)->file.status == 0) return f;

      /*
       * Close f, using fclose, pclose, closedir, or wclose as appropriate.
       */
#ifdef Messaging
      if (BlkLoc(f)->file.status & Fs_Messaging) {
	 BlkLoc(f)->file.status = 0;
	 return C_integer Mclose((struct Mfile*) fp);
	 }
#endif                                  /* Messaging */

#ifdef PosixFns
#if NT
      if (BlkLoc(f)->file.status & Fs_Socket) {
	 BlkLoc(f)->file.status = 0;
	 return C_integer closesocket((SOCKET)fp);
	 }
#else					/* NT */
      if (BlkLoc(f)->file.status & Fs_Dir) {
	 BlkLoc(f)->file.status = 0;
	 closedir((DIR *)fp);
	 return f;
         }
      else if (BlkLoc(f)->file.status & Fs_Socket) {
	 BlkLoc(f)->file.status = 0;
	 return C_integer close((int)fp);
	 }
#endif					/* NT */
#endif					/* PosixFns */

#ifdef ISQL
      if (BlkLoc(f)->file.status & Fs_ODBC) {
	 BlkLoc(f)->file.status = 0;
	 if (dbclose(fp)) fail;
	 return C_integer 0;
	 }
#endif					/* ISQL */

#ifdef Dbm
      if (BlkLoc(f)->file.status & Fs_Dbm) {
	 BlkLoc(f)->file.status = 0;
	 dbm_close((DBM *)fp);
	 return f;
         }
#endif					/* Dbm */


#ifdef Graphics
      /*
       * Close window if windows are supported.
       */

      pollctr >>= 1;
      pollctr++;
      if (BlkLoc(f)->file.status & Fs_Window) {
	 if (BlkLoc(f)->file.status != Fs_Window) { /* not already closed? */
	    BlkLoc(f)->file.status = Fs_Window;
	    SETCLOSED((wbp) fp);
	    wclose((wbp) fp);
	    }
	 return f;
	 }
      else
#endif					/* Graphics */

#if NT
#define pclose _pclose
#define popen _popen
#endif					/* NT */

#if AMIGA || ARM || OS2 || UNIX || VMS || NT
      /*
       * Close pipe if pipes are supported.
       */

      if (BlkLoc(f)->file.status & Fs_Pipe) {
	 BlkLoc(f)->file.status = 0;
	 return C_integer((pclose(fp) >> 8) & 0377);
	 }
      else
#endif					/* AMIGA || ARM || OS2 || ... */

      fclose(fp);
      BlkLoc(f)->file.status = 0;

      /*
       * Return the closed file.
       */
      return f;
      }
end

#undef exit
#passthru #undef exit

"exit(i) - exit process with status i, which defaults to 0."

function{} exit(status)
   if !def:C_integer(status, EXIT_SUCCESS) then
      runerr(101, status)
   inline {
      c_exit((int)status);
      }
end


"getenv(s) - return contents of environment variable s."

function{0,1} getenv(s)

   /*
    * Make a C-style string out of s
    */
   if !cnv:C_string(s) then
      runerr(103,s)
   abstract {
      return string
      }

   inline {
      register char *p;
      long l;

#if AMIGA && __SASC
      if ((p = __getenv(s)) != NULL) {
#else                                /* AMIGA && __SASC */
      if ((p = getenv(s)) != NULL) {	/* get environment variable */
#endif                               /* AMIGA && __SASC */
	 l = strlen(p);
	 Protect(p = alcstr(p,l),runerr(0));
	 return string(l,p);
	 }
      else 				/* fail if not in environment */
	 fail;

      }
end


#if defined(Graphics) || defined(Messaging) || defined(ISQL)
"open(s1, s2, ...) - open file named s1 with options s2"
" and attributes given in trailing arguments."
function{0,1} open(fname, spec, attr[n])
#else						/* Graphics */
#ifdef OpenAttributes
"open(fname, spec, attrstring) - open file fname with specification spec."
function{0,1} open(fname, spec, attrstring)
#else						/* OpenAttributes */
"open(fname, spec) - open file fname with specification spec."
function{0,1} open(fname, spec)
#endif						/* OpenAttributes */
#endif						/* Graphics */
   declare {
      tended struct descrip filename;
      }

   /*
    * fopen and popen require a C string, but it looks terrible in
    *  error messages, so convert it to a string here and use a local
    *  variable (fnamestr) to store the C string.
    */
   if !cnv:string(fname) then
      runerr(103, fname)

   /*
    * spec defaults to "r".
    */
   if !def:tmp_string(spec, letr) then
      runerr(103, spec)

#ifdef OpenAttributes
   /*
    * Convert attrstr to a string, defaulting to "".
    */
   if !def:C_string(attrstring, emptystr) then
      runerr(103, attrstring)
#endif					/* OpenAttributes */

   abstract {
      return file
      }

   body {
      tended char *fnamestr;
      register word slen;
      register int i;
      register char *s;
      int status;
      char mode[4];
      extern FILE *fopen();
      FILE *f;
      struct b_file *fl;
#ifdef PosixFns
      struct stat st;
#endif					/* PosixFns */

#ifdef Graphics
      int j, err_index = -1;
      tended struct b_list *hp;
      tended struct b_lelem *bp;
#endif					/* Graphics */

#ifdef Messaging
      int is_shortreq = 0;
#endif                                  /* Messaging */

/*
 * The following code is operating-system dependent [@fsys.02].  Make
 *  declarations as needed for opening files.
 */

#if PORT
Deliberate Syntax Error
#endif					/* PORT */

#if AMIGA || ATARI_ST || MACINTOSH || MSDOS || MVS || OS2 || VM
   /* nothing is needed */
#endif					/* AMIGA || ATARI_ST || ... */

#if ARM
      extern FILE *popen(const char *, const char *);
      extern int pclose(FILE *);
#endif					/* ARM */

#ifdef PosixFns
      int is_udp = 0;
#endif					/* PosixFns */

#if OS2 || UNIX || VMS || NT
      extern FILE *popen();
#endif					/* OS2 || UNIX || VMS || NT */

/*
 * End of operating-system specific code.
 */

      /*
       * get a C string for the file name
       */
      if (!cnv:C_string(fname, fnamestr))
	 runerr(103,fname);

      status = 0;

#ifdef Network
     if (is_url(fnamestr) == 1) {
	status |= Fs_Network; 
	}
#endif					/* Network */

      /*
       * Scan spec, setting appropriate bits in status.  Produce a
       *  run-time error if an unknown character is encountered.
       */
      s = StrLoc(spec);
      slen = StrLen(spec);
      for (i = 0; i < slen; i++) {
	 switch (*s++) {
	    case 'a':
	    case 'A':
	       status |= Fs_Write|Fs_Append;
	       continue;
	    case 'b':
	    case 'B':
	       status |= Fs_Read|Fs_Write;
	       continue;
	    case 'c':
	    case 'C':
	       status |= Fs_Create|Fs_Write;
	       continue;
	    case 'r':
	    case 'R':
	       status |= Fs_Read;
	       continue;
	    case 'w':
	    case 'W':
	       status |= Fs_Write;
	       continue;

	    case 's':
	    case 'S':
#ifdef Messaging
	       if (status & Fs_Messaging) {
		  is_shortreq = 1;
		  continue;
		  }
#endif                                  /* Messaging */
#ifdef RecordIO
	       status |= Fs_Untrans;
	       status |= Fs_Record;
#endif					/* RecordIO */
	       continue;

	    case 't':
	    case 'T':
	       status &= ~Fs_Untrans;
#ifdef RecordIO
               status &= ~Fs_Record;
#endif                                  /* RecordIO */
	       continue;

	    case 'u':
	    case 'U':
#ifdef PosixFns
	       is_udp = 1;
#endif					/* PosixFns */
	       if ((status & Fs_Socket)==0)
		  status |= Fs_Untrans;
#ifdef RecordIO
	       status &= ~Fs_Record;
#endif					/* RecordIO */
	       continue;

#if AMIGA || ARM || OS2 || UNIX || VMS || NT
	    case 'p':
	    case 'P':
	       status |= Fs_Pipe;
	       continue;
#endif					/* AMIGA || ARM || OS2 || UNIX ... */

	    case 'x':
	    case 'X':
	    case 'g':
	    case 'G':
#ifdef Graphics
	       status |= Fs_Window | Fs_Read | Fs_Write;
	       continue;
#else					/* Graphics */
	       fail;
#endif					/* Graphics */


	    case 'd':
	    case 'D':
#ifdef Dbm
	       status |= Fs_Dbm;
	       continue;
#else
	       fail;
#endif	   				/* DBM */

	    case 'm':
	    case 'M':
#ifdef Messaging
	       status |= Fs_Messaging|Fs_Read|Fs_Write;
	       continue;
#else
	       fail;
#endif                                  /* Messaging */

	    case 'n':
	    case 'N':
#ifdef PosixFns
	       status |= Fs_Socket|Fs_Read|Fs_Write|Fs_Unbuf;
	       continue;

#else 					/* PosixFns */
	       fail;
#endif 					/* PosixFns */


	    case 'o':
	    case 'O':
#ifdef ISQL
	       status |= Fs_ODBC;
	       continue;

#else 					/* ISQL */
	       fail;
#endif 					/* ISQL */



	    default:
	       runerr(209, spec);
	    }
	 }
   
      /*
       * Construct a mode field for fopen/popen.
       */
      mode[0] = '\0';
      mode[1] = '\0';
      mode[2] = '\0';
      mode[3] = '\0';

#ifdef Dbm
      /* If we're opening a dbm database, the default is set further down to
         "rw" */
      if (!(status & Fs_Dbm))
#endif					/* Dbm */
#ifdef ISQL
      /* If we're opening a sql database, modes are not used */
      if (!(status & Fs_ODBC))
#endif					/* ISQL */

      if ((status & (Fs_Read|Fs_Write)) == 0)	/* default: read only */
	 status |= Fs_Read;
      if (status & Fs_Create)
	 mode[0] = 'w';
      else if (status & Fs_Append)
	 mode[0] = 'a';
      else if (status & Fs_Read)
	 mode[0] = 'r';
      else
	 mode[0] = 'w';

/*
 * The following code is operating-system dependent [@fsys.05].  Handle open
 *  modes.
 */

#if PORT
      if ((status & (Fs_Read|Fs_Write)) == (Fs_Read|Fs_Write))
	 mode[1] = '+';
Deliberate Syntax Error
#endif					/* PORT */

#if AMIGA || ARM || UNIX || VMS
      if ((status & (Fs_Read|Fs_Write)) == (Fs_Read|Fs_Write))
	 mode[1] = '+';
#endif					/* AMIGA || ARM || UNIX || VMS */

#if ATARI_ST
      if ((status & (Fs_Read|Fs_Write)) == (Fs_Read|Fs_Write)) {
	 mode[1] = '+';
	 mode[2] = ((status & Fs_Untrans) != 0) ? 'b' : 'a';
	 }
      else mode[1] = ((status & Fs_Untrans) != 0) ? 'b' : 'a';
#endif					/* ATARI_ST */
   
#if MACINTOSH
      if ((status & (Fs_Read|Fs_Write)) == (Fs_Read|Fs_Write)) {
         mode[1] = '+';
         if ((status & Fs_Untrans) != 0) mode[2] = 'b';
         }
      else if ((status & Fs_Untrans) != 0) mode[1] = 'b';
#endif					/* MACINTOSH */

#if MSDOS || OS2
      if ((status & (Fs_Read|Fs_Write)) == (Fs_Read|Fs_Write)) {
	 mode[1] = '+';
#if CSET2
         /* we don't have the 't' in C Set/2 */
         if ((status & Fs_Untrans) != 0) mode[2] = 'b';
         } /* End of if - open file for reading or writing */
      else if ((status & Fs_Untrans) != 0) mode[1] = 'b';
#else					/* CSET2 */
	 mode[2] = ((status & Fs_Untrans) != 0) ? 'b' : 't';
	 }
      else mode[1] = ((status & Fs_Untrans) != 0) ? 'b' : 't';
#endif					/* CSET2 */
#endif					/* MSDOS || OS2 */

#if MVS || VM
      if ((status & (Fs_Read|Fs_Write)) == (Fs_Read|Fs_Write)) {
	 mode[1] = '+';
	 mode[2] = ((status & Fs_Untrans) != 0) ? 'b' : 0;
	 }
      else mode[1] = ((status & Fs_Untrans) != 0) ? 'b' : 0;
#endif					/* MVS || VM */

/*
 * End of operating-system specific code.
 */

      /*
       * Open the file with fopen or popen.
       */

#ifdef OpenAttributes
#if SASC
#ifdef RecordIO
	 f = afopen(fnamestr, mode, status & Fs_Record ? "seq" : "",
		    attrstring);
#else					/* RecordIO */
	 f = afopen(fnamestr, mode, "", attrstring);
#endif					/* RecordIO */
#endif					/* SASC */

#else					/* OpenAttributes */
   
#ifdef Graphics
      if (status & Fs_Window) {
	 /*
	  * allocate an empty event queue for the window
	  */
	 Protect(hp = alclist(0), runerr(0));
	 Protect(bp = alclstb(MinListSlots, (word)0, 0), runerr(0));
	 hp->listhead = hp->listtail = (union block *) bp;
	 bp->listprev = bp->listnext = (union block *) hp;

	 /*
	  * loop through attributes, checking validity
	  */
	 for (j = 0; j < n; j++) {
	    if (is:null(attr[j]))
	       attr[j] = emptystr;
	    if (!is:string(attr[j]))
	       runerr(109, attr[j]);
	    }

	 f = (FILE *)wopen(fnamestr, hp, attr, n, &err_index);
	 if (f == NULL) {
	    if (err_index >= 0) runerr(145, attr[err_index]);
	    else if (err_index == -1) fail;
	    else runerr(305);
	    }
	 } else
#endif					/* Graphics */

#ifdef Messaging
	    if (status & Fs_Messaging) {
	       extern int Merror;
	       if (status & ~(Fs_Messaging|Fs_Read|Fs_Write|Fs_Untrans)) {
		  runerr(209, spec);
		  }
	       else {
		  URI *puri;
		  register int a;
		  char *buf[4192];
		  tended char *tmps;
		  
		  /* Check attributes (stolen from above) */
		  for (a=0; a<n; a++) {
		     if (is:null(attr[a])) {
			attr[a] = emptystr;
			}
		     if (!is:string(attr[a])) {
			runerr(109, attr[a]);
			}
		     if (cnv:C_string(attr[a], tmps)) {
#ifdef MDEBUG
			fprintf(stderr, "header: %s\n", tmps);
			fflush(stderr);
#endif                                  /* MDEBUG */
			}
		     }

		  /* Try to parse the filename as a URL */
		  puri = uri_parse(fnamestr);
		  switch (puri->status) {
		     case URI_OK:
			break;
		     case URI_EMALFORMED:
			runerr(1201, fname); 
			break;
		     case URI_ENOUSER:
			runerr(1202, fname); 
			break;
		     case URI_EUNKNOWNSCHEME:
			runerr(1203, fname); 
			break;
		     case URI_ECHECKERRNO:
		     default:
#ifdef PosixFns
			if (errno != 0) {
			   IntVal(amperErrno) = errno;
			   }
#endif                                  /* PosixFns */
			runerr(1204, fname);
		     }
		 
		  f = (FILE *)Mopen(puri, attr, n, is_shortreq);
		  if (Merror > 1200) {
		    runerr(Merror, fname);
		  }
		  switch (Merror) {
		     case 0: 
			break;
		     case TP_ECONNECT:
			runerr(1205, fname);
			break;
		     case TP_EHOST:
			runerr(1206, fname);
			break;
		     case TP_ESERVER:
			runerr(1212, fname);
			break;
		     case TP_EMEM:
		     case TP_EOPEN:
		     default:
			runerr(1200, fname);
			break;
		     }
		  }
	       }
	    else
#endif                                  /* Messaging */
	    
#ifdef ISQL
   if (status & Fs_ODBC) {
      if (n < 3) runerr(103);
      if (!is:string(attr[0])) runerr(103, attr[0]);
      if (!is:string(attr[1])) runerr(103, attr[1]);
      if (!is:string(attr[2])) runerr(103, attr[2]);
      f = isql_open(fnamestr, attr, attr+1, attr+2);
      }
   else
#endif					/* ISQL */

#ifdef Network
   if (status & Fs_Network) {
      f = (FILE *) netopen(fnamestr, mode);
      }
   else if ( is_url(fnamestr) == 2 ) {
      f = (FILE *) socketopen(fnamestr, mode);
      }
   else	
#endif					/* Network */

#if AMIGA || ARM || OS2 || UNIX || VMS || NT
      if (status & Fs_Pipe) {
	 if (status != (Fs_Read|Fs_Pipe) && status != (Fs_Write|Fs_Pipe))
	    runerr(209, spec);
	 f = popen(fnamestr, mode);
	 }
      else
#endif					/* AMIGA || ARM || OS2 || ... */

#ifdef Dbm
      if (status & Fs_Dbm) {
	 int mode;
	 if ((status & Fs_Read && status & Fs_Write) || status == Fs_Dbm) {
	    mode = O_RDWR|O_CREAT;
	    status |= Fs_Read|Fs_Write;
	 }
	 else if (status & Fs_Write) {
	    mode = O_WRONLY|O_CREAT;
	 }
	 else
	   mode = O_RDONLY;
	   
	 f = (FILE *)dbm_open(fnamestr, mode, 0666);
	 if (!f)
	    fail;
      }
      else
#endif					/* DBM */

#ifdef PosixFns
      {
	 if (status & Fs_Socket) {
	    /* The only allowed values for flags are "n" and "na" */
	    if (status & ~(Fs_Read|Fs_Write|Fs_Socket|Fs_Append|Fs_Unbuf))
	       runerr(209, spec);
	    if (status & Fs_Append) {
	       /* "na" => listen for connections */
	       f = sock_listen(fnamestr, is_udp);
/* fprintf(stderr, "\n f listen is %d\n", f); */
	    } else {
	       /* connect to a port */
	       f = sock_connect(fnamestr, is_udp);
/* fprintf(stderr, "\n f connect is %d\n", f); */
	    }
	    /* read/read is not allowed on a UDP socket, only receive */
	    if (is_udp)
	       status = Fs_Socket | Fs_Write;
	    else
	       status = Fs_Socket | Fs_Read | Fs_Write;


	    if (!f)
	       IntVal(amperErrno) = errno;
	 }
	 else if (stat(fnamestr, &st) < 0) {
	    if (errno == ENOENT && (status & Fs_Read))
	       fail;
	    else
	       f = fopen(fnamestr, mode);
	 }
	 else {
	    /*
	     * check and see if the file was actually a directory
	     */
#if !NT
	    if (S_ISDIR(st.st_mode)) {
	       if (status & Fs_Write)
		  runerr(173, fname);
	       else {
		  f = (FILE *)opendir(fnamestr);
		  status |= Fs_Dir;
		  }
	       }
#else					/* !NT */
	    if (st.st_mode & _S_IFDIR) {
	       if (status & Fs_Write)
		  runerr(173, fname);
	       else {
		  char tempbuf[512];
		  strcpy(tempbuf, fnamestr);
		  if (tempbuf[strlen(tempbuf)-1] != '\\')
		     strcat(tempbuf, "\\");
		  strcat(tempbuf, "*.*");
		  if (*tempbuf) {
		     FINDDATA_T fd;
		     if (!FINDFIRST(tempbuf, &fd)) fail;
		     f = tmpfile();
		     if (f == NULL) fail;
		     do {
			fprintf(f, "%s\n", FILENAME(&fd));
			}
		     while (FINDNEXT(&fd));
		     FINDCLOSE(&fd);
		     fflush(f);
		     fseek(f, 0, SEEK_SET);
		     }
		  }  
	       }
#endif					/* NT */
	    else {
	       f = fopen(fnamestr, mode); 
	       }
	    }
	 }
#else					/* PosixFns */
  	 f = fopen(fnamestr, mode);
#endif 					/* PosixFns */
#endif					/* OpenAttributes */

      /*
       * Fail if the file cannot be opened.
       */
      if (f == NULL) {
#ifdef MSWindows
         char tempbuf[512];
	 *tempbuf = '\0';
         if (strchr(fnamestr, '*') || strchr(fnamestr, '?')) {
            /*
	     * attempted to open a wildcard, do file completion
	     */
	    strcpy(tempbuf, fnamestr);
            }
	 else {
            /*
	     * check and see if the file was actually a directory
	     */
            struct stat fs;
            int rv;

            rv = stat(fnamestr, &fs);
            if (rv == -1) fail;
	    if (fs.st_mode & _S_IFDIR) {
	       strcpy(tempbuf, fnamestr);
	       if (tempbuf[strlen(tempbuf)-1] != '\\')
	          strcat(tempbuf, "\\");
	       strcat(tempbuf, "*.*");
	       }
	    }
         if (*tempbuf) {
            FINDDATA_T fd;
	    if (!FINDFIRST(tempbuf, &fd)) fail;
            f = tmpfile();
            if (f == NULL) fail;
            do {
               fprintf(f, "%s\n", FILENAME(&fd));
               } while (FINDNEXT(&fd));
            FINDCLOSE(&fd);
            fflush(f);
            fseek(f, 0, SEEK_SET);
            if (f == NULL) fail;
	    }
#else					/* MSWindows */
	 fail;
#endif					/* MSWindows */
	 }

#if MACINTOSH
#if MPW
      {
	 void SetFileToMPWText(const char *fname);

	 if (status & Fs_Write)
	    SetFileToMPWText(fnamestr);
      }
#endif					/* MPW */
#endif					/* MACINTOSH */

      /*
       * Return the resulting file value.
       */
      StrLen(filename) = strlen(fnamestr);
      StrLoc(filename) = fnamestr;

      Protect(fl = alcfile(f, status, &filename), runerr(0));

#ifdef Graphics
      /*
       * link in the Icon file value so this window can find it
       */
      if (status & Fs_Window) {
	 ((wbp)f)->window->filep.dword = D_File;
	 BlkLoc(((wbp)f)->window->filep) = (union block *)fl;
	 if (is:null(lastEventWin)) {
	    lastEventWin = ((wbp)f)->window->filep;
            lastEvFWidth = FWIDTH((wbp)f);
            lastEvLeading = LEADING((wbp)f);
            lastEvAscent = ASCENT((wbp)f);
            }
	 }
#endif					/* Graphics */

/* fprintf(stderr, "returned a file\n"); */

      return file(fl);
      }
end


"read(f) - read line on file f."

function{0,1} read(f)
   /*
    * Default f to &input.
    */
   if is:null(f) then
      inline {
	 f.dword = D_File;
	 BlkLoc(f) = (union block *)&k_input;
	 }
   else if !is:file(f) then
      runerr(105, f)

   abstract {
      return string
      }

   body {
      register word slen, rlen;
      register char *sp;
      int status;
      static char sbuf[MaxReadStr];
      tended struct descrip s;
      FILE *fp;
#ifdef PosixFns
#if 1 /* NT */
      SOCKET ws;
#endif					/* NT */
#endif					/* PosixFns */

      /*
       * Get a pointer to the file and be sure that it is open for reading.
       */
      fp = BlkLoc(f)->file.fd;
      status = BlkLoc(f)->file.status;
      if ((status & Fs_Read) == 0)
	 runerr(212, f);

#ifdef PosixFns
#if 1 /* NT */
       if (status & Fs_Socket) {
	  StrLen(s) = 0;
          do {
	     ws = (SOCKET)fp;
	     if ((slen = sock_getstrg(sbuf, MaxReadStr, ws)) == -1) {
	        /*IntVal(amperErrno) = errno; */
	        fail;
		}
	     if (slen == -3)
		fail;
	     if (slen == 1 && *sbuf == '\n')
		break;
	     rlen = slen < 0 ? (word)MaxReadStr : slen;

	     Protect(reserve(Strings, rlen), runerr(0));
	     if (StrLen(s) > 0 && !InRange(strbase,StrLoc(s),strfree)) {
	        Protect(reserve(Strings, StrLen(s)+rlen), runerr(0));
	        Protect((StrLoc(s) = alcstr(StrLoc(s),StrLen(s))), runerr(0));
		}

	     Protect(sp = alcstr(sbuf,rlen), runerr(0));
	     if (StrLen(s) == 0)
	        StrLoc(s) = sp;
	     StrLen(s) += rlen;
	     if (StrLoc(s) [ StrLen(s) - 1 ] == '\n') { StrLen(s)--; break; }
	     else {
/*	        FILE *f = fopen("delete.me","a");
		fprintf(f,"got sock_getstrg but its not a line\n");
		fclose(f); */
		}
	     }
	  while (slen > 0);

         return s;
		}
#else
      /* 
       * well.... switching from unbuffered to buffered actually works so
       * we will allow it except for sockets.
       */
      if (status & Fs_Unbuf) {
	 if (status & Fs_Socket)
	    runerr(180, f);
	 status &= ~Fs_Unbuf;
      }
#endif					/* NT */
      status |= Fs_Buff;
      BlkLoc(f)->file.status = status;
#endif					/* PosixFns */

      if (status & Fs_Writing) {
	 fseek(fp, 0L, SEEK_CUR);
	 BlkLoc(f)->file.status &= ~Fs_Writing;
	 }
      BlkLoc(f)->file.status |= Fs_Reading;

#ifdef ConsoleWindow
      /*
       * if file is &input, then make sure our console is open and read
       * from it, unless input redirected
       */
      if (fp == stdin
           && !(ConsoleFlags & StdInRedirect)
           ) {
        fp = OpenConsole();
        status = Fs_Window | Fs_Read | Fs_Write;
        }

#endif					/* ConsoleWindow */
      /*
       * Use getstrg to read a line from the file, failing if getstrg
       *  encounters end of file. [[ What about -2?]]
       */
      StrLen(s) = 0;
      do {

#ifdef Graphics
	 pollctr >>= 1;
	 pollctr++;
	 if (status & Fs_Window) {
	    slen = wgetstrg(sbuf,MaxReadStr,fp);
	    if (slen == -1)
	       runerr(141);
	    if (slen == -2)
	       runerr(143);
	    if (slen == -3)
               fail;
	    }
	 else
#endif					/* Graphics */

#ifdef PosixFns
#if !NT
	  if (status & Fs_Dir) {
	     struct dirent *d;
	     char *s, *p=sbuf;
	     IntVal(amperErrno) = 0;
	     slen = 0;
	     d = readdir((DIR *)fp);
	     if (!d)
	        fail;
	     s = d->d_name;
	     while(*s && slen++ < MaxReadStr)
	        *p++ = *s++;
	     if (slen == MaxReadStr)
		slen = -2;
	  }
	  else
#endif
#endif					/* PosixFns */

#ifdef RecordIO
	 if ((slen = (status & Fs_Record ? getrec(sbuf, MaxReadStr, fp) :
					   getstrg(sbuf, MaxReadStr, &BlkLoc(f)->file)))
	     == -1) fail;
#else					/* RecordIO */
	 if ((slen = getstrg(sbuf, MaxReadStr, &BlkLoc(f)->file)) == -1) {
#ifdef PosixFns
	    IntVal(amperErrno) = errno;
#endif					/* PosixFns */
	    fail;
	    }
#endif					/* RecordIO */

	 /*
	  * Allocate the string read and make s a descriptor for it.
	  */
	 rlen = slen < 0 ? (word)MaxReadStr : slen;

	 Protect(reserve(Strings, rlen), runerr(0));
	 if (StrLen(s) > 0 && !InRange(strbase,StrLoc(s),strfree)) {
	    Protect(reserve(Strings, StrLen(s)+rlen), runerr(0));
	    Protect((StrLoc(s) = alcstr(StrLoc(s),StrLen(s))), runerr(0));
	    }

	 Protect(sp = alcstr(sbuf,rlen), runerr(0));
	 if (StrLen(s) == 0)
	    StrLoc(s) = sp;
	 StrLen(s) += rlen;
	 } while (slen < 0);
      return s;
      }
end


"reads(f,i) - read i characters on file f."

function{0,1} reads(f,i)
   /*
    * Default f to &input.
    */
   if is:null(f) then
      inline {
	 f.dword = D_File;
	 BlkLoc(f) = (union block *)&k_input;
	 }
   else if !is:file(f) then
      runerr(105, f)

   /*
    * i defaults to 1 (read a single character)
    */
   if !def:C_integer(i,1L) then
      runerr(101, i)

   abstract {
      return string
      }

   body {
#if 1 /* NT */
      register word slen, rlen;
      register char *sp;
      static char sbuf[MaxReadStr];
      SOCKET ws;
      int bytesread = 0;
      int Maxread = 0;
#endif					/* NT */
      long tally, nbytes;
      int status;
      FILE *fp;
      tended struct descrip s;

      /*
       * Get a pointer to the file and be sure that it is open for reading.
       */
      fp = BlkLoc(f)->file.fd;
      status = BlkLoc(f)->file.status;
      if ((status & Fs_Read) == 0)
	 runerr(212, f);

#ifdef Messaging
      if (status & Fs_Messaging) {
	 struct MFile *mf = (struct MFile *)fp;
	 /* Casting to unsigned lets us use reads(f, -1) */
	 size_t size = (unsigned)i <= MaxReadStr ? i : MaxReadStr;
	 if (!MFIN(mf, READING)) {
	    Mstartreading(mf);
	    }
	 bytesread = tp_read(mf->tp, sbuf, size);
	 if (bytesread <= 0) {
	    extern int Merror;
	    if (Merror >= 1200) {
	       runerr(Merror, f);
	       }
	    fail;
	    }
	 
	 return string(bytesread, sbuf);
	 }
      else
#endif                                  /* Messaging */	       

#ifdef PosixFns     
#if 1 /* NT */
      if (status & Fs_Socket)  {
         StrLen(s) = 0;
	 Maxread = ((i<=MaxReadStr)?i:MaxReadStr);
	 do {
	    ws = (SOCKET)fp;
	    if (bytesread > 0) {
	       Maxread = ((i - bytesread <= MaxReadStr)? i - bytesread : MaxReadStr);
	       }
	    if ((slen = sock_getstrg(sbuf, Maxread, ws)) == -1) {
	       /*IntVal(amperErrno) = errno; */
	       fail;
	       }
	    if (slen == -3) {
	       fail;
	       }
	    if (slen > 0)
	       bytesread += slen;
	    rlen = slen < 0 ? (word)MaxReadStr : slen;

	    Protect(reserve(Strings, rlen), runerr(0));
	    if (StrLen(s) > 0 && !InRange(strbase,StrLoc(s),strfree)) {
	       Protect(reserve(Strings, StrLen(s)+rlen), runerr(0));
	       Protect((StrLoc(s) = alcstr(StrLoc(s),StrLen(s))), runerr(0));
	       }

	    Protect(sp = alcstr(sbuf,rlen), runerr(0));
	    if (StrLen(s) == 0)
	       StrLoc(s) = sp;
	    StrLen(s) += rlen;
	    } while (bytesread < i);

	 return s;
	 }
#endif					/*NT*/
      status |= Fs_Buff;
      BlkLoc(f)->file.status = status;
#endif					/* PosixFns */

      if (status & Fs_Writing) {
	 fseek(fp, 0L, SEEK_CUR);
	 BlkLoc(f)->file.status &= ~Fs_Writing;
	 }
      BlkLoc(f)->file.status |= Fs_Reading;

#ifdef ConsoleWindow
      /*
       * if file is &input, then make sure our console is open and read
       * from it, unless input redirected
       */
      if (fp == stdin
          && !(ConsoleFlags & StdInRedirect)
          ) {
        fp = OpenConsole();
        status = Fs_Read | Fs_Write | Fs_Window;
        }
#endif					/* ConsoleWindow */

#ifdef PosixFns
       if (status & Fs_Dir)
	   runerr(174, f);
#endif					/* PosixFns */

      /*
       * Be sure that a positive number of bytes is to be read.
       */
      if (i <= 0) {
	 irunerr(205, i);

	 errorfail;
	 }

#ifdef PosixFns
      /* Remember, sockets are always unbuffered */
      if (status & Fs_Unbuf) {
	 /* We do one read(2) call here to avoid interactions with stdio */

	 int fd;

	 if ((fd = get_fd(f, 0)) < 0)
	    runerr(174, f);
      
	 IntVal(amperErrno) = 0;
	 if (u_read(fd, i, &s) == 0)
	    fail;
	 return s;
      }
#endif					/* PosixFns */

      /*
       * For now, assume we can read the full number of bytes.
       */
      Protect(StrLoc(s) = alcstr(NULL, i), runerr(0));
      StrLen(s) = 0;

#if AMIGA
#if LATTICE
      /*
       * The following code is special for Lattice 4.0 -- it was different
       *  for Lattice 3.10.  It probably won't work correctly with other
       *  C compilers.
       */
      if (IsInteractive(_ufbs[fileno(fp)].ufbfh)) {
	 if ((i = read(fileno(fp),StrLoc(s),i)) <= 0)
	    fail;
	 StrLen(s) = i;
	 /*
	  * We may not have used the entire amount of storage we reserved.
	  */
	 nbytes = DiffPtrs(StrLoc(s) + i, strfree);
	 if (nbytes < 0)
	    EVVal(-nbytes, E_StrDeAlc);
	 else
	    EVVal(nbytes, E_String);
	 strtotal += nbytes;
	 strfree = StrLoc(s) + i;
	 return s;
	 }
#endif					/* LATTICE */
#endif					/* AMIGA */

#ifdef Graphics
      pollctr >>= 1;
      pollctr++;
      if (status & Fs_Window) {
	 tally = wlongread(StrLoc(s),sizeof(char),i,fp);
	 if (tally == -1)
	    runerr(141);
	 else if (tally == -2)
	    runerr(143);
	 else if (tally == -3)
            fail;
	 }
      else
#endif					/* Graphics */
      tally = longread(StrLoc(s),sizeof(char),i,fp);

      if (tally == 0)
	 fail;
      StrLen(s) = tally;
      /*
       * We may not have used the entire amount of storage we reserved.
       */
      nbytes = DiffPtrs(StrLoc(s) + tally, strfree);
      if (nbytes < 0)
         EVVal(-nbytes, E_StrDeAlc);
      else
         EVVal(nbytes, E_String);
      strtotal += nbytes;
      strfree = StrLoc(s) + tally;
      return s;
      }
end


"remove(s) - remove the file named s."

function{0,1} remove(s)

   /*
    * Make a C-style string out of s
    */
   if !cnv:C_string(s) then
      runerr(103,s)
   abstract {
      return null
      }

   inline {
      if (remove(s) != 0)
	 fail;
      return nulldesc;
      }
end


"rename(s1,s2) - rename the file named s1 to have the name s2."

function{0,1} rename(s1,s2)

   /*
    * Make C-style strings out of s1 and s2
    */
   if !cnv:C_string(s1) then
      runerr(103,s1)
   if !cnv:C_string(s2) then
      runerr(103,s2)

   abstract {
      return null
      }

   body {
      int i=0;
#if NT
      if ((i = rename(s1,s2)) != 0) {
	 remove(s2); 
	 if (rename(s1,s2) != 0)
	    fail;
	 }
      return nulldesc;
#else					/*NT*/
      if (rename(s1,s2) != 0)
	 fail;
      return nulldesc;
#endif					/* NT */
      }
end

#ifdef ExecImages

"save(s) - save the run-time system in file s"

function{0,1} save(s)

   if !cnv:C_string(s) then
      runerr(103,s)

   abstract {
      return integer
      }

   body {
      char sbuf[MaxCvtLen];
      int f, fsz;

      dumped = 1;

      /*
       * Open the file for the executable image.
       */
      f = creat(s, 0777);
      if (f == -1)
	 fail;
      fsz = wrtexec(f);
      /*
       * It happens that most wrtexecs don't check the system call return
       *  codes and thus they'll never return -1.  Nonetheless...
       */
      if (fsz == -1)
	 fail;
      /*
       * Return the size of the data space.
       */
      return C_integer fsz;
      }
end
#endif					/* ExecImages */


"seek(f,i) - seek to offset i in file f."
" [[ What about seek error ? ]] "

function{0,1} seek(f,o)

   /*
    * f must be a file
    */
   if !is:file(f) then
      runerr(105,f)

   /*
    * o must be an integer and defaults to 1.
    */
   if !def:C_integer(o,1L) then
      runerr(0)

   abstract {
      return file
      }

   body {
      FILE *fd;

      fd = BlkLoc(f)->file.fd;
      if (BlkLoc(f)->file.status == 0)
	 fail;

#ifdef PosixFns
      if (BlkLoc(f)->file.status & Fs_Dir)
	 fail;
#endif					/* PosixFns */

#ifdef Graphics
      pollctr >>= 1;
      pollctr++;
      if (BlkLoc(f)->file.status & Fs_Window)
	 fail;
#endif					/* Graphics */


#ifdef Network
	if ( BlkLoc(f)->file.status & Fs_Network ) {
	   fprintf(stderr, "network seek() not yet implemented\n");
	   fail;
	}
#endif					/* Network */

      if (o > 0) {
/* fseek returns a non-zero value on error for CSET2, not -1 */
#if CSET2
	 if (fseek(fd, o - 1, SEEK_SET))
#else
	 if (fseek(fd, o - 1, SEEK_SET) == -1)
#endif					/* CSET2 */
	    fail;
	 }
      else {

#if CSET2
/* unreliable seeking from the end in CSet/2 on a text stream, so
   we will fixup seek-from-end to seek-from-beginning */
	long size;
	long save_pos;

	/* save the position in case we have to reset it */
	save_pos = ftell(fd);
	/* seek to the end and get the file size */
	fseek(fd, 0, SEEK_END);
	size = ftell(fd);
	/* try to accomplish the fixed-up seek */
	if (fseek(fd, size + o, SEEK_SET)) {
	   fseek(fd, save_pos, SEEK_SET);
	   fail;
	   }  /* End of if - seek failed, reset position */
#else
	 if (fseek(fd, o, SEEK_END) == -1)
	    fail;
#endif					/* CSET2 */
	 }
      BlkLoc(f)->file.status &= ~(Fs_Reading | Fs_Writing);
      return f;
      }
end


#ifndef PosixFns

"system(s) - execute string s as a system command."

function{1} system(s, o)
   /*
    * Make a C-style string out of s
    */
   if !cnv:C_string(s) then
      runerr(103,s)
   /*
    * o must be an integer and defaults to 1.
    */
   if !def:C_integer(o,1L) then
      runerr(0)

   abstract {
      return integer
      }

   inline {
      /*
       * Pass the C string to the system() function and return
       * the exit code of the command as the result of system().
       * Note, the expression on a "return" may not have side effects,
       * so the exit code must be returned via a variable.
       */
      C_integer i, j;
      char *cmdname;
      char *args[256];

#ifdef Graphics
      pollctr >>= 1;
      pollctr++;
#endif					/* Graphics */

#if 0 /*def MSWindows - try out spawnvp() under win32 */
      i = (C_integer)mswinsystem(s);
#else					/* MSWindows */
#if NT
      if (o == 0)   { /* nowait, or 0, for second argument */
         cmdname = strtok(s, " ");
     
         for(j = 0; j<256; j++)   
            if ((args[j] = strtok(NULL, " ")) == NULL)
	       break;
	 args[j] = NULL;
         _flushall();
         i = (C_integer)_spawnvp(_P_NOWAITO, cmdname, args);
       
      }
      else
#endif					/*NT*/
      i = (C_integer)system(s);
#endif					/* MSWindows */

      return C_integer i;
      }
end
#endif					/* PosixFns */


"where(f) - return current offset position in file f."

function{0,1} where(f)

   if !is:file(f) then
      runerr(105,f)

   abstract {
      return integer
      }

   body {
      FILE *fd;
      long ftell();
      long pos;

      fd = BlkLoc(f)->file.fd;

      if ((BlkLoc(f)->file.status == 0))
	 fail;

#ifdef Graphics
      pollctr >>= 1;
      pollctr++;
      if (BlkLoc(f)->file.status & Fs_Window)
	 fail;
#endif					/* Graphics */

#ifdef Network
      if ( BlkLoc(f)->file.status & Fs_Network ) {
	 fprintf(stderr, "network where() not yet implemented\n");
	 fail;
	 }
#endif 					/* Network */

      pos = ftell(fd) + 1;
      if (pos == 0)
	 fail;	/* may only be effective on ANSI systems */

      return C_integer pos;
      }
end

/*
 * stop(), write(), and writes() differ in whether they stop the program
 *  and whether they output newlines. The macro GenWrite is used to
 *  produce all three functions.
 */
#define False 0
#define True 1

#begdef DefaultFile(error_out)
   inline {
#if error_out
      if ((k_errout.status & Fs_Write) == 0)
	 runerr(213);
      else {
#ifndef ConsoleWindow
	 f = k_errout.fd;
#else					/* ConsoleWindow */
         f = (ConsoleFlags & StdErrRedirect) ? k_errout.fd : OpenConsole();
#endif					/* ConsoleWindow */
	 }
#else					/* error_out */
      if ((k_output.status & Fs_Write) == 0)
	 runerr(213);
      else {
#ifndef ConsoleWindow
	 f = k_output.fd;
#else					/* ConsoleWindow */
         f = (ConsoleFlags & StdOutRedirect) ? k_output.fd : OpenConsole();
#endif					/* ConsoleWindow */
	 }
#endif					/* error_out */
      }
#enddef					/* DefaultFile */

#begdef Finish(retvalue, nl, terminate)
#if nl
   /*
    * Append a newline to the file.
    */
#ifdef Graphics
   pollctr >>= 1;
   pollctr++;
   if (status & Fs_Window)
      wputc('\n',(wbp)f);
   else
#endif					/* Graphics */
#ifdef RecordIO
      if (!(status & Fs_Record)) {
#endif					/* RecordIO */
#ifdef Messaging
      if (status & Fs_Messaging) {
	 struct MFile *mf = (struct MFile *)f;
	 extern int Merror;
	 if (!MFIN(mf, WRITING)) {
	    runerr(213);
	    }
	 if (tp_write(mf->tp, "\n", 1) < 0) {
	    fail;
	    }
	 if (Merror != 0) {
	    runerr(Merror);
	    }
	 }
      else	 
#endif                                  /* Messaging */
#ifdef PosixFns
      if (status & Fs_Socket) {
	 if (sock_write(f, "\n", 1) < 0)
#if terminate
	    syserr("sock_write failed in stop()");
#else
	    fail;
#endif
         }
      else
#endif					/* PosixFns */
	 putc('\n', f);

#ifdef RecordIO
      }
#endif					/* RecordIO */
#endif					/* nl */

   /*
    * Flush the file.
    */
#ifdef Messaging
   if (!(status & Fs_Messaging)) {
#endif					/* Messaging */
#ifdef Graphics
   if (!(status & Fs_Window)) {
#endif					/* Graphics */
#ifdef RecordIO
      if (status & Fs_Record)
	 flushrec(f);
#endif					/* RecordIO */

#ifdef PosixFns
      if (!(status & Fs_Socket)) {
#endif					/* PosixFns */
      if (ferror(f))
	 runerr(214);
      fflush(f);
#ifdef PosixFns
      }
#endif					/* PosixFns */

#ifdef Graphics
      }
#ifdef PresentationManager
    /* must be writing to a window, then, if it is not the console,
       we have to set the background mix mode of the character bundle 
       back to LEAVEALONE so the background is no longer clobbered */
    else if (f != ConsoleBinding) {
      /* have to set the background mode back to leave-alone */
      ((wbp)f)->context->charBundle.usBackMixMode = BM_LEAVEALONE;
      /* force the reload on next use */
      ((wbp)f)->window->charContext = NULL;
      } /* End of else if - not the console window we're writing to */
#endif					/* PresentationManager */
#endif					/* Graphics */
#ifdef Messaging
   }
#endif					/* Messaging */


#if terminate
	    c_exit(EXIT_FAILURE);
#else					/* terminate */
	    return retvalue;
#endif					/* terminate */
#enddef					/* Finish */

#begdef GenWrite(name, nl, terminate)

#name "(a,b,...) - write arguments"
#if !nl
   " without newline terminator"
#endif					/* nl */
#if terminate
   " (starting on error output) and stop"
#endif					/* terminate */
"."

#if terminate
function {} name(x[nargs])
#else					/* terminate */
function {1} name(x[nargs])
#endif					/* terminate */

   declare {
      FILE *f = NULL;
      word status =
#if terminate
#ifndef ConsoleWindow
	k_errout.status;
#else					/* ConsoleWindow */
        (ConsoleFlags & StdErrRedirect) ? k_errout.status : Fs_Read | Fs_Write | Fs_Window;
#endif					/* ConsoleWindow */
#else					/* terminate */
#ifndef ConsoleWindow
	k_output.status;
#else					/* ConsoleWindow */
        (ConsoleFlags & StdOutRedirect) ? k_output.status : Fs_Read | Fs_Write | Fs_Window;
#endif					/* ConsoleWindow */
#endif					/* terminate */

#ifdef BadCode
      struct descrip temp;
#endif					/* BadCode */
      }

#if terminate
   abstract {
      return empty_type
      }
#endif					/* terminate */

   len_case nargs of {
      0: {
#if !terminate
	 abstract {
	    return null
	    }
#endif					/* terminate */
	 DefaultFile(terminate)
	 body {
	    Finish(nulldesc, nl, terminate)
	    }
	 }

      default: {
#if !terminate
	 abstract {
	    return type(x)
	    }
#endif					/* terminate */
	 /*
	  * See if we need to start with the default file.
	  */
	 if !is:file(x[0]) then
	    DefaultFile(terminate)

	 body {
	    tended struct descrip t;
	    register word n;

	    /*
	     * Loop through the arguments.
	     */
	    for (n = 0; n < nargs; n++) {
	       if (is:file(x[n])) {	/* Current argument is a file */
#if nl
		  /*
		   * If this is not the first argument, output a newline to the
		   * current file and flush it.
		   */
		  if (n > 0) {

		     /*
		      * Append a newline to the file and flush it.
		      */
#ifdef Graphics
		     pollctr >>= 1;
		     pollctr++;
		     if (status & Fs_Window) {
			wputc('\n',(wbp)f);
			wflush((wbp)f);
			  }
		     else {
#endif					/* Graphics */
#ifdef RecordIO
			if (status & Fs_Record)
			   flushrec(f);
			else
#endif					/* RecordIO */
#ifdef Messaging
                        if (status & Fs_Messaging) {
			   struct MFile *mf = (struct MFile *)f;
			   extern int Merror;
			   if (!MFIN(mf, WRITING)) {
			     runerr(213);
			   }
			   if (tp_write(mf->tp, "\n", 1) < 0) {
			      fail;
			      }
			   if (Merror != 0) {
			      runerr(Merror, x[n]);
			      }
			   }
			else
#endif                                  /* Messaging */
#ifdef PosixFns
			if (status & Fs_Socket) {
			   if (sock_write(f, "\n", 1) < 0)
#if terminate
			      syserr("sock_write failed in stop()");
#else
			      fail;
#endif
			   }
			else {
#endif					/* PosixFns */
			putc('\n', f);
			if (ferror(f))
			   runerr(214);
			fflush(f);
#ifdef PosixFns
                        }
#endif					/* PosixFns */
#ifdef Graphics
			}
#endif					/* Graphics */
		     }
#endif					/* nl */

#ifdef PresentationManager
                 /* have to put the background mix back on the current file */
                 if (f != NULL && (status & Fs_Window) && f != ConsoleBinding) {
                   /* set the background back to leave-alone */
                   ((wbp)f)->context->charBundle.usBackMixMode = BM_LEAVEALONE;
                   /* unload the context from this window */
                   ((wbp)f)->window->charContext = NULL;
                   }
#endif					/* PresentationManager */

		  /*
		   * Switch the current file to the file named by the current
		   * argument providing it is a file.
		   */
		  status = BlkLoc(x[n])->file.status;
		  if ((status & Fs_Write) == 0)
		     runerr(213, x[n]);
		  f = BlkLoc(x[n])->file.fd;
#ifdef ConsoleWindow
                  if ((f == stdout && !(ConsoleFlags & StdOutRedirect)) ||
                      (f == stderr && !(ConsoleFlags & StdErrRedirect))) {
                     f = OpenConsole();
                     status = Fs_Read | Fs_Write | Fs_Window;
                     }
#endif					/* ConsoleWindow */
#ifdef PresentationManager
                  if (status & Fs_Window) {
                     /*
		      * have to set the background to overpaint - the one
                      * difference between DrawString and write(s)
		      */
                    ((wbp)f)->context->charBundle.usBackMixMode = BM_OVERPAINT;
                    /* unload the context from the window so it will be reloaded */
                    ((wbp)f)->window->charContext = NULL;
                    }
#endif					/* PresentationManager */
		  }
	       else {
		  /*
		   * Convert the argument to a string, defaulting to a empty
		   *  string.
		   */
		  if (!def:tmp_string(x[n],emptystr,t))
		     runerr(109, x[n]);

		  /*
		   * Output the string.
		   */
#ifdef Graphics
		  if (status & Fs_Window)
		     wputstr((wbp)f, StrLoc(t), StrLen(t));
		  else
#endif					/* Graphics */
#ifdef RecordIO
		     if ((status & Fs_Record ? putrec(f, &t) :
					     putstr(f, &t)) == Failed)
#else					/* RecordIO */
#ifdef Messaging
                     if (status & Fs_Messaging) {
			struct MFile *mf = (struct MFile *)f;
			extern int Merror;
			Merror = 0;
			tp_write(mf->tp, StrLoc(t), StrLen(t));
			if (Merror > 1200) {
			   runerr(Merror);
			   }
			}
		     else
#endif                                  /* Messaging */
#ifdef PosixFns
		     if (status & Fs_Socket) {

			if (sock_write(f, StrLoc(t), StrLen(t)) < 0) {
#if terminate
			   syserr("sock_write failed in stop()");
#else
			   fail;
#endif
			   }
		     } else {  
#endif					/* PosixFns */
		     if (putstr(f, &t) == Failed) 
#endif					/* RecordIO */
			runerr(214, x[n]);
#ifdef PosixFns
			}
#endif
		  }
	       }

	    Finish(x[n-1], nl, terminate)
	    }
	 }
      }
end
#enddef					/* GenWrite */

GenWrite(stop,	 True,	True)  /* stop(s, ...) - write message and stop */
GenWrite(write,  True,	False) /* write(s, ...) - write with new-line */
GenWrite(writes, False, False) /* writes(s, ...) - write with no new-line */

#ifdef KeyboardFncs

"getch() - return a character from console."

function{0,1} getch()
   abstract {
      return string;
      }
   body {
      int i;
#ifndef ConsoleWindow
      i = getch();
#else					/* ConsoleWindow */
      struct descrip res;
      if (wgetchne((wbp)OpenConsole(), &res) < 0) fail;
      i = *StrLoc(res);
#endif					/* ConsoleWindow */
      if (i<0 || i>255)
	 fail;
      return string(1, (char *)&allchars[FromAscii(i) & 0xFF]);
      }
end

"getche() -- return a character from console with echo."

function{0,1} getche()
   abstract {
      return string;
      }
   body {
      int i;
#ifndef ConsoleWindow
      i = getche();
#else					/* ConsoleWindow */
      struct descrip res;
      if (wgetche((wbp)OpenConsole(), &res) < 0) fail;
      i = *StrLoc(res);
#endif					/* ConsoleWindow */
      if (i<0 || i>255)
	 fail;
      return string(1, (char *)&allchars[FromAscii(i) & 0xFF]);
      }
end


"kbhit() -- Check to see if there is a keyboard character waiting to be read."

function{0,1} kbhit()
   abstract {
      return null
      }
   inline {
      int rv;
#ifndef ConsoleWindow
      if (kbhit())
	 return nulldesc;
      else fail;
#else					/* ConsoleWindow */
     /* make sure we're up-to-date event wise */
     if (ConsoleBinding) {
        pollevent();
        /*
	 * perhaps should look in the console's icon event list for a keypress;
	 *  either a string or event > 60k; presently, succeed for all events
	 */
        if (BlkLoc(((wbp)ConsoleBinding)->window->listp)->list.size > 0)
	   return nulldesc;
        }
     fail;
#endif					/* ConsoleWindow */
      }
end
#endif					/* KeyboardFncs */

"chdir(s) - change working directory to s."
function{0,1} chdir(s)
   if !cnv:string(s) then
       if !is:null(s) then
	  runerr(103, s)
   abstract {
      return string
   }
   body {
#if NT
#define chdir nt_chdir
#passthru #include <direct.h>
#endif

#if PORT
   Deliberate Syntax Error
#endif                                  /* PORT */
#if ARM || MACINTOSH || MVS || VM
      runerr(121);
#endif                                  /* ARM || MACINTOSH ... */
#if AMIGA || ATARI_ST || MSDOS || OS2 || UNIX || VMS || NT

      char path[PATH_MAX];
      int len;

      if (is:string(s)) {
	 tended char *dir;
	 cnv:C_string(s, dir);
	 if (chdir(dir) != 0)
	    fail;
	 }
#ifndef PATH_MAX
#define PATH_MAX 512
#endif					/* PATH_MAX */
      if ((int)getcwd(path, PATH_MAX) == 0)
	  fail;

      len = strlen(path);
      Protect(StrLoc(result) = alcstr(path, len), runerr(0));
      StrLen(result) = len;
      return result;

#endif
   }
end

#if NT
#ifdef MSWindows
char *getenv(char *s)
{
static char tmp[1537];
DWORD rv;
rv = GetEnvironmentVariable(s, tmp, 1536);
if (rv > 0) return tmp;
return NULL;
}
#endif					/* MSWindows */

int nt_chdir(char *s)
{
    return chdir(s);
}
#endif					/* NT */

"delay(i) - delay for i milliseconds."

function{0,1} delay(n)

   if !cnv:C_integer(n) then
      runerr(101,n)
   abstract {
      return null
      }

   inline {
      if (idelay(n) == Failed)
        fail;
#ifdef Graphics
      pollctr >>= 1;
      pollctr++;
#endif					/* Graphics */
      return nulldesc;
      }
end

"flush(f) - flush file f."

function{1} flush(f)
   if !is:file(f) then
      runerr(105, f)
   abstract {
      return type(f)
      }

   body {
      FILE *fp;
      fp = BlkLoc(f)->file.fd;

#ifdef Graphics
      pollctr >>= 1;
      pollctr++;

#ifndef PresentationManager
      if (BlkLoc(f)->file.status & Fs_Window)
	 wflush((wbp)fp);
      else
#else
       if (!(BlkLoc(f)->file.status & Fs_Window))
#endif					/* PresentationManager */
#endif					/* Graphics */
	 fflush(fp);

      /*
       * Return the flushed file.
       */
      return f;
      }
end
