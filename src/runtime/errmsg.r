/*
 * errmsg.r -- err_msg, irunerr, drunerr
 */

extern struct errtab errtab[];		/* error numbers and messages */

char *logopt;                            /* Log option destination */ 

/*
 * set &errornumber and &errortext to a given (run-time error) number
 */
void set_errortext(int i)
{
   register struct errtab *p;
   CURTSTATE();
   k_errornumber = i;
   MakeStr("", 0, &k_errortext);
   for (p = errtab; p->err_no > 0; p++)
      if (p->err_no == i) {
         MakeStr(p->errmsg,strlen(p->errmsg),&k_errortext);
         break;
         }
}


/*
 * set &errornumber and &errortext to a given (run-time error) number
 */
void set_errortext_with_val(int i, char* errval)
{
   register struct errtab *p;
   CURTSTATE();
   k_errornumber = i;

   if (errval != NULL) {
     int buflen = strlen(errval);
     if ((StrLoc(k_errorvalue) = alcstr(NULL, buflen)) != NULL) {
       strcpy(StrLoc(k_errorvalue), errval);
       have_errval = 1;
       StrLen(k_errorvalue) = buflen;
     }
   }

   MakeStr("", 0, &k_errortext);
   for (p = errtab; p->err_no > 0; p++)
      if (p->err_no == i) {
         MakeStr(p->errmsg,strlen(p->errmsg),&k_errortext);
         break;
         }
}

#ifdef HAVE_GETADDRINFO
/*
 * set &errornumber and &errortext based on error values from getaddrinfo() and getnameinfo().
 */
void set_gaierrortext(int i)
{
   int buflen;
   char buf[512];
   CURTSTATE();
   k_errornumber = i;
   snprintf(buf, 511, "%s", gai_strerror(i));
   buf[511] = 0;
   buflen = strlen(buf);
   if ((StrLoc(k_errortext) = alcstr(buf, buflen)) != NULL) {
     StrLen(k_errortext) = buflen;
   }
}
#endif				/* HAVE_GETADDRINFO */

#if HAVE_LIBSSL
/*
 * set &errornumber and &errortext based on error values from openssl.
 */
void set_ssl_context_errortext(int err, char* errval)
{
   int buflen = 0;
   char* sslerr;
   CURTSTATE();

   if (err != 0)
     k_errornumber = err;
   else
     k_errornumber = 1301;

   if (errval != NULL) {
     buflen = strlen(errval);
     if ((StrLoc(k_errorvalue) = alcstr(NULL, buflen)) != NULL) {
       strcpy(StrLoc(k_errorvalue), errval);
       have_errval = 1;
       StrLen(k_errorvalue) = buflen;
     }
   }

   sslerr = (char *) ERR_reason_error_string(ERR_get_error());

   if (sslerr != NULL) {
     buflen = strlen(sslerr);
     if ((StrLoc(k_errortext) = alcstr(NULL, buflen)) != NULL) {
       strcpy(StrLoc(k_errortext), sslerr);
       StrLen(k_errortext) = buflen;
     }
   }
   else
     set_errortext(1216);


}

void set_ssl_connection_errortext(SSL *ssl, int err)
{
   int buflen;
   char* buf;
   char buf2[32];
   CURTSTATE();

   err = SSL_get_error(ssl, err);
   k_errornumber = err;
   switch (err) {
   case SSL_ERROR_WANT_WRITE  : snprintf(buf2, 32, "SSL_ERROR_WANT_WRITE"); break;
   case SSL_ERROR_WANT_READ   : snprintf(buf2, 32 ,"SSL_ERROR_WANT_READ"); break;
   case SSL_ERROR_WANT_ACCEPT : snprintf(buf2, 32 ,"SSL_ERROR_WANT_ACCEPT"); break;
   case SSL_ERROR_WANT_CONNECT: snprintf(buf2, 32 ,"SSL_ERROR_WANT_CONNECT"); break;
   case SSL_ERROR_SYSCALL     :
     if (errno == 0) {
       /*
	* OpenSSL bug: an enexpcted EOF from peer, see:
	* https://www.openssl.org/docs/man1.1.1/man3/SSL_get_error.html
	*/
       snprintf(buf2, 32 ,"unexpected EOF from peer");
     }
     else {
       set_syserrortext(errno);
       return;
     }

     break;
   case SSL_ERROR_SSL         : snprintf(buf2, 32 ,"SSL_ERROR_SSL"); break;
   default                    : snprintf(buf2, 32 ,"SSL_ERROR_OTHER"); break;
   }


#ifdef DEVMODE_BEBUG
   {
     char buf3[1024];
     ERR_error_string_n(ERR_get_error(), buf3 , 1024);
     printf("\n%s\n", buf3);
   }
#endif				/* EVMODE */

   buf = (char *) ERR_reason_error_string(ERR_get_error());
   if (buf == NULL)
     buf = buf2;

   buflen = strlen(buf);
   if ((StrLoc(k_errortext) = alcstr(NULL, buflen)) != NULL) {
     strcpy(StrLoc(k_errortext), buf);
     StrLen(k_errortext) = buflen;
   }
}
#endif				/* HAVE_LIBSSL */

/*
 * set &errno and &errortext based on a system call failure that set errno.
 * TODO: avoid allocations in most cases.
 */
void set_syserrortext(int ern)
{
   CURTSTATE();
   IntVal(amperErrno) = ern;
   if ((StrLoc(k_errortext) = alc_strerror(ern)) != NULL) {
      StrLen(k_errortext) = strlen(StrLoc(k_errortext));
      }
}

#if HAVE_LIBZ
/*
 * set &errno and &errortext based on a libz error.
 */
void set_gzerrortext(gzFile f)
{
   int ern, slen;
   const char *s = gzerror(f, &ern);
   CURTSTATE();
   slen = strlen(s);
   IntVal(amperErrno) = 214;
   if ((StrLoc(k_errortext) = alcstr(NULL, slen)) != NULL) {
      strcpy(StrLoc(k_errortext), s);
      StrLen(k_errortext) = slen;
      }
}
#endif					/* HAVE_LIBZ */

/*
 * err_msg - print run-time error message, performing trace back if required.
 *  This function underlies the rtt runerr() construct.
 */
void err_msg(int n, dptr v)
{
   register struct errtab *p;
   char *lfile = NULL;
   FILE *logfptr = NULL;   

#ifdef Messaging
   int saveerrno = errno;
#endif                                  /* Messaging */
   CURTSTATE_AND_CE();

   if (rt_status == RTSTATUS_NORMAL)
      rt_status = RTSTATUS_RUNERROR;

#ifdef Concurrent
#if !ConcurrentCOMPILER
   /* 
    * Force all of the threads to stop before proceeding with the runtime error 
    */
   if (is:null(curpstate->eventmask))
      if (IntVal(kywd_err) == 0 || !err_conv)
#endif                                  /* ConcurrentCOMPILER */
         SUSPEND_THREADS();
#endif					/* Concurrent */

   if (logopt != NULL)
      logfptr = fopen(logopt, "a");
   else if (((lfile = getenv("ULOG")) != NULL) && (lfile[0] != '\0')) {
      logfptr = fopen(lfile, "a");  
      }
   if (n == 0) {
      k_errornumber = t_errornumber;
      k_errorvalue = t_errorvalue;
      have_errval = t_have_val;
      }
   else {
      k_errornumber = n;
      if (v == NULL) {
         k_errorvalue = nulldesc;
         have_errval = 0;
         }
      else {
         k_errorvalue = *v;
         have_errval = 1;
         }
      }

   MakeStr("", 0, &k_errortext);
   for (p = errtab; p->err_no > 0; p++)
      if (p->err_no == k_errornumber) {
         MakeStr(p->errmsg,strlen(p->errmsg),&k_errortext);
         break;
         }

   EVVal((word)k_errornumber,E_Error);

   if (pfp != NULL) {
      if (IntVal(kywd_err) == 0 || !err_conv) {
         fprintf(stderr, "\nRun-time error %d\n", k_errornumber);
#if COMPILER
         if (line_info)
            fprintf(stderr, "File %s; Line %d\n", file_name, line_num);
#else					/* COMPILER */
         fprintf(stderr, "File %s; Line %ld\n", findfile(ipc.opnd),
            (long)findline(ipc.opnd));
#endif					/* COMPILER */
         }
      else {
         IntVal(kywd_err)--;
         if (logfptr != NULL)
      	    fclose(logfptr);	 
         return;
         }
      }
   else
      fprintf(stderr, "\nRun-time error %d in startup code\n", n);
   fprintf(stderr, "%s\n", StrLoc(k_errortext));

   if (have_errval) {
      fprintf(stderr, "offending value: ");
      outimage(stderr, &k_errorvalue, 0);
      putc('\n', stderr);
      }

#ifdef Messaging
   if (saveerrno != 0 && k_errornumber >= 1000) {
      fprintf(stderr, "system error (errno %d): \"%s\"\n", 
	      saveerrno, strerror(saveerrno));
      }
#endif                                  /* Messaging */

   if (!debug_info)
      c_exit(EXIT_FAILURE);

   if (pfp == NULL) {		/* skip if start-up problem */
      if (dodump)
         abort();
      c_exit(EXIT_FAILURE);
      }

   fprintf(stderr, "Traceback:\n");

   if (logfptr != NULL) {
      fprintf(logfptr, "Run-time error %d\n", k_errornumber);
#if COMPILER
      if (line_info)
	 fprintf(logfptr, "File %s; Line %d\n", file_name, line_num);
#else					/* COMPILER */
      fprintf(logfptr, "File %s; Line %ld\n", findfile(ipc.opnd),
	      (long)findline(ipc.opnd));
#endif					/* COMPILER */
      fprintf(logfptr, "%s\n", StrLoc(k_errortext));
      if (have_errval) {
	 fprintf(logfptr, "offending value: ");
	 outimage(logfptr, &k_errorvalue, 0);
	 putc('\n', logfptr);
	 }
      fprintf(logfptr, "Traceback:\n");
     }

   tracebk(pfp, glbl_argp, logfptr);
   if (logopt != NULL)
     fprintf(stderr, "Complete error traceback written to %s\n\n", logopt); 
   else if (lfile != NULL && lfile[0] != '\0' )
     fprintf(stderr, "Complete error traceback written to %s\n\n", lfile);
     
   fflush(stderr);
   if (logfptr != NULL)
      fclose(logfptr);

   if (dodump)
      abort();

   c_exit(EXIT_FAILURE);
}

/*
 * irunerr - print an error message when the offending value is a C_integer
 *  rather than a descriptor.
 */
void irunerr(n, v)
int n;
C_integer v;
   {
   CURTSTATE();
   t_errornumber = n;
   IntVal(t_errorvalue) = v;
   t_errorvalue.dword = D_Integer;
   t_have_val = 1;
   err_msg(0,NULL);
   }

/*
 * drunerr - print an error message when the offending value is a C double
 *  rather than a descriptor.
 */
void drunerr(n, v)
int n;
double v;
   {
   CURTSTATE();

#ifdef DescriptorDouble
   t_errornumber = n;
   t_errorvalue.vword.realval = v;
   t_errorvalue.dword = D_Real;
   t_have_val = 1;
#else					/* DescriptorDouble */
   {
   union block *bp;
   bp = (union block *)alcreal(v);
   if (bp != NULL) {
      t_errornumber = n;
      BlkLoc(t_errorvalue) = bp;
      t_errorvalue.dword = D_Real;
      t_have_val = 1;
      }
   }
#endif					/* DescriptorDouble */
   err_msg(0,NULL);
   }
