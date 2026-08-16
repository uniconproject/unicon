/*
 * File: oref.r
 *  Contents: bang, random, sect, subsc
 */

"!x - generate successive values from object x."

operator{*} ! bang(underef x -> dx)
   declare {
      register C_integer i, j;
      tended union block *ep;
      struct hgstate state;
      char ch;
      }

   if is:variable(x) && is:string(dx) then {
      abstract {
         return new tvsubs(type(x))
         }
      inline {
         /*
          * A nonconverted string from a variable is being banged.
          * On a tagged Unicon string each trap is one codepoint (full
          * UTF-8 width), matching s[i]. Untagged strings stay one byte
          * per trap. Re-check the tag after each assignment: replacing
          * a character can tag or untag the result.
          */
         for (i = 1; ; i++) {
            word n, bpos, w;
            unsigned char *bytes;

            if (IsUniQual(dx)) {
               if (CpCount(dx) != CpCountSentinel)
                  n = CpCount(dx);
               else
                  uq_scan((unsigned char *)StrLoc(dx), StrLen(dx), &n);
               if (i > n)
                  break;
               bytes = (unsigned char *)StrLoc(dx);
               bpos = uq_seek_cp(bytes, i - 1);
               w = uq_lead_width(bytes[bpos]);
               suspend tvsubs(&x, bpos + 1, w);
               }
            else {
               if (i > StrLen(dx))
                  break;
               suspend tvsubs(&x, i, (word)1);
               }
            deref(&x, &dx);
            if (!is:string(dx))
               runerr(103, dx);
            }
         }
      }
   else type_case dx of {
      integer: {
         abstract {
            return integer
            }
         inline {
            C_integer from=1, to;
            if (!cnv:C_integer(dx, to)) fail;
            if (to < 1) fail;
            for ( ; from <= to; from += 1) {
               suspend C_integer from;
               }
            }
         }
      list: {
         abstract {
            return type(dx).lst_elem
            }
         inline {
#if E_Lsub
            word xi = 0;
#endif                                  /* E_Lsub */

           /* static struct threadstate *curtstate;
            if (!curtstate) curtstate=&roottstate;*/

            EVValD(&dx, E_Lbang);

#ifdef Arrays
            ep = BlkD(dx,List)->listhead;
            if (BlkType(ep)==T_Realarray){
               tended struct b_realarray *ap =  ( struct b_realarray * ) ep;
               word asize = BlkD(dx,List)->size;

               for (i=0;i<asize;i++){
#if E_Lsub
                  ++xi;
                  EVVal(xi, E_Lsub);
#endif                                  /* E_Lsub */

                  suspend struct_var(&ap->a[i], ap);
                  }
               }
            else if ( BlkType(ep)==T_Intarray){
               tended struct b_intarray *ap =  ( struct b_intarray * ) ep;
               word asize = BlkD(dx,List)->size;

               for (i=0;i<asize;i++){
#if E_Lsub
                  ++xi;
                  EVVal(xi, E_Lsub);
#endif                                  /* E_Lsub */

                  suspend struct_var(&ap->a[i], ap);
                  }
               }
            else{
#endif                                  /* Arrays */


            /*
             * x is a list.  Chain through each list element block and for
             * each one, suspend with a variable pointing to each
             * element contained in the block.
             */
               for (ep = BlkD(dx,List)->listhead;
                  BlkType(ep) == T_Lelem;
                  ep = Blk(ep,Lelem)->listnext){
                  for (i = 0; i < Blk(ep,Lelem)->nused; i++) {
                     j = ep->Lelem.first + i;
                     if (j >= ep->Lelem.nslots)
                        j -= ep->Lelem.nslots;

#if E_Lsub
                     ++xi;
                     EVVal(xi, E_Lsub);
#endif                                  /* E_Lsub */

                     suspend struct_var(&ep->Lelem.lslots[j], ep);
                     }
                  }
#ifdef Arrays
               }
#endif                                  /* Arrays */
            }
         }

      file: {
         abstract {
            return string
               }
         body {
            FILE *fd;
            char sbuf[MaxCvtLen];
            register char *sptr;
            register C_integer slen, rlen;
            word status;
#ifdef Dbm
            datum key;
#endif                                  /* Dbm */
#if ConcurrentCOMPILER && defined(Graphics)
            CURTSTATE();
#endif                                  /* ConcurrentCOMPILER */

            /*
             * x is a file.  Read the next line into the string space
             *  and suspend the newly allocated string.
             */
            status = BlkLoc(dx)->File.status;

#ifdef PosixFns
#if HAVE_LIBSSL
            /*
             * Crypto handles are not line streams; fd.fp is the CryptoFile.
             */
            if (status & Fs_Crypto)
               fail;
#endif                                  /* HAVE_LIBSSL */
#if HAVE_LIBSSH
            /*
             * SSH sessions without a channel are not line streams.
             * Channels carry Fs_Socket and generate input lines below.
             */
            if ((status & Fs_SSH) && !(status & Fs_Socket))
               fail;
#endif                                  /* HAVE_LIBSSH */
#endif                                  /* PosixFns */

            fd = BlkD(dx,File)->fd.fp;

            if ((status & Fs_Read) == 0)
               runerr(212, dx);

            if (status & Fs_Writing) {
               fseek(fd, 0L, SEEK_CUR);
               BlkLoc(dx)->File.status &= ~Fs_Writing;
               }
            BlkLoc(dx)->File.status |= Fs_Reading;
            status = BlkLoc(dx)->File.status;

#ifdef PosixFns
            if (status & Fs_Socket) {
              for (;;) {
                SetStrLen(result, 0);
                do {
                  DEC_NARTHREADS;
                  if ((slen = sock_getstrg(sbuf, MaxReadStr, &dx)) == -1) {
                    /* EOF is no error */
                    INC_NARTHREADS_CONTROLLED;
                    fail;
                  }
                  INC_NARTHREADS_CONTROLLED;
                  if (slen == -3) {
                    /* sock_getstrg sets errornumber/text */
                    fail;
                  }
                  if (slen == 1 && *sbuf == '\n')
                    break;
                  rlen = slen < 0 ? (word)MaxReadStr : slen;

                  Protect(reserve(Strings, rlen), runerr(0));
                  if (StrLen(result) > 0 && !InRange(strbase,StrLoc(result),strfree)) {
                    Protect(reserve(Strings, StrLen(result)+rlen), runerr(0));
                    Protect((StrLoc(result) = alcstr(StrLoc(result),StrLen(result))), runerr(0));
                  }

                  Protect(sptr = alcstr(sbuf,rlen), runerr(0));
                  if (StrLen(result) == 0)
                    StrLoc(result) = sptr;
                  SetStrLen(result, StrLen(result) + (rlen));
                  if (StrLoc(result) [ StrLen(result) - 1 ] == '\n') {
                    SetStrLen(result, StrLen(result) - 1); break;
                  }
                  else { /* no newline to trim; EOF? */
                  }
                }
                while (slen > 0);
                suspend result;
              }
            }
#endif                  /* PosixFns */

#ifdef Messaging
            if (status & Fs_Messaging) {
               struct MFile *mf = (struct MFile *)fd;
               if (!MFIN(mf, READING)) {
                  Mstartreading(mf);
                  }
               if (strcmp(mf->tp->uri.scheme, "pop") == 0) {
                  char buf[100];
                  Tprequest_t req = {0, NULL, 0};
                  unsigned msgnum;
                  long int msglen;

                  req.args = buf;
                  msgnum = 1;
                  for (;;) {
                     snprintf(buf, sizeof(buf), "%d", msgnum);
                     if (mf->resp != NULL)
                        tp_freeresp(mf->tp, mf->resp);

                     req.type = LIST;
                     mf->resp = tp_sendreq(mf->tp, &req);
                     if (mf->resp->sc != 200)
                        fail;

                     if (sscanf(mf->resp->msg, "%*s %*d %ld", &msglen) < 1)
                        runerr(1212, dx);
                     tp_freeresp(mf->tp, mf->resp);

                     Protect(reserve(Strings, msglen), runerr(0));
                     SetStrLen(result, msglen);
                     StrLoc(result) = alcstr(NULL, msglen);

                     req.type = RETR;
                     mf->resp = tp_sendreq(mf->tp, &req);
                     if (mf->resp->sc != 200)
                        runerr(1212, dx);

                     tp_read(mf->tp, StrLoc(result), (size_t)msglen);
                     while (buf[0] != '.')
                        tp_readln(mf->tp, buf, sizeof(buf));

                     suspend result;
                     msgnum++;
                     }
                  }
               }
#endif                                  /* Messaging */

#ifdef Dbm
            if (status & Fs_Dbm) {
               key = dbm_firstkey((DBM *)fd);
               }
#endif                                  /* Dbm */
            for (;;) {
               SetStrLen(result, 0);
               do {

#ifdef Graphics
                  pollctr >>= 1; pollctr++;
                  if (status & Fs_Window) {
                     slen = wgetstrg(sbuf,MaxCvtLen,fd);
                     if (slen == -1)
                        runerr(141);
                     else if (slen < -1)
                        runerr(143);
                     }
                  else
#endif                                  /* Graphics */

#if HAVE_LIBZ
                  if (status & Fs_Compress) {
                      if (gzeof((gzFile)fd)) fail;
                      if (gzgets((gzFile)fd,sbuf,MaxCvtLen+1) == Z_NULL) {
                          runerr(214);
                         }
                     slen = strlen(sbuf);
                     if (slen==MaxCvtLen && sbuf[slen-1]!='\n') slen = -2;
                     else if (sbuf[slen-1] == '\n') {
                        sbuf[slen-1] = '\0';
                        slen--;
                        }
                     }
                  else
#endif                                  /* HAVE_LIBZ */


#ifdef ReadDirectory
#if !NT || defined(NTGCC)
                  if (status & Fs_Directory) {
                     struct dirent *d;
                     char *s, *p=sbuf;
                     DEC_NARTHREADS;
                     d = readdir((DIR *)fd);
                     INC_NARTHREADS_CONTROLLED;
                     if (d == NULL) fail;
                     s = d->d_name;
                     slen = 0;
                     while(*s && slen++ < MaxCvtLen)
                        *p++ = *s++;
                     if (slen == MaxCvtLen)
                        slen = -2;
                  }
                  else
#endif                                  /* !NT */
#endif                                  /* ReadDirectory */

#ifdef Dbm
                  if (status & Fs_Dbm) {
                     DBM *db = (DBM *)fd;
                     datum content;
                     int i;

                     if (key.dptr == NULL)
                        fail;
                     content = dbm_fetch(db, key);
                     if (content.dsize > MaxCvtLen)
                        slen = MaxCvtLen;
                     else
                        slen = content.dsize;
                     for (i = 0; i < slen; i++)
                        sbuf[i] = ((char *)(content.dptr))[i];
                     key = dbm_nextkey(db);
                  }
                  else
#endif                                  /* Dbm */

                  if ((slen = getstrg(sbuf,MaxCvtLen,BlkD(dx,File))) == -1)
                     fail;
                  rlen = slen < 0 ? (word)MaxCvtLen : slen;

                  Protect(reserve(Strings, rlen), runerr(0));
#if ConcurrentCOMPILER
                  CURTSTATE();
#endif                                  /* ConcurrentCOMPILER */
                  if (!InRange(strbase,StrLoc(result),strfree)) {
                     Protect(reserve(Strings, StrLen(result)+rlen), runerr(0));
                     Protect((StrLoc(result) = alcstr(StrLoc(result),
                        StrLen(result))), runerr(0));
                     }

                  Protect(sptr = alcstr(sbuf,rlen), runerr(0));
                  if (StrLen(result) == 0)
                     StrLoc(result) = sptr;
                  SetStrLen(result, StrLen(result) + (rlen));
                  } while (slen < 0);
               suspend result;
               }
            }
         }

      table: {
         abstract {
            return type(dx).tbl_val
               }
         inline {
            struct b_tvtbl *tp;

            EVValD(&dx, E_Tbang);

            /*
             * x is a table.  Chain down the element list in each bucket
             * and suspend a variable pointing to each element in turn.
             */
            for (ep = hgfirst(BlkLoc(dx), &state); ep != 0;
               ep = hgnext(BlkLoc(dx), &state, ep)) {
                  EVValD(&(Blk(ep,Telem)->tval), E_Tval);

                  Protect(tp = alctvtbl(&dx, &ep->Telem.tref, ep->Telem.hashnum), runerr(0));
                  suspend tvtbl(tp);
                  }
            }
         }

      set: {
         abstract {
            return store[type(dx).set_elem]
            }
         inline {
            EVValD(&dx, E_Sbang);
            /*
             *  This is similar to the method for tables except that a
             *  value is returned instead of a variable.
             */
            for (ep = hgfirst(BlkLoc(dx), &state); ep != 0;
               ep = hgnext(BlkLoc(dx), &state, ep)) {
                  EVValD(&(ep->Selem.setmem), E_Sval);
                  suspend ep->Selem.setmem;
                  }
            }
         }

      record: {
         abstract {
            return type(dx).all_fields
               }
         inline {
            /*
             * x is a record.  Loop through the fields and suspend
             * a variable pointing to each one.
             */

            EVValD(&dx, E_Rbang);

            j = Blk(BlkD(dx,Record)->recdesc,Proc)->nfields;
            for (i = 0; i < j; i++) {
               EVVal(i+1, E_Rsub);
               suspend struct_var(&BlkLoc(dx)->Record.fields[i],
                  BlkD(dx, Record));
               }
            }
         }

      default:
         if cnv:tmp_string(dx) then {
            abstract {
               return string
               }
            inline {
               /*
                * A (converted or non-variable) string is being banged.
                * Tagged Unicon strings yield one codepoint at a time,
                * the same values as s[i]. Untagged strings stay one
                * byte each.
                */
               if (IsUniQual(dx)) {
                  unsigned char *bytes = (unsigned char *)StrLoc(dx);
                  word ncps, cp, bpos, w;

                  if (CpCount(dx) != CpCountSentinel)
                     ncps = CpCount(dx);
                  else
                     uq_scan(bytes, StrLen(dx), &ncps);
                  for (cp = 0; cp < ncps; cp++) {
                     bpos = uq_seek_cp(bytes, cp);
                     w = uq_lead_width(bytes[bpos]);
                     if (w == 1) {
                        ch = bytes[bpos];
                        suspend string(1, (char *)&allchars[FromAscii(ch) & 0xFF]);
                        }
                     else
                        suspend string(w, (char *)(bytes + bpos));
                     }
                  }
               else {
                  for (i = 1; i <= StrLen(dx); i++) {
                     ch = *(StrLoc(dx) + i - 1);
                     suspend string(1, (char *)&allchars[FromAscii(ch) & 0xFF]);
                     }
                  }
               }
            }
         else
            runerr(116, dx);
      }

   inline {
      fail;
      }
end


#define RandVal (RanScale*(k_random=(RandA*k_random+RandC)&0x7FFFFFFFL))

"?x - produce a randomly selected element of x."

operator{0,1} ? random(underef x -> dx)

#ifndef LargeInts
   declare {
      C_integer v = 0;
      }
#endif                                  /* LargeInts */

   if is:variable(x) && is:string(dx) then {
      abstract {
         return new tvsubs(type(x))
         }
      body {
         C_integer val;
         double rval;
#if ConcurrentCOMPILER
            CURTSTATE();
#endif                                  /* ConcurrentCOMPILER */

         /*
          * A string from a variable. Produce a one-character substring
          * trapped variable. On a tagged Unicon string the range is
          * codepoints and the trap spans the full UTF-8 character.
          */
         if (IsUniQual(dx)) {
            word ncps, bpos, w;
            unsigned char *bytes;

            if (CpCount(dx) != CpCountSentinel)
               ncps = CpCount(dx);
            else
               uq_scan((unsigned char *)StrLoc(dx), StrLen(dx), &ncps);
            if (ncps <= 0)
               fail;
            rval = RandVal;
            rval *= ncps;
            bytes = (unsigned char *)StrLoc(dx);
            bpos = uq_seek_cp(bytes, (word)rval);
            w = uq_lead_width(bytes[bpos]);
            return tvsubs(&x, bpos + 1, w);
            }
         if ((val = StrLen(dx)) <= 0)
            fail;
         rval = RandVal;        /* This form is used to get around */
         rval *= val;           /* a bug in a certain C compiler */
         return tvsubs(&x, (word)rval + 1, (word)1);
         }
      }
   else type_case dx of {
      string: {
         /*
          * x is a string, but it is not a variable. Produce a
          *   random character in it as the result; a substring
          *   trapped variable is not needed.
          */
         abstract {
            return string
            }
         body {
            C_integer val;
            double rval;
#if ConcurrentCOMPILER
            CURTSTATE();
#endif                                  /* ConcurrentCOMPILER */

            if (IsUniQual(dx)) {
               word ncps, bpos, w;
               unsigned char *bytes;

               if (CpCount(dx) != CpCountSentinel)
                  ncps = CpCount(dx);
               else
                  uq_scan((unsigned char *)StrLoc(dx), StrLen(dx), &ncps);
               if (ncps <= 0)
                  fail;
               rval = RandVal;
               rval *= ncps;
               bytes = (unsigned char *)StrLoc(dx);
               bpos = uq_seek_cp(bytes, (word)rval);
               w = uq_lead_width(bytes[bpos]);
               return string(w, StrLoc(dx) + bpos);
               }
            if ((val = StrLen(dx)) <= 0)
               fail;
            rval = RandVal;
            rval *= val;
            return string(1, StrLoc(dx)+(word)rval);
            }
         }

      cset: {
         /*
          * x is a cset.  Convert it to a string, select a random character
          *  of that string and return it. A substring trapped variable is
          *  not needed.
          */
         if !cnv:tmp_string(dx) then
            { /* cannot fail */ }
         abstract {
            return string
            }
         body {
            C_integer val;
            double rval;
            char ch;
#if ConcurrentCOMPILER
            CURTSTATE();
#endif                                  /* ConcurrentCOMPILER */

            if ((val = StrLen(dx)) <= 0)
               fail;
            rval = RandVal;
            rval *= val;
            ch = *(StrLoc(dx) + (word)rval);
            return string(1, (char *)&allchars[FromAscii(ch) & 0xFF]);
            }
         }

      list: {
         abstract {
            return type(dx).lst_elem
            }
         /*
          * x is a list.  Set i to a random number in the range [1,*x],
          *  failing if the list is empty.
          */
         body {
            C_integer val;
            double rval;
            register C_integer i, j;
            union block *bp;     /* doesn't need to be tended */
#if ConcurrentCOMPILER
            CURTSTATE();
#endif                                  /* ConcurrentCOMPILER */
            val = BlkD(dx,List)->size;
            if (val <= 0)
               fail;
            rval = RandVal;
            rval *= val;
            i = (word)rval + 1;

            EVValD(&dx, E_Lrand);
            EVVal(i, E_Lsub);

            bp = BlkD(dx,List)->listhead;

#ifdef Arrays
            if (BlkD(dx,List)->listtail!=NULL){
#endif                                  /* Arrays */

               j = 1;
               /*
               * Work down chain list of list blocks and find the block that
               *  contains the selected element.
               */
               while (i >= j + Blk(bp,Lelem)->nused) {
                  j += Blk(bp,Lelem)->nused;
                  bp = Blk(bp,Lelem)->listnext;
                  if (BlkType(bp) == T_List)
                     syserr("list reference out of bounds in random");
                  }
               /*
               * Locate the appropriate element and return a variable
               * that points to it.
               */
               i += Blk(bp,Lelem)->first - j;
               if (i >= bp->Lelem.nslots)
                  i -= bp->Lelem.nslots;
               return struct_var(&(bp->Lelem.lslots[i]), bp);
#ifdef Arrays
               }
            else if (BlkType(bp)==T_Realarray)
               return  struct_var(&((struct b_realarray *)(bp))->a[i-1], bp);
            else  /* if (Blk(bp, Intarray)->title==T_Intarray)     assumed to be int array*/
               return  struct_var(&((struct b_intarray *)(bp))->a[i-1], bp);
#endif                                  /* Arrays */

            }
         }

      table: {
         abstract {
            return type(dx).tbl_val
            }
          /*
           * x is a table.  Set n to a random number in the range [1,*x],
           *  failing if the table is empty.
           */
         body {
            C_integer val;
            double rval;
            register C_integer i, j, n;
            union block *ep, *bp;   /* doesn't need to be tended */
            struct b_slots *seg;
            struct b_tvtbl *tp;
#if ConcurrentCOMPILER
            CURTSTATE();
#endif                                  /* ConcurrentCOMPILER */

            bp = BlkLoc(dx);
            val = Blk(bp,Table)->size;
            if (val <= 0)
               fail;
            rval = RandVal;
            rval *= val;
            n = (word)rval + 1;

            EVValD(&dx, E_Trand);
            EVVal(n, E_Tsub);

            /*
             * Walk down the hash chains to find and return the nth element
             *  as a variable.
             */
            for (i=0; i < HSegs && (seg = Blk(bp,Table)->hdir[i])!=NULL;i++)
               for (j = segsize[i] - 1; j >= 0; j--)
                  for (ep = seg->hslots[j];
                       BlkType(ep) == T_Telem;
                       ep = Blk(ep,Telem)->clink)
                     if (--n <= 0) {
                        Protect(tp = alctvtbl(&dx, &(ep->Telem.tref), (ep->Telem.hashnum)), runerr(0));
                        return tvtbl(tp);
                        }
            syserr("table reference out of bounds in random");
            }
         }

      set: {
         abstract {
            return store[type(dx).set_elem]
            }
         /*
          * x is a set.  Set n to a random number in the range [1,*x],
          *  failing if the set is empty.
          */
         body {
            C_integer val;
            double rval;
            register C_integer i, j, n;
            union block *bp, *ep;  /* doesn't need to be tended */
            struct b_slots *seg;
#if ConcurrentCOMPILER
            CURTSTATE();
#endif                                  /* ConcurrentCOMPILER */

            bp = BlkLoc(dx);
            val = Blk(bp,Set)->size;
            if (val <= 0)
               fail;
            rval = RandVal;
            rval *= val;
            n = (word)rval + 1;

            EVValD(&dx, E_Srand);
            /*
             * Walk down the hash chains to find and return the nth element.
             */
            for (i=0; i < HSegs && (seg = Blk(bp,Table)->hdir[i]) != NULL; i++)
               for (j = segsize[i] - 1; j >= 0; j--)
                  for (ep = seg->hslots[j]; ep != NULL; ep = Blk(ep,Telem)->clink)
                     if (--n <= 0) {
                        EVValD(&(ep->Selem.setmem), E_Selem);
                        return Blk(ep,Selem)->setmem;
                        }
            syserr("set reference out of bounds in random");
            }
         }

      record: {
         abstract {
            return type(dx).all_fields
            }
         /*
          * x is a record.  Set val to a random number in the range
          *  [1,*x] (*x is the number of fields), failing if the
          *  record has no fields.
          */
         body {
            C_integer val;
            double rval;
            struct b_record *rec;  /* doesn't need to be tended */
#if ConcurrentCOMPILER
            CURTSTATE();
#endif                                  /* ConcurrentCOMPILER */

            rec = BlkD(dx, Record);
            val = Blk(rec->recdesc,Proc)->nfields;
            if (val <= 0)
               fail;
            /*
             * Locate the selected element and return a variable
             * that points to it
             */
            rval = RandVal;
            rval *= val;
            EVValD(&dx, E_Rrand);
            EVVal(rval + 1, E_Rsub);
            return struct_var(&rec->fields[(word)rval], rec);
            }
         }

      default: {

#ifdef LargeInts
         if !cnv:integer(dx) then
            runerr(113, dx)
#else                                   /* LargeInts */
         if !cnv:C_integer(dx,v) then
            runerr(113, dx)
#endif                                  /* LargeInts */

         abstract {
            return integer ++ real
            }
         body {
            double rval;

#ifdef LargeInts
            C_integer v;
            if (Type(dx) == T_Lrgint) {
               if (bigrand(&dx, &result) == RunError)  /* alcbignum failed */
                  runerr(0);
               return result;
               }

            v = IntVal(dx);
#endif                                  /* LargeInts */
#if ConcurrentCOMPILER
            CURTSTATE();
#endif                                  /* ConcurrentCOMPILER */

            /*
             * x is an integer, be sure that it's non-negative.
             */
            if (v < 0)
               runerr(205, dx);

            /*
             * val contains the integer value of x. If val is 0, return
             *  a real in the range [0,1), else return an integer in the
             *  range [1,val].
             */
            if (v == 0) {
               rval = RandVal;
               return C_double rval;
               }
            else {
               rval = RandVal;
               rval *= v;
               return C_integer (long)rval + 1;
               }
            }
         }
      }
end

"x[i:j] - form a substring or list section of x."

operator{0,1} [:] sect(underef x -> dx, i, j)
   declare {
      int use_trap = 0;
      }

   if is:list(dx) then {
      abstract {
         return type(dx)
         }
      /*
       * If it isn't a C integer, but is a large integer, fail on
       * the out-of-range index.
       */
      if !cnv:C_integer(i) then {
         if cnv : integer(i) then inline { fail; }
         runerr(101, i)
         }
      if !cnv:C_integer(j) then {
         if cnv : integer(j) then inline { fail; }
         runerr(101, j)
         }

      body {
         C_integer t;

         i = cvpos((long)i, (long)BlkD(dx,List)->size);
         if (i == CvtFail)
            fail;
         j = cvpos((long)j, (long)BlkD(dx,List)->size);
         if (j == CvtFail)
            fail;
         if (i > j) {
            t = i;
            i = j;
            j = t;
            }

#ifdef Arrays
         if (BlkD(dx,List)->listtail!=NULL){
#endif                                  /* Arrays */
            if (cplist(&dx, &result, i, j) == RunError)
               runerr(0);
#ifdef Arrays
               }
         else if ( BlkType(BlkD(dx,List)->listhead)==T_Realarray){
            if (cprealarray(&dx, &result, i, j) == RunError)
               runerr(0);
            }
         else /*if ( BlkType(BlkD(dx,List)->listhead)==T_Intarray)*/{
            if (cpintarray(&dx, &result, i, j) == RunError)
               runerr(0);
            }
#endif                                  /* Arrays */
         return result;
         }
      }
   else {

      /*
       * x should be a string. If x is a variable, we must create a
       *  substring trapped variable.
       */
      if is:variable(x) && is:string(dx) then {
         abstract {
            return new tvsubs(type(x))
            }
         inline {
            use_trap = 1;
            }
         }
      else if cnv:string(dx) then
         abstract {
            return string
            }
      else
         runerr(110, dx)

      /*
       * If it isn't a C integer, but is a large integer, fail on
       * the out-of-range index.
       */
      if !cnv:C_integer(i) then {
         if cnv : integer(i) then inline { fail; }
         runerr(101, i)
         }
      if !cnv:C_integer(j) then {
         if cnv : integer(j) then inline { fail; }
         runerr(101, j)
         }

      body {
         C_integer t;
         word uq_total;

         /*
          * Unicon Phase 0: same uq_total substitution as move/tab/pos
          * (fscan.r) -- cvpos() is already unit-agnostic. sect goes
          * further than those: a multi-character slice can itself
          * contain non-ASCII content or not, independent of whether
          * the source does (e.g. slicing out the pure-ASCII "caf" from
          * "café" shouldn't tag the result) -- so rather than assume
          * the slice inherits the source's tag, it's scanned directly,
          * the same precise approach already validated in oasgn.r's
          * subs_asgn fix rather than the coarser "inherit the source's
          * tag" shortcut.
          */
         if (IsUniQual(dx)) {
            if (CpCount(dx) != CpCountSentinel)
               uq_total = CpCount(dx);
            else
               uq_scan((unsigned char *)StrLoc(dx), StrLen(dx), &uq_total);
            }
         else
            uq_total = StrLen(dx);

         i = cvpos((long)i, (long)uq_total);
         if (i == CvtFail)
            fail;
         j = cvpos((long)j, (long)uq_total);
         if (j == CvtFail)
            fail;
         if (i > j) {                   /* convert section to substring */
            t = i;
            i = j;
            j = t - j;
            }
         else
            j = j - i;

         if (IsUniQual(dx)) {
            unsigned char *uq_bytes = (unsigned char *)StrLoc(dx);
            word uq_bstart = uq_seek_cp(uq_bytes, i - 1);
            word uq_bend = uq_seek_cp(uq_bytes, i - 1 + j);
            word uq_blen = uq_bend - uq_bstart;

            if (use_trap) {
               return tvsubs(&x, uq_bstart+1, uq_blen);
               }
            else {
               tended struct descrip uq_result;
               word uq_ncps;
               int uq_tagged = uq_scan(uq_bytes+uq_bstart, uq_blen, &uq_ncps);
               StrLoc(uq_result) = (char *)(uq_bytes+uq_bstart);
               SetStrLen(uq_result, uq_blen);
               if (uq_tagged) {
                  SetUniQual(uq_result);
                  if ((uword)uq_ncps <= CpCountMax)
                     SetCpCount(uq_result, uq_ncps);
                  }
               return uq_result;
               }
            }
         else {
            if (use_trap) {
               return tvsubs(&x, i, j);
               }
            else
               return string(j, StrLoc(dx)+i-1);
            }
         }
      }
end

"x[y] - access yth character or element of x."

operator{0,1} [] subsc(underef x -> dx,y)
   declare {
      int use_trap = 0;
      }

   type_case dx of {
      file: {
         abstract {
            return string ++ integer ++ list
            }

         body {
            int status = BlkD(dx,File)->status;
#ifdef Dbm
            if (status & Fs_Dbm) {
               struct b_tvtbl *tp;

               EVValD(&dx, E_Tref);
               EVValD(&y, E_Tsub);
               Protect(tp = alctvtbl(&dx, &y, 0), runerr(0));
               return tvtbl(tp);
               }
            else
#endif                                  /* Dbm */
#ifdef Messaging
            if (status & Fs_Messaging) {
               tended char *c_y;
               long int msglen;
               struct MFile *mf = BlkD(dx,File)->fd.mf;
               if (!cnv:C_string(y, c_y)) {
                  runerr(103, y);
                  }
               if ((mf->resp == NULL) && !MFIN(mf, READING)){
                  Mstartreading(mf);
                  }
               if (mf->resp == NULL) {
                  fail;
                  }
               if (strcmp(c_y, "Status-Code") == 0 ||
                   strcmp(c_y, "code") == 0) {
                  return C_integer mf->resp->sc;
                  }
               else if (strcmp(c_y, "Reason-Phrase") == 0 ||
                        strcmp(c_y, "message") == 0) {
                  if (mf->resp->msg != NULL && (msglen = strlen(mf->resp->msg)) > 0) {
                     /*
                      * we could just return string(strlen(mf->resp->msg), mf->resp->msg)
                      * but mf->resp->msg could be gone by the time the result is accessed
                      * if the user called close() so, just allocate a string and return it.
                      */

                     SetStrLen(result, msglen);
                     StrLoc(result) = alcstr(mf->resp->msg, msglen);
                     return result;
                     }
                  else {
                     fail;
                     }
                  }
               else if (c_y[0] >= '0' && c_y[0] <= '9' &&
                        strcmp(mf->tp->uri.scheme, "pop") == 0) {
                  Tprequest_t req = { LIST, NULL, 0 };
                  char buf[100];
                  buf[0]='\0';

                  req.args = c_y;
                  tp_freeresp(mf->tp, mf->resp);
                  mf->resp = tp_sendreq(mf->tp, &req);
                  if (mf->resp->sc != 200) {
                     fail;
                     }
                  if (sscanf(mf->resp->msg, "%*s %*d %ld", &msglen) < 1) {
                     runerr(1212, dx);
                     }
                  tp_freeresp(mf->tp, mf->resp);

                  Protect(reserve(Strings, msglen), runerr(0));
                  SetStrLen(result, msglen);
                  StrLoc(result) = alcstr(NULL, msglen);

                  req.type = RETR;
                  mf->resp = tp_sendreq(mf->tp, &req);
                  if (mf->resp->sc != 200) {
                     runerr(1212, dx);
                     }
                  tp_read(mf->tp, StrLoc(result), (size_t)msglen);
                  while (buf[0] != '.') {
                     tp_readln(mf->tp, buf, sizeof(buf));
                     }
                  return result;
                  }
               else {
                  char *val = tp_headerfield(mf->resp->header, c_y);
                  char *end;
                  tended char *tmp;
                  if (val == NULL) {
                     fail;
                     }

                  if (((end = strchr(val, '\r')) != NULL) ||
                     ((end = strchr(val, '\n')) != NULL)) {
                     Protect(tmp = alcstr(val, end-val), runerr(0));
                     return string(end-val, tmp);
                     }
                  else {
                     Protect(tmp = alcstr(val, strlen(val)), runerr(0));
                     return string(strlen(val), tmp);
                     }
                  }
               }
            else
#endif                                  /* Messaging */
               {
#ifdef PosixFns
               tended char *c_y;
               int peek_rc;
#ifdef Concurrent
               word peek_mtx = BlkD(dx,File)->mutexid;
#endif                                  /* Concurrent */
               if (!cnv:C_string(y, c_y))
                  runerr(103, y);

#if HAVE_LIBSSL
               if (status & Fs_Crypto) {
                  struct CryptoFile *cf;
#ifdef Concurrent
                  MUTEX_LOCKID_CONTROLLED(peek_mtx);
#endif                                  /* Concurrent */
                  status = BlkD(dx,File)->status;
                  cf = BlkD(dx,File)->fd.cf;
                  if (cf == NULL || (status & Fs_Crypto) == 0) {
#ifdef Concurrent
                     MUTEX_UNLOCKID(peek_mtx);
#endif                                  /* Concurrent */
                     runerr(174, dx);
                     }
                  peek_rc = crypto_peek(cf, c_y, &result);
#ifdef Concurrent
                  MUTEX_UNLOCKID(peek_mtx);
#endif                                  /* Concurrent */
                  if (peek_rc == FILEPEEK_ERR)
                     runerr(1302, y);
                  if (peek_rc == FILEPEEK_FAIL)
                     fail;
                  return result;
                  }
#endif                                  /* HAVE_LIBSSL */
#if HAVE_LIBSSH
               if (status & Fs_SSH) {
                  struct SSHfile *sshf;
#ifdef Concurrent
                  MUTEX_LOCKID_CONTROLLED(peek_mtx);
#endif                                  /* Concurrent */
                  status = BlkD(dx,File)->status;
                  sshf = BlkD(dx,File)->fd.sshf;
                  if (sshf == NULL || (status & Fs_SSH) == 0) {
#ifdef Concurrent
                     MUTEX_UNLOCKID(peek_mtx);
#endif                                  /* Concurrent */
                     runerr(174, dx);
                     }
                  peek_rc = ssh_peek(sshf, c_y, &result);
#ifdef Concurrent
                  MUTEX_UNLOCKID(peek_mtx);
#endif                                  /* Concurrent */
                  if (peek_rc == FILEPEEK_ERR)
                     runerr(1331, y);
                  if (peek_rc == FILEPEEK_FAIL)
                     fail;
                  return result;
                  }
#endif                                  /* HAVE_LIBSSH */
#if HAVE_LIBSSL
               if ((status & Fs_Encrypt) && (status & Fs_Socket)) {
                  SSL *ssl;
#ifdef Concurrent
                  MUTEX_LOCKID_CONTROLLED(peek_mtx);
#endif                                  /* Concurrent */
                  status = BlkD(dx,File)->status;
                  ssl = BlkD(dx,File)->fd.ssl;
                  if (ssl == NULL ||
                      ((status & Fs_Encrypt) == 0) ||
                      ((status & Fs_Socket) == 0)) {
#ifdef Concurrent
                     MUTEX_UNLOCKID(peek_mtx);
#endif                                  /* Concurrent */
                     runerr(174, dx);
                     }
                  peek_rc = tls_peek(BlkD(dx,File), c_y, &result);
#ifdef Concurrent
                  MUTEX_UNLOCKID(peek_mtx);
#endif                                  /* Concurrent */
                  if (peek_rc == FILEPEEK_ERR)
                     runerr(1326, y);
                  if (peek_rc == FILEPEEK_FAIL)
                     fail;
                  return result;
                  }
#endif                                  /* HAVE_LIBSSL */
               if (status & Fs_Socket) {
                  int s;
#ifdef Concurrent
                  MUTEX_LOCKID_CONTROLLED(peek_mtx);
#endif                                  /* Concurrent */
                  status = BlkD(dx,File)->status;
                  if ((status & Fs_Socket) == 0) {
#ifdef Concurrent
                     MUTEX_UNLOCKID(peek_mtx);
#endif                                  /* Concurrent */
                     runerr(174, dx);
                     }
#if HAVE_LIBSSL
                  if (status & Fs_Encrypt) {
                     SSL *ssl = BlkD(dx,File)->fd.ssl;
                     if (ssl == NULL) {
#ifdef Concurrent
                        MUTEX_UNLOCKID(peek_mtx);
#endif                                  /* Concurrent */
                        runerr(174, dx);
                        }
                     s = SSL_get_fd(ssl);
                     }
                  else
#endif                                  /* HAVE_LIBSSL */
                     s = BlkD(dx,File)->fd.fd;
                  peek_rc = sock_peek(s, c_y, &result);
#ifdef Concurrent
                  MUTEX_UNLOCKID(peek_mtx);
#endif                                  /* Concurrent */
                  if (peek_rc == FILEPEEK_ERR)
                     runerr(1310, y);
                  if (peek_rc == FILEPEEK_FAIL)
                     fail;
                  return result;
                  }
#endif                                  /* PosixFns */
               runerr(114,dx);
               }
            }
         }

      list: {
         abstract {
            return type(dx).lst_elem
            }
         /*
          * Make sure that y is a C integer.
          */
         if !cnv:C_integer(y) then {
            /*
             * If it isn't a C integer, but is a large integer,
             * fail on the out-of-range index.
             */
            if cnv : integer(y) then inline { fail; }
            runerr(101, y)
            }
         body {
            word i, j;
            register union block *bp; /* doesn't need to be tended */
            struct b_list *lp;        /* doesn't need to be tended */

            EVValD(&dx, E_Lref);
            EVVal(y, E_Lsub);

            /*
             * Make sure that subscript y is in range.
             */
            lp = BlkD(dx, List);
            MUTEX_LOCKBLK_CONTROLLED(lp, "x[y]: lock list");
            i = cvpos((long)y, (long)lp->size);
            if (i == CvtFail || i > lp->size){
               MUTEX_UNLOCKBLK(lp, "x[y]: unlock list");
               fail;
               }
            /*
             * Locate the list-element block containing the
             *  desired element.
             */
            bp = lp->listhead;

#ifdef Arrays
            if (lp->listtail!=NULL){
#endif                                  /* Arrays */
               /*
               * y is in range, so bp can never be null here. if it was, a memory
               * violation would occur in the code that follows, anyhow, so
               * exiting the loop on a NULL bp makes no sense.
               */
               j = 1;
               while (i >= j + Blk(bp,Lelem)->nused) {
                  j += bp->Lelem.nused;
                  bp = bp->Lelem.listnext;
                  }

               /*
               * Locate the desired element and return a pointer to it.
               */
               i += bp->Lelem.first - j;
               if (i >= bp->Lelem.nslots)
                  i -= bp->Lelem.nslots;
               MUTEX_UNLOCKBLK(BlkD(dx,List), "x[y]: unlock list");
               return struct_var(&bp->Lelem.lslots[i], bp);
#ifdef Arrays
            }
            else if (BlkType(bp)==T_Realarray)
                  return  struct_var(&((struct b_realarray *)(bp))->a[i-1], bp);
            else { /* if (BlkType(bp)==T_Intarray)     assumed to be int array*/
               return  struct_var(&((struct b_intarray *)(bp))->a[i-1], bp);
               }
#endif                                  /* Arrays */
            }
         }

      table: {
         abstract {
            store[type(dx).tbl_key] = type(y) /* the key might be added */
            return type(dx).tbl_val ++ new tvtbl(type(dx))
            }
         /*
          * x is a table.  Return a table element trapped variable
          *  representing the result; defer actual lookup until later.
          */
         body {
            uword hn;
            struct b_tvtbl *tp;

            EVValD(&dx, E_Tref);
            EVValD(&y, E_Tsub);

            hn = hash(&y);
            EVVal(hn, E_HashNum);
            Protect(tp = alctvtbl(&dx, &y, hn), runerr(0));
            return tvtbl(tp);
            }
         }

      record: {
         abstract {
            return type(dx).all_fields
            }
         /*
          * x is a record.  Convert y to an integer and be sure that it
          *  it is in range as a field number.
          */
         if !cnv:C_integer(y) then body {
            if (!cnv:tmp_string(y,y))
               runerr(101,y);
            else {
               register union block *bp;  /* doesn't need to be tended */
               register union block *bp2; /* doesn't need to be tended */
               register word i;
               register int len;
               char *loc;
               int nf;
               bp = BlkLoc(dx);
               bp2 = BlkD(dx,Record)->recdesc;
               nf = Blk(bp2,Proc)->nfields;
               loc = StrLoc(y);
               len = StrLen(y);
               for(i=0; i<nf; i++) {
                  if (len == StrLen(Blk(bp2,Proc)->lnames[i]) &&
                      !strncmp(loc, StrLoc(Blk(bp2,Proc)->lnames[i]), len)) {

                     EVValD(&dx, E_Rref);
                     EVVal(i+1, E_Rsub);

                     /*
                      * Found the field, return a pointer to it.
                      */
                     return struct_var(&(Blk(bp,Record)->fields[i]), bp);
                     }
                  }
               fail;
               }
            }
         else
         body {
            word i;
            register union block *bp; /* doesn't need to be tended */
            union block *rd;

            bp = BlkLoc(dx);
            rd = Blk(bp,Record)->recdesc;
            /*
             * check if the record is an object, if yes, add 2 to the subscript
             */

            if (Blk(rd,Proc)->ndynam == -3) {
                  i = cvpos(y, (word)(Blk(rd,Proc)->nfields-2));
                  i += 2;
                  }
               else {
                  i = cvpos(y, (word)(Blk(rd,Proc)->nfields));
                  }

            if (i == CvtFail || i > Blk(Blk(bp,Record)->recdesc,Proc)->nfields)
               fail;

            EVValD(&dx, E_Rref);
            EVVal(i, E_Rsub);

            /*
             * Locate the appropriate field and return a pointer to it.
             */
            return struct_var(&Blk(bp,Record)->fields[i-1], bp);
            }
         }

      default: {
         /*
          * dx must either be a string or be convertible to one. Decide
          *  whether a substring trapped variable can be created.
          */
         if is:variable(x) && is:string(dx) then {
            abstract {
               return new tvsubs(type(x))
               }
            inline {
               use_trap = 1;
               }
            }
         else if cnv:tmp_string(dx) then
            abstract {
               return string
               }
         else
            runerr(114, dx)

         /*
          * Make sure that y is a C integer.
          */
         if !cnv:C_integer(y) then {
            /*
             * If it isn't a C integer, but is a large integer, fail on
             * the out-of-range index.
             */
            if cnv : integer(y) then inline { fail; }
            runerr(101, y)
            }

         body {
            char ch;
            word i;

            if (is:string(dx) && IsUniQual(dx)) {
               /*
                * Unicon Phase 0 (design doc §7.2): dx is a tagged
                * Unicode string. y means codepoint index, not byte
                * index. No cache/index yet -- Phase 0's whole point is
                * demonstrating correctness before optimization -- so
                * this walks from the start every time (the "baseline"
                * scheme from the design doc's benchmarks), via the
                * shared uq_scan/uq_seek_cp helpers (rmacros.h) rather
                * than a fourth copy of the same inline loop. Unconditional
                * -- no #ifdef here on purpose, see rmacros.h: IsUniQual
                * is always defined (always false when the feature is
                * off), so this branch is simply never taken rather than
                * needing RTT to strip an #ifdef from inside a body
                * block, which it doesn't do reliably (confirmed
                * directly against generated intermediate C).
                */
               unsigned char *bytes = (unsigned char *)StrLoc(dx);
               word blen = StrLen(dx);
               word ncps, bpos;

               uq_scan(bytes, blen, &ncps);

               i = cvpos(y, ncps);
               if (i == CvtFail || i > ncps)
                  fail;

               bpos = uq_seek_cp(bytes, i - 1);

               /* a single extracted character is small enough to stay
                  a plain, untagged qualifier either way -- design doc
                  §4.2 */
               if (use_trap)
                  return tvsubs(&x, bpos+1, uq_lead_width(bytes[bpos]));
               else
                  return string(uq_lead_width(bytes[bpos]), (char *)(bytes+bpos));
               }

            /*
             * Convert y to a position in x and fail if the position
             *  is out of bounds.
             */
            i = cvpos(y, StrLen(dx));
            if (i == CvtFail || i > StrLen(dx))
               fail;
            if (use_trap) {
               /*
                * x is a string, make a substring trapped variable for the
                * one character substring selected and return it.
                */
               return tvsubs(&x, i, (word)1);
               }
            else {
               /*
                * x was converted to a string, so it cannot be assigned
                * back into. Just return a string containing the selected
                * character.
                */
               ch = *(StrLoc(dx)+i-1);
               return string(1, (char *)&allchars[FromAscii(ch) & 0xFF]);
               }
            }
         }
      }
end
