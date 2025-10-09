/*--------------------------------------------------------------------------------
 *
 * This file is released under the terms of the GNU LIBRARY GENERAL PUBLIC LICENSE
 * (LGPL) version 2. The licence may be found in the root directory of the Unicon
 * source directory in the file COPYING.
 *
 *--------------------------------------------------------------------------------
 *
 * This is a reimplementation in C of the original generator (written in C++)
 * which may be found at
 *     https://github.com/hahnjo/ranluxpp/blob/main/RanluxppEngine.cpp
 * The original header comments are
 * --------------------------------------------------------------------------------
Implementation of the RANLUX++ generator

RANLUX++ is an LCG equivalent of RANLUX using 576 bit numbers.

The idea of the generator (such as the initialization method) and the algorithm
for the modulo operation are described in
A. Sibidanov, *A revision of the subtract-with-borrow random numbergenerators*,
*Computer Physics Communications*, 221(2017), 299-303,
preprint https://arxiv.org/pdf/1705.03123.pdf

The code is loosely based on the Assembly implementation by A. Sibidanov
available at https://github.com/sibidanov/ranluxpp/.

Compared to the original generator, this implementation contains a fix to ensure
that the modulo operation of the LCG always returns the smallest value congruent
to the modulus (based on notes by M. Lüscher). Also, the generator converts the
LCG state back to RANLUX numbers (implementation based on notes by M. Lüscher).
This avoids a bias in the generated numbers because the upper bits of the LCG
state, that is smaller than the modulus \f$ m = 2^{576} - 2^{240} + 1 \f$ (not
a power of 2!), have a higher probability of being 0 than 1. And finally, this
implementation draws 48 random bits for each generated floating point number
(instead of 52 bits as in the original generator) to maintain the theoretical
properties from understanding the original transition function of RANLUX as a
chaotic dynamical system.

These modifications and the portable implementation in general are described in
J. Hahnfeld, L. Moneta, *A Portable Implementation of RANLUX++*, vCHEP2021
preprint https://arxiv.org/pdf/2106.02504.pdf
 * --------------------------------------------------------------------------------
 *
 *
 *   (re) Implementation by Don Ward March 2022
 */

#include "CRanluxppEngine.h"

#include "ranluxpp/mulmod.h"
#include "ranluxpp/ranlux_lcg.h"

#include <assert.h>
#include <stdint.h>

static const uint64_t kA_2048[] = {
    0xed7faa90747aaad9, 0x4cec2c78af55c101, 0xe64dcb31c48228ec,
    0x6d8a15a13bee7cb0, 0x20b2ca60cb78c509, 0x256c3d3c662ea36c,
    0xff74e54107684ed2, 0x492edfcc0cc8e753, 0xb48c187cf5b22097
};

static const int kMaxPos = 9 * 64;
static const int kBits = 48;

void SetSeed(crlx_state_ptr sp, uint64_t s) {
  uint64_t lcg[9] = {1};        /* lcg[0] = 1, lcg [1..8] = 0 */
  uint64_t a_seed[9];

  // Skip 2 ** 96 states.
  powermod(kA_2048, a_seed, (uint64_t)(1) << 48);
  powermod(a_seed, a_seed, (uint64_t)(1) << 48);
  // Skip another s states.
  powermod(a_seed, a_seed, s);
  mulmod(a_seed, lcg);

  to_ranlux(lcg, sp->fState, &(sp->fCarry));
  sp->fPosition = 0;
}

static void Advance(crlx_state_ptr sp) {
  uint64_t lcg[9];
  to_lcg(sp->fState, sp->fCarry, lcg);
  mulmod(kA_2048, lcg);
  to_ranlux(lcg, sp->fState, &(sp->fCarry));
  sp->fPosition = 0;
}

static uint64_t NextRandomBits(crlx_state_ptr sp) {
  if (sp->fPosition + kBits > kMaxPos) {
    Advance(sp);
  }

  int idx = sp->fPosition / 64;
  int offset = sp->fPosition % 64;
  int numBits = 64 - offset;

  uint64_t bits = sp->fState[idx] >> offset;
  if (numBits < kBits) {
    bits |= sp->fState[idx + 1] << numBits;
  }
  bits &= (((uint64_t)(1) << kBits) - 1);

  sp->fPosition += kBits;
  assert(sp->fPosition <= kMaxPos && "position out of range!");

  return bits;
}

/// Skip `n` random numbers without generating them
void Skip(crlx_state_ptr sp, uint64_t n) {
  int left = (kMaxPos - sp->fPosition) / kBits;
  assert(left >= 0 && "position was out of range!");
  if (n < (uint64_t)left) {
    // Just skip the next few entries in the currently available bits.
    sp->fPosition += n * kBits;
    assert(sp->fPosition <= kMaxPos && "position out of range!");
    return;
  }

  n -= left;
  // Need to advance and possibly skip over blocks.
  int nPerState = kMaxPos / kBits;
  int skip = (n / nPerState);

  uint64_t a_skip[9];
  powermod(kA_2048, a_skip, skip + 1);

  uint64_t lcg[9];
  to_lcg(sp->fState, sp->fCarry, lcg);
  mulmod(a_skip, lcg);
  to_ranlux(lcg, sp->fState, &(sp->fCarry));

  // Potentially skip numbers in the freshly generated block.
  int remaining = n - skip * nPerState;
  assert(remaining >= 0 && "should not end up at a negative position!");
  sp->fPosition = remaining * kBits;
  assert(sp->fPosition <= kMaxPos && "position out of range!");
}

/// Generate a double-precision random number with 48 bits of randomness
double Rndm(crlx_state_ptr sp) {
  static const double div = 1.0 / ((uint64_t)(1) << kBits);
  uint64_t bits = NextRandomBits(sp);
  return bits * div;
}

/// Generate a random integer value with 48 bits
uint64_t IntRndm(crlx_state_ptr sp) { return NextRandomBits(sp); }

