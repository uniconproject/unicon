/* lock.c - Implement basic file locking for GDBM. */

/* This file is part of GDBM, the GNU data base manager.
   Copyright (C) 2008-2025 Free Software Foundation, Inc.

   GDBM is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3, or (at your option)
   any later version.

   GDBM is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with GDBM. If not, see <http://www.gnu.org/licenses/>.   */

/* Include system configuration before all else. */
#include "autoconf.h"

#include "gdbmdefs.h"

#include <sys/time.h>
#include <signal.h>
#include <errno.h>

#if HAVE_FLOCK
# ifndef LOCK_SH
#  define LOCK_SH 1
# endif

# ifndef LOCK_EX
#  define LOCK_EX 2
# endif

# ifndef LOCK_NB
#  define LOCK_NB 4
# endif

# ifndef LOCK_UN
#  define LOCK_UN 8
# endif
#endif

#if defined(F_SETLK) && defined(F_RDLCK) && defined(F_WRLCK)
# define HAVE_FCNTL_LOCK 1
#else
# define HAVE_FCNTL_LOCK 0
#endif

/* Return values for try_lock_ functions: */
enum
  {
    TRY_LOCK_OK,    /* Locking succeeded */
    TRY_LOCK_FAIL,  /* File already locked by another process. */
    TRY_LOCK_NEXT   /* Another error (including locking mechanism not
		       available).  The caller should try next locking
		       mechanism. */

  };

/*
 * Locking using flock().
 */
static int
try_lock_flock (GDBM_FILE dbf, int nb)
{
#if HAVE_FLOCK
  if (flock (dbf->desc,
	     ((dbf->read_write == GDBM_READER) ? LOCK_SH : LOCK_EX)
	     | (nb ? LOCK_NB : 0)) == 0)
    {
      return TRY_LOCK_OK;
    }
  else if (errno == EWOULDBLOCK || errno == EINTR)
    {
      return TRY_LOCK_FAIL;
    }
#endif
  return TRY_LOCK_NEXT;
}

static void
unlock_flock (GDBM_FILE dbf)
{
#if HAVE_FLOCK
  flock (dbf->desc, LOCK_UN);
#endif
}

/*
 * Locking via lockf.
 */

static int
try_lock_lockf (GDBM_FILE dbf, int nb)
{
#if HAVE_LOCKF
  /*
   * NOTE: lockf will fail with EINVAL unless the database file was opened
   * with write-only permission (O_WRONLY) or with read/write permission
   * (O_RDWR).  This means that this locking mechanism will always fail for
   * databases opened with GDBM_READER,
   */
  if (dbf->read_write != GDBM_READER)
    {
      if (lockf (dbf->desc, nb ? F_TLOCK : F_LOCK, (off_t)0L) == 0)
	return TRY_LOCK_OK;

      switch (errno)
	{
	case EINTR:
	case EACCES:
	case EAGAIN:
	case EDEADLK:
	  return TRY_LOCK_FAIL;

	default:
	  /* try next locking method */
	  break;
	}
    }
#endif
  return TRY_LOCK_NEXT;
}

static void
unlock_lockf (GDBM_FILE dbf)
{
#if HAVE_LOCKF
  lockf (dbf->desc, F_ULOCK, (off_t)0L);
#endif
}

/*
 * Locking via fcntl().
 */

static int
try_lock_fcntl (GDBM_FILE dbf, int nb)
{
#if HAVE_FCNTL_LOCK
  struct flock fl;

  /* If we're still here, try fcntl. */
  if (dbf->read_write == GDBM_READER)
    fl.l_type = F_RDLCK;
  else
    fl.l_type = F_WRLCK;
  fl.l_whence = SEEK_SET;
  fl.l_start = fl.l_len = (off_t)0L;
  if (fcntl (dbf->desc, nb ? F_SETLK : F_SETLKW, &fl) == 0)
    return TRY_LOCK_OK;

  switch (errno)
    {
    case EINTR:
    case EACCES:
    case EAGAIN:
    case EDEADLK:
      return TRY_LOCK_FAIL;

    default:
      /* try next locking method */
      break;
    }

#endif
  return TRY_LOCK_NEXT;
}

static void
unlock_fcntl (GDBM_FILE dbf)
{
#if HAVE_FCNTL_LOCK
  struct flock fl;

  fl.l_type = F_UNLCK;
  fl.l_whence = SEEK_SET;
  fl.l_start = fl.l_len = (off_t)0L;
  fcntl (dbf->desc, F_SETLK, &fl);
#endif
}

/* Try each supported locking mechanism. */
int
_gdbm_lock_file (GDBM_FILE dbf, int nb)
{
  int res;
  static int (*try_lock_fn[]) (GDBM_FILE, int) = {
    [LOCKING_FLOCK] = try_lock_flock,
    [LOCKING_LOCKF] = try_lock_lockf,
    [LOCKING_FCNTL] = try_lock_fcntl
  };
  int i;

  dbf->lock_type = LOCKING_NONE;
  for (i = 1; i < sizeof (try_lock_fn) / sizeof (try_lock_fn[0]); i++)
    {
      if ((res = try_lock_fn[i] (dbf, nb)) == TRY_LOCK_OK)
	{
	  dbf->lock_type = LOCKING_FLOCK;
	  return 0;
	}
      else if (res != TRY_LOCK_NEXT)
	break;
    }
  return -1;
}

void
_gdbm_unlock_file (GDBM_FILE dbf)
{
  static void (*unlock_fn[]) (GDBM_FILE) = {
    [LOCKING_FLOCK] = unlock_flock,
    [LOCKING_LOCKF] = unlock_lockf,
    [LOCKING_FCNTL] = unlock_fcntl
  };

  if (dbf->lock_type != LOCKING_NONE)
    {
      unlock_fn[dbf->lock_type] (dbf);
      dbf->lock_type = LOCKING_NONE;
    }
}

enum { NANO = 1000000000L };

static inline void
timespec_sub (struct timespec *a, struct timespec const *b)
{
  a->tv_sec -= b->tv_sec;
  a->tv_nsec -= b->tv_nsec;
  if (a->tv_nsec < 0)
    {
      --a->tv_sec;
      a->tv_nsec += NANO;
    }
}

static inline void
timespec_add (struct timespec *a, struct timespec const *b)
{
  a->tv_sec += b->tv_sec;
  a->tv_nsec += b->tv_nsec;
  if (a->tv_nsec >= NANO)
    {
      a->tv_sec += a->tv_nsec / NANO;
      a->tv_nsec %= NANO;
    }
}

static inline int
timespec_cmp (struct timespec const *a, struct timespec const *b)
{
  if (a->tv_sec < b->tv_sec)
    return -1;
  if (a->tv_sec > b->tv_sec)
    return 1;
  if (a->tv_nsec < b->tv_nsec)
    return -1;
  if (a->tv_nsec > b->tv_nsec)
    return 1;
  return 0;
}

static int
_gdbm_lockwait_retry (GDBM_FILE dbf, struct timespec const *ts,
		      struct timespec const *iv)
{
  int ret;
  struct timespec ttw = *ts;
  struct timespec r;

  if (ts == NULL || (ts->tv_sec == 0 && ts->tv_nsec == 0))
    return _gdbm_lock_file (dbf, 1);

  for (;;)
    {
      ret = _gdbm_lock_file (dbf, 1);
      if (ret == 0)
	break;
      if (timespec_cmp (&ttw, iv) < 0)
	break;
      timespec_sub (&ttw, iv);
      if (nanosleep (iv, &r))
	{
	  if (errno == EINTR)
	    timespec_add (&ttw, &r);
	  else
	    break;
	}
    }
  return ret;
}

static void
signull (int sig)
{
  /* nothing */
}

static int
_gdbm_lockwait_signal (GDBM_FILE dbf, struct timespec const *ts)
{
  int ret = -1;
  int ec = 0;

  if (ts == NULL || (ts->tv_sec == 0 && ts->tv_nsec == 0))
    ret = _gdbm_lock_file (dbf, 1);
  else
    {
      struct sigaction act, oldact;
#if HAVE_TIMER_SETTIME
      struct itimerspec itv;
      timer_t timer;
#else
      struct itimerval itv, olditv;
#endif

      act.sa_handler = signull;
      sigemptyset (&act.sa_mask);
      act.sa_flags = 0;
      if (sigaction (SIGALRM, &act, &oldact))
	return -1;

#if HAVE_TIMER_SETTIME
      if (timer_create (CLOCK_REALTIME, NULL, &timer) == 0)
	{
	  itv.it_interval.tv_sec = 0;
	  itv.it_interval.tv_nsec = 0;
	  itv.it_value.tv_sec = ts->tv_sec;
	  itv.it_value.tv_nsec = ts->tv_nsec;

	  if (timer_settime (timer, 0, &itv, NULL) == 0)
	    ret = _gdbm_lock_file (dbf, 0);
	  ec = errno;

	  timer_delete (timer);
	}
      else
	ec = errno;
#else
      itv.it_interval.tv_sec = 0;
      itv.it_interval.tv_usec = 0;
      itv.it_value.tv_sec = ts->tv_sec;
      itv.it_value.tv_usec = ts->tv_nsec / 1000000;

      if (setitimer (ITIMER_REAL, &itv, &olditv) == 0)
	ret = _gdbm_lock_file (dbf, 0);
      ec = errno;

      /* Reset the timer */
      setitimer (ITIMER_REAL, &olditv, NULL);
#endif
      sigaction (SIGALRM, &oldact, NULL); //FIXME: error checking
    }
  if (ret != 0)
    errno = ec;
  return ret;
}

int
_gdbm_lock_file_wait (GDBM_FILE dbf, struct gdbm_open_spec const *op)
{
  switch (op->lock_wait)
    {
    case GDBM_LOCKWAIT_NONE:
      return _gdbm_lock_file (dbf, 1);

    case GDBM_LOCKWAIT_RETRY:
      return _gdbm_lockwait_retry (dbf, &op->lock_timeout, &op->lock_interval);

    case GDBM_LOCKWAIT_SIGNAL:
      return _gdbm_lockwait_signal (dbf, &op->lock_timeout);
    }
  errno = EINVAL;
  return -1;
}
