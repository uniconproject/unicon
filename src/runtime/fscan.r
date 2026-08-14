/*
 * File: fscan.r
 *  Contents: move, pos, tab.
 */

"move(i) - move &pos by i, return substring of &subject spanned."
" Reverses effects if resumed."

function{0,1+} move(i)

   if !def:C_integer(i, 1) then
      runerr(101,i)

   abstract {
      return string
      }

   body {
      register C_integer j;
      C_integer oldpos;
      word uq_total;
      CURTSTATE();

      /*
       * Save old &pos.  Local variable j holds &pos before the move.
       *
       * Uniconde Phase 0: if &subject is tagged, i/j/&pos mean
       * codepoints, not bytes -- the position arithmetic itself
       * (bounds checks, +=) is already unit-agnostic (same principle
       * as cvpos(), design doc §4), so it needs no changes at all.
       * Only the final substring extraction, which turns an abstract
       * position into an actual byte pointer, needs a tagged-aware
       * branch. uq_total replaces StrLen(k_subject) everywhere it was
       * used as a bound, computed once via the same cached-count-or-
       * fallback-scan pattern already used for *size.
       */
      oldpos = j = k_pos;

      if (IsUniQual(k_subject)) {
         if (CpCount(k_subject) != CpCountSentinel)
            uq_total = CpCount(k_subject);
         else
            uq_scan((unsigned char *)StrLoc(k_subject), StrLen(k_subject), &uq_total);
         }
      else
         uq_total = StrLen(k_subject);

      /*
       * If attempted move is past either end of the string, fail.
       */
      if (i + j <= 0 || i + j > uq_total + 1)
         fail;

      /*
       * Set new &pos.
       */
      k_pos += i;
      EVVal(k_pos, E_Spos);

      /*
       * Make sure i >= 0.
       */
      if (i < 0) {
         j += i;
         i = -i;
         }

      /*
       * Suspend substring of &subject that was moved over.
       */
      if (IsUniQual(k_subject)) {
         unsigned char *uq_bytes = (unsigned char *)StrLoc(k_subject);
         word uq_start = uq_seek_cp(uq_bytes, j - 1);
         word uq_end = uq_seek_cp(uq_bytes, j - 1 + i);
         suspend string(uq_end - uq_start, (char *)(uq_bytes + uq_start));
         }
      else
         suspend string(i, StrLoc(k_subject) + j - 1);

      /*
       * If move is resumed, restore the old position and fail.
       */
      if (oldpos > uq_total + 1)
         runerr(205, kywd_pos);
      else {
         k_pos = oldpos;
         EVVal(k_pos, E_Spos);
         }

      fail;
      }
end


"pos(i) - test if &pos is at position i in &subject."

function{0,1} pos(i)

   if !cnv:C_integer(i) then
      runerr(101, i)

   abstract {
      return integer
      }
   body {
      word uq_total;
      CURTSTATE();

      /*
       * Uniconde Phase 0: pos() never touches actual bytes -- it's
       * purely a position comparison, and cvpos() is already
       * unit-agnostic (design doc §4). Only the bound passed to it
       * needs to mean codepoints instead of bytes for a tagged subject.
       */
      if (IsUniQual(k_subject)) {
         if (CpCount(k_subject) != CpCountSentinel)
            uq_total = CpCount(k_subject);
         else
            uq_scan((unsigned char *)StrLoc(k_subject), StrLen(k_subject), &uq_total);
         }
      else
         uq_total = StrLen(k_subject);

      /*
       * Fail if &pos is not equivalent to i, return i otherwise.
       */
      if ((i = cvpos(i, uq_total)) != k_pos)
         fail;
      return C_integer i;
      }
end


"tab(i) - set &pos to i, return substring of &subject spanned."
"Reverses effects if resumed."

function{0,1+} tab(i)

   if !def:C_integer(i, 0) then
      runerr(101, i);

   abstract {
      return string
      }

   body {
      C_integer j, t, oldpos;
      word uq_total;
      CURTSTATE();

      /*
       * Uniconde Phase 0: same shape as move() -- uq_total replaces
       * StrLen(k_subject) as the bound everywhere (cvpos() is already
       * unit-agnostic), and only the final substring extraction needs
       * a tagged-aware branch to turn positions into byte pointers.
       */
      if (IsUniQual(k_subject)) {
         if (CpCount(k_subject) != CpCountSentinel)
            uq_total = CpCount(k_subject);
         else
            uq_scan((unsigned char *)StrLoc(k_subject), StrLen(k_subject), &uq_total);
         }
      else
         uq_total = StrLen(k_subject);

      /*
       * Convert i to an absolute position.
       */
      i = cvpos(i, uq_total);
      if (i == CvtFail)
         fail;

      /*
       * Save old &pos.  Local variable j holds &pos before the tab.
       */
      oldpos = j = k_pos;

      /*
       * Set new &pos.
       */
      k_pos = i;
      EVVal(k_pos, E_Spos);

      /*
       *  Make i the length of the substring &subject[i:j]
       */
      if (j > i) {
         t = j;
         j = i;
         i = t - j;
         }
      else
         i = i - j;

      /*
       * Suspend the portion of &subject that was tabbed over.
       */
      if (IsUniQual(k_subject)) {
         unsigned char *uq_bytes = (unsigned char *)StrLoc(k_subject);
         word uq_start = uq_seek_cp(uq_bytes, j - 1);
         word uq_end = uq_seek_cp(uq_bytes, j - 1 + i);
         suspend string(uq_end - uq_start, (char *)(uq_bytes + uq_start));
         }
      else
         suspend string(i, StrLoc(k_subject) + j - 1);

      /*
       * If tab is resumed, restore the old position and fail.
       */
      if (oldpos > uq_total + 1)
         runerr(205, kywd_pos);
      else {
         k_pos = oldpos;
         EVVal(k_pos, E_Spos);
         }

      fail;
      }
end
