/*
 * udbm.c -- Unicon's NDBM open policy.
 *
 * src/gdbm/dbmopen.c is the upstream file and always passes GDBM_NOLOCK.
 * It is compiled with -Dgdbm_open=unicon_ndbm_gdbm_open, so this function
 * is what that call reaches. Upstream sources stay unmodified.
 *
 * lock=yes (the default) clears GDBM_NOLOCK. A timeout of 0, or no
 * timeout, waits until the lock is free, as a socket open does.
 * A positive timeout is milliseconds before the open fails.
 * lock=no leaves GDBM_NOLOCK set.
 */

#include "autoconf.h"
#include "gdbm.h"

#include <errno.h>

static GDBM_THREAD_LOCAL int want_lock = 1;
static GDBM_THREAD_LOCAL int timeout_ms = 0;

void
unicon_dbm_set_open (int lock, int timeout)
{
  want_lock = lock;
  timeout_ms = timeout;
}

static int
lock_conflict (void)
{
  return gdbm_errno == GDBM_CANT_BE_READER
         || gdbm_errno == GDBM_CANT_BE_WRITER;
}

GDBM_FILE
unicon_ndbm_gdbm_open (const char *file, int block_size, int flags, int mode,
		       void (*fatal_func) (const char *))
{
  struct gdbm_open_spec spec;
  GDBM_FILE dbf;
  int waited = 0;

  if (!want_lock)
    return gdbm_open (file, block_size, flags, mode, fatal_func);

  flags &= ~GDBM_NOLOCK;
  gdbm_open_spec_init (&spec);
  spec.mode = mode;
  spec.block_size = block_size;
  spec.fatal_func = fatal_func;
  spec.lock_wait = GDBM_LOCKWAIT_RETRY;

  for (;;)
    {
      int budget = (timeout_ms <= 0) ? 1000 : timeout_ms - waited;

      if (budget <= 0)
	return NULL;
      spec.lock_timeout.tv_sec = budget / 1000;
      spec.lock_timeout.tv_nsec = (long) (budget % 1000) * 1000000L;
      if (spec.lock_timeout.tv_sec == 0
	  && spec.lock_timeout.tv_nsec < 10000000L)
	spec.lock_interval.tv_nsec = spec.lock_timeout.tv_nsec
	  ? spec.lock_timeout.tv_nsec : 1000000L;
      else
	spec.lock_interval.tv_nsec = 10000000L; /* 10ms */

      dbf = gdbm_open_ext (file, flags, &spec);
      if (dbf || !lock_conflict ())
	return dbf;
      if (timeout_ms > 0)
	{
	  waited += budget;
	  if (waited >= timeout_ms)
	    return NULL;
	}
    }
}
