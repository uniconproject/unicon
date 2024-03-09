/*
 * fconv.r -- abs, cset, integer, numeric, proc, real, string.
 */

"abs(N) - produces the absolute value of N."

function{1} abs(n)
   /*
    * If n is convertible to a (large or small) integer or real,
    * this code returns -n if n is negative
    */
   if cnv:(exact)C_integer(n) then {
      abstract {
         return integer
         }
      inline {
         C_integer i;
         int over_flow = 0;

         if (n >= 0)
            i = n;
         else {
            i = neg(n, &over_flow);
            if (over_flow) {
#ifdef LargeInts
               struct descrip tmp;
               MakeInt(n,&tmp);
               if (bigneg(&tmp, &result) == RunError)  /* alcbignum failed */
                  runerr(0);
               return result;
#else                                   /* LargeInts */
               irunerr(203,n);
               errorfail;
#endif                                  /* LargeInts */
               }
            }
         return C_integer i;
         }
      }


#ifdef LargeInts
   else if cnv:(exact)integer(n) then {
      abstract {
         return integer
         }
      inline {
         if (BlkD(n, Lrgint)->sign == 0)
            result = n;
         else {
            if (bigneg(&n, &result) == RunError)  /* alcbignum failed */
               runerr(0);
            }
         return result;
         }
      }
#endif                                  /* LargeInts */

   else if cnv:C_double(n) then {
      abstract {
         return real
         }
      inline {
         return C_double Abs(n);
         }
      }
   else
      runerr(102,n)
end


/*
 * The convertible types cset, integer, and real are identical
 *  enough to be expansions of a single macro, parameterized by type.
 */
#begdef ReturnYourselfAs(t)
#t "(x) - produces a value of type " #t " resulting from the conversion of x, "
   "but fails if the conversion is not possible."
function{0,1} t(x)

   if cnv:t(x) then {
      abstract {
         return t
         }
      inline {
         return x;
         }
      }
   else {
      abstract {
         return empty_type
         }
      inline {
         fail;
         }
      }
end

#enddef

ReturnYourselfAs(cset)     /* cset(x) - convert to cset or fail */
ReturnYourselfAs(integer)  /* integer(x) - convert to integer or fail */
ReturnYourselfAs(real)     /* real(x) - convert to real or fail */

"string(x) - produces a value of type string resulting from the conversion"
" of x, but fails if the conversion is not possible."
function{0,1} string(x[n])

   abstract {
      return string ++ empty_type
      }
   body {
      int i, j, len;
      char *tmp, *s, *s2;
      tended struct descrip t;
      if (n == 0)
         return emptystr;

      /*
       * convert x[0] to a string
       */
      if (!cnv:string(x[0], x[0]))
         fail;
      t = x[0];

      for (i = 1; i < n; i++) {
         /*
          * if t is not at the end of the string region, make it so
          */
         if (StrLoc(t) + StrLen(t) != strfree) {
            Protect(StrLoc(t) = alcstr(StrLoc(t), StrLen(t)), runerr(0));
            }
         if (!cnv:string(x[i], x[i])) fail;

         /*
          * concatenate t and x[i] and store result in t
          */
         if (StrLoc(t) + StrLen(t) == StrLoc(x[i])) {
            StrLen(t) += StrLen(x[i]);
            }
         else if ((StrLoc(t) + StrLen(t) == strfree) && (DiffPtrs(strend,strfree) > StrLen(x[i]))) {
            Protect(alcstr(StrLoc(x[i]), StrLen(x[i])), runerr(0));
            StrLen(t) += StrLen(x[i]);
            }
         else {
            Protect(tmp = alcstr(NULL, StrLen(t)+StrLen(x[i])), runerr(0));
            s = tmp;
            s2 = StrLoc(t);
            len = StrLen(t);
            for (j = 0; j < len; j++)
               *s++ = *s2++;
            s2 = StrLoc(x[i]);
            len = StrLen(x[i]);
            for (j = 0; j < len; j++)
               *s++ = *s2++;
            StrLoc(t) = tmp;
            StrLen(t) += len;
            }
         }
      return t;
      }
end



"numeric(x) - produces an integer or real number resulting from the "
"type conversion of x, but fails if the conversion is not possible."

function{0,1} numeric(n)

   if cnv:(exact)integer(n) then {
      abstract {
         return integer
         }
      inline {
         return n;
         }
      }
   else if cnv:real(n) then {
      abstract {
         return real
         }
      inline {
         return n;
         }
      }
   else {
      abstract {
         return empty_type
         }
      inline {
         fail;
         }
      }
end


"proc(x,i) - convert x to a procedure if possible; use i to resolve "
"ambiguous string names."

#ifdef MultiProgram
function{0,1} proc(x,i,c)
#else                                   /* MultiProgram */
function{0,1} proc(x,i)
#endif                                  /* MultiProgram */

#ifdef MultiProgram
   if is:coexpr(x) then {
      if !def:C_integer(i, 1) then
         runerr(101, i)
      abstract {
         return proc
         }
      body {
         struct b_coexpr *ce = NULL;
         struct b_proc *bp = NULL;
         struct pf_marker *fp;
         dptr dp=NULL;
         CURTSTATE_AND_CE();
         if (BlkLoc(x) != BlkLoc(k_current)) {
            ce = (struct b_coexpr *)BlkLoc(x);
            dp = ce->es_argp;
            fp = ce->es_pfp;
            if (dp == NULL) fail;
            }
         else {
            fp = pfp;
            dp = glbl_argp;
            }
         /* follow upwards, i levels */
         while (i--) {
            if (fp == NULL) fail;
#if COMPILER
            dp = fp->old_argp;
            fp = fp->old_pfp;
#else                                   /* COMPILER */
            dp = fp->pf_argp;
            fp = fp->pf_pfp;
#endif                                  /* COMPILER */
            }
         if (fp == NULL) fail;
         if (dp)
            bp = (struct b_proc *)BlkLoc(*(dp));
         else fail;
         return proc(bp);
         }
      }
#endif                                  /* MultiProgram */

   if is:proc(x) then {
      abstract {
         return proc
         }
      inline {

#ifdef MultiProgram
         if (!is:null(c)) {
            struct progstate *p;
            if (!is:coexpr(c)) runerr(118,c);
            /*
             * Test to see whether a given procedure belongs to a given
             * program.  Currently this is a sleazy pointer arithmetic check.
             */
            p = BlkD(c,Coexpr)->program;
            if (! InRange(p, BlkD(x,Proc)->entryp.icode, (char *)p + p->hsize))
               fail;
            }
#endif                                  /* MultiProgram */
         return x;
         }
      }

   else if cnv:tmp_string(x) then {
      /*
       * i must be 0, 1, 2, or 3; it defaults to 1.
       */
      if !def:C_integer(i, 1) then
         runerr(101, i)
      inline {
         if (i < 0 || i > 3) {
            irunerr(205, i);
            errorfail;
            }
         }

      abstract {
         return proc
         }
      inline {
         struct b_proc *prc;

#ifdef MultiProgram
         struct progstate *prog, *savedprog;

         savedprog = curpstate;
         if (is:null(c)) {
            prog = curpstate;
            }
         else if (is:coexpr(c)) {
            prog = BlkD(c,Coexpr)->program;
            }
         else {
            runerr(118,c);
            }

         ENTERPSTATE(prog);
#endif                                          /* MultiProgram */

         /*
          * Attempt to convert Arg0 to a procedure descriptor using i to
          *  discriminate between procedures with the same names.  If i
          *  is zero, only check builtins and ignore user procedures.
          *  Fail if the conversion isn't successful.
          */
         if (i == 0)
            prc = bi_strprc(&x, 0);
         else
         prc = strprc(&x, i);

#ifdef MultiProgram
         ENTERPSTATE(savedprog);
#endif                                          /* MultiProgram */
         if (prc == NULL)
            fail;
         else
            return proc(prc);
         }
      }
   else {
      abstract {
         return empty_type
         }
      inline {
         fail;
         }
      }
end
