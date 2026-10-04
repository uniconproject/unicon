/*
 * autoconf.h -- build configuration for the vendored GDBM.
 *
 * Every upstream GDBM source file includes "autoconf.h" before anything
 * else.  Upstream generates it with GDBM's own configure script, which
 * Unicon does not run.  Instead, this file maps the results of Unicon's
 * configure (auto.h) onto the names the GDBM sources expect, so that the
 * upstream .c/.h files can be dropped in unmodified.
 *
 * When updating GDBM, compare against autoconf.h.in in the new release.
 */

#ifndef UNICON_GDBM_AUTOCONF_H
#define UNICON_GDBM_AUTOCONF_H

#include "auto.h"

/*
 * auto.h describes the Unicon package; GDBM uses the same macro names
 * for its own identity (version.c embeds PACKAGE_VERSION in gdbm_version).
 */
#undef PACKAGE
#undef PACKAGE_BUGREPORT
#undef PACKAGE_NAME
#undef PACKAGE_STRING
#undef PACKAGE_TARNAME
#undef PACKAGE_URL
#undef PACKAGE_VERSION
#undef VERSION

#define PACKAGE           "gdbm"
#define PACKAGE_BUGREPORT "bug-gdbm@gnu.org"
#define PACKAGE_NAME      "GNU dbm"
#define PACKAGE_TARNAME   "gdbm"
#define PACKAGE_URL       "http://www.gnu.org/software/gdbm/"
#define PACKAGE_VERSION   "1.26"
#define PACKAGE_STRING    PACKAGE_NAME " " PACKAGE_VERSION
#define VERSION           PACKAGE_VERSION

/* Unicon does not build GDBM's message catalogs. */
#undef ENABLE_NLS

/*
 * gdbm_errno is per-thread upstream when the compiler supports it;
 * keep it that way since Unicon programs may be multi-threaded.
 */
#ifndef GDBM_THREAD_LOCAL
#if defined(__GNUC__) || defined(__clang__)
#define GDBM_THREAD_LOCAL __thread
#elif defined(__STDC_VERSION__) && __STDC_VERSION__ >= 201112L
#define GDBM_THREAD_LOCAL _Thread_local
#else
#define GDBM_THREAD_LOCAL
#endif
#endif

#ifdef _WIN32
#include "w32compat.h"
#endif

/*
 * Optional upstream features that are not enabled in Unicon's build:
 * GDBM_FAILURE_ATOMIC (crash tolerance, Linux reflink-only) and
 * HAVE_TIMER_SETTIME (lock-wait timeouts fall back to setitimer).
 */

#endif                                  /* UNICON_GDBM_AUTOCONF_H */
