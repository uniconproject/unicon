/*--------------------------------------------------------------------------------
 *
 * This file is released under the terms of the GNU LIBRARY GENERAL PUBLIC LICENSE
 * (LGPL) version 2. The licence may be found in the root directory of the Unicon
 * source directory in the file COPYING.
 *
 * It uses source code that is copyrighted by the IETF trust.
 * See the file ./RFC6234/sha.h for the conditions governing the redistribution
 * and use of that code.
 *
 * Note that the original RFC6234 source code has been modified to be
 * thread-safe. The original code may be used by compiling it with the
 * ORIGINAL_SHA_CODE_NOT_THREAD_SAFE symbol defined.
 *
 *--------------------------------------------------------------------------------
 */

/*
 * Interface routines between Unicon and the RFC6234 Secure Hash functions
 *      Don Ward
 *      December 2016
 *
 *      March 2021      Add sha_RawResult
 *
 */

#include "../icall.h"
#include "./RFC6234/sha.h"

#undef SHA_TRACING

static enum SHAversion shaft = SHA512;           /* It stands for SHA function type */

/* -------------------------------------------------------------------------------- */
/* Interface to USHAReset(context, shaFunction)                                     */
/* Translates the unicon string shaFunction to the corresponding enum constant      */
/* and supplies a context to be initialised wrapped up in a T_External block.       */
RTEX int sha_Reset(int argc, descriptor argv[])
{
  struct b_external *eb;
  int ebSize;
  enum SHAversion f;

#ifdef SHA_TRACING
  fprintf(stderr, "sha_Reset\n");
  fflush(stderr);
#endif

  if (argc == 0) { /* No argument supplied; use the current Sha function */
    f = shaft;
  } else { /* get the supplied (string) parameter, which must be one of the known names */
    char *shaName;

    ArgString(1);
    shaName = StringVal(argv[1]);

    for (f = SHA1; f <= SHA512; ++f) {
      if (0 == strcmp(shaName, USHAHashName(f))) {
        goto init_context;
      }
    }
#ifdef SHA_TRACING
  fprintf(stderr, "sha_Reset FAILED\n");
  fflush(stderr);
#endif
    Fail;
  }

 init_context:
  ebSize = ExtHdrSize + sizeof(USHAContext); /* Add the Extern block header to what we need for the SHA context */
  mkExternal(eb = malloc(ebSize), ebSize);   /* Set up the extern block; N.B. might call FailCode() */

  if (shaSuccess == USHAReset((USHAContext *) &(eb->exdata[0]), f)) {
    RetExternal(eb);
  } else {
    free(eb);
#ifdef SHA_TRACING
  fprintf(stderr, "sha_Reset FAILED\n");
  fflush(stderr);
#endif
    Fail;
  }

}

/* -------------------------------------------------------------------------------- */
/* Interface to USHAInput(context, string)                                          */
RTEX int sha_Input(int argc, descriptor argv[])
{
  USHAContext *context;
#ifdef SHA_TRACING
  fprintf(stderr, "sha_Input\n");
  fflush(stderr);
#endif

  ArgExternal(1);               /* The SHA context */
  ArgString(2);                 /* The new string to add to the secure hash */

  context = (USHAContext *)ExternAddr(argv[1]);
  if (shaSuccess == USHAInput(context, (const uint8_t *)StringAddr(argv[2]), StringLen(argv[2]))) {
    Return;
  }

#ifdef SHA_TRACING
  fprintf(stderr, "sha_Input FAILED\n");
  fflush(stderr);
#endif
  Fail;
}

/* -------------------------------------------------------------------------------- */
/* Interface to USHAResult(context)                                                 */
/* returns the result as a string of hexadecimal characters                         */
RTEX int sha_Result(int argc, descriptor argv[])
{
  USHAContext *context;

#ifdef SHA_TRACING
  fprintf(stderr, "sha_Result\n");
  fflush(stderr);
#endif

  ArgExternal(1);               /* The SHA context */
  context = (USHAContext *)ExternAddr(argv[1]);

  do {
    int hashSize = USHAHashSize(context->whichSha); /* invalid params are safe (see below) */
    uint8_t digest[hashSize];

    if (shaSuccess == USHAResult(context, digest)) {
      int in, out, x;
      char result[ hashSize* 2];

      /* Convert the answer to hex chars. */
      for (in = 0, out = 0; in < hashSize; ++in) {
        x = digest[in] >> 4 & 0xF;
        result[out++] = (x > 9 ? 'A' + x -10 : '0' + x);
        x = digest[in] & 0xF;
        result[out++] = (x > 9 ? 'A' + x -10 : '0' + x);
      }

      /* Invalidate the context before releasing the storage.
       * If it gets passed in again, USHAResult() will fail which means we won't free stuff twice.
       * Note we will have called USHAHashSize(999) before that, but it is safe to do so.
       */
      context->whichSha = 999;
      free(BlkLoc(argv[1]));

      RetStringN(result, hashSize * 2); /* 2 hex chars per byte */
    }
  } while(0);

#ifdef SHA_TRACING
  fprintf(stderr, "sha_Result FAILED\n");
  fflush(stderr);
#endif
  Fail;
}

/* -------------------------------------------------------------------------------- */
/* Interface to USHAResult(context)                                                 */
/* returns the raw bits (as characters) rather than a hex string                    */
RTEX int sha_RawResult(int argc, descriptor argv[])
{
  USHAContext *context;

#ifdef SHA_TRACING
  fprintf(stderr, "sha_RawResult\n");
  fflush(stderr);
#endif

  ArgExternal(1);               /* The SHA context */
  context = (USHAContext *)ExternAddr(argv[1]);

  do {
    int hashSize = USHAHashSize(context->whichSha); /* invalid params are safe (see below) */
    uint8_t digest[hashSize];

    if (shaSuccess == USHAResult(context, digest)) {
      /* Invalidate the context before releasing the storage.
       * If it gets passed in again, USHAResult() will fail which means we won't free stuff twice.
       * Note we will have called USHAHashSize(999) before that, but it is safe to do so.
       */
      context->whichSha = 999;
      free(BlkLoc(argv[1]));

      RetStringN((char *)digest, hashSize);
    }
  } while(0);

#ifdef SHA_TRACING
  fprintf(stderr, "sha_RawResult FAILED\n");
  fflush(stderr);
#endif
  Fail;
}

/* -------------------------------------------------------------------------------- */
/* Interface to USHAFinalBits(context, bits, bit_count)                             */
RTEX int sha_FinalBits(int argc, descriptor argv[])
{
  USHAContext *context;
#ifdef SHA_TRACING
  fprintf(stderr, "sha_FinalBits\n");
  fflush(stderr);
#endif

  ArgExternal(1);               /* The SHA context */
  ArgString(2);                 /* The new (1 char) string to add to the secure hash */
  ArgInteger(3);                /* The final bits (1 -7) of the message */
  context = (USHAContext *)ExternAddr(argv[1]);

  if (shaSuccess == USHAFinalBits(context, *(const uint8_t *)StringAddr(argv[2]), IntegerVal(argv[3]))) {
    Return;
  }

#ifdef SHA_TRACING
  fprintf(stderr, "sha_FinalBits FAILED\n");
  fflush(stderr);
#endif

  Fail;
}

/* --------------------------------------------------------------------------------
 * Set/Get SHA algorithm in use.
 *
 * No params: returns one of "SHA1", "SHA224", "SHA256", "SHA384", "SHA512"
 * If a parameter is supplied it sets the algorithm to one of the above.
 */
RTEX int ShaFunction(int argc, descriptor argv[])
{
#ifdef SHA_TRACING
  fprintf(stderr, "ShaFunction\n");
  fflush(stderr);
#endif

  if (argc == 0) { /* No argument supplied; return the Sha function in use */
    RetString((char *)USHAHashName(shaft));  /* (char *) is to stop clang moaning about discarding const */
  } else { /* Set the default SHA function to the supplied argument ... if it's legal. */
    char *shaName;
    enum SHAversion f;

    ArgString(1);
    shaName = StringVal(argv[1]); /* This is the sha function we want to set */

    for (f = SHA1; f <= SHA512; ++f) {
      if (0 == strcmp(shaName, USHAHashName(f))) { /* it matches */
        shaft = f;
        Return;
      }
    }

#ifdef SHA_TRACING
  fprintf(stderr, "ShaFunction FAILED\n");
  fflush(stderr);
#endif

    Fail;
  }
}
