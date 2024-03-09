/*
 * File: oasgn.r
 */

/*
 * Asgn - perform an assignment when the destination descriptor might
 *  be within a block.
 */
#define Asgn(dest, src) *(dptr)((word *)VarLoc(dest) + Offset(dest)) = src;

/*
 * GeneralAsgn - perform the assignment x := y, where x is known to be
 *  a variable and y is has been dereferenced.
 */
#begdef GeneralAsgn(x, y)

   body {
      EVVar(&x, E_Assign);
      }

   type_case x of {
      tvsubs: {
        abstract {
           store[store[type(x).str_var]] = string
           }
        inline {
           if (subs_asgn(&x, (const dptr)&y) == RunError)
              runerr(0);
           }
        }
      tvtbl: {
        abstract {
           store[store[type(x).trpd_tbl].tbl_val] = type(y)
           }
        inline {
           if (tvtbl_asgn(&x, (const dptr)&y) == RunError)
              runerr(0);
           }
         }
      tvmonitored: {
#ifdef MonitoredTrappedVar
        abstract {
           store[store[type(x).trpd_monitored]] = type(y)
           }
        inline {
           if (tvmonitored_asgn(&x, (const dptr)&y) == RunError)
              runerr(0);
           }
#endif                                /* MonitoredTrappedVar */
         }
      kywdevent:
         body {
            *VarLoc(x) = y;
            }
      kywdwin:
         body {
#ifdef Graphics
            if (is:null(y))
               *VarLoc(x) = y;
            else {
               if ((!is:file(y)) || !(BlkD(y,File)->status & Fs_Window))
                  runerr(140,y);
               *VarLoc(x) = y;
               }
#endif                                  /* Graphics */
            }
      kywdint:
         {
         /*
          * No side effect in the type realm - keyword x is still an int.
          */
         body {
            C_integer i;

            if (!cnv:C_integer(y, i))
               runerr(101, y);
            IntVal(*VarLoc(x)) = i;

#ifdef Graphics
            if (xyrowcol(&x) == -1)
               runerr(140,kywd_xwin[XKey_Window]);
#endif                                  /* Graphics */
            }
        }
      kywdpos: {
         /*
          * No side effect in the type realm - &pos is still an int.
          */
         body {
            C_integer i;
#ifndef Arrays
            CURTSTATE();
#endif                                  /* Arrays */
            if (!cnv:C_integer(y, i))
               runerr(101, y);

#if defined(MultiProgram) || ConcurrentCOMPILER
            /*
             * Assuming (ahem) that the address of &subject is the next
             * descriptor following &pos, which is true in struct threadstate,
             * then we can access it via our reference to &pos, rather than
             * needing to lookup the curtstate to find the former global.
             */
            i = cvpos((long)i, StrLen(*(VarLoc(x)+1)));
#else                                   /* MultiProgram || ConcurrentCOMPILER */
            i = cvpos((long)i, StrLen(k_subject));
#endif                                  /* MultiProgram || ConcurrentCOMPILER */

            if (i == CvtFail)
               fail;
            IntVal(*VarLoc(x)) = i;

            EVVal(k_pos, E_Spos);
            }
         }
      kywdsubj: {
         /*
          * No side effect in the type realm - &subject is still a string
          *  and &pos is still an int.
          */
         if !cnv:string(y, *VarLoc(x)) then
            runerr(103, y);
         inline {
#ifndef Arrays
           CURTSTATE();
#endif                                  /* Arrays */
#ifdef MultiProgram
            IntVal(*(VarLoc(x)-1)) = 1;
#else                                   /* MultiProgram */
            k_pos = 1;
#endif                                  /* MultiProgram */
            EVVal(k_pos, E_Spos);
            }
         }
      kywdstr: {
         /*
          *  No side effect in the type realm.
          */
         if !cnv:string(y, *VarLoc(x)) then
            runerr(103, y);
         }
      default: {
         abstract {
            store[type(x)] = type(y)
            }
         inline {
#ifdef Arrays
            if ( Offset(x)>0 ) {
               /* don't know actual title, don't use checking BlkD macro */
               if (BlkLoc(x)->Realarray.title==T_Realarray){
                  double yy;
                  if (cnv:C_double(y, yy)){
                     *(double *)( (word *) VarLoc(x) + Offset(x)) = yy;
                     }
                  else{ /* y is not real, try to convert the realarray to list*/
                     tended struct b_list *xlist= BlkD(x, Realarray)->listp;
                     tended struct descrip dlist;
                     word i;

                     i = (Offset(x)*sizeof(word)-sizeof(struct b_realarray)
                        +sizeof(double)) / sizeof(double);

                     dlist.vword.bptr = (union block *) xlist;
                     dlist.dword = D_List;
                     if (arraytolist(&dlist)!=Succeeded) fail;

                     /*
                      * assuming the new list has one lelem block only,
                      * i should be in the first block. no need to loop
                      * through several blocks
                      */

                     *(dptr)(&xlist->listhead->Lelem.lslots[i]) = y;
                     }
               }
               /* don't know actual title, don't use checking BlkD macro */
               else if (BlkLoc(x)->Intarray.title==T_Intarray){
                  C_integer ii;
                  if (cnv:(exact)C_integer(y, ii))
                     *((word *)VarLoc(x) + Offset(x)) = ii;
                  else{ /* y is not integer, try to convert the intarray to list*/
                     tended struct b_list *xlist= BlkD(x, Intarray)->listp;
                     tended struct descrip dlist;
                     word i;

                     i = (Offset(x)*sizeof(word)-sizeof(struct b_intarray)+
                        sizeof(word)) / sizeof(word);

                     dlist.vword.bptr = (union block *) xlist;
                     dlist.dword = D_List;
                     if (arraytolist(&dlist)!=Succeeded) fail;

                     /*
                     * assuming the new list has one lelem block only,
                     * i should be in the first block. no need to loop
                     * through several blocks
                     */

                     *(dptr)(&xlist->listhead->Lelem.lslots[i]) = y;
                     }
                  }
               else
                  Asgn(x, y)
            }
            else
#endif                                  /* Arrays */

            Asgn(x, y)
            }
         }
      }

#if E_Value
   body {
      EVValD(&y, E_Value);
      }
#endif                                  /* E_Value */

#enddef


"x := y - assign y to x."

operator{0,1} := asgn(underef x, y)

   if !is:variable(x) then
      runerr(111, x)

   abstract {
      return type(x)
      }

   GeneralAsgn(x, y)

   inline {
#ifdef PatternType
      if (is:tvsubs(x)) {
         return BlkD(x, Tvsubs)->ssvar;
         }
#endif
      /*
       * The returned result is the variable to which assignment is being
       *  made.
       */
      return x;
      }
end


"x <- y - assign y to x."
" Reverses assignment if resumed."

operator{0,1+} <- rasgn(underef x -> saved_x, y)

   if !is:variable(x) then
      runerr(111, x)

   abstract {
      return type(x)
      }

   GeneralAsgn(x, y)

   inline {
      suspend x;
      }

   GeneralAsgn(x, saved_x)

   inline {
      fail;
      }
end


"x <-> y - swap values of x and y."
" Reverses swap if resumed."

operator{0,1+} <-> rswap(underef x -> dx, underef y -> dy)

   declare {
      tended union block *bp_x, *bp_y;
      word adj1 = 0;
      word adj2 = 0;
      }

   if !is:variable(x) then
      runerr(111, x)
   if !is:variable(y) then
      runerr(111, y)

   abstract {
      return type(x)
      }

   if is:tvsubs(x) && is:tvsubs(y) then
      body {
         bp_x = (union block *)BlkD(x,Tvsubs);
         bp_y = (union block *)BlkD(y,Tvsubs);
         if (VarLoc(bp_x->Tvsubs.ssvar) == VarLoc(bp_y->Tvsubs.ssvar) &&
          Offset(bp_x->Tvsubs.ssvar) == Offset(bp_y->Tvsubs.ssvar)) {
            /*
             * x and y are both substrings of the same string, set
             *  adj1 and adj2 for use in locating the substrings after
             *  an assignment has been made.  If x is to the right of y,
             *  set adj1 := *x - *y, otherwise if y is to the right of
             *  x, set adj2 := *y - *x.  Note that the adjustment
             *  values may be negative.
             */
            if (bp_x->Tvsubs.sspos > bp_y->Tvsubs.sspos)
               adj1 = bp_x->Tvsubs.sslen - bp_y->Tvsubs.sslen;
            else if (bp_y->Tvsubs.sspos > bp_x->Tvsubs.sspos)
               adj2 = bp_y->Tvsubs.sslen - bp_x->Tvsubs.sslen;
            }
         }

   /*
    * Do x := y
    */
   GeneralAsgn(x, dy)

   if is:tvsubs(x) && is:tvsubs(y) then
      inline {
         if (adj2 != 0) {
            /*
             * Arg2 is to the right of Arg1 and the assignment Arg1 := Arg2 has
             *  shifted the position of Arg2.  Add adj2 to the position of Arg2
             *  to account for the replacement of Arg1 by Arg2.
             */
            Blk(bp_y, Tvsubs)->sspos += adj2;
            }
         }

   /*
    * Do y := x
    */
   GeneralAsgn(y, dx)

   if is:tvsubs(x) && is:tvsubs(y) then
      inline {
         if (adj1 != 0) {
            /*
             * Arg1 is to the right of Arg2 and the assignment Arg2 := Arg1
             *  has shifted the position of Arg1.  Add adj2 to the position
             *  of Arg1 to account for the replacement of Arg2 by Arg1.
             */
            Blk(bp_x, Tvsubs)->sspos += adj1;
            }
         }

   inline {
      suspend x;
      }
   /*
    * If resumed, the assignments are undone.  Note that the string position
    *  adjustments are opposite those done earlier.
    */
   GeneralAsgn(x, dx)
   if is:tvsubs(x) && is:tvsubs(y) then
      inline {
         if (adj2 != 0) {
           Blk(bp_y, Tvsubs)->sspos -= adj2;
           }
         }

   GeneralAsgn(y, dy)
   if is:tvsubs(x) && is:tvsubs(y) then
      inline {
         if (adj1 != 0) {
            Blk(bp_x,Tvsubs)->sspos -= adj1;
            }
         }

   inline {
      fail;
      }
end


"x :=: y - swap values of x and y."

operator{0,1} :=: swap(underef x -> dx, underef y -> dy)
   declare {
      tended union block *bp_x, *bp_y;
      word adj1 = 0;
      word adj2 = 0;
      }

   /*
    * x and y must be variables.
    */
   if !is:variable(x) then
      runerr(111, x)
   if !is:variable(y) then
      runerr(111, y)

   abstract {
      return type(x)
      }

   if is:tvsubs(x) && is:tvsubs(y) then
      body {
         bp_x = (union block *)BlkD(x,Tvsubs);
         bp_y = (union block *)BlkD(y,Tvsubs);
         if (VarLoc(bp_x->Tvsubs.ssvar) == VarLoc(bp_y->Tvsubs.ssvar) &&
          Offset(bp_x->Tvsubs.ssvar) == Offset(bp_y->Tvsubs.ssvar)) {
            /*
             * x and y are both substrings of the same string, set
             *  adj1 and adj2 for use in locating the substrings after
             *  an assignment has been made.  If x is to the right of y,
             *  set adj1 := *x - *y, otherwise if y is to the right of
             *  x, set adj2 := *y - *x.  Note that the adjustment
             *  values may be negative.
             */
            if (bp_x->Tvsubs.sspos > bp_y->Tvsubs.sspos)
               adj1 = bp_x->Tvsubs.sslen - bp_y->Tvsubs.sslen;
            else if (bp_y->Tvsubs.sspos > bp_x->Tvsubs.sspos)
               adj2 = bp_y->Tvsubs.sslen - bp_x->Tvsubs.sslen;
            }
         }

   /*
    * Do x := y
    */
   GeneralAsgn(x, dy)

   if is:tvsubs(x) && is:tvsubs(y) then
      inline {
         if (adj2 != 0) {
            /*
             * Arg2 is to the right of Arg1 and the assignment Arg1 := Arg2 has
             *  shifted the position of Arg2.  Add adj2 to the position of Arg2
             *  to account for the replacement of Arg1 by Arg2.
             */
            Blk(bp_y,Tvsubs)->sspos += adj2;
            }
         }

   /*
    * Do y := x
    */
   GeneralAsgn(y, dx)

   if is:tvsubs(x) && is:tvsubs(y) then
      inline {
         if (adj1 != 0) {
            /*
             * Arg1 is to the right of Arg2 and the assignment Arg2 := Arg1
             *  has shifted the position of Arg1.  Add adj2 to the position
             *  of Arg1 to account for the replacement of Arg2 by Arg1.
             */
            Blk(bp_x,Tvsubs)->sspos += adj1;
            }
         }

   inline {
      return x;
      }
end

/*
 * subs_asgn - perform assignment to a substring. Leave the updated substring
 *  in dest in case it is needed as the result of the assignment.
 */
int subs_asgn(dest, src)
dptr dest;
const dptr src;
   {
   tended struct descrip deststr;
   tended struct descrip srcstr;
   tended struct descrip rsltstr;
   tended struct b_tvsubs *tvsub;

   char *s;
   word len;
   word prelen;   /* length of portion of string before substring */
   word poststrt; /* start of portion of string following substring */
   word postlen;  /* length of portion of string following substring */

   if (!cnv:tmp_string(*src, srcstr))
      ReturnErrVal(103, *src, RunError);

   /*
    * Be sure that the variable in the trapped variable points
    *  to a string and that the string is big enough to contain
    *  the substring.
    */
   tvsub = BlkD(*dest, Tvsubs);
   deref(&tvsub->ssvar, &deststr);
   if (!is:string(deststr))
      ReturnErrVal(103, deststr, RunError);
   prelen = tvsub->sspos - 1;
   poststrt = prelen + tvsub->sslen;
   if (poststrt > StrLen(deststr))
      ReturnErrNum(205, RunError);

   /*
    * Form the result string.
    *  Start by allocating space for the entire result.
    */
   len = prelen + StrLen(srcstr) + StrLen(deststr) - poststrt;
   Protect(s = alcstr(NULL, len), return RunError);
   StrLoc(rsltstr) = s;
   StrLen(rsltstr) = len;
   /*
    * First, copy the portion of the substring string to the left of
    *  the substring into the string space.
    */

   memcpy(StrLoc(rsltstr), StrLoc(deststr), prelen);

   /*
    * Copy the string to be assigned into the string space,
    *  effectively concatenating it.
    */

   memcpy(StrLoc(rsltstr)+prelen, StrLoc(srcstr), StrLen(srcstr));

   /*
    * Copy the portion of the substring to the right of
    *  the substring into the string space, completing the
    *  result.
    */


   postlen = StrLen(deststr) - poststrt;

   memcpy(StrLoc(rsltstr)+prelen+StrLen(srcstr), StrLoc(deststr)+poststrt, postlen);

   /*
    * Perform the assignment and update the trapped variable.
    */
   type_case tvsub->ssvar of {
      kywdevent: {
         *VarLoc(tvsub->ssvar) = rsltstr;
         }
      kywdstr: {
         *VarLoc(tvsub->ssvar) = rsltstr;
         }
      kywdsubj: {
         *VarLoc(tvsub->ssvar) = rsltstr;
         k_pos = 1;
         }
      tvtbl: {
         if (tvtbl_asgn(&tvsub->ssvar, (const dptr)&rsltstr) == RunError)
            return RunError;
         }
      default: {
         Asgn(tvsub->ssvar, rsltstr);
         }
      }
   tvsub->sslen = StrLen(srcstr);

   EVVal(tvsub->sslen, E_Ssasgn);
   return Succeeded;
   }

/*
 * tvtbl_asgn - perform an assignment to a table element trapped variable,
 *  inserting the element in the table if needed.
 */
int tvtbl_asgn(dest, src)
dptr dest;
const dptr src;
   {
   tended struct b_tvtbl *bp;
   tended struct descrip tval;
   struct b_telem *te;
   union block **slot;
   struct b_table *tp;
   int res;

   /*
    * Allocate te now (even if we may not need it)
    * because slot cannot be tended.
    */
   bp = BlkD(*dest, Tvtbl);     /* Save params to tended vars */
   tval = *src;

   if (BlkType(bp->clink) == T_File) {
      int status = Blk(bp->clink,File)->status;
#ifdef Dbm
      if (status & Fs_Dbm) {
         int rv;
         DBM *db;
         datum key, content;
         db = Blk(bp->clink,File)->fd.dbm;
         /*
          * we are doing an assignment to a subscripted DBM file, treat same
          * as insert().  key is bp->tref, and value is src
          */
         if (!cnv:string(bp->tref, bp->tref)) { /* key */
            ReturnErrVal(103, bp->tref, RunError);
            }
         if (!cnv:string(tval, tval)) { /* value */
            ReturnErrVal(103, tval, RunError);
            }
         key.dptr = StrLoc(bp->tref);
         key.dsize = StrLen(bp->tref);
         content.dptr = StrLoc(tval);
         content.dsize = StrLen(tval);
         if ((rv = dbm_store(db, key, content, DBM_REPLACE)) < 0) {
            fprintf(stderr, "dbm_store returned %d\n", rv);
            fflush(stderr);
            return Failed;
            }
         return Succeeded;
         }
      else
#endif                                  /* Dbm */
         return Failed; /* should set runerr instead, or maybe syserr */
      }

   Protect(te = alctelem(), return RunError);

   /*
    * First see if reference is in the table; if it is, just update
    *  the value.  Otherwise, allocate a new table entry.
    */
   slot = memb(bp->clink, &bp->tref, bp->hashnum, &res);

   if (res == 1) {
      /*
       * Do not need new te, just update existing entry.
       */
      deallocate((union block *) te);
      (*slot)->Telem.tval = tval;
      }
   else {
      /*
       * Link te into table, fill in entry.
       */
      tp = (struct b_table *) bp->clink;
      tp->size++;

      te->clink = *slot;
      *slot = (union block *) te;

      te->hashnum = bp->hashnum;
      te->tref = bp->tref;
      te->tval = tval;

      if (TooCrowded(tp))               /* grow hash table if now too full */
         hgrow((union block *)tp);
      }
   return Succeeded;
   }


#ifdef MonitoredTrappedVar
/*
 * tvmonitored_asgn - perform an assignment to a monitored trapped variable
 *   in the Target Program form the Monitor.
 */
int tvmonitored_asgn(dest, src)
dptr dest;
const dptr src;
   {
   word count;
   CURTSTATE();

   count = BlkD(curpstate->eventsource,Coexpr)->actv_count;
   if (count != BlkD(*dest,Tvmonitored)->cur_actv)
      ReturnErrVal(217, *dest, RunError);

   *VarLoc(BlkD(*dest,Tvmonitored)->tv) = *src;
   return Succeeded;
   }
#endif                                    /* MonitoredTrappedVar */
