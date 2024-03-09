/*
 * lmem.c -- memory initialization and allocation; also parses arguments.
 */

#include "link.h"
#include "tproto.h"
#include "tglobals.h"

/*
 * Prototypes.
 */

static struct	lfile *alclfile	(char *name);

void dumplfiles(void);

#ifdef MultipleRuns
   static void	freelfile	(struct lfile *p);
#endif					/* MultipleRuns */

/*
 * Memory initialization
 */

struct gentry **lghash;		/* hash area for global table */
struct ientry **lihash;		/* hash area for identifier table */
struct fentry **lfhash;		/* hash area for field table */

struct lentry *lltable;		/* local table */
struct centry *lctable;		/* constant table */
struct ipc_fname *fnmtbl;	/* table associating ipc with file name */
struct ipc_line *lntable;	/* table associating ipc with line number */

char *lsspace;			/* string space */
word *labels;			/* label table */
char *codeb;			/* generated code space */

struct ipc_fname *fnmfree;	/* free pointer for ipc/file name table */
struct ipc_line *lnfree;	/* free pointer for ipc/line number table */
word lsfree;			/* free index for string space */
char *codep;			/* free pointer for code space */

struct fentry *lffirst;		/* first field table entry */
struct fentry *lflast;		/* last field table entry */
struct gentry *lgfirst;		/* first global table entry */
struct gentry *lglast;		/* last global table entry */

#ifdef MultipleRuns
   extern word pc;
   extern int fatals;
   extern int nlflag;
   extern int lstatics;
   extern int nfields;
#endif					/* MultipleRuns */

/*
 * linit - scan the command line arguments and initialize data structures.
 */
void linit()
   {
   struct gentry **gp;
   struct ientry **ip;
   struct fentry **fp;

   llfiles = NULL;		/* Zero queue of files to link. */

   /*
    * Allocate the various data structures that are used by the linker.
    */
   lghash   = (struct gentry **) tcalloc(ghsize, sizeof(struct gentry *));
   lihash   = (struct ientry **) tcalloc(ihsize, sizeof(struct ientry *));
   lfhash   = (struct fentry **) tcalloc(fhsize, sizeof(struct fentry *));

   lltable  = (struct lentry *) tcalloc(lsize, sizeof(struct lentry));
   lctable  = (struct centry *) tcalloc(csize, sizeof(struct centry));

   lnfree = lntable  = (struct ipc_line*)tcalloc(nsize,sizeof(struct ipc_line));

   lsspace = (char *) tcalloc(stsize, sizeof(char));
   lsfree = 0;

   fnmtbl = (struct ipc_fname *) tcalloc(fnmsize, sizeof(struct ipc_fname));
   fnmfree = fnmtbl;

   labels  = (word *) tcalloc(maxlabels, sizeof(word));
   codep = codeb = (char *) tcalloc(maxcode, 1);

   lffirst = NULL;
   lflast = NULL;
   lgfirst = NULL;
   lglast = NULL;

   /*
    * Zero out the hash tables.
    */
   for (gp = lghash; gp < &lghash[ghsize]; gp++)
      *gp = NULL;
   for (ip = lihash; ip < &lihash[ihsize]; ip++)
      *ip = NULL;
   for (fp = lfhash; fp < &lfhash[fhsize]; fp++)
      *fp = NULL;

#ifdef MultipleRuns
   /*
    * Initializations required for repeated program runs.
    */
   pc = 0;				/* In lcode.c	*/
   nrecords = 0;			/* In lglob.c	*/
   lineno = 0;				/* In link.c	*/
   colmno = 0;				/* In link.c	*/
   fatals = 0;				/* In link.c	*/
   nlflag = 0;				/* In llex.c	*/
   lstatics = 0;			/* In lsym.c	*/
   nfields = 0;				/* In lsym.c	*/
#endif					/* MultipleRuns */

   /*
    * Install "main" as a global variable in order to insure that it
    *  is the first global variable.  iconx/start.s depends on main
    *  being global number 0.
    */
   putglobal(instid("main"), F_Global, 0, 0);
   }

#ifdef DeBugLinker
/*
 * dumplfiles - print the list of files to link.  Used for debugging only.
 */

void dumplfiles()
   {
   struct lfile *p,*lfls;

   fprintf(stderr,"lfiles:\n");
   lfls = llfiles;
   while (p = getlfile(&lfls))
       fprintf(stderr,"'%s'\n",p->lf_name);
   fflush(stderr);
   }
#endif					/* DeBugLinker */

/*
 * alsolink - create an lfile structure for the named file and add it to the
 *  end of the list of files (llfiles) to generate link instructions for.
 */
void alsolink(name)
char *name;
   {
   char file[MaxFileName];

   if (!pathfind(file, ipath, name, U1Suffix) &&
       !pathfind(file, ipath, name, USuffix)) {
      char buf[256];
      strcpy(buf, "cannot resolve reference to file '");
      strcat(buf, name);
      strcat(buf, "'");
      if (name[strlen(name)-1] != 'u') { /* .u[12], tried also .u */
         buf[strlen(buf)-2] = '\'';
         buf[strlen(buf)-1] = '\0';
         strcat(buf, " or '%s'");
         }
      quitf(buf, name);
      }

#if 0

#if UNIX
   {
   char currentdir[1024];
   char file2[MaxFileName];
   *currentdir = '\0';
   /*
    * use full pathname for all file references during linking.
    * symlinks can cause different paths to refer to the same file,
    * so normalize absolute paths via chdir().
    */
   if (!isalpha(file[0])) {
      struct fileparts *fps = fparse(file);
      getcwd(currentdir, 1024);
      chdir(fps->dir);
      sprintf(file, "%s%s", fps->name, fps->ext);
      }

   if (getcwd(file2, PATH_MAX)) {
      if (file2[strlen(file2)-1] != '/')
	 strcat(file2, "/");
      strcat(file2, file);
      strcpy(file, file2);
      }

   if (*currentdir) chdir(currentdir);
   }
#endif				/* Unix */

#if MSDOS
   if (file[0] == '\\' || file[0] == '/' ||
       (isalpha(file[0]) && file[1] == ':')) {
     ;
   }
   else {
     char file2[MaxFileName];
     if (getcwd(file2, PATH_MAX)) {
       if (file2[strlen(file2)-1] != '/' &&
	   file2[strlen(file2)-1] != '\\' )
	 strcat(file2, "/");
       strcat(file2, file);
       strcpy(file, file2);
        }
   }

   while(strchr(file, '\\')) *(strchr(file,'\\')) = '/';

   {
   int i;
   for (i=0; file[i]; i++)
     if (isupper(file[i])) file[i] = tolower(file[i]);
   }

   /*
    * This removes ".." and "." sections from the path.  For
    * example "c:/a/b/../c/d" -> "c:/a/c/d"
    */
   {
      char *p = file;
      char *q = p;

      while (*p) {
          if (*p == '/' && *(p+1) == '.' && 
              *(p+2) == '.' && *(p+3) == '/') {
              p += 3;
              if (q > file) {
                  --q;
                  while (q > file && *q != '/')
                      --q;
              }
          } else if (*p == '/' && *(p+1) == '.' && 
                     *(p+2) == '/') {
              p += 2;
          } else
              *q++ = *p++;
      }
      *q = 0;
   }

#endif					/* MSDOS */
#endif					/* 0 */

   add_linked_file(file);

   }

/*
 * Return 1 if this uid is already on our list.
 */
int lookup_linked_uid(char *uid)
{
  struct lfile *p = llfiles;
  while (p->lf_link != NULL) {
    if (p->uid && !strcmp(p->uid, uid)) return 1;
    p = p->lf_link;
    }
  return 0;
}


/*
 * check if the file was already linked to (return 0), 
 * if not add it to the list (return 1)
 */

int add_linked_file(char * file)
{
   struct lfile *nlf, *p;
   nlf = alclfile(file);
   if (llfiles == NULL) {
      llfiles = nlf;
      }
   else {
      p = llfiles;
      while (p->lf_link != NULL) {
        if ( (p->lf_name) && (strcmp(p->lf_name,file) == 0))
           return 0;
        p = p->lf_link;
        }
      if ( (p->lf_name) && (strcmp(p->lf_name,file) == 0))
        return 0;
      p->lf_link = nlf;
   }
   return 1;
}


/*
 * getlfile - return a pointer (p) to the lfile structure pointed at by lptr
 *  and move lptr to the lfile structure that p points at.  That is, getlfile
 *  returns a pointer to the current (wrt. lptr) lfile and advances lptr.
 */
struct lfile *getlfile(lptr)
struct lfile **lptr;
   {
   struct lfile *p;

   if (*lptr == NULL)
      return (struct lfile *)NULL;
   else {
      p = *lptr;
      *lptr = p->lf_link;
      return p;
      }
   }

/*
 * alclfile - allocate an lfile structure for the named file, fill
 *  in the name and return a pointer to it.
 */
static struct lfile *alclfile(name)
char *name;
   {
   struct lfile *p;

   p = (struct lfile *) alloc(sizeof(struct lfile));
   p->lf_link = NULL;
   p->lf_name = salloc(name);
   return p;
   }

#ifdef MultipleRuns
/*
 * freelfile - free memory of an lfile structure.
 */
static void freelfile(p)
struct lfile *p;
   {
   free((char *)p->lf_name);
   free((char *) p);
   }
#endif					/* MultipleRuns */

/*
 * lmfree - free memory used by the linker
 */
void lmfree()
   {
   struct fentry *fp, *fp1;
   struct gentry *gp, *gp1;
   struct rentry *rp, *rp1;
   struct ientry *ip, *ip1;
   int i;

   for (i = 0; i < ihsize; ++i)
      for (ip = lihash[i]; ip != NULL; ip = ip1) {
           ip1 = ip->i_blink;
           free((char *)ip);
           }

   free((char *) lghash);   lghash = NULL;
   free((char *) lihash);   lihash = NULL;
   free((char *) lfhash);   lfhash = NULL;
   free((char *) lltable);   lltable = NULL;
   free((char *) lctable);   lctable = NULL;
   free((char *) lntable);   lntable = NULL;
   free((char *) lsspace);   lsspace = NULL;
   free((char *) fnmtbl);   fnmtbl = NULL;
   free((char *) labels);   labels = NULL;
   free((char *) codep);   codep = NULL;

   for (fp = lffirst; fp != NULL; fp = fp1) {
      for(rp = fp->f_rlist; rp != NULL; rp = rp1) {
         rp1 = rp->r_link;
         free((char *)rp);
         }
      fp1 = fp->f_nextentry;
      free((char *)fp);
      }
   lffirst = NULL;
   lflast = NULL;

   for (gp = lgfirst; gp != NULL; gp = gp1) {
      gp1 = gp->g_next;
      free((char *)gp);
      }
   lgfirst = NULL;
   lglast = NULL;

#ifdef MultipleRuns
   for (lf = llfiles; lf != NULL; lf = nlf) {
      nlf = lf->lf_link;
      freelfile(lf);
      }
   llfiles = NULL;
#endif					/* MultipleRuns */

   }
