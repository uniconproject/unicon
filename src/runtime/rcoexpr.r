/*
 * File: rcoexpr.r -- co_init, co_chng
 */


/*
 * Function to call after switching stacks. If NULL, call interp().
 */
#if !ConcurrentCOMPILER
static continuation coexpr_fnc;
#endif                                  /* ConcurrentCOMPILER */

#ifdef Concurrent
void tlschain_add(struct threadstate *tstate, struct b_coexpr *cp);
void tlschain_remove(struct threadstate *tstate);

#define TRANSFER_KLEVEL(ncp, ccp) do {                                  \
    if (IS_TS_SYNC(ncp->status) && ncp->program == ccp->program) {      \
       if (ncp->tstate)                                                 \
          ncp->tstate->K_level = ccp->tstate->K_level;                  \
       else                                                             \
          ncp->tmplevel =  ccp->tstate->K_level;                        \
        }                                                               \
} while (0)
#else                                   /* Concurrent  */
#define TRANSFER_KLEVEL(ncp, ccp)
#endif                                  /* Concurrent  */

#ifdef PthreadCoswitch
int pthreadcoswitch(struct b_coexpr *old, struct b_coexpr *new, word ostat, word nstat);
#endif                                  /* PthreadCoswitch */

/*
 * co_init - use the contents of the refresh block to initialize the
 *  co-expression.
 */
void co_init(struct b_coexpr *sblkp)
{
#ifndef CoExpr
   syserr("co_init() called, but co-expressions not implemented");
#else                                   /* CoExpr */
   register dptr dp, dsp;
   int na, nl, i;
#if COMPILER
   int nt;
#else
   register word *newsp;
#endif                                  /* COMPILER */
   /*
    * Get pointer to refresh block.
    */
   struct b_refresh *rblkp = (struct b_refresh *)BlkLoc(sblkp->freshblk);
   CURTSTATE_AND_CE();

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
  {
   word stack_strt;
#ifdef UpStack
   int frame_size;
   frame_size = sizeof(struct p_frame) + sizeof(struct descrip) * (nl + na +
      nt - 1) + rblkp->wrk_size;
   stack_strt = (word)((char *)&sblkp->pf + frame_size + StackAlign*WordSize);
#else                                   /* UpStack */
   stack_strt = (word)((char *)sblkp + stksize - WordSize);
#endif                                  /* UpStack */
   sblkp->cstate[0] = stack_strt & ~(WordSize * StackAlign - 1);

   sblkp->es_argp = &sblkp->pf.t.d[nl + nt];   /* args follow temporaries */
   }

#else                                   /* COMPILER */

   na = (rblkp->pfmkr).pf_nargs + 1; /* number of arguments */
   nl = (int)rblkp->nlocals;         /* number of locals */

   /*
    * The interpreter stack starts at word after co-expression stack block.
    *  C stack starts at end of stack region on machines with down-growing C
    *  stacks and somewhere in the middle of the region.
    *
    * The C stack is aligned on a doubleword boundary.  For up-growing
    *  stacks, the C stack starts in the middle of the stack portion
    *  of the static block.  For down-growing stacks, the C stack starts
    *  at the last word of the static block.
    */

   newsp = (word *)((char *)sblkp + sizeof(struct b_coexpr));

#ifdef UpStack
   sblkp->cstate[0] =
      ((word)((char *)sblkp + (stksize - sizeof(*sblkp))/2)
         &~((word)WordSize*StackAlign-1));
#else                                   /* UpStack */
   sblkp->cstate[0] =
        ((word)((char *)sblkp + stksize - WordSize)
           &~((word)WordSize*StackAlign-1));
#endif                                  /* UpStack */

   sblkp->es_argp = (dptr)newsp;  /* args are first thing on stack */
#ifdef StackCheck
   sblkp->es_stack = newsp;
   sblkp->es_stackend = (word *)
      ((word)((char *)sblkp + (stksize - sizeof(*sblkp))/2)
         &~((word)WordSize*StackAlign-1));
#endif                                  /* StackCheck */
#endif                                  /* COMPILER */

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
   sblkp->es_tend = &sblkp->pf.t;
   sblkp->pf.old_pfp = NULL;
   sblkp->pf.rslt = NULL;
   sblkp->pf.succ_cont = NULL;
   sblkp->pf.t.previous = NULL;
   sblkp->pf.t.num = nl + na + nt;
   sblkp->es_actstk = NULL;
#else                                   /* COMPILER */
   *((struct pf_marker *)dsp) = rblkp->pfmkr;
   sblkp->es_pfp = (struct pf_marker *)dsp;
#ifdef PatternType
 if (!is_in_a_block_region((char *)(sblkp->es_pfp->pattern_cache)) ||
     (sblkp->es_pfp->pattern_cache->title != T_Table))
   sblkp->es_pfp->pattern_cache = NULL;
#endif                                  /* PatternType */
   sblkp->es_tend = NULL;
   dsp = (dptr)((word *)dsp + Vwsizeof(*pfp));
   sblkp->es_ipc.opnd = rblkp->ep;
   sblkp->es_gfp = 0;
   sblkp->es_efp = 0;
   sblkp->es_ilevel = 0;
#endif                                  /* COMPILER */
   sblkp->tvalloc = NULL;

   /*
    * Copy locals into the co-expression.
    */
#if COMPILER
   dsp = sblkp->pf.t.d;
#endif                                  /* COMPILER */
   for (i = 1; i <= nl; i++)
      *dsp++ = *dp++;

#if COMPILER
   /*
    * Initialize temporary variables.
    */
   for (i = 1; i <= nt; i++)
      *dsp++ = nulldesc;
#else                                   /* COMPILER */
   /*
    * Push two null descriptors on the stack.
    */
   *dsp++ = nulldesc;
   *dsp++ = nulldesc;

   sblkp->es_sp = (word *)dsp - 1;
#endif                                  /* COMPILER */

#endif                                  /* CoExpr */
   }

/*
 * co_chng - high-level co-expression context switch.
 */
int co_chng(struct b_coexpr *ncp,
            struct descrip *valloc, /* location of value being transmitted */
            struct descrip *rsltloc,/* location to put result */
            int swtch_typ,          /* A_Coact, A_Coret, A_Cofail, or A_MTEvent */
            int first)
{
#ifndef CoExpr
   syserr("co_chng() called, but co-expressions not implemented");
#else                                   /* CoExpr */

   register struct b_coexpr *ccp;
   CURTSTATE_AND_CE();


   ccp = BlkD(k_current, Coexpr);

#ifndef NativeCoswitch
   /*
    * We don't have Native co-expressions. If this is the first
    * activation for ncp create a thread for it.
    */
   if (first == 0)
      CREATE_CE_THREAD(ncp, 0, "co_chng()");
#endif                                  /* NativeCoswitch */

#if !COMPILER
#ifdef MultiProgram
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
         TRANSFER_KLEVEL(ncp, ccp);
         break;
      case A_Coret:
         EVValX(ncp,E_Coret);
         if (!is:null(curpstate->eventmask) && ncp->program == curpstate) {
            curpstate->parent->eventsource.dword = D_Coexpr;
            BlkLoc(curpstate->parent->eventsource) = (union block *)ncp;
            }
         TRANSFER_KLEVEL(ncp, ccp);
         break;
      case A_Cofail:
         EVValX(ncp,E_Cofail);
         if (!is:null(curpstate->eventmask) && ncp->program == curpstate) {
            curpstate->parent->eventsource.dword = D_Coexpr;
            BlkLoc(curpstate->parent->eventsource) = (union block *)ncp;
            }
         TRANSFER_KLEVEL(ncp, ccp);
         break;
      }
#endif                                  /* MultiProgram */
#endif                                  /* COMPILER */

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
#endif                                  /* COMPILER */

#ifdef Concurrent
      if (IS_TS_ASYNC(ccp->status) && IS_TS_ASYNC(ncp->status)){
      /*
       * The CE thread is genereating a new value, it should go into the outbox.
       * ccp is the "k_current" CE. k_current is used to avoid invalid ccp
       * because of GC.
       */
         struct b_list *hp;
         MUTEX_LOCKBLK_CONTROLLED(BlkD(ccp->outbox, List), "co_chng(): list mutex");
         hp = BlkD(BlkD(k_current,Coexpr)->outbox, List);
         if (hp->size>=hp->max){
            hp->full++;
            while (hp->size>=hp->max){
               CV_SIGNAL_EMPTYBLK(hp);
               DEC_NARTHREADS;
               CV_WAIT_FULLBLK(hp);
               INC_NARTHREADS_CONTROLLED;
               hp = BlkD(BlkD(k_current,Coexpr)->outbox, List);
               }
            hp->full--;
            }
         c_put(&(BlkD(k_current,Coexpr)->outbox), valloc);
         MUTEX_UNLOCKBLK(BlkD(BlkD(k_current,Coexpr)->outbox, List), "co_chng(): list mutex");
         CV_SIGNAL_EMPTYBLK(BlkD(BlkD(k_current,Coexpr)->outbox, List));
         if (IS_TS_THREAD(ccp->status) &&
            (swtch_typ == A_Coret || swtch_typ == A_Cofail)){
            /*
             * On return or fail, the thread is done and should exit
             */
         #ifdef CoClean
             coclean(ccp);
         #endif                         /* CoClean */
            }
         return A_Continue;
      }
      else
#endif                                  /* Concurrent */
         if (ncp->tvalloc != NULL)
            *ncp->tvalloc = *valloc;
      }

#ifdef Concurrent
   /*
    * exit if this is a returning/failing thread.
    * May want to check/fix thread  activator initialization
    * depending on desired join semantics.
    * coclean calls pthread_exit() in this case.
    */
   if (IS_TS_THREAD(ccp->status) &&
#ifdef SoftThreads
       !IS_TS_SOFTTHREAD(ccp->status) &&
#endif                                  /* SoftThreads */
      (swtch_typ == A_Coret || swtch_typ == A_Cofail)){
      #ifdef CoClean
         coclean(ccp);
      #endif                            /* CoClean */
      }
#endif                                  /* Concurrent */

   ncp->tvalloc = NULL;
   ccp->tvalloc = rsltloc;

#if COMPILER
   if (line_info) {
      ccp->file_name = file_name;
      ccp->line_num = line_num;
      file_name = ncp->file_name;
      line_num = ncp->line_num;
      }

   if (debug_info)
#endif                                  /* !COMPILER */
   {
      if (k_trace
      #ifdef MultiProgram
         &&  (swtch_typ != A_MTEvent)
      #endif                                    /* MultiProgram */
         )
         cotrace(ccp, ncp, swtch_typ, valloc);
    }

   /*
    * Save state of current co-expression.
    * & Establish state for new co-expression.
    */
   ccp->es_argp = glbl_argp;

#ifdef Concurrent

#if !COMPILER
   if (ccp->program == ncp->program)
#endif
      if (!IS_TS_ATTACHED(ncp->status)){
         curtstate->c = ncp;
         ncp->tstate = curtstate;
         }
#else                                   /* Concurrent */
   ccp->es_pfp = pfp;
   ccp->es_tend = tend;

   pfp = ncp->es_pfp;
   tend = ncp->es_tend;

#if !COMPILER
   ccp->es_efp = efp;
   ccp->es_gfp = gfp;
   ccp->es_ipc = ipc;
   ccp->es_oldipc = oldipc; /* To be used when the found line is zero*/
   ccp->es_sp = sp;
   ccp->es_ilevel = ilevel;

   efp = ncp->es_efp;
   gfp = ncp->es_gfp;
   ipc = ncp->es_ipc;
   sp = ncp->es_sp;
   ilevel = ncp->es_ilevel;
#endif                                  /* !COMPILER */
#endif                                  /* Concurrent */

#if !COMPILER
   /*
    * Enter the program state of the co-expression being activated
    */
   ENTERPSTATE(ncp->program);
#ifdef Concurrent
   /*
    * Enter the threadstate of the co-expression being activated
    */
   if (ccp->program != ncp->program) {
      curtstate = ncp->tstate;
      global_curtstate = ncp->tstate;
      }
#endif                                  /* Concurrent */
#endif                                  /* !COMPILER */



#ifdef Concurrent
#ifdef NativeCoswitch
   if (!IS_TS_ATTACHED(ncp->status)){
    glbl_argp = ncp->es_argp;
    BlkLoc(k_current) = (union block *)ncp;
   }
   #if COMPILER || ConcurrentCOMPILER
   coexpr_fnc = ncp->fnc;
   #endif                               /* COMPILER && !ConcurrentCOMPILER */
#endif                                  /* NativeCoswitch */
#else                                   /* Concurrent */
    glbl_argp = ncp->es_argp;
    BlkLoc(k_current) = (union block *)ncp;
   #if COMPILER && !ConcurrentCOMPILER
   /* ConcurrentCOMPILER moved this into the nctramp trampoline? */
   coexpr_fnc = ncp->fnc;
   #endif                               /* COMPILER && !ConcurrentCOMPILER */
#endif                                  /* Concurrent */

#ifdef MultiProgram
   /*
    * From here on out, A_MTEvent looks like a A_Coact.
    */
   if (swtch_typ == A_MTEvent)
      swtch_typ = A_Coact;
#endif                                  /* MultiProgram */

   ncp->coexp_act = swtch_typ;

   /*
    *  Transfer the Async status
    */
   SET_FLAG(ncp->status, Ts_Async);
   UNSET_FLAG(ccp->status, Ts_Async);
   /*
    * Time to switch context to the new co-expression.
    * the type of switch depends on whether the new co-expression
    * has its own attached thread or not or if it is of type
    * posix and being activated for the first time
    */

    MUTEX_LOCKBLK(ncp, "lock co-expression");

#ifdef PthreadCoswitch
   if (IS_TS_ATTACHED(ncp->status)) {
      SET_FLAG(ncp->status, Ts_Attached);
      MUTEX_UNLOCKBLK(ncp, "lock co-expression");
      pthreadcoswitch(ccp, ncp, ccp->status, ncp->status );
      }
   else
#endif                                  /* PthreadCoswitch */
   {
      /*
       * with native coswitch, the OS-level thread is reattaching
       * to the new co-expression and will be no longer attached
       * to the current co-expression
       */
      SET_FLAG(ncp->status, Ts_Attached);
      MUTEX_UNLOCKBLK(ncp, "lock co-expression");
      UNSET_FLAG(ccp->status, Ts_Attached);
#ifdef NativeCoswitch
      coswitch(ccp->cstate, ncp->cstate, first);
#else                                   /* NativeCoswitch */
      /*
       * This should never happen: if pthread and coswitch are not available
       * we would not have coexpressions in the first place,
       * but just to make it clear:
       */
       syserr("coswitch() is required but not implemented");
#endif                                  /* NativeCoswitch */
   }

   /*
    * Beware!  Native co-expression switches may not save all registers,
    * they might only preserve enough to immediate return.  Local variables
    * like ccp might not be correct after the coswitch.  We used to dodge
    * this by using the global, k_current, but that's not global anymore.
    */
#ifdef Concurrent
   curtstate =  global_curtstate ? global_curtstate :
      pthread_getspecific(tstate_key);
#endif                                  /* Concurrent */

   return BlkD(k_current,Coexpr)->coexp_act;

#endif                                  /* CoExpr */
   }

#ifdef CoExpr
/*
 * new_context - determine what function to call to execute the new
 *  co-expression; this completes the context switch.
 */
void new_context(int fsig, dptr cargp)
   {
   continuation cf;
   CURTSTATVAR();

   //SYNC_GLOBAL_CURTSTATE();

   if (coexpr_fnc != NULL) {
      cf = coexpr_fnc;
      coexpr_fnc = NULL;
      (*cf)();
      }
   else
#if COMPILER
      syserr("new_context() called with no coexpr_fnc defined");
#else                                   /* COMPILER */
#ifdef TSTATARG
      interp(fsig, cargp, CURTSTATARG);
#else                                    /* TSTATARG */
      interp(fsig, cargp);
#endif                                   /* TSTATARG */
#endif                                  /* COMPILER */
   }
#else                                   /* CoExpr */
/* dummy new_context if co-expressions aren't supported */
void new_context(fsig,cargp)
int fsig;
dptr cargp;
   {
   syserr("new_context() called, but co-expressions not implemented");
   }
#endif                                  /* CoExpr */


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
 * This is systems that do not have unnamed semaphores such as Mac OS.
 */

#if 0
static int pco_inited = 0;              /* has first-time initialization been done? */
#endif

/*
 * coswitch(old, new, first) -- switch contexts.
 */

int pthreadcoswitch(struct b_coexpr *old, struct b_coexpr *new, word ostat, word nstat)
{
   sem_post(new->semp);                 /* unblock the new thread */
   SEM_WAIT(old->semp);                 /* block this thread */

   if (old->alive<1) {
      pthread_exit(NULL);               /* if unblocked because unwanted */
      }

   //SYNC_GLOBAL_CURTSTATE();

   return 0;                            /* else return to continue running */
   }

/*
 * coclean(old) -- clean up co-expression state before freeing.
 */
void coclean(struct b_coexpr *cp) {
  struct region *strregion=NULL, *blkregion=NULL;

#ifdef Concurrent
  if (cp->tstate){
    strregion = cp->tstate->Curstring;
    blkregion = cp->tstate->Curblock;
  }
#endif                  /* Concurrent */

  if (!IS_TS_THREAD(cp->status) || cp->alive==-1){
    CURTSTATE();

#ifdef Concurrent
      if (cp == curtstate->c) {
         /*
         * If the thread is cleaning itself, exit, what about tls chain?
         */
         cp->alive = -1;         /* signal thread to exit */
         cp->have_thread = 0;
   #ifndef NO_COEXPR_SEMAPHORE_FIX
         if (cp->semp) {SEM_CLOSE(cp->semp); cp->semp = NULL;}
   #endif                  /* NO_COEXPR_SEMAPHORE_FIX */
         pthread_exit(0);
      } else if (cp->id == 1 && cp->id == curtstate->c->id) {
         /* FIXME: Main thread, should just return? */
         return;
      }
#endif                  /* Concurrent */

    cp->alive = -1;         /* signal thread to exit */
    if (cp->have_thread){
      sem_post(cp->semp);       /* unblock it */
      THREAD_JOIN(cp->thread, NULL);    /* wait for thread to exit */
      cp->alive = -2;           /* mark it as joined */
    }
    if (!IS_TS_THREAD(cp->status)) {
#ifndef NO_COEXPR_SEMAPHORE_FIX
      if (cp->semp) {SEM_CLOSE(cp->semp); cp->semp = NULL;}
#endif                  /* NO_COEXPR_SEMAPHORE_FIX */
      return;
    }

  }
  else if (cp->alive==1) { /* the current thread is done, called this to exit */
    /* give up the heaps owned by the thread */
#ifdef Concurrent
    if (blkregion){
      MUTEX_LOCKID_CONTROLLED(MTX_PUBLICBLKHEAP);
      swap2publicheap(blkregion, NULL,  &public_blockregion);
      MUTEX_UNLOCKID(MTX_PUBLICBLKHEAP);

      MUTEX_LOCKID_CONTROLLED(MTX_PUBLICSTRHEAP);
      swap2publicheap(strregion, NULL,  &public_stringregion);
      MUTEX_UNLOCKID(MTX_PUBLICSTRHEAP);
    }
#endif                  /* Concurrent */
    cp->alive = -8;
    CV_SIGNAL_EMPTYBLK(BlkD(cp->outbox, List));
    CV_SIGNAL_FULLBLK(BlkD(cp->inbox, List));

    DEC_NARTHREADS;
    cp->alive = -1;
#ifndef NO_COEXPR_SEMAPHORE_FIX
    if (cp->semp) {SEM_CLOSE(cp->semp); cp->semp = NULL;}
#endif                  /* NO_COEXPR_SEMAPHORE_FIX */
    pthread_exit(NULL);
  }


#ifndef NO_COEXPR_SEMAPHORE_FIX
  if (cp->semp) {
    SEM_CLOSE(cp->semp);    /* close/destroy associated semaphore */
    cp->semp = NULL;
  }
#else
  SEM_CLOSE(cp->semp);    /* close/destroy associated semaphore */
#endif                  /* NO_COEXPR_SEMAPHORE_FIX */
#ifdef Concurrent
  /*
   * Give up the heaps owned by the old thread,
   * only GC thread is running, no need to lock
   */
  if (CHECK_FLAG(cp->status, Ts_Posix) && blkregion){
    MUTEX_LOCKID_CONTROLLED(MTX_PUBLICBLKHEAP);
    swap2publicheap(blkregion, NULL,  &public_blockregion);
    MUTEX_UNLOCKID(MTX_PUBLICBLKHEAP);
    MUTEX_LOCKID_CONTROLLED(MTX_PUBLICSTRHEAP);
    swap2publicheap(strregion, NULL,  &public_stringregion);
    MUTEX_UNLOCKID(MTX_PUBLICSTRHEAP);
  }
  tlschain_remove(cp->tstate);
#endif                  /* Concurrent */

  return;
}

/*
 * makesem(cp) -- initialize semaphore in co-expression.
 */
void makesem(struct b_coexpr *cp) {
   #ifdef NamedSemaphores               /* if cannot use unnamed semaphores */
      char name[50];
      sprintf(name, "i%ld-%ld.sem", (long)getpid(), (long) cp->id);
      cp->semp = sem_open(name, O_CREAT, S_IRUSR | S_IWUSR, 0);
      if (cp->semp == (sem_t *)SEM_FAILED)
         handle_thread_error(errno, FUNC_SEM_OPEN, "make_sem():cannot create semaphore");
      sem_unlink(name);
   #else                                /* NamedSemaphores */
      if (sem_init(&cp->sema, 0, 0) == -1)
         handle_thread_error(errno, FUNC_SEM_INIT, "make_sem():cannot init semaphore");
      cp->semp = &cp->sema;
   #endif                               /* NamedSemaphores */
   }

#if defined(Concurrent) && !defined(HAVE_KEYWORD__THREAD)
pthread_key_t tstate_key;
struct threadstate * alloc_tstate()
{
   struct threadstate *ts = malloc(sizeof(struct threadstate));
   if (ts == NULL) syserr("alloc_tstate(): Out of memory");
   return ts;
}
#endif                                  /* Concurrent && !HAVE_KEYWORD__THREAD */

/*
 * nctramp() -- trampoline for calling new_context(0,0).
 */
void *nctramp(void *arg)
{
   struct b_coexpr *ce = (struct b_coexpr *) arg;
#ifdef Concurrent
/*   sigset_t mask; */

#ifndef HAVE_KEYWORD__THREAD
    struct threadstate *curtstate;
    curtstate = (ce->tstate ? ce->tstate : alloc_tstate());
    pthread_setspecific(tstate_key, (void *) curtstate);
#endif                                  /* HAVE_KEYWORD__THREAD */

  /*
   * Mask all allowed signals, the main thread takes care of them
   */

/*  sigfillset(&mask);
  pthread_sigmask(SIG_BLOCK, &mask, NULL);
*/
   curtstate->c = ce;

#if ConcurrentCOMPILER
     coexpr_fnc = ce->fnc;
#endif                                  /* ConcurrentCOMPILER */

   init_threadstate(curtstate);
   tlschain_add(curtstate, ce);
   pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, NULL);

   k_level = ce->tmplevel;
   if (ce->title != T_Coexpr) {
      fprintf(stderr, "warning ce title is %ld\n", (long)ce->title);
      }
#if 0
   pfp = ce->es_pfp;
   efp = ce->es_efp;
   gfp = ce->es_gfp;
   tend = ce->es_tend;
   ipc = ce->es_ipc;
   ilevel = ce->es_ilevel;
   sp = ce->es_sp;
#endif

#if !COMPILER
   stack = ce->es_stack;
   stackend = ce->es_stackend;
#endif                                  /* !COMPILER */
   glbl_argp = ce->es_argp;
   k_current.dword = D_Coexpr;
   BlkLoc(k_current) = (union block *)ce;

#if COMPILER
   init_threadheap(curtstate, ce->ini_blksize, ce->ini_ssize);
#else
   init_threadheap(curtstate, ce->ini_blksize, ce->ini_ssize, NULL);
#endif

#endif                                  /* Concurrent */
   SEM_WAIT(ce->semp);                  /* wait for signal */
   new_context(0, 0);                   /* call new_context; will not return */
   syserr("new_context returned to nctramp");
   return NULL;
   }
#endif                                  /* PthreadCoswitch */

#ifdef Concurrent

pthread_mutexattr_t rmtx_attr;  /* recursive mutex attr ready to be used */
pthread_t TCthread;
int thread_call;
int NARthreads;
pthread_cond_t cond_tc;

#ifndef NamedSemaphores
sem_t sem_tc;
#endif /* NamedSemaphores */

/*
 * sem_tcp points to sem_tc on non Mac systems and to the return
 * from sem_open() on Macs
 */
sem_t *sem_tcp;


pthread_cond_t **condvars;
word* condvarsmtxs;
word maxcondvars;
word ncondvars;

pthread_mutex_t **mutexes;
word maxmutexes;
word nmutexes;

void init_threads()
{
   int i;

   pthread_mutexattr_init(&rmtx_attr);
   pthread_mutexattr_settype(&rmtx_attr,PTHREAD_MUTEX_RECURSIVE);
#if !ConcurrentCOMPILER
   rootpstate.mutexid_stringtotal = MTX_STRINGTOTAL;
   rootpstate.mutexid_blocktotal = MTX_BLOCKTOTAL;
   rootpstate.mutexid_coll = MTX_COLL;
#else
   mutexid_stringtotal = MTX_STRINGTOTAL;
   mutexid_blocktotal = MTX_BLOCKTOTAL;
   mutexid_coll= MTX_COLL;
#endif                                 /* ConcurrentCOMPILER */

   CV_INIT(&cond_tc, "init_threads()");

#ifdef NamedSemaphores
   /* Mac OS X has sem_init(), so it is POSIX compliant.
    * Unfortunately, POSIX compliance does not mean it must work, just be there.
    * On OS X, sem_init() always fails, so we use named semaphores instead.
    */
   {
   char name[50];
   sprintf(name, "gc%ld.sem", (long)getpid());
   sem_tcp = sem_open(name, O_CREAT, S_IRUSR | S_IWUSR, 1);
   if (sem_tcp == (sem_t *)SEM_FAILED)
      handle_thread_error(errno, FUNC_SEM_OPEN,
                          "thread_init():cannot create GC semaphore");

   /* There's not much we can do if sem_unlink fails, so ignore return value */
   (void) sem_unlink(name);
   }
#else
   sem_tcp = &sem_tc;
   if (0 != sem_init(sem_tcp, 0, 1))
      handle_thread_error(errno, FUNC_SEM_INIT,
                          "thread_init():cannot init GC semaphore");
#endif /* NamedSemaphores */

   maxmutexes = 1024;
   mutexes=malloc(maxmutexes * sizeof(pthread_mutex_t *));
   if (mutexes==NULL) syserr("init_threads(): out of memory for mutexes!");

   ncondvars = 0;
   maxcondvars = 10*1024;
   condvars = malloc(maxcondvars * sizeof(pthread_cond_t *));
   condvarsmtxs = malloc(maxcondvars * WordSize);
   if (condvars==NULL || condvarsmtxs==NULL)
      syserr("init_threads(): out of memory for condition variables!");

   nmutexes = NUM_STATIC_MUTEXES;

   for(i=0; i<NUM_STATIC_MUTEXES-1; i++)
      MUTEX_INITID(i, NULL);

   /* recursive mutex for initial clause */
   MUTEX_INITID( MTX_INITIAL, &rmtx_attr);
}

void clean_threads()
{
   /*
    * Make sure that mutexes, thread stuff are initialized before cleaning
    * them. If not, just return; this might happen if iconx is called with
    * no args, for example.
    */

  /*
 * IMPORTANT NOTICE:
 * Disable mutex/condvars clean up for now. Leave this to the OS.
 * Some code/libraries think this should be alive, even though we
 * are doing this at exit time.
 *
 * update ON March 28, 2017: clean cond_tc/sem_tcp was commented out as well
 * destorying these while other threads still waiting on them leaves
 * the system ins a state of "limbo" causing it to hang in some cases
 */


  #if 0
   {
        int i;

   pthread_cond_destroy(&cond_tc);

   if (sem_tcp)
      SEM_CLOSE(sem_tcp);               /* close/destroy TC semaphore */

   /*  keep MTX_SEGVTRAP_N alive        */
   for(i=1; i<nmutexes; i++){
      pthread_mutex_destroy(mutexes[i]);
      free(mutexes[i]);
      }

   pthread_mutexattr_destroy(&rmtx_attr);

   for(i=0; i<ncondvars; i++){
      pthread_cond_destroy(condvars[i]);
      free(condvars[i]);
      }

   free(condvars);
   free(condvarsmtxs);
   }
#endif
}

/*
 * Function thread_control() governs when to run and when to stop threads.
 * Called by any place in the runtime system when it needs to stop all the
 * threads, notably garbage collection and runtime errors.  Not yet
 * implemented: ability to stop/resume individual threads.
 *
 * Legal values for the parameter (action) are:
 *   0==put this thread to sleep
 *   1==wakeup all
 *   2==stop all threads
 *   3==kill all threads
 */
void thread_control(int action)
{
   static int tc_queue=0;        /* how many threads are waiting for TC */
   static int action_in_progress=TC_NONE;
   // Keep track of the thread who is in control
   static word master_thread = 0;
#ifdef GC_TIMING_TUNING
/* timing for GC, for testing and performance tuning */
   struct timeval    tp;
   static word t_init=0;
   static word first_thread=0;
   static word thrd_t=0;
   static word lastgc_t=0;
   static word gc_count=-5;
   static word tot = 0;
   static word tot_lastgc=0;
   static word tot_gcwait=0;
   word tmp;
#endif

   CURTSTATE();

   switch (action){
      case TC_ANSWERCALL:{
         /*---------------------------------*/
         switch (action_in_progress){
            case TC_KILLALLTHREADS:{
               #ifdef CoClean
               coclean(BlkD(k_current, Coexpr));
               #else
               DEC_NARTHREADS;
               #endif
               pthread_exit(NULL);
               break;
               }
            default:{
               /*
                *  Check to see if it is necessary to do GC for the current thread.
                *  Hopefully we will force GC to happen if that is the case.
                */
               if ((curtblock->end - curtblock->free) / (double) curtblock->size < 0.09) {
                  if (!reserve(Blocks, curtblock->end - curtblock->free + 100))
                     fprintf(stderr, " Disaster! in thread_control. \n");
                  return;
                  }


               /* The thread that gets here should block and wait for TC to finish. */

               /*
                * Lock MUTEX_COND_TC mutex and wait on the condition variable cond_gc.
                * note that pthread_cond_wait will block the thread and will automatically
                * and atomically unlock mutex while it waits.
                */

               MUTEX_LOCKID(MTX_COND_TC);
               MUTEX_LOCKID(MTX_NARTHREADS);
               NARthreads--;
               MUTEX_UNLOCKID(MTX_NARTHREADS);
               CV_WAIT_ON_EXPR(thread_call, &cond_tc, MTX_COND_TC);
               MUTEX_UNLOCKID(MTX_COND_TC);

               /*
                * wake up call received! TC is over. increment NARthread
                * and go back to work
                */

               INC_NARTHREADS_CONTROLLED;
               return;

               } /* default */
            } /* switch (action_in_progress)  */
         break;
         /*---------------------------------*/
         }
      case TC_WAKEUPCALL:{
         if (tc_queue){  /* Other threads are waiting for TC to take control */

            /* lock MUTEX_COND_TC mutex and wait on the condition variable
             * cond_gc.
             * note that pthread_cond_wait will block the thread and will
             * automatically and atomically unlock the mutex while it is
             * blocking the thread.
             */

            MUTEX_UNLOCKID(MTX_NARTHREADS);
            MUTEX_UNLOCKID(MTX_THREADCONTROL);

            MUTEX_LOCKID(MTX_COND_TC);
            /* wake up another TCthread and go to sleep */
            sem_post(sem_tcp);

            CV_WAIT_ON_EXPR(thread_call, &cond_tc, MTX_COND_TC);

            MUTEX_UNLOCKID(MTX_COND_TC);

            /* Another TC thread just woke me up!
             * TC is over. Increment NARthreads and return.
             */
            MUTEX_LOCKID(MTX_NARTHREADS);
            NARthreads++;
            MUTEX_UNLOCKID(MTX_NARTHREADS);
            return;
            }
         /*
          * GC is over, reset GCthread and wakeup all threads.
          * reset (post) sem_gc to be ready for the next GC round
          */

         thread_call = 0;
         NARthreads++;
         sem_post(sem_tcp);
         action_in_progress = TC_NONE;
         MUTEX_UNLOCKID(MTX_NARTHREADS);
         MUTEX_UNLOCKID(MTX_THREADCONTROL);

#ifdef GC_TIMING_TUNING
/* timing for GC, for testing and performance tuning */

        gettimeofday(&tp, NULL);
        tmp =  tp.tv_sec * 1000000 + tp.tv_usec-t_init;
        if (gc_count>0){
           tot += tmp;
           printf("========total GC time (ms):%d   av=%d\n", tmp/1000,
                                    tot/1000/gc_count);
           }
        else
           printf("========total GC time (ms):%d\n", tmp/1000);

        t_init = 0;
        first_thread=0;
#endif

         master_thread = 0;

         /* broadcast a wakeup call to all threads waiting on cond_tc */
         pthread_cond_broadcast(&cond_tc);

         return;
         }
      case TC_STOPALLTHREADS:{

        /*
         * First make sure this thread is not requesting this
         * in the middle of another request made by the same thread.
         * typically this happens if something went bad like
         * a segfault in the middle of an ongoing GC.
         * If this is the case, we can safely return.
         */
        if (master_thread == curtstate->c->id)
          return;

         /*
          * If there is a pending TC request, then block/sleep.
          * Make sure we do not start a GC in the middle of starting
          * a new Async thread. Precaution to avoid problems.
          */

         MUTEX_LOCKID(MTX_NARTHREADS);
         NARthreads--;
         tc_queue++;
         MUTEX_UNLOCKID(MTX_NARTHREADS);

         /* Allow only one thread to pass at a time!! */
         SEM_WAIT(sem_tcp);

#ifdef GC_TIMING_TUNING
/* timing for GC, for testing and performance tuning */

     if (t_init==0){
        first_thread=1;
         gc_count++;

        gettimeofday(&tp, NULL);
        thrd_t = t_init = tp.tv_sec * 1000000 + tp.tv_usec;

        if (lastgc_t!=0){

           if (gc_count>0){
              tot_lastgc+=thrd_t-lastgc_t;
              printf("+++++++++++++\ntime (ms) since last GC: %d    av=%d\n***********\n",
                                  (t_init-lastgc_t)/1000, tot_lastgc/1000/gc_count);
              }
           else
              printf("+++++++++++++\ntime (ms) since last GC: %d\n***********\n",
                                  (t_init-lastgc_t)/1000);
          }

         lastgc_t=t_init;

        }
#endif

         /* If another TCthread just woke me up, ensure that he is gone to sleep already! */
         MUTEX_LOCKID(MTX_COND_TC);
         MUTEX_UNLOCKID(MTX_COND_TC);

         MUTEX_LOCKID(MTX_THREADCONTROL);

         TCthread = pthread_self();
         thread_call = 1;
         /* NARthreads should reach and stay at zero during TC*/
         while (1) {
            MUTEX_LOCKID(MTX_NARTHREADS);
            if (NARthreads  <= 0) break;  /* unlock MTX_NARTHREADS after GC*/
            MUTEX_UNLOCKID(MTX_NARTHREADS);
            usleep(50);
            }

#ifdef GC_TIMING_TUNING
/* timing for GC, for testing and performance tuning */
        gettimeofday(&tp, NULL);
        tmp = tp.tv_sec * 1000000 + tp.tv_usec;
        if (gc_count>0 && first_thread){
           tot_gcwait +=tmp-t_init;
           first_thread=0;
           printf("@@@SUSPEND TIME: time (microsec) I waited to start GC=%d     Av=%d \n",
                        tmp-thrd_t, tot_gcwait/gc_count);
           }
           else
           printf("SAME GC Cycle:time (microsec) I waited to start GC=%d\n", tmp-thrd_t);
        thrd_t = tmp;
#endif


         /*
          * Now it is safe to proceed with TC with only the current thread running
          */
         tc_queue--;
         master_thread = curtstate->c->id;
         return;
         }
      case TC_KILLALLTHREADS:{
         /* wait until only this thread is running  */
         thread_call = 1;
         action_in_progress = action;
         while (1) {
            if (NARthreads  <= 1) break;  /* unlock MTX_NARTHREADS after GC*/
            usleep(50);
            }

         /*action_in_progress = TC_NONE;*/
         master_thread = curtstate->c->id;
         return;
         }
      default:{

      }  /* switch (action) */
     }

  return;
}

#ifdef DEBUG
#if !ConcurrentCOMPILER
void howmanyblock()
{
  int i=0;
  struct region *rp;

  printf("here is what I have:\n");
  rp = curpstate->stringregion;
  while (rp){ i++;   rp = rp->Gnext; }
  rp = curpstate->stringregion->Gprev;
  while (rp){ i++;   rp = rp->Gprev; }
  printf(" Global string= %d\n", i);

  rp = curpstate->stringregion;
  i=0;
  while (rp){ i++; rp = rp->next;}
  rp = curpstate->stringregion->prev;
  while (rp){ i++;   rp = rp->prev; }

  printf(" local string= %d\n", i);

  rp = curpstate->blockregion;
  i=0;
  while (rp){i++; rp = rp->Gnext;}
  rp = curpstate->blockregion->Gprev;
  while (rp){ i++;   rp = rp->Gprev; }

  printf(" Global block= %d\n", i);

  rp = curpstate->blockregion;
  i=0;
  while (rp){i++; rp = rp->next; }
  rp = curpstate->blockregion->prev;
  while (rp){ i++;   rp = rp->prev; }

  printf(" local block= %d\n", i);
}
#endif                                /* ConcurrentCOMPILER */
#endif                                /* DEBUG */

void tlschain_add(struct threadstate *tstate, struct b_coexpr *cp)
{
/*TODO: Fixme: roottstate should be replaced with the current
 * program root tstate, ie. tstate->pstate->tstate
 * GC should know about this change as well
 */
   MUTEX_LOCKID(MTX_TLS_CHAIN);
   tstate->prev = roottstate.prev;
   tstate->next = NULL;
   roottstate.prev->next = tstate;
   roottstate.prev = tstate;
   if (cp){
      cp->tstate = tstate;
      tstate->c = cp;
      }
   else
      tstate->c = NULL;

   MUTEX_UNLOCKID(MTX_TLS_CHAIN);
}

void tlschain_remove(struct threadstate *tstate)
{
   /*
    * This function assumes that MTX_TLS_CHAIN is locked/unlocked
    * if needed. GCthread doesn't need to lock for example.
    */

   if (!tstate || !tstate->prev) return;

   tstate->prev->next = tstate->next;
   if (tstate->next)
      tstate->next->prev = tstate->prev;
#if ConcurrentCOMPILER
   /* CurrentCOMPILER has tstate but no pstate */
   curstring->size += tstate->stringtotal;
   curblock->size += tstate->blocktotal;
#else                                   /* ConcurrentCOMPILER */
   rootpstate.stringtotal += tstate->stringtotal;
   rootpstate.blocktotal += tstate->blocktotal;
#endif                                  /* ConcurrentCOMPILER */
   if (tstate->c && tstate->c->isProghead) return;

   free(tstate);
}

/*
 * reuse_region - search region chain for a region having at least nbytes available
 * updated Mar 8 2017: Relax the requirments to only require the region size
 *                     to be >= nbytes but not necessarily nbytes/4 >= freebytes.
 *                     The rational is that some of that memory could be reclaimed
 *                     after doing a garbage collection.
 */
static struct region *reuse_region(word nbytes, int region)
{
  struct region *curr, **pubregion, *pick=NULL;
  word freebytes = nbytes / 4;
  int mtx_id;

  if (region == Strings){
    mtx_id = MTX_PUBLICSTRHEAP;
    MUTEX_LOCKID_CONTROLLED(mtx_id);
    pubregion = &public_stringregion;
  }
  else{
    mtx_id = MTX_PUBLICBLKHEAP;
    MUTEX_LOCKID_CONTROLLED(mtx_id);
    pubregion = &public_blockregion;
  }

  for (curr = *pubregion; curr; curr = curr->Tnext) {
    if (curr->size >= nbytes) {
      // find a region that is big enough
      if (!pick)
        pick = curr;
      if (DiffPtrs(curr->end, curr->free) >= freebytes) {
        // if the region has "enough" free memory just take it
        // and end the search
        pick = curr;
        break;
        }
      else if (DiffPtrs(pick->end, pick->free) < DiffPtrs(curr->end, curr->free))
        // if this region has more free memory, switch to it
        pick = curr;
      }
    }

  if (pick){
    if (pick->Tprev)
      pick->Tprev->Tnext = pick->Tnext;
    else
      *pubregion = pick->Tnext;

    if (pick->Tnext)
      pick->Tnext->Tprev = pick->Tprev;

    pick->Tnext= NULL;
    pick->Tprev = NULL;
  }

  MUTEX_UNLOCKID(mtx_id);
  return pick;
}

/*
 * Initialize separate heaps for (concurrent) threads.
 * At present, PthreadCoswitch probably uses this for Pthread coexpressions.
 *
 * There are now two cases to consider: threadheap for a new thread in the
 * current program, and threadheap for a newly loaded program.  Called from
 * nctramp() you are a new thread in the current program.  Called from
 * initprogram() in init.r, you are a newly loaded program (newp).
 *
 *
 */
#if COMPILER
void init_threadheap(struct threadstate *ts, word blksiz, word strsiz)
#else
void init_threadheap(struct threadstate *ts, word blksiz, word strsiz,
                     struct progstate *newp)
#endif
{
   struct region *rp;

#if !COMPILER
   if (newp == NULL) newp = curpstate;
#endif
   /*
    *  new string and block region should be allocated.
    */

   if (strsiz <  MinStrSpace)
      strsiz = MinStrSpace;
   if (blksiz <  MinAbrSize)
      blksiz = MinAbrSize;

   if((rp = reuse_region(strsiz, Strings)) != 0){
      ts->Curstring =  curstring = rp;
      }
   else if ((rp = newregion(strsiz, strsiz)) != 0) {
      MUTEX_LOCKID_CONTROLLED(MTX_STRHEAP);

#if COMPILER
      rp->prev = curstring;
      rp->next = curstring->next;
      if (curstring->next) curstring->next->prev = rp;
      curstring->next = rp;
#else
      /* attach rp after program's string region on prev/next */
      if (newp->stringregion) {
         rp->prev = newp->stringregion;
         rp->next = newp->stringregion->next;
         if (newp->stringregion->next)
            newp->stringregion->next->prev = rp;
         newp->stringregion->next = rp;
         }
      else
         newp->stringregion = rp;
#endif

      /* attach rp after curstring on Gprev/Gnext. */
      rp->Gprev = curstring;
      rp->Gnext = curstring->Gnext;
      if (curstring->Gnext) curstring->Gnext->Gprev = rp;
      curstring->Gnext = rp;

      MUTEX_UNLOCKID(MTX_STRHEAP);
      ts->Curstring = rp;
      }
    else
      syserr(" init_threadheap: insufficient memory for string region");

   if((rp = reuse_region(blksiz, Blocks)) != 0) {
      ts->Curblock =  curblock = rp;
      }
   else if ((rp = newregion(blksiz, blksiz)) != 0) {
      MUTEX_LOCKID_CONTROLLED(MTX_BLKHEAP);

#if COMPILER
      rp->prev = curblock;
      rp->next = curblock->next;
      if (curblock->next) curblock->next->prev = rp;
      curblock->next = rp;
#else
      /* attach rp after program's block region on prev/next */
      if (newp->blockregion) {
         rp->prev = newp->blockregion;
         rp->next = newp->blockregion->next;
         if (newp->blockregion->next)
            newp->blockregion->next->prev = rp;
         newp->blockregion->next = rp;
         }
      else
         newp->blockregion = rp;
#endif

      /* attach rp after curblock on Gprev/Gnext. */
      rp->Gprev = curblock;
      rp->Gnext = curblock->Gnext;
      if (curblock->Gnext) curblock->Gnext->Gprev = rp;
      curblock->Gnext = rp;

      MUTEX_UNLOCKID(MTX_BLKHEAP);
      ts->Curblock = rp;
      }
    else
      syserr(" init_threadheap: insufficient memory for block region");
}

#endif                                  /* Concurrent */


#if HAVE_LIBPTHREAD

/*
 *  pthread errors handler
 */
void handle_thread_error(int val, int func, char* msg)
{
  if (!msg) msg = "";

   switch(func) {
   case FUNC_MUTEX_LOCK:
   case FUNC_MUTEX_TRYLOCK:
   case FUNC_MUTEX_UNLOCK:
      fprintf(stderr, "\nLock/Unlock mutex error-%s: ", msg);
      switch(val) {
         case EINVAL:
            fatalerr(180, NULL);
            break;
         case EBUSY:
            /* EBUSY is handled somewhere else, we shouldn't get here */
            return;
         }
      break;

   case FUNC_MUTEX_INIT:
      fprintf(stderr, "\nInit mutex error-%s: ", msg);
      break;

   case FUNC_MUTEX_DESTROY:
      fprintf(stderr, "\nDestroy mutex error-%s:", msg);
      switch(val) {
         case EBUSY:
/*          fprintf(stderr, "The implementation has detected an attempt to destroy the object referenced by mutex while it is locked or referenced (for example, while being used in a pthread_cond_wait() or pthread_cond_timedwait()) by another thread.");
*/
            return;
         default:
            fprintf(stderr, " pthread function error!\n ");
            return;
         }

   case FUNC_THREAD_JOIN:
      fprintf(stderr, "\nThread join error-%s:", msg);
      break;

   case FUNC_THREAD_CREATE:
      fprintf(stderr, "\nThread create error-%s:", msg);
      switch(val) {
         case EAGAIN:
            fprintf(stderr, "Insufficient resources to create another thread, or a system imposed limit on the number of threads was encountered.\n");
#if 0
            {
            struct rlimit rlim;
            getrlimit(RLIMIT_NPROC, &rlim);
            fprintf(stderr," Soft Limit: %u\n Hard Limit: %u\n",
               (unsigned int) rlim.rlim_cur, (unsigned int) rlim.rlim_max);
            }
#endif
            break;
         }

   case FUNC_COND_INIT:
         fprintf(stderr, "cond init error-%s\n ", msg);
         break;

   case FUNC_SEM_OPEN:
      fprintf(stderr, "sem open error-%s\n ", msg);
      break;

   case FUNC_SEM_INIT:
      fprintf(stderr, "sem init error-%s\n ", msg);
      break;

   default:
      fprintf(stderr, "\npthread function error-%s !\n", msg);
      break;
      }

      perror("");
      syserr("");
      return;
}
#endif                                  /* HAVE_LIBPTHREAD */
