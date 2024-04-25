/*
 * rdebug.r - tracebk, get_name, xdisp, ctrace, rtrace, failtrace, strace,
 *   atrace, cotrace
 */

/*
 * Prototypes.
 */
static int     glbcmp    (char *pi, char *pj);
static int     keyref    (union block *bp, dptr dp);
static void showline  (char *f, int l);
static void showlevel (register int n);
#if !COMPILER
static void ttrace      (FILE *f);
#endif                                  /* !COMPILER */
static void xtrace
   (struct b_proc *bp, word nargs, dptr arg, int pline, char *pfile, FILE *logfile);

/*
 * tracebk - print a trace of procedure calls.
 */

#if COMPILER
void tracebk(struct p_frame *lcl_pfp, dptr argp, FILE *logfptr)
#else                                   /* COMPILER */
void tracebk(struct pf_marker *lcl_pfp, dptr argp, FILE *logfptr)
#endif                                  /* COMPILER */
   {
   struct b_proc *cproc;
#if COMPILER
   struct debug *debug;
#else                                   /* COMPILER */
   //long depth = 0, iteration = 0;
   struct pf_marker *origpfp;
   dptr arg;
   inst cipc;
#endif                                  /* COMPILER */
   CURTSTATE_AND_CE();

#if COMPILER
   if (lcl_pfp == NULL)
      return;
   debug = PFDebug(*lcl_pfp);
   tracebk(lcl_pfp->old_pfp, lcl_pfp->old_argp, logfptr);
   cproc = debug->proc;
   xtrace(cproc, (word)abs((int)cproc->nparam), argp, debug->old_line,
      debug->old_fname, logfptr);
#else                                   /* COMPILER */
   origpfp = pfp;
   /*
    * Chain back through the procedure frame markers, looking for the
    *  first one, while building a foward chain of pointers through
    *  the expression frame pointers.
    */

   for (pfp->pf_efp = NULL; pfp->pf_pfp != NULL; pfp = pfp->pf_pfp) {
      (pfp->pf_pfp)->pf_efp = (struct ef_marker *)pfp;
      //depth++;
      }

   /* Now start from the base procedure frame marker, producing a listing
    *  of the procedure calls up through the last one.
    */

   while (pfp) {
      arg = &((dptr)pfp)[-(pfp->pf_nargs) - 1];
      cproc = (struct b_proc *)BlkLoc(arg[0]);
      /*
       * The ipc in the procedure frame points after the "invoke n".
       */
      cipc = pfp->pf_ipc;
      --cipc.opnd;
      --cipc.op;

      xtrace(cproc, pfp->pf_nargs, &arg[0], findline(cipc.opnd),
        findfile(cipc.opnd), logfptr);

      /*
       * On the last call, show both the call and the offending expression.
       */
      if (pfp == origpfp) {
         if(logfptr != NULL)
            ttrace(logfptr);
         ttrace(stderr);
         if (logfptr != NULL)
            fprintf(logfptr, "\n\n\n");
         break;
         }

      pfp = (struct pf_marker *)(pfp->pf_efp);
      //iteration++;
      }
#endif                                  /* COMPILER */
   }

/*
 * xtrace - procedure *bp is being called with nargs arguments, the first
 *  of which is at arg; produce a trace message.
 */
static void xtrace(struct b_proc *bp, word nargs, dptr arg, int pline, char *pfile, FILE *logfile)
   {

   fprintf(stderr, "   ");
   if (logfile != NULL)
      fprintf(logfile, "   ");
   if (bp == NULL) {
      fprintf(stderr, "????");
      if (logfile != NULL)
         fprintf(logfile, "????");
      }
   else {

#if COMPILER
      putstr(stderr, &(bp->pname));
#else                                   /* COMPILER */
      if (arg[0].dword == D_Proc) {
         putstr(stderr, &(bp->pname));
         if (logfile != NULL)
            putstr(logfile, &(bp->pname));
         }
      else {
         outimage(stderr, arg, 0);
         if(logfile != NULL)
            outimage(logfile, arg, 0);
         }
      arg++;
#endif                                  /* COMPILER */

      putc('(', stderr);
      if (logfile != NULL)
         putc('(', logfile);
      while (nargs--) {
         if (logfile != NULL)
            outimage(logfile, arg, 0);
         outimage(stderr, arg++, 0);
         if (nargs) {
            putc(',', stderr);
            if (logfile != NULL)
               putc(',', logfile);
            }
         }
      putc(')', stderr);
      if (logfile != NULL)
         putc(')', logfile);
      }

   if (pline != 0) {
      fprintf(stderr, " from line %d in %s", pline, pfile);
      if (logfile != NULL)
         fprintf(logfile, " from line %d in %s", pline, pfile);
      }
   putc('\n', stderr);
   if (logfile != NULL)
     putc('\n', logfile);
   fflush(stderr);
   }


/*
 * get_name -- function to get print name of variable.
 */
int get_name(dptr dp1,dptr dp0)
   {
   dptr dp, varptr;
   tended union block *blkptr;
   dptr arg1;                           /* 1st parameter */
   dptr loc1;                           /* 1st local */
   struct b_proc *proc;                 /* address of procedure block */
   char sbuf[100];                      /* buffer; might be too small */
   char *s, *s2;
   word i, j, k;
   int t;

#if COMPILER
   arg1 = glbl_argp;
   loc1 = pfp->t.d;
   proc = PFDebug(*pfp)->proc;
#else                                   /* COMPILER */
   arg1 = &glbl_argp[1];
   loc1 = pfp->pf_locals;
   proc = BlkD(*glbl_argp,Proc);
#endif                                  /* COMPILER */

   type_case *dp1 of {
      tvsubs: {
         blkptr = (union block *)BlkD(*dp1, Tvsubs);
         get_name(&((blkptr->Tvsubs.ssvar)),dp0);
         sprintf(sbuf,"[%ld:%ld]",(long)(blkptr->Tvsubs.sspos),
            (long)(blkptr->Tvsubs.sspos)+(blkptr->Tvsubs.sslen));
         k = StrLen(*dp0);
         j = strlen(sbuf);

         /*
          * allocate space for both the name and the subscript image,
          *  and then copy both parts into the allocated space
          */
         Protect(s = alcstr(NULL, k + j), return RunError);
         s2 = StrLoc(*dp0);
         StrLoc(*dp0) = s;
         StrLen(*dp0) = j + k;
         for (i = 0; i < k; i++)
            *s++ = *s2++;
         s2 = sbuf;
         for (i = 0; i < j; i++)
            *s++ = *s2++;
         }

      tvtbl: {
         t = keyref((union block *)BlkD(*dp1, Tvtbl) ,dp0);
         if (t == RunError)
            return RunError;
          }

      kywdint:
         if (VarLoc(*dp1) == &kywd_ran) {
            StrLen(*dp0) = 7;
            StrLoc(*dp0) = "&random";
            }
         else if (VarLoc(*dp1) == &kywd_trc) {
            StrLen(*dp0) = 6;
            StrLoc(*dp0) = "&trace";
            }

#ifdef FncTrace
         else if (VarLoc(*dp1) == &kywd_ftrc) {
            StrLen(*dp0) = 7;
            StrLoc(*dp0) = "&ftrace";
            }
#endif                                  /* FncTrace */

         else if (VarLoc(*dp1) == &kywd_dmp) {
            StrLen(*dp0) = 5;
            StrLoc(*dp0) = "&dump";
            }
         else if (VarLoc(*dp1) == &kywd_err) {
            StrLen(*dp0) = 6;
            StrLoc(*dp0) = "&error";
            }
#ifdef PosixFns
         else if (VarLoc(*dp1) == &amperErrno) {
            StrLen(*dp0) = 6;
            StrLoc(*dp0) = "&errno";
            }
#endif                                  /* PosixFns */
#ifdef Graphics
         else if (VarLoc(*dp1) == &amperCol) {
            StrLen(*dp0) = 4;
            StrLoc(*dp0) = "&col";
            }
         else if (VarLoc(*dp1) == &amperRow) {
            StrLen(*dp0) = 4;
            StrLoc(*dp0) = "&row";
            }
         else if (VarLoc(*dp1) == &amperX) {
            StrLen(*dp0) = 2;
            StrLoc(*dp0) = "&x";
            }
         else if (VarLoc(*dp1) == &amperY) {
            StrLen(*dp0) = 2;
            StrLoc(*dp0) = "&y";
            }
         else if (VarLoc(*dp1) == &amperInterval) {
            StrLen(*dp0) = 9;
            StrLoc(*dp0) = "&interval";
            }
#endif                                  /* Graphics */
         else
            syserr("name: unknown integer keyword variable");

      kywdevent:
#ifdef MultiProgram
         if (VarLoc(*dp1) == &curpstate->eventsource) {
            StrLen(*dp0) = 12;
            StrLoc(*dp0) = "&eventsource";
            }
         else if (VarLoc(*dp1) == &curpstate->eventval) {
            StrLen(*dp0) = 11;
            StrLoc(*dp0) = "&eventvalue";
            }
         else if (VarLoc(*dp1) == &curpstate->eventcode) {
            StrLen(*dp0) = 10;
            StrLoc(*dp0) = "&eventcode";
            }
         else
#endif                                  /* MultiProgram */
            syserr("name: unknown event keyword variable");

      kywdwin: {
         StrLen(*dp0) = 7;
         StrLoc(*dp0) = "&window";
         }

      kywdstr: {
         StrLen(*dp0) = 9;
         StrLoc(*dp0) = "&progname";
         }

      kywdpos: {
         StrLen(*dp0) = 4;
         StrLoc(*dp0) = "&pos";
         }

      kywdsubj: {
         StrLen(*dp0) = 8;
         StrLoc(*dp0) = "&subject";
         }

      default:
         if (Offset(*dp1) == 0) {
            /*
             * Must(?) be a named variable.
             * (When used internally, could be reference to nameless
             * temporary stack variables as occurs for string scanning).
             */
            dp = VarLoc(*dp1);           /* get address of variable */
            if (InRange(globals,dp,eglobals)) {
               *dp0 = gnames[dp - globals];             /* global */
               return GlobalName;
               }
            else if (InRange(statics,dp,estatics)) {
               i = dp - statics - proc->fstatic;        /* static */
               if (i < 0 || i >= proc->nstatic)
                  syserr("name: unreferencable static variable");
               i += abs((int)proc->nparam) + abs((int)proc->ndynam);
               *dp0 = proc->lnames[i];
               return StaticName;
               }
            else if (InRange(arg1, dp, &arg1[abs((int)proc->nparam)])) {
               *dp0 = proc->lnames[dp - arg1];          /* argument */
               return ParamName;
               }
            else if (InRange(loc1, dp, &loc1[proc->ndynam])) {
               *dp0 = proc->lnames[dp - loc1 + abs((int)proc->nparam)];
               return LocalName;
               }
            else {
               StrLen(*dp0) = 6;
               StrLoc(*dp0) = "(temp)";
               return Failed;
/*               syserr("name: cannot determine variable name"); */
               }
            }
         else {
            if (is:string(*dp1) || (!is:variable(*dp1))) {  /* non-variable! */
               StrLen(*dp0) = 14;
               StrLoc(*dp0) = "(non-variable)";
               return Failed;
               }
            /*
             * Must be an element of a structure.
             */
            blkptr = (union block *)VarLoc(*dp1);
            varptr = (dptr)((word *)VarLoc(*dp1) + Offset(*dp1));
            switch ((int)BlkType(blkptr)) {
               case T_Lelem:            /* list */
                  i = varptr - &Blk(blkptr,Lelem)->lslots[blkptr->Lelem.first] + 1;
                  if (i < 1)
                     i += blkptr->Lelem.nslots;
                  while (BlkType(Blk(blkptr,Lelem)->listprev) == T_Lelem) {
                     blkptr = blkptr->Lelem.listprev;
                     i += blkptr->Lelem.nused;
                     }
                  sprintf(sbuf,"list_%ld[%ld]",
                          (long)Blk(Blk(blkptr,Lelem)->listprev,List)->id, (long)i);
                  i = strlen(sbuf);
                  Protect(StrLoc(*dp0) = alcstr(sbuf,i), return RunError);
                  StrLen(*dp0) = i;
                  break;
               case T_Record:           /* record */
                  i = varptr - Blk(blkptr,Record)->fields;
                  proc = &blkptr->Record.recdesc->Proc;

                  sprintf(sbuf,"record %s_%ld.%s", StrLoc(proc->recname),
                          (long)(Blk(blkptr,Record)->id),
                          StrLoc(proc->lnames[i]));

                  i = strlen(sbuf);
                  Protect(StrLoc(*dp0) = alcstr(sbuf,i), return RunError);
                  StrLen(*dp0) = i;
                  break;
               case T_Telem:            /* table */
                  t = keyref(blkptr,dp0);
                  if (t == RunError)
                      return RunError;
                  break;
               default:         /* none of the above */
#ifdef MultiProgram
                  StrLen(*dp0) = 8;
                  StrLoc(*dp0) = "(struct)";
                  return Failed;
#else
                  syserr("name: invalid structure reference");
#endif                                  /* MultiProgram */

               }
           }
      }
   return Succeeded;
   }

#if COMPILER
#begdef PTraceSetup()
   struct b_proc *proc;
#if ConcurrentCOMPILER
   CURTSTATE_AND_CE();
#endif                                 /* ConcurrentCOMPILER */
   --k_trace;
   showline(file_name, line_num);
   showlevel(k_level);
   proc = PFDebug(*pfp)->proc; /* get address of procedure block */
   putstr(stderr, &proc->pname);
#enddef

/*
 * ctrace - a procedure is being called; produce a trace message.
 */
void ctrace()
   {
   dptr arg;
   int n;

   PTraceSetup();

   putc('(', stderr);
   arg = glbl_argp;
   n = abs((int)proc->nparam);
   while (n--) {
      outimage(stderr, arg++, 0);
      if (n)
         putc(',', stderr);
      }
   putc(')', stderr);
   putc('\n', stderr);
   fflush(stderr);
   }

/*
 * rtrace - a procedure is returning; produce a trace message.
 */

void rtrace()
   {
   PTraceSetup();

   fprintf(stderr, " returned ");
   outimage(stderr, pfp->rslt, 0);
   putc('\n', stderr);
   fflush(stderr);
   }

/*
 * failtrace - procedure named s is failing; produce a trace message.
 */

void failtrace()
   {
   PTraceSetup();

   fprintf(stderr, " failed\n");
   fflush(stderr);
   }

/*
 * strace - a procedure is suspending; produce a trace message.
 */

void strace()
   {
   PTraceSetup();

   fprintf(stderr, " suspended ");
   outimage(stderr, pfp->rslt, 0);
   putc('\n', stderr);
   fflush(stderr);
   }

/*
 * atrace - a procedure is being resumed; produce a trace message.
 */
void atrace()
   {
   PTraceSetup();

   fprintf(stderr, " resumed\n");
   fflush(stderr);
   }
#endif                                  /* COMPILER */

/*
 * keyref(bp,dp) -- print name of subscripted table
 */
static int keyref(union block *bp, dptr dp)
   {
   char *s, *s2;
   char sbuf[256];                      /* buffer; might be too small */
   int len;

   if (getimage(&((bp->Telem.tref)),dp) == RunError)
      return RunError;

   /*
    * Allocate space, and copy the image surrounded by "table_n[" and "]"
    */
   s2 = StrLoc(*dp);
   len = StrLen(*dp);
   if (BlkType(bp) == T_Tvtbl)
      bp = Blk(bp,Tvtbl)->clink;
   else
      while(BlkType(bp) == T_Telem)
         bp = Blk(bp,Telem)->clink;
#ifdef Dbm
   if (BlkType(bp) == T_File) {
      sprintf(sbuf, "dbmfile(%s)[", StrLoc(Blk(bp,File)->fname));
      }
   else
#endif                                  /* Dbm */
      sprintf(sbuf, "table_%ld[", (long)(Blk(bp,Table)->id));
   { char * dest = sbuf + strlen(sbuf);
   strncpy(dest, s2, len);
   dest[len] = '\0';
   }
   strcat(sbuf, "]");
   len = strlen(sbuf);
   Protect(s = alcstr(sbuf, len), return RunError);
   StrLoc(*dp) = s;
   StrLen(*dp) = len;
   return Succeeded;
   }

#ifdef CoExpr
/*
 * cotrace -- a co-expression context switch; produce a trace message.
 */
void cotrace(struct b_coexpr *ccp, struct b_coexpr *ncp, int swtch_typ, dptr valloc)
   {
   struct b_proc *proc;

#if !COMPILER
   inst t_ipc;
#endif                                  /* !COMPILER */
   CURTSTATE_AND_CE();

   --k_trace;

#if COMPILER
   showline(ccp->file_name, ccp->line_num);
   proc = PFDebug(*ccp->es_pfp)->proc;     /* get address of procedure block */
#else                                   /* COMPILER */

   /*
    * Compute the ipc of the instruction causing the context switch.
    */
   t_ipc.op = ipc.op - 1;
   showline(findfile(t_ipc.opnd), findline(t_ipc.opnd));
   proc = BlkD(*glbl_argp, Proc);
#endif                                  /* COMPILER */

   showlevel(k_level);
   putstr(stderr, &proc->pname);

#ifdef Concurrent
   if (IS_TS_THREAD(ccp->status))
      fprintf(stderr,"; thread_%ld ", (long)ccp->id);
   else
#endif                                  /* Concurrent */
      fprintf(stderr,"; co-expression_%ld ", (long)ccp->id);

   switch (swtch_typ) {
      case A_Coact:
         fprintf(stderr,": ");
         outimage(stderr, valloc, 0);
         fprintf(stderr," @ ");
         break;
      case A_Coret:
         fprintf(stderr,"returned ");
         outimage(stderr, valloc, 0);
         fprintf(stderr," to ");
         break;
      case A_Cofail:
         fprintf(stderr,"failed to ");
         break;
      }

#ifdef Concurrent
   if (IS_TS_THREAD(ncp->status))
      fprintf(stderr,"thread_%ld", (long)ncp->id);
   else
#endif                                  /* Concurrent */
      fprintf(stderr,"co-expression_%ld\n", (long)ncp->id);

   fflush(stderr);
   }
#endif                                  /* CoExpr */

/*
 * showline - print file and line number information.
 */
static void showline(char *f, int l)
   {
   int i;

   i = (int)strlen(f);

#if MVS
   while (i > 22) {
#else                                   /* MVS */
   while (i > 13) {
#endif                                  /* MVS */
      f++;
      i--;
      }
   if (l > 0)

#if MVS
      fprintf(stderr, "%-22s: %4d  ",f, l);
   else
      fprintf(stderr, "                      :      ");
#else                                   /* MVS */
      fprintf(stderr, "%-13s: %4d  ",f, l);
   else
      fprintf(stderr, "             :       ");
#endif                                  /* MVS */

   }

/*
 * showlevel - print "| " n times.
 */
   static void showlevel(register int n)
   {
   while (n-- > 0) {
      putc('|', stderr);
      putc(' ', stderr);
      }
   }

#if !COMPILER

#include "../h/opdefs.h"


#ifndef MultiProgram
extern struct descrip value_tmp;                /* argument of Op_Apply */
#endif                                          /* MultiProgram */
extern struct b_proc *opblks[];


/*
 * ttrace - show offending expression.
 */
 static void ttrace(FILE *f)
   {
   struct b_proc *bp;
   word nargs;
   dptr reset;
   CURTSTATE_AND_CE();

   fprintf(f, "   ");

   reset = xargp;

   switch ((int)lastop) {

      case Op_Keywd:
         fprintf(f,"bad keyword reference");
         break;

      case Op_Invoke:
         nargs = xnargs;
         if (xargp[0].dword == D_Proc) {
            bp = BlkD(*xargp, Proc);
            if (bp)
            putstr(f, &(bp->pname));
            else fprintf(f,"???");
            }
         else
            outimage(f, xargp, 0);
         putc('(', f);
         while (nargs--) {
            outimage(f, ++xargp, 0);
            if (nargs)
               putc(',', f);
            }
         putc(')', f);
         break;

      case Op_Toby:
         putc('{', f);
         outimage(f, ++xargp, 0);
         fprintf(f, " to ");
         outimage(f, ++xargp, 0);
         fprintf(f, " by ");
         outimage(f, ++xargp, 0);
         putc('}', f);
         break;

      case Op_Subsc:
         putc('{', f);
         outimage(f, ++xargp, 0);

#if EBCDIC != 1
         putc('[', f);
#else                                   /* EBCDIC != 1 */
         putc('$', f);
         putc('<', f);
#endif                                  /* EBCDIC != 1 */

         outimage(f, ++xargp, 0);

#if EBCDIC != 1
         putc(']', f);
#else                                   /* EBCDIC != 1 */
         putc('$', f);
         putc('>', f);
#endif                                  /* EBCDIC != 1 */

         putc('}', f);
         break;

      case Op_Sect:
         putc('{', f);
         outimage(f, ++xargp, 0);

#if EBCDIC != 1
         putc('[', f);
#else                                   /* EBCDIC != 1 */
         putc('$', f);
         putc('<', f);
#endif                                  /* EBCDIC != 1 */

         outimage(f, ++xargp, 0);
         putc(':', f);
         outimage(f, ++xargp, 0);

#if EBCDIC != 1
         putc(']', f);
#else                                   /* EBCDIC != 1 */
         putc('$', f);
         putc('>', f);
#endif                                  /* EBCDIC != 1 */

         putc('}', f);
         break;

      case Op_Bscan:
         putc('{', f);
         outimage(f, xargp, 0);
         fputs(" ? ..}", f);
         break;

      case Op_Coact:
         putc('{', f);
         outimage(f, ++xargp, 0);
         fprintf(f, " @ ");
         outimage(f, ++xargp, 0);
         putc('}', f);
         break;

      case Op_Apply:
         outimage(f, xargp++, 0);
         fprintf(f," ! ");
         outimage(f, &value_tmp, 0);
         break;

      case Op_Create:
         fprintf(f,"{create ..}");
         break;

      case Op_Field:
         putc('{', f);
         outimage(f, ++xargp, 0);
         fprintf(f, " . ");
         ++xargp;
         if (IntVal(*xargp) < 0 && fnames-efnames < IntVal(*xargp))
            fprintf(f, "%s", StrLoc(efnames[IntVal(*xargp)]));
         else if (0 <= IntVal(*xargp) && IntVal(*xargp) < efnames - fnames)
            fprintf(f, "%s", StrLoc(fnames[IntVal(*xargp)]));
         else
            fprintf(f, "field");

         putc('}', f);
         break;

      case Op_Limit:
         fprintf(f, "limit counter: ");
         outimage(f, xargp, 0);
         break;

      case Op_Llist:

#if EBCDIC != 1
         fprintf(f,"[ ... ]");
#else                                   /* EBCDIC != 1 */
         fputs("$< ... $>", f);
#endif                                  /* EBCDIC != 1 */
         break;


      default:

         bp = opblks[lastop];
         if (!bp) break;
         nargs = abs((int)bp->nparam);
         putc('{', f);
         if (lastop == Op_Bang || lastop == Op_Random)
            goto oneop;
         if (abs((int)bp->nparam) >= 2) {
            outimage(f, ++xargp, 0);
            putc(' ', f);
            putstr(f, &(bp->pname));
            putc(' ', f);
            }
         else
oneop:
         putstr(f, &(bp->pname));
         outimage(f, ++xargp, 0);
         putc('}', f);
      }

   if (ipc.opnd != NULL)
      fprintf(f, " from line %d in %s", findline(ipc.opnd),
         findfile(ipc.opnd));
   putc('\n', f);
   xargp = reset;
   fflush(f);
   }


/*
 * ctrace - procedure named s is being called with nargs arguments, the first
 *  of which is at arg; produce a trace message.
 */
 void ctrace(dptr dp, int nargs, dptr arg)
   {
   CURTSTATE_AND_CE();

   showline(findfile(ipc.opnd), findline(ipc.opnd));
   showlevel(k_level);
   putstr(stderr, dp);
   putc('(', stderr);
   while (nargs--) {
      outimage(stderr, arg++, 0);
      if (nargs)
         putc(',', stderr);
      }
   putc(')', stderr);
   putc('\n', stderr);
   fflush(stderr);
   }

/*
 * rtrace - procedure named s is returning *rval; produce a trace message.
 */

 void rtrace(dptr dp, dptr rval)
   {
   inst t_ipc;
   CURTSTATE_AND_CE();

   /*
    * Compute the ipc of the return instruction.
    */
   t_ipc.op = ipc.op - 1;
   showline(findfile(t_ipc.opnd), findline(t_ipc.opnd));
   showlevel(k_level);
   putstr(stderr, dp);
   fprintf(stderr, " returned ");
   outimage(stderr, rval, 0);
   putc('\n', stderr);
   fflush(stderr);
   }

/*
 * failtrace - procedure named s is failing; produce a trace message.
 */

 void failtrace(dptr dp)
   {
   inst t_ipc;
   CURTSTATE_AND_CE();

   /*
    * Compute the ipc of the fail instruction.
    */
   t_ipc.op = ipc.op - 1;
   showline(findfile(t_ipc.opnd), findline(t_ipc.opnd));
   showlevel(k_level);
   putstr(stderr, dp);
   fprintf(stderr, " failed");
   putc('\n', stderr);
   fflush(stderr);
   }

/*
 * strace - procedure named s is suspending *rval; produce a trace message.
 */

 void strace(dptr dp, dptr rval)
   {
   inst t_ipc;
   CURTSTATE_AND_CE();

   /*
    * Compute the ipc of the suspend instruction.
    */
   t_ipc.op = ipc.op - 1;
   showline(findfile(t_ipc.opnd), findline(t_ipc.opnd));
   showlevel(k_level);
   putstr(stderr, dp);
   fprintf(stderr, " suspended ");
   outimage(stderr, rval, 0);
   putc('\n', stderr);
   fflush(stderr);
   }

/*
 * atrace - procedure named s is being resumed; produce a trace message.
 */

 void atrace(dptr dp)
   {
   inst t_ipc;
   CURTSTATE_AND_CE();

   /*
    * Compute the ipc of the instruction causing resumption.
    */
   t_ipc.op = ipc.op - 1;
   showline(findfile(t_ipc.opnd), findline(t_ipc.opnd));
   showlevel(k_level);
   putstr(stderr, dp);
   fprintf(stderr, " resumed");
   putc('\n', stderr);
   fflush(stderr);
   }

#ifdef CoExpr
/*
 * coacttrace -- co-expression is being activated; produce a trace message.
 */
 void coacttrace(struct b_coexpr *ccp, struct b_coexpr *ncp)
   {
   struct b_proc *bp;
   inst t_ipc;
   CURTSTATE_AND_CE();

   bp = BlkD(*glbl_argp, Proc);
   /*
    * Compute the ipc of the activation instruction.
    */
   t_ipc.op = ipc.op - 1;
   showline(findfile(t_ipc.opnd), findline(t_ipc.opnd));
   showlevel(k_level);
   putstr(stderr, &(bp->pname));

#ifdef Concurrent
   if (IS_TS_THREAD(ccp->status))
      fprintf(stderr,"; thread_%ld : ", (long)ccp->id);
   else
#endif
      fprintf(stderr,"; co-expression_%ld : ", (long)ccp->id);

   outimage(stderr, (dptr)(sp - 3), 0);

#ifdef Concurrent
   if (IS_TS_THREAD(ncp->status))
      fprintf(stderr," @ thread_%ld\n", (long)ncp->id);
   else
#endif
      fprintf(stderr," @ co-expression_%ld\n", (long)ncp->id);

   fflush(stderr);
   }

/*
 * corettrace -- return from co-expression; produce a trace message.
 */
 void corettrace(struct b_coexpr *ccp, struct b_coexpr *ncp)
   {
   struct b_proc *bp;
   inst t_ipc;
   CURTSTATE_AND_CE();

   bp = BlkD(*glbl_argp, Proc);
   /*
    * Compute the ipc of the coret instruction.
    */
   t_ipc.op = ipc.op - 1;
   showline(findfile(t_ipc.opnd), findline(t_ipc.opnd));
   showlevel(k_level);
   putstr(stderr, &(bp->pname));

#ifdef Concurrent
   if (IS_TS_THREAD(ccp->status))
      fprintf(stderr,"; thread_%ld returned ", (long)ccp->id);
   else
#endif
      fprintf(stderr,"; co-expression_%ld returned ", (long)ccp->id);

   outimage(stderr, (dptr)(&ncp->es_sp[-3]), 0);

#ifdef Concurrent
   if (IS_TS_THREAD(ncp->status))
      fprintf(stderr," to thread_%ld\n", (long)ncp->id);
   else
#endif
      fprintf(stderr," to co-expression_%ld\n", (long)ncp->id);

   fflush(stderr);
   }

/*
 * cofailtrace -- failure return from co-expression; produce a trace message.
 */
 void cofailtrace(struct b_coexpr *ccp, struct b_coexpr *ncp)
   {
   struct b_proc *bp;
   inst t_ipc;
   CURTSTATE_AND_CE();

   bp = BlkD(*glbl_argp, Proc);
   /*
    * Compute the ipc of the cofail instruction.
    */
   t_ipc.op = ipc.op - 1;
   showline(findfile(t_ipc.opnd), findline(t_ipc.opnd));
   showlevel(k_level);
   putstr(stderr, &(bp->pname));

#ifdef Concurrent
   if (IS_TS_THREAD(ccp->status) && IS_TS_THREAD(ncp->status))
      fprintf(stderr,"; thread_%ld failed to thread_%ld\n",
                        (long)ccp->id, (long)ncp->id);
   else
   if (IS_TS_THREAD(ccp->status) && !IS_TS_THREAD(ncp->status))
      fprintf(stderr,"; thread_%ld failed to co-expression_%ld\n",
                        (long)ccp->id, (long)ncp->id);
   else
   if (!IS_TS_THREAD(ccp->status) && IS_TS_THREAD(ncp->status))
      fprintf(stderr,"; coexpression_%ld failed to thread_%ld\n",
                        (long)ccp->id, (long)ncp->id);
   else
#endif
      fprintf(stderr,"; co-expression_%ld failed to co-expression_%ld\n",
                        (long)ccp->id, (long)ncp->id);
   fflush(stderr);
   }
#endif                                  /* CoExpr */
#endif                                  /* !COMPILER */

/*
 * Service routine to display variables in given number of
 *  procedure calls to file f.
 */

#if COMPILER
 int xdisp(struct p_frame *fp, register dptr dp, int count, FILE *f)
#else                                   /* COMPILER */
   int xdisp(struct pf_marker *fp, register dptr dp, int count, FILE *f)
#endif                                  /* COMPILER */
   {
   register dptr np;
   register int n;
   struct b_proc *bp;
   word nglobals, *indices;

   while (count--) {            /* go back through 'count' frames */
      if (fp == NULL)
         break;       /* needed because &level is wrong in co-expressions */

#if COMPILER
      bp = PFDebug(*fp)->proc;  /* get address of procedure block */
#else                                   /* COMPILER */
      bp = BlkD(*dp, Proc); /* get addr of procedure block */
      dp++;
      /*
       * #%#% was: no post-increment here, but *pre*increment dp below
       */
#endif                                  /* COMPILER */

      /*
       * Print procedure name.
       */
      putstr(f, &(bp->pname));
      fprintf(f, " local identifiers:\n");

      /*
       * Print arguments.
       */
      np = bp->lnames;
      for (n = abs((int)bp->nparam); n > 0; n--) {
         fprintf(f, "   ");
         putstr(f, np);
         fprintf(f, " = ");
         outimage(f, dp++, 0);
         putc('\n', f);
         np++;
         }

      /*
       * Print locals.
       */
#if COMPILER
      dp = fp->t.d;
#else                                   /* COMPILER */
      dp = &fp->pf_locals[0];
#endif                                  /* COMPILER */
      for (n = bp->ndynam; n > 0; n--) {
         fprintf(f, "   ");
         putstr(f, np);
         fprintf(f, " = ");
         outimage(f, dp++, 0);
         putc('\n', f);
         np++;
         }

      /*
       * Print statics.
       */
      dp = &statics[bp->fstatic];
      for (n = bp->nstatic; n > 0; n--) {
         fprintf(f, "   ");
         putstr(f, np);
         fprintf(f, " = ");
         outimage(f, dp++, 0);
         putc('\n', f);
         np++;
         }

#if COMPILER
      dp = fp->old_argp;
      fp = fp->old_pfp;
#else                                   /* COMPILER */
      dp = fp->pf_argp;
      fp = fp->pf_pfp;
#endif                                  /* COMPILER */
      }

   /*
    * Print globals.  Sort names in lexical order using temporary index array.
    */

#if COMPILER
   nglobals = n_globals;
#else                                   /* COMPILER */
   nglobals = eglobals - globals;
#endif                                  /* COMPILER */

   indices = (word *)malloc((msize)nglobals * sizeof(word));
   if (indices == NULL)
      return Failed;
   else {
      for (n = 0; n < nglobals; n++)
         indices[n] = n;
      qsort ((char*)indices, (int)nglobals, sizeof(word),(QSortFncCast)glbcmp);
      fprintf(f, "\nglobal identifiers:\n");
      for (n = 0; n < nglobals; n++) {
         fprintf(f, "   ");
         putstr(f, &gnames[indices[n]]);
         fprintf(f, " = ");
         outimage(f, &globals[indices[n]], 0);
         putc('\n', f);
         }
      fflush(f);
      free((pointer)indices);
      }
   return Succeeded;
   }

/*
 * glbcmp - compare the names of two globals using their temporary indices.
 */
static int glbcmp (char *pi, char *pj)
   {
   register word i = *(word *)pi;
   register word j = *(word *)pj;
   return lexcmp(&gnames[i], &gnames[j]);
   }


#ifdef DebugHeap
void heaperr(char *msg, union block *p, int t)
{
   char buf[512];
   sprintf(buf, "%s : %p : %ld / %d\n",msg,p,ValidPtr(p)?p->File.title:-1,t);
   syserr(buf);
}
#endif                                  /* DebugHeap */


#ifdef DEVELOPMODE
/*----------------------------------------------------------------------
 * This is a home for code that is only intended to be present when
 * the --enable-devmode option has been supplied to configure.
 *
 * If any function is thought to be useful enough to be present in the
 * standard (non-developer) configuration, we'll probably change its
 * name and move it somewhere else.
 *----------------------------------------------------------------------
 */

/* This function may be called from the debugger to display the current
 * file and line number in the Unicon program
 */
void dbgUFL()
{
#if COMPILER
  fprintf(stdout, "File %s; Line %d\n", file_name, line_num);
#else                     /* COMPILER */
  CURTSTATE();
  fprintf(stdout, "File: %s Line: %d\n",
          findfile(curtstate->c->es_ipc.opnd),
          findline(curtstate->c->es_ipc.opnd));
#endif                     /* COMPILER */
}

/* Call this from the debugger to print a (Unicon) stack trace back */
void dbgUTrace()
{
  CURTSTATE_AND_CE();
  tracebk(pfp, glbl_argp, NULL);
}

/* This function may be used in test code where the criterion for a
 * break point is complex (it may be easier easier to write C code and
 * call dbgbrkpoint() with a break on the function than construct a
 * complicated debugger expression).
 */
int dbgbrkpoint()
{
  return 0;
}

"dbgbrk() - allow a convenient debugger break point called from Unicon code"
function{1} dbgbrk()
abstract {  return null }
body {
  return nulldesc;  /* Set a break point on this line or use "-n Zdbgbrk" */
}
end

#endif                  /* DEVELOPMODE */
