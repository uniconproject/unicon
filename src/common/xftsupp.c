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
   int flags, size, tp;
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
   if (size > 0)
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
   return res;
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

#endif /* XWindows && HAVE_LIBXFT */
