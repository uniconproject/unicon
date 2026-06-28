/*
 * usdlwin.c - SDL3 window-system layer for Unicon's SDL graphics backend.
 *
 * Responsibilities: create and manage native windows, put a canvas's
 * pixels on screen, and translate SDL input events into the event model
 * the Unicon runtime expects (X11-style key symbols and characters,
 * mouse buttons 1-3, wheel, resize and close requests).
 *
 * All drawing happens in the canvas (ucanvas.c); a window only shows it.
 * Plain C, compiled outside rtt.
 */

#include "../h/define.h"
#include "../h/config.h"

#ifdef SDLGraphics

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <SDL3/SDL.h>

#include "../h/ucanvas.h"
#include "../h/usdlwin.h"

#define OWNER_PROP "unicon.usdlwin"

struct usdlwin {
   SDL_Window *win;
   SDL_Renderer *ren;
   SDL_Texture *tex;
   int tw, th;                          /* texture size */
   void *owner;
   int cursor;
   float wheel;                         /* fractional wheel motion */
   int redraw;                          /* window needs repainting */
   Uint64 last_present;
   };

static int sdl_ready;
static char errbuf[512];

/*
 * On macOS, AppKit may only be used from the main thread, and SDL's
 * Cocoa layer crashes otherwise.  There, calls from other threads that
 * would touch the window system are refused (open) or deferred
 * (events and presents happen when the main thread next polls).
 * Elsewhere SDL is called from whichever thread asks, as Xlib is.
 */
static int offmain(void)
{
#ifdef __APPLE__
   return sdl_ready && !SDL_IsMainThread();
#else
   return 0;
#endif
}

/*
 * Translated events waiting to be returned (one SDL event can produce
 * several, e.g. a multi-character text input event).
 */
#define PENDMAX 64
static struct usdl_event pending[PENDMAX];
static int pend_head, pend_count;

static void push_event(struct usdl_event *ev)
{
   if (pend_count < PENDMAX) {
      pending[(pend_head + pend_count) % PENDMAX] = *ev;
      pend_count++;
      }
}

static int pop_event(struct usdl_event *ev)
{
   if (pend_count == 0) return 0;
   *ev = pending[pend_head];
   pend_head = (pend_head + 1) % PENDMAX;
   pend_count--;
   return 1;
}

char *usdl_error(void)
{
   return errbuf;
}

/*
 * Device pixels per Unicon pixel: the primary display's pixel density
 * (2 on a Retina display), or UNICON_SCALE if it is set.  Canvases are
 * kept at this resolution so text is as sharp as the display allows.
 */
#if defined(Graphics3D) && HAVE_LIBGL
/*
 * SDL's renderer may use OpenGL as well, making its own context current;
 * keep a 3D window's context current across renderer calls.
 */
static SDL_Window *glwin;               /* hidden; 3D contexts need a window */
#define GLSAVE SDL_GLContext glsaved = SDL_GL_GetCurrentContext()
#define GLRESTORE do { \
   if (glsaved && SDL_GL_GetCurrentContext() != glsaved) \
      SDL_GL_MakeCurrent(glwin, glsaved); \
   } while (0)
#else                                   /* Graphics3D && HAVE_LIBGL */
#define GLSAVE
#define GLRESTORE
#endif                                  /* Graphics3D && HAVE_LIBGL */

static int display_scale(void)
{
   const SDL_DisplayMode *m;
   char *e = getenv("UNICON_SCALE");
   int scale = 1;
   if (e != NULL && *e)
      scale = atoi(e);
   else if ((m = SDL_GetDesktopDisplayMode(SDL_GetPrimaryDisplay())) != NULL)
      scale = (int)(m->pixel_density + 0.5f);
   if (scale < 1) scale = 1;
   if (scale > 4) scale = 4;
   return scale;
}

int usdl_init(void)
{
   if (sdl_ready) return 1;
   /*
    * Unicon decides when windows go away and handles its own signals;
    * the first click on an inactive window is delivered, as under X11.
    */
   SDL_SetHint(SDL_HINT_QUIT_ON_LAST_WINDOW_CLOSE, "0");
   SDL_SetHint(SDL_HINT_NO_SIGNAL_HANDLERS, "1");
   SDL_SetHint(SDL_HINT_MOUSE_FOCUS_CLICKTHROUGH, "1");
   SDL_SetAppMetadata("Unicon", NULL, "org.unicon.iconx");
   if (!SDL_Init(SDL_INIT_VIDEO)) {
      snprintf(errbuf, sizeof(errbuf), "SDL_Init: %s", SDL_GetError());
      return 0;
      }
   sdl_ready = 1;
   uc_set_scale(display_scale());
   return 1;
}

void usdl_display_size(int *w, int *h)
{
   SDL_Rect r;
   *w = 1024; *h = 768;
   if (!usdl_init()) return;
   if (SDL_GetDisplayBounds(SDL_GetPrimaryDisplay(), &r)) {
      *w = r.w;
      *h = r.h;
      }
}

static struct usdlwin *lookup(SDL_WindowID id)
{
   SDL_Window *w = SDL_GetWindowFromID(id);
   if (w == NULL) return NULL;
   return SDL_GetPointerProperty(SDL_GetWindowProperties(w), OWNER_PROP,
                                 NULL);
}

struct usdlwin *usdl_open(char *title, int x, int y, int w, int h,
                          int flags, void *owner)
{
   struct usdlwin *uw;
   SDL_WindowFlags wf = 0;

   if (!usdl_init()) return NULL;
   if (offmain()) {
      snprintf(errbuf, sizeof(errbuf),
               "windows can only be opened by the main thread");
      return NULL;
      }
   uw = calloc(1, sizeof(struct usdlwin));
   if (uw == NULL) return NULL;
   if (flags & USDL_RESIZABLE)  wf |= SDL_WINDOW_RESIZABLE;
   if (flags & USDL_BORDERLESS) wf |= SDL_WINDOW_BORDERLESS;
   if (flags & USDL_MINIMIZED)  wf |= SDL_WINDOW_MINIMIZED;
   if (flags & USDL_MAXIMIZED)  wf |= SDL_WINDOW_MAXIMIZED;
   if (uc_get_scale() > 1)      wf |= SDL_WINDOW_HIGH_PIXEL_DENSITY;
   wf |= SDL_WINDOW_HIDDEN;             /* shown once positioned */
   if (w < 1) w = 1;
   if (h < 1) h = 1;

   uw->win = SDL_CreateWindow(title ? title : "", w, h, wf);
   if (uw->win == NULL) {
      snprintf(errbuf, sizeof(errbuf), "SDL_CreateWindow: %s",
               SDL_GetError());
      free(uw);
      return NULL;
      }
   {
   GLSAVE;
   uw->ren = SDL_CreateRenderer(uw->win, NULL);
   if (uw->ren == NULL)
      uw->ren = SDL_CreateRenderer(uw->win, SDL_SOFTWARE_RENDERER);
   GLRESTORE;
   }
   if (uw->ren == NULL) {
      snprintf(errbuf, sizeof(errbuf), "SDL_CreateRenderer: %s",
               SDL_GetError());
      SDL_DestroyWindow(uw->win);
      free(uw);
      return NULL;
      }
   SDL_SetPointerProperty(SDL_GetWindowProperties(uw->win), OWNER_PROP, uw);
   uw->owner = owner;
   uw->redraw = 1;
   if (x != USDL_POS_UNDEFINED || y != USDL_POS_UNDEFINED)
      SDL_SetWindowPosition(uw->win,
         x == USDL_POS_UNDEFINED ? (int)SDL_WINDOWPOS_UNDEFINED : x,
         y == USDL_POS_UNDEFINED ? (int)SDL_WINDOWPOS_UNDEFINED : y);
   if (!(flags & USDL_HIDDEN)) {
      SDL_ShowWindow(uw->win);
      /*
       * A program started from a terminal is not the active
       * application on macOS; bring its new window to the front, as
       * a window manager does for a new X11 window.
       */
      if (!(flags & USDL_MINIMIZED))
         SDL_RaiseWindow(uw->win);
      }
   SDL_StartTextInput(uw->win);
   return uw;
}

void usdl_close(struct usdlwin *uw)
{
   int i;
   if (uw == NULL) return;
   /* drop pending events for this window */
   for (i = 0; i < pend_count; i++) {
      struct usdl_event *e = &pending[(pend_head + i) % PENDMAX];
      if (e->owner == uw->owner) e->type = USDL_EV_NONE;
      }
   {
   GLSAVE;
   if (uw->tex) SDL_DestroyTexture(uw->tex);
   if (uw->ren) SDL_DestroyRenderer(uw->ren);
   GLRESTORE;
   }
   SDL_ClearProperty(SDL_GetWindowProperties(uw->win), OWNER_PROP);
   SDL_DestroyWindow(uw->win);
   free(uw);
}

void usdl_set_title(struct usdlwin *uw, char *title)
{
   /* window labels are Latin-1 strings; SDL wants UTF-8 */
   char buf[1024];
   unsigned char *s = (unsigned char *)title;
   int i = 0;
   for (; *s && i < (int)sizeof(buf) - 3; s++) {
      if (*s < 0x80) buf[i++] = *s;
      else {
         buf[i++] = 0xC0 | (*s >> 6);
         buf[i++] = 0x80 | (*s & 0x3F);
         }
      }
   buf[i] = '\0';
   SDL_SetWindowTitle(uw->win, buf);
}

/*
 * Use the pixels of a canvas as the window's icon (on macOS, the
 * application's Dock icon).
 */
void usdl_set_icon(struct usdlwin *uw, struct ucanvas *c)
{
   SDL_Surface *s;
   if (uw == NULL || c == NULL || offmain()) return;
   s = SDL_CreateSurfaceFrom(c->pw, c->ph, SDL_PIXELFORMAT_XRGB8888,
                             c->px, c->pw * 4);
   if (s == NULL) return;
   SDL_SetWindowIcon(uw->win, s);
   SDL_DestroySurface(s);
}

void usdl_set_position(struct usdlwin *uw, int x, int y)
{
   SDL_SetWindowPosition(uw->win, x, y);
}

void usdl_get_position(struct usdlwin *uw, int *x, int *y)
{
   SDL_GetWindowPosition(uw->win, x, y);
}

void usdl_set_size(struct usdlwin *uw, int w, int h)
{
   SDL_SetWindowSize(uw->win, w < 1 ? 1 : w, h < 1 ? 1 : h);
   uw->redraw = 1;
}

void usdl_get_size(struct usdlwin *uw, int *w, int *h)
{
   SDL_GetWindowSize(uw->win, w, h);
}

void usdl_set_resizable(struct usdlwin *uw, int on)
{
   SDL_SetWindowResizable(uw->win, on ? true : false);
}

void usdl_set_min_size(struct usdlwin *uw, int w, int h)
{
   SDL_SetWindowMinimumSize(uw->win, w, h);
}

void usdl_show(struct usdlwin *uw)     { SDL_ShowWindow(uw->win); uw->redraw = 1; }
void usdl_hide(struct usdlwin *uw)     { SDL_HideWindow(uw->win); }
void usdl_raise(struct usdlwin *uw)    { SDL_RaiseWindow(uw->win); }
void usdl_minimize(struct usdlwin *uw) { SDL_MinimizeWindow(uw->win); }
void usdl_maximize(struct usdlwin *uw) { SDL_MaximizeWindow(uw->win); }
void usdl_restore(struct usdlwin *uw)  { SDL_RestoreWindow(uw->win); }
void usdl_sync(struct usdlwin *uw)     { if (uw) SDL_SyncWindow(uw->win); }

int usdl_state(struct usdlwin *uw)
{
   SDL_WindowFlags f = SDL_GetWindowFlags(uw->win);
   if (f & SDL_WINDOW_HIDDEN)    return USDL_STATE_HIDDEN;
   if (f & SDL_WINDOW_MINIMIZED) return USDL_STATE_ICONIC;
   if (f & SDL_WINDOW_MAXIMIZED) return USDL_STATE_MAXIMIZED;
   return USDL_STATE_NORMAL;
}

/*
 * Put the canvas on screen.  Only the changed part of the canvas is
 * uploaded.  Unless force is set, presents are limited to one every
 * 30ms per window; the canvas stays dirty and a later call shows it.
 * (WFlush() and waiting for an event force a present.)
 *
 * The canvas holds scale x scale device pixels per Unicon pixel; on a
 * high-density display they map one to one onto the window's pixels.
 */
static void present(struct usdlwin *uw, struct ucanvas *c, Uint64 now);

void usdl_present(struct usdlwin *uw, struct ucanvas *c, int force)
{
   Uint64 now;

   if (uw == NULL || c == NULL || offmain()) return;
   if (!c->dirty && !uw->redraw) return;
   now = SDL_GetTicks();
   if (!force && now - uw->last_present < 30) return;
   present(uw, c, now);
}

static void present(struct usdlwin *uw, struct ucanvas *c, Uint64 now)
{
   int ww, wh, ow, oh, vw, vh, s = c->scale;
   SDL_FRect src, dst;
   GLSAVE;

   if (uw->tex == NULL || uw->tw != c->pw || uw->th != c->ph) {
      if (uw->tex) SDL_DestroyTexture(uw->tex);
      uw->tex = SDL_CreateTexture(uw->ren, SDL_PIXELFORMAT_XRGB8888,
                                  SDL_TEXTUREACCESS_STREAMING, c->pw, c->ph);
      if (uw->tex == NULL) {
         GLRESTORE;
         return;
         }
      SDL_SetTextureScaleMode(uw->tex, (s > 1) ? SDL_SCALEMODE_LINEAR :
                                                 SDL_SCALEMODE_NEAREST);
      uw->tw = c->pw;
      uw->th = c->ph;
      SDL_UpdateTexture(uw->tex, NULL, c->px, c->pw * 4);
      }
   else if (c->dirty) {
      SDL_Rect d;
      int x0 = c->dx0 < 0 ? 0 : c->dx0, y0 = c->dy0 < 0 ? 0 : c->dy0;
      int x1 = c->dx1 >= c->width ? c->width - 1 : c->dx1;
      int y1 = c->dy1 >= c->height ? c->height - 1 : c->dy1;
      if (x0 <= x1 && y0 <= y1) {
         d.x = x0 * s; d.y = y0 * s;
         d.w = (x1 - x0 + 1) * s; d.h = (y1 - y0 + 1) * s;
         SDL_UpdateTexture(uw->tex, &d,
                           c->px + (long)d.y * c->pw + d.x, c->pw * 4);
         }
      }
   c->dirty = 0;

   /* the visible part of the canvas, in Unicon pixels */
   SDL_GetWindowSize(uw->win, &ww, &wh);
   if (!SDL_GetCurrentRenderOutputSize(uw->ren, &ow, &oh)) {
      ow = ww; oh = wh;
      }
   vw = ww < c->width ? ww : c->width;
   vh = wh < c->height ? wh : c->height;
   src.x = 0; src.y = 0;
   src.w = (float)(vw * s); src.h = (float)(vh * s);
   dst.x = 0; dst.y = 0;
   dst.w = (float)vw * ow / (ww > 0 ? ww : 1);
   dst.h = (float)vh * oh / (wh > 0 ? wh : 1);
   SDL_SetRenderDrawColor(uw->ren, 0, 0, 0, 255);
   SDL_RenderClear(uw->ren);
   SDL_RenderTexture(uw->ren, uw->tex, &src, &dst);
   SDL_RenderPresent(uw->ren);
   GLRESTORE;
   uw->redraw = 0;
   uw->last_present = now;
}

/*
 * Cursors.  SDL has one cursor for the application, so the cursor of the
 * window under the pointer is installed when the pointer enters it.
 */
static SDL_Cursor *cursors[12];

static void install_cursor(int shape)
{
   static SDL_SystemCursor map[12] = {
      SDL_SYSTEM_CURSOR_DEFAULT, SDL_SYSTEM_CURSOR_TEXT,
      SDL_SYSTEM_CURSOR_WAIT, SDL_SYSTEM_CURSOR_CROSSHAIR,
      SDL_SYSTEM_CURSOR_PROGRESS, SDL_SYSTEM_CURSOR_NWSE_RESIZE,
      SDL_SYSTEM_CURSOR_NESW_RESIZE, SDL_SYSTEM_CURSOR_EW_RESIZE,
      SDL_SYSTEM_CURSOR_NS_RESIZE, SDL_SYSTEM_CURSOR_MOVE,
      SDL_SYSTEM_CURSOR_NOT_ALLOWED, SDL_SYSTEM_CURSOR_POINTER };
   if (shape < 0 || shape >= 12) shape = 0;
   if (cursors[shape] == NULL)
      cursors[shape] = SDL_CreateSystemCursor(map[shape]);
   if (cursors[shape])
      SDL_SetCursor(cursors[shape]);
}

void usdl_set_cursor(struct usdlwin *uw, int shape)
{
   uw->cursor = shape;
   if (SDL_GetMouseFocus() == uw->win)
      install_cursor(shape);
}

void usdl_warp_pointer(struct usdlwin *uw, int x, int y)
{
   SDL_WarpMouseInWindow(uw->win, (float)x, (float)y);
}

/* pointer position relative to the window; 0 if it is unknown */
int usdl_pointer(struct usdlwin *uw, int *x, int *y)
{
   float gx, gy;
   int wx, wy;
   SDL_GetGlobalMouseState(&gx, &gy);
   SDL_GetWindowPosition(uw->win, &wx, &wy);
   *x = (int)gx - wx;
   *y = (int)gy - wy;
   return 1;
}

void usdl_global_pointer(int *x, int *y)
{
   float gx = 0, gy = 0;
   if (usdl_init())
      SDL_GetGlobalMouseState(&gx, &gy);
   *x = (int)gx;
   *y = (int)gy;
}

/*
 * Clipboard text, converted between Unicon's Latin-1 and SDL's UTF-8.
 * usdl_get_clipboard returns a malloc'd string or NULL.
 */
char *usdl_get_clipboard(void)
{
   char *u, *r;
   unsigned char *s;
   int i = 0;
   if (!usdl_init() || !SDL_HasClipboardText()) return NULL;
   u = SDL_GetClipboardText();
   if (u == NULL) return NULL;
   r = malloc(strlen(u) + 1);
   if (r != NULL) {
      for (s = (unsigned char *)u; *s; ) {
         if (*s < 0x80) r[i++] = *s++;
         else if ((*s & 0xE0) == 0xC0 && s[1]) {
            int cp = ((s[0] & 0x1F) << 6) | (s[1] & 0x3F);
            r[i++] = (cp < 256) ? cp : '?';
            s += 2;
            }
         else {                         /* outside Latin-1 */
            r[i++] = '?';
            s++;
            while ((*s & 0xC0) == 0x80) s++;
            }
         }
      r[i] = '\0';
      }
   SDL_free(u);
   return r;
}

int usdl_set_clipboard(char *s, int len)
{
   char *u;
   int i, j = 0, ok;
   if (!usdl_init()) return 0;
   u = malloc(2 * len + 1);
   if (u == NULL) return 0;
   for (i = 0; i < len; i++) {
      unsigned char c = s[i];
      if (c < 0x80) u[j++] = c;
      else {
         u[j++] = 0xC0 | (c >> 6);
         u[j++] = 0x80 | (c & 0x3F);
         }
      }
   u[j] = '\0';
   ok = SDL_SetClipboardText(u);
   free(u);
   return ok;
}

unsigned long usdl_ticks(void)
{
   return (unsigned long)SDL_GetTicks();
}

/*
 * ------------------------------------------------------------------
 * Event translation
 * ------------------------------------------------------------------
 */

static int mods_of(SDL_Keymod m)
{
   int r = 0;
   if (m & SDL_KMOD_SHIFT) r |= USDL_MOD_SHIFT;
   if (m & SDL_KMOD_CTRL)  r |= USDL_MOD_CTRL;
   if (m & (SDL_KMOD_ALT | SDL_KMOD_GUI)) r |= USDL_MOD_META;
   return r;
}

/*
 * Map a non-character key to its X11 keysym, which is what Unicon
 * programs (and keysyms.icn) use for "outboard" keys.  0 = not mapped.
 */
static int keysym_of(SDL_Keycode k, int shift)
{
   if (k >= SDLK_F1 && k <= SDLK_F12) return 0xFFBE + (int)(k - SDLK_F1);
   if (k >= SDLK_F13 && k <= SDLK_F24) return 0xFFCA + (int)(k - SDLK_F13);
   switch (k) {
      case SDLK_HOME:        return 0xFF50;
      case SDLK_LEFT:        return 0xFF51;
      case SDLK_UP:          return 0xFF52;
      case SDLK_RIGHT:       return 0xFF53;
      case SDLK_DOWN:        return 0xFF54;
      case SDLK_PAGEUP:      return 0xFF55;
      case SDLK_PAGEDOWN:    return 0xFF56;
      case SDLK_END:         return 0xFF57;
      case SDLK_SELECT:      return 0xFF60;
      case SDLK_PRINTSCREEN: return 0xFF61;
      case SDLK_EXECUTE:     return 0xFF62;
      case SDLK_INSERT:      return 0xFF63;
      case SDLK_UNDO:        return 0xFF65;
      case SDLK_AGAIN:       return 0xFF66;
      case SDLK_APPLICATION: return 0xFF67;
      case SDLK_MENU:        return 0xFF67;
      case SDLK_FIND:        return 0xFF68;
      case SDLK_CANCEL:      return 0xFF69;
      case SDLK_HELP:        return 0xFF6A;
      case SDLK_PAUSE:       return 0xFF13;
      case SDLK_SCROLLLOCK:  return 0xFF14;
      case SDLK_SYSREQ:      return 0xFF15;
      case SDLK_TAB:         return shift ? 0xFE20 : 0;  /* ISO_Left_Tab */
      default:               return 0;
      }
}

static int is_modifier(SDL_Keycode k)
{
   switch (k) {
      case SDLK_LSHIFT: case SDLK_RSHIFT: case SDLK_LCTRL: case SDLK_RCTRL:
      case SDLK_LALT: case SDLK_RALT: case SDLK_LGUI: case SDLK_RGUI:
      case SDLK_CAPSLOCK: case SDLK_NUMLOCKCLEAR: case SDLK_MODE:
         return 1;
      default:
         return 0;
      }
}

static void base_event(struct usdl_event *ev, int type, struct usdlwin *uw,
                       Uint64 ts)
{
   memset(ev, 0, sizeof(*ev));
   ev->type = type;
   ev->owner = uw->owner;
   ev->time = (unsigned long)(ts / 1000000);
}

/*
 * Keys.  Characters normally arrive as text input (which knows about
 * the keyboard layout and dead keys); a key down only produces an event
 * here for keys that do not generate text: control characters, keys
 * pressed with Ctrl/Alt/Cmd, and the keys that have X11 keysyms.
 */
static void key_event(SDL_KeyboardEvent *k, struct usdlwin *uw, int down)
{
   struct usdl_event ev;
   int mods = mods_of(k->mod), sym, ch = -1;
   SDL_Keycode shifted;
   float fx, fy;

   if (is_modifier(k->key)) return;
   base_event(&ev, down ? USDL_EV_KEYDOWN : USDL_EV_KEYUP, uw, k->timestamp);
   ev.mods = mods;
   SDL_GetMouseState(&fx, &fy);
   ev.x = (int)fx; ev.y = (int)fy;

   sym = keysym_of(k->key, mods & USDL_MOD_SHIFT);
   if (sym) {
      ev.key = sym;
      push_event(&ev);
      return;
      }

   switch (k->key) {
      case SDLK_RETURN: case SDLK_KP_ENTER: ch = '\r';   break;
      case SDLK_TAB:                        ch = '\t';   break;
      case SDLK_BACKSPACE:                  ch = '\b';   break;
      case SDLK_ESCAPE:                     ch = '\033'; break;
      case SDLK_DELETE:                     ch = '\177'; break;
      default: break;
      }

   if (ch < 0) {
      shifted = SDL_GetKeyFromScancode(k->scancode, k->mod, true);
      if (shifted >= 0x20 && shifted < 0x7F)
         ch = (int)shifted;
      else if (shifted >= 0xA0 && shifted <= 0xFF)
         ch = (int)shifted;
      else
         return;                        /* nothing Unicon can report */
      if (down && !(mods & (USDL_MOD_CTRL | USDL_MOD_META)))
         return;                        /* the text input event has it */
      if (mods & USDL_MOD_CTRL) {
         if (ch >= 'a' && ch <= 'z') ch &= 0x1F;
         else if (ch >= '@' && ch <= '_') ch &= 0x1F;
         else if (ch == ' ') ch = 0;
         }
      }
   ev.key = ch;
   ev.ischar = 1;
   push_event(&ev);
}

static void text_event(SDL_TextInputEvent *t, struct usdlwin *uw)
{
   struct usdl_event ev;
   unsigned char *s = (unsigned char *)t->text;
   SDL_Keymod m = SDL_GetModState();
   float fx, fy;

   /* Ctrl/Alt/Cmd combinations were reported by the key down event */
   if (m & (SDL_KMOD_CTRL | SDL_KMOD_ALT | SDL_KMOD_GUI)) return;
   base_event(&ev, USDL_EV_KEYDOWN, uw, t->timestamp);
   ev.mods = mods_of(m);
   ev.ischar = 1;
   SDL_GetMouseState(&fx, &fy);
   ev.x = (int)fx; ev.y = (int)fy;
   while (*s) {
      int cp;
      if (*s < 0x80) { cp = *s++; }
      else if ((*s & 0xE0) == 0xC0 && s[1]) {
         cp = ((s[0] & 0x1F) << 6) | (s[1] & 0x3F);
         s += 2;
         }
      else {                            /* outside Latin-1: dropped */
         s++;
         while ((*s & 0xC0) == 0x80) s++;
         continue;
         }
      if (cp >= 256) continue;
      ev.key = cp;
      push_event(&ev);
      }
}

/*
 * Translate one SDL event, queueing zero or more Unicon-level events.
 */
static void translate(SDL_Event *e)
{
   struct usdl_event ev;
   struct usdlwin *uw;

   switch (e->type) {
   case SDL_EVENT_QUIT: {
      /* e.g. Cmd-Q on macOS: ask every window to close */
      SDL_Window **ws;
      int n, i;
      ws = SDL_GetWindows(&n);
      if (ws == NULL) return;
      for (i = 0; i < n; i++) {
         uw = SDL_GetPointerProperty(SDL_GetWindowProperties(ws[i]),
                                     OWNER_PROP, NULL);
         if (uw) {
            base_event(&ev, USDL_EV_CLOSE, uw, e->common.timestamp);
            push_event(&ev);
            }
         }
      SDL_free(ws);
      return;
      }
   case SDL_EVENT_KEY_DOWN:
   case SDL_EVENT_KEY_UP:
      if ((uw = lookup(e->key.windowID)) == NULL) return;
      key_event(&e->key, uw, e->type == SDL_EVENT_KEY_DOWN);
      return;
   case SDL_EVENT_TEXT_INPUT:
      if ((uw = lookup(e->text.windowID)) == NULL) return;
      text_event(&e->text, uw);
      return;
   case SDL_EVENT_MOUSE_BUTTON_DOWN:
   case SDL_EVENT_MOUSE_BUTTON_UP:
      if ((uw = lookup(e->button.windowID)) == NULL) return;
      if (e->button.button < 1 || e->button.button > 3) return;
      base_event(&ev, e->type == SDL_EVENT_MOUSE_BUTTON_DOWN ?
                 USDL_EV_BDOWN : USDL_EV_BUP, uw, e->button.timestamp);
      ev.button = e->button.button;
      ev.x = (int)e->button.x;
      ev.y = (int)e->button.y;
      ev.mods = mods_of(SDL_GetModState());
      push_event(&ev);
      return;
   case SDL_EVENT_MOUSE_MOTION:
      if ((uw = lookup(e->motion.windowID)) == NULL) return;
      base_event(&ev, USDL_EV_MOTION, uw, e->motion.timestamp);
      ev.x = (int)e->motion.x;
      ev.y = (int)e->motion.y;
      ev.buttons = (int)(e->motion.state & 7);
      ev.mods = mods_of(SDL_GetModState());
      push_event(&ev);
      return;
   case SDL_EVENT_MOUSE_WHEEL: {
      float dy;
      if ((uw = lookup(e->wheel.windowID)) == NULL) return;
      dy = e->wheel.y;
      if (e->wheel.direction == SDL_MOUSEWHEEL_FLIPPED) dy = -dy;
      uw->wheel += dy;
      while (uw->wheel >= 1.0f || uw->wheel <= -1.0f) {
         base_event(&ev, USDL_EV_WHEEL, uw, e->wheel.timestamp);
         ev.wheel = (uw->wheel > 0) ? 1 : -1;
         uw->wheel -= (float)ev.wheel;
         ev.x = (int)e->wheel.mouse_x;
         ev.y = (int)e->wheel.mouse_y;
         ev.mods = mods_of(SDL_GetModState());
         push_event(&ev);
         }
      return;
      }
   case SDL_EVENT_WINDOW_RESIZED:
      if ((uw = lookup(e->window.windowID)) == NULL) return;
      uw->redraw = 1;
      base_event(&ev, USDL_EV_RESIZE, uw, e->window.timestamp);
      ev.w = e->window.data1;
      ev.h = e->window.data2;
      push_event(&ev);
      return;
   case SDL_EVENT_WINDOW_MOVED:
      if ((uw = lookup(e->window.windowID)) == NULL) return;
      base_event(&ev, USDL_EV_MOVE, uw, e->window.timestamp);
      ev.x = e->window.data1;
      ev.y = e->window.data2;
      push_event(&ev);
      return;
   case SDL_EVENT_WINDOW_CLOSE_REQUESTED:
      if ((uw = lookup(e->window.windowID)) == NULL) return;
      base_event(&ev, USDL_EV_CLOSE, uw, e->window.timestamp);
      push_event(&ev);
      return;
   case SDL_EVENT_WINDOW_EXPOSED:
   case SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED:
      if ((uw = lookup(e->window.windowID)) == NULL) return;
      uw->redraw = 1;
      base_event(&ev, USDL_EV_EXPOSE, uw, e->window.timestamp);
      push_event(&ev);
      return;
   case SDL_EVENT_WINDOW_SHOWN:
   case SDL_EVENT_WINDOW_HIDDEN:
   case SDL_EVENT_WINDOW_MINIMIZED:
   case SDL_EVENT_WINDOW_MAXIMIZED:
   case SDL_EVENT_WINDOW_RESTORED:
      if ((uw = lookup(e->window.windowID)) == NULL) return;
      uw->redraw = 1;
      base_event(&ev, USDL_EV_STATE, uw, e->window.timestamp);
      push_event(&ev);
      return;
   case SDL_EVENT_WINDOW_MOUSE_ENTER:
      if ((uw = lookup(e->window.windowID)) == NULL) return;
      install_cursor(uw->cursor);
      return;
   default:
      return;
      }
}

/*
 * Return the next translated event without blocking; 0 if none.
 */
int usdl_poll(struct usdl_event *ev)
{
   SDL_Event e;
   if (!sdl_ready || offmain()) return 0;
   for (;;) {
      while (pop_event(ev))
         if (ev->type != USDL_EV_NONE) return 1;
      if (!SDL_PollEvent(&e)) return 0;
      translate(&e);
      }
}

/*
 * Wait up to timeout_ms (forever if negative) for an event.
 */
int usdl_wait(struct usdl_event *ev, int timeout_ms)
{
   SDL_Event e;
   Uint64 deadline = SDL_GetTicks() + (timeout_ms < 0 ? 0 : timeout_ms);
   if (!sdl_ready) return 0;
   if (offmain()) {                     /* the main thread gets events */
      SDL_Delay((timeout_ms < 0 || timeout_ms > 10) ? 10 : timeout_ms);
      return 0;
      }
   for (;;) {
      Sint32 left;
      while (pop_event(ev))
         if (ev->type != USDL_EV_NONE) return 1;
      if (timeout_ms < 0)
         left = -1;
      else {
         Uint64 now = SDL_GetTicks();
         if (now >= deadline) return 0;
         left = (Sint32)(deadline - now);
         }
      if (!SDL_WaitEventTimeout(&e, left)) {
         if (timeout_ms >= 0) return 0;
         continue;
         }
      translate(&e);
      }
}

#if defined(Graphics3D) && HAVE_LIBGL
/*
 * ------------------------------------------------------------------
 * OpenGL for 3D windows
 * ------------------------------------------------------------------
 *
 * Each 3D window has its own OpenGL context, which renders into a
 * framebuffer object the size of the window.  A finished frame is read
 * back into the window's canvas and shown like 2D drawing, so 3D windows,
 * hidden 3D windows and 3D subwindows all work the same way, and Pixel(),
 * WriteImage() and CopyArea() see what was drawn.  The contexts are made
 * against one hidden window and share their textures.
 */
#include <SDL3/SDL_opengl.h>

struct usdlgl {
   SDL_GLContext ctx;
   GLuint fbo, color, depth;            /* framebuffer and its storage */
   int w, h;
   unsigned int *buf;                   /* read-back buffer */
   };

static SDL_GLContext glroot;            /* never deleted; others share it */

static PFNGLGENFRAMEBUFFERSPROC          gl_GenFramebuffers;
static PFNGLDELETEFRAMEBUFFERSPROC       gl_DeleteFramebuffers;
static PFNGLBINDFRAMEBUFFERPROC          gl_BindFramebuffer;
static PFNGLGENRENDERBUFFERSPROC         gl_GenRenderbuffers;
static PFNGLDELETERENDERBUFFERSPROC      gl_DeleteRenderbuffers;
static PFNGLBINDRENDERBUFFERPROC         gl_BindRenderbuffer;
static PFNGLRENDERBUFFERSTORAGEPROC      gl_RenderbufferStorage;
static PFNGLFRAMEBUFFERRENDERBUFFERPROC  gl_FramebufferRenderbuffer;
static PFNGLCHECKFRAMEBUFFERSTATUSPROC   gl_CheckFramebufferStatus;

/* a framebuffer object function: the OpenGL 3.0 name, else the EXT one */
static SDL_FunctionPointer glproc(const char *core)
{
   char ext[64];
   SDL_FunctionPointer f = SDL_GL_GetProcAddress(core);
   if (f == NULL) {
      snprintf(ext, sizeof(ext), "%sEXT", core);
      f = SDL_GL_GetProcAddress(ext);
      }
   return f;
}

static int glsetup(void)
{
   if (glwin) return 1;
   if (!usdl_init()) return 0;
   if (offmain()) {
      snprintf(errbuf, sizeof(errbuf),
               "3D windows can only be opened by the main thread");
      return 0;
      }
   /* the fixed-function pipeline: a compatibility (macOS: legacy) context */
   SDL_GL_ResetAttributes();
   SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK,
                       SDL_GL_CONTEXT_PROFILE_COMPATIBILITY);
   glwin = SDL_CreateWindow("Unicon 3D", 16, 16,
                            SDL_WINDOW_OPENGL | SDL_WINDOW_HIDDEN);
   if (glwin == NULL) {
      snprintf(errbuf, sizeof(errbuf), "OpenGL: %s", SDL_GetError());
      return 0;
      }
   glroot = SDL_GL_CreateContext(glwin);
   if (glroot == NULL) {
      snprintf(errbuf, sizeof(errbuf), "OpenGL: %s", SDL_GetError());
      SDL_DestroyWindow(glwin);
      glwin = NULL;
      return 0;
      }
   gl_GenFramebuffers = (PFNGLGENFRAMEBUFFERSPROC)glproc("glGenFramebuffers");
   gl_DeleteFramebuffers =
      (PFNGLDELETEFRAMEBUFFERSPROC)glproc("glDeleteFramebuffers");
   gl_BindFramebuffer = (PFNGLBINDFRAMEBUFFERPROC)glproc("glBindFramebuffer");
   gl_GenRenderbuffers =
      (PFNGLGENRENDERBUFFERSPROC)glproc("glGenRenderbuffers");
   gl_DeleteRenderbuffers =
      (PFNGLDELETERENDERBUFFERSPROC)glproc("glDeleteRenderbuffers");
   gl_BindRenderbuffer =
      (PFNGLBINDRENDERBUFFERPROC)glproc("glBindRenderbuffer");
   gl_RenderbufferStorage =
      (PFNGLRENDERBUFFERSTORAGEPROC)glproc("glRenderbufferStorage");
   gl_FramebufferRenderbuffer =
      (PFNGLFRAMEBUFFERRENDERBUFFERPROC)glproc("glFramebufferRenderbuffer");
   gl_CheckFramebufferStatus =
      (PFNGLCHECKFRAMEBUFFERSTATUSPROC)glproc("glCheckFramebufferStatus");
   if (!gl_GenFramebuffers || !gl_DeleteFramebuffers || !gl_BindFramebuffer ||
       !gl_GenRenderbuffers || !gl_DeleteRenderbuffers ||
       !gl_BindRenderbuffer || !gl_RenderbufferStorage ||
       !gl_FramebufferRenderbuffer || !gl_CheckFramebufferStatus) {
      snprintf(errbuf, sizeof(errbuf),
               "OpenGL has no framebuffer objects (version %s)",
               (char *)glGetString(GL_VERSION));
      SDL_GL_DestroyContext(glroot);
      glroot = NULL;
      SDL_DestroyWindow(glwin);
      glwin = NULL;
      return 0;
      }
   return 1;
}

struct usdlgl *usdl_gl_open(void)
{
   struct usdlgl *g;

   if (!glsetup()) return NULL;
   if ((g = calloc(1, sizeof(struct usdlgl))) == NULL) {
      snprintf(errbuf, sizeof(errbuf), "out of memory");
      return NULL;
      }
   SDL_GL_MakeCurrent(glwin, glroot);
   SDL_GL_SetAttribute(SDL_GL_SHARE_WITH_CURRENT_CONTEXT, 1);
   g->ctx = SDL_GL_CreateContext(glwin);
   SDL_GL_SetAttribute(SDL_GL_SHARE_WITH_CURRENT_CONTEXT, 0);
   if (g->ctx == NULL || !SDL_GL_MakeCurrent(glwin, g->ctx)) {
      snprintf(errbuf, sizeof(errbuf), "OpenGL: %s", SDL_GetError());
      if (g->ctx) SDL_GL_DestroyContext(g->ctx);
      free(g);
      return NULL;
      }
   gl_GenFramebuffers(1, &g->fbo);
   gl_GenRenderbuffers(1, &g->color);
   gl_GenRenderbuffers(1, &g->depth);
   gl_BindFramebuffer(GL_FRAMEBUFFER, g->fbo);
   return g;
}

/*
 * Make g's context current (in this thread) and draw into its window.
 */
int usdl_gl_current(struct usdlgl *g)
{
   if (g == NULL) return 0;
   if (SDL_GL_GetCurrentContext() != g->ctx &&
       !SDL_GL_MakeCurrent(glwin, g->ctx))
      return 0;
   gl_BindFramebuffer(GL_FRAMEBUFFER, g->fbo);
   return 1;
}

/*
 * Size the framebuffer for a w x h window (its contents are then
 * undefined): 2 if the size changed, 1 if it was already that size, 0 on
 * failure.  It has the display's resolution: scale x scale pixels per
 * Unicon pixel, as the canvas does.
 */
int usdl_gl_size(struct usdlgl *g, int w, int h)
{
   unsigned int *nb;
   int s = uc_get_scale();

   if (w < 1) w = 1;
   if (h < 1) h = 1;
   w *= s;
   h *= s;
   if (!usdl_gl_current(g)) return 0;
   if (w == g->w && h == g->h) return 1;   /* already: 1; resized: 2 */
   if ((nb = realloc(g->buf, (size_t)w * h * sizeof(unsigned int))) == NULL)
      return 0;
   g->buf = nb;
   gl_BindRenderbuffer(GL_RENDERBUFFER, g->color);
   gl_RenderbufferStorage(GL_RENDERBUFFER, GL_RGBA8, w, h);
   gl_BindRenderbuffer(GL_RENDERBUFFER, g->depth);
   gl_RenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT24, w, h);
   gl_BindRenderbuffer(GL_RENDERBUFFER, 0);
   gl_FramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                              GL_RENDERBUFFER, g->color);
   gl_FramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT,
                              GL_RENDERBUFFER, g->depth);
   if (gl_CheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
      snprintf(errbuf, sizeof(errbuf), "OpenGL: incomplete framebuffer");
      return 0;
      }
   g->w = w;
   g->h = h;
   return 2;
}

/*
 * Copy the rendered frame into canvas c at (x,y).
 */
int usdl_gl_show(struct usdlgl *g, struct ucanvas *c, int x, int y)
{
   GLint align, rowlen;

   if (c == NULL || g->buf == NULL || !usdl_gl_current(g)) return 0;
   glGetIntegerv(GL_PACK_ALIGNMENT, &align);
   glGetIntegerv(GL_PACK_ROW_LENGTH, &rowlen);
   glPixelStorei(GL_PACK_ALIGNMENT, 4);
   glPixelStorei(GL_PACK_ROW_LENGTH, 0);
   glReadPixels(0, 0, g->w, g->h, GL_BGRA, GL_UNSIGNED_INT_8_8_8_8_REV, g->buf);
   glPixelStorei(GL_PACK_ALIGNMENT, align);
   glPixelStorei(GL_PACK_ROW_LENGTH, rowlen);
   if (c->scale == uc_get_scale())
      uc_put_device_rgb(c, x * c->scale, y * c->scale, g->w, g->h, g->buf,
                        g->w, 1);
   else if (uc_get_scale() == 1)
      uc_put_rgb(c, x, y, g->w, g->h, g->buf, g->w, 1);
   return 1;
}

/*
 * ropengl.ri's view of the framebuffer is in Unicon pixels; these scale
 * its viewport, line widths and pixel reads to the display's resolution.
 */
void usdl_gl_viewport(int x, int y, int w, int h)
{
   int s = uc_get_scale();
   glViewport(x * s, y * s, w * s, h * s);
}

void usdl_gl_linewidth(double w)
{
   glLineWidth((GLfloat)(w * uc_get_scale()));
}

/* read Unicon pixels: the middle device pixel of each */
void usdl_gl_readpixels(int x, int y, int w, int h, unsigned int format,
                        unsigned int type, void *data)
{
   int s = uc_get_scale(), n, i, j, k;
   unsigned char *big, *out = data;

   if (s == 1 || type != GL_UNSIGNED_BYTE ||
       (format != GL_RGB && format != GL_RGBA)) {
      glReadPixels(x, y, w, h, format, type, data);
      return;
      }
   n = (format == GL_RGBA) ? 4 : 3;
   if ((big = malloc((size_t)w * s * h * s * n)) == NULL) return;
   glPixelStorei(GL_PACK_ALIGNMENT, 1);
   glReadPixels(x * s, y * s, w * s, h * s, format, type, big);
   for (j = 0; j < h; j++)
      for (i = 0; i < w; i++) {
         unsigned char *p = big +
            ((size_t)(j * s + s / 2) * w * s + (size_t)i * s + s / 2) * n;
         for (k = 0; k < n; k++)
            *out++ = p[k];
         }
   free(big);
}

void usdl_gl_close(struct usdlgl *g)
{
   if (g == NULL) return;
   if (SDL_GL_MakeCurrent(glwin, g->ctx)) {
      gl_BindFramebuffer(GL_FRAMEBUFFER, 0);
      gl_DeleteFramebuffers(1, &g->fbo);
      gl_DeleteRenderbuffers(1, &g->color);
      gl_DeleteRenderbuffers(1, &g->depth);
      }
   SDL_GL_MakeCurrent(glwin, glroot);
   SDL_GL_DestroyContext(g->ctx);
   free(g->buf);
   free(g);
}
#endif                                  /* Graphics3D && HAVE_LIBGL */

#else                                   /* SDLGraphics */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-variable"
  static char x;
#pragma GCC diagnostic pop
#endif                                  /* SDLGraphics */
