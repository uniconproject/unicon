/*
 * File: fxtra.r
 *  Contents: additional functions to extend the standard Icon repertoire.
 *  This file includes collections of functions, such as functions specific to
 *  MS-DOS (DosFncs).
 *
 *  These collections are under the control of conditional compilation
 *  as indicated by the symbols in parentheses. To enable a set of functions,
 *  define the corresponding symbol in ../h/define.h.  The functions themselves
 *  are in separate files, included according to the defined symbols.
 */


#ifdef DosFncs
#include "fxmsdos.ri"
#endif                                  /* DosFncs */

#ifdef PosixFns
#include "fxposix.ri"
#endif                                  /* POSIX interface functions */

/*
 * Always include - defines dummy functions if audio is not supported.
 */
#include "fxaudio.ri"

#ifdef PatternType
#include "fxpattrn.ri"
#endif                                  /* (Snobol-style) Pattern data type */

/* static char junk;                    /* avoid empty module */
