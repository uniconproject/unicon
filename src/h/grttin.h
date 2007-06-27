/*
 * Group of include files for input to rtt.
 *   rtt reads these files for preprocessor directives and typedefs, but
 *   does not output any code from them.
 */
#include "../h/define.h"
#include "../h/config.h"
#include "../h/version.h"
#include "../h/monitor.h"

#ifndef NoTypeDefs
   #include "../h/typedefs.h"
#endif					/* NoTypeDefs */

/*
 * Macros that must be expanded by rtt.
 */

/*
 * Declaration for library routine.
 */
#begdef LibDcl(nm,n,pn)
   #passthru OpBlock(nm,n,pn,0)

   int O##nm(nargs,cargp)
   int nargs;
   register dptr cargp;
#enddef					/* LibDcl */

/*
 * Error exit from non top-level routines. Set tentative values for
 *   error number and error value; these errors will but put in
 *   effect if the run-time error routine is called.
 */
#begdef ReturnErrVal(err_num, offending_val, ret_val)
   do {
   t_errornumber = err_num;
   t_errorvalue = offending_val;
   t_have_val = 1;
   return ret_val;
   } while (0)
#enddef					/* ReturnErrVal */

#begdef ReturnErrNum(err_num, ret_val)
   do {
   t_errornumber = err_num;
   t_errorvalue = nulldesc;
   t_have_val = 0;
   return ret_val;
   } while (0)
#enddef					/* ReturnErrNum */

/*
 * Code expansions for exits from C code for top-level routines.
 */
#define Fail		return A_Resume
#define Return		return A_Continue

/*
 * RunErr encapsulates a call to the function err_msg, followed
 *  by Fail.  The idea is to avoid the problem of calling
 *  runerr directly and forgetting that it may actually return.
 */

#define RunErr(n,dp) do {\
   err_msg((int)n,dp);\
   Fail;\
   } while (0)

/*
 * Protection macro.
 */
#define Protect(notnull,orelse) do {if ((notnull)==NULL) orelse;} while(0)

/*
 * perform what amounts to "function inlining" of EVVal
 */
#begdef RealEVVal(value,event)
   do {
      if (is:null(curpstate->eventmask)) break;
      else if (!Testb((word)ToAscii(event), curpstate->eventmask)) break;
      MakeInt(value, &(curpstate->parent->eventval));
      if (!is:null(curpstate->valuemask) &&
	  (invaluemask(curpstate, event, &(curpstate->parent->eventval)) != Succeeded))
	 break;
      actparent(event);
   } while (0)
#enddef					/* RealEVVal */

#begdef EVVal(value,event)
#if event
   RealEVVal(value,event)
#endif
#enddef					/* EVVal */
#begdef EVValD(dp,event)
#if event
   do {
      if (is:null(curpstate->eventmask)) break;
      else if (!Testb((word)ToAscii(event), curpstate->eventmask)) break;
      curpstate->parent->eventval = *(dp);
      if (!is:null(curpstate->valuemask) &&
	  (invaluemask(curpstate, event, &(curpstate->parent->eventval)) != Succeeded))
	 break;
      actparent(event);
   } while (0)
#endif
#enddef					/* EVValD */
#begdef EVValX(bp,event)
#if event
   do {
      struct progstate *parent = curpstate->parent;
      if (is:null(curpstate->eventmask)) break;
      else if (!Testb((word)ToAscii(event), curpstate->eventmask)) break;
      parent->eventval.dword = D_Coexpr;
      BlkLoc(parent->eventval) = (union block *)(bp);
      if (!is:null(curpstate->valuemask) &&
	  (invaluemask(curpstate, event, &(curpstate->parent->eventval)) != Succeeded))
	 break;
      actparent(event);
   } while (0)
#endif
#enddef					/* EVValX */
#begdef EVVar(dp, e)
#if e
   do {
      if (!is:null(curpstate->eventmask) &&
         Testb((word)ToAscii(e), curpstate->eventmask)) {
            EVVariable(dp, e);
	    }
   } while(0)
#endif
#enddef

#begdef InterpEVVal(value,event)
#if event
  { ExInterp; RealEVVal(value,event); EntInterp; }
#endif
#enddef
#begdef InterpEVValD(dp,event)
#if event
 { ExInterp; EVValD(dp,event); EntInterp; }
#endif
#enddef

/*
 * Macro with construction of event descriptor.
 */

#begdef Desc_EVValD(bp, code, type)
#if code
   do {
   eventdesc.dword = type;
   eventdesc.vword.bptr = (union block *)(bp);
   EVValD(&eventdesc, code);
   } while (0)
#endif
#enddef					/* Desc_EVValD */

typedef int pid_t;

/*
 * dummy typedefs for things defined in #include files
 */
typedef int clock_t, time_t, fd_set;

#if OS2_32
   typedef int HFILE, ULONG;
#endif					/* OS2_32 */

#if WildCards
   typedef int FINDDATA_T;
#endif					/* WildCards */

#ifdef ReadDirectory
   typedef int DIR;
#endif					/* ReadDirectory */

#ifdef Messaging
typedef int size_t;
typedef long time_t;
#endif					/* Messaging */

#ifdef FAttrib
typedef unsigned long mode_t;
#endif					/* FAttrib */

#if HAVE_LIBZ
typedef int gzFile;
#endif					/* HAVE_LIBZ */

#ifdef Messaging
typedef int MFile;
typedef int Tp_t;
typedef int Tpdisc_t;
typedef int Tpmethod_t;
typedef int Tpexcept_f;
typedef int Tprequest_t;
typedef int Tpresponse_t;
typedef int URI;
typedef int jmp_buf;
#endif                                  /* Messaging */

#if NT
typedef int HMODULE, WSADATA, WORD, HANDLE, MEMORYSTATUS;
#ifdef NTGCC
typedef int STARTUPINFO, PROCESS_INFORMATION, SECURITY_ATTRIBUTES;
#endif
#endif					/* NT */

#if HAVE_LIBJPEG
typedef int j_common_ptr, JSAMPARRAY, JSAMPROW;
#endif					/* HAVE_LIBJPEG */

#ifdef PosixFns
typedef int SOCKET;
typedef int u_short;
typedef int fd_set;
extern int amperErrno;
struct timeval {
   long    tv_sec;
   long    tv_usec;
};
typedef int time_t;
typedef int DIR;
#endif					/* PosixFns */

#ifdef Dbm
typedef int DBM;
typedef struct {
   char *dptr;
   int dsize;
} datum;
#endif					/* Dbm */

#ifdef ISQL                             /* ODBC */
  typedef int LPSTR, HENV, HDBC, HSTMT, ISQLFile, PTR, SQLPOINTER;
  typedef int SWORD, SDWORD, UWORD, UDWORD, UCHAR;
  typedef int SQLUSMALLINT, SQLSMALLINT, SQLHSTMT;
  typedef int SQLUINTEGER, SQLRETURN, RETCODE, SQLLEN;
  typedef int SQLHBDC, SQLHENV, SQLCHAR, SQLINTEGER; /* 3.0 */
#endif					/* ISQL */

# if defined(Graphics) || defined(PosixFns)
typedef int siptr, stringint, inst;
#endif

/*
 * graphics
 */
#ifdef Graphics
   typedef int wbp, wsp, wcp, wdp, wclrp, wfp, wtp;
   typedef int wbinding, wstate, wcontext, wfont;
   typedef int XRectangle, XPoint, XSegment, XArc, SysColor, LinearColor;
   typedef int LONG, SHORT;

   #ifdef Audio
      typedef int AudioStruct, AudioPtr, ALCcontext, ALuint, pthread_t;
      typedef int HMIXER, MIXERLINE, MMRESULT, HMIXEROBJ, MIXERCAPS;
      typedef int MIXERCONTROL, MIXERLINECONTROLS, MIXERCONTROLDETAILS;
      typedef int MIXERCONTROLDETAILS_UNSIGNED, MIXERCONTROLDETAILS_BOOLEAN;
   #endif					/* Audio */

   #ifdef MacGraph
      typedef int Str255, Point, StandardFileReply, SFTypeList, Ptr, PixMap;
      typedef int Boolean, Rect, PolyHandle, EventRecord, wsp, MouseInfoType;
      typedef int Handle, MenuHandle, OSErr, WindowPtr, GWorldFlags;
      typedef int PaletteHandle, BitMap, RgnHandle, QDErr, GWorldPtr;
      typedef int GrafPtr, GDHandle, PixMapHandle, OSType, FInfo;
      typedef int IOParam, DialogPtr, ControlHandle, StringHandle, Size;
   #endif				/* MacGraph */

   #ifdef XWindows
      typedef int Atom, Time, XSelectionEvent, XErrorEvent, XErrorHandler;
      typedef int XGCValues, XColor, XFontStruct, XWindowAttributes, XEvent;
      typedef int XExposeEvent, XKeyEvent, XButtonEvent, XConfigureEvent;
      typedef int XSizeHints, XWMHints, XClassHint, XTextProperty;
      typedef int Colormap, XVisualInfo, va_list;
      typedef int *Display, Cursor, GC, Window, Pixmap, Visual, KeySym;
      typedef int WidgetClass, XImage, XpmAttributes, XSetWindowAttributes;
   #endif				/* XWindows */
      
   #ifdef MSWindows
      typedef int clock_t, jmp_buf, MINMAXINFO, OSVERSIONINFO, BOOL_CALLBACK;
      typedef int int_PASCAL, LRESULT_CALLBACK, MSG, BYTE, WORD, DWORD;
      typedef int HINSTANCE, HGLOBAL, HPEN, HBRUSH, HRGN;
      typedef int LPSTR, HBITMAP, WNDCLASS, PAINTSTRUCT, POINT, RECT;
      typedef int HWND, HDC, UINT, WPARAM, LPARAM, SIZE;
      typedef int COLORREF, HFONT, LOGFONT, TEXTMETRIC, FONTENUMPROC, FARPROC;
      typedef int LOGPALETTE, HPALETTE, PALETTEENTRY, HCURSOR, BITMAP, HDIB;
      typedef int va_list, LOGPEN, LOGBRUSH, LPVOID, MCI_PLAY_PARMS;
      typedef int MCI_OPEN_PARMS, MCI_STATUS_PARMS, MCI_SEQ_SET_PARMS;
      typedef int CHOOSEFONT, CHOOSECOLOR, OPENFILENAME, HMENU, LPBITMAPINFO;
      typedef int childcontrol, CPINFO, BITMAPINFO, BITMAPINFOHEADER, RGBQUAD;
      #ifdef FAttrib
         typedef unsigned long mode_t;
         typedef int HFILE, OFSTRUCT, FILETIME, SYSTEMTIME;
      #endif				/* FAttrib */
   #endif				/* MSWindows */

   #ifdef HAVE_VOICE
      typedef int VSESSION, PVSESSION;
   #endif				/* HAVE_VOICE */

   #if defined Audio
      typedef int AudioFile, AudioStruct, AudioPtr;
   #ifdef HAVE_LIBOPENAL   
      typedef int ALfloat, ALuint, ALint, ALenum, ALvoid, ALboolean, ALsizei;
      typedef int PFNALBUFFERWRITEDATAPROC, ALCdevice, ALubyte;
   #endif				/* HAVE_LIBOPENAL */
   #endif				/* Audio */

   #ifdef PresentationManager
      /* OS/2 PM specifics */
      typedef int HAB, HPS, QMSG, HMQ, HWND, USHORT, MRESULT, ULONG, MPARAM;
      typedef int PFNWP, HMODULE, SHORT, BOOL, TID, RECTL, ERRORID;
      typedef int MRESULT_N_EXPENTRY, SIZEL, HDC, POINTL, HMTX, HBITMAP;
      typedef int VOID_APIENTRY, UCHAR, HEV, LINEBUNDLE, BUTMAPARRAYFILEHEADER;
      typedef int LONG, BITMAPINFOHEADER2, PBITMAPINFO2, PSZ, RGB2, BITMAPINFO2;
      typedef int FONTMETRICS, PRECTL, PCHARBUNDLE, PLINEBUNDLE, PIMAGEBUNDLE;
      typedef int AREABUNDLE, PAREABUNDLE, PPOINTL, POLYGON, CHARBUNDLE;
      typedef int lclIdentifier, BYTE, PBYTE, PRGB2, FATTRS, PFATTRS, PULONG;
      typedef int PBITMAPINFOHEADER2, BITMAPFILEHEADER2, BITMAPARRAYFILEHEADER2;
      typedef int colorEntry, ARCPARAMS, threadargs, HPOINTER, CURSORINFO;
      typedef int PCURSORINFO, DEVOPENSTRUCT, PDEVOPENDATA, SIZEF, HRGN, PSWP;
      typedef int va_list, BITMAPINFOHEADER, BITMAPFILEHEADER;
      typedef int PBITMAPINFOHEADER, MinBitmapHeader, RGB;
   #endif				/* PresentationManager */

   /*
    * Convenience macros to make up for RTL's long-windedness.
    */
   #begdef CnvShortInt(desc, s, max, min, type)
	{
	C_integer tmp;
	if (!cnv:C_integer(desc,tmp) || tmp > max || tmp < min)
	   runerr(101,desc);
	s = (type) tmp;
	}
   #enddef				/* CnvShortInt */
   #define CnvCShort(desc, s) CnvShortInt(desc, s, 0x7FFF, -0x8000, short)
   #define CnvCUShort(desc, s) CnvShortInt(desc, s, 0xFFFF, 0, unsigned short)
   
   #define CnvCInteger(d,i) \
     if (!cnv:C_integer(d,i)) runerr(101,d);
   
   #define DefCInteger(d,default,i) \
     if (!def:C_integer(d,default,i)) runerr(101,d);
   
   #define CnvString(din,dout) \
     if (!cnv:string(din,dout)) runerr(103,din);
   
   #define CnvTmpString(din,dout) \
     if (!cnv:tmp_string(din,dout)) runerr(103,din);
   
   /*
    * conventions supporting optional initial window arguments:
    *
    * All routines declare argv[argc] as their parameters
    * Macro OptWindow checks argv[0] and assigns _w_ and warg if it is a window
    * warg serves as a base index and is added everywhere argv is indexed
    * n is used to denote the actual number of "objects" in the call
    * Macro ReturnWindow returns either the initial window argument, or &window
    */
   #begdef OptWindow(w)
      if (argc>warg && is:file(argv[warg])) {
         if ((BlkLoc(argv[warg])->file.status & Fs_Window) == 0)
	    runerr(140,argv[warg]);
         if ((BlkLoc(argv[warg])->file.status & (Fs_Read|Fs_Write)) == 0)
	    fail;
         (w) = BlkLoc(argv[warg])->file.fd.wb;
#ifdef ConsoleWindow
         if ((((FILE*)(w)) != ConsoleBinding) &&
	     ((((FILE*)(w)) == k_input.fd.fp) ||
	      (((FILE*)(w)) == k_output.fd.fp) ||
	      (((FILE*)(w)) == k_errout.fd.fp)))
	   (w) = (wbp)OpenConsole();
#endif					/* ConsoleWindow */
         if (ISCLOSED(w))
	    fail;
         warg++;
         }
      else {
         if (!(is:file(kywd_xwin[XKey_Window]) &&
	      (BlkLoc(kywd_xwin[XKey_Window])->file.status & Fs_Window)))
	    runerr(140,kywd_xwin[XKey_Window]);
         if (!(BlkLoc(kywd_xwin[XKey_Window])->file.status & (Fs_Read|Fs_Write)))
	    fail;
         (w) = (wbp)BlkLoc(kywd_xwin[XKey_Window])->file.fd.fp;
         if (ISCLOSED(w))
	    fail;
         }
   #enddef				/* OptWindow */
   
   #begdef OptTexWindow(w)
      if (argc>warg && is:record(argv[warg])) {
	/* set a boolean flag, use a texture */
	is_texture=1;
	/* Get the Window from Texture record */
	w = BlkLoc(BlkLoc(argv[warg])->record.fields[3])->file.fd.wb;
        /* Pull out the texture handler */
	texhandle = IntVal(BlkLoc(argv[warg])->record.fields[2]);
	/* get the context from the window binding */
	warg=0;
      }
      else OptWindow(w); 
   #enddef   /* OptTexWindow */

   #begdef ReturnWindow
         if (!warg) return kywd_xwin[XKey_Window];
         else return argv[0]
   #enddef				/* ReturnWindow */
   
   #begdef CheckArgMultiple(mult)
   {
     if ((argc-warg) % (mult)) runerr(146);
     n = (argc-warg)/mult;
     if (!n) runerr(146);
   }
   #enddef				/* CheckArgMultiple */
   
#endif					/* Graphics */

/*
 * GRFX_ALLOC* family of macros used for static allocations.
 * Not really specific to Graphics any more, also used by databases.
 *
 * calloc to make sure uninit'd entries are zeroed.
 */
#begdef GRFX_ALLOC(var,type)
   do {
      var = (struct type *)calloc(1, sizeof(struct type));
      if (var == NULL) ReturnErrNum(305, NULL);
      var->refcount = 1;
   } while(0)
#enddef				/* GRFX_ALLOC */
   
#begdef GRFX_LINK(var, chain)
   do {
      var->next = chain;
      var->previous = NULL;
      if (chain) chain->previous = var;
      chain = var;
   } while(0)
#enddef				/* GRFX_LINK */
   
#begdef GRFX_UNLINK(var, chain)
   do {
      if (var->previous) var->previous->next = var->next;
      else chain = var->next;
      if (var->next) var->next->previous = var->previous;
      free(var);
   } while(0)
#enddef				/* GRFX_UNLINK */

#ifdef Graphics3D
   typedef int GLdouble, GLint, GLfloat, GLsizei, Status, GLboolean;
   typedef int XWindowChanges, XStandardColormap, XMappingEvent;
   typedef int GLXContext, GLUquadricObj, GLubyte, GLuint;
   typedef int GLXFBConfig, GLXWindow;
#ifdef MSWindows
   typedef int HGLRC, PIXELFORMATDESCRIPTOR;
#endif
#endif					/* Graphics3D */

#if HAVE_OGG
typedef int OggVorbis_File, vorbis_info;
#endif					/* HAVE_OGG */

#begdef MissingFunc(funcname)
"an unavailable function"
function{} funcname()
   runerr(121)
end
#enddef

#begdef MissingFunc1(funcname)
"an unavailable function"
function{} funcname(x)
   runerr(121)
end
#enddef

#begdef MissingFunc2(funcname)
"an unavailable function"
function{} funcname(x,y)
   runerr(121)
end
#enddef

#begdef MissingFuncV(funcname)
"an unavailable function"
function{0} funcname(argv[warg])
   runerr(121)
end
#enddef
