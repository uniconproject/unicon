/*
 * cnv.r -- Conversion routines:
 *
 * cnv_c_dbl, cnv_c_int, cnv_c_str, cnv_cset, cnv_ec_int,
 * cnv_eint, cnv_int, cnv_real, cnv_str, cnv_tcset, cnv_tstr, deref,
 * getdbl, strprc, bi_strprc
 *
 * Service routines: itos, ston, radix, cvpos
 *
 * Philosophy: certain redundancy is present which could be avoided,
 * and nested conversion calls are avoided due to the importance of
 * minimizing these routines' costs.
 *
 * Assumed: the C compiler must handle assignments of C integers to
 * C double variables and vice-versa.  Hopefully production C compilers
 * have managed to eliminate bugs related to these assignments.
 */

/*
 * Prototypes for static functions.
 */
static void cstos (unsigned int *cs, dptr dp, char *s);
static void itos (C_integer num, dptr dp, char *s);
static int ston (dptr sptr, union numeric *result);
static int tmp_str (char *sbuf, dptr s, dptr d);

/*
 * cnv_c_dbl - cnv:C_double(*s, *d), convert a value directly into a C double
 */
int cnv_c_dbl(dptr s, double *d)
   {

   /*
    * The classic design goal for cnv.r was to avoid tending (and heap
    * allocation for that matter) as much as possible, hence versions of
    * several functions labeled "tmp". Nevertheless, there was a bunch of
    * tending in this file that costs Unicon more than it costs Icon.
    *
    * cnvstr appears in many functions and has always been tended. It is only
    * used for a cset that has been converted to a (temporary) string, and in
    * that case, the cset's string has been allocated in a local character
    * array, sbuf, so it will not move during garbage collection, and
    * therefore need not be tended.
    *
    * In this function, there is also a variable result that was tended, but
    * it only has to survive a call to bigtoreal(), which does not allocate a
    * block and therefore does not need to be tended.
    */

   struct descrip result;
   struct descrip cnvstr;
   char sbuf[MaxCvtLen];

   union numeric numrc;

   type_case *s of {
      real: {
         GetReal(s, *d);
         return 1;
         }
      integer: {

#ifdef LargeInts
         if (Type(*s) == T_Lrgint)
            return bigtoreal(s, d);
         else
#endif                                  /* LargeInts */

            *d = IntVal(*s);

         return 1;
         }
      string: {
         /* fall through (to the statement after the type_case).  */
         }
      cset: {
        tmp_str(sbuf, s, &cnvstr);
        s = &cnvstr;
        }
      default: {
        return 0;
        }
      }

   /*
    * s is now a string.
    */
   switch( ston(s, &numrc) ) {
      case T_Integer:
         *d = numrc.integer;
         return 1;

#ifdef LargeInts
      case T_Lrgint:
         result.dword = D_Lrgint;
         BlkLoc(result) = (union block *)numrc.big;
         return bigtoreal(&result, d);
#endif                                  /* LargeInts */

      case T_Real:
         *d = numrc.real;
         return 1;
      default:
         return 0;
      }
  }

/*
 * cnv_c_int - cnv:C_integer(*s, *d), convert a value directly into a C_integer
 */
int cnv_c_int(s, d)
dptr s;
C_integer *d;
   {
   struct descrip cnvstr;       /* not tended, see comment at cnv_c_dbl */
   union numeric numrc;
   char sbuf[MaxCvtLen];

   type_case *s of {
      integer: {

#ifdef LargeInts
         if (Type(*s) == T_Lrgint) {
            return 0;
            }
#endif                                  /* LargeInts */

         *d = IntVal(*s);
         return 1;
         }
      real: {
         double dbl;
         GetReal(s,dbl);
         if (dbl > MaxLong || dbl < MinLong) {
            return 0;
            }
         *d = dbl;
         return 1;
         }
      string: {
         /* fall through (to the statement after the type_case).  */
         }
      cset: {
        tmp_str(sbuf, s, &cnvstr);
        s = &cnvstr;
        }
      default: {
         return 0;
         }
      }

   /*
    * s is now a string.
    */
   switch( ston(s, &numrc) ) {
      case T_Integer: {
         *d = numrc.integer;
         return 1;
         }
      case T_Real: {
         double dbl = numrc.real;
         if (dbl > MaxLong || dbl < MinLong) {
            return 0;
            }
         *d = dbl;
         return 1;
         }
      default:
         return 0;
      }
   }

/*
 * cnv_c_str - cnv:C_string(*s, *d), convert a value into a C (and Icon) string
 */
int cnv_c_str(s, d)
dptr s;
dptr d;
   {
   CURTSTATE();
   /*
    * Get the string to the end of the string region and append a '\0'.
    */

   if (!is:string(*s)) {
      if (!cnv_str(s, d)) {
         return 0;
         }
      }
   else {
      *d = *s;
      }

   /*
    * See if the end of d is already at the end of the string region
    * and there is room for one more byte.
    */
   if ((StrLoc(*d) + StrLen(*d) == strfree) && (strfree != strend)) {
      Protect(alcstr("\0", 1), fatalerr(0,NULL));
      ++StrLen(*d);
      }
   else {
      register word slen = StrLen(*d);
      register char *sptr, *dp;
      Protect(dp = alcstr(NULL,slen+1), fatalerr(0,NULL));
      StrLen(*d) = StrLen(*d)+1;
      sptr = StrLoc(*d);
      StrLoc(*d) = dp;
      while (slen-- > 0)
         *dp++ = *sptr++;
      *dp = '\0';
      }

   return 1;
   }

#begdef cnv_cset_macro(f,e_aconv,e_tconv,e_nconv,e_sconv,e_fconv)
/*
 * cnv_cset - cnv:cset(*s, *d), convert to a cset
 */
int f(dptr s, dptr d)
   {
   tended struct descrip str;
   char sbuf[MaxCvtLen];
   register C_integer l;
   register char *s1;        /* does not need to be tended */

   EVValD(s, e_aconv);
   EVValD(&csetdesc, e_tconv);

   if (is:cset(*s)) {
      *d = *s;
      EVValD(s, e_nconv);
      return 1;
      }
   /*
    * convert to a string and then add its contents to the cset
    */
   if (tmp_str(sbuf, s, &str)) {
      Protect(BlkLoc(*d) = (union block *)alccset(), fatalerr(0,NULL));
      d->dword = D_Cset;
      s1 = StrLoc(str);
      l = StrLen(str);
      while(l--) {
         Setb(*s1, *d);
         s1++;
         }
      EVValD(d, e_sconv);
      return 1;
      }
   else {
      EVValD(s, e_fconv);
      return 0;
      }
  }
#enddef

#ifdef MultiProgram
cnv_cset_macro(cnv_cset_0,0,0,0,0,0)
cnv_cset_macro(cnv_cset_1,E_Aconv,E_Tconv,E_Nconv,E_Sconv,E_Fconv)
#else                                   /* MultiProgram */
cnv_cset_macro(cnv_cset,0,0,0,0,0)
#endif                                  /* MultiProgram */

/*
 * cnv_ec_int - cnv:(exact)C_integer(*s, *d), convert to an exact C integer
 */
int cnv_ec_int(s, d)
dptr s;
C_integer *d;
   {
   struct descrip cnvstr;       /* not tended, see comment at cnv_c_dbl */
   union numeric numrc;
   char sbuf[MaxCvtLen];

   type_case *s of {
      integer: {

#ifdef LargeInts
         if (Type(*s) == T_Lrgint) {
            return 0;
            }
#endif                                  /* LargeInts */
         *d = IntVal(*s);
         return 1;
         }
      string: {
         /* fall through (to the statement after the type_case).  */
         }
      cset: {
        tmp_str(sbuf, s, &cnvstr);
        s = &cnvstr;
        }
      default: {
         return 0;
         }
      }

   /*
    * s is now a string.
    */
   if (ston(s, &numrc) == T_Integer) {
      *d = numrc.integer;
      return 1;
      }
   else {
      return 0;
      }
   }

/*
 * cnv_eint - cnv:(exact)integer(*s, *d), convert to an exact integer
 */
int cnv_eint(s, d)
dptr s, d;
   {
   struct descrip cnvstr;       /* not tended, see comment at cnv_c_dbl */
   char sbuf[MaxCvtLen];
   union numeric numrc;

   type_case *s of {
      integer: {
         *d = *s;
         return 1;
         }
      string: {
         /* fall through (to the statement after the type_case).  */
         }
      cset: {
        tmp_str(sbuf, s, &cnvstr);
        s = &cnvstr;
        }
      default: {
        return 0;
        }
      }

   /*
    * s is now a string.
    */
   switch (ston(s, &numrc)) {
      case T_Integer:
         MakeInt(numrc.integer, d);
         return 1;

#ifdef LargeInts
      case T_Lrgint:
         d->dword = D_Lrgint;
         BlkLoc(*d) = (union block *)numrc.big;
         return 1;
#endif                          /* LargeInts */

      default:
         return 0;
      }
   }

#begdef cnv_int_macro(f,e_aconv,e_tconv,e_nconv,e_fconv,e_sconv)
/*
 * cnv_int - cnv:integer(*s, *d), convert to integer
 */
int f(s, d)
dptr s, d;
   {
   struct descrip cnvstr;       /* not tended, see comment at cnv_c_dbl */
   char sbuf[MaxCvtLen];
   union numeric numrc;

   EVValD(s, e_aconv);
   EVValD(&zerodesc, e_tconv);

   type_case *s of {
      integer: {
         *d = *s;
         EVValD(s, e_nconv);
         return 1;
         }
      real: {
         double dbl;
         GetReal(s,dbl);
         if (dbl > MaxLong || dbl < MinLong) {

#ifdef LargeInts
            if (realtobig(s, d) == Succeeded) {
               EVValD(d, e_sconv);
               return 1;
               }
            else {
               EVValD(s, e_fconv);
               return 0;
               }
#else                                   /* LargeInts */
            EVValD(s, e_fconv);
            return 0;
#endif                                  /* LargeInts */
            }
         MakeInt((word)dbl,d);
         EVValD(d, e_sconv);
         return 1;
         }
      string: {
         /* fall through (to the statement after the type_case).  */
         }
      cset: {
        tmp_str(sbuf, s, &cnvstr);
        s = &cnvstr;
        }
      default: {
         EVValD(s, e_fconv);
         return 0;
         }
      }

   /*
    * s is now a string.
    */
   switch( ston(s, &numrc) ) {

#ifdef LargeInts
      case T_Lrgint:
         d->dword = D_Lrgint;
         BlkLoc(*d) = (union block *)numrc.big;
         EVValD(d, e_sconv);
         return 1;
#endif                                  /* LargeInts */

      case T_Integer:
         MakeInt(numrc.integer,d);
         EVValD(d, e_sconv);
         return 1;
      case T_Real: {
         double dbl = numrc.real;
         if (dbl > MaxLong || dbl < MinLong) {

#ifdef LargeInts
#ifdef DescriptorDouble
            s->vword.realval = dbl;
#else
            BlkLoc(*s) = (union block *)alcreal(dbl);
#endif
            s->dword = D_Real;
            if (realtobig(s, d) == Succeeded) {
               EVValD(d, e_sconv);
               return 1;
               }
            else {
               EVValD(s, e_fconv);
               return 0;
               }
#else                                   /* LargeInts */
            EVValD(s, e_fconv);
            return 0;
#endif                                  /* LargeInts */
            }
         MakeInt((word)dbl,d);
         EVValD(d, e_sconv);
         return 1;
         }
      default:
         EVValD(s, e_fconv);
         return 0;
      }
   }
#enddef

#ifdef MultiProgram
#passthru #undef cnv_int
cnv_int_macro(cnv_int,0,0,0,0,0)
cnv_int_macro(cnv_int_1,E_Aconv,E_Tconv,E_Nconv,E_Fconv,E_Sconv)
#else                                   /* MultiProgram */
cnv_int_macro(cnv_int,0,0,0,0,0)
#endif                                  /* MultiProgram */

#begdef cnv_real_macro(f,e_aconv,e_tconv,e_sconv,e_fconv)
/*
 * cnv_real - cnv:real(*s, *d), convert to real
 */
int f(dptr s, dptr d)
   {
   double dbl;

   EVValD(s, e_aconv);
   EVValD(&rzerodesc, e_tconv);

   if (cnv_c_dbl(s, &dbl)) {
#ifdef DescriptorDouble
      d->vword.realval = dbl;
#else                                   /* DescriptorDouble */
      Protect(BlkLoc(*d) = (union block *)alcreal(dbl), fatalerr(0,NULL));
#endif                                  /* DescriptorDouble */
      d->dword = D_Real;
      EVValD(d, e_sconv);
      return 1;
      }
   else
      EVValD(s, e_fconv);
      return 0;
   }
#enddef

#ifdef MultiProgram
#passthru #undef cnv_real
cnv_real_macro(cnv_real,0,0,0,0)
cnv_real_macro(cnv_real_1,E_Aconv,E_Tconv,E_Sconv,E_Fconv)
#else                                   /* MultiProgram */
cnv_real_macro(cnv_real,0,0,0,0)
#endif                                  /* MultiProgram */


#begdef cnv_str_macro(f, e_aconv, e_tconv, e_nconv, e_sconf, e_fconv)
/*
 * cnv_str - cnv:string(*s, *d), convert to a string
 */
int f(dptr s, dptr d)
   {
   char sbuf[MaxCvtLen];

   EVValD(s, e_aconv);
   EVValD(&emptystr, e_tconv);

   type_case *s of {
      string: {
         *d = *s;
         EVValD(s, e_nconv);
         return 1;
         }
      integer: {

#ifdef LargeInts
         if (Type(*s) == T_Lrgint) {
            bigtos(s,d);
            }
         else
#endif                                  /* LargeInts */

         itos(IntVal(*s), d, sbuf);
         }
      real: {
         double res;
         GetReal(s, res);
         rtos(res, d, sbuf);
         }
      cset: {
         cstos(BlkD(*s,Cset)->bits, d, sbuf);
         }
      default: {
         EVValD(s, e_fconv);
         return 0;
         }
      }
   Protect(StrLoc(*d) = alcstr(StrLoc(*d), StrLen(*d)), fatalerr(0,NULL));
   EVValD(d, e_sconv);
   return 1;
   }
#enddef

#ifdef MultiProgram
#passthru #undef cnv_str
cnv_str_macro(cnv_str,0,0,0,0,0)
cnv_str_macro(cnv_str_1,E_Aconv,E_Tconv,E_Nconv,E_Sconv,E_Fconv)
#else                                   /* MultiProgram */
cnv_str_macro(cnv_str,0,0,0,0,0)
#endif                                  /* MultiProgram */

#begdef cnv_tcset_macro(f, e_aconv, e_tconv, e_nconv, e_sconv, e_fconv)
/*
 * cnv_tcset - cnv:tmp_cset(*s, *d), convert to a temporary cset
 */
int f(struct b_cset *cbuf, dptr s, dptr d)
   {
   struct descrip tmpstr;
   char sbuf[MaxCvtLen];
   register char *s1;
   C_integer l;

#ifdef DebugHeap
   /* we know its stack memory, but BlkCk won't know that... */
   cbuf->title = T_Cset;
#endif

   EVValD(s, e_aconv);
   EVValD(&csetdesc, e_tconv);

   if (is:cset(*s)) {
      *d = *s;
      EVValD(s, e_nconv);
      return 1;
      }
   if (tmp_str(sbuf, s, &tmpstr)) {
      for (l = 0; l < CsetSize; l++)
          cbuf->bits[l] = 0;
      d->dword = D_Cset;
      BlkLoc(*d) = (union block *)cbuf;
      s1 = StrLoc(tmpstr);
      l = StrLen(tmpstr);
      while(l--) {
         Setb(*s1, *d);
         s1++;
         }
      EVValD(d, e_sconv);
      return 1;
      }
   else {
      EVValD(s, e_fconv);
      return 0;
      }
   }
#enddef

#ifdef MultiProgram
cnv_tcset_macro(cnv_tcset_0,0,0,0,0,0)
cnv_tcset_macro(cnv_tcset_1,E_Aconv,E_Tconv,E_Nconv,E_Sconv,E_Fconv)
#else                                   /* MultiProgram */
cnv_tcset_macro(cnv_tcset,0,0,0,0,0)
#endif                                  /* MultiProgram */

#begdef cnv_tstr_macro(f,e_aconv,e_tconv,e_nconv,e_sconv,e_fconv)
/*
 * cnv_tstr - cnv:tmp_string(*s, *d), convert to a temporary string
 */
int f(char *sbuf, dptr s, dptr d)
   {
   EVValD(s, e_aconv);
   EVValD(&emptystr, e_tconv);

   if (is:string(*s)) {
      *d = *s;
      EVValD(s, e_nconv);
      return 1;
      }
   else if (tmp_str(sbuf, s, d)) {
      EVValD(d, e_sconv);
      return 1;
      }
   else {
      EVValD(s, e_fconv);
      return 0;
      }
   }
#enddef

#ifdef MultiProgram
cnv_tstr_macro(cnv_tstr_0,0,0,0,0,0)
cnv_tstr_macro(cnv_tstr_1,E_Aconv,E_Tconv,E_Nconv,E_Sconv,E_Fconv)
#else                                   /* MultiProgram */
cnv_tstr_macro(cnv_tstr,0,0,0,0,0)
#endif                                  /* MultiProgram */

#begdef deref_macro(f, e_deref)
/*
 * deref - dereference a descriptor.
 */
void f(dptr s, dptr d)
   {
   /*
    * deref() can alloc, bp and v need to be tended.
    * ep is initiliazed and used with no allocation in between, it is safe.
    */
   tended union block *bp;
   tended struct descrip v;
   register union block **ep;
   int res;


   if (!is:variable(*s)) {
      *d = *s;
      }
   else {
      EVVar(s, e_deref);
      type_case *s of {
      tvsubs: {
         /*
          * A substring trapped variable is being dereferenced.
          *  Point bp to the trapped variable block and v to
          *  the string.
          */
         bp = BlkLoc(*s);
         deref(&Blk(bp,Tvsubs)->ssvar, &v);
         if (!is:string(v))
            fatalerr(103, &v);
         if (Blk(bp,Tvsubs)->sspos + Blk(bp,Tvsubs)->sslen - 1 > StrLen(v))
            fatalerr(205, NULL);
         /*
          * Make a descriptor for the substring by getting the
          *  length and pointing into the string.
          */
         StrLen(*d) = Blk(bp,Tvsubs)->sslen;
         StrLoc(*d) = StrLoc(v) + Blk(bp,Tvsubs)->sspos - 1;
        }

      tvtbl: {
         /*
          * Look up the element in the table.
          */
         bp = BlkLoc(*s);
         if (BlkType(Blk(bp,Tvtbl)->clink) == T_File) {
            int status = Blk(Blk(bp,Tvtbl)->clink,File)->status;
#ifdef Dbm
            if (status & Fs_Dbm) {
               DBM *db;
               datum key, content;
               db = (DBM *)Blk(Blk(bp,Tvtbl)->clink,File)->fd.fp;
               if (!cnv:string(bp->Tvtbl.tref, bp->Tvtbl.tref)) { /* key */
                  fatalerr(103, &(bp->Tvtbl.tref));
                  }
               key.dptr = StrLoc(Blk(bp,Tvtbl)->tref);
               key.dsize = StrLen(Blk(bp,Tvtbl)->tref);
               content = dbm_fetch(db, key);
               if (content.dptr == NULL) *d = nulldesc;
               else {
                  StrLoc(*d) = alcstr(content.dptr, content.dsize);
                  Protect(StrLoc(*d),fatalerr(103, s));
                  StrLen(*d) = content.dsize;
                  }
               return;
               }
            else
#endif                                  /* Dbm */
               fatalerr(103, s);
               }
         ep = memb(bp->Tvtbl.clink,&(bp->Tvtbl.tref), bp->Tvtbl.hashnum, &res);
         if (res == 1)
            *d = Blk((*ep),Telem)->tval;                /* found; use value */
         else
            *d = Blk(Blk(bp,Tvtbl)->clink,Table)->defvalue;  /* use default */
         }

      kywdint:
      kywdpos:
      kywdsubj:
      kywdevent:
      kywdwin:
      kywdstr:
         *d = *VarLoc(*s);

      tvmonitored:{
#ifdef EventMon
         *d = *(VarLoc(BlkD(*s,Tvmonitored)->tv));
#endif                                  /* EventMon */
         }

      default: {
#ifdef Arrays
         if (Offset(*s) > 0) {
            if (BlkLoc(*s)->Realarray.title == T_Realarray) {
#ifdef DescriptorDouble
               d->vword.realval = *(double *)((word *)VarLoc(*s) + Offset(*s));
#else                                   /* DescriptorDouble */
               d->vword.bptr =
                  (union block *) alcreal(*(double *)((word *)VarLoc(*s) +
                                                      Offset(*s)));
#endif                                  /* DescriptorDouble */
               d->dword = D_Real;
            }
            else if (BlkLoc(*s)->Intarray.title == T_Intarray) {
               d->vword.integr = (word) *((word *)(VarLoc(*s)) +  Offset(*s)) ;
               d->dword = D_Integer;
            }
            else
               *d = *(dptr)((word *)VarLoc(*s) + Offset(*s));
         }
         else
#endif                                  /* Arrays */

         /*
          * An ordinary variable is being dereferenced.
          */
         *d = *(dptr)((word *)VarLoc(*s) + Offset(*s));
}
      }
      }
   }
#enddef

#ifdef MultiProgram
deref_macro(deref_0,0)
deref_macro(deref_1,E_Deref)
#else                                   /* MultiProgram */
deref_macro(deref,0)
#endif                                  /* MultiProgram */

/*
 * getdbl - return as a double the value inside a real block.
 */
double getdbl(dp)
dptr dp;
   {
   double d;
   GetReal(dp, d);
   return d;
   }

/*
 * tmp_str - Convert to temporary string.
 */
static int tmp_str(sbuf, s, d)
char *sbuf;
dptr s;
dptr d;
   {
   type_case *s of {
      string:
         *d = *s;
      integer: {

#ifdef LargeInts
         if (Type(*s) == T_Lrgint) {
            bigtos(s,d);
            }
         else
#endif                                  /* LargeInts */

         itos(IntVal(*s), d, sbuf);
         }
      real: {
         double res;
         GetReal(s, res);
         rtos(res, d, sbuf);
         }
      cset:
         cstos(BlkD(*s,Cset)->bits, d, sbuf);
      default:
         return 0;
      }
   return 1;
   }

/*
 * dp_pnmcmp - do a string comparison of a descriptor to the procedure
 *   name in a pstrnm struct; used in call to qsearch().
 */
int dp_pnmcmp(pne,dp)
struct pstrnm *pne;
struct descrip *dp;
{
   struct descrip d;
   StrLen(d) = strlen(pne->pstrep);
   StrLoc(d) = pne->pstrep;
   return lexcmp(&d,dp);
}

/*
 * bi_strprc - convert a string to a (built-in) function or operator.
 */
struct b_proc *bi_strprc(dptr s, C_integer arity)
   {
   C_integer i;
#if !COMPILER
   struct pstrnm *pp;
#endif                                  /* !COMPILER */

   if (!StrLen(*s))
      return NULL;

   /*
    * See if the string represents an operator. In this case the arity
    *  of the operator must match the one given.
    */
   if (!isalpha(*StrLoc(*s))) {
      for (i = 0; i < op_tbl_sz; ++i)
         if (eq(s, &op_tbl[i].pname) && (arity == op_tbl[i].nparam ||
                                         op_tbl[i].nparam == -1))
            return &op_tbl[i];
      return NULL;
      }

   /*
    * See if the string represents a built-in function.
    */
#if COMPILER
   for (i = 0; i < n_globals; ++i)
      if (eq(s, &gnames[i]))
         return builtins[i];  /* may be null */
#else                                   /* COMPILER */
   pp = (struct pstrnm *)qsearch((char *)s,(char *)pntab,pnsize,
                                 sizeof(struct pstrnm),dp_pnmcmp);
   if (pp!=NULL)
      return (struct b_proc *)pp->pblock;
#endif                                  /* !COMPILER */

   return NULL;
   }

/*
 * strprc - convert a string to a procedure.
 */
struct b_proc *strprc(dptr s, C_integer arity)
   {
   C_integer i;

   /*
    * See if the string is the name of a global variable.
    */
   for (i = 0; i < n_globals; ++i) {
      if (eq(s, &gnames[i])) {
         if (is:proc(globals[i]))
            return BlkD(globals[i], Proc);
         else
            return NULL;
         }
      }
   return bi_strprc(s,arity);
   }

/*
 * Service routines
 */

/*
 * itos - convert the integer num into a string using s as a buffer and
 *  making q a descriptor for the resulting string.
 */

static void itos(num, dp, s)
C_integer num;
dptr dp;
char *s;
   {
   register char *p;
   word ival;

   p = s + MaxCvtLen - 1;
   ival = num;

   *p = '\0';
   if (num >= 0L)
      do {
         *--p = ival % 10L + '0';
         ival /= 10L;
         } while (ival != 0L);
   else {
      if (ival == MinLong) {
         p -= strlen(MaxNegInt);
         strcpy(p, MaxNegInt);
         }
      else {
        ival = -ival;
        do {
           *--p = '0' + (ival % 10L);
           ival /= 10L;
           } while (ival != 0L);
        *--p = '-';
        }
      }

   StrLen(*dp) = s + MaxCvtLen - 1 - p;
   StrLoc(*dp) = p;
   }


/*
 * ston - convert a string to a numeric quantity if possible.
 * Returns a typecode or CvtFail.  Its answer is in the dptr,
 * unless conversion produces a double, in which case its in the
 * union numeric (we do this to avoid allocating a block for a
 * real that will later be used directly as a C_double).
 */
static int ston(sptr, result)
dptr sptr;
union numeric *result;
   {
   register char *s = StrLoc(*sptr), *end_s;
   register int c;
   int realflag = 0;    /* indicates a real number */
   char msign = '+';    /* sign of mantissa */
   char esign = '+';    /* sign of exponent */
   double mantissa = 0; /* scaled mantissa with no fractional part */
   word lresult = 0;    /* integer result */
   int scale = 0;       /* number of decimal places to shift mantissa */
   int digits = 0;      /* total number of digits seen */
   int sdigits = 0;     /* number of significant digits seen */
   int exponent = 0;    /* exponent part of real number */
   double fiveto;       /* holds 5^scale */
   double power;        /* holds successive squares of 5 to compute fiveto */
   int err_no;
   char *ssave;         /* holds original ptr for bigradix */
   int suffix = 0;      /* number of times to multiply 1024 into the result */

   if (StrLen(*sptr) == 0)
      return CvtFail;
   end_s = s + StrLen(*sptr);
   c = *s++;

   /*
    * Skip leading white space.
    */
   while (isspace(c))
      if (s < end_s)
         c = *s++;
      else
         return CvtFail;

   /*
    * Check for sign.
    */
   if (c == '+' || c == '-') {
      msign = c;
      c = (s < end_s) ? *s++ : ' ';
      }
   else if (c == '&') {
      if ((StrLen(*sptr) == 3) && (s[0] == 'p') && (s[1] == 'i')) {
         result->real = Pi;
         return T_Real;
         }
      else if ((StrLen(*sptr) == 2) && (s[0] == 'e')) {
         result->real = 2.71828182845904523536028747135266249775724709369996;
         return T_Real;
         }
      if ((StrLen(*sptr) == 4) && (s[0] == 'p') &&
          (s[1] == 'h') && (s[2] == 'i')) {
         result->real = 1.618033988749894848204586834365638117720309180;
         return T_Real;
         }
      else return CvtFail;
      }

   ssave = s - 1;   /* set pointer to beginning of digits in case it's needed */

   /*
    * Get integer part of mantissa.
    */
   while (isdigit(c)) {
      digits++;
      if (mantissa < Big) {
         mantissa = mantissa * 10 + (c - '0');
         lresult = lresult * 10 + (c - '0');
         if (mantissa > 0.0)
            sdigits++;
         }
      else
         scale++;
      c = (s < end_s) ? *s++ : ' ';
      }

   /*
    * Check for based integer.
    */
   if (c == 'r' || c == 'R') {
      int rv;
#ifdef LargeInts
      rv = bigradix((int)msign, (int)mantissa, s, end_s, result);
      if (rv == RunError)
         fatalerr(0, NULL);
#else                                   /* LargeInts */
      rv = radix((int)msign, (int)mantissa, s, end_s, result);
#endif                                  /* LargeInts */
      return rv;
      }

   /*
    * Get fractional part of mantissa.
    */
   if (c == '.') {
      realflag++;
      c = (s < end_s) ? *s++ : ' ';
      while (isdigit(c)) {
         digits++;
         if (mantissa < Big) {
            mantissa = mantissa * 10 + (c - '0');
            lresult = lresult * 10 + (c - '0');
            scale--;
            if (mantissa > 0.0)
               sdigits++;
            }
         c = (s < end_s) ? *s++ : ' ';
         }
      }

   /*
    * Check that at least one digit has been seen so far.
    */
   if (digits == 0)
      return CvtFail;

   /*
    * Get exponent part.
    */
   switch (c) {
   case 'k': case 'K': { suffix = 1; c = (s < end_s) ? *s++ : ' '; break; }
   case 'm': case 'M': { suffix = 2; c = (s < end_s) ? *s++ : ' '; break; }
   case 'g': case 'G': { suffix = 3; c = (s < end_s) ? *s++ : ' '; break; }
   case 't': case 'T': { suffix = 4; c = (s < end_s) ? *s++ : ' '; break; }
   case 'p': case 'P': { suffix = 5; c = (s < end_s) ? *s++ : ' '; break; }
   case 'e': case 'E': {
      realflag++;
      c = (s < end_s) ? *s++ : ' ';
      if (c == '+' || c == '-') {
         esign = c;
         c = (s < end_s) ? *s++ : ' ';
         }
      if (!isdigit(c))
         return CvtFail;
      while (isdigit(c)) {
         exponent = exponent * 10 + (c - '0');
         if (exponent > 308) return CvtFail;
         c = (s < end_s) ? *s++ : ' ';
         }
      scale += (esign == '+') ? exponent : -exponent;
      }
      }

   /*
    * Skip trailing white space and make sure there is nothing else left
    *  in the string. Note, if we have already reached end-of-string,
    *  c has been set to a space.
    */
   while (isspace(c) && s < end_s)
      c = *s++;
   if (!isspace(c))
      return CvtFail;

   /* KMGTP suffixes multiply by 1024, some number (1-5) of times */
   while (suffix--) {
      mantissa *= 1024;
      lresult *= 1024;
      }

   /*
    * Test for integer.
    */
   if (!realflag && !scale && mantissa >= MinLong && mantissa <= MaxLong) {
      result->integer = (msign == '+' ? lresult : -lresult);
      return T_Integer;
      }

#ifdef LargeInts
   /*
    * Test for bignum.
    */
#if COMPILER
   if (largeints)
#endif                                  /* COMPILER */
      if (!realflag) {
         int rv;
         rv = bigradix((int)msign, 10, ssave, end_s, result);
         if (rv == RunError)
            fatalerr(0, NULL);
         return rv;
         }
#endif                                  /* LargeInts */

   if (!realflag)
      return CvtFail;           /* don't promote to real if integer format */

   /*
    * Rough tests for overflow and underflow.
    */
   if (sdigits + scale > LogHuge)
      return CvtFail;

   if (sdigits + scale < -LogHuge) {
      result->real = 0.0;
      return T_Real;
      }

   /*
    * Put the number together by multiplying the mantissa by 5^scale and
    *  then using ldexp() to multiply by 2^scale.
    */

   exponent = (scale > 0)? scale : -scale;
   fiveto = 1.0;
   power = 5.0;
   for (;;) {
      if (exponent & 01)
         fiveto *= power;
      exponent >>= 1;
      if (exponent == 0)
         break;
      power *= power;
      }
   if (scale > 0)
      mantissa *= fiveto;
   else
      mantissa /= fiveto;

   err_no = 0;
   mantissa = ldexp(mantissa, scale);
   if (err_no > 0 && mantissa > 0)
      /*
       * ldexp caused overflow.
       */
      return CvtFail;

   if (msign == '-')
      mantissa = -mantissa;
   result->real = mantissa;
   return T_Real;
   }

#if COMPILER || !(defined LargeInts)
/*
 * radix - convert string s in radix r into an integer in *result.  sign
 *  will be either '+' or '-'.
 */
int radix(sign, r, s, end_s, result)
int sign;
register int r;
register char *s;
register char *end_s;
union numeric *result;
   {
   register int c;
   word num;

   if (r < 2 || r > 36)
      return CvtFail;
   c = (s < end_s) ? *s++ : ' ';
   num = 0L;
   while (isalnum(c)) {
      c = tonum(c);
      if (c >= r)
         return CvtFail;
      num = num * r + c;
      c = (s < end_s) ? *s++ : ' ';
      }

   /*
    * Skip trailing white space and make sure there is nothing else left
    *  in the string. Note, if we have already reached end-of-string,
    *  c has been set to a space.
    */
   while (isspace(c) && s < end_s)
      c = *s++;
   if (!isspace(c))
      return CvtFail;

   result->integer = (sign == '+' ? num : -num);

   return T_Integer;
   }
#endif                                  /* COMPILER || !(defined LargeInts) */


/*
 * cvpos - convert position to strictly positive position
 *  given length.
 */

word cvpos(pos, len)
word pos;
register word len;
   {
   register word p;

   /*
    * Make sure the position is in the range of an int. (?)
    */
   if ((word)(p = pos) != pos)
      return CvtFail;
   /*
    * Make sure the position is within range.
    */
   if (p < -len || p > len + 1)
      return CvtFail;
   /*
    * If the position is greater than zero, just return it.  Otherwise,
    *  convert the zero/negative position.
    */
   if (pos > 0)
      return p;
   return (len + p + 1);
   }

double dblZero = 0.0;

/*
 * rtos - convert the real number n into a string using s as a buffer and
 *  making a descriptor for the resulting string.
 */
void rtos(n, dp, s)
double n;
dptr dp;
char *s;
   {
   s++;                                 /* leave room for leading zero */
   sprintf(s, "%.*g", Precision, n + dblZero);   /* format, avoiding -0 */

   /*
    * Now clean up possible messes.
    */
   while (*s == ' ')                    /* delete leading blanks */
      s++;
   if (*s == '.') {                     /* prefix 0 to initial period */
      s--;
      *s = '0';
      }
   else if (!strchr(s, '.') && !strchr(s,'e') && !strchr(s,'E'))
         strcat(s, ".0");               /* if no decimal point or exp. */
   if (s[strlen(s) - 1] == '.')         /* if decimal point is at end ... */
      strcat(s, "0");
   StrLen(*dp) = strlen(s);
   StrLoc(*dp) = s;
   }

/*
 * cstos - convert the cset bit array pointed at by cs into a string using
 *  s as a buffer and making a descriptor for the resulting string.
 */

static void cstos(cs, dp, s)
unsigned int *cs;
dptr dp;
char *s;
   {
   register unsigned int w;
   register int j, i;
   register char *p;

   p = s;
   for (i = 0; i < CsetSize; i++) {
      if (cs[i])
         for (j=i*IntBits, w=cs[i]; w; j++, w >>= 1)
            if (w & 01)
               *p++ = FromAscii((char)j);
      }
   *p = '\0';

   StrLen(*dp) = p - s;
   StrLoc(*dp) = s;
   }

/*
 * cnv_list - (*s, *d), convert a value into a list (sets only)
 */
int cnv_list(dptr s, dptr d)
{
   register dptr d1;
   register word size;
   register int j, k;
   tended struct b_list *lp;
   union block *ep, *bp;
   register struct b_slots *seg;

   if (!is:set(*s)) return 0;
   /*
    * Create a list the size of the set, copy each element into
    * the list, and return the unsorted list.
    */
   size = BlkD(*s,Set)->size;

   Protect(lp = alclist_raw(size, size), fatalerr(0,NULL));

   bp = BlkLoc(*s);  /* need not be tended if not set until now */

   if (size > 0) {  /* only need to copy values for non-empty sets */
      d1 = Blk(lp->listhead,Lelem)->lslots;
      for (j=0; j < HSegs && (seg= BlkPH(bp,Table,hdir)[j])!=NULL;j++)
         for (k = segsize[j] - 1; k >= 0; k--)
            for (ep= seg->hslots[k]; ep!=NULL;ep=BlkPE(ep,Telem,clink))
               *d1++ = BlkPE(ep,Selem,setmem);
      }

   Desc_EVValD(lp, E_Lcreate, D_List);
   d->dword = D_List;
   BlkLoc(*d) = (union block *)lp;
   return 1;
}
