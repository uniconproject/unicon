/*
 * uconsole.c -- pseudo console versions of stdio functions
 *
 * Historically, macros redefined printf to Consoleprintf, etc.
 * The problem with this is that all modules had to be recompiled
 * to switch from iconx to wiconx.
 *
 * The new strategy: stdio replacements use their regular names,
 * link in before the C compiler links in the system libraries.
 */
#include "../h/gsupport.h"

#if NT && defined(ConsoleWindow)
/*
 *  getch() -- return char from window, without echoing
 */
int getch(void)
{
   struct descrip res;
   if (wgetchne((wbp)OpenConsole(), &res) >= 0)
      return *StrLoc(res) & 0xFF;
   else
      return -1;	/* fail */
}

/*
 *  getch() -- return char from window, with echoing
 */
int getche(void)
{
   struct descrip res;
   if (wgetche((wbp)OpenConsole(), &res) >= 0)
      return *StrLoc(res) & 0xFF;
   else
      return -1;	/* fail */
}

/*
 *  kbhit() -- check for availability of char from window
 */
int kbhit(void)
{
   if (ConsoleBinding) {
      /* make sure we're up-to-date event wise */
      pollevent();
      /*
       * perhaps should look in the console's icon event list for a keypress;
       *  either a string or event > 60k; presently, succeed for all events
       */
      if (BlkD(((wbp)ConsoleBinding)->window->listp,List)->size > 0)
         return 1;
      else
        return 0;  /* fail */
      }
   else
      return 0;  /* fail */
}

int checkOpenConsole(FILE *w, char *s)
{
   int i;
   if ((w != ConsoleBinding) && (
       ((w==k_input.fd.fp )&&(!(ConsoleFlags & StdInRedirect)))||
       ((w==k_output.fd.fp)&&(!(ConsoleFlags & StdOutRedirect)))||
       ((w==k_errout.fd.fp)&&(!(ConsoleFlags & StdErrRedirect)))
      )){
	 w = OpenConsole();
       if (s){
       	  register word l;
	  l=strlen(s);
          for(i=0;i<l;i++) Consoleputc(s[i], w);
	  }
       return 1;
       }
   return 0;
}

/*
 * OpenConsole
 */
FILE *OpenConsole()
   {
   struct descrip attrs[4];
   int eindx;

   if (!ConsoleBinding) {
      char ConsoleTitle[256];
      struct b_list *hp;
#if defined(Concurrent) && !defined(HAVE_KEYWORD__THREAD)
       struct threadstate *curtstate;
#endif					/* Concurrent && !HAVE_KEYWORD__THREAD */

      /*
       * If we haven't already allocated regions, we are called due to a
       *  failure during program startup; allocate enough memory to
       *  get the message out.
       */

#ifdef MultiProgram
      if (!curpstate) {
         curpstate = &rootpstate;
         rootpstate.eventmask = nulldesc;
         }
      if (!alclist) curpstate->Alclist = alclist_0;
      if (!reserve) curpstate->Reserve = reserve_0;
#endif						/* MultiProgram */


      if (!curblock) {
         curstring = (struct region *)malloc(sizeof (struct region));
         curblock = (struct region *)malloc(sizeof (struct region));
         curstring->size = MaxStrSpace;
         curblock->size  = MaxAbrSize;
#if defined(Concurrent) && !defined(HAVE_KEYWORD__THREAD)
   	 curtstate = &roottstate;
#if !ConcurrentCOMPILER
	 curpstate->tstate = curtstate;
   	 rootpstate.tstate = curtstate;
#endif                                   /* ConcurrentCOMPILER */

   	 init_threadstate(curtstate);
   	 pthread_key_create(&tstate_key, NULL);
   	 pthread_setspecific(tstate_key, (void *) curtstate);
         curtstate->Curstring = curstring;
         curtstate->Curblock = curblock;
      	 curtstate->c = (struct b_coexpr *) malloc((msize) 1000);
#endif					/* Concurrent && !HAVE_KEYWORD__THREAD */

#if COMPILER
	 initalloc();
#else					/* COMPILER */
#ifdef MultiProgram
         initalloc(1000, &rootpstate);
#else					/* MultiProgram */
         initalloc(1000);
#endif					/* MultiProgram */
#endif					/* COMPILER */

#ifdef Concurrent

      	 curtblock = curblock;
	 curtstring = curstring;
#endif					/*Concurrent*/
         }


      /*
       * build the attribute list
       */
      AsgnCStr(attrs[0], "cursor=on");
      AsgnCStr(attrs[1], "rows=24");
      AsgnCStr(attrs[2], "columns=80");
      /*
       * enable this last argument (by telling wopen it has 4 args)
       * if you want white text on black bg
       */
      AsgnCStr(attrs[3], "reverse=on");

      strncpy(ConsoleTitle, StrLoc(kywd_prog), StrLen(kywd_prog));
      ConsoleTitle[StrLen(kywd_prog)] = '\0';
      strcat(ConsoleTitle, " - console");

      /*
       * allocate an empty event queue
       */
      if ((hp = alclist(0, MinListSlots)) == NULL) return NULL;

      ConsoleBinding = wopen(ConsoleTitle, hp, attrs, 3, &eindx,0,0);
      if ( !(ConsoleFlags & StdInRedirect ))
         k_input.fd.fp = ConsoleBinding;
      if ( !(ConsoleFlags & StdOutRedirect ))
         k_output.fd.fp = ConsoleBinding;
      if ( !(ConsoleFlags & StdErrRedirect ))
         k_errout.fd.fp = ConsoleBinding;
#ifdef ScrollingConsoleWin
{
      wsp ws = ((wbp)ConsoleBinding)->window;
      SUSPEND_THREADS();
      ws->nChildren++;
      ws->child = realloc(ws->child, ws->nChildren * sizeof(childcontrol));
      makeeditregion(ConsoleBinding, ws->child + (ws->nChildren-1), "");
      movechild(ws->child + (ws->nChildren-1), 0, 0, ws->width, ws->height);
      RESUME_THREADS();
}
#endif					/* ScrollingConsoleWin */
      }
   return ConsoleBinding;
   }

/*
 * Consolefprintf - fprintf to the Icon console
 */
int Consolefprintf(FILE *file, const char *format, ...)
   {
   va_list list;
   int retval = -1;
   wbp console;

   va_start(list, format);

   if (ConsoleFlags & OutputToBuf) {
     retval = vsprintf(ConsoleStringBufPtr, format, list);
     ConsoleStringBufPtr += max(retval, 0);
     }
   else if (((file == stdout) && !(ConsoleFlags & StdOutRedirect)) ||
       ((file == stderr) && !(ConsoleFlags & StdErrRedirect))) {
      console = (wbp)OpenConsole();
      if (console == NULL) return 0;
      if ((retval = vsprintf(ConsoleStringBuf, format, list)) > 0) {
        int len = strlen(ConsoleStringBuf);
        if (flog != NULL) {
           int i;
	   for(i=0;i<len;i++) fputc(ConsoleStringBuf[i], flog);
	   }
        wputstr(console, ConsoleStringBuf, len);
	}
      }
   else
      retval = vfprintf(file, format, list);
   va_end(list);
   return retval;
   }

int Consoleprintf(const char *format, ...)
   {
   va_list list;
   int retval = -1;
   wbp console;
   FILE *file = stdout;

   va_start(list, format);

   if (ConsoleFlags & OutputToBuf) {
     retval = vsprintf(ConsoleStringBufPtr, format, list);
     ConsoleStringBufPtr += max(retval, 0);
     }
   else if (!(ConsoleFlags & StdOutRedirect)) {
      console = (wbp)OpenConsole();
      if (console == NULL) return 0;
      if ((retval = vsprintf(ConsoleStringBuf, format, list)) > 0) {
        int len = strlen(ConsoleStringBuf);
        if (flog != NULL) {
           int i;
	   for(i=0;i<len;i++) fputc(ConsoleStringBuf[i], flog);
	   }
        wputstr(console, ConsoleStringBuf, len);
	}
      }
   else
      retval = vfprintf(file, format, list);
   va_end(list);
   return retval;
   }

/*
 * Consoleputc -
 *   If output is to stdio and not redirected, open a console for it.
 */
int Consoleputc(int c, FILE *f)
   {
   wbp console;
   if (ConsoleFlags & OutputToBuf) {
      *ConsoleStringBufPtr++ = c;
      *ConsoleStringBufPtr = '\0';
      return 1;
      }
   if ((f == stdout && !(ConsoleFlags & StdOutRedirect)) ||
       (f == stderr && !(ConsoleFlags & StdErrRedirect))) {
      if (flog) fputc(c, flog);
      console = (wbp)OpenConsole();
      if (console == NULL) return 0;
      return wputc(c, console);
      }
   return fputc(c, f);
   }


#undef fflush

int Consolefflush(FILE *f)
{
   wbp console;
   extern int fflush(FILE *);
   if ((f == stdout && !(ConsoleFlags & StdOutRedirect)) ||
       (f == stderr && !(ConsoleFlags & StdErrRedirect))) {
      if (flog) fflush(flog);
      console = (wbp)OpenConsole();
      if (console == NULL) return 0;
#ifndef MSWindows
      wflush(console);
#endif					/* MSWindows */
      return 0;
      }
  return fflush(f);
}

/*
 * This version of wattrib() is only used for dconsole.c, when building
 * ConsoleWindow versions of compilers, e.g. wicont, wrtt.
 */
void wattr(FILE *w, char *s, int len)
{
   struct descrip answer;
   wattrib((wbp)w, s, len, &answer, s);
}

#else					/* ConsoleWindow */

/*
 * If we don't have graphics facilities (e.g. we are nticonx), let's define
 * Consolefprintf and friends anyhow, so that we can define the printf macros
 * everywhere and not have to recompile to switch.
 */
#undef fprintf
#undef printf
#undef putc
#undef fflush

int checkOpenConsole( FILE *w, char *s)
{
   return 0;
}

/*
 * Consolefprintf - fprintf to the Icon console
 */
int Consolefprintf(FILE *file, const char *format, ...)
   {
   va_list list;
   int retval = -1;
   va_start(list, format);
   retval = vfprintf(file, format, list);
   va_end(list);
   return retval;
   }

int Consoleprintf(const char *format, ...)
   {
   va_list list;
   int retval = -1;
   va_start(list, format);
   retval = vfprintf(stdout, format, list);
   va_end(list);
   return retval;
   }

int Consoleputc(int c, FILE *f)
   {
   return fputc(c, f);
   }

int Consolefflush(FILE *f)
{
   extern int fflush(FILE *);
   return fflush(f);
}

#endif					/* ConsoleWindow */
