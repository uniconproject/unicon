/*
 * File: rwindow.r
 *  non window-system-specific window support routines
 */

unsigned long ConsoleFlags = 0;			 /* Console flags */

#ifdef Graphics

static	int	colorphrase    (char *buf, long *r, long *g, long *b, long *a);
static	double	rgbval		(double n1, double n2, double hue);

static	int	setpos          (wbp w, char *s);
static	int	sicmp		(siptr sip1, siptr sip2);

/*
 * Global variables.
 *  A poll counter for use in interp.c,
 *  the binding for the console window - FILE * for simplicity,
 *  &col, &row, &x, &y, &interval, timestamp, and modifier keys.
 */

#ifndef Concurrent
int pollctr;
#endif					/* Concurrent */

FILE *ConsoleBinding = NULL;
/*
 * the global buffer used as work space for printing string, etc
 */
char ConsoleStringBuf[MaxReadStr * 48];
char *ConsoleStringBufPtr = ConsoleStringBuf;

int canvas_serial, context_serial;

/* Used by the FreeType (3D) fonts subsystem. */
wfont gfont;
wfont *start_font, *end_font, *curr_font;

#ifdef MSWindows
extern wclrp scp;
extern HPALETTE palette;
extern int numColors;
#endif					/* MSWindows */

#ifndef MultiProgram
struct descrip amperX = {D_Integer};
struct descrip amperY = {D_Integer};
struct descrip amperCol = {D_Integer};
struct descrip amperRow = {D_Integer};
struct descrip amperInterval = {D_Integer};
struct descrip amperPick = {D_Null};
struct descrip lastEventWin = {D_Null};
int lastEvFWidth = 0, lastEvLeading = 0, lastEvAscent = 0;
uword xmod_control, xmod_shift, xmod_meta;
#endif					/* MultiProgram */


/*
 * subscript the already-processed-events "queue" to index i.
 * used in "cooked mode" I/O to determine, e.g. how far to backspace.
 */
char *evquesub(w,i)
wbp w;
int i;
   {
   wsp ws = w->window;
   int j = ws->eQback+i;

   if (i < 0) {
      if (j < 0) j+= EQUEUELEN;
      else if (j > EQUEUELEN) j -= EQUEUELEN;
      return &(ws->eventQueue[j]);
      }
   else {
      /* "this isn't getting called in the forwards direction!\n" */
      return NULL;
      }
   }


/*
 * get event from window, assigning to &x, &y, and &interval
 *
 * returns 0 for success, -1 if window died or EOF, -2 for malformed queue,
 *    -3 if timeout expired
 */
int wgetevent(w,res,t)
wbp w;
dptr res;
int t;
   {
   struct descrip xdesc, ydesc, pickdesc;
   struct b_list *hp;
   uword i;
   int retval;

   if (wstates != NULL && wstates->next != NULL		/* if multiple windows*/
   && (BlkD(w->window->listp,List)->size == 0)) {	/* & queue is empty */
      while (BlkD(w->window->listp,List)->size == 0) {
#ifdef XWindows
         extern void postcursor(wbp);
         extern void scrubcursor(wbp);
         if (ISCLOSED(w)) {
	    return -1;
	    }
	 if (ISCURSORON(w)) {
	    postcursor(w);
	    }
#endif					/* XWindows */
#ifdef MSWindows
	 if (ISCURSORON(w) && w->window->hasCaret == 0) {
	    wsp ws = w->window;
	    CreateCaret(ws->iconwin, NULL, FWIDTH(w), FHEIGHT(w));
	    SetCaretBlinkTime(500);
	    SetCaretPos(ws->x, ws->y - ASCENT(w));
	    ShowCaret(ws->iconwin);
	    ws->hasCaret = 1;
	    }
#endif					/* MSWindows */
	 if (pollevent() < 0)				/* poll all windows */
	    break;					/* break on error */
#if UNIX || VMS
         idelay(XICONSLEEP);
#endif					/* UNIX || VMS */
#ifdef MSWindows
	 Sleep(20);
#endif					/* MSWindows */
	 }
#ifdef XWindows
      if (ISCURSORON(w))
	 scrubcursor(w);
#endif
      }

#ifdef GraphicsGL
   if (w->window->is_gl)
      retval = gl_wgetq(w,res,t);
   else
#endif					/* GraphicsGL */
   retval = wgetq(w,res,t);
   if (retval == -1)
      return -1;					/* window died */
   if (retval == -2)
      return -3;					/* timeout expired */

   if (BlkD(w->window->listp,List)->size < 2)
      return -2;					/* malformed queue */

#ifdef GraphicsGL
   if (w->window->is_gl) {
      gl_wgetq(w,&xdesc,-1);
      gl_wgetq(w,&ydesc,-1);
      }
   else
#endif					/* GraphicsGL */
   {
   wgetq(w,&xdesc,-1);
   wgetq(w,&ydesc,-1);
   }

#ifdef Graphics3D
   hp = BlkD(w->window->listp, List);
   if (hp->size > 0) {   /* we might have picking results */
      c_traverse( hp , &pickdesc ,0);
      if (is:list(pickdesc)) { /* pull out the picking results */
#ifdef GraphicsGL
         if (w->window->is_gl)
            gl_wgetq( w, &amperPick, -1);
         else
#endif					/* GraphicsGL */
         wgetq( w, &amperPick, -1);
         }
      else
        amperPick = nulldesc;
      }
   else
        amperPick = nulldesc;
#endif					/* Graphics3D */

   if (xdesc.dword != D_Integer || ydesc.dword != D_Integer)
{
      return -2;			/* bad values on queue */
}

   IntVal(amperX) = IntVal(xdesc) & 0xFFFF;		/* &x */
   if (IntVal(amperX) >= 0x8000)
      IntVal(amperX) -= 0x10000;
   IntVal(amperY) = IntVal(ydesc) & 0xFFFF;		/* &y */
   if (IntVal(amperY) >= 0x8000)
      IntVal(amperY) -= 0x10000;
   IntVal(amperX) -= w->context->dx;
   IntVal(amperY) -= w->context->dy;

#ifdef GraphicsGL
   if (w->window->is_gl) {
      MakeInt(1 + GL_XTOCOL(w,IntVal(amperX)), &(amperCol));	/* &col */
      MakeInt(GL_YTOROW(w,IntVal(amperY)) , &(amperRow));	/* &row */
      }
   else
#endif					/* GraphicsGL */
   {
   MakeInt(1 + XTOCOL(w,IntVal(amperX)), &(amperCol));	/* &col */
   MakeInt(YTOROW(w,IntVal(amperY)) , &(amperRow));	/* &row */
   }

   xmod_control = IntVal(xdesc) & EQ_MOD_CONTROL;	/* &control */
   xmod_meta = IntVal(xdesc) & EQ_MOD_META;		/* &meta */
   xmod_shift = IntVal(xdesc) & EQ_MOD_SHIFT;		/* &shift */

   i = (((uword) IntVal(ydesc)) >> 16) & 0xFFF;		/* mantissa */
   i <<= 4 * ((((uword) IntVal(ydesc)) >> 28) & 0x7);	/* scale it */
   IntVal(amperInterval) = i;				/* &interval */
   return 0;
   }

/*
 * get event from window (drop mouse events), no echo
 *
 * return: 1 = success, -1 = window died, -2 = malformed queue, -3 = EOF
 */
int wgetchne(w,res)
wbp w;
dptr res;
   {
   int i;

   while (1) {
      i = wgetevent(w,res,-1);
      if (i != 0)
	 return i;
      if (is:string(*res)) {
#ifdef MSWindows
         if (*StrLoc(*res) == '\032') return -3; /* control-Z gives EOF */
#endif					/* MSWindows */
         return 1;
	 }
      }
   }

/*
 * get event from window (drop mouse events), with echo
 *
 * returns 1 for success, -1 if window died, -2 for malformed queue, -3 for EOF
 */
int wgetche(w,res)
wbp w;
dptr res;
   {
   int i;
   i = wgetchne(w,res);
   if (i != 1)
      return i;
   i = *StrLoc(*res);
   if ((0 <= i) && (i <= 127) && (ISECHOON(w))) {
#ifdef GraphicsGL
      if (w->window->is_gl) {
         gl_wputc(i, w);
         if (i == '\r') gl_wputc((int)'\n', w); /* CR -> CR/LF */
         }
      else
#endif					/* GraphicsGL */
       {
       wputc(i, w);
       if (i == '\r') wputc((int)'\n', w); /* CR -> CR/LF */
      }}
   return 1;
   }

/*
 * Get a window that has an event pending (queued)
 */
wsp getactivewindow()
   {
   static LONG next = 0;
   LONG i, j, nwindows = 0;
   wsp ptr, ws, stdws = NULL;
   extern FILE *ConsoleBinding;
   CURTSTATE();

   if (wstates == NULL) return NULL;
   for(ws = wstates; ws; ws=ws->next) nwindows++;
   if (ConsoleBinding) stdws = ((wbp)ConsoleBinding)->window;
   /*
    * make sure we are still in bounds
    */
   next %= nwindows;
   /*
    * position ptr on the next window to get events from
    */
   for (ptr = wstates, i = 0; i < next; i++, ptr = ptr->next);
   /*
    * Infinite loop, checking for an event somewhere, sleeping awhile
    * each iteration.
    */
   for (;;) {
      /*
       * Check for any new pending events.
       */
      switch (pollevent()) {
      case -1: ReturnErrNum(141, NULL);
      case 0: return NULL;
	 }
      /*
       * go through windows, looking for one with an event pending
       */
      for (ws = ptr, i = 0, j = next + 1; i < nwindows;
	   (ws = (ws->next) ? ws->next : wstates), i++, j++)
	 if (ws != stdws && BlkD(ws->listp,List)->size > 0) {
	    next = j;
	    return ws;
	    }
#if UNIX || VMS
      /*
       * couldn't find a pending event - wait awhile
       */
      idelay(XICONSLEEP);
#endif					/* UNIX || VMS */
      }
   }

/*
 * wlongread(s,elsize,nelem,f) -- read string from window for reads(w)
 *
 * returns length(>=0) for success, -1 if window died, -2 for malformed queue
 *  -3 on EOF
 */
int wlongread(s, elsize, nelem, f)
char *s;
int elsize, nelem;
FILE *f;
   {
   int c;
   tended char *ts = s;
   struct descrip foo;
   long l = 0, bytes = elsize * nelem;

   while (l < bytes) {
     c = wgetche((wbp)f, &foo);
     if (c == -3 && l > 0)
	return l;
     if (c < 0)
	return c;
     c = *StrLoc(foo);
     switch(c) {
       case '\177':
       case '\010':
         if (l > 0) { ts--; l--; }
         break;
       default:
         *ts++ = c; l++;
         break;
       }
     }
   return l;
   }

/*
 * wgetstrg(s,maxlen,f) -- get string from window for read(w) or !w
 *
 * returns length(>=0) for success, -1 if window died, -2 for malformed queue
 *  -3 for EOF, -4 if length was limited by maxi
 */
int wgetstrg(s, maxlen, f)
char *s;
long  maxlen;
FILE *f;
   {
   int c;
   tended char *ts = s;
   long l = 0;
   struct descrip foo;

   while (l < maxlen) {
      c = wgetche((wbp)f,&foo);
      if (c == -3 && l > 0)
	 return l;
      if (c < 0)
	 return c;
      c = *StrLoc(foo);
      switch(c) {
        case '\177':
        case '\010':
          if (l > 0) { ts--; l--; }
          break;
        case '\r':
        case '\n':
          return l;
        default:
          *ts++ = c; l++;
          break;
        }
      }
   return -4;
   }


/*
 * Assignment side-effects for &x,&y,&row,&col
 */
int xyrowcol(dx)
dptr dx;
{
   if (VarLoc(*dx) == &amperX) { /* update &col too */
      wbp w;
      if (!is:file(lastEventWin) ||
          ((BlkD(lastEventWin,File)->status & Fs_Window) == 0) ||
          ((BlkD(lastEventWin,File)->status & (Fs_Read|Fs_Write)) == 0)) {
         MakeInt(1 + IntVal(amperX)/lastEvFWidth, &amperCol);
	 }
      else {
         w = BlkD(lastEventWin,File)->fd.wb;
#ifdef GraphicsGL
         if (w->window->is_gl)
            MakeInt(1 + GL_XTOCOL(w, IntVal(amperX)), &amperCol);
         else
#endif					/* GraphicsGL */
         MakeInt(1 + XTOCOL(w, IntVal(amperX)), &amperCol);
         }
      }
   else if (VarLoc(*dx) == &amperY) { /* update &row too */
      wbp w;
      if (!is:file(lastEventWin) ||
          ((BlkD(lastEventWin,File)->status & Fs_Window) == 0) ||
          ((BlkD(lastEventWin,File)->status & (Fs_Read|Fs_Write)) == 0)) {
         MakeInt(IntVal(amperY) / lastEvLeading + 1, &amperRow);
         }
      else {
         w = BlkD(lastEventWin,File)->fd.wb;
#ifdef GraphicsGL
         if (w->window->is_gl)
            MakeInt(GL_YTOROW(w, IntVal(amperY)), &amperRow);
         else
#endif					/* GraphicsGL */
         MakeInt(YTOROW(w, IntVal(amperY)), &amperRow);
         }
      }
   else if (VarLoc(*dx) == &amperCol) { /* update &x too */
      wbp w;
      if (!is:file(lastEventWin) ||
          ((BlkD(lastEventWin,File)->status & Fs_Window) == 0) ||
          ((BlkD(lastEventWin,File)->status & (Fs_Read|Fs_Write)) == 0)) {
         MakeInt((IntVal(amperCol) - 1) * lastEvFWidth, &amperX);
         }
      else {
         w = BlkD(lastEventWin,File)->fd.wb;
#ifdef GraphicsGL
         if (w->window->is_gl)
            MakeInt(GL_COLTOX(w, IntVal(amperCol)), &amperX);
         else
#endif					/* GraphicsGL */
         MakeInt(COLTOX(w, IntVal(amperCol)), &amperX);
         }
      }
   else if (VarLoc(*dx) == &amperRow) { /* update &y too */
      wbp w;
      if (!is:file(lastEventWin) ||
          ((BlkD(lastEventWin,File)->status & Fs_Window) == 0) ||
          ((BlkD(lastEventWin,File)->status & (Fs_Read|Fs_Write)) == 0)) {
         MakeInt((IntVal(amperRow)-1) * lastEvLeading + lastEvAscent, &amperY);
         }
      else {
         w = BlkD(lastEventWin,File)->fd.wb;
#ifdef GraphicsGL
         if (w->window->is_gl)
            MakeInt(GL_ROWTOY(w, IntVal(amperRow)), &amperY);
         else
#endif					/* GraphicsGL */
         MakeInt(ROWTOY(w, IntVal(amperRow)), &amperY);
         }
      }
   return 0;
   }

/* linkfiletowindow - link in the Icon file block with an (opened) window */
void linkfiletowindow(wbp w, struct b_file *fl)
{
   w->window->filep.dword = D_File;
   BlkLoc(w->window->filep) = (union block *)fl;
   if (is:null(lastEventWin)) {
      lastEventWin = w->window->filep;
#ifdef GraphicsGL
      if (w->window->is_gl) {
         lastEvFWidth = GL_FWIDTH(w);
         lastEvLeading = GL_LEADING(w);
         lastEvAscent = GL_ASCENT(w);
         }
      else
#endif					/* GraphicsGL */
         {
      lastEvFWidth = FWIDTH(w);
      lastEvLeading = LEADING(w);
      lastEvAscent = ASCENT(w);
         }
      }
}


/*
 * Enqueue an event, encoding time interval and key state with x and y values.
 */
void qevent(ws,e,x,y,t,f)
wsp ws;		/* canvas */
dptr e;		/* event code (descriptor pointer) */
int x, y;	/* x and y values */
uword t;	/* ms clock value */
long f;		/* modifier key flags */
   {
   dptr q = &(ws->listp);	/* a window's event queue (Icon list value) */
   struct descrip d;
   uword ivl, mod;
   int expo;

   mod = 0;				/* set modifier key bits */
   if (f & ControlMask) mod |= EQ_MOD_CONTROL;
   if (f & Mod1Mask)    mod |= EQ_MOD_META;
   if (f & ShiftMask)   mod |= EQ_MOD_SHIFT;

   if (t != ~(uword)0) {		/* if clock value supplied */
      if (ws->timestamp == 0)		/* if first time */
	 ws->timestamp = t;
      if (t < ws->timestamp)		/* if clock went backwards */
	 t = ws->timestamp;
      ivl = t - ws->timestamp;		/* calc interval in milliseconds */
      ws->timestamp = t;		/* save new clock value */
      expo = 0;
      while (ivl >= 0x1000) {		/* if too big */
	 ivl >>= 4;			/* reduce significance */
	 expo += 0x1000;		/* bump exponent */
	 }
      ivl += expo;			/* combine exponent with mantissa */
      }
   else
      ivl = 0;				/* report 0 if interval unknown */

   c_put(q, e);
   d.dword = D_Integer;
   IntVal(d) = mod | (x & 0xFFFF);
   c_put(q, &d);
   IntVal(d) = (ivl << 16) | (y & 0xFFFF);
   c_put(q, &d);
   }

/*
 * setpos() - set (move) canvas position on the screen
 */
static int setpos(w,s)
wbp w;
char *s;
   {
   char *s2, tmp[32];
   int posx, posy;

   s2 = s;
   while (isspace(*s2)) s2++;
   if (!isdigit(*s2) && (*s2 != '-')) return RunError;
   posx = atol(s2);
   if (*s2 == '-') s2++;
   while (isdigit(*s2)) s2++;
   if (*s2 == '.') {
      s2++;
      while (isdigit(*s2)) s2++;
      }
   if (*s2++ != ',') return RunError;
   if (!isdigit(*s2) && (*s2 != '-')) return RunError;
   posy = atol(s2);
   if (*s2 == '-') s2++;
   while (isdigit(*s2)) s2++;
   if (*s2 == '.') {
      s2++;
      while (isdigit(*s2)) s2++;
      }
   if (*s2) return RunError;
   if (posx < 0) {
      if (posy < 0) sprintf(tmp,"%d%d",posx,posy);
      else sprintf(tmp,"%d+%d",posx,posy);
      }
   else {
      if (posy < 0) sprintf(tmp,"+%d%d",posx,posy);
      else sprintf(tmp,"+%d+%d",posx,posy);
      }
   w->window->real_posx = posx;
   w->window->real_posy = posy;
#ifdef GraphicsGL 
   if (w->window->is_gl)
      return gl_setgeometry(w,tmp);
   else
#endif					/* GraphicsGL */
   return setgeometry(w,tmp);
   }

/*
 * setsize() - set canvas size
 */
int setsize(w,s)
wbp w;
char *s;
   {
   char *s2, tmp[32];
   int width, height;

   s2 = s;
   while (isspace(*s2)) s2++;
   if (!isdigit(*s2) && (*s2 != '-')) return RunError;
   width = atol(s2);
   if (*s2 == '-') s2++;
   while (isdigit(*s2)) s2++;
   if (*s2 == '.') {
      s2++;
      while (isdigit(*s2)) s2++;
      }
   if (*s2++ != ',') return RunError;
   height = atol(s2);
   if (*s2 == '-') s2++;
   while (isdigit(*s2)) s2++;
   if (*s2 == '.') {
      s2++;
      while (isdigit(*s2)) s2++;
      }
   if (*s2) return RunError;
   sprintf(tmp,"%dx%d",width,height);
#ifdef GraphicsGL
   if (w->window->is_gl)
      return gl_setgeometry(w,tmp);
   else
#endif					/* GraphicsGL */
   return setgeometry(w,tmp);
   }

/*
 * Set an RGB mode. Allowed values are 24, 48, auto, and normalized.
 * norm and normal are accepted abbreviations of normalized.
 */
int setrgbmode(wbp w, char *s)
{
   if (!strcmp(s, "48")) { w->context->rgbmode = 2; return Succeeded; }
   else if (!strcmp(s, "24")) { w->context->rgbmode = 1; return Succeeded; }
   else if (!strcmp(s, "auto")) { w->context->rgbmode = 0; return Succeeded; }
   else if (!strcmp(s, "normalized") || !strcmp(s, "normal") ||
	    !strcmp(s, "norm")) { w->context->rgbmode = 3; return Succeeded; }
   return Failed;
}


/*
 * src/common/filepart.c defines FILE *flog, the file itself is part of libucommon.
 * On MacOS iconc fails to find the symbol flog even though it is linking libucommon.
 * If we call a function in filepart.c, it forces clang on MacOS to not
 * optimize out filepart.c symbols inclduing flog avoiding the link error.
 *
 * This unused function is a hack to fix iconc on MacOS until someone finds a way
 * to make clang not "too smart"
 */
void call_filepart_openlog_because_macOS_clang_is_too_smart() {
  char *trash="random";
  openlog(trash);
}

/*
 * put a string out to a window using the current attributes
 */
void wputstr(w,s,len)
wbp w;
char *s;
int len;
   {
   char *s2 = s;
   tended struct descrip result;

   /* turn off the cursor */
   hidecrsr(w->window);

   if ( (FILE *) w == stdout || (FILE *) w == stderr || (FILE *) w == ConsoleBinding) {
      if (flog) fprintf(flog, "%*s", len, s);
      }



#ifdef ScrollingConsoleWin
#undef fprintf
   if (w == (wbp)ConsoleBinding) {
      wstate *ws = w->window;
      char *catenation;
      int i, j=0;
      for(i=0; i<len; i++)
	 if (s[i]=='\n') j++;
      geteditregion(ws->child, &result);

      while (StrLen(result) + len + j + 1 > 32700) {
	 while((StrLen(result) > 0) && (StrLoc(result)[0] != '\n')) {
	    StrLoc(result) ++;
	    StrLen(result) --;
	    }
	 if (StrLen(result) > 0) {
	    StrLoc(result)++; StrLen(result)--;
	    }
	 }

	reserve(Strings, StrLen(result) + len + j + 1);
	catenation = alcstr(StrLoc(result), StrLen(result));
        alcstr(s, len+j);

	{ int i, k=0;
	for(i=0; i<len; i++) {
	   if (s[i] == '\n')
	      catenation[StrLen(result) + k++] = '\r';
	   catenation[StrLen(result) + k++] = s[i];
	   }
	}
        alcstr("\0", 1);
	seteditregion(ws->child, catenation);
        movechild(ws->child, 0, 0, ws->width, ws->height);
        setfocusonchild(ws, ws->child, ws->width, ws->height);
	setchildselection(ws, ws->child, StrLen(result), StrLen(result)+len);
	return;
	}
#define fprintf Consolefprintf
#endif					/* ScrollingConsoleWin */

   while (len > 0) {
      /*
       * find a chunk of printable text
       */
#ifdef MSWindows
      while (len > 0) {
	 if (IsDBCSLeadByte(*s2)) {
	    s2++; s2++; len--; len--;
	    }
	 else if (isprint(*s2)) {
	    s2++; len--;
	    }
	 else break;
	 }
#else					/* MSWindows */
      while (isprint(*s2) && len > 0) {
	 s2++; len--;
	 }
#endif					/* MSWindows */
      /*
       * if a chunk was parsed, write it out
       */
      if (s2 != s) {
#ifdef GraphicsGL
         if (w->window->is_gl)
            gl_xdis(w, s, s2 - s);
         else
#endif					/* GraphicsGL */
         xdis(w, s, s2 - s);
         }
      /*
       * put the 'unprintable' character, if didn't just hit the end
       */
      if (len-- > 0) {
#ifdef GraphicsGL
         if (w->window->is_gl)
            gl_wputc(*s2++, w);
         else
#endif					/* GraphicsGL */
         wputc(*s2++, w);
         }
    s = s2;
    }

  /* show the cursor again */
  UpdateCursorPos(w->window, w->context);
  showcrsr(w->window);
}


/*
 * Structures and tables used for color parsing.
 *  Tables must be kept lexically sorted.
 */

typedef struct {	/* color name entry */
   char name[8];	/* basic color name */
   char ish[12];	/* -ish form */
   short hue;		/* hue, in degrees */
   char lgt;		/* lightness, as percentage */
   char sat;		/* saturation, as percentage */
} colrname;

typedef struct {	/* arbitrary lookup entry */
   char word[15];	/* word */
   char val;		/* value, as percentage */
} colrmod;

static colrname colortable[] = {		/* known colors */
   /* color       ish-form     hue  lgt  sat */
   { "black",    "blackish",     0,   0,   0 },
   { "blue",     "bluish",     240,  50, 100 },
   { "brown",    "brownish",    30,  25, 100 },
   { "cyan",     "cyanish",    180,  50, 100 },
   { "gray",     "grayish",      0,  50,   0 },
   { "green",    "greenish",   120,  50, 100 },
   { "grey",     "greyish",      0,  50,   0 },
   { "magenta",  "magentaish", 300,  50, 100 },
   { "orange",   "orangish",    15,  50, 100 },
   { "pink",     "pinkish",    345,  75, 100 },
   { "purple",   "purplish",   270,  50, 100 },
   { "red",      "reddish",      0,  50, 100 },
   { "violet",   "violetish",  270,  75, 100 },
   { "white",    "whitish",      0, 100,   0 },
   { "yellow",   "yellowish",   60,  50, 100 },
   };

static colrmod lighttable[] = {			/* lightness modifiers */
   { "dark",       0 },
   { "deep",       0 },		/* = very dark (see code) */
   { "light",    100 },
   { "medium",    50 },
   { "pale",     100 },		/* = very light (see code) */
   };

static colrmod sattable[] = {			/* saturation levels */
   { "moderate",  50 },
   { "strong",    75 },
   { "vivid",    100 },
   { "weak",      25 },
   };

static colrmod transptable[] = {		/* transparency levels */
   { "dull",  75 },				/* alias for subtranslucent */
   { "opaque",  100 },
   { "subtranslucent",  75 },
   { "subtransparent",  25 },
   { "translucent",  50 },
   { "transparent",  5 },
   };

#ifdef Graphics3D
static char *texturetable[] = {
   "brick",
   "carpet",
   "cloth",
   "clouds",
   "concrete",
   "dirt",
   "glass",
   "grass",
   "grill",
   "hair",
   "iron",
   "marble",
   "metal",
   "leaf",
   "leather",
   "plastic",
   "sand",
   "skin",
   "sky"
   "snow",
   "stone",
   "tile",
   "water",
   "wood",
   };

static int texturephrase(char *buf, long *r, long *g, long *b, long *a);
#endif					/* Graphics3D */

/*
 *  parsecolor(w, s, &r, &g, &b, &a) - parse a color specification
 *
 *  parsecolor interprets a color specification and produces r/g/b values
 *  scaled linearly from 0 to 65535.  parsecolor returns Succeeded or Failed.
 *
 *  An Icon color specification can be any of the forms
 *
 *     #rgb			(hexadecimal digits)
 *     #rgba
 *     #rrggbb
 *     #rrggbbaa
 *     #rrrgggbbb		(note: no 3 digit rrrgggbbbaaa)
 *     #rrrrggggbbbb
 *     #rrrrggggbbbbaaaa
 *     nnnnn,nnnnn,nnnnn	(numbers, interpret by rgbmode)
 *     <Icon color phrase>
 *     <native color spec>
 *
 *  The comma-separated numbers format can be 24-bit, 48-bit, or normalized.
 */

int parsecolor(w, buf, r, g, b, a)
wbp w;
char *buf;
long *r, *g, *b, *a;
   {
   int len, mul, texture;
   char *fmt, c;
   double dr, dg, db, da = 1.0;

   *r = *g = *b = 0L;
#ifdef GraphicsGL
   *a = (long) (w->context->alpha*65535.0);
#else					/* GraphicsGL */
   *a = 65535;
#endif					/* GraphicsGL */

   /* trim leading spaces */
   while (isspace(*buf))
      buf++;

#ifdef Graphics3D
   /* try interpreting as four comma-separated numbers */
   if (sscanf(buf, "%lf,%lf,%lf,%lf%c", &dr, &dg, &db, &da, &c) == 4) {
      *a = da;
      goto RGBnums;
      }
#endif					/* Graphics3D */

   /* try interpreting as three comma-separated numbers */
   if (sscanf(buf, "%lf,%lf,%lf%c", &dr, &dg, &db, &c) == 3) {
RGBnums:
      *r = dr;
      *g = dg;
      *b = db;

      if (w && w->context && w->context->rgbmode == 0) { /* auto */
	 /* see if we need to revert it to 48-bit mode. */
	 if (dr>=256 || dg>=256 || db>=256) {
	    w->context->rgbmode = 2;
	    }
	 }

      if (w && w->context)
      switch (w->context->rgbmode) {
      case 0:			/* nonreverted auto treated as 24-bit color */
#ifdef Graphics3D
				/* unless you are in 3D using normalized */
	 if (w->context->rendermode == UGL3D && dr>=0 && dr<=1.0 &&
	     dg>=0 && dg<=1.0 && db>=0 && db<=1.0)
	    goto normalized;
#endif					/* Graphics3D */
      case 1:			/* convert app 24-bit color to 48-bits */
	 *r *= 257;
	 *g *= 257;
	 *b *= 257;
	 break;
      case 2:			/* no-op, 48 bit color is internal default */
	 break;
      case 3:
normalized:
	 *r = dr * 65535;
	 *g = dg * 65535;
	 *b = db * 65535;
	 *a = da * 65535;
	 }


      if (*r>=0 && *r<=65535 && *g>=0 && *g<=65535 && *b>=0 && *b<=65535)
         return Succeeded;
      else
         return Failed;
      }

   /* try interpreting as a hexadecimal value */
   if (*buf == '#') {
      buf++;
      for (len = 0; isalnum(buf[len]); len++);
      switch (len) {
         case  3:  fmt = "%1x%1x%1x%c";  mul = 0x1111;  break;
         case  4:  fmt = "%1x%1x%1x%1x%c";  mul = 0x1111;  break;
         case  6:  fmt = "%2x%2x%2x%c";  mul = 0x0101;  break;
         case  8:  fmt = "%2x%2x%2x%2x%c";  mul = 0x0101;  break;
         case  9:  fmt = "%3x%3x%3x%c";  mul = 0x0010;  break;
         case 12:  fmt = "%4x%4x%4x%c";  mul = 0x0001;  break;
         case 16:  fmt = "%4x%4x%4x%4x%c";  mul = 0x0001;  break;
         default:  return Failed;
      }
      if ((len == 4) || (len == 8) || (len == 16)) {
         if (sscanf(buf, fmt, r, g, b, a, &c) != 4)
            return Failed;
	 *a *= mul;
         }
      else if (sscanf(buf, fmt, r, g, b, &c) != 3)
            return Failed;
      *r *= mul;
      *g *= mul;
      *b *= mul;
      return Succeeded;
      }

#ifdef Graphics3D
   if ((texture = texturephrase(buf, r, g, b, a))) {
      return Failed; /* not handling textures yet */
      }
   else
#endif					/* Graphics3D */

   /* try interpreting as a color phrase or as a native color spec */
#ifdef GraphicsGL
   if (w->window->is_gl) {
      if (colorphrase(buf, r, g, b, a) || gl_nativecolor(w, buf, r, g, b))
         return Succeeded;
      else
         return Failed;
      }
   else
#endif					/* GraphicsGL */
   if (colorphrase(buf, r, g, b, a) || nativecolor(w, buf, r, g, b))
      return Succeeded;
   else
      return Failed;
   }

#ifdef Graphics3D
int mystrcmp(char *s1, char *s2)
{
   return strcmp(*(char **)s1, s2);
}

/*
 * texturephrase(s, &r, &g, &b, &texture) -- parse Unicon colored texture
 */
static int texturephrase(buf, r, g, b, a)
char *buf;
long *r, *g, *b, *a;
   {
   char buf2[128];
   char *p, *p2;
   int texture;

   if (strlen(buf) > 127) return 0;
   strcpy(buf2, buf);
   p = buf2+strlen(buf2)-1;
   while (*p == ' ' || *p == '\t') *p-- = '\0';
   p = buf2;
   while ((p2 = strchr(p, ' ')) || (p2 = strchr(p, '\t'))) p = p2+1;
   /*
    * p is at this point the last word in the texture phrase, see
    * if it is a texture.
    */
   p2 = qsearch(p, (char *)texturetable,
		ElemCount(texturetable), ElemSize(texturetable), mystrcmp);
   if (p2) {
      texture = ((char **)p2 - texturetable) + 1;
      if (p != buf2) {
	 p--;
	 *p = '\0';
	 if (colorphrase(buf2, r, g, b, a)) return texture;
	 else return 0;
	 }
      else return -texture;
      }
   return 0;
   }
#endif					/* Graphics3D */

/*
 *  colorphrase(s, &r, &g, &b, &a) -- parse Icon color phrase.
 *
 *  A Unicon color phrase matches the pattern
 *
 *   (0.0, 1.0]
 *   transparent
 *   subtransparent                           weak
 *   translucent                 pale         moderate
 *   subtranslucent              light        strong
 * [ opaque     ]        [[very] medium ]   [ vivid    ]   [color[ish]]   color
 *                               dark
 *                               deep
 *
 *  where "color" is any of:
 *
 *          black gray grey white pink violet brown
 *          red orange yellow green cyan blue purple magenta
 *
 *  A single space or hyphen separates each word from its neighbor.  The
 *  default lightness is "medium", and the default saturation is "vivid".
 *  The default diaphaneity is "opaque".
 *
 *  "pale" means "very light"; "deep" means "very dark".
 *
 *  This naming scheme is based loosely on
 *	A New Color-Naming System for Graphics Languages
 *	Toby Berk, Lee Brownston, and Arie Kaufman
 *	IEEE Computer Graphics & Applications, May 1982
 */

static int colorphrase(buf, r, g, b, a)
char *buf;
long *r, *g, *b, *a;
   {
   int len, very;
   char c, *p, *ebuf, cbuffer[MAXCOLORNAME];
   float lgt, sat, blend, bl2, m1, m2, alpha, tmpf;
   float h1, l1, s1, h2, l2, s2, r2, g2, b2;

   alpha = (float)(*a/65535.0);		/* default transparency */
   lgt = -1.0;				/* default no lightness mod */
   sat =  1.0;				/* default vivid saturation */
   len = strlen(buf);
   while (isspace(buf[len-1]))
      len--;				/* trim trailing spaces */

   if (len >= sizeof(cbuffer))
      return 0;				/* if too long for valid Icon spec */

   /*
    * copy spec, lowering case and replacing spaces and hyphens with NULs
    */
   for(p = cbuffer; (c = *buf) != 0; p++, buf++) {
      if (isupper(c)) *p = tolower(c);
      else if (c == ' ' || c == '-') *p = '\0';
      else *p = c;
      }
   *p = '\0';

   buf = cbuffer;
   ebuf = buf + len;

   /* check for diaphaneity adjective */
   p = qsearch(buf, (char *)transptable,
      ElemCount(transptable), ElemSize(transptable), strcmp);

   /* check for numeric diaphaneity value */
   tmpf = atof(buf);

   if (p || tmpf > 0.0) {
      /* skip past word */
      buf += strlen(buf) + 1;
      if (buf >= ebuf)
         return 0;
      /* save diaphaneity value, but ignore "opaque" */
      if (p && (((colrmod *)p) -> val) != 100)
         alpha = ((colrmod *)p) -> val / 100.0;
      /* save numeric diaphaneity value */
      else {
         if (tmpf >= 1.0) tmpf = 1.0;
         alpha = tmpf;
         }
      }

   /* check for "very" */
   if (strcmp(buf, "very") == 0) {
      very = 1;
      buf += strlen(buf) + 1;
      if (buf >= ebuf)
         return 0;
      }
   else
      very = 0;

   /* check for lightness adjective */
   p = qsearch(buf, (char *)lighttable,
      ElemCount(lighttable), ElemSize(lighttable), strcmp);
   if (p) {
      /* set the "very" flag for "pale" or "deep" */
      if (strcmp(buf, "pale") == 0)
         very = 1;			/* pale = very light */
      else if (strcmp(buf, "deep") == 0)
         very = 1;			/* deep = very dark */
      /* skip past word */
      buf += strlen(buf) + 1;
      if (buf >= ebuf)
         return 0;
      /* save lightness value, but ignore "medium" */
      if ((((colrmod *)p) -> val) != 50)
         lgt = ((colrmod *)p) -> val / 100.0;
      }
   else if (very)
      return 0;

   /* check for saturation adjective */
   p = qsearch(buf, (char *)sattable,
      ElemCount(sattable), ElemSize(sattable), strcmp);
   if (p) {
      sat = ((colrmod *)p) -> val / 100.0;
      buf += strlen(buf) + 1;
      if (buf >= ebuf)
         return 0;
      }

   if (buf + strlen(buf) >= ebuf)
      blend = h1 = l1 = s1 = 0.0;		/* only one word left */
   else {
      /* we have two (or more) name words; get the first */
      if ((p = qsearch(buf, colortable[0].name,
            ElemCount(colortable), ElemSize(colortable), strcmp)) != NULL) {
         blend = 0.5;
         }
      else if ((p = qsearch(buf, colortable[0].ish,
            ElemCount(colortable), ElemSize(colortable), strcmp)) != NULL) {
         p -= sizeof(colortable[0].name);
         blend = 0.25;
         }
      else
         return 0;

      h1 = ((colrname *)p) -> hue;
      l1 = ((colrname *)p) -> lgt / 100.0;
      s1 = ((colrname *)p) -> sat / 100.0;
      buf += strlen(buf) + 1;
      }

   /* process second (or only) name word */
   p = qsearch(buf, colortable[0].name,
      ElemCount(colortable), ElemSize(colortable), strcmp);
   if (!p || buf + strlen(buf) < ebuf)
      return 0;
   h2 = ((colrname *)p) -> hue;
   l2 = ((colrname *)p) -> lgt / 100.0;
   s2 = ((colrname *)p) -> sat / 100.0;

   /* at this point we know we have a valid spec */

   /* interpolate hls specs */
   if (blend > 0) {
      bl2 = 1.0 - blend;

      if (s1 == 0.0)
         ; /* use h2 unchanged */
      else if (s2 == 0.0)
         h2 = h1;
      else if (h2 - h1 > 180)
         h2 = blend * h1 + bl2 * (h2 - 360);
      else if (h1 - h2 > 180)
         h2 = blend * (h1 - 360) + bl2 * h2;
      else
         h2 = blend * h1 + bl2 * h2;
      if (h2 < 0)
         h2 += 360;

      l2 = blend * l1 + bl2 * l2;
      s2 = blend * s1 + bl2 * s2;
      }

   /* apply saturation and lightness modifiers */
   if (lgt >= 0.0) {
      if (very)
         l2 = (2 * lgt + l2) / 3.0;
      else
         l2 = (lgt + 2 * l2) / 3.0;
      }
   s2 *= sat;

   /* convert h2,l2,s2 to r2,g2,b2 */
   /* from Foley & Van Dam, 1st edition, p. 619 */
   /* beware of dangerous typos in 2nd edition */
   if (s2 == 0)
      r2 = g2 = b2 = l2;
   else {
      if (l2 < 0.5)
         m2 = l2 * (1 + s2);
      else
         m2 = l2 + s2 - l2 * s2;
      m1 = 2 * l2 - m2;
      r2 = rgbval(m1, m2, h2 + 120);
      g2 = rgbval(m1, m2, h2);
      b2 = rgbval(m1, m2, h2 - 120);
      }

   /* scale and convert the calculated result */
   *r = 65535 * r2;
   *g = 65535 * g2;
   *b = 65535 * b2;
   *a = 65535 * alpha;

   return 1;
   }

/*
 * rgbval(n1, n2, hue) - helper function for HLS to RGB conversion
 */
static double rgbval(n1, n2, hue)
double n1, n2, hue;
   {
   if (hue > 360)
      hue -= 360;
   else if (hue < 0)
      hue += 360;

   if (hue < 60)
      return n1 + (n2 - n1) * hue / 60.0;
   else if (hue < 180)
      return n2;
   else if (hue < 240)
      return n1 + (n2 - n1) * (240 - hue) / 60.0;
   else
      return n1;
   }

/*
 *  Functions and data for reading and writing GIF and JPEG images
 */

#define GifSeparator	0x2C	/* (',') beginning of image */
#define GifTerminator	0x3B	/* (';') end of image */
#define GifExtension	0x21	/* ('!') extension block */
#define GifControlExt	0xF9	/*       graphic control extension label */
#define GifEmpty	-1	/* internal flag indicating no prefix */

#define GifTableSize	4096	/* maximum number of entries in table */
#define GifBlockSize	255	/* size of output block */

typedef struct lzwnode {	/* structure of LZW encoding tree node */
   unsigned short tcode;		/* token code */
   unsigned short child;	/* first child node */
   unsigned short sibling;	/* next sibling */
   } lzwnode;

#if HAVE_LIBJPEG
struct my_error_mgr { /* a part of JPEG error handling */
  struct jpeg_error_mgr pub;	/* "public" fields */
  jmp_buf setjmp_buffer;	/* for return to caller */
};

typedef struct my_error_mgr * my_error_ptr; /* a part of error handling */
#endif					/* HAVE_LIBJPEG */

static	int	gfread		(char *fn, int p);
static	int	gfheader	(FILE *f);
static	int	gfskip		(FILE *f);
static	void	gfcontrol	(FILE *f);
static	int	gfimhdr		(FILE *f);
static	int	gfmap		(FILE *f, int p);
static	int	gfsetup		(void);
static	int	gfrdata		(FILE *f);
static	int	gfrcode		(FILE *f);
static	void	gfinsert	(int prev, int c);
static	int	gffirst		(int c);
static	void	gfgen		(int c);
static	void	gfput		(int b);

static	int	gfwrite		(wbp w, char *filename,
				   int x, int y, int width, int height);
static	int	bmpwrite	(wbp w, char *filename,
				   int x, int y, int width, int height);
static	void	gfpack		(unsigned char *data, long len,
				   struct palentry *paltbl);
static	void	gfmktree	(lzwnode *tree);
static	void	gfout		(int tcode);
static	void	gfdump		(void);

static FILE *gf_f;			/* input file */

static int gf_gcmap, gf_lcmap;		/* global color map? local color map? */
static int gf_nbits;			/* number of bits per pixel */
static int gf_ilace;			/* interlace flag */
static int gf_width, gf_height;		/* image size */

static short *gf_prefix, *gf_suffix;	/* prefix and suffix tables */
static int gf_free;			/* next free position */

static struct palentry *gf_paltbl;	/* palette table */
static unsigned char *gf_string;	/* image string */
static unsigned char *gf_nxt, *gf_lim;	/* store pointer and its limit */
static int gf_row, gf_step;		/* current row and step size */

static int gf_cdsize;			/* code size */
static int gf_clear, gf_eoi;		/* values of CLEAR and EOI codes */
static int gf_lzwbits, gf_lzwmask;	/* current bits per code */

static unsigned char *gf_obuf;		/* output buffer */
static unsigned long gf_curr;		/* current partial byte(s) */
static int gf_valid;			/* number of valid bits */
static int gf_rem;			/* remaining bytes in this block */

/*
 * Construct Icon-style paltbl from BMP-style colortable
 */
struct palentry *bmp_paltbl(int n, int *colortable)
{
   int i;
   if (!(gf_paltbl=(struct palentry *)calloc(256, sizeof(struct palentry))))
      return NULL;
   for(i=0;i<n;i++) {
      gf_paltbl[i].used = gf_paltbl[i].valid = 1;
      gf_paltbl[i].transpt = 0;
      gf_paltbl[i].clr.red = ((unsigned char)((char *)(colortable+i))[2]) * 257;
      gf_paltbl[i].clr.green = ((unsigned char)((char *)(colortable+i))[1]) * 257;
      gf_paltbl[i].clr.blue = ((unsigned char)((char *)(colortable+i))[0]) * 257;
      }
   return gf_paltbl;
}

/*
 * Construct Icon-style imgdata from BMP-style rasterdata.
 * Only trick we know about so far is to reverse rows so first row is bottom
 * But apparently this is wrong (for some bmp's?) if there's no color table.
 */
unsigned char * bmp_data(int width, int height, int bpp, char * rasterdata, int bottom_up)
{
   int i;
   int rowbytes = width * bpp;
   char *tmp;

   if (bottom_up) return (unsigned char *)rasterdata;

   if ((tmp = malloc(rowbytes))==NULL) return NULL;
   for(i=0;i<height/2;i++) {
      memmove(tmp, rasterdata + (i * rowbytes), rowbytes);
      memmove(rasterdata + (i * rowbytes),
	   rasterdata + (height-i-1) * rowbytes, rowbytes);
      memmove(rasterdata + (height-i-1) * rowbytes, tmp, rowbytes);
      }
  free(tmp);
  return (unsigned char *)rasterdata;
}


/*
 * readBMP() - BMP file reader, patterned after readGIF().
 */
int readBMP(char *filename, int p, struct imgdata *imd)
{
  FILE *f;
  int c;
  char headerstuff[52]; /* 54 - 2 byte magic number = 52 */
  int filesize, width, height, compression, imagesize, numcolors;
  short bitcount;
  int *colortable = NULL;
  char *rasterdata;
  if ((f = fopen(filename, "rb")) == NULL) return Failed;
  if (((c = getc(f)) != 'B') || ((c = getc(f)) != 'M')) {
     fclose(f);
     return Failed;
     }
  if (fread(headerstuff, 1, 52, f) < 52) {
     fclose(f);
     return Failed;
     }
  filesize = *(int *)(headerstuff);
  width = *(int *)(headerstuff+16);
  height = *(int *)(headerstuff+20);
  bitcount = *(short *)(headerstuff+26);
  switch(bitcount) {
     case 1: numcolors = 1; break;
     case 4: numcolors = 16; break;
     case 8: numcolors = 256; break;
     case 16: numcolors = 65536; break;
     case 24: numcolors = 65536 * 256;
     default:
        /* teart as 8-bit ?*/
	numcolors = 256; break;
     }
  compression = *(int *)(headerstuff+28);
  if (compression != 0) {
     fprintf(stderr, "warning, can't read compressed bmp's yet\n");
     fclose(f);
     return Failed;
     }

  imagesize = *(int *)(headerstuff+32);
  if (compression == 0 && (imagesize==0)) {
     imagesize = filesize - 54;
     if (bitcount <= 8) imagesize -= 4 * numcolors;
     }

  if (bitcount <= 8) {
     if ((colortable = (int *)malloc(4 * numcolors)) == NULL) {
	fclose(f); return Failed;
	}
     if (fread(colortable, 4, numcolors, f) < numcolors) {
	fclose(f); return Failed;
	}
     }
  if ((rasterdata = (char *)malloc(imagesize))) {
     if (fread(rasterdata, 1, imagesize, f) < imagesize) {
	fclose(f); return Failed;
	}
     /* OK, read the whole thing, now what to do with it ? */
     imd->width = width;
     imd->height = height;
     if (colortable) {
        imd->paltbl = bmp_paltbl(numcolors, colortable);
        imd->data = bmp_data(width, height, 1, rasterdata, imd->is_bottom_up);
        }
     else {
        imd->paltbl = NULL;
        imd->data = bmp_data(width, height, 3, rasterdata, imd->is_bottom_up);
#if NT
	if (imd->format == UCOLOR_RGB &&  bitcount == 24 ){
	   unsigned char *byte, t;
 	   for (byte=imd->data; byte<imd->data+width*height*3; byte+=3)
	     {t = byte[0]; byte[0] = byte[2]; byte[2] = t;}
	   }
#endif
        }
     return Succeeded;
     }
  fclose(f);
  return Failed;
}
/*
 * readGIF(filename, p, imd) - read GIF file into image data structure
 *
 * p is a palette number to which the GIF colors are to be coerced;
 * p=0 uses the colors exactly as given in the GIF file.
 */
int readGIF(char *filename, int p, struct imgdata *imd)
   {
   int r;

   r = gfread(filename, p);			/* read image */

   if (gf_prefix) {
      free((pointer)gf_prefix);
      gf_prefix = NULL;
      }
   if (gf_suffix) {
      free((pointer)gf_suffix);
      gf_suffix = NULL;
      }
   if (gf_f) {
      fclose(gf_f);
      gf_f = NULL;
      }

   if (r != Succeeded) {			/* if no success, free mem */
      if (gf_paltbl) {
	 free((pointer) gf_paltbl);
	 gf_paltbl = NULL;
	 }
      if (gf_string) {
	 free((pointer) gf_string);
	 gf_string = NULL;
	 }
      return r;					/* return Failed or RunError */
      }

   imd->width = gf_width;			/* set return variables */
   imd->height = gf_height;
   imd->paltbl = gf_paltbl;
   imd->data = gf_string;

   return Succeeded;				/* return success */
   }

/*
 * gfread(filename, p) - read GIF file, setting gf_ globals
 */
static int gfread(filename, p)
char *filename;
int p;
   {
   int i;

   gf_f = NULL;
   gf_prefix = NULL;
   gf_suffix = NULL;
   gf_string = NULL;

   if (!(gf_paltbl=(struct palentry *)malloc(256 * sizeof(struct palentry))))
      return Failed;

#ifdef MSWindows
	   if ((gf_f = fopen(filename, "rb")) == NULL)
#else					/* MSWindows */
	   if ((gf_f = fopen(filename, "r")) == NULL)
#endif					/* MSWindows */
      return Failed;

   for (i = 0; i < 256; i++)		/* init palette table */
      gf_paltbl[i].used = gf_paltbl[i].valid = gf_paltbl[i].transpt = 0;

   if (!gfheader(gf_f))			/* read file header */
      return Failed;
   if (gf_gcmap)			/* read global color map, if any */
      if (!gfmap(gf_f, p))
         return Failed;
   if (!gfskip(gf_f))			/* skip to start of image */
      return Failed;
   if (!gfimhdr(gf_f))			/* read image header */
      return Failed;
   if (gf_lcmap)			/* read local color map, if any */
      if (!gfmap(gf_f, p))
         return Failed;
   if (!gfsetup())			/* prepare to read image */
      return RunError;
   if (!gfrdata(gf_f))			/* read image data */
      return Failed;
   while (gf_row < gf_height)		/* pad if too short */
      gfput(0);

   return Succeeded;
   }

/*
 * gfheader(f) - read GIF file header; return nonzero if successful
 */
static int gfheader(f)
FILE *f;
   {
   unsigned char hdr[13];		/* size of a GIF header */
   int b;

   if (fread((char *)hdr, sizeof(char), sizeof(hdr), f) != sizeof(hdr))
      return 0;				/* header short or missing */
   if (strncmp((char *)hdr, "GIF", 3) != 0 ||
         !isdigit(hdr[3]) || !isdigit(hdr[4]))
      return 0;				/* not GIFnn */

   b = hdr[10];				/* flag byte */
   gf_gcmap = b & 0x80;			/* global color map flag */
   gf_nbits = (b & 7) + 1;		/* number of bits per pixel */
   return 1;
   }

/*
 * gfskip(f) - skip intermediate blocks and locate image
 */
static int gfskip(f)
FILE *f;
   {
   int c, n;

   while ((c = getc(f)) != GifSeparator) { /* look for start-of-image flag */
      if (c == EOF)
         return 0;
      if (c == GifExtension) {		/* if extension block is present */
         c = getc(f);				/* get label */
	 if ((c & 0xFF) == GifControlExt)
	    gfcontrol(f);			/* process control subblock */
         while ((n = getc(f)) != 0) {		/* read blks until empty one */
            if (n == EOF)
               return 0;
	    n &= 0xFF;				/* ensure positive count */
            while (n--)				/* skip block contents */
               getc(f);
            }
         }
      }
   return 1;
   }

/*
 * gfcontrol(f) - process control extension subblock
 */
static void gfcontrol(f)
FILE *f;
   {
   int i, n, c, t;

   n = getc(f) & 0xFF;				/* subblock length (s/b 4) */
   for (i = t = 0; i < n; i++) {
      c = getc(f) & 0xFF;
      if (i == 0)
	 t = c & 1;				/* transparency flag */
      else if (i == 3 && t != 0) {
	 gf_paltbl[c].transpt = 1;		/* set flag for transpt color */
	 gf_paltbl[c].valid = 0;		/* color is no longer "valid" */
	 }
      }
   }

/*
 * gfimhdr(f) - read image header
 */
static int gfimhdr(f)
FILE *f;
   {
   unsigned char hdr[9];		/* size of image hdr excl separator */
   int b;

   if (fread((char *)hdr, sizeof(char), sizeof(hdr), f) != sizeof(hdr))
      return 0;				/* header short or missing */
   gf_width = hdr[4] + 256 * hdr[5];
   gf_height = hdr[6] + 256 * hdr[7];
   b = hdr[8];				/* flag byte */
   gf_lcmap = b & 0x80;			/* local color map flag */
   gf_ilace = b & 0x40;			/* interlace flag */
   if (gf_lcmap)
      gf_nbits = (b & 7) + 1;		/* if local map, reset nbits also */
   return 1;
   }

/*
 * gfmap(f, p) - read GIF color map into paltbl under control of palette p
 */
static int gfmap(f, p)
FILE *f;
int p;
   {
   int ncolors, i, r, g, b, c;
   struct palentry *stdpal = 0;

   if (p)
      stdpal = palsetup(p);

   ncolors = 1 << gf_nbits;

   for (i = 0; i < ncolors; i++) {
      r = getc(f);
      g = getc(f);
      b = getc(f);
      if (r == EOF || g == EOF || b == EOF)
         return 0;
      if (p) {
         c = *(unsigned char *)(rgbkey(p, r / 255.0, g / 255.0, b / 255.0));
         gf_paltbl[i].clr = stdpal[c].clr;
         }
      else {
         gf_paltbl[i].clr.red   = 257 * r;	/* 257 * 255 -> 65535 */
         gf_paltbl[i].clr.green = 257 * g;
         gf_paltbl[i].clr.blue  = 257 * b;
         }
      if (!gf_paltbl[i].transpt)		/* if not transparent color */
         gf_paltbl[i].valid = 1;		/* mark as valid/opaque */
      }

   return 1;
   }

/*
 * gfsetup() - prepare to read GIF data
 */
static int gfsetup()
   {
   int i;
   word len;

   len = (word)gf_width * (word)gf_height;
   gf_string = (unsigned char *)malloc((msize)len);
   gf_prefix = (short *)malloc(GifTableSize * sizeof(short));
   gf_suffix = (short *)malloc(GifTableSize * sizeof(short));
   if (!gf_string || !gf_prefix || !gf_suffix)
      return 0;
   for (i = 0; i < GifTableSize; i++) {
      gf_prefix[i] = GifEmpty;
      gf_suffix[i] = i;
      }

   gf_row = 0;				/* current row is 0 */
   gf_nxt = gf_string;			/* set store pointer */

   if (gf_ilace) {			/* if interlaced */
      gf_step = 8;			/* step rows by 8 */
      gf_lim = gf_string + gf_width;	/* stop at end of one row */
      }
   else {
      gf_lim = gf_string + len;		/* do whole image at once */
      gf_step = gf_height;		/* step to end when full */
      }

   return 1;
   }

/*
 * gfrdata(f) - read GIF data
 */
static int gfrdata(f)
FILE *f;
   {
   int curr, prev, c;

   if ((gf_cdsize = getc(f)) == EOF)
      return 0;
   gf_clear = 1 << gf_cdsize;
   gf_eoi = gf_clear + 1;
   gf_free = gf_eoi + 1;

   gf_lzwbits = gf_cdsize + 1;
   gf_lzwmask = (1 << gf_lzwbits) - 1;

   gf_curr = 0;
   gf_valid = 0;
   gf_rem = 0;

   prev = curr = gfrcode(f);
   while (curr != gf_eoi) {
      if (curr == gf_clear) {		/* if reset code */
         gf_lzwbits = gf_cdsize + 1;
         gf_lzwmask = (1 << gf_lzwbits) - 1;
         gf_free = gf_eoi + 1;
         prev = curr = gfrcode(f);
         gfgen(curr);
         }
      else if (curr < gf_free) {	/* if code is in table */
         gfgen(curr);
         gfinsert(prev, gffirst(curr));
         prev = curr;
         }
      else if (curr == gf_free) {	/* not yet in table */
         c = gffirst(prev);
         gfgen(prev);
         gfput(c);
         gfinsert(prev, c);
         prev = curr;
         }
      else {				/* illegal code */
         if (gf_nxt == gf_lim)
            return 1;			/* assume just extra stuff after end */
         else
            return 0;			/* more badly confused */
         }
      curr = gfrcode(f);
      }

   return 1;
   }

/*
 * gfrcode(f) - read next LZW code
 */
static int gfrcode(f)
FILE *f;
   {
   int c, r;

   while (gf_valid < gf_lzwbits) {
      if (--gf_rem <= 0) {
         if ((gf_rem = getc(f)) == EOF)
            return gf_eoi;
         }
      if ((c = getc(f)) == EOF)
         return gf_eoi;
      gf_curr |= ((c & 0xFF) << gf_valid);
      gf_valid += 8;
      }
   r = gf_curr & gf_lzwmask;
   gf_curr >>= gf_lzwbits;
   gf_valid -= gf_lzwbits;
   return r;
   }

/*
 * gfinsert(prev, c) - insert into table
 */
static void gfinsert(prev, c)
int prev, c;
   {

   if (gf_free >= GifTableSize)		/* sanity check */
      return;

   gf_prefix[gf_free] = prev;
   gf_suffix[gf_free] = c;

   /* increase code size if code bits are exhausted, up to max of 12 bits */
   if (++gf_free > gf_lzwmask && gf_lzwbits < 12) {
      gf_lzwmask = gf_lzwmask * 2 + 1;
      gf_lzwbits++;
      }

   }

/*
 * gffirst(c) - return the first pixel in a map structure
 */
static int gffirst(c)
int c;
   {
   int d;

   if (c >= gf_free)
      return 0;				/* not in table (error) */
   while ((d = gf_prefix[c]) != GifEmpty)
      c = d;
   return gf_suffix[c];
   }

/*
 * gfgen(c) - generate and output prefix
 */
static void gfgen(c)
int c;
   {
   int d;

   if ((d = gf_prefix[c]) != GifEmpty)
      gfgen(d);
   gfput(gf_suffix[c]);
   }

/*
 * gfput(b) - add a byte to the output string
 */
static void gfput(b)
int b;
   {
   if (gf_nxt >= gf_lim) {		/* if current row is full */
      gf_row += gf_step;
      while (gf_row >= gf_height && gf_ilace && gf_step > 2) {
         if (gf_step == 4) {
            gf_row = 1;
            gf_step = 2;
            }
	 else if ((gf_row % 8) != 0) {
            gf_row = 2;
            gf_step = 4;
            }
         else {
            gf_row = 4;
	    /* gf_step remains 8 */
	    }
	 }

      if (gf_row >= gf_height) {
	 gf_step = 0;
	 return;			/* too much data; ignore it */
	 }
      gf_nxt = gf_string + ((word)gf_row * (word)gf_width);
      gf_lim = gf_nxt + gf_width;
      }

   *gf_nxt++ = b;			/* store byte */
   gf_paltbl[b].used = 1;		/* mark color entry as used */
   }


#if HAVE_LIBJPEG

/*
 * jpeg error handler 
 */

void my_error_exit (j_common_ptr cinfo)
{
  my_error_ptr myerr = (my_error_ptr) cinfo->err;
/*  (*cinfo->err->output_message) (cinfo); */
  longjmp(myerr->setjmp_buffer, 1);
}

/*
 * jpegread(filename, p, image) - read jpeg file
 */
static int jpegread(char *filename, int p, struct imgdata *imd)
{
   struct jpeg_decompress_struct cinfo; /* libjpeg struct */
   struct my_error_mgr jerr;
   JSAMPARRAY buffer;
   unsigned char *row_ptr;
   int row_stride, row_stride_shift;
   int i;
   static FILE *jpg_f = NULL;			/* input file */

#ifdef MSWindows
      if ((jpg_f = fopen(filename, "rb")) == NULL)
#else					/* MSWindows */
      if ((jpg_f = fopen(filename, "r")) == NULL)
#endif					/* MSWindows */
	 return Failed;

   cinfo.err = jpeg_std_error(&jerr.pub);
   jerr.pub.error_exit = my_error_exit;

   if (setjmp(jerr.setjmp_buffer)) {
      jpeg_destroy_decompress(&cinfo);
      if (jpg_f != NULL)
	 fclose(jpg_f);
      return Failed;
      }

   jpeg_create_decompress(&cinfo);
   jpeg_stdio_src(&cinfo, jpg_f);
   jpeg_read_header(&cinfo, TRUE);

   /*
    * set parameters for decompression
    */
   if (p == 1) {  /* 8-bit */
      cinfo.quantize_colors = TRUE;
      cinfo.desired_number_of_colors = 254;
      }
   else {
      /*
       * Check the requested image color format. Use BGR on windows 
       * if it is available (jpeg-turbo) by checking for JCS_EXTENSIONS macro
       */
      
      cinfo.out_color_space = JCS_RGB;
      cinfo.quantize_colors = FALSE;

#ifdef JCS_EXTENSIONS
      if (imd->format == UCOLOR_BGR)
         cinfo.out_color_space = JCS_EXT_BGR;
#endif
      }

   /* Start decompression */

   jpeg_start_decompress(&cinfo);
   imd->width = cinfo.output_width;
   imd->height = cinfo.output_height;
   row_stride = cinfo.output_width * cinfo.output_components; /* actual width of the image */

   if (p == 1) {
      if (!(imd->paltbl=(struct palentry *)malloc(256 * sizeof(struct palentry))))
	 return Failed;

      for (i = 0; i < cinfo.actual_number_of_colors; i++) {
	 /* init palette table */
	 imd->paltbl[i].used = 1;
	 imd->paltbl[i].valid = 1;
	 imd->paltbl[i].transpt = 0;
	 imd->paltbl[i].clr.red = cinfo.colormap[0][i] * 257;
	 imd->paltbl[i].clr.green = cinfo.colormap[1][i] * 257;
	 imd->paltbl[i].clr.blue = cinfo.colormap[2][i] * 257;
	 }

      for(;i < 256; i++) {
	 imd->paltbl[i].used = imd->paltbl[i].valid = imd->paltbl[i].transpt = 0;
	 }
      }

      imd->data = calloc(row_stride*cinfo.output_height,
			 sizeof(unsigned char));
   /*
    * Make a one-row-high sample array that will go away when done with image
    */
   buffer = (*cinfo.mem->alloc_sarray)
      ((j_common_ptr) &cinfo, JPOOL_IMAGE, row_stride, 1);

   if (imd->is_bottom_up){
      row_stride_shift = -row_stride;
      row_ptr = imd->data + (cinfo.output_height-1) * row_stride;
      }
   else{
      row_stride_shift = row_stride;
      row_ptr = imd->data;
      }

   while (cinfo.output_scanline < cinfo.output_height) {
      (void) jpeg_read_scanlines(&cinfo, buffer, 1);
      memcpy(row_ptr, buffer[0], row_stride);
      row_ptr += row_stride_shift;
      }

#ifndef JCS_EXTENSIONS
   /*
    * If we don't have JCS_EXTENSIONS provided by libjpeg-turbo then
    * we have to transoform the format from RGB to BGR if needed
    */
   if (imd->format == UCOLOR_BGR ){
      unsigned char c, *byte;
      unsigned char *imgEnd = imd->data + row_stride*cinfo.output_height;
      for (byte=imd->data; byte<imgEnd; byte +=3){
         c = *byte; *byte = byte[2]; byte[2] = c;
         }
   }
#endif					/* !JCS_EXTENSIONS */

   /*
    * Finish and release the JPEG decompression object
    */
   (void) jpeg_finish_decompress(&cinfo); /* jpeg lib function call */
   jpeg_destroy_decompress(&cinfo); /* jpeg lib function call */

   fclose(jpg_f);
   jpg_f = NULL;
   return Succeeded;
}

/*
 * readJPEG(filename, p, imd) - read JPEG file into image data structure
 * p is a palette number to which the JPEG colors are to be coerced;
 * p=0 uses the colors exactly as given in the JPEG file.
 */

int readJPEG(char *filename, int p, struct imgdata *imd)
{
   int r;
   imd->paltbl = NULL;
   imd->data = NULL;

   r = jpegread(filename, p, imd);			/* read image */
   if (r == Failed){
      if (imd->paltbl) free(imd->paltbl);
      if (imd->data) free(imd->data);
      return Failed;
      }

   return Succeeded;				/* return success */
}

#endif

#if HAVE_LIBPNG
/*
 * pngread(filename, p) - read png file, setting gf_ globals
 */

static int pngread(char *filename, int p, struct imgdata *imd)
{
   unsigned char header[8];
   int  bit_depth, color_type;
   double  gamma;
   png_uint_32  i, rowbytes, mywidth, myheight;
   png_bytepp row_pointers = NULL;
   png_color_16p image_background;
   /*png_color_16 my_background;*/
   png_structp png_ptr = NULL;
   png_infop info_ptr = NULL;
   png_infop end_info = NULL;

   FILE * png_f = NULL;

   #ifdef MSWindows
      if ((png_f = fopen(filename, "rb")) == NULL) {
   #else					/* MSWindows */
      if ((png_f = fopen(filename, "r")) == NULL) {
   #endif					/* MSWindows */
	 return Failed;
	 }

   /* read the first n bytes (1-8, 8 used here) and test for png signature */
   if (fread(header, 1, 8, png_f) < 8) {
      fclose(png_f);
      return Failed;
      }   

   if (png_sig_cmp(header, 0, 8)) {
      fclose(png_f);
      return Failed;  /* (NOT_PNG) */
      }

   png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);

   if (!png_ptr){
      fclose(png_f);   
      return Failed;
      }

   info_ptr = png_create_info_struct(png_ptr);
   if (!info_ptr) {
      png_destroy_read_struct(&png_ptr, NULL, NULL);
      fclose(png_f);      
      return Failed;
      }

   end_info = png_create_info_struct(png_ptr);
   if (!end_info){
      png_destroy_read_struct(&png_ptr, &info_ptr, NULL);
      fclose(png_f);      
      return Failed;
      }

   if (setjmp(png_jmpbuf(png_ptr))) {
      png_destroy_read_struct(&png_ptr, &info_ptr, &end_info);
      if (png_f) { fclose(png_f); png_f = NULL; }
      return Failed;
      }

   png_init_io(png_ptr, png_f);
   png_set_sig_bytes(png_ptr, 8);
   png_read_info(png_ptr, info_ptr);

   png_get_IHDR(png_ptr, info_ptr, &mywidth, &myheight, &bit_depth, 
   		&color_type, NULL, NULL, NULL);

   imd->width  = (int) mywidth;
   imd->height = (int) myheight;
 
   /*
    * Expand palette images to RGB, low-bit-depth grayscale images to 8 bits,
    * transparency chunks to full alpha channel; strip 16-bit-per-sample
    * images to 8 bits per sample; and convert grayscale to RGB[A]
    */

   switch (color_type) {
      case PNG_COLOR_TYPE_PALETTE:
	 png_set_palette_to_rgb(png_ptr);
	 break;
      case PNG_COLOR_TYPE_GRAY:
	 if (bit_depth < 8)
	    png_set_expand_gray_1_2_4_to_8(png_ptr);
	 png_set_gray_to_rgb(png_ptr);
	 break;
      case PNG_COLOR_TYPE_GRAY_ALPHA:
	 if (bit_depth < 8)
	    png_set_expand_gray_1_2_4_to_8(png_ptr);
	 png_set_gray_to_rgb(png_ptr);
	 png_set_strip_alpha(png_ptr);
	 break;
      case PNG_COLOR_TYPE_RGB:
	 break;
      case PNG_COLOR_TYPE_RGB_ALPHA:
	 png_set_strip_alpha(png_ptr);
	 break;
      }

   if (bit_depth == 16)
      png_set_strip_16(png_ptr);
   else if (bit_depth < 8)
      png_set_packing(png_ptr);

   if (imd->format == UCOLOR_BGR )
      if (color_type == PNG_COLOR_TYPE_RGB ||
          color_type == PNG_COLOR_TYPE_RGB_ALPHA ||
          color_type == PNG_COLOR_TYPE_PALETTE)
         png_set_bgr(png_ptr);

   if (png_get_valid(png_ptr, info_ptr, PNG_INFO_tRNS)){
      /* adds a full alpha channel if there is transparency information
       * in a tRNS chunk.  for now just strip alpha off.
       */
      /*png_set_tRNS_to_alpha(png_ptr);*/
      png_set_strip_alpha(png_ptr);
      }
	 
   if (png_get_bKGD(png_ptr, info_ptr, &image_background))
        png_set_background(png_ptr, image_background,
        	PNG_BACKGROUND_GAMMA_FILE, 1, 1.0);
   /*else
      png_set_background(png_ptr, &my_background,
      	PNG_BACKGROUND_GAMMA_SCREEN, 0, 1.0);
    */

   /*
    * do file gamma for gamma correction, or use a default gamma
    */
   if (png_get_gAMA(png_ptr, info_ptr, &gamma))
      png_set_gamma(png_ptr, GammaCorrection, gamma);
   else
      png_set_gamma(png_ptr, GammaCorrection, 1.0/2.2);

   /*
    * All transformations have been registered; now update info_ptr data,
    * get rowbytes and channels, and allocate image memory.
    */

   png_read_update_info(png_ptr, info_ptr);

   rowbytes = png_get_rowbytes(png_ptr, info_ptr);

   if ((imd->data = (unsigned char *)malloc(rowbytes*imd->height)) == NULL) {
      png_destroy_read_struct(&png_ptr, &info_ptr, &end_info);
      return Failed;
      }

   if ((row_pointers=(png_bytepp)malloc(imd->height*sizeof(png_bytep))) == NULL){
      png_destroy_read_struct(&png_ptr, &info_ptr, &end_info);
      return Failed;
      }

   /* set the individual row_pointers to point at the correct offsets */
   if (imd->is_bottom_up)
      for (i = 0;  i < imd->height;  ++i)
         row_pointers[imd->height-1-i] = imd->data + i*rowbytes;
   else
      for (i = 0;  i < imd->height;  ++i)
         row_pointers[i] = imd->data + i*rowbytes;

   /* now we can go ahead and just read the whole image */
   png_read_image(png_ptr, row_pointers);

   /* and we're done!  (png_read_end() can be omitted if no processing of
    * post-IDAT text/time/etc. is desired) */

   free(row_pointers);
   row_pointers = NULL;

   /*png_read_end(png_ptr, NULL);*/

   if (png_ptr && info_ptr) {
      png_destroy_read_struct(&png_ptr, &info_ptr, &end_info);
      png_ptr = NULL;
      info_ptr = NULL;
      end_info = NULL;
      }

   fclose(png_f);
   png_f = NULL;
   return Succeeded;
}

/*
 * readPNG(filename, p, imd) - read PNG file into image data structure
 * p is a palette number to which the PNG colors are to be coerced;
 * p=0 uses the colors exactly as given in the PNG file.
 */

int readPNG(char *filename, int p, struct imgdata *imd)
{
   int r;
   imd->paltbl = NULL;
   imd->data = NULL;

   r = pngread(filename, p, imd);			/* read image */
   if (r == Failed){
      if (imd->paltbl) free(imd->paltbl);
      if (imd->data) free(imd->data);
      return Failed;
      }

   return Succeeded;				/* return success */
}



#ifdef ConsoleWindow
#undef fprintf
#undef putc
#define putc fputc
#endif					/* ConsoleWindow */

/*
 * pngwrite(w, filename, x, y, width, height) - write PNG file
 */

static int pngwrite(wbp w, FILE *png_f, int x, int y, int width, int height, unsigned char *imgBuf)
{
   int i, rowbytes;
   png_structp png_ptr;
   png_infop info_ptr;
   png_bytep * row_pointers=NULL;

   if ((row_pointers=(png_bytepp)malloc( height * sizeof(png_bytep))) == NULL)
      return Failed;

   png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);

   if (!png_ptr){
      free(row_pointers);
      return Failed;
      }

   info_ptr = png_create_info_struct(png_ptr);
   if (!info_ptr){
      png_destroy_write_struct (&png_ptr, NULL);
      free(row_pointers);
      return Failed;
      }

   if (setjmp(png_jmpbuf(png_ptr))){
     png_destroy_write_struct (&png_ptr, &info_ptr);
     free(row_pointers);
     return Failed;
    }

   png_init_io(png_ptr, png_f);

   png_set_IHDR(png_ptr, info_ptr, width, height,
                     8, PNG_COLOR_TYPE_RGB, PNG_INTERLACE_NONE,
                     PNG_COMPRESSION_TYPE_DEFAULT, PNG_FILTER_TYPE_DEFAULT);

   png_write_info(png_ptr, info_ptr);

   /* set the individual row_pointers to point at the correct offsets */
   rowbytes = width * 3;
   for (i = 0; i < height;  i++)
      row_pointers[i] = imgBuf + i*rowbytes;

   /*
   png_set_rows (png_ptr, info_ptr, row_pointers);
   png_write_png (png_ptr, info_ptr, PNG_TRANSFORM_IDENTITY, NULL);
   */
   png_write_image(png_ptr, row_pointers);

   png_write_end(png_ptr, NULL);
   png_destroy_write_struct (&png_ptr, &info_ptr);

   free(row_pointers);
   return Succeeded;
 }

/*
 * writePNG(w, filename, x, y, width, height) - write JPEG image
 * Returns Succeeded, Failed, or RunError.
 * We assume that the area specified is within the window.
 */
int writePNG(wbp w, char *filename, int x, int y, int width, int height)
   {
   int r;
   FILE * png_f = NULL;
   unsigned char *imgBuf = NULL;

   if (!(imgBuf = (unsigned char*)malloc( width * height * 3 * sizeof(unsigned char))))
      return RunError;

#ifdef GraphicsGL
   if (w->window->is_gl) {
      if (!gl_getimstr24(w, x, y, width, height, imgBuf)) {
         free(imgBuf);
         return RunError;
         }
      }
   else
#endif					/* GraphicsGL */
   if (!getimstr24(w, x, y, width, height, imgBuf)) {
      free(imgBuf);
      return RunError;
      }

   if ((png_f = fopen(filename,"wb")) == NULL) {
      free(imgBuf);
      return Failed;
      }

   r = pngwrite(w, png_f, x, y, width, height, imgBuf);

   free(imgBuf);
   fclose(png_f);
   
   return r;
   }

#endif		/*  HAVE_LIBPNG  */

/*
 * writeBMP(w, filename, x, y, width, height) - write BMP image
 *
 * Fails if filename does not end in .bmp or .BMP; default is write .GIF.
 * Returns Succeeded, Failed, or RunError.
 * We assume that the area specified is within the window.
 */
int writeBMP(wbp w, char *filename, int x, int y, int width, int height)
{
   int r;
   if (strstr(filename, ".BMP")==NULL && strstr(filename,".bmp")==NULL)
      return NoCvt;

   r = bmpwrite(w, filename, x, y, width, height);
   if (gf_f) { fclose(gf_f); gf_f = NULL; }
   if (gf_string) { free((pointer)gf_string); gf_string = NULL; }
   return r;
}

/*
 * bmpwrite(w, filename, x, y, width, height) - write BMP file
 */

static int bmpwrite(wbp w, char *filename, int x, int y, int width, int height)
   {
   int i, a[6];
   short sh[2];
   long len;
   struct palentry paltbl[DMAXCOLORS];

   len = (long)width * (long)height;	/* total length of data */

   if (!(gf_f = fopen(filename, "wb")))
      return Failed;
   if (!(gf_string = (unsigned char*)malloc((msize)len)))
      return RunError;

   for (i = 0; i < DMAXCOLORS; i++)
      paltbl[i].used = paltbl[i].valid = paltbl[i].transpt = 0;
#ifdef GraphicsGL
   if (w->window->is_gl) {
      if (!gl_getimstr(w, x, y, width, height, paltbl, gf_string))
         return RunError;
      }
   else 
#endif					/* GraphicsGL */
   if (!getimstr(w, x, y, width, height, paltbl, gf_string))
      return RunError;

   fprintf(gf_f, "BM");
   a[0] = 54 + 4 * 256 + len;
   a[1] = 0;
   a[2] = 54 + 4 * 256;
   a[3] = 40;
   a[4] = width;
   a[5] = height;
   if (fwrite(a, 4, 6, gf_f) < 6) return Failed;
   sh[0] = 1;
   sh[1] = 8;
   if (fwrite(sh, 2, 2, gf_f) < 2) return Failed;
   a[0] = 0;
   a[1] = len;
   a[2] = a[3] = 3938; /* presumably, hardwire to assume 100dpi */
   a[4] = 256; /* colors used */
   a[5] = 0; /* colors important */
   if (fwrite(a, 4, 6, gf_f) < 6) return Failed;

   for (i=0; i<256; i++) {
      unsigned char c[4];
      c[0] = paltbl[i].clr.red >> 8;
      c[1] = paltbl[i].clr.green >> 8;
      c[2] = paltbl[i].clr.blue >> 8;
      c[3] = 0;
      if (fwrite(c, 4, 1, gf_f) < 1) return Failed;
      }
   if (bmp_data(width, height, 1, (char *)gf_string, 0) == NULL) return RunError;
   if (fwrite(gf_string, width, height, gf_f) < height) return Failed;
   return Succeeded;
}


/*
 * writeGIF(w, filename, x, y, width, height) - write GIF image
 *
 * Returns Succeeded, Failed, or RunError.
 * We assume that the area specified is within the window.
 */
int writeGIF(w, filename, x, y, width, height)
wbp w;
char *filename;
int x, y, width, height;
   {
   int r;

   r = gfwrite(w, filename, x, y, width, height);
   if (gf_f) { fclose(gf_f); gf_f = NULL; }
   if (gf_string) { free((pointer)gf_string); gf_string = NULL; }
   return r;
   }

#ifdef ConsoleWindow
#undef fprintf
#undef putc
#define putc fputc
#endif					/* ConsoleWindow */
/*
 * gfwrite(w, filename, x, y, width, height) - write GIF file
 *
 * We write GIF87a format (not 89a) for maximum acceptability and because
 * we don't need any of the extensions of GIF89.
 */

static int gfwrite(w, filename, x, y, width, height)
wbp w;
char *filename;
int x, y, width, height;
   {
   int i, c, cur;
   long len;
   LinearColor *cp;
   unsigned char *p, *q;
   struct palentry paltbl[DMAXCOLORS];
   unsigned char obuf[GifBlockSize];
   lzwnode tree[GifTableSize + 1];

   len = (long)width * (long)height;	/* total length of data */

   if (!(gf_f = fopen(filename, "wb")))
      return Failed;
   if (!(gf_string = (unsigned char*)malloc((msize)len)))
      return RunError;

   for (i = 0; i < DMAXCOLORS; i++)
      paltbl[i].used = paltbl[i].valid = paltbl[i].transpt = 0;
#ifdef GraphicsGL
   if (w->window->is_gl) {
      if (!gl_getimstr(w, x, y, width, height, paltbl, gf_string))
         return RunError;
      }
   else
#endif					/* GraphicsGL */
   if (!getimstr(w, x, y, width, height, paltbl, gf_string))
      return RunError;

   gfpack(gf_string, len, paltbl);	/* pack color table, set color params */

   gf_clear = 1 << gf_cdsize;		/* set encoding variables */
   gf_eoi = gf_clear + 1;
   gf_free = gf_eoi + 1;
   gf_lzwbits = gf_cdsize + 1;

   /*
    * Write the header, global color table, and image descriptor.
    */

   fprintf(gf_f, "GIF87a%c%c%c%c%c%c%c", width, width >> 8, height, height >> 8,
      0x80 | ((gf_nbits - 1) << 4) | (gf_nbits - 1), 0, 0);


   for (i = 0; i < (1 << gf_nbits); i++) {	/* output color table */
      if (i < DMAXCOLORS && paltbl[i].valid) {
         cp = &paltbl[i].clr;
         putc(cp->red >> 8, gf_f);
         putc(cp->green >> 8, gf_f);
         putc(cp->blue >> 8, gf_f);
         }
      else {
         putc(0, gf_f);
         putc(0, gf_f);
         putc(0, gf_f);
         }
      }

   fprintf(gf_f, "%c%c%c%c%c%c%c%c%c%c%c", GifSeparator, 0, 0, 0, 0,
      width, width >> 8, height, height >> 8, gf_nbits - 1, gf_cdsize);

   /*
    * Encode and write the image.
    */
   gf_obuf = obuf;			/* initialize output state */
   gf_curr = 0;
   gf_valid = 0;
   gf_rem = GifBlockSize;

   gfmktree(tree);			/* initialize encoding tree */

   gfout(gf_clear);			/* start with CLEAR code */

   p = gf_string;
   q = p + len;
   cur = *p++;				/* first pixel is special */
   while (p < q) {
      c = *p++;				/* get code */
      for (i = tree[cur].child; i != 0; i = tree[i].sibling)
         if (tree[i].tcode == c)	/* find as suffix of previous string */
            break;
      if (i != 0) {			/* if found in encoding tree */
         cur = i;			/* note where */
         continue;			/* and accumulate more */
         }
      gfout(cur);			/* new combination -- output prefix */
      tree[gf_free].tcode = c;		/* make node for new combination */
      tree[gf_free].child = 0;
      tree[gf_free].sibling = tree[cur].child;
      tree[cur].child = gf_free;
      cur = c;				/* restart string from single pixel */
      ++gf_free;			/* grow tree to account for new node */
      if (gf_free > (1 << gf_lzwbits)) {
         if (gf_free > GifTableSize) {
            gfout(gf_clear);		/* table is full; reset to empty */
            gf_lzwbits = gf_cdsize + 1;
            gfmktree(tree);
            }
         else
            gf_lzwbits++;		/* time to make output one bit wider */
         }
      }

   /*
    * Finish up.
    */
   gfout(cur);				/* flush accumulated prefix */
   gfout(gf_eoi);			/* send EOI code */
   gf_lzwbits = 7;
   gfout(0);				/* force out last partial byte */
   gfdump();				/* dump final block */
   putc(0, gf_f);			/* terminate image (block of size 0) */
   putc(GifTerminator, gf_f);		/* terminate file */

   fflush(gf_f);
   if (ferror(gf_f))
      return Failed;
   else
      return Succeeded;			/* caller will close file */
   }

/*
 * gfpack() - pack palette table to eliminate gaps
 *
 * Sets gf_nbits and gf_cdsize based on the number of colors.
 */
static void gfpack(data, len, paltbl)
unsigned char *data;
long len;
struct palentry *paltbl;
   {
   int i, ncolors, lastcolor;
   unsigned char *p, *q, cmap[DMAXCOLORS];

   ncolors = 0;
   lastcolor = 0;
   for (i = 0; i < DMAXCOLORS; i++)
      if (paltbl[i].used) {
         lastcolor = i;
         cmap[i] = ncolors;		/* mapping to output color */
         if (i != ncolors) {
            paltbl[ncolors] = paltbl[i];		/* shift down */
            paltbl[i].used = paltbl[i].valid = paltbl[i].transpt = 0;
							/* invalidate old */
            }
         ncolors++;
         }

   if (ncolors < lastcolor + 1) {      /* if entries were moved to fill gaps */
      p = data;
      q = p + len;
      while (p < q) {
         *p = cmap[*p];		       /* adjust color values in data string */
         p++;
         }
      }

   gf_nbits = 1;
   while ((1 << gf_nbits) < ncolors)
      gf_nbits++;
   if (gf_nbits < 2)
      gf_cdsize = 2;
   else
      gf_cdsize = gf_nbits;
   }

/*
 * gfmktree() - initialize or reinitialize encoding tree
 */

static void gfmktree(tree)
lzwnode *tree;
   {
   int i;

   for (i = 0; i < gf_clear; i++) {	/* for each basic entry */
      tree[i].tcode = i;			/* code is pixel value */
      tree[i].child = 0;		/* no suffixes yet */
      tree[i].sibling = i + 1;		/* next code is sibling */
      }
   tree[gf_clear - 1].sibling = 0;	/* last entry has no sibling */
   gf_free = gf_eoi + 1;		/* reset next free entry */
   }

/*
 * gfout(code) - output one LZW token
 */
static void gfout(tcode)
int tcode;
   {
   gf_curr |= tcode << gf_valid;		/* add to current word */
   gf_valid += gf_lzwbits;		/* count the bits */
   while (gf_valid >= 8) {		/* while we have a byte to output */
      gf_obuf[GifBlockSize - gf_rem] = gf_curr;	/* put in buffer */
      gf_curr >>= 8;				/* remove from word */
      gf_valid -= 8;
      if (--gf_rem == 0)			/* flush buffer when full */
         gfdump();
      }
   }

/*
 * gfdump() - dump output buffer
 */
static void gfdump()
   {
   int n;

   n = GifBlockSize - gf_rem;
   putc(n, gf_f);			/* write block size */
   fwrite((pointer)gf_obuf, 1, n, gf_f); /*write block */
   gf_rem = GifBlockSize;		/* reset buffer to empty */
   }


#if HAVE_LIBJPEG

#ifdef ConsoleWindow
#undef fprintf
#undef putc
#define putc fputc
#endif					/* ConsoleWindow */

/*
 * jpegwrite(w, filename, x, y, width, height) - write JPEG file
 */

static int jpegwrite(wbp w, char *filename, int x, int y, int width,int height)
{
   FILE * jpg_f = NULL;
   unsigned char *imgBuf = NULL;

   struct jpeg_compress_struct cinfo;
   struct my_error_mgr jerr;

   JSAMPROW row_pointer[1];	/* pointer to JSAMPLE row[s] */
   int row_stride;		/* physical row width in image buffer */
   int quality;

   quality = 95;

   cinfo.err = jpeg_std_error(&jerr.pub);
   jerr.pub.error_exit = my_error_exit;

   if (setjmp(jerr.setjmp_buffer)) {
      if (imgBuf)
         free(imgBuf);
      if (jpg_f)
         fclose(jpg_f);
      return Failed;
      }

   jpeg_create_compress(&cinfo);

   if ((jpg_f = fopen(filename,"wb")) == NULL) {
      jpeg_destroy_compress(&cinfo);
      return Failed;
      }

   jpeg_stdio_dest(&cinfo, jpg_f);

   cinfo.image_width = width; 	/* image width and height, in pixels */
   cinfo.image_height = height;

   cinfo.input_components = 3;	/* # of color components per pixel */
   cinfo.in_color_space = JCS_RGB; /* colorspace of input image */

   jpeg_set_defaults(&cinfo);
   jpeg_set_quality(&cinfo, quality, TRUE /*limit to baseline-JPEG values */);

   jpeg_start_compress(&cinfo, TRUE);

   row_stride = cinfo.image_width *3;	/* JSAMPLEs per row in image_buffer */

   if (!(imgBuf = (unsigned char*)malloc( height * row_stride * sizeof(unsigned char))))
      return RunError;

#ifdef GraphicsGL
   if (w->window->is_gl) {
      if (!gl_getimstr24(w, x, y, width, height, imgBuf)) {
         free(imgBuf);
         return RunError;
         }
      }
   else
#endif					/* GraphicsGL */
   if (!getimstr24(w, x, y, width, height, imgBuf)) {
      free(imgBuf);
      return RunError;
      }

   while (cinfo.next_scanline < cinfo.image_height) {
      row_pointer[0] = &imgBuf[cinfo.next_scanline*row_stride];
      (void) jpeg_write_scanlines(&cinfo, row_pointer, 1);
      }

   jpeg_finish_compress(&cinfo);
   jpeg_destroy_compress(&cinfo);
   free(imgBuf);
   fclose(jpg_f);
   return Succeeded;
 }

/*
 * writeJPEG(w, filename, x, y, width, height) - write JPEG image
 * Returns Succeeded, Failed, or RunError.
 * We assume that the area specified is within the window.
 */
int writeJPEG(wbp w, char *filename, int x, int y, int width, int height)
   {
   int r;

   r = jpegwrite(w, filename, x, y, width, height);
   return r;
   }

#endif					/* HAVE_LIBJPEG */

#define IMAGE_UNKNOWN	0
#define IMAGE_GIF	1
#define IMAGE_JPEG	2
#define IMAGE_PNG	3
#define IMAGE_BMP	4

int image_type(fname)
char *fname;
{
  int n = strlen(fname);
  int i = n-3;
  if (n < 5)
     return IMAGE_UNKNOWN;

  if (fname[i] == 'j' || fname[i] == 'J')
     if ( (fname[++i] == 'p' || fname[i] == 'P') && 
     	  (fname[++i] == 'g' || fname[i] == 'G'))
	  return IMAGE_JPEG;

  if (fname[i] == 'p' || fname[i] == 'P')
     if ( (fname[++i] == 'n' || fname[i] == 'N') && 
     	  (fname[++i] == 'g' || fname[i] == 'G'))
	  return IMAGE_PNG;

  if (fname[i] == 'g' || fname[i] == 'G')
     if ( (fname[++i] == 'i' || fname[i] == 'I') && 
     	  (fname[++i] == 'f' || fname[i] == 'F'))
	  return IMAGE_GIF;

  if (fname[i] == 'b' || fname[i] == 'B')
     if ( (fname[++i] == 'm' || fname[i] == 'M') && 
     	  (fname[++i] == 'p' || fname[i] == 'P'))
	  return IMAGE_BMP;

  return IMAGE_UNKNOWN;
}
 
/*
 * readImage(filename, p, imd) - read an image file into image data structure
 * p is a palette number to which the image colors are to be coerced;
 * p=0 uses the colors exactly as given in the image file.
 */

int readImage(char *filename, int p, struct imgdata *imd){
   int itype, r = Failed;
   itype = image_type(filename);

   switch (itype){
     case IMAGE_JPEG: 
#if HAVE_LIBJPEG
        r = readJPEG(filename, p, imd);
#endif					/* HAVE_LIBJPEG */
	break;
     case IMAGE_PNG: 
#if HAVE_LIBPNG
        r = readPNG(filename, p, imd);
#endif					/* HAVE_LIBPNG */
	break;
     case IMAGE_GIF: 
        r = readGIF(filename, p, imd);
	break;
     case IMAGE_BMP: 
        r = readBMP(filename, p, imd);
	break;
     }

  if (r == Succeeded)
     return Succeeded; 				/* return success */

 /*
  * We couldn't read the file based on its extension
  * try brute-force...
  */
#if HAVE_LIBJPEG
   if (itype != IMAGE_JPEG && readJPEG(filename, p, imd) == Succeeded)
     return Succeeded;
#endif					/* HAVE_LIBPNG */

#if HAVE_LIBPNG
   if (itype != IMAGE_PNG && readPNG(filename, p, imd) == Succeeded)
     return Succeeded;
#endif					/* HAVE_LIBPNG */

   if (itype != IMAGE_GIF && readGIF(filename, p, imd) == Succeeded)
     return Succeeded;

   if (itype != IMAGE_BMP && readBMP(filename, p, imd) == Succeeded)
     return Succeeded;

   return Failed;
}

int  writeImage	(wbp w, char *filename, int x, int y, int width, int height){
   int itype;
   itype = image_type(filename);

   switch (itype){
     case IMAGE_JPEG: 
#if HAVE_LIBJPEG
#endif					/* HAVE_LIBJPEG */
	break;
     case IMAGE_PNG: 
#if HAVE_LIBPNG
#endif					/* HAVE_LIBPNG */
	break;
     case IMAGE_GIF: 

	break;
     case IMAGE_BMP: 

	break;
     }
  return Failed;
}

#ifdef ConsoleWindow
#undef fprintf
#define fprintf Consolefprintf
#undef putc
#define putc Consoleputc
#endif					/* ConsoleWindow */

/*
 * Static data for XDrawImage and XPalette functions
 */

/*
 * c<n>list - the characters of the palettes that are not contiguous ASCII
 */
char c1list[] = "0123456789?!nNAa#@oOBb$%pPCc&|\
qQDd,.rREe;:sSFf+-tTGg*/uUHh`'vVIi<>wWJj()xXKk[]yYLl{}zZMm^=";
char c2list[] = "kbgcrmywx";
char c3list[] = "@ABCDEFGHIJKLMNOPQRSTUVWXYZabcd";
char c4list[] =
   "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz{}$%&*+-/?@";

/*
 * cgrays -- lists of grayscales contained within color palettes
 */
static char *cgrays[] = { "0123456", "kxw", "@abMcdZ", "0$%&L*+-g/?@}",
"\0}~\177\200\37\201\202\203\204>\205\206\207\210]\211\212\213\214|",
"\0\330\331\332\333\334+\335\336\337\340\341V\342\343\344\345\346\201\
\347\350\351\352\353\254\354\355\356\357\360\327" };

/*
 * c1cube - a precomputed mapping from a color cube to chars in c1 palette
 *
 * This is 10x10x10 cube (A Thousand Points of Light).
 */
#define C1Side 10  			/* length of one side of C1 cube */
static char c1cube[] = {
   '0', '0', 'w', 'w', 'w', 'W', 'W', 'W', 'J', 'J', '0', '0', 'v', 'v', 'v',
   'W', 'W', 'W', 'J', 'J', 's', 't', 't', 'v', 'v', 'V', 'V', 'V', 'V', 'J',
   's', 't', 't', 'u', 'u', 'V', 'V', 'V', 'V', 'I', 's', 't', 't', 'u', 'u',
   'V', 'V', 'V', 'I', 'I', 'S', 'S', 'T', 'T', 'T', 'U', 'U', 'U', 'I', 'I',
   'S', 'S', 'T', 'T', 'T', 'U', 'U', 'U', 'U', 'I', 'S', 'S', 'T', 'T', 'T',
   'U', 'U', 'U', 'U', 'H', 'F', 'F', 'T', 'T', 'G', 'G', 'U', 'U', 'H', 'H',
   'F', 'F', 'F', 'G', 'G', 'G', 'G', 'H', 'H', 'H', '0', '0', 'x', 'x', 'x',
   'W', 'W', 'W', 'J', 'J', '!', '1', '1', 'v', 'v', 'W', 'W', 'W', 'J', 'J',
   'r', '1', '1', 'v', 'v', 'V', 'V', 'V', 'j', 'j', 'r', 'r', 't', 'u', 'u',
   'V', 'V', 'V', 'j', 'j', 'r', 'r', 't', 'u', 'u', 'V', 'V', 'V', 'I', 'I',
   'S', 'S', 'T', 'T', 'T', 'U', 'U', 'U', 'I', 'I', 'S', 'S', 'T', 'T', 'T',
   'U', 'U', 'U', 'i', 'i', 'S', 'S', 'T', 'T', 'T', 'U', 'U', 'U', 'i', 'i',
   'F', 'F', 'f', 'f', 'G', 'G', 'g', 'g', 'H', 'H', 'F', 'F', 'f', 'f', 'G',
   'G', 'g', 'g', 'H', 'H', 'n', 'z', 'x', 'x', 'x', 'X', 'X', 'X', 'X', 'J',
   '!', '1', '1', 'x', 'x', 'X', 'X', 'X', 'j', 'j', 'p', '1', '1', '2', '2',
   ')', 'V', 'j', 'j', 'j', 'r', 'r', '2', '2', '2', ')', 'V', 'j', 'j', 'j',
   'r', 'r', '2', '2', '2', '>', '>', '>', 'j', 'j', 'R', 'R', '-', '-', '/',
   '/', '>', '>', 'i', 'i', 'R', 'R', 'R', 'T', '/', '/', '\'','i', 'i', 'i',
   'R', 'R', 'f', 'f', '/', '/', 'g', 'g', 'i', 'i', 'R', 'f', 'f', 'f', 'f',
   'g', 'g', 'g', 'h', 'h', 'F', 'f', 'f', 'f', 'f', 'g', 'g', 'g', 'h', 'h',
   'n', 'z', 'z', 'y', 'y', 'X', 'X', 'X', 'X', 'K', 'o', 'o', 'z', 'y', 'y',
   'X', 'X', 'X', 'j', 'j', 'p', 'p', '2', '2', '2', ')', 'X', 'j', 'j', 'j',
   'q', 'q', '2', '2', '2', ')', ')', 'j', 'j', 'j', 'q', 'q', '2', '2', '2',
   '>', '>', '>', 'j', 'j', 'R', 'R', '-', '-', '/', '/', '>', '>', 'i', 'i',
   'R', 'R', 'R', '-', '/', '/', '\'','\'','i', 'i', 'R', 'R', 'f', 'f', '/',
   '/', '\'','g', 'i', 'i', 'R', 'f', 'f', 'f', 'f', 'g', 'g', 'g', 'h', 'h',
   'E', 'f', 'f', 'f', 'f', 'g', 'g', 'g', 'h', 'h', 'n', 'z', 'z', 'y', 'y',
   'X', 'X', 'X', 'K', 'K', 'o', 'o', 'z', 'y', 'y', 'X', 'X', 'X', 'K', 'K',
   '?', '?', '?', '2', '2', ']', ']', ']', 'j', 'j', 'q', 'q', '2', '2', '2',
   ']', ']', ']', 'j', 'j', 'q', 'q', '2', '2', '3', '3', '>', '>', 'j', 'j',
   'R', 'R', ':', ':', '3', '3', '>', '>', 'i', 'i', 'R', 'R', ':', ':', ':',
   '/', '\'','\'','i', 'i', 'R', 'R', ':', ':', ':', '/', '\'','\'','i', 'i',
   'E', 'E', 'f', 'f', 'f', 'g', 'g', 'g', 'h', 'h', 'E', 'E', 'f', 'f', 'f',
   'g', 'g', 'g', 'h', 'h', 'N', 'N', 'Z', 'Z', 'Z', 'Y', 'Y', 'Y', 'K', 'K',
   'O', 'O', 'Z', 'Z', 'Z', 'Y', 'Y', 'Y', 'K', 'K', '?', '?', '?', '@', '=',
   ']', ']', ']', 'k', 'k', 'P', 'P', '@', '@', '=', ']', ']', ']', 'k', 'k',
   'P', 'P', '%', '%', '%', '3', ']', ']', 'k', 'k', 'Q', 'Q', '|', '|', '3',
   '3', '4', '4', '(', '(', 'Q', 'Q', ':', ':', ':', '4', '4', '4', '(', '(',
   'Q', 'Q', ':', ':', ':', '4', '4', '4', '<', '<', 'E', 'E', 'e', 'e', 'e',
   '+', '+', '*', '*', '<', 'E', 'E', 'e', 'e', 'e', '+', '+', '*', '*', '`',
   'N', 'N', 'Z', 'Z', 'Z', 'Y', 'Y', 'Y', 'Y', 'K', 'O', 'O', 'Z', 'Z', 'Z',
   'Y', 'Y', 'Y', 'k', 'k', 'O', 'O', 'O', 'Z', '=', '=', '}', 'k', 'k', 'k',
   'P', 'P', 'P', '@', '=', '=', '}', '}', 'k', 'k', 'P', 'P', '%', '%', '%',
   '=', '}', '}', 'k', 'k', 'Q', 'Q', '|', '|', '|', '4', '4', '4', '(', '(',
   'Q', 'Q', '.', '.', '.', '4', '4', '4', '(', '(', 'Q', 'Q', 'e', '.', '.',
   '4', '4', '4', '<', '<', 'Q', 'e', 'e', 'e', 'e', '+', '+', '*', '*', '<',
   'E', 'e', 'e', 'e', 'e', '+', '+', '*', '*', '`', 'N', 'N', 'Z', 'Z', 'Z',
   'Y', 'Y', 'Y', 'Y', 'L', 'O', 'O', 'Z', 'Z', 'Z', 'Y', 'Y', 'Y', 'k', 'k',
   'O', 'O', 'O', 'a', '=', '=', 'm', 'k', 'k', 'k', 'P', 'P', 'a', 'a', '=',
   '=', '}', 'k', 'k', 'k', 'P', 'P', '%', '%', '%', '=', '}', '8', '8', '8',
   'Q', 'Q', '|', '|', '|', '4', '4', '8', '8', '8', 'Q', 'Q', 'c', '.', '.',
   '4', '4', '4', '[', '[', 'Q', 'Q', 'c', 'c', '9', '9', '4', '5', '5', '<',
   'Q', 'e', 'e', 'e', 'e', ';', ';', '5', '5', '<', 'D', 'e', 'e', 'e', 'e',
   ';', ';', ';', '*', '`', 'A', 'A', 'Z', 'Z', 'M', 'M', 'Y', 'Y', 'L', 'L',
   'A', 'A', 'a', 'a', 'M', 'M', 'm', 'm', 'L', 'L', 'B', 'B', 'a', 'a', 'a',
   'm', 'm', 'm', 'l', 'l', 'B', 'B', 'a', 'a', 'a', 'm', 'm', 'm', 'l', 'l',
   'C', 'C', 'b', 'b', 'b', '7', '7', '7', '8', '8', 'C', 'C', 'b', 'b', 'b',
   '7', '7', '^', '[', '[', 'Q', 'c', 'c', 'c', 'c', '#', '#', '^', '[', '[',
   'Q', 'c', 'c', 'c', '9', '9', '$', '5', '5', '[', 'D', 'D', 'd', 'd', '9',
   '&', '&', '5', '5', '6', 'D', 'D', 'd', 'd', 'd', ';', ';', ';', '6', '6',
   'A', 'A', 'A', 'M', 'M', 'M', 'M', 'L', 'L', 'L', 'A', 'A', 'a', 'a', 'M',
   'M', 'm', 'm', 'L', 'L', 'B', 'B', 'a', 'a', 'a', 'm', 'm', 'm', 'l', 'l',
   'B', 'B', 'a', 'a', 'a', 'm', 'm', 'm', 'l', 'l', 'C', 'C', 'b', 'b', 'b',
   '7', '7', '7', 'l', 'l', 'C', 'C', 'b', 'b', 'b', '7', '7', '^', '^', '{',
   'C', 'c', 'c', 'c', 'c', '#', '#', '^', '^', '{', 'D', 'c', 'c', 'c', '9',
   '9', '$', '$', '^', '{', 'D', 'D', 'd', 'd', '9', '&', '&', '&', '6', '6',
   'D', 'D', 'd', 'd', 'd', ',', ',', ',', '6', '6'
};

/*
 * c1rgb - RGB values for c1 palette entries
 *
 * Entry order corresponds to c1list (above).
 * Each entry gives r,g,b in linear range 0 to 48.
 */
static unsigned char c1rgb[] = {
   0, 0, 0,		/*  0             black		*/
   8, 8, 8,		/*  1   very dark gray		*/
   16, 16, 16,		/*  2        dark gray		*/
   24, 24, 24,		/*  3             gray		*/
   32, 32, 32,		/*  4       light gray		*/
   40, 40, 40,		/*  5  very light gray		*/
   48, 48, 48,		/*  6             white		*/
   48, 24, 30,		/*  7             pink		*/
   36, 24, 48,		/*  8             violet	*/
   48, 36, 24,		/*  9  very light brown		*/
   24, 12, 0,		/*  ?             brown		*/
   8, 4, 0,		/*  !   very dark brown		*/
   16, 0, 0,		/*  n   very dark red		*/
   32, 0, 0,		/*  N        dark red		*/
   48, 0, 0,		/*  A             red		*/
   48, 16, 16,		/*  a       light red		*/
   48, 32, 32,		/*  #  very light red		*/
   30, 18, 18,		/*  @        weak red		*/
   16, 4, 0,		/*  o   very dark orange	*/
   32, 8, 0,		/*  O        dark orange	*/
   48, 12, 0,		/*  B             orange	*/
   48, 24, 16,		/*  b       light orange	*/
   48, 36, 32,		/*  $  very light orange	*/
   30, 21, 18,		/*  %        weak orange	*/
   16, 8, 0,		/*  p   very dark red-yellow	*/
   32, 16, 0,		/*  P        dark red-yellow	*/
   48, 24, 0,		/*  C             red-yellow	*/
   48, 32, 16,		/*  c       light red-yellow	*/
   48, 40, 32,		/*  &  very light red-yellow	*/
   30, 24, 18,		/*  |        weak red-yellow	*/
   16, 16, 0,		/*  q   very dark yellow	*/
   32, 32, 0,		/*  Q        dark yellow	*/
   48, 48, 0,		/*  D             yellow	*/
   48, 48, 16,		/*  d       light yellow	*/
   48, 48, 32,		/*  ,  very light yellow	*/
   30, 30, 18,		/*  .        weak yellow	*/
   8, 16, 0,		/*  r   very dark yellow-green	*/
   16, 32, 0,		/*  R        dark yellow-green	*/
   24, 48, 0,		/*  E             yellow-green	*/
   32, 48, 16,		/*  e       light yellow-green	*/
   40, 48, 32,		/*  ;  very light yellow-green	*/
   24, 30, 18,		/*  :        weak yellow-green	*/
   0, 16, 0,		/*  s   very dark green		*/
   0, 32, 0,		/*  S        dark green		*/
   0, 48, 0,		/*  F             green		*/
   16, 48, 16,		/*  f       light green		*/
   32, 48, 32,		/*  +  very light green		*/
   18, 30, 18,		/*  -        weak green		*/
   0, 16, 8,		/*  t   very dark cyan-green	*/
   0, 32, 16,		/*  T        dark cyan-green	*/
   0, 48, 24,		/*  G             cyan-green	*/
   16, 48, 32,		/*  g       light cyan-green	*/
   32, 48, 40,		/*  *  very light cyan-green	*/
   18, 30, 24,		/*  /        weak cyan-green	*/
   0, 16, 16,		/*  u   very dark cyan		*/
   0, 32, 32,		/*  U        dark cyan		*/
   0, 48, 48,		/*  H             cyan		*/
   16, 48, 48,		/*  h       light cyan		*/
   32, 48, 48,		/*  `  very light cyan		*/
   18, 30, 30,		/*  '        weak cyan		*/
   0, 8, 16,		/*  v   very dark blue-cyan	*/
   0, 16, 32,		/*  V        dark blue-cyan	*/
   0, 24, 48,		/*  I             blue-cyan	*/
   16, 32, 48,		/*  i       light blue-cyan	*/
   32, 40, 48,		/*  <  very light blue-cyan	*/
   18, 24, 30,		/*  >        weak blue-cyan	*/
   0, 0, 16,		/*  w   very dark blue		*/
   0, 0, 32,		/*  W        dark blue		*/
   0, 0, 48,		/*  J             blue		*/
   16, 16, 48,		/*  j       light blue		*/
   32, 32, 48,		/*  (  very light blue		*/
   18, 18, 30,		/*  )        weak blue		*/
   8, 0, 16,		/*  x   very dark purple	*/
   16, 0, 32,		/*  X        dark purple	*/
   24, 0, 48,		/*  K             purple	*/
   32, 16, 48,		/*  k       light purple	*/
   40, 32, 48,		/*  [  very light purple	*/
   24, 18, 30,		/*  ]        weak purple	*/
   16, 0, 16,		/*  y   very dark magenta	*/
   32, 0, 32,		/*  Y        dark magenta	*/
   48, 0, 48,		/*  L             magenta	*/
   48, 16, 48,		/*  l       light magenta	*/
   48, 32, 48,		/*  {  very light magenta	*/
   30, 18, 30,		/*  }        weak magenta	*/
   16, 0, 8,		/*  z   very dark magenta-red	*/
   32, 0, 16,		/*  Z        dark magenta-red	*/
   48, 0, 24,		/*  M             magenta-red	*/
   48, 16, 32,		/*  m       light magenta-red	*/
   48, 32, 40,		/*  ^  very light magenta-red	*/
   30, 18, 24,		/*  =        weak magenta-red	*/
   };

/*
 * palnum(d) - return palette number, or 0 if unrecognized.
 *
 *    returns +1 ... +6 for "c1" through "c6"
 *    returns +1 for &null
 *    returns -2 ... -256 for "g2" through "g256"
 *    returns 0 for unrecognized palette name
 *    returns -1 for non-string argument
 */
int palnum(d)
dptr d;
   {
   tended char *s;
   char c, x;
   int n;

   if (is:null(*d))
      return 1;
   if (!cnv:C_string(*d, s))
      return -1;
   if (sscanf(s, "%c%d%c", &c, &n, &x) != 2)
      return 0;
   if (c == 'c' && n >= 1 && n <= 6)
      return n;
   if (c == 'g' && n >= 2 && n <= 256)
      return -n;
   return 0;
   }


struct palentry *palsetup_palette;	/* current palette */

/*
 * palsetup(p) - set up palette for specified palette.
 */
struct palentry *palsetup(p)
int p;
   {
   int r, g, b, i, n, c;
   unsigned int rr, gg, bb;
   unsigned char *s = NULL, *t;
   double m;
   struct palentry *e;

   static int palnumber;		/* current palette number */

   if (palnumber == p)
      return palsetup_palette;
   if (palsetup_palette == NULL) {
      palsetup_palette =
	 (struct palentry *)malloc(256 * sizeof(struct palentry));
      if (palsetup_palette == NULL)
         return NULL;
      }
   palnumber = p;

   for (i = 0; i < 256; i++)
      palsetup_palette[i].valid = palsetup_palette[i].transpt = 0;
   palsetup_palette[TCH1].transpt = 1;
   palsetup_palette[TCH2].transpt = 1;

   if (p < 0) {				/* grayscale palette */
      n = -p;
      if (n <= 64)
         s = (unsigned char *)c4list;
      else
         s = allchars;
      m = 1.0 / (n - 1);

      for (i = 0; i < n; i++) {
         e = &palsetup_palette[*s++];
         gg = 65535 * m * i;
         e->clr.red = e->clr.green = e->clr.blue = gg;
         e->valid = 1;
	 e->transpt = 0;
         }
      return palsetup_palette;
      }

   if (p == 1) {			/* special c1 palette */
      s = (unsigned char *)c1list;
      t = c1rgb;
      while ((c = *s++) != 0) {
         e = &palsetup_palette[c];
         e->clr.red   = 65535 * (((int)*t++) / 48.0);
         e->clr.green = 65535 * (((int)*t++) / 48.0);
         e->clr.blue  = 65535 * (((int)*t++) / 48.0);
         e->valid = 1;
	 e->transpt = 0;
         }
      return palsetup_palette;
      }

   switch (p) {				/* color cube plus extra grays */
      case  2:  s = (unsigned char *)c2list;	break;	/* c2 */
      case  3:  s = (unsigned char *)c3list;	break;	/* c3 */
      case  4:  s = (unsigned char *)c4list;	break;	/* c4 */
      case  5:  s = allchars;			break;	/* c5 */
      case  6:  s = allchars; 			break;	/* c6 */
      }
   m = 1.0 / (p - 1);
   for (r = 0; r < p; r++) {
      rr = 65535 * m * r;
      for (g = 0; g < p; g++) {
         gg = 65535 * m * g;
         for (b = 0; b < p; b++) {
            bb = 65535 * m * b;
            e = &palsetup_palette[*s++];
            e->clr.red = rr;
            e->clr.green = gg;
            e->clr.blue = bb;
            e->valid = 1;
	    e->transpt = 0;
            }
         }
      }
   m = 1.0 / (p * (p - 1));
   for (g = 0; g < p * (p - 1); g++)
      if (g % p != 0) {
         gg = 65535 * m * g;
         e = &palsetup_palette[*s++];
         e->clr.red = e->clr.green = e->clr.blue = gg;
         e->valid = 1;
	 e->transpt = 0;
         }
   return palsetup_palette;
   }

/*
 * rgbkey(p,r,g,b) - return pointer to key of closest color in palette number p.
 *
 * In color cubes, finds "extra" grays only if r == g == b.
 */
char *rgbkey(p, r, g, b)
int p;
double r, g, b;
   {
   int n, i;
   double m;
   char *s;

   if (p > 0) { 			/* color */
      if (r == g && g == b) {
         if (p == 1)
            m = 6;
         else
            m = p * (p - 1);
         return cgrays[p - 1] + (int)(0.501 + m * g);
         }
      else {
         if (p == 1)
            n = C1Side;
         else
            n = p;
         m = n - 1;
         i = (int)(0.501 + m * r);
         i = n * i + (int)(0.501 + m * g);
         i = n * i + (int)(0.501 + m * b);
         switch(p) {
            case  1:  return c1cube + i;		/* c1 */
            case  2:  return c2list + i;		/* c2 */
            case  3:  return c3list + i;		/* c3 */
            case  4:  return c4list + i;		/* c4 */
            case  5:  return (char *)allchars + i;	/* c5 */
            case  6:  return (char *)allchars + i;	/* c6 */
            }
         }
      }
   else {				/* grayscale */
      if (p < -64)
         s = (char *)allchars;
      else
         s = c4list;
      return s + (int)(0.5 + (0.299 * r + 0.587 * g + 0.114 * b) * (-p - 1));
      }

   /*NOTREACHED*/
   return 0;  /* avoid gcc warning */
   }

/*
 * mapping from recognized style attributes to flag values
 */
stringint fontwords[] = {
   { 0,			24 },		/* number of entries */
   { "arabic",		FONTATT_CHARSET | FONTFLAG_ARABIC },
   { "bold",		FONTATT_WEIGHT	| FONTFLAG_BOLD },
   { "condensed",	FONTATT_WIDTH	| FONTFLAG_CONDENSED },
   { "cyrillic",	FONTATT_CHARSET | FONTFLAG_CYRILLIC },
   { "demi",		FONTATT_WEIGHT	| FONTFLAG_DEMI },
   { "demibold",	FONTATT_WEIGHT	| FONTFLAG_DEMI | FONTFLAG_BOLD },
   { "extended",	FONTATT_WIDTH	| FONTFLAG_EXTENDED },
   { "greek",		FONTATT_CHARSET | FONTFLAG_GREEK },
   { "hebrew",		FONTATT_CHARSET | FONTFLAG_HEBREW },
   { "italic",		FONTATT_SLANT	| FONTFLAG_ITALIC },
   { "latin1",		FONTATT_CHARSET | FONTFLAG_LATIN1 },
   { "latin2",		FONTATT_CHARSET | FONTFLAG_LATIN2 },
   { "latin6",		FONTATT_CHARSET | FONTFLAG_LATIN6 },
   { "light",		FONTATT_WEIGHT	| FONTFLAG_LIGHT },
   { "medium",		FONTATT_WEIGHT	| FONTFLAG_MEDIUM },
   { "mono",		FONTATT_SPACING	| FONTFLAG_MONO },
   { "narrow",		FONTATT_WIDTH	| FONTFLAG_NARROW },
   { "normal",		FONTATT_WIDTH	| FONTFLAG_NORMAL },
   { "oblique",		FONTATT_SLANT	| FONTFLAG_OBLIQUE },
   { "proportional",	FONTATT_SPACING	| FONTFLAG_PROPORTIONAL },
   { "roman",		FONTATT_SLANT	| FONTFLAG_ROMAN },
   { "sans",		FONTATT_SERIF	| FONTFLAG_SANS },
   { "serif",		FONTATT_SERIF	| FONTFLAG_SERIF },
   { "wide",		FONTATT_WIDTH	| FONTFLAG_WIDE },
};

stringint font_type[] = {
   {0,                  6},
   { "outline",         FONT_OUTLINE },
   { "polygon",         FONT_POLYGON },
   { "texture",         FONT_TEXTURE },
   { "bitmap",          FONT_BITMAP },
   { "pixmap",          FONT_PIXMAP },
   { "extrude",         FONT_EXTRUDE }
};

/*
 * parsefont - extract font family name, style attributes, and size
 *
 * these are window system independent values, so they require
 *  further translation into window system dependent values.
 *
 * returns 1 on an OK font name
 * returns 0 on a "malformed" font (might be a window-system fontname)
 */
int parsefont(s, family, style, size, tp)
char *s;
char family[MAXFONTWORD+1];
int *style;
int *size;
int *tp;
   {
   char c, *a, attr[MAXFONTWORD+1];
   int tmp;

   /*
    * set up the defaults
    */
   *family = '\0';
   *style = 0;
   *size = -1;
   *tp = 5;

   /*
    * now, scan through the raw and break out pieces
    */
   for (;;) {

      /*
       * find start of next comma-separated attribute word
       */
      while (isspace(*s) || *s == ',')	/* trim leading spaces & empty words */
         s++;
      if (*s == '\0')			/* stop at end of string */
         break;

      /*
       * copy word, converting to lower case to implement case insensitivity
       */
      for (a = attr; (c = *s) != '\0' && c != ','; s++) {
         if (isupper(c))
            c = tolower(c);
         *a++ = c;
         if (a - attr >= MAXFONTWORD)
            return 0;			/* too long */
         }

      /*
       * trim trailing spaces and terminate word
       */
      while (isspace(a[-1]))
         a--;
      *a = '\0';

      /*
       * interpret word as family name, size, or style characteristic
       */
      if (*family == '\0')
         strcpy(family, attr);		/* first word is the family name */

      else if (sscanf(attr, "%d%c", &tmp, &c) == 1 && tmp > 0) {
         if (*size != -1 && *size != tmp)
            return 0;			/* if conflicting sizes given */
         *size = tmp;			/* integer value is a size */
         }

      else {				/* otherwise it's a style attribute */
         tmp = si_s2i(fontwords, attr);	/* look up in table */
         if (tmp != -1) {		/* if recognized */
            if ((tmp & *style) != 0 && (tmp & *style) != tmp)
               return 0;		/* conflicting attribute */
            *style |= tmp;
            }
	 else {
	    *tp=0;
	    for (tmp=1; tmp<=font_type[0].i; tmp++) {
	      if (!strcmp(font_type[tmp].s, attr))
		*tp = font_type[tmp].i-1;
	      }
            }
         }
      }

   /* got to end of string; it's OK if it had at least a font family */
   return (*family != '\0');
   }

/*
 * parsepattern() - parse an encoded numeric stipple pattern
 */
int parsepattern(s, len, width, nbits, bits)
char *s;
int len;
int *width, *nbits;
C_integer *bits;
   {
   C_integer v;
   int i, j, hexdigits_per_row, maxbits = *nbits;
   CURTSTATE();

   /*
    * Get the width
    */
   if (sscanf(s, "%d,", width) != 1) return RunError;
   if (*width < 1) return Failed;

   /*
    * skip over width
    */
   while ((len > 0) && isdigit(*s)) {
      len--; s++;
      }
   if ((len <= 1) || (*s != ',')) return RunError;
   len--; s++;					/* skip over ',' */

   if (*s == '#') {
      /*
       * get remaining bits as hex constant
       */
      s++; len--;
      if (len == 0) return RunError;
      hexdigits_per_row = *width / 4;
      if (*width % 4) hexdigits_per_row++;
      *nbits = len / hexdigits_per_row;
      if (len % hexdigits_per_row) (*nbits)++;
      if (*nbits > maxbits) return Failed;
      for (i = 0; i < *nbits; i++) {
         v = 0;
	 for (j = 0; j < hexdigits_per_row; j++, len--, s++) {
	    if (len == 0) break;
	    v <<= 4;
	    if (isdigit(*s)) v += *s - '0';
	    else switch (*s) {
	    case 'a': case 'b': case 'c': case 'd': case 'e': case 'f':
	       v += *s - 'a' + 10; break;
	    case 'A': case 'B': case 'C': case 'D': case 'E': case 'F':
	       v += *s - 'A' + 10; break;
	    default: return RunError;
	       }
	    }
	 *bits++ = v;
	 }
      }
   else {
      if (*width > 32) return Failed;
      /*
       * get remaining bits as comma-separated decimals
       */
      v = 0;
      *nbits = 0;
      while (len > 0) {
	 while ((len > 0) && isdigit(*s)) {
	    v = v * 10 + *s - '0';
	    len--; s++;
	    }
	 (*nbits)++;
	 if (*nbits > maxbits) return Failed;
	 *bits++ = v;
	 v = 0;

	 if (len > 0) {
	    if (*s == ',') { len--; s++; }
	    else {
	       ReturnErrNum(205, RunError);
	       }
	    }
	 }
      }
   return Succeeded;
   }

/*
 * parsegeometry - parse a string of the form: intxint[+-]int[+-]int
 * Returns:
 *  0 on bad value, 1 if size is set, 2 if position is set, 3 if both are set
 */
int parsegeometry(buf, x, y, width, height)
char *buf;
SHORT *x, *y, *width, *height;
   {
   int retval = 0;
   if (isdigit(*buf)) {
      retval++;
      if ((*width = atoi(buf)) <= 0) return 0;
      while (isdigit(*++buf));
      if (*buf++ != 'x') return 0;
      if ((*height = atoi(buf)) <= 0) return 0;
      while (isdigit(*++buf));
      }

   if (*buf == '+' || *buf == '-') {
      retval += 2;
      *x = atoi(buf);
      buf++; /* skip over +/- */
      while (isdigit(*buf)) buf++;

      if (*buf != '+' && *buf != '-') return 0;
      *y = atoi(buf);
      buf++; /* skip over +/- */
      while (isdigit(*buf)) buf++;
      if (*buf) return 0;
      }
   return retval;
   }


/* return failure if operation returns either failure or error */
#define AttemptAttr(operation) do { switch (operation) { case RunError: t_errornumber=145; StrLen(t_errorvalue)=strlen(val);StrLoc(t_errorvalue)=val;return RunError; case Succeeded: break; default: return Failed; } } while(0)

/* does string (already checked for "on" or "off") say "on"? */
#define ATOBOOL(s) (s[1]=='n')

/*
 * Attribute manipulation
 *
 * wattrib() - get/set a single attribute in a window, return the result attr
 *  string.
 */
int wattrib(w, s, len, answer, abuf)
wbp w;
char *s;
long len;
dptr answer;
char * abuf;
   {
   char val[256], *valptr;
   struct descrip d;
   char *mid, *midend, c;
   int r, a;
   C_integer tmp;
   long lenattr, lenval;
   double gamma;
   SHORT new_height, new_width;
   wsp ws = w->window;
   wcp wc = w->context;
   tended struct descrip f;

   valptr = val;
   /*
    * catch up on any events pending - mainly to update pointerx, pointery
    */
   if (pollevent() == -1)
      fatalerr(141,NULL);

   midend = s + len;
   for (mid = s; mid < midend; mid++)
      if (*mid == '=') break;

   if (mid < midend) {
      /*
       * set an attribute
       */
      lenattr = mid - s;
      lenval  = len - lenattr - 1;
      mid++;

      strncpy(abuf, s, lenattr);
      abuf[lenattr] = '\0';

      if (lenval > 255) {
         StrLen(d) = lenval;
         StrLoc(d) = mid;
         }
      else {
         strncpy(val, mid, lenval);
         val[lenval] = '\0';
         StrLen(d) = strlen(val);
         StrLoc(d) = val;
         }

      switch (a = si_s2i(attribs, abuf)) {
      case A_LINES: case A_ROWS: {
	 if (!cnv:C_integer(d, tmp))
	    return Failed;
	 if ((new_height = tmp) < 1)
	    return Failed;
#ifdef GraphicsGL
	 if (ws->is_gl) {
	    new_height = GL_ROWTOY(w, new_height);
	    new_height += GL_MAXDESCENDER(w);
	    }
	 else
#endif					/* GraphicsGL */
	 {
	 new_height = ROWTOY(w, new_height);
	 new_height += MAXDESCENDER(w);
	 }
#ifdef GraphicsGL
	 if (ws->is_gl) {
	    if (gl_setheight(w, new_height) == Failed) return Failed;
	    }
	 else
#endif					/* GraphicsGL */
	 if (setheight(w, new_height) == Failed) return Failed;
	 break;
         }
      case A_COLUMNS: {
	 if (!cnv:C_integer(d, tmp))
	    return Failed;
	 if ((new_width = tmp) < 1)
	    return Failed;
#ifdef GraphicsGL
	 if (ws->is_gl) {
	    new_width = GL_COLTOX(w, new_width + 1);
	    if (gl_setwidth(w, new_width) == Failed) return Failed;
	    }
	 else
#endif					/* GraphicsGL */
	 {
	 new_width = COLTOX(w, new_width + 1);
	 if (setwidth(w, new_width) == Failed) return Failed;
	 }
	 break;
         }
#ifdef Graphics3D
      case A_RENDERMODE:
         if (!strcmp(val,"2d"))
            wc->rendermode = UGL2D;
         else if (!strcmp(val,"3d"))
            wc->rendermode = UGL3D;
         else 
            return Failed;
	 break;
      case A_DIM:
	 AttemptAttr(setdim(w, val));
	 break;
      case A_EYE:
	 AttemptAttr(seteye(w, val));
	 break;
      case A_EYEPOS:
	 AttemptAttr(seteyepos(w, val));
	 break;
      case A_EYEUP:
	 AttemptAttr(seteyeup(w, val));
	 break;
      case A_EYEDIR:
   	 AttemptAttr(seteyedir(w, val));
	 break;
#if HAVE_LIBGL
      case A_LIGHT: case A_LIGHT0:
	 AttemptAttr(setlight(w, val, GL_LIGHT0));
	 break;
      case A_LIGHT1:
	 AttemptAttr(setlight(w, val, GL_LIGHT1));
	 break;
      case A_LIGHT2:
	 AttemptAttr(setlight(w, val, GL_LIGHT2));
	 break;
      case A_LIGHT3:
	 AttemptAttr( setlight(w, val, GL_LIGHT3));
	 break;
      case A_LIGHT4:
	 AttemptAttr(setlight(w, val, GL_LIGHT4));
	 break;
      case A_LIGHT5:
	 AttemptAttr(setlight(w, val, GL_LIGHT5));
	 break;
      case A_LIGHT6:
	 AttemptAttr(setlight(w, val, GL_LIGHT6));
	 break;
      case A_LIGHT7:
	 AttemptAttr(setlight(w, val, GL_LIGHT7));
	 break;
      case A_ALPHA:
         {
         double alpha;

         alpha = atof(val);
         if (alpha == 0.0)
            return Failed;

         alpha = Abs(alpha); 
         if (alpha >= 1.0) 
            alpha = 1.0;

         wc->alpha = alpha;
	 break;
         }
      case A_PROJECTION:
	 if (!strcmp(val,"ortho"))
	    ws->projection = UGL_ORTHOGONAL;
	 else if (!strcmp(val,"perspec"))
	    ws->projection = UGL_PERSPECTIVE;
	 break;
      case A_CAMWIDTH:
	 {
	 double width;

	 width = atof(val);
	 if (width == 0.0) 
	    return Failed;

         ws->camwidth = Abs(width);
	 break;
	 }
#endif					/* HAVE_LIBGL */
      case A_MESHMODE:
	 if (!setmeshmode(w,val)) return Failed;
	 break;
      case A_TEXTURE:{
         /* -1 means no curtexture, 0 means f is not initialized */
	 AttemptAttr( settexture(w, StrLoc(d), StrLen(d), &f, -1, 0));
	 break;
	 }
      case A_TEXCOORD:
	 AttemptAttr(settexcoords(w, val));
	 break;
      case A_TEXMODE:
	 AttemptAttr(settexmode(w, val));
	 break;
      case A_NORMODE:
	 AttemptAttr(setnormode(w, val));
	 break;
      case A_SLICES:
	AttemptAttr(setslices(w, val));
	break;
      case A_RINGS:
	AttemptAttr(setrings(w, val));
	break;
      case A_FOV:
	AttemptAttr(setfov(w, val));
        break;
      case A_PICK:
	 AttemptAttr(setselectionmode(w, val));
	 break;
      case A_BUFFERMODE: {
        if (!strcmp(val,"on")) {
           wc->buffermode=BUFFERED3D;
           ws->buffermode=UGL_BUFFERED;
           }
        else if (!strcmp(val,"off")) { 
           wc->buffermode = IMMEDIATE3D;
           ws->buffermode=UGL_IMMEDIATE;
           }
        else return Failed;
        if (!ws->initAttrs) ApplyBuffermode(w, ws->buffermode);
        break;
	}
#endif					/* Graphics3D */
      case A_RGBMODE:
	 AttemptAttr(setrgbmode(w, val));
	 break;
      case A_HEIGHT: {
	 if (!cnv:C_integer(d, tmp))
	    return Failed;
         if ((new_height = tmp) < 1) return Failed;
#ifdef GraphicsGL
	 if (ws->is_gl) {
	    if (gl_setheight(w, new_height) == Failed) return Failed;
	    }
	 else
#endif					/* GraphicsGL */
	 if (setheight(w, new_height) == Failed) return Failed;
	 break;
         }
      case A_WIDTH: {
	 if (!cnv:C_integer(d, tmp))
	    return Failed;
         if ((new_width = tmp) < 1) return Failed;
#ifdef GraphicsGL
	 if (ws->is_gl) {
	    if (gl_setwidth(w, new_width) == Failed) return Failed;
	    }
	 else
#endif					/* GraphicsGL */
	 if (setwidth(w, new_width) == Failed) return Failed;
	 break;
         }
      case A_SIZE: {
	 AttemptAttr(setsize(w, val));
	 break;
	 }
      case A_GEOMETRY: {
#ifdef GraphicsGL
	 if (ws->is_gl)
	    AttemptAttr(gl_setgeometry(w, val));
	 else
#endif					/* GraphicsGL */
	 AttemptAttr(setgeometry(w, val));
	 break;
         }
      case A_SELECTION: {
	 if (setselection(w, &d) == Succeeded) {
            *answer = d;
#ifdef GraphicsGL
            if (ws->is_gl)
               gl_wflush(w);
            else
#endif					/* GraphicsGL */
            wflush(w);
            return Succeeded;
            }
	 break;
	 }
      case A_INPUTMASK: {
	 AttemptAttr(setinputmask(w, val));
	 break;
	 }
      case A_RESIZE: {
	 if (strcmp(val, "on") & strcmp(val, "off"))
	    return Failed;
#ifdef GraphicsGL
         if (ws->is_gl)
            gl_allowresize(w, ATOBOOL(val));
         else
#endif					/* GraphicsGL */
         allowresize(w, ATOBOOL(val));
	 break;
         }
      case A_TITLEBAR: {
         if (w->window->pix != 0) return Failed;
	 if (strcmp(val, "on") & strcmp(val, "off"))
	    return Failed;
         if (ATOBOOL(val)) {
            SETTITLEBAR(w->window);
            }
         else {
            CLRTITLEBAR(w->window);
            }
	 break;
         }
      case A_ROW: {
	 if (!cnv:C_integer(d, tmp))
	    return Failed;
#ifdef GraphicsGL
	 if (ws->is_gl)
  	    ws->y = GL_ROWTOY(w, tmp) + wc->dy;
  	 else
#endif					/* GraphicsGL */
	 ws->y = ROWTOY(w, tmp) + wc->dy;
	 break;
	 }
      case A_COL: {
	 if (!cnv:C_integer(d, tmp))
	    return Failed;
#ifdef GraphicsGL
	 if (ws->is_gl)
	    ws->x = GL_COLTOX(w, tmp) + wc->dx;
	 else
#endif					/* GraphicsGL */
	 ws->x = COLTOX(w, tmp) + wc->dx;
	 break;
	 }
      case A_CANVAS: {
#ifdef GraphicsGL
	 if (ws->is_gl)
	    AttemptAttr(gl_setcanvas(w,val));
	 else
#endif					/* GraphicsGL */
	 AttemptAttr(setcanvas(w,val));
	 break;
	 }
      case A_ICONIC: {
#ifdef GraphicsGL
	 if (ws->is_gl)
	    AttemptAttr(gl_seticonicstate(w,val));
	 else
#endif					/* GraphicsGL */
	 AttemptAttr(seticonicstate(w,val));
	 break;
	 }
      case A_ICONIMAGE: {
	 if (!val[0]) return Failed;
#ifdef GraphicsGL
	 if (ws->is_gl)
	    AttemptAttr(gl_seticonimage(w, &d));
	 else
#endif					/* GraphicsGL */
	 AttemptAttr(seticonimage(w, &d));
         break;
	 }
      case A_ICONLABEL: {
#ifdef GraphicsGL
	 if (ws->is_gl)
	    AttemptAttr(gl_seticonlabel(w, val));
	 else
#endif					/* GraphicsGL */
	 AttemptAttr(seticonlabel(w, val));
	 break;
	 }
      case A_ICONPOS: {
#ifdef GraphicsGL
	 if (ws->is_gl)
	    AttemptAttr(gl_seticonpos(w,val));
	 else
#endif					/* GraphicsGL */
	 AttemptAttr(seticonpos(w,val));
	 break;
	 }
      case A_LABEL:
      case A_WINDOWLABEL: {
#ifdef GraphicsGL
	 if (ws->is_gl)
	    AttemptAttr(gl_setwindowlabel(w, val));
	 else
#endif					/* GraphicsGL */
	 AttemptAttr(setwindowlabel(w, val));
	 break;
         }
      case A_CURSOR: {
	 int on_off;
	 if (strcmp(val, "on") & strcmp(val, "off"))
	    return Failed;
	 on_off = ATOBOOL(val);
#ifdef GraphicsGL
         if (ws->is_gl)
            gl_setcursor(w, on_off);
         else
#endif					/* GraphicsGL */
         setcursor(w, on_off);
	 break;
         }
      case A_FONT: {
#ifdef GraphicsGL
	 if (ws->is_gl)
	    AttemptAttr(gl_setfont(w, &valptr));
	 else
#endif					/* GraphicsGL */
	 AttemptAttr(setfont(w, &valptr));
	 break;
         }
      case A_PATTERN: {
#ifdef GraphicsGL
	 if (ws->is_gl)
	    AttemptAttr(gl_SetPattern(w, val, strlen(val)));
	 else
#endif					/* GraphicsGL */
	 AttemptAttr(SetPattern(w, val, strlen(val)));
         break;
	 }
      case A_POS: {
	 AttemptAttr(setpos(w, val));
	 break;
	 }
      case A_POSX: {
	 char tmp[268];
	 sprintf(tmp,"%s,%d",val,ws->posy);
	 AttemptAttr(setpos(w, tmp));
	 break;
	 }
      case A_POSY: {
	 char tmp[268];
	 sprintf(tmp,"%d,%s",ws->posx,val);
	 AttemptAttr(setpos(w, tmp));
         break;
	 }
      case A_FG: {
	 if (cnv:C_integer(d, tmp) && tmp < 0) {
#ifdef GraphicsGL
	    if (ws->is_gl) {
	       if (gl_isetfg(w, tmp) != Succeeded) return Failed;
	       }
	    else
#endif					/* GraphicsGL */
	    if (isetfg(w, tmp) != Succeeded) return Failed;
	    }
	 else {
#ifdef Graphics3D

            if (w->context->rendermode == UGL3D) {
	       if (setmaterials(w,val) != Succeeded)
	          return Failed;
               }
            else 
#endif					/* Graphics3D */
#ifdef GraphicsGL
               if (ws->is_gl) { 
 	          if (gl_setfg(w, val) != Succeeded) return Failed;
                  }
	       else
#endif					/* GraphicsGL */
             {
	     if (setfg(w, val) != Succeeded) return Failed;
            }}
	 break;
         }
      case A_BG: {
	 if (cnv:C_integer(d, tmp) && tmp < 0) {
#ifdef GraphicsGL
	    if (ws->is_gl) {
	       if (gl_isetbg(w, tmp) != Succeeded) return Failed;
	       }
	    else
#endif					/* GraphicsGL */
	    if (isetbg(w, tmp) != Succeeded) return Failed;
	    }
	 else {
#ifdef GraphicsGL
            if (ws->is_gl) { 
 	       if (gl_setbg(w, val) != Succeeded) return Failed;
               }
	    else
#endif					/* GraphicsGL */
	    if (setbg(w, val) != Succeeded) return Failed;
	    }
	 break;
         }
      case A_GAMMA: {
         if (sscanf(val, "%lf%c", &gamma, &c) != 1 || gamma <= 0.0)
            return Failed;
#ifdef GraphicsGL
         if (ws->is_gl) {
            if (gl_setgamma(w, gamma) != Succeeded)
               return Failed;
            }
         else
#endif					/* GraphicsGL */
         if (setgamma(w, gamma) != Succeeded)
            return Failed;
         break;
         }
      case A_FILLSTYLE: {
#ifdef GraphicsGL
	 if (ws->is_gl)
	    AttemptAttr(gl_setfillstyle(w, val));
	 else
#endif					/* GraphicsGL */
	 AttemptAttr(setfillstyle(w, val));
	 break;
	 }
      case A_LINESTYLE: {
#ifdef GraphicsGL
	 if (ws->is_gl)
	    AttemptAttr(gl_setlinestyle(w, val));
	 else
#endif					/* GraphicsGL */
	 AttemptAttr(setlinestyle(w, val));
	 break;
	 }
      case A_LINEWIDTH: {
	 if (!cnv:C_integer(d, tmp))
	    return Failed;
#ifdef Graphics3D
 	 if (w->context->rendermode == UGL3D) {
            if (setlinewidth3D(w, tmp) == RunError)
	       return Failed;
	    }
         else
#endif					/* Graphics3D */
#ifdef GraphicsGL
	 if (ws->is_gl) {
	    if (gl_setlinewidth(w, tmp) == RunError)
	       return Failed;
	    }
	 else
#endif					/* GraphicsGL */
	 if (setlinewidth(w, tmp) == RunError)
	    return Failed;
	 break;
	 }
      case A_POINTER: {
#ifdef GraphicsGL
	 if (ws->is_gl)
	    AttemptAttr(gl_setpointer(w, val));
	 else
#endif					/* GraphicsGL */
	 AttemptAttr(setpointer(w, val));
	 break;
         }
      case A_DRAWOP: {
#ifdef GraphicsGL
	 if (ws->is_gl) 
	    AttemptAttr(gl_setdrawop(w, val));
	 else
#endif					/* GraphicsGL */
	 AttemptAttr(setdrawop(w, val));
	 break;
         }
      case A_DISPLAY: {
#ifdef GraphicsGL
	 if (ws->is_gl)
	    AttemptAttr(gl_setdisplay(w,val));
	 else
#endif					/* GraphicsGL */
	 AttemptAttr(setdisplay(w,val));
	 break;
         }
      case A_X: {
	 if (!cnv:C_integer(d, tmp))
	    return Failed;
	 ws->x = tmp + wc->dx;
         UpdateCursorPos(ws, wc);	/* tell system where to blink it */
	 break;
	 }
      case A_Y: {
	 if (!cnv:C_integer(d, tmp))
	    return Failed;
	 ws->y = tmp + wc->dy;
         UpdateCursorPos(ws, wc);	/* tell system where to blink it */
	 break;
	 }
      case A_DX: {
	 if (!cnv:C_integer(d, tmp))
	    return Failed;
	 wc->dx = tmp;
#ifdef GraphicsGL
	 if (ws->is_gl)
            gl_setdx(w);
#endif					/* GraphicsGL */
         UpdateCursorPos(ws, wc);	/* tell system where to blink it */
	 break;
	 }
      case A_DY: {
	 if (!cnv:C_integer(d, tmp))
	    return Failed;
	 wc->dy = tmp;
#ifdef GraphicsGL
	 if (ws->is_gl)
            gl_setdy(w);
#endif					/* GraphicsGL */
         UpdateCursorPos(ws, wc);	/* tell system where to blink it */
	 break;
	 }
      case A_LEADING: {
	 if (!cnv:C_integer(d, tmp))
	    return Failed;
#ifdef GraphicsGL
	 if (ws->is_gl)
	    gl_setleading(w, tmp);
	 else
#endif					/* GraphicsGL */
	 setleading(w, tmp);
         break;
         }
      case A_IMAGE: {
#if NT
         ws->initimage.format = UCOLOR_BGR;
#else
         ws->initimage.format = UCOLOR_RGB;
#endif 
         ws->initimage.is_bottom_up = 0;

         /* first try supported image file formats; then try platform-dependent format */
         r = readImage(val, 0, &ws->initimage);
         if (r == Succeeded) {
#ifdef GraphicsGL
            if (ws->is_gl) {
               gl_setwidth(w, ws->initimage.width);
               gl_setheight(w, ws->initimage.height);
               }
            else
#endif					/* GraphicsGL */
             {
             setwidth(w, ws->initimage.width);
             setheight(w, ws->initimage.height);
            }}
         else {
#ifdef GraphicsGL
            if (ws->is_gl)
               r = gl_setimage(w, val);
            else
#endif					/* GraphicsGL */
            r = setimage(w, val);
            }

	 AttemptAttr(r);
         break;
         }
      case A_ECHO: {
	 if (strcmp(val, "on") & strcmp(val, "off"))
	    return Failed;
	 if (ATOBOOL(val)) SETECHOON(w);
	 else CLRECHOON(w);
	 break;
         }
      case A_CLIPX:
      case A_CLIPY:
      case A_CLIPW:
      case A_CLIPH: {
	 if (!*val) {
	    wc->clipx = wc->clipy = 0;
	    wc->clipw = wc->cliph = -1;
#ifdef GraphicsGL
	    if (ws->is_gl)
	       gl_unsetclip(w);
	    else
#endif					/* GraphicsGL */
	    unsetclip(w);
	    }
	 else {
	    if (!cnv:C_integer(d, tmp))
	       return Failed;
	    if (wc->clipw < 0) {
	       wc->clipx = wc->clipy = 0;
	       wc->clipw = ws->width;
	       wc->cliph = ws->height;
	       }
	    switch (a) {
	       case A_CLIPX:  wc->clipx = tmp;  break;
	       case A_CLIPY:  wc->clipy = tmp;  break;
	       case A_CLIPW:  wc->clipw = tmp;  break;
	       case A_CLIPH:  wc->cliph = tmp;  break;
	       }
#ifdef GraphicsGL
	    if (ws->is_gl)
	       gl_setclip(w);
	    else
#endif					/* GraphicsGL */
	    setclip(w);
	    }
	 break;
	 }
      case A_REVERSE: {
	 if (strcmp(val, "on") && strcmp(val, "off"))
	    return Failed;
	 if ((!ATOBOOL(val) && ISREVERSE(w)) ||
	     (ATOBOOL(val) && !ISREVERSE(w))) {
#ifdef GraphicsGL
            if (ws->is_gl)
	       gl_toggle_fgbg(w);
	    else
#endif					/* GraphicsGL */
	    {
	    toggle_fgbg(w);
	    ISREVERSE(w) ? CLRREVERSE(w) : SETREVERSE(w);
	    }
	    }
	 break;
         }
      case A_POINTERX: {
	 if (!cnv:C_integer(d, tmp))
	    return Failed;
	 ws->pointerx = tmp + wc->dx;
#ifdef GraphicsGL
	 if (ws->is_gl)
	    gl_warpPointer(w, ws->pointerx, ws->pointery);
	 else
#endif					/* GraphicsGL */
	 warpPointer(w, ws->pointerx, ws->pointery);
	 break;
	 }
      case A_POINTERY: {
	 if (!cnv:C_integer(d, tmp))
	    return Failed;
	 ws->pointery = tmp + wc->dy;
#ifdef GraphicsGL
	 if (ws->is_gl)
	    gl_warpPointer(w, ws->pointerx, ws->pointery);
	 else
#endif					/* GraphicsGL */
	 warpPointer(w, ws->pointerx, ws->pointery);
	 break;
	 }
      case A_POINTERCOL: {
	 if (!cnv:C_integer(d, tmp))
	    return Failed;
#ifdef GraphicsGL
	 if (ws->is_gl) {
	    ws->pointerx = GL_COLTOX(w, tmp) + wc->dx;
	    gl_warpPointer(w, ws->pointerx, ws->pointery);
	    }
	 else
#endif					/* GraphicsGL */
	 {
	 ws->pointerx = COLTOX(w, tmp) + wc->dx;
	 warpPointer(w, ws->pointerx, ws->pointery);
	 }
	 break;
	 }
      case A_POINTERROW: {
	 if (!cnv:C_integer(d, tmp))
	    return Failed;
#ifdef GraphicsGL
	 if (ws->is_gl) {
	    ws->pointery = GL_ROWTOY(w, tmp) + wc->dy;
	    gl_warpPointer(w, ws->pointerx, ws->pointery);
	    }
	 else
#endif					/* GraphicsGL */
	 {
	 ws->pointery = ROWTOY(w, tmp) + wc->dy;
	 warpPointer(w, ws->pointerx, ws->pointery);
	 }
	 break;
	 }
      /*
       * remaining valid attributes are error #147
       */
      case A_DEPTH:
      case A_DISPLAYHEIGHT:
      case A_DISPLAYWIDTH:
      case A_FHEIGHT:
      case A_FWIDTH:
      case A_ASCENT:
      case A_DESCENT:
         ReturnErrNum(147, RunError);
      /*
       * invalid attribute
       */
      default:
	 ReturnErrNum(145, RunError);
	 }
      strncpy(abuf, s, len);
      abuf[len] = '\0';
      }
   else {
      char *selectiontemp;
      int a;
      /*
       * get an attribute
       */
      strncpy(abuf, s, len);
      abuf[len] = '\0';
      switch (a=si_s2i(attribs, abuf)) {
      case A_SELECTION:
	 if ((selectiontemp=getselection(w, abuf)) == NULL) return Failed;
	 MakeStr(selectiontemp, strlen(selectiontemp), answer);
	 break;
      case A_IMAGE:
         ReturnErrNum(147, RunError);
         break;
#ifdef Graphics3D
      case A_RENDERMODE:
         if (wc->rendermode == UGL3D)
	    sprintf(abuf, "3d");
         else
	    sprintf(abuf, "2d");
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
      case A_DIM:
	 MakeInt(wc->dim, answer);
	 break;
      case A_EYE:
	 sprintf(abuf,"%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f",
		 ws->eyeposx, ws->eyeposy, ws->eyeposz, ws->eyedirx,
		 ws->eyediry, ws->eyedirz, ws->eyeupx, ws->eyeupy, ws->eyeupz);
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
      case A_EYEPOS:
 	 sprintf(abuf,"%.2f,%.2f,%.2f", ws->eyeposx, ws->eyeposy, ws->eyeposz);
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
      case A_EYEUP:
 	sprintf(abuf, "%.2f,%.2f,%.2f", ws->eyeupx, ws->eyeupy, ws->eyeupz);
	MakeStr(abuf, strlen(abuf), answer);
	break;
      case A_EYEDIR:
	sprintf(abuf, "%.2f,%.2f,%.2f", ws->eyedirx, ws->eyediry, ws->eyedirz);
	MakeStr(abuf, strlen(abuf), answer);
	break;
      case A_LIGHT:
      case A_LIGHT0:
	 getlight(0, abuf);
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
      case A_LIGHT1:
        getlight(1, abuf);
        MakeStr(abuf, strlen(abuf), answer);
        break;
      case A_LIGHT2:
        getlight(2, abuf);
        MakeStr(abuf, strlen(abuf), answer);
        break;
      case A_LIGHT3:
        getlight(3, abuf);
        MakeStr(abuf, strlen(abuf), answer);
        break;
      case A_LIGHT4:
        getlight(4, abuf);
        MakeStr(abuf, strlen(abuf), answer);
        break;
      case A_LIGHT5:
        getlight(5, abuf);
        MakeStr(abuf, strlen(abuf), answer);
        break;
      case A_LIGHT6:
        getlight(6, abuf);
        MakeStr(abuf, strlen(abuf), answer);
        break;
      case A_LIGHT7:
        getlight(7, abuf);
        MakeStr(abuf, strlen(abuf), answer);
        break;
      case A_ALPHA:
        sprintf(abuf,"%f",wc->alpha);
        MakeStr(abuf, strlen(abuf), answer);
	break;
      case A_PROJECTION:
	if (ws->projection == UGL_PERSPECTIVE)
           sprintf(abuf,"perspec");
	else
           sprintf(abuf,"ortho");
        MakeStr(abuf, strlen(abuf), answer);
	break;
      case A_CAMWIDTH:
        sprintf(abuf,"%f",ws->camwidth);
        MakeStr(abuf, strlen(abuf), answer);
	break;
      case A_MESHMODE:
        getmeshmode(w, abuf);
	MakeStr(abuf, strlen(abuf), answer);
        break;
      case A_TEXTURE:
	gettexture( w, answer );
	/* looks like a memory leak to me */
	if (is:string(*answer)) StrLoc(*answer) = strdup(StrLoc(*answer));
        break;
      case A_TEXMODE:
	gettexmode( w, abuf, answer );
        break;
      case A_NORMODE:
	 if (!wc->normode){
	    strcpy(abuf, "off");
	    MakeStr(abuf, 3, answer); 
	 }
	 else if (wc->normode==1){
	    strcpy(abuf, "auto");
	    MakeStr(abuf, 4, answer); 
	 }
	 else{
	    strcpy(abuf, "on");
	    MakeStr(abuf, 2, answer); 
	 }
	 break;
      case A_TEXCOORD:
	 strcpy(abuf, "auto");
	 if (wc->autogen)
	    MakeStr(abuf, 4, answer);
	 else {
	    gettexcoords(w, abuf);
	    MakeStr(strdup(abuf), strlen(abuf), answer);
	    }
	 break;
      case A_SLICES:
	MakeInt(wc->slices, answer);
	break;
      case A_RINGS:
	MakeInt(wc->rings, answer);
	break;
      case A_RGBMODE:
	 switch (wc->rgbmode) {
	    case 0: strcpy(abuf, "auto"); break;
	    case 1: strcpy(abuf, "24"); break;
	    case 2: strcpy(abuf, "48"); break;
	    case 3: strcpy(abuf, "normalized"); break;
	    }
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
      case A_PICK: {
	 sprintf(abuf,"%s",((w->context->selectionenabled==1)?"on":"off"));
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
	 }
      case A_GLRENDERER: {
#if HAVE_LIBGL
	 sprintf(abuf,"%s", (char *) glGetString(GL_RENDERER));
#else					/* HAVE_LIBGL */
	 sprintf(abuf,"%s", "Unknown");
#endif					/* HAVE_LIBGL */
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
	 }
      case A_GLVENDOR: {
#if HAVE_LIBGL
	 sprintf(abuf,"%s", (char *) glGetString(GL_VENDOR));
#else					/* HAVE_LIBGL */
	 sprintf(abuf,"%s", "Unknown");
#endif					/* HAVE_LIBGL */
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
	 }
      case A_GLVERSION: {
#if HAVE_LIBGL
	 sprintf(abuf,"%s", (char *) glGetString(GL_VERSION));
#else					/* HAVE_LIBGL */
	 sprintf(abuf,"%s", "Unknown");
#endif					/* HAVE_LIBGL */
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
	 }
      case A_BUFFERMODE: {
	 sprintf(abuf,"%s",((ws->buffermode==UGL_BUFFERED)?"on":"off"));
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
	 }
#endif					/* Graphics3D */
      case A_VISUAL:
#ifdef GraphicsGL
	 if (ws->is_gl) {
	    if (gl_getvisual(w, abuf) == Failed) return Failed;
	    }
	 else
#endif					/* GraphicsGL */
	 if (getvisual(w, abuf) == Failed) return Failed;
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
      case A_DEPTH:
	 MakeInt(SCREENDEPTH(w), answer);
	 break;
      case A_DISPLAY:
#ifdef GraphicsGL
	 if (ws->is_gl)
	    gl_getdisplay(w, abuf);
	 else
#endif					/* GraphicsGL */
	 getdisplay(w, abuf);
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
      case A_ASCENT:
#ifdef GraphicsGL
	 if (ws->is_gl) {
	    MakeInt(GL_ASCENT(w), answer);
            }
         else
#endif					/* GraphicsGL */
	 MakeInt(ASCENT(w), answer);
	 break;
      case A_DESCENT:
#ifdef GraphicsGL
	 if (ws->is_gl) {
	    MakeInt(GL_DESCENT(w), answer);
            }
         else
#endif					/* GraphicsGL */
	 MakeInt(DESCENT(w), answer);
	 break;
      case A_FHEIGHT:
#ifdef GraphicsGL
	 if (ws->is_gl) {
	    MakeInt(GL_FHEIGHT(w), answer);
            }
         else
#endif					/* GraphicsGL */
	 MakeInt(FHEIGHT(w), answer);
	 break;
      case A_FWIDTH:
#ifdef GraphicsGL
	 if (ws->is_gl) {
	    MakeInt(GL_FWIDTH(w), answer);
            }
         else
#endif					/* GraphicsGL */
	 MakeInt(FWIDTH(w), answer);
	 break;
      case A_INPUTMASK: {
         char *s = abuf;
         int mask = w->window->inputmask;
         if (mask & PointerMotionMask)
            *s++ = 'm';
         if (mask & KeyReleaseMask)
            *s++ = 'k';
         if (mask & WindowClosureMask)
            *s++ = 'c';
         *s = 0;
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
         }
      case A_ROW:
#ifdef GraphicsGL
	 if (ws->is_gl)
	    MakeInt(GL_YTOROW(w, ws->y - wc->dy), answer);
	 else
#endif					/* GraphicsGL */
	 MakeInt(YTOROW(w, ws->y - wc->dy), answer);
	 break;
      case A_COL:
#ifdef GraphicsGL
	 if (ws->is_gl)
	    MakeInt(1 + GL_XTOCOL(w, ws->x - wc->dx), answer);
	 else
#endif					/* GraphicsGL */
	 MakeInt(1 + XTOCOL(w, ws->x - wc->dx), answer);
	 break;
      case A_POINTERROW: {
	 XPoint xp;
#ifdef GraphicsGL
	 if (ws->is_gl) {
	    gl_query_pointer(w, &xp);
	    MakeInt(GL_YTOROW(w, xp.y - wc->dy), answer);
	    }
	 else
#endif					/* GraphicsGL */
	 {
	 query_pointer(w, &xp);
	 MakeInt(YTOROW(w, xp.y - wc->dy), answer);
	 }
	 break;
	 }
      case A_POINTERCOL: {
	 XPoint xp;
#ifdef GraphicsGL
	 if (ws->is_gl) {
	    gl_query_pointer(w, &xp);
	    MakeInt(1 + GL_XTOCOL(w, xp.x - wc->dx), answer);
	    }
	 else
#endif					/* GraphicsGL */
	 {
	 query_pointer(w, &xp);
	 MakeInt(1 + XTOCOL(w, xp.x - wc->dx), answer);
	 }
	 break;
	 }
      case A_LINES:
      case A_ROWS:
#ifdef GraphicsGL
	 if (ws->is_gl)
	    MakeInt(GL_YTOROW(w,ws->height - DESCENT(w)), answer);
	 else
#endif					/* GraphicsGL */
	 MakeInt(YTOROW(w,ws->height - DESCENT(w)), answer);
	 break;
      case A_COLUMNS:
#ifdef GraphicsGL
	 if (ws->is_gl)
	    MakeInt(GL_XTOCOL(w,ws->width), answer);
	 else
#endif					/* GraphicsGL */
	 MakeInt(XTOCOL(w,ws->width), answer);
	 break;
      case A_POS: case A_POSX: case A_POSY:
#ifdef GraphicsGL
	 if (ws->is_gl) {
	    if (gl_getpos(w) == Failed)
	       return Failed;
	    }
	 else
#endif					/* GraphicsGL */
	 if (getpos(w) == Failed)
	    return Failed;
	 switch (a) {
	 case A_POS:
	    sprintf(abuf, "%d,%d", ws->posx, ws->posy);
	    MakeStr(abuf, strlen(abuf), answer);
	    break;
	 case A_POSX:
	    MakeInt(ws->posx, answer);
	    break;
	 case A_POSY:
	    MakeInt(ws->posy, answer);
	    break;
	    }
	 break;
      case A_FG:
#ifdef Graphics3D
 	 if (w->context->rendermode == UGL3D)
	    getmaterials(abuf);
	 else
#endif
#ifdef GraphicsGL 
	 if (ws->is_gl)
	    gl_getfg(w, abuf);
	 else
#endif					/* GraphicsGL */
	 getfg(w, abuf);
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
      case A_BG:
#ifdef GraphicsGL 
	 if (ws->is_gl)
	    gl_getbg(w, abuf);
	 else
#endif					/* GraphicsGL */
	 getbg(w, abuf);
	 MakeStr(abuf, strlen(abuf), answer);
         break;
      case A_GAMMA:
#ifdef DescriptorDouble
	 answer->vword.realval = wc->gamma;
#else					/* DescriptorDouble */
         Protect(BlkLoc(*answer) = (union block *)alcreal(wc->gamma),
            return RunError);
#endif					/* DescriptorDouble */
         answer->dword = D_Real;
         break;
      case A_FILLSTYLE:
         sprintf(abuf, "%s",
            (wc->fillstyle == FS_SOLID) ? "solid" :
            (wc->fillstyle == FS_STIPPLE) ? "masked" : "textured");
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
      case A_LINESTYLE:
#ifdef GraphicsGL
	 if (ws->is_gl)
	    gl_getlinestyle(w, abuf);
	 else
#endif					/* GraphicsGL */
	 getlinestyle(w, abuf);
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
      case A_LINEWIDTH:
	 MakeInt(LINEWIDTH(w), answer);
	 break;
      case A_HEIGHT: { MakeInt(ws->height, answer); break; }
      case A_WIDTH: { MakeInt(ws->width, answer); break; }
      case A_SIZE:
	 sprintf(abuf, "%d,%d", ws->width, ws->height);
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
      case A_RESIZE:
	 sprintf(abuf,"%s",(ISRESIZABLE(w)?"on":"off"));
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
      case A_DISPLAYHEIGHT:
	 MakeInt(DISPLAYHEIGHT(w), answer);
	 break;
      case A_DISPLAYWIDTH:
	 MakeInt(DISPLAYWIDTH(w), answer);
	 break;
      case A_CURSOR:
	 sprintf(abuf,"%s",(ISCURSORON(w)?"on":"off"));
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
      case A_ECHO:
	 sprintf(abuf,"%s",(ISECHOON(w)?"on":"off"));
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
      case A_REVERSE:
	 sprintf(abuf,"%s",(ISREVERSE(w)?"on":"off"));
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
      case A_FONT:
#ifdef GraphicsGL
	 if (ws->is_gl)
	    gl_getfntnam(w, abuf);
	 else
#endif					/* GraphicsGL */
	 getfntnam(w, abuf);
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
      case A_X:  MakeInt(ws->x - wc->dx, answer); break;
      case A_Y:  MakeInt(ws->y - wc->dy, answer); break;
      case A_DX: MakeInt(wc->dx, answer); break;
      case A_DY: MakeInt(wc->dy, answer); break;
      case A_LEADING: MakeInt(LEADING(w), answer); break;
      case A_POINTERX: {
	 XPoint xp;
#ifdef GraphicsGL
	 if (ws->is_gl)
	    gl_query_pointer(w, &xp);
	 else
#endif					/* GraphicsGL */
	 query_pointer(w, &xp);
	 MakeInt(xp.x - wc->dx, answer);
	 break;
	 }
      case A_POINTERY: {
	 XPoint xp;
#ifdef GraphicsGL
	 if (ws->is_gl)
	    gl_query_pointer(w, &xp);
	 else
#endif					/* GraphicsGL */
	 query_pointer(w, &xp);
	 MakeInt(xp.y - wc->dy, answer);
	 break;
	 }
      case A_POINTER:
#ifdef GraphicsGL
	 if (ws->is_gl)
	    gl_getpointername(w, abuf);
	 else
#endif					/* GraphicsGL */
	 getpointername(w, abuf);
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
      case A_DRAWOP:
#ifdef GraphicsGL
	 if (ws->is_gl)
	    gl_getdrawop(w, abuf);
	 else
#endif					/* GraphicsGL */
	 getdrawop(w, abuf);
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
      case A_GEOMETRY:
#ifdef GraphicsGL
	 if (ws->is_gl)
	    if (gl_getpos(w) == Failed) return Failed;
	 else
#endif					/* GraphicsGL */
	 if (getpos(w) == Failed) return Failed;
         if (ws->win)
           sprintf(abuf, "%dx%d+%d+%d",
		   ws->width, ws->height, ws->posx, ws->posy);
         else
           sprintf(abuf, "%dx%d", ws->pixwidth, ws->pixheight);
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
      case A_CANVAS:
#ifdef GraphicsGL
	 if (ws->is_gl)
	    gl_getcanvas(w, abuf);
	 else
#endif					/* GraphicsGL */
	 getcanvas(w, abuf);
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
      case A_ICONIC:
#ifdef GraphicsGL
	 if (ws->is_gl)
	    gl_geticonic(w, abuf);
	 else
#endif					/* GraphicsGL */
	 geticonic(w, abuf);
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
      case A_ICONIMAGE:
	 if (ICONFILENAME(w) != NULL)
	    sprintf(abuf, "%s", ICONFILENAME(w));
	 else *abuf = '\0';
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
      case A_ICONLABEL:
	 if (ICONLABEL(w) != NULL)
	    sprintf(abuf, "%s", ICONLABEL(w));
	 else return Failed;
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
      case A_LABEL:
      case A_WINDOWLABEL:
	 if (WINDOWLABEL(w) != NULL)
	    sprintf(abuf,"%s", WINDOWLABEL(w));
	 else return Failed;
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
      case A_ICONPOS: {
#ifdef GraphicsGL
	 if (ws->is_gl)
	    switch (gl_geticonpos(w,abuf)) {
	       case Failed: return Failed;
	       case RunError:  return Failed;
	    }
	 else
#endif					/* GraphicsGL */
	 switch (geticonpos(w,abuf)) {
	    case Failed: return Failed;
	    case RunError:  return Failed;
	    }
	 MakeStr(abuf, strlen(abuf), answer);
	 break;
	 }
      case A_PATTERN: {
	 s = w->context->patternname;
	 if (s != NULL) {
	    strcpy(abuf, s);
	    MakeStr(abuf, strlen(s), answer);
	    }
	 else {
	    strcpy(abuf, "black");
	    MakeStr(abuf, 5, answer);
	    }
	 break;
	 }
      case A_CLIPX:
	 if (wc->clipw >= 0)
	    MakeInt(wc->clipx, answer);
	 else
	    *answer = nulldesc;
	 break;
      case A_CLIPY:
	 if (wc->clipw >= 0)
	    MakeInt(wc->clipy, answer);
	 else
	    *answer = nulldesc;
	 break;
      case A_CLIPW:
	 if (wc->clipw >= 0)
	    MakeInt(wc->clipw, answer);
	 else
	    *answer = nulldesc;
	 break;
      case A_CLIPH:
	 if (wc->clipw >= 0)
	    MakeInt(wc->cliph, answer);
	 else
	    *answer = nulldesc;
	 break;
      default:
	 ReturnErrNum(145, RunError);
	 }
   }
#ifdef GraphicsGL
   if (ws->is_gl)
      gl_wflush(w);
   else
#endif					/* GraphicsGL */
   wflush(w);
   return Succeeded;
   }

/*
 * rectargs -- interpret rectangle arguments uniformly
 *
 *  Given an arglist and the index of the next x value, rectargs sets
 *  x/y/width/height to explicit or defaulted values.  These result values
 *  are in canonical form:  Width and height are nonnegative and x and y
 *  have been corrected by dx and dy.
 *
 *  Returns index of bad argument, if any, or -1 for success.
 */
int rectargs(w, argc, argv, i, px, py, pw, ph)
wbp w;
int argc;
dptr argv;
int i;
C_integer *px, *py, *pw, *ph;
   {
   int defw, defh;
   wcp wc = w->context;
   wsp ws = w->window;

   /*
    * Get x and y, defaulting to -dx and -dy.
    */
   if (i >= argc)
      *px = -wc->dx;
   else if (!def:C_integer(argv[i], -wc->dx, *px))
      return i;

   if (++i >= argc)
      *py = -wc->dy;
   else if (!def:C_integer(argv[i], -wc->dy, *py))
      return i;

   *px += wc->dx;
   *py += wc->dy;

   /*
    * Get w and h, defaulting to extend to the edge
    */
   defw = ws->width - *px;
   defh = ws->height - *py;

   if (++i >= argc)
      *pw = defw;
   else if (!def:C_integer(argv[i], defw, *pw))
      return i;

   if (++i >= argc)
      *ph = defh;
   else if (!def:C_integer(argv[i], defh, *ph))
      return i;

   /*
    * Correct negative w/h values.
    */
   if (*pw < 0)
      *px -= (*pw = -*pw);
   if (*ph < 0)
      *py -= (*ph = -*ph);

   return -1;
   }

/*
 * docircles -- draw or file circles.
 *
 *  Helper for DrawCircle and FillCircle.
 *  Returns index of bad argument, or -1 for success.
 */
int docircles(w, argc, argv, fill)
wbp w;
int argc;
dptr argv;
int fill;
   {
   XArc arc;
   int i, dx, dy;
   double x, y, r, theta, alpha;

   dx = w->context->dx;
   dy = w->context->dy;

   for (i = 0; i < argc; i += 5) {	/* for each set of five args */

      /*
       * Collect arguments.
       */
      if (i + 2 >= argc)
         return i + 2;			/* missing y or r */
      if (!cnv:C_double(argv[i], x))
         return i;
      if (!cnv:C_double(argv[i + 1], y))
         return i + 1;
      if (!cnv:C_double(argv[i + 2], r))
         return i + 2;
      if (i + 3 >= argc)
         theta = 0.0;
      else if (!def:C_double(argv[i + 3], 0.0, theta))
         return i + 3;
      if (i + 4 >= argc)
         alpha = 2 * Pi;
      else if (!def:C_double(argv[i + 4], 2 * Pi, alpha))
         return i + 4;

      /*
       * Put in canonical form: r >= 0, -2*pi <= theta < 0, alpha >= 0.
       */
      if (r < 0) {			/* ensure positive radius */
         r = -r;
         theta += Pi;
         }
      if (alpha < 0) {			/* ensure positive extent */
         theta += alpha;
         alpha = -alpha;
         }

      theta = fmod(theta, 2 * Pi);
      if (theta > 0)			/* normalize initial angle */
         theta -= 2 * Pi;

      /*
       * Build the Arc descriptor.
       */
      arc.x = x + dx - r;
      arc.y = y + dy - r;
      ARCWIDTH(arc) = 2 * r;
      ARCHEIGHT(arc) = 2 * r;

      arc.angle1 = ANGLE(theta);
      if (alpha >= 2 * Pi)
         arc.angle2 = EXTENT(2 * Pi);
      else
         arc.angle2 = EXTENT(alpha);

      /*
       * Draw or fill the arc.
       */
#ifdef GraphicsGL
      if (w->window->is_gl) {
         if (fill) 
            gl_fillcircles(w, &arc, 1);
         else 
            gl_drawcircles(w, &arc, 1);
         }
      else 
#endif					/* GraphicsGL */
      {
      if (fill) {			/* {} required due to form of macros */
         fillarcs(w, &arc, 1);
         }
      else {
         drawarcs(w, &arc, 1);
         }
      }
      }
   return -1;
   }


/*
 * genCurve - draw a smooth curve through a set of points.  Algorithm from
 *  Barry, Phillip J., and Goldman, Ronald N. (1988).
 *  A Recursive Evaluation Algorithm for a class of Catmull-Rom Splines.
 *  Computer Graphics 22(4), 199-204.
 *
 * TODO: this algorithm generates a good number of duplicate coordinates.
 * Filter them as they are placed on the output array to be passed to helper.
 */
void genCurve(wbp w, XPoint *p, int n, void (*helper) (wbp, XPoint [], int))
{
   int    i, j, steps;
   float  ax, ay, bx, by, stepsize, stepsize2, stepsize3;
   float  x, dx, d2x, d3x, y, dy, d2y, d3y;
   XPoint *thepoints = NULL;
   long npoints = 0;

   for (i = 3; i < n; i++) {
      /*
       * build the coefficients ax, ay, bx and by, using:
       *                             _              _   _    _
       *   i                 i    1 | -1   3  -3   1 | | Pi-3 |
       *  Q (t) = T * M   * G   = - |  2  -5   4  -1 | | Pi-2 |
       *               CR    Bs   2 | -1   0   1   0 | | Pi-1 |
       *                            |_ 0   2   0   0_| |_Pi  _|
       */

      ax = p[i].x - 3 * p[i-1].x + 3 * p[i-2].x - p[i-3].x;
      ay = p[i].y - 3 * p[i-1].y + 3 * p[i-2].y - p[i-3].y;
      bx = 2 * p[i-3].x - 5 * p[i-2].x + 4 * p[i-1].x - p[i].x;
      by = 2 * p[i-3].y - 5 * p[i-2].y + 4 * p[i-1].y - p[i].y;

      /*
       * calculate the forward differences for the function using
       * intervals of size 0.1
       */
#ifndef abs
#define abs(x) ((x)<0?-(x):(x))
#endif
#ifndef max
#define max(x,y) ((x>y)?x:y)
#endif

#if VMS
      {
      int tmp1 = abs(p[i-1].x - p[i-2].x);
      int tmp2 = abs(p[i-1].y - p[i-2].y);
      steps = max(tmp1, tmp2) + 10;
      }
#else						/* VMS */
      steps = max(abs(p[i-1].x - p[i-2].x), abs(p[i-1].y - p[i-2].y)) + 10;
#endif						/* VMS */

      if (steps+4 > npoints) {
         if (thepoints != NULL) free(thepoints);
	 thepoints = (XPoint *)malloc((steps+4) * sizeof(XPoint));
	 npoints = steps+4;
         }

      stepsize = 1.0/steps;
      stepsize2 = stepsize * stepsize;
      stepsize3 = stepsize * stepsize2;

      x = thepoints[0].x = p[i-2].x;
      y = thepoints[0].y = p[i-2].y;
      dx = (stepsize3*0.5)*ax + (stepsize2*0.5)*bx + (stepsize*0.5)*(p[i-1].x-p[i-3].x);
      dy = (stepsize3*0.5)*ay + (stepsize2*0.5)*by + (stepsize*0.5)*(p[i-1].y-p[i-3].y);
      d2x = (stepsize3*3) * ax + stepsize2 * bx;
      d2y = (stepsize3*3) * ay + stepsize2 * by;
      d3x = (stepsize3*3) * ax;
      d3y = (stepsize3*3) * ay;

      /* calculate the points for drawing the curve */

      for (j = 0; j < steps; j++) {
	 x = x + dx;
	 y = y + dy;
	 dx = dx + d2x;
	 dy = dy + d2y;
	 d2x = d2x + d3x;
	 d2y = d2y + d3y;
         thepoints[j + 1].x = (int)x;
         thepoints[j + 1].y = (int)y;
         }
      helper(w, thepoints, steps + 1);
      }
   if (thepoints != NULL) {
      free(thepoints);
      thepoints = NULL;
      }
   }

void curveLister(wbp w, XPoint *pts, int n)
{
   int i;
   struct descrip d;
   struct descrip *dp = (struct descrip *) w;

   /*
    * Algorithm computes duplicate points, so filter them.
    * w is actually a descrip ptr to a list to put into.
    */
   for(i=0; i<n; i++) {
      if ((i==0) || (pts[i].x != pts[i-1].x) || (pts[i].y != pts[i-1].y)) {
	 MakeInt(pts[i].x, &d);
	 c_put(dp, &d);
	 MakeInt(pts[i].y, &d);
	 c_put(dp, &d);
	 }
      }
}

static void curveHelper(wbp w, XPoint *thepoints, int n)
   {
   /*
    * Could use drawpoints(w, thepoints, n)
    *  but that ignores the linewidth and linestyle attributes...
    * Might make linestyle work a little better by "compressing" straight
    *  sections produced by genCurve into single drawline points.
    */
#ifdef GraphicsGL
   if (w->window->is_gl)
      gl_drawlines(w, thepoints, n);
   else
#endif					/* GraphicsGL */
   drawlines(w, thepoints, n);
   }

/*
 * draw a smooth curve through the array of points
 */
void drawCurve(w, p, n)
wbp w;
XPoint *p;
int n;
   {
   genCurve(w, p, n, curveHelper);
   }


void waitkey(FILE *w)
{
   struct descrip answer;
   /* throw away pending events */
   while (BlkD(((wbp)w)->window->listp,List)->size > 0) {
      wgetevent((wbp)w, &answer,-1);
      }
   /* wait for an event */
   wgetevent((wbp)w, &answer,-1);
}

#if !NT
  extern FILE *flog;
#endif						/* NT */



/*
 * Compare two unsigned long values for qsort or qsearch.
 */
int ulcmp(p1, p2)
pointer p1, p2;
   {
   register unsigned long u1 = *(unsigned int *)p1;
   register unsigned long u2 = *(unsigned int *)p2;

   if (u1 < u2)
      return -1;
   else
      return (u1 > u2);
   }


/*
 * And now, the stringint data.
 * Convention: the 0'th element of a stringint array contains the
 * NULL string, and an integer count of the # of elements in the array.
 */

stringint attribs[] = {
   { 0,			NUMATTRIBS},
   {"alpha",		A_ALPHA},
   {"ascent",		A_ASCENT},
   {"bg",		A_BG},
   {"buffer",           A_BUFFERMODE},
   {"camwidth",		A_CAMWIDTH},
   {"canvas",		A_CANVAS},
   {"ceol",		A_CEOL},
   {"cliph",		A_CLIPH},
   {"clipw",		A_CLIPW},
   {"clipx",		A_CLIPX},
   {"clipy",		A_CLIPY},
   {"col",		A_COL},
   {"columns",		A_COLUMNS},
   {"cursor",		A_CURSOR},
   {"depth",		A_DEPTH},
   {"descent",		A_DESCENT},
   {"dim",		A_DIM},
   {"display",		A_DISPLAY},
   {"displayheight",	A_DISPLAYHEIGHT},
   {"displaywidth",	A_DISPLAYWIDTH},
   {"drawop",		A_DRAWOP},
   {"dx",		A_DX},
   {"dy",		A_DY},
   {"echo",		A_ECHO},
   {"eye",		A_EYE},
   {"eyedir",		A_EYEDIR},
   {"eyepos",		A_EYEPOS},
   {"eyeup",		A_EYEUP},
   {"fg",		A_FG},
   {"fheight",		A_FHEIGHT},
   {"fillstyle",	A_FILLSTYLE},
   {"font",		A_FONT},
   {"fovangle",		A_FOV},
   {"fwidth",		A_FWIDTH},
   {"gamma",		A_GAMMA},
   {"geometry",		A_GEOMETRY},
   {"glrenderer",	A_GLRENDERER},
   {"glvendor",		A_GLVENDOR},
   {"glversion",	A_GLVERSION},
   {"height",		A_HEIGHT},
   {"iconic",		A_ICONIC},
   {"iconimage",	A_ICONIMAGE},
   {"iconlabel",	A_ICONLABEL},
   {"iconpos",		A_ICONPOS},
   {"image",		A_IMAGE},
   {"inputmask",	A_INPUTMASK},
   {"label",		A_LABEL},
   {"leading",		A_LEADING},
   {"light",	 	A_LIGHT},
   {"light0",	 	A_LIGHT0},
   {"light1",	 	A_LIGHT1},
   {"light2",	 	A_LIGHT2},
   {"light3",	 	A_LIGHT3},
   {"light4",	 	A_LIGHT4},
   {"light5",	 	A_LIGHT5},
   {"light6",	 	A_LIGHT6},
   {"light7",	 	A_LIGHT7},
   {"lines",		A_LINES},
   {"linestyle",	A_LINESTYLE},
   {"linewidth",	A_LINEWIDTH},
   {"meshmode",		A_MESHMODE},
   {"normode",		A_NORMODE},
   {"pattern",		A_PATTERN},
   {"pick",		A_PICK},
   {"pointer",		A_POINTER},
   {"pointercol",	A_POINTERCOL},
   {"pointerrow",	A_POINTERROW},
   {"pointerx",		A_POINTERX},
   {"pointery",		A_POINTERY},
   {"pos",		A_POS},
   {"posx",		A_POSX},
   {"posy",		A_POSY},
   {"projection",	A_PROJECTION},
   {"rendermode",	A_RENDERMODE},
   {"resize",		A_RESIZE},
   {"reverse",		A_REVERSE},
   {"rgbmode",		A_RGBMODE},
   {"rings",		A_RINGS},
   {"row",		A_ROW},
   {"rows",		A_ROWS},
   {"selection",	A_SELECTION},
   {"size",		A_SIZE},
   {"slices",		A_SLICES},
   {"texcoord",		A_TEXCOORD},
   {"texmode",		A_TEXMODE},
   {"texture",		A_TEXTURE},
   {"titlebar",		A_TITLEBAR},
   {"visual",		A_VISUAL},
   {"width",		A_WIDTH},
   {"windowlabel",	A_WINDOWLABEL},
   {"x",		A_X},
   {"y",		A_Y},
};

void gotorc(wbp w,int r,int c)
{
   wsp ws = w->window;
   wcp wc = w->context;

   /*
    * turn the cursor off
    */
   hidecrsr(ws);

#ifdef GraphicsGL
   if (ws->is_gl) {
      ws->y = GL_ROWTOY(w, r);
      ws->x = GL_COLTOX(w, c);
      }
   else
#endif					/* GraphicsGL */
   {
   ws->y = ROWTOY(w, r);
   ws->x = COLTOX(w, c);
   }
   ws->x += wc->dx;
   ws->y += wc->dy;

   /*
    * turn it back on at new location
    */
   UpdateCursorPos(ws, wc);
   showcrsr(ws);
}

void gotoxy(wbp w, int x, int y)
{
   wsp ws = w->window;
   wcp wc = w->context;

   x += wc->dx;
   y += wc->dy;

   hidecrsr(ws);

   ws->x = x;
   ws->y = y;

   UpdateCursorPos(ws, wc);
   showcrsr(ws);
}

void drawpts(wbp w, XPoint *points, int npoints)
{
   drawpoints(w, points, npoints);
}

int guicurses_lines(wbp w)
{
#ifdef GraphicsGL
   if (w->window->is_gl)
      return GL_YTOROW(w,w->window->height - GL_DESCENT(w));
   else
#endif					/* GraphicsGL */
   return YTOROW(w,w->window->height - DESCENT(w));
}

int guicurses_cols(wbp w)
{
#ifdef GraphicsGL
   if (w->window->is_gl)
      return GL_XTOCOL(w,w->window->width - GL_DESCENT(w));
#endif					/* GraphicsGL */
   return XTOCOL(w,w->window->width - DESCENT(w));
}

/* convenience function: C language set clip region */

/*
 * convenience function: C language draw rectangle
 */
void drawRectangle(wbp w,int x,int y,int width,int height)
{
  XRectangle r[1];
  RECX(r[0]) = x;
  RECY(r[0]) = y;
  RECWIDTH(r[0]) = width;
  RECHEIGHT(r[0]) = height;
  drawrectangles(w,r,1);
}

int Wx()
{
   return IntVal(amperX);
}

int Wy()
{
   return IntVal(amperY);
}

/*
 * convenience function: C language set-attribute
 */
char * watt(wbp w, char *s)
{
   int config=0, len = strlen(s);
   struct descrip throw;
   char foo[256];
   wattrib(w, s, strlen(s), &throw, foo);

   if (len > 4) {
      if (!strncmp(s, "pos=", 4)) config |= 1;
      if (len > 5) {
	 if (!strncmp(s, "posx=", 5)) config |= 1;
	 if (!strncmp(s, "posy=", 5)) config |= 1;
	 if (!strncmp(s, "rows=", 5)) config |= 2;
	 if (!strncmp(s, "size=", 5)) config |= 2;
	 if (len > 6) {
	    if (!strncmp(s, "width=", 6)) config |= 2;
	    if (!strncmp(s, "lines=", 6)) config |= 2;
	    if (len > 7) {
	       if (!strncmp(s, "height=", 7)) config |= 2;
	       if (!strncmp(s, "resize=", 7)) config |= 2;
	       if (len > 8) {
		  if (!strncmp(s, "columns=", 8)) config |= 2;
		  if (len > 9) {
		     if (!strncmp(s, "geometry=", 9)) config |= 3;
		     }
		  }
		}
	    }
	 }
      }

   if (config) {
#ifdef GraphicsGL
      if (w->window->is_gl) {
         if (gl_do_config(w, config) == Failed) return NULL;
         }
      else
#endif					/* GraphicsGL */
      if (do_config(w, config) == Failed) return NULL;
      }

   if (strchr(s, '=') == NULL) {
      if (is:integer(throw)) {
	 sprintf(foo, "%ld", (long)(IntVal(throw)));
	 }
      else if (!is:string(throw)) return NULL;
      return strdup(foo);
      }
   return NULL;
}


char child_window_generic(wbp w, wbp wp, int child_window)
{
   wsp ws;
   wcp wc;
   struct wbind_list *curr;
   wdp wd = wp->window->display;
   int is_3d;

   is_3d = (child_window==CHILD_WIN3D)? 1 : 0;

   /*
    * allocate a window state, and a context
    */
#ifdef GraphicsGL   
   if (wp->window->is_gl || is_3d) {
      Protect(w->window = gl_alc_winstate(), { free_binding(w); return 0; });
      //if (!wp->window->is_gl) w->window->is_gl = 0;
      }
   else
#endif					/* GraphicsGL */
   Protect(w->window = alc_winstate(), { free_binding(w); return 0; });
   ws = w->window;
   ws->display = wd;
    CLRTITLEBAR(ws);
#ifdef GraphicsGL   
   if (w->window->is_gl) {
      Protect(w->context = gl_alc_context(w), { free_binding(w); return 0; });
      }
   else
#endif					/* GraphicsGL */
   Protect(w->context = alc_context(w), { free_binding(w); return 0; });

   wc = w->context;
   wc->display = wd;
#ifdef GraphicsGL 
   if (wp->window->is_gl) 
      wc->font = wd->glfonts;
   else
#endif					/* GraphicsGL */
#ifdef XWindows
      wc->font = wd->fonts;
#endif					/* XWindows */
   wd->refcount++;

   ws->listp.dword = D_List;
   BlkLoc(ws->listp) = (union block *) alclist(0, MinListSlots);
   ws->width = ws->height = 0;

   ws->children=NULL;
   ws->parent = wp;
   wp->refcount++;

   curr = (struct wbind_list *) malloc(sizeof(struct wbind_list));
   curr->child = w;
   curr->next = wp->window->children;
   wp->window->children = curr;
   w->refcount++;

   /*
    * some attributes of the context determine window defaults
    */
#ifdef GraphicsGL
   ws->is_3D = wc->rendermode = is_3d;
   if (child_window >= CHILD_WINTEXTURE ){
      wtp wt = &(ws->display->stex[ws->texindex]);
      ws->height = wt->height;
      ws->width  = wt->width;
      ws->y = 0;
      ws->x = 0;
      ws->texindex = child_window - CHILD_WINTEXTURE;
      ws->type = TEXTURE_WSTATE;
      wc->rendermode = UGL2D; /* 0 */
      wc->buffermode = IMMEDIATE3D;
      }
   else
#endif					/* GraphicsGL */
      {
      ws->y = 0;
      ws->x = 0;
      ws->y += wc->dy;
      ws->x += wc->dx;
      }
  return 1;
}

/*
 * There are more, X-specific stringint arrays in ../common/xwindow.c
 */

#else					/* Graphics */

/*
 * Stubs to prevent dynamic loader from rejecting cfunc library of IPL.
 */
int palnum(dptr *d)					{ return 0; }
char *rgbkey(int p, double r, double g, double b)	{ return 0; }

#endif					/* Graphics */


/*
 * The next section consists of code to deal with string-integer
 * (stringint) symbols.  See rstructs.h.
 */

/*
 * string-integer comparison, for qsearch()
 */
static int sicmp(sip1,sip2)
siptr sip1, sip2;
{
  return strcmp(sip1->s, sip2->s);
}

/*
 * string-integer lookup function: given a string, return its integer
 */
int si_s2i(sip,s)
siptr sip;
char *s;
{
  stringint key;
  siptr p;
  key.s = s;

  p = (siptr)qsearch((char *)&key,(char *)(sip+1),sip[0].i,sizeof(key),sicmp);
  if (p) return p->i;
  return -1;
}

/*
 * string-integer inverse function: given an integer, return its string
 */
char *si_i2s(sip,i)
siptr sip;
int i;
{
  register siptr sip2 = sip+1;
  for(;sip2<=sip+sip[0].i;sip2++) if (sip2->i == i) return sip2->s;
  return NULL;
}
