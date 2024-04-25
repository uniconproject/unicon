/*
 * cmem.c -- memory initialization and allocation for the translator.
 */
#include "../h/gsupport.h"
#include "cglobals.h"
#include "ctrans.h"
#include "csym.h"
#include "ctree.h"
#include "ccode.h"
#include "cproto.h"

struct centry *chash[CHSize];           /* hash area for constant table */
struct fentry *fhash[FHSize];           /* hash area for field table */
struct gentry *ghash[GHSize];           /* hash area for global table */

struct implement *bhash[IHSize];        /* hash area for built-in functions */
struct implement *khash[IHSize];        /* hash area for keywords */
struct implement *ohash[IHSize];        /* hash area for operators */

struct implement *spec_op[NumSpecOp];   /* table of ops with special syntax */

char pre[PrfxSz] = {'0', '0', '0'};     /* initial function name prefix */

extern struct str_buf lex_sbuf;


/*
 * init - initialize memory for the translator
 */

void init()
{
   int i;

   init_str();
   init_sbuf(&lex_sbuf);

   /*
    * Zero out the hash tables.
    */
   for (i = 0; i < CHSize; i++)
      chash[i] = NULL;
   for (i = 0; i < FHSize; i++)
      fhash[i] = NULL;
   for (i = 0; i < GHSize; i++)
      ghash[i] = NULL;
   for (i = 0; i < IHSize; i++) {
      bhash[i] = NULL;
      khash[i] = NULL;
      ohash[i] = NULL;
      }

   /*
    * Clear table of operators with non-standard operator syntax.
    */
   for (i = 0; i < NumSpecOp; ++i)
      spec_op[i] = NULL;
   }

/*
 * init_proc - add a new entry on front of procedure list.
 */
extern
struct gentry *
init_proc(char *name)
{
   int i;
   struct gentry *sym_ent;
   register struct pentry *p;

   p = NewStruct(pentry);
   p->name = name;
   nxt_pre(p->prefix, pre, PrfxSz);
   p->prefix[PrfxSz] = '\0';
   p->nargs = 0;
   p->args = NULL;
   p->ndynam = 0;
   p->dynams = NULL;
   p->nstatic = 0;
   p->has_coexpr = 0;
   p->statics = NULL;
   p->ret_flag = DoesRet | DoesFail | DoesSusp; /* start out pessimistic */
   p->arg_lst = 0;
   p->lhash =
     (struct lentry **)alloc((unsigned int)((LHSize)*sizeof(struct lentry *)));
   for (i = 0; i < LHSize; i++)
      p->lhash[i] = NULL;
   p->next = proc_lst;
   proc_lst = p;
   sym_ent = instl_p(name, F_Proc);
   sym_ent->val.proc = proc_lst;

   return sym_ent;
}

static
int
rec_is_obj(char * name)
{
   int len;

   if ((len = strlen(name)) < 15)
      return 0;
   if (strcmp("__state", (char *)(name + len - 7)) == 0)
      return 1;
   return 0;
}

/*
 * init_rec - add a new entry on the front of the record list.
 */
void
init_rec(char * name)
{
   int flags;
   register struct rentry *r;
   struct gentry *sym_ent;
   static int rec_num = 0;

   flags = F_Record;
   if (rec_is_obj(name))
      flags |= F_Object;
   /*printf("mdw: init_rec: rec \"%s\" assigned #%d.\n", name, rec_num);*/
   r = NewStruct(rentry);
   r->name = name;
   nxt_pre(r->prefix, pre, PrfxSz);
   r->prefix[PrfxSz] = '\0';
   r->rec_num = rec_num++;
   r->nfields = 0;
   r->fields = NULL;
   r->next = rec_lst;
   rec_lst = r;
   sym_ent= instl_p(name, flags);
   sym_ent->val.rec = r;
}

#ifdef IconcLogAllocations
static
void *
alloc_original(unsigned int n)
{
   register void * a;

   if (n == 0) /* Work-around for 0 allocation */
      n = 1;

   a = calloc((msize)n,sizeof(char));
   if (a == NULL) {
      fprintf(stderr, "alloc(%d): out of memory\n", (int)n);
      exit(EXIT_FAILURE);
      }
   return a;
}

#define AlcTblSize (512)

struct alc_ent {
   int line_num;
   char * fname;
   unsigned long total_bytes;
   struct alc_ent * next;
   };

struct alc_ent * alc_tbl[AlcTblSize] = { 0 };

static
void
add_alloc_entry(unsigned int n, char * fname, int line)
{
   unsigned h;
   struct alc_ent * ent;

   h = line & (AlcTblSize - 1);
   for (ent=alc_tbl[h]; ent; ent=ent->next) {
      if (ent->line_num != line)
         continue;
      if (strcmp(ent->fname, fname) == 0) {
         ent->total_bytes += (unsigned long)n;
         return;
         }
      }
   ent = malloc(sizeof(struct alc_ent));
   ent->fname = fname;
   ent->line_num = line;
   ent->total_bytes = (unsigned long)n;
   ent->next = alc_tbl[h];
   alc_tbl[h] = ent;
}

extern
void
alc_stats(void)
{
   int i, k;
   struct alc_ent * ent;
   unsigned long n_bytes;
   unsigned long max_val;
   struct alc_ent * max_ent;

   printf("  ### alc-stats bgn ###\n");

   n_bytes = 0L;
   for (i=0; i<AlcTblSize; i++) {
      for(ent=alc_tbl[i]; ent; ent=ent->next)
         n_bytes += ent->total_bytes;
      }
   max_val = 1L;
   while (max_val > 0L) {
      max_val = 0L;
      for (i=0; i<AlcTblSize; i++) {
         for (ent=alc_tbl[i]; ent; ent=ent->next) {
            if (ent->total_bytes > max_val) {
               max_ent = ent;
               max_val = ent->total_bytes;
               }
            }
         }
         printf("  %d.%s: %ld bytes\n", max_ent->line_num, max_ent->fname,
            max_ent->total_bytes);
         max_ent->total_bytes = 0UL;
      }
   printf("  *** total-bytes: %ld\n", n_bytes);
   printf("  ### alc-stats end ###\n");
}

pointer
_alloc(unsigned int n, char * fname, int line)
{
   pointer rslt;

   add_alloc_entry(n, fname, line);
   rslt = alloc_original(n);
   return rslt;
}
#endif                                  /* IconcLogAllocations */
