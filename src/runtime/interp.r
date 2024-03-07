#if !COMPILER
/*
 * File: interp.r
 *  The interpreter proper.
 */

#include "../h/opdefs.h"

extern fptr fncentry[];
extern word istart[4]; extern int mterm;

#if MSDOS
   static union {
      pointer stkadr;
      word stkint;
   } stkword;
#endif				/* MSDOS */
   
#ifdef OVLD
extern int *OpTab;
#endif

/*
 * Prototypes for static functions.
 */
static struct ef_marker *vanq_bound (struct ef_marker *efp_v,
                                      struct gf_marker *gfp_v);
static void vanq_proc (struct ef_marker *efp_v, struct gf_marker *gfp_v);

/*
 * The following code is operating-system dependent [@interp.01]. Declarations.
 */

#if PORT
Deliberate Syntax Error
#endif					/* PORT */

#if MACINTOSH || MSDOS || MVS || UNIX || VM || VMS
   /* nothing needed */
#endif					/* MACINTOSH || ... */

/*
 * End of operating-system specific code.
 */

#ifndef MultiProgram
word lastop;			/* Last operator evaluated */
#endif					/* MultiProgram */

/*
 * Istate variables.
 */

#ifndef Concurrent
struct pf_marker *pfp = NULL;		/* Procedure frame pointer */
struct ef_marker *efp;		/* Expression frame pointer */
struct gf_marker *gfp;		/* Generator frame pointer */
inst ipc;			/* Interpreter program counter */
inst oldipc;                    /* the previous ipc, fix returned line zero */
word *sp = NULL;		/* Stack pointer */
int ilevel;	
#ifndef StackCheck
word *stack;				/* Interpreter stack */
word *stackend; 			/* End of interpreter stack */
#endif					/* StackCheck */
#else					/* Concurrent */
int lock_count_mtx_init;
#endif					/* Concurrent */

#if HAVE_PROFIL && E_Tick
extern union { 			/* clock ticker -- keep in sync w/ fmonitor.r */
   unsigned short s[16];	/* 16 counters */
   unsigned long l[8];		/* 8 longs are easier to check */
} ticker;
extern unsigned long oldtick;	/* previous sum of the two longs */
#endif					/* HAVE_PROFIL && E_Tick */


#ifndef MultiProgram
struct descrip value_tmp;	/* list argument to Op_Apply */
#endif					/* MultiProgram */

#ifndef Concurrent
struct descrip eret_tmp;	/* eret value during unwinding */
#endif					/* Concurrent */

#ifndef MultiProgram
dptr xargp;
word xnargs;
dptr field_argp;			/* see comment in imisc.r/Ofield() */
#endif					/* MultiProgram */

/*
 * Macros for use inside the main loop of the interpreter.
 */

#define E_Misc    -1
#define E_Operator 0
#define E_Function 1

/*
 * Setup_Op sets things up for a call to the C function for an operator.
 */
#begdef Setup_Op(nargs,e)
#ifdef MultiProgram
   lastev = E_Operator;
   value_tmp.dword = D_Proc;
   value_tmp.vword.bptr = (union block *)&op_tbl[lastop - 1];
   lastdesc = value_tmp;
   InterpEVValD(&value_tmp, e);
   /*
   EVValDEx(&value_tmp, e, word mylastop, mylastop=lastop, lastop=mylastop);
   */
   value_tmp = nulldesc;
#endif					/* MultiProgram */
   rargp = (dptr)(rsp - 1) - nargs;
   xargp = rargp;
   ExInterp_sp;
#enddef					/* Setup_Op */

/*
 * Setup_Arg sets things up for a call to the C function.
 *  It is the same as Setup_Op, except the latter is used only
 *  operators.
 */
#begdef Setup_Arg(nargs)
#ifdef MultiProgram
   lastev = E_Misc;
#endif					/* MultiProgram */
   rargp = (dptr)(rsp - 1) - nargs;
   xargp = rargp;
   ExInterp_sp;
#enddef					/* Setup_Arg */

#begdef Call_Cond(e)
   if ((*(optab[lastop]))(rargp) == A_Resume) {
     InterpEVValD(&lastdesc, e);
     goto efail_noev;
   }
   rsp = (word *) rargp + 1;
#ifdef MultiProgram
   goto return_term;
#else					/* MultiProgram */
   break;
#endif					/* MultiProgram */
#enddef					/* Call_Cond */

#begdef HandleOVLD(numargs)
#ifdef OVLD
	    fieldnum = OpTab[lastop];
#ifdef OVLD_DEBUG
	    fprintf(stdout,"LastOp = %d\tFieldNum=%d\n",lastop, fieldnum);
#endif
	    if ( fieldnum != -1) {
	     deref(&rargp[1],&x);
#ifdef OVLD_DEBUG
	     fprintf(stdout, "Try overload\n");
#endif
	     if (is:record(x)) {
		  register word fnum;
		  tended struct b_record *rp;
		  register dptr dp;
		  register union block *bptr;
		  int nfields, i;
		  struct b_record *rp2;
		  tended struct descrip md;
		  int found = 0;
		  char *funcname = NULL;
		  rp =  (struct b_record *) BlkLoc(x);
		  bptr = rp->recdesc;
		  nfields = bptr->Proc.nfields;
#ifdef OVLD_DEBUG
		  fprintf(stdout, "x is a record\n");
#endif
/*
Check if our record is a class ( has a method vector)
*/
		   for( i = 0; i < nfields;i++) {
		       if (!strcmp(StrLoc(bptr->Proc.lnames[i]), "__m")) {
			   found = 1;
			   break;
			 }
		     }/* for ... nfields */
		   if (found) {
		       md = rp->fields[i];
		       if (is:record(md)) {
			 rp2 = (struct b_record *)BlkLoc(md);
#ifdef OVLD_DEBUG
			 fprintf(stdout, " x has method vector\n");
#endif
/*
Now that we have a method vector we check if it contains the specified field
*/

#ifdef FieldTableCompression
#define FO(i) ((foffwidth==1)?(focp[i]&255L):((foffwidth==2)?(fosp[i]&65535L):fo[i]))
#define FTAB(i) ((ftabwidth==1)?(ftabcp[i]&255L):((ftabwidth==2)?(ftabsp[i]&65535L):ftabp[i]))

	 if (rp2->recdesc->Proc.recnum == -1)
	    syserr("dynamic classes not supported yet\n");

	 fnum = FTAB(FO(fieldnum) + (rp2->recdesc->Proc.recnum - 1));

	 /*
	  * Check the bitmap for this entry.  If it fails, it converts our
	  * nice field offset number into -1 (empty/invalid for our row).
	  */
	 {
	   int bytes, index;
	   unsigned char this_bit = 0200;

	   bytes = *records >> 3;
	   if ((*records & 07) != 0)
	     bytes++;
	   index = IntVal(Arg2) * bytes + (rp2->recdesc->Proc.recnum - 1) / 8;
	   this_bit = this_bit >> (rp2->recdesc->Proc.recnum - 1) % 8;
	   if ((bm[index] | this_bit) != bm[index]) {
	     fnum = -1;
	   }
	   else { /* bitmap passes test on __m.field */
	   }
	 }
#else					/* FieldTableCompression */
#ifdef OVLD_DEBUG
printf("interp, fieldnum is still %d, recnum %d\n",
	fieldnum, rp2->recdesc->Proc.recnum); fflush(stdout);
#endif
	 fnum = ftabp[fieldnum * *records + rp2->recdesc->Proc.recnum - 1];
#ifdef OVLD_DEBUG
      fprintf(stdout,"Resolving method fnum = %d\n" , fnum);
#endif
#endif					/* FieldTableCompression */
	 if ( fnum >= 0)
		     {
#ifdef OVLD_DEBUG	
		       fprintf(stdout, "x has the overloaded method\n");
#endif
		       rargp[0] = (rp2->fields[fnum]);
		       args = numargs;
		       goto invokej;
		       
		     }
	       }/*if is:record(md)*/
	     }/*if found == 1*/
	  }/*if is record x*/
      }/*if fieldnum != -1*/
#ifdef OVLD_DEBUG
      fprintf(stdout, "%s\n", "No overloading occured");
#endif
#else
#endif
#enddef


/*
 * Call_Gen - Call a generator. A C routine associated with the
 *  current opcode is called. When it terminates, control is
 *  passed to C_rtn_term to deal with the termination condition appropriately.
 */
#begdef Call_Gen
   signal = (*(optab[lastop]))(rargp);
   goto C_rtn_term;
#enddef					/* Call_Gen */

/*
 * GetWord fetches the next icode word.  PutWord(x) stores x at the current
 * icode word.
 */
#define GetWord (*ipc.opnd++)
#define PutWord(x) ipc.opnd[-1] = (x)
#define GetOp (word)(*ipc.op++)
#define PutOp(x) ipc.op[-1] = (x)

/*
 * "Semi-atomic" (thread-safe?) self-modifying instruction rewrite.
 * This is written for a VM bytecode with one opcode and two words
 * (a descriptor), such as Op_Str, in which the second word and the
 * opcode are to be rewritten.
 * Self-modifying bytecodes with another signature (not an int opcode
 * followed by two words), if any, will require a different macro.
 * Called after the ipc has been advanced past the entire instruction,
 * within a mutex on the offset-based bytecode. To avoid a race
 * condition on the pointer-based bytecode, the macro may not write
 * the new opcode until after the offset has been converted to a pointer.
 */
#if WordBits == IntBits
#begdef PutInstr(x,y,op_offset)
   do { ipc.opnd[-1] = (y); ipc.op[-1-op_offset] = (x); } while(0)
#enddef
#begdef PutInstrAt(x,y,p)
   do { *((word *)(p)) = (word)(y); *((int *)(p-1)) = (x); } while(0)
#enddef
#else if WordBits == IntBits*2
#begdef PutInstr(x,y,op_offset)
   do { ipc.opnd[-1] = (y); ipc.op[-1-2*op_offset] = (x); } while(0)
#enddef
#begdef PutInstrAt(x,y,p)
   do { *((word *)(p+1)) = (word)(y); *((int *)(p)) = (x); } while(0)
#enddef
#else
deliberate syntax error
#endif

/*
 * DerefArg(n) dereferences the nth argument.
 */
#define DerefArg(n)   Deref(rargp[n])

/*
 * For the sake of efficiency, the stack pointer is kept in a register
 *  variable, rsp, in the interpreter loop.  Since this variable is
 *  only accessible inside the loop, and the global variable sp is used
 *  for the stack pointer elsewhere, rsp must be stored into sp when
 *  the context of the loop is left and conversely, rsp must be loaded
 *  from sp when the loop is reentered.  The macros ExInterp_sp and
 *  EntInterp_sp, respectively, handle these operations.  Currently,
 *  this register/global scheme is only used for the stack pointer.
 *  Study (performance testing) is needed to justify rsp's use, and determine
 *  whether it should be extended to other interpreter loop variables.
 *  Potential future candidates include ipc and lastop, for example.
 *  Even if they are part of it, its not clear that there should be
 *  separate macros for them, or if one ExInterp/EntInterp pair should
 *  handle all register variables that need to be saved/restored.
 */

#define ExInterp_sp	sp = rsp;
#define EntInterp_sp	rsp = sp;

/*#define ExInterp_ipc	ipc = ripc;
#define EntInterp_ipc	ripc = ipc;

#define ExInterp_lastop	rlastop = lastop;
#define EntInterp_lastop	lastop = rlastop;
*/
/*
 * Inside the interpreter loop, PushDesc, PushNull, PushAVal, and
 *  PushVal use rsp instead of sp for efficiency.
 */

#undef PushDesc
#undef PushNull
#undef PushVal
#undef PushAVal
#define PushDesc(d)   {*++rsp=((d).dword); *++rsp=((d).vword.integr);}
#define PushNull   {*++rsp = D_Null; *++rsp = 0;}
#define PushVal(v)   {*++rsp = (word)(v);}

/*
 * The following code is operating-system dependent [@interp.02].  Define
 *  PushAVal for computers that store longs and pointers differently.
 */

#if PORT
#define PushAVal(x) PushVal(x)
Deliberate Syntax Error
#endif					/* PORT */

#if MACINTOSH || MVS || UNIX || VM || VMS
#define PushAVal(x) PushVal(x)
#endif					/* MACINTOSH || ... */

#if MSDOS
#define PushAVal(x) {rsp++; \
		       stkword.stkadr = (char *)(x); \
		       *rsp = stkword.stkint; \
		       }
#endif					/* MSDOS */

/*
 * End of operating-system specific code.
 */

#begdef interp_macro(interp_x,e_intcall,e_stack,e_fsusp,e_osusp,e_bsusp, e_ocall,e_ofail,e_tick,e_line,e_loc,e_opcode,e_fcall,e_prem,e_erem,e_intret, e_psusp,e_ssusp,e_pret,e_efail,e_sresum,e_fresum,e_oresum,e_eresum,e_presum, e_pfail,e_ffail,e_frem,e_orem,e_fret,e_oret,e_literal,e_operand,e_syntax, e_cstack)

/*
 * The main loop of the interpreter.
 */
#ifdef TSTATARG
int interp_x(int fsig,dptr cargp, struct threadstate *curtstate)
#else 		 	   	  	 /* TSTATARG */
int interp_x(int fsig,dptr cargp)
#endif		 	   	  	 /* TSTATARG */
   {
   register word opnd;
   register word *rsp;
   register dptr rargp;
   register struct ef_marker *newefp;
   register struct gf_marker *newgfp;
   register word *wd;
   register word *firstwd, *lastwd;
   word *oldsp;
   int type, signal, args;
   extern int (*optab[])();
   extern int (*keytab[])();
   struct b_proc *bproc;
#ifdef MultiProgram
   int lastev = E_Misc;
   struct descrip lastdesc = nulldesc;
#endif					/* MultiProgram */

#ifdef TallyOpt
   extern word tallybin[];
#endif					/* TallyOpt */

#ifdef Concurrent
/*
 * TSTATARG doesn't take a CURTSTATE because it is a passed parameter.
 * OVLD doesn't take a CURTSTATE because it declares a tended variable.
 * Review OVLD code and do away with the tended if possible.
 */
#if !(defined(TSTATARG) || defined(OVLD))
    CURTSTATE_AND_CE();
#endif		 	   	  	 /* TSTATARG */
#endif					/* Concurrent */

#if e_intcall
   EVVal(fsig, e_intcall);
#endif					/* e_intcall */
#if e_cstack
#ifdef StackCheck
   EVVal(DiffPtrs(sp, BlkD(k_current,Coexpr)->es_stack), e_cstack);
#else					/* StackCheck */
   EVVal(DiffPtrs(sp, stack), e_cstack);
#endif					/* StackCheck */
#endif					/* e_cstack */

#ifdef StackCheck
   /*
    * Make a stab at catching interpreter stack overflow.  This does
    * not detect C stack overflow.
    */
   if (((char *)sp + PerilDelta) > (char *)(BlkD(k_current,Coexpr)->es_stackend)){
         fatalerr(301, NULL);
	 }
#else					/* StackCheck */
#ifndef MultiProgram
   /*
    * Make a stab at catching interpreter stack overflow.  This does
    * nothing for invocation in a co-expression other than &main.
    */
   if (BlkLoc(k_current) == BlkLoc(k_main) &&
      ((char *)sp + PerilDelta) > (char *)stackend) 
         fatalerr(301, NULL);
#endif					/* MultiProgram */
#endif					/* StackCheck */

#ifdef Polling
   if (!pollctr--) {
      pollctr = pollevent();
      if (pollctr == -1) fatalerr(141, NULL);
      }
#endif					/* Polling */

   ilevel++;

   EntInterp_sp;

   switch (fsig) {
   case G_Csusp: case G_Fsusp: case G_Osusp:
#if 0
      value_tmp = *(dptr)(rsp - 1);	/* argument? */
#else
      value_tmp = cargp[0];
#endif
#ifdef MultiProgram
      Deref0(value_tmp);
#else					/* MultiProgram */
      Deref(value_tmp);
#endif					/* MultiProgram */
      if (fsig == G_Fsusp) {
	 InterpEVValD(&value_tmp, e_fsusp);
	 }
      else if (fsig == G_Osusp) {
	 InterpEVValD(&value_tmp, e_osusp);
	 }
      else {
	 InterpEVValD(&value_tmp, e_bsusp);
	 }

      oldsp = rsp;
      value_tmp = nulldesc;

      /*
       * Create the generator frame.
       */
      newgfp = (struct gf_marker *)(rsp + 1);
      newgfp->gf_gentype = fsig;
      newgfp->gf_gfp = gfp;
      newgfp->gf_efp = efp;
      newgfp->gf_ipc = ipc;
      rsp += Wsizeof(struct gf_smallmarker);

      /*
       * Region extends from first word after the marker for the generator
       *  or expression frame enclosing the call to the now-suspending
       *  routine to the first argument of the routine.
       */
      if (gfp != 0) {
	 if (gfp->gf_gentype == G_Psusp)
	    firstwd = (word *)gfp + Wsizeof(*gfp);
	 else
	    firstwd = (word *)gfp + Wsizeof(struct gf_smallmarker);
	 }
      else
	 firstwd = (word *)efp + Wsizeof(*efp);
      lastwd = (word *)cargp + 1;

      /*
       * Copy the portion of the stack with endpoints firstwd and lastwd
       *  (inclusive) to the top of the stack.
       */
      for (wd = firstwd; wd <= lastwd; wd++)
	 *++rsp = *wd;
      gfp = newgfp;
      }
/*
 * Top of the interpreter loop.
 */

   for (;;) {

#ifdef SoftThreads
  if (curtstate->sthrd_size>0){
     if (curtstate->c->sthrd_tick-- <= 10){
        struct b_coexpr *ncp;
	ncp = curtstate->sthrds[curtstate->sthrd_cur];
        ncp->sthrd_tick = SOFT_THREADS_TSLICE; /* give the new thread a "slice" */
	curtstate->sthrds[curtstate->sthrd_cur] = curtstate->c;
	curtstate->sthrd_cur = (curtstate->sthrd_cur + 1) % curtstate->sthrd_size;
      	ExInterp_sp;
	if (ncp->es_actstk == NULL){ /* this shouldn't be the case */
      	     Protect(ncp->es_actstk = alcactiv(), err_msg(0,NULL));
   	     if (pushact(ncp, curtstate->owner) == RunError)
      	        err_msg(183, NULL);
	     co_chng(ncp, NULL, NULL, A_Coschedule, 0);
	}
	else
           co_chng(ncp, NULL, NULL, A_Coschedule, 1);
	   
	SYNC_CURTSTATE_CE();
      	EntInterp_sp;
	}
     }
#endif 					/* SoftThreads */ 

#ifdef MultiProgram
      /* 
       *  If the TP (the child program) received a signal that it does
       *  not have a handler for, it reports it back to its parent.
       *  The reported event is E_Signal with a string name of that signal
       */
      if (curpstate->signal > 0) {
         struct descrip val;
         StrLoc(val) = si_i2s(signalnames, curpstate->signal);
         StrLen(val) = strlen(StrLoc(val));
         InterpEVValD(&val,E_Signal);
         curpstate->signal = 0;
         }
#endif					/* MultiProgram */

#if HAVE_PROFIL && e_tick
      if (ticker.l[0] + ticker.l[1] + ticker.l[2] + ticker.l[3] +
	  ticker.l[4] + ticker.l[5] + ticker.l[6] + ticker.l[7] != oldtick) {
	 /*
	  * Record a Tick event reflecting a clock advance.
	  *
	  *  The interpreter main loop has detected a change in the
	  *  profile counters. This means that the system clock has
	  *  ticked.  Record an event and update the records.
	  */
	 word sum, nticks;
	 ExInterp_sp;
	 oldtick = ticker.l[0] + ticker.l[1];
	 sum = ticker.s[0] + ticker.s[1] + ticker.s[2] + ticker.s[3];
	 nticks = sum - oldsum;
	 EVVal(nticks, e_tick);
	 oldsum = sum;
	 EntInterp_sp;
	 }
#endif					/* HAVE_PROFIL && e_tick */

#if e_line || e_loc
   /*
    * Location change events are generated by checking to see if the opcode
    *  has changed indices in the "line number" (now line + column) table;
    *  "straight line" forward code does not require a binary search to find
    *  the new location; instead, a pointer is simply incremented.
    *  Further optimization here is planned.
    */
   if (!is:null(curpstate->eventmask) && (
#if e_loc
       Testb((word)ToAscii(E_Loc), curpstate->eventmask)
#if e_line
	 ||
#endif					/* e_line */
#endif					/* e_loc */
#if e_line
       Testb((word)ToAscii(E_Line), curpstate->eventmask)
#endif					/* e_line */
       )) {

      if (InRange(code, ipc.opnd, endcode)) {
	uword ipc_offset = DiffPtrs((char *)ipc.opnd, (char *)code);
	uword size;
	word temp_no;
	if (!current_line_ptr ||
	    current_line_ptr->ipc_saved > ipc_offset ||
	    current_line_ptr[1].ipc_saved <= ipc_offset) {
#if defined(LineCodes) && defined(Polling)
            if (!pollctr--) {
	       ExInterp_sp;
               pollctr = pollevent();
	       EntInterp_sp;
	       if (pollctr == -1) fatalerr(141, NULL);
	       }	       
#endif					/* LineCodes && Polling */

	    if(current_line_ptr &&
	       current_line_ptr + 2 < elines &&
	       current_line_ptr[1].ipc_saved < ipc_offset &&
	       ipc_offset < current_line_ptr[2].ipc_saved) {
	       current_line_ptr ++;
	       } 
	    else {
	       current_line_ptr = ilines;
	       size = DiffPtrs((char *)elines, (char *)ilines) /
		  sizeof(struct ipc_line *);
	       while (size > 1) {
		  if (ipc_offset >= current_line_ptr[size>>1].ipc_saved) {
		     current_line_ptr = &current_line_ptr[size>>1];
		     size -= (size >> 1);
		     }
		  else {
		     size >>= 1;
		     }
		  }
	       }
	    line_num = current_line_ptr->line;
            temp_no = line_num & 65535;
            if ((lastline & 65535) != temp_no) {
#if e_line
               if (Testb((word)ToAscii(E_Line), curpstate->eventmask))
                     if (temp_no)
                        InterpEVVal(temp_no, e_line);
#endif
	       }
	    if (lastline != line_num) {
	       lastline = line_num;
#if e_loc
	       if (Testb((word)ToAscii(E_Loc), curpstate->eventmask) &&
		   current_line_ptr->line >> 16)
		  InterpEVVal(current_line_ptr->line, e_loc);
#endif
	       }
	    }
	}
      }
#else					/* E_Line || E_Loc */
#ifdef MultiProgram
      /*
       * We are uninstrumented code, but the program should be instrumented.
       * Switch to the instrumented version of the interpreter.
       */
      if (curpstate->Interp == interp_1) {
	 ilevel--;
	 ExInterp_sp;
#ifdef TSTATARG 
	 return interp_1(0, cargp, CURTSTATARG);
#else 		 	   	  	 /* TSTATARG */
         return interp_1(0, cargp);
#endif 		 	   	  	 /* TSTATARG */
	 }
#endif					/* MultiProgram */
#endif					/* E_Line || E_Loc */

      lastop = GetOp;		/* Instruction fetch */

#ifdef StackPic
      ExInterp_sp;
      stkdump((int)lastop);
      EntInterp_sp;
#endif					/* StackPic */

/*
 * The following code is operating-system dependent [@interp.03].  Check
 *  for external event.
 */
#if PORT
Deliberate Syntax Error
#endif					/* PORT */

#if MSDOS || MVS || UNIX || VM || VMS
   /* nothing to do */
#endif					/* MSDOS || ... */

/*
 * End of operating-system specific code.
 */

#if e_opcode
      EVValEx(lastop,E_Opcode,word mylastop,mylastop=lastop,lastop=mylastop);
#endif					/* E_Opcode */

#ifdef Concurrent
      /* If there is a pending GC request, then block/sleep*/
      if (thread_call){
      	ExInterp_sp;
	thread_control(TC_ANSWERCALL);
	/*EntInterp_sp;*/
	}
#endif					/* Concurrent */

      switch ((int)lastop) {		/*
				 * Switch on opcode.  The cases are
				 * organized roughly by functionality
				 * to make it easier to find things.
				 * For some C compilers, there may be
				 * an advantage to arranging them by
				 * likelihood of selection.
				 */

				/* ---Constant construction--- */

#ifdef OVLD
	     tended struct descrip x;
	     int fieldnum;
#endif


	 case Op_Cset:		/* cset */
#ifdef Concurrent
	    MUTEX_LOCKID(MTX_OP_ACSET);
            if (ipc.op[-1] == Op_Acset) { 
	      MUTEX_UNLOCKID(MTX_OP_ACSET); goto L_acset; }
#else					/*Concurrent*/
	    PutOp(Op_Acset);
#endif					/*Concurrent*/
	    PushVal(D_Cset);
	    opnd = GetWord;
	    opnd += (word)ipc.opnd;
#ifdef Concurrent
	    PutInstr(Op_Acset, opnd, 1);
#else					/*Concurrent*/
	    PutWord(opnd);
#endif					/*Concurrent*/
	    PushAVal(opnd);
	    InterpEVValD((dptr)(rsp-1), e_literal);

            MUTEX_UNLOCKID(MTX_OP_ACSET);
	    break;

	 case Op_Acset: 	/* cset, absolute address */
L_acset:
	    PushVal(D_Cset);
	    PushAVal(GetWord);
	    InterpEVValD((dptr)(rsp-1), e_literal);
	    break;

	 case Op_Int:		/* integer */
	    PushVal(D_Integer);
	    PushVal(GetWord);
	    InterpEVValD((dptr)(rsp-1), e_literal);
	    break;

	 case Op_Real:		/* real */
#ifdef Concurrent
	    MUTEX_LOCKID(MTX_OP_AREAL);
            if (ipc.op[-1] == Op_Areal) { 
	      MUTEX_UNLOCKID(MTX_OP_AREAL); goto L_areal; }
#else					/*Concurrent*/
	    PutOp(Op_Areal);
#endif					/*Concurrent*/
	    PushVal(D_Real);
	    opnd = GetWord;
	    opnd += (word)ipc.opnd;
#ifdef DescriptorDouble
	    /*
	     * Now it is a pointer, but we want it to be the actual double.
	     * Fetch the bit pattern needed.  Beware of fetching as real and
	     * casting to word (int); it will change the value.
	     */
	    opnd = ((dptr)opnd)->vword.integr;
	    PushVal( opnd );
#else
	    PushAVal(opnd);
#endif					/* DescriptorDouble */
#ifdef Concurrent
	    PutInstr(Op_Areal, opnd, 1);
#else					/*Concurrent*/
	    PutWord(opnd);
#endif					/*Concurrent*/
	    InterpEVValD((dptr)(rsp-1), e_literal);

            MUTEX_UNLOCKID(MTX_OP_AREAL);
	    break;

	 case Op_Areal: 	/* real, absolute address */
L_areal:
	    PushVal(D_Real);
#ifdef DescriptorDouble
	    PushVal(GetWord);
#else					/* DescriptorDouble */
	    PushAVal(GetWord);
#endif					/* DescriptorDouble */
	    InterpEVValD((dptr)(rsp-1), e_literal);
	    break;

	 case Op_Str:		/* string */
#ifdef Concurrent
	    MUTEX_LOCKID(MTX_OP_ASTR);
            if (ipc.op[-1] == Op_Astr) {
	       MUTEX_UNLOCKID(MTX_OP_ASTR); goto L_astr; }
#else					/*Concurrent*/
	    PutOp(Op_Astr);
#endif					/*Concurrent*/
	    PushVal(GetWord)

#ifdef MultiProgram
	    /*
	     * if the current procedure is not within the current program
	     * state, then lookup the program state of the current procedure,
	     * and use its globals instead of the current program state.
	     */
	    if (!InRange(code, ipc.opnd, endcode)) {
	       struct progstate *p = findicode(ipc.opnd);
	       opnd = (word)(p->Strcons + GetWord);
	       }
	    else
#endif					/* MultiProgram */
          opnd = (word)strcons + GetWord;

#ifdef Concurrent
	    PutInstr(Op_Astr, opnd, 2);
#else					/*Concurrent*/
	    PutWord(opnd);
#endif					/*Concurrent*/
	    PushAVal(opnd);
	    InterpEVValD((dptr)(rsp-1), e_literal);

            MUTEX_UNLOCKID(MTX_OP_ASTR);
	    break;

	 case Op_Astr:		/* string, absolute address */
L_astr:
	    PushVal(GetWord);
	    PushAVal(GetWord);
	    InterpEVValD((dptr)(rsp-1), e_literal);
	    break;

				/* ---Variable construction--- */

	 case Op_Arg:		/* argument */
	    PushVal(D_Var);
	    PushAVal(&glbl_argp[GetWord + 1]);
	    break;

	 case Op_Global:	/* global */
#ifdef Concurrent
	    MUTEX_LOCKID(MTX_OP_AGLOBAL);
            if (ipc.op[-1] == Op_Aglobal) {
	      MUTEX_UNLOCKID(MTX_OP_AGLOBAL); goto L_aglobal; }
#else					/*Concurrent*/
	    PutOp(Op_Aglobal);
#endif					/*Concurrent*/
	    PushVal(D_Var);
	    opnd = GetWord;
#ifdef MultiProgram
	    /*
	     * if the current procedure is not within the current program
	     * state, then lookup the program state of the current procedure,
	     * and use its globals instead of the current program state.
	     */
	    if (!InRange(code, ipc.opnd, endcode)) {
	       struct progstate *p = findicode(ipc.opnd);
	       PushAVal(&(p->Globals[opnd]));
	       PutWord((word)&(p->Globals[opnd]));
	       }
	    else
#endif					/* MultiProgram */
	    {
	    PushAVal(&globals[opnd]);
#ifdef Concurrent
	    PutInstr(Op_Aglobal, (word)&globals[opnd], 1);
#else					/*Concurrent*/
	    PutWord((word)&globals[opnd]);
#endif					/*Concurrent*/
	    }

            MUTEX_UNLOCKID(MTX_OP_AGLOBAL);
	    break;

	 case Op_Aglobal:	/* global, absolute address */
L_aglobal:
	    PushVal(D_Var);
	    PushAVal(GetWord);
	    break;

	 case Op_Local: 	/* local */
	    PushVal(D_Var);
	    PushAVal(&pfp->pf_locals[GetWord]);
	    break;

	 case Op_Static:	/* static */
#ifdef Concurrent
	    MUTEX_LOCKID(MTX_OP_ASTATIC);
            if (ipc.op[-1] == Op_Astatic) {
	      MUTEX_UNLOCKID(MTX_OP_ASTATIC); goto L_astatic; }
#else					/*Concurrent*/
	    PutOp(Op_Astatic);
#endif					/*Concurrent*/
	    PushVal(D_Var);
	    opnd = GetWord;
#ifdef MultiProgram
	    /*
	     * if the current procedure is not within the current program
	     * state, then lookup the program state of the current procedure,
	     * and use its statics instead of the current program state.
	     */
	    if (!InRange(code, ipc.opnd, endcode)) {
	       struct progstate *p = findicode(ipc.opnd);
	       PushAVal(&(p->Statics[opnd]));
	       PutWord((word)&(p->Statics[opnd]));
	       }
	    else
#endif					/* MultiProgram */
	    {
	    PushAVal(&statics[opnd]);
#ifdef Concurrent
	    PutInstr(Op_Astatic, (word)&statics[opnd], 1);
#else					/*Concurrent*/
	    PutWord((word)&statics[opnd]);
#endif					/*Concurrent*/
	    }

            MUTEX_UNLOCKID(MTX_OP_ASTATIC);
	    break;

	 case Op_Astatic:	/* static, absolute address */
L_astatic:
	    PushVal(D_Var);
	    PushAVal(GetWord);
	    break;


				/* ---Operators--- */

				/* Unary operators */

	 case Op_Compl: 	/* ~e */
	 case Op_Neg:		/* -e */
	 case Op_Number:	/* +e */
	 case Op_Refresh:	/* ^e */
	 case Op_Size:		/* *e */
	    Setup_Op(1, e_ocall);
	    HandleOVLD(1);
	    DerefArg(1);
	    Call_Cond(e_ofail);

	 case Op_Value: 	/* .e */
            Setup_Op(1, e_ocall);
            DerefArg(1);
            Call_Cond(e_ofail);

	 case Op_Nonnull:	/* \e */
	 case Op_Null:		/* /e */
	    Setup_Op(1, e_ocall);
	    Call_Cond(e_ofail);

	 case Op_Random:	/* ?e */
	    PushNull;
	    Setup_Op(2, e_ocall)
	    HandleOVLD(1);
	    Call_Cond(e_ofail)

				/* Generative unary operators */

	 case Op_Tabmat:	/* =e */
	    Setup_Op(1, e_ocall);
	    HandleOVLD(1);
	    DerefArg(1);
	    Call_Gen;

	 case Op_Bang:		/* !e */
	    PushNull;
	    Setup_Op(2, e_ocall);
	    HandleOVLD(1);
	    Call_Gen;

				/* Binary operators */

	 case Op_Cat:		/* e1 || e2 */
	 case Op_Diff:		/* e1 -- e2 */
	 case Op_Div:		/* e1 / e2 */
	 case Op_Inter: 	/* e1 ** e2 */
	 case Op_Lconcat:	/* e1 ||| e2 */
	 case Op_Minus: 	/* e1 - e2 */
	 case Op_Mod:		/* e1 % e2 */
	 case Op_Mult:		/* e1 * e2 */
	 case Op_Power: 	/* e1 ^ e2 */
	 case Op_Unions:	/* e1 ++ e2 */
	 case Op_Plus:		/* e1 + e2 */
	 case Op_Eqv:		/* e1 === e2 */
	 case Op_Lexeq: 	/* e1 == e2 */
	 case Op_Lexge: 	/* e1 >>= e2 */
	 case Op_Lexgt: 	/* e1 >> e2 */
	 case Op_Lexle: 	/* e1 <<= e2 */
	 case Op_Lexlt: 	/* e1 << e2 */
	 case Op_Lexne: 	/* e1 ~== e2 */
	 case Op_Neqv:		/* e1 ~=== e2 */
	 case Op_Numeq: 	/* e1 = e2 */
	 case Op_Numge: 	/* e1 >= e2 */
	 case Op_Numgt: 	/* e1 > e2 */
	 case Op_Numle: 	/* e1 <= e2 */
	 case Op_Numne: 	/* e1 ~= e2 */
	 case Op_Numlt: 	/* e1 < e2 */
	    Setup_Op(2, e_ocall);
	    HandleOVLD(2);
	    DerefArg(1);
	    DerefArg(2);
	    Call_Cond(e_ofail);

	 case Op_Rcv: 		/* e1 @< e2 */
	 case Op_RcvBk:		/* e1 @<< e2 */
	 case Op_Snd: 		/* e1 @> e2 */
	 case Op_SndBk:		/* e1 @>> e2 */
	    Setup_Op(2, e_ocall);
	    DerefArg(1);
	    DerefArg(2);
	    Call_Cond(e_ofail);

	 case Op_Asgn:		/* e1 := e2 */
	    Setup_Op(2, e_ocall);
	    Call_Cond(e_ofail);

	 case Op_Swap:		/* e1 :=: e2 */
	    PushNull;
	    Setup_Op(3, e_ocall);
	    Call_Cond(e_ofail);

	 case Op_Subsc: 	/* e1[e2] */
	    PushNull;
	    Setup_Op(3, e_ocall);
	    HandleOVLD(2);
	    Call_Cond(e_ofail);
				/* Generative binary operators */

	 case Op_Rasgn: 	/* e1 <- e2 */
	    Setup_Op(2, e_ocall);
	    Call_Gen;

	 case Op_Rswap: 	/* e1 <-> e2 */
	    PushNull;
	    Setup_Op(3, e_ocall);
	    Call_Gen;

				/* Conditional ternary operators */

	 case Op_Sect:		/* e1[e2:e3] */
	    PushNull;
	    Setup_Op(4, e_ocall);
	    HandleOVLD(4);
	    Call_Cond(e_ofail);
				/* Generative ternary operators */

	 case Op_Toby:		/* e1 to e2 by e3 */
	    Setup_Op(3, e_ocall);
	    HandleOVLD(3);
	    DerefArg(1);
	    DerefArg(2);
	    DerefArg(3);
	    Call_Gen;

         case Op_Noop:		/* no-op */
      
#ifdef LineCodes
#ifdef Polling
            if (!pollctr--) {
	       ExInterp_sp;
               pollctr = pollevent();
	       EntInterp_sp;
	       if (pollctr == -1) fatalerr(141, NULL);
	       }	       
#endif					/* Polling */


#endif				/* LineCodes */

            break;


         case Op_Colm:		/* source column number */
            {
#if e_loc
            word loc;
            column = GetWord;
            loc = column;
            loc <<= (WordBits >> 1);	/* column in high-order part */
            loc += line_num;
            InterpEVVal(loc, E_Loc);
#endif					/* E_Loc */

            break;
            }

         case Op_Line:		/* source line number */

#if defined(LineCodes) && defined(Polling)
            if (!pollctr--) {
	       ExInterp_sp;
               pollctr = pollevent();
	       EntInterp_sp;
	       if (pollctr == -1) fatalerr(141, NULL);
	       }	       
#endif					/* LineCodes && Polling */
            line_num = GetWord;
#ifdef MultiProgram
            lastline = line_num;
#endif					/* MultiProgram */
            break;

				/* ---String Scanning--- */

	 case Op_Bscan: 	/* prepare for scanning */
	    PushDesc(k_subject);
	    PushVal(D_Integer);
	    PushVal(k_pos);
	    Setup_Arg(2);

	    signal = Obscan(2,rargp);

	    goto C_rtn_term;

	 case Op_Escan: 	/* exit from scanning */
	    Setup_Arg(1);

	    signal = Oescan(1,rargp);

	    goto C_rtn_term;

				/* ---Other Language Operations--- */

         case Op_Apply: {	/* apply, a.k.a. binary bang */
            union block *bp;
            int i, j;

            value_tmp = *(dptr)(rsp - 1);	/* argument */
            Deref(value_tmp);
            switch (Type(value_tmp)) {
               case T_List: {
                  rsp -= 2;				/* pop it off */
                  bp = BlkLoc(value_tmp);
                  args = (int)Blk(bp,List)->size;

#ifdef StackCheck
		  /*
		   * Make a stab at catching interpreter stack overflow.
		   * This does not detect C stack overflow.
		   */
		  if ((char *)sp + args * sizeof(struct descrip) + PerilDelta >
                       (char *)(BlkD(k_current,Coexpr)->es_stackend)) {
		     fatalerr(301, NULL);
		     }
#else					/* StackCheck */
#ifndef MultiProgram
		  /*
		   * Make a stab at catching interpreter stack overflow.
		   * This does nothing for invocation in a co-expression other
		   * than &main.
		   */
		  if (BlkLoc(k_current) == BlkLoc(k_main) &&
		      ((char *)sp + args * sizeof(struct descrip) >
                       (char *)stackend))
		     fatalerr(301, NULL);
#endif					/* MultiProgram */
#endif					/* StackCheck */

#ifdef Arrays
		  if(Blk(bp,List)->listtail) {
#endif					/* Arrays */
                  for (bp = Blk(bp,List)->listhead; BlkType(bp) == T_Lelem;
		       bp = Blk(bp,Lelem)->listnext) {
		     for (i = 0; i < Blk(bp,Lelem)->nused; i++) {
			j = bp->Lelem.first + i;
			if (j >= bp->Lelem.nslots)
			   j -= bp->Lelem.nslots;
			PushDesc(bp->Lelem.lslots[j]);
			}
		     }
#ifdef Arrays
		  }
		  else {
		     bp = Blk(bp,List)->listhead;
		     if (bp->Intarray.title==T_Intarray) {
			for (i = 0; i < args; i++) {
			   PushVal(D_Integer);
			   PushVal(bp->Intarray.a[i]);
			   }
			}
		     else { /* not list or an intarray, must be a realarray */
#ifndef DescriptorDouble
			reserve(Blocks, args * sizeof(struct b_real));
			bp = BlkLoc(value_tmp)->List.listhead;
#endif
			for (i = 0; i < args; i++) {
			   PushVal(D_Real);
#ifdef DescriptorDouble
			   PushVal(*(word *)(bp->Realarray.a+i));
#else
			   PushAVal(alcreal(bp->Realarray.a[i]));
#endif
			   }
			}
		     }
#endif					/* Arrays */

		  goto invokej;
		  }

               case T_Record: {
                  rsp -= 2;		/* pop it off */
                  bp = (union block *)BlkD(value_tmp, Record);
                  args = Blk(bp->Record.recdesc,Proc)->nfields;
                  for (i = 0; i < args; i++) {
                     PushDesc(bp->Record.fields[i]);
                     }
                  goto invokej;
                  }

               default: {		/* illegal type for invocation */
                  xargp = (dptr)(rsp - 3);
                  err_msg(126, &value_tmp);
                  goto efail;
                  }
               }
	    }

	 case Op_Invoke: {	/* invoke */
            args = (int)GetWord;
invokej:
	    {
            int nargs;
	    dptr carg;

	    ExInterp_sp;
#if e_stack
	    EVVal(DiffPtrs(sp, BlkD(k_current,Coexpr)->es_stack), e_stack);
#endif

#ifdef StackCheck
	    /*
	     * Make a stab at catching interpreter stack overflow.  This does
	     * not detect C stack overflow.
	     */
	    if (((char *)sp + PerilDelta) >
		(char *)(BlkD(k_current,Coexpr)->es_stackend))
	       fatalerr(301, NULL);
#endif					/* StackCheck */

	    type = invoke(args, &carg, &nargs);
	    EntInterp_sp;

	    if (type == I_Fail)
	       goto efail_noev;
	    if (type == I_Continue)
	       break;
	    else {

               rargp = carg;		/* valid only for Vararg or Builtin */

#ifdef Polling
	       /*
		* Do polling here
		*/
	       pollctr >>= 1;
               if (!pollctr) {
	          ExInterp_sp;
                  pollctr = pollevent();
	          EntInterp_sp;
	          if (pollctr == -1) fatalerr(141, NULL);
	          }	       
#endif					/* Polling */

#ifdef MultiProgram
	       lastev = E_Function;
	       lastdesc = *rargp;
	       InterpEVValD(rargp, e_fcall);
#endif					/* MultiProgram */

	       bproc = BlkD(*rargp, Proc);

#ifdef FncTrace
               typedef int (*bfunc2)(dptr, struct descrip *);
#endif					/* FncTrace */


	       /* ExInterp not needed since no change since last EntInterp */
	       if (type == I_Vararg) {
	          int (*bfunc)();
                  bfunc = bproc->entryp.ccode;

#ifdef FncTrace
                  signal = (*bfunc)(nargs, rargp, &(procs->pname));
#else					/* FncTrace */
		  signal = (*bfunc)(nargs,rargp);
#endif					/* FncTrace */

                  }
	       else
                  {
                  int (*bfunc)();
                  bfunc = bproc->entryp.ccode;

#ifdef FncTrace
                  signal = (*(bfunc2)bfunc)(rargp, &(bproc->pname));
#else					/* FncTrace */
		  signal = (*bfunc)(rargp);
#endif					/* FncTrace */
                  }

#ifdef FncTrace
               if (k_ftrace) {
                  k_ftrace--;
                  if (signal == A_Failure)
                     failtrace(&(bproc->pname));
                  else
                     rtrace(&(bproc->pname),rargp);
                  }
#endif					/* FncTrace */

	       goto C_rtn_term;
	       }
	    }
	    break;
	    }

	 case Op_Keywd: 	/* keyword */

            PushNull;
            opnd = GetWord;
            Setup_Arg(0);

	    signal = (*(keytab[(int)opnd]))(rargp);
	    goto C_rtn_term;

	 case Op_Llist: 	/* construct list */
	    opnd = GetWord;

#ifdef MultiProgram
            value_tmp.dword = D_Proc;
            value_tmp.vword.bptr = (union block *)&mt_llist;
            lastev = E_Operator;
	    lastdesc = value_tmp;
            InterpEVValD(&value_tmp, e_ocall);
            rargp = (dptr)(rsp - 1) - opnd;
            xargp = rargp;
            ExInterp_sp;
#else					/* MultiProgram */
	    Setup_Arg(opnd);
#endif					/* MultiProgram */

	    {
	    int i;
	    for (i=1;i<=opnd;i++)
               DerefArg(i);
	    }

	    signal = Ollist((int)opnd,rargp);

   	    value_tmp = nulldesc;

	    goto C_rtn_term;

				/* ---Marking and Unmarking--- */

	 case Op_Mark:		/* create expression frame marker */
#ifdef Concurrent
	    MUTEX_LOCKID(MTX_OP_AMARK);
            if (ipc.op[-1] == Op_Amark) {
	      MUTEX_UNLOCKID(MTX_OP_AMARK); goto L_amark; }
#else					/*Concurrent*/
	    PutOp(Op_Amark);
#endif					/*Concurrent*/
	    opnd = GetWord;
	    opnd += (word)ipc.opnd;
#ifdef Concurrent
	    PutInstr(Op_Amark, opnd, 1);
#else					/*Concurrent*/
	    PutWord(opnd); 
#endif					/*Concurrent*/
	    newefp = (struct ef_marker *)(rsp + 1);
	    newefp->ef_failure.opnd = (word *)opnd;

            MUTEX_UNLOCKID(MTX_OP_AMARK);
	    goto mark;

	 case Op_Amark: 	/* mark with absolute fipc */
L_amark:
	    newefp = (struct ef_marker *)(rsp + 1);
	    newefp->ef_failure.opnd = (word *)GetWord;
mark:
	    newefp->ef_gfp = gfp;
	    newefp->ef_efp = efp;
	    newefp->ef_ilevel = ilevel;
	    InterpEVValS((word *) ipc.opnd, E_Syntax);/* -new- */
	    rsp += Wsizeof(*efp);
	    efp = newefp;
	    gfp = 0;
            InterpEVVal(newefp->ef_failure.opnd, E_Operand);
	    break;

	 case Op_Mark0: 	/* create expression frame with 0 ipl */
mark0:
	    newefp = (struct ef_marker *)(rsp + 1);
	    newefp->ef_failure.opnd = 0;
	    newefp->ef_gfp = gfp;
	    newefp->ef_efp = efp;
	    newefp->ef_ilevel = ilevel;
            InterpEVValS((word *) ipc.opnd, E_Syntax);/* -new- */
	    rsp += Wsizeof(*efp);
	    efp = newefp;
	    gfp = 0;
            InterpEVVal(newefp->ef_failure.opnd, E_Operand);
	    break;

	 case Op_Unmark:	/* remove expression frame */

#if e_prem || e_erem
	    ExInterp_sp;
            vanq_bound(efp, gfp);
	    EntInterp_sp;
#endif					/* E_Prem || E_Erem */

	    gfp = efp->ef_gfp;
	    rsp = (word *)efp - 1;

	    /*
	     * Remove any suspended C generators.
	     */
Unmark_uw:
            InterpEVValS((word *) ipc.opnd - 1, E_Syntax); /* -new- */
	    if (efp->ef_ilevel < ilevel) {
	       --ilevel;
	       ExInterp_sp;
	       EVVal(A_Unmark_uw, e_intret);
#ifdef StackCheck
	       EVVal(DiffPtrs(sp, BlkD(k_current,Coexpr)->es_stack), e_cstack);
#else					/* StackCheck */
	       EVVal(DiffPtrs(sp, stack), e_cstack);
#endif					/* StackCheck */
	       return A_Unmark_uw;
	       }

	    efp = efp->ef_efp;
	    break;

				/* ---Suspensions--- */

	 case Op_Esusp: {	/* suspend from expression */

	    /*
	     * Create the generator frame.
	     */
	    oldsp = rsp;
	    newgfp = (struct gf_marker *)(rsp + 1);
	    newgfp->gf_gentype = G_Esusp;
	    newgfp->gf_gfp = gfp;
	    newgfp->gf_efp = efp;
	    newgfp->gf_ipc = ipc;
	    gfp = newgfp;
	    rsp += Wsizeof(struct gf_smallmarker);

	    /*
	     * Region extends from first word after enclosing generator or
	     *	expression frame marker to marker for current expression frame.
	     */
	    if (efp->ef_gfp != 0) {
	       newgfp = (struct gf_marker *)(efp->ef_gfp);
	       if (newgfp->gf_gentype == G_Psusp)
		  firstwd = (word *)efp->ef_gfp + Wsizeof(*gfp);
	       else
		  firstwd = (word *)efp->ef_gfp +
		     Wsizeof(struct gf_smallmarker);
		}
	    else
	       firstwd = (word *)efp->ef_efp + Wsizeof(*efp);
	    lastwd = (word *)efp - 1;
	    efp = efp->ef_efp;

	    /*
	     * Copy the portion of the stack with endpoints firstwd and lastwd
	     *	(inclusive) to the top of the stack.
	     */
	    for (wd = firstwd; wd <= lastwd; wd++)
	       *++rsp = *wd;
	    PushVal(oldsp[-1]);
	    PushVal(oldsp[0]);
	    break;
	    }

	 case Op_Lsusp: {	/* suspend from limitation */
	    struct descrip sval;

	    /*
	     * The limit counter is contained in the descriptor immediately
	     *	prior to the current expression frame.	lval is established
	     *	as a pointer to this descriptor.
	     */
	    dptr lval = (dptr)((word *)efp - 2);

	    /*
	     * Decrement the limit counter and check it.
	     */
	    if (--IntVal(*lval) > 0) {
	       /*
		* The limit has not been reached, set up stack.
		*/

	       sval = *(dptr)(rsp - 1);	/* save result */

	       /*
		* Region extends from first word after enclosing generator or
		*  expression frame marker to the limit counter just prior to
		*  to the current expression frame marker.
		*/
	       if (efp->ef_gfp != 0) {
		  newgfp = (struct gf_marker *)(efp->ef_gfp);
		  if (newgfp->gf_gentype == G_Psusp)
		     firstwd = (word *)efp->ef_gfp + Wsizeof(*gfp);
		  else
		     firstwd = (word *)efp->ef_gfp +
			Wsizeof(struct gf_smallmarker);
		  }
	       else
		  firstwd = (word *)efp->ef_efp + Wsizeof(*efp);
	       lastwd = (word *)efp - 3;
	       if (gfp == 0)
		  gfp = efp->ef_gfp;
	       efp = efp->ef_efp;

	       /*
		* Copy the portion of the stack with endpoints firstwd and lastwd
		*  (inclusive) to the top of the stack.
		*/
	       rsp -= 2;		/* overwrite result */
	       for (wd = firstwd; wd <= lastwd; wd++)
		  *++rsp = *wd;
	       PushDesc(sval);		/* push saved result */
	       }
	    else {
	       /*
		* Otherwise, the limit has been reached.  Instead of
		*  suspending, remove the current expression frame and
		*  replace the limit counter with the value on top of
		*  the stack (which would have been suspended had the
		*  limit not been reached).
		*/
	       *lval = *(dptr)(rsp - 1);

#if e_prem || e_erem
	       ExInterp_sp;
               vanq_bound(efp, gfp);
	       EntInterp_sp;
#endif					/* E_Prem || E_Erem */

	       gfp = efp->ef_gfp;

	       /*
		* Since an expression frame is being removed, inactive
		*  C generators contained therein are deactivated.
		*/
Lsusp_uw:
	       if (efp->ef_ilevel < ilevel) {
		  --ilevel;
		  ExInterp_sp;
                  EVVal(A_Lsusp_uw, e_intret);
#ifdef StackCheck
		  EVVal(DiffPtrs(sp, BlkD(k_current,Coexpr)->es_stack), e_cstack);
#else					/* StackCheck */
		  EVVal(DiffPtrs(sp, stack), e_cstack);
#endif					/* StackCheck */
		  return A_Lsusp_uw;
		  }
	       rsp = (word *)efp - 1;
	       efp = efp->ef_efp;
	       }
	    break;
	    }

	 case Op_Psusp: {	/* suspend from procedure */

	    /*
	     * An Icon procedure is suspending a value.  Determine if the
	     *	value being suspended should be dereferenced and if so,
	     *	dereference it. If tracing is on, strace is called
	     *  to generate a message.  Appropriate values are
	     *	restored from the procedure frame of the suspending procedure.
	     */

	    struct descrip tmp;
            dptr svalp;
	    struct b_proc *sproc;

#if e_psusp
            value_tmp = *(dptr)(rsp - 1);	/* argument */
            Deref0(value_tmp);
            InterpEVValD(&value_tmp, E_Psusp);
#endif					/* E_Psusp */

	    svalp = (dptr)(rsp - 1);
	    if (Var(*svalp)) {
               ExInterp_sp;
               retderef(svalp, (word *)glbl_argp, sp);
               EntInterp_sp;
               }

	    /*
	     * Create the generator frame.
	     */
	    oldsp = rsp;
	    newgfp = (struct gf_marker *)(rsp + 1);
	    newgfp->gf_gentype = G_Psusp;
	    newgfp->gf_gfp = gfp;
	    newgfp->gf_efp = efp;
	    newgfp->gf_ipc = ipc;
	    newgfp->gf_argp = glbl_argp;
	    newgfp->gf_pfp = pfp;
	    gfp = newgfp;
	    rsp += Wsizeof(*gfp);

	    /*
	     * Region extends from first word after the marker for the
	     *	generator or expression frame enclosing the call to the
	     *	now-suspending procedure to Arg0 of the procedure.
	     */
	    if (pfp->pf_gfp != 0) {
	       newgfp = (struct gf_marker *)(pfp->pf_gfp);
	       if (newgfp->gf_gentype == G_Psusp)
		  firstwd = (word *)pfp->pf_gfp + Wsizeof(*gfp);
	       else
		  firstwd = (word *)pfp->pf_gfp +
		     Wsizeof(struct gf_smallmarker);
	       }
	    else
	       firstwd = (word *)pfp->pf_efp + Wsizeof(*efp);
	    lastwd = (word *)glbl_argp - 1;
	       efp = efp->ef_efp;

	    /*
	     * Copy the portion of the stack with endpoints firstwd and lastwd
	     *	(inclusive) to the top of the stack.
	     */
	    for (wd = firstwd; wd <= lastwd; wd++)
	       *++rsp = *wd;
	    PushVal(oldsp[-1]);
	    PushVal(oldsp[0]);
	    --k_level;
	    if (k_trace) {
               k_trace--;
	       sproc = BlkD(*glbl_argp, Proc);
	       strace(&(sproc->pname), svalp);
	       }

	    /*
	     * If the scanning environment for this procedure call is in
	     *	a saved state, switch environments.
	     */
	    if (pfp->pf_scan != NULL) {
	       InterpEVValD(&k_subject, e_ssusp);
	       tmp = k_subject;
	       k_subject = *pfp->pf_scan;
	       *pfp->pf_scan = tmp;

	       tmp = *(pfp->pf_scan + 1);
	       IntVal(*(pfp->pf_scan + 1)) = k_pos;
	       k_pos = IntVal(tmp);
	       }

	    efp = pfp->pf_efp;
	    ipc = pfp->pf_ipc;
	    glbl_argp = pfp->pf_argp;
	    pfp = pfp->pf_pfp;
   	    value_tmp = nulldesc;
	    break;
	    }

				/* ---Returns--- */

	 case Op_Eret: {	/* return from expression */
	    /*
	     * Op_Eret removes the current expression frame, leaving the
	     *	original top of stack value on top.
	     */
	    /*
	     * Save current top of stack value in global temporary (no
	     *	danger of reentry).
	     */
	    eret_tmp = *(dptr)&rsp[-1];
	    gfp = efp->ef_gfp;
Eret_uw:
	    /*
	     * Since an expression frame is being removed, inactive
	     *	C generators contained therein are deactivated.
	     */
	    if (efp->ef_ilevel < ilevel) {
	       --ilevel;
	       ExInterp_sp;
               EVVal(A_Eret_uw, e_intret);
#ifdef StackCheck
	       EVVal(DiffPtrs(sp, BlkD(k_current,Coexpr)->es_stack), e_cstack);
#else					/* StackCheck */
	       EVVal(DiffPtrs(sp, stack), e_cstack);
#endif					/* StackCheck */
	       return A_Eret_uw;
	       }
	    rsp = (word *)efp - 1;
	    efp = efp->ef_efp;
	    PushDesc(eret_tmp);
	    eret_tmp = nulldesc;
	    break;
	    }


	 case Op_Pret: {	/* return from procedure */
	    /*
	     * An Icon procedure is returning a value.	Determine if the
	     *	value being returned should be dereferenced and if so,
	     *	dereference it.  If tracing is on, rtrace is called to
	     *	generate a message.  Inactive generators created after
	     *	the activation of the procedure are deactivated.  Appropriate
	     *	values are restored from the procedure frame.
	     */
	    struct b_proc *rproc;
	    rproc = BlkD(*glbl_argp, Proc);
#if e_prem || e_erem
	    ExInterp_sp;
            vanq_proc(efp, gfp);
	    EntInterp_sp;
#endif					/* E_Prem || E_Erem */


#if e_pret
	    /*
	     * originally was InterpEVValD(argp,E_Pret) here.
	     * InterpEVValD(glbl_argp,E_Pret) would give the
	     * procedure as the event value; want actual return value.
	     *
	     * We do the E_Pret, using the return value in value_tmp,
	     * prior to replacing the procedure ref (in glbl_argp)
	     * with the return value.
	     */
	    value_tmp = *(dptr)(rsp - 1);	/* argument */
	    Deref0(value_tmp);
	    InterpEVValD(&value_tmp, E_Pret);
#endif


#ifdef MultiProgram
	    /*
	     * Store the procedure we are returning from, it may
	     * be useful in the E_Deref event in the retderef().
	     */
	    value_tmp = *glbl_argp;
#endif					/* MultiProgram */
	    *glbl_argp = *(dptr)(rsp - 1);

	    if (Var(*glbl_argp)) {
               ExInterp_sp;
               retderef(glbl_argp, (word *)glbl_argp, sp);
               EntInterp_sp;
               }

	    --k_level;
	    if (k_trace) {
               k_trace--;
	       rtrace(&(rproc->pname), glbl_argp);
               }
Pret_uw:
	    if (pfp->pf_ilevel < ilevel) {
	       --ilevel;
	       ExInterp_sp;

               EVVal(A_Pret_uw, e_intret);
#ifdef StackCheck
	       EVVal(DiffPtrs(sp, BlkD(k_current,Coexpr)->es_stack), e_cstack);
#else					/* StackCheck */
	       EVVal(DiffPtrs(sp, stack), e_cstack);
#endif					/* StackCheck */
	       return A_Pret_uw;
	       }
	   
	    rsp = (word *)glbl_argp + 1;
	    efp = pfp->pf_efp;
	    gfp = pfp->pf_gfp;
	    ipc = pfp->pf_ipc;
	    glbl_argp = pfp->pf_argp;
	    pfp = pfp->pf_pfp;
   	    value_tmp = nulldesc;

	    /*
	     * Had moved E_Pret (via value_tmp) here for awhile,
	     * but don't we get duplicate E_Pret's due to unwinding here?
	     */

	    break;
	    }

				/* ---Failures--- */

	 case Op_Efail:
efail:
            InterpEVVal((word)-1, e_efail);
efail_noev:
	    /*
	     * Failure has occurred in the current expression frame.
	     */
	    if (gfp == 0) {
	       /*
		* There are no suspended generators to resume.
		*  Remove the current expression frame, restoring
		*  values.
		*
		* If the failure ipc is 0, propagate failure to the
		*  enclosing frame by branching back to efail.
		*  This happens, for example, in looping control
		*  structures that fail when complete.
		*/

	      if (efp == 0) {
		 break;
	         }

               oldipc = ipc;            /* fixing the line zero return */
	       ipc = efp->ef_failure;
	       gfp = efp->ef_gfp;
	       rsp = (word *)efp - 1;
	       efp = efp->ef_efp;

	       if (ipc.op == 0)
		  goto efail;

               if (pfp != NULL &&  sp != rsp)
                  InterpEVValS((word *) ipc.opnd - 1, E_Syntax); /* -new- */

	       break;
	       }

	    else {
	       /*
		* There is a generator that can be resumed.  Make
		*  the stack adjustments and then switch on the
		*  type of the generator frame marker.
		*/
	       struct descrip tmp;
	       register struct gf_marker *resgfp = gfp;

	       type = (int)resgfp->gf_gentype;

	       if (type == G_Psusp) {
		  glbl_argp = resgfp->gf_argp;
		  if (k_trace) {	/* procedure tracing */
                     k_trace--;
		     ExInterp_sp;
		     atrace(&(BlkD(*glbl_argp, Proc)->pname));
		     EntInterp_sp;
		     }
		  }
	       ipc = resgfp->gf_ipc;
	       efp = resgfp->gf_efp;
	       gfp = resgfp->gf_gfp;
	       rsp = (word *)resgfp - 1;
	       if (type == G_Psusp) {
		  pfp = resgfp->gf_pfp;

		  /*
		   * If the scanning environment for this procedure call is
		   *  supposed to be in a saved state, switch environments.
		   */
		  if (pfp->pf_scan != NULL) {
		     tmp = k_subject;
		     k_subject = *pfp->pf_scan;
		     *pfp->pf_scan = tmp;

		     tmp = *(pfp->pf_scan + 1);
		     IntVal(*(pfp->pf_scan + 1)) = k_pos;
		     k_pos = IntVal(tmp);
		     InterpEVValD(&k_subject, e_sresum);
		     }

		  ++k_level;		/* adjust procedure level */
		  }

	       switch (type) {
		  case G_Fsusp:
		     ExInterp_sp;
                     EVVal((word)0, e_fresum);
		     --ilevel;
                     EVVal(A_Resume, e_intret);
#ifdef StackCheck
                     EVVal(DiffPtrs(sp, BlkD(k_current,Coexpr)->es_stack), e_cstack);
#else					/* StackCheck */
                     EVVal(DiffPtrs(sp, stack), e_cstack);
#endif					/* StackCheck */
		     return A_Resume;

		  case G_Osusp:
		     ExInterp_sp;
                     EVVal((word)0, e_oresum);
		     --ilevel;
                     EVVal(A_Resume, e_intret);
#ifdef StackCheck
                     EVVal(DiffPtrs(sp, BlkD(k_current,Coexpr)->es_stack), e_cstack);
#else					/* StackCheck */
                     EVVal(DiffPtrs(sp, stack), e_cstack);
#endif					/* StackCheck */
		     return A_Resume;

		  case G_Csusp:
		     ExInterp_sp;
                     EVVal((word)0, e_eresum);
		     --ilevel;
                     EVVal(A_Resume, e_intret);
#ifdef StackCheck
                     EVVal(DiffPtrs(sp, BlkD(k_current,Coexpr)->es_stack), e_cstack);
#else					/* StackCheck */
                     EVVal(DiffPtrs(sp, stack), e_cstack);
#endif					/* StackCheck */
		     return A_Resume;

		  case G_Esusp:
                     InterpEVVal((word)0, e_eresum);
		     goto efail_noev;

		  case G_Psusp:		/* resuming a procedure */
                     InterpEVValD(glbl_argp, e_presum);
		     break;
		  }

	       break;
	       }

	 case Op_Pfail: {	/* fail from procedure */

#if e_pfail || e_prem || e_erem
	    ExInterp_sp;
#if e_prem || e_erem
            vanq_proc(efp, gfp);
#endif					/* E_Prem || E_Erem */
            EVValD(glbl_argp, e_pfail);
	    EntInterp_sp;
#endif					/* E_Pfail || E_Prem || E_Erem */

	    /*
	     * An Icon procedure is failing.  Generate tracing message if
	     *	tracing is on.	Deactivate inactive C generators created
	     *	after activation of the procedure.  Appropriate values
	     *	are restored from the procedure frame.
	     */

	    --k_level;
	    if (k_trace) {
               k_trace--;
	       failtrace(&(BlkD(*glbl_argp, Proc)->pname));
               }
Pfail_uw:

	    if (pfp->pf_ilevel < ilevel) {
	       --ilevel;
	       ExInterp_sp;
               EVVal(A_Pfail_uw, e_intret);
#ifdef StackCheck
               EVVal(DiffPtrs(sp, BlkD(k_current,Coexpr)->es_stack), e_cstack);
#else					/* StackCheck */
               EVVal(DiffPtrs(sp, stack), e_cstack);
#endif					/* StackCheck */
	       return A_Pfail_uw;
	       }
	    efp = pfp->pf_efp;
	    gfp = pfp->pf_gfp;
	    ipc = pfp->pf_ipc;
	    glbl_argp = pfp->pf_argp;
	    pfp = pfp->pf_pfp;

	    goto efail_noev;
	    }
				/* ---Odds and Ends--- */

	 case Op_Ccase: 	/* case clause */
	    PushNull;
	    PushVal(((word *)efp)[-2]);
	    PushVal(((word *)efp)[-1]);
	    break;

	 case Op_Chfail:	/* change failure ipc */
	    opnd = GetWord;
	    opnd += (word)ipc.opnd;
	    efp->ef_failure.opnd = (word *)opnd;
	    break;

	 case Op_Dup:		/* duplicate descriptor */
	    PushNull;
	    rsp[1] = rsp[-3];
	    rsp[2] = rsp[-2];
	    rsp += 2;
	    break;

	 case Op_Field: 	/* e1.e2 */
	    PushVal(D_Integer);
	    PushVal(GetWord);
	    Setup_Arg(2);

ExInterp_sp;
	    signal = Ofield(2,rargp);
	    rargp = field_argp;
EntInterp_sp;

	    goto C_rtn_term;

	 case Op_Goto:		/* goto */

#ifdef Concurrent
	    MUTEX_LOCKID(MTX_OP_AGOTO);
            if (ipc.op[-1] == Op_Agoto) {
	      MUTEX_UNLOCKID(MTX_OP_AGOTO); goto L_agoto; }
#else					/*Concurrent*/
	    PutOp(Op_Agoto);
#endif					/*Concurrent*/
	    opnd = GetWord;
	    opnd += (word)ipc.opnd;
#ifdef Concurrent
	    PutInstr(Op_Agoto, opnd, 1);
#else					/*Concurrent*/
	    PutWord(opnd); 
#endif					/*Concurrent*/
	    ipc.opnd = (word *)opnd;

            MUTEX_UNLOCKID(MTX_OP_AGOTO);
	    break;

	 case Op_Agoto: 	/* goto absolute address */
L_agoto:
	    opnd = GetWord;
	    ipc.opnd = (word *)opnd;
	    break;

	 case Op_Init:		/* initial */
#ifdef Concurrent
	    MUTEX_LOCKID_CONTROLLED_ALWAYS(MTX_INITIAL);
            if (ipc.op[-1] == Op_Agoto) {
	       MUTEX_UNLOCKID_ALWAYS(MTX_INITIAL);
	       goto L_agoto; 
	       }
#else					/*Concurrent*/
	    *--ipc.op = Op_Goto;
#endif					/*Concurrent*/

#ifdef Concurrent
	    /* no-op on concurrent VM's, but still have to skip operand */
	    lock_count_mtx_init++;
	    if (*ipc.opnd ==-1){
	        while(lock_count_mtx_init--) 
	       	   MUTEX_UNLOCKID_ALWAYS(MTX_INITIAL);

		err_msg(182, NULL);
		}
	    *ipc.opnd = -1;
	    ipc.opnd++;
#else
	    opnd = sizeof(*ipc.op) + sizeof(*rsp);
	    opnd += (word)ipc.opnd;
	    ipc.opnd = (word *)opnd;
#endif
	    break;

	 case Op_EInit:
	    /* no-op on non-concurrent VM's, but still have to skip operand */
	    opnd = GetWord;
#ifdef Concurrent

	     /*
	      * Really interesting variant of PutInstr pokes instruction
	      * back at corresponding Op_Init instruction to be a Goto
	      * that jumps to the next instruction...which is our ipc.opnd
	      */

	     PutInstrAt(Op_Agoto, ipc.opnd, (ipc.op + ((opnd<<3)/IntBits+1)));

       	     MUTEX_UNLOCKID_ALWAYS(MTX_INITIAL);
	     lock_count_mtx_init--;
#endif					/* Concurrent */
	     break;

	 case Op_Limit: 	/* limit */
	    Setup_Arg(0);

	    if (Olimit(0,rargp) == A_Resume) {

	       /*
		* limit has failed here; could generate an event for it,
		*  but not an Ofail since limit is not an operator and
		*  no Ocall was ever generated for it.
		*/
	       goto efail_noev;
	       }
	    else {
	       /*
		* limit has returned here; could generate an event for it,
		*  but not an Oret since limit is not an operator and
		*  no Ocall was ever generated for it.
		*/
	       rsp = (word *) rargp + 1;
	       }
	    goto mark0;

#ifdef TallyOpt
	 case Op_Tally: 	/* tally */
	    tallybin[GetWord]++;
	    break;
#endif					/* TallyOpt */

	 case Op_Pnull: 	/* push null descriptor */
	    PushNull;
	    break;

	 case Op_Pop:		/* pop descriptor */
	    rsp -= 2;
	    break;

	 case Op_Push1: 	/* push integer 1 */
	    PushVal(D_Integer);
	    PushVal(1);
	    break;

	 case Op_Pushn1:	/* push integer -1 */
	    PushVal(D_Integer);
	    PushVal(-1);
	    break;

	 case Op_Sdup:		/* duplicate descriptor */
	    rsp += 2;
	    rsp[-1] = rsp[-3];
	    rsp[0] = rsp[-2];
	    break;

					/* --- calling Icon from C --- */
#ifdef PosixFns
         case Op_Copyd:         /* Copy a descriptor from off efp */
            opnd = GetWord;
            rsp += 2;
            opnd *= 2;
            rsp[-1] = *((word *)efp + opnd);
            rsp[0] = *((word *)efp + opnd + 1);
            break;
         
         case Op_Trapret:
            ilevel--;
            ExInterp_sp;
            return A_Trapret;
         
         case Op_Trapfail:
            ilevel--;
            ExInterp_sp;
            return A_Trapfail;
#endif					/* PosixFns */

					/* ---Co-expressions--- */

	 case Op_Create:	/* create */

#ifdef CoExpr
	    PushNull;
	    Setup_Arg(0);
	    opnd = GetWord;
	    opnd += (word)ipc.opnd;

	    signal = Ocreate((word *)opnd, rargp);

	    goto C_rtn_term;
#else					/* CoExpr */
	    err_msg(401, NULL);
	    goto efail;
#endif					/* CoExpr */

	 case Op_Coact: {	/* @e */


#ifndef CoExpr
            err_msg(401, NULL);
            goto efail;
#else                                        /* CoExpr */
            struct b_coexpr *ncp;
            dptr dp;

            ExInterp_sp;
            dp = (dptr)(sp - 1);
            xargp = dp - 2;

            Deref(*dp);

#ifdef Concurrent
            if (is:null(*dp)){
	       signal = activate((dptr)(sp - 3), NULL, (dptr)(sp - 3));
	       SYNC_CURTSTATE_CE();
	       }
	    else 
#endif					/* Concurrent */	      
            if (is:coexpr(*dp)) {
               ncp = BlkD(*dp, Coexpr);
               signal = activate((dptr)(sp - 3), ncp, (dptr)(sp - 3));
	       SYNC_CURTSTATE_CE();
	       }
	    else{
               err_msg(118, dp);
               goto efail;
               }

            EntInterp_sp;

            if (signal == A_Resume)
               goto efail_noev;
            else
               rsp -= 2;
#endif					/* CoExpr */
            break;
	    }

	 case Op_Coret: {	/* return from co-expression */

#ifndef CoExpr
            syserr("co-expression return, but co-expressions not implemented");
#else                                        /* CoExpr */
            struct b_coexpr *ncp;

            ExInterp_sp;
            ncp = popact(BlkD(k_current, Coexpr));

            ++BlkLoc(k_current)->Coexpr.size;
            co_chng(ncp, (dptr)&sp[-1], NULL, A_Coret, 1);
       	    SYNC_CURTSTATE_CE();
            EntInterp_sp;
#endif					/* CoExpr */
            break;

	    }

	 case Op_Cofail: {	/* fail from co-expression */

#ifndef CoExpr
            syserr("co-expression failure, but co-expressions not implemented");
#else                                        /* CoExpr */
            struct b_coexpr *ncp;

            ExInterp_sp;
            ncp = popact(BlkD(k_current, Coexpr));

	    /*
	     *	if this is a main co-expression failing to its parent
	     *  (monitoring) program, generate an E_Exit event.
	     */
#ifdef MultiProgram
            if (curpstate->parent == ncp->program) {
	       EVVal(0, E_Exit);
	       }
#endif					/* MultiProgram */

            co_chng(ncp, NULL, NULL, A_Cofail, 1);
       	    SYNC_CURTSTATE_CE();
            EntInterp_sp;
#endif					/* CoExpr */
            break;

	    }
         case Op_Quit:		/* quit */


	    goto interp_quit;


	 default: {
	    char buf[50];

	    sprintf(buf, "unimplemented opcode: %ld (0x%08x)\n",
               (long)lastop, (unsigned int)lastop);
	    syserr(buf);
	    }
	 }
	 continue;

C_rtn_term:
	 EntInterp_sp;

	 switch (signal) {

	    case A_Resume:
#ifdef MultiProgram
	    if (lastev == E_Function) {
	       InterpEVValD(&lastdesc, e_ffail);
	       lastev = E_Misc;
	       }
	    else if (lastev == E_Operator) {
	       InterpEVValD(&lastdesc, e_ofail);
	       lastev = E_Misc;
	       }
#endif					/* MultiProgram */
	       goto efail_noev;

	    case A_Unmark_uw:		/* unwind for unmark */
#ifdef MultiProgram
	       if (lastev == E_Function) {
		  InterpEVValD(&lastdesc, e_frem);
		  lastev = E_Misc;
		  }
	       else if (lastev == E_Operator) {
		  InterpEVValD(&lastdesc, e_orem);
		  lastev = E_Misc;
		  }
#endif					/* MultiProgram */
	       goto Unmark_uw;
#ifdef MultiProgram
	       /* unreachable, but good to silence silence compiler wwarning */
	       (void) lastdesc;  /* silence "not used" compiler warning */
#endif					/* MultiProgram */

	    case A_Lsusp_uw:		/* unwind for lsusp */
#ifdef MultiProgram
	       if (lastev == E_Function) {
		  InterpEVValD(&lastdesc, e_frem);
		  lastev = E_Misc;
		  }
	       else if (lastev == E_Operator) {
		  InterpEVValD(&lastdesc, e_orem);
		  lastev = E_Misc;
		  }
#endif					/* MultiProgram */
	       goto Lsusp_uw;

	    case A_Eret_uw:		/* unwind for eret */
#ifdef MultiProgram
	       if (lastev == E_Function) {
		  InterpEVValD(&lastdesc, e_frem);
		  lastev = E_Misc;
		  }
	       else if (lastev == E_Operator) {
		  InterpEVValD(&lastdesc, e_orem);
		  lastev = E_Misc;
		  }
#endif					/* MultiProgram */
	       goto Eret_uw;

	    case A_Pret_uw:		/* unwind for pret */
#ifdef MultiProgram
	       if (lastev == E_Function) {
		  InterpEVVal(&lastdesc, e_frem);
		  lastev = E_Misc;
		  }
	       else if (lastev == E_Operator) {
		  InterpEVVal(&lastdesc, e_orem);
		  lastev = E_Misc;
		  }
#endif					/* MultiProgram */
	       goto Pret_uw;

	    case A_Pfail_uw:		/* unwind for pfail */
#ifdef MultiProgram
	       if (lastev == E_Function) {
		  InterpEVValD(&lastdesc, e_frem);
		  lastev = E_Misc;
		  }
	       else if (lastev == E_Operator) {
		  InterpEVValD(&lastdesc, e_orem);
		  lastev = E_Misc;
		  }
#endif					/* MultiProgram */
	       goto Pfail_uw;
	    }

	 rsp = (word *)rargp + 1;	/* set rsp to result */

#ifdef MultiProgram
return_term:
         if (lastev == E_Function) {
#if e_fret
	    value_tmp = *(dptr)(rsp - 1);	/* argument */
	    Deref0(value_tmp);
	    InterpEVValD(&value_tmp, e_fret);
#endif					/* E_Fret */
	    lastev = E_Misc;
	    }
         else if (lastev == E_Operator) {
#if e_oret
	    value_tmp = *(dptr)(rsp - 1);	/* argument */
	    Deref0(value_tmp);
	    InterpEVValD(&value_tmp, e_oret);
#endif					/* E_Oret */
	    lastev = E_Misc;

	    value_tmp = nulldesc;
	    }
#endif					/* MultiProgram */

	 continue;
	 }

interp_quit:
   --ilevel;
   if (ilevel != 0)
      syserr("interp: termination with inactive generators.");

   /*NOTREACHED*/
   return 0;	/* avoid gcc warning */
   }
#enddef

#ifdef MultiProgram
/*
 * When all event codes are zero, interp_macro sets the value of the 
 * variable lastdesc but never uses it (because the invocations of
 * RealEVValD, which do use the variable, are elided by the preprocessor).
 */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-but-set-variable"
interp_macro(interp_0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
#pragma GCC diagnostic pop
interp_macro(interp_1,E_Intcall,E_Stack,E_Fsusp,E_Osusp,E_Bsusp,E_Ocall,E_Ofail,E_Tick, E_Line,E_Loc,E_Opcode,E_Fcall,E_Prem,E_Erem,E_Intret,E_Psusp,E_Ssusp,E_Pret,E_Efail, E_Sresum,E_Fresum,E_Oresum,E_Eresum,E_Presum,E_Pfail,E_Ffail,E_Frem,E_Orem,E_Fret, E_Oret,E_Literal,E_Operand,E_Syntax,E_Cstack)
#else					/* MultiProgram */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-but-set-variable"
interp_macro(interp,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
#pragma GCC diagnostic pop
#endif					/* MultiProgram */


#ifdef StackPic
/*
 * The following code is operating-system dependent [@interp.04].
 *  Diagnostic stack pictures for debugging/monitoring.
 */

#if PORT
Deliberate Syntax Error
#endif					/* PORT */

#if MACINTOSH || MVS || VM || VMS
   /* not included */
#endif					/* MACINTOSH || ... */

#if DEBUG_INTERP
void stkdump(op)
   int op;
   {
   word *stk;
   word *i;
   CURTSTATE_AND_CE();
   stk = (word *)BlkLoc(k_current);
   stk += Wsizeof(struct b_coexpr);
   fprintf(stderr,">  stack:  %.8x\n", (word)stk);
   fprintf(stderr,">  sp:     %.8x\n", (word)sp);
   fprintf(stderr,">  pfp:    %.8x\n", (word)pfp);
   fprintf(stderr,">  efp:    %.8x\n", (word)efp);
   fprintf(stderr,">  gfp:    %.8x\n", (word)gfp);
   fprintf(stderr,">  ipc:    %.8x\n", (word)ipc.op);
   fprintf(stderr,">  argp:   %.8x\n", (word)glbl_argp);
   fprintf(stderr,">  ilevel: %.8x\n", (word)ilevel);
   fprintf(stderr,">  op:     %d\n",    (int)op);
   for (i = stk; i <= (word *)sp; i++)
      fprintf(stderr,"> %.8x\n",(word)*i);
   fprintf(stderr,"> ----------\n");
   fflush(stderr);
   }
#endif					/* DEBUG_INTERP */

#if MSDOS
#if MICROSOFT || TURBO
void stkdump(op)
   int op;
   {
   word far *stk;
   word far *i;
   CURTSTATE_AND_CE();
   stk = (word far *)BlkLoc(k_current);
   stk += Wsizeof(struct b_coexpr);
   fprintf(stderr,">  stack:  %08lx\n", (word)stk);
   fprintf(stderr,">  sp:     %08lx\n", (word)sp);
   fprintf(stderr,">  pfp:    %08lx\n", (word)pfp);
   fprintf(stderr,">  efp:    %08lx\n", (word)efp);
   fprintf(stderr,">  gfp:    %08lx\n", (word)gfp);
   fprintf(stderr,">  ipc:    %08lx\n", (word)ipc.op);
   fprintf(stderr,">  argp:   %08lx\n", (word)glbl_argp);
   fprintf(stderr,">  ilevel: %08lx\n", (word)ilevel);
   fprintf(stderr,">  op:     %d\n",    (int)op);
   for (i = stk; i <= (word far *)sp; i++)
      fprintf(stderr,"> %08lx\n",(word)*i);
   fprintf(stderr,"> ----------\n");
   fflush(stderr);
   }
#endif					/* MICROSOFT || TURBO ... */
#endif					/* MSDOS */

#if UNIX || VMS
void stkdump(op)
   int op;
   {
   word *i;
   CURTSTATE_AND_CE();
   fprintf(stderr,"\001stack: %lx\n",(long)(stack + Wsizeof(struct b_coexpr)));
   fprintf(stderr,"\001pfp: %lx\n",(long)pfp);
   fprintf(stderr,"\001efp: %lx\n",(long)efp);
   fprintf(stderr,"\001gfp: %lx\n",(long)gfp);
   fprintf(stderr,"\001ipc: %lx\n",(long)ipc.op);
   fprintf(stderr,"\001argp: %lx\n",(long)glbl_argp);
   fprintf(stderr,"\001ilevel: %lx\n",(long)ilevel);
   fprintf(stderr,"\001op: \%d\n",(int)op);
   for (i = stack + Wsizeof(struct b_coexpr); i <= sp; i++)
      fprintf(stderr,"\001%lx\n",*i);
   fprintf(stderr,"\001----------\n");
   fflush(stderr);
   }
#endif					/* UNIX || VMS */

/*
 * End of operating-system specific code.
 */
#endif					/* StackPic */

#if E_Prem || E_Erem
/*
 * vanq_proc - monitor the removal of suspended operations from within
 *   a procedure.
 */
static void vanq_proc(efp_v, gfp_v)
struct ef_marker *efp_v;
struct gf_marker *gfp_v;
   {

   if (is:null(curpstate->eventmask))
      return;

   /*
    * Go through all the bounded expression of the procedure.
    */
   while ((efp_v = vanq_bound(efp_v, gfp_v)) != NULL) {
      gfp_v = efp_v->ef_gfp;
      efp_v = efp_v->ef_efp;
      }
   }

/*
 * vanq_bound - monitor the removal of suspended operations from
 *   the current bounded expression and return the expression frame
 *   pointer for the bounded expression.
 */
static struct ef_marker *vanq_bound(efp_v, gfp_v)
struct ef_marker *efp_v;
struct gf_marker *gfp_v;
   {

   if (is:null(curpstate->eventmask))
      return efp_v;

   while (gfp_v != 0) {		/* note removal of suspended operations */
      switch ((int)gfp_v->gf_gentype) {
         case G_Psusp:
            EVValD(gfp_v->gf_argp, E_Prem);
            break;
	 /* G_Fsusp and G_Osusp handled in-line during unwinding */
         case G_Esusp:
            EVVal((word)0, E_Erem);
            break;
         }

      if (((int)gfp_v->gf_gentype) == G_Psusp) {
         vanq_proc(gfp_v->gf_efp, gfp_v->gf_gfp);
         efp_v = gfp_v->gf_pfp->pf_efp;           /* efp before the call */
         gfp_v = gfp_v->gf_pfp->pf_gfp;           /* gfp before the call */
         }
      else {
         efp_v = gfp_v->gf_efp;
         gfp_v = gfp_v->gf_gfp;
         }
      }

   return efp_v;
   }
#endif					/* E_Prem || E_Erem */

#ifdef MultiProgram
/*
 * activate some other co-expression from an arbitrary point in
 * the interpreter.
 */
int mt_activate(tvalp,rslt,ncp)
dptr tvalp, rslt;
register struct b_coexpr *ncp;
{
   register struct b_coexpr *ccp;
   int first, rv;
   dptr savedtvalloc = NULL;
   CURTSTATE();

   ccp = BlkD(k_current, Coexpr);

   /*
    * Set activator in new co-expression.
    */
   if (ncp->es_actstk == NULL) {
      Protect(ncp->es_actstk = alcactiv(), { err_msg(0, NULL); exit(1); });
      /*
       * If no one ever explicitly activates this co-expression, fail to
       * the implicit activator.
       */
      ncp->es_actstk->arec[0].activator = ccp;
      first = 0;
      }
   else
      first = 1;

   if (ccp->tvalloc) {
     if (InRange(blkbase,ccp->tvalloc,blkfree)) {
       fprintf(stderr,
	       "Multiprogram garbage collection disaster in mt_activate()!\n");
       fflush(stderr);
       exit(1);
     }
     savedtvalloc = ccp->tvalloc;
   }

   ccp->program->Kywd_time_out = millisec();

   rv = co_chng(ncp, tvalp, rslt, A_MTEvent, first);

   ccp->program->Kywd_time_elsewhere +=
      millisec() - ccp->program->Kywd_time_out;

   if ((savedtvalloc != NULL) && (savedtvalloc != ccp->tvalloc)) {
#if 0
      fprintf(stderr,"averted co-expression disaster in activate\n");
#endif
      ccp->tvalloc = savedtvalloc;
      }

   /*
    * flush any accumulated ticks
    */
#if HAVE_PROFIL && E_Tick
   if (ticker.l[0] + ticker.l[1] + ticker.l[2] + ticker.l[3] +
       ticker.l[4] + ticker.l[5] + ticker.l[6] + ticker.l[7] != oldtick) {
      word sum /*, nticks */;

      oldtick = ticker.l[0] + ticker.l[1] + ticker.l[2] + ticker.l[3] +
       ticker.l[4] + ticker.l[5] + ticker.l[6] + ticker.l[7];
      sum = ticker.s[0] + ticker.s[1] + ticker.s[2] + ticker.s[3] +
	 ticker.s[4] + ticker.s[5] + ticker.s[6] + ticker.s[7] +
	    ticker.s[8] + ticker.s[9] + ticker.s[10] + ticker.s[11] +
	       ticker.s[12] + ticker.s[13] + ticker.s[14] + ticker.s[15];
      /* nticks = sum - oldsum; */
      oldsum = sum;
      }
#endif					/* HAVE_PROFIL && E_Tick */

   return rv;
}


/*
 * activate the "&parent" co-expression from anywhere, if there is one
 */
void actparent(event)
int event;
   {
   struct progstate *parent = curpstate->parent;

   curpstate->eventcount.vword.integr++;
   StrLen(parent->eventcode) = 1;
   StrLoc(parent->eventcode) = (char *)&allchars[FromAscii(event)&0xFF];
   mt_activate(&(parent->eventcode), NULL,
	       (struct b_coexpr *)curpstate->parent->Mainhead);
   }
#endif					/* MultiProgram */
#endif					/* !COMPILER */
