/* proto.h - The prototypes for the dbm routines. */

/*  This file is part of GDBM, the GNU data base manager, by Philip A. Nelson.
    Copyright (C) 1990, 1991, 1993  Free Software Foundation, Inc.

    GDBM is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2, or (at your option)
    any later version.

    GDBM is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with GDBM; see the file COPYING.  If not, write to
    the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

    You may contact the author by:
       e-mail:  phil@cs.wwu.edu
      us-mail:  Philip A. Nelson
                Computer Science Department
                Western Washington University
                Bellingham, WA 98226

*************************************************************************/


/* Define our _PROTOTYPE macro. */

#ifdef _ARGS
#undef _ARGS
#endif

#ifdef __STDC__
#define _ARGS(args) args
#else
#define _ARGS(args) ()
#endif


/* From bucket.c */
void _gdbm_new_bucket    _ARGS((gdbm_file_info *dbf, hash_bucket *bucket,
                                int bits ));
void _gdbm_get_bucket    _ARGS((gdbm_file_info *dbf, word_t dir_index ));
void _gdbm_split_bucket  _ARGS((gdbm_file_info *dbf, word_t next_insert ));
void _gdbm_write_bucket  _ARGS((gdbm_file_info *dbf, cache_elem *ca_entry ));

/* From falloc.c */
off_t _gdbm_alloc       _ARGS((gdbm_file_info *dbf, int num_bytes ));
void _gdbm_free         _ARGS((gdbm_file_info *dbf, off_t file_adr,
                               int num_bytes ));
int  _gdbm_put_av_elem  _ARGS((avail_elem new_el, avail_elem av_table [],
                               int *av_count ));

/* From findkey.c */
char *_gdbm_read_entry  _ARGS((gdbm_file_info *dbf, int elem_loc));
int _gdbm_findkey       _ARGS((gdbm_file_info *dbf, datum key,  char **dptr,
                               word_t *new_hash_val));

/* From hash.c */
word_t _gdbm_hash _ARGS((datum key ));

/* From update.c */
void _gdbm_end_update   _ARGS((gdbm_file_info *dbf ));
int _gdbm_fatal         _ARGS((gdbm_file_info *dbf, char *val ));

/* From gdbmopen.c */
int _gdbm_init_cache    _ARGS((gdbm_file_info *dbf, int size));

/* The user callable routines.... */
void  gdbm_close          _ARGS((gdbm_file_info *dbf ));
int   gdbm_delete         _ARGS((gdbm_file_info *dbf, datum key ));
datum gdbm_fetch          _ARGS((gdbm_file_info *dbf, datum key ));
gdbm_file_info *gdbm_open _ARGS((char *file, int block_size,
                                 int flags, int mode,
                                 void (*fatal_func) (void)));
int   gdbm_reorganize     _ARGS((gdbm_file_info *dbf ));
datum gdbm_firstkey       _ARGS((gdbm_file_info *dbf ));
datum gdbm_nextkey        _ARGS((gdbm_file_info *dbf, datum key ));
int   gdbm_store          _ARGS((gdbm_file_info *dbf, datum key,
                                 datum content, int flags ));
int   gdbm_exists         _ARGS((gdbm_file_info *dbf, datum key));
void  gdbm_sync           _ARGS((gdbm_file_info *dbf));
int   gdbm_setopt         _ARGS((gdbm_file_info *dbf, int optflag,
                                 int *optval, int optlen));
