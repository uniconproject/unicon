/*
 * File: rwinsys.r
 *  Window-system-specific window support routines.
 *  This file simply includes an appropriate r*win.ri file.
 */

#ifdef Graphics

#ifdef MacGraph
#include "rmac.ri"
#endif					/* MacGraph */

#ifdef PresentationManager
#include "rpmwin.ri"
#endif					/* PresentationManager */

#ifdef XWindows
#include "rxwin.ri"
#endif					/* XWindows */

#ifdef MSWindows
#include "rmswin.ri"
#endif  				/* MSWindows */

#ifdef Graphics3D
#if HAVE_LIBGL
#include "ropengl.ri"
#endif					/* HAVE_LIBGL */
#if HAVE_D3D
#include "rd3d.ri"
#endif					/* HAVE_D3D */
#endif					/* Graphics3D */

#else					/* Graphics */
static char junk;		/* avoid empty module */
#endif					/* Graphics */
