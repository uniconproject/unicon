/*
 * File: rcoexpr.r -- co_init, co_chng
 */


/*
 * Function to call after switching stacks. If NULL, call interp().
 */
static continuation coexpr_fnc;


/*
 * co_init - use the contents of the refresh block to initialize the
 *  co-expression.
 */
void co_init(sblkp)
struct b_coexpr *sblkp;
{
#ifndef CoExpr
   syserr("co_init() called, but co-expressions not implemented");
#else					/* CoExpr */
   register word *newsp;
   register dptr dp, dsp;
   int frame_size;
   word stack_strt;
   int na, nl, nt, i;
   /*
    * Get pointer to refresh block.
    */
   struct b_refresh *rblkp = (struct b_refresh *)BlkLoc(sblkp->freshblk);

#if COMPILER
   na = rblkp->nargs;                /* number of arguments */
   nl = rblkp->nlocals;              /* number of locals */
   nt = rblkp->ntemps;               /* number of temporaries */

   /*
    * The C stack must be aligned on the correct boundary. For up-growing
    *  stacks, the C stack starts after the initial procedure frame of
    *  the co-expression block. For down-growing stacks, the C stack starts
    *  at the last word of the co-expression block.
    */
#ifdef UpStack
   frame_size = sizeof(struct p_frame) + sizeof(struct descrip) * (nl + na +
      nt - 1) + rblkp->wrk_size;
   stack_strt = (word)((char *)&sblkp->pf + frame_size + StackAlign*WordSize);
#else					/* UpStack */
   stack_strt = (word)((char *)sblkp + stksize - WordSize);
#endif					/* UpStack */
   sblkp->cstate[0] = stack_strt & ~(WordSize * StackAlign - 1);

   sblkp->es_argp = &sblkp->pf.t.d[nl + nt];   /* args follow temporaries */

#else					/* COMPILER */

   na = (rblkp->pfmkr).pf_nargs + 1; /* number of arguments */
   nl = (int)rblkp->numlocals;       /* number of locals */

   /*
    * The interpreter stack starts at word after co-expression stack block.
    *  C stack starts at end of stack region on machines with down-growing C
    *  stacks and somewhere in the middle of the region.
    *
    * The C stack is aligned on a doubleword boundary.	For up-growing
    *  stacks, the C stack starts in the middle of the stack portion
    *  of the static block.  For down-growing stacks, the C stack starts
    *  at the last word of the static block.
    */

   newsp = (word *)((char *)sblkp + sizeof(struct b_coexpr));

#ifdef UpStack
   sblkp->cstate[0] =
      ((word)((char *)sblkp + (stksize - sizeof(*sblkp))/2)
         &~((word)WordSize*StackAlign-1));
#else					/* UpStack */
   sblkp->cstate[0] =
	((word)((char *)sblkp + stksize - WordSize)
           &~((word)WordSize*StackAlign-1));
#endif					/* UpStack */

   sblkp->es_argp = (dptr)newsp;  /* args are first thing on stack */
#ifdef StackCheck
   sblkp->es_stack = newsp;
   sblkp->es_stackend = (word *)
      ((word)((char *)sblkp + (stksize - sizeof(*sblkp))/2)
         &~((word)WordSize*StackAlign-1));
#endif					/* StackCheck */
#endif					/* COMPILER */

   /*
    * Copy arguments onto new stack.
    */
   dsp = sblkp->es_argp;
   dp = rblkp->elems;
   for (i = 1; i <=  na; i++)
      *dsp++ = *dp++;

   /*
    * Set up state variables and initialize procedure frame.
    */
#if COMPILER
   sblkp->es_pfp = &sblkp->pf;
#ifdef Concurrent
         pthread_mutex_lock(&mutex_tend);
#endif					/* Concurrent */
   sblkp->es_tend = &sblkp->pf.t;
#ifdef Concurrent
         pthread_mutex_unlock(&mutex_tend);
#endif					/* Concurrent */
   sblkp->pf.old_pfp = NULL;
   sblkp->pf.rslt = NULL;
   sblkp->pf.succ_cont = NULL;
   sblkp->pf.t.previous = NULL;
   sblkp->pf.t.num = nl + na + nt;
   sblkp->es_actstk = NULL;
#else					/* COMPILER */
   *((struct pf_marker *)dsp) = rblkp->pfmkr;
   sblkp->es_pfp = (struct pf_marker *)dsp;
#ifdef Concurrent
         pthread_mutex_lock(&mutex_tend);
#endif					/* Concurrent */
   sblkp->es_tend = NULL;
#ifdef Concurrent
         pthread_mutex_unlock(&mutex_tend);
#endif					/* Concurrent */
   dsp = (dptr)((word *)dsp + Vwsizeof(*pfp));
   sblkp->es_ipc.opnd = rblkp->ep;
   sblkp->es_gfp = 0;
   sblkp->es_efp = 0;
   sblkp->es_ilevel = 0;
#endif					/* COMPILER */
   sblkp->tvalloc = NULL;

   /*
    * Copy locals into the co-expression.
    */
#if COMPILER
   dsp = sblkp->pf.t.d;
#endif					/* COMPILER */
   for (i = 1; i <= nl; i++)
      *dsp++ = *dp++;

#if COMPILER
   /*
    * Initialize temporary variables.
    */
   for (i = 1; i <= nt; i++)
      *dsp++ = nulldesc;
#else					/* COMPILER */
   /*
    * Push two null descriptors on the stack.
    */
   *dsp++ = nulldesc;
   *dsp++ = nulldesc;

   sblkp->es_sp = (word *)dsp - 1;
#endif					/* COMPILER */

#endif					/* CoExpr */
   }

/*
 * co_chng - high-level co-expression context switch.
 */
int co_chng(ncp, valloc, rsltloc, swtch_typ, first)
struct b_coexpr *ncp;
struct descrip *valloc; /* location of value being transmitted */
struct descrip *rsltloc;/* location to put result */
int swtch_typ;          /* A_Coact, A_Coret, A_Cofail, or A_MTEvent */
int first;
{
#ifndef CoExpr
   syserr("co_chng() called, but co-expressions not implemented");
#else        				/* CoExpr */
   static int coexp_act;     /* used to pass signal across activations */
                             /* back to whomever activates, if they care */

   register struct b_coexpr *ccp = (struct b_coexpr *)BlkLoc(k_current);

#if !COMPILER
#ifdef MultiThread
   switch(swtch_typ) {
      /*
       * A_MTEvent does not generate an event.
       */
      case A_MTEvent:
	 break;
      case A_Coact:
         EVValX(ncp,E_Coact);
	 if (!is:null(curpstate->eventmask) && ncp->program == curpstate) {
	    curpstate->parent->eventsource.dword = D_Coexpr;
	    BlkLoc(curpstate->parent->eventsource) = (union block *)ncp;
	    }
	 break;
      case A_Coret:
         EVValX(ncp,E_Coret);
	 if (!is:null(curpstate->eventmask) && ncp->program == curpstate) {
	    curpstate->parent->eventsource.dword = D_Coexpr;
	    BlkLoc(curpstate->parent->eventsource) = (union block *)ncp;
	    }
	 break;
      case A_Cofail:
         EVValX(ncp,E_Cofail);
	 if (!is:null(curpstate->eventmask) && ncp->program == curpstate) {
	    curpstate->parent->eventsource.dword = D_Coexpr;
	    BlkLoc(curpstate->parent->eventsource) = (union block *)ncp;
	    }
	 break;
      }
#endif        				/* MultiThread */
#endif					/* COMPILER */

   /*
    * Determine if we need to transmit a value.
    */
   if (valloc != NULL) {

#if !COMPILER
      /*
       * Determine if we need to dereference the transmitted value. 
       */
      if (Var(*valloc))
         retderef(valloc, (word *)glbl_argp, sp);
#endif					/* COMPILER */

      if (ncp->tvalloc != NULL)
         *ncp->tvalloc = *valloc;
      }
   ncp->tvalloc = NULL;
   ccp->tvalloc = rsltloc;

   /*
    * Save state of current co-expression.
    */
   ccp->es_pfp = pfp;
   ccp->es_argp = glbl_argp;
#ifdef Concurrent
         pthread_mutex_lock(&mutex_tend);
#endif					/* Concurrent */
   ccp->es_tend = tend;
#ifdef Concurrent
         pthread_mutex_unlock(&mutex_tend);
#endif					/* Concurrent */
#if !COMPILER
   ccp->es_efp = efp;
   ccp->es_gfp = gfp;
   ccp->es_ipc = ipc;
   ccp->es_oldipc = oldipc; /* To be used when the found line is zero*/
   ccp->es_sp = sp;
   ccp->es_ilevel = ilevel;
#ifdef EventMon
   ccp->actv_count += 1;
#endif					/* EventMon */
#endif					/* COMPILER */

#if COMPILER
   if (line_info) {
      ccp->file_name = file_name;
      ccp->line_num = line_num;
      file_name = ncp->file_name;
      line_num = ncp->line_num;
      }
#endif					/* COMPILER */

#if COMPILER
   if (debug_info)
#endif					/* COMPILER */
      if (k_trace)
#ifdef MultiThread
	 if (swtch_typ != A_MTEvent)
#endif					/* MultiThread */
         cotrace(ccp, ncp, swtch_typ, valloc);

#ifndef Concurrent
   /*
    * Establish state for new co-expression.
    */
   pfp = ncp->es_pfp;
   tend = ncp->es_tend;

#if !COMPILER
   efp = ncp->es_efp;
   gfp = ncp->es_gfp;
   ipc = ncp->es_ipc;
   sp = ncp->es_sp;
   ilevel = (int)ncp->es_ilevel;
#endif					/* COMPILER */

#if !COMPILER
#ifdef MultiThread
   /*
    * Enter the program state of the co-expression being activated
    */
   ENTERPSTATE(ncp->program);
#endif        				/* MultiThread */
#endif					/* COMPILER */

   glbl_argp = ncp->es_argp;
   BlkLoc(k_current) = (union block *)ncp;

#if COMPILER
   coexpr_fnc = ncp->fnc;
#endif					/* COMPILER */

#endif					/* ! Concurrent */

#ifdef MultiThread
   /*
    * From here on out, A_MTEvent looks like a A_Coact.
    */
   if (swtch_typ == A_MTEvent)
      swtch_typ = A_Coact;
#endif					/* MultiThread */

   coexp_act = swtch_typ;

#ifdef PthreadCoswitch
#ifdef Concurrent
   pthreadcoswitch(ccp->cstate, ncp->cstate,first, ccp->status, ncp->status );
#else					/* Concurrent */
   pthreadcoswitch(ccp->cstate, ncp->cstate,first);
#endif					/* Concurrent */
#else					/* PthreadCoswitch */
   coswitch(ccp->cstate, ncp->cstate,first);
#endif					/* PthreadCoswitch */

   return coexp_act;
#endif        				/* CoExpr */
   }

#ifdef CoExpr
/*
 * new_context - determine what function to call to execute the new
 *  co-expression; this completes the context switch.
 */
void new_context(fsig,cargp)
int fsig;
dptr cargp;
   {
   continuation cf;
   if (coexpr_fnc != NULL) {
      cf = coexpr_fnc;
      coexpr_fnc = NULL;
      (*cf)();
      }
   else
#if COMPILER
      syserr("new_context() called with no coexpr_fnc defined");
#else					/* COMPILER */
      interp(fsig, cargp);
#endif					/* COMPILER */
   }
#else					/* CoExpr */
/* dummy new_context if co-expressions aren't supported */
void new_context(fsig,cargp)
int fsig;
dptr cargp;
   {
   syserr("new_context() called, but co-expressions not implemented");
   }
#endif					/* CoExpr */


#ifdef PthreadCoswitch
/*
 * pthreads.c -- Icon context switch code using POSIX threads and semaphores
 *
 * This code implements co-expression context switching on any system that
 * provides POSIX threads and semaphores.  It requires Icon 9.4.1 or later
 * built with "#define CoClean" in order to free threads and semaphores when
 * co-expressions are collected.  It is typically much slower when called
 * than platform-specific custom code, but of course it is much more portable,
 * and it is typically used infrequently.
 *
 * Unnamed semaphores are used unless NamedSemaphores is defined.
 * (This is for Mac OS 10.3 which does not have unnamed semaphores.)
 */

static int pco_inited = 0;		/* has first-time initialization been done? */


/*
 * coswitch(old, new, first) -- switch contexts.
 */

#ifdef Concurrent
int pthreadcoswitch(void *o, void *n, int first, word ostat, word nstat)
#else
int pthreadcoswitch(void *o, void *n, int first)
#endif					/* Concurrent */
{


   cstate ocs = o;			/* old cstate pointer */
   cstate ncs = n;			/* new cstate pointer */
   context *old, *new;			/* old and new context pointers */

   if (pco_inited)				/* if not first call */
      old = ocs[1];			/* load current context pointer */
   else {
      /*
       * This is the first coswitch() call.
       * Initialize the context struct for &main.
       */
      old = ocs[1];
      old->thread = pthread_self();
      old->alive = 1;
      pco_inited = 1;
      }

   if (first != 0)			/* if not first call for this cstate */
      new = ncs[1];			/* load new context pointer */
   else {
      /*
       * This is a newly allocated cstate array, allocated and initialized
       * over in alccoexp().  Create a thread for it and mark it alive.
       */
      new = ncs[1];
      if (pthread_create(&new->thread, NULL, nctramp, new) != 0) 
         syserr("cannot create thread");
      new->alive = 1;
      }
   
   sem_post(new->semp);			/* unblock the new thread */

#ifdef AAAConcurrent
   if (nstat & Ts_Sync )
#endif					/* Concurrent */
      sem_wait(old->semp);		/* block this thread */

   if (!old->alive
#ifdef AAAConcurrent
       || (ostat & Ts_Async)
#endif					/* Concurrent */
       ) {
      pthread_exit(NULL);		/* if unblocked because unwanted */
      }
   return 0;				/* else return to continue running */
   }

/*
 * coclean(old) -- clean up co-expression state before freeing.
 */
void coclean(void *o) {
   cstate ocs = o;			/* old cstate pointer */
   struct context *old = ocs[1];	/* old context pointer */
   if (old == NULL)			/* if never initialized, do nothing */
      return;
   old->alive = 0;			/* signal thread to exit */
   sem_post(old->semp);			/* unblock it */
   pthread_join(old->thread, NULL);	/* wait for thread to exit */
   #ifdef NamedSemaphores
      sem_close(old->semp);		/* close associated semaphore */
   #else
      sem_destroy(old->semp);		/* destroy associated semaphore */
   #endif
   free(old);				/* free context block */
   }

/*
 * makesem(ctx) -- initialize semaphore in context struct.
 */
void makesem(struct context *ctx) {
   #ifdef NamedSemaphores		/* if cannot use unnamed semaphores */
      char name[50];
      sprintf(name, "i%ld.sem", (long)getpid());
      ctx->semp = sem_open(name, O_CREAT, S_IRUSR | S_IWUSR, 0);
      if (ctx->semp == (sem_t *)SEM_FAILED)
         syserr("cannot create semaphore");
      sem_unlink(name);
   #else				/* NamedSemaphores */
      if (sem_init(&ctx->sema, 0, 0) == -1)
         syserr("cannot init semaphore");
      ctx->semp = &ctx->sema;
   #endif				/* NamedSemaphores */
   }

/*
 * nctramp() -- trampoline for calling new_context(0,0).
 */
void *nctramp(void *arg)
{
   struct context *new = arg;		/* new context pointer */
   struct b_coexpr *ce;
#ifdef Concurrent
   rootpstate.tstate = &roottstate;
   curtstate = &roottstate;
   init_threadstate(curtstate);
   ce = new->c;
   if (ce->title != T_Coexpr) {
      fprintf(stderr, "warning ce title is %d\n", ce->title);
      }
   pfp = ce->es_pfp;
   efp = ce->es_efp;
   gfp = ce->es_gfp;
   tend = ce->es_tend;
   ipc = ce->es_ipc;
   ilevel = ce->es_ilevel;
   sp = ce->es_sp;
   stack = ce->es_stack;
   stackend = ce->es_stackend;
   k_current.dword = D_Coexpr;
   BlkLoc(k_current) = (union block *)ce;
#endif					/* Concurrent */
   sem_wait(new->semp);			/* wait for signal */
   new_context(0, 0);			/* call new_context; will not return */
   syserr("new_context returned to nctramp");
   return NULL;
   }
#endif					/* PthreadCoswitch */
