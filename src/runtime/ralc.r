/*
 * File: ralc.r
 *  Contents: allocation routines
 */

/*
 * Prototypes.
 */
#ifdef Concurrent
static struct region *findgap(struct region *curr_private, word nbytes, int region);
#define INIT_SHARED(blk) blk->shared = 0
#else 					/* Concurrent */
static struct region *findgap	(struct region *curr, word nbytes);
#define INIT_SHARED(blk)
#endif 					/* Concurrent */

extern word alcnum;

#ifndef MultiProgram
word coexp_ser = 2;	/* serial numbers for co-expressions; &main is 1 */
word list_ser = 1;	/* serial numbers for lists */
word intern_list_ser=-1;/* serial numbers for lists used internally by the RT system */
#ifdef PatternType
word pat_ser = 1;	/* serial numbers for patterns */
#endif					/* PatternType */
word set_ser = 1;	/* serial numbers for sets */
word table_ser = 1;	/* serial numbers for tables */
#endif					/* MultiProgram */


/*
 * AlcBlk - allocate a block.
 */
#begdef AlcBlk(var, struct_nm, t_code, nbytes)
{
   /*
    * Ensure that there is enough room in the block region.
    */

   if (DiffPtrs(blkend,blkfree) < nbytes && !reserve(Blocks, nbytes))
      return NULL;

   /*
    * Decrement the free space in the block region by the number of bytes
    *  allocated and return the address of the first byte of the allocated
    *  block.
    */
   blktotal += nbytes;
   var = (struct struct_nm *)blkfree;
   blkfree += nbytes;
   var->title = t_code;
}
#enddef

/*
 * AlcFixBlk - allocate a fixed length block.
 */
#define AlcFixBlk(var, struct_nm, t_code)\
   AlcBlk(var, struct_nm, t_code, sizeof(struct struct_nm))

/*
 * AlcVarBlk - allocate a variable-length block.
 */
#begdef AlcVarBlk(var, struct_nm, t_code, n_desc)
   {
   uword size;

   /*
    * Variable size blocks are declared with one descriptor, thus
    *  we need add in only n_desc - 1 descriptors.
    */
   size = sizeof(struct struct_nm) + (n_desc - 1) * sizeof(struct descrip);
   AlcBlk(var, struct_nm, t_code, size)
   var->blksize = size;
   }
#enddef

/*
 * alcactiv - allocate a co-expression activation block.
 */

struct astkblk *alcactiv()
   {
   struct astkblk *abp;
   CURTSTATE();

   abp = (struct astkblk *)malloc((msize)sizeof(struct astkblk));

   /*
    * If malloc failed, attempt to free some co-expression blocks and retry.
    */
   if (abp == NULL) {
      DO_COLLECT(Static);
      abp = (struct astkblk *)malloc((msize)sizeof(struct astkblk));
      }

   if (abp == NULL)
      ReturnErrNum(305, NULL);
   abp->nactivators = 0;
   abp->astk_nxt = NULL;
   abp->arec[0].activator = NULL;
   return abp;
   }

#ifdef LargeInts
#begdef alcbignum_macro(f,e_lrgint)
/*
 * alcbignum - allocate an n-digit bignum in the block region
 */

struct b_bignum *f(word n)
   {
   register struct b_bignum *blk;
   register uword size;
   CURTSTATE();

   size = LrgNeed(n);

   EVVal((word)size, e_lrgint);

   AlcBlk(blk, b_bignum, T_Lrgint, size);
   blk->blksize = size;
   blk->msd = blk->sign = 0;
   blk->lsd = n - 1;
   return blk;
   }
#enddef
#ifdef MultiProgram
alcbignum_macro(alcbignum_0,0)
alcbignum_macro(alcbignum_1,E_Lrgint)
#else					/* MultiProgram */
alcbignum_macro(alcbignum,0)
#endif					/* MultiProgram */

#endif					/* LargeInts */

#ifdef Concurrent
int alcce_q(dptr q, int size){
   struct b_list *hp;
   if((hp = alclist(-1, size)) == NULL)
      return Failed;

   MUTEX_INITBLK(hp);
   BlkLoc(*q) = (union block *) hp;
   (*q).dword = D_List;
   hp->max = size;
   CV_INITBLK(hp);
   return Succeeded;
}

int alcce_queues(struct b_coexpr *ep){
   ep->inbox = nulldesc;
   ep->outbox = nulldesc;
   ep->cequeue = nulldesc;
   ep->handdata = NULL;
 
  /*
   * Initialize sender/receiver queues.
   *
   * Make sure we have enough memory for all queues all at once to avoid 
   * multiple GC if we are at the end of a region.
   */

   if (!reserve(Blocks, (word)(
		sizeof(struct b_list) * 3 + 
		sizeof(struct b_lelem) * 3 +
		(CE_INBOX_SIZE + CE_OUTBOX_SIZE + CE_CEQUEUE_SIZE) * sizeof(struct descrip)))
		)
       		return Failed;

   if (alcce_q(&(ep->outbox), 1024) == Failed)
      return Failed;
   if (alcce_q(&(ep->inbox), 1024) == Failed)
      return Failed;
   if (alcce_q(&(ep->cequeue), 64) == Failed)
      return Failed;   
   
   ep->handdata = NULL;
   INIT_SHARED(ep);
   
   return Succeeded;
}

#endif					/* Concurrent */


/*
 * alccoexp - allocate a co-expression stack block.
 */
#if COMPILER
struct b_coexpr *alccoexp()
   {
   struct b_coexpr *ep;
   /*
    * If there have been too many co-expression allocations
    * since a collection, attempt to free some co-expression blocks.
    */

   CURTSTATE();

   MUTEX_LOCKID_CONTROLLED(MTX_ALCNUM);

   if (alcnum > AlcMax) DO_COLLECT(Static);

   ep = (struct b_coexpr *)malloc((msize)stksize);

   /*
    * If malloc failed, attempt to free some co-expression blocks and retry.
    */
   if (ep == NULL) {
      DO_COLLECT(Static);
      ep = (struct b_coexpr *)malloc((msize)stksize);
      }

   if (ep == NULL){
      MUTEX_UNLOCKID(MTX_ALCNUM);
      ReturnErrNum(305, NULL);
      }

   alcnum++;                    /* increment allocation count since last g.c. */
   MUTEX_UNLOCKID(MTX_ALCNUM);

   ep->title = T_Coexpr;
   ep->size = 0;
   ep->es_actstk = NULL;
   MUTEX_LOCKID(MTX_COEXP_SER);
   ep->id = coexp_ser++;
   MUTEX_UNLOCKID(MTX_COEXP_SER);
   ep->es_tend = NULL;
   ep->file_name = "";
   ep->line_num = 0;
   ep->freshblk = nulldesc;
   ep->es_actstk = NULL;

#ifdef NativeCoswitch
   ep->status = 0;
#else					/* NativeCoswitch */
   ep->status = Ts_Posix;
#endif					/* NativeCoswitch */


   /* need to look at concurrent initialization for COMPILER and !COMPILER
    * cases and see if we should make a common function that can serve both.
    */
#ifdef Concurrent

   if (alcce_queues(ep) == Failed)
      ReturnErrNum(307, NULL);
   
   ep->ini_blksize = rootblock.size/100;
   if (ep->ini_blksize < MinAbrSize)
      ep->ini_blksize = MinAbrSize;

   ep->ini_ssize = rootstring.size/100;
   if (ep->ini_ssize < MinStrSpace)
      ep->ini_ssize = MinStrSpace;

#endif             /* Concurrent */

   ep->es_tend = NULL;	

#ifdef PthreadCoswitch
{
   makesem(ep);
   ep->tmplevel = 0;
   ep->have_thread = 0;
   ep->alive = 0;

}
#endif					/* PthreadCoswitch */

   MUTEX_LOCKID(MTX_STKLIST);
   ep->nextstk = stklist;
   stklist = ep;
   MUTEX_UNLOCKID(MTX_STKLIST);
   INIT_SHARED(ep);
   return ep;
   }
#else					/* COMPILER */
#ifdef MultiProgram
/*
 * If this is a new program being loaded, an icodesize>0 gives the
 * hdr.hsize and a stacksize to use; allocate
 * sizeof(progstate) + icodesize + mstksize
 * Otherwise (icodesize==0), allocate a normal stksize...
 */
struct b_coexpr *alccoexp(icodesize, stacksize)
long icodesize, stacksize;
#else					/* MultiProgram */
struct b_coexpr *alccoexp()
#endif					/* MultiProgram */

   {
   struct b_coexpr *ep = NULL;
   CURTSTATE();

   /*
    * If there have been too many co-expression allocations
    * since a collection, attempt to free some co-expression blocks.
    */

MUTEX_LOCKID_CONTROLLED(MTX_ALCNUM);

   if (alcnum > AlcMax) DO_COLLECT(Static);

#ifdef MultiProgram
   if (icodesize > 0) {
      ep = (struct b_coexpr *)
	calloc(1, (msize)(stacksize + icodesize + sizeof(struct progstate) +
			  sizeof(struct b_coexpr)));
      }
   else
#endif					/* MultiProgram */
     ep = (struct b_coexpr *)malloc((msize)stksize);

   /*
    * If malloc failed, attempt to free some co-expression blocks and retry.
    */
   if (ep == NULL) {
      DO_COLLECT(Static);

#ifdef MultiProgram
      if (icodesize>0) {
         ep = (struct b_coexpr *)
	    malloc((msize)(mstksize+icodesize+sizeof(struct progstate)));
         }
      else
#endif					/* MultiProgram */
         ep = (struct b_coexpr *)malloc((msize)stksize);
      }
   if (ep == NULL){
      MUTEX_UNLOCKID(MTX_ALCNUM);
      ReturnErrNum(305, NULL);
      }

   alcnum++;		/* increment allocation count since last g.c. */

   MUTEX_UNLOCKID(MTX_ALCNUM);

   ep->title = T_Coexpr;
   ep->es_actstk = NULL;
   ep->size = 0;
#ifdef MultiProgram
   ep->es_pfp = NULL;
   ep->es_gfp = NULL;
   ep->es_argp = NULL;
   ep->tvalloc = NULL;

#ifdef NativeCoswitch
   ep->status = 0;
#else					/* NativeCoswitch */
   ep->status = Ts_Posix;
#endif					/* NativeCoswitch */

   if (icodesize > 0)
      ep->id = 1;
   else{
#endif					/* MultiProgram */
      MUTEX_LOCKID(MTX_COEXP_SER);
      ep->id = coexp_ser++;
      MUTEX_UNLOCKID(MTX_COEXP_SER);
#ifdef MultiProgram
   }
#endif					/* MultiProgram */

#ifdef Concurrent
   ep->Lastop = 0;
   if (alcce_queues(ep) == Failed)
      ReturnErrNum(307, NULL);

   {
   unsigned long available = memorysize(1);
   word size;
   if (NARthreads <= 32)       size = available * 0.005;
   else if (NARthreads <= 96)  size = available * 0.004;
   else if (NARthreads <= 224) size = available * 0.003;
   else if (NARthreads <= 480) size = available * 0.002;
   else                        size = available * 0.001;
   ep->ini_blksize = ep->ini_ssize = size;
   }

   if (ep->ini_blksize < MinAbrSize)
      ep->ini_blksize = MinAbrSize;

   if (ep->ini_ssize < MinStrSpace)
      ep->ini_ssize = MinStrSpace;
#endif					/* Concurrent */

      ep->es_tend = NULL;

#ifdef MultiProgram
   /*
    * Initialize program state to self for &main; curpstate for others.
    */
   if(icodesize>0){
     ep->program = (struct progstate *)(ep+1);
     ep->program->tstate = &ep->program->maintstate;
     }
   else ep->program = curpstate;
#endif					/* MultiProgram */

#ifdef PthreadCoswitch
{
   makesem(ep);
   ep->tmplevel = 0;
   ep->have_thread = 0;
   ep->alive = 0;
#ifdef Concurrent
#ifdef MultiProgram
   if(icodesize>0){
      ep->isProghead = 1;
      ep->tstate = ep->program->tstate;
      }
   else
#endif					/* MultiProgram */
      {
      ep->tstate = NULL; 
      ep->isProghead = 0;
      }
#endif					/* Concurrent */
}
#endif					/* PthreadCoswitch */

   MUTEX_LOCKID(MTX_STKLIST);
   ep->nextstk = stklist;
   stklist = ep;
   MUTEX_UNLOCKID(MTX_STKLIST);

   return ep;
   }
#endif					/* COMPILER */


#begdef alccset_macro(f, e_cset)
/*
 * alccset - allocate a cset in the block region.
 */

struct b_cset *f()
   {
   register struct b_cset *blk;
   register int i;
   CURTSTATE();

   EVVal(sizeof (struct b_cset), e_cset);
   AlcFixBlk(blk, b_cset, T_Cset)
   blk->size = -1;              /* flag size as not yet computed */

   /*
    * Zero the bit array.
    */
   for (i = 0; i < CsetSize; i++)
     blk->bits[i] = 0;
   return blk;
   }
#enddef
#ifdef MultiProgram
alccset_macro(alccset_0,0)
alccset_macro(alccset_1,E_Cset)
#else					/* MultiProgram */
alccset_macro(alccset,0)
#endif					/* MultiProgram */


#begdef alcfile_macro(f, e_file)
/*
 * alcfile - allocate a file block in the block region.
 */

struct b_file *f(FILE *fd, int status, dptr name)
   {
   tended struct descrip tname = *name;
   register struct b_file *blk;

   EVVal(sizeof (struct b_file), e_file);
   AlcFixBlk(blk, b_file, T_File)
   blk->fd.fp = fd;
   blk->status = status;
   blk->fname = tname;
#ifdef Concurrent
   blk->mutexid = get_mutex(&rmtx_attr);
#endif					/* Concurrent */  

   return blk;
   }
#enddef

#ifdef MultiProgram
#passthru #undef alcfile
alcfile_macro(alcfile,0)
alcfile_macro(alcfile_1,E_File)
#else					/* MultiProgram */
alcfile_macro(alcfile,0)
#endif					/* MultiProgram */

#begdef alchash_macro(f, e_table, e_set)
/*
 * alchash - allocate a hashed structure (set or table header) in the block
 *  region.
 */
union block *f(int tcode)
   {
   register int i;
   register struct b_set *ps;
   register struct b_table *pt;
   CURTSTATE();

   if (tcode == T_Table) {
      EVVal(sizeof(struct b_table), e_table);
      AlcFixBlk(pt, b_table, T_Table);
      ps = (struct b_set *)pt;
      MUTEX_LOCKID(MTX_TABLE_SER);
      ps->id = table_ser++;
      MUTEX_UNLOCKID(MTX_TABLE_SER);
      }
   else {	/* tcode == T_Set */
      EVVal(sizeof(struct b_set), e_set);
      AlcFixBlk(ps, b_set, T_Set);
      MUTEX_LOCKID(MTX_SET_SER);
      ps->id = set_ser++;
      MUTEX_UNLOCKID(MTX_SET_SER);
      }
   ps->size = 0;
   ps->mask = 0;
   INIT_SHARED(ps);
   for (i = 0; i < HSegs; i++)
      ps->hdir[i] = NULL;
   return (union block *)ps;
   }
#enddef

#ifdef MultiProgram
alchash_macro(alchash_0,0,0)
alchash_macro(alchash_1,E_Table,E_Set)
#else					/* MultiProgram */
alchash_macro(alchash,0,0)
#endif					/* MultiProgram */

#begdef alcsegment_macro(f,e_slots)
/*
 * alcsegment - allocate a slot block in the block region.
 */

struct b_slots *f(word nslots)
   {
   uword size;
   register struct b_slots *blk;
   CURTSTATE();

   size = sizeof(struct b_slots) + WordSize * (nslots - HSlots);
   EVVal(size, e_slots);
   AlcBlk(blk, b_slots, T_Slots, size);
   blk->blksize = size;
   while (--nslots >= 0)
      blk->hslots[nslots] = NULL;
   return blk;
   }
#enddef

#ifdef MultiProgram
alcsegment_macro(alcsegment_0,0)
alcsegment_macro(alcsegment_1,E_Slots)
#else					/* MultiProgram */
alcsegment_macro(alcsegment,0)
#endif					/* MultiProgram */


#ifdef PatternType

#begdef alcpattern_macro(f, e_pattern, e_pelem)

struct b_pattern *f(word stck_size)
{
   register struct b_pattern *pheader;
   CURTSTATE();
   
   EVVal(sizeof (struct b_pattern), e_pattern);
   AlcFixBlk(pheader, b_pattern, T_Pattern)
   pheader->stck_size = stck_size;
   MUTEX_LOCKID(MTX_PAT_SER);
   pheader->id = pat_ser++;
   MUTEX_UNLOCKID(MTX_PAT_SER);
   pheader->pe = NULL;
   return pheader;
}
#enddef

#ifdef MultiProgram
alcpattern_macro(alcpattern_0,0,0)
alcpattern_macro(alcpattern_1,E_Pattern,E_Pelem)
#else					/* MultiProgram */
alcpattern_macro(alcpattern,0,0)
#endif					/* MultiProgram */


#begdef alcpelem_macro(f, e_pelem)

#if COMPILER
struct b_pelem *f( word patterncode)
#else					/* COMPILER */
struct b_pelem *f( word patterncode, word *o_ipc)
#endif					/* COMPILER */
{
   register struct b_pelem *pelem;
   CURTSTATE();
   
   EVVal(sizeof (struct b_pelem), e_pelem);
   AlcFixBlk(pelem, b_pelem, T_Pelem)
   pelem->pcode = patterncode;
   pelem->pthen = NULL;
#if !COMPILER
   pelem->origin_ipc = o_ipc;
#endif					/* COMPILER */
   pelem->parameter = nulldesc;
   return pelem;
   }
#enddef

#ifdef MultiProgram
alcpelem_macro(alcpelem_0,0)
alcpelem_macro(alcpelem_1,E_Pelem)
#else					/* MultiProgram */
alcpelem_macro(alcpelem,0)
#endif					/* MultiProgram */


#endif					/* PatternType */

struct b_cons *alccons(union block *data)
{
   struct b_cons *rv;
   CURTSTATE();
   AlcFixBlk(rv, b_cons, T_Cons);
   rv->data = data;
   rv->next = NULL;
   return rv;
}

/*
 * allocate just a list header block.  internal use only (alc*array family).
 */
struct b_list *alclisthdr(uword size, union block *bptr)
{
   register struct b_list *blk;
   CURTSTATE();

   AlcFixBlk(blk, b_list, T_List)
   blk->size = size;
   MUTEX_LOCKID(MTX_LIST_SER);
   blk->id = list_ser++;
   MUTEX_UNLOCKID(MTX_LIST_SER);
   blk->listhead = bptr;
   blk->listtail = NULL;
   INIT_SHARED(blk);
#ifdef Arrays
   ( (struct b_realarray *) bptr)->listp = (union block *)blk;
#endif					/* Arrays */
   return blk;
}


/*
 * alclist_raw(), followed by alclist().
 *
 * alclist - allocate a list header block and attach a
 *  corresponding list element block in the block region.
 *  Forces a g.c. if there's not enough room for the whole list.
 *  The "alclstb" code is inlined to avoid duplicated initialization.
 *
 * alclist_raw() - as per alclist(), except initialization is left to
 * the caller, who promises to initialize first n==size slots w/o allocating.
 */
#begdef alclist_raw_macro(f, e_list, e_lelem)

struct b_list *f(uword size, uword nslots)
   {
   register struct b_list *blk;
   register struct b_lelem *lblk;
   register word i;
   CURTSTATE();

   if (!reserve(Blocks, (word)(sizeof(struct b_list) + sizeof (struct b_lelem)
      + (nslots - 1) * sizeof(struct descrip)))) return NULL;
   EVVal(sizeof (struct b_list), e_list);
   EVVal(sizeof (struct b_lelem) + (nslots-1) * sizeof(struct descrip), e_lelem);
   AlcFixBlk(blk, b_list, T_List)
   AlcVarBlk(lblk, b_lelem, T_Lelem, nslots)
   MUTEX_LOCKID(MTX_LIST_SER);
   if (size != -1)
      blk->id = list_ser++;
   else{
      /* 
       * size -1 is used to indicate an RT list, 
       * reset size to 0 and use the "special" serial number
       */
      size = 0;
      blk->id = intern_list_ser--;
      }
   MUTEX_UNLOCKID(MTX_LIST_SER);
   blk->size = size;     
   INIT_SHARED(blk);

   blk->listhead = blk->listtail = (union block *)lblk;

   lblk->nslots = nslots;
   lblk->first = 0;
   lblk->nused = size;
   lblk->listprev = lblk->listnext = (union block *)blk;
   /*
    * Set all elements beyond size to &null.
    */
   for (i = size; i < nslots; i++)
      lblk->lslots[i] = nulldesc;
   return blk;
   }
#enddef

#ifdef MultiProgram
#passthru #undef alclist_raw
alclist_raw_macro(alclist_raw,0,0)
alclist_raw_macro(alclist_raw_1,E_List,E_Lelem)
#else					/* MultiProgram */
alclist_raw_macro(alclist_raw,0,0)
#endif					/* MultiProgram */

#begdef alclist_macro(f,e_list,e_lelem)

struct b_list *f(uword size, uword nslots)
{
   register word i = sizeof(struct b_lelem)+(nslots-1)*sizeof(struct descrip);
   register struct b_list *blk;
   register struct b_lelem *lblk;
   CURTSTATE();

   if (!reserve(Blocks, (word)(sizeof(struct b_list) + i))) return NULL;
   EVVal(sizeof (struct b_list), e_list);
   EVVal(i, e_lelem);
   AlcFixBlk(blk, b_list, T_List)
   AlcBlk(lblk, b_lelem, T_Lelem, i)
   MUTEX_LOCKID(MTX_LIST_SER);
   if (size != -1)
      blk->id = list_ser++;
   else{ 
      /* 
       * size -1 is used to indicate an RT list, 
       * reset size to 0 and use the "special" serial number
       */
      size = 0;
      blk->id = intern_list_ser--;
      }
   MUTEX_UNLOCKID(MTX_LIST_SER);
   blk->size = size;
   blk->listhead = blk->listtail = (union block *)lblk;
   INIT_SHARED(blk);
   lblk->blksize = i;
   lblk->nslots = nslots;
   lblk->first = 0;
   lblk->nused = size;
   lblk->listprev = lblk->listnext = (union block *)blk;
   /*
    * Set all elements to &null.
    */
   for (i = 0; i < nslots; i++)
      lblk->lslots[i] = nulldesc;
   return blk;
   }
#enddef

#ifdef MultiProgram
alclist_macro(alclist_0,0,0)
alclist_macro(alclist_1,E_List,E_Lelem)
#else					/* MultiProgram */
alclist_macro(alclist,0,0)
#endif					/* MultiProgram */

#begdef alclstb_macro(f,t_lelem)
/*
 * alclstb - allocate a list element block in the block region.
 */

struct b_lelem *f(uword nslots, uword first, uword nused)
   {
   register struct b_lelem *blk;
   register word i;
   CURTSTATE();

   AlcVarBlk(blk, b_lelem, T_Lelem, nslots)
   blk->nslots = nslots;
   blk->first = first;
   blk->nused = nused;
   blk->listprev = NULL;
   blk->listnext = NULL;
   /*
    * Set all elements to &null.
    */
   for (i = 0; i < nslots; i++)
      blk->lslots[i] = nulldesc;
   return blk;
   }
#enddef

#ifdef MultiProgram
alclstb_macro(alclstb_0,0)
alclstb_macro(alclstb_1,E_Lelem)
#else					/* MultiProgram */
alclstb_macro(alclstb,0)
#endif					/* MultiProgram */

#begdef alcreal_macro(f,e_real)
/*
 * alcreal - allocate a real value in the block region.
 */

struct b_real *f(double val)
   {
   register struct b_real *blk;
   CURTSTATE();

   EVVal(sizeof (struct b_real), e_real);
   AlcFixBlk(blk, b_real, T_Real)

#ifdef Double
/* store real value one word at a time into possibly unaligned slot */
   { int *rp, *rq;
     rp = (int *) &(blk->realval);
     rq = (int *) &val;
     *rp++ = *rq++;
     *rp   = *rq;
   }
#else                                   /* Double */
   blk->realval = val;
#endif                                  /* Double */

   return blk;
   }
#enddef

#ifndef DescriptorDouble
#ifdef MultiProgram
#passthru #undef alcreal
alcreal_macro(alcreal,0)
alcreal_macro(alcreal_1,E_Real)
#else					/* MultiProgram */
alcreal_macro(alcreal,0)
#endif					/* MultiProgram */
#endif					/* DescriptorDouble */

#begdef alcrecd_macro(f,e_record)
/*
 * alcrecd - allocate record with nflds fields in the block region.
 */

struct b_record *f(int nflds, union block *recptr)
   {
   tended union block *trecptr = recptr;
   register struct b_record *blk;

   EVVal(sizeof(struct b_record) + (nflds-1)*sizeof(struct descrip),e_record);
   AlcVarBlk(blk, b_record, T_Record, nflds)
   blk->recdesc = trecptr;
   MUTEX_LOCKID(MTX_RECID);
   blk->id = (((struct b_proc *)recptr)->recid)++;
   MUTEX_UNLOCKID(MTX_RECID);
   INIT_SHARED(blk);
   return blk;
   }
#enddef

#ifdef MultiProgram
alcrecd_macro(alcrecd_0,0)
alcrecd_macro(alcrecd_1,E_Record)
#else					/* MultiProgram */
alcrecd_macro(alcrecd,0)
#endif					/* MultiProgram */

/*
 * alcrefresh - allocate a co-expression refresh block.
 */

#if COMPILER
struct b_refresh *alcrefresh(na, nl, nt, wrk_sz)
int na;
int nl;
int nt;
int wrk_sz;
   {
   struct b_refresh *blk;
   CURTSTATE();

   AlcVarBlk(blk, b_refresh, T_Refresh, na + nl)
   blk->nlocals = nl;
   blk->nargs = na;
   blk->ntemps = nt;
   blk->wrk_size = wrk_sz;
   return blk;
   }
#else					/* COMPILER */
#begdef alcrefresh_macro(f,e_refresh)

struct b_refresh *f(word *entryx, int na, int nl)
   {
   struct b_refresh *blk;
   CURTSTATE();

   AlcVarBlk(blk, b_refresh, T_Refresh, na + nl);
   blk->ep = entryx;
   blk->nlocals = nl;
   return blk;
   }

#enddef

#ifdef MultiProgram
alcrefresh_macro(alcrefresh_0,0)
alcrefresh_macro(alcrefresh_1,E_Refresh)
#else					/* MultiProgram */
alcrefresh_macro(alcrefresh,0)
#endif					/* MultiProgram */
#endif					/* COMPILER */

#begdef alcselem_macro(f,e_selem)
/*
 * alcselem - allocate a set element block.
 */
struct b_selem *f(dptr mbr,uword hn)
   {
   tended struct descrip tmbr = *mbr;
   register struct b_selem *blk;

   EVVal(sizeof(struct b_selem), e_selem);
   AlcFixBlk(blk, b_selem, T_Selem)
   blk->clink = NULL;
   blk->setmem = tmbr;
   blk->hashnum = hn;
   return blk;
   }
#enddef

#ifdef MultiProgram
alcselem_macro(alcselem_0,0)
alcselem_macro(alcselem_1,E_Selem)
#else					/* MultiProgram */
alcselem_macro(alcselem,0)
#endif					/* MultiProgram */

#begdef alcstr_macro(f,e_string)
/*
 * alcstr - allocate a string in the string space.
 */

char *f(register char *s, register word slen)
   {
   tended struct descrip ts;
   register char *d;
   char *ofree;

#if e_string
   if (!noMTevents){
      StrLen(ts) = slen;
      StrLoc(ts) = s;
      EVVal(slen, e_string);
      s = StrLoc(ts);
      }
#endif					/* e_string */

   /*
    * Make sure there is enough room in the string space.
    */
   if (DiffPtrs(strend,strfree) < slen) {
      StrLen(ts) = slen;
      StrLoc(ts) = s;
      if (!reserve(Strings, slen)){
         return NULL;
      }
      s = StrLoc(ts);
      }

   strtotal += slen;

   /*
    * Copy the string into the string space, saving a pointer to its
    *  beginning.  Note that s may be null, in which case the space
    *  is still allocated but nothing is to be copied into it.
    *  memcpy() is slower for slen < 4 but faster for slen >> 4.
    */
   ofree = d = strfree;
   if (s) {
      if (slen >= 4) {
	 memcpy(d, s, slen);
	 d+= slen;
	 }
      else
	 while (slen-- > 0)
	    *d++ = *s++;
      }
   else
      d += slen;

   strfree = d;
   return ofree;
   }
#enddef

#ifdef MultiProgram
#passthru #undef alcstr
alcstr_macro(alcstr,0)
alcstr_macro(alcstr_1,E_String)
#else					/* MultiProgram */
alcstr_macro(alcstr,0)
#endif					/* MultiProgram */

#begdef alcsubs_macro(f, e_tvsubs)
/*
 * alcsubs - allocate a substring trapped variable in the block region.
 */

struct b_tvsubs *f(word len, word pos, dptr var)
   {
   tended struct descrip tvar = *var;
   register struct b_tvsubs *blk;

   EVVal(sizeof(struct b_tvsubs), e_tvsubs);
   AlcFixBlk(blk, b_tvsubs, T_Tvsubs)
   blk->sslen = len;
   blk->sspos = pos;
   blk->ssvar = tvar;
   return blk;
   }
#enddef

#ifdef MultiProgram
alcsubs_macro(alcsubs_0,0)
alcsubs_macro(alcsubs_1,E_Tvsubs)
#else					/* MultiProgram */
alcsubs_macro(alcsubs,0)
#endif					/* MultiProgram */

#begdef alctelem_macro(f, e_telem)
/*
 * alctelem - allocate a table element block in the block region.
 */

struct b_telem *f()
   {
   register struct b_telem *blk;
   CURTSTATE();

   EVVal(sizeof (struct b_telem), e_telem);
   AlcFixBlk(blk, b_telem, T_Telem)
   blk->hashnum = 0;
   blk->clink = NULL;
   blk->tref = nulldesc;
   return blk;
   }
#enddef

#ifdef MultiProgram
alctelem_macro(alctelem_0,0)
alctelem_macro(alctelem_1,E_Telem)
#else					/* MultiProgram */
alctelem_macro(alctelem,0)
#endif					/* MultiProgram */

#begdef alctvtbl_macro(f,e_tvtbl)
/*
 * alctvtbl - allocate a table element trapped variable block in the block
 *  region.
 */

struct b_tvtbl *f(register dptr tbl, register dptr ref, uword hashnum)
   {
   tended struct descrip ttbl = *tbl;
   tended struct descrip tref = *ref;
   register struct b_tvtbl *blk;

   EVVal(sizeof (struct b_tvtbl), e_tvtbl);
   AlcFixBlk(blk, b_tvtbl, T_Tvtbl)
   blk->hashnum = hashnum;
   blk->clink = BlkLoc(ttbl);
   blk->tref = tref;
   return blk;
   }
#enddef

#ifdef MultiProgram
alctvtbl_macro(alctvtbl_0,0)
alctvtbl_macro(alctvtbl_1,E_Tvtbl)
#else					/* MultiProgram */
alctvtbl_macro(alctvtbl,0)
#endif					/* MultiProgram */

#ifdef EventMon
#begdef alctvmonitored_macro(f)
/*
 * alctvmonitored - allocate a trapped monitored variable block in the block
 *  region. no need for event, unless the Monitor is a TP for another Monitor.
 */

struct b_tvmonitored *f(register dptr tv, word count)
   {
   tended struct descrip vref = *tv;
   register struct b_tvmonitored *blk;

   AlcFixBlk(blk, b_tvmonitored,T_Tvmonitored);
   blk->tv = vref;
   blk->cur_actv = count;
   return blk;
   } 
#enddef

alctvmonitored_macro(alctvmonitored)
#endif					/* EventMon */


#begdef deallocate_macro(f,e_blkdealc)
/*
 * deallocate - return a block to the heap.
 *
 *  The block must be the one that is at the very end of a block region.
 */
void f (union block *bp)
{
   word nbytes;
   struct region *rp;
   CURTSTATE();
#ifdef Concurrent   /*   DO WE NEED THIS ? WE HAVE PRIVATE HEAPS NOW  */
   return;
#endif					/* Concurrent */
   nbytes = BlkSize(bp);
   for (rp = curblock; rp; rp = rp->next)
      if ((char *)bp + nbytes == rp->free)
         break;
   if (!rp)
      for (rp = curblock->prev; rp; rp = rp->prev)
	 if ((char *)bp + nbytes == rp->free)
            break;
   if (!rp)
      syserr ("deallocation botch");
   rp->free = (char *)bp;
   blktotal -= nbytes;
   EVVal(nbytes, e_blkdealc);
}
#enddef

#ifdef MultiProgram
deallocate_macro(deallocate_0,0)
deallocate_macro(deallocate_1,E_BlkDeAlc)
#else					/* MultiProgram */
deallocate_macro(deallocate,0)
#endif					/* MultiProgram */

#begdef reserve_macro(f,e_tenurestring,e_tenureblock)
/*
 * reserve -- ensure space in either string or block region.
 *
 *   1. check for space in current region.
 *   2. check for space in older regions.
 *   3. check for space in newer regions.
 *   4. set goal of 10% of size of newest region.
 *   5. collect regions, newest to oldest, until goal met.
 *   6. allocate new region at 200% the size of newest existing.
 *   7. reset goal back to original request.
 *   8. collect regions that were too small to bother with before.
 *   9. search regions, newest to oldest.
 *  10. give up and signal error.
 */

char *f(int region, word nbytes)
{
   struct region **pcurr, *curr_private, *rp;
   word want, newsize;
   extern int qualfail;
#ifdef Concurrent
   int mtx_heap;
   struct region **p_publicheap;
   CURTSTATE();
   if (region == Strings)
      pcurr = &curtstring;
   else
      pcurr = &curtblock;
#else 					/* Concurrent */
   if (region == Strings)
      pcurr = &curstring;
   else
      pcurr = &curblock;
#endif 					/* Concurrent */

   curr_private = *pcurr;

   /*
    * Check for space available now.
    */
   if (DiffPtrs(curr_private->end, curr_private->free) >= nbytes)
      return curr_private->free;   /* quick return: current region is OK */

/* check all regions on chain */
#ifdef Concurrent
   if ((rp = findgap(curr_private, nbytes, region)) != 0)
#else 					/* Concurrent */
   if ((rp = findgap(curr_private, nbytes)) != 0)
#endif 					/* Concurrent */   
      {
      *pcurr = rp;			/* switch regions */
      return rp->free;
      }

#ifndef Concurrent
   /*
    * Set "curr_private" to point to newest region.
    */
   while (curr_private->next)
      curr_private = curr_private->next;
      
   /*
    * Need to collect garbage.  To reduce thrashing, set a minimum requirement
    *  of 10% of the size of the newest region, and collect regions until that
    *  amount of free space appears in one of them.
    */
   want = (curr_private->size / 100) * memcushion;
   if (want < nbytes)
      want = nbytes;

   for (rp = curr_private; rp; rp = rp->prev)
      if (rp->size >= want) {	/* if large enough to possibly succeed */
         *pcurr = rp;
         collect(region);
         if (DiffPtrs(rp->end,rp->free) >= want)
            return rp->free;
         }
#else 					/* Concurrent */

   want = (curr_private->size / 100) * memcushion;
   if (want < nbytes)
      want = nbytes;

   SUSPEND_THREADS();
   collect(region); /* try to collect the private region first */
   if (DiffPtrs(curr_private->end,curr_private->free) >= want) {
      RESUME_THREADS();
      return curr_private->free;
      }

/* Only the GC is running  */
   if (region == Strings) {
      mtx_heap=MTX_STRHEAP;
      p_publicheap = &public_stringregion;
      }
   else{
      mtx_heap=MTX_BLKHEAP;
      p_publicheap = &public_blockregion;
      }

   /* look in the public heaps, */
   for (rp = *p_publicheap; rp; rp = rp->Tnext)
      /* if large enough to possibly succeed */
      if (rp->size >= want && rp->size>=curr_private->size/2) {
         curr_private = swap2publicheap(curr_private, rp, p_publicheap);
      	 *pcurr = curr_private;
         collect(region);
         if (DiffPtrs( curr_private->end, curr_private->free) >= want){
            RESUME_THREADS();
            return curr_private->free;
            }
         }
   
   /*
    * GC has failed so far to free enough memory, wake up all threads for now.
    */   
   RESUME_THREADS(); 
 #endif 					/* Concurrent */   

   /*
    * That didn't work.  Allocate a new region with a size based on the
    * newest previous region. memgrowth is a percentile number (defaulting
    * to 200, meaning "double each time"), so divide by 100.
    */
   newsize = (curr_private->size / 100) * memgrowth;
   if (newsize < (nbytes + memcushion))
      newsize = nbytes + memcushion;
   if (newsize < MinAbrSize)
      newsize = MinAbrSize;
     
   if ((rp = newregion(nbytes, newsize)) != 0) {
#ifdef Concurrent
      /* a new region is allocated, swap the current private
       * region out to the public list.
       */
      if (region == Strings){
         MUTEX_LOCKID_CONTROLLED(MTX_PUBLICSTRHEAP);
      	 swap2publicheap(curr_private, NULL, &public_stringregion);
         MUTEX_UNLOCKID(MTX_PUBLICSTRHEAP);
	 }
      else{
         MUTEX_LOCKID_CONTROLLED(MTX_PUBLICBLKHEAP);
      	 swap2publicheap(curr_private, NULL, &public_blockregion);
         MUTEX_UNLOCKID(MTX_PUBLICBLKHEAP);
	 }

      /*
       * Set "curr_private" to point to newest region.
       */
      MUTEX_LOCKID(mtx_heap);
      while (curr_private->next)
         curr_private = curr_private->next;
#endif 					/* Concurrent */
      rp->prev = curr_private;
      rp->next = NULL;
      curr_private->next = rp;
      rp->Gnext = curr_private;
      rp->Gprev = curr_private->Gprev;
      if (curr_private->Gprev) curr_private->Gprev->Gnext = rp;
      curr_private->Gprev = rp;
      MUTEX_UNLOCKID(mtx_heap);
      *pcurr = rp;
#if e_tenurestring || e_tenureblock
      {
      int tmp_noMTevents;
      MUTEX_LOCKID(MTX_NOMTEVENTS);
      tmp_noMTevents = noMTevents;
      MUTEX_UNLOCKID(MTX_NOMTEVENTS);

      if (!tmp_noMTevents) {
         if (region == Strings) {
            EVVal(rp->size, e_tenurestring);
            }
         else {
            EVVal(rp->size, e_tenureblock);
            }
         }
      }
#endif					/* e_tenurestring || e_tenureblock */
    return rp->free;
      }

   /*
    * Allocation failed.  Try to continue, probably thrashing all the way.
    *  Collect the regions that weren't collected before and see if any
    *  region has enough to satisfy the original request.
    */

#ifdef Concurrent
   //   fprintf(stderr, " !!! Low memory!! Trying all options !!!\n ");
   /* look in the public heaps, */
   SUSPEND_THREADS(); 

   /* public heaps might have got updated, resync, no need to lock!  */
   if (region == Strings)
      p_publicheap = &public_stringregion;
   else
      p_publicheap = &public_blockregion;

   for (rp = *p_publicheap; rp; rp = rp->Tnext)
      if (rp->size >= want) {		/* if not collected earlier */
         curr_private = swap2publicheap(curr_private, rp, p_publicheap);
         *pcurr = curr_private;
         collect(region);
         if (DiffPtrs(curr_private->end,curr_private->free) >= want){
   	    RESUME_THREADS(); 
            return curr_private->free;
            }
         }
   RESUME_THREADS(); 
   if ((rp = findgap(curr_private, nbytes, region)) != 0)    /* check all regions on chain */
   
#else 					/* Concurrent */
   for (rp = curr_private; rp; rp = rp->prev)
      if (rp->size >= want) {		/* if not collected earlier */
         *pcurr = rp;
         collect(region);
         if (DiffPtrs(rp->end,rp->free) >= want)
            return rp->free;
         }

   if ((rp = findgap(curr_private, nbytes)) != 0)
#endif 					/* Concurrent */   
   {
      *pcurr = rp;
      return rp->free;
      }

   /*
    * All attempts failed.
    */
   if (region == Blocks)
      ReturnErrNum(307, NULL);
   else if (qualfail)
      ReturnErrNum(304, NULL);
   else
      ReturnErrNum(306, NULL);
}
#enddef

#ifdef MultiProgram
reserve_macro(reserve_0,0,0)
reserve_macro(reserve_1,E_TenureString,E_TenureBlock)
#else					/* MultiProgram */
reserve_macro(reserve,0,0)
#endif					/* MultiProgram */


#ifdef Concurrent
/*
 * swap the thread current region (curr_private) with curr_public from the
 * public heaps. The switch is done in the chain and a pointer to the new private
 * region is returned.
 * IMPORTANT: This function assumes that the public heap in use is locked.
 */
struct region *swap2publicheap( curr_private, curr_public, p_public)
struct region *curr_private;
struct region *curr_public;
struct region **p_public; /* pointer to the head of the list*/
  {
   if (curr_public){
      curr_private->Tnext = curr_public->Tnext;
      curr_private->Tprev = curr_public->Tprev;

      if (curr_public->Tnext){
	curr_private->Tnext->Tprev = curr_private;
	curr_public->Tnext = NULL;
	if (curr_public->Tprev){ /* middle node*/
	  curr_private->Tprev->Tnext = curr_private;
	  curr_public->Tprev = NULL;
	  }
	else
	  *p_public = curr_private;
	}
      else if (curr_public->Tprev){
	curr_private->Tprev->Tnext = curr_private;
	curr_public->Tprev = NULL;
	}
      else
	*p_public = curr_private;
     } 
    else { /* NO SWAP: some thread is giving up his heap. 
    	      Just insert curr_private into the public heap. */
	curr_private->Tprev=NULL;
	if (*p_public==NULL)
	   curr_private->Tnext=NULL;
	else{
	   curr_private->Tnext=*p_public;
	   curr_private->Tnext->Tprev=curr_private;
	   }
   	*p_public=curr_private;
	return NULL;
      }
   
   return curr_public;
  }
#endif 					/* Concurrent */

/*
 * findgap - search region chain for a region having at least nbytes available
 */
#ifdef Concurrent
static struct region *findgap(curr_private, nbytes, region)
struct region *curr_private;
word nbytes;
int region;
#else 					/* Concurrent */
static struct region *findgap(curr, nbytes)
struct region *curr;
word nbytes;
#endif 					/* Concurrent */
   {
   struct region *rp;
   
#ifdef Concurrent
   if (region == Strings){
      MUTEX_LOCKID_CONTROLLED(MTX_PUBLICSTRHEAP);
      for (rp = public_stringregion; rp; rp = rp->Tnext)
         if (DiffPtrs(rp->end, rp->free) >= nbytes && rp->size>=curr_private->size/2)
            break;
         
      if (rp) 
         rp=swap2publicheap(curr_private, rp, &public_stringregion);
      MUTEX_UNLOCKID(MTX_PUBLICSTRHEAP);
      }
   else{
      MUTEX_LOCKID_CONTROLLED(MTX_PUBLICBLKHEAP);
      for (rp = public_blockregion; rp; rp = rp->Tnext)
         if (DiffPtrs(rp->end, rp->free) >= nbytes && rp->size>=curr_private->size/2)
            break;
         
      if (rp) 
         rp=swap2publicheap(curr_private, rp, &public_blockregion);
      MUTEX_UNLOCKID(MTX_PUBLICBLKHEAP);
      }

   return rp;
#else 					/* Concurrent */
/* With ThreadHeap, skip this, we know we are at the front of the list */
   for (rp = curr; rp; rp = rp->prev)
      if (DiffPtrs(rp->end, rp->free) >= nbytes)
         return rp;
   for (rp = curr->next; rp; rp = rp->next)
      if (DiffPtrs(rp->end, rp->free) >= nbytes)
         return rp;
   return NULL;
#endif 					/* Concurrent */
   }

/*
 * newregion - try to malloc a new region and tenure the old one,
 *  backing off if the requested size fails.
 */
struct region *newregion(nbytes,stdsize)
word nbytes,stdsize;
{
   uword minSize = MinAbrSize;
   struct region *rp;

#if IntBits == 16
   if ((uword)nbytes > (uword)MaxBlock)
      return NULL;
   if ((uword)stdsize > (uword)MaxBlock)
      stdsize = (uword)MaxBlock;
#endif					/* IntBits == 16 */

   if ((uword)nbytes > minSize)
      minSize = (uword)nbytes;

   rp = (struct region *)malloc(sizeof(struct region));
   if (rp) {
      rp->size = stdsize;
#if IntBits == 16
      if ((rp->size < nbytes) && (nbytes < (unsigned int)MaxBlock))
         rp->size = Min(nbytes+stdsize,(unsigned int)MaxBlock);
#else					/* IntBits == 16 */
      if (rp->size < nbytes)
         rp->size = Max(nbytes+stdsize, nbytes);
#endif					/* IntBits == 16 */

      do {
         rp->free = rp->base = (char *)AllocReg(rp->size);
         if (rp->free != NULL) {
            rp->end = rp->base + rp->size;
            rp->next = rp->prev = NULL;
#ifdef Concurrent
	    rp->Tnext=NULL;
	    rp->Tprev=NULL;
#endif 					/* Concurrent */   
            return rp;
            }
         rp->size = (rp->size + nbytes)/2 - 1;
         }
      while (rp->size >= minSize);
      free((char *)rp);
      }
   return NULL;
}

#ifdef Arrays

struct b_intarray *alcintarray(uword n)
{
   int bsize = sizeof(struct b_intarray) + (n-1) * sizeof(word);
   register struct b_intarray *blk;
   CURTSTATE();

   AlcBlk(blk, b_intarray, T_Intarray, bsize);
   blk->blksize = bsize;
   blk->dims = NULL;
   blk->listp = NULL;
   return blk;
}

struct b_realarray *alcrealarray(uword n)
{
   int bsize = sizeof(struct b_realarray) + (n-1) * sizeof(double);
   register struct b_realarray *blk;
   CURTSTATE();

   AlcBlk(blk, b_realarray, T_Realarray, bsize);
   blk->blksize = bsize;
   blk->dims = NULL;
   blk->listp = NULL;
   return blk;
}

#endif					/* Arrays */
