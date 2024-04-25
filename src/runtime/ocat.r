/*
 * File: ocat.r -- caterr, lconcat
 */

#ifdef PatternType
"x || y - concatenate strings and patterns x and y."
#else                                   /* PatternType */
"x || y - concatenate strings x and y."
#endif                                  /* PatternType */

operator{1} || cater(x, y)

#ifdef PatternType
   if is:pattern(x) then {
      abstract {
         return pattern;
         }
      body {
         struct b_pattern *lp, *rp;
         struct b_pelem *pe;
         union block *bp;

         if (!cnv_pattern(&y, &y)) runerr(127, y);

         lp = (struct b_pattern *)BlkLoc(x);
         rp = (struct b_pattern *)BlkLoc(y);

         /* perform concatenation in patterns */
         pe = (struct b_pelem *)Concat(Copy((struct b_pelem *)lp->pe), Copy((struct b_pelem *)rp->pe), rp->stck_size);
         bp = (union block *)pattern_make_pelem(lp->stck_size + rp->stck_size,pe);
         return pattern(bp);
         }
      }
   else if is:pattern(y) then {
      abstract {
         return pattern;
         }
      body {
         struct b_pattern *lp, *rp;
         struct b_pelem *pe;
         union block *bp;

         if (!cnv_pattern(&x, &x)) runerr(127, x);

         lp = (struct b_pattern *)BlkLoc(x);
         rp = (struct b_pattern *)BlkLoc(y);

         /* perform concatenation in patterns */
         pe = (struct b_pelem *)Concat(Copy((struct b_pelem *)lp->pe),
                                 Copy((struct b_pelem *)rp->pe), rp->stck_size);
         bp = (union block *)pattern_make_pelem(lp->stck_size+rp->stck_size,pe);
         return pattern(bp);
         }
      }
   else {
#endif                          /* PatternType */

   if !cnv:string(x) then
      runerr(103, x)
   if !cnv:string(y) then
      runerr(103, y)

   abstract {
      return string
      }

   body {
      CURTSTATE();

      /*
       *  Optimization 1:  The strings to be concatenated are already
       *   adjacent in memory; no allocation is required.
       */
      if (StrLoc(x) + StrLen(x) == StrLoc(y)) {
         StrLoc(result) = StrLoc(x);
         StrLen(result) = StrLen(x) + StrLen(y);
         return result;
         }
      else if ((StrLoc(x) + StrLen(x) == strfree) &&
               (DiffPtrs(strend,strfree) > StrLen(y))) {
         /*
          * Optimization 2: The end of x is at the end of the string space.
          *  Hence, x was the last string allocated and need not be
          *  re-allocated. y is appended to the string space and the
          *  result is pointed to the start of x.
          */
         result = x;
         /*
          * Append y to the end of the string space.
          */
         Protect(alcstr(StrLoc(y),StrLen(y)), runerr(0));
         /*
          *  Set the length of the result and return.
          */
         StrLen(result) = StrLen(x) + StrLen(y);
         return result;
         }

      /*
       * Otherwise, allocate space for x and y, and copy them
       *  to the end of the string space.
       */
      Protect(StrLoc(result) = alcstr(NULL, StrLen(x) + StrLen(y)), runerr(0));
      memcpy(StrLoc(result), StrLoc(x), StrLen(x));
      memcpy(StrLoc(result) + StrLen(x), StrLoc(y), StrLen(y));

      /*
       *  Set the length of the result and return.
       */
      StrLen(result) = StrLen(x) + StrLen(y);
      return result;
      }

#ifdef PatternType
   }
#endif                                  /* PatternType */

end


"x ||| y - concatenate lists x and y."

operator{1} ||| lconcat(x, y)
   /*
    * x and y must be lists.
    */
   if !is:list(x) then
      runerr(108, x)
   if !is:list(y) then
      runerr(108, y)

   abstract {
      return new list(store[(type(x) ++ type(y)).lst_elem])
      }

   body {
      register struct b_list *bp1;
      register struct b_lelem *lp1;
      word size1, size2, size3;

      /*
       * Get the size of both lists.
       */
      size1 = BlkD(x,List)->size;
      size2 = BlkD(y,List)->size;
      size3 = size1 + size2;

      Protect(bp1 = (struct b_list *)alclist_raw(size3, size3), runerr(0));
      lp1 = (struct b_lelem *) (bp1->listhead);

      /*
       * Make a copy of both lists in adjacent slots.
       */
      cpslots(&x, lp1->lslots, (word)1, size1 + 1);
      cpslots(&y, lp1->lslots + size1, (word)1, size2 + 1);

      BlkLoc(x) = (union block *)bp1;

      EVValD(&x, E_Lcreate);

      return x;
      }
end
