/* update.c - The routines for updating the file to a consistent state. */

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

/* This procedure writes the header back to the file described by DBF. */

static int
write_header (GDBM_FILE dbf)
{
  off_t file_pos;	/* Return value for lseek. */
  int rc;

  file_pos = gdbm_file_seek (dbf, 0L, SEEK_SET);
  if (file_pos != 0)
    {
      GDBM_SET_ERRNO2 (dbf, GDBM_FILE_SEEK_ERROR, TRUE, GDBM_DEBUG_STORE);
      _gdbm_fatal (dbf, _("lseek error"));
      return -1;
    }

  rc = _gdbm_full_write (dbf, dbf->header, dbf->header->block_size);
  
  if (rc)
    {
      GDBM_DEBUG (GDBM_DEBUG_STORE|GDBM_DEBUG_ERR,
		  "%s: error writing header: %s",
		  dbf->name, gdbm_db_strerror (dbf));	        
      return -1;
    }

  /* Sync the file if fast_write is FALSE. */
  if (dbf->fast_write == FALSE)
    gdbm_file_sync (dbf);

  return 0;
}


/* After all changes have been made in memory, we now write them
   all to disk. */
int
_gdbm_end_update (GDBM_FILE dbf)
{
  off_t file_pos;	/* Return value for lseek. */
  int rc;
  
  /* Write the changed buckets if there are any. */
  _gdbm_cache_flush (dbf);
  
  /* Write the directory. */
  if (dbf->directory_changed)
    {
      file_pos = gdbm_file_seek (dbf, dbf->header->dir, SEEK_SET);
      if (file_pos != dbf->header->dir)
	{
	  GDBM_SET_ERRNO2 (dbf, GDBM_FILE_SEEK_ERROR, TRUE, GDBM_DEBUG_STORE);
	  _gdbm_fatal (dbf, _("lseek error"));
	  return -1;
	}

      rc = _gdbm_full_write (dbf, dbf->dir, dbf->header->dir_size);
      if (rc)
	{
	  GDBM_DEBUG (GDBM_DEBUG_STORE|GDBM_DEBUG_ERR,
		      "%s: error writing directory: %s",
		      dbf->name, gdbm_db_strerror (dbf));	  	  
	  _gdbm_fatal (dbf, gdbm_db_strerror (dbf));
	  return -1;
	}

      dbf->directory_changed = FALSE;
      if (!dbf->header_changed && dbf->fast_write == FALSE)
	gdbm_file_sync (dbf);
    }

  /* Final write of the header. */
  if (dbf->header_changed)
    {
      if (write_header (dbf))
	return -1;
      if (_gdbm_file_extend (dbf, dbf->header->next_block))
	return -1;
      dbf->header_changed = FALSE;
    }

  return 0;
}


/* For backward compatibility, if the caller defined fatal_err function,
   call it upon fatal error and exit. */

void
_gdbm_fatal (GDBM_FILE dbf, const char *val)
{
  if (dbf && dbf->fatal_err)
    {
      (*dbf->fatal_err) (val);
      exit (1);
    }
}
