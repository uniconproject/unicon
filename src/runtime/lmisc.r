/*
 * file: lmisc.r
 *   Contents: [O]create, activate, msg_send, msg_receive
 */

/*
 * create - return an entry block for a co-expression.
 */
#if COMPILER
struct b_coexpr *create(fnc, cproc, ntemps, wrk_size)
continuation fnc;
struct b_proc *cproc;
int ntemps;
int wrk_size;
#else					/* COMPILER */

int Ocreate(entryp, cargp)
word *entryp;
register dptr cargp;
#endif					/* COMPILER */
   {

#ifdef CoExpr
   tended struct b_coexpr *sblkp;
   register struct b_refresh *rblkp;
   register dptr dp, ndp;
   int na, nl, i;

#if !COMPILER
   struct b_proc *cproc;

   /* cproc is the Icon procedure that create occurs in */
   cproc = BlkD(glbl_argp[0], Proc);
#endif					/* COMPILER */

   /*
    * Calculate number of arguments and number of local variables.
    */
#if COMPILER
   na = abs((int)cproc->nparam);
#else					/* COMPILER */
   na = pfp->pf_nargs + 1;  /* includes Arg0 */
#endif					/* COMPILER */
   nl = (int)cproc->ndynam;

   /*
    * Get a new co-expression stack and initialize.
    */

#ifdef MultiThread
   Protect(sblkp = alccoexp(0, 0), err_msg(0, NULL));
#else					/* MultiThread */
   Protect(sblkp = alccoexp(), err_msg(0, NULL));
#endif					/* MultiThread */


   if (!sblkp)
#if COMPILER
      return NULL;
#else					/* COMPILER */
      Fail;
#endif					/* COMPILER */

   /*
    * Get a refresh block for the new co-expression.
    */
#if COMPILER
   Protect(rblkp = alcrefresh(na, nl, ntemps, wrk_size), err_msg(0,NULL));
#else					/* COMPILER */
   Protect(rblkp = alcrefresh(entryp, na, nl),err_msg(0,NULL));
#endif					/* COMPILER */
   if (!rblkp)
#if COMPILER
      return NULL;
#else					/* COMPILER */
      Fail;
#endif					/* COMPILER */

   sblkp->freshblk.dword = D_Refresh;
   BlkLoc(sblkp->freshblk) = (union block *) rblkp;

#if !COMPILER
   /*
    * Copy current procedure frame marker into refresh block.
    */
   rblkp->pfmkr = *pfp;
   rblkp->pfmkr.pf_pfp = 0;
#endif					/* COMPILER */

   /*
    * Copy arguments into refresh block.
    */
   ndp = rblkp->elems;
   dp = glbl_argp;
   for (i = 1; i <= na; i++)
      *ndp++ = *dp++;

   /*
    * Copy locals into the refresh block.
    */
#if COMPILER
   dp = pfp->t.d;
#else					/* COMPILER */
   dp = &(pfp->pf_locals)[0];
#endif					/* COMPILER */
   for (i = 1; i <= nl; i++)
      *ndp++ = *dp++;

   /*
    * Use the refresh block to finish initializing the co-expression stack.
    */
   co_init(sblkp);

#if COMPILER
   sblkp->fnc = fnc;
   if (line_info) {
      if (debug_info)
         PFDebug(sblkp->pf)->proc = cproc;
      PFDebug(sblkp->pf)->old_fname = "";
      PFDebug(sblkp->pf)->old_line = 0;
      }

   return sblkp;
#else					/* COMPILER */
   /*
    * Return the new co-expression.
    */
   Arg0.dword = D_Coexpr;
   BlkLoc(Arg0) = (union block *) sblkp;
   Return;
#endif					/* COMPILER */
#else					/* CoExpr */
   err_msg(401, NULL);
#if COMPILER
   return NULL;
#else					/* COMPILER */
   Fail;
#endif					/* COMPILER */
#endif					/* CoExpr */

   }

/*
 * activate - activate a co-expression.
 */
int activate(val, ncp, result)
dptr val;
struct b_coexpr *ncp;
dptr result;
   {
#ifdef CoExpr

   int first;

#ifdef Concurrent
   if (!ncp){
      tended struct b_list *hp;
      ncp = BlkD(k_current, Coexpr);


      if (!is:null(*val)){      
      /* send */

      hp = BlkD(ncp->outbox, List);
      MUTEX_LOCKBLK_CONTROLLED(hp, "activate(): list mutex");
      if (hp->size>=hp->max){
         hp->full++;
         while (hp->size>=hp->max){
 	    CV_SIGNAL_EMPTYBLK(hp);
	    DEC_NARTHREADS;
	    CV_WAIT_FULLBLK(hp);
	    INC_NARTHREADS_CONTROLLED;
	    }
         hp->full--;
         }
      c_put(&(ncp->outbox), val);
      MUTEX_UNLOCKBLK(hp, "activate: list mutex");
      CV_SIGNAL_EMPTYBLK(hp);
      }

      /* receive */
      hp = BlkD(ncp->inbox, List);
      MUTEX_LOCKBLK_CONTROLLED(hp, "activate: list mutex");

      if (hp->size==0){
	 hp->empty++;
         while (hp->size==0){
 	    CV_SIGNAL_FULLBLK(hp);
	    DEC_NARTHREADS;
	    CV_WAIT_EMPTYBLK(hp);
	    INC_NARTHREADS_CONTROLLED;
	    }
	 hp->empty--;
	 if (hp->size==0){ /* This shouldn't be the case, but.. */
	    MUTEX_UNLOCKBLK(hp, "receive(): list mutex");
 	    CV_SIGNAL_FULLBLK(hp);
      	    return A_Resume;
	    }
      	 }
      c_get(hp, result);
      MUTEX_UNLOCKBLK(hp, "activate: list mutex");
      if (hp->size <= hp->max/50+1) 
 	 CV_SIGNAL_FULLBLK(hp);

      return A_Continue;   
      }
   else
   if (ncp->status & Ts_Async){
      struct b_list *hp;

      if (!is:null(*val)){
      /* send */

      hp = BlkD(ncp->inbox, List);
      MUTEX_LOCKBLK_CONTROLLED(hp, "activate(): list mutex");
      if (hp->size>=hp->max){
         hp->full++;
         while (hp->size>=hp->max){
 	    CV_SIGNAL_EMPTYBLK(hp);
	    DEC_NARTHREADS;
	    CV_WAIT_FULLBLK(hp);
	    INC_NARTHREADS_CONTROLLED;
	    }
         hp->full--;
         }
      c_put(&(ncp->inbox), val);
      MUTEX_UNLOCKBLK(hp, "activate: list mutex");
      CV_SIGNAL_EMPTYBLK(hp);
      }

      /* receive */
      hp = BlkD(ncp->outbox, List);
      MUTEX_LOCKBLK_CONTROLLED(hp, "activate: list mutex");

      if (hp->size==0){
	 hp->empty++;
         while (hp->size==0){
 	    CV_SIGNAL_FULLBLK(hp);
	    DEC_NARTHREADS;
	    CV_WAIT_EMPTYBLK(hp);
	    INC_NARTHREADS_CONTROLLED;
	    }
	 hp->empty--;
	 if (hp->size==0){ /* This shouldn't be the case, but.. */
	    MUTEX_UNLOCKBLK(hp, "receive(): list mutex");
 	    CV_SIGNAL_FULLBLK(hp);
      	    return A_Resume;
	    }
      	 }
      c_get(hp, result);
      MUTEX_UNLOCKBLK(hp, "activate: list mutex");
      if (hp->size <= hp->max/50+1) 
 	 CV_SIGNAL_FULLBLK(hp);

      return A_Continue;   
   }
#endif					/* Concurrent */

   /*
    * Set activator in new co-expression.
    */
   if (ncp->es_actstk == NULL) {
      Protect(ncp->es_actstk = alcactiv(),RunErr(0,NULL));
      first = 0;
      }
   else
      first = 1;

   if (pushact(ncp, (struct b_coexpr *)BlkLoc(k_current)) == Error)
      RunErr(0,NULL);

   if (co_chng(ncp, val, result, A_Coact, first) == A_Cofail)
      return A_Resume;
   else
      return A_Continue;

#else					/* CoExpr */
   RunErr(401,NULL);
#endif					/* CoExpr */
   }

#ifdef Concurrent

int msg_receive( dccp, dncp, msg, timeout)
dptr dccp;
dptr dncp;
/*dptr valloc; /* location of value being transmitted */
dptr msg;	 	 	  /* location to put result */
int timeout;
{
   tended struct b_coexpr *ccp = BlkD(*dccp, Coexpr);
   tended struct b_coexpr *ncp;
   tended struct b_list *hp;
   if (dncp){
      ncp = BlkD(*dncp, Coexpr);
      hp = BlkD(ncp->outbox, List);
      }
   else
      hp = BlkD(ccp->inbox, List);

   switch (timeout){
   	  case 0  :
   	     if (hp->size==0){
 	        CV_SIGNAL_FULLBLK(hp);
	     	*msg = nulldesc;
	     	Fail;
		}

   	     MUTEX_LOCKBLK_CONTROLLED(hp, "receive(): list mutex");
   	     if (hp->size==0){
	        *msg = nulldesc;
	     	MUTEX_UNLOCKBLK(hp, "receive(): list mutex");
 	        CV_SIGNAL_FULLBLK(hp);
      	     	Fail;
      	     	}
   	     c_get(hp, msg);
	     MUTEX_UNLOCKBLK(hp, "receive(): list mutex");
	     if (hp->size <= hp->max/50+1)
 	        CV_SIGNAL_FULLBLK(hp);

   	     Return;
	     break; 

	  case -1 :
   	     MUTEX_LOCKBLK_CONTROLLED(hp, "receive(): list mutex");
   	     if (hp->size==0){
	        hp->empty++;
                while (hp->size==0){
 	          CV_SIGNAL_FULLBLK(hp);
	       	   DEC_NARTHREADS;
	    	   CV_WAIT_EMPTYBLK(hp);
	       	   INC_NARTHREADS_CONTROLLED;
		   }
	        hp->empty--;
		if (hp->size==0){ /* This shouldn't be the case, but.. */
	     	   MUTEX_UNLOCKBLK(hp, "receive(): list mutex");
 	           CV_SIGNAL_FULLBLK(hp);
      	     	   Fail;
		   }
      	     	}
   	     c_get(hp, msg);
	     MUTEX_UNLOCKBLK(hp, "receive(): list mutex");
   	     if (hp->size <= hp->max/50+1) 
 	        CV_SIGNAL_FULLBLK(hp);

   	     Return;
	     break;


	  case -2 :
   	  if (hp->size == 0){
             idelay(1);
             if (hp->size == 0) 
      	     	if (!dncp) 
		   idelay(-1);
	    	else{
		   MUTEX_LOCKBLK_CONTROLLED(BlkD(ncp->cequeue, List), 
	  			       "receieve(): list mutex");
	       	   c_put(&(ncp->cequeue), dccp);
	       	   MUTEX_UNLOCKBLK(BlkD(ncp->cequeue, List), 
	 				"receive(): list mutex");
	           idelay(-1);
	       	   if (ccp->handdata != NULL){
	              *msg = *(ccp->handdata);
	              ccp->handdata = NULL;
	              Return;
	              }
	           }  
              }
	     break;
	  default :
   	     MUTEX_LOCKBLK_CONTROLLED(hp, "receive(): list mutex");
   	     if (hp->size==0){
  	        struct timespec   ts;
  	        struct timeval    tp; 
		gettimeofday(&tp, NULL);
		/* Convert from timeval to timespec */
    		ts.tv_sec  = tp.tv_sec;
    		ts.tv_nsec = tp.tv_usec * 1000 + timeout % 1000;
    		ts.tv_sec += timeout / 1000;

	        hp->empty++;
	        DEC_NARTHREADS;
		CV_TIMEDWAIT_EMPTYBLK(hp, ts);
	        INC_NARTHREADS_CONTROLLED;
	        hp->empty--;
		if (hp->size==0){
	     	   MUTEX_UNLOCKBLK(hp, "receive(): list mutex");
 	           CV_SIGNAL_FULLBLK(hp);
      	     	   Fail;
		   }
      	     	}
   	     c_get(hp, msg);
	     MUTEX_UNLOCKBLK(hp, "receive(): list mutex");
	     if (hp->size <= hp->max/50+1)
 	        CV_SIGNAL_FULLBLK(hp);

   	     Return;
      }
}


int msg_send( dccp, dncp, msg, timeout)
dptr dccp;
dptr dncp;
/*dptr valloc; /* location of value being transmitted */
dptr msg;	 	 	  /* location to put result */
int timeout;
{
   tended struct b_coexpr *ccp = BlkD(*dccp, Coexpr);
   tended struct b_list *hp;
   if (dncp){
      dptr ncpRQ = &(BlkD(*dncp, Coexpr)->inbox);
      hp = BlkD(*ncpRQ, List);
      MUTEX_LOCKBLK_CONTROLLED(hp, "msg_send(): list mutex");
      if (hp->size>=hp->max){ 
         if (timeout==0){ 
	    MUTEX_UNLOCKBLK(hp, "msg_send(): list mutex");
	    Fail;
	    }
         hp->full++;
         while (hp->size>=hp->max){
 	    CV_SIGNAL_EMPTYBLK(hp);
	    DEC_NARTHREADS;
	    CV_WAIT_FULLBLK(hp);
	    INC_NARTHREADS_CONTROLLED;
	    }
	 hp->full--;
      	 }
      c_put(ncpRQ, msg);
      MUTEX_UNLOCKBLK(hp, "msg_send(): list mutex");
      CV_SIGNAL_EMPTYBLK(hp);
      MakeInt(hp->size, msg);
      Return;
      }
   
   /* check if any ce is waiting on my outbox */
   hp = BlkD(ccp->cequeue, List);
   if (hp->size>0){
      tended struct descrip d;
      struct context *n;
      MUTEX_LOCKBLK_CONTROLLED(hp, "send(): list mutex");
      c_get(hp, &d);
      BlkD(d, Coexpr)->handdata = msg;
      MUTEX_UNLOCKBLK(hp, "send(): list mutex");
      n = (struct context *) BlkD(d, Coexpr)->cstate[1];
      if (n->alive > 0){
      	 sem_post(n->semp);
	 MakeInt(hp->size, msg);
	 Return;
	 }
      }

   /* no one is waiting, place the msg in my outbox */
   hp = BlkD(ccp->outbox, List);
   MUTEX_LOCKBLK_CONTROLLED(hp, "send(): list mutex");
      if (hp->size>=hp->max){
         if (timeout==0){ 
	    MUTEX_UNLOCKBLK(hp, "msg_send(): list mutex");
	    Fail;
	    }
         hp->full++;
         while (hp->size>=hp->max){
 	    CV_SIGNAL_EMPTYBLK(hp);
	    DEC_NARTHREADS;
	    CV_WAIT_FULLBLK(hp);
	    INC_NARTHREADS_CONTROLLED;
	    }
	 hp->full--;
      	 }
   c_put(&(ccp->outbox), msg);
   MUTEX_UNLOCKBLK(hp, "send(): list mutex");
   CV_SIGNAL_EMPTYBLK(hp);
   MakeInt(hp->size, msg);
   Return;
}

"x@>y - non-blocking send."
/*
 *  thread send .  y is either &null or a co-expression.
 *  if y is null, send to (the current thread's) outbox.
 *  fails if value cannot be sent to y because y is full.
 *  otherwise, produces the size of y's queue
 */
operator{0,1} @> snd(x,y)
   declare {
      tended struct b_list *hp;
      tended struct descrip L;
      }
   abstract { return integer }

   if is:null(y) then inline {
      CURTSTATE();
      L = (BlkD(k_current, Coexpr))->outbox;
      hp = BlkD(L, List);
      }
   else if is:coexpr(y) then inline {
      L = (BlkD(y, Coexpr))->inbox;
      hp = BlkD(L, List);
      }
   else if is:list(y) then inline {
      L = y;
      hp = BlkD(L, List);
      }
   else 
      runerr(106, y)

   body{
      if (hp->size>=hp->max){
 	 CV_SIGNAL_EMPTYBLK(hp);
	 fail;
	 }

      MUTEX_LOCKBLK_CONTROLLED(hp, "snd(): list mutex");
      if (hp->size>=hp->max){
	 MUTEX_UNLOCKBLK(hp, "snd(): list mutex");
 	 CV_SIGNAL_EMPTYBLK(hp);
	 fail;
	 }
      c_put(&L, &x);
      MUTEX_UNLOCKBLK(hp, "snd(): list mutex");
      CV_SIGNAL_EMPTYBLK(hp);
      return C_integer hp->size;
      }
end

"x@>>y - blocking send."
/*
 *  thread send .  y is either &null or a co-expression.
 *  if y is null, send to (the current thread's) outbox.
 *  fails if value cannot be sent to y because y is full.
 *  otherwise, produces the size of y's queue
 */
operator{0,1} @>> sndbk(x,y)
   declare {
      tended struct b_list *hp;
      tended struct descrip L;
      }
   abstract { return integer }

   if is:null(y) then inline {
      CURTSTATE();
      L = (BlkD(k_current, Coexpr))->outbox;
      hp = BlkD(L, List);
      }
   else if is:coexpr(y) then inline {
      L = (BlkD(y, Coexpr))->inbox;
      hp = BlkD(L, List);
      }
   else if is:list(y) then inline {
      L = y;
      hp = BlkD(L, List);
      }
   else 
      runerr(106, y)

   body{
      MUTEX_LOCKBLK_CONTROLLED(hp, "snd(): list mutex");
      if (hp->size>=hp->max){
         hp->full++;
         while (hp->size>=hp->max){
 	    CV_SIGNAL_EMPTYBLK(hp);
	    DEC_NARTHREADS;
	    CV_WAIT_FULLBLK(hp);
	    INC_NARTHREADS_CONTROLLED;
	    }
	 hp->full--;
      	 }
      c_put(&L, &x);
      MUTEX_UNLOCKBLK(hp, "send(): list mutex");
      CV_SIGNAL_EMPTYBLK(hp);
      return C_integer hp->size;
      }
end

"x@<y - non-blocking receive."
/*
 *  thread send .  y is either &null or a co-expression.
 *  if y is null, send to (the current thread's) outbox.
 *  fails if value cannot be sent to y because y is full.
 *  otherwise, produces the size of y's queue
 */
operator{0,1} @< rcv(x,y)
   declare {
      tended struct b_list *hp;
      struct descrip d;
      }
   abstract { return any_value }

   if !is:null(x) then inline {
      C_integer xval;

      if (!cnv:C_integer(x, xval)) 
         runerr(101, x);

      if (is:list(y)){
         if (xval>0) BlkD(y, List)->max = xval;
         else if (xval<0) BlkD(y, List)->max = xval; 
	 return C_integer BlkD(y, List)->size; 
         }
      else if (is:null(y)){
         CURTSTATE();
	 d = k_current;
	 }
      else if (is:coexpr(y))
         d = y;
      else 
         runerr(106, y);

      if (xval==0)
         return C_integer BlkD((BlkD(d, Coexpr))->inbox, List)->size;
      else if (xval>0) {
         BlkD((BlkD(d, Coexpr))->outbox, List)->max = xval;
	 return C_integer (BlkD(d, List))->size; 
	 }
      else {
         BlkD((BlkD(d, Coexpr))->inbox, List)->max = -xval;
	 return C_integer (BlkD(d, List))->size; 
	 }
      }

   if is:null(y) then inline {
      CURTSTATE();
      hp = BlkD(BlkD(k_current, Coexpr)->inbox, List);
      }
   else if is:coexpr(y) then inline {
      hp = BlkD(BlkD(y, Coexpr)->outbox, List);
      }
   else if is:list(y) then inline {
      hp = BlkD(y, List);
      }
   else 
      runerr(106, y)

   body{

      if (hp->size==0){
 	 CV_SIGNAL_FULLBLK(hp);
	 fail;
	 }

      MUTEX_LOCKBLK_CONTROLLED(hp, "rcv(): list mutex");
      if (hp->size==0){
         MUTEX_UNLOCKBLK(hp, "rcv(): list mutex");
 	 CV_SIGNAL_FULLBLK(hp);
      	 fail;
      	 }
      c_get(hp, &d);
      MUTEX_UNLOCKBLK(hp, "rcv(): list+ mutex");
      if (hp->size <= hp->max/50+1)
 	 CV_SIGNAL_FULLBLK(hp);
      return d;   
      }
end

"x@<<y - blocking receive."
/*
 *  thread send .  y is either &null or a co-expression.
 *  if y is null, send to (the current thread's) outbox.
 *  fails if value cannot be sent to y because y is full.
 *  otherwise, produces the size of y's queue
 */
operator{0,1} @<< rcvbk(x,y)
   declare {
      tended struct b_list *hp;
      struct descrip d;
      }
   abstract { return any_value }

   if !def:C_integer(x, -1) then
     runerr(101, x)

   if is:null(y) then inline {
      CURTSTATE();
      hp = BlkD(BlkD(k_current, Coexpr)->inbox, List);
      }
   else if is:coexpr(y) then inline {
      hp = BlkD(BlkD(y, Coexpr)->outbox, List);
      }
   else if is:list(y) then inline {
      hp = BlkD(y, List);
      }
   else 
      runerr(106, y)

   body{
      switch (x){
         case -1 :
   	    MUTEX_LOCKBLK_CONTROLLED(hp, "rcvbk(): list mutex");
   	    if (hp->size==0){
	       hp->empty++;
               while (hp->size==0){
 	          CV_SIGNAL_FULLBLK(hp);
	          DEC_NARTHREADS;
		  CV_WAIT_EMPTYBLK(hp);
	       	  INC_NARTHREADS_CONTROLLED;
		  }
	       hp->empty--;
	       if (hp->size==0){ /* This shouldn't be the case, but.. */
	          MUTEX_UNLOCKBLK(hp, "rcvbk(): list mutex");
 	          CV_SIGNAL_FULLBLK(hp);
      	     	  fail;
		  }
      	       }
   	    c_get(hp, &d);
	    MUTEX_UNLOCKBLK(hp, "rcvbk(): list mutex");
   	    if (hp->size <= hp->max/50+1) 
 	          CV_SIGNAL_FULLBLK(hp);
   	    return d;

   	 case 0  :
   	    if (hp->size==0){
 	       CV_SIGNAL_FULLBLK(hp);
	       fail;
	       }

   	    MUTEX_LOCKBLK_CONTROLLED(hp, "rcvbk(): list mutex");
   	    if (hp->size==0){
	       MUTEX_UNLOCKBLK(hp, "receive(): list mutex");
 	       CV_SIGNAL_FULLBLK(hp);
      	       fail;
      	       }
   	    c_get(hp, &d);
	    MUTEX_UNLOCKBLK(hp, "rcvbk(): list mutex");
	    if (hp->size <= hp->max/50+1)
 	       CV_SIGNAL_FULLBLK(hp);
   	    return d;

	 default :{
  	    struct timespec   ts;
  	    struct timeval    tp;
    		
	    gettimeofday(&tp, NULL);
	    /* Convert from timeval to timespec */
    	    ts.tv_sec  = tp.tv_sec;
    	    ts.tv_nsec = tp.tv_usec * 1000 + x % 1000;
    	    ts.tv_sec += x / 1000;

   	    MUTEX_LOCKBLK_CONTROLLED(hp, "receive(): list mutex");
   	    if (hp->size==0){ 
	       hp->empty++;
	       DEC_NARTHREADS;
	       CV_TIMEDWAIT_EMPTYBLK(hp, ts);
	       INC_NARTHREADS_CONTROLLED;
	       hp->empty--;
	       if (hp->size==0){
	          MUTEX_UNLOCKBLK(hp, "rcv(): list mutex");
 	          CV_SIGNAL_FULLBLK(hp);
      	     	  fail;
		  }
      	       }
   	    c_get(hp, &d);
	    MUTEX_UNLOCKBLK(hp, "receive(): list mutex");
	    if (hp->size <= hp->max/50+1) 
 	       CV_SIGNAL_FULLBLK(hp);

   	    return d;
	    } /* default */
	 } /* switch */
      }
end
#else					/* Concurrent */
/* 
 * Should never get into these functions as the VM detects the absence
 * of threads and handles these operators in the interpreter loop.
 * Arguably, they should be runtime errors, not fails.
 */
operator{0} @> snd(x,y)
abstract { return empty_type }
body { fail; }
end

operator{0} @>> sndbk(x,y)
abstract { return empty_type }
body { fail; }
end

operator{0} @< rcv(x,y)
abstract { return empty_type }
body { fail; }
end

operator{0} @<< rcvbk(x,y)
abstract { return empty_type }
body { fail; }
end

#endif					/* Concurrent */
