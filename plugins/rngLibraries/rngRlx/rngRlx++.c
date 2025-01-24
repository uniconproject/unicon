/*--------------------------------------------------------------------------------
 *
 * This file is released under the terms of the GNU LIBRARY GENERAL PUBLIC LICENSE
 * (LGPL) version 2. The licence may be found in the root directory of the Unicon
 * source directory in the file COPYING.
 *
 *--------------------------------------------------------------------------------
 *
 * This is a reimplementation in C of the ranlux++ random number generator as
 * a dynamically loaded rng library. The original is written in C++ and may be found
 * at https://github.com/hahnjo/ranluxpp. This file interfaces the generator with
 * the Unicon runtime system
 *
 *--------------------------------------------------------------------------------
 *
 *    Don Ward
 *    March 2022
 *
 *--------------------------------------------------------------------------------
 */

#include "../rngLib.h"
#include "CRanluxppEngine.h"

struct rng_rt_api runtime;  /* A place to store the routines callable by the rng */

/*-------------------------------------------------------------------------------*/
/* This routine is called once by the runtime when the library
 * is first loaded.
 */
int startRng(struct rngprops *props, struct rng_rt_api *rtapi)
{ /*
   * Tell the runtime how much state is needed.
   * NB. the state size is in bits, not bytes.
   */
  props->stateBits = 8 * sizeof(crlx_state);
  /*
   * Specify what types are acceptable as a parameter to putSeed
   * If more than one type is acceptable, or them together
   * eg RngTypeFlag(T_Integer) | RngTypeFlag(T_String)
   *
   * See icall.h for the names of types.
   *
   * The easy types to deal with are
   *    strings
   *    integers, reals (and arrays of either)
   *
   * Other types are possible, but require a detailed understanding of
   * how Unicon represents the type values internally. Familiarity with
   * the Unicon implementation book is essential.
   */
  props->typeFlags = RngTypeFlag(T_Integer) | RngTypeFlag(T_String);

  /*
   * Tell the runtime what the "natural size" of the random output is.
   * For example, if the generator algorithm naturally produces a block
   * of output, tell the runtime what the size of the block is.
   * NB. the block size is in bits, not bytes.
   */
  props->blockBits = 48;

  /* Store the routines that we can call */
  runtime = *rtapi;

  /*
   * If the generator requires any "first time" set up (e.g. to build S-Boxes
   * or similar tables), here is the best place to call the setup routine.
   *
   * Ranlux++ does not require "first time" setup.
   */

  return 0;                     /* Success */
}

/*-------------------------------------------------------------------------------*/
/* This routine is called by the runtime to get the string values of
 * the custom error numbers set by the generator.
 */
char * getErrorText(int err)
{
  switch (err)
    {
    case 700: return "Unexpected type supplied to putSeed";
    case 701: return "Unexpected size supplied to putSeed";
    case 702: return "Bad seed value";

    default:  return "??";      /* Not one of our errors */
    }
}

/*--------------------------------------------------------------------------------*/
/* Convert an ASCII hex nibble to binary
 * Users of EBCDIC are out of luck
 */
static int hex(unsigned char h)
{
  if (('0' <= h) && (h <= '9')) return h - '0';
  if (('a' <= h) && (h <= 'f')) return 10 + h - 'a';
  if (('A' <= h) && (h <= 'F')) return 10 + h - 'A';
  return -1;
}

/*-------------------------------------------------------------------------------*/
/* This routine is called by the runtime when an assignment that is not
 * a restored state is made to &random. The runtime detects an assignment
 * that is a restoration of the state and handles that internally.
 * e.g.
 *      &random := 42  # putSeed will be called
 *      x := &random   # copy the state
 *        ...
 *      &random := x   # putSeed will not be called, the state will be
 *                     # restored to what it was when x was assigned.
 *
 * type   contains one of the values that was specified in the assignment
 *        of props->typeFlags in the startRng function.
 * size   contains the number of bytes supplied.
 *                  Note bytes, not bits (i.e. different to startRng).
 * param  points to the value of the specified type ...
 *    T_String      pointer to the first character in the string.
 *                  Note that string parameters are NOT null terminated.
 *    T_Integer     pointer to the word value.
 *    T_Real        pointer to the double value.
 *    T_Intarray    pointer to the first (word) element of the array.
 *    T_Realarray   pointer to the first (double) element of the array.
 *
 *    other         pointer to the descriptor. In this case the size parameter
 *                  will be zero (all the information needed is in the descriptor).
 *                  Familiarity with the implementation book is essential.
 *
 * If no assignment to &random has been made after the library has been loaded
 * and the random operator is used, putSeed will be called with nil values.
 * i.e. putSeed(T_Null, 0, NULL)
 */
int putSeed(word type, word size, void *param)
{
  crlx_state_ptr sp;
  uint64_t seed;
  if (type == T_Null || param == NULL) {
    /* No seed has been supplied before a use of the random operator:
     * call the runtime to supply some random seed data.
     * getInitialBits may be called more than once, but there is no guarantee
     * that it will return a different value on subsequent calls.
     */
    sp = (crlx_state_ptr)runtime.getRngState(); /* get the location of generator's state */
    seed = runtime.getInitialBits();            /* get some random bits */

    SetSeed(sp, seed);          /* initialize the state */
    return 0;                   /*  return success */
  }

  /* Check the supplied parameters.
   * None of these failures should ever happen (unless there is a bug in the runtime)
   */
  if ((type != T_Integer) && (type != T_String)) {
    runtime.putErrorCode(700);  /* Unexpected type */
    return -1;                  /* The assignment to &random will fail */
  }

  if (param == NULL) {
    runtime.putErrorCode(702);  /* Bad seed */
    return -1;
  }

  sp = (crlx_state_ptr)runtime.getRngState(); /* get the location of generator's state */
  if (type == T_String) {/* We need a hexadecimal string that is up to 64 bits long  */
    int n, nib1, nib2;
    unsigned char *p = (unsigned char *)param;

    if ((size == 0) || (size > 16) || (0 != (size & 1)) ) {
      runtime.putErrorCode(701); /* Wrong size */
      return -1;
    }

    seed = 0;
    /* Convert the hex string to binary */
    for (n=0; n < size/2; ++n) {
      if ((0 > (nib1 = hex(*p++))) || (0 > (nib2 = hex(*p++)))) {
        runtime.putErrorCode(702); /* Not Hex */
        return -1;
      }
      seed <<=8;
      seed |= (nib1 << 4) | nib2;
    }
    SetSeed(sp, seed);
  } else { /* type = T_Integer */
    SetSeed(sp, (uint64_t)(*(word *)param));
  }

  return 0;                     /* success */
}

/*-------------------------------------------------------------------------------*/
/* This routine is called by the runtime when the random operator is invoked.
 * It is expected to return a floating point number in the range [0.0,1.0).
 * Note the interval is half closed (i.e. 1.0 is not allowed).
 */
double getRandomFpt(void)
{
  crlx_state_ptr sp = (crlx_state_ptr)runtime.getRngState();
  return Rndm(sp);
}

/*-------------------------------------------------------------------------------*/
/* This routine is called by the runtime when the standard function rngval is called.
 * It is expected to return an integer.
 */
word getRandomInt(void)
{
  crlx_state_ptr sp = (crlx_state_ptr)runtime.getRngState();
  return IntRndm(sp);
}

/*-------------------------------------------------------------------------------*/
/* This routine is called by the runtime when either of the standard functions
 * rngbitstring() or rngbits() is called.
 * If a buffer is supplied, it is expected to return a bit vector of the required size,
 * although it is also allowed to fail. A null buffer means advance the generator
 * without supplying any bits
 *
 * It is not expected that any bits left over are retained for the next output
 * i.e. it is almost certainly true that
 *      rngbitstring(n) || rngbitstring(n) ~== rngbitstring(n*2)
 * The number of bits may exceed the "natural size". If so, the routine is expected
 * to concatenate several random values together (or fail).
 *
 * In the case of the Ranlux++ generator, the natural size is 48 bits, leading to
 * a requirement to concatenate a sequence of 48 bit generated values together.
 *
 * This getRandomBits procedure assumes that the supplied buffer is an array of uint64_t
 * and is large enough to contain the asked for number of bits. It always writes
 * uint64_t values; sometimes more bits are written than asked for but never more than
 * the size of the buffer:
 * For example, if between 1 and 48 bits are asked for, 1 uint64_t value will be written
 *    containing one 48 bit random deviate.
 *    If between 49 and 64 bits are asked for, 1 uint64_t value will be written containing
 *    the whole of the first deviate(48 bits) and the ms 16 bits of the second deviate.
 *    If 65 bits are asked for, 2 uint64_t values will be written, the first the same as above,
 *    the second containing the ls 32 bits of the second deviate.
 *    Thus the bit vector advances 48 bits at a time, but truncated at the appropriate
 *    64 bit boundary after the specified number of bits.
 *
 *    nBits      bytes containing values
 *    0          0
 *    1 -  48    6       1 random deviate
 *    49 - 64    8       2 random deviates
 *    65 - 96    12      2 random deviates
 *    97 - 128   16      3 random deviates
 *    129 - 144  18      3 random deviates
 *    145 - 192  24      4 random deviates
 *                 etc.
 */

int getRandomBits(int nBits, void *buffer)
 {
   crlx_state_ptr sp = (crlx_state_ptr)runtime.getRngState();
   if (buffer == NULL) { /* Advance the generator without supplying any bits */
     Skip(sp, (nBits + 47)/48);
     return 0;
   } else { /* Populate the buffer with 48 bit values, but writing 64 bits at a time */
     int top = 64, bytes = 0, bits = nBits;
     uint64_t rval, oval = 0;   /* incoming and outgoing values */
     uint64_t *out = (uint64_t *)buffer;

     while (bits > 0) {
       rval = IntRndm(sp) & 0xFFFFFFFFFFFF;   /* 48 bits of lovely randomness */
       bits -= 48;

       /* top keeps track of where the ms bit of the random value should go.
        * If its a new uint64, top = 64; after one 48 bit deviate, top = 16 etc..
        * For every four (48 bit) random values, we write three 64 bit values.
        */
       switch (top) {
       case 64:
         oval = rval << 16;                   /* Fill highest 48 bits */
         top = 16;
         break;

       case 16:
         oval |= ((rval >> 32) & 0xFFFF);     /* Fill lowest 16 bits */
         *out++ = oval; bytes += 8;           /* Write */
         oval = rval << 32;                   /* Fill highest 32 bits */
         top = 32;
         break;

       case 32:
         oval |= ((rval >> 16) & 0xFFFFFFFF); /* Fill lowest 32 bits */
         *out++ = oval; bytes += 8;           /* Write */
         oval = rval << 48;                   /* Fill highest 16 bits */
         top = 48;
         break;

       case 48:
         oval |= rval;                        /* Fill lowest 48 bits */
         *out++ = oval; bytes += 8;           /* Write */
         oval = 0;                            /* No bits stored */
         top = 64;
         break;
       }
     } /* while bits > 0 */

     if (bytes*8 < nBits) {
       /* Final assignment: assume there is enough space for one more uint64.
        *
        * We could perhaps do better (by writing fewer random bits if we have
        * more bits than needed). But there is space in the buffer, so why spend
        * extra cpu cycles trimming the output to the exact number of bits?
        * The caller should only rely on the contents up to the number of bits
        * requested; the rest is undefined.
        */
       if (top != 64) {
         *out = oval;
         switch (top) {
         case 16: return bytes + 6;
         case 32: return bytes + 4;
         case 48: return bytes + 2;
         }
       } else {
         *out = (IntRndm(sp) & 0xFFFFFFFFFFFF) << 16;
         return bytes+6;
       }
     }
     return bytes;
   }
 }

