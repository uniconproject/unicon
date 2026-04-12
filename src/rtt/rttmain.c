#include "rtt.h"

/*#include "../h/filepat.h"             ?* added for filepat change */

#if NT
#include <process.h>
#endif

#ifdef HAVE_WORKING_FORK
#include <sys/wait.h>
#include <unistd.h>
#endif /* HAVE_WORKING_FORK */

/*
 * prototypes for static functions.
 */
static void add_tdef (char *name);
static void rtt_progress_file(const char *path);
static int rtt_cc_is_tmp_chunk_c(const char *path);
static void rtt_progress_cc(const char *path);
#ifdef HAVE_WORKING_FORK
static int rtt_parallel_cc(const char *ccomp, const char *copts,
                           const char *file_list, int silent);
static void rtt_remove_c_files(const char *file_list);
#endif /* HAVE_WORKING_FORK */
extern int yynerrs;
extern int __merr_errors;

/*
 * refpath is used to locate the standard include files for the Icon.
 *  run-time system. If patchpath has been patched in the binary of rtt,
 *  the string that was patched in is used for refpath.
 */
extern char patchpath[];

#ifdef RefPath
char *refpath = RefPath;
#else                                   /* RefPath */
char *refpath = "";
#endif                                  /* RefPath */

#if MVS
char *src_file_nm;
#endif                                  /* MVS */

/*
 * The following code is operating-system dependent [@rttmain.02].
 * The relative path to grttin.h and rt.h depends on whether they are
 *  interpreted as relative to where rtt.exe is or where rtt.exe is
 *  invoked.
 */

#if PORT
   /* something is needed */
Deliberate Syntax Error
#endif                                  /* PORT */

#if MSDOS
char *grttin_path = "..\\src\\h\\grttin.h";
char *rt_path = "..\\src\\h\\rt.h";
#endif                                  /* MSDOS */

#if MVS
char *grttin_path = "ddn:h(grttin)";  /* presented to source() */
char *rt_path = "rt.h";  /* presented to compiler */
#endif                                  /* MVS */

#if VMS || VM
char *grttin_path = "grttin.h";
char *rt_path = "rt.h";
#endif                                  /* VMS || VM */

#if UNIX
char *grttin_path = "../src/h/grttin.h";
char *rt_path = "../src/h/rt.h";
#endif                                  /* UNIX */

/*
 * End of operating-system specific code.
 */

static char *ostr = "AKECPD:I:U:O:d:cir:st:xj:";

#if EBCDIC
static char *options =
    "<-A> <-E> <-C> <-P> <-K> <-c> <-O copts> <-s> <-j n> <-Dname<=<text>>> <-Uname> <-Ipath> <-dfile>\n    \
<-rpath> <-tname> <-x> <files>";
#else                                   /* EBCDIC */
static char *options =
    "[-A] [-E] [-C] [-P] [-K] [-c] [-O copts] [-s] [-j n] [-Dname[=[text]]] [-Uname] [-Ipath] [-dfile]\n    \
[-rpath] [-tname] [-x] [files]";
#endif                                  /* EBCDIC */

/*
 *  Note: rtt presently does not process system include files. If this
 *   is needed, it may be necessary to add other options that set
 *   manifest constants in such include files.  See pmain.c for the
 *   stand-alone preprocessor for examples of what's needed.
 */

char *progname = "rtt";
char *compiler_def;
FILE *out_file;
char *inclname;
int def_fnd;
char *largeints = NULL;

int iconx_flg = 0;
int enable_out = 0;

int archive_flg = 0;
int ccomp_flg = 0;
char *ccomp_opts = NULL;

char *curlst_string;                            /* string of files, with .c */
char *fulllst_string;

static char *cur_src;                           /* current source (.r) file */

static int silent = 0;

/*
 * Parallel gcc -c job cap from -j n (Unix). -1 means option not given.
 */
static int rtt_cc_jobs_cli = -1;

/*
 * One line per input .r while translating. Shown even when -s is set.
 * -x => "[ICONX RTT]"; compiler RTL => "[ICONC RTT]" (matches runtime Makefile
 * tone).
 */
static void rtt_progress_file(const char *path) {
  if (path == NULL || *path == '\0')
    return;
  if (iconx_flg)
    fprintf(stdout, "   [ICONX URTT] %s\n", path);
  else
    fprintf(stdout, "   [ICONC URTT] %s\n", path);
  fflush(stdout);
}

/*
 * rt.db chunk temps: f_*, o_*, k_* (e.g. f_6t.c, o_1.c, k_060.c) — not fconv.c
 * (no "f_"). Omit [CC] for these (even with -s).
 */
static int rtt_cc_is_tmp_chunk_c(const char *path) {
  const char *base, *p;

  if (path == NULL || *path == '\0')
    return 0;
  base = path;
  for (p = path; *p != '\0'; p++)
    if (*p == '/' || *p == '\\')
      base = p + 1;
  if (strncmp(base, "f_", 2) != 0 && strncmp(base, "o_", 2) != 0 &&
      strncmp(base, "k_", 2) != 0)
    return 0;
  /* f_.c — nothing between letter_ and . */
  p = base + 2;
  if (*p == '\0' || *p == '.')
    return 0;
  while (*p != '\0' && *p != '.')
    p++;
  return (*p == '.' && p[1] == 'c' && p[2] == '\0');
}

/*
 * About to run the C compiler on one generated .c (urtt still prints; tool is
 * CC).
 */
static void rtt_progress_cc(const char *path) {
  if (path == NULL || *path == '\0')
    return;
  /* Skip whether or not -s: default builds pass -s but chunk [CC] is still noise. */
  if (rtt_cc_is_tmp_chunk_c(path))
    return;
  fprintf(stdout, "   [CC] %s\n", path);
  fflush(stdout);
}

extern int line_cntrl;

/*
 * tdefnm is used to construct a list of identifiers that
 *  must be treated by rtt as typedef names.
 */
struct tdefnm {
   char *name;
   struct tdefnm *next;
   };

static char *dbname = "rt.db";
static int pp_only = 0;
static char *opt_lst;
static char **opt_args;
static char *in_header;
static struct tdefnm *tdefnm_lst = NULL;

/*
 * getopt() variables
 */
extern int optind;              /* index into parent argv vector */
extern int optopt;              /* character checked for validity */
extern char *optarg;            /* argument associated with option */

#if TURBO
unsigned _stklen = 30000;
#endif                                  /* TURBO */

#ifdef ConsoleWindow
int ConsolePause = 1;
#endif                                  /* ConsoleWindow */

#ifndef NTConsole
#ifdef MSWindows
int rtt(int argc, char **argv);
#define int_PASCAL int PASCAL
#define LRESULT_CALLBACK LRESULT CALLBACK
#undef Reset
#include <windows.h>
#include "../wincap/dibutil.h"

int CmdParamToArgv(char *s, char ***avp)
   {
   char *t, *t2;
   int rv=0;
   t = salloc(s);
   t2 = t;
   while (*t2) {
      while (*t2 && isspace(*t2)) t2++;
      if (!*t2) break;
      rv++;
      while (*t2 && !isspace(*t2)) t2++;
      }
   rv++; /* make room for "iconx" at front */
   *avp = (char **)alloc(rv * sizeof(char *));
   rv = 0;
   (*avp)[rv++] = salloc("iconx.exe");
   t2 = t;
   while (*t2) {
      while (*t2 && isspace(*t2)) t2++;
      if (!*t2) break;
      (*avp)[rv++] = t2;
      while (*t2 && !isspace(*t2)) t2++;
      if (*t2) *t2++ = '\0';
      }
   return rv;
   }

LRESULT_CALLBACK WndProc        (HWND, UINT, WPARAM, LPARAM);

void MSStartup(int argc, char **argv, HINSTANCE hInstance, HINSTANCE hPrevInstance)
   {
   WNDCLASS wc;
   if (!hPrevInstance) {
#if NT
      wc.style = CS_HREDRAW | CS_VREDRAW;
#else                                   /* NT */
      wc.style = 0;
#endif                                  /* NT */
#ifdef NTConsole
      wc.lpfnWndProc = DefWindowProc;
#else                                   /* NTConsole */
      wc.lpfnWndProc = WndProc;
#endif                                  /* NTConsole */
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

HANDLE mswinInstance;
int ncmdShow;


int_PASCAL WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
                   LPSTR lpszCmdParam, int nCmdShow)
   {
   int argc;
   char **argv;

   mswinInstance = hInstance;
   ncmdShow = nCmdShow;
   argc = CmdParamToArgv(lpszCmdParam, &argv);
   MSStartup(argc, argv, hInstance, hPrevInstance);
   (void)rtt(argc, argv);
   fclose(stderr);
   fclose(fopen("icont.fin","w"));
}

#define main rtt
#endif                                  /* MSWindows */
#endif                                  /* NTConsole */

#ifdef HAVE_WORKING_FORK
/*
 * Parallel gcc -c jobs after RTT translation (when fork works: configure
 * HAVE_WORKING_FORK — includes GNU/Linux, MSYS2, Cygwin, etc.).
 * Precedence: -j n command line, RTT_JOBS env, MAKEFLAGS -jN, bare "make -j"
 * in MAKEFLAGS => min(CPU, RTT_CC_MAX_JOBS), else 1.
 */
#define RTT_CC_MAX_JOBS 32
#define RTT_MF_JOBS_NONE 0
#define RTT_MF_JOBS_BARE_J (-1)

/*
 * Scan MAKEFLAGS for -jN / -j (GNU make sets this for recipe subprocesses).
 * Returns last -jN (1..1024), RTT_MF_JOBS_BARE_J if bare -j seen without a
 * following number, or RTT_MF_JOBS_NONE.
 */
static int parse_makeflags_jobs(void) {
  const char *m = getenv("MAKEFLAGS");
  const char *p;
  char *end;
  int last = RTT_MF_JOBS_NONE;
  int saw_bare = 0;

  if (m == NULL)
    return RTT_MF_JOBS_NONE;
  for (p = m; *p != '\0';) {
    /* Skip --long-option tokens (e.g. --jobserver-auth=...) so "-j" in
     * "jobserver" is not treated as a bare -j. */
    if (p[0] == '-' && p[1] == '-') {
      while (*p != '\0' && !isspace((unsigned char)*p))
        p++;
      continue;
    }
    if (p[0] == '-' && p[1] == 'j') {
      const char *q = p + 2;
      if (isdigit((unsigned char)*q)) {
        long v = strtol(q, &end, 10);
        p = end;
        if (v > 0 && v <= 1024) {
          last = (int)v;
          saw_bare = 0;
        }
        continue;
      }
      saw_bare = 1;
      p += 2;
      continue;
    }
    p++;
  }
  if (last > 0)
    return last;
  if (saw_bare)
    return RTT_MF_JOBS_BARE_J;
  return RTT_MF_JOBS_NONE;
}

static int rtt_cc_max_jobs(void) {
  char *e;
  long n;
  char *end;
  long cpus;
  int mj;

  if (rtt_cc_jobs_cli > 0)
    return rtt_cc_jobs_cli;

  e = getenv("RTT_JOBS");
  if (e != NULL && *e != '\0') {
    n = strtol(e, &end, 10);
    if (end != e && n > 0 && n <= 1024)
      return (int)n;
  }
  mj = parse_makeflags_jobs();
  if (mj > 0)
    return mj;
  if (mj == RTT_MF_JOBS_BARE_J) {
    cpus = (long)sysconf(_SC_NPROCESSORS_ONLN);
    if (cpus < 1)
      cpus = 1;
    if (cpus > RTT_CC_MAX_JOBS)
      cpus = RTT_CC_MAX_JOBS;
    return (int)cpus;
  }
  return 1;
}

static void rtt_remove_c_files(const char *file_list) {
  char *copy, *tok;

  if (file_list == NULL)
    return;
  copy = salloc((char *)file_list);
  for (tok = strtok(copy, " \t\r\n"); tok != NULL;
       tok = strtok(NULL, " \t\r\n"))
    if (*tok != '\0')
      remove(tok);
  free(copy);
}

/*
 * Run the C compiler on each generated .c file, with up to max_jobs
 * processes at a time (fork pool when max_jobs > 1). file_list is
 * space-separated paths. Returns 0 on success, non-zero on failure.
 */
static int rtt_parallel_cc(const char *ccomp, const char *copts,
                           const char *file_list, int silent) {
  char *copy, *copy2, *tok, *cmd;
  size_t cmdlen;
  int nfiles, i, fi, max_jobs, nchild, wstatus, fail;
  pid_t pid;
  char **files;

  if (ccomp == NULL)
    ccomp = "cc";
  if (copts == NULL)
    copts = "";

  while (*file_list != '\0' && isspace((unsigned char)*file_list))
    file_list++;

  if (*file_list == '\0')
    return 0;

  copy = salloc((char *)file_list);
  nfiles = 0;
  for (tok = strtok(copy, " \t\r\n"); tok != NULL;
       tok = strtok(NULL, " \t\r\n"))
    if (*tok != '\0')
      nfiles++;
  free(copy);
  if (nfiles == 0)
    return 0;

  files = (char **)alloc((unsigned int)(nfiles * sizeof(char *)));
  copy2 = salloc((char *)file_list);
  i = 0;
  for (tok = strtok(copy2, " \t\r\n"); tok != NULL;
       tok = strtok(NULL, " \t\r\n"))
    if (*tok != '\0')
      files[i++] = salloc(tok);
  free(copy2);

  max_jobs = rtt_cc_max_jobs();
  if (max_jobs < 1)
    max_jobs = 1;

  /*
   * Serial: must compile every file — do not use "only files[0]" when
   * max_jobs==1 and nfiles>1 (that skipped f_*.c / o_*.c and broke ar rt.a).
   */
  if (max_jobs == 1) {
    fail = 0;
    for (i = 0; i < nfiles; i++) {
      rtt_progress_cc(files[i]);
      cmdlen = strlen(ccomp) + strlen(copts) + strlen(files[i]) + 16;
      cmd = (char *)alloc((unsigned int)cmdlen);
      sprintf(cmd, "%s -c %s %s", ccomp, copts, files[i]);
      if (!silent) {
        fprintf(stdout, "%s\n", cmd);
        fflush(stdout);
      }
      if (system(cmd) != 0)
        fail = 1;
      free(cmd);
      if (fail)
        break;
    }
    for (i = 0; i < nfiles; i++)
      free(files[i]);
    free(files);
    return fail;
  }

  fi = 0;
  nchild = 0;
  fail = 0;
  while (fi < nfiles || nchild > 0) {
    while (nchild < max_jobs && fi < nfiles && !fail) {
      rtt_progress_cc(files[fi]);
      cmdlen = strlen(ccomp) + strlen(copts) + strlen(files[fi]) + 16;
      cmd = (char *)alloc((unsigned int)cmdlen);
      sprintf(cmd, "%s -c %s %s", ccomp, copts, files[fi]);
      if (!silent) {
        fprintf(stdout, "%s\n", cmd);
        fflush(stdout);
      }
      pid = fork();
      if (pid < 0) {
        fprintf(stderr, "%s: fork failed\n", progname);
        free(cmd);
        fail = 1;
        break;
      }
      if (pid == 0) {
        execl("/bin/sh", "sh", "-c", cmd, (char *)NULL);
        _exit(127);
      }
      free(cmd);
      fi++;
      nchild++;
    }
    if (fail)
      break;
    if (nchild == 0)
      break;
    pid = waitpid(-1, &wstatus, 0);
    if (pid < 0) {
      fprintf(stderr, "%s: waitpid failed\n", progname);
      fail = 1;
      break;
    }
    nchild--;
    if (!WIFEXITED(wstatus) || WEXITSTATUS(wstatus) != 0)
      fail = 1;
  }

  while (nchild > 0) {
    pid = waitpid(-1, &wstatus, 0);
    if (pid < 0)
      break;
    nchild--;
    if (!WIFEXITED(wstatus) || WEXITSTATUS(wstatus) != 0)
      fail = 1;
  }

  for (i = 0; i < nfiles; i++)
    free(files[i]);
  free(files);
  return fail;
}
#endif /* HAVE_WORKING_FORK */

int main(int argc, char **argv)
   {
   int c;
   int nopts;
   char buf[MaxFileName];               /* file name construction buffer */
   struct fileparts *fp;
   int keeptmp = 0;

   /*
    * See if the location of include files has been patched into the
    *  rtt executable.
    */
   if ((int)strlen(patchpath) > 18)
      refpath = patchpath+18;
   else if (strlen(refpath)==0)
      refpath = relfile(argv[0], "/../");

   /*
    * Initialize the string table and indicate that File must be treated
    *  as a typedef name.
    */
   init_str();
   add_tdef("FILE");

   /*
    * By default, the spelling of white space in unimportant (it can
    *  only be significant with the -E option) and #line directives
    *  are required in the output.
    */
   whsp_image = NoSpelling;
   line_cntrl = 1;

   /*
    * opt_lst and opt_args are the options and corresponding arguments
    *  that are passed along to the preprocessor initialization routine.
    *  Their number is at most the number of arguments to rtt.
    */
   opt_lst = (char *)alloc((unsigned)argc);
   opt_args = (char **)alloc((unsigned)(sizeof (char *)) * argc);
   nopts = 0;

   /*
    * Process options.
    */
   while ((c = getopt(argc, argv, ostr)) != EOF)
      switch (c) {
         case 'E': /* run preprocessor only */
            pp_only = 1;
            if (whsp_image == NoSpelling)
               whsp_image = NoComment;
            break;
     case 'K':              /* Do not remove files */
            keeptmp = 1;
            break;
         case 'C':  /* retain spelling of white space, only effective with -E */
            whsp_image = FullImage;
            break;
         case 'P': /* do not produce #line directives in output */
            line_cntrl = 0;
            break;
         case 'A': /* produce a .a archive file, as if rttfull.cur */
            archive_flg = 1;
            break;
         case 'c': /* go ahead and C compile */
            ccomp_flg = 1;
            break;
         case 's': /* silent */
            silent = 1;
            break;
         case 'O': /* options to pass to C compiler */
            ccomp_opts = optarg;
            ++nopts;
            break;
         case 'd': /* -d name: name of data base */
            dbname = optarg;
            break;
#ifdef ConsoleWindow
         case 'q':
            ConsolePause = 0;
            break;
#endif                                  /* ConsoleWindow */
         case 'r':  /* -r path: location of include files */
            refpath = optarg;
            break;
         case 't':  /* -t ident : treat ident as a typedef name */
            add_tdef(optarg);
            break;
         case 'x':  /* produce code for interpreter rather than compiler */
            iconx_flg = 1;
            break;
         case 'j': /* max parallel gcc -c jobs (Unix, with -c); Makefile uses -j
                      $(RTT_CC_JOBS) */
         {
           char *ej;
           long v;

           v = strtol(optarg, &ej, 10);
           if (ej == optarg || v < 1 || v > 1024)
             show_usage();
           rtt_cc_jobs_cli = (int)v;
         } break;
         case 'D':  /* define preprocessor symbol */
         case 'I':  /* path to search for preprocessor includes */
         case 'U':  /* undefine preprocessor symbol */

            /*
             * Save these options for the preprocessor initialization routine.
             */
            opt_lst[nopts] = c;
            opt_args[nopts] = optarg;
            ++nopts;
            break;
         default:
            show_usage();
         }

#ifdef Rttx
   if (!iconx_flg) {
      fprintf(stdout,
         "rtt was compiled to only support the intepreter, use -x\n");
      exit(EXIT_FAILURE);
      }
#endif                                  /* Rttx */

   if (iconx_flg)
      compiler_def = "#define COMPILER 0\n";
   else
      compiler_def = "#define COMPILER 1\n";
   in_header = (char *)alloc((unsigned)strlen(refpath) +
      (unsigned)strlen(grttin_path) + 1);
   strcpy(in_header, refpath);
   strcat(in_header, grttin_path);
   inclname = (char *)alloc((unsigned)strlen(refpath) +
      (unsigned)strlen(rt_path) + 1);
   strcpy(inclname, refpath);
   strcat(inclname, rt_path);

   opt_lst[nopts] = '\0';

   /*
    * At least one file name must be given on the command line, except
    * if -A was used.
    */
   if ((optind == argc) && !archive_flg)
     show_usage();

   /*
    * When creating the compiler run-time system, rtt creates a string that
    *  is a space-separated list of names of C files created, because most
    *  of the file names are not derived from the names of the input files.
    */
   if (!iconx_flg) {
      curlst_string = strdup("");
      }

   /*
    * Unless the input is only being preprocessed, set up the in-memory data
    *  base (possibly loading it from a file).
    */
   if (!pp_only) {
      fp = fparse(dbname);
      if (*fp->ext == '\0')
         dbname = salloc(makename(buf, SourceDir, dbname, DBSuffix));
      else if (!smatch(fp->ext, DBSuffix))
         err2("bad data base name:", dbname);
      loaddb(dbname);
      }

   /*
    * Scan file name arguments, and translate the files.
    */
   while (optind < argc)  {

#if MVS
      src_file_nm = argv[optind];
#endif                                  /* MVS */

#if WildCards
      FINDDATA_T fd;

      if (!FINDFIRST(argv[optind], &fd)) {
         fprintf(stderr,"File %s: no match\n", argv[optind]);
         fflush(stderr);
         exit(EXIT_FAILURE);
         }
      do {
         argv[optind] = FILENAME(&fd);
         rtt_progress_file(argv[optind]);
         trans(argv[optind]);
      } while (FINDNEXT(&fd));
      FINDCLOSE(&fd);
#else                                   /* WildCards */
     rtt_progress_file(argv[optind]);
     trans(argv[optind]);
#endif                                  /* WildCards */
      optind++;
      }

#ifndef Rttx
   /*
    * Unless the user just requested the preprocessor be run, we
    *   have created C files and updated the in-memory data base.
    *   If this is the compiler's run-time system, we must dump the
    *   data base to a file and create a list of all output files
    *   produced in all runs of rtt that created the data base.
    */
   if (!(pp_only || iconx_flg)) {

#if NT
      /*
       * We used to write out an rttcur.lnk file of filenames with .c extensions
       * for a separate invocation of gcc or lcc but that is now subsumed by
       * curlst_string.
       */
#endif                                  /* NT */
      dumpdb(dbname);
      full_lst();
      if (archive_flg) {
         char *archive_line;
         struct stat sb;

         archive_line = alloc(strlen("ar qc rt.a ") +
                         strlen(fulllst_string) + strlen(ccomp_opts) + 3);

         if (stat("rt.a", &sb) == 0)
            remove("rt.a");

         if (ccomp_opts == NULL) ccomp_opts = "";

         sprintf(archive_line, "%s %s %s", "ar qc rt.a",
                 fulllst_string, ccomp_opts);

         rtt_progress_file("ar rt.a");
         if (!silent)
            fprintf(stdout, "%s\n", archive_line);
#if NT
         /*
          * Expand globs and split like CmdParamToArgv (see unicon_win32_* in mlocal.c),
          * then spawn ar with an explicit argv (same idea as Unix system(archive_line)).
          */
         {
            char **ar_argv;
            int ar_argc;
            intptr_t rc;

            ar_argc = unicon_win32_cmdline_to_argv(archive_line, &ar_argv, 0);
            if (ar_argc < 1 || ar_argv == NULL) {
               if (ar_argv != NULL)
                  unicon_win32_argv_free(ar_argc, ar_argv);
               return EXIT_FAILURE;
               }
            rc = _spawnvp(_P_WAIT, ar_argv[0],
                          (const char *const *)ar_argv);
            unicon_win32_argv_free(ar_argc, ar_argv);
            if (rc == (intptr_t)-1 || rc != 0)
               return EXIT_FAILURE;
         }
#else
         if (system(archive_line))
            return EXIT_FAILURE;
#endif
         }
      }
#endif                                  /* Rttx */

   if ( yynerrs > 0 || __merr_errors > 0)
      return EXIT_FAILURE;

   /*
    * If -c was used, go ahead and invoke a C compiler on curlst_string.
    * If the compile did not report an error, remove the .c files afterwards
    * unless the keeptmp option is present.
    * Note that the remove command is at present hardwired to "rm"; for
    * greater portability (e.g. Windows) perhaps it should be rewritten to
    * a loop of C library remove() calls.
    */
   if (ccomp_flg) {
      char *ccomp_line;
      if (ccomp_opts == NULL) ccomp_opts = "";
#ifdef HAVE_WORKING_FORK
      if (rtt_parallel_cc(CComp, ccomp_opts, curlst_string, silent))
        return EXIT_FAILURE;
      if (0 == keeptmp)
        rtt_remove_c_files(curlst_string);
#else  /* HAVE_WORKING_FORK */
      ccomp_line = alloc(strlen(CComp) + strlen(ccomp_opts) +
                         strlen(curlst_string) + 6);
      sprintf(ccomp_line, "%s -c %s%s", CComp, ccomp_opts, curlst_string);
      {
        char *ccopy, *ctok;
        ccopy = salloc(curlst_string);
        for (ctok = strtok(ccopy, " \t\r\n"); ctok != NULL;
             ctok = strtok(NULL, " \t\r\n"))
          if (*ctok != '\0')
            rtt_progress_cc(ctok);
        free(ccopy);
      }
      if (!silent) { fprintf(stdout, "%s\n", ccomp_line); fflush(stdout); }
      if (system(ccomp_line)) return EXIT_FAILURE;
      if (0 == keeptmp) {
        sprintf(ccomp_line, "%s%s", "rm", curlst_string);
        if (!silent) { fprintf(stdout, "%s\n", ccomp_line); fflush(stdout); }
        if (system(ccomp_line)) return EXIT_FAILURE;
      }
#endif /* HAVE_WORKING_FORK */
   }

   return EXIT_SUCCESS;
   }

/*
 * trans - translate a source file.
 */
void trans(char *src_file)
   {
   char *cname;
   char buf[MaxFileName];               /* file name construction buffer */
   char *buf_ptr;
   char *s;
   struct fileparts *fp;
   struct tdefnm *td;
   struct token *t;
   static char *test_largeints = "#ifdef LargeInts\nyes\n#endif\n";
   static int first_time = 1;

   cur_src = src_file;

   /*
    * Read standard header file for preprocessor directives and
    * typedefs, but don't write anything to output.
    */
   enable_out = 0;
   init_preproc(in_header, opt_lst, opt_args);
   str_src("<rtt initialization>", compiler_def, (int)strlen(compiler_def));
   init_sym();
   for (td = tdefnm_lst; td != NULL; td = td->next)
      sym_add(TypeDefName, td->name, OtherDcl, 1);
   init_lex();
   yyparse();
   if (first_time) {
      first_time = 0;
      /*
       * Now that the standard include files have been processed, see if
       *  Largeints is defined and make sure it matches what's in the data base.
       */
      s = "NoLargeInts";
      str_src("<rtt initialization>", test_largeints,
         (int)strlen(test_largeints));
      while ((t = preproc()) != NULL)
          if (strcmp(t->image, "yes"))
             s = "LargeInts";
      if (largeints == NULL)
         largeints = s;
      else if (strcmp(largeints, s) != 0)
         err2("header file definition of LargeInts/NoLargeInts does not match ",
            dbname);
      }
   enable_out = 1;

   /*
    * Make sure we have a .r file or standard input.
    */
   if (strcmp(cur_src, "-") == 0) {
      source("-"); /* tell preprocessor to read standard input */
      cname = salloc(makename(buf, TargetDir, "stdin", CSuffix));
      }
   else {
      fp = fparse(cur_src);
      if (*fp->ext == '\0')
         cur_src = salloc(makename(buf, SourceDir, cur_src, RttSuffix));
      else if (!smatch(fp->ext, RttSuffix))
         err2("unknown file suffix ", cur_src);
      cur_src = spec_str(cur_src);

      /*
       * For the compiler, remove from the data base the list of
       *  files produced from this input file.
       */
      if (!iconx_flg)
         clr_dpnd(cur_src);
      source(cur_src);  /* tell preprocessor to read source file */
      /*
       * For the interpreter prepend "x" to the file name for the .c file.
       */

#if MVS
      if (*fp->member != '\0') {
         char buf2[MaxFileName];
         sprintf(buf2, "%s%s%s(%s%s", fp->dir, fp->name, fp->ext,
                 iconx_flg? "x": "", fp->member);
         makename(buf, TargetDir, buf2, CSuffix);
         }
         else
#endif                                  /* MVS */

      buf_ptr = buf;
      if (iconx_flg)
         *buf_ptr++ = 'x';
      makename(buf_ptr, TargetDir, cur_src, CSuffix);
      cname = salloc(buf);
      }

   if (pp_only)
      output(stdout); /* invoke standard preprocessor output routine */
   else {
      /*
       * For the compiler, non-RTL code is put in a file whose name
       *  is derived from input file name. The flag def_fnd indicates
       *  if anything interesting is put in the file.
       */
      def_fnd = 0;
      if ((out_file = fopen(cname, "w")) == NULL)
         err2("cannot open output file ", cname);
      else
         addrmlst(cname, out_file);
      prologue(); /* output standard comments and preprocessor directives */
      yyparse();  /* translate the input */
      fprintf(out_file, "\n");

      if (rmlst_empty_p() == 0) {
         if (fclose(out_file) != 0)
            err2("cannot close ", cname);
         else   /* can't close it again if we remove it to due an error */
            markrmlst(out_file);
         }

      /*
       * For the Compiler, note the name of the "primary" output file
       *  in the data base and list of created files.
       */
      if (!iconx_flg)
         put_c_fl(cname, def_fnd);
      }
   }

/*
 * add_tdef - add identifier to list of typedef names.
 */
static void add_tdef(char *name)
   {
   struct tdefnm *td;

   td = NewStruct(tdefnm);
   td->name = spec_str(name);
   td->next = tdefnm_lst;
   tdefnm_lst = td;
   }

/*
 * Add name of file to the output list, and if it contains "interesting"
 *  code, add it to the dependency list in the data base.
 */
void put_c_fl(char *fname, int keep)
   {
   struct fileparts *fp;
   int oldlen = strlen(curlst_string);

   fp = fparse(fname);

   curlst_string = realloc(curlst_string,oldlen + strlen(fp->name)+4);
   sprintf(curlst_string + oldlen, " %s.c", fp->name);

   if (keep)
      add_dpnd(src_lkup(cur_src), fname);
   }

/*
 * Print an error message if called incorrectly.
 */
void show_usage()
   {
   fprintf(stderr, "usage: %s %s\n", progname, options);
   exit(EXIT_FAILURE);
   }
