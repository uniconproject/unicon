/*
 *  fmonitr.r -- EvSend, EvGet
 *
 *   This file contains execution monitoring code, used only if EventMon
 *   (event monitoring) or some of its constituent events is defined.
 *   There used to be a separate virtual machine with all events defined,
 *   but the current setup allows specific events to be defined, and
 *   monitoring is unified into the main virtual machine.
 *
 *   When EventMon is undefined, most of the "MMxxxx" and "EVxxxx"
 *   entry points are defined as null macros in monitor.h.  See
 *   monitor.h for important definitions.
 */


#ifdef MultiProgram
/*
 * EvSend(x, y, C) -- formerly event(); generate an event at the program level.
 */

"EvSend(x, y, C) - send event with event code x and event value y."

function{0,1} EvSend(x,y,ce)
   body {
      struct progstate *dest = NULL;

      if (is:null(x)) {
	 x = curpstate->eventcode;
	 if (is:null(y)) y = curpstate->eventval;
	 }
      if (is:null(ce) && is:coexpr(curpstate->parentdesc))
	 ce = curpstate->parentdesc;
      else if (!is:coexpr(ce)) runerr(118,ce);
      dest = BlkD(ce,Coexpr)->program;
      dest->eventcode = x;
      dest->eventval = y;
      if (mt_activate(&(dest->eventcode),&result,BlkD(ce,Coexpr))==A_Cofail)
         fail;
      return result;
      }
end

void assign_event_functions(struct progstate *p, struct descrip cs)
{
   p->eventmask = cs;

   /*
    * Most instrumentation functions depend on a single event.
    */
   p->Cplist =
      ((Testb((word)ToAscii(E_Lcreate), cs)) ? cplist_1 : cplist_0);
   p->Cpset =
      ((Testb((word)ToAscii(E_Screate), cs)) ? cpset_1 : cpset_0);
   p->Cptable =
      ((Testb((word)ToAscii(E_Tcreate), cs)) ? cptable_1 : cptable_0);
   p->Deref =
      ((Testb((word)ToAscii(E_Deref), cs)) ? deref_1 : deref_0);
#ifdef LargeInts
   p->Alcbignum =
      ((Testb((word)ToAscii(E_Lrgint),cs)) ? alcbignum_1:alcbignum_0);
#endif					/* LargeInts */
   p->Alccset =
      ((Testb((word)ToAscii(E_Cset), cs)) ? alccset_1 : alccset_0);
#undef alcfile
   p->Alcfile =
      ((Testb((word)ToAscii(E_File), cs)) ? alcfile_1 : alcfile);
   p->Alcsegment =
      ((Testb((word)ToAscii(E_Slots), cs)) ? alcsegment_1 : alcsegment_0);
#ifdef PatternType
   p->Alcpattern =
       ((Testb((word)ToAscii(E_Pattern), cs)) ? alcpattern_1 : alcpattern_0);
   p->Alcpelem =
       ((Testb((word)ToAscii(E_Pelem), cs)) ? alcpelem_1 : alcpelem_0);
#endif					/* PatternType */
#undef alcreal
#ifndef DescriptorDouble
   p->Alcreal =
      ((Testb((word)ToAscii(E_Real), cs)) ? alcreal_1 : alcreal);
#endif					/* DescriptorDouble */
   p->Alcrecd =
      ((Testb((word)ToAscii(E_Record), cs)) ? alcrecd_1 : alcrecd_0);
   p->Alcrefresh =
      ((Testb((word)ToAscii(E_Refresh), cs)) ? alcrefresh_1 : alcrefresh_0);
   p->Alcselem =
      ((Testb((word)ToAscii(E_Selem), cs)) ? alcselem_1 : alcselem_0);
#undef alcstr
   p->Alcstr =
      ((Testb((word)ToAscii(E_String), cs)) ? alcstr_1 : alcstr);
   p->Alcsubs =
      ((Testb((word)ToAscii(E_Tvsubs), cs)) ? alcsubs_1 : alcsubs_0);
   p->Alctelem =
      ((Testb((word)ToAscii(E_Telem), cs)) ? alctelem_1 : alctelem_0);
   p->Alctvtbl =
      ((Testb((word)ToAscii(E_Tvtbl), cs)) ? alctvtbl_1 : alctvtbl_0);
   p->Deallocate =
      ((Testb((word)ToAscii(E_BlkDeAlc), cs)) ? deallocate_1 : deallocate_0);

   /*
    * A few functions enable more than one event code.
    */
   p->EVstralc =
      (((Testb((word)ToAscii(E_String), cs)) ||
	(Testb((word)ToAscii(E_StrDeAlc), cs)))
       ? EVStrAlc_1 : EVStrAlc_0);
   p->Alchash =
      (((Testb((word)ToAscii(E_Table), cs)) ||
	(Testb((word)ToAscii(E_Set), cs)))
       ? alchash_1 : alchash_0);
   p->Reserve =
      (((Testb((word)ToAscii(E_TenureString), cs)) ||
	(Testb((word)ToAscii(E_TenureBlock), cs)))
       ? reserve_1 : reserve_0);

   /*
    * Multiple functions all triggered by same events
    */
   if ((Testb((word)ToAscii(E_List), cs)) ||
       (Testb((word)ToAscii(E_Lelem), cs))) {
      p->Alclist_raw = alclist_raw_1;
      p->Alclist = alclist_1;
      p->Alclstb = alclstb_1;
      }
   else {
#undef alclist_raw
      p->Alclist_raw = alclist_raw;
      p->Alclist = alclist_0;
      p->Alclstb = alclstb_0;
      }

   if ((Testb((word)ToAscii(E_Aconv), cs)) ||
       (Testb((word)ToAscii(E_Tconv), cs)) ||
       (Testb((word)ToAscii(E_Nconv), cs)) ||
       (Testb((word)ToAscii(E_Sconv), cs)) ||
       (Testb((word)ToAscii(E_Fconv), cs))) {

      p->Cnvcset = cnv_cset_1;
      p->Cnvint = cnv_int_1;
      p->Cnvreal = cnv_real_1;
      p->Cnvstr = cnv_str_1;
      p->Cnvtcset = cnv_tcset_1;
      p->Cnvtstr = cnv_tstr_1;
#ifdef PatternTypexb
      p->Cnvpattern = cnv_pattern_1;
#endif					/* PatternType */
      }
   else {
      p->Cnvcset = cnv_cset_0;
#undef cnv_int
#undef cnv_real
#undef cnv_str
      p->Cnvint = cnv_int;
      p->Cnvreal = cnv_real;
      p->Cnvstr = cnv_str;
      p->Cnvtcset = cnv_tcset_0;
      p->Cnvtstr = cnv_tstr_0;
#ifdef PatternType
      if (Testb((word)ToAscii(E_PatCode), cs))
	 p->Cnvpattern = cnv_pattern_1;
      else
	 p->Cnvpattern = cnv_pattern_0;
#endif					/* PatternType */
      }

#ifdef PatternType
   /* internal_match. A mini "monster" case.
    * We should replace ~10 membership tests with a cset intersection.
    */
   if (Testb((word)ToAscii(E_PatAttempt), cs) ||
       Testb((word)ToAscii(E_PatFail), cs) ||
       Testb((word)ToAscii(E_PatMatch), cs) ||
       Testb((word)ToAscii(E_PatArg), cs) ||
       Testb((word)ToAscii(E_PelemAttempt), cs) ||
       Testb((word)ToAscii(E_PelemMatch), cs) ||
       Testb((word)ToAscii(E_PelemFail), cs) ||
       Testb((word)ToAscii(E_Assign), cs) ||
       Testb((word)ToAscii(E_Value), cs) ||
       Testb((word)ToAscii(E_Spos), cs)) {
      p->Internalmatch = internal_match_1;
      }
   else p->Internalmatch = internal_match_0;
#endif					/* PatternType */
   

   /*
    * interp() is the monster case:
    * the event codes were redone so under WordBits==64, any bit in one
    * particular word means: "use the instrumented interp". Probably
    * deserves more testing.
    */
   if (
#if WordBits == 64
       *(((uword *)cs.vword.bptr->Cset.bits)+2)
#else					/* WordBits == 64 */
       Testb((word)ToAscii(E_Intcall), cs) ||
       Testb((word)ToAscii(E_Stack), cs) ||
       Testb((word)ToAscii(E_Fsusp), cs) ||
       Testb((word)ToAscii(E_Osusp), cs) ||
       Testb((word)ToAscii(E_Bsusp), cs) ||
       Testb((word)ToAscii(E_Ocall), cs) ||
       Testb((word)ToAscii(E_Ofail), cs) ||
       Testb((word)ToAscii(E_Tick), cs) ||
       Testb((word)ToAscii(E_Line), cs) ||
       Testb((word)ToAscii(E_Loc), cs) ||
       Testb((word)ToAscii(E_Opcode), cs) ||
       Testb((word)ToAscii(E_Fcall), cs) ||
       Testb((word)ToAscii(E_Prem), cs) ||
       Testb((word)ToAscii(E_Erem), cs) ||
       Testb((word)ToAscii(E_Intret), cs) ||
       Testb((word)ToAscii(E_Psusp), cs) ||
       Testb((word)ToAscii(E_Ssusp), cs) ||
       Testb((word)ToAscii(E_Pret), cs) ||
       Testb((word)ToAscii(E_Efail), cs) ||
       Testb((word)ToAscii(E_Sresum), cs) ||
       Testb((word)ToAscii(E_Fresum), cs) ||
       Testb((word)ToAscii(E_Oresum), cs) ||
       Testb((word)ToAscii(E_Eresum), cs) ||
       Testb((word)ToAscii(E_Presum), cs) ||
       Testb((word)ToAscii(E_Pfail), cs) ||
       Testb((word)ToAscii(E_Ffail), cs) ||
       Testb((word)ToAscii(E_Frem), cs) ||
       Testb((word)ToAscii(E_Orem), cs) ||
       Testb((word)ToAscii(E_Fret), cs) ||
       Testb((word)ToAscii(E_Oret), cs) ||
       Testb((word)ToAscii(E_Literal), cs) ||
       Testb((word)ToAscii(E_Operand), cs) ||
       Testb((word)ToAscii(E_Syntax), cs) ||
       Testb((word)ToAscii(E_Cstack), cs)
#endif					/* WordBits == 64 */
       ) {
      p->Interp = interp_1;
      }
   else {
      p->Interp = interp_0;
      }
}

/*
 * EvGet(eventmask, valuemask, flag) - user function for reading event streams.
 * Installs cset eventmask (and optional table valuemask) in the event source,
 * then activates it.
 * EvGet returns the code of the matched token.  These keywords are also set:
 *    &eventcode     token code
 *    &eventvalue    token value
 */

"EvGet(c,flag) - read through the next event token having a code matched "
" by cset c."

function{0,1} EvGet(cs,vmask,flag)
   if !def:cset(cs,k_cset) then
      runerr(104,cs)
   if !is:null(vmask) then
      if !is:table(vmask) then
         runerr(124,vmask)

   body {
      tended struct descrip dummy;
      struct progstate *p = NULL;

#ifdef Concurrent
       if (is_concurrent) 
       	  is_concurrent = 0;
#endif Concurrent			/* Concurrent */ 

      /*
       * Be sure an eventsource is available
       */
      if (!is:coexpr(curpstate->eventsource))
         runerr(118,curpstate->eventsource);
      if (!is:null(vmask))
         BlkD(curpstate->eventsource,Coexpr)->program->valuemask = vmask;

      /*
       * If our event source is a child of ours, assign its event mask.
       */
      p = BlkD(curpstate->eventsource,Coexpr)->program;
      if (p->parent == curpstate) {
	 if (BlkLoc(p->eventmask) != BlkLoc(cs)) {
	    assign_event_functions(p, cs);
	    }
	 }

#ifdef Graphics
      if (Testb((word)ToAscii(E_MXevent), cs) &&
	  is:file(kywd_xwin[XKey_Window])) {
	 wbp _w_ = BlkD(kywd_xwin[XKey_Window],File)->fd.wb;
#ifdef GraphicsGL
	 if (_w_->window->is_gl)
	    gl_wsync(_w_);
	 else
#endif					/* GraphicsGL */
	 wsync(_w_);
	 pollctr = pollevent();
	 if (pollctr == -1)
	    fatalerr(141, NULL);
	 if (BlkD(_w_->window->listp,List)->size > 0) {
	    register int c;
	    c = wgetevent(_w_, &curpstate->eventval, -1);
	    if (c == 0) {
	       StrLen(curpstate->eventcode) = 1;
	       StrLoc(curpstate->eventcode) =
		  (char *)&allchars[FromAscii(E_MXevent) & 0xFF];
	       return curpstate->eventcode;
	       }
	    else if (c == -1)
	       runerr(141);
	    else
	       runerr(143);
	    }
	 }
#endif					/* Graphics */

      /*
       * Loop until we read an event allowed.
       */
      while (1) {
	 int rv;
         /*
          * Activate the event source to produce the next event.
          */
	 dummy = cs;
	 if ((rv=mt_activate(&dummy, &curpstate->eventcode,
			 BlkD(curpstate->eventsource, Coexpr))) == A_Cofail)
	    fail;
	 /*
	  * why would we ever need to dereference &eventcode?
	  */
	 /* deref(&curpstate->eventcode, &curpstate->eventcode); */
	 if (!is:string(curpstate->eventcode) ||
	     StrLen(curpstate->eventcode) != 1) {
	    /*
	     * this event is out-of-band data; return or reject it
	     * depending on whether flag is null.
	     */
	    if (!is:null(flag))
	       return curpstate->eventcode;
	    else continue;
	    }

#if E_Cofail || E_Coret
	 switch(*StrLoc(curpstate->eventcode)) {
	 case E_Cofail: case E_Coret: {
	    if (BlkD(curpstate->eventsource,Coexpr)->id == 1) {
	       fail;
	       }
	    }
	    }
#endif					/* E_Cofail || E_Coret */

	 return curpstate->eventcode;
	 }
      }
end

/*function{*} istate(ce,attrib)*/

"istate(ce,attrib) - gets the istate attribute. "
function{*} istate(ce,attrib)
   abstract {
      return integer
      }
   body {
      tended char *field=NULL;
      word *ipc_opnd;

      if (!cnv:C_string(attrib, field))
	 runerr(103,attrib);
 
      if (!is:null(ce)){
	 if (is:coexpr(ce)){
            if (!strcmp(field, "count"))
               return C_integer (word) BlkD(ce,Coexpr)->actv_count;
            if (!strcmp(field, "ilevel"))
               return C_integer (word) BlkD(ce,Coexpr)->es_ilevel;
            else if (!strcmp(field, "ipc"))
               return C_integer (word) BlkD(ce,Coexpr)->es_ipc.opnd;
            else if (!strcmp(field, "ipc_offset")){
               ipc_opnd = BlkD(ce,Coexpr)->es_ipc.opnd;
               return C_integer (word) DiffPtrs(
                                (char*)ipc_opnd,
                                (char *)BlkD(ce,Coexpr)->program->Code);
               }
            else if (!strcmp(field, "sp"))
               return C_integer (word) BlkD(ce,Coexpr)->es_sp;
            else if (!strcmp(field, "efp"))
               return C_integer (word) BlkD(ce,Coexpr)->es_efp;
            else if (!strcmp(field, "gfp"))
               return C_integer (word) BlkD(ce,Coexpr)->es_gfp;
            else fail;   
            }   
	 else  
	    runerr(118, ce);
	 }
      fail;
      }
end



char typech[MaxType+1];	/* output character for each type */

int noMTevents;			/* don't produce events in EVAsgn */

#if HAVE_PROFIL
union { 			/* clock ticker -- keep in sync w/ interp.r */
   unsigned short s[16];	/* four counters */
   unsigned long l[8];		/* two longs are easier to check */
} ticker;
unsigned long oldtick;		/* previous sum of the two longs */
#endif					/* HAVE_PROFIL */

#if UNIX
/*
 * Global state used by EVTick()
 */
word oldsum = 0;
#endif					/* UNIX */


static char scopechars[] = "+:^-";

/*
 * Special event function for E_Assign & E_Deref;
 * allocates out of monitor's heap.
 */
void EVVariable(dptr dx, int eventcode)
{
   int i;
   dptr procname = NULL;
   struct progstate *parent = curpstate->parent;
   struct region *rp = curpstate->stringregion;
   CURTSTATE();

   if (dx == glbl_argp) {
      /*
       * we are dereferencing a result, glbl_argp is not the procedure.
       * is this a stable state to leave the TP in?
       */
      actparent(eventcode);
      return;
      }

#if COMPILER
   procname = &(PFDebug(*pfp)->proc->pname);
#else					/* COMPILER */
   procname = &(BlkD(*glbl_argp,Proc)->pname);
#endif					/* COMPILER */
   /*
    * call get_name, allocating out of the monitor if necessary.
    */
   curpstate->stringregion = parent->stringregion;
   parent->stringregion = rp;
   MUTEX_LOCKID(MTX_NOMTEVENTS);
   noMTevents++;
   MUTEX_UNLOCKID(MTX_NOMTEVENTS);
   i = get_name(dx,&(parent->eventval));

   if (i == GlobalName) {
      if (reserve(Strings, StrLen(parent->eventval) + 1) == NULL) {
	 fprintf(stderr, "failed to reserve %ld bytes for global\n",
		 (long)(StrLen(parent->eventval)+1));
	 syserr("monitoring out-of-memory error");
	 }
      StrLoc(parent->eventval) =
	 alcstr(StrLoc(parent->eventval), StrLen(parent->eventval));
      alcstr("+",1);
      StrLen(parent->eventval)++;
      }
   else if ((i == StaticName) || (i == LocalName) || (i == ParamName)) {
      if (!reserve(Strings, StrLen(parent->eventval) + StrLen(*procname) + 1)) {
	 fprintf(stderr,"failed to reserve %ld bytes for %d, %ld+%ld\n",
		(long)(StrLen(parent->eventval)+StrLen(*procname)+1), i,
		 (long)StrLen(parent->eventval), (long)StrLen(*procname));
	 syserr("monitoring out-of-memory error");
	 }
      StrLoc(parent->eventval) =
	 alcstr(StrLoc(parent->eventval), StrLen(parent->eventval));
      alcstr(scopechars+i,1);
      alcstr(StrLoc(*procname), StrLen(*procname));
      StrLen(parent->eventval) += StrLen(*procname) + 1;
      }
   else if (i == Failed) {
      /* parent->eventval = *dx; */
      }
   else if (i == Succeeded) {
      /* Succeeded, so OK; get_name allocated if needed.
       * To check: did get_name allocate out of monitor?
       */
      }
   else if (i == RunError) {
      syserr("get_name error in EVVariable");
      }
   else {
      syserr("EVVariable: unknown return code from get_name");
      }

   parent->stringregion = curpstate->stringregion;
   curpstate->stringregion = rp;
   MUTEX_LOCKID(MTX_NOMTEVENTS);
   noMTevents--;
   MUTEX_UNLOCKID(MTX_NOMTEVENTS);
   if (!is:null(curpstate->valuemask) &&
       (invaluemask(curpstate, eventcode, &(parent->eventval)) != Succeeded))
	 return;
   actparent(eventcode);
}


/*
 *  EVInit() - initialization.
 */

void EVInit()
   {
   int i;

   /*
    * Initialize the typech array, which is used if either file-based
    * or MT-based event monitoring is enabled.
    */

   for (i = 0; i <= MaxType; i++)
      typech[i] = '?';	/* initialize with error character */

#ifdef LargeInts
   typech[T_Lrgint]  = E_Lrgint;	/* long integer */
#endif					/* LargeInts */

   typech[T_Real]    = E_Real;		/* real number */
   typech[T_Cset]    = E_Cset;		/* cset */
   typech[T_File]    = E_File;		/* file block */
   typech[T_Record]  = E_Record;	/* record block */
   typech[T_Tvsubs]  = E_Tvsubs;	/* substring trapped variable */
   typech[T_External]= E_External;	/* external block */
   typech[T_List]    = E_List;		/* list header block */
   typech[T_Lelem]   = E_Lelem;		/* list element block */
   typech[T_Table]   = E_Table;		/* table header block */
   typech[T_Telem]   = E_Telem;		/* table element block */
   typech[T_Tvtbl]   = E_Tvtbl;		/* table elem trapped variable*/
   typech[T_Set]     = E_Set;		/* set header block */
   typech[T_Selem]   = E_Selem;		/* set element block */
   typech[T_Slots]   = E_Slots;		/* set/table hash slots */
   typech[T_Coexpr]  = E_Coexpr;	/* co-expression block (static) */
   typech[T_Refresh] = E_Refresh;	/* co-expression refresh block */


   /*
    * codes used elsewhere but not shown here:
    *    in the static region: E_Alien = alien (malloc block)
    *    in the static region: E_Free = free
    *    in the string region: E_String = string
    */

#if UNIX
   /*
    * Call profil(2) to enable program counter profiling.  We use the smallest
    *  allowable scale factor in order to minimize the number of counters;
    *  we assume that the text of iconx does not exceed 256K and so we use
    *  four bins.  One of these four bins will be incremented every system
    *  clock tick (typically 4 to 20 ms).
    *
    *  Take your local profil(2) man page with a grain of salt.  All the
    *  systems we tested really maintain 16-bit counters despite what the
    *  man pages say.
    *  Some also say that a scale factor of two maps everything to one counter;
    *  that is believed to be a no-longer-correct statement dating from the
    *  days when the maximum program size was 64K.
    *
    *  The reference to EVInit below just obtains an arbitrary address within
    *  the text segment.
    */
#if HAVE_PROFIL
#ifdef PROFIL_CHAR_P
   profil((char *)(ticker.s), sizeof(ticker.s), (long) EVInit & ~0x3FFFF, 2);
#else					/* PROFIL_CHAR_P */
   profil((unsigned short *)(ticker.s), sizeof(ticker.s),
	  (long) EVInit & ~0x3FFFF, 2);
#endif					/* PROFIL_CHAR_P */
#endif					/* HAVE_PROFIL */
#endif					/* UNIX */

   }

/*
 * mmrefresh() - redraw screen, initially or after garbage collection.
 */

void mmrefresh()
   {
   char *p = NULL;
   word n;
   CURTSTATE();

   /*
    * If the monitor is asking for E_EndCollect events, then it
    * can handle these memory allocation "redraw" events.
    */
  if (!is:null(curpstate->eventmask) &&
       Testb((word)ToAscii(E_EndCollect), curpstate->eventmask)) {
      for (p = blkbase; p < blkfree; p += n) {
	 n = BlkSize(p);
#if E_Lrgint || E_Real || E_Cset || E_File || E_Record || E_Tvsubs || E_External || E_List || E_Lelem || E_Table || E_Telem || E_Tvtbl || E_Set || E_Selem || E_Slots || E_Coexpr || E_Refresh
	 RealEVVal(n, typech[(int)BlkType(p)],/*noop*/,/*noop*/);/* block reg.*/
#endif					/* instrument allocation events */
	 }
      EVVal(DiffPtrs(strfree, strbase), E_String);	/* string region */
      }
   }


void EVStrAlc_0(word n) { ; }

void EVStrAlc_1(word n)
{
   if (n < 0) {
      EVVal(-n, E_StrDeAlc);
      }
   else {
      EVVal(n, E_String);
      }
}

/*
 * C-calling iconc-iconx compatibility variables.  Iconc-compatible C may
 * refer to these globals. They are normally remapped in the VM to curpstate
 * variables, e.g. curpstate->T_errornumber, so we need to think about this.
 * In the meantime, avoid a crash by defining the iconc-versions in iconx.
 */
#passthru #undef t_errornumber
#passthru #undef t_errorvalue
#passthru #undef t_have_val
int t_errornumber, t_have_val;
struct descrip t_errorvalue;

#else					/* MultiProgram */
/* static char xjunk;			/* avoid empty module */
#endif					/* MultiProgram */
