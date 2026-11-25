/*
 * xftsupp.c - Xft antialiased text support for Unicon's X11 backend.
 *
 * Lives in common (not runtime): runtime .c files are rtt output.
 * Plain C because rtt cannot parse Xft/fontconfig types.
 * Gated by HAVE_LIBXFT (from autoconf). A font uses Xft when it was
 * opened for a window with aa=on. Other fonts take the classic core
 * X path. UNICON_XFT only supplies the default for new windows.
 */

#include "../h/rt.h"

#if defined(XWindows) && defined(HAVE_LIBXFT)

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int unicon_xft;

/*
 * The classic core "fixed" font has 6x13 cells, and layouts (ivib's, the
 * gui package's) are sized for it.  An unsized "fixed" is opened at the
 * largest pixel size whose cells fit in 6x13, found once per process.
 */
#define FIXED_CELL_W 6
#define FIXED_CELL_H 13
static int xft_fixed_px;

#define XFT_CELL_TAG ":unicon_cell="

static int xft_ready;

static int xft_env_on(char *s)
{
   char buf[8];
   int i;

   for (i = 0; s[i] != '\0' && i < (int)sizeof(buf) - 1; i++) {
      buf[i] = s[i];
      if (buf[i] >= 'A' && buf[i] <= 'Z')
         buf[i] = buf[i] - 'A' + 'a';
      }
   if (s[i] != '\0')
      return 0;
   buf[i] = '\0';
   return !strcmp(buf, "1") || !strcmp(buf, "on") ||
          !strcmp(buf, "yes") || !strcmp(buf, "true");
}

/*
 * Default for a new window's aa attribute. Read once, before the
 * first display loads its default font. Unset, 0, and off keep the
 * classic X fonts. A window can still set aa=on or aa=off itself.
 */
void xft_init(void)
{
   char *s;

   if (xft_ready)
      return;
   xft_ready = 1;
   unicon_xft = 0;
   s = getenv("UNICON_XFT");
   if (s != NULL && xft_env_on(s))
      unicon_xft = 1;
}

char *convert_spec(char *s)
{
   static char res[256];
   int flags, size, tp, sized, n;
   char family[MAXFONTWORD+1];
   XftPattern *p;

   if (!strncmp(s, "fc:", 3))
      return s + 3;

   if (!parsefont(s, family, &flags, &size, &tp))
      return s;

   p = XftPatternCreate();

   if (!strcmp(family, "fixed")) {
      XftPatternAddString(p, XFT_FAMILY, "Unicon fixed");
      XftPatternAddString(p, XFT_FAMILY, "fixed");
      flags |= FONTFLAG_MONO;
   }
   else if (!strcmp(family, "mono")) {
      XftPatternAddString(p, XFT_FAMILY, "Unicon mono");
      XftPatternAddString(p, XFT_FAMILY, "lucidatypewriter");
      flags |= FONTFLAG_MONO;
   }
   else if (!strcmp(family, "typewriter")) {
      XftPatternAddString(p, XFT_FAMILY, "Unicon typewriter");
      XftPatternAddString(p, XFT_FAMILY, "courier");
      flags |= FONTFLAG_MONO;
   }
   else if (!strcmp(family, "sans")) {
      XftPatternAddString(p, XFT_FAMILY, "Unicon sans");
      XftPatternAddString(p, XFT_FAMILY, "Arial");
      XftPatternAddString(p, XFT_FAMILY, "Helvetica");
      XftPatternAddString(p, XFT_FAMILY, "helvetica");
      flags |= FONTFLAG_PROPORTIONAL;
   }
   else if (!strcmp(family, "serif")) {
      XftPatternAddString(p, XFT_FAMILY, "Unicon serif");
      XftPatternAddString(p, XFT_FAMILY, "times");
      flags |= FONTFLAG_PROPORTIONAL;
   }
   else if (!strcmp(family, "arial")) {
      XftPatternAddString(p, XFT_FAMILY, "Arial");
      XftPatternAddString(p, XFT_FAMILY, "arial");
      flags |= FONTFLAG_PROPORTIONAL;
   }
   else
      XftPatternAddString(p, XFT_FAMILY, family);

   /*
    * Unicon font sizes are pixel heights, matching the XLFD pixel
    * field. XFT_SIZE is points and comes out larger on a normal display.
    */
   sized = size > 0 && (flags & FONTFLAG_MONO);
   if (size <= 0)
      size = strcmp(family, "fixed") ? DEFAULTFONTSIZE :
         (xft_fixed_px > 0 ? xft_fixed_px : FIXED_CELL_H);
   XftPatternAddDouble(p, XFT_PIXEL_SIZE, (double)size);

   if (flags & FONTFLAG_MEDIUM)
      XftPatternAddInteger(p, XFT_WEIGHT, XFT_WEIGHT_MEDIUM);
   else if ((flags & FONTFLAG_DEMI) && (flags & FONTFLAG_BOLD))
      XftPatternAddInteger(p, XFT_WEIGHT, XFT_WEIGHT_DEMIBOLD);
   else if (flags & FONTFLAG_BOLD)
      XftPatternAddInteger(p, XFT_WEIGHT, XFT_WEIGHT_BOLD);
   else if (flags & FONTFLAG_DEMI)
      XftPatternAddInteger(p, XFT_WEIGHT, XFT_WEIGHT_DEMIBOLD);
   else if (flags & FONTFLAG_LIGHT)
      XftPatternAddInteger(p, XFT_WEIGHT, XFT_WEIGHT_LIGHT);

   if (flags & FONTFLAG_ITALIC)
      XftPatternAddInteger(p, XFT_SLANT, XFT_SLANT_ITALIC);
   else if (flags & FONTFLAG_OBLIQUE)
      XftPatternAddInteger(p, XFT_SLANT, XFT_SLANT_OBLIQUE);
   else if (flags & FONTFLAG_ROMAN)
      XftPatternAddInteger(p, XFT_SLANT, XFT_SLANT_ROMAN);

   if (flags & FONTFLAG_PROPORTIONAL)
      XftPatternAddInteger(p, XFT_SPACING, XFT_PROPORTIONAL);
   if (flags & FONTFLAG_MONO)
      XftPatternAddInteger(p, XFT_SPACING, XFT_MONO);

   /*
    * Same width names the core X path puts in the XLFD setwidth field.
    * Xft does not publish XFT_WIDTH; these are the fontconfig values.
    */
   if (flags & FONTFLAG_NARROW)
      XftPatternAddInteger(p, FC_WIDTH, FC_WIDTH_CONDENSED);
   else if (flags & FONTFLAG_CONDENSED)
      XftPatternAddInteger(p, FC_WIDTH, FC_WIDTH_CONDENSED);
   else if (flags & FONTFLAG_NORMAL)
      XftPatternAddInteger(p, FC_WIDTH, FC_WIDTH_NORMAL);
   else if (flags & FONTFLAG_WIDE)
      XftPatternAddInteger(p, FC_WIDTH, FC_WIDTH_EXPANDED);
   else if (flags & FONTFLAG_EXTENDED)
      XftPatternAddInteger(p, FC_WIDTH, FC_WIDTH_EXPANDED);

   XftPatternAddBool(p, XFT_ANTIALIAS, FcTrue);

   XftNameUnparse(p, res, sizeof(res) - 1);
   XftPatternDestroy(p);

   /*
    * For a mono font an explicit size is a cell height, as it is for
    * core X fonts, so tag the name with it; xft_trim_cell() reads the
    * tag back.  The tag also keeps "fixed,10" apart from the unsized
    * "fixed", which is opened at the same pixel size but must keep its
    * natural 6x13 cell.  Proportional fonts are left alone: their core
    * cells are already taller than the nominal size.
    */
   if (sized) {
      n = strlen(res);
      snprintf(res + n, sizeof(res) - n, "%s%d", XFT_CELL_TAG, size);
      }
   return res;
}

/*
 * Open the font a pattern name describes.  fontconfig's own settings
 * often leave small text with slight or no hinting, which snaps glyphs
 * only vertically; in a narrow mono cell that blurs the stems together
 * (the m of a 6-pixel "fixed" comes out a grey block).  So a mono font
 * under XFT_FULLHINT pixels is hinted in both directions, by the
 * autohinter so faces without hints of their own get it too.  This is
 * set after matching, where the system configuration cannot undo it.
 * Proportional fonts are left alone: full hinting would change their
 * widths.
 */
#define XFT_FULLHINT 16

XftFont *xft_open(Display *dpy, int scr, char *name)
{
   FcPattern *p, *m;
   FcResult r;
   XftFont *f;
   double px;
   int spacing;
   char buf[256], *t;

   strncpy(buf, name, sizeof(buf) - 1);
   buf[sizeof(buf) - 1] = '\0';
   if ((t = strstr(buf, XFT_CELL_TAG)) != NULL)
      *t = '\0';
   if ((p = XftNameParse(buf)) == NULL)
      return NULL;
   m = XftFontMatch(dpy, scr, p, &r);
   FcPatternDestroy(p);
   if (m == NULL)
      return NULL;
   if (FcPatternGetDouble(m, FC_PIXEL_SIZE, 0, &px) == FcResultMatch &&
       px < XFT_FULLHINT &&
       FcPatternGetInteger(m, FC_SPACING, 0, &spacing) == FcResultMatch &&
       spacing >= FC_MONO) {
      FcPatternDel(m, FC_HINTING);
      FcPatternAddBool(m, FC_HINTING, FcTrue);
      FcPatternDel(m, FC_HINT_STYLE);
      FcPatternAddInteger(m, FC_HINT_STYLE, FC_HINT_FULL);
      FcPatternDel(m, FC_AUTOHINT);
      FcPatternAddBool(m, FC_AUTOHINT, FcTrue);
      }
   if ((f = XftFontOpenPattern(dpy, m)) == NULL)
      FcPatternDestroy(m);
   return f;
}

/*
 * Find the pixel size an unsized "fixed" is opened at (see above).
 */
void xft_fit_fixed(Display *dpy, int scr)
{
   char spec[32], name[256];
   XftFont *f;
   int px, fits;

   if (xft_fixed_px > 0)
      return;
   for (px = FIXED_CELL_H; px > 8; px--) {
      sprintf(spec, "fixed,%d", px);
      strncpy(name, convert_spec(spec), sizeof(name) - 1);
      name[sizeof(name) - 1] = '\0';
      if ((f = xft_open(dpy, scr, name)) == NULL)
         break;
      fits = f->max_advance_width <= FIXED_CELL_W &&
             f->ascent + f->descent <= FIXED_CELL_H;
      XftFontClose(dpy, f);
      if (fits)
         break;
      }
   xft_fixed_px = px;
}

void ensure_xftdraw(wbp w)
{
   wsp ws = w->window;
   wdp wd = ws->display;

   /*
    * XftDraw objects are bound to a specific Drawable.  If the window
    * or pixmap was replaced (e.g. remap()), recreate the draw context.
    */
   if (ws->pixDraw != NULL &&
       (ws->pix == (Pixmap)NULL || XftDrawDrawable(ws->pixDraw) != ws->pix)) {
      XftDrawDestroy(ws->pixDraw);
      ws->pixDraw = NULL;
      }
   if (ws->winDraw != NULL &&
       (ws->win == (Window)NULL || XftDrawDrawable(ws->winDraw) != ws->win)) {
      XftDrawDestroy(ws->winDraw);
      ws->winDraw = NULL;
      }

   if (ws->pix != (Pixmap)NULL && ws->pixDraw == NULL)
      ws->pixDraw = XftDrawCreate(wd->display, ws->pix, ws->vis, wd->cmap);
   if (ws->win != (Window)NULL && ws->winDraw == NULL)
      ws->winDraw = XftDrawCreate(wd->display, ws->win, ws->vis, wd->cmap);
}

/*
 * Clip() updates the graphics context only. XftDraw does not consult
 * that context, so apply the same rectangle here. clipw < 0 means the
 * clip is off.
 */
static void apply_xft_clip(wbp w, XftDraw *d)
{
   wcp wc = w->context;
   XRectangle r;

   if (d == NULL)
      return;
   if (wc->clipw < 0) {
      XftDrawSetClip(d, NULL);
      return;
      }
   r.x = wc->clipx;
   r.y = wc->clipy;
   r.width = wc->clipw;
   r.height = wc->cliph;
   XftDrawSetClipRectangles(d, 0, 0, &r, 1);
}

int textwidth(wbp w, char *s, int n)
{
   XGlyphInfo extents;
   wdp wd = w->window->display;

   if (n <= 0)
      return 0;
   if (w->context->font->xft == NULL)
      return XTextWidth(w->context->font->fsp, s, n);
   XftTextExtents8(wd->display, w->context->font->xft, (FcChar8 *)s, n, &extents);
   return extents.xOff;
}

void drawstrng(wbp w, int x, int y, char *str, int slen)
{
   wsp ws = w->window;
   wcp wc = w->context;
   wdp wd = ws->display;
   XftColor color;
   XRenderColor rc;
   wclrp c;

   if (slen <= 0)
      return;

   /*
    * Xft paints the foreground with PictOpOver. noop draws nothing.
    * Every other drawop, including reverse, stays on the graphics
    * context, which Xft does not honor.
    */
   if (wc->font->xft == NULL || wc->drawop == DRAWOP_NOOP ||
       wc->drawop != DRAWOP_COPY || ISXORREVERSE(w)) {
      if (wc->drawop == DRAWOP_NOOP && wc->font->xft != NULL)
         return;
      if (ws->win)
         XDrawString(wd->display, ws->win, wc->gc, x, y, str, slen);
      XDrawString(wd->display, ws->pix, wc->gc, x, y, str, slen);
      return;
      }

   ensure_xftdraw(w);
   apply_xft_clip(w, ws->pixDraw);
   apply_xft_clip(w, ws->winDraw);

   c = &wd->colors[wc->fg];
   /*
    * Mutable colors are changed with XStoreColor. That updates the
    * pixel and the colormap entry, not these cached components, so
    * reading r/g/b paints the text black or in a stale color.
    */
   if (c->type == CLR_MUTABLE) {
      XColor xc;
      xc.pixel = c->c;
      XQueryColor(wd->display, wd->cmap, &xc);
      rc.red = xc.red;
      rc.green = xc.green;
      rc.blue = xc.blue;
      }
   else {
      rc.red = c->r;
      rc.green = c->g;
      rc.blue = c->b;
      }
   rc.alpha = 0xffff;

   if (!XftColorAllocValue(wd->display, ws->vis, wd->cmap, &rc, &color))
      return;

   if (ws->pixDraw != NULL)
      XftDrawString8(ws->pixDraw, &color, wc->font->xft, x, y,
                     (FcChar8 *)str, slen);
   if (ws->win != (Window)NULL && ws->winDraw != NULL)
      XftDrawString8(ws->winDraw, &color, wc->font->xft, x, y,
                     (FcChar8 *)str, slen);

   XftColorFree(wd->display, ws->vis, wd->cmap, &color);
}

/*
 * Layout height for an Xft font.  A pixel size is an em size, and Xft
 * rounds ascent and descent up, so the cell comes out 15-30% taller than
 * the same size does for a core X font.  When the name carries an
 * explicit size, trim ascent and descent so they sum to it, keeping the
 * font's own proportion.  Glyphs and advances are not touched.
 */
void xft_trim_cell(XftFont *f, char *name, int *asc, int *desc)
{
   char *t;
   int a = f->ascent, d = f->descent, want;

   *asc = a;
   *desc = d;
   if ((t = strstr(name, XFT_CELL_TAG)) == NULL)
      return;
   want = atoi(t + strlen(XFT_CELL_TAG));
   if (want < 1 || a + d <= want)
      return;
   d = (int)((double)d * want / (a + d) + 0.5);
   *asc = want - d;
   *desc = d;
}

#endif /* XWindows && HAVE_LIBXFT */
