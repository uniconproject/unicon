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
         SetStrLen(result, StrLen(x) + StrLen(y));
         if (IsUniQual(x) || IsUniQual(y)) {
            SetUniQual(result);
            /*
             * cp_count propagation: an untagged operand is pure ASCII,
             * so its own StrLen IS its codepoint count -- no sentinel
             * concern there. A tagged operand contributes its cached
             * CpCount if known, else the sum can't be trusted either.
             */
            {
            word uq_xcnt = IsUniQual(x) ? CpCount(x) : StrLen(x);
            word uq_ycnt = IsUniQual(y) ? CpCount(y) : StrLen(y);
            int  uq_xok  = !IsUniQual(x) || (uq_xcnt != CpCountSentinel);
            int  uq_yok  = !IsUniQual(y) || (uq_ycnt != CpCountSentinel);
            if (uq_xok && uq_yok && (uword)(uq_xcnt + uq_ycnt) <= CpCountMax)
               SetCpCount(result, uq_xcnt + uq_ycnt);
            }
            }
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
          *  Set the length of the result and return. result already
          *  carried x's tag via the whole-descriptor copy above, but
          *  SetStrLen's full-dword overwrite (by design -- see
          *  rmacros.h) clears it along with everything else, so it
          *  has to be re-set here just like the other two paths, not
          *  assumed to have survived the copy.
          */
         SetStrLen(result, StrLen(x) + StrLen(y));
         if (IsUniQual(x) || IsUniQual(y)) {
            SetUniQual(result);
            {
            word uq_xcnt = IsUniQual(x) ? CpCount(x) : StrLen(x);
            word uq_ycnt = IsUniQual(y) ? CpCount(y) : StrLen(y);
            int  uq_xok  = !IsUniQual(x) || (uq_xcnt != CpCountSentinel);
            int  uq_yok  = !IsUniQual(y) || (uq_ycnt != CpCountSentinel);
            if (uq_xok && uq_yok && (uword)(uq_xcnt + uq_ycnt) <= CpCountMax)
               SetCpCount(result, uq_xcnt + uq_ycnt);
            }
            }
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
      SetStrLen(result, StrLen(x) + StrLen(y));
      if (IsUniQual(x) || IsUniQual(y)) {
         SetUniQual(result);
         {
         word uq_xcnt = IsUniQual(x) ? CpCount(x) : StrLen(x);
         word uq_ycnt = IsUniQual(y) ? CpCount(y) : StrLen(y);
         int  uq_xok  = !IsUniQual(x) || (uq_xcnt != CpCountSentinel);
         int  uq_yok  = !IsUniQual(y) || (uq_ycnt != CpCountSentinel);
         if (uq_xok && uq_yok && (uword)(uq_xcnt + uq_ycnt) <= CpCountMax)
            SetCpCount(result, uq_xcnt + uq_ycnt);
         }
         }
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
