
#include "../h/gsupport.h"
#include "../h/lexdef.h"
#include "ctrans.h"
#include "cglobals.h"
#include "csym.h"
#include "ccode.h"
#include "ctree.h"
#include "ctoken.h"
#include "cproto.h"
#include "vtbl.h"

struct vtbl {
   struct gentry * g;
   struct vtbl * next;
   };

static struct vtbl * vtbls = NULL;

extern
int
vtbl_add(name)
   char * name;
{
   struct vtbl * vtbl;
   struct gentry * gentry;

   if ((gentry = glookup(name)) == NULL)
      return -1;
   vtbl = alloc(sizeof(struct vtbl));
   vtbl->g = gentry;
   vtbl->next = vtbls;
   vtbls = vtbl;
   return 0;
}

extern
struct vtbl *
vtbl_get(gentry)
   struct gentry * gentry;
{
   char * p;
   char * buf;
   struct vtbl * vtbl;
   if (strstr(gentry->name, "__oprec")) {
      for (vtbl=vtbls; vtbl; vtbl=vtbl->next) {
         if (strcmp(gentry->name, vtbl->g->name) == 0)
            break;
         }
      return vtbl;
      }

   buf = NULL;

   if ((p = strstr(gentry->name, "__methods")) ||
      (p = strstr(gentry->name, "__state"))) {
      buf = alloc(sizeof(char)*(strlen(gentry->name)));
      strncpy(buf, gentry->name, p - gentry->name);
      buf[p - gentry->name] = 0;
      strcat(buf, "__oprec");
      }

   if (buf == NULL)
      return NULL;

   for (vtbl=vtbls; vtbl; vtbl=vtbl->next) {
      if (strcmp(buf, vtbl->g->name) == 0)
         break;
      }
   free(buf);
   return vtbl;
}

extern
int
vtbl_index_get(vtbl)
   struct vtbl * vtbl;
{
   return (vtbl->g) ? vtbl->g->index : -1;
}

extern
int
vtbl_method_lkup(vtbl, method)
   struct vtbl * vtbl;
   char * method;
{
   char * p;
   struct fentry * f;
   struct par_rec * rp;

   if (vtbl == NULL)
      return -1;
   if ((p = strstr(vtbl->g->name, "__oprec")) == NULL)
      return -1;
   if ((f = flookup(method)) == NULL)
      return -1;
   for (rp=f->rlist; rp; rp=rp->next) {
      if ((strncmp(rp->rec->name, vtbl->g->name, p - vtbl->g->name) == 0) &&
          (strcmp(rp->rec->name + (p - vtbl->g->name), "__methods") == 0)) {
         return rp->offset;
         }
      }
   return -1;
}

extern
char *
vtbl_name(vtbl)
   struct vtbl * vtbl;
{
   return (vtbl && vtbl->g) ? vtbl->g->name : "vtbl_name: invalid arg.";
}

extern
int
vtbl_name_check(name)
   char * name;
{
   /*
    * The name of a vtbl is [a-zA-Z][a-ZA-Z0-9_]*__oprec
    */
   int len;

   if ((len = strlen(name)) < 8)
      return 0;
   return (strcmp("__oprec", (char *)(name + len - 7)) == 0);
}

