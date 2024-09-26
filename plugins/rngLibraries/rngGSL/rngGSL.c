/*--------------------------------------------------------------------------------
 *
 * This file is released under the terms of the GNU LIBRARY GENERAL PUBLIC LICENSE
 * (LGPL) version 2. The licence may be found in the root directory of the Unicon
 * source directory in the file COPYING.
 *
 *--------------------------------------------------------------------------------
 *
 * This makes the GNU Scientific Library generators available as a dynamically
 * loaded rng library.
 *
 *--------------------------------------------------------------------------------
 *
 *    Don Ward
 *    March 2022
 *
 *--------------------------------------------------------------------------------
 */

#include "../rngLib.h"
#include <gsl/gsl_rng.h>

struct rng_rt_api runtime;  /* A place to store the routines callable by the rng */
const gsl_rng_type **generators; /* The master list of GSL generators */
int gsl_state_max;               /* The maximum acceptable state size */

/*
 * This structure replicates the information created by the GSL routines
 * and allows a GSL generator to be stored on the Unicon heap
 */
typedef struct {
  gsl_rng rng;                  /* The rng parameter expected by most GSL routines */
  gsl_rng_type type;            /* The static info about a generator */
  word rng_state[1];            /* The generator's state (more than one word)  */
} gsl_generator;

/*-------------------------------------------------------------------------------*/
/* This routine is called once by the runtime when the library
 * is first loaded.
 */
int startRng(struct rngprops *props, struct rng_rt_api *rtapi)
{
  char *env_threshold;
  int largest_state;
  const gsl_rng_type **t;

  /* Establish the maximum size of the generator state we might need */

  env_threshold = getenv("GSL_STATE_MAX");
  if ((env_threshold == NULL) || (*env_threshold == '\0')) {
    gsl_state_max = 1024;
  } else {
    char *end;
    gsl_state_max = strtoul(env_threshold, &end, 0);
    if (*end != '\0') {
      gsl_state_max = 1024;
    }
  }

  /* Search through the list for generators under the threshold  */
  generators = gsl_rng_types_setup ();
  largest_state = 0;
  for (t = generators; *t != 0; t++) {
    if ((gsl_state_max == 0) || (*t)->size <= gsl_state_max) {
      if ((*t)->size > largest_state) {
        largest_state = (*t)->size;
      }
    }
  }
  
  /*
   * Tell the runtime how much state is needed.
   * NB. the state size is in bits, not bytes.
   */
  props->stateBits = 8 * (sizeof(gsl_generator) + largest_state);

  /*
   * Specify what types are acceptable as a parameter to putSeed
   * If more than one type is acceptable, or them together
   * eg RngTypeFlag(T_Integer) | RngTypeFlag(T_String)
   */
  props->typeFlags = RngTypeFlag(T_Integer) | RngTypeFlag(T_String) ;

  /*
   * Tell the runtime what the "natural size" of the random output is.
   * For example, if the generator algorithm naturally produces a block
   * of output, tell the runtime what the size of the block is.
   * NB. the block size is in bits, not bytes.
   */
  props->blockBits = 8 * sizeof(unsigned long int);

  /* Store the routines that we can call */
  runtime = *rtapi;

  /*
   * If the generator requires any "first time" set up (e.g. to build S-Boxes
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
    case 701: return "No GSL generator is loaded";
    case 702: return "GSL generator not found";
    case 703: return "GSL generator state is too large";
    case 704: return "Bad seed value";

    default:  return "??";      /* Not one of our errors */
    }
}

/*-------------------------------------------------------------------------------*/
/* This routine is called by the runtime when an assignment that is not
 * a restored state is made to &random. The runtime detects an assignment
 * that is a restoration of the state and handles that internally.
 *
 * If no assignment to &random has been made after the library has been loaded
 * and the random operator is used, putSeed will be called with nil values.
 * i.e. putSeed(T_Null, 0, NULL)
 */
int putSeed(word type, word size, void *param)
{
  gsl_generator *gss;

  if (type == T_Null || param == NULL) {
    /* No seed has been supplied before a use of the random operator:
     *
     * rngGSL requires two assignments to &random to initialise the generator.
     *   The first assignment is a string parameter that specifies the generator to use.
     *   The second assignment is an integer seed.
     * The runtime doesn't know this, so if we are called with the "No Seed" values,
     * try to use the environment variables specified by GSL
     */
    char *default_rng, *default_seed;
    int result;
    word seed;

    default_rng = getenv("GSL_RNG_TYPE");
    default_seed = getenv("GSL_RNG_SEED");
    if (   (default_rng  != NULL) && (*default_rng != '\0')
        && (default_seed != NULL) && (*default_seed != '\0')) {
      result = putSeed(T_String, strlen(default_rng), default_rng);
      if (0 == result) {
        char *end;
        seed = strtoul(default_seed, &end,0);
        if (*end == '\0') {
          return putSeed(T_Integer, sizeof(seed), &seed);
        } else {
          runtime.putErrorCode(704); /* Bad seed */
          return -1;
        }
      } else {
        return result;
      }
    }

    runtime.putErrorCode(701);  /* No generator loaded */
    return -1;                  /* The assignment to &random will fail */
  }

  /* Check the supplied parameters.
   * None of these failures should ever happen (unless there is a bug in the runtime)
   */
  if ((type != T_Integer) && (type != T_String)) {
    runtime.putErrorCode(700);  /* Unexpected type */
    return -1;                  /* The assignment to &random will fail */
  }

  if (type == T_String) { /* The string specifies the GSL generator to load */
    const gsl_rng_type **t;
    /* Search for the generator in the master list */
    for (t = generators; *t != 0; t++) {
      if ((0 == strncmp((char *)param, (*t)->name, size))
          && (size == strlen((*t)->name))) { /* Name matches */
        if ((gsl_state_max == 0) || ((*t)->size <= gsl_state_max)) {
          gsl_rng *gen = gsl_rng_alloc(*t); /* Load the new generator */
          /* Make a copy of the new generator */
          gss = (gsl_generator *)runtime.getRngState();
          if (gss != NULL) {
            gss->type = *(gen->type);
            gss->rng.type = &(gss->type);
            gss->rng.state = &(gss->rng_state[0]);
            memcpy(&(gss->rng_state[0]),
                   gsl_rng_state(gen),
                   gsl_rng_size(gen));
            gsl_rng_free(gen);          /* Give the allocated memory back */
            return 0;                   /* Success */
          } else {
            runtime.putErrorCode(705); /* No generator loaded */
            return -1;
          }
        } else {
          runtime.putErrorCode(703); /* State too large */
          return -1;                 /* fail */
        }
      }
    }
    /* If we get here, the generator wasn't found */
    runtime.putErrorCode(702);
    return -1;
  }

  /* if type isn't a string, it must be an integer to seed the generator */
  gss = (gsl_generator *)runtime.getRngState();
  if ((gss != NULL) && (gss->type.set != NULL)) {
    gsl_rng_set(&gss->rng, *(unsigned long int *)param);
  } else {
    runtime.putErrorCode(701); /* No generator loaded */
    return -1;
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
  gsl_generator *gss = (gsl_generator *)runtime.getRngState();
  return gsl_rng_uniform(&gss->rng);
}

/*-------------------------------------------------------------------------------*/
/* This routine is called by the runtime when the standard function rngval is called.
 * It is expected to return an integer.
 */
word getRandomInt(void)
{
  gsl_generator *gss = (gsl_generator *)runtime.getRngState();
  return gsl_rng_get(&gss->rng);
}

/*-------------------------------------------------------------------------------*/
/* The getRandomBits routine is called by the runtime when either of the standard
 * functions rngbitstring() or rngbits() is called.
 * If a buffer is supplied, it is expected to return a bit vector of the required size,
 * although it is also allowed to fail. A null buffer means advance the generator
 * without supplying any bits
 *
 * Due to the widely varying bit widths of the generators in the GSL, this optional
 * routine is not implemented.
 */

/* int getRandomBits(int nBits, void *buffer) {} */

