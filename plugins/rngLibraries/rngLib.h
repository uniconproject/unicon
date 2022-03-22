#ifndef _rnglib_h
#define _rnglib_h
/*--------------------------------------------------------------------------------
 *
 * This file is released under the terms of the GNU LIBRARY GENERAL PUBLIC LICENSE
 * (LGPL) version 2. The licence may be found in the root directory of the Unicon
 * source directory in the file COPYING.
 *
 *--------------------------------------------------------------------------------
 *
 * This is the header file used by all RNG libraries
 *
 *--------------------------------------------------------------------------------
 *
 *    Don Ward
 *    August 2019
 *
 *--------------------------------------------------------------------------------
 */

/* Make sure the RngLibrary extensions are active */
#define RngLibrary 1

/* There are two icall.h files: we want the modern one */
#include "../../uni/icall/icall.h"

/* These routines must be defined by the RNG library */
extern   char * (getErrortext)(int);
extern   double (getRandomFpt)(void);
extern   int    (putSeed)(word, word, void *); /* Type, Size, Seed parameter */
extern   int    (startRng)(struct rngprops *, struct rng_rt_api *);

/* These routines are optional
 * extern int    (*getRandomBits)(int, void *);   No of bits, output buffer
 *
 * If the RNG library does not provide it then rngbits() and rngbitstring()
 * will always fail (but everything else will work).
 *
 * extern word   (getRandomInt)(void);
 * If the RNG library does not provide it then rngval() will always fail
 */

#endif /* _rnglib_h */
