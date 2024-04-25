/*
 * File: keyword.r
 *  Contents: all keywords
 *
 *  After adding keywords, be sure to rerun ../icont/mkkwd.
 */

#define KDef(p,n) int Cat(K,p) (dptr cargp);
#include "../h/kdefs.h"
#undef KDef

#include "../h/revision.h"

"&allocated - the space used in the storage regions:"
" total, static, string, and block"
keyword{4} allocated
   abstract {
      return integer
      }
   inline {
#ifdef Concurrent
      struct threadstate *tstate;
      uword blktot=0;
      uword strtot=0;
#if !ConcurrentCOMPILER
      /* plausible to omit as there is only one program, and maybe globals
         in lieu of curpstate. But...
       */
      CURTSTATVAR();
#endif                                  /* ConcurrentCOMPILER */
      MUTEX_LOCKID(MTX_TLS_CHAIN);
      blktot = curpstate->blocktotal;
      strtot = curpstate->stringtotal;
      tstate = curpstate->tstate;
      do {
         blktot += tstate->blocktotal;
         strtot += tstate->stringtotal;
         tstate = tstate->next;
         } while (tstate!=NULL);
      MUTEX_UNLOCKID(MTX_TLS_CHAIN);
      suspend C_integer stattotal + strtot + blktot;
      suspend C_integer stattotal;
      suspend C_integer strtot;
      return  C_integer blktot;
#else                                   /* Concurrent */
      suspend C_integer stattotal + strtotal + blktotal;
      suspend C_integer stattotal;
      suspend C_integer strtotal;
      return  C_integer blktotal;
#endif                                  /* Concurrent */
      }
end

#if NT
/* redefine deprected functions to fix warnings on Windows*/
#define timezone _timezone
#define tzname _tzname
#endif

"&clock - a string consisting of the current time of day"
keyword{2} clock
   abstract {
      return string
      }
   inline {
      int i, tz_sec, offset_hrs;
      time_t t;
      struct tm *ct;
      char sbuf[128], *tmp;
#if !ConcurrentCOMPILER
      /* why on earth would &clock need a curtstate? */
      CURTSTATVAR();
#endif                                  /* ConcurrentCOMPILER */
      time(&t);
      ct = localtime(&t);

#if defined(SUN) || NT || defined(HAVE_TIMEZONE)
      tz_sec = timezone;
#else                                   /* HAVE_TIMEZONE */
      tz_sec = ct->tm_gmtoff;
#endif                                  /* HAVE_TIMEZONE */

      sprintf(sbuf,"%02d:%02d:%02d", ct->tm_hour, ct->tm_min, ct->tm_sec);
      Protect(tmp = alcstr(sbuf,(word)8), runerr(0));
      suspend string(8, tmp);

      /* Timezone information. Warning: portability problem here. */
      offset_hrs = tz_sec/3600;
      if (ct->tm_isdst) offset_hrs--;

#if defined(SUN) || NT || defined(HAVE_TZNAME)
      sprintf(sbuf, "UTC%+d %s", offset_hrs, ct->tm_isdst?tzname[1]:tzname[0]);
#else if defined(HAVE_STRUCT_TM_TM_ZONE)
      sprintf(sbuf, "UTC%+d %s", offset_hrs, ct->tm_zone);
#else
      sprintf(sbuf, "UTC%+d (unknown timezone)", offset_hrs);
#endif

      i = strlen(sbuf);
      Protect(tmp = alcstr(sbuf, i), runerr(0));
      suspend string(i, tmp);
      fail;
      }
end

"&collections - the number of collections: total, triggered by static requests"
" triggered by string requests, and triggered by block requests"
keyword{4} collections
   abstract {
      return integer
      }
   inline {
#if !ConcurrentCOMPILER
      /* plausible to omit as there is only one program, and maybe globals */
      CURTSTATVAR();
#endif                                  /* ConcurrentCOMPILER */
      suspend C_integer coll_tot;
      suspend C_integer coll_stat;
      suspend C_integer coll_str;
      return  C_integer coll_blk;
      }
end

#if !COMPILER
"&column - source column number of current execution point"
keyword{1} column
   abstract {
      return integer;
      }
   inline {
#ifdef MultiProgram
      CURTSTATE_AND_CE();
      return C_integer findcol(ipc.opnd);
#else
      fail;
#endif                                  /* MultiProgram */
      }
end
#endif                                  /* !COMPILER */

"&current - the currently active co-expression"
keyword{1} current
   abstract {
      return coexpr
      }
   inline {
#if !ConcurrentCOMPILER
      /* should be separate &current for each thread */
      CURTSTATE();
#endif                                  /* !ConcurrentCOMPILER */
      return k_current;
      }
end

"&date - the current date"
keyword{1} date
   abstract {
      return string
      }
   inline {
      time_t t;
      struct tm *ct;
      char sbuf[36], *tmp;

      time(&t);
      ct = localtime(&t);
      sprintf(sbuf, "%04d/%02d/%02d",
         1900 + ct->tm_year, ct->tm_mon + 1, ct->tm_mday);
      Protect(tmp = alcstr(sbuf,(word)10), runerr(0));
      return string(10, tmp);
      }
end

"&now - the system time"
keyword{1} now
   abstract {
      return integer
      }
   inline {
      time_t t;

      time(&t);
      return C_integer t;
      }
end

"&dateline - current date and time"
keyword{2} dateline
   abstract {
      return string
      }
   body {
      static char *day[] = {
         "Sunday", "Monday", "Tuesday", "Wednesday",
         "Thursday", "Friday", "Saturday"
         };
      static char *month[] = {
         "January", "February", "March", "April", "May", "June",
         "July", "August", "September", "October", "November", "December"
         };
      time_t t;
      struct tm *ct;
      char sbuf[MaxCvtLen];
      int hour;
      char *merid, *tmp;
      int i;
      int tz_sec, offset_hrs;
      CURTSTATVAR();

#ifdef _UCRT
      _tzset();
#endif
      time(&t);
      ct = localtime(&t);

      if ((hour = ct->tm_hour) >= 12) {
         merid = "pm";
         if (hour > 12)
            hour -= 12;
         }
      else {
         merid = "am";
         if (hour < 1)
            hour += 12;
         }
      sprintf(sbuf, "%s, %s %d, %d  %d:%02d %s", day[ct->tm_wday],
         month[ct->tm_mon], ct->tm_mday, 1900 + ct->tm_year, hour, ct->tm_min, merid);
      i = strlen(sbuf);
      Protect(tmp = alcstr(sbuf, i), runerr(0));
      suspend string(i, tmp);

#ifdef _UCRT
      _get_timezone(&tz_sec);
#elif defined(SUN) || NT || defined(HAVE_TIMEZONE)
      tz_sec = timezone;
#else
      tz_sec = ct->tm_gmtoff;
#endif

      offset_hrs = tz_sec/3600;
      if (ct->tm_isdst) offset_hrs--;
#ifdef _UCRT
      {
        size_t tzNameSize = -1;
        _get_tzname(&tzNameSize, NULL, 0, (ct->tm_isdst ? 1 : 0));
        if (tzNameSize > 0) {
          char tzNameBuf[tzNameSize];
          _get_tzname(&tzNameSize, &tzNameBuf[0],tzNameSize, (ct->tm_isdst ? 1 : 0));
          sprintf(sbuf, "UTC%+d %s", offset_hrs, &tzNameBuff[0]);
        } else {
          sprintf(sbuf, "UTC%+d (unknown timezone)", offset_hrs);
        }
      }
#elif defined(SUN) || NT || defined(HAVE_TZNAME)
      sprintf(sbuf, "UTC%+d %s", offset_hrs, ct->tm_isdst?tzname[1]:tzname[0]);
#else if defined(HAVE_STRUCT_TM_TM_ZONE)
      sprintf(sbuf, "UTC%+d %s", offset_hrs, ct->tm_zone);
#else
      sprintf(sbuf, "UTC%+d (unknown timezone)", offset_hrs);
#endif
      i = strlen(sbuf);
      Protect(tmp = alcstr(sbuf, i), runerr(0));
      suspend string(i, tmp);
      fail;
      }
end

"&digits - a cset consisting of the 10 decimal digits"
keyword{1} digits
   constant '0123456789'
end

"&e - the base of the natural logarithms"
keyword{1} e
   constant 2.71828182845904523536028747135266249775724709369996
end

"&error - enable/disable error conversion"
keyword{1} error
   abstract {
      return kywdint
      }
   inline {
      return kywdint(&kywd_err);
      }
end

"&errornumber - error number of last error converted to failure"
keyword{0,1} errornumber
   abstract {
      return integer
      }
   inline {
#if !ConcurrentCOMPILER
      /* plausible to omit as there is only one program, and maybe globals */
      CURTSTATE();
#endif                                  /* !ConcurrentCOMPILER */
      if (k_errornumber == 0)
         fail;
      return C_integer k_errornumber;
      }
end

"&errortext - error message of last error converted to failure"
keyword{0,1} errortext
   abstract {
      return string
      }
   inline {
#if !ConcurrentCOMPILER
      /* plausible to omit as there is only one program, and maybe globals */
      CURTSTATE();
#endif                                  /* !ConcurrentCOMPILER */
      if (((k_errornumber == 0) && IntVal(amperErrno)==0) ||
          (StrLoc(k_errortext) == NULL))
         return nulldesc; // fail or return an empty string?
      return k_errortext;
      }
end

"&errorvalue - erroneous value of last error converted to failure"
keyword{0,1} errorvalue
   abstract {
      return any_value
      }
   inline {
#if !ConcurrentCOMPILER
      /* plausible to omit as there is only one program, and maybe globals */
      CURTSTATE();
#endif                                  /* !ConcurrentCOMPILER */
      if (have_errval) {
         return k_errorvalue;
         }
      else
         fail;
      }
end

"&errout - standard error output."
keyword{1} errout
    abstract {
       return file
       }
    inline {
       return file(&k_errout);
       }
end

"&fail - just fail"
keyword{0} fail
   abstract {
      return empty_type
      }
   inline {
      fail;
      }
end

"&eventcode - event in monitored program"
keyword{0,1} eventcode
   abstract {
      return kywdevent
      }
   inline {
      return kywdevent(&k_eventcode);
      }
end

"&eventsource - source of events in monitoring program"
keyword{0,1} eventsource
   abstract {
      return kywdevent
      }
   inline {
      return kywdevent(&k_eventsource);
      }
end

"&eventvalue - value from event in monitored program"
keyword{0,1} eventvalue
   abstract {
      return kywdevent
      }
   inline {
      return kywdevent(&k_eventvalue);
      }
end


"&features - generate strings identifying features in this version of Icon"
keyword{1,*} features
   abstract {
      return string
      }
   body {
#ifdef RefPath
      char *refpath = RefPath;
#else                                   /* RefPath */
      char *refpath = "";
#endif                                  /* RefPath */

      CURTSTATVAR();

      if ((int)strlen(patchpath) > 18) refpath = patchpath+18;
      else if (strlen(refpath)==0) {
         struct stat buffer;
         char *iconx;
         int xnamelen;

         iconx = relfile(StrLoc(kywd_prog), "/../" UNICONX_EXE);
         xnamelen = strlen(UNICONX_EXE); /* "iconx.exe" */

         // check if we have iconx on a path relative to us
         if ((stat(iconx,&buffer)) == 0) {
            refpath = patchpath+18;
            strcpy(refpath, iconx);
            patchpath[strlen(patchpath)-xnamelen] = '\0';
            }
         }
      else {
#if MSDOS
         if (pathFind(UNICONX_EXE, patchpath+18, MaxPath)) {
            refpath = patchpath+18;
            patchpath[strlen(patchpath)-strlen(UNICONX_EXE)] = '\0';
            }
#endif                                  /* MSDOS */
#if UNIX
         if (findonpath(UNICONX, patchpath+18, MaxPath)) {
            refpath = patchpath+18;
            patchpath[strlen(patchpath)-strlen(UNICONX)] = '\0';
            }
         else {
            int c;
            FILE *f = fopen(StrLoc(kywd_prog), "r");
            if (f != NULL) {
               /*
                * look for iconx in our icode file (could also try the dir
                * containing &progname). Should fix to look rather at argv[0]
                * or save iconx path from icode when icode is loaded.
                */
               while ((c = getc(f)) && (c != EOF) && (c != '\n'));
               refpath = patchpath+18;
               if (fscanf(f, "IXBIN=%s\n", refpath) != 1) refpath = "";
               fclose(f);
               }
            else {
               fprintf(stderr,"&features: can't open '%s' to look for iconx\n",
                       StrLoc(kywd_prog));
               }
            }
#endif                                  /* UNIX */
         }

#if COMPILER
#define Feature(guard,sym,kwval) if ((guard) && (kwval)) suspend C_string kwval;
#else                                   /* COMPILER */
#define Feature(guard,sym,kwval) if (kwval) suspend C_string kwval;
#endif                                  /* COMPILER */

#include "../h/feature.h"

{
    char *s = alcstr(NULL, 33);
    if (get_CCompiler(s))
       suspend C_string s;
}

{
        char *s = alcstr(NULL, 44);
#if NT
        unsigned long long int l = physicalmemorysize();
#else                                           /* NT */
        unsigned long l = physicalmemorysize();
#endif                                          /* NT */
        if (l > 0) {
#if NT
           sprintf(s, "Physical memory: %llu bytes", l);
#else                                          /* NT */
           sprintf(s, "Physical memory: %lu bytes", l);
#endif                                         /* NT */
           suspend C_string s;
           }
}

#ifdef REPO_REVISION
{
         char *s = alcstr(NULL, strlen(REPO_REVISION) + strlen("Revision ") + 1);
         sprintf(s, "Revision %s", REPO_REVISION);
         suspend C_string s;
}
#endif                                  /* REPO_REVISION */

{
void get_arch(char *);
         char *s = alcstr(NULL, 20);
         get_arch(s);
         suspend C_string s;
}

{
         char *s = alcstr(NULL, 20);
         if (num_cpu_cores > 0) {
            sprintf(s, "CPU cores %d", num_cpu_cores );
            suspend C_string s;
            }
}

#if defined(MSWindows) && defined(SM_DIGITIZER)
      {
      int value = GetSystemMetrics(SM_DIGITIZER);
      if (value & NID_READY){ /* stack ready */
         if (value  & NID_MULTI_INPUT){ /* digitizer is multitouch */
            suspend C_string "Multitouch input";
            }
         else if (value & (NID_INTEGRATED_TOUCH|NID_EXTERNAL_TOUCH)){
            suspend C_string "Touch input";
            }
         else if (value & (NID_INTEGRATED_PEN|NID_EXTERNAL_PEN)){
            suspend C_string "Pen input";
            }
         }
}
#endif                                  /* MSWindows && SM_DIGITIZER */

      if (refpath && strlen(refpath) > 0) {
         char *s;
         if (!strcmp(refpath+strlen(refpath)-strlen(UNICONX_EXE), UNICONX_EXE)) {
            refpath[strlen(refpath)-strlen(UNICONX_EXE)] = '\0';
            /*
             * Trim prefix letters in front of iconx, if any
             */
            while ((strlen(refpath)>0) && isalpha(refpath[strlen(refpath)-1]))
               refpath[strlen(refpath)-1] = '\0';
            }

         s = alcstr(NULL, strlen(refpath) + strlen("Binaries at ") + 1);
         strcpy(s, "Binaries at ");
         strcat(s, refpath);
         suspend C_string s;
         }

      if ((int)strlen(uniroot) > 18) {
         char *s;
         s = alcstr(NULL, strlen(uniroot+18) + strlen("Libraries at ") + 1);
         strcpy(s, "Libraries at ");
         strcat(s, uniroot+18);
         suspend C_string s;
         }

      fail;
      }
end

"&file - name of the source file for the current execution point"
keyword{1} file
   abstract {
      return string
      }
   inline {
      char *s;
#if !ConcurrentCOMPILER
      /* COMPILER version of this doesn't look meaningful in any case.
       * A fixed version would need to handle multiple files and be
       * reporting location of current thread.
       */
      CURTSTATE_AND_CE();
#endif                                  /* !ConcurrentCOMPILER */
#if COMPILER
      if (line_info)
         return C_string file_name;
      else
         runerr(402);
#else                                   /* COMPILER */
      s = findfile(ipc.opnd);
      if (!strcmp(s,"?")) fail;
      return C_string s;
#endif                                  /* COMPILER */
      }
end

"&host - a string that identifies the host computer Icon is running on."
keyword{1} host
   abstract {
     return string
     }
   inline {
      char sbuf[MaxCvtLen], *tmp;
      int i;

      iconhost(sbuf);
      i = strlen(sbuf);
      Protect(tmp = alcstr(sbuf, i), runerr(0));
      return string(i, tmp);
      }
end

"&input - the standard input file"
keyword{1} input
   abstract {
      return file
      }
   inline {
      return file(&k_input);
      }
end

"&lcase - a cset consisting of the 26 lower case letters"
keyword{1} lcase
   constant 'abcdefghijklmnopqrstuvwxyz'
end

"&letters - a cset consisting of the 52 letters"
keyword{1} letters
   constant 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
end

"&level - level of procedure call."
keyword{1} level
   abstract {
      return integer
      }

   inline {
      /* need to check if ConcurrentCOMPILER, in the presence of debug_info,
       * has an &level per thread.
       */
#if !ConcurrentCOMPILER
      CURTSTATE();
#endif                                  /* ConcurrentCOMPILER */
#if COMPILER
      if (!debug_info)
         runerr(402);
#endif                                  /* COMPILER */
      return C_integer k_level;
      }
end

"&line - source line number of current execution point"
keyword{1} line
   abstract {
      return integer;
      }
   inline {
#if !ConcurrentCOMPILER
      /*
       * A fixed version would need to handle multiple files and be
       * reporting location of current thread.
       */
      CURTSTATE_AND_CE();
#endif                                  /* !ConcurrentCOMPILER */
#if COMPILER
      if (line_info)
         return C_integer line_num;
      else
         runerr(402);
#else                                   /* COMPILER */
      return C_integer findline(ipc.opnd);
#endif                                  /* COMPILER */
      }
end

"&main - the main co-expression."
keyword{1} main
   abstract {
      return coexpr
      }
   inline {
      return k_main;
      }
end

"&null - the null value."
keyword{1} null
   abstract {
      return null
      }
   inline {
      return nulldesc;
      }
end

"&output - the standard output file."
keyword{1} output
   abstract {
      return file
      }
   inline {
      return file(&k_output);
      }
end

"&phi - the golden ratio"
keyword{1} phi
   constant 1.618033988749894848204586834365638117720309180
end

"&pi - the ratio of circumference to diameter"
keyword{1} pi
   constant 3.14159265358979323846264338327950288419716939937511
end


"&pick - variable containing the result of 3D selection"
#ifdef Graphics3D
keyword{0,*} pick
   abstract {
      return string
      }
   inline {
      int i, elements;
      struct b_list *namelist;
      struct descrip name;
#if !ConcurrentCOMPILER
      CURTSTATVAR();
#endif                                  /* !ConcurrentCOMPILER */

      if (is:null(lastEventWin)) runerr(140, lastEventWin);
      if (is:null(amperPick)) fail;

      namelist = BlkD(amperPick, List);
      elements = namelist->size;

      for (i=0; i<elements; i++){
         c_traverse(namelist, &name, i);
         suspend name;
         }

      fail;
      }
end
#else                                   /* Graphics3D */
keyword{0} pick
   abstract {
      return empty_type
      }
   inline {
      fail;
      }
end
#endif                                  /* Graphics3D */


"&pos - a variable containing the current focus in string scanning."
keyword{1} pos
   abstract {
      return kywdpos
      }
   inline {
#if !ConcurrentCOMPILER
      /* there are not multiple programs, but don't threads have separate
       * copies of &pos? */
      CURTSTATE();
#endif                                  /* !ConcurrentCOMPILER */
      return kywdpos(&kywd_pos);
      }
end

"&progname - a variable containing the program name."
keyword{1} progname
   abstract {
      return kywdstr
      }
    inline {
      return kywdstr(&kywd_prog);
      }
end

"&random - a variable containing the current seed for random operations."
keyword{1} random
   abstract {
      return kywdint
      }
   inline {
#if !ConcurrentCOMPILER
      /* plausible to omit is there is only one program, one seed */
      CURTSTATE();
#endif                                  /* !ConcurrentCOMPILER */
      return kywdint(&kywd_ran);
      }
end

"&regions - generates regions sizes"
keyword{3} regions
   abstract {
      return integer
      }
   inline {
      word allRegions = 0;
      struct region *rp;
#if !ConcurrentCOMPILER
      /* not so sure this is plausible to omit, don't we need curtstate
       * in order to talk to curstring, etc.
       */
      CURTSTATE();
#endif                                  /* !ConcurrentCOMPILER */

      suspend C_integer 0;              /* static region */

      MUTEX_LOCKID(MTX_STRHEAP);
      allRegions = DiffPtrs(strend,strbase);
      for (rp = curstring->next; rp; rp = rp->next)
         allRegions += DiffPtrs(rp->end,rp->base);
      for (rp = curstring->prev; rp; rp = rp->prev)
         allRegions += DiffPtrs(rp->end,rp->base);
      MUTEX_UNLOCKID(MTX_STRHEAP);
      suspend C_integer allRegions;     /* string region */

      MUTEX_LOCKID(MTX_BLKHEAP);
      allRegions = DiffPtrs(blkend,blkbase);
      for (rp = curblock->next; rp; rp = rp->next)
         allRegions += DiffPtrs(rp->end,rp->base);
      for (rp = curblock->prev; rp; rp = rp->prev)
         allRegions += DiffPtrs(rp->end,rp->base);
      MUTEX_UNLOCKID(MTX_BLKHEAP);
      return C_integer allRegions;      /* block region */
      }
end

"&source - the co-expression that invoked the current co-expression."
keyword{1} source
   abstract {
       return coexpr
       }
   inline {
      /* proposed #if !ConcurrentCOMPILER rejected, we need curtstate to
       * get k_current.
       */
      CURTSTATE();
      /* proposed #endif !ConcurrentCOMPILER */
#ifndef CoExpr
      return k_main;
#else                                   /* CoExpr */
      return coexpr(topact(BlkD(k_current,Coexpr)));
#endif                                  /* CoExpr */
      }
end

"&storage - generate the amount of storage used for each region."
keyword{3} storage
   abstract {
      return integer
      }
   inline {
      word allRegions = 0;
      struct region *rp;
/* proposed if !ConcurrentCOMPILER rejected to omit curtstate */
      CURTSTATE();

      suspend C_integer 0;              /* static region */

      MUTEX_LOCKID(MTX_STRHEAP);
      allRegions = DiffPtrs(strfree,strbase);
      for (rp = curstring->next; rp; rp = rp->next)
         allRegions += DiffPtrs(rp->free,rp->base);
      for (rp = curstring->prev; rp; rp = rp->prev)
         allRegions += DiffPtrs(rp->free,rp->base);
      MUTEX_UNLOCKID(MTX_STRHEAP);
      suspend C_integer allRegions;     /* string region */

      MUTEX_LOCKID(MTX_BLKHEAP);
      allRegions = DiffPtrs(blkfree,blkbase);
      for (rp = curblock->next; rp; rp = rp->next)
         allRegions += DiffPtrs(rp->free,rp->base);
      for (rp = curblock->prev; rp; rp = rp->prev)
         allRegions += DiffPtrs(rp->free,rp->base);
      MUTEX_UNLOCKID(MTX_BLKHEAP);
      return C_integer allRegions;      /* block region */
      }
end

"&subject - variable containing the current subject of string scanning."
keyword{1} subject
   abstract {
      return kywdsubj
      }
   inline {
#if !ConcurrentCOMPILER
      /* there are not multiple programs, but don't threads have separate
       * copies of &subject? */
      CURTSTATE();
#endif                               /* !ConcurrentCOMPILER */
      return kywdsubj(&k_subject);
      }
end

"&time - the elapsed execution time in milliseconds."
keyword{1} time
   abstract {
      return integer
      }
   inline {
#ifdef MultiProgram
      /*
       * &time in this program = total time - time spent in other programs
       */
      return C_integer millisec() - curpstate->Kywd_time_elsewhere;
#else                                   /* MultiProgram */
      return C_integer millisec();
#endif                                  /* MultiProgram */
      }
end

"&trace - variable that controls procedure tracing."
keyword{1} trace
   abstract {
      return kywdint
      }
   inline {
      return kywdint(&kywd_trc);
      }
end

"&dump - variable that controls termination dump."
keyword{1} dump
   abstract {
      return kywdint
      }
   inline {
      return kywdint(&kywd_dmp);
      }
end

"&ucase - a cset consisting of the 26 uppercase characters."
keyword{1} ucase
   constant 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
end

"&version - strings identifying this version of Unicon."
keyword{3} version
   abstract {
      return string
    }
   inline {
      suspend C_string Version;        /* As before, from version.h */
      suspend C_string gitDescription; /* git describe --long HEAD */
      return  C_string gitBranch;      /* current git branch */
   }
end

"&errno - variable containing error number from previous posix command."
keyword{1} errno
#ifdef PosixFns
   abstract {
      return kywdint
      }
   inline {
#if !ConcurrentCOMPILER
      /* actually, I would think this would be tracked on a per-thread basis,
       * so we should probably dismantle this !ConcurrentCOMPILER directive.
       */
      CURTSTATE();
#endif                                  /* !ConcurrentCOMPILER */
      return kywdint(&amperErrno);
      }
#else /* PosixFns */
   abstract { return empty_type }
   inline { fail; }
#endif /* PosixFns */
end

#ifndef MultiProgram
struct descrip kywd_xwin[2] = {{D_Null}};
#endif                                  /* MultiProgram */

"&window - variable containing the current graphics rendering context."
#ifdef Graphics
keyword{1} window
   abstract {
      return kywdwin
      }
   inline {
      return kywdwin(kywd_xwin + XKey_Window);
      }
end
#else                                   /* Graphics */
keyword{0} window
   abstract {
      return empty_type
      }
   inline {
      fail;
      }
end
#endif                                  /* Graphics */

#ifdef Graphics
"&col - mouse horizontal position in text columns."
keyword{1} col
   abstract { return kywdint }
   inline { if (is:null(lastEventWin)) runerr(140, lastEventWin);
            else return kywdint(&amperCol); }
end

"&row - mouse vertical position in text rows."
keyword{1} row
   abstract { return kywdint }
   inline { if (is:null(lastEventWin)) runerr(140, lastEventWin);
            else return kywdint(&amperRow); }
end

"&x - mouse horizontal position."
keyword{1} x
   abstract { return kywdint }
   inline { if (is:null(lastEventWin)) runerr(140, lastEventWin);
            else return kywdint(&amperX); }
end

"&y - mouse vertical position."
keyword{1} y
   abstract { return kywdint }
   inline { if (is:null(lastEventWin)) runerr(140, lastEventWin);
            else return kywdint(&amperY); }
end

"&interval - milliseconds since previous event."
keyword{1} interval
   abstract { return kywdint }
   inline { if (is:null(lastEventWin)) runerr(140, lastEventWin);
            else return kywdint(&amperInterval); }
end

"&control - null if control key was down on last X event, else failure"
keyword{0,1} control
   abstract { return null }
   inline { if (is:null(lastEventWin)) runerr(140, lastEventWin);
            else if (xmod_control) return nulldesc; else fail; }
end

"&shift - null if shift key was down on last X event, else failure"
keyword{0,1} shift
   abstract { return null }
   inline { if (is:null(lastEventWin)) runerr(140, lastEventWin);
            else if (xmod_shift) return nulldesc; else fail; }
end

"&meta - null if meta key was down on last X event, else failure"
keyword{0,1} meta
   abstract { return null }
   inline { if (is:null(lastEventWin)) runerr(140, lastEventWin);
            else if (xmod_meta) return nulldesc; else fail; }
end
#else                                   /* Graphics */
"&col - mouse horizontal position in text columns."
keyword{0} col
   abstract { return empty_type }
   inline { fail; }
end

"&row - mouse vertical position in text rows."
keyword{0} row
   abstract { return empty_type }
   inline { fail; }
end

"&x - mouse horizontal position."
keyword{0} x
   abstract { return empty_type }
   inline { fail; }
end

"&y - mouse vertical position."
keyword{0} y
   abstract { return empty_type }
   inline { fail; }
end

"&interval - milliseconds since previous event."
keyword{0} interval
   abstract { return empty_type }
   inline { fail; }
end

"&control - null if control key was down on last X event, else failure"
keyword{0} control
   abstract { return empty_type}
   inline { fail; }
end

"&shift - null if shift key was down on last X event, else failure"
keyword{0} shift
   abstract { return empty_type }
   inline { fail; }
end

"&meta - null if meta key was down on last X event, else failure"
keyword{0} meta
   abstract { return empty_type }
   inline { fail; }
end
#endif                                  /* Graphics */

"&lpress - left button press."
keyword{1} lpress
   abstract { return integer} inline { return C_integer MOUSELEFT; }
end
"&mpress - middle button press."
keyword{1} mpress
   abstract { return integer} inline { return C_integer MOUSEMID; }
end
"&rpress - right button press."
keyword{1} rpress
   abstract { return integer} inline { return C_integer MOUSERIGHT; }
end
"&lrelease - left button release."
keyword{1} lrelease
   abstract { return integer} inline { return C_integer MOUSELEFTUP; }
end
"&mrelease - middle button release."
keyword{1} mrelease
   abstract { return integer} inline { return C_integer MOUSEMIDUP; }
end
"&rrelease - right button release."
keyword{1} rrelease
   abstract { return integer} inline { return C_integer MOUSERIGHTUP; }
end
"&ldrag - left button drag."
keyword{1} ldrag
   abstract { return integer} inline { return C_integer MOUSELEFTDRAG; }
end
"&mdrag - middle button drag."
keyword{1} mdrag
   abstract { return integer} inline { return C_integer MOUSEMIDDRAG; }
end
"&rdrag - right button drag."
keyword{1} rdrag
   abstract { return integer} inline { return C_integer MOUSERIGHTDRAG; }
end
"&resize - window resize."
keyword{1} resize
   abstract { return integer} inline { return C_integer RESIZED; }
end

"&ascii - a cset consisting of the 128 ascii characters"
keyword{1} ascii
#if EBCDIC == 1
constant '\
\x00\x01\x02\x03\x05\x07\x0b\x0c\x0d\x0e\x0f\x10\x11\x12\x13\x16\
\x18\x19\x1c\x1d\x1e\x1f\x25\x26\x27\x2d\x2e\x2f\x32\x37\x3c\x3d\
\x3f\x40\x4b\x4c\x4d\x4e\x4f\x50\x5a\x5b\x5c\x5d\x5e\x5f\x60\x61\
\x6b\x6c\x6d\x6e\x6f\x79\x7a\x7b\x7c\x7d\x7e\x7f\x81\x82\x83\x84\
\x85\x86\x87\x88\x89\x91\x92\x93\x94\x95\x96\x97\x98\x99\xa1\xa2\
\xa3\xa4\xa5\xa6\xa7\xa8\xa9\xad\xbd\xc0\xc1\xc2\xc3\xc4\xc5\xc6\
\xc7\xc8\xc9\xd0\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xe0\xe2\xe3\
\xe4\xe5\xe6\xe7\xe8\xe9\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9'
#else                                   /* EBCDIC == 1 */
constant '\
\000\001\002\003\004\005\006\007\010\011\012\013\014\015\016\017\
\020\021\022\023\024\025\026\027\030\031\032\033\034\035\036\037\
\040\041\042\043\044\045\046\047\050\051\052\053\054\055\056\057\
\060\061\062\063\064\065\066\067\070\071\072\073\074\075\076\077\
\100\101\102\103\104\105\106\107\110\111\112\113\114\115\116\117\
\120\121\122\123\124\125\126\127\130\131\132\133\134\135\136\137\
\140\141\142\143\144\145\146\147\150\151\152\153\154\155\156\157\
\160\161\162\163\164\165\166\167\170\171\172\173\174\175\176\177'
#endif                                  /* EBCDIC == 1 */
end

"&cset - a cset consisting of all the 256 characters."
keyword{1} cset
constant '\
\0\1\2\3\4\5\6\7\10\11\12\13\14\15\16\17\
\20\21\22\23\24\25\26\27\30\31\32\33\34\35\36\37\
\40\41\42\43\44\45\46\47\50\51\52\53\54\55\56\57\
\60\61\62\63\64\65\66\67\70\71\72\73\74\75\76\77\
\100\101\102\103\104\105\106\107\110\111\112\113\114\115\116\117\
\120\121\122\123\124\125\126\127\130\131\132\133\134\135\136\137\
\140\141\142\143\144\145\146\147\150\151\152\153\154\155\156\157\
\160\161\162\163\164\165\166\167\170\171\172\173\174\175\176\177\
\200\201\202\203\204\205\206\207\210\211\212\213\214\215\216\217\
\220\221\222\223\224\225\226\227\230\231\232\233\234\235\236\237\
\240\241\242\243\244\245\246\247\250\251\252\253\254\255\256\257\
\260\261\262\263\264\265\266\267\270\271\272\273\274\275\276\277\
\300\301\302\303\304\305\306\307\310\311\312\313\314\315\316\317\
\320\321\322\323\324\325\326\327\330\331\332\333\334\335\336\337\
\340\341\342\343\344\345\346\347\350\351\352\353\354\355\356\357\
\360\361\362\363\364\365\366\367\370\371\372\373\374\375\376\377'
end
