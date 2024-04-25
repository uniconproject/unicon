/*
 * File: fload.r
 *  Contents: loadfunc.
 *
 *  This file contains loadfunc(), the dynamic loading function for
 *  Unix systems having the <dlfcn.h> interface.
 *
 *  from Icon:
 *     p := loadfunc(filename, funcname)
 *     p(arg1, arg2, ...)
 *
 *  in C:
 *     int func(int argc, dptr argv)
 *        return -1 for failure, 0 for success, >0 for error
 *        argc is number of true args not including argv[0]
 *        argv[0] is for return value; others are true args
 */

#ifdef LoadFunc

#ifndef RTLD_LAZY	/* normally from <dlfcn.h> */
#define RTLD_LAZY 1
#endif					/* RTLD_LAZY */

#if NT
void *dlopen(char *name, int flag)
{ /* LoadLibrary */
   return (void *)LoadLibrary(name);
}
void *dlsym(void *handle, char *sym)
{
   return (void *)GetProcAddress((HMODULE)handle, sym);
}
int dlclose(void *handle)
{ /* FreeLibrary */
   return FreeLibrary((HMODULE)handle);
}
char *dlerror(void)
{
   return "undiagnosed dynamic load error";
}
#endif					/* NT */

#ifdef FreeBSD
   /*
    * If DL_GETERRNO exists, this is an FreeBSD 1.1.5 or 2.0 
    * which lacks dlerror(); supply a substitute.
    */
   #passthru #ifdef DL_GETERRNO
      char *dlerror(void)
      {
         int no;
   
         if (0 == dlctl(NULL, DL_GETERRNO, &no))
            return(strerror(no));
         else
            return(NULL);
      }
   #passthru #endif
#endif					/* __FreeBSD__ */

#if COMPILER
int glue(int, dptr, dptr, continuation);
#else
int glue(int, dptr);
#endif 					/* COMPILER */

"loadfunc(filename,funcname) - load C function dynamically."

function{0,1} loadfunc(filename,funcname)

   if !cnv:C_string(filename) then
      runerr(103, filename)
   if !cnv:C_string(funcname) then
      runerr(103, funcname)

   abstract {
      return proc
      }
   body
      {
      int (*func)();
      static char *curfile;
      static void *handle;
      char *funcname2;
   
      /*
       * Get a library handle, reusing it over successive calls.
       */
      MUTEX_LOCKID(MTX_CURFILE_HANDLE);
      if (!handle || !curfile || strcmp(filename, curfile) != 0) {
         if (curfile)
            free((pointer)curfile);	/* free the old file name */
         curfile = salloc(filename);	/* save the new name */
         handle = dlopen(filename, RTLD_LAZY);	/* get the handle */
         }

      /*
       * If not found, look in our plugins/lib directory
       * We are assuming that the plugins directory is either one
       * level up from iconx (which should be on the path) or it
       * is in the installed location.
       * TODO: this code is used at least in one other place
       *       (keyword.r), so it should be pulled into a util
       *       function.
       */
#if UNIX
      if (!handle) {
	 char path[MaxPath];
	 if (findonpath(UNICONX, path, MaxPath)) {
	    int n = strlen(path);
            /* Try the "not installed" location */
	    snprintf(path+n-strlen(UNICONX), MaxPath - n, "../plugins/lib/%s", filename );
	    handle = dlopen(path, RTLD_LAZY);	/* get the handle */
            if (!handle) {
              /* Try the "installed" location */
              snprintf(path+n-strlen(UNICONX), MaxPath - n, "../lib/unicon/plugins/lib/%s", filename );
              handle = dlopen(path, RTLD_LAZY);	/* get the handle */
            }
	    }
         }
#endif					/* UNIX */
#if NT
      /*
       * Replicate the UNIX logic above but with the added complications
       * of converting / to \ and trying lib.dll if lib.so doesn't work.
       */
      if (!handle) {
        char path[MaxPath];
        if (findonpath(UNICONX, path, MaxPath)) {
          int n = strlen(path);
          /* step backwards over the name of the executable (which ends in.exe) */
          while ((n > 0) && (path[n] != '\\') && (path[n] != '/')) --n;
          ++n;
          { /* Convert solidus to backslash */
            int slash;
            for (slash = 0; slash <= n; ++slash) {
              if (path[slash] == '/') path[slash] = '\\';
            }
          }
          /* Try the "not installed" location */
          snprintf(path+n, MaxPath - n, "..\\plugins\\lib\\%s", filename );
          handle = dlopen(path, RTLD_LAZY);
          if (!handle) { /* Try the "installed" location */
            snprintf(path+n, MaxPath - n,
                     "..\\lib\\unicon\\plugins\\lib\\%s", filename );
            handle = dlopen(path, RTLD_LAZY);
            if (!handle) { /* Repeat the whole process with .dll instead of .so */
              int ext = strlen(filename);
              if ((ext > 3) 
                  && (filename[--ext] == 'o')
                  && (filename[--ext] == 's')
                  && (filename[--ext] == '.')) {
                char dllname[ext+4];
                /*
                 * gcc is clever enough to warn
                 *    "specified bound depends on the length of the source argument"
                 * but not clever enough to realise the length of the destination
                 * is always big enough for it to fit (because it also depends on
                 * the length of the source argument).
                 */
#pragma GCC diagnostic push
                /*
                 * Why am I using _Pragma( ... )?
                 * Because #pragma ... doesn't suppress the warning
                 */
_Pragma("GCC diagnostic ignored \"-Wstringop-overflow=0\"");
                strncpy(dllname, filename, ext+1);
#pragma GCC diagnostic pop
                dllname[ext+1] = 'd'; dllname[ext+2] = 'l'; dllname[ext+3] = 'l';
                dllname[ext+4] = '\0';
                handle = dlopen(dllname, RTLD_LAZY);
                if (!handle) { /* Try the "not installed" location */
                  snprintf(path+n, MaxPath - n, "..\\plugins\\lib\\%s", dllname);
                  handle = dlopen(path, RTLD_LAZY);
                  if (!handle) { /* Try the "installed" location */
                    snprintf(path+n, MaxPath - n, 
                             "..\\lib\\unicon\\plugins\\lib\\%s", dllname);
                    handle = dlopen(path, RTLD_LAZY);
                  }
                }
              }
            }
          }
        }
      }
#endif                                  /* NT */

      /*
       * if handle has an "init" function, call it.
       * if not, we cannot run on Windows, but *NIX is OK.
       */
      func = (int (*)())dlsym(handle, "init");
      if (func) {
 	/*
	 * Windows .dll's have to be informed of the addresses for functions
	 * that are called from icall.h macros. FIXME: modify progstate to
	 * provide a discrete struct of functions pointers so that Windows
	 * .dll's can just be passed a pointer to those functions.
	 */
	 struct rtentrypts {
   	    int (*Cnvint)(dptr,dptr);
   	    int (*Cnvreal)(dptr,dptr);
   	    int (*Cnvstr)(dptr,dptr);
   	    int (*Cnvtstr)(char *,dptr,dptr);
	    int (*Cnvcset)(dptr,dptr);
   	    void (*Deref)(dptr,dptr);

	    char * (*Alcstr)(char *, word);
	    struct b_real * (*Alcreal) (double);
	    double (*Getdbl) (dptr);
	    int (*Cnvcstr)(dptr,dptr);
	    } rtentryvector;
#undef cnv_int_0
       	 rtentryvector.Cnvint = cnv_int;
         rtentryvector.Cnvreal = cnv_real;
	 rtentryvector.Cnvstr = cnv_str;
	 rtentryvector.Cnvcstr = cnv_c_str;
	 rtentryvector.Cnvtstr = cnv_tstr;
	 rtentryvector.Cnvcset = cnv_cset;
	 rtentryvector.Deref = deref;
 	 rtentryvector.Alcstr = alcstr;
 	 rtentryvector.Getdbl = getdbl;

	 (void) (*func)(&rtentryvector);
         }

      /*
       * Load the function.  Diagnose both library and function errors here.
       */
      if (handle) {
         func = (int (*)())dlsym(handle, funcname);
         if (!func) {
            /*
             * If no function, try again by prepending an underscore.
             * (for OpenBSD and similar systems.)
             */
            funcname2 = malloc(strlen(funcname) + 2);
            if (funcname2) {
               *funcname2 = '_';
               strcpy(funcname2 + 1, funcname);
               func = (int (*)())dlsym(handle, funcname2);
               free(funcname2);
               }
            }
         }
      if (!handle || !func) {
#if COMPILER && NT
         fprintf(stderr, "\nloadfunc(\"%s\",\"%s\"): dl error\n",
            filename, funcname);
#else						/* COMPILER && NT */
         if (!handle) {
           fprintf(stderr, "\nloadfunc(\"%s\",\"%s\"): cannot open file\n",
                   filename, funcname);
         } else {
           fprintf(stderr, "\nloadfunc(\"%s\",\"%s\"): %s\n",
                   filename, funcname, dlerror());
         }
#endif						/* COMPILER && NT*/
         MUTEX_UNLOCKID(MTX_CURFILE_HANDLE);
         runerr(216);
         }
      MUTEX_UNLOCKID(MTX_CURFILE_HANDLE);
      /*
       * Build and return a proc descriptor.
       */
      if (!makefunc(&result, funcname, func))
         runerr(305);
      return result;
      }
end

/*
 * makefunc(d, name, func) -- make function descriptor in d.
 *
 *  Returns 0 if memory could not be allocated.
 */
int makefunc(d, name, func)
dptr d;
char *name;
int (*func)();
   {
   struct b_proc *blk;

   blk = (struct b_proc *)malloc(sizeof(struct b_proc));
   if (!blk)
      return 0;
   blk->title = T_Proc;
   blk->blksize = sizeof(struct b_proc);

#if COMPILER
   blk->ccode = glue;		/* set code addr to glue routine */
#else					/* COMPILER */
   blk->entryp.ccode = glue;	/* set code addr to glue routine */
#endif					/* COMPILER */

   blk->nparam = -1;		/* varargs flag */
   blk->ndynam = -1;		/* treat as built-in function */
   blk->nstatic = 0;
   blk->fstatic = 0;
   blk->pname.dword = strlen(name);
   blk->pname.vword.sptr = salloc(name);
   blk->lnames[0].dword = 0;
   blk->lnames[0].vword.sptr = (char *)func;
				/* save func addr in lnames[0] vword */
   d->dword = D_Proc;		/* build proc descriptor */
   d->vword.bptr = (union block *)blk;
   return 1;
   }

/*
 * This glue routine is called when a loaded function is invoked.
 * It digs the actual C code address out of the proc block, and calls that.
 */

#if COMPILER

int glue(argc, dargv, rslt, succ_cont)
int argc;
dptr dargv;
dptr rslt;
continuation succ_cont;
   {
   int i, status, (*func)();
   struct b_proc *blk;
   struct descrip r;
   tended struct descrip p;

   dargv--;				/* reset pointer to proc entry */
   for (i = 0; i <= argc; i++)
      deref(&dargv[i], &dargv[i]);	/* dereference args including proc */

   blk = (struct b_proc *)dargv[0].vword.bptr;	/* proc block address */
   func = (int (*)())blk->lnames[0].vword.sptr;	/* entry point address */

   p = dargv[0];			/* save proc for traceback */
   dargv[0] = nulldesc;			/* set default return value */

   status = (*func)(argc, dargv);	/* call func */

   if (status == 0) {
      *rslt = dargv[0];
      Return;				/* success */
      }

   if (status < 0)
      Fail;				/* failure */

   r = dargv[0];			/* save result value */
   dargv[0] = p;			/* restore proc for traceback */
   if (is:null(r))
      RunErr(status, NULL);		/* error, no value */
   RunErr(status, &r);			/* error, with value */
   }

#else						/* COMPILER */

int glue(argc, dargv)
int argc;
dptr dargv;
   {
   int status, (*func)();
   struct b_proc *blk;
   struct descrip r;
   tended struct descrip p;

   blk = (struct b_proc *)dargv[0].vword.bptr;	/* proc block address */
   func = (int (*)())blk->lnames[0].vword.sptr;	/* entry point address */

   p = dargv[0];			/* save proc for traceback */
   dargv[0] = nulldesc;			/* set default return value */

   status = (*func)(argc, dargv);	/* call func */

   if (status == 0)
      Return;				/* success */
   if (status < 0)
      Fail;				/* failure */

   r = dargv[0];			/* save result value */
   dargv[0] = p;			/* restore proc for traceback */
   if (is:null(r))
      RunErr(status, NULL);		/* error, no value */
   RunErr(status, &r);			/* error, with value */
   }

#endif						/* COMPILER */

#else						/* LoadFunc */
/*static char junk;			/* avoid empty module */
#endif						/* LoadFunc */
