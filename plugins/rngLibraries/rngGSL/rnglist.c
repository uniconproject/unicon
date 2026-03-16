/*--------------------------------------------------------------------------------
 *
 * This file is released under the terms of the GNU LIBRARY GENERAL PUBLIC LICENSE
 * (LGPL) version 2. The licence may be found in the root directory of the Unicon
 * source directory in the file COPYING.
 *
 *--------------------------------------------------------------------------------
 *
 * This program may be used to list the GNU Scientific Library random number
 * generators that are available.  If the environment variable GSL_STATE_MAX is
 * present, generators whose state is larger than that will not be listed. The
 * default is 1024. If GSL_STATE_MAX = 0 all generators will be listed.
 *
 * The rngGSL generator uses the same environment variable to exclude GSL
 * generators with large states (0 means no generator is excluded).
 *
 * All generators are allocated a state which is large enough to fit any GSL
 * generator. So, if you know that your program never uses a generator whose
 * state is larger than 320 bytes, it may be worth setting GSL_STATE_MAX to 320
 * especially if the generator is used by several threads.
 *
 * The largest state in the present GSL library (version 2.7.1) is 128KB.
 *
 *--------------------------------------------------------------------------------
 *
 *    Don Ward
 *    March 2022
 *
 *--------------------------------------------------------------------------------
 */
#include <gsl/gsl_rng.h>
#include <string.h>


int main(int argc, char **argv) {
  const gsl_rng_type **t, **t0;
  unsigned long threshold;
  char *env_threshold, *default_rng, *default_seed;
  const char *largest_rng;
  int largest_state;
  int have_default_rng = 0;

   default_rng = getenv("GSL_RNG_TYPE");
   if ((default_rng != NULL) && (*default_rng != '\0')) {
     printf("Default generator is %s\n", default_rng);
     have_default_rng = 1;
   }
   default_seed = getenv("GSL_RNG_SEED");
   if ((default_seed != NULL) && (*default_seed != '\0')) {
     printf("Default seed is %s\n", default_seed);
   }
   env_threshold = getenv("GSL_STATE_MAX");
  if ((env_threshold == NULL) || (*env_threshold == '\0')) {
     threshold = 1024;
  } else {
    char *end;
     threshold = strtoul(env_threshold, &end, 0);
    if (*end != '\0') {
       threshold = 1024;
    }
  }

  if (threshold > 0) {
    printf ("Available generators: (size <= %lu)\n", threshold);
  } else {
    printf ("Available generators:\n");
  }

  largest_state = 0; largest_rng = "";
  printf("Generator                   Min    Max          State\n");
  t0 = gsl_rng_types_setup ();
  for (t = t0; *t != 0; t++) {
    if ((threshold == 0) || (*t)->size <= threshold) {
      char *mark = "";
      if (have_default_rng) {
        int len = strlen((*t)->name);
        if (0 == strncmp((*t)->name, default_rng, len)
            && (len = strlen(default_rng))) {
          mark = "   <----";
        }
      }
      printf ("%-20s  %8lu %-12lu %8lu%s\n",
              (*t)->name, (*t)->min, (*t)->max, (*t)->size, mark);

      if ((*t)->size > largest_state) {
        largest_state = (*t)->size;
        largest_rng = (*t)->name;
      }
    }
  }
   printf("Largest state = %d (%s)\n", largest_state, largest_rng);
}
