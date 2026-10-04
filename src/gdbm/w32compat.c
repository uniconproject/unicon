/*
 * w32compat.c -- Windows replacements for the GDBM pieces that need POSIX.
 * See w32compat.h.  Only built on Windows (see Makefile).
 */

#include "autoconf.h"

#include <stdarg.h>
#include <string.h>
#include <windows.h>

#include "gdbmdefs.h"

#undef open

int
gdbm_w32_open (const char *name, int flags, ...)
{
  int mode = 0;

  if (flags & O_CREAT)
    {
      va_list ap;
      va_start (ap, flags);
      mode = va_arg (ap, int);
      va_end (ap);
    }
  if (strcmp (name, "/dev/null") == 0)
    name = "NUL";
  return _open (name, flags | O_BINARY, mode);
}

long
gdbm_w32_sysconf (int name)
{
  SYSTEM_INFO si;

  if (name != _SC_PAGESIZE)
    {
      errno = EINVAL;
      return -1;
    }
  GetSystemInfo (&si);
  return (long) si.dwPageSize;
}

/*
 * Replacements for lock.c, which relies on flock/lockf/fcntl locks and
 * POSIX signals and timers.  Windows offers none of those, so these
 * succeed without locking.  dbm_open locks by default and reaches
 * these unless the caller passes DBM_NOLOCK.
 */

int
_gdbm_lock_file (GDBM_FILE dbf, int nb)
{
  (void) nb;
  dbf->lock_type = LOCKING_NONE;
  return 0;
}

void
_gdbm_unlock_file (GDBM_FILE dbf)
{
  dbf->lock_type = LOCKING_NONE;
}

int
_gdbm_lock_file_wait (GDBM_FILE dbf, struct gdbm_open_spec const *op)
{
  (void) op;
  return _gdbm_lock_file (dbf, 1);
}
