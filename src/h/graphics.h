/*
 * graphics.h - macros and types used in Icon's graphics interface.
 */

#define MAXDISPLAYNAME  128

#ifdef MacGraph
   #include "::h:macgraph.h"
#endif                                  /* MacGraph */

#ifdef XWindows
   #include "../h/xwin.h"
#endif                                  /* XWindows */

#ifdef MSWindows
   #include "../h/mswin.h"
#endif                                  /* MSWindows */

#if Graphics3D || GraphicsGL
#if HAVE_LIBGL
#include "../h/opengl.h"
#else                                   /* HAVE_LIBGL */
#include "../h/direct3d.h"
#endif                                  /* HAVE_LIBGL */

/*
 * # of POLL_INTERVAL intervals for determining OpenGL 2D graphics refresh rate
 * (see pollevent())
 */
#define FLUSH_POLL_INTERVAL 10

#define REDRAW_CUBE             0x010
#define REDRAW_CYLINDER         0x020
#define REDRAW_DISK             0x030
#define REDRAW_LINE             0x040
#define REDRAW_POINT            0x050
#define REDRAW_POLYGON          0x060
#define REDRAW_SEGMENT          0x070
#define REDRAW_SPHERE           0x080
#define REDRAW_TORUS            0x090
#define REDRAW_FG               0x0A0
#define REDRAW_FILLPOLYGON      0x0B0
#define REDRAW_IDENTITY         0x0C0
#define REDRAW_MATRIXMODE       0x0D0
#define REDRAW_POPMATRIX        0x0E0
#define REDRAW_PUSHMATRIX       0x0F0
#define REDRAW_ROTATE           0x100
#define REDRAW_SCALE            0x110
#define REDRAW_TEXTURE          0x120
#define REDRAW_TEXCOORD         0x130
#define REDRAW_TRANSLATE        0x140
#define REDRAW_DIM              0x150
#define REDRAW_LINEWIDTH        0x160
#define REDRAW_TEXMODE          0x170
#define REDRAW_FONT3D           0x180
#define REDRAW_DRAWSTRING3D     0x190
#define REDRAW_MARK             0x1A0
#define REDRAW_ENDMARK          0x1B0
#define REDRAW_MESHMODE         0x1C0
#define REDRAW_PICK             0x1D0
#define REDRAW_MULTMATRIX       0x1E0
#define REDRAW_NORMALS          0x1F0
#define REDRAW_NORMODE          0x200
#define REDRAW_SLICES           0x210
#define REDRAW_RINGS            0x220

/* aliases for better comprehension */
#define GL3D_CUBE       REDRAW_CUBE
#define GL3D_CYLINDER   REDRAW_CYLINDER
#define GL3D_DISK       REDRAW_DISK
#define GL3D_SPHERE     REDRAW_SPHERE
#define GL3D_TORUS      REDRAW_TORUS
#define GL3D_IDENTITY   REDRAW_IDENTITY
#define GL3D_MATRIXMODE REDRAW_MATRIXMODE
#define GL3D_POPMATRIX  REDRAW_POPMATRIX
#define GL3D_PUSHMATRIX REDRAW_PUSHMATRIX
#define GL3D_ROTATE     REDRAW_ROTATE
#define GL3D_SCALE      REDRAW_SCALE
#define GL3D_TEXTURE    REDRAW_TEXTURE
#define GL3D_TRANSLATE  REDRAW_TRANSLATE
#define GL3D_FONT       REDRAW_FONT3D
#define GL3D_DRAWSTRING REDRAW_DRAWSTRING3D
#define GL3D_MARK       REDRAW_MARK
#define GL3D_ENDMARK    REDRAW_ENDMARK
#define GL3D_MESHMODE   REDRAW_MESHMODE

#endif                                  /* Graphics3D || GraphicsGL */

#ifndef MAXXOBJS
   #define MAXXOBJS 256
#endif                                  /* MAXXOBJS */

#ifndef DMAXCOLORS
   #define DMAXCOLORS 256
#endif                                  /* DMAXCOLORS */

#ifndef MAXCOLORNAME
   #define MAXCOLORNAME 40
#endif                                  /* MAXCOLORNAME */

#ifndef MAXFONTWORD
   #define MAXFONTWORD 40
#endif                                  /* MAXFONTWORD */

#define DEFAULTFONTSIZE 14

#define FONTATT_SPACING         0x01000000
#define FONTFLAG_MONO           0x00000001
#define FONTFLAG_PROPORTIONAL   0x00000002

#define FONTATT_SERIF           0x02000000
#define FONTFLAG_SANS           0x00000004
#define FONTFLAG_SERIF          0x00000008

#define FONTATT_SLANT           0x04000000
#define FONTFLAG_ROMAN          0x00000010
#define FONTFLAG_ITALIC         0x00000020
#define FONTFLAG_OBLIQUE        0x00000040

#define FONTATT_WEIGHT          0x08000000
#define FONTFLAG_LIGHT          0x00000100
#define FONTFLAG_MEDIUM         0x00000200
#define FONTFLAG_DEMI           0x00000400
#define FONTFLAG_BOLD           0x00000800

#define FONTATT_WIDTH           0x10000000
#define FONTFLAG_CONDENSED      0x00001000
#define FONTFLAG_NARROW         0x00002000
#define FONTFLAG_NORMAL         0x00004000
#define FONTFLAG_WIDE           0x00008000
#define FONTFLAG_EXTENDED       0x00010000

#define FONTATT_CHARSET         0x20000000
#define FONTFLAG_LATIN1         0x00020000
#define FONTFLAG_LATIN2         0x00040000
#define FONTFLAG_CYRILLIC       0x00080000
#define FONTFLAG_ARABIC         0x00100000
#define FONTFLAG_GREEK          0x00200000
#define FONTFLAG_HEBREW         0x00400000
#define FONTFLAG_LATIN6         0x00800000

#define FONT_OUTLINE            0x00000001
#define FONT_POLYGON            0x00000002
#define FONT_TEXTURE            0x00000003
#define FONT_BITMAP             0x00000004
#define FONT_PIXMAP             0x00000005
#define FONT_EXTRUDE            0x00000006

/*
 * EVENT HANDLING
 *
 * Each window keeps an associated queue of events waiting to be
 * processed.  The queue consists of <eventcode,x,y> triples,
 * where eventcodes are strings for normal keyboard events, and
 * integers for mouse and special keystroke events.
 *
 * The main queue is an icon list.  In addition, there is a queue of
 * old keystrokes maintained for cooked mode operations, maintained
 * in a little circular array of chars.
 */
#define EQ_MOD_CONTROL (1L<<16L)
#define EQ_MOD_META    (1L<<17L)
#define EQ_MOD_SHIFT   (1L<<18L)

#define EVQUESUB(w,i) *evquesub(w,i)
#define EQUEUELEN 256

/*
 * mode bits for the Icon window context (as opposed to X context)
 */

#define ISINITIAL(w)    ((w)->window->bits & 1)
#define ISINITIALW(ws)   ((ws)->bits & 1)
#define ISCURSORON(w)   ((w)->window->bits & 2)
#define ISCURSORONW(ws) ((ws->bits) & 2)
/* bit 4 is available */
#define ISREVERSE(w)    ((w)->context->bits & 8)
#define ISXORREVERSE(w) ((w)->context->bits & 16)
#define ISXORREVERSEW(w) ((w)->bits & 16)
#define ISCLOSED(w)     ((w)->window->bits & 64)
#define ISRESIZABLE(w)  ((w)->window->bits & 128)
#define ISEXPOSED(w)    ((w)->window->bits & 256)
#define ISCEOLON(w)     ((w)->window->bits & 512)
#define ISECHOON(w)     ((w)->window->bits & 1024)

#define SETCURSORON(w)  ((w)->window->bits |= 2)
/* bit 4 is available */
#define SETREVERSE(w)   ((w)->context->bits |= 8)
#define SETXORREVERSE(w) ((w)->context->bits |= 16)
#define SETCLOSED(w)    ((w)->window->bits |= 64)
#define SETRESIZABLE(w) ((w)->window->bits |= 128)
#define SETEXPOSED(w)   ((w)->window->bits |= 256)
#define SETCEOLON(w)    ((w)->window->bits |= 512)
#define SETECHOON(w)    ((w)->window->bits |= 1024)

#define CLRCURSORON(w)  ((w)->window->bits &= ~2)
/* bit 4 is available */
#define CLRREVERSE(w)   ((w)->context->bits &= ~8)
#define CLRXORREVERSE(w) ((w)->context->bits &= ~16)
#define CLRCLOSED(w)    ((w)->window->bits &= ~64)
#define CLRRESIZABLE(w) ((w)->window->bits &= ~128)
#define CLREXPOSED(w)   ((w)->window->bits &= ~256)
#define CLRCEOLON(w)    ((w)->window->bits &= ~512)
#define CLRECHOON(w)    ((w)->window->bits &= ~1024)

#ifdef XWindows
#define ISZOMBIE(w)     ((w)->window->bits & 1)
#define SETZOMBIE(w)    ((w)->window->bits |= 1)
#define CLRZOMBIE(w)    ((w)->window->bits &= ~1)
#endif                                  /* XWindows */

#ifdef MSWindows
#define ISTOBEHIDDEN(ws)  ((ws)->bits & 4096)
#define SETTOBEHIDDEN(ws)  ((ws)->bits |= 4096)
#define CLRTOBEHIDDEN(ws)  ((ws)->bits &= ~4096)
#endif                                  /* MSWindows */

#define ISTITLEBAR(ws) ((ws)->bits & 8192)
#define SETTITLEBAR(ws) ((ws)->bits |= 8192)
#define CLRTITLEBAR(ws) ((ws)->bits &= ~8192)


/*
 * Window Resources
 * Icon "Resources" are a layer on top of the window system resources,
 * provided in order to facilitate resource sharing and minimize the
 * number of calls to the window system.  Resources are reference counted.
 * These data structures are simple sets of pointers
 * into internal window system structures.
 */



/*
 * Fonts are allocated within displays.
 */
typedef struct _wfont {
  int           refcount;
  int           serial;                 /* serial # */
  struct _wfont *previous, *next;
  char          type;
  int           size;
  void          *fonts;
#ifdef MacGraph
  short     fontNum;
  Style     fontStyle;
  int       fontSize;
  FontInfo  fInfo;                      /* I-173 */
#endif                                  /* MacGraph */
#ifdef XWindows
  char        * name;                   /* name for WAttrib and fontsearch */
  int           ascent;                 /* font dimensions */
  int           descent;
  int           height;
  int           maxwidth;               /* max width of one char */
#ifdef HAVE_XFT
  XftFont     * fsp;
#else                                   /* HAVE_XFT */
  XFontStruct * fsp;                    /* X font pointer */
#endif                                  /* HAVE_XFT */
#endif                                  /* XWindows */
#ifdef MSWindows
  char          *name;                  /* name for WAttrib and fontsearch */
  HFONT         font;
  LONG          ascent;
  LONG          descent;
  LONG          charwidth;
  LONG          height;
#endif                                  /* MSWindows */
#ifdef GraphicsGL
#if HAVE_LIBFREETYPE
  FT_Library    library;
  FT_Face       face;
#endif                                  /* HAVE_LIBFREETYPE */
  struct fontsymbol chars[256];
#endif                                  /* GraphicsGL */
} wfont, *wfp;

/*
 * These structures and definitions are used for colors and images.
 */
typedef struct {
   long red, green, blue;               /* color components, linear 0 - 65535*/
   } LinearColor;

struct palentry {                       /* entry for one palette member */
   LinearColor clr;                     /* RGB value of color */
   char used;                           /* nonzero if char is used */
   char valid;                          /* nonzero if entry is valid & opaque */
   char transpt;                        /* nonzero if char is transparent */
   };

/*
 * Color formats to be used with imgdata
 */
#define UCOLOR_RGB   1
#define UCOLOR_BGR   2

struct imgdata {                        /* image loaded from a file */
   int width, height;                   /* image dimensions */
   int format;
   int is_bottom_up;
   struct palentry *paltbl;             /* pointer to palette table */
   unsigned char *data;                 /* pointer to image data */
   };

struct imgmem {
   int x, y, width, height;
#ifdef GraphicsGL
   unsigned short *pixmap;
#endif                                  /* GraphicsGL */
#ifdef XWindows
   XImage *im;
#endif                                  /* XWindows */
#ifdef MSWindows
   COLORREF *crp;
#endif                                  /* MSWindows */
   };

#define TCH1 '~'                        /* usual transparent character */
#define TCH2 0377                       /* alternate transparent character */
#define PCH1 ' '                        /* punctuation character */
#define PCH2 ','                        /* punctuation character */


#ifdef MacGraph
typedef struct _wctype {
   Pattern bkPat;
   Pattern fillPat;
   Point pnLoc;
   Point pnSize;
   short pnMode;
   Pattern pnPat;
   short txFont;
   Style txFace;
   short txMode;
   short txSize;
   Fixed spExtra;
   RGBColor fgColor;
   RGBColor bgColor;
} ContextType, *ContextPtrType;
#endif                                  /* MacGraph */


/*
 * Texture management requires that we be able to lookup and reuse
 * existing textures, as well as support dynamic window-based textures.
 */
#ifdef Graphics3D

#define INITTEXTURENUM 64

typedef struct _wtexture {
   int          refcount;
   int          serial;                 /* serial # */

   int width, height;
   struct _wbinding *w;

  struct _wtexture *previous, *next;

   int          textype;        /* 1 = file, 2 = window (descrip), 3 = string*/
   struct descrip d;
   struct {                     /* if type = 1, we store file attributes */
      int           size;
      int          timestamp;
      } fattr;

#if HAVE_LIBGL
   GLubyte *tex;
   GLuint texName;                      /* GL texture name*/
#endif

   } wtexture, *wtp;
#endif                                  /* Graphics3D */


/*
 * Displays are maintained in a global list in rwinrsc.r.
 */
typedef struct _wdisplay {
  int           refcount;
  int           serial;                 /* serial # */
  int           numFonts;

#ifdef MSWindows
  char          name[MAXDISPLAYNAME];
#endif                                  /* MSWindows*/

#ifdef XWindows
  char          name[MAXDISPLAYNAME];
  Display *     display;
  GC            icongc;
  Colormap      cmap;
#ifdef GraphicsGL
  int           nConfigs;
  GLXFBConfig   *configs;
  XVisualInfo   *vis;
  GLXContext    sharedCtx;              /* shared context for texture sharing */
  GLXContext    currCtx;                /* keeps track of current context */
#endif                                  /* GraphicsGL */
#ifdef HAVE_XFT
  XFontStruct   *xfont;
#endif                                  /* HAVE_XFT */
  Cursor        cursors[NUMCURSORSYMS];
  int           numColors;              /* allocated color info */
  int           sizColors;              /* # elements of alloc. color array */
  struct wcolor *colors;
  int           screen;
  wfp           fonts;
  int           buckets[16384];         /* hash table for quicker lookups */
#endif                                  /* XWindows */
#ifdef GraphicsGL
  unsigned int  stdPatTexIds[16];       /* array of std pattern texture ids */
  unsigned int  *texIds;
  unsigned int  numTexIds;
  unsigned int  maxTexIds;
  wfp           glfonts;                /* For OpenGL & X11 to live happily together */
  int           numMclrs;
  int           muteIdCount;
  struct color *mclrs;
#endif                                  /* GraphicsGL */
#ifdef Graphics3D

  int ntextures;                        /* # textures actually used */
  int nalced;                           /* number allocated */
  wtp stex;
  int maxstex;
#endif                                  /* Graphics3D */
  double        gamma;
  struct _wdisplay *previous, *next;
} *wdp;

/*
 * "Context" comprises the graphics context, and the font (i.e. text context).
 * Foreground and background colors (pointers into the display color table)
 * are stored here to reduce the number of window system queries.
 * Contexts are allocated out of a global array in rwinrsrc.c.
 */
typedef struct _wcontext {
  int           refcount;
  int           serial;                 /* serial # */
  struct _wcontext *previous, *next;
  int           clipx, clipy, clipw, cliph;
  char          *patternname;
  wfp           font;
  int           dx, dy;
  int           fillstyle;
  int           drawop;
  int           rgbmode;                /* 0=auto, 1=24, 2=48, 3=norm */
  double        gamma;                  /* gamma correction value */
  int           bits;                   /* context bits */

#ifdef GraphicsGL
  struct color  glfg, glbg;
  int           reverse;
  double        alpha;
  int           linestyle;
  int           linewidth;
  int           leading;                /* inter-line leading */
#endif                                  /* GraphicsGL */

#ifdef MacGraph
  ContextPtrType   contextPtr;
#endif                                  /* MacGraph */
  wdp           display;
#ifdef XWindows
  GC            gc;                     /* X graphics context */
  int           fg, bg;
#ifndef GraphicsGL
  int           linestyle;
  int           linewidth;
  int           leading;                /* inter-line leading */
#endif                                  /* GraphicsGL */
#endif                                  /* XWindows */
#ifdef MSWindows
  LOGPEN        pen;
  LOGPEN        bgpen;
  LOGBRUSH      brush;
  LOGBRUSH      bgbrush;
  HRGN          cliprgn;
  HBITMAP       pattern;
  SysColor      fg, bg;
  char          *fgname, *bgname;
#ifdef GraphicsGL
  int           bkmode;
#else                                   /* GraphicsGL */
  int           leading, bkmode;
#endif                                  /* GraphicsGL */
#endif                                  /* MSWindows*/

#ifdef Graphics3D
  int           dim;                    /* # of coordinates per vertex */
  int           rendermode;                     /* flag for 3D windows */
  char          buffermode;             /* 3D buffering flag */
  char          meshmode;               /* fillpolygon mesh mode */

  int           slices;                 /* slices and rings for level of */
  int           rings;                  /* detail sphere etal to be drawn */

/* selection parameters   */
  int           selectionenabled;       /* selection is enabled */
  int           selectionrendermode;    /* selection code should be executed */
  int           selectionavailablename; /* what int code to use for OpenGL name  */
  char **       selectionnamelist;      /* all of the current used names  */
  int           selectionnamecount;     /* how many - used so far   */
  int           selectionnamelistsize;  /* current available size  */
  int           app_use_selection3D;    /* the application uses 3D selection */

  struct b_realarray  *normals;         /* vertex normals data */

  int           normode;                /* normals on, off or auto */
  int           numnormals;           /* # of normals used */

  int           autogen;  /* flag to automatically generate texture coordinate */
  int           texmode;    /* textures on or off */
  int           numtexcoords;           /* # of texture coordinates used */
  struct b_realarray  *texcoords;             /* texture coordinates */

  int curtexture;                       /* subscript of current texture */
#endif                                  /* Graphics3D */
} wcontext, *wcp;

/*
 * Native facilities include the following child controls (windows) that
 * persist on the canvas and intercept various events.
 */
#ifdef MSWindows
#define CHILD_BUTTON 0
#define CHILD_SCROLLBAR 1
#define CHILD_EDIT 2
typedef struct childcontrol {
   int  type;                           /* what kind of control? */
   HWND win;                            /* child window handle */
   HFONT font;
   char *id;                            /* child window string id */
} childcontrol;
#endif                                  /* MSWindows */

/*
 *
 */

#define REAL_WSTATE     1
#define SUBWIN_WSTATE   2
#define TEXTURE_WSTATE  4

#define CHILD_WIN2D      1
#define CHILD_WIN3D      2
#define CHILD_WINTEXTURE 3

#define TEXTURE_RECORD   1
#define TEXTURE_WINDOW   2

/*
 * This is the "canvas": it is also called a window state.
 * "Window state" includes the actual X window and references to a large
 * number of resources allocated on a per-window basis.  Windows are
 * allocated out of a global array in rwinrsrc.c.  Windows remember the
 * first WMAXCOLORS colors they allocate, and deallocate them on clearscreen.
 */
typedef struct _wstate {
  int           refcount;               /* reference count */
  int           serial;                 /* serial # */
  struct _wstate *previous, *next;

#ifdef Graphics3D
  int type;
  int texindex;
  double        eyeupx, eyeupy, eyeupz;    /* eye up vector */
  double        eyedirx, eyediry, eyedirz; /* eye direction vector */
  double        eyeposx, eyeposy, eyeposz; /* eye position */
  double        fov;            /* field of view angle */
#endif                                  /* Graphics3D */

  int           inputmask;              /* user input mask */
  int           pixheight;              /* backing pixmap height, in pixels */
  int           pixwidth;               /* pixmap width, in pixels */
  char          *windowlabel;           /* window label */
  char          *iconimage;             /* icon pixmap file name */
  char          *iconlabel;             /* icon label */
  struct imgdata initimage;             /* initial image data */
  struct imgdata initicon;              /* initial icon image data */
  int           y, x;                   /* current cursor location, in pixels*/
  int           pointery,pointerx;      /* current mouse location, in pixels */
  int           posy, posx;             /* desired upper lefthand corner */
  int           real_posx, real_posy;   /* real (canvas=normal) position */
  unsigned int  height;                 /* window height, in pixels */
  unsigned int  width;                  /* window width, in pixels */
  unsigned int  minheight;              /* minimum window height, in pixels */
  unsigned int  minwidth;               /* minimum window width, in pixels */
  int           bits;                   /* window bits */
  int           theCursor;              /* index into cursor table */
  word          timestamp;              /* last event time stamp */
  char          eventQueue[EQUEUELEN];  /* queue of cooked-mode keystrokes */
  int           eQfront, eQback;
  char          *cursorname;
  struct descrip filep, listp;          /* icon values for this window */
  struct wbind_list *children;
  struct _wbinding *parent;
#ifdef MacGraph
  WindowPtr theWindow;      /* pointer to the window */
  PicHandle windowPic;      /* handle to backing pixmap */
  GWorldPtr offScreenGWorld;  /* offscreen graphics world */
  CGrafPtr   origPort;
  GDHandle  origDev;
  PixMapHandle offScreenPMHandle;
  Rect      sourceRect;
  Rect      destRect;
  Rect      GWorldRect;
  Boolean   lockOK;
  Boolean   visible;
#endif                                  /* MacGraph */
  wdp           display;

#ifdef GraphicsGL
#ifdef XWindows
  GLXContext    ctx;                    /* context for "gl" windows */
  GLXPbuffer    pbuf;                   /* offscreen render surface */
#endif                                  /* XWindows */
#ifdef MSWindows
  HGLRC ctx;
#endif                                  /* MSWindows */

  struct _wcontext wcrender, wcdef;     /* render & default/init contexts */
  int           lastwcserial;           /* remembers the last context used */
  unsigned char updateRC;               /* render context flag, default:0 */
  unsigned char initAttrs;              /* initialize attribs falg, default:0 */
  unsigned char resize;                 /* window resize flag */
  unsigned char is_gl;                  /* flag for coexisting with Xlib */
  unsigned char dx_flag, dy_flag;
  unsigned char stencil_mask;           /* bitmask for stencil buffer */
  int           rendermode;             /* 2D/3D rendering attrib */
  int           projection;             /* viewing volume projection attrib */
  double        camwidth;               /* viewing volume cam width attrib */
#endif                                  /* GraphicsGL */


#ifdef XWindows
  Window        win;                    /* X window */
  Pixmap        pix;                    /* current screen state */
  Pixmap        initialPix;             /* an initial image to display */
  Window        iconwin;                /* icon window */
  Pixmap        iconpix;                /* icon pixmap */
  Visual        *vis;
#ifdef HAVE_XFT
  XftDraw       *winDraw,*pixDraw;
#endif                                  /* HAVE_XFT */
  int           normalx, normaly;       /* pos to remember when maximized */
  int           normalw, normalh;       /* size to remember when maximized */
  int           numColors;              /* allocated (used) color info */
  int           sizColors;              /* malloced size of theColors */
  short         *theColors;             /* indices into display color table */
  int           numiColors;             /* allocated color info for the icon */
  int           siziColors;             /* malloced size of iconColors */
  short         *iconColors;            /* indices into display color table */
  char *selectiondata;
  int           iconic;                 /* window state; icon, window or root*/
  int           iconx, icony;           /* location of icon */
  unsigned int  iconw, iconh;           /* width and height of icon */
  long          wmhintflags;            /* window manager hints */
#endif                                  /* XWindows */
#ifdef MSWindows
  HWND          win;                    /* client window */
  HWND          iconwin;                /* client window when iconic */
  HBITMAP       pix;                    /* backing bitmap */
  HBITMAP       iconpix;                /* backing bitmap */
  HBITMAP       initialPix;             /* backing bitmap */
  HBITMAP       theOldPix;
  int           hasCaret;
  HCURSOR       curcursor;
  HCURSOR       savedcursor;
  HMENU         menuBar;
  int           nmMapElems;
  char **       menuMap;
  HWND          focusChild;
  int           nChildren;
  childcontrol *child;
#endif                                  /* MSWindows */
#ifdef Graphics3D
  int            is_3D;        /* flag for 3D windows */
  struct descrip funclist;    /* descriptor to hold list of 3d functions */
#endif                                  /* Graphics3D */
#ifdef GraphicsGL
  struct descrip funclist2d;  /* descriptor to hold list of 2d functions */
  unsigned char redraw_flag;
  unsigned char busy_flag;
  unsigned char buffermode;
#endif                                  /* GraphicsGL */
  int            no;          /* new field added for child windows */
} wstate, *wsp;

/*
 * Icon window file variables are actually pointers to "bindings"
 * of a window and a context.  They are allocated out of a global
 * array in rwinrsrc.c.  There is one binding per Icon window value.
 */
typedef struct _wbinding {
  int refcount;
  int serial;
  struct _wbinding *previous, *next;
  wcp context;
  wsp window;
} wbinding, *wbp;

struct wbind_list {
  struct _wbinding *child;
  struct wbind_list *next;
};

#ifdef MacGraph
typedef struct
   {
   Boolean wasDown;
   uword when;
   Point where;
   int whichButton;
   int modKey;
   wsp ws;
   } MouseInfoType;
#endif                                  /* MacGraph */



/*
 * Gamma Correction value to compensate for nonlinear monitor color response
 */
#ifndef GammaCorrection
#define GammaCorrection 2.5
#endif                                  /* GammaCorrection */

/*
 * Attributes
 */

#define A_ASCENT        1
#define A_BG            2
#define A_CANVAS        3
#define A_CEOL          4
#define A_CLIPH         5
#define A_CLIPW         6
#define A_CLIPX         7
#define A_CLIPY         8
#define A_COL           9
#define A_COLUMNS       10
#define A_CURSOR        11
#define A_DEPTH         12
#define A_DESCENT       13
#define A_DISPLAY       14
#define A_DISPLAYHEIGHT 15
#define A_DISPLAYWIDTH  16
#define A_DRAWOP        17
#define A_DX            18
#define A_DY            19
#define A_ECHO          20
#define A_FG            21
#define A_FHEIGHT       22
#define A_FILLSTYLE     23
#define A_FONT          24
#define A_FWIDTH        25
#define A_GAMMA         26
#define A_GEOMETRY      27
#define A_HEIGHT        28
#define A_ICONIC        29
#define A_ICONIMAGE     30
#define A_ICONLABEL     31
#define A_ICONPOS       32
#define A_IMAGE         33
#define A_INPUTMASK     34
#define A_LABEL         35
#define A_LEADING       36
#define A_LINES         37
#define A_LINESTYLE     38
#define A_LINEWIDTH     39
#define A_PATTERN       40
#define A_POINTERCOL    41
#define A_POINTERROW    42
#define A_POINTERX      43
#define A_POINTERY      44
#define A_POINTER       45
#define A_POS           46
#define A_POSX          47
#define A_POSY          48
#define A_RESIZE        49
#define A_REVERSE       50
#define A_RGBMODE       51
#define A_ROW           52
#define A_ROWS          53
#define A_SIZE          54
#define A_VISUAL        55
#define A_WIDTH         56
#define A_WINDOWLABEL   57
#define A_X             58
#define A_Y             59
#define A_SELECTION     60

/* 3D attributes */
#define A_DIM           61
#define A_EYE           62
#define A_EYEPOS        63
#define A_EYEDIR        64
#define A_EYEUP         65
#define A_LIGHT         66
#define A_LIGHT0        67
#define A_LIGHT1        68
#define A_LIGHT2        69
#define A_LIGHT3        70
#define A_LIGHT4        71
#define A_LIGHT5        72
#define A_LIGHT6        73
#define A_LIGHT7        74
#define A_TEXTURE       75
#define A_TEXMODE       76
#define A_TEXCOORD      77

#define A_TITLEBAR      78
#define A_BUFFERMODE    79
#define A_MESHMODE      80
#define A_SLICES        81
#define A_RINGS         82
#define A_PICK          83
#define A_NORMODE       84
#define A_FOV           85
#define A_GLVERSION     86
#define A_GLVENDOR      87
#define A_GLRENDERER    88
#define A_ALPHA         89
#define A_RENDERMODE    90
#define A_PROJECTION    91
#define A_CAMWIDTH      92

#define NUMATTRIBS      92

#define XICONSLEEP      20 /* milliseconds */
