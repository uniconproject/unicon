/* gdbmsync.c - Sync the disk with the in memory state. */

/* This file is part of GDBM, the GNU data base manager.
   Copyright (C) 1990-2025 Free Software Foundation, Inc.

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

#ifdef GDBM_FAILURE_ATOMIC

#include <fcntl.h>
#include <inttypes.h>
#include <limits.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/ioctl.h>
#include <linux/fs.h>

/* Sometimes, to ensure durability, a new file *and* all directories
   on its full path must be fsync()'d up to the root directory.  */
static int
fsync_to_root (const char *f)
{
  int flags = O_WRONLY;
  char path[PATH_MAX], *end;
  
  if (realpath (f, path) == NULL)
    return GDBM_ERR_REALPATH;
  end = path + strlen(path);
  while (path < end)
    {
      int fd;

      *end = 0;
      fd = open (path, flags);
      flags = O_RDONLY;
      if (fd == -1)
	return GDBM_FILE_OPEN_ERROR;
      if (fsync (fd))
	{
	  int ec = errno;
	  close (fd);
	  errno = ec;
	  return GDBM_FILE_SYNC_ERROR;
	}
      if (close (fd))
	return GDBM_FILE_CLOSE_ERROR;

      do
	--end;
      while (path < end && end[-1] != '/');
    }
  return GDBM_NO_ERROR;
}

/* Note:  Valgrind complains about ioctl() call below, but it appears
   that Valgrind is simply confused; it issues similar complaints
   about very simple and correct uses of ioctl(FICLONE). */
int
_gdbm_snapshot (GDBM_FILE dbf)
{
  int s;	     /* snapshot file descriptor */
  int oldsnap;       /* previous snapshot file descriptor */
  
  if (dbf->snapfd[0] < 0)
    /* crash consistency hasn't been requested on this database */
    return 0;

  if (!(dbf->eo == 0 || dbf->eo == 1))
    {
      /* Shouldn't happen, but still... */
      _gdbmsync_done (dbf);
      _gdbmsync_init (dbf);
      GDBM_SET_ERRNO (dbf, GDBM_ERR_USAGE, TRUE);
      return -1;      
    }
  
  s = dbf->snapfd[dbf->eo];
  dbf->eo = !dbf->eo;
  oldsnap = dbf->snapfd[dbf->eo];
  
  /* says "DON'T recover from this snapshot, writing in progress " */
  if (fchmod (s, S_IWUSR)) 
    {
      GDBM_SET_ERRNO (dbf, GDBM_ERR_FILE_MODE, FALSE);
      return -1;
    }

  /* commit permission bits */
  if (fsync (s))
    {
      GDBM_SET_ERRNO (dbf, GDBM_FILE_SYNC_ERROR, FALSE);
      return -1;
    }

  /* make efficient reflink copy into snapshot file, overwrite previous
     contents */
  if (ioctl (s, FICLONE, dbf->desc) == -1)
    {
      if (errno == EINVAL || errno == ENOSYS)
	{
	  _gdbmsync_done (dbf);
	  _gdbmsync_init (dbf);
	}
      GDBM_SET_ERRNO (dbf, GDBM_ERR_SNAPSHOT_CLONE, FALSE);
      return -1;
    }

  /* commit snapshot data */
  if (fsync (s))
    {
      GDBM_SET_ERRNO (dbf, GDBM_FILE_SYNC_ERROR, FALSE);
      return -1;
    }

  /* says "DO recover from this snapshot, writing completed successfully" */
  if (fchmod (s, S_IRUSR))
    {    
      GDBM_SET_ERRNO (dbf, GDBM_ERR_FILE_MODE, FALSE);
      return -1;
    }

  /* commit permission bits again */
  if (fsync (s))
    {
      GDBM_SET_ERRNO (dbf, GDBM_FILE_SYNC_ERROR, FALSE);
      return -1;
    }

  /*
   * Mark the previous snapshot file write-only, indicating thereby
   * that it contains obsolete data.  The point of this additional
   * operation is to reduce the time window during which a crash would
   * leave two readable snapshot files.  
   */
  if (fchmod (oldsnap, S_IWUSR))
    {
      GDBM_SET_ERRNO (dbf, GDBM_ERR_FILE_MODE, FALSE);
      return -1;
    }

  /* commit permission bits */
  if (fsync (oldsnap))
    {
      GDBM_SET_ERRNO (dbf, GDBM_FILE_SYNC_ERROR, FALSE);
      return -1;
    }
  
  return 0;
}

/* Snapshot files even & odd must not exist already. */
int
gdbm_failure_atomic (GDBM_FILE dbf, const char *even, const char *odd)
{
  int r;
  
  /* Return immediately if the database needs recovery */
  GDBM_ASSERT_CONSISTENCY (dbf, -1);

  if (!even || !odd || strcmp (even, odd) == 0)
    {
      errno = EINVAL;
      GDBM_SET_ERRNO (dbf, GDBM_ERR_USAGE, FALSE);
      return -1;
    }
  
  if (dbf->snapfd[0] != -1)
    {
      /*
       * This function has been called before for this dbf: reinitialize
       * the snapshot system.
       */
      _gdbmsync_done (dbf);
      _gdbmsync_init (dbf);
    }

  dbf->snapfd[0] = open (even, O_WRONLY | O_CREAT | O_EXCL, S_IWUSR);
  if (dbf->snapfd[0] == -1) 
    GDBM_SET_ERRNO (dbf, GDBM_FILE_OPEN_ERROR, FALSE);
  else
    {
      dbf->snapfd[1] = open (odd, O_WRONLY | O_CREAT | O_EXCL, S_IWUSR);
      if (dbf->snapfd[1] == -1)
	GDBM_SET_ERRNO (dbf, GDBM_FILE_OPEN_ERROR, FALSE);
      else if ((r = fsync_to_root (even)) != 0 ||
	       (r = fsync_to_root (odd)) != 0)
	{
	  GDBM_SET_ERRNO (dbf, r, FALSE);
	}
      else
	{
	  dbf->eo = 0;
	  if (_gdbm_snapshot (dbf) == 0)
	    return 0;
	}
    }

  _gdbmsync_done (dbf);
  _gdbmsync_init (dbf);

  return -1;
}

static inline int
timespec_cmp (struct stat const *a, struct stat const *b)
{
#if HAVE_STRUCT_STAT_ST_MTIM
  if (a->st_mtim.tv_sec < b->st_mtim.tv_sec)
    return -1;
  if (a->st_mtim.tv_sec > b->st_mtim.tv_sec)
    return 1;
  if (a->st_mtim.tv_nsec < b->st_mtim.tv_nsec)
    return -1;
  if (a->st_mtim.tv_nsec > b->st_mtim.tv_nsec)
    return 1;
#else
  if (a->st_mtime < b->st_mtime)
    return -1;
  if (a->st_mtime > b->st_mtime)
    return 1;
#endif  
  return 0;
}

static int
check_snapshot_mode (int mode)
{
  if (!S_ISREG (mode))	/* file is not a regular file */
    return -1;
  if (S_IXUSR & mode)	/* file is executable */
    return -1;
  if (S_IRUSR & mode)
    {
      if (S_IWUSR & mode)
	return -1;	/* file is both readable and writable */
    }
  else if (!(S_IWUSR & mode))
    return -1;		/* file is neither readable nor writable */
  /* All OK */
  return 0;
}

static int
stat_snapshot (const char *f, struct stat *st)
{
  if (stat (f, st))
    return -1;
  if (check_snapshot_mode (st->st_mode))
    {
      errno = EACCES;
      return -1;
    }
  return 0;
}

static int
gdbm_numsync (const char *dbname, unsigned *numsync)
{
  GDBM_FILE dbf;
  int rc = -1;
  
  dbf = gdbm_open (dbname, 0, GDBM_READER, S_IRUSR, NULL);
  if (dbf)
    {
      if (dbf->xheader)
	{
	  *numsync = dbf->xheader->numsync;
	  rc = 0;
	}
      gdbm_close (dbf);
    }
  return rc;
}

/*
 * Return:
 *   0  both numsyncs equal or result undefined
 *  -1  a's numsync is one less than b's
 *  -2  a's numsync is less than b's
 *  +1  a's numsync is one greater than b's
 *  +2  a's numsync is greater than b's
 *
 * Takes into account integer overflow. 
 */
 
static int
gdbm_numsync_cmp (const char *a, const char *b)
{
  unsigned na, nb;

  if (gdbm_numsync (a, &na) == 0 &&
      gdbm_numsync (b, &nb) == 0)
    {
      if (na == UINT_MAX && nb == 0)
	return -1;
      else if (na == 0 && nb == UINT_MAX)
	return 1;
      else if (na < nb)
	return na + 1 == nb ? -1 : -2;
      else if (na > nb)
	return na == nb + 1 ? 1 : 2;
    }
  return 0;
}

/*
 * Selects among the two given snapshot files the one to be used for
 * post-crash recovery.
 * Returns one of the GDBM_SNAPSHOT_* constants (see gdbm.h).
 * If GDBM_SNAPSHOT_OK is returned a pointer to the most recent snapshot
 * name is stored in *ret.  Otherwise, *ret is untouched.
 */
int
gdbm_latest_snapshot (const char *even, const char *odd, const char **ret)
{
  struct stat st_even, st_odd;
  
  if (!ret || !even || !odd || strcmp (even, odd) == 0)
    {
      errno = EINVAL;
      return GDBM_SNAPSHOT_ERR;
    }

  if (stat_snapshot (even, &st_even))
    return GDBM_SNAPSHOT_ERR;
  if (stat_snapshot (odd, &st_odd))
    return GDBM_SNAPSHOT_ERR;

  if (st_even.st_mode & S_IRUSR)
    {
      int rc = GDBM_SNAPSHOT_OK;
      
      if (!(st_odd.st_mode & S_IRUSR))
	{
	  *ret = even;
	  return GDBM_SNAPSHOT_OK;
	}

      /* Both readable: compare numsync value in the extended header.
       * Select the snapshot with greater numsync value.
       */
      switch (gdbm_numsync_cmp (even, odd))
	{
	case -1:
	  *ret = odd;
	  break;

	case -2:
	  rc = GDBM_SNAPSHOT_SUSPICIOUS;
	  break;
	  
	case 1:
	  *ret = even;
	  break;

	case 2:
	  rc = GDBM_SNAPSHOT_SUSPICIOUS;
	  break;
	  
	default:
	  /*
	   * Both readable: check mtime.
	   * Select the newer snapshot, i.e. the one whose mtime
	   * is greater than the other's
	   */
	  switch (timespec_cmp (&st_even, &st_odd))
	    {
	    case -1:
	      *ret = odd;
	      break;
	      
	    case 1:
	      *ret = even;
	      break;
	      
	    case 0:
	      /* Shouldn't happen */
	      rc = GDBM_SNAPSHOT_SAME;
	    }
	}
      return rc;
    }
  else if (st_odd.st_mode & S_IRUSR)
    {
      *ret = odd;
      return GDBM_SNAPSHOT_OK;
    }
  else
    {      
      /* neither readable: this means the crash occurred during
	 gdbm_failure_atomic() */
    }

  return GDBM_SNAPSHOT_BAD;
}
#else
int
gdbm_failure_atomic (GDBM_FILE dbf, const char *even, const char *odd)
{
	errno = ENOSYS;
	GDBM_SET_ERRNO (dbf, GDBM_ERR_USAGE, FALSE);
	return -1;
}

int
gdbm_latest_snapshot (const char *even, const char *odd, const char **ret)
{
	errno = ENOSYS;
	return GDBM_SNAPSHOT_ERR;
}
#endif /* GDBM_FAILURE_ATOMIC */

int
gdbm_file_sync (GDBM_FILE dbf)
{
  int r = 0;  /* return value */
#if HAVE_MMAP
  r = _gdbm_mapped_sync (dbf);
#elif HAVE_FSYNC
  if (fsync (dbf->desc))
    {
      GDBM_SET_ERRNO (dbf, GDBM_FILE_SYNC_ERROR, TRUE);
      r = 1;
    }
#else
  sync ();
  sync ();
#endif
#ifdef GDBM_FAILURE_ATOMIC
  /* If and only if the conventional fsync/msync/sync succeeds,
     attempt to clone the data file. */
  if (r == 0)
    r = _gdbm_snapshot (dbf);
#endif /* GDBM_FAILURE_ATOMIC */
  return r;
}

/* Make sure the database is all on disk. */

int
gdbm_sync (GDBM_FILE dbf)
{
  /* Return immediately if the database needs recovery */
  GDBM_ASSERT_CONSISTENCY (dbf, -1);

  /* Initialize the gdbm_errno variable. */
  gdbm_set_errno (dbf, GDBM_NO_ERROR, FALSE);

  if (dbf->xheader)
    {
      dbf->xheader->numsync++;
      dbf->header_changed = TRUE;
    }
  
  _gdbm_end_update (dbf);
  
  /* Do the sync on the file. */
  return gdbm_file_sync (dbf);
}
