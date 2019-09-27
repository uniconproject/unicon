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
