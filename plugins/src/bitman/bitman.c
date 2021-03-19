/* ---------------------------------------------------------------------------
 *
 * This file is released under the terms of the GNU LIBRARY GENERAL PUBLIC LICENSE
 * (LGPL) version 2. The licence may be found in the root directory of the Unicon
 * source directory in the file COPYING.
 *
 * ---------------------------------------------------------------------------
 * Low level bit manipulation routines
 *
 * Author  :    Don Ward
 * Date    :    March 2021
 *
 *
 * These routines are the equivalent of the Unicon built-in functions
 * except they never produce a large integer and there is no special
 * case for the sign bit.
 *    bor      bitwise inclusive or       (ior)
 *    bxor     bitwise exclusive or       (ixor)
 *    band     bitwise and                (iand)
 *    bcom     bitwise one's complement   (icom)
 *    bshift   bitwise shift              (ishift)
 * plus
 *    bits     enquiry and bit extraction
 *    bit      single bit extraction
 *    brot     bit rotation
 *
 * bit(x,n) works the same way as string indexing (but indexing bits instead
 * of characters, including negative indices meaning "from the end").
 *   bit(x,1) is the ls bit of x,      (analogous to s[1]).
 *   bit(x,n) is the nth bit of x      (analogous to s[n] when n is +ve).
 *   bit(x,0) is the ms bit of x       (analogous to s[0]).
 *   bit(x,-n) is analogous to s[-n] i.e indexes from the ms end of x.
 *
 * bits(x,n,m) works the same way as substring indexing s[n:m].
 * Note that, as with substrings, the bits are not reversed if m < n.
 *    bits(x,n,m) = bits(x,m,n)
 *
 * The routines are not portable by design (i.e. on machines with different
 * word lengths they will give different results) which is, presumably, why
 * you're using them in place of ior and friends.
 */
#include "bitman.h"

#define NBITS (sizeof(word)*8)

/* ---------------------------------------- */
RTEX
int bor(UARGS)    /* bitwise inclusive or */
{
  if (argc != 2) Fail;
  ArgNativeInteger(1);
  ArgNativeInteger(2);

  RetInteger(IntegerVal(argv[1]) | IntegerVal(argv[2]));
}

/* ---------------------------------------- */
RTEX
int bxor(UARGS)    /* bitwise exclusive or */
{
  if (argc != 2) Fail;
  ArgNativeInteger(1);
  ArgNativeInteger(2);

  RetInteger(IntegerVal(argv[1]) ^ IntegerVal(argv[2]));
}

/* ---------------------------------------- */
RTEX
int band(UARGS)    /* bitwise and */
{
  if (argc != 2) Fail;
  ArgNativeInteger(1);
  ArgNativeInteger(2);

  RetInteger(IntegerVal(argv[1]) & IntegerVal(argv[2]));
}

/* ---------------------------------------- */
RTEX
int bcom(UARGS)    /* bitwise one's complement */
{
  if (argc != 1) Fail;
  ArgNativeInteger(1);

  RetInteger(~IntegerVal(argv[1]));
}

/* ---------------------------------------- */
RTEX
int bshift(UARGS)    /* bitwise shift */
{
  word n;
  if (argc != 2) Fail;
  ArgNativeInteger(1);
  ArgNativeInteger(2);

  /* If the amount to shift is >= wordsize, the result is undefined. */
  /* In that case we return a zero value. */
  n = IntegerVal(argv[2]);
  if (n == 0) {
    RetInteger(IntegerVal(argv[1]));
  } else if (n > 0) {
    if (n < NBITS) {
      RetInteger(IntegerVal(argv[1]) << n);
    } else {
      RetInteger(0);
    }
  } else {
    n = -n;
    if (n < NBITS) {
      RetInteger(IntegerVal(argv[1]) >> n);
    } else {
      RetInteger(0);
    }
  }
}

/* ---------------------------------------- */
RTEX
int bits(UARGS)    /* enquiry and bit extraction */
{
  if (argc == 0) { /* return how many bits there are in a word */
    RetInteger(NBITS);
  } else { /* Extract some bits from a word */
    word lo, hi;
    if (argc != 3) Fail;

    ArgNativeInteger(1);
    ArgNativeInteger(2);
    ArgNativeInteger(3);
    lo = IntegerVal(argv[2]);
    hi = IntegerVal(argv[3]);
    if (lo <= 0) lo = 1 + NBITS + lo;
    if (hi <= 0) hi = 1 + NBITS + hi;
    if (hi < lo) {
      word tmp = hi;
      hi = lo; lo = tmp;
    }
    if ((lo < 1) || (hi < 1) || (lo > NBITS) || (hi > (1 + NBITS))) Fail;
    if (lo == hi) Fail;         /* zero length bit string */

     /* Check for the easy case */
    if ((lo == 1) && (hi == (1 + NBITS))) {
      RetArg(1);
    } else {
      word ans = IntegerVal(argv[1]);
      if (lo > 1) ans >>= (lo - 1); /* Shift to the RHS */
      ans &= (((uword)(-1)) >> (NBITS + lo - hi)); /* Clear unwanted bits */
      RetInteger(ans);
    }
  }
}

/* ---------------------------------------- */
RTEX
int bit(UARGS)    /* single bit extraction */
{
  word bn;
  if (argc != 2) Fail;

  ArgNativeInteger(1);
  ArgNativeInteger(2);

  bn = IntegerVal(argv[2]);
  if (bn == 0) Fail;
  if (bn < 0) bn = NBITS + bn + 1; /* addressing from ms end */
  if ((bn < 1) || (bn > NBITS)) Fail;
  if (bn == 1) RetInteger(IntegerVal(argv[1]) & 1);
  RetInteger( (IntegerVal(argv[1]) >> (bn - 1)) & 1);
}

/* ---------------------------------------- */
RTEX
int brot(UARGS)    /* bit rotation */
{
  word n;
  if (argc != 2) Fail;
  ArgNativeInteger(1);
  ArgNativeInteger(2);

  n = IntegerVal(argv[2]) % NBITS;
  if (n == 0) {
    RetArg(1);                  /* Easy! */
  } else {
    word ans = IntegerVal(argv[1]);
    if (n < 0) n = NBITS + n;
    RetInteger((ans << n) | ((ans >> (NBITS - n)) & (((uword)~0) >> (NBITS -n))));
  }
}



