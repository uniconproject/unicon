/*
 * xftsupp.c - Xft antialiased text support for Unicon's X11 backend.
 *
 * Lives in common (not runtime): runtime .c files are rtt output.
 * Plain C because rtt cannot parse Xft/fontconfig types.
 * Gated by HAVE_LIBXFT (from autoconf).
 */

#include "../h/rt.h"

#if defined(XWindows) && defined(HAVE_LIBXFT)

#include <string.h>
#include <stdio.h>

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

   if (size > 0)
      XftPatternAddDouble(p, XFT_SIZE, (double)size);

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

void xft_font_metrics(wdp wd, wfp rv)
{
   XGlyphInfo extents;
   char buf[256];
   int i;

   /*
    * Xft's font ascent/descent fields are often unreliable; measure a
    * string of all byte values and derive metrics from the glyph info.
    */
   for (i = 0; i < 256; ++i)
      buf[i] = (char)i;
   XftTextExtents8(wd->display, rv->fsp, (FcChar8 *)buf, 256, &extents);
   rv->ascent = extents.y;
   rv->descent = extents.height - extents.y;
   rv->maxwidth = rv->fsp->max_advance_width;
}

void ensure_xftdraw(wbp w)
{
   wsp ws = w->window;
   wdp wd = ws->display;

   if (ws->pix != (Pixmap)NULL && ws->pixDraw == NULL)
      ws->pixDraw = XftDrawCreate(wd->display, ws->pix, ws->vis, wd->cmap);
   if (ws->win != (Window)NULL && ws->winDraw == NULL)
      ws->winDraw = XftDrawCreate(wd->display, ws->win, ws->vis, wd->cmap);
}

int textwidth(wbp w, char *s, int n)
{
   XGlyphInfo extents;
   wdp wd = w->window->display;

   if (n <= 0)
      return 0;
   XftTextExtents8(wd->display, w->context->font->fsp, (FcChar8 *)s, n, &extents);
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

   ensure_xftdraw(w);

   c = &wd->colors[wc->fg];
   rc.red = c->r;
   rc.green = c->g;
   rc.blue = c->b;
   rc.alpha = 0xffff;

   if (!XftColorAllocValue(wd->display, ws->vis, wd->cmap, &rc, &color))
      return;

   if (ws->pixDraw != NULL)
      XftDrawString8(ws->pixDraw, &color, wc->font->fsp, x, y,
                     (FcChar8 *)str, slen);
   if (ws->win != (Window)NULL && ws->winDraw != NULL)
      XftDrawString8(ws->winDraw, &color, wc->font->fsp, x, y,
                     (FcChar8 *)str, slen);

   XftColorFree(wd->display, ws->vis, wd->cmap, &color);
}

#endif /* XWindows && HAVE_LIBXFT */
