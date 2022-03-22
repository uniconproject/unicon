#ifndef _CRanluxppEngine_h
#define _CRanluxppEngine_h
/*--------------------------------------------------------------------------------
 *
 * This file is released under the terms of the GNU LIBRARY GENERAL PUBLIC LICENSE
 * (LGPL) version 2. The licence may be found in the root directory of the Unicon
 * source directory in the file COPYING.
 *
 *--------------------------------------------------------------------------------
 */

#include <stdint.h>

typedef struct cranlux_state {
  uint64_t fState[9];     ///< RANLUX state of the generator
  unsigned fCarry;        ///< Carry bit of the RANLUX state
  int fPosition;          ///< Current position in bits
} crlx_state, *crlx_state_ptr;

/// Generate a double-precision random number with 48 bits of randomness
extern double Rndm(crlx_state_ptr);

/// Generate a random integer value with 48 bits
extern uint64_t IntRndm(crlx_state_ptr);

/// Initialize and seed the state of the generator
extern void SetSeed(crlx_state_ptr, uint64_t seed);

/// Skip `n` random numbers without generating them
extern void Skip(crlx_state_ptr, uint64_t n);

#endif
