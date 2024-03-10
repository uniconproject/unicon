/*
 * This is iyacc's main.c; byacc's main.c with Java and Icon support.
 * iyacc needs to be updated to the current version of byacc!
 */

#include <signal.h>
#ifdef _MSC_VER
#include <stdlib.h>
#else
#include <unistd.h>             /* for _exit() */
#endif

#include "defs.h"

#if NT
#define tmpfile mstmpfile
#endif                                  /* NT */

char dflag;
char lflag;
char rflag;
char tflag;
char vflag;
char jflag;/*rwj -- for Java!*/
char iflag=1;
char threadflag;/*rwj -- for Java!*/
char *java_semantic_type;/*rwj -- for Java!*/

char *symbol_prefix;
char *file_prefix = "y";
char *java_class_name = "parser";/*rwj*/
char *java_extend_name = "Thread";/*rwj*/
char *myname = "yacc";
char *temp_form = "yacc.XXXXXXX";

int lineno;
int outline;

char *action_file_name;
char *code_file_name;
char *defines_file_name;
char *input_file_name = "";
char *output_file_name;
char *text_file_name;
char *union_file_name;
char *verbose_file_name;

FILE *action_file;      /*  a temp file, used to save actions associated    */
                        /*  with rules until the parser is written          */
FILE *code_file;        /*  y.code.c (used when the -r option is specified) */
FILE *defines_file;     /*  y.tab.h                                         */
FILE *input_file;       /*  the input file                                  */
FILE *output_file;      /*  y.tab.c                                         */
FILE *text_file;        /*  a temp file, used to save text until all        */
                        /*  symbols have been defined                       */
FILE *union_file;       /*  a temp file, used to save the union             */
                        /*  definition until all symbol have been           */
                        /*  defined                                         */
FILE *verbose_file;     /*  y.output                                        */

int nitems;
int nrules;
int nsyms;
int ntokens;
int nvars;

int   start_symbol;
char  **symbol_name;
short *symbol_value;
short *symbol_prec;
char  *symbol_assoc;

short *ritem;
short *rlhs;
short *rrhs;
short *rprec;
char  *rassoc;
short **derives;
char *nullable;

extern char *getenv();

/*
 * Since fclose() is called via the signal handler, it might die.  Don't loop
 * if there is a problem closing a file.
 */
#define DO_CLOSE(fp) \
        if (fp != 0) { \
            FILE *use = fp; \
            fp = 0; \
            fclose(use); \
        }

static int got_intr = 0;

void
done(int k)
{
    DO_CLOSE(action_file);
    DO_CLOSE(text_file);
    if (union_file) {
       DO_CLOSE(union_file);
#if NT
       remove(union_file_name);
#endif                                  /* NT */
       }

#if NT
    /* Windows tmpfile() is broken, attempt to delete the files. */
    remove(action_file_name);
    remove(text_file_name);
#endif                                  /* NT */

    if (got_intr)
        _exit(EXIT_FAILURE);

    exit(k);
}


void onintr(int flag)
{
    done(1);
}


void set_signals(void)
{
#ifdef SIGINT
    if (signal(SIGINT, SIG_IGN) != SIG_IGN)
        signal(SIGINT, onintr);
#endif
#ifdef SIGTERM
    if (signal(SIGTERM, SIG_IGN) != SIG_IGN)
        signal(SIGTERM, onintr);
#endif
#ifdef SIGHUP
    if (signal(SIGHUP, SIG_IGN) != SIG_IGN)
        signal(SIGHUP, onintr);
#endif
}


void usage(void)
{
/*
    fprintf(stderr,
     "usage:\n %s [--help] [-dlrtvjxf] [-b file_prefix]  [-p symbol_prefix] \n"
     "      [-s java_semantic_type] [-f class_name] filename\n", myname);
*/
    fprintf(stderr,
     "usage: %s [--help] [-d[d]] [-ilrtv] [-p symbol_prefix] filename\n", myname);

    exit(1);
}

/*
 * Give a longer, chatty help message
 */
void help(void)
{
   fprintf(stderr, "This is iyacc son of jyacc son of byacc. Tremble before me! Usage:\n");
   fprintf(stderr,
           "\n   %s [-d[d]] [-ilrtv] [-p symbol_prefix] filename\n", myname);
   fprintf(stderr, "\ntakes in a filename.y grammar and writes a filename.icn parser\n");
   fprintf(stderr, "\nOptions:\n\n");
   fprintf(stderr, "   -d                write a filename_tab.icn include file w/ token $define's\n");
   fprintf(stderr, "   -dd               produce java compatible object definitions\n");
   fprintf(stderr, "   -i                generate Icon/Unicon (default)\n");
   fprintf(stderr, "   -l                suppress line directives\n");
   fprintf(stderr, "   -p symbol_prefix  use symbol_prefix instead of yy\n");
   fprintf(stderr, "   -r                write separate files for code and tables\n");
   fprintf(stderr, "   -t                enable debugging\n");
   fprintf(stderr, "   -v                write verbose output to y.output\n");
   exit(1);
}

void getargs(int argc,char **argv)
{
    register int i;
    register char *s;

    if (argc > 0) myname = argv[0];
    for (i = 1; i < argc; ++i)
    {
        s = argv[i];
        if (*s != '-') break;
        switch (*++s)
        {
        case '\0':
            input_file = stdin;
            if (i + 1 < argc) usage();
            return;

        case '-':
            ++i;
            if (!strcmp(s, "-help")) {
               help();
               break;
               }
            fprintf(stderr, "user says no more options\n");
            goto no_more_options;

        case 'b':
            if (*++s)
                 file_prefix = s;
            else if (++i < argc)
                file_prefix = argv[i];
            else
                usage();
            continue;

        case 'd':
            dflag = 1;
            break;

        case 'l':
            lflag = 1;
            break;

        case 'p':
            if (*++s)
                symbol_prefix = s;
            else if (++i < argc)
                symbol_prefix = argv[i];
            else
                usage();
            continue;

        case 'r':
            rflag = 1;
            break;

        case 't':
            tflag = 1;
            break;

        case 'v':
            vflag = 1;
            break;

        case 'j':     /* rwj -- for Java!  */
            jflag = 1;
            iflag = 0;
            break;

        case 'i':
            iflag = 1;
            outline = -1;
            lineno  = -1;
            break;

        case 's':     /* rwj -- for Java!  */
            if (*++s)
                   java_semantic_type = s;
            else if (++i < argc)
                   java_semantic_type = argv[i];
            else
                   usage();
            continue;

        case 'f':     /* rwj -- for Java!  */
            if (*++s)
                   java_class_name = s;
            else if (++i < argc)
                   java_class_name = argv[i];
            else
                   usage();
            continue;

        case 'x':     /* rwj -- for Java!  */
            if (*++s)
                   java_extend_name = s;
            else if (++i < argc)
                   java_extend_name = argv[i];
            else
                   usage();
            continue;

        default:
            usage();
        }

        for (;;)
        {
            switch (*++s)
            {
            case '\0':
                goto end_of_option;

            case 'd':
                if (iflag) dflag++; /* -dd: java-compatible object define */
                else dflag = 1;
                break;

            case 'l':
                lflag = 1;
                break;

            case 'r':
                rflag = 1;
                break;

            case 't':
                tflag = 1;
                break;

            case 'v':
                vflag = 1;
                break;

            case 'j':        /* rwj -- for java*/
                jflag = 1;
                break;

            case 'i':
                iflag = 1;
                break;

     default:
                usage();
            }
        }
end_of_option:;
    }

no_more_options:;
    if (i + 1 != argc) usage();
    input_file_name = argv[i];
}


char *allocate(unsigned n)
{
    register char *p;

    p = NULL;
    if (n)
    {
        p = CALLOC(1, n);
        if (!p) no_space();
    }
    return (p);
}

void create_file_names(void)
{
    int i, len;
    char *tmpdir;

    tmpdir = getenv("TMPDIR");
#ifdef MSW  /*rwj -- make portable*/
    if (tmpdir == 0) tmpdir = ".";
#else
    if (tmpdir == 0) tmpdir = "/tmp";
#endif

    len = strlen(tmpdir);
    i = len + 13;
    if (len && tmpdir[len-1] != '/')
        ++i;

    action_file_name = MALLOC(i);
    if (action_file_name == 0) no_space();
    text_file_name = MALLOC(i);
    if (text_file_name == 0) no_space();
    union_file_name = MALLOC(i);
    if (union_file_name == 0) no_space();

    strcpy(action_file_name, tmpdir);
    strcpy(text_file_name, tmpdir);
    strcpy(union_file_name, tmpdir);

    if (len && tmpdir[len - 1] != '/')
    {
        action_file_name[len] = '/';
        text_file_name[len] = '/';
        union_file_name[len] = '/';
        ++len;
    }

    strcpy(action_file_name + len, temp_form);
    strcpy(text_file_name + len, temp_form);
    strcpy(union_file_name + len, temp_form);

    action_file_name[len + 5] = 'a';
    text_file_name[len + 5] = 't';
    union_file_name[len + 5] = 'u';

    if (jflag)/*rwj*/
      {
      len = strlen(java_class_name);

      output_file_name = MALLOC(len + 6);/*for '.java\0' */
      if (output_file_name == 0) no_space();
      strcpy(output_file_name, java_class_name);
      strcpy(output_file_name + len, JAVA_OUTPUT_SUFFIX);
      }

    else if (iflag)
      {
      len = strcspn(input_file_name, ".");

      output_file_name = MALLOC(len + 5);/*for '.icn\0' */
      if (output_file_name == 0) no_space();
      strncpy(output_file_name, input_file_name, len);
      strcpy(output_file_name + len, ICON_OUTPUT_SUFFIX);
      }

    else
      {
      len = strlen(file_prefix);

      output_file_name = MALLOC(len + 7);
      if (output_file_name == 0) no_space();
      strcpy(output_file_name, file_prefix);
      strcpy(output_file_name + len, OUTPUT_SUFFIX);
      }

    if (rflag)
    {
        code_file_name = MALLOC(len + 8);
        if (code_file_name == 0)
            no_space();
        strcpy(code_file_name, file_prefix);
        strcpy(code_file_name + len, CODE_SUFFIX);
    }
    else
        code_file_name = output_file_name;

    if (dflag)
    {
        if (iflag)
        {
            defines_file_name = MALLOC(len + 11);
            if (defines_file_name == 0)
              no_space();
            len = strcspn(input_file_name, ".");
            strncpy(defines_file_name, input_file_name, len);
            strcpy(defines_file_name + len, "_tab" ICON_OUTPUT_SUFFIX);
        }
        else
        {
            defines_file_name = MALLOC(len + 7);
            if (defines_file_name == 0)
              no_space();
            strcpy(defines_file_name, file_prefix);
            if (jflag)
                strcpy(defines_file_name + strlen(file_prefix), "tab.java");
            else
                strcpy(defines_file_name + len, DEFINES_SUFFIX);
        }
    }
    if (vflag)
    {
        verbose_file_name = MALLOC(len + 8);
        if (verbose_file_name == 0)
            no_space();
        strcpy(verbose_file_name, file_prefix);
        strcpy(verbose_file_name + len, VERBOSE_SUFFIX);
    }
}

#if NT
/*
 * mstmpfile() - because tmpfile() does not work reasonably on MS Windows.
 * This program only three temporary files and cleans them up explicitly.
 */
FILE *mstmpfile()
{
   char *temp;
   FILE *f;

   if ((temp = _tempnam(NULL, "uni")) == NULL) {
      fprintf(stderr, "_tempnam(TEMP) failed\n");
      return NULL;
      }

   if ((f = fopen(temp, "w+b")) == NULL) {
      fprintf(stderr, "fopen(%s) w+b failed: ", temp);
      perror("");
      free(temp);
      return NULL;
      }
   free(temp);
   return f;
}
#endif                                  /* NT */

void open_files(void)
{
    create_file_names();

    if (input_file == 0)
    {
        input_file = fopen(input_file_name, "r");
        if (input_file == 0)
            open_error(input_file_name);
    }

    action_file = tmpfile();
    if (action_file == 0)
        open_error("action_file");

    text_file = tmpfile();
    if (text_file == 0)
        open_error("text_file");

    if (vflag)
    {
        verbose_file = fopen(verbose_file_name, "w");
        if (verbose_file == 0)
            open_error(verbose_file_name);
    }

    if (dflag)
    {
        defines_file = fopen(defines_file_name, "w");
        if (defines_file == 0)
            open_error(defines_file_name);
        union_file = tmpfile();
        if (union_file ==  0)
            open_error("union_file");
    }

    output_file = fopen(output_file_name, "w");
    if (output_file == 0)
        open_error(output_file_name);

    if (rflag)
    {
        code_file = fopen(code_file_name, "w");
        if (code_file == 0)
            open_error(code_file_name);
    }
    else
        code_file = output_file;
}


int main(int argc,char **argv)
{
    set_signals();
    getargs(argc, argv);
    open_files();
    reader();
    lr0();
    lalr();
    make_parser();
    verbose();
    output();
    done(0);
    /*NOTREACHED*/
    return 1;
}
