/* avail.c - avail block and stack handling functions. */

/* This file is part of GDBM, the GNU data base manager.
   Copyright (C) 2021-2025 Free Software Foundation, Inc.

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

#include "autoconf.h"
#include "gdbmdefs.h"

static int
avail_comp (void const *a, void const *b)
{
  avail_elem const *ava = a;
  avail_elem const *avb = b;
  if (ava->av_size < avb->av_size)
    return -1;
  else if (ava->av_size > avb->av_size)
    return 1;
  return 0;
}

/* Returns true if the avail array AV[0]@COUNT is valid.

   As a side effect, ensures the array is sorted by element size
   in increasing order and restores the ordering if necessary.

   The proper ordering could have been clobbered in versions of GDBM<=1.15,
   by a call to _gdbm_put_av_elem with the can_merge parameter set to
   TRUE. This happened in two cases: either because the GDBM_COALESCEBLKS
   was set, and (quite unfortunately) when _gdbm_put_av_elem was called
   from pop_avail_block in falloc.c. The latter case is quite common,
   which means that there can be lots of existing databases with broken
   ordering of avail arrays. Thus, restoring of the proper ordering
   is essential for people to be able to use their existing databases.
*/
static int
gdbm_avail_table_valid_p (GDBM_FILE dbf, avail_elem *av, int count)
{
  off_t prev = 0;
  int i;
  int needs_sorting = 0;
  avail_elem *p = av;
  
  prev = 0;
  for (i = 0; i < count; i++, p++)
    {
      if (!(p->av_adr >= dbf->header->bucket_size
	    && off_t_sum_ok (p->av_adr, p->av_size)
	    && p->av_adr + p->av_size <= dbf->header->next_block))
	return 0;
      if (p->av_size < prev)
	needs_sorting = 1;
      prev = p->av_size;
    }

  if (needs_sorting && dbf->read_write)
    {
      GDBM_DEBUG (GDBM_DEBUG_ERR, "%s", "restoring sort order");
      qsort (av, count, sizeof av[0], avail_comp);
    }
  
  return 1;
}

int
gdbm_avail_block_validate (GDBM_FILE dbf, avail_block *avblk, size_t size)
{
  if (!(size > sizeof (avail_block)
	&& (avblk->size > 1 && avblk->count >= 0 && avblk->count <= avblk->size)
	&& ((size - sizeof (avail_block)) / sizeof (avail_elem) + 1) >= avblk->count
	&& gdbm_avail_table_valid_p (dbf, avblk->av_table, avblk->count)))
    {
      GDBM_SET_ERRNO (dbf, GDBM_BAD_AVAIL, TRUE);
      return -1;
    }
  return 0;
}

int
gdbm_bucket_avail_table_validate (GDBM_FILE dbf, hash_bucket *bucket)
{
  if (!(bucket->av_count >= 0
	&& bucket->av_count <= BUCKET_AVAIL
	&& gdbm_avail_table_valid_p (dbf, bucket->bucket_avail,
				     bucket->av_count)))
    {
      GDBM_SET_ERRNO (dbf, GDBM_BAD_AVAIL, TRUE);
      return -1;
    }
  return 0;
}

struct off_map
{
  off_t *map_base;
  size_t map_size;
  size_t map_max;
};

#define OFF_MAP_INITIALIZER { NULL, 0, 0 }

static void
off_map_free (struct off_map *map)
{
  free (map->map_base);
}

static int
off_map_expand (struct off_map *map)
{
  size_t n = map->map_max;
  void *p;
  
  if (!map->map_base)
    {
      if (!n)
	n = 64;
    }
  else
    {
      if (SIZE_T_MAX / 3 * 2 / sizeof (map->map_base[0]) <= n)
	{
	  errno = ENOMEM;
	  return -1;
	}
      n += (n + 1) / 2;
    }

  p = realloc (map->map_base, n * sizeof (map->map_base[0]));
  if (!p)
    return -1;
  map->map_base = p;
  map->map_max = n;
  return 0;
}

static int
off_map_lookup (struct off_map *map, off_t n)
{
  ssize_t lo, hi, mid;

  if (map->map_size)
    {
      lo = 0;
      hi = map->map_size - 1;
      while (lo <= hi)
	{
	  mid = (lo + hi) / 2;
	  if (map->map_base[mid] > n)
	    hi = mid - 1;
	  else if (map->map_base[mid] < n)
	    lo = mid + 1;
	  else
	    return GDBM_CANNOT_REPLACE;
	}
    }
  else
    hi = -1;

  if (map->map_size == map->map_max)
    {
      if (off_map_expand (map))
	return GDBM_MALLOC_ERROR;
    }

  hi++;
  if (map->map_size > hi)
    memmove (map->map_base + hi + 1, map->map_base + hi,
	     (map->map_size - hi) * sizeof (map->map_base[0]));
  map->map_base[hi] = n;
  map->map_size++;
  return GDBM_NO_ERROR;
}

/*
 * gdbm_avail_traverse - traverse the stack of available space blocks.
 *
 * Starting from the header, reads in and verifies each avail block.
 * If the block is valid and callback function CB is given, calls it
 * with the current avail block, its offset in file and user-supplied
 * data as arguments.
 *
 * Traversal stops when one of the following occurs:
 *   1) entire stack has been traversed;
 *   2) an already traversed block is encountered;
 *   3) a block fails validation;
 *   4) callback function (if given) returned non-zero.
 *
 * Returns 0 (success) in cases (1) and (4).  Otherwise, sets the
 * appropriate GDBM error code and returns -1.
 * The case (2) makes this function useful for detecting loops in the
 * avail stack.
 */
int
gdbm_avail_traverse (GDBM_FILE dbf,
		     int (*cb) (avail_block *, off_t, void *), void *data)
{
  avail_block *blk;
  size_t size;
  off_t n;
  struct off_map map = OFF_MAP_INITIALIZER;
  int rc = 0;
  
  GDBM_ASSERT_CONSISTENCY (dbf, -1);
  if (gdbm_avail_block_validate (dbf, dbf->avail, dbf->avail_size))
    return -1;

  if (off_map_lookup (&map, GDBM_HEADER_AVAIL_OFFSET (dbf)))
    {
      GDBM_SET_ERRNO (dbf, GDBM_MALLOC_ERROR, FALSE);
      return -1;
    }
      
  size = ((((size_t)dbf->avail->size * sizeof (avail_elem)) >> 1)
	  + sizeof (avail_block));
  blk = malloc (size);
  if (!blk)
    {
      GDBM_SET_ERRNO (dbf, GDBM_MALLOC_ERROR, FALSE);
      off_map_free (&map);
      return -1;
    }

  if (!(cb && cb (dbf->avail, 0, data)))
    {  
      n = dbf->avail->next_block;
      while (n)
	{
	  rc = off_map_lookup (&map, n);
	  if (rc != GDBM_NO_ERROR)
	    {
	      if (rc == GDBM_CANNOT_REPLACE)
		GDBM_SET_ERRNO (dbf, GDBM_BAD_AVAIL, TRUE);
	      else
		GDBM_SET_ERRNO (dbf, rc, FALSE);
	      rc = -1;
	      break;
	    }
	  
	  if (gdbm_file_seek (dbf, n, SEEK_SET) != n)
	    {
	      GDBM_SET_ERRNO (dbf, GDBM_FILE_SEEK_ERROR, FALSE);
	      rc = -1;
	      break;
	    }

	  if (_gdbm_avail_block_read (dbf, blk, size))
	    {
	      rc = -1;
	      break;
	    }
	  
	  if (cb && cb (blk, n, data))
	    break;
	  
	  n = blk->next_block;
	}
    }
  
  free (blk);
  off_map_free (&map);
  
  return rc;
}

/*
 * gdbm_avail_verify - verify the avail stack consistency.
 *
 * Traverses the avail stack, verifying each avail block and keeping track
 * of visited block offsets to discover eventual loops.
 *
 * On success, returns 0.  On error, sets GDBM errno and returns -1.
 */
int
gdbm_avail_verify (GDBM_FILE dbf)
{
  return gdbm_avail_traverse (dbf, NULL, NULL);
}





