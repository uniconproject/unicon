#if !COMPILER
/*
 * File: imain.r
 * Interpreter main program, argument handling, and such.
 * Contents: main, icon_call, icon_setup, resolve, xmfree
 */

#include "../h/version.h"
#include "../h/header.h"
#include "../h/opdefs.h"

#if MSDOS
   static union {
      pointer stkadr;
      word stkint;
   } stkword;
#endif                          /* MSDOS */


/*
 * Prototypes.
 */
void    icon_setup      (int argc, char **argv, int *ip);

/*
 * The following code is operating-system dependent [@imain.01].  Declarations
 *   that are system-dependent.
 */

#if PORT
   /* probably needs something more */
Deliberate Syntax Error
#endif                                  /* PORT */

#if MSDOS || MVS || VM || UNIX || VMS
   /* nothing needed */
#endif                                  /* MSDOS || ... */

/*
 * End of operating-system specific code.
 */

extern int set_up;

/*
 * A number of important variables follow.
 */

#ifndef MultiProgram
int n_globals = 0;                      /* number of globals */
int n_statics = 0;                      /* number of statics */
#endif                                  /* MultiProgram */

/*
 * Initial icode sequence. This is used to invoke the main procedure with one
 *  argument.  If main returns, the Op_Quit is executed.
 */
word istart[4];
int mterm = Op_Quit;




#if NT
/*
 * On all Microsoft systems, main() here is named iconx().
 * On nticonx, a trivial main (found in rwinsys.r) just calls iconx().
 * For iconx and wiconx, an MSSstartup() and WinMain() call iconx(),
 * since main() is provided by Windows.
 */
#define main iconx
#endif


#if NT                          /* MSWindows */
#if WildCards
void ExpandArgv(int *argcp, char ***avp)
{
   int argc = *argcp;
   char **argv = *avp;
   char **newargv;
   FINDDATA_T fd;
   int j,newargc=0;
   for(j=0; j < argc; j++) {
      newargc++;
      if (strchr(argv[j], '*') || strchr(argv[j], '?')) {
         if (FINDFIRST(argv[j], &fd)) {
            while (FINDNEXT(&fd)) newargc++;
            FINDCLOSE(&fd);
            }
         }
      }
   if (newargc == argc) return;

   if ((newargv = malloc((newargc+1) * sizeof (char *))) == NULL) return;
   newargc = 0;
   for(j=0; j < argc; j++) {
      if (strchr(argv[j], '*') || strchr(argv[j], '?')) {
         if (FINDFIRST(argv[j], &fd)) {
            char dir[MaxPath];
            int end;
            strcpy(dir, argv[j]);
            do {
               end = strlen(dir)-1;
               while(end >= 0 && !strchr("\\/:", dir[end])) {
                  dir[end] = '\0';
                  end--;
                  }
               strcat(dir, FILENAME(&fd));
               newargv[newargc++] = strdup(dir);
               newargv[newargc] = NULL;
               } while (FINDNEXT(&fd));
            FINDCLOSE(&fd);
            }
         else {
            newargv[newargc++] = strdup(argv[j]);
            }
         }
      else {
         newargv[newargc++] = strdup(argv[j]);
         }
      }
   *avp = newargv;
   *argcp = newargc;
}
#endif                                  /* WildCards */
#endif                                  /* NT */

#ifdef DLLICONX
#passthru void __declspec(dllexport) iconx_entry(int argc, char **argv)
#else                                   /* DLLICONX */
#ifdef INTMAIN
int main(int argc, char **argv)
#else
void main(int argc, char **argv)
#endif                                  /* INTMAIN */
#endif                                  /* DLLICONX */
   {
   int i, slen;

#ifdef Concurrent
   struct b_coexpr *curtstate_ce;
#ifndef HAVE_KEYWORD__THREAD
   struct threadstate *curtstate;
   pthread_key_create(&tstate_key, NULL);
#endif                                  /* HAVE_KEYWORD__THREAD */
   rt_status = RTSTATUS_NORMAL;
   init_threads();
   global_curtstate = &roottstate;
#endif                                  /* Concurrent */

#if WildCards && NT
   ExpandArgv(&argc, &argv);
#endif                                  /* WildCards && NT */

#ifdef MultiProgram
   /*
    * Look for MultiProgram programming environment in which to execute
    * this program, specified by MTENV environment variable.
    */
   {
   char *p = NULL;
   char **new_argv = NULL;
   int i=0, j = 1, k = 1;
   if ((p = getenv("MTENV")) != NULL) {
      for(i=0;p[i];i++)
         if (p[i] == ' ')
            j++;
      new_argv = (char **)malloc((argc + j) * sizeof(char *));
      new_argv[0] = argv[0];
      for (i=0; p[i]; ) {
         new_argv[k++] = p+i;
         while (p[i] && (p[i] != ' '))
            i++;
         if (p[i] == ' ')
            p[i++] = '\0';
         }
      for(i=1;i<argc;i++)
         new_argv[k++] = argv[i];
      argc += j;
      argv = new_argv;
      }
   }
#endif                                  /* MultiProgram */

#ifndef Concurrent
 ipc.opnd = NULL;
#endif                                  /* Concurrent */

#if UNIX
   /*
    *  Append to FPATH the bin directory from which iconx was executed.
    */
   {
      char *p = getenv("FPATH");
      char *q = relfile(argv[0], "/..");
      char *buf = malloc((p?strlen(p):1) + (q?strlen(q):1) + 8);
      if (buf) {
         sprintf(buf, "FPATH=%s %s", (p ? p : "."), (q ? q : "."));
         putenv(buf);
         /* buf is part of the environment; don't free it. */
         }
      }
#endif                                  /* UNIX */

   /*
    * Setup Icon interface.  It's done this way to avoid duplication
    *  of code, since the same thing has to be done if calling Icon
    *  is enabled.
    */

   icon_setup(argc, argv, &i);

   if (i < 0) {
      argc++;
      argv--;
      i++;
      }

   while (i--) {                        /* skip option arguments */
      argc--;
      argv++;
      }

   if (argc <= 1) {
      error(NULL, "no icode file specified");
      }

   /*
    * Call icon_init with the name of the icode file to execute.        [[I?]]
    */
   icon_init(argv[1], &argc, argv);

#ifdef MultiProgram
   curtstate = &roottstate;
#ifdef Concurrent
   curtstate_ce = curtstate->c;
#endif                                  /* Concurrent */
#endif                                  /* MultiProgram */

#ifdef Messaging
   errno = 0;
#endif                                  /* Messaging */


#ifdef NativeObjects
   /*
    * The following block of code calls <classname>initialize() methods of
    * every class in the program. initialize methods create an instance of the
    * methods vector record for the class. In the original implementation of
    * Unicon, methods vector instance is created when first instance of that
    * class is created. This implementation creates methods vectors for all
    * the classes in the program before main() begins its execution.
    *
    * This is achieved by calling initialize() methods in icode from this
    * program. Following block of code aligns icode instructions to call
    * initialize() method and descriptor for these methods are pushed
    * on stack. When instructions and stack is setup, interp() is called
    * just like it is called for execution of main().
    *
    * This program also implements the modified Unicon object structure.
    * Object instances no longer carry a pointer to the methods vector.
    * Instead, the record constructor block now holds pointer to it.
    *
    * When initialize() method is called, it assigns the newly created method
    * vector pointer to <classname>__oprec global variable. This new value is
    * also copied into __m field of the record constructor block. This field
    * is reserved.
    */

{
#ifdef StackCheck
    unsigned *temp_stackend=BlkD(k_current,Coexpr)->es_stackend, *temp_sp=sp;
#else                                   /* StackCheck */
    unsigned *temp_stackend=stackend, *temp_sp=sp;
#endif                                  /* StackCheck */
    inst temp_ipc=ipc;
    struct gf_marker *temp_gfp=gfp;
    struct ef_marker *temp_efp=efp;
    struct pf_marker *temp_pfp=pfp;
    int temp_ilevel=ilevel;
    dptr temp_glbl_argp = glbl_argp;
    int temp_set_up=set_up;

    int numberof_globals,i,j,k;
    char classname[500]={0}, *begin=0,*position=0;
    register dptr dp=0;
    char *initialize="initialize";
    int initialize_length=strlen(initialize);

    numberof_globals = egnames - gnames;

    for(i=0;i < numberof_globals;++i) {
       char *sptr;

       if ((globals[i].dword == D_Proc) &&
           (sptr=globals[i].vword.bptr->proc.pname.vword.sptr) &&
           (position=(char *)memmem(sptr,strlen(sptr)+1,initialize,initialize_length+1))) {

          begin=sptr;
          k=0;
          while(begin != position) {
             classname[k]=*begin;
             k++;
             begin++;
          }
          classname[k]=0;

#ifdef StackCheck
          BlkD(k_current,Coexpr)->es_stackend = BlkD(k_current,Coexpr)->es_stack + mstksize/WordSize;
          sp = BlkD(k_current,Coexpr)->es_stack + Wsizeof(struct b_coexpr);
#else                                   /* StackCheck */
          stackend = stack + mstksize/WordSize;
          sp = stack + Wsizeof(struct b_coexpr);
#endif                                  /* StackCheck */

          ipc.opnd = istart;
          *ipc.op++ = Op_Noop;
          *ipc.op++ = Op_Invoke;
          *ipc.opnd++ = 0;
          *ipc.op = Op_Quit;
          ipc.opnd = istart;

          gfp = 0;

          efp = (struct ef_marker *)(sp);
          efp->ef_failure.op = &mterm;
          efp->ef_gfp = 0;
          efp->ef_efp = 0;
          efp->ef_ilevel = 1;
          sp += Wsizeof(*efp) - 1;

          pfp = 0;
          ilevel = 0;

          glbl_argp = 0;
          set_up = 1;

          PushDesc(globals[i]);
#ifdef TSTATARG
          interp(0,(dptr)NULL, CURTSTATARG);           /*      [[I?]] */
#else                                    /* TSTATARG */
          interp(0,(dptr)NULL);                        /*      [[I?]] */
#endif                                   /* TSTATARG */
          /*
           * Now we have <classname>__oprec pointing at method vector.
           * Copy it in  __m field of record constructor block
           */

          strcat(classname,"__state");
          for(j=0; j < numberof_globals; ++j) {
             union block *bptr=globals[j].vword.bptr;
             if((globals[j].dword == D_Proc) && (-3 == bptr->proc.ndynam) &&
                (0==strcmp(classname,bptr->proc.pname.vword.sptr))) {
                *strstr(classname,"__state")=0;
                strcat(classname,"__oprec");

                for(k=0;k < numberof_globals;++k) {
                   if(strcmp(classname,gnames[k].vword.sptr)==0) {
                      bptr->proc.lnames[bptr->proc.nparam]=globals[k];
                      j = numberof_globals; /* exit outer for-loop */
                      break;
                      }
                   }
                }
             }
          }
       }

#ifdef StackCheck
    BlkD(k_current,Coexpr)->es_stackend=temp_stackend;
#else                                   /* StackCheck */
    stackend=temp_stackend;
#endif                                  /* StackCheck */
    sp=temp_sp;
    ipc=temp_ipc;
    gfp=temp_gfp;
    efp=temp_efp;
    pfp=temp_pfp;
    ilevel=temp_ilevel;
    glbl_argp = temp_glbl_argp;
    set_up=temp_set_up;
    }
#endif                                  /* NativeObjects */


   /*
    *  Point sp at word after b_coexpr block for &main, point ipc at initial
    *   icode segment, and clear the gfp.
    */
#ifdef StackCheck
   BlkD(k_current,Coexpr)->es_stackend = BlkD(k_current,Coexpr)->es_stack + mstksize/WordSize;
   sp = BlkD(k_current,Coexpr)->es_stack + Wsizeof(struct b_coexpr);
#else                                   /* StackCheck */
   stackend = stack + mstksize/WordSize;
   sp = stack + Wsizeof(struct b_coexpr);
#endif                                  /* StackCheck */

   ipc.opnd = istart;
   *ipc.op++ = Op_Noop;  /* aligns Invoke's operand */  /*      [[I?]] */
   *ipc.op++ = Op_Invoke;                               /*      [[I?]] */
   *ipc.opnd++ = 1;
   *ipc.op = Op_Quit;
   ipc.opnd = istart;

   gfp = 0;

   /*
    * Set up expression frame marker to contain execution of the
    *  main procedure.  If failure occurs in this context, control
    *  is transferred to mterm, the address of an Op_Quit.
    */
   efp = (struct ef_marker *)(sp);
   efp->ef_failure.op = &mterm;
   efp->ef_gfp = 0;
   efp->ef_efp = 0;
   efp->ef_ilevel = 1;
   sp += Wsizeof(*efp) - 1;

   pfp = 0;
   ilevel = 0;

/*
 * We have already loaded the
 * icode and initialized things, so it's time to just push main(),
 * build an Icon list for the rest of the arguments, and called
 * interp on a "invoke 1" bytecode.
 */
   /*
    * The first global variable holds the value of "main".  If it
    *  is not of type procedure, this is noted as run-time error 117.
    *  Otherwise, this value is pushed on the stack.
    */
   if (globals[0].dword != D_Proc)
      fatalerr(117, NULL);

   PushDesc(globals[0]);
   PushNull;
   glbl_argp = (dptr)(sp - 1);

   /*
    * If main() has a parameter, it is to be invoked with one argument, a list
    *  of the command line arguments.  The command line arguments are pushed
    *  on the stack as a series of descriptors and Ollist is called to create
    *  the list.  The null descriptor first pushed serves as Arg0 for
    *  Ollist and receives the result of the computation.
    */
   if (((struct b_proc *)BlkLoc(globals[0]))->nparam > 0) {
      for (i = 2; i < argc; i++) {
         char *tmp;
         slen = strlen(argv[i]);
         PushVal(slen);
         Protect(tmp=alcstr(argv[i],(word)slen), fatalerr(0,NULL));
         PushAVal(tmp);
         }

      Ollist(argc - 2, glbl_argp);
      }


   sp = (word *)glbl_argp + 1;
   glbl_argp = 0;

   set_up = 1;                  /* post fact that iconx is initialized */

   /*
    * Start things rolling by calling interp.  This call to interp
    *  returns only if an Op_Quit is executed.  If this happens,
    *  c_exit() is called to wrap things up.
    */
#ifdef TSTATARG
   interp(0,(dptr)NULL, CURTSTATARG);           /*      [[I?]] */
#else                                    /* TSTATARG */
   interp(0,(dptr)NULL);                        /*      [[I?]] */
#endif                                   /* TSTATARG */

   c_exit(EXIT_SUCCESS);
#ifdef INTMAIN
   return 0;
#endif
}

/*
 * icon_setup - handle interpreter command line options.
 */
void icon_setup(argc,argv,ip)
int argc;
char **argv;
int *ip;
   {

#ifdef TallyOpt
   extern int tallyopt;
#endif                                  /* TallyOpt */

   *ip = 0;                     /* number of arguments processed */

#ifdef ExecImages
   if (dumped) {
      /*
       * This is a restart of a dumped interpreter.  Normally, argv[0] is
       *  iconx, argv[1] is the icode file, and argv[2:(argc-1)] are the
       *  arguments to pass as a list to main().  For a dumped interpreter
       *  however, argv[0] is the executable binary, and the first argument
       *  for main() is argv[1].  The simplest way to handle this is to
       *  back up argv to point at argv[-1] and increment argc, giving the
       *  illusion of an additional argument at the head of the list.  Note
       *  that this argument is never referenced.
       */
      argv--;
      argc++;
      (*ip)--;
      }
#endif                                  /* ExecImages */

   /*
    * if we didn't start with *iconx[.exe], backup one
    * so that our icode filename is argv[1].
    */
   {
   int len = 0;
   char *tmp = strdup(argv[0]), *t2 = tmp;
   if (tmp == NULL) {
      syserr("memory allocation failure in startup code");
      }
   while (*t2) {
      *t2 = tolower(*t2);
      t2++;
      }
   len = t2 - tmp;

   if (len > 4 && !strcmp(tmp+len-4, ".exe")) {len -= 4; tmp[len] = '\0'; }

   /*
    * if argv[0] is not a reference to our interpreter, take it as the
    * name of the icode file, and back up for it.
    */
   if (!(len >= 5 && !strcmp(tmp+len-4, "conx"))) {
      argv--;
      argc++;
      (*ip)--;
      }

   free(tmp);
   }

#ifdef MaxLevel
   maxilevel = 0;
   maxplevel = 0;
   maxsp = 0;
#endif                                  /* MaxLevel */

/*
 * Handle command line options.
*/
   while ( argv[1] != 0 && *argv[1] == '-' ) {
      char optletter = *(argv[1]+1);
      switch ( optletter ) {

#ifdef TallyOpt
        /*
         * Set tallying flag if -T option given
         */
        case 'T':
            tallyopt = 1;
            break;
#endif                                  /* TallyOpt */

        /*
         * Perform version check and exit if -V option given
         */
        case 'V': {
            extern int versioncheck_only;
            versioncheck_only = 1;
            }
            break;

         /* -l: IDE whole-console-session logfile */
         /* -L: runtime error messaging logfile */
         case 'l': case 'L': {
            extern char *logopt;
            char *p;
            if ( *(argv[1]+2) != '\0' )
               p = argv[1]+2;
            else {
               argv++;
               argc--;
               (*ip)++;
               p = argv[1];
               if ( !p )
                  error(NULL, "no file name given for logfile");
               }
            if(optletter == 'l') {
               openlog(p);
               if (!flog)
                  syserr("Unable to open logfile\n");
               }
            else { /* -L */
               logopt = p;
               }
            break;
            }

      /*
       * Set stderr to new file if -e option is given.
       */
         case 'e': {
            char *p;
            if ( *(argv[1]+2) != '\0' )
               p = argv[1]+2;
            else {
               argv++;
               argc--;
               (*ip)++;
               p = argv[1];
               if ( !p )
                  error(NULL, "no file name given for redirection of &errout");
               }
            if (!redirerr(p))
               syserr("Unable to redirect &errout\n");
            break;
            }
        }
        argc--;
        (*ip)++;
        argv++;
      }
   }

/*
 * resolve - perform various fix-ups on the data read from the icode
 *  file.
 */
#ifdef MultiProgram
   void resolve(pstate)
   struct progstate *pstate;
#else                                   /* MultiProgram */
   void resolve()
#endif                                  /* MultiProgram */

   {
   register word i, j;
   register struct b_proc *pp;
   register dptr dp;
   #ifdef MultiProgram
      register struct progstate *savedstate = curpstate;
      CURTSTATE();
      if (pstate){
        curpstate = pstate;
        curtstate = pstate->tstate;
        }
   #endif                                       /* MultiProgram */

   /*
    * Relocate the names of the global variables.
    */
   for (dp = gnames; dp < egnames; dp++)
      StrLoc(*dp) = strcons + (uword)StrLoc(*dp);

   /*
    * Scan the global variable array for procedures and fill in appropriate
    *  addresses.
    */
   for (j = 0; j < n_globals; j++) {

      if (globals[j].dword != D_Proc)
         continue;

      /*
       * The second word of the descriptor for procedure variables tells
       *  where the procedure is.  Negative values are used for built-in
       *  procedures and positive values are used for Icon procedures.
       */
      i = IntVal(globals[j]);

      if (i < 0) {
         /*
          * globals[j] points to a built-in function; call (bi_)strprc
          *  to look it up by name in the interpreter's table of built-in
          *  functions.
          */
         if((BlkLoc(globals[j])= (union block *)bi_strprc(gnames+j,0)) == NULL)
            globals[j] = nulldesc;              /* undefined, set to &null */
         }
      else {

         /*
          * globals[j] points to an Icon procedure or a record; i is an offset
          *  to location of the procedure block in the code section.  Point
          *  pp at the block and replace BlkLoc(globals[j]).
          */
         pp = (struct b_proc *)(code + i);
         BlkLoc(globals[j]) = (union block *)pp;

         /*
          * Relocate the address of the name of the procedure.
          */
         StrLoc(pp->pname) = strcons + (uword)StrLoc(pp->pname);

         if ((pp->ndynam == -2) || (pp->ndynam == -3)) {
            /*
             * This procedure is a record constructor.  Make its entry point
             *  be the entry point of Omkrec().
             */
            pp->entryp.ccode = Omkrec;

            /*
             * Initialize field names
             */
            for (i = 0; i < pp->nfields; i++)
               StrLoc(pp->lnames[i]) = strcons + (uword)StrLoc(pp->lnames[i]);

            }
         else {
            /*
             * This is an Icon procedure.  Relocate the entry point and
             *  the names of the parameters, locals, and static variables.
             */
            pp->entryp.icode = code + pp->entryp.ioff;
            for (i = 0; i < abs((int)pp->nparam)+pp->ndynam+pp->nstatic; i++)
               StrLoc(pp->lnames[i]) = strcons + (uword)StrLoc(pp->lnames[i]);
            }
         }
      }

   /*
    * Relocate the names of the fields.
    */

   for (dp = fnames; dp < efnames; dp++)
      StrLoc(*dp) = strcons + (uword)StrLoc(*dp);

#ifdef MultiProgram
   curpstate = savedstate;
   curtstate = curpstate->tstate;
   (void) curtstate;  /* silence "not used" compiler warning */
#endif                                          /* MultiProgram */
   }

/*
 * Free malloc-ed memory; the main regions then co-expressions.  Note:
 *  this is only correct if all allocation is done by routines that are
 *  compatible with free() -- which may not be the case for all memory.
 */

void xmfree()
   {
   register struct b_coexpr **ep, *xep;
   register struct astkblk *abp, *xabp;
   CURTSTATE();

   if (mainhead == NULL) return;        /* already xmfreed */
   free((pointer)mainhead->es_actstk);  /* activation block for &main */
   mainhead->es_actstk = NULL;
#ifdef StackCheck
   free((pointer)mainhead->es_stack);   /* interpreter stack */
   mainhead->es_stack = NULL;
#else                                   /* StackCheck */
   free((pointer)stack);                /* interpreter stack */
   stack = NULL;
#endif                                  /* StackCheck */
   mainhead = NULL;

   free((pointer)code);                 /* icode */
   code = NULL;
   /*
    * more is needed to free chains of heaps, also a multithread version
    * of this function may be needed someday.
    */
   if (strbase)
      free((pointer)strbase);           /* allocated string region */
   strbase = NULL;
   if (blkbase)
      free((pointer)blkbase);           /* allocated block region */
   blkbase = NULL;
#ifndef MultiProgram
   if (curstring != &rootstring)
      free((pointer)curstring);         /* string region */
   curstring = NULL;
   if (curblock != &rootblock)
      free((pointer)curblock);          /* allocated block region */
   curblock = NULL;
#endif                                  /* MultiProgram */
   if (quallist)
      free((pointer)quallist);          /* qualifier list */
   quallist = NULL;

   /*
    * The co-expression blocks are linked together through their
    *  nextstk fields, with stklist pointing to the head of the list.
    *  The list is traversed and each stack is freeing.
    */
   MUTEX_LOCKID(MTX_STKLIST);
   ep = &stklist;
   while (*ep != NULL) {
      xep = *ep;
      *ep = (*ep)->nextstk;
       /*
        * Free the astkblks.  There should always be one and it seems that
        *  it's not possible to have more than one, but nonetheless, the
        *  code provides for more than one.
        */
      for (abp = xep->es_actstk; abp; ) {
         xabp = abp;
         abp = abp->astk_nxt;
         free((pointer)xabp);
         }

#ifdef Concurrent
         /*
          * do we need to kill a thread before we free its pointer here
          */
#endif                                  /* Concurrent */

      free((pointer)xep);
      stklist = NULL;
      }
   MUTEX_UNLOCKID(MTX_STKLIST);
   }
#endif                                  /* !COMPILER */

#if NT

/*
 * Convert an argv array to a command line string.  argv[0] is searched
 * on the PATH, since system() or its relatives do not reliably do that.
 */
char *ArgvToCmdline(char **argv)
{
   int i, q, len = 0;
   char *mytmp, *tmp2;
   mytmp = malloc(1024);
   if ((argv == NULL) || (argv[0] == NULL)) return NULL;
   for (i=0; argv[i]; i++) len += strlen(argv[i]) + 1;
   if (strcmp(".exe", argv[0]+(strlen(argv[0])-4))) {
      tmp2 = malloc(strlen(argv[0])+5);
      strcpy(tmp2, argv[0]);
      strcat(tmp2, ".exe");
      }
   else tmp2 = strdup(argv[0]);
   mytmp[0] = '\0';
   q = pathFind(tmp2, mytmp, 2048);
   if (!q) strcpy(mytmp,argv[0]);
   else {
      char *qq = mytmp;
      while (qq=strchr(qq, '/')) *qq='\\';
      if (strchr(mytmp, ' ')) {
         int j = strlen(mytmp);
         mytmp[j+2] = '\0';
         mytmp[j+1] = '"';
         for( ; j > 0 ; j--) mytmp[j] = mytmp[j-1];
         mytmp[0] = '"';
         }
      }
   len += strlen(mytmp);
   if (len > 1023) mytmp = realloc(mytmp, len+1);

   i = 1;
   while (argv[i] != NULL) {
      strcat(mytmp, " ");
      strcat(mytmp, argv[i++]);
   }
   return mytmp;
}
#endif                                  /* NT */
