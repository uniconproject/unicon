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
#endif                                  /* NoTypeDefs */

/*
 * Macros that must be expanded by rtt.
 */

/*
 * Declaration for library routine.
 */
#begdef LibDcl(nm,n,pn)
   #passthru OpBlock(nm,n,pn,0)

   int O##nm(int nargs,register dptr cargp)
#enddef                                 /* LibDcl */

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
#enddef                                 /* ReturnErrVal */

#begdef ReturnErrNum(err_num, ret_val)
   do {
   t_errornumber = err_num;
   t_errorvalue = nulldesc;
   t_have_val = 0;
   return ret_val;
   } while (0)
#enddef                                 /* ReturnErrNum */

/*
 * Code expansions for exits from C code for top-level routines.
 */
#define Fail            return A_Resume
#define Return          return A_Continue

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

#define   mycurpstate curpstate

/*
 * Perform what amounts to "function inlining" of EVVal.
 * There are several variants.  The "real" one includes a cset membership
 * test on the event mask, plus the actual event report via actparent.
 * The non-"Real" version adds an #if test to allow the instrumentation to
 * be excluded entirely.
 */
#begdef RealEVVal(value,event,exint,entint)
   do {
      if (is:null(mycurpstate->eventmask)) break;
      else if (!Testb((word)ToAscii(event), mycurpstate->eventmask)) break;
      MakeInt(value, &(mycurpstate->parent->eventval));
      if (!is:null(mycurpstate->valuemask) &&
          (invaluemask(mycurpstate, event, &(mycurpstate->parent->eventval)) != Succeeded))
         break;
      exint;
      actparent(event);
      entint;
   } while (0)
#enddef                                 /* RealEVVal */

#begdef RealEVValD(dp,event,exint,entint)
   do {
      if (is:null(mycurpstate->eventmask)) break;
      else if (!Testb((word)ToAscii(event), mycurpstate->eventmask)) break;
      mycurpstate->parent->eventval = *(dp);
      if ((!is:null(mycurpstate->valuemask)) &&
          (invaluemask(mycurpstate, event, &(mycurpstate->parent->eventval)) != Succeeded))
         break;
      /* exint; */
      actparent(event);
      /* entint; */
   } while (0)
#enddef                                 /* RealEVValD */


/* extended version of EVVal, allows for save/restore in add'n to rsp */
#begdef EVValEx(value,event,vardecl,preact,postact)
   do {
      vardecl;
      if (is:null(mycurpstate->eventmask)) break;
      else if (!Testb((word)ToAscii(event), mycurpstate->eventmask)) break;
      MakeInt(value, &(mycurpstate->parent->eventval));
      if (!is:null(mycurpstate->valuemask) &&
          (invaluemask(mycurpstate, event, &(mycurpstate->parent->eventval)) != Succeeded))
         break;
      preact;
      ExInterp_sp;
      actparent(event);
      EntInterp_sp;
      postact;
   } while (0)
#enddef                                 /* EVValEx */

/*
  This workaround was introduced to fix a bug where lastop was getting trashed.
  A proper fix was done by moving lastop to be part of the coexpr struct.
  Should be removed if no longer needed.
*/
#begdef EVValDEx(dp,event,vardecl,preact,postact)
   do {
      vardecl;
      if (is:null(mycurpstate->eventmask)) break;
      else if (!Testb((word)ToAscii(event), mycurpstate->eventmask)) break;
      mycurpstate->parent->eventval = *(dp);
      if ((!is:null(mycurpstate->valuemask)) &&
          (invaluemask(mycurpstate, event, &(mycurpstate->parent->eventval)) != Succeeded))
         break;
      preact;
      ExInterp_sp;
      actparent(event);
      EntInterp_sp;
      postact;
   } while (0)
#enddef                                 /* RealEVValD */

#begdef EVVal(value,event)
#if event
   RealEVVal(value,event,/*noop*/,/*noop*/)
#endif
#enddef                                 /* EVVal */

#begdef EVValD(dp,event)
#if event
   RealEVValD(dp,event,/*noop*/,/*noop*/)
#endif
#enddef                                 /* EVValD */

#begdef EVValS(ipcopnd,event)           /* Syntax events */
#if event
   do {
      int scode;
      if (is:null(mycurpstate->eventmask)) break;
      else if (!Testb((word)ToAscii(event), mycurpstate->eventmask)) break;
      if (!is:null(mycurpstate->valuemask) &&
          (invaluemask(mycurpstate, event, &(mycurpstate->parent->eventval)) != Succeeded))
         break;

      scode = hitsyntax(ipcopnd);
      if (scode == 0) break;
      MakeInt(scode, &(mycurpstate->parent->eventval));
      actparent(event);
   } while (0)
#endif
#enddef                                 /* EVValS */

#begdef EVValX(bp,event)
#if event
   do {
      struct progstate *parent = mycurpstate->parent;
      if (is:null(mycurpstate->eventmask)) break;
      else if (!Testb((word)ToAscii(event), mycurpstate->eventmask)) break;
      parent->eventval.dword = D_Coexpr;
      BlkLoc(parent->eventval) = (union block *)(bp);
      if (!is:null(mycurpstate->valuemask) &&
          (invaluemask(mycurpstate, event, &(mycurpstate->parent->eventval)) != Succeeded))
         break;
      actparent(event);
   } while (0)
#endif
#enddef                                 /* EVValX */

#begdef EVVar(dp, e)
#if e
   do {
      if (!is:null(mycurpstate->eventmask) &&
         Testb((word)ToAscii(e), mycurpstate->eventmask)) {
            EVVariable(dp, e);
            }
   } while(0)
#endif
#enddef

#begdef InterpEVVal(value,event)
#if !ConcurrentCOMPILER
#if event
  { RealEVVal(value,event,ExInterp_sp,EntInterp_sp); }
#endif
#endif                                  /* !ConcurrentCOMPILER */
#enddef

#begdef InterpEVValD(dp,event)
#if !ConcurrentCOMPILER
#if event
 { RealEVValD(dp,event,ExInterp_sp,EntInterp_sp); }
#endif
#endif                                  /* !ConcurrentCOMPILER */
#enddef

/*
 * Macro for Syntax Monitoring
 */
#begdef InterpEVValS(ipcopnd,event)
#if !ConcurrentCOMPILER
#if event
 { ExInterp_sp; EVValS(ipcopnd,event); EntInterp_sp; }
#endif
#endif                                  /* !ConcurrentCOMPILER */
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
#enddef                                 /* Desc_EVValD */

typedef int pid_t;

/*
 * dummy typedefs for things defined in #include files
 */
typedef int clock_t, time_t, fd_set;

#if WildCards
   typedef int FINDDATA_T;
#endif                                  /* WildCards */

#ifdef ReadDirectory
   typedef int DIR;
#endif                                  /* ReadDirectory */

#ifdef Messaging
typedef int size_t;
typedef long time_t;
#endif                                  /* Messaging */

#ifdef FAttrib
typedef unsigned long mode_t;
#endif                                  /* FAttrib */

#if HAVE_LIBZ
typedef int gzFile;
#endif                                  /* HAVE_LIBZ */

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
typedef int HMODULE, WSADATA, WORD, HANDLE, MEMORYSTATUS, DWORD;
typedef int STARTUPINFO, PROCESS_INFORMATION, SECURITY_ATTRIBUTES;
typedef int LPSOCKADDR;
#if 1
typedef int MEMORYSTATUSEX;
#endif
#endif                                  /* NT */

#if HAVE_LIBJPEG
typedef int j_common_ptr, JSAMPARRAY, JSAMPROW;
#endif                                  /* HAVE_LIBJPEG */

#if HAVE_LIBPNG
typedef int png_uint_32, png_bytep,  png_bytepp,  png_color_16p, png_structp, png_infop;
#endif                                  /* HAVE_LIBPNG */

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
#endif                                  /* PosixFns */

#if HAVE_LIBSSL
typedef int SSL_CTX, SSL;
#endif                                  /* LIBSSL */

#ifdef Concurrent
       typedef int pthread_key_t, sigset_t;
#endif                                  /* Concurrent */

#ifdef HAVE_LIBCL
       typedef int cl_uint, cl_platform_id, cl_device_id;
#endif                                  /* HAVE_LIBCL */

#ifdef Dbm
typedef int DBM;
typedef struct {
   char *dptr;
   int dsize;
} datum;
#endif                                  /* Dbm */

#ifdef ISQL                             /* ODBC */
  typedef int LPSTR, HENV, HDBC, HSTMT, ISQLFile, PTR, SQLPOINTER;
  typedef int SWORD, SDWORD, UWORD, UDWORD, UCHAR;
  typedef int SQLUSMALLINT, SQLSMALLINT, SQLHSTMT;
typedef int SQLUINTEGER, SQLRETURN, RETCODE, SQLLEN, SQLULEN;
  typedef int SQLHBDC, SQLHENV, SQLCHAR, SQLINTEGER, SQLLEN; /* 3.0 */
#endif                                  /* ISQL */

#ifdef Audio
   typedef int AudioStruct, AudioPtr, AudioFile;
   typedef int HMIXER, MIXERLINE, MMRESULT, HMIXEROBJ, MIXERCAPS;
   typedef int MIXERCONTROL, MIXERLINECONTROLS, MIXERCONTROLDETAILS;
   typedef int MIXERCONTROLDETAILS_UNSIGNED, MIXERCONTROLDETAILS_BOOLEAN;
#ifdef HAVE_LIBOPENAL
   typedef int ALCcontext, ALCdevice;
   typedef int pthread_t, pthread_mutex_t, pthread_attr_t;
   typedef int ALfloat, ALuint, ALint, ALenum, ALvoid, ALboolean, ALsizei;
   typedef int ALubyte, ALchar;
#endif                          /* HAVE_LIBOPENAL */
#endif                          /* Audio */

#if HAVE_OGG
typedef int OggVorbis_File, vorbis_info;
#endif                                  /* HAVE_OGG */

#ifdef HAVE_VOICE
   typedef int VSESSION, PVSESSION;
#endif                          /* HAVE_VOICE */

#if defined(HAVE_LIBPTHREAD)
      typedef int pthread_t, pthread_attr_t, pthread_cond_t;
      typedef int pthread_rwlock_t, sem_t;
      typedef int pthread_mutex_t, pthread_mutexattr_t;
#endif                                  /* HAVE_LIBPTHREAD */

# if defined(Graphics) || defined(PosixFns)
typedef int stringint, inst;
#endif

typedef int va_list, siptr;

/*
 * graphics
 */
#ifdef Graphics
   typedef int wbp, wsp, wcp, wdp, wclrp, wfp, wtp;
   typedef int wbinding, wstate, wcontext, wfont;
   typedef int XRectangle, XPoint, XSegment, XArc, SysColor, LinearColor;
   typedef int LONG, SHORT;

   #ifdef XWindows
      typedef int Atom, Time, XSelectionEvent, XErrorEvent, XErrorHandler;
      typedef int XGCValues, XColor, XFontStruct, XWindowAttributes, XEvent;
      typedef int XExposeEvent, XKeyEvent, XButtonEvent, XConfigureEvent;
      typedef int XSizeHints, XWMHints, XClassHint, XTextProperty;
      typedef int Colormap, XVisualInfo;
      typedef int *Display, Cursor, GC, Window, Pixmap, Visual, KeySym;
      typedef int WidgetClass, XImage, XpmAttributes, XSetWindowAttributes;
   #endif                               /* XWindows */

   #ifdef MSWindows
      typedef int clock_t, jmp_buf, MINMAXINFO, OSVERSIONINFO, BOOL_CALLBACK;
      typedef int int_PASCAL, LRESULT_CALLBACK, MSG, BYTE, WORD;
      typedef int HINSTANCE, HGLOBAL, HPEN, HBRUSH, HRGN;
      typedef int LPSTR, HBITMAP, WNDCLASS, PAINTSTRUCT, POINT, RECT;
      typedef int HWND, HDC, UINT, WPARAM, LPARAM, SIZE, LONG_PTR, DWORD_PTR;
      typedef int COLORREF, HFONT, LOGFONT, TEXTMETRIC, FONTENUMPROC, FARPROC;
      typedef int LOGPALETTE, HPALETTE, PALETTEENTRY, HCURSOR, BITMAP, HDIB;
typedef int LOGPEN, LOGBRUSH, LPVOID, MCI_PLAY_PARMS, MCIDEVICEID;
      typedef int MCI_OPEN_PARMS, MCI_STATUS_PARMS, MCI_SEQ_SET_PARMS;
      typedef int CHOOSEFONT, CHOOSECOLOR, OPENFILENAME, HMENU, LPBITMAPINFO;
      typedef int childcontrol, CPINFO, BITMAPINFO, BITMAPINFOHEADER, RGBQUAD;
      #ifdef FAttrib
         typedef unsigned long mode_t;
         typedef int HFILE, OFSTRUCT, FILETIME, SYSTEMTIME;
      #endif                            /* FAttrib */
   #endif                               /* MSWindows */

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
   #enddef                              /* CnvShortInt */
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
         if ((BlkD(argv[warg],File)->status & Fs_Window) == 0)
            runerr(140,argv[warg]);
         if ((BlkD(argv[warg],File)->status & (Fs_Read|Fs_Write)) == 0)
            fail;
         (w) = BlkD(argv[warg],File)->fd.wb;
#ifdef ConsoleWindow
         checkOpenConsole((FILE *)(w), NULL);
#endif                                  /* ConsoleWindow */
         if (ISCLOSED(w))
            fail;
         warg++;
         }
      else {
         if (!(is:file(kywd_xwin[XKey_Window]) &&
              (BlkD(kywd_xwin[XKey_Window],File)->status & Fs_Window)))
            runerr(140,kywd_xwin[XKey_Window]);
         if (!(BlkD(kywd_xwin[XKey_Window],File)->status & (Fs_Read|Fs_Write)))
            fail;
         (w) = (wbp)BlkD(kywd_xwin[XKey_Window],File)->fd.fp;
         if (ISCLOSED(w))
            fail;
         }
   #enddef                              /* OptWindow */

   #begdef OptTexWindow(w)
#ifdef Graphics3D
      if (argc>warg && is:record(argv[warg])) {
        /* set a boolean flag, use a texture */
        is_texture=TEXTURE_RECORD;
        /* Get the Window from Texture record */
        w = BlkD(BlkD(argv[warg],Record)->fields[3],File)->fd.wb;
        /* Pull out the texture handler */
        texhandle = IntVal(BlkD(argv[warg],Record)->fields[2]);
        /* get the context from the window binding */
        warg++;
      }
      else
#endif                                  /* Graphics3D */
      if (argc>warg && is:file(argv[warg])) {
         if ((BlkD(argv[warg],File)->status & Fs_Window) == 0)
            runerr(140,argv[warg]);
         if ((BlkD(argv[warg],File)->status & (Fs_Read|Fs_Write)) == 0)
            fail;
         (w) = BlkD(argv[warg],File)->fd.wb;
#ifdef ConsoleWindow
         checkOpenConsole((FILE *)(w), NULL);
#endif                                  /* ConsoleWindow */
         if (ISCLOSED(w))
            fail;
         warg++;
#ifdef Graphics3D
        /* set a boolean flag, use a texture */
         if (w->window->type == TEXTURE_WSTATE){
            is_texture=TEXTURE_WINDOW;
            texhandle = w->window->texindex;
            }
#endif                                  /* Graphics3D */

         }
      else {
         if (!(is:file(kywd_xwin[XKey_Window]) &&
              (BlkD(kywd_xwin[XKey_Window],File)->status & Fs_Window)))
            runerr(140,kywd_xwin[XKey_Window]);
         if (!(BlkD(kywd_xwin[XKey_Window],File)->status & (Fs_Read|Fs_Write)))
            fail;
         (w) = (wbp)BlkD(kywd_xwin[XKey_Window],File)->fd.fp;
         if (ISCLOSED(w))
            fail;
#ifdef Graphics3D
        /* set a boolean flag, use a texture */
         if (w->window->type == TEXTURE_WSTATE){
            is_texture=TEXTURE_WINDOW;
            texhandle = w->window->texindex;
            }
#endif                                  /* Graphics3D */
         }
   #enddef   /* OptTexWindow */

   #begdef ReturnWindow
         if (!warg) return kywd_xwin[XKey_Window];
         else return argv[0]
   #enddef                              /* ReturnWindow */

   #begdef CheckArgMultiple(mult)
   {
     if ((argc-warg) % (mult)) runerr(146);
     n = (argc-warg)/mult;
     if (!n) runerr(146);
   }
   #enddef                              /* CheckArgMultiple */

/*
 * make sure the window is 3D, issue a runtime error if it is not
 */
   #begdef EnsureWindow3D(w)
   {
     if (w->context->is_3D == 0) {
       if (warg == 0)
         runerr(150, kywd_xwin[XKey_Window]);
       else
         runerr(150, argv[0]);
     }
   }
   #enddef

#endif                                  /* Graphics */

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
#enddef                         /* GRFX_ALLOC */

#begdef GRFX_LINK(var, chain)
   do {
      var->next = chain;
      var->previous = NULL;
      if (chain) chain->previous = var;
      chain = var;
   } while(0)
#enddef                         /* GRFX_LINK */

#begdef GRFX_UNLINK(var, chain)
   do {
      if (var->previous) var->previous->next = var->next;
      else chain = var->next;
      if (var->next) var->next->previous = var->previous;
      free(var);
   } while(0)
#enddef                         /* GRFX_UNLINK */

#ifdef Graphics3D
   typedef int GLdouble, GLint, GLfloat, GLsizei, Status, GLboolean, GLenum;
   typedef int XWindowChanges, XStandardColormap, XMappingEvent, _GLUfuncptr;
   typedef int GLXContext, GLUquadricObj, GLUtesselator, GLubyte, GLuint;
   typedef int GLXFBConfig, GLXWindow;
#ifdef MSWindows
   typedef int HGLRC, PIXELFORMATDESCRIPTOR;
#endif
#endif                                  /* Graphics3D */

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
