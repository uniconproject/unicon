/* falloc.c - The file space management routines for dbm. */

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
   along with GDBM. If not, see <http://www.gnu.org/licenses/>.    */

/* Include system configuration before all else. */
#include "autoconf.h"

#include "gdbmdefs.h"


/* The forward definitions for this file.  See the functions for
   the definition of the function. */

static avail_elem get_elem (int, avail_elem [], int *);
static avail_elem get_block (int, GDBM_FILE);
static int push_avail_block (GDBM_FILE);
static int pop_avail_block (GDBM_FILE);
static int adjust_bucket_avail (GDBM_FILE);

int
_gdbm_avail_block_read (GDBM_FILE dbf, avail_block *avblk, size_t size)
{
  int rc;
  
  rc = _gdbm_full_read (dbf, avblk, size);
  if (rc)
    {
      GDBM_DEBUG (GDBM_DEBUG_ERR|GDBM_DEBUG_OPEN,
		  "%s: error reading av_table: %s",
		  dbf->name, gdbm_db_strerror (dbf));
    }
  else
    rc = gdbm_avail_block_validate (dbf, avblk, size);
  return rc;
}

/* Allocate space in the file DBF for a block NUM_BYTES in length.  Return
   the file address of the start of the block.  

   Each hash bucket has a fixed size avail table.  We first check this
   avail table to satisfy the request for space.  In most cases we can
   and this causes changes to be only in the current hash bucket.
   Allocation is done on a first fit basis from the entries.  If a
   request can not be satisfied from the current hash bucket, then it is
   satisfied from the file header avail block.  If nothing is there that
   has enough space, another block at the end of the file is allocated
   and the unused portion is returned to the avail block.  This routine
   "guarantees" that an allocation does not cross a block boundary unless
   the size is larger than a single block.  The avail structure is
   changed by this routine if a change is needed.  If an error occurs,
   the value of 0 will be returned.  */

off_t
_gdbm_alloc (GDBM_FILE dbf, int num_bytes)
{
  off_t file_adr;		/* The address of the block. */
  avail_elem av_el;		/* For temporary use. */

  /* The current bucket is the first place to look for space. */
  av_el = get_elem (num_bytes, dbf->bucket->bucket_avail,
		    &dbf->bucket->av_count);

  /* If we did not find some space, we have more work to do. */
  if (av_el.av_size == 0)
    {
      /* If the header avail table is less than half full, and there's
	 something on the stack. */
      if ((dbf->avail->count <= (dbf->avail->size >> 1))
          && (dbf->avail->next_block != 0))
        if (pop_avail_block (dbf))
	  return 0;

      /* check the header avail table next */
      av_el = get_elem (num_bytes, dbf->avail->av_table, &dbf->avail->count);
      if (av_el.av_size == 0)
        /* Get another full block from end of file. */
        av_el = get_block (num_bytes, dbf);

      dbf->header_changed = TRUE;
    }

  /* We now have the place from which we will allocate the new space. */
  file_adr = av_el.av_adr;

  /* Put the unused space back in the avail block. */
  av_el.av_adr += num_bytes;
  av_el.av_size -= num_bytes;
  if (_gdbm_free (dbf, av_el.av_adr, av_el.av_size))
    return 0;

  /* Return the address. */
  return file_adr;
  
}

/* Free space of size NUM_BYTES in the file DBF at file address FILE_ADR.  Make
   it available for reuse through _gdbm_alloc.  This routine changes the
   avail structure. */

int
_gdbm_free (GDBM_FILE dbf, off_t file_adr, int num_bytes)
{
  avail_elem temp;

  /* Is it too small to worry about? */
  if (num_bytes <= IGNORE_SIZE)
    return 0;

  /* Initialize the avail element. */
  avail_elem_init (&temp, num_bytes, file_adr);

  /* Is the freed space large or small? */
  if ((num_bytes >= dbf->header->block_size) || dbf->central_free)
    {
      if (dbf->avail->count == dbf->avail->size)
	{
	  if (push_avail_block (dbf))
	    return -1;
	}
      _gdbm_put_av_elem (temp, dbf->avail->av_table,
			 &dbf->avail->count, dbf->coalesce_blocks);
      dbf->header_changed = TRUE;
    }
  else
    {
      /* Try to put into the current bucket. */
      if (dbf->bucket->av_count < BUCKET_AVAIL)
	_gdbm_put_av_elem (temp, dbf->bucket->bucket_avail,
			   &dbf->bucket->av_count, dbf->coalesce_blocks);
      else
	{
	  if (dbf->avail->count == dbf->avail->size)
	    {
	      if (push_avail_block (dbf))
		return -1;
	    }
	  _gdbm_put_av_elem (temp, dbf->avail->av_table,
			     &dbf->avail->count, dbf->coalesce_blocks);
	  dbf->header_changed = TRUE;
	}
    }

  if (dbf->header_changed && adjust_bucket_avail (dbf))
    return -1;

  /* All work is done. */
  return 0;
}



/* The following are all utility routines needed by the previous two. */


/* Gets the avail block at the top of the stack and loads it into the
   active avail block.  It does a "free" for itself!  This can be (and is)
   now called even when the avail block is not empty, so we must be
   smart about things. */

static int
pop_avail_block (GDBM_FILE dbf)
{
  off_t file_pos;		/* For use with the lseek system call. */
  avail_elem new_el;
  avail_block *new_blk;
  int index;
  
  if (dbf->avail->count == dbf->avail->size)
    {
      /* We're kind of stuck here, so we re-split the header in order to
         avoid crashing.  Sigh. */
      if (push_avail_block (dbf))
	return -1;
    }

  /* Set up variables. */
  avail_elem_init (&new_el,
		   ( ( (dbf->avail->size * sizeof (avail_elem)) >> 1)
		     + sizeof (avail_block)),
		   dbf->avail->next_block);

  /* Allocate space for the block. */
  new_blk = malloc (new_el.av_size);
  if (new_blk == NULL)
    {
      GDBM_SET_ERRNO (dbf, GDBM_MALLOC_ERROR, TRUE);
      _gdbm_fatal (dbf, _("malloc failed"));
      return -1;
    }

  /* Read the block. */
  file_pos = gdbm_file_seek (dbf, new_el.av_adr, SEEK_SET);
  if (file_pos != new_el.av_adr)
    {
      GDBM_SET_ERRNO (dbf, GDBM_FILE_SEEK_ERROR, TRUE);
      free (new_blk);
      _gdbm_fatal (dbf, _("lseek error"));
      return -1;
    }

  if (_gdbm_avail_block_read (dbf, new_blk, new_el.av_size))
    {
      free (new_blk);
      _gdbm_fatal (dbf, gdbm_db_strerror (dbf));
      return -1;
    }

  /* Add the elements from the new block to the header. */
  index = 0;
  while (index < new_blk->count)
    {
      while (index < new_blk->count
	     && dbf->avail->count < dbf->avail->size)
	{
	   /* With luck, this will merge a lot of blocks! */
	   _gdbm_put_av_elem (new_blk->av_table[index],
			      dbf->avail->av_table,
			      &dbf->avail->count, TRUE);
	   index++;
	}
      if (dbf->avail->count == dbf->avail->size)
        {
          /* We're kind of stuck here, so we re-split the header in order to
             avoid crashing.  Sigh. */
          if (push_avail_block (dbf))
	    {
	      free (new_blk);
	      return -1;
	    }
	}
    }

  /* Fix next_block, as well. */
  dbf->avail->next_block = new_blk->next_block;

  /* We changed the header. */
  /* FIXME: or avail block, when it is separate */
  dbf->header_changed = TRUE;

  /* Free the previous avail block.   It is possible that the header table
     is now FULL, which will cause us to overflow it! */
  if (dbf->avail->count == dbf->avail->size)
    {
      /* We're kind of stuck here, so we re-split the header in order to
         avoid crashing.  Sigh. */
      if (push_avail_block (dbf))
	{
	  free (new_blk);
	  return -1;
	}
    }

  _gdbm_put_av_elem (new_el, dbf->avail->av_table, &dbf->avail->count, TRUE);
  free (new_blk);

  return 0;
}


/* Splits the header avail block and pushes half onto the avail stack. */

static int
push_avail_block (GDBM_FILE dbf)
{
  int  av_size;
  off_t av_adr;
  int  index;
  off_t file_pos;
  avail_block *temp;
  avail_elem  new_loc;
  int rc;

  /* Calculate the size of the split block. */
  av_size = ( (dbf->avail->size * sizeof (avail_elem)) >> 1)
            + sizeof (avail_block);

  /* Get address in file for new av_size bytes. */
  new_loc = get_elem (av_size, dbf->avail->av_table, &dbf->avail->count);
  if (new_loc.av_size == 0)
    new_loc = get_block (av_size, dbf);
  av_adr = new_loc.av_adr;

  /* Split the header block. */
  temp = calloc (1, av_size);
  if (temp == NULL)
    {
      GDBM_SET_ERRNO (dbf, GDBM_MALLOC_ERROR, TRUE);
      _gdbm_fatal (dbf, _("malloc error"));
      return -1;
    }

  /* Set the size to be correct AFTER the pop_avail_block. */
  temp->size = dbf->avail->size;
  temp->count = 0;
  temp->next_block = dbf->avail->next_block;
  dbf->avail->next_block = av_adr;
  for (index = 1; index < dbf->avail->count; index++)
    if ( (index & 0x1) == 1)	/* Index is odd. */
      temp->av_table[temp->count++] = dbf->avail->av_table[index];
    else
      dbf->avail->av_table[index>>1] = dbf->avail->av_table[index];

  /* Update the header avail count. */
  dbf->avail->count -= temp->count;

  rc = 0;
  do
    {
      /* Free the unneeded space. */
      new_loc.av_adr += av_size;
      new_loc.av_size -= av_size;
      if (_gdbm_free (dbf, new_loc.av_adr, new_loc.av_size))
	{
	  rc = -1;
	  break;
	}
  
      /* Update the disk. */
      file_pos = gdbm_file_seek (dbf, av_adr, SEEK_SET);
      if (file_pos != av_adr)
	{
	  GDBM_SET_ERRNO (dbf, GDBM_FILE_SEEK_ERROR, TRUE);
	  _gdbm_fatal (dbf, _("lseek error"));
	  rc = -1;
	  break;
	}

      rc = _gdbm_full_write (dbf, temp, av_size);
      if (rc)
	{
	  GDBM_DEBUG (GDBM_DEBUG_STORE|GDBM_DEBUG_ERR,
		      "%s: error writing avail data: %s",
		      dbf->name, gdbm_db_strerror (dbf));	  
	  _gdbm_fatal (dbf, gdbm_db_strerror (dbf));
	  rc = -1;
	}
    }
  while (0);
  
  free (temp);

  return rc;
}

/* AV_TABLE contains COUNT entries sorted by AV_SIZE in ascending order.
   Avail_lookup returns index of an item whose AV_SIZE member is greater
   than or equal to SIZE. */
static int
avail_lookup (int size, avail_elem *av_table, int count)
{
  int start = 0;
  
  while (count > 0)
    {
      int pivot = start + (count >> 1);
      if (size == av_table[pivot].av_size)
	return pivot;
      if (size > av_table[pivot].av_size)
	{
	  start = pivot + 1;
	  count--;
	}
      count >>= 1;
    }
  return start;
}

/* In array AV_TABLE of *AV_COUNT items, move all items from
   position SRC to DST and update *AV_COUNT accordingly.
*/
static inline void
avail_move (avail_elem *av_table, int *av_count, int src, int dst)
{
  memmove (av_table + dst, av_table + src,
	   (*av_count - src) * sizeof av_table[0]);
  *av_count += dst - src;
}

/* Get_elem returns an element in the AV_TABLE block which is
   larger than SIZE.  AV_COUNT is the number of elements in the
   AV_TABLE.  If an item is found, it extracts it from the AV_TABLE
   and moves the other elements up to fill the space. If no block is 
   found larger than SIZE, get_elem returns a size of zero.  This
   routine does no I/O. */

static avail_elem
get_elem (int size, avail_elem av_table[], int *av_count)
{
  int index;			/* For searching through the avail block. */
  avail_elem val;		/* The default return value. */

  /* Initialize default return value. */
  avail_elem_init (&val, 0, 0);

  /* Search for element.  List is sorted by size. */
  index = avail_lookup (size, av_table, *av_count);

  /* Did we find one of the right size? */
  if (index >= *av_count)
    return val;

  /* Ok, save that element and move all others up one. */
  val = av_table[index];
  avail_move (av_table, av_count, index + 1, index);
  return val;
}

/* This routine inserts a single NEW_EL into the AV_TABLE block.
   This routine does no I/O. */

void
_gdbm_put_av_elem (avail_elem new_el, avail_elem av_table[], int *av_count,
     		   int can_merge)
{
  int index;

  /* Is it too small to deal with? */
  if (new_el.av_size <= IGNORE_SIZE)
    return;

  if (can_merge == TRUE)
    {
      /* Search for blocks to coalesce with this one. */
      int i;
      
      for (i = 0; i < *av_count;)
	{
	  if ((av_table[i].av_adr + av_table[i].av_size) == new_el.av_adr)
	    {
	      /* Right adjacent */
	      new_el.av_size += av_table[i].av_size;
	      new_el.av_adr = av_table[i].av_adr;
	      avail_move (av_table, av_count, i + 1, i);
	    }
          else if ((new_el.av_adr + new_el.av_size) == av_table[i].av_adr)
	    {
	      /* Left adjacent */
	      new_el.av_size += av_table[i].av_size;
	      avail_move (av_table, av_count, i + 1, i);
	    }
          else
            i++;
	}
    }

  /* Search for place to put element.  List is sorted by size. */
  index = avail_lookup (new_el.av_size, av_table, *av_count);
  /* Move all others up one. */
  avail_move (av_table, av_count, index, index + 1);
  /* Add the new element. */
  av_table[index] = new_el;
}

/* Get_block "allocates" new file space and the end of the file.  This is
   done in integral block sizes.  (This helps ensure that data smaller than
   one block size is in a single block.)  Enough blocks are allocated to
   make sure the number of bytes allocated in the blocks is larger than SIZE.
   DBF contains the file header that needs updating.  This routine does
   no I/O.  */

static avail_elem
get_block (int size, GDBM_FILE dbf)
{
  avail_elem val;

  /* Need at least one block. */
  avail_elem_init (&val, dbf->header->block_size, dbf->header->next_block);

  /* Get enough blocks to fit the need. */
  while (val.av_size < size)
    val.av_size += dbf->header->block_size;

  /* Update the header and return. */
  dbf->header->next_block += val.av_size;

  /* We changed the header. */
  dbf->header_changed = TRUE;

  return val;
  
}


/*  When the header already needs writing, we can make sure the current
    bucket has its avail block as close to 1/3 full as possible. */
static int
adjust_bucket_avail (GDBM_FILE dbf)
{
  int third = BUCKET_AVAIL / 3;
  avail_elem av_el;

  /* Can we add more entries to the bucket? */
  if (dbf->bucket->av_count < third)
    {
      if (dbf->avail->count > 0)
	{
	  dbf->avail->count -= 1;
	  av_el = dbf->avail->av_table[dbf->avail->count];
	  _gdbm_put_av_elem (av_el, dbf->bucket->bucket_avail,
			     &dbf->bucket->av_count, dbf->coalesce_blocks);
	  _gdbm_current_bucket_changed (dbf);
	}
      return 0;
    }

  /* Is there too much in the bucket? */
  while (dbf->bucket->av_count > BUCKET_AVAIL-third
	 && dbf->avail->count < dbf->avail->size)
    {
      av_el = get_elem (0, dbf->bucket->bucket_avail, &dbf->bucket->av_count);
      if (av_el.av_size == 0)
	{
	  GDBM_SET_ERRNO (dbf, GDBM_BAD_AVAIL, TRUE);
	  return -1;
	}
      _gdbm_put_av_elem (av_el, dbf->avail->av_table,
			 &dbf->avail->count,
			 dbf->coalesce_blocks);
      _gdbm_current_bucket_changed (dbf);
    }
  return 0;
}
