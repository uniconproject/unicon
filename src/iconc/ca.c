#include "../h/gsupport.h"
#include "ctrans.h"
#include "csym.h"
#include "ctree.h"
#include "ctoken.h"
#include "cglobals.h"
#include "ccode.h"
#include "ca.h"

/*
 * Flags for various entities
 */
#define F_Peri  (01)
#define F_Prsd  (02)
#define F_Rslvd (04)
/*
 * The number of buckets in the table of invocations
 */
#define HtblSz (256)
/*
 * lines have to be very long in order to accommodate very large gdbm
 * entries; can get around this by reformatting the unicon output later.
 */
#define MaxLineLen (4095)

#define caf_is_peri(c)          ((c)->flgs & F_Peri)
#define caf_is_parsed(c)        ((c)->flgs & F_Prsd)
#define caf_set_parsed(c)       ((c)->flgs |= F_Prsd)
#define caf_set_peri(c)         ((c)->flgs |= F_Peri)
#define invk_is_resolved(i)     ((i)->flgs & F_Rslvd)
#define invk_set_resolved(i)    ((i)->flgs |= F_Rslvd)

struct imp { /* import target */
   char * name;
   struct imp * next;
   };

struct lnk { /* link target */
   char * name;
   struct lnk * next;
   };

struct prc { /* proc defn */
   char * name;
   struct invk * invks;
   struct prc * next;
   };

struct invk { /* invocation */
   char * name;
   unsigned flgs;
   struct node * node;
   struct invk * next;
   };

struct caf {
   unsigned flgs;
   char * fname;
   char * alias;
   char * pkgname;
   struct imp * imps;
   struct lnk * lnks;
   struct prc * prcs;
   struct cls * clss;
   struct caf * next;
   };

struct member { /* class member */
   char * name;
   struct member * next;
   };

struct supercls { /* class super */
   char * name;
   struct supercls * next;
   };

struct mthd { /* a class method */
   char * name;
   struct mthd * next;
   };

struct cls { /* class */
   char * name;
   struct mthd * mthds;
   struct member * mbrs;
   struct supercls * supers;
   struct cls * next;
   };

struct bndl { /* bundle */
   char * name;
   struct cls * clss;
   struct bndl * next;
   };

struct bkt { /* bucket in the procedure htbl */
   struct caf * caf;
   struct prc * prc;
   struct bkt * next;
   };

char * ca_first_perifile = 0;
static int gui_app = 0;
static struct caf * cafs = 0;
static struct bndl * bndls = 0;
static int max_syms_matched = 0;
static char buf_[MaxLineLen+1] = { 0 };
static struct bkt * htbl[HtblSz] = { 0 };

static void bndl_free(struct bndl *);
static struct bndl * bndl_get(char *);
static void caf_free(struct caf *);
static struct caf * caf_get_by_alias(char *);
static struct caf * caf_get_by_name(char *);
/*
static struct cls * caf_get_class(char *, struct caf *);
static char * is_ctor(char *);
static char * name_get_pkgspec(char *);
*/
static struct prc * caf_get_prc(struct caf *, char *);
static int caf_has_posix_rec_defs(struct caf *);
static void caf_parse(struct caf *, char *);
static void cleanup(void);
static void cls_free(struct cls *);
static void gui_app_init(void);
static int is_rtl_func(char *);
static unsigned name_hash(char *);
static void parse(char *, char *);
static void posix_recs_init(void);
static void prc_add_invk(struct prc *, struct invk *);
static void prc_free(struct prc *);
static struct prc * prc_lkup(char *, struct caf **);
static void read_bndl_class(void *);
static void read_bndl_name(void);
static void read_caf_class(void);
static void read_caf_import(void);
static void read_caf_link(void);
static void read_caf_name(void);
static void read_caf_pkgname(void);
static void read_caf_proc(void);
static void read_caf_supercls(void);
static void report_stats(void);
static void resolve_gui_syms(void);
static int resolve_invk(struct caf *, struct prc *, struct invk *,
   struct caf *[], struct prc *[]);
static int resolve_invks(struct caf *, struct prc *);

extern
int
ca_apply_add(fname, node)
   char * fname;
   struct node * node;
{
   char * id;
   struct node * n;
   struct caf * caf;
   struct prc * prc;
   struct invk * invk;
   extern struct pentry * proc_lst;

   id = 0;
   n = node->n_field[0].n_ptr;
   switch (n->n_type) {
      case N_Field:
         id = Str0(Tree1(n));
         break;
      case N_Id:
         id = n->n_field[0].csym->image;
         break;
      }
   if (id == 0 || is_rtl_func(id))
      return 0;
   if ((caf = caf_get_by_alias(fname)) == NULL)
      return -1;
   if ((prc = caf_get_prc(caf, proc_lst->name)) == NULL)
      return -1;
   invk = alloc(sizeof(struct invk));
   invk->flgs = 0;
   invk->name = id;
   invk->node = node;
   prc_add_invk(prc, invk);

   return 0;
}

extern
int
ca_cleanup(void)
{
   struct caf * caf;
   struct bndl * bndl;

   while (bndls) {
      bndl = bndls;
      bndls = bndls->next;
      bndl_free(bndl);
      }
   while (cafs) {
      caf = cafs;
      cafs = cafs->next;
      caf_free(caf);
      }
   return 0;
}

extern
void
ca_dbg_dump(void)
{
}

extern
int
ca_init(fname, argc, argv)
   char * fname;
   int argc;
   char ** argv; /* argv to iconc */
{
   int i;
   int len;
   void * f;
   char * p;
   char * peri1st;

   if ((f = fopen(fname, "r")) == NULL) {
      perror(fname);
      return -1;
      }
   /*
    * read firstperi
    */
   if (fgets(buf_, MaxLineLen, f) == NULL) {
      fprintf(stderr, "ca-init: fgets error in %s.\n", fname);
      return -1;
      }
   for (p=buf_; *p && *p != ':'; p++)
      ;
   *p++ = 0;
   if (strcmp(buf_, "firstperi")) {
      fprintf(stderr, "ca-init: nak 1.\n");
      return -1;
      }
   len = strlen(p);
   ca_first_perifile = alloc(sizeof(char) * (len + 1));
   strcpy(ca_first_perifile, p);
   ca_first_perifile[len - 1] = 0; /* clobber cr */
   /*
    * point to the firstperi in argv for future refs
    */
   for (i=1; i<argc; i++) {
      if (strcmp(argv[i], ca_first_perifile) == 0) {
         peri1st = argv[i];
         break;
         }
      }
   /*
    * read cafs
    */
   for (;;) {
      if (fgets(buf_, MaxLineLen, f) == NULL) {
         printf("ca-init: premature eof?\n");
         break;
         }
      switch (*buf_) {
         case 'b':
            read_bndl_name();
            break;
         case 'c':
            read_bndl_class(f);
            break;
         case 'e':
            /* predefined eof */
            return 0;
         case 'f':
            read_caf_name();
            /* is the caf we just read a perifile? */
            if (strcmp(cafs->fname, ca_first_perifile) == 0) {
               caf_set_peri(cafs);
               break;
               }
            for (i=argc-1; i; i--) {
               if (argv[i] == peri1st)
                  /* not a perifile */
                  break;
               if (strcmp(cafs->fname, argv[i]) == 0) {
                  caf_set_peri(cafs);
                  break;
                  }
               }
            break;
         case 'i':
            read_caf_import();
            break;
         case 'l':
            read_caf_link();
            break;
         case 'p':
            read_caf_proc();
            break;
         case 'P':
            read_caf_pkgname();
            break;
         case 'C':
            read_caf_class();
            break;
         case 's':
            read_caf_supercls();
            break;
         default:
            printf("ca-init: nak buf: \"%s\"\n", buf_);
            return -1;
         }
      }
   fclose(f);
   return 0;
}

extern
int
ca_invk_add(fname, node)
   char * fname;
   struct node * node;
{
   char * id;
   struct node * n;
   struct caf * caf;
   struct prc * prc;
   struct invk * invk;
   extern struct pentry * proc_lst;

   id = 0;
   n = node->n_field[1].n_ptr;
   switch (n->n_type) {
      case N_Field:
         id = Str0(Tree1(n));
         break;
      case N_Id:
         id = n->n_field[0].csym->image;
         break;
      }
   if (id == 0 || is_rtl_func(id))
      return 0;
   if ((caf = caf_get_by_alias(fname)) == NULL)
      return -1;
   if ((prc = caf_get_prc(caf, proc_lst->name)) == NULL)
      return -1;
   invk = alloc(sizeof(struct invk));
   invk->flgs = 0;
   invk->name = id;
   invk->node = node;
   prc_add_invk(prc, invk);
   return 0;
}

extern
int
ca_mark_parsed(fname)
   char * fname;
{
   struct caf * caf;

   if ((caf = caf_get_by_name(fname)) == NULL) {
      printf("ca-mark-parsed: caf-get-by-name(%s) failure\n", fname);
      return -1;
      }
   caf_set_parsed(caf);
   return 0;
}

int looking_for_main;

extern
int
ca_resolve(void)
{
   struct caf * main_caf;
   struct prc * main_prc;

   main_prc = NULL;
   for (main_caf=cafs; main_caf; main_caf=main_caf->next) {
      if ((main_prc = caf_get_prc(main_caf, "main")))
         break;
      }
   if (main_prc == NULL) {
      printf("ca-resolve: procedure \"main\" not found\n");
      return -1;
      }
   posix_recs_init();
   gui_app_init();
   /* printf("ca-resolve: _resolving...\n"); */
   resolve_invks(main_caf, main_prc);
   report_stats();
   cleanup();
   return 0;
}

static
void
bndl_free(bndl)
   struct bndl * bndl;
{
   struct cls * cls;

   while (bndl->clss) {
      cls = bndl->clss;
      bndl->clss = bndl->clss->next;
      cls_free(cls);
      }
   if (bndl->name)
      free(bndl->name);
   free(bndl);
}

static
struct bndl *
bndl_get(name)
   char * name;
{
   struct bndl * bndl;

   for (bndl=bndls; bndl; bndl=bndl->next) {
      if (strcmp(name, bndl->name) == 0)
         break;
      }
   return bndl;
}

static
void
caf_free(caf)
   struct caf * caf;
{
   struct imp * imp;
   struct lnk * lnk;
   struct prc * prc;
   struct cls * cls;

   while (caf->imps) {
      imp = caf->imps;
      caf->imps = caf->imps->next;
      if (imp->name)
         free(imp->name);
      free(imp);
      }
   while (caf->lnks) {
      lnk = caf->lnks;
      caf->lnks = caf->lnks->next;
      if (lnk->name)
         free(lnk->name);
      free(lnk);
      }
   while (caf->prcs) {
      prc = caf->prcs;
      caf->prcs = caf->prcs->next;
      prc_free(prc);
      }
   while (caf->clss) {
      cls = caf->clss;
      caf->clss = caf->clss->next;
      cls_free(cls);
      }
   if (caf->fname)
      free(caf->fname);
   if (caf->alias)
      free(caf->alias);
   free(caf);
}

static
struct caf *
caf_get_by_alias(alias)
   char * alias;
{
   struct caf * caf;

   for (caf=cafs; caf; caf=caf->next) {
      if (strcmp(caf->alias, alias) == 0)
         break;
      }
   return caf;
}

static
struct caf *
caf_get_by_name(fname)
   char * fname;
{
   struct caf * caf;

   for (caf=cafs; caf; caf=caf->next) {
      if (strcmp(caf->fname, fname) == 0)
         break;
      }
   return caf;
}

/*
static
struct cls *
caf_get_class(name, caf)
   char * name;
   struct caf * caf;
{
   struct cls * rslt;

   for (rslt=caf->clss; rslt; rslt=rslt->next) {
      if (strcmp(name, rslt->name) == 0)
         break;
      }
   return rslt;
}
*/

static
struct prc *
caf_get_prc(caf, name)
   struct caf * caf;
   char * name;
{
   struct prc * prc;

   for (prc=caf->prcs; prc; prc=prc->next) {
      if (strcmp(name, prc->name) == 0)
         break;
      }
   return prc;
}

static
int
caf_has_posix_rec_defs(caf)
   struct caf * caf;
{
   int len;
   char * p;

   len = strlen(caf->alias);
   if (len < 9)
      return 0;
   p = caf->alias + (len - 9);
   return (strcmp(p, "posix.icn") == 0);
}

static
void
caf_parse(caf, sym)
   struct caf * caf;
   char * sym;
{
   if (!caf_is_parsed(caf)) {
      parse(caf->fname, sym);
      caf_set_parsed(caf);
      }
}

static
void
cleanup(void)
{
   struct caf * caf;
   struct bndl * bndl;

   while (cafs) {
      caf = cafs;
      cafs = caf->next;
      caf_free(caf);
      }
   while (bndls) {
      bndl = bndls;
      bndls = bndl->next;
      bndl_free(bndl);
      }
}

static
void
cls_free(cls)
   struct cls * cls;
{
   struct mthd * mthd;
   struct member * mbr;
   struct supercls * sc;

   while (cls->mthds) {
      mthd = cls->mthds;
      cls->mthds = cls->mthds->next;
      if (mthd->name)
         free(mthd->name);
      free(mthd);
      }
   while (cls->mbrs) {
      mbr = cls->mbrs;
      cls->mbrs = cls->mbrs->next;
      if (mbr->name)
         free(mbr->name);
      free(mbr);
      }
   while (cls->supers) {
      sc = cls->supers;
      cls->supers = cls->supers->next;
      if (sc->name)
         free(sc->name);
      free(sc);
      }
   if (cls->name)
      free(cls->name);
   free(cls);
}


static
void
gui_app_init(void)
{
   int i;
   struct prc * prc;
   struct caf * caf;
   extern int allow_inline;
   char * syms[] = {
      "gui__Clipboardinitialize",
      "lang__Classinitialize",
      "lang__Methodinitialize",
      "util__Eventinitialize",
      "util__StringBuffinitialize",
      };

   if (bndl_get("gui") == NULL)
      /* this is not a gui classlib app */
      return;
   gui_app = 1;
   allow_inline = 0;
   for (i=0; i<sizeof(syms)/sizeof(char *); i++) {
      if ((prc = prc_lkup(syms[i], &caf)) == NULL)
         continue;
      caf_parse(caf, syms[i]);
      }
   resolve_gui_syms();
}

/*
static
char *
is_ctor(name)
   char * name;
{
   char buf[256];

   strcpy(buf, name);
   strcat(buf, "__state");
   if (prc_lkup(buf, NULL))
      return name;
   return 0;
}
*/

/*
 * Determine whether name refers to a rtl function by using
 * brute-force traversal of builtin-hashtbl. We cannot just
 * call db_ilkup(name, bhash) here because we may (or more
 * likely) may not have the actual string that was used to
 * install the builtin in the first place.
 */
static
int
is_rtl_func(name)
   char * name;
{
   int i;
   struct implement * impl;

   for (i=0; i<IHSize; i++) {
      for (impl=bhash[i]; impl; impl=impl->blink) {
         if (strcmp(impl->name, name) == 0)
            return 1;
         }
      }
   return 0;
}
/*
static
char *
name_get_pkgspec(name)
   char * name;
{
   int i;
   int len;
   char * p;
   static char buf[64];

   len = strlen(name);
   for (i=0,p=name; *p; p++,i++) {
      buf[i] = *p;
      if (*p == '_' && *(p + 1) == '_')
         break;
      }
   buf[i] = 0;
   if (i > 0 && i < len-1)
      return buf;
   return NULL;
}
*/

/*
 * this is stupid for now...
 */
static
unsigned
name_hash(name)
   char * name;
{
   unsigned h;

   h = name[0];
   h ^= name[1];
   h ^= name[2];
   h ^= name[3];

   return (h & (HtblSz - 1));
}

static
void
parse(fname, symname)
   char * fname;
   char * symname;
{
   extern void trans1(char *);
   /*fprintf(stderr, "Parsing %s to resolve symbol %s\n", fname, symname);*/
   /*printf("Parsing %s to resolve symbol %s\n", fname, symname);*/
   trans1(fname);
}

static
void
posix_recs_init(void)
{
   struct caf * caf;

   for (caf=cafs; caf; caf=caf->next) {
      if (caf_has_posix_rec_defs(caf)) {
         caf_parse(caf, "posix_stat");
         return;
         }
      }
}

static
void
prc_add_invk(prc, invk)
   struct prc * prc;
   struct invk * invk;
{
   struct invk * tmp;

   invk->next = NULL;
   if (prc->invks == NULL) {
      prc->invks = invk;
      return;
      }
   for (tmp=prc->invks; tmp->next; tmp=tmp->next)
      ;
   tmp->next = invk;
}

static
void
prc_free(prc)
   struct prc * prc;
{
   struct invk * invk;

   while (prc->invks) {
      invk = prc->invks;
      prc->invks = prc->invks->next;
      free(invk);
      }
   free(prc);
}

/*
 * find a proc in the proc htbl
 */
static
struct prc *
prc_lkup(name, pcaf)
   char *name;
   struct caf ** pcaf;
{
   unsigned h;
   struct bkt * bkt;

   h = name_hash(name);
   bkt = htbl[h];
   while (bkt) {
      if (strcmp(name, bkt->prc->name) == 0)
         break;
      bkt = bkt->next;
      }
   if (bkt && pcaf)
      *pcaf = bkt->caf;
   return bkt ? bkt->prc : NULL;
}

static
void
read_bndl_class(f)
   void * f;
{
   int len;
   char * p;
   char * q;
   struct cls * cls;
   struct mthd * mthd;
   struct member * mbr;
   struct supercls * sc;

   /* read a class of the current bundle */
   cls = alloc(sizeof(struct cls));
   cls->mbrs = NULL;
   cls->mthds = NULL;
   cls->supers = NULL;
   for (p=buf_; *p && *p != ':'; p++)
      /* skip first ':' */;
   for (q=++p; *q && *q != ':'; q++)
      ;
   len = q - p;
   cls->name = alloc(sizeof(char) * (len + 1));
   strncpy(cls->name, p, len);
   cls->name[len-1] = 0;
   /* enqueue the class */
   cls->next = bndls->clss;
   bndls->clss = cls;
   /* this parses a gdbm entry for a given class
    * in a given bundle. it is as ugly as the entry. */
   /* skip first line in gdbm entry (it's nonsense?) */
   if (fgets(buf_, MaxLineLen, f) == NULL) {
      fprintf(stderr, "fgets fail in read_bndl_class\n");
      exit(1);
      }
   if (fgets(buf_, MaxLineLen, f) == NULL) {
      fprintf(stderr, "fgets fail#2 in read_bndl_class\n");
      exit(1);
      }
   p = buf_;
   /* parse to ':' or '(' */
next_class_token:
   for (; *p && *p != ':' && *p != '('; p++)
      ;
   if (*p == ':') {
      if (*(p+1) == ' ')
         /* first super (if exists) may have space before it */
         p++;
      /* read a superclass name */
      q = ++p;
      while (*q != ':' && *q != '(')
         q++;
      len = q - p;
      /* p[len-1] = 0; -- clobber cr */
      sc = alloc(sizeof(struct supercls));
      sc->name = alloc(sizeof(char) * (len + 1));
      strncpy(sc->name, p, len);
      sc->name[len] = 0;
      sc->next = cls->supers;
      cls->supers = sc;
      p = q;
      goto next_class_token;
      }
   else /* (*p == '(' */ {
      /* read a class field name */
next_member:
      q = ++p;
      while (*q != ',' && *q != ')')
         q++;
      len = q - p;
      mbr = alloc(sizeof(struct member));
      mbr->name = alloc(sizeof(char) * (len + 1));
      strncpy(mbr->name, p, len);
      mbr->next = cls->mbrs;
      cls->mbrs = mbr;
      p = q;
      if (*p == ',')
         goto next_member;
      else
         p++;
      }
   /* read class methods */
   for (;;) {
      if (fgets(buf_, MaxLineLen, f) == NULL) {
         fprintf(stderr, "fgets fail#3 in read_bndl_class\n");
         exit(1);
         }
      len = strlen(buf_);
      buf_[len-1] = 0; /* clobber cr */
      if (strcmp(buf_, "end") == 0)
         break;
      mthd = alloc(sizeof(struct mthd));
      mthd->name = alloc(sizeof(char) * (len + 1));
      strcpy(mthd->name, buf_);
      mthd->next = cls->mthds;
      cls->mthds = mthd;
      }
}

static
void
read_bndl_name(void)
{
   int len;
   char * p;
   char * q;
   struct bndl * bndl;

   bndl = alloc(sizeof(struct bndl));
   for (p=buf_; *p && *p != ':'; p++)
      ;
   for (q=++p; *q && *q != ' '; q++)
      ;
   len = q - p;
   p[len-1] = 0; /* clobber cr */
   bndl->name = alloc(sizeof(char) * (len + 1));
   strncpy(bndl->name, p, len);
   bndl->name[len] = 0;
   bndl->clss = NULL;
   /* enqueue the bundle */
   bndl->next = bndls;
   bndls = bndl;
}

static
void
read_caf_class(void)
{
   int len;
   char * p;
   struct cls * cls;

   /* read the name of a class defined in the current caf */
   for (p=buf_; *p && *p != ':'; p++)
      ;
   len = strlen(++p);
   cls = alloc(sizeof(struct cls));
   cls->name = alloc(sizeof(char) * (len + 1));
   strcpy(cls->name, p);
   cls->name[len - 1] = 0; /* clobber cr */
   cls->next = cafs->clss;
   cafs->clss = cls;
}

static
void
read_caf_import(void)
{
   int len;
   char * p;
   struct imp * imp;

   /* read an import of the cur caf */
   imp = alloc(sizeof(struct imp));
   for (p=buf_; *p && *p != ':'; p++)
      ;
   len = strlen(++p);
   imp->name = alloc(sizeof(char) * (len + 1));
   strcpy(imp->name, p);
   imp->name[len - 1] = 0; /* clobber cr */
   imp->next = cafs->imps;
   cafs->imps = imp;
}

static
void
read_caf_link(void)
{
   int len;
   char * p;
   struct lnk * lnk;

   /* read a link of the cur caf */
   lnk = alloc(sizeof(struct lnk));
   for (p=buf_; *p && *p != ':'; p++)
      ;
   len = strlen(++p);
   lnk->name = alloc(sizeof(char) * (len + 1));
   strcpy(lnk->name, p);
   lnk->name[len - 1] = 0; /* clobber cr */
   lnk->next = cafs->lnks;
   cafs->lnks = lnk;
}

static
void
read_caf_name(void)
{
   int len;
   char * p;
   char * q;
   struct caf * caf;

   /* read a caf's fname */
   caf = alloc(sizeof(struct caf));
   for (p=buf_; *p && *p != ':'; p++)
      ;
   for(q=++p; *q && *q != ' '; q++)
      ;
   len = q - p;
   caf->fname = alloc(sizeof(char) * (len + 1));
   strncpy(caf->fname, p, len);
   caf->fname[len] = 0;
   /* read a caf's alias */
   while (*q == ' ')
      q++;
   len = strlen(q);
   caf->alias = alloc(sizeof(char) * (len + 1));
   strcpy(caf->alias, q);
   caf->alias[len - 1] = 0; /* clobber cr */

   /* init rest of caf */
   caf->flgs = 0;
   caf->lnks = NULL;
   caf->imps = NULL;
   caf->prcs = NULL;
   caf->clss = NULL;
   /* enqueue the caf */
   caf->next = cafs;
   cafs = caf;
}

static
void
read_caf_pkgname(void)
{
   int len;
   char * p;

   /* read cur caf's package name */
   for (p=buf_; *p && *p != ':'; p++)
      ;
   len = strlen(++p);
   cafs->pkgname = alloc(sizeof(char) * (len + 1));
   strcpy(cafs->pkgname, p);
   cafs->pkgname[len - 1] = 0; /* clobber cr */
}

static
void
read_caf_proc(void)
{
   int len;
   char * p;
   unsigned h;
   struct bkt * bkt;
   struct prc * prc;

   /* read a proc of the current caf */
   prc = alloc(sizeof(struct prc));
   prc->invks = NULL;
   for (p=buf_; *p && *p != ':'; p++)
      ;
   len = strlen(++p);
   prc->name = alloc(sizeof(char) * (len + 1));
   strcpy(prc->name, p);
   prc->name[len - 1] = 0; /* clobber cr */
   prc->next = cafs->prcs;
   cafs->prcs = prc;

   /*
    * add a htbl entry for this prc
    */
   bkt = alloc(sizeof(struct bkt));
   bkt->prc = prc;
   bkt->caf = cafs;
   h = name_hash(prc->name);
   bkt->next = htbl[h];
   htbl[h] = bkt;
}

static
void
read_caf_supercls(void)
{
   int len;
   char * p;
   struct supercls * sc;

   /*
    * read the name of a superclass of the current class defined
    * in the current caf
    */
   for (p=buf_; *p && *p != ':'; p++)
      ;
   len = strlen(++p);
   sc = alloc(sizeof(struct supercls));
   sc->name = alloc(sizeof(char) * (len + 1));
   strcpy(sc->name, p);
   sc->name[len - 1] = 0; /* clobber cr */
   sc->next = cafs->clss->supers;
   cafs->clss->supers = sc;
}

static
void
report_stats(void)
{
   struct caf * caf;
   int n_total, n_used;
   extern int verbose;

   if (verbose < 2)
      return;
   n_total = n_used = 0;
   for (caf=cafs; caf; caf=caf->next,n_total++) {
      if (caf_is_parsed(caf)) {
         n_used++;
         printf("Parsed %s as %s\n", caf->fname, caf->alias);
         }
      }
   printf("used %d of %d files\n", n_used, n_total);
   /*printf("max-syms-matched: %d\n", max_syms_matched);*/
}

static
int
resolve_invk(caf, prc, invk, cafs, prcs)
   struct caf * caf;
   struct prc * prc;
   struct invk * invk;
   struct caf * cafs[];
   struct prc * prcs[];
{
   int n;
   char buf[256];
   struct cls * cls;
   struct supercls * sc;

   n = 0;
   /*printf("resolve-invk: %s in prc: %s\n", invk->name, prc->name);*/
   prcs[n] = prc_lkup(invk->name, &cafs[n]);
   if (prcs[n]) {
      /*printf("found a proc\n");*/
      caf_parse(cafs[n], invk->name);
      ++n;
      sprintf(buf, "%s_display", invk->name);
      prcs[n] = prc_lkup(buf, &cafs[n]);
      if (prcs[n]) {
         caf_parse(cafs[n], buf);
         ++n;
         }
      if (strcmp(invk->name, "gui__Buttoninitialize") == 0) {
         prcs[n] = prc_lkup("gui__CheckBoxGroupinitialize", &cafs[n]);
         if (prcs[n]) {
            caf_parse(cafs[n], "gui__CheckBoxGroupinitialize");
            ++n;
            }
         }
      return n;
      }
   /*
    * check for a method of a class defined in the current caf
    */
   /*printf("  try local mthds...\n");*/
   for (cls=caf->clss; cls; cls=cls->next) {
      sprintf(buf, "%s_%s", cls->name, invk->name);
      /*printf("  mthd: %s\n", buf);*/
      prcs[n] = prc_lkup(buf, &cafs[n]);
      if (prcs[n]) {
         /*printf("    matched\n");*/
         caf_parse(cafs[n], buf);
         ++n;
         }
      }
   if (n > 0)
      return n;
   /*
    * check for a method of a class that is a superclass of a class
    * defined in the current caf
    */
   /*printf("  try super mthds...\n");*/
   for (cls=caf->clss; cls; cls=cls->next) {
      for (sc=cls->supers; sc; sc=sc->next) {
         sprintf(buf, "%s_%s", sc->name, invk->name);
         /*printf("  mthd: %s\n", buf);*/
         prcs[n] = prc_lkup(buf, &cafs[n]);
         if (prcs[n]) {
            /*printf("    matched\n");*/
            caf_parse(cafs[n], buf);
            ++n;
            }
         }
      }
   return n;
}

static
void
resolve_gui_syms(void)
{
   char buf[512];
   struct caf * caf;
   struct cls * cls;
   struct prc * prc;

   for (caf=cafs; caf; caf=caf->next) {
      if (caf_is_peri(caf))
         continue;
      for (cls=caf->clss; cls; cls=cls->next) {
         sprintf(buf, "%s_%s", cls->name, "component_setup");
         if ((prc = prc_lkup(buf, NULL)) == NULL)
            continue;
         resolve_invks(caf, prc);
         }
      }
}

static
int
resolve_invks(caf, prc)
   struct caf * caf;
   struct prc * prc;
{
   int i, n;
   struct invk * invk;
   struct caf * cafs[32];
   struct prc * prcs[32];

   for (invk=prc->invks; invk; invk=invk->next) {
      if (invk_is_resolved(invk))
         continue;
      n = resolve_invk(caf, prc, invk, cafs, prcs);
      /*printf("resolve-invks: found %d syms\n", n);*/
      if (n > max_syms_matched)
         max_syms_matched = n;
      invk_set_resolved(invk);
      for (i=0; i<n; i++)
         resolve_invks(cafs[i], prcs[i]);
      }
   return 0;
}

