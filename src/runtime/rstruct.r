/*
 * File: rstruct.r
 *  Contents: addmem, cpslots, cplist, cpset, hmake, hchain, hfirst, hnext,
 *  hgrow, hshrink, listtoarray memb
 */

/*
 * addmem - add a new set element block in the correct spot in
 *  the bucket chain.
 */

void addmem(struct b_set *ps,struct b_selem *pe,union block **pl)
   {
   ps->size++;
   if (*pl != NULL )
      pe->clink = *pl;
   *pl = (union block *) pe;
   }

/*
 * cpslots(dp1, slotptr, i, j) - copy elements of sublist dp1[i:j]
 *  into an array of descriptors.
 */

void cpslots(dptr dp1, dptr slotptr, word i, word j)
   {
   word size;
   struct b_list *lp1; /* these were tended, but I see no allocations here */
   /*
    * Get pointers to the list and list elements for the source list
    *  (bp1, lp1).
    */
   lp1 = BlkD(*dp1, List);
   size = j - i;

   switch (lp1->listhead->Lelem.title) {
   case T_Lelem: {

      struct b_lelem *bp1;

      bp1 = Blk(lp1->listhead, Lelem);

      /*
       * Locate the block containing element i in the source list.
       */
      if (size > 0) {
	 while (i > bp1->nused) {
	    i -= bp1->nused;
	    bp1 = (struct b_lelem *) bp1->listnext;
	 }
      }

      /*
       * Copy elements from the source list into the sublist, moving to
       *  the next list block in the source list when all elements in a
       *  block have been copied.
       */
      while (size > 0) {
	 j = bp1->first + i - 1;
	 if (j >= bp1->nslots)
	   j -= bp1->nslots;
	 *slotptr++ = bp1->lslots[j];
	 if (++i > bp1->nused) {
	   i = 1;
	   bp1 = (struct b_lelem *) bp1->listnext;
           }
         size--;
         }
      break;
      } // case T_Lelem

#ifdef Arrays

   case T_Intarray: {

      struct b_intarray *ap = (struct b_intarray *) lp1->listhead;
      int ndims;
      word k;

      ndims = (ap->dims?
               ((ap->dims->Intarray.blksize - sizeof(struct b_intarray) +sizeof(word)) /
                sizeof(word))
               : 1);
      i--; // ith element is slot back
      if (ndims==1){
         for (k=0; k<size; k++){
            MakeInt(ap->a[i++],&(slotptr[k]));
            }
         }
      else {
         // TODO: multi-dimensional
         syserr("multi-dimensional arrays are not supported yet\n");
         }
      break;
      } /* IntArray*/
   case T_Realarray: {
      struct b_realarray *ap = (struct b_realarray *) lp1->listhead;
      int ndims;
      word k;
      ndims = (ap->dims ?
               ((ap->dims->Intarray.blksize - sizeof(struct b_intarray) +
                 sizeof(word)) / sizeof(word))
               : 1);
      i--;  // ith element is slot back
      if (ndims==1) {
         for (k=0; i<size; k++) {
#ifdef DescriptorDouble
            slotptr[k].vword.realval = (double)ap->a[i++];
#else                                   /* DescriptorDouble */
            {
            struct b_real *xp;
            xp = alcreal((double)ap->a[i++]);
            slotptr[k].vword.bptr = (union block *) xp;
	    }
#endif					/* DescriptorDouble */
	    slotptr[k].dword = D_Real;
	    }
         } /* if (ndims==1) */
     else {
        // TODO: multi-dimensional
        syserr("multi-dimensional arrays are not supported yet\n");
        }
      break;
   } /* Realrray */

#endif				/* Arrays */

   default:
      syserr("impossible cpslots\n");
   }
   }


#begdef cplist_macro(f, e)
/*
 * cplist(dp1,dp2,i,j) - copy sublist dp1[i:j] into dp2.
 */
int f(dptr dp1, dptr dp2, word i, word j)
   {
   word size, nslots;
   tended struct b_list *lp2;

   /*
    * Calculate the size of the sublist.
    */
   size = nslots = j - i;
   if (nslots == 0)
      nslots = MinListSlots;

   Protect(lp2 = (struct b_list *) alclist(size, nslots), return RunError);
   cpslots(dp1, lp2->listhead->Lelem.lslots, i, j);

   /*
    * Fix type and location fields for the new list.
    */
   dp2->dword = D_List;
   BlkLoc(*dp2) = (union block *) lp2;
   EVValD(dp2, e);
   return Succeeded;
   }
#enddef

#ifdef MultiProgram
cplist_macro(cplist_0, 0)
cplist_macro(cplist_1, E_Lcreate)
#else					/* MultiProgram */
cplist_macro(cplist, 0)
#endif					/* MultiProgram */


#begdef cpset_macro(f, e)
/*
 * cpset(dp1,dp2,n) - copy set dp1 to dp2, reserving memory for n entries.
 */
int f(dptr dp1, dptr dp2, word n)
   {
   int i = cphash(dp1, dp2, n, T_Set);
   EVValD(dp2, e);
   return i;
   }
#enddef

#ifdef MultiProgram
cpset_macro(cpset_0, 0)
cpset_macro(cpset_1, E_Screate)
#else					/* MultiProgram */
cpset_macro(cpset, 0)
#endif					/* MultiProgram */

#begdef cptable_macro(f, e)
int f(dptr dp1, dptr dp2, word n)
   {
   int i = cphash(dp1, dp2, n, T_Table);
   BlkD(*dp2,Table)->defvalue = BlkD(*dp1,Table)->defvalue;
   EVValD(dp2, e);
   return i;
   }
#enddef

#ifdef MultiProgram
cptable_macro(cptable_0, 0)
cptable_macro(cptable_1, E_Tcreate)
#else					/* MultiProgram */
cptable_macro(cptable, 0)
#endif					/* MultiProgram */

int cphash(dp1, dp2, n, tcode)
dptr dp1, dp2;
word n;
int tcode;
   {
   union block *src;
   tended union block *dst;
   tended struct b_slots *seg;
   tended struct b_selem *ep, *prev;
   struct b_selem *se;
   register word slotnum;
   register int i;

   /*
    * Make a new set organized like dp1, with room for n elements.
    */
   dst = hmake(tcode, BlkPH(BlkLoc(*dp1),Set,mask) + 1, n);
   if (dst == NULL)
      return RunError;
   /*
    * Copy the header and slot blocks.
    */
   src = BlkLoc(*dp1);
   dst->Set.size = src->Set.size;	/* actual set size */
   dst->Set.mask = src->Set.mask;	/* hash mask */
   for (i = 0; i < HSegs && src->Set.hdir[i] != NULL; i++)
      memcpy((char *)dst->Set.hdir[i], (char *)src->Set.hdir[i],
         src->Set.hdir[i]->blksize);
   /*
    * Work down the chain of element blocks in each bucket
    *	and create identical chains in new set.
    */
   for (i = 0; i < HSegs && (seg = BlkPH(dst,Set,hdir)[i]) != NULL; i++)
      for (slotnum = segsize[i] - 1; slotnum >= 0; slotnum--)  {
	 prev = NULL;
         for (ep = (struct b_selem *)seg->hslots[slotnum];
	      ep != NULL && BlkType(ep) != T_Table;
	      ep = (struct b_selem *)ep->clink) {
	    if (tcode == T_Set) {
               Protect(se = alcselem(&ep->setmem, ep->hashnum),return RunError);
               se->clink = ep->clink;
	       }
	    else {
	       Protect(se = (struct b_selem *)alctelem(), return RunError);
	       *(struct b_telem *)se = *(struct b_telem *)ep; /* copy table entry */
	       if (BlkType(se->clink) == T_Table)
		  se->clink = dst;
	       }
	    if (prev == NULL)
		seg->hslots[slotnum] = (union block *)se;
	    else
		prev->clink = (union block *)se;
	    prev = se;
            }
         }
   dp2->dword = tcode | D_Typecode | F_Ptr;
   BlkLoc(*dp2) = dst;
   if (TooSparse(dst))
      hshrink(dst);
   return Succeeded;
   }

/*
 * hmake - make a hash structure (Set or Table) with a given number of slots.
 *  If *nslots* is zero, a value appropriate for *nelem* elements is chosen.
 *  A return of NULL indicates allocation failure.
 */
union block *hmake(tcode, nslots, nelem)
int tcode;
word nslots, nelem;
   {
   word seg, t, blksize, elemsize;
   tended union block *blk;
   struct b_slots *segp;

   if (nslots == 0)
      nslots = (nelem + MaxHLoad - 1) / MaxHLoad;
   for (seg = t = 0; seg < (HSegs - 1) && (t += segsize[seg]) < nslots; seg++)
      ;
   nslots = ((word)HSlots) << seg;	/* ensure legal power of 2 */
   if (tcode == T_Table) {
      blksize = sizeof(struct b_table);
      elemsize = sizeof(struct b_telem);
      }
   else {	/* T_Set */
      blksize = sizeof(struct b_set);
      elemsize = sizeof(struct b_selem);
      }
   if (!reserve(Blocks, (word)(blksize + (seg + 1) * sizeof(struct b_slots)
      + (nslots - HSlots * (seg + 1)) * sizeof(union block *)
      + nelem * elemsize))) return NULL;
   Protect(blk = alchash(tcode), return NULL);
   for (; seg >= 0; seg--) {
      Protect(segp = alcsegment(segsize[seg]), return NULL);
#ifdef DebugHeap
      if (tcode == T_Table)
         Blk(blk,Table)->hdir[seg] = segp;
      else
         Blk(blk,Set)->hdir[seg] = segp;
#else					/* DebugHeap */
      blk->Set.hdir[seg] = segp;
#endif					/* DebugHeap */
      if (tcode == T_Table) {
	 int j;
	 for (j = 0; j < segsize[seg]; j++)
	    segp->hslots[j] = blk;
         }
      }
   blk->Set.mask = nslots - 1;
   return blk;
   }

/*
 * hchain - return a pointer to the word that points to the head of the
 *  hash chain for hash number hn in hashed structure s.
 */

/*
 * lookup table for log to base 2; must have powers of 2 through
 * (HSegs-1)/2.
 */
static unsigned char log2h[] = {
   0,1,2,2, 3,3,3,3, 4,4,4,4, 4,4,4,4, 5,5,5,5, 5,5,5,5, 5,5,5,5, 5,5,5,5,
   6,6,6,6, 6,6,6,6, 6,6,6,6, 6,6,6,6, 6,6,6,6, 6,6,6,6, 6,6,6,6, 6,6,6,6,
   7,7,7,7, 7,7,7,7, 7,7,7,7, 7,7,7,7, 7,7,7,7, 7,7,7,7, 7,7,7,7, 7,7,7,7,
   7,7,7,7, 7,7,7,7, 7,7,7,7, 7,7,7,7, 7,7,7,7, 7,7,7,7, 7,7,7,7, 7,7,7,7,
   8,8,8,8, 8,8,8,8, 8,8,8,8, 8,8,8,8, 8,8,8,8, 8,8,8,8, 8,8,8,8, 8,8,8,8,
   8,8,8,8, 8,8,8,8, 8,8,8,8, 8,8,8,8, 8,8,8,8, 8,8,8,8, 8,8,8,8, 8,8,8,8,
   8,8,8,8, 8,8,8,8, 8,8,8,8, 8,8,8,8, 8,8,8,8, 8,8,8,8, 8,8,8,8, 8,8,8,8,
   8,8,8,8, 8,8,8,8, 8,8,8,8, 8,8,8,8, 8,8,8,8, 8,8,8,8, 8,8,8,8, 8,8,8,8,

   9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9,
   9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9,
   9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9,
   9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9,
   9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9,
   9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9,
   9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9,
   9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9, 9,9,9,9,

   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,
   10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10,

   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11,
   11,11,11,11, 11,11,11,11, 11,11,11,11, 11,11,11,11
   };

union block **hchain(pb, hn)
union block *pb;
register uword hn;
   {
   register struct b_set *ps;
   register word slotnum, segnum, segslot;

   ps = (struct b_set *)pb;
   slotnum = hn & ps->mask;
   if (slotnum >= HSlots * sizeof(log2h))
      segnum = log2h[slotnum >> (LogHSlots + HSegs/2)] + HSegs/2;
   else
      segnum = log2h[slotnum >> LogHSlots];
   segslot = hn & (segsize[segnum] - 1);
   return &ps->hdir[segnum]->hslots[segslot];
   }

/*
 * hgfirst - initialize for generating set or table, and return first element.
 */

union block *hgfirst(bp, s)
union block *bp;
struct hgstate *s;
   {
   int i;

   s->segnum = 0;				/* set initial state */
   s->slotnum = -1;
   s->tmask = BlkPH(bp,Table,mask);
   for (i = 0; i < HSegs; i++)
      s->sghash[i] = s->sgmask[i] = 0;
   return hgnext(bp, s, (union block *)0);     /* get and return first value */
   }

/*
 * hgnext - return the next element of a set or table generation sequence.
 *
 *  We carefully generate each element exactly once, even if the hash chains
 *  are split between calls.  We do this by recording the state of things at
 *  the time of the split and checking past history when starting to process
 *  a new chain.
 *
 *  Elements inserted or deleted between calls may or may not be generated. 
 *
 *  We assume that no structure *shrinks* after its initial creation; they
 *  can only *grow*.
 */

union block *hgnext(bp, s, ep)
union block *bp;
struct hgstate *s;
union block *ep;
   {
   int i;
   word d, m;
   uword hn;

   /*
    * Check to see if the set or table's hash buckets were split (once or
    *  more) since the last call.  We notice this unless the next entry
    *  has same hash value as the current one, in which case we defer it
    *  by doing nothing now.
    */
   if (BlkPH(bp,Table,mask) != s->tmask &&
	  (BlkPE(ep,Selem,clink) == NULL ||
	   BlkType(BlkPE(ep,Telem,clink)) == T_Table ||
	  BlkPE(BlkPE(ep,Telem,clink),Telem,hashnum) != BlkPE(ep,Telem,hashnum))){
      /*
       * Yes, they did split.  Make a note of the current state.
       */
      hn = BlkPE(ep,Telem,hashnum);
      for (i = 1; i < HSegs; i++)
         if ((((word)HSlots) << (i - 1)) > s->tmask) {
   	 /*
   	  * For the newly created segments only, save the mask and
   	  *  hash number being processed at time of creation.
   	  */
   	 s->sgmask[i] = s->tmask;
   	 s->sghash[i] = hn;
         }
      s->tmask = BlkPH(bp,Table,mask);
      /*
       * Find the next element in our original segment by starting
       *  from the beginning and skipping through the current hash
       *  number.  We can't just follow the link from the current
       *  element, because it may have moved to a new segment.
       */
      ep = BlkPH(bp,Table,hdir)[s->segnum]->hslots[s->slotnum];
      while (ep != NULL && BlkType(ep) != T_Table &&
	     BlkPE(ep,Telem,hashnum) <= hn)
         ep = BlkPE(ep,Telem,clink);
      }

   else {
      /*
       * There was no split, or else if there was we're between items
       *  that have identical hash numbers.  Find the next element in
       *  the current hash chain.
       */
      if (ep != NULL && BlkType(ep) != T_Table)	/* NULL on very first call */
         ep = BlkPE(ep,Telem,clink);	/* next element in chain, if any */
   }

   /*
    * If we don't yet have an element, search successive slots.
    */
   while (ep == NULL || BlkType(ep) == T_Table) {
      /*
       * Move to the next slot and pick the first entry.
       */
      s->slotnum++;
      if (s->slotnum >= segsize[s->segnum]) {
	 s->slotnum = 0;		/* need to move to next segment */
	 s->segnum++;
	 if (s->segnum >= HSegs || BlkPH(bp,Table,hdir)[s->segnum] == NULL)
	    return 0;			/* return NULL at end of set/table */
         }
      ep = BlkPH(bp,Table,hdir)[s->segnum]->hslots[s->slotnum];
      /*
       * Check to see if parts of this hash chain were already processed.
       *  This could happen if the elements were in a different chain,
       *  but a split occurred while we were suspended.
       */
      for (i = s->segnum; (m = s->sgmask[i]) != 0; i--) {
         d = (word)(m & s->slotnum) - (word)(m & s->sghash[i]);
         if (d < 0)			/* if all elements processed earlier */
            ep = NULL;			/* skip this slot */
         else if (d == 0) {
            /*
             * This chain was split from its parent while the parent was
             *  being processed.  Skip past elements already processed.
             */
            while (ep != NULL && BlkType(ep) != T_Table &&
		   BlkPE(ep,Telem,hashnum) <= s->sghash[i])
               ep = BlkPE(ep,Telem,clink);
            }
         }
      }

   /*
    * Return the element.
    */
   if (ep && BlkType(ep) == T_Table) ep = NULL;
   return ep;
   }

/*
 * hgrow - split a hashed structure (doubling the buckets) for faster access.
 */

void hgrow(bp)
union block *bp;
   {
   register union block **tp0, **tp1, *ep;
   register word newslots, slotnum, segnum;
   tended struct b_set *ps;
   struct b_slots *seg, *newseg;
   union block **curslot;

   ps = &(bp->Set);
#ifdef DebugHeap
   if (!ValidPtr(bp)) syserr("invalid block ptr");
   if ((ps->title != T_Set) && (ps->title != T_Table))
      heaperr("invalid title not set/table", (union block *)ps, T_Set);
#endif
   if (ps->hdir[HSegs-1] != NULL)
      return;				/* can't split further */
#ifdef VerifyHeap
   vrfyLog("Growing Set/Table at %p (id %ld)", ps, ps->id);
#endif                  /* VerifyHeap */
   newslots = ps->mask + 1;
   EVVal((word)newslots, E_HashSlots);
   Protect(newseg = alcsegment(newslots), return);
   if (BlkType(ps) == T_Table) {
      int j;
      for(j=0; j<newslots; j++) newseg->hslots[j] = (union block *) ps;
      }

   curslot = newseg->hslots;
   for (segnum = 0; (seg = ps->hdir[segnum]) != NULL; segnum++)
      for (slotnum = 0; slotnum < segsize[segnum]; slotnum++)  {
         tp0 = &seg->hslots[slotnum];	/* ptr to tail of old slot */
         tp1 = curslot++;		/* ptr to tail of new slot */
         for (ep = *tp0;
	      ep != NULL && BlkType(ep) != T_Table;
	      ep = BlkPE(ep,Telem,clink)) {
            if ((BlkPE(ep,Telem,hashnum) & newslots) == 0) {
               *tp0 = ep;		/* element does not move */
               tp0 = &(ep->Selem.clink);
               }
            else {
               *tp1 = ep;		/* element moves to new slot */
               tp1 = &(ep->Selem.clink);
               }
            }
         if ( BlkType(ps) == T_Table ) 
	    *tp0 = *tp1 = (union block *) ps;
         else
            *tp0 = *tp1 = NULL;
         }
   ps->hdir[segnum] = newseg;
   ps->mask = (ps->mask << 1) | 1;
#ifdef VerifyHeap
   if ( BlkType(ps) == T_Table ) {
     vrfy_Live_Table((struct b_table *)ps);
   }
#endif                  /* VerifyHeap */
   
   }

/*
 * hshrink - combine buckets in a set or table that is too sparse.
 *
 *  Call this only for newly created structures.  Shrinking an active structure
 *  can wreak havoc on suspended generators.
 */
void hshrink(bp)
union block *bp;
   {
   register union block **tp, *ep0, *ep1;
   int topseg, curseg;
   word slotnum;
   tended struct b_set *ps;
   struct b_slots *seg;
   union block **uppslot;

   ps = (struct b_set *)bp;
#ifdef DebugHeap
   if (!ValidPtr(bp)) syserr("invalid block ptr");
   if ((ps->title != T_Set) && (ps->title != T_Table))
      heaperr("invalid title not set/table", (union block *)ps, T_Set);
#endif
#ifdef VerifyHeap
   vrfyLog("Shrinking Set/Table at %p (id %ld)", ps, ps->id);
#endif                  /* VerifyHeap */
   topseg = 0;
   for (topseg = 1; topseg < HSegs && ps->hdir[topseg] != NULL; topseg++)
      ;
   topseg--;
   while (TooSparse(ps)) {
      uppslot = ps->hdir[topseg]->hslots;
      ps->hdir[topseg--] = NULL;
      for (curseg = 0; (seg = ps->hdir[curseg]) != NULL; curseg++)
         for (slotnum = 0; slotnum < segsize[curseg]; slotnum++)  {
            tp = &seg->hslots[slotnum];		/* tail pointer */
            ep0 = seg->hslots[slotnum];		/* lower slot entry pointer */
            ep1 = *uppslot++;			/* upper slot entry pointer */
            while (ep0 != NULL && BlkType(ep0) != T_Table &&
		   ep1 != NULL && BlkType(ep1) != T_Table)
               if (Blk(ep0,Selem)->hashnum < Blk(ep1,Selem)->hashnum) {
                  *tp = ep0;
                  tp = &(ep0->Selem.clink);
                  ep0 = Blk(ep0,Selem)->clink;
                  }
               else {
                  *tp = ep1;
                  tp = &(ep1->Selem.clink);
                  ep1 = Blk(ep1,Selem)->clink;
                  }
            while (ep0 != NULL && BlkType(ep0) != T_Table) {
               *tp = ep0;
               tp = &(ep0->Selem.clink);
               ep0 = Blk(ep0,Selem)->clink;
               }
            while (ep1 != NULL && BlkType(ep1) != T_Table) {
               *tp = ep1;
               tp = &(ep1->Selem.clink);
               ep1 = Blk(ep1,Selem)->clink;
               }
            }
      ps->mask >>= 1;
      }
#ifdef VerifyHeap
   if ( BlkType(bp) == T_Table ) {
	 vrfy_Live_Table(&bp->Table);
   }
#endif                  /* VerifyHeap */

   }

/*
 * memb - sets res flag to 1 if x is a member of a set or table, 0 if not.
 *  Returns a pointer to the word which points to the element, or which
 *  would point to it if it were there.
 *  int *res is a pointer to integer result flag.
 */

union block **memb(union block *pb, dptr x, uword hn, int *res)
   {
   register union block **lp;
   register struct b_selem *pe;
   register uword eh;
   int chainlen = 0; /* # of elements visited during this lookup */
#ifdef DebugHeap
   int elemtitle;
   if (pb->Set.title == T_Set) elemtitle = T_Selem;
   else if (pb->Set.title == T_Table) elemtitle = T_Telem;
   else { syserr("odd memb\n"); }
#endif

   lp = hchain(pb, hn);
   /*
    * Look for x in the hash chain.
    */
   *res = 0;
   while ((pe = (struct b_selem *)*lp) != NULL && BlkType(pe) != T_Table) {
      chainlen++;
      eh = pe->hashnum;
      if (eh > hn) {			/* too far - it isn't there */
	 EVVal((word)chainlen, E_HashChain);
         return lp;
	 }
      else if ((eh == hn) && (equiv(&pe->setmem, x)))  {
         *res = 1;
	 EVVal((word)chainlen, E_HashChain);
         return lp;
         }
      /*
       * We haven't reached the right hashnumber yet or
       *  the element isn't the right one so keep looking.
       */
      lp = &(pe->clink);
      }
   /*
    *  At end of chain - not there.
    */
   EVVal((word)chainlen, E_HashChain);
   return lp;
   }

/*
 * dynamic records code.  originally this just did a malloc and returned it,
 * but the memory leak implied by this behavior was significant since this
 * function gets called every fetch.  So now it stores an array of pointers
 * to arrays of procedure blocks, and returns an existing procedure block
 * when it finds one with identical fields **need to match record name also.
 * Array subscript == #of fields-1, so you are searching among all dynamic
 * records with the same number of fields to try and find a match. May need
 * to make this smarter someday.
 */

#ifndef MultiProgram
int longest_dr = 0;
struct b_proc_list **dr_arrays;
#endif					/* MultiProgram */

#if COMPILER
static word mdw_dynrec_start = 0;

void
dynrec_start_set(start)
   word start;
{
   mdw_dynrec_start = start;
}

static
char *
dynrec_recname_create(name, flds, nflds)
   dptr name;
   dptr flds;
   int nflds;
{
   char * p;
   int i, len;
   char * rslt;

   for (i=len=0; i<nflds; i++)
      len += StrLen(flds[i]);
   if (len + nflds > 256) {
      printf("dynrec_name_create: name exceeds max.\n");
      return NULL;
      }
      
   Protect(rslt = alcstr(NULL, 256), return NULL);
   for (p=rslt,i=0; i<nflds; i++) {
      strncpy(p, StrLoc(flds[i]), StrLen(flds[i]));
      p += StrLen(flds[i]);
      *p++ = '_';
      }
   name->vword.sptr = rslt;
   name->dword = len + nflds - 1;

   return rslt;
}

static
int
rmkrec(nargs, cargp, rslt)
   int nargs;
   dptr cargp;
   dptr rslt;
{
   int i;
   dptr d;
   struct b_proc * bp;
   tended struct b_record * rp;

   d = cargp[-1].vword.descptr;
   bp = (struct b_proc *)d->vword.bptr;
   Protect(rp = alcrecd((int)bp->nfields, (union block *)bp), RunErr(0,NULL));

   for (i = (int)bp->nfields; i > nargs; i--)
      rp->fields[i-1] = nulldesc;
   for ( ; i > 0; i--) {
       rp->fields[i-1] = cargp[i-1];
      Deref(rp->fields[i-1]);
      }
   rslt->dword = D_Record;
   rslt->vword.bptr = (union block *)rp;
   return A_Continue;
}

int fldlookup(rec, fld)
    struct b_record * rec;
    const char * const fld;
{
    int i, len;
    union block * desc;

    len = strlen(fld);
    desc = rec->recdesc;
    for (i=0; i<Blk(desc,Proc)->nfields; i++) {
        if (len == StrLen(desc->Proc.lnames[i]) &&
           (strncmp(fld, StrLoc(desc->Proc.lnames[i]), len) == 0)) {
           break;
	   }
        }
    if (i >= desc->Proc.nfields)
        i = -1;
    return i;
}

static struct b_proc_list * dr_tbl[128] = { 0 };

struct b_proc *
dynrecord(s, fields, n)
   dptr s;
   dptr fields;
   int n;
{
   int i, hval, len;
   struct b_proc * bp;
   struct b_proc_list * bpl;

   if (StrLen(*s) == 0) {
      if (dynrec_recname_create(s, fields, n) == NULL) {
         printf("dynrecord: dynrec_recname_create failure.\n");
         return NULL;
         }
      }
   hval = (hash(s) & 0x7f);

   if (n > 0) {
      for (bpl=dr_tbl[hval]; bpl; bpl=bpl->next) {
         bp = bpl->this;
         if (StrLen(*s) != StrLen(bp->recname))
            continue;
         if (strncmp(StrLoc(*s), StrLoc(bp->recname), StrLen(*s)))
            continue;
         if (bp->nfields != n)
            return NULL;
         for (i=0; i<n; i++) {
            len = StrLen(fields[i]);
            if ((len != StrLen(bp->lnames[i])) ||
               (strncmp(StrLoc(fields[i]), StrLoc(bp->lnames[i]), len)))
               return NULL;
            }
         return bp;
         }
      }

   bp = (struct b_proc *)malloc(sizeof(struct b_proc) +
      sizeof(struct descrip) * n);
   if (bp == NULL) return NULL;
   bp->title = T_Proc;
   bp->blksize = sizeof(struct b_proc) + sizeof(struct descrip) * n;
   bp->ccode = rmkrec;
   bp->nfields = n;
   bp->ndynam = -2;
   bp->recnum = -1; /* recnum -1 means: dynamic record */
   bp->recid = 1;
   StrLoc(bp->recname) = malloc(StrLen(*s)+1);
   if (StrLoc(bp->recname) == NULL) return NULL;
   strncpy(StrLoc(bp->recname), StrLoc(*s), StrLen(*s));
   StrLen(bp->recname) = StrLen(*s);
   StrLoc(bp->recname)[StrLen(*s)] = '\0';
   for (i=0;i<n;i++) {
      StrLen(bp->lnames[i]) = StrLen(fields[i]);
      StrLoc(bp->lnames[i]) = malloc(StrLen(fields[i])+1);
      if (StrLoc(bp->lnames[i]) == NULL) return NULL;
      strncpy(StrLoc(bp->lnames[i]), StrLoc(fields[i]), StrLen(fields[i]));
      StrLoc(bp->lnames[i])[StrLen(fields[i])] = '\0';
      }
   bpl = malloc(sizeof(struct b_proc_list));
   if (bpl == NULL) return NULL;
   bpl->this = bp;
   MUTEX_LOCKID(MTX_DR_TBL);
   bpl->next = dr_tbl[hval];
   dr_tbl[hval] = bpl;
   MUTEX_UNLOCKID(MTX_DR_TBL);
   return bp;
}

#else /* COMPILER */

struct b_proc *dynrecord(dptr s, dptr fields, int n)
   {
      struct b_proc_list *bpelem = NULL;
      struct b_proc *bp = NULL;
      int i, ct=0;
      if (n > longest_dr) {
         SUSPEND_THREADS();
         if (n > longest_dr) {
               dr_arrays = realloc(dr_arrays, n * sizeof (struct b_proc *));
               if (dr_arrays == NULL){
                  RESUME_THREADS();
	          return NULL;
		  }
               while(longest_dr<n) {
                  dr_arrays[longest_dr++] = NULL;
                  }
            }
         RESUME_THREADS();
	 }

      if (n>0)
      for(bpelem = dr_arrays[n-1]; bpelem; bpelem = bpelem->next, ct++) {
         bp = bpelem->this;
         /* compare name of record */
         if (strncmp(StrLoc(*s),StrLoc(bp->recname),StrLen(*s))) break;
         for (i=0; i<n; i++) {
            if((StrLen(fields[i]) != StrLen(bp->lnames[i])) ||
                strncmp(StrLoc(fields[i]), StrLoc(bp->lnames[i]),StrLen(fields[i]))) break;
            }
         if(i==n) {
            return bp;
            }
         }

      bp = (struct b_proc *)malloc(sizeof(struct b_proc) +
               sizeof(struct descrip) * n);
      if (bp == NULL) return NULL;
      bp->title = T_Proc;
      bp->blksize = sizeof(struct b_proc) + sizeof(struct descrip) * n;
      bp->entryp.ccode = Omkrec;
      bp->nfields = n;
      bp->ndynam = -2;
      bp->recnum = -1; /* dynamic record */
      bp->recid = 1;
      StrLoc(bp->recname) = malloc(StrLen(*s)+1);

      if (StrLoc(bp->recname) == NULL) return NULL;
      StrLen(bp->recname) = StrLen(*s);
      for(i=0;i<StrLen(*s); i++) StrLoc(bp->recname)[i]=StrLoc(*s)[i];
      StrLoc(bp->recname)[StrLen(*s)] = '\0';
      for(i=0;i<n;i++) {
	 StrLen(bp->lnames[i]) = StrLen(fields[i]);
	 StrLoc(bp->lnames[i]) = malloc(StrLen(fields[i])+1);
	 if (StrLoc(bp->lnames[i]) == NULL) return NULL;
	 strncpy(StrLoc(bp->lnames[i]), StrLoc(fields[i]), StrLen(fields[i]));
	 StrLoc(bp->lnames[i])[StrLen(fields[i])] = '\0';
	 }
      bpelem = malloc(sizeof (struct b_proc_list));
      if (bpelem == NULL) return NULL;
      bpelem->this = bp;
      bpelem->next = dr_arrays[n-1];
      dr_arrays[n-1] = bpelem;
      return bp;
   }
#endif /* COMPILER */

#ifdef MultiProgram

/*
 * Determine whether an event (value) is in a mask for a given event code.
 */
int invaluemask(struct progstate *p, int evcode, struct descrip *val)
   {
   int rv;
   uword hn;
   union block **foo;
   /*
    * Build a Unicon string for the event code.
    */
   unsigned char ec = (unsigned char)evcode;
   struct descrip d;
   StrLoc(d) = (char *)&ec;
   StrLen(d) = 1;

   if (! is:table(p->valuemask)) return RunError;
   hn = hash(&d);
   foo = memb(BlkLoc(p->valuemask), &d, hn, &rv);
   if (rv == 1) {
      /* found a value mask for this event code; use it */
      d = Blk(*foo,Telem)->tval;
      if (! is:set(d)) return RunError;
      hn = hash(val);
      foo = memb(BlkLoc(d), val, hn, &rv);
      if (rv == 1) return Succeeded;
      return Failed;
      }
   else { /* no value mask for this code, let anything through */
      return Succeeded;
      }
   }
#endif					/* MultiProgram */

/*
 * Insert an array of alternating keys and values into a table.
 */
int cinserttable(union block **pbp, int n, dptr x)
{
   tended struct descrip s;
   union block **pd;
   struct b_telem *te;
   register uword hn;
   int res, argc;

   s.dword = D_Table;
   BlkLoc(s) = *pbp;
   for(argc=0; argc<n; argc+=2) {
      hn = hash(x+argc);

      /* get this now because can't tend pd */
      Protect(te = alctelem(), return -1);

      pd = memb(*pbp, x+argc, hn, &res);	/* search table for key */
      if (res == 0) {
	 /*
	  * The element is not in the table - insert it.
	  */
	 Blk(*pbp, Table)->size++;
	 te->clink = *pd;
	 *pd = (union block *)te;
	 te->hashnum = hn;
	 te->tref = x[argc];
	 if (argc+1 < n)
	    te->tval = x[argc+1];
	 else
	    te->tval = nulldesc;
	 if (TooCrowded(*pbp))
	    hgrow(*pbp);
	 }
      else {
	 /*
	  * We found an existing entry; just change its value.
	  */
	 deallocate((union block *)te);
	 te = (struct b_telem *) *pd;
	 if (argc+1 < n)
	    te->tval = x[argc+1];
	 else
	    te->tval = nulldesc;
	 }
      EVValD(&s, E_Tinsert);
      EVValD(x+argc, E_Tsub);
      }
   return 0;
}


/* 
 * Make simple Icon lists (all elements the same type) from C arrays.
 * Intended primarily to be called from loaded C code.  If you are
 * considering using this, you may also want to consider using
 * an intarray or realarray for better interoperability and reduced
 * conversion costs going back and forth between C and Unicon; see
 * mkIarray() and mkRarray() below.
 */

/*
 * Given a C array of ints "x", returns the vword of the descriptor for
 * an Icon list made from "x".
 */
union block * mkIlist(int x[], int n)
{
  tended struct b_list *hp;
  register word i, size;
  word nslots;
  register struct b_lelem *bp;  /* doesn't need to be tended.  Why? */

  nslots = size = n;
  if (nslots == 0) nslots = MinListSlots;

  /* Protect and ReturnErrNum are macros defined in h/grttin.h */
  Protect(hp = alclist_raw(size, nslots), ReturnErrNum(307,NULL));
  bp = (struct b_lelem *)hp->listhead;
  /* List has only one list-element block: */
  hp->listhead = hp->listtail = (union block *) bp;
  
  /* Set slot i to a descriptor for the integer x[i] */
  for (i = 0; i < size; i++) {
    bp->lslots[i].dword = D_Integer;
    bp->lslots[i].vword.integr = x[i];
  }

  /* Event monitoring.  See h/grttin.h. */
  Desc_EVValD(hp, E_Lcreate, D_List);
  return (union block *) hp;
}

/*
 * Given a C array of doubles "x", return the vword of the descriptor for
 * an Icon list made from "x".
 */
union block * mkRlist(double x[], int n)
{ 
  tended struct b_list *hp;
  tended struct b_lelem *bp;
  register word i, size;
  word nslots;

  nslots = size = n;
  if (nslots == 0) nslots = MinListSlots;

  /* Protect and ReturnErrNum are macros defined in h/grttin.h */
  Protect(hp = alclist_raw(size, nslots), ReturnErrNum(307,NULL));
  bp = (struct b_lelem *)hp->listhead;
  /* List has only one list-element block: */
  hp->listhead = hp->listtail = (union block *) bp;

  /* Set slot i to a descriptor for the b_real containing the double x[i] */
  for (i = 0; i < size; i++) {
#ifdef DescriptorDouble
    bp->lslots[i].vword.realval = x[i];
#else					/* DescriptorDouble */
    {
    register struct b_real *rblk; /* does not need to be tended */
    Protect(rblk = alcreal(x[i]), ReturnErrNum(307,NULL));
    bp->lslots[i].vword.bptr = (union block *)rblk;
    }
#endif					/* DescriptorDouble */
    bp->lslots[i].dword = D_Real;
  }

  /* Event monitoring.  See h/grttin.h. */
  Desc_EVValD(hp, E_Lcreate, D_List);
  return (union block *) hp;
}

#ifdef Arrays

union block *mkIArray(int x[], int n)
{
   int i;
   tended struct b_intarray *ap;

   Protect(ap = (struct b_intarray *) alcintarray(n), return NULL);
   /* TODO: consider whether memcpy() or similar would be faster here */
   if (x != NULL)
      for(i=0; i<n; i++) ap->a[i] = x[i];
   return (union block *)alclisthdr(n, (union block *) ap);
}

union block *mkRArray(double x[], int n)
{
   int i;
   tended struct b_realarray *ap;

   Protect(ap = (struct b_realarray *) alcrealarray(n), return NULL);
   /* TODO: consider whether memcpy() or similar would be faster here */
   if (x != NULL)
      for(i=0; i<n; i++) ap->a[i] = x[i];
   return (union block *)alclisthdr(n, (union block *) ap);
}

word *getIArrDataPtr(struct b_list * L)
{
   struct b_intarray *ap;
   if (L->listtail != NULL) return NULL;
   if (BlkType(L->listhead) != T_Intarray) return NULL;
   ap = (struct b_intarray *) L->listhead;
   return ap->a;
}

double *getRArrDataPtr( struct b_list * L)
{
   struct b_realarray *ap;
   if (L->listtail != NULL) return NULL;
   if (BlkType(L->listhead) != T_Realarray) return NULL;
   ap = (struct b_realarray *) L->listhead;
   return ap->a;
}

/*
 * Convert an (Unicon-style C-compatible) array to a list.
 */

int arraytolist(struct descrip *arr)
{
   int ndims, lsize, i; 
   register struct b_lelem *lelemp;
   tended struct b_list *lparr;
   
   if (is:list(*arr)) {
      lparr = (struct b_list *) BlkD(*arr, List);
      if (lparr->listtail!=NULL) return Succeeded;
      }
   else
      return RunError;

   if (BlkType(lparr->listhead) == T_Realarray) {

      struct b_realarray *ap = (struct b_realarray *) lparr->listhead;
      
      ndims = (ap->dims ?
	       ((ap->dims->Intarray.blksize - sizeof(struct b_intarray) +
		 sizeof(word)) / sizeof(word))
	       : 1);

      lsize = (ndims>1 ? ap->dims->Intarray.a[0] :
	       (ap->blksize - sizeof(struct b_realarray) + sizeof(double)) /
	       sizeof(double));

      Protect(lelemp = alclstb(lsize, (word)0, (word)0) , return RunError );      
      lelemp->listprev = lelemp->listnext = (union block *) lparr;
      lparr->listhead = lparr->listtail = (union block *)lelemp;
      
      if (ndims==1) {
	 for (i=0; i<lsize; i++) {
#ifdef DescriptorDouble
	    lelemp->lslots[i].vword.realval = (double)ap->a[i];
#else					/* DescriptorDouble */
	    {
	    struct b_real *xp;
	    xp = alcreal((double)ap->a[i]);
	    lelemp->lslots[i].vword.bptr = (union block *) xp;
	    }
#endif					/* DescriptorDouble */
	    lelemp->lslots[i].dword = D_Real;
	    lelemp->nused++;
	    }
         } /* if (ndims==1) */
      else if (ndims==2) {
	 struct b_realarray *ap2;
	 int n=ap->dims->Intarray.a[1];
	 int base=0, j;

	 for (i=0; i<lsize; i++){
	    ap2 = alcrealarray(n);

	    ap2->dims=NULL;
	    for(j=0; j<n; j++) /* copy elements over to the new sub-array */
	       ap2->a[j]=ap->a[base++];

	    lelemp->lslots[i].vword.bptr = (union block *) ap2;
	    lelemp->lslots[i].dword = D_Realarray;
	    lelemp->nused++;
	 }

	 } /* (ndims==2) */
     else { /* (ndims > 2) */
	 struct b_realarray *ap2;
	 int n=ap->dims->Intarray.a[1];
	 int base=0, j;
	 
	 for(i=2; i<ndims; i++)
	    n *= ap->dims->Intarray.a[i];

	 for (i=0; i<lsize; i++){
	    struct b_intarray *dims = NULL;
	    
	    ap2 = alcrealarray(n);
	    dims = alcintarray(ndims-1); 	/* dimension is less by 1 */
	    ap2->dims = (union block *)dims;	
	    for(j=1; j<ndims; j++)		/* copy the dimensions */
	       dims->a[j-1]=ap->dims->Intarray.a[j]; /* to the new array */

	    for(j=0; j<n; j++) /* copy elemets over to the new sub-array */
	       ap2->a[j]=ap->a[base++];

	    lelemp->lslots[i].vword.bptr = (union block *) ap2;
	    lelemp->lslots[i].dword = D_Realarray;
	    lelemp->nused++;
	 }

	 } /* (ndims>2) */
 
      } /* Realrray */

   else if (BlkType(lparr->listhead)==T_Intarray) {

      struct b_intarray *ap = (struct b_intarray *) lparr->listhead;
      
      ndims = (ap->dims?
      ((ap->dims->Intarray.blksize - sizeof(struct b_intarray) +sizeof(word)) /
       sizeof(word))
      : 1);
      
      lsize = (ndims>1? ap->dims->Intarray.a[0]:
       (ap->blksize - sizeof(struct b_intarray) + sizeof(word))/sizeof(word));

      Protect(lelemp = alclstb(lsize, (word)0, (word)0) , return RunError );      
      lelemp->listprev = lelemp->listnext = (union block *) lparr;
      lparr->listhead = lparr->listtail = (union block *)lelemp;
      
      if (ndims==1){
	 for (i=0; i<lsize; i++){
	    MakeInt(ap->a[i],&(lelemp->lslots[i]));
	    lelemp->nused++;
	    }
         } /* if (ndims==1) */
      else if (ndims==2){
	 struct b_intarray *ap2;
	 int n=ap->dims->Intarray.a[1];
	 int base=0, j;

	 for (i=0; i<lsize; i++){
	    ap2 = alcintarray(n);

	    ap2->dims=NULL;
	    for(j=0; j<n; j++) /* copy elemets over to the new sub-array */
	       ap2->a[j]=ap->a[base++];

	    lelemp->lslots[i].vword.bptr = (union block *) ap2;
	    lelemp->lslots[i].dword = D_Intarray;
	    lelemp->nused++;
	 }

	 } /* (ndims==2) */
     else { /* (ndims > 2) */
	 struct b_intarray *ap2;
	 int n=ap->dims->Intarray.a[1];
	 int base=0, j;
	 
	 for(i=2; i<ndims; i++)
	    n*=ap->dims->Intarray.a[i];

	 for (i=0; i<lsize; i++){
	    struct b_intarray *dims = NULL;
	    
	    ap2 = alcintarray(n);
	    dims = alcintarray(ndims-1); 	/* dimension is less by 1 */
	    ap2->dims = (union block *)dims;	
	    for(j=1; j<ndims; j++)		/* copy the dimensions */
	       dims->a[j-1]=ap->dims->Intarray.a[j]; /* to the new array */

	    for(j=0; j<n; j++) /* copy elements over to the new sub-array */
	       ap2->a[j]=ap->a[base++];

	    lelemp->lslots[i].vword.bptr = (union block *) ap2;
	    lelemp->lslots[i].dword = D_Intarray;
	    lelemp->nused++;
	 }

	 } /* (ndims>2) */

      } /* IntArray*/
   else
      return RunError;

   return Succeeded;
}


/*
 * traverse a list and produce the element given by position
 */
int c_traverse(struct b_list *hp, struct descrip * res, int position)
{
   register word i;
   register struct b_lelem *bp;
   int j, used;

   /*
    * Fail if the list is not big enough.
    */
   if (hp->size < position)
      return 0;

   /*
    * Point bp at the first list block.  If the first block has no
    *  elements in use, point bp at the next list block.
    */
   bp = (struct b_lelem *) hp->listhead;
   if (bp->nused <= 0) {
      bp = (struct b_lelem *) bp->listnext;
      hp->listhead = (union block *) bp;
      bp->listprev = (union block *) hp;
      }

   /*
    * Parse through the list blocks to find the specified element.
    */
   i = bp->first;
   used = bp->nused;
   for (j=0; j < position; j++){
      if (used <= 1){
	 bp = (struct b_lelem *) bp->listnext;
         used = bp->nused;
         i = bp->first;
         }
      else {
	 if (i++ >= bp->nslots) i = 0;
	 used--;
         }
      }
   *res = bp->lslots[i];
   return 1;
}

int cplist2realarray(dptr dp, dptr dp2, word i, word j,  word skipcopyelements)
{
   word size;
   tended struct b_realarray *ap2;
   
   /*
   * Calculate the size of the sublist.
   */
   size =j - i ;
   if (!reserve(Blocks, (word)(sizeof(struct b_list) + (word)sizeof(struct b_realarray)
      + size * (word)sizeof(double))))  return RunError;
   
   Protect(ap2 = (struct b_realarray *) alcrealarray(size), return RunError);

   if (!skipcopyelements){
      word k;
      /* copy elements i throgh j to the new array ap2*/
      if (is:list(*dp)){
	tended struct b_list *lp;
	lp = (struct b_list *) BlkD(*dp, List);
	if (BlkType(lp->listhead) == T_Realarray){
	  double *a, *a2;
	  a = &(((struct b_realarray *) lp->listhead )->a[i]);
	  a2 = ap2->a;
	  for (k=0; k<size; k++)
	     a2[k]=a[k];
	  }
	else if (BlkType(lp->listhead) == T_Intarray){
	  word *a;
	  double *a2;
	  a = &(((struct b_intarray *) lp->listhead )->a[i]);
	  a2 = ap2->a;
	  for (k=0; k<size; k++)
	     a2[k]=(double) a[k];
	  }
	else{ /* regular list */
	  tended struct descrip val;
	  for (k=0; k<size; k++,i++){
	    c_traverse(lp, &val, i); /* This is not very efficient */
	    if (!cnv:C_double(val, ap2->a[k]))
	      return RunError;
	    }
	  }
	}
      else{ /*( *dp is not a list, it is a ptr to an array of descriptors)*/
	dp = &dp[i];
	for (k=0; k<size; k++){
	  if (!cnv:C_double(*dp++, ap2->a[k]))
	    return RunError;
	    }
	  }
      } /* skip */
   
  /* for now, we only handle one dimensional lists */
   ap2->dims=NULL;
   
   /*
   * Fix type and location fields for the new realarray
   */
   dp2->vword.bptr = (union block *)
      alclisthdr(size, (union block *) ap2);
   dp2->dword = D_List;

   EVValD(dp2, e);
   return Succeeded;
}

int cpint2realarray(dptr dp1, dptr dp2, word i, word j, int copyelements)
{
   word size, bytes;
   struct b_intarray *ap;
   tended struct b_realarray *ap2;
   
   /*
   * Calculate the size of the sublist.
   */
   size = j - i;
   bytes = (word)(sizeof(struct b_list) + (word)sizeof(struct b_realarray) +
		size * (word)sizeof(double));
   if (!reserve(Blocks, bytes)) return RunError;
   
   Protect(ap2 = (struct b_realarray *) alcrealarray(size), return RunError);
   ap = (struct b_intarray *) BlkD(*dp1, List)->listhead;
   
   if (copyelements){
      word *a, k;
      double *b;
      
      a=ap->a;
      b=ap2->a;
   
      /* cop elements i throgh j to the new array ap2*/
      for (k=i-1, j=0; j<size; k++,j++)
	 b[j]=a[k];
      }
   
   if (ap->dims){
      word ndims;
      ndims = (ap->dims->Intarray.blksize - sizeof(struct b_intarray) +
	       sizeof(word)) / sizeof(word);
      /* The first dimension of the new array is reduced to size */
      ap2->dims->Intarray.a[1] = size ;
      /* The remaining dimensions are the same, just copy them. */
      for(i=2; i<ndims; i++)
	 ap2->dims->Intarray.a[i] = ap->dims->Intarray.a[i];
      }
   else
      ap2->dims = NULL;
   
   /*
   * Fix type and location fields for the new realarray
   */
   dp2->vword.bptr = (union block *)
      alclisthdr(size, (union block *) ap2);
   dp2->dword = D_List;

   EVValD(dp2, e);
   return Succeeded;
}


#begdef cprealarray_macro(f, e)
/*
 * cprealarray(dp1,dp2,i,j) - copy subarray dp1[i:j] into dp2.
 */
int f(dptr dp1, dptr dp2, word i, word j)
{
   word size, copyelements=1;
   struct b_realarray *ap;
   tended struct b_realarray *ap2;
   
   /*
    * Calculate the size of the sublist.
    */
   size =j - i;
   if (!reserve(Blocks, (word)(sizeof(struct b_list) +
			       (word)sizeof(struct b_realarray) +
				size * (word)sizeof(double))))  return RunError;
   
   Protect(ap2 = (struct b_realarray *) alcrealarray(size), return RunError);
   ap = (struct b_realarray *) BlkD(*dp1, List)->listhead;

   if (copyelements){
      word k;
      double *a, *b;
      
      a = ap->a;
      b = ap2->a;
   
      /* cop elements i throgh j to the new array ap2*/
      for (k=i-1, j=0; j<size; k++,j++)
	 b[j] = a[k];
      }
   
   if (ap->dims) {
      word ndims;
      ndims = (ap->dims->Intarray.blksize - sizeof(struct b_intarray) +
	       sizeof(word)) / sizeof(word);
      /* the first dimension of the new array is reduced to size */
      ap2->dims->Intarray.a[1]= size ;
      /* the remaining dimensions are the same, just copy them */
      for(i=2; i<ndims; i++)
	 ap2->dims->Intarray.a[i] = ap->dims->Intarray.a[i];
      }
   else
      ap2->dims=NULL;
   
   /*
   * Fix type and location fields for the new realarray
   */
   dp2->vword.bptr = (union block *)
      alclisthdr(size, (union block *) ap2);
   dp2->dword = D_List;

   EVValD(dp2, e);
   return Succeeded;
}
#enddef

#ifdef MultiProgram
cprealarray_macro(cprealarray_0, 0)
#else					/* MultiProgram */
cprealarray_macro(cprealarray, 0)
#endif					/* MultiProgram */

#begdef cpintarray_macro(f, e)
/*
* cpintarray(dp1,dp2,i,j) - copy subarray dp1[i:j] into dp2.
*/
int f(dptr dp1, dptr dp2, word i, word j)
{
   word size, copyelements=1;
   struct b_intarray *ap;
   tended struct b_intarray *ap2;
   
   /*
   * Calculate the size of the sublist.
   */
   size =j - i;
   if (!reserve(Blocks, (word)(sizeof(struct b_list) +
			       (word) sizeof(struct b_intarray) +
				size * (word) sizeof(word))))  return RunError;
   
   Protect(ap2 = (struct b_intarray *) alcintarray(size), return RunError);
   ap = (struct b_intarray *) BlkD(*dp1, List)->listhead;
   
   if (copyelements){
      word *a, *b, k;
      
      a = ap->a;
      b = ap2->a;
   
      /* copy elements i through j to the new array ap2 */
      for (k=i-1, j=0; j<size; k++,j++)
	 b[j] = a[k];
      }
   
   if (ap->dims) {
      word ndims = (ap->dims->Intarray.blksize - sizeof(struct b_intarray) +
		    sizeof(word)) / sizeof(word);
      ap2->dims->Intarray.a[1] = size;
      for(i=2; i<ndims; i++)
	 ap2->dims->Intarray.a[i]=ap->dims->Intarray.a[i];
      }
   else
      ap2->dims=NULL;
   
   /*
   * Fix type and location fields for the new intarray
   */
   dp2->vword.bptr = (union block *)
      alclisthdr(size, (union block *) ap2);
   dp2->dword = D_List;
   EVValD(dp2, e);
   return Succeeded;
}
#enddef

#ifdef MultiProgram
cpintarray_macro(cpintarray_0, 0)
#else					/* MultiProgram */
cpintarray_macro(cpintarray, 0)
#endif					/* MultiProgram */

/*
 * Convert a list to an array. If not possible, return the original list
 */
struct descrip listtoarray(dptr l)
{
  tended struct b_list *hp;
  struct descrip *first;
  struct b_lelem *bp;
  struct descrip ans;
  int bsize, num;
  double *rp;
  word *ip;

  hp = BlkD(*l, List);
  MUTEX_LOCKBLK_CONTROLLED(hp, "listtoarray() lock list");
  if ((num = hp->size) <= 0) {
    MUTEX_UNLOCKBLK(hp, "listtoarray(): unlock list");
    return *l; /* An empty array is not very useful - return the original list */
  }

  /* Point bp at the first list block.  */
  bp = (struct b_lelem *) hp->listhead;
  /* Is it an array already? */
  if ((bp->title == T_Intarray) || (bp->title == T_Realarray)) {
    MUTEX_UNLOCKBLK(hp, "listtoarray(): unlock list");
    return *l;
  }

  /*
   * Decide whether to create a real array or an integer array (or neither)
   * based on the type of the first element in the list
   */

  /* If the first block has no elements in use, point bp at the next list block.*/
  if (bp->nused <= 0) {
    bp = (struct b_lelem *) bp->listnext;
    hp->listhead = (union block *) bp;
    bp->listprev = (union block *) hp;
  }

   /* Locate first element    */
   first = &bp->lslots[bp->first];

   type_case *first of {
     integer: {
       /* Make a single dimensional integer array */
       bsize = sizeof(struct b_intarray) + (num - 1)*sizeof(word);
       if (!reserve(Blocks, (word)(sizeof(struct b_list) + bsize))) {
         MUTEX_UNLOCKBLK(hp, "listtoarray(): unlock list");
         return *l;
       }

       ans.vword.bptr =  (union block *) alclisthdr(num,(union block *)alcintarray(num));
       ans.dword = D_List;
       rp = NULL;
       ip = &ans.vword.bptr->List.listhead->Intarray.a[0];
     }

     real: {
       /* Make a single dimensional real array */
       bsize = sizeof(struct b_realarray) + (num - 1)*sizeof(double);
       if (!reserve(Blocks, (word)(sizeof(struct b_list) + bsize))) {
         MUTEX_UNLOCKBLK(hp, "listtoarray(): unlock list");
         return *l;
       }

       ans.vword.bptr =  (union block *) alclisthdr(num,(union block *)alcrealarray(num));
       ans.dword = D_List;
       ip = NULL;
       rp = &ans.vword.bptr->List.listhead->Realarray.a[0];
     }

     default: { /* Cannot convert to an array */
       MUTEX_UNLOCKBLK(hp, "listtoarray(): unlock list");
       return *l;
     }
   }

   /* Go through the list copying the list values into the array elements.  */
   /* If any value cannot be assigned, give up and return the original list.*/
   /* The list traversal code has been "liberated" from the max function.   */
   {
     union block *bp = l->vword.bptr;
     int i,j;

     for (bp = Blk(bp,List)->listhead; BlkType(bp) == T_Lelem;
          bp = Blk(bp,Lelem)->listnext) {
       for (i = 0; i < Blk(bp,Lelem)->nused; i++) {
         j = bp->Lelem.first + i;
         if (j >= bp->Lelem.nslots)
           j -= bp->Lelem.nslots;

         type_case bp->Lelem.lslots[j] of {
         integer: {
             if (ip == NULL) {  /* Wrong type for the target array */
               MUTEX_UNLOCKBLK(hp, "listtoarray(): unlock list");
               return *l;
             } else {
               *ip++ = bp->Lelem.lslots[j].vword.integr;
             }
           }

         real: {
             if (rp == NULL) {  /* Wrong type for the target array */
               MUTEX_UNLOCKBLK(hp, "listtoarray(): unlock list");
               return *l;
             } else {
#ifdef DescriptorDouble
               *rp++ = bp->Lelem.lslots[j].vword.realval;
#else
               *rp++ = ((struct b_real *)(bp->Lelem.lslots[j].vword.bptr))->realval;
#endif /* DescriptorDouble */
             }
           }

           default: { /* Wrong type for the target array */
             MUTEX_UNLOCKBLK(hp, "listtoarray(): unlock list");
             return *l;
           }
         } /* type_case per list element */
       } /* per slot */
     } /* per list element block */
   }

   MUTEX_UNLOCKBLK(hp, "listtoarray(): unlock list");
   return ans;
}

#endif					/* Arrays */
