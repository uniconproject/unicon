/* proto.h - The prototypes for the dbm routines. */

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


/* From bucket.c */
void _gdbm_new_bucket	(GDBM_FILE, hash_bucket *, int);
int _gdbm_get_bucket	(GDBM_FILE, int);

int _gdbm_split_bucket (GDBM_FILE, int);
int _gdbm_write_bucket (GDBM_FILE, cache_elem *);
int _gdbm_cache_init   (GDBM_FILE, size_t);
void _gdbm_cache_free  (GDBM_FILE dbf);
int _gdbm_cache_flush  (GDBM_FILE dbf);

/* Mark current bucket as changed. */
static inline void
_gdbm_current_bucket_changed (GDBM_FILE dbf)
{
  dbf->cache_mru->ca_changed = TRUE;
}

/* Return true if the directory entry at DIR_INDEX can be considered
   valid. This means that DIR_INDEX is in the valid range for addressing
   the dir array, and the offset stored in dir[DIR_INDEX] points past
   first two blocks in file. This does not necessarily mean that there's
   a valid bucket or data block at that offset. All this implies is that
   it is safe to use the offset for look up in the bucket cache and to
   attempt to read a block at that offset. */
static inline int
gdbm_dir_entry_valid_p (GDBM_FILE dbf, int dir_index)
{
  return dir_index >= 0
         && dir_index < GDBM_DIR_COUNT (dbf)
         && dbf->dir[dir_index] >= dbf->header->block_size;
}


/* From falloc.c */
off_t _gdbm_alloc       (GDBM_FILE, int);
int  _gdbm_free         (GDBM_FILE, off_t, int);
void _gdbm_put_av_elem  (avail_elem, avail_elem [], int *, int);
int _gdbm_avail_block_read (GDBM_FILE dbf, avail_block *avblk, size_t size);

/* From findkey.c */
char *_gdbm_read_entry  (GDBM_FILE, int);
int _gdbm_findkey       (GDBM_FILE, datum, char **, int *);

/* From hash.c */
int _gdbm_hash (datum);
void _gdbm_hash_key (GDBM_FILE dbf, datum key, int *hash, int *bucket,
		     int *offset);
int _gdbm_bucket_dir (GDBM_FILE dbf, int hash);

/* From update.c */
int _gdbm_end_update   (GDBM_FILE);
void _gdbm_fatal	(GDBM_FILE, const char *);

/* From gdbmopen.c */
int _gdbm_validate_header (GDBM_FILE dbf);

int _gdbm_file_size (GDBM_FILE dbf, off_t *psize);

/* From gdbmload.c */
int _gdbm_str2fmt (char const *str);

/* From mmap.c */
int _gdbm_mapped_init	(GDBM_FILE);
void _gdbm_mapped_unmap	(GDBM_FILE);
ssize_t _gdbm_mapped_read	(GDBM_FILE, void *, size_t);
ssize_t _gdbm_mapped_write	(GDBM_FILE, void *, size_t);
off_t _gdbm_mapped_lseek	(GDBM_FILE, off_t, int);
int _gdbm_mapped_sync	(GDBM_FILE);

/* From lock.c */
void _gdbm_unlock_file	 (GDBM_FILE);
int _gdbm_lock_file	 (GDBM_FILE, int);
int _gdbm_lock_file_wait (GDBM_FILE, struct gdbm_open_spec const *);

/* From fullio.c */
int _gdbm_full_read (GDBM_FILE, void *, size_t);
int _gdbm_full_write (GDBM_FILE, void *, size_t);
int _gdbm_file_extend (GDBM_FILE dbf, off_t size);

/* From base64.c */
int _gdbm_base64_encode (const unsigned char *input, size_t input_len,
			 unsigned char **output, size_t *output_size,
			 size_t *outbytes);
int _gdbm_base64_decode (const unsigned char *input, size_t input_len,
			 unsigned char **output, size_t *output_size,
			 size_t *inbytes, size_t *outbytes);

int _gdbm_load (FILE *fp, GDBM_FILE *pdbf, unsigned long *line);
int _gdbm_dump (GDBM_FILE dbf, FILE *fp);

/* From recover.c */
int _gdbm_next_bucket_dir (GDBM_FILE dbf, int bucket_dir);


/* avail.c */
int gdbm_avail_block_validate (GDBM_FILE dbf, avail_block *avblk, size_t size);
int gdbm_bucket_avail_table_validate (GDBM_FILE dbf, hash_bucket *bucket);
int gdbm_avail_traverse (GDBM_FILE dbf,
			 int (*cb) (avail_block *, off_t, void *),
			 void *data);


/* I/O functions */
static inline ssize_t
gdbm_file_read (GDBM_FILE dbf, void *buf, size_t size)
{
#if HAVE_MMAP
  return _gdbm_mapped_read (dbf, buf, size);
#else
  return read (dbf->desc, buf, size);
#endif
}

static inline ssize_t
gdbm_file_write (GDBM_FILE dbf, void *buf, size_t size)
{
#if HAVE_MMAP
  return _gdbm_mapped_write (dbf, buf, size);
#else
  return write (dbf->desc, buf, size);
#endif
}

static inline off_t
gdbm_file_seek (GDBM_FILE dbf, off_t off, int whence)
{
#if HAVE_MMAP
  return _gdbm_mapped_lseek (dbf, off, whence);
#else
  return lseek (dbf->desc, off, whence);
#endif
}

/* From gdbmsync.c */
int gdbm_file_sync (GDBM_FILE dbf);
#ifdef GDBM_FAILURE_ATOMIC
extern int _gdbm_snapshot(GDBM_FILE);
#endif /* GDBM_FAILURE_ATOMIC */

static inline void
_gdbmsync_init (GDBM_FILE dbf)
{
#ifdef GDBM_FAILURE_ATOMIC
  dbf->snapfd[0] = dbf->snapfd[1] = -1;
  dbf->eo = 0;
#endif
}

static inline void
_gdbmsync_done (GDBM_FILE dbf)
{
#ifdef GDBM_FAILURE_ATOMIC
  if (dbf->snapfd[0] >= 0)
    close (dbf->snapfd[0]);
  if (dbf->snapfd[1] >= 0)
    close (dbf->snapfd[1]);
#endif
}

