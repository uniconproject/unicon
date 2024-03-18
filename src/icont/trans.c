/*
 * trans.c - main control of the translation process.
 */

#include "../h/gsupport.h"
#include "tproto.h"
#include "../h/version.h"
#include "tglobals.h"
#include "tsym.h"
#include "tree.h"
#include "ttoken.h"

/*
 * Prototypes.
 */

static  void    trans1          (char *filename);
void writeUID(char *, FILE *);
extern int __merr_errors;       /* in place of the old tfatals, the number of syntax errors in a file */
int afatals;                    /* total number of fatal errors */
int nocode;                     /* non-zero to suppress code generation */
int in_line;                    /* current input line number */
int incol;                      /* current input column number */
int peekc;                      /* one-character look ahead */

/*
 * translate a number of files, returning an error count
 */
int trans(char **ifiles)
   {
   tmalloc();                   /* allocate memory for translation */

   afatals = 0;

#ifdef MultipleRuns
   yylexinit();                 /* initialize lexical analyser */
   tcodeinit();                 /* initialize code generator */
#endif                                  /* Multiple Runs */

   while (*ifiles) {
      trans1(*ifiles++);        /* translate each file in turn */
      afatals += __merr_errors;
      }

   tmfree();                    /* free memory used for translation */

   /*
    * Report information about errors and warnings and be correct about it.
    */
   if (afatals == 1)
      report("1 error\n");
   else if (afatals > 1) {
      char tmp[24];
      sprintf(tmp, "%d errors\n", afatals);
      report(tmp);
      }
   else
      report("No errors\n");

   return afatals;
   }

extern char *pofile;
/*
 * translate one file.
 */
static void trans1(char *filename)
{
   char oname1[MaxFileName];    /* buffer for constructing file name */
   char oname2[MaxFileName];    /* buffer for constructing file name */
   char oname3[MaxFileName];    /* buffer for constructing file name */

   __merr_errors = 0;                   /* reset error counts */
   nocode = 0;                  /* allow code generation */
   in_line = 1;                 /* start with line 1, column 0 */
   incol = 0;
   peekc = 0;                   /* clear character lookahead */

   if (!ppinit(filename,lpath,m4pre))
      quitf("cannot open %s",filename);

   if (pofile != NULL) {
      filename = pofile;
      pofile = NULL;
      }
   else if (strcmp(filename,"-") == 0) {
      filename = "stdin";
      }

   report(filename);

   if (pponly) {
      ppecho();
      return;
      }

   /*
    * Form names for the .u1 and .u2 files and open them.
    *  Write the ucode version number to the .u2 file.
    */

   makename(oname1, TargetDir, filename, U1Suffix);

#if MVS || VM
/*
 * Even though the ucode data is all reasonable text characters, use
 *  of text I/O may cause problems if a line is larger than LRECL.
 *  This is likely to be true with any compiler, though the precise
 *  disaster which results may vary.
 *
 * On CMS (and sometimes on MVS), empty files are not readable later.
 *  Since the .U1 file may be empty, we start it off with an extra
 *  blank (thrown away on input) to make sure there's something there.
 */
   codefile = fopen(oname1, WriteBinary);   /* avoid line splits */
   if (codefile != NULL)
      putc(' ', codefile);
#else                                   /* MVS || VM */
   codefile = fopen(oname1, WriteText);
#endif                                  /* MVS || VM */

   if (codefile == NULL)
      quitf("cannot create %s", oname1);

   makename(oname2, TargetDir, filename, U2Suffix);

#if MVS || VM
   globfile = fopen(oname2, WriteBinary);
#else                                   /* MVS || VM */
   globfile = fopen(oname2, WriteText);
#endif                                  /* MVS || VM */

   if (globfile == NULL)
      quitf("cannot create %s", oname2);
   writecheck(fprintf(globfile,"version\t%s\n",UVersion));
   writeUID(oname1, globfile);

   tok_loc.n_file = filename;
   in_line = 1;

   tminit();                            /* Initialize data structures */
   yyparse();                           /* Parse the input */

   /*
    * Close the output files.
    */

   if (fclose(codefile) != 0 || fclose(globfile) != 0)
      quit("cannot close ucode file");

   if (__merr_errors) {
      remove(oname1);
      remove(oname2);
      }
   else {
      FILE *ftemp;
      int c;
      makename(oname3, TargetDir, filename, USuffix);
      /*
       * rename the .u2 file to be .u; append a control L and then the .u1.
       * If rename fails, copy and delete the old fashioned way.
       * The elaborate contortions are because rename() fails on Windows if
       * the target filename exists, and unlink seems unreliable there.
       */
      unlink(oname3);
      if ((c=rename(oname2, oname3)) != 0) {
         globfile = fopen(oname3, "w");
         if (globfile == NULL) quitf("cannot write ucode file %s", oname3);
         ftemp=fopen(oname2, "r");
         if (ftemp == NULL) quitf("cannot read ucode file %s", oname2);
         while ((c = getc(ftemp)) != EOF) putc(c, globfile);
         fclose(ftemp);
         unlink(oname2);
         /* leave globfile opened in write mode */
         }
      else
         globfile = fopen(oname3, "a");
      if (globfile == NULL) quitf("cannot append ucode file %s", oname3);
      putc('\014', globfile);
      putc('\n', globfile);
      codefile = fopen(oname1, "r");
      if (codefile == NULL) quit("cannot read .u2 component");
      while ((c = getc(codefile)) != EOF) putc(c, globfile);
      if (fclose(codefile) != 0 || fclose(globfile) != 0)
         quit("cannot close ucode file");
      remove(oname1);
      }
   }

/*
 * writecheck - check the return code from a stdio output operation
 */
void writecheck(int rc)
   {
   if (rc < 0)
      quit("cannot write to ucode file");
}

/*
 * writeUID - write a universal-unicon ID to the file
 */
#define RandA        1103515245 /* random seed multiplier */
#define RandC         453816694 /* random seed additive constant */
#define RanScale 4.65661286e-10 /* random scale factor = 1/(2^31-1) */
#define RandVal(RNDSEED) (RanScale*((RandA*RNDSEED+RandC)&0x7FFFFFFFL))
void writeUID(char *fname, FILE * f)
{
   time_t t;
   time(&t);
   writecheck(fprintf(f, "uid\t%s-%d-%d\n", fname, (int)t, (int)RandVal(t)));
}

