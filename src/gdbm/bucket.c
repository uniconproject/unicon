/* bucket.c - The routines for playing with hash buckets. */

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

#include "autoconf.h"
#include "gdbmdefs.h"
#include <stdint.h>
#include <limits.h>

#define GDBM_MAX_DIR_SIZE INT32_MAX
#define GDBM_MAX_DIR_HALF (GDBM_MAX_DIR_SIZE / 2)

/* Initializing a new hash buckets sets all bucket entries to -1 hash value. */
void
_gdbm_new_bucket (GDBM_FILE dbf, hash_bucket *bucket, int bits)
{
  int index;

  /* Initialize the avail block. */
  bucket->av_count = 0;

  /* Set the information fields first. */
  bucket->bucket_bits = bits;
  bucket->count = 0;
  
  /* Initialize all bucket elements. */
  for (index = 0; index < dbf->header->bucket_elems; index++)
    bucket->h_table[index].hash_value = -1;
}

/* Bucket cache table functions */

/* Hash an off_t word into an index of width NBITS. */
static size_t
adrhash (off_t adr, size_t nbits)
{
  adr ^= adr >> (GDBM_HASH_BITS + 1 - nbits); 
  return ((265443576910ul * adr) & 0xffffffff) >> (GDBM_HASH_BITS + 1 - nbits);
}

/*
 * Return a pointer to the cache table slot for bucket address ADR.
 * Never returns NULL.
 */
static cache_elem **
cache_tab_lookup_slot (GDBM_FILE dbf, off_t adr)
{
  cache_elem **cache = dbf->cache;
  size_t h = adrhash (adr, dbf->cache_bits);

  if (cache[h])
    {
      if (cache[h]->ca_adr != adr)
	{
	  cache_elem *prev = cache[h], *p = prev->ca_coll;
	  while (p)
	    {
	      if (p->ca_adr == adr)
		break;
	      prev = p;
	      p = prev->ca_coll;
	    }
	  return &prev->ca_coll;
	}
    }
  return &cache[h];
}

/* LRU list management */

/*
 * Link ELEM after REF in DBF cache.  If REF is NULL, link at head and
 * set DBF->bucket to point to the ca_bucket of ELEM.
 */
static void
lru_link_elem (GDBM_FILE dbf, cache_elem *elem, cache_elem *ref)
{
  if (!ref)
    {
      elem->ca_prev = NULL;
      elem->ca_next = dbf->cache_mru;
      if (dbf->cache_mru)
	dbf->cache_mru->ca_prev = elem;
      else
	dbf->cache_lru = elem;
      dbf->cache_mru = elem;
      dbf->bucket = dbf->cache_mru->ca_bucket;
    }
  else
    {
      cache_elem *x;

      elem->ca_prev = ref;
      elem->ca_next = ref->ca_next;
      if ((x = ref->ca_next))
	x->ca_prev = elem;
      else
	dbf->cache_lru = elem;
      ref->ca_next = elem;
    }
}

/*
 * Unlink ELEM from the list of cache elements in DBF.
 * If cache_mru gets updated, update DBF->bucket accordingly.
 */
static void
lru_unlink_elem (GDBM_FILE dbf, cache_elem *elem)
{
  cache_elem *x;

  if ((x = elem->ca_prev))
    x->ca_next = elem->ca_next;
  else
    {
      dbf->cache_mru = elem->ca_next;
      dbf->bucket = dbf->cache_mru ? dbf->cache_mru->ca_bucket : NULL;
    }
  if ((x = elem->ca_next))
    x->ca_prev = elem->ca_prev;
  else
    dbf->cache_lru = elem->ca_prev;
  elem->ca_prev = elem->ca_next = NULL;
}

/* Creates and returns new cache element for DBF.  The element is initialized,
   but not linked to the LRU list.
   Return NULL on error.
*/
static cache_elem *
cache_elem_new (GDBM_FILE dbf, off_t adr)
{
  cache_elem *elem;

  elem = dbf->cache_avail;
  if (elem)
    {
      dbf->cache_avail = elem->ca_next;
    }
  else
    {
      elem = calloc (1,
		     sizeof (*elem) -
		     sizeof (elem->ca_bucket[0]) +
		     dbf->header->bucket_size);

      if (!elem)
	return NULL;
    }

  elem->ca_adr = adr;
  elem->ca_changed = FALSE;
  elem->ca_data.hash_val = -1;
  elem->ca_data.elem_loc = -1;

  elem->ca_prev = elem->ca_next = elem->ca_coll = NULL;
  elem->ca_hits = 0;
  
  return elem;
}

/* Frees element ELEM.  Unlinks it from the cache tree and LRU list. */
static void
cache_elem_free (GDBM_FILE dbf, cache_elem *elem)
{
  size_t h = adrhash (elem->ca_adr, dbf->cache_bits);
  cache_elem **pp;
  
  lru_unlink_elem (dbf, elem);

  elem->ca_next = dbf->cache_avail;
  dbf->cache_avail = elem;
  dbf->cache_num--;

  pp = &dbf->cache[h];
  while (*pp)
    {
      if (*pp == elem)
	{
	  *pp = (*pp)->ca_coll;
	  break;
	}
      pp = &(*pp)->ca_coll;
    }      
}

/* Free the least recently used cache entry. */
static inline int
cache_lru_free (GDBM_FILE dbf)
{
  cache_elem *last = dbf->cache_lru;
  if (last->ca_changed)
    {
      if (_gdbm_write_bucket (dbf, last))
	return -1;
    }
  cache_elem_free (dbf, last);
  return 0;
}

/*
 * Round up V to the next highest power of 2 and compute log2 of
 * it using De Brujin sequences.
 * See http://supertech.csail.mit.edu/papers/debruijn.pdf
 */
static unsigned
log2i (unsigned v)
{
  static const int dbp[32] =
    {
      0, 1, 28, 2, 29, 14, 24, 3, 30, 22, 20, 15, 25, 17, 4, 8, 
      31, 27, 13, 23, 21, 19, 16, 7, 26, 12, 18, 6, 11, 5, 10, 9
    };

  v--;
  v |= v >> 1;
  v |= v >> 2;
  v |= v >> 4;
  v |= v >> 8;
  v |= v >> 16;
  v++;
  return dbp[(uint32_t)(v * 0x077CB531U) >> 27];
}

static int
cache_tab_resize (GDBM_FILE dbf, int bits)
{
  size_t size = 1 << bits;

  if (!dbf->cache || size != dbf->cache_size)
    {
      size_t n = size * sizeof (dbf->cache[0]);
      cache_elem **p, *elem;
      
      /* Flush existing cache */
      if (_gdbm_cache_flush (dbf))
	return -1;

      /* Reallocate it */
      p = realloc (dbf->cache, n);
      if (!p)
	{
	  GDBM_SET_ERRNO (dbf, GDBM_MALLOC_ERROR, FALSE);
	  return -1;
	}
      dbf->cache = p;
      dbf->cache_size = size;
      dbf->cache_bits = bits;

      memset (dbf->cache, 0, n);

      /* Rehash and free surplus elements */
      for (elem = dbf->cache_lru; elem; )
	{
	  cache_elem *prev = elem->ca_prev;
	  elem->ca_coll = NULL;
	  if (size < dbf->cache_num)
	    {
	      cache_elem_free (dbf, elem);
	    }
	  else
	    {
	      p = cache_tab_lookup_slot (dbf, elem->ca_adr);
	      if (*p)
		abort ();// shouldn't happen
	      *p = elem;
	    }
	  elem = prev;
	}
    }
  return 0;
}

enum
  {
    cache_found,
    cache_new,
    cache_failure
  };

static int
cache_lookup (GDBM_FILE dbf, off_t adr, cache_elem *ref, cache_elem **ret_elem)
{
  int rc;
  cache_elem **elp, *elem;
  
  dbf->cache_access_count++;

  elp = cache_tab_lookup_slot (dbf, adr);
  
  if (*elp != NULL)
    {
      elem = *elp;
      elem->ca_hits++;
      dbf->cache_hits++;
      lru_unlink_elem (dbf, elem);
      rc = cache_found;
    }
  else if ((elem = cache_elem_new (dbf, adr)) == NULL)
    return cache_failure;
  else
    {
      rc = cache_new;

      if (dbf->cache_num == dbf->cache_size)
	{
	  if (dbf->cache_auto && dbf->cache_bits < dbf->header->dir_bits &&
	      cache_tab_resize (dbf, dbf->cache_bits + 1) == 0)
	    {
	      /* Table has been reallocated, recompute the slot. */
	      elp = cache_tab_lookup_slot (dbf, adr);
	    }
	  else if (cache_lru_free (dbf))
	    {
	      rc = cache_failure;
	    }
	}
      
      if (rc == cache_new)
	{
	  *elp = elem;
	  dbf->cache_num++;
	}
    }

  /*
   * If the obtained bucket is not changed and is going to become current,
   * flush all changed cache elements.  This ensures that changed cache
   * elements form a contiguous sequence at the head of the cache list (see
   * _gdbm_cache_flush).
   */
  if (ref == NULL && !elem->ca_changed)
    _gdbm_cache_flush (dbf);
  
  lru_link_elem (dbf, elem, ref);
  if (rc != cache_failure)
    *ret_elem = elem;
  return rc;
}

/*
 * Find a bucket for DBF that is pointed to by the bucket directory from
 * location DIR_INDEX.   The bucket cache is first checked to see if it
 * is already in memory.  If not, the last recently used bucket may be
 * tossed (if the cache is full) to read the new bucket.
 *
 * On success, the cached entry with the requested bucket is placed at
 * the head of the cache list (cache_mru) and the requested bucket becomes
 * "current".
 *
 * On error, the current bucket remains unchanged.
 */
int
_gdbm_get_bucket (GDBM_FILE dbf, int dir_index)
{
  int rc;
  off_t bucket_adr;	/* The address of the correct hash bucket.  */
  off_t	file_pos;	/* The return address for lseek. */
  hash_bucket *bucket;
  cache_elem *elem;
  
  if (!gdbm_dir_entry_valid_p (dbf, dir_index))
    {
      /* FIXME: negative caching? */
      GDBM_SET_ERRNO (dbf, GDBM_BAD_DIR_ENTRY, TRUE);
      return -1;
    }
  
  /* Initial set up. */
  dbf->bucket_dir = dir_index;
  bucket_adr = dbf->dir[dir_index];

  switch (cache_lookup (dbf, bucket_adr, NULL, &elem))
    {
    case cache_found:
      break;
      
    case cache_new:
      /* Position the file pointer */
      file_pos = gdbm_file_seek (dbf, bucket_adr, SEEK_SET);
      if (file_pos != bucket_adr)
	{
	  GDBM_SET_ERRNO (dbf, GDBM_FILE_SEEK_ERROR, TRUE);
	  cache_elem_free (dbf, elem);
	  _gdbm_fatal (dbf, _("lseek error"));
	  return -1;
	}

      /* Read the bucket. */
      rc = _gdbm_full_read (dbf, elem->ca_bucket, dbf->header->bucket_size);
      if (rc)
	{
	  GDBM_DEBUG (GDBM_DEBUG_ERR,
		      "%s: error reading bucket: %s",
		      dbf->name, gdbm_db_strerror (dbf));
	  dbf->need_recovery = TRUE;
	  cache_elem_free (dbf, elem);
	  _gdbm_fatal (dbf, gdbm_db_strerror (dbf));
	  return -1;
	}

      /* Validate the bucket */
      bucket = elem->ca_bucket;
      if (!(bucket->count >= 0
	    && bucket->count <= dbf->header->bucket_elems
	    && bucket->bucket_bits >= 0
	    && bucket->bucket_bits <= dbf->header->dir_bits))
	{
	  GDBM_SET_ERRNO (dbf, GDBM_BAD_BUCKET, TRUE);
	  cache_elem_free (dbf, elem);
	  return -1;
	}
      /* Validate bucket_avail table */
      if (gdbm_bucket_avail_table_validate (dbf, bucket))
	{
	  cache_elem_free (dbf, elem);
	  return -1;
	}
      
      /* Update the cache */
      elem->ca_adr = bucket_adr;
      elem->ca_data.elem_loc = -1;
      elem->ca_changed = FALSE;
      
      break;
      
    case cache_failure:
      return -1;
    }
  
  return 0;
}

/* Split the current bucket.  This includes moving all items in the bucket to
   a new bucket.  This doesn't require any disk reads because all hash values
   are stored in the buckets.  Splitting the current bucket may require
   doubling the size of the hash directory.  */
int
_gdbm_split_bucket (GDBM_FILE dbf, int next_insert)
{
  off_t        old_adr[GDBM_HASH_BITS];  /* Address of the old directories. */
  int          old_size[GDBM_HASH_BITS]; /* Size of the old directories. */
  int	       old_count;	/* Number of old directories. */

  int          index;		/* Used in array indexing. */
  int          index1;		/* Used in array indexing. */
  
  /* No directories are yet old. */
  old_count = 0;
  while (dbf->bucket->count == dbf->header->bucket_elems)
    {
      int          new_bits;	/* The number of bits for the new buckets. */
      cache_elem  *newcache[2]; /* Location in the cache for the buckets. */
      off_t        adr_0;	/* File address of the new bucket 0. */
      off_t        adr_1;	/* File address of the new bucket 1. */
      avail_elem   old_bucket;	/* Avail Struct for the old bucket. */
      
      off_t        dir_start0;	/* Used in updating the directory. */
      off_t        dir_start1;
      off_t        dir_end;

      new_bits = dbf->bucket->bucket_bits + 1;

      /*
       * Allocate two new buckets.  They will be populated with the entries
       * from the current bucket (cache_mru->bucket), so make sure that
       * cache_mru remains unchanged until both buckets are fully formed.
       * Newly allocated buckets must be linked right after cache_mru, so
       * that all changed buckets form a contiguous sequence at the beginning
       * of the cache list (this is needed by _gdbm_cache_flush).
       */
      adr_0 = _gdbm_alloc (dbf, dbf->header->bucket_size);
      switch (cache_lookup (dbf, adr_0, dbf->cache_mru, &newcache[0]))
	{
	case cache_new:
	  break;

	case cache_found:
	  /* should not happen */
	  GDBM_DEBUG (GDBM_DEBUG_ERR,
		      "%s: bucket found where it should not",
		      dbf->name);
	  GDBM_SET_ERRNO (dbf, GDBM_BUCKET_CACHE_CORRUPTED, TRUE);
	  return -1;

	case cache_failure:
	  return -1;
	}
      _gdbm_new_bucket (dbf, newcache[0]->ca_bucket, new_bits);

      adr_1 = _gdbm_alloc (dbf, dbf->header->bucket_size);
      switch (cache_lookup (dbf, adr_1, newcache[0], &newcache[1]))
	{
	case cache_new:
	  break;

	case cache_found:
	  /* should not happen */
	  GDBM_DEBUG (GDBM_DEBUG_ERR,
		      "%s: bucket found where it should not",
		      dbf->name);
	  GDBM_SET_ERRNO (dbf, GDBM_BUCKET_CACHE_CORRUPTED, TRUE);
	  return -1;

	case cache_failure:
	  return -1;
	}
      _gdbm_new_bucket (dbf, newcache[1]->ca_bucket, new_bits);

      /* Double the directory size if necessary. */
      if (dbf->header->dir_bits == dbf->bucket->bucket_bits)
	{
	  off_t       *new_dir;		/* Pointer to the new directory. */
	  int          dir_size;	/* Size of the new directory. */
	  off_t        dir_adr; 	/* Address of the new directory. */
	  
	  if (dbf->header->dir_size >= GDBM_MAX_DIR_HALF)
	    {
	      GDBM_SET_ERRNO (dbf, GDBM_DIR_OVERFLOW, TRUE);
	      _gdbm_fatal (dbf, _("directory overflow"));
	      return -1;
	    }
	  dir_size = dbf->header->dir_size * 2;
	  dir_adr  = _gdbm_alloc (dbf, dir_size);
	  if (dir_adr == 0)
	    return -1;
	  new_dir = malloc (dir_size);
	  if (new_dir == NULL)
	    {
	      GDBM_SET_ERRNO (dbf, GDBM_MALLOC_ERROR, TRUE);
	      _gdbm_fatal (dbf, _("malloc error"));
	      return -1;
	    }

	  for (index = 0; index < GDBM_DIR_COUNT (dbf); index++)
	    {
	      new_dir[2*index]   = dbf->dir[index];
	      new_dir[2*index+1] = dbf->dir[index];
	    }
	  
	  /* Update header. */
	  old_adr[old_count] = dbf->header->dir;
	  dbf->header->dir = dir_adr;
	  old_size[old_count] = dbf->header->dir_size;
	  dbf->header->dir_size = dir_size;
	  dbf->header->dir_bits = new_bits;
	  old_count++;
	  
	  /* Now update dbf.  */
	  dbf->header_changed = TRUE;
	  dbf->bucket_dir *= 2;
	  free (dbf->dir);
	  dbf->dir = new_dir;
	}

      /* Copy all elements in dbf->bucket into the new buckets. */
      for (index = 0; index < dbf->header->bucket_elems; index++)
	{
	  bucket_element *old_el = &dbf->bucket->h_table[index];
	  hash_bucket *bucket;
	  int elem_loc;
	  
	  if (old_el->hash_value < 0)
	    {
	      GDBM_SET_ERRNO (dbf, GDBM_BAD_BUCKET, TRUE);
	      return -1;
	    }

	  bucket =
	    newcache[(old_el->hash_value >> (GDBM_HASH_BITS - new_bits)) & 1]->ca_bucket;
	  elem_loc = old_el->hash_value % dbf->header->bucket_elems;
	  while (bucket->h_table[elem_loc].hash_value != -1)
	    elem_loc = (elem_loc + 1) % dbf->header->bucket_elems;
	  bucket->h_table[elem_loc] = *old_el;
	  bucket->count++;
	}
      
      /* Allocate avail space for the newcache[1]->ca_bucket. */
      newcache[1]->ca_bucket->bucket_avail[0].av_adr
	= _gdbm_alloc (dbf, dbf->header->block_size);
      if (newcache[1]->ca_bucket->bucket_avail[0].av_adr == 0)
	return -1;
      newcache[1]->ca_bucket->bucket_avail[0].av_size
	= dbf->header->block_size;
      newcache[1]->ca_bucket->av_count = 1;
      
      /* Copy the avail elements in dbf->bucket to newcache[0]->ca_bucket. */
      newcache[0]->ca_bucket->av_count = dbf->bucket->av_count;
      index = 0;
      if (newcache[0]->ca_bucket->av_count == BUCKET_AVAIL)
	{
	  /* The avail is full, move the first one to newcache[1]->ca_bucket.*/
	  _gdbm_put_av_elem (dbf->bucket->bucket_avail[0],
			     newcache[1]->ca_bucket->bucket_avail,
			     &newcache[1]->ca_bucket->av_count, 
                             dbf->coalesce_blocks);
	  index = 1;
	  newcache[0]->ca_bucket->av_count--;
	}

      index1 = 0;
      for (; index < dbf->bucket->av_count; index++)
	{
	  newcache[0]->ca_bucket->bucket_avail[index1++]
	    = dbf->bucket->bucket_avail[index];
	}
      
      /* Update the directory.  We have new file addresses for both buckets. */
      dir_start1 = (dbf->bucket_dir >> (dbf->header->dir_bits - new_bits)) | 1;
      dir_end = (dir_start1 + 1) << (dbf->header->dir_bits - new_bits);
      dir_start1 = dir_start1 << (dbf->header->dir_bits - new_bits);
      dir_start0 = dir_start1 - (dir_end - dir_start1);
      for (index = dir_start0; index < dir_start1; index++)
	dbf->dir[index] = adr_0;
      for (index = dir_start1; index < dir_end; index++)
	dbf->dir[index] = adr_1;
      
      /* Set changed flags. */
      newcache[0]->ca_changed = TRUE;
      newcache[1]->ca_changed = TRUE;
      dbf->directory_changed = TRUE;
      
      /* Update the cache! */
      dbf->bucket_dir = _gdbm_bucket_dir (dbf, next_insert);
      
      /* Invalidate old cache entry. */
      avail_elem_init (&old_bucket,
		       dbf->header->bucket_size,
		       dbf->cache_mru->ca_adr);
      cache_elem_free (dbf, dbf->cache_mru);
      
      /* Set dbf->bucket to the proper bucket. */
      if (dbf->dir[dbf->bucket_dir] != adr_0)
	{
	  cache_elem *t = newcache[0];
	  newcache[0] = newcache[1];
	  newcache[1] = t;
	}

      _gdbm_put_av_elem (old_bucket,
			 newcache[1]->ca_bucket->bucket_avail,
			 &newcache[1]->ca_bucket->av_count, 
			 dbf->coalesce_blocks);

      lru_unlink_elem (dbf, newcache[0]);
      lru_link_elem (dbf, newcache[0], NULL);
    }

  /* Get rid of old directories. */
  for (index = 0; index < old_count; index++)
    if (_gdbm_free (dbf, old_adr[index], old_size[index]))
      return -1;

  return 0;
}


/* The only place where a bucket is written.  CA_ENTRY is the
   cache entry containing the bucket to be written. */

int
_gdbm_write_bucket (GDBM_FILE dbf, cache_elem *ca_entry)
{
  int rc;
  off_t file_pos;	/* The return value for lseek. */

  file_pos = gdbm_file_seek (dbf, ca_entry->ca_adr, SEEK_SET);
  if (file_pos != ca_entry->ca_adr)
    {
      GDBM_SET_ERRNO (dbf, GDBM_FILE_SEEK_ERROR, TRUE);
      _gdbm_fatal (dbf, _("lseek error"));
      return -1;
    }
  rc = _gdbm_full_write (dbf, ca_entry->ca_bucket, dbf->header->bucket_size);
  if (rc)
    {
      GDBM_DEBUG (GDBM_DEBUG_STORE|GDBM_DEBUG_ERR,
		  "%s: error writing bucket: %s",
		  dbf->name, gdbm_db_strerror (dbf));	  
      _gdbm_fatal (dbf, gdbm_strerror (rc));
      return -1;
    }

  ca_entry->ca_changed = FALSE;
  ca_entry->ca_data.hash_val = -1;
  ca_entry->ca_data.elem_loc = -1;
  return 0;
}

/* Cache manipulation interface functions. */

#define INIT_CACHE_BITS 9

/* Initialize the bucket cache. */
int
_gdbm_cache_init (GDBM_FILE dbf, size_t size)
{
  int bits;
  int cache_auto;
  
  if (size == GDBM_CACHE_AUTO)
    {
      cache_auto = TRUE;
      bits = dbf->cache ? dbf->cache_bits : INIT_CACHE_BITS;
    }
  else if (size > SIZE_T_MAX / sizeof (dbf->cache[0]))
    {
      GDBM_SET_ERRNO (dbf, GDBM_OPT_BADVAL, FALSE);
      return -1;
    }
  else
    {
      cache_auto = FALSE;
      bits = log2i (size < 4 ? 4 : size);
    }

  dbf->cache_auto = cache_auto;

  return cache_tab_resize (dbf, bits);
}

/* Free the bucket cache */
void
_gdbm_cache_free (GDBM_FILE dbf)
{
  cache_elem *elem;

  while (dbf->cache_lru)
    cache_elem_free (dbf, dbf->cache_lru);
  free (dbf->cache);
  dbf->cache = NULL;
  while ((elem = dbf->cache_avail) != NULL)
    {
      dbf->cache_avail = elem->ca_next;
      free (elem->ca_data.dptr);
      free (elem);
    }
}

/*
 * Flush cache content to disk.
 * All cache elements with the changed buckets form a contiguous sequence
 * at the head of the cache list (starting with cache_mru).
 */
int
_gdbm_cache_flush (GDBM_FILE dbf)
{
  cache_elem *elem;
  for (elem = dbf->cache_mru; elem && elem->ca_changed; elem = elem->ca_next)
    {
      if (_gdbm_write_bucket (dbf, elem))
	return -1;
    }
  return 0;
}


void
gdbm_get_cache_stats (GDBM_FILE dbf,
		      size_t *access_count,
		      size_t *cache_hits,
		      size_t *cache_count,
		      struct gdbm_cache_stat *bstat,
		      size_t nstat)
{
  if (access_count)
    *access_count = dbf->cache_access_count;
  if (cache_hits)
    *cache_hits = dbf->cache_hits;
  if (cache_count)
    *cache_count = dbf->cache_num;
  if (bstat)
    {
      size_t i;
      cache_elem *elem;

      if (nstat > dbf->cache_num)
	nstat = dbf->cache_num;
      
      for (i = 0, elem = dbf->cache_mru; i < nstat; i++, elem = elem->ca_next)
	{
	  bstat[i].adr = elem->ca_adr;
	  bstat[i].hits = elem->ca_hits;
	}
    }
}
