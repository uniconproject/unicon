/*
 * file: lmisc.r
 *   Contents: [O]create, activate, msg_send, msg_receive, snd, sndbk,
 *             rcv, rcvbk
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

#ifdef Concurrent
   /*
    * Make sure we have enough space for the coexpression refresh block and
    * queues before we begin to prevent GC from happening somewhere in the
    * middle before we initialize all bits
    * see ralc.r:alccoexp() and ralc.r:alcrefresh() for information on
    * how much memory to reserve.
    */
   if (!reserve(Blocks, (word)(
		sizeof(struct b_list) * 3 +
		sizeof(struct b_lelem) * 3 +
		(CE_INBOX_SIZE + CE_OUTBOX_SIZE + CE_CEQUEUE_SIZE) * sizeof(struct descrip) +
		sizeof(struct b_refresh) +
		(nl - 1) * sizeof(struct descrip)))
		)
#if COMPILER
               return NULL;
#else					/* COMPILER */
               Fail;
#endif					/* COMPILER */

#endif					/* Concurrent */

#ifdef MultiProgram
   Protect(sblkp = alccoexp(0, 0), err_msg(0, NULL));
#else					/* MultiProgram */
   Protect(sblkp = alccoexp(), err_msg(0, NULL));
#endif					/* MultiProgram */


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

   EVValD( &Arg0, E_CoCreate );

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

   int first = 1;  /* equals 0 if first activation */

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
   if (IS_TS_THREAD(ncp->status) && IS_TS_ASYNC(ncp->status)){
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
	    if (hp->size==0 && ncp->alive<0){
	       hp->empty--;
      	       return A_Resume;
	       }
 	    CV_SIGNAL_FULLBLK(hp);
	    DEC_NARTHREADS;
	    if (hp->size==0 && ncp->alive<0){
	       hp->empty--;
      	       return A_Resume;
	       }
	    CV_WAIT_EMPTYBLK(hp);
	    INC_NARTHREADS_CONTROLLED;
	    if (hp->size==0 && ncp->alive<0){
	       hp->empty--;
      	       return A_Resume;
	       }
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
      first = 0; /* equals 0 if first activation */
      }

   if (pushact(ncp, (struct b_coexpr *)BlkLoc(k_current)) == RunError)
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
             if (hp->size == 0){ 
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
      Fail; /* Unreachable */
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
      MUTEX_LOCKBLK_CONTROLLED(hp, "send(): list mutex");
      c_get(hp, &d);
      BlkD(d, Coexpr)->handdata = msg;
      MUTEX_UNLOCKBLK(hp, "send(): list mutex");
      if (BlkD(d, Coexpr)->alive > 0){
      	 sem_post(BlkD(d, Coexpr)->semp);
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

#endif					/* Concurrent */

"x@>y - non-blocking send."
/*
 *  send value x to y . Possible values of y and the corresponding action:
 *  co-expression: put x in y's inbox
 *  &null: put x the current thread's outbox.
 *  file (socket): write x to y (assuming x can be converted to a string)
 *  list: put x in y
 * 
 *  fails if the value cannot be immediately sent to y (ex: y is full).
 *  produces the size of the list where x got added, except when 
 *  y is a socket where 1 is returned.
 */
operator{0,1} @> snd(x,y)
   declare {
      tended struct b_list *hp;
      tended struct descrip L;
      }
   abstract { return integer }

#ifdef Concurrent
   if is:null(y) then inline {
#if !ConcurrentCOMPILER
      /*
       * Avoid redeclaring curtstate in an inline, it is generated by rtt
       * in the enclosing function.
       */
      CURTSTATE();
#endif					/* ConcurrentCOMPILER */
      L = (BlkD(k_current, Coexpr))->outbox;
      hp = BlkD(L, List);
      }
   else if is:coexpr(y) then inline {
      L = (BlkD(y, Coexpr))->inbox;
      hp = BlkD(L, List);
      }
   else
#endif					/* Concurrent */
   if is:list(y) then inline {
      L = y;
      hp = BlkD(L, List);
      }
   else if is:file(y) then inline {
      tended struct descrip t;
      union f f;
      struct b_file *fblk = BlkD(y, File);
      word status = fblk->status;
  
      f.fp = BlkLoc(y)->File.fd.fp;
   
      /*
       * Convert the argument to a string, defaulting to a empty
       *  string.
       */
       if (!def:tmp_string(x,emptystr,t))
          runerr(109, x);

	/*
	 * Output the string.
	 */
#ifdef PosixFns
        if (status & Fs_Socket) {
           MUTEX_LOCKID_CONTROLLED(fblk->mutexid);
	   if (sock_write(f.fd, StrLoc(t), StrLen(t)) < 0) {
              MUTEX_UNLOCKID(fblk->mutexid);
	      fail;
	      }
           MUTEX_UNLOCKID(fblk->mutexid);
	   return C_integer 1;
      	}
#endif	
				/* PosixFns */
      runerr(118, y);

      }
   else 
      runerr(118, y)

   body{
#ifdef Concurrent
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
#endif					/* Concurrent */
      c_put(&L, &x);
      MUTEX_UNLOCKBLK(hp, "snd(): list mutex");
      CV_SIGNAL_EMPTYBLK(hp);
      return C_integer hp->size;
      }
end

"x@>>y - blocking send."
/*
 *  The same sematics of x@>y above, except that this operation will block 
 *  if the value cannot be sent immedialty to y (ex: y is full),
 *  and wait until it can send.
 */
operator{0,1} @>> sndbk(x,y)
   declare {
      tended struct b_list *hp;
      tended struct descrip L;
      }
   abstract { return integer }

#ifdef Concurrent
   if is:null(y) then inline {
#if !ConcurrentCOMPILER
      /*
       * Avoid redeclaring curtstate in an inline, it is generated by rtt
       * in the enclosing function.
       */
      CURTSTATE();
#endif					/* ConcurrentCOMPILER */
      L = (BlkD(k_current, Coexpr))->outbox;
      hp = BlkD(L, List);
      }
   else if is:coexpr(y) then inline {
      L = (BlkD(y, Coexpr))->inbox;
      hp = BlkD(L, List);
      }
   else
#endif					/* Concurrent */
   if is:list(y) then inline {
      L = y;
      hp = BlkD(L, List);
      }
   else if is:file(y) then inline {
      tended struct descrip t;
      union f f;
      struct b_file *fblk = BlkD(y, File);
      word status = fblk->status;
  
      f.fp = BlkLoc(y)->File.fd.fp;
   
      /*
       * Convert the argument to a string, defaulting to a empty
       *  string.
       */
       if (!def:tmp_string(x,emptystr,t))
          runerr(109, x);

	/*
	 * Output the string.
	 */
#ifdef PosixFns
        if (status & Fs_Socket) {
           MUTEX_LOCKID_CONTROLLED(fblk->mutexid);
	   if (sock_write(f.fd, StrLoc(t), StrLen(t)) < 0) {
              MUTEX_UNLOCKID(fblk->mutexid);
	      fail;
	      }
	   if (sock_write(f.fd, "\n", 1) < 0){
              MUTEX_UNLOCKID(fblk->mutexid);
	      fail;
	      }
           MUTEX_UNLOCKID(fblk->mutexid);
	   return C_integer 1;
      	}
#endif	
				/* PosixFns */
      runerr(118, y);

      }
   else 
      runerr(106, y)

   body{
#ifdef Concurrent
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
#endif					/* Concurrent */
      c_put(&L, &x);
      MUTEX_UNLOCKBLK(hp, "send(): list mutex");
      CV_SIGNAL_EMPTYBLK(hp);
      return C_integer hp->size;
      }
end

"x<@y - non-blocking receive."
/*
 *  receive a value from y . Possible values of y and the corresponding action:
 *  co-expression: get a value from y's outbox
 *  &null: get a value from the current thread's inbox.
 *  file: the same semantics of read()
 *  list: get a value from y
 * 
 *  fails if a value is not available in y (ex: y is empty).
 *  produces whatever value it reads from y;
 *
 *  Experimental: if x is not &null then this is a "query/set" operation 
 *  for the max size of the queue where if y is:
 *  list: 
        x==0: return the "max" size of y 
        x!=0: set the max size of y to abs(x)
 *  co-expression: 
 *      x==0: return the size of the y's inbox
 *      x>0 : set the size y's outbox to x
 *      x<0 : set the size of y's inbox to -x
 */
operator{0,1} <@ rcv(x,y)
   declare {
      tended struct b_list *hp;
      struct descrip d;
      }
   abstract { return any_value }

#ifdef Concurrent
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
#if !ConcurrentCOMPILER
      /*
       * Avoid redeclaring curtstate in an inline, it is generated by rtt
       * in the enclosing function.
       */
      CURTSTATE();
#endif					/* ConcurrentCOMPILER */
      hp = BlkD(BlkD(k_current, Coexpr)->inbox, List);
      }
   else if is:coexpr(y) then inline {
      hp = BlkD(BlkD(y, Coexpr)->outbox, List);
      }
   else
#endif					/* Concurrent */
   if is:list(y) then inline {
      hp = BlkD(y, List);
      }
#ifdef PosixFns
   else if is:file(y) then inline {
      int status, fd, i=0;
      tended struct descrip desc;
      status = BlkD(y, File)->status;

      if (!(status & Fs_Read))
	  runerr(212, y);

#ifdef Graphics
      if (status & Fs_Window) {
	 /* implement ready() on window */
         fail;
         }
#endif					/* Graphics */

#if defined(PseudoPty)
      if (status & Fs_Pty) {
         tended char *sbuf = NULL;
         struct ptstruct *pt = BlkD(y, File)->fd.pt;
#if NT
         DWORD tb;
	 if ((PeekNamedPipe(pt->master_read, NULL, 0, NULL, &tb, NULL) != 0)
		&& (tb>0)) {
#else
	 int tb;
	 fd_set readset;
	 struct timeval tv;
	 FD_ZERO(&readset);
	 FD_SET(pt->master_fd, &readset);
	 tv.tv_sec = tv.tv_usec = 0;
	 if (select(pt->master_fd+1, &readset, NULL, NULL, &tv) > 0) {
	    /* performance bug: how many bytes are really available? */
	    tb = 1;
#endif
	    if (i == 0) i = tb;
            else if (tb < i) i = tb;
            Protect(sbuf = alcstr(NULL, i), runerr(0));
	    DEC_NARTHREADS;
#if NT
            status = ReadFile(pt->master_read, sbuf, i, &tb, NULL);
#else
	    tb = read(pt->master_fd, sbuf, i);
            status = (tb != -1);
#endif
	    INC_NARTHREADS_CONTROLLED;
	    if (!status) fail;
            StrLoc(desc) = sbuf;
            StrLen(desc) = tb;
            return desc;
	 }
	else fail;
	}
#endif					/* PseudoPty */

      if (status & Fs_Buff)
	 runerr(1048, y);

      if (u_read(&y, i, status, &desc) == 0)
	 fail;
      return desc;
      }
#endif					/* PosixFns */
   else 
      runerr(118, y)

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
#ifdef Concurrent
      if (hp->size <= hp->max/50+1)
 	 CV_SIGNAL_FULLBLK(hp);
#endif					/* Concurrent */

      return d;   
      }
end

"x<<@y - blocking receive."
/*
 * same semantics of x<@y excpet this is a blocking operation that waits
 * for a value to become available if there isn't one already.
 * x is a timeout in milliseconds before giving up on waiting.
 * fails if no value is available after x milliseconds 
 * otherwise, produces the value read from y (queue)
 */
operator{0,1} <<@ rcvbk(x,y)
   declare {
      tended struct b_list *hp;
      struct descrip d;
      }
   abstract { return any_value }

   if !def:C_integer(x, -1) then
     runerr(101, x)

#ifdef Concurrent
   if is:null(y) then inline {
#if !ConcurrentCOMPILER
      /*
       * Avoid redeclaring curtstate in an inline, it is generated by rtt
       * in the enclosing function.
       */
      CURTSTATE();
#endif					/* ConcurrentCOMPILER */
      hp = BlkD(BlkD(k_current, Coexpr)->inbox, List);
      }
   else if is:coexpr(y) then inline {
      hp = BlkD(BlkD(y, Coexpr)->outbox, List);
      }
   else
#endif					/* Concurrent */
   if is:list(y) then inline {
      hp = BlkD(y, List);
      }
   else if is:file(y) then inline {
      register word slen, rlen;
      register char *sptr;
      int status;
      char sbuf[MaxReadStr];
      tended struct descrip s;
#ifdef PosixFns
      SOCKET ws;
#endif					/* PosixFns */
      /*
       * Make sure the file is open for reading.
       */
      /* status = BlkLoc(y)->File.status;
       * if ((status & Fs_Read) == 0)
       * runerr(212, y);
       */

#ifdef PosixFns
      if (status & Fs_Socket) {
         StrLen(s) = 0;
         do {
	    ws = (SOCKET)BlkD(y,File)->fd.fd;
      	    DEC_NARTHREADS;
	    if ((slen = sock_getstrg(sbuf, MaxReadStr, ws)) == -1) {
	       /*IntVal(amperErrno) = errno; */
      	       INC_NARTHREADS_CONTROLLED;
	       fail;
	       }
      	    INC_NARTHREADS_CONTROLLED;
	    if (slen == -3)
	       fail;
	    if (slen == 1 && *sbuf == '\n')
	       break;
	    rlen = slen < 0 ? (word)MaxReadStr : slen;

	    Protect(reserve(Strings, rlen), runerr(0));
	    if (StrLen(s) > 0 && !InRange(strbase,StrLoc(s),strfree)) {
	       Protect(reserve(Strings, StrLen(s)+rlen), runerr(0));
	       Protect((StrLoc(s) = alcstr(StrLoc(s),StrLen(s))), runerr(0));
	       }

	    Protect(sptr = alcstr(sbuf,rlen), runerr(0));
	    if (StrLen(s) == 0)
	       StrLoc(s) = sptr;
	    StrLen(s) += rlen;
	    if (StrLoc(s) [ StrLen(s) - 1 ] == '\n') { StrLen(s)--; break; }
	    else {
	       /* no newline to trim; EOF? */
	       }
	    }
	 while (slen > 0);
         return s;
	 }
#endif					/* PosixFns */
      runerr(118, y);
      }
   else 
      runerr(118, y)

   body{
      switch (x){
         case -1 :
   	    MUTEX_LOCKBLK_CONTROLLED(hp, "rcvbk(): list mutex");
   	    if (hp->size==0){
#ifdef Concurrent
	       hp->empty++;
               while (hp->size==0){
 	          CV_SIGNAL_FULLBLK(hp);
	          DEC_NARTHREADS;
		  CV_WAIT_EMPTYBLK(hp);
	       	  INC_NARTHREADS_CONTROLLED;
		  }
	       hp->empty--;
#endif					/* Concurrent */
	       if (hp->size==0){ /* This shouldn't be the case, but.. */
	          MUTEX_UNLOCKBLK(hp, "rcvbk(): list mutex");
 	          CV_SIGNAL_FULLBLK(hp);
      	     	  fail;
		  }
      	       }
   	    c_get(hp, &d);
	    MUTEX_UNLOCKBLK(hp, "rcvbk(): list mutex");
#ifdef Concurrent
   	    if (hp->size <= hp->max/50+1) 
 	          CV_SIGNAL_FULLBLK(hp);
#endif					/* Concurrent */
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
#ifdef Concurrent
	    if (hp->size <= hp->max/50+1)
 	       CV_SIGNAL_FULLBLK(hp);
#endif					/* Concurrent */
   	    return d;

	 default :{
  	    struct timespec   ts;
  	    struct timeval    tp;
	    gettimeofday(&tp, NULL);
	    /*
	     * The argument is in milli seconds,
	     * timeval returns micro seconds
	     * timespec needs nano seconds
	     * Do the conversion:
	     */
    	    tp.tv_usec += (x % 1000) * 1000;
	    if(tp.tv_usec<1000000) {
    	       ts.tv_sec  = tp.tv_sec +  x / 1000;
    	       ts.tv_nsec = tp.tv_usec * 1000;
	       }
	    else {
	       /* make sure tv_usec overflows to seconds */
	       ts.tv_sec  = tp.tv_sec +  x / 1000 + 1;
    	       ts.tv_nsec = (tp.tv_usec-1000000) * 1000;
	       }

   	    MUTEX_LOCKBLK_CONTROLLED(hp, "receive(): list mutex");
   	    if (hp->size==0){
#ifdef Concurrent
	       hp->empty++;
	       DEC_NARTHREADS;
	       CV_TIMEDWAIT_EMPTYBLK(hp, ts);
	       INC_NARTHREADS_CONTROLLED;
	       hp->empty--;
#endif					/* Concurrent */
	       if (hp->size==0){
	          MUTEX_UNLOCKBLK(hp, "rcv(): list mutex");
 	          CV_SIGNAL_FULLBLK(hp);
      	     	  fail;
		  }
      	       }
   	    c_get(hp, &d);
	    MUTEX_UNLOCKBLK(hp, "receive(): list mutex");
#ifdef Concurrent
	    if (hp->size <= hp->max/50+1)
 	       CV_SIGNAL_FULLBLK(hp);
#endif					/* Concurrent */
   	    return d;
	    } /* default */
	 } /* switch */

      fail;   /* make rtt happy! */
      }
end
