/*
 * cmain.c - main program icon compiler.
 */
#include "../h/gsupport.h"
#include "ctrans.h"
#include "ctree.h"
#include "ccode.h"
#include "csym.h"
#include "cproto.h"
#include "wop.h"
#include "../h/version.h"

/*
 * Prototypes.
 */
static void emit_cmdline(void *, int, char **);
static void execute (char *ofile, char *efile, char **args);
static FILE  *open_out (char *fname);
static void rmfile  (char *fname);
static void report  (char *s);
static void usage   (void);

#ifdef strlen
#undef strlen				/* pre-defined in some contexts */
#endif					/* strlen */

#ifdef ExpTools
char *toolstr = "${TOOLS}";
#endif					/* ExpTools */


char *unirootfile(char *prog, char *mod);
char *refpath;
extern char patchpath[];

#define Global
#define Init(v) = v
#include "cglobals.h"

/*
 * getopt() variables
 */
extern int optind;		/* index into parent argv vector */
extern int optopt;		/* character checked for validity */
extern char *optarg;		/* argument associated with option */


static
int
compute_dynrec_start()
{
   int rslt;
   struct rentry * r;
   extern int num_dynrec_ctors;

   for (rslt=0,r=rec_lst; r; r=r->next,rslt++)
      ;
   if (rslt >= num_dynrec_ctors)
      rslt -= num_dynrec_ctors;
   else
      rslt = 0;
   if (rslt < 0)
      rslt = 0;
   return rslt;
}

/* Temporary home for versionLine() */
char *versionLine(char *prefix)
{
  static char vline[200];
  int pos, dots;
  char c, *dstr, *branch;

  sprintf(vline, "%s Version %s   %s (", prefix, VersionNumber, VersionDate);
  for (dstr = gitDescription, pos = 0, dots = 0; (c = dstr[pos]) != '\0'; ++pos) {
    if (c == '.') ++dots;
    if (!isdigit(c) && c != '.') break; /* Not an LTB char */
  }
  if (c == '-') {
    if (dstr[pos+1] == '0' && dstr[pos+2] == '-') { /* Latest commit is tagged */
      /* Use the tag name (in dstr) to decide the annotation */
      if (dots == 0) {
        strcat(vline, dstr); strcat(vline, " Development)");
      } else if (dots == 1) {
        strcat(vline, "Release)");
      } else {
        strncat(vline, dstr, pos); strcat(vline, " Maintenance Release)");
      }
    } else { /*  Latest commit is not tagged */
      strcat(vline,dstr);
      if (0 == strcmp(gitBranch, "master")) {
        strcat(vline, " pre-release)");
      } else { /* Use the branch name to decide the annotation */
        for (branch = gitBranch, pos = 0; (c = branch[pos]) != '\0'; ++pos) {
          if (!isdigit(c) && c != '.') break;
        }
        if (c == '\0') {
          strcat(vline, " Maintenance pre-release)");
        } else {
          strcat(vline, " Development \""); strcat(vline, branch); strcat(vline, "\")");
        }
      }
    }
  } else { /* We don't understand the output of git describe */
    strcat(vline, dstr); strcat(vline, ")");
  }

  return vline;
}


/*
 *  main program
 */
int main(argc,argv)
int argc;
char **argv;
   {
   int errors = 0;			/* compilation errors */
   int dynrec_start; /* recnum origin for dynamic recs */
   int no_c_comp = 0;			/* suppress C compile and link? */
   char *cfile = NULL;			/* name of C file - primary */
   char *hfile = NULL;			/* name of C file - include */
   char *ofile = NULL;			/* name of executable result */
   char *efile = NULL;			/* stderr file */

   char *db_name = "rt.db";		/* data base name */
   char *incl_file = "rt.h";		/* header file name */

   char *db_path;			/* path to data base */
   char *db_lst;			/* list of private data bases */
   char *incl_path;			/* path to header file */
   char *s, c1;
   char buf[MaxFileName];		/* file name construction buffer */
   extern int ca_init(char *, int, char **);
   extern void ca_dbg_dump(void);
   extern char * ca_first_perifile;
#ifdef ExpTools
   char Buf[MaxFileName];
   char *tools;				/* patch and TOOLS string buffer */
#endif					/* ExpTools */

   int c;
   int ret_code;
   struct fileparts *fp;

   if (verbose > 1)
      report("iconc build of " __DATE__" "__TIME__);

#ifdef ExpTools
   if (strlen(patchpath)>18) {
      refpath = patchpath+18;
      if(!strncmp(refpath,toolstr,strlen(toolstr))) {	/* Is it TOOLS   */
         refpath = refpath+strlen(toolstr);		/* skip TOOLS    */
         if ((tools = getenv("TOOLS")) == NULL) {
            fprintf(stderr,
              "patchstr begins with \"${TOOLS}\" but ${TOOLS} has no value\n");
            fprintf(stderr, "patchstr=%s\ncompilation aborted\n", refpath);
            exit(EXIT_FAILURE);
           }
         else
            strcpy(Buf,tools);
         strcat(Buf,refpath);			/* append name   */
         if (Buf[strlen(Buf)-1] != '/')
            strcat(Buf,"/");
         refpath = Buf;				/* use refpath   */
         }
      }
   fprintf(stderr,"iconc library files found in %s\n",refpath);
#else					/* ExpTools */

   // find the path to the top level directory
   refpath = unirootfile(argv[0], "/../..");

#endif					/* ExpTools */

   /*
    * Pre-process options looking for -help and -version
    *  (this is a temporary measure; in the longer term we will probably
    *   switch from getopt() to getopt_long() or similar).
    * At that time, much of this code will get put into a couple of procedures to
    * build the version string and to emit the help text
    */
   {
     int n, nargs = argc;
     char ** opts = argv;
     for (n = 1; n < nargs; ++n)
       {
         if ((0 == strncmp("--", opts[n],2)) || (0 == strncmp("-x", opts[n],2))) {
           break;             /* Stop at a -- or -x option */
         }
         if (opts[n][0] != '-') {
           break;               /* stop at first non option */
         } else { /* See if we have -help or -version */
           if (0 == strncmp("-help", opts[n], 5)) {
             printf("Usage: %s [-cEgmstTuU] [-help] [-version] [-C comp]\n", progname);
             printf("       [-e efile] [-f[adelns]] [-n[acest]] [-o ofile]\n");
             printf("       [-p opt] [-r path] [-v i] [-w[bf]] file ... [-x args]\n");
             printf("options may be one of:\n");
             printf("   -c          : produce C file(s) only; do not compile\n");
             printf("   -C comp     : the C compiler is called comp\n");
             printf("   -e efile    : redirect standard error output to efile\n");
             printf("   -E          : preprocess only; do not compile\n");
             printf("   -fa         : enable all features (-fd -fe -fl -fn -fs)\n");
             printf("     -fd       :   enable debugging\n");
             printf("     -fe       :   enable error conversion\n");
             printf("     -fl       :   enable support for large integers\n");
             printf("     -fn       :   enable line numbering\n");
             printf("     -fs       :   enable full string invocation\n");
             printf("   -g          : emit debugging symbols\n");
             printf("   -help       : produce this information\n");
             printf("   -m          : preprocess using m4\n");
             printf("   -na         : disable all optimizations (-nc -ne -ns -nt)\n");
             printf("     -nc       :   disable control flow optimizations\n");
             printf("     -ne       :   disable in-line expansion\n");
             printf("     -ns       :   disable switch optimizations\n");
             printf("     -nt       :   disable type inference\n");
             printf("   -p opt      : pass opt through to C compiler (or linker)\n");
             printf("   -r path     : path is the location of the runtime system\n");
             printf("   -s          : work silently\n");
             printf("   -t          : turn on tracing\n");
             printf("   -T          : type trace only\n");
             printf("   -u          : warn of undeclared variables\n");
             printf("   -U          : indicate the source file(s) were produced by Unicon\n");
             printf("   -v i        : set diagnostic verbosity level to i\n");
             printf("   -version    : report the build version\n");
             printf("   -wb         : optimize argument dereferences\n");
             printf("   -wf         : optimize field dereferences\n");
             printf("   -x args     : execute immediately\n");
             printf("\n");
             exit(EXIT_SUCCESS);
           }

           if(0 == strncmp("-version", opts[n],8)) {
             printf("%s\n", versionLine(progname));
             exit(EXIT_SUCCESS);
           }
         }
       }
   }

   /*
    * Process options.
    */
   while ((c = getopt(argc,argv,"A:C:EL:S:TU:ce:f:gmn:o:p:r:stuv:w:x")) != EOF)
      switch (c) {
         case 'A': /* here come the perifiles... */
            ca_init(optarg, argc, argv);
            if (verbose > 3) {
               printf("mdw: ca-first-perifile: \"%s\"\n", ca_first_perifile);
               ca_dbg_dump();
               }
            break;
         case 'C': /* -C C-comp: C compiler*/
            c_comp = optarg;
            break;
         case 'E': /* -E: preprocess only */
            pponly = 1;
            no_c_comp = 1;
            break;
         case 'S': /* Ignore: interpreter only */
            break;
         case 'T':
            just_type_trace = 1;
            break;
         case 'U': /* source was preprocessed by unicon */
            if (*optarg == 'a')
               unicon_mode = UM_Ambig;
            else
               unicon_mode = UM_Normal;
            /*
            printf("iconc: unicon-mode: %s.\n", unicon_mode == UM_Ambig ?
                "UM_Ambig" : "UM_Normal");
            */
            break;
         case 'c': /* -c: produce C file only */
            no_c_comp = 1;
            break;
         case 'e': /* -e file: redirect stderr */
            efile = optarg;
            break;
         case 'f': /* -f: enable features */
            for (s = optarg; *s != '\0'; ++s) {
               switch (*s) {
                  case 'a': /* -fa: enable all features */
                     line_info = 1;
                     debug_info = 1;
                     err_conv = 1;
                     largeints = 1;
                     str_inv = 1;
                     break;
                  case 'd': /* -fd: enable debugging features */
                     line_info = 1;
                     debug_info = 1;
                     break;
                  case 'e': /* -fe: enable error conversion */
                     err_conv = 1;
                     break;
                  case 'l': /* -fl: support large integers */
                     largeints = 1;
                     break;
                  case 'n': /* -fn: enable line numbers */
                     line_info = 1;
                     break;
                  case 's': /* -fs: enable full string invocation */
                     str_inv = 1;
                     break;
                  default:
                     quitf("-f option must be a, d, e, l, n, or s. found: %s",
                        optarg);
                  }
               }
            break;
         case 'g': /* -g: mdw: emit debugging symbols in target */
            dbgsyms = 1;
            break;
         case 'm': /* -m: preprocess using m4(1) [UNIX] */
            m4pre = 1;
            break;
         case 'n': /* -n: disable optimizations */
            for (s = optarg; *s != '\0'; ++s) {
               switch (*s) {
                  case 'A': /* mdw: disable ca module */
                     opt_ca = 0;
                     break;
                  case 'O': /* -nO: no optimizations with host cc */
                     opt_hc_opts = 0;
                     printf("opt-hc-opts: 0\n");
                     break;
                  case 'a': /* -na: disable all optimizations */
                     opt_cntrl = 0;
                     allow_inline = 0;
                     opt_sgnl = 0;
                     do_typinfer = 0;
                     break;
                  case 'c': /* -nc: disable control flow opts */
                     opt_cntrl = 0;
                     break;
                  case 'e': /* -ne: disable expanding in-line */
                     allow_inline = 0;
                     break;
                  case 's': /* -ns: disable switch optimizations */
                     opt_sgnl = 0;
                     break;
                  case 't': /* -nt: disable type inference */
                     do_typinfer = 0;
                     break;
                  default:
                     usage();
                  }
               }
            break;
         case 'o': /* -o file: name output file */
            ofile = optarg;
            break;
         case 'p': /* -p C-opts: options for C comp */
            if (*optarg == '\0')	/* if empty string, clear options */
               c_opts = optarg;
            else {			/* else append to current set */
               s = (char *)alloc(strlen(c_opts) + 1 + strlen(optarg) + 1);
               sprintf(s, "%s %s", c_opts, optarg);
               c_opts = s;
               }
            break;
         case 'r': /* -r path: primary runtime system */
            refpath = optarg;
            break;
         case 's': /* -s: suppress informative messages */
            verbose = 0;
            break;
         case 't': /* -t: &trace = -1 */
            line_info = 1;
            debug_info = 1;
            trace = 1;
            break;
         case 'u': /* -u: warn about undeclared ids */
            uwarn = 1;
            break;
         case 'v': /* -v: set level of verbosity */
            if (sscanf(optarg, "%d%c", &verbose, &c1) != 1)
               quitf("bad operand to -v option: %s",optarg);
            break;
         case 'w': /* -w: weird opts */
            for (s=optarg; *s; s++) {
               switch (*s) {
                  case 'b': /* -wb: optimize arg derefs #2 */
                     wop_set(Wop_OpArgDerefs);
                     break;
                  case 'f':		/* -wf: optimize field derefs */
                     wop_set(Wop_FldDerefs);
                     break;
                  default:
                     usage();
                     break;
               }
            }
            break;
         default:
         case 'x': /* -x illegal until after file list */
            usage();
         }

   init();			/* initialize memory for translation */
   /*
    * Load the data bases of information about run-time routines and
    *  determine what libraries are needed for linking (these libraries
    *  go before any specified on the command line).
    */
   db_lst = getenv("DBLIST");
   if (db_lst != NULL)
      db_lst = salloc(db_lst);
   s = db_lst;
   while (s != NULL) {
      db_lst = s;
      while (isspace(*db_lst))
         ++db_lst;
      if (*db_lst == '\0')
         break;
      for (s = db_lst; !isspace(*s) && *s != '\0'; ++s)
         ;
      if (*s == '\0')
         s = NULL;
      else
         *s++ = '\0';
      readdb(db_lst);
      addlib(salloc(makename(buf,SourceDir, db_lst, LibSuffix)));
      }
   db_path = (char *)alloc((unsigned int)strlen(refpath) + /*"/rt/lib/"*/ 8 + strlen(db_name) + 1);
   strcpy(db_path, refpath);
#if NTGCC
   strcat(db_path, "\\rt\\lib\\");
#else					/* NTGCC */
   strcat(db_path, "/rt/lib/");
#endif					/* NTGCC */
   strcat(db_path, db_name);
   readdb(db_path);
   addlib(salloc(makename(buf,SourceDir, db_path, LibSuffix)));

   /*
    * Scan the rest of the command line for file name arguments.
    */
   while (optind < argc)  {
      if (strcmp(argv[optind],"-x") == 0)	/* stop at -x */
         break;
      else if (strcmp(argv[optind],"-") == 0)
         /* mdw src_file("-"); */				/* "-" means standard input */
         src_file("-", &srclst);

/*
 * The following code is operating-system dependent [@tmain.02].  Check for
 *  C linker options on the command line.
 */

#if PORT
   /* something is needed */
Deliberate Syntax Error
#endif					/* PORT */

#if UNIX
      else if (argv[optind][0] == '-')
         addlib(argv[optind]);		/* assume linker option */
#endif					/* UNIX ... */

#if MACINTOSH || MSDOS || MVS || VM || VMS
      /*
       * Linker options on command line not supported.
       */
#endif					/* MACINTOSH || ... */

/*
 * End of operating-system specific code.
 */

      else {
         fp = fparse(argv[optind]);		/* parse file name */
         if (*fp->ext == '\0' || smatch(fp->ext, SourceSuffix)) {
            /* mdw: modified this clause */
            if (unicon_mode)
               makename(buf, SourceDir, argv[optind], "");
            else
               makename(buf,SourceDir,argv[optind], SourceSuffix);
#if VMS
            strcat(buf, fp->version);
#endif					/* VMS */
            /* mdw src_file(buf);*/
            src_file(buf, &srclst);
            }
         else

/*
 * The following code is operating-system dependent [@tmain.03].  Pass
 *  appropriate files on to linker.
 */

#if PORT
   /* something is needed */
Deliberate Syntax Error
#endif					/* PORT */


#if UNIX
            /*
             * Assume all files that are not Icon source go to linker.
             */
            addlib(argv[optind]);
#endif					/* UNIX ... */

#if MACINTOSH || MSDOS || MVS || VM || VMS
            /*
             * Pass no files to the linker.
             */
            quitf("bad argument %s",argv[optind]);
#endif					/* MACINTOSH || ... */

/*
 * End of operating-system specific code.
 */

         }
      optind++;
      }

   if (srclst == NULL)
      usage();				/* error -- no files named */

   if (pponly) {
      if (trans(argv[0]) == 0)
         exit (EXIT_FAILURE);
      else
         exit (EXIT_SUCCESS);
      }

   if (ofile == NULL) {		/* if no -o file, synthesize a name */
      if (strcmp(srclst->name,"-") == 0)
         ofile = salloc(makename(buf,TargetDir,"stdin",ExecSuffix));
      else
         ofile = salloc(makename(buf,TargetDir,srclst->name,ExecSuffix));
      }
   else {				/* add extension if necessary */
      fp = fparse(ofile);
      if (*fp->ext == '\0' && *ExecSuffix != '\0')
         ofile = salloc(makename(buf,NULL,ofile,ExecSuffix));
      }
   /*
    * Make name of intermediate C files.
    */
   cfile = salloc(makename(buf,TargetDir,ofile,CSuffix));
   hfile = salloc(makename(buf,TargetDir,ofile,HSuffix));

   codefile = open_out(cfile);
   emit_cmdline(codefile, argc, argv);
   fprintf(codefile, "#include \"%s\"\n", hfile);

   inclfile = open_out(hfile);
   fprintf(inclfile, "#define COMPILER 1\n");

   incl_path = (char *)alloc((unsigned int)(strlen(refpath) + /*/rt/include/*/ 12 +
       strlen(incl_file) + 1));
   strcpy(incl_path, refpath);
#if NTGCC
   strcat(incl_path, "\\rt\\include\\");
#else					/* NTGCC */
   strcat(incl_path, "/rt/include/");
#endif					/* NTGCC */
   strcat(incl_path, incl_file);
   fprintf(inclfile,"#include \"%s\"\n", incl_path);

   /*
    * Translate .icn files to make C file.
    */
   if ((verbose > 0) && !just_type_trace)
      report("Translating to C");

   errors = trans(argv[0]);

   if ((errors > 0) || just_type_trace) {	/* exit if errors seen */
      rmfile(cfile);
      rmfile(hfile);
      if (errors > 0)
         exit(EXIT_FAILURE);
      else
         exit(EXIT_SUCCESS);
      }

   /*
    * determine the origin of dynrecs so that we can
    * notify the runtime system and keep recnums in sync.
    */
   dynrec_start = compute_dynrec_start();
   fprintf(inclfile, "/* mdw: sync recnum between iconc and rtl */\n");
   fprintf(inclfile, "#define DYNREC_START %d\n", dynrec_start);

   fclose(codefile);
   fclose(inclfile);
   /*
    * Compile and link C file.
    */
   if (no_c_comp) {			/* exit if no C compile wanted */
      exit(EXIT_SUCCESS);
      }

   if (verbose > 0)
      report("Compiling and linking C code");

   ret_code = ccomp(cfile, ofile);
   if (ret_code == EXIT_FAILURE) {
      fprintf(stderr, "*** C compile and link failed ***\n");
      rmfile(ofile);
      }
   else {
      /*
       * Finish by removing C files.
       */
      fprintf(stderr,"Succeeded\n");
      rmfile(cfile);
      rmfile(hfile);
      rmfile(makename(buf,TargetDir,cfile,ObjSuffix));
      }
#ifdef IconcLogAllocations
   alc_stats();
#endif					/* IconcLogAllocations */
   if (ret_code == EXIT_SUCCESS && optind < argc)  {
      if (verbose > 0)
         report("Executing");
      execute (ofile, efile, argv+optind+1);
      }
   return ret_code;
   }

/*
 * Write the iconc command-line into a comment in the C file generated by iconc.
 */ 
static
void
emit_cmdline(f, argc, argv)
   void * f;
   int argc;
   char ** argv;
{
   int i, len, col;

   fprintf(f, "/*\n * command-line:\n *\n * ");
   for (col=4,i=0; i<argc; i++) {
      len = strlen(argv[i]);
      if (col + len > 60) {
         fprintf(f, "\n *   ");
         col = 6 + len;
         }
      else
         col += len;
      fprintf(f, "%s ", argv[i]);
      }
   fprintf(f, "\n */\n");
   fflush(f);
}

/*
 * execute - execute compiled Icon program
 */
static void execute(ofile,efile,args)
char *ofile, *efile, **args;
   {

   int n;
   char **argv, **p;

#if UNIX
      char buf[MaxFileName];		/* file name construction buffer */

      ofile = salloc(makename(buf,"./",ofile,ExecSuffix));
#endif					/* UNIX */

   for (n = 0; args[n] != NULL; n++)	/* count arguments */
      ;
   p = argv = (char **)alloc((unsigned int)((n + 2) * sizeof(char *)));

   *p++ = ofile;			/* set executable file */

   while ((*p++ = *args++) != NULL)		/* copy args into argument vector */
      ;

   *p = NULL;

   if (efile != NULL && !redirerr(efile)) {
      fprintf(stderr, "Unable to redirect &errout\n");
      fflush(stderr);
      }

/*
 * The following code is operating-system dependent [@tmain.04].  It calls
 *  the Icon program on the way out.
 */

#if PORT
   /* something is needed */
Deliberate Syntax Error
#endif					/* PORT */

#if MACINTOSH
      fprintf(stderr,"-x not supported\n"); fflush(stderr);
#endif					/* MACINTOSH */

#if MSDOS
#if MICROSOFT || TURBO
      execvp(ofile,argv);
#endif					/* MICROSOFT || ... */
#endif					/* MSDOS */

#if MVS || VM
      fprintf(stderr,"-x not supported\n");
      fflush(stderr);
#endif                                  /* MVS || VM */

#if UNIX || VMS
      execvp(ofile,argv);
#endif					/* UNIX || VMS */


/*
 * End of operating-system specific code.
 */

   quitf("could not run %s",ofile);

   }

static void report(s)
char *s;
   {

/*
 * The following code is operating-system dependent [@tmain.05].  Report
 *  phase.
 */

#if PORT
   fprintf(stderr,"%s:\n",s);
Deliberate Syntax Error
#endif					/* PORT */

#if MSDOS || MVS || UNIX || VM || VMS
   fprintf(stderr,"%s:\n",s);
#endif					/* MSDOS || ... */

/*
 * End of operating-system specific code.
 */

   }

/*
 * rmfile - remove a file
 */

static void rmfile(fname)
char *fname;
   {
   remove(fname);
   }

/*
 * open_out - open a C output file and write identifying information
 *  to the front.
 */
static FILE *open_out(fname)
char *fname;
   {
   FILE *f;
   static char *ident = "/*ICONC*/";
   int c;
   int i;

   /*
    * If the file already exists, make sure it is old output from iconc
    *   before overwriting it. Note, this test doesn't work if the file
    *   is writable but not readable.
    */
   f = fopen(fname, "r");
   if (f != NULL) {
      for (i = 0; i < (int)strlen(ident); ++i) {
         c = getc(f);
         if (c == EOF)
            break;
         if ((char)c != ident[i])
            quitf("%s not in iconc format; rename or delete, and rerun",fname);
         }
      fclose(f);
      }

   f = fopen(fname, "w");
   if (f == NULL)
      quitf("cannot create %s", fname);
   fprintf(f, "%s\n", ident); /* write "belongs to iconc" comment */
   id_comment(f);             /* write detailed comment for human readers */
   fflush(f);
   return f;
   }

/*
 * Print an error message if called incorrectly.  The message depends
 *  on the legal options for this system.
 */
static void usage()
   {
   fprintf(stderr,"usage: %s %s file ... [-x args]\n", progname, CUsage);
   fprintf(stderr,"%s -help       for full listing of options\n", progname);
   exit(EXIT_FAILURE);
   }
