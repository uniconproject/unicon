/*
 * File: rmisc.r
 *  Contents: eq, getkeyword, getvar, hash, outimage,
 *  qtos, pushact, popact, topact, [dumpact], 
 *  findline, findipc, findfile, doimage, getimage
 *  findsyntax, hitsyntax
 *  printable, retderef, sig_rsm, cmd_line, varargs.
 *
 *  Integer overflow checking.
 */

/*
 * Prototypes.
 */
static void	listimage       (FILE *f,struct b_list *lp, int noimage);
static void	printimage	(FILE *f,int c,int q);
static char *	csname		(dptr dp);
static int construct_funcimage(union block *pe, int aicode, int bpcode, dptr result, int index);
int        find_cindex(union block *l, union block *r); 


/* 
 * eq - compare two Icon strings for equality
 */
int eq(d1, d2)
dptr d1, d2;
{
	char *s1, *s2;
	int i;

	if (StrLen(*d1) != StrLen(*d2))
	   return 0;
	s1 = StrLoc(*d1);
	s2 = StrLoc(*d2);
	for (i = 0; i < StrLen(*d1); i++)
	   if (*s1++ != *s2++) 
	      return 0;
	return 1;
}

#ifdef PatternType
/*
 * getkeyword() - return a descriptor with current value of non-variable
 * keywords not found in getvar(). So far just the cset constants.
 * Need to add the rest of the keywords.
 * The code to use getkeyword() is different from code to use getvar because
 *    getvar() returns a variable descriptor, but getkeyword() just returns
 *    the value in a descriptor. No dereference will be needed.
 */

int getkeyword(char *s, dptr vp)
{
   if (*s++ == '&') {
      switch(*s++) {
      case 'a':
         if (!strcmp(s, "scii")) {
	    vp->dword = D_Cset; vp->vword.bptr = (union block *)&k_ascii;
	    return Succeeded;
	    }
         break;
      case 'c':
         if (!strcmp(s, "set")) {
	    vp->dword = D_Cset; vp->vword.bptr = (union block *)&k_cset;
	    return Succeeded;
	    }
         break;
      case 'd':
         if (!strcmp(s, "igits")) {
	    vp->dword = D_Cset; vp->vword.bptr = (union block *)&k_digits;
	    return Succeeded;
	    }
         break;
      case 'l':
         if (!strcmp(s, "etters")) {
	    vp->dword = D_Cset; vp->vword.bptr = (union block *)&k_letters;
	    return Succeeded;
	    }
         else if (!strcmp(s, "case")) {
	    vp->dword = D_Cset; vp->vword.bptr = (union block *)&k_lcase;
	    return Succeeded;
	    }
         break;
      case 'u':
         if (!strcmp(s, "case")) {
	    vp->dword = D_Cset; vp->vword.bptr = (union block *)&k_ucase;
	    return Succeeded;
	    }
         break;
         }
      }
   return Failed;
   }
#endif					/* PatternType */

/*
 * Get variable descriptor from name.  Returns the (integer-encoded) scope
 *  of the variable (Succeeded for keywords), or Failed if the variable
 *  does not exist.
 */
int getvar(s,vp)
   char *s;
   dptr vp;
   {
   register dptr dp;
   register dptr np;
   register int i;
   struct b_proc *bp;
#if COMPILER
   struct descrip sdp;
#else					/* COMPILER */
   struct pf_marker *fp;
#endif
   CURTSTATE_AND_CE();

#if COMPILER
   if (!debug_info) 
      fatalerr(402,NULL);

   StrLoc(sdp) = s;
   StrLen(sdp) = strlen(s);
#else					/* COMPILER */
   fp = pfp;
#endif					/* COMPILER */

   /*
    * Is it a keyword that's a variable?
    */
   if (*s == '&') {

      if (strcmp(s,"&error") == 0) {	/* must put basic one first */
         vp->dword = D_Kywdint;
         VarLoc(*vp) = &kywd_err;
         return Succeeded;
         }
#ifdef PosixFns
      else if (strcmp(s,"&errno") == 0) {
         vp->dword = D_Kywdint;
         VarLoc(*vp) = &amperErrno;
         return Succeeded;
         }
#endif					/* PosixFns */
      else if (strcmp(s,"&pos") == 0) {
         vp->dword = D_Kywdpos;
         VarLoc(*vp) = &kywd_pos;
         return Succeeded;
         }
      else if (strcmp(s,"&progname") == 0) {
         vp->dword = D_Kywdstr;
         VarLoc(*vp) = &kywd_prog;
         return Succeeded;
         }
      else if (strcmp(s,"&random") == 0) {
         vp->dword = D_Kywdint;
         VarLoc(*vp) = &kywd_ran;
         return Succeeded;
         }
      else if (strcmp(s,"&subject") == 0) {
         vp->dword = D_Kywdsubj;
         VarLoc(*vp) = &k_subject;
         return Succeeded;
         }
      else if (strcmp(s,"&trace") == 0) {
         vp->dword = D_Kywdint;
         VarLoc(*vp) = &kywd_trc;
         return Succeeded;
         }

#ifdef FncTrace
      else if (strcmp(s,"&ftrace") == 0) {
         vp->dword = D_Kywdint;
         VarLoc(*vp) = &kywd_ftrc;
         return Succeeded;
         }
#endif					/* FncTrace */

      else if (strcmp(s,"&dump") == 0) {
         vp->dword = D_Kywdint;
         VarLoc(*vp) = &kywd_dmp;
         return Succeeded;
         }
#ifdef Graphics
      else if (strcmp(s,"&window") == 0) {
         vp->dword = D_Kywdwin;
         VarLoc(*vp) = &(kywd_xwin[XKey_Window]);
         return Succeeded;
         }
#endif					/* Graphics */

#ifdef MultiProgram
      else if (strcmp(s,"&eventvalue") == 0) {
         vp->dword = D_Var;
         VarLoc(*vp) = (dptr)&(curpstate->eventval);
         return Succeeded;
         }
      else if (strcmp(s,"&eventsource") == 0) {
         vp->dword = D_Var;
         VarLoc(*vp) = (dptr)&(curpstate->eventsource);
         return Succeeded;
         }
      else if (strcmp(s,"&eventcode") == 0) {
         vp->dword = D_Var;
         VarLoc(*vp) = (dptr)&(curpstate->eventcode);
         return Succeeded;
         }
#endif					/* MultiProgram */

      else return Failed;
      }

   /*
    * Look for the variable the name with the local identifiers,
    *  parameters, and static names in each Icon procedure frame on the
    *  stack. If not found among the locals, check the global variables.
    *  If a variable with name is found, variable() returns a variable
    *  descriptor that points to the corresponding value descriptor. 
    *  If no such variable exits, it fails.
    */

#if !COMPILER
   /*
    *  If no procedure has been called (as can happen with icon_call(),
    *  don't try to find local identifier.
    */
   if (pfp == NULL)
      goto glbvars;
#endif					/* !COMPILER */

   dp = glbl_argp;
#if COMPILER
   bp = PFDebug(*pfp)->proc;  /* get address of procedure block */
#else					/* COMPILER */
   bp = &(BlkLoc(*dp)->Proc);		/* get address of procedure block */

   if (bp->title != T_Proc) {
      if (value_tmp.dword == D_Proc) {
	 bp = (struct b_proc *)BlkLoc(value_tmp);
	 }
      }
#endif					/* COMPILER */
   
   np = bp->lnames;		/* Check the formal parameter names. */

   for (i = abs((int)bp->nparam); i > 0; i--) {
#if COMPILER
      if (eq(&sdp, np) == 1) {
#else					/* COMPILER */
      dp++;

      if (strcmp(s,StrLoc(*np)) == 0) {
#endif					/* COMPILER */
         vp->dword = D_Var;
         VarLoc(*vp) = (dptr)dp;
         return ParamName;
         }
      np++;
#if COMPILER
      dp++;
#endif					/* COMPILER */
      }

#if COMPILER
   dp = &pfp->t.d[0];
#else					/* COMPILER */
   dp = &fp->pf_locals[0];
#endif					/* COMPILER */

   for (i = (int)bp->ndynam; i > 0; i--) { /* Check the local dynamic names. */
#if COMPILER
         if (eq(&sdp, np)) {
#else					/* COMPILER */
	 if (strcmp(s,StrLoc(*np)) == 0) {
#endif					/* COMPILER */
            vp->dword = D_Var;
            VarLoc(*vp) = (dptr)dp;
            return LocalName;
	    }
         np++;
         dp++;
         }

   dp = &statics[bp->fstatic]; /* Check the local static names. */
   for (i = (int)bp->nstatic; i > 0; i--) {
#if COMPILER
         if (eq(&sdp, np)) {
#else					/* COMPILER */
         if (strcmp(s,StrLoc(*np)) == 0) {
#endif					/* COMPILER */
            vp->dword = D_Var;
            VarLoc(*vp) = (dptr)dp;
            return StaticName;
	    }
         np++;
         dp++;
         }

#if COMPILER
   for (i = 0; i < n_globals; ++i) {
      if (eq(&sdp, &gnames[i])) {
         vp->dword = D_Var;
         VarLoc(*vp) = (dptr)&globals[i];
         return GlobalName;
         }
      }
#else					/* COMPILER */
glbvars:
   dp = globals;	/* Check the global variable names. */
   np = gnames;
   while (dp < eglobals) {
      if (strcmp(s,StrLoc(*np)) == 0) {
         vp->dword    =  D_Var;
         VarLoc(*vp) =  (dptr)(dp);
         return GlobalName;
         }
      np++;
      dp++;
      }
#endif					/* COMPILER */
   return Failed;
   }

/*
 * hash - compute hash value of arbitrary object for table and set accessing.
 */

uword hash(dp)
dptr dp;
   {
   register char *s;
   register uword i;
   register word j, n;
   register unsigned int *bitarr;
   double r;

   if (Qual(*dp)) {
   hashstring:
      /*
       * Compute the hash value for the string based on a scaled sum
       *  of its first and last several characters, plus its length.
       *  Loops are unrolled.
       */
      i = 0;
      s = StrLoc(*dp);
      n = StrLen(*dp);

      switch(n){
      case 20:  i ^= (i << 7)^(*s++)^(i >> 3);
      case 19:  i ^= ~(i << 11)^(*s++)^(i >> 5);
      case 18:  i ^= (i << 7)^(*s++)^(i >> 3);
      case 17:  i ^= ~(i << 11)^(*s++)^(i >> 5);
      case 16:  i ^= (i << 7)^(*s++)^(i >> 3);
      case 15:  i ^= ~(i << 11)^(*s++)^(i >> 5);
      case 14:  i ^= (i << 7)^(*s++)^(i >> 3);
      case 13:  i ^= ~(i << 11)^(*s++)^(i >> 5);
      case 12:  i ^= (i << 7)^(*s++)^(i >> 3);
      case 11:  i ^= ~(i << 11)^(*s++)^(i >> 5);
      case 10:  i ^= (i << 7)^(*s++)^(i >> 3);
      case 9:   i ^= ~(i << 11)^(*s++)^(i >> 5);
      case 8:   i ^= (i << 7)^(*s++)^(i >> 3);
      case 7:   i ^= ~(i << 11)^(*s++)^(i >> 5);
      case 6:   i ^= (i << 7)^(*s++)^(i >> 3);
      case 5:   i ^= ~(i << 11)^(*s++)^(i >> 5);
      case 4:   i ^= (i << 7)^(*s++)^(i >> 3);
      case 3:   i ^= ~(i << 11)^(*s++)^(i >> 5);
      case 2:   i ^= (i << 7)^(*s++)^(i >> 3);
      case 1:   i ^= ~(i << 11)^(*s++)^(i >> 5);
      case 0:   break;
      default:

	 i ^= (i << 7)^(*s++)^(i >> 3);
	 i ^= ~(i << 11)^(*s++)^(i >> 5);
	 i ^= (i << 7)^(*s++)^(i >> 3);
	 i ^= ~(i << 11)^(*s++)^(i >> 5);
	 i ^= (i << 7)^(*s++)^(i >> 3);
	 i ^= ~(i << 11)^(*s++)^(i >> 5);
	 i ^= (i << 7)^(*s++)^(i >> 3);
	 i ^= ~(i << 11)^(*s++)^(i >> 5);
	 i ^= (i << 7)^(*s++)^(i >> 3);
	 i ^= ~(i << 11)^(*s++)^(i >> 5);

	 s += n - 20;

	 i ^= (i << 7)^(*s++)^(i >> 3);
	 i ^= ~(i << 11)^(*s++)^(i >> 5);
	 i ^= (i << 7)^(*s++)^(i >> 3);
	 i ^= ~(i << 11)^(*s++)^(i >> 5);
	 i ^= (i << 7)^(*s++)^(i >> 3);
	 i ^= ~(i << 11)^(*s++)^(i >> 5);
	 i ^= (i << 7)^(*s++)^(i >> 3);
	 i ^= ~(i << 11)^(*s++)^(i >> 5);
	 i ^= (i << 7)^(*s++)^(i >> 3);
	 i ^= ~(i << 11)^(*s++)^(i >> 5);
	 }
      i += n;
      }

   else {

      switch (Type(*dp)) {
         /*
          * The hash value of an integer is itself times eight times the golden
	  *  ratio.  We do this calculation in fixed point.  We don't just use
	  *  the integer itself, for that would give bad results with sets
	  *  having entries that are multiples of a power of two.
          */
         case T_Integer:
            i = (13255 * (uword)IntVal(*dp)) >> 10;
            break;

#ifdef LargeInts
         /*
          * The hash value of a bignum is based on its length and its
          *  most and least significant digits.
          */
	 case T_Lrgint:
	    {
	    struct b_bignum *b = BlkD(*dp, Lrgint);

	    i = ((b->lsd - b->msd) << 16) ^ 
		(b->digits[b->msd] << 8) ^ b->digits[b->lsd];
	    }
	    break;
#endif					/* LargeInts */

         /*
          * The hash value of a real number is itself times a constant,
          *  converted to an unsigned integer.  The intent is to scramble
	  *  the bits well, in the case of integral values, and to scale up
	  *  fractional values so they don't all land in the same bin.
	  *  The constant below is 32749 / 29, the quotient of two primes,
	  *  and was observed to work well in empirical testing.
          */
         case T_Real:
            GetReal(dp,r);
            i = r * 1129.27586206896558;
            break;

         /*
          * The hash value of a cset is based on a convoluted combination
          *  of all its bits.
          */
         case T_Cset:
            i = 0;
            bitarr = BlkD(*dp,Cset)->bits + CsetSize - 1;
            for (j = 0; j < CsetSize; j++) {
               i += *bitarr--;
               i *= 37;			/* better distribution */
               }
            i %= 1048583;		/* scramble the bits */
            break;

         /*
          * The hash value of a list, set, table, or record is its id,
          *   hashed like an integer.
          */
         case T_List:
            i = (13255 * BlkD(*dp,List)->id) >> 10;
            break;

         case T_Set:
            i = (13255 * BlkD(*dp,Set)->id) >> 10;
            break;

         case T_Table:
            i = (13255 * BlkD(*dp,Table)->id) >> 10;
            break;

         case T_Record:
            i = (13255 * BlkD(*dp,Record)->id) >> 10;
            break;
 
	 case T_Proc:
	    dp = &(BlkD(*dp,Proc)->pname);
	    goto hashstring;

         default:
            /*
             * For other types, use the type code as the hash
             *  value.
             */
            i = Type(*dp);
            break;
         }
      }

   return i;
   }


#define StringLimit	16		/* limit on length of imaged string */
#define ListLimit	 6		/* limit on list items in image */

/*
 * outimage - print image of *dp on file f.  If noimage is nonzero,
 *  fields of records will not be imaged.
 */

void outimage(f, dp, noimage)
FILE *f;
dptr dp;
int noimage;
   {
   register word i, j;
   register char *s;
   register union block *bp;
   char *type, *csn;
   FILE *fd;
   struct descrip q;
   double rresult;
   tended struct descrip tdp;

   type_case *dp of {
      string: {
         /*
          * *dp is a string qualifier.  Print StringLimit characters of it
          *  using printimage and denote the presence of additional characters
          *  by terminating the string with "...".
          */
         i = StrLen(*dp);
         s = StrLoc(*dp);
         j = Min(i, StringLimit);
         putc('"', f);
         while (j-- > 0)
            printimage(f, *s++, '"');
         if (i > StringLimit)
            fprintf(f, "...");
         putc('"', f);
         }

      null:
         fprintf(f, "&null");

      integer:

#ifdef LargeInts
         if (Type(*dp) == T_Lrgint)
            bigprint(f, dp);
         else
#endif					/* LargeInts */
#ifdef LongLongWord
            fprintf(f, "%lld", (word)IntVal(*dp));
#else					/* LongLongWord */
            fprintf(f, "%ld", (long)IntVal(*dp));
#endif					/* LongLongWord */

      real: {
         char s[30];
         struct descrip rd;

         GetReal(dp,rresult);
         rtos(rresult, &rd, s);
         fprintf(f, "%s", StrLoc(rd));
         }

      cset: {
         /*
	  * Check for a predefined cset; use keyword name if found.
	  */
	 if ((csn = csname(dp)) != NULL) {
	    fprintf(f, "%s", csn);
	    return;
	    }
         /*
          * Use printimage to print each character in the cset.  Follow
          *  with "..." if the cset contains more than StringLimit
          *  characters.
          */
         putc('\'', f);
         j = StringLimit;
         for (i = 0; i < 256; i++) {
            if (Testb(i, *dp)) {
               if (j-- <= 0) {
                  fprintf(f, "...");
                  break;
                  }
               printimage(f, (int)i, '\'');
               }
            }
         putc('\'', f);
         }

      file: {
         /*
          * Check for distinguished files by looking at the address of
          *  of the object to image.  If one is found, print its name.
          */
         if ((fd = BlkD(*dp,File)->fd.fp) == stdin)
            fprintf(f, "&input");
         else if (fd == stdout)
            fprintf(f, "&output");
         else if (fd == stderr)
            fprintf(f, "&errout");
         else {
            /*
             * The file isn't a special one, just print "file(name)".
             */
	    i = StrLen(BlkD(*dp,File)->fname);
	    s = StrLoc(BlkLoc(*dp)->File.fname);
#ifdef PosixFns
	    if (BlkLoc(*dp)->File.status & Fs_Socket) {
	       fprintf(f, "inet(");
               }
            else
	    if (BlkLoc(*dp)->File.status & Fs_Directory) {
	       fprintf(f, "directory(");
               }
	    else
#endif
#ifdef Dbm
	    if(BlkLoc(*dp)->File.status & Fs_Dbm) {
	       fprintf(f, "dbmfile(");
               }
	    else
#endif
#ifdef Graphics
	    if (BlkLoc(*dp)->File.status & Fs_Window) {
	       if ((BlkLoc(*dp)->File.status != Fs_Window) && /* window open?*/
		  (s = BlkLoc(*dp)->File.fd.wb->window->windowlabel)) {
		  i = strlen(s);
	          fprintf(f, "window_%d:%d(",
		       BlkLoc(*dp)->File.fd.wb->window->serial,
		       BlkLoc(*dp)->File.fd.wb->context->serial
		       );
		  }
	       else {
		  i = 0;
	          fprintf(f, "window_-1:-1(");
		 }
	       }
	    else
#endif					/* Graphics */
#ifdef Messaging
            if (BlkD(*dp,File)->status & Fs_Messaging) {
	       struct MFile *mf = BlkLoc(*dp)->File.fd.mf;
	       fprintf(f, "message(");
	       if (mf && mf->resp && mf->resp->msg != NULL) {
		  fprintf(f, "[%d:%s]", mf->resp->sc, mf->resp->msg);
		  }
	       }
	    else
#endif                                  /* Messaging */
	       fprintf(f, "file(");
	    while (i-- > 0)
	       printimage(f, *s++, '\0');
	    putc(')', f);
            }
         }

      proc: {
         /*
          * Produce one of:
          *  "procedure name"
          *  "function name"
          *  "record constructor name"
          *  "class constructor name"
          *
          * Note that the number of dynamic locals is used to determine
          *  what type of "procedure" is at hand.
          */
         i = StrLen(BlkD(*dp,Proc)->pname);
         s = StrLoc(BlkLoc(*dp)->Proc.pname);
         switch ((int)BlkLoc(*dp)->Proc.ndynam) {
            default:  type = "procedure"; break;
            case -1:  type = "function"; break;
            case -2:  type = "record constructor"; break;
	    case -3:  type = "class constructor"; break;
            }
         fprintf(f, "%s ", type);
         while (i-- > 0)
            printimage(f, *s++, '\0');
         }

      list: {
         /*
          * listimage does the work for lists.
          */
         listimage(f, BlkD(*dp, List), noimage);
         }

      table: {
         /*
          * Print "table_m(n)" where n is the size of the table.
          */
         fprintf(f, "table_%ld(%ld)", (long)BlkD(*dp,Table)->id,
            (long)BlkLoc(*dp)->Table.size);
         }

      set: {
	/*
         * print "set_m(n)" where n is the cardinality of the set
         */
	fprintf(f,"set_%ld(%ld)",(long)BlkD(*dp,Set)->id,
           (long)BlkLoc(*dp)->Set.size);
        }

      record: {
	 int is_obj = 0;
         /*
          * If noimage is nonzero, print "record(n)" where n is the
          *  number of fields in the record.  If noimage is zero, print
          *  the image of each field instead of the number of fields.
          */
         bp = BlkLoc(*dp);
         i = StrLen(Blk(Blk(bp,Record)->recdesc,Proc)->recname);
         s = StrLoc(bp->Record.recdesc->Proc.recname);
         j = Blk(Blk(bp,Record)->recdesc,Proc)->nfields;

	 if((j>0) && (bp == (Blk(bp,Record)->fields[0]).vword.bptr) &&
	    !strcmp(StrLoc(Blk(Blk(bp,Record)->recdesc,Proc)->lnames[0]),
		    "__s")) {
	    char *__stateloc;
	    is_obj = 1;
	    if ((__stateloc = strstr(s, "__state")) != NULL) {
	       while (s != __stateloc) {
		  printimage(f, *s++, '\0'); i--; }
	       s += 7; i -= 7;
	       }
	    while (i-- > 0)
	       printimage(f, *s++, '\0');
	    }
	 else {
	    fprintf(f, "record ");
         while (i-- > 0)
            printimage(f, *s++, '\0');
	    }
         fprintf(f, "_%ld", (long)Blk(bp,Record)->id);

	 if (f != stderr) {
	    if (j <= 0)
	       fprintf(f, "()");
	    else if (noimage > 0)
	       fprintf(f, "(%ld)", (long)j);
	    else {
	       putc('(', f);
	       if (is_obj) i = 2; else
		  i = 0;
	       /* if we have any fields at all... */
	       if (i < j) {
		  for (;;) {
		     outimage(f, &Blk(bp,Record)->fields[i], noimage + 1);
		     if (++i >= j)
			break;
		     putc(',', f);
		     }
		  }
	       putc(')', f);
	       }
	    }
	 }

      coexpr: {
         struct b_coexpr *cp = BlkD(*dp, Coexpr);
#ifdef Concurrent
         if (IS_TS_THREAD(cp->status))
            fprintf(f, "thread_%ld(%ld)", (long) cp->id, (long) cp->size);
   	 else
#endif					/* Concurrent */
            fprintf(f, "co-expression_%ld(%ld)", (long) cp->id, (long) cp->size);
         }

      tvsubs: {
         /*
          * Produce "v[i+:j] = value" where v is the image of the variable
          *  containing the substring, i is starting position of the substring
          *  j is the length, and value is the string v[i+:j].	If the length
          *  (j) is one, just produce "v[i] = value".
          */
         bp = BlkLoc(*dp);
	 dp = VarLoc(Blk(bp,Tvsubs)->ssvar);
         if (is:kywdsubj(bp->Tvsubs.ssvar)) {
            fprintf(f, "&subject");
            fflush(f);
            }
         else {
            dp = (dptr)((word *)dp + Offset(Blk(bp,Tvsubs)->ssvar));
            outimage(f, dp, noimage);
            }

         if (bp->Tvsubs.sslen == 1)

#if EBCDIC != 1
            fprintf(f, "[%ld]", (long)Blk(bp,Tvsubs)->sspos);
#else					/* EBCDIC != 1 */

            fprintf(f, "$<%ld$>", (long)Blk(bp,Tvsubs)->sspos);
#endif					/* EBCDIC != 1 */

         else

#if EBCDIC != 1
            fprintf(f, "[%ld+:%ld]", (long)Blk(bp,Tvsubs)->sspos,

#else					/* EBCDIC != 1 */
            fprintf(f, "$<%ld+:%ld$>", (long)Blk(bp,Tvsubs)->sspos,
#endif					/* EBCDIC != 1 */

               (long)Blk(bp,Tvsubs)->sslen);

         if (Qual(*dp)) {
            if (Blk(bp,Tvsubs)->sspos + Blk(bp,Tvsubs)->sslen - 1 >StrLen(*dp))
               return;
            StrLen(q) = bp->Tvsubs.sslen;
            StrLoc(q) = StrLoc(*dp) + bp->Tvsubs.sspos - 1;
            fprintf(f, " = ");
            outimage(f, &q, noimage);
            }
        }

      tvtbl: {
         /*
          * produce "t[s]" where t is the image of the table containing
          *  the element and s is the image of the subscript.
          */
         bp = BlkLoc(*dp);
#ifdef Dbm
	 if (BlkType(bp) == T_File)
	    tdp.dword = D_File;
	 else
#endif					/* Dbm */
	    tdp.dword = D_Table;
	 BlkLoc(tdp) = Blk(bp,Tvtbl)->clink;
	 outimage(f, &tdp, noimage);

#if EBCDIC != 1
         putc('[', f);
#else					/* EBCDIC != 1 */
         putc('$', f);
         putc('<', f);
#endif					/* EBCDIC != 1 */

         outimage(f, &(bp->Tvtbl.tref), noimage);

#if EBCDIC != 1
         putc(']', f);
#else					/* EBCDIC != 1 */
         putc('$', f);
         putc('>', f);
#endif					/* EBCDIC != 1 */
         }

      kywdint: {
         if (VarLoc(*dp) == &kywd_ran)
            fprintf(f, "&random = ");
         else if (VarLoc(*dp) == &kywd_trc)
            fprintf(f, "&trace = ");

#ifdef FncTrace
         else if (VarLoc(*dp) == &kywd_ftrc)
            fprintf(f, "&ftrace = ");
#endif					/* FncTrace */

         else if (VarLoc(*dp) == &kywd_dmp)
            fprintf(f, "&dump = ");
         else if (VarLoc(*dp) == &kywd_err)
            fprintf(f, "&error = ");
         outimage(f, VarLoc(*dp), noimage);
         }

      kywdevent: {
#ifdef MultiProgram
         if (VarLoc(*dp) == &curpstate->eventsource)
            fprintf(f, "&eventsource = ");
         else if (VarLoc(*dp) == &curpstate->eventcode)
            fprintf(f, "&eventcode = ");
         else if (VarLoc(*dp) == &curpstate->eventval)
            fprintf(f, "&eventval = ");
#endif					/* MultiProgram */
         outimage(f, VarLoc(*dp), noimage);
         }

      kywdstr: {
         outimage(f, VarLoc(*dp), noimage);
         }

      kywdpos: {
         fprintf(f, "&pos = ");
         outimage(f, VarLoc(*dp), noimage);
         }

      kywdsubj: {
         fprintf(f, "&subject = ");
         outimage(f, VarLoc(*dp), noimage);
         }
      kywdwin: {
         fprintf(f, "&window = ");
         outimage(f, VarLoc(*dp), noimage);
         }

      default: { 
         if (is:variable(*dp)) {
            /*
             * *d is a variable.  Print "variable =", dereference it, and 
             *  call outimage to handle the value.
             */
            fprintf(f, "(variable = "); fflush(f);

	    /* weird special cases for arrays, which are the only "variable"
	     * descriptors that do not point at a variable descriptor.
	     */
	    if (Offset(*dp) &&
		(((struct b_intarray *)VarLoc(*dp))->title == T_Intarray)) {
	       fprintf(f, "%ld",(long)
		       ((struct b_intarray *)VarLoc(*dp))->a[Offset(*dp)-4]);
	       }
	    else if (Offset(*dp) &&
		     (((struct b_realarray *)VarLoc(*dp))->title==T_Realarray)){
	       char s[30];
	       struct descrip rd;
	       rtos(((struct b_realarray *)VarLoc(*dp))->a[Offset(*dp)-4], &rd, s);
	       fprintf(f, "%s", StrLoc(rd));
	       }
	    else {
	       dp = (dptr)((word *)VarLoc(*dp) + Offset(*dp));
	       outimage(f, dp, noimage);
	       }
            putc(')', f);
            }
         else if (Type(*dp) == T_External)
            fprintf(f, "external(%ld)",(long int)(BlkD(*dp,External)->blksize));
         else if (Type(*dp) <= MaxType)
            fprintf(f, "%s", blkname[Type(*dp)]);
         else
            syserr("outimage: unknown type");
         }
      }
   }

/*
 * printimage - print character c on file f using escape conventions
 *  if c is unprintable, '\', or equal to q.
 */

static void printimage(f, c, q)
FILE *f;
int c, q;
   {
   if (printable(c)) {
      /*
       * c is printable, but special case ", ', and \.
       */
      switch (c) {
         case '"':
            if (c != q) goto deflt;
            fprintf(f, "\\\"");
            return;
         case '\'':
            if (c != q) goto deflt;
            fprintf(f, "\\'");
            return;
         case '\\':
            fprintf(f, "\\\\");
            return;
         default:
         deflt:
            putc(c, f);
            return;
         }
      }

   /*
    * c is some sort of unprintable character.	If it one of the common
    *  ones, produce a special representation for it, otherwise, produce
    *  its hex value.
    */
   switch (c) {
      case '\b':			/* backspace */
         fprintf(f, "\\b");
         return;

#if !EBCDIC
      case '\177':			/* delete */
#else					/* !EBCDIC */
      case '\x07':
#endif					/* !EBCDIC */

         fprintf(f, "\\d");
         return;
#if !EBCDIC
      case '\33':			/* escape */
#else					/* !EBCDIC */
      case '\x27':
#endif					/* !EBCDIC */
         fprintf(f, "\\e");
         return;
      case '\f':			/* form feed */
         fprintf(f, "\\f");
         return;
      case LineFeed:			/* new line */
         fprintf(f, "\\n");
         return;

#if EBCDIC == 1
      case '\x25':                      /* EBCDIC line feed */
         fprintf(f, "\\l");
         return;
#endif					/* EBCDIC == 1 */

      case CarriageReturn:		/* carriage return */
         fprintf(f, "\\r");
         return;
      case '\t':			/* horizontal tab */
         fprintf(f, "\\t");
         return;
      case '\13':			/* vertical tab */
         fprintf(f, "\\v");
         return;
      default:				/* hex escape sequence */
         fprintf(f, "\\x%02x", ToAscii(c & 0xff));
         return;
      }
   }

/*
 * listimage - print an image of a list.
 */

static void listimage(f, lp, noimage)
FILE *f;
struct b_list *lp;
int noimage;
   {
   register word i, j;
   word size, count;
   
   size = lp->size;

   if (noimage > 0 && size > 0) {
      /*
       * Just give indication of size if the list isn't empty.
       */
      fprintf(f, "list_%ld(%ld)", (long)lp->id, (long)size);
      return;
      }

   /*
    * Print [e1,...,en] on f.  If more than ListLimit elements are in the
    *  list, produce the first ListLimit/2 elements, an ellipsis, and the
    *  last ListLimit elements.
    */

#if EBCDIC != 1
   fprintf(f, "list_%ld = [", (long)lp->id);
#else					/* EBCDIC != 1 */
   fprintf(f, "list_%ld = $<", (long)lp->id);
#endif				/* EBCDIC != 1 */

   if (lp->listtail!=NULL){   
      register struct b_lelem *bp = (struct b_lelem *) lp->listhead;   
      count = 1;
      i = 0;
      if (size > 0) {
	 for (;;) {
	    if (++i > bp->nused) {
	       i = 1;
	       bp = (struct b_lelem *) bp->listnext;
	       }
	    if (count <= ListLimit/2 || count > size - ListLimit/2) {
	       j = bp->first + i - 1;
	       if (j >= bp->nslots)
		  j -= bp->nslots;
	       outimage(f, &bp->lslots[j], noimage+1);
	       if (count >= size)
		  break;
	       putc(',', f);
	       }
	    else if (count == ListLimit/2 + 1)
	       fprintf(f, "...,");
	    count++;
	    }
	 }
      }
#ifdef Arrays      
   else if (BlkType(lp->listhead) ==T_Realarray){
      tended struct descrip d;
#ifndef DescriptorDouble
      tended struct b_real *rblk = alcreal(0.0);
#endif					/* DescriptorDouble */
      /* probably need to worry about the following pointer*/
      register struct b_realarray *ap = (struct b_realarray *) lp->listhead;
      
#ifdef DescriptorDouble
      d.vword.realval = 0.0;
#else					/* DescriptorDouble */
      d.vword.bptr = (union block *) rblk;
#endif					/* DescriptorDouble */
      d.dword = D_Real;
      
      for (i=0;i<size;i++) {
	 if (i < ListLimit/2 || i >= size - ListLimit/2) {
#ifdef DescriptorDouble
	    d.vword.realval = ap->a[i];
#else					/* DescriptorDouble */
	    rblk->realval = ap->a[i];
#endif					/* DescriptorDouble */
	    outimage(f, &d , noimage+1);
	    if (i < size-1)
	       putc(',', f);
	    }
	 else if (i == ListLimit/2){
	    fprintf(f, "...,");
	    i=size-ListLimit/2-1;
	    }
	 } /* for*/
      }
   else if (BlkType(lp->listhead) ==T_Intarray){
      register struct b_intarray *ap = (struct b_intarray *) lp->listhead;

      for (i=0;i<size;i++) {
	 if (i < ListLimit/2 || i >= size - ListLimit/2) {
	    fprintf(f, "%ld" , (long int) (ap->a[i]));
	    if (i < size-1)
	       putc(',', f);
	    }
	 else if (i == ListLimit/2){
	    fprintf(f, "...,");
	    i=size-ListLimit/2-1;
	    }
	 } /* for */
      }
#endif						/* Arrays */

#if EBCDIC != 1
   putc(']', f);
#else					/* EBCDIC != 1 */
   putc('$', f);
   putc('>', f);
#endif					/* EBCDIC != 1 */

   }

/*
 * qsearch(key,base,nel,width,compar) - binary search
 *
 *  A binary search routine with arguments similar to qsort(3).
 *  Returns a pointer to the item matching "key", or NULL if none.
 *  Based on Bentley, CACM 28,7 (July, 1985), p. 676.
 */

char * qsearch (key, base, nel, width, compar)
char * key;
char * base;
int nel, width;
int (*compar)();
{
    int l, u, m, r;
    char * a;

    l = 0;
    u = nel - 1;
    while (l <= u) {
	m = (l + u) / 2;
	a = (char *) ((char *) base + width * m);
	r = compar (a, key);
	if (r < 0)
	    l = m + 1;
	else if (r > 0)
	    u = m - 1;
	else
	    return a;
    }
    return 0;
}

#if !COMPILER
/*
 * qtos - convert a qualified string named by *dp to a C-style string.
 *  Put the C-style string in sbuf if it will fit, otherwise put it
 *  in the string region.
 */

int qtos(dp, sbuf)
dptr dp;
char *sbuf;
   {
   register word slen;
   register char *c, *s;
   CURTSTATE();

   c = StrLoc(*dp);
   slen = StrLen(*dp)++;
   if (slen >= MaxCvtLen) {
      Protect(reserve(Strings, slen+1), return RunError);
      c = StrLoc(*dp);
      if (c + slen != strfree) {
         Protect(s = alcstr(c, slen), return RunError);
         }
      else
         s = c;
      StrLoc(*dp) = s;
      Protect(alcstr("",(word)1), return RunError);
      }
   else {
      StrLoc(*dp) = sbuf;
      for ( ; slen > 0; slen--)
         *sbuf++ = *c++;
      *sbuf = '\0';
      }
   return Succeeded;
   }
#endif					/* !COMPILER */

#ifdef CoExpr
/*
 * pushact - push actvtr on the activator stack of ce
 */
int pushact(struct b_coexpr *ce, struct b_coexpr *actvtr)
{
   struct astkblk *abp = ce->es_actstk, *nabp;
   struct actrec *arp;

#ifdef MultiProgram
   if (ce->program != actvtr->program) return Succeeded;
#endif					/* MultiProgram */
   /*
    * If the last activator is the same as this one, just increment
    *  its count.
    */
   if (abp->nactivators > 0) {
      arp = &abp->arec[abp->nactivators - 1];
      if (arp->activator == actvtr) {
         arp->acount++;
         return Succeeded;
         }
      }
   /*
    * This activator is different from the last one.  Push this activator
    *  on the stack, possibly adding another block.
    */
   if (abp->nactivators + 1 > ActStkBlkEnts) {
      Protect(nabp = alcactiv(), fatalerr(0,NULL));
      nabp->astk_nxt = abp;
      abp = nabp;
      }
   abp->nactivators++;
   arp = &abp->arec[abp->nactivators - 1];
   arp->acount = 1;
   arp->activator = actvtr;
   ce->es_actstk = abp;

   return Succeeded;
}
#endif					/* CoExpr */

/*
 * popact - pop the most recent activator from the activator stack of ce
 *  and return it.
 */
struct b_coexpr *popact(struct b_coexpr *ce)
{

#ifdef CoExpr

   struct astkblk *abp = ce->es_actstk, *oabp;
   struct actrec *arp;
   struct b_coexpr *actvtr;

#ifdef MultiProgram
   /*
    * If we are trying to pop a different program, we probably shouldn't.
   if (curpstate != ce->program) {
      syserr("multiprogram disaster in popact\n");
      }
    */
#endif

   /*
    * If the current stack block is empty, pop it, unless this would leave
    * the activation stack empty and a return to a parent program in progress.
    * In that case, setting the actstk to NULL would be counterproductive.
    */
   if ((abp->nactivators == 0)
#if !COMPILER
        && (abp->astk_nxt
#ifdef MultiProgram 
	|| !(curpstate->parent)
#endif					/* MultiProgram */
	)
#endif					/* COMPILER */
      ) {
      oabp = abp;
      ce->es_actstk = abp = abp->astk_nxt;
      free((pointer)oabp);
      }

   if (abp == NULL || abp->nactivators == 0) {
#ifdef MultiProgram
      if (curpstate->parent) {
	 return BlkD(curpstate->parent->K_main, Coexpr);
	 }
      else
#endif					/* MultiProgram */
      {

#ifdef Concurrent
       /*
        * if this is a thread it should exist
        * coclean calls pthread_exit() in this case.
    	*/
   	if (IS_TS_THREAD(ce->status)){
      	#ifdef CoClean
 	   coclean(ce);
        #endif				/* CoClean */
           }
#endif					/* Concurrent */
	 syserr("empty activator stack\n");
      }
   }

   /*
    * Find the activation record for the most recent co-expression.
    *  Decrement the activation count and if it is zero, pop that
    *  activation record and decrement the count of activators.
    */

   arp = &abp->arec[abp->nactivators - 1];
   actvtr = arp->activator;

/*
 *    FIXME: check if this is OK for a thread
 */
      if (--arp->acount == 0)
         abp->nactivators--;
      ce->es_actstk = abp;

   return actvtr;

#else					/* CoExpr */
    syserr("popact() called, but co-expressions not implemented");
#endif					/* CoExpr */

}

#ifdef CoExpr
/*
 * topact - return the most recent activator of ce.
 */
struct b_coexpr *topact(ce)
struct b_coexpr *ce;
{
   struct astkblk *abp = ce->es_actstk;
   CURTSTATE();

#ifdef MultiProgram 
   if (ce->program == curtstate->c->program){
#endif					/* MultiProgram */
      if (abp->nactivators == 0)
         abp = abp->astk_nxt;
      return abp->arec[abp->nactivators-1].activator;
#ifdef MultiProgram
       }
    else
       return abp->arec[0].activator;
#endif					/* MultiProgram */
}

#ifdef DeBugIconx
/*
 * dumpact - dump an activator stack
 */
void dumpact(ce)
struct b_coexpr *ce;
{
   struct astkblk *abp = ce->es_actstk;
   struct actrec *arp;
   int i;

   if (abp)
      fprintf(stderr, "Ce %ld ", (long)ce->id);
   while (abp) {
      fprintf(stderr, "--- Activation stack block (%x) --- nact = %d\n",
         abp, abp->nactivators);
      for (i = abp->nactivators; i >= 1; i--) {
         arp = &abp->arec[i-1];
         /*for (j = 1; j <= arp->acount; j++)*/
#ifdef Concurrent
         if (IS_TS_THREAD(arp->activator->status))
            fprintf(stderr, "thread_%ld(%d)\n", (long)(arp->activator->id),
            arp->acount);
   	 else
#endif					/* Concurrent */
            fprintf(stderr, "co-expression_%ld(%d)\n", (long)(arp->activator->id),
            arp->acount);
         }
      abp = abp->astk_nxt;
      }
}
#endif					/* DeBugIconx */
#endif					/* CoExpr */

#if !COMPILER

/*
 * findline - find the source line number associated with the ipc
 */
int findline(ipc_in)
word *ipc_in;
{
  return findloc(ipc_in) & 65535;
}
int findcol(ipc_in)
word *ipc_in;
{
  return findloc(ipc_in) >> 21; /*16 changed to 21  */
}

int findsyntax(ipc_in)
word *ipc_in;
{
  return ((findloc(ipc_in) >> 16) & 31);
}

int findloc(word *ipc_in)
{
   uword ipc_offset;
   uword size;
   struct ipc_line *base;

   static int two = 2;	/* some compilers generate bad code for division
			   by a constant that is a power of two ... */

   if (!InRange(code,ipc_in,endcode))
      return 0;
   ipc_offset = DiffPtrs((char *)ipc_in,(char *)code);
   base = ilines;
   size = DiffPtrs((char *)elines,(char *)ilines) / sizeof(struct ipc_line *);
   while (size > 1) {
      if (ipc_offset >= base[size / two].ipc_saved) {
         base = &base[size / two];
         size -= size / two;
         }
      else
         size = size / two;
      }
   /*
    * return the line component of the location (column is top 11 bits)
    */
   return (int)(base->line);
}

#ifdef MultiProgram
/*
 * A "loc" (for location) is a generalization of a line; the line number
 * table is now a table of loc's. At present these are ints containing
 * bits for <line,column,syntaxcode>.
 */

int findloc_p(word *ipc_in, struct progstate *prog)
{
   uword ipc_offset;
   uword size;
   struct ipc_line *base;

   if (!InRange(prog->Code,ipc_in,prog->Ecode))
      return 0;
   ipc_offset = DiffPtrs((char *)ipc_in,(char *)prog->Code);
   base = prog->Ilines;
   size = DiffPtrs((char *)prog->Elines,(char *)prog->Ilines) / sizeof(struct ipc_line *);
   while (size > 1) {
      if (ipc_offset >= base[size / 2].ipc_saved) {
         base = &base[size / 2];
         size -= size / 2;
         }
      else
         size = size / 2;
      }
   /*
    * return the line component of the location (column is top 11 bits)
    */
   return (int)(base->line);
}
int findline_p(word *ipc_in, struct progstate *p)
{
  return findloc_p(ipc_in, p) & 65535;
}
#endif					/* MultiProgram */

/*
 * findipc - find the first ipc associated with a source-code line number.
 */
int findipc(int line)
{
   uword size;
   struct ipc_line *base;

   static int two = 2;	/* some compilers generate bad code for division
			   by a constant that is a power of two ... */

   base = ilines;
   size = DiffPtrs((char *)elines,(char *)ilines) / sizeof(struct ipc_line *);
   while (size > 1) {
      if (line >= base[size / two].line) {
         base = &base[size / two];
         size -= size / two;
         }
      else
         size = size / two;
      }
   return base->ipc_saved;
}


/*
 * findoldipc - find the first ipc associated with a procedure frame level.
 */
word* findoldipc(ce, level)
struct b_coexpr *ce;
int level;
{
   struct pf_marker *fp;
   int i;
   CURTSTATE_AND_CE();

#ifdef MultiProgram
   if (BlkLoc(ce->program->tstate->K_current) != BlkLoc(k_current))
      fp = ce->es_pfp;
   else
      fp = pfp;

   i = ce->program->tstate->K_level;
   if (i<level) 
      return (word*)0;
#endif					/* MultiProgram */

   /* follow upwards, i levels */
   while (level) {
      if ((fp == NULL) || (fp->pf_ilevel == level))
         break;
      fp = fp->pf_pfp;
      --level;
      }

   if ((fp == NULL) || (level == 0))
      return (word*)0;
   else
      return fp->pf_ipc.opnd;
}

/*
 * hitsyntax - finds if the ipc that has an entry on the line table.
 * returns a syntax_code > 0 if it founds, otherwise it returns a zero.
 */
int hitsyntax(ipc_in)
word *ipc_in;
{

   int synt=0;
   uword ipc_offset;
   uword size;
   struct ipc_line *base;

   static int two = 2;	/* some compilers generate bad code for division
			   by a constant that is a power of two ... */

   if (!InRange(code,ipc_in,endcode))
      return 0;
   ipc_offset = DiffPtrs((char *)ipc_in,(char *)code);
   base = ilines;
   size = DiffPtrs((char *)elines,(char *)ilines) / sizeof(struct ipc_line *);
   while (size > 1) {
      if (ipc_offset >= base[size / two].ipc_saved) {
         base = &base[size / two];
         size -= size / two;
         }
      else
         size = size / two;
      }

   if (ipc_offset == base->ipc_saved)
       synt = ((int)base->line >> 16) & 31;
   return synt;
}

/*
 * findfile - find source file name associated with the ipc
 */
char *findfile(word *ipc_in)
{
   uword ipc_offset;
   struct ipc_fname *p;

   if (!InRange(code,ipc_in,endcode))
      return "?";
   ipc_offset = DiffPtrs((char *)ipc_in,(char *)code);
   for (p = efilenms - 1; p >= filenms; p--)
      if (ipc_offset >= p->ipc_saved)
         return strcons + p->fname;
   fprintf(stderr,"bad ipc/file name table\n");
   fflush(stderr);
   c_exit(EXIT_FAILURE);
   /*NOTREACHED*/
   return 0;  /* avoid compiler warning */
}

#ifdef MultiProgram
/*
 * findfile_p - find source file name associated with the ipc, in program prog
 * rather than in curpstate.
 */
char *findfile_p(word *ipc_in, struct progstate *prog)
{
   uword ipc_offset;
   struct ipc_fname *p;

   if (!InRange(prog->Code,ipc_in,prog->Ecode))
      return "?";
   ipc_offset = DiffPtrs((char *)ipc_in,(char *)prog->Code);
   for (p = prog->Efilenms - 1; p >= prog->Filenms; p--)
      if (ipc_offset >= p->ipc_saved)
         return prog->Strcons + p->fname;
   fprintf(stderr,"bad ipc/file name table\n");
   fflush(stderr);
   c_exit(EXIT_FAILURE);
   /*NOTREACHED*/
   return 0;  /* avoid compiler warning */
}
#endif					/* MultiProgram */
#endif					/* !COMPILER */

/*
 * doimage(c,q) - allocate character c in string space, with escape
 *  conventions if c is unprintable, '\', or equal to q.
 *  Returns number of characters allocated.
 */

int doimage(c, q)
int c, q;
   {
   static char cbuf[5];

   if (printable(c)) {

      /*
       * c is printable, but special case ", ', and \.
       */
      switch (c) {
         case '"':
            if (c != q) goto deflt;
            Protect(alcstr("\\\"", (word)(2)), return RunError);
            return 2;
         case '\'':
            if (c != q) goto deflt;
            Protect(alcstr("\\'", (word)(2)), return RunError);
            return 2;
         case '\\':
            Protect(alcstr("\\\\", (word)(2)), return RunError);
            return 2;
         default:
         deflt:
            cbuf[0] = c;
            Protect(alcstr(cbuf, (word)(1)), return RunError);
            return 1;
         }
      }

   /*
    * c is some sort of unprintable character.	If it is one of the common
    *  ones, produce a special representation for it, otherwise, produce
    *  its hex value.
    */
   switch (c) {
      case '\b':			/*	   backspace	*/
         Protect(alcstr("\\b", (word)(2)), return RunError);
         return 2;

#if !EBCDIC
      case '\177':			/*      delete	  */
#else					/* !EBCDIC */
      case '\x07':			/*      delete    */
#endif					/* !EBCDIC */

         Protect(alcstr("\\d", (word)(2)), return RunError);
         return 2;

#if !EBCDIC
      case '\33':			/*	    escape	 */
#else					/* !EBCDIC */
      case '\x27':			/*          escape       */
#endif					/* !EBCDIC */

         Protect(alcstr("\\e", (word)(2)), return RunError);
         return 2;
      case '\f':			/*	   form feed	*/
         Protect(alcstr("\\f", (word)(2)), return RunError);
         return 2;

#if EBCDIC == 1
      case '\x25':                      /* EBCDIC line feed */
         Protect(alcstr("\\l", (word)(2)), return RunError);
         return 2;
#endif					/* EBCDIC */

      case LineFeed:			/*	   new line	*/
         Protect(alcstr("\\n", (word)(2)), return RunError);
         return 2;
      case CarriageReturn:		/*	   return	*/
         Protect(alcstr("\\r", (word)(2)), return RunError);
         return 2;
      case '\t':			/*	   horizontal tab     */
         Protect(alcstr("\\t", (word)(2)), return RunError);
         return 2;
      case '\13':			/*	    vertical tab     */
         Protect(alcstr("\\v", (word)(2)), return RunError);
         return 2;
      default:				/*	  hex escape sequence  */
         sprintf(cbuf, "\\x%02x", ToAscii(c & 0xff));
         Protect(alcstr(cbuf, (word)(4)), return RunError);
         return 4;
      }
   }

#ifdef PatternType

/*
 * Construct a pattern image of pe.  Returns Succeeded or RunError.
 * peCount helps to know whether there is a previous thing on which
 * to concatenate. pe_index aids UDB in identifying current indices.
 * stop_index is the index at which an alternate halts its recursion (to
 * prevent duplication). prev_index stores the index of the last Arbno_S
 * so we know where to halt the image recursion (avoids infinite loops)
 */
int pattern_image(union block *pe, int prev_index, dptr result, 
                  int peCount, int pe_index, int stop_index)
   {
   tended union block * ep = pe;
   tended union block * r;
   tended struct descrip image;
   tended struct descrip right;
   tended struct descrip left;
   tended struct descrip arg;
   int index_image = 0; 
   if (ep != NULL) {

       if(Blk(ep, Pelem)->index == pe_index)
          index_image = 1; 

       switch (Blk(ep,Pelem)->pcode) {
          case PC_Alt: {
             int common_index = -1;
             arg = Blk(ep,Pelem)->parameter;
             r = (union block *)(BlkLoc(arg));
        
             /* Find the common index of the two sides (if there is something
              * that follow the left hand alternation)
              */ 

             if(Blk(ep, Pelem)->pthen != NULL)
                common_index = find_cindex(Blk(ep, Pelem)->pthen, r); 
        
             /* Traverse through the two sides until you get to the most
              * recent common indexed element (if it exists)
              */ 

             if ((pattern_image(Blk(ep,Pelem)->pthen, prev_index, &left,
				peCount, pe_index, common_index)) == RunError) 
	        return RunError;

             if ((pattern_image(r, prev_index, &right, peCount, pe_index, 
                                common_index)) == RunError)
	        return RunError;
        
             if(construct_image(&left, bi_pat(PI_ALT), &right, result) 
                                == RunError)
	        return RunError;

             construct_image(bi_pat(PI_FPAREN), result, 
                             bi_pat(PI_BPAREN), result);

             /* if the most recent common element existed traverse to that
              * on the left so we can include it in our print
              */ 

             if(common_index != -1){
                while(Blk(Blk(ep, Pelem)->pthen, Pelem)->index != common_index)
                   ep = Blk(ep,Pelem)->pthen;
                } 

             break;
             } 
          case PC_Any_MF   :
          case PC_Break_MF :
          case PC_NotAny_MF:
          case PC_NSpan_MF :
          case PC_Span_MF  : 
          case PC_Len_NMF  :
          case PC_Pos_NMF  :
          case PC_RPos_NMF :
          case PC_Tab_NMF  :
          case PC_RTab_NMF : {
	     if ((construct_funcimage(ep, PT_MF, Blk(ep, Pelem)->pcode, 
                            result, index_image)) == RunError) return RunError;
	     peCount++;
	     break;
             }
          case PC_Any_VF   :
          case PC_Break_VF :
          case PC_NotAny_VF:
          case PC_NSpan_VF :
          case PC_Span_VF  :
          case PC_Len_NF   : 
          case PC_Pos_NF   :
          case PC_RPos_NF  :
          case PC_Tab_NF   :
          case PC_RTab_NF  : {
	     if ((construct_funcimage(ep, PT_VF, Blk(ep, Pelem)->pcode, 
                            result, index_image)) == RunError) return RunError;
	     peCount++;
	     break;
	     }
          case PC_Any_VP   :
          case PC_Break_VP :
          case PC_NotAny_VP:
          case PC_NSpan_VP :
          case PC_Span_VP  :
          case PC_Len_NP   :
          case PC_Pos_NP   :
          case PC_RPos_NP  :
          case PC_Tab_NP   :
          case PC_RTab_NP  : {
	     if ((construct_funcimage(ep, PT_VP, Blk(ep, Pelem)->pcode, 
                            result, index_image)) == RunError) return RunError;
	     peCount++;
	     break;
             } 
          case PC_Any_CS   : 
          case PC_Break_CS :
          case PC_NotAny_CS:
          case PC_NSpan_CS : 
          case PC_Span_CS  :
          case PC_Len_Nat  :
          case PC_Pos_Nat  :
          case PC_RPos_Nat :
          case PC_Tab_Nat  :
          case PC_RTab_Nat : {
	     if ((construct_funcimage(ep, PT_EVAL, Blk(ep, Pelem)->pcode, 
                            result, index_image)) == RunError) return RunError;
	     peCount++;
	     break;
             } 
          case PC_BreakX_VF:
          case PC_BreakX_VP:
          case PC_BreakX_MF:
          case PC_BreakX_CS: {
             int image_case; 

             if (Blk(ep, Pelem)->pcode == PC_BreakX_VF)
                image_case = PT_VF;
             else if(Blk(ep, Pelem)->pcode == PC_BreakX_VP)
                image_case = PT_VP;
             else if(Blk(ep, Pelem)->pcode == PC_BreakX_MF)
                image_case = PT_MF;
             else /* if(Blk(ep, Pelem)->pcode == PC_BreakX_CS)  <-- must always be true */
                image_case = PT_EVAL; 

	     if (construct_funcimage(ep, image_case, Blk(ep, Pelem)->pcode, 
                             result, index_image) == RunError) return RunError;
	     peCount++;
	     ep = Blk(ep,Pelem)->pthen; 
             if(Blk(ep, Pelem)->index + 1 == pe_index) 
                construct_image(bi_pat(PI_FBRACE), result, 
                                bi_pat(PI_BBRACE), result);
	     break;
             }
          case PC_Arbno_S: {
             union block *arb;
             int last_index = Blk(ep, Pelem)->index; 

             if (Blk(ep, Pelem)->index == prev_index) {
		*result = *bi_pat(PI_EMPTY);
                return Succeeded;
		}
             arb = (union block *) BlkLoc(Blk(ep,Pelem)->parameter);
             if (pattern_image((union block *)arb, last_index, result, 0, pe_index, 
                               stop_index) == RunError) return RunError;
             if (construct_image(bi_pat(PF_Arbno), result, bi_pat(PI_BPAREN), 
                                 result) == RunError) return RunError;
             if (index_image == 1)
                if (construct_image(bi_pat(PI_FBRACE), result, bi_pat(PI_BBRACE)
                                    ,result) == RunError) return RunError;
	     peCount++;   
	     break;         
             }             
          case PC_Arbno_X: {
             union block *arb;
             struct b_pelem *arbParam; 
             arbParam = (struct b_pelem *)BlkLoc(Blk(ep,Pelem)->parameter);
             if (arbParam->pcode == PC_R_Enter) {
                arb = arbParam->pthen;
                if (pattern_image(arb, prev_index, result, 0, pe_index, stop_index) 
                    == RunError) return RunError;
                if (construct_image(bi_pat(PF_Arbno), result,
		   		bi_pat(PI_BPAREN), result) == RunError)
		   return RunError;
                if (index_image == 1)
                   if (construct_image(bi_pat(PI_FBRACE), result,
                                       bi_pat(PI_BBRACE), result) == RunError) 
                                       return RunError;
                }
             else {
                syserr("PC_Arbno_X whose param is not a PC_R_Enter");
                } 
	     peCount++;
	     break;
             } 
          case PC_String_VF:
          case PC_Pred_Func: {
             int pcode = Blk(ep, Pelem)->pcode; 
             arg = Blk(ep,Pelem)->parameter;
             if ((arg_image(arg, pcode, PT_VF, result)) == RunError) {
		return RunError;
		}
             if (index_image == 1)
                if (construct_image(bi_pat(PI_FBRACE), result, bi_pat(PI_BBRACE),
                                    result) == RunError) return RunError;
	     peCount++;
	     break;
             }
          case PC_String_MF:
          case PC_Pred_MF: {
             int pcode = Blk(ep, Pelem)->pcode; 
             arg = Blk(ep,Pelem)->parameter;
             if ((arg_image(arg, pcode, PT_MF, result)) == RunError) 
                return RunError;
             if (index_image == 1)
                if (construct_image(bi_pat(PI_FBRACE), result, bi_pat(PI_BBRACE)                                     ,result) == RunError) return RunError;
	     peCount++;
	     break;
             }
          case PC_Arb_X: {
             struct b_pelem * arbY;
             AsgnCStr(*result, "Arb()");
             arbY = BlkD(Blk(ep, Pelem)->parameter, Pelem);
             if(arbY->index == pe_index) index_image = 1; 
             if (index_image == 1)
                if (construct_image(bi_pat(PI_FBRACE), result, bi_pat(PI_BBRACE)
                                    ,result) == RunError) return RunError;
	     peCount++;
	     break;
	     }
          case PC_Assign_Imm: 
          case PC_Assign_OnM: {
	     /*
	      * consider Resolved patterns. do we need to check
	      * if parameter is a string, or a variable?
	      */
             tended struct descrip op;

             if (index_image == 1){
                if(Blk(ep, Pelem)->pcode == PC_Assign_OnM)
                   AsgnCStr(op, ") [-> ");
                else
                   AsgnCStr(op, ") [=> ");

                if ((construct_image(bi_pat(PI_EMPTY), &op, 
                           &(Blk(ep,Pelem)->parameter), result)) ==  RunError) 
                           return RunError;
                if ((construct_image(result, bi_pat(PI_BBRACE), 
                                     bi_pat(PI_EMPTY), result)) ==  RunError) 
                           return RunError;
                }
             else{

                if(Blk(ep, Pelem)->pcode == PC_Assign_OnM)
                   AsgnCStr(op, ") -> ");
                else 
                   AsgnCStr(op, ") => "); 
 
                if ((construct_image(&op, &(Blk(ep,Pelem)->parameter), 
                                     bi_pat(PI_EMPTY), result)) ==
		    RunError) return RunError;
                   }             
	     peCount++;
	     break;
             }
          case PC_Setcur: {
             AsgnCStr(image, " .> ");
             if ((construct_image(bi_pat(PI_EMPTY), &image,
				     &(Blk(ep,Pelem)->parameter), result)) ==
		 RunError) return RunError;
             if (index_image == 1)
                if (construct_image(bi_pat(PI_FBRACE), result, bi_pat(PI_BBRACE)
                                    ,result) == RunError) return RunError;
	     peCount++;
	     break;
	     }
          case PC_Bal    :
          case PC_Abort  :
          case PC_Fail   :
          case PC_Fence  :
          case PC_Rest   :
          case PC_Succeed: {
             if(Blk(ep, Pelem)->pcode == PC_Succeed)
                AsgnCStr(*result, "Succeed()");
             else if(Blk(ep, Pelem)->pcode == PC_Rest)
                AsgnCStr(*result, "Rem()");
             else if(Blk(ep, Pelem)->pcode == PC_Fence)
                AsgnCStr(*result, "Fence()");
             else if(Blk(ep, Pelem)->pcode == PC_Fail)
                AsgnCStr(*result, "Fail()"); 
             else if(Blk(ep, Pelem)->pcode == PC_Abort)
                AsgnCStr(*result, "Abort()");
             else if(Blk(ep, Pelem)->pcode == PC_Bal)
                AsgnCStr(*result, "Bal()"); 

             if (index_image == 1)
                if (construct_image(bi_pat(PI_FBRACE), result, bi_pat(PI_BBRACE)
                                    ,result) == RunError) return RunError;
	     peCount++;
	     break;
             }
          case PC_Rpat: {
             arg = Blk(ep,Pelem)->parameter;
             if ((arg_image(arg, -1, PT_VP, result)) == RunError) 
                return RunError;
             if (index_image == 1)
                if (construct_image(bi_pat(PI_FBRACE), result, bi_pat(PI_BBRACE)
                                    ,result) == RunError) return RunError;
	     peCount++;
	     break;
             }
          case PC_String: {
             arg = Blk(ep,Pelem)->parameter;
             if ((construct_image(bi_pat(PI_QUOTE), &arg,
				     bi_pat(PI_QUOTE), result)) == RunError)
		                        return RunError;
             if (index_image == 1)
                if (construct_image(bi_pat(PI_FBRACE), result, bi_pat(PI_BBRACE)
                                    ,result) == RunError) return RunError;
	     peCount++;
	     break;
             }
	  case PC_BreakX_X: {          
             *result = *bi_pat(PI_EMPTY);
	     break;
             }
          case PC_R_Enter: {
             *result = *bi_pat(PI_FPAREN);
	     break;
             }
          case PC_EOP: {
	    *result = emptystr;
	    break;
          }
          default: {
	    char buf[128];
	    if (Blk(ep,Pelem)->title != T_Pelem)
	      sprintf(buf, "pattern_image: bad pattern element, title %" LINTFRMT "d\n",
		      Blk(ep,Pelem)->title);
	    else
	      sprintf(buf, "pattern_image: bad pattern element code %" LINTFRMT "d\n",
		      Blk(ep,Pelem)->pcode);
	    syserr(buf);
	    }
         }
      }
   else {
      *result = *bi_pat(PI_EMPTY);
      return RunError;
      }

    /* This serves to add the implied concatenation. This checks
     * for ->, =>, .>, PC_EOP, Arbno_S's, Arbno_Y's because all of those
     * don't have implied concatenation here. Also peCount checks to see
     * if we are at the beginning of the pattern and if we are then it 
     * also ignores the implied concatenation. 
     */ 

   if ((ep = Blk(ep,Pelem)->pthen) != NULL) {

      if(Blk(ep, Pelem)->pcode == PC_Arbno_Y  || 
         Blk(ep, Pelem)->pcode == PC_EOP      ||
         Blk(ep, Pelem)->index == prev_index  ||
         Blk(ep, Pelem)->index == stop_index)
          return Succeeded;  

      if ((Blk(ep,Pelem)->pcode != PC_Assign_Imm &&
	   Blk(ep,Pelem)->pcode != PC_Assign_OnM &&
           Blk(ep,Pelem)->pcode != PC_Setcur) ||
	   ((Blk(ep,Pelem)->pcode == PC_R_Enter) && peCount != 0)) {
	  if ((StrLen(*result)>0) ||
	      ((Blk(ep,Pelem)->pcode == PC_R_Enter) && peCount != 0)){
	     if ((pattern_image(ep, prev_index, &image, peCount, pe_index, 
                  stop_index)) == RunError) return RunError;
             if(strcmp(StrLoc(*result), "(") != 0) 
	        return construct_image(result, bi_pat(PI_CONCAT), &image, result);
             else
 	        return construct_image(result, bi_pat(PI_EMPTY), &image, result);
	     }
	  else return pattern_image(ep,prev_index,result,peCount,pe_index, 
                                    stop_index);
          }
       else {
	  if ((pattern_image(ep, prev_index, &image, peCount, pe_index, 
               stop_index)) == RunError) return RunError;
          return construct_image(bi_pat(PI_EMPTY), result, &image, result);
          }
       }
   return Succeeded;
   }


/* Construct image for Pattern Function Parameters */ 

int arg_image(struct descrip arg, int pcode,  int type, dptr result)
   {
   tended struct descrip param = arg;  
   
   if(!is:list(param)) {
      if(type == PT_EVAL) {   /*Parameter is a string, cset, int */ 
         type_case param of { /* or unevaluated variable */ 
            string: {
               return construct_image(bi_pat(PI_QUOTE), &param,
				      bi_pat(PI_QUOTE), result);
               }
            cset: {
	       getimage(&param, result); 
               return construct_image(bi_pat(PI_EMPTY), result, 
	       	       bi_pat(PI_EMPTY), result);
               }
            integer: {
               getimage(&param, result); 
               return Succeeded;
               }
            default: {
	       syserr("unexpected type in a PT_EVAL");
            }
            }
	 }
      else {
         return construct_image(bi_pat(PI_BQUOTE), &param,  /*uneval var */
		         	 bi_pat(PI_BQUOTE), result);
         }
      }
   else {
      struct b_list *l = (struct b_list *) BlkLoc(param);
      tended struct b_lelem *le = (struct b_lelem *) l->listhead;
      int leCurrent = 1;

      if(!is:string(le->lslots[le->first]))
         get_name(&le->lslots[le->first], result);
      else   
	 AsgnCStr(*result, StrLoc(le->lslots[le->first]));

      switch(type) {
      case PT_VP: { /*Parameter image is unevaluated class member */ 
         do {
            if (construct_image(result, bi_pat(PI_PERIOD),
				&(le->lslots[leCurrent]), result) ==
		RunError) return RunError;
            leCurrent++;
	    }
	 while (leCurrent != le->nslots);
	 return construct_image(bi_pat(PI_BQUOTE), result, 
                                bi_pat(PI_BQUOTE), result);
	 }
       case PT_MF: { /*Parameter image is unevaluated method function */ 
         if (construct_image(result, bi_pat(PI_PERIOD),
			     &(le->lslots[leCurrent]), result) == RunError)
	    return RunError;
         leCurrent++;
         break;
         }
       case PT_VF: {
           /* Parameter image is unevaluated variable function */ 
         break;
         }
       default: {
	 syserr("unknown pcode in arg_image()");
         break;
         }
         }

	 /* There are no parameters for this function/method */ 

       if((type != PT_MF && (le->nslots == 1)) || 
         ((type == PT_MF) && (le->nslots == 2))) {

          if (construct_image(result, bi_pat(PI_FPAREN), 
                      bi_pat(PI_BPAREN), result) == RunError)
	     return RunError;

          /* if double back quote */ 

          if (pcode == PC_String_VF || pcode == PC_String_MF) 
             construct_image(bi_pat(PI_BQUOTE), result,
                             bi_pat(PI_BQUOTE), result); 

          return construct_image(bi_pat(PI_BQUOTE), result,
				 bi_pat(PI_BQUOTE), result);
	  }

        /* Attach front paren and first argument */ 
        /* If string then we are working with resolved copy */ 

       if (cnv:string(le->lslots[leCurrent], arg))
          AsgnCStr(arg, StrLoc(le->lslots[leCurrent])); 
       else if (is:variable(le->lslots[leCurrent]))
          get_name(&le->lslots[leCurrent], &arg);
       else return RunError; 

       if (construct_image(result, bi_pat(PI_FPAREN), &arg, result) ==
              RunError) return RunError;

       /*if (!is:string(le->lslots[leCurrent])) {
          get_name(&le->lslots[leCurrent], &arg);
	  if (construct_image(result, bi_pat(PI_FPAREN), &arg, result) ==
	      RunError)
	     return RunError;
	  }
       else {
	  if (construct_image(result, bi_pat(PI_FPAREN),
			      &(le->lslots[leCurrent]), result) == RunError)
	     return RunError;
	  }*/  

	  /* attach rest of parameters for uneval method/function */ 

       leCurrent++;
       if (((type != PT_MF) && (le->nslots != 2)) || 
           ((type == PT_MF) && (le->nslots != 3))) {
          do {
	     if(is:string(le->lslots[leCurrent]))
                AsgnCStr(arg, StrLoc(le->lslots[leCurrent]));
             else if(is:variable(le->lslots[leCurrent]))
	        get_name(&le->lslots[leCurrent], &arg);
             if((construct_image(result, bi_pat(PI_COMMA), &arg, 
	      		    result)) == RunError) return RunError;
             /*else {
		if (construct_image(result, bi_pat(PI_COMMA),
				&(le->lslots[leCurrent]), result) == RunError)
		return RunError;
		}*/ 
	     leCurrent++;
	     }
	  while (leCurrent != le->nslots);
          }
       if (construct_image(bi_pat(PI_EMPTY), result,
			       bi_pat(PI_BPAREN), result) == RunError)
	  return RunError;

       /* if double back quote */ 

       if (pcode == PC_String_VF || pcode == PC_String_MF) 
          construct_image(bi_pat(PI_BQUOTE), result,
                          bi_pat(PI_BQUOTE), result); 

       if (construct_image(bi_pat(PI_BQUOTE), result,
			   bi_pat(PI_BQUOTE), result) == RunError)
          return RunError;

       return Succeeded;
       }
   }

/*
 * bi_pat() - returns a pointer to a string descriptor pattern image for
 * built-in pattern functions and operators. This subsumes get_patimage()
 * and patimg_fns[].
 */
dptr bi_pat(int what)
   {
   static struct descrip patimag[NUM_PATIMGS];
   if (!StrLen(patimag[0])) {
      MUTEX_LOCKID(MTX_PATIMG_FUNCARR);
      if (!StrLen(patimag[0])) {
	 AsgnCStr(patimag[PF_Any], "Any(");
	 AsgnCStr(patimag[PF_Break], "Break(");
	 AsgnCStr(patimag[PF_BreakX], "Breakx(");
	 AsgnCStr(patimag[PF_NotAny], "NotAny(");
	 AsgnCStr(patimag[PF_NSpan], "NSpan(");
	 AsgnCStr(patimag[PF_Span], "Span(");
	 AsgnCStr(patimag[PF_Len], "Len(");
	 AsgnCStr(patimag[PF_Pos], "Pos(");
	 AsgnCStr(patimag[PF_RPos], "Rpos(");
	 AsgnCStr(patimag[PF_Tab], "Tab(");
	 AsgnCStr(patimag[PF_RTab], "Rtab(");
	 AsgnCStr(patimag[PF_Arbno], "Arbno(");
	 AsgnCStr(patimag[PI_EMPTY], "");
	 AsgnCStr(patimag[PI_FPAREN], "(");
	 AsgnCStr(patimag[PI_BPAREN], ")");
         AsgnCStr(patimag[PI_FBRACE], "[");
         AsgnCStr(patimag[PI_BBRACE], "]"); 
	 AsgnCStr(patimag[PI_BQUOTE], "`");
	 AsgnCStr(patimag[PI_QUOTE], "\"");
	 AsgnCStr(patimag[PI_SQUOTE], "'");
	 AsgnCStr(patimag[PI_COMMA], ", ");
	 AsgnCStr(patimag[PI_PERIOD], ".");
	 AsgnCStr(patimag[PI_CONCAT], " || ");
	 AsgnCStr(patimag[PI_ALT], " .| ");
	 AsgnCStr(patimag[PI_ONM], " -> ");
	 AsgnCStr(patimag[PI_IMM], " => ");
	 AsgnCStr(patimag[PI_SETCUR], " .> ");
	 }
      MUTEX_UNLOCKID(MTX_PATIMG_FUNCARR);
      }

   if ((what < 0) || (what > NUM_PATIMGS)) {
      syserr(" illegal patimg argument");
      return NULL;
      }
   return patimag + what;
   } 

/*
 * Construct a concatenation of three strings. Return Succeeded if OK.
 * Arguments MUST point at tended or static string data.
 * Result may refer to the same location as one of the parameters,
 */
int construct_image(dptr l, dptr s, dptr r, dptr result)
   {
   int i, slen = StrLen(*l) + StrLen(*s) + StrLen(*r);
   char *str, *p;
   Protect (reserve(Strings, slen), return RunError);
   p = str = alcstr(NULL, slen);
   for(i=0;i<StrLen(*l);i++) *p++ = StrLoc(*l)[i];
   for(i=0;i<StrLen(*s);i++) *p++ = StrLoc(*s)[i];
   for(i=0;i<StrLen(*r);i++) *p++ = StrLoc(*r)[i];
   MakeStr(str, slen, result);
   return Succeeded; 
   }

/*
 * Construct an image for a known built-in pattern function.
 */
static int construct_funcimage(union block *pe, int aicode,
				int bpcode, dptr result, int index)
{
   if (arg_image(Blk(pe,Pelem)->parameter, -1, aicode, result) != Succeeded)
      return RunError;

   switch (bpcode) {
      case PC_Any_MF:
      case PC_Any_VF:
      case PC_Any_VP:
      case PC_Any_CS: { 
         bpcode = PF_Any;
         break; 
         } 
      case PC_Break_MF:
      case PC_Break_VF:
      case PC_Break_VP:
      case PC_Break_CS:  { 
         bpcode = PF_Break;
         break; 
         } 
      case PC_NotAny_MF:
      case PC_NotAny_VF:
      case PC_NotAny_VP:
      case PC_NotAny_CS: { 
         bpcode = PF_NotAny;
         break; 
         } 
      case PC_BreakX_MF:
      case PC_BreakX_VF:
      case PC_BreakX_VP:
      case PC_BreakX_CS: { 
         bpcode = PF_BreakX;
         break; 
         } 
      case PC_Span_MF:
      case PC_Span_VF:
      case PC_Span_VP:
      case PC_Span_CS: { 
         bpcode = PF_Span;
         break; 
         } 
      case PC_NSpan_MF:
      case PC_NSpan_VF:
      case PC_NSpan_VP:
      case PC_NSpan_CS:  { 
         bpcode = PF_NSpan;
         break; 
         } 
      case PC_Len_NF:
      case PC_Len_NP:
      case PC_Len_NMF:
      case PC_Len_Nat:  { 
         bpcode = PF_Len;
         break; 
         } 
      case PC_Pos_NF:
      case PC_Pos_NP:
      case PC_Pos_NMF:
      case PC_Pos_Nat: { 
         bpcode = PF_Pos;
         break; 
         } 
      case PC_RPos_NF:
      case PC_RPos_NP:
      case PC_RPos_NMF:
      case PC_RPos_Nat:  { 
         bpcode = PF_RPos;
         break; 
         } 
      case PC_Tab_NF:
      case PC_Tab_NP:
      case PC_Tab_NMF:
      case PC_Tab_Nat: { 
         bpcode = PF_Tab;
         break; 
         } 
      case PC_RTab_NF:
      case PC_RTab_NP:
      case PC_RTab_NMF:
      case PC_RTab_Nat: { 
         bpcode = PF_RTab;
         break; 
         }
      default: {
         return RunError;
         }
      }
    
   if (construct_image(bi_pat(bpcode), result, bi_pat(PI_BPAREN), 
                   result) == RunError) return RunError;
   if (index == 1)
      return construct_image(bi_pat(PI_FBRACE), result, bi_pat(PI_BBRACE),
                             result);
   else
      return Succeeded; 
}

/* Alternations need to find the most recent index that is common
 * to determine where to cut off the image. The function below fills
 * an array with 1's if the index exists in the right pattern. If 
 * the same index exists in the left side then that is the first 
 * most common element
 */ 

int find_cindex(union block *l, union block *r)
{  
   int pat_size = -1;
   int * pat_array; 
   int i; 
   union block * tmp; 
 
   tmp = r; 
   while(Blk(tmp, Pelem) != NULL){
      if(pat_size < Blk(tmp, Pelem)->index)
         pat_size = Blk(tmp, Pelem)->index;
      tmp = Blk(tmp, Pelem)->pthen;
      }

   tmp = l;
   while(Blk(tmp, Pelem) != NULL){
      if(pat_size < Blk(tmp, Pelem)->index)
         pat_size = Blk(tmp, Pelem)->index;
      tmp = Blk(tmp, Pelem)->pthen; 
      }

   pat_array = (int *) malloc((pat_size + 1) * sizeof(int));

   for(i = 0; i < pat_size + 1; i++)
      pat_array[i] = 0;

   while(1){ 
      pat_array[Blk(r, Pelem)->index] = 1;
      if((r = Blk(r,Pelem)->pthen) == NULL) 
         break;  
      }  

   while(1){
      if(pat_array[Blk(l, Pelem)->index] == 1){
         free(pat_array); 
         return Blk(l, Pelem)->index;
         }
      if(Blk(l, Pelem)->pthen)
         l = Blk(l, Pelem)->pthen; 
      else break; 
      }

   free(pat_array); 
   return -1; 
}

#endif					/* PatternType */


/*
 * getimage(dp1,dp2) - return string image of object dp1 in dp2.
 */

int getimage(dp1,dp2)
dptr dp1, dp2;
   {
   register word len, outlen, rnlen;
   int i;
   tended char *s;
   tended struct descrip source = *dp1;    /* the source may move during gc */
   register union block *bp;
   char *type, *t, *csn;
   char sbuf[MaxCvtLen];
   FILE *fd;

   type_case source of {
      string: {
         /*
          * Form the image by putting a quote in the string space, calling
          *  doimage with each character in the string, and then putting
          *  a quote at then end. Note that doimage directly "writes"
          * (allocates) into the string region.  (Hence the indentation.)
	  *  This technique is used several times in this routine.
          */
         s = StrLoc(source);
         len = StrLen(source);
	 Protect (reserve(Strings, (len << 2) + 2), return RunError);
         Protect(t = alcstr("\"", (word)(1)), return RunError);
         StrLoc(*dp2) = t;
         StrLen(*dp2) = 1;

         while (len-- > 0)
            StrLen(*dp2) += doimage(*s++, '"');
         Protect(alcstr("\"", (word)(1)), return RunError);
         ++StrLen(*dp2);
         }

      null: {
         StrLoc(*dp2) = "&null";
         StrLen(*dp2) = 5;
         }

      integer: {
#ifdef LargeInts
         if (Type(source) == T_Lrgint) {
            word slen;
            word dlen;
            struct b_bignum *blk = BlkD(source, Lrgint);

            slen = blk->lsd - blk->msd;
            dlen = slen * NB * 0.3010299956639812 	/* 1 / log2(10) */
               + log((double)blk->digits[blk->msd]) * 0.4342944819032518 + 0.5;
							/* 1 / ln(10) */
            if (dlen >= MaxDigits) {
               sprintf(sbuf,"integer(~10^%ld)",(long)dlen);
	       len = strlen(sbuf);
               Protect(StrLoc(*dp2) = alcstr(sbuf,len), return RunError);


               StrLen(*dp2) = len;
               }
	    else bigtos(&source,dp2);
	    }
         else
            cnv: string(source, *dp2);
#else					/* LargeInts */
         cnv:string(source, *dp2);
#endif					/* LargeInts */
	 }

      real: {
         cnv:string(source, *dp2);
         }

      cset: {
         /*
	  * Check for the value of a predefined cset; use keyword name if found.
	  */
	 if ((csn = csname(dp1)) != NULL) {
	    StrLoc(*dp2) = csn;
	    StrLen(*dp2) = strlen(csn);
	    return Succeeded;
	    }
	 /*
	  * Otherwise, describe it in terms of the character membership.
	  */

	 i = BlkD(source,Cset)->size;
	 if (i < 0)
	    i = cssize(&source);
	 i = (i << 2) + 2;
	 if (i > 730) i = 730;
	 Protect (reserve(Strings, i), return RunError);

         Protect(t = alcstr("'", (word)(1)), return RunError);
         StrLoc(*dp2) = t;
         StrLen(*dp2) = 1;
         for (i = 0; i < 256; ++i)
            if (Testb(i, source))
               StrLen(*dp2) += doimage((char)i, '\'');
         Protect(alcstr("'", (word)(1)), return RunError);
         ++StrLen(*dp2);
         }

      file: {
         /*
          * Check for distinguished files by looking at the address of
          *  of the object to image.  If one is found, make a string
          *  naming it and return.
          */
         if ((fd = BlkD(source,File)->fd.fp) == stdin) {
            StrLen(*dp2) = 6;
            StrLoc(*dp2) = "&input";
            }
         else if (fd == stdout) {
            StrLen(*dp2) = 7;
            StrLoc(*dp2) = "&output";
            }
         else if (fd == stderr) {
            StrLen(*dp2) = 7;
            StrLoc(*dp2) = "&errout";
            }
         else {
            /*
             * The file is not a standard one; form a string of the form
             *	file(nm) where nm is the argument originally given to open.
             */
             char namebuf[100];		/* scratch space */
#ifdef Graphics
	    if (BlkD(source,File)->status & Fs_Window) {
	       if ((BlkLoc(source)->File.status != Fs_Window) &&
		  (s = BlkLoc(source)->File.fd.wb->window->windowlabel)){
	          len = strlen(s);
                  Protect (reserve(Strings, (len << 2) + 16), return RunError);
	          sprintf(sbuf, "window_%d:%d(", 
		       BlkLoc(source)->File.fd.wb->window->serial,
		       BlkLoc(source)->File.fd.wb->context->serial
		       );
		  }
		else {
                  len = 0;
                  Protect (reserve(Strings, (len << 2) + 16), return RunError);
	          sprintf(sbuf, "window_-1:-1(");
                  }
	       Protect(t = alcstr(sbuf, (word)(strlen(sbuf))), return RunError);
	       StrLoc(*dp2) = t;
	       StrLen(*dp2) = strlen(sbuf);
	       }
	    else {
#endif					/* Graphics */
#ifdef PosixFns
               if (BlkD(source,File)->status & Fs_Socket) {
                   s = namebuf;
                   len = sock_name(BlkLoc(source)->File.fd.fd,
                                 StrLoc(BlkLoc(source)->File.fname),
                                 namebuf, sizeof(namebuf));
               }
               else {
#endif 					/* PosixFns */
               s = StrLoc(BlkD(source,File)->fname);
               len = StrLen(BlkD(source,File)->fname);
#ifdef PosixFns
               }
#endif 					/* PosixFns */
               Protect (reserve(Strings, (len << 2) + 12), return RunError);
	       Protect(t = alcstr("file(", (word)(5)), return RunError);
	       StrLoc(*dp2) = t;
	       StrLen(*dp2) = 5;
#ifdef Graphics
	     }
#endif					/* Graphics */
            while (len-- > 0)
               StrLen(*dp2) += doimage(*s++, '\0');
            Protect(alcstr(")", (word)(1)), return RunError);
            ++StrLen(*dp2);
            }
         }

      proc: {
         /*
          * Produce one of:
          *  "procedure name"
          *  "function name"
          *  "record constructor name"
	  *  "class constructor name"
          *
          * Note that the number of dynamic locals is used to determine
          *  what type of "procedure" is at hand.
          */
         len = StrLen(BlkD(source,Proc)->pname);
         s = StrLoc(BlkLoc(source)->Proc.pname);
	 Protect (reserve(Strings, len + 22), return RunError);
         switch ((int)BlkLoc(source)->Proc.ndynam) {
            default:  type = "procedure "; outlen = 10; break;
            case -1:  type = "function "; outlen = 9; break;
            case -2:  type = "record constructor "; outlen = 19; break;
	    case -3:  type = "class constructor "; outlen = 18; break;
            }
         Protect(t = alcstr(type, outlen), return RunError);
         StrLoc(*dp2) = t;
         Protect(alcstr(s, len), return RunError);
         StrLen(*dp2) = len + outlen;
         }

      list: {
         /*
          * Produce:
          *  "list_m(n)"
          * where n is the current size of the list.
          */
         bp = BlkLoc(*dp1);
         sprintf(sbuf, "list_%ld(%ld)", (long)Blk(bp,List)->id,
		 (long)Blk(bp,List)->size);
         len = strlen(sbuf);
         Protect(t = alcstr(sbuf, len), return RunError);
         StrLoc(*dp2) = t;
         StrLen(*dp2) = len;
         }

      table: {
         /*
          * Produce:
          *  "table_m(n)"
          * where n is the size of the table.
          */
         bp = BlkLoc(*dp1);
         sprintf(sbuf, "table_%ld(%ld)", (long)Blk(bp,Table)->id,
            (long)Blk(bp,Table)->size);
         len = strlen(sbuf);
         Protect(t = alcstr(sbuf, len), return RunError);
         StrLoc(*dp2) = t;
         StrLen(*dp2) = len;
         }

      set: {
         /*
          * Produce "set_m(n)" where n is size of the set.
          */
         bp = BlkLoc(*dp1);
         sprintf(sbuf, "set_%ld(%ld)", (long)Blk(bp,Set)->id,
		 (long)Blk(bp,Set)->size);
         len = strlen(sbuf);
         Protect(t = alcstr(sbuf,len), return RunError);
         StrLoc(*dp2) = t;
         StrLen(*dp2) = len;
         }

      record: {
	 long size;
         /*
          * Produce:
          *  "record name_m(n)"	-- under construction
          * where n is the number of fields.
          */
         bp = BlkLoc(*dp1);
	 size = (long)bp->Record.recdesc->Proc.nfields;
	 rnlen = StrLen(Blk(Blk(bp,Record)->recdesc,Proc)->recname);
	 sprintf(sbuf, "_%ld(%ld)", (long)bp->Record.id, size);
	 len = strlen(sbuf);
	 Protect (reserve(Strings, 7 + len + rnlen), return RunError);
	 bp = BlkLoc(*dp1);		/* refresh pointer */
	 /*
	  * If we have an object, its size is -2 for __s and __m fields.
	  * Also, drop the tedious "__state" portion of its recname.
	  */
	 if (Blk(Blk(bp,Record)->recdesc, Proc)->ndynam == -3) {
	    char *los;			/* location of "__state" in recname */
	    sprintf(sbuf, "_%ld(%ld)", (long)bp->Record.id, size-2);
	    len= strlen(sbuf);
	    los= strstr(StrLoc(Blk(bp,Record)->recdesc->Proc.recname),"__state");
	    if (los == NULL)
	       syserr("no __state in object's classname");
	    rnlen = los - StrLoc(Blk(bp,Record)->recdesc->Proc.recname);
	    Protect(t = alcstr("object ", (word)(7)), return RunError);
	    }
	 else {
	    Protect(t = alcstr("record ", (word)(7)), return RunError);
	    }
	 StrLoc(*dp2) = t;
	 StrLen(*dp2) = 7;
         Protect(alcstr(StrLoc(Blk(bp,Record)->recdesc->Proc.recname),rnlen),
	            return RunError);
         StrLen(*dp2) += rnlen;
         Protect(alcstr(sbuf, len), return RunError);
         StrLen(*dp2) += len;
         }

      coexpr: {
         /*
          * Produce:
          *  "co-expression_m (n)"
          *  where m is the number of the co-expressions and n is the
          *  number of results that have been produced.
          */
	 word numchar;

         sprintf(sbuf, "_%ld(%ld)", (long)BlkD(source,Coexpr)->id,
            (long)BlkLoc(source)->Coexpr.size);
         len = strlen(sbuf);
#ifdef Concurrent
         if (IS_TS_THREAD(BlkLoc(source)->Coexpr.status)){
	    numchar = 6;
	    Protect (reserve(Strings, len + numchar), return RunError);
            Protect(t = alcstr("thread", numchar), return RunError);
	    }
   	 else
#endif					/* Concurrent */
            {
	    numchar = 13;
	    Protect (reserve(Strings, len + numchar), return RunError);
            Protect(t = alcstr("co-expression", numchar), return RunError);
	    }

         StrLoc(*dp2) = t;
         Protect(alcstr(sbuf, len), return RunError);
         StrLen(*dp2) = numchar + len;
         }

      tvmonitored:{
         /* 
          * foreign monitored tapped variable 
          */
         Protect(t = alcstr("Trapped_monitored", (word)(17)), return RunError);
         StrLoc(*dp2) = t;
         StrLen(*dp2) = 17;
         } 

#ifdef PatternType		
      pattern: {
         /*
          * Produce:
          *  "pattern_m(n)"
          * where n is the current size of the pattern.
          */
	 register union block *ep;
	 tended struct descrip pimage;
         bp = BlkLoc(*dp1);
	 ep = Blk(bp,Pattern)->pe;
	 
         if (pattern_image(ep, -1, &pimage, 0, -1, -1) == RunError)
	    ReturnErrVal(166, *dp1, RunError);
         t = alcstr(NULL, StrLen(pimage) + 29);
	 sprintf(t, "pattern_%ld(%ld) = ", (long)(Blk(bp,Pattern)->id),
	 	        (long)(Blk(ep,Pelem)->index));
	 len = strlen(t);
	 { int i;
	  for(i=0;i<StrLen(pimage);i++) t[len+i] = StrLoc(pimage)[i];
         }
	 len += StrLen(pimage);
         StrLoc(*dp2) = t;
         StrLen(*dp2) = len;
         }
#endif					/* PatternType */

      default:
#ifdef Arrays
	 if (Type(*dp1) == T_Intarray) {
	    sprintf(sbuf, "intarray(?)");
	    len = strlen(sbuf);
	    Protect(t = alcstr(sbuf, len), return RunError);
	    StrLoc(*dp2) = t;
	    StrLen(*dp2) = len;
	    }
	 else
#endif					/* Arrays */
        if (Type(*dp1) == T_External) {
           /*
            * For now, just produce "external(n)". 
            */
           sprintf(sbuf, "external(%ld)",(long)BlkD(*dp1,External)->blksize);
           len = strlen(sbuf);
           Protect(t = alcstr(sbuf, len), return RunError);
           StrLoc(*dp2) = t;
           StrLen(*dp2) = len;
           }
         else {
	    ReturnErrVal(123, source, RunError);
            }
      }
   return Succeeded;
   }

/*
 * csname(dp) -- return the name of a predefined cset matching dp.
 */
static char *csname(dp)
dptr dp;
   {
   register int n;

   n = BlkD(*dp,Cset)->size;
   if (n < 0) 
      n = cssize(dp);

#if EBCDIC != 1
   /*
    * Check for a cset we recognize using a hardwired decision tree.
    *  In ASCII, each of &lcase/&ucase/&digits are complete within 32 bits.
    */
   if (n == 52) {
      if ((Cset32('a',*dp) & Cset32('A',*dp)) == (0377777777l << CsetOff('a')))
	 return ("&letters");
      }
   else if (n < 52) {
      if (n == 26) {
	 if (Cset32('a',*dp) == (0377777777l << CsetOff('a')))
	    return ("&lcase");
	 else if (Cset32('A',*dp) == (0377777777l << CsetOff('A')))
	    return ("&ucase");
	 }
      else if (n == 10 && *CsetPtr('0',*dp) == (01777 << CsetOff('0')))
	 return ("&digits");
      }
   else /* n > 52 */ {
      if (n == 256)
	 return "&cset";
      else if (n == 128 && ~0 ==
	 (Cset32(0,*dp) & Cset32(32,*dp) & Cset32(64,*dp) & Cset32(96,*dp)))
	    return "&ascii";
      }
   return NULL;
#else						/* EBCDIC != 1 */
   /*
    * Check for a cset we recognize using a hardwired decision tree.
    *  In EBCDIC, the neither &lcase nor &ucase is contiguous.
    *  #%#% THIS CODE HAS NOT YET BEEN TESTED.
    */
   if (n == 52) {
      if ((Cset32(0x80,*dp) & Cset32(0xC0,*dp)) == 0x03FE03FE
         && Cset32(0xA0,*dp) & Cset32(0xE0,*dp)) == 0x03FC)
	    return ("&letters");
      }
   else if (n < 52) {
      if (n == 26) {
	 if (Cset32(0x80,*dp) == 0x03FE03FE && Cset32(0xA0,*dp) == 0x03FC)
	    return ("&lcase");
	 else if (Cset32(0xC0,*dp) == 0x03FE03FE && Cset32(0xE0,*dp) == 0x03FC)
	    return ("&ucase");
	 }
      else if (n == 10 && *CsetPtr('0',*dp) == (01777 << CsetOff('0')))
 return ("&digits");
      }
   else /* n > 52 */ {
      if (n == 256)
	 return "&cset";
      else if (n == 128) {
         int i;
         for (i = 0; i < CsetSize; i++)
            if (k_ascii.bits[i] != BlkLoc(*dp)->Cset.bits[i])
               break;
         if (i >= CsetSize) return "&ascii";
         }
      }
   return NULL;
#endif						/* EBCDIC != 1 */
   }

/*
 * cssize(dp) - calculate cset size, store it, and return it
 */
int cssize(dp)
dptr dp;
{
   register int i, n;
   register unsigned int w, *wp;
   register struct b_cset *cs;

   cs = BlkD(*dp,Cset);
   wp = (unsigned int *)cs->bits;
   n = 0;
   for (i = CsetSize; --i >= 0; )
      for (w = *wp++; w != 0; w >>= 1)
	 n += (w & 1);
   cs->size = n;
   return n;
}

/*
 * printable(c) -- is c a "printable" character?
 */

int printable(c)
int c;
   {

/*
 * The following code is operating-system dependent [@rmisc.01].
 *  Determine if a character is "printable".
 */

#if PORT
   return isprint(c);
Deliberate Syntax Error
#endif					/* PORT */

#if MSDOS || UNIX || VMS
   return (isascii(c) && isprint(c));
#endif					/* MSDOS ... */

#if MACINTOSH
   return isprint(c);
#endif					/* MACINTOSH */

#if MVS || VM
   return isprint(c);
#endif                                  /* MVS || VM */

/*
 * End of operating-system specific code.
 */
   }

#ifndef AsmOver
/*
 * add, sub, mul, neg with overflow check
 * all return 1 if ok, 0 if would overflow
 */

/*
 *  Note: on some systems an improvement in performance can be obtained by
 *  replacing the C functions that follow by checks written in assembly
 *  language.  To do so, add #define AsmOver to ../h/define.h.  If your
 *  C compiler supports the asm directive, put the new code at the end
 *  of this section under control of #else.  Otherwise put it a separate
 *  file.
 */

word add(word a, word b, int *over_flowp)
{
   if ((a ^ b) >= 0 && (a >= 0 ? b > MaxLong - a : b < MinLong - a)) {
      *over_flowp = 1;
      return 0;
      }
   else {
     *over_flowp = 0;
     return a + b;
     }
}

word sub(word a, word b, int *over_flowp)
{
   if ((a ^ b) < 0 && (a >= 0 ? b < a - MaxLong : b > a - MinLong)) {
      *over_flowp = 1;
      return 0;
      }
   else {
      *over_flowp = 0;
      return a - b;
      }
}

word mul(word a, word b, int *over_flowp)
{
   if (b != 0) {
      if ((a ^ b) >= 0) {
	 if (a >= 0 ? a > MaxLong / b : a < MaxLong / b) {
            *over_flowp = 1;
	    return 0;
            }
	 }
      else if (b != -1 && (a >= 0 ? a > MinLong / b : a < MinLong / b)) {
         *over_flowp = 1;
	 return 0;
         }
      }

   *over_flowp = 0;
   return a * b;
}

/* MinLong / -1 overflows; need div3 too */

word mod3(word a, word b, int *over_flowp)
{
   word retval;

   switch ( b )
   {
      case 0:
	 *over_flowp = 1; /* Not really an overflow, but definitely an error */
	 return 0;

      case MinLong:
	 /* Handle this separately, since -MinLong can overflow */
	 retval = ( a > MinLong ) ? a : 0;
	 break;

      default:
	 /* First, we make b positive */
      	 if ( b < 0 ) b = -b;	

	 /* Make sure retval should have the same sign as 'a' */
	 retval = a % b;
	 if ( ( a < 0 ) && ( retval > 0 ) )
	    retval -= b;
	 break;
      }

   *over_flowp = 0;
   return retval;
}

word div3(word a, word b, int *over_flowp)
{
   if ( ( b == 0 ) ||	/* Not really an overflow, but definitely an error */
        ( b == -1 && a == MinLong ) ) {
      *over_flowp = 1;
      return 0;
      }

   *over_flowp = 0;
   return ( a - mod3 ( a, b, over_flowp) ) / b;
}

/* MinLong / -1 overflows; need div3 too */

word neg(word a, int *over_flowp)
{
   if (a == MinLong) {
      *over_flowp = 1;
      return 0;
      }
   *over_flowp = 0;
   return -a;
}
#endif					/* AsmOver */

#if COMPILER
/*
 * sig_rsm - standard success continuation that just signals resumption.
 */

int sig_rsm()
   {
   return A_Resume;
   }

/*
 * cmd_line - convert command line arguments into a list of strings.
 */
void cmd_line(argc, argv, rslt)
int argc;
char **argv;
dptr rslt;
   {
   tended struct b_list *hp;
   register word i;
   register struct b_lelem *bp;  /* need not be tended */

   /*
    * Skip the program name.
    */
   --argc;
   ++argv;

   /*
    * Allocate the list and a list block.
    */
   Protect(hp = alclist_raw(argc, argc), fatalerr(0,NULL));
   bp = Blk(hp->listhead,Lelem);

   /*
    * Copy the arguments into the list
    */
   for (i = 0; i < argc; ++i) {
      StrLen(bp->lslots[i]) = strlen(argv[i]);
      StrLoc(bp->lslots[i]) = argv[i];
      }

   rslt->dword = D_List;
   rslt->vword.bptr = (union block *) hp;
   }

/*
 * varargs - construct list for use in procedures with variable length
 *  argument list.
 */
void varargs(argp, nargs, rslt)
dptr argp;
int nargs;
dptr rslt;
   {
   tended struct b_list *hp;
   tended struct b_lelem *bp; /* deref() can alloc, needs to be tended. */
   register word i;

   /*
    * Allocate the list and a list block.
    */
   Protect(hp = alclist(nargs, nargs), fatalerr(0,NULL));
   bp = Blk(hp->listhead, Lelem);

   /*
    * Copy the arguments into the list
    */
   for (i = 0; i < nargs; i++)
      deref(&argp[i], &bp->lslots[i]);

   rslt->dword = D_List;
   rslt->vword.bptr = (union block *) hp;
   }
#endif					/* COMPILER */

/*
 * retderef - Dereference local variables and substrings of local
 *  string-valued variables. This is used for return, suspend, and
 *  transmitting values across co-expression context switches.
 */
void retderef(valp, low, high)
dptr valp;
word *low;
word *high;
   {
   struct b_tvsubs *tvb;
   word *loc;

   if (((*valp).dword & F_Typecode) && (Type(*valp) == T_Tvsubs)) {
      tvb = BlkD(*valp, Tvsubs);
      loc = (word *)VarLoc(tvb->ssvar);
      }
   else
      loc = (word *)VarLoc(*valp) + Offset(*valp);
   if (InRange(low, loc, high))
      deref(valp, valp);
   }

#if MSDOS
#ifndef NTGCC
int strcasecmp(char *s1, char *s2)
{
   while (*s1 && *s2) {
      if (tolower(*s1) != tolower(*s2))
         return tolower(*s1) - tolower(*s2);
      s1++; s2++;
      }
   return tolower(*s1) - tolower(*s2);
}

int strncasecmp(char *s1, char *s2, int n)
{
   int i, j;
   for(i=0;i<n;i++) {
      j = tolower(s1[i]) - tolower(s2[i]);
      if (j) return j;
      if (s1[i] == '\0') return 0; /* terminate if both at end-of-string */
      }
   return 0;
}
#endif					/* NTGCC */
#endif					/* MSDOS */
