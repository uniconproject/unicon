/* gdbmerrno.c - convert gdbm errors into English. */

/* This file is part of GDBM, the GNU data base manager.
   Copyright (C) 1993-2025 Free Software Foundation, Inc.

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

/* The dbm error number is placed in the variable GDBM_ERRNO. */
static GDBM_THREAD_LOCAL gdbm_error gdbm_errno_storage = GDBM_NO_ERROR;

int *
gdbm_errno_location (void)
{
  return &gdbm_errno_storage;
}

/* Store error code EC in the database structure DBF and in the
   global variable gdbm_error. 
*/
void
gdbm_set_errno (GDBM_FILE dbf, gdbm_error ec, int fatal)
{
  if (dbf)
    {
      free (dbf->last_errstr);
      dbf->last_errstr = NULL;
      
      dbf->last_error = ec;
      if (gdbm_syserr[ec])
	dbf->last_syserror = errno;
      else
	dbf->last_syserror = 0;
      dbf->need_recovery = fatal;
    }
  gdbm_errno = ec;
}

/* Retrieve last error code for the database DBF. */
gdbm_error
gdbm_last_errno (GDBM_FILE dbf)
{
  if (!dbf)
    {
      errno = EINVAL;
      return -1;
    }
  return dbf->last_error;
}

int
gdbm_last_syserr (GDBM_FILE dbf)
{
  if (!dbf)
    {
      errno = EINVAL;
      return -1;
    }
  return dbf->last_syserror;
}

int
gdbm_needs_recovery (GDBM_FILE dbf)
{
  if (!dbf)
    return 0;
  return dbf->need_recovery;
}

/* Clear error state for the database DBF. */
void
gdbm_clear_error (GDBM_FILE dbf)
{
  if (dbf)
    {
      dbf->last_error = GDBM_NO_ERROR;
      dbf->last_syserror = 0;
      free (dbf->last_errstr);
      dbf->last_errstr = NULL;
    }
}

/* this is not static so that applications may access the array if they
   like. */

const char * const gdbm_errlist[_GDBM_MAX_ERRNO+1] = {
  [GDBM_NO_ERROR]               = N_("No error"),
  [GDBM_MALLOC_ERROR]           = N_("Malloc error"),
  [GDBM_BLOCK_SIZE_ERROR]       = N_("Block size error"),
  [GDBM_FILE_OPEN_ERROR]        = N_("File open error"),
  [GDBM_FILE_WRITE_ERROR]       = N_("File write error"),
  [GDBM_FILE_SEEK_ERROR]        = N_("File seek error"),
  [GDBM_FILE_READ_ERROR]        = N_("File read error"),
  [GDBM_BAD_MAGIC_NUMBER]       = N_("Bad magic number"),
  [GDBM_EMPTY_DATABASE]         = N_("Empty database"),
  [GDBM_CANT_BE_READER]         = N_("Can't be reader"),
  [GDBM_CANT_BE_WRITER]         = N_("Can't be writer"),
  [GDBM_READER_CANT_DELETE]     = N_("Reader can't delete"),
  [GDBM_READER_CANT_STORE]      = N_("Reader can't store"),
  [GDBM_READER_CANT_REORGANIZE] = N_("Reader can't reorganize"),
  [GDBM_UNKNOWN_ERROR]          = N_("Should not happen: unused error code"),
  [GDBM_ITEM_NOT_FOUND]         = N_("Item not found"),
  [GDBM_REORGANIZE_FAILED]      = N_("Reorganize failed"),
  [GDBM_CANNOT_REPLACE]         = N_("Cannot replace"),
  [GDBM_MALFORMED_DATA]         = N_("Malformed data"),
  [GDBM_OPT_ALREADY_SET]        = N_("Option already set"),
  [GDBM_OPT_BADVAL]             = N_("Bad option value"),
  [GDBM_BYTE_SWAPPED]           = N_("Byte-swapped file"),
  [GDBM_BAD_FILE_OFFSET]        = N_("File header assumes wrong off_t size"),
  [GDBM_BAD_OPEN_FLAGS]         = N_("Bad file flags"),
  [GDBM_FILE_STAT_ERROR]        = N_("Cannot stat file"),
  [GDBM_FILE_EOF]               = N_("Unexpected end of file"),
  [GDBM_NO_DBNAME]              = N_("Database name not given"),
  [GDBM_ERR_FILE_OWNER]         = N_("Failed to restore file owner"),
  [GDBM_ERR_FILE_MODE]          = N_("Failed to restore file mode"),
  [GDBM_NEED_RECOVERY]          = N_("Database needs recovery"),
  [GDBM_BACKUP_FAILED]          = N_("Failed to create backup copy"),
  [GDBM_DIR_OVERFLOW]           = N_("Bucket directory overflow"),
  [GDBM_BAD_BUCKET]             = N_("Malformed bucket header"),
  [GDBM_BAD_HEADER]             = N_("Malformed database file header"),
  /* TRANSLATORS: avail_block is a field name. Don't translate it. */
  [GDBM_BAD_AVAIL]              = N_("Malformed avail_block"),
  [GDBM_BAD_HASH_TABLE]         = N_("Malformed hash table"),
  [GDBM_BAD_DIR_ENTRY]          = N_("Invalid directory entry"),
  [GDBM_FILE_CLOSE_ERROR]       = N_("Error closing file"),
  [GDBM_FILE_SYNC_ERROR]        = N_("Error synchronizing file"),
  [GDBM_FILE_TRUNCATE_ERROR]    = N_("Error truncating file"),
  [GDBM_BUCKET_CACHE_CORRUPTED] = N_("Bucket cache corrupted"),
  [GDBM_BAD_HASH_ENTRY]         = N_("Malformed bucket hash entry"),
  [GDBM_ERR_SNAPSHOT_CLONE]     = N_("Reflink failed"),
  [GDBM_ERR_REALPATH]           = N_("Failed to resolve real path name"),
  [GDBM_ERR_USAGE]              = N_("Function usage error"),
};

const char *
gdbm_strerror (gdbm_error error)
{
  if (error < _GDBM_MIN_ERRNO || error > _GDBM_MAX_ERRNO)
    error = GDBM_UNKNOWN_ERROR;
  return gettext (gdbm_errlist[error]);
}

char const *
gdbm_db_strerror (GDBM_FILE dbf)
{
  if (!dbf->last_errstr)
    {
      char const *errstr = gdbm_strerror (dbf->last_error);

      if (dbf->last_syserror)
	{
	  char const *syserrstr = strerror (dbf->last_syserror);
	  size_t len = strlen (errstr) + strlen (syserrstr) + 2;
	  dbf->last_errstr = malloc (len + 1);
	  if (!dbf->last_errstr)
	    return errstr;

	  strcpy (dbf->last_errstr, errstr);
	  strcat (dbf->last_errstr, ": ");
	  strcat (dbf->last_errstr, syserrstr);
	}
      else
	return errstr;
    }
  return dbf->last_errstr;
}

int const gdbm_syserr[_GDBM_MAX_ERRNO+1] = {
  [GDBM_FILE_OPEN_ERROR]        = 1,
  [GDBM_FILE_WRITE_ERROR]       = 1,
  [GDBM_FILE_SEEK_ERROR]        = 1,
  [GDBM_FILE_READ_ERROR]        = 1,
  [GDBM_FILE_STAT_ERROR]        = 1,
  [GDBM_BACKUP_FAILED]          = 1,
  [GDBM_FILE_CLOSE_ERROR]       = 1,
  [GDBM_FILE_SYNC_ERROR]        = 1,
  [GDBM_FILE_TRUNCATE_ERROR]    = 1,
  [GDBM_ERR_SNAPSHOT_CLONE]     = 1,
  [GDBM_ERR_REALPATH]           = 1,
  [GDBM_ERR_USAGE]              = 1
};

/* Returns true if system errno value is meaningful for GDBM error
   code N. */
int
gdbm_check_syserr (gdbm_error n)
{
  if (n >= _GDBM_MIN_ERRNO && n <= _GDBM_MAX_ERRNO)
    return gdbm_syserr[n];
  return 0;
}
