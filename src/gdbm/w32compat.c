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
 * Replacements for lock.c, which relies on flock/lockf/fcntl and POSIX
 * signals and timers.  These implement the same contract with
 * LockFileEx: readers take a shared lock and writers an exclusive one,
 * and a nonblocking attempt fails at once if another
 * handle holds a conflicting lock.  udbm.c clears GDBM_NOLOCK unless
 * the open asked for lock=no, so these are reached by default.
 *
 * Windows byte-range locks are mandatory for the bytes they cover, while
 * flock is advisory.  So that a lock only excludes other GDBM opens, as
 * on POSIX, and never blocks plain reads (a lock=no open, a backup tool),
 * lock one sentinel byte far beyond any real file size instead of the
 * file's data.  Every GDBM open locks that same byte.
 */

#define W32_LOCK_OFFSET_HIGH 0x40000000   /* offset 2^62 */
#define W32_LOCK_OFFSET_LOW  0

int
_gdbm_lock_file (GDBM_FILE dbf, int nb)
{
  HANDLE h = (HANDLE) _get_osfhandle (dbf->desc);
  OVERLAPPED ov;
  DWORD flags = 0;

  dbf->lock_type = LOCKING_NONE;
  if (h == INVALID_HANDLE_VALUE)
    {
      errno = EBADF;
      return -1;
    }
  if (dbf->read_write != GDBM_READER)
    flags |= LOCKFILE_EXCLUSIVE_LOCK;
  if (nb)
    flags |= LOCKFILE_FAIL_IMMEDIATELY;

  memset (&ov, 0, sizeof ov);
  ov.Offset = W32_LOCK_OFFSET_LOW;
  ov.OffsetHigh = W32_LOCK_OFFSET_HIGH;
  if (!LockFileEx (h, flags, 0, 1, 0, &ov))
    {
      errno = (GetLastError () == ERROR_LOCK_VIOLATION) ? EWOULDBLOCK : EACCES;
      return -1;
    }
  /* Any value but LOCKING_NONE marks the file locked; lock.c uses this. */
  dbf->lock_type = LOCKING_FLOCK;
  return 0;
}

void
_gdbm_unlock_file (GDBM_FILE dbf)
{
  HANDLE h;
  OVERLAPPED ov;

  if (dbf->lock_type == LOCKING_NONE)
    return;
  h = (HANDLE) _get_osfhandle (dbf->desc);
  if (h != INVALID_HANDLE_VALUE)
    {
      memset (&ov, 0, sizeof ov);
      ov.Offset = W32_LOCK_OFFSET_LOW;
      ov.OffsetHigh = W32_LOCK_OFFSET_HIGH;
      UnlockFileEx (h, 0, 1, 0, &ov);
    }
  dbf->lock_type = LOCKING_NONE;
}

static DWORD
w32_millis (struct timespec const *ts)
{
  return (DWORD) (ts->tv_sec * 1000 + ts->tv_nsec / 1000000);
}

/*
 * GDBM_LOCKWAIT_NONE tries once.  GDBM_LOCKWAIT_RETRY polls every
 * lock_interval until lock_timeout, as lock.c does.  There is no
 * SIGALRM here, so GDBM_LOCKWAIT_SIGNAL polls the same way (every 10 ms).
 */
int
_gdbm_lock_file_wait (GDBM_FILE dbf, struct gdbm_open_spec const *op)
{
  DWORD left, step;

  if (op->lock_wait == GDBM_LOCKWAIT_NONE)
    return _gdbm_lock_file (dbf, 1);
  if (op->lock_wait != GDBM_LOCKWAIT_RETRY
      && op->lock_wait != GDBM_LOCKWAIT_SIGNAL)
    {
      errno = EINVAL;
      return -1;
    }

  left = w32_millis (&op->lock_timeout);
  step = (op->lock_wait == GDBM_LOCKWAIT_RETRY)
           ? w32_millis (&op->lock_interval) : 10;
  if (step == 0)
    step = 1;
  for (;;)
    {
      if (_gdbm_lock_file (dbf, 1) == 0)
        return 0;
      if (left < step)
        return -1;
      Sleep (step);
      left -= step;
    }
}
