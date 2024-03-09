/*
 * File: fstr.r
 *  Contents: center, detab, entab, left, map, repl, reverse, right, trim
 */


/*
 * macro used by center, left, right
 */
#begdef FstrSetup
   /*
    * s1 must be a string.  n must be a non-negative integer and defaults
    *  to 1.  s2 must be a string and defaults to a blank.
    */
   if !cnv:string(s1) then
      runerr(103,s1)
   if !def:C_integer(n,1) then
      runerr(101, n)
   if !def:tmp_string(s2,blank) then
      runerr(103, s2)

   abstract {
      return string
      }
   body {
      register char *s, *st;
      word slen;
      char *sbuf, *s3;

      if (n < 0) {
         irunerr(205,n);
         errorfail;
         }
      /*
       * The padding string is null; make it a blank.
       */
      if (StrLen(s2) == 0)
         s2 = blank;
   /* } must be supplied */
#enddef


"center(s1,i,s2) - pad s1 on left and right with s2 to length i."

function{1} center(s1,n,s2)
   FstrSetup /* includes body { */
      {
      word hcnt;

      /*
       * If we are extracting the center of a large string (not padding),
       * just construct a descriptor.
       */
      if (n <= StrLen(s1)) {
         return string(n, StrLoc(s1) + ((StrLen(s1)-n+1)>>1));
         }

      /*
       * Get space for the new string.  Start at the right
       *  of the new string and copy s2 into it from right to left as
       *  many times as will fit in the right half of the new string.
       */
      Protect(sbuf = alcstr(NULL, n), runerr(0));

      slen = StrLen(s2);
      s3 = StrLoc(s2);
      hcnt = n / 2;
      s = sbuf + n;
      while (s > sbuf + hcnt) {
         st = s3 + slen;
         while (st > s3 && s > sbuf + hcnt)
            *--s = *--st;
         }

      /*
       * Start at the left end of the new string and copy s1 into it from
       *  left to right as many time as will fit in the left half of the
       *  new string.
       */
      s = sbuf;
      while (s < sbuf + hcnt) {
         st = s3;
         while (st < s3 + slen && s < sbuf + hcnt)
            *s++ = *st++;
         }

      slen = StrLen(s1);
      if (n < slen) {
         /*
          * s1 is larger than the field to center it in.  The source for the
          *  copy starts at the appropriate point in s1 and the destination
          *  starts at the left end of of the new string.
          */
         s = sbuf;
         st = StrLoc(s1) + slen/2 - hcnt + (~n&slen&1);
         }
      else {
         /*
          * s1 is smaller than the field to center it in.  The source for the
          *  copy starts at the left end of s1 and the destination starts at
          *  the appropriate point in the new string.
          */
         s = sbuf + hcnt - slen/2 - (~n&slen&1);
         st = StrLoc(s1);
         }
      /*
       * Perform the copy, moving min(*s1,n) bytes from st to s.
       */
      if (slen > n)
         slen = n;
      while (slen-- > 0)
         *s++ = *st++;

      /*
       * Return the new string.
       */
      return string(n, sbuf);
      } }
end


"detab(s,i,...) - replace tabs with spaces, with stops at columns indicated."

function{1} detab(s,i[n])

   if !cnv:string(s) then
      runerr(103,s)

   abstract {
      return string
      }

   body {
      tended char *in, *out, *iend;
      C_integer last, interval, col, target, expand, j;
      dptr tablst;
      dptr endlst;
      int is_expanded = 0;
      char c;

      /*
       * Make sure all allocations for result will go in one region
       */
      reserve(Strings, StrLen(s) * 8);

      for (j=0; j<n; j++) {
         if (!cnv:integer(i[j],i[j]))
            runerr(101,i[j]);
         if ((j>0) && IntVal(i[j])<=IntVal(i[j-1]))
            runerr(210, i[j]);

         }
      /*
       * Start out assuming the result will be the same size as the argument.
       */
      Protect(StrLoc(result) = alcstr(NULL, StrLen(s)), runerr(0));
      StrLen(result) = StrLen(s);

      /*
       * Copy the string, expanding tabs.
       */
      last = 1;
      if (n == 0)
         interval = 8;
      else {
         if (!cnv:integer(i[0], i[0]))
            runerr(101, i[0]);

         if (IntVal(i[0]) <= last)
            runerr(210, i[0]);
          }
      tablst = i;
      endlst = &i[n];
      col = 1;
      iend = StrLoc(s) + StrLen(s);
      for (in = StrLoc(s), out = StrLoc(result); in < iend; )
         switch (c = *out++ = *in++) {
            case '\b':
               col--;
               tablst = i;  /* reset the list of remaining tab stops */
               last = 1;
               break;
            case LineFeed:
            case CarriageReturn:
               col = 1;
               tablst = i;  /* reset the list of remaining tab stops */
               last = 1;
               break;
            case '\t':
               is_expanded = 1;
               out--;
               target = col;
               nxttab(&target, &tablst, endlst, &last, &interval);
               expand = target - col - 1;
               if (expand > 0) {
                  Protect(alcstr(NULL, expand), runerr(0));
                  StrLen(result) += expand;
                  }
               while (col < target) {
                  *out++ = ' ';
                  col++;
                  }
               break;
            default:
               if (isprint(c))
                  col++;
            }

      /*
       * Return new string if indeed there were tabs; otherwise return original
       *  string to conserve memory.
       */
      if (is_expanded)
         return result;
      else {
         long n = DiffPtrs(StrLoc(result),strfree); /* note deallocation */
         EVStrAlc(n);
         strtotal += n;
         strfree = StrLoc(result);              /* reset the free pointer */
         return s;                              /* return original string */
         }
      }
end



"entab(s,i,...) - replace spaces with tabs, with stops at columns indicated."

function{1} entab(s,i[n])
   if !cnv:string(s) then
      runerr(103,s)

   abstract {
      return string
      }

   body {
      C_integer last, interval, col, target, nt, nt1, j;
      dptr tablst;
      dptr endlst;
      char *in, *out, *iend;
      char c;
      int inserted = 0;
      CURTSTATE();

      for (j=0; j<n; j++) {
         if (!cnv:integer(i[j],i[j]))
            runerr(101,i[j]);

         if ((j>0) && IntVal(i[j])<=IntVal(i[j-1]))
            runerr(210, i[j]);
         }

      /*
       * Get memory for result at end of string space.  We may give some back
       *  if not all needed, or all of it if no tabs can be inserted.
       */
      Protect(StrLoc(result) = alcstr(NULL, StrLen(s)), runerr(0));
      StrLen(result) = StrLen(s);

      /*
       * Copy the string, looking for runs of spaces.
       */
      last = 1;
      if (n == 0)
         interval = 8;
      else {
         if (!cnv:integer(i[0], i[0]))
            runerr(101, i[0]);
         if (IntVal(i[0]) <= last)
            runerr(210, i[0]);
         }
      tablst = i;
      endlst = &i[n];
      col = 1;
      target = 0;
      iend = StrLoc(s) + StrLen(s);

      for (in = StrLoc(s), out = StrLoc(result); in < iend; )
         switch (c = *out++ = *in++) {
         case '\b':
            col--;
            tablst = i;  /* reset the list of remaining tab stops */
            last = 1;
            break;
         case LineFeed:
         case CarriageReturn:
            col = 1;
            tablst = i;  /* reset the list of remaining tab stops */
            last = 1;
            break;
         case '\t':
            nxttab(&col, &tablst, endlst, &last, &interval);
            break;
         case ' ':
            target = col + 1;
            while (in < iend && *in == ' ')
               target++, in++;
            if (target - col > 1) { /* never tab just 1; already copied space */
               nt = col;
               nxttab(&nt, &tablst, endlst, &last, &interval);
               if (nt == col+1) {
                  nt1 = nt;
                  nxttab(&nt1, &tablst, endlst, &last, &interval);
                  if (nt1 > target) {
                     col++;     /* keep space to avoid 1-col tab then spaces */
                     nt = nt1;
                     }
                  else
                     out--;     /* back up to begin tabbing */
                  }
               else
                  out--;        /* back up to begin tabbing */
               while (nt <= target)  {
                  inserted = 1;
                  *out++ = '\t';        /* put tabs to tab positions */
                  col = nt;
                  nxttab(&nt, &tablst, endlst, &last, &interval);
                  }
               while (col++ < target)
                  *out++ = ' ';         /* complete gap with spaces */
               }
            col = target;
            break;
         default:
            if (isprint(c))
               col++;
         }

      /*
       * Return new string if indeed tabs were inserted; otherwise return
       *  original string (and reset strfree) to conserve memory.
       */
      if (inserted) {
         long n;
         StrLen(result) = DiffPtrs(out,StrLoc(result));
         n = DiffPtrs(out,strfree);             /* note the deallocation */
         EVStrAlc(n);
         strtotal += n;
         strfree = out;                         /* give back unused space */
         return result;                         /* return new string */
         }
      else {
         long n = DiffPtrs(StrLoc(result),strfree); /* note the deallocation */
         EVStrAlc(n);
         strtotal += n;
         strfree = StrLoc(result);              /* reset free pointer */
         return s;                              /* return original string */
         }
      }
end

/*
 * nxttab -- helper routine for entab and detab, returns next tab
 *   beyond col
 */

void nxttab(col, tablst, endlst, last, interval)
C_integer *col;
dptr *tablst;
dptr endlst;
C_integer *last;
C_integer *interval;
   {
   /*
    * Look for the right tab stop.
    */
   while (*tablst < endlst && *col >= IntVal((*tablst)[0])) {
      ++*tablst;
      if (*tablst == endlst)
         *interval = IntVal((*tablst)[-1]) - *last;
      else {
         *last = IntVal((*tablst)[-1]);
         }
      }
   if (*tablst >= endlst)
      *col = *col + *interval - (*col - *last) % *interval;
   else
      *col = IntVal((*tablst)[0]);
   }


"left(s1,i,s2) - pad s1 on right with s2 to length i."

function{1} left(s1,n,s2)
   FstrSetup  /* includes body { */

      /*
       * If we are extracting the left part of a large string (not padding),
       * just construct a descriptor.
       */
      if (n <= StrLen(s1)) {
         return string(n, StrLoc(s1));
         }

      /*
       * Get n bytes of string space.  Start at the right end of the new
       *  string and copy s2 into the new string as many times as it fits.
       *  Note that s2 is copied from right to left.
       */
      Protect(sbuf = alcstr(NULL, n), runerr(0));

      slen = StrLen(s2);
      s3 = StrLoc(s2);
      s = sbuf + n;
      while (s > sbuf) {
         st = s3 + slen;
         while (st > s3 && s > sbuf)
            *--s = *--st;
         }

      /*
       * Copy up to n bytes of s1 into the new string, starting at the left end
       */
      s = sbuf;
      slen = StrLen(s1);
      st = StrLoc(s1);
      if (slen > n)
         slen = n;
      while (slen-- > 0)
         *s++ = *st++;

      /*
       * Return the new string.
       */
      return string(n, sbuf);
      }
end


/*
 * What we know about map:
 * In an IPL scan 4/18/2010, of around 350 lexical occurrences of map(),
 * approximately 200 used default s2/s3. Of the remainder, roughly 21-25
 * use &lcase and &ucase explicitly.  A significant percentage of the
 * calls identifiably use a first argument of length 1, e.g. map(move(1)).
 */

"map(s1,s2,s3) - map s1, using s2 and s3."

function{1} map(s1,s2,s3)
   /*
    * s1 must be a string; s2 and s3 default to (string conversions of)
    *  &ucase and &lcase, respectively.
    */
   if !cnv:string(s1) then
      runerr(103,s1)
#if COMPILER
   if !def:string(s2, ucase) then
      runerr(103,s2)
   if !def:string(s3, lcase) then
      runerr(103,s3)
#endif                                          /* COMPILER */

   abstract {
      return string
      }
   body {
      register int i;
      register word slen;
      register char *str1, *str2, *str3;
#ifndef Concurrent
      static char maptab[256];
#endif                                  /* Concurrent */
      CURTSTATE();

#if !COMPILER
      /*
       * Defaulting is here, conversion only if cached maptab fails
       */
      if (is:null(s2))
         s2 = ucase;
      /*
       * Short-cut conversions of &lcase and &ucase.
       */
      else {
         struct descrip _k_lcase_, _k_ucase_;
         Klcase(&_k_lcase_);
         Kucase(&_k_ucase_);
         if (s2.dword == D_Cset) {
            if (BlkLoc(s2) == BlkLoc(_k_lcase_)) {
               s2 = lcase;
               }
            else if (BlkLoc(s2) == BlkLoc(_k_ucase_)) {
               s2 = ucase;
               }
            }
         }

      if (is:null(s3))
         s3 = lcase;
      /*
       * Short-cut conversions of &lcase and &ucase.
       */
      else {
         struct descrip _k_lcase_, _k_ucase_;
         Klcase(&_k_lcase_);
         Kucase(&_k_ucase_);
         if (s3.dword == D_Cset) {
            if (BlkLoc(s3) == BlkLoc(_k_lcase_)) {
               s3 = lcase;
               }
            else if (BlkLoc(s3) == BlkLoc(_k_ucase_)) {
               s3 = ucase;
               }
            }
         }
#endif                                  /* !COMPILER */

      /*
       * If s2 and s3 are the same as for the last call of map,
       *  the current values in maptab can be used. Otherwise, the
       *  mapping information must be recomputed.
       */
      if (!EqlDesc(maps2,s2) || !EqlDesc(maps3,s3)) {
         maps2 = s2;
         maps3 = s3;

#if !COMPILER
         if (!cnv:string(s2,s2))
            runerr(103,s2);
         if (!cnv:string(s3,s3))
            runerr(103,s3);
#endif                                  /* !COMPILER */
         /*
          * s2 and s3 must be of the same length
          */
         if (StrLen(s2) != StrLen(s3))
            runerr(208);

         /*
          * The array maptab is used to perform the mapping.  First,
          *  maptab[i] is initialized with i for i from 0 to 255.
          *  Then, for each character in s2, the position in maptab
          *  corresponding to the value of the character is assigned
          *  the value of the character in s3 that is in the same
          *  position as the character from s2.
          */
         str2 = StrLoc(s2);
         str3 = StrLoc(s3);
         for (i = 0; i <= 255; i++)
            maptab[i] = i;
         for (slen = 0; slen < StrLen(s2); slen++)
            maptab[str2[slen]&0377] = str3[slen];
         }

      slen = StrLen(s1);

      if (slen == 0) {
         return emptystr;
         }
      else if (slen == 1) {
         char c = maptab[*(StrLoc(s1)) & 0xFF];
         return string(1, (char *)&allchars[FromAscii(c) & 0xFF]);
         }

      /*
       * The result is a string the size of s1; create the result
       *  string, but specify no value for it.
       */
      StrLen(result) = slen;
      Protect(StrLoc(result) = alcstr(NULL, slen), runerr(0));
      str1 = StrLoc(s1);
      str2 = StrLoc(result);

      /*
       * Run through the string, using values in maptab to do the
       *  mapping.
       */
      while (slen-- > 0)
         *str2++ = maptab[(*str1++)&0377];

      return result;
      }
end


"repl(s,i) - concatenate i copies of string s."

function{1} repl(s,n)

   if !cnv:C_integer(n) then
      runerr(101,n)
   inline {
      if (n < 0) { irunerr(205,n); errorfail; }
      }

   if is:list(s) then {
      abstract { return type(s) }
      body {
         register struct b_list *bp1;
         register struct b_lelem *lp1;
         word i, size1, size2;
         size1 = BlkD(s,List)->size;
         size2 = size1 * n;
         Protect(bp1 = (struct b_list *)alclist_raw(size2, size2), runerr(0));
         lp1 = (struct b_lelem *) (bp1->listhead);

         for(i=0; i<n; i++) {
            cpslots(&s, lp1->lslots + i*size1, (word)1, size1+1);
            }
         BlkLoc(s) = (union block *)bp1;
         return s;
         }
      }

   else if cnv:string(s) then {

   abstract {
       return string
       }

   body {
      register C_integer cnt;
      register C_integer slen;
      register C_integer size;
      register char * resloc, * sloc, *floc;

      slen = StrLen(s);
      /*
       * Return an empty string if n is 0 or if s is the empty string.
       */
      if ((n == 0) || (slen==0))
         return emptystr;

      /*
       * Make sure the resulting string will not be too long.
       */
      size = n * slen;
      if (size > MaxStrLen) {
         irunerr(306,n);
         errorfail;
         }

      /*
       * Make result a descriptor for the replicated string.
       */
      Protect(resloc = alcstr(NULL, size), runerr(0));

      StrLoc(result) = resloc;
      StrLen(result) = size;

      /*
       * Fill the allocated area with copies of s.
       */
      sloc = StrLoc(s);
      if (slen == 1)
         memset(resloc, *sloc, size);
      else {
         while (--n >= 0) {
            floc = sloc;
            cnt = slen;
            while (--cnt >= 0)
               *resloc++ = *floc++;
            }
         }

      return result;
      }
}
else runerr(103,s)
end


"reverse(s) - reverse string s."

function{1} reverse(x)

   if is:list(x) then {
      abstract {
         return type(x)
         }
      body {
         int i=0, size = BlkD(x,List)->size;
         struct descrip temp;
         dptr dp;
         cplist(&x, &result, 1, size+1);
         dp = Blk(BlkD(result,List)->listhead,Lelem)->lslots;
         while (i<size-1) {
            temp = dp[i]; dp[i] = dp[size-1]; dp[size-1] = temp;
            i++; size--;
            }
         return result;
         }
      }
   else {

   if !cnv:string(x) then
      runerr(103,x)

   abstract {
      return string
      }
   body {
      register char c, *floc, *lloc;
      register word slen;

      /*
       * Allocate a copy of x.
       */
      slen = StrLen(x);
      Protect(StrLoc(result) = alcstr(StrLoc(x), slen), runerr(0));
      StrLen(result) = slen;

      /*
       * Point floc at the start of s and lloc at the end of s.  Work floc
       *  and sloc along s in opposite directions, swapping the characters
       *  at floc and lloc.
       */
      floc = StrLoc(result);
      lloc = floc + --slen;
      while (floc < lloc) {
         c = *floc;
         *floc++ = *lloc;
         *lloc-- = c;
         }
      return result;
      }
}
end


"right(s1,i,s2) - pad s1 on left with s2 to length i."

function{1} right(s1,n,s2)
   FstrSetup  /* includes body { */
      /*
       * If we are extracting the right part of a large string (not padding),
       * just construct a descriptor.
       */
      if (n <= StrLen(s1)) {
         return string(n, StrLoc(s1) + StrLen(s1) - n);
         }

      /*
       * Get n bytes of string space.  Start at the left end of the new
       *  string and copy s2 into the new string as many times as it fits.
       */
      Protect(sbuf = alcstr(NULL, n), runerr(0));

      slen = StrLen(s2);
      s3 = StrLoc(s2);
      s = sbuf;
      while (s < sbuf + n) {
         st = s3;
         while (st < s3 + slen && s < sbuf + n)
            *s++ = *st++;
         }

      /*
       * Copy s1 into the new string, starting at the right end and copying
       * s2 from right to left.  If *s1 > n, only copy n bytes.
       */
      s = sbuf + n;
      slen = StrLen(s1);
      st = StrLoc(s1) + slen;
      if (slen > n)
         slen = n;
      while (slen-- > 0)
         *--s = *--st;

      /*
       * Return the new string.
       */
      return string(n, sbuf);
      }
end


"trim(s,c) - trim trailing characters in c from s."

function{1} trim(s,c,ends)

   if !cnv:string(s) then
      runerr(103, s)
   /*
    * c defaults to a cset containing a blank.
    */
   if !def:tmp_cset(c,blankcs) then
      runerr(104, c)

   if !def:C_integer(ends,-1) then
      runerr(101, ends)

   abstract {
      return string
      }

   body {
      char *sloc;
      C_integer slen;

      slen = StrLen(s);
      /*
       * Left trimming: Start at the beginning of s and then advance StrLoc(s)
       * and decrease the slen until a character that is not in c is found.
       */
      if (ends > -1) {
         sloc = StrLoc(s);
         while (slen > 0 && Testb(ToAscii(*sloc), c)) {
            sloc++;
            slen--;
            }
         StrLoc(s) = sloc;
         }
      /*
       * Regular (right) trimming: Start at the end of s and then back up
       * until a character that is not in c is found.
       */
      if (ends < 1) {
         sloc = StrLoc(s) + slen - 1;
         while (sloc >= StrLoc(s) && Testb(ToAscii(*sloc), c)) {
            sloc--;
            slen--;
            }
         }
      /*
       *  Do the actual trimming by creating a descriptor that
       *  points at a substring of s, but with the length reduced.
       */
      return string(slen, StrLoc(s));
      }
end
