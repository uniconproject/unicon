/*--------------------------------------------------------------------------------
 *
 * This file is released under the terms of the GNU LIBRARY GENERAL PUBLIC LICENSE
 * (LGPL) version 2. The licence may be found in the root directory of the Unicon
 * source directory in the file COPYING.
 *
 *--------------------------------------------------------------------------------
 *
 * This is an implementation of the Rabbit random number generator as
 * a dynamically loaded rng library. The underlying code also does encryption,
 * but we only use the keystream as a source of random bits to generate
 * random numbers.
 *
 *--------------------------------------------------------------------------------
 *
 *    Don Ward
 *    August 2019
 *
 *--------------------------------------------------------------------------------
 */

#include "../rngLib.h"
#include "ecrypt-sync.h"

struct rng_rt_api runtime; /* A place to store the routines callable by the rng  */

RABBIT_ctx zero_ctx;       /* A zero context, useful for checking initialization */

/*-------------------------------------------------------------------------------*/
/* This routine is called once by the runtime when the library
 * is first loaded.
 */
int startRng(struct rngprops *props, struct rng_rt_api *rtapi)
{ /*
   * Tell the runtime how much state is needed.
   * NB. the state size is in bits, not bytes.
   */
  props->stateBits = 8 * sizeof(ECRYPT_ctx);

  /*
   * Specify what types are acceptable as a parameter to putSeed
   * If more than one type is acceptable, or them together.
   */
  props->typeFlags = RngTypeFlag(T_Integer)
    | RngTypeFlag(T_Intarray)
    | RngTypeFlag(T_String);
  /* ----------------------------------------------------------------------
   * Why are there three types specified for putSeed?
   *
   * T_Intarray is used to alter both key and IV (i.e. a full setup).
   * T_Integer is used to just alter the IV after a full set up.
   * T_String may be used as a Hexadecimal string to do a full setup or change the IV
   *     (The string value is portable between 32bit and 64bit systems).
   *
   * Allowing IV only means that putSeed() must detect whether a full setup has been done.
   *
   * For convenience, we "stretch" an integer value to a full key/IV so
   * that users can assign an integer to &random without bothering to
   * create an integer array. For random numbers this is probably good
   * enough.  But, for proper security, the full key/IV should be set to
   * unique values from a good source of entropy.
   * ----------------------------------------------------------------------
   *
   * Tell the runtime what the "natural size" of the random output is.
   * For example, if the generator algorithm naturally produces a block
   * of output, tell the runtime what the size of the block is.
   * NB. the block size is in bits, not bytes.
   */
  props->blockBits = 128;

  /* Store the routines that we can call */
  runtime = *rtapi;

  /*
   * The Rabbit generator does not need to do any "first time" setup.
   * If it did, we would call the setup routine here.
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
    case 703: return "Fewer than 192 bits in seed";

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
 */
int putSeed(word type, word size, void *param)
{
  ECRYPT_ctx *state;
  word seed;
  if (type == T_Null || param == NULL) {
    /* No seed has been supplied before a use of the random operator:
     * call the runtime to supply some random seed data.
     * getInitialBits may be called more than once, but there is no guarantee
     * that it will return a different value on subsequent calls.
     */
    state = (ECRYPT_ctx *)runtime.getRngState(); /* get the location of generator's state */
    seed = runtime.getInitialBits();       /* get some random bits */

    return putSeed(T_Integer, sizeof(seed), &seed);
  }

  /* Check the supplied parameters.
   * None of these failures should ever happen (unless there is a bug in the runtime)
   */
  if ((type != T_Integer) && (type != T_Intarray) && (type != T_String)) {
    runtime.putErrorCode(700);  /* Unexpected type */
    return -1;                  /* The assignment to &random will fail */
  }

  if (param == NULL) {
    runtime.putErrorCode(702);  /* Bad seed */
    return -1;
  }

  if (type == T_String) {
    /* We need a hexadecimal string that is either 192 bits (key + IV)
     * or 64 bits (IV only)
     */
    unsigned char keyIV[24];
    int n, nib1, nib2;
    unsigned char *p = (unsigned char *)param;

    if ((size != 16) && (size != 48)) {
      runtime.putErrorCode(701); /* Wrong size */
      return -1;
    }
    /* Convert the hex string to binary */
    for (n=0; n < size/2; ++n) {
      if ((0 > (nib1 = hex(*p++))) || (0 > (nib2 = hex(*p++)))) {
        runtime.putErrorCode(702); /* Not Hex */
        return -1;
      }
      keyIV[n] = (nib1 << 4) | nib2;
    }

    state = (ECRYPT_ctx *)runtime.getRngState(); /* get the location of generator's state */
    if (size == 48) { /* key and IV */
      ECRYPT_keysetup(state, keyIV, 16, 8);
      ECRYPT_ivsetup(state, keyIV + 16);
    } else { /* IV only */
      /* Check if the generator has been initialized before */
      if ((0 == memcmp(&zero_ctx, &state->master_ctx, sizeof(RABBIT_ctx))) &&
          (0 == memcmp(&zero_ctx, &state->work_ctx, sizeof(RABBIT_ctx)))) {
        /* Not initialized -- "stretch" the data to 192 bits */
        for (n=0; n < 8; ++n) {keyIV[n+8] = keyIV[n];}
        ECRYPT_keysetup(state, keyIV, 16, 8);
        ECRYPT_ivsetup(state, keyIV);
      } else {
        ECRYPT_ivsetup(state, keyIV);
      }
    }
    state->cached = 1.0;      /* Clear any stored value */
  } else if (type == T_Intarray) {
    /* We need a 128 bit key and a 64 bit IV.
     * Fail if there aren't enough bits in the supplied parameter.
     */
    if ((size * 8) < 128 + 64) {
      runtime.putErrorCode(703); /* Insufficient data */
      return -1;
    } else {
      /* Set up key and IV */
      state = (ECRYPT_ctx *)runtime.getRngState(); /* get the location of generator's state */
      /* This only sets up the key (it uses neither of the two size parameters) */
      ECRYPT_keysetup(state, param, 16, 8);
      /* Set up the IV */
      ECRYPT_ivsetup(state, (unsigned char *)param + 16);
      state->cached = 1.0;      /* Clear any stored value */
    }
  } else { /* type == T_Integer */
    state = (ECRYPT_ctx *)runtime.getRngState(); /* get the location of generator's state */

    /* Check if the generator has been initialized before */
    if ((0 == memcmp(&zero_ctx, &state->master_ctx, sizeof(RABBIT_ctx))) &&
        (0 == memcmp(&zero_ctx, &state->work_ctx, sizeof(RABBIT_ctx)))) {
     /* Not initialized */
      u64 keyIv[3];
      /* "stretch" the data to 192 bits. There are probably better ways to do this. */
      if (size == 4) { /* 32-bit system */
        keyIv[0] = keyIv[1] = keyIv[2] = *(u32 *)param;
      } else {
        keyIv[0] = keyIv[1] = keyIv[2] = *(u64 *)param;
      }
      return putSeed(T_Intarray, sizeof(keyIv), keyIv);
    } else {
      /* This is a reinitilization with an integer: just change the IV */
      u64 keyIv;
      if (size == 4) { /* 32-bit system */
        keyIv = *(u32 *)param;
      } else {
        keyIv = *(u64 *)param;
      }
      ECRYPT_ivsetup(state, (const u8 *) &keyIv);
      state->cached = 1.0;      /* Clear any stored value */
    }
  }

  return 0;                     /* success */
}

/*-------------------------------------------------------------------------------*/
#define RanScale 5.421010862427517e-20      /* Almost, but not quite, 1/(2^64-1) */

/* This routine is called by the runtime when the random operator is invoked.
 * It is expected to return a floating point number in the range [0.0,1.0).
 * Note the interval is half closed (i.e. 1.0 is not allowed).
 */
double getRandomFpt(void)
{
  ECRYPT_ctx *state =  (ECRYPT_ctx *)runtime.getRngState();

  /* Rabbit generates 2 double's worth of bits every call of ECRYPT_keystream_bytes()
   * so the second double is stored for the next time around.
   */
  if (state->cached < 1.0) { /* There is a number waiting to go */
    double ans = state->cached;
    state->cached = 1.0;        /* Clear the stored value */
    return ans;
  } else {
    u64 ans[2];
    /* Get a block's worth of random bits */
    ECRYPT_keystream_bytes(state, (u8 *)ans, sizeof(ans));
    state->cached = RanScale * ans[1]; /* Stash one away for later */
    return RanScale * ans[0];          /* and return one to the caller */
  }
}

/*-------------------------------------------------------------------------------*/
/* This routine is called by the runtime when either of the standard functions
 * rngbitstring() or rngbits() is called.
 * If a buffer is supplied, it is expected to return a bit vector of the required size,
 * although it is also allowed to fail. A null buffer means advance the generator
 * without supplying any bits
 *
 * It is not expected that any bits left over are retained for the next output
 */

int getRandomBits(int nBits, void *buffer)
{
  ECRYPT_ctx *state =  (ECRYPT_ctx *)runtime.getRngState();

  state->cached = 1.0;        /* Clear the stored value (if any) */
  if (buffer != NULL) {
    int bytes = (nBits + 7)/8;
    ECRYPT_keystream_bytes(state, buffer, bytes);
    return bytes;
  } else { /* Advance the generator only */
    if (nBits > 0 ) {
      skip_blocks(state, (nBits + 127)/128);
    }

    return 0;                   /* Success */
  }
}

/*-------------------------------------------------------------------------------*/
/* This routine is called by the runtime when the standard function rngval is called.
 * It is expected to return an integer.
 */
word getRandomInt(void)
{
  ECRYPT_ctx *state =  (ECRYPT_ctx *)runtime.getRngState();
  u64 ans[2];
  state->cached = 1.0;        /* Clear the stored value (if any) */
  /* Get a block's worth of random bits */
  ECRYPT_keystream_bytes(state, (u8 *)ans, sizeof(ans));
  return ans[0];              /* return a value (and throw one away) */
}
