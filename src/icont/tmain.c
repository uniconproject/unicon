/*
 * tmain.c - main program for translator and linker.
 */

#include "../h/gsupport.h"
#include "../h/version.h"
#include "tproto.h"
#include "tglobals.h"

#if MACINTOSH
   #if THINK_C
      #include "console.h"
      #include "config.h"
      #include "cpuconf.h"
      #include "macgraph.h"
      #include <AppleEvents.h>
      #include <GestaltEqu.h>
      /* #include <Values.h> */

      #define MAXLONG  (0x7fffffff)
      
      /* #define kSleep MAXLONG */
      #define kGestaltMask 1L

      /* Global */
      Boolean gDone;
      Boolean g_cOption;
   #endif    /* THINK_C */
#endif    /* MACINTOSH */

#if NT
   extern FILE *pathOpen(char *, char *);
#endif

#ifdef MSWindows

#ifdef Concurrent
int is_concurrent; 
#endif					/* Concurrent */

   #ifdef NTConsole
      #define int_PASCAL int PASCAL
      #define LRESULT_CALLBACK LRESULT CALLBACK
      #include <windows.h>
      #include "../h/filepat.h"
   #endif				/* NTConsole */
#endif					/* MSWindows */

#if WildCards
   #ifndef ConsoleWindow
/*      #include "../h/filepat.h" */
   #endif				/* ConsoleWindow */
#endif					/* WildCards */

/*
 * Prototypes.
 */

static	void	execute	(char *ofile,char *efile,char * *args);
static	void	usage (void);
char *libpath (char *prog, char *envname);

#if AMIGA && __SASC
   extern void PostClip(char *file, int line, int number, char *text);
   extern void CallARexx(char *script);
#endif					/* AMIGA && __SASC */

#if MACINTOSH
   #if THINK_C
      pascal void  MaxApplZone ( void );
      void         IncreaseStackSize ( Size extraBytes );
      
      void         ToolBoxInit ( void );
      void         EventInit ( void );
      void         EventLoop ( void );
      void         DoEvent ( EventRecord *eventPtr );
      pascal OSErr DoOpenDoc ( AppleEvent theAppleEvent,
                         AppleEvent reply,
                               long refCon );
      pascal OSErr DoQuitApp ( AppleEvent theAppleEvent,
                         AppleEvent reply,
                               long refCon );
      OSErr        GotRequiredParams ( AppleEvent *appleEventPtr );
      void      MacMain ( int argc, char **argv );

      void DoMouseDown (EventRecord *eventPtr);
      void HandleMenuChoice (long menuChoice);
      void HandleAppleChoice (short item);
      void HandleFileChoice (short item);
      void HandleOptionsChoice (short item);
      void MenuBarInit (void);
   #endif					/* THINK_C */
#endif					/* MACINTOSH */

/*
 * The following code is operating-system dependent [@tmain.01].  Include
 *  files and such.
 */

#if PORT
   Deliberate syntax error
#endif					/* PORT */

#if AMIGA
   #if __SASC
      #include <dos.h>
      #include <libraries/dos.h>
      #include <proto/dos.h>
      #include <proto/asl.h>
      extern int _WBargc;
      extern char **_WBargv;
      char __stdiowin[] = "CON:10/40/640/200/IconT Console Window";
      char OptTemplate[] = "NoLink/S,StrInv/S,Silent/S,Trace/S,UWarn/S,Output/K,Verbosity/K";
      enum {opt_nolink,opt_strinv,opt_silent,opt_trace,opt_uwarn,opt_output,opt_verbosity,numopts}; 
   #else				/* __SASC */
      #include <libraries/dosextens.h>
   #endif				/* __SASC */
#endif					/* AMIGA */

#if ARM || MVS || UNIX || VM || VMS
   /* nothing is needed */
#endif					/* ARM || ... */

#if MSDOS
   char pathToIconDOS[129];
#endif					/* MSDOS */

#if ATARI_ST
   char *patharg;
#endif					/* ATARI_ST */

#if MACINTOSH
   #if MPW
      #include <CursorCtl.h>
      void SortOptions();
   #endif				/* MPW */
#endif					/* MACINTOSH */

#if OS2
   #include <process.h>
#endif					/* OS2 */
/*
 * End of operating-system specific code.
 */

#if IntBits == 16
   #ifdef strlen
   #undef strlen			/* pre-defined in some contexts */
   #endif				/* strlen */
#endif					/* Intbits == 16 */

/*
 *  Define global variables.
 */

char *pofile = NULL;			/* piped input file name */
int bundleiconx = 0;

char patchpath[MaxPath+18] = "%PatchStringHere->";

/*
 * getopt() variables
 */
extern int optind;		/* index into parent argv vector */
extern int optopt;		/* character checked for validity */
extern char *optarg;		/* argument associated with option */

#ifdef ConsoleWindow
   int ConsolePause = 1;
#endif					/* ConsoleWindow */



#if MACINTOSH
#if THINK_C
void main ( void )
{
/* Increase stack size if neccessary  */

/*
   Size extraBytes=32*1024;
   IncreaseStackSize (extraBytes);
 */

   MaxApplZone();

   ToolBoxInit ();
   EventInit ();
   MenuBarInit();

   EventLoop ();
}                    /* end of main () */
#endif               /* THINK_C */
#endif               /* MACINTOSH */


#if NT || defined(ConsoleWindow)
/*
 * expand Icon project (.icp) files
 */
void expand_proj(int *argc, char ***argv)
{
   int ac = *argc, i, j, k;
   char **av = *argv, buf[1024];
   FILE *f;
   for (i=1; i<ac; i++) {
      if (strstr(av[i], ".ICP") || strstr(av[i], ".icp")) break;
      }
   if (i == ac) return;
   if ((f = fopen(av[i], "r")) == NULL) {
      fprintf(stderr, "%s: can't open %s\n", progname, av[i]);
      fflush(stderr);
      return;
      }
   if ((*argv = malloc(ac * sizeof (char *))) == NULL) {
      fprintf(stderr, "%s: can't malloc for %s\n", progname, av[i]);
      fflush(stderr);
      return;
      }
   for(j=0; j<i; j++) (*argv)[j] = av[j];
   k = j++;
   if(fgets(buf, 1023, f) != NULL) {
      if (strchr(buf, '\n') != NULL)
         buf[strlen(buf)-1] = '\0';
      (*argv)[k++] = salloc(buf);
      while(fgets(buf, 1023, f) != NULL) {
         if (strchr(buf, '\n') != NULL)
            buf[strlen(buf)-1] = '\0';
         (*argc)++;
         if ((*argv = realloc(*argv, *argc * sizeof (char *))) == NULL) {
            fprintf(stderr, "%s: can't malloc for %s\n", progname, av[i]);
            fflush(stderr);
            return;
            }
         (*argv)[k++] = salloc(buf);
         }
      }
   fclose(f);
   for( ; j < ac; j++, k++) (*argv)[k] = av[j];
}
#endif					/* NT || ConsoleWindow */

#ifndef NTConsole
#ifdef MSWindows
int icont(int argc, char **argv);
#define int_PASCAL int PASCAL
#define LRESULT_CALLBACK LRESULT CALLBACK
#undef lstrlen
#include <windows.h>
#define lstrlen longstrlen

int CmdParamToArgv(char *s, char ***avp, int dequote)
   {
   char tmp[MaxPath], dir[MaxPath];
   char *t, *t2;
   int rv=0, i;
   FILE *f;
   t = salloc(s);
   t2 = t;
   *avp = malloc(2 * sizeof(char *));
   (*avp)[rv] = NULL;

   while (*t2) {
      while (*t2 && isspace(*t2)) t2++;
      switch (*t2) {
	 case '\0': break;
	 case '"': {
	    char *t3 = ++t2;			/* skip " */
            while (*t2 && (*t2 != '"')) t2++;
            if (*t2)
	       *t2++ = '\0';
	    *avp = realloc(*avp, (rv + 2) * sizeof (char *));
	    (*avp)[rv++] = salloc(t3);
            (*avp)[rv] = NULL;
	    break;
	    }
         default: {
            FINDDATA_T fd;
	    char *t3 = t2;
            while (*t2 && !isspace(*t2)) t2++;
	    if (*t2)
	       *t2++ = '\0';
            strcpy(tmp, t3);
	    if (!FINDFIRST(tmp, &fd)) {
	       *avp = realloc(*avp, (rv + 2) * sizeof (char *));
	       (*avp)[rv++] = salloc(t3);
               (*avp)[rv] = NULL;
               }
	    else {
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
            break;
	    }
         }
      }
   free(t);
   return rv;
   }


LRESULT_CALLBACK WndProc	(HWND, UINT, WPARAM, LPARAM);

#if 0
void MSStartup(int argc, char **argv, HINSTANCE hInstance, HINSTANCE hPrevInstance)
   {
   WNDCLASS wc;

   if (!hPrevInstance) {
#if NT
      wc.style = CS_HREDRAW | CS_VREDRAW;
#else					/* NT */
      wc.style = 0;
#endif					/* NT */
#ifdef NTConsole
      wc.lpfnWndProc = DefWindowProc;
#else					/* NTConsole */
      wc.lpfnWndProc = WndProc;
#endif					/* NTConsole */
      wc.cbClsExtra = 0;
      wc.cbWndExtra = 0;
      wc.hInstance  = hInstance;
      wc.hIcon      = NULL;
      wc.hCursor    = LoadCursor(NULL, IDC_ARROW);
      wc.hbrBackground = GetStockObject(WHITE_BRUSH);
      wc.lpszMenuName = NULL;
      wc.lpszClassName = "iconx";
      RegisterClass(&wc);
      }
   }

#endif

HINSTANCE mswinInstance;
int ncmdShow;

jmp_buf mark_sj;

#if 0
int_PASCAL WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
                   LPSTR lpszCmdParam, int nCmdShow)
   {
   int argc;
   char **argv;

   mswinInstance = hInstance;
   ncmdShow = nCmdShow;
   argc = CmdParamToArgv(GetCommandLine(), &argv, 0);
   MSStartup(argc, argv, hInstance, hPrevInstance);
   if (setjmp(mark_sj) == 0)
      icont(argc,argv);
   while (--argc>=0)
      free(argv[argc]);
   free(argv);
   wfreersc();
   return 0;
}
#else
void iconx(int argc, char** argv){
  icont(argc, argv);
}
#endif

#define main icont
#endif					/* MSWindows */
#endif					/* NTConsole */


/*
 *  main program
 */

#if !THINK_C
   int main(int argc, char **argv)
#else                           /* THINK_C */
   void MacMain(int argc, char **argv)
#endif                          /* !THINKC_C */
   {
   int nolink = 0;			/* suppress linking? */
   int errors = 0;			/* translator and linker errors */
   char **tfiles, **tptr;		/* list of files to translate */
   char **lfiles, **lptr;		/* list of files to link */
   char **rfiles, **rptr;		/* list of files to remove */
   char *efile = NULL;			/* stderr file */
   char buf[MaxFileName];		/* file name construction buffer */
   int c, n;
   char ch;
   struct fileparts *fp;

#if WildCards
   FINDDATA_T fd;
   int j;
#endif					/* WildCards */

#if SCCX_MX
    syntax error!
    The Symantec license agreement requires you to include a copyright
    notice in your program.  This is a good place for it.
   fprintf( stderr,
    "Copyright (c) 1995, Your Name, Your City, Your State.\n");
#endif					/* SSCX_MX */

#if AMIGA
#if AZTEC_C
   struct Process *FindTask();
   struct Process *Process = FindTask(0L);
   ULONG stacksize = *((ULONG *)Process->pr_ReturnAddr);

   if (stacksize < ICONTMINSTACK) {
      fprintf(stderr,"Icont needs \"stack %d\" to run\n",ICONTMINSTACK);
      exit(-1);
      }
#endif					/* AZTEC_C */
#if __SASC
   if ( argc == 0 ) {    /* We were started from the WorkBench. */
      struct FileRequester *fr;
      int  n, Rargc = 0;
      char *pattern, **Rargv;
      struct WBArg *wba;
      struct RDArgs *rda;
      long *options;

   /* Get options from the IcontOptions environment variable. */ 
      rda = (struct RDArgs *)alloc(sizeof(struct RDArgs));
      options = (long *)alloc(numopts*sizeof(long));
      if (rda->RDA_Source.CS_Buffer = getenv("IcontOptions") ) {
         rda->RDA_Source.CS_Length = strlen(rda->RDA_Source.CS_Buffer);
         ReadArgs(OptTemplate, options, rda);
         FreeArgs(rda);

         if (options[opt_nolink]   ) nolink = 1; 
         if (options[opt_strinv]   ) strinv = 1;
         if (options[opt_silent]   ) {silent = 1; verbose = 0;}
         if (options[opt_trace]    ) trace = -1;
         if (options[opt_uwarn]    ) uwarn = 1  ;
         if (options[opt_output]   ) ofile = salloc((char *)options[opt_output]) ;
         if (options[opt_verbosity]) {
            if (sscanf( (char *)options[opt_verbosity], "%d%c", &verbose, &ch) != 1)
               quitf("bad operand to -v option: %s",optarg);
            if (verbose == 0)
               silent = 1;
            }
         }
   
   /* Get file arguments from the WorkBench startup message. */
      sprintf(buf, "#?%s", SourceSuffix);
      pattern = salloc(buf);
      fr = (struct FileRequester *)AllocAslRequestTags(ASL_FileRequest,
           ASL_Hail,     "Select Icon source files",
           ASL_Pattern,  (ULONG)pattern,
           ASL_FuncFlags, FILF_MULTISELECT | FILF_PATGAD,
           ASL_Dir,      "Icon:",
           TAG_DONE);
   
      if ( fr != NULL) {
         if (_WBargc == 1 ) {  /* No input files were specified */
            if ( AslRequest(fr, NULL) ) {
               Rargv = (char **)alloc((fr->fr_NumArgs + 2)*sizeof(char *));
               Rargv[0] = _WBargv[0];
               Rargc = 1;
               wba = fr->fr_ArgList;
               for(n = 0; n < fr->fr_NumArgs; n++, wba++){
                  if (wba->wa_Name != NULL &&
                     NameFromLock(wba->wa_Lock, buf, sizeof(buf)) != 0) {
                     AddPart(buf, wba->wa_Name, sizeof(buf));
                     Rargv[Rargc] = salloc(buf);
                     Rargc++;
                     }
                  }
               Rargv[Rargc] = NULL;
               }
            }
   
         /* Initialize argv and argc */
         if ( Rargc > 1 ) {
            argc = Rargc;
            argv = Rargv;
            }
         else {
            argc = _WBargc;
            argv = _WBargv;
            }
   
         /* The Workbench args come in random order.  So if we have
            more than one ask for the name of the output file. */
         if (ofile == NULL && nolink == 0 && argc > 2) {
            strcpy(buf, argv[1]);
            *PathPart(buf) = '\0';
            if ( AslRequestTags(fr,
                  ASL_Hail,      "Specify output (icode) file",
                  ASL_Pattern,   NULL,
                  ASL_FuncFlags, FILF_SAVE,
                  ASL_Dir,       buf,
                  ASL_File,      NULL,
                  TAG_DONE) ) {
               SetCurrentDirName(fr->fr_Drawer);
               ofile = salloc(fr->fr_File);
               }
            }
         FreeAslRequest(fr);
         }
      }
#endif					/* __SASC */
#endif					/* AMIGA */


#if MACINTOSH
#if MPW
   InitCursorCtl(NULL);
   SortOptions(argv);
#endif					/* MPW */
#endif					/* MACINTOSH */

   if ((int)strlen(patchpath) > 18)
      iconxloc = patchpath+18;	/* use stated iconx path if patched */
   else
      iconxloc = relfile(argv[0],
#if defined(MSVC) && defined(MSWindows)
			 "/../wiconx"
#else					/* MSWindows */
			 "/../iconx"
#endif					/* MSVC && MSWindows */
			 );

#ifdef ConsoleWindow
   expand_proj(&argc, &argv);
#endif					/* ConsoleWindow */

   /*
    * Process options. NOTE: Keep Usage definition in sync with getopt() call.
    */
   #define Usage "[-cBstuEG] [-f s] [-l logfile] [-o ofile] [-v i]"	/* omit -e from doc */
   while ((c = getopt(argc,argv, "cBe:f:l:o:O:stuGv:ELZ")) != EOF)
      switch (c) {
	 case 'B':
	    bundleiconx = 1;
            break;
         case 'C':			/* Ignore: compiler only */
            break;
         case 'E':			/* -E: preprocess only */
	    pponly = 1;
	    nolink = 1;
            break;

         case 'L':			/* -L: enable linker debugging */

#ifdef DeBugLinker
            Dflag = 1;
#endif					/* DeBugLinker */

            break;

	 case 'G':			/* -G: enable graphics */
	    Gflag = 1;
	    break;

         case 'S':			/* -S */
            fprintf(stderr, "Warning, -S option is obsolete\n");
            break;

#if MSDOS
         case 'X':			/* -X */
#if ZTC_386
            fprintf(stderr, "Warning: -X option is not available\n");
#else					/* ZTC_386 */
            makeExe = 1;
#endif					/* ZTC_386 */
            break;
         case 'I':			/* -C */
            makeExe = 0;
            break;
#ifdef SCCX_MX
         case 'A':
            makeExe = 2;
            break;
#endif                  /* SCCX_MX */
#endif					/* MSDOS */

         case 'V':
	    printf("%s\n", Version);
	    exit(0);
	    break;
         case 'c':			/* -c: compile only (no linking) */
            nolink = 1;
            break;
	 case 'l':
	    openlog(optarg);
	    break;
         case 'e':			/* -e file: redirect stderr */
            efile = optarg;
            break;
         case 'f':			/* -f features: enable features */
            if (strchr(optarg, 's') || strchr(optarg, 'a'))
               strinv = 1;		/* this is the only icont feature */
            break;

#if OS2
	 case 'i':                      /* -i: Don't create .EXE file */
	    noexe = 1;
	    break;
#endif					/* OS2 */

         case 'm':			/* -m: preprocess using m4(1) [UNIX] */
            m4pre = 1;
            break;

         case 'n':			/* Ignore: compiler only */
            break;

         case 'o':			/* -o file: name output file */
            ofile = optarg;
            break;

         case 'O':			/* -O file: name input file */
            pofile = optarg;
            break;

         case 'p':			/* -p path: iconx path [ATARI] */

#if ATARI_ST
            patharg = optarg;
#endif					/* ATARI_ST */

            break;

#ifdef ConsoleWindow
	 case 'q':
 	    ConsolePause = 0;
	    break;
#endif					/* ConsoleWindow */
         case 'r':			/* Ignore: compiler only */
            break;
         case 's':			/* -s: suppress informative messages */
            silent = 1;
            verbose = 0;
            break;
         case 't':			/* -t: turn on procedure tracing */
            trace = -1;
            break;
         case 'u':			/* -u: warn about undeclared ids */
            uwarn = 1;
            break;
         case 'v':			/* -v n: set verbosity level */
            if (sscanf(optarg, "%d%c", &verbose, &ch) != 1)
               quitf("bad operand to -v option: %s",optarg);
            if (verbose == 0)
               silent = 1;
            break;
         case 'Z':
	    /* add flag to say "don't compress". noop unless HAVE_LIBZ */
	    Zflag = 0;
	    break;

         default:
         case 'x':			/* -x illegal until after file list */
            usage();
         }

#if MSDOS && !NT
      /*
       * Define pathToIconDOS as a global accessible from inside
       * separately-compiled compilation units.
       */
      if( makeExe ){
         char *pathCursor;

         strcpy (pathToIconDOS, argv[0]);
         pathCursor = (char *)strrchr (pathToIconDOS, '\\');
         if (!pathCursor) {
            fprintf (stderr,
               "Can't understand what directory icont was run from.\n");
            exit(EXIT_FAILURE);
            }
            strcpy( ++pathCursor, (makeExe==1) ?  "ixhdr.exe" : "iconx.exe");
         }
#endif                                  /* MSDOS && !NT */

   /*
    * Allocate space for lists of file names.
    */
   n = argc - optind + 1;

#if WildCards
   {
   for(j=optind; j < argc; j++) {
      if (FINDFIRST(argv[j], &fd))
         while(FINDNEXT(&fd)) n++;
      FINDCLOSE(&fd);
      }
   }
#endif					/* WildCards */

   tptr = tfiles = (char **)alloc((unsigned int)(n * sizeof(char *)));
   lptr = lfiles = (char **)alloc((unsigned int)(n * sizeof(char *)));
   rptr = rfiles = (char **)alloc((unsigned int)(2 * n * sizeof(char *)));

   /*
    * Scan file name arguments.
    */
   while (optind < argc)  {
      if (strcmp(argv[optind],"-x") == 0)	/* stop at -x */
         break;
      else if (strcmp(argv[optind],"-") == 0) {

	 if (pofile != NULL) {
	    *tptr++ = "-";
	    fp = fparse(pofile);
	    makename(buf, TargetDir, pofile, USuffix);
	    *lptr++ = *rptr++ = salloc(buf);
	    }
	 else {
#if ARM
	/* Different file naming, so we need a different strategy... */
	*tptr++ = "-";
	/* Use makename(), pretending we had an input file named "Stdin" */
	makename(buf,TargetDir,"Stdin",U1Suffix);
	*lptr++ = *rptr++ = salloc(buf);	/* link & remove .u1 */
	makename(buf,TargetDir,"Stdin",U2Suffix);
	*rptr++ = salloc(buf);		/* also remove .u2 */
#else					/* ARM */
         *tptr++ = "-";				/* "-" means standard input */
         *lptr++ = *rptr++ = "stdin.u";
#endif					/* ARM */
	}
         }
      else if (pofile != NULL) {
	    fp = fparse(pofile);
            if (*fp->ext == '\0' || smatch(fp->ext, SourceSuffix)) {
               makename(buf,SourceDir,argv[optind], "");
               *tptr++ = salloc(buf);		/* translate the .icn file */
	    }
	    makename(buf, TargetDir, pofile, USuffix);
	    *lptr++ = *rptr++ = salloc(buf);
         }
      else {
#if WildCards
	 char tmp[MaxPath], dir[MaxPath];
         int matches = 0;

	 fp = fparse(argv[optind]);
	 /* Save because *fp will get overwritten frequently */
	 strcpy(dir, fp->dir);
	 if (*fp->ext == '\0')
	    makename(tmp,NULL,argv[optind], SourceSuffix);
	 else
	    strcpy(tmp, argv[optind]);

	 if (strchr(tmp, '*') || strchr(tmp, '?')) {
	    if (!FINDFIRST(tmp, &fd)) {
	       fprintf(stderr, "File %s: no match\n", tmp);
	       fflush(stderr);
	       }
	    else matches = 1;
	    }
         do {
	 if (matches) {
	    makename(tmp,dir,FILENAME(&fd),NULL);
	    argv[optind] = tmp;
	    }
#endif					/* WildCards */
         fp = fparse(argv[optind]);		/* parse file name */
         if (*fp->ext == '\0' || smatch(fp->ext, SourceSuffix)) {
            makename(buf,SourceDir,argv[optind], SourceSuffix);
#if VMS
	    strcat(buf, fp->version);
#endif					/* VMS */
            *tptr++ = salloc(buf);		/* translate the .icn file */
            makename(buf,TargetDir,argv[optind],USuffix);
            *lptr++ = *rptr++ = salloc(buf);	/* link & remove .u */
            }
         else if (smatch(fp->ext,U1Suffix) || smatch(fp->ext,U2Suffix)
               || smatch(fp->ext,USuffix)) {
            makename(buf,(*TargetDir?TargetDir:NULL),argv[optind],U1Suffix);
            *lptr++ = salloc(buf);
            }
         else
            quitf("bad argument %s",argv[optind]);
#if WildCards
	 if (!matches)
	    break;
         } while (FINDNEXT(&fd));
	 if (matches)
	 FINDCLOSE(&fd);
#endif					/* WildCards */
         }
      optind++;
      }

   *tptr = *lptr = *rptr = NULL;	/* terminate filename lists */

   if (lptr == lfiles)
      usage();				/* error -- no files named */

   /*
    * Initialize globals.
    */
   initglob();				/* general global initialization */

   ipath = libpath(argv[0], "IPATH");	/* set library search paths */
   lpath = libpath(argv[0], "LPATH");

   /*
    * Translate .icn files to make .u files.
    */
   if (tptr > tfiles) {
      if (!pponly)
         report("Translating");
      errors = trans(tfiles);
      if (errors > 0) {			/* exit if errors seen */
#if AMIGA && __SASC
         PostClip("END", 0, 0, "END");
         CallARexx(IcontRexx);
#endif					/* AMIGA && __SASC */
         exit(EXIT_FAILURE);
	 }
      }

   /*
    * Link .u files to make an executable.
    */
   if (nolink) {			/* exit if no linking wanted */

#if MACINTOSH
#if MPW
      /*
       *  Set type of translator output ucode (.u) files
       *  to 'TEXT', so they can be easily viewed by editors.
       */
      {
      char **p;
      void setfile();
      for (p = rfiles; *p; ++p)
         setfile(*p,'TEXT','UCOD');
      }
#endif					/* MPW */
#endif					/* MACINTOSH */

#if AMIGA && __SASC
      if ( !silent && _WBenchMsg != NULL ) fprintf(stderr,"Done.\n");
#endif				/* AMIGA && __SASC */

      exit(EXIT_SUCCESS);
      }

#if MSDOS
   {
   if (ofile == NULL)  {                /* if no -o file, synthesize a name */
      ofile = salloc(makename(buf,TargetDir,lfiles[0],
                              makeExe ? ".exe" : IcodeSuffix));
      }
   else {                             /* add extension if necessary */
      fp = fparse(ofile);
      if (*fp->ext == '\0' && *IcodeSuffix != '\0') /* if no ext given */
         ofile = salloc(makename(buf,NULL,ofile,
                                 makeExe ? ".exe" : IcodeSuffix));
      }
   }
#else                                   /* MSDOS */

   if (ofile == NULL)  {		/* if no -o file, synthesize a name */
      ofile = salloc(makename(buf,TargetDir,lfiles[0],IcodeSuffix));
   } else {				/* add extension in necessary */
      fp = fparse(ofile);
      if (*fp->ext == '\0' && *IcodeSuffix != '\0') /* if no ext given */
         ofile = salloc(makename(buf,NULL,ofile,IcodeSuffix));
   }

#endif					/* MSDOS */

   report("Linking");
   errors = ilink(lfiles,ofile);	/* link .u files to make icode file */

#if HAVE_LIBZ
   /*
    * we have linked together a bunch of files to make an icode,
    * now call file_comp() to compress it
    */
   if (Zflag) {
#if NT
#define stat _stat
#endif					/* NT */
      struct stat buf;
      int i = stat(ofile, &buf);
      if (i==0 && buf.st_size > 1000000 && file_comp(ofile)) {
	 report("error during icode compression\n");
	 }
      }
#endif					/* HAVE_LIBZ */

#if NT
   if (!bundleiconx)
      bundleiconx = !stricmp(".exe", ofile+strlen(ofile)-4);
#endif

   /*
    * prepend iconx if we generated an executable and specified to bundle
    */
   if (!errors && bundleiconx) {
      FILE *f, *f2;
      char tmp[MaxPath], *iconx, mesg[80];
      strcpy(tmp, ofile);
      strcpy(tmp+strlen(tmp)-4, ".bat");
      rename(ofile, tmp);

#if UNIX
      iconx = "iconx";
#endif
#if NT
      if (Gflag) iconx="wiconx.exe";
      else
         iconx = "iconx.exe";
#endif					/* NT */
      if ((f = pathOpen(iconx, ReadBinary)) == NULL) {
	 sprintf(mesg,"Tried to read %s to build .exe, but couldn't\n",iconx);
	 report(mesg);
	 errors++;
	 }
      else {
	 if ((f2 = fopen(ofile, WriteBinary)) == NULL) {
	    sprintf(mesg,"Could not write to %s to build .exe\n",
		    ofile);
	    report(mesg);
	    }
	 else {
	    while ((c = fgetc(f)) != EOF) {
	       fputc(c, f2);
	       }
	    fclose(f);
	    if ((f = fopen(tmp, ReadBinary)) == NULL) {
	       sprintf(mesg,"Could not read %s in order to append to .exe\n",
		       tmp);
	       report(mesg);
	       errors++;
	       }
	    else {
	       while ((c = fgetc(f)) != EOF) {
		  fputc(c, f2);
		  }
	       fclose(f);
	       }
	    fclose(f2);
	    setexe(ofile);
	    unlink(tmp);
	    }
	 }
	 }

   /*
    * Finish by removing intermediate files.
    *  Execute the linked program if so requested and if there were no errors.
    */

#if MACINTOSH
#if MPW
   /* Set file type to TEXT so it will be executable as a script. */
   setfile(ofile,'TEXT','ICOD');
#endif					/* MPW */
#endif					/* MACINTOSH */

   for (rptr = rfiles; *rptr; rptr++)	/* delete intermediate files */
      remove(*rptr);
   if (errors > 0) {			/* exit if linker errors seen */
      char errbuf[32];
      remove(ofile);
      sprintf(errbuf, "%d errors\n", errors);
      report(errbuf);
      if (flog)
	 closelog();
      exit(EXIT_FAILURE);
      }
#ifdef ConsoleWindow
   else
      report("No errors\n");
#endif					/* ConsoleWindow */

#if !(MACINTOSH && MPW)
   if (optind < argc)  {
      report("Executing");
      execute (ofile, efile, argv+optind+1);
      }
#endif					/* !(MACINTOSH && MPW) */

#if AMIGA && __SASC
   if (!silent && _WBenchMsg != NULL) fprintf(stderr, "Done.\n");
#endif				/* AMIGA && __SASC */

   free(tfiles);
   free(lfiles);
   free(rfiles);

   closelog();

   exit(EXIT_SUCCESS);
   }

/*
 * execute - execute iconx to run the icon program
 */
static void execute(ofile,efile,args)
char *ofile, *efile, **args;
   {

#if !(MACINTOSH && MPW)
   int n;
   char **argv, **p;

   for (n = 0; args[n] != NULL; n++)	/* count arguments */
      ;
   p = argv = (char **)alloc((unsigned int)((n + 5) * sizeof(char *)));

#if !UNIX	/* exec the file, not iconx; stderr already redirected  */
   *p++ = iconxloc;			/* set iconx pathname */
   if (efile != NULL) {			/* if -e given, copy it */
      *p++ = "-e";
      *p++ = efile;
      }
#endif					/* UNIX */

   *p++ = ofile;			/* pass icode file name */

#if AMIGA && LATTICE
   *p = *args;
   while (*p++) {
      *p = *args;
      args++;
   }
#else					/* AMIGA && LATTICE */
#ifdef MSWindows
#ifndef NTConsole
   {
      char cmdline[256], *tmp;

      strcpy(cmdline, "wiconx ");
      if (efile != NULL) {
         strcat(cmdline, "-e ");
         strcat(cmdline, efile);
         strcat(cmdline, " ");
      }
   strcat(cmdline, ofile);
   strcat(cmdline, " ");
   while ((tmp = *args++) != NULL) {	/* copy args into argument vector */
      strcat(cmdline, tmp);
      strcat(cmdline, " ");
   }

   WinExec(cmdline, SW_SHOW);
   return;
   }
#endif					/* NTConsole */
#endif					/* MSWindows */

   while ((*p++ = *args++) != 0)      /* copy args into argument vector */
      ;
#endif					/* AMIGA && LATTICE */

   *p = NULL;

/*
 * The following code is operating-system dependent [@tmain.03].  It calls
 *  iconx on the way out.
 */

#if PORT
   /* something is needed */
Deliberate Syntax Error
#endif					/* PORT */

#if AMIGA
#if AZTEC_C
      execvp(iconxloc,argv);
      return;
#endif					/* AZTEC_C */
#if LATTICE
      {
      struct ProcID procid;
      if (forkv(iconxloc,argv,NULL,&procid) == 0) {
         wait(&procid);
         return;
         }
      }
#endif					/* LATTICE */
#if __SASC
      {
      struct ProcID procid;
      struct FORKENV env = { 0,       /* priority */
                             20000,   /* stack    */
                             NULL,    /* default stdin */
                             NULL,    /* default stdout */
                             NULL,    /* default console */
                             NULL};   /* default message port */
      env.std_in = Input();
      env.std_out = Output();
      if (forkv(iconxloc,argv,&env,&procid) == 0) { 
         wait(&procid);
         return;
         }
      }
#endif					/* __SASC */
#endif					/* AMIGA */

#if ARM
   {
      int i = 7 + strlen(iconxloc);
      int j;
      char *s;
      char buffer[255];
      extern int armquote(char *, char **);

      sprintf(buffer, "Chain:%s ", iconxloc);
      for (p = argv + 1; *p; ++p)
      {
         j = armquote(*p, &s);

         if (j == -1 || i + j >= 255)
         {
            fprintf(stderr, "Cannot execute: command line too long");
            fflush(stderr);
            return;
         }

         strcpy(buffer + i, s);
         i += j;
         buffer[i] = ' ';
      }
      buffer[i] = '\0';
      system(buffer);
   }
#endif					/* ARM */

#if ATARI_ST || MACINTOSH
      fprintf(stderr,"-x not supported\n");
      fflush(stderr);
#endif					/* ATARI_ST || ... */

#if MSDOS
      /* No special handling is needed for an .exe files, since iconx
       * recognizes it from the extension andfrom internal .exe data.
       */
#if MICROSOFT || TURBO || BORLAND_286 || BORLAND_386
      execvp(iconxloc,argv);	/* execute with path search */
#endif					/* MICROSOFT || ... */

#if INTEL_386 || ZTC_386 || HIGHC_386 || WATCOM || SCCX_MX
      fprintf(stderr,"-x not supported\n");
      fflush(stderr);
#endif					/* INTEL_386 || ... */

#endif					/* MSDOS */

#if MVS || VM
#if SASC
	  exit(sysexec(iconxloc, argv));
#endif					/* SASC */
      fprintf(stderr,"-x not supported\n");
      fflush(stderr);
#endif                                  /* MVS || VM */

#if OS2
#ifdef PresentationManager
      fputs("-x not supported\n", stderr);
#else					/* PresentationManager */
      execvp(iconxloc,argv);	/* execute with path search */
#endif					/* PresentationManager */
#endif					/* OS2 */

#if UNIX || NT
      /*
       * Just execute the file.  It knows how to find iconx.
       * First, though, must redirect stderr if requested.
       */
      if (efile != NULL) {
         close(fileno(stderr));
         if (strcmp(efile, "-") == 0){
	    if (dup(fileno(stdout) == -1)){
	       perror("execute(): could not dup stdout:");
	       exit(EXIT_FAILURE);
	       }
	    }
	 else if (freopen(efile, "w", stderr) == NULL)
	      quitf("could not redirect stderr to %s\n", efile);
         }
      execv(ofile, argv);
      quitf("could not execute %s", ofile);
#endif					/* UNIX */

#if VMS
      execv(iconxloc,argv);
#endif					/* VMS */

/*
 * End of operating-system specific code.
 */

   quitf("could not run %s",iconxloc);

#else					/* !(MACINTOSH && MPW) */
   printf("-x not supported\n");
#endif					/* !(MACINTOSH && MPW) */

   }

void report(s)
char *s;
   {
   char *c = (strchr(s, '\n') ? "" : ":\n") ;
   if (!silent)
      fprintf(stderr,"%s%s",s,c);
   else if (flog != NULL) {
      fprintf(flog, "%s%s",s,c);
      fflush(flog);
      }
   }

/*
 * Print an error message if called incorrectly.  The message depends
 *  on the legal options for this system.
 */
static void usage()
   {
#if MVS || VM
   fprintf(stderr,"usage: %s %s file ... <-x args>\n", progname, Usage);
#elif MPW
   fprintf(stderr,"usage: %s %s file ...\n", progname, Usage);
#else
   fprintf(stderr,"usage: %s %s file ... [-x args]\n", progname, Usage);
#endif					/* MVS || VM || MPW */
   exit(EXIT_FAILURE);
   }



#if MACINTOSH
#if THINK_C

/*
 * IncreaseStackSize - increases stack size by extraBytes
 */
void IncreaseStackSize (Size extraBytes)
{
   SetApplLimit ( GetApplLimit() - extraBytes );
}

/*
 * ToolBoxInit - initializes mac toolbox
 */
void ToolBoxInit ( void )
{
   InitGraf ( &qd.thePort );
   InitFonts ();
   InitWindows ();
   InitMenus ();
   TEInit ();
   InitDialogs ( nil );
   InitCursor ();
}

/*-------------- code for display graphics ----------------------*/

/*
 * DoEvent - handles AppleEvent by passing eventPtr to AEProcessAppleEvent
 *           Command-Q key sequence results exit of the program
 */
void DoEvent ( EventRecord *eventPtr )
{
   char theChar;

   switch ( eventPtr->what )
   {
      case mouseDown:        DoMouseDown (eventPtr);
                             break;
/*
      case kHighLevelEvent : AEProcessAppleEvent ( eventPtr );
                             break;
 */
      case keyDown:
      case autoKey:          theChar = eventPtr->message & charCodeMask;
                             if ( (eventPtr->modifiers & cmdKey) != 0)
                                HandleMenuChoice (MenuKey (theChar));
                             break;
   }
}

/*
 * DoMouseDown -
 */
void DoMouseDown (EventRecord *eventPtr)
{
   WindowPtr whichWindow;
   short thePart;
   long menuChoice;

   thePart = FindWindow (eventPtr->where, &whichWindow);
   switch (thePart) {
      case inMenuBar:
         menuChoice = MenuSelect (eventPtr->where);
         HandleMenuChoice (menuChoice);
         break;
      }
}

/*
 * HandleMenuChoice -
 */
void HandleMenuChoice (long menuChoice)
{
   short menu;
   short item;

   if (menuChoice != 0) {
      menu = HiWord (menuChoice);
      item = LoWord (menuChoice);

      switch (menu) {
         case kAppleMenu:
            HandleAppleChoice (item);
            break;
         case kFileMenu:
            HandleFileChoice (item);
            break;
         case kOptionsMenu:
            HandleOptionsChoice (item);
            break;
         }
      HiliteMenu (0);
      }
}

void HandleAppleChoice (short item)
{
   MenuHandle  appleMenu;
   Str255      accName;
   short       accNumber;

   switch (item) {
      case kAboutMItem:
         SysBeep (20);
         break;
         /* ******************* open a dialog box **************** */
      default:
         appleMenu = GetMHandle (kAppleMenu);
         GetItem (appleMenu, item, accName);
         accNumber = OpenDeskAcc (accName);
         break;
      }
}

void HandleFileChoice (short item)
{
   StandardFileReply fileReply;
   SFTypeList typeList;
   short numTypes;
   char *fileName;
   int argc;
   char **argv;
   MenuHandle menu;

   switch (item) {
      case kQuitMItem:
         gDone = true;
         abort ();
         break;
      case kCompileMItem:
         typeList[0] = 'TEXT';
         numTypes = 1;
         StandardGetFile (nil, numTypes, typeList, &fileReply);
         if (fileReply.sfGood) {
            fileName = PtoCstr (fileReply.sfFile.name);
            menu = GetMHandle (kFileMenu);
            DisableItem (menu, kCompileMItem);
            menu = GetMHandle (kOptionsMenu);
            DisableItem (menu, 0);
            }
         else
            break;

         if (g_cOption)
            argc = 3;
         else
            argc = 2;

         argv = malloc (sizeof (*argv) * argc);
         argv[0] = malloc (strlen ("ICONT") + 1);
         strcpy (argv[0], "ICONT");

         if (g_cOption) {
            argv[1] = malloc (strlen ("-c") + 1);
            strcpy (argv[1], "-c");
            }

         argv[argc-1] = malloc (strlen(fileName) + 1);
         strcpy (argv[argc-1], fileName);

         MacMain (argc, argv);
         break;
      }
}

void HandleOptionsChoice (short item)
{
   MenuHandle menu;

   switch (item) {
      case k_cMItem:
         g_cOption = !g_cOption;
         menu = GetMHandle (kOptionsMenu);
         CheckItem (menu, item, g_cOption);
         break;
      }
}

/*------------------  End of display graphics code ------------------------*/

void MenuBarInit (void)
{
   Handle         menuBar;
   MenuHandle     menu;
   OSErr          myErr;
   long           feature;

   g_cOption = false;

   menuBar = GetNewMBar (kMenuBar);
   SetMenuBar (menuBar);

   menu = GetMHandle (kAppleMenu);
   AddResMenu (menu, 'DRVR');

   menu = GetMHandle (kOptionsMenu);
   CheckItem (menu, k_cMItem, g_cOption);

   DrawMenuBar ();
}

/*
 * EventInit - calls Gestalt to check if AppleEvent is available, if so,
 *   install OpenDocument and QuitApplication handler routines
 */
void EventInit ( void )
{
   OSErr err;
   long  feature;

   err = Gestalt ( gestaltAppleEventsAttr, &feature );

   if ( err != noErr ) {
      printf ("Problem in calling Gestalt.");
      return;
      }
   else {
      if ( ! ( feature & (kGestaltMask << gestaltAppleEventsPresent ) ) ) {
         printf ("Apple events not available!");
         return;
         }
      }

   err = AEInstallEventHandler (kCoreEventClass,
                                kAEOpenDocuments,
            (AEEventHandlerUPP)   DoOpenDoc,
                                0L,
                                false );

   if ( err != noErr )
      printf ("kAEOpenDocuments Apple Event not available!");

   err = AEInstallEventHandler (kCoreEventClass,
                                kAEQuitApplication,
             (AEEventHandlerUPP)  DoQuitApp,
                                0L,
                                false );
   if ( err != noErr )
      printf ("kAEQuitApplication Apple Event not available!");
}

/*
 * EventLoop - waits for an event to be processed
 */
void EventLoop ( void )
{
   EventRecord event;

   gDone = false;
   while ( gDone == false ) {
      if ( WaitNextEvent ( everyEvent, &event, kSleep, nil ) )
         DoEvent ( &event );
      }
}

/*
 * DoOpenDoc - called by AEProcessAppleEvent (a ToolBox routine)
 *
 *    Calls AECountItems to retrieve number of files is to be processed
 *    and enters a loop to process each file.  Sets gDone to true
 *    to terminate program.
 */
pascal OSErr DoOpenDoc ( AppleEvent theAppleEvent,
                         AppleEvent reply,
                               long refCon )
{
   AEDescList fileSpecList;
   FSSpec     file;
   OSErr      err;
   DescType   type;
   Size       actual;
   long       count;
   AEKeyword  keyword;
   long       i;

   int        argc;
   char       **argv;

   char       *fileName;

   err = AEGetParamDesc ( &theAppleEvent,
                          keyDirectObject,
                          typeAEList,
                          &fileSpecList );
   if ( err != noErr ) {
      printf ("Error AEGetParamDesc");
      return ( err );
      }

   err = GotRequiredParams ( &theAppleEvent );
   if ( err != noErr ) {
      printf ("Error GotRequiredParams");
      return ( err );
      }

   err = AECountItems ( &fileSpecList, &count );
   if ( err != noErr ) {
      printf ("Error AECountItems");
      return ( err );
      }

   argc = count + 1;
   argv = malloc (sizeof (*argv) * (argc + 1));
   argv[0] = malloc (strlen("ICONT") + 1);
   strcpy (argv[0], "ICONT");

   for ( i = 1; i <= count; i++ ) {
      err = AEGetNthPtr ( &fileSpecList,
                          i,
                          typeFSS,
                          &keyword,
                          &type,
                          (Ptr) &file,
                          sizeof (FSSpec),
                          &actual );
      if ( err != noErr ) {
         printf ("Error AEGetNthPtr");
         return ( err );
	 }

      fileName = PtoCstr (file.name);
      argv[i] = malloc(strlen(fileName) + 1);
      strcpy (argv[i], fileName);
      }
   MacMain (argc, argv);
   gDone = true;
   return ( noErr );
}

/*
 * DoQuitApp - called by AEProcessAppleEvent (a ToolBox routine)
 *             sets gDone to true to terminate program
 */
pascal OSErr DoQuitApp ( AppleEvent theAppleEvent,
                         AppleEvent reply,
                               long refCon )
{
   OSErr err = noErr;
   gDone = true;
   return err;
}

/*
 * GotRequiredParams - check if all required parameters are retrieved
 */
OSErr GotRequiredParams ( AppleEvent *appleEventPtr )
{
   DescType returnedType;
   Size     actualSize;
   OSErr    err;

   err = AEGetAttributePtr ( appleEventPtr,
                             keyMissedKeywordAttr,
                             typeWildCard,
                             &returnedType,
                             nil,
                             0,
                             &actualSize );
   if ( err == errAEDescNotFound )
      return noErr;
   else
      if (err == noErr )
         return errAEEventNotHandled;
      else
         return err;
}

#endif               /* THINK_C */
#endif               /* MACINTOSH */
