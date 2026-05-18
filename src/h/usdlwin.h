/*
 * usdlwin.h - the window-system layer of Unicon's SDL graphics backend.
 *
 * A thin shim over SDL3: on-screen windows, putting a canvas's pixels on
 * screen, input events, pointer, cursor and clipboard.  The runtime never
 * sees SDL types; it sees only this header, so rtt can read it.
 */
#ifndef USDLWIN_H
#define USDLWIN_H

struct ucanvas;
struct usdlwin;

/* position for usdl_open() that lets the window system choose */
#define USDL_POS_UNDEFINED (-1000000)

/* window flags for usdl_open() */
#define USDL_RESIZABLE   1
#define USDL_BORDERLESS  2
#define USDL_HIDDEN      4
#define USDL_MINIMIZED   8
#define USDL_MAXIMIZED   16

/* window states from usdl_state() */
#define USDL_STATE_NORMAL    0
#define USDL_STATE_ICONIC    1
#define USDL_STATE_MAXIMIZED 2
#define USDL_STATE_HIDDEN    3

/* event types */
#define USDL_EV_NONE     0
#define USDL_EV_KEYDOWN  1      /* key: a character (ischar) or keysym */
#define USDL_EV_KEYUP    2
#define USDL_EV_BDOWN    3      /* button: 1 left, 2 middle, 3 right */
#define USDL_EV_BUP      4
#define USDL_EV_MOTION   5      /* buttons: held buttons, bit (button-1) */
#define USDL_EV_WHEEL    6      /* wheel: +1 up, -1 down */
#define USDL_EV_RESIZE   7      /* w, h: new size */
#define USDL_EV_MOVE     8      /* x, y: new position */
#define USDL_EV_CLOSE    9      /* close requested by the user */
#define USDL_EV_EXPOSE   10
#define USDL_EV_STATE    11     /* minimized, maximized, restored, ... */

/* modifier bits */
#define USDL_MOD_SHIFT   1
#define USDL_MOD_CTRL    2
#define USDL_MOD_META    4

struct usdl_event {
   int type;
   void *owner;                 /* owner pointer given to usdl_open() */
   int x, y;                    /* pointer position in the window */
   int w, h;
   int button, buttons;
   int key, ischar;
   int mods;
   int wheel;
   unsigned long time;          /* milliseconds */
   };

int  usdl_init(void);
char *usdl_error(void);
void usdl_display_size(int *w, int *h);

struct usdlwin *usdl_open(char *title, int x, int y, int w, int h,
                          int flags, void *owner);
void usdl_close(struct usdlwin *win);
void usdl_set_title(struct usdlwin *win, char *title);
void usdl_set_icon(struct usdlwin *win, struct ucanvas *c);
void usdl_set_position(struct usdlwin *win, int x, int y);
void usdl_get_position(struct usdlwin *win, int *x, int *y);
void usdl_set_size(struct usdlwin *win, int w, int h);
void usdl_get_size(struct usdlwin *win, int *w, int *h);
void usdl_set_resizable(struct usdlwin *win, int on);
void usdl_set_min_size(struct usdlwin *win, int w, int h);
void usdl_show(struct usdlwin *win);
void usdl_hide(struct usdlwin *win);
void usdl_raise(struct usdlwin *win);
void usdl_minimize(struct usdlwin *win);
void usdl_maximize(struct usdlwin *win);
void usdl_restore(struct usdlwin *win);
int  usdl_state(struct usdlwin *win);
void usdl_sync(struct usdlwin *win);

void usdl_present(struct usdlwin *win, struct ucanvas *c, int force);
void usdl_set_cursor(struct usdlwin *win, int shape);
void usdl_warp_pointer(struct usdlwin *win, int x, int y);
int  usdl_pointer(struct usdlwin *win, int *x, int *y);
void usdl_global_pointer(int *x, int *y);
char *usdl_get_clipboard(void);
int  usdl_set_clipboard(char *s, int len);

int  usdl_poll(struct usdl_event *ev);
int  usdl_wait(struct usdl_event *ev, int timeout_ms);
unsigned long usdl_ticks(void);

/* cursor shapes for usdl_set_cursor() */
#define USDL_CURSOR_ARROW       0
#define USDL_CURSOR_TEXT        1
#define USDL_CURSOR_WAIT        2
#define USDL_CURSOR_CROSSHAIR   3
#define USDL_CURSOR_PROGRESS    4
#define USDL_CURSOR_NWSE        5
#define USDL_CURSOR_NESW        6
#define USDL_CURSOR_EW          7
#define USDL_CURSOR_NS          8
#define USDL_CURSOR_MOVE        9
#define USDL_CURSOR_NO          10
#define USDL_CURSOR_HAND        11

#endif                                  /* USDLWIN_H */
