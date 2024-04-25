/*
 * lglob.c -- routines for processing globals.
 */

#include "link.h"
#include "tglobals.h"
#include "tproto.h"
#include "opcode.h"
#include "../h/version.h"

/*
 * Prototypes.
 */

static void     scanfile        (char *filename);
static void     reference       (struct gentry *gp);

int nrecords = 0;               /* number of records in program */

/*
 * readglob reads the global information from infile (.u2) and merges it with
 *  the global table and record table.
 *  return 1 if the file is processed for the first time.
 *  return 0 if the file has already been linked to.
 */
int readglob(struct lfile *lf)
   {
   register word id;
   register int n, op;
   int k;
   int implicit;
   char *name;
   struct gentry *gp;

   if (getopc(&name) != Op_Version)
      quitf("ucode file %s has no version identification",inname);
   id = getid();                /* get version number of ucode */
   newline();
   if (strcmp(&lsspace[id],UVersion)) {
      if (!silent) {
         fprintf(stderr,"version mismatch in ucode file %s\n",inname);
         fprintf(stderr,"\tucode version: %s\n",&lsspace[id]);
         fprintf(stderr,"\texpected version: %s\n",UVersion);
         }
#ifdef ConsoleWindow
      if (flog != NULL) {
         fprintf(flog,"version mismatch in ucode file %s\n",inname);
         fprintf(flog,"\tucode version: %s\n",&lsspace[id]);
         fprintf(flog,"\texpected version: %s\n",UVersion);
         }
#endif                                  /* ConsoleWindow */

      exit(EXIT_FAILURE);

      }
   if ((op=getopc(&name)) != Op_Uid)
     goto skipOP;

   id = getid();                /* get version number of ucode */
   if (lookup_linked_uid(&lsspace[id])) {
     /* found it already, don't claim ownership of it and in fact, nuke our filename so we don't duplicate */
     /*if (lf->lf_name)
       printf("found %s (%s) already, skipping!\n", lf->lf_name, &lsspace[id]);
     else
       printf("found (%s) already, skipping!\n", &lsspace[id]);
     */
     lf->lf_name = NULL;
     return 0;
   } else {
     /*printf("claiming ownership of %s!\n", &lsspace[id]);
      * by this gentle insertion of our uid onto the global list, we assert ownership of this uid forever */
     lf->uid = &lsspace[id];
   }

   newline();

   while ((op = getopc(&name)) != EOF) {
skipOP: switch (op) {
         case Op_Record:        /* a record declaration */
            id = getid();       /* record name */
            n = getdec();       /* number of fields */
            newline();
            gp = glocate(id);
            /*
             * It's ok if the name isn't already in use or if the
             *  name is just used in a "global" declaration.  Otherwise,
             *  it is an inconsistent redeclaration.
             */
            if (gp == NULL || (gp->g_flag & ~F_Global) == 0) {
               gp = putglobal(id, F_Record, n, ++nrecords);
               while (n--) {    /* loop reading field numbers and names */
                  k = getdec();
                  putfield(getid(), gp, k);
                  newline();
                  }
               }
            else {
               lfatal(&lsspace[id], "inconsistent redeclaration");
               while (n--)
                  newline();
               }
            break;

         case Op_Impl:          /* undeclared identifiers should be noted */
            if (getopc(&name) == Op_Local)
               implicit = 0;
            else
               implicit = F_ImpError;
            break;

         case Op_Trace:         /* turn on tracing */
            trace = -1;
            break;

         case Op_Global:        /* global variable declarations */
            n = getdec();       /* number of global declarations */
            newline();
            while (n--) {       /* process each declaration */
               getdec();        /* throw away sequence number */
               k = getoct();    /* get flags */
               if (k & F_Proc)
                  k |= implicit;
               id = getid();    /* get variable name */
               gp = glocate(id);
               /*
                * Check for conflicting declarations and install the
                *  variable.
                */
               if (gp != NULL && (k & F_Proc) && gp->g_flag != F_Global)
                  lfatal(&lsspace[id], "inconsistent redeclaration");
               else if (gp == NULL || (k & F_Proc))
                  putglobal(id, k, getdec(), 0);
               newline();
               }
            break;

         case Op_Invocable:     /* "invocable" declaration */
            id = getid();       /* get name */
            if (lsspace[id] == '0')
               strinv = 1;      /* name of "0" means "invocable all" */
            else
               addinvk(&lsspace[id], 2);
            newline();
            break;

         case Op_Link:          /* link the named file */
            k = getrest();
            name = &lsspace[k]; /* get the name */

            alsolink(name);     /*  put it on the list of files to link */

            newline();
            break;

         default:
            quitf("ill-formed global section in file %s",inname);
         }
      }
   return 1;
   }

/*
 * scanrefs - scan .u1 files for references and mark unreferenced globals.
 *
 * Called only if -fs is *not* specified (or implied by "invocable all").
 */
void scanrefs()
   {
   int i, n;
   char *t, *old;
   struct fentry *fp, **fpp;
   struct gentry *gp, **gpp;
   struct rentry *rp;
   struct lfile *lf, *lfls;
   struct ientry *ip, *ipnext;
   struct invkl *inv;

   /*
    * Loop through .u1 files and accumulate reference lists.
    */
   lfls = llfiles;
   while ((lf = getlfile(&lfls)) != 0) {
      if (lf->lf_name)
         scanfile(lf->lf_name);
      /* else this was a redundant reference found during .u1 processing */
   }
   lstatics = 0;                        /* discard accumulated statics */

   /*
    * Mark every global as unreferenced.
    */
   for (gp = lgfirst; gp != NULL; gp = gp->g_next)
      gp->g_flag |= F_Unref;

   /*
    * Clear the F_Unref flag for referenced globals, starting with main()
    * and marking references within procedures recursively.
    */
   reference(lgfirst);

   /*
    * Reference (recursively) every global declared to be "invocable".
    */
   for (inv = invkls; inv != NULL; inv = inv->iv_link)
      if ((gp = glocate(instid(inv->iv_name))) != NULL)
         reference(gp);

   /*
    * Rebuild the global list to include only referenced globals,
    * and renumber them.  Also renumber all record constructors.
    * Free all reference lists.
    */
   n = 0;
   nrecords = 0;
   gpp = &lgfirst;
   while ((gp = *gpp) != NULL) {
      if (gp->g_refs != NULL) {
         free((char *)gp->g_refs);              /* free the reference list */
         gp->g_refs = NULL;
         }
      if (gp->g_flag & F_Unref) {
         /*
          *  Global is not referenced anywhere.
          */
         gp->g_index = gp->g_procid = -1;       /* flag as unused */
         if (verbose >= 3) {
            if (gp->g_flag & F_Proc)
               t = "procedure";
            else if (gp->g_flag & F_Record)
               t = "record   ";
            else
               t = "global   ";
            if (!(gp->g_flag & F_Builtin)) {
               if (!silent)
                 fprintf(stderr, "  discarding %s %s\n", t, &lsspace[gp->g_name]);
#ifdef ConsoleWindow
               if (flog != NULL)
                  fprintf(flog, "  discarding %s %s\n", t, &lsspace[gp->g_name]);
#endif                                  /* ConsoleWindow */
               }
            }
         *gpp = gp->g_next;
         }
      else {
         /*
          *  The global is used.  Assign it new serial number(s).
          */
         gp->g_index = n++;
         if (gp->g_flag & F_Record)
            gp->g_procid = ++nrecords;

#if NT
#ifndef NTGCC
         /*
          * NT distinguishes between graphics and non-graphics VM's.
          * If this is a graphics application we want the graphics VM.
          * All graphics functions start with a capital letter.
          */
         if (!Gflag &&
             (gp->g_flag & F_Builtin) &&
             isupper((&lsspace[gp->g_name])[0]) &&
             strcmp("EvGet", &lsspace[gp->g_name])) {
            Gflag = 1;
            }
#endif                                  /* NTGCC */
#endif                                  /* NT */
         gpp = &gp->g_next;
         }
      }

   /*
    * Rebuild the field list to include only referenced fields,
    * and renumber them.
    */
   n = 0;
   fpp = &lffirst;
   while ((fp = *fpp) != NULL) {
      for (rp = fp->f_rlist; rp != NULL; rp = rp->r_link)
         if (rp->r_gp->g_procid > 0)    /* if record was referenced */
            break;
      if (rp == NULL) {
         /*
          *  The field was used only in unreferenced record constructors.
          */
         fp->f_fid = 0;
         *fpp = fp->f_nextentry;
         }
      else {
         /*
          *  The field was referenced.  Give it the next number.
          */
         fp->f_fid = ++n;
         fpp = &fp->f_nextentry;
         }
      }

   /*
    * Create a new, empty string space, saving a pointer to the old one.
    * Clear the old identifier hash table.
    */
   old = lsspace;
   lsspace = (char *)tcalloc(stsize, 1);
   lsfree = 0;
   for (i = 0; i < ihsize; i++) {
      for (ip = lihash[i]; ip != NULL; ip = ipnext) {
         ipnext = ip->i_blink;
         free((char *)ip);
         }
      lihash[i] = NULL;
      }

   /*
    * Reinstall the global identifiers that are actually referenced.
    * This changes the hashing, so clear and rebuild the hash table.
    */
   for (i = 0; i < ghsize; i++)
      lghash[i] = NULL;
   for (gp = lgfirst; gp != NULL; gp = gp->g_next) {
      gp->g_name = instid(&old[gp->g_name]);
      i = ghasher(gp->g_name);
      gp->g_blink = lghash[i];
      lghash[i] = gp;
      }

   /*
    * Reinstall the referenced record fields in similar fashion.
    */
   for (i = 0; i < fhsize; i++)
      lfhash[i] = NULL;
   for (fp = lffirst; fp != NULL; fp = fp->f_nextentry) {
      fp->f_name = instid(&old[fp->f_name]);
      i = fhasher(fp->f_name);
      fp->f_blink = lfhash[i];
      lfhash[i] = fp;
      }

   /*
    * Free the old string space.
    */
   free((char *)old);
   }

/*
 * scanfile -- scan one file for references.
 */
static void scanfile(char *filename)
   {
   int i, k, f, op, nrefs, flags;
   word id, procid;
   char *name;
   struct gentry *gp, **rp;

   makename(inname, SourceDir, filename, U1Suffix);

   #if MVS || VM
      infile = fopen(inname, ReadBinary);
      if (infile != NULL)               /* discard the extra blank we had */
         (void)getc(infile);            /* to write to make it non-empty  */
   #else                                /* MVS || VM */
      infile = fopen(inname, ReadText);
   #endif                               /* MVS || VM */

   if (infile == NULL) {
      int c;
      makename(inname, SourceDir, filename, USuffix);
      infile = fopen(inname, ReadText);
      if (infile == NULL)
         quitf("cannot open .u or .u1 for %s", inname);
      /*
       * skip past the control-L
       */
      while ((c = getc(infile)) != EOF)
         if (c == '\014') {
            getc(infile);
            break;
            }
      }

   if (infile == NULL)
      quitf("cannot open %s", inname);

   while ((op = getopc(&name)) != EOF) {
      switch (op) {
         case Op_Proc:
            procid = getid();
            newline();
            gp = glocate(procid);
            locinit();
            nrefs = 0;
            break;
         case Op_Local:
            k = getdec();
            flags = getoct();
            id = getid();
            putlocal(k, id, flags, 0, procid);
            lltable[k].l_flag |= F_Unref;
            break;
         case Op_Var:
            k = getdec();
            newline();
            f = lltable[k].l_flag;
            if ((f & F_Global) && (f & F_Unref)) {
               lltable[k].l_flag = f & ~F_Unref;
               nrefs++;
               }
            break;
         case Op_End:
            newline();
            if (nrefs > 0) {
               rp = (struct gentry **)tcalloc(nrefs + 1, sizeof(*rp));
               gp->g_refs = rp;
               for (i = 0; i <= nlocal; i++)
                  if ((lltable[i].l_flag & (F_Unref + F_Global)) == F_Global)
                     *rp++ = lltable[i].l_val.global;
               *rp = NULL;
               }
            break;
         default:
            newline();
            break;
         }
      }

   fclose(infile);
   }

/*
 *
 */
static void reference(struct gentry *gp)
   {
   struct gentry **rp;

   if (gp->g_flag & F_Unref) {
      gp->g_flag &= ~F_Unref;
      if ((rp = gp->g_refs) != NULL)
         while ((gp = *rp++) != 0)
            reference(gp);
      }
   }
