/*
 * File: fstruct.r
 *  Contents: delete, get, key, insert, list, member, pop, pull, push, put,
 *  set, table, constructor
 */

"delete(x1, x2) - delete element x2 from set, table, or list x1 if it is there"
" (always succeeds and returns x1)."

function{1} delete(s, x[n])
   abstract {
      return type(s) ** (set ++ table ++ list)
      }

   /*
    * The technique and philosophy here are the same
    *  as used in insert - see comment there.
    */
   type_case s of {
      set:
         body {
            register uword hn;
            register union block **pd;
            int res, argc;
	    
	    MUTEX_LOCKBLK_CONTROLLED(BlkD(s, Set), "delete(): lock set");
	    for (argc = 0; argc < n; argc++) {
	       hn = hash(x+argc);
	       pd = memb(BlkLoc(s), x + argc, hn, &res);
	       if (res == 1) {
		  /*
		   * The element is there so delete it.
		   */
		  *pd = Blk(*pd, Selem)->clink;
		  BlkD(s, Set)->size--;
		  }
	       EVValD(&s, E_Sdelete);
	       EVValD(x+argc, E_Sval);
	       }
	    MUTEX_UNLOCKBLK(BlkD(s, Set), "delete(): unlock set");
            return s;
	    }
      table:
         body {
            register union block **pd;
            register uword hn;
            int res, argc;

	    MUTEX_LOCKBLK_CONTROLLED(BlkD(s, Table), "delete(): lock table");
	    for (argc = 0; argc < n; argc++) {
	       hn = hash(x+argc);
	       pd = memb(BlkLoc(s), x+argc, hn, &res);
	       if (res == 1) {
		  /*
		   * The element is there so delete it.
		   */
		  *pd = Blk(*pd,Telem)->clink;
		  BlkD(s,Table)->size--;
		  }
	       EVValD(&s, E_Tdelete);
	       EVValD(x+argc, E_Tsub);
	       }
	    MUTEX_UNLOCKBLK(BlkD(s, Table), "delete(): unlock table");
            return s;
            }
      list:
         body {
	    tended struct b_list *hp; /* work in progress */
	    tended struct descrip d;
            C_integer cnv_x;
	    int i, size, argc;

#ifdef Arrays
	    if (BlkD(s,List)->listtail==NULL) 
	       if (arraytolist(&s)!=Succeeded) fail;
#endif					/* Arrays*/

	    MUTEX_LOCKBLK_CONTROLLED(BlkD(s, List), "delete(): lock list");

	    for (argc = 0; argc < n; argc++) {
	       if (!cnv:C_integer(x[argc], cnv_x)) runerr(101, x[argc]);
	       hp = BlkD(s, List);
	       size = hp->size;
	       if (cnv_x < 0 ) 
	       	  cnv_x = size +  cnv_x + 1; 
	       for (i = 1; i <= size; i++) {
		  c_get(hp, &d);
		  if (i != cnv_x)
		     c_put(&s, &d);
		  }
	       EVValD(&s, E_Ldelete);
	       EVVal(cnv_x, E_Lsub);
	       }
	    MUTEX_UNLOCKBLK(BlkD(s, List), "delete(): unlock list");
	    return s;
	    }
#if defined(Dbm) || defined(Messaging)
      file:
	 body {
	    C_integer cnv_x;
	    int argc;

#ifdef Dbm
	    if (BlkD(s,File)->status & Fs_Dbm) {
	       DBM *db;
	       datum key;
	       db = BlkD(s,File)->fd.dbm;
	       for (argc = 0; argc < n; argc++) {
		  key.dsize = StrLen(x[argc]); key.dptr = StrLoc(x[argc]);
		  dbm_delete(db, key);
		  }
	       return s;
	       }
	    else
#endif

#ifdef Messaging
            if ((BlkD(s,File)->status & Fs_Messaging)) {
	       struct MFile *mf = BlkD(s,File)->fd.mf;
	       if (strcmp(mf->tp->uri.scheme, "pop") != 0) {
		  runerr(1213, s);
		  }
	       for (argc=0; argc<n; argc++) {
		  if (!cnv:C_integer(x[argc], cnv_x)) runerr(101, x[argc]);

		  if (Mpop_delete(mf, cnv_x) < 0) {
		     runerr(1212, s);
		     }
		  }
	       return s;
	       }
	    else
#endif					/* Messaging */
	       runerr(1208, s);

	    }
#endif
      default:
         runerr(122, s)
      }
end


/*
 * c_get - convenient C-level access to the get function
 *  returns 0 on failure, otherwise fills in res
 */
int c_get(hp, res)
struct b_list *hp;
struct descrip *res;
{
   register word i;
   register struct b_lelem *bp;

   /*
    * Fail if the list is empty.
    */
   if (hp->size <= 0)
      return 0;

   /*
    * Point bp at the first list block.  If the first block has no
    *  elements in use, point bp at the next list block.
    */
   bp = (struct b_lelem *) hp->listhead;
   if (bp->nused <= 0) {
      bp = (struct b_lelem *) bp->listnext;
      hp->listhead = (union block *) bp;
      bp->listprev = (union block *) hp;
      }

   /*
    * Locate first element and assign it to result for return.
    */
   i = bp->first;
   *res = bp->lslots[i];

   /*
    * Set bp->first to new first element, or 0 if the block is now
    *  empty.  Decrement the usage count for the block and the size
    *  of the list.
    */
   if (++i >= bp->nslots)
      i = 0;
   bp->first = i;
   bp->nused--;
   hp->size--;

   return 1;
}

#begdef GetOrPop(get_or_pop)
#get_or_pop "(x) - " #get_or_pop " an element from the left end of list x."
/*
 * get(L) - get an element from end of list L.
 *  Identical to pop(L).
 */
function{0,1} get_or_pop(x,i)
   if !def:C_integer(i, 1L) then
      runerr(101, i)

   type_case x of {
      list: {

	 abstract {
	    return store[type(x).lst_elem]
	    }

	 body {
	    int j;
	    tended struct b_list *hp;
      	    if (i <= 0)
      	    fail;
	    
	    EVValD(&x, E_Lget);
#ifdef Arrays
	    if (BlkD(x, List)->listtail==NULL) 
	       if (arraytolist(&x)!=Succeeded) fail;
#endif					/* Arrays*/
	    hp = BlkD(x, List);
   	    MUTEX_LOCKBLK_CONTROLLED(hp, "get() lock list");
	    for(j=0;j<i;j++)
	       if (!c_get(hp, &result)){
	          MUTEX_UNLOCKBLK(hp, "get(): unlock list");
 	          fail;
		  }
	    MUTEX_UNLOCKBLK(hp, "get(): unlock list");
	    return result;
	    }
	 }
#ifdef Messaging
      file: {
	 abstract {
	    return string
	    }
	 body {
	    char buf[100];
	    struct MFile* mf;
	    Tprequest_t req = { LIST, NULL, 0 };
	    struct Mpoplist* mpl;
	    unsigned int msgnum;
	    long int msglen;

	    if (!(BlkD(x,File)->status & Fs_Messaging)) {
	       runerr(1213, x);
	       }
	    mf = BlkD(x,File)->fd.mf;
	    if (strcmp(mf->tp->uri.scheme, "pop") != 0) {
	       runerr(1213, x);
	       }

	    /* Determine the next undeleted message */
	    mpl = (struct Mpoplist*)mf->data;
	    if (mpl == NULL || mpl->next == mpl) {
	       fail;
	       }
	    msgnum = mpl->next->msgnum;

	    req.args = buf;
	    snprintf(req.args, sizeof(buf), "%d", msgnum);
	    if (mf->resp != NULL) {
	       tp_freeresp(mf->tp, mf->resp);
	       }
	    mf->resp = tp_sendreq(mf->tp, &req);
	    if (mf->resp->sc != 200) {
	       fail;
	       }
	    if (sscanf(mf->resp->msg, "%*s %*d %ld", &msglen) < 1) {
	       runerr(1212, x);
	       }
	    tp_freeresp(mf->tp, mf->resp);
	    
	    Protect(reserve(Strings, msglen), runerr(0));
	    StrLen(result) = msglen;
	    StrLoc(result) = alcstr(NULL, msglen);
	    
	    req.type = RETR;
	    mf->resp = tp_sendreq(mf->tp, &req);
	    if (mf->resp->sc != 200) {
	       runerr(1212, x);
	       }
	    tp_read(mf->tp, StrLoc(result), (size_t)msglen);
	    while (buf[0] != '.') {
	       tp_readln(mf->tp, buf, sizeof(buf));
	       }

	    /* Delete the message we just read */
	    Mpop_delete(mf, 1);

	    return result;
	    }
	 }
#endif                                  /* Messaging */
      default:
	 runerr(108, x)
      }
end
#enddef

GetOrPop(get) /* get(x) - get an element from the left end of list x. */
GetOrPop(pop) /* pop(x) - pop an element from the left end of list x. */


"key(T) - generate successive keys (entry values) from table T."

function{*} key(t)
   type_case t of {
      table: {
	 abstract {
	    return store[type(t).tbl_key]
	 }
	 inline {
	    tended union block *ep;
	    struct hgstate state;

	    EVValD(&t, E_Tkey);
	    for (ep = hgfirst(BlkLoc(t), &state); ep != 0;
		 ep = hgnext(BlkLoc(t), &state, ep)) {
	       EVValD(&(Blk(ep,Telem)->tref), E_Tsub);
	       suspend ep->Telem.tref;
            }
	    fail;
	    }
      }
      list: {
	 abstract { return integer }
	 inline {
	    C_integer i;
	    for(i=1; i<=BlkD(t, List)->size; i++) suspend C_integer i;
	    fail;
	    }
	 }
      record: {
	 abstract { return string }
	 inline {
	    C_integer i=0, sz = Blk(BlkD(t,Record)->recdesc,Proc)->nfields;
	    if (sz > 0) {
	       struct descrip d;
	       d = Blk(BlkD(t,Record)->recdesc,Proc)->lnames[0];
	       if ((StrLen(d) != 3) || strncmp(StrLoc(d),"__s",3))
		  suspend d;
	       if (sz > 1) {
		  d = Blk(BlkD(t,Record)->recdesc,Proc)->lnames[1];
		  if ((StrLen(d) != 3) || strncmp(StrLoc(d),"__m",3))
		  suspend Blk(BlkD(t,Record)->recdesc,Proc)->lnames[1];
		  i = 2;
		  while(i<sz) {
		     suspend Blk(BlkD(t,Record)->recdesc,Proc)->lnames[i];
		     i++;
		     }
		  }
	       }
	    fail;
	    }
	 }
#if defined(Dbm) || defined(Messaging)
      file: {
	 abstract {
	    return string
	 }
	 inline {
	    word status;
	    status = BlkD(t,File)->status;
#ifdef Dbm
	    if (status & Fs_Dbm) {
	       DBM *db;
	       datum key; 
	       db = BlkD(t,File)->fd.dbm;
	       for (key = dbm_firstkey(db); key.dptr != NULL;
		    key = dbm_nextkey(db)) {
		  Protect(StrLoc(result) = alcstr(key.dptr, key.dsize),runerr(0));
		  StrLen(result) = key.dsize;
		  suspend result;
		  }
	       fail;
	       }
#endif                                  /* Dbm */
#ifdef Messaging
	       else if (status & Fs_Messaging) {
		  struct MFile *mf = BlkD(t,File)->fd.mf;
		  char *field, *end;

		  if ((mf->resp == NULL) && !MFIN(mf, READING)){
		     Mstartreading(mf);
		     }

		  if (mf->resp == NULL)
		     fail;
		     
		  Protect(StrLoc(result) = alcstr("Status-Code", 11),runerr(0));
		  StrLen(result) = 11;
		  suspend result;

		  if (mf->resp->msg != NULL && strlen(mf->resp->msg) > 0){
		     Protect(StrLoc(result) = alcstr("Reason-Phrase", 13),runerr(0));
		     StrLen(result) = 13;
		     suspend result;
		     }

		  if (mf->resp->header == NULL)
		     fail;

		  for (field = mf->resp->header;
		       field != NULL;
		       field = strchr(field, '\r')) {

		     /* Skip to first letter of field name */
		     while (strchr(" \r\n", *field)) {
			field++;
			}
		     
		     end = strchr(field, ':');
		     Protect(StrLoc(result) = alcstr(field, end - field),runerr(0));
		     StrLen(result) = end - field;
		     suspend result;
		     }
		  fail;
		  }
#endif                                  /* Messaging */
	    else
	       runerr(122, t);
	    }
	 }
#endif					/* Dbm || Messaging */
   default: {
      runerr(124, t)
      }
}
end


/*
 * Insert an array of alternating keys and values into a table.
 */
int c_inserttable(union block **pbp, int n, dptr x)
{
   tended struct descrip s;
   union block **pd;
   struct b_telem *te;
   register uword hn;
   int res, argc;

   s.dword = D_Table;
   BlkLoc(s) = *pbp;
   /* n could be odd, the code below makes sure the last value defaults to null in such case */
   for(argc=0; argc<n; argc+=2) {
      hn = hash(x+argc);

      /* get this now because can't tend pd */
      Protect(te = alctelem(), return -1);

      pd = memb(*pbp, x+argc, hn, &res);	/* search table for key */
      if (res == 0) {
	 /*
	  * The element is not in the table - insert it.
	  */
	 Blk(*pbp, Table)->size++;
	 te->clink = *pd;
	 *pd = (union block *)te;
	 te->hashnum = hn;
	 te->tref = x[argc];
	 if (argc+1<n)
	    te->tval = x[argc+1];
	 else /* if n is odd, a null is used as a default value */
	    te->tval = nulldesc;
	 if (TooCrowded(*pbp))
	    hgrow(*pbp);
	 }
      else {
	 /*
	  * We found an existing entry; just change its value.
	  */
	 deallocate((union block *)te);
	 te = (struct b_telem *) *pd;
	 te->tval = x[argc+1];
	 }
      EVValD(&s, E_Tinsert);
      EVValD(x+argc, E_Tsub);
      }
   return 0;
}

"insert(x1, x2, x3) - insert element x2 into set or table x1 if not already there."
" If x1 is a table, the assigned value for element x2 is x3."
" (always succeeds and returns x1)."

function{1} insert(s, x[n])
   type_case s of {

      set: {
         abstract {
            store[type(s).set_elem] = type(x).lst_elem
            return type(s)
            }

         body {
            tended union block *bp, *bp2;
            register uword hn;
            int res, argc;
            struct b_selem *se;
            register union block **pd;
	    
   	    MUTEX_LOCKBLK_CONTROLLED(BlkD(s, Set), "insert(): lock set");

	    for(argc=0;argc<n;argc++) {
	       bp = BlkLoc(s);
	       hn = hash(x+argc);
	       /*
		* If x is a member of set s then res will have the value 1,
		*  and pd will have a pointer to the pointer
		*  that points to that member.
		*  If x is not a member of the set then res will have
		*  the value 0 and pd will point to the pointer
		*  which should point to the member - thus we know where
		*  to link in the new element without having to do any
		*  repetitive looking.
		*/

	       /* get this now because can't tend pd */
	       Protect(se = alcselem(x+argc, hn), runerr(0));

	       pd = memb(bp, x+argc, hn, &res);
	       if (res == 0) {
		  /*
		   * The element is not in the set - insert it.
		   */
		  addmem((struct b_set *)bp, se, pd);
		  if (TooCrowded(bp))
		     hgrow(bp);
		  }
	       else
		  deallocate((union block *)se);

	       EVValD(&s, E_Sinsert);
	       EVValD(x+argc, E_Sval);
	       }
   	    MUTEX_UNLOCKBLK(BlkD(s, Set), "insert(): unlock set");
            return s;
            }
         }

      list: {
	 abstract {
	    store[type(s).lst_elem] = type(x).lst_elem
	    return type(s)
	    }
	 body {
	    tended struct b_list *hp; /* work in progress */
	    tended struct descrip d;
	    C_integer cnv_x;
            word i, j, size, argc;

#ifdef Arrays
	    if (BlkD(s,List)->listtail==NULL) 
	       if (arraytolist(&s)!=Succeeded) fail;
#endif					/* Arrays*/

   	    MUTEX_LOCKBLK_CONTROLLED(BlkD(s, List), "insert(): lock list");

	    for(argc=0;argc<n;argc+=2) {
	       hp = BlkD(s, List);
	       /*
		* Make sure that subscript x is in range.
		*/
	       if (!cnv:C_integer(x[argc], cnv_x)) {
		  if (cnv:integer(x[argc],x[argc])){
		     MUTEX_UNLOCKBLK(BlkD(s, List), "insert(): unlock list");
		     fail;
		     }
		  runerr(101, x[argc]);
		  }
	       size = hp->size;
	       i = cvpos((long)cnv_x, size);
	       if (i == CvtFail || i > size+1){
   	          MUTEX_UNLOCKBLK(BlkD(s, List), "insert(): unlock list");
		  fail;
		  }

	       /*
		* Perform i-1 rotations so that the position to be inserted
		* is at the front/back
		*/
	       for (j = 1; j < i; j++) {
		  c_get(hp, &d);
		  c_put(&s, &d);
		  }

	       /*
		* Put the element to insert on the back
		*/
	       if (argc+1 < n)
		  c_put(&s, x+argc+1);
	       else
		  c_put(&s, &nulldesc);

	       /*
		* Perform size - (i-1) more rotations to slide everything back
		* where it was originally
		*/
	       for (j = i; j <= size; j++) {
		  c_get(hp, &d);
		  c_put(&s, &d);
		  }
	       }
   	    MUTEX_UNLOCKBLK(BlkD(s, List), "insert(): unlock list");
	    return s;
	    }
         }
      table: {
         abstract {
            store[type(s).tbl_key] = type(x).lst_elem
            store[type(s).tbl_val] = type(x).lst_elem
            return type(s)
            }

         body {
	    tended union block *bp;
   	    MUTEX_LOCKBLK_CONTROLLED(BlkD(s, Table), "insert(): lock table");
	    bp = BlkLoc(s);
	    if (c_inserttable(&bp, n, x) == -1) runerr(0);
   	    MUTEX_UNLOCKBLK(BlkD(s, Table), "insert(): unlock table");
            return s;
            }
         }
#ifdef Dbm
      file: {
         abstract {
             return string
             }
	 body {
	    DBM *db;
	    datum key, content;
	    word status;
	    int argc, rv;

	    for(argc=0; argc<n; argc+=2) {
	       if (!cnv:string(x[argc],x[argc])) runerr(103, x[argc]);
	       if (argc+1 < n) {
		  if (!cnv:string(x[argc+1],x[argc+1])) runerr(103, x[argc+1]);
		  }
	       else runerr(103, nulldesc);
	       db = BlkD(s,File)->fd.dbm;
	       status = BlkD(s,File)->status;
	       if (!(status & Fs_Dbm))
		  runerr(122, s);
	       key.dptr = StrLoc(x[argc]);
	       key.dsize = StrLen(x[argc]);
	       content.dptr = StrLoc(x[argc+1]);
	       content.dsize = StrLen(x[argc+1]);
	       if ((rv=dbm_store(db, key, content, DBM_REPLACE)) < 0) {
		  fprintf(stderr, "dbm_store returned %d\n", rv);
		  fflush(stderr);
		  fail;
		  }
	       }
	    return s;
	 }
      }
#endif					/* Dbm */
      default:
         runerr(122, s);
      }
end

#if COMPILER
#define ClsInstSuffix "__mdw_inst_mdw"
#else
#define ClsInstSuffix "__state"
#endif /* COMPILER */

"classname(r) - get name of class for instance r"
function{0,1} classname(r)
   abstract {
      return string
      }
   body {
      char * recnm_bgn;
      char * recnm_end;
      char * first__;
      char * second__;
      struct b_record * br;

      if (!is:record(r)) {
	 fail;
	 }

      br = BlkD(r, Record);
      recnm_bgn = StrLoc(Blk(br->recdesc,Proc)->recname);
      if ((first__ = strstr(recnm_bgn, "__")) == NULL)
	 fail;
      second__ = strstr(first__ + 2, "__");
      if (second__ != NULL) recnm_bgn = first__ + 2;
      recnm_end = strstr(recnm_bgn, ClsInstSuffix);
      if (recnm_end > recnm_bgn) {
         StrLen(result) = recnm_end - recnm_bgn;
         StrLoc(result) = recnm_bgn;
         return result;
         }
      else
         fail;
      }
end

"membernames(r) - get list of the member vars for class instance r"
function{0,1} membernames(r)
   if is:string(r) then {
      abstract {
	 return new list(string)
	 }
      body {
	 /* construct the string for the class instance vector in sbuf */
	 char sbuf[MaxCvtLen];
	 tended struct b_list * p;
	 tended struct descrip d;
	 tended struct b_proc *pr;
	 register struct b_lelem * bp;
	 int i, j, n_flds;

	 for(i=0;i<StrLen(r);i++) sbuf[i] = StrLoc(r)[i];
	 strcpy(sbuf+i, "__state");
	 /* lookup the record type, given the class instance vector name */
	 i = getvar(sbuf, &d);
	 if (i == GlobalName) {
	    deref(&d, &d);
	    if (!is:proc(d)) runerr(131,d);
	    
	    pr = BlkD(d, Proc);
	    n_flds = pr->nfields;
	    j = 0;
	    if (strcmp("__s",StrLoc(pr->lnames[j])) == 0) {
	       j++; n_flds--;
	       }
	    if (strcmp("__m",StrLoc(pr->lnames[j])) == 0) {
	       j++; n_flds--;
	       }

	    Protect(p = alclist_raw(n_flds, n_flds), runerr(0));
	    bp = Blk(p->listhead,Lelem);
	    
	    for (i=0 ; i < n_flds; i++, j++) {
	       bp->lslots[i] = pr->lnames[j];
	       }
	    return list(p);
	    }
	 else {
	    fail;
	    }
	 }
      }
   else if !is:record(r) then
      runerr(107, r)
   else {
      abstract {
	 return new list(string)
	 }
      body {
	 register word i, n_flds;
	 tended struct b_list * p;
	 tended struct b_record * br;
	 register struct b_lelem * bp;

	 br = BlkD(r, Record);
	 n_flds = Blk(br->recdesc,Proc)->nfields;
	 Protect(p = alclist_raw(n_flds, n_flds), runerr(0));
	 bp = Blk(p->listhead,Lelem);
	 for (i=0; i<n_flds; i++)
	    bp->lslots[i] = br->recdesc->Proc.lnames[i];
	 return list(p);
	 }
      }
end

"methodnames(r) - get list of method names for class instance r"
function{1} methodnames(r, cooked_names)
   if !is:record(r) then
      if !is:string(r) then
         runerr(107, r)
   abstract {
      return new list(string)
      }
   body {
      tended struct b_list * p;
      union block * blk;
      register struct b_lelem * bp;
      register word i, k, n_mthds, n_glbls;
      word len;
      tended char *s;
      char * procname;

      if (is:record(r)) {
#if !COMPILER
      char * suffix;
#endif /* COMPILER */
      struct b_record * br;
      tended char * recnm_bgn;
      tended char * recnm_end;

      br = BlkD(r, Record);
      s = StrLoc(Blk(br->recdesc,Proc)->recname);
      recnm_end = strstr(s, ClsInstSuffix);
      len = recnm_end - s + 1;
      n_glbls = egnames - gnames;
      for (i=0,n_mthds=0; i<n_glbls; i++) {
         if (globals[i].dword != D_Proc)
            continue;
         blk = globals[i].vword.bptr;
         procname = StrLoc(Blk(blk,Proc)->pname);
         if (strncmp(procname, s, len))
            continue;
#if !COMPILER
         suffix = StrLoc(Blk(blk,Proc)->pname);
         suffix += (recnm_end - s);
         if (strcmp(suffix, "__state") == 0 || strcmp(suffix, "__methods") ==0)
            continue;
#endif					/* COMPILER */
         n_mthds++;
         }
      Protect(p = alclist_raw(n_mthds, n_mthds), runerr(0));
      bp = Blk(p->listhead,Lelem);
      for (i=0,k=0; i<n_glbls && k<n_mthds; i++) {
         if (globals[i].dword != D_Proc)
            continue;
         blk = globals[i].vword.bptr;
         if (strncmp(StrLoc(Blk(blk,Proc)->pname), s, len))
            continue;
#if !COMPILER
         suffix = StrLoc(blk->Proc.pname);
         suffix += (recnm_end - s);
         if (strcmp(suffix, "__state") == 0 || strcmp(suffix, "__methods") ==0)
            continue;
#endif					/* COMPILER */
         if (cooked_names.vword.integr) {
            bp->lslots[k].dword = StrLen(blk->Proc.pname) - len;
            bp->lslots[k].vword.sptr = StrLoc(blk->Proc.pname) + len;
            }
         else {
            bp->lslots[k] = blk->Proc.pname;
            }
         k++;
         }
      }
   else {
      if (!cnv:C_string(r, s))
	 runerr(103,r);

      len = strlen(s);
      n_glbls = egnames - gnames;
      for (i=0,n_mthds=0; i<n_glbls; i++) {
         if (globals[i].dword != D_Proc)
            continue;
         blk = globals[i].vword.bptr;
         if (StrLen(Blk(blk,Proc)->pname) <= len)
            continue;
         procname = StrLoc(blk->Proc.pname);
         if (strncmp(procname, s, len))
            continue;
         if (procname[len] != '_')
            continue;
#if !COMPILER
         if (strcmp(procname + len, "__state") == 0)
            continue;
         if (strcmp(procname + len, "__methods") == 0)
            continue;
#endif /* COMPILER */
         n_mthds++;
         }
      Protect(p = alclist_raw(n_mthds, n_mthds), runerr(0));
      bp = Blk(p->listhead,Lelem);
      for (i=0,k=0; i<n_glbls && k<n_mthds; i++) {
         if (globals[i].dword != D_Proc)
            continue;
         blk = globals[i].vword.bptr;
         if (StrLen(Blk(blk,Proc)->pname) <= len)
            continue;
         procname = StrLoc(blk->Proc.pname);
         if (strncmp(procname, s, len))
            continue;
         if (procname[len] != '_')
            continue;
#if !COMPILER
         if (strcmp(procname + len, "__state") == 0)
            continue;
         if (strcmp(procname + len, "__methods") == 0)
            continue;
#endif /* COMPILER */
         if (cooked_names.vword.integr) {
            bp->lslots[k].dword = StrLen(blk->Proc.pname) - len - 1;
            bp->lslots[k].vword.sptr = procname + len + 1;
            }
         else {
            bp->lslots[k] = blk->Proc.pname;
            }
         k++;
         }
      }
      return list(p);
      }
end

"methods(r) - get list of methods for class instance r"
function{1} methods(r)
   declare {
      union block * blk;
      tended struct b_list * p;
      register word i, k, n_glbls, n_mthds;
      register struct b_lelem * bp;
      }
   abstract {
      return new list(proc)
      }

   type_case r of {
      record:
	 body {
      char * suffix;
      unsigned recnm_len;
      struct b_record * br;
      tended char * recnm_bgn;
      tended char * recnm_end;

      br = BlkD(r, Record);
      recnm_bgn = StrLoc(Blk(br->recdesc, Proc)->recname);
      recnm_end = strstr(recnm_bgn, ClsInstSuffix);
      recnm_len = recnm_end - recnm_bgn + 1;
      n_glbls = egnames - gnames;
      for (i=0,n_mthds=0; i<n_glbls; i++) {
         if (globals[i].dword != D_Proc)
            continue;
         blk = globals[i].vword.bptr;
         if (strncmp(StrLoc(Blk(blk,Proc)->pname), recnm_bgn, recnm_len))
            continue;
#if !COMPILER
      suffix = StrLoc(Blk(blk,Proc)->pname);
      suffix += (recnm_end - recnm_bgn);
      if (strcmp(suffix, "__state") == 0 || strcmp(suffix, "__methods") == 0)
         continue;
#endif /* COMPILER */
         n_mthds++;
         }
      Protect(p = alclist_raw(n_mthds, n_mthds), runerr(0));
      bp = (struct b_lelem *)p->listhead;
      for (i=0,k=0; i<n_glbls && k<n_mthds; i++) {
         if (globals[i].dword != D_Proc)
            continue;
         blk = globals[i].vword.bptr;
         if (strncmp(StrLoc(Blk(blk,Proc)->pname), recnm_bgn, recnm_len))
            continue;
#if !COMPILER
      suffix = StrLoc(blk->Proc.pname);
      suffix += (recnm_end - recnm_bgn);
      if (strcmp(suffix, "__state") == 0 || strcmp(suffix, "__methods") == 0)
         continue;
#endif /* COMPILER */
         bp->lslots[k].dword = D_Proc;
         bp->lslots[k].vword.bptr = blk;
         k++;
         }
      return list(p);
      }
      string:
	 body {
      word len;
      char * procname;
      tended char *s;

      if (!cnv:C_string(r, s))
	 runerr(103, r);
      len = StrLen(r);
      n_glbls = egnames - gnames;
      for (i=0,n_mthds=0; i<n_glbls; i++) {
         if (globals[i].dword != D_Proc)
            continue;
         blk = globals[i].vword.bptr;
         if (StrLen(Blk(blk,Proc)->pname) <= len)
            continue;
         procname = StrLoc(blk->Proc.pname);
         if (strncmp(procname, s, len))
            continue;
         if (procname[len] != '_')
            continue;
#if !COMPILER
         if (strcmp(procname + len, "__state") == 0)
            continue;
         if (strcmp(procname + len, "__methods") == 0)
            continue;
#endif /* COMPILER */
         n_mthds++;
         }
      Protect(p = alclist_raw(n_mthds, n_mthds), runerr(0));
      bp = Blk(p->listhead,Lelem);
      for (i=0,k=0; i<n_glbls && k<n_mthds; i++) {
         if (globals[i].dword != D_Proc)
            continue;
         blk = globals[i].vword.bptr;
         if (StrLen(Blk(blk,Proc)->pname) <= len)
            continue;
         procname = StrLoc(blk->Proc.pname);
         if (strncmp(procname, s, len))
            continue;
         if (procname[len] != '_')
            continue;
#if !COMPILER
         if (strcmp(procname + len, "__state") == 0)
            continue;
         if (strcmp(procname + len, "__methods") == 0)
            continue;
#endif /* COMPILER */
         bp->lslots[k].dword = D_Proc;
         bp->lslots[k].vword.bptr = blk;
         k++;
         }
      return list(p);
      }
      default: {
	 runerr(107, r)
	 }
	 }
end

"methods_fromstr(s) - get list of methods for class instance r"
function{1} methods_fromstr(s)
   if !cnv:C_string(s) then
      runerr(103,s)
   abstract {
      return new list(proc)
      }
   body {
      word len;
      char * procname;
      union block * blk;
      tended struct b_list * p;
      register struct b_lelem * bp;
      register word i, k, n_glbls, n_mthds;

      len = strlen(s);
      n_glbls = egnames - gnames;
      for (i=0,n_mthds=0; i<n_glbls; i++) {
         if (globals[i].dword != D_Proc)
            continue;
         blk = globals[i].vword.bptr;
         if (StrLen(Blk(blk,Proc)->pname) <= len)
            continue;
         procname = StrLoc(blk->Proc.pname);
         if (strncmp(procname, s, len))
            continue;
         if (procname[len] != '_')
            continue;
#if !COMPILER
         if (strcmp(procname + len, "__state") == 0)
            continue;
         if (strcmp(procname + len, "__methods") == 0)
            continue;
#endif /* COMPILER */
         n_mthds++;
         }
      Protect(p = alclist_raw(n_mthds, n_mthds), runerr(0));
      bp = Blk(p->listhead,Lelem);
      for (i=0,k=0; i<n_glbls && k<n_mthds; i++) {
         if (globals[i].dword != D_Proc)
            continue;
         blk = globals[i].vword.bptr;
         if (StrLen(Blk(blk,Proc)->pname) <= len)
            continue;
         procname = StrLoc(blk->Proc.pname);
         if (strncmp(procname, s, len))
            continue;
         if (procname[len] != '_')
            continue;
#if !COMPILER
         if (strcmp(procname + len, "__state") == 0)
            continue;
         if (strcmp(procname + len, "__methods") == 0)
            continue;
#endif /* COMPILER */
         bp->lslots[k].dword = D_Proc;
         bp->lslots[k].vword.bptr = blk;
         k++;
         }
      return list(p);
      }
end

"oprec(r) - get the operations record for class instance r"
function{0,1} oprec(r)
   abstract {
      return variable
      }
   body {
      tended char * s;
      char * p;
      register word i, len, n_glbls;

      if (is:record(r)) {
	 char * recnm_end;
	 struct b_record * br;
	 br = BlkD(r, Record);
	 s = StrLoc(Blk(br->recdesc,Proc)->recname);
	 recnm_end = strstr(s, ClsInstSuffix);
	 len = recnm_end - s;
	 }
      else {
	 if (!cnv:C_string(r, s))
	    runerr(103, r);
	 len = strlen(s);
	 }
      n_glbls = egnames - gnames;
      for (i=0; i<n_glbls; i++) {
	 p = StrLoc(gnames[i]);
	 if (strncmp(s, p, len))
	    continue;
	 p += len;
	 if (strncmp(p, "__oprec", 7) == 0)
	    break;
	 }
      if (i < n_glbls) {
	 result.dword = D_Var;
	 VarLoc(result) = (dptr)&globals[i];
	 return result;
	 }
      else fail;
      }
end

"list(i, x) - create a list of size i, with initial value x."

function{1} list(n, x)
   if is:set(n) then {
      abstract {
         return new list(store[type(n).set_elem])
         }
      body {
         struct descrip d;
         cnv_list(&n, &d); /* can't fail, already know n is a set */
         return d;
         }
      }
#ifdef Arrays
   else if is:list(n) then {
     abstract { return type(n) }
     inline { return listtoarray(&n); }
    }
#endif  /* Arrays */
   else {

   if !def:C_integer(n, 0L) then
     runerr(101, n)

   abstract {
      return new list(type(x))
      }

   body {
      tended struct b_list *hp;
      register word i, size;
      word nslots;
      register struct b_lelem *bp; /* does not need to be tended */

      nslots = size = n;

      /*
       * Ensure that the size is positive and that the
       *  list-element block has at least MinListSlots slots.
       */
      if (size < 0) {
         irunerr(205, n);
         errorfail;
         }
      if (nslots == 0)
         nslots = MinListSlots;
#ifdef Arrays
      else { /* Check to see if making an array is feasible */
        type_case x of {
        integer: {
            word *ip;
            Protect(hp = alclisthdr(size,(union block *)alcintarray(size)), runerr(0));
            /* initialize all elements to x */
            ip = &((union block *)hp)->List.listhead->Intarray.a[0];
            i = x.vword.integr;
            while (size-- > 0) {*ip++ = i;}

            return list(hp);    /* return the new array of integer values */
          }

        real: {
            double *rp, rval;
            Protect(hp = alclisthdr(size,(union block *)alcrealarray(size)), runerr(0));
            /* initialize all elements to x */
            rp = &((union block *)hp)->List.listhead->Realarray.a[0];
#ifdef DescriptorDouble
            rval = x.vword.realval;
#else                     /* DescriptorDouble */
            rval = x.vword.bptr->Real.realval;
#endif                    /* DescriptorDouble */
            while (size-- > 0) {*rp++ = rval;}

            return list(hp);    /* return the new array of real values */
          }

        /* If the type of x is neither integer nor real, drop through */
        default: {}
        } /* type_case x */
      }
#endif  /* Arrays */

      /*
       * Allocate the list-header block and a list-element block.
       *  Note that nslots is the number of slots in the list-element
       *  block while size is the number of elements in the list.
       */
      Protect(hp = alclist_raw(size, nslots), runerr(0));
      bp = (struct b_lelem *)hp->listhead;

      /*
       * Initialize each slot.
       */
      for (i = 0; i < size; i++)
         bp->lslots[i] = x;

      Desc_EVValD(hp, E_Lcreate, D_List);

      /*
       * Return the new list.
       */
      return list(hp);
      }
   }
end


"member(x1, x2) - returns x1 if x2 ... are members of x1 but fails otherwise."
"x1 may be a set, cset, table, list, database file or record."

function{0,1} member(s, x[n])
   type_case s of {
      record: {
         abstract {
            return type(s)
            }
         inline {
           C_integer i=0, sz = Blk(BlkD(s,Record)->recdesc,Proc)->nfields;
           C_integer j, k, ismatched, nmatched=0;
           if (n==0) fail;

           for(i=0; i<n; i++) {
              struct descrip s1;
              if (!cnv:string(x[i], s1)) runerr(103, s1);
              for(j=0;j<sz;j++) {
                 struct descrip s2 =
                    Blk(BlkD(s,Record)->recdesc,Proc)->lnames[j];
                 if (StrLen(s1) != StrLen(s2)) fail;
                 ismatched = 1;
                 for (k=0; k<StrLen(s1); k++)
                    if (StrLoc(s1)[k] != StrLoc(s2)[k]) {
                       ismatched = 0; break;
                       }
                 if (ismatched) { nmatched++; break; }
                 }
            }
         if (nmatched == n) return s;
         fail;
         }
       }
      set: {
         abstract {
            return type(x) ** store[type(s).set_elem]
            }
         inline {
            int res, argc;
            register uword hn;

	    for(argc=0; argc<n; argc++) {
	       EVValD(&s, E_Smember);
	       EVValD(x+argc, E_Sval);

	       hn = hash(x+argc);
	       memb(BlkLoc(s), x+argc, hn, &res);
	       if (res==0)
		  fail;
	       }
	    return x[n-1];
            }
         }
      table: {
         abstract {
            return type(x) ** store[type(s).tbl_key]
            }
         inline {
            int res, argc;
            register uword hn;

	    for(argc=0; argc<n; argc++) {
	       EVValD(&s, E_Tmember);
	       EVValD(x+argc, E_Tsub);

	       hn = hash(x+argc);
	       memb(BlkLoc(s), x+argc, hn, &res);
	       if (res == 0)
		  fail;
	       }
	    return x[n-1];
            }
         }
      list: {
	 abstract {
	    return store[type(x).lst_elem]
	    }
	 inline {
	    int argc, size;
	    C_integer cnv_x;
	    size = BlkD(s,List)->size;
	    for(argc=0; argc<n; argc++) {
	       if (!(cnv:C_integer(x[argc], cnv_x))) fail;
	       cnv_x = cvpos(cnv_x, size);
	       if ((cnv_x == CvtFail) || (cnv_x > size)) fail;
	       }
	    return x[n-1];
	    }
	 }
      cset: {
	 abstract {
	    return cset
	    }
	 body {
            int argc, i;
	    for(argc=0; argc<n; argc++) {
	       if (!(cnv:string(x[argc], x[argc]))) fail;
	       for(i=0; i<StrLen(x[argc]); i++)
		  if (!Testb(StrLoc(x[argc])[i], s)) fail;
	       }
	    return s;
	    }
	 }
#ifdef Dbm
      file: {
	 abstract {
	    return string
	 }
         body {
	    DBM *db;
	    datum key, content;
	    word status, argc;

	    for(argc=0; argc<n; argc++) {
	       if (!cnv:string(x[argc], x[argc]) )
		   runerr(103,x[argc]);

	       status = BlkD(s,File)->status;
	       if (!(status & Fs_Dbm))
		  runerr(122, s);
	       db = BlkD(s,File)->fd.dbm;
	       key.dptr = StrLoc(x[argc]);
	       key.dsize = StrLen(x[argc]);
	       content = dbm_fetch(db, key);
	       if (content.dptr == NULL)
		  fail;
	       }
	    return x[n-1];
	 }
      }
#endif					/* Dbm */
      default:
         runerr(122, s)
   }
end


"pull(L,n) - pull an element from end of list L."

function{0,1} pull(x,n)
   if !def:C_integer(n, 1L) then
      runerr(101, n)
   /*
    * x must be a list.
    */
   if !is:list(x) then
      runerr(108, x)
   abstract {
      return store[type(x).lst_elem]
      }

   body {
      register word i, j;
      register struct b_list *hp;
      register struct b_lelem *bp;

      if (n <= 0)
      	 fail;
	 
#ifdef Arrays
      if (BlkD(x,List)->listtail==NULL) 
	 if (arraytolist(&x)!=Succeeded) fail;
#endif					/* Arrays*/
      
      MUTEX_LOCKBLK_CONTROLLED(BlkD(x, List), "pull(): lock list");

      for(j=0;j<n;j++) {
	 EVValD(&x, E_Lpull);

	 /*
	  * Point at list header block and fail if the list is empty.
	  */
         hp = BlkD(x, List);
	 if (hp->size <= 0){
   	    MUTEX_UNLOCKBLK(hp, "pull(): unlock list");
 	    fail;
	    }

	 /*
	  * Point bp at the last list element block.  If the last block has no
	  *  elements in use, point bp at the previous list element block.
	  */
	 bp = (struct b_lelem *) hp->listtail;
	 if (bp->nused <= 0) {
	    bp = (struct b_lelem *) bp->listprev;
	    hp->listtail = (union block *) bp;
	    bp->listnext = (union block *) hp;
	    }

	 /*
	  * Set i to position of last element and assign the element to
	  *  result for return.  Decrement the usage count for the block
	  *  and the size of the list.
	  */
	 i = bp->first + bp->nused - 1;
	 if (i >= bp->nslots)
	    i -= bp->nslots;
	 result = bp->lslots[i];
	 bp->nused--;
	 hp->size--;
	 }
      MUTEX_UNLOCKBLK(hp, "pull(): unlock list");
      return result;
      }
end


/*
 * c_push - C-level, nontending push operation
 */
void c_push(l, val)
dptr l;
dptr val;
{
   register word i = 0;
   register struct b_lelem *bp; /* does not need to be tended */
   static int two = 2;		/* some compilers generate bad code for
				   division by a constant that's a power of 2*/
#ifdef Arrays
   if (BlkD(*l,List)->listtail==NULL) 
      if (arraytolist(l)!=Succeeded) return;
#endif					/* Arrays*/

   /*
    * Point bp at the first list-element block.
    */

   bp = Blk(BlkD(*l,List)->listhead, Lelem);

   /*
    * If the first list-element block is full, allocate a new
    *  list-element block, make it the first list-element block,
    *  and make it the previous block of the former first list-element
    *  block.
    */
   if (bp->nused >= bp->nslots) {
      /*
       * Set i to the size of block to allocate.
       */
      i = BlkD(*l, List)->size / two;
      if (i < MinListSlots)
         i = MinListSlots;
#ifdef MaxListSlots
      if (i > MaxListSlots)
         i = MaxListSlots;
#endif					/* MaxListSlots */

      /*
       * Allocate a new list element block.  If the block can't
       *  be allocated, try smaller blocks.
       */
      while ((bp = alclstb(i, (word)0, (word)0)) == NULL) {
         i /= 4;
         if (i < MinListSlots) fatalerr(0, NULL);
         }

      Blk(BlkD(*l, List)->listhead, Lelem)->listprev = (union block *)bp;
      bp->listprev = BlkLoc(*l);
      bp->listnext = BlkD(*l,List)->listhead;
      BlkLoc(*l)->List.listhead = (union block *) bp;
      }

   /*
    * Set i to position of new first element and assign val to
    *  that element.
    */
   i = bp->first - 1;
   if (i < 0)
      i = bp->nslots - 1;
   bp->lslots[i] = *val;
   /*
    * Adjust value of location of first element, block usage count,
    *  and current list size.
    */
   bp->first = i;
   bp->nused++;
   BlkLoc(*l)->List.size++;
   }



"push(L, x1, ..., xN) - push x onto beginning of list L."

function{1} push(x, vals[n])
   /*
    * x must be a list.
    */
   if !is:list(x) then
      runerr(108, x)
   abstract {
      store[type(x).lst_elem] = type(vals)
      return type(x)
      }

   body {
      tended struct b_list *hp;
      dptr dp;
      register word i, val, num;
      register struct b_lelem *bp; /* does not need to be tended */
      static int two = 2;	/* some compilers generate bad code for
				   division by a constant that's a power of 2*/

#ifdef Arrays
      if (BlkD(x,List)->listtail==NULL) 
	 if (arraytolist(&x)!=Succeeded) fail;
#endif					/* Arrays*/


      if (n == 0) {
	 dp = &nulldesc;
	 num = 1;
	 }
      else {
	 dp = vals;
	 num = n;
	 }

      MUTEX_LOCKBLK_CONTROLLED(BlkD(x, List), "push(): lock list");

      for (val = 0; val < num; val++) {
	 /*
	  * Point hp at the list-header block and bp at the first
	  *  list-element block.
	  */
	 hp = BlkD(x, List);
	 bp = Blk(hp->listhead, Lelem);

	 /*
	  * Initialize i so it's 0 if first list-element.
	  */
	 i = 0;			/* block isn't full */

	 /*
	  * If the first list-element block is full, allocate a new
	  *  list-element block, make it the first list-element block,
	  *  and make it the previous block of the former first list-element
	  *  block.
	  */
	 if (bp->nused >= bp->nslots) {
	    /*
	     * Set i to the size of block to allocate.
	     */
	    i = hp->size / two;
	    if (i < MinListSlots)
	       i = MinListSlots;
#ifdef MaxListSlots
	    if (i > MaxListSlots)
	       i = MaxListSlots;
#endif					/* MaxListSlots */

	    /*
	     * Allocate a new list element block.  If the block can't
	     *  be allocated, try smaller blocks.
	     */
	    while ((bp = alclstb(i, (word)0, (word)0)) == NULL) {
	       i /= 4;
	       if (i < MinListSlots)
		  runerr(0);
	       }

	    Blk(hp->listhead, Lelem)->listprev = (union block *)bp;
	    bp->listprev = (union block *) hp;
	    bp->listnext = hp->listhead;
	    hp->listhead = (union block *) bp;
	    }

	 /*
	  * Set i to position of new first element and assign val to
	  *  that element.
	  */
	 i = bp->first - 1;
	 if (i < 0)
	    i = bp->nslots - 1;
	 bp->lslots[i] = dp[val];
	 /*
	  * Adjust value of location of first element, block usage count,
	  *  and current list size.
	  */
	 bp->first = i;
	 bp->nused++;
	 hp->size++;
	 }

      MUTEX_UNLOCKBLK(hp, "push(): unlock list");

      EVValD(&x, E_Lpush);

      /*
       * Return the list.
       */
      return x;
      }
end


/*
 * c_put - C-level, nontending list put function
 */
void c_put(struct descrip *l, struct descrip *val)
{
   register word i = 0;
   register struct b_lelem *bp;  /* does not need to be tended */
   static int two = 2;		/* some compilers generate bad code for
				   division by a constant that's a power of 2*/

   /*
    * Point bp at the last list-element block.
    */

   bp = Blk(BlkD(*l,List)->listtail, Lelem);
   
   /*
    * If the last list-element block is full, allocate a new
    *  list-element block, make it the last list-element block,
    *  and make it the next block of the former last list-element
    *  block.
    */
   if (bp->nused >= bp->nslots) {
      /*
       * Set i to the size of block to allocate.
       */
      i = BlkD(*l, List)->size / two;
      if (i < MinListSlots)
         i = MinListSlots;
#ifdef MaxListSlots
      if (i > MaxListSlots)
         i = MaxListSlots;
#endif					/* MaxListSlots */

      /*
       * Allocate a new list element block.  If the block
       *  can't be allocated, try smaller blocks.
       */
      while ((bp = alclstb(i, (word)0, (word)0)) == NULL) {
         i /= 4;
         if (i < MinListSlots) fatalerr(0, NULL);
         }

      Blk(BlkD(*l,List)->listtail,Lelem)->listnext = (union block *) bp;
      bp->listprev = BlkD(*l,List)->listtail;
      bp->listnext = BlkLoc(*l);
      BlkD(*l,List)->listtail = (union block *) bp;
      }

   /*
    * Set i to position of new last element and assign val to
    *  that element.
    */
   i = bp->first + bp->nused;
   if (i >= bp->nslots)
      i -= bp->nslots;
   bp->lslots[i] = *val;

   /*
    * Adjust block usage count and current list size.
    */
   bp->nused++;
   BlkD(*l, List)->size++;
}


"put(L, x1, ..., xN) - put elements onto end of list L."

function{1} put(x, vals[n])
   /*
    * x must be a list.
    */
   if !is:list(x) then
      runerr(108, x)
   abstract {
      store[type(x).lst_elem] = type(vals)
      return type(x)
      }

   body {
      tended struct b_list *hp;
      dptr dp;
      register word i, val, num;
      register struct b_lelem *bp;  /* does not need to be tended */
      static int two = 2;	/* some compilers generate bad code for
				   division by a constant that's a power of 2*/
#ifdef Arrays
	    if (BlkD(x,List)->listtail==NULL) 
	       if (arraytolist(&x)!=Succeeded) fail;
#endif					/* Arrays*/

      if (n == 0) {
	 dp = &nulldesc;
	 num = 1;
	 }
      else {
	 dp = vals;
	 num = n;
	 }

      MUTEX_LOCKBLK_CONTROLLED(BlkD(x,List), "put(): lock list");

      /*
       * Point hp at the list-header block and bp at the last
       *  list-element block.
       */
      for(val = 0; val < num; val++) {
	 hp = BlkD(x, List);
	 bp = Blk(hp->listtail, Lelem);
   
	 i = 0;			/* block isn't full */

	 /*
	  * If the last list-element block is full, allocate a new
	  *  list-element block, make it the last list-element block,
	  *  and make it the next block of the former last list-element
	  *  block.
	  */
	 if (bp->nused >= bp->nslots) {
	    /*
	     * Set i to the size of block to allocate.
	     *  Add half the size of the present list, subject to
	     *  minimum and maximum and including enough space for
	     *  the rest of this call to put() if called with varargs.
	     */
	    i = hp->size / two;
	    if (i < MinListSlots)
	       i = MinListSlots;
	    if (i < n - val)
	       i = n - val;
#ifdef MaxListSlots
	    if (i > MaxListSlots)
	       i = MaxListSlots;
#endif					/* MaxListSlots */
	    /*
	     * Allocate a new list element block.  If the block can't
	     *  be allocated, try smaller blocks.
	     */
	    while ((bp = alclstb(i, (word)0, (word)0)) == NULL) {
	       i /= 4;
	       if (i < MinListSlots)
		  runerr(0);
	       }

	    Blk(hp->listtail, Lelem)->listnext = (union block *) bp;
	    bp->listprev = hp->listtail;
	    bp->listnext = (union block *) hp;
	    hp->listtail = (union block *) bp;
	    }

	 /*
	  * Set i to position of new last element and assign val to
	  *  that element.
	  */
	 i = bp->first + bp->nused;
	 if (i >= bp->nslots)
	    i -= bp->nslots;
	 bp->lslots[i] = dp[val];

	 /*
	  * Adjust block usage count and current list size.
	  */
	 bp->nused++;
	 hp->size++;

	 }

      MUTEX_UNLOCKBLK(hp, "put(): unlock list");

      EVValD(&x, E_Lput);

      /*
       * Return the list.
       */
      return x;
      }
end


/*
 * C language set insert.  pps must point to a tended block pointer.
 * pe can't be tended, so allocate before, and deallocate if unused.
 * returns: 0 = yes it was inserted, -1 = runtime error, 1 = already there.
 */
#begdef C_SETINSERT(ps, pd, res)
{
   register uword hn;
   union block **pe;
   struct b_selem *ne;			/* does not need to be tended */
   tended struct descrip d;

   d = *pd;
   if ((ne = alcselem(&nulldesc, (uword)0))) {
      pe = memb(ps, &d, hn = hash(&d), &res);
      if (res==0) {
         ne->setmem = d;			/* add new element */
         ne->hashnum = hn;
         addmem((struct b_set *)ps, ne, pe);
         }
      else deallocate((union block *)ne);
      }
   else res = -1;
   res = 0;
}
#enddef

int c_insertset(union block **pps, dptr pd)
{
   int rv;
   C_SETINSERT(*pps, pd, rv);
   return rv;
}

"set(L) - create a set with members in list L."
"  The members are linked into hash chains which are"
" arranged in increasing order by hash number."

function{1} set(x[n])

   len_case n of {
      0: {
         abstract {
            return new set(empty_type)
            }
         inline {
            register union block * ps;
            ps = hmake(T_Set, (word)0, (word)0);
            if (ps == NULL)
               runerr(0);
	    Desc_EVValD(ps, E_Screate, D_Set);
            return set(ps);
            }
         }

      default: {
         abstract {
            return new set(type(x)) /* ?? */
/*            return new set(store[type(x).lst_elem]) /* should be anything */
            }

         body {
            tended union block *pb, *ps;
            word i, j;
	    int arg, res;

	    /*
	     * Make a set.
             */
            if (is:list(x[0])) i = BlkD(x[0],List)->size;
            else i = n;
            ps = hmake(T_Set, (word)0, i);
            if (ps == NULL) {
               runerr(0);
               }

	    for (arg = 0; arg < n; arg++) {
	      if (is:list(x[arg])) {
		pb = BlkLoc(x[arg]);
                if(!(reserve(Blocks,
                     Blk(pb,List)->size * (2*sizeof(struct b_selem))))){
                   runerr(0);
                   }
		/*
		 * Chain through each list block and for
		 *  each element contained in the block
		 *  insert the element into the set if not there.
		 */
		for (pb = Blk(pb,List)->listhead;
		     pb && (BlkType(pb) == T_Lelem);
		     pb = Blk(pb,Lelem)->listnext) {
		  for (i = 0; i < Blk(pb,Lelem)->nused; i++) {
#ifdef Polling
            if (!pollctr--) {
               pollctr = pollevent();
	       if (pollctr == -1) fatalerr(141, NULL);
	       }	       
#endif					/* Polling */
		    j = Blk(pb,Lelem)->first + i;
		    if (j >= Blk(pb,Lelem)->nslots)
		      j -= pb->Lelem.nslots;
		    C_SETINSERT(ps, &(pb->Lelem.lslots[j]), res);
                    if (res == -1) {
                       runerr(0);
                       }
                    }
		}
	      }
	      else {
		if (c_insertset(&ps, & (x[arg])) == -1) {
                   runerr(0);
                   }
	      }
	    }
	    Desc_EVValD(ps, E_Screate, D_Set);
            return set(ps);
	    }
         }
      }
end


"table(k, v, ..., x) - create a table with default value x."

function{1} table(x[n])
   abstract {
      return new table(empty_type, empty_type, type(x))
      }
   inline {
      tended union block *bp;
   
      bp = hmake(T_Table, (word)0, (word)n);
      if (bp == NULL)
         runerr(0);
      if (n > 1) {
      	 /*
	  * if n is odd then the last value is the table's default value
	  * the actual key-value pairs end at n-1 (n-n%2 below)
	  */
	  if (c_inserttable(&bp, n - n % 2, x) == -1) runerr(0);
 	 }
      if (n % 2)
	 bp->Table.defvalue = x[n-1];
      else bp->Table.defvalue = nulldesc;

      Desc_EVValD(bp, E_Tcreate, D_Table);
      return table(bp);
      }
end


"constructor(label, field, field...) - produce a new record constructor"

function{1} constructor(s, x[n])
   abstract {
      return proc
	}
   if !cnv:string(s) then runerr(103,s)
   inline {
      int i;
      struct b_proc *bp;
      for(i=0;i<n;i++)
         if (!is:string(x[i])) runerr(103, x[i]);
      bp = dynrecord(&s, x, n);
      if (bp == NULL) syserr("out of memory in constructor()");
      return proc(bp);
      }
end

#ifdef Arrays

/*
 * array(dim1,...,dimN,initvalue) allocate an array.
 */
function{1} array(x[n])
   abstract {
      return new list(integer++real)
      }
   body {
      tended struct descrip d;
      struct b_intarray *dims = NULL;
      word *a_ip;
      double dv, *a_dp;
      C_integer ci;
      int num = 1;
      int i;
      int bsize;
      int i_or_real = 0;

      if( n>2 ){
      	 fprintf(stderr,
	   "multi-dimensional array support has not been added yet\n");
	 runerr(101, x[2]);
         }

      /*
       * Prepare dimensions.
       * Calculate total # of elements for n-dimensional array.
       */
      for(i=0;i<n-1;i++){
	 if (!cnv:C_integer(x[i], ci)) runerr(101, x[i]);
	 if (!is:integer(x[i])) MakeInt(ci, &(x[i]));
	 }
      for(i=0;i<n-1;i++) num *= IntVal(x[i]);

      /*
       * Decide whether we are doing the IntArray or RealArray.
       */
      if (cnv:(exact)C_integer(x[n-1], ci)) {
	 i_or_real = 1; /* integer */
	 bsize = sizeof(struct b_intarray) + (n-1) * sizeof(word);
	 if (!is:integer(x[i])) MakeInt(ci, &(x[i]));
	 }
      else if (cnv:C_double(x[n-1], dv)) {
	 i_or_real = 2; /* real */
	 bsize = sizeof(struct b_realarray) + (n-1) * sizeof(double);
	 }
      else if (is:list(x[n-1])) {
	 /* get the first element of x[n-1], use it to set i_or_real */
	 if (cplist2realarray(&x[n-1], &d, 0, BlkD(x[n-1],List)->size, 0) !=
	     Succeeded)
	    runerr(102, x[n-1]);
	 return d;
	 }
      else runerr(102, x[n-1]);

      /*
       * reserve # of bytes for both header and array block
       */
      if (!reserve(Blocks, (word)(sizeof(struct b_list) + bsize))) runerr(0);

      d.vword.bptr = (union block *) alclisthdr(num,
         ((i_or_real == 1) ? ((union block *)alcintarray(num)) :
			     ((union block *)alcrealarray(num))));
      d.dword = D_List;

      if (n>2) {
	 dims = alcintarray(n-1);
	 for (i=0;i<n-1;i++) dims->a[i] = IntVal(x[i]);
	 if (i_or_real == 1)
	    d.vword.bptr->List.listhead->Intarray.dims = (union block *)dims;
	 else
	    d.vword.bptr->List.listhead->Realarray.dims = (union block *)dims;
	 }

      if (i_or_real == 1) {
	 a_ip = d.vword.bptr->List.listhead->Intarray.a;
	 for(i=0; i<num; i++) a_ip[i] = IntVal(x[n-1]);
	 }
      else {
	 a_dp = d.vword.bptr->List.listhead->Realarray.a;
	 for(i=0; i<num; i++) a_dp[i] = dv;
	 }

      return d;
      }
end
#else					/* Arrays */
MissingFuncV(array)
#endif					/* Arrays */
