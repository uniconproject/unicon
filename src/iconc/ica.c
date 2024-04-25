#include "../h/gsupport.h"
#include "ctrans.h"
#include "csym.h"
#include "ctree.h"
#include "ctoken.h"
#include "cglobals.h"
#include "ccode.h"
#include "cproto.h"
#include <sys/resource.h>
#include "ica.h"

#define If_Unused (1)

#define dbgmsg(args...) do { if (dbg) fprintf(stdout,args); } while (0)
#define errmsg(args...) do { fprintf(stderr,args); } while (0)

struct pcall {
   char * name;
   struct node * node;
   struct pcall * next;
   };

struct pdefn {
   struct gentry * ent;
   struct pdefn * next;
#define pdefn_flags(p) ((p)->ent->flag)
#define pdefn_name(p) ((p)->ent->name)
   };

struct rdecl {
   unsigned int iflgs;
   struct gentry * ent;
   struct rdecl * next;
#define rdecl_is_clsinst(p) ((p)->ent->flag & F_Object)
#define rdecl_is_methvect(p) (is_methods_vector(rdecl_name(p)))
#define rdecl_name(p) ((p)->ent->name)
   };

struct unit {
   char * name;
   struct unit * next;
   };

struct gcell {
   struct gentry * ent;
   struct gcell * next;
   };

static void chk_pdefns(void);
static void chk_rdecls(void);
static void cleanup(void);
static struct pcall * find_clsinst_call(char *);
static void gentry_imprison(struct gentry *);
static void rdecl_imprison(struct rdecl *);
static void rdecl_print_flds(struct rdecl *);
static int rdecl_rmv(struct rdecl *);
static void rdecl_rmv_parrec_entries(struct rdecl *);

static int dbg = 0;
static struct unit * units = 0;
static struct gcell * jail = 0;
static struct rdecl * rdecls = 0;
static struct pdefn * pdefns = 0;
static struct pcall * pcalls = 0;

extern
int
ica_analyze(void)
{
long bgn, end;
struct rusage ru_in, ru_out;

   if (!opt_ica)
      return 0;
getrusage(RUSAGE_SELF, &ru_in);
   chk_rdecls();
   /* chk_pdefns_pre(); */
   cleanup();
getrusage(RUSAGE_SELF, &ru_out);
bgn = ru_in.ru_utime.tv_sec * 1000 + ru_in.ru_utime.tv_usec / 1000;
end = ru_out.ru_utime.tv_sec * 1000 + ru_out.ru_utime.tv_usec / 1000;
printf("ica-pre-time: %ld msec\n", end - bgn);
   return 0;
}

extern
int
ica_init(void)
{
   static int n = 0;

   if (!opt_ica)
      return 0;
   if (n++)
      return -1;
   jail = 0;
   units = 0;
   pcalls = 0;
   pdefns = 0;
   rdecls = 0;
   return 0;
}

extern
int
ica_pcall_add(node)
   struct node * node;
{
   struct node * n;
   struct pcall * pcall;

   if (!opt_ica)
      return 0;
   pcall = 0;
   n = node->n_field[1].n_ptr;
   switch (n->n_type) {
      case N_Field:
         pcall = alloc(sizeof(struct pcall));
         pcall->node = node;
         /* pcall->name = n->n_field[1].n_ptr->n_field[0].n_str; */
         pcall->name = Str0(Tree1(n));
         pcall->next = pcalls;
         pcalls = pcall;
         break;
      case N_Id:
         pcall = alloc(sizeof(struct pcall));
         pcall->node = node;
         pcall->name = n->n_field[0].csym->image;
         pcall->next = pcalls;
         pcalls = pcall;
         break;
      case N_Invok:
      case N_InvOp:
         /* an invocation within an invocation */
         break;
      case N_Int:
      case N_Empty:
         /*
          * /ipl/procs/printf.icn has what iconc thinks are N_Invok
          * nodes whose callee is an N_Int (integer literal) or sometimes
          * an N_Empty. Which is mighty interesting. Don't know
          * if this is because iconc is misinterpreting this expr
          *
          * wholepart :=  1(tab(many(&digits)), any('.eE')) | return image(x)
          *
          * or some other explanation bears merit. In the meantime,
          * ignore this schtuff and chug-chug-w00w00 right on by it.
          */
         break;
      default:
         errmsg("ica-pcall-add: nak n_type: %d\n", n->n_type);
         exit(-1);
         break;
      }
   if (pcall)
      dbgmsg("ica-pcall-add: \"%s\"\n", pcall->name);
   return 0;
}

extern
int
ica_pdefn_add(gentry)
   struct gentry * gentry;
{
   struct pdefn * pdefn;

   if (!opt_ica)
      return 0;
   pdefn = alloc(sizeof(struct pdefn));
   pdefn->ent = gentry;
   pdefn->next = pdefns;
   pdefns = pdefn;
   dbgmsg("ica-pdefn-add: \"%s\"\n", pdefn_name(pdefn));
   return 0;
}

extern
int
ica_pdefn_unused(gentry)
   struct gentry * gentry;
{
   return 0;
}

extern
int
ica_rdecl_add(gentry)
   struct gentry * gentry;
{
   struct rdecl * rdecl;
   extern int is_methods_vector(char *);

   if (!opt_ica)
      return 0;
   rdecl = alloc(sizeof(struct rdecl));
   rdecl->iflgs = 0;
   rdecl->ent = gentry;
   rdecl->next = rdecls;
   rdecls = rdecl;
   dbgmsg("ica-rdecl-add: \"%s\"", rdecl_name(rdecl));
   if (rdecl_is_clsinst(rdecl))
      dbgmsg(" a cls-inst");
   if (rdecl_is_methvect(rdecl))
      dbgmsg(" a meth-vect");
   dbgmsg("\n");
   return 0;
}

extern
int
ica_rdecl_unused(gentry)
   struct gentry * gentry;
{
   struct gcell * cell;

   if (!opt_ica)
      return 0;
   for (cell=jail; cell; cell=cell->next) {
      if (cell->ent == gentry)
         return 1;
      }
   return 0;
}

extern
int
ica_unit_add(name)
   char * name;
{
   struct unit * unit;

   if (!opt_ica)
      return 0;
   unit = alloc(sizeof(struct unit));
   unit->name = name;
   unit->next = units;
   units = unit;
   dbgmsg("ica-unit-add: \"%s\"\n", name);
   return 0;
}

static
void
chk_pdefns_pre(void)
{
   struct pdefn * pdefn;
   struct pcall * pcall;
   struct pentry * pentry;

   dbgmsg("ica.chk-pdefns-pre...\n");
   for (pdefn=pdefns; pdefn; pdefn=pdefn->next) {
      pentry = pdefn->ent->val.proc;
      for (pcall=pcalls; pcall; pcall=pcall->next) {
         if (strcmp(pentry->name, pcall->name))
            continue;
         printf("ica.chk-pdefns-pre: found \"%s\"\n", pentry->name);
         }
      }
}

static
void
chk_rdecls(void)
{
   int rslt;
   struct rdecl * rdecl;
   struct pcall * pcall;

   dbgmsg("ica.chk-rdecls...\n");
   for (rdecl=rdecls; rdecl; rdecl=rdecl->next) {
      dbgmsg("  \"%s\"...\n", rdecl_name(rdecl));
      if (rdecl_is_methvect(rdecl)) {
         dbgmsg("    a methods-vector.\n");
         continue;
         }
      if (rdecl_is_clsinst(rdecl)) {
         dbgmsg("    a class-inst.\n");
         pcall = find_clsinst_call(rdecl->ent->name);
         if (pcall == 0) {
            dbgmsg("      not instantiated.\n");
            if ((rslt = rdecl_rmv(rdecl)) != 0) {
               dbgmsg("iga.chk-rdecls: rmv-rdecl failure: %d\n", rslt);
               exit(-1);
               }
            }
         else
            dbgmsg("      is instantiated.\n");
         }
      else {
         dbgmsg("    a Icon rec.\n");
         }
      }
}

static
void
cleanup(void)
{
   struct unit * unit;
   struct gents * gent;
   struct pcall * pcall;
   struct pdefn * pdefn;
   struct rdecl * rdecl;

   /*
    * Relinquish core used to store stuff. Do NOT
    * relinquish the jail, as it is used during codegen.
    */
   while (units) {
      unit = units;
      units = unit->next;
      free(unit);
      }
   while (pcalls) {
      pcall = pcalls;
      pcalls = pcall->next;
      free(pcall);
      }
   while (pdefns) {
      pdefn = pdefns;
      pdefns = pdefn->next;
      free(pdefn);
      }
   while (rdecls) {
      rdecl = rdecls;
      rdecls = rdecl->next;
      free(rdecl);
      }
   units = 0;
   pcalls = 0;
   pdefns = 0;
   rdecls = 0;
}

static
struct pcall *
find_clsinst_call(clsname)
   char * clsname;
{
   int clslen;
   int calllen;
   struct pcall * pcall;

   clslen = strlen(clsname);
   clslen -= 7 /* "__state" */;
   if (clslen <= 0) {
      errmsg("ica.find-clsinst-call: invalid len: %d clsname: \"%s\"\n",
         clslen, clsname);
      return 0;
      }
   for (pcall=pcalls; pcall; pcall=pcall->next) {
      calllen = strlen(pcall->name);
      if (clslen != calllen)
         continue;
      if (strncmp(clsname, pcall->name, clslen) == 0)
         break;
      }
   return pcall;
}

static
void
gentry_imprison(gentry)
   struct gentry * gentry;
{
   struct gcell * cell;

   for (cell=jail; cell; cell=cell->next) {
      if (cell->ent == gentry)
         /* already here */
         return;
      }
   cell = alloc(sizeof(struct gcell));
   cell->ent = gentry;
   cell->next = jail;
   jail = cell;
}

static
void
rdecl_imprison(rdecl)
   struct rdecl * rdecl;
{
   gentry_imprison(rdecl->ent);
}

static
void
rdecl_print_flds(rdecl)
   struct rdecl * rdecl;
{
   struct rentry * r;
   struct fentry * f;
   struct par_rec * pr;
   struct fldname * fldnm;

   if (!dbg)
      return;
   dbgmsg("ica.rdecl-print-flds: \n");
   r = rdecl->ent->val.rec;
   for (fldnm=r->fields; fldnm; fldnm=fldnm->next) {
      dbgmsg("  fldname: %s\n", fldnm->name);
      f = flookup(fldnm->name);
      for (pr=f->rlist; pr; pr=pr->next) {
         dbgmsg("    prec: \"%s\" addr: %p\n", pr->rec->name, pr->rec);
         if (pr->rec == rdecl->ent->val.rec)
            dbgmsg("      ** match **\n");
         }
      }
}

static
int
rdecl_rmv(rdecl)
   struct rdecl * rdecl;
{
   struct rentry * r;
   struct rentry * rentry;
   extern struct rentry * rec_lst;

   dbgmsg("ica.rdecl_rmv: rec_lst in: ");
   for (r=rec_lst; r; r=r->next)
      dbgmsg("%d ", r->rec_num);
   dbgmsg("\n");

   rentry = rdecl->ent->val.rec;
   if (rec_lst == rentry) {
      rec_lst = rec_lst->next;
      rdecl_imprison(rdecl);
      dbgmsg("ica.rdecl_rmv: %s addr: %p rec-num: %d\n", rdecl_name(rdecl),
         rentry, rentry->rec_num);
      rdecl_print_flds(rdecl);
      rdecl_rmv_parrec_entries(rdecl);
      goto return_zero;
      }
   for (r=rec_lst; r && r->next; r=r->next) {
      r->rec_num -= 1;
      if (r->next != rentry)
         continue;
      dbgmsg("ica.rdecl_rmv: %s addr: %p rec-num: %d\n", rdecl_name(rdecl),
         rentry, r->next->rec_num);
      rdecl_print_flds(rdecl);
      r->next = rentry->next;
      rdecl_imprison(rdecl);
      rdecl_rmv_parrec_entries(rdecl);
      goto return_zero;
      }
   dbgmsg("ica.rdecl_rmv: rentry \"%s\" not found.\n", rdecl_name(rdecl));
   return -1;
return_zero:
   dbgmsg("ica.rdecl_rmv: rec_lst out: ");
   for (r=rec_lst; r; r=r->next)
      dbgmsg("%d ", r->rec_num);
   dbgmsg("\n");
   return 0;
}

static
void
rdecl_rmv_parrec_entries(rdecl)
   struct rdecl * rdecl;
{
   struct fentry * f;
   struct rentry * r;
   struct par_rec * pr;
   struct par_rec * tmp;
   struct fldname * fnm;

   r = rdecl->ent->val.rec;
   for (fnm=r->fields; fnm; fnm=fnm->next) {
      if ((f = flookup(fnm->name)) == 0)
         continue;
      if (f->rlist == 0)
         continue;
      if (f->rlist->rec == r) {
         tmp = f->rlist;
         f->rlist = tmp->next;
         free(tmp);
         continue;
         }
      for (pr=f->rlist; pr && pr->next; pr=pr->next) {
         if (pr->next->rec != r)
            continue;
         tmp = pr->next;
         pr->next = tmp->next;
         free(tmp);
         break;
         }
      }
}

