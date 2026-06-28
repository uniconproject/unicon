/*
 * ucanvas.h - a portable software canvas for Unicon's SDL graphics backend.
 *
 * A canvas is a plain 32-bit pixel buffer (0x00RRGGBB).  All 2D drawing
 * is done here in software, so drawing operations, clipping, patterns,
 * pixel reads and copies behave identically on every platform.  The
 * window system layer (usdlwin.h) only puts finished pixels on screen.
 *
 * This header is read by rtt, so it sticks to plain C: no system headers,
 * no fixed-width integer types, and no library types.
 */
#ifndef UCANVAS_H
#define UCANVAS_H

/*
 * Drawing operations.  The values match the X11 GX* function codes, so
 * the bitwise logic is the familiar one: dst = op(src, dst).
 */
#define UC_OP_CLEAR             0
#define UC_OP_AND               1
#define UC_OP_ANDREVERSE        2
#define UC_OP_COPY              3
#define UC_OP_ANDINVERTED       4
#define UC_OP_NOOP              5
#define UC_OP_XOR               6
#define UC_OP_OR                7
#define UC_OP_NOR               8
#define UC_OP_EQUIV             9
#define UC_OP_INVERT            10
#define UC_OP_ORREVERSE         11
#define UC_OP_COPYINVERTED      12
#define UC_OP_ORINVERTED        13
#define UC_OP_NAND              14
#define UC_OP_SET               15

#define UC_LINE_SOLID           0
#define UC_LINE_DASHED          1       /* on/off: gaps are left untouched */
#define UC_LINE_STRIPED         2       /* double dash: gaps drawn in bg */

#define UC_FILL_SOLID           0
#define UC_FILL_STIPPLED        1       /* pattern 1 bits in fg, 0 bits skip */
#define UC_FILL_OPAQUESTIPPLED  2       /* pattern 1 bits in fg, 0 bits bg */

#define UC_MAXPATTERN           32      /* max pattern height */

#define UC_FONT_BOLD            1
#define UC_FONT_ITALIC          2
#define UC_FONT_MONO            4       /* prefer a monospaced face */
#define UC_FONT_SERIF           8
#define UC_FONT_SANS            16
#define UC_FONT_TYPEWRITER      32

/*
 * The pixel buffer.  Coordinates are logical pixels (Unicon's); each
 * logical pixel is scale x scale device pixels, so a canvas shown on a
 * high-density (Retina) display keeps Unicon's geometry while text is
 * rendered at the display's resolution.  px holds pw x ph device
 * pixels, 0x00RRGGBB, row-major.  dirty and the bounding box (logical
 * pixels) track what changed since the last present.
 */
struct ucanvas {
   int width, height;                   /* logical size */
   int scale;                           /* device pixels per logical */
   int pw, ph;                          /* device size */
   unsigned int *px;
   int dirty;
   int dx0, dy0, dx1, dy1;              /* dirty box, inclusive */
   };

/*
 * Graphics state for one drawing call; a Unicon context owns one of these.
 */
struct ucgc {
   unsigned int fg, bg;                 /* 0x00RRGGBB */
   int op;                              /* UC_OP_* */
   int linewidth;                       /* 0 or 1 means thin */
   int linestyle;                       /* UC_LINE_* */
   int fillstyle;                       /* UC_FILL_* */
   int patw, path;                      /* pattern width and height */
   unsigned int pat[UC_MAXPATTERN];     /* rows; bit x is pixel x */
   int clipon;                          /* clip rectangle in effect? */
   int clipx, clipy, clipw, cliph;
   };

struct ucpoint {
   int x, y;
   };

struct ucfont;

/*
 * Canvas management.  uc_set_scale sets the scale of canvases and
 * fonts created afterwards (1 to 4; 1 unless a display needs more).
 */
void uc_set_scale(int scale);
int  uc_get_scale(void);
struct ucanvas *uc_canvas_new(int width, int height, unsigned int bg);
void uc_canvas_free(struct ucanvas *c);
int  uc_canvas_resize(struct ucanvas *c, int width, int height,
                      unsigned int bg);
void uc_canvas_clean(struct ucanvas *c);
void uc_gc_init(struct ucgc *gc);

/*
 * Drawing.  Every routine clips to the canvas and to the gc clip
 * rectangle, and applies the gc drawing operation and fill style.
 */
void uc_draw_points(struct ucanvas *c, struct ucgc *gc,
                    struct ucpoint *p, int n);
void uc_draw_lines(struct ucanvas *c, struct ucgc *gc,
                   struct ucpoint *p, int n);
void uc_draw_segments(struct ucanvas *c, struct ucgc *gc,
                      struct ucpoint *p, int nsegs);
void uc_draw_rect(struct ucanvas *c, struct ucgc *gc,
                  int x, int y, int w, int h);
void uc_fill_rect(struct ucanvas *c, struct ucgc *gc,
                  int x, int y, int w, int h);
void uc_fill_polygon(struct ucanvas *c, struct ucgc *gc,
                     struct ucpoint *p, int n);
void uc_draw_arc(struct ucanvas *c, struct ucgc *gc, int x, int y,
                 int w, int h, double angle1, double angle2);
void uc_fill_arc(struct ucanvas *c, struct ucgc *gc, int x, int y,
                 int w, int h, double angle1, double angle2);

/*
 * Pixel access and copying.  uc_put_pixel honours clipping and the
 * drawing op but not the fill style; uc_copy_area copies pixels as-is
 * (drawing op copy) and handles overlapping areas of one canvas.
 */
unsigned int uc_get_pixel(struct ucanvas *c, int x, int y);
void uc_put_pixel(struct ucanvas *c, struct ucgc *gc, int x, int y,
                  unsigned int rgb);
void uc_copy_area(struct ucanvas *src, int sx, int sy, int w, int h,
                  struct ucanvas *dst, struct ucgc *gc, int dx, int dy);
void uc_put_rgb(struct ucanvas *c, int x, int y, int w, int h,
                const unsigned int *rgb, int stride, int bottomup);
void uc_put_device_rgb(struct ucanvas *c, int x, int y, int w, int h,
                       const unsigned int *rgb, int stride, int bottomup);

/*
 * Fonts and text.  Strings are bytes; each byte is a Latin-1 character,
 * matching the column arithmetic Unicon does for text windows.
 */
struct ucfont *uc_font_open(char *family, int flags, int size);
void uc_font_close(struct ucfont *f);
int  uc_font_ascent(struct ucfont *f);
int  uc_font_descent(struct ucfont *f);
int  uc_font_maxwidth(struct ucfont *f);
int  uc_text_width(struct ucfont *f, char *s, int n);
void uc_draw_text(struct ucanvas *c, struct ucgc *gc, struct ucfont *f,
                  int x, int y, char *s, int n, int image);
char *uc_font_error(void);

#endif                                  /* UCANVAS_H */
