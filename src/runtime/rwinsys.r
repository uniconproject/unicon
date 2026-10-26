/*
 * File: rwinsys.r
 *  Window-system-specific window support routines.
 *  This file simply includes an appropriate r*win.ri file.
 */

void checkpollevent(){
#ifdef Graphics
#ifdef KbhitPoll
   while (!kbhit_ms(133)) { pollevent(); }
#else                                   /* KbhitPoll */
   while (!kbhit()) { idelay(100); pollevent(); }
#endif                                  /* KbhitPoll */
#endif                                  /* Graphics */
}

#ifdef Graphics

#ifdef XWindows
#include "rxwin.ri"
#endif                                  /* XWindows */

#ifdef MSWindows
#include "rmswin.ri"
#else
#endif                                  /* MSWindows */

#ifdef SDLGraphics
#include "rsdlwin.ri"
#if NT
/*
 * main() is named iconx() on MS Windows (see imain.r): call it from
 * main() in the console build (iconx) and from WinMain() in the GUI
 * build (wiconx), which the GUI translator (wicont) also links with its
 * own main().
 */
int iconx(int argc, char **argv);
#ifdef NTConsole
int main(int argc, char *argv[])
{
   return iconx(argc, argv);
}
#else                                   /* NTConsole */
#passthru int WINAPI WinMain(HINSTANCE hi, HINSTANCE hp, LPSTR cmd, int show)
#passthru {
#passthru    return iconx(__argc, __argv);
#passthru }
#endif                                  /* NTConsole */
#endif                                  /* NT */
#endif                                  /* SDLGraphics */

#ifdef Graphics3D
#include "rwin3d.ri"
#if HAVE_LIBGL
#include "ropengl.ri"
#endif                                  /* HAVE_LIBGL */
#if HAVE_D3D
#include "rd3d.ri"
#endif                                  /* HAVE_D3D */
#endif                                  /* Graphics3D */

#else                                   /* Graphics */
#if NT
int iconx(int argc, char **argv);
int main(int argc, char *argv[])
{
   return iconx(argc, argv);
}
#endif                                  /* NT */
/* static char junk;            /* avoid empty module */
#endif                                  /* Graphics */
