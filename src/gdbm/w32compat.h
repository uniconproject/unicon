/*
 * w32compat.h -- POSIX bits the GDBM sources need on native Windows.
 *
 * Upstream GDBM targets POSIX systems only.  This header, included from
 * autoconf.h on _WIN32, fills the gaps for the MinGW build so the upstream
 * sources can stay unmodified.  The Makefile also leaves out the files
 * that cannot work here (lock.c, which w32compat.c replaces, and the
 * dump/load/import/export utilities), none of which Unicon uses.
 */

#ifndef UNICON_GDBM_W32COMPAT_H
#define UNICON_GDBM_W32COMPAT_H

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <io.h>
#include <unistd.h>

/*
 * Database files must be opened in binary mode: text mode would
 * translate CR/LF and stop reading at a ^Z byte.  The wrapper also maps
 * the POSIX null device, which the NDBM layer opens for read-only
 * databases that have no .dir file, to its Windows name.
 */
int gdbm_w32_open(const char *name, int flags, ...);
#define open gdbm_w32_open

/* _commit() is the Windows counterpart of fsync(). */
#undef  HAVE_FSYNC
#define HAVE_FSYNC 1
#define fsync(fd) _commit(fd)

/* sysconf() is only used to ask for the page size. */
#ifndef _SC_PAGESIZE
#define _SC_PAGESIZE 1
#endif
long gdbm_w32_sysconf(int name);
#define sysconf gdbm_w32_sysconf

typedef long blksize_t;

/*
 * gdbm_recover() copies the owner and permissions of the original file
 * onto the rebuilt one; Windows has no POSIX ownership, so do nothing.
 */
#define fchown(fd, uid, gid) ((void)(fd), (void)(uid), (void)(gid), 0)
#define fchmod(fd, mode)     ((void)(fd), (void)(mode), 0)

#endif                                  /* UNICON_GDBM_W32COMPAT_H */
