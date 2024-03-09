/*
 * ctrans.c - main control of the translation process.
 */
#include "../h/gsupport.h"
#include "cglobals.h"
#include "ctrans.h"
#include "csym.h"
#include "ctree.h"
#include "ctoken.h"
#include "ccode.h"
#include "cproto.h"
#include "ca.h"
#include "../h/auto.h"

/*
 * Prototypes.
 */
static void adjust_class_recs(struct rentry *);
static void publish_unreachable_funcs(struct pentry *);
/* mdw: for ca static */ void   trans1(char *);

/*
 * Variables.
 */
int __merr_errors = 0;          /* total number of fatal errors */
int twarns = 0;                 /* total number of warnings */
int nocode;                     /* set by lexer; unused in compiler */
int in_line;                    /* current input line number */
int incol;                      /* current input column number */
int peekc;                      /* one-character look ahead */
struct srcfile *srclst = NULL;  /* list of source files to translate */

extern char *lpath;                     /* LPATH value */


/*
 * This routine walks through rec_lst looking for object instance records,
 * and removes those fields from said instance records that correspond to
 * methods contained in the vector table (vtbl) for said object.  It is
 * unfortunately O(n^2) where n is the size of recs.  This routine is
 * only invoked once, though (after type inferencing), so it shouldn't be
 * a problem yet.
 */
static
void
adjust_class_recs(recs)
   struct rentry * recs;
{
   int nflds;
   char * p, * q;
   struct fldname * f;
   struct rentry * rinst;
   struct rentry * rmeth;

   for (rinst=recs; rinst; rinst=rinst->next) {
      if ((p = strstr(rinst->name, "__state")) == NULL)
         continue;
      for (rmeth=rinst->next; rmeth; rmeth=rmeth->next) {
         if ((q = strstr(rmeth->name, "__methods")) == NULL)
            continue;
         if (p - rinst->name != q - rmeth->name)
            continue;
         if (strncmp(rinst->name, rmeth->name, p - rinst->name))
            continue;
         /*
         printf("mdw-adjust-recs: found vtbl %s for inst %s.\n",
            rmeth->name, rinst->name);
         printf("mdw-adjust-recs: vtbl flds: %d inst flds: %d.\n",
            rmeth->nfields, rinst->nfields);
         */
         nflds = rinst->nfields - rmeth->nfields;
         while (rinst->nfields > nflds) {
            f = rinst->fields;
            rinst->fields = rinst->fields->next;
            free(f);
            rinst->nfields--;
            }
         break;
         }
      }
}


static
void
publish_unreachable_funcs(pents)
   struct pentry * pents;
{
   unsigned long n;
   unsigned long nun;
   struct pentry * p;

   fprintf(codefile, "/*\n * unreachable functions:\n *\n");
   n = 0UL;
   nun = 0UL;
   for (p=pents; p; p=p->next,n++) {
      if (p->reachable)
         continue;
      nun++;
      fprintf(codefile, " *    %s\n", p->name);
      }
   fprintf(codefile, " *\n * %ld of %ld functions are unreachable.\n", nun, n);
   fprintf(codefile, " */\n\n");
}

/*
 * translate a number of files, returning an error count
 */
int trans(char *argv0)
   {
   register struct pentry *proc;
   struct srcfile *sf;
   extern char * ca_first_perifile;
   extern int ca_mark_parsed(char *);

   lpath = (char *)libpath(argv0, "LPATH");     /* remains null if unspecified */

   if (opt_ca && ca_first_perifile) {
      /*
       * translate all non-peri files
       */
      for (sf = srclst; sf != NULL; sf = sf->next) {
         if (strcmp(sf->name, ca_first_perifile) == 0)
            break;
         trans1(sf->name);
         ca_mark_parsed(sf->name);
         }
      /*
       * resolve all remaining symbols
       */
      ca_resolve();
      ca_cleanup();
      }
   else {
      for (sf = srclst; sf != NULL; sf = sf->next)
         trans1(sf->name);      /* translate each file in turn */
      }

   if (!pponly) {
      /*
       * Resolve undeclared references.
       */
      for (proc = proc_lst; proc != NULL; proc = proc->next)
         resolve(proc);

#ifdef DeBug
      symdump();
#endif                                  /* DeBug */

      if (__merr_errors == 0) {
         chkstrinv();  /* see what needs be available for string invocation */
         chkinv();     /* perform "naive" optimizations */
         }

      if (__merr_errors == 0)
         typeinfer();        /* perform type inference */

      if (just_type_trace)
         return __merr_errors;     /* stop without generating code */

      publish_unreachable_funcs(proc_lst);

      if (__merr_errors == 0) {
         adjust_class_recs(rec_lst);
         var_dcls();         /* output declarations for globals and statics */
         const_blks();       /* output blocks for cset and real literals */
         for (proc = proc_lst; proc != NULL; proc = proc->next)
            proccode(proc);  /* output code for a procedure */
         recconstr(rec_lst); /* output code for record constructors */
         }
      }

   /*
    * Report information about errors and warnings and be correct about it.
    */
   if (__merr_errors == 1)
      fprintf(stderr, "1 error; ");
   else if (__merr_errors > 1)
      fprintf(stderr, "%d errors; ", __merr_errors);
   else if (verbose > 0)
      fprintf(stderr, "No errors; ");

   if (twarns == 1)
      fprintf(stderr, "1 warning\n");
   else if (twarns > 1)
      fprintf(stderr, "%d warnings\n", twarns);
   else if (verbose > 0)
      fprintf(stderr, "no warnings\n");
   else if (__merr_errors > 0)
      fprintf(stderr, "\n");

#ifdef TranStats
   tokdump();
#endif                                  /* TranStats */

   return __merr_errors;
   }

/*
 * translate one file.
 */
/* mdw: for ca... static */
void trans1(filename)
char *filename;
   {
   in_line = 1;                 /* start with line 1, column 0 */
   incol = 0;
   peekc = 0;                   /* clear character lookahead */

   if (!ppinit(filename, lpath, m4pre)) {
      tfatal(filename, "cannot open source file");
      return;
      }
   if (!largeints)              /* undefine predef symbol if no -l option */
      ppdef("_LARGE_INTEGERS", (char *)NULL);
   ppdef("_MULTITASKING", (char *)NULL);        /* never defined in compiler */
   ppdef("_EVENT_MONITOR", (char *)NULL);
#ifdef NoConcurrentCOMPILER
   ppdef("_CONCURRENT", (char *)NULL);
#endif
   ppdef("_OVLD", (char *)NULL);
   ppdef("_MEMORY_MONITOR", (char *)NULL);
   ppdef("_VISUALIZATION", (char *)NULL);

   if (strcmp(filename,"-") == 0)
      filename = "stdin";
   if (strstr(filename, "/uni") && strstr(filename, "-iconc")) {
      if (verbose > 1)
         fprintf(stderr, "%s:\n",filename);
      }
   else
      if (verbose > 0)
         fprintf(stderr, "%s:\n",filename);

   tok_loc.n_file = filename;
   in_line = 1;

   if (pponly)
      ppecho();                 /* preprocess only */
   else
      yyparse();                                /* Parse the input */
   }

/*
 * writecheck - check the return code from a stdio output operation
 *
mdw: this is unreferenced...
 *
void writecheck(rc)
   int rc;
   {
   if (rc < 0)
      quit("unable to write to icode file");
   }
*/

/*
 * lnkdcl - find file locally or on LPATH and add to source list.
 */
void lnkdcl(name)
char *name;
{
/* mdw: unrefd locals
   struct srcfile **pp;
   struct srcfile *p;
*/
   char buf[MaxFileName];

   if (pathfind(buf, lpath, name, SourceSuffix))
      /* mdw src_file(buf); */
      src_file(buf, &srclst);
   else
      tfatal("cannot resolve reference to file name", name);
      }


void src_file(name, srclist)
char *name;
struct srcfile **srclist;
   {
   struct srcfile **pp;
   struct srcfile *p;

   for (pp = srclist; *pp != NULL; pp = &(*pp)->next)
     if (strcmp((*pp)->name, name) == 0)
        return;
   p = NewStruct(srcfile);
   p->name = salloc(name);
   p->next = NULL;
   *pp = p;
}
