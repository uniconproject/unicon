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
#include "ropengl.ri"
#endif

#else					/* Graphics */
static char junk;		/* avoid empty module */
#endif					/* Graphics */
