/*--------------------------------------------------------------------------------
 *
 * This file is released under the terms of the GNU LIBRARY GENERAL PUBLIC LICENSE
 * (LGPL) version 2. The licence may be found in the root directory of the Unicon
 * source directory in the file COPYING.
 *
 *--------------------------------------------------------------------------------
 *
 * This is a reimplementation of the built in (Icon) random number generator as
 * a dynamically loaded rng library.
 *
 *--------------------------------------------------------------------------------
 *
 *    Don Ward
 *    August 2019
 *
 *--------------------------------------------------------------------------------
 */

#include "../rngLib.h"

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
  props->stateBits = 32;
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
  props->typeFlags = RngTypeFlag(T_Integer);

  /*
   * Tell the runtime what the "natural size" of the random output is.
   * For example, if the generator algorithm naturally produces a block
   * of output, tell the runtime what the size of the block is.
   * NB. the block size is in bits, not bytes.
   */
  props->blockBits = 31;

  /* Store the routines that we can call */
  runtime = *rtapi;

  /*
   * If the generator reuires any "first time" set up (e.g. to build S-Boxes
   * or similar tables), here is the best place to call the setup routine.
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
  word *state, seed;
  if (type == T_Null || param == NULL) {
    /* No seed has been supplied before a use of the random operator:
     * call the runtime to supply some random seed data.
     * getInitialBits may be called more than once, but there is no guarantee
     * that it will return a different value on subsequent calls.
     */
    state = (word *)runtime.getRngState(); /* get the location of generator's state */
    seed = runtime.getInitialBits();       /* get some random bits */

    *state = seed;              /* initialize the state */
    return 0;                   /*  return success */
  }

  /* Check the supplied parameters.
   * None of these failures should ever happen (unless there is a bug in the runtime)
   * but the code demonstrates how to report a custom error.
   */
  if (type != T_Integer) {
    runtime.putErrorCode(700);  /* Unexpected type */
    return -1;                  /* The assignment to &random will fail */
  }

  /* The runtime will supply the whole word even if fewer bits have been specified */
  if (size > sizeof(word)) {
    runtime.putErrorCode(701);  /* Unexpected size */
    return -1;
  }

  if (param == NULL) {
    runtime.putErrorCode(702);  /* Bad seed */
    return -1;
  }

  /*
   * Store the supplied seed in the state variable.
   * getRngState must be called for each invocation of putSeed, in case the
   * garbage collector has moved the state to another location.
   *
   * We could just write
   *    *((word *)runtime.getRngState()) = *(word *)param;
   * but, for clarity, three assignments are made. It is to be hoped that
   * a decent compiler will optimise them to produce the same code.
   */
  state = (word *)runtime.getRngState();
  seed = *(word *)param;
  *state = seed;

  return 0;                     /* success */
}

/*-------------------------------------------------------------------------------*/
/* These values are copied from rmacros.h */
#define RandA        1103515245 /* random seed multiplier */
#define RandC         453816694 /* random seed additive constant */
#define RanScale 4.65661286e-10 /* random scale factor = 1/(2^31-1) */
/*
 * Accuracy demands that we point out that 4.65661286e-10 isn't 1/(2^31-1).
 * The actual double precision figure is   4.656612875245797e-10.
 *
 * The value chosen for RanScale is actually much cleverer than that: it is very
 * close to the largest value that will NOT return 1.0 when multiplied by 0x7FFFFFF
 * in single precision IEEE floating point arithmetic. I.e. it guarantees the range
 * of values returned is [0.0,1.0) rather than [0.0,1.0]
 *
 * On a 64 bit machine, with double precision arithmetic, we could do slightly better
 * and use a constant of 4.656612875245793e-10: it would make the spread of deviates
 * imperceptibly more uniform. But if we did that, the 32 bit and 64 bit generators
 * would no longer produce the same answers.
 */

/*-------------------------------------------------------------------------------*/
/* This routine is called by the runtime when the random operator is invoked.
 * It is expected to return a floating point number in the range [0.0,1.0).
 * Note the interval is half closed (i.e. 1.0 is not allowed).
 */
double getRandomFpt(void)
{
  word *state = (word *)runtime.getRngState();
  word seed = *state;
  double ans;

  *state=((RandA*seed+RandC)&0x7FFFFFFFL);
  ans = RanScale * (*state);

  return ans;
}

/*-------------------------------------------------------------------------------*/
/* This routine is called by the runtime when the standard function rngval is called.
 * It is expected to return an integer.
 */
word getRandomInt(void)
{
  word *state = (word *)runtime.getRngState();
  word seed = *state;

  *state=((RandA*seed+RandC)&0x7FFFFFFFL);
  return *state;
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
 * For most generator algorithms, it will be particularly efficient to ask for
 * random bits in integer multiples of the natural size.
 *
 * In the case of the IconEx generator, the natural size is 31 bits, leading to
 * a requirement to concatenate a sequence of 31 bit generated values together.
 * This example generator ducks the issue by refusing to supply more than 31 bits.
 */

int getRandomBits(int nBits, void *buffer)
{
  if (nBits > 31) {
    /* One day, when I'm feeling courageous, I may write the code that concatenates
     * a sequence of 31 bit values into a contiguous sequence of 32 bit values with
     * no gaps. Today is not that day.
     */
    return -1;                  /* Fail */
  } else {
    word *state = (word *)runtime.getRngState();
    word seed = *state;
    /* Should a new random value be generated, even if none of it is required?
     * It's possible to argue either way, but it seems better to consistently
     * generate a new value on every call, rather than have no bits as a special case.
     */
    *state=((RandA*seed+RandC)&0x7FFFFFFFL);
    /* Note that, in the usual case, it's quite hard for the user to ask for no bits
     * because the runtime interprets rngbits(0) as a request for the natural size.
     * nBits == 0 can only happen if the generator specifies 0 as its natural size.
     */
    if ((nBits == 0) | (buffer == NULL)) {
      return 0;                 /* supplying no bits is easy */
    } else {
      size_t bytes = (nBits + 7)/8;
      memcpy(buffer,state,bytes);
      return bytes;
    }
  }
}
