/*
 * sdlwin.h - macros and types used in the SDL graphics interface.
 *
 * The SDL backend draws into a software canvas (ucanvas.h) and shows it
 * through a thin SDL3 window layer (usdlwin.h).  The names below are the
 * ones the window-system independent code expects; most mirror xwin.h.
 */
#ifdef SDLGraphics

#include "../h/ucanvas.h"
#include "../h/usdlwin.h"

#define DRAWOP_AND                      UC_OP_AND
#define DRAWOP_ANDINVERTED              UC_OP_ANDINVERTED
#define DRAWOP_ANDREVERSE               UC_OP_ANDREVERSE
#define DRAWOP_CLEAR                    UC_OP_CLEAR
#define DRAWOP_COPY                     UC_OP_COPY
#define DRAWOP_COPYINVERTED             UC_OP_COPYINVERTED
#define DRAWOP_EQUIV                    UC_OP_EQUIV
#define DRAWOP_INVERT                   UC_OP_INVERT
#define DRAWOP_NAND                     UC_OP_NAND
#define DRAWOP_NOOP                     UC_OP_NOOP
#define DRAWOP_NOR                      UC_OP_NOR
#define DRAWOP_OR                       UC_OP_OR
#define DRAWOP_ORINVERTED               UC_OP_ORINVERTED
#define DRAWOP_ORREVERSE                UC_OP_ORREVERSE
#define DRAWOP_REVERSE                  0x10
#define DRAWOP_SET                      UC_OP_SET
#define DRAWOP_XOR                      UC_OP_XOR

#define MAXCOLORNAME 40

#define TEXTWIDTH(w,s,n) uc_text_width((w)->context->font->uf, s, n)
#define SCREENDEPTH(w) 24
#define ASCENT(w) ((w)->context->font->ascent)
#define DESCENT(w) ((w)->context->font->descent)
#define LEADING(w) ((w)->context->leading)
#define FHEIGHT(w) ((w)->context->font->height)
#define FWIDTH(w) ((w)->context->font->maxwidth)
#define LINEWIDTH(w) ((w)->context->linewidth)
#define DISPLAYHEIGHT(w) sdl_displaysize(0)
#define DISPLAYWIDTH(w) sdl_displaysize(1)
#define FS_SOLID UC_FILL_SOLID
#define FS_STIPPLE UC_FILL_STIPPLED
#define FS_OPAQUESTIPPLE UC_FILL_OPAQUESTIPPLED
#define hidecrsr(x) /* noop */
#define UpdateCursorPos(x, y) /* noop */
#define showcrsr(x) /* noop */
#define SysColor unsigned long
#define RED(c) (((c) >> 16) & 0xFF)
#define GREEN(c) (((c) >> 8) & 0xFF)
#define BLUE(c) ((c) & 0xFF)
#define ARCWIDTH(arc) ((arc).width)
#define ARCHEIGHT(arc) ((arc).height)
#define RECX(rec) ((rec).x)
#define RECY(rec) ((rec).y)
#define RECWIDTH(rec) ((rec).width)
#define RECHEIGHT(rec) ((rec).height)
#define ANGLE(ang) (ang)
#define EXTENT(ang) (ang)
#define FULLARC (2 * Pi)
#define ISICONIC(w) ((w)->window->iconic == IconicState)
#define ISFULLSCREEN(w) (0)
#define ISROOTWIN(w) (0)
#define ISNORMALWINDOW(w) ((w)->window->iconic == NormalState)
#define ICONFILENAME(w) ((w)->window->iconimage)
#define ICONLABEL(w) ((w)->window->iconlabel)
#define WINDOWLABEL(w) ((w)->window->windowlabel)
#define MAXDESCENDER(w) DESCENT(w)

/*
 * Window states, kept in the iconic field of the window state.
 */
#define NormalState     1
#define IconicState     3
#define RootState       4
#define MaximizedState  5
#define HiddenState     6

/*
 * Input masks (the inputmask field of the window state) and
 * modifier bits passed to qevent().
 */
#define PointerMotionMask    (1L<<0)
#define KeyReleaseMask       (1L<<1)
#define WindowClosureMask    (1L<<2)

#define ControlMask          (1L << 16L)
#define Mod1Mask             (2L << 16L)
#define ShiftMask            (4L << 16L)

#define NUMCURSORSYMS       78

/* the value X11 computes from its sRGB (Xcms) conversion; keeps colors
 * the same as under the X11 backend */
#define GammaCorrection 2.276

/*
 * Geometry types used by the window-system independent code.
 */
typedef struct { int x, y; } XPoint;
typedef struct { int x1, y1, x2, y2; } XSegment;
typedef struct { int x, y, width, height; } XRectangle;
typedef struct {
   int x, y, width, height;
   double angle1, angle2;               /* radians, Unicon orientation */
   } XArc;

#ifdef Graphics3D
/*
 * ropengl.ri swaps buffers to show a frame; here the frame is copied
 * into the window's canvas.
 */
#define glXSwapBuffers(dpy, win) sdl_gl_swap(w)
#endif                                  /* Graphics3D */

/*
 * Colors recently asked for, by display value, for Pixel().
 */
#define SDLCOLORS 1024
#define SDLCOLORHASH(px) \
   ((unsigned int)(((px) & 0xFFFFFF) * 2654435761U) >> 22)
struct sdlcolor {
   unsigned int pixel;
   unsigned short r, g, b, used;
   };

#define STDLOCALS(w) \
   wcp wc = (w)->context; \
   wsp ws = (w)->window; \
   struct ucanvas *stdpix = ws->pix; \
   struct ucgc *stdgc = sdl_gc(w);

/*
 * "get" means remove them from the Icon list and put them on the ghost queue
 */
#define EVQUEGET(w,d) { \
   wsp ws = (w)->window; \
   if (!c_get((struct b_list *)BlkLoc(ws->listp),&d)) fatalerr(0,NULL); \
   if (Qual(d)) {\
      ws->eventQueue[ws->eQfront++] = *StrLoc(d); \
      if (ws->eQfront >= EQUEUELEN) ws->eQfront = 0; \
      ws->eQback = ws->eQfront; \
      } \
   }

#define EVQUEEMPTY(w) (BlkD((w)->window->listp,List)->size == 0)

/*
 * macros performing row/column to pixel y,x translations
 * computation is 1-based and depends on the current font's size.
 * exception: XTOCOL as defined is 0-based, because that's what its
 * clients seem to need.
 */
#define ROWTOY(w,row) ((row-1) * LEADING(w) + ASCENT(w))
#define COLTOX(w,col) ((col-1) * FWIDTH(w))
#define YTOROW(w,y)   ((y>0) ? ((y) / LEADING(w) + 1) : ((y) / LEADING(w)))
#define XTOCOL(w,x)  (!FWIDTH(w) ? (x) : ((x) / FWIDTH(w)))

#endif                                  /* SDLGraphics */
