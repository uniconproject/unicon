/*
 * pmwin.h - macros and types used in PresentationManager graphics interface.
 */
#ifdef PresentationManager
#include <os2.h>
/*
 * id's for various PM resources
 */
#define IDD_RUNERR			400
#define DID_TEXT			401
#define DID_ERRNO			402
#define DID_FILE			403
#define DID_LINE			404
#define DID_MSG 			405
#define DID_OFFEND			406
#define DID_TRACE			407

/* pointer shapes */
#define PTR_XARROW			500
#define PTR_BASE_ARROW_DOWN		501
#define PTR_BASE_ARROW_UP		502
#define PTR_BOTTOM_LEFT_CORNER		503
#define PTR_BOAT			504
#define PTR_BOGOSITY			505
#define PTR_BOTTOM_SIDE 		506
#define PTR_BOTTOM_TEE			507
#define PTR_BOTTOM_RIGHT_CORNER 	508
#define PTR_BOX_SPIRAL			509
#define PTR_CENTER_PTR			510
#define PTR_CIRCLE			511
#define PTR_CLOCK			512
#define PTR_CROSS			513
#define PTR_CROSSHAIR			514
#define PTR_CROSS_REVERSE		515
#define PTR_SB_DOWN_ARROW		516
#define PTR_DOUBLE_ARROW		517
#define PTR_SB_H_DOUBLE_ARROW		518
#define PTR_DIAMOND_CROSS		519
#define PTR_DOT 			520
#define PTR_DOTBOX			521
#define PTR_DRAFT_LARGE 		522
#define PTR_DRAFT_SMALL 		523
#define PTR_DRAPED_BOX			524
#define PTR_EXCHANGE			525
#define PTR_FLEUR			526
#define PTR_GOBBLER			527
#define PTR_GUMBY			528
#define PTR_HAND1			529
#define PTR_HAND2			530
#define PTR_HEART			531
#define PTR_ICON			532
#define PTR_IRON_CROSS			533
#define PTR_SB_LEFT_ARROW		534
#define PTR_LEFTBUTTON			535
#define PTR_LEFT_PTR			536
#define PTR_LEFT_SIDE			537
#define PTR_LEFT_TEE			538
#define PTR_LL_ANGLE			539
#define PTR_LR_ANGLE			540
#define PTR_MAN 			541
#define PTR_MIDDLEBUTTON		542
#define PTR_MOUSE			543
#define PTR_COFFEE_MUG			544
#define PTR_PENCIL			545
#define PTR_PIRATE			546
#define PTR_PLUS			547
#define PTR_QUESTION_ARROW		548
#define PTR_SB_RIGHT_ARROW		549
#define PTR_RIGHTBUTTON 		550
#define PTR_RIGHT_PTR			551
#define PTR_RIGHT_SIDE			552
#define PTR_RIGHT_TEE			553
#define PTR_RTLLOGO			554
#define PTR_SAILBOAT			555
#define PTR_SHUTTLE			556
#define PTR_SIZING			557
#define PTR_SPIDER			558
#define PTR_SPRAYCAN			559
#define PTR_STAR			560
#define PTR_TARGET			561
#define PTR_TCROSS			562
#define PTR_TOP_LEFT_ARROW		563
#define PTR_TOP_LEFT_CORNER		564
#define PTR_TOP_TEE			565
#define PTR_TOP_RIGHT_CORNER		566
#define PTR_TREK			567
#define PTR_TOP_SIDE			568
#define PTR_SB_UP_ARROW 		569
#define PTR_UL_ANGLE			570
#define PTR_UMBRELLA			571
#define PTR_UR_ANGLE			572
#define PTR_SB_V_DOUBLE_ARROW		573
#define PTR_XWATCH			574
#define PTR_X_CURSOR			575
#define PTR_XTERM			576

#define GammaCorrection 1.0

#define TEXTWIDTH(w,s,n) GetTextWidth(w, s, n)
#define SCREENDEPTH(w) (ScreenBitsPerPel)
#define ASCENT(w) (w->context->font->metrics.lMaxAscender)
#define DESCENT(w) (w->context->font->metrics.lMaxDescender)
#define LEADING(w) (w->context->fntLeading)
#define FHEIGHT(w) (w->context->font->metrics.lMaxBaselineExt)
#define FWIDTH(w) (w->context->font->metrics.lMaxCharInc)
#define LINEWIDTH(w) (w->context->lineBundle.lGeomWidth + 1)
#define DISPLAYHEIGHT(w) (ScreenHeight)
#define DISPLAYWIDTH(w) (ScreenWidth)
#define wflush(w) /* noop */
#define wsync(w) /* noop */
#define SysColor int
#define RED(x) (((x) >> 16) & 0xFF)
#define GREEN(x) (((x) >> 8) & 0xFF)
#define BLUE(x) ((x) & 0xFF)
#define ARCWIDTH(arc) ((arc).arcp.lP)
#define ARCHEIGHT(arc) ((arc).arcp.lQ)
/*
 * These get fixed up in the window-system-specific code
 */
#define RECX(rec) ((rec).xLeft)
#define RECY(rec) ((rec).yTop)
#define RECWIDTH(rec) ((rec).xRight)
#define RECHEIGHT(rec) ((rec).yBottom)
/*
 * convert from radians (was 1/64 of degrees) to 1/65536 of degrees
 */
deliberate syntax error - needs converting for OS/2
#define ANGLE(ang) (ang)
#define EXTENT(ang)(ang)
#define FULLARC (23040)

#define ISICONIC(w) ((w)->window->winState & WS_MIN)
#define ISFULLSCREEN(w) ((w)->window->winState & WS_MAX)
#define ISNORMALWINDOW(w) (!(ISICONIC(w) || ISFULLSCREEN(w)))

#define ISROOTWIN(w) (0)

#define ICONFILENAME(w) ((w)->window->iconimage)
#define ICONLABEL(w) ((w)->window->iconlabel)
#define WINDOWLABEL(w) ((w)->window->windowlabel)

/*
 * don't want to include this if we are making the translator
 */

#define MAXDESCENDER(w) (w->context->font->metrics.lMaxDescender)

#define STDLOCALS(w) \
   wcp wc = (w)->context; \
   wsp ws = (w)->window; \
   HPS stdwin = ws->hpsWin; \
   HPS stdbit = ws->hpsBitmap;

/*
 * the interpreter thread stack size - make it really big since this will
 * grow up to this max dynamically
 */
#define THREADSTACKSIZE      512000

/*
 * special events for window creation/communication between threads
 */
#define REQUEST_DESTROY      (WM_USER)
#define REQUEST_WINDOW	     (WM_USER + 1)
#define DESTROYED_WINDOW     (WM_USER + 2)
#define NEW_WINDOW	     (WM_USER + 3)
#define REQUEST_SHUTDOWN     (WM_USER + 4)
#define WINDOW_SIZED	     (WM_USER + 5)
#define KEY_PRESS	     (WM_USER + 6)
#define MOUSE_EVENT	     (WM_USER + 7)

/*
 * these are the bounds for the events that we want the interp thread
 * to pick up for the
 */
#define INTERP_EVENT_START     REQUEST_SHUTDOWN
#define INTERP_EVENT_END       MOUSE_EVENT
/*
 * whether you should block waiting for an event or not
 */
#define WAIT_EVT	     1
#define NO_WAIT_EVT	     0
/*
 * gemeotry bitmasks
 */
#define GEOM_WIDTH	     1
#define GEOM_HEIGHT	     2
#define GEOM_POSX	     4
#define GEOM_POSY	     8
/*
 * wonderful define to get around RTT
 */
#define MRESULT_N_EXPENTRY   MRESULT EXPENTRY
#define VOID_APIENTRY	     void APIENTRY
/*
 * mutual exclusion
 */
/* 2 seconds */
#define MAXWAIT 	     2000
#define INFINITE_WAIT	     -1
/*
 * initial dependants allocated for context/window bundles
 */
#define INITDEPS	     32
/*
 * fill styles
 */
#define FS_SOLID	     1
#define FS_STIPPLE	     2
#define FS_OPAQUESTIPPLE     4
/*
 * the special ROP code for mode reverse
 */
#define ROP_USER1	     (ROP_ONE << 1)
/*
 * window states
 */
#define WS_NORMAL	    0x01
#define WS_MIN		    0x02
#define WS_MAX		    0x04
#define WS_HIDDEN	    0x80

/*
 * something I think should be #defined
 */
#define EOS		     '\0'

/* size of the working buffer, used for dialog messages and such */
#define PMSTRBUFSIZE	     2048
/*
 * the bitmasks for the modifier keys
 */
#define ControlMask	     (1 << 16)
#define Mod1Mask	     (2 << 16)
#define ShiftMask	     (4 << 16)
#define VirtKeyMask	     (8 << 16)

/* some macros for PresentationManager */
#define TimedMutexOn(ws, place) {  \
	 if (ws->mutex && DosRequestMutexSem(ws->mutex, MAXWAIT) == ERROR_TIMEOUT) \
	   Bomb("Waiting for mutex in ", place); \
	 }
#define MutexOn(ws) {if (ws->mutex) DosRequestMutexSem(ws->mutex, INFINITE_WAIT); }
#define MutexOff(ws) {if (ws->mutex) DosReleaseMutexSem(ws->mutex); }
#define MAKERGB(r,g,b) ((ULONG)(((r) << 16) | ((g) << 8) | (b)))
#define RGB16TO8(x) if ((x) > 0xff) (x) = (((x) >> 8) & 0xff)
#define AddPatternDependant(id)  AddLocalIdDependant((id))
#define ReleasePattern(id)  ReleaseLocalId((id))
#define AddFontDependant(id)  AddLocalIdDependant((id))
#define ReleaseFont(id)  ReleaseLocalId((id))
#define AddFontToWindow(ws, id) AddLocalIdToWindow((ws), (id))
#define AddPatternToWindow(ws, id) AddLocalIdToWindow((ws), (id))
#define hidecrsr(ws) { if ((ws)->hpsWin && ISCURSORONW(ws) &&  \
			     ws->hwnd == WinQueryFocus(HWND_DESKTOP)) \
			   WinShowCursor((ws)->hwnd, 0); \
			}
#define showcrsr(ws) { if ((ws)->hpsWin && ISCURSORONW(ws) && \
			     ws->hwnd == WinQueryFocus(HWND_DESKTOP)) \
			   WinShowCursor((ws)->hwnd, 1); \
		       }
#define FNTWIDTH(size) ((size) & 0xFFFF)
#define FNTHEIGHT(size) ((size) >> 16)
#define MAKEFNTSIZE(height, width) (((height) << 16) | (width))
#define WaitForEvent(msgnum, msgstruc) ObtainEvents(NULL, WAIT_EVT, msgnum, msgstruc)
#define pollevent() (ObtainEvents(NULL, NO_WAIT_EVT, 0, NULL), 400)
#define PMErrInit() { ConsoleFlags |= OutputToBuf; ConsoleStringBufPtr = ConsoleStringBuf; }

/*
 * "get" means remove them from the Icon list and put them on the ghost queue
 */
#define EVQUEGET(ws,d) { \
  int i;\
  if (!c_get((struct b_list *)BlkLoc((ws)->listp),&d)) fatalerr(0,NULL); \
  if (Qual(d)) {\
      ws->eventQueue[(ws)->eQfront++] = *StrLoc(d); \
      if ((ws)->eQfront >= EQUEUELEN) (ws)->eQfront = 0; \
      (ws)->eQback = (ws)->eQfront; \
      } \
  }
#define EVQUEEMPTY(ws) (BlkLoc((ws)->listp)->list.size == 0)
/*
 * the maximum number of messages to be queued by PM
 */
#define MAXMSGS  25

/*
 * Colors...
 */
#define CLR_LOCKED	1
#define CLR_USED	2
#define CLR_BASE	4
#define MAXCOLORNAME	64
#define DMAXCOLORS	256

/*
 * constant used to offset entries in global table *over* the standard colors
 */
typedef struct _CNODE {
  UCHAR 	bits;			 /* flags */
  int		refcount;		 /* reference count */
  ULONG 	rgb;			 /* the rgb component */
  char* 	name;			 /* color name */
  struct _CNODE *next, *previous;
  } colorEntry;

/*
 * we make the segment structure look like this so that we can
 * cast it to POINTL structures that can be passed to GpiPolyLineDisjoint
 */
typedef struct {
   LONG x1, y1;
   LONG x2, y2;
   } XSegment;

typedef POINTL XPoint;
typedef RECTL XRectangle;

typedef struct {
  LONG x, y;
  ARCPARAMS arcp;
  double angle1, angle2;
  } XArc;

/*
 * some macros that used to be functions
 */
#define AddColorDependant(indx) \
   if (indx >= 0 && indx < MaxPSColors && (ColorTable[indx].bits & CLR_USED))\
      ColorTable[indx].refcount++;

/* don't map 0 cause that is LCID_DEFAULT */
#define AddLocalIdDependant(id) { \
   LONG newid = id - 1; \
   if (newid >= 0 && newid < MAXLOCALS) LocalIds[newid].refcount++; \
   }

/*
 * Macros to ease coding in which every X call must be done twice.
 */
#define RENDER1(func,v1) {\
   if (ws->hpsWin) func(ws->hpsWin, v1); \
   func(ws->hpsBitmap, v1);}
#define RENDER2(func,v1,v2) {\
   if (ws->hpsWin) func(ws->hpsWin, v1, v2); \
   func(ws->hpsBitmap, v1, v2);}
#define RENDER3(func,v1,v2,v3) {\
   if (ws->hpsWin) func(ws->hpsWin, v1, v2, v3); \
   func(ws->hpsBitmap, v1, v2, v3);}
#define RENDER4(func,v1,v2,v3,v4) {\
   if (ws->hpsWin) func(ws->hpsWin, v1, v2, v3, v4); \
   func(ws->hpsBitmap, v1, v2, v3, v4);}
#define RENDER5(func,v1,v2,v3,v4,v5) {\
   if (ws->hpsWin) func(ws->hpsWin, v1, v2, v3, v4, v5); \
   func(ws->hpsBitmap, v1, v2, v3, v4, v5);}

/* Try to speed some things up */
#define SetAreaContext(wb, ws, wc) { \
   SetClipContext((wb), (ws), (wc)); \
   if ((ws)->areaContext != wc) { \
     if ((ws)->hpsWin) \
       GpiSetAttrs((ws)->hpsWin, PRIM_AREA, areaAttrs, 0UL, &((wc)->areaBundle)); \
      GpiSetAttrs((ws)->hpsBitmap, PRIM_AREA, areaAttrs, 0UL, &((wc)->areaBundle)); \
      (ws)->areaContext = wc; \
      } /* End of if - we are not already loaded */ \
   }

#define SetLineContext(wb, ws, wc) { \
   SetClipContext((wb), (ws), (wc)); \
   if (ws->lineContext != wc) { \
     if ((ws)->hpsWin) \
       GpiSetAttrs((ws)->hpsWin, PRIM_LINE, lineAttrs, 0UL, &((wc)->lineBundle)); \
      GpiSetAttrs((ws)->hpsBitmap, PRIM_LINE, lineAttrs, 0UL, &((wc)->lineBundle)); \
      (ws)->lineContext = wc; \
      } /* End of if - we are not already loaded */ \
   }

#define SetImageContext(wb, ws, wc) { \
   SetClipContext((wb), (ws), (wc)); \
   if (ws->imageContext != wc) { \
     if ((ws)->hpsWin) \
       GpiSetAttrs((ws)->hpsWin, PRIM_IMAGE, imageAttrs, 0UL, &((wc)->imageBundle)); \
      GpiSetAttrs((ws)->hpsBitmap, PRIM_IMAGE, imageAttrs, 0UL, &((wc)->imageBundle)); \
      (ws)->imageContext = wc; \
      } /* End of if - we are not already loaded */ \
   }

#define SetCharContext(wb, ws, wc) { \
   PCURSORINFO _ptr; \
   SetClipContext((wb), (ws), (wc)); \
   if (ws->charContext != wc) { \
     if ((ws)->hpsWin) { \
       GpiSetAttrs((ws)->hpsWin, PRIM_CHAR, charAttrs, 0UL, &((wc)->charBundle)); \
       /* update the cursor */ \
       _ptr = &(ws->cursInfo); \
       _ptr->cx = wc->font->metrics.lAveCharWidth; \
       _ptr->x = ws->x + wc->dx; \
       _ptr->y = ws->height - (ws->y + wc->dy); \
       if (ISCURSORONW(ws) && ws->hwnd == WinQueryFocus(HWND_DESKTOP)) \
	 WinCreateCursor(ws->hwnd, _ptr->x, _ptr->y, _ptr->cx, \
			 _ptr->cy, CURSOR_SETPOS|CURSOR_FLASH, NULL); \
       } /* End of if - ws has a window */ \
      GpiSetAttrs((ws)->hpsBitmap, PRIM_CHAR, charAttrs, 0UL, &((wc)->charBundle)); \
      (ws)->charContext = wc; \
      /* set the font descender value used when the window is resized */ \
      (ws)->lastDescender = (wc)->font->metrics.lMaxDescender; \
      } /* End of if - we are not already loaded */ \
   }

/*
#undef SetAreaContext
#undef SetLineContext
#undef SetImageContext
#undef SetCharContext

#define SetAreaContext(a,b,c)
#define SetLineContext(a,b,c)
#define SetImageContext(a,b,c)
#define SetCharContext(a,b,c)
*/

#define UnsetCharContext(wc)  UnsetContext(wc, UCharContext);
#define UnsetLineContext(wc)  UnsetContext(wc, ULineContext);
#define UnsetImageContext(wc) UnsetContext(wc, UImageContext);
#define UnsetAreaContext(wc) UnsetContext(wc, UAreaContext);
#define UnsetClipContext(wc) UnsetContext(wc, UClipContext);
#define UnsetAllContext(wc) UnsetContext(wc, UAllContext);

/*
 * macros performing row/column to pixel y,x translations
 * computation is 1-based and depends on the current font's size.
 * exception: XTOCOL as defined is 0-based, because that's what its
 * clients seem to need.
 */
#define ROWTOY(wb, row)  ((row - 1) * (LEADING(wb) + FHEIGHT(wb)) + ASCENT(wb))
#define COLTOX(wb, col)  ((col - 1) * FWIDTH(wb))
#define YTOROW(wb, y)	 ((y) /  (LEADING(wb) + FHEIGHT(wb)) + 1)
#define XTOCOL(wb, x)	 ((x) / FWIDTH(wb))
/*
 * system size values
 */
#define BORDERWIDTH	 (WinQuerySysValue(HWND_DESKTOP, SV_CXSIZEBORDER))
#define BORDERHEIGHT	 (WinQuerySysValue(HWND_DESKTOP, SV_CYSIZEBORDER))
#define TITLEHEIGHT	 (WinQuerySysValue(HWND_DESKTOP, SV_CYTITLEBAR))
#endif					/* PresentationManager */
