/*
 * File: fwindow.r - Icon graphics interface
 *
 * Contents: Active, Bg, Color, CopyArea, Couple,
 *  DrawArc, DrawCircle, DrawCurve, DrawImage, DrawLine,
 *  DrawSegment, DrawPoint, DrawPolygon, DrawString,
 *  DrawRectangle, DrawTorus, DrawCylinder, DrawDisk, DrawCube,
 *  DrawSphere,  EraseArea, Event, Fg, FillArc, FillCircle,
 *  FillRectangle, FillPolygon, Font, FreeColor, GotoRC, GotoXY,
 *  NewColor, Pattern, PaletteChars, PaletteColor, PaletteKey,
 *  Pending, PopMatrix, PushMatrix, QueryPointer, ReadImage, Rotate,
 *  Scale, Translate, TextWidth, Texture, Texcoord, Uncouple,
 *  WAttrib, WDefault, WFlush, WSync, WriteImage
 */

#ifdef Graphics

"Active() - produce the next active window"

function{0,1} Active()
   abstract {
      return file
      }
   body {
      wsp ws;
      if (!wstates || !(ws = getactivewindow())) fail;
      return ws->filep;
      }
end


"Alert(w,volume) - Alert the user"

function{1} Alert(argv[argc])
   abstract {
      return file
      }
   body {
      wbp w;
      int warg = 0;
      C_integer volume;
      OptWindow(w);

      if (argc == warg) volume = 0;
      else if (!def:C_integer(argv[warg], 0, volume))
        runerr(101, argv[warg]);
#ifdef GraphicsGL
      if (w->window->is_gl)
         gl_walert(w, volume);
      else
#endif                                  /* GraphicsGL */
      walert(w, volume);
      ReturnWindow;
      }
end

"Bg(w,s) - background color"

function{0,1} Bg(argv[argc])
   abstract {
      return string
      }
   body {
      wbp w;
      char sbuf1[MaxCvtLen];
      int len;
      tended char *tmp;
      int warg = 0;
#ifdef Graphics3D
      int is_texture=0;
      int texhandle;
#endif                                  /* Graphics3D */
      OptTexWindow(w);
#ifdef Graphics3D
      if (is_texture) {
         warg=1;
         (void) texhandle;  /* silence "not used" compiler warning */
         }
#endif                                  /* Graphics3D */

      /*
       * If there is a (non-window) argument we are setting by
       * either a mutable color (negative int) or a string name.
       */
      if (argc - warg > 0) {
         if (is:integer(argv[warg])) {    /* mutable color or packed RGB */
#ifdef GraphicsGL
            if (w->window->is_gl) {
               if (gl_isetbg(w, IntVal(argv[warg])) == Failed) fail;
               }
            else
#endif                                  /* GraphicsGL */
            if (isetbg(w, IntVal(argv[warg])) == Failed) fail;
            }
         else {
            if (!cnv:C_string(argv[warg], tmp))
               runerr(103,argv[warg]);
#ifdef GraphicsGL
            if (w->window->is_gl) {
               if (gl_setbg(w, tmp) == Failed) fail;
               }
            else
#endif                                  /* GraphicsGL */
            if (setbg(w, tmp) == Failed) fail;
            }

         }

      /*
       * In any event, this function returns the current background color.
       */
#ifdef GraphicsGL
      if (w->window->is_gl)
         gl_getbg(w, sbuf1);
      else
#endif                                  /* GraphicsGL */
      getbg(w, sbuf1);
      len = strlen(sbuf1);
      Protect(tmp = alcstr(sbuf1, len), runerr(0));
      return string(len, tmp);
      }
end


"Clip(w, x, y, w, h) - set context clip rectangle"

function{1} Clip(argv[argc])
   abstract {
      return file
      }
   body {
      wbp w;
      int warg = 0, r;
      C_integer x, y, width, height;
      wcp wc;
      OptWindow(w);

      wc = w->context;

      if (argc <= warg) {
         wc->clipx = wc->clipy = 0;
         wc->clipw = wc->cliph = -1;
#ifdef GraphicsGL
         if (w->window->is_gl)
            gl_unsetclip(w);
         else
#endif                                  /* GraphicsGL */
         unsetclip(w);
         }
      else {
         r = rectargs(w, argc, argv, warg, &x, &y, &width, &height);
         if (r >= 0)
            runerr(101, argv[r]);
         wc->clipx = x;
         wc->clipy = y;
         wc->clipw = width;
         wc->cliph = height;
#ifdef GraphicsGL
         if (w->window->is_gl)
            gl_setclip(w);
         else
#endif                                  /* GraphicsGL */
         setclip(w);
         }

      ReturnWindow;
      }
end


"Clone(w, attribs...) - create a new context bound to w's canvas"

function{1} Clone(argv[argc])
   abstract {
#ifdef Graphics3D
      return file ++ record
#else
      return file
#endif                                  /* Graphics3D */
      }
   body {
      wbp w, w2, new_w;
      int warg = 0, n;
      tended struct descrip sbuf, sbuf2;
      char answer[128];
      int child_window=0;
#ifdef Graphics3D
      int is_texture=0;
      int texhandle;
#endif                                  /* Graphics3D */
      tended struct descrip f;
      tended struct b_record *rp;

      OptTexWindow(w);
#if 0 /* Graphics3D */
      if (is_texture){
         int nfields, draw_code;
         static dptr constr;

         if (texhandle >= w->context->display->ntextures) runerr(101, argv[warg]);

         if (!constr && !(constr = rec_structor3d(GL3D_TEXTURE)))
            syserr("failed to create opengl record constructor");
         nfields = (int) BlkD(*constr, Proc)->nfields;

         draw_code = si_s2i(redraw3Dnames, "Texture");
         if (draw_code == -1)
            fail;

         Protect(rp = alcrecd(nfields, BlkLoc(*constr)), runerr(0));
         MakeInt(draw_code, &(rp->fields[1]));

         MakeStr("Texture", 7, &(rp->fields[0]));
         f.dword = D_Record;
         f.vword.bptr = (union block *)rp;

         MakeInt(texhandle, &(rp->fields[2]));
         }
#endif                                  /* Graphics3D */

      Protect(new_w = alc_wbinding(), runerr(0));

      for (n=warg; n<argc; n++) {
         if (!is:string(argv[n])) runerr(103, argv[n]);

         if (StrLen(argv[n])==2 && !strncmp(StrLoc(argv[n]), "gl", 2)){
#ifdef Graphics3D
            child_window = CHILD_WIN3D;
#else                                   /* Graphics3D */
            runerr(150, argv[n]);
#endif                                  /* Graphics3D */
            argv[n] = nulldesc;
            break;
            }
         else if (StrLen(argv[n])==2 && !strncmp(StrLoc(argv[n]), "gt", 2)){
#ifdef Graphics3D
            child_window = CHILD_WINTEXTURE;
#else                                   /* Graphics3D */
            runerr(150, argv[n]);
#endif                                  /* Graphics3D */
            argv[n] = nulldesc;
            break;
            }

         else if (StrLen(argv[n])==1 && !strncmp(StrLoc(argv[n]), "g", 1)){
            child_window = CHILD_WIN2D;
            argv[n] = nulldesc;
            break;
            }
         }

#ifdef Graphics3D
      if (is_texture == TEXTURE_RECORD) {
         child_window = CHILD_WINTEXTURE + texhandle;
         }
#endif                                  /* Graphics3D */

      /* check for optional second window arg */
      if (argc>warg && is:file(argv[warg])) {
         if ((BlkD(argv[warg],File)->status & Fs_Window) == 0)
            runerr(140,argv[warg]);
         if ((BlkLoc(argv[warg])->File.status & (Fs_Read|Fs_Write)) == 0)
            runerr(142,argv[warg]);
         if (ISCLOSED(BlkLoc(argv[warg])->File.fd.wb))
            runerr(142,argv[warg]);
         w2 = (wbp)BlkD(argv[warg],File)->fd.wb;
         warg++;
         }
      else {
         w2 = w;
         }

      /* initialize new window's canvas and context */
      if (!child_window) {
         new_w->window = w->window;
         new_w->window->refcount++;
#ifdef GraphicsGL
         if (w->window->is_gl) {
            Protect(new_w->context = gl_clone_context(w2),runerr(0));
            }
         else
#endif                                  /* GraphicsGL */
         Protect(new_w->context = clone_context(w2),runerr(0));
         }
      else {
#ifdef GraphicsGL
         /* Allow legacy X11 to work with OpenGL 3D windows */
         if (w->window->is_gl || child_window==CHILD_WIN3D) {
            if (!gl_child_window_stuff(new_w, w, child_window)) runerr(0);
            }
         else
#endif                                  /* GraphicsGL */
         if (!child_window_stuff(new_w, w, child_window)) runerr(0);
         }

#ifdef GraphicsGL
      if (new_w->window->is_gl) {
         if (!new_w->window->initAttrs)
            new_w->window->initAttrs = 1;
         else
            glprintf("Clone(): need a mutex lock\n");
         }
#endif                                  /* GraphicsGL */
      for (n = warg; n < argc; n++) {
         if (!is:null(argv[n])) {
            if (!cnv:tmp_string(argv[n], sbuf))  /* sbuf not allocated */
               runerr(109, argv[n]);
            switch (wattrib(new_w, StrLoc(argv[n]), StrLen(argv[n]), &sbuf2, answer)) {
            case Failed: fail;
            case RunError: runerr(0, argv[n]);
               }
            }
         }
#ifdef GraphicsGL
      if (new_w->window->is_gl) {
         if (new_w->window->initAttrs)
            new_w->window->initAttrs = 0;
         else
            glprintf("Clone(): need a mutex unlock\n");
         }

      if (new_w->window->is_gl) {
         if (child_window)
            gl_wmap(new_w);
         else
            MakeCurrent(new_w);
         }
#endif                                  /* GraphicsGL */

      Protect(BlkLoc(result) =
              (union block *)alcfile((FILE *)new_w, Fs_Window|Fs_Read|Fs_Write
#ifdef Graphics3D
                             | (w->context->rendermode == UGL3D?Fs_Window3D:0)
#endif                                  /* Graphics3D */
#ifdef GraphicsGL
                             | (w->window->is_gl?Fs_WinGL2D:0)
#endif                                  /* GraphicsGL */
                                   , &emptystr),runerr(0));
      result.dword = D_File;

#ifdef GraphicsGL
      /*
       * link in the Icon file value so this window can find it
       */
      if (new_w->window->is_gl && child_window)
         linkfiletowindow(new_w, BlkD(result,File));
#endif                                  /* GraphicsGL */

#if 0 /* Graphics3D */
      if (is_texture){
         rp->fields[3] = result;
         return f;
         }

#endif                                  /* Graphics3D */

      return result;
      }
end



"Color(argv[]) - return or set color map entries"

function{0,1} Color(argv[argc])
   abstract {
      return file ++ string
      }
   body {
      wbp w;
      int warg = 0;
      int i, len;
      C_integer n;
      char *colorname, *srcname;
      tended char *tmp;

      OptWindow(w);
      if (argc - warg == 0) runerr(101);

      if (argc - warg == 1) {                   /* if this is a query */
         CnvCInteger(argv[warg], n)
#ifdef GraphicsGL
         if (w->window->is_gl) {
            if ((colorname = gl_get_mutable_name(w, n)) == NULL)
               fail;
            }
         else
#endif                                  /* GraphicsGL */
         if ((colorname = get_mutable_name(w, n)) == NULL)
            fail;
         len = strlen(colorname);
         Protect(tmp = alcstr(colorname, len), runerr(0));
         return string(len, tmp);
         }

      CheckArgMultiple(2);

      for (i = warg; i < argc; i += 2) {
         CnvCInteger(argv[i], n)
#ifdef GraphicsGL
         if (w->window->is_gl) {
            if ((colorname = gl_get_mutable_name(w, n)) == NULL)
               fail;
            }
         else
#endif                                  /* GraphicsGL */
         if ((colorname = get_mutable_name(w, n)) == NULL)
            fail;

         if (is:integer(argv[i+1])) {           /* copy another mutable  */
            if (IntVal(argv[i+1]) >= 0)
               runerr(205, argv[i+1]);          /* must be negative */
#ifdef GraphicsGL
            if (w->window->is_gl) {
               if ((srcname = gl_get_mutable_name(w, IntVal(argv[i+1]))) == NULL)
                  fail;
               if (gl_set_mutable(w, n, srcname) == Failed) fail;
               }
            else
#endif                                  /* GraphicsGL */
             {
             if ((srcname = get_mutable_name(w, IntVal(argv[i+1]))) == NULL)
                fail;
             if (set_mutable(w, n, srcname) == Failed) fail;
             }
            strcpy(colorname, srcname);
            }

         else {                                 /* specified by name */
            tended char *tmp;
            if (!cnv:C_string(argv[i+1],tmp))
               runerr(103,argv[i+1]);

#ifdef GraphicsGL
            if (w->window->is_gl) {
               if (gl_set_mutable(w, n, tmp) == Failed) fail;
               }
            else
#endif                                  /* GraphicsGL */
            if (set_mutable(w, n, tmp) == Failed) fail;
            strcpy(colorname, tmp);
            }
         }

      ReturnWindow;
      }
end


"ColorValue(w,s) - produce RGB components from string color name"

function{0,1} ColorValue(argv[argc])
   abstract {
      return string
      }
   body {
      wbp w;
      C_integer n;
      int warg = 0, len;
      long r, g, b, a = 65535;
      tended char *s;
      char tmp[32], *t;

      if (is:file(argv[0]) && (BlkD(argv[0],File)->status & Fs_Window)) {
         w = BlkD(argv[0],File)->fd.wb; /* explicit window */
         warg = 1;
         }
      else if (is:file(kywd_xwin[XKey_Window]) &&
            ((BlkD(kywd_xwin[XKey_Window],File)->status &
             (Fs_Window|Fs_Read))==(Fs_Window|Fs_Read))) {
         w = BlkD(kywd_xwin[XKey_Window],File)->fd.wb;  /* &window */
         }
      else {
         w = NULL;                      /* no window (but proceed anyway) */
         }

      if (!(warg < argc))
         runerr(103);

      if (cnv:C_integer(argv[warg], n)) {
         if (w != NULL && (t = get_mutable_name(w, n)))
            Protect(s = alcstr(t, (word)strlen(t)+1), runerr(306));
         else
            fail;
         }
      else if (!cnv:C_string(argv[warg], s))
         runerr(103,argv[warg]);

      if (parsecolor(w, s, &r, &g, &b, &a) == Succeeded) {
         if (a < 65535)
            sprintf(tmp,"%ld,%ld,%ld,%ld", r, g, b, a);
         else
            sprintf(tmp,"%ld,%ld,%ld", r, g, b);
         len = strlen(tmp);
         Protect(s = alcstr(tmp,len), runerr(306));
         return string(len, s);
         }
      fail;
      }
end


"CopyArea(w,w2,x,y,width,height,x2,y2) - copy area"

function{0,1} CopyArea(argv[argc]) /* w,w2,x,y,width,height,x2,y2 */
   abstract {
      return file
      }
   body {
      int warg = 0, n, r;
      C_integer x, y, width, height, x2, y2, width2, height2;
      wbp w, w2;
#ifdef Graphics3D
      int is_texture=0 /* src */, dest_is_texture=0, base=0;
      int texhandle=0 /* src */, dest_texhandle;
#endif                                  /* Graphics3D */

      OptTexWindow(w);

      /*
       * w is the source window, and w2 is a destination.  There are 4 cases:
       * 1. window to window (handled by copyArea),
       * 2. window to texture (handled by TexCopyArea),
       * 3. texture to window (not handled),
       * 4. texture to texture (not handled).
       */

#ifdef Graphics3D
   if (w->context->rendermode == UGL3D) {
      if (argc>warg && is:record(argv[warg])) {
        /* set a boolean flag, use a texture */
        dest_is_texture=1;
        /* Get the Window from Texture record */
        w2 = BlkD(BlkD(argv[warg],Record)->fields[3],File)->fd.wb;
        /* Pull out the texture handler */
        dest_texhandle = IntVal(BlkD(argv[warg],Record)->fields[2]);
        /* get the context from the window binding */
        warg++;
      }

      if (argc-warg<4) /* should have at least 4 int values */
            runerr(146);

      /*
       * This is the: "w2 is a destination texture" case.
       */
      if (dest_is_texture) {
         base=warg;
         if (dest_texhandle >= w2->context->display->ntextures) runerr(102,argv[base]);
         if (!cnv:C_integer(argv[base]  , x)) runerr(102, argv[base]);
         if (!cnv:C_integer(argv[base+1], y)) runerr(102, argv[base+1]);
         if (!cnv:C_integer(argv[base+2], width)) runerr(102, argv[base+2]);
         if (!cnv:C_integer(argv[base+3], height)) runerr(102, argv[base+3]);

         if (argc-warg>4){
            if (is:null(argv[base+4])) x2=x;
            else if (!cnv:C_integer(argv[base+4], x2))
                 runerr(102, argv[base+4]);
            }
         else x2 = x;

         if (argc-warg>5){
            if (is:null(argv[base+5])) y2=y;
            else if (!cnv:C_integer(argv[base+5], y2))
                 runerr(102, argv[base+5]);
            }
         else y2 = y;

         if (is_texture) {
            /* texture to texture */
            copyareaTexToTex(w, texhandle, dest_texhandle,
                             x,y,width,height, x2,y2);

            }
         else {
            /* window to texture */
            if (TexCopyArea(w, w2, dest_texhandle, x, y, width, height, x2, y2,
                            width, height)==Failed)
               fail;
         }
         ReturnWindow;
         }
      }
#endif                                  /* Graphics3D */

      /*
       * 2nd window defaults to value of first window
       */
      if (argc>warg && is:file(argv[warg])) {
         if ((BlkD(argv[warg],File)->status & Fs_Window) == 0)
            runerr(140,argv[warg]);
         if ((BlkLoc(argv[warg])->File.status & (Fs_Read|Fs_Write)) == 0)
            runerr(142,argv[warg]);
         w2 = BlkLoc(argv[warg])->File.fd.wb;
         if (ISCLOSED(w2))
            runerr(142,argv[warg]);
         warg++;
         }
      else {
         w2 = w;
         }

      /*
       * x1, y1, width, and height follow standard conventions.
       */
      r = rectargs(w, argc, argv, warg, &x, &y, &width, &height);
      if (r >= 0)
         runerr(101, argv[r]);

      /*
       * get x2 and y2, ignoring width and height.
       */
      n = argc;
      if (n > warg + 6)
         n = warg + 6;
      r = rectargs(w2, n, argv, warg + 4, &x2, &y2, &width2, &height2);
      if (r >= 0)
         runerr(101, argv[r]);
#ifdef GraphicsGL
      if (w->window->is_gl) {
         if (gl_copyArea(w, w2, x, y, width, height, x2, y2) == RunError)
            runerr(0);
         }
      else
#endif                                  /* GraphicsGL */
      if (copyArea(w, w2, x, y, width, height, x2, y2) == Failed)
         fail;
      ReturnWindow;
      }
end

/*
 * Bind the canvas associated with w to the context
 *  associated with w2.  If w2 is omitted, create a new context.
 *  Produces a new window variable.
 */
"Couple(w,w2) - couple canvas to context"

function{0,1} Couple(w,w2)
   abstract {

      return file
      }
   body {
      tended struct descrip sbuf, sbuf2;
      wbp wb, wb_new;
      wsp ws;

      /*
       * make the new binding
       */
      Protect(wb_new = alc_wbinding(), runerr(0));

      /*
       * if w is a file, then we bind to an existing window
       */
      if (is:file(w) && (BlkD(w,File)->status & Fs_Window)) {
         wb = BlkLoc(w)->File.fd.wb;
         wb_new->window = ws = wb->window;
         if (is:file(w2) && (BlkD(w2,File)->status & Fs_Window)) {
            /*
             * Bind an existing window to an existing context,
             * and up the context's reference count.
             */
#ifdef GraphicsGL
            if (wb->window->is_gl) {
               if (gl_rebind(wb_new, BlkLoc(w2)->File.fd.wb) == Failed) fail;
               }
            else
#endif                                  /* GraphicsGL */
            if (rebind(wb_new, BlkLoc(w2)->File.fd.wb) == Failed) fail;
            wb_new->context->refcount++;
            }
         else
            runerr(140, w2);

         /* bump up refcount to ws */
         ws->refcount++;
         }
      else
         runerr(140, w);

      Protect(BlkLoc(result) =
         (union block *)alcfile((FILE *)wb_new, Fs_Window|Fs_Read|Fs_Write,
                                &emptystr),runerr(0));
      result.dword = D_File;
      return result;
      }
end

/*
 * DrawArc(w, x1, y1, width1, height1, angle11, angle21,...)
 */
"DrawArc(argv[]){1} - draw arc"

function{1} DrawArc(argv[argc])
   abstract {
      return file
      }
   body {
      wbp w;
      int i, j, r, warg = 0;
      XArc arcs[MAXXOBJS];
      C_integer x, y, width, height;
      double a1, a2;

      OptWindow(w);

      j = 0;
      for (i = warg; i < argc || i == warg; i += 6) {
         if (j == MAXXOBJS) {
#ifdef GraphicsGL
            if (w->window->is_gl) {
               if (gl_drawarcs(w, arcs, MAXXOBJS) == RunError)
                  runerr(0);
               }
            else
#endif                                  /* GraphicsGL */
            drawarcs(w, arcs, MAXXOBJS);
            j = 0;
            }
         r = rectargs(w, argc, argv, i, &x, &y, &width, &height);
         if (r >= 0)
            runerr(101, argv[r]);

         arcs[j].x = x;
         arcs[j].y = y;
         ARCWIDTH(arcs[j]) = width;
         ARCHEIGHT(arcs[j]) = height;

         /*
          * Angle 1 processing.  Computes in radians and 64'ths of a degree,
          *  bounds checks, and handles wraparound.
          */
         if (i + 4 >= argc || is:null(argv[i + 4]))
            a1 = 0.0;
         else {
            if (!cnv:C_double(argv[i + 4], a1))
               runerr(102, argv[i + 4]);
            if (a1 >= 0.0)
               a1 = fmod(a1, 2 * Pi);
            else
               a1 = -fmod(-a1, 2 * Pi);
            }
         /*
          * Angle 2 processing
          */
         if (i + 5 >= argc || is:null(argv[i + 5]))
            a2 = 2 * Pi;
         else {
            if (!cnv:C_double(argv[i + 5], a2))
               runerr(102, argv[i + 5]);
            if (fabs(a2) > 3 * Pi)
               runerr(101, argv[i + 5]);
            }
         if (fabs(a2) >= 2 * Pi) {
            a2 = 2 * Pi;
            }
         else {
            if (a2 < 0.0) {
               a1 += a2;
               a2 = fabs(a2);
               }
            }
         if (a1 < 0.0)
            a1 = 2 * Pi - fmod(fabs(a1), 2 * Pi);
         else
            a1 = fmod(a1, 2 * Pi);
         arcs[j].angle1 = ANGLE(a1);
         arcs[j].angle2 = EXTENT(a2);

         j++;
         }

#ifdef GraphicsGL
      if (w->window->is_gl) {
         if (gl_drawarcs(w, arcs, j) == RunError)
            runerr(0);
         }
      else
#endif                                  /* GraphicsGL */
      drawarcs(w, arcs, j);
      ReturnWindow;
      }
end

/*
 * DrawCircle(w, x1, y1, r1, angle11, angle21, ...)
 */
"DrawCircle(argv[]){1} - draw circle"

function{1} DrawCircle(argv[argc])
   abstract {
      return file
      }
   body {
      wbp w;
      int warg = 0, r;

      OptWindow(w);
      r = docircles(w, argc - warg, argv + warg, 0);
      if (r < 0)
         ReturnWindow;
      else if (r >= argc - warg)
         runerr(146);
      else
         runerr(102, argv[warg + r]);
      }
end

/*
 * DrawCurve(w,x1,y1,...xN,yN)
 *  Draw a smooth curve through the given points.
 *  If no window, return the list of computed points.
 */
"DrawCurve(argv[]){1} - draw curve"

function{1} DrawCurve(argv[argc])
   abstract {
      return file
      }
   body {
      wbp w;
      int i, n, closed = 0, warg = 0;
      C_integer dx = 0, dy = 0, x0, y0, xN, yN;
      XPoint *points;

      /* instead of the usual OptWindow(w); allow w/no window arguments */
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
            w = NULL;
         else if (!(BlkD(kywd_xwin[XKey_Window],File)->status & (Fs_Read|Fs_Write)))
            fail;
         else {
            (w) = (wbp)BlkD(kywd_xwin[XKey_Window],File)->fd.fp;
            if (ISCLOSED(w))
               fail;
            }
         }
      CheckArgMultiple(2);

      if (w) {
         dx = w->context->dx;
         dy = w->context->dy;
         }

      Protect(points = (XPoint *)malloc(sizeof(XPoint) * (n+2)), runerr(305));

      if (n > 1) {
         CnvCInteger(argv[warg], x0)
         CnvCInteger(argv[warg + 1], y0)
         CnvCInteger(argv[argc - 2], xN)
         CnvCInteger(argv[argc - 1], yN)
         if ((x0 == xN) && (y0 == yN)) {
            closed = 1;               /* duplicate the next to last point */
            CnvCShort(argv[argc-4], points[0].x);
            CnvCShort(argv[argc-3], points[0].y);
            points[0].x += dx;
            points[0].y += dy;
            }
         else {                       /* duplicate the first point */
            CnvCShort(argv[warg], points[0].x);
            CnvCShort(argv[warg + 1], points[0].y);
            points[0].x += dx;
            points[0].y += dy;
            }
         for (i = 1; i <= n; i++) {
            int base = warg + (i-1) * 2;
            CnvCShort(argv[base], points[i].x);
            CnvCShort(argv[base + 1], points[i].y);
            points[i].x += dx;
            points[i].y += dy;
            }
         if (closed) {                /* duplicate the second point */
            points[i] = points[2];
            }
         else {                       /* duplicate the last point */
            points[i] = points[i-1];
            }

         if (w) {
            if (n == 2) {
#ifdef GraphicsGL
               if (w->window->is_gl)
                  gl_drawlines(w, points+1, 2);
               else
#endif                                  /* GraphicsGL */
               drawlines(w, points+1, 2);
               }
            else {
               drawCurve(w, points, n+2);
               }
            }
         else {  /* make a list to return instead of drawing */
            struct descrip d;

            /*
             * Give an upper bound on number of points in resulting list.
             * Every curve being 90 degree angles seems like a worst case.
             */
            int sum = n;
            for(i=1;i<n+1;i++)
               sum += abs(points[i].x - points[i+1].x) +
                       abs(points[i].y - points[i+1].y);

            /* reserve enough memory so we won't gc during list puts */
            if (!reserve(Blocks, (word)(sizeof(struct b_list) +
                                   sizeof(struct b_lelem) +
                                   (2+sum) * 2 * sizeof(struct descrip))))
               fail;

            /* allocate a list */

            d.dword = D_List;
            BlkLoc(d) = (union block *)alclist(0, (sum+2)*2);

            genCurve((wbp) &d, points, n+2, curveLister);
            free(points);
            return d;
            }
         }
      free(points);
      ReturnWindow;
      }
end


"DrawImage(w,x,y,s) - draw bitmapped figure"

function{0,1} DrawImage(argv[argc])
   abstract {
      return null++integer
      }
   body {
      wbp w;
      int warg = 0;
      int c, i, width, height, row, p;
      C_integer x, y;
      word nchars;
      unsigned char *s, *t, *z;
      struct descrip d;
      struct palentry *e;
      OptWindow(w);

      /*
       * X or y can be defaulted but s is required.
       * Validate x/y first so that the error message makes more sense.
       */
      if (argc - warg >= 1 && !def:C_integer(argv[warg], -w->context->dx, x))
         runerr(101, argv[warg]);
      if (argc - warg >= 2 && !def:C_integer(argv[warg + 1], -w->context->dy, y))
         runerr(101, argv[warg + 1]);
      if (argc - warg < 3)
         runerr(103);                   /* missing s */
      if (!cnv:tmp_string(argv[warg+2], d))    /* d is not allocated */
         runerr(103, argv[warg + 2]);

      x += w->context->dx;
      y += w->context->dy;
      /*
       * Extract the Width and skip the following comma.
       */
      s = (unsigned char *)StrLoc(d);
      z = s + StrLen(d);                /* end+1 of string */
      width = 0;
      while (s < z && *s == ' ')        /* skip blanks */
         s++;
      while (s < z && isdigit(*s))      /* scan number */
         width = 10 * width + *s++ - '0';
      while (s < z && *s == ' ')        /* skip blanks */
         s++;
      if (width == 0 || *s++ != ',')    /* skip comma */
         fail;
      while (s < z && *s == ' ')        /* skip blanks */
         s++;
      if (s >= z)                       /* if end of string */
         fail;

      /*
       * Check for a bilevel format.
       */
      if ((c = *s) == '#' || c == '~') {
         s++;
         nchars = 0;
         for (t = s; t < z; t++)
            if (isxdigit(*t))
               nchars++;                        /* count hex digits */
            else if (*t != PCH1 && *t != PCH2)
               fail;                            /* illegal punctuation */
         if (nchars == 0)
            fail;
         row = (width + 3) / 4;                 /* digits per row */
         if (nchars % row != 0)
            fail;
         height = nchars / row;
#ifdef GraphicsGL
         if (w->window->is_gl) {
            if (gl_blimage(w, x, y, width, height, c, s, (word)(z - s)) == RunError)
               runerr(305);
            else return nulldesc;
            }
         else
#endif                                  /* GraphicsGL */
         if (blimage(w, x, y, width, height, c, s, (word)(z - s)) == RunError)
            runerr(305);
         else
            return nulldesc;
         }

      /*
       * Extract the palette name and skip its comma.
       */
      c = *s++;                                 /* save initial character */
      p = 0;
      while (s < z && isdigit(*s))              /* scan digits */
         p = 10 * p + *s++ - '0';
      while (s < z && *s == ' ')                /* skip blanks */
         s++;
      if (s >= z || p == 0 || *s++ != ',')      /* skip comma */
         fail;
      if (c == 'g' && p >= 2 && p <= 256)       /* validate grayscale number */
         p = -p;
      else if (c != 'c' || p < 1 || p > 6)      /* validate color number */
         fail;

      /*
       * Scan the image to see which colors are needed.
       */
      e = palsetup(p);
      if (e == NULL)
         runerr(305);
      for (i = 0; i < 256; i++)
         e[i].used = 0;
      nchars = 0;
      for (t = s; t < z; t++) {
         c = *t;
         e[c].used = 1;
         if (e[c].valid || e[c].transpt)
            nchars++;                   /* valid color, or transparent */
         else if (c != PCH1 && c != PCH2)
            fail;
         }
      if (nchars == 0)
         fail;                                  /* empty image */
      if (nchars % width != 0)
         fail;                                  /* not rectangular */

      /*
       * Call platform-dependent code to draw the image.
       */
      height = nchars / width;
#ifdef GraphicsGL
      if (w->window->is_gl)
         i = gl_strimage(w, x, y, width, height, e, s, (word)(z - s), 0);
      else
#endif                                  /* GraphicsGL */
      i = strimage(w, x, y, width, height, e, s, (word)(z - s), 0);
      if (i == 0)
         return nulldesc;
      else if (i < 0)
         runerr(305);
      else
         return C_integer i;
      }
end

/*
 * DrawLine(w,x1,y1,...xN,yN)
 */
"DrawLine(argv[]){1} - draw line"

function{1} DrawLine(argv[argc])
   abstract {
      return file
      }
   body {
      wbp w;
      int i, j, n, warg = 0;
      XPoint points[MAXXOBJS];
      int dx, dy;
      C_integer x1, x2, y1, y2;
      int base=0;
#ifdef Graphics3D
      int is_texture = 0;
      int texhandle;
#endif                                  /* Graphics3D */
      OptTexWindow(w);
#ifdef Graphics3D
      if (is_texture) {
         base=warg;
         CheckArgMultiple(2);

         if (argc-warg<4) /* first line should have at least 4 int values */
            runerr(146);

         if (texhandle >= w->context->display->ntextures) runerr(101, argv[base]);

         if (!cnv:C_integer(argv[base]  , x1)) runerr(101, argv[base]);
         if (!cnv:C_integer(argv[base+1], y1)) runerr(101, argv[base+1]);

         for (base+=2; base < argc; base+=2){
             if (!cnv:C_integer(argv[base], x2)) runerr(101, argv[base]);
             if (!cnv:C_integer(argv[base+1], y2)) runerr(101, argv[base+1]);
             TexDrawLine(w, texhandle, x1, y1, x2, y2);
             x1=x2;
             y1=y2;
             }
         ReturnWindow;
         }

      if (w->context->rendermode == UGL3D) {
         word num;
         tended struct descrip f;
         tended struct descrip d;
         tended struct b_realarray *ap;

         /* check if the argument is a list */
         if (is:list(argv[warg]))
            num = BlkD(argv[warg], List)->size;
         else {
            num = argc-warg;
            }
         /* Check the number of coordinates*/
         if (num%w->context->dim != 0 || num<w->context->dim*2)
            runerr(146);

         /* create a list to keep track of function information */
         if (cplist2realarray(&argv[warg], &d, 0, num, 0)!=Succeeded)
           runerr(305, argv[warg]);
         ap = (struct b_realarray *) BlkD(d, List)->listhead;

         if (create3Dlisthdr(&f, "DrawLine", 4)!=Succeeded)
            fail;
         c_put(&f, &d);
         c_put(&(w->window->funclist), &f);

         /* draw the lines */
         if (w->window->buffermode == UGL_IMMEDIATE) {
            drawpoly(w, ap->a, num, U3D_LINE_STRIP, w->context->dim);
            glFlush();
            }
         return f;
         }
     else
#endif                                  /* Graphics3D */
     {
      CheckArgMultiple(2);

      dx = w->context->dx;
      dy = w->context->dy;

      for(i=0, j=0;i<n;i++, j++) {
         int base = warg + i * 2;
         if (j==MAXXOBJS) {
#ifdef GraphicsGL
            if (w->window->is_gl) {
               if (gl_drawlines(w, points, MAXXOBJS) == RunError)
                  runerr(0);
               }
            else
#endif                                  /* GraphicsGL */
            drawlines(w, points, MAXXOBJS);
            points[0] = points[MAXXOBJS-1];
            j = 1;
            }
         CnvCShort(argv[base], points[j].x);
         CnvCShort(argv[base + 1], points[j].y);
         points[j].x += dx;
         points[j].y += dy;
         }
#ifdef GraphicsGL
      if (w->window->is_gl) {
         if (gl_drawlines(w, points, j) == RunError)
            runerr(0);
         }
      else
#endif                                  /* GraphicsGL */
      drawlines(w, points, j);
      ReturnWindow;
        }
      }
end

/*
 * DrawPoint(w, x1, y1, ...xN, yN)
 */
"DrawPoint(argv[]){1} - draw point"

function{1} DrawPoint(argv[argc])
   abstract {
      return file
      }
   body {
      wbp w;
      int i, j, n, warg = 0;
      XPoint points[MAXXOBJS];
      int dx, dy;
      C_integer x,y;
      int base=0;
#ifdef Graphics3D
      int is_texture=0;
      int texhandle;
#endif                                  /* Graphics3D */

      OptTexWindow(w);
#ifdef Graphics3D
      if (is_texture) {
         base=warg;
         CheckArgMultiple(2);

         if (texhandle >= w->context->display->ntextures) runerr(102, argv[base]);

         for (; base < argc; base+=2){
             if (!cnv:C_integer(argv[base], x)) runerr(101, argv[base]);
             if (!cnv:C_integer(argv[base+1], y)) runerr(101, argv[base+1]);
             TexDrawPoint(w, texhandle, x, y);
             }
         ReturnWindow;
         }

      if (w->context->rendermode == UGL3D) {
         word num;
         tended struct descrip f;
         tended struct descrip d;
         tended struct b_realarray *ap;

         /* check if the argument is a list */
         if (is:list(argv[warg]))
            num = BlkD(argv[warg], List)->size;
         else {
            num = argc-warg;
            }

         /* Check the number of coordinates*/
         if (num%w->context->dim!=0)
            runerr(146);

         /* create a list to store function information */
         if (cplist2realarray(&argv[warg], &d, 0, num, 0)!=Succeeded)
            runerr(305, argv[warg]);
         ap = (struct b_realarray *) BlkD(d, List)->listhead;

         if (create3Dlisthdr(&f, "DrawPoint", 4)!=Succeeded)
            fail;
         c_put(&f, &d);
         c_put(&(w->window->funclist), &f);

         if (w->window->buffermode == UGL_IMMEDIATE) {
            drawpoly(w, ap->a, num, U3D_POINTS, w->context->dim);
            glFlush();
            }
         return f;
         }
      else
#endif                                  /* Graphics3D */
     {
     CheckArgMultiple(2);
      dx = w->context->dx;
      dy = w->context->dy;
      for(i=0, j=0; i < n; i++, j++) {
         int base = warg + i * 2;
         if (j == MAXXOBJS) {
#ifdef GraphicsGL
            if (w->window->is_gl) {
               if (gl_drawpoints(w, points, MAXXOBJS) == RunError)
                  runerr(0);
               }
            else
#endif                                  /* GraphicsGL */
            drawpoints(w, points, MAXXOBJS);
            j = 0;
            }
         CnvCShort(argv[base], points[j].x);
         CnvCShort(argv[base + 1], points[j].y);
         points[j].x += dx;
         points[j].y += dy;
       }
#ifdef GraphicsGL
      if (w->window->is_gl) {
         if (gl_drawpoints(w, points, j) == RunError)
            runerr(0);
         }
      else
#endif                                  /* GraphicsGL */
      drawpoints(w, points, j);
      ReturnWindow;

        }
     }
end

/*
 * DrawPolygon(w,x1,y1,...xN,yN)
 */
"DrawPolygon(argv[]){1} - draw polygon"

function{1} DrawPolygon(argv[argc])
   abstract {
      return file
      }
   body {
      wbp w;
      int i, j, n, base, dx, dy, warg = 0;
#ifdef GraphicsGL
      XPoint *points;
#else                                   /* GraphicsGL */
      XPoint points[MAXXOBJS];
#endif                                  /* GraphicsGL */
      OptWindow(w);

#ifdef Graphics3D
      if (w->context->rendermode == UGL3D) {
         word num;
         tended struct descrip f;
         tended struct descrip d;
         tended struct b_realarray *ap;

         /* check if the argument is a list */
         if (is:list(argv[warg]))
            num = BlkD(argv[warg], List)->size;
         else {
            num = argc-warg;
            }

         /* Check the number of coordinates*/
         if (num%w->context->dim!=0 || num<3*w->context->dim)
            runerr(146);

         /* create a list for function information */
         if (cplist2realarray(&argv[warg], &d, 0, num, 0)!=Succeeded)
            runerr(305, argv[warg]);
         ap = (struct b_realarray *) BlkD(d, List)->listhead;

         if (create3Dlisthdr(&f, "DrawPolygon", 4)!=Succeeded)
            fail;
         c_put(&f, &d);
         c_put(&(w->window->funclist), &f);

         /* draw the polygon */
         if (w->window->buffermode == UGL_IMMEDIATE) {
            drawpoly(w, ap->a, num, U3D_LINE_LOOP /* w->context->meshmode*/, w->context->dim);
            glFlush();
            }
         return f;
         }
      else
#endif                                  /* Graphics3D */
     {
      CheckArgMultiple(2);

      dx = w->context->dx;
      dy = w->context->dy;

#ifdef GraphicsGL
      if (w->window->is_gl) {
         if ((points = (XPoint *)malloc((n+1)*sizeof(XPoint))) == NULL)
            runerr(305);
         }
      else {
         if ((points = (XPoint *)malloc((MAXXOBJS)*sizeof(XPoint))) == NULL)
            runerr(305);
         }
#endif                                  /* GraphicsGL */
      /*
       * To make a closed polygon, start with the *last* point.
       */
      CnvCShort(argv[argc - 2], points[0].x);
      CnvCShort(argv[argc - 1], points[0].y);
      points[0].x += dx;
      points[0].y += dy;

      /*
       * Now add all points from beginning to end, including last point again.
       */
      for(i = 0, j = 1; i < n; i++, j++) {
         base = warg + i * 2;
#ifdef GraphicsGL
         if (!w->window->is_gl && j == MAXXOBJS) {
#else                                   /* GraphicsGL */
         if (j == MAXXOBJS) {
#endif                                  /* GraphicsGL */
            drawlines(w, points, MAXXOBJS);
            points[0] = points[MAXXOBJS-1];
            j = 1;
            }
         CnvCShort(argv[base], points[j].x);
         CnvCShort(argv[base + 1], points[j].y);
         points[j].x += dx;
         points[j].y += dy;
         }
#ifdef GraphicsGL
      if (w->window->is_gl) {
         if (gl_drawlines(w, points, j) == RunError)
            runerr(0);
         }
      else
#endif                                  /* GraphicsGL */
      drawlines(w, points, j);
#ifdef GraphicsGL
      free(points);
#endif                                  /* GraphicsGL */
      ReturnWindow;
       }
     }
end


/*
 * DrawRectangle(w, x1, y1, width1, height1, ..., xN, yN, widthN,heightN)
 */
"DrawRectangle(argv[]){1} - draw rectangle"

function{1} DrawRectangle(argv[argc])
   abstract {
      return file
      }
   body {
      wbp w;
      int i, j, r, n, warg = 0;
      XRectangle recs[MAXXOBJS];
      C_integer x, y, width, height;
      int base=0;
#ifdef Graphics3D
      int is_texture=0;
      int texhandle;
#endif                                  /* Graphics3D */

      OptTexWindow(w);

#ifdef Graphics3D
      if (is_texture) {
         base=warg;
         CheckArgMultiple(4);

         if (texhandle >= w->context->display->ntextures) runerr(101, argv[base]);
         for (; base < argc; base+=4){
             if (!cnv:C_integer(argv[base]  , x)) runerr(101, argv[base]);
             if (!cnv:C_integer(argv[base+1], y)) runerr(101, argv[base+1]);
             if (!cnv:C_integer(argv[base+2], width)) runerr(101, argv[base+2]);
             if (!cnv:C_integer(argv[base+3], height)) runerr(101, argv[base+3]);
             TexDrawRect(w, texhandle, x, y, width, height);
             }
         ReturnWindow;
         }
#endif                                  /* Graphics3D */
      j = 0;

      for (i = warg; i < argc || i == warg; i += 4) {
         r = rectargs(w, argc, argv, i, &x, &y, &width, &height);
         if (r >= 0)
            runerr(101, argv[r]);
         if (j == MAXXOBJS) {
#ifdef GraphicsGL
            if (w->window->is_gl) {
               if (gl_drawrectangles(w,recs,MAXXOBJS) == RunError)
                  runerr(0);
               }
            else
#endif                                  /* GraphicsGL */
            drawrectangles(w,recs,MAXXOBJS);
            j = 0;
            }
         RECX(recs[j]) = x;
         RECY(recs[j]) = y;
         RECWIDTH(recs[j]) = width;
         RECHEIGHT(recs[j]) = height;
         j++;
         }

#ifdef GraphicsGL
      if (w->window->is_gl) {
         if (gl_drawrectangles(w,recs,j) == RunError)
            runerr(0);
         }
      else
#endif                                  /* GraphicsGL */
      drawrectangles(w, recs, j);
      ReturnWindow;
      }
end

/*
 * DrawSegment(x11,y11,x12,y12,...,xN1,yN1,xN2,yN2)
 */
"DrawSegment(argv[]){1} - draw line segment"

function{1} DrawSegment(argv[argc])
   abstract {
      return file
      }
   body {
      wbp w;
      int i, j, n, warg = 0, dx, dy;
      XSegment segs[MAXXOBJS];
      C_integer x1, x2, y1, y2;
      int base=0;
#ifdef Graphics3D
      int is_texture=0;
      int texhandle;
#endif                                  /* Graphics3D */
      OptTexWindow(w);
#ifdef Graphics3D
      if (is_texture) {
         base=warg;
         CheckArgMultiple(4);
         if (texhandle >= w->context->display->ntextures) runerr(101, argv[base]);
         for (; base < argc; base+=4){
             if (!cnv:C_integer(argv[base]  , x1)) runerr(101, argv[base]);
             if (!cnv:C_integer(argv[base+1], y1)) runerr(101, argv[base+1]);
             if (!cnv:C_integer(argv[base+2], x2)) runerr(101, argv[base+2]);
             if (!cnv:C_integer(argv[base+3], y2)) runerr(101, argv[base+3]);
             TexDrawLine(w, texhandle, x1, y1, x2, y2);
             }
         ReturnWindow;
         }

      if (w->context->rendermode == UGL3D) {
         word num;
         tended struct descrip f;
         tended struct descrip d;
         tended struct b_realarray *ap;

         /* check if the argument is a list */
         if (is:list(argv[warg]))
            num = BlkD(argv[warg], List)->size;
         else {
            num = argc-warg;
            }

         /* Check the number of coordinates*/
         if (num%(2*w->context->dim) != 0)
            runerr(146);

         /* create a list for function information */
         if (cplist2realarray(&argv[warg], &d, 0, num, 0)!=Succeeded)
            runerr(305, argv[warg]);
         ap = (struct b_realarray *) BlkD(d, List)->listhead;

         if (create3Dlisthdr(&f, "DrawSegment", 4)!=Succeeded)
            fail;
         c_put(&f, &d);
         c_put(&(w->window->funclist), &f);

         /* draw the line segments */
         if (w->window->buffermode == UGL_IMMEDIATE) {
            drawpoly(w, ap->a, argc-warg, U3D_LINES, w->context->dim);
            glFlush();
            }
         return f;
         }
       else
#endif                                  /* Graphics3D */
     {

      CheckArgMultiple(4);

      dx = w->context->dx;
      dy = w->context->dy;
      for(i=0, j=0; i < n; i++, j++) {
         int base = warg + i * 4;
         if (j == MAXXOBJS) {
#ifdef GraphicsGL
            if (w->window->is_gl) {
               if (gl_drawsegments(w, segs, MAXXOBJS) == RunError)
                  runerr(0);
               }
            else
#endif                                  /* GraphicsGL */
            drawsegments(w, segs, MAXXOBJS);
            j = 0;
            }
         CnvCShort(argv[base], segs[j].x1);
         CnvCShort(argv[base + 1], segs[j].y1);
         CnvCShort(argv[base + 2], segs[j].x2);
         CnvCShort(argv[base + 3], segs[j].y2);
         segs[j].x1 += dx;
         segs[j].x2 += dx;
         segs[j].y1 += dy;
         segs[j].y2 += dy;
         }
#ifdef GraphicsGL
      if (w->window->is_gl) {
         if (gl_drawsegments(w, segs, j) == RunError)
            runerr(0);
         }
      else
#endif                                  /* GraphicsGL */
      drawsegments(w, segs, j);
         }
      ReturnWindow;
      }
end

/*
 * DrawString(w, x1, y1, s1, ..., xN, yN, sN)
 */
"DrawString(argv[]){1} - draw text"

function{1} DrawString(argv[argc])
   abstract {
      return file
      }
   body {
      wbp w;
      int i, j, n, len, warg = 0, nf;
      tended char *s;
      double x, y, z;
      struct descrip f;
      tended struct b_record *rp;
      static dptr constr;
      int draw_code;

      OptWindow(w);
#ifdef Graphics3D
      if (w->context->rendermode == UGL3D) {

         if (argc - warg < 3) fail;

         if (!constr) {
            if (!(constr = rec_structor3d(GL3D_DRAWSTRING)))
              syserr("failed to create opengl record constructor");
            }
         nf = (int) ((struct b_proc *)BlkLoc(*constr))->nfields;

         if (!(cnv:C_double(argv[warg], x)))
             runerr(102, argv[warg]);
         if (!(cnv:C_double(argv[warg+1], y)))
             runerr(102, argv[warg+1]);
         if (!(cnv:C_double(argv[warg+2], z)))
            runerr(102, argv[warg+2]);
         if (!(cnv:C_string(argv[warg+3], s)))
            runerr(103, argv[warg+3]);

         if (w->window->buffermode == UGL_IMMEDIATE) {
            drawstrng3d(w, (double) x, (double) y, (double) z, s);
            glFlush();
            }
         //swapbuffers(w, 1);

         /* create a record of the graphical object */

         Protect(rp = alcrecd(nf, BlkLoc(*constr)), runerr(0));
         f.dword = D_Record;
         f.vword.bptr = (union block *) rp;
         MakeStr("DrawString3d", 10, &(rp->fields[0]));

         draw_code = si_s2i(redraw3Dnames, "DrawString3d");
         if (draw_code == -1)
            fail;
         MakeInt(draw_code, &(rp->fields[1]));

         for(j = warg; j < warg + 3; j++)
            rp->fields[2 + j - warg] = argv[j];
         MakeStr(s, strlen(s), &(rp->fields[5]));
         c_put(&(w->window->funclist), &f);

         ReturnWindow;
         }
      else
#endif                      /* Graphics3D */
        {
      CheckArgMultiple(3);

      for(i=0; i < n; i++) {
         C_integer x, y;
         int base = warg + i * 3;
         CnvCInteger(argv[base], x);
         CnvCInteger(argv[base + 1], y);
         x += w->context->dx;
         y += w->context->dy;
         CnvTmpString(argv[base + 2], argv[base + 2]);
         s = StrLoc(argv[base + 2]);
         len = StrLen(argv[base + 2]);
#ifdef GraphicsGL
         if (w->window->is_gl)
            gl_drawstrng(w, x, y, s, len);
         else
#endif                                  /* GraphicsGL */
         drawstrng(w, x, y, s, len);
         }
      ReturnWindow;
      }
      }
end


"EraseArea(w,x,y,width,height) - clear an area of the window"

function{1} EraseArea(argv[argc])
   abstract {
      return file
      }
   body {
      wbp w;
      wcp wc=NULL;
      int warg = 0, i, r, n;
      C_integer x, y, width, height;
      int base=0;
#ifdef Graphics3D
      int is_texture=0;
      int texhandle;
#endif                                  /* Graphics3D */

      OptTexWindow(w);

#ifdef Graphics3D
      wc = w->context;
      if (is_texture) {
         base=warg;
         CheckArgMultiple(4);
         if (texhandle >= wc->display->ntextures) runerr(102, argv[base]);
         for (; base < argc; base+=4){
             if (!cnv:C_integer(argv[base]  , x)) runerr(101, argv[base]);
             if (!cnv:C_integer(argv[base+1], y)) runerr(101, argv[base+1]);
             if (!cnv:C_integer(argv[base+2], width)) runerr(101, argv[base+2]);
             if (!cnv:C_integer(argv[base+3], height)) runerr(101, argv[base+3]);
             TexFillRect(w, texhandle, x, y, width, height, 0);
             }
         ReturnWindow;
         }

      if (wc->rendermode == UGL3D) {
         if(create_display_list(w, 40000) == Failed)
            runerr(0);

#if HAVE_LIBGL
         /* need to free selectionnamelist entries here */
         wc->selectionnamecount=0;
#endif                                  /* HAVE_LIBGL */
         erasetocolor(RED(wc->bg), GREEN(wc->bg), BLUE(wc->bg));
         swapbuffers(w, 0);
         ReturnWindow;
         }
#endif                                  /* Graphics3D */

      for (i = warg; i < argc || i == warg; i += 4) {
         r = rectargs(w, argc, argv, i, &x, &y, &width, &height);
         if (r >= 0)
            runerr(101, argv[r]);
#ifdef GraphicsGL
         if (w->window->is_gl) {
            if (gl_eraseArea(w, x, y, width, height) == RunError)
               runerr(0);
            }
         else
#endif                                  /* GraphicsGL */
         eraseArea(w, x, y, width, height);
         }

      ReturnWindow;
      }
end


"Event(w) - return an event from a window"

function{1} Event(argv[argc])
   abstract {
      return string ++ integer
      }
   body {
      wbp w;
      C_integer i, t;
      tended struct descrip d;
      int warg = 0;
      if (argc>warg && is:file(argv[warg])) {
         d = argv[warg++];
         }
      else {
         d = kywd_xwin[XKey_Window];
         }
      if (is:null(d) || ((BlkD(d,File)->status & Fs_Window) == 0))
         runerr(140,d);
      if ((BlkD(d,File)->status & (Fs_Read|Fs_Write)) == 0)
         runerr(142,d);
      w = BlkLoc(d)->File.fd.wb;
#ifdef ConsoleWindow
      checkOpenConsole((FILE *)w, NULL);
#endif                                  /* ConsoleWindow */
      if (ISCLOSED(w) && BlkD(w->window->listp,List)->size == 0)
         runerr(142,d);
      if (argc - warg < 1)
         t = -1;
      else
         CnvCInteger(argv[warg], t)
#ifdef MSWindows
      if (EVQUEEMPTY(w->window))
         SetFocus(w->window->win);
#endif                                  /* MSWindows */
      d = nulldesc;
      i = wgetevent(w, &d, t);
      if (i == -3) {
         if (t < 0) {
            /* Something's wrong, but what?  */
            runerr(-1);
            }
         fail;
         }
      if (i == 0) {
         if (is:file(kywd_xwin[XKey_Window]) &&
               w == BlkD(kywd_xwin[XKey_Window],File)->fd.wb)
            lastEventWin = kywd_xwin[XKey_Window];
         else
            lastEventWin = argv[warg-1];
#ifdef GraphicsGL
         if (BlkD(lastEventWin,File)->fd.wb->window->is_gl) {
            lastEvFWidth = GL_FWIDTH(BlkD(lastEventWin,File)->fd.wb);
            lastEvLeading = GL_LEADING(BlkD(lastEventWin,File)->fd.wb);
            lastEvAscent = GL_ASCENT(BlkD(lastEventWin,File)->fd.wb);
            }
         else
#endif                                  /* GraphicsGL */
         {
         lastEvFWidth = FWIDTH(BlkD(lastEventWin,File)->fd.wb);
         lastEvLeading = LEADING(BlkD(lastEventWin,File)->fd.wb);
         lastEvAscent = ASCENT(BlkD(lastEventWin,File)->fd.wb);
         }
         if (is:integer(d) && IntVal(d)==WINDOWCLOSED &&
             !(w->window->inputmask & WindowClosureMask)) {
            /* closed, don't accept more I/O on it */
            BlkLoc(lastEventWin)->File.status &= ~(Fs_Read|Fs_Write);
            }
         return d;
         }
      else if (i == -1)
         runerr(141);
      else
         runerr(143);
      }
end


"Fg(w,s) - foreground color"

function{0,1} Fg(argv[argc])
   abstract {
      return string
      }
   body {
      wbp w;
      char sbuf1[MaxCvtLen];
      int len;
      tended char *tmp;
      int warg = 0;
#ifdef Graphics3D
      int is_texture=0;
      int texhandle;
#endif                                  /* Graphics3D */
      OptTexWindow(w);
#ifdef Graphics3D
      if (is_texture) {
         warg=1;
         (void) texhandle;  /* silence "not used" compiler warning */
         }
#endif                                  /* Graphics3D */
      /*
       * If there is a (non-window) argument we are setting by
       *  either a mutable color (negative int) or a string name.
       */
      if (argc - warg > 0) {
          if (is:integer(argv[warg])) { /* mutable color or packed RGB */
#ifdef GraphicsGL
            if (w->window->is_gl) {
               if (gl_isetfg(w, IntVal(argv[warg])) == Failed) fail;
               }
            else
#endif                                  /* GraphicsGL */
            if (isetfg(w, IntVal(argv[warg])) == Failed) fail;
            }
          else {
            if (!cnv:C_string(argv[warg], tmp))
               runerr(103,argv[warg]);
#ifdef Graphics3D
            if (w->context->rendermode == UGL3D) {
               /* set the material properties */
               if (setmaterials(w, tmp) == Failed) fail;
               }
            else
#endif                                  /* Graphics3D */
               {
#ifdef GraphicsGL
               if (w->window->is_gl) {
                  if (gl_setfg(w, tmp) == Failed) fail;
                  }
               else
#endif                                  /* GraphicsGL */
               if (setfg(w, tmp) == Failed) fail;
               }
            }
         }

      /*
       * In any case, this function returns the current foreground color.
       */
#ifdef Graphics3D
      if (w->context->rendermode == UGL3D)
         getmaterials(sbuf1);
      else
#endif
      {
#ifdef GraphicsGL
      if (w->window->is_gl)
         gl_getfg(w, sbuf1);
      else
#endif                                  /* GraphicsGL */
      getfg(w, sbuf1);
      }

      len = strlen(sbuf1);
      Protect(tmp = alcstr(sbuf1, len), runerr(0));
      return string(len, tmp);
      }
end

/*
 * FillArc(w, x1, y1, width1, height1, angle11, angle21,...)
 */
"FillArc(argv[]){1} - fill arc"

function{1} FillArc(argv[argc])
   abstract {
      return file
      }
   body {
      wbp w;
      int i, j, r, warg = 0;
      XArc arcs[MAXXOBJS];
      C_integer x, y, width, height;
      double a1, a2;

      OptWindow(w);
      j = 0;
      for (i = warg; i < argc || i == warg; i += 6) {
         if (j == MAXXOBJS) {
#ifdef GraphicsGL
            if (w->window->is_gl) {
               if (gl_fillarcs(w, arcs, MAXXOBJS) == RunError)
                  runerr(0);
               }
            else
#endif                                  /* GraphicsGL */
            fillarcs(w, arcs, MAXXOBJS);
            j = 0;
            }
         r = rectargs(w, argc, argv, i, &x, &y, &width, &height);
         if (r >= 0)
            runerr(101, argv[r]);

         arcs[j].x = x;
         arcs[j].y = y;
         ARCWIDTH(arcs[j]) = width;
         ARCHEIGHT(arcs[j]) = height;

         if (i + 4 >= argc || is:null(argv[i + 4])) {
            a1 = 0.0;
            }
         else {
            if (!cnv:C_double(argv[i + 4], a1))
               runerr(102, argv[i + 4]);
            if (a1 >= 0.0)
               a1 = fmod(a1, 2 * Pi);
            else
               a1 = -fmod(-a1, 2 * Pi);
            }
         if (i + 5 >= argc || is:null(argv[i + 5]))
            a2 = 2 * Pi;
         else {
            if (!cnv:C_double(argv[i + 5], a2))
               runerr(102, argv[i + 5]);
            if (fabs(a2) > 3 * Pi)
               runerr(101, argv[i + 5]);
            }
         if (fabs(a2) >= 2 * Pi) {
            a2 = 2 * Pi;
            }
         else {
            if (a2 < 0.0) {
               a1 += a2;
               a2 = fabs(a2);
               }
            }
         arcs[j].angle2 = EXTENT(a2);
         if (a1 < 0.0)
            a1 = 2 * Pi - fmod(fabs(a1), 2 * Pi);
         else
           a1 = fmod(a1, 2 * Pi);
         arcs[j].angle1 = ANGLE(a1);

         j++;
         }
#ifdef GraphicsGL
      if (w->window->is_gl) {
         if (gl_fillarcs(w, arcs, j) == RunError)
            runerr(0);
         }
      else
#endif                                  /* GraphicsGL */
      fillarcs(w, arcs, j);
      ReturnWindow;
      }
end

/*
 * FillCircle(w, x1, y1, r1, angle11, angle21, ...)
 */
"FillCircle(argv[]){1} - draw filled circle"

function{1} FillCircle(argv[argc])
   abstract {
      return file
      }
   body {
      wbp w;
      int warg = 0, r;

      OptWindow(w);
      r = docircles(w, argc - warg, argv + warg, 1);
      if (r < 0)
         ReturnWindow;
      else if (r >= argc - warg)
         runerr(146);
      else
         runerr(102, argv[warg + r]);

      }
end

/*
 * FillPolygon(w, x1, y1, ...xN, yN)
 */
"FillPolygon(argv[]){1} - fill polygon"

function{1} FillPolygon(argv[argc])
   abstract {
      return file
      }
   body {
      wbp w;
      int i, n, warg = 0, num;
      XPoint *points;
      int dx, dy;
      OptWindow(w);

#ifdef Graphics3D
      if (w->context->rendermode == UGL3D) {
         tended struct descrip f;
         tended struct descrip d;
         tended struct b_realarray *ap;

         /* check if the argument is a list */
         if (is:list(argv[warg])) {
            num = BlkD(argv[warg], List)->size;
            }
         else {
            num = argc-warg;
            }

         /* Check the number of coordinates*/
         if (num%w->context->dim != 0 || num<w->context->dim*3)
            runerr(146);

         /* create a list to store function information */
         if (cplist2realarray(&argv[warg], &d, 0, num, 0)!=Succeeded)
            runerr(305, argv[warg]);
         ap = (struct b_realarray *) BlkD(d, List)->listhead;

         if (create3Dlisthdr(&f, "FillPolygon", 4)!=Succeeded)
            fail;
         c_put(&f, &d);
         c_put(&(w->window->funclist), &f);

         /* draw polygons */
         /*CheckArgMultiple(w->context->dim);*/
         if (w->window->buffermode == UGL_IMMEDIATE) {
            drawpoly(w, ap->a, num, U3D_POLYGON, w->context->dim);
            glFlush();
            }
         return f;
         }
      else
#endif                                  /* Graphics3D */
      {
      CheckArgMultiple(2);

      /*
       * Allocate space for all the points in a contiguous array,
       * because a FillPolygon must be performed in a single call.
       */
      n = argc>>1;
      Protect(points = (XPoint *)malloc(sizeof(XPoint) * n), runerr(305));
      dx = w->context->dx;
      dy = w->context->dy;
      for(i=0; i < n; i++) {
         int base = warg + i * 2;
         CnvCShort(argv[base], points[i].x);
         CnvCShort(argv[base + 1], points[i].y);
         points[i].x += dx;
         points[i].y += dy;
         }
#ifdef GraphicsGL
      if (w->window->is_gl) {
         if (gl_fillpolygon(w, points, n) == RunError)
            runerr(0);
         }
      else
#endif                                  /* GraphicsGL */
      fillpolygon(w, points, n);
      free(points);
      ReturnWindow;
       }
      }

end

/*
 * FillRectangle(w, x1, y1, width1, height1,...,xN, yN, widthN, heightN)
 */
"FillRectangle(argv[]){1} - draw filled rectangle"

function{1} FillRectangle(argv[argc])
   abstract {
      return file
      }
   body {
      wbp w;
      int i, j, r, n, warg = 0;
      XRectangle recs[MAXXOBJS];
      C_integer x, y, width, height;
      int base=0;
#ifdef Graphics3D
      int is_texture=0;
      int texhandle;
#endif                                  /* Graphics3D */

      OptTexWindow(w);

#ifdef Graphics3D
      if (is_texture) {
         base=warg;
         CheckArgMultiple(4);

         if (texhandle >= w->context->display->ntextures) runerr(101, argv[base]);
         for (; base < argc; base+=4){
             if (!cnv:C_integer(argv[base]  , x)) runerr(101, argv[base]);
             if (!cnv:C_integer(argv[base+1], y)) runerr(101, argv[base+1]);
             if (!cnv:C_integer(argv[base+2], width)) runerr(101, argv[base+2]);
             if (!cnv:C_integer(argv[base+3], height)) runerr(101, argv[base+3]);
             TexFillRect(w, texhandle, x, y, width, height, 1);
             }

         ReturnWindow;
         }
#endif                                  /* Graphics3D */

      j = 0;

      for (i = warg; i < argc || i == warg; i += 4) {
         r = rectargs(w, argc, argv, i, &x, &y, &width, &height);
         if (r >= 0)
            runerr(101, argv[r]);
         if (j == MAXXOBJS) {
#ifdef GraphicsGL
            if (w->window->is_gl) {
               if (gl_fillrectangles(w,recs,MAXXOBJS) == RunError)
                  runerr(0);
               }
            else
#endif                                  /* GraphicsGL */
            fillrectangles(w,recs,MAXXOBJS);
            j = 0;
            }
         RECX(recs[j]) = x;
         RECY(recs[j]) = y;
         RECWIDTH(recs[j]) = width;
         RECHEIGHT(recs[j]) = height;
         j++;
         }

#ifdef GraphicsGL
      if (w->window->is_gl) {
         if (gl_fillrectangles(w,recs,j) == RunError)
            runerr(0);
         }
      else
#endif                                  /* GraphicsGL */
      fillrectangles(w, recs, j);
      ReturnWindow;
      }
end



"Font(w,s) - get/set font"

function{0,1} Font(argv[argc])
   abstract {
      return string
      }
   body {
      tended char *tmp;
      int len, nfields, draw_code;
      wbp w;
      int warg = 0;
      char buf[MaxCvtLen];
      struct descrip f;
      tended struct b_record *rp;
      static dptr constr;

      OptWindow(w);

      if (warg < argc) {
         if (!cnv:C_string(argv[warg],tmp))
            runerr(103,argv[warg]);
#ifdef GraphicsGL
         if (w->window->is_gl) {
            if (gl_setfont(w,&tmp) == Failed) fail;
            }
         else
#endif                                  /* GraphicsGL */
          {
          if (setfont(w,&tmp) == Failed) fail;
         }}
#ifdef GraphicsGL
      if (w->window->is_gl)
         gl_getfntnam(w, buf);
      else
#endif                                  /* GraphicsGL */
      getfntnam(w, buf);
      len = strlen(buf);
#ifdef Graphics3D
      if (w->context->rendermode == UGL3D) {
         if (!constr)
            if (!(constr = rec_structor3d(GL3D_FONT)))
              syserr("failed to create opengl record constructor");
         nfields = (int) ((struct b_proc *)BlkLoc(*constr))->nfields;

         Protect(rp = alcrecd(nfields, BlkLoc(*constr)), runerr(0));
         f.dword = D_Record;
         f.vword.bptr = (union block *) rp;

         MakeStr("Font3d", 10, &(rp->fields[0]));

         draw_code = si_s2i(redraw3Dnames, "Font3d");
         if (draw_code == -1)
             fail;

         MakeInt(draw_code, &rp->fields[1]);
         MakeInt(curr_font, &rp->fields[2]);
         c_put(&(w->window->funclist), &f);
        }
#endif                                  /* Graphics3D */
      Protect(tmp = alcstr(buf, len), runerr(0));
      return string(len,tmp);
      }
end


"FreeColor(argv[]) - free colors"

function{1} FreeColor(argv[argc])
   abstract {
      return file
      }
   body {
      wbp w;
      int warg = 0;
      int i;
      C_integer n;
      tended char *s;

      OptWindow(w);
      if (argc - warg == 0) runerr(103);

      for (i = warg; i < argc; i++) {
         if (is:integer(argv[i])) {
            CnvCInteger(argv[i], n)
            if (n < 0) {
#ifdef GraphicsGL
               if (w->window->is_gl)
                  gl_free_mutable(w, n);
               else
#endif                                  /* GraphicsGL */
               free_mutable(w, n);
            }
         }
         else {
            if (!cnv:C_string(argv[i], s))
               runerr(103,argv[i]);
#ifdef GraphicsGL
            if (!w->window->is_gl)
               gl_freecolor(w, s);
            else
#endif                                  /* GraphicsGL */
            freecolor(w, s);
            }
         }

      ReturnWindow;
      }

end


"GotoRC(w,r,c) - move cursor to a particular text row and column"

function{1} GotoRC(argv[argc])
   abstract {
      return file
      }
   body {
      C_integer r, c;
      wbp w;
      int warg = 0;
      OptWindow(w);

      if (argc - warg < 1)
         r = 1;
      else
         CnvCInteger(argv[warg], r)
      if (argc - warg < 2)
         c = 1;
      else
         CnvCInteger(argv[warg + 1], c)

      gotorc(w,r,c);

      ReturnWindow;
      }
end


"GotoXY(w,x,y) - move cursor to a particular pixel location"

function{1} GotoXY(argv[argc])
   abstract {
      return file
      }
   body {
      wbp w;
      C_integer x, y;
      int warg = 0;
      OptWindow(w);

      if (argc - warg < 1)
         x = 0;
      else
         CnvCInteger(argv[warg], x)
      if (argc - warg < 2)
         y = 0;
      else
         CnvCInteger(argv[warg + 1], y)

      gotoxy(w, x, y);

      ReturnWindow;
      }
end


"Lower(w) - lower w to the bottom of the window stack"

function{1} Lower(argv[argc])
   abstract {
      return file
      }
   body {
      wbp w;
      int warg = 0;
      OptWindow(w);
#ifdef GraphicsGL
      if (w->window->is_gl)
         gl_lowerWindow(w);
      else
#endif                                  /* GraphicsGL */
      lowerWindow(w);
      ReturnWindow;
      }
end


"NewColor(w,s) - allocate an entry in the color map"

function{0,1} NewColor(argv[argc])
   abstract {
      return integer
      }
   body {
      wbp w;
      int rv;
      int warg = 0;
      OptWindow(w);

#ifdef GraphicsGL
      if (w->window->is_gl) {
         if (gl_mutable_color(w, argv+warg, argc-warg, &rv) == Failed) fail;
         }
      else
#endif                                  /* GraphicsGL */
      if (mutable_color(w, argv+warg, argc-warg, &rv) == Failed) fail;
      return C_integer rv;
      }
end



"PaletteChars(w,p) - return the characters forming keys to palette p"

function{0,1} PaletteChars(argv[argc])
   abstract {
      return string
      }
   body {
      int n, warg;
      extern char c1list[], c2list[], c3list[], c4list[];

      if (is:file(argv[0]) && (BlkD(argv[0],File)->status & Fs_Window))
         warg = 1;
      else
         warg = 0;              /* window not required */
      if (argc - warg < 1)
         n = 1;
      else
         n = palnum(&argv[warg]);
      switch (n) {
         case -1:  runerr(103, argv[warg]);             /* not a string */
         case  0:  fail;                                /* unrecognized */
         case  1:  return string(90, c1list);                   /* c1 */
         case  2:  return string(9, c2list);                    /* c2 */
         case  3:  return string(31, c3list);                   /* c3 */
         case  4:  return string(73, c4list);                   /* c4 */
         case  5:  return string(141, (char *)allchars);        /* c5 */
         case  6:  return string(241, (char *)allchars);        /* c6 */
         default:                                       /* gn */
            if (n >= -64)
               return string(-n, c4list);
            else
               return string(-n, (char *)allchars);
         }
      fail; /* NOTREACHED */ /* avoid spurious rtt warning message */
      }
end


"PaletteColor(w,p,s) - return color of key s in palette p"

function{0,1} PaletteColor(argv[argc])
   abstract {
      return string
      }
   body {
      int p, warg, len;
      char tmp[24];
      tended char *s;
      struct palentry *e;
      tended struct descrip d;

      if (is:file(argv[0]) && (BlkD(argv[0],File)->status & Fs_Window))
         warg = 1;
      else
         warg = 0;                      /* window not required */
      if (argc - warg < 2)
         runerr(103);
      p = palnum(&argv[warg]);
      if (p == -1)
         runerr(103, argv[warg]);
      if (p == 0)
         fail;
      if (!cnv:tmp_string(argv[warg + 1], d))
         runerr(103, argv[warg + 1]);
      if (StrLen(d) != 1)
         runerr(205, d);
      e = palsetup(p);
      if (e == NULL)
         runerr(305);
      e += *StrLoc(d) & 0xFF;
      if (!e->valid)
         fail;
      sprintf(tmp, "%ld,%ld,%ld", e->clr.red, e->clr.green, e->clr.blue);
      len = strlen(tmp);
      Protect(s = alcstr(tmp, len), runerr(306));
      return string(len, s);
      }
end


"PaletteKey(w,p,s) - return key of closest color to s in palette p"

function{0,1} PaletteKey(argv[argc])
   abstract {
      return string
      }
   body {
      wbp w;
      int warg = 0, p;
      C_integer n;
      tended char *s;
      long r, g, b, a;

      if (is:file(argv[0]) && (BlkD(argv[0],File)->status & Fs_Window)) {
         w = BlkLoc(argv[0])->File.fd.wb;       /* explicit window */
         warg = 1;
         }
      else if (is:file(kywd_xwin[XKey_Window]) &&
            (BlkD(kywd_xwin[XKey_Window],File)->status & Fs_Window))
         w = BlkLoc(kywd_xwin[XKey_Window])->File.fd.wb;        /* &window */
      else
         w = NULL;                      /* no window (but proceed anyway) */

      if (argc - warg < 2)
         runerr(103);
      p = palnum(&argv[warg]);
      if (p == -1)
         runerr(103, argv[warg]);
      if (p == 0)
         fail;

      if (cnv:C_integer(argv[warg + 1], n)) {
#ifdef GraphicsGL
         if (w->window->is_gl) {
            if (w == NULL || (s = gl_get_mutable_name(w, n)) == NULL)
               fail;
            }
         else
#endif                                  /* GraphicsGL */
         if (w == NULL || (s = get_mutable_name(w, n)) == NULL)
            fail;
         }
      else if (!cnv:C_string(argv[warg + 1], s))
         runerr(103, argv[warg + 1]);

      if (parsecolor(w, s, &r, &g, &b, &a) == Succeeded)
         return string(1, rgbkey(p, r / 65535.0, g / 65535.0, b / 65535.0));
      else
         fail;
      }
end


"Pattern(w,s) - sets the context fill pattern by string name"

function{1} Pattern(argv[argc])
   abstract {
      return file
      }
   body {
      int warg = 0;
      wbp w;
      OptWindow(w);

      if (argc - warg == 0)
         runerr(103, nulldesc);

      if (! cnv:string(argv[warg], argv[warg]))
         runerr(103, nulldesc);

#ifdef GraphicsGL
      if (w->window->is_gl)
         switch (gl_SetPattern(w, StrLoc(argv[warg]), StrLen(argv[warg]))) {
            case RunError:
               runerr(0, argv[warg]);
            case Failed:
               fail;
            }
      else
#endif                                  /* GraphicsGL */
      switch (SetPattern(w, StrLoc(argv[warg]), StrLen(argv[warg]))) {
         case RunError:
            runerr(0, argv[warg]);
         case Failed:
            fail;
         }

      ReturnWindow;
      }
end


"Pending(w,x[]) - produce a list of events pending on window"

function{0,1} Pending(argv[argc])
   abstract {
      return list
      }
   body {
      wbp w;
      int warg = 0;
      wsp ws;
      int i;
      int isclosed = 0;

      /* not using OptWindow() macro here since Pending() does no I/O */

      if (argc>warg && is:file(argv[warg])) {
         if ((BlkD(argv[warg],File)->status & Fs_Window) == 0)
            runerr(140,argv[warg]);
         if ((BlkD(argv[warg],File)->status & Fs_Write) == 0)
            isclosed = 1;

         w = BlkD(argv[warg],File)->fd.wb;
#ifdef ConsoleWindow
         checkOpenConsole((FILE *)w, NULL);
#endif                                  /* ConsoleWindow */
         if (ISCLOSED(w))
            isclosed = 1;
         warg++;
         }
      else {
         if (!(is:file(kywd_xwin[XKey_Window]) &&
              (BlkD(kywd_xwin[XKey_Window],File)->status & Fs_Window)))
            runerr(140,kywd_xwin[XKey_Window]);
         if ((BlkD(kywd_xwin[XKey_Window],File)->status& (Fs_Read|Fs_Write))==0)
            isclosed = 1;
         w = BlkLoc(kywd_xwin[XKey_Window])->File.fd.wb;
         if (ISCLOSED(w))
            isclosed = 1;
         }

      ws = w->window;
      if (isclosed == 0) {
#ifdef GraphicsGL
         if (w->window->is_gl)
            gl_wsync(w);
         else
#endif                                  /* GraphicsGL */
         wsync(w);
         }

      /*
       * put additional arguments to Pending on the pending list in
       * guaranteed consecutive order.
       */
      for (i = warg; i < argc; i++) {
         c_put(&(ws->listp), &argv[i]);
         }

      /*
       * retrieve any events that might be relevant before returning the
       * pending queue.
       */
      switch (pollevent()) {
         case -1: runerr(141);
         case 0: fail;
         }
      return ws->listp;
      }
end



"Pixel(w,x,y,width,height) - produce the contents of some pixels"

function{3} Pixel(argv[argc])
   abstract {
      return integer ++ string
      }
   body {
      struct imgmem imem;
      C_integer x, y, width, height;
      wbp w;
      int warg = 0, slen, r;
      tended struct descrip lastval;
      char strout[50];
      OptWindow(w);

      r = rectargs(w, argc, argv, warg, &x, &y, &width, &height);
      if (r >= 0)
         runerr(101, argv[r]);

      {
      int i, j;
      long rv;
      wsp ws = w->window;

#ifndef max
#define max(x,y) (((x)<(y))?(y):(x))
#define min(x,y) (((x)>(y))?(y):(x))
#endif

      imem.x = max(x,0);
      imem.y = max(y,0);
      imem.width = min(width, (int)ws->width - imem.x);
      imem.height = min(height, (int)ws->height - imem.y);

#ifdef GraphicsGL
      if (w->window->is_gl) {
         if (gl_getpixel_init(w, &imem) == Failed) fail;
         }
      else
#endif                                  /* GraphicsGL */
      if (getpixel_init(w, &imem) == Failed) fail;

      lastval = emptystr;

      for (j=y; j < y + height; j++) {
         for (i=x; i < x + width; i++) {
#ifdef GraphicsGL
            if (w->window->is_gl)
               gl_getpixel(w, i, j, &rv, strout, &imem);
            else
#endif                                  /* GraphicsGL */
            getpixel(w, i, j, &rv, strout, &imem);

            slen = strlen(strout);
            if (rv >= 0) {
               if (slen != StrLen(lastval) ||
                     strncmp(strout, StrLoc(lastval), slen)) {
                  Protect((StrLoc(lastval) = alcstr(strout, slen)), runerr(0));
                  StrLen(lastval) = slen;
                  }
#if COMPILER
               suspend lastval;         /* memory leak on vanquish */
#else                                   /* COMPILER */
               /*
                * suspend, but free up imem if vanquished; RTL workaround.
                * Needs implementing under the compiler iconc.
                */
               {
               int signal;
               r_args[0] = lastval;
#ifdef TSTATARG
               if ((signal = interp(G_Fsusp, r_args, CURTSTATARG)) != A_Resume) {
#else                                    /* TSTATARG */
               if ((signal = interp(G_Fsusp, r_args)) != A_Resume) {
#endif                                   /* TSTATARG */
                  tend = r_tend.previous;
#ifdef GraphicsGL
                  if (w->window->is_gl)
                     gl_getpixel_term(w, &imem);
                  else
#endif                                  /* GraphicsGL */
                  getpixel_term(w, &imem);
                  VanquishReturn(signal);
                  }
               }
#endif                                  /* COMPILER */
               }
            else {
#if COMPILER
               suspend C_integer rv;    /* memory leak on vanquish */
#else                                   /* COMPILER */
               int signal;
               /*
                * suspend, but free up imem if vanquished; RTL workaround
                * Needs implementing under the compiler.
                */
               r_args[0].dword = D_Integer;
               r_args[0].vword.integr = rv;
#ifdef TSTATARG
               if ((signal = interp(G_Fsusp, r_args, CURTSTATARG)) != A_Resume) {
#else                                    /* TSTATARG */
               if ((signal = interp(G_Fsusp, r_args)) != A_Resume) {
#endif                                   /* TSTATARG */
                  tend = r_tend.previous;
#ifdef GraphicsGL
                  if (w->window->is_gl)
                     gl_getpixel_term(w, &imem);
                  else
#endif                                  /* GraphicsGL */
                  getpixel_term(w, &imem);
                  VanquishReturn(signal);
                  }
#endif                                  /* COMPILER */
               }
            }
         }
#ifdef GraphicsGL
      if (w->window->is_gl)
         gl_getpixel_term(w, &imem);
      else
#endif                                  /* GraphicsGL */
      getpixel_term(w, &imem);
      fail;
      }
      }
end


"QueryPointer(w) - produce mouse position"

function{0,2} QueryPointer(w)

   declare {
      XPoint xp;
      }
   abstract {
      return integer
      }
   body {
      CURTSTATVAR();
      pollevent();
      if (is:null(w)) {
         query_rootpointer(&xp);
         }
      else {
         if (!is:file(w) || !(BlkD(w,File)->status & Fs_Window))
            runerr(140, w);
#ifdef GraphicsGL
         if ((BlkD(w,File)->fd.wb)->window->is_gl)
            gl_query_pointer(BlkLoc(w)->File.fd.wb, &xp);
         else
#endif                                  /* GraphicsGL */
         query_pointer(BlkLoc(w)->File.fd.wb, &xp);
         }
      suspend C_integer xp.x;
      suspend C_integer xp.y;
      fail;
      }
end


"Raise(w) - raise w to the top of the window stack"

function{1} Raise(argv[argc])
   abstract {
      return file
      }
   body {
      wbp w;
      int warg = 0;
      OptWindow(w);
#ifdef GraphicsGL
      if (w->window->is_gl)
         gl_raiseWindow(w);
      else
#endif                                  /* GraphicsGL */
      raiseWindow(w);
      ReturnWindow;
      }
end


"ReadImage(w, s, x, y, p) - load image file"

function{0,1} ReadImage(argv[argc])
   abstract {
      return integer
      }
   body {
      wbp w;
      char filename[MaxFileName + 1];
      tended char *tmp;
      int status, warg = 0;
      C_integer x, y;
      int p, r;
      struct imgdata imd;
#ifdef Graphics3D
      int is_texture=0;
      int texhandle;
#endif                                  /* Graphics3D */
      OptTexWindow(w);

#ifdef Graphics3D
      if (is_texture){
         warg=1;
         imd.format = UCOLOR_RGB;
         imd.is_bottom_up = 1;
         }
      else
#endif                                  /* Graphics3D */
      {
#if NT
         imd.format = UCOLOR_BGR;
#else
         imd.format = UCOLOR_RGB;
#endif
         imd.is_bottom_up = 0;
      }

      if (argc - warg == 0)
         runerr(103,nulldesc);
      if (!cnv:C_string(argv[warg], tmp))
         runerr(103,argv[warg]);

      /*
       * x and y must be integers; they default to the upper left pixel.
       */
      if (argc - warg < 2)
         x = -w->context->dx;
      else if (!def:C_integer(argv[warg+1], -w->context->dx, x))
         runerr(101, argv[warg+1]);

      if (argc - warg < 3)
         y = -w->context->dy;
      else if (!def:C_integer(argv[warg+2], -w->context->dy, y))
         runerr(101, argv[warg+2]);

      /*
       * p is an optional palette name.
       */
      if (argc - warg < 4 || is:null(argv[warg+3])) p = 0;
      else {
         p = palnum(&argv[warg+3]);
         if (p == -1)
            runerr(103, argv[warg+3]);
         if (p == 0)
            fail;
         }

      x += w->context->dx;
      y += w->context->dy;
      strncpy(filename, tmp, MaxFileName);   /* copy to loc that won't move*/
      filename[MaxFileName] = '\0';


      /*
       * First try to read as one of the supported image file formats.
       * If that doesn't work, try platform-dependent image reading code.
       */
      r = readImage(filename, p, &imd);
      if (r == Succeeded) {

#ifdef Graphics3D
         if (is_texture) {
            if (texhandle > w->context->display->ntextures)
               runerr(102, argv[warg]);
            return C_integer (word) TexReadImage(w, texhandle, x, y, &imd);
            }
#endif                                  /* Graphics3D */

#ifdef GraphicsGL
         if (w->window->is_gl)
            status = gl_strimage(w, x, y, imd.width, imd.height, imd.paltbl,
                           imd.data, (word)imd.width * (word)imd.height, 0);
         else
#endif                                  /* GraphicsGL */
         status = strimage(w, x, y, imd.width, imd.height, imd.paltbl,
                           imd.data, (word)imd.width * (word)imd.height, 0);
         if (status < 0)
            r = RunError;
         free((pointer)imd.paltbl);
         free((pointer)imd.data);
         }
      else if (r == Failed) {
#ifdef GraphicsGL
         if (w->window->is_gl)
            r = gl_readimage(w, filename, x, y, &status);
         else
#endif                                  /* GraphicsGL */
         r = readimage(w, filename, x, y, &status);
         }
      if (r == RunError)
         runerr(305);
      if (r == Failed)
         fail;
      if (status == 0)
         return nulldesc;
      else
         return C_integer (word)status;
      }
end



"WSync(w) - synchronize with server"

function{1} WSync(w)
   abstract {
      return file++null
      }
   body {
#if !NT
      wbp _w_;

      if (is:null(w)) {
         _w_ = NULL;
         }
      else if (!is:file(w)) runerr(140,w);
      else {
         if (!(BlkD(w,File)->status & Fs_Window))
            runerr(140,w);
         _w_ = BlkLoc(w)->File.fd.wb;
         }

#ifdef GraphicsGL
      if (_w_ != NULL &&_w_->window->is_gl)
         gl_wsync(_w_);
      else
#endif                                  /* GraphicsGL */
      wsync(_w_);
#endif
      pollevent();
      return w;
      }
end


"TextWidth(w,s) - compute text pixel width"

function{1} TextWidth(argv[argc])
   abstract {
      return integer
      }
   body {
      wbp w;
      int warg=0;
      C_integer i;
      OptWindow(w);

      if (warg == argc) runerr(103,nulldesc);
      else if (!cnv:tmp_string(argv[warg],argv[warg]))
         runerr(103,argv[warg]);

#ifdef GraphicsGL
      if (w->window->is_gl)
         i = GL_TEXTWIDTH(w, StrLoc(argv[warg]), StrLen(argv[warg]));
      else
#endif                                  /* GraphicsGL */
      i = TEXTWIDTH(w, StrLoc(argv[warg]), StrLen(argv[warg]));
      return C_integer i;
      }
end


"Uncouple(w) - uncouple window"

function{1} Uncouple(w)
   abstract {
      return file
      }
   body {
      wbp _w_;
      if (!is:file(w)) runerr(140,w);
      if ((BlkD(w,File)->status & Fs_Window) == 0) runerr(140,w);
      if ((BlkLoc(w)->File.status & (Fs_Read|Fs_Write)) == 0) runerr(142,w);
      _w_ = BlkLoc(w)->File.fd.wb;
      BlkLoc(w)->File.status = Fs_Window; /* no longer open for read/write */
      free_binding(_w_);
      return w;
      }
end

"WAttrib(argv[]) - read/write window attributes"

function{*} WAttrib(argv[argc])
   abstract {
      return file++string++integer
      }
   body {
      wbp w, wsave;
      word n;
      tended struct descrip sbuf, sbuf2 = nulldesc;
      char answer[4096];
      int  pass, config = 0, warg = 0;
#ifdef Graphics3D
      int is_texture = 0;
      int texhandle = 0;
#endif                                  /* Graphics3D */
      OptTexWindow(w);

      wsave = w;
      /*
       * Loop through the arguments.
       */

      for (pass = 1; pass <= 2; pass++) {
         w = wsave;
         if (config && pass == 2) {
#ifdef GraphicsGL
            if (w->window->is_gl) {
               if (gl_do_config(w, config) == Failed) fail;
               }
            else
#endif                                  /* GraphicsGL */
            if (do_config(w, config) == Failed) fail;
            }
         for (n = warg; n < argc; n++) {
            if (is:file(argv[n])) {/* Current argument is a file */
               /*
                * Switch the current file to the file named by the
                *  current argument providing it is a file.  argv[n]
                *  is made to be a empty string to avoid a special case.
                */
               if (!(BlkD(argv[n],File)->status & Fs_Window))
                  runerr(140,argv[n]);
               w = BlkLoc(argv[n])->File.fd.wb;
               if (config && pass == 2) {
#ifdef GraphicsGL
                  if (w->window->is_gl) {
                     if (gl_do_config(w, config) == Failed) fail;
                     }
                  else
#endif                                  /* GraphicsGL */
                  if (do_config(w, config) == Failed) fail;
                  }
               }
            else {      /* Current argument should be a string */
               /*
                * In pass 1, a null argument is an error; failed attribute
                *  assignments are turned into null descriptors for pass 2
                *  and are ignored.
                */
               if (is:null(argv[n])) {
                  if (pass == 2)
                     continue;
                  else runerr(109, argv[n]);
                  }
               /*
                * If its an integer or real, it can't be a valid attribute.
                */
               if (is:integer(argv[n]) || is:real(argv[n]))
                  runerr(145, argv[n]);
               /*
                * Convert the argument to a string
                */
               if (!cnv:tmp_string(argv[n], sbuf)) /* sbuf not allocated */
                  runerr(109, argv[n]);
               /*
                * Read/write the attribute
                */
               if (pass == 1) {

                  char *tmp_s = StrLoc(sbuf);
                  char *tmp_s2 = StrLoc(sbuf) + StrLen(sbuf);
                  for ( ; tmp_s < tmp_s2; tmp_s++)
                     if (*tmp_s == '=') break;
                  if (tmp_s < tmp_s2) {
#ifdef  Graphics3D
                     if (is_texture) {
                        /* For now, no attribute assignments on textures. */
                        if (StrLen(sbuf) > 12 &&
                            !strncmp(StrLoc(sbuf), "windowlabel=", 12)) {
                           fail;
                           }
                        else
                           runerr(0, argv[n]);
                        }
#endif                                  /* Graphics3D */

                     /*
                      * pass 1: perform attribute assignments
                      */


                     switch (wattrib(w, StrLoc(sbuf), StrLen(sbuf),
                                     &sbuf2, answer)) {
                     case Failed:
                        /*
                         * Mark the attribute so we don't produce a result
                         */
                        argv[n] = nulldesc;
                        continue;
                     case RunError: runerr(0, argv[n]);


                     }
                     if (StrLen(sbuf) > 4) {
                        if (!strncmp(StrLoc(sbuf), "pos=", 4)) config |= 1;
                        if (StrLen(sbuf) > 5) {
                           if (!strncmp(StrLoc(sbuf), "posx=", 5)) config |= 1;
                           if (!strncmp(StrLoc(sbuf), "posy=", 5)) config |= 1;
                           if (!strncmp(StrLoc(sbuf), "rows=", 5)) config |= 2;
                           if (!strncmp(StrLoc(sbuf), "size=", 5)) config |= 2;
                           if (StrLen(sbuf) > 6) {
                              if (!strncmp(StrLoc(sbuf), "width=", 6))
                                 config |= 2;
                              if (!strncmp(StrLoc(sbuf), "lines=", 6))
                                 config |= 2;
                              if (StrLen(sbuf) > 7) {
                                 if (!strncmp(StrLoc(sbuf), "height=", 7))
                                    config |= 2;
                                 if (!strncmp(StrLoc(sbuf), "resize=", 7))
                                    config |= 2;
                                 if (StrLen(sbuf) > 8) {
                                    if (!strncmp(StrLoc(sbuf), "columns=", 8))
                                       config |= 2;
                                    if (StrLen(sbuf) > 9) {
                                       if (!strncmp(StrLoc(sbuf),
                                                    "geometry=", 9))
                                          config |= 3;
                                       }
                                    }
                                 }
                              }
                           }
                        }
                     }
                  }
               /*
                * pass 2: perform attribute queries, suspend result(s)
                */
               else if (pass==2) {
                  char *stmp, *stmp2;
                  /*
                   * Turn assignments into queries.
                   */
                  for( stmp = StrLoc(sbuf),
                      stmp2 = stmp + StrLen(sbuf); stmp < stmp2; stmp++)
                     if (*stmp == '=') break;
                  if (stmp < stmp2)
                     StrLen(sbuf) = stmp - StrLoc(sbuf);
#ifdef Graphics3D
                  if (is_texture) {

                     wdp wd = w->context->display;
                     /*
                      * So far, textures support only read-only access to a
                      * couple common canvas attributes (width and height).
                      */
                     if(StrLen(sbuf)==5 && StrLoc(sbuf)[0]=='w' &&
                        StrLoc(sbuf)[1]=='i' && StrLoc(sbuf)[2]=='d' &&
                        StrLoc(sbuf)[3]=='t' && StrLoc(sbuf)[4]=='h') {
                        return C_integer wd->stex[texhandle].width;
                        }
                     else if (StrLen(sbuf)==6 &&
                              StrLoc(sbuf)[0]=='h' && StrLoc(sbuf)[1]=='e' &&
                              StrLoc(sbuf)[2]=='i' && StrLoc(sbuf)[3]=='g' &&
                              StrLoc(sbuf)[4]=='h' && StrLoc(sbuf)[5]=='t') {
                        return C_integer wd->stex[texhandle].height;
                        }
                     else

                        {
                        /* the default=fail semantics will be clear enough
                         * to applications on read.
                         */
                        fail;
                        }
                     }
#endif                                  /* Graphics3D */

                  switch (wattrib(w, StrLoc(sbuf), StrLen(sbuf),
                                  &sbuf2, answer)) {
                  case Failed: continue;
                  case RunError:  runerr(0, argv[n]);
                     }
                  if (is:string(sbuf2)) {
                     char *p=StrLoc(sbuf2);
                     Protect(StrLoc(sbuf2) = alcstr(StrLoc(sbuf2),StrLen(sbuf2)), runerr(0));
                     if (p != answer) free(p);
                     }
                  suspend sbuf2;
                  }
               }
            }
         }
      fail;
      }
end


"WDefault(w,program,option) - get a default value from the environment"

function{0,1} WDefault(argv[argc])
   abstract {
      return string
      }
   body {
      wbp w;
      int warg = 0;
      long l;
      tended char *prog, *opt;
      char sbuf1[MaxCvtLen];
      OptWindow(w);

      if (argc-warg < 2)
         runerr(103);
      if (!cnv:C_string(argv[warg],prog))
         runerr(103,argv[warg]);
      if (!cnv:C_string(argv[warg+1],opt))
         runerr(103,argv[warg+1]);

#ifdef GraphicsGL
      if (w->window->is_gl) {
         if (gl_getdefault(w, prog, opt, sbuf1) == Failed) fail;
         }
      else
#endif                                  /* GraphicsGL */
      if (getdefault(w, prog, opt, sbuf1) == Failed) fail;
      l = strlen(sbuf1);
      Protect(prog = alcstr(sbuf1,l),runerr(0));
      return string(l,prog);
      }
end


"WFlush(w) - flush all output to window w"

function{1} WFlush(argv[argc])
   abstract {
      return file
      }
   body {
      wbp w;
      int warg = 0;
      OptWindow(w);
#ifdef GraphicsGL
      if (w->window->is_gl)
         gl_wflush(w);
      else
#endif                                  /* GraphicsGL */
      wflush(w);
      ReturnWindow;
      }
end


"WriteImage(w,filename,x,y,width,height) - write an image to a file"

function{0,1} WriteImage(argv[argc])
   abstract {
      return file
      }
   body {
      wbp w;
      int r;
      C_integer x, y, width, height, warg = 0;
      tended char *s;
      OptWindow(w);

      if (argc - warg == 0)
         runerr(103, nulldesc);
      else if (!cnv:C_string(argv[warg], s))
         runerr(103, argv[warg]);

      r = rectargs(w, argc, argv, warg + 1, &x, &y, &width, &height);
      if (r >= 0)
         runerr(101, argv[r]);

      /*
       * clip image to window, and fail if zero-sized.
       * (the casts to long are necessary to avoid unsigned comparison.)
       */
      if (x < 0) {
         width += x;
         x = 0;
         }
      if (y < 0) {
         height += y;
         y = 0;
         }
      if (x + width > (long) w->window->width)
         width = w->window->width - x;
      if (y + height > (long) w->window->height)
         height = w->window->height - y;
      if (width <= 0 || height <= 0)
         fail;

      /*
       * try platform-dependent code first; it will reject the call
       * if the file name s does not specify a platform-dependent format.
       */
#ifdef GraphicsGL
      if (w->window->is_gl)
         r = gl_dumpimage(w, s, x, y, width, height);
      else
#endif                                  /* GraphicsGL */
      r = dumpimage(w, s, x, y, width, height);
#if HAVE_LIBJPEG
      if ((r == NoCvt) &&
          (strcmp(s + strlen(s)-4, ".jpg")==0 ||
          (strcmp(s + strlen(s)-4, ".JPG")==0))) {
         r = writeJPEG(w, s, x, y, width, height);
         }
#endif                                  /* HAVE_LIBJPEG */

#if HAVE_LIBPNG
      if ((r == NoCvt) &&
          (strcmp(s + strlen(s)-4, ".png")==0 ||
          (strcmp(s + strlen(s)-4, ".PNG")==0))) {
         r = writePNG(w, s, x, y, width, height);
         }
#endif                                  /* HAVE_LIBPNG */
      if (r == NoCvt)
         r = writeBMP(w, s, x, y, width, height);
      if (r == NoCvt)
         r = writeGIF(w, s, x, y, width, height);
      if (r != Succeeded)
         fail;
      ReturnWindow;
      }
end

#ifdef MSWindows

"WinAssociate(ext) - return the application associated with an extension"

function{0,1} WinAssociate(ext)
   if !is:string(ext) then runerr(103, ext)
   abstract {
      return string
      }
   body {
      FILE *f;
      char *s, fname[MAX_PATH], buf[MAX_PATH];
      int l;

      if (getenv_r("TEMP", fname, MAX_PATH-1) != 0) strcpy(fname, ".\\");
      if (fname[strlen(fname)-1] != '\\') strcat(fname, "\\");
      strcat(fname, "t.");
      fname[strlen(fname)+StrLen(ext)] = '\0';
      strncat(fname, StrLoc(ext), StrLen(ext));
      f = fopen(fname, "w");
      fclose(f);
      if ((word)(FindExecutable(fname, NULL, buf)) < 32) {
         unlink(fname);
         fail;
         }
      unlink(fname);
      l = strlen(buf);
      Protect(s = alcstr(buf, l),runerr(0));
      return string(l, s);
      }
end

"WinPlayMedia(w,x[]) - play a multimedia resource"

function{0,1} WinPlayMedia(argv[argc])
   abstract {
      return null
      }
   body {
      wbp w;
      tended char *tmp;
      int warg = 0;
      word n;
      OptWindow(w);

      for (n = warg; n < argc; n++) {
         if (!cnv:C_string(argv[n], tmp))
            runerr(103,argv[warg]);
         if (playmedia(w, tmp) == Failed) fail;
         }
      return nulldesc;
      }
end


/*
 * Simple Windows-native pushbutton
 */
"WinButton(w, s, x, y, wd, ht) - install a pushbutton with label s on window w"

function{0,1} WinButton(argv[argc])
   abstract {
      return file
      }
   body {
      wbp w;
      wsp ws;
      int i, ii, i2;
      C_integer x, y, width, height, warg = 0;
      tended char *s, *s2;
      tended struct descrip d;
      tended struct b_list *hp;
      OptWindow(w);
      ws = w->window;
      if (warg == argc) fail;
      if (!cnv:C_string(argv[warg], s)) runerr(103, argv[warg]);
      warg++;
      /*
       * look for an existing button with this id.
       */
      for(i = 0; i < ws->nChildren; i++) {
         if (!strcmp(s, ws->child[i].id) && ws->child[i].type==CHILD_BUTTON)
            break;
         }
      /*
       * create a new button if none is found
       */
      if (i == ws->nChildren) {
         SUSPEND_THREADS();
         if (i == ws->nChildren) {
            ws->nChildren++;
            ws->child = realloc(ws->child,
                             ws->nChildren * sizeof(childcontrol));
            makebutton(ws, ws->child + i, s);
            }
         RESUME_THREADS();
         }

      if (warg >= argc) x = 0;
      else if (!def:C_integer(argv[warg], 0, x))
         runerr(101, argv[warg]);
      warg++;
      if (warg >= argc) y = 0;
      else if (!def:C_integer(argv[warg], 0, y))
         runerr(101, argv[warg]);
      warg++;
      /*
       * default width is width of text in system font + 2 chars
       */
      ii = sysTextWidth(w, s, strlen(s)) + 10;
      if (warg >= argc) width = ii;
      else if (!def:C_integer(argv[warg], ii, width))
         runerr(101, argv[warg]);
      warg++;
      /*
       * default height is height of text in system font * 7/4
       */
      i2 = sysFontHeight(w) * 7 / 4;
      if (warg >= argc) height = i2;
      else if (!def:C_integer(argv[warg], i2, height))
         runerr(101, argv[warg]);

      movechild(ws->child + i, x, y, width, height);
      ReturnWindow;
      }
end

"WinScrollBar(w, s, i1, i2, i3, x, y, wd, ht) - install a scrollbar"

function{0,1} WinScrollBar(argv[argc])
   abstract {
      return file
      }
   body {
      wbp w;
      wsp ws;
      C_integer x, y, width, height, warg = 0, i1, i2, i3, i, ii;
      tended char *s, *s2;
      tended struct descrip d;
      tended struct b_list *hp;

      OptWindow(w);
      ws = w->window;
      if (warg == argc) fail;
      if (!cnv:C_string(argv[warg], s)) runerr(103, argv[warg]);
      warg++;
      /*
       * look for an existing scrollbar with this id.
       */
      for(i = 0; i < ws->nChildren; i++) {
         if (!strcmp(s, ws->child[i].id) && ws->child[i].type==CHILD_EDIT)
            break;
         }
      /*
       * i1, the min of the scrollbar range, defaults to 0
       */
      if (warg >= argc) i1 = 0;
      else if (!def:C_integer(argv[warg], 0, i1)) runerr(101, argv[warg]);
      warg++;
      /*
       * i2, the max of the scrollbar range, defaults to 100
       */
      if (warg >= argc) i2 = 100;
      else if (!def:C_integer(argv[warg], 100, i2)) runerr(101, argv[warg]);
      warg++;
      /*
       * create a new scrollbar at end of array if none was found
       */
      if (i == ws->nChildren) {
         SUSPEND_THREADS();
         if (i == ws->nChildren) {
            ws->nChildren++;
            ws->child = realloc(ws->child,
                             ws->nChildren * sizeof(childcontrol));
            makescrollbar(ws, ws->child + i, s, i1, i2);
            }
         RESUME_THREADS();
         }

      /*
       * i3, the interval, defaults to 10
       */
      if (warg >= argc) i3 = 10;
      else if (!def:C_integer(argv[warg], 10, i3))
         runerr(101, argv[warg]);
      warg++;
      /*
       * x defaults to the right edge of the window - system scrollbar width
       */
      ii = ws->width - sysScrollWidth();
      if (warg >= argc) x = ii;
      else if (!def:C_integer(argv[warg], ii, x))
         runerr(101, argv[warg]);
      warg++;
      /*
       * y defaults to 0
       */
      if (warg >= argc) y = 0;
      else if (!def:C_integer(argv[warg], 0, y))
         runerr(101, argv[warg]);
      warg++;
      /*
       * width defaults to system scrollbar width
       */
      ii = sysScrollWidth();
      if (warg >= argc) width = ii;
      else if (!def:C_integer(argv[warg], ii, width))
         runerr(101, argv[warg]);
      warg++;
      /*
       * height defaults to height of the client window
       */
      if (warg >= argc) height = ws->height;
      else if (!def:C_integer(argv[warg], ws->height, height))
         runerr(101, argv[warg]);

      movechild(ws->child + i, x, y, width, height);
      ReturnWindow;
      }
end

/*
 * Simple Windows-native menu bar
 */
"WinMenuBar(w,L1,L2,...) - install a set of top-level menus"

function{0,1} WinMenuBar(argv[argc])
   abstract {
      return file
      }
   body {
      wbp w;
      wsp ws;
      int i, total = 0;
      C_integer warg = 0;
      tended char *s;
      tended struct descrip d;
      OptWindow(w);
      ws = w->window;

      if (warg == argc) fail;
      for (i = warg; i < argc; i++) {
         if (!is:list(argv[i])) runerr(108, argv[i]);
         total += BlkD(argv[i],List)->size;
         }
      /*
       * free up memory for the old menu map
       */
      if (ws->nmMapElems) {
         for (i=0; i<ws->nmMapElems; i++) free(ws->menuMap[i]);
         free(ws->menuMap);
         }
      ws->menuMap = (char **)calloc(total, sizeof(char *));

      if (nativemenubar(w, total, argc, argv, warg, &d) == RunError)
        runerr(103, d);
      ReturnWindow;
      }
end

/*
 * Windows-native editor
 */
"WinEditRegion(w, s, s2, x, y, wd, ht) = install an edit box with label s"

function{0, 2} WinEditRegion(argv[argc])
   abstract {
      return file ++ string
      }
   body {
      wbp w;
      wsp ws;
      tended char *s, *s2;
      C_integer i, x, y, width, height, warg = 0;
      OptWindow(w);
      ws = w->window;
      if (warg == argc) fail;
      if (!cnv:C_string(argv[warg], s))
         runerr(103, argv[warg]);
      warg++;
      /*
       * look for an existing edit region with this id.
       */
      for(i = 0; i < ws->nChildren; i++) {
         if (!strcmp(s, ws->child[i].id) && ws->child[i].type==CHILD_EDIT)
            break;
         }
      /*
       * create a new edit region if none is found
       */
      if (i == ws->nChildren) {
         SUSPEND_THREADS();
         if (i == ws->nChildren) {
            ws->nChildren++;
            ws->child = realloc(ws->child,
                             ws->nChildren * sizeof(childcontrol));
            makeeditregion(w, ws->child + i, s);
            }
         RESUME_THREADS();
         }

      /*
       * Invoked with no value, return the current value of an existing
       * edit region (entire buffer is one gigantic string).
       */
      else if (warg == argc) {
         geteditregion(ws->child + i, &result);
         return result;
         }
      /*
       * Assign a value (s2 string contents) or perform editing command
       */
      if (is:null(argv[warg])) s2 = NULL;
      else if (!cnv:C_string(argv[warg], s2)) runerr(103, argv[warg]);
      warg++;

      if (warg >= argc) x = 0;
      else if (!def:C_integer(argv[warg], 0, x)) runerr(101, argv[warg]);
      warg++;
      if (warg >= argc) y = 0;
      else if (!def:C_integer(argv[warg], 0, y)) runerr(101, argv[warg]);
      warg++;
      if (warg >= argc) width = ws->width - x;
      else if (!def:C_integer(argv[warg], ws->width -x, width))
         runerr(101, argv[warg]);
      warg++;
      if (warg >= argc) height = ws->height - y;
      else if (!def:C_integer(argv[warg], ws->height - y, height))
         runerr(101, argv[warg]);

      if (s2 && !strcmp("!clear", s2)) {
         cleareditregion(ws->child + i);
         s2 = NULL;
         }
      else if (s2 && !strcmp("!copy", s2)) {
         copyeditregion(ws->child + i);
         s2 = NULL;
         }
      else if (s2 && !strcmp("!cut", s2)) {
         cuteditregion(ws->child + i);
         s2 = NULL;
         }
      else if (s2 && !strcmp("!paste", s2)) {
         pasteeditregion(ws->child + i);
         s2 = NULL;
         }
      else if (s2 && !strcmp("!undo", s2)) {
         if (undoeditregion(ws->child + i) == Failed) fail;
         s2 = NULL;
         }
      else if (s2 && !strncmp("!modified=", s2, 10)) {
         setmodifiededitregion(ws->child + i, atoi(s2+10));
         s2 = NULL;
         }
      else if (s2 && !strcmp("!modified", s2)) {
         if (modifiededitregion(ws->child + i) == Failed) fail;
         s2 = NULL;
         }
      else if (s2 && !strncmp("!font=", s2, 6)) {
         if (setchildfont(ws->child + i, s2 + 6) == Succeeded) {
            ReturnWindow;
            }
         else fail;
         }
      else if (s2 && !strcmp("!setsel", s2)) {
         setchildselection(ws, ws->child + i, x, y);
         ReturnWindow;
         }
      else if (s2 && !strcmp("!getsel", s2)) {
         getchildselection(ws, ws->child + i, &x, &y);
         suspend C_integer x + 1;
         if (x != y) suspend C_integer y + 1;
         fail;
         }

      if (s2) {
         seteditregion(ws->child + i, s2);
         }
      movechild(ws->child + i, x, y, width, height);
      setfocusonchild(ws, ws->child + i, width, height);
      ReturnWindow;
      }
end


/*
 * common dialog functions
 */

"WinColorDialog(w,s) - choose a color for a window's context"

function{0,1} WinColorDialog(argv[argc])
   abstract {
      return string
      }
   body {
      wbp w;
      long r, g, b, a, warg = 0;
      tended char *s;
      char buf[64];
      OptWindow(w);

      if (warg < argc) {
         if (is:null(argv[warg])) s = "white";
         else if (!cnv:C_string(argv[warg], s)) runerr(103, argv[warg]);
         }
      else s = "white";
      if (parsecolor(w, s, &r, &g, &b, &a) == Failed) fail;

      if (nativecolordialog(w, r, g, b, buf) == NULL) fail;
      StrLoc(result) = alcstr(buf, strlen(buf));
      StrLen(result) = strlen(buf);
      return result;
      }
end

"WinFontDialog(w,s) - choose a font for a window's context"

function{0,2} WinFontDialog(argv[argc])
   abstract {
      return string
      }
   body {
      wbp w;
      int flags, t, fheight,  warg = 0;
      tended char *s;
      char buf[64];
      char colr[64];
      OptWindow(w);

      if (warg < argc) {
         if (is:null(argv[warg])) s = "fixed";
         else if (!cnv:C_string(argv[warg], s)) runerr(103, argv[warg]);
         }
      else s = "fixed";

      parsefont(s, buf, &flags, &fheight, &t);

      if (nativefontdialog(w, buf, flags, fheight, colr) == Failed) fail;
      StrLoc(result) = alcstr(buf, strlen(buf));
      StrLen(result) = strlen(buf);
      suspend result;
      StrLoc(result) = alcstr(colr, strlen(colr));
      StrLen(result) = strlen(colr);
      return result;
      }
end


"WinOpenDialog(w,s1,s2,i,s3,j,s4) - choose a file to open"

function{0,1} WinOpenDialog(argv[argc])
   abstract {
      return string
      }
   body {
      wbp w;
      int len, slen;
      C_integer i, j, warg = 0;
      char buf3[256], buf4[256], chReplace;
      char *tmpstr;
      tended char *s1, *s2, *s3, *s4;
      OptWindow(w);

      if (warg >= argc || is:null(argv[warg])) {
         s1 = "Open:";
         }
      else if (!cnv:C_string(argv[warg], s1)) {
         runerr(103, argv[warg]);
         }
      warg++;

      if (warg >= argc || is:null(argv[warg])) {
         s2 = "";
         }
      else if (!cnv:C_string(argv[warg], s2)) {
         runerr(103, argv[warg]);
         }
      warg++;

      if (warg >= argc) {
         i = 50;
         }
      else if (!def:C_integer(argv[warg], 50, i)) {
         runerr(101, argv[warg]);
         }
      warg++;

      if (warg >= argc || is:null(argv[warg])) {
         strcpy(buf3,"All Files(*.*)|*.*|");
         s3 = buf3;
         }
      else if (!cnv:C_string(argv[warg], s3)) {
         runerr(103, argv[warg]);
         }
      else {
         strncpy(buf3, s3, 255);
         buf3[255] = '\0';
         s3 = buf3;
         }
      chReplace = s3[strlen(s3)-1];
      slen = strlen(s3);
      for(j=0; j < slen; j++)
         if(s3[j] == chReplace) s3[j] = '\0';
      warg++;

      if (warg >= argc) {
         j = 1;
         }
      else if (!def:C_integer(argv[warg], 1, j)) {
         runerr(101, argv[warg]);
         }
      warg++;

      /* s4 is the directory; defaults to Windows version-specific rules */
      if (warg >= argc || is:null(argv[warg])) {
         s4 = NULL;
         }
      else if (!cnv:C_string(argv[warg], s4)) {
         runerr(103, argv[warg]);
         }
      else {
         strncpy(buf4, s4, 255);
         buf4[255] = '\0';
         s4 = buf4;
         }
      warg++;

      if ((tmpstr = nativefiledialog(w, s1, s2, s3, s4, i, j, 0)) == NULL)
         fail;
      len = strlen(tmpstr);
      StrLoc(result) = tmpstr;
      StrLen(result) = len;
      return result;
      }
end


"WinSelectDialog(w, s1, buttons) - select from a set of choices"

function{0,1} WinSelectDialog(argv[argc])
   abstract {
      return string
      }
   body {
      wbp w;
      C_integer i, warg = 0, len = 0;
      tended char *s1;
      char *s2 = NULL, *tmpstr;
      tended struct descrip d;
      tended struct b_list *hp;
      int lsize;
      OptWindow(w);

      /*
       * look for list of text for the message.  concatenate text strings.
       */
      if (warg == argc)
         fail;
      if (!is:list(argv[warg])) runerr(108, argv[warg]);
      hp  = BlkD(argv[warg], List);
      lsize = hp->size;
      for(i=0; i < lsize; i++) {
         c_get(hp, &d);
         if (!cnv:C_string(d, s1)) runerr(103, d);
         len += strlen(s1)+2;
         if (s2) {
            s2 = realloc(s2, len);
            if (!s2) fail;
            strcat(s2, "\r\n");
            strcat(s2, s1);
            }
         else s2 = salloc(s1);
         c_put(&(argv[warg]), &d);
         }
      warg++;

      if (warg >= argc) {
         hp = NULL;
         }
      else {
         if (!is:list(argv[warg])) runerr(108, argv[warg]);
         hp  = BlkD(argv[warg], List);
         lsize = hp->size;
         for(i=0; i < lsize; i++) {
            c_get(hp, &d);
            if (!cnv:C_string(d, s1)) runerr(103, d);
            c_put(&(argv[warg]), &d);
            }
         }
      tmpstr = nativeselectdialog(w, hp, s2);
      if (tmpstr == NULL) fail;
      free(s2);
      len = strlen(tmpstr);
      StrLoc(result) = alcstr(tmpstr, len);
      StrLen(result) = len;
      return result;
      }
end

"WinSaveDialog(w,s1,s2,i,s3,j,s4) - choose a file to save"

function{0,1} WinSaveDialog(argv[argc])
   abstract {
      return string
      }
   body {
      wbp w;
      int len;
      C_integer i, j, warg = 0, slen;
      char buf3[256], buf4[256], chReplace;
      tended char *tmpstr;
      tended char *s1, *s2, *s3, *s4;
      OptWindow(w);

      if (warg >= argc || is:null(argv[warg])) {
         s1 = "Save:";
         }
      else if (!cnv:C_string(argv[warg], s1)) {
         runerr(103, argv[warg]);
         }
      warg++;

      if (warg >= argc || is:null(argv[warg])) {
         s2 = "";
         }
      else if (!cnv:C_string(argv[warg], s2)) {
         runerr(103, argv[warg]);
         }
      warg++;

      if (warg >= argc) {
         i = 50;
         }
      else if (!def:C_integer(argv[warg], 50, i)) {
         runerr(101, argv[warg]);
         }
      warg++;

      if (warg >= argc || is:null(argv[warg])) {
         strcpy(buf3,"All Files(*.*)|*.*|");
         s3 = buf3;
         }
      else if (!cnv:C_string(argv[warg], s3)) {
         runerr(103, argv[warg]);
         }
      else {
         strcpy(buf3, s3);
         s3 = buf3;
         }
      chReplace = s3[strlen(s3)-1];
      slen = strlen(s3);
      for(j=0; j < slen; j++)
         if(s3[j] == chReplace) s3[j] = '\0';
      warg++;

      if (warg >= argc) {
         j = 1;
         }
      else if (!def:C_integer(argv[warg], 1, j)) {
         runerr(101, argv[warg]);
         }
      warg++;

      /* s4 is the directory; defaults to Windows version-specific rules */
      if (warg >= argc || is:null(argv[warg])) {
         s4 = NULL;
         }
      else if (!cnv:C_string(argv[warg], s4)) {
         runerr(103, argv[warg]);
         }
      else {
         strncpy(buf4, s4, 255);
         buf4[255] = '\0';
         s4 = buf4;
         }
      warg++;

      if ((tmpstr = nativefiledialog(w, s1, s2, s3, s4, i, j, 1)) == NULL)
         fail;
      len = strlen(tmpstr);
      StrLoc(result) = alcstr(tmpstr, len);
      StrLen(result) = len;
      return result;
      }
end
#else
MissingFunc1(WinAssociate)
MissingFuncV(WinPlayMedia)
MissingFuncV(WinButton)
MissingFuncV(WinScrollBar)
MissingFuncV(WinMenuBar)
MissingFuncV(WinEditRegion)
MissingFuncV(WinColorDialog)
MissingFuncV(WinFontDialog)
MissingFuncV(WinOpenDialog)
MissingFuncV(WinSelectDialog)
MissingFuncV(WinSaveDialog)
#endif                                  /* MSWindows */


#else                                   /* Graphics */
MissingFunc(Active)
MissingFuncV(Alert)
MissingFuncV(Bg)
MissingFuncV(Clip)
MissingFuncV(Clone)
MissingFuncV(Color)
MissingFuncV(ColorValue)
MissingFuncV(CopyArea)
MissingFuncV(Couple)
MissingFuncV(DrawArc)
MissingFuncV(DrawCircle)
MissingFuncV(DrawCurve)
MissingFuncV(DrawImage)
MissingFuncV(DrawLine)
MissingFuncV(DrawPoint)
MissingFuncV(DrawPolygon)
MissingFuncV(DrawRectangle)
MissingFuncV(DrawSegment)
MissingFuncV(DrawString)
MissingFuncV(EraseArea)
MissingFuncV(Event)
MissingFuncV(Fg)
MissingFuncV(FillArc)
MissingFuncV(FillCircle)
MissingFuncV(FillPolygon)
MissingFuncV(FillRectangle)
MissingFuncV(Font)
MissingFuncV(FreeColor)
MissingFuncV(GotoRC)
MissingFuncV(GotoXY)
MissingFuncV(Lower)
MissingFuncV(NewColor)
MissingFuncV(PaletteChars)
MissingFuncV(PaletteColor)
MissingFuncV(PaletteKey)
MissingFuncV(Pattern)
MissingFuncV(Pending)
MissingFuncV(Pixel)
MissingFunc1(QueryPointer)
MissingFuncV(Raise)
MissingFuncV(ReadImage)
MissingFuncV(TextWidth)
MissingFunc1(Uncouple)
MissingFuncV(WAttrib)
MissingFuncV(WDefault)
MissingFuncV(WFlush)
MissingFuncV(WriteImage)
MissingFunc1(WSync)
MissingFunc1(WinAssociate)
MissingFuncV(WinPlayMedia)
MissingFuncV(WinButton)
MissingFuncV(WinScrollBar)
MissingFuncV(WinMenuBar)
MissingFuncV(WinEditRegion)
MissingFuncV(WinColorDialog)
MissingFuncV(WinFontDialog)
MissingFuncV(WinOpenDialog)
MissingFuncV(WinSelectDialog)
MissingFuncV(WinSaveDialog)

#endif                                  /* Graphics */


#if defined(Graphics) && defined(Graphics3D)

/*
 * DrawTorus(w,x,y,z,radius1,radius2,...)
 *
 */
"DrawTorus(argv[]) - draw a torus"

function{1} DrawTorus(argv[argc])
   abstract{ return record }
   body {
      wbp w;
      wcp wc;
      int n, i, j, warg = 0, nfields, draw_code;
      double r1, r2, x, y, z;
      tended struct descrip f;
      tended struct b_record *rp;
      static dptr constr;
      char bfmode;

      OptWindow(w);
      EnsureWindow3D(w);

      CheckArgMultiple(5);

      wc = w->context;
      /* tori are not allowed in a 2-dim space */
      if (wc->dim == 2)
         runerr(150);

      if (!constr && !(constr = rec_structor3d(GL3D_TORUS)))
         syserr("failed to create opengl record constructor");
      nfields = (int) BlkD(*constr, Proc)->nfields;

      MakeCurrent(w);
      CheckRendermode(w);
      bfmode = w->window->buffermode;

      for (i = warg; i < argc; i += 5) {

         /* convert parameters and draw torus*/
         if (!cnv:C_double(argv[i], x))    runerr(102, argv[i]);
         if (!cnv:C_double(argv[i+1], y))  runerr(102, argv[i+1]);
         if (!cnv:C_double(argv[i+2], z))  runerr(102, argv[i+2]);
         if (!cnv:C_double(argv[i+3], r1)) runerr(102, argv[i+3]);
         if (!cnv:C_double(argv[i+4], r2)) runerr(102, argv[i+4]);
         if (bfmode == UGL_IMMEDIATE) {
            torus(r1, r2, x, y, z,
                    wc->slices, wc->rings,
                   (wc->texmode?wc->autogen:0));
            glFlush();
            }
         /* create a record of the graphical object */
         Protect(rp = alcrecd(nfields, BlkLoc(*constr)), runerr(0));
         f.dword = D_Record;
         f.vword.bptr = (union block *)rp;
         MakeStr("DrawTorus", 9, &(rp->fields[0])); /* r.name */

         draw_code = si_s2i(redraw3Dnames, "DrawTorus");
         if (draw_code == -1)
             fail;

         MakeInt(draw_code, &(rp->fields[1]));

         for(j = i; j < i + 5; j++)
            rp->fields[2 + j-i] = argv[j];
         c_put(&(w->window->funclist), &f);
         }
      return f;
   }
end

/*
 * DrawCube(w,x,y,z,length,...)
 *
 */
"DrawCube(argv[]){1} - draw a cube"

function{1} DrawCube(argv[argc])
   abstract{ return record }
   body {
      wbp w;
      int n, i, j, warg = 0, nfields, draw_code;
      double l, x, y, z;
      tended struct descrip f;
      tended struct b_record *rp;
      static dptr constr;
      char bfmode;

      OptWindow(w);
      EnsureWindow3D(w);
      CheckArgMultiple(4);

      /* Cubes are not 2-dim objects */
      if (w->context->dim == 2)
         runerr(150);

      if (!constr)
         if (!(constr = rec_structor3d(GL3D_CUBE)))
            syserr("failed to create opengl record constructor");
      nfields = (int) BlkD(*constr, Proc)->nfields;

      MakeCurrent(w);
      CheckRendermode(w);
      bfmode = w->window->buffermode;

      for(i = warg; i < argc; i += 4) {

         /* convert parameters and draw a cube */
         if (!cnv:C_double(argv[i], x))   runerr(102, argv[i]);
         if (!cnv:C_double(argv[i+1], y)) runerr(102, argv[i+1]);
         if (!cnv:C_double(argv[i+2], z)) runerr(102, argv[i+2]);
         if (!cnv:C_double(argv[i+3], l)) runerr(102, argv[i+3]);
         if (bfmode == UGL_IMMEDIATE) {
            cube(l, x, y, z, (w->context->texmode?w->context->autogen:0));
            glFlush();
            }

         /*
          * create a record of the graphical object and its parameters
          */
         Protect(rp = alcrecd(nfields, BlkLoc(*constr)), runerr(0));
         f.dword = D_Record;
         f.vword.bptr = (union block *)rp;
         MakeStr("DrawCube", 8, &(rp->fields[0]));

         draw_code = si_s2i(redraw3Dnames, "DrawCube");
         if (draw_code == -1)
             fail;
         MakeInt(draw_code, &(rp->fields[1]));

         for(j = i; j < i + 4; j++)
            rp->fields[2 + j - i] = argv[j];
         c_put(&(w->window->funclist), &f);
         }
      return f;
      }
end


/*
 * DrawSphere(w,x,y,z,radius,...)
 *
 */
"DrawSphere(argv[]){1} - draw a sphere"

function{1} DrawSphere(argv[argc])
   abstract{ return record }
   body {
      wbp w;
      wcp wc;
      int warg = 0, n, i, nfields, draw_code;
      double r, x, y, z;
      tended struct b_record *rp;
      tended struct descrip f;
      static dptr constr;
      char bfmode;

      OptWindow(w);
      EnsureWindow3D(w);
      CheckArgMultiple(4);

      wc = w->context;

      /* sphere cannot be drawn in a 2-dim scene */
      if (wc->dim == 2) runerr(150);

      if (!constr)
         if (!(constr = rec_structor3d(GL3D_SPHERE)))
            syserr("failed to create opengl record constructor");
      nfields = (int) BlkD(*constr, Proc)->nfields;

      MakeCurrent(w);
      CheckRendermode(w);
      bfmode = w->window->buffermode;
      for(i = warg; i < argc; i += 4) {

         /* convert parameters and draw a sphere */
         if (!cnv:C_double(argv[i], x))    runerr(102, argv[i]);
         if (!cnv:C_double(argv[i+1], y))  runerr(102, argv[i+1]);
         if (!cnv:C_double(argv[i+2], z))  runerr(102, argv[i+2]);
         if (!cnv:C_double(argv[i+3], r))  runerr(102, argv[i+3]);
         if (bfmode == UGL_IMMEDIATE) {
            sphere(r, x, y, z, wc->slices, wc->rings, (wc->texmode?wc->autogen:0));
            glFlush();
            }

         /* create a record of the graphical object */
         Protect(rp = alcrecd(nfields, BlkLoc(*constr)), runerr(0));
         f.dword = D_Record;
         f.vword.bptr = (union block *)rp;
         MakeStr("DrawSphere", 10, &(rp->fields[0])); /* r.name */

         draw_code = si_s2i(redraw3Dnames, "DrawSphere");
         if (draw_code == -1)
             fail;
         MakeInt(draw_code, &(rp->fields[1]));

         /* put parameter in the list for the function */
         rp->fields[2] = argv[i];
         rp->fields[3] = argv[i+1];
         rp->fields[4] = argv[i+2];
         rp->fields[5] = argv[i+3];
         c_put(&(w->window->funclist), &f);
         }
      return f;
      }
end


/*
 * DrawCylinder(w,x,y,z,height,radius1,radius2,...)
 *
 */
"DrawCylinder(argv[]){1} - draw a cylinder"

function{1} DrawCylinder(argv[argc])
   abstract{ return record }
   body {
      wbp w;
      wcp wc;
      int warg = 0, n, i, j, nfields, draw_code;
      double r1, r2, h, x, y, z;
      tended struct descrip f;
      tended struct b_record *rp;
      static dptr constr;
      char bfmode;

      OptWindow(w);
      EnsureWindow3D(w);
      wc = w->context;
      CheckArgMultiple(6);

      /* cylinders cannot be used in a 2-dim scene */
      if (wc->dim == 2) runerr(150);

      if (!constr)
         if (!(constr = rec_structor3d(GL3D_CYLINDER)))
            syserr("failed to create opengl record constructor");
      nfields = (int) BlkD(*constr,Proc)->nfields;

      MakeCurrent(w);
      CheckRendermode(w);
      bfmode = w->window->buffermode;

      for(i = warg; i < argc; i += 6) {

         /* convert parameters and draw a cylinder */
         if (!cnv:C_double(argv[i], x))    runerr(102, argv[i]);
         if (!cnv:C_double(argv[i+1], y))  runerr(102, argv[i+1]);
         if (!cnv:C_double(argv[i+2], z))  runerr(102, argv[i+2]);
         if (!cnv:C_double(argv[i+3], h))  runerr(102, argv[i+3]);
         if (!cnv:C_double(argv[i+4], r1)) runerr(102, argv[i+4]);
         if (!cnv:C_double(argv[i+5], r2)) runerr(102, argv[i+5]);
         if (bfmode == UGL_IMMEDIATE) {
            cylinder(r1, r2, h, x, y, z, wc->slices, wc->rings, (wc->texmode ? wc->autogen : 0));
            glFlush();
            }
         /* create a record of the graphical object */
         Protect(rp = alcrecd(nfields, BlkLoc(*constr)), runerr(0));
         f.dword = D_Record;
         f.vword.bptr = (union block *) rp;
         MakeStr("DrawCylinder", 12, &(rp->fields[0])); /* r.name */

         draw_code = si_s2i(redraw3Dnames, "DrawCylinder");
         if (draw_code == -1)
             fail;

         MakeInt(draw_code, &(rp->fields[1]));

           /* put parameters in the list */
         for(j = i; j < i + 6; j++)
            rp->fields[2 + j - i] = argv[j];
         c_put(&(w->window->funclist), &f);
         }
      return f;
   }
end


/*
 * DrawDisk(w,x,y,z,radius1,radius2,...)
 *
 */

"DrawDisk(argv[]){1} - draw a disk"

function{1} DrawDisk(argv[argc])
   abstract{ return record }
   body {
      wbp w;
      wcp wc;
      int warg = 0, i, nfields, draw_code;
      double r1, r2, a1, a2, x, y, z;
      tended struct descrip f;
      static dptr constr;
      tended struct b_record *rp;
      char bfmode;

      OptWindow(w);
      EnsureWindow3D(w);
      wc = w->context;
      if (!constr)
         if (!(constr = rec_structor3d(GL3D_DISK)))
            syserr("failed to create opengl record constructor");
      nfields = (int) BlkD(*constr, Proc)->nfields;

      MakeCurrent(w);
      CheckRendermode(w);
      bfmode = w->window->buffermode;

      for (i = warg; i < argc; i += 7) {
         if (argc-warg <= i+3)
            runerr(146);

         /* create a record of the graphical object */
         Protect(rp = alcrecd(nfields, BlkLoc(*constr)), runerr(0));
         f.dword = D_Record;
         f.vword.bptr = (union block *)rp;
         MakeStr("DrawDisk", 8, &(rp->fields[0])); /* r.name */

         draw_code = si_s2i(redraw3Dnames, "DrawDisk");
         if (draw_code == -1)
             fail;
         MakeInt(draw_code, &(rp->fields[1]));

         if (!cnv:C_double(argv[i], x))   runerr(102, argv[i]);
         if (!cnv:C_double(argv[i+1], y)) runerr(102, argv[i+1]);
         if (!cnv:C_double(argv[i+2], z)) runerr(102, argv[i+2]);
         if (!cnv:C_double(argv[i+3], r1)) runerr(102, argv[i+3]);
         if (!cnv:C_double(argv[i+4], r2)) runerr(102, argv[i+4]);
         rp->fields[2] = argv[i];
         rp->fields[3] = argv[i+1];
         rp->fields[4] = argv[i+2];
         rp->fields[5] = argv[i+3];
         rp->fields[6] = argv[i+4];

         if (i+5 >= argc) {
            a1 = 0.0;
            rp->fields[7] = zerodesc;
            }
         else {
            if (!cnv:C_double(argv[i+5],a1)) runerr(102, argv[i+5]);
            rp->fields[7] = argv[i+5];
            }

         if (i+6 >= argc) {
            a2 = 360;
            MakeInt(360, &(rp->fields[8]));
            }
         else {
            if (!cnv:C_double(argv[i+6], a2)) runerr(102, argv[i+6]);
            rp->fields[8] = argv[i+6];
            }
         if (bfmode == UGL_IMMEDIATE) {
            disk(r1, r2, a1, a2, x, y, z, wc->slices, wc->rings, (wc->texmode ? wc->autogen : 0));
            glFlush();
            }
         c_put(&(w->window->funclist), &f);
        }
      return f;
      }
end


/*
 * Eye(w,px,py,pz,dx,dy,dz,ux,uy,yz) - get/set eye attributes
 *
 */

"Eye(argv[]){1} - get/set eye attributes"

function{1} Eye(argv[argc])
    abstract{ return record }
    body {
      wbp w;
      wsp ws;
      int warg = 0, i=0, len;
      double x;
      char abuf[128];

      OptWindow(w);
      EnsureWindow3D(w);
      ws = w->window;

      while (warg+i < argc && i < 9) {
         if (!is:null(argv[warg+i]))
            if (!cnv:C_double(argv[warg+i], x))
               runerr(102, argv[warg+i]);
         switch (i) {
            case 0: ws->eyeposx = x; break;
            case 1: ws->eyeposy = x; break;
            case 2: ws->eyeposz = x; break;
            case 3: ws->eyedirx = x; break;
            case 4: ws->eyediry = x; break;
            case 5: ws->eyedirz = x; break;
            case 6: ws->eyeupx = x; break;
            case 7: ws->eyeupy = x; break;
            case 8: ws->eyeupz = x; break;
            }
         i++;
         }

      if (warg < argc) redraw3D(w);

      sprintf(abuf,"%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f",
              ws->eyeposx, ws->eyeposy, ws->eyeposz, ws->eyedirx,
              ws->eyediry, ws->eyedirz, ws->eyeupx, ws->eyeupy, ws->eyeupz);
      len = strlen(abuf);
      StrLoc(result) = alcstr(abuf, len);
      StrLen(result) = len;
      return result;
      }
end

/*
 * Rotate(w,angle,x,y,z,...)
 *
 */

"Rotate(argv[]){1} - rotates objects"

function{1} Rotate(argv[argc])
    abstract{ return record }
    body {
      wbp w;
      int warg = 0, n, i, j;
      tended struct descrip f;
      tended struct b_record *rp;

      OptWindow(w);
      EnsureWindow3D(w);
      CheckArgMultiple(4);

      for(i = warg; i < argc-warg; i = i+4) {
         if ((j = rotate(w, argv, i, &f))) {
            if (j == 1) runerr(0);
            else runerr(102, argv[-j-1]);
            }
         }
      return f;
    }
end


/*
 * Translate(w,x,y,z,...)
 *
 */
"Translate(argv[]){1} - translates objects"

function{1} Translate(argv[argc])
   abstract{ return record }
   body {
      wbp w;
      int warg = 0, i, j, n;
      tended struct descrip f;

      OptWindow(w);
      EnsureWindow3D(w);
      CheckArgMultiple(3);

      for(i = warg; i < argc-warg; i = i+3) {
         if ((j = translate(w, argv, i, &f))) {
            if (j == 1) runerr(0);
            else runerr(102, argv[-j-1]);
            }
         }
      return f;
   }
end


/*
 * Scale(w,x,y,z,...)
 *
 */

"Scale(argv[]){1} - scales objects"

function{1} Scale(argv[argc])
   abstract{ return record }
   body {
      wbp w;
      int warg = 0, n, i, j;
      tended struct descrip f = nulldesc;

      OptWindow(w);
      EnsureWindow3D(w);
      CheckArgMultiple(3);

      for(i = warg; i < argc-warg; i = i+3) {
         if ((j=scale(w, argv, i, &f))) {
            if (j == 1) runerr(0);
            else runerr(102, argv[-j-1]);
            }
         }
      return f;
      }
end

/*
 * PopMatrix(w)
 *
 */
"PopMatrix(argv[]){1} - pop the matrix stack"

function{1} PopMatrix(argv[argc])
   abstract{ return record }
   body {
      wbp w;
      C_integer npops;
      int warg = 0, nfields, i, draw_code;
      tended struct descrip f;
      tended struct b_record *rp;
      static dptr constr;

      OptWindow(w);
      EnsureWindow3D(w);

      if (argc == warg) npops = 1;
      else if (!def:C_integer(argv[warg], 1, npops))
         runerr(101, argv[warg]);

      if (!constr)
         if (!(constr = rec_structor3d(GL3D_POPMATRIX)))
            syserr("failed to create opengl record constructor");
      nfields = (int) BlkD(*constr, Proc)->nfields;

      MakeCurrent(w);

      for (i=0; i<npops; i++) {

         /* pop matrix from the matrix stack, if possible */
         if (popmatrix() == Failed)
            runerr(151);

         /*
          * create a record of the graphical object and its parameters
          */
         Protect(rp = alcrecd(nfields, BlkLoc(*constr)), runerr(0));
         f.dword = D_Record;
         f.vword.bptr = (union block *)rp;
         MakeStr("PopMatrix", 9, &(rp->fields[0]));

         draw_code = si_s2i(redraw3Dnames, "PopMatrix");
         if (draw_code == -1)
             fail;
         MakeInt(draw_code, &(rp->fields[1]));

         c_put(&(w->window->funclist), &f);
         }
      return f;
      }
end


/*
 * PushMatrix(w)
 *
 */

"PushMatrix(argv[]){1} - push a copy of the top matrix onto the matrix stack"

function{1} PushMatrix(argv[argc])
   abstract{ return record }
   body {
      wbp w;
      int warg = 0,  nfields, draw_code;
      tended struct descrip f;
      tended struct b_record *rp;
      static dptr constr;

      OptWindow(w);
      EnsureWindow3D(w);

      if (!constr && !(constr = rec_structor3d(GL3D_PUSHMATRIX)))
         syserr("failed to create opengl record constructor");
      nfields = (int) BlkD(*constr, Proc)->nfields;

      MakeCurrent(w);
      /* push a copy of the top matrix, if possible */
      if (pushmatrix() == Failed)
         runerr(151);

      /*
       * create a record of the graphical object
       */
      Protect(rp = alcrecd(nfields, BlkLoc(*constr)), runerr(0));
      f.dword = D_Record;
      f.vword.bptr = (union block *)rp;
      MakeStr("PushMatrix", 10 ,&(rp->fields[0]));

      draw_code = si_s2i(redraw3Dnames, "PushMatrix");
      if (draw_code == -1)
        fail;
      MakeInt(draw_code, &(rp->fields[1]));

      c_put(&(w->window->funclist), &f);
      return f;
      }
end


"PushTranslate(argv[]){1} - push a copy of the top matrix onto the matrix stack and apply translations"

function{2} PushTranslate(argv[argc])
abstract { return record }
body {
      wbp w;
      int warg = 0, i, j, n;
      tended struct descrip f, f2;

      OptWindow(w);
      EnsureWindow3D(w);
      CheckArgMultiple(3);

      if ((j = pushmatrix_rd(w, &f))) {
         if (j == 151) runerr(j);
         else if (j == -1) runerr(0);
         }

      for(i = warg; i < argc-warg; i = i+3) {
         if ((j = translate(w, argv, i, &f2))) {
            if (j == 1) runerr(0);
            else runerr(102, argv[-j-1]);
            }
         }

      suspend f;
      return f2;
      }
end


"PushRotate(argv[]){1} - push a copy of the top matrix onto the matrix stack and apply rotations"

function{2} PushRotate(argv[argc])
abstract { return record }
body {
      wbp w;
      int warg = 0, i, j, n;
      tended struct descrip f, f2;

      OptWindow(w);
      EnsureWindow3D(w);
      CheckArgMultiple(4);

      if ((j = pushmatrix_rd(w, &f))) {
         if (j == 151) runerr(j);
         else if (j == -1) runerr(0);
         }

      for(i = warg; i < argc-warg; i = i+4) {
         if ((j = rotate(w, argv, i, &f2))) {
            if (j == 1) runerr(0);
            else runerr(102, argv[-j-1]);
            }
         }

      suspend f;
      return f2;
      }
end


"PushScale(argv[]){1} - push a copy of the top matrix onto the matrix stack and apply scales"

function{2} PushScale(argv[argc])
abstract { return record }
body {
      wbp w;
      int warg = 0, i, j, n;
      tended struct descrip f, f2;

      OptWindow(w);
      EnsureWindow3D(w);
      CheckArgMultiple(3);

      if ((j = pushmatrix_rd(w, &f))) {
         if (j == 151) runerr(j);
         else if (j == -1) runerr(0);
         }

      for(i = warg; i < argc-warg; i = i+3) {
         if ((j = scale(w, argv, i, &f2))) {
            if (j == 1) runerr(0);
            else runerr(102, argv[-j-1]);
            }
         }

      suspend f;
      return f2;
      }
end

/*
 * IdentityMatrix(w)
 */
"IdentityMatrix(argv[]){1} - change the top matrix to the identity"

function{1} IdentityMatrix(argv[argc])
   abstract { return record }
   body {
      wbp w;
      int warg = 0, nfields, draw_code;
      tended struct descrip f;
      tended struct b_record *rp;
      static dptr constr;

      OptWindow(w);
      EnsureWindow3D(w);

      if (!constr)
         if (!(constr = rec_structor3d(GL3D_IDENTITY)))
            syserr("failed to create opengl record constructor");
      nfields = (int) BlkD(*constr, Proc)->nfields;

      /*
       * create a record of the graphical object and its parameters
       */
      Protect(rp = alcrecd(nfields, BlkLoc(*constr)), runerr(0));
      f.dword = D_Record;
      f.vword.bptr = (union block *)rp;
      MakeStr("LoadIdentity", 12, &(rp->fields[0]));

      draw_code = si_s2i(redraw3Dnames, "LoadIdentity");
      if (draw_code == -1)
        fail;
      MakeInt(draw_code, &(rp->fields[1]));

      c_put(&(w->window->funclist), &f);

      /* load identity matrix */
      identitymatrix();
      return f;
   }
end


/*
 * MatrixMode(w, s)
 *
 */
"MatrixMode(argv[]){1} - use the matrix stack specified by s"

function{1} MatrixMode(argv[argc])
   abstract { return record }
   body {
      wbp w;
      int warg = 0, nfields, draw_code;
      tended char* temp;
      tended struct descrip f;
      tended struct b_record *rp;
      static dptr constr;

      OptWindow(w);
      EnsureWindow3D(w);

      if (!constr && !(constr = rec_structor3d(GL3D_MATRIXMODE)))
         syserr("failed to create opengl record constructor");
      nfields = (int) BlkD(*constr, Proc)->nfields;

      /*
       * create a record of the graphical object and its parameters
       */
      Protect(rp = alcrecd(nfields, BlkLoc(*constr)), runerr(0));
      f.dword = D_Record;
      f.vword.bptr = (union block *)rp;
      MakeStr("MatrixMode", 10, &(rp->fields[0]));

      draw_code = si_s2i(redraw3Dnames, "MatrixMode");
      if (draw_code == -1)
        fail;
      MakeInt(draw_code, &(rp->fields[1]));

      /* convert parameter */
      if (!cnv:C_string(argv[warg],temp)) runerr(103,argv[warg]);

      /* the only "failure" is: the argument was illegal */
      switch (setmatrixmode(temp)) {
      case RunError: runerr(152, argv[warg]); break;
      case Failed: fail;
      }

      /* put parameter in the list */
      rp->fields[2] = argv[warg];
      c_put(&(w->window->funclist), &f);
      return f;
      }
end

/*
 * Texture(x) sets the current texture used in drawing 3D shapes.
 * Texture(R) reuses an existing texture.
 * Texture(s) sets a new texture from string s.
 * Texture(w1,w2) sets a new texture from window w2.
 * Texture(x, i) replace texture #i with what is in x.
 * Texture(x, R) replace R's texture with what is in x.
 * Texture(x, texturehandle) replaces a texture (and also sets
 * it as the current texture).
 * texturehandle is an integer or a (display list texture record).
 */

"Texture([w], x) - apply the texture defined by the string or window x as a texture "

function{1} Texture(argv[argc])
   abstract{ return record }
   body {
      wbp w, w2;
      wcp wc;
      int warg = 0, nfields, draw_code, i, saved_tex;
      tended char* tmp;
      tended struct descrip f;
      tended struct b_record *rp;
      static dptr constr;
      C_integer theTexture=-1;

      OptWindow(w);
      EnsureWindow3D(w);
      wc = w->context;
      if (argc - warg < 1)/* missing texture source */
         runerr(103);

      if (!constr && !(constr = rec_structor3d(GL3D_TEXTURE)))
         syserr("failed to create opengl record constructor");
      nfields = (int) BlkD(*constr, Proc)->nfields;

      /*
       * create a record of the graphical object and its parameters
       *
       * to redraw a texture we must know the texture name assigned by opengl
       * This name is stored in wc->stex[wc->curtexture].texName
       * so we put wc->curtexture in the list.
       */

      draw_code = si_s2i(redraw3Dnames, "Texture");
      if (draw_code == -1)
        fail;
      Protect(rp = alcrecd(nfields, BlkLoc(*constr)), runerr(0));
      MakeInt(draw_code, &(rp->fields[1]));
      if (argc > 0 && is:file(argv[0]))
         rp->fields[3] = argv[0];
      else
         rp->fields[3] = kywd_xwin[XKey_Window];

      MakeStr("Texture", 7, &(rp->fields[0]));
      f.dword = D_Record;
      f.vword.bptr = (union block *)rp;

      saved_tex = wc->curtexture;

      /*
       * Replace an existing texture "name".  In this case, we are setting
       * the current texture (integer handle) and then expecting the later
       * code which is processing argv[warg] to install on our handle.
       * But the later code would normally put in a new texture.
       */
      if (argc - warg > 1) {
         if (is:record(argv[warg+1])) {
            if (!cnv:C_string(BlkD(argv[warg],Record)->fields[0], tmp))
               runerr(103, argv[warg]);
            if (strcmp(tmp, "Texture")) runerr(103, argv[warg]);
            /* Pull out the texture handle */
            theTexture = IntVal(BlkLoc(argv[warg])->Record.fields[2]);
            }
         else if (!cnv:C_integer(argv[warg + 1], theTexture)) {
            runerr(101, argv[warg+1]);
            }
         if ((theTexture<0) || (theTexture>=wc->display->ntextures)) fail;
         theTexture++; /* should be check, probably no need for ++ */

         wc->curtexture = theTexture;
         }

      /*
       * Set the current texture.  It can either be set to a new texture
       * (via string or window argument) or it be set to an existing
       * texture (via integer code and display list Texture record).
       */

      /* check if the source is a record */
      else if (is:record(argv[warg])) {
         C_integer texhandle;

         if (!cnv:C_string(BlkD(argv[warg],Record)->fields[0], tmp))
            runerr(103, argv[warg]);

         if (strcmp(tmp, "Texture")) runerr(103, argv[warg]);

         w2 = BlkD(BlkLoc(argv[warg])->Record.fields[3],File)->fd.wb;
         rp->fields[3] = BlkLoc(argv[warg])->Record.fields[3];
         wc = w2->context;

         /* Pull out the texture handle */
         texhandle = IntVal(BlkLoc(argv[warg])->Record.fields[2]);
         rp->fields[2] = BlkLoc(argv[warg])->Record.fields[2];
         bindtexture(w, texhandle);
         c_put(&(w->window->funclist), &f);
         return f;
         }

      /*
       * If the source texture is another window's contents...
       */
      if (is:file(argv[warg])) {
         if ((BlkD(argv[warg],File)->status & Fs_Window) == 0)
            runerr(140,argv[warg]);
         if ((BlkLoc(argv[warg])->File.status & (Fs_Read|Fs_Write)) == 0)
            runerr(142,argv[warg]);
         w2 = BlkLoc(argv[warg])->File.fd.wb;
         if (ISCLOSED(w2))
            runerr(142,argv[warg]);

         if (theTexture==-1){
            if (make_enough_texture_space(wc->display)==Failed) fail;
            wc->curtexture = wc->display->ntextures;
            }
         else
            wc->curtexture = theTexture;

         /* convert the window into a texture */
         if (w2->context->rendermode == UGL3D)
            i = texwindow3D(w, w2);
         else
            i = texwindow2D(w, w2);

         if (i==Succeeded) {
            if (wc->curtexture == wc->display->ntextures)
               wc->display->ntextures++;
            MakeInt(wc->curtexture, &(rp->fields[2]));
            c_put(&(w->window->funclist), &f);
            return f;
            }
         else {
            wc->curtexture = saved_tex;
            fail;
            }
         }
      else {
         /*
          * Otherwise it must be a string (probably, a filename).
          */
         if (!cnv:C_string(argv[warg], tmp)) runerr(103, argv[warg]);
         i = settexture(w, tmp, strlen(tmp), &f, theTexture, 1);

         if (i==Succeeded)
            return f;
         else
            fail;
         }
   }
end

/*
 * Texcoord (w, s) or Texture (w, L)
 */

"Texcoord(argv[]){1} - set texture coordinate to those defined by the string s or the list L "

function{1} Texcoord(argv[argc])
   abstract { return list }
   body {
      wbp w;
      wcp wc;
      int warg = 0, num;
      tended char* tmp;
      tended struct descrip f, mode;
      tended struct descrip d;
#ifdef Arrays
      tended struct b_realarray *ap;
#endif                                  /* Arrays */

      OptWindow(w);
      EnsureWindow3D(w);
      wc = w->context;
      num=argc-warg;
      if (num < 1) /* missing the texture coordinates */
         runerr(103);

      /* create a list */
      if (create3Dlisthdr(&f, "Texcoord", 8)!=Succeeded)
        fail;

      /* check if the argument is a list */
      if (is:list(argv[warg]))
         num = BlkD(argv[warg], List)->size;
      else {
         num = argc-warg;

         if (num == 1) { /* probably "auto" */
            if (!cnv:C_string(argv[warg], tmp))
               runerr(103, argv[warg]);
            if (!strcmp(tmp, "auto")) {
               wc->autogen = 1;
               wc->numtexcoords = 0;
               applyAutomaticTextureCoords(1);
               mode = onedesc;
               c_put(&f, &mode);
               c_put(&(w->window->funclist), &f);
               return f;
               }
            else fail;
            }
         }

      applyAutomaticTextureCoords(0);
      mode = zerodesc;
      c_put(&f, &mode);
      wc->autogen = 0;
      wc->numtexcoords = 0;
      if (cplist2realarray(&argv[warg], &d, 0, num, 0)!=Succeeded)
         runerr(305, argv[warg]);
#ifdef  Arrays
      ap = (struct b_realarray *) BlkD(d, List)->listhead;
      wc->texcoords = ap;
#endif                                  /* Arrays */
      wc->numtexcoords = num;
      c_put(&f, &d);

      /* there must be an even number of arguments */
      if (num % 2  != 0) {
         runerr(154);
         }
      c_put(&(w->window->funclist), &f);
      return f;
      }
end

/*
 * Normals (w, s) or Normals (w, L)
 */

"Normal(argv[]){1} - set texture coordinate to those defined by the string s or the list L "

function{1} Normals(argv[argc])
   abstract { return list }
   body {
      wbp w;
      wcp wc;
      int warg = 0, num;
      tended struct descrip f;
      tended struct descrip d;
#ifdef Arrays
      tended struct b_realarray *ap;
#endif                                  /* Arrays */

      OptWindow(w);
      EnsureWindow3D(w);
      wc = w->context;
      num=argc-warg;
      if (num < 1) /* missing the normals coordinates */
         runerr(103);

      /* create a list */
      if (create3Dlisthdr(&f, "Normals", 4)!=Succeeded)
        fail;

      /* check if the argument is a list */
      if (is:list(argv[warg]))
        num = BlkD(argv[warg], List)->size;
      else {
        num = argc-warg;
        }

      if (cplist2realarray(&argv[warg], &d, 0, num, 0) != Succeeded)
         runerr(305, argv[warg]);
#ifdef Arrays
      ap = (struct b_realarray *) BlkD(d, List)->listhead;
      wc->normals = ap;
#endif                                  /* Arrays */
      wc->numnormals = num;
      c_put(&f, &d);

      c_put(&(w->window->funclist), &f);
      return f;
      }
end

/*
 * MultMatrix (w, L)
 */

"MultMatrix(argv[]){1} - multiply transformation matrix by the list L "

function{1} MultMatrix(argv[argc])
   abstract { return list }
   body {
      wbp w;
      int warg = 0, num;
      tended struct descrip f;
      tended struct descrip d;
#ifdef Arrays
      tended struct b_realarray *ap;
#endif                                  /* Arrays */

      OptWindow(w);
      EnsureWindow3D(w);
      if (argc-warg < 1) /* missing the matrix elements */
         runerr(103);

      /* create a list */
      if (create3Dlisthdr(&f, "MultMatrix", 4)!=Succeeded)
        fail;

      /* check if the argument is a list */
      if (is:list(argv[warg]))
        num= BlkD(argv[warg], List)->size;
      else {
        num = argc-warg;
        }

      /*
       * transformation matrix must have 16 values
       */
      if (num != 16 )
        runerr(305);

      if (cplist2realarray(&argv[warg], &d, 0, num, 0) != Succeeded)
        runerr(305, argv[warg]);
#ifdef Arrays
      ap = (struct b_realarray *) BlkD(d, List)->listhead;
#endif                                  /* Arrays */
      c_put(&f, &d);
      c_put(&(w->window->funclist), &f);
#if HAVE_LIBGL
      glMultMatrixd((GLdouble *)ap->a);
#endif                                  /* HAVE_LIBGL */
      return f;
      }
end


/*
 * Refresh(w)
 */

"Refresh(argv[]){1} - redraws the window"

function{1} Refresh(argv[argc])
   abstract{ return file }
   body {
      wbp w;
      int warg = 0;
      OptWindow(w);
      if (!w->window->is_gl) {
         if (warg == 0)
           runerr(150, kywd_xwin[XKey_Window]);
         else
           runerr(150, argv[0]);
         }
      redraw3D(w);
      ReturnWindow;

   }
end

/*
 * WindowContents(w)
 *
 */

"WindowContents(argv[]){1} - returns an Icon list of lists, which contains all objects drawn on window"

function{1} WindowContents(argv[argc])
   abstract{ return list }
   body {
      wbp w;
      int warg = 0;
      OptWindow(w);
#ifdef GraphicsGL
      if (w->context->rendermode == UGL2D)
         return w->window->funclist2d;
      else
#else                                   /* GraphicsGL */
      EnsureWindow3D(w);
#endif                                  /* GraphicsGL */
      return w->window->funclist;
   }
end

"WSection(argv[]){1} - mark section"

function{1} WSection(argv[argc])
  abstract{ return file ++ integer}
  body {
      wbp w;
      wcp wc;
      int warg = 0, nfields, draw_code;
      tended struct descrip f;
      tended struct b_record *rp;
      tended char* tmp;
      static dptr constr, constr2;
      /*
       * Section one is the outer most section.
       * every new nested section increment one
       */
      static int section_depth=1;

      OptWindow(w);
      EnsureWindow3D(w);
      wc = w->context;

      if (argc-warg==0) {       /* section ends */
         if (!section_length(w))
            syserr("failed to find the section length");
         section_depth--;
         if (!(wc->selectionenabled))
            return C_integer 1;   /* selection is off. no record need to be added */

         /*  selection is enabled. add a record to mark the end of the section  */
         if (!constr2 && !(constr2 = rec_structor3d(GL3D_ENDMARK))) {
            syserr("failed to create opengl record constructor");
            }
         nfields = (int) ((struct b_proc *)BlkLoc(*constr2))->nfields;

         /* create a record of the graphical object */
         Protect(rp = alcrecd(nfields, BlkLoc(*constr2)), runerr(0));
         f.dword = D_Record;
         f.vword.bptr = (union block *) rp;
         MakeStr("EndMark", 7, &(rp->fields[0]));

         draw_code = si_s2i(redraw3Dnames, "EndMark");
         if (draw_code == -1)
            fail;

         MakeInt(draw_code, &(rp->fields[1]));
         MakeInt(section_depth+1, &(rp->fields[2]));

         c_put(&(w->window->funclist), &f);

         return f;
         }

      if (argc - warg != 1)
         fail;

      if (!constr && !(constr = rec_structor3d(GL3D_MARK))) {
             syserr("failed to create opengl record constructor");
      }
      nfields = (int) BlkD(*constr, Proc)->nfields;

      if (!cnv:string(argv[warg], argv[warg]))
         runerr(103, argv[warg]);

         /* create a record of the graphical object */

      Protect(rp = alcrecd(nfields, BlkLoc(*constr)), runerr(0));
      f.dword = D_Record;
      f.vword.bptr = (union block *) rp;
      MakeStr("Mark", 4, &(rp->fields[0]));

      draw_code = si_s2i(redraw3Dnames, "Mark");
      if (draw_code == -1)
         fail;
      MakeInt(draw_code, &(rp->fields[1]));

      rp->fields[2] = argv[warg];   /* section_name */
      rp->fields[3] = zerodesc;     /* skip */
      rp->fields[4] = zerodesc;     /* count */

      MakeInt(section_depth, &(rp->fields[6]));
      section_depth++;

      if (wc->selectionenabled) {
         /*  integer code for opengl selection */
         MakeInt(wc->selectionnamecount, &(rp->fields[5]));

         if (wc->selectionnamecount >= wc->selectionnamelistsize) {
            SUSPEND_THREADS();
            if (wc->selectionnamecount >= wc->selectionnamelistsize) {
               wc->selectionnamelistsize *=2;
               wc->selectionnamelist=realloc(wc->selectionnamelist,
                        wc->selectionnamelistsize*sizeof(char*));
               if (wc->selectionnamelist == NULL) fail;
               }
            RESUME_THREADS();
            }

         if (!cnv:C_string(argv[warg], tmp))
            runerr(103, argv[warg]);

         wc->selectionnamelist[wc->selectionnamecount] = strdup(tmp);
         wc->selectionnamecount++;
         }
      else
        rp->fields[5]=zerodesc;

      c_put(&(w->window->funclist), &f);
      return f;
  }
end

#else                                   /* Graphics3D */
MissingFuncV(DrawTorus)
MissingFuncV(DrawCube)
MissingFuncV(DrawSphere)
MissingFuncV(DrawCylinder)
MissingFuncV(DrawDisk)
MissingFuncV(Eye)
MissingFuncV(PushMatrix)
MissingFuncV(PushRotate)
MissingFuncV(PushScale)
MissingFuncV(PushTranslate)
MissingFuncV(PopMatrix)
MissingFuncV(IdentityMatrix)
MissingFuncV(MatrixMode)
MissingFuncV(MultMatrix)
MissingFuncV(Normals)
MissingFuncV(Scale)
MissingFuncV(Rotate)
MissingFuncV(Translate)
MissingFuncV(Texture)
MissingFuncV(Texcoord)
MissingFuncV(Refresh)
MissingFuncV(WindowContents)
MissingFuncV(WSection)
#endif                                  /* Graphics3D */
