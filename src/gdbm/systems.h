/* systems.h - Most of the system dependent code and defines are here. */

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

/* Include all system headers first. */
#include <sys/types.h>
#include <stdio.h>
#include <stddef.h>
#if HAVE_SYS_FILE_H
# include <sys/file.h>
#endif
#include <sys/stat.h>
#include <stdlib.h>
#if HAVE_STRING_H
# include <string.h>
#endif
#if HAVE_STRINGS_H
# include <strings.h>
#endif
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <limits.h>

#ifndef SEEK_SET
# define SEEK_SET        0
#endif

#ifndef O_CLOEXEC
# define O_CLOEXEC 0
#endif

/* Default block size.  Some systems do not have blocksize in their
   stat record. This code uses the BSD blocksize from stat. */

#if HAVE_STRUCT_STAT_ST_BLKSIZE
# define STATBLKSIZE(st) (st).st_blksize
#else
# define STATBLKSIZE(st) 1024
#endif

#if ! HAVE_STRUCT_STAT_ST_MTIM
# if HAVE_STRUCT_STAT_ST_MTIMESPEC
#   define st_mtim st_mtimespec
#   define HAVE_STRUCT_STAT_ST_MTIM 1
# endif
#endif

#ifndef STDERR_FILENO
# define STDERR_FILENO 2
#endif


