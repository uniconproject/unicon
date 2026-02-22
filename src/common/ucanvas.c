/*
 * ucanvas.c - portable software canvas for Unicon's SDL graphics backend.
 *
 * Everything the 2D graphics facilities draw is rasterized here into a
 * 0x00RRGGBB pixel buffer: points, lines, rectangles, polygons, arcs and
 * text.  Drawing honours the Unicon (X11-derived) graphics state: drawing
 * operation, line width and style, fill style with patterns, and a clip
 * rectangle.  Text uses FreeType; faces are found with fontconfig where
 * available and in the platform font directories otherwise.
 *
 * Plain C, compiled outside rtt, with no dependency on SDL: the canvas is
 * usable (and testable) without a window system.
 *
 * Geometry conventions follow X11 so that existing programs render the
 * same way: thin lines include both end points, filled shapes include the
 * pixels whose centres lie inside the shape (centres are at integer
 * coordinates; left and top edges are inside, right and bottom are not),
 * an outlined w x h rectangle or arc covers (w+1) x (h+1) pixels and a
 * filled one covers w x h pixels.
 */

#include "../h/define.h"
#include "../h/config.h"

#ifdef SDLGraphics

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <ctype.h>
#include <sys/stat.h>

#include <ft2build.h>
#include FT_FREETYPE_H
#include FT_SYNTHESIS_H

#ifdef HAVE_LIBFONTCONFIG
#include <fontconfig/fontconfig.h>
#endif                                  /* HAVE_LIBFONTCONFIG */

#include "../h/ucanvas.h"

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

#define RGBMASK 0x00FFFFFFu

/*
 * ------------------------------------------------------------------
 * Canvas management
 * ------------------------------------------------------------------
 */

struct ucanvas *uc_canvas_new(int width, int height, unsigned int bg)
{
   struct ucanvas *c;
   long i, n;

   if (width < 1) width = 1;
   if (height < 1) height = 1;
   c = calloc(1, sizeof(struct ucanvas));
   if (c == NULL)
      return NULL;
   n = (long)width * height;
   c->px = malloc(n * sizeof(unsigned int));
   if (c->px == NULL) {
      free(c);
      return NULL;
      }
   for (i = 0; i < n; i++)
      c->px[i] = bg & RGBMASK;
   c->width = width;
   c->height = height;
   c->dirty = 1;
   c->dx0 = c->dy0 = 0;
   c->dx1 = width - 1;
   c->dy1 = height - 1;
   return c;
}

void uc_canvas_free(struct ucanvas *c)
{
   if (c) {
      free(c->px);
      free(c);
      }
}

/*
 * Change the canvas size, keeping the old pixels at the top left and
 * filling any new area with bg.  Returns 0 if out of memory.
 */
int uc_canvas_resize(struct ucanvas *c, int width, int height,
                     unsigned int bg)
{
   unsigned int *np;
   int x, y;

   if (width < 1) width = 1;
   if (height < 1) height = 1;
   if (width == c->width && height == c->height)
      return 1;
   np = malloc((long)width * height * sizeof(unsigned int));
   if (np == NULL)
      return 0;
   for (y = 0; y < height; y++) {
      unsigned int *row = np + (long)y * width;
      for (x = 0; x < width; x++)
         row[x] = (x < c->width && y < c->height) ?
            c->px[(long)y * c->width + x] : (bg & RGBMASK);
      }
   free(c->px);
   c->px = np;
   c->width = width;
   c->height = height;
   c->dirty = 1;
   c->dx0 = c->dy0 = 0;
   c->dx1 = width - 1;
   c->dy1 = height - 1;
   return 1;
}

void uc_canvas_clean(struct ucanvas *c)
{
   c->dirty = 0;
}

void uc_gc_init(struct ucgc *gc)
{
   memset(gc, 0, sizeof(*gc));
   gc->fg = 0x000000;
   gc->bg = 0xFFFFFF;
   gc->op = UC_OP_COPY;
   gc->linewidth = 1;
   gc->linestyle = UC_LINE_SOLID;
   gc->fillstyle = UC_FILL_SOLID;
}

static void mark(struct ucanvas *c, int x0, int y0, int x1, int y1)
{
   if (!c->dirty) {
      c->dirty = 1;
      c->dx0 = x0; c->dy0 = y0; c->dx1 = x1; c->dy1 = y1;
      return;
      }
   if (x0 < c->dx0) c->dx0 = x0;
   if (y0 < c->dy0) c->dy0 = y0;
   if (x1 > c->dx1) c->dx1 = x1;
   if (y1 > c->dy1) c->dy1 = y1;
}

/*
 * ------------------------------------------------------------------
 * Pixel operations
 * ------------------------------------------------------------------
 */

static unsigned int rop(int op, unsigned int s, unsigned int d)
{
   unsigned int r;
   switch (op) {
      case UC_OP_CLEAR:        r = 0;             break;
      case UC_OP_AND:          r = s & d;         break;
      case UC_OP_ANDREVERSE:   r = s & ~d;        break;
      case UC_OP_COPY:         r = s;             break;
      case UC_OP_ANDINVERTED:  r = ~s & d;        break;
      case UC_OP_NOOP:         r = d;             break;
      case UC_OP_XOR:          r = s ^ d;         break;
      case UC_OP_OR:           r = s | d;         break;
      case UC_OP_NOR:          r = ~(s | d);      break;
      case UC_OP_EQUIV:        r = ~(s ^ d);      break;
      case UC_OP_INVERT:       r = ~d;            break;
      case UC_OP_ORREVERSE:    r = s | ~d;        break;
      case UC_OP_COPYINVERTED: r = ~s;            break;
      case UC_OP_ORINVERTED:   r = ~s | d;        break;
      case UC_OP_NAND:         r = ~(s & d);      break;
      case UC_OP_SET:          r = ~0u;           break;
      default:                 r = s;             break;
      }
   return r & RGBMASK;
}

/*
 * The effective clip region: canvas bounds intersected with the gc clip.
 * Half-open: x0 <= x < x1.  Returns 0 if nothing can be drawn.
 */
struct clip { int x0, y0, x1, y1; };

static int getclip(struct ucanvas *c, struct ucgc *gc, struct clip *cl)
{
   cl->x0 = 0; cl->y0 = 0; cl->x1 = c->width; cl->y1 = c->height;
   if (gc && gc->clipon) {
      if (gc->clipx > cl->x0) cl->x0 = gc->clipx;
      if (gc->clipy > cl->y0) cl->y0 = gc->clipy;
      if (gc->clipx + gc->clipw < cl->x1) cl->x1 = gc->clipx + gc->clipw;
      if (gc->clipy + gc->cliph < cl->y1) cl->y1 = gc->clipy + gc->cliph;
      }
   return cl->x0 < cl->x1 && cl->y0 < cl->y1;
}

static int patbit(struct ucgc *gc, int x, int y)
{
   int px, py;
   if (gc->patw <= 0 || gc->path <= 0)
      return 1;
   px = x % gc->patw; if (px < 0) px += gc->patw;
   py = y % gc->path; if (py < 0) py += gc->path;
   return (gc->pat[py] >> px) & 1;
}

/*
 * Paint pixels x0..x1 (inclusive) of row y.  which is 1 for the
 * foreground ("on" pixels) and 2 for the background (gaps of a striped
 * line).  Applies clipping, fill style and the drawing operation.
 */
static void hspan(struct ucanvas *c, struct ucgc *gc, struct clip *cl,
                  int y, int x0, int x1, int which)
{
   unsigned int *row, color;
   int x, op = gc->op;

   if (y < cl->y0 || y >= cl->y1) return;
   if (x0 < cl->x0) x0 = cl->x0;
   if (x1 >= cl->x1) x1 = cl->x1 - 1;
   if (x0 > x1) return;
   mark(c, x0, y, x1, y);
   row = c->px + (long)y * c->width;
   color = (which == 1) ? gc->fg : gc->bg;

   if (gc->fillstyle == UC_FILL_SOLID || gc->patw <= 0) {
      if (op == UC_OP_COPY) {
         for (x = x0; x <= x1; x++) row[x] = color & RGBMASK;
         }
      else {
         for (x = x0; x <= x1; x++) row[x] = rop(op, color, row[x]);
         }
      }
   else if (gc->fillstyle == UC_FILL_STIPPLED) {
      for (x = x0; x <= x1; x++)
         if (patbit(gc, x, y))
            row[x] = rop(op, color, row[x]);
      }
   else {                                       /* opaque stipple */
      for (x = x0; x <= x1; x++)
         row[x] = rop(op, patbit(gc, x, y) ? gc->fg : gc->bg, row[x]);
      }
}

/*
 * ------------------------------------------------------------------
 * Coverage masks
 *
 * Wide lines (built from several overlapping pieces) are first
 * rasterized into a mask and then painted once, so that every pixel is
 * touched once no matter how many pieces cover it.  That keeps xor and
 * the other non-idempotent drawing operations correct at line joins.
 * A mask value is 0 (untouched), 1 (foreground) or 2 (background).
 * ------------------------------------------------------------------
 */

struct mask {
   int x0, y0, w, h;                    /* covers [x0,x0+w) x [y0,y0+h) */
   unsigned char *m;
   };

static int mask_init(struct mask *mk, struct clip *cl,
                     double bx0, double by0, double bx1, double by1)
{
   int x0 = (int)floor(bx0) - 1, y0 = (int)floor(by0) - 1;
   int x1 = (int)ceil(bx1) + 2, y1 = (int)ceil(by1) + 2;
   if (x0 < cl->x0) x0 = cl->x0;
   if (y0 < cl->y0) y0 = cl->y0;
   if (x1 > cl->x1) x1 = cl->x1;
   if (y1 > cl->y1) y1 = cl->y1;
   mk->m = NULL;
   if (x0 >= x1 || y0 >= y1) return 0;
   mk->x0 = x0; mk->y0 = y0; mk->w = x1 - x0; mk->h = y1 - y0;
   mk->m = calloc((long)mk->w * mk->h, 1);
   return mk->m != NULL;
}

static void mask_span(struct mask *mk, int y, int xa, int xb, int v)
{
   int x;
   unsigned char *row;
   y -= mk->y0;
   if (y < 0 || y >= mk->h) return;
   xa -= mk->x0; xb -= mk->x0;
   if (xa < 0) xa = 0;
   if (xb >= mk->w) xb = mk->w - 1;
   row = mk->m + (long)y * mk->w;
   for (x = xa; x <= xb; x++)
      if (v == 1 || row[x] == 0)
         row[x] = v;
}

static void mask_apply(struct ucanvas *c, struct ucgc *gc, struct clip *cl,
                       struct mask *mk)
{
   int y, x, start;
   for (y = 0; y < mk->h; y++) {
      unsigned char *row = mk->m + (long)y * mk->w;
      x = 0;
      while (x < mk->w) {
         int v = row[x];
         if (v == 0) { x++; continue; }
         start = x;
         while (x < mk->w && row[x] == v) x++;
         hspan(c, gc, cl, y + mk->y0, start + mk->x0, x - 1 + mk->x0, v);
         }
      }
   free(mk->m);
   mk->m = NULL;
}

/*
 * ------------------------------------------------------------------
 * Polygon scan conversion (even-odd rule, pixel centres at integers)
 * ------------------------------------------------------------------
 */

struct dpt { double x, y; };

typedef void (*spanfn)(void *arg, int y, int xa, int xb);

static int dcmp(const void *a, const void *b)
{
   double d = *(const double *)a - *(const double *)b;
   return (d < 0) ? -1 : (d > 0);
}

static void scan_polygon(struct dpt *p, int n, int ylo, int yhi,
                         spanfn fn, void *arg)
{
   double ymin, ymax, *xs, xstack[64];
   int i, y, y0, y1, nx;

   if (n < 3) return;
   ymin = ymax = p[0].y;
   for (i = 1; i < n; i++) {
      if (p[i].y < ymin) ymin = p[i].y;
      if (p[i].y > ymax) ymax = p[i].y;
      }
   y0 = (int)ceil(ymin);
   y1 = (int)ceil(ymax) - 1;
   if (y0 < ylo) y0 = ylo;
   if (y1 > yhi) y1 = yhi;
   if (y0 > y1) return;

   xs = (n <= 64) ? xstack : malloc(n * sizeof(double));
   if (xs == NULL) return;

   for (y = y0; y <= y1; y++) {
      nx = 0;
      for (i = 0; i < n; i++) {
         struct dpt *a = &p[i], *b = &p[(i + 1) % n];
         if ((a->y <= y && y < b->y) || (b->y <= y && y < a->y))
            xs[nx++] = a->x + (y - a->y) * (b->x - a->x) / (b->y - a->y);
         }
      if (nx < 2) continue;
      qsort(xs, nx, sizeof(double), dcmp);
      for (i = 0; i + 1 < nx; i += 2) {
         int xa = (int)ceil(xs[i]);
         int xb = (int)ceil(xs[i + 1]) - 1;
         if (xa <= xb)
            fn(arg, y, xa, xb);
         }
      }
   if (xs != xstack) free(xs);
}

struct direct_arg {
   struct ucanvas *c;
   struct ucgc *gc;
   struct clip *cl;
   };

static void direct_span(void *arg, int y, int xa, int xb)
{
   struct direct_arg *d = arg;
   hspan(d->c, d->gc, d->cl, y, xa, xb, 1);
}

struct mask_arg {
   struct mask *mk;
   int v;
   };

static void mask_span_fn(void *arg, int y, int xa, int xb)
{
   struct mask_arg *m = arg;
   mask_span(m->mk, y, xa, xb, m->v);
}

static void fill_dpoly(struct ucanvas *c, struct ucgc *gc, struct dpt *p,
                       int n)
{
   struct clip cl;
   struct direct_arg d;
   if (!getclip(c, gc, &cl)) return;
   d.c = c; d.gc = gc; d.cl = &cl;
   scan_polygon(p, n, cl.y0, cl.y1 - 1, direct_span, &d);
}

static void mask_dpoly(struct mask *mk, struct dpt *p, int n, int v)
{
   struct mask_arg m;
   m.mk = mk; m.v = v;
   scan_polygon(p, n, mk->y0, mk->y0 + mk->h - 1, mask_span_fn, &m);
}

/*
 * ------------------------------------------------------------------
 * Lines
 * ------------------------------------------------------------------
 */

struct dash {
   int style;                           /* UC_LINE_* */
   double len;                          /* length of each dash and gap */
   double pos;                          /* distance into current period */
   };

static void dash_init(struct dash *ds, struct ucgc *gc)
{
   ds->style = gc->linestyle;
   ds->len = (gc->linewidth > 1) ? 3.0 * gc->linewidth : 4.0;
   ds->pos = 0.0;
}

/* value to paint for the current dash position: 1 on, 2 bg gap, 0 skip */
static int dash_val(struct dash *ds)
{
   if (ds->style == UC_LINE_SOLID) return 1;
   if (fmod(ds->pos, 2 * ds->len) < ds->len) return 1;
   return (ds->style == UC_LINE_STRIPED) ? 2 : 0;
}

/*
 * Thin (Bresenham) line from (x0,y0) to (x1,y1), painted directly.
 * Bresenham visits each pixel once, so no mask is needed.  If skipfirst
 * (or skiplast), the first (or last) pixel is not drawn: it belongs to
 * the neighbouring segment of a polyline.
 */
static void thin_line(struct ucanvas *c, struct ucgc *gc, struct clip *cl,
                      struct dash *ds, int x0, int y0, int x1, int y1,
                      int skipfirst, int skiplast)
{
   int dx = abs(x1 - x0), sx = (x0 < x1) ? 1 : -1;
   int dy = -abs(y1 - y0), sy = (y0 < y1) ? 1 : -1;
   int err = dx + dy, e2, first = 1;

   for (;;) {
      int last = (x0 == x1 && y0 == y1);
      if (!(first && skipfirst) && !(last && skiplast && !first)) {
         int v = dash_val(ds);
         if (v) hspan(c, gc, cl, y0, x0, x0, v);
         ds->pos += 1.0;
         }
      first = 0;
      if (last) break;
      e2 = 2 * err;
      if (e2 >= dy) { err += dy; x0 += sx; }
      if (e2 <= dx) { err += dx; y0 += sy; }
      }
}

/*
 * A wide line segment as a filled quadrilateral.  ext0 and ext1 extend
 * the segment beyond its end points (half the width for projecting
 * caps, zero for butt ends).
 */
static void wide_seg(struct mask *mk, double x0, double y0, double x1,
                     double y1, double hw, double ext0, double ext1, int v)
{
   struct dpt q[4];
   double dx = x1 - x0, dy = y1 - y0, len = sqrt(dx * dx + dy * dy);
   double ux, uy, nx, ny;

   if (len < 1e-9) {                    /* degenerate: a square dot */
      double e = (ext0 > ext1) ? ext0 : ext1;
      if (e < hw) e = hw;
      q[0].x = x0 - e; q[0].y = y0 - hw;
      q[1].x = x0 + e; q[1].y = y0 - hw;
      q[2].x = x0 + e; q[2].y = y0 + hw;
      q[3].x = x0 - e; q[3].y = y0 + hw;
      mask_dpoly(mk, q, 4, v);
      return;
      }
   ux = dx / len; uy = dy / len;
   nx = -uy * hw; ny = ux * hw;
   x0 -= ux * ext0; y0 -= uy * ext0;
   x1 += ux * ext1; y1 += uy * ext1;
   q[0].x = x0 + nx; q[0].y = y0 + ny;
   q[1].x = x1 + nx; q[1].y = y1 + ny;
   q[2].x = x1 - nx; q[2].y = y1 - ny;
   q[3].x = x0 - nx; q[3].y = y0 - ny;
   mask_dpoly(mk, q, 4, v);
}

/*
 * Fill the outside of the join at point b between segments a->b and b->c
 * with a miter, or a bevel if the miter would be too long.
 */
static void wide_join(struct mask *mk, struct dpt a, struct dpt b,
                      struct dpt c, double hw)
{
   double d1x = b.x - a.x, d1y = b.y - a.y, d2x = c.x - b.x, d2y = c.y - b.y;
   double l1 = sqrt(d1x * d1x + d1y * d1y), l2 = sqrt(d2x * d2x + d2y * d2y);
   double n1x, n1y, n2x, n2y, cross, mx, my, ml, cosang;
   struct dpt q[4];

   if (l1 < 1e-9 || l2 < 1e-9) return;
   d1x /= l1; d1y /= l1; d2x /= l2; d2y /= l2;
   cross = d1x * d2y - d1y * d2x;
   if (fabs(cross) < 1e-9) return;      /* straight on (or reversal) */
   /* normals pointing to the outside of the turn */
   if (cross > 0) {
      n1x = d1y; n1y = -d1x; n2x = d2y; n2y = -d2x;
      }
   else {
      n1x = -d1y; n1y = d1x; n2x = -d2y; n2y = d2x;
      }
   q[0] = b;
   q[1].x = b.x + n1x * hw; q[1].y = b.y + n1y * hw;
   q[3].x = b.x + n2x * hw; q[3].y = b.y + n2y * hw;
   mx = n1x + n2x; my = n1y + n2y;
   ml = sqrt(mx * mx + my * my);
   cosang = d1x * d2x + d1y * d2y;
   /* X11 miter limit: about 11 degrees; past that, bevel. */
   if (ml > 1e-9 && cosang > -0.98) {
      double half = sqrt((1.0 + cosang) / 2.0);   /* cos of half angle */
      double len = hw / (half > 1e-6 ? half : 1e-6);
      q[2].x = b.x + mx / ml * len; q[2].y = b.y + my / ml * len;
      mask_dpoly(mk, q, 4, 1);
      }
   else {
      q[2] = q[3];
      mask_dpoly(mk, q, 3, 1);
      }
}

/*
 * Draw a polyline of n points (doubles) with the gc's width and style.
 * closed means the first and last points are joined (e.g. polygons).
 */
static void polyline(struct ucanvas *c, struct ucgc *gc, struct dpt *p,
                     int n, int closed)
{
   struct clip cl;
   struct mask mk;
   struct dash ds;
   double bx0, by0, bx1, by1, hw, margin;
   int i;

   if (n < 1 || !getclip(c, gc, &cl)) return;
   dash_init(&ds, gc);

   if (gc->linewidth <= 1) {
      int px = (int)floor(p[0].x + 0.5), py = (int)floor(p[0].y + 0.5);
      if (n == 1)
         thin_line(c, gc, &cl, &ds, px, py, px, py, 0, 0);
      for (i = 1; i < n; i++) {
         int qx = (int)floor(p[i].x + 0.5), qy = (int)floor(p[i].y + 0.5);
         /* a closed figure's last point is its first: draw it once */
         thin_line(c, gc, &cl, &ds, px, py, qx, qy, i > 1,
                   closed && i == n - 1);
         px = qx; py = qy;
         }
      return;
      }

   hw = gc->linewidth / 2.0;
   margin = hw * 12 + 2;                /* room for caps and miters */
   bx0 = bx1 = p[0].x; by0 = by1 = p[0].y;
   for (i = 1; i < n; i++) {
      if (p[i].x < bx0) bx0 = p[i].x;
      if (p[i].x > bx1) bx1 = p[i].x;
      if (p[i].y < by0) by0 = p[i].y;
      if (p[i].y > by1) by1 = p[i].y;
      }
   if (!mask_init(&mk, &cl, bx0 - margin, by0 - margin,
                  bx1 + margin, by1 + margin))
      return;

   if (gc->linestyle != UC_LINE_SOLID) {
      /*
       * Dashed wide lines: each dash is its own segment with
       * projecting caps.
       */
      for (i = 1; i < n || (n == 1 && i == 1); i++) {
         struct dpt a = p[i - 1], b = p[(n == 1) ? 0 : i];
         double dx = b.x - a.x, dy = b.y - a.y;
         double len = sqrt(dx * dx + dy * dy), t = 0.0;
         if (len < 1e-9) {
            wide_seg(&mk, a.x, a.y, a.x, a.y, hw, hw, hw, dash_val(&ds));
            continue;
            }
         while (t < len) {
            double period = fmod(ds.pos, 2 * ds.len);
            double left = (period < ds.len) ? ds.len - period
                                            : 2 * ds.len - period;
            double t2 = t + left;
            int v = dash_val(&ds);
            if (t2 > len) t2 = len;
            if (v)
               wide_seg(&mk, a.x + dx * t / len, a.y + dy * t / len,
                        a.x + dx * t2 / len, a.y + dy * t2 / len,
                        hw, hw, hw, v);
            ds.pos += t2 - t;
            t = t2;
            }
         }
      }
   else if (n == 1) {
      wide_seg(&mk, p[0].x, p[0].y, p[0].x, p[0].y, hw, hw, hw, 1);
      }
   else {
      for (i = 1; i < n; i++) {
         double e0 = (i == 1 && !closed) ? hw : 0.0;
         double e1 = (i == n - 1 && !closed) ? hw : 0.0;
         wide_seg(&mk, p[i-1].x, p[i-1].y, p[i].x, p[i].y, hw, e0, e1, 1);
         if (i < n - 1)
            wide_join(&mk, p[i-1], p[i], p[i+1], hw);
         }
      if (closed && n > 2) {
         /* the first and last points coincide; join across them */
         wide_join(&mk, p[n-2], p[0], p[1], hw);
         }
      }
   mask_apply(c, gc, &cl, &mk);
}

void uc_draw_points(struct ucanvas *c, struct ucgc *gc,
                    struct ucpoint *p, int n)
{
   struct clip cl;
   int i;
   if (!getclip(c, gc, &cl)) return;
   for (i = 0; i < n; i++)
      hspan(c, gc, &cl, p[i].y, p[i].x, p[i].x, 1);
}

void uc_draw_lines(struct ucanvas *c, struct ucgc *gc,
                   struct ucpoint *p, int n)
{
   struct dpt dstack[64], *d;
   int i, closed;
   if (n < 1) return;
   d = (n <= 64) ? dstack : malloc(n * sizeof(struct dpt));
   if (d == NULL) return;
   for (i = 0; i < n; i++) {
      d[i].x = p[i].x;
      d[i].y = p[i].y;
      }
   closed = (n > 2 && p[0].x == p[n-1].x && p[0].y == p[n-1].y);
   polyline(c, gc, d, n, closed);
   if (d != dstack) free(d);
}

void uc_draw_segments(struct ucanvas *c, struct ucgc *gc,
                      struct ucpoint *p, int nsegs)
{
   int i;
   for (i = 0; i < nsegs; i++)
      uc_draw_lines(c, gc, p + 2 * i, 2);
}

/*
 * ------------------------------------------------------------------
 * Rectangles and polygons
 * ------------------------------------------------------------------
 */

void uc_fill_rect(struct ucanvas *c, struct ucgc *gc,
                  int x, int y, int w, int h)
{
   struct clip cl;
   int j;
   if (w <= 0 || h <= 0 || !getclip(c, gc, &cl)) return;
   if (y < cl.y0) { h -= cl.y0 - y; y = cl.y0; }
   if (y + h > cl.y1) h = cl.y1 - y;
   for (j = 0; j < h; j++)
      hspan(c, gc, &cl, y + j, x, x + w - 1, 1);
}

void uc_draw_rect(struct ucanvas *c, struct ucgc *gc,
                  int x, int y, int w, int h)
{
   struct ucpoint p[5];
   if (w < 0 || h < 0) return;
   if (gc->linewidth <= 1 && gc->linestyle == UC_LINE_SOLID) {
      /* outline covers (w+1) x (h+1) pixels; each pixel painted once */
      uc_fill_rect(c, gc, x, y, w + 1, 1);
      if (h > 0) {
         uc_fill_rect(c, gc, x, y + h, w + 1, 1);
         if (h > 1) {
            uc_fill_rect(c, gc, x, y + 1, 1, h - 1);
            if (w > 0)
               uc_fill_rect(c, gc, x + w, y + 1, 1, h - 1);
            }
         }
      return;
      }
   p[0].x = x;     p[0].y = y;
   p[1].x = x + w; p[1].y = y;
   p[2].x = x + w; p[2].y = y + h;
   p[3].x = x;     p[3].y = y + h;
   p[4] = p[0];
   uc_draw_lines(c, gc, p, 5);
}

void uc_fill_polygon(struct ucanvas *c, struct ucgc *gc,
                     struct ucpoint *p, int n)
{
   struct dpt dstack[64], *d;
   int i;
   if (n < 3) return;
   d = (n <= 64) ? dstack : malloc(n * sizeof(struct dpt));
   if (d == NULL) return;
   for (i = 0; i < n; i++) {
      d[i].x = p[i].x;
      d[i].y = p[i].y;
      }
   fill_dpoly(c, gc, d, n);
   if (d != dstack) free(d);
}

/*
 * ------------------------------------------------------------------
 * Arcs.  The arc lies in the box [x, x+w] x [y, y+h].  Angles are in
 * radians; 0 is three o'clock and positive angles run clockwise on the
 * screen (Unicon's convention).  angle2 is the extent.
 * ------------------------------------------------------------------
 */

static int arc_points(int x, int y, int w, int h, double a1, double a2,
                      struct dpt **pts, int extra)
{
   double cx = x + w / 2.0, cy = y + h / 2.0, rx = w / 2.0, ry = h / 2.0;
   double perim = M_PI * (rx + ry) * fabs(a2) / (2 * M_PI);
   int n = (int)(perim / 1.5) + 8, i;
   struct dpt *p;

   if (n > 20000) n = 20000;
   p = malloc((n + 1 + extra) * sizeof(struct dpt));
   if (p == NULL) return 0;
   for (i = 0; i <= n; i++) {
      double t = a1 + a2 * i / n;
      p[i].x = cx + rx * cos(t);
      p[i].y = cy + ry * sin(t);
      }
   *pts = p;
   return n + 1;
}

void uc_draw_arc(struct ucanvas *c, struct ucgc *gc, int x, int y,
                 int w, int h, double angle1, double angle2)
{
   struct dpt *p;
   int n, full;
   if (w < 0 || h < 0) return;
   full = fabs(angle2) >= 2 * M_PI - 1e-9;
   if (full) { angle1 = 0.0; angle2 = 2 * M_PI; }
   n = arc_points(x, y, w, h, angle1, angle2, &p, 0);
   if (n == 0) return;
   if (full) {                          /* make the end meet the start */
      p[n-1] = p[0];
      }
   polyline(c, gc, p, n, full);
   free(p);
}

void uc_fill_arc(struct ucanvas *c, struct ucgc *gc, int x, int y,
                 int w, int h, double angle1, double angle2)
{
   struct dpt *p;
   int n;
   if (w <= 0 || h <= 0) return;
   if (fabs(angle2) >= 2 * M_PI - 1e-9) {
      n = arc_points(x, y, w, h, 0.0, 2 * M_PI, &p, 0);
      if (n == 0) return;
      fill_dpoly(c, gc, p, n - 1);
      }
   else {
      n = arc_points(x, y, w, h, angle1, angle2, &p, 1);
      if (n == 0) return;
      p[n].x = x + w / 2.0;             /* pie slice: close at the centre */
      p[n].y = y + h / 2.0;
      fill_dpoly(c, gc, p, n + 1);
      }
   free(p);
}

/*
 * ------------------------------------------------------------------
 * Pixel access and copies
 * ------------------------------------------------------------------
 */

unsigned int uc_get_pixel(struct ucanvas *c, int x, int y)
{
   if (x < 0 || y < 0 || x >= c->width || y >= c->height)
      return 0;
   return c->px[(long)y * c->width + x];
}

void uc_put_pixel(struct ucanvas *c, struct ucgc *gc, int x, int y,
                  unsigned int rgb)
{
   struct clip cl;
   unsigned int *p;
   if (!getclip(c, gc, &cl)) return;
   if (x < cl.x0 || y < cl.y0 || x >= cl.x1 || y >= cl.y1) return;
   p = c->px + (long)y * c->width + x;
   *p = gc ? rop(gc->op, rgb, *p) : (rgb & RGBMASK);
   mark(c, x, y, x, y);
}

/*
 * Copy a w x h block from src at (sx,sy) to dst at (dx,dy).  The source
 * must already be clipped to src's bounds by the caller; the destination
 * is clipped here (canvas and gc clip).  Pixels are copied verbatim.
 */
void uc_copy_area(struct ucanvas *src, int sx, int sy, int w, int h,
                  struct ucanvas *dst, struct ucgc *gc, int dx, int dy)
{
   struct clip cl;
   unsigned int *tmp;
   int j, x0, x1, y0, y1;

   if (w <= 0 || h <= 0 || !getclip(dst, gc, &cl)) return;
   x0 = dx; y0 = dy; x1 = dx + w; y1 = dy + h;
   if (x0 < cl.x0) x0 = cl.x0;
   if (y0 < cl.y0) y0 = cl.y0;
   if (x1 > cl.x1) x1 = cl.x1;
   if (y1 > cl.y1) y1 = cl.y1;
   /* also stay inside the source */
   if (x0 < dx - sx) x0 = dx - sx;
   if (y0 < dy - sy) y0 = dy - sy;
   if (x1 > dx - sx + src->width) x1 = dx - sx + src->width;
   if (y1 > dy - sy + src->height) y1 = dy - sy + src->height;
   if (x0 >= x1 || y0 >= y1) return;

   /* go through a temporary buffer so overlapping copies work */
   tmp = malloc((long)(x1 - x0) * (y1 - y0) * sizeof(unsigned int));
   if (tmp == NULL) return;
   for (j = y0; j < y1; j++)
      memcpy(tmp + (long)(j - y0) * (x1 - x0),
             src->px + (long)(j - dy + sy) * src->width + (x0 - dx + sx),
             (x1 - x0) * sizeof(unsigned int));
   for (j = y0; j < y1; j++)
      memcpy(dst->px + (long)j * dst->width + x0,
             tmp + (long)(j - y0) * (x1 - x0),
             (x1 - x0) * sizeof(unsigned int));
   free(tmp);
   mark(dst, x0, y0, x1 - 1, y1 - 1);
}

/*
 * ------------------------------------------------------------------
 * Fonts
 * ------------------------------------------------------------------
 */

struct ucglyph {
   int loaded;
   int w, h, left, top, advance;
   unsigned char *bits;                 /* 8-bit coverage, w x h */
   };

struct ucfont {
   struct ucfont *next;
   int refcount;
   char *path;
   int index, size, synth;              /* synth: 1 bold, 2 italic */
   FT_Face face;
   int ascent, descent, maxwidth;
   struct ucglyph glyphs[256];
   };

static FT_Library ftlib;
static int ftlib_ready;
static struct ucfont *fonts;
static char font_err[1100];

char *uc_font_error(void)
{
   return font_err;
}

static int ft_init(void)
{
   if (!ftlib_ready) {
      if (FT_Init_FreeType(&ftlib) != 0) {
         snprintf(font_err, sizeof(font_err), "cannot initialize FreeType");
         return 0;
         }
      ftlib_ready = 1;
      }
   return 1;
}

static int file_exists(char *path)
{
   struct stat st;
   return stat(path, &st) == 0 && S_ISREG(st.st_mode);
}

static int strieq(const char *a, const char *b)
{
   while (*a && *b) {
      if (tolower((unsigned char)*a) != tolower((unsigned char)*b))
         return 0;
      a++; b++;
      }
   return *a == *b;
}

static int strihas(const char *s, const char *sub)
{
   size_t n = strlen(sub);
   for (; *s; s++) {
      size_t i;
      for (i = 0; i < n && s[i]; i++)
         if (tolower((unsigned char)s[i]) != tolower((unsigned char)sub[i]))
            break;
      if (i == n) return 1;
      }
   return 0;
}

/*
 * How well does face (of a file) match the requested style?  Higher is
 * better; -1 means the file cannot be read.
 */
static int face_score(char *path, int index, int flags, long *nfaces)
{
   FT_Face face;
   int score = 0, bold, italic;
   const char *st;

   if (FT_New_Face(ftlib, path, index, &face) != 0)
      return -1;
   if (nfaces) *nfaces = face->num_faces;
   if (!FT_IS_SCALABLE(face) && face->num_fixed_sizes == 0) {
      FT_Done_Face(face);
      return -1;
      }
   bold = (face->style_flags & FT_STYLE_FLAG_BOLD) != 0;
   italic = (face->style_flags & FT_STYLE_FLAG_ITALIC) != 0;
   st = face->style_name ? face->style_name : "";
   if (!bold && (strihas(st, "bold") || strihas(st, "black") ||
                 strihas(st, "heavy")))
      bold = 1;
   if (!italic && (strihas(st, "italic") || strihas(st, "oblique")))
      italic = 1;
   if (bold == ((flags & UC_FONT_BOLD) != 0)) score += 10;
   if (italic == ((flags & UC_FONT_ITALIC) != 0)) score += 10;
   /* prefer plain widths and weights over exotic variants */
   if (strihas(st, "light") || strihas(st, "thin") ||
       strihas(st, "condensed") || strihas(st, "narrow") ||
       strihas(st, "medium") || strihas(st, "semi") || strihas(st, "demi") ||
       strihas(st, "ultra") || strihas(st, "extra") || strihas(st, "black"))
      score -= 4;
   if (FT_IS_SCALABLE(face)) score += 1;
   FT_Done_Face(face);
   return score;
}

/*
 * Choose the best face in a font file (collections hold several).
 * Returns the score, and sets *index; -1 if unusable.
 */
static int best_face(char *path, int flags, int *index)
{
   long nfaces = 1, i;
   int best = -1, s;
   *index = 0;
   for (i = 0; i < nfaces && i < 64; i++) {
      s = face_score(path, (int)i, flags, &nfaces);
      if (s > best) { best = s; *index = (int)i; }
      }
   return best;
}

/*
 * Directories searched when fontconfig is not available or finds nothing.
 */
static char *font_dirs[] = {
#ifdef __APPLE__
   "/System/Library/Fonts",
   "/System/Library/Fonts/Supplemental",
   "/Library/Fonts",
   "~/Library/Fonts",
#endif                                  /* __APPLE__ */
   "/usr/share/fonts/truetype/dejavu",
   "/usr/share/fonts/dejavu",
   "/usr/share/fonts/TTF",
   "/usr/share/fonts/truetype/liberation",
   "/usr/share/fonts/liberation",
   "/usr/share/fonts/truetype/freefont",
   "/usr/local/share/fonts",
   "~/.fonts",
   "~/.local/share/fonts",
   "/usr/share/fonts",
   NULL
   };

/*
 * File name stems tried for Unicon's portable families.  Each stem is
 * tried with the common extensions and with " Bold", "-Bold", etc.
 */
static char *mono_files[] = {
   "Menlo", "SFNSMono", "Monaco", "DejaVuSansMono", "LiberationMono",
   "FreeMono", "Courier New", "Andale Mono", NULL };
static char *typewriter_files[] = {
   "Courier", "Courier New", "LiberationMono", "FreeMono",
   "DejaVuSansMono", "Menlo", NULL };
static char *sans_files[] = {
   "Helvetica", "HelveticaNeue", "Arial", "Geneva", "DejaVuSans",
   "LiberationSans", "FreeSans", NULL };
static char *serif_files[] = {
   "Times", "Times New Roman", "NewYork", "Georgia", "DejaVuSerif",
   "LiberationSerif", "FreeSerif", NULL };

static void expand_home(char *dir, char *buf, int len)
{
   if (dir[0] == '~') {
      char *home = getenv("HOME");
      snprintf(buf, len, "%s%s", home ? home : "", dir + 1);
      }
   else
      snprintf(buf, len, "%s", dir);
}

/*
 * Look for a file named after stem in the font directories and return
 * the best-matching face in *path / *index.  Returns the score or -1.
 */
static int find_file(char *stem, int flags, char *path, int len, int *index)
{
   static char *exts[] = { ".ttc", ".ttf", ".otf", ".dfont", NULL };
   static char *styles[] = { "", " Regular", "-Regular", " Bold", "-Bold",
                             " Italic", "-Italic", "-Oblique",
                             " Bold Italic", "-BoldItalic",
                             "-BoldOblique", NULL };
   char dir[512], cand[1024];
   int d, e, s, best = -1, idx, sc;

   for (d = 0; font_dirs[d]; d++) {
      expand_home(font_dirs[d], dir, sizeof(dir));
      for (s = 0; styles[s]; s++) {
         /* only look at styled files that could help this request */
         if (strihas(styles[s], "bold") && !(flags & UC_FONT_BOLD))
            continue;
         if ((strihas(styles[s], "italic") || strihas(styles[s], "oblique"))
             && !(flags & UC_FONT_ITALIC))
            continue;
         for (e = 0; exts[e]; e++) {
            snprintf(cand, sizeof(cand), "%s/%s%s%s", dir, stem,
                     styles[s], exts[e]);
            if (!file_exists(cand)) continue;
            sc = best_face(cand, flags, &idx);
            if (sc > best) {
               best = sc;
               snprintf(path, len, "%s", cand);
               *index = idx;
               }
            }
         }
      if (best >= 20) break;            /* exact style match: done */
      }
   return best;
}

#ifdef HAVE_LIBFONTCONFIG
/*
 * Ask fontconfig.  If exact is set, the family of the match must be the
 * one requested (fontconfig always returns something).
 */
static int find_fontconfig(char *family, int flags, int size, int exact,
                           char *path, int len, int *index)
{
   static int fc_ready;
   FcPattern *pat, *match;
   FcResult res;
   FcChar8 *file = NULL, *fam = NULL;
   int idx = 0, ok = 0;

   if (!fc_ready) {
      if (!FcInit()) return -1;
      fc_ready = 1;
      }
   pat = FcPatternCreate();
   if (pat == NULL) return -1;
   FcPatternAddString(pat, FC_FAMILY, (FcChar8 *)family);
   FcPatternAddInteger(pat, FC_WEIGHT, (flags & UC_FONT_BOLD) ?
                       FC_WEIGHT_BOLD : FC_WEIGHT_REGULAR);
   FcPatternAddInteger(pat, FC_SLANT, (flags & UC_FONT_ITALIC) ?
                       FC_SLANT_ITALIC : FC_SLANT_ROMAN);
   if (flags & UC_FONT_MONO)
      FcPatternAddInteger(pat, FC_SPACING, FC_MONO);
   FcPatternAddDouble(pat, FC_PIXEL_SIZE, (double)size);
   FcPatternAddBool(pat, FC_SCALABLE, FcTrue);
   FcConfigSubstitute(NULL, pat, FcMatchPattern);
   FcDefaultSubstitute(pat);
   match = FcFontMatch(NULL, pat, &res);
   if (match) {
      if (FcPatternGetString(match, FC_FILE, 0, &file) == FcResultMatch &&
          FcPatternGetString(match, FC_FAMILY, 0, &fam) == FcResultMatch) {
         FcPatternGetInteger(match, FC_INDEX, 0, &idx);
         if (!exact || strieq((char *)fam, family)) {
            snprintf(path, len, "%s", (char *)file);
            *index = idx;
            ok = 1;
            }
         }
      FcPatternDestroy(match);
      }
   FcPatternDestroy(pat);
   return ok ? face_score(path, *index, flags, NULL) : -1;
}
#endif                                  /* HAVE_LIBFONTCONFIG */

/*
 * Resolve a family name to a font file and face index.
 */
static int resolve_font(char *family, int flags, int size, char *path,
                        int len, int *index)
{
   char **stems = NULL;
   char *fcname = NULL;
   int i, best = -1, sc, idx;
   char cand[1024];
   size_t flen = strlen(family);

   /* an explicit font file */
   if (strchr(family, '/') || (flen > 4 &&
       (strieq(family + flen - 4, ".ttf") || strieq(family + flen - 4, ".otf")
        || strieq(family + flen - 4, ".ttc")))) {
      if (!file_exists(family)) return -1;
      snprintf(path, len, "%s", family);
      return best_face(path, flags, index);
      }

   if (strieq(family, "mono") || strieq(family, "fixed")) {
      stems = mono_files; fcname = "monospace";
      }
   else if (strieq(family, "typewriter")) {
      stems = typewriter_files; fcname = "Courier";
      }
   else if (strieq(family, "sans")) {
      stems = sans_files; fcname = "sans-serif";
      }
   else if (strieq(family, "serif")) {
      stems = serif_files; fcname = "serif";
      }

#ifdef HAVE_LIBFONTCONFIG
   if (stems) {
      /* typewriter: prefer a real Courier-like face if there is one */
      if (stems == typewriter_files) {
         static char *tw[] = { "Courier", "Courier New", "Liberation Mono",
                               "Nimbus Mono PS", "FreeMono", NULL };
         for (i = 0; tw[i]; i++) {
            sc = find_fontconfig(tw[i], flags | UC_FONT_MONO, size, 1,
                                 path, len, index);
            if (sc >= 0) return sc;
            }
         fcname = "monospace";
         }
      sc = find_fontconfig(fcname, flags |
                           ((stems == mono_files) ? UC_FONT_MONO : 0),
                           size, 0, path, len, index);
      if (sc >= 0) return sc;
      }
   else {
      sc = find_fontconfig(family, flags, size, 1, path, len, index);
      if (sc >= 0) return sc;
      }
#endif                                  /* HAVE_LIBFONTCONFIG */

   if (stems) {
      for (i = 0; stems[i]; i++) {
         sc = find_file(stems[i], flags, cand, sizeof(cand), &idx);
         if (sc > best) {
            best = sc;
            snprintf(path, len, "%s", cand);
            *index = idx;
            if (best >= 20) break;
            }
         }
      return best;
      }
   return find_file(family, flags, path, len, index);
}

static int ceil26(long v)
{
   return (int)((v + 63) >> 6);
}

struct ucfont *uc_font_open(char *family, int flags, int size)
{
   char path[1024];
   int index = 0, score, synth = 0;
   struct ucfont *f;
   FT_Face face;

   font_err[0] = '\0';
   if (!ft_init()) return NULL;
   if (size <= 0) size = 14;
   score = resolve_font(family, flags, size, path, sizeof(path), &index);
   if (score < 0) {
      snprintf(font_err, sizeof(font_err), "no font found for \"%s\"",
               family);
      return NULL;
      }

   /* synthesize styles the chosen face lacks */
   if (FT_New_Face(ftlib, path, index, &face) != 0) {
      snprintf(font_err, sizeof(font_err), "cannot open font %s", path);
      return NULL;
      }
   if ((flags & UC_FONT_BOLD) && !(face->style_flags & FT_STYLE_FLAG_BOLD)
       && !strihas(face->style_name ? face->style_name : "", "bold"))
      synth |= 1;
   if ((flags & UC_FONT_ITALIC) &&
       !(face->style_flags & FT_STYLE_FLAG_ITALIC) &&
       !strihas(face->style_name ? face->style_name : "", "italic") &&
       !strihas(face->style_name ? face->style_name : "", "oblique"))
      synth |= 2;

   for (f = fonts; f; f = f->next)
      if (f->size == size && f->index == index && f->synth == synth &&
          !strcmp(f->path, path)) {
         FT_Done_Face(face);
         f->refcount++;
         return f;
         }

   f = calloc(1, sizeof(struct ucfont));
   if (f == NULL) { FT_Done_Face(face); return NULL; }
   f->path = strdup(path);
   f->index = index;
   f->size = size;
   f->synth = synth;
   f->face = face;
   f->refcount = 1;

   if (FT_IS_SCALABLE(face))
      FT_Set_Pixel_Sizes(face, 0, size);
   else {
      int best = 0, j;                  /* bitmap font: nearest strike */
      for (j = 1; j < face->num_fixed_sizes; j++)
         if (abs(face->available_sizes[j].height - size) <
             abs(face->available_sizes[best].height - size))
            best = j;
      FT_Select_Size(face, best);
      }
   if (synth & 2) {
      FT_Matrix shear;
      shear.xx = 0x10000L; shear.xy = (FT_Fixed)(0.2 * 0x10000L);
      shear.yx = 0;        shear.yy = 0x10000L;
      FT_Set_Transform(face, &shear, NULL);
      }

   f->ascent = ceil26(face->size->metrics.ascender);
   f->descent = ceil26(-face->size->metrics.descender);
   if (f->ascent + f->descent < size) {
      /* some fonts report tiny metrics; keep lines at least size tall */
      f->descent = size - f->ascent;
      if (f->descent < 0) f->descent = 0;
      }
   f->maxwidth = 1;                     /* computed on first use */
   f->next = fonts;
   fonts = f;
   return f;
}

void uc_font_close(struct ucfont *f)
{
   struct ucfont **pp;
   int i;
   if (f == NULL || --f->refcount > 0) return;
   for (pp = &fonts; *pp; pp = &(*pp)->next)
      if (*pp == f) { *pp = f->next; break; }
   for (i = 0; i < 256; i++)
      free(f->glyphs[i].bits);
   FT_Done_Face(f->face);
   free(f->path);
   free(f);
}

static struct ucglyph *glyph(struct ucfont *f, unsigned char ch)
{
   struct ucglyph *g = &f->glyphs[ch];
   FT_GlyphSlot slot;
   FT_UInt gi;
   int r;

   if (g->loaded) return g;
   g->loaded = 1;
   gi = FT_Get_Char_Index(f->face, ch);
   if (ch < 32 || (ch >= 127 && ch < 160)) gi = 0;
   if (FT_Load_Glyph(f->face, gi, FT_LOAD_DEFAULT | FT_LOAD_TARGET_LIGHT)
       != 0)
      return g;
   slot = f->face->glyph;
   if (f->synth & 1)
      FT_GlyphSlot_Embolden(slot);
   if (FT_Render_Glyph(slot, FT_RENDER_MODE_LIGHT) != 0)
      return g;
   g->advance = (int)((slot->advance.x + 32) >> 6);
   if (ch < 32 || (ch >= 127 && ch < 160)) {
      g->advance = 0;                   /* control characters: invisible */
      return g;
      }
   g->left = slot->bitmap_left;
   g->top = slot->bitmap_top;
   g->w = slot->bitmap.width;
   g->h = slot->bitmap.rows;
   if (g->w > 0 && g->h > 0) {
      g->bits = malloc((long)g->w * g->h);
      if (g->bits == NULL) { g->w = g->h = 0; return g; }
      for (r = 0; r < g->h; r++) {
         unsigned char *src = slot->bitmap.buffer + r * slot->bitmap.pitch;
         unsigned char *dst = g->bits + (long)r * g->w;
         if (slot->bitmap.pixel_mode == FT_PIXEL_MODE_MONO) {
            int x;
            for (x = 0; x < g->w; x++)
               dst[x] = (src[x >> 3] & (0x80 >> (x & 7))) ? 255 : 0;
            }
         else
            memcpy(dst, src, g->w);
         }
      }
   return g;
}

int uc_font_ascent(struct ucfont *f)   { return f->ascent; }
int uc_font_descent(struct ucfont *f)  { return f->descent; }

int uc_font_maxwidth(struct ucfont *f)
{
   int i;
   if (f->maxwidth <= 1) {
      for (i = 32; i < 127; i++) {
         struct ucglyph *g = glyph(f, (unsigned char)i);
         if (g->advance > f->maxwidth) f->maxwidth = g->advance;
         }
      }
   return f->maxwidth;
}

int uc_text_width(struct ucfont *f, char *s, int n)
{
   int w = 0, i;
   for (i = 0; i < n; i++)
      w += glyph(f, (unsigned char)s[i])->advance;
   return w;
}

/*
 * Draw n characters with the baseline at y, starting at x.  If image is
 * set, first fill the character cells with the background (as X11's
 * XDrawImageString does); image text always uses the copy operation.
 */
void uc_draw_text(struct ucanvas *c, struct ucgc *gc, struct ucfont *f,
                  int x, int y, char *s, int n, int image)
{
   struct clip cl;
   int i, gx, gy, op;
   int blend;

   if (n <= 0 || !getclip(c, gc, &cl)) return;
   op = gc->op;
   if (image) {
      struct ucgc bg = *gc;
      bg.op = UC_OP_COPY;
      bg.fillstyle = UC_FILL_SOLID;
      bg.fg = gc->bg;
      uc_fill_rect(c, &bg, x, y - f->ascent, uc_text_width(f, s, n),
                   f->ascent + f->descent);
      op = UC_OP_COPY;
      }
   blend = (op == UC_OP_COPY) &&
           (image || gc->fillstyle == UC_FILL_SOLID || gc->patw <= 0);

   for (i = 0; i < n; i++) {
      struct ucglyph *g = glyph(f, (unsigned char)s[i]);
      int ox = x + g->left, oy = y - g->top;
      for (gy = 0; gy < g->h; gy++) {
         int py = oy + gy;
         unsigned int *row;
         if (py < cl.y0 || py >= cl.y1) continue;
         row = c->px + (long)py * c->width;
         for (gx = 0; gx < g->w; gx++) {
            int px = ox + gx;
            unsigned int a = g->bits[(long)gy * g->w + gx];
            if (a == 0 || px < cl.x0 || px >= cl.x1) continue;
            if (blend) {
               unsigned int d = row[px], fg = gc->fg, r, gg, b;
               r = ((d >> 16) & 255) * (255 - a) + ((fg >> 16) & 255) * a;
               gg = ((d >> 8) & 255) * (255 - a) + ((fg >> 8) & 255) * a;
               b = (d & 255) * (255 - a) + (fg & 255) * a;
               row[px] = (((r + 127) / 255) << 16) |
                         (((gg + 127) / 255) << 8) | ((b + 127) / 255);
               }
            else if (a >= 128) {
               if (gc->fillstyle == UC_FILL_STIPPLED && !patbit(gc, px, py))
                  continue;
               if (gc->fillstyle == UC_FILL_OPAQUESTIPPLED &&
                   !patbit(gc, px, py))
                  row[px] = rop(op, gc->bg, row[px]);
               else
                  row[px] = rop(op, gc->fg, row[px]);
               }
            }
         }
      if (g->h > 0)
         mark(c, ox < 0 ? 0 : ox, oy < 0 ? 0 : oy,
              ox + g->w - 1, oy + g->h - 1);
      x += g->advance;
      }
   /* keep the dirty box inside the canvas */
   if (c->dx1 >= c->width) c->dx1 = c->width - 1;
   if (c->dy1 >= c->height) c->dy1 = c->height - 1;
}

#else                                   /* SDLGraphics */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-variable"
  static char x;
#pragma GCC diagnostic pop
#endif                                  /* SDLGraphics */
