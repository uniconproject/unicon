/*
 * opengl.h - macros and structures for OpenGL-specific implementation
 *            of Unicon graphics facilities
 */

//#define GL2D_DRAWARRAYS 1 /* Punt this off as a TODO item */

#ifdef GL2D_DEBUG
#define glprintf(s, ...) printf(stderr,s, ##__VA_ARGS__)
#else					/* GL2D_DEBUG */
#define glprintf(s, ...) 
#endif					/* GL2D_DEBUG */

/* Definitions for attribute buffermode */
#define UGL_IMMEDIATE	1
#define UGL_BUFFERED 	0
/* Legacy definitons */
#define IMMEDIATE3D    	UGL_IMMEDIATE	
#define BUFFERED3D	UGL_BUFFERED	


/*
 * mesh modes.
 */
#define U3D_POINTS         GL_POINTS
#define U3D_LINES          GL_LINES
#define U3D_LINE_STRIP     GL_LINE_STRIP
#define U3D_LINE_LOOP      GL_LINE_LOOP
#define U3D_TRIANGLES      GL_TRIANGLES
#define U3D_TRIANGLE_FAN   GL_TRIANGLE_FAN
#define U3D_TRIANGLE_STRIP GL_TRIANGLE_STRIP
#define U3D_QUADS          GL_QUADS
#define U3D_QUAD_STRIP     GL_QUAD_STRIP
#define U3D_POLYGON        GL_POLYGON

#define U2D_LINE_LOOP      GL_LINE_LOOP
#define U2D_LINE_STRIP	   GL_LINE_STRIP
#define U2D_POLYGON	   GL_POLYGON

/*
 * texture modes.
 */
#define U3D_REPLACE        GL_REPLACE
#define U3D_BLEND          GL_BLEND
#define U3D_MODULATE       GL_MODULATE

/*
 * Graphical primitive IDs
 */
#define GL2D_BLIMAGE		9000
#define GL2D_FILLPOLYGON	9001
#define GL2D_DRAWPOLYGON	9002
#define GL2D_DRAWSEGMENT	9003
#define GL2D_DRAWLINE		9004 
#define GL2D_DRAWPOINT		9005
#define GL2D_DRAWCIRCLE		9006
#define GL2D_FILLCIRCLE		9007
#define GL2D_DRAWARC		9008
#define GL2D_FILLARC		9009
#define GL2D_DRAWRECTANGLE	9010
#define GL2D_FILLRECTANGLE	9011
#define GL2D_COPYAREA		9012
#define GL2D_ERASEAREA		9013
#define GL2D_STRIMAGE		9014
#define GL2D_READIMAGE		9015
#define GL2D_DRAWSTRING		9016
#define GL2D_WWRITE		9017

/* 
 * Attribute primitive IDs
 */
/* colors */
#define GL2D_FG			9050
#define GL2D_BG			9051
#define GL2D_REVERSE		9052
#define GL2D_GAMMA		9053
#define GL2D_DRAWOP		9054

/* fonts */
#define GL2D_FONT		9055
#define GL2D_LEADING		9056

/* lines/fills */
#define GL2D_LINEWIDTH		9057
#define GL2D_LINESTYLE		9058
#define GL2D_FILLSTYLE		9059
#define GL2D_PATTERN		9060

/* positioning */
#define GL2D_CLIP		9061
#define GL2D_DX			9062
#define GL2D_DY			9063

/*
 * line styles
 */
#define GL2D_LINE_SOLID		0
#define GL2D_LINE_DASHED	1
#define GL2D_LINE_STRIPED	2

/*
 * fill styles
 */
#define GL2D_FILL_SOLID		0
#define GL2D_FILL_TEXTURED	1
#define GL2D_FILL_MASKED	2

/*
 * drawops 
 */
#define GL2D_DRAWOP_COPY	GL_COPY	
#define GL2D_DRAWOP_REVERSE	GL_XOR	


/*
 * Structures
 */

/*
 * For a linked list color structure
 */
typedef struct color {
   char name[6+MAXCOLORNAME];
   unsigned short r, g, b, a;
   /* for referencing a mutable color (negative) */
   int id; 
#ifdef XWindows
   unsigned long c; /* X11 color handle */
#endif 					/* XWindows */
   struct color *prev, *next;
   } *clrp;

/*
 * Object for storing font characters (uses textures)
 */
struct fontsymbol {
   unsigned char *pixmap;
   int width, height;
   int advance, top_bearing, left_bearing;  
   unsigned int texid, index;
   };


/*
 * A version of *MakeCurrent that checks for redundant state changes.
 */
#ifdef XWindows
#define MakeCurrent(w) do {\
   wsp ws = (w)->window;\
   if (ws->ctx != ws->display->currCtx) {\
      if (ws->iconic == HiddenState)\
         glXMakeCurrent(ws->display->display, ws->pbuf, ws->ctx);\
      else\
         glXMakeCurrent(ws->display->display, ws->win, ws->ctx);\
      ws->display->currCtx = ws->ctx;\
      }\
   } while(0)

#define UnbindCurrent(wd) do {\
   glXMakeCurrent(wd->display, None, NULL);\
   wd->currCtx = NULL;\
   } while(0)

#endif					/* XWindows */

/*
 * TODO: Make MSWindows version check for redundant state changes
 */
#ifdef MSWindows
#define MakeCurrent(w) do {\
   wsp ws = (w)->window;\
   HDC stddc = CreateWinDC(w); \
   wglMakeCurrent(stddc, ws->ctx);\
   ReleaseDC(ws->iconwin, stddc);\
   } while(0)

#define UnbindCurrent(wd)
#endif 					/* MSWindows */

#define FlushWindow(w) do {\
   if ((w)->window->buffermode == UGL_BUFFERED)\
      swapbuffers((w), 1);\
   else if ((w)->window->buffermode == UGL_IMMEDIATE)\
      glFlush();\
   } while(0);

/*
 * Wrappers for OpenGL functions that check return values (prefixed with UGL)
 */

/*
 * There is at least one OpenGL function that is generating
 * an error currently. When there is enough time, just these
 * error macros to find out what is it. As of yet, nothing
 * seems to be running poorly.
 */
#define UGLGetError(msg) do {\
   unsigned int err;\
   while ((err = glGetError()) != GL_NO_ERROR)\
      glprintf("OpenGL error 0x%x from" #msg "\n",err);\
   } while(0)

/*
 * General OpenGL error checker that handles nothing. 
 * Currently for debugging 
 */
#define CheckGLError(func) do {\
   unsigned int err;\
   func;\
   UGLGetError(func);\
   } while(0)

#define UGLTexImage2D(wd, target, level, internalfmt, width, height, border,\
   format, type, data, retval) \
   do {\
   unsigned int err, errcount = 0;\
   glTexImage2D(target,level,internalfmt,width,height,border,format,type,data);\
   while ((err = glGetError()) != GL_NO_ERROR) {\
      if (err == GL_OUT_OF_MEMORY) {\
         if (!errcount) {\
            delete_first_tex(wd, (wd)->numTexIds/2);\
            glTexImage2D(target,level,internalfmt,width,height,border,format,\
		         type,data);\
            }\
         /* if failed already, then let it die */\
         else return retval;\
         errcount++;\
         }\
      }\
   } while(0)

/*
 * There is a floating error in gpxtest.icn for procedure copying
 * It is happening before the entire hidden 
 * window's contents are copied to the main window.
 * TODO: find the error to make sure it doesn't become
 * a future problem. Reminder: set a breakpoint at 
 * gl_copyArea or copyarea2d to find it.
 *
 * The error is incorrectly diagnosed to be a result of 
 * glBindTexture, but uncommenting the while loop shows
 * it to be true.
 */
#define UGLBindTexture(target, texid) do {\
   unsigned int err;\
/*\
   while ((err = glGetError()) != GL_NO_ERROR)\
      glprintf("previous OpenGL error 0x%x\n",err);\
*/\
   glBindTexture(target, texid);\
   while ((err = glGetError()) != GL_NO_ERROR) {\
      switch (err) {\
         case GL_INVALID_ENUM:\
            glprintf("Invalid texture target %d\n",(int)target);\
            break;\
         case GL_INVALID_VALUE:\
            glprintf("Texture id %u was not generated from a previous call to glGenTextures()\n",(unsigned int)texid);\
            break;\
         case GL_INVALID_OPERATION:\
            glprintf("Texture id %u does not match the target specified from the call to glGenTextures()\n",(unsigned int)texid);\
            break;\
         default:\
            glprintf("Residual OpenGL error 0x%x\n",err);\
            break;\
         }\
      }\
   } while(0)

#ifdef XWindows
#define ApplyBuffermode(w, mode) do {\
   if ((mode) == UGL_BUFFERED || (w)->window->iconic == HiddenState) {\
      glReadBuffer(GL_BACK);\
      glDrawBuffer(GL_BACK);\
      }\
   else if ((mode) == UGL_IMMEDIATE) {\
      glReadBuffer(GL_FRONT);\
      glDrawBuffer(GL_FRONT);\
      }\
   } while(0)
#else					/* XWindows */
#define ApplyBuffermode(w, mode)
#endif					/* XWindows */


/*
 * For Unicon graphics, it would be useful to designate specific classes
 * of operations to each bit of the stencil buffer.
 */
#define GL2D_DRAW_BIT 0x01
#define GL2D_PATT_BIT 0x02
#define GL2D_ERASE_BIT 0x04

/*
 * {mask} determines the bitplane(s) affected.
 * {val} is the value the stencil buffer is cleared to.
 * {action} determines the the action to be taken when the stencil
 * test passes.
 */
#define EnableStencilWrite(mask, val, action) do {\
   glStencilMask(mask);\
   glStencilOp(GL_KEEP, GL_KEEP, action);\
   glClearStencil(val);\
   glClear(GL_STENCIL_BUFFER_BIT);\
   } while(0)

#define DisableStencilWrite() do {\
   glStencilMask(0x0);\
   glStencilOp(GL_KEEP, GL_KEEP, GL_KEEP);\
   } while(0)

/*
 * glStencilFunc() with a mask of 0 lets the stencil test pass regardless
 * of what values are in the stencil buffer. Otherwise, it will only let 
 * pixels that are equal to the bits in {mask} pass the stencil test.
 */
#define SetStencilFunc(w, mask) \
   glStencilFunc(GL_EQUAL, 0xFF, (w)->window->stencil_mask|mask)
#define DefaultStencilFunc(w) SetStencilFunc(w, 0)

/*
 * Miscellaneous
 */
#define POLY_COMPLEX 1 /* self-intersecting "convex" */
#define POLY_CONVEX 2 
#define POLY_NONCONVEX 3

/*
 * Macros for GPU pixel format. (buf) and other values must be of the same
 * type. Automating GPU pixel format configuration is a TODO item.
 */
#define AssignRGBA(buf, r, g, b, a) do {\
   (buf)[0] = r;\
   (buf)[1] = g;\
   (buf)[2] = b;\
   (buf)[3] = a;\
   } while(0)

#define AssignBGRA(buf, r, g, b, a) do {\
   (buf)[0] = b;\
   (buf)[1] = g;\
   (buf)[2] = r;\
   (buf)[3] = a;\
   } while(0)

#define AssignRGB(buf, r, g, b) do {\
   (buf)[0] = r;\
   (buf)[1] = g;\
   (buf)[2] = b;\
   } while(0)
 
#define AssignBGR(buf, r, g, b) do {\
   (buf)[0] = b;\
   (buf)[1] = g;\
   (buf)[2] = r;\
   } while(0)

/*
 * Macro for convenience
 */
#define UpdateRenderContext(w, intcode) do {\
   if (!(w)->window->initAttrs && !(w)->window->updateRC &&\
       (w)->window->lastwcserial != (w)->context->serial)\
      {\
      int rv = updaterendercontext(w, intcode);\
      if (rv != Succeeded) return rv;\
      }\
   } while(0)

/*
 * Helper macro for getting 2d record constructors
 *
 * rec_structor2d() could return NULL if the program runs out of memory. 
 * If it returns NULL with memory to spare, it would be a syserr().
 */
#define Get2dRecordConstr(constr, code) do {\
   if (constr == NULL) {\
      if ((constr = rec_structor2d(code)) == NULL) {\
         return RunError;\
         }\
      }\
   } while(0)\

/*
 * Macros for context attribute application
 */

/*
 * The OpenGL logical operations interfere with transparency (i.e. when
 * GL_COLOR_LOGIC_OP is enabled, GL_BLEND is disabled)
 * Disable GL_COLOR_LOGIC_OP for drawop="copy" and enable
 * it for drawop="reverse"/"xor".
 */
#define ApplyDrawop(w, drawop) do {\
   if (drawop == GL2D_DRAWOP_COPY) {\
      glDisable(GL_COLOR_LOGIC_OP);\
      }\
   else if (drawop == GL2D_DRAWOP_REVERSE) {\
      glEnable(GL_COLOR_LOGIC_OP);\
      }\
   SetDrawopColorState(w, drawop, FG);\
   } while(0)

#define ApplyGamma(w) SetDrawopColorState(w, (w)->window->wcrender.drawop, FG)
#define ApplyLinewidth(linewidth) glLineWidth(linewidth);

/*
 * Get macros for user-modifiable DL record fields.
 * Should they Fail or RunError on an unexpected type?
 */
#define GetInt(d, intgr) do {\
   /*if (is:integer(d))*/\
   if ((d).dword == D_Integer)\
      intgr = IntVal(d);\
   /*else if (is:real(d))*/\
   else if ((d).dword == D_Real)\
      intgr = (int)RealVal(d);\
   else\
      return RunError;/* expected Int/Dbl */\
   } while(0)

#define GetDouble(d, dbl) do {\
   /*if (is:integer(d))*/\
   if ((d).dword == D_Integer)\
      dbl = (double)IntVal(d);\
   /*else if (is:real(d))*/\
   else if ((d).dword == D_Real)\
      dbl = (double)RealVal(d);\
   else\
      return RunError;/* expected Int/Dbl */\
   } while(0)

#define GetStr(d, s, len) do {\
   if (Qual(d)) {\
      s = StrLoc(d);\
      len = StrLen(d);\
      }\
   else\
      return RunError; /* expected string */\
   } while(0)

#define GetStrLoc(d, s) do {\
   if (Qual(d))\
      s = StrLoc(d);\
   else\
      return RunError; /* expected string */\
   } while(0)

/*
 * Macros for checking user-changed DL record fields
 */
#define RecalcTranslation(w) \
   ((w)->window->dx_flag | (w)->window->dy_flag)

/*
 * Need to compare some real values. Choose an epsilon
 */
#define UGL_EPSILON 1e-4
#define RealEqual(r1, r2) (Abs(r1 - r2) <= UGL_EPSILON)

#define RecalcCircle(rp) \
   ((IntVal((rp)->fields[3]) != IntVal((rp)->fields[8])) ||\
    (IntVal((rp)->fields[4]) != IntVal((rp)->fields[9])) ||\
    RealEqual(RealVal((rp)->fields[5]), RealVal((rp)->fields[10])) ||\
    RealEqual(RealVal((rp)->fields[6]), RealVal((rp)->fields[11])) ||\
    RealEqual(RealVal((rp)->fields[7]), RealVal((rp)->fields[12]))\
   )

#define UpdateCircle(rp) do {\
   IntVal((rp)->fields[8]) = (word)IntVal((rp)->fields[3]);\
   IntVal((rp)->fields[9]) = (word)IntVal((rp)->fields[4]);\
   RealVal((rp)->fields[10]) = RealVal((rp)->fields[5]);\
   RealVal((rp)->fields[11]) = RealVal((rp)->fields[6]);\
   RealVal((rp)->fields[12]) = RealVal((rp)->fields[7]);\
   } while(0)

#define RecalcArc(rp) \
   ((IntVal((rp)->fields[3]) != IntVal((rp)->fields[9])) ||\
    (IntVal((rp)->fields[4]) != IntVal((rp)->fields[10])) ||\
    (IntVal((rp)->fields[5]) != IntVal((rp)->fields[11])) ||\
    (IntVal((rp)->fields[6]) != IntVal((rp)->fields[12])) ||\
    RealEqual(RealVal((rp)->fields[7]), RealVal((rp)->fields[13])) ||\
    RealEqual(RealVal((rp)->fields[8]), RealVal((rp)->fields[14]))\
   )

#define UpdateArc(rp) do {\
   IntVal((rp)->fields[9]) = (word)IntVal((rp)->fields[3]);\
   IntVal((rp)->fields[10]) = (word)IntVal((rp)->fields[4]);\
   IntVal((rp)->fields[11]) = (word)IntVal((rp)->fields[5]);\
   IntVal((rp)->fields[12]) = (word)IntVal((rp)->fields[6]);\
   RealVal((rp)->fields[13]) = RealVal((rp)->fields[7]);\
   RealVal((rp)->fields[14]) = RealVal((rp)->fields[8]);\
   } while(0)

#define RecalcRect(rp) \
   ((IntVal((rp)->fields[3]) != IntVal((rp)->fields[7])) ||\
    (IntVal((rp)->fields[4]) != IntVal((rp)->fields[8])) ||\
    (IntVal((rp)->fields[5]) != IntVal((rp)->fields[9])) ||\
    (IntVal((rp)->fields[6]) != IntVal((rp)->fields[10]))\
   )

#define UpdateRect(rp) do {\
   IntVal((rp)->fields[7]) = (word)IntVal((rp)->fields[3]);\
   IntVal((rp)->fields[8]) = (word)IntVal((rp)->fields[4]);\
   IntVal((rp)->fields[9]) = (word)IntVal((rp)->fields[5]);\
   IntVal((rp)->fields[10]) = (word)IntVal((rp)->fields[6]);\
   } while(0)

/*
 * Macros for managing integrated 2D/3D mode
 */

#define DepthRange2d() glDepthRange(0.0,0.0)
#define DepthRange3d() glDepthRange(0.05,1.0)
#define DepthRangeMax() glDepthRange(1.0,1.0)

#define IS_CLIP(w) ((w)->window->wcrender.clipx != 0 ||\
                    (w)->window->wcrender.clipy != 0 ||\
                    (w)->window->wcrender.clipw != -1 ||\
                    (w)->window->wcrender.cliph != -1)

/*
 * Make sure that OpenGL states stay consistent to 2D/3D rendering modes
 */
#define SwitchMode2d(w) do {\
   if (IS_CLIP(w))\
      glEnable(GL_SCISSOR_TEST);\
   DepthRange2d();\
   } while(0)

#define SwitchMode3d(w) do {\
   if (IS_CLIP(w))\
      glDisable(GL_SCISSOR_TEST);\
   DepthRange3d();\
   } while(0)

#define UGL2D 0
#define UGL3D 1
#define ApplyRendermode(w,is_3d) do {\
   (w)->window->rendermode = is_3d;\
   if (is_3d)\
      SwitchMode3d(w);\
   else\
      SwitchMode2d(w);\
   } while(0)

#define CheckRendermode(w) do {\
   if ((w)->window->rendermode != (w)->context->rendermode) {\
      ApplyRendermode(w, w->context->rendermode);\
      }\
   } while(0)

/*
 * Viewing volume definitions
 */ 
//#define CWIDTH 0.25
//#define CNEAR 0.25
//#define CFAR 50000.0
//#define CHEIGHT(w) (CWIDTH*((double)w->window->height)/((double)w->window->width))

#define CNEAR 0.25
#define CFAR 50000.0
#define DEFAULT_CWIDTH 0.25
#define CWIDTH(w) ((w)->window->camwidth)
#define CHEIGHT(w) ((w)->window->camwidth*((double)w->window->height)/\
                    ((double)w->window->width))
#define HALF_CWIDTH(w) (CWIDTH(w)/2.0)
#define HALF_CHEIGHT(w) (CHEIGHT(w)/2.0)

/* Projection definitons */
#define UGL_PERSPECTIVE	0
#define UGL_ORTHOGONAL	1

#define UGLProj(w) do {\
   wsp ws = (w)->window;\
   if (ws->projection == UGL_PERSPECTIVE)\
      glFrustum(-HALF_CWIDTH(w),HALF_CWIDTH(w),-HALF_CHEIGHT(w),\
                HALF_CHEIGHT(w),CNEAR,CFAR);\
   else\
      glOrtho(-HALF_CWIDTH(w),HALF_CWIDTH(w),-HALF_CHEIGHT(w),HALF_CHEIGHT(w),\
                CNEAR,CFAR);\
   } while(0)

#define SetWindowSize(w) do {\
   wsp ws = (w)->window;\
   glViewport(0, 0, (GLsizei)ws->width, (GLsizei)ws->height);\
   glMatrixMode(GL_PROJECTION);\
   glLoadIdentity();\
   UGLProj(w);\
   glMatrixMode(GL_MODELVIEW);\
   } while(0)

/*
 * Checks to see if (x, y, w, h) are the defaults set by rectargs(). If they
 * aren't, subtract dx/dy.
 */
#define RemoveDxDy(win, x, y, w, h) do {\
   wsp ws = win->window;\
   wcp wcr = &(ws->wcrender);\
   if (x != 0 || y != 0 || w != ws->width || h != ws->height) {\
      x -= wcr->dx;\
      y -= wcr->dy;\
      }\
   } while(0)

/*
 * Adds dx/dy back in via render context. 
 * Uses rectargs() logic like RemoveDxDy()
 */
#define AddDxDy(win, x, y, w, h) do {\
   wsp ws = win->window;\
   wcp wcr = &(ws->wcrender);\
   if (x != 0 || y != 0 || w != ws->width || h != ws->height) {\
      x += wcr->dx;\
      y += wcr->dy;\
      }\
   } while(0)

/*
 * For translating from pixel (Unicon) to world (OpenGL) coordinates. 
 * In relation to the camera, the center of the window is (0,0) in world
 * coordinates.
 */
#define PIXW(w) (w->window->width)
#define PIXH(w) (w->window->height)
#define CLIPW(w) (CWIDTH(w))
#define CLIPH(w) (CHEIGHT(w))

/*
 * For translating from Unicon to OpenGL coordinates
 *
 * Any pixel rendering operations must use GLWORLDCOORD_*().
 *
 * Any line rendering operations that use OpenGL defined primitives 
 * (GL_POLYGON, GL_LINES, etc) must use GLWORLDCOORD_RENDER*().
 * OpenGL renders lines with the diamond rule. GLWORLDCOORD_RENDER_*() offsets
 * the pixel value by 0.5 so that it starts in the center of a pixel.
 */
#define GLWORLDCOORD_X(w, px) ((px)*CLIPW(w)/(double)PIXW(w)-CLIPW(w)/2.0)
#define GLWORLDCOORD_Y(w, py) \
   ((PIXH(w)-(py))*CLIPH(w)/(double)PIXH(w)-CLIPH(w)/2.0)
#define GLWORLDCOORD_RENDER_X(w, px) \
   ((px+0.5)*CLIPW(w)/(double)PIXW(w)-CLIPW(w)/2.0)
#define GLWORLDCOORD_RENDER_Y(w, py) \
   ((PIXH(w)-(py+0.5))*CLIPH(w)/(double)PIXH(w)-CLIPH(w)/2.0)

/* 
 * For translating radius in pixels to that of the world coordinate system.
 *
 * The transformation must keep the correct arc-to-window-dimension
 * ratios when transforming from pixel to world dimensions.
 */
#define GLRADIUS_X(w, pr) ((pr)/PIXW(w)*CLIPW(w))
#define GLRADIUS_Y(w, pr) ((pr)/PIXH(w)*CLIPH(w))

/*
 * Sets a color {struct color}. 
 *
 * Whenever a color is set, set the X11 color handle to -1 (default).
 *
 * Should the colorname include alpha?
 */
#ifdef XWindows 
#define SetColor(clr, red, green, blue, alpha, index) do {\
   sprintf((clr).name,"%ld,%ld,%ld",(long)red,(long)green,(long)blue);\
   (clr).r = red;\
   (clr).g = green;\
   (clr).b = blue;\
   (clr).a = alpha;\
   (clr).id = index;\
   /* TODO: make this look through {wd->colors} to see if already allocated */\
   if (red == 0 && green == 0 && blue == 0 )\
      (clr).c = 0;\
   else if (red == 65535 && green == 65535 && blue == 65535)\
      (clr).c = 1;\
      /*(clr).pixel = 1;*/\
   else\
      (clr).c = -1;\
      /*(clr).pixel = -1;*/\
   } while(0)
#else					/* XWindows */
#define SetColor(clr, red, green, blue, alpha, index) do {\
   sprintf((clr).name,"%ld,%ld,%ld",(long)red,(long)green,(long)blue);\
   (clr).r = red;\
   (clr).g = green;\
   (clr).b = blue;\
   (clr).a = alpha;\
   (clr).id = index;\
   } while(0)
#endif					/* XWindows */

/*
 * Gets a color from type {struct color}. Works whether {color}
 * is mutable or not. If it is mutable and it cannot be found,
 * set the color to black (talk to Dr. J about this). 
 *
 * The returned color values are unsigned short (US).
 */
#define GetColorUS(w, clr, red, green, blue, alpha) do {\
   if ((clr).id < 0) { /* have a mutable */\
      struct color *mclr = find_mutable(w, (clr).id);\
      if (mclr) {\
         red = mclr->r;\
         green = mclr->g;\
         blue = mclr->b;\
         alpha = mclr->a;\
         }\
      else { /* mutable not found, use {clr}... should this be a fail? */\
         red = (clr).r;\
         green = (clr).g;\
         blue = (clr).b;\
         alpha = (clr).a;\
         }\
      }\
   else {\
      red = (clr).r;\
      green = (clr).g;\
      blue = (clr).b;\
      alpha = (clr).a;\
      }\
   } while(0)

/*
 * Exactly like GetColorUS(), but returns unsigned char (UC)
 */
#define GetColorUC(w, clr, red, green, blue, alpha) do {\
   if ((clr).id < 0) { /* have a mutable */\
      struct color *mclr = find_mutable(w, (clr).id);\
      if (mclr) {\
         red = USToUC(mclr->r);\
         green = USToUC(mclr->g);\
         blue = USToUC(mclr->b);\
         alpha = USToUC(mclr->a);\
         }\
      else { /* mutable not found, use {clr}... should this be a fail? */\
         red = (clr).r;\
         green = (clr).g;\
         blue = (clr).b;\
         alpha = (clr).a;\
         }\
      }\
   else {\
      red = USToUC((clr).r);\
      green = USToUC((clr).g);\
      blue = USToUC((clr).b);\
      alpha = USToUC((clr).a);\
      }\
   } while(0)

/*
 * For copying a {struct color} to another
 */
#define CopyColor(dest, src) do {\
   strcpy((dest).name, (src).name);\
   (dest).r = (src).r;\
   (dest).g = (src).g;\
   (dest).b = (src).b;\
   (dest).a = (src).a;\
   (dest).id = (src).id;\
   } while(0)

/*
 * Comparing {struct color}. Returns 1 for match, 0 for different
 */
#define ColorEqual(clr1, clr2) (\
   ((clr1).r == (clr2).r && (clr1).g == (clr2).g &&\
    (clr1).b == (clr2).b && (clr1).a == (clr2).a)\
   || ((clr1).id && (clr2).id && (clr1).id == (clr2).id)\
   )

/*
 * Type conversion macros (for gamma correction)
 */

#define USToUC(ushort) (unsigned char)(ushort >> 8)
#define USToUC_V4(dest, src) do {\
   dest[0] = USToUC(src[0]);\
   dest[1] = USToUC(src[1]);\
   dest[2] = USToUC(src[2]);\
   dest[3] = USToUC(src[3]);\
   } while(0)

/* GLfloat is a C float */
#define GLFToUS(flt) (unsigned short)((flt)*65535)
#define USToGLF(ushort) (GLfloat)((ushort)/65535.0)
#define USToGLF_V4(dest, src) do {\
   dest[0] = USToGLF(src[0]);\
   dest[1] = USToGLF(src[1]);\
   dest[2] = USToGLF(src[2]);\
   dest[3] = USToGLF(src[3]);\
   } while(0)

#define GLFToUC(glf) (unsigned char) (255.0*(glf))
#define UCToGLF(uchar) (GLfloat) ((uchar)/255.0)

/*
 * For gamma encode/decode color operations. 
 * 
 * Unicon color values are in linear color units. All computer screens
 * convert from linear units to sRGB units by using the value gamma. Thus,
 * The Unicon color values (linear) are converted to sRGB space and given
 * to OpenGL (which has no notion of gamma correction, unless using ver. 4+).
 * 
 * Encoding transforms from linear-to-sRGB space.
 * Decoding transforms from sRGB-to-linear space.
 * Assume that gamma has no effect on transparency (alpha).
 */
#define EncodeGamma(flt, gamma) pow(flt, 1/gamma)
#define DecodeGamma(flt, gamma) pow(flt, gamma)

/*
 * Specifically for gamma correction for pixmaps used in gl_strimage()
 * Takes an unsigned short, converts it to a GLfloat, applies gamma
 * correction, then converts the GLfloat to unsigned char.
 */
#define EncodeGammaUSToUC(ushort, gamma) \
   (unsigned char)(GLFToUC(EncodeGamma(USToGLF(ushort),gamma)))
#define DecodeGammaUSToUC(ushort, gamma) \
   (unsigned char)(GLFToUC(DecodeGamma(USToGLF(ushort),gamma)))

#define EncodeGammaUS(ushort, gamma) \
   (unsigned short)(GLFToUS(EncodeGamma(USToGLF(ushort),gamma)))
#define EncodeGammaUS_V4(dest, src, gamma) do {\
   dest[0] = EncodeGammaUS(src[0], gamma);\
   dest[1] = EncodeGammaUS(src[1], gamma);\
   dest[2] = EncodeGammaUS(src[2], gamma);\
   dest[3] = src[3];\
   } while(0)

#define EncodeGammaUSToUC_V4(dest, src, gamma) do {\
   dest[0] = EncodeGammaUS(src[0], gamma) >> 8;\
   dest[1] = EncodeGammaUS(src[1], gamma) >> 8;\
   dest[2] = EncodeGammaUS(src[2], gamma) >> 8;\
   dest[3] = src[3] >> 8;\
   } while(0)

/*
 * Decodes gamma correction in the form of (unsigned short). Converts
 * to a float to perform correction and converts back to (unsigned 
 * short).
 */
#define DecodeGammaUS(ushort, gamma) \
   (unsigned short) GLFToUS(DecodeGamma(USToGLF(ushort), gamma))

/* Same as above but for unsigned char */
#define DecodeGammaUC(uchar, gamma) \
   (unsigned char) GLFToUC(DecodeGamma(UCToGLF(uchar), gamma))

#define EncodeGamma_V4(dest, src, gamma) do {\
   dest[0] = EncodeGamma(src[0], gamma);\
   dest[1] = EncodeGamma(src[1], gamma);\
   dest[2] = EncodeGamma(src[2], gamma);\
   dest[3] = src[3];\
   } while(0)

#define DecodeGamma_V4(dest, src, gamma) do {\
   dest[0] = DecodeGamma(src[0], gamma);\
   dest[1] = DecodeGamma(src[1], gamma);\
   dest[2] = DecodeGamma(src[2], gamma);\
   dest[3] = src[3];\
   } while(0)


/*
 * Sets the color specified by {color} to sRGB space with gamma as the
 * "foreground" (current OpenGL) color. 
 * {color} must be an array of unsigned short of size 4.
 */
#define SetColorState(color, gamma) do {\
   GLfloat norm[4], normg[4];\
   USToGLF_V4(norm, color);\
   EncodeGamma_V4(normg, norm, gamma);\
   glColor4fv(normg);\
   } while(0)

/* Let's avoid magic numbers */
#define FG 1
#define BG 0

/*
 * Gets a context color (fg or bg) depending on the reverse attribute 
 */
#define GetContextColorUS(w, is_fg, r, g, b, a) do {\
   wcp wcr = &((w)->window->wcrender);\
   if (wcr->reverse) {\
      if (is_fg)\
         GetColorUS(w, wcr->glbg, r, g, b, a);\
      else\
         GetColorUS(w, wcr->glfg, r, g, b, a);\
      }\
   else {\
      if (is_fg)\
         GetColorUS(w, wcr->glfg, r, g, b, a);\
      else\
         GetColorUS(w, wcr->glbg, r, g, b, a);\
      }\
   } while(0)

#define GetContextColorUC(w, is_fg, r, g, b, a) do {\
   wcp wcr = &((w)->window->wcrender);\
   if (wcr->reverse) {\
      if (is_fg)\
         GetColorUC(w, wcr->glbg, r, g, b, a);\
      else\
         GetColorUC(w, wcr->glfg, r, g, b, a);\
      }\
   else {\
      if (is_fg)\
         GetColorUC(w, wcr->glfg, r, g, b, a);\
      else\
         GetColorUC(w, wcr->glbg, r, g, b, a);\
      }\
   } while(0)

/*
 * This macro sets the OpenGL color state based on {w}'s render context's
 * reverse and gamma attributes. {Drawop} is specified. {is_fg} specifies
 * whether the render context's fg or bg color is the desired drawing 
 * color. 
 */
#define SetDrawopColorState(w, drawop, is_fg) do {\
   wsp ws = (w)->window;\
   wcp wcr = &(ws->wcrender);\
   unsigned short color[4];\
\
   if (is_fg)\
      GetContextColorUS(w, FG, color[0], color[1], color[2], color[3]);\
   else\
      GetContextColorUS(w, BG, color[0], color[1], color[2], color[3]);\
\
   /* set fg to (fg ^ bg) */\
   if (drawop == GL2D_DRAWOP_REVERSE) {\
      unsigned short bg[4];\
      if (is_fg)\
         GetContextColorUS(w, BG, bg[0], bg[1], bg[2], bg[3]);\
      else\
         GetContextColorUS(w, FG, bg[0], bg[1], bg[2], bg[3]);\
\
      /* calculate xor */\
      color[0] = color[0] ^ bg[0];\
      color[1] = color[1] ^ bg[1];\
      color[2] = color[2] ^ bg[2];\
      color[3] = 65535; /* transparency is disabled for "xor" */\
      }\
   SetColorState(color, wcr->gamma);\
   } while(0)

/* 
 * Clear screen to either the fg or bg color. 
 * Accounts for gamma and reverse.
 */
#define ClearScreenToColor(w, is_fg) do {\
   unsigned short clr[4];\
   GLfloat norm[4], normg[4];\
   GetContextColorUS(w,is_fg,clr[0],clr[1],clr[2],clr[3]);\
   USToGLF_V4(norm, clr);\
   EncodeGamma_V4(normg, norm, (w)->window->wcrender.gamma);\
   glDepthRange(0,1.0);\
   glClearColor(normg[0], normg[1], normg[2], normg[3]);\
   glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);\
   } while(0)

/*
 * Rendering macros 
 */

/* 
 * The RenderRealarray*() family of macros are for rendering geometric
 * primitives
 */

/*
 * RenderRealarray(double *v, int n)
 * Renders (v) which is an array of 2d coordinates of size (n).
 */
#ifdef GL2D_DRAWARRAYS
#define RenderRealarray(v, n) do {\
   glEnableClientState(GL_VERTEX_ARRAY);\
   glVertexPointer(2, GL_DOUBLE, 0, (void *) &(v)[1]);\
   glDrawArrays((v)[0], 0, (n-1)/2);\
   glDisableClientState(GL_VERTEX_ARRAY);\
   } while(0)
#else /* GL2D_DRAWARRAYS */
#define RenderRealarray(v, n) do {\
   int i;\
   glBegin(v[0]);\
   for (i = 1; i < n; i+=2)\
      glVertex2d((GLdouble)v[i], (GLdouble)v[i+1]);\
   glEnd();\
   } while(0)
#endif /* GL2D_DRAWARRAYS */

#define RenderRealarrayFillstyle(w, v, n, stencil_mask) do {\
   switch ((w)->window->wcrender.fillstyle) {\
      case GL2D_FILL_SOLID:\
         SetStencilFunc(w, stencil_mask);\
         RenderRealarray(v, n);\
         break;\
      case GL2D_FILL_MASKED:\
         SetStencilFunc(w, stencil_mask | GL2D_PATT_BIT);\
         RenderRealarray(v, n);\
         break;\
      case GL2D_FILL_TEXTURED:\
         SetStencilFunc(w, stencil_mask);\
         SetDrawopColorState(w, wcr->drawop, BG);\
         RenderRealarray(v, n);\
         SetStencilFunc(w, stencil_mask | GL2D_PATT_BIT);\
         SetDrawopColorState(w, wcr->drawop, FG);\
         RenderRealarray(v, n);\
         break;\
      default:\
         return Failed;\
         break;\
      }\
   DefaultStencilFunc(w);\
   } while(0)

#define RenderRealarrayLinestyle(w, v, n, vseg, nseg) do {\
   int linestyle = (w)->window->wcrender.linestyle;\
   if (linestyle == GL2D_LINE_SOLID) {\
      RenderRealarray(v, n);\
      }\
   else {\
      if (linestyle == GL2D_LINE_STRIPED) {\
         int drawop = (w)->window->wcrender.drawop;\
         SetDrawopColorState(w, drawop, BG);\
         RenderRealarray(v, n); \
         SetDrawopColorState(w, drawop, FG);\
         }\
      RenderRealarray(vseg, nseg);\
      }\
   } while(0)



/*
 * For the following *Render*Rect() macros:
 * (x1, y1) specifies the top left corner and (x2, y2) specifies the bottom 
 * right corner. The rectangles are rendered to be front facing 
 * (counterclockwise).
 * These macros are used for rendering image primitives
 */
#define _RenderFilledRect(wx1, wy1, wx2, wy2, near) do {\
   glBegin(GL_TRIANGLE_FAN);\
   glVertex3d((GLdouble)wx1,(GLdouble)wy1,(GLdouble)near);\
   glVertex3d((GLdouble)wx1,(GLdouble)wy2,(GLdouble)near);\
   glVertex3d((GLdouble)wx2,(GLdouble)wy2,(GLdouble)near);\
   glVertex3d((GLdouble)wx2,(GLdouble)wy1,(GLdouble)near);\
   glEnd();\
   } while(0)

#define RenderFilledRect(x, y, wd, ht, near) do {\
   double wx1, wy1, wx2, wy2;\
   wx1 = GLWORLDCOORD_X(w, x);\
   wy1 = GLWORLDCOORD_Y(w, y);\
   wx2 = GLWORLDCOORD_X(w, x+wd);\
   wy2 = GLWORLDCOORD_Y(w, y+ht);\
   _RenderFilledRect(wx1, wy1, wx2, wy2, near);\
   } while(0)

#define _RenderTexturedRect(w, x, y, wd, ht, texwd, texht, near) do {\
   int drawop;\
   double wx1, wy1, wx2, wy2;\
   float tx1, ty1, tx2, ty2;\
\
   tx1 = ty2 = 0.0;\
   tx2 = (float)wd/(float)texwd;\
   ty1 = (float)ht/(float)texht;\
   wx1 = GLWORLDCOORD_X(w, x);\
   wy1 = GLWORLDCOORD_Y(w, y);\
   wx2 = GLWORLDCOORD_X(w, x+wd);\
   wy2 = GLWORLDCOORD_Y(w, y+ht);\
\
   glBegin(GL_TRIANGLE_FAN);\
   glTexCoord2f(tx1,ty1); glVertex3d(wx1,wy1,near);\
   glTexCoord2f(tx1,ty2); glVertex3d(wx1,wy2,near);\
   glTexCoord2f(tx2,ty2); glVertex3d(wx2,wy2,near);\
   glTexCoord2f(tx2,ty1); glVertex3d(wx2,wy1,near);\
   glEnd();\
   } while(0)

#define RenderTexturedRect(w, x, y, wd, ht, texwd, texht, near) do {\
   glEnable(GL_TEXTURE_2D);\
   glDisable(GL_TEXTURE_GEN_S);\
   glDisable(GL_TEXTURE_GEN_T);\
   _RenderTexturedRect(w,x,y,wd,ht,texwd,texht,near);\
   glEnable(GL_TEXTURE_GEN_S);\
   glEnable(GL_TEXTURE_GEN_T);\
   glDisable(GL_TEXTURE_2D);\
   } while(0)


#define FILL_BG 1
#define TRANSP_BG 0
#define RenderTexturedBitmapRect(w, x, y, wd, ht, texwd, texht, near, fillbg)\
   do {\
   wcp wcr = &(w->window->wcrender);\
   double wx1, wy1, wx2, wy2;\
   float tx1, ty1, tx2, ty2;\
\
   tx1 = ty2 = 0.0;\
   tx2 = (float)wd/(float)texwd;\
   ty1 = (float)ht/(float)texht;\
   wx1 = GLWORLDCOORD_X(w, x);\
   wy1 = GLWORLDCOORD_Y(w, y);\
   wx2 = GLWORLDCOORD_X(w, x+wd);\
   wy2 = GLWORLDCOORD_Y(w, y+ht);\
\
   if (fillbg) {\
      SetDrawopColorState(w, wcr->drawop, BG);\
      _RenderFilledRect(wx1, wy1, wx2, wy2, near);\
      SetDrawopColorState(w, wcr->drawop, FG);\
      }\
\
   glEnable(GL_TEXTURE_2D);\
   glDisable(GL_TEXTURE_GEN_S);\
   glDisable(GL_TEXTURE_GEN_T);\
\
   /* Apply pattern to stencil buffer by using texture and alpha test*/\
   glColorMask(GL_FALSE, GL_FALSE, GL_FALSE, GL_FALSE);\
   glDepthMask(GL_FALSE);\
   EnableStencilWrite(GL2D_DRAW_BIT,0,GL_REPLACE);\
\
   /* first pass - render texture to stencil buffer */\
   glBegin(GL_TRIANGLE_FAN);\
   glTexCoord2f(tx1,ty1); glVertex3d(wx1,wy1,near);\
   glTexCoord2f(tx1,ty2); glVertex3d(wx1,wy2,near);\
   glTexCoord2f(tx2,ty2); glVertex3d(wx2,wy2,near);\
   glTexCoord2f(tx2,ty1); glVertex3d(wx2,wy1,near);\
   glEnd();\
\
   /* disable stencil writing */\
   DisableStencilWrite();\
   glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);\
   glDepthMask(GL_TRUE);\
\
   glEnable(GL_TEXTURE_GEN_S);\
   glEnable(GL_TEXTURE_GEN_T);\
   glDisable(GL_TEXTURE_2D);\
\
   /* second pass using stencil buffer */\
   SetStencilFunc(w, GL2D_DRAW_BIT);\
   _RenderFilledRect(wx1, wy1, wx2, wy2, near);\
   DefaultStencilFunc(w);\
   } while(0)

#define InitTexture2d(texptr) do {\
   glGenTextures(1, texptr);\
/*glprintf("generated texid %u\n",*texptr);*/\
   UGLBindTexture(GL_TEXTURE_2D, *texptr);\
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);\
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);\
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);\
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);\
   glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);\
   } while(0)

/*
 * Structures
 */ 

/*
 * For OpenGL, colors need not be allocated. Colors are defined with
 * RGBA values only. Use clamped doubles (0.0 - 1.0) for RGBA since 
 * they are more representative to how colors are interpreted by machines.
 *
 * Negative (id) values indicate a mutable color, otherwise not mutable. 
 */ 

/*
 * Get font size values in terms of pixels (px). Returns integer value.
 * These macros should only be used on a face whose size has been 
 * initialized.
 *
 * ascender and descender are in 26.6 fixed point units... or not.
 * may be in ems
 *
 * As a design note, why don't we just unify these font macros
 * by using the ascent, descent, maxwidth, and height fields in 
 * struct _wfont?
 */
#if HAVE_LIBFREETYPE
#define FT_ASCENT_I64(face) (int)((face)->size->metrics.ascender)
#define FT_DESCENT_I64(face) (int)((face)->size->metrics.descender)
#define FT_FWIDTH_I64(face) (int)((face)->size->metrics.max_advance)
#define FT_FHEIGHT_I64(face) (int)((face)->size->metrics.ascender -\
   (face)->size->metrics.descender)

#define FT_ASCENT(face) (int)((face)->size->metrics.ascender >> 6)
#define FT_DESCENT(face) (int)((face)->size->metrics.descender >> 6)
#define FT_FWIDTH(face) (int)((face)->size->metrics.max_advance >> 6)
#define FT_FHEIGHT(face) \
   (int)(((face)->size->metrics.ascender-(face)->size->metrics.descender) >> 6)
#else					/* HAVE_LIBFREETYPE */
/* placeholders for MSWin and OSX until implemented */
#define FT_ASCENT(face) 1
#define FT_DESCENT(face) 1
#define FT_FWIDTH(face) 1
#define FT_FHEIGHT(face) 1
#endif					/* HAVE_LIBFREETYPE */

/*
 * Macors check for {wc->font->face} for legacy 3D subwindow support.
 */
#if HAVE_LIBFREETYPE

#define GL_ASCENT(w) \
   ((w)->context->font->face ? FT_ASCENT((w)->context->font->face) : 0)
#define GL_DESCENT(w) \
   ((w)->context->font->face ? FT_DESCENT((w)->context->font->face) : 0)
#define GL_FWIDTH(w) \
   ((w)->context->font->face ? FT_FWIDTH((w)->context->font->face) : 0)
#define GL_FHEIGHT(w) \
   ((w)->context->font->face ? FT_FHEIGHT((w)->context->font->face) : 0)

#else					/* HAVE_LIBFREETYPE */

#define GL_ASCENT(w) ((w)->context->font->ascent)
#define GL_DESCENT(w) ((w)->context->font->descent)
/* Once this implementation gets ported to Windows, unify maxwidth/charwidth */
#ifdef XWindows
#define GL_FWIDTH(w) ((w)->context->font->maxwidth)
#endif					/* XWindows */
#ifdef MSWindows
#define GL_FWIDTH(w) ((w)->context->font->charwidth)
#endif					/* MSWindows */
#define GL_FHEIGHT(w) ((w)->context->font->height)

#endif					/* HAVE_LIBFREETYPE */

#define GL_LEADING(w) ((w)->context->leading)

#if HAVE_LIBFREETYPE

#define GL_ROWTOY(w,row) \
   ((w)->context->font->face ? ((row-1) * GL_LEADING(w) + GL_ASCENT(w)) : 0)
#define GL_COLTOX(w,col) \
   ((w)->context->font->face ? ((col-1) * GL_FWIDTH(w)) : 0)
#define GL_YTOROW(w,y) \
   ((w)->context->font->face ? \
   ((y>0) ? ((y)/GL_LEADING(w)+1) : ((y)/GL_LEADING(w))) : 0)
#define GL_XTOCOL(w,x) \
   ((w)->context->font->face ? (!GL_FWIDTH(w) ? (x) : ((x) / GL_FWIDTH(w))) : 0)
#define GL_MAXDESCENDER(w) ((w)->context->font->face ? GL_DESCENT(w) : 0)

#else					/* HAVE_LIBFREETYPE */

#define GL_ROWTOY(w,row) \
   ((w)->context->font ? ((row-1) * GL_LEADING(w) + GL_ASCENT(w)) : 0)
#define GL_COLTOX(w,col) \
   ((w)->context->font ? ((col-1) * GL_FWIDTH(w)) : 0)
#define GL_YTOROW(w,y) \
   ((w)->context->font ? \
   ((y>0) ? ((y)/GL_LEADING(w)+1) : ((y)/GL_LEADING(w))) : 0)
#define GL_XTOCOL(w,x) \
   ((w)->context->font ? (!GL_FWIDTH(w) ? (x) : ((x) / GL_FWIDTH(w))) : 0)
#define GL_MAXDESCENDER(w) ((w)->context->font ? GL_DESCENT(w) : 0)

#endif					/* HAVE_LIBFREETYPE */

/* 
 * compute text pixel width
 */
#define GL_TEXTWIDTH(w, s, len) drawstringhelper(w, 0, 0, 0, s, len, 0, 0)
