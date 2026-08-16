/*
 * File: fstranl.r
 * String analysis functions: any,bal,find,many,match,upto
 *
 * str_anal is a macro for performing the standard conversions and
 *  defaulting for string analysis functions. It takes as arguments the
 *  parameters for subject, beginning position, and ending position. It
 *  produces declarations for these 3 names prepended with cnv_. These
 *  variables will contain the converted versions of the arguments.
 */
#begdef str_anal(s, i, j)
   declare {
      C_integer cnv_ ## i;
      C_integer cnv_ ## j;
      }

   abstract {
      return integer
      }

   if is:null(s) then {
      inline {
#if !ConcurrentCOMPILER
         CURTSTATE();
#endif                                     /* ConcurrentCOMPILER */
         s = k_subject;
         }
      if is:null(i) then inline {
#if !ConcurrentCOMPILER
         CURTSTATE();
#endif                                     /* ConcurrentCOMPILER */
         cnv_ ## i = k_pos;
         }
      }
   else {
      if !cnv:string(s) then
         runerr(103,s)
      if is:null(i) then inline {
         cnv_ ## i = 1;
         }
      }

   if !is:null(i) then
      if cnv:C_integer(i,cnv_ ## i) then inline {
         if ((cnv_ ## i = cvpos(cnv_ ## i, StrLen(s))) == CvtFail)
            fail;
         }
      else
         runerr(101,i)


    if is:null(j) then inline {
       cnv_ ## j = StrLen(s) + 1;
       }
    else if cnv:C_integer(j,cnv_ ## j) then inline {
       if ((cnv_ ## j = cvpos(cnv_ ## j, StrLen(s))) == CvtFail)
          fail;
       if (cnv_ ## i > cnv_ ## j) {
          register C_integer tmp;
          tmp = cnv_ ## i;
          cnv_ ## i = cnv_ ## j;
          cnv_ ## j = tmp;
          }
       }
    else
       runerr(101,j)

#enddef


"any(c,s,i1,i2) - produces min(i1,i2)+1 if s[min(i1,i2)] is contained "
"in c and i1 ~= i2, but fails otherwise."

function{0,1} any(c,s,i,j)
   str_anal( s, i, j )
   if !cnv:tmp_cset(c) then
      runerr(104,c)
   body {
      if (cnv_i == cnv_j)
         fail;
      if (!Testb(StrLoc(s)[cnv_i-1], c))
         fail;
      return C_integer cnv_i+1;
      }
end


"bal(c1,c2,c3,s,i1,i2) - generates the sequence of integer positions in s up to"
" a character of c1 in s[i1:i2] that is balanced with respect to characters in"
" c2 and c3, but fails if there is no such position."

function{*} bal(c1,c2,c3,s,i,j)
   str_anal( s, i, j )
   if !def:tmp_cset(c1,k_cset) then
      runerr(104,c1)
   if !def:tmp_cset(c2,lparcs) then
      runerr(104,c2)
   if !def:tmp_cset(c3,rparcs) then
      runerr(104,c3)

   body {
      C_integer cnt;
      char c;
      CURTSTATVAR();

      /*
       * Loop through characters in s[i:j].  When a character in c2
       * is found, increment cnt; when a character in c3 is found, decrement
       * cnt.  When cnt is 0 there have been an equal number of occurrences
       * of characters in c2 and c3, i.e., the string to the left of
       * i is balanced.  If the string is balanced and the current character
       * (s[i]) is in c, suspend with i.  Note that if cnt drops below
       *  zero, bal fails.
       */
      cnt = 0;
      while (cnv_i < cnv_j) {
         c = ToAscii(StrLoc(s)[cnv_i-1]);
         if (cnt == 0 && Testb(c, c1)) {
            suspend C_integer cnv_i;
            }
         if (Testb(c, c2))
            cnt++;
         else if (Testb(c, c3))
            cnt--;
         if (cnt < 0)
            fail;
         cnv_i++;
         }
      /*
       * Eventually fail.
       */
      fail;
      }
end


"find(s1,s2,i1,i2) - generates the sequence of positions in s2 at which "
"s1 occurs as a substring in s2[i1:i2], but fails if there is no such position."

function{*} find(s1,s2,i,j)
   str_anal( s2, i, j )
   if !cnv:string(s1) then
      runerr(103,s1)

   body {
      register char *str1, *str2;
      C_integer s1_len, l, term;
      CURTSTATVAR();

      s1_len = StrLen(s1);

      /*
       * Unicon: same reasoning as match() above -- i/j mean
       * codepoints for a tagged s2, the byte comparison itself doesn't
       * need to change (UTF-8 self-synchronization), only the position
       * bookkeeping does. Unlike match(), find() is a generator, so
       * this walks one codepoint at a time across the window, testing
       * s1 at each byte offset a codepoint boundary lands on, and
       * suspending the codepoint index rather than the byte offset.
       */
      if (IsUniQual(s2)) {
         word uq_ncps, uq_ii, uq_jj, uq_bpos, uq_bend;
         unsigned char *uq_bytes = (unsigned char *)StrLoc(s2);

         uq_scan(uq_bytes, StrLen(s2), &uq_ncps);

         if (is:null(i)) uq_ii = 1;
         else {
            C_integer uq_praw;
            if (!cnv_c_int(&i, &uq_praw)) fail;
            uq_ii = cvpos(uq_praw, uq_ncps);
            if (uq_ii == CvtFail) fail;
            }
         if (is:null(j)) uq_jj = uq_ncps + 1;
         else {
            C_integer uq_praw;
            if (!cnv_c_int(&j, &uq_praw)) fail;
            uq_jj = cvpos(uq_praw, uq_ncps);
            if (uq_jj == CvtFail) fail;
            }
         if (uq_ii > uq_jj) { word uq_t = uq_ii; uq_ii = uq_jj; uq_jj = uq_t; }

         uq_bpos = uq_seek_cp(uq_bytes, uq_ii - 1);
         uq_bend = uq_seek_cp(uq_bytes, uq_jj - 1);

         while (uq_ii < uq_jj) {
            if (uq_bpos + s1_len <= uq_bend) {
               str1 = StrLoc(s1);
               str2 = (char *)(uq_bytes + uq_bpos);
               l = s1_len;
               do {
                  if (l-- <= 0) {
                     suspend C_integer uq_ii;
                     break;
                     }
                  } while (*str1++ == *str2++);
               }
            uq_bpos += uq_lead_width(uq_bytes[uq_bpos]);
            uq_ii++;
            }
         fail;
         }

      /*
       * Loop through s2[i:j] trying to find s1 at each point, stopping
       * when the remaining portion s2[i:j] is too short to contain s1.
       * Optimize me!
       */
      term = cnv_j - s1_len;
      while (cnv_i <= term) {
         str1 = StrLoc(s1);
         str2 = StrLoc(s2) + cnv_i - 1;
         l    = s1_len;

         /*
          * Compare strings on a byte-wise basis; if the end is reached
          * before inequality is found, suspend with the position of the
          * string.
          */
         do {
            if (l-- <= 0) {
               suspend C_integer cnv_i;
               break;
               }
            } while (*str1++ == *str2++);
         cnv_i++;
         }
      fail;
      }
end


"many(c,s,i1,i2) - produces the position in s after the longest initial "
"sequence of characters in c in s[i1:i2] but fails if there is none."

function{0,1} many(c,s,i,j)
   str_anal( s, i, j )
   if !cnv:tmp_cset(c) then
      runerr(104,c)
   body {
      C_integer start_i = cnv_i;

      /*
       * Unicon Phase 0: str_anal (above) computed cnv_i/cnv_j using
       * StrLen(s) -- byte semantics. str_anal is an RTT-native
       * construct (not something in this file to edit directly), so
       * rather than touch it, a tagged s recomputes its own
       * codepoint-based bounds here from the original i/j parameters,
       * discarding str_anal's byte-based cnv_i/cnv_j, then walks
       * codepoint-by-codepoint via the shared uq_scan/uq_seek_cp/
       * uq_lead_width helpers (rmacros.h) instead of raw byte
       * indexing. A multi-byte codepoint can never test true against
       * a plain cset (only represents codepoints 0-255), so it always
       * correctly ends the run rather than needing its own cset logic
       * -- a b_unicset counterpart (design doc §8) would be needed to
       * do anything more than that.
       */
      if (IsUniQual(s)) {
         unsigned char *uq_bytes = (unsigned char *)StrLoc(s);
         word uq_blen = StrLen(s);
         word uq_ncps, uq_ii, uq_jj, uq_bpos;

         uq_scan(uq_bytes, uq_blen, &uq_ncps);
         if (is:null(i)) uq_ii = 1;
         else {
            C_integer uq_praw;
            if (!cnv_c_int(&i, &uq_praw)) fail;
            uq_ii = cvpos(uq_praw, uq_ncps);
            if (uq_ii == CvtFail) fail;
            }
         if (is:null(j)) uq_jj = uq_ncps+1;
         else {
            C_integer uq_praw;
            if (!cnv_c_int(&j, &uq_praw)) fail;
            uq_jj = cvpos(uq_praw, uq_ncps);
            if (uq_jj == CvtFail) fail;
            }
         if (uq_ii > uq_jj) { word uq_t = uq_ii; uq_ii = uq_jj; uq_jj = uq_t; }

         start_i = uq_ii;
         uq_bpos = uq_seek_cp(uq_bytes, uq_ii - 1);
         while (uq_ii < uq_jj) {
            int uq_w = uq_lead_width(uq_bytes[uq_bpos]);
            if (uq_w > 1 || !Testb(ToAscii(uq_bytes[uq_bpos]), c))
               break;
            uq_bpos += uq_w;
            uq_ii++;
            }
         if (uq_ii == start_i)
            fail;
         return C_integer uq_ii;
         }

      /*
       * Move i along s[i:j] until a character that is not in c is found
       *  or the end of the string is reached.
       */
      while (cnv_i < cnv_j) {
         if (!Testb(ToAscii(StrLoc(s)[cnv_i-1]), c))
            break;
         cnv_i++;
         }
      /*
       * Fail if no characters in c were found; otherwise
       *  return the position of the first character not in c.
       */
      if (cnv_i == start_i)
         fail;
      return C_integer cnv_i;
      }
end


"match(s1,s2,i1,i2) - produces i1+*s1 if s1==s2[i1+:*s1], but fails otherwise."

function{0,1} match(s1,s2,i,j)
   str_anal( s2, i, j )
   if !cnv:tmp_string(s1) then
      runerr(103,s1)
   body {
      char *str1, *str2;

      /*
       * Unicon: i/j mean codepoints, not bytes, for a tagged s2.
       * str_anal (above) already computed cnv_i/cnv_j using byte-based
       * StrLen(s2) -- discarded here in favor of recomputing from the
       * original i/j the same way many()/sect() do. The byte-level
       * comparison itself is unchanged and doesn't need to become
       * codepoint-aware: UTF-8 is self-synchronizing, so an exact byte
       * match beginning and ending at codepoint boundaries is already
       * a correct codepoint-level match. Only the bounds fed into the
       * comparison, and the position returned, need to mean codepoints.
       */
      if (IsUniQual(s2)) {
         word uq_ncps, uq_ii, uq_jj, uq_bstart, uq_bend, uq_s1cp;
         unsigned char *uq_bytes = (unsigned char *)StrLoc(s2);

         uq_scan(uq_bytes, StrLen(s2), &uq_ncps);

         if (is:null(i)) uq_ii = 1;
         else {
            C_integer uq_praw;
            if (!cnv_c_int(&i, &uq_praw)) fail;
            uq_ii = cvpos(uq_praw, uq_ncps);
            if (uq_ii == CvtFail) fail;
            }
         if (is:null(j)) uq_jj = uq_ncps + 1;
         else {
            C_integer uq_praw;
            if (!cnv_c_int(&j, &uq_praw)) fail;
            uq_jj = cvpos(uq_praw, uq_ncps);
            if (uq_jj == CvtFail) fail;
            }
         if (uq_ii > uq_jj) { word uq_t = uq_ii; uq_ii = uq_jj; uq_jj = uq_t; }

         uq_bstart = uq_seek_cp(uq_bytes, uq_ii - 1);
         uq_bend = uq_seek_cp(uq_bytes, uq_jj - 1);

         if (uq_bend - uq_bstart < StrLen(s1))
            fail;

         str1 = StrLoc(s1);
         str2 = (char *)(uq_bytes + uq_bstart);
         {
         word uq_k = StrLen(s1);
         while (uq_k-- > 0)
            if (*str1++ != *str2++)
               fail;
         }

         /* s1's own codepoint count is exactly how many codepoints of
            s2 the match consumed, since the bytes are identical */
         if (IsUniQual(s1)) {
            if (CpCount(s1) != CpCountSentinel)
               uq_s1cp = CpCount(s1);
            else
               uq_scan((unsigned char *)StrLoc(s1), StrLen(s1), &uq_s1cp);
            }
         else
            uq_s1cp = StrLen(s1);

         return C_integer uq_ii + uq_s1cp;
         }

      /*
       * Cannot match unless s2[i:j] is as long as s1.
       */
      if (cnv_j - cnv_i < StrLen(s1))
         fail;

      /*
       * Compare s1 with s2[i:j] for *s1 characters; fail if an
       *  inequality is found.
       */
      str1 = StrLoc(s1);
      str2 = StrLoc(s2) + cnv_i - 1;
      for (cnv_j = StrLen(s1); cnv_j > 0; cnv_j--)
         if (*str1++ != *str2++)
            fail;

      /*
       * Return position of end of matched string in s2.
       */
      return C_integer cnv_i + StrLen(s1);
      }
end


"upto(c,s,i1,i2) - generates the sequence of integer positions in s up to a "
"character in c in s[i2:i2], but fails if there is no such position."

function{*} upto(c,s,i,j)
   str_anal( s, i, j )
   if !cnv:tmp_cset(c) then
      runerr(104,c)
   body {
      C_integer tmp;
      CURTSTATVAR();

      /*
       * Look through s[i:j] and suspend position of each occurrence of
       * of a character in c.
       */
      while (cnv_i < cnv_j) {
         tmp = (C_integer)ToAscii(StrLoc(s)[cnv_i-1]);
         if (Testb(tmp, c)) {
            suspend C_integer cnv_i;
            }
         cnv_i++;
         }
      /*
       * Eventually fail.
       */
      fail;
      }
end
