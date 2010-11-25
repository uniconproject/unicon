/*
 * File: ralc.r
 *  Contents: allocation routines
 */

/*
 * Prototypes.
 */
#ifdef ThreadHeap
static struct region *findgap(struct region *curr_private, word nbytes, int region);
static struct region *switchtopublicheap(struct region *curr_private,
      struct region *curr_public, struct region **pcurr_public);
#else 					/* ThreadHeap */
static struct region *findgap	(struct region *curr, word nbytes);
#endif 					/* ThreadHeap */

extern word alcnum;

#ifdef Concurrent 
   pthread_mutex_t mutex_alcblk;
   pthread_mutex_t mutex_alcstr;
#endif					/* Concurrent */

#ifndef MultiThread
word coexp_ser = 2;	/* serial numbers for co-expressions; &main is 1 */
word list_ser = 1;	/* serial numbers for lists */
#ifdef PatternType
word pat_ser = 1;	/* serial numbers for patterns */
#endif					/* PatternType */
word set_ser = 1;	/* serial numbers for sets */
word table_ser = 1;	/* serial numbers for tables */
#endif					/* MultiThread */


/*
 * AlcBlk - allocate a block.
 */
#begdef AlcBlk(var, struct_nm, t_code, nbytes)
{
   /*
    * Ensure that there is enough room in the block region.
    */
#ifndef ThreadHeap
   MUTEX_LOCK(mutex_alcblk, "mutex_alcblk");
#endif					/* ThreadHeap */

   if (DiffPtrs(blkend,blkfree) < nbytes && !reserve(Blocks, nbytes)){
#ifndef ThreadHeap
      MUTEX_UNLOCK(mutex_alcblk, "mutex_alcblk");
#endif					/* ThreadHeap */
      return NULL;
      }

   /*
    * Decrement the free space in the block region by the number of bytes
    *  allocated and return the address of the first byte of the allocated
    *  block.
    */
   blktotal += nbytes;
   var = (struct struct_nm *)blkfree;
   blkfree += nbytes;
   var->title = t_code;
#ifndef ThreadHeap
   MUTEX_UNLOCK(mutex_alcblk, "mutex_alcblk");
#endif					/* ThreadHeap */
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

   abp = (struct astkblk *)malloc((msize)sizeof(struct astkblk));

   /*
    * If malloc failed, attempt to free some co-expression blocks and retry.
    */
   if (abp == NULL) {
      collect(Static);
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

   size = sizeof(struct b_bignum) + ((n - 1) * sizeof(DIGIT));
   /* ensure whole number of words allocated */
   size = (size + WordSize - 1) & -WordSize;

   EVVal((word)size, e_lrgint);

   AlcBlk(blk, b_bignum, T_Lrgint, size);
   blk->blksize = size;
   blk->msd = blk->sign = 0;
   blk->lsd = n - 1;
   return blk;
   }
#enddef
#ifdef MultiThread
alcbignum_macro(alcbignum_0,0)
alcbignum_macro(alcbignum_1,E_Lrgint)
#else					/* MultiThread */
alcbignum_macro(alcbignum,0)
#endif					/* MultiThread */

#endif					/* LargeInts */

/*
 * alccoexp - allocate a co-expression stack block.
 */

#if COMPILER
struct b_coexpr *alccoexp()
   {
   struct b_coexpr *ep;
   ep = (struct b_coexpr *)malloc((msize)stksize);

   /*
    * If malloc failed or if there have been too many co-expression allocations
    * since a collection, attempt to free some co-expression blocks and retry.
    */

   if (ep == NULL || alcnum > AlcMax) {
      collect(Static);
      ep = (struct b_coexpr *)malloc((msize)stksize);
      }

   if (ep == NULL)
      ReturnErrNum(305, NULL);

   alcnum++;                    /* increment allocation count since last g.c. */

   ep->title = T_Coexpr;
   ep->size = 0;
   MUTEX_LOCKID(MTX_COEXP_SER);
   ep->id = coexp_ser++;
   MUTEX_UNLOCKID(MTX_COEXP_SER);
   ep->es_tend = NULL;
   ep->file_name = "";
   ep->line_num = 0;
   ep->freshblk = nulldesc;
   ep->es_actstk = NULL;
   MUTEX_LOCK(mutex_stklist, "mutex_stklist");
   ep->nextstk = stklist;
   stklist = ep;
   MUTEX_UNLOCK(mutex_stklist, "mutex_stklist");
   return ep;
   }
#else					/* COMPILER */
#ifdef MultiThread
/*
 * If this is a new program being loaded, an icodesize>0 gives the
 * hdr.hsize and a stacksize to use; allocate
 * sizeof(progstate) + icodesize + mstksize
 * Otherwise (icodesize==0), allocate a normal stksize...
 */
struct b_coexpr *alccoexp(icodesize, stacksize)
long icodesize, stacksize;
#else					/* MultiThread */
struct b_coexpr *alccoexp()
#endif					/* MultiThread */

   {
   struct b_coexpr *ep;

#ifdef MultiThread
   if (icodesize > 0) {
      ep = (struct b_coexpr *)
	calloc(1, (msize)(stacksize + icodesize + sizeof(struct progstate) +
			  sizeof(struct threadstate) + sizeof(struct b_coexpr)));
      }
   else
#endif					/* MultiThread */
      {
   ep = (struct b_coexpr *)malloc((msize)stksize);
   }

   /*
    * If malloc failed or there have been too many co-expression allocations
    * since a collection, attempt to free some co-expression blocks and retry.
    */

   if (ep == NULL || alcnum > AlcMax) {
      collect(Static);

#ifdef MultiThread
      if (icodesize>0) {
         ep = (struct b_coexpr *)
	    malloc((msize)(mstksize+icodesize+sizeof(struct progstate)+sizeof(struct threadstate)));
         }
      else
#endif					/* MultiThread */

         ep = (struct b_coexpr *)malloc((msize)stksize);
      }
   if (ep == NULL)
      ReturnErrNum(305, NULL);

   alcnum++;		/* increment allocation count since last g.c. */

   ep->title = T_Coexpr;
   ep->es_actstk = NULL;
   ep->size = 0;
#ifdef MultiThread
   ep->es_pfp = NULL;
   ep->es_gfp = NULL;
   ep->es_argp = NULL;
   ep->tvalloc = NULL;

   if (icodesize > 0)
      ep->id = 1;
   else{
#endif					/* MultiThread */
      MUTEX_LOCKID(MTX_COEXP_SER);
      ep->id = coexp_ser++;
      MUTEX_UNLOCKID(MTX_COEXP_SER);
#ifdef MultiThread
   }
#endif					/* MultiThread */

#ifdef Concurrent
      ep->status = 0;
      ep->squeue = ep->rqueue = NULL;
#endif					/* Concurrent */

      ep->es_tend = NULL;

#ifdef MultiThread
   /*
    * Initialize program state to self for &main; curpstate for others.
    */
   if(icodesize>0){
     ep->program = (struct progstate *)(ep+1);
     ep->program->tstate = (struct threadstate *) (ep->program + 1);
     }
   else ep->program = curpstate;
#endif					/* MultiThread */

#ifdef PthreadCoswitch
/*
 * Allocate a struct context for this co-expression.
 */
{
   cstate ncs = (cstate) (ep->cstate);
   context *ctx;
   ctx = ncs[1] = alloc(sizeof (struct context));
   makesem(ctx);
   ctx->c = ep;
}
#endif					/* PthreadCoswitch */

   MUTEX_LOCK(mutex_stklist, "mutex_stklist");
   ep->nextstk = stklist;
   stklist = ep;
   MUTEX_UNLOCK(mutex_stklist, "mutex_stklist");
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
#ifdef MultiThread
alccset_macro(alccset_0,0)
alccset_macro(alccset_1,E_Cset)
#else					/* MultiThread */
alccset_macro(alccset,0)
#endif					/* MultiThread */


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
   pthread_mutex_init(&(blk->mutex), NULL);
#endif				/* Concurrent */
   return blk;
   }
#enddef

#ifdef MultiThread
alcfile_macro(alcfile_0,0)
alcfile_macro(alcfile_1,E_File)
#else					/* MultiThread */
alcfile_macro(alcfile,0)
#endif					/* MultiThread */

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

   if (tcode == T_Table) {
      EVVal(sizeof(struct b_table), e_table);
      AlcFixBlk(pt, b_table, T_Table);
      ps = (struct b_set *)pt;
      MUTEX_LOCK(static_mutexes[MTX_TABLE_SER], "MTX_TABLE_SER");
      ps->id = table_ser++;
      MUTEX_UNLOCK(static_mutexes[MTX_TABLE_SER], "MTX_TABLE_SER");
      }
   else {	/* tcode == T_Set */
      EVVal(sizeof(struct b_set), e_set);
      AlcFixBlk(ps, b_set, T_Set);
      MUTEX_LOCK(static_mutexes[MTX_SET_SER], "MTX_SET_SER");
      ps->id = set_ser++;
      MUTEX_UNLOCK(static_mutexes[MTX_SET_SER], "MTX_SET_SER");
      }
   ps->size = 0;
   ps->mask = 0;
   for (i = 0; i < HSegs; i++)
      ps->hdir[i] = NULL;
   return (union block *)ps;
   }
#enddef

#ifdef MultiThread
alchash_macro(alchash_0,0,0)
alchash_macro(alchash_1,E_Table,E_Set)
#else					/* MultiThread */
alchash_macro(alchash,0,0)
#endif					/* MultiThread */

#begdef alcsegment_macro(f,e_slots)
/*
 * alcsegment - allocate a slot block in the block region.
 */

struct b_slots *f(word nslots)
   {
   uword size;
   register struct b_slots *blk;

   size = sizeof(struct b_slots) + WordSize * (nslots - HSlots);
   EVVal(size, e_slots);
   AlcBlk(blk, b_slots, T_Slots, size);
   blk->blksize = size;
   while (--nslots >= 0)
      blk->hslots[nslots] = NULL;
   return blk;
   }
#enddef

#ifdef MultiThread
alcsegment_macro(alcsegment_0,0)
alcsegment_macro(alcsegment_1,E_Slots)
#else					/* MultiThread */
alcsegment_macro(alcsegment,0)
#endif					/* MultiThread */


#ifdef PatternType

#begdef alcpattern_macro(f, e_pattern, e_pelem)

struct b_pattern *f(word stck_size)
{
   register struct b_pattern *pheader;
   register struct b_pelem *pelem;
   
   if (!reserve(Blocks, (word)
		( sizeof(struct b_pattern) + sizeof(struct b_pelem))))
      return NULL; 
   EVVal(sizeof (struct b_pattern), e_pattern);
   EVVal(sizeof (struct b_pelem), e_pelem);
   AlcFixBlk(pheader, b_pattern, T_Pattern)
   pheader->stck_size = stck_size;
   MUTEX_LOCK(static_mutexes[MTX_PAT_SER], "MTX_PAT_SER");
   pheader->id = pat_ser++;
   MUTEX_UNLOCK(static_mutexes[MTX_PAT_SER], "MTX_PAT_SER");
   pheader->pe = NULL;
   return pheader;
}
#enddef

#ifdef MultiThread
alcpattern_macro(alcpattern_0,0,0)
alcpattern_macro(alcpattern_1,E_Pattern,E_Pelem)
#else					/* MultiThread */
alcpattern_macro(alcpattern,0,0)
#endif					/* MultiThread */


#begdef alcpelem_macro(f, e_pelem)

struct b_pelem *f( word patterncode)
{
   register struct b_pelem *pelem;
   
   if (!reserve(Blocks, (word)
		(sizeof(struct b_pelem))
		)
       ) return NULL;
   EVVal(sizeof (struct b_pelem), e_pelem);
   AlcFixBlk(pelem, b_pelem, T_Pelem)
   pelem->pcode = patterncode;
   pelem->pthen = NULL;
   return pelem;
   }
#enddef

#ifdef MultiThread
alcpelem_macro(alcpelem_0,0)
alcpelem_macro(alcpelem_1,E_Pelem)
#else					/* MultiThread */
alcpelem_macro(alcpelem,0)
#endif					/* MultiThread */


#endif					/* PatternType */

/*
 * allocate just a list header block.  internal use only (alc*array family).
 */
struct b_list *alclisthdr(uword size, union block *bptr)
{
   register struct b_list *blk;
   AlcFixBlk(blk, b_list, T_List)
   blk->size = size;
   MUTEX_LOCK(static_mutexes[MTX_LIST_SER], "MTX_LIST_SER");
   blk->id = list_ser++;
   MUTEX_UNLOCK(static_mutexes[MTX_LIST_SER], "MTX_LIST_SER");
   blk->listhead = bptr;
   blk->listtail = NULL;
#ifdef Arrays
   ( (struct b_realarray *) bptr)->listp = (union block *)blk;
#endif					/* Arrays */
   return blk;
}


#begdef alclist_raw_macro(f, e_list, e_lelem)
/*
 * alclist - allocate a list header block in the block region.
 *  A corresponding list element block is also allocated.
 *  Forces a g.c. if there's not enough room for the whole list.
 *  The "alclstb" code inlined so as to avoid duplicated initialization.
 *
 * alclist_raw() - as per alclist(), except initialization is left to
 * the caller, who promises to initialize first n==size slots w/o allocating.
 */

struct b_list *f(uword size, uword nslots)
   {
   register struct b_list *blk;
   register struct b_lelem *lblk;
   register word i;

   if (!reserve(Blocks, (word)(sizeof(struct b_list) + sizeof (struct b_lelem)
      + (nslots - 1) * sizeof(struct descrip)))) return NULL;
   EVVal(sizeof (struct b_list), e_list);
   EVVal(sizeof (struct b_lelem) + (nslots-1) * sizeof(struct descrip), e_lelem);
   AlcFixBlk(blk, b_list, T_List)
   AlcVarBlk(lblk, b_lelem, T_Lelem, nslots)
   blk->size = size;
   MUTEX_LOCK(static_mutexes[MTX_LIST_SER], "MTX_LIST_SER");
   blk->id = list_ser++;
   MUTEX_UNLOCK(static_mutexes[MTX_LIST_SER], "MTX_LIST_SER");

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

#ifdef MultiThread
#passthru #undef alclist_raw
alclist_raw_macro(alclist_raw,0,0)
alclist_raw_macro(alclist_raw_1,E_List,E_Lelem)
#else					/* MultiThread */
alclist_raw_macro(alclist_raw,0,0)
#endif					/* MultiThread */

#begdef alclist_macro(f,e_list,e_lelem)

struct b_list *f(uword size, uword nslots)
{
   register word i = sizeof(struct b_lelem)+(nslots-1)*sizeof(struct descrip);
   register struct b_list *blk;
   register struct b_lelem *lblk;

   if (!reserve(Blocks, (word)(sizeof(struct b_list) + i))) return NULL;
   EVVal(sizeof (struct b_list), e_list);
   EVVal(i, e_lelem);
   AlcFixBlk(blk, b_list, T_List)
   AlcBlk(lblk, b_lelem, T_Lelem, i)
   blk->size = size;
   MUTEX_LOCK(static_mutexes[MTX_LIST_SER], "MTX_LIST_SER");
   blk->id = list_ser++;
   MUTEX_UNLOCK(static_mutexes[MTX_LIST_SER], "MTX_LIST_SER");
   blk->listhead = blk->listtail = (union block *)lblk;
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

#ifdef MultiThread
alclist_macro(alclist_0,0,0)
alclist_macro(alclist_1,E_List,E_Lelem)
#else					/* MultiThread */
alclist_macro(alclist,0,0)
#endif					/* MultiThread */

#begdef alclstb_macro(f,t_lelem)
/*
 * alclstb - allocate a list element block in the block region.
 */

struct b_lelem *f(uword nslots, uword first, uword nused)
   {
   register struct b_lelem *blk;
   register word i;

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

#ifdef MultiThread
alclstb_macro(alclstb_0,0)
alclstb_macro(alclstb_1,E_Lelem)
#else					/* MultiThread */
alclstb_macro(alclstb,0)
#endif					/* MultiThread */

#begdef alcreal_macro(f,e_real)
/*
 * alcreal - allocate a real value in the block region.
 */

struct b_real *f(double val)
   {
   register struct b_real *blk;

   EVVal(sizeof (struct b_real), e_real);
   AlcFixBlk(blk, b_real, T_Real)

#ifdef Double
/* access real values one word at a time */
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

#ifdef MultiThread
#passthru #undef alcreal
alcreal_macro(alcreal,0)
alcreal_macro(alcreal_1,E_Real)
#else					/* MultiThread */
alcreal_macro(alcreal,0)
#endif					/* MultiThread */

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
   MUTEX_LOCK(mutex_recid, "mutex_recid");
   blk->id = (((struct b_proc *)recptr)->recid)++;
   MUTEX_UNLOCK(mutex_recid, "mutex_recid");
   return blk;
   }
#enddef

#ifdef MultiThread
alcrecd_macro(alcrecd_0,0)
alcrecd_macro(alcrecd_1,E_Record)
#else					/* MultiThread */
alcrecd_macro(alcrecd,0)
#endif					/* MultiThread */

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

   AlcVarBlk(blk, b_refresh, T_Refresh, na + nl);
   blk->ep = entryx;
   blk->nlocals = nl;
   return blk;
   }

#enddef

#ifdef MultiThread
alcrefresh_macro(alcrefresh_0,0)
alcrefresh_macro(alcrefresh_1,E_Refresh)
#else					/* MultiThread */
alcrefresh_macro(alcrefresh,0)
#endif					/* MultiThread */
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

#ifdef MultiThread
alcselem_macro(alcselem_0,0)
alcselem_macro(alcselem_1,E_Selem)
#else					/* MultiThread */
alcselem_macro(alcselem,0)
#endif					/* MultiThread */

#begdef alcstr_macro(f,e_string)
/*
 * alcstr - allocate a string in the string space.
 */

char *f(register char *s, register word slen)
   {
   tended struct descrip ts;
   register char *d;
   char *ofree;

#ifdef MultiThread
   StrLen(ts) = slen;
   StrLoc(ts) = s;
#if E_String
   MUTEX_LOCK(mutex_noMTevents, "mutex_noMTevents");
   if (!noMTevents)
      EVVal(slen, e_string);
   MUTEX_UNLOCK(mutex_noMTevents, "mutex_noMTevents");
#endif					/* E_String */
   s = StrLoc(ts);
#endif					/* MultiThread */

   /*
    * Make sure there is enough room in the string space.
    */
#ifndef ThreadHeap 
   MUTEX_LOCK(mutex_alcstr, "mutex_enoughStringSpace");
#endif					/* ThreadHeap */

   if (DiffPtrs(strend,strfree) < slen) {
      StrLen(ts) = slen;
      StrLoc(ts) = s;
      if (!reserve(Strings, slen)){
#ifndef ThreadHeap
 	MUTEX_UNLOCK(mutex_alcstr,"mutex_alcstr");
#endif					/* ThreadHeap */
         return NULL;
      }
      s = StrLoc(ts);
      }

   strtotal += slen;

   /*
    * Copy the string into the string space, saving a pointer to its
    *  beginning.  Note that s may be null, in which case the space
    *  is still to be allocated but nothing is to be copied into it.
    */
   ofree = d = strfree;
   if (s) {
      while (slen-- > 0)
         *d++ = *s++;
      }
   else
      d += slen;

   strfree = d;
#ifndef ThreadHeap
     MUTEX_UNLOCK(mutex_alcstr,"mutex_alcstr");
#endif					/* ThreadHeap */
   return ofree;
   }
#enddef

#ifdef MultiThread
#passthru #undef alcstr
alcstr_macro(alcstr,0)
alcstr_macro(alcstr_1,E_String)
#else					/* MultiThread */
alcstr_macro(alcstr,0)
#endif					/* MultiThread */

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

#ifdef MultiThread
alcsubs_macro(alcsubs_0,0)
alcsubs_macro(alcsubs_1,E_Tvsubs)
#else					/* MultiThread */
alcsubs_macro(alcsubs,0)
#endif					/* MultiThread */

#begdef alctelem_macro(f, e_telem)
/*
 * alctelem - allocate a table element block in the block region.
 */

struct b_telem *f()
   {
   register struct b_telem *blk;

   EVVal(sizeof (struct b_telem), e_telem);
   AlcFixBlk(blk, b_telem, T_Telem)
   blk->hashnum = 0;
   blk->clink = NULL;
   blk->tref = nulldesc;
   return blk;
   }
#enddef

#ifdef MultiThread
alctelem_macro(alctelem_0,0)
alctelem_macro(alctelem_1,E_Telem)
#else					/* MultiThread */
alctelem_macro(alctelem,0)
#endif					/* MultiThread */

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

#ifdef MultiThread
alctvtbl_macro(alctvtbl_0,0)
alctvtbl_macro(alctvtbl_1,E_Tvtbl)
#else					/* MultiThread */
alctvtbl_macro(alctvtbl,0)
#endif					/* MultiThread */

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
#if defined(Concurrent) /* && !defined(ThreadHeap)*/
   return;
#endif					/* Concurrent && !ThreadHeap */
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

#ifdef MultiThread
deallocate_macro(deallocate_0,0)
deallocate_macro(deallocate_1,E_BlkDeAlc)
#else					/* MultiThread */
deallocate_macro(deallocate,0)
#endif					/* MultiThread */

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
   struct region **pcurr, *curr, *rp;
   word want, newsize;
   extern int qualfail;
#ifdef ThreadHeap
   int mtx_publicheap, mtx_heap;
   struct region *curr_private, **pcurr_public;
   if (region == Strings){
      mtx_publicheap = MTX_PUBLICSTRHEAP;
      mtx_heap=MTX_STRHEAP;
      pcurr = &curtstring;
      curr_private = curtstring;
      pcurr_public = &public_stringregion;
   }
   else{
      mtx_publicheap = MTX_PUBLICBLKHEAP;
      mtx_heap=MTX_BLKHEAP;
      pcurr = &curtblock;
      curr_private = curtblock;
      pcurr_public = &public_blockregion;
   }
#else 					/* ThreadHeap */
   if (region == Strings)
      pcurr = &curstring;
   else
      pcurr = &curblock;
#endif 					/* ThreadHeap */

   curr = *pcurr;

   /*
    * Check for space available now.
    */
   if (DiffPtrs(curr->end, curr->free) >= nbytes)
      return curr->free;		/* quick return: current region is OK */


#ifdef ThreadHeap
   if ((rp = findgap(curr_private, nbytes, region)) != 0)    /* check all regions on chain */
#else 					/* ThreadHeap */
   if ((rp = findgap(curr, nbytes)) != 0)     /* check all regions on chain */
#endif 					/* ThreadHeap */   
      {
      *pcurr = rp;			/* switch regions */
      return rp->free;
      }

   /*
    * Set "curr" to point to newest region.
    */
   while (curr->next)
      curr = curr->next;
      
   /*
    * Need to collect garbage.  To reduce thrashing, set a minimum requirement
    *  of 10% of the size of the newest region, and collect regions until that
    *  amount of free space appears in one of them.
    */
   want = (curr->size / 100) * memcushion;
   if (want < nbytes)
      want = nbytes;

#ifndef ThreadHeap
   for (rp = curr; rp; rp = rp->prev)
      if (rp->size >= want) {	/* if large enough to possibly succeed */
         *pcurr = rp;
         collect(region);
         if (DiffPtrs(rp->end,rp->free) >= want)
            return rp->free;
         }
#else 					/* ThreadHeap */
   collect(region); /* try to collect the private region first */
   if (DiffPtrs(curr_private->end,curr_private->free) >= want)
      return curr_private->free;
      
   /* look in the public heaps, */
   MUTEX_LOCKID(mtx_publicheap);
   for (rp = *pcurr_public; rp; rp = rp->Tnext)
      if (rp->size >= want) {	/* if large enough to possibly succeed */
         *pcurr = rp;
         collect(region);
         if (DiffPtrs(rp->end,rp->free) >= want){
            switchtopublicheap(curr_private, rp, pcurr_public);
	    MUTEX_UNLOCKID(mtx_publicheap);
            return rp->free;
            }
         }
   MUTEX_UNLOCKID(mtx_publicheap);
   
   MUTEX_LOCKID(mtx_heap);
#endif 					/* ThreadHeap */   

   /*
    * That didn't work.  Allocate a new region with a size based on the
    * newest previous region.
    */
   newsize = (curr->size / 100) * memgrowth;
   if (newsize < nbytes)
      newsize = nbytes;
   if (newsize < MinAbrSize)
      newsize = MinAbrSize;

   if ((rp = newregion(nbytes, newsize)) != 0) {
     int tmp_noMTevents;
      MUTEX_LOCKID(mtx_heap);
      rp->prev = curr;
      rp->next = NULL;
      curr->next = rp;
      rp->Gnext = curr;
      rp->Gprev = curr->Gprev;
      if (curr->Gprev) curr->Gprev->Gnext = rp;
      curr->Gprev = rp;
      MUTEX_UNLOCKID(mtx_heap);
      *pcurr = rp;
#ifdef ThreadHeap
      MUTEX_LOCKID(mtx_publicheap);
      switchtopublicheap(curr_private, rp, pcurr_public);
      MUTEX_UNLOCKID(mtx_publicheap);
#endif 					/* ThreadHeap */       
#if e_tenurestring || e_tenureblock
      MUTEX_LOCK(mutex_noMTevents, "mutex_noMTevents");
      tmp_noMTevents = noMTevents;
      MUTEX_UNLOCK(mutex_noMTevents, "mutex_noMTevents");

      if (!tmp_noMTevents) {
         if (region == Strings) {
            EVVal(rp->size, e_tenurestring);
            }
         else {
            EVVal(rp->size, e_tenureblock);
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
#ifdef ThreadHeap
   /* look in the public heaps, */
   MUTEX_LOCKID(mtx_publicheap);
   for (rp = *pcurr_public; rp; rp = rp->Tnext)
      if (rp->size < want) {		/* if not collected earlier */
         *pcurr = rp;
         collect(region);
         if (DiffPtrs(rp->end,rp->free) >= want){
            switchtopublicheap(curr_private, rp, pcurr_public);
	    MUTEX_UNLOCKID(mtx_publicheap);
            return rp->free;
            }
         }
   MUTEX_UNLOCKID(mtx_publicheap);
   
   if ((rp = findgap(curr_private, nbytes, region)) != 0)    /* check all regions on chain */
   
#else 					/* ThreadHeap */
   for (rp = curr; rp; rp = rp->prev)
      if (rp->size < want) {		/* if not collected earlier */
         *pcurr = rp;
         collect(region);
         if (DiffPtrs(rp->end,rp->free) >= want)
            return rp->free;
         }

   if ((rp = findgap(curr, nbytes)) != 0)
#endif 					/* ThreadHeap */   
   {
      *pcurr = rp;
      return rp->free;
      }

   /*
    * All attempts failed.
    */
   if (region == Blocks)
      ReturnErrNum(307, 0);
   else if (qualfail)
      ReturnErrNum(304, 0);
   else
      ReturnErrNum(306, 0);
}
#enddef

#ifdef MultiThread
reserve_macro(reserve_0,0,0)
reserve_macro(reserve_1,E_TenureString,E_TenureBlock)
#else					/* MultiThread */
reserve_macro(reserve,0,0)
#endif					/* MultiThread */


#ifdef ThreadHeap
/*
 * switch the thread current region (curr_private) with curr_public from the
 * public heaps. The switch is done in the chain and a pointer to the new private
 * region is returned.
 * IMPORTANT: This function assumes that the public heap in use is locked.
 */
static struct region *switchtopublicheap(curr_private, curr_public, pcurr_public)
struct region *curr_private;
struct region *curr_public;
struct region **pcurr_public; /* pointer to the head of the list*/
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
	  *pcurr_public = curr_private;
	}
      else if (curr_public->Tprev){
	curr_private->Tprev->Tnext = curr_private;
	curr_public->Tprev = NULL;
	}
      else
	*pcurr_public = curr_private;
      }
   
   return curr_public;
  }
#endif 					/* ThreadHeap */

/*
 * findgap - search region chain for a region having at least nbytes available
 */
#ifdef ThreadHeap
static struct region *findgap(curr_private, nbytes, region)
struct region *curr_private;
word nbytes;
int region;
#else 					/* ThreadHeap */
static struct region *findgap(curr, nbytes)
struct region *curr;
word nbytes;
#endif 					/* ThreadHeap */
   {
   struct region *rp;
   
#ifdef ThreadHeap
   struct region **pcurr_public;
   struct region *curr;
   int mtx_publicheap;
   if (region == Strings){
      curr = public_stringregion;
      pcurr_public = &public_stringregion;
      mtx_publicheap = MTX_PUBLICSTRHEAP;
      }
   else{
      curr = public_blockregion;
      pcurr_public = &public_blockregion;
      mtx_publicheap = MTX_PUBLICBLKHEAP;
      }
   
   MUTEX_LOCKID(mtx_publicheap);
   for (rp = curr; rp; rp = rp->next)
      if (DiffPtrs(rp->end, rp->free) >= nbytes)
         break;
         
   if (rp) rp=switchtopublicheap(curr_private, rp, pcurr_public);
   MUTEX_UNLOCKID(mtx_publicheap);

   return rp;
#else 					/* ThreadHeap */
/* With ThreadHeap, skip this, we know we are at the front of the list */
   for (rp = curr; rp; rp = rp->prev)
      if (DiffPtrs(rp->end, rp->free) >= nbytes)
         return rp;
   for (rp = curr->next; rp; rp = rp->next)
      if (DiffPtrs(rp->end, rp->free) >= nbytes)
         return rp;
   return NULL;
#endif 					/* ThreadHeap */
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
#ifdef ThreadHeap
	    rp->Tnext=NULL;
	    rp->Tprev=NULL;
#endif 					/* ThreadHeap */   
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
AlcBlk(blk, b_realarray, T_Realarray, bsize);
blk->blksize = bsize;
blk->dims = NULL;
blk->listp = NULL;
return blk;
}

#endif					/* Arrays */
